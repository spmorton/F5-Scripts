#!/bin/bash
# Scott Morton PhD
# Derived from https://my.f5.com/manage/s/article/K20522219
#     and modified to display all partitions
#
# Usage - bash ./http-profile-map >> /var/tmp/http-profile-map.csv
# Use winscp to retrieve file or cat contents and copy from screen

LIST=`tmsh -c 'cd /; list /ltm virtual recursive' | awk '$2 == "virtual" {print $3}' | grep -v -i redirect | sort -u`
echo "Virtual,Profile"
for VAL in ${LIST}
do
        PROF=`tmsh -c "cd /; show /ltm virtual ${VAL} profiles" 2> /dev/null | grep -B 1 " Ltm::HTTP Profile:" | cut -d: -f4 | grep -i "[a-z]" | sed s'/ //'g| sort -u`
        test -n "${PROF}" 2>&- && {
               	echo "${VAL},${PROF}"
        }
done
