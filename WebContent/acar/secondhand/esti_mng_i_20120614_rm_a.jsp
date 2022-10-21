<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.secondhand.*, acar.car_register.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="session"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
		
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");
	String damdang_id	= request.getParameter("damdang_id2")==null?"":request.getParameter("damdang_id2");
	String cust_tel		= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");
	String cust_fax 	= request.getParameter("cust_fax")==null?"":request.getParameter("cust_fax");
	String cust_email 	= request.getParameter("cust_email")==null?"":request.getParameter("cust_email");	
	String doc_type 	= request.getParameter("doc_type")==null?"":request.getParameter("doc_type");
	
	String months	 	= request.getParameter("months")	==null?"1":request.getParameter("months");
	String days	 	= request.getParameter("days")		==null?"0":request.getParameter("days");
	
	String tot_rm 		= request.getParameter("tot_rm")	==null?"":request.getParameter("tot_rm");
	String tot_rm1 		= request.getParameter("tot_rm1")	==null?"":request.getParameter("tot_rm1");
	String per 		= request.getParameter("per_rm")	==null?"":request.getParameter("per_rm");
	String navi_yn 		= request.getParameter("navi_yn")	==null?"":request.getParameter("navi_yn");
	
	

	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	//최근 홈페이지 적용대여료 - 월대여료
	Hashtable hp = oh_db.getSecondhandCaseRm("", "", car_mng_id);	
		
	//견적정보
	String est_id = shDb.getSearchEstIdShRm(car_mng_id, "21", "1", "", String.valueOf(hp.get("REAL_KM")), String.valueOf(hp.get("UPLOAD_DT")), String.valueOf(hp.get("RM1")), String.valueOf(hp.get("REG_CODE")));
	e_bean = e_db.getEstimateShCase(est_id);		
	
		
	
	e_bean.setEst_nm		(cust_nm);
	if(damdang_id.equals("")){
		e_bean.setReg_id	(user_id);
	}else{
		e_bean.setReg_id	(damdang_id);
	}
	e_bean.setEst_tel		(cust_tel);
	e_bean.setEst_fax		(cust_fax);	
	e_bean.setEst_email		(cust_email.trim());
	e_bean.setDoc_type		(doc_type);
	e_bean.setEst_from		("rm_car");
	e_bean.setEst_type		("S");
					
	//견적관리번호 생성
	est_id = Long.toString(System.currentTimeMillis());	
	
	//fms2에서 견적함.
	if(AddUtil.lengthb(est_id) < 15)	est_id = est_id+""+"2";
		
	e_bean.setEst_id		(est_id);
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	e_bean.setReg_code		(reg_code);
		
	e_bean.setMonths		(months);
	e_bean.setDays			(days);
	e_bean.setTot_rm		(tot_rm);
	e_bean.setTot_rm1		(tot_rm1);	
	e_bean.setPer			(per);
	e_bean.setNavi_yn		(navi_yn);	
	
	
		
	count = e_db.insertEstimate(e_bean);
	
	
	//20220812 무조건 1개월 견적이고, 네비별도 관리 안하므로 미사용 정리 - 몇해전부터 안쓰나 현재 정리함. 
	//count = e_db.insertEstiRm(e_bean);
	
	
	
		
		

%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	//견적섭기
	function go_esti_print(){  
		var fm = document.form1;
		
			fm.action = "/acar/secondhand_hp/estimate_rm_new.jsp";
				
		
/*		
		//할인율		
		var amt_per = 0;				
		if(toInt(fm.months.value)==1){
			amt_per 	= (4/100)*toInt(fm.days.value)/30;
		}			
		if(toInt(fm.months.value)==2){
			amt_per 	= (4/100) + ((2/100)*toInt(fm.days.value)/30);
		}							
		if(toInt(fm.months.value) > 2){
			amt_per 	= 6/100;
		}												
		amt_per 		= parseDecimal(amt_per*1000)/1000;			
		fm.per.value 		= amt_per;
			
		
		//적용월대여료
		fm.tot_rm.value 	= parseDecimal( th_rnd(<%=e_bean.getFee_s_amt()%> * (1-amt_per)) ) ;
		
				
		//산출대여료
		var fee_s_amt 		= toInt(parseDigit(fm.tot_rm.value));			
		fee_s_amt 		= parseDecimal( (fee_s_amt*toInt(fm.months.value)) + (fee_s_amt/30*toInt(fm.days.value)) );		
		fm.tot_rm1.value 	= fee_s_amt;
*/
	
				
		fm.submit();
	}		
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="br_id" 		value="<%=br_id%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="acar_id" 		value="<%=ck_acar_id%>">  
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>     
  <input type="hidden" name="car_mng_id" 	value="<%=car_mng_id%>">  
  <input type="hidden" name="a_a"		value="<%=e_bean.getA_a()%>">
  <input type="hidden" name="a_b"		value="<%=e_bean.getA_b()%>">
  <input type="hidden" name="o_1"		value="<%=e_bean.getO_1()%>">  
  <input type="hidden" name="rent_dt"		value="<%=e_bean.getRent_dt()%>">
  <input type="hidden" name="amt"		value="<%=e_bean.getFee_s_amt()%>">      
  <input type="hidden" name="est_code"		value="<%=reg_code%>">
  <input type="hidden" name="from_page"		value="<%=from_page%>">  
  <input type="hidden" name="tot_rm"		value="<%=tot_rm%>">  
  <input type="hidden" name="tot_rm1"		value="<%=tot_rm1%>">  
  <input type="hidden" name="months"		value="<%=months%>">  
  <input type="hidden" name="days"		value="<%=days%>">  
  <input type="hidden" name="per"		value="<%=per%>">  
  <input type="hidden" name="navi_yn"		value="<%=navi_yn%>">  
  <input type="hidden" name="content_st"		value="sh_rm_fms_new">  
 
</form>
<script>
<!--
	go_esti_print();		
//-->
</script>
</body>
</html>
