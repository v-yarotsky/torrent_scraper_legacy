function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).next('div.nested_fields').prepend(content.replace(regexp, new_id));
}

var showLoadingIcon = function() {
    $("#loading").toggle(true);
};

var hideLoadingIcon = function () {
    $("#loading").toggle(false);
};

var toggleSpoiler = function() {
    var spoiler = $(this).parent();
    var content = $(this).next(".content");
    content.slideToggle('fast', function() {
        if (spoiler.attr("id")) {
            var visible = content.is(":visible");
            $.cookie(spoiler.attr("id") + "_visible", visible);
        }
    });
};

var initializeTrackerSpoilers = function() {
  $("div.spoiler").each(function() {
    var spoiler = $(this);
    if ($.cookie(spoiler.attr("id") + "_visible") == "true") {
      spoiler.find("div.caption").click();
    }
  });
};

$(function(){
    $(".spoiler .caption").live("click", toggleSpoiler);
    $(".remote.action").live("ajax:beforeSend", showLoadingIcon).live("ajax:complete", hideLoadingIcon);
    $("th.sortable").live("click", function() {
        var data_column = $(this).attr("data-column");
        var data_order = $(this).attr("data-order") || "asc";
        var data_url = $(this).closest("table").attr("url");

        $(this).attr("data-order", data_order == "asc" ? "desc" : "asc");
        $(this).siblings("th.sortable").removeClass("current");
        $(this).addClass("current");

        $.ajax({
            url: data_url,
            data: ({ column: data_column, order: data_order, format: "js" }),
            loading: showLoadingIcon,
            complete: hideLoadingIcon
          });
        //alert(column + " " + tracker+ " " + category);
    });
});