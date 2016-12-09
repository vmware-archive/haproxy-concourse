#!/bin/bash -e
echo "checking haproxy can route"
curl -IL ${OMG_HAPROXY_IP} | grep "HTTP/1.1 200 OK"

echo "adding fake private only domain - ${OMG_HAPROXY_IP}  ${OMG_TEST_INTERNAL_DOMAIN}"
echo "${OMG_HAPROXY_IP}  ${OMG_TEST_INTERNAL_DOMAIN}" >> /etc/hosts

echo "adding fake private only domain - ${OMG_HAPROXY_IP}  ${OMG_TEST_PUBLIC_DOMAIN}"
echo "${OMG_HAPROXY_IP}  ${OMG_TEST_PUBLIC_DOMAIN}" >> /etc/hosts

echo "test if public domain, it should be routable"
curl -IL ${OMG_TEST_PUBLIC_DOMAIN} | grep "HTTP/1.1 200 OK"

echo "test internal only domain, it should not be routable"
curl -IL ${OMG_TEST_INTERNAL_DOMAIN} | grep "HTTP/1.0 403 Forbidden"
