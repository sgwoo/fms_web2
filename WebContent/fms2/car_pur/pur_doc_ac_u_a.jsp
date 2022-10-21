<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.tint.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
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
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit		= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag9 = true;
	int result = 0;
	
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//중고차딜러
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "5");
	//중고차판매처
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
%>


<%
	//4. 출고정보 car_pur--------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	pur.setTrf_amt1		(request.getParameter("trf_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt1")));
	pur.setTrf_st1		(request.getParameter("trf_st1")	==null?"":request.getParameter("trf_st1"));
	pur.setCard_kind1	(request.getParameter("card_kind1")	==null?"":request.getParameter("card_kind1"));
	pur.setCardno1		(request.getParameter("cardno1")	==null?"":request.getParameter("cardno1"));
	pur.setTrf_cont1	(request.getParameter("trf_cont1")	==null?"":request.getParameter("trf_cont1"));
	pur.setAcc_st1		(request.getParameter("acc_st1")	==null?"":request.getParameter("acc_st1"));
	
	pur.setTrf_amt2		(request.getParameter("trf_amt2").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt2")));
	pur.setTrf_st2		(request.getParameter("trf_st2")	==null?"":request.getParameter("trf_st2"));
	pur.setCard_kind2	(request.getParameter("card_kind2")	==null?"":request.getParameter("card_kind2"));
	pur.setCardno2		(request.getParameter("cardno2")	==null?"":request.getParameter("cardno2"));
	pur.setTrf_cont2	(request.getParameter("trf_cont2")	==null?"":request.getParameter("trf_cont2"));
	pur.setAcc_st2		(request.getParameter("acc_st2")	==null?"":request.getParameter("acc_st2"));
	
	pur.setTrf_amt3		(request.getParameter("trf_amt3").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt3")));
	pur.setTrf_st3		(request.getParameter("trf_st3")	==null?"":request.getParameter("trf_st3"));
	pur.setCard_kind3	(request.getParameter("card_kind3")	==null?"":request.getParameter("card_kind3"));
	pur.setCardno3		(request.getParameter("cardno3")	==null?"":request.getParameter("cardno3"));
	pur.setTrf_cont3	(request.getParameter("trf_cont3")	==null?"":request.getParameter("trf_cont3"));
	pur.setAcc_st3		(request.getParameter("acc_st3")	==null?"":request.getParameter("acc_st3"));
	
	pur.setEst_car_no	(request.getParameter("est_car_no")	==null?"":request.getParameter("est_car_no"));
	pur.setCar_num		(request.getParameter("car_num")	==null?"":request.getParameter("car_num"));
	pur.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
	pur.setCon_amt_cont(request.getParameter("con_amt_cont")	==null?"":request.getParameter("con_amt_cont"));
	pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
	pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
	pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
	pur.setPur_est_dt	(request.getParameter("pur_est_dt")	==null?"":request.getParameter("pur_est_dt"));
	
	//=====[CAR_PUR] update=====
	flag4 = a_db.updateContPur(pur);
	

	emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
	emp1.setEmp_acc_no(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
	emp1.setEmp_acc_nm(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
	
	if(!emp1.getRent_mng_id().equals("")){
		//=====[commi] update=====
		flag9 = a_db.updateCommiNew(emp1);
	}
	
		
	//5. 차량기본정보 car_etc-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String reg_est_dt 	= request.getParameter("reg_est_dt")==null?"":request.getParameter("reg_est_dt");
	String reg_est_h 	= request.getParameter("reg_est_h")==null?"":request.getParameter("reg_est_h");
	
	car.setReg_est_dt	(reg_est_dt+reg_est_h);
	car.setCar_ext		(request.getParameter("car_ext")	==null?"":request.getParameter("car_ext"));
	
	//=====[car_etc] update=====
	flag5 = a_db.updateContCarNew(car);
	
	
	

	%>
<script language='javascript'>
<%		if(!flag4){	%>	alert('출고정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
<%		if(!flag5){	%>	alert('차량정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">   
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>      
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>        
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='mode'	 			value='<%=mode%>'>     
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'pur_doc_ac_u.jsp';
	fm.target = 'd_content';	
	
	if(fm.from_page.value == '/fms2/car_pur/pur_pay_frame.jsp'){
		fm.action = '<%=from_page%>';
		fm.target = 'd_content';
		parent.window.close();
	}
	
	fm.submit();
</script>
</body>
</html>