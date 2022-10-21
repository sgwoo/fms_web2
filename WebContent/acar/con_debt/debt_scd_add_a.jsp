<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.debt.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	int tot_amt_tm	= request.getParameter("t_tot_amt_tm").equals("")?0:Integer.parseInt(request.getParameter("t_tot_amt_tm"));
	String car_id 	= request.getParameter("car_id")==null?"": request.getParameter("car_id");

	int from_tm	= request.getParameter("from_tm").equals("")?0:Integer.parseInt(request.getParameter("from_tm"));
	int add_tm	= request.getParameter("add_tm").equals("")?0:Integer.parseInt(request.getParameter("add_tm"));

	int flag = 0;
	int flag2 = 0;
	
	int cal_tm = from_tm + add_tm;
	
	for(int i = from_tm ; i <  cal_tm ; i++){
		DebtScdBean debt = new DebtScdBean();
		debt.setCar_mng_id(car_id);
		debt.setAlt_tm(Integer.toString( i ));
		
		debt.setAlt_prn(0);
		debt.setAlt_int(0);
		debt.setPay_yn("0");	//default값은 0	(미지급)
		debt.setPay_dt("");
		debt.setAlt_rest(0);
	
		if(!d_db.insertDebtScdAdd(debt))	flag += 1;
	}
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
</form>
<script language='javascript'>
<%	if(flag != 0 && flag2 != 0){%>
		alert('등록되지 않았습니다');
		location='about:blank';
<%	}else{%>
		alert('등록되었습니다');
		var fm = document.form1;
		fm.target='d_content';
		fm.action='debt_scd_u.jsp';
		fm.submit();
<%	}%>
</script>
</body>
</html>
