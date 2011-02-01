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

var filtersData = function() {
  var filters = "";
  $(".filter").each(function() {
    var filter = $(this);
    filters += "&" + filter.attr("data-name") + "=" + filter.val();
  });
  return filters;
};

$(function(){
    $(".spoiler .caption").live("click", toggleSpoiler);
    $(".remote.action").live("ajax:beforeSend", showLoadingIcon).live("ajax:complete", hideLoadingIcon);

    $("th.sortable").live("click", function() {
        var parent = $(this).closest(".media_category");
        var url = parent.attr("data-url");
        var column = $(this).attr("data-column");
        var order = $(this).attr("data-order") || "asc";
        $.get(url, filtersData() + "&column=" + column + "&order=" + order + "&format=js");
    });

    $(function() {
      $("select.filter").change(function() {
        var parent = $(this).parent();
        var url = parent.attr("data-url");
        $.ajax({
          url: url,
          data: (filtersData() + "&format=js"),
          beforeSend: showLoadingIcon,
          complete: hideLoadingIcon
        });
      });
    });
});