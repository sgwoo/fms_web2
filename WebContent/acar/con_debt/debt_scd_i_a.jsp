<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.debt.*, acar.util.*, acar.fee.*, acar.common.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
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
	int flag = 0;
	int flag2 = 0;
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	
	/* 1회차 결재일, 결재액수 update */
	ContDebtBean c_debt = a_db.getContDebt(m_id, l_cd);
	c_debt.setFst_pay_dt(request.getParameter("t_fst_pay_dt"));
	c_debt.setFst_pay_amt(request.getParameter("t_fst_pay_amt").equals("")?0:Util.parseDigit(request.getParameter("t_fst_pay_amt")));
	if(!a_db.updateContDebt(c_debt))	flag += 1;

	//0회차 생성
	DebtScdBean debt0 = new DebtScdBean();
	debt0.setCar_mng_id(car_id);
	debt0.setAlt_tm("0");
	debt0.setAlt_est_dt(request.getParameter("lend_dt"));
	debt0.setAlt_prn(0);
	debt0.setAlt_int(0);
	debt0.setPay_yn("1");
	debt0.setPay_dt(request.getParameter("lend_dt"));
	debt0.setAlt_rest(Util.parseDigit(request.getParameter("t_lend_prn")));
	debt0.setR_alt_est_dt(request.getParameter("lend_dt"));
	if(!abl_db.insertScdAltCase(debt0)) flag2 = 1;
//	flag2 = abl_db.insertScdAltCase(debt0);
		
	/* 스케줄 insert */
	String alt_tm[] = request.getParameterValues("t_alt_tm");
	String est_dt[] = request.getParameterValues("t_est_dt");
	String alt_prn[] = request.getParameterValues("t_alt_prn");
	String alt_int[] = request.getParameterValues("t_alt_int");
	String alt_amt[] = request.getParameterValues("t_alt_amt");
	String alt_rest[] = request.getParameterValues("t_rest_amt");
	
	for(int i = 0 ; i < tot_amt_tm ; i++){
		DebtScdBean debt = new DebtScdBean();
		debt.setCar_mng_id(car_id);
		debt.setAlt_tm(alt_tm[i]);
		debt.setAlt_est_dt(est_dt[i]);
		debt.setAlt_prn(alt_prn[i].equals("")?0:Util.parseDigit(alt_prn[i]));
		debt.setAlt_int(alt_int[i].equals("")?0:Util.parseDigit(alt_int[i]));
		debt.setPay_yn("0");	//default값은 0	(미지급)
		debt.setPay_dt("");
		debt.setAlt_rest(alt_rest[i].equals("")?0:Util.parseDigit(alt_rest[i]));
		
		//마지막회차는 공휴일 전일
		//if((i+1)==tot_amt_tm){
		//	debt.setR_alt_est_dt(c_db.getFGetDt("F_getInsurPayDt", debt.getAlt_est_dt(), "0"));
		//}else{
			debt.setR_alt_est_dt(af_db.getValidDt(debt.getAlt_est_dt()));
		//}
		
		if(!d_db.insertDebtScd(debt))	flag += 1;
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
</form>
<script language='javascript'>
<%	if(flag != 0 && flag2 != 0){%>
		alert('등록되지 않았습니다');
		location='about:blank';
<%	}else{%>
		alert('등록되었습니다');
		var fm = document.form1;
		fm.target='d_content';
		fm.action='/acar/con_debt/debt_scd_frame_s.jsp';
		fm.submit();
<%	}%>
</script>
</body>
</html>
