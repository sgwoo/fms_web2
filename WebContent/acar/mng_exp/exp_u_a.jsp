<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.mng_exp.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<html>
<head><title>FMS</title></head>
<body>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String exp_st = request.getParameter("exp_st")==null?"":request.getParameter("exp_st");
	String est_dt = request.getParameter("est_dt")==null?"":request.getParameter("est_dt");
	
	GenExpBean exp = ex_db.getGenExp(car_mng_id, exp_st, est_dt);
	
	exp.setExp_etc		(request.getParameter("exp_etc")==null?"":request.getParameter("exp_etc"));
	exp.setExp_amt		(request.getParameter("exp_amt")==null?0:Util.parseDigit(request.getParameter("exp_amt")));
	exp.setExp_est_dt	(request.getParameter("exp_est_dt")==null?"":request.getParameter("exp_est_dt"));	
	exp.setExp_dt		(request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt"));
	exp.setExp_start_dt	(request.getParameter("exp_start_dt")==null?"":request.getParameter("exp_start_dt"));
	exp.setExp_end_dt	(request.getParameter("exp_end_dt")==null?"":request.getParameter("exp_end_dt"));
	exp.setPk_dt		(est_dt);
	exp.setCar_ext		(request.getParameter("car_ext")==null?"":request.getParameter("car_ext"));
	exp.setCar_no		(request.getParameter("exp_car_no")==null?"":request.getParameter("exp_car_no"));
	exp.setRtn_cau_dt	(request.getParameter("rtn_cau_dt")==null?"":request.getParameter("rtn_cau_dt"));
	exp.setRtn_cau		(request.getParameter("rtn_cau")==null?"":request.getParameter("rtn_cau"));
	
	exp.setRtn_est_amt	(request.getParameter("rtn_est_amt")==null?0:Util.parseDigit(request.getParameter("rtn_est_amt")));
	exp.setRtn_amt		(request.getParameter("rtn_amt")==null?0:Util.parseDigit(request.getParameter("rtn_amt")));
	exp.setRtn_dt		(request.getParameter("rtn_dt")==null?"":request.getParameter("rtn_dt"));
	exp.setRtn_req_dt	(request.getParameter("rtn_req_dt")==null?"":request.getParameter("rtn_req_dt"));
	
%>
<script language='javascript'>
<%	if(ex_db.updateGenExp(exp)){%>
		alert('수정되었습니다');
		parent.opener.parent.c_head.search();
		parent.close();
<%	}else{%>
		alert('오류발생');
<%	}%>
</script>
</body>
</html>
