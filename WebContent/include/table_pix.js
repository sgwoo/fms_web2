$('document').ready(function() {
	$(function() {
		var marginTop = parseInt( $(".table_pix_td").css('margin-top') );
		/*var tr_marginLeft = parseInt( $("#tr_title").css('margin-left') );*/
		$(window).scroll(function(e) {
			$(".table_pix_td").css("margin-top", marginTop - $(this).scrollTop() );
		});
		/*$(window).scrollLeft(function(e) {
		    $("#tr_title").css("margin-left", tr_marginLeft - $(this).scrollLeft() );
		});*/
	});
});