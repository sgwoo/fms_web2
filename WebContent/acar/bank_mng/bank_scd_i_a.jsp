<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.bank_mng.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String lend_id 	= request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int cont_term	= request.getParameter("cont_term").equals("")?0:Integer.parseInt(request.getParameter("cont_term"));
	int flag = 0;
	int flag2 = 0;
	
	
	/* 스케줄 insert */
	String alt_tm[] = request.getParameterValues("alt_tm");
	String est_dt[] = request.getParameterValues("alt_est_dt");
	String alt_prn[] = request.getParameterValues("alt_prn_amt");
	String alt_int[] = request.getParameterValues("alt_int_amt");
	String alt_rest[] = request.getParameterValues("alt_rest");
	
	
	
	/* 1회차 결재일, 결재액수 update */
	BankRtnBean br = new BankRtnBean();
	br.setLend_id		(lend_id);
	br.setSeq		(rtn_seq);
	br.setFst_pay_dt	(request.getParameter("fst_pay_dt"));
	br.setFst_pay_amt	(request.getParameter("fst_pay_amt").equals("")?0:Util.parseDigit(request.getParameter("fst_pay_amt")));
	if(!abl_db.updateBankRtn_fst(br))	flag += 1;

	//0회차 생성
	BankScdBean bs0 = new BankScdBean();
	bs0.setLend_id		(lend_id);
	bs0.setRtn_seq		(rtn_seq);
	bs0.setAlt_tm		("0");
	bs0.setAlt_est_dt	(request.getParameter("lend_dt"));
	bs0.setAlt_prn_amt	(0);
	bs0.setAlt_int_amt	(0);
	bs0.setPay_dt		(request.getParameter("lend_dt"));
	bs0.setPay_yn		("1");
	bs0.setAlt_rest		(request.getParameter("cont_amt").equals("")?0:Util.parseDigitLong(request.getParameter("cont_amt")));
	bs0.setR_alt_est_dt	(request.getParameter("lend_dt"));
	
	if(bs0.getAlt_rest()==0){
		br = abl_db.getBankRtn(lend_id, rtn_seq);		
		bs0.setAlt_rest		(Util.parseDigitLong(String.valueOf(br.getRtn_cont_amt())));
	}
	
	if(!abl_db.insertBankScd(bs0))	flag2 += 1;
	
	for(int i = 0 ; i < cont_term ; i++){
		BankScdBean bs = new BankScdBean();
		bs.setLend_id		(lend_id);
		bs.setRtn_seq		(rtn_seq);
		bs.setAlt_tm		(alt_tm[i]);
		bs.setAlt_est_dt	(est_dt[i]);
		bs.setAlt_prn_amt	(alt_prn[i].equals("")?0:Util.parseDigit(alt_prn[i]));
		bs.setAlt_int_amt	(alt_int[i].equals("")?0:Util.parseDigit(alt_int[i]));
		bs.setPay_dt		("");
		bs.setPay_yn		("0");
		bs.setAlt_rest		(alt_rest[i].equals("")?0:Util.parseDigitLong(alt_rest[i]));
		
		
		bs.setR_alt_est_dt	(af_db.getValidDt(bs.getAlt_est_dt()));
		
		
		if(!abl_db.insertBankScd(bs))	flag += 1;
	}
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
</form>
<script language='javascript'>
<%	if(flag != 0 && flag2 != 0){%>
		alert('등록되지 않았습니다');
		location='about:blank';
<%	}else{%>
		alert('등록되었습니다');
		var fm = document.form1;
		fm.target='d_content';
		fm.action='bank_frame_s.jsp';
		fm.submit();
<%	}%>
</script>
</body>
</html>
