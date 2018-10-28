#!/bin/bash


#=======================================================================
#pathFile.txt - in that you have images list .
#command to run :
# set the mode -  chmod +x path_33.txt
#              -  ./copytoS3.sh
#=======================================================================



# declaring variables

LOGFILE="logfile.txt"   
source_file_path=""
source_path=""
file_path=""
file_root_path="/homebase_uploads/uploads"
counter=0;
file_total_count=0;
file_counter=0;
fixed_path="./photoAsset/"
mkdir photoAsset
#destination s3 bucket name .
bucket_name=cms-bamtechv1-uploads-qa-cmsbt-1695

echo "$(date "+%m%d%Y %T") :started " | tee -a "$LOGFILE"  
while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "$(date "+%m%d%Y %T") :Paths read from file: $line" | tee -a "$LOGFILE"

	source_file_path=$line
	source_path=$( echo ${source_file_path%/*} )
	file_path=$( echo ${source_file_path##/*/} )
	completePath=$file_root_path$source_path
	echo "..........$completePath "
	
	if [ -d "$completePath" ]; then
	#	if [ "$counter" -le 15000 ]; then
		
		#	echo "    $(date "+%m%d%Y %T") :  bucket_name - "$bucket_name  | tee -a "$LOGFILE"
		#	echo "    $(date "+%m%d%Y %T") :  counter - "$counter | tee -a "$LOGFILE"
			echo "    $(date "+%m%d%Y %T") :  source_file_path - "$source_file_path | tee -a "$LOGFILE"
			echo "    $(date "+%m%d%Y %T") :  source_path - "$source_path  | tee -a "$LOGFILE"
			echo "    $(date "+%m%d%Y %T") :  file_path - "$file_path  | tee -a "$LOGFILE"
		
			echo "    ==============================================================     " | tee -a "$LOGFILE"
			echo "    ============= Files are going to S3 ==========================     " | tee -a "$LOGFILE"
			echo "    ==============================================================     " | tee -a "$LOGFILE"
			cp -r --parents $file_root_path$source_file_path ./photoAsset/  | tee -a "$LOGFILE"
			echo "    ==============================================================     "  | tee -a "$LOGFILE"
			echo "    ============= files are copied successfully ! ================     "  | tee -a "$LOGFILE"
			echo "    ==============================================================     "  | tee -a "$LOGFILE"
		  counter=$((counter+1))
      file_counter=$(find $fixed_path$file_root_path$source_file_path -type f -print | wc -l)
      file_total_count=$((file_total_count+file_counter))
      echo "counter -> $counter  , file_counter is -> $file_counter , file_total_count = $file_total_count" | tee -a "$LOGFILE"
		file_counter=0;	
	  echo "file_counter is now initiallized $file_counter" | tee -a "$LOGFILE"
	  
	#	fi
   else
		echo "    $(date "+%m%d%Y %T") :  source_file_path does not exist - "$source_file_path  | tee -a "$LOGFILE"
		echo "    $(date "+%m%d%Y %T") :  source_path does not exist - "$source_path  | tee -a "$LOGFILE"
		echo "    $(date "+%m%d%Y %T") :  file_path does not exist  - "$file_path  | tee -a "$LOGFILE"
   fi

done < "$1"
echo "sync with s3 ............. "
aws s3 sync ./photoAsset/$file_root_path/ s3://$bucket_name/ --acl authenticated-read
echo "this is - file_total_count "$file_total_count 
rm -rf ./photoAsset/
echo "$(date "+%m%d%Y %T") :finished   " | tee -a "$LOGFILE"