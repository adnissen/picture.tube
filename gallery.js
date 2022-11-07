function attemptAlign() {
    list = document.getElementsByTagName('ul')[0]

    //distance from right side of the image to the edge of the list border
    //list.offsetWidth - img.getBoundingClientRect().right

    //first we're going to make an array that contains the image elements
    imageElements = []
    Array.from(list.children).forEach(listElement => {
        if (typeof listElement.children[0] === 'undefined' || typeof listElement.children[0].children === 'undefined') {  }
        else {
            imageElements.push(listElement.children[0].children[0]);
        };
    });

    //next we need to figure out which images will be grouped together as a row
    //there are 3 image types for our purposes: portait, landscape, and square
    //the challenge comes when a row has elements of a mixed size

    //in order to not cut off any of the images, we need to come up with a fixed height per-row that the above 3 elements can all use
    //let's start with trying to 4 images per row no matter what
    rowSize = 4
    rows = imageElements.length / rowSize

    //get the width of all the images in each row
    rowWidths = []
    for (let row = 0; row < rows; row++) {
        for (let picture = 0; picture < rowSize; picture++) {
            rowWidths[row] ||= 0
            rowWidths[row] += imageElements[((row + 1) * rowSize - rowSize) + picture].getBoundingClientRect().width
        }
    }

    //now that we know that total widths of the 4 images, we can go back through and resize each one
    for (let row = 0; row < rows; row++) {
        for (let picture = 0; picture < rowSize; picture++) {
            rowWidthComparedToAvailable = list.getBoundingClientRect().width - rowWidths[row]
            //and now fill the available space
            element = imageElements[((row + 1) * rowSize - rowSize) + picture]
            element.style.height = element.getBoundingClientRect().height + ((rowWidthComparedToAvailable / 4) / 1.3333333) + 'px'
        }
    }
}

attemptAlign();
attemptAlign();
attemptAlign();

addEventListener('resize', (event) => {
    for (let row = 0; row < rows; row++) {
        for (let picture = 0; picture < rowSize; picture++) {
            element = imageElements[((row + 1) * rowSize - rowSize) + picture]
            element.style.height = ''
        }
    }
    attemptAlign();
    attemptAlign();
    attemptAlign();
});
