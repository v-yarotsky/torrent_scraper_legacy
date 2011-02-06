var showLoadingIcon = function() {
    $("#loading").toggle(true);
};

var hideLoadingIcon = function () {
    $("#loading").toggle(false);
};

$(function(){
    $(".action[data-remote!=''], .remote.action")
            .live("ajax:beforeSend", showLoadingIcon)
            .live("ajax:complete", hideLoadingIcon);
});