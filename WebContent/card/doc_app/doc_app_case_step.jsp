<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	
	out.println("ī����ǥ �ڵ���ǥ �����ϱ� 1�ܰ�"+"<br><br>");
	
	String cardno 		= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 		= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String buy_dt 		= request.getParameter("buy_dt")==null?"":request.getParameter("buy_dt");
	
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String acct_code_g2 	= "";
	String doc_acct_cont 	= request.getParameter("doc_acct_cont")==null?"":request.getParameter("doc_acct_cont");
	String ven_code 	= "";
	String buy_user_nm 	= "";
	String firm_nm 	= "";
	int data_no =0;
	int flag = 0;
	int seq = 0;
	
	
	
	//�����
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
	//�����Է����� ���� ���� - 20091015	
	String acct_cont[] 		= request.getParameterValues("acct_cont"); //���� : ���� �� ����ܴ̿� 1��
	String item_name[] 		= request.getParameterValues("item_name"); // car_no
	String rent_l_cd[] 		= request.getParameterValues("rent_l_cd"); //rent_l_cd
	String serv_id[] 		= request.getParameterValues("serv_id"); //����id
	String item_code[] 		= request.getParameterValues("item_code"); //car_mng_id
	String call_t_nm[] 		= request.getParameterValues("call_t_nm");   //���� call center ����
	String call_t_tel[] 		= request.getParameterValues("call_t_tel");
	
	//[1�ܰ�] ��ǥ����
	
	out.println("��ǥ����"+"<br><br>");
	
	//ī������
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	cd_bean.setBuy_dt(buy_dt);
	cd_bean.setBuy_s_amt(request.getParameter("buy_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_s_amt")));
	cd_bean.setBuy_v_amt(request.getParameter("buy_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_v_amt")));
	cd_bean.setBuy_amt(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_amt")));
	cd_bean.setVen_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	cd_bean.setVen_name(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
	cd_bean.setAcct_code(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));
	cd_bean.setTax_yn(request.getParameter("tax_yn")==null?"N":request.getParameter("tax_yn"));
	cd_bean.setVen_st(request.getParameter("ven_st")==null?"1":request.getParameter("ven_st"));
	
	//�����Ļ���,�����,�������,����������,���������, ��ź�
	if(acct_code.equals("00001") || acct_code.equals("00002") || acct_code.equals("00003") || acct_code.equals("00004") || acct_code.equals("00005") || acct_code.equals("00009") || acct_code.equals("00016") || acct_code.equals("00017")){
		cd_bean.setAcct_code_g(request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g"));
	}
	//�����Ļ���
	if(acct_code.equals("00001") || acct_code.equals("00004")){
		cd_bean.setAcct_code_g2(request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2"));
	}
	
	//����������,���������,��������, ��ݺ�
	if(acct_code.equals("00004") || acct_code.equals("00005") || acct_code.equals("00006")|| acct_code.equals("00018") || acct_code.equals("00019")){
		cd_bean.setItem_code	(item_code[0]);
		cd_bean.setItem_name	(item_name[0]);		
		
	}
	
	//���������,��������
	if(acct_code.equals("00005") || acct_code.equals("00006") ){
		cd_bean.setServ_id	(serv_id[0]);		 
	}
	
	if(acct_code.equals("00004")) {
		cd_bean.setO_cau	(request.getParameter("o_cau")==null?"":request.getParameter("o_cau"));
		cd_bean.setOil_liter	(request.getParameter("oil_liter")==null?0:AddUtil.parseFloat(request.getParameter("oil_liter")));
	}	
		
	cd_bean.setAcct_cont	(acct_cont[0]);
	cd_bean.setUser_su	(request.getParameter("user_su")==null?"":request.getParameter("user_su"));
	cd_bean.setUser_cont	(request.getParameter("user_cont")==null?"":request.getParameter("user_cont"));
	cd_bean.setBuy_user_id	(request.getParameter("buy_user_id")==null?"":request.getParameter("buy_user_id"));
	cd_bean.setRent_l_cd	(rent_l_cd[0]);
	
	if(cd_bean.getAcct_cont().equals("")){
		cd_bean.setAcct_cont(doc_acct_cont);
	}
	
	if(!CardDb.updateCardDoc(cd_bean)) flag += 1;
	
	out.println("flag="+flag+"<br><br>");

	//[1_1�ܰ�] ��ǥ����-������ ����
	//������ ����
	int user_su 	= request.getParameter("user_su")==null?0:AddUtil.parseInt(request.getParameter("user_su"));
	
	String value1[] = request.getParameterValues("user_case_id");
	String value2[] = request.getParameterValues("money");
	String value3[] = request.getParameterValues("client_nm");
	String value4[] = request.getParameterValues("mgr_nm");
	String value5[] = request.getParameterValues("user_nm");
	int cnt = 0;
	
	
	if(!CardDb.deleteCardDocUser(cardno, buy_id)) flag += 1;
	
	if(user_su > 0){
		for(int i=0;i < user_su;i++){
			if(!value2[i].equals("0")){
				CardDocUserBean cdu_bean = new CardDocUserBean();
				cdu_bean.setCardno	(cardno);
				cdu_bean.setBuy_id	(buy_id);
				cdu_bean.setSeq		(AddUtil.addZero2(i+1));
				cdu_bean.setUser_st	("1");
				if(!value1[i].equals("")) 		cdu_bean.setDoc_user(value1[i]);
				else							cdu_bean.setDoc_user(value5[i+1]);
				cdu_bean.setDoc_amt	(AddUtil.parseDigit(value2[i]));
				if(!CardDb.insertCardDocUser(cdu_bean)) flag += 1;
				cnt ++;
			}
		}
	}
	 
	//
	int cnt1 = 0;
	//���� �� �������Ͽ� �������� ���� �Է� �� ���		
	
	//���� ���� bit ����
	if( ( acct_code.equals("00005")  &&  acct_code_g.equals("6")  ) || acct_code.equals("00006")){	
		
		   //������Ÿ ���� ��ȿ ó��
		Vector vt = CardDb.getCardDocItemList(cardno, buy_id);
		int vt_size = vt.size();
		
		for(int i=0; i < vt_size; i++){
       		Hashtable ht = (Hashtable)vt.elementAt(i);       		
       		if(!CardDb.updateCardDocItem(String.valueOf(ht.get("ITEM_CODE")), String.valueOf(ht.get("SERV_ID")))  ) flag += 1;       	       				
		}	
		
		if(!CardDb.deleteCardDocItem(cardno, buy_id)) flag += 1;
		
		for(int i=0;i < 19;i++){
			if(!item_name[i].equals("")){
					CardDocItemBean cdi_bean = new CardDocItemBean();
					cdi_bean.setCardno	(cardno);
					cdi_bean.setBuy_id	(buy_id);
					cdi_bean.setSeq		(AddUtil.addZero2(i+1));
					cdi_bean.setItem_code(item_code[i]);	
					cdi_bean.setRent_l_cd(rent_l_cd[i]);	
					cdi_bean.setServ_id(serv_id[i]);	
					cdi_bean.setItem_name(item_name[i]);	
					cdi_bean.setAcct_cont(acct_cont[i]);	
					cdi_bean.setCall_t_nm(call_t_nm[i]);	
					cdi_bean.setCall_t_tel(call_t_tel[i]);					
												
				//	cdi_bean.setDoc_amt	(AddUtil.parseDigit(doc_amt[i]));
					if(!CardDb.insertCardDocItem(cdi_bean)) flag += 1;
					
					//���� ���� ǥ�� - car_mng_id , serv_id �� jung_st = '1'�� 
					if(!CardDb.updateCardDocServiceItem(item_code[i], serv_id[i], buy_dt, call_t_nm[i], call_t_tel[i] ) ) flag += 1;
					cnt1 ++;
			}
		}
	 
    }
    
	//[2�ܰ�] �ڵ���ǥ ����

		//ī����ǥ��ȸ
		Hashtable card_doc = CardDb.getAppCardDocSelectList(cardno, buy_id);
		
		buy_user_nm = String.valueOf(card_doc.get("USER_NM"));
		
		//���������-����
		Hashtable per = neoe_db.getPerinfoDept(buy_user_nm);//-> neoe_db ��ȯ

		//�׿��� �ڵ���ǥ ó��-------------------------------
		
		AutoDocuBean ad_bean = new AutoDocuBean();
		ad_bean.setBuy_id	(buy_id);
		ad_bean.setNode_code("S101");
		ad_bean.setVen_code	(String.valueOf(card_doc.get("VEN_CODE")));
		ad_bean.setFirm_nm	(String.valueOf(card_doc.get("VEN_NAME")));
		ad_bean.setWrite_dt	(String.valueOf(card_doc.get("BUY_DT")));
		ad_bean.setAcct_dt	(ad_bean.getWrite_dt());
		
		ad_bean.setAcct_code(String.valueOf(card_doc.get("ACCT_CODE")));
		
		if(String.valueOf(card_doc.get("ACCT_CODE")).equals("00001")){
			if(String.valueOf(card_doc.get("ACCT_CODE_G")).equals("3")){
				ad_bean.setAcct_code("00002");
			}		
		}
		
		ad_bean.setAmt		(AddUtil.parseInt(String.valueOf(card_doc.get("BUY_S_AMT"))));
		ad_bean.setAmt2		(AddUtil.parseInt(String.valueOf(card_doc.get("BUY_V_AMT"))));
		ad_bean.setInsert_id(user_id);
		ad_bean.setItem_code(String.valueOf(card_doc.get("ITEM_CODE")));
		ad_bean.setItem_name(String.valueOf(card_doc.get("ITEM_NAME")));
		
		ad_bean.setCardno	(cardno);
		ad_bean.setCard_name(String.valueOf(card_doc.get("CARD_NAME")));
		
		ad_bean.setVen_type	("0");
		ad_bean.setS_idno	(neoe_db.getVendorEnpNo(ad_bean.getVen_code()));//ven_code�� ��ȸ�ϱ�//-> neoe_db ��ȯ
		
		//����ī���� ��� - com�� ven����
		if ( cardno.equals("0000-0000-0000-0000")) {
			ad_bean.setCom_code	(String.valueOf(card_doc.get("VEN_CODE")));
			ad_bean.setCom_name	(String.valueOf(card_doc.get("VEN_NAME")));
		} else {	
			ad_bean.setCom_code	(String.valueOf(card_doc.get("COM_CODE")));
			ad_bean.setCom_name	(String.valueOf(card_doc.get("COM_NAME")));
		}	
		
		if(!buy_user_nm.equals("")){
			ad_bean.setSa_code	(String.valueOf(per.get("SA_CODE")));
			ad_bean.setKname	(String.valueOf(per.get("KNAME")));
			ad_bean.setDept_code(String.valueOf(per.get("DEPT_CODE")));
			ad_bean.setDept_name(String.valueOf(per.get("DEPT_NAME")));
		}
		ad_bean.setAcct_cont(doc_acct_cont);
		ad_bean.setTax_yn(request.getParameter("tax_yn")==null?"N":request.getParameter("tax_yn"));
		
		
		ad_bean.setAcct_cd1(String.valueOf(card_doc.get("ACCT_CODE_G")));
		
		out.println("�����ڵ�="+String.valueOf(card_doc.get("ACCT_CODE"))+"<br><br>");
		out.println("�����ڵ�="+ad_bean.getAcct_code()+"<br>");
//		System.out.println("��������="+cardno+", "+String.valueOf(card_doc.get("BUY_DT"))+": "+ad_bean.getTax_yn()+"<br>");		
		
		
		//����ī�尡 �ƴϸ�
		if ( !cardno.equals("0000-0000-0000-0000")) {
			//�ܰ躰 ����
			//[2-1�ܰ�] data_no ��������
			//data_no = neoe_db.insertCardAutoDocu_step1(ad_bean);		//-> neoe_db ��ȯ
			//ad_bean.setData_no(data_no);
			//[2-2�ܰ�] ������� �ڵ���ǥ ����
			//if(!neoe_db.insertCardAutoDocu_step2(ad_bean)) flag += 1;		//-> neoe_db ��ȯ
			//[2-3�ܰ�] �����ޱ� �ڵ���ǥ ����
			//if(!neoe_db.insertCardAutoDocu_step3(ad_bean)) flag += 1;		//-> neoe_db ��ȯ
			//[2-4�ܰ�] �ΰ�����ޱ�+���� �ڵ���ǥ ����
			//if(ad_bean.getAmt2() > 0){//������ǥ
			//	if(!neoe_db.insertCardAutoDocu_step4(ad_bean)) flag += 1;	//-> neoe_db ��ȯ
			//}
			
			
											
		}

		//����ī�尡 �ƴϸ�
		if ( !cardno.equals("0000-0000-0000-0000")) {
		
			//if(data_no == 0){//����
				//flag = 1;
				//�̹� �ۼ��� �ڵ���ǥ ����
			//}else{//ī����ǥ�� �ڵ���ǥ �ۼ�����/�Ϸù�ȣ/������ ���� �ֱ�
				//ī������
				//cd_bean.setApp_id(user_id);
				//cd_bean.setApp_dt(AddUtil.getDate());
				//cd_bean.setAutodocu_write_date(ad_bean.getWrite_dt());
				//cd_bean.setAutodocu_data_no(String.valueOf(data_no));
				//out.println("1="+cd_bean.getApp_id()+"<br>");
				//out.println("2="+cd_bean.getApp_dt()+"<br>");
				//out.println("3="+cd_bean.getAutodocu_write_date()+"<br>");
				//out.println("4="+cd_bean.getAutodocu_data_no()+"<br>");								
				//if(!CardDb.updateCardDoc(cd_bean)) flag += 1;
				
				
				//�ڵ���ǥ ���ν��� ȣ��----------------------------------------------------------------------------
				//int flag4 = 0;
				//System.out.println(" �ڵ���ǥ ���ν��� ��� "+sender_bean.getUser_nm()+" "+cardno+" "+buy_id);
				String  d_flag1 =  neoe_db.call_sp_card_account(sender_bean.getUser_nm(), "", cardno, buy_id);			
				if (!d_flag1.equals("0")) flag = 1;
				//System.out.println(" �ڵ���ǥ ���ν��� ��� "+sender_bean.getUser_nm()+" "+cardno+" "+buy_id);
				//--------------------------------------------------------------------------------------------------	
			//}
		}	
		
		
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'doc_app_frame.jsp';
		fm.target = "d_content";
		fm.submit();
		
		parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<a href="javascript:go_step()">�Ϸ�</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("�ڵ���ǥ �ۼ��� ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("���������� �����Ͽ����ϴ�.");
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
