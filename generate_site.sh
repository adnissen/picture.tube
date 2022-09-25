source .env

mkdir site
cd site

# use cut to remove the first element of the lust, which is full/
aws s3api list-objects --bucket $AWS_BUCKET_NAME --query Contents[].Key --prefix full/ --output text | cut -f 2- > files_on_s3 > files_on_s3
if [ ! -f "last_processed_files" ]; then
    touch last_processed_files
fi

# comparing the files on s3 with the files we last processed to see if we need to re-generate the site
echo "checking if any files have changed on s3 since last run"

diff files_on_s3 last_processed_files
if [ ! $? -eq 0 ]; then 
    echo "changes found, regenerating site"

    # get the total number of images
    cat files_on_s3 | awk '/\t/' | wc -l
    ((total_image_count=$?+1))
    page_size=20

    rm index.html
    echo '<!doctype html>' >> index.html
    echo '<html lang="en">' >> index.html
    echo '<head>' >> index.html
    echo '<title>picture.tube</title>' >> index.html
    echo '<meta name="author" content="Andrew Nissen">' >> index.html
    echo '<link rel="stylesheet" href="style.css">' >> index.html
    echo '</head>' >> index.html
    echo '<body>' >> index.html
    echo "<p>There are ${total_image_count} total images on this site. All images are at the highest possible jpeg quality and free for non-commercial use.</p>" >> index.html
    echo "<p>Click for full resolution. <strong>Warning: </strong>some jpges are > 40mb in size.</p>" >> index.html
    while IFS=$'\t' read -r -a filesArray
    do
        for i in "${filesArray[@]}"
        do
        : 
            filename=${i:5} # remove the /full part of the string
            echo "<a href='https://${AWS_BUCKET_NAME}.s3.amazonaws.com/full/${filename}'><img src='https://${AWS_BUCKET_NAME}.s3.amazonaws.com/thumbnail/thumbnail_${filename}'></img></a>" >> index.html
        done
    done < files_on_s3

    echo '</body>' >> index.html
    echo '</html>' >> index.html

    # set the list of files we just generated the site with as the last_processed_files list
    mv files_on_s3 last_processed_files
else
    echo "no changes found, done."
fi

cd ..