#! /bin/bash

# collect files and folders from .gitignore's 
declare -A exclude_list=()
count=0
while read line;
do 
   if [[ "$line" != ""  ||  "$line" != ".env" ]]; then
   echo ${line}
   exclude_list[$count]=$line
   ((count+=1))
   #echo ${exclude_list[@]}
   fi
done < "../../.gitignore"

# build rsync command with exclude list
ignore_string=""
for entry in "${exclude_list[@]}"
do
    ignore_string="${ignore_string} --exclude ${entry}"
done
echo "$ignore_string"

# collecting directory to rsync over 
top_of_dir="../../{{cookiecutter.project_slug}}"


# conversly, just pass the gitignore file straight to rsync, no don't do this it's bad.
rysnc_command="rsync -avr ${ignore_string} ../{{cookiecutter.project_slug}} ../deployments"
echo "Running $rysnc_command"
$rysnc_command

