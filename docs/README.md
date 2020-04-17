# コントロールプレーンによるクラスターへの参加時にエラーが発生した場合の対処方法
これは、[コントロールプレーンによるクラスターへの参加](https://github.com/izewfktvy533zjmn/Build_HA_RasPi_K8s_Cluster#コントロールプレーンによるクラスターへの参加)実施時に発生したエラーへの対処方法をまとめたものです。  



## エラー1：ConfigMap kubeadm-configの取得に失敗する
joinコマンド実行後、下記のようなメッセージが現れました。  

```
pi@makina-master3:~ $ sudo kubeadm join 192.168.3.240:9000 --token o5g8v9.mwqkevubeq8u66wu --discovery-token-ca-cert-hash sha256:d37194065c68d4f8e76e8bddc928f94c7923520be0189f391eb7d79fc5f27973 --experimental-control-plane
[preflight] Running pre-flight checks
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[discovery] Trying to connect to API Server "192.168.3.240:9000"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.3.240:9000"
[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
[discovery] Requesting info from "https://192.168.3.240:9000" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.3.240:9000"
[discovery] Successfully established connection with API Server "192.168.3.240:9000"
[join] Reading configuration from the cluster...
[join] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[join] Running pre-flight checks before initializing the new control plane instance
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [makina-master3 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.3.253 192.168.3.240 192.168.3.240]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [makina-master3 localhost] and IPs [192.168.3.253 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [makina-master3 localhost] and IPs [192.168.3.253 127.0.0.1 ::1]
[certs] valid certificates and keys now exist in "/etc/kubernetes/pki"
[certs] Using the existing "sa" key
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/admin.conf"
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Checking etcd cluster health
Get https://192.168.3.240:9000/api/v1/namespaces/kube-system/configmaps/kubeadm-config: unexpected EOF
```



## エラー1への対処方法
joinコマンドに**"--ignore-preflight-errors=DirAvailable--etc-kubernetes-manifests"** を追加してもう一度実行します。  



## エラー2：ConfigMap kubeadm-config-X.XXの取得に失敗する
joinコマンド実行後、下記のようなメッセージが現れました。  

```
pi@makina-master3:~ $ sudo kubeadm join 192.168.3.240:9000 --token 2vfjp7.augovzk2eb5o22sa --discovery-token-ca-cert-hash sha256:30d7499f02e8860d7ed370f87b9d25638c34dec234482c1366070d64fa13833e --experimental-control-plane
[preflight] Running pre-flight checks
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[discovery] Trying to connect to API Server "192.168.3.240:9000"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.3.240:9000"
[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
^[[A^[[A[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
[discovery] Failed to request cluster info, will try again: [Get https://192.168.3.240:9000/api/v1/namespaces/kube-public/configmaps/cluster-info: unexpected EOF]
[discovery] Requesting info from "https://192.168.3.240:9000" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.3.240:9000"
[discovery] Successfully established connection with API Server "192.168.3.240:9000"
[join] Reading configuration from the cluster...
[join] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[join] Running pre-flight checks before initializing the new control plane instance
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [makina-master3 localhost] and IPs [192.168.3.253 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [makina-master3 localhost] and IPs [192.168.3.253 127.0.0.1 ::1]
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [makina-master3 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.3.253 192.168.3.240 192.168.3.240]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] valid certificates and keys now exist in "/etc/kubernetes/pki"
[certs] Using the existing "sa" key
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/admin.conf"
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Checking etcd cluster health
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.13" ConfigMap in the kube-system namespace
Get https://192.168.3.240:9000/api/v1/namespaces/kube-system/configmaps/kubelet-config-1.13: unexpected EOF
```



## エラー2への対処方法
下記のコマンドを実行します。  

```
sudo rm -rf /etc/kubernetes/bootstrap-kubelet.conf
suod rm -rf /etc/kubernetes/kubelet.conf
```

その後、joinコマンドに**"--ignore-preflight-errors=DirAvailable--etc-kubernetes-manifests"** を追加してもう一度実行します。



## エラー3：error uploading crisocket
joinコマンド実行後、下記のようなメッセージが現れました。  

```
pi@makina-master3:~/Build_HA_RasPi_K8s_Cluster $ sudo kubeadm join 192.168.3.240:9000 --token lbeqhh.45h59a1g7a0con9c --discovery-token-ca-cert-hash sha256:55a07d3b3c3495253c6b67bc8083e5986c228a07b01381582df0b8f0a1a818f0 --experimental-control-plane --ignore-preflight-errors=DirAvailable--etc-kubernetes-manifests
[preflight] Running pre-flight checks
	[WARNING DirAvailable--etc-kubernetes-manifests]: /etc/kubernetes/manifests is not empty
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[discovery] Trying to connect to API Server "192.168.3.240:9000"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.3.240:9000"
[discovery] Requesting info from "https://192.168.3.240:9000" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.3.240:9000"
[discovery] Successfully established connection with API Server "192.168.3.240:9000"
[join] Reading configuration from the cluster...
[join] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[join] Running pre-flight checks before initializing the new control plane instance
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[certs] Using the existing "apiserver" certificate and key
[certs] Using the existing "apiserver-kubelet-client" certificate and key
[certs] Using the existing "front-proxy-client" certificate and key
[certs] Using the existing "etcd/server" certificate and key
[certs] Using the existing "etcd/peer" certificate and key
[certs] Using the existing "etcd/healthcheck-client" certificate and key
[certs] Using the existing "apiserver-etcd-client" certificate and key
[certs] valid certificates and keys now exist in "/etc/kubernetes/pki"
[certs] Using the existing "sa" key
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/admin.conf"
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/controller-manager.conf"
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/scheduler.conf"
[etcd] Checking etcd cluster health
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.13" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "makina-master3" as an annotation
error uploading crisocket: error patching node "makina-master3" through apiserver: Patch https://192.168.3.240:9000/api/v1/nodes/makina-master3: unexpected EOF
```



## エラー3への対処方法
下記のコマンドを実行し、etcdのPodが起動していることを確認します。  

```
rm -rf .kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl -n kube-system get pods -o wide
```

対象のマスターノード上にて、etcdのPodが起動していない場合、起動するまで待って下さい。  
etcdのPod起動が確認できたら、下記のコマンドを実行して下さい。   

```
sudo kubeadm init phase upload-config kubeadm --config=$HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
kubectl label node `hostname` node-role.kubernetes.io/master=''
kubectl taint node `hostname` node-role.kubernetes.io/master=:NoSchedule
```



## エラー4：etcdのPod作成に対するタイムアウト
joinコマンド実行後、下記のようなメッセージが現れました。  

```
pi@makina-master3:~ $ sudo kubeadm join 192.168.3.240:9000 --token o5g8v9.mwqkevubeq8u66wu --discovery-token-ca-cert-hash sha256:d37194065c68d4f8e76e8bddc928f94c7923520be0189f391eb7d79fc5f27973 --experimental-control-plane --ignore-preflight-errors=DirAvailable--etc-kubernetes-manifests
[preflight] Running pre-flight checks
	[WARNING DirAvailable--etc-kubernetes-manifests]: /etc/kubernetes/manifests is not empty
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[discovery] Trying to connect to API Server "192.168.3.240:9000"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.3.240:9000"
[discovery] Requesting info from "https://192.168.3.240:9000" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.3.240:9000"
[discovery] Successfully established connection with API Server "192.168.3.240:9000"
[join] Reading configuration from the cluster...
[join] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[join] Running pre-flight checks before initializing the new control plane instance
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[certs] Using the existing "apiserver" certificate and key
[certs] Using the existing "apiserver-kubelet-client" certificate and key
[certs] Using the existing "etcd/peer" certificate and key
[certs] Using the existing "etcd/server" certificate and key
[certs] Using the existing "etcd/healthcheck-client" certificate and key
[certs] Using the existing "apiserver-etcd-client" certificate and key
[certs] Using the existing "front-proxy-client" certificate and key
[certs] valid certificates and keys now exist in "/etc/kubernetes/pki"
[certs] Using the existing "sa" key
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/admin.conf"
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/controller-manager.conf"
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/scheduler.conf"
[etcd] Checking etcd cluster health
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.13" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "makina-master3" as an annotation
[etcd] Announced new etcd member joining to the existing etcd cluster
[etcd] Wrote Static Pod manifest for a local etcd member to "/etc/kubernetes/manifests/etcd.yaml"
[etcd] Waiting for the new etcd member to join the cluster. This can take up to 40s
[util/etcd] Waiting 0s for initial delay
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[kubelet-check] Initial timeout of 40s passed.
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
error creating local etcd static pod manifest file: timeout waiting for etcd cluster to be available
```



## エラー4への対処方法
下記のコマンドを実行し、etcdのPodが起動していることを確認します。   

```
rm -rf .kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl -n kube-system get pods -o wide
```

対象のマスターノード上にて、etcdのPodが起動していない場合、起動するまで待って下さい。  
etcdのPod起動が確認できたら、下記のコマンドを実行して下さい。  

```
sudo kubeadm init phase upload-config kubeadm --config=$HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
kubectl label node `hostname` node-role.kubernetes.io/master=''
kubectl taint node `hostname` node-role.kubernetes.io/master=:NoSchedule
```



## エラー5：etcdのPod起動後、ConfigMap kubeadm-configの取得に失敗する
joinコマンド実行後、下記のようなメッセージが現れました。  

```
pi@makina-master2:~ $ sudo kubeadm join 192.168.3.240:9000 --token 2aesuu.4kti53z4kakh359l --discovery-token-ca-cert-hash sha256:63954e56a4f12c43779a6e16fb0b1a9468d983982548b81f593cbb1d79c56948 --experimental-control-plane
[preflight] Running pre-flight checks
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[discovery] Trying to connect to API Server "192.168.3.240:9000"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.3.240:9000"
[discovery] Requesting info from "https://192.168.3.240:9000" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.3.240:9000"
[discovery] Successfully established connection with API Server "192.168.3.240:9000"
[join] Reading configuration from the cluster...
[join] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[join] Running pre-flight checks before initializing the new control plane instance
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [makina-master2 localhost] and IPs [192.168.3.252 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [makina-master2 localhost] and IPs [192.168.3.252 127.0.0.1 ::1]
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [makina-master2 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.3.252 192.168.3.240 192.168.3.240]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] valid certificates and keys now exist in "/etc/kubernetes/pki"
[certs] Using the existing "sa" key
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/admin.conf"
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Checking etcd cluster health
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.13" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "makina-master2" as an annotation
[etcd] Announced new etcd member joining to the existing etcd cluster
[etcd] Wrote Static Pod manifest for a local etcd member to "/etc/kubernetes/manifests/etcd.yaml"
[etcd] Waiting for the new etcd member to join the cluster. This can take up to 40s
[util/etcd] Waiting 0s for initial delay
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[kubelet-check] Initial timeout of 40s passed.
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
error uploading configuration: Get https://192.168.3.240:9000/api/v1/namespaces/kube-system/configmaps/kubeadm-config: unexpected EOF
```


## エラー5への対処方法
下記のコマンドを実行し、etcdのPodが起動していることを確認します。   

```
rm -rf .kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl -n kube-system get pods -o wide
```

対象のマスターノード上にて、etcdのPodが起動していない場合、起動するまで待って下さい。  
etcdのPod起動が確認できたら、下記のコマンドを実行して下さい。  

```
sudo kubeadm init phase upload-config kubeadm --config=$HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
kubectl label node `hostname` node-role.kubernetes.io/master=''
kubectl taint node `hostname` node-role.kubernetes.io/master=:NoSchedule
```



## エラー6：etcdのPod起動後、ConfigMapの作成に失敗する
joinコマンド実行後、下記のようなメッセージが現れました。  

```
pi@makina-master2:~ $ sudo kubeadm join 192.168.3.240:9000 --token c4xmd2.zjodd1afdkqfdu7x --discovery-token-ca-cert-hash sha256:09fe91258373dcefcbc678fb319d3fd18a56609fcdf60114d28f3aa4fa60ef8e --experimental-control-plane
[preflight] Running pre-flight checks
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[discovery] Trying to connect to API Server "192.168.3.240:9000"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.3.240:9000"
[discovery] Requesting info from "https://192.168.3.240:9000" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.3.240:9000"
[discovery] Successfully established connection with API Server "192.168.3.240:9000"
[join] Reading configuration from the cluster...
[join] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[join] Running pre-flight checks before initializing the new control plane instance
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [makina-master2 localhost] and IPs [192.168.3.252 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [makina-master2 localhost] and IPs [192.168.3.252 127.0.0.1 ::1]
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [makina-master2 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.3.252 192.168.3.240 192.168.3.240]
[certs] Generating "front-proxy-client" certificate and key
[certs] valid certificates and keys now exist in "/etc/kubernetes/pki"
[certs] Using the existing "sa" key
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/admin.conf"
[kubeconfig] Writing "controller-manager.conf" kubeconfig fil
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Checking etcd cluster health
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.13" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "makina-master2" as an annotation
[etcd] Announced new etcd member joining to the existing etcd cluster
[etcd] Wrote Static Pod manifest for a local etcd member to "/etc/kubernetes/manifests/etcd.yaml"
[etcd] Waiting for the new etcd member to join the cluster. This can take up to 40s
[util/etcd] Waiting 0s for initial delay
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[kubelet-check] Initial timeout of 40s passed.
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
error uploading configuration: unable to create configmap: Post https://192.168.3.240:9000/api/v1/namespaces/kube-system/configmaps: unexpected EOF
```




## エラー6への対処方法
下記のコマンドを実行し、etcdのPodが起動していることを確認します。   

```
rm -rf .kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl -n kube-system get pods -o wide
```

対象のマスターノード上にて、etcdのPodが起動していない場合、起動するまで待って下さい。  
etcdのPod起動が確認できたら、下記のコマンドを実行して下さい。   

```
sudo kubeadm init phase upload-config kubeadm --config=$HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
kubectl label node `hostname` node-role.kubernetes.io/master=''
kubectl taint node `hostname` node-role.kubernetes.io/master=:NoSchedule
```



## エラー7：RBACのRoleBindingリソースの作成に失敗する
joinコマンド実行後、下記のようなメッセージが現れました。  

```
pi@makina-master2:~/Build_HA_RasPi_K8s_Cluster $ sudo kubeadm join 192.168.3.240:9000 --token lbeqhh.45h59a1g7a0con9c --discovery-token-ca-cert-hash sha256:55a07d3b3c3495253c6b67bc8083e5986c228a07b01381582df0b8f0a1a818f0 --experimental-control-plane
[preflight] Running pre-flight checks
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[discovery] Trying to connect to API Server "192.168.3.240:9000"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.3.240:9000"
[discovery] Requesting info from "https://192.168.3.240:9000" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.3.240:9000"
[discovery] Successfully established connection with API Server "192.168.3.240:9000"
[join] Reading configuration from the cluster...
[join] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[join] Running pre-flight checks before initializing the new control plane instance
	[WARNING SystemVerification]: this Docker version is not on the list of validated versions: 19.03.8. Latest validated version: 18.06
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [makina-master2 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.3.252 192.168.3.240 192.168.3.240]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [makina-master2 localhost] and IPs [192.168.3.252 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [makina-master2 localhost] and IPs [192.168.3.252 127.0.0.1 ::1]
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] valid certificates and keys now exist in "/etc/kubernetes/pki"
[certs] Using the existing "sa" key
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Using existing up-to-date kubeconfig file: "/etc/kubernetes/admin.conf"
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Checking etcd cluster health
[kubelet] Downloading configuration for the kubelet from the "kubelet-config-1.13" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Activating the kubelet service
[tlsbootstrap] Waiting for the kubelet to perform the TLS Bootstrap...
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "makina-master2" as an annotation
[etcd] Announced new etcd member joining to the existing etcd cluster
[etcd] Wrote Static Pod manifest for a local etcd member to "/etc/kubernetes/manifests/etcd.yaml"
[etcd] Waiting for the new etcd member to join the cluster. This can take up to 40s
[util/etcd] Waiting 0s for initial delay
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[kubelet-check] Initial timeout of 40s passed.
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[util/etcd] Attempt timed out
[util/etcd] Waiting 5s until next retry
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
error uploading configuration: unable to create RBAC rolebinding: Post https://192.168.3.240:9000/apis/rbac.authorization.k8s.io/v1/namespaces/kube-system/rolebindings: unexpected EOF
```



## エラー7への対処方法
下記のコマンドを実行し、etcdのPodが起動していることを確認します。   

```
rm -rf .kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl -n kube-system get pods -o wide
```

対象のマスターノード上にて、etcdのPodが起動していない場合、起動するまで待って下さい。  
etcdのPod起動が確認できたら、下記のコマンドを実行して下さい。  

```
sudo kubeadm init phase upload-config kubeadm --config=$HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
kubectl label node `hostname` node-role.kubernetes.io/master=''
kubectl taint node `hostname` node-role.kubernetes.io/master=:NoSchedule
```
