#!/bin/sh

#port 192.168.1.134

directory=$1; # /Users/zoya_rassadkina/projects/bash-projects
vm-directory=$2; #/var/app/

fe-dir="$directory/shop-angular-cloudfront"
be-dir="$directory/nestjs-rest-api"
vm-fe-dir="$vm-directory/shop-fe"
vm-be-dir="$vm-directory/shop-be"

cd $fe-dir && npm run build
cd $be-dir && npm run build

ssh ubuntu-sshuser
scp -Cr "$fe-dir/dist" package.json ubuntu-sshuser:$vm-fe-dir
scp -Cr "$be-dir/dist/*" package.json ubuntu-sshuser:$vm-be-dir

cd $vm-be-dir && npm run start
