<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cooperation.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	Vector vt = cp_db.CooperationNList(s_year, s_mon, "", s_kd, t_wd, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	
%>
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

<body>
<form name='form1' action='' method="POST">

<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 cellpadding=0 width='100%'>
				<tr>
					<td width='5%' class='title'> ���� </td>
					<td width='10%' class='title'> ��û���� </td>
					<td width='10%' class='title'> ��û�� </td>
					<td width='40%' class='title'> ���� </td>
					<td width='10%' class='title'> �����μ� ���� </td>
					<td width='10%' class='title'> ó������� </td>
					<td width='15%' class='title'> ó������ </td>
				</tr>
<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	
	%>
				<tr>
					<td width='5%'  align='center'><%=(i+1)%></td>
					<td width='10%' align='center'><%= AddUtil.ChangeDate2((String)ht.get("IN_DT")) %></td>
					<td width='10%' align='center'><%=ht.get("USER_NM")%></td>
					<td width='40%'>&nbsp;<a href="javascript:parent.view_content('<%=ht.get("SEQ")%>', '<%=ht.get("IN_DT")%>','<%=ht.get("IN_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("TITLE")%></a></td>
					<td width='10%' align='center'><%if(ht.get("OUT_ID").equals("")){%>��������<%}else{%><%=ht.get("OUT_NM")%><%}%></td>
					<td width='10%' align='center'><%=ht.get("SUB_NM")%></td>
					<td width='15%' align='center'><table width=100% border=0 cellspacing=0 cellpadding=5><tr><td align=center><%if(ht.get("OUT_DT").equals("")){%>��ó��<%}else{%><%=ht.get("OUT_DT")%><%}%></td></tr></table></td>
				</tr>

			<%}
		}
	else
	{
%>
				<tr>
					<td colspan='8' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
				</tr>
<%
	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td>* �̼��ݰ������� [��������߱޿�û]�� �ϸ� ���������� ��ϵǾ� ��ó�������� ���������� ��ȸ�˴ϴ�. ä�Ǵ���ڴ� ��������߼��� ó���Ϸ��ϸ� ����Ͽ� �ֽʽÿ�.</td>
    </tr>	
</table>
</form>
</body>
</html>