<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<body>
<%
	String s_rtn 	= request.getParameter("s_rtn")==null?"":request.getParameter("s_rtn");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String cont_bn = request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String lend_int = request.getParameter("lend_int")==null?"":request.getParameter("lend_int");
	String max_cltr_rat = request.getParameter("max_cltr_rat")==null?"":request.getParameter("max_cltr_rat");
	String rtn_st = request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st");
	String lend_amt_lim = request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim");
	String rtn_size = request.getParameter("rtn_size")==null?"":request.getParameter("rtn_size");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String loan_dt = request.getParameter("h_loan_dt")==null?"":request.getParameter("h_loan_dt");
	String pay_dt = request.getParameter("h_pay_dt")==null?"":request.getParameter("h_pay_dt");
	boolean flag1 = true;
	boolean flag2 = true;

	if(!loan_dt.equals("")){
		ContDebtBean debt = new ContDebtBean();
	    debt.setRent_mng_id(m_id);
    	debt.setRent_l_cd(l_cd);
	    debt.setAllot_st("2");
    	debt.setCpt_cd(request.getParameter("h_cpt_cd")==null?"":request.getParameter("h_cpt_cd"));
	    debt.setLend_int(lend_int);
    	debt.setLend_prn(request.getParameter("h_loan_sch_amt")==null?0:Util.parseDigit(request.getParameter("h_loan_sch_amt")));
    	debt.setLend_dt(loan_dt);
		debt.setCpt_cd_st(request.getParameter("cpt_cd_st"));
		debt.setLend_id(lend_id);
		debt.setCar_mng_id(request.getParameter("car_id")==null?"":request.getParameter("car_id"));
		debt.setLoan_st_dt(Util.getDate());
		debt.setLoan_sch_amt(request.getParameter("loan_sch_amt")==null?0:Util.parseDigit(request.getParameter("loan_sch_amt")));
		debt.setPay_sch_amt(request.getParameter("pay_sch_amt")==null?0:Util.parseDigit(request.getParameter("pay_sch_amt")));
		debt.setDif_amt(request.getParameter("dif_amt")==null?0:Util.parseDigit(request.getParameter("dif_amt")));
		debt.setRtn_seq(s_rtn);
		debt.setLoan_st("2");
		debt.setRimitter(request.getParameter("rimitter")==null?"":request.getParameter("rimitter"));
//		out.println(debt.getLend_id());
//		out.println(debt.getRtn_seq());
//		if(1==1)return;
		flag1 = abl_db.updateBankMapping_allot(debt);
		
		gubun="list";
	}

	if(!pay_dt.equals("")){
		//car_pur update
		flag2 = abl_db.updateBankMapping_pay(gubun, m_id, l_cd, pay_dt);
	}
%>
<form action="bank_mapping_frame_s.jsp" name="form1" method="POST" targer="MAPPING">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='s_rtn' value='<%=s_rtn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='cont_bn' value='<%=cont_bn%>'>
<input type='hidden' name='lend_int' value='<%=lend_int%>'>
<input type='hidden' name='max_cltr_rat' value='<%=max_cltr_rat%>'>
<input type='hidden' name='rtn_st' value='<%=rtn_st%>'>
<input type='hidden' name='lend_amt_lim' value='<%=lend_amt_lim%>'>
<input type='hidden' name='rtn_size' value='<%=rtn_size%>'>
</form>
<script language='javascript'>
<!--
<%	if(!flag1){%>
		alert('에러입니다.\n\n할부가 수정되지 않았습니다');
		location='about:blank';		
<%	}else if(!flag2){%>
		alert('에러입니다.\n\n구매관리가 수정되지 않았습니다');
		location='about:blank';		
<%	}else{%>		
		alert('등록되었습니다');
		document.form1.submit();
<%	}%>
-->
</script>
</body>
</html>
