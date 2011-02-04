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
    var caption = $(this);
    var spoiler = caption.parent().toggleClass("expanded");
    var content = caption.next(".content");
    if (spoiler.attr("id")) {
        var visible = content.is(":visible");
        $.cookie(spoiler.attr("id") + "_visible", visible);
    }
};

var initializeTrackerSpoilers = function() {
  $("div.spoiler").each(function() {
      var spoiler = $(this);
      if ($.cookie(spoiler.attr("id") + "_visible") == "true") {
          spoiler.addClass("expanded");
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
            type: link.attr("request") || "POST",
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
        var column_header = $(this).addClass("current");
        column_header.siblings().removeClass("current");
        var table = column_header.closest("table");

        var url = table.attr("data-sort-url");
        var data = getSortableParams(table) + filtersData();

        $.ajax({ url: url, dataType: "html", accepts: { html: "application/javascript" }, data: data, success: function(data) {
            table.find("tbody").html(data);
            column_header.attr("data-order", column_header.attr("data-order") == "asc" ? "desc" : "asc");
        } });
    });
};

var getSortableParams = function(table) {
    var column_header = table.find("th.sortable.current");
    if (column_header.length) {
        var column = column_header.attr("data-column");
        var order = column_header.attr("data-order") || "asc";
        return "&column=" + column + "&order=" + order;
    } else {
        return "";
    }
};

var bindSearch = function() {
    $("th .search_toggler").live("click", function() {
        $(this).parent().toggleClass("active");
        return false;
    }).end().find("input[type='text']").live("keydown", function(e) {
        if (e.which == 10 || e.which == 13) {
            var input = $(this);
            var table = input.closest("table");
            var url = table.attr("data-search-url");
            var data = getSearchParams(table) + getSortableParams(table) + filtersData();
            $.ajax({ url: url, data: data, dataType: "html", accepts: { html: "application/javascript" },
                beforeSend: showLoadingIcon,
                complete: hideLoadingIcon,
                success: function(data) { table.find("tbody").html(data); }
            });
        }
    }).live("click", function() { return false; });
};

var getSearchParams = function(table) {
    var data = "";
    table.find(".search.active").each(function() {
        var input = $(this).find("input[type='text']");
        var column = input.closest("th").attr("data-column");
        data += "[" + column + "]=" + input.val();
    });
    if (data != "") {
        return "search" + data;
    } else {
        return "";
    }
};

var bindFilterSelects = function() {
    $("select.filter").change(function() {
        var parent = $(this).parent();
        var url = parent.attr("data-url");
        $.ajax({ url: url, dataType: "script", data: filtersData(), beforeSend: showLoadingIcon, complete: hideLoadingIcon });
    });
};

$(function(){
    $(".spoiler .caption").live("click", toggleSpoiler);
    $(".action[data-remote!=''], .action.remote").live("ajax:beforeSend", showLoadingIcon).live("ajax:complete", hideLoadingIcon);
    bindRemoteActionLinks();
    bindSortableHeaders();
    bindSearch();
    bindFilterSelects();
});