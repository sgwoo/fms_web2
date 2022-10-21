<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 

<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body 공통 속성 */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '나눔고딕';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* 레이아웃 큰박스 속성 */
#wrap {float:left; margin:0 auto; width:100%; background-color:#fff;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%;}
#footer {float:left; width:100%; height:50px; background:#C3C3C3; margin-top:20px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle; width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}

/* 검색창 */
#search fieldset {padding:0px 0px; border:0px;}
#search .userform {width:100%; overflow:hidden; position:relative;}
#search .userform .name {float:left; position:absolute; width:100px; margin:5px 20px 0 20px;}
#search .userform .userinput {padding-right:60px; height:50px; margin:0 20px 0 85px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:25px;}

/* 리스트 */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '나눔고딕'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

td {padding:6px 0 4px 0; border:0px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

#contentsWrap { padding:0; font-size:22px;} /* padding _ top bottom */
#topListWrap { position: relative; height: 100%; }
.List li {padding:10px 21px 5px 21px;border-bottom:1px #eaeaea solid;}
.List li a {width:100%;padding:7px 0 6px;font-size:16px;color:#000;line-height:20px;font-weight:bold;}
.List li a em {color:#888;font-size:16px;}
.List .list1{float:left;margin-right:10px;}
.List .list2{height:95px;display:block;overflow:hidden;padding:0.8em 0px 0.3em;_float:left;_padding-right:1em;white-space:nowrap;text-overflow:ellipsis;}


</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.partner.*" %>

<jsp:useBean id="po_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String sostel_st 	= request.getParameter("sostel_st")==null?"1":request.getParameter("sostel_st");
	String ddept_id 		= request.getParameter("ddept_id")==null?"":request.getParameter("ddept_id");
	String dept_nm 		= request.getParameter("dept_nm")==null?"":request.getParameter("dept_nm");
%>

<style type=text/css>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #828282;
         font-size: 11px;}
.style2 {color: #ff00ff;
         font-size: 11px;} 
.style3 {color: #727272}
.style4 {color: #ef620c}
.style5 {color: #334ec5;
        font-weight: bold;} 
-->

</style>


<script language='javascript'>
<!--
	function view_sch(sch_user_nm, sch_user_id)
	{
		var fm = document.form1;		
		fm.sch_user_id.value = sch_user_id;
		fm.sch_user_nm.value = sch_user_nm;
		fm.action = 'sostel_sch_view.jsp';
		fm.submit();
	}
	
	//이전페이지
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "sostel_main.jsp";		
		fm.submit();
	}			
//-->
</script>

</head>

<body>
<form name='form1' method='post' action='sostel_list.jsp'>
<%@ include file="/smart/include/search_hidden.jsp" %>
	<input type='hidden' name='sostel_st'	value='<%=sostel_st%>'>
<!--	<input type='hidden' name='dept_id'		value='<%=dept_id%>'>
	<input type='hidden' name='dept_nm'		value='<%=dept_nm%>'> -->
	<input type='hidden' name='sch_user_nm'	value=''>
	<input type='hidden' name='sch_user_id'	value=''>

<div id="wrap">
    <div id="header">
        <div id="gnb_box">
        	
            <div id="gnb_login">연락망 - <%=dept_nm%></div>
            <div id="gnb_home">
            	<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
            	<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
            </div>
        </div>
    </div>
    <div id="contents">				
        <div id="topListWrap">
			<%if(sostel_st.equals("1")){//사원-----------------------------------------------------------
					UsersBean user_r [] = umd.getSostel_UserList(ddept_id);%>
					
			<%		if(ddept_id.equals("0002")){//고객지원팀일때 아마존카명진사무실 연락처 표시
					
						Hashtable br = umd.getBranch("S1");%>					
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:02-392-4242">02-392-4242</a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>
		    		 
		    		 
		    		 
		    		 						 
	               	  <li>
	               	 	 <span>
							<font color="#990000">[강서지점]</font> 
							<br>
							 <a href="tel:02)2636-9920">02)2636-9920</a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>													    		
		    		 
		    		 
		    		 
		    		 
	               	  <li>
	               	 	 <span>
							<font color="#990000">[부천지점]</font> 
							<br>
							 <a href="tel:02)2038-7575">02)2038-7575</a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>							
		    		 		
		    		 		
		    		 						    		

    			</ul>	 
    			   			             								
			<%		}else if(ddept_id.equals("0001")){
						Hashtable br = umd.getBranch("S1");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:02-757-0802">02-757-0802</a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("0003")){
						Hashtable br = umd.getBranch("S1");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:02-392-4243">02-392-4243</a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("0007")){
						Hashtable br = umd.getBranch("B1");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("0008")){
						Hashtable br = umd.getBranch("D1");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	
			<%		}else if(ddept_id.equals("0009")){
						Hashtable br = umd.getBranch("S2");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("0010")){
						Hashtable br = umd.getBranch("J1");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("0011")){
						Hashtable br = umd.getBranch("G1");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("0012")){
						Hashtable br = umd.getBranch("I1");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("0013")){
						Hashtable br = umd.getBranch("K3");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("0014")){
						Hashtable br = umd.getBranch("S3");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("0015")){
						Hashtable br = umd.getBranch("S4");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}else if(ddept_id.equals("16")){
						Hashtable br = umd.getBranch("U1");%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
							<%=br.get("BR_ADDR")%>
							<br>
							<a href="tel:<%=br.get("TEL")%>"><%=br.get("TEL")%></a>
						 </span>
						 <span>&nbsp;</span>
		    		 </li>						 
    			</ul>	    					
			<%		}%>
			
			
					
			<% 		if(user_r.length > 0) { %>			
			<%			for(int i=0; i<user_r.length; i++){
        					user_bean = user_r[i];%>                
                 <ul class="List">
	               	  <li>
						 <span class='list1'><img name="carImg" src="https://fms3.amazoncar.co.kr<%=user_bean.getFilename2()%><%=user_bean.getFilename()%>" border="0" width="85" height="105"></span>
						 <%if(!user_bean.getLoan_st().equals("")){%>
						 <span>&nbsp;<%if(user_bean.getLoan_st().equals("1")){%>고객지원<%}else if(user_bean.getLoan_st().equals("2")){%>영업<%}%></span>
						 <%}%>
						 <span class='list2'><font color="#990000">[<%=user_bean.getUser_pos()  %>]</font>
							<font color='#3b44bb'><b><%= user_bean.getUser_nm()%></b></font>&nbsp;
							<%if(!user_bean.getSch_chk().equals("")){%>
							&nbsp;&nbsp;<a href="javascript:view_sch('<%= user_bean.getUser_nm()%>','<%= user_bean.getUser_id()%>')" onMouseOver="window.status=''; return true"><img src=/smart/images/nc_icon.gif align=absmiddle /><%//= user_bean.getSch_chk()%></a>
							<%}%>
							<br>
							 <a href="tel:<%= user_bean.getUser_m_tel()%>"><%= user_bean.getUser_m_tel()%></a>
							 <%if(!user_bean.getHot_tel().equals("")){%>
							 <br><a href="tel:<%= user_bean.getHot_tel() %>"><%= user_bean.getHot_tel() %></a>
							 <%}%>	
						 </span>
						 <br> 		  
		    		 </li>													    		
    			</ul>	    			             	
			<%			}%>
			<%		}else{%>			
				<span>데이타가 없습니다.</span><br> 
				<span>&nbsp;</span>  
			<%		}%>
			
		
			
			<%}else{//협력업체-----------------------------------------------------------------------------
					Vector vt = po_db.getSostel_PartnerList(dept_nm);
					int vt_size = vt.size();%>
			<%		if(vt_size > 0)	{
						for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							%>
                 <ul class="List">
	               	  <li>
	               	 	 <span>
						    <%if(dept_nm.equals("자동차구매")){%>
							<font color="#990000">[<%=ht.get("PO_NM")%>]</font> 
							<%=ht.get("PO_OWN")%>
						    <%}else if(dept_nm.equals("협력업체")){%>
							<font color="#990000">[<%=ht.get("PO_STA")%>]</font> 
							<%=ht.get("PO_NM")%> <%=ht.get("PO_OWN")%>
						    <%}else if(dept_nm.equals("긴급출동")){%>
							<font color="#990000">[<%=ht.get("PO_STA")%>]</font> 
							<%=ht.get("PO_NM")%>
							<%}else{%>
							<font color="#990000">[<%=ht.get("PO_NM")%>]</font> 
							<%=ht.get("PO_OWN")%>
							<%}%>
							<br>
							 <%if(!dept_nm.equals("긴급출동")){%>	
							 <a href="tel:<%=ht.get("PO_M_TEL")%>"><%=ht.get("PO_M_TEL")%></a>
							 <%		if(!String.valueOf(ht.get("PO_M_TEL")).equals("")){%>
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <%		}%>							 
							 <%}%>
							 <a href="tel:<%=ht.get("PO_O_TEL")%>"><%=ht.get("PO_O_TEL")%></a>
							 <%if(dept_nm.equals("자동차구매") && !String.valueOf(ht.get("PO_AGNT_NM")).equals("")){%>
							 <br>
							 계출담당자 : <%=ht.get("PO_AGNT_NM")%><%if(!String.valueOf(ht.get("PO_AGNT_O_TEL")).equals(String.valueOf(ht.get("PO_O_TEL")))){%>&nbsp;<a href="tel:<%=ht.get("PO_O_TEL")%>"><%=ht.get("PO_AGNT_O_TEL")%></a><%}%>
							 <%}else if(dept_nm.equals("협력업체") && !String.valueOf(ht.get("PO_AGNT_NM")).equals("")){%>
							 <br>
							 담당자 : <%=ht.get("PO_AGNT_NM")%><%if(!String.valueOf(ht.get("PO_AGNT_O_TEL")).equals(String.valueOf(ht.get("PO_O_TEL")))){%>&nbsp;<a href="tel:<%=ht.get("PO_O_TEL")%>"><%=ht.get("PO_AGNT_O_TEL")%></a><%}%>
							 <%}%>
						 </span><br> 
						 <span>&nbsp;</span>
		    		 </li>													    		
    			</ul>	    			             								
			<%			}%>
			<%		}else{%>			
				<span>데이타가 없습니다.</span><br> 
				<span>&nbsp;</span>  
			<%		}%>		
			<%}%>
               <span>&nbsp;</span>  
	    </div> 		
	</div>  
    <div id="footer"></div>  
</div>
</form>
</body>
</html>