<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st");
	
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");					//영업소ID
    String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");					//자동차회사ID
    String car_comp_nm = request.getParameter("car_comp_nm")==null?"":request.getParameter("car_comp_nm");					//자동차회사이름
    String car_off_nm = request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm");					//영업소명
    String car_off_st = request.getParameter("car_off_st")==null?"":request.getParameter("car_off_st");					//영업소구분
    String owner_nm = request.getParameter("owner_nm")==null?"":request.getParameter("owner_nm");					//지점장
    String car_off_tel = request.getParameter("car_off_tel")==null?"":request.getParameter("car_off_tel");					//사무실전화
    String car_off_fax = request.getParameter("car_off_fax")==null?"":request.getParameter("car_off_fax");					//팩스
    String car_off_post = request.getParameter("t_zip")==null?"":request.getParameter("t_zip");				//우편번호
    String car_off_addr = request.getParameter("t_addr")==null?"":request.getParameter("t_addr");				//주소
    String bank = request.getParameter("bank")==null?"":request.getParameter("bank");						//계좌개설은행
    String acc_no = request.getParameter("acc_no")==null?"":request.getParameter("acc_no");						//계좌번호
    String acc_nm = request.getParameter("acc_nm")==null?"":request.getParameter("acc_nm");						//예금주
    String page_gubun = request.getParameter("page_gubun")==null?"":request.getParameter("page_gubun");
	int count = 0;

	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	co_bean.setCar_off_id(car_off_id);
	co_bean.setCar_comp_id(car_comp_id);
	co_bean.setCar_comp_nm(car_comp_nm);
	co_bean.setCar_off_nm(car_off_nm);
	co_bean.setCar_off_st(car_off_st);
	co_bean.setOwner_nm(owner_nm);
	co_bean.setCar_off_tel(car_off_tel);
	co_bean.setCar_off_fax(car_off_fax);
	co_bean.setCar_off_post(car_off_post);
	co_bean.setCar_off_addr(car_off_addr);
	co_bean.setBank(bank);
	co_bean.setAcc_no(acc_no);
	co_bean.setAcc_nm(acc_nm);
	
	count = umd.insertCarOff(co_bean);
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15">
<script language='javascript'>
<%if(page_gubun.equals("NEW")){%>
	alert('정상적으로 등록되었습니다');
	parent.location.href = "search_car_off.jsp?car_comp_id=<%=car_comp_id%>&car_off_nm=<%=car_off_nm%>&gubun_st=<%=gubun_st%>";
<%}else{%>
	alert('등록되지 않았습니다');
<%}%>
</script>
</body>
</html>