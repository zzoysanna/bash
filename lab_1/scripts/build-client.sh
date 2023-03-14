#!/bin/sh

# --configuration=production to build in prod mode

prod="--configuration=production"
buildDirName="dist"
zipFileName="client-app.zip"
zipPath="$buildDirName/$zipFileName"
counterPath="scripts/file_counter.sh"

npm install

if [[ -f $zipPath ]]; then
  rm $zipPath
fi

if [[ $1 == $prod ]]; then
  echo 'Building production...'
  ng build $1
else
  ng build
fi

echo '--------------------------------------'
filesNumber=$(bash $counterPath $buildDirName)
echo "Number of files in $buildDirName folder: $filesNumber"
echo '--------------------------------------'

zip -r $zipPath $buildDirName
if [[ -f $zipPath ]]; then
  echo 'Archive is created'
fi


