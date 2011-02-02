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

var bindRemoteActionLinks = function() {
    $(".remote.action").live("click", function(e) {
        var link = $(this);
        $.ajax({
            type: link.attr("request") || "GET",
            url: link.attr("href"),
            dataType: "script",
            data: filtersData(),
            beforeSend: function(xhr, settings) { link.trigger("ajax:beforeSend", [xhr, settings]); },
            complete: function(xhr, status) { link.trigger("ajax:complete", [xhr, status]); }
        });
        e.preventDefault();
        return false;
    });
};

var bindSortableHeaders = function() {
    $("th.sortable").live("click", function() {
        var column_header = $(this);
        var url = column_header.closest("table").attr("data-url");
        var column = column_header.attr("data-column");
        var order = column_header.attr("data-order") || "asc";
        var data = filtersData() + "&column=" + column + "&order=" + order;
        $.ajax({ url: url, dataType: "script", data: data, complete: function() {
            column_header.siblings().removeClass("current");
            column_header.attr("data-order", order == "asc" ? "desc" : "asc").addClass("current");
        } });
    });
};

var bindFilterSelects = function() {
    $("select.filter").change(function() {
        var parent = $(this).parent();
        var url = parent.attr("data-url");
        $.ajax({ url: url, dataType: "script", data: filtersData() });
    });
};

$(function(){
    $(".spoiler .caption").live("click", toggleSpoiler);
    $(".remote.action").live("ajax:beforeSend", showLoadingIcon).live("ajax:complete", hideLoadingIcon);
    bindRemoteActionLinks();
    bindSortableHeaders();
    bindFilterSelects();
});