<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.daily_sch.*"%>
<jsp:useBean id="ds_db" scope="page" class="acar.daily_sch.DScdDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table.css'>
<script language="JavaScript">
<!--
	function modify()
	{
		var fm = document.form1;
		if(fm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
		else if(fm.content.value == '')	{	alert('내용을 입력하십시오');	return;	}
		if(get_length(fm.content.value) > 4000){
			alert("4000자 까지만 입력할 수 있습니다.");
			return;
		}	
		fm.target='i_no';
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
//-->
</script>
</head>
<%
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");	
	String s_seq = request.getParameter("s_seq")==null?"":request.getParameter("s_seq");
	String auth_rw = request.getParameter("year")==null?"":request.getParameter("auth_rw");
	CommonDataBase c_db = CommonDataBase.getInstance();
	DailyScdBean scd = ds_db.getDailyScd(s_year, s_mon, s_day, s_seq);
%>
<body>
<form action='/acar/daily_sch/d_sch_u_a.jsp' name='form1' method='post'>
<input type='hidden' name='s_year' value='<%=s_year%>'>
<input type='hidden' name='s_mon' value='<%=s_mon%>'>
<input type='hidden' name='s_day' value='<%=s_day%>'>
<input type='hidden' name='s_seq' value='<%=s_seq%>'>
<table border=0 cellspacing=0 cellpadding=0 width=450>
	<tr>
    	<td><font color="navy">기초정보관리 -> </font><font color="red">일일업무계획</font></td>
    </tr>
    <tr>
    	<td align='right'>
    		<a href='javascript:modify()' onMouseOver="window.status=''; return true"> 수정 </a>
    		<a href='javascript:window.close()' onMouseOver="window.status=''; return true">닫기</a>
    	</td>
    </tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=450>
			    <tr>
			    	<td class='title' width='100'>등록일</td>
			    	<td>&nbsp;<%=s_year%>년&nbsp;<%=s_mon%>월&nbsp;<%=s_day%>일
			    	</td>
			    </tr>
			    <tr>
			    	<td class='title'>등록자</td>
			    	<td>&nbsp;<%=c_db.getNameById(scd.getUser_id(), "USER")%></td>
			    </tr>
			    <tr>
			    	<td class='title'>제목</td>
			    	<td>&nbsp;<input type='text' name='title' size='50' class='text' value='<%=scd.getTitle()%>' maxlength='125'></td>
			    </tr>
				<tr>
			    	<td class='title'>내용</td>
			    	<td>&nbsp;<textarea rows='20' name='content' cols='52' maxlength='2000'><%=scd.getContent()%></textarea></td>
			    </tr>    
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</body>
</html>