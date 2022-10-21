<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %> 

<%	
	String acar_id = ck_acar_id;
	
	//소메뉴
	UserMngDatabase umd = UserMngDatabase.getInstance();
		//사용자정보	
	UsersBean user_bean = umd.getUsersBean(acar_id);
	
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

	//마이메뉴 데이터 갖고오기
	function getMyMenuData(){
		
		$.ajax({
			url:"/fms2/menu/emp_mymenu.jsp",
			cache:false,
			success:function(data){
				
				var items = jQuery.parseJSON(data);
				$("#12").html("<div id='sub99' class='submenu mymenu' style='float:left'></div>");
				$("#sub99").html("<span class='sub-title'>나의 메뉴</span><input type='button' onclick='javascript:changeOrderMode();' id='changeOrderMode' value='메뉴 순서 변경 / 삭제'/><br/><hr/><br/>");
				
				$.each(items, function(key, value){
					$.each(value, function(key, value){
				    	var index = parseInt(key,10);
				    	var menu = 	"<p id='" + value.mst +":" + value.mst2 + ":" + value.mcd +
				    				"' class='item'>" +
				    				"<span class='icon-star2 favorite2' id='favorite2' style='display:none;' param='"+ value.mst +":" + value.mst2 + ":" + value.mcd + "'></span> " +
				    				"<span class='icon-sort' style='display:none;'></span><span class='mymenu-path' style='cursor:pointer;'>&nbsp;&nbsp;" + value.mnm1 + " > " + value.mnm2 + " > </span>" +
				    				"<a href='#' onclick=\"javascript:page_link_mymenu('2','" +
				    				value.mst + "','" + value.mst2 + "','" + value.mcd + "','" + value.url + "','" + value.authRw + "','" +
				    				value.mnm1 + " > " + value.mnm2 + " > " + value.mnm + 
				    				"');\">" + value.mnm + "</a></p>";
				    				
				    	if(index%15 == 0 && index != 0){ //리스트가 15개가 넘어가면 div를 하나씩 더 만든다.
				    		$('#12').append("<div class='submenu mymenu' style='float:left; margin-top:44px;'>"+menu+"</div>");
				    	}else{
				    		$('#12 div:last-child').append(menu);
				    	}				    					
				    });
				});
				$('.favorite2').on("click",function(){
					
					$(this).removeClass(".favorite2");
					
					var confirmMsg = "마이메뉴를 제거하시겠습니까?";
					var st = "";				
					var mst = $(this).attr("param").split(':')[0];
					var mst2 = $(this).attr("param").split(':')[1];
					var mcd = $(this).attr("param").split(':')[2];
					
					if($(this).hasClass('icon-star2')){
						st = "N";
						confirmMsg += " 제거하시겠습니까?";
					} 				
					if(confirm(confirmMsg)){					
						var url = "/fms2/menu/mymenu_act.jsp";
						url = url + "?st=" + st + "&m_st=" + mst + "&m_st2=" + mst2 + "&m_cd=" + mcd;
						var me = this;
						$.ajax({
							url:url,
							cache:false,
							success:function(){
								alert( "정상적으로 처리되었습니다" );
								getMyMenuData();
								checkEmptyMenu();
								$(me).addClass(".favorite2");							
							}
						});
						
						$(this).toggleClass("icon-star icon-star-o");
						$(this).next("a.text-link").toggleClass("text-favorite");
					}
								
				});
			}
		});
	}
		
	function page_link_mymenu(st, m_st, m_st2, m_cd, url, auth_rw, menu_full_path){
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id=<%=acar_br%>&user_id=<%=ck_acar_id%>';
		parent.d_content.location = url+''+values;
		
		if(st == 1)		parent.top_menu.showMenuDepth(m_st);
		else 			parent.top_menu.showMenuDepth('12');
		$.cookie("currentMenuNavi",menu_full_path,{expires: 1, path: '/', domain:'.amazoncar.co.kr'});
	}
	
	//하위메뉴가 없는 것은 안보이게 처리하기 
	function checkEmptyMenu(){
		$('.submenu').each(function(index){
			var itemCount = $(this).find('a').length;
			if(itemCount == 0){
				$(this).css("display","none");
			}
		});
	}
	
	function changeOrderMode(){
		$('#changeOrderMode').toggleClass("edit");

		if($('#changeOrderMode').hasClass("edit")){
			$('#changeOrderMode').val("변경 완료");
			$('.icon-star2').css("display","inline");
			$('.icon-sort').css("display","inline");
			$( ".upper-mymenu" ).sortable({
				  disabled: false
			});			
		}else{
			$('#changeOrderMode').val("메뉴 순서 변경 / 삭제");
			$('.icon-star2').css("display","none");
			$('.icon-sort').css("display","none");
			$( ".upper-mymenu" ).sortable({
				  disabled: true
			});
		}
	}
	
	$(document).ready(function(){
		
		getMyMenuData();
		checkEmptyMenu();
		
		$('.page-link').click(function(){
			
			var param = $(this).attr("param");
			
			var st = param.split(":")[0];
			var m_st = param.split(":")[1];
			var m_st2 = param.split(":")[2];
			var m_cd = param.split(":")[3];
			var url = param.split(":")[4];
			var auth_rw = param.split(":")[5];
			
			var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id=<%=acar_br%>&user_id=<%=ck_acar_id%>';
			
			var m_nm = $(this).find("span").html(); //메뉴 이름
			var m_st2_nm = $(this).closest("div").find(".sub-title").html(); //중메뉴 이름
			var m_st_nm = $('.open',parent.frames['top_menu'].document).find("b").html(); //대메뉴 이름
			var data = m_st_nm + " > " + m_st2_nm + " > " + m_nm;
			
			$.cookie("currentMenuNavi",data,{expires: 1, path: '/', domain:'.amazoncar.co.kr'});
			
			if ( url.substr(0, 4) =='http' ) {	
			     
			    var name5='<%=user_bean.getId()%>';
			    var pass5='<%=user_bean.getUser_psd()%>';	
			    
			    if ( auth_rw.substr(0, 5) =='//211' ) {	
			    	window.open(url + ":"+ auth_rw+"", "pop", "menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
			    }else if ( auth_rw =='//fms1.amazoncar.co.kr/acar/estimate_mng/search_cust_list_judge.jsp' ) {
			    	auth_rw = '/acar/estimate_mng/search_cust_list_judge.jsp';
				    window.open(auth_rw+"", "pop", "menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
			    }else{			      
					window.open(url + ":"+ auth_rw+"?name="+name5+"&passwd="+pass5 + "&s_width=500&s_height=200", "pop", "menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
			    }	
		
		
		} else {
					
				parent.d_content.location = url+''+values;
				
				if(st == 1)		parent.top_menu.showMenuDepth(m_st);
				else 			parent.top_menu.showMenuDepth('12');
			}		
			
		})
		
		//마이메뉴 드래그앤드랍 가능하게 하는 function 
		$('.upper-mymenu').sortable(
			{	
				disabled: true,
				items:'>.mymenu > .item', //item class 를 드래그앤드랍 가능하게 할것
			    stop: function(event, ui) { //드래그앤드랍 후 멈췄을 때 이벤트에 바인딩
			    	var jsonData = new Object();
					var menuList = new Array();
					var index = 0;
			        $(".item").each(function(i, el){
			        	index++;
			        	
			        	var data = new Object();
			        	var menuInfo = $(el).attr("id");

			        	data.mst = menuInfo.split(':')[0];
			        	data.mst2 = menuInfo.split(':')[1];
			        	data.mcd = menuInfo.split(':')[2];
			        	data.index = index;
						
			        	menuList.push(data);
			        });
			        
			        jsonData.data = menuList;
					
			        //소팅 결과 반영
			        $.ajax({
			        	type:'POST',
			        	url:"/fms2/menu/mymenu_sorting.jsp",
			        	data:{'data': JSON.stringify(jsonData) },
			        	success:function(){
			        		alert("적용되었습니다");
			        	}
			        })
			    }
			}
		);
		
		//즐겨찾기 추가,해제 시
		$('.favorite').on("click",function(event){
			
			$(this).removeClass(".favorite");
			
			var confirmMsg = "마이메뉴를";
			var st = "";
			
			var mst = $(this).attr("param").split(':')[0];
			var mst2 = $(this).attr("param").split(':')[1];
			var mcd = $(this).attr("param").split(':')[2];
			
			if($(this).hasClass('icon-star-o')){
				st = "Y";
				confirmMsg += " 추가하시겠습니까?";
			}else{
				st = "N";
				confirmMsg += " 제거하시겠습니까?";
			}

			
			if(confirm(confirmMsg)){
				
				var url = "/fms2/menu/mymenu_act.jsp";
				url = url + "?st=" + st + "&m_st=" + mst + "&m_st2=" + mst2 + "&m_cd=" + mcd;
				var me = this;
				$.ajax({
					url:url,
					cache:false,
					success:function(){
						alert( "정상적으로 처리되었습니다" );
						getMyMenuData();
						$(me).addClass(".favorite");
					}
				});
				
				$(this).toggleClass("icon-star icon-star-o");
				$(this).next("a.text-link").toggleClass("text-favorite");
			}
						
		})
		
	
	})
	
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
	margin-right: 106px;
	float: right;
	background-color: #d9d9d9;
	cursor:pointer;
}

.favorite {
	text-decoration:none;
	cursor:pointer;
}
.favorite2 {
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
.icon-star2:before {
    content: "\f005";
}
.icon-star2-o:before {
    content: "\f006";
}
.icon-star2-empty:before {
    content: "\e9d7";
}
.icon-star2-full:before {
    content: "\e9d9";
}
.icon-sort:before {
    content: "\f0dc";
}
.icon-unsorted:before {
    content: "\f0dc";
}

body{
	background-color:#f6f6f6;
	border-bottom:2px solid #349BD5;
}

.menu{
	font-family:'Nanum Barun Gothic';
	background-color:#f6f6f6;
	font-size:13px;
	padding-left:100px;
}
.sub-title{
	font-family:'Nanum Barun Gothic';
	font-size:14px;
	color:#0D7BBA;
	padding-bottom:5px;
	margin-bottom:10px;
}
.submenu{
	width:150px;
	/*float:left;*/
	padding:20px;
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
.icon-star2{
	 color:rgba(255, 136, 0, 1);
}
.icon-star-o{
	 color:#ddd;
}

.mymenu{
	width:350px;
	line-height:22px;
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
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="min-width:1245px;">

<%

	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//메뉴
	Vector upper_menu_list = nm_db.getXmlUpperMenuList(ck_acar_id);	
	Vector menu_vt = nm_db.getXmlMenuList(ck_acar_id);
	
	int upper_menu_size = upper_menu_list.size();
	int menu_size = menu_vt.size();
	
	String currentDiv = ""; //대메뉴에 따라  div(class="menu") 분기 처리 
	String currentUpperMenu = ""; //div 분기를 위한 보조자
	String currentSubDiv = ""; //M_ST2 값에 따라 div(class="submenu") 분기 처리
	
	for(int i=0; i<upper_menu_size; i++){
	    Hashtable upperMenu = (Hashtable)upper_menu_list.elementAt(i);
	    currentDiv = upperMenu.get("M_ST").toString();
%>
		<div id="<%=currentDiv%>" class="menu">
			<div>
			<!-- 서브 아이템 -->
		<%
			for(int j=0; j<menu_size; j++){
			    
			    Hashtable menu = (Hashtable)menu_vt.elementAt(j);
			    currentUpperMenu = menu.get("M_ST").toString();
			    
			    if(currentDiv.equals(currentUpperMenu)){
			        if(currentSubDiv.equals(menu.get("M_ST2").toString())){
		%>
						
							<%if(String.valueOf(menu.get("MYMENU_YN")).equals("Y")){%>
								<span class="icon-star favorite" param="<%=menu.get("M_ST")%>:<%=menu.get("M_ST2")%>:<%=menu.get("M_CD")%>"></span>
								&nbsp;
								<a class="page-link" href="javascript:;" param="1:<%=menu.get("M_ST")%>:<%=menu.get("M_ST2")%>:<%=menu.get("M_CD")%>:<%=menu.get("URL")%>:<%=menu.get("AUTH_RW")%>:true"><span><%=menu.get("M_NM") %></span></a>
								<!-- <a href="javascript:page_link('1','<%=menu.get("M_ST")%>','<%=menu.get("M_ST2")%>','<%=menu.get("M_CD")%>','<%=menu.get("URL")%>','<%=menu.get("AUTH_RW")%>', true)" class="text-link text-favorite">
		                                        		<%=menu.get("M_NM")%>
	                			</a> -->
	                			<br/>
							<%}else{%>
								<span class="icon-star-o favorite"  param="<%=menu.get("M_ST")%>:<%=menu.get("M_ST2")%>:<%=menu.get("M_CD")%>"></span>  
								&nbsp;
								<a class="page-link" href="javascript:;" param="1:<%=menu.get("M_ST")%>:<%=menu.get("M_ST2")%>:<%=menu.get("M_CD")%>:<%=menu.get("URL")%>:<%=menu.get("AUTH_RW")%>:true"><span><%=menu.get("M_NM") %></span></a>
								
								<!--<a href="javascript:page_link('1','<%=menu.get("M_ST")%>','<%=menu.get("M_ST2")%>','<%=menu.get("M_CD")%>','<%=menu.get("URL")%>','<%=menu.get("AUTH_RW")%>', true)" class="text-link">
		                                        		<%=menu.get("M_NM")%>	</a>-->
		                        <br/> 													
							<%}%> 						
							
		
		<%			            
			            
			        }else{
			            currentSubDiv = menu.get("M_ST2").toString();
		%>
						</div>
						<div id="sub<%=currentSubDiv%>" class="submenu" <%if(menu.get("M_NM").equals("법인카드관리") || 
							menu.get("M_NM").equals("연말정산관리") || menu.get("M_NM").equals("코드관리")){%>style="clear:both; float:left;"<%}else{%>style="float:left;"<%}%>>
								<span class="sub-title"><%=menu.get("M_NM")%></span><br/><hr/><br/>
		<%
			        }
			    }
			}
		%>
			</div>
		</div>
<%  } %>	

		<div id="12" class="menu upper-mymenu">	
			
			<div id="sub99" class="submenu mymenu  ">
				
			</div>
		</div>

<script>
	
</script>