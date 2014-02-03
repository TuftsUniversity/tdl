function extractPageName(hrefString) {
    var arr = hrefString.split('/');
    return  (arr.length < 2) ? hrefString : arr[arr.length - 1].toLowerCase();
}

function setActiveMenu(arr, crtPage) {
    for (var i = 0; i < arr.length; i++) {
        if (extractPageName(arr[i].href) == crtPage) {
            if (arr[i].parentNode.tagName != "DIV") {
                arr[i].className = "current";
                arr[i].parentNode.className = "current";
                return;
            }
        }
    }
    setActiveMenu(document.getElementById("navigation").getElementsByTagName("a"), "catalog");
}

function setPage() {
    hrefString = document.location.href ? document.location.href : document.location;

    if (document.getElementById("navigation") != null)
        setActiveMenu(document.getElementById("navigation").getElementsByTagName("a"), extractPageName(hrefString));
}

$(document).ready(function () {
    setPage();


        $("a.more_facets_link").each(function () {

            $(this).on('click', function (e) {
                e.preventDefault();
                $("#more_facets_modal .modal-body").html('');
                var url = $(this).attr("href");

                var jqxhr = $.ajax({
                    url:url,
                    dataType: 'script'});
                jqxhr.always( function (resp) {

                            $("#more_facets_modal .modal-body").html(resp.responseText);
                            var title = $("#more_facets_modal .modal-body h2").text();
                            $("#more_facets_modal .modal-body h2").hide();
                            $("#more_facets_modal .modal-header h3").text(title);


                            $("#more_facets_modal").modal('show');                // initializes and invokes show immediately
                });

                return false;
            });

        });

});

$('#more_facets_link').on('click', function () {

});
