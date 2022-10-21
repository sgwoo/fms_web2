<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag9 = true;
	int result = 0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	UsersBean user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�߰�������
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "5");
	//�߰����Ǹ�ó
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
	

		//0. ������� car_pur--------------------------------------------------------------------------------------
		
		pur.setTrf_amt1		(request.getParameter("trf_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt1")));
		pur.setTrf_st1		(request.getParameter("trf_st1")	==null?"":request.getParameter("trf_st1"));
		pur.setCard_kind1	(request.getParameter("card_kind1")	==null?"":request.getParameter("card_kind1"));
		pur.setCardno1		(request.getParameter("cardno1")	==null?"":request.getParameter("cardno1"));
		pur.setTrf_cont1	(request.getParameter("trf_cont1")	==null?"":request.getParameter("trf_cont1"));
		pur.setAcc_st1		(request.getParameter("acc_st1")	==null?"":request.getParameter("acc_st1"));
		
		pur.setTrf_amt2		(request.getParameter("trf_amt2").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt2")));
		pur.setTrf_st2		(request.getParameter("trf_st2")	==null?"":request.getParameter("trf_st2"));
		pur.setCard_kind2	(request.getParameter("card_kind2")	==null?"":request.getParameter("card_kind2"));
		pur.setCardno2		(request.getParameter("cardno2")	==null?"":request.getParameter("cardno2"));
		pur.setTrf_cont2	(request.getParameter("trf_cont2")	==null?"":request.getParameter("trf_cont2"));
		pur.setAcc_st2		(request.getParameter("acc_st2")	==null?"":request.getParameter("acc_st2"));
		
		pur.setTrf_amt3		(request.getParameter("trf_amt3").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt3")));
		pur.setTrf_st3		(request.getParameter("trf_st3")	==null?"":request.getParameter("trf_st3"));
		pur.setCard_kind3	(request.getParameter("card_kind3")	==null?"":request.getParameter("card_kind3"));
		pur.setCardno3		(request.getParameter("cardno3")	==null?"":request.getParameter("cardno3"));
		pur.setTrf_cont3	(request.getParameter("trf_cont3")	==null?"":request.getParameter("trf_cont3"));
		pur.setAcc_st3		(request.getParameter("acc_st3")	==null?"":request.getParameter("acc_st3"));
		
		pur.setEst_car_no	(request.getParameter("est_car_no")	==null?"":request.getParameter("est_car_no"));
		pur.setCar_num		(request.getParameter("car_num")	==null?"":request.getParameter("car_num"));
		pur.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
		pur.setCon_amt_cont	(request.getParameter("con_amt_cont")	==null?"":request.getParameter("con_amt_cont"));
		pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
		pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
		pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
		pur.setPur_est_dt	(request.getParameter("pur_est_dt")	==null?"":request.getParameter("pur_est_dt"));
		
		
		//=====[CAR_PUR] update=====
		flag3 = a_db.updateContPur(pur);
		
		emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
		emp1.setEmp_acc_no(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
		emp1.setEmp_acc_nm(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
	
		if(!emp1.getRent_mng_id().equals("")){
			//=====[commi] update=====
			flag9 = a_db.updateCommiNew(emp1);
		}
		
	
	//1. ����ó���� ����ó��-------------------------------------------------------------------------------------------
	
	//=====[doc_settle] update=====
	
	String doc_step = "2";
	
	//�ѹ����� �����̸� ���� ���� �Ϸ�
	if(doc_bit.equals("5")) doc_step = "3";
	
	
	flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
	//out.println("����ó���� ����<br>");
	
	
	//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sub 		= "�߰������ ���� ��û";
	String cont 	= "["+firm_nm+"] �߰������ ������ ��û�մϴ�.";
	String url 		= "/fms2/car_pur/pur_doc_ac_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
	String target_id = "";
	String m_url = "/fms2/car_pur/pur_doc_ac_frame.jsp";
	
	//���������� target_id
	
	if(doc_bit.equals("2"))	target_id = doc.getUser_id3();				//��������
	if(doc_bit.equals("3"))	target_id = doc.getUser_id5();				//ȸ�����
	if(doc_bit.equals("4"))	target_id = doc.getUser_id5();				//�ѹ�����
	if(doc_bit.equals("5"))	target_id = nm_db.getWorkAuthUser("��������");	//�����������ó��
	
	
	//����� ȸ����� �����ϰ� �ѹ��������� �Ѿ��. (�������� ȸ������� �����Ƿ�) 20131001 ȸ������� ��� ����
	if(doc_bit.equals("3")){// && user_bean.getBr_nm().equals("����")
		doc_bit 	= "4";
		target_id 	= doc.getUser_id5();
	}
	
	
	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
	if(!cs_bean.getUser_id().equals("")){
		if(!cs_bean.getWork_id().equals("")){
		 	target_id = cs_bean.getWork_id();
			//���������ڵ� ����
			//=====[doc_settle] update=====
			if(doc_bit.equals("3"))	flag4 = d_db.updateDocSettleUserCng(doc_no, "4", target_id);//ȸ�����
			if(doc_bit.equals("4"))	flag4 = d_db.updateDocSettleUserCng(doc_no, "5", target_id);//�ѹ�����
		}else{
			if(doc_bit.equals("4") && target_id.equals(nm_db.getWorkAuthUser("�����ѹ�����"))) 		target_id = nm_db.getWorkAuthUser("���翵������"); 			//�ѹ����� : �ѹ����� �ް��� ���翵������ ����
 			if(doc_bit.equals("5") && target_id.equals(nm_db.getWorkAuthUser("��������")))		target_id = nm_db.getWorkAuthUser("��༭�����˴����");	//�����������ó�� : �������� �ް��� ��༭�����˴���� ó��
		}
	}
	
	
	if(doc_bit.equals("5")){
		sub 	= "�߰������ ���� �ϰ�";
		cont 	= "�߰������ ������ ���� �ϰ��ϴ� ��� �����ϼ���";
		url 	= "/fms2/car_pur/pur_pay_frame.jsp";
		m_url = "/fms2/car_pur/pur_pay_frame.jsp";
	}
	
	//����� ���� ��ȸ
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
	
	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	

	
	xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  				"    <MSGICON>10</MSGICON>"+
  				"    <MSGSAVE>1</MSGSAVE>"+
  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
  				"    <FLDTYPE>1</FLDTYPE>"+
  				"  </ALERTMSG>"+
  				"</COOLMSG>";
	
	CdAlertBean msg = new CdAlertBean();
	msg.setFlddata(xml_data);
	msg.setFldtype("1");
	
	flag2 = cm_db.insertCoolMsg(msg);
	
	System.out.println("��޽���(�߰�����ݰ���)"+firm_nm+", doc_bit="+doc_bit+"-----------------------"+target_bean.getUser_nm());

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='flag1'	 		    value='<%=flag1%>'>     
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action = 'pur_doc_ac_u.jsp';
	fm.target = 'd_content';
	<%if(doc_bit.equals("3") || doc_bit.equals("5")){%>
	//fm.action = 'pur_doc_c.jsp';
	fm.action = 'pur_doc_ac_frame.jsp';
	<%}%>
	fm.submit();
<%	}else{	%>
		alert('�����ͺ��̽� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');		
<%	}	%>
</script>
<body>
</body>
</html>