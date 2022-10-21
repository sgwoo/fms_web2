<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function reg_sch()
	{
		window.open("/acar/day_sche/day_sche_i.jsp?auth_rw="+document.form1.auth_rw.value, "DAILY_SCD_I", "left=100, top=100, width=470, height=450");
	}
	function reg_site(cmd){
		var fm = inner.form1;
		fm.cmd.value = cmd;
		if(cmd == 'p'){
			if(!confirm('처리하시겠습니까?')){	return;	}
			var len = fm.elements.length;
			var cnt=0;
			var idnum="";
			for(var i=0 ; i<len ; i++){
				var ck = fm.elements[i];
				if(ck.name == 'pr'){
					if(ck.checked == true){
						cnt++;
						idnum = ck.value;
					}
				}
			}
			if(cnt == 0){ alert("처리할 스케쥴을 선택하세요."); return; }
			fm.action='/acar/day_sche/day_sche_pr.jsp';
		}else{
			if(!confirm('삭제하시겠습니까?')){	return;	}
			var len = fm.elements.length;
			var cnt=0;
			var idnum="";
			for(var i=0 ; i<len ; i++){
				var ck = fm.elements[i];
				if(ck.name == 'pr'){
					if(ck.checked == true){
						cnt++;
						idnum = ck.value;
					}
				}
			}
			if(cnt == 0){ alert("삭제할 스케쥴을 선택하세요."); return; }
			fm.action='/acar/day_sche/day_sche_delete.jsp';
		}
		fm.target = "i_no";		
		fm.submit();
	}
	function view_content(year, mon, day, seq)
	{
		window.open("/acar/day_sche/day_sche_u.jsp?auth_rw="+document.form1.auth_rw.value+"&s_year="+year+"&s_mon="+mon+"&s_day="+day+"&s_seq="+seq, "DAILY_SCD_C", "left=100, top=100, width=470, height=500");
	}	
//-->
</script>
</head>
<%
	String s_sys = Util.getDate();
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_year = request.getParameter("s_year")==null?s_sys.substring(0, 4):request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?s_sys.substring(5, 7):request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?s_sys.substring(8, 10):request.getParameter("s_day");
%>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<%
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
    <tr>
    	<td align='right'>
			<a href='javascript:reg_site("p")' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_cr.gif" align="absmiddle" border="0"></a>
			<a href='javascript:reg_site("d")' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
			<a href='javascript:reg_sch()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;
		</td>		
    </tr>
<%
	}
%>

    <tr>
    	<td>
			<iframe src="/acar/day_sche/day_sche_s_sc_in.jsp?auth_rw=<%=auth_rw%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>" name="inner" width="100%" height="600" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
    	</td>
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>