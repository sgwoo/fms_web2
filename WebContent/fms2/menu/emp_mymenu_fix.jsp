<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
%>
<html>
<head>
<title>:: FMS(Fleet Management System) ::</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/sub.css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>

<script>
$(document).ready(function(){
	
	$('.page-link').click(function(){
		var menuNameParam = $(this).attr("param");
		var menuFullPath = menuNameParam.split(":")[0] + " > " + menuNameParam.split(":")[1] + " > " + menuNameParam.split(":")[2];
		
		$.cookie("currentMenuNavi",menuFullPath,{expires: 1, path: '/', domain:'.amazoncar.co.kr'});
		
		location.href = $(this).attr("href");
	})
	
	$('.mymenu-boxes').css('height',$(window).height());
	getMyMenuData();
})



//마이메뉴 데이터 갖고오기
	function getMyMenuData(){
		
		$.ajax({
			url:"/fms2/menu/emp_mymenu.jsp",
			cache:false,
			success:function(data){
				
				var items = jQuery.parseJSON(data);
				$("#13").html("<div id='sub99' class='submenu mymenu' style='float:left'></div>");
				$("#sub99").html("<br><span class='sub-title'>나의 메뉴&nbsp;&nbsp;</span><br/><br/>");
				
				$.each(items, function(key, value){
					$.each(value, function(key, value){
				    	var index = parseInt(key,10);
				    	var menu = 	"<p id='" + value.mst +":" + value.mst2 + ":" + value.mcd +
				    				"' class='item'>" +
				    				"<span class='mymenu-path' style='cursor:pointer;'>&nbsp;&nbsp;</span>" +(index+1)+". " +
				    				"<a href='#' onclick=\"javascript:page_link_mymenu('2','" +
				    				value.mst + "','" + value.mst2 + "','" + value.mcd + "','" + value.url + "','" + value.authRw + "','" +
				    				value.mnm1 + " > " + value.mnm2 + " > " + value.mnm + 
				    				"');\">" + value.mnm + "</a></p>";
				    		$('#13 div:last-child').append(menu);			    					
				    });
				});
			}
		});
	}
	
function page_link_mymenu(st, m_st, m_st2, m_cd, url, auth_rw, menu_full_path){
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id=<%=acar_br%>&user_id=<%=ck_acar_id%>';
		parent.d_content.location = url+''+values;
		
		//if(st == 1)		parent.top_menu.showMenuDepth(m_st);
		//else 			parent.top_menu.showMenuDepth('12');
		$.cookie("currentMenuNavi",menu_full_path,{expires: 1, path: '/', domain:'.amazoncar.co.kr'});
	}

	$( window ).resize(function() {
  	$('.mymenu-boxes').css('height',$(window).height());
	});

</script>
<style>
@import url(//cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothic.css);
@import url(//cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothiclight.css);
@font-face {
    font-family: 'icomoon';
    src:    url('../lib/fonts/icomoon.eot?rtmp4o');
    src:    url('../lib/fonts/icomoon.eot?rtmp4o#iefix') format('embedded-opentype'),
        url('../lib/fonts/icomoon.ttf?rtmp4o') format('truetype'),
        url('../lib/fonts/icomoon.woff?rtmp4o') format('woff'),
        url('../lib/fonts/icomoon.svg?rtmp4o#icomoon') format('svg');
    font-weight: normal;
    font-style: normal;
}

[class^="icon-"], [class*=" icon-"] {
    /* use !important to prevent issues with browser extensions that change fonts */
    font-family: 'icomoon' !important;
    speak: none;
    font-style: normal;
    font-weight: normal;
    font-variant: normal;
    text-transform: none;
    line-height: 1;

    /* Better Font Rendering =========== */
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

#changeOrderMode {
	padding: 3px;
	border: 1px solid #d0d0d0;
	color: #ffffff;
	font-size: 11px;
	background-color: #d9d9d9;
	cursor:pointer;
}

.favorite {
	text-decoration:none;
	cursor:pointer;
}

.icon-star:before {
    content: "\f005";
}
.icon-star-o:before {
    content: "\f006";
}
.icon-star-empty:before {
    content: "\e9d7";
}
.icon-star-full:before {
    content: "\e9d9";
}
.icon-sort:before {
    content: "\f0dc";
}
.icon-unsorted:before {
    content: "\f0dc";
}

body{
	//background-color:#f6f6f6;
	//border-bottom:2px solid #349BD5;
}

.menu{
	font-family:'Nanum Barun Gothic';
	background-color:#f6f6f6;
	font-size:12px;
}
.sub-title{
	font-family:'Nanum Barun Gothic';
	font-size:14px;
	color:#0D7BBA;
	padding-bottom:5px;
	margin-bottom:10px;
	margin-left:15px;
}
.submenu{
	width:150px;
	/*float:left;*/
	line-height:22px;
}
.submenu hr{
	border:0px;
	border-top:1px solid #dadada;
	height:1px;
	float:left;
	width:70%;
}
.icon-star{
	 color:rgba(255, 136, 0, 1);
}
.icon-star-o{
	 color:#ddd;
}

.mymenu{
	width:150px;
	line-height:18px;
}
.text-favorite{
	color:#000 !important;
	font-weight:bold;
}
.mymenu-path{
	color:#9d9d9d;
}
p.item{
	margin:2px !important;
    -webkit-margin-before: 0px;
    -webkit-margin-after: 0px;
    -webkit-margin-start: 0px;
    -webkit-margin-end: 0px;
}
</style>
<body style="height:100%;">
			<div class="mymenu-boxes menu upper-mymenu" id="13" style="width:100%;background-color:#f1f5f4;overflow-y:scroll;">
					<div id="sub99" class="submenu mymenu">
						
					</div>
			</div> 

</body>
</html>