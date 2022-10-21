<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.car_service.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String serv_jc = request.getParameter("serv_jc")==null?"":request.getParameter("serv_jc");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");
	String checker = request.getParameter("checker")==null?"":request.getParameter("checker");
	String serv_dt = request.getParameter("serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("serv_dt"));
	String tot_dist = request.getParameter("tot_dist")==null?"0":AddUtil.parseDigit3(request.getParameter("tot_dist"));
	String cust_serv_dt = request.getParameter("cust_serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("cust_serv_dt"));
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String rep_cont = request.getParameter("rep_cont")==null?"":request.getParameter("rep_cont");
	String next_serv_dt = request.getParameter("next_serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("next_serv_dt"));
	String next_rep_cont = request.getParameter("next_rep_cont")==null?"":request.getParameter("next_rep_cont");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	CarServDatabase csD = CarServDatabase.getInstance();
	
	ServiceBean sb = new ServiceBean();
	sb.setCar_mng_id(car_mng_id);
	sb.setServ_id(serv_id);
	sb.setRent_mng_id(rent_mng_id);
	sb.setRent_l_cd(rent_l_cd);
	sb.setServ_jc(serv_jc);
	sb.setServ_st(serv_st);
	sb.setChecker(checker);
	sb.setServ_dt(serv_dt);
	sb.setTot_dist(tot_dist);
	sb.setCust_serv_dt(cust_serv_dt);
	sb.setOff_id(off_id);
	sb.setRep_cont(rep_cont);
	sb.setNext_serv_dt(next_serv_dt);
	sb.setNext_rep_cont(next_rep_cont);

	if(!car_mng_id.equals("")){
		if(gubun.equals("i")){
			serv_id = csD.insertService(sb);
		}else if(gubun.equals("u")){
			serv_id = csD.updateService3(sb);
		}
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(!serv_id.equals("")){
	if(gubun.equals("i")){%>
		alert("등록되었습니다.");
	<%}else if(gubun.equals("u")){%>
		alert("수정되었습니다.");
	<%}%>
//	parent.opener.location.reload();
	parent.location.href = "sub_select_2_s.jsp?auth_rw=<%=auth_rw%>&c_id=<%=car_mng_id%>&serv_id=<%=serv_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&go_url=<%=go_url%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
//	window.close();				
<%}%>
//-->
</script>
</body>
</html>
