<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.car_office.*, acar.user_mng.*, acar.estimate_mng.*, acar.coolmsg.*, acar.cont.*, acar.car_mst.*, acar.client.*, acar.common.*"%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String opt1 		= request.getParameter("opt1")		==null?"":request.getParameter("opt1");
	String opt2 		= request.getParameter("opt2")		==null?"":request.getParameter("opt2");
	String opt3 		= request.getParameter("opt3")		==null?"":request.getParameter("opt3");
	String opt4 		= request.getParameter("opt4")		==null?"":request.getParameter("opt4");
	String opt5 		= request.getParameter("opt5")		==null?"":request.getParameter("opt5");
	String opt6 		= request.getParameter("opt6")		==null?"":request.getParameter("opt6");
	String opt7 		= request.getParameter("opt7")		==null?"":request.getParameter("opt7");
	String e_opt1 		= request.getParameter("e_opt1")	==null?"":request.getParameter("e_opt1");
	String e_opt2 		= request.getParameter("e_opt2")	==null?"":request.getParameter("e_opt2");
	String e_opt3 		= request.getParameter("e_opt3")	==null?"":request.getParameter("e_opt3");
	String e_opt4 		= request.getParameter("e_opt4")	==null?"":request.getParameter("e_opt4");
	String e_opt5 		= request.getParameter("e_opt5")	==null?"":request.getParameter("e_opt5");
	String e_opt6 		= request.getParameter("e_opt6")	==null?"":request.getParameter("e_opt6");
	String e_opt7 		= request.getParameter("e_opt7")	==null?"":request.getParameter("e_opt7");
	String ready_car	= request.getParameter("ready_car")	==null?"":request.getParameter("ready_car");
	String eco_yn 	= request.getParameter("eco_yn")	==null?"":request.getParameter("eco_yn");

	
	String seq 			= request.getParameter("seq")		==null?"":request.getParameter("seq");
	String r_seq 		= request.getParameter("r_seq")		==null?"":request.getParameter("r_seq");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String cng_item 	= request.getParameter("cng_item")	==null?"":request.getParameter("cng_item");


	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag4 = true;
	
	int result = 0;
	
	String msg_yn = "N"; 
	String target2_yn = "N"; 
	String sub 	= "";
	String cont 	= "";
	String jg_g_7 = "";
	
	String cont_udt_auto_cng_yn = "";
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	CarOffPreBean bean = cop_db.getCarOffPreSeq(seq);
	
	if(!r_seq.equals("")){
		bean = cop_db.getCarOffPreSeq(seq, r_seq);
	}
	
	//int temp_idx = bean.getReq_dt().indexOf(".");
    //String req_dt = bean.getReq_dt().substring(0, temp_idx);
    
    bean.setReq_dt(bean.getReq_dt());
	
	//�����ȣ ����
	if(cng_item.equals("com_con_no")){
	
		String o_com_con_no = request.getParameter("o_com_con_no")==null?"":request.getParameter("o_com_con_no");
		String n_com_con_no = request.getParameter("n_com_con_no")==null?"":request.getParameter("n_com_con_no");
		
		String etc = bean.getEtc();
		
		if(!etc.equals("")) etc = etc+" ";
		
		etc = etc +"�������ȣ="+o_com_con_no;
		
		bean.setCom_con_no	(n_com_con_no);
		bean.setEtc	(etc);
		
		//update
		flag1 = cop_db.updateCarOffPre(bean);
		
	}else if(cng_item.equals("req")){
		
		String o_req_dt = request.getParameter("o_req_dt")==null?"":request.getParameter("o_req_dt");
		String n_req_dt = request.getParameter("n_req_dt")==null?"":request.getParameter("n_req_dt");
		
		//int idx_num = n_req_dt.indexOf(".");
		//n_req_dt = n_req_dt.substring(0, idx_num);
		
		bean.setReq_dt(n_req_dt);
		
		//update
		flag1 = cop_db.updateCarOffPre(bean);
			
	//�������� ����
	}else if(cng_item.equals("car")){
		
		bean.setCar_nm		(request.getParameter("car_nm")		==null?"":request.getParameter("car_nm"));	
		bean.setOpt			(request.getParameter("opt")		==null?"":request.getParameter("opt"));	
		bean.setColo		(request.getParameter("colo")		==null?"":request.getParameter("colo"));	
		bean.setIn_col		(request.getParameter("in_col")		==null?"":request.getParameter("in_col"));	
		bean.setEco_yn		(request.getParameter("eco_yn")		==null?"":request.getParameter("eco_yn"));	
		bean.setCar_amt		(request.getParameter("car_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_amt")));
		bean.setCon_amt		(request.getParameter("con_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("con_amt")));
		bean.setDlv_est_dt	(request.getParameter("dlv_est_dt")	==null?"":request.getParameter("dlv_est_dt"));	
		bean.setCon_pay_dt	(request.getParameter("con_pay_dt")	==null?"":request.getParameter("con_pay_dt"));	
		bean.setEtc			(request.getParameter("etc")		==null?"":request.getParameter("etc"));	
		bean.setGarnish_col	(request.getParameter("garnish_col")==null?"":request.getParameter("garnish_col"));
		bean.setAgent_view_yn(request.getParameter("agent_view_yn")==null?"N":request.getParameter("agent_view_yn"));
		bean.setBus_self_yn	(request.getParameter("bus_self_yn")==null?"N":request.getParameter("bus_self_yn"));
		
		bean.setCon_bank	(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
		bean.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
		bean.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
		bean.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
		bean.setTrf_st0		(request.getParameter("trf_st0")	==null?"":request.getParameter("trf_st0"));
		bean.setAcc_st0		(request.getParameter("acc_st0")	==null?"":request.getParameter("acc_st0"));
		
		//update
		flag1 = cop_db.updateCarOffPre(bean);

		
		String o_q_reg_dt = request.getParameter("o_q_reg_dt")==null?"":request.getParameter("o_q_reg_dt");
		String q_reg_dt = request.getParameter("q_reg_dt")==null?"N":request.getParameter("q_reg_dt");
		
		bean.setQ_reg_dt	(q_reg_dt);
		
		//�����϶� Q�ڵ�����
		if(o_q_reg_dt.equals("") && q_reg_dt.equals("Y")){
			flag1 = cop_db.updateCarOffPreQ(bean);
		}
		if(!o_q_reg_dt.equals("") && q_reg_dt.equals("N")){
			flag1 = cop_db.updateCarOffPreQ(bean);
		}
		
		
	//������ ����
	}else if(cng_item.equals("res_u")){
		
		bean.setBus_nm		(request.getParameter("bus_nm")		==null?"":request.getParameter("bus_nm"));	
		bean.setFirm_nm		(request.getParameter("firm_nm")	==null?"":request.getParameter("firm_nm"));	
		bean.setAddr		(request.getParameter("addr")		==null?"":request.getParameter("addr"));	
		bean.setCust_tel	(request.getParameter("cust_tel")	==null?"":request.getParameter("cust_tel"));	
		bean.setMemo		(request.getParameter("memo")		==null?"":request.getParameter("memo"));	
		bean.setBus_tel		(request.getParameter("bus_tel")	==null?"":request.getParameter("bus_tel"));
		
		//update
		flag1 = cop_db.updateCarOffPreRes(bean);
		
	//������ ���
	}else if(cng_item.equals("res_i")){
		//���� : ������ ���డ��(reg_dt�� ���� ��������), ����: �� ������ �Ѹ� ���డ���ϰ� ����. (20190121) --> 2�������� ��� 20211015 --> 3�������� ��� 20220901
		int res_cnt = 0;
		int max_r_seq = 0;
		Vector vt = cop_db.getCarOffPreSeqResList(seq);
		if(vt.size() > 0){
			for(int i=0; i<vt.size();i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String cls_dt = String.valueOf(ht.get("CLS_DT"));
				if(cls_dt.equals("")){
					msg_yn = "RESERVE";
					res_cnt++;
				}
				max_r_seq = AddUtil.parseInt(String.valueOf(ht.get("R_SEQ")));
			}
		}
		if(res_cnt < 3){ // && msg_yn.equals("N")
			String res_msg_yn 	= request.getParameter("res_msg_yn")	==null?"":request.getParameter("res_msg_yn");
			String res_msg_yn2 	= request.getParameter("res_msg_yn2")	==null?"":request.getParameter("res_msg_yn2");
			
			msg_yn = res_msg_yn;
			target2_yn = res_msg_yn2;
			
			bean.setBus_nm	(request.getParameter("bus_nm")		==null?"":request.getParameter("bus_nm"));	
			bean.setFirm_nm	(request.getParameter("firm_nm")	==null?"":request.getParameter("firm_nm"));	
			bean.setAddr	(request.getParameter("addr")		==null?"":request.getParameter("addr"));	
			bean.setCust_tel(request.getParameter("cust_tel")	==null?"":request.getParameter("cust_tel"));	
			bean.setMemo	(request.getParameter("memo")		==null?"":request.getParameter("memo"));	
			bean.setReg_id	(ck_acar_id);
			bean.setBus_tel	(request.getParameter("bus_tel")	==null?"":request.getParameter("bus_tel"));
			
			//q�ڵ�
			if(!bean.getQ_reg_dt().equals("")){
				bean.setCust_q	("Q");
			}
			
			//insert
			flag1 = cop_db.insertCarOffPreRes(bean);
			
			//1���� ������ ��� ��ȿ�Ⱓ ���� ���ν����� �����Ѵ�.
			if(res_cnt == 0){
				String d_flag1 = cop_db.call_sp_com_pre_res_dire("i", bean.getSeq(), (max_r_seq+1));
			}	
			
		}
		
		
	//������ ���
	}else if(cng_item.equals("res_c")){
		
		
		
		//update
		flag1 = cop_db.updateCarOffPreResCls(bean.getSeq(), AddUtil.parseInt(r_seq));
		
		//������࿹�� �Ⱓ ���� ���ν��� ����
		String d_flag1 = cop_db.call_sp_com_pre_res_dire("c"+""+user_id, bean.getSeq(), AddUtil.parseInt(r_seq));
		
		
		//��ҽ� ����������ڿ��� �޽��� �߼�
		msg_yn = "Y";
		target2_yn = "Y";

	//�ɻ�Ϸ�
	}else if(cng_item.equals("res_conf")){
			
		//update
		flag1 = cop_db.updateCarOffPreResConfirm(bean.getSeq(), AddUtil.parseInt(r_seq));
		
		//��ҽ� ����������ڿ��� �޽��� �߼�
		msg_yn = "Y";
		

	//������� ���
	}else if(cng_item.equals("cls")){
		
		//update
		flag1 = cop_db.updateCarOffPreCls(bean.getSeq());
		
	//��࿬��
	}else if(cng_item.equals("cont")){
		
		String cont_car_yn = request.getParameter("cont_car_yn")==null?"":request.getParameter("cont_car_yn");
		
		bean.setRent_l_cd	(request.getParameter("rent_l_cd")	==null?"":request.getParameter("rent_l_cd"));	
		
		//����� Ȯ��
		Hashtable cont_ht = a_db.getContCase(bean.getRent_l_cd());

		//20190221 ������ ��ó�� : �߸� �Էº� ã���� ����.
		//if(cont_car_yn.equals("Y")){
			//�����⺻����
			//ContCarBean car 	= a_db.getContCarNew(String.valueOf(cont_ht.get("RENT_MNG_ID")), bean.getRent_l_cd());
			//�ڵ����⺻����
			//CarMstBean cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
			//������
			//bean.setCar_nm			(cm_bean.getCar_nm());	
			//bean.setOpt					(cm_bean.getCar_name()+" "+car.getOpt());	
			//bean.setColo				(car.getColo());	
			//bean.setIn_col			(car.getIn_col());	
			//bean.setCar_amt			(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt());
		//}
		
		//update
		bean.setPre_out_yn("");
		flag1 = cop_db.updateCarOffPre(bean);		
		
		//�������
		ContPurBean pur = a_db.getContPur(String.valueOf(cont_ht.get("RENT_MNG_ID")), bean.getRent_l_cd());
		
		//���� ����
		if(bean.getCon_amt() >0 && pur.getPur_pay_dt().equals("")){
			if(pur.getCon_amt() == 0){
				pur.setCon_amt		(bean.getCon_amt());
				pur.setCon_pay_dt	(bean.getCon_pay_dt());
				pur.setCon_bank		(bean.getCon_bank());
				pur.setCon_acc_no	(bean.getCon_acc_no());
				pur.setCon_acc_nm	(bean.getCon_acc_nm());
				pur.setTrf_st0		(bean.getTrf_st0());
				pur.setAcc_st0		(bean.getAcc_st0());
				pur.setCon_est_dt	(bean.getCon_est_dt());
			}			
			if(pur.getRpt_no().equals("")){ 
				pur.setRpt_no	(bean.getCom_con_no());
			}	
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		}
		
		//��ü������˸޽���
		String d_flag2 = cop_db.call_sp_com_pre_sys_cont(bean.getCom_con_no());
		
		//��ü������˸޽��� -> 20220907 call_sp_com_pre_sys_cont ó���� �ߺ� �̻��
		//String d_flag1 = cop_db.call_sp_com_pre_pur_auto(bean.getCom_con_no());
		
		//��ü������ ����
		CarPurDocListBean cpd_bean = cod.getCarPurCom(bean.getCom_con_no());
		
		//����� ����� ó�� 
		if(bean.getCar_off_nm().equals("B2B������") || cpd_bean.getCar_off_id().equals("03900")){
			//B2B������ : ���������� ȭ�� �ϴܿ� ���������� ǥ��	
		}else{
			//B2B������ ��(����,������, ����, ����, �ѽŴ�) : �����(�μ���)�� �ڵ�����
			if(!pur.getUdt_st().equals("") && !cpd_bean.getUdt_st().equals("") && !pur.getUdt_st().equals(cpd_bean.getUdt_st())){
				UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
				UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ�������"));
				UsersBean udt_mng_bean_b2	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ����������"));
				UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
				UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("�뱸������"));
				UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
				//������
				ClientBean client = al_db.getNewClient(String.valueOf(cont_ht.get("CLIENT_ID")));
					
				String udt_mng_id 	= "";
			    String udt_mng_nm 	= "";
			  	String udt_mng_tel 	= "";
			  	String udt_firm 	= "";    	
				String udt_addr 	= "";  
				String o_udt_st_nm = c_db.getNameByIdCode("0035", "", cpd_bean.getUdt_st());
				String n_udt_st_nm = c_db.getNameByIdCode("0035", "", pur.getUdt_st());
			 	if(pur.getUdt_st().equals("1")){
				  	udt_mng_id 	= udt_mng_bean_s.getUser_id();
					udt_mng_nm 	= udt_mng_bean_s.getDept_nm()+" "+udt_mng_bean_s.getUser_nm()+" "+udt_mng_bean_s.getUser_pos();  		
			 		udt_mng_tel = udt_mng_bean_s.getHot_tel();
				  	udt_firm 	= "������ ����������"; 
			 		udt_addr 	= "����� �������� �������� 34�� 9";   
			  	}else if(pur.getUdt_st().equals("2")){
			  		udt_mng_id 	= udt_mng_bean_b2.getUser_id();
			 		udt_mng_nm 	= udt_mng_bean_b2.getDept_nm()+" "+udt_mng_bean_b2.getUser_nm()+" "+udt_mng_bean_b2.getUser_pos(); 
			  		udt_mng_tel = udt_mng_bean_b2.getHot_tel();
			  		udt_firm 	= "������TS"; 
			  		udt_addr 	= "�λ�� ������ �ȿ���7������ 10(���굿 363-13����)";			  		  	
			  	}else if(pur.getUdt_st().equals("3")){
			  		udt_mng_id 	= udt_mng_bean_d.getUser_id();
			 		udt_mng_nm 	= udt_mng_bean_d.getDept_nm()+" "+udt_mng_bean_d.getUser_nm()+" "+udt_mng_bean_d.getUser_pos(); 
			  		udt_mng_tel = udt_mng_bean_d.getHot_tel();
			  		udt_firm 	= "�̼���ũ"; 
			 		udt_addr 	= "���������� ������ ��õ�Ϸ�59���� 10(���� 690-3)";     	
			  	}else if(pur.getUdt_st().equals("5")){
			  		udt_mng_id 	= udt_mng_bean_g.getUser_id();
			 		udt_mng_nm 	= udt_mng_bean_g.getDept_nm()+" "+udt_mng_bean_g.getUser_nm()+" "+udt_mng_bean_g.getUser_pos(); 
			  		udt_mng_tel = udt_mng_bean_g.getHot_tel();
			  		udt_firm 	= "�뱸 ������"; 
			 		udt_addr 	= "�뱸������ �޼��� �Ŵ絿 321-86";  
			  	}else if(pur.getUdt_st().equals("6")){
			  		udt_mng_id 	= udt_mng_bean_j.getUser_id();
			 		udt_mng_nm 	= udt_mng_bean_j.getDept_nm()+" "+udt_mng_bean_j.getUser_nm()+" "+udt_mng_bean_j.getUser_pos(); 
			  		udt_mng_tel = udt_mng_bean_j.getHot_tel();
			  		udt_firm 	= "������ڵ�����ǰ��"; 
			 		udt_addr 	= "���ֱ����� ���걸 �󹫴�� 233 (������ 1360)";     	
			  	}else if(pur.getUdt_st().equals("4")){
			  		udt_mng_id 	= client.getClient_id();
			 		udt_mng_nm 	= client.getCon_agnt_dept()+" "+client.getCon_agnt_nm()+" "+client.getCon_agnt_title();
			  		udt_mng_tel = client.getO_tel();
			  		udt_firm 	= client.getFirm_nm(); 
			 		udt_addr 	= client.getO_addr();     	
			 	}
			 	
			 	String o_udt_firm = cpd_bean.getUdt_firm(); 
				cpd_bean.setUdt_st			(pur.getUdt_st());	
				cpd_bean.setUdt_firm		(udt_firm);	
				cpd_bean.setUdt_addr		(udt_addr);		
				cpd_bean.setUdt_mng_id		(udt_mng_id);	
				cpd_bean.setUdt_mng_nm		(udt_mng_nm);	
				cpd_bean.setUdt_mng_tel		(udt_mng_tel);	
				flag1 = cod.updateCarPurCom(cpd_bean);
				int cng_next_seq = cod.getCarPurComCngNextSeq(cpd_bean.getRent_mng_id(), cpd_bean.getRent_l_cd(), cpd_bean.getCom_con_no());
				CarPurDocListBean cng_bean = new CarPurDocListBean();
				cng_bean.setRent_mng_id		(cpd_bean.getRent_mng_id());
				cng_bean.setRent_l_cd		(cpd_bean.getRent_l_cd());
				cng_bean.setCom_con_no		(cpd_bean.getCom_con_no());
				cng_bean.setSeq				(cng_next_seq);
				cng_bean.setCng_st			("1");	
				cng_bean.setCng_cont		("�����");	
				cng_bean.setBigo			(o_udt_st_nm+"->"+n_udt_st_nm+" (������� �ڵ�����)");	
				cng_bean.setReg_id			(user_id);
				flag1 = cod.insertCarPurComCng(cng_bean);
				
				cont_udt_auto_cng_yn = "Y";
				
			}
		}	
		
		
		
	//��࿬�� ���
	}else if(cng_item.equals("no_cont")){
		
		
		//����� Ȯ��
		Hashtable cont_ht = a_db.getContCase(bean.getRent_l_cd());
		
		//�������
		ContPurBean pur = a_db.getContPur(String.valueOf(cont_ht.get("RENT_MNG_ID")), bean.getRent_l_cd());

		//���ݿ��� ���
		if(bean.getCon_amt() >0 && bean.getCon_amt() == pur.getCon_amt() && pur.getPur_pay_dt().equals("")){
			pur.setCon_amt		(0);
			pur.setCon_pay_dt	("");
			pur.setCon_bank		("");
			pur.setCon_acc_no	("");
			pur.setCon_acc_nm	("");
			pur.setTrf_st0		("");
			pur.setAcc_st0		("");
			pur.setCon_est_dt	("");
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		}
		
		
		bean.setRent_l_cd			("");	
		
		//update
		flag1 = cop_db.updateCarOffPre(bean);				
								
	}else if(cng_item.equals("pre_out")){
		
		bean.setPre_out_yn	(request.getParameter("pre_out_yn")	==null?"":request.getParameter("pre_out_yn"));
		//update
		flag1 = cop_db.updatePreOutYn(bean);
	
	//������� ���
	}else if(cng_item.equals("cls_restore")){
		
		//update
		flag1 = cop_db.updateCarOffPreClsRestore(bean.getSeq());
	
	}
	
	//�޽��� �߼�
	if(msg_yn.equals("Y") || target2_yn.equals("Y")){
	

			sub = "������� ����ȳ�";
			cont = "������� ������ ��ϵǾ����ϴ�.  &lt;br&gt; &lt;br&gt;  ���� : "+bean.getCar_nm()+",  &lt;br&gt; &lt;br&gt; �����ȣ : "+bean.getCom_con_no()+",  &lt;br&gt; &lt;br&gt; ������ : "+bean.getBus_nm()+",  &lt;br&gt; &lt;br&gt; ���� : "+bean.getFirm_nm();
			
			//�����
			UsersBean target_bean 	= new UsersBean();
			if(!bean.getBus_nm().equals("")){
				target_bean = umd.getUserNmBusBean(bean.getBus_nm());
			}
			
	
			//��޽��� �޼��� ����------------------------------------------------------------------------------------------
				
			String url 	 = "/fms2/pur_com_pre/pur_pre_c.jsp?seq="+seq;
			String m_url = "/fms2/pur_com_pre/pur_pre_frame.jsp";
			String xml_data = "";
			
			String xml_data_target = "";
 			if(cng_item.equals("res_c")){ 				
				sub = "������� �������";
				cont = "������� ������ ��ҵǾ����ϴ�.  &lt;br&gt; &lt;br&gt; ���� : "+bean.getCar_nm()+",  &lt;br&gt; &lt;br&gt; �����ȣ : "+bean.getCom_con_no()+",  &lt;br&gt; &lt;br&gt; ������ : "+bean.getBus_nm()+",  &lt;br&gt; &lt;br&gt; ���� : "+bean.getFirm_nm();
 			}else if(cng_item.equals("res_conf")){	
				sub = "������� �ɻ�Ϸ�";
				cont = "������Ʈ ������� ������ �ɻ�Ϸ�Ǿ����ϴ�.  &lt;br&gt; &lt;br&gt; ���� : "+bean.getCar_nm()+",  &lt;br&gt; &lt;br&gt; �����ȣ : "+bean.getCom_con_no()+",  &lt;br&gt; &lt;br&gt; ������ : "+bean.getBus_nm()+",  &lt;br&gt; &lt;br&gt; ���� : "+bean.getFirm_nm();
				UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����"));
				xml_data_target = "    <TARGET>"+target_bean3.getId()+"</TARGET>";
 			}else{
				xml_data_target = "    <TARGET>"+target_bean.getId()+"</TARGET>";
			}
						
			xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	 
 			
			//���� �������� ���������ô����(������)���� �޽��� �߼�
			if(target2_yn.equals("Y")){
				UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("���������"));
				
				if(!target_bean3.getUser_id().equals(ck_acar_id)){
					xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";					
				}
			}
			
			if(msg_yn.equals("Y")){
				xml_data += xml_data_target;
			}
				
			xml_data += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			System.out.println("��޽���(�������)"+cont+"-----------------------"+target_bean.getUser_nm());
			
			flag2 = cm_db.insertCoolMsg(msg);
		
			if(!bean.getRent_l_cd().equals("") && !cng_item.equals("res_conf")){
			
				//����� Ȯ��
				Hashtable cont_ht = a_db.getContCase(bean.getRent_l_cd());
				
				//���⺻����
				ContBaseBean base = a_db.getCont(String.valueOf(cont_ht.get("RENT_MNG_ID")), bean.getRent_l_cd());
				
				//������Ʈ ���Ƿ������� ��û
				if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
							
					UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
					String sendphone 	= sender_bean.getUser_m_tel();
					String sendname 	= "(��)�Ƹ���ī "+sender_bean.getUser_nm();
					String msg_cont		= AddUtil.replace(cont,"&lt;br&gt; &lt;br&gt;","\n\n");
					CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
					String destname 	= a_coe_bean.getEmp_nm();
					String destphone = a_coe_bean.getEmp_m_tel();
			
					IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", msg_cont);
				}	
			}
		
	}

%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('���������� ó�� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%}%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>   
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page'	   value='<%=from_page%>'>   
  <input type='hidden' name='seq'  value='<%=seq%>'>  
  <input type='hidden' name='opt1' 		value='<%=opt1%>'>
  <input type='hidden' name='opt2' 		value='<%=opt2%>'>
  <input type='hidden' name='opt3' 		value='<%=opt3%>'>
  <input type='hidden' name='opt4' 		value='<%=opt4%>'>
  <input type='hidden' name='opt5' 		value='<%=opt5%>'>
  <input type='hidden' name='opt6' 		value='<%=opt6%>'>
  <input type='hidden' name='opt7' 		value='<%=opt7%>'>
  <input type='hidden' name='e_opt1' 	value='<%=e_opt1%>'>
  <input type='hidden' name='e_opt2' 	value='<%=e_opt2%>'>
  <input type='hidden' name='e_opt3' 	value='<%=e_opt3%>'>
  <input type='hidden' name='e_opt4' 	value='<%=e_opt4%>'>
  <input type='hidden' name='e_opt5' 	value='<%=e_opt5%>'>
  <input type='hidden' name='e_opt6' 	value='<%=e_opt6%>'>
  <input type='hidden' name='e_opt7' 	value='<%=e_opt7%>'>
  <input type='hidden' name='ready_car' value='<%=ready_car%>'>
  <input type='hidden' name='eco_yn' value='<%=eco_yn%>'>
</form>
<script language='javascript'>
<%if(cng_item.equals("res_i")&& msg_yn.equals("RESERVE")){%>
	alert("�̹� ��ϵ� ���೻���� �ֽ��ϴ�.\n\n�������� ���ΰ�ħ ���ּ���.");
<%}else{%>
	<%if(flag1){%>
	<%	if(cont_udt_auto_cng_yn.equals("Y")){%>
		alert('�����(�μ���)�� �ڵ�����Ǿ����ϴ�. �븮���� �� ��ȭ�Ͽ� Ź�� �μ��� ������û�ϼž� �մϴ�.');
	<%	}else{%>
		alert('ó���Ǿ����ϴ�.');
	<%	}%>
	<%}%>
<%}%>
	<%if(cng_item.equals("res_c")){//�ٷ�ó��%>
	<%}else{%>
	parent.self.close();
	<%}%>	
	var fm = document.form1;	
	fm.action = 'pur_pre_c.jsp';
	fm.target = 'd_content';
	fm.submit();
	
</script>
</body>
</html>