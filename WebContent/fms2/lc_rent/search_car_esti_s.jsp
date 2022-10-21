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
<jsp:useBean id="ins" class="acar.con_ins.InsurBean" scope="page"/>
<jsp:useBean id="ai_db2" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");


	String user_id		= ck_acar_id;
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_gubun 	= request.getParameter("car_gubun")==null?"":request.getParameter("car_gubun");
	
	String tae_car_mng_id 	= request.getParameter("tae_car_mng_id")==null?"":request.getParameter("tae_car_mng_id");
	String tae_car_id 	= request.getParameter("tae_car_id")==null?"":request.getParameter("tae_car_id");
	String tae_car_seq 	= request.getParameter("tae_car_seq")==null?"":request.getParameter("tae_car_seq");
	String tae_car_rent_st 	= request.getParameter("tae_car_rent_st")==null?"":request.getParameter("tae_car_rent_st");
	String tae_car_rent_et 	= request.getParameter("tae_car_rent_et")==null?"":request.getParameter("tae_car_rent_et");
	
	String ext_esti_st 	= request.getParameter("ext_esti_st")==null?"":request.getParameter("ext_esti_st");
	
	String fee_start_dt = "";
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	String rent_way = ext_fee.getRent_way();
	
	ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));

	//���ຸ������
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//���ǿ���
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	
	fee_start_dt = rs_db.addDay(ext_fee.getRent_end_dt(), 1);
	
	//���������� �����
	if(ext_esti_st.equals("re")){
		fee_start_dt = ext_fee.getRent_start_dt();
		ext_fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size-1));	
		fee_etcs 	= a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size-1));
		gins 			= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size-1));		
	}
	
	String fee_type = "fee";
	
	if(im_vt_size>0){
		Hashtable im_ht = (Hashtable)im_vt.elementAt(im_vt_size-1);
		if(AddUtil.parseInt(String.valueOf(im_ht.get("RENT_END_DT"))) > AddUtil.parseInt(ext_fee.getRent_end_dt())){
			//fee_start_dt = rs_db.addDay(String.valueOf(im_ht.get("RENT_END_DT")), 1);
			fee_type = "fee_im";
		}
	}
	
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	
	if(car_gubun.equals("taecha")){
		fee_start_dt 	= tae_car_rent_st;
		car 			= a_db.getContCarMaxNew(tae_car_mng_id);
		cm_bean 		= cmb.getCarNmCase(tae_car_id, tae_car_seq);
		base.setCar_mng_id(tae_car_mng_id);
	}
	
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//��������
		String ins_st = ai_db2.getInsSt(base.getCar_mng_id());
		ins = ai_db2.getIns(base.getCar_mng_id(), ins_st);
	}
	
	
	//4. ����----------------------------
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//�߰����ܰ� ����		
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
		if(!String.valueOf(ht2.get("TAX_DC_AMT")).equals(String.valueOf(ht.get("TAX_DC_AMT")))) 						chk++;
		if(chk >0){
			ht2.put("SECONDHAND_DT", fee_start_dt);
			//sh_base table update
			int count = shDb.updateShBase(ht2);
		}
	}
	//��������
	sh_ht = shDb.getShBase(base.getCar_mng_id());
		
	int fee_opt_amt = 0;
	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* �ڵ� ����:�뿩��ǰ�� */
	int good_size = goods.length;
	
	String tr_display_dt = "none";
	String tr_display    = "none";
	
	//���������
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	if(nm_db.getWorkAuthUser("������",user_id)){
		tr_display_dt 	= "";
		tr_display 	= "";
	}
	
	
	
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
	//car_end_dt_max = c_db.addDay(car_end_dt_max, -1);
	
	//20211126 ������ 1���� �� �� (������ ���������ϸ� �� ��� ��) - �豤�������û
	car_end_dt_max = c_db.addMonth(car_end_dt_max, -1);
	
	//�����Ī������ ���� ���������Ϻ��� ����Ÿ����--
	String taecha_st_dt = "";
	taecha_st_dt = ac_db.getClsEtcTaeChaStartDt(rent_mng_id, rent_l_cd, base.getCar_mng_id() );	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type-"text/css>
<!--	
input.whitetextredb		{ text-align:left; font-size : 9pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#ff0000;  font-weight:bold;}
//-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//���� üũ
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');
		}
	}
	
	//��������Ÿ� ����
	function getTotDist_h(){
		var fm = document.sh_form;
		var fm2 = document.form1;		
		fm.a_b.value 		= fm2.con_mon.value;
		fm.rent_dt.value 	= replaceString('-','',fm2.rent_start_dt.value);
		fm.today_dist.value = fm2.sh_km.value;
		fm.fee_opt_amt.value = fm2.fee_opt_amt.value;
		fm.action = "/acar/secondhand/getTotDistSet.jsp";
		fm.target = "i_no2";
		fm.submit();
	}

	//�߰������� ����ϱ�-���
	function getSecondhandCarAmt_h(){
		var fm = document.sh_form;
		var fm2 = document.form1;	
		
		fm2.sh_amt.value = '0'; //�ʱ�ȭ
		
		fm.a_b.value 		= fm2.con_mon.value;
		fm.rent_dt.value 	= replaceString('-','',fm2.rent_start_dt.value);
		fm.today_dist.value = fm2.sh_km.value;
		fm.fee_opt_amt.value = fm2.fee_opt_amt.value;
		
		if(fm.a_b.value == '' || fm.a_b.value == '0')	return;
		if(fm.rent_dt.value == '')			return;
		if(toInt(fm.a_b.value) > 24){ alert('24���� �̸��� ��������˴ϴ�.'); 	return; }
		if(toInt(fm.a_b.value) == 0){ alert('0���� �̻� ��������˴ϴ�.'); 	return; }
		
		if(fm2.car_gubun.value=='taecha') fm.rent_st.value 	= '1';//�縮��
		
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "i_no2";
		fm.submit();
	}
		
	//�߰������� ����ϱ�-���
	function getSecondhandCarAmt(){
		var fm = document.sh_form;
		var fm2 = document.form1;		
		
		fm.a_b.value 		= fm2.con_mon.value;
		fm.rent_dt.value 	= replaceString('-','',fm2.rent_start_dt.value);
		fm.today_dist.value = fm2.sh_km.value;
		fm.fee_opt_amt.value = fm2.fee_opt_amt.value;
		fm.mode.value 		= 'view';
		
		if(fm.a_b.value == '' || fm.a_b.value == '0')	return;
		if(fm.rent_dt.value == '')						return;
		if(toInt(fm.a_b.value) > 24){ alert('24���� �̸��� ��������˴ϴ�.'); return; }
		
		if(fm2.car_gubun.value=='taecha') fm.rent_st.value 	= '1';//�縮��
				
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "_blank";
		fm.submit();
	}		
	
	//����Ÿ�����ġ		
	function getSecondhandCarDist(rent_dt, serv_dt, tot_dist){
		var fm = document.form1;
		rent_dt = fm.sh_day_bas_dt.value;
		serv_dt = fm.sh_km_bas_dt.value;
		tot_dist = fm.sh_tot_km.value;
		var height = 300;
		window.open("search_todaydist.jsp?car_mng_id=<%=base.getCar_mng_id()%>&rent_dt="+rent_dt+"&serv_dt="+serv_dt+"&tot_dist="+tot_dist, "VIEW_DIST", "left=0, top=0, width=650, height="+height+", scrollbars=yes");
	}
			
	//�����̷º���
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=base.getCar_mng_id()%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
					
	//�뿩�Ⱓ ����
	function set_cont_date(obj){
		var fm = document.form1;
		var rent_way = fm.rent_way.value;
		
		if(toInt(fm.con_mon.value) > 24){
//			alert('24���� �̸��� ��������˴ϴ�.');
//			fm.con_mon.value = '24';
			return;
		}
		
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;
		
		if(obj == fm.rent_start_dt){
//			fm.rent_start_dt.value = ChangeDate(fm.rent_start_dt.value);
		}
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
		var car_price 	= toInt(parseDigit(fm.o_1.value));
		
		
		//������---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
			}
		}else if(obj==fm.grt_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.grt_s_amt.value)) / car_price * 100, 1);
				
			}
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
			}
		}else if(obj==fm.pp_v_amt){ 	//������ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
			}		
		}else if(obj==fm.pp_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));			
					
			if(car_price > 0){
				fm.pere_r_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.pp_amt.value)) / car_price * 100, 1);
			}			
		//���ô뿩��---------------------------------------------------------------------------------			
		}else if(obj==fm.ifee_s_amt){ 	//���ô뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ifee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
		}else if(obj==fm.ifee_v_amt){ 	//���ô뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
		}else if(obj==fm.ifee_amt){ 	//���ô뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));			
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));	
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);			
		//�����ܰ���---------------------------------------------------------------------------------			
		}else if(obj==fm.app_ja){ 		//�����ܰ���
			fm.ja_r_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.app_ja.value) /100,-3) );
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
		}else if(obj==fm.ja_r_s_amt){ 	//�����ܰ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
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
				fm.opt_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
			}
			if(toInt(parseDigit(fm.opt_amt.value))==0){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			<%if(!acar_de.equals("1000")){%>
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//�ִ�
			}else{
				fm.opt_chk[0].checked = true;//����
			}
			<%}%>
		}else if(obj==fm.opt_v_amt){ 	//���Կɼ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(toInt(parseDigit(fm.opt_amt.value))==0){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			<%if(!acar_de.equals("1000")){%>
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//�ִ�
			}else{
				fm.opt_chk[0].checked = true;//����
			}			
			<%}%>
		}else if(obj==fm.opt_amt){ 		//���Կɼ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));	
			if(car_price > 0){				
				fm.opt_per.value 	= parseFloatCipher3(toInt(parseDigit(fm.opt_amt.value)) / car_price * 100, 1);
			}
			if(toInt(parseDigit(fm.opt_amt.value))==0){
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
			}else{
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;
			}
			<%if(!acar_de.equals("1000")){%>
			if(toInt(parseDigit(fm.opt_amt.value)) > 0 ){
				fm.opt_chk[1].checked = true;//�ִ�
			}else{
				fm.opt_chk[0].checked = true;//����
			}			
			<%}%>
		//�����뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//�����뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
		}else if(obj==fm.inv_v_amt){ 	//�����뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value		= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
		}else if(obj==fm.inv_amt){ 		//�����뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
		}		
	}	
	
	//���Կɼ�
	function display_opt(){
		var fm = document.form1;
		fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.o_1.value)) * toFloat(fm.opt_per.value) / 100 );
		fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
		fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));	
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
		
	//�����뿩�� ��� (����)
	function estimate(st){
		var fm = document.form1;
		
		//�Ϲݽ����� ����Ÿ� ���� ����
		<%if(rent_way.equals("1")){%>
		var dist_chk_var = 0;
		<%	if(base.getCar_gu().equals("1")){ //����%>
			dist_chk_var = getCutRoundNumber(toInt(parseDigit(fm.sh_km.value)) / (toInt(parseDigit(fm.o_rent_days.value)) /365),0);
		<%	}else{ //�縮��%>
			dist_chk_var = getCutRoundNumber((toInt(parseDigit(fm.sh_km.value)) - toInt(parseDigit(fm.o_over_bas_km.value))) / (toInt(parseDigit(fm.o_rent_days.value)) /365),0);
		<%	}%>
		if(dist_chk_var > 35000){
			if(confirm('�Ϲݽ� ������ ����Ÿ��� ����(�Ⱓ 35,000km�̻�) �ϴ�,\n\n���������� ���������� ���� �� ���� ��� ����ٶ��ϴ�.\n\n���������� �þҽ��ϱ�?')){
				
			}else{
				return;
			}
		}
		<%}%>			
		
		//20220613 ���� �Ϲݽ��϶��� 1��̸� �⺻�İ����� �ȵȴ�
		if(fm.f_rent_way.value == '1' && (toInt(fm.t_con_mon.value)+toInt(fm.con_mon.value)) <= 12 && (fm.a_a.value == '22' || fm.a_a.value == '12')){
			alert('���� �Ϲݽİ���� �⺻�� 1��̸����� ������ �� �����ϴ�.'); 	return;
		}
		
		//20220613 ���� �Ϲݽ��϶��� 1���̻� �⺻�İ����̸� �����϶�� ����
		if(fm.f_rent_way.value == '1' && (toInt(fm.t_con_mon.value)+toInt(fm.con_mon.value)) > 12 && (fm.a_a.value == '22' || fm.a_a.value == '12')){
			if(confirm('�Ϲݽ� -> �⺻�� ������� �̹Ƿ� ��������� �����ϼ���\n\n���������Ͻðڽ��ϱ�?')){
				
			}else{
				return;
			}			
		}
		
	
		if(fm.rent_dt.value == '')	{ alert('���������ڸ� �Է��Ͻʽÿ�.'); 	return; }
		if(fm.rent_start_dt.value == '')	{ alert('����뿩�������� �Է��Ͻʽÿ�.'); 	return; }
		if(fm.car_mng_id.value == '')	{ alert('������ ���õ��� �ʾҽ��ϴ�. Ȯ���Ͻʽÿ�.'); 	return; }	
		if(toInt(fm.con_mon.value) > 24){ alert('24���� �̸��� ��������˴ϴ�.'); return; }	
		if(fm.sh_amt.value == '0' || fm.sh_amt.value == ''){ alert('�߰����� ����� ���� �ȵǾ� �ֽ��ϴ�.'); getSecondhandCarAmt_h(); return; }
		
		//������������ ��� ���ɸ����� üũ�ؼ� ���常������ ����� �� ��� ����� �ȵǵ��� �Ѵ�.
		<%if(!ck_acar_id.equals("000029") && !ck_acar_id.equals("000026") && cr_bean.getCar_use().equals("1")){%>
		if(toInt(replaceString('-','','<%=car_end_dt_max%>')) < toInt(replaceString('-','',fm.rent_end_dt.value)) ){
			alert('�뿩�Ⱓ �������� ���ɸ����Ϻ��� Ů�ϴ�. Ȯ���Ͻʽÿ�.'); 						fm.rent_end_dt.focus(); 	return;
		}
		<%}%>		
		
		//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
		if('<%=base.getCar_st()%><%=ext_fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
				return;					
			}
		}
		
			
		fm.grt_amt.value 	= fm.grt_s_amt.value;
		
		fm.esti_stat.value 	= st;
		
		fm.fee_rent_dt.value = replaceString("-","",fm.rent_start_dt.value);
		
		set_fee_amt(fm.grt_s_amt);
		
		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;	
		

		fm.action='search_car_esti_s_a.jsp';		
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}
		
		//20161101 ���Կɼ� ���� ���� ������ ������ ���Կɼ� �ο� ���� ����
		<%if(!acar_de.equals("1000")){%>
		if(toInt(parseDigit(fm.fee_opt_amt.value))==0 && fm.opt_chk[1].checked == true ){
			if('<%=base.getCar_gu()%>'=='0' && '<%=ej_bean.getJg_b()%>' ==2){
				alert('��������� ���Կɼ��� �����ϴ�.\n\nLPG���� �縮�� ����� ���Կɼ��� �ο��� �� �����ϴ�.');
				return;
			}else{
				if(confirm('��������� ���Կɼ��� �����ϴ�.\n\n�������� ���Կɼ� �ο��� �ݵ�� ��������Կ��� �������θ� �����ñ� �ٶ��ϴ�.\n\n���������� �þҽ��ϱ�?')){
					
				}else{
					return;
				}
			}
		}
		<%}%>
		
		if(confirm('���� �������� ����� ���� ������ �����մϴ�.\n\n�����Ͻðڽ��ϱ�?')){	
			fm.submit();
		}
	}
	
	//�����̷�
	function view_car_esti_h(){
		var fm = document.form1;
		var SUBWIN="view_car_esti_list.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+fm.fee_rent_st.value;
		window.open(SUBWIN, "CarEstiHistory", "left=50, top=50, width=1200, height=800, scrollbars=yes, status=yes");
	}
	
	//�ʰ�����Ÿ� �󼼺���	
	function view_over_agree(){
		var fm = document.form1;
		var SUBWIN="view_over_agree.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=ext_fee.getRent_st()%>&tot_dist=<%=sh_ht.get("TODAY_DIST")%>";
		window.open(SUBWIN, "ViewOverAgree", "left=50, top=50, width=850, height=700, scrollbars=yes, status=yes");
	}

	//�ŷ�ó ��ü�ݾ�
	function view_dlyamt(client_id)
	{
		window.open('/acar/account/stat_settle_sc_in_view_sub_list_client.jsp?client_id='+client_id, "CLIENT_DLVAMT", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
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
  <input type='hidden' name="from_page"			value="/fms2/lc_rent/search_car_esti_s.jsp">          
</form>
<form action='' name="form1" method='post'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="car_gubun" 		value="<%=car_gubun%>">  
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">
  <input type='hidden' name="car_ext" 			value="<%=cr_bean.getCar_ext()%>">
  <input type='hidden' name="udt_st" 			value="<%=pur.getUdt_st()%>">  
  <input type='hidden' name="rent_way" 			value="<%=ext_fee.getRent_way()%>">
  <input type='hidden' name="fee_pay_tm" 		value="<%=ext_fee.getFee_pay_tm()%>">
  <input type='hidden' name="fee_pay_start_dt" 	value="">
  <input type='hidden' name="fee_pay_end_dt" 	value="">
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
  <input type='hidden' name='gi_st' 			value='<%=gins.getGi_st()%>'>  
  <input type='hidden' name='gi_amt' 			value='<%=gins.getGi_amt()%>'>    
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
  <input type="hidden" name="tax_dc_s_amt"   		value="<%=car.getTax_dc_s_amt()%>">  
  <input type="hidden" name="tax_dc_v_amt"   		value="<%=car.getTax_dc_v_amt()%>">    
  <input type="hidden" name="tax_dc_amt"   		value="<%=car.getTax_dc_s_amt()+car.getTax_dc_v_amt()%>">        
  <input type="hidden" name="spe_tax"   		value="<%=car.getSpe_tax()%>">  
  <input type="hidden" name="edu_tax"   		value="<%=car.getEdu_tax()%>">
  <input type="hidden" name="tot_tax"   		value="<%=car.getSpe_tax()+car.getEdu_tax()%>">
  <input type='hidden' name="ro_13"				value="">  
  <input type='hidden' name="o_13"				value="">  
  <input type='hidden' name="o_13_amt"			value="">      
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
    
  <input type='hidden' name="est_from"			value="lc_renew">      
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">   
  <input type='hidden' name="ins_chk4"			value="">                         
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">   
  <%if(ext_esti_st.equals("re")){%>
  <input type='hidden' name="fee_rent_st"		value="<%=fee_size%>">
  <%}else{%>
  <input type='hidden' name="fee_rent_st"		value="<%=fee_size+1%>">
  <%}%>
  <input type='hidden' name="fee_rent_dt"		value="">              
  <input type='hidden' name="bc_b_e1"			value="">                
  <input type='hidden' name="bc_b_e2"			value="">     
  <input type='hidden' name="fee_type"			value="<%=fee_type%>">  
  <input type='hidden' name="com_emp_yn"	value="<%=cont_etc.getCom_emp_yn()%>">	   
             
        
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5><%if(car_gubun.equals("taecha")){%>�����������<%}else{%>����<%}%> ����</span></span> : <%if(car_gubun.equals("taecha")){%>�����������<%}else{%>����<%}%> ����</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>�������</td>
                    <td width=20%>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title width=10%>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td>&nbsp;<%=client.getFirm_nm()%>
					(<b><font color='#990000'>
                      <% 	if(base.getSpr_kd().equals("")){
                      			if(base.getCar_gu().equals("0")) base.setSpr_kd("1"); //�縮��-�췮���
                      			if(base.getCar_gu().equals("1")) base.setSpr_kd("2"); //����-�ʿ췮���
                      		}
                      %>
                      <% if(base.getSpr_kd().equals("3")) out.print("�ż�����"); 	%>
                      <% if(base.getSpr_kd().equals("0")) out.print("�Ϲݰ�"); 	%>
                      <% if(base.getSpr_kd().equals("1")) out.print("�췮���"); 	%>
                      <% if(base.getSpr_kd().equals("2")) out.print("�ʿ췮���");  %>
					</font></b>)
					</td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<b><font color='#990000'><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></font></b></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<b><font color='#990000'><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></font></b></td>
                </tr>
                <tr>
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
                    <td class=title>���ɸ�����</td>
                    <td>&nbsp;<b><font color='#990000'><%=AddUtil.ChangeDate2(cr_bean.getCar_end_dt())%></font></b>
                    <td class=title>�����ڵ�</td>
                    <td>&nbsp;<b><font color='#990000'><%=cm_bean.getJg_code()%></font></b>
        			</td>
                </tr>				
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title >�Ǻ�����</td>
                    <td width="20%">&nbsp;<b><font color='#990000'><%=ins.getCon_f_nm()%></font></b></td>
                    <td width="10%" class=title >�����ڿ���</td>
                    <td width="12%">&nbsp;
                        <%if(ins.getAge_scp().equals("1")){%>21���̻�<%}%> 
                        <%if(ins.getAge_scp().equals("4")){%>24���̻�<%}%> 
                        <%if(ins.getAge_scp().equals("2")){%>26���̻�<%}%> 
                        <%if(ins.getAge_scp().equals("3")){%>������<%}%> 
                        <%if(ins.getAge_scp().equals("5")){%>30���̻�<%}%>
                        <%if(ins.getAge_scp().equals("6")){%>35���̻�<%}%>
                        <%if(ins.getAge_scp().equals("7")){%>43���̻�<%}%>
                        <%if(ins.getAge_scp().equals("8")){%>48���̻�<%}%>
                        <%if(ins.getAge_scp().equals("9")){%>22���̻�<%}%>
                        <%if(ins.getAge_scp().equals("10")){%>28���̻�<%}%>
                        <%if(ins.getAge_scp().equals("11")){%>35���̻�~49������<%}%>
                    </td>
                    <td width="10%" class=title >�빰���</td>
                    <td width="12%">&nbsp;
                        <%if(ins.getVins_gcp_kd().equals("6")){%>5���     <%}%>
                        <%if(ins.getVins_gcp_kd().equals("7")){%>2���     <%}%>
                        <%if(ins.getVins_gcp_kd().equals("3")){%>1���     <%}%>
                        <%if(ins.getVins_gcp_kd().equals("4")){%>5õ����   <%}%>
                        <%if(ins.getVins_gcp_kd().equals("1")){%>3õ����   <%}%>
                        <%if(ins.getVins_gcp_kd().equals("2")){%>1õ5�鸸��<%}%>
                        <%if(ins.getVins_gcp_kd().equals("5")){%>1õ����   <%}%>
					</td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td>&nbsp;
                        <%if(ins.getVins_bacdt_kd().equals("1")){%>3���      <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("2")){%>1��5õ���� <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("6")){%>1���      <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("5")){%>5õ����    <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("3")){%>3õ����    <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("4")){%>1õ5�鸸�� <%}%>
                        <%if(ins.getVins_bacdt_kd().equals("9")){%>�̰��� <%}%>
					</td>
                </tr>
				<tr>
				    <td class=title>�ڱ���������</td>
					<td colspan='5'>&nbsp;
					<%if(ins.getVins_cacdt_cm_amt()>0){%>
					<b><font color='#990000'>
					���� ( ���� <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>����, �ڱ�δ�� <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>����)
                    </font></b>
					<%}else{%>
                    -
                    <%}%></td>
					<td class=title>������å��</td>
					<td>&nbsp;
					  <%=AddUtil.parseDecimal(base.getCar_ja())%>��</td>
				</tr>
            </table>
	    </td>		
	</tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <% 	String f_rent_way = "";
    	int t_con_mon = 0;
    %>
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
    				
    				if(i==0){
    					f_rent_way = fees.getRent_way();
    				}
    				
    				t_con_mon += AddUtil.parseInt(fees.getCon_mon());
    				
    				//���������� �����
					if(ext_esti_st.equals("re")){
						if((i+2)==fee_size)			fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt(); //���������� ���
					}else{				
	    				if(fee_size >0 && (i+1)==fee_size)	fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt(); //���ο�� ����
    				}
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>����</td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right">
					<%if(fee_size >1 && (i+1)==(fee_size)){%>
					<b><font color='#990000'><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��</font></b>
					<%}else{%>
					<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��
					<%}%>
					</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%}}%>
            </table>
		<%}%>
	    </td>
	</tr>
	<input type='hidden' name="f_rent_way"	value="<%=f_rent_way%>">
	<input type='hidden' name="t_con_mon"	value="<%=t_con_mon%>">
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳�ä��</span>
	    	- <input type="button" class="button" id="bad_amt" value='ä�Ǻ���' onclick="javascript:view_dlyamt('<%=base.getClient_id()%>');">
	    	</td>
	</tr>		
	<input type='hidden' name="con_f_nm"		value="<%=ins.getCon_f_nm()%>">
	<input type='hidden' name="age_scp"			value="<%=ins.getAge_scp()%>">	
	<input type='hidden' name="vins_gcp_kd"		value="<%=ins.getVins_gcp_kd()%>">	
	<input type='hidden' name="vins_bacdt_kd"	value="<%=ins.getVins_bacdt_kd()%>">	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� <%=fee_opt_amt%></span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr id=tr_1 style="display:''">
                    <td width='13%' class='title'> �������� </td>
                    <td width="15%">&nbsp;
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT")))%>��</td>
                    <td class='title' width="12%">���û��</td>
                    <td width="13%">&nbsp;
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("OPT_AMT")))%>��</td>
                    <td class='title' width='10%'>����</td>
                    <td width="12%">&nbsp;
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("COL_AMT")))%>��</td>
                    <td class='title' width='10%'>���Ҽ�����</td>
                    <td width="15%">&nbsp;	
					  <%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("TAX_DC_AMT")))%>��</td>
                </tr>	
                <tr id=tr_1 style="display:''">
                    <td class='title' width='10%'>�����Һ��ڰ�</td>
                    <td colspan='7'>&nbsp;	
					  <input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT"))-AddUtil.parseInt((String)sh_ht.get("TAX_DC_AMT")))%>' size='10' class='whitenum' readonly>
        				��&nbsp;				  
					</td>					  
                </tr>	                
                <tr>
                    <td width='13%' class='title'> �߰����� </td>
                    <td colspan='7'>&nbsp;
					  <input type='text' name='sh_amt' value=''size='10' class='whitenum' readonly>
					  ��
					  &nbsp;&nbsp;&nbsp;				  	
					  (�ܰ���: <input type='text' name='sh_ja' value=''size='4' class='whitenum' readonly>
						%,  ��������Ÿ� ���� )
					  <%if(nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("�����������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%>
						&nbsp;&nbsp;<span class="b"><a href="javascript:getSecondhandCarAmt()" onMouseOver="window.status=''; return true" title="�߰����� ����ϱ�"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
					  <%}%>							
					</td>                    				  
                </tr>													
                <tr>
                    <td width='13%' class='title'> �������� </td>
                    <td colspan='7'>&nbsp;
					  <input type='text' name='o_1' value=''size='10' class='whitenum'>
					  ��
					  &nbsp;&nbsp;&nbsp;
					  (���� ���Կɼ��� ������ ���� ���Կɼǰ�, ������ ���� �߰��������� ����˴ϴ�.)					  
					</td>                    				  
                </tr>							
                <tr id=tr_1 style='display:<%=tr_display%>'>
                    <td class='title' width='10%'>����</td>
                    <td colspan='5'>&nbsp;                      
						<input type='text' name='sh_year' value='<%=carOld.get("YEAR")%>' size='1' class='white' readonly>
                    ��
                    <input type='text' name='sh_month' value='<%=carOld.get("MONTH")%>' size='2' class='white' readonly>
                    ����
                    <input type='text' name='sh_day' value='<%=carOld.get("DAY")%>' size='2' class='white' readonly>
                    �� &nbsp;  
					(
					��������� <input type='text' name='sh_init_reg_dt' value='<%=cr_bean.getInit_reg_dt()%>' size='11' class='white' readonly> ~
                    �뿩������ <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(fee_start_dt)%>' size='11' class='white' readonly>
                  )
					</td>
					<td class='title' width='10%'>�������Կɼ�</td>
					<td >&nbsp;
					  <input type='text' name='fee_opt_amt' value=''size='10' class='whitenum'>
					  ��
					</td>
                </tr>
                
                <!--�ʰ�����δ�� ����-->
                <tr>
                    <td class='title' width='13%'>������������Ÿ�</td>
                    <td>&nbsp;
						<input type='text' name='o_agree_dist' size='6' value='<%=AddUtil.parseDecimal(f_fee_etc.getAgree_dist())%>' class='whitenum' readonly>
					km����/1��
					</td>
                    <td class='title'>��������Ÿ�(�ѵ�)</td>
                    <td colspan='3'>&nbsp;
						<input type='text' name='o_y_agree_dist' size='6' value='' class='whitenum' readonly>
					km (�����������Ÿ�*�뿩�ϼ�<input type='text' name='o_rent_days' size='2' value='' class='whitenum' readonly>/365)
					</td>					
                    <td class='title' width='13%'>��������Ÿ�(������)</td>
                    <td>&nbsp;
						<input type='text' name='o_over_bas_km' size='6' value='<%=AddUtil.parseDecimal(f_fee_etc.getOver_bas_km())%>' class='whitenum' readonly>
					km
					</td>
                </tr>
                <tr>
                    <td class='title' width='13%'>�ʰ�����Ÿ� �������</td>
                    <td colspan='7'>&nbsp;
						<input type='text' name='o_b_agree_dist' size='6' value='' class='whitenum' readonly>
					km (��������Ÿ�(�ѵ�)+��������Ÿ�(������)+���񽺸��ϸ���(1000km))
					</td>
                </tr>                
                
                <tr>
                    <td class='title' width='13%'>��������Ÿ�</td>
                    <td colspan='7'>&nbsp;                      
						<input type='text' name='o_sh_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>' class='whitenum' readonly>
					km
					&nbsp;&nbsp; 
					(�ǰ����� �Ʒ��� "��������Ÿ�" �� �������� ���˴ϴ�.)
					</td>
                </tr>				
                
                <tr>
                    <td class='title' width='13%'>�ʰ�����Ÿ�</td>
                    <td colspan='7'>&nbsp;
						<input type='text' name='o_over_agree_dist' size='6' value='' class='whitenum' readonly>
					km &nbsp;&nbsp; 
					<input type='text' name='o_over_agree_dist_nm' size='6' value='' class='whitetextredb' readonly>
					&nbsp;&nbsp; 
					<input type="button" class="button" id="over_agree_pop" value='�󼼺���' onclick="javascript:view_over_agree();">
					&nbsp;&nbsp; 
					(��������Ÿ�-�ʰ�����Ÿ� �������(����Ÿ�)
					</td>
                </tr>   
                                
                <tr id=tr_1 style='display:<%=tr_display%>'>
                    <td width="13%" class='title'> �ֱ�����Ÿ� </td>
                    <td  colspan='7'>&nbsp;
        			  <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>' class='whitenum' >
					km
					(
					�������� <input type='text' name='sh_km_bas_dt' size='10' value='<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value);'>
					)
					<span class="b"><a href="javascript:getSecondhandCarDist('','','')" onMouseOver="window.status=''; return true" title="�߰����� ����ϱ�"><img src=/acar/images/center/button_in_jhgl.gif align=absmiddle border=0></a></span>
        			  &nbsp;&nbsp;
					  <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="���񳻿�����"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>
					</td>
                </tr>				
            </table>
	    </td>
    </tr>
    <tr>
        <td>* �� �ʰ�����Ÿ��� ��������Ÿ��� �������� ����� �����Դϴ�.</td>
    </tr>			    
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���û���</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                    <td width="13%" class=title >�뿩��ǰ</td>
                    <td width="15%">&nbsp;
					    			<% String s_a_a= "";
												if(base.getCar_st().equals("1")) 			s_a_a = "2";
												else                             			s_a_a = "1";
												if(ext_fee.getRent_way().equals("1")) s_a_a = s_a_a+"1";
												else                              		s_a_a = s_a_a+"2";
										%>
							        
                      <select <%if(!acar_de.equals("1000")){%>name="a_a"<%}else{%>name="s_a_a" disabled<%}%> class="default">
                        <%for(int i = 0 ; i < good_size ; i++){
        					         CodeBean good = goods[i];
        					         //�⺻�İ��� �⺻�ĸ�
        					         if(ext_fee.getRent_way().equals("3") && (good.getNm_cd().equals("21")||good.getNm_cd().equals("11"))) continue;
        					         //������������ ��ⷻƮ��
        					         if(base.getCar_st().equals("1") && (good.getNm_cd().equals("11")||good.getNm_cd().equals("12"))) continue;
        					         //�ڰ��������� ������ุ
        					         if(base.getCar_st().equals("3") && (good.getNm_cd().equals("21")||good.getNm_cd().equals("22"))) continue;
        					      %>
                        <option value='<%= good.getNm_cd()%>' <%if(s_a_a.equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        <%}%>
                      </select>
                    
							        <%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="a_a" value="<%=s_a_a%>">
							        <%}%>
                    
                    </td>
                <td width="10%" class=title >�ſ���</td>
                <td width="12%">&nbsp;
				      <select name="spr_yn" class="default">
                  			<option value='3' <%if(base.getSpr_kd().equals("3"))%>selected<%%>>�ż�����</option>
                  			<option value='0' <%if(base.getSpr_kd().equals("0"))%>selected<%%>>�Ϲݰ�</option>
                  			<option value='1' <%if(base.getSpr_kd().equals("1")||base.getSpr_kd().equals(""))%>selected<%%>>�췮���</option>
                  			<option value='2' <%if(base.getSpr_kd().equals("2"))%>selected<%%>>�ʿ췮���</option>
                      </select>
                      <%//20211214 ������Ʈ ��������� �ſ��� ���ð����ϰ�%>
                      <!-- 
                      <select <%if(!acar_de.equals("1000")){%>name="spr_yn"<%}else{%>name="s_spr_yn" disabled<%}%> class="default">
                  			<option value='3' <%if(base.getSpr_kd().equals("3"))%>selected<%%>>�ż�����</option>
                  			<option value='0' <%if(base.getSpr_kd().equals("0"))%>selected<%%>>�Ϲݰ�</option>
                  			<option value='1' <%if(base.getSpr_kd().equals("1")||base.getSpr_kd().equals(""))%>selected<%%>>�췮���</option>
                  			<option value='2' <%if(base.getSpr_kd().equals("2"))%>selected<%%>>�ʿ췮���</option>
                      </select>
                      <%if(acar_de.equals("1000")){%>
						<input type='hidden' name="spr_yn" value="<%=base.getSpr_kd()%>">
					  <%}%>
					  -->							        
                    </td>
                <td width="10%" class=title>��������</td>
                <td width="15%">&nbsp;<%if(cont_etc.getInsurant().equals("")) cont_etc.setInsurant("1");%>
                        <select <%if(!acar_de.equals("1000")){%>name='insurant'<%}else{%>name="s_insurant" disabled<%}%> class="default">                          
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                      </select>
                      <%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="insurant" value="<%=cont_etc.getInsurant()%>">
							        <%}%>
                    </td>
                <td width="10%" class=title>�Ǻ�����</td>
                <td width="15%">&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select <%if(!acar_de.equals("1000")){%>name='insur_per'<%}else{%>name="s_insur_per" disabled<%}%> class="default">
                          <option value="">����</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(car_st.equals("3") && cont_etc.getInsur_per().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                      </select>
                      <%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="insur_per" value="<%=cont_etc.getInsur_per()%>">
							        <%}%>
                    </td>                    
              </tr>
              <tr> 
                <td width="13%" class=title >������å��</td>
                <td width="15%">&nbsp;
                	<%if(acar_de.equals("1000")){%>
							        <%=AddUtil.parseDecimal(base.getCar_ja())%>��
							        <input type='hidden' name="car_ja" value="<%=base.getCar_ja()%>">
							    <%}else{%>
				          <input type="text" name="car_ja" class='defaultnum' size="10" value="<%=AddUtil.parseDecimal(base.getCar_ja())%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                          ��
                  <%}%>
                    </td>
                <td width="10%" class=title >�����ڿ���</td>
                <td width="12%">&nbsp;
                    <select <%if(!acar_de.equals("1000")){%>name='driving_age'<%}else{%>name="s_driving_age" disabled<%}%> class="default">
                      <option value="">����</option>
                      <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26���̻�</option>
                      <%if(car_st.equals("3")){%>
                      <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24���̻�</option>
                      <%}%>
                      <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21���̻�</option>
                      <%if(car_st.equals("3")){%>
                      <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>��������</option>
                      <option value=''>=�Ǻ����ڰ�=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30���̻�</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35���̻�</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43���̻�</option>						
                      <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48���̻�</option>
                      <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>22���̻�</option>					  
                      <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>28���̻�</option>					  
                      <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>35���̻�~49������</option>					  
		                  <%}%>
                  </select>
                  		<%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="driving_age" value="<%=base.getDriving_age()%>">
							        <%}%>
                  </td>
                <td width="10%" class=title>�빰���</td>
                <td width="15%">&nbsp;
                    <select <%if(!acar_de.equals("1000")){%>name='gcp_kd'<%}else{%>name="s_gcp_kd" disabled<%}%> class="default">
                      <option value="">����</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1���</option>
                          <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2���</option>
                          <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3���</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5���</option>						  
                    </select>
                  		<%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="gcp_kd" value="<%=base.getGcp_kd()%>">
							        <%}%>                  
                  </td>
                <td width="10%" class=title >�ڱ��ü���</td>
                <td width="15%">&nbsp;
                    <select <%if(!acar_de.equals("1000")){%>name='bacdt_kd'<%}else{%>name="s_bacdt_kd" disabled<%}%> class="default">
                      <option value="">����</option>
                      <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1���</option>
                      <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>�̰���</option>
                      <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                  </select>
                  		<%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="bacdt_kd" value="<%=base.getBacdt_kd()%>">
							        <%}%>
                  </td>
              </tr>		
              <tr> 
                    <td width="13%" class=title>�̿�Ⱓ</td>
                    <td width="15%">&nbsp;
                        <input type='text' name="con_mon" value='' size="4" maxlength="2" class='defaultnum' onChange='javascript:set_cont_date(this); getSecondhandCarAmt_h();'>
            			 ����</td>			  
                <td width="10%" class=title >������</td>
                <td width="12%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        <%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>��
							        <input type='hidden' name="grt_s_amt" value="<%=ext_fee.getGrt_amt_s()%>">
							    <%}else{%>                	
                    <input type='text' size='11' maxlength='10' name='grt_s_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��
        				  <%}%>
        				  </td>
                <td width="10%" class=title>������</td>
                <td width="15%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        -
							        <input type='hidden' name="pp_amt" value="0">
							    <%}else{%>                      	
                    <input type='text' size='11' name='pp_amt' maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��
        				  <%}%>
        				  </td>
                <td width="10%" class=title >���ô뿩��</td>
                <td width="15%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        -
							        <input type='hidden' name="pere_r_mth" value="0">
							    <%}else{%>                   	
                    <input type='text' size='2' name='pere_r_mth' class='defaultnum' value=''>
        				  ����ġ �뿩��
        				  <%}%>
        				  </td>
              </tr>		
              <tr> 
                    <td width="13%" class=title >��������Ÿ�</td>
                    <td width="15%">&nbsp;
					  <input type='text' name='sh_km' size='10' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>' class='defaultnum' onBlur='javascript:getSecondhandCarAmt_h()' >
					km</td>			                
                <td width="10%" class=title >�����ܰ�</td>
                <td width="12%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        -
							        <input type='hidden' name="opt_per" value="0">
							    <%}else{%>                           	
				              <input type='text' size='6' name='opt_per' class='defaultnum' value='' onBlur="javascript:display_opt()">
        				  %
        				  <%}%>
                    </td>
                <td width="10%" class=title>���Կɼ�</td>
                <td width="15%">&nbsp;
                	
                  <%if(acar_de.equals("1000")){%>
										<%	if(fee_opt_amt>0){//������� ���Կɼ��� �ִ� ���%>		
											�ο�
							        <input type='hidden' name="opt_chk" value="1">
										<%	}else{%>
											�̺ο�
							        <input type='hidden' name="opt_chk" value="0">
										<%	}%>
							    <%}else{%>                           	
				              <input type='radio' name="opt_chk" value='0'>
                      �̺ο�
                      <input type='radio' name="opt_chk" value='1'>
        	 		        �ο�
        				  <%}%>
                </td>
                <td width="10%" class=title >�뿩��D/C</td>
                <td width="15%">&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        -
							        <input type='hidden' name="fee_dc_per" value="0">
							    <%}else{%>                   	                	
                   �뿩���� <input type='text' size='4' name='fee_dc_per' maxlength='4' class='defaultnum' value=''>%
                  <%}%> 
                   </td>
              </tr>		
              <tr> 
                    <td width="13%" class=title >�������߰����</td>
                    <td>&nbsp;
                  <%if(acar_de.equals("1000")){%>
							        <%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>��(���ް�)
							        <input type='hidden' name="driver_add_amt" value="<%=fee_etcs.getDriver_add_amt()%>">
							    <%}else{%>
					            <input type='text' name='driver_add_amt' size='5' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>' class='defaultnum'>
					            ��(���ް�)
					        <%}%>
					</td>			                
              	
                <td width="10%" class=title >���������</td>
                <td colspan='5'>&nbsp;
				  <select <%if(!acar_de.equals("1000")){%>name='damdang_id'<%}else{%>name="s_damdang_id" disabled<%}%> class=default>            
                        <option value="">������</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        					%>
          			    <option value='<%=user.get("USER_ID")%>' <% if((!acar_de.equals("1000") && base.getBus_id2().equals(user.get("USER_ID"))) || (acar_de.equals("1000") && user_id.equals(user.get("USER_ID")))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>	  
        			        <%if(acar_de.equals("1000")){%>
							        <input type='hidden' name="damdang_id" value="<%=user_id%>">
							        <%}%>
                    </td>                
              </tr>							  	
			  
            </table>
        </td>
    </tr>
    <tr>
        <td>* �����ܰ���=���Կɼ���, ���Է½� ���� �ִ��ܰ����� �����մϴ�. </td>
    </tr>				
    <tr>
        <td>* �̿�Ⱓ�� 24�����̳����� ���� �����մϴ�.</td>
    </tr>				
    <%if(base.getCar_gu().equals("0") && fee_opt_amt == 0){%>
    <tr>
        <td><font color=red>* ���Կɼ��� ���� �縮�� ����� ����� ���Կɼ��� �ο��� �� �����ϴ�.</font></td>
    </tr>
    <%}%>
	<%if(fee_type.equals("fee_im")){
		tr_display_dt = "";
	%>
    <tr>
        <td><font color=red>* ���� �뿩�� ���ǿ����Դϴ�. �������� �뿩�������� ǥ������ �ʽ��ϴ�.</font></td>
    </tr>				
	<%}%>
    <tr>
        <td class=h></td>
    </tr>	
	<!--
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> �뿩���</span></td>
    </tr>
	-->
	    <input type='hidden' name="rent_st" value="<%=fee_size+1%>">
    <tr id=tr_2 style='display:<%=tr_display_dt%>'>
        <td class=line2></td>
    </tr>
    <tr id=tr_3 style='display:<%=tr_display_dt%>'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="13%" align="center" class=title>�������</td>
                    <td width="20%">&nbsp;
					<input type="text" name="rent_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
                        </td>
                    <td width="10%" align="center" class=title>�뿩������</td>
					<td width="20%">&nbsp;
					<input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class=default onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this); getTotDist_h();'>
                    </td>
					<td width="20%">&nbsp;
                      </td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td>&nbsp;
                    <input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>
            </table>
        </td>
    </tr>
    <!--
	<tr></tr>
	<tr></tr>
	-->
    <tr id=tr_4 style='display:<%=tr_display%>'>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>����</td>
                    <td class='title' width='13%'>���ް�</td>
                    <td class='title' width='13%'>�ΰ���</td>
                    <td class='title' width='13%'>�հ�</td>
                    <td class='title' width="28%">�������</td>
                    <td class='title' width='20%'>-</td>
                </tr>
                <tr>
                    <td width="3%" rowspan="3" class='title'>��<br>
                      ��</td>
                    <td width="10%" class='title'>������</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'></td>
                    <td align="center">������
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='' readonly>
        				  % </td>
                    <td align='center'>
        			    <input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>'>
        				<select name='grt_suc_yn' onChange="javascript:display_suc('grt')">
                              <option value=""  <%if(fee.getGrt_amt_s()==0)%>selected<%%>>����</option>
                              <option value="0" <%if(fee.getGrt_amt_s()> 0)%>selected<%%>>�°�</option>
                              <option value="1">����</option>
                            </select>				
        				</td>
                </tr>
                <tr>
                    <td class='title'>������</td>
                    <td align="center"><input type='text' size='11' name='pp_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='11' name='pp_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'></td>
                    <td align="center">������
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='' readonly>
        				  % </td>
                    <td align='center'>-<input type='hidden' name='pere_per' value=''></td>
                </tr>
                <tr>
                    <td class='title'>���ô뿩��</td>
                    <td align="center"><input type='text' size='11' name='ifee_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='11' name='ifee_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='11' name='ifee_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">������
                         </td>
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
                    <td rowspan="3" class='title'>��<br>
                      ��</td>
                    <td class='title'>�ִ��ܰ�</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' maxlength='11' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='ja_v_amt' maxlength='10' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' maxlength='11' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align='center'>
        			  �ִ��ܰ���:������
                          <input type='text' size='4' name='max_ja' maxlength='10' class='whitenum' value='' readonly>
                          %</td>
                    <td align='center'>-</td>
                </tr>    
                <tr>
                    <td class='title'>���Կɼ�</td>
                    <td align="center"><input type='text' size='11' name='opt_s_amt' maxlength='11' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='11' name='opt_v_amt' maxlength='10' class='num' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='11' name='opt_amt' maxlength='11' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">������
                        </td>
                    <td align='center'>
        			  
                    </td>
                </tr>
                <tr>
                    <td class='title'>�����ܰ�</td>
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' maxlength='11' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='ja_r_v_amt' maxlength='10' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' maxlength='11' class='whitenum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td align="center">������<input type='text' size='4' name='app_ja' maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        			  % 
        			  </td>
                    <td align='center'>-</td>				  
                </tr>		  				
                <tr>
                    <td colspan='2' class='title'>�뿩�� ������</td>
                    <td align="center" ><input type='text' size='11' name='inv_s_amt' maxlength='10' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='11' name='inv_v_amt' maxlength='9' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='11' maxlength='10' name='inv_amt' class='defaultnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">������<span class="contents1_1">
                      
					  <input type='hidden' name="bas_dt"		value="">
                    </span></td>
                    <td align='center'>&nbsp;
        			  <span class="b"><a href="javascript:estimate('account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>					  
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6") || base.getBus_id().equals(ck_acar_id) ) {%>
    <tr> 
      <td align=center><a href="javascript:estimate('account');"><img src=/acar/images/center/button_est.gif border=0 align=absmiddle></a> 
      </td>
    </tr>	
    <%}%>
	
    <tr>
		<td align="right"><a href="javascript:view_car_esti_h()" title="�̷�"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a></td>
	</tr>	
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

	var fm = document.form1;
	
	if(fm.bas_dt.value == ''){
		fm.bas_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';
		fm.rent_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';
		fm.rent_start_dt.value 			= '<%= AddUtil.ChangeDate2(fee_start_dt) %>';				
	}

<%	if(fee_opt_amt>0){//������� ���Կɼ��� �ִ� ���%>		
	fm.fee_opt_amt.value = parseDecimal(<%=fee_opt_amt%>);
	<%if(!acar_de.equals("1000")){%>
	fm.opt_chk[1].checked = true;
	<%}%>
	fm.o_1.value	= parseDecimal(fm.fee_opt_amt.value);		
<%	}else{%>
	<%if(!acar_de.equals("1000")){%>
	fm.opt_chk[0].checked = true;
	<%}%>
<%	}%>
	
	if(fm.udt_st.value == ''){
		if('<%=user_bean.getBr_id()%>'=='S1') fm.udt_st.value = '1';
		if('<%=user_bean.getBr_id()%>'=='B1') fm.udt_st.value = '2';
		if('<%=user_bean.getBr_id()%>'=='D1') fm.udt_st.value = '3';
	}
	
	//����Ʈ 12����
	fm.con_mon.value = '12';
	set_cont_date(fm.con_mon); 
	getSecondhandCarAmt_h();
	
	//�ʰ�����
	var fw_917 = getRentTime('l', '<%=fee.getRent_start_dt()%>', '<%=ext_fee.getRent_end_dt()%>');
	
	if ( '<%=taecha_st_dt%>'  != '' )  {
		fw_917 = getRentTime('l', '<%=taecha_st_dt%>', '<%=ext_fee.getRent_end_dt()%>');
	}
	
	fm.o_rent_days.value = fw_917;
	
	fm.o_y_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_agree_dist.value))*fw_917/365);
	
	fm.o_b_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_y_agree_dist.value))+toInt(parseDigit(fm.o_over_bas_km.value))+1000);
	
	fm.o_over_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_sh_km.value))-toInt(parseDigit(fm.o_b_agree_dist.value)));
	if(toInt(parseDigit(fm.o_over_agree_dist.value)) <=0){
		fm.o_over_agree_dist_nm.value = '�ѵ���';
	}
	if(toInt(parseDigit(fm.o_over_agree_dist.value)) >0){
		fm.o_over_agree_dist_nm.value = '�ѵ��ʰ�';
	}
		
		
	//�ϼ� ���ϱ�
	function getRentTime(gubun, d1, d2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var t1;
		var t2;
		var t3;		
		t1 = getDateFromString(replaceString('-','',d1)).getTime();
		t2 = getDateFromString(replaceString('-','',d2)).getTime();
		t3 = t2 - t1;			
		if(gubun=='m') return parseInt(t3/m);
		if(gubun=='l') return parseInt(t3/l);
		if(gubun=='lh') return parseInt(t3/lh);
		if(gubun=='lm') return parseInt(t3/lm);		
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}			
	
//-->
</script>
</body>
</html>

