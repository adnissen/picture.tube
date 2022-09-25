source .env

mkdir processing
cd processing
# our process is going to look like the following:
#
# 1. download all the files in the upload directory
# 2. create thumbnails of these images
# 3. upload the thumbnails to /thumbnails
# 4. move only the files we created thumbnails for from /upload to /full

# list the files in /upload and download them one by one. 
# we do this instead of manipulating the entire directory so that we can be sure we don't miss any files in the case that an upload happens while processing
# use cut to remove the first element of the list, which is upload/
aws s3api list-objects --bucket $AWS_BUCKET_NAME --query Contents[].Key --prefix upload/ --output text | cut -f 2- > files_to_process

while IFS=$'\t' read -r -a filesArray
do
    for i in "${filesArray[@]}"
    do
        : 
        filename=${i:7} # remove the /upload part of the string
        aws s3 cp s3://$AWS_BUCKET_NAME/upload/$filename . # download the image
        convert -thumbnail 4000 $filename thumbnail_$filename # create the thumbnail
        aws s3 cp thumbnail_$filename s3://$AWS_BUCKET_NAME/thumbnail/thumbnail_$filename # upload the thumbnail
        aws s3 mv s3://$AWS_BUCKET_NAME/upload/$filename s3://$AWS_BUCKET_NAME/full/$filename
    done
done < files_to_process

cd ..