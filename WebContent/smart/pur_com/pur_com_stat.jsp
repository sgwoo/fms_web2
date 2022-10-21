<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />

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
#header {float:left; width:100%; height:43px; margin-bottom:20px;}
#contents {float:left; width:100%; height:100% margin:0 auto;}
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

.btn {width:90%; margin:0 auto; margin-bottom:10px;}

.dj_list {width:90%; text-align:center; border-bottom:2px solid #c18d44; border-top:1px solid #c18d44; font:11px Tahoma; margin-bottom:20px;}
.dj_list th {padding:7px 0 4px 0;  border-top:1px solid #c18d44; border-right:1px solid #c18d44; font:14px NanumGothic; font-weight:bold; color:#f09310; height:30px;}
.dj_list td {padding:6px 0 4px 0; border-top:1px solid #c18d44;  font:14px NanumGothic; color:#e4ddd4; font-weight:bold; height:30px;}
.dj_list a{padding:5px 5px;}

</style>

</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.car_office.*" %>
<%@ include file="/smart/cookies.jsp" %> 

<%
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	Vector vt = umd.getPurComBusList();
	int vt_size = vt.size();
		
	
	int total_su1 	= 0;
	int total_su2 	= 0;
	
%>



<script language='javascript'>
<!--
	function view_info(st, bus_nm)
	{
		var fm = document.form1;		
		fm.gubun3.value = st;
		if(bus_nm != ''){
			fm.s_kd.value = '4';
			fm.t_wd.value = bus_nm;
		}else{
			fm.s_kd.value = '1';
			fm.t_wd.value = '';
		}						
		fm.action = "pur_com_list.jsp";		
		fm.submit();
	}
			
	
//-->
</script>

</head>

<body>
<form name='form1' method='post' action='pur_com_list.jsp'>
<input type='hidden' name='s_kd'  	value=''>
<input type='hidden' name='t_wd' 	value=''>			
<input type='hidden' name='sort'	value=''>
<input type='hidden' name='gubun1' 	value=''>  
<input type='hidden' name='gubun2' 	value=''>  
<input type='hidden' name='gubun3' 	value=''>  
<input type='hidden' name='st_dt' 	value=''>  
<input type='hidden' name='end_dt' 	value=''>  
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">영업담당자별 특판계출현황</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">	
    	<!--본사영업팀일때-->
    	<div class="btn"><img src=/smart/images/btn_bs_yu.gif /></div>
    	<div class="dj_list" style="margin:0 auto; margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0001")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='배정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10001&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20001&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>  
    	<!--본사고객지원팀 일때-->
    	<div class="btn"><img src=/smart/images/btn_bs_gg.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0002")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10002&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20002&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	<!--부산지점일때-->
    	<div class="btn"><img src=/smart/images/btn_ps.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0007")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10007&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20007&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	<!--대전지점일때-->
    	<div class="btn"><img src=/smart/images/btn_dj.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0008")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10008&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20008&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	
<!--강남지점일때-->
    	<div class="btn"><img src=/smart/images/btn_gn.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0009")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10009s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20009&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	 	
<!--광주-->
    	<div class="btn"><img src=/smart/images/btn_kj.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0010")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10010&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20010&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	 	
<!--대구-->
    	<div class="btn"><img src=/smart/images/btn_dk.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0011")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10011&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20011&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	 	
<!--인천-->
    	<div class="btn"><img src=/smart/images/btn_ic.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0012")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10012&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20012&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	 	
<!--수원-->
    	<div class="btn"><img src=/smart/images/btn_sw.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0013")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10013&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20013&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	 	
<!--강서-->
    	<div class="btn"><img src=/smart/images/btn_ks.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0014")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10014&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20014&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	 	
<!--구로-->
    	<div class="btn"><img src=/smart/images/btn_gr.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0015")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10015&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20015&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
    	 	
<!--울산-->
    	<div class="btn"><img src=/smart/images/btn_us.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0016")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10016&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20016&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
 <!--종로-->
    	<div class="btn"><img src=/smart/images/btn_jr.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0017")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10016&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20016&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
    		    </tr>
    		</table>
    	</div>      	
<!--송파-->
    	<div class="btn"><img src=/smart/images/btn_sp.gif /></div>
    	<div class="dj_list" style="margin:0 auto;  margin-bottom:25px;">
    		<table border="0" width=100% cellspacing=0 cellpadding=0>
                    <tr> 
                        <th><font color="#c28835">이름</font></td>                                        
                        <td><font color="#f09310">예정</font></td>
                        <td><font color="#f09310">배정</font></td>
                    </tr>
		    <%	total_su1 = 0;
		     	total_su2 = 0;
		    	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(!String.valueOf(ht.get("DEPT_ID")).equals("0018")) continue;
				total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
				total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                    %>				
                    <tr> 
                        <th><%=ht.get("USER_NM")%></td>                    
                        <td><a href="pur_com_list.jsp?gubun3=1&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고예정 보기'><font color="#c28835"><%=ht.get("DLV_ST1_CNT")%><font color="#c28835"></a></td>
                        <td><a href="pur_com_list.jsp?gubun3=2&s_kd=4&t_wd=<%=ht.get("USER_NM")%>" title='출고확정 보기'><font color="#c28835"><%=ht.get("DLV_ST2_CNT")%><font color="#c28835"></a></td>
                    </tr>                      
		    <%	}%>
    		    <tr>
    			<th><font color="#d3f010">합계</font></th>
    			<td><a href="pur_com_list.jsp?gubun3=10016&s_kd=1&t_wd="><font color="#d3f010"><%=total_su1%></font></a></td>
    			<td><a href="pur_com_list.jsp?gubun3=20016&s_kd=1&t_wd="><font color="#d3f010"><%=total_su2%></font></a></td>
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
