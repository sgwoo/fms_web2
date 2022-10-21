<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*" %>
<%@ page import="acar.kakao.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
	String sendphone 	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String destphone 	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String destname 	= request.getParameter("destname")==null?"":request.getParameter("destname");
	String msg 			= request.getParameter("msg")==null?"":request.getParameter("msg");
	String msglen		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
	String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
	String user_pos 	= request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String dest_gubun	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	if(user_pos.equals("���")){
		msg = destname+ "���Բ��� ��û�Ͻ� ���� ����� ���� ��ȭ������� ������ ���� �ʾ� ���� ����ϴ�. ������ ����� �����ϴ� ��ȭ �����Ͻ� �� �����ּ���."+"-�Ƹ���ī "+sendname+"-";
	}else{
		msg = destname+ "���Բ��� ��û�Ͻ� ���� ����� ���� ��ȭ������� ������ ���� �ʾ� ���� ����ϴ�. ������ ����� �����ϴ� ��ȭ �����Ͻ� �� �����ּ���."+"-�Ƹ���ī "+user_pos+" "+sendname+"-";
	}

	//�˸��� acar0068 ������� �����߾˸�
	String customer_name 	= destname;				// ���̸�
	String manager_name = sendname;					// ����� �̸�
	String manager_phone = sendphone;				// ����� ��ȭ
	String etc1 = est_id;
	String etc2 = ck_acar_id ;
	
	List<String> fieldList = Arrays.asList(customer_name, manager_name, manager_phone);
	at_db.sendMessageReserve("acar0068", fieldList, destphone, sendphone, null,  etc1, etc2 );
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<script language="JavaScript">
<!--
	alert("���ڰ� �߼۵Ǿ����ϴ�.");
//-->
</script>
</body>
</html>
