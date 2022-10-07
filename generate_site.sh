source .env

firstArg=$1
if [ "$firstArg" = "-force" ]; then
    rm -rf site
fi

mkdir site

# use cut to remove the first element of the list, which is full/
aws s3api list-objects --bucket $AWS_BUCKET_NAME --query Contents[].Key --prefix full/ --output text | cut -f 2- > site/files_on_s3
if [ ! -f "last_processed_files" ]; then
    touch site/last_processed_files
fi

# comparing the files on s3 with the files we last processed to see if we need to re-generate the site
echo "checking if any files have changed on s3 since last run"

diff site/files_on_s3 site/last_processed_files
if [ ! $? -eq 0 ]; then 
    echo "changes found, regenerating site"

    # get the total number of images
    cat site/files_on_s3 | awk '/\t/' | wc -l
    ((total_image_count=$?+1))
    page_size=20
    current_page=1
    # to get the total number of pages, divide the total number of images by the page size and round up
    totalPages=$((($total_image_count + $page_size - 1)/$page_size))
    
    rm site/index.html
    while IFS=$'\t' read -r -a filesArray
    do
        for pageNum in {1..$totalPages}
        do
        :
            # get every x elements, where x is the page size
            imageBatch=${filesArray[@]:$((($current_page-1)*$page_size)):$page_size}
            echo "${pageNum} of ${totalPages} pages. Images: ${imageBatch}"
            ./generate_page.sh $pageNum $totalPages $imageBatch
        done
    done < site/files_on_s3
    
    # set the list of files we just generated the site with as the last_processed_files list
    mv site/files_on_s3 site/last_processed_files

    # rename the first page to index.html
    mv site/1.html site/index.html

    # upload the site folder to the s3 static site bucket
    aws s3 cp ./site s3://$AWS_STATIC_SITE_BUCKET_NAME/ --exclude "*" --include "*.html" --recursive   

else
    echo "no changes found, done."
fi

cd ..