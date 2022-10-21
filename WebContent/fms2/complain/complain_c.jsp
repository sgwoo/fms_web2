
<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.complain.*" %>
<jsp:useBean id="bean" class="acar.complain.OpinionBean" scope="page"/>


<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	
	if(user_id.equals("")){
		user_id = ck_acar_id;
	}
	
	ComplainDatabase oad = ComplainDatabase.getInstance();
	
	//�������� �Ѱ� ��ȸ
	bean = oad.getComplainBean(seq);

%>
<html>
<head><title>FMS</title>
<script language='javascript'>

//�˾�â �ݱ�
function AncClose()
{
	self.close();
	window.close();
}

//���� ������
function Email_Reg(){
	var fm = document.form1;
	if(fm.answer.value == '')	{	alert('�亯 ������ ���ּ���.'); return; }
	if(confirm('��� �Ͻðڽ��ϱ�?'))
	{			
		fm.target = "i_no";
		fm.action = "complain_email.jsp";
		fm.submit();						
	}	
}

//��ȭ ���Ϸ�
function Phone_Reg(){
	var fm = document.form1;
		
	if(confirm('��ȭ����� �Ϸ��ϼ̽��ϱ�?'))
	{			
		fm.answer.value = '��ȭ�� ����� �����߽��ϴ�.'	
		fm.target = "i_no";
		fm.action = "complain_email.jsp";
		fm.submit();						
	}	
}

</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body onLoad="javascript:self.focus()" id="body">
<form name="form1" method="post">
	<input type="hidden" name="seq" value="<%=seq%>">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>"> 
    <input type='hidden' name="email" value="<%=bean.getEmail()%>">
    <input type='hidden' name="name" value="<%=bean.getName()%>">      	
<center>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5> ���Ҹ�����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan='4' align='right'>
		<a href="javascript:AncClose()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align=absmiddle border=0></a>&nbsp;</td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width=20%>�̸�</td>
					<td width=25%>&nbsp;&nbsp;<%=bean.getName()%></td>
					<td class="title" width=20%>��ȭ��ȣ</td>
					<td width=35%>&nbsp;&nbsp;<%=bean.getTel()%></td>
				</tr>
				<tr>
					<td class="title">�̸���</td>
					<td>&nbsp;&nbsp;<%=bean.getEmail()%></td>
					<td class="title">�Ƹ���ī �̿뿩��</td>
					<td>&nbsp;&nbsp;<%if(bean.getAcar_use().equals("1")){%>�̿��� <%} else{ %>���̿��� <%} %></td>
				</tr>
				<tr>
					<td align="center" class="title">����</td>
					<td align="center" colspan="3"><%=bean.getTitle()%></td>
				</tr>
				<tr>
					<td class="title">����</td>
					<td colspan="3" style="height:200" valign="top">
						<table border=0 cellspacing=0 cellpadding=0 >
							<tr>
								<td align="center">&nbsp;&nbsp;<textarea name="contents" cols='80' rows='18' readonly><%=bean.getContents()%></textarea></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>	
	<tr>
		<%if(bean.getAns_id().equals("")){%> 
		<td align="right">
			 <a href="javascript:Phone_Reg()"><img src="/acar/images/center/button_send_call.gif" align=absmiddle border=0></a>&nbsp;&nbsp;
			 <a href="javascript:Email_Reg()"><img src="/acar/images/center/button_send_mail.gif" align=absmiddle border=0></a>
		</td>
		<%} else { %>
		<%} %>
	</tr>
    <tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class="line">
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<%if(bean.getAns_id().equals("")){%>
				<%} else { %>
				<tr>
					<td class="title" width=20%>�亯��</td>
					<td width=25%>&nbsp;&nbsp;<%=bean.getAns_nm()%></td>
					<td class="title" width=20%>�亯�ð�</td>
					<td width=35%>&nbsp;&nbsp;<%=bean.getAns_dt()%></td>
				</tr>
				<%} %>
				<tr>
					<td class="title" width="20%">�亯</td>
				<%if(bean.getAns_id().equals("")){%> 
					 <td align="center" colspan="3">
						&nbsp;&nbsp;<textarea name="answer" cols="80" rows="18" class="text"></textarea></td>
				<%} else { %>
					<td align="center" colspan="3">
						&nbsp;&nbsp;<textarea cols="80" rows="18" class="text" readonly="readonly"><%=bean.getAnswer()%></textarea></td>
				<%} %>
				</tr>
		 	</table>
		</td>
    </tr>
</table>
</center>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</form>		
</body>
</html>