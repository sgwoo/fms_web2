<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<%
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String ins_com = request.getParameter("ins_com")==null?"":request.getParameter("ins_com");
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<body>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
    	<td colspan='2'>
			<iframe src="/acar/condition/ins_condition_sc_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&ins_com=<%=ins_com%>&gubun=<%=gubun%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>    	
    	</td>
    </tr>
</table>
</body>
</html>