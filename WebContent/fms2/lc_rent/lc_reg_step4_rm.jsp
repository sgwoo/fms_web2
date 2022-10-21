<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, card.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.con_ins.*, acar.secondhand.*, acar.offls_pre.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="ins" class="acar.con_ins.InsurBean" scope="page"/>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�ڵ����⺻����-�⺻����
	CarMstBean cm_bean2 = new CarMstBean();
	if(!cm_bean.getCar_b_inc_id().equals("")){
		cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	}
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//��������
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");

	//����Ʈ����
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//�ſ�ī�� �ڵ����
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
	
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP", "Y");
	int user_size = users.size();
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
	
	//�ֱ� Ȩ������ ����뿩��
	Hashtable hp = oh_db.getSecondhandCaseRm("", "", base.getCar_mng_id());	
		 
	//��������
	String est_id = String.valueOf(hp.get("RM1_ID"));
	if(est_id.equals("") || est_id.equals("null")){
		est_id = shDb.getSearchEstIdShRm(base.getCar_mng_id(), "21", "1", "", String.valueOf(hp.get("REAL_KM")), String.valueOf(hp.get("UPLOAD_DT")), String.valueOf(hp.get("RM1")), String.valueOf(hp.get("REG_CODE")));
	}
	e_bean = e_db.getEstimateShCase(est_id);		

	out.println("est_id="+est_id);
	out.println("rm="+String.valueOf(hp.get("RM1")));

		 
	Hashtable sh_ht = new Hashtable();
	Hashtable sh_ht2 = new Hashtable();
	Hashtable carOld = new Hashtable();
	
	//��������
	sh_ht = shDb.getShBase(base.getCar_mng_id());
	//������� ����Ⱓ(����)
	carOld 	= c_db.getOld(cr_bean.getInit_reg_dt());		
	//��������
	sh_ht2 = shDb.getBase(base.getCar_mng_id(), base.getRent_dt(), (String)sh_ht.get("SERV_DT"));	
	
	String print_car_st_yn = "";
	Hashtable tax_print_car = al_db.getTaxPrintCarStChk(base.getClient_id());	
	if(
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409") 
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
	 ){//'100','101','601','602','701','702','801','802','803','811','812'	
	 	print_car_st_yn = "Y";
	 }	
	
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
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step3.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		

	//�ڵ���������� ����
	function view_car()
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}	
		
	//�뿩�Ⱓ ����
	function set_cont_date(obj){
		var fm = document.form1;

		if(obj == fm.con_mon || obj == fm.con_day){
					
			fm.v_con_mon.value = fm.con_mon.value;
			fm.v_con_day.value = fm.con_day.value;					
			
			set_sum_amt();	
		}
			
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
		
		var car_price 	= toInt(parseDigit(fm.sh_amt.value));
		
		//������---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value = fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value = replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			}

		//����뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//����뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();			
		}else if(obj==fm.inv_v_amt){ 	//����뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.inv_amt){ 	//����뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			dc_fee_amt();			
		//D/C---------------------------------------------------------------------------------
		}else if(obj==fm.dc_s_amt){ 	//D/C ���ް�
			obj.value = parseDecimal(obj.value);
			fm.dc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) * 0.1 );
			fm.dc_amt.value	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));			
			dc_fee_amt();			
		}else if(obj==fm.dc_v_amt){ 	//D/C �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.dc_amt.value	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.dc_amt){ 	//D/C �հ�
			obj.value = parseDecimal(obj.value);
			fm.dc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_amt.value))));
			fm.dc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)));			
			dc_fee_amt();			
		//������̼�---------------------------------------------------------------------------------
		}else if(obj==fm.navi_s_amt){ 	//������̼� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) * 0.1 );
			fm.navi_amt.value	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));			
		}else if(obj==fm.navi_v_amt){ 	//������̼� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.navi_amt.value	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));			
		}else if(obj==fm.navi_amt){ 	//������̼� �հ�
			obj.value = parseDecimal(obj.value);
			fm.navi_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.navi_amt.value))));
			fm.navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_amt.value)) - toInt(parseDigit(fm.navi_s_amt.value)));			
		//��Ÿ---------------------------------------------------------------------------------
		}else if(obj==fm.etc_s_amt){ 	//��Ÿ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) * 0.1 );
			fm.etc_amt.value	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));			
		}else if(obj==fm.etc_v_amt){ 	//��Ÿ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.etc_amt.value	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));			
		}else if(obj==fm.etc_amt){ 	//��Ÿ �հ�
			obj.value = parseDecimal(obj.value);
			fm.etc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.etc_amt.value))));
			fm.etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_amt.value)) - toInt(parseDigit(fm.etc_s_amt.value)));			
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.cons1_s_amt){ 	//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.cons1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) * 0.1 );
			fm.cons1_amt.value	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));			
		}else if(obj==fm.cons1_v_amt){ 	//������ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.cons1_amt.value	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));			
		}else if(obj==fm.cons1_amt){ 	//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.cons1_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.cons1_amt.value))));
			fm.cons1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_amt.value)) - toInt(parseDigit(fm.cons1_s_amt.value)));			
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.cons2_s_amt){ 	//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.cons2_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) * 0.1 );
			fm.cons2_amt.value	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));			
		}else if(obj==fm.cons2_v_amt){ 	//������ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.cons2_amt.value	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));			
		}else if(obj==fm.cons2_amt){ 	//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.cons2_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.cons2_amt.value))));
			fm.cons2_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_amt.value)) - toInt(parseDigit(fm.cons2_s_amt.value)));			
		}
		
		set_sum_amt();	
		
	}	
	
	//�հ���
	function set_sum_amt(){
		var fm = document.form1;
		
		var amt_per = 0;
		
		//������
		var amt_per = 0;									
		if(toInt(fm.con_mon.value)==1){
			amt_per = (4/100)*toInt(fm.con_day.value)/30;
		}		
		if(toInt(fm.con_mon.value)==2){
			amt_per = (4/100) + ((2/100)*toInt(fm.con_day.value)/30);
		}							
		if(toInt(fm.con_mon.value) > 2){
			amt_per = 6/100;
		}					
		amt_per = parseDecimal(amt_per*1000)/1000;				
		fm.amt_per.value = amt_per;	
		
		fm.inv_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 ) ;
		fm.inv_amt.value 	= parseDecimal( toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)) );
				
		
		//���뿩�� �հ�
		fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.navi_s_amt.value))+ toInt(parseDigit(fm.etc_s_amt.value)));
		fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) - toInt(parseDigit(fm.dc_v_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value))+ toInt(parseDigit(fm.etc_v_amt.value)));
		fm.fee_amt.value   = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)) );
		//�뿩�� �Ѿ�
		fm.t_fee_s_amt.value = parseDecimal((toInt(parseDigit(fm.fee_s_amt.value))*toInt(fm.con_mon.value)) + (toInt(parseDigit(fm.fee_s_amt.value))/30*toInt(fm.con_day.value)));
		fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) * 0.1 );
		fm.t_fee_amt.value   = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) + toInt(parseDigit(fm.t_fee_v_amt.value)) );
		//�հ�
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)));
		fm.rent_tot_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		fm.rent_tot_amt.value   = parseDecimal(toInt(parseDigit(fm.rent_tot_s_amt.value)) + toInt(parseDigit(fm.rent_tot_v_amt.value)) );
		
		f_paid_way_display();
	}		
	
	//�뿩�� DC�� ���
	function dc_fee_amt(){
		var fm = document.form1;
		
		var inv_amt	= toInt(parseDigit(fm.inv_s_amt.value))+toInt(parseDigit(fm.inv_v_amt.value));		//����뿩��
		var dc_amt	= toInt(parseDigit(fm.dc_s_amt.value))+toInt(parseDigit(fm.dc_v_amt.value));		//DC�ݾ�
		var dc_ra;
						
		if(inv_amt > 0 && dc_amt > 0){			
			dc_ra = replaceFloatRound(dc_amt / inv_amt );
			fm.dc_ra.value = dc_ra;
		}
	}		
		
	//������̼�����
	function obj_display(st, value){
		var fm = document.form1;	
		
		if(st == 'navi'){
			if(value == 'Y'){
				fm.navi_s_amt.value 	= '25,000';
				fm.navi_v_amt.value 	= '2,500';
				fm.navi_amt.value	= '27,500';		
			}else if(value == 'N'){
				fm.navi_s_amt.value 	= '0';
				fm.navi_v_amt.value 	= '0';
				fm.navi_amt.value	= '0';		
			}	
		}else if(st == 'cons1'){
			if(value == 'Y'){
				fm.cons1_s_amt.value 	= '20,000';
				fm.cons1_v_amt.value 	= '2,000';
				fm.cons1_amt.value	= '22,000';		
			}else if(value == 'N'){
				fm.cons1_s_amt.value 	= '0';
				fm.cons1_v_amt.value 	= '0';
				fm.cons1_amt.value	= '0';		
			}
		}else if(st == 'cons2'){
			if(value == 'Y'){
				fm.cons2_s_amt.value 	= '20,000';
				fm.cons2_v_amt.value 	= '2,000';
				fm.cons2_amt.value	= '22,000';		
			}else if(value == 'N'){
				fm.cons2_s_amt.value 	= '0';
				fm.cons2_v_amt.value 	= '0';
				fm.cons2_amt.value	= '0';		
			}				
		}
		set_sum_amt();			
	}	
	
	//���ʰ������ ����
	function f_paid_way_display(){
		var fm = document.form1;
		
		//1����ġ
		if(fm.f_paid_way.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		//�Ѿ�	
		}else if(fm.f_paid_way.value == '2'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		}
		
		//������ �������Կ���
		if(fm.f_paid_way2.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.f_rent_tot_amt.value)) + toInt(parseDigit(fm.cons2_amt.value)));
		}					
	}				

	function search_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}

	function search_card_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_card_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}
	
	//���
	function save(){
		var fm = document.form1;
				
		if(fm.driving_age.value == '')				{ alert('�������-�����ڿ����� �Է��Ͻʽÿ�.'); 			fm.driving_age.focus(); 	return; }
		
		<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	 
			if(fm.com_emp_yn.value == '')					{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');		fm.com_emp_yn.focus(); 		return; }
		<%}else if(AddUtil.parseInt(client.getClient_st()) >2 && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
			//���λ���� ������������ ���Ѿ���
			if(fm.com_emp_yn.value == '')					{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');		fm.com_emp_yn.focus(); 		return; }
		<%}else{%>
			if(fm.com_emp_yn.value == 'Y')				{ alert('�������-��������������Ư�� ���Դ���� �ƴѵ� �������� �Ǿ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');	fm.com_emp_yn.focus(); 	return; }
		<%}%>
				
		if(fm.gcp_kd.value == '')				{ alert('�������-�빰��� ���Աݾ��� �Է��Ͻʽÿ�.'); 			fm.gcp_kd.focus(); 		return; }
		if(fm.bacdt_kd.value == '')				{ alert('�������-�ڱ��ü��� ���Աݾ��� �Է��Ͻʽÿ�.'); 		fm.bacdt_kd.focus(); 		return; }
		if(fm.canoisr_yn.value == '')				{ alert('�������-������������ ���Կ��θ� �Է��Ͻʽÿ�.'); 		fm.canoisr_yn.focus(); 		return; }
		if(fm.cacdt_yn.value == '')				{ alert('�������-�ڱ��������� ���Կ��θ� �Է��Ͻʽÿ�.'); 		fm.cacdt_yn.focus(); 		return; }
		if(fm.eme_yn.value == '')				{ alert('�������-����⵿ ���Կ��θ� �Է��Ͻʽÿ�.'); 			fm.eme_yn.focus(); 		return; }
		

		<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
		if(fm.driving_age.value=='1' && fm.age_scp.value!='1')	{ alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';}
		if(fm.driving_age.value=='3' && fm.age_scp.value!='4')	{ alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}
		if(fm.driving_age.value=='0' && fm.age_scp.value!='2')	{ alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}
		if(fm.driving_age.value=='2' && fm.age_scp.value!='3')	{ alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}
		if(fm.driving_age.value=='5' && fm.age_scp.value!='5')	{ alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}			
		if(fm.driving_age.value=='6' && fm.age_scp.value!='6')	{ alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}			
		if(fm.driving_age.value=='7' && fm.age_scp.value!='7')	{ alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}			
		if(fm.driving_age.value=='8' && fm.age_scp.value!='8')	{ alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}												
			
		if(fm.gcp_kd.value=='3' && fm.vins_gcp_kd.value!='6')	{ alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk2.value =	'���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.';		}
		if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3')	{ alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk2.value =	'���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.';		}
		if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4')	{ alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk2.value =	'���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.';		}
		if(fm.gcp_kd.value=='4' && fm.vins_gcp_kd.value!='7')	{ alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk2.value =	'���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.';		}			
			
		if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){ alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk3.value =	'���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.';	}
		if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){ alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk3.value =	'���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.';	}
		if(fm.bacdt_kd.value=='9' && fm.vins_bacdt_kd.value!='9'){ alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk3.value =	'���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.';	}
		
		if(fm.con_f_nm.value=='1' && fm.insur_per.value!='1')	{ alert('���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk4.value =	'���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.';		}
		if(fm.con_f_nm.value=='2' && fm.insur_per.value!='2')	{ alert('���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk4.value =	'���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.';		}
		<%}%>		
		
		var car_ja 	= toInt(parseDigit(fm.car_ja.value));
		
		if(car_ja == 0)						{ alert('�������-������å���� �Է��Ͻʽÿ�.'); 		fm.car_ja.focus(); 		return; }
		<%if(car.getCar_origin().equals("2")){//������%>
		if(fm.car_ja.value != fm.imm_amt.value){
			if(fm.ja_reason.value == '')			{ alert('�������-������å�� ��������� �Է��Ͻʽÿ�.'); 	fm.ja_reason.focus(); 		return; }
			if(fm.rea_appr_id.value == '')			{ alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.'); 	fm.rea_appr_id.focus(); 	return; }
		}
		<%}else{%>
		if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'){
			if(fm.ja_reason.value == '')			{ alert('�������-������å�� ��������� �Է��Ͻʽÿ�.'); 	fm.ja_reason.focus(); 		return; }
			if(fm.rea_appr_id.value == '')			{ alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.'); 	fm.rea_appr_id.focus(); 	return; }
		}			
		<%}%>			
			
		
		if(fm.con_mon.value == '')				{ alert('�뿩���-�̿�Ⱓ�� �Է��Ͻʽÿ�.'); 			fm.con_mon.focus(); 		return; }
		
				
		var fee_amt 	= toInt(parseDigit(fm.fee_amt.value));
		var inv_amt 	= toInt(parseDigit(fm.inv_amt.value));		
		var agree_dist 	= toInt(parseDigit(fm.agree_dist.value));
		var over_run_amt= toInt(parseDigit(fm.over_run_amt.value));		
		
		if(inv_amt == 0)	{ alert('�뿩���-����뿩�Ḧ �Է��Ͻʽÿ�.'); 	fm.inv_amt.focus(); 		return; }
		if(fee_amt == 0)	{ alert('�뿩���-���뿩�Ḧ Ȯ���Ͻʽÿ�.'); 		fm.inv_amt.focus(); 		return; }
		if(agree_dist == 0)	{ alert('�뿩���-��������Ÿ��� �Է��Ͻʽÿ�.'); 	fm.agree_dist.focus(); 		return; }
		if(over_run_amt == 0)	{ alert('�뿩���-�ʰ�����δ���� �Է��Ͻʽÿ�.'); 	fm.over_run_amt.focus(); 	return; }
		
		if(fm.f_paid_way.value == '')				{ alert('�뿩���-���ʰ�������� �Է��Ͻʽÿ�.');		fm.f_paid_way.focus(); 		return; }
		if(toInt(parseDigit(fm.f_rent_tot_amt.value)) == '0')	{ alert('�뿩���-���ʰ����ݾ��� �Է��Ͻʽÿ�.'); 		fm.f_rent_tot_amt.focus(); 	return; }						
		
		if(toInt(fm.cls_r_per.value) < 1)			{ alert('�뿩���-�ߵ����������� Ȯ���Ͻʽÿ�.'); 		fm.cls_r_per.focus(); 		return; }	
			
		if(fm.fee_pay_tm.value == '')				{ alert('�뿩���-����Ƚ���� �Է��Ͻʽÿ�.'); 			fm.fee_pay_tm.focus(); 		return; }
		if(fm.fee_sh.value == '')				{ alert('�뿩���-���ݱ��и� �Է��Ͻʽÿ�.'); 			fm.fee_sh.focus(); 		return; }
		if(fm.fee_pay_st.value == '')				{ alert('�뿩���-���ι���� �Է��Ͻʽÿ�.'); 			fm.fee_pay_st.focus(); 		return; }		
		if(fm.def_st.value == '')				{ alert('�뿩���-��ġ���θ� �Է��Ͻʽÿ�.'); 			fm.def_st.focus(); 		return; }
		if(fm.def_st.value == 'Y'){
			if(fm.def_remark.value == '')			{ alert('�뿩���-��ġ������ �Է��Ͻʽÿ�.');			fm.def_remark.focus();		return; }
			if(fm.def_sac_id.value == '')			{ alert('�뿩���-��ġ �����ڸ� �Է��Ͻʽÿ�.');		fm.def_sac_id.focus();		return; }
		}
			
		if(fm.fee_pay_st.value == '1'){
			if(fm.cms_bank_cd.value == '')	{ alert('�뿩���-CMS �ŷ������� �Է��Ͻʽÿ�.'); 		fm.cms_bank_cd.focus(); 		return; }
			if(fm.cms_acc_no.value == '')		{ alert('�뿩���-CMS ���¹�ȣ�� �Է��Ͻʽÿ�.'); 		fm.cms_acc_no.focus(); 		return; }
			if(fm.cms_acc_no.value != '')		{ 
				fm.cms_acc_no.value = replaceString(" ","",fm.cms_acc_no.value);
				if ( !checkInputNumber("CMS ���¹�ȣ", fm.cms_acc_no.value) ) {		
					fm.cms_acc_no.focus(); 		return; 
				}
				//�޴���,����ó ���Ͽ��� Ȯ��
				if(replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getM_tel()%>") || replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getO_tel()%>")){
					alert("���¹�ȣ�� �޴��� Ȥ�� ����ó�� �����ϴ�. ������¹�ȣ�� �ڵ���ü�� �ȵ˴ϴ�.");
					fm.cms_acc_no.focus(); 		return; 
				}
			}
			if(fm.cms_dep_nm.value == '')			{ alert('�뿩���-CMS �����ָ� �Է��Ͻʽÿ�.'); 		fm.cms_dep_nm.focus(); 		return; }				
			if(fm.cms_dep_ssn.value == '')			{ alert('�뿩���-CMS ������ �������/����ڹ�ȣ�� �Է��Ͻʽÿ�.'); fm.cms_dep_ssn.focus(); 	return; }
			
			//������ ��������� 6�ڸ�			
			if(replaceString("-","",fm.cms_dep_ssn.value).length == 8){
				alert('�뿩���-CMS ������ ��������� 6�ڸ��Դϴ�.'); return;
			}
			
			if(fm.c_cms_acc_no.value != '')		{ 
				fm.c_cms_acc_no.value = replaceString(" ","",fm.c_cms_acc_no.value);
				if ( !checkInputNumber("ī���ȣ", fm.c_cms_acc_no.value) ) {		
					fm.c_cms_acc_no.focus(); 		return; 
				}
			}
		}
			
		if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ fm.tax_type[0].checked = true; }
		
		if(fm.rec_st.value == '')				{ alert('���ݰ�꼭-û�������ɹ���� �Է��Ͻʽÿ�.');		fm.rec_st.focus(); 		return; }
		if(fm.rec_st.value == '1'){
			if(fm.ele_tax_st.value == '')			{ alert('���ݰ�꼭-���ڼ��ݰ�꼭 �ý����� �Է��Ͻʽÿ�.'); 	fm.ele_tax_st.focus();		return; }
			if(fm.ele_tax_st.value == '2'){
				if(fm.tax_extra.value == '')		{ alert('���ݰ�꼭-���ڼ��ݰ�꼭 �����ý��� �̸��� �Է��Ͻʽÿ�.'); fm.tax_extra.focus(); 	return; }
			}
			<%	if(print_car_st_yn.equals("Y")){%>
			if(fm.print_car_st.value == '')			{ alert('���ݰ�꼭-��꼭�������౸���� �Է��Ͻʽÿ�.'); 	fm.print_car_st.focus();	return; }
			<%	}%>
		}
		
		//������
		var amt_per = 0;									
		if(toInt(fm.con_mon.value)==1){
			amt_per = (4/100)*toInt(fm.con_day.value)/30;
		}		
		if(toInt(fm.con_mon.value)==2){
			amt_per = (4/100) + ((2/100)*toInt(fm.con_day.value)/30);
		}							
		if(toInt(fm.con_mon.value) > 2){
			amt_per = 6/100;
		}					
		amt_per = parseDecimal(amt_per*1000)/1000;				
		fm.amt_per.value = amt_per;		
			
		
		if(confirm('4�ܰ踦 ����Ͻðڽ��ϱ�?')){	
			fm.action='lc_reg_step4_rm_a.jsp';		
			//fm.target='i_no';
			fm.submit();
		}							
	}
	
	function set_loc(loc_num, st){
		var fm = document.form1;	
		var loc_nm = '';
		
		if(loc_num == '1')		loc_nm = '����������';
		else if(loc_num == '2')		loc_nm = '�������� ������';
		else if(loc_num == '3')		loc_nm = '�λ����� ������';
		else if(loc_num == '4')		loc_nm = '�������� ������';
		else if(loc_num == '5')		loc_nm = '�뱸���� ������';
						
		if(loc_nm != ''){
			if(st == 'deli')		fm.deli_loc.value = loc_nm;
			else if(st == 'ret')		fm.ret_loc.value = loc_nm;
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
<body leftmargin="15">
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name="mode"			value="lc_rent">
  <input type='hidden' name="rent_dt"			value="">  
  <input type='hidden' name="rent_st"			value="1">  
  <input type='hidden' name="a_b"			value="">
  <input type='hidden' name="fee_opt_amt"		value="">
  <input type='hidden' name="cust_sh_car_amt"	value="">
</form>
<form action='lc_reg_step4_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="old_rent_mng_id" 		value="<%=old_rent_mng_id%>">
  <input type='hidden' name="old_rent_l_cd" 		value="<%=old_rent_l_cd%>">
  <input type='hidden' name="opt"			value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"			value="<%=cm_bean.getCar_b()%><%=cm_bean2.getCar_b()%>">
  <input type='hidden' name="s_st" 			value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="rent_way" 			value="<%=fee.getRent_way()%>">  
  <input type='hidden' name="dpm" 			value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="car_end_dt"		value="<%=cr_bean.getCar_end_dt()%>">
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
  <input type='hidden' name='est_id' 			value='<%=est_id%>'>
  <input type='hidden' name="amt_per"			value="">  
                   
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
					<select name="bus_st">
                        <option value="">����</option>
                        <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>���ͳ�</option>
                        <option value="8" <%if(base.getBus_st().equals("8")){%>selected<%}%>>�����</option>
                        <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>��ȭ���</option>                        
                        <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>�������</option>
                        <option value="7" <%if(base.getBus_st().equals("7")){%>selected<%}%>>������Ʈ</option>                        
                        <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>������ü</option>
                        <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>��ü�Ұ�</option>
                        <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog</option>
                        
                      </select>					
					</td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}else if(car_gu.equals("3")){%>����Ʈ<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<b><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("4")){%>����Ʈ<%}else if(car_st.equals("5")){%>�����뿩<%}%></b></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<b><%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></b></td>
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
    		    <%if(!cr_bean.getCar_no().equals("")){%>
    		    <tr>
        		    <td width='13%' class='title'> ������ȣ </td>
        		    <td width="20%">&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a></td>
                	<td class='title' width="10%">������ȣ</td>
        		    <td>&nbsp;<%=cr_bean.getCar_doc_no()%>&nbsp;(<%String car_ext = cr_bean.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>)</td>
        		    <td width="10%" class='title'><%if(cr_bean.getCar_use().equals("1")){%>���ɸ�����<%}else{%>���ʵ����<%}%></td>
        		    <td>&nbsp;<%if(cr_bean.getCar_use().equals("1")){%><font color=red><b><%=cr_bean.getCar_end_dt()%></b></font><%}else{%><%=cr_bean.getInit_reg_dt()%><%}%></td>
    		    </tr>			  
    		    <tr>
        		    <td class='title'> �˻���ȿ�Ⱓ </td>
        		    <td>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%></b></td>
                	<td class='title'>������ȿ�Ⱓ</td>
        		    <td colspan='3'>&nbsp;<b><%=cr_bean.getTest_st_dt()%>~<%=cr_bean.getTest_end_dt()%></b></td>
    		    </tr>			  
    		    <%}%>	  
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
                    <td>&nbsp;<%=cr_bean.getDpm()%>cc</td>
                </tr>
                <tr>
                    <td class='title'>�⺻���</td>
                    <td colspan="5" align=center>
                        <table width=98% cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td>
        			  <%if(!cm_bean2.getCar_name().equals("")){%><span title='<%=cm_bean2.getCar_b()%>'><font color='#999999'><%=cm_bean2.getCar_name()%>��&nbsp;</font></span><%}%>
        			  <%=cm_bean.getCar_b()%></td>
        			        <tr>
                                <td style='height:3'></td>
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
                      <input type='text' name='color' size='50' class='whitetext' value='<%=car.getColo()%>'>
                      &nbsp;&nbsp;&nbsp;
					  (�������(��Ʈ): <input type='text' name="in_col" size='20' class='whitetext' value='<%=car.getIn_col()%>'> )                        
                      &nbsp;&nbsp;&nbsp;
					  (���Ͻ�: <input type='text' name="garnish_col" size='20' class='whitetext' value='<%=car.getGarnish_col()%>'> )                        
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
        <td class=h></td>
    </tr>    
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr id=tr_car0 style="display:''"> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> �����Һ��ڰ� </td>
                    <td width="20%">&nbsp;
        		<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT")))%>'size='10' class='defaultnum' readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
        		�� 
        		<input type='hidden' name="view_car_amt" value=""></td>
                    <td class='title' width="10%">�ܰ���</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='sh_ja' value=''size='4' class='defaultnum' readonly>%</td>
                    <td class='title' width='10%'>�߰�����</td>
                    <td>&nbsp;
                      <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(e_bean.getO_1()) %>'size='10' class='defaultnum' readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                      �� </td>
                </tr>
                <tr>
                    <td class='title'>����</td>
                    <td colspan="5">&nbsp;
			<input type='text' name='sh_year' value='<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("YEAR")%><%}%>'size='1' class='default' >
                        ��
                        <input type='text' name='sh_month' value='<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("MONTH")%><%}%>'size='2' class='default' >
                        ����
                        <input type='text' name='sh_day' value='<%if(!String.valueOf(carOld.get("YEAR")).equals("null")){%><%=carOld.get("DAY")%><%}%>'size='2' class='default' >
                        �� (
                        <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                        ~
                        <input type='text' name='sh_day_bas_dt' value='<%= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='default'  onBlur='javascript:this.value=ChangeDate(this.value);'>
                        )                  
					</td>
                </tr>
                <tr>
                  <td class='title'>����Ÿ�</td>
                  <td colspan="5">&nbsp;
				    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(e_bean.getToday_dist()) %>' class='defaultnum' >
                        km / Ȯ������Ÿ�
                          <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>' class='defaultnum' >
                        km (
                        <input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>' class='default'  onBlur='javascript:this.value=ChangeDate(this.value);'>
                        )
                        
					</td>
                </tr>
                <%if(!cr_bean.getDist_cng().equals("")){%>
                <tr>
                  <td class='title'>����Ǳ�ü</td>
                  <td colspan="5">&nbsp;
                    <font color=green><%=cr_bean.getDist_cng()%></font></td>
                </tr>                
                <%}%>                
            </table>
	    </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>
	<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
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
                    <td width="20%">&nbsp;
                        <select name='conr_nm' disabled>
                          <option value="1" <%if(ins.getConr_nm().equals("�Ƹ���ī")){%> selected <%}%>>�Ƹ���ī</option>
                          <option value="2" <%if(!ins.getConr_nm().equals("�Ƹ���ī")){%> selected <%}%>>��</option>
                        </select></td>				
                    <td width="10%" class=title >�Ǻ�����</td>
                    <td colspan='3'>&nbsp;
                        <select name='con_f_nm' disabled>
                          <option value="1" <%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%> selected <%}%>>�Ƹ���ī</option>
                          <option value="2" <%if(!ins.getCon_f_nm().equals("�Ƹ���ī")){%> selected <%}%>>��</option>
                        </select></td>		
                </tr>                  
                <tr>
                    <td width="13%" class=title >�����ڿ���</td>
                    <td width="20%">&nbsp;
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
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30���̻�</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35���̻�</option>				
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
                                <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000����&nbsp;&nbsp;&nbsp;</option>
                                <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000����</option>
                                <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500����</option>
                                <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000����</option>				
                              </select></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td>&nbsp;
                        <select name='vins_bacdt_kd' disabled>
                                <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3���</option>
                                <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1��5õ����</option>
                                <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1���</option>
                                <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000����</option>
                                <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000����</option>
                                <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500����</option>
                                <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>�̰���</option>
                              </select></td>
                </tr>
            </table>
	    </td>		
	</tr>
    <tr>
	    <td style='height:5'></td>
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;2. ��༭�� ������ ��������</td>
	</tr>		
	<%}%>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>��������</td>
                    <td width="20%">&nbsp;
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                      </select></td>
                    <td width="10%"  class=title>�Ǻ�����</td>
                    <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' onChange='javascript:display_ip()'>
                          <option value="">����</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <!--  <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>-->
                      </select></td>
                </tr>                        
              <tr> 
                <td width="13%" class=title>�����ڹ���</td>
                <td width="20%" class=''>&nbsp;
    				<select name='driving_ext'>
                      <option value="">����</option>
                      <option value="1" <%if(base.getDriving_ext().equals("1") || base.getDriving_ext().equals("")){%> selected <%}%>>�����</option>
                      <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>��������</option>
                      <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>��Ÿ</option>
                  </select>			
    			</td>
                <td width="10%" class=title >�����ڿ���</td>
                <td>&nbsp;
                    <select name='driving_age'>
                      <option value="">����</option>
                      <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26���̻�</option>
                      <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24���̻�</option>
                      <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21���̻�</option>
                      <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>��������</option>
					  <option value=''>=�Ǻ����ڰ�=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30���̻�</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35���̻�</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43���̻�</option>						
					  <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48���̻�</option>					  
                  </select></td>
                <td class=title >��������������Ư��</td>
                <td class=''>&nbsp;<%if(client.getClient_st().equals("1") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){ cont_etc.setCom_emp_yn("Y"); }%>
                  <select name='com_emp_yn'>
                    <option value="">����</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                  </select></td>                    
              </tr>
              <tr>
                <td  class=title>���ι��</td>
                <td>&nbsp; ����(���ι��,��)</td>
                <td class=title>�빰���</td>
                <td class=''>&nbsp;
                    <select name='gcp_kd'>
                      <option value="">����</option>
                      <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                      <option value="2" <% if(base.getGcp_kd().equals("2")||base.getGcp_kd().equals("")) out.print("selected"); %>>1���</option>
                      <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2���</option>
					  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3���</option>
                      <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5���</option>					  
                  </select></td>
                <td width="10%" class=title >�ڱ��ü���</td>
                <td class=''>&nbsp;
                    <select name='bacdt_kd'>
                      <option value="">����</option>
                      <!--<option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5õ����</option>-->
                      <option value="2" <% if(base.getBacdt_kd().equals("2")||base.getBacdt_kd().equals("")) out.print("selected"); %>>1���</option>
                      <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>�̰���</option>
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
                <td>&nbsp;<%if(base.getCar_ja()==0) base.setCar_ja(300000);%>
    			<input type='text' size='12' maxlength='10' name='car_ja' class='num' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			��</td>
                <td class=title>�������</td>
                <td class=''>&nbsp;
                  <input type='text' size='18' name='ja_reason' class='text' value='<%=cont_etc.getJa_reason()%>'></td>
                <td class=title >������</td>
                <td class=''>&nbsp;
                    <select name='rea_appr_id'>
                      <option value="">����</option>
                    <%if(user_size > 0){
    					for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); %>
                    <option value='<%=user.get("USER_ID")%>' <%if(cont_etc.getRea_appr_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%	}
    				}		%>
                  </select> 
                    (�⺻ <input type='text' size='6' maxlength='10' name='imm_amt' class='whitenum' value='<%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%>' readonly>��) </td>
              </tr>
              <tr>
                <td  class=title>���������</td>
                <td colspan='5'>&nbsp;
                    <select name="my_accid_yn">
                        <option value="Y" selected>���δ�</option>
                        <option value="N">����</option>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/���� ��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width="13%"  class=title>�����ð�</td>
                <td width="37%">&nbsp;<input type='text' size='11' name='deli_plan_dt' maxlength='10' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='deli_plan_h' class='default' value='00'>
                    ��
                    <input type='text' size='2' name='deli_plan_m' class='default' value='00'>
                    ��
                    </td>
                <td width="13%" class=title>�����ð�</td>
                <td width="37%" class=''>&nbsp;<input type='text' size='11' name='ret_plan_dt' maxlength='10' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='ret_plan_h' class='default' value='00'>
                    ��
                    <input type='text' size='2' name='ret_plan_m' class='default' value='00'>
                    ��
                    </td>
              </tr>
              <tr> 
                <td width="13%"  class=title>�������</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='deli_loc' class='default' value=''  onBlur="javscript:set_loc(this.value, 'deli');">
                      </td>
                <td width="13%" class=title>�������</td>
                <td width="37%" class=''>&nbsp;<input type='text' size='30' name='ret_loc' class='default' value=''   onBlur="javscript:set_loc(this.value, 'ret');">
                      </td>
              </tr>          
            </table>
        </td>
    </tr>	    
    <tr>
        <td>* ��/���� ��� ��ȣ �ڵ��Է� : 1 - ����������, 2 - �������� ������, 3 - �λ����� ������, 4 - �������� ������, 5 - �뱸���� ������ </td>
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
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                <td  >&nbsp; <!--width="26%"-->
                    <%if(AddUtil.parseInt(base.getRent_dt()) > 20140228){%>		
                    1����
        	    <input type='hidden' name="con_day"	value="0">      		 
        	    <input type='hidden' name="con_mon"	value="1">      		         			 
                    <%}else{%>                    
                    <input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 ����        	            	    
        	    <input type='text' name="con_day" value='<%=fee_etc.getCon_day()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 ��
        	    <%}%>		 
    	    	    <input type='hidden' name='rent_start_dt' value='<%=fee.getRent_start_dt()%>'>
		    <input type='hidden' name='rent_end_dt' value='<%=fee.getRent_end_dt()%>'>					 
					 (�뿩������ ���� �����뿩���� ó���Ҷ� �Է��մϴ�. ���� ����� 1�����Դϴ�.)		 
		 </td>		
		 <!--		
                <td width="13%" align="center" class=title>�뿩������</td>
                <td width="15%">&nbsp;
                  <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'></td>
                <td width="13%" align="center" class=title>�뿩������</td>
                <td width="20%">&nbsp;
                  <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fee.getRent_end_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>				
                  -->
              </tr>
            </table>
         </td>
    </tr>
    <tr></tr><tr></tr>
    <tr>
        <td class=line>      
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td colspan="2" class='title'>����</td>
                <td class='title' width='13%'>���ް�</td>
                <td class='title' width='13%'>�ΰ���</td>
                <td class='title' width='13%'>�հ�</td>
                <td class='title' width="28%">�������</td>
                <td class='title' width='20%'>��������</td>
              </tr>
             <tr>               
                <td colspan='2' class='title'>������</td>
                <td align='center'>-</td>
                <td align='center'>-</td>
                <td align='center'><input type='text' size='11' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">������
                    <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fee.getGur_p_per()%>' readonly>
    				  % </td>
                <td align='center'><input type='hidden' name='gur_per' value='0'><input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>'>
		    <%if(base.getRent_st().equals("3")){%>
			���� ������ �°迩�� :
			<select name='grt_suc_yn'>
                            <option value="">����</option>
                            <option value="0">�°�</option>
                            <option value="1">����</option>
                        </select>	
		    <%}else{%>		
		    -
		    <input type='hidden' name='grt_suc_yn' value=''>
		    <%}%>
		</td>
              </tr>       
              <%
              		if(fee.getInv_s_amt() == 0){
              			fee.setInv_s_amt(e_bean.getFee_s_amt());
              			fee.setInv_v_amt(e_bean.getFee_v_amt());
              		}
              %>       
              <tr>
                <td width="3%" rowspan="5" class='title'>��<br>
                  ��<br>��<br>��</td>
                <td width="10%" class='title'>����뿩��</td>
                 <td align="center"><input type='text' size='11' name='inv_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='inv_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='inv_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee.getInv_s_amt()+fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>

                <td align="center">-</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>D/C</td>
                <td align="center">-<input type='text' size='10' name='dc_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">-<input type='text' size='10' name='dc_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-<input type='text' size='10' name='dc_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt()+fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">DC��:
                  <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fee.getDc_ra()%>'>
                </font>%</span></td>
                <td align='center'>-</td>
              </tr>              
              <tr>
                <td class='title'>������̼�</td>
                <td align="center"><input type='text' size='11' name='navi_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='navi_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='navi_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">
                  <input type='radio' name="navi_yn" value='N' onclick="javascript:obj_display('navi','N')" <%if(fee_rm.getNavi_yn().equals("0")||fee_rm.getNavi_yn().equals("")){%> checked <%}%>>
                  ����
                  <input type='radio' name="navi_yn" value='Y' onclick="javascript:obj_display('navi','Y')" <%if(fee_rm.getNavi_yn().equals("1")){%> checked <%}%>>
    	 	  ����
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>��Ÿ</td>
                <td align="center"><input type='text' size='11' name='etc_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='etc_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='etc_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">
                    <input type='text' size='40' name='etc_cont' class='text' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>�հ�</td>
                <td align="center"><input type='text' size='11' name='fee_s_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='fee_v_amt' maxlength='10' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='fee_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">-</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>�뿩���Ѿ�</td>
                <td align="center"><input type='text' size='11' name='t_fee_s_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='t_fee_v_amt' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='t_fee_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' name="v_con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 ����
        	    <!--<input type='text' name="v_con_day" value='<%=fee_etc.getCon_day()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        	    ��-->
        	    <input type='hidden' name="v_con_day"	value="0">   
        			 </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>������</td>
                <td align="center"><input type='text' size='11' name='cons1_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='cons1_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='cons1_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">
                  <input type='radio' name="cons1_yn" value='N' onclick="javascript:obj_display('cons1','N')" <%if(fee_rm.getCons1_yn().equals("0")||fee_rm.getCons1_yn().equals("")){%> checked <%}%>>
                  ����
                  <input type='radio' name="cons1_yn" value='Y' onclick="javascript:obj_display('cons1','Y')" <%if(fee_rm.getCons1_yn().equals("1")){%> checked <%}%>>
    	 	  ���� 
    	 	</td>
                <td align='center'>
    			  
                </td>
              </tr>
              <tr>
                <td colspan="2" class='title'>������</td>
                <td align="center"><input type='text' size='11' name='cons2_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='cons2_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='cons2_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">
                  <input type='radio' name="cons2_yn" value='N' onclick="javascript:obj_display('cons2','N')" <%if(fee_rm.getCons2_yn().equals("0")||fee_rm.getCons2_yn().equals("0")){%> checked <%}%>>
                  ����
                  <input type='radio' name="cons2_yn" value='Y' onclick="javascript:obj_display('cons2','Y')" <%if(fee_rm.getCons2_yn().equals("1")){%> checked <%}%>>
    	 	  ���� 
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>�հ�</td>
                <td align="center"><input type='text' size='11' name='rent_tot_s_amt' maxlength='11' class='fixnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='rent_tot_v_amt' maxlength='10' class='fixnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='rent_tot_amt' maxlength='11' class='fixnum' value='' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"> </td>
                <td align='center'>-</td>
              </tr>              
              <tr id=tr_emp_bus style="display:''">
                <td rowspan="<%if(rent_st.equals("3")){%>4<%}else{%>3<%}%>" class='title'>��<br>Ÿ</td>                             
                <td class='title'><span class="title1">���ʰ����ݾ�</span></td>
                <td align='center'><input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>" size="11" class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��		  
                </td>                
                <td colspan='3'>&nbsp;&nbsp;&nbsp;
                     * ���ʰ������ : <select name="f_paid_way" onchange="javascript:f_paid_way_display();">
                        <option value="">==����==</option>			  
                        <option value="1">1����ġ</option>
                        <option value="2">�Ѿ�</option>
                      </select>
                      &nbsp; ������
                      <select name="f_paid_way2" onchange="javascript:f_paid_way_display();">
                        <option value="">==����==</option>
                        <option value="1">����</option>
                        <option value="2">������</option>
                      </select>          
                      &nbsp;&nbsp;&nbsp;
                      * ����� : <input type="text" name="f_con_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_con_amt())%>" size="11" class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��	
                  
                </td>                
                <td align='center'>-</td>
              </tr>  
              <tr>
                <td class='title'><span class="title1">��������Ÿ�</span></td>
                <td colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='agree_dist' size='8' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>'>
                  km����/1����,
                  �ʰ��� 1km�� (<input type='text' name='over_run_amt' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��)�� �߰������ �ΰ��˴ϴ�.
                </td>
                <td align='center'>-</td>
              </tr>                                   
              <tr>
                <td class='title'>�ߵ�����������</td>
                <td colspan="3" align="center">���̿�Ⱓ�� 1���� �̻��� ���</td>                
                <td align="center">�ܿ��Ⱓ �뿩����
                    <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fee.getCls_r_per()%>'>
    				  %</td>
                <td align='center'><font color="#FF0000">
    				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fee.getCls_per()%>'>%					
					</font></span></td>
              </tr>
              <%if(rent_st.equals("3")){%>
				<%	//�������������
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}
					%>			  
              <tr>
                    <td class='title' style="font-size : 8pt;">���������</td>
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
					  �°躸���� : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum' >��
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(���������� ���� <input type='text' name='grt_suc_cha_amt' size='10' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>' class='whitenum'>)</font>
					  <%}else{ %>
					  <input type='hidden' name='grt_suc_cha_amt' 	value=''>
					  <%} %>
        			</td>
              </tr>	
              <%}%>
              
              <tr>
                <td colspan="2" class='title'>���<br>(�Ϲ����� ����)</td>
                <td colspan="5">&nbsp;
                  <textarea rows='5' cols='90' class=default name='fee_cdt'><%=fee.getFee_cdt()%></textarea></td>
              </tr>			
              <tr>
                <td colspan="3" class='title'>���<br>(���� ����)</td>
                <td colspan="5">&nbsp;
                  <textarea rows='5' cols='90' class=default name='cls_etc'><%=cont_etc.getCls_etc()%></textarea></td>
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
    <tr id=tr_fee2 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="3%" rowspan="6" class='title'>��<br>��<br>��<br>��<br>��<br>��<br>��</td>
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
                    <option value="1" <%if(fee.getFee_sh().equals("1")||fee.getFee_sh().equals("")){%> selected <%}%>>����</option>
                  </select></td>
                <td width="10%" class='title'>���ι��</td>
                <td>&nbsp;
                  <select name='fee_pay_st'>
                    <option value=''>����</option>
                    <option value='1' <%if(fee.getFee_pay_st().equals("1") || !cms.getCms_bank().equals("")){%> selected <%}%>>�ڵ���ü</option>
                    <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>�������Ա�</option>                    
                    <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>����</option>
                    <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>��Ÿ</option>
                    <option value='6' <%if(fee.getFee_pay_st().equals("6") || fee.getFee_pay_st().equals("")){%> selected <%}%>>ī��</option>
                  </select></td>
    			  <td class='title'>CMS�̽���</td>
    			  <td>&nbsp;
    			    ���� : <input type='text' name='cms_not_cau' size='25' value='����Ʈ<%//=fee_etc.getCms_not_cau()%>' class='text'>
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
                  <select name='def_sac_id'>
                    <option value="">����</option>
                    <%if(user_size > 0){
    					for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); %>
                    <option value='<%=user.get("USER_ID")%>' <%if(fee.getDef_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%	}
    				}		%>
                  </select></td>
              </tr>
              <tr>
                <td class='title'>�ڵ���ü
                    <br><span class="b"><a href="javascript:search_cms('0')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;
					�ŷ����� : 
					    <input type='hidden' name="cms_bank" value="<%=cms.getCms_bank()%>"> 
    				  <select name='cms_bank_cd'>
                    <option value=''>����</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];	
    												//�ű��ΰ�� �̻������ ����
   													if(bank.getUse_yn().equals("N"))	 continue;
    												if(cms.getCms_bank().equals("")){%>
                    <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}else{%>
                    <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}%>
                    <%		}
    										}
    								%>
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
					  			if(client.getClient_st().equals("2")) 	cms.setCms_dep_ssn(client.getSsn1());
								else                                   	cms.setCms_dep_ssn(client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3());
					  		}
					  %>
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
					  
    				  &nbsp;&nbsp;������ �ּ� : 
					  <input type='text' name="cms_zip" value='<%if(cms.getCms_dep_post().equals("")){%><%=client.getO_zip()%><%}else{%><%=cms.getCms_dep_post()%><%}%>' size="7" class='text'>
                      <input type='text' name="cms_addr" value='<%if(cms.getCms_dep_addr().equals("")){%><%=client.getO_addr()%><%}else{%><%=cms.getCms_dep_addr()%><%}%>' size="50" class='text'>			

					  <br><br>
    			      &nbsp;
					  ������ȭ :
    			      <input type='text' name='cms_tel' size='15' class='text' value="<%if(cms.getCms_tel().equals("")){%><%= client.getO_tel()%><%}else{%><%=cms.getCms_tel()%><%}%>">

    			      &nbsp;&nbsp;�޴��� :
    			      <input type='text' name='cms_m_tel' size='15' class='text' value="<%if(cms.getCms_m_tel().equals("")){%><%= client.getM_tel()%><%}else{%><%=cms.getCms_m_tel()%><%}%>">
    					  
    			      &nbsp;&nbsp;�̸��� :
    			      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%if(cms.getCms_email().equals("")){%><%= client.getCon_agnt_email()%><%}else{%><%=cms.getCms_email()%><%}%>">
    			      
    			      <br><br>
    			      &nbsp;
					  ������������ :
    			      <input type='text' name='cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
    					  
					  
    			       </td>
    			    </tr>
    			    
    			</table>
    			</td>
              </tr>
              <tr>
                <td class='title'>�ſ�ī�� �ڵ����
                    <br><span class="b"><a href="javascript:search_card_cms('1')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;
					ī��� : 
					    <input type='text' name='c_cms_bank' value='<%=card_cms.getCms_bank()%>' size='20' class='text'>					    
    				&nbsp;&nbsp;
    				ī���ȣ : 
    			      <input type='text' name='c_cms_acc_no' value='<%=card_cms.getCms_acc_no()%>' size='20' class='text'>    			      
					  <br><br>

    			      &nbsp;
    			      ī���� ���θ� :
    			      <input type='text' name='c_cms_dep_nm' value='<%if(card_cms.getCms_dep_nm().equals("")){%><%=client.getClient_nm()%><%}else{%><%=card_cms.getCms_dep_nm()%><%}%>' size='20' class='text'>

    			      &nbsp;&nbsp;
					  ī���� ������� :
					  <%	if(card_cms.getCms_dep_ssn().equals("")){
					  			if(client.getClient_st().equals("2")) 	card_cms.setCms_dep_ssn(client.getSsn1());
					  		}
					  %>
    			      <input type='text' name='c_cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(card_cms.getCms_dep_ssn())%>">

    			      &nbsp;&nbsp;
    				����ڹ�ȣ(������ΰ��) : 
    			      <input type='text' name='c_enp_no' value='<%if(card_cms.getC_enp_no().equals("") && !client.getClient_st().equals("2")){%><%=client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3()%><%}else{%><%=card_cms.getC_enp_no()%><%}%>' size='12' class='text'>
					  
					  <br><br>
    			      &nbsp;
					  ��û�� ���� :
					      <input type='text' name='c_firm_nm' value='<%if(card_cms.getC_firm_nm().equals("")){%><%=client.getFirm_nm()%><%}else{%><%=card_cms.getC_firm_nm()%><%}%>' size='19' class='text'>

    			      &nbsp;&nbsp;
    				  �ּ� : 
					  <input type='text' name="c_cms_zip" value='<%if(card_cms.getCms_dep_post().equals("")){%><%=client.getO_zip()%><%}else{%><%=card_cms.getCms_dep_post()%><%}%>' size="7" class='text'>
                      <input type='text' name="c_cms_addr" value='<%if(card_cms.getCms_dep_addr().equals("")){%><%=client.getO_addr()%><%}else{%><%=card_cms.getCms_dep_addr()%><%}%>' size="60" class='text'>

					  <br><br>
    			      &nbsp;
					  ������ȭ :
    			      <input type='text' name='c_cms_tel' size='15' class='text' value="<%if(card_cms.getCms_tel().equals("")){%><%= client.getO_tel()%><%}else{%><%=card_cms.getCms_tel()%><%}%>">

    			      &nbsp;&nbsp;�޴��� :
    			      <input type='text' name='c_cms_m_tel' size='15' class='text' value="<%if(card_cms.getCms_m_tel().equals("")){%><%= client.getM_tel()%><%}else{%><%=card_cms.getCms_m_tel()%><%}%>">
    					  
    			      &nbsp;&nbsp;�̸��� :
    			      <input type='text' name='c_cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%if(card_cms.getCms_email().equals("")){%><%= client.getCon_agnt_email()%><%}else{%><%=card_cms.getCms_email()%><%}%>">
    			      
    			      <br><br>
    			      &nbsp;
					  ������������ :
    			      <input type='text' name='c_cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(card_cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
    					  
					  
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
    <tr id=tr_tax style="display:''"> 
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
                    <option value='1' <%if(client.getPrint_car_st().equals("1") || client.getPrint_car_st().equals("")) out.println("selected");%>>����/ȭ��/9�ν�/����</option>							
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
    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>   
    <tr>
	<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
    </tr>
    <%}%>
    <tr>
        <td>&nbsp;</td>
    </tr>
	<%if(nm_db.getWorkAuthUser("������",ck_acar_id)){%>
    <tr>
        <td align='right'>
	        <a href="lc_reg_step2_rm.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp;</a>	        
	        <a href="lc_b_u_rm.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" target='d_content'><img src=/acar/images/center/button_mig.gif align=absmiddle border=0></a>&nbsp;  
	        <a href="lc_c_frame.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>
	    </td>
    </tr>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<iframe src="about:blank" name="i_no2" width="100%" height="100" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	
	fm.sh_ja.value = replaceFloatRound(toInt(parseDigit(fm.sh_amt.value)) / toInt(parseDigit(fm.sh_car_amt.value)) );
	
	fm.con_mon.value = '1';
	fm.con_day.value = '0';
	
	fm.v_con_mon.value = '1';
	fm.v_con_day.value = '0';

	fm.inv_s_amt.value 	= '<%=AddUtil.parseDecimal(String.valueOf(hp.get("RM1")))%>';
	
	set_fee_amt(fm.inv_s_amt);
	
	//fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
	//fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));	
			 		
	if(fm.cls_per.value == ''){
		fm.cls_per.value = '10';
	}
	if(fm.cls_r_per.value == '0.0'){
		fm.cls_r_per.value = '10';
	}	
	
//-->
</script>
</body>
</html>
