<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, acar.res_search.*, acar.con_ins.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="ai_db2" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "10");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String fee_start_dt = "";
	String ext_fee_start_dt = "";
	String im_fee_start_dt = "";
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//���뺸��������
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//��������
		String ins_st = ai_db2.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	ext_fee_start_dt = rs_db.addDay(ext_fee.getRent_end_dt(), 1);
	fee_start_dt = ext_fee_start_dt;
	
	//���ǿ���
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	int im_vt_size = im_vt.size();
	String im_end_dt = "";
	for(int i = 0 ; i < im_vt_size ; i++){
  	Hashtable im_ht = (Hashtable)im_vt.elementAt(i);
  	im_end_dt = String.valueOf(im_ht.get("RENT_END_DT"));
  }
  if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){
  	im_fee_start_dt = rs_db.addDay(im_end_dt, 1);
  	fee_start_dt = im_fee_start_dt;
  }
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//fee_etc
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�����̿���
	CarMgrBean mgr1 = a_db.getCarMgr(rent_mng_id, rent_l_cd, "�����̿���");
	
	
	//4. ����----------------------------
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
		
	String a_e = cm_bean.getS_st();
	
	
	Hashtable sh_ht = new Hashtable();
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt(), fee_start_dt);
	
	//�縮�������⺻�������̺�
	Hashtable ht = shDb.getShBase(base.getCar_mng_id());
			
	//��������-�������̺� ���� ��ȸ
	Hashtable ht2 = shDb.getBase(base.getCar_mng_id(), fee_start_dt);
	
	//���� ���� ����Ÿ�(������)�� ������ 
	if(AddUtil.parseDouble(String.valueOf(ht2.get("TOT_DIST")))>0 && f_fee_etc.getOver_bas_km() > 0){
		Hashtable carOld2 	= c_db.getOld(fee.getRent_start_dt(), String.valueOf(ht2.get("SERV_DT")));
		double start_serv_mon = (AddUtil.parseDouble(String.valueOf(carOld2.get("YEAR")))*12)+AddUtil.parseDouble(String.valueOf(carOld2.get("MONTH")));
		//���� �ֱ��� ����Ÿ��� ���� ��� �뿩������(������)�κ��� 3���� �ʰ�
		if(start_serv_mon>3){
			Hashtable ht3 = shDb.getBase(base.getCar_mng_id(), fee_start_dt, "1", fee.getRent_start_dt(), f_fee_etc.getOver_bas_km(), f_fee_etc.getAgree_dist());
			ht2.put("TODAY_DIST", String.valueOf(ht3.get("TODAY_DIST")));
		//���� �ֱ��� ����Ÿ��� ���� ��� �뿩������(������)�κ��� 3���� �̳�	
		}else{
			Hashtable ht3 = shDb.getBase(base.getCar_mng_id(), fee_start_dt, "2", fee.getRent_start_dt(), f_fee_etc.getOver_bas_km(), f_fee_etc.getAgree_dist());
			ht2.put("TODAY_DIST", String.valueOf(ht3.get("TODAY_DIST")));
		}
	}
			
	if(String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
		ht2.put("REG_ID", user_id);
		ht2.put("SECONDHAND_DT", fee_start_dt);
		//sh_base table insert
		int count = shDb.insertShBase(ht2);
	}else{
		int chk = 0;
		if(!String.valueOf(ht2.get("SECONDHAND_DT")).equals(fee_start_dt)) 									chk++;
		if(!String.valueOf(ht2.get("BEFORE_ONE_YEAR")).equals(String.valueOf(ht.get("BEFORE_ONE_YEAR")))) 	chk++;
		if(!String.valueOf(ht2.get("SERV_DT")).equals(String.valueOf(ht.get("SERV_DT")))) 					chk++;
		if(!String.valueOf(ht2.get("TOT_DIST")).equals(String.valueOf(ht.get("TOT_DIST")))) 				chk++;
		if(!String.valueOf(ht2.get("TODAY_DIST")).equals(String.valueOf(ht.get("TODAY_DIST")))) 			chk++;
		if(!String.valueOf(ht2.get("PARK")).equals(String.valueOf(ht.get("PARK")))) 						chk++;
		if(chk >0){
			ht2.put("SECONDHAND_DT", fee_start_dt);
			//sh_base table update
			int count = shDb.updateShBase(ht2);
		}
	}
	//��������
	sh_ht = shDb.getShBase(base.getCar_mng_id());
		
	int fee_opt_amt = 0;
	
	//���ɸ����� �ִ뿬�� �ݿ���
	String car_end_dt_max = cr_bean.getInit_reg_dt();
	//2000cc�̸��� 5+2=7��
	car_end_dt_max = c_db.addMonth(car_end_dt_max, 82);
	
	//��LPG -1����
	if(!ej_bean.getJg_b().equals("2")){
		car_end_dt_max = c_db.addMonth(car_end_dt_max, 1);
	}
	
	//2000cc�ʰ��� 8+2=10��
	if(AddUtil.parseInt(cr_bean.getDpm()) > 2000){
		car_end_dt_max = c_db.addMonth(car_end_dt_max, 36);
	}
	
	//20211126 ������ 1���� �� �� (������ ���������ϸ� �� ��� ��) - �豤�������û
	car_end_dt_max = c_db.addMonth(car_end_dt_max, -1);
	
	
	//���Ǻ����� ���� ������������ϰ� �������� �������� ������� �������� ���� �Ǿ�� �Ѵ�.
	String ins_cust_chk = "";
	
	if(!ins.getCon_f_nm().equals("�Ƹ���ī") && ins.getIns_exp_dt().equals(ext_fee.getRent_end_dt())){
		ins_cust_chk = "Y";	
	}
	
	//�ſ��� ���� ��� ó��
	if(base.getSpr_kd().equals("")){
   if(base.getCar_gu().equals("0")) base.setSpr_kd("1"); //�縮��-�췮���
   if(base.getCar_gu().equals("1")) base.setSpr_kd("2"); //����-�ʿ췮���
  }
	if(cont_etc.getDec_gr().equals("")){
   if(base.getCar_gu().equals("0")) cont_etc.setDec_gr("1"); //�縮��-�췮���
   if(base.getCar_gu().equals("1")) cont_etc.setDec_gr("2"); //����-�ʿ췮���
  }  
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//�� ����
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���õ� ���� �����ϴ�."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("���õ� ������ �����ϴ�."); return;}
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//���� üũ
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');
		}
	}
	
	function cng_stat_dt_input(){
		var fm = document.form1;
		<%if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){%>
				if(fm.start_dt_st[0].checked == true){
					fm.bas_dt.value 				= '<%= AddUtil.ChangeDate2(ext_fee_start_dt) %>';
					fm.rent_start_dt.value 	= '<%= AddUtil.ChangeDate2(ext_fee_start_dt) %>';		
					fm.sh_day_bas_dt.value 	= '<%= AddUtil.ChangeDate2(ext_fee_start_dt) %>';
				}else{
					fm.bas_dt.value 				= '<%= AddUtil.ChangeDate2(im_fee_start_dt) %>';
					fm.rent_start_dt.value 	= '<%= AddUtil.ChangeDate2(im_fee_start_dt) %>';	
					fm.sh_day_bas_dt.value 	= '<%= AddUtil.ChangeDate2(im_fee_start_dt) %>';	
				}
				
				set_cont_date(fm.con_mon);
		<%}%>
	}
	
	//�뿩�Ⱓ ����
	function set_cont_date(obj){
		var fm = document.form1;
		var rent_way = fm.rent_way.value;
		
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;
		
		<%if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){%>
			if(fm.start_dt_st[0].checked == false && fm.start_dt_st[1].checked == false){
				alert('���ǿ���Ⱓ ���� ���θ� �����Ͻʽÿ�.'); 
				fm.con_mon.value = '';
				fm.rent_start_dt.value = '';
				fm.start_dt_st[0].focus();
				return;	
			}
		<%}%>

		if(obj == fm.con_mon && rent_way == '1'){
			fm.fee_pay_tm.value = toInt(fm.con_mon.value)-3;
			fm.rent_start_dt.value = ChangeDate(fm.rent_start_dt.value);
		}	
		if(obj == fm.con_mon && rent_way != '1'){
			fm.fee_pay_tm.value = fm.con_mon.value;
			fm.rent_start_dt.value = ChangeDate(fm.rent_start_dt.value);
		}	
		
		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
					
		fm.action='get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
		
		if(obj == fm.con_mon){
			getSecondhandCarAmt_h();
		}
		
	
	}
	
	//�ݿø�
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}	
	
	//�������� �Է½� �ڵ�������� ����..
	function enter_fee(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_fee_amt(obj);
	}	
	//���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_fee_amt(obj)
	{
		var fm = document.form1;	
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		
		var f_car_price = car_price;
					
		car_price 	= toInt(parseDigit(fm.sh_amt.value));
		
		<%if(ext_fee.getOpt_s_amt()>0){%>
		car_price	= <%=ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt()%>;		
		<%}%>
						
		//������---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
				fm.f_gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / f_car_price * 100, 1);
			}
			sum_pp_amt();			
		}else if(obj==fm.grt_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
				fm.f_gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / f_car_price * 100, 1);				
			}
			sum_pp_amt();		
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
				fm.f_pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / f_car_price * 100, 1);
			}
			sum_pp_amt();			
		}else if(obj==fm.pp_v_amt){ 	//������ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
				fm.f_pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / f_car_price * 100, 1);
			}		
			sum_pp_amt();	
		}else if(obj==fm.pp_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));			
					
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
				fm.f_pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / f_car_price * 100, 1);
			}			
			sum_pp_amt();
		//���ô뿩��---------------------------------------------------------------------------------			
		}else if(obj==fm.ifee_s_amt){ 	//���ô뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ifee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			sum_pp_amt();
		}else if(obj==fm.ifee_v_amt){ 	//���ô뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			sum_pp_amt();					
		}else if(obj==fm.ifee_amt){ 	//���ô뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));	
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);			
			sum_pp_amt();		
		//�����ܰ���---------------------------------------------------------------------------------			
		}else if(obj==fm.app_ja){ 		//�����ܰ���
			fm.ja_r_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.app_ja.value) /100,-3) );
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
		}else if(obj==fm.ja_r_s_amt){ 	//�����ܰ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
			//fm.app_ja.value 		= parseFloatCipher3(toInt(parseDigit(fm.ja_amt.value)) / car_price * 100, 1);
		}else if(obj==fm.ja_r_v_amt){ 	//�����ܰ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_amt){		//�����ܰ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));	
			if(car_price > 0){		
				fm.app_ja.value 		= parseFloatCipher3(toInt(parseDigit(fm.ja_r_amt.value)) / car_price * 100, 1);
			}
		//���Կɼ���---------------------------------------------------------------------------------					
		}else if(obj==fm.opt_s_amt){ 	//���Կɼ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));		
			if(car_price > 0){			
				fm.opt_per.value 		= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
				fm.f_opt_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / f_car_price * 100, 1);
			}
			if(toInt(parseDigit(fm.opt_amt.value))==0 || toInt(parseDigit(fm.opt_amt.value)) >toInt(parseDigit(fm.ja_amt.value))){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//�ִ�
			}else{
				fm.opt_chk[0].checked = true;//����
			}
		}else if(obj==fm.opt_v_amt){ 	//���Կɼ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(toInt(parseDigit(fm.opt_amt.value))==0 || toInt(parseDigit(fm.opt_amt.value)) >toInt(parseDigit(fm.ja_amt.value))){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//�ִ�
			}else{
				fm.opt_chk[0].checked = true;//����
			}			
		}else if(obj==fm.opt_amt){ 		//���Կɼ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));	
			if(car_price > 0){				
				fm.opt_per.value 		= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
				fm.f_opt_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / f_car_price * 100, 1);
			}
			if(toInt(parseDigit(fm.opt_amt.value))==0 || toInt(parseDigit(fm.opt_amt.value)) >toInt(parseDigit(fm.ja_amt.value))){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//�ִ�
			}else{
				fm.opt_chk[0].checked = true;//����
			}			
		//���뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.fee_s_amt){ 	//���뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
			//if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			//}
		}else if(obj==fm.fee_v_amt){ 	//���뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value		= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.fee_amt){ 		//���뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			dc_fee_amt();
			//if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			//}
		//������뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.ins_s_amt){ 	//������뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ins_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) * 0.1 );
			fm.ins_amt.value	= parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)));			
			

			
			dc_fee_amt();
			setTinv_amt();
	 	}else if(obj==fm.ins_v_amt){ 
	 		//������뿩�� �ΰ���
	 		obj.value = parseDecimal(obj.value);
			fm.ins_amt.value = parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)));	
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.ins_amt){ 		//������뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ins_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_amt.value))));
			fm.ins_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_amt.value)) - toInt(parseDigit(fm.ins_s_amt.value)));	
			dc_fee_amt();
			setTinv_amt();
			/* if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)); 
			} */
		//�Ѻ����---------------------------------------------------------------------------------
		}else if(obj==fm.ins_total_amt){
			obj.value = parseDecimal(obj.value);
			fm.ins_total_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_total_amt.value)));
		//�����뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//�����뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.inv_v_amt){ 	//�����뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value		= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.inv_amt){ 		//�����뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
			
		//������ �߰����(2018.03.30)-------------------------------------------------------------------	
		}else if(obj==fm.driver_add_amt){	//�������߰���� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.driver_add_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) * 0.1 );
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.driver_add_v_amt){ 	//�������߰���� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.driver_add_total_amt){ //�������߰���� �հ�			
			obj.value = parseDecimal(obj.value);
			fm.driver_add_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.driver_add_total_amt.value))));
			fm.driver_add_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.driver_add_total_amt.value)) - toInt(parseDigit(fm.driver_add_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}
		
	}
	
	//�������հ� ���ϱ�
	function setTinv_amt(){
		fm.tinv_s_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.driver_add_amt.value)));
		fm.tinv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
		fm.tinv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.driver_add_total_amt.value)));
	}
	
	//������ �հ�
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		
		
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
		fm.credit_r_per.value = parseFloatCipher3(pp_price / car_price * 100, 1);
		fm.credit_r_amt.value = parseDecimal(pp_price);
	}
	
	//�뿩�� DC�� ���
	function dc_fee_amt(){
		var fm = document.form1;
		
		var pp_s_amt	= toInt(parseDigit(fm.pp_s_amt.value));		//������
		var fee_s_amt	= toInt(parseDigit(fm.fee_s_amt.value));	//���뿩��(����)
		var inv_s_amt	= toInt(parseDigit(fm.inv_s_amt.value));	//����뿩��(����)
		var con_mon		= toInt(parseDigit(fm.con_mon.value));		//�뿩�Ⱓ 
		var dc_ra;
		
		//�����ݿ��� �����.
		if(<%=base.getRent_dt()%> < 20150512){		
			if(inv_s_amt > 0){
				dc_ra = (1 - (pp_s_amt+fee_s_amt*con_mon)/(pp_s_amt+inv_s_amt*con_mon))*100;
				fm.dc_ra.value = parseFloatCipher3(dc_ra,1);
			}
		}
	}	
	
	//������ġ�� ����
	function set_janga(){
		var fm = document.form1;	
		
		if(fm.rent_dt.value == ''){	alert('������ڸ� �Է��Ͻʽÿ�.'); return;}
		if(fm.con_mon.value == ''){	alert('�̿�Ⱓ�� �Է��Ͻʽÿ�.'); return;}		
		
		var fm2 = document.sh_form;	
		fm2.rent_dt.value 		= fm.rent_start_dt.value;
		fm2.a_b.value 			= fm.con_mon.value;
		fm2.fee_opt_amt.value 	= fm.fee_opt_amt.value;
		fm2.action='/acar/secondhand/getSecondhandJanga.jsp';
		fm2.target='i_no2';
		fm2.submit();			
	}	
	
	//�����뿩�� ��� (����)
	function estimate(st){
		var fm = document.form1;
		set_fee_amt(fm.opt_amt);
		if(fm.rent_dt.value == '')		{ alert('���������ڸ� �Է��Ͻʽÿ�.'); 	return; }
		if(fm.car_mng_id.value == '')	{ alert('í���� ���õ��� �ʾҽ��ϴ�. Ȯ���Ͻʽÿ�.'); 	return; }		
		
		if(fm.insurant.value == '1' && fm.insur_per.value == '2'){
			if(fm.ins_s_amt.value == '0' || fm.ins_s_amt.value =='' ) {confirm('������Ḧ �Է����� �ʾҽ��ϴ�. ��� �����Ͻðڽ��ϱ�?');		return; };
			if(fm.ins_v_amt.value == '0' || fm.ins_v_amt.value =='') {confirm('������Ḧ �Է����� �ʾҽ��ϴ�. ��� �����Ͻðڽ��ϱ�?');		return; };
		}
		
		//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
		if('<%=base.getCar_st()%><%=ext_fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
				return;					
			}
		}else{
			//if(fm.insurant.value == '2'){
			//	alert('�������� ���� �����⺻�ĸ� �����մϴ�.');
			//	return;
			//}			
		}			
		
		fm.o_13.value 		= fm.app_ja.value;
		fm.o_13_amt.value 	= fm.ja_r_amt.value;
		
		fm.ro_13.value 		= fm.max_ja.value;
		
		fm.grt_amt.value 	= fm.grt_s_amt.value;
		
		<%if(ext_fee.getOpt_s_amt()>0){%>
		fm.o_1.value	= <%=ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt()%>;		
		<%}else{%>
		fm.o_1.value	= fm.sh_amt.value;
		<%}%>

		fm.esti_stat.value 	= st;
		
		fm.fee_rent_dt.value = replaceString("-","",fm.rent_start_dt.value);
		
		
		//�߰������� ����
		fm.sh_day_bas_dt.value = replaceString("-","",fm.rent_start_dt.value);		
		getSecondhandCarAmt_h();
		
		set_fee_amt(fm.grt_s_amt);
		

		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;	
		fm.action='get_fee_estimate_20090901.jsp';	
		
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}

		fm.submit();

	}
	

	//���
	function save(idx){
		var fm = document.form1;
		
			if(toInt(parseDigit(fm.grt_s_amt.value))>0){
				set_fee_amt(fm.grt_s_amt);
			}
			
			if(fm.con_mon.value == '')				{ alert('�뿩���-�̿�Ⱓ�� �Է��Ͻʽÿ�.'); 					fm.con_mon.focus(); 		return; }
			if(fm.ext_agnt.value == '')				{ alert('�뿩���-������ڸ� �Է��Ͻʽÿ�.'); 					fm.ext_agnt.focus(); 		return; }
			if(fm.rent_start_dt.value == '')	{ alert('�뿩���-�뿩�������� �Է��Ͻʽÿ�.'); 					fm.rent_start_dt.focus(); 	return; }
			if(fm.rent_end_dt.value == '')		{ alert('�뿩���-�뿩�������� �Է��Ͻʽÿ�.'); 					fm.rent_end_dt.focus(); 		return; }
			if(fm.ext_agnt.value.substring(0,1) == '1')		{ alert('������ڰ� �μ��� ���õǾ����ϴ�. Ȯ�����ּ���.'); return; }
		
			<%	//���ǿ����� �����϶� fee_stat_dt
				if(im_vt_size>0){%>
			if(	toInt(replaceString('-','',fm.im_fee_start_dt.value)) > toInt(replaceString('-','',fm.rent_start_dt.value)) ){
				if(!confirm('���ǿ����� �ִ� ����Դϴ�. ���ǿ��� �뿩������('+ChangeDate(fm.im_end_dt.value)+')�� ���� �������� �뿩������(<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%>)�� Ȯ���Ͻð�, �Է��� �뿩��������('+fm.rent_start_dt.value+')�� �´��� Ȯ���Ͻñ� �ٶ��ϴ�.'))			
					return;
			}
			<%	}%>				
		
			if(fm.driving_age.value == '')			{ alert('�������-�����ڿ����� �Է��Ͻʽÿ�.'); 			fm.driving_age.focus(); 	return; }
			if(fm.gcp_kd.value == '')				{ alert('�������-�빰��� ���Աݾ��� �Է��Ͻʽÿ�.'); 		fm.gcp_kd.focus(); 			return; }
			if(fm.bacdt_kd.value == '')				{ alert('�������-�ڱ��ü��� ���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.bacdt_kd.focus(); 		return; }
			
			<%if((base.getCar_st().equals("5") || client.getClient_st().equals("1")) && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	 
				if(fm.com_emp_yn.value == '')			{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');	fm.com_emp_yn.focus(); 		return; }
			<%}else if(AddUtil.parseInt(client.getClient_st()) >2 && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
				//���λ���� ������������ ���Ѿ���
				if(fm.com_emp_yn.value == '')			{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');	fm.com_emp_yn.focus(); 		return; }
			<%}else{%>
				if(fm.com_emp_yn.value == 'Y')			{ alert('�������-��������������Ư�� ���Դ���� �ƴѵ� �������� �Ǿ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');	fm.com_emp_yn.focus(); 	return; }
			<%}%>
			
		
			if(fm.driving_age.value=='1' && fm.age_scp.value!='1'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
			if(fm.driving_age.value=='3' && fm.age_scp.value!='4'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
			if(fm.driving_age.value=='0' && fm.age_scp.value!='2'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
			if(fm.driving_age.value=='2' && fm.age_scp.value!='3'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
			if(fm.driving_age.value=='5' && fm.age_scp.value!='5'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}			
			if(fm.driving_age.value=='6' && fm.age_scp.value!='6'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}			
			if(fm.driving_age.value=='7' && fm.age_scp.value!='7'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}			
			if(fm.driving_age.value=='8' && fm.age_scp.value!='8'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}												
			
			if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}
			if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}
			if(fm.gcp_kd.value=='3' && fm.vins_gcp_kd.value!='6'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}
			if(fm.gcp_kd.value=='4' && fm.vins_gcp_kd.value!='7'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}			
			
			if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk3.value =	'�ڱ��ü��� ';	}
			if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk3.value =	'�ڱ��ü��� ';	}
			if(fm.bacdt_kd.value=='9' && fm.vins_bacdt_kd.value!='9'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk3.value =	'�ڱ��ü��� ';	}
		
			
			if(fm.con_mon.value == '')				{ alert('�뿩���-�̿�Ⱓ�� �Է��Ͻʽÿ�.'); 					fm.con_mon.focus(); 		return; }
			if(fm.ext_agnt.value == '')				{ alert('�뿩���-������ڸ� �Է��Ͻʽÿ�.'); 					fm.ext_agnt.focus(); 		return; }
			if(fm.rent_end_dt.value == '')		{ alert('�뿩���-��ุ������ �Է��Ͻʽÿ�.'); 					fm.rent_end_dt.focus(); 		return; }
			
			if(fm.ext_agnt.value.substring(0,1) == '1')		{ alert('������ڰ� �μ��� ���õǾ����ϴ�. Ȯ�����ּ���.'); return; }		
			
			
			
			if(toInt(parseDigit(fm.fee_amt.value))>0){
			
				if(fm.app_ja.value == '')				{ alert('�뿩���-�����ܰ����� �Է��Ͻʽÿ�.'); 			fm.app_ja.focus(); 			return; }
				var ja_amt = toInt(parseDigit(fm.ja_amt.value));
				if(ja_amt == 0)							{ alert('�뿩���-������ġ�ݾ��� �Է��Ͻʽÿ�.'); 			fm.ja_amt.focus(); 			return; }
				//if(fm.opt_chk.value == '')				{ alert('�뿩���-���Կɼ� ���θ� �Է��Ͻʽÿ�.'); 			fm.opt_chk.focus(); 		return; }				
				//if(fm.opt_chk.value == '1'){
				if(fm.opt_chk[0].checked == false && fm.opt_chk[1].checked == false)				{ alert('�뿩���-���Կɼ� ���θ� �Է��Ͻʽÿ�.'); 			fm.opt_chk.focus(); 		return; }
				if(fm.opt_chk[1].checked == true){
					if(fm.opt_per.value == '')			{ alert('�뿩���-���Կɼ����� �Է��Ͻʽÿ�.'); 			fm.opt_per.focus(); 		return; }
					var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
					if(opt_amt == 0)					{ alert('�뿩���-���ԿɼǱݾ��� �Է��Ͻʽÿ�.'); 			fm.opt_amt.focus(); 		return; }
				}
				if(fm.opt_chk[0].checked == true){
					var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
					if(opt_amt > 0)						{ alert('�뿩���-���ԿɼǾ������� �Ǿ� ������ ���ԿɼǱݾ��� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');	fm.opt_amt.focus(); 		return; }
					//fm.opt_s_amt.value = 0;
					//fm.opt_v_amt.value = 0;
					//fm.opt_amt.value = 0;
					//fm.opt_per.value = 0;
				}
				if(fm.cls_r_per.value == '')			{ alert('�뿩���-�ߵ����������� �Է��Ͻʽÿ�.'); 			fm.cls_r_per.focus(); 		return; }
				var fee_amt = toInt(parseDigit(fm.fee_amt.value));
				var inv_amt = toInt(parseDigit(fm.inv_amt.value));
				if(inv_amt == 0)						{ alert('�뿩���-�뿩�� �����ݾ��� �Է��Ͻʽÿ�.'); 		fm.inv_amt.focus(); 		return; }
				if(fm.fee_sac_id.value == '')			{ alert('�뿩���-��� �����ڸ� �Է��Ͻʽÿ�.'); 			fm.fee_sac_id.focus(); 		return; }
				if(fm.fee_pay_tm.value == '')			{ alert('�뿩���-����Ƚ���� �Է��Ͻʽÿ�.'); 				fm.fee_pay_tm.focus(); 		return; }
				
				if(fm.fee_est_day.value == '')			{ alert('�뿩���-�������ڸ� �Է��Ͻʽÿ�.'); 				fm.fee_est_day.focus(); 	return; }
			}
			//����������
			var grt_amt = toInt(parseDigit(fm.grt_s_amt.value));
			var ifee_amt = toInt(parseDigit(fm.ifee_amt.value));
		
			if (grt_amt > 0 ) {
				if(fm.grt_suc_yn.value == '')			{ alert('������-���������� �����Ͻʽÿ�.'); 			fm.grt_suc_yn.focus(); 		return; }
				//��������� �������� ���ٸ� ���� 20180711
				if(toInt(parseDigit(fm.ext_grt_amt.value))==0)				{ fm.grt_suc_yn.value = '1'; }
				//��������� �����ݰ� �������� �������� ���ٸ� �°� 20180711
				if(grt_amt == toInt(parseDigit(fm.ext_grt_amt.value))){ fm.grt_suc_yn.value = '0'; }
			}else{
				if(fm.grt_suc_yn.value != '')			{ fm.grt_suc_yn.value = '' }
			}
			
			if (ifee_amt > 0 ) {
				if(fm.ifee_suc_yn.value == '')			{ alert('���ô뿩��-���������� �����Ͻʽÿ�.'); 		fm.ifee_suc_yn.focus(); 	return; }
			}		
			
			//������������ ��� ���ɸ����� üũ�ؼ� ���常������ ����� �� ��� ����� �ȵǵ��� �Ѵ�.
			<%if(!ck_acar_id.equals("000029") && !ck_acar_id.equals("000026") && cr_bean.getCar_use().equals("1")){%>
			if(toInt(replaceString('-','','<%=car_end_dt_max%>')) < toInt(replaceString('-','',fm.rent_end_dt.value)) ){
				alert('�뿩�Ⱓ �������� ���ɸ����Ϻ��� Ů�ϴ�. Ȯ���Ͻʽÿ�.'); 						fm.rent_end_dt.focus(); 	return;
			}
			<%}%>
			
			<%if(client.getClient_st().equals("2") || client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")){%>
				
				if(fm.lic_no.value == '' && fm.mgr_lic_no.value == ''){
					alert('����,���λ���ڴ� ���������ȣ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.lic_no.value != '' && fm.lic_no.value.length < 12){
					alert('����� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_no.value.length < 12){
					alert('�����̿��� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
					return;
				}			
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_emp.value == ''){
					alert('�����̿��� ���������ȣ �̸��� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_rel.value == ''){
					alert('�����̿��� ���������ȣ ���踦 �Է��Ͻʽÿ�.');
					return;
				}
    	<%}%>
    	
    	
    	if(fm.gi_st[0].checked == false && fm.gi_st[1].checked == false){	
    		alert('�������� ���Կ��θ� �����Ͻʽÿ�.'); fm.gi_st[0].focus(); return; 
    	}
			
		if(toInt(parseDigit(fm.grt_s_amt.value))==0 && fm.gi_st[1].checked == true){
			if(!confirm('�������� ���� �������� ������ �Ǿ� �ֽ��ϴ�. ���� ����� �����Ͻðڽ��ϱ�?')){	return;	}	
		}			
	
		
		if(confirm('����Ͻðڽ��ϱ�?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			fm.action='lc_renew_c_a.jsp';		
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}							
	}

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	
	
	//�°迩�ο� ���� ���÷���
	function display_suc(st){
		var fm = document.form1;
		if(st == 'grt'){
			if(fm.grt_suc_yn.value == '0'){
				fm.grt_s_amt.value  = '<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>';
				set_fee_amt(fm.grt_s_amt);
			}
		}else if(st == 'ifee'){
			if(fm.ifee_suc_yn.value == '0'){
				fm.ifee_s_amt.value = '<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt())%>';
				fm.ifee_v_amt.value = '<%=AddUtil.parseDecimal(ext_fee.getIfee_v_amt())%>';
				fm.ifee_amt.value   = '<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>';
				set_fee_amt(fm.ifee_s_amt);
			}
		}		
	}
	//�뿩���
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=650, scrollbars=yes");
	}		
	//��������
	function view_car_amt(rent_mng_id, rent_l_cd)
	{		
		window.open("/fms2/lc_rent/view_car_amt.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&cmd=view", "VIEW_CAR_AMT", "left=100, top=100, width=850, height=450, scrollbars=yes");
	}		
	
	//�߰������� ����ϱ�-���
	function getSecondhandCarAmt_h(){
		var fm = document.sh_form;
		var fm2 = document.form1;		
		
		fm.a_b.value 		= fm2.con_mon.value;
		fm.rent_dt.value 	= replaceString('-','',fm2.rent_start_dt.value);
		fm.today_dist.value = fm2.sh_km.value;
		
		if(fm.a_b.value == '' || fm.a_b.value == '0')	return;
		if(fm.rent_dt.value == '')						return;
		
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "i_no2";
//		fm.target = "_blank";
		fm.submit();
	}
	
	
	//�߰������� ����ϱ�-���
	function getSecondhandCarAmt(){
		var fm = document.sh_form;
		var fm2 = document.form1;		
		
		fm.a_b.value 		= fm2.con_mon.value;
		fm.rent_dt.value 	= replaceString('-','',fm2.rent_start_dt.value);
		fm.today_dist.value = fm2.sh_km.value;
		fm.mode.value 		= 'view';
		
		if(fm.a_b.value == '' || fm.a_b.value == '0')	return;
		if(fm.rent_dt.value == '')						return;
				
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "_blank";
		fm.submit();
	}	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name="mode"				value="lc_rent">    
  <input type='hidden' name="rent_st"			value="2"><!--�������-->      
  <input type='hidden' name="rent_dt"			value="">        
  <input type='hidden' name="a_b"				value="">  
  <input type='hidden' name="fee_opt_amt"		value="">      
  <input type='hidden' name="today_dist"		value="">        
</form>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">
  <input type='hidden' name="car_ext" 			value="<%=car.getCar_ext()%>">
  <input type='hidden' name="udt_st" 			value="<%=pur.getUdt_st()%>">    
  <input type='hidden' name="dpm" 				value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="s_dc1_re" 			value="<%=car.getS_dc1_re()%>">
  <input type='hidden' name="s_dc1_yn" 			value="<%=car.getS_dc1_yn()%>">
  <input type='hidden' name="s_dc1_amt"			value="<%=car.getS_dc1_amt()%>">
  <input type='hidden' name="s_dc2_re" 			value="<%=car.getS_dc2_re()%>">
  <input type='hidden' name="s_dc2_yn" 			value="<%=car.getS_dc2_yn()%>">
  <input type='hidden' name="s_dc2_amt"			value="<%=car.getS_dc2_amt()%>">
  <input type='hidden' name="s_dc3_re" 			value="<%=car.getS_dc3_re()%>">
  <input type='hidden' name="s_dc3_yn" 			value="<%=car.getS_dc3_yn()%>">
  <input type='hidden' name="s_dc3_amt"			value="<%=car.getS_dc3_amt()%>">
  <input type='hidden' name="s_dc1_re_etc"		value="<%=car.getS_dc1_re_etc()%>">  
  <input type='hidden' name="s_dc2_re_etc"		value="<%=car.getS_dc2_re_etc()%>">  
  <input type='hidden' name="s_dc3_re_etc"		value="<%=car.getS_dc3_re_etc()%>">      
  <input type='hidden' name="s_dc1_per"			value="<%=car.getS_dc1_per()%>">  
  <input type='hidden' name="s_dc2_per"			value="<%=car.getS_dc2_per()%>">  
  <input type='hidden' name="s_dc3_per"			value="<%=car.getS_dc3_per()%>">        
  <input type='hidden' name="car_end_dt"		value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>      
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name='spr_kd' 			value='<%=base.getSpr_kd()%>'>  
  <input type="hidden" name="car_cs_amt"   		value="<%=car.getCar_cs_amt()%>">  
  <input type="hidden" name="car_cv_amt"   		value="<%=car.getCar_cv_amt()%>">
  <input type="hidden" name="car_c_amt"   		value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">  
  <input type="hidden" name="car_fs_amt"   		value="<%=car.getCar_fs_amt()%>">  
  <input type="hidden" name="car_fv_amt"   		value="<%=car.getCar_fv_amt()%>">    
  <input type="hidden" name="car_f_amt"   		value="<%=car.getCar_fs_amt()+car.getCar_fv_amt()%>">      
  <input type="hidden" name="opt_cs_amt"   		value="<%=car.getOpt_cs_amt()%>">  
  <input type="hidden" name="opt_cv_amt"   		value="<%=car.getOpt_cv_amt()%>">    
  <input type="hidden" name="opt_c_amt"   		value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">    
  <input type="hidden" name="sd_cs_amt"   		value="<%=car.getSd_cs_amt()%>">  
  <input type="hidden" name="sd_cv_amt"   		value="<%=car.getSd_cv_amt()%>">    
  <input type="hidden" name="sd_c_amt"   		value="<%=car.getSd_cs_amt()+car.getSd_cv_amt()%>">      
  <input type="hidden" name="col_cs_amt"   		value="<%=car.getClr_cs_amt()%>">  
  <input type="hidden" name="col_cv_amt"   		value="<%=car.getClr_cv_amt()%>">    
  <input type="hidden" name="col_c_amt"   		value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">      
  <input type="hidden" name="dc_cs_amt"   		value="<%=car.getDc_cs_amt()%>">  
  <input type="hidden" name="dc_cv_amt"   		value="<%=car.getDc_cv_amt()%>">    
  <input type="hidden" name="dc_c_amt"   		value="<%=car.getDc_cs_amt()+car.getDc_cv_amt()%>">        
  <input type="hidden" name="spe_tax"   		value="<%=car.getSpe_tax()%>">  
  <input type="hidden" name="edu_tax"   		value="<%=car.getEdu_tax()%>">
  <input type="hidden" name="tot_tax"   		value="<%=car.getSpe_tax()+car.getEdu_tax()%>">
  <input type='hidden' name="o_1"				value="">
  <input type='hidden' name="ro_13"				value="">  
  <input type='hidden' name="o_13"				value="">  
  <input type='hidden' name="o_13_amt"			value="">      
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
    
  <input type='hidden' name="est_from"			value="lc_renew">      
  <input type='hidden' name="fee_opt_amt"		value="">  
  
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">   
  <input type='hidden' name="ins_chk4"			value="">                         
  <input type='hidden' name="firm_nm"				value="<%=client.getFirm_nm()%>">    
  <input type='hidden' name='client_st' 		value='<%=client.getClient_st()%>'>              
  <input type='hidden' name="fee_rent_st"		value="<%=fee_size+1%>">      
  <input type='hidden' name="fee_rent_dt"		value="">              
  <input type='hidden' name="ext_fee_start_dt"	value="<%=ext_fee_start_dt%>">              
  <input type='hidden' name="im_fee_start_dt"	value="<%=im_fee_start_dt%>">              
  <input type='hidden' name="im_end_dt"			value="<%=im_end_dt%>">                
  <!-- 2018.04.02 �߰� -->
  <input type="hidden" name="e_rtn_run_amt"	value="">
  <input type="hidden" name="e_rtn_run_amt_yn"	value="">
  <input type="hidden" name="e_over_run_amt"	value="">
  <input type="hidden" name="e_agree_dist"		value="">
  <input type="hidden" name="r_agree_dist"		value="">
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr> 
                    <td class=title>���ʿ�����</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title>�����븮��</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>��౸��</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>�ű�<%}else if(rent_st.equals("3")){%>����<%}else if(rent_st.equals("4")){%>����<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ�<%}else if(bus_st.equals("2")){%>�������<%}else if(bus_st.equals("3")){%>��ü�Ұ�<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>��ȭ���<%}else if(bus_st.equals("6")){%>������ü<%}else if(bus_st.equals("7")){%>������Ʈ<%}else if(bus_st.equals("8")){%>�����<%}%></td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
                </tr>
                <tr>
                    <td class=title>��ȣ</td>
                    <td>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a></td>
                    <td class=title>��ǥ��</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>����/����</td>
                    <td>&nbsp;<a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=site.getR_site()%></a></td>
                </tr>
                <tr>
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a>
					    &nbsp;&nbsp;&nbsp;
						<b><font color="#999999">[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></font></b>
					</td>
                    <td class=title>����</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp;<font color=red><b><%=AddUtil.ChangeDate2(cr_bean.getCar_end_dt())%></b></font>
                    	<%if(cr_bean.getCar_use().equals("1")){
							int car_end_d_day = c_db.getCar_D_day("car_end_dt", base.getCar_mng_id());
						%>
						<%if(car_end_d_day <= 30){ %><font color=red>(D-day <%=car_end_d_day%>��)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_end_d_day%>��<%}} %>
						<%} %>
                    </td>
                </tr>
                <%	
        		    	int car_maint_d_day = c_db.getCar_D_day("car_maint_dt", base.getCar_mng_id());
				%>
                <tr>
                    <td class=title>�˻���ȿ�Ⱓ</td>
                    <td colspan='5'>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%> <%if(car_maint_d_day <= 30){ %><font color=red>(D-day <%=car_maint_d_day%>��)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_maint_d_day%>��<%}} %></b></td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
		<% if(!base.getCar_st().equals("2")){%>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="2">����</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">�������</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">�̿�Ⱓ</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
                    <td style="font-size : 8pt;" width="7%" class=title rowspan="2">�����</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">���뿩��</td>
                    <td style="font-size : 8pt;" class=title colspan="2">������</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">������</td>
                    <td style="font-size : 8pt;" class=title colspan="2">���ô뿩��</td>
                    <td style="font-size : 8pt;" class=title colspan="2">���Կɼ�</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>%</td>			
                </tr>
    		  <%for(int i=0; i<fee_size; i++){
    				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
    				if(fee_size >1 && (i+1)==(fee_size-1))	fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt();
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>����</td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%}}%>
            </table>
		<%}%>
	    </td>
	</tr>
	<%if(im_vt_size>0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǿ���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">����</td>
                    <td class=title width="20%">ȸ��</td>			
                    <td class=title width="37%">�뿩�Ⱓ</td>
                    <td class=title width="15%">�����</td>
                    <td class=title width="15%">�����</td>
                  </tr>
        		  <%	for(int i = 0 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=im_ht.get("ADD_TM")%>ȸ��</td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
                    <td align='center'><%=im_ht.get("USER_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("REG_DT")))%></td>
                  </tr>
        		  <%	} %>
            </table>
        </td>
    </tr>				
	<%}%>	
	<tr>
	    <td class=h></td>
	</tr>
    <%		if(ins_cust_chk.equals("Y")){%>
    <tr>
        <td><font color=red>* ���� �Ǻ������� ������ ������ ������ ���谻���� ���� �̷������ ���� ������ �� �����û�� �� �� �ֽ��ϴ�.</font></td>
    </tr>    
	<tr>
	    <td class=h></td>
	</tr>    
    <%		}%>    	

    <%if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){%>
    <tr>
        <td><font color=red>* ���ǿ����� �ֽ��ϴ�. ���ǿ���Ⱓ ���Կ��θ� �����Ͽ� �Է��Ͻʽÿ�. �뿩�Ⱓ�� �´��� Ȯ�����ּ���.</font></td>
    </tr>    
	<tr>
	    <td class=h></td>
	</tr>    
    <%		}%>       

	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> �����Һ��ڰ� </td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT")))%>' size='10' class='defaultnum' readonly>
        				  ��&nbsp;<font size='7' color='#999999'><a href="javascript:view_car_amt('<%=rent_mng_id%>','<%=rent_l_cd%>')"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></font></td>
                    <td class='title' width="10%">�ܰ���</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='sh_ja' value=''size='4' class='defaultnum' readonly>
%</td>
                    <td class='title' width='10%'>�߰�����</td>
                    <td>&nbsp;
                      <input type='text' name='sh_amt' value=''size='10' class='defaultnum' readonly>
��
</td>
                </tr>
                <tr>
                  <td class='title'>����</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_year' value='<%=carOld.get("YEAR")%>' size='1' class='white' readonly>
                    ��
                    <input type='text' name='sh_month' value='<%=carOld.get("MONTH")%>' size='2' class='white' readonly>
                    ����
                    <input type='text' name='sh_day' value='<%=carOld.get("DAY")%>' size='2' class='white' readonly>
                    �� (<input type='text' name='sh_init_reg_dt' value='<%=cr_bean.getInit_reg_dt()%>' size='11' class='white' readonly> ~
                    <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(fee_start_dt)%>' size='11' class='white' readonly>
                  )</td>
                </tr>
                <tr>
                  <td class='title'>��������Ÿ�</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>' class='defaultnum' >
km
/ Ȯ������Ÿ� <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>' class='defaultnum' >
km(
<input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>' class='default' >
)</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>       
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� �뿩���</span></td>
    </tr>
	    <input type='hidden' name="rent_st" value="<%=fee_size+1%>">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>            	
                <tr>
                    <td width="13%" align="center" class=title>�������</td>
                    <td width="20%">&nbsp;
        			  <input type="text" name="rent_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value); getSecondhandCarAmt_h();'></td>
                    <td width="10%" align="center" class=title>�������</td>
                    <td>&nbsp;
        			  <select name='ext_agnt'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
        			<td width="10%" align="center" class=title>�����븮��</td>
                    <td>&nbsp;
        			  <select name='bus_agnt_id' onchange="javascript:if(this.value!=''){ document.form1.bus_agnt_r_per.value='20';document.form1.bus_agnt_per.value='20'; }else{ document.form1.bus_agnt_r_per.value='';document.form1.bus_agnt_per.value=''; }">
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>			  
                </tr>
                <%if(im_vt_size >0 && AddUtil.parseInt(ext_fee.getRent_end_dt()) < AddUtil.parseInt(im_end_dt)){%>
                <tr>
                    <td width="13%" align="center" class=title>���ǿ���Ⱓ���Կ���</td>
                    <td colspan='5'>&nbsp;
                    	<input type='radio' name="start_dt_st" value='1' onClick="javascript:cng_stat_dt_input()">
                  		������
                  		<input type='radio' name="start_dt_st" value='2' onClick="javascript:cng_stat_dt_input()">
                  		����
                        </td>
                </tr>     
                <%}%>                
                <tr>
                    <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this); '>
            			 ����</td>
                    <td width="13%" align="center" class=title>��������</td>
                    <td colspan='3'>&nbsp;
                    	  <select name="rent_way">                            
                            <option value='1' <%if(ext_fee.getRent_way().equals("1")){%>selected<%}%>>�Ϲݽ�</option>                            
                            <option value='3' <%if(ext_fee.getRent_way().equals("3")){%>selected<%}%>>�⺻��</option>
                        </select>
            			  </td>
                </tr>

                <tr>
                    <td width="13%" align="center" class=title>�뿩������</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'></td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td colspan='3'>&nbsp;
                    <input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>                           
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="3" class='title'>����</td>
                    <td class='title' width='13%'>���ް�</td>
                    <td class='title' width='13%'>�ΰ���</td>
                    <td class='title' width='13%'>�հ�</td>
                    <td class='title' width="28%">�������</td>
                    <td class='title' width='20%'>��������</td>
                </tr>
                <tr>
                    <td width="3%" rowspan="5" class='title'>��<br>
                      ��</td>
                    <td width="10%" class='title' colspan="2">������</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='11' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">������
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_gur_p_per' class='fixnum' value='' readonly>
    				            %  
        				    </td>
                    <td align='center'>
        			    <input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>'>
        				<input type='hidden' name='ext_grt_amt' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>'>
        				<select name='grt_suc_yn' onChange="javascript:display_suc('grt')">
                              <option value=""  <%if(ext_fee.getGrt_amt_s()==0)%>selected<%%>>����</option>
                              <option value="0" <%if(ext_fee.getGrt_amt_s()> 0)%>selected<%%>>�°�</option>
                              <option value="1">����</option>
                            </select>				
                            (�°迩�θ� �°�� �ϸ� ���� ������ �������� ������Ű��, ������ �����ϸ� �ű� �������� �����˴ϴ�.)
        				</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">������</td>
                    <td align="center"><input type='text' size='11' name='pp_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='11' name='pp_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='11' name='pp_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">������
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_pere_r_per' class='fixnum' value='' readonly>
    				            %  
        				    </td>
        				  
                    <td align='center'>-<input type='hidden' name='pere_per' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">���ô뿩��</td>
                    <td align="center"><input type='text' size='11' name='ifee_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='11' name='ifee_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='11' name='ifee_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">������
                        <input type='text' size='2' name='pere_r_mth' class='fixnum' value='' readonly>
        				  ����ġ �뿩�� </td>
                    <td align='center'>
        			    <input type='hidden' name='pere_mth' value=''>
        				<select name='ifee_suc_yn' onChange="javascript:display_suc('ifee')">
                              <option value="">����</option>
                              <option value="0">�°�</option>
                              <option value="1">����</option>
                            </select>
        				</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">�հ�</td>
                    <td align="center"><input type='text' size='11' name='tot_pp_s_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='11' name='tot_pp_v_amt' maxlength='10' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='11' name='tot_pp_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">�Աݿ����� :
                          <input type='text' size='11' name='pp_est_dt' maxlength='10' class="text" value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>&nbsp;</td>
                </tr>
                <tr>
        			<td class='title' colspan="2">��ä��Ȯ��</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>						
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='' readonly>%
        			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='fixnum' value='' readonly>��(������������)</td>
                    <td align='center'>
        			<input type='hidden' name="credit_per"			value="">
        			<input type='hidden' name="credit_amt"			value="">
        			</td>
                </tr>
                <tr>
                    <td rowspan="3" class='title'>��<br>
                      ��</td>
                    <td class='title' colspan="2">�ִ��ܰ�</td>
                    <td align="center"><input type='text' size='11' name='ja_s_amt' readonly maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='11' name='ja_v_amt' readonly maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='11' name='ja_amt' readonly maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">������
        			  <input type='text' size='4' name='max_ja' maxlength='10' readonly class='fixnum' value='' readonly>
        			  % </td>
                    <td align='center'>
					<%	if(AddUtil.parseInt(fee_start_dt) < 20090924){%>		
    			    <span class="b"><a href="javascript:set_janga()" onMouseOver="window.status=''; return true" title="�ִ��ܰ��� ����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
					<%	}else{%>
					<span class="b">������ ��꿡 ���ԵǾ��ֽ��ϴ�. </span>
					<%	}%>
					</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">���Կɼ�</td>
                    <td align="center"><input type='text' size='11' name='opt_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='11' name='opt_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='11' name='opt_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">������
                        <input type='text' size='4' name='opt_per' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				        % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_opt_per' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				            % 
        				    </td>
                    <td align='center'>
        			  <input type='radio' name="opt_chk" value='0' <%if(ext_fee.getOpt_chk().equals("0")){%> checked <%}%>>
                      ����
                      <input type='radio' name="opt_chk" value='1' <%if(ext_fee.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		  ����
                    </td>
                </tr>
                <tr>
                    <td class='title' colspan="2">�����ܰ�</td>
                    <td align="center"><input type='text' size='11' name='ja_r_s_amt' readonly maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='11' name='ja_r_v_amt' readonly maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='11' name='ja_r_amt' readonly maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">������
        			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="defaultnum" value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td rowspan="5" class='title'>��<br>��<br>��</td>
                    <td class='title' colspan="2">�����</td>
                    <td align="center" ><input type='text' size='11'  name='fee_s_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='11'  name='fee_v_amt' maxlength='9' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='11'  name='fee_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">DC��:
                      <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value=''>
                      <input type="hidden" name="dc_ra_amt" value="0">
                    </font>%</span></td>
                    <td align='center'>-</td>
                </tr>
                <!-- �������߰����/�������(���Ǻ���) ���� (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">��<br>��<br>��<br>��<br>��</td>
                    <td class='title'>������</td>
                    <td align="center" ><input type='text' size='11' name='inv_s_amt' readonly maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='11' name='inv_v_amt' readonly maxlength='9' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='11' maxlength='10' readonly name='inv_amt' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">��������<span class="contents1_1">
                      <input type='text' size='11' name='bas_dt' maxlength='10' readonly class="fix" value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </span></td>
                    <td align='center'>&nbsp;
                                  <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        			  <span class="b"><a href="javascript:estimate('account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
        			  <%}%>
					  <!--
        			  &nbsp;&nbsp;
        			  <span class="b"><a href="javascript:estimate('view')" onMouseOver="window.status=''; return true" title="�������� ����"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
					  -->
                    </td>
                </tr>
                <tr>
                    <td class='title'>�������(���Ǻ���)</td>
                    <td align="center" ><input type='text' size='11' name='ins_s_amt'  maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='11' name='ins_v_amt'  maxlength='9' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='11' maxlength='10'  name='ins_amt' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">&nbsp;�������(���ް�) = �Ⱓ�����
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 ��/12</td>
                    <td align='center'></td>
                </tr>
                <tr>
	                <td class='title'>�������߰����</td>
	                <td align="center" >
	                	<input type='text' size='11' name='driver_add_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> �� 
	                </td>
	                <td align="center" >
	                	<input type='text' size='11' name='driver_add_v_amt'  maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center' >
	                	<input type='text' size='11' maxlength='10'  name='driver_add_total_amt' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	            </tr>
                <tr>
                    <td class='title'>������ �հ�</td>
                    <td align="center" >
                    	<input type='text' size='11' name='tinv_s_amt' maxlength='11' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(ext_fee.getInv_s_amt() + ext_fee.getIns_s_amt() + fee_etc.getDriver_add_amt())%>'> �� 
                    </td>
                    <td align="center" >
                       	<input type='text' size='11' name='tinv_v_amt'  maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(ext_fee.getInv_v_amt() + ext_fee.getIns_v_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center' >
                    	<input type='text' size='11' maxlength='10'  name='tinv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(ext_fee.getInv_s_amt() + ext_fee.getInv_v_amt() + ext_fee.getIns_s_amt() + ext_fee.getIns_v_amt() + fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
                
                <tr>
                    <td colspan="3" class='title'>�����븮�ν���</td>
                    <td colspan="2" align="center">-</td>
        			<td align='center'>-</td>
                    <td align="center">
                        <input type='text' size='3' name='bus_agnt_r_per' maxlength='10'  class='defaultnum' value=''>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='bus_agnt_per' maxlength='10' class='defaultnum' value=''>%</font></span></td>
                </tr>		  
                <%
                	//20140101 ������ 20% ����
                	ext_fee.setCls_per("20");
                %>
                <tr>
                    <td class='title' colspan="3">�ߵ�����������</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align="center">�ܿ��Ⱓ �뿩����
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=ext_fee.getCls_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='20'>%
						,�ʿ��������[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value=''>%]
						</font></span></td>
                </tr>
                <%-- <tr>
                    <td colspan="3" class='title'>�������߰����</td>
                    <td colspan="5">&nbsp;
                    	<input type='text' size='10' name='driver_add_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>'>
        				  �� (���ް�)</td>                  
                </tr> --%>                  
                				<input type='hidden' name='agree_dist' 			value='<%=fee_etc.getAgree_dist()%>'>
                				<input type='hidden' name='rtn_run_amt' 		value='<%=fee_etc.getRtn_run_amt()%>'>
                				<input type='hidden' name='rtn_run_amt_yn' 		value='<%=fee_etc.getRtn_run_amt_yn()%>'>
								<input type='hidden' name='over_run_amt' 		value='<%=fee_etc.getOver_run_amt()%>'>
								<input type='hidden' name='agree_dist_yn' 	value='<%=fee_etc.getAgree_dist_yn()%>'>								
                <tr>
                    <td colspan="3" class='title'>�ߵ�����</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align="center">��������Ⱓ : 
        				<input type='text' size='3' name='cls_n_mon' maxlength='10'  class='defaultnum' value=''>
        				  ����</td>
                    <td align='center'>-</td>				  
                </tr>		  		  
                <tr>
                    <td colspan="3" class='title'>������</td>
                    <td colspan="5">&nbsp;
                      <select name='fee_sac_id'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
                </tr>
                <tr>
                    <td colspan="3" class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
                    <td colspan="5">&nbsp;
                      <textarea rows='5' cols='90' name='fee_cdt'></textarea></td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>��༭ Ư����� ���� ����</td>
                    <td colspan="5">&nbsp;
                      <textarea rows='5' cols='90' name='con_etc'></textarea></td>
                </tr>			
            </table>
	    </td>
    </tr>
    <tr></tr><tr></tr>
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding='0' width=100%>
    		    <tr>
        		    <td class=line width="100%">
        			    <table border="0" cellspacing="1" cellpadding='0' width=100%>
            		        <tr>
            				  <td width="5%" class=title>��ȣ</td>
            				  <td width="10%" class=title>�ڵ�</td>				  
            				  <td width="35%" class=title>�̸�</td>
            				  <td width="50%" class=title>��</td>
            				</tr>
            				    <td align="center">E-1</td>
            				    <td align="center">bc_b_e1</td>				  
            				    <td>&nbsp;�������󰡴�����簡ġ����¼��ǱⰣ�ݿ���</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e1' maxlength='10' class=fixnum value='<%//=fee_etc.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;����忹��������</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e2' maxlength='10' class=fixnum value='<%//=fee_etc.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;��Ÿ���</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='num' value='<%//=fee_etc.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='bc_b_u_cont' maxlength='150' class=text value='<%//=fee_etc.getBc_b_u_cont()%>'>
            				  </td>
            				</tr>							
            		        <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;��Ÿ����</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='num' value='<%//=fee_etc.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='bc_b_g_cont' maxlength='150' class=text value='<%//=fee_etc.getBc_b_g_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;��Ÿ ����ȿ���ݿ���</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='num' value='<%//=fee_etc.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='bc_b_ac_cont' maxlength='150' class=text value='<%//=fee_etc.getBc_b_ac_cont()%>'></td>
            				</tr>
            		        <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_etc</td>				  
            				  <td>&nbsp;�������ǻ���</td>
            				  <td align="center"><textarea rows='5' cols='70' name='bc_etc'><%//=fee_etc.getBc_etc()%></textarea></td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
    </tr>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>����Ƚ��</td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='fee_pay_tm' value='' maxlength='1' class='text' >
        				ȸ </td>
                    <td width="10%" class='title'>��������</td>
                    <td width="20%">&nbsp;�ſ�
                      <select name='fee_est_day'>
                        <option value="">����</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                        <option value='<%=i%>'  <%if(ext_fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                        <% } %>
                        <option value='99' <%if(ext_fee.getFee_est_day().equals("99")){%> selected <%}%> > ���� </option>
						<option value='98' <%if(ext_fee.getFee_est_day().equals("98")){%> selected <%}%> > �뿩������ </option>
                      </select></td>
                    <td width="10%" class='title'>���ԱⰣ</td>
                    <td>&nbsp;
                      <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
    			        <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		
                <tr>
                    <td width="13%" class='title'>1ȸ��������</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='fee_fst_dt' value='<%//=AddUtil.ChangeDate2(ext_fee.getFee_fst_dt())%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				</td>
                    <td width="10%" class='title'>1ȸ�����Ծ�</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name='fee_fst_amt' value='<%//=AddUtil.parseDecimal(ext_fee.getFee_fst_amt())%>' maxlength='10' size='10' class='num'>��
                      </td>
                </tr>		  		  		  		  		  	  		    		  		  
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1' >
                  		����
                  		<input type='radio' name="gi_st" value='0' >
                  		���� </td>
                </tr>                
                <tr>
                    <td class=title>��������</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value=''>
        			   <input type='text' name='gi_jijum' value='' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>���Աݾ�</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                    <td class=title >���������</td>
                    <td>&nbsp;
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                </tr>	
            </table>
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;1. ���� ���Ե� ��������</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title >��������</td>
                    <td width="15%">&nbsp;
                        <input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='30' class='whitetext' disabled>
					</td>
                    <td width="10%" class=title >�Ǻ�����</td>
                    <td width="15%">&nbsp;
                        <input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='30' class='whitetext' disabled>
                        &nbsp;&nbsp;&nbsp;
                        <%if(ins_cust_chk.equals("Y")){%><font color=red>����Ⱓ : <%=AddUtil.ChangeDate2(ins.getIns_start_dt())%> ~ <%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%></font><%}%>
					</td>       
                    <td width="10%" class=title >��������������Ư��</td>
                    <td>&nbsp;
                        <select name='i_com_emp_yn' disabled>
                          <option value="">����</option>
                          <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
					</td>					            
                </tr>            
                <tr>
                    <td width="13%" class=title >�����ڿ���</td>
                    <td width="15%">&nbsp;
                        <select name='age_scp' disabled>
                                <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21���̻� 
                                </option>
                                <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24���̻� 
                                </option>
                                <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26���̻� 
                                </option>
                                <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>������ 
                                </option>
								<option value=''>=�Ǻ����ڰ�=</option>				
								        <option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>22���̻�</option>	
								        <option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>28���̻�</option>	
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30���̻�</option>	
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35���̻�</option>
                        <option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>35���̻�~49������</option>	
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43���̻�</option>
						<option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48���̻�</option>
                              </select></td>
                    <td width="10%" class=title >�빰���</td>
                    <td width="15%">&nbsp;
                        <select name='vins_gcp_kd' disabled>
                                <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5���</option>
				<option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3���</option>
				<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2���</option>
				<option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1���</option>
                                <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5õ����</option>
                                <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3õ����</option>
                                <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1õ5�鸸��</option>
                                <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1õ����</option>				
                              </select></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td>&nbsp;
                        <select name='vins_bacdt_kd' disabled>
                                <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3���</option>
                                <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1��5õ����</option>
                                <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1���</option>
                                <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5õ����</option>
                                <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3õ����</option>
                                <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1õ5�鸸��</option>
                                <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>�̰���</option>
                              </select></td>
                </tr>
            </table>
	    </td>		
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;2. ��༭�� ������ ��������</td>
	</tr>		
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                    <td width="13%" class=title >��������</td>
                    <td width="15%">&nbsp;
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                      </select>					  
		    </td>			  
                    <td width="10%" class=title >�Ǻ�����</td>
                    <td width="15%">&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per'>
                          <option value="">����</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(car_st.equals("3") && cont_etc.getInsur_per().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                      </select>					
		    </td>			  		
                    <td width="10%" class=title >��������������Ư��</td>
                    <td>&nbsp;
                        <select name='com_emp_yn'>
                          <option value="">����</option>
                          <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                          <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>
					</td>		    			
              </tr>            
              <tr> 
                <td width="13%" class=title >�����ڿ���</td>
                <td width="15%">&nbsp;
                    <select name='driving_age'>
                      <option value="">����</option>
                      <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26���̻�</option>
                      <%if(car_st.equals("3")){%>
                      <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24���̻�</option>
                      <%}%>
                      <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21���̻�</option>
                      <%if(car_st.equals("3")){%>
                      <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>��������</option>
		      <option value=''>=�Ǻ����ڰ�=</option>				
								        <option value='9'  <%if(base.getDriving_age().equals("9")){%>selected<%}%>>22���̻�</option>	
								        <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>28���̻�</option>	
                        <option value='5'  <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30���̻�</option>				
                        <option value='6'  <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35���̻�</option>				
                        <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>35���̻�~49������</option>	
                        <option value='7'  <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43���̻�</option>						
		                    <option value='8'  <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48���̻�</option>
		      <%}%>
                  </select></td>
                <td width="10%" class=title>�빰���</td>
                <td width="15%">&nbsp;
                    <select name='gcp_kd'>
                      <option value="">����</option>
                      <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                      <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1���</option>
					  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2���</option>
					  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3���</option>
					  <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5���</option>
                  </select></td>
                <td width="10%" class=title >�ڱ��ü���</td>
                <td>&nbsp;
                    <select name='bacdt_kd'>
                      <option value="">����</option>
                      <option value="2" <% if(base.getBacdt_kd().equals("2") || base.getBacdt_kd().equals("1")) out.print("selected"); %>>1���</option>
                      <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>�̰���</option>
                      <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                  </select></td>
              </tr>
            </table>
        </td>
    </tr>		
    <%if(client.getClient_st().equals("2") || client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��</span></td>
	  </tr>    
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">����� ���������ȣ</td>
                    <td>&nbsp;
                        <input type='text' name='lic_no' value='<%//=base.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;(����,���λ����)
			&nbsp;�� �����(<%=client.getClient_nm()%>)�� ���������ȣ�� ���� </td>
                </tr>
                <tr>
                    <td class=title width="13%">�����̿��� ���������ȣ</td>
                    <td>&nbsp;
			<input type='text' name='mgr_lic_no' value='<%//=base.getMgr_lic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;�̸�
			<input type='text' name='mgr_lic_emp' value='<%//=base.getMgr_lic_emp()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;����
			<input type='text' name='mgr_lic_rel' value='<%//=base.getMgr_lic_rel()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;(����,���λ����)
			&nbsp;�� ����ڰ� �������㰡 ���� ��� �����̿����� �������㸦 �Է�   </td>
                </tr>     
                         
            </table>
        </td>
    </tr>  	  
    <%}%>        
<%--     <%if(client.getClient_st().equals("1")){%> --%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='tr_client_share_st'> 
<%--     <tr id=tr_client_share_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  --%>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>������������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' <%if(cont_etc.getClient_share_st().equals("1"))%>checked<%%>>
        				�ִ�
        	      <input type='radio' name="client_share_st" value='2' <%if(!cont_etc.getClient_share_st().equals("1"))%>checked<%%>>
        				����</td>
                </tr>
            </table>  
        </td>
    </tr>  
<%--     <%}%>          --%>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>			
    <%		if(ins_cust_chk.equals("Y")){%>
    <tr>
        <td>&nbsp;</td>
    </tr>    
    <tr>
        <td><font color=red>* ���� �Ǻ������� ������ ������ ������ ���谻���� ���� �̷������ ���� ������ �� �����û�� �� �� �ֽ��ϴ�.</font></td>
    </tr>    
    <%		}else{%>    
    <tr>
        <td>* ���ó���� �̰�׿�û��Ȳ�� ������������ �Ѿ�ϴ�.
		&nbsp;</td>
    </tr>
    <%//			if(fee_size==9){ %>
    <!-- rent_st ������ �� 
    <tr>
		<td align="right"><font color=red>�� �ִ� 8ȸ���� ������� �����Դϴ�.(���ʰ����� 10�� ����) ���ǿ��� ����Ͻʽÿ�.</font></td>
    </tr>
     -->	
    <%//			}else{ %>
    <tr>
		<td align="right"><a id="submitLink" href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
    </tr>	
    <%//			} %>
    <%		}%>
    <%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	if(fm.bas_dt.value == ''){
		fm.bas_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';
		fm.rent_dt.value 			= '<%= AddUtil.getDate() %>';
		fm.rent_start_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';		
	}

<%	if(ext_fee.getOpt_s_amt()>0){//������� ���Կɼ��� �ִ� ���%>		
	fm.fee_opt_amt.value = <%=ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt()%>;
<%	}%>

	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	//�߰������� ���
	getSecondhandCarAmt_h();	
	<%}%>
	
//-->
</script>
</body>
</html>
