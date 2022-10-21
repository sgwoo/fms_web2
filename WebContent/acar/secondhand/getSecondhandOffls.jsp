<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.estimate_mng.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String car_mng_id 	= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
	String rent_dt 		= request.getParameter("rent_dt")	==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");
	String today_dist	= request.getParameter("today_dist")	==null?"":request.getParameter("today_dist");
	
	out.println(car_mng_id);
	out.println(rent_dt);
	out.println(today_dist);
	
	String reg_code  = "O"+Long.toString(System.currentTimeMillis());
	
	//P_ESTI_REG_SH_OFFLS(V_REG_CODE IN VARCHAR2, V_RENT_DT IN VARCHAR2, V_CAR_MNG_ID IN VARCHAR2, V_TODAY_DIST IN VARCHAR2)
                     
	//재리스 계산
	String  d_flag1 =  e_db.call_sp_esti_reg_sh_offls(reg_code, rent_dt, car_mng_id, today_dist);
	
	EstimateBean o_bean = e_db.getEstimateCase(reg_code, "");
	
	Hashtable esti_exam = e_db.getEstimateResultVar(o_bean.getEst_id(), "esti_exam");
	
	Vector vt = e_db.getEstiMateResultCaramtList("estimate", o_bean.getEst_id());
	int vt_size = vt.size();
	
	out.println(reg_code);
	out.println(o_bean.getEst_id());
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--


//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
	<input type="hidden" name="est_id" value="<%=o_bean.getEst_id()%>">
</form>	
<script>
<!--
		<%if(!o_bean.getEst_id().equals("")){%>
			alert('견적완료');
				
			//결과값 처리하기---------------------------------------------------------------
			parent.document.form1.o_s_amt.value 		= parseDecimal(<%=o_bean.getO_1()%>);
		
			<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
			var fm = document.form1;
			fm.action = "getSecondhandOffls_result.jsp";
			fm.target = '_blank';
			fm.submit();
			<%}%>
			
		<%}%>
//-->
</script>	
</body>
</html>
