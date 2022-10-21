<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function Holiday_modify(cmd, idx){
		var fm = document.form1;
		var i_fm = i_in.form1;			
		var hol_size = i_fm.hol_size.value;	
		//if(hol_size == "1"){
		//	fm.seq.value 	 = i_fm.seq.value;
		//	fm.hday.value 	 = i_fm.hday.value;			
		//	fm.hday_nm.value = i_fm.hday_nm.value;								
		//}else{
			fm.seq.value 	 = i_fm.seq[idx].value;
			fm.hday.value 	 = i_fm.hday[idx].value;			
			fm.hday_nm.value = i_fm.hday_nm[idx].value;								
		//}		
		fm.cmd.value = cmd;	
		if(!CheckField()){	return;	}	
		if(!confirm(cmd+'하시겠습니까?')){
			return;
		}
		fm.target = "i_no"
		fm.submit();
	}
	
	//입력값 null 체크
	function CheckField(){
		var fm = document.form1;
		if(fm.hday.value==""){		alert("공휴일자를 입력하십시요");	return false;	}
		if(fm.hday_nm.value==""){	alert("공휴일명를 입력하십시요");	return false;	}
		return true;
	}
	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	int s_year = request.getParameter("s_year")==null?2003:Integer.parseInt(request.getParameter("s_year"));	
%>
<form action="holiday_sc_a.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="seq" value="">
<input type="hidden" name="hday" value="">
<input type="hidden" name="hday_nm" value="">
<table border=0 cellspacing=0 cellpadding=0 width=800>
	<tr>
		<td>
			<iframe src="/acar/attend/holiday_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>" name="i_in" width="820" height="500" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='auto' marginwidth='0' marginheight='0'></iframe>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>