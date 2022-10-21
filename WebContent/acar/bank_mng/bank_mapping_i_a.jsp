<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
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
	String max_cltr_rat = request.getParameter("max_cltr_rat")==null?"":request.getParameter("max_cltr_rat");
	String rtn_st = request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st");
	String rtn_size = request.getParameter("rtn_size")==null?"":request.getParameter("rtn_size");
	String lend_amt_lim = request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	boolean flag1 = true;
	boolean flag2 = true;
	
	//allot update-------------------------------------------------------------------------------------------
	ContDebtBean debt = new ContDebtBean();
    debt.setRent_mng_id(m_id);
    debt.setRent_l_cd(l_cd);
    debt.setAllot_st(request.getParameter("allot_st"));
    debt.setCpt_cd(request.getParameter("cpt_cd"));
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
    debt.setFst_pay_dt("");	 // 스케줄 작성시 입력
    debt.setFst_pay_amt(0);	 // 스케줄 작성시 입력
    debt.setBond_get_st_sub(request.getParameter("bond_get_st_sub")==null?"":request.getParameter("bond_get_st_sub"));
    debt.setCls_rtn_dt(request.getParameter("cls_rtn_dt")==null?"":request.getParameter("cls_rtn_dt"));
    debt.setCls_rtn_amt(request.getParameter("cls_rtn_amt")==null?0:Util.parseDigit(request.getParameter("cls_rtn_amt")));
    debt.setCls_rtn_fee(request.getParameter("cls_rtn_fee")==null?0:Util.parseDigit(request.getParameter("cls_rtn_fee")));
    debt.setCls_rtn_cau(request.getParameter("cls_rtn_cau")==null?"":request.getParameter("cls_rtn_cau"));
    debt.setNote(request.getParameter("note")==null?"":request.getParameter("note"));
	//추가
	debt.setCpt_cd_st(request.getParameter("cpt_cd_st"));
	debt.setLend_id(request.getParameter("lend_id"));
	debt.setCar_mng_id(request.getParameter("car_id")==null?"":request.getParameter("car_id"));
	debt.setLoan_st_dt(Util.getDate());
	debt.setLoan_sch_amt(request.getParameter("loan_sch_amt")==null?0:Util.parseDigit(request.getParameter("loan_sch_amt")));
	debt.setPay_sch_amt(request.getParameter("pay_sch_amt")==null?0:Util.parseDigit(request.getParameter("pay_sch_amt")));
	debt.setDif_amt(request.getParameter("dif_amt")==null?0:Util.parseDigit(request.getParameter("dif_amt")));
	debt.setRtn_seq(request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq"));
	debt.setLoan_st("2");
	debt.setRimitter(request.getParameter("rimitter")==null?"":request.getParameter("rimitter"));
	debt.setLend_int_vat(request.getParameter("lend_int_vat")==null?0:Util.parseDigit(request.getParameter("lend_int_vat")));
	
	flag1 = abl_db.updateBankMapping_allot(debt);
	
	
	//cltr insert--------------------------------------------------------------------------------------------
	int cltr_amt = request.getParameter("cltr_amt")==null?0:Util.parseDigit(request.getParameter("cltr_amt"));
	String cltr_set_dt = request.getParameter("cltr_set_dt")==null?"":request.getParameter("cltr_set_dt");
	CltrBean cltr = new CltrBean();
	cltr.setRent_mng_id(m_id);
	cltr.setRent_l_cd(l_cd);
	cltr.setCltr_id("");//생성
	cltr.setCltr_amt(cltr_amt);
	cltr.setCltr_per_loan(request.getParameter("cltr_per_loan")==null?"":request.getParameter("cltr_per_loan"));
	cltr.setCltr_exp_dt(request.getParameter("cltr_exp_dt")==null?"":request.getParameter("cltr_exp_dt"));
	cltr.setCltr_set_dt(cltr_set_dt);
	cltr.setReg_tax(request.getParameter("reg_tax")==null?0:Util.parseDigit(request.getParameter("reg_tax")));
//	cltr.setReg_tax((new Double(i_cltr_amt1 * 0.002)).intValue());
//	cltr.setCltr_fee((new Double(i_cltr_amt1 * 0.004)).intValue());
	cltr.setCltr_pay_dt("");
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
//	cltr.setCltr_st(request.getParameter("cltr_st")==null?"N":request.getParameter("cltr_st"));	
	cltr.setCltr_num(request.getParameter("cltr_num")==null?"":request.getParameter("cltr_num"));

	if(cltr_amt > 0 && !cltr_set_dt.equals("")){
		cltr.setCltr_st("Y");
	}
		
//	if(cltr_amt > 0 || !cltr_set_dt.equals("")){	}
	
	flag2 = abl_db.insertBankMapping_cltr(cltr);
%>
<form action="bank_mapping_frame_s.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='s_rtn' value='<%=debt.getRtn_seq()%>'>
<input type='hidden' name='gubun' value='reg'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='cont_bn' value='<%=cont_bn%>'>
<input type='hidden' name='lend_int' value='<%=lend_int%>'>
<input type='hidden' name='max_cltr_rat' value='<%=max_cltr_rat%>'>
<input type='hidden' name='rtn_st' value='<%=rtn_st%>'>
<input type='hidden' name='rtn_size' value='<%=rtn_size%>'>
<input type='hidden' name='lend_amt_lim' value='<%=lend_amt_lim%>'>

</form>

<script language='javascript'>
<!--
<%	if(!flag1){%>
		alert('에러입니다.\n\n은행대출이 등록되지 않았습니다');
		location='about:blank';
<%	}else if(!flag2){%>
		alert('에러입니다.\n\n근저당설정이 등록되지 않았습니다');
		location='about:blank';		
<%	}else{%>		
		alert('등록되었습니다');
		document.form1.target="MAPPING";
		document.form1.submit();
<%	}%>
-->
</script>
</body>
</html>
