<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.daily_sch.*"%>
<jsp:useBean id="ds_db" scope="page" class="acar.daily_sch.DScdDatabase"/>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table.css'>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<%
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	Vector scds = ds_db.getDailyScds(s_year, s_mon, s_day);
	int scd_size = scds.size();
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<body>
<table border=0 cellspacing=0 cellpadding=0 width='800'>
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 width='800'>
<%
	if(scd_size > 0)
	{
		for(int i = 0 ; i < scd_size ; i++)
		{
			DailyScdBean scd = (DailyScdBean)scds.elementAt(i);
%>
            	<tr>
            		<td width='50'  align='center'><%=(i+1)%></td>
            		<td width='550'>&nbsp;<a href="javascript:parent.view_content('<%=scd.getYear()%>', '<%=scd.getMon()%>', '<%=scd.getDay()%>', '<%=scd.getSeq()%>')" onMouseOver="window.status=''; return true"><%=scd.getTitle()%></a></td>
            		<td width='100' align='center'><%=c_db.getNameById(scd.getUser_id(), "USER")%></td>
<%
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>            		
            		<td width='100' align='center'><%if(scd.getStatus().equals("0")){%><a href="javascript:parent.set_done('<%=scd.getYear()%>', '<%=scd.getMon()%>', '<%=scd.getDay()%>', '<%=scd.getSeq()%>')" onMouseOver="window.status=''; return true">미진행</a><%}else{%>완료<%}%></td>
<%
	}
	else
	{
%>
					<td width='100' align='center'><%if(scd.getStatus().equals("0")){%>미진행<%}else{%>완료<%}%></td>
<%
	}
%>
            	</tr>
<%		}
	}
	else
	{
%>
				<tr>
					<td colspan='4' align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%
	}
%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>