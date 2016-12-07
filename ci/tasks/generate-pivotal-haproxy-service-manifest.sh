#!/bin/bash

CERTFILE=certblob.cert
CERTS_PREFIX=haproxy-cert-

echo "setting permissions on omg-cli..."
chmod +x omg-cli/omg-linux
if [[ $? -ne 0 ]]; then 
  cleanfail "couldnt chmod omg-cli"
fi

echo "breaking up cert blob into individual files..."
echo "$HAPROXY_CERTS_BLOB" > ${CERTFILE}
csplit -f ${CERTS_PREFIX} ${CERTFILE} '/^-----BEGIN CERTIFICATE-----/' '{1}' \
  && export OMG_CERT_FILEPATH=$(ls -mx ${CERTS_PREFIX}* | sed 's/ //g') \
  && rm -f ${CERTFILE}

if [[ $? -ne 0 ]]; then 
  cleanfail "couldnt create your certs from blob"
fi
echo "using certs from files: $OMG_CERT_FILEPATH" 
echo "registering plugin..."
omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath haproxy-plugin/$PRODUCT_PLUGIN


if [[ $? -ne 0 ]]; then 
  cleanfail "couldnt register your plugin"
fi

echo "generating deployment manifest..."
omg-cli/omg-linux deploy-product \
  --bosh-url $BOSH_URL \
  --bosh-port $BOSH_PORT \
  --bosh-user $BOSH_CLIENT \
  --bosh-pass $BOSH_CLIENT_SECRET \
  --print-manifest \
  --ssl-ignore \
  $PRODUCT_PLUGIN \
  --deployment-name $DEPLOYMENT_NAME \
  --stemcell-ver $STEMCELL_VERSION > manifest/deployment.yml

if [[ $? -ne 0 ]]; then 
  cleanfail "couldnt generate your manifest"
fi
echo "completed successfully"
clean
exit 0

function cleanfail {
  echo "FAILURE!!!"
  echo $1
  clean
  exit 1
} 

function clean {
  rm -f ${CERTFILE}
  rm -f ${CERTS_PREFIX}* 
}
#eof
