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

$(document).ready(function(){
    $("div.spoiler span.caption").live("click", toggleSpoiler);
});