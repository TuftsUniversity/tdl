$(function(){
      $('.collapse_td').on('click', function(e){

        e.preventDefault();
        var par = $(this).parents("tr").eq(0);
        var col_cont = par.find('.collapse_content');
        col_cont.toggle();
        var tog_img= par.find('img');
        if (col_cont.is(':visible'))
        {

            tog_img.attr('src','/assets/img/button_collapse.png');
        }
        else
        {
            tog_img.attr('src','/assets/img/button_expand.png');
        }
      });


      ////add modals to the thumbnails

      $('.thumbnail').attr('href','#myImageOverlay');
      addThumbListeners();


    //$("#myImageOverlay").on('show resize', function () {
    //                var modal = $(this);
    //    modal.css({
    //    'margin-top': function () {
    //
    //
    //           return ("-48%");
    //    }
    //
    //       });
    //});
   $("#myImageGallery").on('show resize', function () {
                        var modal = $("#myImageGallery");
                        modal.css({"left":0}).css({"max-width":"100%","max-height":"100%","margin-left": (- modal.outerWidth() / 2), "margin-top": (- modal.outerHeight() / 2), "left":"50%"});})



   $("#myImageOverlay").on('show resize', function () {
                        var modal = $("#myImageOverlay");
                          modal.css({"left":0}).css({"max-width":"100%","max-height":"100%","margin-left": (- modal.outerWidth() / 2), "margin-top": (- modal.outerHeight() / 2), "left":"50%"});
})


    var gallery_start = 0;
    var gallery_page_size = 10;
    var pid = "";
    var total_count = 0;
    var gallery = $('#myImageGallery');

    $('.myImageGalleryLauncher').on('click', function (e) {
        e.preventDefault();
        pid = $(this).data('pid');
        updateThumbs(gallery, true);

    });

    function removeThumbListeners()
    {
        $('a.thumbnail, a.gallery_thumbnail').unbind('click');
    }

    function addThumbListeners()
    {
        $('a.thumbnail, a.gallery_thumbnail').on('click', function(e){
                    e.preventDefault();



                  var pid = $(this).data('pid');
                  $.getJSON('/file_assets/image_overlay/' + pid , function(data)
                  {
                    var template = $('#image_overlay_template').html();
                    var html = Mustache.to_html(template, data);
                    $('#myImageOverlay').html(html)
		    setTimeout(function() { 
			$('#myImageOverlay').modal('show');
			},500);


                  });




              });
    }
    function updateThumbs(gallery,show) {
        $.getJSON('/file_assets/image_gallery/' + pid + '/' + gallery_start + '/' + gallery_page_size, function (data) {
            total_count = parseInt(data.count);
            var template = $('#gallery_overlay_template').html();
            var html = Mustache.to_html(template, data);
            gallery.html(html);
            if (show)
            {
                gallery.modal('show');


            }
            addPagingHandlers();
            removeThumbListeners();
            addThumbListeners();
            $(document).ready(function() {
                $('.modal a[rel="tooltip"]')
                    .tooltip({placement: 'right'})
                    .data('tooltip')
                    .tip()
                    .css('z-index',2080);
            });
        });
    }

    function addPagingHandlers() {

        if (gallery_start + gallery_page_size >= total_count)
            $('.next_page').addClass('disabled');

        if (gallery_start == 0) {
            $('.prev_page').addClass('disabled');

        }
        $('.next_page').on('click', function (e) {
            e.preventDefault();
            gallery_start += gallery_page_size;
            updateThumbs(gallery, false);
        });

        $('.prev_page').on('click', function (e) {
            e.preventDefault();
            gallery_start -= gallery_page_size;
            updateThumbs(gallery, false);
        });
    }

    function removePagingHandlers() {
        $('.next_page').unbind('click');
        $('.prev_page').unbind('click');
    }

    gallery.on('hidden', function (e) {
        removePagingHandlers();
    })



  });
