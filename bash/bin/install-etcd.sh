#!/usr/bin/env bash

run_etcd_docker() {
rm -rf /tmp/etcd-data.tmp && mkdir -p /tmp/etcd-data.tmp && \
  docker rmi gcr.io/etcd-development/etcd:v3.4.15 || true && \
  docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data \
  --name etcd-gcr-v3.4.15 \
  gcr.io/etcd-development/etcd:v3.4.15 \
  /usr/local/bin/etcd \
  --name s1 \
  --data-dir /etcd-data \
  --listen-client-urls http://0.0.0.0:2379 \
  --advertise-client-urls http://0.0.0.0:2379 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --initial-advertise-peer-urls http://0.0.0.0:2380 \
  --initial-cluster s1=http://0.0.0.0:2380 \
  --initial-cluster-token tkn \
  --initial-cluster-state new \
  --log-level info \
  --logger zap \
  --log-outputs stderr
}

test_etcd_docker() {
docker exec etcd-gcr-v3.4.15 /bin/sh -c "/usr/local/bin/etcd --version"
docker exec etcd-gcr-v3.4.15 /bin/sh -c "/usr/local/bin/etcdctl version"
docker exec etcd-gcr-v3.4.15 /bin/sh -c "/usr/local/bin/etcdctl endpoint health"
docker exec etcd-gcr-v3.4.15 /bin/sh -c "/usr/local/bin/etcdctl put foo bar"
docker exec etcd-gcr-v3.4.15 /bin/sh -c "/usr/local/bin/etcdctl get foo"
}

run_rqlite_docker() {
  docker run -v /rqlite_data:/rqlite/file/data -p 4001:4001 -p 4002:4002 rqlite/rqlite
}

install_rqlite() {
  wget https://github.com/rqlite/rqlite/releases/download/v5.10.2/rqlite-v5.10.2-linux-amd64.tar.gz
  tar xvf rqlite-v5.10.2-linux-amd64.tar.gz
  mv rqlite-v5.10.2-linux-amd64/* /usr/local/bin/
  rm xvf rqlite-v5.10.2-linux-amd64.tar.gz
  rm -rf xvf rqlite-v5.10.2-linux-amd64
}
