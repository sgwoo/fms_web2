<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.* " %>
<%@ page import="acar.secondhand.*, acar.estimate_mng.*, acar.res_search.*, acar.car_register.*" %>
<%@ page import="acar.accid.*, acar.car_service.*"%>
<jsp:useBean id="shDb" 	class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="shBn" 		class="acar.secondhand.SecondhandBean" 		scope="page"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="session"/>
<jsp:useBean id="e_bean" 	class="acar.estimate_mng.EstimateBean" 		scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	EstiDatabase e_db 		= EstiDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	LoginBean login 		= LoginBean.getInstance();

	String auth_rw 			= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 				= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 			= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String res_yn 				= request.getParameter("res_yn")==null?"":request.getParameter("res_yn");
	String res_mon_yn		= request.getParameter("res_mon_yn")==null?"":request.getParameter("res_mon_yn");

	String est_st 				= request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String fee_opt_amt 		= request.getParameter("fee_opt_amt")==null?"":request.getParameter("fee_opt_amt");
	String fee_rent_st 		= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");

	String est_id 				= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String spe_seq 			= request.getParameter("spe_seq")==null?"":request.getParameter("spe_seq");
	String est_table 			= request.getParameter("est_table")==null?"":request.getParameter("est_table");
	String from_page 		= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String list_from_page 	= request.getParameter("list_from_page")==null?"":request.getParameter("list_from_page");

	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	String car_mng_id 		= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id 		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 			= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String br_to_st 			= request.getParameter("br_to_st")==null?"":request.getParameter("br_to_st");
	
	//�����������
	if (!car_mng_id.equals("")) {
		cr_bean = crd.getCarRegBean(car_mng_id);
	}

	//����Ʈ�������� �縮�������� ����
	if (from_page.equals("/fms2/lc_rent/lc_rm_frame.jsp")) {
		rent_mng_id = "";
		rent_l_cd = "";
		est_st = "1";
	}

	//���
	Vector vt = oh_db.getServCarHisList(car_mng_id);
	int vt_size = vt.size();

	//�������
	ShResBean srBn = shDb.getShRes(car_mng_id);

	Vector sr = shDb.getShResList(car_mng_id);
	int sr_size = sr.size();

	Vector srh = shDb.getShResHList(car_mng_id);
	int srh_size = srh.size();

	//�������� ��������
	Hashtable reserv = rs_db.getResCarCase(car_mng_id, "2");
	String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	
	//�������� ������Ȳ
	Vector conts = rs_db.getResCarList(car_mng_id);
	int cont_size = conts.size();
	
	int cont_size2 = 0;
	for (int i = 0; i < cont_size; i++) {
		Hashtable reservs2 = (Hashtable)conts.elementAt(i);
		if (String.valueOf(reservs2.get("USE_ST")).equals("����")) {
			cont_size2++;
		}
	}
		
	if (use_st.equals("null") && cont_size2 == 1) {
		reserv = rs_db.getResCarCase(car_mng_id, "1");
		use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
		cont_size = 0;
	}

	//�ֱ� Ȩ������ ����뿩�� ��������Ÿ� 10000 - �⺻
	Hashtable hp = oh_db.getSecondhandCase_20090901("", "", car_mng_id);	
	
	//�ֱ� Ȩ������ ����뿩�� ��������Ÿ� 20000
	Hashtable hp_2d = oh_db.getSecondhandCaseDist("", "", car_mng_id, "20000");	

	//�ֱ� Ȩ������ ����뿩�� ��������Ÿ� 30000
	Hashtable hp_3d = oh_db.getSecondhandCaseDist("", "", car_mng_id, "30000");

	//�ֱ� Ȩ������ ����뿩�� ��������Ÿ� 40000
	Hashtable hp_4d = oh_db.getSecondhandCaseDist("", "", car_mng_id, "40000");

	//�ֱ� Ȩ������ ����뿩�� - ���뿩��
	Hashtable hp2 = oh_db.getSecondhandCaseRm("", "", car_mng_id);

	//�ڻ�������
	Hashtable ht_ac = shDb.getCarAcInfo(car_mng_id);

	//��������	
	Hashtable ht = shDb.getShBase(car_mng_id);

	String car_comp_id			= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_cd					= String.valueOf(ht.get("CAR_CD"));
	String car_id					= String.valueOf(ht.get("CAR_ID"));
	String car_seq					= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 						= String.valueOf(ht.get("S_ST"));
	String jg_code 				= String.valueOf(ht.get("JG_CODE"));
	String car_no 					= String.valueOf(ht.get("CAR_NO"));
	String car_name				= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 			= String.valueOf(ht.get("INIT_REG_DT"));
	String car_y_form			= String.valueOf(ht.get("CAR_Y_FORM"));
	String secondhand_dt 		= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 				= String.valueOf(ht.get("PARK"));
	String dlv_dt 					= String.valueOf(ht.get("DLV_DT"));
	String before_one_year		= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 				= String.valueOf(ht.get("TOT_DIST"));
	String today_dist 			= String.valueOf(ht.get("TODAY_DIST"));
	today_dist 						= String.valueOf(ht.get("TOT_DIST")); //20170629 ��������Ÿ� �������� �����Ѵ�.
	String serv_dt	 				= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 				= String.valueOf(ht.get("LPG_YN"));
	String opt		 				= String.valueOf(ht.get("OPT"));
	String colo		 				= String.valueOf(ht.get("COL"));
	String add_opt	 			= String.valueOf(ht.get("ADD_OPT"));
	int car_amt 					= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 					= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 						= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int accid_serv_amt1			= AddUtil.parseInt((String)ht.get("ACCID_SERV_AMT1"));
	int accid_serv_amt2			= AddUtil.parseInt((String)ht.get("ACCID_SERV_AMT2"));
	int add_opt_amt				= AddUtil.parseInt((String)ht.get("ADD_OPT_AMT"));
	String jg_opt_st	 			= String.valueOf(ht.get("JG_OPT_ST"));
	String jg_col_st	 			= String.valueOf(ht.get("JG_COL_ST"));
	String jg_tuix_st	 			= String.valueOf(ht.get("JG_TUIX_ST"));
	String jg_tuix_opt_st		= String.valueOf(ht.get("JG_TUIX_OPT_ST"));
	String lkas_yn	 				= String.valueOf(ht.get("LKAS_YN"));
	String ldws_yn		 		= String.valueOf(ht.get("LDWS_YN"));
	String aeb_yn	 				= String.valueOf(ht.get("AEB_YN"));
	String fcw_yn	 				= String.valueOf(ht.get("FCW_YN"));
	String hook_yn		 		= String.valueOf(ht.get("HOOK_YN"));
	String legal_yn		 		= String.valueOf(ht.get("LEGAL_YN"));	
	String max_use_mon	 	= String.valueOf(hp.get("MAX_USE_MON"));
	
	//���� ���Ҽ� ����� �߰�(2017.10.13)
	int tax_dc_amt	 			= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));
	
	//�߰����ܰ�����
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(jg_code, "");
	
	//ģȯ���� ���� üũ ���� ����
	String jg_g_7 = String.valueOf(ej_bean.getJg_g_7());

	//������� ����Ⱓ(����)
	Hashtable carOld = c_db.getOld(init_reg_dt);
	//�縮����� ����Ⱓ
	Hashtable carOld2 = c_db.getOld(secondhand_dt);
	//����Ÿ���� ����Ⱓ
	Hashtable carOld3 = c_db.getOld(serv_dt);
	//������� ����Ⱓ2(���ɸ�����2����������)
	Hashtable carOld4 = new Hashtable();
	if (cr_bean.getCar_end_yn().equals("Y")) {
		carOld4 = c_db.getOld(init_reg_dt, cr_bean.getCar_end_dt(), "-60");
		if (!ej_bean.getJg_b().equals("2")) {
			carOld4 = c_db.getOld(init_reg_dt, cr_bean.getCar_end_dt(), "-30"); //20150120 ���������ϱ���	-> 20150217 LPG�� 2����������, ��LPG�� 1����������
		}
	}

	//�縮�����ݰ�������
	String readonly = "";
	if(!nm_db.getWorkAuthUser("�縮�����ݰ���",user_id)) readonly = "readonly";

	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();

	if (jg_code.equals("")) {
		ej_bean.setJg_a(s_st);
	}

	int mon[] = new int[18];
	mon[0] = 36;
	mon[1] = 24;
	mon[2] = 12;
	mon[3] = 6;

	//����Ȱ������� ����
	if (est_table.equals("esti_spe")) {
		e_bean = e_db.getEstimateSpeCarCase(est_id, spe_seq);
	}

	//������ ����
	CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;
	
	String rb_max = "0";
	String rs_max = "0";
	String lb_max = "0";
	String ls_max = "0";
	
	String amt1 = "0";
	String amt2 = "0";
	String amt3 = "0";
	String amt4 = "0";
	String amt_id1 = "";
	String amt_id2 = "";
	String amt_id3 = "";
	String amt_id4 = "";
	
	String to_amt1 = "0";
	String to_amt2 = "0";
	String to_amt3 = "0";
	String to_amt4 = "0";
	
	Hashtable estiCommVarSh = oh_db.getEstiCommVarSh();
	
	/* 0.���� 1.���� 2.�뱸 3.���� 4.�λ� */
	/*
	1.���������� 2.�������� 4.�������� 5.�ſ����� 6.��Ÿ 7.�λ�ΰ� 8.�����̵� 9.�������� 10.����ũ�� 
	11.������ȣ 12.�������� 13.�뱸���� 14.�������ͽ� 16.��ȭ����ũ 18.�����ڵ��� 19.Ÿ�̾���Ÿ�� 20.��������
	21.�Ƹ������ͽ�
	*/
	
	String br_from = "";
	String br_to = "";
	//����ġ
	if (park.equals("1") || park.equals("2") || park.equals("5") || park.equals("10") || park.equals("14") || park.equals("16") || park.equals("18") || park.equals("19") || park.equals("21")) {
		br_from = "0";		//����
	} else if (park.equals("4") || park.equals("9") || park.equals("11")) {
		br_from = "1";		//����
	} else if (park.equals("13") || park.equals("20")) {
		br_from = "2";		//�뱸
	} else if (park.equals("12")) {
		br_from = "3";		//����
	} else if (park.equals("3") || park.equals("7") || park.equals("8")) {
		br_from = "4";		//�λ�
	}
	
	//���ּ���
	if (park.equals("6")) {
		br_from = "0";		//����
		br_to = "0";
	} else {
		if (!br_to_st.equals("")) {
			if (br_to_st.equals("0") || br_to_st.equals("5")) {
				br_to = "0";
			} else {
				br_to = br_to_st;
			}
		} else {
			br_to = br_from;
		}
	}
	
	int br_cons = AddUtil.parseInt((String)estiCommVarSh.get("BR_CONS_" + br_from + br_to));	
	
	for (int i = 0; i < 4; i++) {
		if (i == 0) {
			to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
			to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
			to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
			//amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
		} else if (i == 1) {
			to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
			to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
			to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
			//amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));			
		} else if (i == 2) {
			to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
			to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
			to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
			//amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
		} else if (i == 3) {
			to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
			to_amt3 = "0";
			to_amt4 = "0";
			//amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
		}
	}
	
	/* System.out.println("###############");
	System.out.println("br_to_st = " + br_to_st);
	System.out.println("----------------------------");
	System.out.println("br_from = " + br_from);
	System.out.println("br_to = " + br_to);
	System.out.println("br_cons = " + br_cons);
	System.out.println("###############"); */
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style type="text/css">
 .col_0{	background-color: #FFFFFF;	}
 .col_1{	background-color: #FFB2D9;	}
 .col_2{	background-color: #FAED7D;	}
 .col_3{	background-color: #86E57F;	}
 .col_4{	background-color: #B2CCFF;	}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//������Ȳ ���γ��� ��ȸ
	function view_rentcont(use_st, rent_s_cd){
		var SUBWIN="/acar/res_stat/res_rent_u.jsp?mode=view&c_id=<%=car_mng_id%>&s_cd="+rent_s_cd;
		if(use_st == '����'){
			SUBWIN="/acar/rent_mng/res_rent_u.jsp?mode=view&c_id=<%=car_mng_id%>&s_cd="+rent_s_cd;
		}
		window.open(SUBWIN, "view_rentcont", "left=5, top=50, width=1000, height=650, scrollbars=yes, status=yes");
	}

	//�����̷�
	function view_sh_res_h(){
		var SUBWIN="reserveCarHistory.jsp?car_mng_id=<%=car_mng_id%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}

	//��������� �����صα�
	function reserveCar(){
		var fm = document.form1;
		var SUBWIN="reserveCar.jsp?from_page=<%=from_page%>&car_mng_id=<%=car_mng_id%>&user_id=<%=user_id%>&situation=<%=srBn.getSituation()%>&damdang_id=<%=srBn.getDamdang_id()%>&reg_dt=<%=srBn.getReg_dt()%>&ret_dt="+fm.ret_dt.value;
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=520, height=600, scrollbars=no, status=yes");
	}

	//����޸�����ϱ�
	function reserveCarM(seq, situation, memo, cust_nm, cust_tel, damdang_id){
		var fm = document.form1;
		var SUBWIN="reserveCarM.jsp?from_page=<%=from_page%>&user_id=<%=user_id%>&car_mng_id=<%=car_mng_id%>&seq="+seq+"&situation="+situation+"&memo="+memo+"&cust_nm="+cust_nm+"&cust_tel="+cust_tel+"&damdang_id="+damdang_id;
		window.open(SUBWIN, "reserveCar", "left=250, top=250, width=520, height=500, scrollbars=no, status=yes");
	}

	//��������ϱ�
	function cancelCar(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("������ ��� �Ͻðڽ��ϱ�?"))	return;
		fm.action = "cancelCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//���࿬���ϱ�
	function reReserveCar(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("������ ���� �Ͻðڽ��ϱ�?"))	return;
		fm.action = "reReserveCar.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//���� �����Ⱓ �����ϱ�
	function reReserveCar2(car_mng_id, seq, situation, damdang_id, shres_reg_dt){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		if(!confirm("����Ⱓ�� ���������Ͽ�����+3�Ϸ� ���� �Ͻðڽ��ϱ�?"))	return;
		fm.action = "reReserveCar2.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//���Ȯ������ ��ȯ�ϱ�
	function reserveCar2Cng(car_mng_id, seq, situation, damdang_id, shres_reg_dt, shres_cust_nm, shres_cust_tel){
		var fm = document.form1;
		fm.shres_seq.value = seq;
		fm.situation.value = situation;
		fm.damdang_id.value = damdang_id;
		fm.shres_reg_dt.value = shres_reg_dt;
		fm.shres_cust_nm.value = shres_cust_nm;
		fm.shres_cust_tel.value = shres_cust_tel;
		if(!confirm("����߿��� ���Ȯ������ ��ȯ �Ͻðڽ��ϱ�?"))	return;
		fm.action = "reserveCar2cng.jsp";
		fm.target = "i_no";
		fm.submit();
	}

	//�ڵ���������� ����
	function view_car() {
		window.open("/acar/car_register/car_view.jsp?car_mng_id=<%=car_mng_id%>&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}

	//�������� ����
	function view_car_nm(car_id, car_seq) {
		window.open("/acar/car_mst/car_mst_u.jsp?car_id="+car_id+"&car_seq="+car_seq, "VIEW_CAR_NM", "left=100, top=100, width=875, height=675, scrollbars=yes");
	}

	//�߰������� ����ϱ�-���
	function getSecondhandCarAmt_h() {
		var fm = document.form1;
		fm.mode.value = 'account';
		fm.action = "getSecondhandBaseSet.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//�߰������� ����ϱ�
	function getSecondhandCarAmt(){
		var fm = document.form1;
		window.open("getSecondhandBaseSet.jsp?car_mng_id=<%=car_mng_id%>&est_st=<%=est_st%>&fee_opt_amt=<%=fee_opt_amt%>&rent_st=1&mode=view", "VIEW_SH_CAR_AMT", "left=100, top=100, width=900, height=800, scrollbars=yes");
	}

	//����
	function EstiMate(st, value, nm, a_a, rent_way, a_b, target,agree_dist){
		var fm = document.form1;

		<%if(jg_code.equals("")){%>
		alert('�����ڵ尡 �����ϴ�.\n\n������ �ȵ˴ϴ�.');
		return;
		<%}%>
		
		if(st != '1' && a_a == '1' && a_b < 12){
			alert('������ �ּҰ����� 12�����Դϴ�.');
			return;
		}
		
		if((st == '2' || st == '3') && rent_way == '2' && a_a == '2' && Number(a_b) < 12){
			alert('�� �緻Ʈ �뿩�Ⱓ 12���� �̸��� �Ϲݽ�(��������) ��ǰ�� �����մϴ�.\n �⺻��(���������) ��ǰ�� 12���� �̻���� �����մϴ�.');
			return;
		}  
		
		if (fm.br_to_st.value == "") {
			alert("���ּ���(�����ε�����)�� ���� ���ּ���.");
			return;
		} else {			
			if (fm.br_to_st.value == "" || fm.br_to_st.value == "5") {
				fm.br_to.value = "0";
			} else {
				fm.br_to.value = fm.br_to_st.value;
			}
		}
		
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		//���λ�����϶� �������� �Ǿ������� ���� �Ǵ� �̰������� �����ϵ��� ����
		var doc_type_value = $('select[name="doc_type"] option:selected').val();
		if (doc_type_value == "2") {
    	    if (fm.com_emp_yn.value == "") {
    	    	alert("������ ��������Ư�� ���� ���θ� �������ּ���.\n\n���ǽŰ�Ȯ�δ����, ���������� ���λ���ڴ� 2021��1��1�� ���ĺ��� ���������ڵ������迡 �����Ͽ��� �մϴ�. ��, ����ں� 1��� ���������ڵ������� ���Դ�󿡼� ����, 1�븦 ������ ������ ���� ���������ڵ������� �̰��� �� ����� 50%�� �����˴ϴ�.\n\n�ڼ��� ������ Ȩ������ �ϴ� [�պ�ó�� ����]�� �������ּ���.");
    			return;
    	  	}
        }
		<%}%>

		if(fm.apply_secondhand_price.value == '' || fm.apply_secondhand_price.value == '0'){
			alert('�縮������������ ������ �ʾҽ��ϴ�.\n\n������ ���������忡�� �����Ͻʽÿ�.');
			return;
		}

		if(value == '�����Ұ�' || value == '��Ʈ�Ұ�'){ alert(value); return; }
		
		//������ ���������
		<%if(AddUtil.parseInt(car_comp_id) > 5){%>
			if(st == '1'){
				if(!confirm("���������� ����� ���� �������� �����Ϸ��� ��� ��������� ���������� �þƾ� �մϴ�.\n\n���������� �����̽��ϱ�?"))	return;
			}
		<%}%>

		fm.esti_nm.value 	= nm;
		fm.a_a.value 		= a_a+""+rent_way;
		fm.a_b.value 		= a_b;
		fm.st.value 		= st;
		fm.agree_dist.value 		= agree_dist;

		fm.pp_st.value 	= '2';
		fm.rg_8.value 	= '25'; //20->30(20081216)->25(20090117)


		if(st == 'all'){
			fm.pp_st.value 	= '2';
			fm.rg_8.value 	= '25'; //20->30(20081216)->25(20090117)
		}else{
			//����Ÿ� �Է±Ⱓ üũ
			if('<%=serv_dt%>' != ''){
				var serv_mon = <%= carOld3.get("YEAR") %>*12+<%= carOld3.get("MONTH") %>;
				if(serv_mon >6){
					if(!confirm("����Ÿ� ���� �Է��Ϸκ��� "+serv_mon+"������ ����Ͽ����ϴ�.\n\n���� ��������Ÿ��� ������ �Ұ�� ����Ȯ�� ����� ����˴ϴ�.\n\n�����Ͻðڽ��ϱ�?"))	return;
				}
				if(st == '2' || st == '3' || st == '4'){
					var serv_days = (<%= carOld3.get("YEAR") %>*365)+(<%= carOld3.get("MONTH") %>*30)+<%= carOld3.get("DAY") %>;
					if(serv_days >7){
						if(!confirm("����Ÿ�Ȯ�����ڷκ��� 7���̻�("+serv_days+"��) ����Ͽ����ϴ�. \n\n���� ����Ÿ��� ������ �Ұ�� ����Ȯ�� ����� ����˴ϴ�. \n\n�� ����Ÿ��� Ȯ���� �縮�� �������� ���� �ִ� ������ ��Ͽ� ������Ÿ��� ����ϰ� �����ϼ���.\n\n������Ÿ� ����� �̶� �����Ͻðڽ��ϱ�?"))	return;
					}
				}
				
			}
		}

		fm.target = target;
		fm.action = 'esti_mng_i_20090901.jsp';
		fm.submit();
	}

	//����Ʈ ����
	function EstiMateRm(st, value, nm, a_a, rent_way, a_b, days, target){
		var fm = document.form1;

		<%if(jg_code.equals("")){%>
		alert('�����ڵ尡 �����ϴ�.\n\n������ �ȵ˴ϴ�.');
		return;
		<%}%>		

		if(value == '�����Ұ�' || value == '��Ʈ�Ұ�'){ alert(value); return; }

		fm.esti_nm.value 	= nm;
		fm.a_a.value 		  = a_a+""+rent_way;
		fm.a_b.value 		  = a_b;
		fm.st.value 		  = st;
		fm.months.value		= a_b;
		fm.days.value 		= days;

		//������
		var amt_per = 0;
		if(toInt(fm.months.value)==1){
			amt_per 	= (4 / 100) * toInt(fm.days.value) / 30;
		}
		if(toInt(fm.months.value)==2){
			amt_per 	= (4 / 100) + ((2 / 100)*toInt(fm.days.value) / 30);
		}
		if(toInt(fm.months.value) > 2){
			amt_per 	= 6 / 100;
		}
		amt_per 			= parseDecimal(amt_per * 1000) / 1000;
		fm.per_rm.value	= amt_per;

		//������뿩��
		fm.tot_rm.value 	= <%=hp2.get("RM1")%> * (1-amt_per);
		fm.tot_rm.value 	= hun_th_rnd(toInt(fm.tot_rm.value));
		
		//����뿩��
		fm.tot_rm1.value 	= ( toInt(fm.tot_rm.value)*toInt(fm.months.value) ) + ( toInt(fm.tot_rm.value) / 30 * toInt(fm.days.value) );
		fm.tot_rm1.value 	= hun_th_rnd(toInt(fm.tot_rm1.value));

		//����Ÿ� �Է±Ⱓ üũ
		<%if(!serv_dt.equals("")){%>
			var serv_mon = <%= carOld3.get("YEAR") %>*12+<%= carOld3.get("MONTH") %>;
			if(serv_mon >6){
				if(!confirm("����Ÿ� ���� �Է��Ϸκ��� "+serv_mon+"������ ����Ͽ����ϴ�.\n\n���� ��������Ÿ��� ������ �Ұ�� ����Ȯ�� ����� ����˴ϴ�.\n\n�����Ͻðڽ��ϱ�?"))	return;
			}
		<%}%>

		fm.target = target;
		fm.action = 'esti_mng_i_20120614_rm_a.jsp';
		fm.submit();
	}

	//��ü����
	function show_all(){
		var fm = document.form1;

		<%if(jg_code.equals("")){%>
		alert('�����ڵ尡 �����ϴ�.\n\n������ �ȵ˴ϴ�.');
		return;
		<%}%>
		
		/* if (fm.br_to_st.value == "") {
			alert("���ּ���(�����ε�����)�� ���� ���ּ���.");
			return;
		} else {			
			if (fm.br_to_st.value == "" || fm.br_to_st.value == "5") {
				fm.br_to.value = "0";
			}
		} */
		if (fm.br_to_st.value == "") {
			fm.br_to.value = fm.br_from.value;
		} else if (fm.br_to_st.value == "5") {
			fm.br_to.value = "0";
		}
		
		fm.target = 'i_no';
		fm.action = "sp_esti_reg_sh.jsp";
		fm.submit();
	}

	//��ü��������
	function estimates_view(reg_code, car_mng_id) {
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?est_code="+reg_code+"&car_mng_id="+car_mng_id+"&esti_table=estimate_sh";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}

	//��ü��������
	function estimates_view_rm(reg_code, car_mng_id) {
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901_rm.jsp?est_code="+reg_code+"&car_mng_id="+car_mng_id+"&esti_table=estimate_sh";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}

	//�������μ�
	function EstiPrint(a_a, rent_way, a_b, amt, est_id) {
		var check = confirm_serv_mon('2');
		
 		if (check == true) {
			var fm = document.form1;			
			if (fm.br_to_st.value == "") {
				alert("���ּ���(�����ε�����)�� ���� ���ּ���.");
				return;
			} else {			
				if (fm.br_to_st.value == "" || fm.br_to_st.value == "5") {
					fm.br_to.value = "0";
				}
			}
			var br_to = fm.br_to.value;
			var br_from = fm.br_from.value;
			var SUBWIN="/acar/secondhand_hp/estimate.jsp?from_page=secondhand_hp&car_mng_id=<%= car_mng_id %>&today_dist=<%=hp.get("REAL_KM")%>&o_1=<%=hp.get("APPLY_SH_PR")%>&rent_dt=<%=hp.get("UPLOAD_DT")%>&est_code=<%=hp.get("REG_CODE")%>&a_a="+a_a+""+rent_way+"&a_b="+a_b+"&amt="+amt+"&est_id="+est_id+"&br_from="+br_from+"&br_to="+br_to;
			window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes");
 		}	
	}

	function EstiPrintRm(a_a, rent_way, a_b, amt, est_id) {
		var fm = document.form1;
		var SUBWIN="/acar/secondhand_hp/estimate_rm_new.jsp?from_page=secondhand_hp&car_mng_id=<%= car_mng_id %>&today_dist=<%=hp2.get("REAL_KM")%>&o_1=<%=hp2.get("APPLY_SH_PR")%>&rent_dt=<%=hp2.get("UPLOAD_DT")%>&est_code=<%=hp2.get("REG_CODE")%>&a_a="+a_a+""+rent_way+"&a_b="+a_b+"&amt="+amt+"&est_id="+est_id;
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes");
	}

	//�������� ����
	function view_car_service(car_id) {
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=car_mng_id%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");
	}

	//�������������̷�
	function EstiHistory() {
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/rm_esti_history.jsp';
		fm.submit();
	}

	//���� ������ã��
	function search_cust() {
		var fm = document.form1;
		var SUBWIN="/acar/estimate_mng/search_cust_list.jsp?from_page=/acar/secondhand/secondhand_price_20090901.jsp&t_wd="+fm.cust_nm.value;
		window.open(SUBWIN, "SubCust", "left=10, top=10, width=1250, height=800, scrollbars=yes, status=yes");
	}

	//Ư������
	function reg_spe_dc() {
		var fm = document.form1;
		var SUBWIN="reg_spe_dc.jsp?user_id=<%=user_id%>&car_mng_id=<%=car_mng_id%>";
		window.open(SUBWIN, "RegSpeDc", "left=250, top=250, width=420, height=200, scrollbars=no, status=no");
	}

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	//�������������뺸�� ���Կ���
	function SetComEmpYn() {
		var fm = document.form1;
		
		<%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
		
		var doc_type_value = $('select[name="doc_type"] option:selected').val();
		var com_emp_yn_html = "";
		
		if (doc_type_value == "1") {
			com_emp_yn_html = "<option value='N'>�̰���</option>"+
										"<option value='Y' selected>����</option>";
					
			$("#com_emp_yn").html(com_emp_yn_html);
			
		} else if (doc_type_value == "2") {
			com_emp_yn_html = "<option value='' selected>����</option>"+
										"<option value='N'>�̰���</option>"+
										"<option value='Y'>����</option>";
										
			$("#com_emp_yn").html(com_emp_yn_html);
		} else {
			com_emp_yn_html = "<option value='N' selected>�̰���</option>"+
										"<option value='Y'>����</option>";
						
			$("#com_emp_yn").html(com_emp_yn_html);
		}
		
		if (fm.doc_type.value == "1") {
			fm.com_emp_yn.value = "Y";
		} else if (fm.doc_type.value == "2") {
			fm.com_emp_yn.value = "";
		} else {
			fm.com_emp_yn.value = "N";
		}
		<%}%>
	}

	//�⺻��纸���ֱ�
	function opt() {  
		var fm = document.form1;
		var SUBWIN="/acar/main_car_hp/opt.jsp?car_id=<%=car_id%>&car_seq=<%=car_seq%>&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=798, height=550, scrollbars=yes, status=yes, resizable=no");
	}
	
	//���� 4�� �������� ����(20180725)
	function go_esti_more() {
		var check = confirm_serv_mon('2');
		
 		if (check == true) {
	        var fm = document.form1 ;
	        
			if (fm.br_to_st.value == "") {
				alert("���ּ���(�����ε�����)�� ���� ���ּ���.");
				return;
			} else {			
				if (fm.br_to_st.value == "" || fm.br_to_st.value == "5") {
					fm.br_to.value = "0";
				}
			}
			window.open("", "esti_4_sh", "left=10, top=10, width=800, height=900, scrollbars=yes, status=yes, resizable=yes");
			
	        fm.target = "esti_4_sh" ;
	        fm.action = "/acar/secondhand_hp/estimate_comp_fms_sh.jsp";
	        fm.submit() ;
		}
	}
	
	//üũ�ڽ� üũ�� ���� �ٲٱ�/���� �Ķ���� ����(20180725)
	function change_td_col(num,val){
		var chk_cnt = $("input[name='go_esti_4']:checked").length;
		
		if($("#cb"+num).is(":checked")==true){	//üũ�� ���
			
			//���� üũ������ ������ �ִ��� üũ 
			if($("#cb_chk_off1").val()=="Y"){	//üũ������ ������ ù��° ���ð� �̾�����
				chk_cnt=1;						//�ٽ� üũ�ص� ù��° �������� ���
				$("#cb_chk_off1").val("");		//üũ���� ������ ����ó��
			}else if($("#cb_chk_off2").val()=="Y"){	//�ι�°
				chk_cnt=2;
				$("#cb_chk_off2").val("");
			}else if($("#cb_chk_off3").val()=="Y"){	//����°
				chk_cnt=3;
				$("#cb_chk_off3").val("");
			}else if($("#cb_chk_off4").val()=="Y"){	//�׹�°
				chk_cnt=4;
				$("#cb_chk_off4").val("");
			}
		
			//���� üũ������ ������ ������ �ٷ� ���⼭ ����(������� ��, �Ķ���� ����)		
			if(chk_cnt==1){
				$("#cb"+num).parents("td").addClass('col_1');
				$("#param1").val(val);
			}else if(chk_cnt==2){
				$("#cb"+num).parents("td").addClass('col_2');
				$("#param2").val(val);
			}else if(chk_cnt==3){
				$("#cb"+num).parents("td").addClass('col_3');
				$("#param3").val(val);
			}else if(chk_cnt==4){
				$("#cb"+num).parents("td").addClass('col_4');
				$("#param4").val(val);
			}else{
				alert("���� ������ �� 4�� ������ �����մϴ�.");
				$("#cb"+num).prop("checked",false);
				return false;
			}
			
		}else{	//üũ������ ���
			
			for(var i=1;i<=4;i++) {
				if($("#param"+i).val()==val){	//���� üũ�����Ϸ��°��� �ѱ� �Ķ���Ͱ��� ��
					$("#param"+i).val("");		//�ѱ� �Ķ���Ϳ��� ����				
					if($("#cb"+num).parents("td").hasClass('col_'+i)){	
						$("#cb_chk_off"+i).val("Y");	//���°�� ������ ���� üũ�����ߴ��� ����
						$("#cb"+num).parents("td").removeClass('col_'+i);	//�� ����
					}
				}
			}
		}
	}
	
	//üũ�ڽ� üũ �ʱ�ȭ(20180725)
	function reset_checkBox() {
		for(var i=1;i<=4;i++){
			$("#param"+i).val("");
			$("#cb_chk_off"+i).val("");
			$(".cb").parents("td").removeClass('col_'+i);
		}
		$("input[name='go_esti_4']:checked").each(function(){
			$(this).prop("checked",false);
		});
	}
	
	//����Ÿ�Ȯ������ ����� Ȯ��
	function confirm_serv_mon(st){
		var result = true;
		if(st == 'all'){
			fm.pp_st.value 	= '2';
			fm.rg_8.value 	= '25'; //20->30(20081216)->25(20090117)
		}else{
			//����Ÿ� �Է±Ⱓ üũ
			if('<%=serv_dt%>' != ''){
				var serv_mon = <%= carOld3.get("YEAR") %>*12+<%= carOld3.get("MONTH") %>;
				if(serv_mon >6){
					if(!confirm("����Ÿ� ���� �Է��Ϸκ��� "+serv_mon+"������ ����Ͽ����ϴ�.\n\n���� ��������Ÿ��� ������ �Ұ�� ����Ȯ�� ����� ����˴ϴ�.\n\n�����Ͻðڽ��ϱ�?"))	result = false;
				}
				if(st == '2' || st == '3' || st == '4'){
					var serv_days = (<%= carOld3.get("YEAR") %>*365)+(<%= carOld3.get("MONTH") %>*30)+<%= carOld3.get("DAY") %>;
					if(serv_days >7){
						if(!confirm("����Ÿ�Ȯ�����ڷκ��� 7���̻�("+serv_days+"��) ����Ͽ����ϴ�. \n\n���� ����Ÿ��� ������ �Ұ�� ����Ȯ�� ����� ����˴ϴ�. \n\n�� ����Ÿ��� Ȯ���� �縮�� �������� ���� �ִ� ������ ��Ͽ� ������Ÿ��� ����ϰ� �����ϼ���.\n\n������Ÿ� ����� �̶� �����Ͻðڽ��ϱ�?"))	result = false;
					}
				}
			}
		}
		return result;
	}
	
	//���ּ������ÿ� ���� ������ ���� �� �ݾ׺���
	function changeBrTo(str) {
		
		var fm = document.form1;
		
		if (str == "" || str == "5") {
			fm.br_to.value = fm.br_from.value;
		} else {
			fm.br_to.value = str;
		}
		
		var url = "auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>";		
			url = url + "&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&jg_code=<%=jg_code%>";		
			url = url + "&est_st=<%=est_st%>&fee_opt_amt=<%=fee_opt_amt%>&fee_rent_st=<%=fee_rent_st%>&est_id=<%=est_id%>&spe_seq=<%=spe_seq%>&est_table=<%=est_table%>&list_from_page=<%=list_from_page%>&br_to_st="+str;
			
		//fm.target = 'detail_body';
        //fm.action = "./secondhand_price_20090901.jsp";
        //fm.submit() ;
		parent.detail_body.location.href = "secondhand_price_20090901.jsp?"+url;
	}
	
	//�ҷ��� 
	function view_badcust()
	{
		var fm = document.form1;
	    if (fm.cust_nm.value == '') {
	    	alert('��ȣ �Ǵ� ������ �Է��Ͻʽÿ�');
	    	fm.cust.focus();
	    	return;
	    }	
		window.open('/acar/bad_cust/stat_badcust_list.jsp?badcust_chk_from=esti_mng_atype_i.jsp&est_nm='+fm.cust_nm.value+'&est_tel='+fm.cust_tel.value+'&est_mail='+fm.cust_email.value+'&est_fax='+fm.cust_fax.value, "BADCUST", "left=10, top=10, width=1400, height=900, resizable=yes, scrollbars=yes, status=yes");
		return;
	}	    	
	
	
//-->
</script>
</head>

<body>
<form name="form1" action="" method="POST" >
<input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
<input type="hidden" name="br_id" 		value="<%=br_id%>">
<input type="hidden" name="user_id" 		value="<%=user_id%>">
<input type="hidden" name="car_mng_id" 		value="<%=car_mng_id%>">
<input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type="hidden" name="a_e" 		value="<%=s_st%>">
<input type="hidden" name="car_no" 		value="<%=car_no%>">
<input type="hidden" name="init_reg_dt" 	value="<%=init_reg_dt%>">
<input type="hidden" name="before_one_year" 	value="<%=before_one_year%>">
<input type="hidden" name="real_km" 		value="<%=today_dist%>">
<input type="hidden" name="today_dist" 		value="<%=today_dist%>">
<input type="hidden" name="lpg_yn"	 	value="<%=lpg_yn%>">
<input type='hidden' name="est_st"		value="<%=est_st%>">
<input type='hidden' name="fee_opt_amt"		value="<%=fee_opt_amt%>">
<input type='hidden' name="fee_rent_st"		value="<%=fee_rent_st%>">
<input type='hidden' name="jg_code"		value="<%=jg_code%>">
<input type="hidden" name="reg_code"		value="<%=hp.get("REG_CODE")%>" id="reg_code">
<input type="hidden" name="upload_dt"		value="<%=hp.get("UPLOAD_DT")%>">
<input type="hidden" name="mode" 		value="">
<input type="hidden" name="st"	 		value="">
<input type="hidden" name="car_old_exp" 	value="">
<input type="hidden" name="apply_sh_pr" 	value="">
<input type="hidden" name="seq" 		value="">
<input type="hidden" name="compute" 		value="N">
<input type="hidden" name="detail" 		value="N">
<input type="hidden" name="car_name" value="<%=car_name%>" id="car_name">
<!--��������-->
<input type="hidden" name="esti_nm"		value="">
<input type="hidden" name="a_a"			value="">
<input type="hidden" name="a_b"			value="">
<input type="hidden" name="pp_st"		value="">
<input type="hidden" name="rg_8"		value="">
<!--��������-->
<input type="hidden" name="rent_st"		value="1"><!--�������縮��-->
<input type="hidden" name="spr_yn" 		value="1">
<input type="hidden" name="lpg_yn" 		value="0">
<input type="hidden" name="lpg_kit" 		value="">
<input type="hidden" name="a_h" 		value="1">
<input type="hidden" name="ins_dj" 		value="2">
<input type="hidden" name="ins_age" 		value="1">
<input type="hidden" name="ins_good" 		value="0">
<input type="hidden" name="gi_yn" 		value="0">
<input type="hidden" name="car_ja" 		value="300000">
<!--<input type="hidden" name="from_page" 		value="secondhand">-->
<input type="hidden" name="rent_dt" 		value="<%=AddUtil.getDate()%>">

<input type="hidden" name="situation" 		value="<%//=srBn.getSituation()%>">
<input type="hidden" name="damdang_id" 		value="<%//=srBn.getDamdang_id()%>">
<input type="hidden" name="shres_reg_dt" 	value="<%//=srBn.getReg_dt()%>">
<input type="hidden" name="shres_seq" 		value="">
<input type="hidden" name="shres_cust_nm" 		value="">
<input type="hidden" name="shres_cust_tel" 		value="">

<input type="hidden" name="est_id" 		value="<%=est_id%>">
<input type='hidden' name="spe_seq"		value="<%=spe_seq%>">
<input type='hidden' name="est_table"		value="<%=est_table%>">
<input type='hidden' name="from_page"		value="<%=from_page%>">
<input type='hidden' name="list_from_page" 	value="<%=list_from_page%>">
<input type='hidden' name="jg_w" 		value="<%=ej_bean.getJg_w()%>">
<!--����Ʈ-->
<input type="hidden" name="tot_rm"		value="">
<input type="hidden" name="tot_rm1"		value="">
<input type="hidden" name="per_rm"		value="">

<input type="hidden" name="agree_dist"	value="">

<input type="hidden" name="br_from"		value="<%=br_from%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
<%if(est_st.equals("")){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span>
            <%if(srh_size>0){%>
            &nbsp;&nbsp;<a href="javascript:view_sh_res_h()" title="�̷�"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a>&nbsp;(<%=srh_size%>��)
            <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="5%">����</td>
                    <td class="title" width="10%">�����</td>
                    <td class="title" width="10%">�����Ȳ</td>
                    <td class="title" width="15%">����Ⱓ</td>
                    <td class="title" width="35%">�޸�</td>
                    <td class="title" width="10%">�������</td>
                    <td class="title" width="15%">ó��</td>
                </tr>
                <%	int sh_res_reg_chk = 0;
                    for(int i = 0 ; i < sr_size ; i++){
                        Hashtable sr_ht = (Hashtable)sr.elementAt(i);

                        //20160119 ���Ȯ�����Ŀ��� �����Ҽ� �ִ�.
                        //if(String.valueOf(sr_ht.get("SITUATION")).equals("2")) sh_res_reg_chk = 1;
                %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>
                    <td align="center">
                    	<%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))				out.print("�����");
                    			else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))		out.print("���Ȯ��");
                   				else if(String.valueOf(sr_ht.get("SITUATION")).equals("3"))		out.print("��࿬��");
                    	%>
                    </td>
                    <td align="center">
                    	<%if(!String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>
                    	<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
                    	<%}%>
                    </td>
                    <td>&nbsp;
                    	<!--�޸����-->
                    	<%if(!String.valueOf(sr_ht.get("SITUATION")).equals("3") && !auth_rw.equals("1")){%><a href="javascript:reserveCarM('<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("MEMO")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>', '<%=sr_ht.get("DAMDANG_ID")%>');" title='�޸�����ϱ�'><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>&nbsp;<%}%>
                    	<%=sr_ht.get("CUST_NM")%>&nbsp;<%=sr_ht.get("CUST_TEL")%>&nbsp;<%=sr_ht.get("MEMO")%>
                    </td>
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %></td>
                    <td align="center">
                    	<%if(!String.valueOf(sr_ht.get("SITUATION")).equals("3") && !auth_rw.equals("1")){%>
                    	<%	if(user_id.equals(String.valueOf(sr_ht.get("DAMDANG_ID"))) || nm_db.getWorkAuthUser("������",user_id)){%>
                    	<%		if(i==0 && sh_res_reg_chk==0 && String.valueOf(sr_ht.get("SITUATION")).equals("0")){%>
                    	<!--����� ���Ȯ���� ��ȯ-->
                    	<a href="javascript:reserveCar2Cng('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>', '<%=sr_ht.get("CUST_NM")%>', '<%=sr_ht.get("CUST_TEL")%>');" title='�������� ���Ȯ���ϱ�'><img src=/acar/images/center/button_in_dec.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%		}%>
                    	<!--1ȸ����-->
                    	<%		if((i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("2") && AddUtil.parseInt(String.valueOf(sr_ht.get("ADD_CNT"))) == 0) || (i==0 && String.valueOf(sr_ht.get("SITUATION")).equals("0") && AddUtil.parseInt(String.valueOf(sr_ht.get("ADD_CNT_S"))) == 0)){%>
                    	<a href="javascript:reReserveCar('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='�������� �����ϱ�'><img src=/acar/images/center/button_in_yj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<%		}%>
                    	<!--�������-->
                    	<a href="javascript:cancelCar('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=sr_ht.get("REG_DT")%>');" title='�������� ����ϱ�'><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a>&nbsp;&nbsp;
                    	<!--���� �Ⱓ ����-->
                    	<%		if(i==0 && nm_db.getWorkAuthUser("������",user_id) && !use_st.equals("null") && !String.valueOf(reserv.get("RENT_ST")).equals("���") && AddUtil.parseInt(String.valueOf(sr_ht.get("RES_END_DT"))) < AddUtil.parseInt(String.valueOf(reserv.get("RET_DT2"))) ){%>
                    	<a href="javascript:reReserveCar2('<%=car_mng_id%>', '<%=sr_ht.get("SEQ")%>', '<%=sr_ht.get("SITUATION")%>', '<%=sr_ht.get("DAMDANG_ID")%>', '<%=reserv.get("RET_DT2")%>');" title='�������� �����Ⱓ �����ϱ�'>����</a>&nbsp;&nbsp;
                    	<%		}%>
                    	<%	}%>
                    	<%}%>
                    </td>
                </tr>
				        <%}%>
				        <%if(sr_size==0){%>
                <tr>
                    <td align="center" colspan="7">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
				        <%}%>
            </table>
	    </td>
    </tr>
	  <%if(sh_res_reg_chk == 0 && sr_size < 3){%>
    <tr>
        <td align="right">
            <a href="javascript:reserveCar();" title='���������ϱ�'><img src=/acar/images/center/button_cryy.gif align=absmiddle border=0></a>
        </td>
    </tr>
	  <%}%>
    <tr>
        <td>* ���Ȯ���� ��쿡 2ȸ���� ����Ⱓ�� �����Ҽ� �ֽ��ϴ�. ���� ���������� ������ �����Ͽ� 3���� ����˴ϴ�. ���Ȯ�� ����Ⱓ�� �������ڸ� �����մϴ�.</td>
    </tr>
    <tr>
        <td>* 1���� ������ �ڵ���� Ȥ�� �������ó���� ��� ������������ ��������˴ϴ�.</td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ</span></td>
    </tr>
    <!-- ���� --->
	<%if(!use_st.equals("null")){%>
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">��౸��</td>
                    <% if (String.valueOf(reserv.get("RENT_ST")).equals("��������")) { %>
	                    <td width="34%">&nbsp;<a href="javascript:view_rentcont('<%=reserv.get("USE_ST")%>','<%=reserv.get("RENT_S_CD")%>');"><%=reserv.get("RENT_ST")%></a></td>
	                    <td class="title" width="16%">����ġ</td>
						<td width="34%">&nbsp;			
							<%for(int i = 0 ; i < good_size ; i++){
								CodeBean good = goods[i];
								if(park.equals(good.getNm_cd()))%><%=good.getNm()%>
							<%}%>
						</td>
					<% } else { %>
						<td width="84%" colspan='3'>&nbsp;<a href="javascript:view_rentcont('<%=reserv.get("USE_ST")%>','<%=reserv.get("RENT_S_CD")%>');"><%=reserv.get("RENT_ST")%></a></td>	                    
					<% } %>
    		    </tr>
    		    <tr>
                    <td class="title" width="16%">�뿩�Ⱓ</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT")))%>~<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT")))%>
					&nbsp;&nbsp;&nbsp;
					[���] <%=AddUtil.ChangeDate2(String.valueOf(reserv.get("REG_DT")))%> <%=c_db.getNameById(String.valueOf(reserv.get("REG_ID")),"USER")%>
					</td>
					<td class="title" width="16%">�����</td>
                    <td width="34%">&nbsp;<%=reserv.get("FIRM_NM")%>&nbsp;<%=reserv.get("CUST_NM")%></td>					
                </tr>
            </table>
	    </td>
    </tr>
    
    <%	if(String.valueOf(reserv.get("RENT_ST")).equals("�����뿩")){%>
	<input type="hidden" name="ret_dt" 		value="">
	<%	}else{%>
	<input type="hidden" name="ret_dt" 		value="<%=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT2")))%>">
	<%	}%>
	
    <%}else{%>
    
    <%	if(cont_size2 > 0){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title rowspan='2' width="4%">����</td>
                    <td class=title rowspan='2' width="7%">����</td>
                    <td class=title rowspan='2' width="4%">����</td>
                    <td class=title colspan='2'>�ڵ���</td>										
                    <td class=title rowspan='2' width="18%">�뿩�Ⱓ</td>
                    <td class=title rowspan='2' width="24%">��ȣ/����</td>					
                    <td class=title rowspan='2' width="7%">�����</td>					
                    <td class=title rowspan='2' width="10%">�������</td>
                </tr>
				<tr>
                    <td class=title width="10%">������</td>														
                    <td class=title width="10%">�����߻�</td>																			
				</tr>			
                <%	int cont_idx = 0;
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs2 = (Hashtable)conts.elementAt(i);
    					if(String.valueOf(reservs2.get("USE_ST")).equals("����")){
    						cont_idx++;	
    					%>
                <tr> 
                    <td align="center"><%=cont_idx%></td>
                    <td align="center"><%=reservs2.get("RENT_ST")%></td>
                    <td align="center"><%=reservs2.get("USE_ST")%></td>
                    <td align="center"><%=reservs2.get("CAR_NO")%></td>
                    <td align="center"><%=reservs2.get("D_CAR_NO")%></td>															
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs2.get("RENT_START_DT")))%>��<br> ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs2.get("RENT_END_DT")))%>��</td>
                    <td align="center"><%=reservs2.get("FIRM_NM")%> <%=reservs2.get("CUST_NM")%></td>
                    <td align="center"><%=reservs2.get("BUS_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate3_2(String.valueOf(reservs2.get("REG_DT")))%></td>										
                </tr>
              	<%		}%>
              <%	}%>
            </table>
        </td>
    </tr>   
    <input type="hidden" name="ret_dt" 		value="">
    <%	}else{%>
	<input type="hidden" name="ret_dt" 		value="">
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">��౸��</td>
                    <td width="34%">&nbsp;���</td>
                    <td class="title" width="16%">����ġ</td>
                    <td width="34%">&nbsp;
						<%for(int i = 0 ; i < good_size ; i++){
							CodeBean good = goods[i];							
							if(park.equals(good.getNm_cd()))%><%= good.getNm()%>
						<%}%>
        			</td>
                </tr>
            </table>
	    </td>
    </tr>    
    <%	} %> 
    <!-- ���� --->
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�縮�������Ȳ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">�縮���������</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate2(secondhand_dt)%></td>
                    <td class="title" width="16%">����Ⱓ</td>
                    <td width="34%">&nbsp;<%= carOld2.get("MONTH") %>����<%= carOld2.get("DAY") %>��
        			</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<%if(!cr_bean.getOff_ls().equals("0")){%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ű�����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">������������</td>
                    <td >&nbsp;
                        <%if(cr_bean.getOff_ls().equals("1")){%>[�Ű�����]<%}%>
                        <%if(cr_bean.getOff_ls().equals("2")){%>[�Ҹ�]<%}%>
                        <%if(cr_bean.getOff_ls().equals("3")){%>[�������ǰ]<%}%>
                        <%if(cr_bean.getOff_ls().equals("4")){%>[���ǰ��]<%}%>
                        <%if(cr_bean.getOff_ls().equals("5")){%>[����峫��]<%}%>
                        <%if(cr_bean.getOff_ls().equals("6")){%>[�Ű��Ϸ�]<%}%>
						<%if(cr_bean.getOff_ls().equals("3")){
								//�������
								Hashtable ht_apprsl 	= shDb.getCarApprsl(car_mng_id);%>
						:
							<%if(!String.valueOf(ht_apprsl.get("ACTN_DT")).equals("")){%>
							������� - <%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("ACTN_DT")))%>,
							<%}else{%>
							������ - <%=AddUtil.ChangeDate2(String.valueOf(ht_apprsl.get("APPRSL_DT")))%>,
							<%}%>
						��ǰ����� - <%=ht_apprsl.get("FIRM_NM")%>
						<%}%>
					</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<%}%>
<%}%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span>
           <!-- &nbsp;<span class="b"><a href="javascript:MM_openBrWindow('/acar/rent_prepare/car_rmst.jsp?c_id=<%=car_mng_id%>&car_no=<%=car_no%>&auth_rw=<%=auth_rw%>','CarRmSt','scrollbars=no,status=yes,resizable=yes,width=420,height=530,left=50, top=50')" title='�������� Ȯ��'>
           [��������]</a></span>
            --> 
           <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�縮��Ư������",user_id)){%>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:reg_spe_dc();">[
                     Ư������
            <%if(cr_bean.getSpe_dc_st().equals("Y")){%>
            &nbsp; ����: <%=cr_bean.getSpe_dc_cau()%>, <%=cr_bean.getSpe_dc_per()%>%
            <%}%>
            ]</a>
            <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">���ʵ����</td>
                    <td width="34%">&nbsp;<a href="javascript:view_car();"><%=AddUtil.ChangeDate2(init_reg_dt)%></a>&nbsp;(<%=car_y_form%>����)</td>
                    <td class="title" width="16%">�������</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate2(dlv_dt)%>
					 (����:
					    <%=c_db.getNameByIdCode("0039", "", cr_bean.getFuel_kd())%>					    
					 )</td>
                </tr>
                <tr>
                    <td class="title" width="16%">����</td>
                    <td width="34%">&nbsp;<%= carOld.get("YEAR") %>��<%= carOld.get("MONTH") %>����<%= carOld.get("DAY") %>��(��������:<%=AddUtil.getDate()%>)
					<%if(cr_bean.getCar_use().equals("1")){
							int car_end_d_day = c_db.getCar_D_day("car_end_dt", car_mng_id);
					%>
					<br>&nbsp;<b>���ɸ����� : <%=cr_bean.getCar_end_dt()%> <%if(car_end_d_day <= 30){ %><font color=red>(D-day <%=car_end_d_day%>��)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_end_d_day%>��<%}} %></b>
					<%}%>
					</td>
                    <td class="title" width="16%">����Ÿ�</td>
                    <td width="34%">&nbsp;�����Է�:<%=AddUtil.parseDecimal(tot_dist)%>km, <%=AddUtil.ChangeDate2(serv_dt)%>
   	    			  &nbsp;&nbsp;
					  <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="���񳻿�����"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>
					  &nbsp;&nbsp;
					  <a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_reg.jsp?car_mng_id=<%= car_mng_id %>&cmd=b&from_page=/acar/secondhand/secondhand_price_20090901.jsp','popwin_serv_reg','scrollbars=yes,status=yes,resizable=yes,width=850,height=600,top=50,left=50')"><img src=/acar/images/center/button_reg_bjg.gif align=absmiddle border=0></a>&nbsp;
					  
					  
					</td>
                </tr>
    		    <tr>
        		    <td class='title'> �˻���ȿ�Ⱓ </td>
        		    <%	
        		    	int car_maint_d_day = c_db.getCar_D_day("car_maint_dt", car_mng_id);
					%>
        		    <td>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%> <%if(car_maint_d_day <= 30){ %><font color=red>(D-day <%=car_maint_d_day%>��)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_maint_d_day%>��<%}} %></b></b></td>
                	<td class='title'>������ȿ�Ⱓ</td>
        		    <td>&nbsp;<b><%=cr_bean.getTest_st_dt()%>~<%=cr_bean.getTest_end_dt()%></b></td>
    		    </tr>
    		    <tr>
        		    <td class='title'> �������� </td>
        		    <td>&nbsp;1�� <%= AddUtil.parseDecimal(accid_serv_amt1) %>��, 2�� <%= AddUtil.parseDecimal(accid_serv_amt2) %>�� 
        		    	<%if(!String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("") && !String.valueOf(ht_ac.get("CAR_MNG_ID")).equals("null")){%>
        		    	(<b>�ڻ�������</b>)
        		    	<%}%> 
        		    </td>
                	<td class='title'>����׻�� �ܰ��ݿ�</td>
        		    <td>&nbsp;���� : <%=jg_col_st%>, �ܰ� : <%=jg_opt_st%>
        		    	<!-- &nbsp;&nbsp;&nbsp;&nbsp;TUIX/TUON Ʈ������ : <%=jg_tuix_st%>, �ɼǿ��� : <%=jg_tuix_opt_st%> -->
        		    </td>
    		    </tr>
    		    <tr>
        		    <td class='title'> ÷�ܾ������ </td>
        		    <td colspan='3'>&nbsp;<%if(lkas_yn.equals("Y")){%>������Ż������ <%=lkas_yn%><%}%> <%if(ldws_yn.equals("Y")){%>������Ż����� <%=ldws_yn%><%}%> <%if(aeb_yn.equals("Y")){%>������������� <%=aeb_yn%><%}%> <%if(fcw_yn.equals("Y")){%>������������ <%=fcw_yn%><%}%></td>
    		    </tr>    		    
            </table>
	    </td>
    </tr>
    <%if(!cr_bean.getDist_cng().equals("")){%>
    <tr>
		<td><font color=green><b>* <%=cr_bean.getDist_cng()%></b></font></td>
    </tr>
    <%}else{%>
    <tr></tr><tr></tr>
    <%}%>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">������</td>
                    <td width="68%">&nbsp;<%= c_db.getNameById(car_comp_id, "CAR_COM") %></td>
                    <td class="title" width="16%">�ݾ�</td>
                </tr>
                <tr>
                    <td class="title">����</td>
                    <td>&nbsp;<a href="javascript:opt();" onMouseOver="window.status=''; return true"><%=car_name%></a>&nbsp;(<%=jg_code%>)</td>
                    <td align="center"><input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(car_amt) %>" size="15" class="whitenum">��</td>
                </tr>
                <tr>
                    <td class="title">�ɼ�</td>
                    <td>&nbsp;<a href="javascript:opt();" onMouseOver="window.status=''; return true"><%=opt%></a>
                    <%if(add_opt_amt>0){ %>(�߰�����:<%=add_opt %> <%= AddUtil.parseDecimal(add_opt_amt) %>��)<%}%>
                    </td>
                    <td align="center"><input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(opt_amt) %>" size="15" class="whitenum">��</td>
                </tr>
                <tr>
                    <td class="title">����</td>
                    <td>&nbsp;<%=colo%></td>
                    <td align="center"><input type="text" name="car_amt" value="<%= AddUtil.parseDecimal(clr_amt) %>" size="15" class="whitenum">��</td>
                </tr>
                <!-- ���� ���Ҽ� ���� �߰�(2017.10.13) -->
				<%
				if(jg_g_7.equals("1") || jg_g_7.equals("2") || jg_g_7.equals("3") || jg_g_7.equals("4")){
				%>                
                <tr>
                    <td class="title">���� ���Ҽ� ����</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type="text" name="car_amt" value="- <%= AddUtil.parseDecimal(tax_dc_amt) %>" size="15" class="whitenum">��</td>
                </tr>
				<%
				}
				%>
                
                <tr>
                    <td class="title">������</td>
                    <td align="right"></td>
                    <td align="center">- <input type="text" name="depreciation" value="0" size="15" class="defaultnum">��</td>
                </tr>
                <tr>
                    <td class="title" colspan="2">�縮�����ذ���</td>
                    <td align="center"><input type="text" name="apply_secondhand_price" value="<%=AddUtil.parseDecimal(String.valueOf(hp.get("APPLY_SH_PR")))%>" size="15" class="defaultnum">��</td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>

    <tr></tr><tr></tr>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span>
             &nbsp;&nbsp;<a href="javascript:search_cust()" onMouseOver="window.status=''; return true" title="����ȸ�ϱ�. Ŭ���ϼ���"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a>
             
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <font color=red>�� �ҷ��� Ȯ���ϱ�</font>
        	&nbsp;&nbsp;&nbsp;        	
        	<input type="button" class="button" id="bad_cust" value='��Ȯ��' onclick="javascript:view_badcust();">
        	<input name="badcust_chk" type="text" class="text"  readonly value="" size="1">   
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td class="title" width="16%">��ȣ �Ǵ� ����</td>
                    <td width="34%">&nbsp;<input type="text" name="cust_nm" value="<%=e_bean.getEst_nm()%>" size="40" class=default style='IME-MODE: active'></td>
                    <td class="title" width="16%">ȣĪ �Ǵ� ������̸�+ȣĪ</td>
                    <td width="34%">&nbsp;<input type="text" name="mgr_nm" value="<%=e_bean.getMgr_nm()%>" size="40" class=default style='IME-MODE: active'></td>
                </tr>
                <tr>
                    <td class="title">����ڵ�Ϲ�ȣ</td>
                    <td>&nbsp;<input type="text" name="cust_ssn" value="<%=e_bean.getEst_ssn()%>" size="40" class=default ></td>
                    <td class="title">�̸����ּ�</td>
                    <td>&nbsp;<input type="text" name="cust_email" value="<%=e_bean.getEst_email()%>" size="40" class=default  style='IME-MODE: inactive'></td>
                </tr>
                <tr>
                    <td class="title" width="16%">��ȭ��ȣ</td>
                    <td width="34%">&nbsp;<input type="text" name="cust_tel" value="<%=e_bean.getEst_tel()%>" size="15" class=default ></td>
                    <td class="title" width="16%">FAX</td>
                    <td width="34%">&nbsp;<input type="text" name="cust_fax" value="<%=e_bean.getEst_fax()%>" size="15" class=default></td>
                </tr>
                <tr>
                    <td class="title">������</td>
                    <td>&nbsp;<select name="doc_type" class=default <%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>onChange="javascript:SetComEmpYn()"<%}%>>
                            <option value=""  <%if(e_bean.getDoc_type().equals("")){%>selected<%}%>>����</option>
                            <option value="1" <%if(e_bean.getDoc_type().equals("1")){%>selected<%}%>>���ΰ�</option>
                            <option value="2" <%if(e_bean.getDoc_type().equals("2")){%>selected<%}%>>���λ����</option>
                            <option value="3" <%if(e_bean.getDoc_type().equals("3")){%>selected<%}%>>����</option>
                          </select>
                          &nbsp;(�����п� ���� �������� �ʿ伭���� ǥ���մϴ�.) 
                    </td>
                    <td class="title" width="16%">�����</td>
                    <td>
        			  &nbsp;<select name='damdang_id2' class=default>
                        <option value="">������</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);
        					%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        			</td>
                </tr>                
                <%if((AddUtil.parseInt(jg_code) > 1999999 && AddUtil.parseInt(jg_code) < 7000000) || (AddUtil.parseInt(jg_code) > 1999 && AddUtil.parseInt(jg_code) < 7000)){%>
                <tr>
                    <td class="title">�������������뺸��</td>
                    <td colspan='3'>&nbsp;<select name="com_emp_yn" id="com_emp_yn" class=default>
                    	<%if(e_bean.getDoc_type().equals("2")){%>                    	
                            <option value="">����</option>
                    	<%}%>
                            <option value="N">�̰���</option>
                            <option value="Y">����</option>
                          </select>                          
                    </td>
                </tr>
                <%}else{%>
                <input type="hidden" name="com_emp_yn"		value="N">
                <%}%>
            </table>
	    </td>
    </tr>
    <%if(nm_db.getWorkAuthUser("������",user_id)||cr_bean.getSecondhand().equals("1") || from_page.equals("off_lease_sc.jsp")){%>
    <tr>
        <td>&nbsp;<font color="#999999">�� �������� �Է��ϰ� �⺻�̳� ���������� Ŭ���ϸ�, <!--��������-&gt;������������� ����� �� �ֽ��ϴ�.-->�������� �ݿ��˴ϴ�.</font></td>
    </tr>
    <tr>
        <td align="right">
		<%if(est_st.equals("")){%>

	    		<a href="javascript:EstiMate('1', '', '', '<%if(cr_bean.getCar_use().equals("1")){%>2<%}else{%>1<%}%>', '1', '1', '_blank','');" title='����������� �����ϱ�'><img src=/acar/images/center/button_cgjdc.gif align=absmiddle border=0></a>&nbsp;&nbsp;


			<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�縮��Ư������",user_id)){%> 
			<a href="javascript:show_all();" title='��ü�����ϱ�'><img src=/acar/images/center/button_est_all.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<%}%>

			<font color=red>[Ȩ������ �������� : <%=hp.get("UPLOAD_DT")%>]</font>

		<%}else{ %>

			<%if(nm_db.getWorkAuthUser("������",user_id)){%>
			<a href="javascript:EstiMate('1', '', '', '<%if(cr_bean.getCar_use().equals("1")){%>2<%}else{%>1<%}%>', '1', '1', '_blank','');" title='����������� �����ϱ�'><img src=/acar/images/center/button_cgjdc.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<%}%>

		<%}%>
		</td>
    </tr>
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ּ���</span>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
   	    		<td class="title" width="16%">���ּ���(�����ε�����)</td>
    	    	<td width="34%">
    	    		&nbsp;
                   	<select name="br_to_st" class="default" style="width: 100px;" onchange="changeBrTo(this.value);">
	                    <option value="" selected>����</option>
	                    <option value="0" <%if (br_to_st.equals("0")) {%>selected<%}%>>������</option>
	                    <option value="1" <%if (br_to_st.equals("1")) {%>selected<%}%>>����/����/�泲/���</option>
	                    <option value="2" <%if (br_to_st.equals("2")) {%>selected<%}%>>�뱸/���</option>
	                    <option value="3" <%if (br_to_st.equals("3")) {%>selected<%}%>>����/����/����</option>
	                    <option value="4" <%if (br_to_st.equals("4")) {%>selected<%}%>>�λ�/���/�泲</option>
	                    <option value="5" <%if (br_to_st.equals("5")) {%>selected<%}%>>����</option>
					</select>
					<input type="hidden" name="br_to" value="<%=br_to%>">
    	    	</td>
   	    		<td class="title" width="16%">����ġ</td>
    	    	<td width="34%">
    	    		&nbsp;
    	    		<%if (br_from.equals("0")) {%>����<%} else if (br_from.equals("1")) {%>����<%} else if (br_from.equals("2")) {%>�뱸<%} else if (br_from.equals("3")) {%>����<%} else if (br_from.equals("4")) {%>�λ�<%}%>
    	    	</td>
    	    </table>
		</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%
    if (!from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp") && (cr_bean.getSecondhand().equals("1") || from_page.equals("off_lease_sc.jsp") || from_page.equals("/fms2/lc_rent/lc_s_frame.jsp") || from_page.equals("/fms2/lc_rent/lc_rm_frame.jsp") || nm_db.getWorkAuthUser("������", user_id))) {
   		
    	rb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RBMAX")), AddUtil.parseInt((String)hp.get("RBMAX_AG")), br_cons);
   		rs_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RSMAX")), AddUtil.parseInt((String)hp.get("RSMAX_AG")), br_cons);
   		lb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LBMAX")), AddUtil.parseInt((String)hp.get("LBMAX_AG")), br_cons);
   		ls_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LSMAX")), AddUtil.parseInt((String)hp.get("LSMAX_AG")), br_cons);
    %>
    <!--10000-->
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�Ⱓ�� ���뿩��
                    	<%if(!String.valueOf(hp_3d.get("REG_CODE")).equals("") && !String.valueOf(hp_3d.get("REG_CODE")).equals("null")){%>
                    	  (���� ��������Ÿ� : <%=hp.get("AGREE_DIST")%>km)&nbsp;&nbsp;
                    	<%}%>
                    	</span>                    	
			                <%if(nm_db.getWorkAuthUser("������",user_id)){%>
			                  (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			                  ||<a href="javascript:estimates_view('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='�������'>[�������]</a>
			                <%}%>
	                  </td>
                    <td align=right>
                    	�������� ǥ��Ǵ� ���� &nbsp;: &nbsp;
                    	<span style="color: #FFB2D9;size:20px;">��</span>&nbsp;-&nbsp;
                    	<span style="color: #FAED7D;size:20px;">��</span>&nbsp;-&nbsp;
                    	<span style="color: #86E57F;size:20px;">��</span>&nbsp;-&nbsp;
                    	<span style="color: #B2CCFF;size:20px;">��</span>&nbsp;&nbsp;
                    	<input type="hidden" name="param1" id="param1" value="">
                    	<input type="hidden" name="param2" id="param2" value="">
                    	<input type="hidden" name="param3" id="param3" value="">
                    	<input type="hidden" name="param4" id="param4" value="">
                    	<input type="button" class="button" value="������ �������� ����" onclick="javascript:go_esti_more();">
                    	<input type="button" class="button" value="���� �ʱ�ȭ" onclick="javascript:reset_checkBox();">
                    </td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td rowspan="2" width="8%" class="title">�뿩�Ⱓ</td>
                    <td colspan="2" class="title">��ⷻƮ</td>
                    <td colspan="2" class="title">�����÷���(���丮��)</td>
                </tr>
                <tr>
                    <td width="23%" class="title">�⺻��</td>
                    <td width="23%" class="title">�Ϲݽ�</td>
                    <td width="23%" class="title">�⺻��</td>
                    <td width="23%" class="title">�Ϲݽ�</td>
                </tr>
                <!--�ִ밳��--> 
                <tr>
                    <td class="title">�ִ� <%=String.valueOf(hp.get("MAX_USE_MON"))%>����</td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("RBMAX"))) > 0) {%>
       		            <%-- <a href="javascript:EstiPrint('2', '2', '<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '<%=String.valueOf(hp.get("RBMAX"))%>', '<%=hp.get("RBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RBMAX")))%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(rb_max)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                   		<input type="checkbox" class="cb" name="go_esti_4" id="cb1" value="22//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=String.valueOf(hp.get("RBMAX"))%>//<%=hp.get("RBMAX_ID")%>" onclick="javascript:change_td_col('1',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("RSMAX"))) > 0) {%>
       		            <%-- <a href="javascript:EstiPrint('2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RSMAX"))%>','<%=hp.get("RSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RSMAX")))%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(rs_max)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb2" value="21//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=String.valueOf(hp.get("RSMAX"))%>//<%=hp.get("RSMAX_ID")%>" onclick="javascript:change_td_col('2',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("LBMAX"))) > 0) {%>
       		            <%-- <a href="javascript:EstiPrint('1', '2', '<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '<%=String.valueOf(hp.get("LBMAX"))%>', '<%=hp.get("LBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LBMAX")))%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(lb_max)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb3" value="12//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=String.valueOf(hp.get("LBMAX"))%>//<%=hp.get("LBMAX_ID")%>" onclick="javascript:change_td_col('3',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("LSMAX"))) > 0) {%>
       		            <%-- <a href="javascript:EstiPrint('1', '1', '<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LSMAX"))%>','<%=hp.get("LSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LSMAX")))%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(ls_max)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb4" value="11//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=String.valueOf(hp.get("LSMAX"))%>//<%=hp.get("LSMAX_ID")%>" onclick="javascript:change_td_col('4',this.value);">
                        <%} else {%>-<%}%>
    		    	</td>
                </tr>
                <!--�ִ밳������ 12�����̳� ���ð���-->
                <tr>
                    <td class="title">����
                        <select name="s_a_b">
                        <%for (int i = AddUtil.parseInt(String.valueOf(hp.get("MAX_USE_MON")))-1; i > 6; i--) {
                        	if (i == 36) continue;
                        	if (i == 24) continue;
                        	if (i == 12) continue;
                        	if (i == 6) continue;
                        %>
                        	<option value="<%=i%>"><%=i%></option>
                        <%}%>
                        </select>����
                    </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("RB36")))+AddUtil.parseInt(String.valueOf(hp.get("RB24")))+AddUtil.parseInt(String.valueOf(hp.get("RB12")))+AddUtil.parseInt(String.valueOf(hp.get("RB6"))) > 0) {%>
                        <input type="text" name="rbsel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
					</td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("RS36")))+AddUtil.parseInt(String.valueOf(hp.get("RS24")))+AddUtil.parseInt(String.valueOf(hp.get("RS12")))+AddUtil.parseInt(String.valueOf(hp.get("RS6"))) > 0) {%>
                        <input type="text" name="rssel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("LB36")))+AddUtil.parseInt(String.valueOf(hp.get("LB24")))+AddUtil.parseInt(String.valueOf(hp.get("LB12"))) > 0) {%>
                        <input type="text" name="lbsel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','2',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if (AddUtil.parseInt(String.valueOf(hp.get("LS36")))+AddUtil.parseInt(String.valueOf(hp.get("LS24")))+AddUtil.parseInt(String.valueOf(hp.get("LS12"))) > 0) {%>
                        <input type="text" name="lssel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','1',document.form1.s_a_b[0].options[document.form1.s_a_b[0].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%
    		  	for (int i = 0; i < 4; i++) {
  	  				if (i == 0) {
    					amt1 	= String.valueOf(hp.get("RB36"));			amt2 		= String.valueOf(hp.get("RS36"));  		amt3 		= String.valueOf(hp.get("LB36"));  		amt4 		= String.valueOf(hp.get("LS36"));
    					amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
    				} else if (i == 1) {
    					amt1 	= String.valueOf(hp.get("RB24"));			amt2 		= String.valueOf(hp.get("RS24"));  		amt3 		= String.valueOf(hp.get("LB24"));  		amt4 		= String.valueOf(hp.get("LS24"));
    					amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
    				} else if (i == 2) {
    					amt1 	= String.valueOf(hp.get("RB12"));			amt2 		= String.valueOf(hp.get("RS12"));  		amt3 		= String.valueOf(hp.get("LB12"));  		amt4 		= String.valueOf(hp.get("LS12"));
    					amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
	    			} else if (i == 3) {
  	  					amt1 	= String.valueOf(hp.get("RB6"));			amt2 		= String.valueOf(hp.get("RS6"));  		amt3 		= "0";  amt4 		= "0";
  	  					amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
  	  					
	  	  				to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
		  	  			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
		  	  			to_amt3 = "0";
		  	  			to_amt4 = "0";
    				}
    			%>
                <tr>
                    <td class="title" ><%=mon[i]%>����</td>
                    <td align="center">
                   	<%if (nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057")) {%>
                        <%if (AddUtil.parseInt(amt1) > 0) {%>
	        		        <%-- <a href="javascript:EstiPrint('2', '2', '<%=mon[i]%>', '<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
	                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+2)+1%>',this.value);">
                        <%} else {%>-<%}%>
                   	<%} else {%>
                        <%if (AddUtil.parseInt(amt1) > 0) {%>
	                    	<%if (mon[i] >= 12) {%>
	        		        <%-- <a href="javascript:EstiPrint('2', '2', '<%=mon[i]%>', '<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
	                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+2)+1%>',this.value);">
	                    	<%} else {%>-<%}%>
                        <%} else {%>-<%}%>
                   	<%}%>
        	        </td>
                    <td  align="center">
                        <%if(AddUtil.parseInt(amt2)>0){%>
        		        <%-- <a href="javascript:EstiPrint('2', '1', '<%=mon[i]%>', '<%=to_amt2%>', '<%=amt_id2%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rs<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt2)>0){%><%=AddUtil.parseDecimal(to_amt2)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>', '2', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>', '2', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>', '2', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+2%>" value="21//<%=mon[i]%>//<%=to_amt2%>//<%=amt_id2%>" onclick="javascript:change_td_col('<%=4*(i+2)+2%>',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
   	          		<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt3)>0){%>
        		        <%-- <a href="javascript:EstiPrint('1', '2', '<%=mon[i]%>', '<%=to_amt3%>', '<%=amt_id3%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt3)>0){%><%=AddUtil.parseDecimal(to_amt3)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>', '1', '2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>', '1', '2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>', '1', '2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+3%>" value="12//<%=mon[i]%>//<%=to_amt3%>//<%=amt_id3%>" onclick="javascript:change_td_col('<%=4*(i+2)+3%>',this.value);">
                        <%} else {%>-<%}%>
                    <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
        		    <%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt4)>0){%>
        		        <%-- <a href="javascript:EstiPrint('1', '1', '<%=mon[i]%>', '<%=to_amt4%>', '<%=amt_id4%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="ls<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt4)>0){%><%=AddUtil.parseDecimal(to_amt4)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>', '1', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>', '1', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>', '1', '1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+2)+4%>" value="11//<%=mon[i]%>//<%=to_amt4%>//<%=amt_id4%>" onclick="javascript:change_td_col('<%=4*(i+2)+4%>',this.value);">
                        <%} else {%>-<%}%>
        		    <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%}%>
    		</table>
	    </td>
    </tr>    
    
    <!--20000-->
    <%	
    if (!String.valueOf(hp_2d.get("REG_CODE")).equals("") && !String.valueOf(hp_2d.get("REG_CODE")).equals("null")) {
		hp = hp_2d;
		
		rb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RBMAX")), AddUtil.parseInt((String)hp.get("RBMAX_AG")), br_cons);
   		rs_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RSMAX")), AddUtil.parseInt((String)hp.get("RSMAX_AG")), br_cons);
   		lb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LBMAX")), AddUtil.parseInt((String)hp.get("LBMAX_AG")), br_cons);
   		ls_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LSMAX")), AddUtil.parseInt((String)hp.get("LSMAX_AG")), br_cons);
    %>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�Ⱓ�� ���뿩��
                    	  (���� ��������Ÿ� : <%=hp.get("AGREE_DIST")%>km)&nbsp;&nbsp;
                    	</span>
			                <%if(nm_db.getWorkAuthUser("������",user_id)){%>
			                  (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			                  ||<a href="javascript:estimates_view('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='�������'>[�������]</a>
			                <%}%>
	                  </td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td rowspan="2" width="8%" class="title">�뿩�Ⱓ</td>
                    <td colspan="2" class="title">��ⷻƮ</td>
                    <td colspan="2" class="title">�����÷���(���丮��)</td>
                </tr>
                <tr>
                    <td width="23%" class="title">�⺻��</td>
                    <td width="23%" class="title">�Ϲݽ�</td>
                    <td width="23%" class="title">�⺻��</td>
                    <td width="23%" class="title">�Ϲݽ�</td>
                </tr>

                <!--�ִ밳��--> 
                <tr>
                    <td class="title">�ִ� <%=String.valueOf(hp.get("MAX_USE_MON"))%>����</td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RBMAX"))%>','<%=hp.get("RBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RBMAX")))%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(rb_max)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb25" value="22//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rb_max%>//<%=hp.get("RBMAX_ID")%>" onclick="javascript:change_td_col('25',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=rs_max%>','<%=hp.get("RSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(rs_max)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb26" value="21//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rs_max%>//<%=hp.get("RSMAX_ID")%>" onclick="javascript:change_td_col('26',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=lb_max%>','<%=hp.get("LBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(lb_max)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb27" value="12//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=lb_max%>//<%=hp.get("LBMAX_ID")%>" onclick="javascript:change_td_col('27',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=ls_max%>','<%=hp.get("LSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(ls_max)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb28" value="11//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=ls_max%>//<%=hp.get("LSMAX_ID")%>" onclick="javascript:change_td_col('28',this.value);">
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
                <!--�ִ밳������ 12�����̳� ���ð���-->
                <tr>
                    <td class="title">����
                        <select name="s_a_b">
                        <%for(int i = AddUtil.parseInt(String.valueOf(hp.get("MAX_USE_MON")))-1 ; i > 6 ; i--){
                        	if(i == 36) continue;
                        	if(i == 24) continue;
                        	if(i == 12) continue;
                        	if(i == 6) continue;

                        %>
                        <option value="<%=i%>"><%=i%></option>
                        <%}%>
                        </select>����
                    </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RB36")))+AddUtil.parseInt(String.valueOf(hp.get("RB24")))+AddUtil.parseInt(String.valueOf(hp.get("RB12")))+AddUtil.parseInt(String.valueOf(hp.get("RB6")))>0){%>
                        <input type="text" name="rbsel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RS36")))+AddUtil.parseInt(String.valueOf(hp.get("RS24")))+AddUtil.parseInt(String.valueOf(hp.get("RS12")))+AddUtil.parseInt(String.valueOf(hp.get("RS6")))>0){%>
                        <input type="text" name="rssel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LB36")))+AddUtil.parseInt(String.valueOf(hp.get("LB24")))+AddUtil.parseInt(String.valueOf(hp.get("LB12")))>0){%>
                        <input type="text" name="lbsel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','2',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LS36")))+AddUtil.parseInt(String.valueOf(hp.get("LS24")))+AddUtil.parseInt(String.valueOf(hp.get("LS12")))>0){%>
                        <input type="text" name="lssel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','1',document.form1.s_a_b[1].options[document.form1.s_a_b[1].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%
    		  	for (int i = 0; i < 4; i++) {
  	  				if (i == 0) {
    					amt1		= String.valueOf(hp.get("RB36"));			amt2 		= String.valueOf(hp.get("RS36"));  		amt3 		= String.valueOf(hp.get("LB36"));  		amt4 		= String.valueOf(hp.get("LS36"));
    					amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
    				} else if (i == 1) {
    					amt1		= String.valueOf(hp.get("RB24"));			amt2 		= String.valueOf(hp.get("RS24"));  		amt3 		= String.valueOf(hp.get("LB24"));  		amt4 		= String.valueOf(hp.get("LS24"));
    					amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
    				} else if (i == 2) {
    					amt1		= String.valueOf(hp.get("RB12"));			amt2 		= String.valueOf(hp.get("RS12"));  		amt3 		= String.valueOf(hp.get("LB12"));  		amt4 		= String.valueOf(hp.get("LS12"));
    					amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
	    			} else if (i == 3) {
  	  					amt1		= String.valueOf(hp.get("RB6"));			amt2 		= String.valueOf(hp.get("RS6"));  		amt3 		= "0";  amt4 		= "0";
  	  					amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
  	  					
	  	  				to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
		  	  			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
		  	  			to_amt3 = "0";
		  	  			to_amt4 = "0";
    				}
    			%>
                <tr>
                    <td class="title" ><%=mon[i]%>����</td>
                    <td align="center">
                    <%if (nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057")) {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+7)+1%>',this.value);">
                        <%} else {%>-<%}%>
					<%} else {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
							<%if (mon[i] >= 12) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+7)+1%>',this.value);">
	                        <%} else {%>-<%}%>
						<%} else {%>-<%}%>
					<%}%>
        	        </td>
                    <td  align="center">
                        <%if(AddUtil.parseInt(amt2)>0){%>
        		        <%-- <a href="javascript:EstiPrint('2','1','<%=mon[i]%>','<%=to_amt2%>', '<%=amt_id2%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rs<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt2)>0){%><%=AddUtil.parseDecimal(to_amt2)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+2%>" value="21//<%=mon[i]%>//<%=to_amt2%>//<%=amt_id2%>" onclick="javascript:change_td_col('<%=4*(i+7)+2%>',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
   	          		<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt3)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=mon[i]%>','<%=to_amt3%>', '<%=amt_id3%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt3)>0){%><%=AddUtil.parseDecimal(to_amt3)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+3%>" value="12//<%=mon[i]%>//<%=to_amt3%>//<%=amt_id3%>" onclick="javascript:change_td_col('<%=4*(i+7)+3%>',this.value);">
                        <%} else {%>-<%}%>
                    <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
	            	<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt4)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=mon[i]%>','<%=to_amt4%>', '<%=amt_id4%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="ls<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt4)>0){%><%=AddUtil.parseDecimal(to_amt4)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+7)+4%>" value="11//<%=mon[i]%>//<%=to_amt4%>//<%=amt_id4%>" onclick="javascript:change_td_col('<%=4*(i+7)+4%>',this.value);">
                        <%} else {%>-<%}%>
   		            <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%}%>
    		</table>
	    </td>
    </tr>
    <%	}%>
    
    <!--30000-->
    <%	
    if (!String.valueOf(hp_3d.get("REG_CODE")).equals("") && !String.valueOf(hp_3d.get("REG_CODE")).equals("null")) {
    	hp = hp_3d;
    	
    	rb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RBMAX")), AddUtil.parseInt((String)hp.get("RBMAX_AG")), br_cons);
   		rs_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RSMAX")), AddUtil.parseInt((String)hp.get("RSMAX_AG")), br_cons);
   		lb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LBMAX")), AddUtil.parseInt((String)hp.get("LBMAX_AG")), br_cons);
   		ls_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LSMAX")), AddUtil.parseInt((String)hp.get("LSMAX_AG")), br_cons);
    %>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�Ⱓ�� ���뿩��
                    	  (���� ��������Ÿ� : <%=hp.get("AGREE_DIST")%>km)&nbsp;&nbsp;
                    	</span>
			                <%if(nm_db.getWorkAuthUser("������",user_id)){%>
			                  (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			                  ||<a href="javascript:estimates_view('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='�������'>[�������]</a>
			                <%}%>
	                </td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td rowspan="2" width="8%" class="title">�뿩�Ⱓ</td>
                    <td colspan="2" class="title">��ⷻƮ</td>
                    <td colspan="2" class="title">�����÷���(���丮��)</td>
                </tr>
                <tr>
                    <td width="23%" class="title">�⺻��</td>
                    <td width="23%" class="title">�Ϲݽ�</td>
                    <td width="23%" class="title">�⺻��</td>
                    <td width="23%" class="title">�Ϲݽ�</td>
                </tr>

                <!--�ִ밳��--> 
                <tr>
                    <td class="title">�ִ� <%=String.valueOf(hp.get("MAX_USE_MON"))%>����</td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RBMAX"))%>','<%=hp.get("RBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RBMAX")))%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(rb_max)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb49" value="22//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rb_max%>//<%=hp.get("RBMAX_ID")%>" onclick="javascript:change_td_col('49',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RSMAX"))%>','<%=hp.get("RSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RSMAX")))%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(rs_max)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb50" value="21//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rs_max%>//<%=hp.get("RSMAX_ID")%>" onclick="javascript:change_td_col('50',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LBMAX"))%>','<%=hp.get("LBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LBMAX")))%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(lb_max)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb51" value="12//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=lb_max%>//<%=hp.get("LBMAX_ID")%>" onclick="javascript:change_td_col('51',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LSMAX"))%>','<%=hp.get("LSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LSMAX")))%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(ls_max)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb52" value="11//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=ls_max%>//<%=hp.get("LSMAX_ID")%>" onclick="javascript:change_td_col('52',this.value);">
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
                <!--�ִ밳������ 12�����̳� ���ð���-->
                <tr>
                    <td class="title">����
                        <select name="s_a_b">
                        <%for(int i = AddUtil.parseInt(String.valueOf(hp.get("MAX_USE_MON")))-1 ; i > 6 ; i--){
                        	if(i == 36) continue;
                        	if(i == 24) continue;
                        	if(i == 12) continue;
                        	if(i == 6) continue;

                        %>
                        <option value="<%=i%>"><%=i%></option>
                        <%}%>
                        </select>����
                    </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RB36")))+AddUtil.parseInt(String.valueOf(hp.get("RB24")))+AddUtil.parseInt(String.valueOf(hp.get("RB12")))+AddUtil.parseInt(String.valueOf(hp.get("RB6")))>0){%>
                        <input type="text" name="rbsel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RS36")))+AddUtil.parseInt(String.valueOf(hp.get("RS24")))+AddUtil.parseInt(String.valueOf(hp.get("RS12")))+AddUtil.parseInt(String.valueOf(hp.get("SB6")))>0){%>
                        <input type="text" name="rssel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LB36")))+AddUtil.parseInt(String.valueOf(hp.get("LB24")))+AddUtil.parseInt(String.valueOf(hp.get("LB12")))>0){%>
                        <input type="text" name="lbsel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','2',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LS36")))+AddUtil.parseInt(String.valueOf(hp.get("LS24")))+AddUtil.parseInt(String.valueOf(hp.get("LS12")))>0){%>
                        <input type="text" name="lssel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','1',document.form1.s_a_b[2].options[document.form1.s_a_b[2].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%
    		  	for (int i = 0; i < 4; i++) {
  	  				if (i == 0) {
    					amt1 	= String.valueOf(hp.get("RB36"));			amt2 		= String.valueOf(hp.get("RS36"));  		amt3 		= String.valueOf(hp.get("LB36"));  		amt4 		= String.valueOf(hp.get("LS36"));
    					amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
    				} else if (i == 1) {
    					amt1 	= String.valueOf(hp.get("RB24"));			amt2 		= String.valueOf(hp.get("RS24"));  		amt3 		= String.valueOf(hp.get("LB24"));  		amt4 		= String.valueOf(hp.get("LS24"));
    					amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
    				} else if (i == 2) {
    					amt1 	= String.valueOf(hp.get("RB12"));			amt2 		= String.valueOf(hp.get("RS12"));  		amt3 		= String.valueOf(hp.get("LB12"));  		amt4 		= String.valueOf(hp.get("LS12"));
    					amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
	    			} else if (i == 3) {
  	  					amt1 	= String.valueOf(hp.get("RB6"));			amt2 		= String.valueOf(hp.get("RS6"));  		amt3 		= "0";  amt4 		= "0";
  	  					amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
  	  					
	  	  				to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
		  	  			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
		  	  			to_amt3 = "0";
		  	  			to_amt4 = "0";
    				}
    			%>
                <tr>
                    <td class="title" ><%=mon[i]%>����</td>
                    <td align="center">
					<%if (nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057")) {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
	                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+14)+1%>',this.value);">
                        <%} else {%>-<%}%>
					<%} else {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
							<%if (mon[i] >= 12) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
	                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+14)+1%>',this.value);">
                       		<%} else {%>-<%}%>
						<%} else {%>-<%}%>
					<%}%>
        	        </td>
                    <td  align="center">
                        <%if(AddUtil.parseInt(amt2)>0){%>
        		        <%-- <a href="javascript:EstiPrint('2','1','<%=mon[i]%>','<%=to_amt2%>', '<%=amt_id2%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rs<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt2)>0){%><%=AddUtil.parseDecimal(to_amt2)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+2%>" value="21//<%=mon[i]%>//<%=to_amt2%>//<%=amt_id2%>" onclick="javascript:change_td_col('<%=4*(i+14)+2%>',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
  	          		<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt3)>0){%>
      		            <%-- <a href="javascript:EstiPrint('1','2','<%=mon[i]%>','<%=to_amt3%>', '<%=amt_id3%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt3)>0){%><%=AddUtil.parseDecimal(to_amt3)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+3%>" value="12//<%=mon[i]%>//<%=to_amt3%>//<%=amt_id3%>" onclick="javascript:change_td_col('<%=4*(i+14)+3%>',this.value);">
                        <%} else {%>-<%}%>
                    <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
  		            <%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt4)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=mon[i]%>','<%=to_amt4%>', '<%=amt_id4%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="ls<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt4)>0){%><%=AddUtil.parseDecimal(to_amt4)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+14)+4%>" value="11//<%=mon[i]%>//<%=to_amt4%>//<%=amt_id4%>" onclick="javascript:change_td_col('<%=4*(i+14)+4%>',this.value);">
                        <%} else {%>-<%}%>
   		            <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%}%>
    		</table>
	    </td>
    </tr>
    <%	}%>    
    
    <!--40000-->
    <%	
    if (!String.valueOf(hp_4d.get("REG_CODE")).equals("") && !String.valueOf(hp_4d.get("REG_CODE")).equals("null")) {
    	hp = hp_4d;
    	
    	rb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RBMAX")), AddUtil.parseInt((String)hp.get("RBMAX_AG")), br_cons);
   		rs_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RSMAX")), AddUtil.parseInt((String)hp.get("RSMAX_AG")), br_cons);
   		lb_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LBMAX")), AddUtil.parseInt((String)hp.get("LBMAX_AG")), br_cons);
   		ls_max = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LSMAX")), AddUtil.parseInt((String)hp.get("LSMAX_AG")), br_cons);
    %>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�Ⱓ�� ���뿩��
                    	  (���� ��������Ÿ� : <%=hp.get("AGREE_DIST")%>km)&nbsp;&nbsp;
                    	</span>
			                <%if(nm_db.getWorkAuthUser("������",user_id)){%>
			                  (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			                  ||<a href="javascript:estimates_view('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='�������'>[�������]</a>
			                <%}%>
					</td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td rowspan="2" width="8%" class="title">�뿩�Ⱓ</td>
                    <td colspan="2" class="title">��ⷻƮ</td>
                    <td colspan="2" class="title">�����÷���(���丮��)</td>
                </tr>
                <tr>
                    <td width="23%" class="title">�⺻��</td>
                    <td width="23%" class="title">�Ϲݽ�</td>
                    <td width="23%" class="title">�⺻��</td>
                    <td width="23%" class="title">�Ϲݽ�</td>
                </tr>

                <!--�ִ밳��--> 
                <tr>
                    <td class="title">�ִ� <%=String.valueOf(hp.get("MAX_USE_MON"))%>����</td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RBMAX"))%>','<%=hp.get("RBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RBMAX")))%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="rbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RBMAX")))>0){%><%=AddUtil.parseDecimal(rb_max)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rbmax.value, 'rbmax','2','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb73" value="22//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rb_max%>//<%=hp.get("RBMAX_ID")%>" onclick="javascript:change_td_col('73',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("RSMAX"))%>','<%=hp.get("RSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("RSMAX")))%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="rsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("RSMAX")))>0){%><%=AddUtil.parseDecimal(rs_max)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rsmax.value, 'rsmax','2','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb74" value="21//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=rs_max%>//<%=hp.get("RSMAX_ID")%>" onclick="javascript:change_td_col('74',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LBMAX"))%>','<%=hp.get("LBMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LBMAX")))%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="lbmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LBMAX")))>0){%><%=AddUtil.parseDecimal(lb_max)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lbmax.value, 'lbmax','1','2','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb75" value="12//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=lb_max%>//<%=hp.get("LBMAX_ID")%>" onclick="javascript:change_td_col('75',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>','<%=String.valueOf(hp.get("LSMAX"))%>','<%=hp.get("LSMAX_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(String.valueOf(hp.get("LSMAX")))%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp; --%>
                        <input type="text" name="lsmax" class=num size="6" value="<%if(AddUtil.parseInt(String.valueOf(hp.get("LSMAX")))>0){%><%=AddUtil.parseDecimal(ls_max)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lsmax.value, 'lsmax','1','1','<%=String.valueOf(hp.get("MAX_USE_MON"))%>', '_blank','<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        	<input type="checkbox" class="cb" name="go_esti_4" id="cb76" value="11//<%=String.valueOf(hp.get("MAX_USE_MON"))%>//<%=ls_max%>//<%=hp.get("LSMAX_ID")%>" onclick="javascript:change_td_col('76',this.value);">
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
                <!--�ִ밳������ 12�����̳� ���ð���-->
                <tr>
                    <td class="title">����
                        <select name="s_a_b">
                        <%for(int i = AddUtil.parseInt(String.valueOf(hp.get("MAX_USE_MON")))-1 ; i > 6 ; i--){
                        	if(i == 36) continue;
                        	if(i == 24) continue;
                        	if(i == 12) continue;
                        	if(i == 6) continue;

                        %>
                        <option value="<%=i%>"><%=i%></option>
                        <%}%>
                        </select>����
                    </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RB36")))+AddUtil.parseInt(String.valueOf(hp.get("RB24")))+AddUtil.parseInt(String.valueOf(hp.get("RB12")))+AddUtil.parseInt(String.valueOf(hp.get("RB6")))>0){%>
                        <input type="text" name="rbsel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("RS36")))+AddUtil.parseInt(String.valueOf(hp.get("RS24")))+AddUtil.parseInt(String.valueOf(hp.get("RS12")))+AddUtil.parseInt(String.valueOf(hp.get("RS6")))>0){%>
                        <input type="text" name="rssel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','2','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','2','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','2','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LB36")))+AddUtil.parseInt(String.valueOf(hp.get("LB24")))+AddUtil.parseInt(String.valueOf(hp.get("LB12")))>0){%>
                        <input type="text" name="lbsel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','2',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
        	        </td>
                    <td align="center">
                        <%if(AddUtil.parseInt(String.valueOf(hp.get("LS36")))+AddUtil.parseInt(String.valueOf(hp.get("LS24")))+AddUtil.parseInt(String.valueOf(hp.get("LS12")))>0){%>
                        <input type="text" name="lssel" class=num size="6" value="���ð���" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', 0, '','1','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', 0, '','1','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', 0, '','1','1',document.form1.s_a_b[3].options[document.form1.s_a_b[3].selectedIndex].value, '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                        <%} else {%>-<%}%>
    		        </td>
                </tr>
    		  <%
    		  	for (int i = 0; i < 4; i++) {
  	  				if (i==0) {
    					amt1 	= String.valueOf(hp.get("RB36"));			amt2 		= String.valueOf(hp.get("RS36"));  		amt3 		= String.valueOf(hp.get("LB36"));  		amt4 		= String.valueOf(hp.get("LS36"));
    					amt_id1 = String.valueOf(hp.get("RB36_ID"));	amt_id2 = String.valueOf(hp.get("RS36_ID"));  amt_id3 = String.valueOf(hp.get("LB36_ID"));  amt_id4 = String.valueOf(hp.get("LS36_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB36")), AddUtil.parseInt((String)hp.get("RB36_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS36")), AddUtil.parseInt((String)hp.get("RS36_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB36")), AddUtil.parseInt((String)hp.get("LB36_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS36")), AddUtil.parseInt((String)hp.get("LS36_AG")), br_cons);
    				} else if (i == 1) {
    					amt1 	= String.valueOf(hp.get("RB24"));			amt2 		= String.valueOf(hp.get("RS24"));  		amt3 		= String.valueOf(hp.get("LB24"));  		amt4 		= String.valueOf(hp.get("LS24"));
    					amt_id1 = String.valueOf(hp.get("RB24_ID"));	amt_id2 = String.valueOf(hp.get("RS24_ID"));  amt_id3 = String.valueOf(hp.get("LB24_ID"));  amt_id4 = String.valueOf(hp.get("LS24_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB24")), AddUtil.parseInt((String)hp.get("RB24_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS24")), AddUtil.parseInt((String)hp.get("RS24_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB24")), AddUtil.parseInt((String)hp.get("LB24_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS24")), AddUtil.parseInt((String)hp.get("LS24_AG")), br_cons);
    				} else if (i == 2) {
    					amt1 	= String.valueOf(hp.get("RB12"));			amt2 		= String.valueOf(hp.get("RS12"));  		amt3 		= String.valueOf(hp.get("LB12"));  		amt4 		= String.valueOf(hp.get("LS12"));
    					amt_id1 = String.valueOf(hp.get("RB12_ID"));	amt_id2 = String.valueOf(hp.get("RS12_ID"));  amt_id3 = String.valueOf(hp.get("LB12_ID"));  amt_id4 = String.valueOf(hp.get("LS12_ID"));
    					
    					to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB12")), AddUtil.parseInt((String)hp.get("RB12_AG")), br_cons);
    					to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS12")), AddUtil.parseInt((String)hp.get("RS12_AG")), br_cons);
    					to_amt3 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LB12")), AddUtil.parseInt((String)hp.get("LB12_AG")), br_cons);
    					to_amt4 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("LS12")), AddUtil.parseInt((String)hp.get("LS12_AG")), br_cons);
	    			} else if (i == 3) {
  	  					amt1 	= String.valueOf(hp.get("RB6"));			amt2 		= String.valueOf(hp.get("RS6"));  		amt3 		= "0";  amt4 		= "0";
  	  					amt_id1 = String.valueOf(hp.get("RB6_ID"));		amt_id2 = String.valueOf(hp.get("RS6_ID"));  	amt_id3 = "";  	amt_id4 = "";
  	  					
	  	  				to_amt1 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RB6")), AddUtil.parseInt((String)hp.get("RB6_AG")), br_cons);
		  	  			to_amt2 = oh_db.getSecondHandBrAmtCalculate(AddUtil.parseInt((String)hp.get("RS6")), AddUtil.parseInt((String)hp.get("RS6_AG")), br_cons);			
		  	  			to_amt3 = "0";
		  	  			to_amt4 = "0";
    				}
    			%>
                <tr>
                    <td class="title" ><%=mon[i]%>����</td>
                    <td align="center">
					<%if (nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057")) {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+20)+1%>',this.value);">
                        <%} else {%>-<%}%>
					<%} else {%>
						<%if (AddUtil.parseInt(amt1) > 0) {%>
							<%if (mon[i] >= 12) {%>
	        		        <%-- <a href="javascript:EstiPrint('2','2','<%=mon[i]%>','<%=to_amt1%>', '<%=amt_id1%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
	                        <input type="text" name="rb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt1)>0){%><%=AddUtil.parseDecimal(to_amt1)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
	                        <a href="javascript:EstiMate('2', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
	                        <a href="javascript:EstiMate('3', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <a href="javascript:EstiMate('4', document.form1.rb<%=mon[i]%>.value, 'rb<%=mon[i]%>','2','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
	                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+1%>" value="22//<%=mon[i]%>//<%=to_amt1%>//<%=amt_id1%>" onclick="javascript:change_td_col('<%=4*(i+20)+1%>',this.value);">
							<%} else {%>-<%}%>
						<%} else {%>-<%}%>
					<%}%>
        	        </td>
                    <td  align="center">
                        <%if(AddUtil.parseInt(amt2)>0){%>
        		        <%-- <a href="javascript:EstiPrint('2','1','<%=mon[i]%>','<%=to_amt2%>', '<%=amt_id2%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="rs<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt2)>0){%><%=AddUtil.parseDecimal(to_amt2)%><%}else{%>��Ʈ�Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.rs<%=mon[i]%>.value, 'rs<%=mon[i]%>','2','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                        <input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+2%>" value="21//<%=mon[i]%>//<%=to_amt2%>//<%=amt_id2%>" onclick="javascript:change_td_col('<%=4*(i+20)+2%>',this.value);">
                        <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
   	          		<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt3)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','2','<%=mon[i]%>','<%=to_amt3%>', '<%=amt_id3%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="lb<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt3)>0){%><%=AddUtil.parseDecimal(to_amt3)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.lb<%=mon[i]%>.value, 'lb<%=mon[i]%>','1','2','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+3%>" value="12//<%=mon[i]%>//<%=to_amt3%>//<%=amt_id3%>" onclick="javascript:change_td_col('<%=4*(i+20)+3%>',this.value);">
                        <%} else {%>-<%}%>
                    <%} else {%>-<%}%>
        	        </td>
                    <td  align="center">
	            	<%if(i < 3){%>
                        <%if(AddUtil.parseInt(amt4)>0){%>
       		            <%-- <a href="javascript:EstiPrint('1','1','<%=mon[i]%>','<%=to_amt4%>', '<%=amt_id4%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp; --%>
                        <input type="text" name="ls<%=mon[i]%>" class=num size="6" value="<%if(AddUtil.parseInt(amt4)>0){%><%=AddUtil.parseDecimal(to_amt4)%><%}else{%>�����Ұ�<%}%>" <%=readonly%>>��&nbsp;
                        <a href="javascript:EstiMate('2', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_bgj.gif align="absmiddle" border="0" alt="�⺻����"></a>
                        <a href="javascript:EstiMate('3', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="��������"></a>
                        <a href="javascript:EstiMate('4', document.form1.ls<%=mon[i]%>.value, 'ls<%=mon[i]%>','1','1','<%=mon[i]%>', '_blank', '<%=hp.get("AGREE_DIST")%>');"><img src=/acar/images/center/button_in_msggj.gif align="absmiddle" border="0" alt="��������"></a>
                       	<input type="checkbox" class="cb" name="go_esti_4" id="cb<%=4*(i+20)+4%>" value="11//<%=mon[i]%>//<%=to_amt4%>//<%=amt_id4%>" onclick="javascript:change_td_col('<%=4*(i+20)+4%>',this.value);">
                        <%} else {%>-<%}%>
   		            <%} else {%>-<%}%>
					</td>
                </tr>
    		  <%}%>
    		</table>
	    </td>
    </tr>
    <%	}%>
    
    <%}%>
    
    <%if (cr_bean.getCar_use().equals("1")) {%>
    <tr>
	    <td class=h></td>
	</tr>
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td>
                    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span>
			            <%if(nm_db.getWorkAuthUser("������", user_id)){%>
			            (<%=car_mng_id%>-<%=hp.get("REG_CODE")%>)
			            ||<a href="javascript:estimates_view_rm('<%=hp.get("REG_CODE")%>','<%=car_mng_id%>');" title='�������'>[����Ʈ �������]</a>
			            <%}%>
					</td>
                    <td align=right></td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="line">
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr>
					<td class="title" width="8%">����Ʈ</td>
					<td>&nbsp;
						<%if(AddUtil.parseInt(String.valueOf(hp2.get("RM1")))>0){%><a href="javascript:EstiPrintRm('2','1','1','<%=hp2.get("RM1")%>','<%=hp2.get("RM1_ID")%>');"><img src=/acar/images/center/button_hp.gif align="absmiddle" border="0"></a>&nbsp;<%}%>
    		    	    <input type="text" name="rm1" class=num size="10" value="<%=AddUtil.parseDecimal(String.valueOf(hp2.get("RM1")))%>" <%=readonly%>>��&nbsp;
    		    		&nbsp;|&nbsp;
    		    		<a href="javascript:EstiMateRm('2', document.form1.rm1.value, 'rm1', '2', '1', '1', '0', '_blank')"><img src=/acar/main_car_hp/images/btn_1month.gif border="0" alt="1��������"></a>
					    <input type="hidden" name="months" value="1">
                        <input type="hidden" name="days" value="0">
                        <a href="javascript:EstiHistory();"><img src=/acar/images/center/button_in_gjir.gif align="absmiddle" border="0" alt="�����̷�"></a>
    		        </td>
				</tr>
			</table>
		</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
    <%//	}%>    
    <%}%>    
</table>
<input type="hidden" id="cb_chk_off1" value="">
<input type="hidden" id="cb_chk_off2" value="">
<input type="hidden" id="cb_chk_off3" value="">
<input type="hidden" id="cb_chk_off4" value="">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

<script language="JavaScript" type="text/JavaScript">
	<%if(jg_code.equals("")){%>
		alert('�����ڵ尡 �����ϴ�.\n\n��������� �ȵ˴ϴ�.\n\nȮ���Ͻʽÿ�.');
	<%}%>

	var fm = document.form1;
	fm.car_old_exp.value = (<%= carOld.get("YEAR") %>*12)+<%= carOld.get("MONTH") %>;

	fm.depreciation.value 	= parseDecimal(<%=car_amt+opt_amt+clr_amt-tax_dc_amt%> - toInt(parseDigit(fm.apply_secondhand_price.value)));
</script>
</body>
</html>
