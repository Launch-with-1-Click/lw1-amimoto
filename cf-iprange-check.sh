#!/bin/bash
curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq  -r '.prefixes[] | select(.service=="CLOUDFRONT") | .ip_prefix' | awk '{print "  "$1}'
