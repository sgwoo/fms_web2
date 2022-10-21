<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.asset.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="bean" class="acar.offls_actn.Offls_sui_etcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String comm_date = request.getParameter("comm_date")==null?"":request.getParameter("comm_date");
	int comm1_sup = request.getParameter("comm1_sup")==null?0:AddUtil.parseDigit(request.getParameter("comm1_sup"));
	int comm1_vat = request.getParameter("comm1_vat")==null?0:AddUtil.parseDigit(request.getParameter("comm1_vat"));
	int comm1_tot = request.getParameter("comm1_tot")==null?0:AddUtil.parseDigit(request.getParameter("comm1_tot"));
	int comm2_sup = request.getParameter("comm2_sup")==null?0:AddUtil.parseDigit(request.getParameter("comm2_sup"));
	int comm2_vat = request.getParameter("comm2_vat")==null?0:AddUtil.parseDigit(request.getParameter("comm2_vat"));
	int comm2_tot = request.getParameter("comm2_tot")==null?0:AddUtil.parseDigit(request.getParameter("comm2_tot"));
	int comm3_sup = request.getParameter("comm3_sup")==null?0:AddUtil.parseDigit(request.getParameter("comm3_sup"));
	int comm3_vat = request.getParameter("comm3_vat")==null?0:AddUtil.parseDigit(request.getParameter("comm3_vat"));
	int comm3_tot = request.getParameter("comm3_tot")==null?0:AddUtil.parseDigit(request.getParameter("comm3_tot"));
	
	int comm4_sup = request.getParameter("comm4_sup")==null?0:AddUtil.parseDigit(request.getParameter("comm4_sup"));
	int comm4_vat = request.getParameter("comm4_vat")==null?0:AddUtil.parseDigit(request.getParameter("comm4_vat"));
	int comm4_tot = request.getParameter("comm4_tot")==null?0:AddUtil.parseDigit(request.getParameter("comm4_tot"));
	
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	AssetDatabase as_db = AssetDatabase.getInstance();

	//신규 또는 수정
	int cnt = as_db.getSuiEtcCount(car_mng_id);

//	System.out.println("car_mng_id=" + car_mng_id + ":cnt=" + cnt); 
	bean.setCar_mng_id(car_mng_id);
	bean.setComm_date(comm_date);
	bean.setComm1_sup(comm1_sup);
	bean.setComm1_vat(comm1_vat);
	bean.setComm1_tot(comm1_tot);
	bean.setComm2_sup(comm2_sup);
	bean.setComm2_vat(comm2_vat);
	bean.setComm2_tot(comm2_tot);
	bean.setComm3_sup(comm3_sup);
	bean.setComm3_vat(comm3_vat);
	bean.setComm3_tot(comm3_tot);
//	bean.setComm4_sup(comm4_sup);
//	bean.setComm4_vat(comm4_vat);
//	bean.setComm4_tot(comm4_tot);
	int result = 0;
	
	if (cnt > 0) {
		result = as_db.updateSuiEtc(bean);
	} else {
	    result = as_db.insertSuiEtc(bean);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result > 0){ %>
	alert("수정 되었읍니다.");
	parent.location.href = "off_ls_sui_reg_sugum.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.location.href = "off_ls_sui_reg_sugum.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}%>
//-->
</script>
</body>
</html>
