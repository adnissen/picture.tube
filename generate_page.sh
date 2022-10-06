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
echo "<p>All images are at the highest possible jpeg quality and free for non-commercial use.</p>" >> site/$pageNum.html
echo "<p>Click for full resolution. <strong>Warning: </strong>some jpges are > 40mb in size.</p>" >> site/$pageNum.html

echo "<p>Page ${pageNum} of ${pageOf}</p>" >> site/$pageNum.html

# if we're not the first page we want a previous button
if [ ! $pageNum -eq 1 ];then
    echo "<a href='/$((${pageNum}-1)).html'>Previous</a>  " > site/$pageNum.html
fi

# if we're not the last page then we want a next button
if [ ! $pageNum -eq $pageOf ];then
    echo "<a href='/$((${pageNum}+1)).html'>Next</a>" >> site/$pageNum.html
fi

for i in $images
do
    filename=${i:5} # remove the /full part of the string
    echo "<a href='${AWS_IMAGEHOST_DOMAIN}/full/${filename}'><img src='${AWS_IMAGEHOST_DOMAIN}/thumbnail/thumbnail_${filename}'></img></a>" >> site/$pageNum.html
done

# but the page navigation buttons at the top and the bottom of the page
if [ ! $pageNum -eq 1 ];then
    echo "<a href='/$((${pageNum}-1)).html'>Previous</a>  " > site/$pageNum.html
fi

if [ ! $pageNum -eq $pageOf ];then
    echo "<a href='/$((${pageNum}+1)).html'>Next</a>" >> site/$pageNum.html
fi

echo '</body>' >> site/$pageNum.html
echo '</html>' >> site/$pageNum.html
