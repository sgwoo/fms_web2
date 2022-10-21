<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, acar.fee.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//Ư�ǰ������
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);		
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String o_3 		= edb.getEstiSikVarCase("1", "", "o_3");
	
	
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
	function view_client(client_id)
	{
		window.open("/agent/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site(client_id, site_id)
	{
		window.open("/agent/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=100, width=850, height=700, scrollbars=yes");
	}		

	
	//��ó�� ���� �ڵ��� ������ ����ϱ�
	function GetCarCompe(){
		var fm = document.form1;
		var fm2 = document.form2;
		var car_origin = fm.car_origin.options[fm.car_origin.selectedIndex].value;
		
		if(car_origin == ''){ alert('��ó�� �����Ͻʽÿ�.'); return; }
		
		if(car_origin != '<%=car.getCar_origin()%>'){
			fm.code.value = '';
			fm.car_name.value = '';
			fm.car_id.value = '';
			fm.car_seq.value = '';
			fm.car_s_amt.value = '';
			fm.car_v_amt.value = '';
			fm.car_amt.value = '';			
			fm.opt.value = '';
			fm.opt_seq.value = '';			
			fm.opt_s_amt.value = '';
			fm.opt_v_amt.value = '';
			fm.opt_amt.value = '';			
			fm.col.value = '';
			fm.col_seq.value = '';			
			fm.col_s_amt.value = '';
			fm.col_v_amt.value = '';
			fm.col_amt.value = '';		
			fm.o_1_s_amt.value = '';
			fm.o_1_v_amt.value = '';
			fm.o_1.value = '';						
		}
		
		fm2.car_origin.value = car_origin;	
		te = fm.car_comp_id;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.car_comp_id";
		fm2.mode.value = '0';
		fm2.target="i_no";
		fm2.submit();		
	}
	
	//�ڵ���ȸ�� ���ý� �����ڵ� ����ϱ�
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		var car_comp_id = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
		
		if(car_comp_id == ''){ alert('�ڵ��� ����ȸ�縦 �����Ͻʽÿ�.'); return; }
		
		if(car_comp_id != '<%=cm_bean.getCar_comp_id()%>'){
			fm.car_name.value = '';
			fm.car_id.value = '';
			fm.car_seq.value = '';
			fm.car_s_amt.value = '';
			fm.car_v_amt.value = '';
			fm.car_amt.value = '';			
			fm.opt.value = '';
			fm.opt_seq.value = '';			
			fm.opt_s_amt.value = '';
			fm.opt_v_amt.value = '';
			fm.opt_amt.value = '';			
			fm.col.value = '';
			fm.col_seq.value = '';			
			fm.col_s_amt.value = '';
			fm.col_v_amt.value = '';
			fm.col_amt.value = '';		
			fm.o_1_s_amt.value = '';
			fm.o_1_v_amt.value = '';
			fm.o_1.value = '';						
		}
				
		//fm.con_cd3.value = car_comp_id.substring(0,1);
		//fm.con_cd4.value = '';
		fm2.car_comp_id.value = car_comp_id.substring(1);
		//alert(car_comp_id);
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.code";
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	//�����ڵ� ���ý� ����ڵ� ����ϱ�
	function GetCarCd(){
		var fm = document.form1;	
		var code = fm.code.options[fm.code.selectedIndex].text;
		
		if(code == ''){ alert('������ �����Ͻʽÿ�.'); return; }
		
		if(fm.code.options[fm.code.selectedIndex].value != '<%=cm_bean.getCode()%>'){
			fm.car_name.value = '';
			fm.car_id.value = '';
			fm.car_seq.value = '';
			fm.car_s_amt.value = '';
			fm.car_v_amt.value = '';
			fm.car_amt.value = '';					
			fm.opt.value = '';
			fm.opt_seq.value = '';			
			fm.opt_s_amt.value = '';
			fm.opt_v_amt.value = '';
			fm.opt_amt.value = '';			
			fm.col.value = '';
			fm.col_seq.value = '';			
			fm.col_s_amt.value = '';
			fm.col_v_amt.value = '';
			fm.col_amt.value = '';		
			fm.o_1_s_amt.value = '';
			fm.o_1_v_amt.value = '';
			fm.o_1.value = '';						
		}		
		fm.con_cd4.value = code.substring(1,3);
	}
	
	//���θ���Ʈ
	function sub_list(idx){
		var fm = document.form1;
		var garnish_yn_opt_st = fm.garnish_yn_opt_st.value;
		var hook_yn_opt_st = fm.hook_yn_opt_st.value;
		var SUBWIN="search_esti_sub_list.jsp?from_page=/agent/lc_rent/lc_cng_car_frame.jsp&idx="+idx+"&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.car_nm.value+"&garnish_yn_opt_st="+garnish_yn_opt_st+"&hook_yn_opt_st="+hook_yn_opt_st;	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=650, height=500, scrollbars=yes, status=yes");
	}
		

	function save(){
		var fm = document.form1;
		
		fm.car_cs_amt.value = fm.car_s_amt.value;
		fm.car_cv_amt.value = fm.car_v_amt.value;
		fm.car_c_amt.value 	= fm.car_amt.value;		
		
		fm.opt_cs_amt.value = fm.opt_s_amt.value;
		fm.opt_cv_amt.value = fm.opt_v_amt.value;
		fm.opt_c_amt.value 	= fm.opt_amt.value;		
		
		fm.col_cs_amt.value = fm.col_s_amt.value;
		fm.col_cv_amt.value = fm.col_v_amt.value;
		fm.col_c_amt.value 	= fm.col_amt.value;		
		
		if (fm.garnish_yn_opt_st.value == "Y") {
			if(fm.garnish_col.value == "") {
				alert("���Ͻ� �ɼ��� ���ԵǾ� �ֽ��ϴ�. ���Ͻ� ������ �������ּ���.");
				return;
			}
		}
		
		if(fm.car_origin.value == '')	{ 	alert('��ó�� Ȯ���Ͻʽÿ�.'); 			return;	}		
		if(fm.purc_gu.value == '')		{	alert("���������� �����Ͻʽÿ�."); 		return; }		
		
		sum_dc_amt();
		sum_tax_amt();
		sum_car_c_amt();
		sum_car_f_amt();
		
		if(toInt(fm.commi_car_amt.value)>0){
			fm.commi_car_amt.value = fm.tot_c_amt.value;
			var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));
			var comm_r_rt 	= toFloat(fm.comm_r_rt.value);		
			fm.commi.value = parseDecimal(th_round(car_price*comm_r_rt/100));
		}
		
		//20151116 ������ ��� �������ӱ� Ȯ��
		if(<%=base.getCar_gu()%> == '1'){
			var auto = 'M/T';
			
			if(fm.auto_yn.value == 'Y') auto = 'A/T';
			
			if(auto == 'M/T' && fm.car_b.value.indexOf('�ڵ����ӱ�') != -1){
				auto = 'A/T';
			}
			if(auto == 'M/T' && fm.opt.value.indexOf('���ӱ�') != -1){
				auto = 'A/T';
			}
			if(auto == 'M/T' && fm.opt.value.indexOf('DCT') != -1){
				auto = 'A/T';
			}
			if(auto == 'M/T' && fm.opt.value.indexOf('C-TECH') != -1){
				auto = 'A/T';
			}				
			if(auto == 'M/T' && fm.opt.value.indexOf('A/T') != -1){
				auto = 'A/T';
			}	
			if(auto == 'M/T' && fm.car_b.value.indexOf('���� ���ӱ�') != -1){
				auto = 'A/T';
			}
			
			
			if(auto == 'M/T'){
				if(!confirm('�������ӱ� �����Դϴ�. �����Ͻðڽ��ϱ�?')){			
					return;
				}
			}
			
			if(fm.pur_color.value != ''){
				alert('Ư�ǹ������� ��Ϻ��Դϴ�. ����,�ɼ�,������ ������ ��� ���¾�ü����-��ü���������� ��ຯ�� ó���Ͻʽÿ�.');
			}

		}				
		
		if(confirm('�����Ͻðڽ��ϱ�?')){					
			fm.action='lc_cng_new_car_c_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}		

	}
	
	function sum_dc_amt()
	{
		var fm = document.form1;
		fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_dc1_amt.value)) + toInt(parseDigit(fm.s_dc2_amt.value)) + toInt(parseDigit(fm.s_dc3_amt.value)) );		
		fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_c_amt.value))));
		fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));
	}
	
	//���� Ư�Ҽ� �հ�
	function sum_tax_amt(){
		var fm = document.form1;
		
		if(toInt(parseDigit(fm.spe_tax.value)) >  0){	return; }
		
		if(toInt(parseDigit(fm.car_f_amt.value)) == 0){	sum_car_f_amt(); }
		
		var purc_gu 	= fm.purc_gu.value;		
		var car_st 		= '<%=base.getCar_st()%>';
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_c_price = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));		
		var car_f_price = toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		
		var a_e = toInt(s_st);
		var o_1 = car_c_price;
		//������ Ư�Ҽ���
		var o_2 = <%=ej_bean.getJg_3()%>;	
	
		<%	if(base.getDlv_dt().equals("")){%>
		<%		if(cr_bean.getInit_reg_dt().equals("")){%>
				if(<%=AddUtil.getDate(4)%> >= 20081219 && <%=AddUtil.getDate(4)%> < 20090630) o_2 = o_2*0.7;				
		<%		}else{%>
				if(<%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> >= 20081219 && <%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> < 20090630) o_2 = o_2*0.7;							
		<%		}%>
		<%	}else{%>
			if(<%=base.getDlv_dt()%> >= 20081219 && <%=base.getDlv_dt()%> < 20090630) o_2 = o_2*0.7;				
		<%	}%>
				
		//Ư�Ҽ��������� o_3 = o_1/(1+o_2), ��������/(1+Ư�Ҽ���);
		var o_3 = Math.round(<%=o_3%>);		
		
		if(purc_gu == '1'){//����1
			fm.spe_tax.value = parseDecimal(car_c_price-o_3);
			fm.pay_st.value = '1';
		}else{//����2(�鼼)	 	
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>' == '5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
				fm.spe_tax.value = parseDecimal(Math.round(o_1*o_2));
			}else{
				fm.spe_tax.value = parseDecimal(car_c_price-toInt(parseDigit(fm.car_f_amt.value)));
			}				
			fm.pay_st.value = '2';
		}
		fm.edu_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value))*(30/100));		
		fm.tot_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );			
	}
	
	//���� �Һ��ڰ� �հ�
	function sum_car_c_amt(){
		var fm = document.form1;		
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
	}
	
	//���� ���԰� �հ�
	function sum_car_f_amt(){
		var fm = document.form1;
		
		var purc_gu 	= fm.purc_gu.value;		
		var car_st 		= '<%=base.getCar_st()%>';
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));

		if(fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0'){
			fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_c_amt.value))));
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));			
		}

			if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }		
			if(purc_gu == '1'){//����1
				fm.car_fs_amt.value = fm.tot_cs_amt.value;
				fm.car_fv_amt.value = fm.tot_cv_amt.value;
				fm.car_f_amt.value 	= fm.tot_c_amt.value;
			}else{//����2(�鼼)
				if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>' == '5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
					fm.car_fs_amt.value = fm.tot_cs_amt.value;
					fm.car_fv_amt.value = fm.tot_cv_amt.value;
					fm.car_f_amt.value 	= fm.tot_c_amt.value;
				}else{
					var a_e = toInt(s_st);
					var o_1 = car_price;
					//������ Ư�Ҽ���
					var o_2 = <%=ej_bean.getJg_3()%>;		
					<%	if(base.getDlv_dt().equals("")){%>
					<%		if(cr_bean.getInit_reg_dt().equals("")){%>
							if(<%=AddUtil.getDate(4)%> >= 20081219 && <%=AddUtil.getDate(4)%> < 20090630) o_2 = o_2*0.7;				
					<%		}else{%>
							if(<%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> >= 20081219 && <%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> < 20090630) o_2 = o_2*0.7;							
					<%		}%>
					<%	}else{%>
						if(<%=base.getDlv_dt()%> >= 20081219 && <%=base.getDlv_dt()%> < 20090630) o_2 = o_2*0.7;				
					<%	}%>
						
					//Ư�Ҽ��������� o_3 = o_1/(1+o_2), ��������/(1+Ư�Ҽ���);
					var o_3 = Math.round(<%=o_3%>);
					fm.car_f_amt.value 	= parseDecimal(o_3);
					fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
					fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));			
				}				
			}
		
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							
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
<form action="get_car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_origin" value="">
  <input type="hidden" name="car_comp_id" value="">  
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">    
  <input type="hidden" name="t_wd" value="">      
  <input type="hidden" name="auth_rw" value="">
  <input type="hidden" name="mode" value="">
</form>
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 				value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 				value="<%=rent_l_cd%>">  
  <input type='hidden' name="from_page" 		value="/agent/lc_rent/lc_cng_car_frame.jsp">
  
  <input type="hidden" name="idx"         		value="reset_car">
  <input type='hidden' name='o_1_s_amt' 		value=''>
  <input type='hidden' name='o_1_v_amt' 		value=''>
  <input type='hidden' name='s_st' 				value='<%=cm_bean.getS_st()%>'>
  <input type='hidden' name='dpm' 				value='<%=cm_bean.getDpm()%>'>
  
  <!--�������-->
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
  <input type="hidden" name="pay_st"			value="<%=car.getPay_st()%>">
  <input type="hidden" name="tot_cs_amt"   		value="">
  <input type="hidden" name="tot_cv_amt"   		value="">
  <input type="hidden" name="tot_c_amt"   		value="">
  <input type="hidden" name="tot_fs_amt"   		value="">
  <input type="hidden" name="tot_fv_amt"   		value="">
  <input type="hidden" name="tot_f_amt"   		value="">
  <input type="hidden" name="commi_car_amt"		value="<%=emp1.getCommi_car_amt()%>">
  <input type="hidden" name="comm_r_rt"			value="<%=emp1.getComm_r_rt()%>">
  <input type="hidden" name="comm_rt"			value="<%=emp1.getComm_rt()%>">
  <input type="hidden" name="commi"				value="<%=emp1.getCommi()%>">
  <input type='hidden' name="jg_opt_st"			value="<%=car.getJg_opt_st()%>">
  <input type='hidden' name="jg_col_st"			value="<%=car.getJg_col_st()%>">
  <input type='hidden' name="jg_tuix_st"			value="<%=car.getJg_tuix_st()%>">
  <input type='hidden' name="jg_tuix_opt_st"			value="<%=car.getJg_tuix_opt_st()%>">
  <input type="hidden" name="lkas_yn" value="<%=cm_bean.getLkas_yn()%>">
  <input type="hidden" name="lkas_yn_opt_st" value="">
  <input type="hidden" name="ldws_yn" value="<%=cm_bean.getLdws_yn()%>">
  <input type="hidden" name="ldws_yn_opt_st" value="">
  <input type="hidden" name="aeb_yn" value="<%=cm_bean.getAeb_yn()%>">
  <input type="hidden" name="aeb_yn_opt_st" value="">
  <input type="hidden" name="fcw_yn" value="<%=cm_bean.getFcw_yn()%>">
  <input type="hidden" name="fcw_yn_opt_st" value="">  
  <input type="hidden" name="garnish_yn" value="">				<!-- ���Ͻ� ���� -->
  <input type="hidden" name="garnish_yn_opt_st" value="">	<!-- ���Ͻ� ����(�ɼ�) -->
  <input type="hidden" name="hook_yn" value="">				<!-- ���ΰ� ���� -->
  <input type="hidden" name="hook_yn_opt_st" value="">	<!-- ���ΰ� ����(�ɼ�) -->
    
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
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
                    <td>&nbsp;<b><%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></b></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
                </tr>
                <tr>
                    <td class=title>��ȣ</td>
                    <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a></td>
                    <td class=title>��ǥ��</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>����/����</td>
                    <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=site.getR_site()%></a></td>
                </tr>
                <tr>
                    <td class=title>������ȣ</td>
                    <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title width=10%>����</td>
                    <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(�����ڵ�:<%=cm_bean.getJg_code()%>)</font>
        			</td>
                </tr>		  
            </table>
	    </td>
    </tr>
	<tr>
        <td></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan="2" class='title'>�׸�</td>
                    <td width="70%" class='title'>����</td>
                    <td width="17%" class='title'>�ݾ�</td>
                </tr>
                <tr id=td_con_cd style='display:none'> 
                    <td colspan='2' class='title'>���� ����ȣ</td>
                    <td><table width="100%" border="0" cellpadding="0">
                        <tr>
                          <td>&nbsp;
						  	<input type='text' class='fix' name='con_cd3' size='1' value='' readonly>
                      		-
                      		<input type='text' class='fix' name='con_cd4' size='2' value='' readonly>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>				
                <tr> 
                    <td width="3%" rowspan="7" class='title'>��<br>
                    ��<br>��</td>
                    <td width="10%" class='title'>��ó</td>
                    <td><table width="100%" border="0" cellpadding="0">
                        <tr>
                          <td>&nbsp;
                          	<!--
                            <select name="car_origin" onChange="javascript:GetCarCompe()" class='default'>
                              <option value="">����</option>
                              <option value="1" <%if(car.getCar_origin().equals("1"))%>selected<%%>>����</option>
                              <option value="2" <%if(car.getCar_origin().equals("2"))%>selected<%%>>����</option>
                            </select>-->
                            <%if(car.getCar_origin().equals("1")){%>����<%}%>
                            <%if(car.getCar_origin().equals("2")){%>����<%}%>
                            <input type="hidden" name="car_origin" value="<%=car.getCar_origin()%>">
                            </td>
                        </tr>
                      </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>����ȸ��</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td>&nbsp;                                	
                          		<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%>
                          	<input type="hidden" name="car_comp_id" value="<%=cm_bean.getCar_comp_id()%>">	
            				    </td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td>&nbsp;                                     	
                              		<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>
                          	<input type="hidden" name="code" value="<%=cm_bean.getCode()%>">	
                          	<input type="hidden" name="car_nm" value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">	
            					</td>
                            </tr>
                        </table> 
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7%>&nbsp;                    
            					    <a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
            				    </td>
                                <td>&nbsp;
                				  	<input type='text' name="car_name" size='60' class='fix' value="<%=cm_bean.getCar_name()%>" readonly>
			  						<input type='hidden' name='car_id' value='<%=cm_bean.getCar_id()%>'>
			  						<input type='hidden' name='car_seq' value='<%=cm_bean.getCar_seq()%>'>
									<input type='hidden' name='car_s_amt' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>'>
									<input type='hidden' name='car_v_amt' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>'>
									<input type='hidden' name='auto_yn' value='<%=cm_bean.getAuto_yn()%>'>
									<input type='hidden' name='car_b' value='<%=cm_bean.getCar_b()%>'>
								</td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='car_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='15' class='fixnum' readonly>
        			  ��</td>
                </tr>
                <tr> 
                    <td class='title'>�ɼ�</td>
                    <td>
        			    <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_41 style="display:''">&nbsp;
            				        <a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>			
                                </td>
                                <td id=td_42 style="display:''">&nbsp;
            				    	<input type='text' name="opt" size='60' class='fix' value="<%=car.getOpt()%>" readonly>
				  		    		<input type='hidden' name='opt_seq' value='<%=car.getOpt_code()%>'>
				  		    		<input type='hidden' name='opt_s_amt' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>'>
				  		    		<input type='hidden' name='opt_v_amt' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>'>
				  				</td>
                            </tr>
                        </table>
                    </td>
                    <td align="center">
                    	<input type='text' name='opt_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='13' class='fixnum' readonly> ��
                    	<input type='hidden' name='opt_amt_m' value=''>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width=7% id=td_51 style="display:''">&nbsp;
            				        <a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
                                </td>
                                <td id=td_52 style="display:''">&nbsp;
                                	<input type='text' name="col" size='40' class='fix' value="<%=car.getColo()%>" readonly>
				                          ����
				                          <input type='text' name="in_col" size='20' class='fix' value="<%=car.getIn_col()%>" readonly>
				                          ���Ͻ�
				                          <input type='text' name="garnish_col" size='20' class='fix' value="<%=car.getGarnish_col()%>" readonly>
            				    	
				  					<input type='hidden' name='col_seq' value=''>
				  					<input type='hidden' name='col_s_amt' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>'>
				  					<input type='hidden' name='col_v_amt' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>'>
				  				</td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='col_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='13' class='fixnum' readonly>
        			  ��</td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>��������</td>
                    <td align="center"><input type='text' name='o_1' size='10' value='' maxlength='13' class='fixnum' readonly>					
    				��
					</td>
                </tr>
                <tr> 
                    <td colspan='2' class='title'>��������</td>
                    <td><table width="100%" border="0" cellpadding="0">
                        <tr>
                          <td>&nbsp;
						  	<select name="purc_gu">
                        		<option value=''>����</option>
                        		<option value='1' <%if(car.getPurc_gu().equals("1")){%> selected <%}%>>����</option>
                        		<option value='0' <%if(car.getPurc_gu().equals("0")){%> selected <%}%>>�鼼</option>
                     	 	</select>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>								
            </table>
	    </td>
    </tr>	
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	fm.o_1.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)));
	fm.o_1_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_s_amt.value)) + toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.col_s_amt.value)));
	fm.o_1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_v_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)) + toInt(parseDigit(fm.col_v_amt.value)));		
	
//-->
</script>	
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����D/C</span></td>	
	</tr>
	<tr>
		<td class='line2'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='3%'> ���� </td>
					<td class='title'>����</td>
					<td width="17%" class='title'>�뿩��ݿ�����</td>
				    <td width="17%" class='title'>�ݾ�</td>
			    </tr>
				<tr>
					<td align='center'>1</td>
					<td align="center"><input type='text' name='s_dc1_re' size='75' class="text" value='<%=car.getS_dc1_re()%>'></td>
					<td align="center"><select name='s_dc1_yn'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc1_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc1_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc1_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc1_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>2</td>
					<td align="center"><input type='text' name='s_dc2_re' size='75' class="text" value='<%=car.getS_dc2_re()%>'></td>
					<td align="center"><select name='s_dc2_yn'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc2_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc2_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc2_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc2_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>3</td>
					<td align="center"><input type='text' name='s_dc3_re' size='75' class="text" value='<%=car.getS_dc3_re()%>'></td>
					<td align="center"><select name='s_dc3_yn'>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc3_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc3_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc3_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc3_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
     					 ��</td>
			    </tr>
		  </table>
		</td>
	</tr>	
    <tr>
        <td>�� ����� <font color=red><b>�̰���Ȳ</b></font>���� �Ѿ�ϴ�.</td>
    </tr>
    <tr>
        <td>�� �̰���Ȳ���� ����� ������ �°� <font color=red><b>�뿩��� / �������� / ������� / ��༭ ��ĵ���</b></font> ���� ó���ϼ���.</td>
    </tr>
    <tr>
        <td>�� ��������� ����� �ʱ�ȭ �մϴ�. ���� �Ϸ��� �����û �ϼ���.</td>
    </tr>
    <%if(!String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null") && !String.valueOf(pur_com.get("USE_YN_ST")).equals("����")){%>
	<tr>
        <td><font color='red'>�� Ư�ǹ������� ��Ϻ��Դϴ�. ����,�ɼ�,������ ������ ��� ���¾�ü����-��ü���������� ��ຯ�� ó���Ͻʽÿ�.</font></td>
    </tr> 
    <input type="hidden" name="pur_color" value="<%=pur_com.get("R_COLO")%>">   
    <%}else{ %>
    <input type="hidden" name="pur_color" value="">
	<%} %>		    
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	/*
	var car_comp_id = fm.car_comp_id.options[fm.car_comp_id.selectedIndex].value;
	fm.con_cd3.value = car_comp_id.substring(0,1);
	var code = fm.code.options[fm.code.selectedIndex].text;
	fm.con_cd4.value = code.substring(1,3);
	*/

//-->
</script>
</body>
</html>
