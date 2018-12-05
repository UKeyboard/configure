#! /bin/bash

# In linux, the minimum user ID is 1000 and the maximum user ID is 60000
# If you donot want to create folder for some user, put his user ID in 
# the `omitid` list
declare -a omitid=(1000 1079)
for i in `getent passwd | sort | uniq | awk -F: '$3>=1000 && $3<=60000 {print $1}'`; do
    mkdir $i
done
