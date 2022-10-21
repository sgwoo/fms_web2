<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="session"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] pre = request.getParameterValues("pr");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	

	int result = olpD.setOffls_pre(pre);
			
	
	//재리스견적 계산하기
		
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String car_mng_id = "";
	
	for(int i=0 ; i<pre.length ; i++){
		car_mng_id = pre[i]==null?"":pre[i];
		
		//최근 홈페이지 적용대여료
		Hashtable hp = oh_db.getSecondhandCase_20090901("", "", car_mng_id);
		
		//오늘자 견적이 없으면 돌린다.
		if(!String.valueOf(hp.get("UPLOAD_DT")).equals(AddUtil.getDate(4))){
			//재리스 계산
			String  d_flag1 =  e_db.call_sp_esti_reg_sh(car_mng_id);
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
<%	if(result >= 1){%>
	alert("등록되었습니다.\n오프리스 매각결정 자동차 현황에서 확인하시기 바랍니다.");
	window.top.frames["d_content"].location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
	//parent.parent.location.href = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.top.frames["d_content"].location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
	//parent.c_foot.inner.location.href = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
<%}%>
//-->
</script>
</body>
</html>
