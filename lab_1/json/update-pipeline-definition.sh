#!/bin/bash

# $ ./update-pipeline-definition.sh
# ./pipeline.json
# --configuration production
# --owner boale
# --branch feat/cicd-lab
# --poll-for-source-changes true

if ! [ $(which jq) ]; then
  echo
  echo 'You will need jq to run this script. Install it using your package manager.'
  echo '- Macos: brew install jq'
  echo '- Windows 10: download file and put jq.exe in C:\Users\username\bin'
  echo '- Linux: yum install jq'
  printf '\e]8;;https://stedolan.github.io/jq/download/\e\\You can check this link\e]8;;\e\\\n'
  echo
  exit
fi

file=$1
if ! [ $file ] ; then
  echo 'File is not provided, can not continue'
  exit
fi

properties=(
  ".pipeline"
  ".pipeline.stages"
  ".pipeline.version"
  ".pipeline.stages[0].actions[0].configuration.Branch"
  ".pipeline.stages[0].actions[0].configuration.Owner"
  ".pipeline.stages[0].actions[0].configuration.PollForSourceChanges"
)

for i in "${properties[@]}"
do
   fieldValue=$(jq --arg i "$i" $i $file)
   num=${#fieldValue}
   if [ $num == 0 ];then
     echo 'File is invalid, can not continue'
     exit
   fi
done

branch='main'
poll='false'

i=0
while [ $i -lt 4 ]; do
    case "$2" in
        -c | --configuration)  configuration=$3; shift 2;;
        -o | --owner) owner=$3; shift 2;;
        -b | --branch) branch=$3; shift 2;;
        -p | --poll-for-source-changes) poll=$3; shift 2;;
    esac
    i=$((i+1))
done

echo "Configuration: $configuration"
echo "Owner: $owner"
echo "Branch: $branch"
echo "Poll: $poll"

echo '------------------------------'

newFileName="pipeline-$(date +%m%d%Y).json"
cp $file $newFileName

newFileContent=$(jq '.pipeline.version += 1 | del(.metadata)' $newFileName)
echo -E "${newFileContent}" > $newFileName

if [ $configuration ]; then
  echo "Add configuration info"
  confContent=$(jq --arg conf "$configuration" '
    .pipeline.stages[1].actions[0].configuration.EnvironmentVariables |= sub("{{BUILD_CONFIGURATION value}}";$conf;"g")
    | .pipeline.stages[3].actions[0].configuration.EnvironmentVariables |= sub("{{BUILD_CONFIGURATION value}}";$conf;"g")
  ' $newFileName)
  echo -E "${confContent}" > $newFileName
fi

if [ $branch ]; then
  echo "Add branch info"
  branchContent=$(jq --arg branch "$branch" '.pipeline.stages[0].actions[0].configuration.Branch = $branch' $newFileName)
  echo -E "${branchContent}" > $newFileName
fi

if [ $owner ]; then
  echo "Add owner info"
  ownerContent=$(jq --arg owner "$owner" '.pipeline.stages[0].actions[0].configuration.Owner = $owner' $newFileName)
  echo -E "${ownerContent}" > $newFileName
fi

if [ $poll ]; then
  echo "Add poll info"
  pollContent=$(jq --arg poll "$poll" '.pipeline.stages[0].actions[0].configuration.PollForSourceChanges = $poll' $newFileName)
  echo -E "${pollContent}" > $newFileName
fi

