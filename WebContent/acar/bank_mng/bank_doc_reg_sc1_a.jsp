<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*, acar.condition.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
		
 	String card = request.getParameter("card")==null?"":request.getParameter("card");
 	
	String vid1[] = request.getParameterValues("ch_mng_id");  
	String vid2[] = request.getParameterValues("ch_l_cd");
			
	int vid_size = 0;
	vid_size = vid1.length;
			
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	
	String doc_id =  FineDocDb.getFineGovNoNext("�ѹ�");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String doc_dt = request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt");	
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");	
	
	int count = 0;
	boolean flag = true;
			
	String ch_m_id="";  
	String ch_l_cd="";
	String ch_c_id="";
	
	float loan_amt = 0;
	int loan_amt1 = 0;
	int dam_amt = 0;	
	
	int loan_a_amt1 = 0;
			
	int  amt4 = 0;  //�����
	int  amt5 = 0;  //��漼
	int  car_f_amt = 0;   //�츮ī��(0046)�϶��� ���  	, ������ݿ��� ó���� ��� ��� 
	int  car_dc_amt = 0;   //�츮ī��(0046)�϶��� ���  	, ������ݿ��� ó���� ��� ��� 
	int  ecar_pur_amt = 0; //���ź����� 
		
	//�ߺ�üũ
	count = FineDocDb.getDocIdChk(doc_id);
		
	if(count == 0){
		//���� ���̺�
		FineDocBn.setDoc_id		(doc_id);
		FineDocBn.setDoc_dt		(doc_dt);
		FineDocBn.setGov_id		(bank_id);
		FineDocBn.setMng_dept		(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
		FineDocBn.setReg_id		(user_id);
		FineDocBn.setGov_st		(request.getParameter("lend_cond")==null?"":request.getParameter("lend_cond")); //��ȯ����
		FineDocBn.setFilename		(request.getParameter("lend_int")==null?"0.0":request.getParameter("lend_int")); //����ݸ� - �����û�� �����
		FineDocBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
		FineDocBn.setMng_pos		(request.getParameter("mng_pos")==null?"":request.getParameter("mng_pos"));
		FineDocBn.setTitle		(request.getParameter("title")==null?"":request.getParameter("title"));	
		FineDocBn.setH_mng_id		(request.getParameter("h_mng_id")==null?"":request.getParameter("h_mng_id"));
		FineDocBn.setB_mng_id		(request.getParameter("b_mng_id")==null?"":request.getParameter("b_mng_id"));
		FineDocBn.setApp_doc1		(request.getParameter("app_doc1")==null?"N":request.getParameter("app_doc1"));
		FineDocBn.setApp_doc2		(request.getParameter("app_doc2")==null?"N":request.getParameter("app_doc2"));
		FineDocBn.setApp_doc3		(request.getParameter("app_doc3")==null?"N":request.getParameter("app_doc3"));
		FineDocBn.setApp_doc4		(request.getParameter("app_doc4")==null?"N":request.getParameter("app_doc4"));
		FineDocBn.setApp_doc5		(request.getParameter("app_doc5")==null?"N":request.getParameter("app_doc5"));
		FineDocBn.setEnd_dt		(doc_dt); //���� �������� (�츮ī�� ���մ����� ���)
		
		FineDocBn.setOff_id		(off_id); //���� �����
		FineDocBn.setSeq		(request.getParameter("seq")==null?0:AddUtil.parseDigit(request.getParameter("seq"))); //���� 
		
		FineDocBn.setCltr_rat		(request.getParameter("cltr_rat")==null?"":request.getParameter("cltr_rat")); //�����缳����
		FineDocBn.setCltr_amt		(request.getParameter("cltr_amt")==null?0:AddUtil.parseDigit(request.getParameter("cltr_amt"))); //�����Ǵ�ݾ�
		
		FineDocBn.setCard_yn		(request.getParameter("card")==null?"":request.getParameter("card")); //ī���Һ� ����
		
		if ( bank_id.equals("0046") && off_id.equals("") ) {  //�츮ī���� ��� ����� setting
			FineDocBn.setOff_id	("010946");
			FineDocBn.setSeq	(439);
		}
		
		flag = FineDocDb.insertFineDoc(FineDocBn);
		//�������� - doc_dt + 2 �� ���� 
		String app_dt = "";		
		app_dt = FineDocDb.getAfterDt(doc_dt, 1);
		flag =  FineDocDb.updateFineDoc(doc_id, "end_dt", app_dt);  //ī���Һ��� ��� ������
		flag =  FineDocDb.updateFineDoc(doc_id, "app_dt", app_dt);  //ī���Һ��� ��� ������
						
		for(int i=0;i < vid_size;i++){
			
			ch_m_id = vid1[i];
			ch_l_cd = vid2[i];
									
			//�������
			Hashtable loan = cdb.getLoanListExcel(ch_m_id, ch_l_cd, "0");
			//����ĳ��Ż�� ��쵵  ó�� 
		 	if (bank_id.equals("0046") || bank_id.equals("0011")  ) { //�츮ī��(0046) - ���������� 80% - 202104	  -- ���ź������� �ִ� ��� ����� -���ź����� ó��.	 ecar_pur_amt
		 						 
		 		car_f_amt = AddUtil.parseDigit(String.valueOf(loan.get("CAR_F_AMT")));  //��������   
		 		car_dc_amt = AddUtil.parseDigit(String.valueOf(loan.get("CAR_DC_AMT")));  //dc�ݾ�    
		 		loan_a_amt1 = car_f_amt - car_dc_amt;
		 
		 		if (bank_id.equals("0046") ) {
		 			loan_amt = AddUtil.parseFloat(Integer.toString(loan_a_amt1)) *  80/100;     
			 	} else {
			 		loan_amt = AddUtil.parseFloat(Integer.toString(loan_a_amt1)) *  100/100;    
			 	}		 		
		 	}   
		 		 
        	loan_amt1 = (int) loan_amt;
        	
        	if (bank_id.equals("0046") ) {
        		loan_amt1 = AddUtil.th_rnd(loan_amt1); 
        	} else {
        		loan_amt1 = AddUtil.ten_th_rnd(loan_amt1);        	
        	}	
        	//-- ���ź������� �ִ� ��� ����� -���ź����� ó��.	 ecar_pur_amt
        	ecar_pur_amt = AddUtil.parseDigit(String.valueOf(loan.get("ECAR_PUR_AMT")));  //���ź�����   
        	loan_amt1 = loan_amt1 - ecar_pur_amt;        	
		 	
			FineDocListBn.setDoc_id			(doc_id);
			FineDocListBn.setCar_mng_id		(String.valueOf(loan.get("CAR_MNG_ID")));
			FineDocListBn.setSeq_no			(i + 1);
			FineDocListBn.setRent_mng_id	(ch_m_id);
			FineDocListBn.setRent_l_cd		(ch_l_cd);
			FineDocListBn.setRent_s_cd		("");
			FineDocListBn.setFirm_nm		(String.valueOf(loan.get("FIRM_NM")));
						
			FineDocListBn.setAmt1			(AddUtil.parseDigit(String.valueOf(loan.get("FEE_AMT"))));  //�뿩��
			FineDocListBn.setAmt2			(AddUtil.parseDigit(String.valueOf(loan.get("TOT_FEE_AMT"))));  // �Ѵ뿩��
			FineDocListBn.setAmt3			(AddUtil.parseDigit(String.valueOf(loan.get("CAR_AMT"))));     // ��������
								
			FineDocListBn.setAmt4			(loan_amt1);   //����� 
			FineDocListBn.setAmt5			(0);   //��漼 
				
			if ( bank_id.equals("0046") ) {		// �츮ī�� (0046)  -��������(car_f_amt)
					dam_amt =  car_f_amt - car_dc_amt ;			  
					FineDocListBn.setAmt6		( dam_amt );			          		    		    		    	
	     //   }  else {  //  bank_id.equals("0039") -2021����� �㺸�� 50%
	     //           FineDocListBn.setAmt6		( (amt4 + amt5) /2 );
	        } else  {		// �츮ī�� (0011)  -��������(car_f_amt)
					FineDocListBn.setAmt6		( amt4 /2 );			          		    		    		    	
	     //   }  else {  //  bank_id.equals("0039") -2021����� �㺸�� 50%
	     //           FineDocListBn.setAmt6		( (amt4 + amt5) /2 );
	        } 
                 				
			FineDocListBn.setPaid_no		(String.valueOf(loan.get("CON_MON")));			
			FineDocListBn.setReg_id			(user_id);
			
			flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());								
		}
				
		FineDocDb.call_p_card_debt_batch(doc_id);  //����ī�� �����Һΰ��� ī�� ���� 	 ȣ��		
		
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='javascript'>
<!--
	function go_step2(){		
	
		var fm = document.form1;	
		
		fm.action = '/fms2/car_pur/pur_doc_frame.jsp';
		fm.target = "d_content";
		fm.submit();
		
		parent.window.close();	
	
	}	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='doc_id' value='<%=doc_id%>'>
</form>
<script>
<%	if(count == 0){%>
<%		if(flag==true){%>
			alert("���������� ó���Ǿ����ϴ�.");
			go_step2();
<%		}else{%>
			alert("�����߻�!");
<%		}%>
<%	}else{%>
			alert("�̹� ��ϵ� ������ȣ�Դϴ�. Ȯ���Ͻʽÿ�.");
//			parent.document.form1.bank_nm.focus();
<%	}%>
</script>
</body>
</html>

