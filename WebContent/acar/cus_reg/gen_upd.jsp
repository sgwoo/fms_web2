<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");	
	String serv_jc = request.getParameter("serv_jc")==null?"":request.getParameter("serv_jc");
	String serv_dt = request.getParameter("serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("serv_dt"));
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String ipgoza = request.getParameter("ipgoza")==null?"":request.getParameter("ipgoza");	
	String ipgodt = request.getParameter("ipgodt")==null?"":AddUtil.ChangeString(request.getParameter("ipgodt"));
	String ipgodt_h = request.getParameter("ipgodt_h")==null?"":request.getParameter("ipgodt_h");
	String ipgodt_m = request.getParameter("ipgodt_m")==null?"":request.getParameter("ipgodt_m");
	String chulgoza = request.getParameter("chulgoza")==null?"":request.getParameter("chulgoza");	
	String chulgodt = request.getParameter("chulgodt")==null?"":AddUtil.ChangeString(request.getParameter("chulgodt"));
	String chulgodt_h = request.getParameter("chulgodt_h")==null?"":request.getParameter("chulgodt_h");
	String chulgodt_m = request.getParameter("chulgodt_m")==null?"":request.getParameter("chulgodt_m");
	String cust_act_dt = request.getParameter("cust_act_dt")==null?"":AddUtil.ChangeString(request.getParameter("cust_act_dt")); 	
	String cust_nm = request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");
	String cust_tel = request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");
	String cust_rel = request.getParameter("cust_rel")==null?"":request.getParameter("cust_rel");
	int sup_amt = request.getParameter("sup_amt")==null?0:AddUtil.parseDigit(request.getParameter("sup_amt"));
	int add_amt = request.getParameter("add_amt")==null?0:AddUtil.parseDigit(request.getParameter("add_amt"));
	int rep_amt = request.getParameter("rep_amt")==null?0:AddUtil.parseDigit(request.getParameter("rep_amt"));
	int dc = request.getParameter("dc")==null?0:AddUtil.parseDigit(request.getParameter("dc"));
	int tot_amt = request.getParameter("tot_amt")==null?0:AddUtil.parseDigit(request.getParameter("tot_amt"));
	//순회점검
	String checker = request.getParameter("checker")==null?"":request.getParameter("checker");
	String spdchk_dt = request.getParameter("spdchk_dt")==null?"":AddUtil.ChangeString(request.getParameter("spdchk_dt"));
	String tot_dist = request.getParameter("tot_dist")==null?"0":AddUtil.parseDigit3(request.getParameter("tot_dist"));
	String next_serv_dt = request.getParameter("next_serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("next_serv_dt"));
	String rep_cont = request.getParameter("rep_cont")==null?"":request.getParameter("rep_cont");
	String checker_st = request.getParameter("checker_st")==null?"":request.getParameter("checker_st");
	//운행,사고자차건 
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd"); 
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id"); 
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st"); 
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	//결재일
	String set_dt = request.getParameter("set_dt")==null?"":AddUtil.ChangeString(request.getParameter("set_dt")); 
	
	if(!ipgodt.equals("")){
		ipgodt = ipgodt+ipgodt_h+ipgodt_m;
	}
	if(ipgodt.equals("0000") || ipgodt.equals("0000    0000")){
		ipgodt = "";
	}
	if(!chulgodt.equals("")){
		chulgodt = chulgodt+chulgodt_h+chulgodt_m;
	}
	if(chulgodt.equals("0000") || chulgodt.equals("0000    0000")){
		chulgodt = "";
	}
	
		//serv_st : 4.5->13
	if (  serv_st.equals("4") ||  serv_st.equals("5")   )   {	
	       serv_st = "13";    
	}
	
	// 정산용
	int r_labor = request.getParameter("r_labor")==null?0:AddUtil.parseDigit(request.getParameter("r_labor"));
	int r_amt = request.getParameter("r_amt")==null?0:AddUtil.parseDigit(request.getParameter("r_amt"));
	int r_dc = request.getParameter("r_dc")==null?0:AddUtil.parseDigit(request.getParameter("r_dc"));
	int r_j_amt = request.getParameter("r_j_amt")==null?0:AddUtil.parseDigit(request.getParameter("r_j_amt"));
	
	int result=0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(rent_mng_id.equals("") || rent_l_cd.equals("")){
		Hashtable ht = c_db.getRent_id(car_mng_id);
		rent_mng_id = (String)ht.get("RENT_MNG_ID");
		rent_l_cd 	= (String)ht.get("RENT_L_CD");
	}
	
	ServInfoBean siBn = new ServInfoBean();
	siBn.setCar_mng_id(car_mng_id);
	siBn.setServ_id(serv_id);
	siBn.setRent_mng_id(rent_mng_id);
	siBn.setRent_l_cd(rent_l_cd);
	siBn.setServ_st(serv_st);
	siBn.setServ_jc(serv_jc);
	siBn.setServ_dt(serv_dt);
	siBn.setOff_id(off_id);
	siBn.setIpgoza(ipgoza);
	siBn.setIpgodt(ipgodt);
	siBn.setChulgoza(chulgoza);
	siBn.setChulgodt(chulgodt);
	siBn.setCust_act_dt(cust_act_dt);
	siBn.setCust_nm(cust_nm);
	siBn.setCust_tel(cust_tel);
	siBn.setCust_rel(cust_rel);
	siBn.setSup_amt(sup_amt);
	siBn.setAdd_amt(add_amt);
	siBn.setRep_amt(rep_amt);
	siBn.setDc(dc);
	siBn.setTot_amt(tot_amt);
	//순회점검
	siBn.setChecker(checker);
	siBn.setSpdchk_dt(spdchk_dt);
	siBn.setTot_dist(tot_dist);
	siBn.setNext_serv_dt(next_serv_dt);
	siBn.setRep_cont(rep_cont);
	siBn.setChecker_st(checker_st);
	//운행,사고자차건
	siBn.setAccid_id(accid_id);
	//결제일
	siBn.setSet_dt(set_dt);
	siBn.setUpdate_id(ck_acar_id);
	//정산용
	siBn.setR_labor(r_labor);
	siBn.setR_amt(r_amt);
	siBn.setR_dc(r_dc);
	siBn.setR_j_amt(r_j_amt);
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	if(car_mng_id.equals("") || serv_id.equals("")){
		result = 3;
	}else{
	 	result = cr_db.updateService_g1(siBn);
	}
	
	//로그인 사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result==1){%>
	alert("정비내용이 등록되었습니다.");
	parent.opener.location.reload();
	parent.window.close();
<%}else if(result == 3){%>
	alert("car_mng_id 또는 serv_id가 없습니다.\n 확인하십시오");
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");					
<%}%>
//-->
</script>
</body>
</html>
