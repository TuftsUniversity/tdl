// 
// This file shows the minimum you need to provide to BookReader to display a book
//
// Copyright(c)2008-2009 Internet Archive. Software license AGPL version 3.

// Create the BookReader object
br = new BookReader();
var br_width = -1;
var br_height = -1;

// Return the width of a given page.  Here we assume all images are 800 pixels wide
br.getPageWidth = function (index) {
    var bookReaderDiv = $('#ImageInfo');
    var pid = bookReaderDiv.data('pid');
    if (br_width == -1) {
        $.ajax({
            type:'GET',
            url:'/pdf_pages/' + pid + '/metadata',
            datatype:'json',
            success:function (image_data) {
                br_width = image_data.page_width;

            },
            failure:function (obj) {
                alert('blah' + obj)
            },
            data:{},
            async:false
        });
    }

    return br_width;
};

// Return the height of a given page.  Here we assume all images are 1200 pixels high
br.getPageHeight = function (index) {
    var bookReaderDiv = $('#ImageInfo');
    var pid = bookReaderDiv.data('pid');
    if (br_height == -1) {
        $.ajax({
            type:'GET',
            url:'/pdf_pages/' + pid + '/metadata',
            datatype:'json',
            success:function (image_data) {
                br_height = image_data.page_height;

            },
            data:{},
            async:false
        });
    }

    return br_height;
};

// We load the images from archive.org -- you can modify this function to retrieve images
// using a different URL structure
br.getPageURI = function (index, reduce, rotate) {
    // reduce and rotate are ignored in this simple implementation, but we
    // could e.g. look at reduce and load images from a different directory
    // or pass the information to an image server
    // var leafStr = '0';
    // var imgStr = (index+1).toString();
    // var re = new RegExp("0{"+imgStr.length+"}$");
    var bookReaderDiv = $('#ImageInfo');
    //return "/file_assets/advanced/tufts:TBS.VW0001.000113";
    return '/pdf_pages/' + bookReaderDiv.data('pid') + '/' + index;// +leafStr.replace(re, imgStr) + '.jpg';

};


// Return which side, left or right, that a given page should be displayed on
br.getPageSide = function (index) {
    if (0 == (index & 0x1)) {
        return 'L';
    } else {
        return 'R';
    }
}


BookReader.prototype.drawLeafsOnePage = function () {
    //alert('drawing leafs!');
    this.timer = null;


    var scrollTop = $('#BRcontainer').prop('scrollTop');
    var scrollBottom = scrollTop + $('#BRcontainer').height();
    //console.log('top=' + scrollTop + ' bottom='+scrollBottom);

    var indicesToDisplay = [];

    var i;
    var leafTop = 0;
    var leafBottom = 0;
    for (i = 0; i < this.numLeafs; i++) {
        var height = parseInt(this._getPageHeight(i) / this.reduce);

        leafBottom += height;
        //console.log('leafTop = '+leafTop+ ' pageH = ' + this.pageH[i] + 'leafTop>=scrollTop=' + (leafTop>=scrollTop));
        var topInView = (leafTop >= scrollTop) && (leafTop <= scrollBottom);
        var bottomInView = (leafBottom >= scrollTop) && (leafBottom <= scrollBottom);
        var middleInView = (leafTop <= scrollTop) && (leafBottom >= scrollBottom);
        if (topInView | bottomInView | middleInView) {
            //console.log('displayed: ' + this.displayedIndices);
            //console.log('to display: ' + i);
            indicesToDisplay.push(i);
        }
        leafTop += height + 10;
        leafBottom += 10;
    }

    // Based of the pages displayed in the view we set the current index
    // $$$ we should consider the page in the center of the view to be the current one
    var firstIndexToDraw = indicesToDisplay[0];
    if (firstIndexToDraw != this.firstIndex) {
        this.willChangeToIndex(firstIndexToDraw);
    }
    this.firstIndex = firstIndexToDraw;

    // Update hash, but only if we're currently displaying a leaf
    // Hack that fixes #365790
    if (this.displayedIndices.length > 0) {
        this.updateLocationHash();
    }

    if ((0 != firstIndexToDraw) && (1 < this.reduce)) {
        firstIndexToDraw--;
        indicesToDisplay.unshift(firstIndexToDraw);
    }

    var lastIndexToDraw = indicesToDisplay[indicesToDisplay.length - 1];
    if (((this.numLeafs - 1) != lastIndexToDraw) && (1 < this.reduce)) {
        indicesToDisplay.push(lastIndexToDraw + 1);
    }

    leafTop = 0;
    var i;
    for (i = 0; i < firstIndexToDraw; i++) {
        leafTop += parseInt(this._getPageHeight(i) / this.reduce) + 10;
    }
    var cont = $('#BRContainer');

    cont.css('background-image', this._getPageURI(index, this.reduce, 0));
    cont.css('background-color', 'transparent');


    //center the page vertically
    if (this.numLeafs == 1) {
        var containerHeight = $('#BRcontainer').height();
        var zoomedHeight = parseInt((this._getPageHeight(i) / this.reduce));
        if (zoomedHeight < containerHeight)
            leafTop = parseInt(containerHeight / 2 - zoomedHeight / 2);
        //alert("center image debug viewHeight " +viewHeight + " zoomedHedight " + zoomedHeight);
    }
    //var viewWidth = $('#BRpageview').width(); //includes scroll bar width
    var viewWidth = $('#BRcontainer').prop('scrollWidth');


    for (i = 0; i < indicesToDisplay.length; i++) {
        var index = indicesToDisplay[i];
        var height = parseInt(this._getPageHeight(index) / this.reduce);

        if (BookReader.util.notInArray(indicesToDisplay[i], this.displayedIndices)) {
            var width = parseInt(this._getPageWidth(index) / this.reduce);
            //console.log("displaying leaf " + indicesToDisplay[i] + ' leafTop=' +leafTop);
            var div = document.createElement("div");
            div.className = 'BRpagediv1up';
            div.id = 'pagediv' + index;
            div.style.position = "absolute";
            $(div).css('top', leafTop + 'px');
            var left = (viewWidth - width) >> 1;
            if (left < 0) left = 0;
            $(div).css('left', left + 'px');
            $(div).css('width', width + 'px');
            $(div).css('height', height + 'px');
            //$(div).text('loading...');

            $('#BRpageview').append(div);


            var img = document.createElement("img");
            img.src = this.protectImages ? this._getTransparentPageURI() : this._getPageURI(index, this.reduce, 0);
            $(img).addClass('BRnoselect2');
            $(img).css('width', width + 'px');
            $(img).css('height', height + 'px');
            $(div).append(img);

            var img2 = document.createElement("img");
            img2.src = this._getPageURI(index, this.reduce, 0);
            $(img2).addClass('BRnoselect');
            $(img2).css('width', width + 'px');
            $(img2).css('height', height + 'px');
            $(div).append(img2);
        } else {
            //console.log("not displaying " + indicesToDisplay[i] + ' score=' + jQuery.inArray(indicesToDisplay[i], this.displayedIndices));
        }

        leafTop += height + 10;

    }

    for (i = 0; i < this.displayedIndices.length; i++) {
        if (BookReader.util.notInArray(this.displayedIndices[i], indicesToDisplay)) {
            var index = this.displayedIndices[i];
            //console.log('Removing leaf ' + index);
            //console.log('id='+'#pagediv'+index+ ' top = ' +$('#pagediv'+index).css('top'));
            $('#pagediv' + index).remove();
        } else {
            //console.log('NOT Removing leaf ' + this.displayedIndices[i]);
        }
    }

    this.displayedIndices = indicesToDisplay.slice();
    this.updateSearchHilites();

    if (null != this.getPageNum(firstIndexToDraw)) {
        $("#BRpagenum").val(this.getPageNum(this.currentIndex()));
    } else {
        $("#BRpagenum").val('');
    }

    this.updateToolbarZoom(this.reduce);

}

BookReader.prototype._getTransparentPageURI = function () {
    return '/images/tdl/Transparent.gif'
}
// This function returns the left and right indices for the user-visible
// spread that contains the given index.  The return values may be
// null if there is no facing page or the index is invalid.
br.getSpreadIndices = function (pindex) {
    var spreadIndices = [null, null];
    if ('rl' == this.pageProgression) {
        // Right to Left
        if (this.getPageSide(pindex) == 'R') {
            spreadIndices[1] = pindex;
            spreadIndices[0] = pindex + 1;
        } else {
            // Given index was LHS
            spreadIndices[0] = pindex;
            spreadIndices[1] = pindex - 1;
        }
    } else {
        // Left to right
        if (this.getPageSide(pindex) == 'L') {
            spreadIndices[0] = pindex;
            spreadIndices[1] = pindex + 1;
        } else {
            // Given index was RHS
            spreadIndices[1] = pindex;
            spreadIndices[0] = pindex - 1;
        }
    }

    return spreadIndices;
}

// For a given "accessible page index" return the page number in the book.
//
// For example, index 5 might correspond to "Page 1" if there is front matter such
// as a title page and table of contents.
br.getPageNum = function (index) {
    return index + 1;
}


// Protect images
br.protectImages = false;

// Total number of leafs
//br.numLeafs = 6;


var bookReaderDiv = $('#ImageInfo');

var pid = bookReaderDiv.data('pid');
$.ajax({
    type:'GET',
    url:'/pdf_pages/' + pid + '/metadata',
    datatype:'json',
    success:function (image_data) {
        br.numLeafs = image_data.page_count;

    },
    data:{},
    async:false
});


// Book title and the URL used for the book title link
br.bookTitle = 'Open Library BookReader Presentation';
br.bookUrl = 'http://openlibrary.org';
br.logoURL = '/';
// Override the path used to find UI images
br.imagesBaseURL = '/images/BookReader/';

br.getEmbedCode = function (frameWidth, frameHeight, viewParams) {
    return "Embed code not supported in bookreader demo.";
}

// Let's go!
br.init();

// read-aloud and search need backend compenents and are not supported in the demo
$('#BRtoolbar').find('.read').hide();
$('#textSrch').hide();
$('#btnSrch').hide();
