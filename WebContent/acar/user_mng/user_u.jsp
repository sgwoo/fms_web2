<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="dept_bean" class="acar.user_mng.DeptBean" scope="page"/>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String user_id = "";
	String br_id = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String dept_id = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_i_tel = "";
	String user_email = "";
	String user_pos = "";
	String user_aut = "";
	String cmd = "";
	int count = 0;
	
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert ����
	}
	
	if(cmd.equals("i")||cmd.equals("u"))
	{
		if(request.getParameter("user_id") !=null) user_id = request.getParameter("user_id");
		if(request.getParameter("br_id") !=null) br_id = request.getParameter("br_id");
		if(request.getParameter("user_nm") !=null) user_nm = request.getParameter("user_nm");
		if(request.getParameter("id") !=null) id = request.getParameter("id");
		if(request.getParameter("user_psd") !=null) user_psd = request.getParameter("user_psd");
		if(request.getParameter("user_cd") !=null) user_cd = request.getParameter("user_cd");
		if(request.getParameter("user_ssn") !=null) user_ssn = request.getParameter("user_ssn");
		if(request.getParameter("dept_id") !=null) dept_id = request.getParameter("dept_id");
		if(request.getParameter("user_h_tel") !=null) user_h_tel = request.getParameter("user_h_tel");
		if(request.getParameter("user_m_tel") !=null) user_m_tel = request.getParameter("user_m_tel");
		if(request.getParameter("user_email") !=null) user_email = request.getParameter("user_email");
		if(request.getParameter("user_pos") !=null) user_pos = request.getParameter("user_pos");
		if(request.getParameter("user_aut") !=null) user_aut = request.getParameter("user_aut");
		
		user_bean.setUser_id(user_id);
		user_bean.setBr_id(br_id);
		user_bean.setUser_nm(user_nm);
		user_bean.setId(id);
		user_bean.setUser_psd(user_psd);
		user_bean.setUser_cd(user_cd);
		user_bean.setUser_ssn(user_ssn);
		user_bean.setDept_id(dept_id);
		user_bean.setUser_h_tel(user_h_tel);
		user_bean.setUser_m_tel(user_m_tel);
		user_bean.setUser_email(user_email);
		user_bean.setUser_pos(user_pos);
		user_bean.setUser_aut(user_aut);
		
		count = umd.insertUser(user_bean);
	}	
	
		DeptBean dept_r [] = umd.getDeptAll();
		BranchBean br_r [] = umd.getBranchAll();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function PersonRegister()
{
	alert("���������� ��ϵǾ����ϴ�.");
	//location = "./car_office_s.html";

}
function PersonUpdate()
{
	alert("���������� �����Ǿ����ϴ�.");
	//location = "./car_office_s.html";

}
function UserAdd()
{
	var theForm = document.UserForm;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value= "i";
	alert(theForm.dept_id.value);
	theForm.user_ssn.value = theForm.user_ssn1.value + "" + theForm.user_ssn2.value;
	theForm.submit();
}
function CheckField()
{
	var theForm = document.UserForm;
	
	if(theForm.br_id.value=="")
	{
		alert("������ �����Ͻʽÿ�.");
		theForm.br_id.focus();
		return false;
	}
	if(theForm.dept_id.value=="")
	{
		alert("�μ��� �����Ͻʽÿ�.");
		theForm.dept_id.focus();
		return false;
	}
	if(theForm.user_nm.value=="")
	{
		alert("�̸��� �Է��Ͻʽÿ�.");
		theFrom.user_nm.focus();
		return false;
	}
	if(theForm.user_ssn1.value=="")
	{
		alert("�ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.");
		theFrom.user_ssn1.focus();
		return false;
	}
	if(theForm.user_ssn2.value=="")
	{
		alert("�ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.");
		theFrom.user_ssn2.focus();
		return false;
	}
	if(theForm.id.value=="")
	{
		alert("ID�� �Է��Ͻʽÿ�.");
		theFrom.id.focus();
		return false;
	}
	if(theForm.user_psd.value=="")
	{
		alert("��й�ȣ�� �Է��Ͻʽÿ�.");
		theFrom.user_psd.focus();
		return false;
	}
	return true;
}
function CheckUserID()
{
	var theForm = document.UserForm;
	var theForm1 = document.UserIDCheckForm;
	theForm1.user_id.value=theForm.id.value;
	theForm1.target = "i_no";
	theForm1.submit();
}
//-->
</script>
</head>
<body  onLoad="self.focus()">
<center>
<table border=0 cellspacing=0 cellpadding=0 width=400>
	<tr>
    	<td ><font color="navy">MASTER -> ����ڰ��� -> </font><font color="red">����ڵ��</font></td>
    </tr>
<form action="./user_i.jsp" name="UserForm" method="POST" >
	<tr>
    	<td class=line>
            <table border="0" cellspacing="1" width=400>
            	<tr>
			    	<td class=title width=80>����</td>
			    	<td width=120>
			    		<select name="br_id">
			    			<option value="">����</option>
<%
    for(int i=0; i<br_r.length; i++){
        br_bean = br_r[i];
%>
            				<option value="<%= br_bean.getBr_id() %>"><%= br_bean.getBr_nm() %></option>
<%}%>
						</select>
			    	</td>
			    	<td class=title width=80>�μ�</td>
			        <td width=120>
			        	<select name="dept_id">
			    			<option value="">����</option>
<%
    for(int i=0; i<dept_r.length; i++){
        dept_bean = dept_r[i];
%>
            				<option value="<%= dept_bean.getCode() %>"><%= dept_bean.getNm() %></option>
<%}%>								</select>
			        </td>
			    </tr>
            	<tr>
			    	<td class=title>�̸�</td>
			    	<td align=center><input type="text" name="user_nm" value="" size="18" class=text></td>
			    	<td class=title>�ֹε�Ϲ�ȣ</td>
			    	<td align=center><input type="text" name="user_ssn1" value="" size="6" maxlength=6 class=text> - <input type="text" name="user_ssn2" value="" size="7" maxlength=7 class=text></td>
			    
            	</tr>
            	<tr>
			    	<td class=title>ID</td>
			    	<td align=center><input type="text" name="id" value="" size="18" class=text onBlur="javascript:CheckUserID()"></td>
			    	<td class=title>��й�ȣ</td>
			        <td align=center><input type="password" name="user_psd" value="" size="18" class=text></td>
            	</tr>
            	<tr>
			    	<td class=title>��ȭ</td>
			    	<td align=center><input type="text" name="user_h_tel" value="" size="18" class=text></td>
			    	<td class=title>�޴���</td>
			        <td align=center><input type="text" name="user_m_tel" value="" size="18" class=text></td>
            	</tr>
            	<tr>
			    	<td class=title>����</td>
			    	<td align=center><input type="text" name="user_pos" value="" size="18" class=text></td>
			    	<td class=title>����</td>
			        <td>
			        	<select name="user_aut">
			        		<option value="">����</option>
			    			<option value="F">�뿩�ắ��</option>
						</select>
			        </td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
        <table border="0" cellspacing="3" width=400>
        <tr><td align="right"><a href="javascript:UserAdd()">���</a>&nbsp;</td></tr<
        </table>
       </td>
    </tr>
</table>
<input type="hidden" name="user_ssn" value="">
<input type="hidden" name="cmd" value="">
</form>
</center>
<form action="user_id_check_null.jsp" name="UserIDCheckForm" method="post">
<input type="hidden" name="user_id" value="">
<input type="hidden" name="h_id" value="">
<input type="hidden" name="cmd" value="u">
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>

<script>
<%
	if(cmd.equals("u"))
	{
%>
alert("���������� �����Ǿ����ϴ�.");

<%
	}else{
		if(count==1)
		{
%>
alert("���������� ��ϵǾ����ϴ�.");
<%
		}
	}
%>
</script>
</body>
</html>