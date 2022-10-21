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
	function go_modify()
	{
		var fm = document.form1;
		fm.submit();
	}
//-->
</script>
</head>
<%
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");	
	String s_seq = request.getParameter("s_seq")==null?"":request.getParameter("s_seq");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	CommonDataBase c_db = CommonDataBase.getInstance();
	DailyScdBean scd = ds_db.getDailyScd(s_year, s_mon, s_day, s_seq);
//System.out.println("y="+s_year+"/s_mon="+s_mon+"/s_day="+s_day+"/s_seq="+s_seq);
%>
<body>
<form name='form1' name='form1' method='post' action='/acar/daily_sch/d_sch_u.jsp'>
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
<%
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>    	
    		<a href='javascript:go_modify()' onMouseOver="window.status=''; return true">수정화면</a>
<%
	}
%>			<a href='javascript:window.close()' onMouseOver="window.status=''; return true">닫기</a>
    	</td>
    </tr>
    <tr>
    	<td class='line'>
    		<table border='0' cellspacing='1' cellpadding='0' width='450'>
			    <tr>
			    	<td class='title' width='100'>등록일</td>
			    	<td>&nbsp;<%=scd.getYear()%>년&nbsp;<%=scd.getMon()%>월&nbsp;<%=scd.getDay()%>일
			    	</td>
			    </tr>
			    <tr>
			    	<td class='title'>등록자</td>
			    	<td>&nbsp;<%=c_db.getNameById(scd.getUser_id(), "USER")%></td>
			    </tr>
			    <tr>
			    	<td class='title'>제목</td>
			    	<td>&nbsp;<%=scd.getTitle()%></td>
			    </tr>
				<tr>
			    	<td class='title'>내용</td>
			    	<td><br/>
			    		<table border='0' cellspacing='1' cellpadding='0' width='350' height='270'>
			    			<tr>
			    				<td width='5'></td>
			    				<td valign='top'>
			    					<%=Util.htmlBR(scd.getContent())%>
			    				</td>
			    			</tr>
			    		</table>
			    	</td>
			    </tr>    
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>