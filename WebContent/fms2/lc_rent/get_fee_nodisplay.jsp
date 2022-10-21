<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<%
	//계약등록시 입력값에 따른 변수 셋팅 페이지
	
	String r_way 			=  request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
	String rent_start_dt		=  request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	
	int t_con_mon 			=  request.getParameter("con_mon")==null?0:AddUtil.parseInt(request.getParameter("con_mon"));
	int t_con_day 			=  request.getParameter("con_day")==null?0:AddUtil.parseInt(request.getParameter("con_day"));
	int fee_pay_tm 			=  request.getParameter("fee_pay_tm")==null?0:AddUtil.parseInt(request.getParameter("fee_pay_tm"));
	int pere_r_mth 			=  request.getParameter("pere_r_mth")==null?0:AddUtil.parseInt(request.getParameter("pere_r_mth"));
	
	String cng_item  		= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String fee_fst_dt  		= request.getParameter("fee_fst_dt")==null?"":request.getParameter("fee_fst_dt");
	String car_st	  		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String fee_amt	  		= request.getParameter("fee_amt")==null?"":AddUtil.replace(request.getParameter("fee_amt"),",","");
	String t_fee_amt	  	= request.getParameter("t_fee_amt")==null?"":AddUtil.replace(request.getParameter("t_fee_amt"),",","");
	String fee_rent_st 		= request.getParameter("fee_rent_st")==null?"1":request.getParameter("fee_rent_st");
	
	
	String rent_end_dt="";
	String fee_st_dt="";
	String fee_end_dt="";
	
	String fee_fst_amt ="";
	
	if(pere_r_mth>0)		fee_pay_tm = t_con_mon - pere_r_mth;
	else 				fee_pay_tm = t_con_mon;
	
	if(t_con_mon==0){
		fee_pay_tm = 1;
	}
	if(fee_pay_tm>1){
		fee_fst_amt = fee_amt;		
	}else{
		fee_fst_amt = t_fee_amt;
	}
	
	// 대여기간 (대여개시일 ~ 대여개시일+계약개월수-1일)
	CommonDataBase c_db = CommonDataBase.getInstance();
	rent_end_dt = c_db.addMonth(rent_start_dt, t_con_mon);
	

	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);	
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	String base_dt = rent_start_dt;
	
	if(!fee.getRent_start_dt().equals("")){
		base_dt = fee.getRent_start_dt();
	}
	
	//20170421 기준변경 (예)대여기간 2017-04-18 ~ 2020-04-18
	if((base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(base_dt,"-","")) >= 20170421 && fee_rent_st.equals("1")){
		rent_end_dt = rent_end_dt;
	}else{
		rent_end_dt = c_db.addDay(rent_end_dt, -1);
	}
	
	//일 추가
	if(t_con_day >0 && car_st.equals("4")){
		rent_end_dt = c_db.addDay(rent_end_dt, t_con_day);
	}
	
	fee_fst_dt = rent_start_dt;
	fee_end_dt = rent_end_dt;

%>

	parent.document.form1.rent_start_dt.value		= '<%=rent_start_dt%>';
	parent.document.form1.rent_end_dt.value 		= ChangeDate3('<%=rent_end_dt%>');
	parent.document.form1.fee_pay_tm.value 			= '<%=fee_pay_tm%>';
	parent.document.form1.fee_pay_start_dt.value 		= '<%=fee_fst_dt%>';
	parent.document.form1.fee_pay_end_dt.value 		= ChangeDate3('<%=fee_end_dt%>');	
	parent.document.form1.fee_fst_amt.value 		= '<%=fee_fst_amt%>';
</script>
</body>
</html>
