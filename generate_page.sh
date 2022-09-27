pageNum=$1 # page x
shift
pageOf=$1 # of y
shift
images=$@
echo '<!doctype html>' >> site/$pageNum.html
echo '<html lang="en">' >> site/$pageNum.html
echo '<head>' >> site/$pageNum.html
echo '<title>picture.tube</title>' >> site/$pageNum.html
echo '<meta name="author" content="Andrew Nissen">' >> site/$pageNum.html
echo '<link rel="stylesheet" href="style.css">' >> site/$pageNum.html
echo '</head>' >> site/$pageNum.html
echo '<body>' >> site/$pageNum.html
echo "<p>There are ${total_image_count} total images on this site. All images are at the highest possible jpeg quality and free for non-commercial use.</p>" >> site/$pageNum.html
echo "<p>Click for full resolution. <strong>Warning: </strong>some jpges are > 40mb in size.</p>" >> site/$pageNum.html
for i in $images
do
    filename=${i:5} # remove the /full part of the string
    echo "<a href='https://${AWS_BUCKET_NAME}.s3.amazonaws.com/full/${filename}'><img src='https://${AWS_BUCKET_NAME}.s3.amazonaws.com/thumbnail/thumbnail_${filename}'></img></a>" >> site/$pageNum.html
done
echo '</body>' >> site/$pageNum.html
echo '</html>' >> site/$pageNum.html
