var toggleSpoiler = function() {
    var caption = $(this);
    var spoiler = caption.parent().toggleClass("expanded");
    var content = caption.next(".content");
    if (spoiler.attr("id") && spoiler.is(".memorized")) {
        var visible = content.is(":visible");
        $.cookie(spoiler.attr("id") + "_visible", visible);
    }
    return false;
};

var initializeSpoilers = function() {
  $("div.spoiler").each(function() {
      var spoiler = $(this);
      if ($.cookie(spoiler.attr("id") + "_visible") == "true") {
          spoiler.addClass("expanded");
      }
  });
};

$(function() {
    $(".spoiler .caption").live("click", toggleSpoiler);
    $('body').bind("reloaded", initializeSpoilers);
    initializeSpoilers();
});