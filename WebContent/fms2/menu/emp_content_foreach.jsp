<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %> 
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<html>
<head>
<title>:: FMS(Fleet Management System) ::</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/sub.css">

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<style>
@import url(//cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothic.css);
.menu{
	font-family:'Nanum Barun Gothic' !important;
	background-color:#555;
	display:none;
	font-size:12px;
	padding-left:160px;
}
a:link{
	
	color:#fff !important;
}
ul{
	font-family:'NanumBarunGothic' !important;
	display:inline-table;
	list-style-type: none;
}
</style>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%

	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//메뉴
	Vector upper_menu_list = nm_db.getXmlUpperMenuList(ck_acar_id);	
	Vector menu_vt = nm_db.getXmlMenuList(ck_acar_id);
	
	int upper_menu_size = upper_menu_list.size();
	int menu_size = menu_vt.size();
	
	String currentDiv = ""; //대메뉴에 따라 div 분기처리 
	String currentUpperMenu = ""; //div 분기를 위한 보조자
	String currentUl = ""; //M_ST2 값에 따라 ul 분기처리
	
	for(int i=0; i<upper_menu_size; i++){
	    Hashtable upperMenu = (Hashtable)upper_menu_list.elementAt(i);
	    currentDiv = upperMenu.get("M_ST").toString();
%>
		<div id="<%=currentDiv%>" class="menu">
			
		
<%	
		for(int j=0; j<menu_size; j++){
		    
		    Hashtable menu = (Hashtable)menu_vt.elementAt(j);
		    currentUpperMenu = menu.get("M_ST").toString();
		    
		    if(currentDiv.equals(currentUpperMenu)){ 
		        if(!currentUl.equals(menu.get("M_ST2").toString())) { // ul 분기처리
		            if(currentUl != ""){ //최초에는 앞의 ul을 닫아줄 필요 없음
%>
						</ul>
<%		                
		            }
		            currentUl = menu.get("M_ST2").toString();
%>
						<ul id="sub<%=currentUl%>">
<%
		        }
		        if(menu.get("M_CD").toString().equals("00")){ //대메뉴거나 서브메뉴 타이틀인 경우
%>
					
<% 				}
%>
				<li>
					<a href="javascript:page_link('<%=menu.get("M_ST")%>','<%=menu.get("M_ST2")%>','<%=menu.get("M_CD")%>','<%=menu.get("URL")%>','<%=menu.get("AUTH_RW")%>', true)">
                                        		<%=menu.get("M_NM")%>
                	</a>
                </li>
<%	    	
		    }
		}
%>
		</div>
<%
	}
	
%>
</body>
</html>