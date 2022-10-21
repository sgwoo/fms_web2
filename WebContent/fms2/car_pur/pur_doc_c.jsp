<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.tint.*, acar.doc_settle.*, card.*, acar.bill_mng.*, acar.car_sche.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>	
<%@ include file="/acar/cookies.jsp" %>

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
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	CarSchDatabase csd = CarSchDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//���뺸��������
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	if(pur.getDir_pur_yn().equals("Y") && emp2.getEmp_id().equals("")){
		emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	}	
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
	
	//Ư�ǰ������
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreRent(rent_l_cd);
	
	//��������
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//��ǰ����
	TintBean tint 	= t_db.getTint(rent_mng_id, rent_l_cd);
	
	//��ǰ	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
	TintBean tint3 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "3");
	TintBean tint4 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "4");
	TintBean tint5 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "5");	
	TintBean tint6 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "6");	
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("4", rent_l_cd);
		//doc.setUser_id1(user_id);
		doc_no = doc.getDoc_no();
	}
	
	//���������
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
	
	CodeBean[] codes = c_db.getCodeAll("0017");
	int c_size2 = codes.length;
	
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
	
	Vector cards = CardDb.getCards("", "Y", "", "");
	int c_size = card_kinds.size();
	
//	from_page = "/fms2/car_pur/pur_doc_u.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;


					
                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
			String content_code = "LC_SCAN";
			String content_seq  = rent_mng_id+""+rent_l_cd; 
			
			Vector attach_vt = new Vector();
			int attach_vt_size = 0;       
			
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	
	//����ȭ��
	function go_modify()
	{
		var fm = document.form1;
		fm.target = "_self";
		fm.action = "/fms2/car_pur/pur_doc_u.jsp";		
		fm.submit();
	}
	
	//����Ʈ
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'pur_doc_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	

	//�˾������� ����
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();			
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}
	
	//�����������
	function view_emp(emp_id){
		var fm = document.form1;
		window.open("/acar/car_office/car_office_p_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_c_c_fee.jsp&cmd=view&emp_id="+emp_id, "VIEW_EMP", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}
	
	//�����Һ���
	function view_car_office(car_off_id){
		var fm = document.form1;
		window.open("view_car_office.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_doc_u.jsp&cmd=view&car_off_id="+car_off_id, "VIEW_CAR_OFF", "left=50, top=50, width=850, height=200, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	
	//Ź�۾�ü ��ȸ
	function search_off()
	{
		var fm = document.form1;	
		window.open("/acar/cus0601/cus0602_frame.jsp?from_page=/fms2/consignment/cons_i_c.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//���������ݽ°���ȸ
	function search_grt_suc()
	{
		var fm = document.form1;	
		window.open("s_grt_suc.jsp?from_page=/fms2/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//Ź�۾�ü Ź�۷� ��ȸ
	function search_off_amt()
	{
		var fm = document.form1;
		if(fm.cons_st.value !== '2')	{ 	alert('Ź�۱����� �����϶� ��ȸ�Ͻʽÿ�.'); 	return; }
		if(fm.dlv_ext.value == '')		{ 	alert('������� �����Ͻʽÿ�.'); 				return;	}
		if(fm.udt_st.value == '')		{	alert('�μ����� �����Ͻʽÿ�.'); 				return; }
		if(fm.off_id.value == '')		{	alert('Ź�۾�ü�� �����Ͻʽÿ�.'); 				return; }
		var o_url = "/fms2/cons_cost/s_cons_cost.jsp?car_comp_id=<%=cm_bean.getCar_comp_id()%>&car_cd=<%=cm_bean.getCode()%>&off_id="+fm.off_id.value+"&off_nm="+fm.off_nm.value+"&dlv_ext="+fm.dlv_ext.value+"&udt_st="+fm.udt_st.value;
		window.open(o_url, "CONS_COST", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//��ǰ���� �˾�
	function cng_rent_ext(){
		var fm = document.form1;		
		var width = 600;
		var firm_nm = '';				
		
		window.open("/fms2/consignment/s_place.jsp?go_url=/fms2/car_pur/pur_doc_i.jsp&st=&value=2&idx=0&s_kd=1&t_wd=<%=client.getFirm_nm()%>&req_id=<%=user_id%>", "PLACE", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");		
	}
	
	//Ź�۷��հ���
	function set_cons_amt(){
		var fm = document.form1;
		fm.cons_amt3.value = parseDecimal(toInt(parseDigit(fm.cons_amt1.value)) + toInt(parseDigit(fm.cons_amt2.value))); 	
		
		if(fm.cons_st.value == '1' && toInt(parseDigit(fm.cons_amt1.value)) != toInt(parseDigit(fm.sd_c_amt.value))){
			fm.sd_c_amt.value 	= parseDecimal( toInt(parseDigit(fm.cons_amt1.value)) );
			fm.sd_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.sd_c_amt.value))));
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_c_amt.value)) - toInt(parseDigit(fm.sd_cs_amt.value)));
			sum_car_f_amt();
			
			fm.off_nm.value = '';
			fm.off_id.value = '';
		}
		
		if(fm.cons_st.value == '2'){// && toInt(parseDigit(fm.cons_amt1.value)) != toInt(parseDigit(fm.sd_c_amt.value))
//			fm.sd_c_amt.value 	= parseDecimal( toInt(parseDigit(fm.cons_amt1.value)) );
//			fm.sd_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.sd_c_amt.value))));
//			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_c_amt.value)) - toInt(parseDigit(fm.sd_cs_amt.value)));		
			fm.sd_c_amt.value 	= '0';
			fm.sd_cs_amt.value 	= '0';
			fm.sd_cv_amt.value 	= '0';
			sum_car_f_amt();			
		}
	}
	
	//��������ܾװ��
	function set_con_amt(){
		var fm = document.form1;
		fm.jan_amt.value = parseDecimal(toInt(parseDigit(fm.tot_f_amt.value)) - toInt(parseDigit(fm.con_amt.value))); 	
	}

	//�ڵ�������� 
	function update_car_f_amt(){
		window.open("/acar/car_register/register_pur_id.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_F_AMT", "left=10, top=10, width=820, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
		
	//����
	function update_car_amt(){
		var st = 'car_amt';
		var height = 400;
		window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=50, top=50, width=850, height="+height+", resizable=yes, scrollbars=yes, status=yes");
	}
		
	//���� �Һ��ڰ� �հ�
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
	}
	
	//���� ���԰� �հ�
	function sum_car_f_amt(){
		var fm = document.form1;		
		
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							
		
		fm.jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_f_amt.value)) - toInt(parseDigit(fm.con_amt.value)));
//		fm.trf_amt1.value	= fm.jan_amt.value;
//		fm.tot_trf_amt.value= fm.trf_amt1.value;
		
	}	
	
	//����DC �հ�
	function set_dc_amt(){
		var fm = document.form1;		
		
		fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_dc1_amt.value)) + toInt(parseDigit(fm.s_dc2_amt.value)) + toInt(parseDigit(fm.s_dc3_amt.value)) );		
		fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_c_amt.value))));
		fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));
		
		sum_car_f_amt();
	}
	
	//������� ����ݾ� ����
	function set_trf_amt(){
		var fm = document.form1;		
		
		var tot_trf_amt = toInt(parseDigit(fm.trf_amt1.value)) + toInt(parseDigit(fm.trf_amt2.value)) + toInt(parseDigit(fm.trf_amt3.value)) + toInt(parseDigit(fm.trf_amt4.value));
		var jan_amt 	= toInt(parseDigit(fm.jan_amt.value));
		
		fm.tot_trf_amt.value = parseDecimal(tot_trf_amt);
		
	}
	
	//�Һ��ڰ���� �ݾװ��
	function setDc_per_amt(idx){
		var fm = document.form1;
		
		if(idx == 1 && toFloat(fm.s_dc1_per.value)>0){// && toInt(fm.s_dc1_amt.value)==0
			fm.s_dc1_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_c_amt.value)) * toFloat(fm.s_dc1_per.value) /100);
		}
		if(idx == 2 && toFloat(fm.s_dc2_per.value)>0){// && toInt(fm.s_dc2_amt.value)==0
			fm.s_dc2_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_c_amt.value)) * toFloat(fm.s_dc2_per.value) /100);
		}
		if(idx == 3 && toFloat(fm.s_dc3_per.value)>0){// && toInt(fm.s_dc3_amt.value)==0
			fm.s_dc3_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_c_amt.value)) * toFloat(fm.s_dc3_per.value) /100);
		}
	}
	
	//��ĵ���� ����
	function view_scan(){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//ī���ȣ ��ȸ
	function cng_input_card(value, idx){
		var fm = document.form1;
		if(idx == '1' && fm.trf_st1.value == '1') return;
		if(idx == '2' && fm.trf_st2.value == '1') return;
		if(idx == '3' && fm.trf_st3.value == '1') return;
		if(idx == '4' && fm.trf_st4.value == '1') return;						
		var width = 500;		
		window.open("s_cardno.jsp?go_url=/fms2/car_pur/pur_doc_u.jsp&value="+value+"&idx="+idx, "CARDNO", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");
	}
	//���¹�ȣ
	function cng_input_bank(value, idx){
		var fm = document.form1;		
		var width = 800;	
		if(value == '1'){
			window.open("s_bankacc.jsp?go_url=/fms2/car_pur/pur_doc_u.jsp&emp_id=<%=emp2.getEmp_id()%>&car_off_id=<%=emp2.getCar_off_id()%>&value=<%=emp2.getCar_off_nm()%>&idx="+idx, "CARDNO", "left=10, top=10, width="+width+", height=600, scrollbars=yes, status=yes, resizable=yes");	
		}
	}
	//���
	function save(){
		var fm = document.form1;
	
		if(fm.dlv_est_dt.value  != ''  && fm.dlv_est_h.value  == '') 		fm.dlv_est_h.value 	= '00';		
		if(fm.reg_est_dt.value  != ''  && fm.reg_est_h.value  == '') 		fm.reg_est_h.value 	= '00';		
		if(fm.rent_est_dt.value != ''  && fm.rent_est_h.value == '') 		fm.rent_est_h.value = '00';
		if(fm.sup_est_dt.value  != ''  && fm.sup_est_h.value  == '') 		fm.sup_est_h.value 	= '00';		
	
		if(fm.dlv_ext.value == '')		{	alert('������� �Է��Ͽ� �ֽʽÿ�.'); 				fm.dlv_ext.focus(); 		return;		}
		if(fm.dlv_est_dt.value == '')	{	alert('��������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 		fm.dlv_est_dt.focus(); 		return;		}
		if(fm.udt_st.value == '')		{	alert('�μ����� �Է��Ͽ� �ֽʽÿ�.'); 				fm.udt_st.focus(); 			return;		}
		if(fm.udt_est_dt.value == '')	{	alert('�μ��������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 		fm.udt_est_dt.focus(); 		return;		}
		if(fm.cons_st.value == '')		{	alert('Ź�۱����� �Է��Ͽ� �ֽʽÿ�.'); 			fm.cons_st.focus(); 		return;		}
		if(fm.reg_est_dt.value == '')	{	alert('��Ͽ������� �Է��Ͽ� �ֽʽÿ�.'); 			fm.reg_est_dt.focus(); 		return;		}
		if(fm.rent_est_dt.value == '')	{	alert('��ǰ�������� �Է��Ͽ� �ֽʽÿ�.'); 			fm.rent_est_dt.focus(); 	return;		}
		if(fm.rent_ext.value == '')		{	alert('��ǰ������ �Է��Ͽ� �ֽʽÿ�.'); 			fm.rent_ext.focus(); 		return;		}
		if(fm.jan_amt.value == '0')		{	alert('������� �ܾ��� Ȯ���Ͽ� �ֽʽÿ�.'); 		fm.jan_amt.focus(); 		return;		}
		if(fm.con_est_dt.value == '')	{	alert('����ó����û���� �Է��Ͽ� �ֽʽÿ�.');		fm.con_est_dt.focus(); 		return;		}
		
		if(	toInt(parseDigit(fm.s_dc1_amt.value))>0 && fm.s_dc1_re.value == ''){ alert('����D/C ����1�� �Է��Ͻʽÿ�.'); return; }
		if(	toInt(parseDigit(fm.s_dc2_amt.value))>0 && fm.s_dc2_re.value == ''){ alert('����D/C ����2�� �Է��Ͻʽÿ�.'); return; }
		if(	toInt(parseDigit(fm.s_dc3_amt.value))>0 && fm.s_dc3_re.value == ''){ alert('����D/C ����3�� �Է��Ͻʽÿ�.'); return; }				
		
		<%if(base.getRent_st().equals("3")){%>
		if(toInt(parseDigit(fm.grt_suc_r_amt.value))>0 && fm.grt_suc_yn.value != '0'){
			fm.grt_suc_yn.value = '0';
		} 

		if(fm.grt_suc_yn.value == '')		{	alert('�������������� �°迩�θ� �������ּ���.'); 		fm.grt_suc_yn.focus(); 		return;		}
		<%}%>
		
		
		<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>		
		if(fm.com_tint[0].checked==true){		//�������ǰ-����
			if(fm.com_film_st[1].checked==true || fm.com_film_st[2].checked==true){
				alert('�ʸ�-�⺻�� �������� �ϰ�, �ʸ�-���ÿ��� �ش��ϴ� �����ʸ��� �����Ͻʽÿ�.'); return;
			}			
		}else if(fm.com_tint[1].checked==true){//�������ǰ-����
			if(fm.com_film_st[0].checked==true){
				alert('�ʸ�-�⺻�� �縶 ���� ��񽺸� �����Ͻʽÿ�.'); return;
			}
		}else if(fm.com_tint[2].checked==true){//�������ǰ-�귣��Ű��
			fm.com_film_st[0].checked=true;
			fm.cleaner_st[1].checked=true;
		}
		<%}%>		
			
		<%if(!emp2.getEmp_id().equals("030849") && !emp2.getEmp_id().equals("030879")){%>					
		<%	if(!coe_bean.getOne_self_yn().equals("Y")){//����������%>
				if(toInt('<%=pur.getCon_est_dt()%>') > 20101112){
					if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){	
						alert('��������û����-���������� �Է��Ͻʽÿ�.'); 		fm.con_acc_no.focus(); 		return;		
					}
				}
		<%	}%>
		<%}%>
		
				
		if(confirm('���� �Ͻðڽ��ϱ�?')){	
			fm.action='pur_doc_u_a.jsp';		
			fm.target='i_no';			
			fm.submit();
		}	
	}			
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		if(doc_bit == '4'){
			if(fm.trf_st1.value == '')			{	alert('���޼����� �����Ͻʽÿ�.');			return;		}
			if(toInt(parseDigit(fm.trf_amt1.value)) == 0)	
												{	alert('���ޱݾ��� �Է��Ͻʽÿ�.');			return;		}
			if(fm.trf_st1.value == '2' || fm.trf_st1.value == '3' || fm.trf_st1.value == '7'){
				if(fm.card_kind1.value == '')	{	alert('ī�������� �����Ͻʽÿ�.');			return;		}
				if(fm.cardno1.value == '')		{	alert('ī���ȣ�� �Է��Ͻʽÿ�.');			return;		}
			}
			if(toInt(parseDigit(fm.tot_trf_amt.value)) != toInt(parseDigit(fm.jan_amt.value)))
												{	alert('���޳��� ���հ� �ܾ��� Ʋ���ϴ�.');	return;		}
			if(fm.pur_est_dt.value == '')		{	alert('ó���������� �Է��Ͻʽÿ�.');		return;		}
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='pur_doc_sanction.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}									
	}
		
	function doc_msg(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		fm.mode.value = 'msg';
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='pur_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}		
	
	//������� ������ȸ
	function search_bank_acc(gubun, car_off_id, car_off_nm){
		var fm = document.form1;
		window.open("/fms2/car_pur/s_bankacc.jsp?go_url=/fms2/lc_rent/lc_b_s.jsp&st="+gubun+"&t_wd="+car_off_nm+"&car_off_id="+car_off_id, "CAR_OFF_ACC", "left=0, top=0, width=800, height=600, resizable=yes, scrollbars=yes, status=yes");	
	}	
		
	//�ڵ���ǥ���-��ó���غ�	
	function autodocu_cancel(){
		var fm = document.form1;
		if(confirm('����Ͻðڽ��ϱ�?')){	
			fm.action='pur_autodocu_cancel.jsp';		
			fm.target='i_no';
			fm.submit();
		}						
	}
	
	function trf_pay_cancel(trf_st){
		var fm = document.form1;
		if(confirm('����Ͻðڽ��ϱ�?')){	
			fm.trf_st.value = trf_st;
			fm.action='pur_trf_pay_cancel.jsp';		
			fm.target='i_no';
			fm.submit();
		}			
	}
	
		
	
	//������ ���⿹���ݾ� 
	function pay_est_dt_purs(){
		var fm = document.form1;
		window.open('about:blank', "PAY_EST_DT_PURS", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");				
		fm.action = 's_pay_est_dt_purs.jsp';
		fm.target = 'PAY_EST_DT_PURS';
		fm.submit();
	}	
	
	//Ư�ǹ�������
	function view_car_pur_com(com_con_no){
		var fm = document.form1;
		window.open("/fms2/pur_com/lc_rent_c.jsp?mode=view&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&com_con_no="+com_con_no, "PUR_COM", "left=0, top=0, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}			
	
	function OpenImg(url){
  	var img=new Image();
  	var OpenWindow=window.open('','_blank', 'width=1000, height=760, menubars=no, scrollbars=auto');
  	OpenWindow.document.write("<style>body{margin:0px;}</style><img src='"+url+"' width='990'>");
 }
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>        
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="gur_size" 		value="<%=gur_size%>">  
  <input type='hidden' name="mode" 			value="<%=mode%>">      
  <input type='hidden' name="file_st" 		value="">
  <input type='hidden' name="doc_bit" 		value="">          
  <input type='hidden' name="trf_st" 		value="">          
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������� > <span class=style5>����������޿�û</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align="right">
			<%if(!mode.equals("view")){%>
				<a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a>
			<%}%>
			
			<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("�������������",user_id) || nm_db.getWorkAuthUser("���������",user_id)){%>
				<a href="javascript:go_modify()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify_s.gif align=absmiddle border=0></a>
			<%}%>
			</td>
	</tr> 	
    <tr>
        <td class=line2></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>����ȣ</td>
                    <td width=15%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%>����ڹ�ȣ</td>
                    <td width=15%>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
    		    </tr>	
                <tr> 
                    <td class=title width=10%>�뵵����</td>
                    <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
                    <td class=title width=10%>��������</td>
                    <td width=15%>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}else if(rent_way.equals("2")){%>�����<%}%></td>
                    <td class=title width=10%>�̿�Ⱓ</td>
                    <td width=15%>&nbsp;<%=fee.getCon_mon()%>����</td>
                    <td class=title width=10%>���뿩��</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>��</td>
    		    </tr>
                <tr> 
                    <td class=title width=10%>���ʿ�����</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title width=10%>�����������</td>
                    <td colspan='5'>&nbsp;<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %><%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>&nbsp;(������Ʈ���)<%}%></td>
    		    </tr>    		  
                <tr> 
                    <td class=title width=10%>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
                    <td colspan='7'>&nbsp;<%=fee.getFee_cdt()%></td>
    		    </tr>    	    		      
                <tr> 
                    <td class=title width=10%>��༭ Ư����� ���� ����</td>
                    <td colspan='7'>&nbsp;<%=fee_etc.getCon_etc()%></td>
    		    </tr>    	    		      
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 	
        <%if(!String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>Ư�ǹ�������</span></td>
	</tr>  		
        <tr>
        <td class=line2></td>
        </tr>      
        <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td width=10% class=title>Ư�ǰ���ȣ</td>
                    <td >&nbsp;<a href="javascript:view_car_pur_com('<%=pur_com.get("COM_CON_NO")%>');"><%=pur_com.get("COM_CON_NO")%></a></td>
                </tr>
            </table>
        </td>
        </tr> 
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 	
        <%}%>  			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ĵ</span>
	    <input type='hidden' name="file_name1" value=""><input type='hidden' name="file_name2" value="">		
	  </td>
	</tr>  			
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=10%>�Ÿ��ֹ���</td>
                    <td width=40%>&nbsp;
                    <%
                    	String file_15_yn = ""; 
                    	String file_10_yn = ""; 
                    	
			content_seq  = rent_mng_id+""+rent_l_cd+"115";
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					
 					file_15_yn = "Y";
                    %>                    
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
        	    <%}%>
        			</td>
                    <td class=title width=10%>���ݰ�꼭</td>
                    <td width=40%>&nbsp;
                    <%
			content_seq  = rent_mng_id+""+rent_l_cd+"110";
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					
 					file_10_yn = "Y";
                    %>
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
        	    <%}%>         
        			</td>
                </tr>	
    		</table>
	    </td>
	</tr> 	        
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>	
    		  <%if(!cr_bean.getCar_no().equals("")){%>
                <tr>
                    <td class=title>������ȣ</td>
                    <td colspan="4">&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td colspan="2" class=title>���ʵ����</td>
                    <td colspan="4">&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
                </tr>	
        		  <%}%>				
                <tr>
                    <td class=title>����</td>
                    <td colspan="4">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                    <td colspan="2" class=title>�ɼ�</td>
                    <td colspan="4">
                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td style='height:3' colspan=3></td>
                            </tr>
                            <tr>
                                <td width=3>&nbsp;</td>
                                <td><%=car.getOpt()%></td>
                                <td width=3>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style='height:3' colspan=3></td>
                            </tr>
                        </table>
                    </td>
                </tr>					
                <tr> 
                    <td class=title width=10%>���ۻ��</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%>
                      <%if(pur.getDir_pur_yn().equals("Y")){%>&nbsp;<b>[Ư�����]</b><%}%></td>
                    <td width=3% rowspan="2" class=title>��<br>��<br>��</td>
                    <td class=title width=7%>��ȣ</td>
                    <td width=15%>&nbsp;<a href="javascript:view_car_office('<%=coe_bean.getCar_off_id()%>');"><%=emp2.getCar_off_nm()%></a>
                    	<input type='hidden' name="dlv_brch" value="<%=emp2.getCar_off_nm()%>">
                    	<!--
                    	<%if(cm_bean.getCar_comp_id().equals("0003")){
                    		String dlv_mon = AddUtil.getDate(1)+""+AddUtil.getDate(2);
                    	%>
                    	  (������<%=d_db.getCarPurDlvBrchMonCnt(cm_bean.getCar_comp_id(), emp2.getCar_off_nm(), dlv_mon)%>��)
                    	<%}%>
                    	-->
                    </td>
                    <td width=3% rowspan="2" class=title>��<br>��</td>
                    <td width=7% class=title>�����</td>
                    <td width=15%>
        			<%	//������ڵ�
        				if(emp2.getCar_comp_id().equals("0001")){
        					CodeBean[] p_codes = c_db.getCodeAll("0018");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(pur.getDlv_ext().equals(code.getNm()))%>selected<%%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0002")){
        					CodeBean[] p_codes = c_db.getCodeAll("0019");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(pur.getDlv_ext().equals(code.getNm()))%>selected<%%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0004")||emp2.getCar_comp_id().equals("0005")){
        					CodeBean[] p_codes = c_db.getCodeAll("0020");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(pur.getDlv_ext().equals(code.getNm()))%>selected<%%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0003")){
        					CodeBean[] p_codes = c_db.getCodeAll("0021");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>' <%if(pur.getDlv_ext().equals(code.getNm()))%>selected<%%>><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			  <%}else{%>
        			  &nbsp;<input type='text' name='dlv_ext' size='15' value='<%=pur.getDlv_ext()%>' class='default' >
        			  <%}%>			
        			</td>
                    <td width=3% rowspan="5" class=title>Ź<br>��</td>
                    <td width=7% class=title>����</td>
                    <td width=15%>
        			  &nbsp;<select name="cons_st" class='default' onchange="javascript:set_cons_amt();">
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getCons_st().equals("1")){%>selected<%}%>>���</option>
        				<option value="2" <%if(pur.getCons_st().equals("2")){%>selected<%}%>>��ü</option>							
        			  </select>
        			</td>
        	    </tr>
                <tr>
                    <td class=title width=10%>��������</td>
                    <td width=15%>
                        <%String purc_gu = car.getPurc_gu();%>
                        <%if(purc_gu.equals("1")){%>
                        &nbsp;����
                        <%}else if(purc_gu.equals("0")){%>
                        &nbsp;�鼼
                        <%}%></td>
                    <td class=title>����ó</td>
                    <td>&nbsp;<%=coe_bean.getCar_off_tel()%></td>
                    <td class=title>�����Ͻ�</td>
                    <td>&nbsp;<input type='text' size='12' name='dlv_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  <input type='text' size='2' name='dlv_est_h' class='default' value='<%=String.valueOf(est.get("DLV_EST_H"))%>'>��
        			</td>
                    <td class=title>��ü��</td>
                    <td>&nbsp;<input type='text' name="off_nm" value='<%=pur.getOff_nm()%>' size='10' class='default'>
        			  <input type='hidden' name='off_id' value='<%=pur.getOff_id()%>'>
        			  </td>
                </tr>
                <tr>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;����:<%=car.getColo()%>/����:<%=car.getIn_col()%>/���Ͻ�:<%=car.getGarnish_col()%></td>
                    <td rowspan="2" class=title>��<br>��<br>��<br>��</td>
                    <td class=title>����</td>
                    <td>&nbsp;<a href="javascript:view_emp('<%=coe_bean.getEmp_id()%>');"><%=coe_bean.getEmp_nm()%></a>
					<%if(pur.getOne_self().equals("Y")){%>&nbsp;<b>[��ü���]</b><%}else{%>[����������]<%}%>
					<%if(pur.getDir_pur_yn().equals("Y")){%>&nbsp;<b>[����]</b><%}%>
					</td>
                    <td rowspan="2" class=title>��<br>��</td>
                    <td class=title>�μ���</td>
                    <td>
        			  &nbsp;<select name="udt_st" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getUdt_st().equals("1")){%>selected<%}%>>���ﺻ��</option>
        				<option value="2" <%if(pur.getUdt_st().equals("2")){%>selected<%}%>>�λ�����</option>
        				<option value="3" <%if(pur.getUdt_st().equals("3")){%>selected<%}%>>��������</option>
        				<option value="5" <%if(pur.getUdt_st().equals("5")){%>selected<%}%>>�뱸����</option>
        				<option value="6" <%if(pur.getUdt_st().equals("6")){%>selected<%}%>>��������</option>
        				<option value="4" <%if(pur.getUdt_st().equals("4")){%>selected<%}%>>��</option>				
        			  </select>
        			</td>
                    <td class=title>Ź�۷�1</td>
                    <td>&nbsp;<input type='text' name='cons_amt1' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCons_amt1())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                </tr>
                <tr>
                    <td class=title>��ⷮ</td>
                    <td>&nbsp;<%=cm_bean.getDpm()%>cc</td>
                    <td class=title>����ó</td>
                    <td>&nbsp;<%=coe_bean.getEmp_m_tel()%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<input type='text' size='11' name='udt_est_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(pur.getUdt_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title>Ź�۷�2</td>
                    <td>&nbsp;<input type='text' name='cons_amt2' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCons_amt2())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                </tr>
                <tr>
                    <td class=title>�����ȣ</td>
                    <td>
                    &nbsp;<input type='text' name='rpt_no' maxlength='15' value='<%=pur.getRpt_no()%>' class='default' size='15'></td>
                    <td rowspan="2" class=title>��<br>��</td>
                    <td class=title>�����</td>
                    <td>
                      &nbsp;<%=c_db.getNameByIdCode("0032", "", car.getCar_ext())%>
        			  <input type="hidden" name="car_ext" value="<%=car.getCar_ext()%>">
        			</td>
                    <td rowspan="2" class=title>��<br>ǰ</td>
                    <td class=title>��ǰ��</td>
                    <td>&nbsp;<input type='text' name='rent_ext' size='20' value='<%=pur.getRent_ext()%>' class='default' ></td>
                    <td class=title>�Ұ�</td>
                    <td>&nbsp;<input type='text' name='cons_amt3' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCons_amt1()+pur.getCons_amt2())%>' class='whitenum' size='10'>��</td>
                </tr>		
        	    <tr>
        		    <td class=title>�����ȣ</td>
        			<td>
        		    &nbsp;<input type='text' name='car_num' maxlength='20' value='<%=pur.getCar_num()%>' class='default' size='20'></td>
        		    <td class=title>�����Ͻ�</td>
        		    <td>
        		      &nbsp;<input type='text' size='12' name='reg_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='reg_est_h' class='default' value='<%=String.valueOf(est.get("REG_EST_H"))%>'>
                    ��</td>
        		    <td class=title>�����Ͻ�</td>
        			<td colspan="4">
        			  &nbsp;<input type='text' size='12' name='rent_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='rent_est_h' class='default' value='<%=String.valueOf(est.get("RENT_EST_H"))%>'>
                    �� 
					<%
						int dlv_rent_day = 0;
						
						dlv_rent_day = AddUtil.parseInt(rs_db.getDay(pur.getCon_est_dt(), String.valueOf(est.get("RENT_EST_DT"))));
						
						if(dlv_rent_day >2){%>
						<font color=red>(����ó����û�� ���� 2�� �̳��� ��ǰ�ؾ��մϴ�.)</font>
						<%}%>
					</td>			
                </tr>
    		</table>
	    </td>
	</tr> 
    <tr></tr><tr></tr><tr></tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>	
                <tr>
                    <td width="10%" rowspan="2" class='title'>����</td>
                    <td colspan="3" class='title'>�Һ��ڰ���</td>
                    <td width="10%" rowspan="2" class='title'>����</td>
                    <td colspan="3" class='title'>���԰���<%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id)){%><!--&nbsp;&nbsp;<a href="javascript:update_car_amt()"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>--><%}%></td>
                </tr>
                <tr>
                    <td width="13%" class='title'>���ް�</td>
                    <td width="13%" class='title'>�ΰ���</td>
                    <td width="14%" class='title'>�հ�</td>
                    <td width="13%" class='title'>���ް�</td>
                    <td width="13%" class='title'>�ΰ���</td>
                    <td width="14%" class='title'>�հ�</td>
                </tr>
                <tr>
                    <td class='title'> �⺻����</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title>��������</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                </tr>
                <tr>
                    <td height="12" class='title'>�ɼ�</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title>Ź�۷�</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                </tr>
                <tr>
                    <td height="26" class='title'> ����</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title>����D/C<span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"></a></span></td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				��</td>
                </tr>
              <tr id=tr_ecar_dc <%if(car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>���Ҽ� �����</td>
                <td align="center">&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align="center">&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>                       
                <tr>
                    <td class='title'>�հ�</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    ��</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                    <td class='title'>�հ�</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                </tr>
    		</table>
	    </td>
	</tr> 

    <tr></tr><tr></tr><tr></tr>  
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='10%'> ���� </td>
					<td class='title' width='17%'>����D/C ����</td>
					<td class='title' width='33%'>����</td>					
					<td class='title' width='13%'>�Һ��ڰ����</td>										
					<td width="13%" class='title'>�뿩��ݿ�����</td>
				    <td width="14%" class='title'>�ݾ�</td>
			    </tr>
				<tr>
					<td align='center'>1</td>
					<td>&nbsp;
					  <select name='s_dc1_re' class='default'>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size2 ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc1_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  					  
					  <input type='text' name='s_dc1_re_etc' size='47' class="text" value='<%=car.getS_dc1_re_etc()%>'>
					<td align="center">  
					  <input type='text' name='s_dc1_per' size='4' class="text" value='<%=car.getS_dc1_per()%>' onBlur='javascript:setDc_per_amt(1);'>%
					</td>
					<td align="center"><select name='s_dc1_yn' class='default'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc1_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc1_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc1_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc1_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_dc_amt();'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>2</td>
					<td>&nbsp;
					  <select name='s_dc2_re' class='default'>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size2 ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc2_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc2_re_etc' size='47' class="text" value='<%=car.getS_dc2_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc2_per' size='4' class="text" value='<%=car.getS_dc2_per()%>' onBlur='javascript:setDc_per_amt(2);'>%
					</td>
					<td align="center"><select name='s_dc2_yn' class='default'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc2_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc2_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc2_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc2_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_dc_amt();'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>3</td>
					<td>&nbsp;
					  <select name='s_dc3_re' class='default'>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size2 ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc3_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc3_re_etc' size='47' class="text" value='<%=car.getS_dc3_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc3_per' size='4' class="text" value='<%=car.getS_dc3_per()%>' onBlur='javascript:setDc_per_amt(3);'>%
					</td>
					<td align="center"><select name='s_dc3_yn' class='default'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc3_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc3_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc3_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc3_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_dc_amt();'>
     					 ��</td>
			    </tr>
				<tr>
					<td class='title'>��ǰ���</td>
					<td colspan='5'>&nbsp;
					  <input type='text' name='bc_b_t' size='10' value='<%=AddUtil.parseDecimal(fee_etc.getBc_b_t())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
     					 ��
					</td>  					
			    </tr>			    
		    </table>
		</td>
	</tr>
    <%if(car.getCar_origin().equals("2")){//������%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ������ ����</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>ī������ݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='import_card_amt' value='<%= AddUtil.parseDecimal(car.getImport_card_amt())%>'size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    </td>
                    <td width="10%" class='title'>Cash Back�ݾ�</td>
                    <td>&nbsp;
        		<input type='text' name='import_cash_back' value='<%= AddUtil.parseDecimal(car.getImport_cash_back())%>'size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
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
                        <input type='text' name='ecar_pur_sub_amt' value='<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    </td>
                    <td width="10%" class='title'>�����ݼ��ɹ��</td>
                    <td>&nbsp;
        		            <select name='ecar_pur_sub_st' disabled>
        		            	<option value="" <%if(car.getEcar_pur_sub_st().equals("")){%> selected <%}%>>����</option>
                          <option value="1" <%if(car.getEcar_pur_sub_st().equals("1")){%> selected <%}%>>������ ������� ����</option>
                          <option value="2" <%if(car.getEcar_pur_sub_st().equals("2")){%> selected <%}%>>�Ƹ���ī ���� ����</option>
                        </select>        		            
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������û����</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td width=40%>&nbsp;
                      <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_con_amt();'>
                    ��</td>
                    <td class=title width=10%>�ܾ�</td>
                    <td width="40%">&nbsp;
                      <input type='text' name='jan_amt' maxlength='15' value='<%=AddUtil.parseDecimal(pur.getJan_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_con_amt();'>
                    ��</td>                    
                </tr>	
                <tr>
				  <td width="10%" class=title>���޿�û��</td>
                    <td colspan='3'>&nbsp;
                    <input type='text' name='con_est_dt' size='15' value='<%=AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='default' >
					  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;&nbsp;&nbsp;(����������:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��ݴ��",user_id) || nm_db.getWorkAuthUser("�Աݴ��",user_id)){%>
					  <a href="javascript:trf_pay_cancel('0')" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='�����ó���� ���� �������ó���մϴ�.'>[���]</a>
					  <%	}%>
					  <%}%>
					  
					  <%if(pur.getCon_amt() >0 && cop_bean.getCon_amt() >0 &&  !cop_bean.getCon_pay_dt().equals("") &&  !cop_bean.getCon_pay_dt().equals(AddUtil.replace(pur.getCon_pay_dt(),"-",""))){%>
					  &nbsp;&nbsp;&nbsp;&nbsp;(������࿬�� ����������:<%=cop_bean.getCon_pay_dt()%>)
					  <%} %>
					  
					  
					</td>
				</tr>	
				<tr>
				  <td class=title width=10%>�������޼���</td>
                    <td colspan='3'>&nbsp;
						<!--
						<span class="b"><a href="javascript:search_bank_acc('DLV', '<%=emp2.getCar_off_id()%>', '<%=emp2.getCar_off_nm()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
						-->
					  ���޼��� :  	
					  <%if(pur.getTrf_st0().equals("1")){ out.println("����"); }else if(pur.getTrf_st0().equals("3")){ out.println("ī��"); }%>	
					  ī��/������ : 
					  <%=pur.getCon_bank()%>
					  <input type='hidden' name="con_bank" value="<%=pur.getCon_bank()%>">
					  <!-- 
					  <select name='con_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                    </select>
                     -->
				  	&nbsp;
					ī��/���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					����/������ : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='30' class='text'>
                    </td>
				</tr>				
				<tr>
				  <td class=title width=10%>Ư�̻���</td>
                    <td colspan='3'>&nbsp;
					  <textarea name="con_amt_cont" cols="100" rows="3" class="default"><%=pur.getCon_amt_cont()%></textarea>(������,�����ݽ°���)
                    </td>
				</tr>				
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td><font color=#666666>&nbsp;�� �������� : ���� ���� ������ ��������� ������������Դϴ�. ���θ��� ���´� ����Ҽ� �����ϴ�. ��ȸ�� Ŭ���ϸ� �������� ���������� Ȯ��/������ �� �ֽ��ϴ�.</font> </td>
	</tr>	

	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��漼 </td>
	</tr>  			
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=10%>���Ǻ��濩��</td>
                    <td width=40%>&nbsp;
        			  <%if(pur.getAcq_cng_yn().equals("N")||pur.getAcq_cng_yn().equals("")){%>����<%}%>        				
        			  <%if(pur.getAcq_cng_yn().equals("Y")){%>����<%}%>        				
        			</td>
                    <td class=title width=10%>������</td>
                    <td width=40%>&nbsp;
        			  <select name='cpt_cd'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getCode()%>' <%if(pur.getCpt_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ó����������</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="10%" class=title>���޼���</td>
                    <td width="15%" class=title>�ݾ�</td>
                    <td width="15%" class=title>ī������/������</td>
                    <td width="10%" class=title>��������</td>					
                    <td width="18%" class=title>ī��/���¹�ȣ</td>
                    <td width="20%" class=title>����</td>
                    <td width="12%" class=title>��������</td>					
                </tr>
        		  <%String trf_st 		= "";
        		 	int    trf_amt 		= 0;
        		  	String card_kind 	= "";
        		  	String cardno 		= "";
        		  	String trf_cont 	= "";
					String trf_pay_dt 	= "";
					String acc_st 		= "";
        		  	for(int j=0; j<4; j++){
        				if(j==0){
        					trf_st 		= pur.getTrf_st1	();
        					trf_amt 	= pur.getTrf_amt1	();
        					card_kind 	= pur.getCard_kind1	();
        					cardno 		= pur.getCardno1	();
        					trf_cont 	= pur.getTrf_cont1	();
							trf_pay_dt	= pur.getTrf_pay_dt1();
							acc_st 		= pur.getAcc_st1	();
        				}else if(j==1){
        					trf_st 		= pur.getTrf_st2	();
        					trf_amt 	= pur.getTrf_amt2	();
        					card_kind 	= pur.getCard_kind2	();
        					cardno 		= pur.getCardno2	();
        					trf_cont 	= pur.getTrf_cont2	();
							trf_pay_dt	= pur.getTrf_pay_dt2();
							acc_st 		= pur.getAcc_st2	();
        				}else if(j==2){
        					trf_st 		= pur.getTrf_st3	();
        					trf_amt 	= pur.getTrf_amt3	();
        					card_kind 	= pur.getCard_kind3	();
        					cardno 		= pur.getCardno3	();
        					trf_cont 	= pur.getTrf_cont3	();
							trf_pay_dt	= pur.getTrf_pay_dt2();
							acc_st 		= pur.getAcc_st3	();
        				}else if(j==3){
        					trf_st 		= pur.getTrf_st4	();
        					trf_amt 	= pur.getTrf_amt4	();
        					card_kind 	= pur.getCard_kind4	();
        					cardno 		= pur.getCardno4	();
        					trf_cont 	= pur.getTrf_cont4	();
							trf_pay_dt	= pur.getTrf_pay_dt4();
							acc_st 		= pur.getAcc_st4	();
        				}
        		  		%>
                <tr>
                    <td align="center">
        			  <select name="trf_st<%=j+1%>" class='default' onChange="javascript:cng_input_bank(this.value, <%=j+1%>)">
                        <option value="">==����==</option>
        				<option value="1" <%if(trf_st.equals("1")) out.println("selected");%>>����</option>
        				<option value="2" <%if(trf_st.equals("2")) out.println("selected");%>>����ī��</option>
        				<option value="3" <%if(trf_st.equals("3")) out.println("selected");%>>�ĺ�ī��</option>
        				<option value="4" <%if(trf_st.equals("4")) out.println("selected");%>>����</option>
        				<option value="5" <%if(trf_st.equals("5")) out.println("selected");%>>����Ʈ</option>
        				<option value="6" <%if(trf_st.equals("6")) out.println("selected");%>>���ź�����</option>
        				<option value="7" <%if(trf_st.equals("7")) out.println("selected");%>>ī���Һ�</option>
        			  </select>
        			  </td>
                    <td align="center"><input type='text' size='10' maxlength='15' name='trf_amt<%=j+1%>' class='defaultnum' value='<%=AddUtil.parseDecimal(trf_amt)%>' onBlur='javascript:this.value=parseDecimal(this.value); set_trf_amt();'>
                      ��</td>
                    <td align="center">
        			  <select name="card_kind<%=j+1%>" class='default' onChange="javascript:cng_input_card(this.value, <%=j+1%>)">
                  	    <option value=''>����</option>
                  		<%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>' <%if(card_kind.equals(String.valueOf(ht.get("CARD_KIND")))) out.println("selected");%>><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
        					
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(card_kind.equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>					
                	  </select>
        			</td>
                    <td align="center">
        			  <select name="acc_st<%=j+1%>" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(acc_st.equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(acc_st.equals("2")) out.println("selected");%>>�������</option>
        			  </select>
        			  </td>					
                    <td align="center">
        			  <input type='text' size='22' maxlength='100' name='cardno<%=j+1%>' class='default' value='<%=cardno%>'>
        			</td>
                    <td align="center"><input type='text' size='25' maxlength='100' name='trf_cont<%=j+1%>' class='default' value='<%=trf_cont%>'>
					</td>
                    <td align="center">
					  <%if(trf_amt>0 && !trf_pay_dt.equals("")){%>	
        			  <%=trf_pay_dt%>
					  <%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��ݴ��",user_id) || nm_db.getWorkAuthUser("�Աݴ��",user_id)){%>
					  <a href="javascript:trf_pay_cancel('<%=j+1%>')" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='�����ó���� ���� �������ó���մϴ�.'>[���]</a>
					  <%	}%>
					  <%}%>
        			</td>					
                </tr>
        		  <%}%>
                <tr>
                    <td class=title>�հ�</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='tot_trf_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(pur.getTrf_amt1()+pur.getTrf_amt2()+pur.getTrf_amt3()+pur.getTrf_amt4())%>'>
                      ��</td>
                    <td class=title>ó��������</td>
                    <td>&nbsp;
                      <input type='text' size='11' name='pur_est_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(pur.getPur_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>					  
					  </td>
                    <td colspan="3" align="center">&nbsp;
					(ó���Ϸ��� : <%=AddUtil.ChangeDate2(pur.getPur_pay_dt())%>)
					  </td>
					  
                </tr>
            </table>
        </td>
	</tr> 
	<tr>
	    <td align="right">&nbsp;
		  <a href="javascript:pay_est_dt_purs()" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='ó�������� ���� ����(����)����Ʈ'>[������ݰ�������ݾ�]</a>
		</td>
	</tr> 	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ӽÿ��ຸ���</span>
	    	<!--<input type="button" class="button" id="b_tmp_ins_amt" value='�����ػ� ����� ����' onclick="javascript:OpenImg('/acar/images/center/tmp_ins_amts.jpg');">-->
	    	</td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="10%" class=title>���޼���</td>
                    <td width="15%" class=title>�ݾ�</td>
                    <td width="15%" class=title>ī������/������</td>
                    <td width="10%" class=title>��������</td>					
                    <td width="18%" class=title>ī��/���¹�ȣ</td>
                    <td width="20%" class=title>����</td>
                    <td width="12%" class=title>��������</td>					
                </tr>
        		  <%trf_st 		= pur.getTrf_st5		();
       					trf_amt 	= pur.getTrf_amt5		();
       					card_kind = pur.getCard_kind5	();
       					cardno 		= pur.getCardno5		();
       					trf_cont 	= pur.getTrf_cont5	();
								trf_pay_dt= pur.getTrf_pay_dt5();
								acc_st 		= pur.getAcc_st5		();
     		  		%>
                <tr>
                    <td align="center">
        			  <select name="trf_st4" class='default' onChange="javascript:cng_input_bank(this.value, 4)">
                        <option value="">==����==</option>
        				<option value="1" <%if(trf_st.equals("1")) out.println("selected");%>>����</option>
        				<option value="2" <%if(trf_st.equals("2")) out.println("selected");%>>����ī��</option>
        				<option value="3" <%if(trf_st.equals("3")) out.println("selected");%>>�ĺ�ī��</option>
        			  </select>
        			  </td>
                    <td align="center"><input type='text' size='10' maxlength='15' name='trf_amt4' class='defaultnum' value='<%=AddUtil.parseDecimal(trf_amt)%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">
        			  <select name="card_kind4" class='default'>
                  	    <option value=''>����</option>
                  		<%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>' <%if(card_kind.equals(String.valueOf(ht.get("CARD_KIND")))) out.println("selected");%>><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
        					
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(card_kind.equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>					
                	  </select>
        			</td>
                    <td align="center">
        			  <select name="acc_st4" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(acc_st.equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(acc_st.equals("2")) out.println("selected");%>>�������</option>
        			  </select>
        			  </td>					
                    <td align="center">
        			  <input type='text' size='22' maxlength='100' name='cardno4' class='default' value='<%=cardno%>'>
        			</td>
                    <td align="center"><input type='text' size='25' maxlength='100' name='trf_cont4' class='default' value='<%=trf_cont%>'>
					</td>
                    <td align="center">
					  <%if(trf_amt>0 && !trf_pay_dt.equals("")){%>	
        			  <%=trf_pay_dt%>	
        			  <%	if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��ݴ��",user_id) || nm_db.getWorkAuthUser("�Աݴ��",user_id)){%>
					  <a href="javascript:trf_pay_cancel('5')" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='�����ó���� ���� �������ó���մϴ�.'>[���]</a>
					  <%	}%>				  
					  <%}%>
        			</td>					
                </tr>
            </table>
        </td>
	</tr> 					
	<%if(doc.getDoc_step().equals("3") && !pur.getAutodocu_write_date().equals("")){%>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 					
                    <td class=title width=10%>�ڵ���ǥ</td>
                    <td>&nbsp;
        			  <%=pur.getAutodocu_write_date()%>&nbsp;(<%=pur.getAutodocu_data_no()%>)
					  <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��ݵ��",user_id)){%>
					  <a href="javascript:autodocu_cancel()" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='�ڵ���ǥ�� ������ϱ� ���ؼ��� ������ ������ �ڵ���ǥ�� ���ó���ؾ� �մϴ�.'>[�ڵ���ǥ���]</a>
					  <%}%>
        			</td>
                </tr>	
    		</table>
	    </td>
	</tr>  	  	
    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>	
	<%}%>				

	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǰ��û����</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <%if(!tint.getTint_no().equals("")){%>	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td colspan="2" class='title'><span class="title1">������߰�����</span></td>
                    <td colspan="3">
                    	&nbsp;<%=car.getAdd_opt()%>&nbsp;<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>��<font color="#666666">(�ΰ������Աݾ�, ���� �ݿ���, LPGŰƮ����, �׺���̼� ��)</font>
                    	<%if(cm_bean.getS_st().equals("801")||cm_bean.getS_st().equals("802")||cm_bean.getS_st().equals("811")||cm_bean.getS_st().equals("821")){%>
                    		<%if(!cr_bean.getCar_no().equals("")){ %>
								<br>&nbsp;&nbsp;ȭ���� ���� : 
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="" <%if(car.getVan_add_opt().equals("")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;����
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="1" <%if(car.getVan_add_opt().equals("1")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;����ž/���ٵ�	        				
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="2" <%if(car.getVan_add_opt().equals("2")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;Ȱ�������
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="3" <%if(car.getVan_add_opt().equals("3")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;���߱�/ũ����
							<%}%>	
        				<%}%>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class=title>�����ݿ���ǰ</td>
                    <td colspan="3">&nbsp;
		              <%if(car.getTint_b_yn().equals("Y")){%>2ä�� ���ڽ�<%}%> 
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>���� ����
                      &nbsp;
                                      ���ñ��������� : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		          &nbsp;
                      <%if(car.getTint_ps_yn().equals("Y")){%>��� ����
                      &nbsp;
                                      ���� : <%=car.getTint_ps_nm()%>, �ݾ� : <%=AddUtil.parseDecimal(car.getTint_ps_amt())%>�� (�ΰ�������)
                      <%}%>
                      <%if(car.getTint_n_yn().equals("Y")){%>��ġ�� ������̼�<%}%>
                      &nbsp;
                      <%if(car.getTint_eb_yn().equals("Y")){%>�̵��� ������<%}%>
                      &nbsp;
                      <%if(car.getTint_bn_yn().equals("Y")){%>���ڽ� ������ ���� (<%if(car.getTint_bn_nm().equals("1")){%>��Ʈ��ķ<%}else if(car.getTint_bn_nm().equals("2")){%>������<%}else{%>��Ʈ��ķ,������..<%}%>)<%}%> 
                      &nbsp;
                      <%if(car.getTint_cons_yn().equals("Y")){%>�߰�Ź�۷��
                      &nbsp;
                      <%=AddUtil.parseDecimal(car.getTint_cons_amt())%>��
                      <%}%> 
                      <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>&nbsp;������ȣ�ǽ�û<%}%>
<%--                       <%if(car.getNew_license_plate().equals("1")){%>&nbsp;������ȣ�ǽ�û(������)<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("2")){%>&nbsp;������ȣ�ǽ�û(����/�뱸/����/�λ�)<%}%> --%>
					  </td>
                </tr>			
				
				<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
                <tr>
                    <td colspan="2" class=title>�������ǰ</td>
                    <td colspan="3">&nbsp;
        			  <%if(pur.getCom_tint().equals("")){%>����<%}%>                      					  
                      <%if(pur.getCom_tint().equals("1")){%>����<%}%>                      
                      <%if(pur.getCom_tint().equals("2")){%>�귣��ŰƮ<%}%>                      					  
					  </td>
                </tr>	
				<%}%>					
                <tr> 
                    <td colspan="3" class=title>����</td>
                    <td colspan="2" class=title>û�ҿ�ǰ(���̰�)</td>
                </tr>
                <tr>
                    <td width="5%" rowspan="2" class=title>�ʸ�</td>
                    <td width="5%" class=title>�⺻</td>
                    <td width="49%" >&nbsp;
					  <%if(pur.getCom_film_st().equals("")){%>-<%}%>        				
					  <%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>                      				
        			  		<%if(pur.getCom_film_st().equals("1")){%>�縶<%}%>
        			  		<%if(pur.getCom_film_st().equals("2")){%>���<%}%>
						<%if(pur.getCom_film_st().equals("3")){%>SKC<%}%>
						<%if(pur.getCom_film_st().equals("4")){%>3M<%}%>
					  <%}%>	
        			</td>
                    <td width="6%" class=title>�⺻</td>
                    <td width="30%">&nbsp;						
        			  <%if(tint.getCleaner_st().equals("1")){%>����<%}%>
        			  <%if(tint.getCleaner_st().equals("2")){%>����<%}%>
       				</td>
                </tr>
                <tr>
                  <td class=title>����</td>
                  <td>&nbsp;
          			  <%if(tint.getFilm_st().equals("")){%>-<%}%>
        			  <%if(tint.getFilm_st().equals("1")){%>�Ϲ�<%}%>        				
        			  <%if(tint.getFilm_st().equals("2")){%>3M<%}%>
        			  <%if(tint.getFilm_st().equals("3")){%>�縶<%}%>
				  </td>
                  <td rowspan="2" class=title>�߰�</td>
                  <td rowspan="2">&nbsp;
                      <textarea name="cleaner_add" cols="45" rows="2" class="default"><%=tint.getCleaner_add()%></textarea>                  </td>
                </tr>
                <tr>
                    <td colspan="2" class=title>���ñ���������</td>
                    <td>&nbsp;
        			  <input type='text' name='sun_per' size='3' <%if(!tint.getTint_no().equals("")){%>value='<%=tint.getSun_per()%>'<%}else{%>value='<%=car.getSun_per()%>'<%}%> class='default' >%
        			</td>
                </tr>
                <tr> 
                    <td colspan="3" class=title>�׺���̼�</td>
                    <td colspan="2" class=title>��Ÿ</td>
                </tr>
                <tr>
                    <td width="10%" colspan="2" class=title>��ǰ��</td>
                    <td>&nbsp;
                        <input type='text' name='navi_nm' size='45' value='<%=tint.getNavi_nm()%>' class='default' >
                    </td>
                    <td colspan="2" rowspan="2">&nbsp;
        			  <textarea name="sup_other" cols="57" rows="2" class="default"><%=tint.getOther()%></textarea></td>
                </tr>
                <tr>
                    <td colspan="2" class=title>(����)����</td>
                    <td>&nbsp;
                        <input type='text' name='navi_est_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getNavi_est_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        �� </td>
                </tr>
                <tr>
                    <td colspan="2" class=title>���ڽ�</td>
                    <td colspan="3">&nbsp;
        			  <%if(tint.getBlackbox_yn().equals("N")){%>������<%}%>
				  <%if(tint.getBlackbox_yn().equals("Y")){%>����<%}%>
				  <%if(tint.getBlackbox_yn().equals("3")){%>���(����)<%}%>
				  <%if(tint.getBlackbox_yn().equals("4")){%>���(����)<%}%>
                      </select>
        			</td>
                </tr>                
                <tr>
                    <td colspan="2" class=title>����</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name='sup_etc' size='90' value='<%=tint.getEtc()%>' class='default' >
        			</td>
                </tr>
                <tr>
                    <td colspan="2" class=title>�۾�������û�Ͻ�</td>
                    <td>&nbsp;
        			  <input type='text' size='12' name='sup_est_dt' maxlength='12' class='default' <%if(tint.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  <input type='text' size='2' name='sup_est_h' class='default' value=<%if(tint.getSup_est_dt().length()==10){%>'<%=tint.getSup_est_dt().substring(8)%>'<%}%>>��
        			</td>
                    <td class=title>��ü��</td>
                    <td>&nbsp;
        			  <select name='sup_off_id' class='default'>
                          <option value="">����</option>
                          <option value="002849�ٿȹ�"       <%if(tint.getOff_id().equals("002849"))%>selected<%%>>�ٿȹ�</option>
        				  <option value="002850����ī����"     <%if(tint.getOff_id().equals("002850"))%>selected<%%>>����ī����</option>
        				  <option value="002851����Ųõ������" <%if(tint.getOff_id().equals("002851"))%>selected<%%>>����Ųõ������</option>
						  <option value="008692�ֽ�ȸ�����ī��" <%if(tint.getOff_id().equals("008692"))%>selected<%%>>�ֽ�ȸ�� ����ī��</option>
						  <option value="008501�ƽþƳ����" <%if(tint.getOff_id().equals("008501"))%>selected<%%>>�ƽþƳ����</option>
						  <option value="008514��ȣ4WD���" <%if(tint.getOff_id().equals("008514"))%>selected<%%>>��ȣ4WD���</option>
						  <option value="008680������ڵ�����ǰ��" <%if(tint.getOff_id().equals("008680"))%>selected<%%>>������ڵ�����ǰ��</option>
                        </select></td>
                </tr>	
            </table>
	    </td>
	</tr> 	
    <%}else{%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class='title'><span class="title1">������߰�����</span></td>
                    <td colspan="3">
                    	&nbsp;<%=car.getAdd_opt()%>&nbsp;<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>��<font color="#666666">(�ΰ������Աݾ�, ���� �ݿ���, LPGŰƮ����, �׺���̼� ��)</font>
                    	<%if(cm_bean.getS_st().equals("801")||cm_bean.getS_st().equals("802")||cm_bean.getS_st().equals("811")||cm_bean.getS_st().equals("821")){%>
                    		<%if(!cr_bean.getCar_no().equals("")){ %>
								<br>&nbsp;&nbsp;ȭ���� ���� : 
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="" <%if(car.getVan_add_opt().equals("")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;����
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="1" <%if(car.getVan_add_opt().equals("1")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;����ž/���ٵ�	        				
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="2" <%if(car.getVan_add_opt().equals("2")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;Ȱ�������
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="3" <%if(car.getVan_add_opt().equals("3")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;���߱�/ũ����
							<%}%>	
        				<%}%>
                    </td>
                </tr>
                <tr>
                    <td width="10%" class=title>�����ݿ���ǰ</td>
                    <td colspan='3'>&nbsp;
		              <%if(car.getTint_b_yn().equals("Y")){%>2ä�� ���ڽ�<%}%> 
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>���� ����
                      &nbsp;
                                      ���ñ��������� : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		          &nbsp;
                      <%if(car.getTint_ps_yn().equals("Y")){%>��� ����
                      &nbsp;
                                      ���� : <%=car.getTint_ps_nm()%>, �ݾ� : <%=AddUtil.parseDecimal(car.getTint_ps_amt())%>�� (�ΰ�������)
                      <%}%>
                      <%if(car.getTint_n_yn().equals("Y")){%>��ġ�� ������̼�<%}%>
                      &nbsp;
                      <%if(car.getTint_eb_yn().equals("Y")){%>�̵��� ������<%}%>
                      &nbsp;
                      <%if(car.getTint_bn_yn().equals("Y")){%>���ڽ� ������ ���� (<%if(car.getTint_bn_nm().equals("1")){%>��Ʈ��ķ<%}else if(car.getTint_bn_nm().equals("2")){%>������<%}else{%>��Ʈ��ķ,������..<%}%>)<%}%> 
                      &nbsp;
                      <%if(car.getTint_cons_yn().equals("Y")){%>�߰�Ź�۷��
                      &nbsp;
                      <%=AddUtil.parseDecimal(car.getTint_cons_amt())%>��
                      <%}%> 
                      <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>&nbsp;������ȣ�ǽ�û<%}%>
<%--                       <%if(car.getNew_license_plate().equals("1")){%>&nbsp;������ȣ�ǽ�û(������)<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("2")){%>&nbsp;������ȣ�ǽ�û(����/�뱸/����/�λ�)<%}%> --%>
		    </td>
                </tr>			                	
                <tr>
                    <td class=title>�������ǰ</td>
                    <td width="40%">&nbsp;
        			  <%if(pur.getCom_tint().equals("")){%>����<%}%>                      					  
                      <%if(pur.getCom_tint().equals("1")){%>����<%}%>                      
                      <%if(pur.getCom_tint().equals("2")){%>�귣��ŰƮ<%}%> 
		    </td>
                    <td width="10%" class=title>������ ����</td>
                    <td width="40%">&nbsp;
        			  <%if(pur.getCom_film_st().equals("")){%>-<%}%>        				
					  <%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>                      				
        			  		<%if(pur.getCom_film_st().equals("1")){%>�縶<%}%>
        			  		<%if(pur.getCom_film_st().equals("2")){%>���<%}%>
						<%if(pur.getCom_film_st().equals("3")){%>SKC<%}%>
						<%if(pur.getCom_film_st().equals("4")){%>3M<%}%>
					  <%}%>	
        	    </td>					  
                </tr>		
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td> <span class=style2>����(���ĸ�/����)</span></td>
	</tr>  				                 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan='2' class='title'>�ð�����</td>
                    <td width='40%' >&nbsp;
                        <%if(tint1.getTint_yn().equals("Y")){%>���ĸ�<%}%>
                        <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("Y")){%>+<%}%>
                        <%if(tint2.getTint_yn().equals("Y")){%>����<%}%>
                        <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("N")){%>�ð���������<%}%>
                    </td>
                    <td colspan='2' class='title'>�ð���ü</td>
                    <td colspan='2' width='40%'>&nbsp;
                        <%=tint1.getOff_nm()%><%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("Y")){%><%=tint2.getOff_nm()%><%}%></td>
                </tr>
                <%if(tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y")){%>
                <tr> 
                    <td rowspan='2' width='5%' class='title'>�ʸ�����</td>
                    <td width='5%' class='title'>���ĸ�</td>
                    <td>&nbsp;
        		<%if(tint1.getFilm_st().equals("2")){%>3M
        		<%}else if(tint1.getFilm_st().equals("3")){%>�縶
        		<%}else if(tint1.getFilm_st().equals("5")){%>�ֶ󰡵�
        		<%}else if(tint1.getFilm_st().equals("6")){%>���
        		<%}else{%>��Ÿ(<%=tint1.getFilm_st()%>)
        		<%}%>
                    </td>
                    <td rowspan='2' width='5%' class='title'>���ñ���<br>������</td>
                    <td width='5%' class='title'>���ĸ�</td>
                    <td>&nbsp;
                        <%=tint1.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;
        		<%if(tint2.getFilm_st().equals("2")){%>3M
        		<%}else if(tint2.getFilm_st().equals("3")){%>�縶
        		<%}else if(tint2.getFilm_st().equals("5")){%>�ֶ󰡵�
        		<%}else if(tint2.getFilm_st().equals("6")){%>���
        		<%}else{%>��Ÿ(<%=tint2.getFilm_st()%>)
        		<%}%>                    
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp;
                        <%=tint2.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td rowspan='2' width='5%' class='title'>���δ�</td>
                    <td width='5%' class='title'>���ĸ�</td>
                    <td>&nbsp;
        		<%if(tint1.getCost_st().equals("1")){%>����
        		<%}else if(tint1.getCost_st().equals("2")){%>��
        		<%}else if(tint1.getCost_st().equals("4")){%>���
        		<%}else if(tint1.getCost_st().equals("5")){%>������Ʈ
        		<%}%>                       
                    </td>
                    <td rowspan='2' width='5%' class='title'>�����ݿ�</td>
                    <td width='5%' class='title'>���ĸ�</td>
                    <td>&nbsp;
        		<%if(tint1.getEst_st().equals("Y")){%>�ݿ� &nbsp;<%=AddUtil.parseDecimal(tint1.getEst_m_amt())%>��
        		<%}else if(tint1.getEst_st().equals("N")){%>�̹ݿ�
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;
        		<%if(tint2.getCost_st().equals("1")){%>����
        		<%}else if(tint2.getCost_st().equals("2")){%>��
        		<%}else if(tint2.getCost_st().equals("4")){%>���
        		<%}else if(tint2.getCost_st().equals("5")){%>������Ʈ
        		<%}%>                                           
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp;
        		<%if(tint2.getEst_st().equals("Y")){%>�ݿ� &nbsp;<%=AddUtil.parseDecimal(tint2.getEst_m_amt())%>��
        		<%}else if(tint2.getEst_st().equals("N")){%>�̹ݿ�
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' class='title'>��ġ����</td>
                    <td class='title'>���ĸ�</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint1.getSup_est_dt())%>���� ��û��</td>
                    <td rowspan='2' class='title'>��ġ���</td>
                    <td class='title'>���ĸ�</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint1.getTint_amt())%>��</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint2.getSup_est_dt())%>���� ��û��</td>
                    <td class='title'>����</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint2.getTint_amt())%>��</td>
                </tr>
                <%}%>
            </table>
	</td>
    </tr>      
	<tr>
	    <td> <span class=style2>���ڽ�</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>��ġ����</td>
                    <td width='40%' >&nbsp;
                        <%if(tint3.getTint_yn().equals("Y")){%>��ġ<%}%>
                        <%if(tint3.getTint_yn().equals("N")){%>��ġ��������<%}%>
                    </td>
                    <td width='10%' class='title'>��ġ��ü</td>
                    <td width='40%'>&nbsp;
                        <%=tint3.getOff_nm()%></td>
                </tr>
                <%if(tint3.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>�𵨼���</td>
                    <td>&nbsp;
                        <%if(tint3.getModel_st().equals("1")){%>��õ��<%}%>
                        <%if(!tint3.getModel_st().equals("") && !tint3.getModel_st().equals("1")){%>��Ÿ���ø�(<%=tint3.getModel_st()%>)<%}%>                    
                    </td>
                    <td class='title'>ä�μ���</td>
                    <td>&nbsp;
                        <%if(tint3.getChannel_st().equals("1")){%>1ä��<%}%>
                        <%if(tint3.getChannel_st().equals("2")){%>2ä��<%}%>                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�������</td>
                    <td>&nbsp;
                        <%=tint3.getCom_nm()%></td>
                    <td class='title'>�𵨸�</td>
                    <td>&nbsp;
                        <%=tint3.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>���δ�</td>
                    <td>&nbsp;
        		<%if(tint3.getCost_st().equals("1")){%>����
        		<%}else if(tint3.getCost_st().equals("2")){%>��(����)
        		<%}else if(tint3.getCost_st().equals("3")){%>��(�Ϻ�)
        		<%}else if(tint3.getCost_st().equals("4")){%>���
        		<%}else if(tint3.getCost_st().equals("5")){%>������Ʈ
        		<%}%>                       
                    </td>
                    <td class='title'>�����ݿ�</td>
                    <td>&nbsp;
        		<%if(tint3.getEst_st().equals("Y")){%>�ݿ� &nbsp;<%=AddUtil.parseDecimal(tint3.getEst_m_amt())%>��
        		<%}else if(tint3.getEst_st().equals("N")){%>�̹ݿ�
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>�۾�������û�Ͻ�</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint3.getSup_est_dt())%>���� ��û��
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>          	
	<tr>
	    <td> <span class=style2>������̼�</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>��ġ����</td>
                    <td width='40%' >&nbsp;
                        <%if(tint4.getTint_yn().equals("Y")){%>��ġ<%}%>
                        <%if(tint4.getTint_yn().equals("N")){%>��ġ��������<%}%>
                    </td>
                    <td width='10%' class='title'>��ġ��ü</td>
                    <td width='40%'>&nbsp;
                        <%=tint4.getOff_nm()%></td>
                </tr>
                <%if(tint4.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>�������</td>
                    <td>&nbsp;
                        <%=tint4.getCom_nm()%></td>
                    <td class='title'>�𵨸�</td>
                    <td>&nbsp;
                        <%=tint4.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>���δ�</td>
                    <td>&nbsp;
        		<%if(tint4.getCost_st().equals("1")){%>����
        		<%}else if(tint4.getCost_st().equals("2")){%>��        		
        		<%}else if(tint4.getCost_st().equals("4")){%>���
        		<%}else if(tint4.getCost_st().equals("5")){%>������Ʈ
        		<%}%>                       
                    </td>
                    <td class='title'>�����ݿ�</td>
                    <td>&nbsp;
        		<%if(tint4.getEst_st().equals("Y")){%>�ݿ� &nbsp;<%=AddUtil.parseDecimal(tint4.getEst_m_amt())%>��
        		<%}else if(tint4.getEst_st().equals("N")){%>�̹ݿ�
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>�۾�������û�Ͻ�</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint4.getSup_est_dt())%>���� ��û��
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>       	
	<tr>
	    <td> <span class=style2>��Ÿ��ǰ</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>��ǰ��</td>
                    <td width='40%' >&nbsp;
                        <%=tint5.getCom_nm()%>&nbsp;<%=tint5.getModel_nm()%></td>
                    <td width='10%' class='title'>��ġ��ü</td>
                    <td width='40%'>&nbsp;
                        <%=tint5.getOff_nm()%></td>
                </tr>
                <%if(!tint5.getModel_nm().equals("")){%>
                <tr> 
                    <td class='title'>���</td>
                    <td colspan='3'>&nbsp;
                        <%=tint5.getEtc()%></td>
                </tr>   
                <tr> 
                    <td class='title'>���δ�</td>
                    <td>&nbsp;
        		<%if(tint5.getCost_st().equals("1")){%>����
        		<%}else if(tint5.getCost_st().equals("2")){%>��        		
        		<%}else if(tint5.getCost_st().equals("4")){%>���
        		<%}else if(tint5.getCost_st().equals("5")){%>������Ʈ
        		<%}%>                       
                    </td>
                    <td class='title'>�����ݿ�</td>
                    <td>&nbsp;
        		<%if(tint5.getEst_st().equals("Y")){%>�ݿ� &nbsp;<%=AddUtil.parseDecimal(tint5.getEst_m_amt())%>��
        		<%}else if(tint5.getEst_st().equals("N")){%>�̹ݿ�
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>�۾�������û�Ͻ�</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint5.getSup_est_dt())%>���� ��û��
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>   
    <%if(ej_bean.getJg_g_7().equals("3")){//������%>
	<tr>
	    <td> <span class=style2>�̵��� ������</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>��ǰ��</td>
                    <td width='40%' >&nbsp;
                        <%=tint5.getCom_nm()%>&nbsp;<%=tint6.getModel_nm()%></td>
                    <td width='10%' class='title'>��ġ��ü</td>
                    <td width='40%'>&nbsp;
                        <%=tint6.getOff_nm()%></td>
                </tr>
                <%if(!tint6.getModel_nm().equals("")){%>
                <tr> 
                    <td class='title'>���</td>
                    <td colspan='3'>&nbsp;
                        <%=tint6.getEtc()%></td>
                </tr>   
                <tr> 
                    <td class='title'>���δ�</td>
                    <td>&nbsp;
        		<%if(tint6.getCost_st().equals("1")){%>����
        		<%}else if(tint6.getCost_st().equals("2")){%>��        		
        		<%}else if(tint6.getCost_st().equals("4")){%>���
        		<%}else if(tint6.getCost_st().equals("5")){%>������Ʈ
        		<%}%>                       
                    </td>
                    <td class='title'>�����ݿ�</td>
                    <td>&nbsp;
        		<%if(tint6.getEst_st().equals("Y")){%>�ݿ� &nbsp;<%=AddUtil.parseDecimal(tint6.getEst_m_amt())%>��
        		<%}else if(tint6.getEst_st().equals("N")){%>�̹ݿ�
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>�۾�������û�Ͻ�</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint6.getSup_est_dt())%>���� ��û��
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>   
    <%}%>    
           
    <%}%>				
	<tr>
	    <td class=h></td>
	</tr>	
	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width=10% rowspan="2" class=title>�뵵����</td>
                    <td width=15% rowspan="2" class=title>�������<br>[VAT����]</td>
                    <td colspan="3" class=title>�Աݳ���</td>
                    <td colspan="2" class=title>�̼���</td>
                </tr>
                <tr>
                    <td width=15% class=title>�ѱݾ�</td>
                    <td width=5% class=title>Ƚ��</td>
                    <td width=25% class=title>�ԱݱⰣ</td>
                    <td width=15% class=title>�ݾ�</td>
                    <td width=15% class=title>��������</td>
                </tr>
        		<%	Hashtable ext0 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, "1", "0");
        			Hashtable ext1 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, "1", "1");
        			Hashtable ext2 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, "1", "2");
        			
        			int pp_amt0 	= fee.getGrt_amt_s();
        			int pp_amt1 	= fee.getPp_s_amt()+fee.getPp_v_amt();
        			int pp_amt2 	= fee.getIfee_s_amt()+fee.getIfee_v_amt();
        			int pp_pay_amt0 = AddUtil.parseInt(String.valueOf(ext0.get("PAY_AMT")));
        			int pp_pay_amt1 = AddUtil.parseInt(String.valueOf(ext1.get("PAY_AMT")));
        			int pp_pay_amt2 = AddUtil.parseInt(String.valueOf(ext2.get("PAY_AMT")));
        			%>
                <tr>
                    <td class=title width=10%>������</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt0)%>'>��</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_pay_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_pay_amt0)%>'>��</td>
                    <td align="center"><%=AddUtil.parseDecimal(String.valueOf(ext0.get("CNT")))%></td>
                    <td align="center"><%if(AddUtil.parseInt(String.valueOf(ext0.get("CNT"))) > 0){%><%=AddUtil.ChangeDate2(String.valueOf(ext0.get("MIN_PAY_DT")))%><%if(!String.valueOf(ext0.get("MAX_PAY_DT")).equals(String.valueOf(ext0.get("MIN_PAY_DT")))){%>~<%=AddUtil.ChangeDate2(String.valueOf(ext0.get("MAX_PAY_DT")))%><%}%><%}else{%>-<%}%></td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_non_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt0-pp_pay_amt0)%>'>��</td>
                    <td align="center">&nbsp;<%if(pp_amt0-pp_pay_amt0 > 0){%><%=AddUtil.ChangeDate2(fee.getPp_est_dt())%><%}else{%>-<%}%></td>
                </tr>
                <tr>
                    <td class=title>������</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt1)%>'>��</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_pay_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_pay_amt1)%>'>��</td>
                    <td align="center"><%=AddUtil.parseDecimal(String.valueOf(ext1.get("CNT")))%></td>
                    <td align="center"><%if(AddUtil.parseInt(String.valueOf(ext1.get("CNT"))) > 0){%><%=AddUtil.ChangeDate2(String.valueOf(ext1.get("MIN_PAY_DT")))%><%if(!String.valueOf(ext1.get("MAX_PAY_DT")).equals(String.valueOf(ext1.get("MIN_PAY_DT")))){%>~<%=AddUtil.ChangeDate2(String.valueOf(ext1.get("MAX_PAY_DT")))%><%}%><%}else{%>-<%}%></td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_non_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt1-pp_pay_amt1)%>'>��</td>
                    <td align="center">&nbsp;<%if(pp_amt1-pp_pay_amt1 > 0){%><%=AddUtil.ChangeDate2(fee.getPp_est_dt())%><%}else{%>-<%}%></td>
                </tr>
                <tr>
                    <td class=title>���ô뿩��</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt2)%>'>��</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_pay_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_pay_amt2)%>'>��</td>
                    <td align="center"><%=AddUtil.parseDecimal(String.valueOf(ext2.get("CNT")))%></td>
                    <td align="center"><%if(AddUtil.parseInt(String.valueOf(ext2.get("CNT"))) > 0){%><%=AddUtil.ChangeDate2(String.valueOf(ext2.get("MIN_PAY_DT")))%><%if(!String.valueOf(ext2.get("MAX_PAY_DT")).equals(String.valueOf(ext2.get("MIN_PAY_DT")))){%>~<%=AddUtil.ChangeDate2(String.valueOf(ext2.get("MAX_PAY_DT")))%><%}%><%}else{%>-<%}%></td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_non_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt2-pp_pay_amt2)%>'>��</td>
                    <td align="center">&nbsp;<%if(pp_amt2-pp_pay_amt2 > 0){%><%=AddUtil.ChangeDate2(fee.getPp_est_dt())%><%}else{%>-<%}%></td>
                </tr>
                <tr>
                    <td class=title>�հ�</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt0+pp_amt1+pp_amt2)%>'>��</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_pay_amt0+pp_pay_amt1+pp_pay_amt2)%>'>��</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_non_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt0+pp_amt1+pp_amt2-pp_pay_amt0-pp_pay_amt1-pp_pay_amt2)%>'>��</td>
                    <td align="center">-</td>
                </tr>
        		<%if((pp_amt0+pp_amt1+pp_amt2-pp_pay_amt0-pp_pay_amt1-pp_pay_amt2) > 0){%>
                <tr>
                    <td class=title>�ĺ�ó������</td>
                    <td colspan="4">&nbsp;<input type='text' name='pp_etc' size='40' value='<%=fee.getPp_etc()%>' class='default'></td>
                    <td class=title>�ĺҰ���������</td>
                    <td>&nbsp;		    
            		    <input type='text' size='11' name='pp_est_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
            		    </td>
                </tr>
        		<input type='hidden' name='pp_st' value='�̰�'>
        		<%}else{%>
        		<input type='hidden' name='pp_st' value='�ϰ�'>
				<input type='hidden' name='pp_etc' value='<%=fee.getPp_etc()%>'>
				<input type='hidden' name='pp_est_dt' value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>'>
				<%}%>		
				<%if(base.getRent_st().equals("3") || cont_etc.getGrt_suc_r_amt() > 0){%>
                <tr> 
                    <td class=title>���������</td>
                    <td colspan='6'>&nbsp;
					  �°迩�� :
					  <select name='grt_suc_yn'>
                              <option value="">����</option>
                              <option value="0" <%if(fee.getGrt_suc_yn().equals("0"))%>selected<%%>>�°�</option>
                              <option value="1" <%if(fee.getGrt_suc_yn().equals("1"))%>selected<%%>>����</option>
                            </select>	
					  &nbsp;
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;����ȣ : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;���������� : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  ���������ݽ°� : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum' >��
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(���������� ���� <%=AddUtil.parseDecimal(fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  <%} %>		  
                      </td>
                </tr>		
				<%}else{%>
				<input type='hidden' name='grt_suc_m_id'  value='<%=cont_etc.getGrt_suc_m_id()%>'>
				<input type='hidden' name='grt_suc_l_cd'  value='<%=cont_etc.getGrt_suc_l_cd()%>'>
				<input type='hidden' name='grt_suc_c_no'  value='<%=cont_etc.getGrt_suc_c_no()%>'>
				<input type='hidden' name='grt_suc_o_amt' value='<%=cont_etc.getGrt_suc_o_amt()%>'>
				<input type='hidden' name='grt_suc_r_amt' value='<%=cont_etc.getGrt_suc_r_amt()%>'>
				<input type='hidden' name='grt_suc_yn' value='<%=fee.getGrt_suc_yn()%>'>
				<%}%>								
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
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>���Ա���</td>
                    <td width=15%>&nbsp;<%if(gins.getGi_st().equals("1")){%>����<%}else if(gins.getGi_st().equals("0")){%>����<%}%></td>
                    <td class=title width=10%>����ݾ�</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(gins.getGi_amt())%>��</td>
                    <td width="10%" class=title>���谡����</td>
                    <td width="15%">&nbsp;<%=AddUtil.ChangeDate2(gins.getGi_dt())%></td>
                    <td width="10%" class=title>�����</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(gins.getGi_fee())%>��</td>
                </tr>	
        		  <%if(gins.getGi_st().equals("1") && gins.getGi_dt().equals("")){%>
                <tr> 
                    <td class=title width=10%>ó������</td>
                    <td width=15%>&nbsp;�̰�</td>
                    <td class=title width=10%>�̰����</td>
                    <td colspan="3">&nbsp;<input type='text' name='gi_etc' size='40' value='<%=gins.getGi_etc()%>' class='default'></td>
                    <td class=title width=10%>�ϰΌ����</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='gi_est_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(gins.getGi_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        	    </tr>	
        		  <input type='hidden' name='gi_st' value='�̰�'>
        		  <%}else{%>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%=gins.getGi_jijum()%></td>
                    <td class=title>���ǹ�ȣ</td>
                    <td>&nbsp;<%=gins.getGi_no()%></td>
                    <td class=title>����Ⱓ</td>
                    <td colspan='3'>&nbsp;<%=AddUtil.ChangeDate2(gins.getGi_start_dt())%>~<%=AddUtil.ChangeDate2(gins.getGi_end_dt())%> (<%=gins.getGi_day()%>�ϰ�)</td>
                </tr>
        		  <input type='hidden' name='gi_st' value='�ϰ�'>
        		  <%}%>
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뺸��</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>��ǥ���뺸��</td>
                    <td width=15%>&nbsp;<%if(cont_etc.getClient_guar_st().equals("1")){%>�Ժ�<%}else if(cont_etc.getClient_guar_st().equals("2")){%>����<%}%></td>
                    <td class=title width=10%>��������</td>
                    <td width="15%">&nbsp;
        			  <%if(cont_etc.getGuar_con().equals("1")){%>�ſ�����<%}%>
                      <%if(cont_etc.getGuar_con().equals("2")){%>���������δ�ü<%}%>
                      <%if(cont_etc.getGuar_con().equals("3")){%>�����������δ�ü<%}%>
                      <%if(cont_etc.getGuar_con().equals("4")){%>��Ÿ ����ȹ��<%}%>
                      <%if(cont_etc.getGuar_con().equals("5")){%>�����濵��<%}%>
                      <%if(cont_etc.getGuar_con().equals("6")){%>��ǥ��������<%}%>
                      
        			</td>
                    <td width="10%" class=title>��Ÿ���뺸��</td>
                    <td width="15%">&nbsp;<%if(cont_etc.getGuar_st().equals("1")){%>����<%}else if(cont_etc.getGuar_st().equals("2")){%>����<%}%></td>
                    <td class=title>�����ο�</td>
                    <td>&nbsp;<%=gur_size%>��</td>
                </tr>
        		  <%if(cont_etc.getClient_guar_st().equals("1") || gur_size > 0){%>	
                <tr> 
                    <td class=title width=10%>ó������</td>
                    <td width=15%>&nbsp;
        			  <select name='guar_end_st' disabled>
                        <option value="">����</option>
                        <option value="1" <%if(cont_etc.getGuar_end_st().equals("1")){%>selected<%}%>>�̰�</option>
                        <option value="2" <%if(cont_etc.getGuar_end_st().equals("2")){%>selected<%}%>>�ϰ�</option>
                      </select>						
        			</td>
                    <td class=title width=10%>�̰����</td>
                    <td colspan="3">&nbsp;<input type='text' name='guar_etc' size='40' value='<%=cont_etc.getGuar_etc()%>' class='<%if(cont_etc.getGuar_end_st().equals("2")){%>white<%}%>text'></td>
                    <td class=title width=10%>�ϰΌ����</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='guar_est_dt' maxlength='10' class='<%if(cont_etc.getGuar_end_st().equals("2")){%>white<%}%>text' value='<%=AddUtil.ChangeDate2(cont_etc.getGuar_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        	    </tr>	
        		  <%}%>		
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ�������</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title>��������</td>
                    <td>&nbsp;
                      <%String insurant = cont_etc.getInsurant();%>
                      <%if(insurant.equals("1") || insurant.equals("")){%>
                        �Ƹ���ī
                      <%}else if(insurant.equals("2")){%>
                        ��
                      <%}%>
                    </td>
                    <td class=title>�Ǻ�����</td>
                    <td colspan="3">&nbsp;
                      <%String insur_per = cont_etc.getInsur_per();%>
                      <%if(insur_per.equals("1") || insur_per.equals("")){%>
                        �Ƹ���ī
                      <%}else if(insur_per.equals("2")){%>
                        ��
                      <%}%>
                    </td>
                    <td class=title >��������������Ư��</td>
                    <td>&nbsp;
                      <%if(cont_etc.getCom_emp_yn().equals("Y")){%>����<%}%>
                      <%if(cont_etc.getCom_emp_yn().equals("N")){%>�̰���<%}%>
                    </td>                           
        	    </tr>
        		  <%if(insur_per.equals("2")){%>
        	    <tr>
                    <td class=title>�Ժ�ȸ��</td>
                    <td colspan="7" class=''>
        			    <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">&nbsp;
            				    <%if(insur_per.equals("2")){%>
            				     	�����  : <%=cont_etc.getIp_insur()%>
                  				 	&nbsp;�븮�� : <%=cont_etc.getIp_agent()%>
                  					&nbsp;����� : <%=cont_etc.getIp_dam()%>
            						&nbsp;����ó : <%=cont_etc.getIp_tel()%>
            					<%}%>
            				    </td>
                            </tr>
                        </table>
        		    </td>
                </tr>
        		  <%}%>
                <tr>
                    <td class=title>�����ڹ���</td>
                    <td class=''>&nbsp;
                      <%String driving_ext = base.getDriving_ext();%>
                      <%if(driving_ext.equals("1") || driving_ext.equals("")){%>
                         �����
                      <%}else if(driving_ext.equals("2")){%>
                         ��������
                      <%}else if(driving_ext.equals("3")){%>
                         ��Ÿ
                      <%}%></td>
                    <td class=title >�����ڿ���</td>
                    <td class=''>&nbsp;
                      <%String driving_age = base.getDriving_age();%>
                      <%if(driving_age.equals("0")){%>
                         26���̻�
                      <%}else if(driving_age.equals("3")){%>
                         24���̻�
                      <%}else if(driving_age.equals("1")){%>
                         21���̻�
                      <%}else if(driving_age.equals("2")){%>
                        ��������
                      <%}else if(driving_age.equals("5")){%>
                        30���̻�
                      <%}else if(driving_age.equals("6")){%>
                        35���̻�
                      <%}else if(driving_age.equals("7")){%>
                        43���̻�
                      <%}else if(driving_age.equals("8")){%>
                        48���̻�
                      <%}else if(driving_age.equals("9")){%>
                        22���̻�
                      <%}else if(driving_age.equals("10")){%>
                        28���̻�
                      <%}else if(driving_age.equals("11")){%>
                        35���̻�~49������
                      <%}%>
                    </td>
                    <td  class=title>���ι��</td>
                    <td width="15%">&nbsp;����(���ι��,��)</td>
                    <td width="10%" class=title>����⵿</td>
                    <td width="15%" class=''>&nbsp;
                      <%String eme_yn = cont_etc.getEme_yn();%>
                      <%if(eme_yn.equals("Y")){%>
                        ����
                      <%}else if(eme_yn.equals("N")){%>
                        �̰���
                      <%}%></td>
                </tr>
                <tr>
                     <td class=title>�빰���</td>
                     <td class=''>&nbsp;
					   <%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5õ����<%}else if(gcp_kd.equals("2")){%>1���<%}else if(gcp_kd.equals("3")){%>5���<%}else if(gcp_kd.equals("4")){%>2���<%}else if(gcp_kd.equals("8")){%>3���<%}%>
                       </td>
                     <td class=title >�ڱ��ü���</td>
                     <td class=''>&nbsp;
                       <%String bacdt_kd = base.getBacdt_kd();%>
                       <%if(bacdt_kd.equals("1")){%>
                            5õ����
                       <%}else if(bacdt_kd.equals("2")){%>
                            1���
                       <%}%></td>
                     <td  class=title>������������</td>
                     <td>&nbsp;
                       <%String canoisr_yn = cont_etc.getCanoisr_yn();%>
                       <%if(canoisr_yn.equals("Y")){%>
                              ����
                       <%}else if(canoisr_yn.equals("N")){%>
                              �̰���
                       <%}%></td>
                     <td class=title>�ڱ���������</td>
                     <td class=''>&nbsp;
                       <%String cacdt_yn = cont_etc.getCacdt_yn();%>
                       <%if(cacdt_yn.equals("Y")){%>
                              ����
                       <%}else if(cacdt_yn.equals("N")){%>
                              �̰���
                       <%}%></td>
                </tr>		
                <tr>
                    <td width="10%"  class=title>������å��</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(base.getCar_ja())%>��</td>
                    <td width="10%" class=title>������</td>
                    <td width="15%" class=''><%=c_db.getNameById(cont_etc.getRea_appr_id(),"USER")%></td>
                    <td width="10%" class=title >�������</td>
                    <td colspan="3" class=''>&nbsp;(�⺻ <%=AddUtil.parseDecimal(car.getImm_amt())%>��)<%=cont_etc.getJa_reason()%></td>
                </tr>
                <tr>
                    <td  class=title>�ڵ���</td>
                    <td colspan="7">&nbsp;
                      <input type="checkbox" name="air_ds_yn" 	value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%>checked<%}%> disabled>
        				�����������
                      <input type="checkbox" name="air_as_yn" 	value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%>checked<%}%> disabled>
        				�����������
        	      <!--			
                      <input type="checkbox" name="air_cu_yn" 	value="Y" <%if(cont_etc.getAir_cu_yn().equals("Y")){%>checked<%}%> disabled>
        				Ŀư�����
                      <input type="checkbox" name="auto_yn" 	value="Y" <%if(cont_etc.getAuto_yn().equals("Y")){%>checked<%}%> disabled>
        				�ڵ����ӱ�
                      <input type="checkbox" name="abs_yn" 		value="Y" <%if(cont_etc.getAbs_yn().equals("Y")){%>checked<%}%> disabled>
        				ABS��ġ
                      <input type="checkbox" name="rob_yn" 		value="Y" <%if(cont_etc.getRob_yn().equals("Y")){%>checked<%}%> disabled>
        				����������ġ				
                      <input type="checkbox" name="sp_car_yn" 	value="Y" <%if(cont_etc.getSp_car_yn().equals("Y")){%>checked<%}%> disabled>
                      ������ī����
                      -->
                      <input type="checkbox" name="v_blackbox_yn" 	value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%>checked<%}%> disabled>
        				���ڽ�
                      </td>
                </tr>
        		  <%if(!base.getOthers().equals("")){%>
                <tr>
                    <td class='title'>���</td>
                    <td colspan="7">&nbsp;<%=HtmlUtil.htmlBR(base.getOthers())%></td>
                </tr>
        		  <%}%>
            </table>
        </td>
    </tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	<tr> 		 
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>  	
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">����</td>
                    <td class=title width=15%>������</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%><%=doc.getUser_nm3()%></td>
                    <td class=title width=15%><%=doc.getUser_nm4()%></td>
                    <td class=title width=15%><%=doc.getUser_nm5()%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></td>
                    <td align="center"><!--������--><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			  <%if(!doc.getUser_id2().equals("XXXXXX")){
					    if(doc.getUser_dt2().equals("")){
        			  		String user_id2 = doc.getUser_id2();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        					if(!cs_bean.getWork_id().equals(""))									user_id2 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id2 = "000128";//��ȭ��
        					%>
        			  <%	if(doc.getUser_id2().equals(user_id) || user_id2.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("������ڵ��������",user_id)){%>
        			    <a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
					  <%}else{%>
					    -<br>&nbsp;
					  <%}%>
        			</td>
                    <td align="center"><!--�������--><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
        			  <%if(doc.getUser_dt3().equals("")){
        			  		String user_id3 = doc.getUser_id3();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
        					if(!cs_bean.getWork_id().equals(""))									user_id3 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id3 = "000126";//������
        					%>
        			  <%	if(doc.getUser_id3().equals(user_id) || user_id3.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("������ڵ��������",user_id)){%>
        			    <a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>					  
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>
                    <td align="center"><!--ȸ������--><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%>					  
        			  <%if(!doc.getUser_id4().equals("XXXXXX")){
					    if(!doc.getUser_dt3().equals("") && doc.getUser_dt4().equals("")){
        				  	String user_id4 = doc.getUser_id4();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id4);
        					if(!cs_bean.getWork_id().equals(""))					user_id4 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id4 = "000172";//���¿�->������
        					%>
        			  <%	if(doc.getUser_id4().equals(user_id) || user_id4.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("������ڵ��������",user_id)){%>
        			    <a href="javascript:doc_sanction('4')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
					  <%}else{%>
					    -<br>&nbsp;
					  <%}%>
        			</td>
                    <td align="center"><!--�ѹ�����--><%=c_db.getNameById(doc.getUser_id5(),"USER_PO")%><br><%=doc.getUser_dt5()%>
        			  <%if(doc.getUser_dt5().equals("") && !doc.getUser_dt3().equals("")){
        			  		String user_id5 = doc.getUser_id5();
        					CarScheBean cs_bean = csd.getCarScheTodayBean(user_id5);
        					if(!cs_bean.getWork_id().equals(""))	user_id5 = cs_bean.getWork_id();
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals(""))	user_id5 = "000172";//���¿�->������
        					%>
        			  <%	if(doc.getUser_id5().equals(user_id) || user_id5.equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("��������",user_id) || nm_db.getWorkAuthUser("������ڵ��������",user_id)){%>
        			    <a href="javascript:doc_sanction('5')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			</td>			
        	    </tr>	
    		</table>
	    </td>
	</tr>  	  
</table>
</form>
<script language="JavaScript">
<!--	
	var fm = document.form1;		
		
	fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
	fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
	fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
		
	fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
	fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
	fm.tot_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							
		
	//�ٷΰ���
	var s_fm = parent.top_menu.document.form1;
	s_fm.auth_rw.value 		= fm.auth_rw.value;
	s_fm.user_id.value 		= fm.user_id.value;
	s_fm.br_id.value 		= fm.br_id.value;		
	s_fm.m_id.value 		= fm.rent_mng_id.value;
	s_fm.l_cd.value 		= fm.rent_l_cd.value;	
	s_fm.c_id.value 		= "<%=base.getCar_mng_id()%>";
	s_fm.client_id.value 	= "<%=base.getClient_id()%>";	
	s_fm.accid_id.value 	= "";
	s_fm.serv_id.value 		= "";
	s_fm.seq_no.value 		= "";				
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

