<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table.css'>
<script language="JavaScript">
<!--
	function reg_sch()
	{
		window.open("/acar/daily_sch/d_sch_i.jsp?auth_rw="+document.form1.auth_rw.value, "DAILY_SCD_I", "left=100, top=100, width=470, height=450");
	}
	function view_content(year, mon, day, seq)
	{
		window.open("/acar/daily_sch/d_sch_c.jsp?auth_rw="+document.form1.auth_rw.value+"&s_year="+year+"&s_mon="+mon+"&s_day="+day+"&s_seq="+seq, "DAILY_SCD_C", "left=100, top=100, width=470, height=450");
	}
	function set_done(year, mon, day, seq)
	{
		if(confirm('진행완료로 변경하시겠습니까?'))
		{
			var fm = document.form1;
			fm.action="/acar/daily_sch/d_sch_cng.jsp?auth_rw="+document.form1.auth_rw.value+"&s_year="+year+"&s_mon="+mon+"&s_day="+day+"&s_seq="+seq;
			fm.target='i_no';
			fm.submit();
		}
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
<table border=0 cellspacing=0 cellpadding=0 width=800>
<%
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
    <tr>
    	<td align='right'> <a href='javascript:reg_sch()'>등록</a> </td>
    </tr>
<%
	}
%>
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 width='800'>
            	<tr>
            		<td width='50' class='title'> 번호 </td>
            		<td width='550' class='title'> 제목 </td>
            		<td width='100' class='title'> 등록자 </td>
            		<td width='100' class='title'> 진행상태 </td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td>
			<iframe src="/acar/daily_sch/d_sch_sc_in.jsp?auth_rw=<%=auth_rw%>&s_year=<%=s_year%>&s_mon=<%=s_mon%>&s_day=<%=s_day%>" name="inner" width="800" height="480" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
    	</td>
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>