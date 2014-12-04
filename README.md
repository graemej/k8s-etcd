# k8s-etcd

Docker container to run `etcd` (0.4.6) in an Ubuntu 14.04 container with configuration settings from the environment.

## environment

The names of these environment variables are carefully chosen for compatibility with what Kubernetes (primarily GKE) provides for defined services.

* `ETCD_SERVER_ID`: required, integer 1..cluster size
* for each etcd instance in the cluster
  * `ETCD_CLIENT_<i>_SERVICE_HOST`: IP address of the etcd instance  
  * `ETCD_CLIENT_<i>_SERVICE_PORT`: port number of the etcd client service (4001)
  * `ETCD_PEER_<i>_SERVICE_HOST`: IP address of the etcd instance  
  * `ETCD_PEER_<i>_SERVICE_PORT`: port number of the etcd client service
  
  
## notes

To start a two node cluster, run this to start the first node:

```
HOST_IP=$(ip ro get 8.8.8.8 | grep -oP "(?<=src )(\S+)")
docker run \
 -e ETCD_SERVER_ID=1 \
 -e ETCD_CLIENT_1_SERVICE_HOST=${HOST_IP} \
 -e ETCD_CLIENT_1_SERVICE_PORT=4001 \
 -e ETCD_PEER_1_SERVICE_HOST=${HOST_IP} \
 -e ETCD_PEER_1_SERVICE_PORT=7001 \
 -e ETCD_CLIENT_2_SERVICE_HOST=${HOST_IP} \
 -e ETCD_CLIENT_2_SERVICE_PORT=4002 \
 -e ETCD_PEER_2_SERVICE_HOST=${HOST_IP} \
 -e ETCD_PEER_2_SERVICE_PORT=7002 \
 -e ETCD_PEERS="" \
 graemej/k8s-etcd
```

and this to start the second one:

```
docker run \
 -e ETCD_SERVER_ID=2 \
 -e ETCD_CLIENT_1_SERVICE_HOST=${HOST_IP} \
 -e ETCD_CLIENT_1_SERVICE_PORT=4001 \
 -e ETCD_PEER_1_SERVICE_HOST=${HOST_IP} \
 -e ETCD_PEER_1_SERVICE_PORT=7001 \
 -e ETCD_CLIENT_2_SERVICE_HOST=${HOST_IP} \
 -e ETCD_CLIENT_2_SERVICE_PORT=4002 \
 -e ETCD_PEER_2_SERVICE_HOST=${HOST_IP} \
 -e ETCD_PEER_2_SERVICE_PORT=7002 \
 graemej/k8s-etcd 
```
