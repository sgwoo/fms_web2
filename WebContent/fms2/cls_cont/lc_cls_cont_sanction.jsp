<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*, acar.cont.*, acar.user_mng.*, acar.cls.*, acar.estimate_mng.*"%>
<%@ page import="acar.insur.*, acar.car_sche.*, acar.res_search.*, acar.common.*,   acar.im_email.*,  acar.memo.*, acar.client.* , tax.*,acar.offls_sui.* "%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>

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
	
	String match 	= request.getParameter("match")==null?"":request.getParameter("match"); //�����Ī :Y
	
	String car_st 	= request.getParameter("car_st")==null?"":request.getParameter("car_st"); // �����뿩 :5
					
	String reco_st 	= request.getParameter("reco_st")==null?"":request.getParameter("reco_st"); // ��ȸ��:N
	
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
					
	boolean flag1 = true;
	boolean flag2 = true;
	 	
	int	flag = 0;	
	int	count = 0;	
		
	String from_page 	=   "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
				
	ClsBean cls = new ClsBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	//�����Ƿ�����
	ClsEtcBean clsEtc = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = clsEtc.getCls_st_r();
			
	String car_mng_id = "";
			
	String mng_id = "";
	
	//���⺻����
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	car_mng_id = base.getCar_mng_id();
		
			//�ŷ�ó����
	ClientBean client       = al_db.getClient(base.getClient_id());
				
		//������ �Ա���
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
	String real_date = "";
	String r_add_date = "";  //�������� 1�� �� -> �������� 1���� �� --> �������� 3�� ��
		
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
	cls.setOver_v_amt(request.getParameter("over_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt_1"))); //�ʰ����� Ȯ���ݾ�	

	cls.setDfee_s_amt(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1"))); //�뿩�� Ȯ���ݾ�	
	cls.setDfee_v_amt(request.getParameter("dfee_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_v_amt_1"))); //�뿩�� Ȯ���ݾ� vat	
	
   	if(!as_db.insertCls2(cls))	flag += 1;
		
	//System.out.println(" ������� flag 1=" + flag);
		
	 	 //�뿩�� ��� - ���������� ����ݿ� ����  - �����Ī�ΰ��� ���� - ������ �̰���.
	 if(!match.equals("Y")){// 
		 if(!ac_db.updateScdFeeCls(rent_mng_id, rent_l_cd, real_date, user_id))	flag += 1;	//�̳��� �뿩�� ���ó��	
	 }	  
	 
	 if(cls_st.equals("7") || cls_st.equals("10") ){//��������� ��� - 
			if(!ac_db.updateContEtcClear(rent_mng_id, rent_l_cd))	flag += 1;	//������� �����ݽ°����� ������ ����Ÿ ����
			
			if(cls_st.equals("7") ){//��������� ��� - 
				//��ü������ ���� 20220426
		 		String  d_flag3 = ec_db.call_sp_com_pre_cls_cont(rent_mng_id, rent_l_cd);
			}
	 }	
	 
	String dl_amt = "";			   
	if(!as_db.closeCont(rent_mng_id, rent_l_cd, cls_st, "", dl_amt, car_no, real_date ))	flag += 1;	
	//System.out.println(" ���� ó�� flag 6=" + flag);
		
	//����������
	 if( cls_st.equals("10") ){//
		int count2 = 0;
	 	
	 	String park = request.getParameter("park")==null?"":request.getParameter("park"); //��������ġ
		String park_cont = request.getParameter("park_cont")==null?"":request.getParameter("park_cont"); //���� ��Ÿ			
		count = rs_db.updateCarPark(car_mng_id, park, park_cont);	
		
		code_bean = c_db.getCodeBean("0027",park);	
			
		if ( !code_bean.getCms_bk().equals("")) {
			Hashtable ht6 = pk_db.getRentParkIOSearch2(car_mng_id);
			count2 = pk_db.UpdateParkIO(String.valueOf(ht6.get("CAR_MNG_ID")));	
		}	
		
		//����ġ�� Ʋ�� ���������� ��� ��������  ���� - 2012-10-09 - ��Ÿ�ΰ��¿���ó��
		String n_mng_br_id = "";
		String n_user_id = nm_db.getWorkAuthUser("�����������");	
		
		if ( !code_bean.getCms_bk().equals("")) {
			n_mng_br_id = code_bean.getCms_bk();
		}
		
		if( n_mng_br_id.equals("S1") ){	
			n_user_id = nm_db.getWorkAuthUser("�����������");	
		}else if(n_mng_br_id.equals("B1") ){	
			n_user_id = nm_db.getWorkAuthUser("�λ�������");	
		}else if(n_mng_br_id.equals("D1") ){	
			n_user_id = nm_db.getWorkAuthUser("����������");	
		}else if(n_mng_br_id.equals("J1") ){	
			n_user_id = nm_db.getWorkAuthUser("����������");	
		}else if(n_mng_br_id.equals("G1") ){	
			n_user_id = nm_db.getWorkAuthUser("�뱸������");
		} else 	{	
			n_user_id = nm_db.getWorkAuthUser("�����������");		
		}
		
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		//����Ÿ����
		ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont.get("RENT_MNG_ID")), String.valueOf(cont.get("RENT_L_CD")));
		
		if(!n_mng_br_id.equals("") && cont_etc.getRent_mng_id().equals("")){
		
			cont_etc.setMng_br_id		(n_mng_br_id);
		
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
			cont_etc.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
			boolean flag21 = a_db.insertContEtc(cont_etc);
		}else{
		
			String o_mng_br_id = cont_etc.getMng_br_id();
			
			if(!n_mng_br_id.equals("") && !o_mng_br_id.equals(n_mng_br_id)){
				
				
				//�������� �����̷µ�� & �������� ���� ����
				LcRentCngHBean bean = new LcRentCngHBean();	
				bean.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
				bean.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
				bean.setCng_item	("mng_br_id");
				bean.setOld_value	(o_mng_br_id);
				bean.setNew_value	(n_mng_br_id);
				bean.setCng_cau		("������ ����ġ ����");
				bean.setCng_id		(ck_acar_id);
				bean.setRent_st		(String.valueOf(cont.get("FEE_RENT_ST")));
				bean.setS_amt		(0);
				bean.setV_amt		(0);	
				boolean flag23 = a_db.updateLcRentCngH(bean);		 
			}		
		}
	
			//������ ����κ� ��� - ������ ������ ���� - 20161005
			if(!clsEtc.getServ_gubun().equals("")) {	  	  
			//	  if ( clsEtc.getServ_st().equals("Y") ) {
				  	 	 count = ac_db.setCar_prepare(car_mng_id, clsEtc.getServ_gubun());
			//	   }			
			}
		
	 }	
	
	if(doc_bit.equals("2")) {			
		if ( cls_st.equals("7") || cls_st.equals("10")  ) { //���������, ���������� 
			   flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,"2") ; // ��������/�������� 				   
			   doc_bit = "3"; 	
			   flag1 = d_db.updateDocSettleDocDt( doc_no, "3","2") ; // ȸ�� skip			 
			  
		}  	
	}
	
	if(doc_bit.equals("3")) {			
		if ( cls_st.equals("7") || cls_st.equals("10")  ) { //���������, ���������� 			
			   flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,"2") ; // 		  
		}  	
	}
	
	 //�ݾ�Ȯ������					
	if(!ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "2", user_id))	flag += 1;			
	
   	if(!d_db.updateDocSettleDocDt( doc_no, "5", "3"))	flag += 1;	 //  ����Ϸ� ó�� 
   	
   	//ȸ��ó�� 
    if(!ac_db.updateClsEtcAuto(rent_mng_id, rent_l_cd, "Y")) flag += 1; 
   	
	System.out.println(" cls_st = 7,10 ������� "+car_no+"--------"+ rent_l_cd);	
							    		
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
	       
	fm.action ='<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
<%	} %>
</script>
</body>
</html>
