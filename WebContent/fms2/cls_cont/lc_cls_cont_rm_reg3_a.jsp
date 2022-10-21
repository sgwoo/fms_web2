<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*, acar.doc_settle.*, acar.cont.*, acar.user_mng.*, acar.cls.*, acar.coolmsg.*,  acar.estimate_mng.*"%>
<%@ page import="acar.insur.*, acar.car_sche.*, acar.res_search.*, acar.common.*, acar.memo.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"Y":request.getParameter("cls_doc_yn");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
		
	boolean flag1 = true;
	boolean flag2 = true;
	 	
	int	flag = 0;	
	int	count = 0;	
		
	String from_page 	=  "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	CommonDataBase c_db = CommonDataBase.getInstance();		
	EstiDatabase e_db = EstiDatabase.getInstance();
			
	ClsBean cls = new ClsBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	//�����Ƿ�����
	ClsEtcBean clsEtc = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = clsEtc.getCls_st_r();
			
	String car_mng_id = "";
	
	String bus_id2 = "";
	
	String mng_id = "";
	
	//���⺻����
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	car_mng_id = base.getCar_mng_id();
	
//	bus_id2 = base.getBus_id2();	
	bus_id2 = base.getMng_id2(); 	
		
	 //����ó���� ���
	String sub = "";
	String cont = "";
	
	//	System.out.println(" doc_sanction doc_bit = " + doc_bit + ": doc_no = :" + doc_no + ": rent_l_cd = " + rent_l_cd);
	
	//doc_settle�� ����	
	//2. ����ó���� ���-------------------------------------------------------------------------------------------
	sub 		= "����Ʈ���� ȸ��ó���Ƿ�";
	cont 	= "[����ȣ:"+rent_l_cd+"] ����Ʈ ȸ��ó�� �Ƿ� �մϴ�.";			
	
	DocSettleBean doc = new DocSettleBean();
	doc.setDoc_st("11");//���������Ƿ� (�ߵ�����, ��ุ��, ���Կɼ�, ���������(����))
	doc.setDoc_id(rent_l_cd);
	doc.setSub(sub);
	doc.setCont(cont);
	doc.setEtc("");
	doc.setUser_nm1("�����");
	doc.setUser_nm2("����������");
	doc.setUser_nm3("ȸ������"); //ä�Ǿ����� ���� ó�� -  ����Ʈ�ΰ��� ������� ȸ��ó����.
	doc.setUser_nm4("ä�Ǵ����");  //��� - 20091201
	doc.setUser_nm5("�ѹ�����");
	
	doc.setUser_id1(reg_id);
	
	String user_id2 = "XXXXXX";
	String user_id3 = "XXXXXX";
	String user_id4 ="XXXXXX";
	String user_id5 = "XXXXXX";
		
	doc.setDoc_bit("1");//���
	doc.setDoc_step("1");//���		

	doc.setUser_id2(user_id2);//����/������
	doc.setUser_id3(user_id3);//ȸ�������
	doc.setUser_id4(user_id4);//ä�ǰ�����
	doc.setUser_id5(user_id5);//�ѹ�����
				 				
	//=====[doc_settle] insert=====
	flag1 = d_db.insertDocSettle(doc);		
	doc = d_db.getDocSettleCommi("11", rent_l_cd);
	doc_no = doc.getDoc_no();
	flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "3",  "2"); //��꼭
	flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "5",  "3");//����
	
		//������ �Ա���
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
	String real_date = "";
	String r_add_date = "";  //�������� 1�� �� -> �������� 1���� �� -> 3�� ��
		
	real_date = cls_dt;
	r_add_date =  c_db.addDay(real_date, 3);  
		
			
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setTerm_yn("Y");  //�������
	cls.setCls_st(cls_st);
	cls.setCls_dt(real_date);
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//���̿�Ⱓ ��
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//���̿�Ⱓ ��
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//��������
	
	cls.setCls_doc_yn("Y");
	cls.setReg_id(reg_id); //�����id
	
	 
	//�ߵ�����, ���Կɼ�, �������� �����Ƿ� ���
	cls.setCancel_yn(request.getParameter("cancel_yn")==null?"":request.getParameter("cancel_yn"));
	cls.setGrt_amt(request.getParameter("grt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("grt_amt")));
	cls.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	cls.setIfee_mon(request.getParameter("ifee_mon")==null?"":		request.getParameter("ifee_mon"));
	cls.setIfee_day(request.getParameter("ifee_day")==null?"":		request.getParameter("ifee_day"));
	cls.setIfee_ex_amt(request.getParameter("ifee_ex_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_ex_amt")));
	cls.setRifee_s_amt(request.getParameter("rifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_s_amt")));
	cls.setRifee_v_amt(request.getParameter("rifee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_v_amt")));
	cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
	cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
	cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
	cls.setRfee_v_amt(request.getParameter("rfee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_v_amt")));
	cls.setNfee_s_amt(request.getParameter("nfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("nfee_s_amt")));
	cls.setNfee_mon(request.getParameter("nfee_mon")==null?"":		request.getParameter("nfee_mon"));
	cls.setNfee_day(request.getParameter("nfee_day")==null?"":		request.getParameter("nfee_day"));
	cls.setNfee_amt(request.getParameter("nfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt_1"))); //�̳��뿩�� ���ʱݾ�
	cls.setEx_di_amt(request.getParameter("ex_di_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt_1"))); //������ �뿩�� �ݾ� (���� �Ǵ� �ܾ�)
	cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt"))); //�뿩�� �Ѿ�
	cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt"))); //����մ뿩��
	cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));  //�ܿ��Ⱓ
	cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));   //�ܿ��Ⱓ
	cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt"))); //�ܿ��Ⱓ�Ѵ뿩��
	cls.setDft_int(request.getParameter("dft_int_1")==null?"":		request.getParameter("dft_int_1")); //�ߵ����� ������
	cls.setDft_amt(request.getParameter("dft_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //�ߵ���������� ���ʱݾ�
	cls.setCar_ja_amt(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //��å�� ���ʱݾ�
	cls.setDly_amt(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //��ü�� ���ʱݾ�
	cls.setEtc_amt(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //����ȸ�����ֺ� ���ʱݾ�
	cls.setEtc2_amt(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //����ȸ���δ�� ���ʱݾ�
	cls.setEtc3_amt(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //������������ ���ʱݾ�
	cls.setEtc4_amt(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //��Ÿ���ع��� ���ʱݾ�

	cls.setFine_amt(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //���·� ���ʱݾ�
	cls.setNo_v_amt(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //�ΰ��� ���ʱݾ�
	cls.setFdft_amt1(request.getParameter("fdft_amt1_1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//�հ� ���ʱݾ�
	cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));//�����Աݾ�
			
	cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_s_amt")));   //��������� ���ް�
	cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_v_amt")));   //��������� �ΰ���
	cls.setCls_est_dt(request.getParameter("est_dt")==null?"":	request.getParameter("est_dt"));

	if(cls.getCls_est_dt().equals(""))	cls.setCls_est_dt(real_date);			

		
	//�߰��Աݾ��� ���� ��� - ���꼭 �ۼ�������
	cls.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //�߰��Ա���
	cls.setEx_ip_amt(request.getParameter("ex_ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_ip_amt")));	  //�߰��Աݾ� 	
	cls.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //�Ա�����
	cls.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //�Աݱ���
	cls.setTot_dist(request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist")));   //��������Ÿ�
	
	cls.setCms_chk(request.getParameter("cms_chk")==null?"N":request.getParameter("cms_chk"));  //cms�����Ƿ�
	
	cls.setOver_amt(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //�ʰ����� Ȯ���ݾ�	
	cls.setOver_v_amt(request.getParameter("over_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt_1"))); //�ʰ����� Ȯ���ݾ� vat
	
	cls.setDfee_s_amt(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1"))); //�뿩�� Ȯ���ݾ�	
	cls.setDfee_v_amt(request.getParameter("dfee_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_v_amt_1"))); //�뿩�� Ȯ���ݾ� vat
			
	//���������� 
	if(!as_db.insertCls2(cls))	flag += 1;
//	System.out.println(" ������� flag 1=" + flag);
		
		 
	 //�ڱ��������ظ�å���� ��������ݿ� ����ó�� - 20100624 �߰�
	 if ( AddUtil.parseDigit(request.getParameter("car_ja_amt_1") ) > 0 ) {
	 			   		
	   		Vector vt3 = ac_db.getServiceDetailCls(rent_mng_id, rent_l_cd);  //�̳��� ��å��
			int vt3_size = vt3.size();			
			
			String serv_id = "";
			String ext_tm = "";
			int  car_ja_amt = 0;
			String bill_doc_yn = "";
				
			for(int i = 0 ; i < vt3_size ; i++){
				Hashtable ht3 = (Hashtable)vt3.elementAt(i);
							
				serv_id	 	 = 	 String.valueOf(ht3.get("EXT_ID")); //����id
				ext_tm	 	 = 	 String.valueOf(ht3.get("EXT_TM")); //����
				car_ja_amt 	 = 	 Util.parseDigit(String.valueOf(ht3.get("CAR_JA_AMT")));  //��å�ݾ�
				bill_doc_yn	 	 = 	 String.valueOf(ht3.get("BILL_DOC_YN")); // 1:��꼭 ���� , 0:�̹���
				
				if (!ac_db.updateServiceDetailCls2(rent_mng_id, rent_l_cd, serv_id, car_ja_amt, ext_tm, real_date, user_id, bill_doc_yn ) )	flag += 1;	//�̳��� ��å�� �Ա� ó��
//				System.out.println("��å�� ��������� ����  flag 3_1=" + flag);
			}  //end for	
	 }
	 	 			
				 
	  //��ü��  ����ó��
	 if ( AddUtil.parseDigit(request.getParameter("dly_amt")) > 0 ){
	 		int dly_amt_0 = AddUtil.parseDigit(request.getParameter("dly_amt"));
	 		int dly_amt_1 = AddUtil.parseDigit(request.getParameter("dly_amt_1"));
	 		if ( (dly_amt_0 - dly_amt_1) > 0 ) { 
	 			int j_dly = dly_amt_0 - dly_amt_1;
		 		if(!ac_db.insertScdDlyCls(rent_mng_id, rent_l_cd, j_dly , real_date, user_id, "1"))	flag += 1;	//�̳��� ��å�� �Ա� ó��	 
//		 		System.out.println("��ü�� ���� flag 4=" + flag);		 		
	 		} 
	 }	
	 			 
		 	 
	 //�뿩�� ��� - ���������� ����ݿ� ����
	 if(!ac_db.updateScdFeeCls(rent_mng_id, rent_l_cd, real_date, user_id))	flag += 1;	//�̳��� �뿩�� ���ó��	
//	 System.out.println(" �뿩�� ��� flag 5=" + flag); 	
	
	  		
	//�����ִ� ����Ÿ�� ���� �� ����������� ������ ����
	 String dl_amt = "";
		 
	//����ȸ���� ���¶�� -- ����ȸ�� ���� ����  - ����ȸ�� �� �ݳ�(��������� ���ؼ�)
	if(!ac_db.updateCarCallIn(rent_mng_id, rent_l_cd, real_date)) flag += 1;	
//	System.out.println(" ����ȸ��(�ݳ�) ó�� flag 6_1=" + flag);
		 
	if(!as_db.closeCont(rent_mng_id, rent_l_cd, cls_st, "", dl_amt, car_no, real_date))	flag += 1;	
//	System.out.println(" ���� ó�� flag 6=" + flag);
	
		//������ ��������� ���� ���� - �ߵ�����, ��ุ��, �縮�������������� ��� - loan_st = '2'�� ��쿡 ���ؼ�, ����Ʈ�����ΰ�쵵 ����
	if ( cls_st.equals("14") ) {
	
	 	UsersBean bus_id2_bean 	= umd.getUsersBean(bus_id2);	 	
	 	if ( !bus_id2_bean.getLoan_st().equals("1") ) {
		// 	if(!ac_db.sendMemo(cls_dt, car_no))	flag += 1;	
	 	//	System.out.println(" ������ ��������� ����ó�� flag 6_2=" + flag);	 
	 	}	 	 
		
	 	int count2 = 0;
	 	
	 	String park = request.getParameter("park")==null?"":request.getParameter("park"); //��������ġ
		String park_cont = request.getParameter("park_cont")==null?"":request.getParameter("park_cont"); //���� ��Ÿ			
		count = rs_db.updateCarPark(car_mng_id, park, park_cont);			
		
		if(park.equals("1") || park.equals("3") || park.equals("7") || park.equals("8")|| park.equals("4") || park.equals("9")  || park.equals("11")  ){//����� ������ ����
			Hashtable ht6 = pk_db.getRentParkIOSearch2(car_mng_id);
			count2 = pk_db.UpdateParkIO(String.valueOf(ht6.get("CAR_MNG_ID")));	
		}	
		
		//������ ���뿩�� ���
		ac_db.call_sp_esti_reg_sh_res (real_date, car_mng_id);	
				
		//  �縮��//����Ʈ ���� - ������
		if ( base.getCar_st().equals("1") ||   base.getCar_st().equals("4")  ) {
			e_db.call_sp_esti_reg_sh(car_mng_id);
		}
					
		//����ġ�� Ʋ�� ���������� ��� ��������  ���� - 2012-10-09 - ��Ÿ�ΰ��¿���ó��
		String n_mng_br_id = "";
		String n_user_id = "000026";	
		if(park.equals("1") || park.equals("5") || park.equals("2") || park.equals("10") || park.equals("15") || park.equals("16")  || park.equals("14" ){	
			n_mng_br_id = "S1";		
			n_user_id = "000026";	
		//�λ����� park_in ('3', '7', '8' )	
		}else if(park.equals("3") || park.equals("7") || park.equals("8")){	
			n_mng_br_id = "B1";	
			n_user_id = "000053";	
		//�������� park_in ('4', '9', '11') 
		}else if(park.equals("4") || park.equals("9") ||  park.equals("11") ){	
			n_mng_br_id = "D1";	
			n_user_id = "000052";	
		}else if(park.equals("12")  ){	
			n_mng_br_id = "J1";	 // ����
			n_user_id = "000052";		
		}else if(park.equals("13")  ){	
			n_mng_br_id = "G1";	
			n_user_id = "000054";
		}
			
		Hashtable cont1 = a_db.getContViewUseYCarCase(car_mng_id);
		//����Ÿ����
		ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont1.get("RENT_MNG_ID")), String.valueOf(cont1.get("RENT_L_CD")));
		
	//	if(!n_mng_br_id.equals("") && cont_etc.getRent_mng_id().equals("")){
		
	//		cont_etc.setMng_br_id		(n_mng_br_id);
		
			//=====[cont_etc] update=====
	//		cont_etc.setRent_mng_id	(String.valueOf(cont1.get("RENT_MNG_ID")));
	//		cont_etc.setRent_l_cd	(String.valueOf(cont1.get("RENT_L_CD")));
	//		boolean flag21 = a_db.insertContEtc(cont_etc);
	//	}else{
		
			String o_mng_br_id = cont_etc.getMng_br_id();
			
			if(!n_mng_br_id.equals("") && !o_mng_br_id.equals(n_mng_br_id)){
				
				
				//�������� �����̷µ�� & �������� ���� ����
				LcRentCngHBean bean = new LcRentCngHBean();	
				bean.setRent_mng_id	(String.valueOf(cont1.get("RENT_MNG_ID")));
				bean.setRent_l_cd	(String.valueOf(cont1.get("RENT_L_CD")));
				bean.setCng_item	("mng_br_id");
				bean.setOld_value	(o_mng_br_id);
				bean.setNew_value	(n_mng_br_id);
				bean.setCng_cau		("������ ����ġ ����");
				bean.setCng_id		(ck_acar_id);
				bean.setRent_st		(String.valueOf(cont1.get("FEE_RENT_ST")));
				bean.setS_amt		(0);
				bean.setV_amt		(0);	
				boolean flag23 = a_db.updateLcRentCngH(bean);
				
				String cont_memo 		= "[������ ����ġ ����] "+car_no+" �� ����ġ�� ����Ǿ����ϴ�. ���������� ��������ڸ� �������ּ���.";
				
			}		
		//}
									
	}
	
	if ( !cls_st.equals("8") ) {
		if (!a_db.updateCarStatCng(car_mng_id))	flag += 1;
//		System.out.println(" �縮�� ó�� flag7=" + flag);		
        	
		
		//������ ������ ���������� ��� �޼��� ����------------------------------------------------------------------------------------------
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
		sub 		= "������� ������ ���� ���";
		cont 	= "[������ȣ:"+car_no+"] ������ ����(���) Ȯ���ϼ���.";	
			
		String url 		= "/acar/rent_prepare/rent_pr_frame_s.jsp";
				
		String target_id = nm_db.getWorkAuthUser("����������");  //������ ������ "000085"; 
		
				
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
		
		//flag2 = cm_db.insertCoolMsg(msg); 20121022 ���¿��븮 ��û���� �޽��� ���� ���� : ��������������ȭ�� �ʿ������
			
	//	System.out.println("��޽���(����������)"+car_no+"---------------------"+target_bean.getUser_nm());	
	}		
	
		//����Ʈ������ ������� �������ڿ��� �޼��� ������ - 20170223 	
	if ( cls_st.equals("14")  ) {
			
		//��������
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		InsurBean ins  = ai_db.getIns(base.getCar_mng_id(), ins_st);
		Hashtable ins_info = ai_db.getInsClsCoolMsg(base.getCar_mng_id(),ins_st);
		
		//20170207 �Ű��̳� ���Կɼ��� ��쿡�� ���������� ��� �ȵǾ� ������  ���� �ٲٱ�
		String msgGubun = "�������";
										
		String sub1 		= "����Ʈ ������� �Ϸ��� ���� ���� üũ���";
		String cont1 	=  msgGubun+" ["+car_no+","+ins_info.get("CAR_NM")+","+ins_info.get("FIRM_NM")+","+ins_info.get("ENP_NO")+","+ins_info.get("INS_START_DT")+","+ins_info.get("INS_EXP_DT")+","+ins_info.get("INS_CON_NO")+"]";	
			
			//���躯���û ���ν��� ȣ��
		String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub1, rent_mng_id, rent_l_cd, "");
	}	
					
				
	if(clsEtc.getServ_st().equals("N")) {
		
		//���� �� ���������ʿ� ��Ͻ� ��������� ����
		RentContBean rc_bean = new RentContBean();
		rc_bean.setCar_mng_id	(car_mng_id);
		rc_bean.setRent_st		("6");
		rc_bean.setRent_dt		(real_date);
		rc_bean.setBrch_id		("");
		rc_bean.setBus_id		(reg_id);
		rc_bean.setRent_start_dt(r_add_date+"0000");
		rc_bean.setEtc			("������ �������� �ڵ����� ");
		rc_bean.setDeli_plan_dt	(r_add_date+"0000");
		rc_bean.setUse_st		("1");
		rc_bean.setReg_id		(reg_id);
		rc_bean.setMng_id		(reg_id);
		rc_bean = rs_db.insertRentCont(rc_bean);	
	
	//	System.out.println("��������� ������"+car_no);	
					
		//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------	
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		sub 		= "������ ó�� �뺸";
		cont 	= "[����]�������� ���-"+car_no+",  "+rc_bean.getEtc() + "�� �Ǿ����ϴ�. ���� ������  ������ ����Ͽ� �������� Ȱ���� �� �ְ� �ϼž� �մϴ�.!!!";
		String target_id = reg_id;
					
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
		xml_data += "    <SENDER>system</SENDER>"+
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
		System.out.println("��޽���[������ ó�� �뺸-������ �������� �ڵ�����] "+car_no+"-----------------------"+target_bean.getUser_nm());	
		
	}
	
			
		//������ ����κ� ��� - ������ ������ ���� - 20161005
	if(!clsEtc.getServ_gubun().equals("")) {	  	  
	//	  if ( clsEtc.getServ_st().equals("Y") ) {
		  	 	 count = ac_db.setCar_prepare(car_mng_id, clsEtc.getServ_gubun());
	//	   }			
	}
		
	
//	flag2 = d_db.updateDocSettleDocDt( doc_no, "5", "3") ; // ����Ʈ ����Ϸ�
	flag2 = ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "2", reg_id);  //����Ϸ� 
	if(!ac_db.updateClsEtcAuto(rent_mng_id, rent_l_cd, "Y")) flag += 1;
						
	System.out.println("������� "+car_no+"--------"+ rent_l_cd);	
			    		
	//����
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>

<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//�������̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');				
     fm.s_kd.value = '2';
     fm.action='/fms2/cls_cont/lc_cls_rm_u3.jsp';
     fm.target='d_content';		
     fm.submit();
<%	
	} %>
</script>
</body>
</html>
