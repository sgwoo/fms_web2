<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String var_cd = request.getParameter("var_cd")==null?"":request.getParameter("var_cd");
	String var_sik = request.getParameter("var_sik")==null?"":request.getParameter("var_sik");
	
	if(var_cd.equals("dly1_bus3")||var_cd.equals("dly1_bus6")||var_cd.equals("dly1_bus12")||var_cd.equals("dly1_bus13"))	var_sik = AddUtil.ChangeString(var_sik);
	if(var_cd.equals("dly1_bus4")||var_cd.equals("dly1_bus7") ||var_cd.equals("dly1_bus14")) 				var_sik = AddUtil.parseDigit3(var_sik);
	
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstiSikVarBean bean = e_db.getEstiSikVarCaseDly(a_a, seq, var_cd);
	bean.setVar_sik(var_sik);
	count = e_db.updateEstiSikVar(bean);
	
	//ä��ķ���� ���� ���ν��� ����
	int flag8 = 0;
	String  d_flag =  ad_db.call_sp_stat_settle_magam();
    if (!d_flag.equals("0")) flag8 = 1;
    System.out.println("ä��ķ���� =" + d_flag);
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='stat_settle_201103_sc2.jsp' method="POST" target='d_content'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="save_dt" value="<%=save_dt%>">
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type="hidden" name="mode" value="cmp_amt_reg1_only">
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==1){%>
			alert("���������� �����Ǿ����ϴ�.");
			parent.location.reload();
			fm.submit();
<%	}else{%>
			alert("�����߻�!");
<%	}%>
//-->
</script>
</body>
</html>
