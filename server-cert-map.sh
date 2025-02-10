#!/bin/bash
# Scott Morton PhD
# Derived from https://my.f5.com/manage/s/article/K20522219
#     and modified to display all partitions
#
# Usage - bash ./client-cert-mapping >> /var/tmp/client-cert-map.csv
# Use winscp to retrieve file or cat contents and copy from screen

LIST=`tmsh -c 'cd /; list /ltm virtual recursive' | awk '$2 == "virtual" {print $3}' | sort -u`
echo "Virtual,Profile,Certificate"
for VAL in ${LIST}
do
        PROF=`tmsh -c "cd /; show /ltm virtual ${VAL} profiles" 2> /dev/null | grep -B 1 " Ltm::ServerSSL Profile:" | cut -d: -f4 | grep -i "[a-z]" | sed s'/ //'g| sort -u`
        test -n "${PROF}" 2>&- && {
                for PCRT in ${PROF}
                do
                        CERT=`tmsh -c "cd /; list /ltm profile server-ssl ${PCRT}" |  awk '$1 == "cert" {print $2}' 2> /dev/null | sort -u`
                        test -n "${CERT}" 2>&- && {
                        	echo "${VAL},${PCRT},${CERT}"
                        }
                done
        }
done
