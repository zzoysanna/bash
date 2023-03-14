#!/bin/sh

echo 'Running quality check script...'

lintRes=$(ng lint)
testsRes=$(ng test)
auditRes=$(npm audit)

echo '------------------------------'
echo 'Linter results:'
echo $lintRes
echo '------------------------------'
echo 'Unit tests results:'
echo $testsRes
echo '------------------------------'
echo 'Npm audit results:'
echo $auditRes
