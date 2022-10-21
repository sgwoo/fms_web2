<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
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
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	

%>


<%
	//4. 영업수당정보 commi-------------------------------------------------------------------------------------------
	
	//commi
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "4");
	
	emp1.setCommi		(request.getParameter("commi")			==null? 0:Util.parseDigit(request.getParameter("commi")));
	emp1.setInc_amt		(request.getParameter("inc_amt")		==null? 0:Util.parseDigit(request.getParameter("inc_amt")));
	emp1.setRes_amt		(request.getParameter("res_amt")		==null? 0:Util.parseDigit(request.getParameter("res_amt")));
	emp1.setTot_amt		(request.getParameter("c_amt")			==null? 0:Util.parseDigit(request.getParameter("c_amt")));
	emp1.setDif_amt		(request.getParameter("d_amt")			==null? 0:Util.parseDigit(request.getParameter("d_amt")));
	emp1.setAdd_amt1	(request.getParameter("add_amt1")		==null? 0:Util.parseDigit(request.getParameter("add_amt1")));
	emp1.setAdd_amt2	(request.getParameter("add_amt2")		==null? 0:Util.parseDigit(request.getParameter("add_amt2")));
	emp1.setAdd_amt3	(request.getParameter("add_amt3")		==null? 0:Util.parseDigit(request.getParameter("add_amt3")));
	emp1.setAdd_cau1	(request.getParameter("add_cau1")		==null?"":request.getParameter("add_cau1"));
	emp1.setAdd_cau2	(request.getParameter("add_cau2")		==null?"":request.getParameter("add_cau2"));
	emp1.setAdd_cau3	(request.getParameter("add_cau3")		==null?"":request.getParameter("add_cau3"));
	emp1.setInc_per		(request.getParameter("inc_per")		==null?"":request.getParameter("inc_per"));
	emp1.setRes_per		(request.getParameter("res_per")		==null?"":request.getParameter("res_per"));
	emp1.setTot_per		(request.getParameter("tot_per")		==null?"":request.getParameter("tot_per"));
	emp1.setEmp_acc_nm	(request.getParameter("emp_acc_nm")		==null?"":request.getParameter("emp_acc_nm"));
	emp1.setRel		(request.getParameter("rel")			==null?"":request.getParameter("rel"));
	emp1.setRec_incom_yn	(request.getParameter("rec_incom_yn")		==null?"":request.getParameter("rec_incom_yn"));
	emp1.setRec_incom_st	(request.getParameter("rec_incom_st")		==null?"":request.getParameter("rec_incom_st"));
	emp1.setEmp_bank	(request.getParameter("emp_bank")		==null?"":request.getParameter("emp_bank"));
	emp1.setEmp_acc_no	(request.getParameter("emp_acc_no")		==null?"":request.getParameter("emp_acc_no"));
	emp1.setRec_ssn		(request.getParameter("rec_ssn")		==null?"":request.getParameter("rec_ssn"));
	emp1.setRec_zip		(request.getParameter("t_zip")			==null?"":request.getParameter("t_zip"));
	emp1.setRec_addr	(request.getParameter("t_addr")			==null?"":request.getParameter("t_addr"));
	emp1.setReq_dt		(AddUtil.getDate());
	emp1.setReq_id		(user_id);
	emp1.setAdd_st1		(request.getParameter("add_st1")		==null?"":request.getParameter("add_st1"));
	emp1.setAdd_st2		(request.getParameter("add_st2")		==null?"":request.getParameter("add_st2"));
	emp1.setAdd_st3		(request.getParameter("add_st3")		==null?"":request.getParameter("add_st3"));
	emp1.setBank_cd		(request.getParameter("emp_bank_cd")	==null?"":request.getParameter("emp_bank_cd"));
		
	if(!emp1.getBank_cd().equals("")){
		emp1.setEmp_bank		(c_db.getNameById(emp1.getBank_cd(), "BANK"));
	}
	
	
	//영업사원정보 car_off_emp-------------------------------------------------------------------------------------
	
	coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
	
	
	//if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && !coe_bean.getFile_name1().equals("") && emp1.getFile_name1().equals("")) 	emp1.setFile_name1(coe_bean.getFile_name1());
	//if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && !coe_bean.getFile_name2().equals("") && emp1.getFile_name2().equals("")) 	emp1.setFile_name2(coe_bean.getFile_name2());
	//if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getFile_name1().equals("") && !emp1.getFile_name1().equals("")) 	result = cod.updateCarOffEmp(emp1.getEmp_id(), "1", emp1.getFile_name1(), emp1.getFile_gubun1());
	//if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getFile_name2().equals("") && !emp1.getFile_name2().equals("")) 	result = cod.updateCarOffEmp(emp1.getEmp_id(), "2", emp1.getFile_name2(), emp1.getFile_gubun2());
	if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getEmp_ssn1().equals("") && !emp1.getRec_ssn().equals("")) 		result = cod.updateCarOffEmp(emp1.getEmp_id(), "3", emp1.getRec_ssn(), "");
	if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getEmp_addr().equals("") && !emp1.getRec_addr().equals("")) 		result = cod.updateCarOffEmp(emp1.getEmp_id(), "4", emp1.getRec_zip(), emp1.getRec_addr());
	if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getCust_st().equals("") && !emp1.getRec_incom_st().equals("")) 	result = cod.updateCarOffEmp(emp1.getEmp_id(), "5", emp1.getRec_incom_st(), "");
	
	String s_file_name1		= request.getParameter("s_file_name1")==null?"":request.getParameter("s_file_name1");
	String s_file_name2		= request.getParameter("s_file_name2")==null?"":request.getParameter("s_file_name2");
	String s_file_gubun1		= request.getParameter("s_file_gubun1")==null?"":request.getParameter("s_file_gubun1");
	String s_file_gubun2		= request.getParameter("s_file_gubun2")==null?"":request.getParameter("s_file_gubun2");
	
	if(emp1.getFile_name1().equals("") && !s_file_name1.equals("")){
		//emp1.setFile_name1	(s_file_name1);
		//emp1.setFile_gubun1	(s_file_gubun1);
	}
	if(emp1.getFile_name2().equals("") && !s_file_name2.equals("")){
		//emp1.setFile_name2	(s_file_name2);
		//emp1.setFile_gubun2	(s_file_gubun2);
	}
	
	//=====[commi] update=====
	flag4 = a_db.updateCommiNew(emp1);


	%>
<script language='javascript'>
<%		if(!flag4){	%>	alert('영업수당정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">
  <input type='hidden' name='gubun1'  			value='<%=gubun1%>'>    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>
	var fm = document.form1;	
	
	<%if(doc_no.equals("")){%>
	fm.action = 'commi_doc_i.jsp';
	<%}else{%>
	fm.action = 'commi_doc_u.jsp';
	<%}%>
	fm.target = 'd_content';
	fm.submit();
	
	parent.self.close();
</script>
</body>
</html>