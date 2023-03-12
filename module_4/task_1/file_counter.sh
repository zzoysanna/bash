# Create a shell script, which will count the number of files that exist in each given directory and its subdirectories.
# If nested object is neither directory, nor file, it counts as 0
# If file is given as an input parameter it counts as 1
# If neither directory, nor file is given as an input parameter it counts as 0 

countFilesInOneDir() {
	result=0
	if [[ -f $1 ]]; then
		result=$((result + 1))
	elif [[ -d $1 ]]; then
		for FILE in $1/*; do
			result=$((result + $(countFilesInOneDir $FILE)))
		done
	fi
	echo $result
}

result=0
for var in "$@"
do
	result=$((result + $(countFilesInOneDir $var)))
done

echo $result

