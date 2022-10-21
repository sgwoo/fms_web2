<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
</head>
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
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String cpt_cd_st = request.getParameter("cpt_cd_st")==null?"":request.getParameter("cpt_cd_st");
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String cpt_cd2 = request.getParameter("cpt_cd2")==null?"":request.getParameter("cpt_cd2");
	String fund_id 	= request.getParameter("fund_id")==null?"":request.getParameter("fund_id");
	if(cpt_cd_st.equals("2")) cpt_cd=cpt_cd2;
	boolean flag1 = true;
	boolean flag2 = true;
	
	//allot update-------------------------------------------------------------------------------------------
	ContDebtBean debt = ad_db.getContDebtReg(m_id, l_cd);
//	ContDebtBean debt = new ContDebtBean();
    debt.setRent_mng_id(m_id);
    debt.setRent_l_cd(l_cd);
    debt.setAllot_st(request.getParameter("allot_st"));
    debt.setCpt_cd(cpt_cd);
    debt.setLend_int(request.getParameter("lend_int")==null?"":request.getParameter("lend_int"));
    debt.setLend_prn(request.getParameter("lend_prn")==null?0:Util.parseDigit(request.getParameter("lend_prn")));
    debt.setAlt_fee(request.getParameter("alt_fee")==null?0:Util.parseDigit(request.getParameter("alt_fee")));
    debt.setRtn_tot_amt(request.getParameter("rtn_tot_amt")==null?0:Util.parseDigit(request.getParameter("rtn_tot_amt")));
    debt.setLoan_debtor(request.getParameter("loan_debtor"));
    debt.setRtn_cdt(request.getParameter("rtn_cdt"));
    debt.setRtn_way(request.getParameter("rtn_way"));
    debt.setRtn_est_dt(request.getParameter("rtn_est_dt"));
    debt.setLend_no(request.getParameter("lend_no")==null?"":request.getParameter("lend_no"));
    debt.setNtrl_fee(request.getParameter("ntrl_fee")==null?0:Util.parseDigit(request.getParameter("ntrl_fee")));
    debt.setStp_fee(request.getParameter("stp_fee")==null?0:Util.parseDigit(request.getParameter("stp_fee")));
    debt.setLend_dt(request.getParameter("lend_dt")==null?"":request.getParameter("lend_dt"));
    debt.setLend_int_amt(request.getParameter("lend_int_amt")==null?0:Util.parseDigit(request.getParameter("lend_int_amt")));
    debt.setAlt_amt(request.getParameter("alt_amt")==null?0:Util.parseDigit(request.getParameter("alt_amt")));
    debt.setTot_alt_tm(request.getParameter("tot_alt_tm")==null?"":request.getParameter("tot_alt_tm"));
    debt.setAlt_start_dt(request.getParameter("alt_start_dt")==null?"":request.getParameter("alt_start_dt"));
    debt.setAlt_end_dt(request.getParameter("alt_end_dt")==null?"":request.getParameter("alt_end_dt"));
    debt.setBond_get_st(request.getParameter("bond_get_st")==null?"":request.getParameter("bond_get_st"));
//  debt.setFst_pay_dt("");	 // 스케줄 작성시 입력
//  debt.setFst_pay_amt(0);	 // 스케줄 작성시 입력
    debt.setBond_get_st_sub(request.getParameter("bond_get_st_sub")==null?"":request.getParameter("bond_get_st_sub"));
//  debt.setCls_rtn_dt(request.getParameter("cls_rtn_dt")==null?"":request.getParameter("cls_rtn_dt"));
//  debt.setCls_rtn_amt(request.getParameter("cls_rtn_amt")==null?0:Util.parseDigit(request.getParameter("cls_rtn_amt")));
//  debt.setCls_rtn_fee(request.getParameter("cls_rtn_fee")==null?0:Util.parseDigit(request.getParameter("cls_rtn_fee")));
//  debt.setCls_rtn_cau(request.getParameter("cls_rtn_cau")==null?"":request.getParameter("cls_rtn_cau"));
    debt.setNote(request.getParameter("note")==null?"":request.getParameter("note"));
	//추가
	debt.setCpt_cd_st(cpt_cd_st);
//	debt.setLend_id("");	//건별 할부는 은행대출아이디는 없다.
	debt.setCar_mng_id(car_id);
//	debt.setLoan_st_dt(Util.getDate());
//	debt.setLoan_sch_amt(0);
	debt.setPay_sch_amt(request.getParameter("pay_sch_amt")==null?0:Util.parseDigit(request.getParameter("pay_sch_amt")));
	debt.setDif_amt(request.getParameter("dif_amt")==null?0:Util.parseDigit(request.getParameter("dif_amt")));
//	debt.setRtn_seq("");
//	debt.setLoan_st("1");
	debt.setRimitter(request.getParameter("rimitter")==null?"":request.getParameter("rimitter"));
	debt.setAutodoc_yn(request.getParameter("autodoc_yn")==null?"N":request.getParameter("autodoc_yn"));
	if(debt.getAutodoc_yn().equals("Y")){
		debt.setVen_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
		debt.setBank_code(request.getParameter("bank_code2")==null?"":request.getParameter("bank_code2"));
		debt.setDeposit_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));
		debt.setAcct_code(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));
	}else{
		debt.setVen_code("");
		debt.setBank_code("");
		debt.setDeposit_no("");
		debt.setAcct_code("");
	}
	debt.setCls_rtn_fee_int	(request.getParameter("cls_rtn_fee_int")==null?"":request.getParameter("cls_rtn_fee_int"));
	debt.setCls_rtn_etc		(request.getParameter("cls_rtn_etc")==null?"":request.getParameter("cls_rtn_etc"));
	debt.setFund_id			(fund_id);
	
	debt.setAlt_etc		(request.getParameter("alt_etc")==null?"":request.getParameter("alt_etc"));
	debt.setAlt_etc_amt (request.getParameter("alt_etc_amt")==null?0:Util.parseDigit(request.getParameter("alt_etc_amt")));
	debt.setAlt_etc_tm  (request.getParameter("alt_etc_tm")==null?"":request.getParameter("alt_etc_tm"));
	
	
	flag1 = ad_db.updateContDebt(debt);
	
	
	//cltr insert--------------------------------------------------------------------------------------------
	int cltr_amt = request.getParameter("cltr_amt")==null?0:Util.parseDigit(request.getParameter("cltr_amt"));
	String cltr_set_dt = request.getParameter("cltr_set_dt")==null?"":request.getParameter("cltr_set_dt");
	String cltr_id = request.getParameter("cltr_id")==null?"":request.getParameter("cltr_id");
	String cltr_st = request.getParameter("cltr_st")==null?"N":request.getParameter("cltr_st");
	CltrBean cltr = ad_db.getBankLend_mapping_cltr(m_id, l_cd);
//	CltrBean cltr = new CltrBean();
	cltr.setRent_mng_id(m_id);
	cltr.setRent_l_cd(l_cd);
	cltr.setCltr_id(request.getParameter("cltr_id")==null?"":request.getParameter("cltr_id"));
	cltr.setCltr_amt(cltr_amt);
	cltr.setCltr_per_loan(request.getParameter("cltr_per_loan")==null?"":request.getParameter("cltr_per_loan"));
	cltr.setCltr_exp_dt(request.getParameter("cltr_exp_dt")==null?"":request.getParameter("cltr_exp_dt"));
	cltr.setCltr_set_dt(cltr_set_dt);
	cltr.setReg_tax(request.getParameter("reg_tax")==null?0:Util.parseDigit(request.getParameter("reg_tax")));
//	cltr.setCltr_pay_dt("");
	//추가
	cltr.setCltr_docs_dt(request.getParameter("cltr_docs_dt")==null?"":request.getParameter("cltr_docs_dt"));
	cltr.setCltr_f_amt(request.getParameter("cltr_f_amt")==null?0:Util.parseDigit(request.getParameter("cltr_f_amt")));
	cltr.setCltr_exp_cau(request.getParameter("cltr_exp_cau")==null?"":request.getParameter("cltr_exp_cau"));
	cltr.setMort_lank(request.getParameter("mort_lank")==null?"":request.getParameter("mort_lank"));
	cltr.setCltr_user(request.getParameter("cltr_user")==null?"":request.getParameter("cltr_user"));
	cltr.setCltr_office(request.getParameter("cltr_office")==null?"":request.getParameter("cltr_office"));
	cltr.setCltr_offi_man(request.getParameter("cltr_offi_man")==null?"":request.getParameter("cltr_offi_man"));
	cltr.setCltr_offi_tel(request.getParameter("cltr_offi_tel")==null?"":request.getParameter("cltr_offi_tel"));
	cltr.setCltr_offi_fax(request.getParameter("cltr_offi_fax")==null?"":request.getParameter("cltr_offi_fax"));
	cltr.setSet_stp_fee(request.getParameter("set_stp_fee")==null?0:Util.parseDigit(request.getParameter("set_stp_fee")));
	cltr.setExp_tax(request.getParameter("exp_tax")==null?0:Util.parseDigit(request.getParameter("exp_tax")));
	cltr.setExp_stp_fee(request.getParameter("exp_stp_fee")==null?0:Util.parseDigit(request.getParameter("exp_stp_fee")));
	cltr.setCltr_num(request.getParameter("cltr_num")==null?"":request.getParameter("cltr_num"));
	if(cltr_amt > 0 || !cltr_set_dt.equals("")){//입력이 있다.
		cltr.setCltr_st("Y");
	}
//	out.println(cltr_st);out.println(cltr.getCltr_id());if(1==1)return;
	if(!cltr_id.equals("") && cltr_st.equals("Y")) flag2 = ad_db.updateContCltr(cltr);
	if(cltr_id.equals("") && cltr_st.equals("Y")) flag2 = ad_db.insertContCltr(cltr);
%>
<form action="debt_scd_frame_s.jsp" name="form1" method="POST">
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
<!--
<%	if(!flag1){%>
		alert('에러입니다.\n\n할부금이 수정되지 않았습니다');
		location='about:blank';
<%	}else if(!flag2){%>
		alert('에러입니다.\n\n근저당설정이 수정되지 않았습니다');
		location='about:blank';		
<%	}else{%>		
		alert('수정되었습니다');
		document.form1.target='d_content';
		document.form1.submit();
<%	}%>
-->
</script>
</body>
</html>
