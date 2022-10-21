<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.partner.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String cpt_cd 	= request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	Vector vt = se_dt.getBank_DCGR_List(cpt_cd);
	int vt_size = vt.size();	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--


//-->
</script>
</head>
<body leftmargin="10">


<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<div class="navigation">
	<span class=style1></span><span class=style5>�۴���ŷ���Ȳ(�������� : <%=AddUtil.getDate()%> ����)</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
				<tbody>
					<tr>
						<td rowspan=3 class="title">����</td>
						<td colspan=3 class="title">��������</td>
						<td rowspan=3 class="title">ȸ��(<br>������<br>)����</td>
						<td colspan=2 class="title">�����ѵ�</td>
						<td colspan=8 class="title">������Ȳ</td>
						<td rowspan=3 class="title">�����հ�</td>
						<td colspan=2 class="title">��ȯ����</td>
					</tr>
					<tr>
						<td rowspan=2 class="title">ü����</td>
						<td colspan=2 class="title">��������</td>
						<td rowspan=2 class="title">�ѵ�</td>
						<td rowspan=2 class="title">�ܾ�</td>
						<td colspan=2 class="title">24����</td>
						<td colspan=2 class="title">36����</td>
						<td colspan=2 class="title">48����</td>
						<td colspan=2 class="title">60����</td>
						<td rowspan=2 class="title">��ȯ</td>
						<td rowspan=2 class="title">�ܾ�</td>
					</tr>
					<tr>
						<td class="title">������</td>
						<td class="title">���Ό����</td>
						<td class="title">�ݾ�</td>
						<td class="title">�ݸ�</td>
						<td class="title">�ݾ�</td>
						<td class="title">�ݸ�</td>
						<td class="title">�ݾ�</td>
						<td class="title">�ݸ�</td>
						<td class="title">�ݾ�</td>
						<td class="title">�ݸ�</td>
					</tr>
					<% for(int i=0; i< vt_size; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
					<tr>
						<td align="center"><%=i+1%></td>
						<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ü������")))%></td>
						<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("���ళ����")))%></td>
						<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("����������")))%></td>
						<td align="center"><%=ht.get("ȸ������")%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("�����ѵ��ݾ�")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("�����ѵ��ܾ�")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("�ݾ�_24����")))%></td>
						<td align="right"><%=AddUtil.parseFloat(String.valueOf(ht.get("�ݸ�_24����")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("�ݾ�_36����")))%></td>
						<td align="right"><%=AddUtil.parseFloat(String.valueOf(ht.get("�ݸ�_36����")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("�ݾ�_48����")))%></td>
						<td align="right"><%=AddUtil.parseFloat(String.valueOf(ht.get("�ݸ�_48����")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("�ݾ�_60����")))%></td>
						<td align="right"><%=AddUtil.parseFloat(String.valueOf(ht.get("�ݸ�_60����")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("�����հ�ݾ�")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("��ȯ�ݾ�")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("��ȯ�ܾ�")))%></td>
					</tr>
					<%}%>
				</tbody>
			</table>
        </td>
    </tr>
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>