<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="coh_bean" class="acar.car_office.CarOffEdhBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"0":request.getParameter("gubun5");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String cust_st = request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String emp_nm = request.getParameter("emp_nm")==null?"":request.getParameter("emp_nm");
	String emp_ssn = request.getParameter("emp_ssn")==null?"":request.getParameter("emp_ssn");
	String emp_m_tel = request.getParameter("emp_m_tel")==null?"":request.getParameter("emp_m_tel");
	String emp_pos = request.getParameter("emp_pos")==null?"":request.getParameter("emp_pos");
	String emp_email = request.getParameter("emp_email")==null?"":request.getParameter("emp_email");
	String emp_bank = request.getParameter("emp_bank")==null?"":request.getParameter("emp_bank");
	String emp_acc_no = request.getParameter("emp_acc_no")==null?"":request.getParameter("emp_acc_no");
	String emp_acc_nm = request.getParameter("emp_acc_nm")==null?"":request.getParameter("emp_acc_nm");
	String emp_post = request.getParameter("emp_post")==null?"":request.getParameter("emp_post");
	String emp_addr = request.getParameter("emp_addr")==null?"":request.getParameter("emp_addr");
	String etc = request.getParameter("etc")==null?"":request.getParameter("etc");
	String reg_dt = AddUtil.ChangeString(AddUtil.getDate());
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String upd_dt = request.getParameter("upd_dt")==null?"":AddUtil.ChangeString(request.getParameter("upd_dt"));
	String upd_id = request.getParameter("upd_id")==null?"":request.getParameter("upd_id");
	String emp_h_tel = request.getParameter("emp_h_tel")==null?"":request.getParameter("emp_h_tel");
	String emp_sex = request.getParameter("emp_sex")==null?"":request.getParameter("emp_sex");
	String use_yn = request.getParameter("use_yn")==null?"":request.getParameter("use_yn");
	String sms_denial_rsn = request.getParameter("sms_denial_rsn")==null?"":request.getParameter("sms_denial_rsn");
	
	//담당자이력관리
	String damdang_id = request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String cng_dt = request.getParameter("cng_dt")==null?"":AddUtil.ChangeString(request.getParameter("cng_dt"));
	String cng_rsn2 = request.getParameter("cng_rsn2")==null?"":request.getParameter("cng_rsn2"); 
		
    String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
    String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	int count = 0;


	String car_comp_id	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_off_nm 	= request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm");
	String car_off_st 	= request.getParameter("car_off_st")==null?"":request.getParameter("car_off_st");
	String car_off_tel 	= request.getParameter("car_off_tel")==null?"":request.getParameter("car_off_tel");
	String car_off_fax 	= request.getParameter("car_off_fax")==null?"":request.getParameter("car_off_fax");
	String t_zip[] 		= request.getParameterValues("t_zip");
	String t_addr[] 	= request.getParameterValues("t_addr");
	
	//영업소등록
	co_bean.setCar_comp_id(car_comp_id);
	co_bean.setCar_off_id(car_off_id);
	co_bean.setCar_off_nm(car_off_nm);
	co_bean.setCar_off_st(car_off_st);
	co_bean.setCar_off_tel(car_off_tel);
	co_bean.setCar_off_fax(car_off_fax);
	co_bean.setCar_off_post(t_zip[0]);
	co_bean.setCar_off_addr(t_addr[0]);

	//영업사원등록
	coe_bean.setCar_off_id(car_off_id);
	coe_bean.setCust_st(cust_st);
	coe_bean.setEmp_nm(emp_nm);
	coe_bean.setEmp_ssn(emp_ssn);
	coe_bean.setEmp_m_tel(emp_m_tel);
	coe_bean.setEmp_pos(emp_pos);
	coe_bean.setEmp_email(emp_email.trim());
	coe_bean.setEmp_bank(emp_bank);
	coe_bean.setEmp_acc_no(emp_acc_no);
	coe_bean.setEmp_acc_nm(emp_acc_nm);
	coe_bean.setEmp_post(t_zip[1]);
	coe_bean.setEmp_addr(t_addr[1]);
	coe_bean.setEmp_id(emp_id);
	coe_bean.setEtc(etc);
	coe_bean.setReg_dt(reg_dt);
	coe_bean.setReg_id(reg_id);
	coe_bean.setUpd_dt(upd_dt);
	coe_bean.setUpd_id(upd_id);
	coe_bean.setEmp_h_tel(emp_h_tel);
	coe_bean.setEmp_sex(emp_sex);
	coe_bean.setUse_yn(use_yn);
	coe_bean.setSms_denial_rsn(sms_denial_rsn);
	//담당자 이력관리
	coh_bean.setEmp_id(emp_id);
	coh_bean.setDamdang_id(damdang_id);
	coh_bean.setCng_dt(cng_dt);
	coh_bean.setCng_rsn(cng_rsn2);	//검색조건(car_off_p_sh)에서 cng_rsn으로 해서 수정화면에 중복발생하여 에러나서 2로 함.
	
	coh_bean.setReg_id(reg_id);
	coh_bean.setReg_dt(reg_dt);
	
	coe_bean.setBank_cd		(request.getParameter("emp_bank_cd")	==null?"":request.getParameter("emp_bank_cd"));
		
	if(!coe_bean.getBank_cd().equals("")){
		coe_bean.setEmp_bank		(c_db.getNameById(coe_bean.getBank_cd(), "BANK"));
	}	
	
	emp_id = umd.insertCarOffEmp(coe_bean, coh_bean);
	
	/*
	if(car_off_id.equals("")){
		emp_id = umd.insertCarOffEmp(coe_bean, coh_bean, co_bean);
	}else{
		emp_id = umd.insertCarOffEmp(coe_bean, coh_bean);
	}
	*/
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
</head>
<body>
<script language="JavaScript">
<!--
<%if(emp_id.equals("")){%>
	alert("에러발생");
<%}else{%>
	alert("정상적으로 등록되었습니다.");
	<%if(from_page.equals("car_agent_c.jsp")){%>
		parent.opener.location.reload();
	<%}else{%>	
		<%if(gubun.equals("BUS")){%>
			parent.opener.document.form1.emp_id[0].value 		= '<%=emp_id%>';
			parent.opener.document.form1.emp_nm[0].value 		= '<%=emp_nm%>';
			parent.opener.document.form1.car_off_nm[0].value 	= '<%=car_off_nm%>';
			var car_off_st = '<%=car_off_st%>';
			if(car_off_st == '1') 		parent.opener.document.form1.car_off_st[0].value = '지점';
			else if(car_off_st == '2') 	parent.opener.document.form1.car_off_st[0].value = '영업소';
			var cust_st = '<%=cust_st%>';
			if(cust_st == '1') 			parent.opener.document.form1.cust_st.value = '갑종근로소득';
			else if(cust_st == '2') 	parent.opener.document.form1.cust_st.value = '사업소득';
			else if(cust_st == '3') 	parent.opener.document.form1.cust_st.value = '기타사업소득';			
		<%}else{%>
			parent.opener.document.form1.emp_id[1].value 		= '<%=emp_id%>';
			parent.opener.document.form1.emp_nm[1].value 		= '<%=emp_nm%>';
			parent.opener.document.form1.car_off_nm[1].value 	= '<%=car_off_nm%>';
			var car_off_st = '<%=car_off_st%>';
			if(car_off_st == '1') 		parent.opener.document.form1.car_off_st[1].value = '지점';
			else if(car_off_st == '2') 	parent.opener.document.form1.car_off_st[1].value = '영업소';
		<%}%>
	<%}%>
	parent.self.close();
<%}%> 
//-->
</script>
</body>
</html>
