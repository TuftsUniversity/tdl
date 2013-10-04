function SortAndPerPageControls(sort_fields) {
    this.perpage_count = 25;
    this.sort_val = $('#sort').find('option:selected').val();
    this.sort_col = (this.sort_val != undefined) ? this.sort_val.split(" ", 1)[0] : "Relevance";
    this.sort_fields = sort_fields;
    this.sort_direction = this.sort_val.split(" ", 2)[1]
    this.sort_direction = this.sort_direction.substring(0, this.sort_direction.length - 1);

    var a = this.getParameterByName("per_page");
    if (a != "")
        this.perpage_count = a;

    a = this.getParameterByName("sort");
    if (a != "score" && a != "") {
        this.sort_col = a;
        this.sort_direction = this.sort_val.split(" ", 2)[1]
        this.sort_direction = this.sort_direction.substring(0, this.sort_direction.length - 1);
    }


    this.updatePerPageButton('#perpage_button');
    this.updateSortButton('#sort_button');


}


SortAndPerPageControls.prototype.getParameterByName = function (name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.search);
    if (results == null)
        return "";
    else
        return decodeURIComponent(results[1].replace(/\+/g, " "));
};

SortAndPerPageControls.prototype.updatePerPageButton = function () {

    $('#perpage_button').html(this.perpage_count + " per page" + "&nbsp;<span class=caret></span>");
    $('#per_page').val(this.perpage_count);
};

SortAndPerPageControls.prototype.updateSortButton = function (e) {

    var sort = $('#sort');
    var sort_type = this.sort_col.split(" ", 2)[0];

    if (this.sort_direction == undefined)
      this.sort_direction = this.sort_col.split(" ", 2)[1];


    var dir = "";
    switch (sort_type) {
        case "score":
        case "Relevance":
            this.updateSortText('relevance');
            sort.find("option:contains('relevance')").prop("selected", "selected");
            $(function () {
                $('#title_header').attr('src', "assets/img/arrow_both.gif").parent().data('sort', 'none');
                $('#creator_header').attr('src', "assets/img/arrow_both.gif").parent().data('sort', 'none');
                $('#date_header').attr('src', "assets/img/arrow_both.gif").parent().data('sort', 'none');
            });
            break;
        case "title_si":
        case "Title":
            this.updateSortText('title');


            if (this.sort_direction == undefined || this.sort_direction == "asc") {
                sort.find("option:contains('title ascending')").prop("selected", "selected");
                dir = "asc";
            }
            else {
                sort.find("option:contains('title descending')").prop("selected", "selected");
                dir = "desc"
            }
            $(function () {
                $('#title_header').attr('src',  (dir=="desc") ? "assets/img/arrow_down.gif" : "assets/img/arrow_up.gif").parent().data('sort', dir);
                $('#creator_header').attr('src', "assets/img/arrow_both.gif").parent().data('sort', 'none');
                $('#date_header').attr('src', "assets/img/arrow_both.gif").parent().data('sort', 'none');
            });
            break;
        case "author_si":
        case "Creator":
            this.updateSortText('creator');
            if (this.sort_direction == undefined || this.sort_direction == "asc") {
                sort.find("option:contains('author ascending')").prop("selected", "selected");
                dir = "asc";
            }
            else {
                sort.find("option:contains('author descending')").prop("selected", "selected");
                dir = "desc"
            }

            $(function () {
                $('#title_header').attr('src', "assets/img/arrow_both.gif").parent().data('sort', 'none');
                $('#creator_header').attr('src', (dir=="desc") ? "assets/img/arrow_down.gif" : "assets/img/arrow_up.gif").parent().data('sort', dir);
                $('#date_header').attr('src', "assets/img/arrow_both.gif").parent().data('sort', 'none');
            });
            break;
        case "pub_date_isi":
        case "Date":
            this.updateSortText('date');
            if (this.sort_direction == undefined || this.sort_direction == "asc") {
                sort.find("option:contains('year ascending')").prop("selected", "selected");
                dir = "asc";
            }
            else {
                sort.find("option:contains('year descending')").prop("selected", "selected");
                dir = "desc"
            }


            $(function () {
                $('#title_header').attr('src', "assets/img/arrow_both.gif").parent().data('sort', 'none');
                $('#creator_header').attr('src', "assets/img/arrow_both.gif").parent().data('sort', 'none');
                $('#date_header').attr('src', (dir=="desc") ? "assets/img/arrow_down.gif" : "assets/img/arrow_up.gif").parent().data('sort', dir);
            });
            break;
    }

};

SortAndPerPageControls.prototype.updateSortText = function (text) {
    $('#sort_button').html("Sort by " + text + "&nbsp;<span class=caret></span>");

};
