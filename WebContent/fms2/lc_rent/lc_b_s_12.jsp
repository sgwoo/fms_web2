<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.con_ins.*, acar.ext.*, acar.im_email.*,acar.insur.*, acar.doc_settle.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="ae_db" class="acar.ext.AddExtDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();

	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	String fee_rent_st = request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	//�ڵ����⺻����-�⺻����
	CarMstBean cm_bean2 = cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		ins = ai_db.getInsCase(base.getCar_mng_id(), ai_db.getInsSt(base.getCar_mng_id()));//��������
	}
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	if(fee_size > 1) rent_st = Integer.toString(fee_size);
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	//�������뿩����
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	//���ຸ������
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	//������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");	
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());	
	
	//�����뿩 �⺻��
	if(base.getCar_st().equals("5") && fees.getRent_way().equals("")){
		fees.setRent_way("3");
	}
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	String a_a = "2";	
	if(base.getCar_st().equals("3")) a_a = "1";
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
	
	String o_3 = edb.getEstiSikVarCase("1", "", "o_3");
	//String gi_fee = edb.getEstiSikVarCase("1", "", "gi_fee");//���������
	Hashtable sh_ht = new Hashtable();
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt());//������� ����Ⱓ(����)
	//�ܰ� ��������
	Hashtable sh_var = shDb.getShBaseVar(base.getCar_mng_id());
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+Integer.toString(fee_size)+"&from_page="+from_page;
	String valus_t = valus;
	int fee_opt_amt = 0;
	for(int f=1; f<=fee_size; f++){
		ContFeeBean fees2 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
		if(fee_size >1 && f==(fee_size-1)){
			fee_opt_amt = fees2.getOpt_s_amt()+fees2.getOpt_v_amt();
		}
	}
	//�⺻DC ��������
	String car_d_dt = e_db.getDc_b_dt(cm_bean.getCar_comp_id()+""+cm_bean.getCode(), "dc", base.getRent_dt(), cm_bean.getCar_b_dt());
	CarDcBean cd_bean = cmb.getCarDcBaseCase(cm_bean.getCar_comp_id(), cm_bean.getCode(), car_d_dt, cm_bean.getCar_b_dt());
	//�̸���ȸ
	int user_idx = 0;
	
	e_bean = e_db.getEstimateCase(fee_etc.getBc_est_id()); 
	
	DocSettleBean doc = d_db.getDocSettleCommi("1", rent_l_cd);

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	function replaceFloatRound(per){return Math.round(per*1000)/10;}
	function replaceFloatRound2(per){return Math.round(per*10)/10;}
	//���������ݽ°���ȸ
	function search_grt_suc(){window.open("/fms2/car_pur/s_grt_suc.jsp?from_page=/fms2/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>","SERV_GRT_OFF","left=10,top=10,width=800,height=500,scrollbars=yes,status=yes,resizable=yes");}
	//���������ݽ°����
	function cancel_grt_suc(){var fm=document.form1;fm.grt_suc_l_cd.value='';fm.grt_suc_m_id.value='';fm.grt_suc_c_no.value='';fm.grt_suc_o_amt.value='';fm.grt_suc_r_amt.value='';}
	//Ư�Ҽ��������� ��������
	function setVar_o_123(car_price){
		var o_1 = car_price;
		//������ Ư�Ҽ���
		var o_2 = <%=ej_bean.getJg_3()%>;
		//Ư�Ҽ��������� o_3 = o_1/(1+o_2), ��������/(1+Ư�Ҽ���);
		var o_3 = Math.round(<%=o_3%>);
		fm.v_o_1.value = o_1;
		fm.v_o_2.value = o_2;
		fm.v_o_3.value = o_3;
	}
	//�뿩�Ⱓ ����
	function set_cont_date(obj){
		var fm = document.form1;	
		var rent_way = <%=fees.getRent_way()%>;
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == '')) return;
		if(obj == fm.con_mon){ fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value); }
		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
		fm.action='get_fee_nodisplay.jsp';
		fm.target='i_no';
		//if(<%=fees.getRent_st()%>!='1'){
			fm.submit();	
		//}
	}
	//�ݿø�
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}		
	//���/����: �������� �Է½� �ڵ�������� ����..
	function enter_fee(obj, rent_dt){
		var keyValue = event.keyCode;
		
		if (keyValue =='13') set_fee_amt(obj, rent_dt);
	}	
	//���/����: ���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_fee_amt(obj, rent_dt)
	{
		var fm = document.form1;
		var car_price = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price);
		if(rent_dt == '') rent_dt = <%=base.getRent_dt()%>;
		car_price = car_price - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));
		//Ư����� 
		//20190513 DC�ݾ� �鼼���ݿ����Ѵ�.
		//20190816 Ư���� ������ ����
		<%if(!base.getCar_st().equals("5")){%>
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn.value == 'Y'){
		//	s_dc_amt = <%=cd_bean.getCar_d_p()%>;
		//	var s_dc_per = <%=cd_bean.getCar_d_per()%>;
		//	if(s_dc_per > 0){ s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt; }
			car_price = <%=e_bean.getO_1()%>;
		}
		//car_price = car_price - s_dc_amt;
		<%}%>
		var f_car_price = car_price;
		if(fm.car_gu.value != '1'){ car_price = toInt(parseDigit(fm.sh_amt.value)); }
		if(<%=fee_size%> > 1){
			car_price = toInt(parseDigit(fm.sh_amt.value));
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) car_price	= toInt(parseDigit(fm.fee_opt_amt.value));
		}
		
		obj.value = parseDecimal(obj.value);
		//������---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt || obj==fm.grt_amt){
			if(obj==fm.grt_s_amt)	 fm.grt_amt.value 	 = fm.grt_s_amt.value;	//���ް�
			if(obj==fm.grt_amt)		 fm.grt_s_amt.value = fm.grt_amt.value;		//�հ�
			if(car_price > 0){
				fm.gur_p_per.value 	 = replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
				fm.f_gur_p_per.value = replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / f_car_price );
			}
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt || obj==fm.pp_v_amt || obj==fm.pp_amt){
			if(obj==fm.pp_s_amt){ 	//������ ���ް�
				fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
				fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));
			}
			if(obj==fm.pp_v_amt){ 	//������ �ΰ���
				fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));
			}
			if(obj==fm.pp_amt){ 	//������ �հ�
				fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
				fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));
			}
			if(car_price > 0){
				fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
				fm.f_pere_r_per.value = replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / f_car_price );
			}
		//���ô뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.ifee_s_amt || obj==fm.ifee_v_amt || obj==fm.ifee_amt){
			if(obj==fm.ifee_s_amt){ 	//���ô뿩�� ���ް�
				fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
				fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));
			}
			if(obj==fm.ifee_v_amt){ 	//���ô뿩�� �ΰ���
				fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));
			}
			if(obj==fm.ifee_amt){ 	  //���ô뿩�� �հ�
				fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
				fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));
			}
			fm.pere_r_mth.value = Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
			fm.fee_pay_tm.value = toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
		//�ִ��ܰ���---------------------------------------------------------------------------------
		}else if(obj==fm.max_ja){ 		//�ִ��ܰ���
			fm.ja_amt.value 	  = parseDecimal(getCutRoundNumber(car_price * toFloat(fm.max_ja.value) /100,-3) );
			fm.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));
		}else if(obj==fm.ja_s_amt){ 	//�ִ��ܰ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) * 0.1 );
			fm.ja_amt.value		  = parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));
		}else if(obj==fm.ja_v_amt){ 	//�ִ��ܰ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ja_amt.value		  = parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));
		}else if(obj==fm.ja_amt){		//�ִ��ܰ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));
			if(car_price > 0){
				fm.max_ja.value 	= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
			}
		//�����ܰ���---------------------------------------------------------------------------------
		}else if(obj==fm.app_ja){ 		//�����ܰ���
			fm.ja_r_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.app_ja.value) /100,-3) );
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));
		}else if(obj==fm.ja_r_s_amt){ 	//�����ܰ� ���ް�
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		  = parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));
		}else if(obj==fm.ja_r_v_amt){ 	//�����ܰ� �ΰ���
			fm.ja_r_amt.value		  = parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));
		}else if(obj==fm.ja_r_amt){		//�����ܰ� �հ�
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));
			if(car_price > 0){	
				fm.app_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_r_amt.value)) / car_price );
			}
		//���Կɼ���---------------------------------------------------------------------------------
		}else if(obj==fm.opt_s_amt){ 	//���Կɼ� ���ް�
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		  = parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(car_price > 0){
				fm.opt_per.value 	  = replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
				fm.f_opt_per.value 	= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / f_car_price );
			}
		}else if(obj==fm.opt_v_amt){ 	//���Կɼ� �ΰ���
			fm.opt_amt.value		  = parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
		}else if(obj==fm.opt_amt){ 		//���Կɼ� �հ�
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				fm.opt_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
				fm.opt_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));
				if(car_price > 0){
					fm.opt_per.value 	 = replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
					fm.f_opt_per.value = replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / f_car_price );
				}
			}
		//���뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.fee_s_amt){ 	//���뿩�� ���ް�
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
			fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
		}else if(obj==fm.fee_v_amt){ 	//���뿩�� �ΰ���
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_amt){ 		//���뿩�� �հ�
			fm.fee_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));
			fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
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
		//�Ѻ����---------------------------------------------------------------------------------
		}else if(obj==fm.ins_total_amt){
			obj.value = parseDecimal(obj.value);
			fm.ins_total_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_total_amt.value)));
		//�����뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//�����뿩�� ���ް�
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));
			setTinv_amt();
		}else if(obj==fm.inv_v_amt){ 	//�����뿩�� �ΰ���
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));
			setTinv_amt();
		}else if(obj==fm.inv_amt){ 		//�����뿩�� �հ�
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));
			setTinv_amt();
		//������ �߰����(2018.03.30)-------------------------------------------------------------------	
		}else if(obj==fm.driver_add_amt){	//�������߰���� ���ް�
			fm.driver_add_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) * 0.1 );
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
			setTinv_amt();
		}else if(obj==fm.driver_add_v_amt){ 	//�������߰���� �ΰ���
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
			setTinv_amt();
		}else if(obj==fm.driver_add_total_amt){ //�������߰���� �հ�
			fm.driver_add_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.driver_add_total_amt.value))));
			fm.driver_add_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.driver_add_total_amt.value)) - toInt(parseDigit(fm.driver_add_amt.value)));
			setTinv_amt();
		}
	
		if(obj==fm.opt_s_amt || obj==fm.opt_v_amt || obj==fm.opt_amt){ 	//���Կɼ�
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(rent_dt >= 20080501 && toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){
					//�����϶��� ���Կɼ��� �����ܰ�
					if(<%=fee_size%> > 1){
						fm.app_ja.value = fm.opt_per.value;
						fm.ja_r_s_amt.value = fm.opt_s_amt.value;
						fm.ja_r_v_amt.value = fm.opt_v_amt.value;
						fm.ja_r_amt.value = fm.opt_amt.value;
					}else{
						fm.app_ja.value = fm.max_ja.value;
						fm.ja_r_s_amt.value = fm.ja_s_amt.value;
						fm.ja_r_v_amt.value = fm.ja_v_amt.value;
						fm.ja_r_amt.value = fm.ja_amt.value;
					}
				}else{
					fm.app_ja.value = fm.opt_per.value;
					fm.ja_r_s_amt.value = fm.opt_s_amt.value;
					fm.ja_r_v_amt.value = fm.opt_v_amt.value;
					fm.ja_r_amt.value = fm.opt_amt.value;
				}
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value = fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value = fm.ja_amt.value;
				fm.opt_chk[0].checked = true;
			}
		}
		sum_pp_amt();
	}
	
	//�������հ� ���ϱ�
	function setTinv_amt(){
		fm.tinv_s_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.driver_add_amt.value)));
		fm.tinv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
		fm.tinv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.driver_add_total_amt.value)));
	}
	
	//���Կɼ�����
	function opt_display(st, rent_dt){
		var fm = document.form1;
		if(rent_dt == '') rent_dt = <%=base.getRent_dt()%>;
		if(st == ''){
			if(fm.opt_chk[0].checked == true)	st = '0'; //����
			else if(fm.opt_chk[1].checked == true)	st = '1'; //����
		}
		if(st == '0'){
			fm.app_ja.value = fm.max_ja.value;
			fm.ja_r_s_amt.value = fm.ja_s_amt.value;
			fm.ja_r_v_amt.value = fm.ja_v_amt.value;
			fm.ja_r_amt.value = fm.ja_amt.value;
			fm.opt_s_amt.value = 0;
			fm.opt_v_amt.value = 0;
			fm.opt_amt.value = 0;
			fm.opt_per.value = 0;
		}else if(st == '1'){
			if(rent_dt >= 20080501 && toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){
				fm.app_ja.value = fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value = fm.ja_amt.value;
			}else{		
				fm.app_ja.value = fm.opt_per.value;
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value = fm.opt_amt.value;
			}
		}
	}
	//�������� ��������
	function setCarPrice(st){
		var fm = document.form1;
		var car_price = 0;
		if(st == 'car_c_price')		car_price = <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()%>;
		if(st == 'car_price2')		car_price	= <%=car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()+car.getAdd_opt_amt()%>;
		return car_price;
	}
	//DC�ݾ� ��������
	function setDcAmt(car_price){
		var fm = document.form1;		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		//�Ϲ� ������ ��Ʈ������ ����D/C�ݾ� Ư�Ҽ����ݿ�---------------
		var purc_gu 	= fm.purc_gu.value;
		var s_st 			= fm.s_st.value;
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼) 
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);
				s_dc_amt = Math.round(s_dc_amt*(1+toFloat(fm.v_o_2.value)));
			}
		}
		//������
		if('<%=ej_bean.getJg_w()%>'=='1'){ s_dc_amt = 0; }
		return s_dc_amt;
	}	
	//DC�ݾ� ��������
	function setDcAmt2(car_price){
		var fm = document.form1;		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));		
		//������
		if('<%=ej_bean.getJg_w()%>'=='1'){ s_dc_amt = 0; }
		return s_dc_amt;
	}		
	//������ �հ�
	function sum_pp_amt(){
		var fm = document.form1;
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value   = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );
		var car_price = setCarPrice('car_price2');
		var s_dc_amt 	= setDcAmt2(car_price);
    	car_price = car_price - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));
		if(fm.car_gu.value != '1'){
			car_price 	= toInt(parseDigit(fm.sh_amt.value));
		}
		if(<%=fee_size%> > 1){
			car_price 	= toInt(parseDigit(fm.sh_amt.value));
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) car_price	= toInt(parseDigit(fm.fee_opt_amt.value));
		}
		var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
		if(pp_price>0 || car_price>0){
			fm.credit_r_per.value = replaceFloatRound(pp_price / car_price );
			fm.credit_r_amt.value = parseDecimal(pp_price);
		}
	}
	//�����뿩�� ��� (����) 
	function estimate(rent_st, rent_dt, rent_start_dt, st){
		var fm = document.form1;
		set_fee_amt(fm.opt_amt, rent_dt);
		if(fm.con_mon.value == '')					{ alert('�̿�Ⱓ�� �Է��Ͻʽÿ�.');			return;}
		if(fm.driving_age.value == '')			{ alert('�����ڿ����� �����Ͻʽÿ�.');		return;}
		if(fm.gcp_kd.value == '')						{ alert('�빰����� �����Ͻʽÿ�.');			return;}
		
		// �׽��� ���� �뿩�Ⱓ ���� ����. 20210225
		<%-- if ('<%=cm_bean.getCar_comp_id()%>' == '0056' && '<%=base.getCar_st()%>' != '5') {
			if(fm.con_mon.value > 48) {
				alert('�׽��������� ��� 48���� �̻� ������ �Ұ� �մϴ�.');
				fm.con_mon.focus();
				return;
			}
		} --%>
		
		var agree_dist 		= toInt(parseDigit(fm.agree_dist.value));
		fm.fee_rent_st.value = rent_st;
		fm.fee_rent_dt.value = rent_dt;
		if(toInt(rent_st) > 1)  fm.fee_rent_dt.value = rent_start_dt;
		if(fm.car_gu.value == '1' && fm.fee_size.value == '1' && fm.one_self.value == '')	{	alert('������� �����Ͽ� �ֽʽÿ�.');  return; }
		var car_price 	= setCarPrice('car_price2');
		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		
		
		//�Ϲ� ������ ��Ʈ������ ����D/C�ݾ� Ư�Ҽ����ݿ�---------------
		var purc_gu 	= fm.purc_gu.value;
		var s_st 			= fm.s_st.value;
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);	������DC�� ����				
				if(<%=base.getRent_dt()%> >= 20130501 && '<%=ej_bean.getJg_w()%>'=='1'){
				}else{
					s_dc_amt = Math.round(s_dc_amt*(1+toFloat(fm.v_o_2.value)));
				}
			}
		}
		
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
		fm.o_1.value 				= car_price - s_dc_amt;
		fm.t_dc_amt.value 	= s_dc_amt;
		fm.esti_stat.value 	= st;
		<%if(!base.getCar_st().equals("5")){%>
		//Ư�����
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn.value == 'Y'){
			fm.o_1.value 			= car_price;
			fm.t_dc_amt.value = 0;
			s_dc_amt = <%=cd_bean.getCar_d_p()%>;
			var s_dc_per = <%=cd_bean.getCar_d_per()%>;
			if(s_dc_per > 0){
				s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt;
			}
			fm.o_1.value 			= car_price - s_dc_amt;
			fm.t_dc_amt.value = s_dc_amt;
		}
	  <%}%>
	  
			<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ���������� %>
			if(<%=base.getRent_dt()%> >= 20190215 && <%=base.getRent_dt()%> < 20191217){
				if(fm.return_select.value == ''){ alert('������ �μ�/�ݳ� ������ �����Ͻʽÿ�.'); return; }
				//�Ϲݽ��� �μ�/�ݳ� �������� �Ҽ� ����.
				if('<%=fees.getRent_way()%>' == '1' && fm.return_select.value == '0'){
					alert('�Ϲݽ��� ������ �μ�/�ݳ� �������� ������ �� �����ϴ�. ');
					return;
				}
				//�μ�/�ݳ� ������ - ���Կɼ�����
				if(fm.return_select.value == '0'){
					fm.opt_chk[1].checked = true;	
				//�ݳ��� - ���ԿɼǾ���	
				}else if(fm.return_select.value == '1'){
					fm.opt_chk[0].checked = true;	
					fm.opt_s_amt.value = 0;
					fm.opt_v_amt.value = 0;
					fm.opt_amt.value = 0;
					fm.opt_per.value = 0;
				}
				opt_display('', '');				
			}
			<%}%>				  
	  
		fm.ro_13.value 			= fm.app_ja.value;
		fm.o_13_amt.value 	= fm.ja_r_amt.value;
		if(toInt(parseDigit(fm.ja_r_amt.value)) > toInt(parseDigit(fm.ja_amt.value))){
			fm.ro_13.value 			= fm.max_ja.value;
			fm.o_13_amt.value 	= fm.ja_amt.value;
		}
		fm.o_13.value 		= fm.max_ja.value;
		
		if(st == 'view'){fm.target = '_blank';}else{fm.target = 'i_no';}
		//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.
		if('<%=base.getCar_st()%><%=fees.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');return;}
		}else{
			if(toInt(rent_st) == 1 && fm.insurant.value == '2'){alert('�������� ���� �����⺻�ĸ� �����մϴ�.');	return;}
		}
		
		
		if(toInt(rent_st) > 1){//����
			fm.o_1.value				= fm.sh_amt.value;
			fm.ro_13.value 			= fm.opt_per.value;
			fm.o_13_amt.value 	= fm.opt_amt.value;
			fm.o_13.value 			= 0;
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) fm.o_1.value	= fm.fee_opt_amt.value;
			if(toInt(fm.o_1.value) == 0){ alert('�߰������� �Է��Ͻʽÿ�.'); return;}
			fm.action='get_fee_estimate_20090901.jsp';
			if(toInt(fm.fee_rent_dt.value) < 20090924){
				fm.action='get_fee_estimate.jsp';	
			}
		}else{
			if(fm.car_gu.value != '1'){//�縮��&�߰���
				fm.o_1.value	= fm.sh_amt.value;
				fm.ro_13.value 			= fm.opt_per.value;
				fm.o_13_amt.value 	= fm.opt_amt.value;
				fm.o_13.value 			= 0;
				if(toInt(fm.o_1.value) == 0){ alert('�߰������� �Է��Ͻʽÿ�.'); return;}
				
				<%if (fees.getRent_st().equals("1") && base.getCar_gu().equals("0")) {%>
				if (fm.br_from_st.value == "") {
					alert('�縮�� ������ �̵� ����� ������ �ּ���.');
					return;
				} else {
					if (fm.br_from_st.value == "9") {
						fm.br_from.value = "";
					} else {
						fm.br_from.value = fm.br_from_st.value;
					}
				}
				
				if (fm.br_to_st.value == "") {
					alert('�縮�� ������ �̵� ������ ������ �ּ���.');
					return;
				} else {
					if (fm.br_to_st.value == "9") {
						fm.br_to.value = "";
					} else {
						fm.br_to.value = fm.br_to_st.value;
					}
				}
				<%}%>
				
				fm.action='get_fee_estimate_20090901.jsp';
				if(toInt(fm.fee_rent_dt.value) < 20090924){
					fm.action='get_fee_estimate.jsp';
				}
			}else{//����	
				fm.ro_13.value 		= fm.opt_per.value;
				fm.o_13_amt.value 	= fm.opt_amt.value;
				fm.o_13.value 		= 0;
				fm.action='get_fee_estimate_20090901.jsp';
				if(toInt(fm.fee_rent_dt.value) < 20090924){
					fm.action='get_fee_estimate.jsp';
				}
				
				<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id) || nm_db.getWorkAuthUser("���翵������",user_id) || nm_db.getWorkAuthUser("���翵��������",user_id)){%>
				<%	if(base.getCar_gu().equals("1") && !base.getDlv_dt().equals("") && fees.getRent_st().equals("1")){%>
				//������� ���� �����ϱ�
				if(fm.bc_dlv_yn.checked == true){
					fm.fee_rent_dt.value = '<%=base.getDlv_dt()%>';
				}
				<%	}%>
				<%}%>
			}
		}
		
		
		
		<%if(cm_bean.getJg_code().equals("")){%>alert("�����ܰ��ڵ尡 �����ϴ�. ������������ �Է��Ͻʽÿ�.");return;	<%}%>
		if(toInt(rent_st) > 1){//����
			fm.submit();
		}else{
			if(fm.car_gu.value != '1'){//�縮��&�߰���
				fm.submit();
			}else{
				if(confirm('�������� ������� '+fm.comm_r_rt.value+'%�� �����˴ϴ�. ����Ͻðڽ��ϱ�?')){
					if(fm.one_self.value == 'Y' && confirm('��ü���� �����˴ϴ�. ����Ͻðڽ��ϱ�?')){	fm.submit();}
					if(fm.one_self.value == 'N' && confirm('����������� �����˴ϴ�. ����Ͻðڽ��ϱ�?')){fm.submit();}
				}
			}
		}
	}

	//����������
	function setCommi(){
		var fm = document.form1;
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
		fm.commi.value = parseDecimal(th_round(car_price*comm_r_rt/100));
	}

	//����
	function update(idx){
		var fm = document.form1;
		
		<%//if(!ck_acar_id.equals("000029")){%>

				if(fm.car_st.value != '2'){
					if(fm.con_mon.value == ''){alert('�뿩���-�̿�Ⱓ�� �Է��Ͻʽÿ�.');fm.con_mon.focus();return;}
					
					<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ���������� %>
					if(<%=base.getRent_dt()%> >= 20190215 && <%=base.getRent_dt()%> < 20191217){
						if(fm.return_select.value == ''){ alert('������ �μ�/�ݳ� ������ �����Ͻʽÿ�.'); return; }
						//�Ϲݽ��� �μ�/�ݳ� �������� �Ҽ� ����.
						if('<%=fees.getRent_way()%>' == '1' && fm.return_select.value == '0'){
							alert('�Ϲݽ��� ������ �μ�/�ݳ� �������� ������ �� �����ϴ�. ');
							return;
						}//�μ�/�ݳ� ������ - ���Կɼ�����
						if(fm.return_select.value == '0'){
							fm.opt_chk[1].checked = true;	
						//�ݳ��� - ���ԿɼǾ���	
						}else if(fm.return_select.value == '1'){
							fm.opt_chk[0].checked = true;	
							fm.opt_s_amt.value = 0;
							fm.opt_v_amt.value = 0;
							fm.opt_amt.value = 0;
							fm.opt_per.value = 0;
						}else{
							alert('������ �μ�/�ݳ� ������ �����Ͻʽÿ�.');
							return;
						}
						opt_display('', '');						
					}
					<%}%>			
								
					if(toInt(parseDigit(fm.ja_amt.value)) == 0 && toInt(parseDigit(fm.ja_r_amt.value)) > 0){
						fm.ja_s_amt.value = fm.ja_r_s_amt.value;
						fm.ja_v_amt.value = fm.ja_r_v_amt.value;
						fm.ja_amt.value = fm.ja_r_amt.value;
						fm.max_ja.value = fm.app_ja.value;
					}
					<%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�") && !String.valueOf(begin.get("CLS_ST")).equals("��������")){%>
					if(fm.max_ja.value == ''){alert('�뿩���-�ִ��ܰ����� �Է��Ͻʽÿ�.');fm.max_ja.focus();return;}
					var ja_amt = toInt(parseDigit(fm.ja_amt.value));
					if(fm.car_st.value != '5' && toInt(fm.cls_r_per.value) < 1){alert('�뿩���-�ߵ������������� Ȯ���Ͻʽÿ�.');fm.cls_r_per.focus();return;}
					var fee_amt = toInt(parseDigit(fm.fee_amt.value));
					var inv_amt = toInt(parseDigit(fm.inv_amt.value));
					var pp_amt = toInt(parseDigit(fm.pp_amt.value));
					if(pp_amt == 0) fm.pp_chk.value = '';
					var agree_dist = toInt(parseDigit(fm.agree_dist.value));
					var over_run_amt = toInt(parseDigit(fm.over_run_amt.value));
					var rtn_run_amt = toInt(parseDigit(fm.rtn_run_amt.value));
					<%if(!base.getCar_st().equals("5")){%>
						if(fm.car_gu.value == '1' && fm.agree_dist.value !='������'){//����
							<%if(AddUtil.parseInt(base.getRent_dt()) > 20130604){%>
								if(agree_dist == 0){alert('�뿩���-��������Ÿ��� �Է��Ͻʽÿ�.');fm.agree_dist.focus();return;}
								if(over_run_amt == 0){alert('�뿩���-�ʰ�����δ���� �Է��Ͻʽÿ�.');fm.over_run_amt.focus();return;}
							<%}%>
							<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
								if(fm.rtn_run_amt_yn.value == '')								{ alert('�뿩���-ȯ�޴뿩�����뿩�θ� �Է��Ͻʽÿ�.'); 	fm.rtn_run_amt_yn.focus(); 	return; }	
								if(rtn_run_amt == 0 && fm.rtn_run_amt_yn.value == '0')			{ alert('�뿩���-ȯ�޴뿩�Ḧ �Է��Ͻʽÿ�.'); 			fm.rtn_run_amt.focus();return;}
								if(rtn_run_amt > 0 && fm.rtn_run_amt_yn.value == '1')			{ alert('�뿩���-ȯ�޴뿩��������̹Ƿ� ȯ�޴뿩�� 0�� ó���մϴ�.'); fm.rtn_run_amt.value = 0; }
							<%}%>
						}
						if(fm.car_gu.value == '0' && fm.agree_dist.value !='������'){//�縮��
							<%if(AddUtil.parseInt(base.getRent_dt()) > 20140724){%>
								if(agree_dist == 0){ alert('�뿩���-��������Ÿ��� �Է��Ͻʽÿ�.');fm.agree_dist.focus();return;}
								if(over_run_amt == 0){ alert('�뿩���-�ʰ�����δ���� �Է��Ͻʽÿ�.');fm.over_run_amt.focus();return;}
							<%}%>
							<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
								if(fm.rtn_run_amt_yn.value == '')								{ alert('�뿩���-ȯ�޴뿩�����뿩�θ� �Է��Ͻʽÿ�.'); 	fm.rtn_run_amt_yn.focus(); 	return; }	
								if(rtn_run_amt == 0 && fm.rtn_run_amt_yn.value == '0')			{ alert('�뿩���-ȯ�޴뿩�Ḧ �Է��Ͻʽÿ�.');			fm.rtn_run_amt.focus();return;}
								if(rtn_run_amt > 0 && fm.rtn_run_amt_yn.value == '1')			{ alert('�뿩���-ȯ�޴뿩��������̹Ƿ� ȯ�޴뿩�� 0�� ó���մϴ�.'); fm.rtn_run_amt.value = 0; }
							<%}%>
						}
						if(fm.car_gu.value == '0'){//�縮��
							var over_bas_km = toInt(parseDigit(fm.over_bas_km.value));
						
							<%if (fees.getRent_st().equals("1") && base.getCar_gu().equals("0")) {%>
							if (fm.br_from_st.value == "") {
								alert('�縮�� ������ �̵� ����� ������ �ּ���.');
								return;
							} else {
								if (fm.br_from_st.value == "9") {
									fm.br_from.value = "";
								} else {
									fm.br_from.value = fm.br_from_st.value;
								}
							}
							
							if (fm.br_to_st.value == "") {
								alert('�縮�� ������ �̵� ������ ������ �ּ���.');
								return;
							} else {
								if (fm.br_to_st.value == "9") {
									fm.br_to.value = "";
								} else {
									fm.br_to.value = fm.br_to_st.value;
								}
							}
							<%}%>
						
							<%if(fee_size==1){%>
							if(over_bas_km == 0){ alert('�뿩���-������ ������ ����Ÿ��� �Է��Ͻʽÿ�.');fm.over_bas_km.focus();return;}
							<%}%>
						}
					if(fm.fee_pay_tm.value == ''){ alert('�뿩���-����Ƚ���� �Է��Ͻʽÿ�.'); 				fm.fee_pay_tm.focus(); 		return; }
					fm.tax_dc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.tax_dc_amt.value))));
					fm.tax_dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.tax_dc_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
					
					<%	if(base.getCar_gu().equals("1") && fee_size==1){%>
					//Ư�����(�����̰�����)�̸� ���������� ����.
					if(<%=base.getRent_dt()%> >= 20190610 && toFloat(parseDigit(fm.comm_r_rt.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && '<%=cont_etc.getDlv_con_commi_yn()%>' == 'Y' && '<%=cont_etc.getDir_pur_commi_yn()%>' == 'Y' && '<%=pur.getDir_pur_yn()%>' == 'Y' && '<%=pur.getPur_bus_st()%>' != '1'){
						alert('�������̸鼭 ���ΰ��̰� ����������� �ִ� Ư������ ���������� �����ϴ�.'); return;
					}					
					<%	}%>
					

					
					
					<%}%>
					<%}%>
				}
				
		//���Կɼǿ��ο� ���� ����
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
				
		var checkSymbol = false;
		var symbol = "<>\"'\\";		// �Է� ���� ����� Ư�� ����(<, >, ', ")
		var con_etc = fm.con_etc.value;
		for(var i=0; i<con_etc.length; i++){
			if(symbol.indexOf(con_etc.charAt(i)) != -1) 	checkSymbol = true;
		}
		if(checkSymbol){		// Ư����� ����� �Ϻ� Ư�� ���� �Է� ���� ó�� ���� 2020.01.03.
			alert('�뿩���-Ư����� ���� ���뿡�� Ư�� ���� �� <, >, \', "\�� ����� �� �����ϴ�.'); return;
		}
		
		if (con_etc.indexOf("*,***") != -1) {
			alert('�뿩���-Ư����� ���� ���� �� ���뿩�� �λ�ݾ� �Է��� Ȯ���ϼ���.'); return;
		}
		
		<%//}%>
		
		fm.idx.value = idx;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}							
	}
	
	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
	}
	
	//�뿩�� DC�� ���
	function dc_fee_amt(){
		//�����ݿ��� �����. 20170310 �ҽ�����
	}		
	
	function estimates_view(rent_st, reg_code){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?car_gu=<%=base.getCar_gu()%>&rent_st="+rent_st+"&est_code="+reg_code+"&esti_table=estimate";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//Ư���û�� ����
	function reqdoc(rent_l_cd, rent_mng_id, rent_st){
		var url = 'lc_b_s_reqdoc.jsp?rent_l_cd='+rent_l_cd+'&rent_mng_id='+rent_mng_id+'&rent_st='+rent_st;
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
	}
	
	//����
	function update_item(st, rent_st){
		var cmd = "�Աݼ����� ����";
		if(st == 'grt_amt' || st == 'pp_amt' || st == 'ifee_amt'){
			alert('������ ������ �뿩�� ������ �����Ͻʽÿ�.');
			if(st == 'pp_amt'){
				<%if(fees.getPp_chk().equals("0")){%>cmd = "�ſ��յ���� �Աݼ����� ����"<%}%>		
			}
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st+"&cmd="+cmd, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}
	}
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>   
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>    
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_12.jsp'>   
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="s_st" 					value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="dpm" 					value="<%=cm_bean.getDpm()%>">
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
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">      
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">     
  <input type='hidden' name="o_1"			value="">
  <input type='hidden' name="ro_13"			value="">  
  <input type='hidden' name="o_13"			value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
  <input type='hidden' name="idx"			value="">  
  <input type='hidden' name="scan_cnt"			value="">    
  <input type='hidden' name="chk_cnt"			value="">
  <input type='hidden' name="car_id"			value="<%=cm_bean.getCar_id()%>">  
  <input type='hidden' name="car_id2"			value="<%=cm_bean2.getCar_id()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>
  <input type='hidden' name="remove_seq"		value="">  
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">    
  <input type='hidden' name="est_from"			value="lc_b_u">
  <input type='hidden' name="fee_opt_amt"		value="">  
  <input type='hidden' name="rent_mng_id2"		value="">    
  <input type='hidden' name="rent_l_cd2"		value="">      
  <input type='hidden' name="fee_rent_st"		value="<%=rent_st%>">        
  <input type='hidden' name="fee_rent_dt"		value="">          
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">            
  <input type='hidden' name="v_o_1"			value="">
  <input type='hidden' name="v_o_2"			value="">
  <input type='hidden' name="v_o_3"			value="">
  <input type='hidden' name="car_cng_yn"		value="<%=cont_etc.getCar_cng_yn()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">
  <input type='hidden' name="tax_dc_amt" 		value="<%=car.getTax_dc_s_amt()+car.getTax_dc_v_amt()%>">
  <input type='hidden' name="tax_dc_s_amt" 	value="<%=car.getTax_dc_s_amt()%>">
  <input type='hidden' name="tax_dc_v_amt" 	value="<%=car.getTax_dc_v_amt()%>">
  <input type='hidden' name="dir_pur_yn" 		value="<%=pur.getDir_pur_yn()%>">
  <input type='hidden' name="one_self" 		value="<%=pur.getOne_self()%>">
  <input type='hidden' name="sh_amt" 		value="<%=fee_etc.getSh_amt()%>">
  <input type='hidden' name="gi_amt" 		value="<%=gins.getGi_amt()%>">
  <input type='hidden' name="gi_st" 		value="<%=gins.getGi_st()%>">
  <input type='hidden' name="driving_age" value="<%=base.getDriving_age()%>">
  <input type='hidden' name="gcp_kd" value="<%=base.getGcp_kd()%>">
  <%
  	if(cont_etc.getInsur_per().equals("")) 	cont_etc.setInsur_per("1");
  	if(cont_etc.getInsurant().equals("")) 	cont_etc.setInsurant("1");
  %>
  <input type='hidden' name="insurant" value="<%=cont_etc.getInsurant()%>">
  <input type='hidden' name="insur_per" value="<%=cont_etc.getInsur_per()%>">
  <input type='hidden' name="add_opt_amt" value="<%=car.getAdd_opt_amt()%>">
  <input type='hidden' name="sh_km" 		value="<%=fee_etc.getSh_km()%>">
  <input type='hidden' name="udt_st" 		value="<%=pur.getUdt_st()%>">
  <input type='hidden' name="car_c_amt" 		value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">
  <input type='hidden' name="opt" 		value="<%=car.getOpt_code()%>">
  <input type='hidden' name="opt_c_amt" 		value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">
  <input type="hidden" name="opt_amt_m" value="<%=car.getOpt_amt_m()%>">	
  <input type='hidden' name="color" 		value="<%=car.getColo()%>">
  <input type='hidden' name="col_c_amt" 		value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">
  <input type='hidden' name="car_st" 		value="<%=base.getCar_st()%>">
  <input type='hidden' name="rent_way" 		value="<%=fees.getRent_way()%>">
  <input type='hidden' name="car_ext" 		value="<%=car.getCar_ext()%>">
  <input type='hidden' name="eme_yn" 		value="<%=cont_etc.getEme_yn()%>">
  <input type='hidden' name="car_ja" 		value="<%=base.getCar_ja()%>">
  <input type='hidden' name="spr_kd" 		value="<%=base.getSpr_kd()%>">
  <input type='hidden' name="ecar_loc_st" 		value="<%=pur.getEcar_loc_st()%>">
  <input type='hidden' name="hcar_loc_st" 		value="<%=pur.getHcar_loc_st()%>">
  <input type='hidden' name="eco_e_tag" 		value="<%=car.getEco_e_tag()%>">
  <input type='hidden' name="tint_b_yn" 		value="<%=car.getTint_b_yn()%>">
  <input type='hidden' name="tint_s_yn" 		value="<%=car.getTint_s_yn()%>">
  <input type='hidden' name="tint_n_yn" 		value="<%=car.getTint_n_yn()%>">
  <input type='hidden' name="tint_bn_yn" 		value="<%=car.getTint_bn_yn()%>">
  <input type='hidden' name="tint_sn_yn" 		value="<%=car.getTint_sn_yn()%>">
  <input type='hidden' name="new_license_plate" 		value="<%=car.getNew_license_plate()%>">
  <input type='hidden' name="tint_cons_yn" 		value="<%=car.getTint_cons_yn()%>">
  <input type='hidden' name="tint_cons_amt"		value="<%=car.getTint_cons_amt()%>">
  <input type='hidden' name="tint_eb_yn" 		value="<%=car.getTint_eb_yn()%>">
  <input type='hidden' name="tint_ps_yn" 		value="<%=car.getTint_ps_yn()%>">
  <input type='hidden' name="tint_ps_nm" 		value="<%=car.getTint_ps_nm()%>">
  <input type='hidden' name="tint_ps_amt" 	value="<%=car.getTint_ps_amt()%>">
  <input type='hidden' name="ecar_pur_sub_amt" value="<%=car.getEcar_pur_sub_amt()%>">
  <input type='hidden' name="ecar_pur_sub_st" value="<%=car.getEcar_pur_sub_st()%>">
  <input type='hidden' name="h_ecar_pur_sub_amt" value="<%=car.getEcar_pur_sub_amt()%>">
  <input type='hidden' name="h_ecar_pur_sub_st" value="<%=car.getEcar_pur_sub_st()%>">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  
  <input type='hidden' name="br_from"			value="">
  <input type='hidden' name="br_to"				value="">
  <!-- <input type='hidden' name="br_from_st"		value="">
  <input type='hidden' name="br_to_st"			value=""> -->
  <input type='hidden' name="san_st"			value="<%=san_st%>">
       
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�̰���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span></td>
    </tr>

	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <!-- �縮���� �����ε������� �Է� -->
              <%if(fees.getRent_st().equals("1") && base.getCar_gu().equals("0")){ %>
              <tr>
                <td width="13%" align="center" class=title>�����ε�������</td>
                <td colspan='5'>&nbsp;
                    <input type='text' size='12' name='car_deli_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
					 (�縮������� �� �����ε������� ���� ���躯���մϴ�. �ε� Ȯ���� �ٽ� Ȯ���Ͻʽÿ�.)
					 </td>
              </tr>              
              <%}%>
              <tr>
                <td width="13%" align="center" class=title>�������</td>
                <td width="20%">&nbsp;
					  <%if(nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("5���̻���������",user_id)  || nm_db.getWorkAuthUser("������",user_id)  || user_id.equals(base.getBus_id())){%>
        			  <input type="text" name="ext_rent_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_dt())%>" size='12' maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(fees.getRent_dt())%>
					  <input type='hidden' name='ext_rent_dt' 	value='<%=fees.getRent_dt()%>'>
					  <%}%>				
				  
				</td>
                <td width="10%" align="center" class=title>�������</td>
                <td >&nbsp;    
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fees.getExt_agnt(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_agnt" value="<%=fees.getExt_agnt()%>">			
			<a href="javascript:User_search('ext_agnt', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
                </td>
                <td width="10%" align="center" class=title>�����븮��</td>
                <td >&nbsp;                  
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etc.getBus_agnt_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_bus_agnt_id" value="<%=fee_etc.getBus_agnt_id()%>">			
			<a href="javascript:User_search('ext_bus_agnt_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>               
                </td>
              </tr>				
              <tr>
                <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                <td width="20%">&nbsp;
                    <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 ����</td>
                <td width="10%" align="center" class=title>�뿩������</td>
                <td width="20%">&nbsp;
                  <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size='12' maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);' readonly></td>
                <td width="10%" align="center" class=title>�뿩������</td>
                <td>&nbsp;
                  <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size='12' maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);' readonly></td>
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
                    <td class='title' width='11%'>���ް�</td>
                    <td class='title' width='11%'>�ΰ���</td>
                    <td class='title' width='13%'>�հ�</td>
                    <td class='title' width='4%'>�Ա�</td>
                    <td class='title' width="28%">�������</td>
                    <td class='title' width='20%'>��������</td>
                </tr>
                <% String pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0"); %>
                <tr>
                    <td width="3%" rowspan="5" class='title'>��<br>
                      ��</td>
                    <td width="10%" class='title' colspan="2">������</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='12' maxlength='10' name='grt_s_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum'  readonly<%}else{%>class='num'  onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%}%>>
        				  ��</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">������
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_gur_p_per' class='fixnum' value='<%=fees.getF_gur_p_per()%>' readonly>
    				            %
    				            <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>
    				            <br><font color=red>�� �Աݵ� �������� ���� ���游 �����մϴ�.</font>
    				            <a href="javascript:update_item('grt_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        				    </td>
                    <td align='center'>
					<%if(fee_size==1 && base.getRent_st().equals("3")){%>
					  ���� ������ �°迩�� :
					  <select name='grt_suc_yn'>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0"))%>selected<%%>>�°�</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1"))%>selected<%%>>����</option>
                            </select>	
					<%}else{%>					
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='grt_suc_yn' value='<%= fees.getGrt_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='grt_suc_yn'>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0")){%>selected<%}%>>�°�</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1")){%>selected<%}%>>����</option>
                            </select>			  
        				<%}%>
					<%}%>
        				<input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'></td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1"); %>
                <tr>
                    <td class='title' colspan="2">������</td>
                    <td align="center"><input type='text' size='12' name='pp_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align="center"><input type='text' size='12' name='pp_v_amt' maxlength='10' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align='center'><input type='text' size='12' name='pp_amt'   maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">������
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_pere_r_per' class='fixnum' value='<%=fees.getF_pere_r_per()%>' readonly>
    				            %  
    				            <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>
    				            <br><font color=red>�� �Աݵ� �������� ���� ���游 �����մϴ�.</font>
    				            <a href="javascript:update_item('pp_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        				    </td>
                    <td align='center'><input type='hidden' name='pere_per' value=''>
           ������ ��꼭���౸�� :
					<select name='pp_chk'>
                              <option value="">����</option>
                              <option value="1" <%if(fees.getPp_chk().equals("1")){%>selected<%}%>>�����Ͻù���</option>
                              <option value="0" <%if(fees.getPp_chk().equals("0")){%>selected<%}%>>�ſ��յ����</option>
                            </select>                       	
                    </td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2"); %>
                <tr>
                    <td class='title' colspan="2">���ô뿩��</td>
                    <td align="center"><input type='text' size='12' name='ifee_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align="center"><input type='text' size='12' name='ifee_v_amt' maxlength='10'  value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align='center'><input type='text' size='12' name='ifee_amt' maxlength='11'  value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">������
                        <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  ����ġ �뿩�� 
        				  <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>
    				            <br><font color=red>�� �Աݵ� ���ô뿩��� ���� ���游 �����մϴ�.</font>
    				            <a href="javascript:update_item('ifee_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        				  </td>
                    <td align='center'>
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='ifee_suc_yn' value='<%= fees.getIfee_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='ifee_suc_yn'>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getIfee_suc_yn().equals("0")){%>selected<%}%>>�°�</option>
                              <option value="1" <%if(fees.getIfee_suc_yn().equals("1")){%>selected<%}%>>����</option>
                            </select>			  
        				<%}%>
        			    <input type='hidden' name='pere_mth' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">�հ�</td>
                    <td align="center"><input type='text' size='12' name='tot_pp_s_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='12' name='tot_pp_v_amt' maxlength='10' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='12' name='tot_pp_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">�Աݿ����� :
                          <input type='text' size='12' name='pp_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>&nbsp;
					<%	ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fees.getRent_st(), "5", "1");//�°������ ���� ��� ���� ��ȸ
						if(suc == null || suc.getRent_l_cd().equals("")){
							
						}else{%>	
					�°������ �Աݿ��� : <%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "5")%>
					<%	}%>
					</td>
                </tr>
                <tr>
        	    <td class='title' colspan="2">��ä��Ȯ��</td>
                    <td colspan='3'>&nbsp;
                        ������ : <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etc.getCredit_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="credit_sac_id" value="<%=fee_etc.getCredit_sac_id()%>">
			<a href="javascript:User_search('credit_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
			&nbsp;&nbsp;&nbsp;&nbsp;
			�������� : <input type='text' size='12' name='credit_sac_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee_etc.getCredit_sac_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>				
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='12' name='credit_r_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>��(������������)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='12' name='credit_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_amt())%>' readonly>��</td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>����<br>
                      �Ÿ�</td>              
              <!--20130605 ������������Ÿ� �-->    
                <td class='title' colspan="2"><span class="title1">��������Ÿ�</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='agree_dist' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' >
                  km����/1��,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (�������Ͽ����) ȯ�޴뿩��  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��/1km (�ΰ�������)
                  <%	if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
                  <select name='rtn_run_amt_yn'>        
                    <option value="">����</option>                      
                    <option value="0" <%if(fee_etc.getRtn_run_amt_yn().equals("0")||fee_etc.getRtn_run_amt_yn().equals(""))%>selected<%%>>ȯ�޴뿩������</option>
                    <option value="1" <%if(fee_etc.getRtn_run_amt_yn().equals("1"))%>selected<%%>>ȯ�޴뿩�������</option>                    
                  </select>
                  <%	}else{ %>
                  <%		if(fee_etc.getRtn_run_amt_yn().equals("")){
                	  			fee_etc.setRtn_run_amt_yn("0");
                  			} 
                  %>
                  <%if(fee_etc.getRtn_run_amt_yn().equals("0")){%>��ȯ�޴뿩������<%}else if(fee_etc.getRtn_run_amt_yn().equals("1")){%>��ȯ�޴뿩�������<%} %>
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etc.getRtn_run_amt_yn()%>">
                  <%	} %>
                  <%}else{ %>
                  <input type="hidden" name="rtn_run_amt" value="<%=fee_etc.getRtn_run_amt()%>">
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etc.getRtn_run_amt_yn()%>">
                  <%} %>    
                  <br>&nbsp;              
                  (�����ʰ������) �ʰ�����뿩�� <input type='text' name='over_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��/1km (�ΰ�������)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  ���Կɼ� ���� ȯ�޴뿩�� : �⺻���� ������, �Ϲݽ��� 40%�� ����
                  <%} %>
                  <br>&nbsp;                  
                  ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>�� ����
                  <!-- 
                  �ʰ� 1km�� (<input type='text' name='over_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��)�� �ʰ�����δ���� �ΰ��� (�뿩�����)	
                  <br>&nbsp;
                  ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� 50%�� ����
                   -->
                  <input type="hidden" name="agree_dist_yn" value="<%=fee_etc.getAgree_dist_yn()%>">
                  <!--      
                  <select name='agree_dist_yn'>        
                    <option value=""  <%if(fee_etc.getAgree_dist_yn().equals(""))%>selected<%%>>����</option>                      
                    <option value="1" <%if(fee_etc.getAgree_dist_yn().equals("1"))%>selected<%%>>���׸���(�⺻��)</option>
                    <option value="2" <%if(fee_etc.getAgree_dist_yn().equals("2"))%>selected<%%>>50%�� ����(�Ϲݽ�)</option>
                    <option value="3" <%if(fee_etc.getAgree_dist_yn().equals("3"))%>selected<%%>>���Կɼ� ����(�⺻��,�Ϲݽ�)</option>
                  </select>	
                  -->
                  <!--    
                  <br>&nbsp;
                  �� ��������Ÿ� ������� ��������Ÿ��� <input type='text' name='ex_agree_dist' size='5' class='defaultnum' value='������' >�� ���� �Է��ϸ� �˴ϴ�.
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        �� ���� ����Ÿ� <input type='text' name='cust_est_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getCust_est_km())%>' >
                        km/1��
                   -->     
                </td>
                <td align='center'>
                  <%if(AddUtil.parseInt(fees.getRent_dt()) > 20130604){
                  	
                  	String e_agree_dist_yn = "���Կɼ� ����(�⺻��,�Ϲݽ�)";
                  	if(e_bean.getOpt_chk().equals("1")){
                  		if(e_bean.getA_a().equals("12") || e_bean.getA_a().equals("22")){
                  			e_agree_dist_yn = "���׸���(�⺻��)";
                  		}else{
							if(AddUtil.parseInt(base.getRent_dt()) > 20220414){
								e_agree_dist_yn = "40%������(�Ϲݽ�)";
							}else{
								e_agree_dist_yn = "50%������(�Ϲݽ�)";
							}                  			
                  		}
                  	}
                  %>
                    <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                    <input type='text' name='e_rtn_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>' >/1km,<br>&nbsp;
                    <%}else{ %>
                  	<input type="hidden" name="e_rtn_run_amt" value="<%=e_bean.getRtn_run_amt()%>">
                  	<%} %> 
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,<br>&nbsp;
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>
              </tr>   
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">����������Ÿ�</td>
                    <%if (fees.getRent_st().equals("1") && base.getCar_gu().equals("0")) {%>
                    <td colspan="4">&nbsp;
                        <input type='text' name='over_bas_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%>' >
                        km
                        (�縮�� ������ �뿩���� ����Ÿ�, ��༭ ���� ��)
                    </td>
                    <td colspan="2" align="center">
                    	�� �縮�� ������ �̵� :&nbsp;
                    	���&nbsp;
                    	<select name="br_from_st" class="default">
                    		<option value="" <%if (fee_etc.getBr_from_st().equals("")) {%>selected<%}%>>����</option>
                    		<option value="9" <%if (fee_etc.getBr_from_st().equals("9")) {%>selected<%}%>>�������̵�����</option>
                    		<option value="0" <%if (fee_etc.getBr_from_st().equals("0")) {%>selected<%}%>>����</option>
                    		<option value="1" <%if (fee_etc.getBr_from_st().equals("1")) {%>selected<%}%>>����</option>
                    		<option value="2" <%if (fee_etc.getBr_from_st().equals("2")) {%>selected<%}%>>�뱸</option>
                    		<option value="3" <%if (fee_etc.getBr_from_st().equals("3")) {%>selected<%}%>>����</option>
                    		<option value="4" <%if (fee_etc.getBr_from_st().equals("4")) {%>selected<%}%>>�λ�</option>
                    	</select>
                    	&nbsp;&nbsp;
                    	����&nbsp;
                    	<select name="br_to_st" class="default">
                    		<option value="" <%if (fee_etc.getBr_to_st().equals("")) {%>selected<%}%>>����</option>
                    		<option value="9" <%if (fee_etc.getBr_to_st().equals("9")) {%>selected<%}%>>�������̵�����</option>
                    		<option value="0" <%if (fee_etc.getBr_to_st().equals("0")) {%>selected<%}%>>����</option>
                    		<option value="1" <%if (fee_etc.getBr_to_st().equals("1")) {%>selected<%}%>>����</option>
                    		<option value="2" <%if (fee_etc.getBr_to_st().equals("2")) {%>selected<%}%>>�뱸</option>
                    		<option value="3" <%if (fee_etc.getBr_to_st().equals("3")) {%>selected<%}%>>����</option>
                    		<option value="4" <%if (fee_etc.getBr_to_st().equals("4")) {%>selected<%}%>>�λ�</option>
                    	</select>
                    </td>
                    <%} else {%>
                    <td colspan="6">&nbsp;
                        <input type='text' name='over_bas_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%>' >
                        km
                        (�縮�� ������ �뿩���� ����Ÿ�, ��༭ ���� ��)
                    </td>
                    <%}%>
                </tr>	                         
                <tr>
                    <td rowspan="4" class='title'>��<br>
                      ��</td>
                    <td class='title' colspan="2">ǥ�� �ִ��ܰ�</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='b_max_ja' maxlength='10' class='fixnum' value='<%=fees.getB_max_ja()%>'>
        			  % </td>
                    <td align='center'>                        
                        <input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' >km/1��                        
                    </td>
                </tr>                
                <tr>
                    <td class='title' colspan="2">���� �ִ��ܰ�</td>
                    <td align="center"><input type='text' size='12' name='ja_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='12' name='ja_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='12' name='ja_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='max_ja' maxlength='10' readonly class='fixnum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'>
                                  <input type='text' name='r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' >km/1��
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">���Կɼ�</td>
                    <td align="center"><input type='text' size='12' name='opt_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='12' name='opt_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='12' name='opt_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
                        <input type='text' size='4' name='opt_per' class='defaultnum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_opt_per' class='defaultnum' value='<%=fees.getF_opt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
    				            %  
        				    </td>
                    <td align='center'>
        			  <input type='radio' name="opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%> onClick="javascript:opt_display('0', <%=fees.getRent_dt()%>)">
                      ����
                      <input type='radio' name="opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%> onclick="javascript:opt_display('1', <%=fees.getRent_dt()%>)">
        	 		  ����
                    </td>
                </tr>
                <%if(fee_etc.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ���������� %>
                <tr>
                    <td class='title' colspan="2">�����ܰ�</td>
                    <td align="center"><input type='text' size='10' name='i_ja_r_s_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='i_ja_r_v_amt' readonly maxlength='10' class='whitenum' value='-' >
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='i_ja_r_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='i_app_ja' maxlength='10' readonly class="whitenum" value='-'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <input type="hidden" name="ja_r_s_amt" value='<%=fees.getJa_r_s_amt()%>'>
                <input type="hidden" name="ja_r_v_amt" value='<%=fees.getJa_r_v_amt()%>'>
                <input type="hidden" name="ja_r_amt" value='<%=fees.getJa_r_s_amt()+fees.getJa_r_v_amt()%>'>
                <input type="hidden" name="app_ja" value='<%=fees.getApp_ja()%>'>
                <%}else{%>
                <tr>
                    <td class='title' colspan="2">�����ܰ�</td>
                    <td align="center"><input type='text' size='12' name='ja_r_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='12' name='ja_r_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='12' name='ja_r_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="defaultnum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>��<br>��<br>��</td>
                    <td class='title' colspan="2">�����</td>
                    <td align="center" ><input type='text' size='12'  name='fee_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='12'  name='fee_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='12'  name='fee_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>
					���뿩�ᳳ�Թ�� :
					  <select name='fee_chk'>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getFee_chk().equals("0"))%>selected<%%>>�ſ�����</option>
                              <option value="1" <%if(fees.getFee_chk().equals("1"))%>selected<%%>>�Ͻÿϳ�</option>
                            </select>	
					</td>
                </tr>
                <!-- �������߰����/�������(���Ǻ���) ���� (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">��<br>��<br>��<br>��<br>��</td>
                    <td class='title'>������</td>
                    <td align="center" ><input type='text' size='12' name='inv_s_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='12' name='inv_v_amt' readonly maxlength='9' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='12' maxlength='10' readonly name='inv_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">
                    	<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4"))){//������,������%>
                    	<input type="hidden" name="ecar_pur_sub_yn" value="N"> 
                    	<%}%>
                    	
                    	<%EstimateBean esti = e_db.getEstimateCase(fee_etc.getBc_est_id()); 	%>
                    	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
                            <%if((now_stat.equals("���°�") || now_stat.equals("��������")) && !fees.getRent_dt().equals(String.valueOf(begin.get("CLS_DT")))){%>
                            �� ���°��̰ų� ���������� ������� �ʽ��ϴ�.
                            <%}else{%>
                            	<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id) || nm_db.getWorkAuthUser("���翵������",user_id) || nm_db.getWorkAuthUser("���翵��������",user_id)){%>
                            	<%	if(base.getCar_gu().equals("1") && !base.getDlv_dt().equals("") && fees.getRent_st().equals("1")){%>
                            	<input type="checkbox" name="bc_dlv_yn" value="Y" <%if(fee_etc.getBc_dlv_yn().equals("Y")){%> checked <%}%> >������ڱ���
                            	<%	}else if(base.getCar_gu().equals("1") && fees.getRent_st().equals("1")){%>
                            	<!-- �� ���������� <input type="text" name="est_rent_dt" value="<%=esti.getRent_dt()%>" size="12" class=text>
                            	 -->
                            	 <input type='hidden' name="est_rent_dt" value="">
                            	<%	} %>
                            	<%}%>
                            <%}%>
		                <%}%>	
                    </td>
                    <td align='center'>&nbsp;
                        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
                            <%if((now_stat.equals("���°�") || now_stat.equals("��������")) && !fees.getRent_dt().equals(String.valueOf(begin.get("CLS_DT")))){%>

                            <%}else{%>
        			              <span class="b"><a href="javascript:estimate('<%=fees.getRent_st()%>', '<%=fees.getRent_dt()%>', '<%=fees.getRent_start_dt()%>', 'account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>	
                            <%}%>
					                  
		                    <%if(!esti.getReg_code().equals("")){%>
					              &nbsp;&nbsp;
        			              <span class="b"><a href="javascript:estimates_view('<%=fees.getRent_st()%>', '<%=esti.getReg_code()%>')" onMouseOver="window.status=''; return true" title="������� ����"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>					                  
					        <%}%>
			            <%}%>		  
                    </td>
                </tr>
                <tr>
                    <td class='title'>�������(���Ǻ���)</td>
                    <td align="center" ><input type='text' size='12'  name='ins_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='12'  name='ins_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='12'  name='ins_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">&nbsp;�������(���ް�) = �Ⱓ�����
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 ��/12</td>
                    <td align='center'>�ڵ������� ���� Ư�� ������ &nbsp;&nbsp;&nbsp;&nbsp;
                    	<a href="javascript:reqdoc('<%=fees.getRent_l_cd()%>','<%=fees.getRent_mng_id()%>','<%=fees.getRent_st()%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    </td>
                </tr>
                <tr>
	                <td class='title'>�������߰����</td>
	                <td align='center' >
	                	<input type='text' size='12' name='driver_add_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> �� 
	                </td>
	                <td align="center" >
	                	<input type='text' size='12' name='driver_add_v_amt'  maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center' >
	                	<input type='text' size='12' maxlength='10'  name='driver_add_total_amt' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	            </tr>
	            <tr>
                    <td class='title'>������ �հ�</td>
                    <td align='center' >
                    	<input type='text' size='12' name='tinv_s_amt' maxlength='11' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etc.getDriver_add_amt())%>'> �� 
                    </td>
                    <td align="center" >
                       	<input type='text' size='12' name='tinv_v_amt'  maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center' >
                    	<input type='text' size='12' maxlength='10'  name='tinv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
                   
        		<tr>
	                <td class='title' colspan="2">�뿩��DC</td>
	                <td colspan='3'>&nbsp;
	                    ������ : 
	                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etc.getDc_ra_sac_id(), "USER")%>" size="12"> 
				<input type="hidden" name="dc_ra_sac_id" value="<%=fee_etc.getDc_ra_sac_id()%>">
				<a href="javascript:User_search('dc_ra_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
				<% user_idx++;%>
			    &nbsp;&nbsp;&nbsp;&nbsp;
			    �������� : 	
			    <input type='text' size='12' name='bas_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
	                
	                </td>                    
	                <td align='center'>-</td>            
	                <td align="center">
	                    ����ٰ� : <select name='dc_ra_st'>
	                        <option value=''>����</option>
	                        <option value='1' <%if(fee_etc.getDc_ra_st().equals("1")){%>selected<%}%>>����DC����</option>
	                        <option value='2' <%if(fee_etc.getDc_ra_st().equals("2")){%>selected<%}%>>Ư��DC</option>
	                    </select>
	                    &nbsp;
			    ��Ÿ : 
			    <input type='text' size='18' name='dc_ra_etc' class="text" value='<%=fee_etc.getDc_ra_etc()%>'>
	                </td>
	                <td align='center'>
	                    DC�� <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fees.getDc_ra()%>'>%
                    DC�ݾ� <input type='text' size='6' name='dc_ra_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()+fees.getIns_s_amt()+fees.getIns_v_amt()+fee_etc.getDriver_add_amt()+fee_etc.getDriver_add_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>'>
	        				  ��
	                </td>
              </tr>                    
				<%		int fee_etc_rowspan = 1;
				    	if(fees.getRent_st().equals("1")) fee_etc_rowspan = fee_etc_rowspan+2;//��������϶� ���������
				    	//�������߰�����߰�
		    			//fee_etc_rowspan++;
				%>
       
                <tr>
                    <td rowspan="<%=fee_etc_rowspan%>" class='title'>��<br>
                      Ÿ</td>                     
                    <td class='title' colspan="2" style="font-size : 8pt;">�ߵ�����������</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">�ܿ��Ⱓ �뿩����
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fees.getCls_per()%>'>%
						,�ʿ��������[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                </tr>	
				      <%if(fees.getRent_st().equals("1")){%>
                <tr>
                    <td class='title' colspan="2">��������</td>
                    <td colspan="2" align="center">
        			  �������:
        			  <select name='commi_car_st'>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>��������</option>
                      </select>
        			</td>
                    <td align='center'><input type='text' size='12' name='commi_car_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' <%if(!doc.getDoc_step().equals("3")){%>onBlur="javascript:setCommi()"<%}%>>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">
                        <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> <%if(!doc.getDoc_step().equals("3")){%>class='defaultnum' onBlur='javascript:setCommi()'<%}else{%>class='fixnum' readonly<%}%>>  
        		      %</td>
                    <td align='center'>
        				        <input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='fixnum' <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%><%}else{%>readonly<%}%>>
        			  %</td>
                </tr>
                <%}%>
                
				<%if(fees.getRent_st().equals("1")){
					//�������������
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}  
					%>                                  
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">���������</td>
                    <td colspan="6">&nbsp;
					  <b>[���������]</b>
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;����ȣ : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='grt_suc_c_no' size='12' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;�����ڵ庰���� ���� : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <span class="b"><a href="javascript:cancel_grt_suc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[���������ݽ°�]</b>
					  &nbsp;���������� : <input type='text' name='grt_suc_o_amt' size='12' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  �°躸���� : <input type='text' name='grt_suc_r_amt' size='12' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum'  onBlur="javascript:document.form1.grt_suc_cha_amt.value=parseDecimal(toInt(parseDigit(document.form1.grt_suc_o_amt.value))-toInt(parseDigit(document.form1.grt_suc_r_amt.value)));">��
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(���������� ���� <input type='text' name='grt_suc_cha_amt' size='10' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>' class='whitenum'>)</font>
					  <%}else{ %>
					  <input type='hidden' name='grt_suc_cha_amt' 	value=''>
					  <%} %>					  	
        			</td>
                </tr>						
				<%}else{%>	
				<input type='hidden' name='commi_car_st' 	value='<%=emp1.getCommi_car_st()%>'>							
				<input type='hidden' name='commi_car_amt' 	value='<%=emp1.getCommi_car_amt()%>'>							
				<input type='hidden' name='comm_r_rt' 		value='<%=emp1.getComm_r_rt()%>'>							
				<input type='hidden' name='comm_rt' 		value='<%=emp1.getComm_rt()%>'>							
				<%}%>
				<input type='hidden' name='commi' 		value='<%=emp1.getCommi()%>'>							
			  <input type='hidden' name='bus_agnt_r_per' 	value='<%=fee_etc.getBus_agnt_r_per()%>'>
			  <input type='hidden' name='bus_agnt_per' 	value='<%=fee_etc.getBus_agnt_per()%>'>
			  <input type='hidden' name='cls_n_mon' 	value='<%=fee_etc.getCls_n_mon()%>'>
			  <input type='hidden' name='cls_n_amt' 	value='<%=fee_etc.getCls_n_amt()%>'>			 
			  <input type='hidden' name='over_serv_amt' 	value='<%=fee_etc.getOver_serv_amt()%>'>
			  <input type='hidden' name='over_run_day' 		value='<%=fee_etc.getOver_run_day()%>'>              				
			  <input type="hidden" name="fee_sac_id" value="<%=fees.getFee_sac_id()%>">				
			          <%if(ej_bean.getJg_g_7().equals("3")){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ���������� %>
                <tr>
                    <td colspan="3" class='title'>������ �μ�/�ݳ� ����</td>
                    <td colspan="6">&nbsp;
                    	<select name='return_select'>
                        <option value=''>����</option>
                        <option value='0' <%if(fee_etc.getReturn_select().equals("0")){%>selected<%}%>>�μ�/�ݳ� ������</option>
                        <option value='1' <%if(fee_etc.getReturn_select().equals("1")){%>selected<%}%>>�ݳ���</option>
                    	</select>
                    </td>
                </tr>		
                <%}%>
                <tr>
                    <td colspan="3" class='title'>��༭ Ư����� ���� ����</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
		                      	<textarea rows='5' cols='90' name='con_etc' ><%=fee_etc.getCon_etc()%></textarea>                      
                    		</div>
                   		</div>
                      	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
					  		<div style="display: table-cell; vertical-align: middle;">
	                      	<%-- <%if (base.getCar_gu().equals("1") && base.getCar_mng_id().equals("") && fee_etc.getCon_etc().indexOf("�����Һ� �ѽ��� ����(2020.3~6��) ���� ����") == -1 && AddUtil.parseInt(AddUtil.getDate(4)) < 20210115) {//���Ҽ� �ѽ��� ���� �Ⱓ %> --%>
	                      	<%if (base.getCar_gu().equals("1") && base.getCar_mng_id().equals("") && AddUtil.parseInt(AddUtil.getDate(4)) < 20210101) {//���Ҽ� �ѽ��� ���� �Ⱓ %>
		                      	<!-- <input type="button" onclick="setMentConEtc('0')" value="�����Һ� �λ�ݾ� �ȳ�����"> -->
		                      	<%if (ej_bean.getJg_3() > 0) {%>
						  		<!-- <input type="button" onclick="setMentConEtc('1')" value="�����Һ��� ȯ���� �ȳ�����">&nbsp; -->
								<%}%>
								<%if (ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")) {%>
						  		<input type="button" onclick="setMentConEtc('2')" value="���̺긮�� ��漼 ����������� �ȳ�����">
								<%}%>
								<%if (ej_bean.getJg_3() > 0 && (ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2"))) {%>
						  		<!-- <br><br>
						  		<input type="button" onclick="setMentConEtc('3')" value="�����Һ��� ȯ�� �� ���̺긮�� ��漼 ����������� �ȳ�����"> -->
								<%}%>
						  	<%}%>
						  	<%if(base.getCar_gu().equals("0")){%>
								<input type="button" onclick="setMentConEtc('4')" value="�縮�� ǰ������ �ȳ�����">
							<%}%>
		                	<%-- <%if( ej_bean.getJg_3() > 0 && (
					  					cm_bean.getJg_code().equals("4022311") || cm_bean.getJg_code().equals("4022312") || cm_bean.getJg_code().equals("4022313") || cm_bean.getJg_code().equals("4022314")
					  					 || cm_bean.getJg_code().equals("5014123") || cm_bean.getJg_code().equals("5018411") || cm_bean.getJg_code().equals("5018412") || cm_bean.getJg_code().equals("5018413")
					  					 || cm_bean.getJg_code().equals("6022410") || cm_bean.getJg_code().equals("6022415") || cm_bean.getJg_code().equals("6022418") || cm_bean.getJg_code().equals("4217013") || cm_bean.getJg_code().equals("3516312")
					  					 || cm_bean.getJg_code().equals("4519221") || cm_bean.getJg_code().equals("4519222") || cm_bean.getJg_code().equals("4519223") || cm_bean.getJg_code().equals("5514112")
					  					 || cm_bean.getJg_code().equals("6516213") || cm_bean.getJg_code().equals("6516214") || cm_bean.getJg_code().equals("6516215") || cm_bean.getJg_code().equals("6519213") || cm_bean.getJg_code().equals("6519214")
					  					 || cm_bean.getJg_code().equals("5028511") || cm_bean.getJg_code().equals("5028512")
					  					 || cm_bean.getJg_code().equals("4016314") || cm_bean.getJg_code().equals("6012423") || cm_bean.getJg_code().equals("6012424") || cm_bean.getJg_code().equals("6012428") || cm_bean.getJg_code().equals("6012429")
				                		 || cm_bean.getJg_code().equals("6022421") || cm_bean.getJg_code().equals("6022422") || cm_bean.getJg_code().equals("6022423") || cm_bean.getJg_code().equals("6022424") || cm_bean.getJg_code().equals("6022426") || cm_bean.getJg_code().equals("6022427")
				                		 || cm_bean.getJg_code().equals("6024411") || cm_bean.getJg_code().equals("6024412") || cm_bean.getJg_code().equals("6024413") || cm_bean.getJg_code().equals("6024414") || cm_bean.getJg_code().equals("6024415")
				                		 || cm_bean.getJg_code().equals("5028513") || cm_bean.getJg_code().equals("5018414") || cm_bean.getJg_code().equals("5018415") || cm_bean.getJg_code().equals("5018416")
					  				) ){ %>
			                	<input type="button" onclick="setMentConEtc('5')" value="�����Һ��� ȯ���� �ȳ�����">
							<%}%> --%>
							  	<script>  src.indexOf(",", sp);
								function setMentConEtc(idx) {
									//document.form1.con_etc.value = '�����Һ� �ѽ��� ����Ⱓ(2020.3~6��)�� �ʰ��Ͽ� ��� �� ��� �뿩��� �λ�˴ϴ�.';
									if (idx == "0") {
										document.form1.con_etc.value = '�����Һ� �ѽ��� ���� 70% ����(2020.3~6��) �Ⱓ�� �ʰ��Ͽ�, �����Һ����� 3.5%(2020.7~12��)�� �����Ǿ� ���� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�.';
									}
									if (idx == "1") {
										document.form1.con_etc.value = "�� 2021��1��1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�.";
									}
									if (idx == "2") {
										document.form1.con_etc.value = "�� 2021��1��1�� ���� ������ ���Ǹ� ���̺긮�� �ڵ��� ��漼 ���� ���� ��ҿ� ���� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�.";
									}
									if (idx == "3") {
										document.form1.con_etc.value = "�� 2021��1��1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�. �� 2021��1��1�� ���� ������ ���Ǹ� ���̺긮�� �ڵ��� ��漼 ���� ���� ��ҿ� ���� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�.";
									}
									if (idx == "4") {
										document.form1.con_etc.value = "�� ����, ���ӱ� : 2����/5,000Km ǰ������ (�Ⱓ �Ǵ� ����Ÿ� �� ���� ������ ���� �����Ⱓ ����� ����)";
									}
									if (idx == "5") {
										document.form1.con_etc.value = "�� 2022�� 1�� 1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�.";
									} 
								}
							  	</script>
					  		</div>
				  		</div>
                    </td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                    			<textarea rows='5' cols='90' name='fee_cdt'><%=fees.getFee_cdt()%></textarea>
                    		</div>
                   		</div>
                    </td>
                </tr>		
                <%if(fee_etc.getRent_st().equals("1")){%>	    
                <tr>
                    <td colspan="3" class='title'>���<br>(���� ����)</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                    			<textarea rows='5' cols='90' name='cls_etc'><%=cont_etc.getCls_etc()%></textarea>
                    		</div>
                   		</div>
                    </td>
                </tr>
                <%}%>
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>����Ƚ��</td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='fee_pay_tm' value='<%=fees.getFee_pay_tm()%>' maxlength='2' class='text' >
        				ȸ </td>
                    <td width="10%" class='title'>��������</td>
                    <td width="20%">&nbsp;�ſ�
                      <select name='fee_est_day'>
                        <option value="">����</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                        <option value='<%=i%>' <%if(fees.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                        <% } %>
                        <option value='99' <%if(fees.getFee_est_day().equals("99")){%> selected <%}%>> ���� </option>
						<option value='98' <%if(fees.getFee_est_day().equals("98")){%> selected <%}%>> �뿩������ </option>
                      </select></td>
                    <td width="10%" class='title'>���ԱⰣ</td>
                    <td>&nbsp;
                      <input type='text' name='fee_pay_start_dt' maxlength='10' size='12' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  <input type='text' name='fee_pay_end_dt' maxlength='10' size='12' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		
            </table>				  				
	    </td>
    </tr>			

	<%if(acar_de.equals("1000")){ %>
	<input type='hidden' name="bc_s_a"	value="<%=fee_etc.getBc_s_a()%>">
	<input type='hidden' name="bc_b_e1"	value="<%=fee_etc.getBc_b_e1()%>">
	<input type='hidden' name="bc_b_e2"	value="<%=fee_etc.getBc_b_e2()%>">
	<input type='hidden' name="bc_b_u"	value="<%=fee_etc.getBc_b_u()%>">
	<input type='hidden' name="bc_b_g"	value="<%=fee_etc.getBc_b_g()%>">
	<input type='hidden' name="bc_b_ac"	value="<%=fee_etc.getBc_b_ac()%>">
	<input type='hidden' name="bc_etc"	value="<%=fee_etc.getBc_etc()%>">
	<input type='hidden' name="bc_b_t"	value="<%=fee_etc.getBc_b_t()%>">
	<input type='hidden' name="bc_b_u_cont"	value="<%=fee_etc.getBc_b_u_cont()%>">
	<input type='hidden' name="bc_b_g_cont"	value="<%=fee_etc.getBc_b_g_cont()%>">
	<input type='hidden' name="bc_b_ac_cont" value="<%=fee_etc.getBc_b_ac_cont()%>">
	<%}else{ %>	
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
            				<input type='hidden' name='bc_s_a' 	value='<%=fee_etc.getBc_s_a()%>'>
            		        <tr>
            				    <td align="center">E-1</td>
            				    <td align="center">bc_b_e1</td>				  
            				    <td>&nbsp;�������󰡴�����簡ġ����¼��ǱⰣ�ݿ���</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e1' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;����忹��������</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e2' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;��Ÿ���</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='num' value='<%=fee_etc.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='bc_b_u_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_u_cont()%>'>
            				  </td>
            				</tr>							
            		        <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;��Ÿ����</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='num' value='<%=fee_etc.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='bc_b_g_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_g_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;��Ÿ ����ȿ���ݿ���</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='num' value='<%=fee_etc.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='bc_b_ac_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_ac_cont()%>'></td>
            				</tr>
            		        <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_etc</td>				  
            				  <td>&nbsp;�������ǻ���</td>
            				  <td align="center"><textarea rows='5' cols='70' name='bc_etc'><%=fee_etc.getBc_etc()%></textarea></td>
            				</tr>
            		        <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_b_t</td>				  
            				  <td>&nbsp;��ǰ���</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_t' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getBc_b_t())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
    </tr>	
    <%} %>
    	
    <% int u_chk = 0;%>
    
    <%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�") && !String.valueOf(begin.get("CLS_ST")).equals("��������")){%>
    
	    <%if(base.getCar_gu().equals("1") && pur.getOne_self().equals("")){ u_chk++;%>
			<tr>
	  	  <td><font color=red>������� �����ϴ�.</font></td>
			<tr>	
  	  <%}%>	
    	<%if(car.getPurc_gu().equals("")){ u_chk++;%>
			<tr>
		    <td><font color=red>���������� �����ϴ�.</font></td>
			<tr>
			<%}%>
  	  <%if(base.getDriving_age().equals("")){ u_chk++;%>
			<tr>
		    <td><font color=red>�����ڿ����� �����ϴ�.</font></td>
			<tr>
			<%}%>
			
		<%}%>
		
    <%if(ck_acar_id.equals("000029") || u_chk==0){%>
		<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||   auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('12')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
		<tr>	
		<%}%>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	var fm = document.form1;
	
  <%if(fee_opt_amt>0){//������� ���Կɼ��� �ִ� ���%>
	fm.fee_opt_amt.value = <%=fee_opt_amt%>;
  <%}%>
  
	<%if(!base.getCar_st().equals("2")){%>
	sum_pp_amt();
	<%}%>

//-->
</script>
</body>
</html>
