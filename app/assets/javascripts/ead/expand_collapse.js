function toggleDisplay(imgName, firstRow, lastRow) {
  var img = $(imgName);
  var rows = $("#theTable tr");
  var display = (img.attr("src").indexOf("button_expand.png") != -1);
  var imgSrc = (display ? "/assets/img/button_collapse.png" : "/assets/img/button_expand.png");
  var rowIndex;

  img.attr("src", imgSrc);  // swap the [+] or [-] image on the row that was clicked

  if (display) {
    // Expanding: show each row in the range firstRow to lastRow unless it's in a sub-folder that's collapsed.
    for (rowIndex = firstRow; rowIndex <= lastRow; rowIndex++) {
      var row = $(rows[rowIndex]);

      row.css("display", "");

      // If the row is a folder that's collapsed, skip down to the next row that's not a child of the collapsed folder.
      var toggler = row.find(".folderRowToggler");

      if (toggler.length) {  // This row is a folder
        if (toggler.attr("src").indexOf("button_expand.png") != -1) {  // This folder is collapsed.
          rowIndex += toggler.data("child-count");  // skip all the rows that are contents of this folder, leaving them hidden
        }
      }
    }
  } else {
    // Collapsing: just hide every row in the range firstRow to lastRow.  
    for (rowIndex = firstRow; rowIndex <= lastRow; rowIndex++) {
      var row = $(rows[rowIndex]);

      row.css("display", "none");
    }
  }
}

function displayAll(display) {
  var rows = $("#theTable tr");
  var imgSrc = (display ? "/assets/img/button_collapse.png" : "/assets/img/button_expand.png");
  var rowDisplay = (display ? "" : "none");
  var rowIndex;
  var rowCount = rows.length;
  var foldersFound = false;
  var buttonRow = null;

  for (rowIndex = 0; rowIndex < rowCount; rowIndex++) {
    var row = $(rows[rowIndex]);
    var className = row.attr("class");

    if (className == "table_options") {
      buttonRow = row;
    } else if (className == "table_header") {
      // do nothing
    } else  {
      var toggler = row.find(".folderRowToggler");

      if (toggler.length) {
        toggler.attr("src", imgSrc);
        foldersFound = true;
      }

      if (className != "topLevelRow") {
        row.css("display", rowDisplay);
      }
    }
  }

  if (!foldersFound && buttonRow != null) {
    // There are no folders on this page, so hide the expand/collapse buttons.
    buttonRow.css("display", "none");
  }
}

$(document).ready(function(){
  displayAll(false);
});
