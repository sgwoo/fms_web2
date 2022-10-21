<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.coolmsg.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.car_sche.*, acar.car_register.*, acar.im_email.*, tax.*, acar.insur.*, acar.client.* "%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//����1,����0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	boolean flag12 = true;
	
	int flag = 0;
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);	
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);	
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
%>


<%
	if(cng_item.equals("client")){
		//���⺻����-----------------------------------------------------------------------------------------------
		
		String o_p_addr = base.getP_addr();
		String o_lic = base.getLic_no();
		String o_m_lic = base.getMgr_lic_no()+""+base.getMgr_lic_emp()+""+base.getMgr_lic_rel();
		
		//��,����,�����ּ�,����������
		base.setR_site			(request.getParameter("site_id")	==null?"":request.getParameter("site_id"));
		base.setP_zip				(request.getParameter("t_zip")		==null?"":request.getParameter("t_zip"));
		base.setP_addr			(request.getParameter("t_addr")		==null?"":request.getParameter("t_addr"));
		base.setTax_agnt		(request.getParameter("tax_agnt")	==null?"":request.getParameter("tax_agnt"));
		base.setLic_no			(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));	
		base.setMgr_lic_no	(request.getParameter("mgr_lic_no")==null?"":request.getParameter("mgr_lic_no"));	
		base.setMgr_lic_emp	(request.getParameter("mgr_lic_emp")==null?"":request.getParameter("mgr_lic_emp"));	
		base.setMgr_lic_rel	(request.getParameter("mgr_lic_rel")==null?"":request.getParameter("mgr_lic_rel"));	
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);
		
		
		String n_p_addr = base.getP_addr();
		String n_lic = base.getLic_no();
		String n_m_lic = base.getMgr_lic_no()+""+base.getMgr_lic_emp()+""+base.getMgr_lic_rel();
		
		//�����ּ� �����̷� ����
		if(!o_p_addr.equals(n_p_addr)){
			LcRentCngHBean lrc_bean = new LcRentCngHBean();
			lrc_bean.setRent_mng_id	(rent_mng_id);
			lrc_bean.setRent_l_cd		(rent_l_cd);
			lrc_bean.setCng_item		("p_addr");
			lrc_bean.setOld_value		(o_p_addr);
			lrc_bean.setNew_value		(n_p_addr);
			lrc_bean.setCng_cau			("�����ּ� ����");
			lrc_bean.setCng_id			(ck_acar_id);
			lrc_bean.setRent_st			(Integer.toString(fee_size));
			flag1 = a_db.updateLcRentCngH(lrc_bean);
		}
		//�����̷� ����
		if(!o_lic.equals(n_lic)){
			LcRentCngHBean lrc_bean = new LcRentCngHBean();
			lrc_bean.setRent_mng_id	(rent_mng_id);
			lrc_bean.setRent_l_cd		(rent_l_cd);
			lrc_bean.setCng_item		("lic_no");
			lrc_bean.setOld_value		(o_lic);
			lrc_bean.setNew_value		(n_lic);
			lrc_bean.setCng_cau			("�����/�� ���������ȣ ����");
			lrc_bean.setCng_id			(ck_acar_id);
			lrc_bean.setRent_st			(Integer.toString(fee_size));
			flag1 = a_db.updateLcRentCngH(lrc_bean);
			
			//������
			client.setLic_no		(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));
			flag2 = al_db.updateNewClient2(client);
		}
		//�����̷� ����
		if(!o_m_lic.equals(n_m_lic)){
			LcRentCngHBean lrc_bean = new LcRentCngHBean();
			lrc_bean.setRent_mng_id	(rent_mng_id);
			lrc_bean.setRent_l_cd		(rent_l_cd);
			lrc_bean.setCng_item		("mgr_lic_no");
			lrc_bean.setOld_value		(o_m_lic);
			lrc_bean.setNew_value		(n_m_lic);
			lrc_bean.setCng_cau			("�����̿��� ���������ȣ ����");
			lrc_bean.setCng_id			(ck_acar_id);
			lrc_bean.setRent_st			(Integer.toString(fee_size));
			flag1 = a_db.updateLcRentCngH(lrc_bean);
		}
		
		CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "�߰�������");
		mgr.setLic_no		(request.getParameter("mgr_lic_no5")	==null?"":request.getParameter("mgr_lic_no5"));
		mgr.setEtc			(request.getParameter("mgr_lic_rel5")	==null?"":request.getParameter("mgr_lic_rel5"));
		if(!mgr.getRent_l_cd().equals("")){
			//=====[CAR_MGR] update=====
			flag1 = a_db.updateCarMgrNew(mgr);
		}
		
		

%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('���⺻���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("mgr")){
		//����������-----------------------------------------------------------------------------------------------
		
		//car_mgr
		String mgr_id[] 			= request.getParameterValues("mgr_id");
		String mgr_st[] 			= request.getParameterValues("mgr_st");
		String mgr_com[] 			= request.getParameterValues("mgr_com");
		String mgr_dept[] 			= request.getParameterValues("mgr_dept");
		String mgr_nm[] 			= request.getParameterValues("mgr_nm");
		String mgr_title[] 			= request.getParameterValues("mgr_title");
		String mgr_tel[] 			= request.getParameterValues("mgr_tel");
		String mgr_m_tel[] 			= request.getParameterValues("mgr_m_tel");
		String mgr_email[] 			= request.getParameterValues("mgr_email");
		
		int mgr_size = mgr_st.length;
		
		for(int i = 0 ; i < mgr_size ; i++){
			
			CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, mgr_st[i]);
			//�ٹ�ó,�μ�,����,����,��ȭ��ȣ,�޴���,�̸���
			mgr.setMgr_nm		(mgr_nm[i]);
			mgr.setMgr_dept		(mgr_dept[i]);
			mgr.setMgr_title	(mgr_title[i]);
			mgr.setMgr_tel		(mgr_tel[i]);
			mgr.setMgr_m_tel	(mgr_m_tel[i]);
			mgr.setMgr_email	(mgr_email[i].trim());
			mgr.setCom_nm		(mgr_com[i]);
			
			if(i == 0){
				mgr.setMgr_zip		(request.getParameter("t_zip")		==null?"":request.getParameter("t_zip"));
				mgr.setMgr_addr		(request.getParameter("t_addr")		==null?"":request.getParameter("t_addr"));
			}
						
			
			if(!mgr_st[i].equals("")){
				if(!mgr.getRent_l_cd().equals("")){
					//=====[CAR_MGR] update=====
					flag1 = a_db.updateCarMgrNew(mgr);
				}else{
					mgr.setRent_mng_id	(rent_mng_id);
					mgr.setRent_l_cd	(rent_l_cd);
					mgr.setMgr_id		(mgr_id[i]);
					mgr.setMgr_st		(mgr_st[i]);
					
					//=====[CAR_MGR] update=====
					flag1 = a_db.insertCarMgr(mgr);
				}
			}
		}%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('���������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("client_guar")){
		//����Ÿ����-----------------------------------------------------------------------------------------------
		
		//���뺸������,��������,������
		cont_etc.setClient_guar_st	(request.getParameter("client_guar_st")==null?"":request.getParameter("client_guar_st"));
		cont_etc.setGuar_con		(request.getParameter("guar_con")==null?"":request.getParameter("guar_con"));
		cont_etc.setGuar_sac_id		(request.getParameter("guar_sac_id")==null?"":request.getParameter("guar_sac_id"));
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] insert=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag1 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag1 = a_db.updateContEtc(cont_etc);
		}
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('��ǥ�̻纸�� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("guar")){
		//����Ÿ����-----------------------------------------------------------------------------------------------
		
		//���뺸������,��������,������
		cont_etc.setGuar_st			(request.getParameter("guar_st")==null?"":request.getParameter("guar_st"));
		cont_etc.setGuar_con		(request.getParameter("guar_con")==null?"":request.getParameter("guar_con"));
		cont_etc.setGuar_sac_id		(request.getParameter("guar_sac_id")==null?"":request.getParameter("guar_sac_id"));
		
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] insert=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag1 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag1 = a_db.updateContEtc(cont_etc);
		}
		
		//���뺸����-----------------------------------------------------------------------------------------------
		
		//cont_gur
		String gur_id[] 	= request.getParameterValues("gur_id");
		String gur_nm[] 	= request.getParameterValues("gur_nm");
		String gur_ssn[] 	= request.getParameterValues("gur_ssn");
		String gur_tel[] 	= request.getParameterValues("gur_tel");
		String gur_rel[] 	= request.getParameterValues("gur_rel");
		String t_zip[] 		= request.getParameterValues("t_zip");
		String t_addr[] 	= request.getParameterValues("t_addr");

		int gur_size = gur_nm.length;
		
		for(int i = 0 ; i < gur_size ; i++){
		
			if(!gur_nm[i].equals("") && cont_etc.getGuar_st().equals("1")){
				ContGurBean gur = a_db.getContGur(rent_mng_id, rent_l_cd, gur_id[i]);
				//����,�ֹε�Ϲ�ȣ,�ּ�,����ó,����
				gur.setGur_nm		(gur_nm[i]);
				gur.setGur_ssn		(gur_ssn[i]);
				gur.setGur_zip		(t_zip[i]);
				gur.setGur_addr		(t_addr[i]);
				gur.setGur_tel		(gur_tel[i]);
				gur.setGur_rel		(gur_rel[i]);
				
				if(gur.getRent_l_cd().equals("")){
					gur.setRent_mng_id	(rent_mng_id);
					gur.setRent_l_cd	(rent_l_cd);
					gur.setGur_id		(gur_id[i]);
					//=====[CONT_GUR] update=====
					flag2 = a_db.insertContGur(gur);
				}else{
					//=====[CONT_GUR] update=====
					flag2 = a_db.updateContGur(gur);
				}
			}
		}%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('����Ÿ���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
<%		if(!flag2){	%>	alert('���������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>



<%
	if(cng_item.equals("car")){
	
	
	
	//�����⺻����-----------------------------------------------------------------------------------------------
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	boolean chg_van_add_opt_yn = false;
	if(!car.getVan_add_opt().equals(String.valueOf(request.getParameter("van_add_opt")))){
		chg_van_add_opt_yn = true;
	}
	
// 	car.setColo		(request.getParameter("color")			==null?"":request.getParameter("color"));
	car.setSun_per		(request.getParameter("sun_per")		==null? 0:AddUtil.parseDigit(request.getParameter("sun_per")));
	car.setLpg_yn		(request.getParameter("lpg_yn")			==null?"":request.getParameter("lpg_yn"));
	car.setLpg_setter	(request.getParameter("lpg_setter")		==null?"":request.getParameter("lpg_setter"));
	car.setLpg_kit		(request.getParameter("lpg_kit")		==null?"":request.getParameter("lpg_kit"));
	car.setLpg_price	(request.getParameter("lpg_price")		==null? 0:AddUtil.parseDigit(request.getParameter("lpg_price")));
	car.setAdd_opt		(request.getParameter("add_opt")		==null?"":request.getParameter("add_opt"));
	car.setAdd_opt_amt	(request.getParameter("add_opt_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("add_opt_amt")));
	car.setRemark		(request.getParameter("remark")			==null?"":request.getParameter("remark"));
	car.setExtra_set	(request.getParameter("extra_set")		==null?"":request.getParameter("extra_set"));
	car.setExtra_amt	(request.getParameter("extra_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("extra_amt")));
// 	car.setIn_col		(request.getParameter("in_col")			==null?"":request.getParameter("in_col"));
// 	car.setGarnish_col		(request.getParameter("garnish_col")			==null?"":request.getParameter("garnish_col"));
	car.setHipass_yn	(request.getParameter("hipass_yn")		==null?"":request.getParameter("hipass_yn"));
	car.setBluelink_yn	(request.getParameter("bluelink_yn")		==null?"":request.getParameter("bluelink_yn"));
	car.setTint_b_yn	(request.getParameter("tint_b_yn")		==null?"":request.getParameter("tint_b_yn"));
	car.setTint_s_yn	(request.getParameter("tint_s_yn")		==null?"":request.getParameter("tint_s_yn"));
	car.setTint_ps_yn	(request.getParameter("tint_ps_yn")		==null?"":request.getParameter("tint_ps_yn"));	// ��޽��� ����	2017.12.26
	car.setTint_ps_nm	(request.getParameter("tint_ps_nm")	==null?"":request.getParameter("tint_ps_nm"));	// ��޽��� ����
	car.setTint_ps_amt(request.getParameter("tint_ps_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_ps_amt")));	// ��޽��� �ݾ�
	car.setTint_n_yn	(request.getParameter("tint_n_yn")		==null?"":request.getParameter("tint_n_yn"));
	car.setTint_bn_yn	(request.getParameter("tint_bn_yn")		==null?"":request.getParameter("tint_bn_yn"));
	car.setTint_bn_nm	(request.getParameter("tint_bn_nm")		==null?"":request.getParameter("tint_bn_nm"));
	car.setTint_sn_yn		(request.getParameter("tint_sn_yn")		==null?"":request.getParameter("tint_sn_yn")); // ������� �̽ð� ����
	car.setNew_license_plate		(request.getParameter("new_license_plate")		==null ? "0":request.getParameter("new_license_plate"));	// ������ȣ�� ��û ���� ����Ʈ 0(������ȣ��)
	car.setTint_cons_yn		(request.getParameter("tint_cons_yn")		==null?"":request.getParameter("tint_cons_yn"));
	car.setTint_cons_amt	(request.getParameter("tint_cons_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_cons_amt")));
	car.setTint_eb_yn	(request.getParameter("tint_eb_yn")		==null?"":request.getParameter("tint_eb_yn"));
	car.setServ_b_yn	(request.getParameter("serv_b_yn")		==null?"":request.getParameter("serv_b_yn"));
	car.setServ_sc_yn	(request.getParameter("serv_sc_yn")		==null?"":request.getParameter("serv_sc_yn"));
// 	car.setEco_e_tag	(request.getParameter("eco_e_tag")		==null?"":request.getParameter("eco_e_tag"));	
	car.setVan_add_opt	(request.getParameter("van_add_opt")		==null?"":request.getParameter("van_add_opt"));
	
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	
	// ��ȣ�� ���� ���� �� ��ȣ�ǰ��������(���漱 �����), �������ⳳ(������ �����) �޽��� �߼�
	String prev_new_license_plate = request.getParameter("prev_new_license_plate")	==	null ? "0" : request.getParameter("prev_new_license_plate");
	String new_license_plate = request.getParameter("new_license_plate")					==	null ? "0" : request.getParameter("new_license_plate");
	if(!prev_new_license_plate.equals(new_license_plate)){
		
		// �Ÿ��ֹ��� ��ĵ ���� ��� ���� ��ȸ
		String content_code = "LC_SCAN";
		String content_seq  = rent_mng_id+""+rent_l_cd;
		int attach_count = 0;
		attach_count = c_db.getAcarAttachFileCount(content_code, content_seq, 15);	
		
		if(attach_count>0){	// �Ÿ��ֹ��� ��ĵ ������ ��ϵ� ��쿡�� �߼�
			
			String msg_subject 		= "��ȣ�� ���� ����";
			String target_id1 = "000096";	// ��ȣ�� ���� �����(���漱 �����)
			//String target_id2 = "000298";	// ������ �ⳳ(������ �����)->����ް�
			//�������ⳳ ����ް��� ��ȣ�ǰ�������� ������ ������ü�ڷ�
			CarSchDatabase csd = CarSchDatabase.getInstance();
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id1);
			if(!cs_bean.getUser_id().equals(""))	target_id1 = cs_bean.getWork_id();
		
			//����� ���� ��ȸ
			UsersBean target_bean1 	= umd.getUsersBean(target_id1);
			//UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			UsersBean sender_bean	= umd.getUsersBean(user_id);
			
			String msg = "[ "+rent_l_cd+" "+firm_nm+" ]�� ��ȣ�� ������  &lt;br&gt; &lt;br&gt; ";
			if(prev_new_license_plate.equals("0") && new_license_plate.equals("1")) msg += "�������� ��������";
			else if(prev_new_license_plate.equals("1") && new_license_plate.equals("0")) msg += "�������� ��������";
			msg += "����Ǿ����ϴ�.  &lt;br&gt; &lt;br&gt; Ȯ�� �ٶ��ϴ�.  &lt;br&gt; &lt;br&gt; ������: "+sender_bean.getUser_nm();
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
						"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>"+msg_subject+"</SUB>"+
						"    <CONT>"+msg+"</CONT>";
	
			//�޴»��
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
			//xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
	
			//�������
			xml_data += "    <SENDER></SENDER>"+
	
						"    <MSGICON>10</MSGICON>"+
						"    <MSGSAVE>1</MSGSAVE>"+
						"    <LEAVEDMSG>1</LEAVEDMSG>"+
						"    <FLDTYPE>1</FLDTYPE>"+
						"  </ALERTMSG>"+
						"</COOLMSG>";
			
			CdAlertBean msg1 = new CdAlertBean();
			msg1.setFlddata(xml_data);
			msg1.setFldtype("1");
			
			flag3 = cm_db.insertCoolMsg(msg1);
		
		}
	}
	
	//�������-------------------------------------------------------------------------------------------
	
	
// 	String o_udt_st = pur.getUdt_st();
	
// 	pur.setUdt_st				(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
// 	pur.setCons_amt1		(request.getParameter("cons_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt1")));
// 	pur.setEcar_loc_st	(request.getParameter("ecar_loc_st")		==null?"":request.getParameter("ecar_loc_st"));
// 	pur.setHcar_loc_st	(request.getParameter("hcar_loc_st")		==null?"":request.getParameter("hcar_loc_st"));
	
	flag4 = a_db.updateContPur(pur);
	
// 	String n_udt_st = pur.getUdt_st();
	
	//�����μ��� ����� ��ຯ��������� �޽��� �߼�
// 	if(!o_udt_st.equals("") && !o_udt_st.equals(n_udt_st)){
// 		if(base.getUse_yn().equals("Y")){
			
// 			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
// 			String sub 		= "����� �����μ��� ����";
// 			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] ������� �����μ����� �����Ͽ����ϴ�. Ȯ�ιٶ��ϴ�.";
// 			String target_id = nm_db.getWorkAuthUser("��ຯ�����");//20130128 ����������->�߰������м��� ����  20131205 �߰������м���->��ຯ�����
			
// 			CarSchDatabase csd = CarSchDatabase.getInstance();
// 			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
// 			if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("��������������");
			
// 			//����� ���� ��ȸ
// 			UsersBean target_bean 	= umd.getUsersBean(target_id);
// 			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
// 			String xml_data = "";
// 			xml_data =  "<COOLMSG>"+
// 		  				"<ALERTMSG>"+
//   						"    <BACKIMG>4</BACKIMG>"+
//   						"    <MSGTYPE>104</MSGTYPE>"+
//   						"    <SUB>"+sub+"</SUB>"+
// 		  				"    <CONT>"+cont+"</CONT>"+
//  						"    <URL></URL>";
// 			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
// 			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
//   						"    <MSGICON>10</MSGICON>"+
//   						"    <MSGSAVE>1</MSGSAVE>"+
//   						"    <LEAVEDMSG>1</LEAVEDMSG>"+
// 		  				"    <FLDTYPE>1</FLDTYPE>"+
//   						"  </ALERTMSG>"+
//   						"</COOLMSG>";
			
// 			CdAlertBean msg = new CdAlertBean();
// 			msg.setFlddata(xml_data);
// 			msg.setFldtype("1");
			
// 			flag3 = cm_db.insertCoolMsg(msg);			
			
// 		}
// 	}
	
	//ȭ�����̰� ������߰����� �ɼ� ������ ������ �������ڿ��� �޼���
	if(chg_van_add_opt_yn==true){
		
		String sub2 		= "������߰����� ����";
		String target_id2 = "000130";	//����
		String target_id3 = "000048";	//��ġ�� //000277  2���� �޼��� �߼۵ǰ� ��û
		//����� ���� ��ȸ
		UsersBean target_bean2 	= umd.getUsersBean(target_id2);
		UsersBean target_bean3 	= umd.getUsersBean(target_id3);
		UsersBean sender_bean	= umd.getUsersBean(user_id);
		
		String cont2 	= "[ "+rent_l_cd+" "+firm_nm+" "+cr_bean.getCar_no()+" ]  &lt;br&gt; &lt;br&gt; ������� ����� �߰�����(ȭ��������)�� ";
		if(car.getVan_add_opt().equals("")){				cont2 += "����"; 			 		}
		else if(car.getVan_add_opt().equals("1")){		cont2 += "����ž/���ٵ� ��";  		}
		else if(car.getVan_add_opt().equals("2")){		cont2 += "Ȱ�������";  			}
		else if(car.getVan_add_opt().equals("3")){		cont2 += "������/ũ����";  		}
		cont2 += " ���� ���(Ȥ�� ����)�Ͽ����ϴ�.  &lt;br&gt; &lt;br&gt; Ȯ�ιٶ��ϴ�.  &lt;br&gt; &lt;br&gt; ���(����)��:"+sender_bean.getUser_nm();
		
		String xml_data2 = "";
		xml_data2 =  "<COOLMSG>"+
	  						 "<ALERTMSG>"+
							 "    <BACKIMG>4</BACKIMG>"+
							 "    <MSGTYPE>104</MSGTYPE>"+
							 "    <SUB>"+sub2+"</SUB>"+
	  						 "    <CONT>"+cont2+"</CONT>"+
							 "    <URL></URL>";
		xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET><TARGET>"+target_bean3.getId()+"</TARGET>";
		xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
							 "    <MSGICON>10</MSGICON>"+
							 "    <MSGSAVE>1</MSGSAVE>"+
							 "    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					 	 "    <FLDTYPE>1</FLDTYPE>"+
							 "  </ALERTMSG>"+
							 "</COOLMSG>";
		
		CdAlertBean msg2 = new CdAlertBean();
		msg2.setFlddata(xml_data2);
		msg2.setFldtype("1");
		
		//20200219 ����� �߰�����(ȭ��������)�� ������ �Ⱥ������� �������� ��û
		if(car.getVan_add_opt().equals("")){
			
		}else{
			flag3 = cm_db.insertCoolMsg(msg2);
		}	
		
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�����⺻���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
<%		if(!flag4){	%>	alert('������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');				<%		}	%>		
</script>
<%	}%>



<%
	if(cng_item.equals("gi")){
	
	//�����⺻����-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	car.setGi_st		(request.getParameter("gi_st")			==null?"":request.getParameter("gi_st"));
	//=====[car_etc] update=====
	flag1 = a_db.updateContCarNew(car);
	
	//���ຸ������-----------------------------------------------------------------------------------------------
	
	//gua_ins
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	gins.setGi_st		(request.getParameter("gi_st")			==null?"":request.getParameter("gi_st"));
	
	if(!car_st.equals("2")){
		if(gins.getGi_no().equals("")){
			gins.setGi_no("0");
		}else{
			gins.setGi_no(request.getParameter("gi_no")==null?"":request.getParameter("gi_no"));
		}
		if(gins.getGi_st().equals("0")){
			gins.setGi_reason	(request.getParameter("gi_reason")==null?"":request.getParameter("gi_reason"));
			gins.setGi_sac_id	(request.getParameter("gi_sac_id")==null?"":request.getParameter("gi_sac_id"));
			gins.setGi_jijum("");
			gins.setGi_amt(0);
			gins.setGi_fee(0);
			gins.setGi_start_dt("");
			gins.setGi_end_dt("");
			gins.setGi_dt("");
		}else if(gins.getGi_st().equals("1")){
			gins.setGi_reason("");
			gins.setGi_sac_id("");
			gins.setGi_jijum	(request.getParameter("gi_jijum")==null?"":request.getParameter("gi_jijum"));
			gins.setGi_amt		(request.getParameter("gi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_amt")));
			gins.setGi_fee		(request.getParameter("gi_fee")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_fee")));
		}
		
		if(gins.getRent_mng_id().equals("")){
			//=====[gua_ins] insert=====
			gins.setRent_mng_id	(rent_mng_id);
			gins.setRent_l_cd	(rent_l_cd);
			gins.setRent_st		("1");
			flag2 = a_db.insertGiInsNew(gins);
		}else{
			//=====[gua_ins] update=====
			flag2 = a_db.updateGiInsNew(gins);
		}
	}

	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�����⺻���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
<%		if(!flag2){	%>	alert('���ຸ������ ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("pay_way")){
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	if(!car_st.equals("2")){
		
		fee.setFee_sh			(request.getParameter("fee_sh")			==null?"":request.getParameter("fee_sh"));
		fee.setFee_pay_st		(request.getParameter("fee_pay_st")		==null?"":request.getParameter("fee_pay_st"));
		fee.setFee_bank			(request.getParameter("fee_bank")		==null?"":request.getParameter("fee_bank"));
		fee.setDef_st			(request.getParameter("def_st")			==null?"":request.getParameter("def_st"));
		fee.setDef_remark		(request.getParameter("def_remark")		==null?"":request.getParameter("def_remark"));
		fee.setDef_sac_id		(request.getParameter("def_sac_id")		==null?"":request.getParameter("def_sac_id"));
		fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));
		
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
		
		//�ڵ���ü-------------------------------------------------------------------------------------------
		
		//cms_mng
		ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
		
		if(!cms.getSeq().equals("") && cms.getApp_dt().equals("")){
		
			cms.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
			cms.setCms_bank		(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
			cms.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
			cms.setCms_day		(request.getParameter("cms_day")	==null?"":request.getParameter("cms_day"));
			
			cms.setCms_tel		(request.getParameter("cms_tel")==null?"":request.getParameter("cms_tel"));
			cms.setCms_m_tel	(request.getParameter("cms_m_tel")==null?"":request.getParameter("cms_m_tel"));
			cms.setCms_email	(request.getParameter("cms_email")==null?"":request.getParameter("cms_email"));
			cms.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")==null?"":request.getParameter("cms_dep_ssn"));
			
			cms.setCms_dep_post	(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
			cms.setCms_dep_addr	(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
			
			cms.setBank_cd		(request.getParameter("cms_bank_cd")	==null?"":request.getParameter("cms_bank_cd"));
		
			if(!cms.getBank_cd().equals("")){
				cms.setCms_bank		(c_db.getNameById(cms.getBank_cd(), "BANK"));
			}			
			
		
			if(!cms.getCms_acc_no().equals("")){
			
				if(cms.getSeq().equals("")){
					cms.setRent_mng_id	(rent_mng_id);
					cms.setRent_l_cd	(rent_l_cd);
					cms.setReg_st		("1");
					cms.setCms_st		("1");
					cms.setReg_id		(user_id);
					//=====[cms_mng] insert=====
					flag2 = a_db.insertContCmsMng(cms);
				}else{
					cms.setUpdate_id	(user_id);
					//=====[cms_mng] update=====
					flag2 = a_db.updateContCmsMng(cms);
				}
			}
		}
	}
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	fee_etc.setCms_not_cau	(request.getParameter("cms_not_cau")==null?"":request.getParameter("cms_not_cau"));
	if(!fee_etc.getCms_not_cau().equals("")){
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id	(rent_mng_id);
			fee_etc.setRent_l_cd	(rent_l_cd);
			fee_etc.setRent_st		("1");
			//=====[fee_etc] insert=====
			flag6 = a_db.insertFeeEtc(fee_etc);
		}else{
			//=====[fee_etc] update=====
			flag6 = a_db.updateFeeEtc(fee_etc);
		}
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�뿩���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
<%		if(!flag2){	%>	alert('�ڵ���ü ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("tax")){
	
	//���⺻����-----------------------------------------------------------------------------------------------
	
	base.setTax_type	(request.getParameter("tax_type")		==null?"1":request.getParameter("tax_type"));
	//=====[cont] update=====
	flag1 = a_db.updateContBaseNew(base);
	
	//����Ÿ����-----------------------------------------------------------------------------------------------
	
	cont_etc.setRec_st	(request.getParameter("rec_st")		==null?"":request.getParameter("rec_st"));
	cont_etc.setEle_tax_st	(request.getParameter("ele_tax_st")	==null?"":request.getParameter("ele_tax_st"));
	cont_etc.setTax_extra	(request.getParameter("tax_extra")	==null?"":request.getParameter("tax_extra"));
	
	if(cont_etc.getRent_mng_id().equals("")){
		//=====[cont_etc] insert=====
		cont_etc.setRent_mng_id	(rent_mng_id);
		cont_etc.setRent_l_cd	(rent_l_cd);
		flag2 = a_db.insertContEtc(cont_etc);
		flag2 = a_db.updateContEtc(cont_etc);
	}else{
		//=====[cont_etc] update=====
		flag2 = a_db.updateContEtc(cont_etc);
	}
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	if(!car_st.equals("2")){
		
		fee.setBr_id		(request.getParameter("fee_br_id")	==null?"":request.getParameter("fee_br_id"));
		fee.setFee_st		(request.getParameter("fee_st")		==null?"":request.getParameter("fee_st"));
		fee.setRc_day		(request.getParameter("rc_day")		==null?"":request.getParameter("rc_day"));
		fee.setNext_yn		(request.getParameter("next_yn")	==null?"":request.getParameter("next_yn"));
		fee.setLeave_day	(request.getParameter("leave_day")	==null?"":request.getParameter("leave_day"));
		
		//=====[fee] update=====
		flag3 = a_db.updateContFeeNew(fee);
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('���⺻���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
<%		if(!flag2){	%>	alert('����Ÿ���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("taecha_info")){
	
	if(!car_st.equals("2")){
		
		//�뿩����-------------------------------------------------------------------------------------------
		
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		fee.setPrv_dlv_yn		(request.getParameter("prv_dlv_yn")		==null?"":request.getParameter("prv_dlv_yn"));
		fee.setPrv_mon_yn		(request.getParameter("prv_mon_yn")		==null?"":request.getParameter("prv_mon_yn"));
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�뿩���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>			
</script>
<%	}%>

<%
	if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){
	
	if(!car_st.equals("2")){
		
		//�뿩����-------------------------------------------------------------------------------------------
		
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		
		//�����������-------------------------------------------------------------------------------------------
		
		String tae_car_mng_id = request.getParameter("tae_car_mng_id")	==null?"":request.getParameter("tae_car_mng_id");
		String tae_no = request.getParameter("tae_no")	==null?"":request.getParameter("tae_no");
		
		String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
		
		if(!tae_no.equals("") && taecha_no.equals("")){
			taecha_no = tae_no;
		}
		
		if(taecha_no.equals("")){
			taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
		}
				
		//�����������
		ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
		
		taecha.setCar_mng_id	(tae_car_mng_id);
		taecha.setCar_no		(request.getParameter("tae_car_no")		==null?"":request.getParameter("tae_car_no"));
		taecha.setCar_nm		(request.getParameter("tae_car_nm")		==null?"":request.getParameter("tae_car_nm"));
		taecha.setCar_id		(request.getParameter("tae_car_id")		==null?"":request.getParameter("tae_car_id"));
		taecha.setCar_seq		(request.getParameter("tae_car_seq")	==null?"":request.getParameter("tae_car_seq"));
		taecha.setCar_rent_st	(request.getParameter("tae_car_rent_st")==null?"":request.getParameter("tae_car_rent_st"));
		taecha.setCar_rent_et	(request.getParameter("tae_car_rent_et")==null?"":request.getParameter("tae_car_rent_et"));
		taecha.setRent_fee		(request.getParameter("tae_rent_fee")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee")));
		taecha.setReq_st		(request.getParameter("tae_req_st")		==null?"":request.getParameter("tae_req_st"));
		taecha.setTae_st		(request.getParameter("tae_tae_st")		==null?"":request.getParameter("tae_tae_st"));
		taecha.setTae_sac_id	(request.getParameter("tae_sac_id")		==null?"":request.getParameter("tae_sac_id"));
		taecha.setRent_s_cd		(request.getParameter("tae_s_cd")		==null?"":request.getParameter("tae_s_cd"));
		taecha.setRent_inv		(request.getParameter("tae_rent_inv")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_inv")));
		taecha.setEst_id		(request.getParameter("tae_est_id")		==null?"":request.getParameter("tae_est_id"));
		taecha.setF_req_yn		(request.getParameter("tae_f_req_yn")		==null?"":request.getParameter("tae_f_req_yn"));
		taecha.setRent_fee_st	(request.getParameter("tae_rent_fee_st")	==null?"":request.getParameter("tae_rent_fee_st"));
		taecha.setRent_fee_cls	(request.getParameter("tae_rent_fee_cls")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee_cls")));
		taecha.setEnd_rent_link_sac_id(request.getParameter("end_rent_link_sac_id")		==null?"":request.getParameter("end_rent_link_sac_id"));
		

		if(!tae_car_mng_id.equals("") && fee.getPrv_dlv_yn().equals("Y")){
			
			String taecha_add_yn = "N"; 
			
			if(taecha.getRent_mng_id().equals("")){
				taecha.setRent_mng_id	(rent_mng_id);
				taecha.setRent_l_cd		(rent_l_cd);
				//=====[gua_ins] insert=====
				flag2 = a_db.insertTaechaNew(taecha);
				
				if(ta_vt_size > 0){
					taecha_add_yn = "Y";
				}
				
			}else{
				//=====[gua_ins] update=====
				flag2 = a_db.updateTaechaNew(taecha);
			}
			
			//��������� ��������(�߰����)
			if(taecha_add_yn.equals("Y")){
				UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("�����ٻ�����"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>����������� ��������</SUB>"+
		  				"    <CONT>����������� ������ ����Ǿ����� �뿩�� Ȯ���ϼ���. &lt;br&gt; &lt;br&gt;  "+rent_l_cd+" "+firm_nm+"</CONT>"+
 						"    <URL></URL>";
				//xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <TARGET>2002013</TARGET>";
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
			
			//�����ٴ���ڿ��� �޽��� �߼�
			if(AddUtil.parseInt(taecha.getRent_fee()) >0 && taecha.getF_req_yn().equals("Y") && taecha.getF_req_dt().equals("")){
				UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("�����ٻ�����"));
										
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>��������� ���Ա� ���</SUB>"+
		  				"    <CONT>��������� ���Ա� ��� : "+rent_l_cd+" "+firm_nm+" ���뿩��"+taecha.getRent_fee()+"��</CONT>"+
 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
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
				
				taecha.setF_req_dt	(AddUtil.getDate(4));
				flag8 = a_db.updateTaechaNew(taecha);
			}
			//20210101 ���� ��������� ���뿩�ᰡ �ְ�, ����������������� �������� ǥ��Ǿ� ���� ������ ��� �ǿ�İ������� �޽��� �߼�
			if(taecha.getRent_fee_cls().equals("0") && AddUtil.parseInt(taecha.getRent_fee()) >0  && AddUtil.parseInt(AddUtil.replace(taecha.getCar_rent_st(),"-","")) >= 20210101){				
				UsersBean tae_target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("��������������"));
				
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
	  						"    <BACKIMG>4</BACKIMG>"+
	  						"    <MSGTYPE>104</MSGTYPE>"+
	  						"    <SUB>��������� ���������ÿ������</SUB>"+
			  				"    <CONT>��������� ���������ÿ������ ������ ��ǥ�� : "+rent_l_cd+"</CONT>"+
	 						"    <URL></URL>";
				xml_data3 += "    <TARGET>"+tae_target_bean.getId()+"</TARGET>";
				xml_data3 += "    <MSGICON>10</MSGICON>"+
	  						"    <MSGSAVE>1</MSGSAVE>"+
	  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
	  						"  </ALERTMSG>"+
	  						"</COOLMSG>";
				
				CdAlertBean msg3 = new CdAlertBean();
				msg3.setFlddata(xml_data3);
				msg3.setFldtype("1");
				
				//flag12 = cm_db.insertCoolMsg(msg3);									
			}
			
			if(!taecha.getRent_inv().equals("") && !taecha.getRent_inv().equals("0")){
				ContFeeBean fee_add = a_db.getContFeeNewAdd(rent_mng_id, rent_l_cd, "t");
				if(!AddUtil.replace(taecha.getCar_rent_et(),"-","").equals(fee_add.getRent_end_dt()) || !AddUtil.replace(taecha.getCar_rent_st(),"-","").equals(fee_add.getRent_start_dt())){
					fee_add.setRent_start_dt	(taecha.getCar_rent_st());
					fee_add.setRent_end_dt		(taecha.getCar_rent_et());
					flag2 = a_db.updateContFeeAdd(fee_add);
				}
			}
			
			int tae_rent_inv_s = request.getParameter("tae_rent_inv_s")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_inv_s"));
			int tae_rent_inv_v = request.getParameter("tae_rent_inv_v")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_inv_v"));
			
			int tae_rent_fee_s = request.getParameter("tae_rent_fee_s")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_fee_s"));
			int tae_rent_fee_v = request.getParameter("tae_rent_fee_v")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_fee_v"));
			
			if(tae_rent_inv_s>0){
				//�߰�����뿩���� ������ ����
				boolean flag30 = a_db.updateContFeeAddInvAmt(rent_mng_id, rent_l_cd, "t", tae_rent_inv_s, tae_rent_inv_v, tae_rent_fee_s, tae_rent_fee_v);
			}else{
				ContFeeBean fee_add = a_db.getContFeeNewAdd(rent_mng_id, rent_l_cd, "t");
				if( tae_rent_fee_s>0 && AddUtil.parseInt(base.getRent_dt()) > 20100910 ){
					if(AddUtil.parseDigit(taecha.getRent_fee()) > fee_add.getFee_s_amt()+fee_add.getFee_v_amt() || AddUtil.parseDigit(taecha.getRent_fee()) < fee_add.getFee_s_amt()+fee_add.getFee_v_amt() ){
						boolean flag30 = a_db.updateContFeeAddFeeAmt(rent_mng_id, rent_l_cd, "t", tae_rent_fee_s, tae_rent_fee_v);
					}
				}
			}			
			
			if(!tae_car_mng_id.equals("") && !taecha.getRent_s_cd().equals("")){
				RentContBean rc_bean = rs_db.getRentContCase(taecha.getRent_s_cd(), tae_car_mng_id);
				if(rc_bean.getSub_l_cd().equals("")){
					rc_bean.setSub_l_cd		(rent_l_cd);
					int rs_count = 1;
					rs_count = rs_db.updateRentCont(rc_bean);
				}
			}
			
		}else{
			if(!taecha.getRent_mng_id().equals("") && fee.getPrv_dlv_yn().equals("N") && taecha.getCar_rent_st().equals("") && taecha.getCar_rent_et().equals("")){
				if(taecha.getCar_mng_id().equals("")){
					//=====[Taecha] update=====
					flag2 = a_db.deleteTaecha(taecha);
					
				}else{
					//=====[Taecha] update=====
					flag2 = a_db.updateTaechaNew(taecha);
				}	
			}
		}
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�뿩���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
<%		if(!flag2){	%>	alert('��������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("emp1")){
	
	//�����һ��-------------------------------------------------------------------------------------------
	
	//commi
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	String emp_id[] 	= request.getParameterValues("emp_id");
	String car_off_nm[] 	= request.getParameterValues("car_off_nm");
	
	float o_comm_r_rt = emp1.getComm_r_rt();
	
	if(!emp_id[0].equals("")){
		
		emp1.setEmp_id		(emp_id[0]);
		emp1.setComm_r_rt	(request.getParameter("comm_r_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
		emp1.setCh_remark	(request.getParameter("ch_remark")	==null?"":request.getParameter("ch_remark"));
		emp1.setCh_sac_id	(request.getParameter("ch_sac_id")	==null?"":request.getParameter("ch_sac_id"));
		emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
		emp1.setEmp_acc_no(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
		emp1.setEmp_acc_nm(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
		emp1.setCommi			(request.getParameter("commi")		==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
		emp1.setCommi_car_amt	(request.getParameter("commi_car_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
		emp1.setCommi_car_st	(request.getParameter("commi_car_st")==null?"":request.getParameter("commi_car_st"));
		emp1.setAgnt_st		("1");
		emp1.setCommi_st	("1");
		emp1.setBank_cd		(request.getParameter("emp_bank_cd")	==null?"":request.getParameter("emp_bank_cd"));
		
		if(!emp1.getBank_cd().equals("")){
			emp1.setEmp_bank		(c_db.getNameById(emp1.getBank_cd(), "BANK"));
		}
		
		if(emp1.getRent_mng_id().equals("")){
			emp1.setRent_mng_id	(rent_mng_id);
			emp1.setRent_l_cd	(rent_l_cd);
			//=====[commi] insert=====
			flag1 = a_db.insertCommiNew(emp1);
		}else{
			//=====[commi] update=====
			flag1 = a_db.updateCommiNew(emp1);
		}
	}else{
		emp1.setEmp_id		("000000");
		emp1.setComm_r_rt	(request.getParameter("comm_r_rt")	==null? 0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
		emp1.setCh_remark	(request.getParameter("ch_remark")	==null?"":request.getParameter("ch_remark"));
		emp1.setCh_sac_id	(request.getParameter("ch_sac_id")	==null?"":request.getParameter("ch_sac_id"));
		emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
		emp1.setEmp_acc_no	(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
		emp1.setEmp_acc_nm	(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
		emp1.setCommi		(request.getParameter("commi")		==null? 0:AddUtil.parseDigit(request.getParameter("commi")));
		emp1.setCommi_car_amt(request.getParameter("commi_car_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
		emp1.setCommi_car_st(request.getParameter("commi_car_st")==null?"":request.getParameter("commi_car_st"));
		//=====[commi] update=====
		flag1 = a_db.updateCommiNew(emp1);
	}
	
	float n_comm_r_rt = emp1.getComm_r_rt();
	
	//�������� ������ �������忡�� �޽��� �߼�		
	if(o_comm_r_rt > n_comm_r_rt || o_comm_r_rt < n_comm_r_rt){
		
		//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
		String sub 		= "����� ��࿵������ ����";
		String cont 		= "[ "+rent_l_cd+" "+firm_nm+" ] ������� ���������� ��࿵�������� �����Ͽ����ϴ�. Ȯ�ιٶ��ϴ�.";
		String url 		= "/fms2/lc_rent/lc_b_s.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
		String target_id = nm_db.getWorkAuthUser("��ຯ�����");//20130128 ����������->�߰������м��� ����  20131205 �߰������м���->��ຯ�����
			
		CarSchDatabase csd = CarSchDatabase.getInstance();
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getUser_id().equals(""))	target_id = nm_db.getWorkAuthUser("��������������");
			
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
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
			
		flag3 = cm_db.insertCoolMsg(msg);
	}		
	
	
	if(car_gu.equals("1")){
		
		pur.setPur_bus_st	(request.getParameter("pur_bus_st")	==null?"":request.getParameter("pur_bus_st"));
		
		//=====[CAR_PUR] update=====
		flag4 = a_db.updateContPur(pur);
		
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('������� ������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("emp2")){
	
	//�����һ��-------------------------------------------------------------------------------------------
	
	//commi
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	String emp_id[] 	= request.getParameterValues("emp_id");
	String car_off_nm[] = request.getParameterValues("car_off_nm");
	
	if(car_gu.equals("1")){
		if(!emp_id[1].equals("")){
			
			emp2.setEmp_id		(emp_id[1]);
			emp2.setAgnt_st		("2");
			emp2.setCommi_st	("1");
			
			if(emp2.getRent_mng_id().equals("")){
				emp2.setRent_mng_id	(rent_mng_id);
				emp2.setRent_l_cd	(rent_l_cd);
				//=====[commi] insert=====
				flag2 = a_db.insertCommiNew(emp2);
			}else{
				//=====[commi] update=====
				flag2 = a_db.updateCommiNew(emp2);
			}
		}else{
			emp2.setEmp_id		("000000");
			//=====[commi] update=====
			flag2 = a_db.updateCommiNew(emp2);
		}
	}
	
	
	//�������-------------------------------------------------------------------------------------------
	
	
	if(car_gu.equals("1")){
		
		String o_one_self  	= pur.getOne_self();
		
		pur.setTmp_drv_no	(request.getParameter("tmp_drv_no")	==null?"":request.getParameter("tmp_drv_no"));
		pur.setTmp_drv_st	(request.getParameter("tmp_drv_st")	==null?"":request.getParameter("tmp_drv_st"));
		pur.setTmp_drv_et	(request.getParameter("tmp_drv_et")	==null?"":request.getParameter("tmp_drv_et"));
		//pur.setCon_amt		(request.getParameter("con_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("con_amt")));
		//pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
		//pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
		//pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
		pur.setDir_pur_yn	(request.getParameter("dir_pur_yn")	==null?"":request.getParameter("dir_pur_yn"));
		pur.setPur_req_dt	(request.getParameter("pur_req_dt")	==null?"":request.getParameter("pur_req_dt"));
		pur.setPur_req_yn	(request.getParameter("pur_req_yn")	==null?"":request.getParameter("pur_req_yn"));
		//pur.setTrf_amt5		(request.getParameter("trf_amt5")		==null? 0:AddUtil.parseDigit(request.getParameter("trf_amt5"))); 
		
		//if(pur.getTrf_amt5() >0 && pur.getTrf_st5().equals("")) pur.setTrf_st5("1");
		
		
		//=====[CAR_PUR] update=====
		flag4 = a_db.updateContPur(pur);
		
		String n_one_self  	= pur.getOne_self();
		

	}
	
	%>
<script language='javascript'>
<%		if(!flag2){	%>	alert('����� ������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
<%		if(!flag3){	%>	alert('���⺻���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');			<%		}	%>		
<%		if(!flag4){	%>	alert('������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');				<%		}	%>		
</script>
<%	}%>



<%
	if(cng_item.equals("com_emp_sac")){

		//=====[cont_etc] update=====
		flag2 = ec_db.updateContEtcComEmpSac(rent_mng_id, rent_l_cd, user_id);		
	
	}
%>	


<form name='form1' method='post'>
  
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 			value="">
</form>
<script language='javascript'>

	var fm = document.form1;
	
	if('<%=from_page%>' == '/agent/lc_rent/lc_bc_frame.jsp'){
		fm.rent_st.value = '<%=request.getParameter("rent_st")==null?"1":request.getParameter("rent_st")%>';
		fm.action = '/agent/lc_rent/lc_bc_u.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}else if('<%=from_page%>' == '/agent/car_pur/pur_doc_u.jsp'){
		fm.rent_st.value = '1';
		fm.action = '/agent/car_pur/pur_doc_u.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}else if('<%=from_page%>' == '/fms2/lc_rent/lc_c_c_car.jsp'){
		fm.rent_st.value = '1';
		fm.action = '/fms2/lc_rent/lc_c_c_car.jsp';	
		fm.target = 'c_foot';
		fm.submit();
	}else{
		fm.action = '<%=from_page%>';	
		fm.target = 'c_foot';
		fm.submit();
	}
	
	parent.window.close();
//	window.close();

</script>
</body>
</html>