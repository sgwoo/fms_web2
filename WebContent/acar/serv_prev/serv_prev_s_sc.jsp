<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_prev.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	String gubun_nm = "";
	String gubun = "";
	String ref_dt1 = "";
	String ref_dt2 = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun_nm") !=null) gubun_nm = request.getParameter("gubun_nm");
	if(request.getParameter("gubun") !=null) gubun = request.getParameter("gubun");
	if(request.getParameter("ref_dt1") !=null) ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") !=null) ref_dt2 = request.getParameter("ref_dt2");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 3; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--
function AccidAdd()
{
	var theForm = document.AccidRegMoveForm;
	theForm.target="d_content";
	theForm.submit();
}
//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>

    <tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr><td class=line2></td></tr>
				<tr>
					<td class='line' width="100%">
						 <table  border=0 cellspacing=1 width="100%">
						  	<td class=title width=60>����</td>
						 	<td class=title width=90>������ȣ</td>
		            		<td class=title width=80>�����</td>
		            		<td class=title width=98>����</td>
		            		<td class=title width=149>��ȣ</td>
		            		<td class=title width=78>�����</td>
		            		<td class=title width=71>����<br>����Ÿ�</td>
		            		<td class=title width=61>�����<br>����Ÿ�</td>
		            		<td class=title width=70>����<br>����Ÿ�</td>
		            		<td class=title width=50>����<br>ǰ��</td>
		            		<td class=title width=50>����<br>����</td>
			            </table>
					</td>
					<td width=19>&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td colspan=2><iframe src="./serv_prev_s_sc_in.jsp?auth_rw=<%=auth_rw%>&gubun_nm=<%=gubun_nm%>&gubun=<%=gubun%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>" name="MaintList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							
	
			</table>
		</td>
	</tr>

</table>
</body>
</html>