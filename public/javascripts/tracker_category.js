function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".tracker_category").hide();
}

function add_fields(content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_tracker_category", "g");
  $("table.tracker_categories tbody").append(content.replace(regexp, new_id));
}

var updateMediaCategories = function() {
    var current_select = $(this);
    if (!current_select.find("option:selected").is(":last-child")) {
        current_select.attr("data-default", current_select.val());
        return false;
    }
    var new_category = prompt("New media category");
    if (!new_category) {
        current_select.val(current_select.attr("data-default"));
        return false;
    }
    var url = current_select.attr("data-url");

    $.ajax({
        type: "POST",
        url: url,
        dataType: "json",
        data: encodeURI("&new_media_category_name=" + new_category),
        success: function(data) {
            var options = "";
            $.each(data, function(){
                options += "<option value='" + this[1] + "'>" + this[0] + "</option>";
            });
            $(".tracker_category select").each(function(){
                var select = $(this);
                var option = select.val();
                select.html(options).val(option);
            });
            current_select.val(current_select.find(":contains('" + new_category +"')").attr("value"));
        }
    });
    return false;
};

$(function(){
    $(".tracker_category select").live("change", updateMediaCategories);
});