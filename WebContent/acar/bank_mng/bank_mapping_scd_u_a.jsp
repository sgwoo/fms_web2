<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.debt.*, acar.bank_mng.*, acar.fee.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_rtn 	= request.getParameter("s_rtn")==null?"":request.getParameter("s_rtn");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String cont_bn = request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String lend_int = request.getParameter("lend_int")==null?"":request.getParameter("lend_int");
	int max_cltr_rat = request.getParameter("max_cltr_rat")==null?0:Util.parseInt(request.getParameter("max_cltr_rat"));
	String rtn_st = request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st");
	String lend_amt_lim = request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim");
	int rtn_size = request.getParameter("rtn_size")==null?0:Util.parseInt(request.getParameter("rtn_size"));
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	int tot_amt_tm	= request.getParameter("t_tot_amt_tm").equals("")?0:Integer.parseInt(request.getParameter("t_tot_amt_tm"));
	boolean flag1 = true;
	boolean flag2 = true;


	/* 1회차 결재일, 결재액수 update */
	ContDebtBean debt = abl_db.getBankLend_mapping_allot(m_id, l_cd);
	debt.setFst_pay_dt(request.getParameter("t_fst_pay_dt"));
	debt.setFst_pay_amt(request.getParameter("t_fst_pay_amt").equals("")?0:Util.parseDigit(request.getParameter("t_fst_pay_amt")));
	debt.setRent_mng_id(m_id);
	debt.setRent_l_cd(l_cd);
	flag1 = abl_db.updateAllot_fst(debt);

	/* 스케줄 insert */	
	String alt_tm[] 	= request.getParameterValues("t_alt_tm");
	String est_dt[] 	= request.getParameterValues("t_est_dt");
	String alt_prn[] 	= request.getParameterValues("t_alt_prn");
	String alt_int[] 	= request.getParameterValues("t_alt_int");
	String alt_amt[] 	= request.getParameterValues("t_alt_amt");
	String alt_rest[] 	= request.getParameterValues("t_rest_amt");
	for(int i = 0 ; i < tot_amt_tm ; i++){
		DebtScdBean dscd = abl_db.getADebtScd(car_id, alt_tm[i]);
		dscd.setAlt_est_dt(est_dt[i]);
		dscd.setAlt_prn(alt_prn[i].equals("")?0:Util.parseDigit(alt_prn[i]));
		dscd.setAlt_int(alt_int[i].equals("")?0:Util.parseDigit(alt_int[i]));
//		dscd.setPay_yn("0");
//		dscd.setPay_dt("");
		dscd.setAlt_rest(alt_rest[i].equals("")?0:Util.parseDigit(alt_rest[i]));
		dscd.setR_alt_est_dt(af_db.getValidDt(dscd.getAlt_est_dt()));
		flag2 = abl_db.updateDebtScd(dscd);
	}
%>
<form action="bank_mapping_frame_s.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='s_rtn' value='<%=debt.getRtn_seq()%>'>
<input type='hidden' name='gubun' value='list'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='cont_bn' value='<%=cont_bn%>'>
<input type='hidden' name='lend_int' value='<%=lend_int%>'>
<input type='hidden' name='max_cltr_rat' value='<%=max_cltr_rat%>'>
<input type='hidden' name='rtn_st' value='<%=rtn_st%>'>
<input type='hidden' name='rtn_size' value='<%=rtn_size%>'>
</form>
<script language='javascript'>
<%	if(!flag1){%>
		alert('에러입니다.\n\n할부관리가 수정되지 않았습니다');
		location='about:blank';
<%	}else if(!flag2){%>
		alert('에러입니다.\n\n스케줄이 수정되지 않았습니다');
		location='about:blank';		
<%	}else{%>
		alert('수정되었습니다');
		document.form1.target="MAPPING";
		document.form1.submit();
<%	}%>
</script>
</body>
</html>
