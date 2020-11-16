#!/bin/sh

# This script collects random number from:
# https://devopschallenges.duckdns.org/random
#
# This script is controlled by a cron job with:
# */1 * * * * /root/getNumber.sh

url=https://devopschallenges.duckdns.org/random

echo "Random number - $(date): " >> randomNumber.txt
curl -k ${url} >> randomNumber.txt
echo "\n" >> randomNumber.txt
