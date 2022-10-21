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
#wrap {float:left; margin:0 auto; width:100%; background-color:#322719;}
#header {float:left; width:100%; height:43px; margin-bottom:30px;}
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
.contents_box1 th {color:#282828; width:85px; height:22px; text-align:left; font-weight:bold; line-height:24px;}
.contents_box1 td {line-height:24px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:24px; color:#7f7f7f; font-weight:bold;}


/* 제목테이블 */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


.dj_list {width:90%; text-align:center; border-bottom:2px solid #c18d44; border-top:1px solid #c18d44; font:11px Tahoma;}
.dj_list th {padding:7px 0 4px 0;  border-top:1px solid #c18d44; border-right:1px solid #c18d44; font:14px NanumGothic; font-weight:bold; color:#f09310; height:30px;}
.dj_list td {padding:6px 0 4px 0; border-top:1px solid #c18d44;  font:14px NanumGothic; color:#e4ddd4; font-weight:bold; height:30px;}

</style>

</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.car_sche.*" %>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarSchDatabase schedule = CarSchDatabase.getInstance();
	
	Vector vt = new Vector();
	int vt_size = 0;
	
	
	String dt1 		= AddUtil.getDate();
	String r_dt1 	= af_db.getValidDt(dt1);
	
	String dt2 		= c_db.addDayBr(r_dt1, 1);
	String r_dt2 	= af_db.getValidDt(dt2);
	
	//휴가현황
	if(dt1.equals(r_dt1) && dt2.equals(r_dt2)){
		vt = schedule.getCarSchStat();
		vt_size = vt.size();
	}else{
		vt = schedule.getCarSchStat(r_dt1, r_dt2);
		vt_size = vt.size();
	}
	
	int total_cnt1 	= 0;
	int total_cnt2 	= 0;
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
	function view_info(dt_st, dept_nm, dept_id)
	{
		var fm = document.form1;		
		fm.dt_st.value 		= dt_st;
		fm.dept_nm.value 	= dept_nm;				
		fm.dept_id2.value 	= dept_id;						
		fm.action = "sch_stat_4_list.jsp";		
		fm.submit();
	}
//-->
</script>

</head>

<body>
<form name='form1' method='post' action='sch_stat_4.jsp'>
<input type='hidden' name="dt_st" value="">
<input type='hidden' name="dept_nm" value="">
<input type='hidden' name="dept_id2" value="">
<input type='hidden' name="dt1" value="<%=dt1%>">
<input type='hidden' name="dt2" value="<%=dt2%>">
<input type='hidden' name="r_dt1" value="<%=r_dt1%>">
<input type='hidden' name="r_dt2" value="<%=r_dt2%>">
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">휴가현황</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">	
    	<div class="dj_list" style="margin:0 auto;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
    			<tr>
    				<th width=85><font color="#c28835">구분</font></th>
    				<td><font color="#f09310">오늘<%if(!dt1.equals(r_dt1)){%><br><%=r_dt1%><%}%></font></td>
    				<td><font color="#f09310">내일<%if(!dt1.equals(r_dt1)||!dt2.equals(r_dt2)){%><br><%=r_dt2%><%}%></font></td>
    			</tr>
				<%	for(int i=0; i<  vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						total_cnt1 += AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
						total_cnt2 += AddUtil.parseInt(String.valueOf(ht.get("CNT2")));%>				
    			<tr>
    				<th><%=ht.get("NM")%></th>
    				<td><a href="javascript:view_info('0','<%=ht.get("NM")%>','<%=ht.get("CODE")%>')" onMouseOver="window.status=''; return true"><font color="#c28835"><%=ht.get("CNT1")%></font></a></td>
    				<td><a href="javascript:view_info('1','<%=ht.get("NM")%>','<%=ht.get("CODE")%>')" onMouseOver="window.status=''; return true"><font color="#c28835"><%=ht.get("CNT2")%></font></a></td>
    			</tr>
				<%	}%>
    			<tr>
    				<th><font color="#d3f010">합계</font></th>
    				<td><a href="javascript:view_info('0','오늘','')" onMouseOver="window.status=''; return true"><font color="#d3f010"><%=total_cnt1%></font></a></td>
    				<td><a href="javascript:view_info('1','내일','')" onMouseOver="window.status=''; return true"><font color="#d3f010"><%=total_cnt2%></font></a></td>
    			</tr>
    		</table>
    	</div>   			
	</div>	
    <div id="footer"></div>  
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</body>
</html>
