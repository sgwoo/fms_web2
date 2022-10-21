<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.fee.*"%>
<%@ page import="acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	ForfeitDatabase ff_db = ForfeitDatabase.getInstance();
	FineBean[] ffs = ff_db.getForfeitDetailAll(m_id, l_cd);
	int ffs_size = ffs.length;
%>
<table border="0" cellspacing="0" cellpadding="0" width=580>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=580>
<%
	if(ffs_size > 0)
	{
		for(int i = 0 ; i < ffs_size ; i++)
		{
			FineBean ff = ffs[i];
%>	
				<tr>
					<td width='120' align='center'><%=ff.getVio_dt_view()%></td>
					<td width='80' align='center'><%=ff.getFine_st_nm()%></td>
					<td width='80' align='center'><%=ff.getVio_pla()%></td>
					<td width='80' align='center'><%=ff.getVio_cont()%></td>
					<td width='80' align='center'><%=ff.getFault_st_nm()%></td>
					<td width='80' align='center'><%=ff.getPaid_no()%></td>
					<td width='70' align='center'><%=ff.getPaid_st_nm()%></td>
				</tr>
<%
		}
	}
	else
	{
%>
				<tr>
					<td align='center'>과태료 및 범칙금 내역이 없습니다</td>
				</tr>
<%
	}
%>			</table>
		</td>
	</tr>
</table>
</body>
</html>