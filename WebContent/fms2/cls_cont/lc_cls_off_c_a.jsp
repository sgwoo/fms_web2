<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*, acar.user_mng.*, acar.coolmsg.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	int    scd_size 	= request.getParameter("vt_size8")		==null?0 :AddUtil.parseInt(request.getParameter("vt_size8"));  //�ߵ����Կɼǽ� �ܿ��뿩�� ������ ���� 
	
	String add_saction_id =  request.getParameter("add_saction_id")==null?"":	request.getParameter("add_saction_id"); //�ߵ����Կɼ��ΰ�� ����� ����	
	int    old_opt_amt 	= request.getParameter("old_opt_amt")		==null?0 :AddUtil.parseInt(request.getParameter("old_opt_amt"));  //�ߵ����Կɼǽ� ���� ���Կɼ� �ݾ� 
	int    b_old_opt_amt 	= request.getParameter("fee_size_1_opt_amt")		==null?0 :AddUtil.parseInt(request.getParameter("fee_size_1_opt_amt"));  //�������� ���Կɼ� �ݾ�
	int    m_r_fee_amt 	= request.getParameter("m_r_fee_amt")		==null?0 :AddUtil.parseInt(request.getParameter("m_r_fee_amt"));  //�ߵ����Կɼǽ� �뿩�� �ݿ���
	int    count1 	= request.getParameter("count1")		==null?0 :AddUtil.parseInt(request.getParameter("count1"));  // 
	int    count2 	= request.getParameter("count2")		==null?0 :AddUtil.parseInt(request.getParameter("count2"));  // 
	float   rc_rate 	= request.getParameter("rc_rate")	==null?0 :AddUtil.parseFloat(request.getParameter("rc_rate"));  //�ߵ����Կɼǽ� ���簡ġ��
	String mt = request.getParameter("mt")==null?"":request.getParameter("mt");  //���Կɼ� ����  1:�ߵ����Կɼ�, 2:������Կɼ�
	
	int flag = 0;	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
			
	ClsEtcBean cls = new ClsEtcBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setTerm_yn("0");  //�Ƿڵ��
	cls.setCls_st(cls_st);
	cls.setCls_dt(request.getParameter("cls_dt"));
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//���̿�Ⱓ ��
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//���̿�Ⱓ ��
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//��������
	
	cls.setCls_doc_yn(cls_doc_yn);
	cls.setReg_id(reg_id); //�����id
	
	//�ߵ�����, ���Կɼ�, �������� �����Ƿ� ���
	
	cls.setCancel_yn(request.getParameter("cancel_yn")==null?"":request.getParameter("cancel_yn"));
	cls.setGrt_amt(request.getParameter("grt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("grt_amt")));
	cls.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	cls.setIfee_mon(request.getParameter("ifee_mon")==null?"":		request.getParameter("ifee_mon"));
	cls.setIfee_day(request.getParameter("ifee_day")==null?"":		request.getParameter("ifee_day"));
	cls.setIfee_ex_amt(request.getParameter("ifee_ex_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_ex_amt")));
	cls.setRifee_s_amt(request.getParameter("rifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_s_amt")));
	cls.setRifee_v_amt(request.getParameter("rifee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_v_amt"))); //2022-04
	cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
	cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
	cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
	cls.setRfee_v_amt(request.getParameter("rfee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_v_amt"))); //2022-04
	cls.setNfee_s_amt(request.getParameter("nfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("nfee_s_amt")));
	cls.setNfee_mon(request.getParameter("nfee_mon")==null?"":		request.getParameter("nfee_mon"));
	cls.setNfee_day(request.getParameter("nfee_day")==null?"":		request.getParameter("nfee_day"));
	cls.setNfee_amt(request.getParameter("nfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt"))); //�̳��뿩�� ���ʱݾ�
	cls.setEx_di_amt(request.getParameter("ex_di_amt")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt"))); //������ �뿩�� �ݾ� (���� �Ǵ� �ܾ�)
	cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt"))); //�뿩�� �Ѿ�
	cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt"))); //����մ뿩��
	cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));  //�ܿ��Ⱓ
	cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));   //�ܿ��Ⱓ
	cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt"))); //�ܿ��Ⱓ�Ѵ뿩��
	cls.setDft_int(request.getParameter("dft_int")==null?"":		request.getParameter("dft_int")); //�ߵ����� ������
	cls.setDft_int_1(request.getParameter("dft_int_1")==null?"":		request.getParameter("dft_int_1")); //�ߵ����� ������ Ȯ��
	cls.setDft_amt(request.getParameter("dft_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt")));   //�ߵ���������� ���ʱݾ�
	cls.setCar_ja_amt(request.getParameter("car_ja_amt")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt"))); //��å�� ���ʱݾ�
	cls.setDly_amt(request.getParameter("dly_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt")));   //��ü�� ���ʱݾ�
	cls.setEtc_amt(request.getParameter("etc_amt")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt")));  //����ȸ�����ֺ� ���ʱݾ�
	cls.setEtc2_amt(request.getParameter("etc2_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt"))); //����ȸ���δ�� ���ʱݾ�
	cls.setEtc3_amt(request.getParameter("etc3_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt"))); //������������ ���ʱݾ�
	cls.setEtc4_amt(request.getParameter("etc4_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt"))); //��Ÿ���ع��� ���ʱݾ�

	cls.setFine_amt(request.getParameter("fine_amt")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt"))); //���·� ���ʱݾ�
	cls.setNo_v_amt(request.getParameter("no_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt")));   //�ΰ��� ���ʱݾ�
	cls.setFdft_amt1(request.getParameter("fdft_amt1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1")));//�հ� ���ʱݾ�
	cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));//�����Աݾ�
	
	cls.setDfee_amt(request.getParameter("dfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt")));   //������+�̳��뿩�� ���ʱݾ�	
	cls.setDfee_v_amt(request.getParameter("dfee_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_v_amt")));   //������+�̳��뿩�� ���ʱݾ� �ΰ��� - 2022-04 �߰� 		
	cls.setFine_amt_1(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //���·� Ȯ���ݾ�
	cls.setCar_ja_amt_1(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //��å�� Ȯ���ݾ�
	cls.setDly_amt_1(request.getParameter("dly_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //��ü�� Ȯ���ݾ�
	cls.setEtc_amt_1(request.getParameter("etc_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //����ȸ�����ֺ� Ȯ���ݾ�
	cls.setEtc2_amt_1(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //����ȸ���δ�� Ȯ���ݾ�
	cls.setDft_amt_1(request.getParameter("dft_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //�ߵ���������� Ȯ���ݾ�
	cls.setEx_di_amt_1(request.getParameter("ex_di_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt_1")));   //������ Ȯ���ݾ�
	cls.setNfee_amt_1(request.getParameter("nfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt_1")));   //�뿩�� Ȯ���ݾ�
	cls.setEtc3_amt_1(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //������������ Ȯ���ݾ�
	cls.setEtc4_amt_1(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //��Ÿ���ع��� Ȯ���ݾ�

	cls.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //�ΰ��� Ȯ���ݾ�
	cls.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//�հ� ���ʱݾ�
	cls.setDfee_amt_1(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1")));   //������+�̳��뿩�� Ȯ���ݾ�
	cls.setDfee_v_amt_1(request.getParameter("dfee_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_v_amt_1")));   //������+�̳��뿩�� Ȯ���ݾ� - 2022-04 �߰� 		
	
	cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_s_amt")));   //��������� ���ް�
	cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_v_amt")));   //��������� �ΰ���
	
	cls.setD_saction_id(request.getParameter("d_saction_id")==null?"":	request.getParameter("d_saction_id")); //Ȯ���ݾ� ������
	cls.setD_reason(request.getParameter("d_reason")==null?"":	request.getParameter("d_reason"));             //Ȯ���ݾ� ����
	cls.setDly_saction_id(request.getParameter("dly_saction_id")==null?"":	request.getParameter("dly_saction_id")); //��ü�ᰨ�� ������
	cls.setDly_reason(request.getParameter("dly_reason")==null?"":	request.getParameter("dly_reason"));       //��ü�ᰨ�� ����
	cls.setDft_saction_id(request.getParameter("dft_saction_id")==null?"":	request.getParameter("dft_saction_id")); //�ߵ���������ݰ��� ������
	cls.setDft_reason(request.getParameter("dft_reason")==null?"":	request.getParameter("dft_reason"));       //�ߵ���������ݰ��� ����
	
	cls.setDiv_st(request.getParameter("div_st")==null?"":				request.getParameter("div_st")); 						   //���� 1:�ϳ�, 2:�г�  
	cls.setDiv_cnt(request.getParameter("div_cnt")==null?1:				AddUtil.parseDigit(request.getParameter("div_cnt")));     //�г�Ƚ��  
	cls.setEst_dt(request.getParameter("est_dt")==null?"":				request.getParameter("est_dt"));  						   //�Աݿ�����
	cls.setEst_amt(request.getParameter("est_amt")==null?0:				AddUtil.parseDigit(request.getParameter("est_amt")));	   //ä�Ǿ����ݾ� 
	cls.setEst_nm(request.getParameter("est_nm")==null?"":				request.getParameter("est_nm"));  				   //�Աݾ�����
	cls.setGur_nm(request.getParameter("gur_nm")==null?"":				request.getParameter("gur_nm")); 				   //����������
	cls.setGur_rel_tel(request.getParameter("gur_rel_tel")==null?"":	request.getParameter("gur_rel_tel"));      //Ȯ���ݾ� ����
	cls.setGur_rel(request.getParameter("gur_rel")==null?"":			request.getParameter("gur_rel")); 		   //Ȯ���ݾ� ������
	cls.setRemark(request.getParameter("remark")==null?"":				request.getParameter("remark"));           //ó���ǰ�
	
	if(cls_st.equals("8")){//���Կɼ��ΰ�� 
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));	
		cls.setFdft_amt3(request.getParameter("fdft_amt3")==null?0:					AddUtil.parseDigit(request.getParameter("fdft_amt3")));   //�����Ű��� �� ���Աݾ�
	}	
				
	//���ݰ�꼭 �����Ƿڰ� ��� : �Ƿ��ߴ��� �������ݰ�꼭�� ����ȵ� �� ���� :��⿬ü�� ��� (���ݽ� ���ݰ�꼭 ����ó��)
	cls.setTax_chk0(request.getParameter("tax_chk0")==null?"N":request.getParameter("tax_chk0"));  //�ߵ����������
	cls.setTax_chk1(request.getParameter("tax_chk1")==null?"N":request.getParameter("tax_chk1"));  //�������ֺ��
	cls.setTax_chk2(request.getParameter("tax_chk2")==null?"N":request.getParameter("tax_chk2"));  //�����δ���
	cls.setTax_chk3(request.getParameter("tax_chk3")==null?"N":request.getParameter("tax_chk3"));  //��Ÿ���ع���
	cls.setTax_chk4(request.getParameter("tax_chk4")==null?"N":request.getParameter("tax_chk4"));  // �ʰ�����
	
	cls.setTax_reg_gu(request.getParameter("tax_reg_gu")==null?"N":request.getParameter("tax_reg_gu"));  //��꼭 ���� ����
		
	String tax_supply[] = request.getParameterValues("tax_supply");
  	 String tax_value[] = request.getParameterValues("tax_value");
	String tax_g[] = request.getParameterValues("tax_g");
	
	int tax_size = tax_g.length;
	for(int i = 0; i<tax_size; i++){
    		String tax_chk = request.getParameter("tax_chk"+i)==null?"N":	request.getParameter("tax_chk"+i);
		//	out.println(tax_chk);
  			if(tax_chk.equals("Y")){
    	//		out.println("����"+i+"=<br><br>");
	    //		out.println("tax_g="+tax_g[i]+"<br>");
       //		out.println("tax_supply="+tax_supply[i]+"<br>");
        		
        		if (i == 0) {
        			cls.setDft_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setDft_amt_v(AddUtil.parseDigit(tax_value[i]));
       	 		} else if ( i == 1 ){
	       	 		cls.setEtc_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setEtc_amt_v(AddUtil.parseDigit(tax_value[i]));
	       	 	} else if ( i == 2 ){
	       	 		cls.setEtc2_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setEtc2_amt_v(AddUtil.parseDigit(tax_value[i]));
	       	 	} else if ( i == 3 ){
	       	 		cls.setEtc4_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setEtc4_amt_v(AddUtil.parseDigit(tax_value[i]));       	
	       	 	} else if ( i == 4 ){
	       	 		cls.setOver_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setOver_amt_v(AddUtil.parseDigit(tax_value[i]));       		
	       	 	}	
   		//	tax_cnt++;
  			
  			} else {
  			
  				if (i == 0) {
        				cls.setDft_amt_s(0);
	       	 		cls.setDft_amt_v(0);
       	 		} else if ( i == 1 ){
	       	 		cls.setEtc_amt_s(0);
	       	 		cls.setEtc_amt_v(0);
	       	 	} else if ( i == 2 ){
	       	 		cls.setEtc2_amt_s(0);
	       	 		cls.setEtc2_amt_v(0);
	       	 	} else if ( i == 3 ){
	       	 		cls.setEtc4_amt_s(0);
	       	 		cls.setEtc4_amt_v(0);       	
	       	 	} else if ( i == 4 ){
	       	 		cls.setOver_amt_s(0);
	       	 		cls.setOver_amt_v(0);       		
	       	 	}	  			
  			}
	}				
	
	cls.setCar_ja_no_amt(request.getParameter("car_ja_no_amt")==null?0:			AddUtil.parseDigit(request.getParameter("car_ja_no_amt")));   //���Աݵ� ��å���� ��꼭 ��û����
	cls.setTot_dist(request.getParameter("tot_dist")==null?0:					AddUtil.parseDigit(request.getParameter("tot_dist")));   //��������Ÿ�
	
	//�ʰ�����Ÿ�
	cls.setOver_amt(request.getParameter("over_amt")==null?0:			AddUtil.parseDigit(request.getParameter("over_amt")));  //�ʰ����� �����ݾ�
	cls.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //�ʰ����� Ȯ���ݾ�
	cls.setOver_v_amt(request.getParameter("over_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt"))); //�ʰ����� �����ݾ� �ΰ��� - 2022-04 �߰� 
	cls.setOver_v_amt_1(request.getParameter("over_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt_1"))); //�ʰ����� Ȯ���ݾ� �ΰ��� - 2022-04 �߰�
		
	cls.setInput_id(ck_acar_id); //�Է��� 		
	if(!ac_db.insertClsEtc(cls))	flag += 1;
	
		//�����Ƿڳ��� �߰� �׸� - 20180907 cls_etc field�� �ʹ� ���Ƽ� cls_etc_more�� �߰� 	
	ClsEtcMoreBean clsm = new ClsEtcMoreBean();	
	clsm.setRent_mng_id(rent_mng_id);
	clsm.setRent_l_cd(rent_l_cd);	
		//�߰��Աݾ��� ���� ��� - ���꼭 �ۼ�������
	clsm.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //�߰��Ա���
	clsm.setEx_ip_amt(request.getParameter("ex_ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_ip_amt")));	  //�߰��Աݾ� 	
	clsm.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //�Ա�����
	clsm.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //�Աݱ���
	
	clsm.setDes_zip(request.getParameter("des_zip")==null?"":			request.getParameter("des_zip"));
	clsm.setDes_addr(request.getParameter("des_addr")==null?"":			request.getParameter("des_addr"));
	clsm.setDes_nm(request.getParameter("des_nm")==null?"":			request.getParameter("des_nm"));
	clsm.setDes_tel(request.getParameter("des_tel")==null?"":			request.getParameter("des_tel"));
	
	clsm.setCms_after(request.getParameter("cms_after")==null?"":request.getParameter("cms_after"));            //�ڵ���ü ����ó�� 	

	if(cls_st.equals("8")){//���Կɼ��ΰ�� 	
		clsm.setSui_st(request.getParameter("sui_st")==null?"N":			request.getParameter("sui_st"));
		clsm.setSui_d1_amt(request.getParameter("sui_d1_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d1_amt")));
		clsm.setSui_d2_amt(request.getParameter("sui_d2_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d2_amt")));
		clsm.setSui_d3_amt(request.getParameter("sui_d3_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d3_amt")));
		clsm.setSui_d4_amt(request.getParameter("sui_d4_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d4_amt")));
		clsm.setSui_d5_amt(request.getParameter("sui_d5_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d5_amt")));
		clsm.setSui_d6_amt(request.getParameter("sui_d6_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d6_amt")));
		clsm.setSui_d7_amt(request.getParameter("sui_d7_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d7_amt")));
		clsm.setSui_d8_amt(request.getParameter("sui_d8_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d8_amt")));
		clsm.setSui_d_amt(request.getParameter("sui_d_amt")==null?0:		AddUtil.parseDigit(request.getParameter("sui_d_amt")));
					 
	}	
	
	if(!ac_db.insertClsEtcMore(clsm))	flag += 1;	
	
	//�����Ƿڳ��� ����
	ClsEtcSubBean clss = new ClsEtcSubBean();
	clss.setRent_mng_id(rent_mng_id);
	clss.setRent_l_cd(rent_l_cd);
	clss.setFine_amt_1(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //���·� Ȯ���ݾ�
	clss.setCar_ja_amt_1(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //��å�� Ȯ���ݾ�
	clss.setDly_amt_1(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //��ü�� Ȯ���ݾ�
	clss.setEtc_amt_1(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //����ȸ�����ֺ� Ȯ���ݾ�
	clss.setEtc2_amt_1(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //����ȸ���δ�� Ȯ���ݾ�
	clss.setDft_amt_1(request.getParameter("dft_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //�ߵ���������� Ȯ���ݾ�
	clss.setDfee_amt_1(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1")));   //�ߵ���������� Ȯ���ݾ�
	clss.setEtc3_amt_1(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //������������ Ȯ���ݾ�
	clss.setEtc4_amt_1(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //��Ÿ���ع��� Ȯ���ݾ�
	clss.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //�ʰ����� Ȯ���ݾ�
	clss.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //�ΰ��� Ȯ���ݾ�
	clss.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//�հ� ���ʱݾ�
	clss.setReg_id(reg_id);
	
	//�����Ƿڼ��곻�� ����	
	if(!ac_db.insertClsEtcSub(clss))	flag += 1;
		
	//�����Ƿڼ��ݰ�꼭���� ����
	ClsEtcTaxBean ct = new ClsEtcTaxBean();
	ct.setRent_mng_id(rent_mng_id);
	ct.setRent_l_cd(rent_l_cd);
	ct.setSeq_no(1);
	ct.setReg_id(reg_id);
	
	//�����Ƿڼ��곻�� ����	
	if(!ac_db.insertClsEtcTax(ct))	flag += 1;
	
		//�ߵ����Կɼǰ��� �߰� - 20161028	
	if ( old_opt_amt > 0 ) { 
		
			//�ߵ����Կɼǰ��� �߰� - 20161028
			
			ClsEtcAddBean clsa = new ClsEtcAddBean();
			clsa.setRent_mng_id(rent_mng_id);
			clsa.setRent_l_cd(rent_l_cd);
			clsa.setA_f(request.getParameter("a_f")==null?0:		AddUtil.parseFloat(request.getParameter("a_f"))); //������ 
			clsa.setOld_opt_amt(request.getParameter("old_opt_amt")==null?0:	AddUtil.parseDigit(request.getParameter("old_opt_amt"))); //��༭�� ���Կɼ� �ݾ�
			clsa.setAdd_saction_id(request.getParameter("add_saction_id")==null?"":	request.getParameter("add_saction_id")); //�ߵ����Դ���� 
			
			clsa.setMt(request.getParameter("mt")==null?"":	request.getParameter("mt")); //���Կɼ� 1:�ߵ����� 2:�����ߵ�����
			clsa.setRc_rate(request.getParameter("rc_rate")==null?0:		AddUtil.parseFloat(request.getParameter("rc_rate"))); //���簡ġ��
			clsa.setB_old_opt_amt(request.getParameter("fee_size_1_opt_amt")==null?0:	AddUtil.parseDigit(request.getParameter("fee_size_1_opt_amt"))); //��������  ���Կɼ� �ݾ�
			clsa.setCount1(request.getParameter("count1")==null?0:	AddUtil.parseDigit(request.getParameter("count1"))); // 
			clsa.setCount2(request.getParameter("count2")==null?0:	AddUtil.parseDigit(request.getParameter("count2"))); // 
			clsa.setM_r_fee_amt(request.getParameter("m_r_fee_amt")==null?0:	AddUtil.parseDigit(request.getParameter("m_r_fee_amt"))); //�ߵ����Կɼǽ� �뿩�� �ݿ���
			
			//�����Ƿ� �߰����� ����	
			if(!ac_db.insertClsEtcAdd(clsa))	flag += 1;
			
			String value0[]  = request.getParameterValues("s_fee_tm");
			String value1[]  = request.getParameterValues("s_r_fee_est_dt");
			String value2[]  = request.getParameterValues("s_fee_s_amt");
			String value3[]  = request.getParameterValues("s_tax_amt");
			String value4[]  = request.getParameterValues("s_is_amt");
			String value5[]  = request.getParameterValues("s_cal_amt");
			String value6[]  = request.getParameterValues("s_r_fee_s_amt");
			String value7[]  = request.getParameterValues("s_r_fee_v_amt");
			String value8[]  = request.getParameterValues("s_r_fee_amt");
			String value9[]  = request.getParameterValues("s_rc_rate");
			String value10[]  = request.getParameterValues("s_cal_days");			
			String value11[]  = request.getParameterValues("s_grt_amt");	
			String value12[]  = request.getParameterValues("s_g_fee_amt");				
			
			for(int i=0 ; i < scd_size ; i++){
				
				int s_fee_tm = value0[i]	==null?0 :AddUtil.parseDigit(value0[i]);   //ȸ�� 
				int s_fee_s_amt = value2[i]	==null?0 :AddUtil.parseDigit(value2[i]);  //���뿩�� 
				int s_tax_amt = value3[i]	==null?0 :AddUtil.parseDigit(value3[i]); //�ڵ�����  
				int s_is_amt = value4[i]	==null?0 :AddUtil.parseDigit(value4[i]); // ����� + ������ 
				int s_cal_amt = value5[i]	==null?0 :AddUtil.parseDigit(value5[i]);  // ���ܿ�� 
				int s_r_fee_s_amt = value6[i]	==null?0 :AddUtil.parseDigit(value6[i]); //���簡ġ ���ް� 
				int s_r_fee_v_amt = value7[i]	==null?0 :AddUtil.parseDigit(value7[i]); //���簡ġ �ΰ��� 
				int s_r_fee_amt = value8[i]	==null?0 :AddUtil.parseDigit(value8[i]);   //���簡ġ �ݾ� 
				float s_rc_rate = value9[i]	==null?0 :AddUtil.parseFloat(value9[i]);   //���簡ġ�� 
				int s_cal_days = value10[i]	==null?0 :AddUtil.parseDigit(value10[i]);	//����ϼ� 	 
				int s_grt_amt = value11[i]	==null?0 :AddUtil.parseDigit(value11[i]); //������ ����ȿ��  
				int s_g_fee_amt = value12[i]	==null?0 :AddUtil.parseDigit(value12[i]); //������ ���ڹݿ� �뿩��   	
				
				if(s_fee_tm > 0){
							
							//�ߵ����Կɼ� �ߵ����꼭����
							ClsEtcDetailBean clsd = new ClsEtcDetailBean();
			
							clsd.setRent_mng_id(rent_mng_id);
							clsd.setRent_l_cd(rent_l_cd);
							clsd.setS_fee_tm(s_fee_tm); //ȸ��
							clsd.setS_r_fee_est_dt(value1[i]); //�����ҳ�¥ 			
							clsd.setS_fee_s_amt(s_fee_s_amt); //���뿩��
							clsd.setS_tax_amt(s_tax_amt);   //�ڵ�����
							clsd.setS_is_amt(s_is_amt);  //����� + ������ 
							clsd.setS_cal_amt(s_cal_amt); //���ݾ�
							clsd.setS_r_fee_s_amt(s_r_fee_s_amt);   //���簡ġ�� �ݿ� ���ް� 
							clsd.setS_r_fee_v_amt(s_r_fee_v_amt);   //���簡ġ�� �ݿ� �ΰ��� 
							clsd.setS_r_fee_amt(s_r_fee_amt); //���簡ġ�� �հ� 
							clsd.setS_rc_rate(s_rc_rate); //���簡ġ��
							clsd.setS_cal_days(s_cal_days); //����ϼ�
							
							clsd.setS_grt_amt(s_grt_amt); //������ ����ȿ��  
							clsd.setS_g_fee_amt(s_g_fee_amt); //������ ���ڹݿ� �뿩��   	
																
							//�����Ƿڼ��곻�� ����	
							if(!ac_db.insertClsEtcDetail(clsd))	flag += 1;									
			   }
			}	
	}
		
	if(flag == 0){ 	
						
			//����ȸ��		
		CarRecoBean cr = new CarRecoBean();
		cr.setRent_mng_id(rent_mng_id);
		cr.setRent_l_cd	(rent_l_cd);
		cr.setReco_st(request.getParameter("reco_st")==null?"":			request.getParameter("reco_st"));  //����ȸ������
		cr.setReco_d1_st(request.getParameter("reco_d1_st")==null?"":	request.getParameter("reco_d1_st"));  //����ȸ������
		cr.setReco_d2_st(request.getParameter("reco_d2_st")==null?"":	request.getParameter("reco_d2_st"));  //������ȸ������
		cr.setReco_cau(request.getParameter("reco_cau")==null?"":		request.getParameter("reco_cau"));  //����
		cr.setReco_dt(request.getParameter("reco_dt")==null?"":			request.getParameter("reco_dt"));  //ȸ����
		cr.setReco_id(request.getParameter("reco_id")==null?"":			request.getParameter("reco_id")); //ȸ�������
		cr.setIp_dt(request.getParameter("ip_dt")==null?"":				request.getParameter("ip_dt"));  //�԰���	
		cr.setEtc2_d1_amt(request.getParameter("etc2_d1_amt")==null?0:	AddUtil.parseDigit(request.getParameter("etc2_d1_amt"))); //�δ���
		cr.setEtc_d1_amt(request.getParameter("etc_d1_amt")==null?0:	AddUtil.parseDigit(request.getParameter("etc_d1_amt")));  //���ֺ��
		cr.setReg_id(reg_id);		
		boolean cr_flag = ac_db.insertCarReco(cr);
				
		//ä�ǰ���, ����ä���� ó���ǰ�/���û���
		CarCreditBean cc = new CarCreditBean();
		cc.setRent_mng_id(rent_mng_id);
		cc.setRent_l_cd	(rent_l_cd);
		cc.setGi_amt(request.getParameter("gi_amt")==null?0:				AddUtil.parseDigit(request.getParameter("gi_amt"))); //��������ݾ�
		cc.setGi_c_amt(request.getParameter("gi_c_amt")==null?0:			AddUtil.parseDigit(request.getParameter("gi_c_amt"))); //û���ݾ�
		cc.setGi_j_amt(request.getParameter("gi_j_amt")==null?0:			AddUtil.parseDigit(request.getParameter("gi_j_amt"))); //����ä�Ǳݾ�
		cc.setC_ins(request.getParameter("c_ins")==null?"":					request.getParameter("c_ins"));  //���غ���� 
		cc.setC_ins_d_nm(request.getParameter("c_ins_d_nm")==null?"":		request.getParameter("c_ins_d_nm"));  //�����
		cc.setC_ins_tel(request.getParameter("c_ins_tel")==null?"":			request.getParameter("c_ins_tel"));  //��ȭ��ȣ
		cc.setCrd_reg_gu1(request.getParameter("crd_reg_gu1")==null?"":		request.getParameter("crd_reg_gu1"));  //��������û������
		cc.setCrd_reg_gu2(request.getParameter("crd_reg_gu2")==null?"":		request.getParameter("crd_reg_gu2"));  //���뺸�����󿩺�
		cc.setCrd_reg_gu3(request.getParameter("crd_reg_gu3")==null?"":		request.getParameter("crd_reg_gu3"));  //ä���߽ɿ���
		cc.setCrd_reg_gu4(request.getParameter("crd_reg_gu4")==null?"":		request.getParameter("crd_reg_gu4"));  //�ڵ������غ���
		cc.setCrd_reg_gu5(request.getParameter("crd_reg_gu5")==null?"":		request.getParameter("crd_reg_gu5"));  //����
		cc.setCrd_reg_gu6(request.getParameter("crd_reg_gu6")==null?"":		request.getParameter("crd_reg_gu6"));  //���ó��
		cc.setCrd_remark1(request.getParameter("crd_remark1")==null?"":		request.getParameter("crd_remark1"));  //��������û�� �ǰ�
		cc.setCrd_remark2(request.getParameter("crd_remark2")==null?"":		request.getParameter("crd_remark2"));  //���뺸���α��� �ǰ�
		cc.setCrd_remark3(request.getParameter("crd_remark3")==null?"":		request.getParameter("crd_remark3"));  //ä���߽ɿ��� �ǰ�
		cc.setCrd_remark4(request.getParameter("crd_remark4")==null?"":		request.getParameter("crd_remark4"));  //�ڵ������غ��� �ǰ�
		cc.setCrd_remark5(request.getParameter("crd_remark5")==null?"":		request.getParameter("crd_remark5"));  //���� �ǰ�
		cc.setCrd_remark6(request.getParameter("crd_remark6")==null?"":		request.getParameter("crd_remark6"));  //���ó�� �ǰ�
		cc.setCrd_id(request.getParameter("crd_id")==null?"":				request.getParameter("crd_id"));  // ������
		cc.setCrd_reason(request.getParameter("crd_reason")==null?"":		request.getParameter("crd_reason"));  //����
		cc.setReg_id(reg_id);
		boolean cr1_flag = ac_db.insertCarCredit(cc);
		
			  //r_over_amt�� �ִٸ� - ����ݾ��� �ִٸ�	       
	   	if ( AddUtil.parseDigit(request.getParameter("r_over_amt")) != 0 ) {
	        		
	        		//�ʰ�����δ�� 
			ClsEtcOverBean cco = new ClsEtcOverBean();        	
		
			cco.setRent_mng_id(rent_mng_id);
		 	cco.setRent_l_cd(rent_l_cd);
			cco.setRent_days(request.getParameter("rent_days")==null?0:	AddUtil.parseDigit(request.getParameter("rent_days"))); //�̿���
			cco.setCal_dist(request.getParameter("cal_dist")==null?0:	AddUtil.parseDigit(request.getParameter("cal_dist"))); //�����Ÿ�
			cco.setFirst_dist(request.getParameter("first_dist")==null?0:	AddUtil.parseDigit(request.getParameter("first_dist"))); //��������Ÿ�
			cco.setLast_dist(request.getParameter("last_dist")==null?0:	AddUtil.parseDigit(request.getParameter("last_dist"))); //��������Ÿ�
			cco.setReal_dist(request.getParameter("real_dist")==null?0:	AddUtil.parseDigit(request.getParameter("real_dist"))); //�ǿ���Ÿ�
			cco.setOver_dist(request.getParameter("over_dist")==null?0:	AddUtil.parseDigit(request.getParameter("over_dist"))); //�ʰ�����Ÿ�
			cco.setAdd_dist(request.getParameter("add_dist")==null?0:	AddUtil.parseDigit(request.getParameter("add_dist"))); //���񽺸��ϸ���
			cco.setJung_dist(request.getParameter("jung_dist")==null?0:	AddUtil.parseDigit(request.getParameter("jung_dist"))); //������ؿ���Ÿ�
			cco.setR_over_amt(request.getParameter("r_over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("r_over_amt"))); //����ݾ�
			cco.setM_over_amt(request.getParameter("m_over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("m_over_amt"))); //����
			cco.setJ_over_amt(request.getParameter("j_over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("j_over_amt"))); //����ݾ�		
			cco.setM_saction_id(request.getParameter("m_saction_id")==null?"":	request.getParameter("m_saction_id")); //������
			cco.setM_reason(request.getParameter("m_reason")==null?"":request.getParameter("m_reason")); //����

			boolean cr3_flag = ac_db.insertClsEtcOver(cco);	
	   	}
			
	}
		
	//�ߵ����Կɼ� ���꼭 ���� �޽��� ����	
	if(add_saction_id.equals("000197") &&  old_opt_amt  > 0  ){
	
		// ------------------------------------------------------------------------------------------
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
		String sub 		= "�ߵ����Կɼ� ����ݾ� Ȯ��ó�� ��� ";
		String cont 	= "[����ȣ:"+rent_l_cd+"]  �ߵ����Կɼ� ����ݾ� Ȯ����  ���� ��û�մϴ�.";	
		
		String url = 	"/fms2/cls_cont/lc_cls_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|add=Y";
		
		String target_id = nm_db.getWorkAuthUser("���Կɼǰ�����");   //�ߵ����Կɼ� 
	//	String target_id = "000277";   //�ߵ����Կɼ� 
					
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
//		xml_data += "    <TARGET>2010014</TARGET>"; //��а� �������븮�� ���� 
				
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
			
		System.out.println("��޽���(�ߵ����Կɼ� ����ݾ� Ȯ��)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
	}
		
	//ȥ��/����  ���� ���� �޼��� S617HAHR00003 S617HACR00021 S517HAHR00004 S517HAHR00005 S119VX6R00002 S218VX6R00002  - 20210115 
	if ( rent_l_cd.equals("S617HAHR00003") || rent_l_cd.equals("S617HACR00021") || rent_l_cd.equals("S517HAHR00004") || rent_l_cd.equals("S517HAHR00005") || rent_l_cd.equals("S119VX6R00002") || rent_l_cd.equals("S218VX6R00002") ) {
		
			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------	
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String sub 		= "ȥ��/���� ���� ���� ";
			String cont 	= " ȥ��/���� ���� ���� . ����ȣ : "+rent_l_cd +" , ���� ������ ���� �ٶ��ϴ�.!!!";
		
								
			//����� ���� ��ȸ
			UsersBean target_bean 	= umd.getUsersBean("000063");
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
	  					"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
	 					"    <URL></URL>";
			xml_data += "    <TARGET>2006007</TARGET>";	
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
			System.out.println("��޽���[ȥ��/���� ���� ] "+rent_l_cd+"-----------------------"+target_bean.getUser_nm());		
		
	} 
	
	//�����.�� �ؾ� ����
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	//����
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='andor'	 	value='<%=andor%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//�������̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');				
	fm.s_kd.value = '2';
//	fm.t_wd.value = fm.rent_l_cd.value;
//    fm.action='/fms2/cls_cont/lc_cls_off_d_frame.jsp';
    fm.action='/fms2/cls_cont/lc_cls_u.jsp';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>