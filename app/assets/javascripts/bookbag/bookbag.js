/*=================================================================================================
This script provides functionality to add and remove documents from a user's bookbag.

It assumes that all bookbag links have a common CSS selector, as well as an attribute that uniquely
identifies a document. It also assumes that the element displaying the number of items in a bookbag
has a unique CSS selector. These values are controlled by variables:

bookbag - the CSS selector for all bookbag links.
bagCount - the element which displays the number of items in the bookbag.
================================================================================================ */

$(document).ready(function () {
    // Sets global selector variables
    var listAdd = '.list-add';
    var listDelete = '.list-delete';
    var listCount = '.listCount';
    
    // Removes link and changes text displayed if cookies are not enabled
    if (! navigator.cookieEnabled) {
        $(listAdd).text('Cookies not enabled');
    };

    //gets list items from localStorage
    function getList() {
        if (localStorage.getItem("myList")) {
          var list = JSON.parse(localStorage.getItem("myList")).sort();
          return list;
        } else {
          return null;
        }
    };

    //saves list items to localStorage
    function saveList(collection) {
        localStorage.setItem("myList", JSON.stringify(collection));
    };

    //update list on bookbag page and in dialogs
    function updateDisplay() {
        var myList = getList();
        if (myList) {
            $('.myListContents').empty();
            if (myList.length > 0) {
            $('#myListNav #myListButton').addClass('hasContents');
            $('.myListContents').append(
                '<div class="row header-row">' + 
                    '<div class="requestInputs"><input type="checkbox" checked="checked" name="allRequests"/></div>' + 
                    '<div class="collectionTitle">Collection/Book Title</div>' +
                    '<div class="title">Folder Title</div>' + 
                    '<div class="date">Date</div>' + 
                    '<div class="containers">Containers</div>' +
                    '<div class="dateAdded">Date Added</div>' +
                '</div>');
            }
        for(var i =0; i <= myList.length-1; i++) {
            var item = myList[i];
            
            //create variables
            function sanitize(value) {
                if (value) {return value;}
                else {return '';}
            };

            function dateConvert(value){
                if(value){
                    var date = new Date(value);
                    var d = date.toDateString();
                    var h = date.getHours();
                    var m = date.getMinutes();
                    if (h > 12) {
                        var p = h-12;
                        return d + ', ' + p + ':' + m + ' pm';
                    } else {
                        return d + ', ' + h + ':' + m + ' am';
                    }
                } else {
                    return '';
                }
            };

            function containerJoin(container1, container2) {
                if (container1) {
                if (container2) {
                    return container1 + ', ' + container2;
                } else {
                    return container1
                    }
                } else {
                    return '';
                }
                e.preventDefault();
            };

            function splitparents(string) {
                if(string) {
                    var split = string.split('; ');
                    var parents = '';
                    for(var i=0; i<split.length; i++) {
                        var parent = '<div style="text-indent:' + i*2 + 'px;">' + split[i] + '</div>'
                        parents = parents + parent;
                    };
                    return parents;
                    } else {
                    return '';
                }
            };

            var title = sanitize(item.title);
            var date = sanitize(item.date);
            var collectionTitle = sanitize(item.collectionTitle);
            var creator = sanitize(item.creator);
            var dateAdded = dateConvert(item.dateAdded);
            var identifier = sanitize(item.identifier);
            var url = sanitize(item.URL);
            var parents = sanitize(item.parents);
            var formatparents = splitparents(item.parents);
            var container1 = sanitize(item.container1);
            var container2 = sanitize(item.container2);
            var containers = containerJoin(container1, container2);
            var callNumber = sanitize(item.callNumber);
            var accessRestrict = sanitize(item.accessRestrict);
            var groupingfield = sanitize(item.groupingfield);
                                
            $('.myListContents').append(
                '<div class="row">' + 
                    '<div class="requestInputs">' +
                        '<input type="checkbox" checked="checked" name="Request" value="' + identifier + '"/>' +
                        '<input type="hidden" name="ItemInfo1_' + identifier + '" value="' + title + '"/>' +
                        '<input type="hidden" name="ItemDate_' + identifier + '" value="' + date + '"/>' +
                        '<input type="hidden" name="ItemTitle_' + identifier + '" value="' + collectionTitle + '"/>' +
                        '<input type="hidden" name="ItemAuthor_' + identifier + '" value="' + creator + '"/>' +
                        '<input type="hidden" name="ItemSubtitle_' + identifier + '" value="' + parents + '"/>' +
                        '<input type="hidden" name="ItemVolume_' + identifier + '" value="' + container1 + '"/>' +
                        '<input type="hidden" name="ItemIssue_' + identifier + '" value="' + container2 + '"/>' +
                        '<input type="hidden" name="ItemInfo2_' + identifier + '" value="' + accessRestrict + '"/>' +
                        '<input type="hidden" name="CallNumber_' + identifier + '" value="' + callNumber + '"/>' +
                        '<input type="hidden" name="ItemInfo3_' + identifier + '" value="' + url + '"/>' +
                        '<input type="hidden" name="GroupingField_' + identifier + '" value="' + groupingfield + '"/>' +
                    '</div>' + 
                    '<div class="collectionTitle"><p>' + collectionTitle + ' (' + item.callNumber + ')</p>' +
                    '<div class="parents">' + formatparents + '</div></div>' +
                    '<div class="title"><p><a href="' + url + '">' + title + '</a></p></div>' + 
                    '<div class="date">' + date + ' </div>' +
                    '<div class="containers"><p>' + containers + '</p></div>' +
                    '<div class="dateAdded"><p>' + dateAdded + '</p></div>' + 
                    '<button class="list-delete btn" href="#" data-identifier="'+ identifier + '">Delete</button>' +
                '</div>');

            // change text for components already in bookbag
            $('.list-add[data-identifier="' + identifier + '"]').replaceWith('<span>Added</span>');

        };

        // update list count
        var count = myList.length
        $(listCount).text(count);
        if (count < 1) {
            $('.myListContents').append('<div class="empty">Your List is empty! Click on the icon that looks like this <img alt="bookbag icon" src="/xtf/icons/default/addlist.png"/> next to one or more items in your <a href="">Search Results</a> to add it to your list.</div>');
            $('#myListNav #myListButton').removeClass('hasContents');
        } 
        
        
    } else {
        //if list is empty, set count to zero
        $(listCount).text('0');
        $('#myListNav #myListButton').removeClass('hasContents');
    }
    
    

    return false;

    };

    //Might need some functions to sort by various fields, maybe title, collection, creator, date added
    //function sortList(param) {}
    
    //Adds documents to My List
    $(listAdd).on('click', function (e) {
    
        //animate my list button
        $('#myListButton').effect( "highlight", {color:"rgba(196, 84, 20, 0.1)"}, 500 );
        
        var a = $(this);

        //data variables
        var identifier = $(a).attr('data-identifier');
        var title = $(a).attr('data-iteminfo1');
        var date = $(a).attr('data-itemdate');
        var collectionTitle = $(a).attr('data-itemtitle');
        var creator = $(a).attr('data-itemauthor');
        var parents = $(a).attr('data-itemsubtitle');
        var container1 = $(a).attr('data-itemvolume');
        var container2 = $(a).attr('data-itemissue');
        var accessRestrict = $(a).attr('data-iteminfo2');
        var callNumber = $(a).attr('data-callnumber');
        var url = $(a).attr('data-iteminfo3');
        var groupingfield = $(a).attr('data-groupingfield');

        //Let the user know something is happpening
        a.text('Adding...');

        // Add document to myList in localStorage        
            // figure out if there's an existing list in localStorage
            var localStorage = getList();
            if (localStorage) {
                var myList = localStorage;
            } else {
                var myList = new Array();};

            //create a new object to add to the array    
            var dateAdded = Date.now();
            var doc = {
                'identifier': identifier,
                'title': title,
                'date': date,
                'collectionTitle': collectionTitle,
                'creator': creator,
                'parents': parents,
                'container1': container1,
                'container2': container2,
                'accessRestrict': accessRestrict,
                'callNumber': callNumber,
                'URL': url,
                'groupingfield': groupingfield,
                'dateAdded': dateAdded
            }

            //add the new item to the existing array
            myList.push(doc);

            //save the new list in localStorage
            saveList(myList);

            // update display
            updateDisplay();
   
        e.preventDefault();

        //need this so function doesn't run twice
        return false;   
    });

    // Removes documents from My List
    $('body').on('click', listDelete, function(e) {
        var a = $(this);
        var identifier = $(a).attr('data-identifier')
        // Remove document from bookbag
            a.text('Deleting...');
            var myList  = getList();

            for(var i=0; i <= myList.length -1; i++) {
                var item = myList[i];
                if (item.identifier === identifier) {
                    myList.splice(i, 1)
                }
            }
            
            // save new list in localStorage
            saveList(myList);

            // update display
            updateDisplay();

            e.preventDefault();
    })

    // Remove all items from bookbag
    $('.myListRemoveAll').on('click', function(e){
        var myList = [];
        saveList(myList);
        updateDisplay();
    });


    // update display
    updateDisplay();

    return false;

});

// Disables inputs when checkbox is unchecked
$(function() {
    $('.requestInputs input[name="Request"]').on('click', function(){
        if($(this).is(':checked')) {
            $(this).siblings('input').attr("disabled", false);
            var value = $(this).attr("value");
            $('input[value='+value+"]").attr('checked', true);
            $('input[value='+value+"]").siblings('input').attr("disabled", false);
            if(!($(this).parents('.myListContents').hasClass('dialog'))) {
                $('input[value='+value+"]").parents('.row:not(.header-row)').removeClass('disabled');
            }
        } else {
           $(this).siblings('input').attr("disabled", true);
           var value = $(this).attr("value");
           $('input[value='+value+"]").attr('checked', false);
           $('input[value='+value+"]").siblings('input').attr("disabled", true);
           if(!($(this).parents('.myListContents').hasClass('dialog'))) {
                $('input[value='+value+"]").parents('.row:not(.header-row)').addClass('disabled');
           }
        }
        var listCount = $('#requestForm .row > .requestInputs > input[checked="checked"]').length - 1;
        $('.listCount').html(listCount);
    });
});


// Checks or unchecks all
$(function() {
    $('.header-row input[type="checkbox"]').on('click', function(e) {
        if($(this).is(':checked')) {
            $('.requestInputs input[type="checkbox"]').attr('checked', true);
            $('.requestInputs input[type="hidden"]').attr("disabled", false);
            if(!($(this).parents('.myListContents').hasClass('dialog'))) {
                $('.requestInputs').parents('.row:not(.header-row)').removeClass('disabled');
            }
            var listCount = $('#requestForm .row > .requestInputs > input[checked="checked"]').length - 1;
           $('.listCount').html(listCount);
        } else {
            $('.requestInputs input[type="checkbox"]').attr('checked', false);
            $('.requestInputs input[type="hidden"]').attr("disabled", true);
            if(!($(this).parents('.myListContents').hasClass('dialog'))) {
                $('.requestInputs').parents('.row:not(.header-row)').addClass('disabled');
            }
           var listCount = $('#requestForm .row > .requestInputs > input[checked="checked"]').length;
           $('.listCount').html(listCount);
        }
    });
});


//shows or hides scheduled date and user review sections
$(function () {

    function showSection(root) {
        root.show();
        root.find(':input').prop("disabled", false);
    }

    function hideSection(root) {
        root.hide();
        root.find(':input').prop("disabled", true);
    }

    function showReview() {
        $('#VisitReview').prop("checked", true);
        showSection(userReviewLabel);
        hideSection(scheduledDateLabel);
        $('#UserReview').prop("checked", true);
    }

    function showScheduled() {
        $('#VisitScheduled').prop("checked", true);
        showSection(scheduledDateLabel);
        hideSection(userReviewLabel);
        $('#UserReview').prop("checked", false);
    }

    $(document).ready(function () {
        scheduledDateLabel = $('.scheduledDate');
        userReviewLabel = $('.userReview');

        if ((scheduledDateLabel != null) && (userReviewLabel != null) && ($('#VisitScheduled') != null) && ($('#VisitReview') != null) && ($('#UserReview') != null)) {

            $('#UserReview').hide();

            $('#VisitScheduled').click(function () {
                showScheduled();
            });

            $('#VisitReview').click(function () {
                showReview();
            });

            if ($('#UserReview').prop("checked")) {
                showReview();
            } else {
                showScheduled();
            }
        }
    });

}());
