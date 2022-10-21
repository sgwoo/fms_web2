<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.tint.*, acar.doc_settle.*, acar.estimate_mng.*, card.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
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
		
	//�������
	co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	
	
	
	//Ư�ǰ������
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreRent(rent_l_cd);	
	
	int car_off_chk1 = 0;
	int car_off_chk2 = 0;
	
	//������� �ѽ���ȣ, ����ڵ�Ϲ�ȣ �Է� üũ
	if(co_bean.getCar_off_fax().equals(""))						car_off_chk1 = 1;
	if(co_bean.getVen_code().equals("") && co_bean.getEnp_no().equals(""))		car_off_chk2 = 1;
	
	
	//��ǰ	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
	TintBean tint3 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "3");
	TintBean tint4 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "4");
	TintBean tint5 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "5");
	TintBean tint6 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "6");
	
	
	//��������
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("4", rent_l_cd);
	}
	
	//���������
	user_bean 	= umd.getUsersBean(base.getBus_id());
	
	//����Ʈ �ӽÿ��ຸ���
		int b_ins_amt = 0;
		if(pur.getOne_self().equals("Y")){
			if(coe_bean.getCar_off_id().equals("00631") || coe_bean.getCar_off_id().equals("00588")){
				//�¿�-�Ϲ�-6������
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 100 && AddUtil.parseInt(ej_bean.getJg_a()) <= 402){
					b_ins_amt = 2000;
				}
				//�¿�-�Ϲ�-6������-������
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 901 && AddUtil.parseInt(ej_bean.getJg_a()) <= 904){
					b_ins_amt = 2000;
				}
				//�¿�-���ν�-10������
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 501 && AddUtil.parseInt(ej_bean.getJg_a()) <= 701){
					b_ins_amt = 2800;
				}
				//ȭ��-��-1������
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 801 && AddUtil.parseInt(ej_bean.getJg_a()) <= 803){
					b_ins_amt = 3100;
				}
				//ȭ��-��-1��~5������
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 811 && AddUtil.parseInt(ej_bean.getJg_a()) <= 821){
					b_ins_amt = 2700;
				}
				//����
				if(AddUtil.parseInt(ej_bean.getJg_a()) == 702){
					b_ins_amt = 3400;
				}
				//����-��Ÿ����11�ν�
				if(AddUtil.parseInt(ej_bean.getJg_a()) == 700){
					b_ins_amt = 3400;
				}
			}
		}	
	
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
	
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
	
	//����DC�ڵ�
	CodeBean[] codes = c_db.getCodeAll("0017");
	int c_size = codes.length;
	
	int scan_cnt = 0;
	
	String  file_path = "";
	String theURL = "https://fms3.amazoncar.co.kr/data/";	
	String file_ext=".pdf";	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
	String content_code = "LC_SCAN";
	String content_seq  = rent_mng_id+""+rent_l_cd; 
			
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;       

	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
	
	// �ӽÿ��ຸ��� 2018.04.20
	Vector attach_vt_26 = new Vector();
	String content_seq_26 = content_seq;
	content_seq_26 += "126";
	attach_vt_26 = c_db.getAcarAttachFileListEqual(content_code, content_seq_26, 0);
	
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
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	//����Ʈ
	function list(){
		var fm = document.form1;			
		fm.action = 'pur_doc_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//Ź�۾�ü ��ȸ
	function search_off()
	{
		var fm = document.form1;	
		window.open("/agent/cus0601/cus0602_frame.jsp?from_page=/agent/consignment/cons_i_c.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//Ź�۾�ü Ź�۷� ��ȸ
	function search_off_amt()
	{
		var fm = document.form1;
		if(fm.cons_st.value !== '2')		{ 	alert('Ź�۱����� ��ü�϶� ��ȸ�Ͻʽÿ�.'); 	return; }
		if(fm.dlv_ext.value == '')		{ 	alert('������� �����Ͻʽÿ�.'); 				return;	}
		if(fm.udt_st.value == '')		{	alert('�μ����� �����Ͻʽÿ�.'); 				return; }
		if(fm.off_id.value == '')		{	alert('Ź�۾�ü�� �����Ͻʽÿ�.'); 				return; }
		var o_url = "/agent/cons_cost/s_cons_cost.jsp?car_comp_id=<%=cm_bean.getCar_comp_id()%>&car_cd=<%=cm_bean.getCode()%>&off_id="+fm.off_id.value+"&off_nm="+fm.off_nm.value+"&dlv_ext="+fm.dlv_ext.value+"&udt_st="+fm.udt_st.value;
		window.open(o_url, "CONS_COST", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}	
	function search_base_consamt(){
		var fm = document.form1;
		if('<%=cm_bean.getDlv_ext()%>'== ''){ alert('�⺻������� �����ϴ�.'); return; }
		if(fm.udt_st.value == '')		{	alert('�μ����� �����Ͻʽÿ�.'); 				return; }
		if(fm.udt_st.value == '4')		{	alert('�μ����� ���� ��� �⺻ Ź�۷ᰡ ��ȸ���� �ʽ��ϴ�.');				return; }
		var o_url = "/agent/cons_cost/s_cons_cost_base.jsp?rent_l_cd=<%=rent_l_cd%>&car_comp_id=<%=cm_bean.getCar_comp_id()%>&car_cd=<%=cm_bean.getCode()%>&dlv_ext=<%=cm_bean.getDlv_ext()%>&udt_st="+fm.udt_st.value;
		window.open(o_url, "CONS_COST", "left=10, top=10, width=300, height=700, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//���������ݽ°���ȸ
	function search_grt_suc()
	{
		var fm = document.form1;	
		window.open("s_grt_suc.jsp?from_page=/fms2/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}		
			
	//��ǰ���� �˾�
	function cng_rent_ext(){
		var fm = document.form1;		
		var width = 600;
		var firm_nm = '';				
		
		window.open("/agent/consignment/s_place.jsp?go_url=/agent/car_pur/pur_doc_i.jsp&st=&value=2&idx=0&s_kd=1&t_wd=<%=client.getFirm_nm()%>&req_id=<%=user_id%>", "PLACE", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");		
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
		
		if(fm.cons_st.value == '2'){
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
		
		//ģȯ���� ������ ������ݰ����� ��� ���ź������� �ܾ� ��꿡 �ݿ��Ѵ�.->20170102 ���޼��ܿ��� ó���Ѵ�.
		<%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>
			<%if(car.getEcar_pur_sub_st().equals("1")){%>
				//fm.jan_amt.value = parseDecimal(toInt(parseDigit(fm.tot_f_amt.value)) - toInt(parseDigit(fm.ecar_pur_sub_amt.value)) - toInt(parseDigit(fm.con_amt.value))); 	
			<%}%>
		<%}%>		
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
	}	
	
	//����DC �հ�
	function set_dc_amt(){
		var fm = document.form1;		
		
		fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_dc1_amt.value)) + toInt(parseDigit(fm.s_dc2_amt.value)) + toInt(parseDigit(fm.s_dc3_amt.value)) );		
		fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_c_amt.value))));
		fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));
		
		sum_car_f_amt();
	}
	
	//�Һ��ڰ���� �ݾװ��
	function setDc_per_amt(obj, idx){
		obj.value = obj.value;
		var fm = document.form1;
		
		if(idx == 1){
			if(obj==fm.s_dc1_per){
				fm.s_dc1_amt.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * toFloat(fm.s_dc1_per.value) /100 ) );
			}else if(obj==fm.s_dc1_amt){
				fm.s_dc1_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc1_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			}
		}
		if(idx == 2){
			if(obj==fm.s_dc2_per){
				fm.s_dc2_amt.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * toFloat(fm.s_dc2_per.value) /100) );
			}else if(obj==fm.s_dc2_amt){
				fm.s_dc2_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc2_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			}
		}
		if(idx == 3){
			if(obj==fm.s_dc3_per){
				fm.s_dc3_amt.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * toFloat(fm.s_dc3_per.value) /100));
			}else if(obj==fm.s_dc3_amt){
				fm.s_dc3_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc3_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			}
		}
	}
	
	//����DC
	function search_dc(){
		var fm = document.form1;
		window.open("/agent/lc_rent/search_dc.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "COMP_DC", "left=100, top=100, height=200, width=800, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//��ĵ���
	function scan_reg(file_st){
		window.open("/agent/lc_rent/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_doc_i.jsp&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//��ĵ���� ����
	function view_scan(){
		window.open("/agent/lc_rent/scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//��¥����
	function dt_set(){
		var fm = document.form1;
		fm.udt_est_dt.value = fm.dlv_est_dt.value;
		fm.reg_est_dt.value = fm.dlv_est_dt.value;
		fm.rent_est_dt.value = fm.dlv_est_dt.value;				
	}
	

	
	//���� �ڵ庯ȯ
  	function set_dc_re(idx){
		var fm = document.form1;
		if(idx == 1){
			if(fm.s_dc1_re.value == "1")				fm.s_dc1_re.value = '�Ǹ�����������';
    		else if(fm.s_dc1_re.value  == "2")      	fm.s_dc1_re.value = '������';
    		else if(fm.s_dc1_re.value  == "3")      	fm.s_dc1_re.value = '������';
    		else if(fm.s_dc1_re.value  == "4")      	fm.s_dc1_re.value = '�ٷ�����ó���';
    		else if(fm.s_dc1_re.value  == "5")      	fm.s_dc1_re.value = 'ķ����';									    					
		}
		if(idx == 2){
			if(fm.s_dc2_re.value == "1")				fm.s_dc2_re.value = '�Ǹ�����������';
    		else if(fm.s_dc2_re.value  == "2")      	fm.s_dc2_re.value = '������';
    		else if(fm.s_dc2_re.value  == "3")      	fm.s_dc2_re.value = '������';
    		else if(fm.s_dc2_re.value  == "4")      	fm.s_dc2_re.value = '�ٷ�����ó���';
    		else if(fm.s_dc2_re.value  == "5")      	fm.s_dc2_re.value = 'ķ����';									    					
		}
		if(idx == 3){
			if(fm.s_dc3_re.value == "1")				fm.s_dc3_re.value = '�Ǹ�����������';
    		else if(fm.s_dc3_re.value  == "2")      	fm.s_dc3_re.value = '������';
    		else if(fm.s_dc3_re.value  == "3")      	fm.s_dc3_re.value = '������';
    		else if(fm.s_dc3_re.value  == "4")      	fm.s_dc3_re.value = '�ٷ�����ó���';
    		else if(fm.s_dc3_re.value  == "5")      	fm.s_dc3_re.value = 'ķ����';									    					
		}
  	}
		
		
	//���
	function save(){
		var fm = document.form1;

		if(fm.dlv_est_dt.value  != ''  && fm.dlv_est_h.value  == '') 		fm.dlv_est_h.value 	= '00';		
		if(fm.reg_est_dt.value  != ''  && fm.reg_est_h.value  == '') 		fm.reg_est_h.value 	= '00';		
		if(fm.rent_est_dt.value != ''  && fm.rent_est_h.value == '') 		fm.rent_est_h.value = '00';
		
		if(<%=fee.getGrt_amt_s()+fee.getPp_s_amt()+fee.getIfee_s_amt()%>==0 && '<%=gins.getGi_st()%>'=='0' && '<%=cont_etc.getClient_guar_st()%>'=='2'){
			if(!confirm("ä��Ȯ���� ��� ������ �����Դϴ�. �ٽ��ѹ� ä��Ȯ�� ���� ���θ� Ȯ�����ּ���"))	return;
		}
		
		
		
		<%if(base.getRent_st().equals("3")){%>
		if(toInt(parseDigit(fm.grt_suc_r_amt.value))>0 && fm.grt_suc_yn.value != '0'){
			fm.grt_suc_yn.value = '0';
		} 
		if(fm.grt_suc_yn.value == '')		{	alert('�������������� �°迩�θ� �������ּ���.'); 		fm.grt_suc_yn.focus(); 		return;		}
		if(fm.grt_suc_yn.value == '0' && fm.pp_st.value == '�̰�' && (fm.pp_est_dt.value == '' || fm.pp_etc.value == '')){
			alert('������ �ĺҰ��������� �Ǵ� �ĺ�ó�������� �Է��Ͻʽÿ�.');  					fm.pp_etc.focus(); 		return;		}
		
		<%}else{%>		
		if(fm.pp_st.value == '�̰�' && (fm.pp_est_dt.value == '' || fm.pp_etc.value == '')){
			alert('������ �ĺҰ��������� �Ǵ� �ĺ�ó�������� �Է��Ͻʽÿ�.');  					fm.pp_etc.focus(); 		return;		}
		<%}%>
					
		if(fm.gi_st.value == '�̰�' && (fm.gi_est_dt.value == '' || fm.gi_etc.value == '')){
			alert('�������� �ϰΌ���� �Ǵ� �̰������ �Է��Ͻʽÿ�.'); 						fm.gi_etc.focus(); 		return;		}
		
		if(fm.guar_end_st.value == '�̰�' && (fm.guar_est_dt.value == '' || fm.guar_etc.value == '')){
			alert('���뺸�� �ϰΌ���� �Ǵ� �̰������ �Է��Ͻʽÿ�.'); 						fm.guar_etc.focus(); 		return;		}		
	
		if(fm.guar_end_st.value == '')	{	alert('���뺸�� ó�������� �����Ͽ� �ֽʽÿ�.'); 			fm.guar_end_st.focus(); 	return;		}
		
		
		
		if(fm.dlv_ext.value == '')		{	alert('������� �Է��Ͽ� �ֽʽÿ�.'); 				fm.dlv_ext.focus(); 		return;		}
		if(fm.dlv_est_dt.value == '')		{	alert('��������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 			fm.dlv_est_dt.focus(); 		return;		}
		if(fm.udt_st.value == '')		{	alert('�μ����� �Է��Ͽ� �ֽʽÿ�.'); 				fm.udt_st.focus(); 		return;		}
		if(fm.udt_est_dt.value == '')		{	alert('�μ��������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 			fm.udt_est_dt.focus(); 		return;		}
		
		if(fm.cons_st.value == '')		{	alert('Ź�۱����� �Է��Ͽ� �ֽʽÿ�.'); 			fm.cons_st.focus(); 		return;		}
		
		//��üŹ��
		if(fm.cons_st.value == '2'){
			if(toInt(parseDigit(fm.cons_amt1.value))==0){ alert('Ź�۷�1�� �Է��Ͻʽÿ�.'); return;}
		//���Ź��	
		}else{
			//�������ƴϸ�
			if('<%=ej_bean.getJg_w()%>'!='1'){
				if(toInt(parseDigit(fm.cons_amt1.value))==0){ alert('Ź�۷�1�� �Է��Ͻʽÿ�.'); return;}
			}
		}
		
		if(fm.reg_est_dt.value == '')		{	alert('��Ͽ������� �Է��Ͽ� �ֽʽÿ�.'); 			fm.reg_est_dt.focus(); 		return;		}
		if(fm.rent_est_dt.value == '')		{	alert('��ǰ�������� �Է��Ͽ� �ֽʽÿ�.'); 			fm.rent_est_dt.focus(); 	return;		}
		if(fm.rent_ext.value == '')		{	alert('��ǰ������ �Է��Ͽ� �ֽʽÿ�.'); 			fm.rent_ext.focus(); 		return;		}
		if(fm.rpt_no.value == '')		{	alert('�����ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 			fm.rpt_no.focus(); 		return;		}
				
		if(	toInt(parseDigit(fm.s_dc1_amt.value))>0 && fm.s_dc1_re.value == ''){ alert('����D/C ����1�� �Է��Ͻʽÿ�.'); return; }
		if(	toInt(parseDigit(fm.s_dc2_amt.value))>0 && fm.s_dc2_re.value == ''){ alert('����D/C ����2�� �Է��Ͻʽÿ�.'); return; }
		if(	toInt(parseDigit(fm.s_dc3_amt.value))>0 && fm.s_dc3_re.value == ''){ alert('����D/C ����3�� �Է��Ͻʽÿ�.'); return; }		
		
		
		
		if(	toInt(parseDigit(fm.car_f_amt.value))==0){ alert('�������԰����� 0�� �Դϴ�. �������԰����� ���������� �Էµ��� �ʾҽ��ϴ�. ���԰��ݿ� �ִ� ������ư Ŭ���Ͽ� �����Ͻʽÿ�.'); return; }				
		
		if(fm.jan_amt.value == '0')		{	alert('������� �ܾ��� Ȯ���Ͽ� �ֽʽÿ�.'); 			fm.jan_amt.focus(); 		return;		}
		if(fm.con_est_dt.value == '')		{	alert('����ó����û���� �Է��Ͽ� �ֽʽÿ�.');			fm.con_est_dt.focus(); 		return;		}
		
		

		<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
		
		var com_tint = "";

		if(fm.com_tint[0].checked==true){		//�������ǰ-����
			com_tint = "����";
			if(fm.com_film_st[1].checked==true || fm.com_film_st[2].checked==true){
				alert('�ʸ�-�⺻�� �������� �ϰ�, �ʸ�-���ÿ��� �ش��ϴ� �����ʸ��� �����Ͻʽÿ�.'); return;
			}			
		}else if(fm.com_tint[1].checked==true){//�������ǰ-����
			com_tint = "����";		
			if(fm.com_film_st[0].checked==true){
				alert('�ʸ�-�⺻�� �縶 ���� ��񽺸� �����Ͻʽÿ�.'); return;
			}	
			
			<%if(tint1.getTint_no().equals("")){%>
				if(!confirm('�������ǰ�� �����Դϴ�. ������-��ǰ�� ������ ��ϵ� ���� ������ �Է��ϼž� �մϴ�.'))	return;
			<%}%>
					
		}else if(fm.com_tint[2].checked==true){//�������ǰ-�귣��Ű��
			com_tint = "�귣��Ű��";		
			fm.com_film_st[0].checked=true;			
		}
		
		if(!confirm('�������ǰ�� '+com_tint+' �½��ϱ�?'))			 return;
				
		<%}%>		
		
		if(fm.com_con_no.value == ''){
			if(fm.trf_st0.value == '' || fm.trf_st0.value == '1'){
				<%if(coe_bean.getCar_comp_id().equals("0004") || (!coe_bean.getCar_comp_id().equals("0004") && !coe_bean.getOne_self_yn().equals("Y"))){//GM||����������%>		
				if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){	alert('��������û����-���������� �Է��Ͻʽÿ�.'); 		fm.con_acc_no.focus(); 		return;		}
				<%}%>
			}	
		}
		
		//����ó����û�Ϸ� ���� 2���� �ʰ��Ͽ� ��ǰ������ �������� �޽����� ǥ��
		if(getRentTime('d', fm.con_est_dt.value, fm.rent_est_dt.value) > 1){ 
			if(!confirm('��ǰ�������� ����ó����û�Ϸ� ���� 2���� �ʰ��� ���Դϴ�. \n\n������� ���ΰ��縦 �����ʽÿ�.'))			
				return;
		}
		
		<%if((cm_bean.getCar_comp_id().equals("0001")||cm_bean.getCar_comp_id().equals("0002")) && !String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null")){%>
		if(fm.rpt_no.value != '<%=pur_com.get("COM_CON_NO")%>'){	alert('Ư�ǰ���ȣ�� �Է��� �����ȣ�� Ʋ���ϴ�. Ȯ���Ͻʽÿ�.'); 		fm.rpt_no.focus(); 		return;		}
		<%}%>		
		
		
		//20151116 ������ ��� �������ӱ� Ȯ��
		if(<%=base.getCar_gu()%> == '1'){
			if(fm.auto.value == 'M/T'){
				if(!confirm('�������ӱ� �����Դϴ�. ����Ͻðڽ��ϱ�?')){			
					return;
				}
			}
		}	
		
		//2018.04.20
		//�ӽÿ��ຸ��� ������ üũ
		<%if(coe_bean.getCar_off_id().equals("00631") || coe_bean.getCar_off_id().equals("00588")){ //20210525 ���� ����,�ѽŴ�� ��ĵ���� �ݾ��Է� �ʼ�%>
			if(fm.trf_amt5.value == '' || fm.trf_amt5.value == '0'){
				alert('�ӽÿ��ຸ��� �ݾ� �Է��� �ʼ��Դϴ�.'); 
				return;
			}
		<%}else{%>
			var trf_amt_remove_comma = parseInt((fm.trf_amt5.value).replace(/,/g,""));
			if(trf_amt_remove_comma != undefined){
				if(trf_amt_remove_comma > 1){
					//if(<%=attach_vt_26.size()%><1){alert('�ӽÿ��ຸ��� ������ ��ĵ������ �����ϴ�. \n��ĵ������ ������ֽʽÿ�.'); return; }
				}
			}
		<%}%>
		
		var dlv_chk = 0;
		//�������Ź�۱��к� ����
		//������-�ƻ�-�������-�μ���(����/����/�λ�/�뱸/����)
		if(fm.car_comp_id.value=='0001' && fm.dlv_ext.value=='�ƻ�' && fm.off_id.value=='011372' && (fm.udt_st.value=='1'||fm.udt_st.value=='2'||fm.udt_st.value=='3'||fm.udt_st.value=='5'||fm.udt_st.value=='6')){
			dlv_chk = 1;
		}
		//������-���-�������-�μ���(����/����)
		if(fm.car_comp_id.value=='0001' && fm.dlv_ext.value=='���' && fm.off_id.value=='011372' && (fm.udt_st.value=='1'||fm.udt_st.value=='3')){
			dlv_chk = 1;
		}
		//�����-ȭ��-����Ư��-�μ���(����/����/�λ�/�뱸)
		if(fm.car_comp_id.value=='0002' && fm.dlv_ext.value=='ȭ��' && fm.off_id.value=='007751' && (fm.udt_st.value=='1'||fm.udt_st.value=='2'||fm.udt_st.value=='5'||fm.udt_st.value=='6')){
			dlv_chk = 1;
		}
		//�����-����-����Ư��-�μ���(�λ�/�뱸)
		if(fm.car_comp_id.value=='0002' && fm.dlv_ext.value=='����' && fm.off_id.value=='007751' && (fm.udt_st.value=='2'||fm.udt_st.value=='5')){
			dlv_chk = 1;
		}
		//��ȭ�������� �ϴ� �����ϰ�  - 20210812
		if ( fm.off_id.value=='010265') {
			dlv_chk = 1;
		}
		//�Ｚ�� ����
		if (fm.car_comp_id.value=='0003') {
			dlv_chk = 1;
		}
		
		if(fm.cons_st.value == '2' && dlv_chk==0){
			alert('��üŹ�� �Ұ����� <�����-�μ���-Ź�ۻ�>�Դϴ�. Ȯ���Ͻʽÿ�.'); return;
		}
		
		if(confirm('��� �Ͻðڽ��ϱ�?')){	
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			fm.action='pur_doc_i_a.jsp';		
			fm.target='d_content';			
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}	
	}		
		
	//�뿩�ϼ� ���ϱ�
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}	
	
	
	
	//�������ǰ
	function cng_com_tint(idx){
		var fm = document.form1;
		<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
		
		if(idx==0){								//����
			fm.com_film_st	[0].checked	=true;
		}else if(idx==1){							//����
			fm.com_film_st	[1].checked	=true;
		}else if(idx==2){							//�귣��Ű��
			fm.com_film_st	[0].checked	=true;
		}				
		
		<%}%>
	}				
	
	//�ʸ�-�⺻
	function cng_com_film_st(idx){
		var fm = document.form1;
		<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
		
		if(idx==0){									//����
			if(fm.com_tint[1].checked==true){
				alert('�������ǰ�� �������� �Ǿ� �ֽ��ϴ�. �縶/���/SKC �� ���� �Ͻʽÿ�.');
				fm.com_film_st	[1].checked	=true;
			}
		}else if(idx==1 || idx==2 || idx==3 || idx==4){							//�縶||���||SKC||3M	
			if(fm.com_tint[1].checked==true){
			}else{
				alert('�������ǰ�� �������� �Ǿ� ���� �ʽ��ϴ�.');		
				fm.com_tint[1].checked=true;		
			}
		}
		
		<%}%>
	}	
	
	
	//Ư�ǹ�������
	function view_car_pur_com(com_con_no){
		var fm = document.form1;
		window.open("/fms2/pur_com/lc_rent_c.jsp?mode=view&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&com_con_no="+com_con_no, "PUR_COM", "left=0, top=0, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function tint_update(st){
		if(st == '1')	window.open("/agent/lc_rent/lc_c_u_tint1.jsp<%=valus%>&from_page2=pur_doc_i.jsp", "CHANGE_TINT", "left=100, top=100, width=950, height=650");
		else		window.open("/agent/lc_rent/lc_c_u_tint2.jsp<%=valus%>&st="+st+"&from_page2=pur_doc_i.jsp", "CHANGE_TINT", "left=100, top=100, width=950, height=650");	
	}
	
	function openHc(){
  		window.open('/acar/common/hyundai_confidentiality.jsp','_blank', 'width=800, height=600, menubars=no, scrollbars=auto');
 	}
	
	//����
	function update_car_amt(){
		var st = 'car_amt';
		var height = 500;
		window.open("/agent/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=50, top=50, width=1150, height="+height+", resizable=yes, scrollbars=yes, status=yes");
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
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>   
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="car_nm" 		value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">  
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="gur_size" 		value="<%=gur_size%>">  
  <input type='hidden' name="file_st" 		value="">  
  <input type='hidden' name="car_comp_id"	value="<%=emp2.getCar_comp_id()%>">    
  <input type='hidden' name='auto_yn' value='<%=cm_bean.getAuto_yn()%>'>
  <input type='hidden' name='car_b' value='<%=cm_bean.getCar_b()%>'>
  <input type='hidden' name='opt' value='<%=car.getOpt()%>'>
     
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
	    <td align="right"><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
	<tr> 	
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
                    <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}%></td>
                    <td class=title width=10%>��������</td>
                    <td width=15%>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}else if(rent_way.equals("2")){%>�����<%}%></td>
                    <td class=title width=10%>�̿�Ⱓ</td>
                    <td width=15%>&nbsp;<%=fee.getCon_mon()%>����</td>
                    <td class=title width=10%>���뿩��</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>��</td>
    		    </tr>
    		    <%if(1!=1){%>
                <tr>
                    <td class=title>����</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                    <td class=title width=10%>���������</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>	
    		    <%//if(!car.getOpt().equals("")){%>
                <tr>
                    <td class=title>�ɼ�</td>
                    <td colspan="5">&nbsp;<%=car.getOpt()%></td>
                    <td class=title width=10%>���������</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%></td>
                </tr>	
    		  <%//}%>
    		  <%}%>
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
                    <%
			content_seq  = rent_mng_id+""+rent_l_cd+"115";
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                		
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					
                    %>    		
	<input type='hidden' name="file_name" value="<%=ht.get("FILE_NAME")%>">
                    <%		}%>
                    <%	}%>      
	
<%if(coe_bean.getCar_off_id().equals("03900") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null")){%>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 	
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
                    <td >&nbsp;<a href="javascript:view_car_pur_com('<%=pur_com.get("COM_CON_NO")%>');"><%=pur_com.get("COM_CON_NO")%></a><input type='hidden' name="com_con_no" value="<%=pur_com.get("COM_CON_NO")%>"></td>
                </tr>
                <tr> 
                    <td width=10% class=title>����</td>
                    <td >&nbsp;<%=pur_com.get("R_CAR_NM")%>
                        <%
                        	String pur_com_car_nm = AddUtil.replace(String.valueOf(pur_com.get("R_CAR_NM")),"&nbsp;"," ");
                        pur_com_car_nm = AddUtil.replace(pur_com_car_nm,"&#160;"," ");         
                    		String pur_cont_car_nm = cm_bean.getCar_nm()+" "+cm_bean.getCar_name();
                        	if(!pur_com_car_nm.equals(pur_cont_car_nm)){ %>
                        <font color=red>(Ư�ǹ����� �ִ� ����� ������ ������ �ٸ��ϴ�. Ȯ���Ͻʽÿ�.)</font>
                        <%} %>                        
                    </td>
                </tr>
                <tr> 
                    <td width=10% class=title>���û��</td>
                    <td >&nbsp;<%=pur_com.get("R_OPT")%>
                        <%if(!String.valueOf(pur_com.get("R_OPT")).equals(car.getOpt())){ %>
                        <font color=red>(Ư�ǹ����� �ִ� ���û��� ������ ���û���� �ٸ��ϴ�. Ȯ���Ͻʽÿ�.)</font>
                        <%} %>
                    </td>
                </tr>
                <tr> 
                    <td width=10% class=title>����</td>
                    <td >&nbsp;<%=pur_com.get("R_COLO")%>
                    	<%if(!String.valueOf(pur_com.get("R_COLO")).equals(car.getColo()+"/"+car.getIn_col()+"/"+car.getGarnish_col())){ %>
                        <font color=red>(Ư�ǹ����� �ִ� ����� ������ ������ �ٸ��ϴ�. Ȯ���Ͻʽÿ�.)</font>
                        <%} %>
                    </td>
                </tr>  
                <tr> 
                    <td width=10% class=title>����-�Һ��ڰ�</td>
                    <td >&nbsp;<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_C_AMT")))%>��
                    	<%
                    		int pur_com_amt  = AddUtil.parseInt(String.valueOf(pur_com.get("R_CAR_C_AMT")));
                    		int pur_cont_amt = car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt();
                    	 	if(pur_com_amt>pur_cont_amt || pur_com_amt<pur_cont_amt ){ %>
                        <font color=red>(Ư�ǹ����� �ִ� �Һ��ڰ��� ������ �Һ��ڰ��� �ٸ��ϴ�. Ȯ���Ͻʽÿ�.)</font>
                        <%	} %>
                    </td>
                </tr>    
                <tr> 
                    <td width=10% class=title>�����/�����</td>
                    <td >&nbsp;����� : <%=pur_com.get("DLV_EXT")%>&nbsp;&nbsp;&nbsp;
                    	����� : <%=pur_com.get("UDT_ST_NM")%>
                    	<!-- <font color=red>(Ư�ǹ����� �ִ� ������� �����(=�μ���)�� �������ּ���.)</font> -->
                    	<%if(!String.valueOf(pur_com.get("UDT_ST")).equals(pur.getUdt_st())){%>
                    	<br>&nbsp;
                    	<span style="font-size: 15px; font-weight:bold;"><font color=red>(Ư�ǹ����� �ִ� ������� ��� �μ����� �ٸ��ϴ�. ������Ƚ� ��� �μ����� Ư�ǿ� �ڵ�����˴ϴ�.)</font></span>
                    	<%} %>                       	                       
                    </td>
                </tr>              
            </table>
        </td>
    </tr> 
<%}else{%>    	

	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 
	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ÿ��ֹ���   &nbsp;<a href="javascript:view_scan()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a></span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>      
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=10%>�Ÿ��ֹ���</td>
                    <td>&nbsp;
                    <%
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					
                    %>
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
                    <%	}else{%>      
        	    <span class="b"><a href="javascript:scan_reg('15')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
        	    <%}%>
        			</td>
                </tr>	
    		</table>
	    </td>
	</tr>
	<%if(car_off_chk1+car_off_chk2 > 0){%>
    	<tr>
        	<td>&nbsp;</td>
    	</tr>	
    	<tr>
        	<td><font color=red>* ������� <%=emp2.getCar_off_nm()%>�� 
        	<%if(car_off_chk1 == 1){%>�ѽ���ȣ<%}%>
        	<%if(car_off_chk1+car_off_chk2 == 2){%>|<%}%>
        	<%if(car_off_chk2 == 1){%>����ڵ�Ϲ�ȣ<%}%>
        	�� �����ϴ�. ��������-�����Ұ������� �����Ͻʽÿ�.        	
        	</font></td>
    	</tr>	
    	<tr>
        	<td class=h></td>
    	</tr>	
    	<%}%>
    	<input type='hidden' name="com_con_no" value="">
<%}%>

	<%	
		//attach_vt_size = 1;
		
		if(attach_vt_size >0 || (coe_bean.getCar_off_id().equals("03900") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null"))){%>
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
                <tr>
                    <td class=title>����</td>
                    <td colspan="4">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                    <td colspan="2" class=title>���ӱ�</td>
                    <td colspan="4">&nbsp;<input type='text' name='auto' size='4' value='<%if(cm_bean.getAuto_yn().equals("Y")){%>A/T<%}else{%>M/T<%}%>' class='whitetext' ></td>
                </tr>	
                <tr>
                    <td class=title>�ɼ�</td>
                    <td colspan="10">&nbsp;<%=car.getOpt()%></td>
                    
                </tr>	                		
                <tr> 
                    <td class=title width=10%>���ۻ��</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%>
                      <%if(pur.getDir_pur_yn().equals("Y")){%>&nbsp;<b>[Ư�����]</b><%}%>
                    </td>
                    <td width=3% rowspan="2" class=title>��<br>��<br>��</td>
                    <td class=title width=7%>��ȣ</td>
                    <td width=15%>&nbsp;<%=emp2.getCar_off_nm()%>
                    	<input type='hidden' name="dlv_brch" value="<%=emp2.getCar_off_nm()%>">
                    	<%if(cm_bean.getCar_comp_id().equals("0003")){
                    		String dlv_mon = AddUtil.getDate(1)+""+AddUtil.getDate(2);
                    	%>
                    	  (������<%=d_db.getCarPurDlvBrchMonCnt(cm_bean.getCar_comp_id(), emp2.getCar_off_nm(), dlv_mon)%>��)
                    	<%}%>
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
        				<option value='<%=code.getNm()%>'><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0002")){
        					CodeBean[] p_codes = c_db.getCodeAll("0019");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>'><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0004")||emp2.getCar_comp_id().equals("0005")){
        					CodeBean[] p_codes = c_db.getCodeAll("0020");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>'><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0003")){
        					CodeBean[] p_codes = c_db.getCodeAll("0021");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">����</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>'><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			  <%}else{%>
        			  &nbsp;<input type='text' name='dlv_ext' size='15' value='' class='default' >
        			  <%}%>
        			</td>
                    <td width=3% rowspan="5" class=title>Ź<br>��</td>
                    <td width=7% class=title>����</td>
                    <td width=15%>
        			  &nbsp;<select name="cons_st" class='default' onchange="javascript:set_cons_amt();">
                        <option value="">==����==</option>
        				<option value="1" >���</option>
        				<option value="2" >��ü</option>							
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
                    <td>&nbsp;<input type='text' size='12' name='dlv_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>' <%if(pur.getDlv_est_dt().equals("")&&(!base.getDlv_dt().equals(""))){%>readonly<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  <input type='text' size='2' name='dlv_est_h' class='default' value='<%=String.valueOf(est.get("DLV_EST_H"))%>' <%if(pur.getDlv_est_dt().equals("")&&(!base.getDlv_dt().equals(""))){%>readonly<%}%>>��
        			  <!--<span class="b"><a href="javascript:dt_set()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">����</a></span>-->        			  
        			</td>
                    <td class=title>��ü��</td>
                    <td>&nbsp;<input type='text' name="off_nm" value='' size='10' class='default'>
        			  <input type='hidden' name='off_id' value=''>
    			    <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span></td>
                </tr>
                <tr>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;<%=car.getColo()%></td>
                    <td rowspan="2" class=title>��<br>��<br>��<br>��</td>
                    <td class=title>����</td>
                    <td>&nbsp;<%=coe_bean.getEmp_nm()%>
					<%if(pur.getOne_self().equals("Y")){%>&nbsp;<b>[��ü���]</b><%}else{%>[����������]<%}%>
										
					</td>
                    <td rowspan="2" class=title>��<br>��</td>
                    <td class=title>�μ���</td>
                    <td>
        			  &nbsp;<select name="udt_st" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getUdt_st().equals("1")){%> selected<%}%>>���ﺻ��</option>
        				<option value="2" <%if(pur.getUdt_st().equals("2")){%> selected<%}%>>�λ�����</option>
        				<option value="3" <%if(pur.getUdt_st().equals("3")){%> selected<%}%>>��������</option>				
        				<option value="5" <%if(pur.getUdt_st().equals("5")){%> selected<%}%>>�뱸����</option>
        				<option value="6" <%if(pur.getUdt_st().equals("6")){%> selected<%}%>>��������</option>				
        				<option value="4" <%if(pur.getUdt_st().equals("4")){%> selected<%}%>>��</option>
        			  </select>
        			</td>
                    <td class=title>Ź�۷�1</td>
                    <td>&nbsp;<input type='text' name='cons_amt1' maxlength='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��
                    <span class="b"><a href="javascript:search_off_amt()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  </td>
                </tr>
                <tr>
                    <td class=title>��ⷮ</td>
                    <td>&nbsp;<%=cm_bean.getDpm()%>cc</td>
                    <td class=title>����ó</td>
                    <td>&nbsp;<%=coe_bean.getEmp_m_tel()%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<input type='text' size='12' name='udt_est_dt' maxlength='12' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title>Ź�۷�2</td>
                    <td>&nbsp;<input type='text' name='cons_amt2' maxlength='10' value='0' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
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
                    <td>&nbsp;<input type='text' name='rent_ext' size='12' value='' class='default' >
        			  <span class="b"><a href="javascript:cng_rent_ext()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			</td>
                    <td class=title>�Ұ�</td>
                    <td>&nbsp;<input type='text' name='cons_amt3' maxlength='10' value='0' class='whitenum' size='10'>��</td>
                </tr>	
    		    <tr>
        		    <td class=title>�����ȣ</td>
        			<td>
                      &nbsp;<input type='text' name='car_num' maxlength='20' value='<%=pur.getCar_num()%>' class='default' size='20'></td>
        		    <td class=title>�����Ͻ�</td>
        		    <td>
        		      &nbsp;<input type='text' size='12' name='reg_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='reg_est_h' class='default' value='<%=String.valueOf(est.get("REG_EST_H"))%>'>
                    �� </td>
        		    <td class=title>�����Ͻ�</td>
        			<td>
        			  &nbsp;<input type='text' size='12' name='rent_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='rent_est_h' class='default' value='<%=String.valueOf(est.get("RENT_EST_H"))%>'>
                    �� </td>
                    <td colspan="2" class=title>�⺻Ź�۷�</td>
                    <td>&nbsp;
                    
                      <span class="b"><a href="javascript:search_base_consamt()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
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
                    <td width="10%" rowspan="2" class='title'>���� </td>
                    <td colspan="3" class='title'>�Һ��ڰ���</td>
                    <td width="10%" rowspan="2" class='title'>����</td>
                    <td colspan="3" class='title'>���԰���&nbsp;&nbsp;<a href="javascript:update_car_amt()"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a></td>
                </tr>
                <tr>
                    <td width="13%" class='title'>���ް�</td>
                    <td width="13%" class='title'>�ΰ���</td>
                    <td width="13%" class='title'>�հ�</td>
                    <td width="13%" class='title'>���ް�</td>
                    <td width="12%" class='title'>�ΰ���</td>
                    <td width="13%" class='title'>�հ�</td>
                </tr>
                <tr>
                    <td class='title'> �⺻����</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td class=title>��������</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                </tr>
                <tr>
                    <td height="12" class='title'>�ɼ�</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td class=title>Ź�۷�</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                </tr>
                <tr>
                    <td height="26" class='title'> ����</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			��</td>
                    <td class=title>����D/C<span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"></a></span></td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
        				��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
        				��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>'  maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
        				��</td>        				
                </tr>
              <tr id=tr_ecar_dc <%if(car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>���Ҽ� �����</td>
                <td align="center">&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
         			��</td>
                <td align="center">&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
         			��</td>
                <td align="center">&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
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
					<td class='title' width='34%'>����</td>					
					<td class='title' width='13%'>�Һ��ڰ����</td>										
					<td width="13%" class='title'>�뿩��ݿ�����</td>
				    <td width="13%" class='title'>�ݾ�</td>
			    </tr>
				<tr>
					<td align='center'>1</td>
					<td>&nbsp;
					  <select name='s_dc1_re' class='default'>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc1_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc1_re_etc' size='35' class="text" value='<%=car.getS_dc1_re_etc()%>'>
					<td align="center">  
					  <input type='text' name='s_dc1_per' size='4' class="text" value='<%=car.getS_dc1_per()%>' onBlur='javascript:setDc_per_amt(this, 1);'>%
					</td>
					<td align="center"><select name='s_dc1_yn' class='default'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc1_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc1_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc1_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc1_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setDc_per_amt(this, 1); set_dc_amt();'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>2</td>
					<td>&nbsp;
					  <select name='s_dc2_re' class='default'>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc2_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc2_re_etc' size='35' class="text" value='<%=car.getS_dc2_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc2_per' size='4' class="text" value='<%=car.getS_dc2_per()%>' onBlur='javascript:setDc_per_amt(this, 2);'>%
					</td>
					<td align="center"><select name='s_dc2_yn' class='default'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc2_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc2_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc2_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc2_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setDc_per_amt(this, 2); set_dc_amt();'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>3</td>
					<td>&nbsp;
					  <select name='s_dc3_re' class='default'>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc3_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc3_re_etc' size='35' class="text" value='<%=car.getS_dc3_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc3_per' size='4' class="text" value='<%=car.getS_dc3_per()%>' onBlur='javascript:setDc_per_amt(this, 3);'>%
					</td>
					<td align="center"><select name='s_dc3_yn' class='default'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc3_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc3_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc3_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc3_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setDc_per_amt(this, 3); set_dc_amt();'>
     					 ��</td>
			    </tr>
		    </table>
		</td>
	</tr>	
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
	    <td style='height:5'></td>
	</tr>	  
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� Ź�۱��� : [���]-�����縦 ���� Ź��(���Լ��ݰ�꼭�� Ź�۷� �ջ�), [����]-��翡�� Ź�۾�ü�� �Ƿ��ؼ� ��������� ������ Ź��</font> </td>
	</tr>		
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� Ź�۾�ü : Ź�۱����� ��ü�϶� Ź���Ƿ��ϴ� ��ü</font> </td>
	</tr>		
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� Ź�۷�1 : ��������� ���� ���� Ź�۷�(���Լ��ݰ�꼭�� ��õ� Ź�۷�)</font> </td>
	</tr>		
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� Ź�۷�2 : ��翡�� ������ ��ǰ�Ҷ� �߻��ϴ� Ź�۷�</font> </td>
	</tr>				
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� ��ǰ���� : ��ǰ�� ����/���� (�ѱ�25���̳�)</font> </td>
	</tr>				
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� ��ǰ�������� ���޿�ûó���Ϸ� ���� 2���� ��� �Ҽ� �����ϴ�. 2���� �ʰ��� ��� ���忡�� ���ΰ��縦 �����ʽÿ�.</font> </td>
	</tr>				
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
                    <td class=title width=10%>ǰ������</td>
                    <td>&nbsp;
                    <input type='text' name='doc_dt' size='15' value='<%=AddUtil.getDate()%>' class='whitetext'  onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title width=10%>�ӽÿ��ຸ���</td>
                    <%	//����Ʈ�ݾ� ������ �ݿ�
						if(pur.getTrf_amt5()==0 && b_ins_amt >0){
							pur.setTrf_amt5(b_ins_amt);
						} %>
                    <td colspan='3'>&nbsp;
                      <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    ��
                    <!--<input type="button" class="button" id="b_tmp_ins_amt" value='�����ػ� ����� ����' onclick="javascript:openHc();">-->
                    </td>
                </tr>					
                <tr> 
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;
                      <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_con_amt();'>
                    ��</td>
                    <td class=title width=10%>�ܾ�</td>
                    <td width="15%">&nbsp;
                      <input type='text' name='jan_amt' maxlength='15' value='0' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_con_amt();'>
                    ��</td>
                    <td width="10%" class=title>����ó����û��</td>
                    <td>&nbsp;
                    <input type='text' name='con_est_dt' size='15' value='' class='default'  onBlur='javscript:this.value = ChangeDate(this.value);'>					  
					  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;&nbsp;&nbsp;(����������:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <input type='hidden' name='con_pay_dt' value='<%=pur.getCon_pay_dt()%>'>					  
					  <%}else{%>						  
					  <%	if(pur.getCon_amt() >0 && cop_bean.getCon_amt() >0 &&  !cop_bean.getCon_pay_dt().equals("")){%>
					  &nbsp;&nbsp;&nbsp;&nbsp;(������࿬�� ����������:<%=cop_bean.getCon_pay_dt()%>)
					  <input type='hidden' name='con_pay_dt' value='<%=cop_bean.getCon_pay_dt()%>'>
					  <%	} %>				
					  <%} %>
					</td>                    
                </tr>			
                <%	
                	if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getTrf_st0().equals("") && !cop_bean.getCon_bank().equals("")){
                		pur.setTrf_st0		(cop_bean.getTrf_st0());
                		pur.setAcc_st0		(cop_bean.getAcc_st0());
                		pur.setCon_bank		(cop_bean.getCon_bank());
                		pur.setCon_acc_no	(cop_bean.getCon_acc_no());
                		pur.setCon_acc_nm	(cop_bean.getCon_acc_nm());
                		pur.setCon_est_dt	(cop_bean.getCon_est_dt());
                	}
                	if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getTrf_st0().equals("") && pur.getCon_bank().indexOf("����") == 0){
                		//�����ڵ���,����ڵ���,�Ｚ�ڵ��� ī����� ����
                		if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002") || emp2.getCar_comp_id().equals("0003")){
                			//20220914 �����ѽŴ�븮��, ��������ͽ��� �켱 ī�� ����Ʈ ó��
                			if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){
	                			pur.setTrf_st0("3");
                			}else{
                   				pur.setTrf_st0("1");
                   			}	
                		}	
                	}
                	if(pur.getTrf_amt5() > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_st5().equals("")){
                		//20220916 �����ѽŴ�븮���� �켱 ī�� ����Ʈ ó��
               			if(emp2.getCar_off_id().equals("00588")){
                			pur.setTrf_st5("3");
               			}else{
               				pur.setTrf_st5("1");
               			}
                	}
                %>
				<tr>
				  <td class=title width=10%>�������޼���</td>
                    <td colspan='5'>&nbsp;
                      ���޼��� :
                     <select name="trf_st0" class='default'>
                        <option value="">==����==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>ī��</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>����</option>        				        				
        			  </select> 
        			  &nbsp;
                      ī��/������ : 
					  <select name='con_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                        <%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>' <%if(pur.getCon_bank().equals(String.valueOf(ht.get("CARD_KIND")))) out.println("selected");%>><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
                    </select>
                    &nbsp;
				  	�������� :
				  	<select name="acc_st0" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>�������</option>
        			  </select>
				  	&nbsp;
					ī��/���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					����/������ : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
                    </td>
				</tr>
				<tr>
				  <td class=title width=10%>Ư�̻���</td>
                    <td colspan='5'>&nbsp;
					  <textarea name="con_amt_cont" cols="100" rows="3" class="default"></textarea>
                    </td>
				</tr>
				<tr>
					<td class=title width=10%>�ӽÿ��ຸ���<br/>������</td><!-- 2018.04.20 -->
					<%
					int attach_vt_26_size=0;
					attach_vt_26 = c_db.getAcarAttachFileListEqual(content_code, content_seq_26, 0);
                	attach_vt_26_size = attach_vt_26.size();
					%>
                    <td colspan='5'>&nbsp;
					  <%
					  	if(attach_vt_26_size > 0){
					  		for(int k=0; k<attach_vt_26_size; k++){
					  			Hashtable ht = (Hashtable)attach_vt_26.elementAt(k);
					  			%>
					  				<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>&nbsp;
					  			<%
					  		}
					  	}else{
					  		%>
<span class="b"><a href="javascript:scan_reg('26')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
					  		<%
					  	}
					  %>
                    </td>
				</tr>
    		</table>
	    </td>
	</tr> 	
	<tr>
	    <td><font color=#666666>&nbsp;�� ���� : ������ҿ� ���޵� ����</font> </td>
	</tr>
	<tr>
	    <td><font color=#666666>&nbsp;�� �������� : ���� �� �������� ������ü�� ��������� ������������Դϴ�. ���θ��� ���´� ����Ҽ� �����ϴ�.</font> </td>
	</tr>
	<tr>
	    <td><font color=#666666>&nbsp;�� �������� : ������ҿ� Ȯ���Ͽ� <font color=red>���� ������� ����</font>�� �Է��Ͻʽÿ�. </font> ���� �̷����� �ִ� ���´� ���� ������� ���� ���� �ֽ��ϴ�. </td>
	</tr>
	<tr>
	    <td><font color=#666666>&nbsp;�� Ư�̻��� : ���� ���� ������ ���, ������ ����� ������ �°� ��� Ư�̻����� �Է��ϼ���</font> </td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǰ��û����</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
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
        			  <input type='radio' name="com_tint" value='' <%if(!emp2.getCar_comp_id().equals("0001") && !emp2.getCar_comp_id().equals("0002")){%>checked<%}else{%>checked onClick="javascript:cng_com_tint(0)"<%}%>>
                                  ����
				  <%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
                                  <input type='radio' name="com_tint" value='1' checked onClick="javascript:cng_com_tint(1)">
                                  ����+�������̰�
                                  <input type='radio' name="com_tint" value='2' onClick="javascript:cng_com_tint(2)">
                                  �귣��ŰƮ
				  <%}%>
		    </td>
                    <td width="10%" class=title>������ ����</td>
                    <td width="40%">&nbsp;
        			  <input type='radio' name="com_film_st" value='' <%if(!emp2.getCar_comp_id().equals("0001") && !emp2.getCar_comp_id().equals("0002")){%>checked<%}else{%>checked onClick="javascript:cng_com_film_st(0)"<%}%>>
	       			  ����
				  <%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>	
                                  <input type='radio' name="com_film_st" value='1' checked onClick="javascript:cng_com_film_st(1)">       				  
                                  �縶 (����/���)
        			  <input type='radio' name="com_film_st" value='2' onClick="javascript:cng_com_film_st(2)">
        			  ��� (����)
				  <input type='radio' name="com_film_st" value='3' onClick="javascript:cng_com_film_st(3)">
        			  SKC (���)
        			  <input type='radio' name="com_film_st" value='4' onClick="javascript:cng_com_film_st(4)">
        			  3M (����/���)
				  <%}%>	
        	    </td>					  
                </tr>		
    		</table>
	    </td>
	</tr> 	
	<tr>
	    <td> <span class=style2>����(���ĸ�/����)</span>
            <%if((tint1.getTint_yn().equals("Y") || tint1.getTint_yn().equals("")) && tint1.getReq_dt().equals("") && tint1.getConf_dt().equals("") && tint1.getPay_dt().equals("") && tint1.getDoc_code().equals("")){%>
            <%if(base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)){%>
                &nbsp;<a href="javascript:tint_update('1')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
            <%}%>
            <%if(tint1.getTint_yn().equals("N") && (tint2.getTint_yn().equals("Y") || tint2.getTint_yn().equals("")) && tint2.getReq_dt().equals("") && tint2.getConf_dt().equals("") && tint2.getPay_dt().equals("") && tint2.getDoc_code().equals("")){%>
            <%if(base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)){%>
                &nbsp;<a href="javascript:tint_update('1')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
            <%}%>      	  	    
	    </td>
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
	    <td> <span class=style2>���ڽ� </span>
			
            	<%if(base.getReg_id().equals(user_id) || base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) ){%>
					<%if(base.getCar_gu().equals("1") && (car.getOpt().contains("��Ʈ�� ķ")||car.getOpt().contains("��Ʈ��ķ"))){ %><!-- 20190522 -->
						- ��Ʈ��ķ�� ���Ե� �����Դϴ�. <!-- ��ó�ȭ�� �ʿ�� �ϴ� ���� ��û�� �ִ� ��쿡�� ��Ÿ��ǰ�� ����ϼ��� -->
					<%}else{ %>
	                	&nbsp;<a href="javascript:tint_update('3')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
					<%} %>
				<%}%>
            <%-- <%}%> --%>
	    </td>
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
	    <td> <span class=style2>������̼� </span>
            <%if(tint4.getReq_dt().equals("") && tint4.getConf_dt().equals("") && tint4.getPay_dt().equals("") && tint4.getDoc_code().equals("")){%>
            <%if(base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)){%>
                &nbsp;<a href="javascript:tint_update('4')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
            <%}%>	    
	    </td>
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
	    <td> <span class=style2>��Ÿ��ǰ</span>
            <%if(tint5.getReq_dt().equals("") && tint5.getConf_dt().equals("") && tint5.getPay_dt().equals("") && tint5.getDoc_code().equals("")){%>
            <%if(base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)){%>
                &nbsp;<a href="javascript:tint_update('5')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
            <%}%>	    
	    </td>
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
	    <td> <span class=style2>�̵��� ������</span>
	    	
	    </td>
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
                        <%=tint6.getCom_nm()%>&nbsp;<%=tint6.getModel_nm()%></td>
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
	<tr>
	    <td style='height:5'></td>
	</tr>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� ��ǰ��û : ������-��ǰ���� �Ƿ� ��� �� �� �ֽ��ϴ�	    
        <%if(car.getTint_b_yn().equals("Y") && tint3.getTint_no().equals("")){%><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����ݿ���ǰ�� 2ä�� ���ڽ��� ������ ��ǰ ��ϵ��� �ʾҽ��ϴ�.<%}%>
        <%if((car.getTint_s_yn().equals("Y")||car.getTint_ps_yn().equals("Y")) && tint2.getTint_no().equals("")){%><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����ݿ���ǰ�� ���� ������ ������ ��ǰ ��ϵ��� �ʾҽ��ϴ�.<%}%>
        <%if(car.getTint_n_yn().equals("Y") && tint4.getTint_no().equals("")){%><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����ݿ���ǰ�� ��ġ�� ������̼��� ������ ��ǰ ��ϵ��� �ʾҽ��ϴ�.<%}%>
        <%if(car.getTint_eb_yn().equals("Y") && tint6.getTint_no().equals("")){%><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����ݿ���ǰ�� �̵��� �����Ⱑ ������ ��ǰ ��ϵ��� �ʾҽ��ϴ�.<%}%>
	    </font></td>
	</tr>				
	<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� ����/����� ��ǰ���� : �� �縶���� �Ǵ� ��񽺽��� + �ؼ���������� �� �귣��ŰƮ(Ʈ��ũ������+�������̽�+���Ʈ������+������ɷ�+�ν��ɷ�+��������+��Ƽ���+������)</font> </td>
	</tr>	
	<%}%>
	<tr>
	    <td></td>
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
    		  <%Hashtable ext0 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, "1", "0");
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
        		      <input type='text' size='11' name='pp_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
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
                              <option value="1" <%if(fee.getGrt_suc_yn().equals("1")||fee.getGrt_suc_yn().equals(""))%>selected<%%>>����</option>
                            </select>	
					  &nbsp;
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;����ȣ : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;���������� : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum' readonly>��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  ���������ݽ°� : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum' >��
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(���������� ���� <%=AddUtil.parseDecimal(fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  <%} %>					  
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>			  
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
                    <td width=15%>&nbsp;<input type='text' size='11' name='gi_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(gins.getGi_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
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
                    <td width=15%>&nbsp;<%if(cont_etc.getClient_guar_st().equals("1")){%>����<%}else if(cont_etc.getClient_guar_st().equals("2")){%>����<%}%></td>
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
                    <td width=15%>
        			  &nbsp;<select name='guar_end_st' class='default'>
                        <option value="">����</option>
                        <option value="1" <%if(cont_etc.getGuar_end_st().equals("1") || scan_cnt > 0){%>selected<%}%>>�̰�</option>
                        <option value="2" <%if(cont_etc.getGuar_end_st().equals("2") || scan_cnt ==0){%>selected<%}%>>�ϰ�</option>
                      </select>			
        			  &nbsp;<span class="b"><a href="javascript:view_scan()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0></a></span>
        			</td>
                    <td class=title width=10%>�̰����</td>
                    <td colspan="3">&nbsp;<input type='text' name='guar_etc' size='40' value='<%=cont_etc.getGuar_etc()%>' class='default'></td>
                    <td class=title width=10%>�ϰΌ����</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='guar_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(cont_etc.getGuar_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        	    </tr>	
        		  <%}else{%>
        		  <input type='hidden' name='guar_end_st' value='2'>
        		  <%}%>		
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td><font color=#666666>&nbsp;�� ó�������� �̰��϶� �̰������ �ϰΌ������ �־� �ֽʽÿ�. </font> </td>
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
                         ��26���̻�
                      <%}else if(driving_age.equals("3")){%>
                         ��24���̻�
                      <%}else if(driving_age.equals("1")){%>
                         ��21���̻�
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
                       <%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5õ����<%}else if(gcp_kd.equals("2")){%>1���<%}else if(gcp_kd.equals("3")){%>5���<%}else if(gcp_kd.equals("4")){%>2���<%}else if(gcp_kd.equals("8")){%>3���<%}%></td>
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
	    <td align='center'>
	    	  <%if(base.getCar_st().equals("1")||base.getCar_st().equals("3")){%>
	    	  <%	if(fee.getCon_mon().equals("") || car.getCar_fs_amt() ==0){%>
	    	  &nbsp;�� �������� �뿩������ �������԰����� �Էµ��� �ʾҽ��ϴ�. ������� ���� �Ϸ��Ͻʽÿ�.
	    	  <%	}else{%>
	        <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
	        <%	}%>
	        <%}else{%>
	        <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>	        
	        <%}%>
	    </td>
	</tr>	
	<%}else{%>
	<tr>
	    <td align="right">&nbsp;</td>
	<tr>	
	<tr>
	    <td>&nbsp;�� �Ÿ��ֹ��� ��ĵ�� �ʼ��Դϴ�. �켱 ������ֽʽÿ�. ����� <span class="b"><a href="javascript:location.reload()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_reload.gif align=absmiddle border=0></a></span>�� ���ּ���.</td>
	</tr>	
	<tr>
	    <td>&nbsp;�� �Ÿ��ֹ��� ��ĵ�� �Ϸ�Ǹ� �����ܰ�� �Ѿ�ϴ�.</td>
	</tr>	
	<tr>
	    <td>&nbsp;�� �Ÿ��ֹ��� ��ĵ ���� ��� ����Ͽ� ��� ���簡 �����Ǵ����� �߻��� ���� ���� �����մϴ�.</td>
	</tr>	
	<%}%>			
</table>
</form>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	
	if(fm.auto.value == 'M/T' && fm.car_b.value.indexOf('�ڵ����ӱ�') != -1){
		fm.auto.value = 'A/T';
	}	
	if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('���ӱ�') != -1){
		fm.auto.value = 'A/T';
	}
	if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('DCT') != -1){
		fm.auto.value = 'A/T';
	}
	if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('C-TECH') != -1){
		fm.auto.value = 'A/T';
	}		
	if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('A/T') != -1){
		fm.auto.value = 'A/T';
	}	
	if(fm.auto.value == 'M/T' && fm.car_b.value.indexOf('���� ���ӱ�') != -1){
		fm.auto.value = 'A/T';
	}	
			
	
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	<%if(attach_vt_size >0 || (coe_bean.getCar_off_id().equals("03900") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null"))){%>	
	set_cons_amt();
	sum_car_c_amt();
	sum_car_f_amt();
	set_con_amt();
	
		
	
	if(fm.com_con_no.value != ''){
		fm.rpt_no.value		= '<%=pur_com.get("COM_CON_NO")%>';			
		//fm.dlv_est_dt.value	= '<%=pur_com.get("DLV_CON_DT")%>';			
		fm.dlv_ext.value 	= '<%=pur_com.get("DLV_EXT")%>';
		//fm.udt_st.value 	= '<%=pur_com.get("UDT_ST")%>';
		//fm.cons_amt1.value 	= parseDecimal(<%=pur_com.get("CONS_AMT")%>);
		//fm.cons_amt3.value 	= parseDecimal(<%=pur_com.get("CONS_AMT")%>);
		//set_cons_amt();
		fm.s_dc1_re.value 	= '�Ǹ�����������';
		fm.s_dc1_re_etc.value 	= 'Ư��DC';
		fm.s_dc1_amt.value 	= parseDecimal(<%=pur_com.get("DC_AMT")%>);
		fm.s_dc1_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc1_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
		//fm.s_dc1_yn.value 	= 'Y';	
		set_dc_amt();	
		if('<%=pur_com.get("CAR_OFF_ID")%>'=='03900' && <%=pur_com.get("ADD_DC_AMT")%> >0 ){
			fm.s_dc2_re.value 	= '����ƮDC';
			fm.s_dc2_re_etc.value 	= '�����������Ʈ';
			fm.s_dc2_amt.value 	= parseDecimal(<%=pur_com.get("ADD_DC_AMT")%>);
			fm.s_dc2_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc2_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			set_dc_amt();	
		}	
		if(fm.udt_st.value != '<%=pur_com.get("UDT_ST")%>'){
			alert('Ư�ǹ������� ������� �μ����� �ٸ��ϴ�. �����ϼ���.');
		}
	}	
	
	if(toInt(parseDigit(fm.s_dc1_amt.value)) > 0 && toFloat(fm.s_dc1_per.value) == 0.0){
		fm.s_dc1_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc1_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
	}
	if(toInt(parseDigit(fm.s_dc2_amt.value)) > 0 && toFloat(fm.s_dc2_per.value) == 0.0){
		fm.s_dc2_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc2_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
	}
	if(toInt(parseDigit(fm.s_dc3_amt.value)) > 0 && toFloat(fm.s_dc3_per.value) == 0.0){
		fm.s_dc3_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc3_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
	}
	
	<%}%>
	

	
		
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

