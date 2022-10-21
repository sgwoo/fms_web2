<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.receive.*, acar.doc_settle.*"%>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
		
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	String cmd	 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String  seq	 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	int count = 0;
	int flag = 0;
	
	boolean flag1 = true;	
	int result = 0;
		
	//ä���߽� ������ ���̺�
	ClsBandEtcBean cls = new ClsBandEtcBean();
	
	//���� 
	if (cmd.equals("D")) {
		if(!re_db.deleteClsBandEtc(rent_mng_id, rent_l_cd , seq ))	flag += 1;	
	} else if (cmd.equals("U")) {
		cls = re_db.getClsBandEtcInfo(rent_mng_id, rent_l_cd , seq );
		
		cls.setBand_st(request.getParameter("band_st")==null?"":	request.getParameter("band_st"));// ȸ������
		cls.setBand_ip_dt(request.getParameter("band_ip_dt"));  //�Ա�����
		cls.setDraw_amt(request.getParameter("draw_amt")==null?0:			AddUtil.parseDigit(request.getParameter("draw_amt"))); //ȸ����
		cls.setIp_amt(request.getParameter("ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ip_amt"))); //�Աݾ�
		cls.setRate_amt(request.getParameter("rate_amt")==null?0:			AddUtil.parseDigit(request.getParameter("rate_amt"))); //������
		cls.setRate_jp_dt(request.getParameter("rate_jp_dt"));  //��������
		cls.setUpd_id(user_id); //�����id
		if(!re_db.updateClsBandEtc(cls))	flag += 1;	
		
	} else {
		
		cls.setRent_mng_id(rent_mng_id);
		cls.setRent_l_cd(rent_l_cd);
		cls.setBand_st(request.getParameter("band_st")==null?"":	request.getParameter("band_st"));// ȸ������
		cls.setBand_ip_dt(request.getParameter("band_ip_dt"));  //�Ա�����
		cls.setDraw_amt(request.getParameter("draw_amt")==null?0:			AddUtil.parseDigit(request.getParameter("draw_amt"))); //ȸ����
		cls.setIp_amt(request.getParameter("ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ip_amt"))); //�Աݾ�
		cls.setRate_amt(request.getParameter("rate_amt")==null?0:			AddUtil.parseDigit(request.getParameter("rate_amt"))); //������
		cls.setRate_jp_dt(request.getParameter("rate_jp_dt"));  //��������
		cls.setReg_id(user_id); //�����id
		cls.setUser_id1(user_id); //�����id
		cls.setUser_id2("000004"); //�ѹ�����
		
		if(!re_db.insertClsBandEtc(cls))	flag += 1;	
	
	}
	
	  	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>

<%	if(flag != 0){ 	//ä���߽����̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//ä���߽����̺� ���� ����.. %>
	
   	 alert('ó���Ǿ����ϴ�');		
   	 parent.opener.location.reload();
     parent.window.close();			
<%	
	} %>

</script>
</body>
</html>

