<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	//String auth_rw = "";
	
	//if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>

<script language="JavaScript">
<!--
function SearchBbs()
{
	var theForm = document.from1;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body>
<form action="./know_how_sc.jsp" name="from1" method="POST" target="c_foot">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5>�Ƹ���ī ����IN</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǰ˻�</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class=line>
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<tr >
					<td class=title width=8%>�˻�����</td>
					<td width=18%>&nbsp;
						<select name="gubun" onChange="javascript:document.from1.gubun_nm.focus()">
							<option value="all">��ü</option>
							<option value="current_month">���</option>
							<option value="title">����</option>
							<option value="content">����</option>
							<option value="user_nm">�ۼ���</option>
							<option value="reg_dt">��¥	</option>
						</select>
					&nbsp;<input type='text' name="gubun_nm" size='22' class='text'></td>
					<td class=title width=10%>ī�װ� �˻�</td>
					<td width=39%>&nbsp;
						<INPUT TYPE="radio" NAME="gubun1" value=''  <%if(gubun1.equals("")){%>checked<%}%>>��ü&nbsp;
						<INPUT TYPE="radio" NAME="gubun1" value='1'  <%if(gubun1.equals("1")){%>checked<%}%>>����Q&A&nbsp;
						<INPUT TYPE="radio" NAME="gubun1" value='2'  <%if(gubun1.equals("4")){%>checked<%}%>>��������&nbsp;
			
						&nbsp;<a href="javascript:SearchBbs()"><img src="/acar/images/center/button_search.gif" align=absmiddle border=0></a></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;* ���� Q&A�� �ñ��� ���̳� �������� �ǰ��� ���� ���� ��, ���������� �������Ͽ쳪 ������� ���� �����ϰ� ���� �������� ����Ͻø� �˴ϴ�. </td>
	</tr>
</table>
</form>
</body>
</html>  