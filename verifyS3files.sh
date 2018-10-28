#!/bin/bash


#=======================================================================
#pathFile.txt - in that you have images list .
#command to run :
# set the mode -  chmod +x path_33.txt
#              -  ./copytoS3.sh
#=======================================================================



# declaring variables

LOGFILE="defferencfileList.txt"   
source_file_path=""
source_path=""
file_path=""
file_root_path="/homebase_uploads/uploads"
file_exist_counter=0;
notexistcounter=0;
verified_count=0;
fixed_path="./photoAsset/"
#mkdir photoAsset
#destination s3 bucket name .
bucket_name=cms-bamtechv1-upload-cmsbt-1489

echo "$(date "+%m%d%Y %T") :started "
while IFS='' read -r line || [[ -n "$line" ]]; do
	source_file_path=$line
	source_path=$( echo ${source_file_path%/*} )
	file_path=$( echo ${source_file_path##/*/} )
	completePath=$file_root_path$source_path
	if [ -d "$completePath" ];then  
			echo "    $(date "+%m%d%Y %T") :  file_path - "$bucket_name$source_file_path
			verified_count=$((verified_count+1))
		   aws s3 ls s3://$bucket_name$source_file_path
		if [[ $? -ne 0 ]]; then
          echo $source_file_path | tee -a "$LOGFILE"
		  notexistcounter=$((notexistcounter+1))
		else
			file_exist_counter=$((file_exist_counter+1))
		fi
		echo "file notexistcounter -> "$notexistcounter
		echo "file file_exist_counter -> "$file_exist_counter
		echo "file verified_count -> "$verified_count
    fi

done < "$1"
echo "$(date "+%m%d%Y %T") :finished "