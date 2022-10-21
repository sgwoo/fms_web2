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
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* 메뉴아이콘들 */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* 로고 */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}


/* 둥근테이블 시작 */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}

/* 내용테이블 */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:18px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font:13px; margin:5px 5px;}
.contents_box1 th {color:#282828; height:26px; text-align:left; font-weight:bold;}
.contents_box1 td {line-height:18px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:18px; color:red; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/smart/cookies.jsp" %>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String bus_id2 		= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String s_item 		= request.getParameter("s_item")==null?"":request.getParameter("s_item");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //계약건수
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
		
	//String mode = "client";
	
	Vector memos = new Vector();
	int memo_size = 0;
	
	if(mode.equals("client")){
		memos = af_db.getFeeMemoClient("", "", client_id);
		memo_size = memos.size();
	}else{
		memos = af_db.getFeeMemoClient(rent_mng_id, rent_l_cd, "");
		memo_size = memos.size();
	}
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

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function date_type_input(date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";		
		var dt = today;

		if(date_type==2){//내일			
			dt = new Date(today.valueOf()+(24*60*60*1000));
		}else if(date_type == 3){
			dt = new Date(today.valueOf()+(24*60*60*1000)*2);						
		}else if(date_type == 4){
			dt = new Date(today.valueOf()+(24*60*60*1000)*3);						
		}else if(date_type == 0){
			dt = new Date(today.valueOf()-(24*60*60*1000));						
		}
		
		s_dt = String(dt.getFullYear())+"-";		
		if(dt.getFullYear()<2000) s_dt = String(dt.getFullYear()+1900)+"-";
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		
		fm.reg_dt.value = s_dt;		
	}		
		
	function save()
	{
		if(confirm('등록하시겠습니까?'))
		{
			var fm = document.form1;
			if((fm.reg_dt.value == ''))			{	alert('등록일을 확인하십시오');	return;	}
			else if(fm.speaker.value == '')		{	alert('담당자를 확인하십시오');	return;	}
			else if(fm.content.value == '')		{	alert('메모내용을 확인하십시오');	return;	}
			
			fm.target='i_no';
			fm.action='settle_credit_memo_a.jsp';
			fm.submit();
		}
	}
	
	function view_before()
	{
		var fm = document.form1;		
		fm.action = "settle_credit_main.jsp";		
		if(fm.from_page.value == 'fms_menu.jsp') 	fm.action = '/smart/fms/settle_item_list.jsp';
		if(fm.from_page.value == 'cont_menu.jsp') 	fm.action = '/smart/fms/settle_item_list.jsp';
		fm.submit();
	}		
	
//-->
</script>

</head>

<body>
<form name='form1' method='post' action=''>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='bus_id2' 	value='<%=bus_id2%>'>
	<input type='hidden' name='s_item' 		value='<%=s_item%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>
	<input type='hidden' name='mode' 		value='<%=mode%>'>
	<input type='hidden' name='from_page' 	value='<%=from_page%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	


<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">
				<%=firm_nm%> 채권관리
			</div>
			<div id="gnb_home">
				<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>
				<a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a>
			</div>
        </div>
    </div>
    <div id="contents">	
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">							
						<tr>
							<th width="50">작성일</th>
							<td>
								<input type="text" name="reg_dt" size="11" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'>
								<input type='radio' name="date_type1" value='3' onClick="javascript:date_type_input(0)">어제
								<input type='radio' name="date_type1" value='2' onClick="javascript:date_type_input(1)" checked>오늘
        			  		</td>
						</tr>						
						<tr>
							<th>담당자</th>
							<td>
								<input type='text' name='speaker' size='30' class='text' style='IME-MODE: active'>
							</td>
						</tr>	
						<tr>
							<th>내용</th>
							<td><textarea name='content' rows='3' cols='30' class='text' onKeyUp="javascript:checklen(2)" style='IME-MODE: active'></textarea>							
							</td>
						</tr>	
						<tr>
							<td height=10  colspan=2></td>
						</tr>						
						<tr>
							<td colspan='2' valign=bottom align="center"><a href="javascript:save()"><img src='/smart/images/btn_reg.gif' align=absmiddle /></a></td>
						</tr>					
												
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div> 			
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle">통화내용</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">
				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">							
						<%	for(int i = 0 ; i < memo_size ; i++){
								FeeMemoBean memo = (FeeMemoBean)memos.elementAt(i);%>				  
						<tr>
							<th width="50"><%=c_db.getNameById(memo.getReg_id(), "USER")%></th>
							<td>
							<%=memo.getReg_dt()%> <font color=#fd5f00><%=memo.getSpeaker()%></font>
							<br>
							<%=Util.htmlBR(memo.getContent())%>
							</td>
						</tr>	
						<%		if(i+1 < memo_size){%>	
						<tr>
							<td colspan=2 height=1 bgcolor=#b0b0b0></td>
						</tr>						
						<%		}%>							
						<%	}%>	
						<%	if(memo_size==0){%>
						<tr>
							<th valign=top>데이타가 없습니다.</th>
						</tr>
						<%	}%>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div> 
	</div>	
    <div id="footer"></div>  
</div>
</form>
<script language='javascript'>
<!--
	date_type_input(1);
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</body>
</html>