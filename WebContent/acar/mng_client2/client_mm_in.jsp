<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector c_mms = l_db.getClientMMs(client_id);
	int c_mm_size = c_mms.size();
%>
<form name='form1' method='post' action='/acar/mng_client2/client_mm_i_a.jsp'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
	if(c_mm_size > 0)
	{
		for(int i = 0; i < c_mm_size ; i++)
		{
			ClientMMBean mm = (ClientMMBean)c_mms.elementAt(i);
%>
                <tr>
					<td align='center' width='18%'><%=mm.getReg_dt()%></td>
					<td align='center' width='18%'><%=c_db.getNameById(mm.getReg_id(), "USER")%></td>
					<td width='64%'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<tr>
								<td width='5'></td>
								<td><%=Util.htmlBR(mm.getContent())%></td>
							</tr>
						</table>
				</tr>
<%		}
	}else{
%>
				<tr>
					<td colspan='3' align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%
	}
%>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
