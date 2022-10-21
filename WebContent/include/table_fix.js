$("document").ready(function() {
	var frame_height = Number($("#height").val());
	var form_width = Number($("#form1").width());
	
	var title_width = Number($(".left_fix").width());
	var title_height = Number($(".tb_title_box").height());
	
	//$(".tb_box").css("max-height", frame_height);
	//$(".tb_box").css("min-height", frame_height);
	$(".tb_box").css("height", frame_height - title_height);
	
	//$("#right_area").css("width", form_width - title_width);
	
	$(function(){
		fixTh();
	  
	  	//$(window).on("resize", function() {
		$(window).resize(function (){
	    	fixTh();
	    	
	    	var frame_height = Number($("#height").val());
	    	var form_width = Number($("#form1").width());
	    	
	    	var title_width = Number($(".left_fix").width());
	    	var title_height = Number($(".tb_title_box").height());
	    	
	    	//$(".tb_box").css("max-height", frame_height);
	    	//$(".tb_box").css("min-height", frame_height);
	    	$(".tb_box").css("height", frame_height - title_height);
	    	
	    	//$("#right_area").css("width", form_width - title_width);
	  	});
	});

	function fixTh() {
    	$(".tb_box").on("scroll", function() {
   		/* $('.tb_box').scroll(function(){ */
      		var tbBox = $('.tb_box');
      		var tbTitleBox = $('.tb_title_box');
      		var th1 = $('.tb_box tr:nth-child(1) .left_fix:nth-child(1)');
      		var th2 = $('.tb_box tr:nth-child(1) td:nth-child(2)');
      		var th3 = $('.tb_title_box tr:nth-child(1) .left_fix:nth-child(1)');
      		/* var td1 = $('.tb_box tr:nth-child(n+2) th'); */
      		var td1 = $('.tb_box tr:nth-child(n+2) .fixed_col');
      		var td2 = $('.tb_box td:nth-child(2)');
      		var scrLeft = tbBox.scrollLeft();
      		var scrTop = tbBox.scrollTop();
      		var fixLeft = tbBox.offset().left;
      		
      		var scrTitleLeft = tbTitleBox.scrollLeft();
      		
      		var fixTop = tbBox.offset().top;      		
      		var thTop = $(".fix");
      		if ($(this).scrollTop() > 0) {
      			thTop.offset({
					//"top" : fixTop
			  	});
      		} else {
      			thTop.css({
					//"top" : 0
			  	});
      		}
      		
      		/* tbBox.find('.row:nth-child(1)').css({
        		//'transform' : 'translateX(' + - scrLeft + 'px)'
        		'left' : '-'+ scrLeft + 'px'
      		}); */
      
			if ($(this).scrollLeft() > 0) {
				th1.offset({
					"left" : fixLeft
			  	});
			  	/* th2.css({
			    	'margin-left': -scrLeft
			  	}); */
				tbTitleBox.scrollLeft(scrLeft);
				th3.offset({
					"left" : fixLeft
				});
			  	td1.offset({
			    	"left" : fixLeft
			  	});
			  	/* td2.css({
			    	'margin-left': -scrLeft
			  	}); */
			} else {
			  	th1.css({
			    	"left" : 0
			  	});
			  	tbTitleBox.scrollLeft(scrLeft);
			  	th3.css({
					"left" : 0
				});
			  	td1.css({
			    	"left" : 0
			  	});
			}
    	});
	};
});