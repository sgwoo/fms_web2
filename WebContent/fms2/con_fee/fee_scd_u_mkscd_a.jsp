<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.common.*, acar.util.*,acar.cont.*, acar.car_mst.*, acar.insur.*, acar.user_mng.*, acar.coolmsg.*, acar.ext.*, acar.car_register.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ae_db" class="acar.ext.AddExtDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String auth 		= request.getParameter("auth")		==null?"":request.getParameter("auth");
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	InsDatabase ai_db 	= InsDatabase.getInstance();
	LoginBean login 	= LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	//�α��� ���������
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	String admin_yn = "";
	if(nm_db.getWorkAuthUser("������",user_id)){
		admin_yn = "Y";
	}
	
	String m_id 			= request.getParameter("m_id")			==null?"":request.getParameter("m_id");
	String l_cd 			= request.getParameter("l_cd")			==null?"":request.getParameter("l_cd");
	String c_id 			= request.getParameter("c_id")			==null?"":request.getParameter("c_id");
	String rent_st 			= request.getParameter("rent_st")		==null?"":request.getParameter("rent_st");
	String gubun 			= request.getParameter("gubun")			==null?"":request.getParameter("gubun");
	String tae_no 			= request.getParameter("tae_no")		==null?"":request.getParameter("tae_no");
	int    idx 			= request.getParameter("idx")			==null?2:AddUtil.parseInt(request.getParameter("idx"));
	//�뿩���
	String rent_start_dt 		= request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt 		= request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt");
	int    con_mon 			= request.getParameter("rent_mon")		==null?0:AddUtil.parseDigit(request.getParameter("rent_mon"));
	int    fee_amt 			= request.getParameter("fee_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_amt"));
	int    fee_s_amt 		= request.getParameter("fee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int    fee_v_amt 		= request.getParameter("fee_v_amt")		==null?0:AddUtil.parseDigit(request.getParameter("fee_v_amt"));
	int    f_fee_amt 		= request.getParameter("f_fee_amt")		==null?0:AddUtil.parseDigit(request.getParameter("f_fee_amt"));
	int    f_fee_s_amt 		= request.getParameter("f_fee_s_amt")		==null?0:AddUtil.parseDigit(request.getParameter("f_fee_s_amt"));
	int    f_fee_v_amt 		= request.getParameter("f_fee_v_amt")		==null?0:AddUtil.parseDigit(request.getParameter("f_fee_v_amt"));
	int    f_rtn2_fee_amt 	= request.getParameter("f_rtn2_fee_amt")	==null?0:AddUtil.parseDigit(request.getParameter("f_rtn2_fee_amt"));
	int    f_rtn2_fee_s_amt = request.getParameter("f_rtn2_fee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("f_rtn2_fee_s_amt"));
	int    f_rtn2_fee_v_amt = request.getParameter("f_rtn2_fee_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("f_rtn2_fee_v_amt"));
	//���Թ��
	String prv_mon_yn 		= request.getParameter("prv_mon_yn")		==null?"":request.getParameter("prv_mon_yn");			//����������� �Ⱓ ���Կ���(0-������,1-����)
	String tax_br_id 		= request.getParameter("tax_br_id")		==null?"":request.getParameter("tax_br_id");			//���࿵����
	String fee_pay_st 		= request.getParameter("fee_pay_st")		==null?"":request.getParameter("fee_pay_st");			//���ι��
	String fee_sh 			= request.getParameter("fee_sh")		==null?"":request.getParameter("fee_sh");			//���ι��(0-�ĺ�,1-����)
	String fee_est_day		= request.getParameter("fee_est_day")		==null?"":request.getParameter("fee_est_day");			//��������
	//String fee_req_day		= request.getParameter("fee_req_day")		==null?"":request.getParameter("fee_req_day");			//û������
	String f_use_start_dt 		= request.getParameter("f_use_start_dt")	==null?"":request.getParameter("f_use_start_dt");		//1ȸ�����Ⱓ
	String f_use_end_dt 		= request.getParameter("f_use_end_dt")		==null?"":request.getParameter("f_use_end_dt");			//1ȸ�����Ⱓ
	String fee_fst_dt 		= request.getParameter("fee_fst_dt")		==null?"":request.getParameter("fee_fst_dt");			//1ȸ�� ������
	String f_req_dt 		= request.getParameter("f_req_dt")		==null?"":request.getParameter("f_req_dt");			//1ȸ�� ������
	String cng_cau	 		= request.getParameter("cng_cau")		==null?"":request.getParameter("cng_cau");			//1ȸ�� �뿩�� ����
	String etc	 				= request.getParameter("etc")		==null?"":request.getParameter("etc");		
	String etc2	 				= request.getParameter("etc2")		==null?"":request.getParameter("etc2");		
	String o_tot_mon		= request.getParameter("o_tot_mon")		==null?"":request.getParameter("o_tot_mon");		
	
	
	int    leave_day 		= request.getParameter("leave_day")		==null?0:AddUtil.parseDigit(request.getParameter("leave_day"));	//�������
	int    fee_pay_tm 		= request.getParameter("fee_pay_tm")		==null?0:AddUtil.parseDigit(request.getParameter("fee_pay_tm"));//����Ƚ��
	int    mon_st			= request.getParameter("mon_st")		==null?1:AddUtil.parseInt(request.getParameter("mon_st"));
	//����û��
	String rtn_st 			= request.getParameter("rtn_st")		==null?"":request.getParameter("rtn_st");			//���տ���
	int    rtn_tm 			= request.getParameter("rtn_tm")		==null?0:AddUtil.parseInt(request.getParameter("rtn_tm"));	//���Ұ���
	int    u_mon	 		= request.getParameter("u_mon")			==null?0:AddUtil.parseDigit(request.getParameter("u_mon"));	//00����
	int    u_day	 		= request.getParameter("u_day")			==null?0:AddUtil.parseDigit(request.getParameter("u_day"));	//00�ϼ�	
	String rtn_firm_nm[] 		= request.getParameterValues("rtn_firm_nm");
	String rtn_client_id[] 		= request.getParameterValues("rtn_client_id");
	String rtn_site_id[] 		= request.getParameterValues("rtn_site_id");
	String rtn_fee_amt[] 		= request.getParameterValues("rtn_fee_amt");
	String rtn_fee_s_amt[] 		= request.getParameterValues("rtn_fee_s_amt");
	String rtn_fee_v_amt[] 		= request.getParameterValues("rtn_fee_v_amt");
	String rtn_type[] 		= request.getParameterValues("rtn_type");
	
	//����Ʈ���ʰ����ݾ�
	int    v_f_rent_tot_amt		= request.getParameter("v_f_rent_tot_amt")	==null?0:AddUtil.parseDigit(request.getParameter("v_f_rent_tot_amt"));
	
	String fee_est_y 		= request.getParameter("fee_est_y")==null?"":request.getParameter("fee_est_y");
	String fee_est_m 		= request.getParameter("fee_est_m")==null?"":request.getParameter("fee_est_m");
	String fee_est_d 		= request.getParameter("fee_est_d")==null?"":request.getParameter("fee_est_d");
	
	String r_use_end_dt 	= "";
	String req_fst_dt 	= "";
	String cms_start_dt 	= "";
	String cms_end_dt 	= "";
	
	String f_etc 	= "";
	String l_etc 	= "";

	//ó������
	int flag = 0;
	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;	
	boolean flag12 = true;
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;
	boolean c_flag3 = true;
	
	
	//���⺻����
	ContBaseBean cont 	= a_db.getCont(m_id, l_cd);
	
	//�뿩�⺻����
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");	
	
	ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, rent_st);
	ContCarBean fee_etcs = new ContCarBean();
	ContFeeRmBean fee_rm = new ContFeeRmBean();
	
	if(cont.getCar_st().equals("4")){
		//����Ʈ����
		fee_rm = a_db.getContFeeRm(m_id, l_cd, rent_st);
		fee_etcs = a_db.getContFeeEtc(m_id, l_cd, rent_st);
	}		

	

	//�����̷� ���------------------------------------------------------------------------
	FeeScdCngBean cng = new FeeScdCngBean();
	cng.setRent_mng_id(m_id);
	cng.setRent_l_cd	(l_cd);
	cng.setFee_tm			("1");
	cng.setAll_st			("");
	cng.setGubun			("�űԻ���");
	cng.setB_value		("");
	cng.setA_value		(request.getParameter("fee_pay_tm")+"ȸ��");
	cng.setCng_id			(user_id);
	cng.setCng_cau		("�űԻ��� ��� "+cng_cau);
	
	if(idx == 1 && rent_st.equals("")){
		cng.setGubun		("����������� �űԻ���");
		cng.setCng_cau	("����������� �űԻ��� ��� "+cng_cau);
	}
	
	if(idx == 1 && f_fee.getFee_s_amt()==0 && f_fee.getPp_chk().equals("0")){
		cng.setGubun		("�����ݱյ���� �űԻ���");
		cng.setCng_cau	("�����ݱյ���� �űԻ��� ��� "+cng_cau);
	}	
	
	if(!af_db.insertFeeScdCng(cng)) flag += 1;
	
	
	
	//��������������� ����------------------------------------------------------------------------
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
		
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
		
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	if(idx == 1 && rent_st.equals("")){		
		taecha.setCar_rent_st	(rent_start_dt);
		taecha.setCar_rent_dt	(fee_fst_dt);
		if(!a_db.updateTaecha(taecha)) flag1 += 1;
		
		ContFeeBean fee_add = a_db.getContFeeNewAdd(m_id, l_cd, "t");
		if(!AddUtil.replace(taecha.getCar_rent_et(),"-","").equals(fee_add.getRent_end_dt()) || !AddUtil.replace(taecha.getCar_rent_st(),"-","").equals(fee_add.getRent_start_dt())){
			fee_add.setRent_start_dt	(taecha.getCar_rent_st());
			fee_add.setRent_end_dt		(taecha.getCar_rent_et());
			boolean taecha_flag = a_db.updateContFeeAdd(fee_add);
		}
		
		ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
		fee.setBr_id		(tax_br_id);
		if(!a_db.updateContFeeNew(fee))	flag2 += 1;
		
			//��������� ���Ա��ϰ�� �޽��� �߼�
			//�Աݴ���ڿ��� �޽��� �߼�
			if(taecha.getF_req_yn().equals("Y") && !taecha.getF_req_dt().equals("")){
				UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("�Աݴ��"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>��������� ���Ա� ���</SUB>"+
		  				"    <CONT>��������� ���Ա� ����� �뿩�ὺ������ �����Ǿ����ϴ�.  &lt;br&gt; &lt;br&gt; �Ա� Ȯ�� �Ͻʽÿ�.  &lt;br&gt; &lt;br&gt;  "+l_cd+" "+firm_nm+" ���뿩��"+taecha.getRent_fee()+"��</CONT>"+
 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
				CdAlertBean msg3 = new CdAlertBean();
				msg3.setFlddata(xml_data3);
				msg3.setFldtype("1");
			
				flag12 = cm_db.insertCoolMsg(msg3);
				
			}		
	}
	

	
	
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	


	//�뿩������� ����------------------------------------------------------------------------
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	if(idx == 2 && !rent_st.equals("")){//�ű�+���� �뿩��				
		fee.setFee_pay_st	(fee_pay_st);
		fee.setFee_sh		(fee_sh);
		fee.setFee_est_day	(fee_est_day);
		//fee.setFee_req_day	(fee_req_day);
		fee.setFee_fst_dt	(fee_fst_dt);
		fee.setLeave_day	(request.getParameter("leave_day")==null?"":request.getParameter("leave_day"));
		fee.setFee_pay_tm	(request.getParameter("fee_pay_tm")==null?"":request.getParameter("fee_pay_tm"));
		fee.setBr_id		(tax_br_id);
		fee.setRtn_st		(rtn_st);
		
		//�������� [�뿩������]�� ��� �뿩������ ������ �ǰ����Ϸ� �������ش�.
		if(fee.getFee_est_day().equals("98")){
			String r_fee_est_day 	= fee_est_d;
			int    mon_last_day 	= AddUtil.getMonthDate(AddUtil.parseInt(fee_est_y), AddUtil.parseInt(fee_est_m));
			if(AddUtil.parseInt(r_fee_est_day)==mon_last_day){
				fee.setFee_est_day	("99");
			}else{
				fee.setFee_est_day	(r_fee_est_day);
			}			
		}
		
		if(!a_db.updateContFeeNew(fee))	flag2 += 1;
	}




	//����û�� ------------------------------------------------------------------------
	
	if(rtn_st.equals("Y")){
		
		for(int i = 0 ; i < rtn_tm ; i++){
		
			FeeRtnBean rtn = af_db.getFeeRtn(m_id, l_cd, rtn_client_id[i], rtn_site_id[i], AddUtil.parseDigit(rtn_fee_amt[i]));
			if(rent_st.equals("")){
				rtn.setRent_st		("1");		//�����������
			}else{
				rtn = af_db.getFeeRtn(m_id, l_cd, rent_st, String.valueOf(i+1), rtn_client_id[i], rtn_site_id[i], AddUtil.parseDigit(rtn_fee_amt[i]));
				rtn.setRent_st		(rent_st);	//����||����				
			}
			rtn.setRent_seq			(String.valueOf(i+1));
			rtn.setClient_id		(rtn_client_id[i]);
			rtn.setR_site			(rtn_site_id[i]);
			rtn.setRtn_est_dt		(fee_fst_dt);
			rtn.setRtn_amt			(AddUtil.parseDigit(rtn_fee_amt[i]));
			rtn.setRtn_move_st		("0");
			rtn.setUpdate_id		(user_id);
			rtn.setRtn_type			(rtn_type[i]);
			
			if(rtn.getRent_l_cd().equals("")){
				rtn.setRent_mng_id	(m_id);
				rtn.setRent_l_cd	(l_cd);
				if(!af_db.insertFeeRtn(rtn))	flag3 += 1;
			}
			
			out.println("����û���ݾ� : "+rtn_fee_amt[i]+"<br>");
		}
	}	


	int rtn_size = 1;
	
	
	if(rtn_st.equals("Y")){
		rtn_size = rtn_tm;
	}else{
		rtn_fee_amt[0] 		= request.getParameter("fee_amt");
		rtn_fee_s_amt[0] 	= request.getParameter("fee_s_amt");
		rtn_fee_v_amt[0] 	= request.getParameter("fee_v_amt");
		
		//����Ʈ ���뿩��
		if(cont.getCar_st().equals("4")){
			rtn_fee_amt[0] 		= String.valueOf(fees.getFee_s_amt());
			rtn_fee_s_amt[0]	= String.valueOf(fees.getFee_v_amt());
			rtn_fee_v_amt[0] 	= String.valueOf(fees.getFee_s_amt()+fees.getFee_v_amt());
		}
	}
	



	//�����뿩������ �뿩Ƚ�� �ִ밪
	int max_fee_tm = a_db.getMax_fee_tm(m_id, l_cd);
	
	
	//�������Ⱓ�� ��ü �뿩�Ⱓ�� ���Եȴٸ� Ƚ���� ���δ�.
	if(prv_mon_yn.equals("1") && rent_st.equals("1")){
		//fee_pay_tm=fee_pay_tm-max_fee_tm;
	}
	


	//�����ٻ��� ------------------------------------------------------------------------
	
	int totoal_fee_s_amt = 0;
	
	for(int s = 0 ; s < rtn_size ; s++){
		
		int fee_fst_amt		= 0;
		int fee_fst_s_amt		= 0;
		int fee_fst_v_amt		= 0;
		int r_t_fee_s_amt		= 0;
		int r_t_fee_v_amt		= 0;
		
		
		//1ȸ�� ������
		String f_use_s_dt 	= f_use_start_dt;
		//1ȸ�� ��������
		String f_use_e_dt 	= f_use_end_dt;
		//2ȸ�� �ǽ�����
		String t_use_s_dt 	= c_db.addDay(f_use_end_dt, 1);
		//���� ������
		String use_e_dt 	= c_db.minusDay(c_db.addMonth(rent_start_dt, fee_pay_tm), 1);
		//20170421 ���غ��� (��)�뿩�Ⱓ 2017-04-18 ~ 2020-04-18
		if(rent_st.equals("1") && (cont.getCar_st().equals("1") || cont.getCar_st().equals("3") || cont.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(f_fee.getRent_start_dt(),"-","")) >= 20170421){
			use_e_dt 	= c_db.addMonth(rent_start_dt, fee_pay_tm);
		}
		
		if(mon_st == 12){
			use_e_dt = rent_end_dt;
		}
		
		//�������� 1ȸ�������϶�
		if(idx == 1 && rent_st.equals("") && fee_pay_tm == 1){	
			use_e_dt	= f_use_end_dt;
		}
		

	
		//�뿩�Ⱓ�� ���� 1ȸ�� ����������
		String r_use_e_dt 	= c_db.minusDay(c_db.addMonth(f_use_s_dt, 1), 1);
		
		//20170421 ���غ��� (��)�뿩�Ⱓ 2017-04-18 ~ 2020-04-18
		if(rent_st.equals("1") && (cont.getCar_st().equals("1") || cont.getCar_st().equals("3") || cont.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(f_fee.getRent_start_dt(),"-","")) >= 20170421){
			r_use_e_dt 	= c_db.addMonth(f_use_s_dt, 1);
		}		
		int    use_days 	= 0;
		

		if(mon_st == 12){
			r_use_e_dt 	= c_db.minusDay(c_db.addMonth(f_use_s_dt, 12), 1);
			//20170421 ���غ��� (��)�뿩�Ⱓ 2017-04-18 ~ 2020-04-18
			if(rent_st.equals("1") && (cont.getCar_st().equals("1") || cont.getCar_st().equals("3") || cont.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(f_fee.getRent_start_dt(),"-","")) >= 20170421){
				r_use_e_dt 	= c_db.addMonth(f_use_s_dt, 12);
			}
		}


		//�������� 1ȸ�������϶�
		if(idx == 1 && rent_st.equals("") && fee_pay_tm == 1){	
			r_use_e_dt	= f_use_end_dt;
		}
		
		
		if(admin_yn.equals("Y")){
			out.println("======�뿩�Ⱓ=-======="+"<br>");
			out.println("���һ�����  	: "+rtn_size+"<br>");
			out.println("���������ٻ�����  	: "+max_fee_tm+"<br>");
			out.println("���������ٻ�����  	: "+fee_pay_tm+"<br>");
			out.println("1ȸ�� �Ⱓ  	: "+f_use_s_dt+"~"+f_use_e_dt+"<br>");
			out.println("2ȸ�������� 	: "+t_use_s_dt+"<br>");
			out.println("���� ������ 	: "+rent_end_dt+"<br>");
			out.println("���� ������ 	: "+use_e_dt+"<br><br>");			
			out.println("1ȸ������������ 	: "+r_use_e_dt+"<br><br>");			
		}
		
		
		//�Ѵ뿩��
		int t_fee_amt			= AddUtil.parseDigit(rtn_fee_amt[s]) * fee_pay_tm;
		int t_fee_s_amt			= AddUtil.parseDigit(rtn_fee_s_amt[s]) * fee_pay_tm;
		int t_fee_v_amt			= t_fee_amt - t_fee_s_amt;
		
		if(mon_st == 12){
			t_fee_amt			= AddUtil.parseDigit(rtn_fee_amt[s]) * 12 * fee_pay_tm;
			t_fee_s_amt			= AddUtil.parseDigit(rtn_fee_s_amt[s]) * 12 * fee_pay_tm;
			t_fee_v_amt			= t_fee_amt - t_fee_s_amt;
		}
		
		//����Ʈ �Ѿ�
		if(cont.getCar_st().equals("4")){
			t_fee_amt		= fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt();
			t_fee_s_amt		= fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt();
			t_fee_v_amt		= t_fee_amt - t_fee_s_amt;			
		}
		
		//������ �Ѿ�
		if(s > 0 && rtn_type[s].equals("4")){
			t_fee_amt			= fee.getPp_s_amt()+fee.getPp_v_amt();
			t_fee_s_amt		= fee.getPp_s_amt();
			t_fee_v_amt		= fee.getPp_v_amt();
		}
		
		
		
		if(admin_yn.equals("Y")){	
			out.println("======�Ѵ뿩��=-======="+"<br>");		
			out.println("t_fee_amt 		: "+t_fee_amt+"<br><br>");
			out.println("t_fee_s_amt 	: "+t_fee_s_amt+"<br><br>");
			out.println("t_fee_v_amt 	: "+t_fee_v_amt+"<br><br>");
			
		}

		
		
		//1ȸ�� ���Ұ�� Ȯ��----------------------------------------------------------------------
		if(!AddUtil.replace(r_use_e_dt,"-","").equals(AddUtil.replace(f_use_e_dt,"-","")) && fee_pay_tm+max_fee_tm >0){//1ȸ�� ���������ϰ� ���������� ��
			//�ϼ����ϱ�
			use_days 		= AddUtil.parseInt(rs_db.getDay(f_use_s_dt, f_use_e_dt));
			//20170421 ���غ��� (��)�뿩�Ⱓ 2017-04-18 ~ 2020-04-18
			if(rent_st.equals("1") && (cont.getCar_st().equals("1") || cont.getCar_st().equals("3") || cont.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(f_fee.getRent_start_dt(),"-","")) >= 20170421){
				use_days 		= AddUtil.parseInt(rs_db.getDay2(f_use_s_dt, f_use_e_dt));
			}
			//���ұݾװ���ϱ�		
			//fee_fst_s_amt 	= (AddUtil.parseDigit(rtn_fee_s_amt[s]) * u_mon) + (AddUtil.parseDigit(rtn_fee_s_amt[s]) * u_day / 30);
			//fee_fst_v_amt 	= fee_fst_s_amt*10/100;
			fee_fst_amt 			= AddUtil.parseDigit(rtn_fee_amt[s]) * use_days / 30;
			fee_fst_s_amt     = af_db.getSupAmt(fee_fst_amt);
			fee_fst_v_amt 		= fee_fst_amt-fee_fst_s_amt;
			//00����00�Ϸ� ���
			
			f_etc							= "���Ұ�곻��:"+AddUtil.parseDigit(rtn_fee_amt[s])+"��(���뿩��VAT����)/30*"+use_days+"��";
			
			out.println("======1ȸ�� ���Ұ�� Ȯ��======="+"<br>");		
			out.println("r_use_e_dt 	: "+r_use_e_dt+"<br>");
			out.println("f_use_e_dt 	: "+f_use_e_dt+"<br>");
			out.println("ȸ��        	: "+fee_pay_tm+max_fee_tm+"<br>");
			
		}else{
			fee_fst_s_amt 		= AddUtil.parseDigit(rtn_fee_s_amt[s]);
			fee_fst_v_amt 		= AddUtil.parseDigit(rtn_fee_v_amt[s]);
			
			if(mon_st == 12){
				fee_fst_s_amt 		= AddUtil.parseDigit(rtn_fee_s_amt[s])*12;
				fee_fst_v_amt 		= AddUtil.parseDigit(rtn_fee_v_amt[s])*12;				
			}
		}
		
		//����Ʈ �Ѿ�
		if(cont.getCar_st().equals("4") && fee_rm.getF_paid_way().equals("2")){
			fee_fst_s_amt = AddUtil.parseDigit(String.valueOf(v_f_rent_tot_amt/1.1));		
			fee_fst_v_amt = v_f_rent_tot_amt-fee_fst_s_amt;
		}else if(cont.getCar_st().equals("4") && fee_rm.getF_paid_way().equals("1")){
			fee_fst_s_amt = fees.getFee_s_amt();		
			fee_fst_v_amt = fees.getFee_v_amt();	
			if(fee_rm.getCons1_s_amt()>0){
				fee_fst_s_amt = fee_fst_s_amt+fee_rm.getCons1_s_amt();		
				fee_fst_v_amt = fee_fst_v_amt+fee_rm.getCons1_v_amt();					
			}
			if(fee_rm.getF_paid_way2().equals("1") && fee_rm.getCons2_s_amt()>0){//����������
				fee_fst_s_amt = fee_fst_s_amt+fee_rm.getCons2_s_amt();		
				fee_fst_v_amt = fee_fst_v_amt+fee_rm.getCons2_v_amt();					
				
			}
		}


		
		if(admin_yn.equals("Y")){	
			out.println("======1ȸ�� ���======="+"<br>");
			out.println("1ȸ�� ���� ���Ⱓ : "+f_use_s_dt+" "+f_use_e_dt+"<br>");
			out.println("1ȸ�� ���� ���Ⱓ : "+f_use_s_dt+" "+r_use_e_dt+"<br>");
			out.println("1ȸ�� ����ϼ� 	: "+use_days+"<br>");
			out.println("���뿩��(���ް�) 	: "+rtn_fee_s_amt[s]+"<br>");
			out.println("���뿩��(�ΰ���) 	: "+rtn_fee_v_amt[s]+"<br>");
			out.println("���Ұ��(���ް�) 	: "+fee_fst_s_amt+"<br>");
			out.println("���Ұ��(�ΰ���) 	: "+fee_fst_v_amt+"<br>");
			out.println("��ȸ�� 		: "+(fee_pay_tm+max_fee_tm)+"<br>");
			out.println("�뿩�Ϸù�ȣ 	: "+rent_st+"<br><br>");
			out.println("======������ ����======="+"<br>");			
		}


		count3 = 0;
		count1 = 0;
		
		
		if(fee_fst_s_amt >0){
		
		
			//������ ����----------------------------------------------------------------------
		
			for(int i = max_fee_tm ; i < fee_pay_tm+max_fee_tm ; i++){
			
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id		(m_id);
				fee_scd.setRent_l_cd			(l_cd);
				fee_scd.setFee_tm					(String.valueOf(i+1));
			
				if(rent_st.equals("")){
					fee_scd.setRent_st				("1");					//�����������
					fee_scd.setTm_st2				("2");					//2-�������
					fee_scd.setTaecha_no			(taecha_no);			//������� ������ȣ
				}else{
					fee_scd.setRent_st			(rent_st);				//����/����
					fee_scd.setTm_st2				("0");					//0-�Ϲݴ뿩�� (1-ȸ������)
				}
			
				fee_scd.setRent_seq				(String.valueOf(s+1));			//����û���Ϸù�ȣ
			
				if(s > 0 && rtn_type[s].equals("4")){
					fee_scd.setTm_st2				("4");					//4-�����ݱչ������
				}
			
			
				if(fee_scd.getRent_seq().equals("")){
					fee_scd.setRent_seq("1");
				}
			
				fee_scd.setTm_st1					("0");					//0-���뿩�� (1~�ܾ�)
				fee_scd.setRc_yn					("0");					//0-�̼���
				fee_scd.setUpdate_id					(user_id);
				fee_scd.setTae_no					(tae_no);
			
			
				//1ȸ��---------------------------------------------------------------------------------------------
				if(i == max_fee_tm){
			
					fee_scd.setUse_s_dt				(f_use_s_dt);				//1ȸ�� ���Ⱓ ������
					fee_scd.setUse_e_dt				(f_use_e_dt);				//1ȸ�� ���Ⱓ ������
					fee_scd.setFee_est_dt				(fee_fst_dt);				//1ȸ�� ������
				
					if(rtn_size>1){//����û���� �������
						if(rtn_size==2 && s==0){
							fee_scd.setFee_s_amt			(f_fee_s_amt);				//1ȸ�� �뿩��
							fee_scd.setFee_v_amt			(f_fee_v_amt);				//1ȸ�� �뿩��
							fee_scd.setEtc						(etc);
						}else{				
							fee_scd.setFee_s_amt			(fee_fst_s_amt);			//1ȸ�� �뿩��
							fee_scd.setFee_v_amt			(fee_fst_v_amt);			//1ȸ�� �뿩��
							fee_scd.setEtc						(f_etc);
						}
						if(s > 0 && rtn_type[s].equals("4") && f_rtn2_fee_s_amt >0){
							//���Ȱ�
							fee_scd.setFee_s_amt		(f_rtn2_fee_s_amt);		//1ȸ�� �뿩��
							fee_scd.setFee_v_amt		(f_rtn2_fee_v_amt);		//1ȸ�� �뿩��
							fee_scd.setEtc					(etc2);
						}
					}else{//���Ȱ�
						fee_scd.setFee_s_amt			(f_fee_s_amt);				//1ȸ�� �뿩��
						fee_scd.setFee_v_amt			(f_fee_v_amt);				//1ȸ�� �뿩��
						fee_scd.setEtc						(etc);
					}
				
					//����Ʈ �Ѿ�
					if(cont.getCar_st().equals("4")){
						fee_scd.setFee_s_amt			(fee_fst_s_amt);				//1ȸ�� �뿩��
						fee_scd.setFee_v_amt			(fee_fst_v_amt);				//1ȸ�� �뿩��					
					}
		
				
					req_fst_dt = c_db.minusDay(fee_fst_dt, leave_day);
				
					if(!f_req_dt.equals("")){
						req_fst_dt = f_req_dt;
					}
				
					if(admin_yn.equals("Y")){	
						out.println("1ȸ��--------------"+"<br>");
						out.println("use_s_dt	="+fee_scd.getUse_s_dt()+"<br>");
						out.println("use_e_dt	="+fee_scd.getUse_e_dt()+"<br>");
						out.println("fee_s_amt	="+fee_scd.getFee_s_amt()+"<br>");
						out.println("fee_v_amt 	="+fee_scd.getFee_v_amt()+"<br>");
						out.println("req_fst_dt	="+req_fst_dt+"<br>");									
					}
				
				//2ȸ������----------------------------------------------------------------------------------------
				}else{
				
					//2ȸ�� �Ⱓ�������� ��ȸ�� �������� �Ѵ�.
					fee_scd.setUse_s_dt				(c_db.addDay(r_use_end_dt, 1));				
					fee_scd.setUse_e_dt				(c_db.addMonth(f_use_e_dt, count1));
				
					if(mon_st == 12){
						fee_scd.setUse_e_dt			(c_db.addMonth(f_use_e_dt, count1*12));
					}
				
				
					//������ȸ���̸�
					if(i == (fee_pay_tm+max_fee_tm-1)){
				
						//���������ϰ� ������������ ���Ͽ� ���Ұ���ؾ���.
						String r_end_dt 	= AddUtil.replace(use_e_dt,"-","");
						String i_end_dt 	= AddUtil.replace(fee_scd.getUse_e_dt(),"-","");
						
						//�������� 1ȸ�������϶�
						if(idx == 1 && rent_st.equals("") && fee_pay_tm == 1){	
							r_end_dt	= f_use_end_dt;
						}
						
						System.out.println("�����ٻ���(������ȸ��)--------------");
						System.out.println("rent_end_dt	="+rent_end_dt);
						System.out.println("use_e_dt	="+use_e_dt);
						System.out.println("f_use_end_dt="+f_use_end_dt);
						System.out.println("���������� r_end_dt	="+r_end_dt);
						System.out.println("���������� i_end_dt	="+i_end_dt);
					
										
						//���Ұ��
						if(!AddUtil.replace(rent_end_dt,"-","").equals(AddUtil.replace(f_use_end_dt,"-","")) && !AddUtil.replace(r_end_dt,"-","").equals(AddUtil.replace(i_end_dt,"-",""))){
					
							fee_scd.setUse_e_dt		(r_end_dt);
						
							fee_scd.setFee_est_dt		(c_db.addMonth(fee_fst_dt, count1));
							if(mon_st == 12){
								fee_scd.setFee_est_dt	(c_db.addMonth(fee_fst_dt, count1*12));
							}
							if(AddUtil.parseInt(r_end_dt) < AddUtil.parseInt(fee_scd.getFee_est_dt())){
								fee_scd.setFee_est_dt	(r_end_dt);
							}
						
							//���ұݾװ���ϱ�
							int l_use_days = AddUtil.parseInt(rs_db.getDay(fee_scd.getUse_s_dt(), fee_scd.getUse_e_dt()));
						
						
							fee_scd.setFee_s_amt		(t_fee_s_amt-r_t_fee_s_amt);
							fee_scd.setFee_v_amt		(t_fee_v_amt-r_t_fee_v_amt);
						
							l_etc = "��곻��:"+fee_amt+"��(���뿩��VAT����)*"+o_tot_mon+"�������� ���������հ踦 �� ������ �ݾ�";
						
							if(fee_scd.getTm_st2().equals("4")){
								l_etc = "��곻��:"+(rtn_fee_amt[s])+"��(�����뿩��VAT����)*"+o_tot_mon+"�������� ���������հ踦 �� ������ �ݾ�";
							}

							fee_scd.setEtc					(l_etc);
						
						
							/*
							System.out.println("======������ ȸ�� ���Ұ��======="+"<br>");
							System.out.println("1ȸ�� ����ϼ� : "+l_use_days+"<br>");
							System.out.println("���Ұ��(��) : "+fee_scd.getFee_s_amt()+"<br>");
							System.out.println("���Ұ��(��) : "+fee_scd.getFee_v_amt()+"<br><br>");
							*/
						
						//��������
						}else{
							fee_scd.setUse_e_dt			(r_end_dt);
							fee_scd.setFee_est_dt		(c_db.addMonth(fee_fst_dt, count1));
							fee_scd.setFee_s_amt		(AddUtil.parseDigit(rtn_fee_s_amt[s]));		// 2ȸ�����ʹ� ���뿩��� ����
							fee_scd.setFee_v_amt		(AddUtil.parseDigit(rtn_fee_v_amt[s]));
						
							if(mon_st == 12){
								fee_scd.setFee_est_dt	(c_db.addMonth(fee_fst_dt, count1*12));
								fee_scd.setFee_s_amt	(AddUtil.parseDigit(rtn_fee_s_amt[s])*12);		// 2ȸ�����ʹ� ���뿩��� ����
								fee_scd.setFee_v_amt	(AddUtil.parseDigit(rtn_fee_v_amt[s])*12);							
							}
						}
					
					
						//����Ʈ �����������
						if(cont.getCar_st().equals("4") && fee_rm.getF_paid_way2().equals("2") && fee_rm.getCons2_s_amt() >0){
							fee_scd.setFee_s_amt		(fee_scd.getFee_s_amt()+fee_rm.getCons2_s_amt());	
							fee_scd.setFee_v_amt		(fee_scd.getFee_v_amt()+fee_rm.getCons2_v_amt());	
						}
					
					}else{
							fee_scd.setFee_est_dt		(c_db.addMonth(fee_fst_dt, count1));
							fee_scd.setFee_s_amt		(AddUtil.parseDigit(rtn_fee_s_amt[s]));		// 2ȸ�����ʹ� ���뿩��� ����
							fee_scd.setFee_v_amt		(AddUtil.parseDigit(rtn_fee_v_amt[s]));
							
							if(mon_st == 12){
								fee_scd.setFee_est_dt	(c_db.addMonth(fee_fst_dt, count1*12));
								fee_scd.setFee_s_amt	(AddUtil.parseDigit(rtn_fee_s_amt[s])*12);		// 2ȸ�����ʹ� ���뿩��� ����
								fee_scd.setFee_v_amt	(AddUtil.parseDigit(rtn_fee_v_amt[s])*12);							
							}						
						
						String s_cng_dt 	= AddUtil.replace(fee_scd.getFee_est_dt(),"-",""); 
						int i_cng_yy 		= AddUtil.parseInt(s_cng_dt.substring(0,4));
						int i_cng_mm 		= AddUtil.parseInt(s_cng_dt.substring(4,6));
						int i_cng_dd 		= AddUtil.parseInt(s_cng_dt.substring(6,8));
						int i_tax_dd 		= AddUtil.parseInt(AddUtil.replace(fee_fst_dt,"-","").substring(6,8));
						int i_max_dd 		= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
					
					
						if(fee.getFee_est_day().equals("99")){//����						
							fee_scd.setFee_est_dt			(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
						}else{
							if(AddUtil.parseInt(fee.getFee_est_day()) < i_cng_dd ){
								fee_scd.setFee_est_dt		(s_cng_dt.substring(0,6)+""+AddUtil.addZero(fee.getFee_est_day()));	
							}
						}	
												
					}
				
					count3++;
				


				}
			
				fee_scd.setTax_out_dt					(fee_scd.getFee_est_dt());
				fee_scd.setR_fee_est_dt					(af_db.getValidDt(fee_scd.getFee_est_dt()));
				fee_scd.setReq_dt					(c_db.addMonth(req_fst_dt, count1));
				if(mon_st == 12){				
					fee_scd.setReq_dt				(c_db.addMonth(req_fst_dt, count1*12));
				}
				fee_scd.setR_req_dt					(af_db.getValidDt(fee_scd.getReq_dt()));
				
				if(AddUtil.parseInt(AddUtil.replace(fee_scd.getTax_out_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(fee_scd.getR_req_dt(),"-",""))){
					fee_scd.setR_req_dt				(fee_scd.getTax_out_dt());
				}
			
			
				int max_tm_add_l_use_days = AddUtil.parseInt(rs_db.getDay(fee_scd.getUse_s_dt(), fee_scd.getUse_e_dt()));
			
				//������ȸ���̸�
				if(i > max_fee_tm && i == (fee_pay_tm+max_fee_tm-1)){
			
					//20110215 �뿩������(���������Ⱓ������)���� �Աݿ������� �� Ŭ���� ����.   use_e_dt < fee_est_dt
					ContFeeBean m_fee = a_db.getContFeeNew(fee_scd.getRent_mng_id(), fee_scd.getRent_l_cd(), fee_scd.getRent_st());
				
					if(m_fee.getIfee_s_amt()==0 && AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-",""))){
						fee_scd.setFee_est_dt			(fee_scd.getUse_e_dt());
						fee_scd.setTax_out_dt			(fee_scd.getFee_est_dt());
						fee_scd.setR_fee_est_dt			(af_db.getValidDt(fee_scd.getFee_est_dt()));
					}
				
					//20121101 �뿩������(���������Ⱓ������)���� �Աݿ������� �� �������� ����.   use_e_dt > fee_est_dt
					if(max_tm_add_l_use_days <= 40 ){
						if(m_fee.getIfee_s_amt()==0 && AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-",""))){
							fee_scd.setFee_est_dt			(fee_scd.getUse_e_dt());
							fee_scd.setTax_out_dt			(fee_scd.getFee_est_dt());
							fee_scd.setR_fee_est_dt			(af_db.getValidDt(fee_scd.getFee_est_dt()));
						}
					}
				
					//if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){				
						if(max_tm_add_l_use_days > 15 ){								
							fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -15));
						}else if(max_tm_add_l_use_days < 15 && max_tm_add_l_use_days > 10 ){		
							fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -10));
						}else{
							fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -5));
						}
						fee_scd.setR_req_dt			(fee_scd.getReq_dt());
					//}
				
					System.out.println("�����ٻ���(������ȸ��)--------------");
					System.out.println("rent_l_cd="+fee_scd.getRent_l_cd());				
					System.out.println("m_fee.getIfee_s_amt()	= "+m_fee.getIfee_s_amt());
					System.out.println("fee_scd.getFee_s_amt()	= "+fee_scd.getFee_s_amt());
					System.out.println("fee_scd.getUse_e_dt()	= "+fee_scd.getUse_e_dt());
					System.out.println("fee_scd.getFee_est_dt()	= "+fee_scd.getFee_est_dt());
					System.out.println("fee_scd.getFee_tm()		= "+fee_scd.getFee_tm());
					System.out.println("------------------------------------");
				
				}
			
			
				//�����ݸſ��յ���ེ������ ��� ������ �Աݿ��� �ݿ�
				if(fee_scd.getTm_st2().equals("4") && a_db.getPpPaySt(fee_scd.getRent_mng_id(), fee_scd.getRent_l_cd(), fee_scd.getRent_st(), "1").equals("�Ա�")){
					ExtScdBean ext = ae_db.getAGrtScd(fee_scd.getRent_mng_id(), fee_scd.getRent_l_cd(), fee_scd.getRent_st(), "1", "1");//������
					fee_scd.setRc_yn			("1");
					fee_scd.setRc_dt			(ext.getExt_pay_dt());
					fee_scd.setRc_amt			(fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt());
				}
			
			
			
				if(!af_db.insertFeeScd(fee_scd)) flag4 += 1;
			
			
				r_t_fee_s_amt 		= r_t_fee_s_amt + fee_scd.getFee_s_amt();
				r_t_fee_v_amt 		= r_t_fee_v_amt + fee_scd.getFee_v_amt();
			
				if(s > 0 && rtn_type[s].equals("4")){
			
				}else{
					totoal_fee_s_amt 	= totoal_fee_s_amt + (fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt());
				}
			
			
				int add_fee_s_amt = 0;
				int add_fee_v_amt = 0;

			
				//1ȸ��---------------------------------------------------------------------------------------------
				if(i == max_fee_tm){
					cms_start_dt 	= fee_scd.getFee_est_dt();
				}
				//������ȸ���̸�
				if(i == (fee_pay_tm+max_fee_tm-1)){
					cms_end_dt 	= fee_scd.getFee_est_dt();
				}
			
			
			

				//������ȸ�� ���Ⱓ�� 1���̻��϶� ������
				if(mon_st == 1 && i == (fee_pay_tm+max_fee_tm-1) && max_tm_add_l_use_days > 40 ){
			
					System.out.println("�����ٻ���(������ȸ�� ������ ����)--------------");
					System.out.println("rtn_fee_s_amt[s]="+rtn_fee_s_amt[s]);				
					System.out.println("fee_scd.getFee_s_amt()	= "+fee_scd.getFee_s_amt());
					System.out.println("fee_scd.getFee_s_amt()	= "+fee_scd.getFee_s_amt());
					System.out.println("fee_scd.getUse_e_dt()	= "+fee_scd.getUse_e_dt());
					System.out.println("fee_scd.getFee_est_dt()	= "+fee_scd.getFee_est_dt());
					System.out.println("fee_scd.getFee_tm()		= "+fee_scd.getFee_tm());
					System.out.println("------------------------------------");
			
			
					if(AddUtil.parseDigit(rtn_fee_s_amt[s]) < fee_scd.getFee_s_amt()){
				
						ContFeeBean m_fee = a_db.getContFeeNew(fee_scd.getRent_mng_id(), fee_scd.getRent_l_cd(), fee_scd.getRent_st());
					
						if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-",""))){ //m_fee.getIfee_s_amt()==0 && 
										
							FeeScdBean add_fee_scd = fee_scd;
																		
												
							add_fee_s_amt = fee_scd.getFee_s_amt()-fee.getFee_s_amt();
							add_fee_v_amt = fee_scd.getFee_v_amt()-fee.getFee_v_amt();
						
							//������ ���
							if(s > 0){
								add_fee_s_amt = fee_scd.getFee_s_amt()-AddUtil.parseDigit(rtn_fee_s_amt[s]);
								add_fee_v_amt = fee_scd.getFee_v_amt()-AddUtil.parseDigit(rtn_fee_v_amt[s]);							
							}
						
						
							//������ȸ�������� ��������-----------------------------------------------------
						
							//�Ⱓ�������� ��ȸ�� �������� �Ѵ�.
							fee_scd.setUse_s_dt			(c_db.addDay(r_use_end_dt, 1));
							fee_scd.setUse_e_dt			(c_db.addMonth(f_use_e_dt, count1));
							fee_scd.setFee_s_amt			(AddUtil.parseDigit(rtn_fee_s_amt[s]));
							fee_scd.setFee_v_amt			(AddUtil.parseDigit(rtn_fee_v_amt[s]));
												
							String s_cng_dt 	= AddUtil.replace(fee_scd.getFee_est_dt(),"-",""); 
							int i_cng_yy 		= AddUtil.parseInt(s_cng_dt.substring(0,4));
							int i_cng_mm 		= AddUtil.parseInt(s_cng_dt.substring(4,6));
							int i_cng_dd 		= AddUtil.parseInt(s_cng_dt.substring(6,8));
							int i_tax_dd 		= AddUtil.parseInt(AddUtil.replace(fee_fst_dt,"-","").substring(6,8));
							int i_max_dd 		= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
										
							if(fee.getFee_est_day().equals("99")){//����						
								fee_scd.setFee_est_dt			(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
							}else{
								if(AddUtil.parseInt(fee.getFee_est_day()) < i_cng_dd ){
									fee_scd.setFee_est_dt		(s_cng_dt.substring(0,6)+""+AddUtil.addZero(fee.getFee_est_day()));	
								}
							}	
							fee_scd.setR_fee_est_dt			(af_db.getValidDt(fee_scd.getFee_est_dt()));
							fee_scd.setTax_out_dt				(fee_scd.getFee_est_dt());
							fee_scd.setReq_dt						(c_db.addMonth(req_fst_dt, count1));						
							fee_scd.setR_req_dt					(fee_scd.getReq_dt());
							fee_scd.setEtc							("");
						
							//�����ݸſ��յ���ེ������ ��� ������ �Աݿ��� �ݿ�
							if(fee_scd.getTm_st2().equals("4") && a_db.getPpPaySt(fee_scd.getRent_mng_id(), fee_scd.getRent_l_cd(), fee_scd.getRent_st(), "1").equals("�Ա�")){
								ExtScdBean ext2 = ae_db.getAGrtScd(fee_scd.getRent_mng_id(), fee_scd.getRent_l_cd(), fee_scd.getRent_st(), "1", "1");//������
								fee_scd.setRc_yn			("1");
								fee_scd.setRc_dt			(ext2.getExt_pay_dt());
								fee_scd.setRc_amt			(fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt());
							}
						
							if(!af_db.updateFeeScd(fee_scd)) flag4 += 1;
						
						
							System.out.println("������ȸ�� ���Ⱓ�� 1���̻��϶� ������-----");
							System.out.println("������ȸ�������� ��������");
							System.out.println("fee_scd.getFee_tm()		= "+fee_scd.getFee_tm());
							System.out.println("fee_scd.getFee_s_amt()	= "+fee_scd.getFee_s_amt());
						
										
											
							//������ȸ�� 1���̻�� �߰�����-----------------------------------------------------
						
							add_fee_scd.setFee_tm			(String.valueOf(i+2));
							add_fee_scd.setUse_s_dt			(c_db.addDay(fee_scd.getUse_e_dt(), 1));
							add_fee_scd.setUse_e_dt			(use_e_dt);
												
							add_fee_scd.setFee_est_dt		(add_fee_scd.getUse_e_dt());
							add_fee_scd.setTax_out_dt		(add_fee_scd.getFee_est_dt());
							add_fee_scd.setR_fee_est_dt		(af_db.getValidDt(add_fee_scd.getFee_est_dt()));
							add_fee_scd.setFee_s_amt		(add_fee_s_amt);
							add_fee_scd.setFee_v_amt		(add_fee_v_amt);
						
							add_fee_scd.setReq_dt			(c_db.addMonth(req_fst_dt, count1+1));
							add_fee_scd.setR_req_dt			(af_db.getValidDt(add_fee_scd.getReq_dt()));
						
							max_tm_add_l_use_days = AddUtil.parseInt(rs_db.getDay(add_fee_scd.getUse_s_dt(), add_fee_scd.getUse_e_dt()));
						
							//if(AddUtil.parseInt(AddUtil.replace(add_fee_scd.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(add_fee_scd.getReq_dt(),"-",""))){
								if(max_tm_add_l_use_days > 15 ){								
									add_fee_scd.setReq_dt		(c_db.addDay(add_fee_scd.getUse_e_dt(), -15));
								}else if(max_tm_add_l_use_days < 15 && max_tm_add_l_use_days > 10 ){		
									add_fee_scd.setReq_dt		(c_db.addDay(add_fee_scd.getUse_e_dt(), -10));
								}else{
									add_fee_scd.setReq_dt		(c_db.addDay(add_fee_scd.getUse_e_dt(), -5));
								}							
								add_fee_scd.setR_req_dt		(add_fee_scd.getReq_dt());
							//}
						
							add_fee_scd.setEtc					(l_etc);
						
							//�����ݸſ��յ���ེ������ ��� ������ �Աݿ��� �ݿ�
							if(add_fee_scd.getTm_st2().equals("4") && a_db.getPpPaySt(add_fee_scd.getRent_mng_id(), add_fee_scd.getRent_l_cd(), add_fee_scd.getRent_st(), "1").equals("�Ա�")){
								ExtScdBean ext2 = ae_db.getAGrtScd(add_fee_scd.getRent_mng_id(), add_fee_scd.getRent_l_cd(), add_fee_scd.getRent_st(), "1", "1");//������
								add_fee_scd.setRc_yn			("1");
								add_fee_scd.setRc_dt			(ext2.getExt_pay_dt());
								add_fee_scd.setRc_amt			(add_fee_scd.getFee_s_amt()+add_fee_scd.getFee_v_amt());
							}
						
							if(!af_db.insertFeeScd(add_fee_scd)) flag4 += 1;
						
						
							cms_end_dt 	= add_fee_scd.getFee_est_dt();

							System.out.println("������ȸ�� 1���̻�� �߰�����");
							System.out.println("add_fee_scd.getFee_tm()	= "+add_fee_scd.getFee_tm());
							System.out.println("add_fee_scd.getFee_s_amt()	= "+add_fee_scd.getFee_s_amt());						
							System.out.println("---------------------------------------------");
						
												
						}
				
					}
			
				}

			
									
				r_use_end_dt 		= fee_scd.getUse_e_dt();
			
			
			
				//System.out.println(fee_scd.getFee_tm()+"ȸ��, ���������� : "+fee_scd.getUse_e_dt()+"<br>");
			
				count1++;
			
			
			
			}
		}
	}
	
	
	
	String total_fee_s_amt_chk = "";
	
	
	if(fees.getFee_s_amt() > 0 ){
	
		//�ѱݾ�Ȯ��
		if(!cont.getCar_st().equals("4") && idx == 2 && !rent_st.equals("")){//�ű�+���� �뿩��		
		
			int o_total_fee_s_amt = (fee.getFee_s_amt()+fee.getFee_v_amt())*AddUtil.parseInt(fee.getCon_mon())-(fee.getIfee_s_amt()+fee.getIfee_v_amt());
		
			//if(o_total_fee_s_amt==totoal_fee_s_amt+add_fee_s_amt+add_fee_s_amt){
			//	totoal_fee_s_amt = totoal_fee_s_amt+add_fee_s_amt+add_fee_s_amt;
			//}
	
			if(o_total_fee_s_amt > totoal_fee_s_amt || o_total_fee_s_amt < totoal_fee_s_amt){
				total_fee_s_amt_chk = "N";
			
				System.out.println("�����ٻ���(�ѱݾ�Ȯ��)--------------");
				System.out.println("rent_l_cd		="+l_cd);
				System.out.println("o_total_fee_s_amt	="+o_total_fee_s_amt);
				System.out.println("totoal_fee_s_amt	="+totoal_fee_s_amt);
			}
		}
	
	
		//�ڵ���ü �������� ����
		if(!cms.getRent_mng_id().equals("") && !cms.getCms_acc_no().equals("") && idx == 2 && !rent_st.equals("")){//�ű�+���� �뿩��
	
			//�űԽ������϶�
			if(rent_st.equals("1")){
		
				//��������������
				if(max_fee_tm == 0){
					cms.setCms_start_dt	(cms_start_dt);	
					//[20130930]�뿩�ὺ���� ������ �ڵ���ü ��û���� �־���
					cms.setApp_dt(AddUtil.getDate());
				}
			
			
			
				cms.setCms_end_dt	(cms_end_dt);


			//���彺�����϶�	
			}else{
				cms.setCms_end_dt	(cms_end_dt);
			}		
				
		
			//[20120904]�������ڵ� ����	: 20121223 ������ġ����		
			cms.setCms_day(fee.getFee_est_day());
		
		
			if(cms.getApp_dt().equals("")){
				cms.setCms_start_dt	(cms_start_dt);	
				cms.setApp_dt		(AddUtil.getDate());
			}
		
			if(cms.getCms_day().equals("99")){			
				cms.setCms_day("31");
			}
		
		
			cms.setUpdate_id	(user_id);
			c_flag3 = a_db.updateContCmsMng(cms);			
		
		}else{
			//���������϶�..
			if(!cms.getRent_mng_id().equals("") && !cms.getCms_acc_no().equals("") && idx == 1 && rent_st.equals("")){
		
				cms.setCms_start_dt	(cms_start_dt);
				//[20130930]�뿩�ὺ���� ������ �ڵ���ü ��û���� �־���
				cms.setApp_dt(AddUtil.getDate());
			
				//[20120904]�������ڵ� ����	: 20121223 ������ġ����		
				cms.setCms_day(fee.getFee_est_day());
			
				if(cms.getCms_day().equals("99")){
					cms.setCms_day("31");
				}
				cms.setUpdate_id	(user_id);
				c_flag3 = a_db.updateContCmsMng(cms);			
			}
		}
	}
	
	
	//������ ��������� ���� ���� �߼��Ѵ�. : 20100716	
	//��� ����� ���� ���� ����
	
	Hashtable sms = c_db.getDmailSms(m_id, l_cd, "1");
	
	Hashtable cont_view = a_db.getContViewCase(m_id, l_cd);
	
	//cont
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(m_id, l_cd);
	
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	UsersBean target_bean = new UsersBean();
	UsersBean target_bean2 = new UsersBean();
	target_bean 	= umd.getUsersBean(base.getBus_id2());
	target_bean2 	= umd.getUsersBean(base.getBus_id());
	

	if(!l_cd.equals("S214KK7R00045") && !base.getBus_id2().equals("000026") && !base.getBus_id2().equals("000005") && !base.getBus_id2().equals("000144")){//��������,��������,ä�Ǵ��

		
		if(!base.getCar_mng_id().equals("")){
			cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		}
	
		String s_destphone = String.valueOf(sms.get("TEL"))==null?"":String.valueOf(sms.get("TEL"));
		String s_destname = String.valueOf(sms.get("NM"))==null?"":String.valueOf(sms.get("NM"));
	
		if(s_destphone.equals("null")) 	s_destphone = "";
		if(s_destname.equals("null")) 	s_destname = "";
	
		String ins_name = "";
		ins_name = ai_db.getInsComNm(base.getCar_mng_id() );
	
		String ins_tel ="";
		if ( ins_name.equals("�Ｚȭ��") ) {
	    		ins_tel = " 1588-5114 ";
		} else if  ( ins_name.equals("����ȭ��") || ins_name.equals("DB���غ���")) {
	    		ins_tel = " 1588-0100 ";
	    	} else if  ( ins_name.equals("����ī��������") ) {	
	    		ins_tel = " 1661-7977 ";
		}
	
		String cont_sms 	= String.valueOf(cont_view.get("FIRM_NM")) +" ���� �ȳ��Ͻʴϱ�, �Ƹ���ī�Դϴ�.\n\n�뿩�Ͻ� "+ cr_bean.getCar_no() + "������ �뿩��� �������� " + String.valueOf(cont_view.get("RENT_START_DT")) + " �̸�, ���� �ڵ������� ����ڴ� " + target_bean.getUser_nm() + ", "+ target_bean.getUser_m_tel() + " �Դϴ�.\n\n(��)�Ƹ���ī "; 
	
		String cont_sms1 	= String.valueOf(cont_view.get("FIRM_NM")) +" ���� �ȳ��Ͻʴϱ�, �Ƹ���ī�Դϴ�.\n\n������ �뿩 �ڵ��� ������ "+ ins_name + " "  + ins_tel + " �̸�,  ����⵿ ���񽺴� ����Ÿ����⵿ 1588-6688, SK��Ʈ���� 1670-5494 �Դϴ�. ��Ÿ �̿��� �����Ͻ� ������ ���� �ڵ������� ����� " + target_bean.getUser_nm() + "("+ target_bean.getUser_m_tel() + ")�� ��� �ٶ��ϴ�.\n\n(��)�Ƹ���ī "; 
	
		if(!s_destphone.equals("")){	
	
			//201411 �뿩������ +3�Ͽ� �����°����� �����Ѵ�.
			String msg_type 	= "5";
			String msg_subject 	= "�뿩���þȳ�";
			String req_time 	= AddUtil.getDate(4);
			String rqdate 		= "";
			req_time 		= rs_db.addDay(req_time, 3);
			req_time 		= AddUtil.replace(af_db.getValidDt(req_time),"-","")+"100101";
							
			msg_subject 	= "����� ����⵿�ȳ�";
			//������ ����⵿ ���ڸ޼���
			
						
			//�˸��� acar0044 �뿩���þȳ�			
			// ���̸�
			String customer_name 	= String.valueOf(cont_view.get("FIRM_NM"));
			// ������ȣ
			String car_num 				= cr_bean.getCar_no();
			// ��� ������
			String contract_s_date= String.valueOf(cont_view.get("RENT_START_DT"));
			// ����� �̸�
			String manager_name 	= target_bean.getUser_nm();
			// ����� ��ȭ
			String manager_phone 	= target_bean.getUser_m_tel();
			
			// ����� �̸�(����)
			String bus_manager_name = target_bean2.getUser_nm();
			// ����� ��ȭ(����)
			String bus_manager_phone = target_bean2.getUser_m_tel();
			
			// ���ռ��� �ȳ��� url
			String full_url = "http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id=" + m_id + "&l_cd=" + l_cd + "&rent_st=";			
			String schedule_url = ShortenUrlGoogle.getShortenUrl(full_url);
			
			String car_etc1 = l_cd;
			String car_etc2 = user_id;
			//acar0044 -> acar0081 (��������) -> acar0115 (��������) -> acar0141 (��������) -> acar0211 (��������)
			List<String> fieldList = Arrays.asList(customer_name, car_num, contract_s_date, bus_manager_name, bus_manager_phone, manager_name, manager_phone, schedule_url);
			at_db.sendMessageReserve("acar0211", fieldList, s_destphone, manager_phone, req_time , car_etc1,  base.getBus_id2());
			//at_db.sendMessageReserve("acar0141", fieldList, s_destphone,  "02-392-4242", req_time , car_etc1,  car_etc2);

			//�˸��� acar0046 ����� ����⵿�ȳ�
			// ���̸�
			String customer_name2 = String.valueOf(cont_view.get("FIRM_NM"));
			// ����� �̸�
			String insurance_name2= ins_name + " (" + ins_tel + ")";
			// ����� �̸�
			String manager_name2 	= target_bean.getUser_nm();
			// ����� ����ó
			String manager_phone2 = "("+ target_bean.getUser_m_tel() + ")";
			String callbackNum = target_bean.getUser_m_tel();
			// ����⵿
			String sos_service_info = "����Ÿ�ڵ��� (1588-6688)";
			
			String marster_car_num = "1588-6688"; //������ �ڵ��� ����ó
			String sk_net_num = "1670-5494"; //sk��Ʈ���� ����ó
			
			String url_1 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_sos.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
			String sos_url = ShortenUrlGoogle.getShortenUrl(url_1);
			
			//acar0046 -> acar0092 (��������) -> acar0113 (�ִ�ī����) -> acar0156 -> acar0231 (��������)
			/* List<String> fieldList2 = Arrays.asList(customer_name2, insurance_name2, sos_service_info, manager_name2, manager_phone2);
			at_db.sendMessageReserve("acar0113", fieldList2, s_destphone, "02-392-4242", req_time , car_etc1,  car_etc2); */
			List<String> fieldList2 = Arrays.asList(customer_name2, car_num, insurance_name2, marster_car_num, sk_net_num, manager_name2, manager_phone2, sos_url);
			at_db.sendMessageReserve("acar0231", fieldList2, s_destphone, target_bean.getUser_m_tel(), req_time, car_etc1, base.getBus_id2());
			
			// ��縵ũ �ȳ��� �˸��� �߼� (�����̰� �������ϰ��)  acar0145 -> acar0164
			if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) {
				if (car.getBluelink_yn().equals("Y") && rent_st.equals("1")) {
					List<String> fieldList3 = Arrays.asList("");
					at_db.sendMessageReserve("acar0164", fieldList3, s_destphone, target_bean.getUser_m_tel(), null , car_etc1, base.getBus_id2());
				}
			}
			
		}
	}
	
	
	
	
%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
</form>
<script language='javascript'>
<%	if(flag1+flag2+flag3+flag4 > 0){%>

		alert("�������� ��ϵ��� �ʾҽ��ϴ�");		
		
<%	}else{%>	

		if('<%=total_fee_s_amt_chk%>'=='N'){
			alert("������ ���� �ѱݾ��� Ʋ���ϴ�. Ȯ���Ͻʽÿ�.");
		}
		
		alert("�������� ��ϵǾ����ϴ�");
		var fm = document.form1;
		fm.target='d_content';
		fm.action='./fee_scd_u_frame.jsp';
		fm.submit();	
		
		parent.window.close();	
		
<%	}%>
</script>