<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
String su 	= request.getParameter("su")==null?"":request.getParameter("su");
String msg 	= request.getParameter("msg")==null?"":request.getParameter("msg");
String gubun 	= request.getParameter("s_destphone")==null?"":request.getParameter("s_destphone");

String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
String sendphone	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
String destphone	= "010-7757-1540";
String msglen 		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");

String msg2 ="";

	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);	

if(gubun.equals("��ȭ")){
	gubun = "��ȭ-�۷κ�";
}else if(gubun.equals("�д�")){
	gubun = "�д�-�۷κ�";
}else{
	gubun = "�������̼�ī(��)";
}
	
if(!destphone.equals("")){
				
	msg2 = gubun +" ��������� ������ Ź������ ����Ʈ �Դϴ�. "+msg;
	
	String rqdate = "";
	
	if(msg_subject.equals("")) msg_subject = "�ѹ���-���¿����";
	
	IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, firm_nm, "", rqdate, msg_type, msg_subject, msg2, l_cd, base.getClient_id(), ck_acar_id, "5");
	
}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body onLoad="javascript:print(document)">
<form name='form1' method='post'>

<table table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td align="center"><a href="javascript:print(document)"><img src=/acar/images/center/button_print.gif border=0></a></td>
	</tr>
	<tr>
		<td class="h"></td>
	</tr>
	<%if(gubun.equals("")){%>
	<tr>
		<td><img src=/acar/images/center/glovis.jpg border=0 align=absmiddle>[�� ����� ���������ڵ�������� ��ǰ�� ����Դϴ�.]</td>
	</tr>
	<%}%>
	<tr>
        <td colspan="2" class=line2></td>
    </tr>
	<tr>
		<td colspan="2" class='line' width=100%>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
				  <td class='title' colspan="4" rowspan="1"><font size="6">Ź �� �� û ��</font></td>
				</tr>
				<tr>
				  <td class='title' colspan="1" rowspan="3" width="15%">�� �� �� ��<br>(��������<br>�ΰ���)</td>
				  <td class='title' colspan="2" rowspan="1">����</td>
				  <td align="center"><input type='text' size='30' name='' value='(��)�Ƹ���ī' maxlength='100' class='text' style = "border : none;font:11pt ����"></td>
				</tr>
				<tr>
				  <td class='title' colspan="1" rowspan="2" width="15%">����ó</td>
				  <td class='title' width="15%">��ȭ��ȣ</td>
				  <td align="center"><input type='text' size='30' name='' value='���Ǳ�' maxlength='100' class='text' style = "border : none;font:11pt ����"></td>
				</tr>
				<tr>
				  <td class='title' width="15%">�޴���ȭ</td>
				  <td align="center"><input type='text' size='30' name='' value='010-7757-1540' maxlength='100' class='text' style = "border : none;font:11pt ����"></td>
				</tr>
				<tr>
				  <td class='title' colspan="4" rowspan="1" align="left">�ذ������� ���� ������ �����Ͻô� ���� ������ �����Ͽ� �ֽʽÿ�</td>
				</tr>
				<tr>
				  <td class='title' colspan="1" rowspan="2">��������</td>
				  <td class='title'>������</td>
				  <td colspan="2" rowspan="2" align="center"><br><textarea name='msg' rows='14' cols='50' class='text' style='IME-MODE: active' style="overflow:hidden;border:none;font:11pt ����"><%=msg%></textarea></td>
				</tr>
				<tr>
				  <td class='title'>������ȣ</td>
				</tr>
				<tr>
				  <td colspan="2" rowspan="1"class='title' >�൵</td>
				  <td colspan="2" rowspan="1" align="center">�� <%=su%>��</td>
				</tr>
				<tr>
				  <!-- <td colspan="4" rowspan="1"><img src=/acar/images/center/yd.jpg align=absmiddle border=0 width=500 height=450></td> -->
				  <td colspan="4" rowspan="1"><img src=/acar/images/center/map_s_youngnam.jpg align=absmiddle border=0 width=500 height=450></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='h'></td>
	</tr>
<%if(gubun.equals("")){%>	
	<tr>
		<td >�� Ź�۷� �Աݽ� �Աݰ��� �� ����ó(�Ա��� �ݵ�� ������ �ؼ� Ȯ���� �ؾ��մϴ�.)</td>
	</tr>
	<tr>
		<td >�� �� �� �� �� : ��ȯ(05) 174-18-35675-8(������:�ڴ���)</td>
	</tr>
	<tr>
		<td >�� Ź �� �� ü : 031)766-7217, 031)760-5397 (���:����ȣ �����) F:031-766-6131</td>
	</tr>
	<tr>
		<td >�� �� �� �� �� : 031)760-5360~61 031)760-5356~57 (���:������, �������)</td>
	</tr>
<%}%>	
</table>

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--


//-->
</script>
</body>
</html>
