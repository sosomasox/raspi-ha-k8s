# アクティブ/スタンバイ冗長化構成ロードバランサの構築
## はじめに
[本アーキテクチャー](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/READMD.md#アーキテクチャー)において、**アクティブ/スタンバイ冗長化構成ロードバランサ** はアクティブ/アクティブ冗長化構成Kubernetesマスターノード群に対するクラスター操作のAPIリクエストを受け取り、各マスターノードのkube-apiserverに振り分ける役割を担っています。  


[本アーキテクチャーのネットワーク構成](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/READMD.md#ネットワーク構成)において、アクティブ/スタンバイ冗長化構成ロードバランサのIPアドレスとして仮想IPアドレスである **192.168.3.240/24** を割り当て、ポート番号9000番をリスニングポートとして設定することにしました。  
また、アクティブ/アクティブ冗長化構成Kubernetesマスターノード群のコンポーネントとして稼働する3台のマスターノードに対してはそれぞれ **192.168.3.251/24** と **192.168.3.252/24** 、**192.168.3.253/24** を割り当てることにしました。  


ここでは、ネットワーク構成をもとにアクティブ/スタンバイ冗長化構成ロードバランサの構築と動作検証を行っていきます。  

<img src="../images/redundant_load_balancers_and_redundant_kubernetes_master_nodes_on_network.png" width=100% alt="Redundant Load Balancers and Redundant Kubernetes Master Nodes on Network"><br>

まずは、ロードバランサ構築用スクリプトをダウンロードし、スクリプトに実行権限を与えていきます。  
下記のコマンドを実行して下さい。  

```
cd $HOME
git clone https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster.git
cd Build_HA_RasPi_K8s_Cluster/rlb/scripts && chmod +x *
```





## アクティブ/スタンバイ冗長化構成ロードバランサの構築方法
### Keepalived設定ファイルの作成
次に、**make_keepalived-conf.sh** スクリプトを使用して、Keepalivedを起動するための設定ファイルを作成していきます。  

```
./make_keepalived-conf.sh
Usage: ./make_keepalived-conf.sh VIRTUAL_IP_ADDRESS
```

スクリプトの引数としてアクティブ/スタンバイ冗長化構成ロードバランサで使用する仮想IPアドレスを指定し、スクリプトを **piユーザ権限** 実行します。  

```
./make_keepalived-conf.sh 192.168.3.240
```

設定ファイルが作成されると下記のようなメッセージが現れます。  

```
make keepalived.conf done.
```

Build_HA_RasPi_K8s_Cluster/rlb/config フォルダ直下に、下記の内容の **keepalived.conf** ファイルが作成されていることを確認します。  

```
vrrp_script chk_haproxy {
    script   "systemctl is-active haproxy"
    interval 1
    rise     2
    fall     3
}

vrrp_instance HA-CLUSTER {
    state BACKUP
    nopreempt
    interface eth0
    virtual_router_id 1
    priority 100
    advert_int 1
    virtual_ipaddress {
        192.168.3.240
    }
    track_script {
        chk_haproxy
    }
}
```

上記の設定ファイルの内容に関して少し説明しておきます。  

**vrrp_scriptセクション** にて、HAProxyに対するヘルスチェックの内容を定義しています。  
**scriptパラメータ** に対してヘルスチェックとして実施するコマンドである**"systemctl is-active haproxy"** を指定し、**intervalパラメータ** に対してはヘルスチェックの実施間隔を指定することでヘルスチェックを1秒間隔で実施するようにしています。  
また、ロードバランサに対するヘルスチェックが3回連続で失敗した場合には障害が発生したとみなし、一方で、障害が発生したロードバランサに対するヘルスチェックが2回連続で成功した場合にはロードバランサが復帰したとみなすように **fallパラメータ** と **riseパラメータ** に対する設定を行っています。  

**vrrp_instanceセクション** にて、**stateパラメータ** をBACKUP、**priorityパラメータ** を同じ値にすることで、Keepalivedを先に起動させたロードバランサをアクティブ状態、後に起動させたロードバランサをスタンバイ状態として稼働させるようにしています。  
また、**nopreemptパラメータ** を設定することで障害が発生したロードバランサが復帰した際、フェイルバックが行われないようにしています。  
**virtual_ipaddressブロック** では仮想IPアドレスを設定し、**track_scriptブロック** にてvrrp_scriptセクションで定義したヘルスチェックを実行するように設定しています。  

上記の設定により、HAProxyに対するヘルスチェックが失敗したり、Keepalivedに障害が発生した場合にフェイルオーバーを発生させることができるため、スタンバイ状態のロードバランサが仮想IPアドレスを引き継いだ上でアクティブ状態に遷移し、高可用性Kubernetesクラスターのロードバランサとしての機能を継続させることができます。  



### HAProxy設定ファイルの作成
次に、**make_haproxy-cfg.sh** スクリプトを使用して、HAProxyを起動するための設定ファイルを作成していきます。  

```
./make_haproxy-cfg.sh
Usage: ./make_haproxy-cfg.sh HAPROXY_PORT CONTROL_PLANES...
```

スクリプトの引数としてアクティブ/スタンバイ冗長化構成ロードバランサで使用するリスニングポート番号とアクティブ/アクティブ冗長化構成Kubernetesマスターノード群のコンポーネントとして稼働するマスターノードのIPアドレスを指定し、スクリプトを **piユーザ権限** 実行します。  

```
./make_haproxy-cfg.sh 9000 192.168.3.251 192.168.3.252 192.168.3.253
```

設定ファイルが作成されると下記のようなメッセージが現れます。  

```
make haproxy.cfg done.
```

Build_HA_RasPi_K8s_Cluster/rlb/config フォルダ直下に、下記の内容の **haproxy.cfg** ファイルが作成されていることを確認します。  

```
global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon
    ca-base /etc/ssl/certs
    crt-base /etc/ssl/private
    ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
    ssl-default-bind-options no-sslv3


defaults
    log global
    mode    http
    option  httplog
    option  dontlognull
    retries 10
    timeout connect 3000ms
    timeout client  3000ms
    timeout server  60000ms
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http


frontend kube-apiserver
    bind *:9000
    default_backend kube-apiserver
    mode tcp
    option tcplog
    log global


backend kube-apiserver
    mode tcp
    option tcp-check
    balance roundrobin
    option redispatch
    retries 3
    server control-plane1 192.168.3.251:6443 check inter 3000ms rise 30 fall 3
    server control-plane2 192.168.3.252:6443 check inter 3000ms rise 30 fall 3
    server control-plane3 192.168.3.253:6443 check inter 3000ms rise 30 fall 3
```

上記の設定ファイルの内容に関して少し説明しておきます。



### ロードバランサの構築
最後に、**build.sh** スクリプトを使用して、ロードバランサを構築していきます。  

```
sudo ./build.sh
Usage: ./build.sh HAPROXY_PORT
```

スクリプトの引数としてアクティブ/スタンバイ冗長化構成ロードバランサで使用するリスニングポート番号を指定し、スクリプトを **sudo権限** で実行します。

```
sudo ./build.sh 9000
```

ロードバランサの構築が完了すると下記のようなメッセージが現れます。  

```
build done.
```


**build.sh** スクリプトは、KeepalivedとHAProxyのパッケージをインストールし、
**iptables** コマンドを使用して、アクティブ/スタンバイ冗長化構成ロードバランサで利用するリスニングポートに対する受信パケットの流入を許可するように設定します。  
また、ロードバランサの再起動後にもリスニングポートを開放し続けるために **/etc/rc.local** ファイルに対する編集を行います。  
その後、[Keepalived設定ファイルの作成](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/rlb/READMD.md#Keepalived設定ファイルの作成)と
[HAProxy設定ファイルの作成](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/rlb/READMD.md#HAProxy設定ファイルの作成)で作成した設定ファイルを　
systemdの環境変数として設定されている各サービスのエントリポイントに設置し、KeepalivedとHAProxyを起動させることでロードバランサの構築を完了させます。  

_**\* bulid.shスクリプトの詳細に関しましては、[こちら](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/rlb/scripts/build.sh)を参照して下さい。**_



### アクティブ/スタンバイ冗長化構成ロードバランサの稼働
[同様の手順](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/rlb/READMD.md#アクティブ/スタンバイ冗長化構成ロードバランサの構築方法)をもう1台のロードバランサに対しても行うことで、**アクティブ/スタンバイ冗長化構成ロードバランサ** を稼働させることができます。  

もう1台のロードバランサに対しても[同様の手順](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/rlb/READMD.md#アクティブ/スタンバイ冗長化構成ロードバランサの構築方法)を行うことで、**アクティブ/スタンバイ冗長化構成ロードバランサ** を稼働させることができます。  

<img src="../images/redundant_load_balancers_on_network.png" width=100% alt="Redundant Load Balancers on Network"><br>




## アクティブ/スタンバイ冗長化構成ロードバランサの解体方法
アクティブ/スタンバイ冗長化構成ロードバランサの解体させるには、コンポーネントとして稼働するロードバランサに対して **unbulid.sh** を実行します。

```
sudo ./unbulid.sh
Usage: unbulid.sh HAPROXY_PORT
```

スクリプトの引数としてアクティブ/スタンバイ冗長化構成ロードバランサで使用しているリスニングポート番号を指定し、スクリプトを **sudo権限** で実行します。

```
sudo ./unbulid.sh
```

ロードバランサの解体が完了すると下記のようなメッセージが現れます

```
unbuild done.
```

_**\* unbulid.shスクリプトの詳細に関しましては、[こちら](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/rlb/scripts/unbuild.sh)を参照して下さい。**_  
_**なお、一度作成したKeepalivedの設定ファイルとHAProxyの設定をそのまま使用して再構築する場合には、もう一度 build.shスクリプトを実行します。**_  
_**新しい設定ファイルを使用して再構築する場合には、[Keepalived設定ファイルの作成](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/rlb/READMD.md#Keepalived設定ファイルの作成)と
[HAProxy設定ファイルの作成](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster/tree/master/rlb/READMD.md#HAProxy設定ファイルの作成)からやり直す必要があります。**_





## アクティブ/スタンバイ冗長化構成ロードバランサの動作検証
