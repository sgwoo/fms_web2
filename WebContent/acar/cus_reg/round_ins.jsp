<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*, acar.estimate_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");	
	String checker = request.getParameter("checker")==null?"":request.getParameter("checker");
	String spdchk_dt = request.getParameter("spdchk_dt")==null?"":AddUtil.ChangeString(request.getParameter("spdchk_dt"));
	String tot_dist = request.getParameter("tot_dist")==null?"0":AddUtil.parseDigit3(request.getParameter("tot_dist"));
	String next_serv_dt = request.getParameter("next_serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("next_serv_dt"));
	String rep_cont = request.getParameter("rep_cont")==null?"":request.getParameter("rep_cont");
	String checker_st = request.getParameter("checker_st")==null?"":request.getParameter("checker_st");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String chk_ids = "";


	//로그인 사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){
	
	
	}else{
		
		Enumeration e = request.getParameterNames();
		while(e.hasMoreElements()){
			String name = (String)e.nextElement();
			String value = request.getParameter(name);
			if(name.length()>5 && name.substring(0,5).equals("radio")){
				chk_ids += (value+":"+name+"/");
			}
		}	
	}
		
	ServInfoBean siBn = new ServInfoBean();
	siBn.setCar_mng_id(car_mng_id);
	siBn.setServ_id(serv_id);
	siBn.setRent_mng_id(rent_mng_id);
	siBn.setRent_l_cd(rent_l_cd);
	siBn.setServ_st(serv_st);
	siBn.setServ_dt(spdchk_dt);
	siBn.setChecker(checker);
	siBn.setSpdchk_dt(spdchk_dt);
	siBn.setTot_dist(tot_dist);
	siBn.setNext_serv_dt(next_serv_dt);
	siBn.setRep_cont(rep_cont);
	siBn.setChecker_st(checker_st);
	siBn.setSpd_chk(chk_ids);
	siBn.setReg_id(user_id);
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.updateService(siBn);
	
	
	
	if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){
	
		EstiDatabase e_db = EstiDatabase.getInstance();
		
		//재리스견적 다시 내기
		String  d_flag1 = e_db.call_sp_esti_reg_sh(car_mng_id);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result>0){%>
	alert("순회점검 내용이 등록되었습니다.");
	
	<%if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){%>
	parent.opener.location.reload();
	parent.window.close();
	<%}else{%>	
	parent.location.href = "serv_reg.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>";
	parent.opener.location.reload();
	<%}%>
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");					
<%}%>
//-->
</script>
</body>
</html>
