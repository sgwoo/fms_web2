<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_office.*, card.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�ڵ����⺻����-�⺻����
	CarMstBean cm_bean2 = new CarMstBean();
	if(!cm_bean.getCar_b_inc_id().equals("")){
		cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	}
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
		
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//���뺸��������
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	//������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//�����������
	CarOffBean co_bean = new CarOffBean();
	if(!emp2.getCar_off_id().equals("")){
		co_bean = cod.getCarOffBean(emp2.getCar_off_id());
	}
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);
	
	//�����縮��Ʈ
	CodeBean[] banks2 = c_db.getCodeAll("0003");
	int bank_size2 = banks2.length;	
		
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();		
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
  	//������ ���ּ���
  	CodeBean[] code34 = c_db.getCodeAll3("0034");
  	int code34_size = code34.length;	
	
  	//������ ���ּ���
  	CodeBean[] code37 = c_db.getCodeAll3("0037");
  	int code37_size = code37.length;	
  
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
	
	String o_3 		= edb.getEstiSikVarCase("1", "", "o_3");
	
	String print_car_st_yn = "";
	Hashtable tax_print_car = al_db.getTaxPrintCarStChk(base.getClient_id());
	if(AddUtil.parseInt(String.valueOf(tax_print_car.get("TOT_CNT")))>1 && !client.getPrint_car_st().equals("1") && !client.getPrint_st().equals("1") &&
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409") 
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
	 ){//'100','101','601','602','701','702','801','802','803','811','812'	
	 	print_car_st_yn = "Y";
	 }
	 
	//�⺻DC ��������
	String car_d_dt = "";	
	car_d_dt = edb.getDc_b_dt(cm_bean.getCar_comp_id()+""+cm_bean.getCode(), "dc", base.getRent_dt(), cm_bean.getCar_b_dt());
	CarDcBean cd_bean = cmb.getCarDcBaseCase(cm_bean.getCar_comp_id(), cm_bean.getCode(), car_d_dt, cm_bean.getCar_b_dt());	
	
	//�̸���ȸ
	int user_idx = 0;

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--	
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;	
	}
	
	//�� ����
	function view_client()
	{
		var fm = document.form1;
		window.open("/agent/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step3.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		

	
	//���/����: �������� �Է½� �ڵ�������� ����..
	function enter_car(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_car_amt(obj);
	}	
	//���/����: ���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_car_amt(obj)
	{
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.car_cs_amt){ 		//�����⺻���� ���ް�
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) * 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cs_amt){ 	//���û��� ���ް�
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) * 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cs_amt){ 	//���� ���ް�
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) * 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cs_amt){ 	//Ź�۷� ���ް�
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) * 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cs_amt){ 	//����DC ���ް�
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) * 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));			
		}else if(obj==fm.car_fs_amt){ 	//�鼼�������� ���ް�
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) * 0.1 );
			fm.car_f_amt.value	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));			
		}else if(obj==fm.tax_dc_s_amt){ 	//ģȯ���� ���Ҽ� ����� ���ް�
			fm.tax_dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) * 0.1 );
			fm.tax_dc_amt.value		= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));			
		}

		else if(obj==fm.car_cv_amt){ 	//�����⺻���� �ΰ���
			fm.car_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) / 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cv_amt){ 	//���û��� �ΰ���
			fm.opt_cs_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cv_amt.value)) / 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cv_amt){ 	//���� �ΰ���
			fm.col_cs_amt.value = parseDecimal(toInt(parseDigit(fm.col_cv_amt.value)) / 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cv_amt){ 	//Ź�۷� �ΰ���
			fm.sd_cs_amt.value = parseDecimal(toInt(parseDigit(fm.sd_cv_amt.value)) / 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cv_amt){ 	//����DC �ΰ���
			fm.dc_cs_amt.value = parseDecimal(toInt(parseDigit(fm.dc_cv_amt.value)) / 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));
		}else if(obj==fm.car_fv_amt){ 	//�鼼�������� �ΰ���
			fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) / 0.1 );
			fm.car_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
		}else if(obj==fm.tax_dc_v_amt){ 	//ģȯ���� ���Ҽ� ����� �ΰ���
			fm.tax_dc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_v_amt.value)) / 0.1 );
			fm.tax_dc_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));
		}

		else if(obj==fm.car_c_amt){ 	//�����⺻���� �հ�
			fm.car_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_cs_amt.value)));			
		}else if(obj==fm.opt_c_amt){ 	//���û��� �հ�
			fm.opt_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.opt_cs_amt.value)));			
		}else if(obj==fm.col_c_amt){ 	//���� �հ�
			fm.col_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.col_cs_amt.value)));			
		}else if(obj==fm.sd_c_amt){ 	//Ź�۷� �հ�
			fm.sd_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.sd_cs_amt.value)));			
		}else if(obj==fm.dc_c_amt){ 	//����DC �հ�
			fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));			
		}else if(obj==fm.car_f_amt){ 	//�鼼�������� �հ�
			fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_fs_amt.value)));			
		}else if(obj==fm.tax_dc_amt){ 	//ģȯ���� ���Ҽ� ����� �հ�
			fm.tax_dc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.tax_dc_v_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));			
		}
		
		sum_tax_amt();
		sum_car_c_amt();
		sum_car_f_amt();
		
	}

	//���� Ư�Ҽ� �ڵ����
	function set_tax_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.spe_tax){ 	//Ư�Ҽ�
			fm.edu_tax.value = parseDecimal(toInt(parseDigit(obj.value))*(30/100));		
		}
		fm.tot_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );					
	}

	//��������� �ڵ����
	function set_gi_amt(){
		var fm = document.form1;
		sum_pp_amt();		
	}

	//���� Ư�Ҽ� �հ�
	function sum_tax_amt(){
		var fm = document.form1;
		
		if(toInt(parseDigit(fm.spe_tax.value)) >  0){	return; }
		
		if(toInt(parseDigit(fm.car_f_amt.value)) == 0){	sum_car_f_amt(); }
		
		var purc_gu 		= fm.purc_gu.value;		
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_c_price = setCarPrice('car_c_price');
		var car_f_price = setCarPrice('car_f_price');
		var a_e 	= toInt(s_st);
		var o_1 	= car_c_price;
		setVar_o_123(car_f_price);
		if(purc_gu == '1'){//����1
			fm.spe_tax.value = parseDecimal(car_c_price-toInt(fm.v_o_3.value));
			fm.pay_st[1].selected = true;
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>' == '5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){			
				fm.tot_tax.value = parseDecimal(Math.round(toInt(fm.v_o_1.value)*toFloat(fm.v_o_2.value)));
			}else{
				fm.tot_tax.value = parseDecimal(car_c_price-toInt(parseDigit(fm.car_f_amt.value)));
			}							
			fm.pay_st[2].selected = true;
		}
		fm.spe_tax.value 	= parseDecimal(toInt(parseDigit(fm.tot_tax.value))/6.5*5);	
		fm.edu_tax.value 	= parseDecimal(toInt(parseDigit(fm.tot_tax.value)) - toInt(parseDigit(fm.spe_tax.value)) );				
	}
	
	//���� �Һ��ڰ� �հ�
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)));		
	}
	
	//���� ���԰� �հ�
	function sum_car_f_amt_b(){
		var fm = document.form1;
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );
	}
		
	//���� ���԰� �հ�
	function sum_car_f_amt(){
		var fm = document.form1;
		
		var purc_gu 		= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_price = setCarPrice('car_c_price');
		if(fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0') set_car_amt(fm.dc_c_amt);
		fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)));
		fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.tot_cv_amt.value)));
		fm.car_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_c_amt.value)));
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
      //������
			if('<%=ej_bean.getJg_w()%>'=='1'){
				fm.car_f_amt.value = parseDecimal(<%=cm_bean.getCar_b_p2()%> + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));
			}else if('<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){				
			}else{
				setVar_o_123(car_price);
				fm.car_f_amt.value  = parseDecimal(toInt(fm.v_o_3.value));
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));
			}
		}
		sum_car_f_amt_b();
		sum_tax_amt();
		
		var car_price2 = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price2);
		car_price2 = car_price2 - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));

		//ä��Ȯ��
		if(car_price2 <= 45000000)		fm.credit_per.value = '20';
		else if(car_price2 > 45000000)	fm.credit_per.value = '25';
		if(toInt(<%=cm_bean.getCar_comp_id()%>) > 6){
			fm.credit_per.value = '25';
		}else{
			fm.credit_per.value = '20';
		}
		//�������� �⺻ �����ݿ��� 10% ���ش�
   	    if('<%=ej_bean.getJg_g_7()%>' == '3'){ fm.credit_per.value = toInt(fm.credit_per.value)-10; }
		//�������� �⺻ �����ݿ��� 15% ���ش�
   	    if('<%=ej_bean.getJg_g_7()%>' == '4'){ fm.credit_per.value = toInt(fm.credit_per.value)-15; }
		var credit_per = toInt(fm.credit_per.value)/100;
		fm.credit_amt.value = parseDecimal(car_price2*credit_per);
		fm.commi_car_amt.value = parseDecimal(car_price - toInt(parseDigit(fm.tax_dc_amt.value)));
	}	
	
	//����DC
	function search_dc(){
		var fm = document.form1;
		window.open("search_dc.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&car_fs_amt="+fm.car_fs_amt.value+"&car_fv_amt="+fm.car_fv_amt.value, "COMP_DC", "left=100, top=100, height=200, width=800, scrollbars=yes, status=yes");
	}
	
	//�Ǻ�����-�� ���÷���
	function display_ip(){
		var fm = document.form1;
		var insur_per = fm.insur_per.options[fm.insur_per.selectedIndex].value;
		if(insur_per == '1'){ 				//�Ƹ���ī
			tr_ip.style.display	= 'none';
			tr_ip2.style.display	= 'none';
		}else{						//��
			tr_ip.style.display	= '';
			tr_ip2.style.display	= '';
		}		
	}	
		
	//���谡�Ի��� �ڵ�����
	function set_insur_serv(){
		var fm = document.form1;
		
		var car_b  	= replaceString(" ","",fm.car_b.value)+replaceString(" ","",fm.opt.value);
		var car_nm  	= '<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%><%=cm_bean.getCar_name()%>'

		if(car_b.indexOf("�����������") != -1)	{ fm.air_ds_yn.value 	= "Y";	}
		if(car_b.indexOf("�����������") != -1)	{ fm.air_as_yn.value 	= "Y";	}
			
		if(fm.insurant.value == '1'){
			fm.pro_yn.checked 		= true;
		}
		if(fm.insur_per.value == '2' || '<%=ej_bean.getJg_k()%>' == '0'){
			fm.ac_dae_yn.checked 		= false;
		}else{
			fm.ac_dae_yn.checked 		= true;		
		}
		<% if(fee.getRent_way().equals("1")){%>
		fm.main_yn.checked 		= true;
		fm.ma_dae_yn.checked 		= true;
		<% }%>
	}
	
	//�������� ���÷���
	function display_gi(){
		var fm = document.form1;
		if(fm.gi_st[0].checked == true){				//����
			tr_gi1.style.display		= '';
		}else{								//����
			tr_gi1.style.display		= 'none';
			fm.gi_amt.value = 0;	
			fm.gi_fee.value = 0;	
			set_fee_amt(fm.grt_s_amt);
		}		
	}	
	
	//�뿩�Ⱓ ����
	function set_cont_date(obj){
		var fm = document.form1;
		var rent_way = fm.rent_way.value;
		
		if(fm.con_mon.value == ''){
			return;
		}
					
		fm.action='/fms2/lc_rent/get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
	
	}
	
	//���/����: �������� �Է½� �ڵ�������� ����..
	function enter_fee(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_fee_amt(obj);
	}	
	//���/����: ���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_fee_amt(obj)
	{
		var fm = document.form1;	
		
		var car_price = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price);
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
				
		car_price = car_price - s_dc_amt;
		
		//������---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			sum_pp_amt();			
		}else if(obj==fm.grt_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			sum_pp_amt();		
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
			fm.pere_r_per.value = replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			sum_pp_amt();			
		}else if(obj==fm.pp_v_amt){ 	//������ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
			fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			sum_pp_amt();	
		}else if(obj==fm.pp_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));			
			fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
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
			fm.ja_r_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
		}else if(obj==fm.ja_r_s_amt){ 	//�����ܰ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_v_amt){ 	//�����ܰ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_amt){		//�����ܰ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ja_r_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
			fm.app_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_r_amt.value)) / car_price );
		//���Կɼ���---------------------------------------------------------------------------------			
		}else if(obj==fm.opt_s_amt){ 	//���Կɼ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));			
			fm.opt_per.value 		= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
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
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked = true;				
			}
		}else if(obj==fm.opt_v_amt){ 	//���Կɼ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
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
				fm.opt_chk[1].checked = true;	
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked = true;				
			}			
		}else if(obj==fm.opt_amt){ 		//���Կɼ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));			
			fm.opt_per.value 		= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
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
				fm.opt_chk[1].checked = true;	
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked = true;				
			}
		//���뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.fee_s_amt){ 	//���뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
		}else if(obj==fm.fee_v_amt){ 	//���뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value		= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.fee_amt){ 		//���뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
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
	
	//�������� ��������
	function setCarPrice(st){
		var fm = document.form1;
		var car_price = 0;
		if(st == 'car_c_price')		car_price = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));
		if(st == 'car_price2')		car_price	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		if(st == 'car_f_price')		car_price = toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		//������DC�� ����
		if(st == 'car_f_price' && <%=base.getRent_dt()%> >= 20130501 && '<%=ej_bean.getJg_w()%>'=='1'){
			car_price 	= toInt(parseDigit(fm.car_f_amt.value));
		}
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
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>' == '5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
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

	
	//������ �հ�
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );
		
		var car_price = setCarPrice('car_price2');
		var s_dc_amt 	= setDcAmt(car_price);
		
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
				
		car_price = car_price - s_dc_amt;		
        	
								
		var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
		if(pp_price>0 && car_price>0){
			fm.credit_r_per.value = parseFloatCipher3(pp_price / car_price * 100, 1);
			fm.credit_r_amt.value = parseDecimal(pp_price);
			fm.credit_amt.value = parseDecimal(car_price*toInt(fm.credit_per.value)/100);
		}
	}
	
	//����������
	function setCommi(){
		var fm = document.form1;
		
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
		
		fm.commi_car_amt.value 	= parseDecimal(car_price);
		fm.commi.value 		= parseDecimal(th_round(car_price*comm_r_rt/100));				
	}
	
	//�뿩�� DC�� ���
	function dc_fee_amt(){
		var fm = document.form1;
		
		var pp_s_amt	= toInt(parseDigit(fm.pp_s_amt.value));		//������
		var fee_s_amt	= toInt(parseDigit(fm.fee_s_amt.value));	//���뿩��(����)
		var inv_s_amt	= toInt(parseDigit(fm.inv_s_amt.value));	//����뿩��(����)
		var con_mon	= toInt(parseDigit(fm.con_mon.value));		//�뿩�Ⱓ 
		var dc_ra;
		
	}	
	
	//�����뿩�� ��� (����)
	function estimate(rent_st, st){
		var fm = document.form1;
		
		if(fm.con_mon.value == '')		{ alert('�̿�Ⱓ�� �Է��Ͻʽÿ�.');		return;}
		if(fm.driving_age.value == '')		{ alert('�����ڿ����� �����Ͻʽÿ�.');		return;}
		if(fm.gcp_kd.value == '')		{ alert('�빰����� �����Ͻʽÿ�.');		return;}
		
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.car_gu.value == '1' && fm.dir_pur_yn[0].checked == false && fm.dir_pur_yn[1].checked == false){	alert('Ư������θ� �����Ͽ� �ֽʽÿ�.'); fm.dir_pur_yn[0].focus(); return; }		
		
		// �׽��� ���� �뿩�Ⱓ ���� ����. 20210225
		<%-- if ('<%=cm_bean.getCar_comp_id()%>' == '0056') {
			if(fm.con_mon.value > 48) {
				alert('�׽��������� ��� 48���� �̻� ������ �Ұ� �մϴ�.');
				fm.con_mon.focus();
				return;
			}
		} --%>
		
		fm.fee_rent_st.value = rent_st;
		
		//������ ó��
		if(fm.car_gu.value == '1' ){
		
			var v_ch_327 = 0;
			var v_ch_315 = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value)); 
			var v_ch_326 = v_ch_315/(1+<%=ej_bean.getJg_3()%>);
			var v_bk_122 = 0;
			<%if(!ej_bean.getJg_w().equals("1")){%>
			<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
			//if('<%=ej_bean.getJg_2()%>'=='1') v_ch_326 = v_ch_315; //�Ϲݽ¿�LPG�϶�
			if('<%=ej_bean.getJg_g_7()%>'=='1') v_bk_122 = 1300000;
			if('<%=ej_bean.getJg_g_7()%>'=='2') v_bk_122 = 1300000;
			if('<%=ej_bean.getJg_g_7()%>'=='3') v_bk_122 = 3900000;
			if('<%=ej_bean.getJg_g_7()%>'=='4') v_bk_122 = 5200000;
			if(v_ch_315-v_ch_326<v_bk_122*1.1) 	v_ch_327 = v_ch_315-v_ch_326;
			else                         		v_ch_327 = v_bk_122*1.1;
			v_ch_327 = getCutRoundNumber(v_ch_327,0);
			if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111')	v_ch_327 = 0;//��ƮEV
			if('<%=cm_bean.getJg_code()%>'=='9133' || '<%=cm_bean.getJg_code()%>'=='9015435' || '<%=cm_bean.getJg_code()%>'=='9015436' || '<%=cm_bean.getJg_code()%>'=='9015437')	v_ch_327 = 0;//�����Ϸ�
			fm.tax_dc_amt.value 	= parseDecimal(v_ch_327);
			set_car_amt(fm.tax_dc_amt);
	  		<%	}%>
  			<%}%>	
  		
			//���Ҽ� �ѽ��� ���� 20200301~20200630
	  		var bk_175 = 0.7;     //������
		  	var bk_176 = 1430000; //���Ҽ� ���� �ѵ�(����������,�ΰ�������)
		  	var bk_177 = 0;
	  		<%if(!ej_bean.getJg_w().equals("1")){ //����������%>
		  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//�鼼��ǥ������ ����%>
		  	<%		}else{%>
						if(v_ch_315<33471429){
							bk_177 = v_ch_326*<%=ej_bean.getJg_3()%>*bk_175;	
						}else{
							bk_177 = bk_176;
						}	 
						bk_177 = getCutRoundNumber(bk_177,-4);
						if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='5033111')	bk_177 = 0;//��ƮEV
						//20200701 ��������
						bk_177 = 0;
		  	<%		}%>
		  	<%}%>
	  	
	    	//���� ������ �����Һ�(�����ѵ� �ʰ��ݾ�) 20210101~20210630**********************
		  	var bk_216 = 0;
		  	if(<%=base.getRent_dt()%> >= 20210101){
	  		<%if(!ej_bean.getJg_w().equals("1")){ //����������%>
		  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//�鼼��ǥ������ ����%>
		  	<%		}else{%>
						if(v_ch_315-v_ch_326>0 && (v_ch_326/1.1)>66666666){
							bk_216 = ((v_ch_326/1.1)-66666666)*0.0195*1.1;	
						}	    					
	// 					if(v_ch_315-v_ch_326>0 && v_ch_315>76669999){
	// 						bk_216 = (v_ch_315-76669999)*0.0195;	
	// 					}	    					
						bk_216 = getCutRoundNumber(bk_216,-4);		
	  		<%		}%>
		  	<%}%>
		  	}
	  	
	  		var ch327Nbk177 = ch_327;
	  	
		  	if(bk_177>0){
		  		if(v_ch_315-v_ch_326<bk_177+(bk_122*1.1)) 	ch327Nbk177 = v_ch_315-v_ch_326;
				else                         				ch327Nbk177 = bk_177+(bk_122*1.1);
	  		
		  		fm.tax_dc_amt.value 	= parseDecimal(ch327Nbk177);
				set_car_amt(fm.tax_dc_amt);
	  			
	  		}
		  	if(bk_216>0){
		  		if(v_ch_315-v_ch_326<-bk_216+(bk_122*1.1)) 	ch327Nbk177 = v_ch_315-v_ch_326;
				else                         				ch327Nbk177 = -bk_216+(bk_122*1.1);
	  		
	  			fm.tax_dc_amt.value    = parseDecimal(ch327Nbk177);			
	  			set_car_amt(fm.tax_dc_amt);
	  		}
		  	
		}  	
		
		var car_price = setCarPrice('car_price2');
		
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
		
		var s_dc_amt 	= setDcAmt(car_price);
		
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));    	
		
		fm.o_1.value 		= car_price - s_dc_amt;
		fm.t_dc_amt.value 	= s_dc_amt;
		fm.esti_stat.value 	= st;
		
		//Ư������϶� dc�̹ݿ�
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn[0].checked == true){
			fm.o_1.value 		= car_price;
			fm.t_dc_amt.value 	= 0;			
			
			if(<%=base.getRent_dt()%> >= 20130501){
				s_dc_amt = <%=cd_bean.getCar_d_p()%>;
				var s_dc_per = <%=cd_bean.getCar_d_per()%>;
				if(s_dc_per > 0){
					s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt;					
				}
				fm.o_1.value 		= car_price - s_dc_amt;
				fm.t_dc_amt.value 	= s_dc_amt;
			}
			
		}
		
		//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
		if('<%=base.getCar_st()%><%=fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('�������� ���� �����⺻�ĸ� �����մϴ�.');
				return;
			}			
		}			
						
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}



		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;	
		
		fm.action='get_fee_estimate_20090901.jsp';			

		
		<%	if(cm_bean.getJg_code().equals("")){%>
			alert("�����ܰ��ڵ尡 �����ϴ�. ������������ �Է��Ͻʽÿ�.");
			return;
		<%	}%>		
		
				<%if(ej_bean.getJg_g_7().equals("3")){//������%>
				if(fm.ecar_loc_st.value == ''){	
					alert("������ ���ּ����� �����Ͻʽÿ�.");
					return;			
				}else{
					
					//1.����, 2.����, 3.�λ�, 4.����, 5.����, 6.��õ, 7.��õ, 8.����, 9.����, 10.�뱸
					
					// ���� ����ȭ����(�����: ����) �� ��� ������ �� �ּ����� ���� ���� ��õ���� ���. 2021.02.18.
					// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� ��õ ���. 20210224
					// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� �λ� ���. 20210520
					// ���ּ����� ���� ���� ����ȭ������ �ǵ������ �뱸, ����¿����� �ǵ������ ��õ ���. 20220519
					<%if ( Integer.parseInt(cm_bean.getJg_code()) > 8000000 ) {%>
							fm.car_ext.value = '10';	// �뱸
					<%} else {%>
							fm.car_ext.value = '7';		// ��õ
					<%}%>
				}
				<%}%>
				
				<%if(ej_bean.getJg_g_7().equals("4")){//������%>
				if(fm.hcar_loc_st.value == ''){
					alert("������ ���ּ����� �����Ͻʽÿ�.");
					return;			
				}else{
					fm.car_ext.value = '1';
				}
				//��õ -> ��õ ���
				if(fm.hcar_loc_st.value == '1'){	
					fm.car_ext.value = '7';
				}
				//���� ���� -> ������ ���� ���
				if(fm.hcar_loc_st.value == '3'  && fm.car_st.value == '3'){	
					fm.car_ext.value = '5';
				}
				//����/����/���� -> ���� ���
				if(fm.hcar_loc_st.value == '4'){	
					fm.car_ext.value = '9';
				}
				//�λ�/���/�泲 -> �λ� ���
				if(fm.hcar_loc_st.value == '6'){	
					fm.car_ext.value = '3';
				}
				//20190701 �������� ��õ���
				//fm.car_ext.value = '7';
				fm.car_ext.value = '7'; //20191206 �������� ��� ��õ
				//fm.car_ext.value = '1'; //20200324 �������� ��� ��õ -> ����� ���
				<%}%>
		
		<%-- <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����-��������%>
		if(fm.eco_e_tag.value == ''){	
			alert("�������ｺƼĿ �߱�(�����ͳ� �̿� �����±�)�� �����Ͻʽÿ�.");
			return;
		}		
		/* if(fm.eco_e_tag.value == '1'){
			fm.car_ext.value = '1'; //�������ｺƼĿ �߱޽� ������
		} */
		
			<%if(ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����:��������%>
			if(fm.eco_e_tag.value == '1'){
				alert("������/�������� ���� �������ｺƼĿ �߱�(�����ͳ� �̿� �����±�)�� �Ұ��մϴ�.");
				return;
			}
			<%}else{%>
			if(fm.eco_e_tag.value == '1'){
				fm.car_ext.value = '1'; //�������ｺƼĿ �߱޽� ������
			}
			<%}%>
		
		<%}%> --%>
		
		if(fm.opt_amt.value == '0'){	
			if(!confirm('���Կɼ��� �����ϴ�. �Է��� ������ ������ Ȯ���Ͻʽÿ�. ����Ͻðڽ��ϱ�?'))  return;
		}	
		
		
		if(confirm('�������� ������� '+fm.comm_r_rt.value+'%�� �����˴ϴ�. ����Ͻðڽ��ϱ�?')){
			fm.submit();
		}
		
		dc_fee_amt();
	}
	
	//����������� ���÷���
	function display_tae(){
		var fm = document.form1;
		if(fm.prv_dlv_yn[0].checked == true){			//����
			tr_tae2.style.display		= 'none';
		}else{							//�ִ�
			tr_tae2.style.display		= '';
		}		
	}		

	//��������� ��ȸ
	function car_search(st)
	{
		var fm = document.form1;
		window.open("search_res_car.jsp?taecha=Y&client_id=<%=base.getClient_id()%>", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");
	}	
	
	//�����Ҵ���� ��ȸ
	function search_emp(st){		
		var fm = document.form1;		
		var one_self = "N";		
		var pur_bus_st = "4";
		if(fm.one_self[0].checked == true) one_self = "Y";		
		window.open("search_emp.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self="+one_self+"&pur_bus_st="+pur_bus_st+"&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");	
	}
	
	//�����Ҵ���� �Է����
	function cancel_emp(st){
		var fm = document.form1;
		if(st == 'BUS'){
			fm.emp_nm[0].value = '';
			fm.emp_id[0].value = '';
			fm.car_off_nm[0].value = '';
			fm.car_off_id[0].value = '';
			fm.car_off_st[0].value = '';
			fm.cust_st.value = '';
			fm.comm_rt.value = '';
			fm.comm_r_rt.value = '';
			fm.ch_remark.value = '';
			fm.ch_sac_id.value = '';
			fm.emp_bank.value = '';
			fm.emp_bank_cd.value = '';
			fm.emp_acc_no.value = '';
			fm.emp_acc_nm.value = '';
		}else{
			fm.emp_nm[1].value = '';
			fm.emp_id[1].value = '';
			fm.car_off_nm[1].value = '';
			fm.car_off_id[1].value = '';
			fm.car_off_st[1].value = '';
		}		
	}
	//��� �����Ҵ���ڸ� ���� �����Ҵ���� ��ó��
	function set_emp_sam(){
		var fm = document.form1;
		if(fm.emp_chk.checked == true){			
			fm.emp_nm[1].value = fm.emp_nm[0].value;
			fm.emp_id[1].value = fm.emp_id[0].value;
			fm.car_off_nm[1].value = fm.car_off_nm[0].value;
			fm.car_off_st[1].value = fm.car_off_st[0].value;		
		}else{
			cancel_emp('DLV');
		}
	}
	
	// ÷�ܾ�����ġ ������ ���Ƴ��� ���¿��� ����� ���� �� ÷�ܾ�����ġ select box ��Ȱ��ȭ ���� ����	2018.01.24
	function before_submit(){
		$("#lkas_yn").prop("disabled", false);
		$("#ldws_yn").prop("disabled", false);
		$("#aeb_yn").prop("disabled", false);
		$("#fcw_yn").prop("disabled", false);
		$("#hook_yn").prop("disabled", false);
		$("#ev_yn").prop("disabled", false);
		$("#legal_yn").prop("disabled", false);
	}
	
	//���
	function save(){
		var fm = document.form1;
		
		if(fm.color.value == '')				{ alert('�뿩����-������ �Է��Ͻʽÿ�.'); 				fm.color.focus(); 		return; }
		if(fm.car_gu.value == '1'){//����
				if(fm.in_col.value == ''){ alert('�뿩����-��������� �Է��Ͻʽÿ�.');fm.in_col.focus();return; }	
		}
		if(fm.car_ext.value == '')				{ alert('�뿩����-��������� �Է��Ͻʽÿ�.'); 				fm.car_ext.focus(); 		return; }
		
				<%if(ej_bean.getJg_g_7().equals("3")){//������%>
					if(fm.ecar_loc_st.value == ''){	
						alert("������ ���ּ����� �����Ͻʽÿ�.");
						return;			
					}else{
						
						//1.����, 2.����, 3.�λ�, 4.����, 5.����, 6.��õ, 7.��õ, 8.����, 9.����, 10.�뱸
						
						// ���� ����ȭ����(�����: ����) �� ��� ������ �� �ּ����� ���� ���� ��õ���� ���. 2021.02.18.
						// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� ��õ ���. 20210224
						// ���ּ����� ���� ���� ����ȭ������ �ǵ������ �뱸, ����¿����� �ǵ������ ��õ ���. 20220519
						<% if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435") || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%>
	// 						fm.car_ext.value = '7'; // ����ȭ���� ��õ ���. 20210729
							fm.car_ext.value = '10'; // ����ȭ���� �뱸 ���. 20220519
						<%} else {%>
								fm.car_ext.value = '7';
						<%}%>
						
					}
				<%}%>
				
				<%if(ej_bean.getJg_g_7().equals("4")){//������%>
				if(fm.hcar_loc_st.value == ''){
					alert("������ ���ּ����� �����Ͻʽÿ�.");
					return;			
				}else{
					fm.car_ext.value = '1';
				}
				//��õ -> ��õ ���
				if(fm.hcar_loc_st.value == '1'){	
					fm.car_ext.value = '7';
				}
				//���� ���� -> ������ ���� ���
				if(fm.hcar_loc_st.value == '3'  && fm.car_st.value == '3'){	
					fm.car_ext.value = '5';
				}
				//����/����/���� -> ���� ���
				if(fm.hcar_loc_st.value == '4'){	
					fm.car_ext.value = '9';
				}
				//�λ�/���/�泲 -> �λ� ���
				if(fm.hcar_loc_st.value == '6'){	
					fm.car_ext.value = '3';
				}
				//20190701 �������� ��õ���
				//fm.car_ext.value = '7';
				fm.car_ext.value = '7'; //20191206 �������� ��� ��õ
				//fm.car_ext.value = '1'; //20200324 �������� ��� ��õ -> ����� ���
				<%}%>
		
		<%-- <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����-��������%>
		if(fm.eco_e_tag.value == ''){	
			alert("�������ｺƼĿ �߱�(�����ͳ� �̿� �����±�)�� �����Ͻʽÿ�.");
			return;
		}		
		/* if(fm.eco_e_tag.value == '1'){
			fm.car_ext.value = '1'; //�������ｺƼĿ �߱޽� ������
		} */
		
			<%if(ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����:��������%>
			if(fm.eco_e_tag.value == '1'){
				alert("������/�������� ���� �������ｺƼĿ �߱�(�����ͳ� �̿� �����±�)�� �Ұ��մϴ�.");
				return;
			}
			<%}else{%>
			if(fm.eco_e_tag.value == '1'){
				fm.car_ext.value = '1'; //�������ｺƼĿ �߱޽� ������
			}
			<%}%>
		
		<%}%> --%>
				
		// ��޽��� �߰� 2017.12.26
		if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
			alert('�������(�⺻��), ������� �̽ð� ����, ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
		}
		if(fm.tint_s_yn.checked == true && fm.tint_ps_yn.checked == true){
			alert('�������(�⺻��)�� ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
		}
		if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true){
			alert('�������(�⺻��)�� ������� �̽ð� ���� �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
		}
		if(fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
			alert('������� �̽ð� ���ΰ� ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_ps_yn.focus(); return;
		}
		if(fm.tint_ps_yn.checked == true && fm.tint_ps_amt.value < 1){
			alert('��޽��� �ݾ��� �Է��ϼ���.'); fm.tint_ps_amt.focus(); return;
		}
		
		if(fm.tint_s_yn.checked == true && toInt(fm.tint_s_per.value) < 50 && '<%=ej_bean.getJg_w()%>' != '1'){
			//alert('�뿩����-��ǰ-��������� �������� �������� 50% �̻� �����մϴ�.'); 				fm.tint_s_per.focus(); 		return;
		}
		
		if(fm.tint_bn_yn.checked == true && fm.tint_bn_nm.value == ''){
			alert('���ڽ� ������ ���� ������ �����Ͻʽÿ�.'); fm.tint_bn_nm.focus(); return;
		}
		
		
		var car_c_amt = toInt(parseDigit(fm.car_c_amt.value));
		var car_f_amt = toInt(parseDigit(fm.car_f_amt.value));
		
		if(car_c_amt == 0)					{ alert('��������-�Һ��ڰ� �⺻������ �Է��Ͻʽÿ�.'); 			fm.car_c_amt.focus(); 		return; }
		if(car_f_amt == 0)					{ alert('��������-���԰� ���������� �Է��Ͻʽÿ�.'); 			fm.car_f_amt.focus(); 		return; }			
		
		//��༭�� ������ ������ �������� ǥ�⿩��, ������. (20190911)
		<%if(base.getCar_gu().equals("1")){%>
			if(fm.dc_view_yn.checked==true){
				if(fm.view_car_dc.value==""||fm.view_car_dc.value==0){
					alert("���� ��༭�� ������ ���� �� �������� ���� ǥ�� ���� üũ!\n\n-> [������ ���� �� ��������] �� �Է����ּ���.");	fm.view_car_dc.focus();	return;
				}
			}else{
				fm.view_car_dc.value="";
			}
		<%}%> 
		
		if(fm.insur_per.value == '')				{ alert('�������-�Ǻ����ڸ� �Է��Ͻʽÿ�.'); 			fm.insur_per.focus(); 		return; }
		if(fm.driving_age.value == '')				{ alert('�������-�����ڿ����� �Է��Ͻʽÿ�.'); 			fm.driving_age.focus(); 	return; }
		<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
			if(fm.com_emp_yn.value == '')			{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');		fm.com_emp_yn.focus(); 		return; }
		<%}else if(AddUtil.parseInt(client.getClient_st()) >2 && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
			//���λ���� ������������ ���Ѿ���
			if(fm.com_emp_yn.value == '')			{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');		fm.com_emp_yn.focus(); 		return; }
		<%}else{%>
			if(fm.com_emp_yn.value == 'Y')			{ alert('�������-��������������Ư�� ���Դ���� �ƴѵ� �������� �Ǿ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');	fm.com_emp_yn.focus(); 	return; }
		<%}%>
		if(fm.gcp_kd.value == '')				{ alert('�������-�빰��� ���Աݾ��� �Է��Ͻʽÿ�.'); 			fm.gcp_kd.focus(); 		return; }
		if(fm.bacdt_kd.value == '')				{ alert('�������-�ڱ��ü��� ���Աݾ��� �Է��Ͻʽÿ�.'); 		fm.bacdt_kd.focus(); 		return; }
		if(fm.canoisr_yn.value == '')				{ alert('�������-������������ ���Կ��θ� �Է��Ͻʽÿ�.'); 		fm.canoisr_yn.focus(); 		return; }
		if(fm.cacdt_yn.value == '')				{ alert('�������-�ڱ��������� ���Կ��θ� �Է��Ͻʽÿ�.'); 		fm.cacdt_yn.focus(); 		return; }
		if(fm.eme_yn.value == '')				{ alert('�������-����⵿ ���Կ��θ� �Է��Ͻʽÿ�.'); 			fm.eme_yn.focus(); 		return; }
		
		//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
		if('<%=base.getCar_st()%><%=fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('�������� ���� �����⺻�ĸ� �����մϴ�.');
				return;
			}			
		}	
				
		var car_ja 	= toInt(parseDigit(fm.car_ja.value));
		
		if(car_ja == 0)						{ alert('�������-������å���� �Է��Ͻʽÿ�.'); 			fm.car_ja.focus(); 		return; }
		
		<%if(ej_bean.getJg_w().equals("1")){//������%>
		if(fm.car_ja.value != fm.imm_amt.value){
			if(fm.ja_reason.value == '')			{ alert('�������-������å�� ��������� �Է��Ͻʽÿ�.'); 		fm.ja_reason.focus(); 		return; }
			if(fm.rea_appr_id.value == '')			{ alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.'); 		fm.rea_appr_id.focus(); 	return; }
		}
		<%}else{%>
		if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
			if(fm.ja_reason.value == '')			{ alert('�������-������å�� ��������� �Է��Ͻʽÿ�.'); 		fm.ja_reason.focus(); 		return; }
			if(fm.rea_appr_id.value == '')			{ alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.'); 		fm.rea_appr_id.focus(); 	return; }
		}			
		<%}%>			
			

		if(fm.insur_per.value == '2'){
			if(fm.ip_insur.value == '')			{ alert('�������-�Ժ�ȸ�� �������� �Է��Ͻʽÿ�.'); 			fm.ip_insur.focus(); 		return; }
			if(fm.ip_agent.value == '')			{ alert('�������-�Ժ�ȸ�� �븮������ �Է��Ͻʽÿ�.'); 			fm.ip_agent.focus(); 		return; }
			if(fm.ip_dam.value == '')			{ alert('�������-�Ժ�ȸ�� ����ڸ��� �Է��Ͻʽÿ�.'); 			fm.ip_dam.focus(); 		return; }
			if(fm.ip_tel.value == '')			{ alert('�������-�Ժ�ȸ�� ����ó�� �Է��Ͻʽÿ�.'); 			fm.ip_tel.focus(); 		return; }
		}
		
		if(fm.gi_st[0].checked == true){//����
			var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
			//var gi_fee 	= toInt(parseDigit(fm.gi_fee.value));
			if(gi_amt == 0)					{ alert('��������-���Աݾ��� �Է��Ͻʽÿ�.'); 			fm.gi_amt.focus(); 		return; }
			//if(gi_fee == 0)					{ alert('��������-��������Ḧ �Է��Ͻʽÿ�.'); 			fm.gi_fee.focus(); 		return; }
		}
			
		if(fm.con_mon.value == '')				{ alert('�뿩���-�̿�Ⱓ�� �Է��Ͻʽÿ�.'); 			fm.con_mon.focus(); 		return; }
		if(toInt(parseDigit(fm.tot_pp_amt.value))>0 && fm.pp_est_dt.value == ''){ alert('������ �Աݿ������� �Է��Ͻʽÿ�.'); 	fm.pp_est_dt.focus(); 		return;	}
		
		if(toInt(parseDigit(fm.credit_r_amt.value))>0 && ( fm.credit_sac_id.value == '' || fm.credit_sac_dt.value == '' )) 
									{ alert('ä��Ȯ�� �����ڿ� �������ڸ� �Է��Ͻʽÿ�.'); 			fm.credit_sac_dt.focus(); 	return;}			
		

													
		if(toInt(parseDigit(fm.ja_amt.value)) == 0 && toInt(parseDigit(fm.ja_r_amt.value)) > 0){
			fm.ja_s_amt.value 	= fm.ja_r_s_amt.value;
			fm.ja_v_amt.value 	= fm.ja_r_v_amt.value;
			fm.ja_amt.value 	= fm.ja_r_amt.value;
			fm.max_ja.value 	= fm.app_ja.value;								
		}
			
		if(fm.max_ja.value == '')				{ alert('�뿩���-�ִ��ܰ����� �Է��Ͻʽÿ�.'); 			fm.max_ja.focus(); 		return; }
		var ja_r_amt = toInt(parseDigit(fm.ja_r_amt.value));
		if(toInt(fm.app_ja.value) < 1 && ja_r_amt > 100000)				{ alert('�뿩���-�����ܰ����� �Է��Ͻʽÿ�.'); 			fm.app_ja.focus(); 		return; }				
		if(ja_r_amt == 0)						{ alert('�뿩���-������ġ�ݾ��� �Է��Ͻʽÿ�.'); 			fm.ja_r_amt.focus(); 		return; }
		if(fm.opt_chk[0].checked == false && fm.opt_chk[1].checked == false){ alert('�뿩���-���Կɼ� ���θ� �Է��Ͻʽÿ�.'); 		fm.opt_chk.focus(); 		return; }
		if(fm.opt_chk[1].checked == true){
			var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
			if(opt_amt == 0)				{ alert('�뿩���-���ԿɼǱݾ��� �Է��Ͻʽÿ�.'); 			fm.opt_amt.focus(); 		return; }
		}
		if(fm.opt_chk[0].checked == true){
			var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
			if(opt_amt > 0)						{ alert('�뿩���-���ԿɼǾ������� �Ǿ� ������ ���ԿɼǱݾ��� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');	fm.opt_amt.focus(); 		return; }
			//fm.opt_s_amt.value = 0;
			//fm.opt_v_amt.value = 0;
			//fm.opt_amt.value = 0;
			//fm.opt_per.value = 0;
		}
		if(toInt(fm.cls_r_per.value) < 1)			{ alert('�뿩���-�ߵ����������� Ȯ���Ͻʽÿ�.'); 		 	fm.cls_r_per.focus(); 		return;	}
		
		var fee_amt = toInt(parseDigit(fm.fee_amt.value));
		var inv_amt = toInt(parseDigit(fm.inv_amt.value));
		var pp_amt = toInt(parseDigit(fm.pp_amt.value));
		if(fm.fee_chk.value == '') fm.fee_chk.value = '0';
		if(fm.pp_chk.value == '' && pp_amt >0) fm.pp_chk.value = '1';
		if(pp_amt == 0) fm.pp_chk.value = '';
		if(fm.fee_chk.value == '0' && fee_amt == 0)		{ alert('�뿩���-�뿩�� ���ݾ��� �Է��Ͻʽÿ�.'); 			fm.fee_amt.focus(); 		return; }
		if(fm.fee_chk.value == '0' && inv_amt == 0)					{ alert('�뿩���-�뿩�� �����ݾ��� �Է��Ͻʽÿ�.'); 			fm.inv_amt.focus(); 		return; }
		
		if(toFloat(parseDigit(fm.dc_ra.value))*100>0 && ( fm.dc_ra_st.value == '' || fm.dc_ra_sac_id.value == '' )) 
									{ alert('�뿩���-�뿩��DC ����ٰ�, �����ڿ� �������ڸ� �Է��Ͻʽÿ�.'); 	fm.dc_ra_st.focus(); 		return;}			
			
		if(toFloat(parseDigit(fm.comm_r_rt.value))>0 && toInt(parseDigit(fm.commi_car_amt.value))==0){
			alert('�������� �����������(�������)�� ������ ��������ݾ� ������ ���� ������� �ݾ��� �����ϴ�. Ȯ���Ͻʽÿ�.'); return;
		}
		
		//Ư�����(�����̰�����)�̸� ���������� ����.
		if(<%=base.getRent_dt()%> >= 20190610 && toFloat(parseDigit(fm.comm_r_rt.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true && fm.dir_pur_yn[0].checked == true && fm.dir_pur_commi_yn.value == 'Y'){
			alert('�������̸鼭 ���ΰ��̰� ����������� �ִ� Ư������ ���������� �����ϴ�.'); return;
		}
					
		if(fm.car_gu.value == '1' && fm.agree_dist.value !='������'){//����
			if(fm.agree_dist.value == '0')		{ alert('�뿩���-��������Ÿ��� �Է��Ͻʽÿ�.'); 			fm.agree_dist.focus(); 		return; }
			if(fm.over_run_amt.value == '0')	{ alert('�뿩���-�ʰ�����δ���� �Է��Ͻʽÿ�.'); 			fm.over_run_amt.focus(); 	return; }
			<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
				if(fm.rtn_run_amt_yn.value == '')									{ alert('�뿩���-ȯ�޴뿩�����뿩�θ� �Է��Ͻʽÿ�.'); 	fm.rtn_run_amt_yn.focus(); 	return; }	
				if(fm.rtn_run_amt.value == '0' && fm.rtn_run_amt_yn.value == '0')	{ alert('�뿩���-ȯ�޴뿩�Ḧ �Է��Ͻʽÿ�.'); 			fm.rtn_run_amt.focus(); 	return; }
				if(toInt(parseDigit(fm.rtn_run_amt.value)) > 0 && fm.rtn_run_amt_yn.value == '1')	{ alert('�뿩���-ȯ�޴뿩��������̹Ƿ� ȯ�޴뿩�� 0�� ó���մϴ�.'); fm.rtn_run_amt.value = 0; }
			<%}%>
		}
			
		<%if(base.getRent_st().equals("3")){%>
			//���� ������ �°� 
			if(fm.grt_suc_yn.value == '0' && fm.grt_suc_l_cd.value !='' && (toInt(parseDigit(fm.grt_suc_o_amt.value))==0 || toInt(parseDigit(fm.grt_suc_r_amt.value))==0)){
				alert('���� ������ �°��Դϴ�. ���������ݰ� �°躸������ �Է��Ͻʽÿ�.'); fm.grt_suc_o_amt.focus(); return;
			}
			if(fm.grt_suc_yn.value == '0' && fm.grt_suc_l_cd.value == ''){
				alert('���� ������ �°��Դϴ�. ����������� �����Ͻʽÿ�.'); fm.grt_suc_l_cd.focus(); return;
			}
			if(fm.grt_suc_yn.value == '' && fm.grt_suc_l_cd.value != '' && toInt(parseDigit(fm.grt_suc_r_amt.value))>0){
				alert('���� ������ �°迩�θ� �����Ͻʽÿ�.'); fm.grt_suc_yn.focus(); return;
			}			
			if(fm.grt_suc_yn.value == '0' && toInt(parseDigit(fm.grt_s_amt.value)) < toInt(parseDigit(fm.grt_suc_r_amt.value))){
				alert('���� ������ �°��Դϴ�. �°躸������ ��� �����ݺ��� Ů�ϴ�. Ȯ���Ͻʽÿ�.'); fm.grt_suc_r_amt.focus(); return;
			}
		<%}%>
			
		if(fm.fee_pay_tm.value == '')				{ alert('�뿩���-����Ƚ���� �Է��Ͻʽÿ�.'); 				fm.fee_pay_tm.focus(); 		return; }
		if(fm.fee_sh.value == '')				{ alert('�뿩���-���ݱ��и� �Է��Ͻʽÿ�.'); 				fm.fee_sh.focus(); 		return; }
		if(fm.fee_pay_st.value == '')				{ alert('�뿩���-���ι���� �Է��Ͻʽÿ�.'); 				fm.fee_pay_st.focus(); 		return; }
		if(fm.fee_pay_st.value != '1' && fm.cms_not_cau.value == ''){ alert('���ι���� �ڵ���ü�� �ƴ� ��� CMS�̽�������� �Է��Ͻʽÿ�.'); fm.cms_not_cau.focus(); return; }
		if(fm.def_st.value == '')				{ alert('�뿩���-��ġ���θ� �Է��Ͻʽÿ�.'); 				fm.def_st.focus(); 		return; }
		if(fm.def_st.value == 'Y'){
			if(fm.def_remark.value == '')			{ alert('�뿩���-��ġ������ �Է��Ͻʽÿ�.');				fm.def_remark.focus();		return; }
			if(fm.def_sac_id.value == '')			{ alert('�뿩���-��ġ �����ڸ� �Է��Ͻʽÿ�.');			fm.def_sac_id.focus();		return; }
		}
			
		if(fm.fee_pay_st.value == '1'){
			if(fm.cms_bank_cd.value == '')	{ alert('�뿩���-CMS �ŷ������� �Է��Ͻʽÿ�.'); 			fm.cms_bank_cd.focus(); 		return; }
			if(fm.cms_acc_no.value != '')		{ 
					if ( !checkInputNumber("CMS ���¹�ȣ", fm.cms_acc_no.value) ) {		
						fm.cms_acc_no.focus(); 		return; 
					}
					//�޴���,����ó ���Ͽ��� Ȯ��
					if(replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getM_tel()%>") || replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getO_tel()%>")){
						alert("���¹�ȣ�� �޴��� Ȥ�� ����ó�� �����ϴ�. ������¹�ȣ�� �ڵ���ü�� �ȵ˴ϴ�.");
						fm.cms_acc_no.focus(); 		return; 
					}
			}	
			if(fm.cms_dep_nm.value == '')			{ alert('�뿩���-CMS �����ָ� �Է��Ͻʽÿ�.'); 				fm.cms_dep_nm.focus(); 		return; }				
			if(fm.cms_dep_ssn.value == '')			{ alert('�뿩���-CMS ������ �������/����ڹ�ȣ�� �Է��Ͻʽÿ�.'); 	fm.cms_dep_ssn.focus(); 	return; }		
			//������ ��������� 6�ڸ�			
			if(replaceString("-","",fm.cms_dep_ssn.value).length == 8){
				alert('�뿩���-CMS ������ ��������� 6�ڸ��Դϴ�.'); return;
			}
		}
			
		if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ fm.tax_type[0].checked = true; }
		if(fm.rec_st.value == '')				{ alert('���ݰ�꼭-û�������ɹ���� �Է��Ͻʽÿ�.');			fm.rec_st.focus(); 		return; }
		if(fm.rec_st.value == '1'){
			if(fm.ele_tax_st.value == '')			{alert('���ݰ�꼭-���ڼ��ݰ�꼭 �ý����� �Է��Ͻʽÿ�.'); 		fm.ele_tax_st.focus();		return; }
			if(fm.ele_tax_st.value == '2'){
				if(fm.tax_extra.value == '')		{ alert('���ݰ�꼭-���ڼ��ݰ�꼭 �����ý��� �̸��� �Է��Ͻʽÿ�.'); 	fm.tax_extra.focus(); 		return; }
			}
			<%	if(print_car_st_yn.equals("Y")){%>
			if(fm.print_car_st.value == '')			{alert('���ݰ�꼭-��꼭�������౸���� �Է��Ͻʽÿ�.'); 		fm.print_car_st.focus();	return; }
			<%	}%>
		}
		
		if(fm.prv_dlv_yn[1].checked == true){
			if(fm.tae_car_no.value == '')		{ alert('���������-�ڵ����� �����Ͻʽÿ�.'); 				fm.tae_car_no.focus(); 		return; }					
			if(fm.tae_car_rent_st.value == '')	{ alert('���������-�뿩�������� �Է��Ͻʽÿ�.'); 			fm.tae_car_rent_st.focus(); 	return; }
			if(fm.tae_req_st.value == '')		{ alert('���������-û�����θ� �����Ͻʽÿ�.'); 			fm.tae_req_st.focus(); 		return; }
			if(fm.tae_req_st.value == '1'){
				if(toInt(parseDigit(fm.tae_rent_fee.value)) == 0)	{ alert('���������-���뿩�Ḧ �Է��Ͻʽÿ�.'); 			fm.tae_rent_fee.focus(); 	return; }
				if(toInt(parseDigit(fm.tae_rent_inv.value)) == 0)	{ alert('���������-�������� �Է��Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
				if(fm.tae_est_id.value == '')	{ alert('���������-������ ����ϱ⸦ �Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
				/*
				if(fm.tae_rent_fee_st[0].checked == false && fm.tae_rent_fee_st[1].checked == false){
					alert('��������� ������ <����� ���� �뿩 ��� ������ �������> �׸� ����Ʈ �������� ǥ��Ǿ� �ִ� ��쿡 ����Ʈ �������� �Է��ϰ�, ����Ʈ �������� ǥ��Ǿ� ���� ���� ��쿡�� ���������� ǥ��Ǿ� ���� ������ üũ���ּ���.'); return;
				}else{
					if(fm.tae_rent_fee_st[0].checked == true){
						if(toInt(parseDigit(fm.tae_rent_fee_cls.value)) == 0){ alert('���� ������ �������(����Ʈ������)�� �Է��Ͻʽÿ�.'); return;									}
						if(toInt(parseDigit(fm.tae_rent_fee.value)) >= toInt(parseDigit(fm.tae_rent_fee_cls.value)))	{ alert('���� ������ �������(����Ʈ������)���� ����������� ���뿩�Ẹ�� ũ�� �ʽ��ϴ�. Ȯ���Ͻʽÿ�.'); 			fm.tae_rent_fee_cls.focus(); 	return; }
					}else{
						fm.tae_rent_fee_cls.value = 0;
					}								
				}
				*/
				if(fm.tae_tae_st.value == '')	{ alert('���������-��꼭���࿩�θ� �����Ͻʽÿ�.'); 			fm.tae_tae_st.focus(); 		return; }						
			}
			if(fm.tae_sac_id.value == '')		{ alert('���������-�����ڸ� �����Ͻʽÿ�.'); 				fm.tae_sac_id.focus(); 		return; }
		}

			
		if(fm.emp_id[0].value != ''){
			if(fm.comm_rt.value == '' || fm.comm_rt.value == '0')	{ 
				fm.comm_rt.value = 3.0;
			}			
			if(fm.comm_r_rt.value == '')		{ alert('������翵�����-�������� ������������� �Է��Ͻʽÿ�.'); 	fm.comm_r_rt.focus(); 		return; }
			if(toFloat(fm.comm_rt.value) < toFloat(fm.comm_r_rt.value)){ //�ִ������������ ������������� �� Ŭ���� ����.
				alert('������翵�����-�������� �ִ������������ ������������� �� Ŭ�� �� �����ϴ�. Ȯ���Ͻʽÿ�.'); 		fm.comm_rt.focus(); return;
			}
			
										
		}
		
		
		
		//��Ÿ(��ü)
		if(fm.dir_pur_yn[0].checked == false){
			var con_amt 		= toInt(parseDigit(fm.con_amt.value));
			//if(con_amt > 0){
			//	if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){
			//		alert('������ҿ� �������(����)�� ������ ���¸� �Է��Ͻʽÿ�.'); return;
			//	}
			//}
			if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value == '�����Ǹ�����'){
				alert('���� �����Ǹ������ε� Ư���� �ƴմϴ�. ������Ҹ� Ȯ���Ͻʽÿ�.'); return;											
			}
			if(fm.dir_pur_commi_yn.value == 'Y'){
				alert('����������� �ְ� Ư�����(�����̰�����)�ε� Ư���� �ƴմϴ�. Ư������� Ȥ�� ��������� ������� Ȯ���Ͻʽÿ�.'); return;
			}
			if(fm.dir_pur_commi_yn.value == 'N'){
				alert('����������� �ְ� Ư�����(�����̰�����)�ε� Ư���� �ƴմϴ�. Ư������� Ȥ�� ��������� ������� Ȯ���Ͻʽÿ�.'); return;
			}
		//Ư�����		
		}else{
			if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value == ''){
				//�����ڵ��� Ư��
				alert('������Ҹ� �Է��Ͻʽÿ�.'); return;											
			}
			if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value != '030849'){
					alert('Ư����� ���õǾ����� ������Ұ� ������������ �ƴմϴ�. Ȯ���Ͻʽÿ�.'); return;						
			}
			if('<%=cm_bean.getCar_comp_id()%>' == '0003' && fm.emp_id[1].value != '038036'){
					alert('Ư����� ���õǾ����� ������Ұ� �����Ǹ����� �ƴմϴ�. Ȯ���Ͻʽÿ�.'); return;
			}
			if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value != '�����Ǹ�����'){
				alert('���� Ư���ε� �����Ǹ����� �ƴմϴ�. ������Ҹ� Ȯ���Ͻʽÿ�.'); return;											
			}
			if(fm.dir_pur_commi_yn.value == '2'){
				alert('����������� �ְ� ��ü���븮������ε� Ư���Դϴ�. Ư������� Ȥ�� ��������� ������� Ȯ���Ͻʽÿ�.'); return;
			}
		}
		
		if(fm.emp_id[1].value != ''){
			if(fm.con_amt.value == '' || fm.con_amt.value == '0')	{
				
			}else{	
				if(fm.trf_st0.value == '')			{ alert('�������-������ ���޼����� �����Ͻʽÿ�.'); 	fm.trf_st0.focus(); 		return; }
				if(fm.trf_st0.value == '1'){
					if(fm.con_bank.value == '') 	{ alert('�������-������ ���ޱ����縦 �Է��Ͻʽÿ�.'); 	fm.con_bank.focus(); 		return; }
					if(fm.con_acc_no.value == '') 	{ alert('�������-������ ���¹�ȣ�� �Է��Ͻʽÿ�.'); 	fm.con_acc_no.focus(); 		return; }
					if(fm.con_acc_nm.value == '') 	{ alert('�������-������ ���¿����ָ� �Է��Ͻʽÿ�.'); 	fm.con_acc_nm.focus(); 		return; }					
				}	
				if(fm.con_est_dt.value == '') 	{ alert('�������-������ ���޿������� �Է��Ͻʽÿ�.'); 	fm.con_est_dt.focus(); 		return; }
			}			
			if(fm.trf_amt5.value == '' || fm.trf_amt5.value == '0')	{
				
			}else{	
				if(fm.trf_st5.value == '')			{ alert('�ӽÿ��ຸ��� ���޼����� �����Ͻʽÿ�.'); 	fm.trf_st5.focus(); 		return; }
				if(fm.trf_st5.value == '1'){
					if(fm.card_kind5.value == '') 	{ alert('�ӽÿ��ຸ��� ���ޱ����縦 �Է��Ͻʽÿ�.'); 	fm.card_kind5.focus(); 		return; }
					if(fm.cardno5.value == '') 		{ alert('�ӽÿ��ຸ��� ���¹�ȣ�� �Է��Ͻʽÿ�.'); 	fm.cardno5.focus(); 		return; }
					if(fm.trf_cont5.value == '') 	{ alert('�ӽÿ��ຸ��� ���¿����ָ� �Է��Ͻʽÿ�.'); 	fm.trf_cont5.focus(); 		return; }					
				}	
				if(fm.trf_est_dt5.value == '') 	{ alert('�ӽÿ��ຸ��� ���޿������� �Է��Ͻʽÿ�.'); 	fm.trf_est_dt5.focus(); 	return; }
			}	
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
			
		if(toFloat(fm.v_comm_rt.value) > 0 ) setCommi();
			
			
		if(inv_amt > 0 && toFloat(fm.dc_ra.value) == 0) dc_fee_amt();		
			
		
		
		if(confirm('4�ܰ踦 ����Ͻðڽ��ϱ�?')){	
			before_submit();	// ������� ÷�ܾ�����ġ select box disable ����	2018.01.24
			fm.action='lc_reg_step4_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}							
	}
	
		
	//��������� �����뿩�� ��� (����)
	function estimate_taecha(st){
		var fm = document.form1;
		
		if(fm.tae_car_mng_id.value == '')	{ alert('��������� ������ �����Ͻʽÿ�.');	return;}		
		
		fm.esti_stat.value 	= st;
				
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}		

		fm.action='get_fee_estimate_taecha.jsp';			
							
		fm.submit();
	}	
	
	//�������μ�
	function TaechaEstiPrint(est_id){ 
		
		var fm = document.form1;  
		
		var SUBWIN="/acar/secondhand_hp/estimate.jsp?from_page=/agent/lc_rent/lc_t_frame.jsp&est_id="+est_id;  	
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}		
	
		
	//��������������� ���ÿ� ���� �ڱ�δ�� ����
	function setCacdtMeAmt(){
		var fm = document.form1;
		fm.cacdt_memin_amt.value = toInt(fm.cacdt_mebase_amt.value)*0.1;		
		if(toInt(fm.cacdt_mebase_amt.value) >0){
			fm.cacdt_me_amt.value = 50;
		}
	}	
	
	function search_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}				
	
	//���������ݽ°���ȸ
	function search_grt_suc()
	{
		var fm = document.form1;	
		window.open("/agent/car_pur/s_grt_suc.jsp?from_page=/fms2/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}					
	
	//������ȸ
	function User_search(nm, idx)
	{
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/agent/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP_Y&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}		
	//�����̰���ϱ�
	function age_search()
	{
		var fm = document.form1;
		
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/agent/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}
	
	function OpenImg(url){
  	var img=new Image();
  	var OpenWindow=window.open('','_blank', 'width=1000, height=760, menubars=no, scrollbars=auto');
  	OpenWindow.document.write("<style>body{margin:0px;}</style><img src='"+url+"' width='990'>");
 }
	
	//���������
	function cng_input(){
		var fm = document.form1;		
		if('<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true ){ // && fm.dir_pur_yn[0].checked == true
			if(fm.dir_pur_commi_yn.value == ''){
				if('<%=ej_bean.getJg_g_7()%>' == '3' || '<%=ej_bean.getJg_g_7()%>' == '4'){
					fm.dir_pur_commi_yn.value = 'N';
				}else{
					fm.dir_pur_commi_yn.value = 'Y';
				}	
				//��Ÿ(��ü)
				if(fm.dir_pur_yn[0].checked == false){
					fm.dir_pur_commi_yn.value = '2';
				}
			}
		}else{												
			fm.dir_pur_commi_yn.value = '';
		}
	}
	
	//������ ���� �� ��������ǥ�� ��
	function span_dc_view(){
		var fm = document.form1;
		if(fm.dc_view_yn.checked==true){	$("#span_dc_view").css("display","");				}
		else{												$("#span_dc_view").css("display","none");		}
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
<form action='lc_reg_step4_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="opt"			value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"			value="<%=cm_bean.getCar_b()%><%=cm_bean2.getCar_b()%>">
  <input type='hidden' name="s_st" 			value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="rent_way" 			value="<%=fee.getRent_way()%>">  
  <input type='hidden' name="dpm" 			value="<%=cm_bean.getDpm()%>">
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
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="o_1"			value="">
  <input type='hidden' name="ro_13"			value="">  
  <input type='hidden' name="o_13"			value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="rent_dt"			value="<%=base.getRent_dt()%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">    
  <input type='hidden' name="client_id"			value="<%=base.getClient_id()%>">       
  <input type='hidden' name="from_page"			value="car_rent">  
  <input type='hidden' name="est_from"			value="lc_reg">      
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">            
  <input type='hidden' name="ins_chk4"			value="">              
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">              
  <input type='hidden' name="fee_rent_st"		value="">  
  <input type='hidden' name="r_max_agree_dist"		value="">   
  <input type='hidden' name="print_car_st_yn"		value="<%=print_car_st_yn%>">  
  <input type='hidden' name="v_o_1"			value="">
  <input type='hidden' name="v_o_2"			value="">
  <input type='hidden' name="v_o_3"			value="">
   
                   
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td align='left'>&nbsp;&nbsp; <span class=style2> <font color=red>[4�ܰ�]</font> ������</span></td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
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
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>��౸��</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>�ű�<%}else if(rent_st.equals("3")){%>����<%}else if(rent_st.equals("4")){%>����<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;
					  ������Ʈ
					  <input type='hidden' name='bus_st' 	value='<%=base.getBus_st()%>'>				
		    		</td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<b><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}%></b></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<b><%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></b></td>
                </tr>
                <tr> 
                    <td class=title>���ʿ�����</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%><%if(!base.getAgent_emp_id().equals("")){%>&nbsp;(�����������:<%=c_db.getNameById(base.getAgent_emp_id(),"CAR_OFF_EMP")%>)<%}%></td>
                    <td class=title>�����븮��</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>��ȣ</td>
                    <td>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a></td>
                    <td class=title>��ǥ��</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>����/����</td>
                    <td>&nbsp;<%=site.getR_site()%></td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	  
                <tr>
                    <td width='13%' class='title'>�ڵ���ȸ��</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' width="10%">����</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' width='10%'>����</td>
                    <td>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class='title'>�Һз� </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
                    <td class='title' width="10%">�����ڵ�</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>��ⷮ</td>
                    <td>&nbsp;<%=cm_bean.getDpm()%>cc</td>
                </tr>
                <tr>
                    <td class='title'>�⺻���</td>
                    <td colspan="5" align=center>
                        <table width=98% cellpadding=3 cellspacing=3 border=0>
                            <tr>
                                <td>
        			  <%if(!cm_bean2.getCar_name().equals("")){%><span title='<%=cm_bean2.getCar_b()%>'><font color='#999999'><%=cm_bean2.getCar_name()%>��&nbsp;</font></span><%}%>
        			  <%=cm_bean.getCar_b()%></td>
        		    </tr>
                        </table>
                    </td>
                </tr>		  
                <tr>
                    <td class='title'>�ɼ�</td>
                    <td colspan="5">&nbsp;
        			  <%=car.getOpt()%><input type='hidden' name='opt_code' value='<%=car.getOpt_code()%>'></td>
                </tr>
                <tr>
                    <td class='title'> ����</td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='color' size='50' class='default' value='<%=car.getColo()%>'>
                      &nbsp;&nbsp;&nbsp;
		      (�������(��Ʈ): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'> )                        
                      &nbsp;&nbsp;&nbsp;
		      (���Ͻ�: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'> )                        
                    </td>
                </tr>
                <tr>
                	<td class="title">����</td>
                	<td colspan="5">&nbsp;<%=car.getConti_rat()%></td>
                </tr>
                <%if(ej_bean.getJg_g_7().equals("3")){//������%>
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td colspan="5">&nbsp;
                        <select name="ecar_loc_st">
                    	  <option value=""  <%if(pur.getEcar_loc_st().equals(""))%>selected<%%>>����</option>
                    	  <%for(int i = 0 ; i < code34_size ; i++){
                            CodeBean code = code34[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getEcar_loc_st().equals(code.getNm_cd())){%>selected<%}%> <%if(Integer.parseInt(cm_bean.getJg_code()) > 8000000 && (code.getNm_cd().equals("12") || code.getNm_cd().equals("13"))){ %>style='display: none;'<%} %>><%= code.getNm()%></option>
                        <%}%>        
                      </select>
        			  </td>
                </tr>	
                <%}%> 
                <%if(ej_bean.getJg_g_7().equals("4")){//������%>
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td colspan="5">&nbsp;
                        <select name="hcar_loc_st">
                    	  <option value=""  <%if(pur.getHcar_loc_st().equals(""))%>selected<%%>>����</option>
                    	  <%for(int i = 0 ; i < code37_size ; i++){
                            CodeBean code = code37[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getHcar_loc_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>        
                      </select>
        			  </td>
                </tr>	
                <%}%>                 
                <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����-�������� %>
                <tr <%if (ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) {%>style="display: none;"<%}%>>
                    <%-- <td class='title'>�������ｺƼĿ �߱�<br>(�����ͳ� �̿� �����±�)</td>
                    <td colspan="5">&nbsp;
                        <select name="eco_e_tag" id="eco_e_tag">
                        <option value="0" <%if(car.getEco_e_tag().equals("") || car.getEco_e_tag().equals("0"))%>selected<%%>>�̹߱�</option>
                        <option value="1" <%if(car.getEco_e_tag().equals("1"))%>selected<%%>>�߱�</option>
                      </select>
                      &nbsp;�� ģȯ���� �� �� �����ͳ� ���̿��ڸ� �߱� ����, ���̺긮��/�÷����� ���̺긮�� ������ ��� ���������� �뿩�ᰡ ���� ��µ�.
        			      </td> --%>
        			<input type="hidden" name="eco_e_tag" id="eco_e_tag" value="<%=car.getEco_e_tag()%>">
                </tr>		
                <%}%>	                                           
                <tr>
                    <td class='title'> �����μ���</td>
                    <td <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>colspan="3"<%} else { %>colspan="5"<% } %>>&nbsp;
						<select name="udt_st" class='default'>
							<option value=''>����</option>
							<option value="1" <%if(base.getBrch_id().equals("S1")||base.getBrch_id().equals("S2")||base.getBrch_id().equals("I1")||base.getBrch_id().equals("K3"))%> selected<%%>>���ﺻ��</option>
							<option value="2" <%if(base.getBrch_id().equals("B1"))%> selected<%%>>�λ�����</option>
							<option value="3" <%if(base.getBrch_id().equals("D1"))%> selected<%%>>��������</option>				
							<option value="5" <%if(base.getBrch_id().equals("G1"))%> selected<%%>>�뱸����</option>
							<option value="6" <%if(base.getBrch_id().equals("J1"))%> selected<%%>>��������</option>				
							<option value="4" >��</option>
						</select>
        			  &nbsp; �μ��� Ź�۷� :
        			  <input type='text' name='cons_amt1' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'> �� (���μ��� ���� ���� �Է��ϼ���.)
        			  
        			 	<%if (car.getHipass_yn().equals("")) { // 20181012 �����н����� (������ ������ ���� select���� input���� ���� ó��)%>
							<input type="hidden" name="hipass_yn" value="">
						<%} else {%>
							<input type="hidden" name="hipass_yn" value="<%=car.getHipass_yn()%>">
						<%}%>
						
						<%if (!(base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001"))) {%>
							<%if (car.getBluelink_yn().equals("")) {%>
								<input type="hidden" name="bluelink_yn" value="">
							<%} else {%>
								<input type="hidden" name="bluelink_yn" value="<%=car.getBluelink_yn()%>">
							<%}%>
						<%}%>
                    </td>
                    <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>
	                    <td class='title'>��縵ũ����</td>
	                    <td>&nbsp;
	                        <select name="bluelink_yn">
	                            <option value='Y' <%if(car.getBluelink_yn().equals("Y"))%>selected<%%>>����</option>
	                            <option value='N' <%if(car.getBluelink_yn().equals("N") || car.getBluelink_yn().equals(""))%>selected<%%>>����</option>
	                        </select>
	                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;�� �������ý� ��縵ũ ���� �ȳ��� �˸���߼�(�����ٻ�����)</span>
	                    </td>
                    <% } %>
                </tr>
                <tr>
                    <td class='title'>�������</td>
                    <td colspan="3" >&nbsp;
                      <select name="car_ext" id="car_ext" class='default'>
                        <option value=''>����</option>
                        <%if(ej_bean.getJg_g_7().equals("3")){//������%>
                        		<option value='1' selected>����</option>
                        		<option value='7'>��õ</option>
                        		<option value='5'>����</option>
                        		<option value='9'>����</option>
                        		<option value='10'>�뱸</option>
                        		<option value='3'>�λ�</option>
                        <%}else if(ej_bean.getJg_g_7().equals("4")){//������%>
                        		<!-- <option value='1' selected>����</option> -->
                        		<option value='7' selected>��õ</option>
                        <%}else{%>
								<option value='7' selected>��õ</option>
							<%	if(ej_bean.getJg_g_7().equals("1") || ej_bean.getJg_g_7().equals("2")){//���̺긮�� ģȯ����%>
                        		<option value='1'>����</option>
                        	<%	}%> 
						<%}%>
                      </select></td>
                    <td class='title'>����</td>
                    <td>&nbsp;
                      <input type='text' name="sun_per" value='<%=car.getSun_per()%>' size="4" maxlength="4" class='text'>
        			  %</td>
                </tr>
                <tr>
                    <td class='title'>LPGŰƮ</td>
                    <td colspan="5" >
        			    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="80">&nbsp;
                                  <select name='lpg_yn'>
                                    <option value="">����</option>
                                    <option value="Y" <%if(car.getLpg_yn().equals("Y")) out.println("selected");%>>����</option>
                                    <option value="N" <%if(car.getLpg_yn().equals("N")) out.println("selected");%>>������ </option>
                                  </select>
                              </td>
                              <td width="110">&nbsp;
                                  <select name='lpg_setter'>
                                    <option value=''>����</option>
                                    <option value='1' <%if(car.getLpg_setter().equals("1")){%> selected <%}%>>������</option>
                                    <option value='2' <%if(car.getLpg_setter().equals("2")){%> selected <%}%>>���뿩������</option>
                                  </select>
                              </td>
                              <td width="110">&nbsp;
                                  <select name='lpg_kit'>
                                    <option value=''>����</option>
            						<%if(ej_bean.getJg_e().equals("1")){%>
                                    <option value='1' <%if(car.getLpg_kit().equals("1")){%> selected <%}%>>�����л�</option>
            						<%}%>
            						<%if(ej_bean.getJg_e1()>0){%>
                                    <option value='2' <%if(car.getLpg_kit().equals("2")){%> selected <%}%>>�����л�</option>
            						<%}%>
            						<%if(ej_bean.getJg_e().equals("3")){%>
                                    <option value='3' <%if(car.getLpg_kit().equals("3")){%> selected <%}%>>�����Ұ�</option>
            						<%}%>
                                  </select>
                              </td>
                              <td>&nbsp;
                                  <input type='text' name='lpg_price' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getLpg_price())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
            					  �� </td>
                            </tr>
                        </table>
        			</td>
                </tr>	
                <tr>
                    <td class='title'><span class="title1">������߰�����</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='add_opt' size='45' class="text" value='<%=car.getAdd_opt()%>'>
        				&nbsp;<input type='text' name='add_opt_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  ��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����ݿ���,LPGŰƮ����,�׺���̼� ��)</font></span>
                    </td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">�����ݿ���ǰ</span></td>
                    <td colspan="5">&nbsp;
                      <label><input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2ä�� ���ڽ�</label>
                      &nbsp;
                      <label><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y") || !(cm_bean.getCar_comp_id().equals("0056") || cm_bean.getCar_comp_id().equals("0057") ||  (Integer.parseInt(cm_bean.getJg_code()) > 9017300 && Integer.parseInt(cm_bean.getJg_code()) < 9018200)) ){%>checked<%}%>> ���� ����(�⺻��)</label>,
                      &nbsp;
                      ���ñ��������� :
                      <input type='text' name="tint_s_per" value='<%=car.getTint_s_per()%>' size="4" maxlength="4" class='text'>
        	      % 
      		      &nbsp;
      		      <label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> ��޽���(��������)</label>
      		      &nbsp;&nbsp;���� <input type="text" name="tint_ps_nm" size="10" value='<%=car.getTint_ps_nm()%>'>
      		      &nbsp; ��ǰ�� ���ޱݾ� <input type="text" name="tint_ps_amt" size="10" value='<%=car.getTint_ps_amt()%>'> �� (�ΰ�������)      		      
      		      <br>
      		      &nbsp;
      		      	  <label><input type="checkbox" name="tint_sn_yn" value="Y" <%if(car.getTint_sn_yn().equals("Y")){%>checked<%}%>> ������� �̽ð� ����</label>
      		      	  <label><input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> ���ڽ� ������ ����      		      	   
                  		&nbsp; ���λ��� : 
                  		<select name="tint_bn_nm">
                  		<option value=""  <%if (car.getTint_bn_nm().equals("")){%>selected<%}%>>����</option>
                  		<option value="2" <%if (car.getTint_bn_nm().equals("2")){%>selected<%}%>>������</option>
                   		<option value="1" <%if (car.getTint_bn_nm().equals("1")){%>selected<%}%>>��Ʈ��ķ</option>                   		
                   		</select>
      		      	  </label>
					  <label><input type="checkbox" name="tint_cons_yn" value="Y" <%if(car.getTint_cons_yn().equals("Y")){%>checked<%}%>> �߰�Ź�۷�� </label>
                      <input type="text" name="tint_cons_amt" class='num' size="10" value='<%=car.getTint_cons_amt()%>'> ��
                      <label <%if(!car.getTint_n_yn().equals("Y")){%>style="display: none;"<%}%>>&nbsp;<input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> ��ġ�� ������̼�</label>
                      <%if(ej_bean.getJg_g_7().equals("3")){//������%>
      		      &nbsp;
                      <label <%if(!car.getTint_eb_yn().equals("Y")){%>style="display: none;"<%}%>>&nbsp;<input type="checkbox" name="tint_eb_yn" value="Y" <%if(car.getTint_eb_yn().equals("Y")){%>checked<%}%>> �̵��� ������(������)</label>
                      <%}%>   
                      &nbsp;
                      	<label> ��ȣ�Ǳ���</label>
                      	<!-- <label> ������ȣ�ǽ�û</label> -->
                      	<select name="new_license_plate">
                      		<%if( !( (Integer.parseInt(ej_bean.getSh_code()) > 9018110 && Integer.parseInt(ej_bean.getSh_code()) < 9018999) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")
                      				|| cm_bean.getCar_comp_id().equals("0044") || cm_bean.getCar_comp_id().equals("0007") || cm_bean.getCar_comp_id().equals("0025") || cm_bean.getCar_comp_id().equals("0033") || cm_bean.getCar_comp_id().equals("0048")) ){ %>
                      		<option value="1" <%if (car.getNew_license_plate().equals("") || car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>����</option>
                      		<% } %>
                      		<option value="0" <%if (car.getNew_license_plate().equals("0")) {%>selected<%}%>>����</option>
                      		<%-- <option value="" <%if (car.getNew_license_plate().equals("")) {%>selected<%}%>>��û����</option>
                      		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>��û</option> --%>
<%--                       		<option value="1" <%if (car.getNew_license_plate().equals("1")) {%>selected<%}%>>������</option> --%>
<%--                       		<option value="2" <%if (car.getNew_license_plate().equals("2")) {%>selected<%}%>>����/�뱸/����/�λ�</option> --%>
                      	</select>                   
                    </td>
                </tr>                
                <tr>
                    <td class='title'><span class="title1">����ǰ��</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='extra_set' size='45' class="text" value='<%=car.getExtra_set()%>'>
        				&nbsp;<input type='text' name='extra_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getExtra_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  ��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����̹ݿ���)</font></span>
        					  &nbsp;<input type="checkbox" name="serv_b_yn" value="Y" <%if(car.getServ_b_yn().equals("Y")){%>checked<%}%>> ���ڽ� (2015��8��1�Ϻ���)
        					  <%if(ej_bean.getJg_g_7().equals("3")){%>
								&nbsp;<input type="checkbox" name="serv_sc_yn" value="Y" <%if(car.getServ_sc_yn().equals("Y")){%>checked<%}%>> ������������
							  <%} %>
                    </td>
                </tr>
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='5' cols='90' class=default name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td><font color="#666666">* LPGŰƮ : LPGŰƮ �߰������� �Է� / * �߰����� : LPGŰƮ�� �߰������� �Է�</font></td>
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
                <td class='title'>��������</td>
                <td colspan="3">&nbsp;
    			<%if(base.getCar_st().equals("3")){%>
    			����<input type='hidden' name="purc_gu" value="1">
    			<%}else{
    				if(cm_bean.getS_st().equals("401") || cm_bean.getS_st().equals("402") || cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("821")){%>
    				�����<input type='hidden' name="purc_gu" value="0">
    			<%	}else{%>
    				�鼼<input type='hidden' name="purc_gu" value="0">
    			<%	}%>
    			<%}%>                    			    		
                </td>
                <td class='title'>��ó</td>
                <td colspan="3">&nbsp;<%String car_origin = car.getCar_origin();%>
    			<%	if(car_origin.equals("")){
    					code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
    					car_origin = code_bean.getApp_st();
    				}%>
    			<%if(car_origin.equals("1")){%>����<%}else if(car_origin.equals("2")){%>����<%}%>
    			<input type='hidden' name="car_origin" value="<%=car_origin%>"></td>
              </tr>
              <tr>
                <td width="13%" rowspan="2" class='title'>���� </td>
                <td colspan="3" class='title'>�Һ��ڰ���</td>
                <td width="10%" rowspan="2" class='title'>����</td>
                <td colspan="3" class='title'>���԰���</td>
              </tr>
              <tr>
                <td width="13%" class='title'>���ް�</td>
                <td width="13%" class='title'>�ΰ���</td>
                <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_c_amt()" onMouseOver="window.status=''; return true" title="�Һ��ڰ� �հ� ����ϱ�">�հ�</a></span></td>
                <td width="13%" class='title'>���ް�</td>
                <td width="12%" class='title'>�ΰ���</td>
                <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_f_amt()" onMouseOver="window.status=''; return true" title="���԰� �հ� ����ϱ�">�հ�</a></span></td>
              </tr>
              <tr>
                <td class='title'> �⺻����</td>
                <td>&nbsp;
                  <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>��������</td>
                <td>&nbsp;
                  <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
              </tr>
              <tr>
                <td height="12" class='title'>�ɼ�</td>
                <td>&nbsp;
                  <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  <input type="hidden" name="opt_amt_m" value="<%=AddUtil.parseDecimal(car.getOpt_amt_m())%>">
                  <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>Ź�۷�</td>
                <td height="12">&nbsp;
                  <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td height="12">&nbsp;
                  <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td height="12">&nbsp;
                  <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
              </tr>
              <tr>
                <td height="26" class='title'> ����</td>
                <td>&nbsp;
                  <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title><span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">����D/C</a></span></td>
                <td>&nbsp;
                  <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
    				��</td>
                <td>&nbsp;
                  <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
    				��</td>
                <td>&nbsp;
                  <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
    				��</td>
              </tr>
              <tr id=tr_ecar_dc <%if(car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'> ���Ҽ� �����</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>                  
              <tr>
                <td align="center" class='title_p'>�հ�</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_cs_amt' size='10' value='' class='fixnum' readonly>
    			    ��</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_cv_amt' size='10' value='' class='fixnum' readonly>
    				��</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_c_amt' size='10' value='' class='fixnum'  readonly>
    				��</td>
                <td align='center' class='title_p'>�հ�</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_fs_amt' size='10' value='' class='fixnum' readonly>
    				��</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_fv_amt' size='10' value='' class='fixnum' readonly>
    				��</td>
                <td class='title_p' style='text-align:left'>&nbsp;
                  <input type='text' name='tot_f_amt' size='10' value='' class='fixnum'  readonly>
    				��</td>
              </tr>
              <tr id=tr_sptax style='display:none'>
                <td class='title'>���ο���</td>
                <td>&nbsp;
                  <select name='pay_st'>
                    <option value="">����</option>
                    <option value="1" <%if(car.getPay_st().equals("1")){%> selected <%}%>>����</option>
                    <option value="2" <%if(car.getPay_st().equals("2")){%> selected <%}%>>�鼼</option>
                  </select>
                </td>
                <td class='title'>Ư�Ҽ�</td>
                <td >&nbsp;
                  <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='fixnum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
    				��</td>
                <td class='title'>������</td>
                <td >&nbsp;
                  <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='fixnum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
    				��</td>
                <td class='title'>�հ�</td>
                <td >&nbsp;
                  <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='fixnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>
    				��</td>
              </tr>
            </table>		
	    </td>
    </tr>
    <!-- ������ ���� �� �������� ǥ��(20190911)- �����̰� �ű԰���� ��츸 -->
    <%if(base.getCar_gu().equals("1")){ %>
    <tr>
  		<td>
  			<font color="#666666">* ���� ��༭�� ������ ���� �� �������� ���� ǥ�� ����</font>
  			<input type="checkbox" name="dc_view_yn" id="dc_view_yn" <%if(cont_etc.getView_car_dc()!=0){%>checked<%}%> onclick="javascript:span_dc_view();">&nbsp;&nbsp;&nbsp;
  			<span id="span_dc_view" style="display:<%if(cont_etc.getView_car_dc()==0){%> none<%}else{%><%}%>;">
  				<font color="#666666">������ ���� �� �������� 
  					<input type="text" size="10" name="view_car_dc" value="<%=cont_etc.getView_car_dc()%>" onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown='javascript:enter_car(this)'>��
  				</font>
  			</span>
  		</td>
  	</tr>
  	<%}%>			  
    <%if(ej_bean.getJg_w().equals("1")){//������%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ������ ����</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>ī������ݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='import_card_amt' value='<%= AddUtil.parseDecimal(car.getImport_card_amt())%>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    </td>
                    <td width="10%" class='title'>Cash Back�ݾ�</td>
                    <td>&nbsp;
        		<input type='text' name='import_cash_back' value='<%= AddUtil.parseDecimal(car.getImport_cash_back())%>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
        	    </td>	
                </tr>
            </table>
	    </td>
    </tr>      
    <%}%>  
    <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ģȯ����</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>���ź�����</td>
                    <td width="27%">&nbsp;
                        <input type='text' name='ecar_pur_sub_amt' readonly value='<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    </td>
                    <td width="10%" class='title'>�����ݼ��ɹ��</td>
                    <td>&nbsp;
        		            <select name='ecar_pur_sub_st'  disabled>
        		            	<option value="">����</option>
                          <option value="1" <%if(car.getEcar_pur_sub_st().equals("1")){%> selected <%}%>>������ ������� ����</option>
                          <option value="2" <%if(car.getEcar_pur_sub_st().equals("2")){%> selected <%}%>>�Ƹ���ī ���� ����</option>
                        </select>
                        <input type='hidden' name="h_ecar_pur_sub_amt"	value="<%=car.getEcar_pur_sub_amt()%>">
                        <input type='hidden' name="h_ecar_pur_sub_st"		value="<%=car.getEcar_pur_sub_st()%>">
        	          </td>
                </tr>
            </table>
	    </td>
    </tr>                 
    <%}%>                        
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width="13%"  class=title>��������</td>
                <td width="20%">&nbsp;
                    <select name='insurant' class='default'>                      
                      <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                  </select></td>
                <td width="10%"  class=title>�Ǻ�����</td>
                <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                    <select name='insur_per' onChange='javascript:display_ip(); set_insur_serv();' class='default'>
                      <option value="">����</option>
                      <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                      <%if(car_st.equals("3")){%>
                      <!--  <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>-->
                      <%}%>
                  </select></td>
              </tr>
              <tr> 
                <td width="13%" class=title>�����ڹ���</td>
                <td width="20%" class=''>&nbsp;
    		  <select name='driving_ext'>
                      <option value="">����</option>
                      <option value="1" <%if(base.getDriving_ext().equals("1") || base.getDriving_ext().equals("")){%> selected <%}%>>�����</option>
                      <%if(car_st.equals("3")){%>
                      <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>��������</option>
                      <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>��Ÿ</option>
                      <%}%>
                  </select>			
    			</td>
                <td width="10%" class=title >�����ڿ���</td>
                <td>&nbsp;
                    <select name='driving_age'>
                      <option value="">����</option>
                      <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>��26���̻�</option>
                      <%if(car_st.equals("3")){%>
                      <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>��24���̻�</option>
                      <%}%>
                      <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>��21���̻�</option>
                      <%if(car_st.equals("3")){%>
                      <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>��������</option>
		      <option value=''>=�Ǻ����ڰ�=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>��30���̻�</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>��35���̻�</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>��43���̻�</option>						
		      <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>��48���̻�</option>
		      <%}%>
                  </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a></td>
                <td class=title >��������������Ư��</td>
                <td class=''>&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">����</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                  </select></td>                    
              </tr>              
              <tr>
                <td width="13%" class=title>���ι��</td>
                <td width="20%">&nbsp; ����(���ι��,��)</td>
                <td width="10%" class=title>�빰���</td>
                <td width="20%" class=''>&nbsp;
                    <select name='gcp_kd'>
                      <option value="">����</option>
                      <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                      <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1���</option>
                      <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2���</option>
					  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3���</option>
                      <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5���</option>					  
                  </select></td>
                <td width="10%" class=title >�ڱ��ü���</td>
                <td class=''>&nbsp;
                    <select name='bacdt_kd'>
                      <option value="">����</option>                      
                      <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1���</option>
                  </select></td>
              </tr>
              <tr>
                <td  class=title>������������</td>
                <td>&nbsp;<%if(cont_etc.getCanoisr_yn().equals("")) cont_etc.setCanoisr_yn("Y");%>
                  <select name='canoisr_yn'>
                    <option value="">����</option>
                    <option value="Y" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getCanoisr_yn().equals("N")){%> selected <%}%>>�̰���</option>
                  </select>            </td>
                <td class=title>�ڱ���������</td>
                <td class=''>&nbsp;<%if(cont_etc.getCacdt_yn().equals("")) cont_etc.setCacdt_yn("N");%>
                  <select name='cacdt_yn' class='default'>
                    <option value="">����</option>
                    <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>�̰���</option>
                  </select>              </td>
                <td class=title >����⵿</td>
                <td class=''>&nbsp;<%if(cont_etc.getEme_yn().equals("")) cont_etc.setEme_yn("N");%>
                  <select name='eme_yn'>
                    <option value="">����</option>
                    <option value="Y" <%if(cont_etc.getEme_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getEme_yn().equals("N")){%> selected <%}%>>�̰���</option>
                  </select></td>
              </tr>
              <tr>
                <td  class=title>������å��</td>
                <td>&nbsp;
    			<input type='text' size='12' maxlength='10' name='car_ja' class='num' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			��</td>
                <td class=title>�������</td>
                <td class=''>&nbsp;
                  <input type='text' size='18' name='ja_reason' class='text' value='<%=cont_etc.getJa_reason()%>'></td>
                <td class=title >������</td>
                <td class=''>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getRea_appr_id(), "USER")%>" size="12"> 
			<input type="hidden" name="rea_appr_id" value="<%=cont_etc.getRea_appr_id()%>">
			<a href="javascript:User_search('rea_appr_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>				
			<% user_idx++;%>
                    (�⺻ <input type='text' size='6' maxlength='10' name='imm_amt' class='whitenum' value='<%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%>' readonly>��) </td>
              </tr>
              <tr>
                <td  class=title>�ڵ���</td>
                <td colspan="5">&nbsp;
    			  <select name="air_ds_yn">
                    <option value="">����</option>
                    <option value="Y" <%if(cm_bean.getAir_ds_yn().equals("Y")){%> selected <%}%>>��</option>
                    <option value="N" <%if(cm_bean.getAir_ds_yn().equals("N")){%> selected <%}%>>��</option>
                  </select>
    				�����������
    			  <select name="air_as_yn">
                    <option value="">����</option>
                    <option value="Y" <%if(cm_bean.getAir_as_yn().equals("Y")){%> selected <%}%>>��</option>
                    <option value="N" <%if(cm_bean.getAir_as_yn().equals("N")){%> selected <%}%>>��</option>
                  </select>	
    				�����������
    			 &nbsp; 			
                      <select name="blackbox_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getBlackbox_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			���ڽ�  
        			<br/>		
        			&nbsp; 	
                      <select name="lkas_yn" id="lkas_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getLkas_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getLkas_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			������Ż(������)	
        			&nbsp; 			
                      <select name="ldws_yn" id="ldws_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getLdws_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getLdws_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			������Ż(�����)	
        			&nbsp; 			
                      <select name="aeb_yn" id="aeb_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getAeb_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getAeb_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			�������(������)	
        			&nbsp; 			
                      <select name="fcw_yn" id="fcw_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getFcw_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getFcw_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			�������(�����)	
        			&nbsp; 			
                      <select name="ev_yn" id="ev_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getEv_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getEv_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			�����ڵ���	
        			<br/>
        			&nbsp; 	
					  <select name="hook_yn" id="hook_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getHook_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getHook_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			���ΰ�(Ʈ���Ϸ���)
        			&nbsp; 			
                      <select name="legal_yn" id="legal_yn" >
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getLegal_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getLegal_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>	
        			�������������(�����)
        			&nbsp; 			
        			<select name="top_cng_yn" id="top_cng_yn" >
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getTop_cng_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getTop_cng_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			ž��(���ΰ�)
        			<br/>        				
        				&nbsp;  
        				��Ÿ��ġ : 
                      <input type="text" class="text" name="others_device" value="<%=cont_etc.getOthers_device()%>" size="50">     
                  </td>
              </tr>
              <tr>
                <td  class=title>��������<br>��&nbsp;��&nbsp;��<br>��������</td>
                <td colspan="5">&nbsp;
                	<%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
                      		<input type="checkbox" name="ac_dae_yn" 	value="Y" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>>
                    <%} else {%>
                      		<input type="hidden" name="ac_dae_yn" value="Y" >
                      		&nbsp;* 
                    <%} %>  
                      		����������(���ػ��� ����)<br>
        			  &nbsp;
        			  <%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
        			  		<input type="checkbox" name="pro_yn" 		value="Y" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>>
        			  <%} else {%>
                      		<input type="hidden" name="pro_yn" value="Y" >
                      		&nbsp;* 
                      <%} %>  
        			  ������ �߻��� ���ó�� �������� (����� ���� ���� ��) <br>
        			  &nbsp;
        			  <input type="checkbox" name="main_yn" 	value="Y" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>> 
                      		  ��ü�� ���񼭺�(���� ��������ǰ/�Ҹ�ǰ  ����,��ȯ,����) * ������ ���� ��޼��� ���� <br>
        			  &nbsp;
        			  <input type="checkbox" name="ma_dae_yn" 	value="Y" <%if(cont_etc.getMa_dae_yn().equals("Y")){%>checked<%}%>> 
                      		  �����������(4�ð� �̻� ������� �԰��) <br>
    			  </td>
              </tr>
              <tr id=tr_ip style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                <td  class=title>�Ժ�ȸ��</td>
                <td colspan="5">
                    <table width="100%" border="0" cellpadding="0">
                      <tr>
                        <td width="100%">&nbsp;�����  :
                            <input type='text' name='ip_insur' value='<%=cont_etc.getIp_insur()%>' size='12' class='text'>
              				&nbsp;�븮�� : 
              				<input type='text' name='ip_agent' value='<%=cont_etc.getIp_agent()%>' size='15' class='text'>
              				&nbsp;����� :
              				<input type='text' name='ip_dam' value='<%=cont_etc.getIp_dam()%>' size='10' class='text'>
        					&nbsp;����ó :
        					<input type='text' name='ip_tel' value='<%=cont_etc.getIp_tel()%>' size='13' class='text'>
        					</td>
                      </tr>
                    </table>
                 </td>
                </tr>
              <tr id=tr_ip2 style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                <td  class=title>��������</td>
                <td colspan="5">
                    <table width="100%" border="0" cellpadding="0">
                      <tr>
                        <td width="100%">&nbsp;���������������
					  <select name='cacdt_mebase_amt' onChange="javascript:setCacdtMeAmt();" align="absmiddle">
					    <option value=""    <%if(cont_etc.getCacdt_mebase_amt()==0  ){%>selected<%}%>>����</option>
					    <option value="50"  <%if(cont_etc.getCacdt_mebase_amt()==50 ){%>selected<%}%>>50����</option>
					    <option value="100" <%if(cont_etc.getCacdt_mebase_amt()==100){%>selected<%}%>>100����</option>
					    <option value="150" <%if(cont_etc.getCacdt_mebase_amt()==150){%>selected<%}%>>150����</option>
					    <option value="200" <%if(cont_etc.getCacdt_mebase_amt()==200){%>selected<%}%>>200����</option>
					  </select>
					  / (�ִ�)�ڱ�δ�� 
                      <input type='text' size='6' name='cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(cont_etc.getCacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      ���� 
					  / (�ּ�)�ڱ�δ��  
                      <select name='cacdt_memin_amt'>
                        <option value=""   <%if(cont_etc.getCacdt_memin_amt()==0 ){%>selected<%}%>>����</option>
                        <option value="5"  <%if(cont_etc.getCacdt_memin_amt()==5 ){%>selected<%}%>>5����</option>
                        <option value="10" <%if(cont_etc.getCacdt_memin_amt()==10){%>selected<%}%>>10����</option>
                        <option value="15" <%if(cont_etc.getCacdt_memin_amt()==15){%>selected<%}%>>15����</option>
                        <option value="20" <%if(cont_etc.getCacdt_memin_amt()==20){%>selected<%}%>>20����</option>
                      </select>      
                			    </td>
                      </tr>
                    </table>
                 </td>
                </tr>				
                <tr>
                      <td class='title'>���</td>
                      <td colspan="5">&nbsp;
                        <textarea rows='3' cols='90' class=default name='others'><%=base.getOthers()%></textarea></td>
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
	<tr id=tr_gi style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td class=title width="13%">���Կ���</td>
                <td colspan="5">&nbsp;
                    <input type='radio' name="gi_st" value='1' onClick="javascript:display_gi()" <%if(gins.getGi_st().equals("1")){%> checked <%}%>>
              		����
              		<input type='radio' name="gi_st" value='0' onClick="javascript:display_gi()" <%if(gins.getGi_st().equals("0")){%> checked <%}%>>
              		���� </td>
              </tr>
              <tr id=tr_gi1 style="display:<%if(gins.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                <td class=title>��������</td>
                <td width="20%">&nbsp;<input type='hidden' name='gi_no' value='<%=gins.getGi_no()%>'>
    			   <input type='text' name='gi_jijum' value='<%=gins.getGi_jijum()%>' size='12' class='text'>
                </td>
                <td width="10%" class='title'>���Աݾ�</td>
                <td width="20%" >&nbsp;
                    <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt()'>
              		��</td>
                <td class=title >���������</td>
                <td>&nbsp;
                    <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='<%=AddUtil.parseDecimal(gins.getGi_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
              		��</td>
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
              <%
              		int e_agree_dist =0;
              	
              		//20151211 ����,�縮�� ��� ǥ�ؾ�������Ÿ� ����
              	
              		fee_etc.setAgree_dist(30000);
              		
              		if(AddUtil.parseInt(base.getRent_dt()) >= 20220415){
            			fee_etc.setAgree_dist(23000);
            		}
              		
			//���� +5000
			if(ej_bean.getJg_b().equals("1")){
				fee_etc.setAgree_dist(fee_etc.getAgree_dist()+5000);
			}				
			
			//LPG +10000 -> 20190418 +5000
			if(ej_bean.getJg_b().equals("2")){
				fee_etc.setAgree_dist(fee_etc.getAgree_dist()+5000);
			}
			
			e_agree_dist = fee_etc.getAgree_dist();
					
			//�׽��� ��������Ÿ� 2�� ���� - 20190801 �ʰ��δ�� 450�� ����
// 			if(cm_bean.getJg_code().equals("4854") || cm_bean.getJg_code().equals("5866") || cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("4314111") || cm_bean.getJg_code().equals("6316111") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")){
			if(cm_bean.getCar_comp_id().equals("0056")){
				if(AddUtil.parseDecimal(fee_etc.getAgree_dist()).equals("0")){
			//		fee_etc.setAgree_dist(20000);
					fee_etc.setOver_run_amt(450);
				}
			} 
			
              %>                  
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                <td colspan='3'>&nbsp;
                    <input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 ����
					 <input type='hidden' name='rent_start_dt' value='<%=fee.getRent_start_dt()%>'>
					 <input type='hidden' name='rent_end_dt' value='<%=fee.getRent_end_dt()%>'>					 					 
					 </td>
              </tr>
              <tr>
                <td width="13%" align="center" class=title>�����ſ���</td>
                <td width="20%">&nbsp;
    			  <input type='hidden' name='dec_gr' value='<%=cont_etc.getDec_gr()%>'>
    			  <input type='hidden' name='spr_kd' value='<%=base.getSpr_kd()%>'>
    			  <% if(base.getSpr_kd().equals("3")) out.print("�ż�����"); 	%>
                  <% if(base.getSpr_kd().equals("0")) out.print("�Ϲݰ�"); 	%>
                  <% if(base.getSpr_kd().equals("1")) out.print("�췮���"); 	%>
                  <% if(base.getSpr_kd().equals("2")) out.print("�ʿ췮���");  %>
    			</td>
                <td width="10%" class=title>���뺸��</td>
                <td >&nbsp;
    			<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%>
    			��ǥ�� : ���� /
    			<%}%>
    			���뺸�� :
    			<%if(cont_etc.getGuar_st().equals("1")){%>
    			(<%=gur_size%>)��
    			<%	if(gur_size > 0){
    		  			for(int i = 0 ; i < gur_size ; i++){
    						Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
    					<%=gur.get("GUR_NM")%>&nbsp;
    					<%	}%>
    					
    			<%	}%>
    			<%}else{%>
    			����
    			<%}%>
    			</td>
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
                <td align='center'><input type='text' size='11' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">������
                    <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fee.getGur_p_per()%>' readonly>
    				  % </td>
                <td align='center'><input type='hidden' name='gur_per' value=''><input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>'>                
					<%if(base.getRent_st().equals("3")){%>
					���� ������ �°迩�� :
					<select name='grt_suc_yn'>
                              <option value="">����</option>
                              <option value="0">�°�</option>
                              <option value="1">����</option>
                            </select>	
					<%}%>		
					</td>
              </tr>
              <tr>
                <td class='title' colspan="2">������</td>
                <td align="center"><input type='text' size='11' name='pp_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='pp_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='pp_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">������
                    <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=fee.getPere_r_per()%>' readonly>
    				  % </td>
                <td align='center'><input type='hidden' name='pere_per' value=''>
           ������ ��꼭���౸�� :
					<select name='pp_chk'>
                              <option value="">����</option>
                              <option value="1">�����Ͻù���</option>
                              <option value="0">�ſ��յ����</option>
                            </select>                	
                	</td>
              </tr>
              <tr>
                <td class='title' colspan="2">���ô뿩��</td>
                <td align="center"><input type='text' size='11' name='ifee_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ifee_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ifee_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">������
                    <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=fee.getPere_r_mth()%>' readonly>
    				  ����ġ �뿩�� </td>
                <td align='center'>-<input type='hidden' name='pere_mth' value=''></td>
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
                      <input type='text' size='11' name='pp_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                </td>
                <td align='center'>&nbsp;</td>
              </tr>
              <tr>
    		<td class='title' colspan="2">��ä��Ȯ��</td>
                <td colspan='3'>&nbsp;
                        ������ : <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etc.getCredit_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="credit_sac_id" value="<%=fee_etc.getCredit_sac_id()%>">
			<a href="javascript:User_search('credit_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
			&nbsp;&nbsp;&nbsp;&nbsp;
			�������� : <input type='text' size='11' name='credit_sac_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee_etc.getCredit_sac_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                </td>						
                <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='' readonly>%
    			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='fixnum' readonly>��(������������)</td>
                <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='' readonly>%
    			<input type='text' size='10' name='credit_amt' maxlength='10' class='fixnum' readonly>��</td>
              </tr>
             
              <tr>
                <td rowspan="2" class='title'>����<br>
                  �Ÿ�</td>              
                <!--20130605 ������������Ÿ� �-->              
                <td class='title' colspan="2"><span class="title1">��������Ÿ�</span></td>
                <td colspan="4">&nbsp;
		  <input type='text' name='agree_dist' size='8' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>'>
                  km����/1��,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (�������Ͽ����) ȯ�޴뿩��  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��/1km (�ΰ�������)
                  <%//	if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
                  <!--
                  <select name='rtn_run_amt_yn'>        
                    <option value="">����</option>                      
                    <option value="0" <%if(fee_etc.getRtn_run_amt_yn().equals("0")||fee_etc.getRtn_run_amt_yn().equals(""))%>selected<%%>>ȯ�޴뿩������</option>
                    <option value="1" <%if(fee_etc.getRtn_run_amt_yn().equals("1"))%>selected<%%>>ȯ�޴뿩�������</option>                    
                  </select>
                  -->
                  <%//	}else{ %>
                  ��ȯ�޴뿩������
                  <input type="hidden" name="rtn_run_amt_yn" value="0">
                  <%//	} %>
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
                  �ʰ� 1km�� (<input type='text' name='over_run_amt' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
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
                	<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                	<input type='text' name='e_rtn_run_amt' size='2' class='whitenum' value='0' >/1km<br>&nbsp;
                	<%}else{ %>
                  	<input type="hidden" name="e_rtn_run_amt" value="0">
                  	<%} %>   
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' value='0' >/1km<br>&nbsp;
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' value='' >
                </td>
              </tr>  
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">����������Ÿ�</td>
                    <td colspan="6">&nbsp;
                        <input type='text' name='over_bas_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%>' >
                        km
                        (�縮�� ������ �뿩���� ����Ÿ�, ��༭ ���� ��)
                    </td>
                </tr>	
              <tr>
                <td rowspan="4" class='title'>��<br>
                  ��</td>
                <td class='title' colspan="2">ǥ�� �ִ��ܰ�</td>
                <td align="center">-</td>
                <td align="center">-</td>
                <td align='center'>-</td>
                <td align="center">������
    			  <input type='text' size='4' name='b_max_ja' maxlength='10' class='<%if(base.getCar_gu().equals("1")){%>fix<%}else{%>default<%}%>num' value='<%=fee.getB_max_ja()%>' <%if(base.getCar_gu().equals("1")){%>readonly<%}%>>
    			  % </td>
                <td align='center'><input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=e_agree_dist%>' >km/1��</td>
              </tr>                              
              <tr>
                <td class='title' colspan="2">���� �ִ��ܰ�</td>
                <td align="center"><input type='text' size='11' name='ja_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ja_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ja_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt()+fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">������
    			  <input type='text' size='4' name='max_ja' maxlength='10' readonly class='fixnum' value='<%=fee.getMax_ja()%>' readonly>
    			  % </td>
                <td align='center'><input type='text' name='r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' >km/1��</td>
              </tr>
              <tr>
                <td class='title' colspan="2">���Կɼ�</td>
                <td align="center"><input type='text' size='11' name='opt_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='opt_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='opt_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getOpt_s_amt()+fee.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">������
                    <input type='text' size='4' name='opt_per' class='defaultnum' value='<%=fee.getOpt_per()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  % </td>
                <td align='center'>
    			  <input type='radio' name="opt_chk" value='0' <%if(fee.getOpt_chk().equals("0")){%> checked <%}%>>
                  ����
                  <input type='radio' name="opt_chk" value='1' <%if(fee.getOpt_chk().equals("1")){%> checked <%}%>>
    	 		  ����
                </td>
              </tr>
              <tr>
                <td class='title' colspan="2">�����ܰ�</td>
                <td align="center"><input type='text' size='11' name='ja_r_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ja_r_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ja_r_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee.getJa_s_amt()+fee.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">������
    			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="defaultnum" value='<%=fee.getApp_ja()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    			  % </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td rowspan="6" class='title'>��<br>��<br>��</td>
                <td class='title' colspan="2">�����</td>
                <td align="center" ><input type='text' size='11'  name='fee_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center" ><input type='text' size='11'  name='fee_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center' ><input type='text' size='11'  name='fee_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">-</td>
                <td align='center'>
				���뿩�ᳳ�Թ�� :
					  <select name='fee_chk'>
                              <option value="">����</option>
                              <option value="0" <%if(fee.getFee_chk().equals("0"))%>selected<%%>>�ſ�����</option>
                              <option value="1" <%if(fee.getFee_chk().equals("1"))%>selected<%%>>�Ͻÿϳ�</option>
                            </select>	
							</td>
              </tr>
              <!-- �������߰����/�������(���Ǻ���) ���� (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">��<br>��<br>��<br>��<br>��</td>
	                <td class='title'>������</td>
	                <td align="center" ><input type='text' size='11' name='inv_s_amt' maxlength='10' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  ��</td>
	                <td align="center" ><input type='text' size='11' name='inv_v_amt' maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  ��</td>
	                <td align='center' ><input type='text' size='11' maxlength='10' name='inv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_s_amt()+fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  ��</td>
	                <td align="center">-</td>
	                <td align='center'>&nbsp;
	    			  <span class="b"><a href="javascript:estimate('<%=fee.getRent_st()%>','account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
	                </td>
               </tr>
               <tr>
                    <td class='title'>�������(���Ǻ���)</td>
                    <td align="center" ><input type='text' size='11' name='ins_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='11' name='ins_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='11' maxlength='10'  name='ins_amt' class='num' value='<%=AddUtil.parseDecimal(fee.getIns_s_amt()+fee.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">&nbsp;�������(���ް�) = �Ⱓ�����
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='num' value='<%=AddUtil.parseDecimal(fee.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 ��/12</td>
                    <td align='center'>-<!-- �ڵ������� ���� Ư�� ������<br> -->
                    	<%-- <a href="javascript:reqdoc('<%=fees.getRent_l_cd()%>','<%=fees.getRent_mng_id()%>','<%=fees.getRent_st()%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> --%>
                    </td>
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
                    	<input type='text' size='11' name='tinv_s_amt' maxlength='11' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_s_amt() + fee.getIns_s_amt() + fee_etc.getDriver_add_amt())%>'> �� 
                    </td>
                    <td align="center" >
                       	<input type='text' size='11' name='tinv_v_amt'  maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_v_amt() + fee.getIns_v_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center' >
                    	<input type='text' size='11' maxlength='10'  name='tinv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fee.getInv_s_amt() + fee.getInv_v_amt() + fee.getIns_s_amt() + fee.getIns_v_amt() + fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
              
        	<tr>
                <td class='title' colspan="2">�뿩��DC</td>
                <td colspan='3'>&nbsp;
                    ������ : 
                        <input name="user_nm" type="text" class="text"  readonly value="" size="12"> 
			<input type="hidden" name="dc_ra_sac_id" value="">
			<a href="javascript:User_search('dc_ra_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
		    &nbsp;&nbsp;&nbsp;&nbsp;
		    �������� : 	
		    <input type='text' size='11' name='bas_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                </td>                                
                <td align="center">                
                    ����ٰ� : <select name='dc_ra_st'>
                        <option value=''>����</option>
                        <option value='1' selected>����DC����</option>
                        <option value='2'>Ư��DC</option>
                    </select>
                    ��Ÿ : <input type='text' size='20' name='dc_ra_etc' class="text" value=''>
                </td>
                <td align='center'>DC�� <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fee.getDc_ra()%>'>%
                	<input type="hidden" name="dc_ra_amt" value="0">
                	</td>
              </tr>                             
              <tr id=tr_emp_bus style="display:''">
                <%-- <td rowspan="<%if(rent_st.equals("3")){%>4<%}else{%>3<%}%>" class='title'>��<br>Ÿ</td> --%>
                <td rowspan="<%if(rent_st.equals("3")){%>3<%}else{%>2<%}%>" class='title'>��<br>Ÿ</td>
                <td class='title' colspan="2">��������</td>
                <td colspan="2" align="center">�������:
    			  <select name='commi_car_st'>
                    <option value='1' selected>��������</option>
                  </select>
    			</td>
                <td align='center'><input type='text' size='11' name='commi_car_amt' maxlength='11' class='defaultnum' value='' onBlur="javascript:setCommi()">
    				  ��</td>
                <td align="center">
                    <input type='text' name="comm_r_rt" value='<%//=emp1.getComm_r_rt()%>' size="3"  maxlength='3' class='defaultnum' onBlur='javascript:setCommi()'>
    		      %</td>
                <td align='center'>
    				[�ִ� <input type='text' name="comm_rt" value='<%//=emp1.getComm_rt()%>' size="3"  maxlength='3' class='fixnum' readonly>
    			  %]</td>
              </tr>
              <tr>
                <td class='title' colspan="2">�ߵ�����������</td>
                <td colspan="2" align="center">-</td>
                <td align='center'>-</td>
                <td align="center">�ܿ��Ⱓ �뿩����
                    <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fee.getCls_r_per()%>'>
    				  %</td>
                <td align='center'><font color="#FF0000">
    				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fee.getCls_per()%>'>%
					,�ʿ��������[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value='<%=fee.getCls_n_per()%>'>%]
					</font></span></td>
              </tr>
                <%-- <tr>
                    <td class='title'>�������߰����</td>
                    <td colspan="6">&nbsp;
                    	<input type='text' size='10' name='driver_add_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>'>
        				  �� (���ް�)</td>                  
                </tr> --%>              
				<%	if(base.getRent_st().equals("3")){
						//�������������
						Hashtable suc_cont = new Hashtable();
						if(!cont_etc.getGrt_suc_l_cd().equals("")){
							suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
						}
					%>
              <tr>
                    <td class='title'  colspan="2" style="font-size : 8pt;">���������</td>
                    <td colspan="6">&nbsp;
                                          <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>					  
					  &nbsp;����ȣ : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;�����ڵ庰���� ���� : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[���������ݽ°�]</b>
					  &nbsp;���������� : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  �°躸���� : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum'  onBlur="javascript:document.form1.grt_suc_cha_amt.value=parseDecimal(toInt(parseDigit(document.form1.grt_suc_o_amt.value))-toInt(parseDigit(document.form1.grt_suc_r_amt.value)));">��
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(���������� ���� <input type='text' name='grt_suc_cha_amt' size='10' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>' class='whitenum'>)</font>
					  <%}else{ %>
					  <input type='hidden' name='grt_suc_cha_amt' 	value=''>
					  <%} %>	
        			</td>
        			<%	}%>
              </tr>					  			  
			  <input type='hidden' name='bus_agnt_r_per' 	value='<%//=fee_etc.getBus_agnt_r_per()%>'>
			  <input type='hidden' name='bus_agnt_per' 	value='<%//=fee_etc.getBus_agnt_per()%>'>
			  <input type='hidden' name='cls_n_mon' 	value='<%//=fee_etc.getCls_n_mon()%>'>
			  <input type='hidden' name='cls_n_amt' 	value='<%//=fee_etc.getCls_n_amt()%>'>
			  <input type='hidden' name='min_agree_dist' 	value='<%//=fee_etc.getMin_agree_dist()%>'>
			  <input type='hidden' name='max_agree_dist' 	value='<%//=fee_etc.getMax_agree_dist()%>'>
			  <input type='hidden' name='over_run_day' 	value='<%//=fee_etc.getOver_run_day()%>'>
			  <input type='hidden' name='over_serv_amt' 	value='<%//=fee_etc.getOver_serv_amt()%>'>
			  <input type="hidden" name="fee_sac_id" value="<%=fee.getFee_sac_id()%>">

                <tr>
                    <td colspan="3" class='title'>��༭ Ư����� ���� ����</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                    			<%
                    				String con_etc_text = "2023�� 1�� 1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ";
                    				String con_etc_text2 = "����ü ������ ���� �Ǵ� ����, ���� ������� ������ �뿩�ᰡ ����ǰų� ��������� �Ұ��� �� �� �ֽ��ϴ�.";
                    			%>
				                <textarea rows='5' cols='90' name='con_etc' ><%if( ej_bean.getJg_3() > 0){ %>�� 2023�� 1�� 1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ <%if( !(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")) ){ %>*,***��(���ް�) <%} %>�λ�˴ϴ�.<%}
					  				if(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){
					  					String con_etc_value = "";
// 					  					if(cm_bean.getJg_code().equals("3313112")|| cm_bean.getJg_code().equals("3313113")|| cm_bean.getJg_code().equals("3313114")
// 					  						|| cm_bean.getJg_code().equals("5315111") || cm_bean.getJg_code().equals("5315112") || cm_bean.getJg_code().equals("5315113")
// 					  						){
					  					if(cm_bean.getCar_comp_id().equals("0056")){
					  						con_etc_value = "�� ȯ��, ����, ���� ���� �����̳� ������ ������å�� ���� ���������� ����� ��� �뿩�ᰡ ����� �� �ֽ��ϴ�. ���� �������� ���� �Ǵ� ����� �뿩�ᰡ ����ǰų�  ��������� �Ұ��� �� �� �ֽ��ϴ�.";
					  					} else{
					  						con_etc_value = "�� ����ü ������ ���� �Ǵ� ����, ���� ������� ������ �뿩�ᰡ ����ǰų� ��������� �Ұ��� �� �� �ֽ��ϴ�.";
					  					}%><%=con_etc_value%><%}
                    				if(!fee_etc.getCon_etc().equals("")&&!fee_etc.getCon_etc().contains(con_etc_text)&&!fee_etc.getCon_etc().contains(con_etc_text2)) {
                    				%><%=fee_etc.getCon_etc()%><%} %></textarea>
                    		</div>
                   		</div>
                      	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
					  		<div style="display: table-cell; vertical-align: middle;">
                      		<%if (base.getCar_gu().equals("1") && AddUtil.parseInt(AddUtil.getDate(4)) >= 20200831 && AddUtil.parseInt(AddUtil.getDate(4)) < 20210101) {//���Ҽ� �ѽ��� ���� �Ⱓ %>                 
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
							  	<script>
								function setMentConEtc(idx) {
									/* if (idx == "0") {
										document.form1.con_etc.value = "�����Һ� �ѽ��� ���� 70% ����(2020.3~6��) �Ⱓ�� �ʰ��Ͽ�, �����Һ����� 3.5%(2020.7~12��)�� �����Ǿ� ���� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�.";
									} */
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
										document.form1.con_etc.value = "�� 2023�� 1�� 1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�.";
									} 
								}
							  	</script>	   
					  		</div>
				  		</div>
                    </td>
                </tr>			              
              	<tr>
	                <td colspan="3" class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
	                <td colspan="5">
	                	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
			                  	<textarea rows='5' cols='90' class=default name='fee_cdt'><%=fee.getFee_cdt()%></textarea>
                    		</div>
                   		</div>
					</td>
              	</tr>			
              	<tr>
	                <td colspan="3" class='title'>���<br>(���� ����)</td>
	                <td colspan="5">
	                	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
			                  	<textarea rows='5' cols='90' class=default name='cls_etc'><%=cont_etc.getCls_etc()%></textarea>
                    		</div>
                   		</div>
					</td>
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
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
    </tr>				
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Թ��</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>	
    <tr id=tr_fee2 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="3%" rowspan="5" class='title'>��<br>��<br>��<br>��<br>��<br>��<br>��</td>
                <td width="10%" class='title'>����Ƚ��</td>
                <td width="20%">&nbsp;
                  <input type='text' size='3' name='fee_pay_tm' value='<%=fee.getFee_pay_tm()%>' maxlength='2' class='default' >
    				ȸ </td>
                <td width="10%" class='title'>��������</td>
                <td width="20%">&nbsp;�ſ�
                  <select name='fee_est_day'>
                    <option value="">����</option>
                    <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                    <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                    <% } %>
                    <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> ���� </option>
					<option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> �뿩������ </option>
                  </select></td>
                <td width="10%" class='title'>���ԱⰣ</td>
                <td>&nbsp;
                  <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
    				~
    			  <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
              </tr>		  		  		  
              <tr>
                <td width="10%" class='title'>���ݱ���</td>
                <td width="20%">&nbsp;
                  <select name='fee_sh'>
                    <option value="">����</option>
                    <option value="0" <%if(fee.getFee_sh().equals("0")){%> selected <%}%>>�ĺ�</option>
                    <option value="1" <%if(fee.getFee_sh().equals("1")){%> selected <%}%>>����</option>
                  </select></td>
                <td width="10%" class='title'>���ι��</td>
                <td>&nbsp;
                  <select name='fee_pay_st'>
                    <option value=''>����</option>
                    <option value='1' <%if(fee.getFee_pay_st().equals("1")){%> selected <%}%>>�ڵ���ü</option>
                    <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>�������Ա�</option>
                    <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>����</option>
                    <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>��Ÿ</option>
                  </select></td>
    			  <td class='title'>CMS�̽���</td>
    			  <td>&nbsp;
    			    ���� : <input type='text' name='cms_not_cau' size='25' value='<%//=fee_etc.getCms_not_cau()%>' class='text'>
    			  </td>
                </tr>		  		  		  
              <tr>
                <td class='title'>��ġ����</td>
                <td colspan="3">&nbsp;
                <select name='def_st'>
                  <option value="N" <%if(fee.getDef_st().equals("N")){%> selected <%}%>>����</option>
                  <option value="Y" <%if(fee.getDef_st().equals("Y")){%> selected <%}%>>����</option>
                </select>
    			 ���� :            
    			 <input type='text' name='def_remark' size='40' value='<%=fee.getDef_remark()%>' class='text'>
    			</td>
                <td class='title'>������</td>
                <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee.getDef_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="def_sac_id" value="<%=fee.getDef_sac_id()%>">
			<a href="javascript:User_search('def_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
                  </td>
              </tr>
              <tr>
                <td class='title'>�ڵ���ü
                    <br><span class="b"><a href="javascript:search_cms('')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;
					�ŷ����� : 
					    <input type='hidden' name="cms_bank" 			value="<%=cms.getCms_bank()%>">
    				  <select name='cms_bank_cd'>
                    <option value=''>����</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];	
    												//�ű��ΰ�� �̻������ ����
    												if(bank.getUse_yn().equals("N"))	 continue;
    												if(cms.getCms_bank().equals("")){
        						%>			
                    <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}else{%>
                    <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}%>
                    <%		}
    					 					}%>
                  </select>
    				&nbsp;&nbsp;
    				���¹�ȣ : 
    			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='20' class='text'>
    			      
    			      &nbsp;&nbsp;�� �� �� :
    			      <input type='text' name='cms_dep_nm' value='<%if(cms.getCms_dep_nm().equals("")){%><%=client.getFirm_nm()%><%}else{%><%=cms.getCms_dep_nm()%><%}%>' size='20' class='text'>
    					  
					  <br><br>
    			      &nbsp;
					  ������ �������/����ڹ�ȣ :
					  <%	if(cms.getCms_dep_ssn().equals("")){
					  			if(client.getClient_st().equals("1")) 	cms.setCms_dep_ssn(client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3());
								else                                   	cms.setCms_dep_ssn(client.getSsn1());					  
				  		}
					  %>
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
					  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
						<script>
							function openDaumPostcode() {
								new daum.Postcode({
									oncomplete: function(data) {
										document.getElementById('t_zip').value = data.zonecode;
										document.getElementById('t_addr').value = data.address +" ("+ data.buildingName+")";
										
									}
								}).open();
							}
						</script>
    				  &nbsp;&nbsp;������ �ּ� : 
					  <input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%if(cms.getCms_dep_post().equals("")){%><%=client.getO_zip()%><%}else{%><%=cms.getCms_dep_post()%><%}%>">
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="65" value="<%if(cms.getCms_dep_addr().equals("")){%><%=client.getO_addr()%><%}else{%><%=cms.getCms_dep_addr()%><%}%>">
						
					  <br><br>
    			      &nbsp;
					  ������ȭ :
    			      <input type='text' name='cms_tel' size='15' class='text' value="<%if(cms.getCms_tel().equals("")){%><%= client.getO_tel()%><%}else{%><%=cms.getCms_tel()%><%}%>">

    			      &nbsp;&nbsp;�޴��� :
    			      <input type='text' name='cms_m_tel' size='15' class='text' value="<%if(cms.getCms_m_tel().equals("")){%><%= client.getM_tel()%><%}else{%><%=cms.getCms_m_tel()%><%}%>">
    					  
    			      &nbsp;&nbsp;�̸��� :
    			      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%if(cms.getCms_email().equals("")){%><%= client.getCon_agnt_email()%><%}else{%><%=cms.getCms_email()%><%}%>">
    					  
					  
    			       </td>
    			    </tr>
    			</table>
    			</td>
              </tr>
              <tr>
                <td class='title'>�����Ա�</td>
                <td colspan="5">&nbsp; 
                  <select name='fee_bank'>
                    <option value=''>����</option>
                    <%if(bank_size > 0){
    										for(int j = 0 ; j < bank_size ; j++){
    											CodeBean bank = banks[j];
    											//�ű��ΰ�� �̻������ ����
 													if(bank.getUse_yn().equals("N"))	 continue;
    								%>
                          <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%= bank.getNm()%> </option>
                    <%	}
    									}
    								%>
                  </select>
                </td>
              </tr>
            </table>
        </td>
    </tr>		
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_tax style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="13%" class='title'>���޹޴���</td>
                <td width="20%">&nbsp;<%if(base.getTax_type().equals("")) base.setTax_type("1"); %>
                  <input type="radio" name="tax_type" value="1" <% if(base.getTax_type().equals("1")) out.print("checked"); %>>
    			    ����
    		      <input type="radio" name="tax_type" value="2" <% if(base.getTax_type().equals("2")) out.print("checked"); %>>
    		    	���� </td>
                <td width="10%" class='title' style="font-size : 8pt;">û�������ɹ��</td>
                <td width="20%">&nbsp;<%if(client.getEtax_not_cau().equals("")) cont_etc.setRec_st("1"); else cont_etc.setRec_st("2");%>
                  <select name='rec_st' class='default'>
                    <option value="">����</option>					
                    <option value="1" <% if(cont_etc.getRec_st().equals("1")) out.print("selected"); %>>�̸���</option>
                    <option value="2" <% if(cont_etc.getRec_st().equals("2")) out.print("selected"); %>>����</option>
                    <option value="3" <% if(cont_etc.getRec_st().equals("3")) out.print("selected"); %>>���ɾ���</option>
                  </select>
                </td>
                <td width="10%" class='title' style="font-size : 8pt;">���ڼ��ݰ�꼭</td>
                <td>&nbsp;<%if(cont_etc.getRec_st().equals("1") && cont_etc.getEle_tax_st().equals("")) cont_etc.setEle_tax_st("1");%>
                  <select name='ele_tax_st' class='default'>
                    <option value="">����</option>
                    <option value="1" <% if(cont_etc.getEle_tax_st().equals("1")) out.print("selected"); %>>���ý���</option>
                    <option value="2" <% if(cont_etc.getEle_tax_st().equals("2")) out.print("selected"); %>>�����ý���</option>
                  </select>
                  <input type='text' name='tax_extra' maxlength='10' size='15' value='<%=cont_etc.getTax_extra()%>' class='text'>
    			</td>
              </tr>
			  <!--�ΰ���ȯ�������� �߰� �Ǿ��� ��쿡 �ΰ���ȯ������ ��꼭 ���� �߱ݿ� ���� ���´�.-->
			  <%	if(print_car_st_yn.equals("Y")){%>
			  <tr>
                <td width="13%" class='title'>��꼭�������౸��</td>			  
			    <td colspan='5'>&nbsp;
				  <select name='print_car_st'>
                    <option value="">����</option>				  
                    <option value=''  >����</option>
                    <option value='1' selected>����/ȭ��/9�ν�/����</option>							
                  </select>	
				  <font color=red>* '<%=cm_bean.getCar_nm()%>' ������ �ΰ���ȯ�޴�� �����Դϴ�. �ΰ���ȯ���Ұ�� ��꺰�����౸���� [����/ȭ��/9�ν�/����]�� �����Ͻʽÿ�.</font>
				</td>	
			  </tr>
			  <%	}%>		
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
    <tr id=tr_tae1 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="13%" class=title>��������</td>
                <td width="20%">&nbsp;<%if(fee.getPrv_dlv_yn().equals("")) fee.setPrv_dlv_yn("N"); %>
                  <input type='radio' name="prv_dlv_yn" value='N' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                  ����
                  <input type='radio' name="prv_dlv_yn" value='Y' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
    	 		�ִ�
    		    </td>
                <td width="10%" class=title style="font-size : 8pt;">�����Ⱓ���Կ���</td>
                <td>&nbsp; &nbsp;<%if(fee.getPrv_dlv_yn().equals("Y") && fee.getPrv_mon_yn().equals("")) fee.setPrv_mon_yn("0"); %>
                  <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> >
                  ������
                  <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> >
    	 		����
    		    </td>			
              </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_tae2 style="display:<%if(fee.getPrv_dlv_yn().equals("Y") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                <td width="13%" class=title>������ȣ</td>
                <td width="20%">&nbsp;
                  <input type='text' name='tae_car_no' size='12' class='text' readonly value='<%=taecha.getCar_no()%>'>
                  <span class="b"><a href="javascript:car_search('taecha')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span> 
    			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
    			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
    			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
    			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
				  <input type='hidden' name='tae_s_cd'	 	 value='<%=taecha.getRent_s_cd()%>'>
    			</td>
                <td width="10%" class='title'>����</td>
                <td>&nbsp;
                  <input type="text" name="tae_car_nm" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getCar_nm()%>'></td>
                <td class='title'>���ʵ����</td>
                <td>&nbsp; 
                  <input type="text" name="tae_init_reg_dt" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getInit_reg_dt()%>'></td>
              </tr>
              <tr>
                <td class=title>�뿩������</td>
                <td>&nbsp;
                  <input type='text' name='tae_car_rent_st' class='text' size='11' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                <td class='title'>�뿩������</td>
                <td >&nbsp;
                  <input type='text' name='tae_car_rent_et' class='text' size='11' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
    			  &nbsp;</td>
    			  <td class='title'>�뿩�ἱ�Աݿ���</td>
                <td>&nbsp;
                	<input type='radio' name="tae_f_req_yn" value='Y' <%if(taecha.getF_req_yn().equals("Y")){%> checked <%}%> >
                  ���Ա�
                  <input type='radio' name="tae_f_req_yn" value='N' <%if(taecha.getF_req_yn().equals("N")||taecha.getF_req_yn().equals("")){%> checked <%}%> >
    	 		        ���Ա�
    	 		        </td>
              </tr>
              <tr>
                <td class=title>���뿩��</td>
                <td colspan='3'>&nbsp;
                  <input type='text' name='tae_rent_fee' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			  ��(vat����) 
    			</td>
                <td class=title>������</td>
                <td >&nbsp;
                      <input type='text' name='tae_rent_inv' class='whitenum' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_inv())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����) 
					  <span class="b"><a href="javascript:estimate_taecha('account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
        			  <input type='hidden' name='tae_rent_inv_s'	 value=''>
        			  <input type='hidden' name='tae_rent_inv_v'	 value=''>					  
					  <input type='hidden' name='tae_est_id'	 	 value='<%=taecha.getEst_id()%>'>					  					  
        		</td>				
              </tr>	
              	              
              <tr>
                    <td class=title>���������ÿ������</td>
                    <td colspan='5' >&nbsp;
                      <input type='radio' name="tae_rent_fee_st" value='1' <%if(taecha.getRent_fee_st().equals("1")||taecha.getRent_fee_st().equals("")){%> checked <%}%> >
                                      ����Ʈ������
                      <input type='text' name='tae_rent_fee_cls' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����)                 
                      <input type='radio' name="tae_rent_fee_st" value='0' <%if(taecha.getRent_fee_st().equals("0")){%> checked <%}%>  >
    	 		          �������� ǥ��Ǿ� ���� ����                      				  					 
        			</td>                   
              </tr>		                
              <tr>
                <td class=title>û������</td>
                <td>&nbsp;
                  <select name='tae_req_st'>
                    <option value="">����</option>
                    <option value="1" <% if(taecha.getReq_st().equals("1")) out.print("selected");%>>û��</option>
                    <option value="0" <% if(taecha.getReq_st().equals("0")) out.print("selected");%>>�������</option>
                  </select></td>
                <td class='title' style="font-size : 8pt;">��꼭���࿩��</td>
                <td>&nbsp;
                  <select name='tae_tae_st'>
                    <option value="">����</option>
                    <option value="1" <% if(taecha.getTae_st().equals("1")) out.print("selected");%>>����</option>
                    <option value="0" <% if(taecha.getTae_st().equals("0")) out.print("selected");%>>�̹���</option>
                  </select></td>
                <td class='title'>������</td>
                <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(taecha.getTae_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="tae_sac_id" value="<%=taecha.getTae_sac_id()%>">
			<a href="javascript:User_search('tae_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>	
			<% user_idx++;%>
    			</td>
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
        <td class=line2></td>
    </tr>
    <tr id=tr_emp_bus style="display:''"> 	
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
                	<td width="3%" rowspan="6" class='title'>��<br>
     			  	��</td>
					<td class='title'>��������</td>
					<td colspan='5'>&nbsp;
						<label><input type='radio' name="pur_bus_st" value='4' checked >
						������Ʈ</label>                  
					</td>
				</tr>
				<tr id="dlv_con_commi_yn_tr">
					<td class='title'>��������� ���޿���</td>
					<td colspan='5'>&nbsp;
						<label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
						����</label>����
						<label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input()">
						����</label>
              		<table>
              		   <tr>              		   
              		       <td>&nbsp;
              		           <select name='dir_pur_commi_yn'>
                          <option  value="">����</option>
                          <option value="Y" <%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>selected<%}%>>Ư�����(�����̰�����)</option>
                          <option value="N" <%if(cont_etc.getDir_pur_commi_yn().equals("N")){%>selected<%}%>>Ư�����(�����̰��Ұ���)</option>
                          <option value="2" <%if(cont_etc.getDir_pur_commi_yn().equals("2")){%>selected<%}%>>��ü���븮�����</option>
                        </select>                        
              		       </td> 
              		   </tr>
              		</table>						
					</td>
				</tr>	            
				<tr>                
                	<td width="10%" class='title'>�������</td>
                	<td width="20%" >&nbsp;
                  	<input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
    		  		<input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>
    				</td>
                <td width="10%" class='title'>�����Ҹ�</td>
                <td width="20%">&nbsp;
                  <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>
                  <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
				  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
				  </td>
                <td width="10%" class='title'>����</td>
                <td>&nbsp;
                  <input type='text' name='car_off_st' size='15' value='<%=emp1.getCar_off_st()%>' class='whitetext' readonly>
                </td>
              </tr>
              <tr>
                <td class='title'>�ҵ汸��</td>
                <td >&nbsp;
                  <input type='text' name='cust_st' size='15' value='<%=emp1.getCust_st()%>' class='whitetext' readonly></td>
                <td class='title'>�ִ��������</td>
                <td>&nbsp;
                  <input type='text' name="v_comm_rt" value='<%=emp1.getComm_rt()%>' size="3" class='whitenum' readonly>
    			  % 
    			</td>
                <td class='title'>�����������</td>
                <td>&nbsp;
                  <input type='text' name="v_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="3" class='whitenum' readonly>
    		      % 
    			  <input type='hidden' name='commi' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>'>
    			</td>
              </tr>
              <tr>
                <td class='title'>�������</td>
                <td colspan="3" >&nbsp;
    		      <input type='text' name="ch_remark" value='<%=emp1.getCh_remark()%>' size="40" class='text'>
                </td>
                <td class='title'>������</td>
                <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(emp1.getCh_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ch_sac_id" value="<%=emp1.getCh_sac_id()%>">
			<a href="javascript:User_search('ch_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>	
			<% user_idx++;%>
    			</td>
              </tr>
              <tr>
                <td class='title'>�����</td>
                <td >&nbsp;
                	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
    		      <select name='emp_bank_cd'>
                    <option value=''>����</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];
    												//�ű��ΰ�� �̻������ ����
   													if(bank.getUse_yn().equals("N"))	 continue;
    								%>
                    <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%		}
    										}
    								%>
                  </select>
    			</td>
                <td class='title'>���¹�ȣ</td>
                <td>&nbsp;
                  <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='text'>
    			</td>
                <td class='title'>�����ָ�</td>
                <td colspan="2">&nbsp;
                  <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='text'>
    			</td>
              </tr>		  
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������-�����</span> <%if(!cop_bean.getRent_l_cd().equals("")){%>&nbsp;<font color=red>(������� <%=cop_bean.getCom_con_no()%>)</font><%}%></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_emp_dlv style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
              <tr>
                <td width="3%" rowspan="4" class='title'>��<br>
                  ��</td>
                <td class='title'>�����</td>
                <td>&nbsp;      
                  <label><input type='radio' name="one_self" value='Y' >
                  ��ü���</label>
                  <label><input type='radio' name="one_self" value='N' checked >
                  ����������</label>                                                         
                </td>
                <td class='title'>Ư�������</td>
                <td>&nbsp;
                    <input type='radio' name="dir_pur_yn" value='Y' onClick="javascript:cng_input()">
        				Ư��
        	    <input type='radio' name="dir_pur_yn" value='' onClick="javascript:cng_input()">
        				��Ÿ(��ü)
        	</td>  
        	<td class='title'>����û��</td>
                <td>&nbsp;
                		  <input type='text' name='pur_req_dt' value='' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		 &nbsp;
        		  <input type="checkbox" name="pur_req_yn" value="Y">				  
        				����û�Ѵ�
    			</td>			
              </tr>		            			
              <tr>
                
                <td width="10%" class='title'>�����</td>
                <td width="20%" >&nbsp;
                  <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
    			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
                  <span class="b"><a href="javascript:search_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
    			  <span class="b"><a href="javascript:cancel_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
                  <input type='checkbox' name="emp_chk" onClick="javascript:set_emp_sam()"><font size='1'>��</font></td>
                <td width="10%" class='title'>�����Ҹ�</td>
                <td width="20%">&nbsp;
                  <%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%>
                  <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
				  <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
    			</td>
                <td width="10%" class='title'>����</td>
                <td>&nbsp;
                  <input type='text' name='car_off_st' size='15' value='<%=emp2.getCar_off_st()%>' class='whitetext' readonly>
                </td>
              </tr>
              
              <tr>
                <td class='title'>����</td>
                <td colspan="5">&nbsp;
                	�ݾ� : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��	
                     &nbsp;
                     ���޼��� :
                     <select name="trf_st0" class='default'>
                        <option value="">==����==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>ī��</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>����</option>        				
        			  </select> 
                     &nbsp;
                    ������ :
					<select name='con_bank' class='default'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	�������� :
				  	<select name="acc_st0" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>�������</option>
        			  </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					������ : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
        			<br>
        			&nbsp;
        			���޿�û�� :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
					  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;(����������:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <%}%>        			
    			</td>															
              </tr>
              <tr>				
                <td class='title'>�ӽÿ��ຸ���</td>
                <td colspan='5'>&nbsp;
                  �ݾ� : 
				     <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��	
                     &nbsp;
                     ���޼��� :
                     <select name="trf_st5" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getTrf_st5().equals("1")) out.println("selected");%>>����</option>        				
        				<option value="3" <%if(pur.getTrf_st5().equals("3")) out.println("selected");%>>ī��</option>
        			  </select> 
                     &nbsp;
                    ������ :
					<select name='card_kind5' class='default'>
                        <option value=''>����</option>                        
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCard_kind5().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	�������� :
				  	<select name="acc_st5" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getAcc_st5().equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(pur.getAcc_st5().equals("2")) out.println("selected");%>>�������</option>
        			  </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='cardno5' value='<%=pur.getCardno5()%>' size='20' class='text'>
					&nbsp;
					������ : 
        			<input type='text' name='trf_cont5' value='<%=pur.getTrf_cont5()%>' size='20' class='text'>
        			<br>
        			&nbsp;
        			���޿�û�� :
        			<input type='text' name='trf_est_dt5' value='<%= AddUtil.ChangeDate2(pur.getTrf_est_dt5())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
				    <!--<input type="button" class="button" id="b_tmp_ins_amt" value='�����ػ� ����� ����' onclick="javascript:OpenImg('/acar/images/center/tmp_ins_amts.jpg');">-->
    			</td>				
              </tr>    
  
            </table>
        </td>
    </tr>
    <tr>
	    <td>* ������ҿ� ������ �� �ӽÿ��ຸ��Ḧ ������ ī��/���������� �Է��Ͻʽÿ�.(Ư���� ����) ���θ��� ���´� ����� �� �����ϴ�. ī��� ���޼��ܰ� ���޿�û�ϸ� �Է��Ͻʽÿ�. </td>
    </tr>
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>
	<tr>
        <td>&nbsp;</td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="100" frameborder="0" noresize></iframe>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script language="JavaScript">
<!--	

	
 	var fm = document.form1;
 	
 	//������ �������� �鼼������ ����Ʈ ó��
 	<%if(car.getCar_origin().equals("2")){%>
 	fm.car_f_amt.value = parseDecimal(<%=cm_bean.getCar_b_p2()%> + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
 	set_car_amt(fm.car_f_amt);
 	<%if(base.getCar_st().equals("3")){%>
 	fm.dc_c_amt.value = <%=cm_bean.getL_dc_amt()%>;
 	<%}else{%>
 	fm.dc_c_amt.value = <%=cm_bean.getR_dc_amt()%>;
 	<%}%>
 	fm.s_dc1_re.value = '�Ǹ�����������';
 	fm.s_dc1_yn.value = 'Y';
 	fm.s_dc1_amt.value = fm.dc_c_amt.value;
 	set_car_amt(fm.dc_c_amt);
 	<%}%>
	
	if(fm.bas_dt.value == ''){
		fm.bas_dt.value = '<%=AddUtil.ChangeDate2(base.getReg_dt())%>';
	}
	
	fm.opt_chk[0].checked = true;
	
	cng_input();
	
	//��õ�������
	fm.car_ext.value = '7';		//20130130 ��� ��õ���
	
	<%if(ej_bean.getJg_g_7().equals("3")){//�������� ������%>
	fm.car_ext.value = '1';
	<%}%>	
	<%if(ej_bean.getJg_g_7().equals("4")){//�������� ������ 20190701 ��õ���%>
	fm.car_ext.value = '1';
	<%}%>	

	
	//20120901���� ���������� �ִ�3% �̳����� ���ð���
	fm.comm_rt.value = 3.0;
	fm.v_comm_rt.value = fm.comm_rt.value;
	fm.comm_r_rt.value = 0.0;
	fm.v_comm_r_rt.value = 0.0;
	
	//20191212
	if('<%=cm_bean.getJg_code()%>'=='9133' || '<%=cm_bean.getJg_code()%>'=='9015435' || '<%=cm_bean.getJg_code()%>'=='9015436' || '<%=cm_bean.getJg_code()%>'=='9015437'){
		sum_car_c_amt();
		sum_car_f_amt();
	}		
	
	//20190605 �׽��� ���� ���� - 20190801 �ʰ��δ�� 450�� ����
<%-- 	if('<%=cm_bean.getJg_code()%>'=='4854' || '<%=cm_bean.getJg_code()%>'=='5866' || '<%=cm_bean.getJg_code()%>'=='3871' || '<%=cm_bean.getJg_code()%>'=='4314111' || '<%=cm_bean.getJg_code()%>'=='6316111' || '<%=cm_bean.getJg_code()%>'=='3313111' || '<%=cm_bean.getJg_code()%>'=='3313112' || '<%=cm_bean.getJg_code()%>'=='3313113' || '<%=cm_bean.getJg_code()%>'=='3313114'){ --%>
	if('<%=cm_bean.getCar_comp_id()%>'=='0056'){
	//	fm.con_mon.value = '36';
	//	fm.agree_dist.value = '20000';
		fm.over_run_amt.value = '450';
	}		
	
	//���Ҽ������
	var ch_327 = 0;		
	var ch_315 = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value)); 
	var ch_326 = ch_315/(1+<%=ej_bean.getJg_3()%>);
	var bk_122 = 0;
	<%if(!ej_bean.getJg_w().equals("1")){%>
	<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
	if(<%=ej_bean.getJg_3()%>*100 > 0){
		//if('<%=ej_bean.getJg_2()%>'=='1') ch_326 = ch_315; //�Ϲݽ¿�LPG�϶�
		
		if('<%=ej_bean.getJg_g_7()%>'=='1') bk_122 = 1300000;
		if('<%=ej_bean.getJg_g_7()%>'=='2') bk_122 = 1300000;
		if('<%=ej_bean.getJg_g_7()%>'=='3') bk_122 = 3900000;
		if('<%=ej_bean.getJg_g_7()%>'=='4') bk_122 = 5200000;
		if(ch_315-ch_326<bk_122*1.1) 	ch_327 = ch_315-ch_326;
		else                         	ch_327 = bk_122*1.1;
		ch_327 = getCutRoundNumber(ch_327,0);
		if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111')	ch_327 = 0;//��ƮEV
		if('<%=cm_bean.getJg_code()%>'=='9133' || '<%=cm_bean.getJg_code()%>'=='9015435' || '<%=cm_bean.getJg_code()%>'=='9015436' || '<%=cm_bean.getJg_code()%>'=='9015437')	ch_327 = 0;//�����Ϸ�Ʈ��
		fm.tax_dc_amt.value 	= parseDecimal(ch_327);
		set_car_amt(fm.tax_dc_amt);
	}
  	<%	}%>
  	<%}%>
  
	//���Ҽ� �ѽ��� ���� 20200301~20200630
	var bk_175 = 0.7;     //������
	var bk_176 = 1430000; //���Ҽ� ���� �ѵ�(����������,�ΰ�������)
	var bk_177 = 0;
	<%if(!ej_bean.getJg_w().equals("1")){ //����������%>
	<%		if(cm_bean.getDuty_free_opt().equals("1")){//�鼼��ǥ������ ����%>
	<%		}else{%>
				if(ch_315<33471429){
					bk_177 = ch_326*<%=ej_bean.getJg_3()%>*bk_175;	
				}else{
					bk_177 = bk_176;
				}	
				bk_177 = getCutRoundNumber(bk_177,-4);
				if('<%=cm_bean.getJg_code()%>'=='2361' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='5033111')	bk_177 = 0;//��ƮEV
	<%		}%>
	<%}%>
	//20200701 ��������
	bk_177 = 0;
	
	//���� ������ �����Һ�(�����ѵ� �ʰ��ݾ�) 20210101~20210630**********************
  	var bk_216 = 0;
  	if(<%=base.getRent_dt()%> >= 20210101){
  	<%if(!ej_bean.getJg_w().equals("1")){ //����������%>
  	<%		if(cm_bean.getDuty_free_opt().equals("1")){//�鼼��ǥ������ ����%>
  	<%		}else{%>
				if(ch_315-ch_326>0 && ch_326/1.1>66666666){
					bk_216 = ((ch_326/1.1)-66666666) * 0.0195 * 1.1;	
				}	    					
				bk_216 = getCutRoundNumber(bk_216,-4);						
  	<%		}%>
  	<%}%>
  	}
	
	var ch327Nbk177 = ch_327;
  	
  	if(bk_177>0){
  		if(ch_315-ch_326<bk_177+(bk_122*1.1)) 	ch327Nbk177 = ch_315-ch_326;
		else                         			ch327Nbk177 = bk_177+(bk_122*1.1);
  		
  		fm.tax_dc_amt.value 	= parseDecimal(ch327Nbk177);
		set_car_amt(fm.tax_dc_amt);
		tr_ecar_dc.style.display	= '';  		
  	}
  	if(bk_216>0){
  		if(ch_315-ch_326<-bk_216+(bk_122*1.1)) 	ch327Nbk177 = ch_315-ch_326;
		else                         			ch327Nbk177 = -bk_216+(bk_122*1.1);
  		
  		fm.tax_dc_amt.value 	= parseDecimal(ch327Nbk177);
		set_car_amt(fm.tax_dc_amt);
		tr_ecar_dc.style.display	= '';  		
  	}
  	
  	
  
  	
	sum_car_c_amt();
	sum_car_f_amt();
	sum_tax_amt();
	set_insur_serv();
	sum_pp_amt();	
	
	
	//�ݿø�
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}	
	
	// �������ｺƼĿ �߱� ���� �� ��������� ����� �ڵ� ����
	$("#eco_e_tag").change(function() {
		if($("#eco_e_tag").val() == "1"){
			$("#car_ext").val("1").prop("selected", true);
		}
	});
	
	//������ �ε� �� ��������� ���޿��� �ʱ�ȭ		2017. 12. 06
	document.addEventListener("DOMContentLoaded", function(){
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		if(dlv_con_commi_yn_val == "Y"){															// ��������� ���޿��� -> ���� ����
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// ����� -> ��ü��� ����
			$("input[name='one_self']:radio[value='N']").prop("disabled", true);		// ����� -> ���������� ��Ȳ��ȭ
		}else if(dlv_con_commi_yn_val == "N"){													// ��������� ���޿��� -> ���� �� ���
			$("input[name='one_self']:radio[value='N']").prop("disabled", false);	// ����� -> ���������� Ȱ��ȭ
			$("input[name='one_self']:radio[value='N']").prop("checked", true);	// ����� -> ���������� ����
		}
	});
	
	// ���������		2017. 12. 06
	var one_self_no = $("input[name='one_self']:radio[value='N']");		// ����� ����������
	$("input[name=dlv_con_commi_yn]").change(function(){
		if($(this).val() == "Y"){																			// �������п��� �����������, ������Ʈ ���� �� > ��������� ���޿��� ���� ���� ��
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// ����� ��ü��� ����
			one_self_no.prop("disabled", true);														// ����� ���������� ��Ȱ��ȭ
		}else{																										// �������п��� �����������, ������Ʈ ���� �� > ��������� ���޿��� ���� ���� ��
			one_self_no.prop("disabled", false);														// ����� ���������� Ȱ��ȭ
			one_self_no.prop("checked", true);														// ����� ���������� ����
		}
	});	
	
//-->
</script>
</body>
</html>
