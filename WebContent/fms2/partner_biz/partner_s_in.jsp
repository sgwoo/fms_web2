<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="pd_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	Vector conts = new Vector();
	int cont_size = 0;
	
	Vector vt = pd_db.getFinMan(s_kd, use_yn, "S");
	int vt_size = vt.size();	

%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_kd" value="<%=s_kd%>">
<input type='hidden' name="use_yn" value="<%=use_yn%>">
<input type='hidden' name="t_wd" value="<%=t_wd%>">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>       
        <td class='line' width='100%'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			<tr>
				<td width=5% class='title'>����</td>
				<td width=5% class='title'>����</td>
				<td width=16% class='title'>��ȣ</td>
				<td width=16% class='title'>�����</td>
				<td class='title' width=20%>�̸���</td>
				<td class='title' width=12%>�����</td>		         
				<td class='title' width=11%>��ȭ��ȣ</td>		         
				<td class='title' width=11%>�ѽ�</td>	
				<td class='title' width=6%>����</td>		         
          	</tr>
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
                <tr> 
					<td align='center' width=5%><%=i+1%></td>
					<td align='center' width=5%><input type="checkbox" name="ch_cd" value="<%=ht.get("FIN_EMAIL")%>^<%=ht.get("AGNT_NM")%>^<%=ht.get("AGNT_TITLE")%>"></td>
					<td align='center' width=16%><a href="javascript:parent.BranchUpdate('<%=ht.get("FIN_SEQ")%>')"><%=ht.get("COM_NM")%></a></td>
					<td align='center' width=16%><%=ht.get("AGNT_NM")%>&nbsp;<%=ht.get("AGNT_TITLE")%></td>
					<td align='center' width=20%><%=ht.get("FIN_EMAIL")%></td>
					<td align='center' width=12%><%=ht.get("FIN_M_TEL")%></td>
					<td align='center' width=11%><%=ht.get("FIN_TEL")%></td>
					<td align='center' width=11%><%=ht.get("FIN_FAX")%></td>
					<td align='center' width=6%><%=ht.get("SORT")%></td>
                </tr>
                <%	}
        		}else{%>
                <tr> 
                    <td align='center' colspan="8">�ش� ����Ÿ�� �����ϴ�.</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
	<%if(t_wd.equals("")){%>
	<tr>
		<td>* �˻��ܾ�� ��ȸ�Ͻʽÿ�.</td>
    </tr>
	<%}%>	
</table>
</form>
</body>
</html>
