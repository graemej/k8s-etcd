#!/bin/bash

function getKey() {
  echo $1 | cut -d "=" -f1
}

function getValue() {
  echo $1 | cut -d "=" -f2
}

function envValue() {
 local entry=`env | grep $1`
 echo `getValue $entry`
}

set -ex
PEERS=""

#Find the server id
SERVER_ID=`envValue ETCD_SERVER_ID`
if [ ! -z "$SERVER_ID" ] ; then

  #Find the servers exposed in env.
  for i in `echo {1..15}`; do
    CLIENT_HOST=`envValue ETCD_CLIENT_${i}_SERVICE_HOST`
    CLIENT_PORT=`envValue ETCD_CLIENT_${i}_SERVICE_PORT`
    PEER_HOST=`envValue ETCD_PEER_${i}_SERVICE_HOST`
    PEER_PORT=`envValue ETCD_PEER_${i}_SERVICE_PORT`

    if [ "$SERVER_ID" = "$i" ] ; then
      export ETCD_ADDR="${CLIENT_HOST}:${CLIENT_PORT}"
      export ETCD_PEER_ADDR="${PEER_HOST}:${PEER_PORT}"
    elif [ -z "$PEER_HOST" ] || [ -z "$PEER_PORT" ] || [ -z "$CLIENT_HOST" ] || [ -z "$CLIENT_PORT" ] ; then
      break
    else
      if [ ! -z $PEERS ] ; then
        PEERS="${PEERS},"
      fi
      PEERS="${PEERS}${PEER_HOST}:${PEER_PORT}"
    fi

  done
fi

if [ -z "$ETCD_NAME" ] ; then
  export ETCD_NAME="etcd${SERVER_ID}"
  echo "Set ETCD_NAME=${ETCD_NAME}"
fi

if [ ! -v "ETCD_PEERS" ] ; then
  export ETCD_PEERS="${PEERS}"
  echo "Set ETCD_PEERS=${ETCD_PEERS}"
fi

exec /opt/etcd/bin/etcd