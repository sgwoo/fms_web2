<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="tr_bean" class="acar.car_mst.CarTrimBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	
	String trimChk[] 		= request.getParameterValues("trim_chk"); 
	
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();

	int col_su = trimChk.length;
			
	int count = 0;
	int cnt = 0;
	int ins_trim = 0;
		
	if(col_su >0){

		tr_bean.setCar_comp_id		(car_comp_id);		
		tr_bean.setCar_cd		(car_cd);
		
		count = a_cmb.deleteTrimCol(tr_bean);
		
		for(int i=0; col_su > i ; i++){
			
			StringTokenizer trim_chk = new StringTokenizer(trimChk[i], "^");
			
			tr_bean.setCar_id		(trim_chk.nextToken());
			tr_bean.setCar_u_seq	(trim_chk.nextToken());
			tr_bean.setCar_c_seq	(trim_chk.nextToken());
									
			if(a_cmb.insertTrimCol(tr_bean) >0 ) cnt++;
			
		}
	}
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="./car_col_trim_a.jsp" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
<input type="hidden" name="car_cd" value="<%=car_cd%>">

<script>
<%if(cnt > 0){%>

		alert("<%=cnt%>건이 정상적으로 등록되었습니다.");
		//parent.Search();
		
		var fm=document.form1;	
		var SUBWIN="./car_col_trim.jsp?auth_rw="+fm.auth_rw.value+"&car_comp_id="+fm.car_comp_id.value+"&code="+fm.car_cd.value;
		window.open(SUBWIN, "ColTrimSelect", "left=100, top=100, width=1000, height=700, scrollbars=auto, status=yes, resizable=no");

<%}else{%>
		alert("에러입니다.");
<%}%>
</script>
</form>
</body>
</html>