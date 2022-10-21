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
.contents_box1 th {color:#282828; width:80px; height:22px; text-align:left; font-weight:bold; line-height:24px;}
.contents_box1 td {line-height:24px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:24px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_sche.*, acar.user_mng.*" %>
<%@ include file="/smart/cookies.jsp" %> 

<%
	CarSchDatabase schedule = CarSchDatabase.getInstance();
	
	String dt_st 		= request.getParameter("dt_st")==null?"0":request.getParameter("dt_st");
	String dept_nm 		= request.getParameter("dept_nm")==null?"":request.getParameter("dept_nm");
	String dept_id2 	= request.getParameter("dept_id2")==null?"":request.getParameter("dept_id2");
	
	String dt1 			= request.getParameter("dt1")==null?"":request.getParameter("dt1");
	String r_dt1 		= request.getParameter("r_dt1")==null?"":request.getParameter("r_dt1");
	String dt2 			= request.getParameter("dt2")==null?"":request.getParameter("dt2");
	String r_dt2 		= request.getParameter("r_dt2")==null?"":request.getParameter("r_dt2");
	
	
	Vector vt = new Vector();
	int vt_size = 0;
	
	
	//휴가현황
	if(dt1.equals(r_dt1) && dt2.equals(r_dt2)){
		vt = schedule.getCarSchDeptStatList(dt_st, dept_id2);
		vt_size = vt.size();
	}else{
		if(dt_st.equals("0")){//오늘
			vt = schedule.getCarSchDeptStatList(dt_st, dept_id2, r_dt1);
		}else{//다음날
			vt = schedule.getCarSchDeptStatList(dt_st, dept_id2, r_dt2);
		}
		vt_size = vt.size();
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
		s_y = String(dt.getFullYear());
		if(dt.getFullYear()<2000) s_y = String(dt.getFullYear()+1900);
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
			<div id="gnb_login"><%=dept_nm%> 
				<%if(dt_st.equals("0") && !dt1.equals(r_dt1)){%><%=r_dt1%> <%}%> 
				<%if(dt_st.equals("1") && (!dt1.equals(r_dt1)||!dt2.equals(r_dt2))){%><%=r_dt2%> <%}%> 
				휴가현황
			</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">	
			<%	for(int i=0; i<  vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);;%>				
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>연&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;번</th>
							<td><font color="#fd5f00"><%=i+1%></font></td>
						</tr>
						<tr>
							<th>성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</th>
							<td><a href="tel:<%=ht.get("USER_M_TEL")%>"><%=ht.get("USER_NM")%></a></td>
						</tr>													
						<tr>
							<th>급&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;여</th>
							<td><%=ht.get("OV_YN")%></td>
						</tr>	
						<tr>
							<th>휴가구분</th>
							<td><%=ht.get("SCH_CHK")%>
							<%if(String.valueOf(ht.get("GJ_CK")).equals("결재전")){%>
							(예정)
							<%}%>
							</td>
						</tr>
						<tr>
							<th>휴가기간</th>
							<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DATE")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DATE")))%></td>
						</tr>	
						<tr>
				    		<th>대체근무자</th>
				    		<td><a href="tel:<%=ht.get("WORK_M_TEL")%>"><%=ht.get("WORK_NM")%></a></td>
				    	</tr>										
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>									
			<%	}%>
			<%	if(vt_size == 0 ){%>
    	<div id="ctable">			
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>데이타가 없습니다.</th>
						</tr>
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>			
		</div>						
			<%	}%>
	</div>	
    <div id="footer"></div>  
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</body>
</html>
