<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.call.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
textarea {
    width: 100%;
    height: 100px;
    padding: 12px 20px;
    box-sizing: border-box;
    border: 2px solid #ccc;
    border-radius: 4px;
    background-color: #f8f8f8;
    font-size: 12px;
    resize: none;
}
</style>
<script language="JavaScript">
	function send_msg() {
		var fm = document.form1;
		if (confirm("�����Ͻðڽ��ϱ�?")) {
			fm.action='survey_msg_pop_a.jsp';
			fm.submit();
		}
	}
</script>
</head>
<body>
<form name="form1" method="post">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<table border="0" cellspacing="0" cellpadding="0" width="100%" style="padding-top: 40px;">	
	<tr>
        <td colspan="3">
        	&nbsp;&nbsp;&nbsp;* �ش� ��೻���� �̻��ִ� ��� ��ǥ�Կ��� �߼��ϴ� �޼��� ����ȭ���Դϴ�.<br>
        	&nbsp;&nbsp;&nbsp;&nbsp;��೻���� Ȯ���� �ʿ��� ������ �ۼ����ּ���.
        </td>
    </tr>
	<tr>
        <td colspan="3" style="text-align: center; padding-top: 20px;">
        	<textarea rows="5" name="memo" style="width: 90%;"></textarea>
        </td>
    </tr>
    <tr>
    	<td colspan="3" style="text-align: center; padding-top: 20px;">
    		<input type="button" class="button button4" value="�޽��� �߼�" onclick="send_msg()"/>
    	</td>
    </tr>
</table>
</form>
</body>
</html>