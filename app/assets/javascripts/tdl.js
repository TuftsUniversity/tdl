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
            var link = $(this).attr("href")
            $(this).attr("href", link + ".js")

            $(this).on('click', function (e) {
                e.preventDefault();
                $("#more_facets_modal .modal-body").html('');
                var url = $(this).attr("href");

                $.ajax({
                    url:url,
                    dataType:"html",
                    success:function (resp, status, xhr) {
                        if (xhr.status != 0) {

                            $("#more_facets_modal .modal-body").html(resp);
                            var title = $("#more_facets_modal .modal-body h2").text();
                            $("#more_facets_modal .modal-body h2").hide();
                            $("#more_facets_modal .modal-header h3").text(title);


                            $("#more_facets_modal").modal('show');                // initializes and invokes show immediately
                        } else {
                            //stupid jquery calling this 'success', it's
                            //network unavailable.
                            //self._displayFailure(url, xhr, status);
                            alert("fail");
                        }
                    },
                    error:function (xhr, msg) {
                        alert('false ' +xhr);
                    }
                });

                return false;
            });

        });

});

$('#more_facets_link').on('click', function () {

});
