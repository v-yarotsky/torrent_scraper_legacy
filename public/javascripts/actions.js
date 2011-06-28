var bindRemoteActionLinks = function() {
    $(".remote.action").live("click", function(e) {
        var $link = $(this);
		var data = $.extend(filtersData(), getIds($link));
		
		console.log(data);
		
        $.ajax({
            type: $link.attr("request") || "POST",
            url: $link.attr("href"),
            dataType: "script",
            data: data,
            beforeSend: function(xhr, settings) { $link.trigger("ajax:beforeSend", [xhr, settings]); },
            complete: function(xhr, status) { $link.trigger("ajax:complete", [xhr, status]); $.event.trigger("reloaded"); }
        });
		e.preventDefault();
        return false;
    });
};

var getIds = function($link) {
	var data = {};
	if ($link.attr("data-id")) {
		data["ids"] = getSingleId($link);
	} else if ($link.is(".group")) {
		data["ids"] = getGroupIds();
	}
	return data;
};

var getSingleId = function($link) {
	return $.makeArray($link.attr("data-id"));
};

var getGroupIds = function() {
	return $.makeArray($(".select_torrent:checked").map(function(idx, c) { return $(c).attr("data-id"); }));
};

var bindGroupCheckBoxes = function() {
	$(".select_media_category_torrents").live("click", function() {
		var $checkbox = $(this);
		var $checkboxes = $checkbox.closest("table").find(".select_torrent");
		if ($checkbox.attr("checked")) {
			$checkboxes.attr("checked", "checked");
		} else {
			$checkboxes.removeAttr("checked");
		}
	});
};

$(function() {
	bindRemoteActionLinks();
	bindGroupCheckBoxes();
});