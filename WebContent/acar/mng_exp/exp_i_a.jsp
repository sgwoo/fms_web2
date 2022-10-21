<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.mng_exp.*, acar.car_register.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<html>
<head><title>FMS</title></head>
<body>
<%
	GenExpBean exp = new GenExpBean();
	exp.setExp_st(request.getParameter("exp_st")==null?"":request.getParameter("exp_st"));
	exp.setCar_mng_id(request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"));
	exp.setExp_etc(request.getParameter("exp_etc")==null?"":request.getParameter("exp_etc"));
	exp.setExp_amt(request.getParameter("exp_amt")==null?0:Util.parseDigit(request.getParameter("exp_amt")));
	exp.setExp_est_dt(request.getParameter("exp_est_dt")==null?"":request.getParameter("exp_est_dt"));
	String dt_st = request.getParameter("dt_st")==null?"":request.getParameter("dt_st");
	if(!dt_st.equals("")){
		exp.setExp_start_dt(request.getParameter("exp_start_dt")==null?"":request.getParameter("exp_start_dt"));
		exp.setExp_end_dt(request.getParameter("exp_end_dt")==null?"":request.getParameter("exp_end_dt"));
	}
	
	exp.setCar_ext(request.getParameter("car_ext")==null?"":request.getParameter("car_ext"));
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(exp.getCar_mng_id());
	exp.setCar_no	(cr_bean.getCar_no());
	
	//exp.setCar_ext	(cr_bean.getCar_ext());
%>
<script language='javascript'>
<%
	if(ex_db.insertGenExp(exp))
	{
%>		alert('등록되었습니다');
		parent.opener.parent.c_head.search();
		parent.close();
<%
	}
	else
	{
%>		alert('오류발생');
<%
	}
%>
</script>
</body>
</html>
