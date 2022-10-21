<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.short_fee_mng.*" %>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	String kind 		= request.getParameter("kind")==null?"":request.getParameter("kind");
	String section 		= request.getParameter("section")==null?"":request.getParameter("section");
	String stand_car 	= request.getParameter("stand_car")==null?"":request.getParameter("stand_car");
	String reg_dt	 	= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int flag = 0;
	
	String amt_12h[] = request.getParameterValues("amt_12h");
	String amt_01d[] = request.getParameterValues("amt_01d");
	String amt_02d[] = request.getParameterValues("amt_02d");
	String amt_03d[] = request.getParameterValues("amt_03d");
	String amt_04d[] = request.getParameterValues("amt_04d");
	String amt_05d[] = request.getParameterValues("amt_05d");
	String amt_06d[] = request.getParameterValues("amt_06d");
	String amt_07d[] = request.getParameterValues("amt_07d");
	String amt_08d[] = request.getParameterValues("amt_08d");
	String amt_09d[] = request.getParameterValues("amt_09d");
	String amt_10d[] = request.getParameterValues("amt_10d");
	String amt_11d[] = request.getParameterValues("amt_11d");
	String amt_12d[] = request.getParameterValues("amt_12d");
	String amt_13d[] = request.getParameterValues("amt_13d");
	String amt_14d[] = request.getParameterValues("amt_14d");
	String amt_15d[] = request.getParameterValues("amt_15d");
	String amt_16d[] = request.getParameterValues("amt_16d");
	String amt_17d[] = request.getParameterValues("amt_17d");
	String amt_18d[] = request.getParameterValues("amt_18d");
	String amt_19d[] = request.getParameterValues("amt_19d");
	String amt_20d[] = request.getParameterValues("amt_20d");
	String amt_21d[] = request.getParameterValues("amt_21d");
	String amt_22d[] = request.getParameterValues("amt_22d");
	String amt_23d[] = request.getParameterValues("amt_23d");
	String amt_24d[] = request.getParameterValues("amt_24d");
	String amt_25d[] = request.getParameterValues("amt_25d");
	String amt_26d[] = request.getParameterValues("amt_26d");
	String amt_27d[] = request.getParameterValues("amt_27d");
	String amt_28d[] = request.getParameterValues("amt_28d");
	String amt_29d[] = request.getParameterValues("amt_29d");
	String amt_30d[] = request.getParameterValues("amt_30d");
	String amt_01m[] = request.getParameterValues("amt_01m");
	String amt_02m[] = request.getParameterValues("amt_02m");
	String amt_03m[] = request.getParameterValues("amt_03m");
	String amt_04m[] = request.getParameterValues("amt_04m");
	String amt_05m[] = request.getParameterValues("amt_05m");
	String amt_06m[] = request.getParameterValues("amt_06m");
	String amt_07m[] = request.getParameterValues("amt_07m");
	String amt_08m[] = request.getParameterValues("amt_08m");
	String amt_09m[] = request.getParameterValues("amt_09m");
	String amt_10m[] = request.getParameterValues("amt_10m");
	String amt_11m[] = request.getParameterValues("amt_11m");
	
	
	for(int i=0; i<2; i++){
		ShortFeeMngBean bean = new ShortFeeMngBean();
		bean.setKind		(kind);
		bean.setSection		(section);
		bean.setFee_st		(Integer.toString(i+1));
		bean.setAmt_12h		(AddUtil.parseDigit(amt_12h[i]));
		bean.setAmt_01d		(AddUtil.parseDigit(amt_01d[i]));
		bean.setAmt_02d		(AddUtil.parseDigit(amt_02d[i]));
		bean.setAmt_03d		(AddUtil.parseDigit(amt_03d[i]));
		bean.setAmt_04d		(AddUtil.parseDigit(amt_04d[i]));
		bean.setAmt_05d		(AddUtil.parseDigit(amt_05d[i]));
		bean.setAmt_06d		(AddUtil.parseDigit(amt_06d[i]));
		bean.setAmt_07d		(AddUtil.parseDigit(amt_07d[i]));
		bean.setAmt_08d		(AddUtil.parseDigit(amt_08d[i]));
		bean.setAmt_09d		(AddUtil.parseDigit(amt_09d[i]));
		bean.setAmt_10d		(AddUtil.parseDigit(amt_10d[i]));
		bean.setAmt_11d		(AddUtil.parseDigit(amt_11d[i]));
		bean.setAmt_12d		(AddUtil.parseDigit(amt_12d[i]));
		bean.setAmt_13d		(AddUtil.parseDigit(amt_13d[i]));
		bean.setAmt_14d		(AddUtil.parseDigit(amt_14d[i]));
		bean.setAmt_15d		(AddUtil.parseDigit(amt_15d[i]));
		bean.setAmt_16d		(AddUtil.parseDigit(amt_16d[i]));
		bean.setAmt_17d		(AddUtil.parseDigit(amt_17d[i]));
		bean.setAmt_18d		(AddUtil.parseDigit(amt_18d[i]));
		bean.setAmt_19d		(AddUtil.parseDigit(amt_19d[i]));
		bean.setAmt_20d		(AddUtil.parseDigit(amt_20d[i]));
		bean.setAmt_21d		(AddUtil.parseDigit(amt_21d[i]));
		bean.setAmt_22d		(AddUtil.parseDigit(amt_22d[i]));
		bean.setAmt_23d		(AddUtil.parseDigit(amt_23d[i]));
		bean.setAmt_24d		(AddUtil.parseDigit(amt_24d[i]));
		bean.setAmt_25d		(AddUtil.parseDigit(amt_25d[i]));
		bean.setAmt_26d		(AddUtil.parseDigit(amt_26d[i]));
		bean.setAmt_27d		(AddUtil.parseDigit(amt_27d[i]));
		bean.setAmt_28d		(AddUtil.parseDigit(amt_28d[i]));
		bean.setAmt_29d		(AddUtil.parseDigit(amt_29d[i]));
		bean.setAmt_30d		(AddUtil.parseDigit(amt_30d[i]));
		bean.setAmt_01m		(AddUtil.parseDigit(amt_01m[i]));
		bean.setAmt_02m		(AddUtil.parseDigit(amt_02m[i]));
		bean.setAmt_03m		(AddUtil.parseDigit(amt_03m[i]));
		bean.setAmt_04m		(AddUtil.parseDigit(amt_04m[i]));
		bean.setAmt_05m		(AddUtil.parseDigit(amt_05m[i]));
		bean.setAmt_06m		(AddUtil.parseDigit(amt_06m[i]));
		bean.setAmt_07m		(AddUtil.parseDigit(amt_07m[i]));
		bean.setAmt_08m		(AddUtil.parseDigit(amt_08m[i]));
		bean.setAmt_09m		(AddUtil.parseDigit(amt_09m[i]));
		bean.setAmt_10m		(AddUtil.parseDigit(amt_10m[i]));
		bean.setAmt_11m		(AddUtil.parseDigit(amt_11m[i]));
		bean.setUpdate_id	(user_id);
		bean.setStand_car	(stand_car);
		bean.setReg_dt		(reg_dt);
		if(cmd.equals("i") || cmd.equals("up")){
			if(!sfm_db.insertShortFeeMng(bean)) flag = 1;
			reg_dt = AddUtil.getDate(4);
		}else if(cmd.equals("u")){
//System.out.println("reg_dt: "+reg_dt);		
			if(!sfm_db.updateShortFeeMng(bean)) flag = 1;
		}
	}
%>
<form name='form1' action='short_fee_mng_u.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type='hidden' name='section' value='<%=section%>'>
<input type="hidden" name="reg_dt" value="<%=reg_dt%>">
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag != 0){%>
		alert('수정오류발생!');
<%	}else{%>
		alert('수정되었습니다.');
		fm.submit();				
<%	}%>
</script>
</body>
</html>