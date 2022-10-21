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
.contents_box th {color:#282828; height:22px; text-align:left; font-weight:bold;}
.contents_box td {line-height:22px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:22px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font:13px; margin:5px 0px;}
.contents_box1 th {color:#282828; width:50px; height:22px; text-align:left; font-weight:bold; line-height:24px;}
.contents_box1 td {line-height:24px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:24px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/smart/cookies.jsp" %> 

<%
	
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
function ScheReg()
{
	var fm = document.form1;
	if(fm.title.value == ''){	alert("제목을 선택하십시오.");	return;	}
	if(get_length(fm.content.value) > 4000){alert("4000자 까지만 입력할 수 있습니다."); return; }

	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	fm.target = "i_no";
	fm.submit();
}

function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}

function date_type_input(date_type){
		var fm = document.form1;
		var today = new Date();
		var s_y = "";
		var s_m = "";
		var s_d = "";				
		var dt = today;
		if(date_type==2){//내일			
			dt = new Date(today.valueOf()+(24*60*60*1000));
		}
		s_y = String(dt.getYear());
		if(dt.getYear()<2000) s_y = String(dt.getFullYear()+1900);
		s_m = String(dt.getMonth()+1);
		s_d = String(dt.getDate());
		fm.start_year.value = s_y;		
		fm.start_mon.value 	= s_m;		
		fm.start_day.value 	= s_d;		
	}	
//-->
</script>

</head>

<body>
<form name='form1' method='post' action='sch_reg_a.jsp'>
<input type='hidden' name="sch_chk" value="2">
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">현지출근등록</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
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
						<tr>
							<th></th>
							<td><input type='radio' name="date_type" value='1' checked onClick="javascript:date_type_input(1)">오늘
								<input type='radio' name="date_type" value='2'  onClick="javascript:date_type_input(2)">내일
							</td>
						</tr>								
							<th>일자</th>
							<td>
								<select name="start_year">
			        			  <%for(int i=2009; i<=AddUtil.getDate2(1); i++){%>
			                        <option value="<%=i%>" <%if(AddUtil.getDate2(1) == i)%>selected<%%>><%=i%></option>
			        			  <%}%>
			                      </select>년			
			                      <select name="start_mon">
			        			  <%for(int i=1; i<13; i++){%>
			                        <option value="<%=i%>" <%if(AddUtil.getDate2(2) == i)%>selected<%%>><%=i%></option>
			        			  <%}%>
			                      </select>월			
			                      <select name="start_day">
			        			  <%for(int i=1; i<32; i++){%>
			                        <option value="<%=i%>" <%if(AddUtil.getDate2(3) == i)%>selected<%%>><%=i%></option>
			        			  <%}%>
			                      </select>일						  			  
			       			</td>
						</tr>		
						<tr>
							<th>제목</th>
							<td><textarea name='title' rows='5' cols='30'></textarea></td>
						</tr>													
						<tr>
							<th>내용</th>
							<td><textarea name='content' rows='10' cols='30'></textarea></td>
						</tr>
						<tr>
							<td style='height:10px;'></td>
						</tr>	
						<tr>
							<th>&nbsp;</th>
							<td valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:ScheReg()"><img src='/smart/images/btn_reg.gif' align=absmiddle /></a></td>
						</tr>					
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
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</body>
</html>
