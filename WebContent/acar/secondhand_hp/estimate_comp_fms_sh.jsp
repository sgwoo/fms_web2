<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.res_search.*" %>
<%@ page import="acar.cont.*, acar.client.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="page"/>

<%
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"0":request.getParameter("today_dist");
	String o_1 			= request.getParameter("o_1")==null?"0":request.getParameter("o_1");
	String rent_dt 		= request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	String a_a 			= request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String a_b 			= request.getParameter("a_b")==null?"":request.getParameter("a_b");
	String amt 			= request.getParameter("amt")==null?"0":request.getParameter("amt");
	
	String est_id	 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_code 	= request.getParameter("est_code")==null?"":request.getParameter("est_code");
	String opt_chk		= request.getParameter("opt_chk")==null?"0":request.getParameter("opt_chk");	
	int fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_opt_amt"));
	String mobile_yn	= request.getParameter("mobile_yn")==null?"":request.getParameter("mobile_yn");
	String mail_yn		= request.getParameter("mail_yn")==null?"0":request.getParameter("mail_yn");
 	String cust_nm		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");
 	String cust_tel		= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");
 	String cust_fax		= request.getParameter("cust_fax")==null?"":request.getParameter("cust_fax");
 	String doc_type		= request.getParameter("doc_type")==null?"":request.getParameter("doc_type");
 	String com_emp_yn	= request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn");
 	
	String param1		= request.getParameter("param1")==null?"":request.getParameter("param1");
	String param2		= request.getParameter("param2")==null?"":request.getParameter("param2");
	String param3		= request.getParameter("param3")==null?"":request.getParameter("param3");
	String param4		= request.getParameter("param4")==null?"":request.getParameter("param4");
	String cust_info	= request.getParameter("cust_info")==null?"":request.getParameter("cust_info");
	
	String br_from		= request.getParameter("br_from")==null?"":request.getParameter("br_from");
	String br_to		= request.getParameter("br_to")==null?"":request.getParameter("br_to");
	String br_to_st	= request.getParameter("br_to_st")==null?"":request.getParameter("br_to_st");
	
	String[] p1_arr = new String[4];
	String[] p2_arr = new String[4];
	String[] p3_arr = new String[4];
	String[] p4_arr = new String[4];
	
	String est_id1 = "";
	String est_id2 = "";
	String est_id3 = "";
	String est_id4 = "";
	
	/*	p?_arr[0] : a_a(�뿩����)		p?_arr[1] :	a_b(�뿩�Ⱓ)		p?_arr[2] :	amt(�뿩�ݾ�)		p?_arr[3] : est_id(������ID)	*/
	p1_arr = param1.split("//");
	p2_arr = param2.split("//");
	p3_arr = param3.split("//");
	p4_arr = param4.split("//");
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase 	a_cmb 	= AddCarMstDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	EstimateBean e_bean1 = new EstimateBean();
	EstimateBean e_bean2 = new EstimateBean();
	EstimateBean e_bean3 = new EstimateBean();
	EstimateBean e_bean4 = new EstimateBean();
	
	if(!String.valueOf(p1_arr[0]).equals("")){		est_id = p1_arr[3];		}
	
	if(est_id.equals("") && !car_mng_id.equals("")){
		//Ȩ������ �縮������ ������
		est_id = shDb.getSearchEstIdSh(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
	}	
	
	//��������
	for(int i = 0 ; i < 4 ; i++){
		if(i==0 && p1_arr.length==4){		e_bean1 = e_db.getEstimateShCase(String.valueOf(p1_arr[3]));	}
		if(i==1 && p2_arr.length==4){		e_bean2 = e_db.getEstimateShCase(String.valueOf(p2_arr[3]));	}
		if(i==2 && p3_arr.length==4){		e_bean3 = e_db.getEstimateShCase(String.valueOf(p3_arr[3]));	}
		if(i==3 && p4_arr.length==4){		e_bean4 = e_db.getEstimateShCase(String.valueOf(p4_arr[3]));	}
	}
	
	if(!e_bean1.getEst_id().equals("")){	est_id1 = e_bean1.getEst_id();	}
	if(!e_bean2.getEst_id().equals("")){	est_id2 = e_bean2.getEst_id();	}
	if(!e_bean3.getEst_id().equals("")){	est_id3 = e_bean3.getEst_id();	}
	if(!e_bean4.getEst_id().equals("")){	est_id4 = e_bean4.getEst_id();	}
	
	//��������
	EstimateBean e_bean = new EstimateBean();
	e_bean = e_bean1;
	String page_kind = "";
			
	if(est_id.equals("") && !car_mng_id.equals("")){
		if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){		//FMS �縮�������������� �⺻������/����������
			est_id = shDb.getSearchEstId(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
			page_kind = "fms";
		}else{									//Ȩ������ �縮������ ������
			est_id = shDb.getSearchEstIdSh(car_mng_id, a_a, a_b, o_1, today_dist, rent_dt, amt, est_code);
			page_kind = "homepage";
		}
	}

	if(est_id.equals("")){
		out.println("�������� ��ã�ҽ��ϴ�.");
		return;
	}
	
	//�ܰ� ��������
	Hashtable sh_comp = new Hashtable();
	
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		e_bean = e_db.getEstimateCase(est_id);
		sh_comp = shDb.getShCompare(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}else{
		e_bean = e_db.getEstimateShCase(est_id);
		sh_comp = shDb.getShCompareSh(est_id);
		today_dist = String.valueOf(e_bean.getToday_dist());
	}
	
	if(e_bean.getOpt_chk().equals("1") && opt_chk.equals("0")) 			opt_chk 	= e_bean.getOpt_chk();
	
	if(e_bean.getFee_opt_amt() >0 && fee_opt_amt == 0 ) 				fee_opt_amt = e_bean.getFee_opt_amt();
	
	//��������
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
	//�����ڵ庯��
	String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());		
	EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);
	
	//��������
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 			= String.valueOf(ht.get("S_ST"));
	String jg_code 			= String.valueOf(ht.get("JG_CODE"));
	String car_no 			= String.valueOf(ht.get("CAR_NO"));
	String car_name			= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	String secondhand_dt 	= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 		= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 	= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt			 	= String.valueOf(ht.get("OPT"));
	String colo			 	= String.valueOf(ht.get("COL"));
	String car_y_form		= String.valueOf(ht.get("CAR_Y_FORM"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int tax_dc_amt			= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));	
	if(today_dist.equals("0"))	today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	String dist_cng			= String.valueOf(ht.get("DIST_CNG"));	
	int dpm 				= AddUtil.parseInt((String)ht.get("DPM"));
	float spe_dc_per		= AddUtil.parseFloat((String)ht.get("SPE_DC_PER"));
	String cha_st_dt 		= String.valueOf(ht.get("CHA_ST_DT"));
	String b_dist 			= String.valueOf(ht.get("B_DIST"));
	String car_use 			= String.valueOf(ht.get("CAR_USE"));

	if(e_bean.getB_dist() > 0){
		cha_st_dt 		= e_bean.getCha_st_dt();
		b_dist 			= String.valueOf(e_bean.getB_dist());
	}

	int car_use_mon = 0;
	//������� ����Ⱓ2(���ɸ�����2����������)
	if(!String.valueOf(ht.get("CAR_END_DT")).equals("") && AddUtil.checkDate(init_reg_dt)){	
		Hashtable carOld4 	= c_db.getOld(init_reg_dt, AddUtil.getDate(4), ""); //����
		car_use_mon 		= (AddUtil.parseInt(String.valueOf(carOld4.get("YEAR")))*12) + AddUtil.parseInt(String.valueOf(carOld4.get("MONTH")));
	}
	
	String min_use_mon		= "6";
	if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){
		min_use_mon			= "12";
		//���������� ���� �뵵����� (���������ϰ� 24���� �̻� ������ �ǵ���)
		if(AddUtil.parseInt(jg_code) > 2000 && AddUtil.parseInt(jg_code) < 9999 && car_use.equals("1")){
			min_use_mon		= "24";
		}
		//���������� ���� �뵵����� (���������ϰ� 24���� �̻� ������ �ǵ���)
		if(AddUtil.parseInt(jg_code) > 2000000 && AddUtil.parseInt(jg_code) < 9999999 && car_use.equals("1")){
			min_use_mon		= "24";
		}		
	}
	
	String max_use_mon		= e_bean.getMax_use_mon();
	if(max_use_mon.equals("")){
		if(car_use_mon>0){
			if(ej_bean.getJg_b().equals("2")){
				if(dpm > 2000){
					max_use_mon = String.valueOf(94-car_use_mon);
				}else{
					max_use_mon = String.valueOf(82-car_use_mon);
				}
			}else{
				if(dpm > 2000){
					max_use_mon = String.valueOf(95-car_use_mon);
				}else{
					max_use_mon = String.valueOf(83-car_use_mon);
				}
			}
			if(AddUtil.parseInt(max_use_mon) > 48){
				max_use_mon = "48";
			}
		}else{
			max_use_mon = "48";
		}
	}
		
	if(e_bean.getCar_amt()==0){
		e_bean.setCar_amt(car_amt);
		e_bean.setOpt_amt(opt_amt);
		e_bean.setCol_amt(clr_amt);
	}
	
	String stat = "";
	if(e_bean.getEst_st().equals("3") && car_amt == 0) stat = "�������ݺҸ�";
	if(e_bean.getEst_st().equals("3") && AddUtil.parseInt((String)ht.get("O_L")) == 0) stat = "�߰���������";
	
	//�ܰ� ��������
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	int sh_car_amt		= AddUtil.parseInt((String)sh_var.get("SH_CAR_AMT"));
	int dlv_car_amt		= AddUtil.parseInt((String)sh_var.get("DLV_CAR_AMT"));
	
	sh_car_amt 			= e_bean.getO_1();
	dlv_car_amt 		= car_amt+opt_amt+clr_amt-tax_dc_amt-e_bean.getO_1();
	
	String rent_way 	= "2";
	if(!e_bean.getA_a().equals("")){
		a_a 			= e_bean.getA_a().substring(0,1);
		rent_way 		= e_bean.getA_a().substring(1);
	}
	if(a_b.equals(""))	a_b	= e_bean.getA_b();
	String a_e 			= s_st;
	float o_13 			= 0;
	
	//��ȿ�Ⱓ
	String vali_date = AddUtil.getDate3(rs_db.addDay(e_bean.getRent_dt(), 4));
	
	//����ó----------------------------------------------------------------
	
	String br_id 	= "S1";
	String name 	= "";
	String m_tel	= "";
	String h_tel	= "";
	String i_fax	= "";
	String email	= "";
	
	UsersBean user_bean 	= new UsersBean();
	
	//���������
//	if(!e_bean.getReg_id().equals("") && e_bean.getReg_id().length() == 6){
//		user_bean = umd.getUsersBean(e_bean.getReg_id());
//	}else{
		if(acar_id.equals(""))	acar_id = login.getCookieValue(request, "acar_id");
		
		if(!acar_id.equals("")){
			user_bean = umd.getUsersBean(acar_id);
		}
//	}
	
	String client_st = "2";
	
	ContBaseBean base = new ContBaseBean();
	ClientBean client = new ClientBean();

	if(e_bean.getMgr_ssn().equals("�������") && !e_bean.getEst_from().equals("ext_car")){
	
		//���⺻����
		base = a_db.getCont(e_bean.getRent_mng_id(), e_bean.getRent_l_cd());
				
		//������
		client = al_db.getClient(base.getClient_id());
		client_st = client.getClient_st();
		
		e_bean.setEst_tel	(client.getO_tel());
		e_bean.setEst_email	(client.getCon_agnt_email());
	}
	
	name 		= user_bean.getUser_nm();
	m_tel 		= user_bean.getUser_m_tel();
	br_id   	= user_bean.getBr_id();
	h_tel 		= user_bean.getHot_tel();
	i_fax   	= user_bean.getI_fax();
	email 		= user_bean.getUser_email();

	//������, ��������� ���������� ����
	if(!cust_info.equals("")){
		
		String[] cust_arr = new String[8];
		cust_arr = cust_info.split("//");	// 0:������(��ȣ) 1:������ó  2:��fax  3:����ڼ���  4:�����hp  5:�����tel  6:�����fax  7:�����mail
		
		if(cust_arr.length>0 && !cust_arr[0].equals("")){	cust_nm  = cust_arr[0];	}else{	cust_nm  = "";	}
		if(cust_arr.length>1 && !cust_arr[1].equals("")){	cust_tel = cust_arr[1];	}else{	cust_tel = "";	}
		if(cust_arr.length>2 && !cust_arr[2].equals("")){	cust_fax = cust_arr[2];	}else{	cust_fax = "";	}
		if(cust_arr.length>3 && !cust_arr[3].equals("")){	name 	 = cust_arr[3];	}else{	cust_nm  = "";	}
		if(cust_arr.length>4 && !cust_arr[4].equals("")){	m_tel 	 = cust_arr[4];	}else{	m_tel 	 = "";	}
		if(cust_arr.length>5 && !cust_arr[5].equals("")){	h_tel 	 = cust_arr[5];	}else{	h_tel 	 = "";	}
		if(cust_arr.length>6 && !cust_arr[6].equals("")){	i_fax    = cust_arr[6];	}else{	i_fax 	 = "";	}
		if(cust_arr.length>7 && !cust_arr[7].equals("")){	email 	 = cust_arr[7];	}else{	email 	 = "";	} 
	}
	
	if(name.equals("�ڱԼ�")) name = "�ּ���";
	
	if(user_bean.getDept_id().equals("1000") && e_bean.getEst_st().equals("2")){
		vali_date = "��Ȯ�� ����";
	}
	
	if (e_bean.getBr_to_st().equals("")) {
		e_bean.setBr_to_st(br_to_st);
	}
%>

<!DOCTYPE HTML PUBLIC -//W3C//DTD HTML 4.01 Transitional//EN
http://www.w3.org/TR/html4/loose.dtd>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>������</title>
<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<script>
$(document).ready(function(){	
	var contiRatDesc = $('#contiRatDesc').text();
	var point = contiRatDesc.indexOf("(");
	if(point >= 0){
		$('#contiRatDesc').text(contiRatDesc.substring(0,point) + "(���տ������)");
	}else{
		$('#contiRatDesc').text(contiRatDesc + "(���տ������)");
	}
})
</script>
<style type="text/css">
.style1 {color: #dc0039; font-weight: bold;	font-size: 22px;}
.style2 {color: #706f6f; font-weight: bold;}
.style3 {color: #333333;}
.style4 {color: #000000;}
.style5 {color: #444444;}
.style6 {color: #dc0039; font-weight: bold;}
.style7 {color: #1c75ba; font-weight: bold;}
.style8 {color: #354a6d;}
.style9 {color: #5f52a0;}
.style10{font-weight: 900;}
.style12{color: #9cb445; font-weight: bold;}
.style13{color: #c4c4c4; font-weight: bold;}
.style14{color: #616161;}
.style15 tr td{border:1px solid c4c4c4; border-color: c4c4c4;}
.style16{color: #77786b; font-size: 8pt;}
-->
</style>
<link href="/acar/main_car_hp/style_est.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->		
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
	//�μ��ϱ�
//	function go_print(est_id){
	function go_print(){
		var fm = document.form1;
		//fm.est_id.value = est_id;
		fm.action = "esti_print_comp_fms_sh.jsp";
		fm.target = "_blank";
		fm.submit();		
	}	
	
	//���Ϲ߼��ϱ�
	function go_mail(cust_info){	
		var SUBWIN="/acar/apply/mail_input.jsp?from_page=estimate_comp_fms_sh.jsp&est_id=esti_comp_fms_sh&acar_id=<%=acar_id%>&content_st=sh_fms&param1=<%=param1%>&param2=<%=param2%>&param3=<%=param3%>&param4=<%=param4%>&br_from=<%=br_from%>&br_to=<%=br_to%>&br_to_st=<%=br_to_st%>&cust_info="+cust_info;	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=600, scrollbars=no, status=yes");
	}

	//������ڹ߼�
	function esti_result_sms(est_id){	
		var SUBWIN="/acar/apply/sms_input.jsp?from_page=<%=from_page%>&est_id=<%=est_id%>&write_id=<%=e_bean.getReg_id()%>&acar_id=<%=acar_id%>&opt_chk=<%=opt_chk%>&fee_opt_amt=<%=fee_opt_amt%>&est_email=<%=e_bean.getEst_email()%>&content_st=sh_fms";	
		window.open(SUBWIN, "openSMS", "left=100, top=100, width=420, height=600, scrollbars=no, status=yes");
	}
	
	//�غ񼭷�����
	function go_paper(){
		var SUBWIN="/acar/main_car_hp/papers.html";	
		window.open(SUBWIN, "openpaper", "left=50, top=50, width=573, height=770, status=no, scrollbars=no, resizable=no");
	}		
	
	//�⺻��纸���ֱ�
	function opt(est_id){  
		var fm = document.form1;
		var SUBWIN="/acar/main_car_hp/opt.jsp?est_id="+est_id+"&from_page=<%=from_page%>";	
		window.open(SUBWIN, "OPT", "left=10, top=10, width=798, height=550, scrollbars=yes, status=yes, resizable=no");
	}
//-->
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
</head>
<body topmargin=0 leftmargin=0>
<form action="" name="form1" method="POST" >
<input type="hidden" name="from_page" 	value="<%=from_page%>">
<input type="hidden" name="est_id" 		value="<%=est_id%>">
<input type="hidden" name="acar_id" 	value="<%=acar_id%>">
<input type="hidden" name="opt_chk" 	value="<%=opt_chk%>">
<input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">
<input type="hidden" name="mobile_yn" 	value="<%=mobile_yn%>">
<input type="hidden" name="content_st" 	value="sh_fms">
<input type="hidden" name="param1" id="param1" value="<%=param1%>">
<input type="hidden" name="param2" id="param2" value="<%=param2%>">
<input type="hidden" name="param3" id="param3" value="<%=param3%>">
<input type="hidden" name="param4" id="param4" value="<%=param4%>">
<input type="hidden" name="com_emp_yn" id="com_emp_yn" value="<%=com_emp_yn%>">
<input type="hidden" name="cust_nm" id="cust_nm" value="<%=cust_nm%>">
<input type="hidden" name="cust_tel" id="cust_tel" value="<%=cust_tel%>">
<input type="hidden" name="cust_fax" id="cust_fax" value="<%=cust_fax%>">
<input type="hidden" name="br_from" value="<%=br_from%>">
<input type="hidden" name="br_to" value="<%=br_to%>">
<input type="hidden" name="br_to_st" value="<%=br_to_st%>">
<table width=680 border=0 cellspacing=0 cellpadding=0 style="margin-left: 15px;">
    <tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
    <tr>
        <td height=8 colspan=3></td>
    </tr>
    <tr>
        <td colspan=3>
            <table width=680 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=21>&nbsp;</td>
                    <td width=550><img src=../main_car_hp/images/title_2.gif></td>
                    <td width=180 align=right>
                        <table width=100% border=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr>
                                <td width=60 bgcolor=f2f2f2 height=18 align=center><span class=style16>�ۼ���</span></td>
                                <td width=97 bgcolor=ffffff align=center><span class=style16><%=AddUtil.getDate3(e_bean.getRent_dt())%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 align=center height=18><span class=style16>��ȿ�Ⱓ</span></td>
                                <td bgcolor=ffffff align=center><span class=style16><%=vali_date%></span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=5 colspan=3></td>
    </tr>
    <tr>
        <td width=21>&nbsp;</td>
        <td width=680>
            <table width=680 border=0 cellspacing=0 cellpadding=0>
          		<tr> 
            		<td colspan="2"> 
            			<table width=680 border=0 cellspacing=0 cellpadding=0>
                			<tr> 
                  				<td width=410> 
                  					<table width=410 border=0 cellspacing=0 cellpadding=0>
                      					<tr> 
                        					<td height=30 colspan=4>&nbsp;
                        					<span class=style1>
                        					<%if(e_bean.getEst_from().equals("tae_car")){%>
						                		[ ��������� ]
						              		<%}else{%>  
                        	  					[ <%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%> ]
                            					<%if(e_bean.getEst_from().equals("res_car")){%>
	  					                			- �Ϲݴ���
                            					<%}else if(e_bean.getEst_from().equals("emp_car")){%>
			  			                			- �������� ������
						                		<%}else{%>
						                  			<%if(e_bean.getEst_st().equals("1")){%>- ������<%if(e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")){%>�縮��<%}else{%>�緻Ʈ<%}%>
						                  			<%}else if(e_bean.getEst_st().equals("2")){%>- ������
						                  			<%}else if(e_bean.getEst_st().equals("3")){%>- �߰��� ����
						                  			<%}%>
						                		<%}%>
						              		<%}%>  
										    </span>
										    </td>
                      					</tr>
                      					<tr> 
                        					<td colspan=4><img src=../main_car_hp/images/line.gif width=409 height=1></td>
                      					</tr>
                      					<tr> 
                        					<td width=24 height=25 align=center><img src=../main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
                        					<td colspan=3><div align="left"><span class=style2><%=cust_nm%> ��</span></div></td>
                      					</tr>
                      					<tr> 
                        					<td colspan=4><img src=../main_car_hp/images/line.gif width=409 height=1></td>
                      					</tr>
                      					<tr> 
					                        <td width=24 height=25 align=center><img src=../main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
					                        <td width=160><span class=style2>TEL.<%=cust_tel%></span></td>
					                        <td width=24 align=center><img src=../main_car_hp/images/arrow.gif width=8 height=8 align=absmiddle></td>
					                        <td width=202><span class=style2>FAX.<%=cust_fax%></span></td>
				                      	</tr>
				                      	<tr> 
                        					<td colspan=4><img src=../main_car_hp/images/line.gif width=409 height=1></td>
                      					</tr>
                    				</table>
                    			</td>
                  				<td width=28>&nbsp;</td>
                  				<td width=201 valign=bottom align="right"> 
                  					<div style="vertical-align: bottom; border: 5px solid #e3e7d6; border-radius: 5px; background: linear-gradient(to bottom, #FFFFFF 45%, #EEF0E6); background-color: #FFFFFF;">
                  						<table width=100% border=0 cellpadding=0 cellspacing=0 style="padding: 5px 3px;">
						               		<tr> 
						                        <td width=60 align=center rowspan="4"><span class=style5><b><%= name %></b></span>&nbsp;</td>
						                        <td align=center rowspan="4">
						                        	<div style="width: 5px; height: 45px; border-left: 1px solid #d5d9c1;"></div>
						                        </td>
						                        <td align=right style="letter-spacing: 0.2px;">&nbsp;hp)</td>
						                        <td class=listnum2 align=left>&nbsp;&nbsp;<span class=style5><%= m_tel %></span></td>
						                 	</tr>
						                  	<tr>
						                        <td align=right style="letter-spacing: 0.2px;">&nbsp;tel)</td>
						                        <td class=listnum2 align=left>&nbsp;&nbsp;<span class=style5><%= h_tel %></span></td>
						                 	</tr>
						                   	<tr>
						                        <td align=right style="letter-spacing: 0.2px;">&nbsp;fax)</td>
						                        <td class=listnum2 align=left>&nbsp;&nbsp;<span class=style5><%= i_fax %></span></td>
						                  	</tr>
						                  	<tr>
						                  		<td align=right></td>
						                        <td class=listnum2 align=left>&nbsp;&nbsp;<span class=style5><%= email %></span></td>
						                  	</tr>
	                   					</table>
                  					</div>
                  					<%-- <table width=201 border=0 cellpadding=0 cellspacing=0 background=../main_car_hp/images/tel_bg_new.gif  height=80>
		   								<tr> 
                        					<td colspan=4 height=9></td>
	                					</tr>
					               		<tr> 
					                        <td width=60 align=center>&nbsp;<span class=style5><b><%= name %></b></span></td>
					                        <td width=30 align=right>hp)</td>
					                        <td width=111 class=listnum2>&nbsp;<span class=style5><%= m_tel %></span></td>
					                 	</tr>
					                  	<tr> 
					                        <td>&nbsp;</td>
					                        <td align=right>tel)</td>
					                        <td class=listnum2>&nbsp;<span class=style5><%= h_tel %></span></td>
					                 	</tr>
					                   	<tr> 
					                     	<td>&nbsp;</td>
					                        <td align=right>fax)</td>
					                        <td class=listnum2>&nbsp;<span class=style5><%= i_fax %></span></td>
					                  	</tr>
					                  	<tr> 
					                        <td>&nbsp;</td>
					                        <td colspan='2' class=listnum2>&nbsp;&nbsp;<span class=style5><%= email %></span></td>
					                  	</tr>
				        				<tr> 
				                        	<td colspan=4 height=5></td>
				                      	</tr>          
                   					</table> --%>
								</td>
	                		</tr>
                			<tr> 
			                  	<td colspan="3" height="10"></td>
			                </tr>
							<%if(stat.equals("�������ݺҸ�")){%>
			                <tr> 
			                  	<td colspan="3" height="17">&nbsp;�� �� ������ ������ ���������̸�, ���������� Ȯ�εǾ�� Ȯ�������� ���õ˴ϴ�.</td>
			                </tr>
							<%}	else if(stat.equals("�߰���������")){%>
			                <tr> 
			                  	<td colspan="3" height="17">&nbsp;�� �� ������ ������ ���������̸�, �߰��������� �����εǾ�� Ȯ�������� ���õ˴ϴ�.</td>                
							</tr>
							<%}else{%>
			                <tr> 
			                  	<td colspan="3" height="17">&nbsp;�� �ͻ翡�� �����Ͻ� ���뿩�� ���Ͽ� �Ʒ��� ���� ������ �����Ͽ��� �����Ͻð� ���� �亯 ��Ź�帳�ϴ�.</td>
			                </tr>
							<%}%>
	           			</table>
	              	</td>
          		</tr>
          		<tr> 
	            	<td height=10 colspan="2"></td>
	          	</tr>
	          	<tr> 
	            	<td colspan="2"><%if(e_bean.getAccid_serv_zero().equals("Y")){//�����������%><img width="680" src=../main_car_hp/images/bar_01_msg.gif><%}else{%><img width="680" src=../main_car_hp/images/bar_01.gif><%}%></td>
	          	</tr>
          		<tr> 
            		<td height=4 colspan="2"></td>
          		</tr>
          		<tr> 
            		<td colspan="2"> 
            			<table width=680 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
			                <tr> 
			                  	<td width=132 height=17 align=center bgcolor=f2f2f2><span class=style3>������</span></td>
			                  	<td width=388 bgcolor=#FFFFFF>&nbsp;<span class=style4><%= c_db.getNameById(car_comp_id, "CAR_COM") %></span></td>
			                  	<td width=114 align=center bgcolor=f2f2f2><span class=style3>�� ��</span></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>����(�����𵨸�)</span></td>
			                 	 <td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(est_id.length() > 0){%><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=car_name%></a><%}else{%><%=car_name%><%}%></span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%if(stat.equals("�������ݺҸ�")){%>��Ȯ��<%}else{%><%= AddUtil.parseDecimal(e_bean.getCar_amt()) %>  ��<%}%></span>&nbsp;</td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� ��</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(est_id.length() > 0){%><a href="javascript:opt('<%=est_id%>');" onMouseOver="window.status=''; return true"><%=opt%></a><%}else{%><%=opt%><%}%></span>
			                      <%if(car_mng_id.equals("018647")){%>(���� �ǸŵǴ� �����̾� ���� ������ ����)<%}%>
			                  	</td>
			                 	<td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getOpt_amt()) %> ��</span>&nbsp;</td>
			                </tr>
			                <tr> 
			                 	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� �� </span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;<span class=style7><%if(!e_bean.getIn_col().equals("")){%>����: <%}%><%=colo%><%if(!e_bean.getIn_col().equals("")){%>&nbsp;/&nbsp;����: <%=e_bean.getIn_col()%><%}%></span></td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4><%= AddUtil.parseDecimal(e_bean.getCol_amt()) %> ��</span>&nbsp;</td>
			                </tr>
			                <%if(!e_bean.getConti_rat().equals("")){%>
			                <tr>
			                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>�� �� </span></td>
			                    <td bgcolor=#FFFFFF><span id="contiRatDesc">&nbsp;<%=e_bean.getConti_rat()%></span></td>
			                    <td bgcolor=#FFFFFF></td>
			                </tr>
			                <%}%>
			                <!-- ���� ���Ҽ� ���� �߰�(2017.10.13) -->
			                <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
			                <tr>
			                	<td height=17 align=center bgcolor=f2f2f2><span class=style3>���� ���Ҽ� ���� </span></td>
			                    <td bgcolor=#FFFFFF></td>
			                    <td align=right bgcolor=#FFFFFF><span class=style4> - <%=AddUtil.parseDecimal(e_bean.getTax_dc_amt())%> ��</span>&nbsp;</td>
			                </tr>
			                <%}%>
			                <tr> 
			                  	<td height=17 align=center bgcolor=f2f2f2><span class=style3>������</span></td>
			                  	<td bgcolor=#FFFFFF>&nbsp;<span class=style7>��������� : <%=AddUtil.ChangeDate2(init_reg_dt)%> (�𵨿���:<%=car_y_form%>)
			                  	<%if(!e_bean.getTot_dt().equals("") && (e_bean.getEst_from().equals("tae_car") || e_bean.getEst_from().equals("secondhand"))){//�縮��,���������%>
			                  		<br>&nbsp;����Ÿ� : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km (Ȯ������:<%=AddUtil.ChangeDate2(e_bean.getTot_dt())%>)
			                  	<%}else{%>
			                  		&nbsp;&nbsp;����Ÿ� : <%= AddUtil.parseDecimal(today_dist) %> <%if(today_dist.equals("0")) out.println("*****");%> km	
			                  	<%}%>
			                  	</span>
			                  	</td>
			                  	<td align=right bgcolor=#FFFFFF><span class=style4>-<%if(stat.equals("�������ݺҸ�") || stat.equals("�߰���������")){%>##,###,###<%}else{%><%= AddUtil.parseDecimal(dlv_car_amt) %><%}%> ��</span>&nbsp;</td>
			                </tr>
			                <tr> 
			               	   	<td height=20 align=center bgcolor=f2f2f2><span class=style3>��������</span></td>
			                	<td bgcolor=#FFFFFF>&nbsp;<span class=style7>������ȣ : <%if(!car_no.equals("")){ out.println("****"+car_no.substring(car_no.length()-4, car_no.length())); } %></span></td>
				                <td align=right bgcolor=#FFFFFF><span class=style6><%if(stat.equals("�߰���������")){%>�̰���<%}else{%><%=AddUtil.parseDecimal(e_bean.getO_1())%> ��<%}%></span>&nbsp;</td>
			                </tr>
             			</table>
          			</td>
          		</tr>		  
          		<tr> 
		 			<td height=10 colspan="2">
		   				<table width=680 border=0 cellpadding=0 cellspacing=1>
		        			<tr>
		        				<td>
					        	<%if(!e_bean.getEst_from().equals("res_car") && !e_bean.getEst_from().equals("emp_car") && !e_bean.getEst_from().equals("tae_car") && e_bean.getEst_st().equals("1") && !e_bean.getA_a().equals("")){%>
					          		�� ����, ���ӱ� : 2����/5,000Km ǰ������<span style="font-size:10px;">(�Ⱓ �Ǵ� ����Ÿ� �� ���� ������ ���� �����Ⱓ ����� ����)</span>
				          		<%}%>
				          		<%if (e_bean.getBr_to_st().equals("0")) {%>
				          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : ������</p>
				          		<%} else if (e_bean.getBr_to_st().equals("1")) {%>
				          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : ����/����/�泲/���</p>
				          		<%} else if (e_bean.getBr_to_st().equals("2")) {%>
				          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : �뱸/���</p>
				          		<%} else if (e_bean.getBr_to_st().equals("3")) {%>
				          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : ����/����/����</p>
				          		<%} else if (e_bean.getBr_to_st().equals("4")) {%>
				          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : �λ�/���/�泲</p>
				          		<%} else if (e_bean.getBr_to_st().equals("5")) {%>
				          			<p style="margin: 0px;">�� ���ּ���(�����ε�����) : ����</p>
				          		<%}%>
		          				</td>
			            		<td height=10 align="right">
								<%if(cm_bean.getJg_code().equals("1232") || cm_bean.getJg_code().equals("1242") || cm_bean.getJg_code().equals("1021212") || cm_bean.getJg_code().equals("1023112")){//��׹���ǻ��,����%>
									�� LPG/�ֹ��� �����
								<%}else{%>						
									<%	if(String.valueOf(sh_comp.get("ENGIN")).equals("Y")){%>		�� ��������
									<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("2")){%>	�� LPG������
									<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("1")){%>	�� ���ָ�����
									<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("3")){%>	�� ���̺긮��
									<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("4")){%>	�� �÷����� ���̺긮��
									<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("5")){%>	�� ������
									<%	}else if(String.valueOf(sh_comp.get("ENGIN")).equals("6")){%>	�� ������
									<%	}else{%>
											<%if(cm_bean.getDiesel_yn().equals("Y")){%>			�� ��������
											<%}else if(cm_bean.getDiesel_yn().equals("2")){%>		�� LPG������
											<%}else if(cm_bean.getDiesel_yn().equals("1")){%>		�� ���ָ�����
											<%}else if(cm_bean.getDiesel_yn().equals("3")){%>		�� ���̺긮��
											<%}else if(cm_bean.getDiesel_yn().equals("4")){%>		�� �÷����� ���̺긮��
											<%}else if(cm_bean.getDiesel_yn().equals("5")){%>		�� ������
											<%}else if(cm_bean.getDiesel_yn().equals("6")){%>		�� ������
											<%}%>
									<%	}%>
								<%}%>			
								</td>
			          		</tr>
			     		</table>
			  		</td>
				</tr>
          		<%if(!dist_cng.equals("")){%>
          		<tr>
		          	<td colspan="2" bgcolor=f2f2f2 height=45><span class=style4> * �� ������ ����� ��ȯ �̷�(<%=AddUtil.getDate3(cha_st_dt)%>)�� �ִ� �������� ����� ��ȯ�� ����Ÿ��� <%=AddUtil.parseDecimal(b_dist)%>km, ��ȯ�� �� ���<br>
		          	&nbsp; ���� ����Ÿ��� <%=AddUtil.parseDecimal(AddUtil.parseInt(today_dist)-AddUtil.parseInt(b_dist))%>km�Դϴ�. ������ ���ÿ��� ����Ÿ��� <%=AddUtil.parseDecimal(today_dist)%>km�� �����ϰ�, �������� ���� �ü��϶���<br>
		          	&nbsp; �ݿ��Ͽ����ϴ�.</span></td>
         		</tr>
          		<%}%>
	          	<tr> 
	            	<td height=5 colspan="2"></td>
	          	</tr>
				<!-- ���躸����� -->
	          	<tr> 
	            	<td colspan="2">                   	
	                   	<div style="position: relative;">
							<img width="680" src=../main_car_hp/images/bar_02_ins_comp_est_prt.gif align=left>
							<span style="position: absolute; top:4; right:4;">								
								<%if (doc_type.equals("1") || e_bean.getDoc_type().equals("1")) {%>
									<%if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000 && com_emp_yn.equals("Y")) {%>
		                        	      �� �����ڹ��� : ����������
		                        	<%} else if (AddUtil.parseInt(cm_bean.getJg_code()) > 1999999 && AddUtil.parseInt(cm_bean.getJg_code()) < 7000000 && com_emp_yn.equals("Y")) {%>
		                        	    �� �����ڹ��� : ����������      
		                        	<%} else {%>    
		                        	     �� �����ڹ��� : �������� ���谡��                        	  
		                        	<%}%>
		                        <%} else if (doc_type.equals("2") || e_bean.getDoc_type().equals("2")) {%>
		                        	  �� �����ڹ��� : �������� ���谡��
		                        <%} else if (doc_type.equals("3") || e_bean.getDoc_type().equals("3")) {%>
		                        	  �� �����ڹ��� : ����� �� ���谡��
		                        <%}%>
							</span>
						</div> 	           		
	            	</td>
	          	</tr>
	          	<tr> 
	            	<td height=4 colspan="2"></td>
	          	</tr>
	          	<tr>
	          		<td colspan="2">
						<table width=680 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
							<tr>
								<td height=17 align=center bgcolor=f2f2f2><span class=style4>���ι��</span></td>
								<td align=center bgcolor=f2f2f2><span class=style4>�빰���</span></td>
								<td align=center bgcolor=f2f2f2><span class=style4>�ڱ��ü���</span></td>
								<td align=center bgcolor=f2f2f2><span class=style4>������å��</span></td>
								<td align=center bgcolor=f2f2f2><span class=style4>������������</span></td>
								<td align=center bgcolor=f2f2f2><span class=style4>�����ڿ���</span></td>
								<td align=center bgcolor=f2f2f2><span class=style4>����⵿</span></td>
							</tr>
							<%	if(!e_bean.getIns_per().equals("2")){%>
							<tr>
								<td height=17 align=center bgcolor=#FFFFFF><span class=style4>����(���Υ�,��)</span></td>
								<td align=center bgcolor=#FFFFFF><span class=style4><%if(e_bean.getIns_dj().equals("1")){%>5õ����<%}else if(e_bean.getIns_dj().equals("3")){%>5���<%}else if(e_bean.getIns_dj().equals("4")){%>2���<%}else if(e_bean.getIns_dj().equals("8")){%>3���<%}else{%>1���<%}%></span></td>
								<td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_dj().equals("1")){%>5õ����<%}else{%>1���<%}%></span></td>
								<td align=center bgcolor=#FFFFFF><span class=style3><%=AddUtil.parseDecimal(e_bean.getCar_ja())%>��</span></td>
								<td align=center bgcolor=#FFFFFF><span class=style3>1�δ� �ְ� 2��� </span></td>
								<td align=center bgcolor=#FFFFFF><span class=style3><%if(e_bean.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean.getIns_age().equals("3")){%>��24���̻�<%}else{%>��26���̻�<%}%></span></td>
								<td align=center bgcolor=#FFFFFF><span class=style3>����</span></td>
							</tr>
							<%	}else{%>
							<tr>
								<td height=17 align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
								<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
								<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
								<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
								<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
								<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
								<td align=center bgcolor=#FFFFFF><span class=style4>����̹ݿ�</span></td>
							</tr>
							<%	}%>
						</table>
					</td>
				</tr>	
				<!-- ���躸����� end--> 
          		<tr> 
       				<td height=10 colspan="2"></td>
   				</tr>
      			<tr> 
        			<td colspan="2"><img width="680" src=../main_car_hp/images/bar_03_fee_prt.gif></td>
      			</tr>
      			<tr> 
        			<td height=4 colspan="2"></td>
          		</tr>
				<!-- ���뿩�� �� �ʱⳳ�Ա� -->
	          	<tr>
	          		<td colspan="2">
	          			<table class="style15" width=680 border=1 cellpadding=0 cellspacing=1 style="border-collapse:collapse; border-color: white">
							<tr style="height: 18px;">
								<td align=center bgcolor=f2f2f2 colspan=2 >����</td>
								<td align=center bgcolor=f2f2f2 width=135>����1</td>
								<td align=center bgcolor=f2f2f2 width=135>����2</td>
								<td align=center bgcolor=f2f2f2 width=135>����3</td>
								<td align=center bgcolor=f2f2f2 width=135>����4</td>
							</tr>
	          				<tr>
	          					<td align=center bgcolor=f2f2f2 colspan=2><span class=style3>�뿩��ǰ��</span></td>	   
	          					<td align=center height=17 bgcolor=ffffff><span class=style3><%=c_db.getNameByIdCode("0009", "", e_bean1.getA_a())%></span></td>
	          					<td align=center bgcolor=ffffff><span class=style3><%if(!e_bean2.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%><%}%></span></td>
	          					<td align=center bgcolor=ffffff><span class=style3><%if(!e_bean3.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean3.getA_a())%><%}%></span></td>
	          					<td align=center bgcolor=ffffff><span class=style3><%if(!e_bean4.getEst_id().equals("")){%><%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%><%}%></span></td>
	          				</tr>
	          				<tr bgcolor=f2f2f2>
	          					<td height=17 align=center colspan=2><span class=style3>�뿩�Ⱓ</span></td>
	          					<td align=right><span class=style4><%=e_bean1.getA_b()%> ����</span>&nbsp;</td>  
	          					<td align=right><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=e_bean2.getA_b()%> ����<%}%></span>&nbsp;</td>
	          					<td align=right><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=e_bean3.getA_b()%> ����<%}%></span>&nbsp;</td>
	          					<td align=right><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=e_bean4.getA_b()%> ����<%}%></span>&nbsp;</td>
	          				</tr>     
	          				<%
	          				int fee_s_amt_1 = 0;
							int fee_v_amt_1 = 0;
							int fee_t_amt_1 = 0;
							
	          				int fee_s_amt_2 = 0;
							int fee_v_amt_2 = 0;
							int fee_t_amt_2 = 0;
							
	          				int fee_s_amt_3 = 0;
							int fee_v_amt_3 = 0;
							int fee_t_amt_3 = 0;
							
	          				int fee_s_amt_4 = 0;
							int fee_v_amt_4 = 0;
							int fee_t_amt_4 = 0;
						  	
							String reg_code = "";
							String str_ag = "";
							
							int feeAg = 0;
							int br_cons = 0;
							String fee_amt = "";
							
							if (!br_to.equals("")) {
								Hashtable estiCommVarSh = oh_db.getEstiCommVarSh();
								Hashtable shData = new Hashtable();
								
								if (!e_bean1.getEst_id().equals("")) {
									reg_code = e_bean1.getReg_code().toString();
									shData = oh_db.getSecondhandCaseData(car_mng_id, reg_code);
									
									str_ag = e_bean1.getMgr_ssn().toUpperCase() + "_AG";
									feeAg = AddUtil.parseInt(shData.get(str_ag).toString());
									br_cons = AddUtil.parseInt(estiCommVarSh.get("BR_CONS_" + br_from + br_to).toString());
									fee_amt = oh_db.getSecondHandBrAmtCalculate((int)(e_bean1.getFee_s_amt()+e_bean1.getDriver_add_amt()*0.9), feeAg, br_cons);
									
									fee_s_amt_1 = AddUtil.parseInt(fee_amt);
									fee_v_amt_1 = (int)(AddUtil.parseInt(fee_amt) * 0.1);
									fee_t_amt_1 = fee_s_amt_1 + fee_v_amt_1 + e_bean1.getDriver_add_amt();	
								}
								
								if (!e_bean2.getEst_id().equals("")) {
									reg_code = e_bean2.getReg_code().toString();
									shData = oh_db.getSecondhandCaseData(car_mng_id, reg_code);
									
									str_ag = e_bean2.getMgr_ssn().toUpperCase() + "_AG";
									feeAg = AddUtil.parseInt(shData.get(str_ag).toString());
									br_cons = AddUtil.parseInt(estiCommVarSh.get("BR_CONS_" + br_from + br_to).toString());
									fee_amt = oh_db.getSecondHandBrAmtCalculate((int)(e_bean2.getFee_s_amt()+e_bean2.getDriver_add_amt()*0.9), feeAg, br_cons);
									
									fee_s_amt_2 = AddUtil.parseInt(fee_amt);
									fee_v_amt_2 = (int)(AddUtil.parseInt(fee_amt) * 0.1);
									fee_t_amt_2 = fee_s_amt_2 + fee_v_amt_2 + e_bean2.getDriver_add_amt();
								}
								
								if (!e_bean3.getEst_id().equals("")) {
									reg_code = e_bean3.getReg_code().toString();
									shData = oh_db.getSecondhandCaseData(car_mng_id, reg_code);
									
									str_ag = e_bean3.getMgr_ssn().toUpperCase() + "_AG";
									feeAg = AddUtil.parseInt(shData.get(str_ag).toString());
									br_cons = AddUtil.parseInt(estiCommVarSh.get("BR_CONS_" + br_from + br_to).toString());
									fee_amt = oh_db.getSecondHandBrAmtCalculate((int)(e_bean3.getFee_s_amt()+e_bean3.getDriver_add_amt()*0.9), feeAg, br_cons);
									
									fee_s_amt_3 = AddUtil.parseInt(fee_amt);
									fee_v_amt_3 = (int)(AddUtil.parseInt(fee_amt) * 0.1);
									fee_t_amt_3 = fee_s_amt_3 + fee_v_amt_3 + e_bean3.getDriver_add_amt();
								}
								
								if (!e_bean4.getEst_id().equals("")) {
									reg_code = e_bean4.getReg_code().toString();
									shData = oh_db.getSecondhandCaseData(car_mng_id, reg_code);
									
									str_ag = e_bean4.getMgr_ssn().toUpperCase() + "_AG";
									feeAg = AddUtil.parseInt(shData.get(str_ag).toString());
									br_cons = AddUtil.parseInt(estiCommVarSh.get("BR_CONS_" + br_from + br_to).toString());
									fee_amt = oh_db.getSecondHandBrAmtCalculate((int)(e_bean4.getFee_s_amt()+e_bean4.getDriver_add_amt()*0.9), feeAg, br_cons);
									
									fee_s_amt_4 = AddUtil.parseInt(fee_amt);
									fee_v_amt_4 = (int)(AddUtil.parseInt(fee_amt) * 0.1);
									fee_t_amt_4 = fee_s_amt_4 + fee_v_amt_4 + e_bean4.getDriver_add_amt();
								}
								
						  	} else {
						  		
								fee_s_amt_1 = (int)(e_bean1.getFee_s_amt()+e_bean1.getDriver_add_amt()*0.9);
								fee_v_amt_1 = (int)(e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt()*0.1);
								fee_t_amt_1 = (int)(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt());
								
							  	fee_s_amt_2 = (int)(e_bean2.getFee_s_amt()+e_bean2.getDriver_add_amt()*0.9);
								fee_v_amt_2 = (int)(e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt()*0.1);
								fee_t_amt_2 = (int)(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt());
								
							  	fee_s_amt_3 = (int)(e_bean3.getFee_s_amt()+e_bean3.getDriver_add_amt()*0.9);
								fee_v_amt_3 = (int)(e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt()*0.1);
								fee_t_amt_3 = (int)(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt());
								
							  	fee_s_amt_4 = (int)(e_bean4.getFee_s_amt()+e_bean4.getDriver_add_amt()*0.9);
								fee_v_amt_4 = (int)(e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt()*0.1);
								fee_t_amt_4 = (int)(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt());
						  	}
	          				%>
	          				<tr>
								<td bgcolor=f2f2f2 width=20 style="border-bottom-color:f2f2f2;">&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2 width=138 ><span class=style3>���ް�</span></td>
	          					<%-- <td align=right bgcolor=ffffff><span class=style4><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getDriver_add_amt()*0.9)%> ��</span>&nbsp;</td>  
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getDriver_add_amt()*0.9)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getDriver_add_amt()*0.9)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getDriver_add_amt()*0.9)%> ��<%}%></span>&nbsp;</td> --%>
	          					<td align=right bgcolor=ffffff><span class=style4><%=AddUtil.parseDecimal(fee_s_amt_1)%> ��</span>&nbsp;</td>  
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(fee_s_amt_2)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(fee_s_amt_3)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(fee_s_amt_4)%> ��<%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td bgcolor=f2f2f2 style="border-bottom-color:f2f2f2">&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2><span class=style3>�ΰ���</span></td>
	          					<%-- <td align=right bgcolor=ffffff><span class=style4><%=AddUtil.parseDecimal(e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt()*0.1)%> ��</span>&nbsp;</td>  
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt()*0.1)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt()*0.1)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt()*0.1)%> ��<%}%></span>&nbsp;</td> --%>
	          					<td align=right bgcolor=ffffff><span class=style4><%=AddUtil.parseDecimal(fee_v_amt_1)%> ��</span>&nbsp;</td>  
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(fee_v_amt_2)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(fee_v_amt_3)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(fee_v_amt_4)%> ��<%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
	          					<td height=17 bgcolor=f2f2f2 colspan="2" align="center"><span class=style3>���뿩��</span></td>
	          					<%-- <td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt())%> ��</span>&nbsp;</td>  
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt())%> ��<%}%></span>&nbsp;</td> --%>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%=AddUtil.parseDecimal(fee_t_amt_1)%> ��</span>&nbsp;</td>  
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(fee_t_amt_2)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(fee_t_amt_3)%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(fee_t_amt_4)%> ��<%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
								<td bgcolor=f2f2f2 style="border-bottom-color:f2f2f2;">&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2><span class=style3>������</span></td>
	          					<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%=Math.round(e_bean1.getRg_8())%>%</td>
											<td align=right style="border:0px;" width=90><span class=style4><%=AddUtil.parseDecimal(e_bean1.getGtr_amt())%> ��</span>&nbsp;</td>  
										</tr>
									</table>
	          					<td align=right bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean2.getEst_id().equals("")){%><%=Math.round(e_bean2.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getGtr_amt())%> ��<%}%></span>&nbsp;</td>
										</tr>
									</table>
	          					<td align=right bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean3.getEst_id().equals("")){%><%=Math.round(e_bean3.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getGtr_amt())%> ��<%}%></span>&nbsp;</td>
										</tr>
									</table>
								</td>
	          					<td align=right bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=45><%if(!e_bean4.getEst_id().equals("")){%><%=Math.round(e_bean4.getRg_8())%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getGtr_amt())%> ��<%}%></span>&nbsp;</td>
										</tr>
									</table>
								</td>
	          				</tr> 
	          				<tr>
								<td bgcolor=f2f2f2 style="border-bottom-color:f2f2f2;">&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2><span class=style3>������(VAT����)</span></td>
	          					<td align=right bgcolor=ffffff><span class=style4><%=AddUtil.parseDecimal(e_bean1.getPp_s_amt()+e_bean1.getPp_v_amt())%> ��</span>&nbsp;</td>  
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getPp_s_amt()+e_bean2.getPp_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getPp_s_amt()+e_bean3.getPp_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getPp_s_amt()+e_bean4.getPp_v_amt())%> ��<%}%></span>&nbsp;</td>
	          				</tr>
	          				<tr>
								<td bgcolor=f2f2f2 style="border-bottom-color:f2f2f2;">&nbsp;</td>
	          					<td height=17 align=center bgcolor=f2f2f2><span class=style3>���ô뿩��(VAT����)</span></td>
	          					<td align=right bgcolor=ffffff><span class=style4><%=AddUtil.parseDecimal(e_bean1.getIfee_s_amt()+e_bean1.getIfee_v_amt())%> ��</span>&nbsp;</td>  
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getIfee_s_amt()+e_bean2.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getIfee_s_amt()+e_bean3.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=ffffff><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getIfee_s_amt()+e_bean4.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          				</tr> 
	          				<tr>
	          					<td height=17 bgcolor=f2f2f2 colspan="2" align="center"><span class=style3>�ʱⳳ�Ա� �հ�</span></td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%=AddUtil.parseDecimal(e_bean1.getGtr_amt()+e_bean1.getPp_s_amt()+e_bean1.getPp_v_amt()+e_bean1.getIfee_s_amt()+e_bean1.getIfee_v_amt())%> ��</span>&nbsp;</td>  
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getGtr_amt()+e_bean2.getPp_s_amt()+e_bean2.getPp_v_amt()+e_bean2.getIfee_s_amt()+e_bean2.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getGtr_amt()+e_bean3.getPp_s_amt()+e_bean3.getPp_v_amt()+e_bean3.getIfee_s_amt()+e_bean3.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          					<td align=right bgcolor=f2f2f2 class="bd_top"><span class=style6><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getGtr_amt()+e_bean4.getPp_s_amt()+e_bean4.getPp_v_amt()+e_bean4.getIfee_s_amt()+e_bean4.getIfee_v_amt())%> ��<%}%></span>&nbsp;</td>
	          				</tr> 
						</table>
						<%	
						  e_bean1.setGi_amt(0);		e_bean2.setGi_amt(0);	e_bean3.setGi_amt(0);	e_bean4.setGi_amt(0);
						  e_bean1.setGi_fee(0);		e_bean2.setGi_fee(0);	e_bean3.setGi_fee(0);	e_bean4.setGi_fee(0);%>
						<%if(e_bean1.getGi_amt()+e_bean2.getGi_amt()+e_bean3.getGi_amt()+e_bean4.getGi_amt() > 0){%>
						<table width=680 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4 style="margin-top: 2px;">
							<tr>	
								<td align=center bgcolor=f2f2f2 width=166>�������� ���Աݾ�</td>
								<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center bgcolor=ffffff width=135><%=e_bean1.getGi_per()%>%</td>
											<td align=right style="border:0px;" width=90><span class=style4><%=AddUtil.parseDecimal(e_bean1.getGi_amt())%> ��&nbsp;</span></td>
										</tr>
									</table>
								</td>
								<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center bgcolor=ffffff width=135><%if(!e_bean2.getEst_id().equals("")){%><%=e_bean2.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean2.getGi_amt())%> ��&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
								<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center bgcolor=ffffff width=135><%if(!e_bean3.getEst_id().equals("")){%><%=e_bean3.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean3.getGi_amt())%> ��&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
								<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center bgcolor=ffffff width=135><%if(!e_bean4.getEst_id().equals("")){%><%=e_bean4.getGi_per()%>%<%}%></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=AddUtil.parseDecimal(e_bean4.getGi_amt())%> ��&nbsp;<%}%></span></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td align=center bgcolor=f2f2f2>
									���������
									<%-- <br>
									<span style="font-size: 11px;">�� �ſ��� <%=e_bean1.getGi_grade()%>��ޱ���</span> --%>
								</td>
								<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center bgcolor=ffffff width=55><span class=style4><%=e_bean1.getA_b()%>����ġ</span></td>
											<td align=right bgcolor=ffffff width=80>
												<span class=style4>												
													<%if (e_bean1.getGi_amt() > 0) {%>
							                          	<%if (!e_bean1.getGi_grade().equals("")) {%>
							                          		<%=AddUtil.parseDecimal(e_bean1.getGi_fee())%>
							                          	<%}%>
							                          	&nbsp;��&nbsp;
						                          	<%} else {%>
						                          		<%=AddUtil.parseDecimal(e_bean1.getGi_fee())%>&nbsp;��&nbsp;
						                          	<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
								<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center bgcolor=ffffff width=55><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%=e_bean2.getA_b()%>����ġ<%}%></span></td>
											<td align=right bgcolor=ffffff width=80>
												<span class=style4>												
													<%if(!e_bean2.getEst_id().equals("")){%>
														<%if (e_bean2.getGi_amt() > 0) {%>
								                          	<%if (!e_bean2.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean2.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;��&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean2.getGi_fee())%>&nbsp;��&nbsp;
							                          	<%}%>
													<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
								<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center bgcolor=ffffff width=55><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%=e_bean3.getA_b()%>����ġ<%}%></span></td>
											<td align=right bgcolor=ffffff width=80>
												<span class=style4>												
													<%if(!e_bean3.getEst_id().equals("")){%>
														<%if (e_bean3.getGi_amt() > 0) {%>
								                          	<%if (!e_bean3.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean3.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;��&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean3.getGi_fee())%>&nbsp;��&nbsp;
							                          	<%}%>
													<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
								<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center bgcolor=ffffff width=55><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%=e_bean4.getA_b()%>����ġ<%}%></span></td>
											<td align=right bgcolor=ffffff width=80>
												<span class=style4>												
													<%if(!e_bean4.getEst_id().equals("")){%>
														<%if (e_bean4.getGi_amt() > 0) {%>
								                          	<%if (!e_bean4.getGi_grade().equals("")) {%>
								                          		<%=AddUtil.parseDecimal(e_bean4.getGi_fee())%>
								                          	<%}%>
								                          	&nbsp;��&nbsp;
							                          	<%} else {%>
							                          		<%=AddUtil.parseDecimal(e_bean4.getGi_fee())%>&nbsp;��&nbsp;
							                          	<%}%>
													<%}%>
												</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<%}%>
<!--�����ܰ���-->
<%	if(e_bean1.getA_a().equals("22") || e_bean1.getA_a().equals("12")){//�⺻��
		if(e_bean1.getRo_13_amt() > 0 && AddUtil.parseInt(e_bean1.getA_b()) < 24){
			e_bean1.setRo_13(0);		e_bean1.setRo_13_amt(0);
		}
		if(stat.equals("�߰���������")){
			e_bean1.setRo_13(0);		e_bean1.setRo_13_amt(0);
		}
//		if(cm_bean.getDiesel_yn().equals("2")){//�Ϲݽ¿�LPG�������� ���Կɼ� ������
		if(AddUtil.parseInt(e_bean.getRent_dt()) < 20190419 && cm_bean.getDiesel_yn().equals("2")){	//20190419
			if(cm_bean.getS_st().equals("300") || cm_bean.getS_st().equals("301") || cm_bean.getS_st().equals("302")){
				e_bean1.setRo_13(0);		e_bean1.setRo_13_amt(0);
			}
		}
	}else{	e_bean1.setRo_13(0);		e_bean1.setRo_13_amt(0);	}%>
	
<%	if(e_bean2.getA_a().equals("22") || e_bean2.getA_a().equals("12")){//�⺻��
		if(e_bean2.getRo_13_amt() > 0 && AddUtil.parseInt(e_bean2.getA_b()) < 24){
			e_bean2.setRo_13(0);		e_bean2.setRo_13_amt(0);
		}
		if(stat.equals("�߰���������")){
			e_bean2.setRo_13(0);		e_bean2.setRo_13_amt(0);
		}
//		if(cm_bean.getDiesel_yn().equals("2")){//�Ϲݽ¿�LPG�������� ���Կɼ� ������
		if(AddUtil.parseInt(e_bean.getRent_dt()) < 20190419 && cm_bean.getDiesel_yn().equals("2")){	//20190419
			if(cm_bean.getS_st().equals("300") || cm_bean.getS_st().equals("301") || cm_bean.getS_st().equals("302")){
				e_bean2.setRo_13(0);		e_bean2.setRo_13_amt(0);
			}
		}
	}else{	e_bean2.setRo_13(0);		e_bean2.setRo_13_amt(0);	}%>
	
<%	if(e_bean3.getA_a().equals("22") || e_bean3.getA_a().equals("12")){//�⺻��
		if(e_bean3.getRo_13_amt() > 0 && AddUtil.parseInt(e_bean3.getA_b()) < 24){
			e_bean3.setRo_13(0);		e_bean3.setRo_13_amt(0);
		}
		if(stat.equals("�߰���������")){
			e_bean3.setRo_13(0);		e_bean3.setRo_13_amt(0);
		}
//		if(cm_bean.getDiesel_yn().equals("2")){//�Ϲݽ¿�LPG�������� ���Կɼ� ������
		if(AddUtil.parseInt(e_bean.getRent_dt()) < 20190419 && cm_bean.getDiesel_yn().equals("2")){	//20190419
			if(cm_bean.getS_st().equals("300") || cm_bean.getS_st().equals("301") || cm_bean.getS_st().equals("302")){
				e_bean3.setRo_13(0);		e_bean3.setRo_13_amt(0);
			}
		}
	}else{	e_bean3.setRo_13(0);		e_bean3.setRo_13_amt(0);	}%>
	
<%	if(e_bean4.getA_a().equals("22") || e_bean4.getA_a().equals("12")){//�⺻��
		if(e_bean4.getRo_13_amt() > 0 && AddUtil.parseInt(e_bean4.getA_b()) < 24){
			e_bean4.setRo_13(0);		e_bean4.setRo_13_amt(0);
		}
		if(stat.equals("�߰���������")){
			e_bean4.setRo_13(0);		e_bean4.setRo_13_amt(0);
		}
//		if(cm_bean.getDiesel_yn().equals("2")){//�Ϲݽ¿�LPG�������� ���Կɼ� ������
		if(AddUtil.parseInt(e_bean.getRent_dt()) < 20190419 && cm_bean.getDiesel_yn().equals("2")){	//20190419
			if(cm_bean.getS_st().equals("300") || cm_bean.getS_st().equals("301") || cm_bean.getS_st().equals("302")){
				e_bean4.setRo_13(0);		e_bean4.setRo_13_amt(0);
			}
		}
	}else{	e_bean4.setRo_13(0);		e_bean4.setRo_13_amt(0);	}%>
			
						<table width=680 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4 style="margin-top: 2px;">
							<tr>
								<td align=center bgcolor=f2f2f2 width=166>���Կɼǰ���(VAT����)</td>
								<td bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=35><span class=style4><%if(e_bean1.getRo_13()!=0){%><%=e_bean1.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(e_bean1.getRo_13()!=0){%><%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%> ��<%}else{%>���Կɼ� ����<%}%></span></td>  
										</tr>
									</table>
	          					<td align=right bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=35><span class=style4><%if(!e_bean2.getEst_id().equals("") && e_bean2.getRo_13()!=0){%><%=e_bean2.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean2.getEst_id().equals("")){%><%if(e_bean2.getRo_13()!=0){%><%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%> ��<%}else{%>���Կɼ� ����<%}%><%}%></span></td>  
										</tr>
									</table>
	          					<td align=right bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=35><span class=style4><%if(!e_bean3.getEst_id().equals("") && e_bean3.getRo_13()!=0){%><%=e_bean3.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean3.getEst_id().equals("")){%><%if(e_bean3.getRo_13()!=0){%><%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%> ��<%}else{%>���Կɼ� ����<%}%><%}%></span></td>  
										</tr>
									</table>
								</td>
	          					<td align=right bgcolor=ffffff>
									<table width=135>
										<tr>
											<td align=center style="border:0px;" width=35><span class=style4><%if(!e_bean4.getEst_id().equals("") && e_bean4.getRo_13()!=0){%><%=e_bean4.getRo_13()%>%<%}%></span></td>
											<td align=right style="border:0px;" width=90><span class=style4><%if(!e_bean4.getEst_id().equals("")){%><%if(e_bean4.getRo_13()!=0){%><%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%> ��<%}else{%>���Կɼ� ����<%}%><%}%></span></td>  
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<table width=680 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4 style="margin-top: 2px;">
							<tr>
	            				<td bgcolor=f2f2f2 height=17 align=center><span class=style3>���� ��������Ÿ�</span></td>
		            			<td bgcolor=ffffff align=right width=135><span class=style6><%=AddUtil.parseDecimal(e_bean1.getAgree_dist())%>km</span> ����&nbsp;</td>
		            			<td bgcolor=ffffff align=right width=135><%if(!e_bean2.getEst_id().equals("")){%><span class=style6><%=AddUtil.parseDecimal(e_bean2.getAgree_dist())%>km</span> ����&nbsp;<%}%></td>
						      	<td bgcolor=ffffff align=right width=135><%if(!e_bean3.getEst_id().equals("")){%><span class=style6><%=AddUtil.parseDecimal(e_bean3.getAgree_dist())%>km</span> ����&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right width=135><%if(!e_bean4.getEst_id().equals("")){%><span class=style6><%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>km</span> ����&nbsp;<%}%></td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=f2f2f2 height=17 align=center><span class=style3 style="font-size: 11px">�ʰ�����뿩��(VAT����)</span></td>
		            			<td bgcolor=ffffff align=right>�ʰ� 1km�� &nbsp;<b>(<%=e_bean1.getOver_run_amt()%>)��</b>&nbsp;</td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean2.getEst_id().equals("")){%>�ʰ� 1km�� &nbsp;<b>(<%=e_bean2.getOver_run_amt()%>)��</b>&nbsp;<%}%></td>
						      	<td bgcolor=ffffff align=right><%if(!e_bean3.getEst_id().equals("")){%>�ʰ� 1km�� &nbsp;<b>(<%=e_bean3.getOver_run_amt()%>)��</b>&nbsp;<%}%></td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean4.getEst_id().equals("")){%>�ʰ� 1km�� &nbsp;<b>(<%=e_bean4.getOver_run_amt()%>)��</b>&nbsp;<%}%></td>
		            		</tr>
		            		<tr>
		            			<td bgcolor=f2f2f2 height=17 align=center><span class=style3>���Կɼ� ����<br>�ʰ�����뿩��</span></td>
		            			<td bgcolor=ffffff align=right><%if(e_bean1.getRo_13()!=0){%><%if(e_bean1.getA_a().equals("12")||e_bean1.getA_a().equals("22")){%>����<%}else{%>50%�� ����<%}%><%}else{%>���Կɼ� ����<%}%>&nbsp;</td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean2.getEst_id().equals("")){%><%if(e_bean2.getRo_13()!=0){%><%if(e_bean2.getA_a().equals("12")||e_bean2.getA_a().equals("22")){%>����<%}else{%>50%�� ����<%}%><%}else{%>���Կɼ� ����<%}%><%}%>&nbsp;</td>
						      	<td bgcolor=ffffff align=right><%if(!e_bean3.getEst_id().equals("")){%><%if(e_bean3.getRo_13()!=0){%><%if(e_bean3.getA_a().equals("12")||e_bean3.getA_a().equals("22")){%>����<%}else{%>50%�� ����<%}%><%}else{%>���Կɼ� ����<%}%><%}%>&nbsp;</td>
		            			<td bgcolor=ffffff align=right><%if(!e_bean4.getEst_id().equals("")){%><%if(e_bean4.getRo_13()!=0){%><%if(e_bean4.getA_a().equals("12")||e_bean4.getA_a().equals("22")){%>����<%}else{%>50%�� ����<%}%><%}else{%>���Կɼ� ����<%}%><%}%>&nbsp;</td>
		            		</tr>
						</table>
						<table width=680 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4 style="margin-top: 2px;">
	          				<tr>
	          					<td height=17 align=center bgcolor=f2f2f2 width=141><span class=style3>�ߵ����� �����</span></td>
	          					<td width=140 align=right bgcolor=ffffff width=135 style="font-size: 11px;">�ܿ��Ⱓ �뿩���� <span class=style6><%if(e_bean1.getCls_per()>0){%><%=e_bean1.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean1.getCls_per())%><%}else{%>30<%}%>%</span>&nbsp;</td>  
	          					<td width=140 align=right bgcolor=ffffff width=135 style="font-size: 11px;"><%if(!e_bean2.getEst_id().equals("")){%>�ܿ��Ⱓ �뿩���� <span class=style6><%if(e_bean2.getCls_per()>0){%><%=e_bean2.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean2.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>
	          					<td width=140 align=right bgcolor=ffffff width=135 style="font-size: 11px;"><%if(!e_bean3.getEst_id().equals("")){%>�ܿ��Ⱓ �뿩���� <span class=style6><%if(e_bean3.getCls_per()>0){%><%=e_bean3.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean3.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>
	          					<td width=140 align=right bgcolor=ffffff width=135 style="font-size: 11px;"><%if(!e_bean4.getEst_id().equals("")){%>�ܿ��Ⱓ �뿩���� <span class=style6><%if(e_bean4.getCls_per()>0){%><%=e_bean4.getCls_per()%><%//=AddUtil.parseFloatNotDot(e_bean4.getCls_per())%><%}else{%>30<%}%>%<%}%></span>&nbsp;</td>
	          				</tr>  
	          			</table>
	          		</td>
	          	</tr> 
	          	<tr>
	          		<td colspan="2" height="5"></td>
	          	</tr>
        		<!--��ǰ-->
        		<%if(e_bean.getTint_b_yn().equals("Y") || e_bean.getTint_s_yn().equals("Y")|| e_bean.getTint_n_yn().equals("Y")|| e_bean.getTint_eb_yn().equals("Y")){
        				String tint_all = "";
        				if(e_bean.getTint_b_yn().equals("Y")){	tint_all +="1";	}		//2ä�� ���ڽ�
        				if(e_bean.getTint_s_yn().equals("Y")){	tint_all +="2";	}		//���� ����
        				if(e_bean.getTint_n_yn().equals("Y")){	tint_all +="3";	}		//��ġ�� ������̼�
        				if(e_bean.getTint_eb_yn().equals("Y")){	tint_all +="4";	}		//�̵��� ������ �뿩���
        		%>      
                <tr> 
			    	<td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style3>�� 
			    		<%if(tint_all.equals("1")){%>�� �뿩����� 2ä�� ���ڽ��� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("2")){%>�� �뿩����� ���� ������ ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("3")){%>�� �뿩����� ��ġ�� ������̼��� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("4")){%>�� �뿩����� �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("12")){%>�� �뿩����� 2ä�� ���ڽ��� ���� ������ ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("13")){%>�� �뿩����� 2ä�� ���ڽ��� ��ġ�� ������̼��� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("14")){%>�� �뿩����� 2ä�� ���ڽ��� �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("23")){%>�� �뿩����� ���� ���ð� ��ġ�� ������̼��� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("24")){%>�� �뿩����� ���� ���ð� �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("34")){%>�� �뿩����� ��ġ�� ������̼ǰ� �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("123")){%>�� �뿩����� 2ä�� ���ڽ�, ���� ����, ��ġ�� ������̼��� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("124")){%>�� �뿩����� 2ä�� ���ڽ�, ���� ����, �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("134")){%>�� �뿩����� 2ä�� ���ڽ�, ��ġ�� ������̼�, �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("234")){%>�� �뿩����� ���� ����, ��ġ�� ������̼�, �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>
                       	<%if(tint_all.equals("1234")){%>�� �뿩����� 2ä�� ���ڽ�, ���� ����, ��ġ�� ������̼�, �̵��� ������ �뿩����� ���Ե� �ݾ��Դϴ�.<%}%>    
			    		</span>
                    </td>
                </tr>                        
                <%}%>
	          	<tr> 
                    <td colspan="2"><span class=style4>�� �� �������� ���Ⱓ ���� �� ȯ���� �帳�ϴ�.<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [������ 100������ �����ϸ�, ���뿩�� 5,500��(VAT����)�� ���ϵ˴ϴ�.(�⸮6.6%ȿ��)]<br>
                    &nbsp;&nbsp;&nbsp;&nbsp; �� �������� �ſ� ���� �ݾ׾� �����Ǿ� �Ҹ�Ǵ� ���Դϴ�.<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �� ���ݰ�꼭�� ����̿�Ⱓ ���� �ſ� �յ� ���� �Ǵ� ���ν� �Ͻ� ���� �� ���ð���<br><!-- 2018.01.23 �߰� -->
                    &nbsp;&nbsp;&nbsp;&nbsp; �� ���ô뿩��� ������ (<%=e_bean.getG_10()%>)����ġ �뿩�Ḧ �����ϴ� ���Դϴ�.
					<%if(AddUtil.parseInt(cm_bean.getJg_code()) < 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000)){%>
	                    <br>
	                    &nbsp;&nbsp;&nbsp;&nbsp; �� �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� ���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.
                    <%}%>
                    <%if(AddUtil.parseInt(cm_bean.getJg_code()) > 1000000 && (AddUtil.parseInt(cm_bean.getJg_code()) > 6999999 || AddUtil.parseInt(cm_bean.getJg_code()) < 2000000)){%>
	                    <br>
	                    &nbsp;&nbsp;&nbsp;&nbsp; �� �뿩��(���뿩��,������)�� ���������� �պ�ó�� ������ ��� �ΰ����� ���Լ��װ���(ȯ��)������ �� �ֽ��ϴ�.
                    <%}%>
					<br>
					�� ��������Ÿ��� ���̸� �뿩����� ���ϵǰ�, ��������Ÿ��� �ø��� �뿩����� �λ�˴ϴ�.
					<%if(e_bean1.getGi_amt()+e_bean2.getGi_amt()+e_bean3.getGi_amt()+e_bean4.getGi_amt() > 0){%>
					<br>
					�� �ſ��޺��� ��������ᰡ �޶����ϴ�.
					<%}%>
                    </span></td>
                </tr>
	         <!-- ���뿩�� �� �ʱⳳ�Ա� end -->  
			    <%if(e_bean.getPp_ment_yn().equals("Y")){%>          
		        <tr> 
				    <td colspan=2>&nbsp;<span class=style3>* �ʱⳳ�Ա��� ������ �ſ뵵�� ���� �ɻ�������� ������ �� �ֽ��ϴ�.</span></td>
		        </tr>
		      	<%}%>	         
	      		<%if(e_bean.getTint_ps_yn().equals("Y")){%> 
                <tr>
                	<td colspan=3 class=listnum2 valign=top>
					<%if(e_bean.getTint_ps_st().equals("Y")){%>&nbsp;<span class=style3>* ���ñ���: ��޽���</span>
                	<%}else if(e_bean.getTint_ps_st().equals("N")){%>
                	<%}else if(e_bean.getTint_ps_st().equals("I")){ %>&nbsp;<span class=style3>* <%=e_bean.getTint_ps_nm()%></span>
                	<%} %>
	                </td>
	           	</tr>
                <%}%>
	          	<tr> 
	             	<td height=10 colspan="2"></td>
	          	</tr>
          		<tr> 
            		<td colspan="2">
            		<%if(ej_bean.getJg_k().equals("2")){%><img width="680" src=../main_car_hp/images/bar_04_service_dc_prt.gif><%} else if(ej_bean.getJg_k().equals("0")){%><img width="680" src=../main_car_hp/images/bar_04_service_ndc_prt.gif><%} else if(ej_bean.getJg_k().equals("3")){%><img width="680" src=../main_car_hp/images/bar_04_3.gif><%}else{%><img width="680" src=../main_car_hp/images/bar_04_service_prt.gif><%}%>
	            	    <%-- <%if(e_bean.getA_a().equals("22") || e_bean.getA_a().equals("12")){%>
	            	        <%if(ej_bean.getJg_k().equals("0")){%>
	            	        <img src=../main_car_hp/images/bar_06_1_2.gif width=680 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=../main_car_hp/images/bar_06_1_1.gif width=680 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
	            	        <img src=../main_car_hp/images/bar_06_3.gif width=680 height=22>
	            	        <%}else{%>
	            	        <img src=../main_car_hp/images/bar_06_1.gif width=680 height=22>
	            	        <%}%>
	            	    <%}else{%>
	            	        <%if(ej_bean.getJg_k().equals("2")){%>
	            	        <img src=../main_car_hp/images/bar_05_1_1.gif width=680 height=22>
	            	        <%}else if(ej_bean.getJg_k().equals("3")){%><!-- �������񽺴� �Ϲ� ��������������� ���� 2017.11.15 -->
	            	        <img src=../main_car_hp/images/bar_05_3.gif width=680 height=22>
	            	        <%}else{%>
	            	        <img src=../main_car_hp/images/bar_05.gif width=680 height=22>
	            	        <%}%>	            	    	            	        
	            	    <%	}%> --%> 
            		</td>
          		</tr>
	           	<tr> 
	           		<td height=4 colspan="2"></td>
	          	</tr>
          		<tr> 
		        	<td colspan="2" valign=top> 
		          		<table width=680 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
		                  	<tr> 
		                     	<td width=92 height=17 align=center bgcolor=f2f2f2><span class=style3>���뼭��</span></td>
		                    	<td width=543 colspan=2 bgcolor=#FFFFFF>&nbsp;<%if(!e_bean.getInsurant().equals("2")){%>* ������ �߻��� <span class=style10>���ó�� ���� ����</span><%}%> &nbsp; <%if(e_bean.getIns_per().equals("2") || ej_bean.getJg_k().equals("0")){%><%}else{%>&nbsp;*<span class=style10> ����������</span>(���ػ��ô� �������)<%}%></td>
		                    </tr>
		                </table>
		          	</td>
	         	</tr>
		        <tr>
		         	<td colspan="2">
		                <table width=680 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4 style="margin-top: 2px;">
		                    <tr>
		                       	<td align=center bgcolor=#f2f2f2 height=17><span style="vertical-align:3px;"><span class="style10">�⺻��</span> (���񼭺� ������ ��ǰ)</span></td>
		                     	<td align=center bgcolor=#f2f2f2 align=left>&nbsp;<span style="vertical-align:3px;"><span class="style10">�Ϲݽ�</span> (���񼭺� ���� ��ǰ)</span></td>
		                  	</tr>
		                  	<tr>
		                  		<td width=50% bgcolor=#FFFFFF height=95>&nbsp; <span class=style10>* �Ƹ����ɾ� ����</span><br>
		                  			&nbsp;&nbsp;&nbsp;&nbsp; - ���� ���� ���� ���� ��㼭�� ��� ����<br>
		                  			<%if(!e_bean.getEst_st().equals("2")){%>
		                  			&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� �̳� ���� ������� ����<%if(e_bean.getCar_comp_id().equals("0056")) {%>(�׽������� ����)<%}%><br>
			                  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (24�ð� �̻� ������� �԰��)<br> 		                  		
			                  		&nbsp;&nbsp;&nbsp;&nbsp; - �뿩 ���� 2���� ����
			                  		<%}else{%>
			                  		&nbsp;&nbsp;&nbsp;&nbsp; - 
			                  		<%}%>
		                  		 	���� ������ ���� ������� ����<br>
		                  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (�ܱ� �뿩����� 15~30% ����, Ź�۷� ����)</td>
		                   		<td width=279 bgcolor=#FFFFFF align=left>&nbsp; <span class=style10>* ��ü�� ���񼭺�</span><br>
			                   		&nbsp;&nbsp;&nbsp;&nbsp; - ���� ��������ǰ/�Ҹ�ǰ ����, ��ȯ, ����<br>
			                   		&nbsp;&nbsp;&nbsp;&nbsp; - ������ ���� ��޼��� ����<br>
			                   		&nbsp; <span class=style10>* �����������</span><br> 
			                   		&nbsp;&nbsp;&nbsp;&nbsp; - 4�ð� �̻� ������� �԰��</td>
		                 	</tr>
		         		</table>
		         	</td>
		        </tr>
	          	<tr> 
	            	<td height=5 colspan="2"></td>
	          	</tr>
				<!-- ��Ÿ �뿩����-->
		    	<tr> 
		            <td colspan="2"><img width="680" src=../main_car_hp/images/bar_05_etc_prt.gif></td>
		    	</tr>
		  		<tr> 
		            <td height=4 colspan="2"></td>
		   		</tr>
	          	<tr> 
		            <td colspan="2" align=center> 
		            	<table width=671 border=0 cellspacing=0 cellpadding=0>
			                <tr> 
			                  	<td width=28 height=17 align=right><img src=../main_car_hp/images/1.gif width=13 height=13 align=absmiddle></td>
			                  	<td width=8>&nbsp;</td>
			                  	<td width=635 colspan=2 align=left class=listnum2>���, �ڵ����� ����, ����˻�  � �Ƹ���ī���� ó��(�� ��� �δ� ����)</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=../main_car_hp/images/2.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>FMS(Fleet Management System)�� ���ؼ� ���������������� ����(www.amazoncar.co.kr)</td>
			                </tr>
			                <tr> 
			                  	<td colspan=4><img src=../main_car_hp/images/line_1.gif width=621 height=1></td>
			                </tr>
			                <tr> 
			                  	<td height=17 align=right><img src=../main_car_hp/images/3.gif width=13 height=13 align=absmiddle></td>
			                  	<td>&nbsp;</td>
			                  	<td colspan=2 align=left class=listnum2>�뿩�Ⱓ ����ÿ��� �ݳ�, �����̿�(���ο�� ����), ���Կɼ� ���(���Կɼ� ���� ���) �� ���� ����</td>
			                </tr>
			  			</table>
		           	</td>
	          	</tr>
		      	<tr> 
		            <td align=right><img src=../main_car_hp/images/ceo.gif>&nbsp;</td>
		            <td align=right>&nbsp;</td>
		     	</tr>
		     	<tr> 
			    	<td height=10 colspan="2"></td>
			 	</tr>
        	</table>
        </td>
        <td width=21>&nbsp;</td>
    </tr>
	<!--�ʿ伭��ǥ�� start-->
    <!-- ����-->
	<%if(e_bean.getDoc_type().equals("1")){%>
    <tr>
        <td colspan=3 align=center>
            <table width=680 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img.gif>
                <tr>
                    <td colspan=2 align=left background=../main_car_hp/images/p_up_img.gif height=24>
                        <table width=680 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����غ񼭷� (����)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width=10>&nbsp;</td>
                    <td width=628  align=left>
                        <table width=628 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td valign=top>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>���⼭�� :</span></td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>	
                                <td>
                                    <table width=610 border=0 cellspacing=0 cellpadding=0 align=center>
                                        <tr>
                                            <td width=115 style="font-size:11px;" valign=top><span class=style4>1.��ǥ�̻� ���� �����:</span></td>
                                            <td style="font-size:11px;"><span class=style4>�� ����ڵ���� �纻  &nbsp;�� ��ǥ�̻� �ź��� �纻 &nbsp;�� �ڵ���ü���� �纻 &nbsp;�� �ֿ�����  ������  �纻 <br>�� ����Ȯ�ν� �ź��� �ǹ� ���� �ʼ�, ���� �� ���θ��� ���� �ʿ�</td>
                                        </tr>
                                     </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                       			<td>
                                	<table width=610 border=0 cellspacing=0 cellpadding=0 align=center>
                                    	<tr>
                                        	<td width=135 style="font-size:11px;" valign=top><span class=style4>2.��ǥ�̻� ���� ���� �Ұ���:</span></td>
                                            <td style="font-size:11px;"><span class=style4>�� ����ڵ���� �纻 &nbsp;�� �����ΰ����� 1�� &nbsp;�� ��ǥ�̻� �ź��� �纻 &nbsp;�� ��ǥ�̻� �ΰ����� 1�� <br>�� �ڵ���ü���� �纻 &nbsp;�� �ֿ����� ������ �纻 &nbsp;(�ΰ������� �ֱ� 3�����̳� �߱޺�)</span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td colspan=2>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>�ſ�ɻ� ������ : </span>  &nbsp;&nbsp;<span class=style4>�繫��ǥ(��������ǥ, ���Ͱ�꼭 ��) &nbsp;&nbsp;�� �ʿ�� ���뺸����(��ǥ�̻�)�� �ֹε�ϵ</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=2><img src=../main_car_hp/images/p_dw_img.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>			
	<%}else if(e_bean.getDoc_type().equals("2")){%>
    <!-- ���λ����-->
    <tr>
        <td colspan=3 align=center>
            <table width=680 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img.gif height=24>
                        <table width=680 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����غ񼭷� (���λ����)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50 width=15>&nbsp;</td>
                    <td width=608 align=left>
                        <table width=608 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=8></td>
                            </tr>
                            <tr>
                                <td width=88 valign=top>&nbsp;<img src=/acar/main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>���⼭�� :</span></td>
                                <td width=540>
                                    <table width=540 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td style="font-size:11px;"><span class=style4>�� ����ڵ���� �纻  &nbsp;&nbsp;�� �ź��� �纻 &nbsp;&nbsp;�� �ڵ���ü���� �纻 &nbsp;&nbsp;�� �ֿ����� ������ �纻<br> 
                                           		 �� ����Ȯ�ν� �ź��� �ǹ� ���� �ʼ� <br>
                                           		 �� �Ұ����� �������� ������� ������ ����� �븮�ؾ� �� ��쿡�� ������� �����ΰ������� �����ϰ� <br> �� �����ΰ�����(�ֱ� 3�����̳� �߱޵� ��)�� ÷���Ͽ� ����� ü���� �� �ֽ��ϴ�.</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td style="font-size:11px;" colspan=2>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>�ſ�ɻ� ������ :</span> &nbsp;&nbsp;<span class=style4>���������ڷ� &nbsp;&nbsp;�� �ſ� �ɻ翡 �ʿ��� ��� �ֹε�ϵ ������ ��û�� �� �ֽ��ϴ�.</span></td>
                            </tr>
                        </table>
                    </td>
                    <td width=15>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan=3><img src=../main_car_hp/images/p_dw_img.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>		
    <!-- ����-->
    <%}else if(e_bean.getDoc_type().equals("3")){%>
    <tr>
        <td colspan=3 align=center>
            <table width=680 border=0 cellspacing=0 cellpadding=0 background=../main_car_hp/images/p_bg_img.gif>
                <tr>
                    <td colspan=3 align=left background=../main_car_hp/images/p_up_img.gif height=24>
                        <table width=680 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����غ񼭷� (����)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50 width=15>&nbsp;</td>
                    <td width=608 align=left>
                        <table width=608 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td colspan=2 height=8></td>
                            </tr>
                            <tr>
                                <td width=93>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>���⼭�� :</span></td>
                                <td width=535>
                                    <table width=525 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td style="font-size:11px;"><span class=style4>�� ���������� �纻  &nbsp;&nbsp;�� �ڵ���ü���� �纻</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 height=5></td>
                            </tr>
                            <tr>
                                <td colspan=2>&nbsp;<img src=../main_car_hp/images/dot.gif width=3 height=3 align=absmiddle> <span class=style12>�ſ�ɻ� ������ :</span> &nbsp;&nbsp;&nbsp;<span class=style4>��������, �ҵ������ڷ�(��õ¡�������� ��)<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;�� �ſ� �ɻ翡 �ʿ��� ��� �ֹε�ϵ ������ ��û�� �� �ֽ��ϴ�.</span></td>
                            </tr> 
                        </table>
                    </td>
                    <td width=15>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan=3><img src=../main_car_hp/images/p_dw_img.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>	
	<%}%>
	<!--�ʿ伭��ǥ�� end-->	
    <tr>
        <td align=center colspan=3>
    		<a href=javascript:go_print('<%= est_id %>'); title='������ ����Ʈ �ϱ�'><img src=../main_car_hp/images/button_print.gif border=0></a>&nbsp;&nbsp;
  		    <a href=javascript:go_mail('<%=cust_nm%>//<%=cust_tel%>//<%=cust_fax%>//<%=name%>//<%=m_tel%>//<%=h_tel%>//<%=i_fax%>//<%=email%>'); title='������ ���� �߼��ϱ�'><img src="../main_car_hp/images/button_send_mail.gif" border=0></a>&nbsp;&nbsp;
  		    <%-- <a href=javascript:go_mail('<%=est_id%>'); title='������ ���� �߼��ϱ�'><img src="../main_car_hp/images/button_send_mail.gif" border=0></a>&nbsp;&nbsp; --%>	
		    <%-- <a href=javascript:esti_result_sms('<%= est_id %>'); title='��� ���� �߼��ϱ�'><img src="../main_car_hp/images/button_sms.gif" border=0></a>&nbsp;&nbsp; --%>
	      	<%if(e_bean.getDoc_type().equals("")){%>
	      		<a href="javascript:go_paper();" title='����غ񼭷�����'><img src=../main_car_hp/images/button_paper.gif border=0></a>
	      	<%}%>
	    </td>
    </tr>
    <tr>
        <td height=15></td>
    </tr>
  	<tr bgcolor=80972e>
        <td height=6 colspan=3></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>	
    </body>
</html>