$(function() {
	$("#copy_destination_folder").blur(function(){
		$.cookie('copy_destination', $(this).val());
	});
});