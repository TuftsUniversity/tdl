$(function() {
    $( "#ScheduledDate" ).datepicker({
        changeMonth: true,
        changeYear: true
    });
});

(function ($) {
    "use strict";
    function centerModal() {

        $('#cart_modal').css(
            {
                'margin-top': function () {
                    return -($(this).height() /2 + 50);
                }
            });
    }

    $(document).on('show.bs.modal', '#cart_modal', centerModal);
    $(window).on("resize", function () {
        $('#cart_modal:visible').each(centerModal);
    });
}(jQuery));