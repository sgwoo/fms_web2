<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_mst.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String a_b = request.getParameter("a_b")==null?"36":request.getParameter("a_b");
	String a_e = "";
	String g_8 = "";
	//String o_13 = "";
	String lpg_yn = request.getParameter("lpg_yn")==null?"0":request.getParameter("lpg_yn");
	
	a_a = "1";//a_a.substring(0,1);
	
	//소분류, 기본보증금율, 최대잔가율
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	a_e = e_db.getA_e(car_comp_id, code, car_id, car_seq);
	
	if(!a_a.equals(""))	g_8 = e_db.getVar("comm", "g_8", a_a, a_e);
	
	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
	
	float o_13 = e_db.getJanga(car_id, car_seq, a_b, lpg_yn);

	// 20051122 42개월 -2%,48개월 -4% 최대잔가 줄임.
	if(a_b.equals("42") || a_b.equals("48")){
		o_13 = o_13 - ((AddUtil.parseInt(a_b)-36)/3/100f);
	}
		
	/*if(a_b.equals("48")){
		o_13 = e_db.getVar("car", "o_13_7", a_a, a_e);
	}else if(a_b.equals("42")){
		o_13 = e_db.getVar("car", "o_13_6", a_a, a_e);
	}else if(a_b.equals("36")){
		o_13 = e_db.getVar("car", "o_13_5", a_a, a_e);
	}else if(a_b.equals("30")){
		o_13 = e_db.getVar("car", "o_13_4", a_a, a_e);
	}else if(a_b.equals("24")){
		o_13 = e_db.getVar("car", "o_13_3", a_a, a_e);
	}else if(a_b.equals("18")){
		o_13 = e_db.getVar("car", "o_13_2", a_a, a_e);
	}else if(a_b.equals("12")){
		o_13 = e_db.getVar("car", "o_13_1", a_a, a_e);
	}*/
	
%>

<html>
<head>
<title>FMS</title>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	var fm = parent.document.form1;	
	fm.a_e.value = '<%=a_e%>';
//	fm.rg_8.value = '<%=g_8%>';
	fm.rg_8_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * 20/100);
//	fm.g_8.value = '<%=g_8%>';
	fm.ro_13.value = '<%=o_13 * 100 %>';		
	fm.o_13.value = '<%=o_13 * 100 %>';	
	fm.ro_13_amt.value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.ro_13.value)/100);	
</script>
</body>
</html>
