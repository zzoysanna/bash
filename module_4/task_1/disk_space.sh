#Create a shell script that will watch free disk space.
# The bash script should follow watch the free space of your hard disks and warns you when that free space drops below a given threshold.
# The value of the threshold is given by the user as a command line argument.
# Notice that if the program gets no command line argument, a default value is used as the threshold.

calcThreshold() {
  local volume=$(df -Ph | awk 'NR==2 {print $2}' | tr -dc '0-9' )
  threshold=$(($volume / 2))
}

if [ -z $1 ]; then
  calcThreshold
  echo "Default value for threshold is $threshold"
else
  threshold=$1
fi

echo "Theshold: $threshold"

current=$(df -h / | awk 'NR==2 {print $4}' | tr -dc '0-9')
echo "Current free space is: $current"

if [ $current -lt $threshold ]; then
  echo "Warning! Less than $threshold Gi of disk space is free"
else
  echo "Keep calm, more than $threshold Gi of disk space is free"
fi

