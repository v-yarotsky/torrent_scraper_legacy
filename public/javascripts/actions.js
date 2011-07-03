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
	$(".select_tracker_category_torrents").live("click", function() {
		var $checkbox = $(this);
		var $checkboxes = $checkbox.closest("table").find(".select_torrent");
		if ($checkbox.attr("checked")) {
			$checkboxes.attr("checked", "checked");
		} else {
			$checkboxes.removeAttr("checked");
		}
	});
	$(".select_torrent").live("click", function() {
		var $checkbox = $(this);
		var $group_checkbox = $checkbox.closest("table").find(".select_tracker_category_torrents");
		if ($group_checkbox.is(":checked") && $checkbox.is(":not(:checked)")) {
			$group_checkbox.removeAttr("checked");
		}
	});
};

$(function() {
	bindRemoteActionLinks();
	bindGroupCheckBoxes();
});

var Torrent = new JS.Class({
	initialize: function(id) {
		this.id = id;
		this.$element = $("#torrent_" + id);
		this.title = this.$element.find(".title").text();
		this.link = this.$element.find(".title a").attr("href");
		this.seeders = this.$element.find(".seeders").text();
		this.size = this.$element.find(".size").text();
	}
});

var TrackerCategory = new JS.Class({
	initialize: function(id) {
		this.id = id;
		this.$element = $("#tracker_category_" + id);
		this.title = this.$element.find(".caption .title").text();
		this.torrents = this.$element.find(".torrent").map(function(idx, element) { return new Torrent($(element).data("id")); });
	}
});

