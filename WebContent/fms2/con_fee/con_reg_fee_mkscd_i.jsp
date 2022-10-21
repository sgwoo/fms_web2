<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.fee.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="f_db" scope="page" class="acar.fee.FeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String m_id = request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd");
	String gubun = request.getParameter("gubun");	//1:신규대여료, 2:연장대여료

	int fee_s_amt = Util.parseDigit(request.getParameter("t_fee_s_amt"));
	int fee_v_amt = Util.parseDigit(request.getParameter("t_fee_v_amt"));
	int fee_pay_tm = Util.parseDigit(request.getParameter("t_fee_pay_tm"));
	String fee_fst_dt = request.getParameter("t_fee_fst_dt");
	int fee_fst_s_amt = Util.parseDigit(request.getParameter("h_fee_fst_s_amt"));
	int fee_fst_v_amt = Util.parseDigit(request.getParameter("h_fee_fst_v_amt"));
	CommonDataBase c_db = CommonDataBase.getInstance();
	int flag = 0;

	if(gubun.equals("1"))
	{
		/* 스케줄 생성 */
		for(int i = 0 ; i < fee_pay_tm ; i++)
		{
			FeeScdBean fee_scd = new FeeScdBean();
			if(i == 0)							/*1회차 */
			{
				fee_scd.setRent_mng_id(m_id);
				fee_scd.setRent_l_cd(l_cd);
				fee_scd.setFee_tm(String.valueOf(i+1));
				fee_scd.setRent_st(gubun);
				fee_scd.setTm_st1("0");					// 구분: 월대여료(/잔액)
				fee_scd.setTm_st2("0");					// 구분: 일반대여료(/회차연장대여료)
				fee_scd.setFee_est_dt(fee_fst_dt);		// 1회차 납입일은 1회차 납입일 그대로
				fee_scd.setR_fee_est_dt(f_db.getValidDt(fee_scd.getFee_est_dt()));
				fee_scd.setFee_s_amt(fee_fst_s_amt);	// 1회차 금액은   1회차납입액 그대로
				fee_scd.setFee_v_amt(fee_fst_v_amt);		
				fee_scd.setRc_yn("0");		// default값은 미수금 
				//fee_scd.setRc_dt();
				//fee_scd.setRc_amt();
				//fee_scd.setDly_days();
				//fee_scd.setDly_fee();
				//fee_scd.setPay_cng_dt();
				//fee_scd.setPay_cng_cau();
			}
			else
			{
				fee_scd.setRent_mng_id(m_id);
				fee_scd.setRent_l_cd(l_cd);
				fee_scd.setFee_tm(String.valueOf(i+1));
				fee_scd.setRent_st(gubun);
				fee_scd.setTm_st1("0");					// 구분: 월대여료
				fee_scd.setTm_st2("0");					// 구분: 일반대여료
				fee_scd.setFee_est_dt(c_db.addMonth(fee_fst_dt, i));
				fee_scd.setR_fee_est_dt(f_db.getValidDt(fee_scd.getFee_est_dt()));
				fee_scd.setFee_s_amt(fee_s_amt);		// 2회차부터는 월대여료로 세팅
				fee_scd.setFee_v_amt(fee_v_amt);	
				fee_scd.setRc_yn("0");
				fee_scd.setRent_seq("1");
			}
		
			if(!f_db.insertFeeScd(fee_scd))
				flag = flag+1;
		}
	}
	else
	{
		String s_tot_tm = f_db.getFeeTotTm(m_id);
		int next_tm = 0;
		if(!s_tot_tm.equals(""))	
		{
			next_tm = Integer.parseInt(s_tot_tm)+1;
		}
		/* 스케줄 생성 */
		for(int i = 0 ; i < fee_pay_tm ; i++)
		{
			FeeScdBean fee_scd = new FeeScdBean();
			fee_scd.setRent_mng_id(m_id);
			fee_scd.setRent_l_cd(l_cd);
			fee_scd.setFee_tm(String.valueOf(next_tm+i));
			fee_scd.setRent_st(gubun);
			fee_scd.setTm_st1("0");					// 구분: 월대여료
			fee_scd.setTm_st2("0");					// 구분: 일반대여료
			fee_scd.setFee_est_dt(c_db.addMonth(fee_fst_dt, i));
			fee_scd.setFee_s_amt(fee_s_amt);		// 2회차부터는 월대여료로 세팅
			fee_scd.setFee_v_amt(fee_v_amt);	
			fee_scd.setRc_yn("0");
			fee_scd.setR_fee_est_dt(f_db.getValidDt(fee_scd.getFee_est_dt()));
			fee_scd.setRent_seq("1");
		
			if(!f_db.insertFeeScd(fee_scd))
				flag = flag+1;
		}
	}	
	f_db.calDelay(m_id, l_cd);	//연체료 계산
%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
</form>
<script language='javascript'>
<%
	if(flag != 0)
	{
%>		alert("스케줄이 등록되지 않았습니다");
		location='about:blank';
<%	}
	else
	{
%>		alert("스케줄이 등록되었습니다");
		var fm = document.form1;
		fm.target='c_foot';
<% 	
		if(gubun.equals("1"))
		{
%>			fm.action='/acar/car_rent/con_fee_frame_u.jsp?';
<%		}
		else
		{
%>			fm.action='/acar/car_rent/con_ext_frame_u.jsp?';
<%		}
%>			fm.submit();		
<%	}
%>
</script>