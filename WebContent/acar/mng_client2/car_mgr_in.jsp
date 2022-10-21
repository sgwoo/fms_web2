<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
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
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	Vector mgrs = a_db.getCarMgr(rent_mng_id, rent_l_cd);
	int mgr_size = mgrs.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
	if(mgr_size > 0)
	{
%>              <tr>
                    <td width='12%' class='title'>����</td>
                    <td width='12%' class='title'>�ٹ��μ�</td>
                    <td width='12%' class='title'>����</td>
                    <td width='12%' class='title'>����</td>
                    <td width='12%' class='title'>��ȭ��ȣ</td>
                    <td width='12%' class='title'>�޴���</td>
                    <td width='28%' class='title'>E-MAIL</td>
                </tr>
<%
		for(int i = 0 ; i < mgr_size ; i++)
		{
			CarMgrBean mgr = (CarMgrBean)mgrs.elementAt(i);
%>
                <tr>
                	<td align='center'><%= mgr.getMgr_st()%></td>
                    <td align='center'><%= mgr.getMgr_dept()%></td>
                    <td align='center'><%= mgr.getMgr_nm()%></td>
                    <td align='center'><%= mgr.getMgr_title()%></td>
                    <td align='center'><%= mgr.getMgr_tel()%></td>
                    <td align='center'><%= mgr.getMgr_m_tel()%></td>
                    <td align='center'><%= mgr.getMgr_email()%></td>
				</tr>
<%		}
	}else{
%>
				<tr>
					<td align='center'>��ϵ� ���������ڰ� �����ϴ�</td>
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
