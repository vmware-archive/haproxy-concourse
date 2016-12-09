#!/bin/bash -e
curl -IL ${OMG_HAPROXY_IP} | grep "HTTP/1.1 200 OK"
