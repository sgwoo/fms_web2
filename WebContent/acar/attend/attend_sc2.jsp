<%@ page language="java"  contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ip_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	
	int cnt = 3; //��Ȳ ��� �Ѽ�
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/index.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan='2'> 
            <table border="0" cellspacing="0" cellpadding="0" width='100%'>
                <tr> 
                    <td width=100% colspan='2'> 
                        <table border="0" cellspacing="0" cellpadding="0" width=100%>
                            <tr> 
                                <td align='center'><iframe src="attend_sc_in2.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&chk1=<%=chk1%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_year=<%=s_year%>&s_month=<%=s_month%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                                </iframe> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan='2'> 
            <table border="0" cellspacing="0" cellpadding="0" width='100%'>
                <tr> 
                    <td width=810 colspan='2'> 
                        <table border="0" cellspacing="0" cellpadding="0" width=100%>
                            <tr>
                                <td class=h></td>
                            </tr>
                            <tr>                           
                                <td>
                                    <table width="500" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                            <td width="20" align="center"><font color=999999>��</font></td>
                                            <td width="60" bgcolor="#EEF5F9">&nbsp;</td>
                                            <td width="60"><font color=999999> : �����</font></td>
                                            <td width="60" bgcolor="#FEE6E6">&nbsp;</td>
                                            <td width="60"><font color=999999> : �Ͽ���</font></td>
                                            <td width="20" align="center"><font color=999999>��</font></td>
                                            <td width="180"><font color=999999>�� : ����� �ٹ���</font></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
</table>
<form action="attend_sc2.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">		
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
<input type="hidden" name="s_month" value="<%=s_month%>">
</form>
</body>
</html>