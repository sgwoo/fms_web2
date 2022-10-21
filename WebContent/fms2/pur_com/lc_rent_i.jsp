<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.tint.*, acar.doc_settle.*, acar.estimate_mng.*, acar.consignment.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");


	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
	
	//��������
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreRent(rent_l_cd);
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//���� ���Ź�� ����� �ִ��� Ȯ��
	ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	CarPurDocListBean cpd_bean = new CarPurDocListBean();
	
	String dlv_mng_id = nm_db.getWorkAuthUser("��������");
	
	UsersBean dlv_mng_bean 	= umd.getUsersBean(dlv_mng_id);
	
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
	UsersBean udt_mng_bean_b2 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ����������"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ�������"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("�뱸������"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
	
	if(pur.getUdt_st().equals("")){
		if(base.getBrch_id().equals("S1")||base.getBrch_id().equals("S2")||base.getBrch_id().equals("S3")||base.getBrch_id().equals("S4")||base.getBrch_id().equals("K3")||base.getBrch_id().equals("S4")||base.getBrch_id().equals("S5")) pur.setUdt_st("1");			
		if(base.getBrch_id().equals("B1")||base.getBrch_id().equals("U1")) pur.setUdt_st("2");			
		if(base.getBrch_id().equals("D1")) pur.setUdt_st("3");		
		if(base.getBrch_id().equals("G1")) pur.setUdt_st("5");		
		if(base.getBrch_id().equals("J1")) pur.setUdt_st("6");		
	}
	
	if(car.getPurc_gu().equals("")){
		if(base.getCar_st().equals("3")){
			car.setPurc_gu("1");	
		}else{
			car.setPurc_gu("0");	
		}
	}
	
	user_bean 	= umd.getUsersBean(ck_acar_id);
	
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"";				   	
	
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
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

	//����Ʈ
	function list(){
		var fm = document.form1;			
		fm.action = 'lc_rent_frame.jsp';
		if(fm.from_page.value != ''){
			fm.action = fm.from_page.value;
		}
		fm.target = 'd_content';
		fm.submit();
	}	

	//���� �Һ��ڰ� �հ�
	function set_car_amt(){
		var fm = document.form1;
		
		fm.car_d_amt.value 	= parseDecimal( toInt(parseDigit(fm.dc_amt.value)) + toInt(parseDigit(fm.add_dc_amt.value)) );
		fm.car_g_amt.value 	= parseDecimal( toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_d_amt.value)) );
		fm.car_amt1.value 	= fm.car_g_amt.value;		
		fm.car_amt2.value 	= fm.cons_amt.value;		
		fm.car_amt3.value 	= parseDecimal( toInt(parseDigit(fm.car_g_amt.value)) + toInt(parseDigit(fm.cons_amt.value)) );
				
	}
	
	//���԰����
	function set_car_f_amt(){
		var fm = document.form1;
		
		if(fm.purc_gu.value == '����'){//����1
			fm.car_f_amt.value = fm.car_c_amt.value;
		}else{//����2(�鼼) 
			if('<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || '<%=cm_bean.getS_st()%>' == '301' || '<%=cm_bean.getS_st()%>' =='302' || '<%=cm_bean.getS_st()%>' == '300'))){
				fm.car_f_amt.value = fm.car_c_amt.value;
			}else{
			
				var o_1 = toInt(parseDigit(fm.car_c_amt.value));
		
				//������ Ư�Ҽ���
				var o_2 = <%=ej_bean.getJg_3()%>;	
				
				//Ư�Ҽ��������� o_3 = o_1/(1+o_2), ��������/(1+Ư�Ҽ���);
				var o_3 = Math.round(o_1/(1+o_2));	
					
				fm.car_f_amt.value  = parseDecimal(o_3);
			}			
		}	
		
		if(fm.car_off_id.value == '03900'){
			fm.dc_amt.value = parseDecimal( Math.round( toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );
		}
		
		set_car_amt();				
	}		
	
	//�μ����� ����� ����Ʈ
	function setOff(){
		var fm = document.form1;
		
		var deposit_len = fm.udt_firm.length;			
		for(var i = 1 ; i < deposit_len ; i++){
			fm.udt_firm.options[i] = null;			
		}
		
		if(fm.udt_st.value == '1'){
			fm.udt_firm.options[1] = new Option('������ ����������', '������ ����������');					
			fm.udt_firm.value = '������ ����������';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '2'){
			<%if(AddUtil.getDate2(4) >= 20210205){%>
			fm.udt_firm.options[1] = new Option('������TS', '������TS');
			fm.udt_firm.options[2] = new Option('�����̵���ǽ��� ����1�� ������', '�����̵���ǽ��� ����1�� ������');
			fm.udt_firm.options[3] = new Option('����ī(������)', '����ī(������)');
			fm.udt_firm.value = '������TS';
			<%}else{%>
			fm.udt_firm.options[1] = new Option('������������� ������', '������������� ������');
			fm.udt_firm.options[2] = new Option('�����̵���ǽ��� ����1�� ������', '�����̵���ǽ��� ����1�� ������');
			fm.udt_firm.options[3] = new Option('����ī(������)', '����ī(������)');
			fm.udt_firm.options[4] = new Option('������TS', '������TS');
			fm.udt_firm.value = '������������� ������';
			<%}%>
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '3'){
			fm.udt_firm.options[1] = new Option('�̼���ũ', '�̼���ũ');								
			fm.udt_firm.value = '�̼���ũ';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '5'){
			fm.udt_firm.options[1] = new Option('�뱸 ������', '�뱸 ������');											
			fm.udt_firm.value = '�뱸 ������';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '6'){
			fm.udt_firm.options[1] = new Option('������ڵ�����ǰ��', '������ڵ�����ǰ��');											
			fm.udt_firm.value = '������ڵ�����ǰ��';
			cng_input1(fm.udt_firm.value);
		}else if(fm.udt_st.value == '4'){
			fm.udt_firm.options[1] = new Option('<%=client.getFirm_nm()%>', '<%=client.getFirm_nm()%>');											
			fm.udt_firm.value = '<%=client.getFirm_nm()%>';
			cng_input1(fm.udt_firm.value);
		}			
	}	
	
	//�����μ��� ���ý� ��ǰ��ü ����
	function cng_input1(value){
		var fm = document.form1;
		
		
		if(fm.udt_firm.value == '������ ����������'){					
			fm.udt_addr.value 	= '����� �������� �������� 34�� 9';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_s.getDept_nm()%> <%=udt_mng_bean_s.getUser_nm()%> <%=udt_mng_bean_s.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_s.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_s.getUser_id()%>';
			fm.cons_amt.value       = parseDecimal(fm.jg_d1.value);			
		}else if(fm.udt_firm.value == '����ī(������)'){			
			fm.udt_addr.value 	= '�λ걤���� ������ ����4�� 700-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b.getUser_id()%>';
			fm.cons_amt.value       = parseDecimal(fm.jg_d2.value);			
		}else if(fm.udt_firm.value == '������������� ������'){			
			fm.udt_addr.value 	= '�λ걤���� ������ ����4�� 585-1';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';		
			fm.cons_amt.value       = parseDecimal(fm.jg_d2.value);				
		}else if(fm.udt_firm.value == '������TS'){			
			fm.udt_addr.value 	= '�λ�� ������ �ȿ���7������ 10(���굿 363-13����)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';	

		}else if(fm.udt_firm.value == '�����̵���ǽ��� ����1�� ������'){			
			fm.udt_addr.value 	= '�λ걤���� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵�������';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_b2.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_b2.getUser_id()%>';		
			fm.cons_amt.value       = parseDecimal(fm.jg_d2.value);				
		}else if(fm.udt_firm.value == '����ī��ǰ'){			
			fm.udt_addr.value 	= '���������� ������ ������ 527-5';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';
			fm.cons_amt.value       = parseDecimal(fm.jg_d3.value);						
		}else if(fm.udt_firm.value == '�̼���ũ'){				
			fm.udt_addr.value = '���������� ������ ��õ�Ϸ�59���� 10(���� 690-3)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_d.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_d.getUser_id()%>';			
		}else if(fm.udt_firm.value == '�뱸 ������'){			
			fm.udt_addr.value 	= '�뱸������ �޼��� �Ŵ絿 321-86';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_g.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_g.getUser_id()%>';
			fm.cons_amt.value       = parseDecimal(fm.jg_d2.value);
		}else if(fm.udt_firm.value == '������ڵ�����ǰ��'){			
			fm.udt_addr.value 	= '���ֱ����� ���걸 �󹫴�� 233 (������ 1360)';
			fm.udt_mng_nm.value 	= '<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>';
			fm.udt_mng_tel.value 	= '<%=udt_mng_bean_j.getHot_tel()%>';
			fm.udt_mng_id.value     = '<%=udt_mng_bean_j.getUser_id()%>';
			fm.cons_amt.value       = parseDecimal(fm.jg_d3.value);
		}else if(fm.udt_firm.value == '<%=client.getFirm_nm()%>'){			
			fm.udt_addr.value 	= '<%=client.getO_addr()%>';
			fm.udt_mng_nm.value 	= '<%=client.getCon_agnt_dept()%> <%=client.getCon_agnt_nm()%> <%=client.getCon_agnt_title()%>';
			fm.udt_mng_tel.value 	= '<%=client.getO_tel()%>';
			fm.udt_mng_id.value     = '';
			fm.cons_amt.value       = 0;
		}
		
					
	}		
	
	//����� ���÷���
	function cng_input2(){
		var fm = document.form1;
		if(fm.stock_yn[0].checked == true){ 				//����
			tr_stock1.style.display = '';		
			tr_stock2.style.display = 'none';		
		}else{								//����
			tr_stock1.style.display = 'none';		
			tr_stock2.style.display = '';		
		}
	}	
		
	//���
	function save(){
		var fm = document.form1;
		
		
		if(fm.com_con_no.value == ''){	alert('�ڵ����� ����ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 	fm.com_con_no.focus(); 	return;	}
		
		if(fm.dlv_st.options[fm.dlv_st.selectedIndex].value == '1' && fm.dlv_est_dt.value == ''){
		//	alert('��������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_est_dt.focus(); 	return;
		}
		
		if(fm.dlv_st.options[fm.dlv_st.selectedIndex].value == '2' && fm.dlv_est_dt.value == ''){
			alert('���������ڸ� �Է��Ͽ� �ֽʽÿ�.'); 	fm.dlv_est_dt.focus(); 	return;
		}
		
		//������Ȳ���� �������� �Ѿ�� �Ѵ�.
		//if(fm.car_off_id.value == '03900' && toInt(parseDigit(fm.add_dc_amt.value)) ==0){
		//	alert('�߰�D/C�� �Է��Ͽ� �ֽʽÿ�.'); 	fm.add_dc_amt.focus(); 	return;
		//}				
		
		if(confirm('��� �Ͻðڽ��ϱ�?')){	
			fm.action='lc_rent_i_a.jsp';		
			fm.target='i_no';	
			if(fm.user_id.value=='000029'){
				fm.target='d_content';	
			}		
			fm.submit();
		}	
	}		
	
	function search_firm_h(){
		var fm = document.form1;
		if(confirm('��� �Ͻðڽ��ϱ�?')){	
			fm.action='lc_rent_u_cust_a.jsp';		
			fm.target='i_no';			
			fm.submit();
		}		
	}					
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">  
  <input type='hidden' name="dlv_mng_id" 	value="<%=dlv_mng_id%>">
  <input type='hidden' name="udt_mng_id" 	value="<%=cons.getUdt_mng_id()%>">
  <input type='hidden' name="car_comp_id" 	value="<%=cm_bean.getCar_comp_id()%>">
  <input type='hidden' name="car_off_id" 	value="<%=emp2.getCar_off_id()%>">
  <input type='hidden' name="jg_d1" 	value="<%//=ej_bean.getJg_d1()%>">
  <input type='hidden' name="jg_d2" 	value="<%//=ej_bean.getJg_d2()%>">
  <input type='hidden' name="jg_d3" 	value="<%//=ej_bean.getJg_d3()%>">
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������� > <span class=style5>������</span></span></td>
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
                    <td width=7% rowspan="2" class=title>����ȣ</td>
                    <td width=7% class=title>�Ƹ���ī</td>
                    <td width=19%>&nbsp;<%=rent_l_cd%></td>
                    <td width=7% rowspan="2" class=title>��������</td>
                    <td width=7% class=title>�������</td>
                    <td width="19%" >&nbsp;<%=AddUtil.ChangeDate2(base.getReg_dt())%></td>
                    <td width=7% rowspan="2" class=title>�����</td>
                    <td width=7% class=title>������</td>
                    <td width="20%">&nbsp;<%=dlv_mng_bean.getDept_nm()%>&nbsp;<%=dlv_mng_bean.getUser_nm()%>&nbsp;<%=dlv_mng_bean.getUser_pos()%></td>
    		    </tr>
                <tr>
                  <td class=title><%=cm_bean.getCar_comp_nm()%></td>
                  <%	if(cpd_bean.getCom_con_no().equals("") && !pur.getRpt_no().equals(""))	cpd_bean.setCom_con_no(pur.getRpt_no()); %>
                  <td>&nbsp;<input type='text' name='com_con_no' value='<%=cpd_bean.getCom_con_no()%>' class='default' size='15'>
                  </td>
                  <td class=title>��������</td>
                  <td >&nbsp;<%=AddUtil.ChangeDate2(pur.getPur_req_dt())%></td>
                  <td width=5% class=title>����ó</td>
                  <td>&nbsp;<%=dlv_mng_bean.getHot_tel()%></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <%if(cop_bean.getRent_l_cd().equals(rent_l_cd)){ %>
    <tr>
        <td>�� ������������Դϴ�. (�����ȣ : <%=cop_bean.getCom_con_no()%>)</td>
    </tr>    
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <input type='hidden' name="car_nm" 	value="<%=cm_bean.getCar_nm()%> <%=cm_bean.getCar_name()%>">
                <input type='hidden' name="opt" 	value="<%=car.getOpt()%>">
                <input type='hidden' name="purc_gu" 	value="<%if(car.getPurc_gu().equals("1")){%>����<%}else if(car.getPurc_gu().equals("0")){%>�鼼<%}%>">
                <input type='hidden' name="colo" 	value="<%=car.getColo()%>/<%=car.getIn_col()%>/<%=car.getGarnish_col()%>">                
                <input type='hidden' name="car_b" 	value="<%=cm_bean.getCar_b()%>">
                <tr> 
                    <td width=14% class=title>����</td>
                    <td colspan="3">&nbsp;<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%> <%if(!cm_bean.getCar_y_form().equals("")){%>(����:<%=cm_bean.getCar_y_form()%>)<%}%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>���û��</td>
                    <td colspan="3" >&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td colspan="3" >&nbsp;����:<%=car.getColo()%>/����:<%=car.getIn_col()%>/���Ͻ�:<%=car.getGarnish_col()%></td>
                </tr>
                <tr>
                  <td class=title>��������</td>
                  <td width="19%">&nbsp;<%if(car.getPurc_gu().equals("1")){%>����<%}else if(car.getPurc_gu().equals("0")){%>�鼼<%}%></td>
                  <td width=14% class=title>T/M</td>
                  <td>&nbsp;<input type='text' name='auto' size='4' value='<%if(cm_bean.getAuto_yn().equals("Y")){%>A/T<%}else{%>M/T<%}%>' class='whitetext' ></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>����</td>
                    <td width=7% class=title>�Һ��ڰ�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                    <td width=7% rowspan="2" class=title>D/C</td>
                    <td width=7% class=title>D/C</td>
                    <td width="19%" >&nbsp;<input type='text' name='dc_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                    <td width="14%" class=title>D/C�հ�</td>
                    <td width="20%">&nbsp;<input type='text' name='car_d_amt' size='10' value='0'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
    		    </tr>
                <tr>
                  <td class=title>���԰�</td>
                  <td>&nbsp;<input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>'  maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��<a href="javascript:set_car_f_amt()" onMouseOver="window.status=''; return true" title="���԰� ����ϱ�">[���]</a></td>
                  <td class=title>�߰�D/C</td>
                  <td >&nbsp;<input type='text' name='add_dc_amt' size='10' value='0'  maxlength='10' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                  <td class=title>�ŷ��ݾװ�</td>
                  <td>&nbsp;<input type='text' name='car_g_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt()-car.getDc_cs_amt()+car.getDc_cv_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);'>��</td>
                </tr>	
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="3" class=title>����</td>
                    <td width=7% class=title>����</td>
                    <td width=19%>&nbsp;<select name="dlv_st" class='default'>
        				<option value="1">����</option>
        				<option value="2">����</option>
        			  </select>
        			  <%	String pur_dlv_est_dt = String.valueOf(est.get("DLV_EST_DT"))==null?"":String.valueOf(est.get("DLV_EST_DT")); 
        			  		if(pur_dlv_est_dt.equals("null")) pur_dlv_est_dt = "";
        			  %>
        			  &nbsp;
        			  <input type='text' size='11' name='dlv_est_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(pur_dlv_est_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  (��¥)</td>
                    <td width=7% rowspan="3" class=title>�����</td>
                    <td width=7% class=title>����</td>
                    <td width="19%" >&nbsp;<select name="udt_st" class='default' onChange="javascript:setOff()">
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getUdt_st().equals("1"))%> selected<%%>>���ﺻ��</option>
        				<option value="2" <%if(pur.getUdt_st().equals("2"))%> selected<%%>>�λ�����</option>
        				<option value="3" <%if(pur.getUdt_st().equals("3"))%> selected<%%>>��������</option>				
        				<option value="5" <%if(pur.getUdt_st().equals("5"))%> selected<%%>>�뱸����</option>
        				<option value="6" <%if(pur.getUdt_st().equals("6"))%> selected<%%>>��������</option>				
        				<option value="4" <%if(pur.getUdt_st().equals("4"))%> selected<%%>>��</option>
        			  </select></td>
                    <td width="7%" rowspan="2" class=title>�����</td>
                    <td width="7%" class=title>�μ�/����</td>
                    <td width="20%">&nbsp;<input type='text' name='udt_mng_nm' size='29' value='<%=cons.getUdt_mng_nm()%>' class='whitetext' ></td>
    		    </tr>
                <tr>
                
                  <td class=title>���繫��</td>
                  <td>&nbsp;<%	//������ڵ�
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
                  <td class=title>����/��ȣ</td>
                  <td >&nbsp;<select name="udt_firm" class='default' onChange="javascript:cng_input1(this.value);">
                            <option value="">==����==</option>
        		    <%if(pur.getUdt_st().equals("1")){%>
        		    <option value="������ ����������" <%if(cons.getUdt_firm().equals("������ ����������"))%> selected<%%>>������ ����������</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("2")){%>
        		    <%if(AddUtil.getDate2(4) < 20210205){%>
        		    <option value="������������� ������" <%if(cons.getUdt_firm().equals("������������� ������"))%> selected<%%>>������������� ������</option>
        		    <%} %>
        		    <option value="�����̵���ǽ��� ����1�� ������" <%if(cons.getUdt_firm().equals("�����̵���ǽ��� ����1�� ������"))%> selected<%%>>�����̵���ǽ��� ����1�� ������</option>
        		    <option value="����ī(������)" <%if(cons.getUdt_firm().equals("����ī(������)"))%> selected<%%>>����ī(������)</option>
        		    <option value="������TS" <%if(cons.getUdt_firm().equals("������TS"))%> selected<%%>>������TS</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("3")){%>
        		    <option value="�̼���ũ" <%if(cons.getUdt_firm().equals("�̼���ũ"))%> selected<%%>>�̼���ũ</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("5")){%>
        		    <option value="�뱸 ������" <%if(cons.getUdt_firm().equals("�뱸 ������"))%> selected<%%>>�뱸 ������</option>
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("6")){%>
        		    <option value="������ڵ�����ǰ��" <%if(cons.getUdt_firm().equals("������ڵ�����ǰ��"))%> selected<%%>>������ڵ�����ǰ��</option>				
        		    <%}%>
        		    <%if(pur.getUdt_st().equals("4")){%>
     			    <option value="<%=client.getFirm_nm()%>" <%if(cons.getUdt_firm().equals(client.getFirm_nm()))%> selected<%%>><%=client.getFirm_nm()%></option>
     			    <%}%>
        		</select>
                  </td>
                  <td class=title>����ó</td>
                  <td>&nbsp;<input type='text' name='udt_mng_tel' size='29' value='<%=cons.getUdt_mng_tel()%>' class='whitetext' ></td>
                </tr>
                <tr>
                  <td class=title>���Ź�۷�</td>
                  <td>&nbsp;<input type='text' name='cons_amt' maxlength='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt();'>��</td>
                  <td class=title>�ּ�</td>
                  <td colspan="4" >&nbsp;<input type='text' name='udt_addr' size='80' value='<%=cons.getUdt_addr()%>' class='whitetext' ></td>
                </tr>	
            </table>
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>�ֹ���</td>
                    <td colspan='2'>&nbsp;<input type="checkbox" name="order_car" value="Y">�ֹ���</td>                    
                </tr>            	
                <tr> 
                    <td width=14% class=title>�����Ȳ</td>
                    <td width=19%> &nbsp;<input type='radio' name="stock_yn" value='N' checked onClick="javascript:cng_input2()">
                      ����
                      <input type='radio' name="stock_yn" value='Y' onClick="javascript:cng_input2()">
                      ����</td>
                    <td>
                        <table>
                            <tr id=tr_stock1 style="display:''">
                                <td>
                                    <input type='radio' name="stock_st" value='1'>
                      			������ü(1�����̻�)
                      		    <input type='radio' name="stock_st" value='2'>
                      			������ü(1�����̳�)
                      		    <input type='radio' name="stock_st" value='3'>
                      			��������(��1~2��)
                                </td>  
                            </tr>
                            <tr id=tr_stock2 style='display:none'>
                                <td>
                                    ������ : 
                                    <input type='radio' name="stock_st" value='4'>
                      			�Ͻ���
                      		    <input type='radio' name="stock_st" value='5'>
                      			�����
                                </td>  
                            </tr>                          
                        </table>                       
                    </td>   
                </tr>
                <tr> 
                    <td width=14% class=title>Ư�̻���</td>
                    <td colspan='2'>&nbsp;<textarea rows='3' cols='90' name='bigo'></textarea></td>
                </tr>                   
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>
    <%if(user_bean.getDept_id().equals("8888")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���������</td>
                    <td width=19%>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%>
                    <%	if(!base.getAgent_emp_id().equals("")){
                    		CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
                    %>
                    		(������Ʈ ����������� : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)
                    <%	}%>                    
                    </td>
                    <td width=14% class=title>��ȣ</td>
                    <td width=53%>&nbsp;<%=pur.getPur_com_firm()%>
                        <%=AddUtil.ChangeEnt_no(c_db.getNameById(pur.getPur_com_firm(),"ENP_NO"))%>
                        <%if(pur.getPur_com_firm().equals("")){%><%=client.getFirm_nm()%><%}%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else{%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%>
                    <%	if(!base.getAgent_emp_id().equals("")){
                    		CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
                    %>
                    		(������Ʈ ����������� : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)
                    <%	}%>  
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>     
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
		    <td colspan='2' class=title>������</td>
		    <td colspan='2' class=title>������(Ư��)</td>
                </tr>
                <tr> 
                    <td width=15% class=title>������</td>
		    <td width=35% class=title>��ȣ</td>
		    <td width=15% class=title>������</td>
		    <td width=35% class=title>��ȣ</td>
                </tr>
                <tr> 									
                    <td>&nbsp;<%if(client.getClient_st().equals("1")){ 	out.println("����");
	                    }else if(client.getClient_st().equals("2")){  	out.println("����");
	                    }else if(client.getClient_st().equals("3")){ 	out.println("���λ����(�Ϲݰ���)");
	                    }else if(client.getClient_st().equals("4")){	out.println("���λ����(���̰���)");
	                    }else if(client.getClient_st().equals("5")){ 	out.println("���λ����(�鼼�����)");}%>
                    </td>
                    <td>&nbsp;<%=client.getFirm_nm()%></td>
                    <td>&nbsp;<!--����--></td>
		    <td>&nbsp;<%=pur.getPur_com_firm()%>
		        &nbsp;<%=AddUtil.ChangeEnt_no(c_db.getNameById(pur.getPur_com_firm(),"ENP_NO"))%>
		        
		        <%if(pur.getPur_com_firm().equals("")){%>		        
		        <%	if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("�ѹ�����",ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",ck_acar_id)){%>     
		        		<input type='text' name='pur_com_firm' size='40' value='<%=client.getFirm_nm()%>' class='whitetext' >
		        		<a href="javascript:search_firm_h()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
		        <%	}%>
		        <%}%>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>��������</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt1' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt()-car.getDc_cs_amt()+car.getDc_cv_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                    <td width=14% class=title>���Ź�۷�</td>
                    <td width=19%>&nbsp;<input type='text' name='car_amt2' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                    <td width=14% class=title>�հ�</td>
                    <td width=20%>&nbsp;<input type='text' name='car_amt3' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt()-car.getDc_cs_amt()+car.getDc_cv_amt()-car.getSd_cs_amt()+car.getSd_cv_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>��</td>
                </tr>
            </table>
        </td>
    </tr>           
    <tr>
	<td align="right">&nbsp;</td>
    <tr>     
    <%if(!from_page.equals("/fms2/pur_com/lc_firm_frame.jsp")){%>      
   <%	if(!cm_bean.getCar_comp_nm().equals("�����ڵ���") || !pur.getPur_com_firm().equals("")){// || client.getClient_st().equals("1")%>
    <tr>
	<td align='right'>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
	    <%}%>
	</td>
    </tr>	
    <%	}%>
    <%}%>
    <tr>
        <td class=h></td>
    </tr> 	
</table>
</form>
<script language="JavaScript">
<!--	
	
	var fm = document.form1;
	
	<%if(cons.getUdt_mng_nm().equals("")){%>
	setOff();
	<%}%>
	
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
	
	//���԰� ���
	if(fm.car_f_amt.value == '0'){
		set_car_f_amt();
	}
	
	if('<%=cm_bean.getCar_nm()%>' == 'YF�Ÿ' || '<%=cm_bean.getCar_nm()%>' == 'YF�Ÿ LPG'){
		fm.jg_d1.value = 120000;
		fm.jg_d2.value = 225000;
		fm.jg_d3.value =  98000;
	}

	if('<%=cm_bean.getCar_nm()%>' == '�׷���HG' || '<%=cm_bean.getCar_nm()%>' == '�׷���HG LPG'){
		fm.jg_d1.value = 120000;
		fm.jg_d2.value = 235000;
		fm.jg_d3.value = 102000;
	}
	
	if('<%=cm_bean.getCar_nm()%>' == '����Ƽ'){
		fm.jg_d1.value = 155000;
		fm.jg_d2.value = 217000;
		fm.jg_d3.value = 115000;
	}	
	
	if('<%=cm_bean.getCar_nm()%>' == 'i40'){
		fm.jg_d1.value = 225000;
		fm.jg_d2.value =  90000;
		fm.jg_d3.value = 162000;
	}	
	
	if('<%=cm_bean.getCar_nm()%>' == '����Ʈ'){
		fm.jg_d1.value = 232000;
		fm.jg_d2.value =  86000;
		fm.jg_d3.value = 173000;
	}		
	
	if('<%=cm_bean.getCar_nm()%>' == '�ƹݶ�' || '<%=cm_bean.getCar_nm()%>' == '�ƹݶ� LPG' || '<%=cm_bean.getCar_nm()%>' == 'i30'){
		fm.jg_d1.value = 232000;
		fm.jg_d2.value =  88000;
		fm.jg_d3.value = 173000;
	}
		
	if('<%=cm_bean.getCar_nm()%>' == '����(����)'){
		fm.jg_d1.value = 267000;
		fm.jg_d2.value = 113000;
		fm.jg_d3.value = 201000;
	}	
	
	if('<%=cm_bean.getCar_nm()%>' == '���׽ý�'){
		fm.jg_d1.value = 267000;
		fm.jg_d2.value = 113000;
		fm.jg_d3.value = 201000;
		if('<%=cm_bean.getJg_code()%>' == '4166' || '<%=cm_bean.getJg_code()%>' == '4167' || '<%=cm_bean.getJg_code()%>' == '4016113' || '<%=cm_bean.getJg_code()%>' == '4016114'){
			fm.jg_d1.value = 267000;
			fm.jg_d2.value = 112000;
			fm.jg_d3.value = 201000;
		}
	}		
	
	if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.jg_d1.value == ''){
		fm.jg_d1.value = 227000;
		fm.jg_d2.value =  91000;
		fm.jg_d3.value = 163000;
	}

	//20150805 ��� ���Ź������ Ź�ۺ� 0�� ����(����� Ź���� ����)
	fm.jg_d1.value = 0;
	fm.jg_d2.value = 0;
	fm.jg_d3.value = 0;

	if(fm.car_off_id.value == '03900' && toInt(parseDigit(fm.add_dc_amt.value)) ==0){
		fm.dc_amt.value = parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * <%=ej_bean.getJg_y()%> ) );
	}

		
	
	cng_input1(document.form1.udt_st.value);
	
	set_car_amt();
	
	
	
	
		
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

