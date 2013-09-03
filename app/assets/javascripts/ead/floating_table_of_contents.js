function handleTOC(eventObj) {
  var outermost = $('#outermost')
  var column = $('#floating_table_of_contents_column')
  var toc = $('#floating_table_of_contents')
  var window_top = $(window).scrollTop();
  var outermost_height = outermost.height();
  var toc_top = window_top - column.position().top;
  var toc_space = outermost.position().top + outermost_height - window_top;
  var toc_height = toc.height();
  var toc_at_top = (toc_top < 0);
  var toc_at_bottom = (toc_space < toc_height);

  if ((eventObj.type == "resize") || toc_at_top || toc_at_bottom) {
    // browser is resizing, or page is scrolled up or down to the point at which TOC should stick
    // to the top or bottom 
    toc.css('position', 'relative');
    toc.css('left', '0px');

    if (toc_at_top) {
      // TOC should be at top of column
      toc.css('top', '0px');
    } else if (toc_at_bottom) {
      // TOC should be at bottom of column
      toc.css('top', outermost_height - toc_height);
    } else {
      // resizing
      toc.css('top', toc_top);
    }
  } else {
    // TOC should float
    toc.css('position', 'fixed');
    toc.css('left', column.offset().left);
    toc.css('top', '0px');
  }
}

$(window).scroll(handleTOC);
$(window).resize(handleTOC);
