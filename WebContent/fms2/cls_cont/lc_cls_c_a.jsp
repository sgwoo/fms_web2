<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.receive.*,  acar.credit.*, acar.user_mng.*, acar.coolmsg.*,acar.car_sche.*, acar.car_office.*, acar.car_mst.*, acar.cont.*, acar.client.* "%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="r_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String guar_st		 	= request.getParameter("guar_st")==null?"":request.getParameter("guar_st"); //����������
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	
	String dft_saction_id =  request.getParameter("dft_saction_id")==null?"":	request.getParameter("dft_saction_id"); //�ߵ����� ����� ����
	
//	String sb_saction_id =  request.getParameter("sb_saction_id")==null?"":	request.getParameter("sb_saction_id"); //���������(����), ����������(�縮��) �� ��� ������ ����
			
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st"); //�����뿩 
	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"); //  
	
	String match = request.getParameter("match")==null?"N":request.getParameter("match"); //  
	
	
	//����� �������     
	int    dft_amt 	= request.getParameter("dft_amt")		==null?0 :AddUtil.parseDigit(request.getParameter("dft_amt"));  //����� ����
	int    dft_amt_1 	= request.getParameter("dft_amt_1")		==null?0 :AddUtil.parseDigit(request.getParameter("dft_amt_1"));  //����� Ȯ�� 
	
	int flag = 0;
	int count = 1;	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	String c_id = "";
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	
	//������ ��ϵǾ� �ִ��� ����
	ClsEtcBean cls = new ClsEtcBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
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
	cls.setRifee_v_amt(request.getParameter("rifee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_v_amt")));  //���ô뿩��ΰ���  -2022-04-20 �߰� 
	cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
	cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
	cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
	cls.setRfee_v_amt(request.getParameter("rfee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_v_amt")));  //�����ݺΰ���  -2022-04-20 �߰� 
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

//	cls.setDfee_amt_v(request.getParameter("dfee_amt_v")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_v")));   //�뿩�� �ΰ��� ( ���Ա�(������) + �̳� �뿩�� ) 
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
	
	cls.setEst_dt(request.getParameter("est_dt")==null?request.getParameter("cls_dt"):	request.getParameter("est_dt"));  						   //�Աݿ����� ( ������ ������)
	
	cls.setEst_amt(request.getParameter("est_amt")==null?0:				AddUtil.parseDigit(request.getParameter("est_amt")));	   //ä�Ǿ����ݾ� 
	cls.setEst_nm(request.getParameter("est_nm")==null?"":				request.getParameter("est_nm"));  				   //�Աݾ�����
	cls.setGur_nm(request.getParameter("gur_nm")==null?"":				request.getParameter("gur_nm")); 				   //����������
	cls.setGur_rel_tel(request.getParameter("gur_rel_tel")==null?"":	request.getParameter("gur_rel_tel"));      //Ȯ���ݾ� ����
	cls.setGur_rel(request.getParameter("gur_rel")==null?"":			request.getParameter("gur_rel")); 		   //Ȯ���ݾ� ������
	cls.setRemark(request.getParameter("remark")==null?"":				request.getParameter("remark"));           //ó���ǰ�
	
	//���ݰ�꼭 �����Ƿڰ� ��� : �Ƿ��ߴ��� �������ݰ�꼭�� ����ȵ� �� ���� :��⿬ü�� ��� (���ݽ� ���ݰ�꼭 ����ó��)
	cls.setTax_chk0(request.getParameter("tax_chk0")==null?"N":request.getParameter("tax_chk0"));  //�ߵ����������
	cls.setTax_chk1(request.getParameter("tax_chk1")==null?"N":request.getParameter("tax_chk1"));  //�������ֺ��
	cls.setTax_chk2(request.getParameter("tax_chk2")==null?"N":request.getParameter("tax_chk2"));  //�����δ���
	cls.setTax_chk3(request.getParameter("tax_chk3")==null?"N":request.getParameter("tax_chk3"));  //��Ÿ���ع���
	cls.setTax_chk4(request.getParameter("tax_chk4")==null?"N":request.getParameter("tax_chk4"));  //�ʰ�����δ�� 
	
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
	cls.setFdft_amt3(request.getParameter("fdft_amt3")==null?0:					AddUtil.parseDigit(request.getParameter("fdft_amt3")));   //�����Ű��� �� ���Աݾ�
	cls.setTot_dist(request.getParameter("tot_dist")==null?0:					AddUtil.parseDigit(request.getParameter("tot_dist")));   //��������Ÿ�
	cls.setB_tot_dist(request.getParameter("b_tot_dist")==null?0:					AddUtil.parseDigit(request.getParameter("b_tot_dist")));   //��������Ÿ�
	
	//��ȯ������
	cls.setRe_bank(request.getParameter("re_bank")==null?"":request.getParameter("re_bank"));            //����
	cls.setRe_acc_no(request.getParameter("re_acc_no")==null?"":request.getParameter("re_acc_no"));      //ȯ�Ұ��¹�ȣ
	cls.setRe_acc_nm(request.getParameter("re_acc_nm")==null?"":request.getParameter("re_acc_nm"));      //ȯ�� �����ָ�
	
	//��������� cms�����Ƿ�
	String cms_chk = request.getParameter("cms_chk")==null?"N":request.getParameter("cms_chk");
	//���������ΰ��� �����Ƿڰ��� 
	
	//����������  - ���걸�� : 1-> �ջ����� , 2->��������
	String jung_st = request.getParameter("jung_st")==null?"":request.getParameter("jung_st");	
	
	if ( cms_chk.equals("Y") )  {
	    if (!jung_st.equals("2")  &&  AddUtil.parseDigit(request.getParameter("fdft_amt2")) < 1 )   {
		cms_chk = "N";
	    }
	}    
				
	cls.setCms_chk(cms_chk);  //cms�����Ƿ�
		
//	cls.setSb_saction_id(request.getParameter("sb_saction_id")==null?"":	request.getParameter("sb_saction_id")); //���������(����), ����������(�縮��)�� ��� ������ ������
	
	cls.setDft_cost_id(request.getParameter("dft_cost_id")==null?"":	request.getParameter("dft_cost_id")); //����ȿ�� �ͼӴ����
	
	cls.setServ_st(request.getParameter("serv_st")==null?"":	request.getParameter("serv_st")); //������ ��밡�� ����
	cls.setServ_gubun(request.getParameter("serv_gubun")==null?"":	request.getParameter("serv_gubun")); //������ ���� 
	
	//�ʰ�����Ÿ�
	cls.setOver_amt(request.getParameter("over_amt")==null?0:			AddUtil.parseDigit(request.getParameter("over_amt")));  //�ʰ����� �����ݾ�
	cls.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //�ʰ����� Ȯ���ݾ�
	cls.setOver_v_amt(request.getParameter("over_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt"))); //�ʰ����� �����ݾ� �ΰ��� - 2022-04 �߰� 
	cls.setOver_v_amt_1(request.getParameter("over_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt_1"))); //�ʰ����� Ȯ���ݾ� �ΰ��� - 2022-04 �߰�
	
	cls.setMatch(request.getParameter("match")==null?"N":request.getParameter("match"));      //�����Ī
	//����������
	cls.setExt_saction_id(request.getParameter("ext_saction_id")==null?"":	request.getParameter("ext_saction_id")); //������ �ĺ�ó�� ����
	cls.setExt_reason(request.getParameter("ext_reason")==null?"":	request.getParameter("ext_reason"));       //������ �ĺ�ó�� ����
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
	
	clsm.setCms_after(request.getParameter("cms_after")==null?"":request.getParameter("cms_after"));            //�ڵ���ü ����ó�� 	
	clsm.setCms_amt(request.getParameter("cms_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cms_amt")));	  //cms �κ�����ݾ� 	
	
	if (  match.equals("Y")) {
		clsm.setMatch_l_cd(request.getParameter("match_l_cd")==null?"":request.getParameter("match_l_cd"));            //�����Ī����ȣ 
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
		cr.setPark(request.getParameter("park")==null?"":				request.getParameter("park"));  //������	
		cr.setPark_cont(request.getParameter("park_cont")==null?"":		request.getParameter("park_cont"));  //���� Ư�̻���

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
		
		cc.setCrd_req_gu1(request.getParameter("crd_req_gu1")==null?"":		request.getParameter("crd_req_gu1"));  //��������û������ �Ǹ��м�
		cc.setCrd_req_gu2(request.getParameter("crd_req_gu2")==null?"":		request.getParameter("crd_req_gu2"));  //���뺸�����󿩺�
		cc.setCrd_req_gu3(request.getParameter("crd_req_gu3")==null?"":		request.getParameter("crd_req_gu3"));  //ä���߽ɿ���
		cc.setCrd_req_gu4(request.getParameter("crd_req_gu4")==null?"":		request.getParameter("crd_req_gu4"));  //�ڵ������غ���
		cc.setCrd_req_gu5(request.getParameter("crd_req_gu5")==null?"":		request.getParameter("crd_req_gu5"));  //����
		cc.setCrd_req_gu6(request.getParameter("crd_req_gu6")==null?"":		request.getParameter("crd_req_gu6"));  //���ó��
		
		cc.setCrd_pri1(request.getParameter("crd_pri1")==null?"":		request.getParameter("crd_pri1"));  //��������û�� �켱����
		cc.setCrd_pri2(request.getParameter("crd_pri2")==null?"":		request.getParameter("crd_pri2"));  //���뺸�����󿩺�
		cc.setCrd_pri3(request.getParameter("crd_pri3")==null?"":		request.getParameter("crd_pri3"));  //ä���߽ɿ���
		cc.setCrd_pri4(request.getParameter("crd_pri4")==null?"":		request.getParameter("crd_pri4"));  //�ڵ������غ���
		cc.setCrd_pri5(request.getParameter("crd_pri5")==null?"":		request.getParameter("crd_pri5"));  //����
		cc.setCrd_pri6(request.getParameter("crd_pri6")==null?"":		request.getParameter("crd_pri6"));  //���ó��
		
		cc.setGuar_st(guar_st);  //������ ���� - ��ǥ����				
						
		boolean cr1_flag = ac_db.insertCarCredit(cc);
		
		//����������  - ���걸�� : 1-> �ջ����� , 2->��������
		//�������������
		if (  jung_st.equals("1") ||  jung_st.equals("2")  ) { 
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
							
			cct.setH_st(request.getParameter("h_st")==null?"":			request.getParameter("h_st"));  //����
			cct.setH_ip_dt(request.getParameter("h_ip_dt")==null?"":		request.getParameter("h_ip_dt"));  //�Ա�(����)����
	//		cct.setPay_st(request.getParameter("pay_st")==null?"":			request.getParameter("pay_st"));  //ȯ���ΰ�� ��������: 2->���� . �����ʿ�
			
			cct.setSuc_gubun(request.getParameter("suc_gubun")==null?"":		request.getParameter("suc_gubun"));  //�°�
			cct.setSuc_l_cd(request.getParameter("suc_l_cd")==null?"":		request.getParameter("suc_l_cd"));  //�°���� ����ȣ 
			
			cct.setDelay_st(request.getParameter("delay_st")==null?"":		request.getParameter("delay_st"));  //�������� 
			cct.setDelay_type(request.getParameter("delay_type")==null?"":		request.getParameter("delay_type"));  //�������� 
			cct.setDelay_desc(request.getParameter("delay_desc")==null?"":		request.getParameter("delay_desc"));  //�������� 
			cct.setRefund_st(request.getParameter("refund_st")==null?"":		request.getParameter("refund_st"));  //ȯ�ұ��� 						
			boolean cr5_flag = ac_db.insertClsContEtc(cct);
		}
		
		if ( !car_st.equals("5") )  {
			if(cls_st.equals("1") ||cls_st.equals("2") ){   // ������ ��� - 20160202		
			  //r_over_amt�� �ִٸ� - ����ݾ��� �ִٸ�	      
		    //    	if ( AddUtil.parseDigit(request.getParameter("r_over_amt")) != 0 ) {
					        		
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
							
			//����� ���� 
			ClsCarExamBean cce = new ClsCarExamBean();
			cce.setRent_mng_id(rent_mng_id);
			cce.setRent_l_cd	(rent_l_cd);
			cce.setS_seq(1); //����	
			cce.setExam_dt(request.getParameter("exam_dt")==null?"":		request.getParameter("exam_dt"));  //������ 
			cce.setExam_id(request.getParameter("exam_id")==null?"":		request.getParameter("exam_id"));  //�����
			cce.setS_gu1(request.getParameter("s_gu1")==null?"":			request.getParameter("s_gu1"));  //
			cce.setS_gu2(request.getParameter("s_gu2")==null?"":			request.getParameter("s_gu2"));  //
			cce.setS_gu3(request.getParameter("s_gu3")==null?"":			request.getParameter("s_gu3"));  //
			cce.setS_gu4(request.getParameter("s_gu4")==null?"":			request.getParameter("s_gu4"));  //		
			cce.setS_remark(request.getParameter("s_remark")==null?"":		request.getParameter("s_remark"));  //
			cce.setS_result(request.getParameter("s_result")==null?"":		request.getParameter("s_result"));  //���
			
			boolean cr2_flag = r_db.insertClsCarExam(cce);	
		  	  	
		    if ( guar_st.equals("1") ) {  //�������� �ִٸ� 
				
				//������ ����		
				String gu_seq[] 	= request.getParameterValues("gu_seq");
				String gu_nm[] 	= request.getParameterValues("gu_nm");
				String gu_addr[] 	= request.getParameterValues("gu_addr");
				String gu_zip[] 	= request.getParameterValues("gu_zip");
				String gu_tel[] 	= request.getParameterValues("gu_tel");
				String gu_rel[] 	= request.getParameterValues("gu_rel");
		//		String plan_st[] 	= request.getParameterValues("plan_st");
		//		String eff_st[] 	= request.getParameterValues("eff_st");
				String plan_rem[] 	= request.getParameterValues("plan_rem");
				String eff_rem[] 	= request.getParameterValues("eff_rem");
				
				int gu_size = gu_nm.length;
				
				String plan_st_n = "";
				String eff_st_n = "";
							
		//		System.out.println("���� ������=" + gu_size + ":" + rent_l_cd);
							
					for(int i = 0 ; i < gu_size ; i++){
					//	System.out.println("gu_nm[i] 1 =" + gu_nm[i] );
						if(!gu_nm[i].equals("") ){
							ClsCarGurBean ccc = new ClsCarGurBean();
								
							ccc.setRent_mng_id(rent_mng_id);
							ccc.setRent_l_cd	(rent_l_cd);
						//	System.out.println("gu_nm[i] 2 =" + rent_l_cd );	
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
																
							boolean cr3_flag = r_db.insertClsCarGur(ccc);	
							
						}
					}	
			  }	
		}	  	
		
	}
	
    if ( !match.equals("Y")) {  //�����Ī�� �ƴϸ� 
    	
    	if (  dft_amt != dft_amt_1 ) {	
    		System.out.println("��޽���(����������� ����� ���װ� �޽��� ���Ȯ�ο� )"+rent_l_cd);	
    	}
	//�ߵ������� ����ݸ��� ���� �޽��� ����	
		if(dft_saction_id.equals("000005") ||  dft_saction_id.equals("000028") ||  dft_saction_id.equals("000026") ){
		
			// ------------------------------------------------------------------------------------------
			
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
								
			String sub 		= "�ߵ����� ����� ���װ��� ���� ó�� ���";
			String cont 	= "[����ȣ:"+rent_l_cd+"]  �ߵ����� ����� ���װ��� ���� ��û�մϴ�.";	
			
			String url = 	"/fms2/cls_cont/lc_cls_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|dft=Y";
			
			
			String target_id = "";
			if (  dft_saction_id.equals("000026") ) {
					target_id =dft_saction_id;   
			} else{		
				target_id = "000028";  //�ߵ����� ����� ����		
				CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id); 
			   if(!cs_bean2.getWork_id().equals("")) target_id =  cs_bean2.getWork_id();    // cs_bean3.getWork_id();		
			
		//	String target_id =dft_saction_id;     //�ߵ����� ����� ����		
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
		 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		//	xml_data += "    <TARGET>2006007</TARGET>";	
			
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
				
			System.out.println("��޽���(����������� ����� ���� ��û )"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
		}
    }
    
		
	//�����ڵ带 ������ ��ϵ� �����ڵ�� �޼����߼�(20190930)
	//������ ��������� �޼��� ���� 
	int elec_cnt = 0;
	elec_cnt= ac_db.getElecCnt(rent_l_cd );	
	
//	if(cls_st.equals("7")){	//����������Ӹ��ƴ϶� ��� ���� �޼��� �߼�.(20191021)
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	CommonEtcBean ce_bean	= c_db.getCommonEtc("set_msg", "jg_code", "�����������޼��������ڵ弳��", "", "", "", "", "", "");	
	String c_content = ce_bean.getEtc_content();
	String [] c_content_arr = c_content.split(",");
	boolean result =false;
	for(int i=0;i<c_content_arr.length;i++){
		if(cm_bean.getJg_code().equals(c_content_arr[i])){	result = true;	}
	}
	
	if(elec_cnt > 0){		result = true;		}	//������, �������� �����ڵ��Ͼ��ص� �޼����߼�
	
	if(result){
		//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------	
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String sub 	= "����������� > ����������� ���� �뺸";
		String cont 	= "����������� > ������������� ���� �Ǿ����ϴ�. ��ȣ�� : "+client.getFirm_nm()+" ����ȣ : "+rent_l_cd +" , ���� ������ ���� �ٶ��ϴ�.";
	
		String target_id = nm_db.getWorkAuthUser("���������");  //������ ������ "000144"; 
					
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
						"    <URL></URL>";
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
	}
	//} 
		
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
	
	//����Ÿ� �Է½� ���Է�üũ ���ν���  ghcnf -20190122
	if(cls_st.equals("1") ||cls_st.equals("2") || cls_st.equals("10")  ){   // ������ ��� - 20160202		
		String  d_flag3 =  ad_db.call_sp_dist_case_ck(car_mng_id, user_id);
  }

	//������ ������ ��û ���� Ȯ�� (20190611)
	CarOffPreDatabase cop_db 	= CarOffPreDatabase.getInstance();
	EcarChargerBean ec_bean	= cop_db.getEcarChargerOne(cls.getRent_l_cd(), cls.getRent_mng_id());
	
	//������ ������ ��û �����̸� �����, ����������� ���� �޼���	(20190611)
	if(!ec_bean.getRent_l_cd().equals("")){
		String sub4 		= "������ ������ ��û���� �ȳ�";
		String cont4 		= "[ "+ec_bean.getRent_l_cd()+" ] ����ó�� �Ǿ����ϴ�. ������ ������ ��û������ ������ Ȯ���ϼ���.";
		String target_id4 	= nm_db.getWorkAuthUser("���������");						//������ �����
		String target_id5 	= ec_bean.getReg_id();	//�����(�������û�����)
								
		//����� ���� ��ȸ
		UsersBean target_bean4 	= umd.getUsersBean(target_id4);
		UsersBean target_bean5 	= umd.getUsersBean(target_id5);

		String xml_data4 = "";
		xml_data4 =  "<COOLMSG>"+
							 "<ALERTMSG>"+
 								 "    <BACKIMG>4</BACKIMG>"+
							 "    <MSGTYPE>104</MSGTYPE>"+
							 "    <SUB>"+sub4+"</SUB>"+
	  						 "    <CONT>"+cont4+"</CONT>"+
							 "    <URL></URL>";
		xml_data4 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
		xml_data4 += "    <TARGET>"+target_bean5.getId()+"</TARGET>";
		xml_data4 += "    <SENDER></SENDER>"+
 								 "    <MSGICON>10</MSGICON>"+
							 "    <MSGSAVE>1</MSGSAVE>"+
 								 "    <LEAVEDMSG>1</LEAVEDMSG>"+
							 "    <FLDTYPE>1</FLDTYPE>"+
 								 "  </ALERTMSG>"+
							 "</COOLMSG>";
		CdAlertBean msg4 = new CdAlertBean();
		msg4.setFlddata(xml_data4);
		msg4.setFldtype("1");

		boolean flag7 = cm_db.insertCoolMsg(msg4);
	}
	
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
   fm.action ='/fms2/cls_cont/lc_cls_u.jsp';
 //  fm.action ='/fms2/cls_cont/lc_cls_d_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
