<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">

<head>

<title>Mobile_FMS_Search_Cont</title>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<link rel=stylesheet type="text/css" href="/smart/include/css_stat.css">
<link rel=stylesheet type="text/css" href="/smart/include/css_calendar.css">
<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='JavaScript' src='/smart/include/calendar.js'></script>
<script language='javascript'>
<!--
	function view_before()
	{
		var fm = document.form1;
		fm.mode.value = '';	
		fm.gubun2.value = '';	
		fm.gubun3.value = '';
		fm.gubun4.value = '';		
		fm.action = "rent_cont_stat.jsp";		
		fm.submit();
	}
//-->
</script>
</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/smart/cookies.jsp" %>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	int cnt[]	 = new int[14];		
%> 


<body>
<form name='form1' method='post' action='rent_cont_stat.jsp' id="sortdata1">
	<input type='hidden' name="s_width" 	value="<%=s_width%>">   
	<input type='hidden' name="s_height" 	value="<%=s_height%>">     
	<input type='hidden' name="sh_height" 	value="<%=sh_height%>">   
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>  
	<input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
	<input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
	
	<input type='hidden' name='mode' 	value=''>
	<input type='hidden' name='rent_way' 	value=''>
	<input type='hidden' name='s_br' 	value=''>  


	
<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
            <div id="gnb_login">영업소별계약현황 </span></div>
            <div id="gnb_home">
		<a href="javascript:view_before()" onMouseOver="window.status=''; return true" title='이전화면 가기'><img src=/smart/images/button_back.gif align=absmiddle /></a>				
		<a href='/smart/main.jsp' title='홈'><img src=/smart/images/btn_home.gif align=absmiddle /></a>
	    </div>
        </div>
    </div>
    <div id="contents">
        <div class="text01"><img src="/smart/images/arrow.png"> <b>관리구분별현황 : <%if(mode.equals("1")){%>신차<%}else if(mode.equals("2")){%>재리스<%}else if(mode.equals("3")){%>연장<%}%></b></div>
	<div id="dj_list">	
	    <table border="0" cellspacing="0" cellpadding="0" width="100%" style="border:1px solid #c18d44;">
		<tr>
		    <th width='25%'>구분</th>					
		    <th width='25%'>기본식</th>
		    <th width='25%'>일반식</th>
		    <th width='25%' class="n">합계</th>					
		</tr>
												
		<%	Vector vt = ec_db.getStatDeptListM("", mode, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
			int vt_size = vt.size();
		%>
					
					
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				cnt[0] += AddUtil.parseInt((String)ht.get("CNT2_0"));
				cnt[1] += AddUtil.parseInt((String)ht.get("CNT2_1"));
				cnt[2] += AddUtil.parseInt((String)ht.get("CNT2_2"));							
		%>								

		<tr>
			<th style="text-align:center;"><%=ht.get("BR_NM")%></th>
			<th>          <a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=<%=mode%>&gubun2=<%=gubun2%>&gubun3=<%=ht.get("BRCH_ID")%>&gubun4=1"><%=ht.get("CNT2_0")%></a></td>
			<th>          <a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=<%=mode%>&gubun2=<%=gubun2%>&gubun3=<%=ht.get("BRCH_ID")%>&gubun4=2"><%=ht.get("CNT2_1")%></a></td>
			<th class="b"><a href="rent_cont_stat_list.jsp?gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&mode=<%=mode%>&gubun2=<%=gubun2%>&gubun3=<%=ht.get("BRCH_ID")%>&gubun4="><%=ht.get("CNT2_2")%></a></td>
		</tr>

		<%	}%>									
				
		<!--합계-->							
       		<tr> 
       			<th class="c" style="text-align:center;">합계</th>  
       			<th class='c'><font color="#d3f010"><%=cnt[0]%></font></td>
       			<th class='c'><font color="#d3f010"><%=cnt[1]%></font></td>
       			<th class='c'><font color="#d3f010"><%=cnt[2]%></font></td>
       		</tr>										
	    </table>
	</div>
	<div class=ment>※ 출고전해지/개시전해지/계약승계/차종변경은 제외, 중고차는 재리스에 포함</div>        
    </div> 
    <div id="footer"></div>      	
</div>
</form>
</body>
</html>