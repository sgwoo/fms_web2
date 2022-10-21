<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script>
	$(document).ready(function(){
		var currentMenu = $.cookie("currentMenuNavi");
		if(currentMenu != null) {
			var m_nm1 = currentMenu.split(">")[0];
			var m_nm2 = currentMenu.split(">")[1];
			var m_nm3 = currentMenu.split(">")[2];
			if($('.style1').length > 0){
				$('.style1').html(m_nm1 + ">" + m_nm2 + " > <span class='style5'>" + m_nm3 + "</span>");	
			}
		}			
	})
</script>