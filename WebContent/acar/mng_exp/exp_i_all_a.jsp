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
	String exp_st = request.getParameter("exp_st")==null?"":request.getParameter("exp_st");
	String exp_est_dt = request.getParameter("exp_est_dt")==null?"":request.getParameter("exp_est_dt");	
	String dt_st = request.getParameter("dt_st")==null?"":request.getParameter("dt_st");
	String exp_start_dt = request.getParameter("exp_start_dt")==null?"":request.getParameter("exp_start_dt");
	String exp_end_dt = request.getParameter("exp_end_dt")==null?"":request.getParameter("exp_end_dt");			
	String car_ext = request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String[] car_mng_id = request.getParameterValues("car_mng_id");
	String[] exp_amt = request.getParameterValues("exp_amt");
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	int flag = 0;
	for(int i = 0 ; i < 10 ; i++){
		if(!car_mng_id[i].equals("")){
			GenExpBean exp = new GenExpBean();
			exp.setExp_st(exp_st);
			exp.setCar_mng_id(car_mng_id[i]);
			exp.setExp_amt(Util.parseDigit(exp_amt[i]));
			exp.setExp_est_dt(exp_est_dt);
			if(!dt_st.equals("")){
				exp.setExp_start_dt(exp_start_dt);
				exp.setExp_end_dt(exp_end_dt);
			}
			cr_bean = crd.getCarRegBean(car_mng_id[i]);
			exp.setCar_no	(cr_bean.getCar_no());
//			exp.setCar_ext	(cr_bean.getCar_ext());
			exp.setCar_ext	(car_ext);
			
			if(!ex_db.insertGenExp(exp)) flag += 1;
		}
	}
%>
<script language='javascript'>
<%	if(flag == 0){%>
		alert('등록되었습니다');
		parent.document.form1.reset();
<%	}else{%>
		alert('오류발생');
<%	}%>
</script>
</body>
</html>
