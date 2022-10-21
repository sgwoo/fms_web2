<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,  acar.user_mng.*, acar.util.*,  acar.credit.*, acar.receive.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="r_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");

	String job = request.getParameter("job")==null?"3":request.getParameter("job");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if ( from_page.equals("") ) from_page = "/fms2/cls_cont/lc_cls_u1.jsp";
	
	int flag = 0;
	boolean flag2 = true;
	
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
	String cls_st = cls.getCls_st_r();
				
	/* if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_u1.jsp";
//		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {	
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_u1.jsp";
//		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}
	*/
	if (cls_st.equals("14") ) from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
			
	cls.setCls_st	(cls_st);
	cls.setCls_dt	(request.getParameter("cls_dt"));
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//���̿�Ⱓ ��
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//���̿�Ⱓ ��
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//��������
	cls.setUpd_id	(user_id);	
	
	cls.setCancel_yn(request.getParameter("cancel_yn")==null?"":request.getParameter("cancel_yn"));
	cls.setGrt_amt(request.getParameter("grt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("grt_amt")));
	cls.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	cls.setIfee_mon(request.getParameter("ifee_mon")==null?"":		request.getParameter("ifee_mon"));
	cls.setIfee_day(request.getParameter("ifee_day")==null?"":		request.getParameter("ifee_day"));
	cls.setIfee_ex_amt(request.getParameter("ifee_ex_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_ex_amt")));
	cls.setRifee_s_amt(request.getParameter("rifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_s_amt")));
	cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
	cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
	cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
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
	cls.setDft_int_1(request.getParameter("dft_int_1")==null?"":	request.getParameter("dft_int_1")); //�ߵ����� ������
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
	cls.setRemark(request.getParameter("remark")==null?"":				request.getParameter("remark"));           //Ȯ���ݾ� ����
	
	//�߰��Աݾ��� ���� ��� - ���꼭 �ۼ�������
//	cls.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //�߰��Ա���
//	cls.setEx_ip_amt(request.getParameter("ex_ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_ip_amt")));	  //�߰��Աݾ� 	
//	cls.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //�Ա�����
//	cls.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //�Աݱ���
		
	if(cls_st.equals("8")){//���Կɼ��ΰ�� 
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));
	/*	cls.setSui_st(request.getParameter("sui_st")==null?"N":			request.getParameter("sui_st"));
		cls.setSui_d1_amt(request.getParameter("sui_d1_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d1_amt")));
		cls.setSui_d2_amt(request.getParameter("sui_d2_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d2_amt")));
		cls.setSui_d3_amt(request.getParameter("sui_d3_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d3_amt")));
		cls.setSui_d4_amt(request.getParameter("sui_d4_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d4_amt")));
		cls.setSui_d5_amt(request.getParameter("sui_d5_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d5_amt")));
		cls.setSui_d6_amt(request.getParameter("sui_d6_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d6_amt")));
		cls.setSui_d7_amt(request.getParameter("sui_d7_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d7_amt")));
		cls.setSui_d8_amt(request.getParameter("sui_d8_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d8_amt")));
		cls.setSui_d_amt(request.getParameter("sui_d_amt")==null?0:		AddUtil.parseDigit(request.getParameter("sui_d_amt"))); */
		
		//���Կɼ� �Ա� 1 - ���꼭 �ۼ�������
		cls.setOpt_ip_dt1(request.getParameter("opt_ip_dt1")==null?"":			request.getParameter("opt_ip_dt1"));  		 //�߰��Ա���
		cls.setOpt_ip_amt1(request.getParameter("opt_ip_amt1")==null?0:			AddUtil.parseDigit(request.getParameter("opt_ip_amt1")));	  //�߰��Աݾ� 	
		cls.setOpt_ip_bank1(request.getParameter("opt_bank_code1_2")==null?"":		request.getParameter("opt_bank_code1_2"));           //�Ա�����
		cls.setOpt_ip_bank_no1(request.getParameter("opt_deposit_no1_2")==null?"":request.getParameter("opt_deposit_no1_2"));            //�Աݱ���
		
		//���Կɼ� �Ա� 2 - ���꼭 �ۼ�������
		cls.setOpt_ip_dt2(request.getParameter("opt_ip_dt2")==null?"":			request.getParameter("opt_ip_dt2"));  		 //�߰��Ա���
		cls.setOpt_ip_amt2(request.getParameter("opt_ip_amt2")==null?0:			AddUtil.parseDigit(request.getParameter("opt_ip_amt2")));	  //�߰��Աݾ� 	
		cls.setOpt_ip_bank2(request.getParameter("opt_bank_code2_2")==null?"":		request.getParameter("opt_bank_code2_2"));           //�Ա�����
		cls.setOpt_ip_bank_no2(request.getParameter("opt_deposit_no2_2")==null?"":request.getParameter("opt_deposit_no2_2"));            //�Աݱ���		
		cls.setExt_st(request.getParameter("ext_st")==null?"":request.getParameter("ext_st"));
	
	}
	
	cls.setCar_ja_no_amt(request.getParameter("car_ja_no_amt")==null?0:			AddUtil.parseDigit(request.getParameter("car_ja_no_amt")));   //���Աݵ� ��å���� ��꼭 ��û����
	
	cls.setOver_amt(request.getParameter("over_amt")==null?0:			AddUtil.parseDigit(request.getParameter("over_amt")));  //�ʰ����� �����ݾ�
	cls.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //�ʰ����� Ȯ���ݾ�	
	
	cls.setMatch(request.getParameter("match")==null?"":request.getParameter("match"));      //�����Ī
					
//	if(!ac_db.updateClsEtc(cls))	flag += 1;
		
   int  ex_ip_amt 		= request.getParameter("ex_ip_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ex_ip_amt"));	//�߰��Աݾ� 	
        
    	//�߰��Աݾ��� �ִ� ��� 
   	if (ex_ip_amt > 0 ) {
		if(!ac_db.updateClsEtcIp(cls))	flag += 1;			
	}
    				
	//���Կɼ��� ��� ���Կɼ� �Ա�Ȯ�� 
	if (cls_st.equals("8")) {
		if(!ac_db.updateClsEtcOpt(cls))	flag += 1;			
	}
	

	//����������  - ���걸�� : 1-> �ջ����� , 2->�������� , 3->ī������ 
	String jung_st = request.getParameter("jung_st")==null?"":request.getParameter("jung_st");		
	
	//�ݾ�Ȯ������					
	if(!ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "2", user_id))	flag += 1;	
	
	//�����Ƿڳ��� �߰� �׸� - 20180907 cls_etc field�� �ʹ� ���Ƽ� cls_etc_more�� �߰� 			
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);		

	clsm.setRent_mng_id(rent_mng_id);
	clsm.setRent_l_cd(rent_l_cd);
		
	clsm.setRe_file_name(request.getParameter("re_file_name")==null?"":			request.getParameter("re_file_name"));  //
	clsm.setEtc4_file_name(request.getParameter("etc4_file_name")==null?"":	request.getParameter("etc4_file_name"));  //
	clsm.setRemark_file_name(request.getParameter("remark_file_name")==null?"":	request.getParameter("remark_file_name"));  //
	//�߰��Աݾ��� ���� ��� - ���꼭 �ۼ�������
	clsm.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //�߰��Ա���
	clsm.setEx_ip_amt(ex_ip_amt);	  //�߰��Աݾ� 	
	clsm.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //�Ա�����
	clsm.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //�Աݱ���
	clsm.setDes_zip(request.getParameter("des_zip")==null?"":			request.getParameter("des_zip"));    //���Կɼ� ����
	clsm.setDes_addr(request.getParameter("des_addr")==null?"":			request.getParameter("des_addr"));
	clsm.setDes_nm(request.getParameter("des_nm")==null?"":			request.getParameter("des_nm"));
	clsm.setDes_tel(request.getParameter("des_tel")==null?"":			request.getParameter("des_tel"));
	clsm.setCms_after(request.getParameter("cms_after")==null?"":	request.getParameter("cms_after"));  //					
	clsm.setM_dae_amt(request.getParameter("m_dae_amt")==null?0:			AddUtil.parseDigit(request.getParameter("m_dae_amt")));	  //��ü�Աݾ� 	
	clsm.setExt_amt(request.getParameter("ext_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ext_amt")));	  //ȯ��/������ 	
	clsm.setStatus("1");	  //status 	
	clsm.setCms_amt(request.getParameter("cms_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cms_amt")));	  //�κ����� 	
	
	clsm.setE_serv_rem(request.getParameter("e_serv_rem")==null?"":	request.getParameter("e_serv_rem"));  //					
	clsm.setE_serv_amt(request.getParameter("e_serv_amt")==null?0:			AddUtil.parseDigit(request.getParameter("e_serv_amt")));	  //����������
	
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
	
	///�����Ƿڳ��� �߰� �׸� ����	
	if(!ac_db.updateClsEtcMore(clsm))	flag += 1;	
			
	//�����Ƿڻ󼼳��� - ���ݾ� ������ (��꼭�ʹ� ��� ����)		
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);		

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
	clss.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //�ΰ��� Ȯ���ݾ�
	clss.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//�հ� ���ʱݾ�
	
	clss.setFine_amt_2(request.getParameter("fine_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_2"))); //���·� ���ݾ�
	clss.setCar_ja_amt_2(request.getParameter("car_ja_amt_2")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_2"))); //��å�� ���ݾ�
	clss.setDly_amt_2(request.getParameter("dly_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_2")));   //��ü�� ���ݾ�
	clss.setEtc_amt_2(request.getParameter("etc_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_2")));  //����ȸ�����ֺ� ���ݾ�
	clss.setEtc2_amt_2(request.getParameter("etc2_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_2"))); //����ȸ���δ�� ���ݾ�
	clss.setDft_amt_2(request.getParameter("dft_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_2")));   //�ߵ���������� ���ݾ�
	clss.setDfee_amt_2(request.getParameter("dfee_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_2")));   //�̳��뿩�� ���ݾ�
	clss.setEtc3_amt_2(request.getParameter("etc3_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_2"))); //������������ ���ݾ�
	clss.setEtc4_amt_2(request.getParameter("etc4_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_2"))); //��Ÿ���ع��� ���ݾ�
	clss.setNo_v_amt_2(request.getParameter("no_v_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_2")));   //�ΰ��� ���ݾ�
	clss.setFdft_amt1_2(request.getParameter("fdft_amt1_2")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_2")));//�հ� ���ݾ�
	
	clss.setRifee_amt_2_v(request.getParameter("rifee_amt_2_v")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_amt_2_v")));   //�̳��뿩�� ���ݾ� vat
	clss.setRfee_amt_2_v(request.getParameter("rfee_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("rfee_amt_2_v")));   //�̳��뿩�� ���ݾ� vat
	clss.setDfee_amt_2_v(request.getParameter("dfee_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_2_v")));   //�̳��뿩�� ���ݾ� vat
	clss.setDft_amt_2_v(request.getParameter("dft_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_2_v")));   //����� ���ݾ� vat
	clss.setEtc_amt_2_v(request.getParameter("etc_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_2_v")));   //���ֺ�� ���ݾ� vat
	clss.setEtc2_amt_2_v(request.getParameter("etc2_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_2_v")));   //�δ��� ���ݾ� vat
	clss.setEtc4_amt_2_v(request.getParameter("etc4_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_2_v")));   //���ع��� ���ݾ� vat
	
	clss.setUpd_id(user_id);		
	
	clss.setOver_amt_1(request.getParameter("over_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("over_amt_1")));//�ʰ����� Ȯ���ݾ�
	clss.setOver_amt_2(request.getParameter("over_amt_2")==null?0:	AddUtil.parseDigit(request.getParameter("over_amt_2")));//�ʰ�������ݾ�
	clss.setOver_amt_2_v(request.getParameter("over_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_2_v")));   //�ʰ����� ���ݾ� vat
	
	//�����Ƿڼ��곻�� ����	
	if(!ac_db.updateClsEtcSub(clss))	flag += 1;
							
		//����ȸ��		
	CarRecoBean cr = ac_db.getCarReco(rent_mng_id, rent_l_cd);		
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
	cr.setUpd_id(user_id);		
	cr.setPark(request.getParameter("park")==null?"":				request.getParameter("park"));  //������	
	cr.setPark_cont(request.getParameter("park_cont")==null?"":		request.getParameter("park_cont"));  //���� Ư�̻���
//	boolean cr_flag = ac_db.updateCarReco(cr);
	
	
	//ä�ǰ���, ����ä���� ó���ǰ�/���û���
	CarCreditBean cc = ac_db.getCarCredit(rent_mng_id, rent_l_cd);		
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
	cc.setUpd_id(user_id);	
	cc.setCrd_req_gu1(request.getParameter("crd_req_gu1")==null?"":		request.getParameter("crd_req_gu1"));  //��������û������
	cc.setCrd_req_gu2(request.getParameter("crd_req_gu2")==null?"":		request.getParameter("crd_req_gu2"));  //���뺸�����󿩺�
	cc.setCrd_req_gu3(request.getParameter("crd_req_gu3")==null?"":		request.getParameter("crd_req_gu3"));  //ä���߽ɿ���
	cc.setCrd_req_gu4(request.getParameter("crd_req_gu4")==null?"":		request.getParameter("crd_req_gu4"));  //�ڵ������غ���
	cc.setCrd_req_gu5(request.getParameter("crd_req_gu5")==null?"":		request.getParameter("crd_req_gu5"));  //����
	cc.setCrd_req_gu6(request.getParameter("crd_req_gu6")==null?"":		request.getParameter("crd_req_gu6"));  //���ó��
	cc.setCrd_pri1(request.getParameter("crd_pri1")==null?"":		request.getParameter("crd_pri1"));  //��������û�� �ǰ� �켱����
	cc.setCrd_pri2(request.getParameter("crd_pri2")==null?"":		request.getParameter("crd_pri2"));  //���뺸���α��� �ǰ�
	cc.setCrd_pri3(request.getParameter("crd_pri3")==null?"":		request.getParameter("crd_pri3"));  //ä���߽ɿ��� �ǰ�
	cc.setCrd_pri4(request.getParameter("crd_pri4")==null?"":		request.getParameter("crd_pri4"));  //�ڵ������غ��� �ǰ�
	cc.setCrd_pri5(request.getParameter("crd_pri5")==null?"":		request.getParameter("crd_pri5"));  //���� �ǰ�
	cc.setCrd_pri6(request.getParameter("crd_pri6")==null?"":		request.getParameter("crd_pri6"));  //���ó�� �ǰ�
	boolean cr1_flag = ac_db.updateCarCredit(cc);
	
	if (  jung_st.equals("1") ||  jung_st.equals("2")    ) { 	
		//�������������
		ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);		
		cct.setRent_mng_id(rent_mng_id);
		cct.setRent_l_cd	(rent_l_cd);
		cct.setJung_st(request.getParameter("jung_st")==null?"":			request.getParameter("jung_st"));  //���걸��
		cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //�����ݾ�
		cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //�̳��Աݾ�
		cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //����ݾ�(�ջ������)
		cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //ȯ��
		cct.setH5_amt(request.getParameter("h5_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h5_amt"))); //ȯ������ݾ� (ī���ΰ�� ��ұݾ�)
		cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //û��
		cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //û������ݾ� (ī���ΰ�� ������ ����αݾ�)
						
		cct.setH_st(request.getParameter("h_st")==null?"":			request.getParameter("h_st"));  //����
		cct.setH_ip_dt(request.getParameter("h_ip_dt")==null?"":		request.getParameter("h_ip_dt"));  //�Ա�����
		cct.setPay_st(request.getParameter("pay_st")==null?"":			request.getParameter("pay_st"));  //ȯ���ΰ�� ��������: 2->���� . �����ʿ�
		
		cct.setSuc_gubun(request.getParameter("suc_gubun")==null?"":		request.getParameter("suc_gubun"));  //�°�
		cct.setSuc_l_cd(request.getParameter("suc_l_cd")==null?"":		request.getParameter("suc_l_cd"));  //�°���� ����ȣ 
			
		cct.setDelay_st(request.getParameter("delay_st")==null?"":		request.getParameter("delay_st"));  //�������� 
		cct.setDelay_type(request.getParameter("delay_type")==null?"":		request.getParameter("delay_type"));  //�������� 
		cct.setDelay_desc(request.getParameter("delay_desc")==null?"":		request.getParameter("delay_desc"));  //�������� 
		cct.setRefund_st(request.getParameter("refund_st")==null?"":		request.getParameter("refund_st"));  //ȯ�ұ��� 						
	
		if(!ac_db.updateClsContEtc(cct))	flag += 1;
	}
	
	if (cls_st.equals("14") ) {
	   //ī������簡 �������� ����Ǵ� ���
	   	if (  jung_st.equals("1") ||  jung_st.equals("2")  ) { 	
	   	  		if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_cont_etc"))	flag += 1; //����������	   	    
	   	}	   
				//jung_st �� 3�� ��� : ī������, �����αݾ� ���, ī�� ������Ƿڷ� ó�� 
		if (   jung_st.equals("3")   ) { 
		
		   int cce_cnt =  ac_db.getCntClsContEtc	(rent_mng_id, rent_l_cd);		
		   
		   if ( cce_cnt  < 1) {
		 	  	ClsContEtcBean cct = new ClsContEtcBean();
				cct.setRent_mng_id(rent_mng_id);
				cct.setRent_l_cd	(rent_l_cd);
				cct.setJung_st(request.getParameter("jung_st")==null?"":			request.getParameter("jung_st"));  //���걸��
				cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //�����ݾ�
				cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //�̳��Աݾ�
				cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //����ݾ�(�ջ������)
				cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //ȯ��
				cct.setH5_amt(request.getParameter("h5_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h5_amt"))); //ȯ������ݾ�
				cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //û��
				cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //û������ݾ�						
				
				cct.setR_date(request.getParameter("r_date")==null?"":		request.getParameter("r_date"));  //ī�� ��Ұ��� - ����� ī�� ������							
			
				if(!ac_db.insertClsContEtc(cct))	flag += 1;
			} else {	
		   	   
				//�������������
				ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);		
				cct.setRent_mng_id(rent_mng_id);
				cct.setRent_l_cd	(rent_l_cd);
				cct.setJung_st(request.getParameter("jung_st")==null?"":			request.getParameter("jung_st"));  //���걸��
				cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //�����ݾ�
				cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //�̳��Աݾ�
				cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //����ݾ�(�ջ������)
				cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //ȯ��
				cct.setH5_amt(request.getParameter("h5_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h5_amt"))); //ȯ������ݾ� (ī���ΰ�� ��ұݾ�)
				cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //û��
				cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //û������ݾ� (ī���ΰ�� ������ ����αݾ�)							
				
				cct.setR_date(request.getParameter("r_date")==null?"":		request.getParameter("r_date"));  //ī�� ��Ұ��� - ����� ī�� ������					
				
				if(!ac_db.updateClsContEtc(cct))	flag += 1;
			}
		}	
	}
			
		//������� ���		
	ClsCarExamBean cce = r_db.getClsCarExam(rent_mng_id, rent_l_cd, 1);		
	cce.setRent_mng_id(rent_mng_id);
	cce.setRent_l_cd	(rent_l_cd);
	cce.setExam_dt(request.getParameter("exam_dt")==null?"":		request.getParameter("exam_dt")); 
	cce.setExam_id(request.getParameter("exam_id")==null?"":		request.getParameter("exam_id")); 
	cce.setS_gu1(request.getParameter("s_gu1")==null?"":			request.getParameter("s_gu1")); 
	cce.setS_gu2(request.getParameter("s_gu2")==null?"":			request.getParameter("s_gu2")); 
	cce.setS_gu3(request.getParameter("s_gu3")==null?"":			request.getParameter("s_gu3")); 
	cce.setS_gu4(request.getParameter("s_gu4")==null?"":			request.getParameter("s_gu4")); 
	cce.setS_remark(request.getParameter("s_remark")==null?"":	request.getParameter("s_remark"));  //
	cce.setS_result(request.getParameter("s_result")==null?"":	request.getParameter("s_result"));  //
		
	boolean cr2_flag =r_db.updateClsCarExam(cce);
		
	
	//ä�� - ������
	Vector gurs = r_db.getClsCarGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
		
	//������ ����		
	String gu_seq[] 	= request.getParameterValues("gu_seq");
	String gu_nm[] 	= request.getParameterValues("gu_nm");
	String gu_addr[] 	= request.getParameterValues("gu_addr");
	String gu_zip[] 	= request.getParameterValues("gu_zip");
	String gu_tel[] 	= request.getParameterValues("gu_tel");
	String gu_rel[] 	= request.getParameterValues("gu_rel");
	String plan_st[] 	= request.getParameterValues("plan_st");
	String eff_st[] 	= request.getParameterValues("eff_st");
	String plan_rem[] 	= request.getParameterValues("plan_rem");
	String eff_rem[] 	= request.getParameterValues("eff_rem");
			
	int gu_size = 0;
	
	if ( gur_size < 1) {			
		gu_size =gur_size;
	} else {
		gu_size = gu_nm.length;
	}
	
//	System.out.println("���� ������ ����=" + gu_size + ":" + rent_l_cd);
	
	String plan_st_n = "";
	String eff_st_n = "";
			
	for(int i = 0 ; i < gu_size ; i++){
		
		if(!gu_nm[i].equals("") ){
			ClsCarGurBean ccc = r_db.getClsCarGurList(rent_mng_id, rent_l_cd, gu_nm[i]);
													
		//	ccc.setRent_mng_id(rent_mng_id);
		//	ccc.setRent_l_cd	(rent_l_cd);
			ccc.setGu_seq(AddUtil.parseInt(gu_seq[i]) ); //����
			ccc.setGu_nm(gu_nm[i]);
			ccc.setGu_addr(gu_addr[i] ==null?"":gu_addr[i]);
			ccc.setGu_zip(gu_zip[i] ==null?"":gu_zip[i]);
			ccc.setGu_tel(gu_tel[i] ==null?"":gu_tel[i]);
			ccc.setGu_rel(gu_rel[i] ==null?"":gu_rel[i]);	
							
			plan_st_n= request.getParameter("plan_st" + i)==null?"":request.getParameter("plan_st" + i);  
			eff_st_n= request.getParameter("eff_st" + i)==null?"":request.getParameter("eff_st" + i);  
			ccc.setPlan_st	(plan_st_n);
			ccc.setEff_st	(eff_st_n);						
			ccc.setPlan_rem(plan_rem[i] ==null?"":plan_rem[i]);
			ccc.setEff_rem(eff_rem[i] ==null?"":eff_rem[i]);					
					
			//=====[CAR_MGR] update=====
			flag2 = r_db.updateClsCarGur(ccc);
					
		}
	}			
			
	//�����Ƿ� ���ݰ�꼭���� 
	//���ݰ�꼭 �����Ƿڰ� ��� : �Ƿ��ߴ��� �������ݰ�꼭�� ����ȵ� �� ���� :��⿬ü�� ��� (���ݽ� ���ݰ�꼭 ����ó��)
	ClsEtcTaxBean ct = ac_db.getClsEtcTax(rent_mng_id, rent_l_cd, 1);
	ct.setRent_mng_id(rent_mng_id);
	ct.setRent_l_cd	(rent_l_cd);		
	ct.setSeq_no	(1);
	ct.setTax_r_chk0(request.getParameter("tax_r_chk0")==null?"N":request.getParameter("tax_r_chk0"));  //�ܿ����ô뿩��
	ct.setTax_r_chk1(request.getParameter("tax_r_chk1")==null?"N":request.getParameter("tax_r_chk1"));  //�ܿ�������
	ct.setTax_r_chk2(request.getParameter("tax_r_chk2")==null?"N":request.getParameter("tax_r_chk2"));  //��Ҵ뿩��
	ct.setTax_r_chk3(request.getParameter("tax_r_chk3")==null?"N":request.getParameter("tax_r_chk3"));  //�����뿩��
	ct.setTax_r_chk4(request.getParameter("tax_r_chk4")==null?"N":request.getParameter("tax_r_chk4"));  //���������
	ct.setTax_r_chk5(request.getParameter("tax_r_chk5")==null?"N":request.getParameter("tax_r_chk5"));  //ȸ�����ֺ��
	ct.setTax_r_chk6(request.getParameter("tax_r_chk6")==null?"N":request.getParameter("tax_r_chk6"));  //ȸ���δ���
	ct.setTax_r_chk7(request.getParameter("tax_r_chk7")==null?"N":request.getParameter("tax_r_chk7"));  //���ع���
	ct.setTax_r_chk8(request.getParameter("tax_r_chk8")==null?"N":request.getParameter("tax_r_chk8"));  //�ʰ�����δ��
		
	String tax_r_supply[] = request.getParameterValues("tax_r_supply"); // ���࿹����
    String tax_r_value[] = request.getParameterValues("tax_r_value");
 
 	String tax_rr_supply[] = request.getParameterValues("tax_rr_supply"); // �����
    String tax_rr_value[] = request.getParameterValues("tax_rr_value");
    
    String tax_rr_hap[] = request.getParameterValues("tax_rr_hap");  //���������
    
	String tax_r_g[] = request.getParameterValues("tax_r_g");
	String tax_r_bigo[] = request.getParameterValues("tax_r_bigo");	
	
	String tax_reg_gu = request.getParameter("tax_reg_gu")==null?"":	request.getParameter("tax_reg_gu");
	 	
	int tax_size = tax_r_g.length;
	for(int i = 0; i<tax_size; i++){
    	    
    	    String tax_chk = request.getParameter("tax_r_chk"+i)==null?"N":	request.getParameter("tax_r_chk"+i);
    	    if(tax_chk.equals("Y")){
    	        		
	    		if (i == 0) {
	    			ct.setRifee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�ܿ����ô뿩�� ����
	       	 		ct.setRifee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_rifee_s_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //�ܿ����ô뿩�� ����
	       	 		ct.setR_rifee_s_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
	       	 		ct.setRifee_etc(tax_r_g[i]);  //���� ������ ǰ��
	   	 		} else if ( i == 1 ){
	       	 		ct.setRfee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�ܿ������� ����
	       	 		ct.setRfee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_rfee_s_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //�ܿ������� ����
	       	 		ct.setR_rfee_s_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
	       	 		ct.setRfee_etc(tax_r_g[i]);  //���� ������ ǰ��
	       	 	} else if ( i == 2 ){
	       	 		ct.setDfee_c_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //��Ҵ뿩�� ����
	       	 		ct.setDfee_c_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_dfee_c_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //��Ҵ뿩�� ����
	       	 		ct.setR_dfee_c_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
	       	 		ct.setDfee_c_etc(tax_r_g[i]);  //���� ������ ǰ��	
	       	 	} else if ( i == 3 ){
	       	 		ct.setDfee_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�̳��뿩�� ����
	       	 		ct.setDfee_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_dfee_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //�̳��뿩�� ����
	       	 		ct.setR_dfee_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
	       	 		ct.setDfee_etc(tax_r_g[i]);  //���� ������ ǰ��
	       	 	} else if ( i == 4 ){
	       	 		ct.setDft_amt_s(AddUtil.parseDigit(tax_r_supply[i]));   //�ߵ���������� ����
	       	 		ct.setDft_amt_v(AddUtil.parseDigit(tax_r_value[i]));       
	       	 		ct.setR_dft_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));   //�ߵ���������� ����
	       	 		ct.setR_dft_amt_v(AddUtil.parseDigit(tax_rr_value[i])); 
	       	 		ct.setDft_etc(tax_r_g[i]);  //���� ������ ǰ��    		
	       	 	} else if ( i == 5 ){
	       	 		ct.setEtc_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //���ֺ�� ����
	       	 		ct.setEtc_amt_v(AddUtil.parseDigit(tax_r_value[i])); 
	       	 		ct.setR_etc_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //���ֺ�� ����
	       	 		ct.setR_etc_amt_v(AddUtil.parseDigit(tax_rr_value[i])); 
	       	 		ct.setEtc_etc(tax_r_g[i]);  //���� ������ ǰ��
	       	 	} else if ( i == 6 ){
	       	 		ct.setEtc2_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�δ��� ����
	       	 		ct.setEtc2_amt_v(AddUtil.parseDigit(tax_r_value[i]));     
	       	 		ct.setR_etc2_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //�δ��� ����
	       	 		ct.setR_etc2_amt_v(AddUtil.parseDigit(tax_rr_value[i]));     
	       	 		ct.setEtc2_etc(tax_r_g[i]);  //���� ������ ǰ��      	
	       	 	} else if ( i == 7 ){
	       	 		ct.setEtc4_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //���ع��� ����
	       	 		ct.setEtc4_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
	       	 		ct.setR_etc4_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //���ع��� ����
	       	 		ct.setR_etc4_amt_v(AddUtil.parseDigit(tax_rr_value[i]));  
	       	 		ct.setEtc4_etc(tax_r_g[i]);  //���� ������ ǰ��
	       	 	} else if ( i == 8 ){
	       	 		ct.setOver_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�ʰ�����δ�� ����
	       	 		ct.setOver_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
	       	 		ct.setR_over_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //�ʰ�����δ�� ����
	       	 		ct.setR_over_amt_v(AddUtil.parseDigit(tax_rr_value[i]));  
	       	 		ct.setOver_etc(tax_r_g[i]);  //���� ������ ǰ��	
	       	 	}	
	       	 	
	       	 } else {
	       	 
	       		 if (i == 0) {
	    			ct.setRifee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�ܿ����ô뿩�� ����
	       	 		ct.setRifee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_rifee_s_amt_s(0);  //�ܿ����ô뿩�� ����
	       	 		ct.setR_rifee_s_amt_v(0);
	       	 		ct.setRifee_etc(tax_r_g[i]);  //���� ������ ǰ��
	   	 		} else if ( i == 1 ){
	       	 		ct.setRfee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�ܿ������� ����
	       	 		ct.setRfee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_rfee_s_amt_s(0);  //�ܿ������� ����
	       	 		ct.setR_rfee_s_amt_v(0);
	       	 		ct.setRfee_etc(tax_r_g[i]);  //���� ������ ǰ��
	       	 	} else if ( i == 2 ){
	       	 		ct.setDfee_c_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //��Ҵ뿩�� ����
	       	 		ct.setDfee_c_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_dfee_c_amt_s(0);  //��Ҵ뿩�� ����
	       	 		ct.setR_dfee_c_amt_v(0);
	       	 		ct.setDfee_c_etc(tax_r_g[i]);  //���� ������ ǰ��	
	       	 	} else if ( i == 3 ){
	       	 		ct.setDfee_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�̳��뿩�� ����
	       	 		ct.setDfee_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_dfee_amt_s(0);  //�̳��뿩�� ����
	       	 		ct.setR_dfee_amt_v(0);
	       	 		ct.setDfee_etc(tax_r_g[i]);  //���� ������ ǰ��
	       	 	} else if ( i == 4 ){
	       	 		ct.setDft_amt_s(AddUtil.parseDigit(tax_r_supply[i]));   //�ߵ���������� ����
	       	 		ct.setDft_amt_v(AddUtil.parseDigit(tax_r_value[i]));       
	       	 		ct.setR_dft_amt_s(0);   //�ߵ���������� ����
	       	 		ct.setR_dft_amt_v(0);   
	       	 		ct.setDft_etc(tax_r_g[i]);  //���� ������ ǰ��    		
	       	 	} else if ( i == 5 ){
	       	 		ct.setEtc_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //���ֺ�� ����
	       	 		ct.setEtc_amt_v(AddUtil.parseDigit(tax_r_value[i])); 
	       	 		ct.setR_etc_amt_s(0);  //���ֺ�� ����
	       	 		ct.setR_etc_amt_v(0); 
	       	 		ct.setEtc_etc(tax_r_g[i]);  //���� ������ ǰ��
	       	 	} else if ( i == 6 ){
	       	 		ct.setEtc2_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�δ��� ����
	       	 		ct.setEtc2_amt_v(AddUtil.parseDigit(tax_r_value[i]));     
	       	 		ct.setR_etc2_amt_s(0);  //�δ��� ����
	       	 		ct.setR_etc2_amt_v(0); 
	       	 		ct.setEtc2_etc(tax_r_g[i]);  //���� ������ ǰ��      	
	       	 	} else if ( i == 7 ){
	       	 		ct.setEtc4_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //���ع��� ����
	       	 		ct.setEtc4_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
	       	 		ct.setR_etc4_amt_s(0);  //���ع��� ����
	       	 		ct.setR_etc4_amt_v(0);   	       	 	     
	       	 		ct.setEtc4_etc(tax_r_g[i]);  //���� ������ ǰ��
	       	 	} else if ( i ==8 ){
	       	 		ct.setOver_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�ʰ�����δ� ����
	       	 		ct.setOver_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
	       	 		ct.setR_over_amt_s(0);  //�ʰ�����δ�� ����
	       	 		ct.setR_over_amt_v(0);   	       	 	     
	       	 		ct.setOver_etc(tax_r_g[i]);  //���� ������ ǰ��	
	       	 	}	
	       	 	       	 
	       	 }			
  			
	}				
	
	if(!ac_db.updateClsEtcTax(ct))	flag += 1;	
	
	//���ݰ�꼭���չ��࿩��					
	if(!ac_db.updateClsEtcTaxGu(rent_mng_id, rent_l_cd, tax_reg_gu ))	flag += 1;
				
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls_st%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='bit' value='Ȯ��'>
<input type='hidden' name='cont_st' value=''>
</form>

<script language='javascript'>
	var fm = document.form1;
	
<%	if(flag != 0){ 	//�������̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');				
	
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action ='<%=from_page%>';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>

