var filtersData = function() {
  var filters = {};
  $(".filter").each(function() {
      filters[$(this).attr("data-name")] = $(this).val();
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
            complete: function(xhr, status) { link.trigger("ajax:complete", [xhr, status]); $.event.trigger("reloaded"); }
        });
        return false;
    });
};

var bindSortableHeaders = function() {
    $("th.sortable").live("click", function() {
        var column_header = $(this).addClass("current");
        column_header.siblings().removeClass("current");
        column_header.attr("data-order", column_header.attr("data-order") == "asc" ? "desc" : "asc");
        filterTable(column_header);
    });
};

var getSortableParams = function(table) {
    var column_header = table.find("th.sortable.current");
    if (column_header.length) {
        var column = column_header.attr("data-column");
        var order = column_header.attr("data-order") || "asc";
        return { column: column, order :order };
    }
    return {};
};

var bindSearch = function() {
    $("th .search_toggler").live("click", function() {
        var toggler = $(this);
        if (toggler.parent().is(".active")) {
            var input = toggler.next("input[type='text']").val("");
            filterTable(input);
        }
        toggler.parent().toggleClass("active");
        return false;
    }).end().find("input[type='text']").live("keydown", function(e) {
        if (e.which == 10 || e.which == 13) {
            filterTable($(this));
        }
    }).live("click", function() { return false; });
};

var filterTable = function(element) {
    var table = element.closest("table");
    var url = element.attr("data-url");
    var data = $.extend({}, getSearchParams(table), getSortableParams(table), filtersData());
    $.ajax({ url: url, type: "POST", data: data, dataType: "html", accepts: { html: "application/javascript" },
        success: function(data) { table.find("tbody").html(data); }
    });
};

var getSearchParams = function(table) {
    var data = {};
    table.find(".search.active").each(function() {
        var input = $(this).find("input[type='text']");
        data[input.attr("data-column")] = input.val();
    });
    if ($.isEmptyObject(data)) {
        return {};
    }
    return { search: data };
};

var bindFilterSelects = function() {
    $("select.filter").change(function() {
        var parent = $(this).parent();
        var url = parent.attr("data-url");
        $.ajax({ url: url, dataType: "script", data: filtersData(), beforeSend: showLoadingIcon, complete: function() {
            hideLoadingIcon();
            $.event.trigger("reloaded");
        } });
    });
};

$(function(){
    bindRemoteActionLinks();
    bindSortableHeaders();
    bindSearch();
    bindFilterSelects();
});
