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
#search .userform .title {float:left; margin-right:10px; height:40px;}
#search .userform .name { margin:0 20px 0 45px;}
#search .userform .userinput {padding-right:50px; height:40px; margin:0 20px 0 50px;}
#search .userform .userinput input.text {border:1px solid #c9c9c9; width:100%; height:23px; font-weight:bold; font-size:0.95em; vertical-align:top;}
#search .userform .submit {float:left; position:absolute; right:0; top:0; padding-right:20px;}

/* UI Object */

.srch{width:100%;padding:5px 0}
.srch legend{overflow:hidden;visibility:hidden;position:absolute;top:0;left:0;width:1px;height:1px;font-size:0;line-height:0}
.srch{color:#c4c4c4;text-align:center}
.srch select,.srch input{margin:-1px 0 1px;font-size:12px;color:#373737;vertical-align:middle}
.srch .keyword{margin-left:1px;padding:2px 3px 5px;border:1px solid #b5b5b5;font-size:12px;line-height:15px}
.srch .white{margin-left:1px;padding:2px 3px 5px;border:0px solid #b5b5b5;font-size:12px;line-height:15px}
/* //UI Object */


/* 리스트 */
.search_list {width:100%; text-align:center; border-bottom:2px solid #b0baec; border-collapse:collapse;}
.search_list caption {display:none;}
.search_list th {padding:7px 0 4px 0; background-color:#e2e7ff; border-top:2px solid #b0baec; border-left:1px solid #b0baec; border-right:1px solid #b0baec; border-bottom:1px solid #b0baec; font-size:14px; font-family:NanumGothic, '나눔고딕'; font-weight:bold; color:#666666;}
.search_list td {padding:6px 0 4px 0; border:1px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

td {padding:6px 0 4px 0; border:0px solid #b0baec; color:#4C4C4C#  font-size:14px; font-family:NanumGothic, '나눔고딕';}

#contentsWrap { padding:0; font-size:22px;} /* padding _ top bottom */
#topListWrap { position: relative; height: 100%; }
.List li {padding:0 21px;border-bottom:1px #eaeaea solid;}
.List li a {width:100%;padding:2px 0 3px;font-size:16px;color:#000;line-height:17px;font-weight:bold;display:block;}
.List li a em {color:#888;font-size:16px;}
.List .list1{float:left;margin-right:10px;}
.List .list2{height:33px;display:block;overflow:hidden;padding:0.8em 0px 0.3em;_float:left;_padding-right:1em;white-space:nowrap;text-overflow:ellipsis;}
</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_ls_hpg.*"%>
<jsp:useBean id="oh_db" scope="page" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//차종(기본) 정렬
	sort = "";
	
	Vector secondhandList = oh_db.getSecondhandList_20100930(gubun1, sort);	
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
	function search(){
		var fm = document.form1;
//		fm.sort.value = '';		
		fm.target =  "_self";
		fm.action =  "rlscar_list.jsp";
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	/*
	function sort_search(list_sort){
		var fm = document.form1;
		fm.sort.value = list_sort;
		fm.target =  "_self";
		fm.action =  "rlscar_list.jsp";
		fm.submit();		
	}
	*/
	
	function view_car(rent_mng_id, rent_l_cd, car_mng_id, car_no)
	{
		var fm = document.form1;
		fm.rent_mng_id.value 	= rent_mng_id;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.car_mng_id.value 	= car_mng_id;
		fm.car_no.value 		= car_no;
		fm.target =  "_self";
		fm.action = 'rlscar_main.jsp'
		fm.submit();
	}

	function view_before()
	{
		var fm = document.form1;		
		fm.action = "/smart/esti/esti_main.jsp";		
		fm.submit();
	}	

	 function view_car2(rent_mng_id, rent_l_cd, car_mng_id, car_no) {//2012-09-26 수정 
        var fm = document.form1;
        window.open('blank', "detail", 'width=1024,height=800,status=no,scrollbars=yes,resizable=yes');
        fm.method = "post";
        fm.action = 'rlscar_main.jsp?rent_mng_id='+rent_mng_id+'&rent_l_cd='+rent_l_cd+'&car_mng_id='+car_mng_id+'&car_no='+car_no;
        fm.target = "detail";
        fm.submit();    
    }	
//-->
</script>

</head>

<body>
<table width=100% border=0 cellspacing=0 cellpadding=0>
<form name='form1' method='post' action='rlscar_list.jsp'>
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>    
	<input type='hidden' name='from_page'	value='<%=from_page%>'>
	<input type='hidden' name='sort' 		value=''>    
	<input type='hidden' name='rent_mng_id' value=''>
	<input type='hidden' name='rent_l_cd' 	value=''>
	<input type='hidden' name='car_mng_id' 	value=''>
	<input type='hidden' name='car_no' 		value=''>
	

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">재리스차량리스트</div>
            <div id="gnb_home">
				<%if(from_page.equals("esti_main.jsp")){%>
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<%}%>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
 	 
    <div id="contents">		
    	<div id="search">
	        <fieldset>
	        	<div class="userform">
		        	<div class="title">차종:</div>		
					<div class="userinput"><select name="gubun1">
	                      		<option value=""  <% if(gubun1.equals("")) out.print("selected"); %>>전체 </option>
								<option value="8" <% if(gubun1.equals("8")) out.print("selected"); %>>소형승용(LPG)</option>
							    <option value="5" <% if(gubun1.equals("5")) out.print("selected"); %>>중형승용(LPG)</option>
							    <option value="4" <% if(gubun1.equals("4")) out.print("selected"); %>>대형승용(LPG)</option>
							    <option value="3" <% if(gubun1.equals("3")) out.print("selected"); %>>소형승용(가솔린,디젤)</option>
							    <option value="2" <% if(gubun1.equals("2")) out.print("selected"); %>>중형승용(가솔린,디젤)</option>
							    <option value="1" <% if(gubun1.equals("1")) out.print("selected"); %>>대형승용(가솔린)</option>
							    <option value="6" <% if(gubun1.equals("6")) out.print("selected"); %>>RV및기타 </option>																  		
							    <option value="7" <% if(gubun1.equals("7")) out.print("selected"); %>>수입차 </option>																		
		                    		</select>
					</div>										        
					<div class="submit"><a onClick='javascript:window.search();' style='cursor:hand'><img src="/smart/images/btn_srch.gif" alt="검색" value="검색"></a></div>
					</div>
				</div>	
			</fieldset>		
		</div>	
		   
        <tbody>	
           <%	for(int i=0; i < secondhandList.size(); i++){
					Hashtable secondhand = (Hashtable)secondhandList.elementAt(i);%>
                <ul class="List">
	               	  <li> <span>&nbsp;</span>  
	               	  	  <a href="javascript:view_car2('<%=secondhand.get("RENT_MNG_ID")%>', '<%=secondhand.get("RENT_L_CD")%>', '<%=secondhand.get("CAR_MNG_ID")%>', '<%=secondhand.get("CAR_NO")%>')" onMouseOver="window.status=''; return true">
		               	  		<span class='list1'><img src="https://fms3.amazoncar.co.kr/images/carImg/<% if(String.valueOf(secondhand.get("IMGFILE6")).equals("")) out.print("../../images/no_photo"); else out.print(secondhand.get("IMGFILE6")); %>.gif" width=76 height=65 border=0 align=absmiddle></span>
						  </a>
		                  <a href="javascript:view_car2('<%=secondhand.get("RENT_MNG_ID")%>', '<%=secondhand.get("RENT_L_CD")%>', '<%=secondhand.get("CAR_MNG_ID")%>', '<%=secondhand.get("CAR_NO")%>')" onMouseOver="window.status=''; return true">               
		               	  <span><%= secondhand.get("CAR_JNM") %><%= secondhand.get("CAR_NM") %></span>
		               	  <span class='list2'>
						  	<font color="#990000"><%=secondhand.get("CAR_NO")%><%//=secondhand.get("AB_CAR_NO")%></font>
		               	  	<% if ( secondhand.get("SITUATION").equals("상담중") ) {%><img src=/smart/images/sh_icon.gif align=absmiddle>
							<%}else if ( secondhand.get("SITUATION").equals("예약가능")&&(secondhand.get("RENT_ST").equals("사고대차")||secondhand.get("RENT_ST").equals("정비대차")||secondhand.get("RENT_ST").equals("보험대차")||secondhand.get("RENT_ST").equals("지연대차") )) {%><img src=/smart/images/sh_icon_dc.gif align=absmiddle>
							<%} %>
						  </span>
						  </a>	 
	                      <span>
						  	주행거리: &nbsp;<%= AddUtil.parseDecimal((String)secondhand.get("REAL_KM")) %>&nbsp;km&nbsp;<font color="#aeaeae"> | </font>&nbsp; 대여료: &nbsp;	                       
						  <%if(String.valueOf(secondhand.get("FEE_AMT")).equals("0") || String.valueOf(secondhand.get("FEE_AMT")).equals("-1")){%>
						  <%	if(String.valueOf(secondhand.get("FEE_AMT_30")).equals("0") || String.valueOf(secondhand.get("FEE_AMT_30")).equals("-1")){%>
						  		
						  <%	}else{%>
						  <font color="#990000"><%= AddUtil.parseDecimal((String)secondhand.get("FEE_AMT_30")) %></font>
						  <%	}%>																				  
						  <%}else{%>
						  <font color="#990000"><%= AddUtil.parseDecimal((String)secondhand.get("FEE_AMT")) %></font>
						  <%}%>	
						  <br>
						  <%	Vector sr = oh_db.getShResList(String.valueOf(secondhand.get("CAR_MNG_ID")));
								int sr_size = sr.size();
								if(sr_size>0)	out.println("<font color=blue>[예약]</font>");
								for(int j = 0 ; j < sr_size ; j++){
									Hashtable sr_ht = (Hashtable)sr.elementAt(j);%>	
								<%=j+1%>순위-<%= sr_ht.get("USER_NM") %>
								<%if(j==0){%>(<%=sr_ht.get("RES_END_DT")%> 								
								<% if ( sr_ht.get("SITUATION").equals("0") ) {%>상담중
								<% }else if ( sr_ht.get("SITUATION").equals("2") ) {%>계약확정
								<% }%>
								)
								<%}%>
								&nbsp;
						  <%	}%>
						 </span>						 									
               		 </li>
               </ul>		
          <%	}%> 
		  <%if(secondhandList.size()==0){%>
                <ul class="List">
	               	  <li><span>&nbsp;</span>     
						 <span>데이타가 없습니다.</span>     				 									
               		 </li>
               </ul>				  
		  <%}%>
    		  <span>&nbsp;</span>      	     
		</tbody>		
	</div>    
</div>
</form>
</table>
</body>
</html>