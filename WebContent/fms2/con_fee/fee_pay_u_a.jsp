<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id		= request.getParameter("m_id");
	String l_cd		= request.getParameter("l_cd");
	String r_st		= request.getParameter("r_st");
	String prv_mon_yn = request.getParameter("prv_mon_yn")==null?"":request.getParameter("prv_mon_yn");//출고전대차기간포함여부
	String fee_tm	= request.getParameter("h_fee_tm");
	String tm_st1	= request.getParameter("h_tm_st1");
	String rent_seq = request.getParameter("rent_seq")==null?"":request.getParameter("rent_seq");
	String rc_dt	= request.getParameter("t_rc_dt");
	String ext_dt = request.getParameter("ext_dt")==null?"":request.getParameter("ext_dt");
	String b_dt = request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String rent_dt = request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");	
	String page_gubun = request.getParameter("page_gubun")==null?"":request.getParameter("page_gubun");
	int rc_amt		= request.getParameter("t_rc_amt")==null?0:Util.parseDigit(request.getParameter("t_rc_amt"));
	int flag = 0;
	int flag2 = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	FeeScdBean pay_fee = af_db.getScdNew(m_id, l_cd, r_st, rent_seq, fee_tm, tm_st1);
	int fee_amt = pay_fee.getFee_s_amt()+pay_fee.getFee_v_amt();
	
	/*전액 납부하는 경우*/
	if(rc_amt == fee_amt){
		pay_fee.setRc_yn("1");
		pay_fee.setRc_dt(rc_dt);
		pay_fee.setRc_amt(rc_amt);
		pay_fee.setUpdate_id(user_id);
		pay_fee.setExt_dt(ext_dt);
		if(!af_db.updateFeeScd(pay_fee))	flag += 1;
	}

	/*잔액이 생성되는 경우*/
	else if(rc_amt < fee_amt){
		int rest_amt = fee_amt - rc_amt;
		int rest_s_amt = (new Double(rest_amt/1.1)).intValue();
		
		pay_fee.setRc_yn("1");
		pay_fee.setRc_dt(rc_dt);
		pay_fee.setRc_amt(rc_amt);
		pay_fee.setUpdate_id(user_id);
		if(!af_db.updateFeeScd(pay_fee))	flag += 1;
		
		FeeScdBean rest_fee = new FeeScdBean();
		rest_fee.setRent_mng_id(m_id);
		rest_fee.setRent_l_cd(l_cd);
		rest_fee.setFee_tm(fee_tm);
		rest_fee.setRent_st(r_st);
		rest_fee.setRent_seq(rent_seq);
		if (rent_seq.equals("")) rest_fee.setRent_seq("1");
		if (rest_fee.getRent_seq().equals("")) rest_fee.setRent_seq("1");
		rest_fee.setTm_st1(String.valueOf(Integer.parseInt(pay_fee.getTm_st1())+1));	//잔액대여료. 기존 회차구분+1
		rest_fee.setTm_st2("0");	//일반대여료(not 회차연장대여료)
		rest_fee.setFee_est_dt(pay_fee.getFee_est_dt());	//원 대여료의 입금예정일
		rest_fee.setFee_s_amt(rest_s_amt);
		rest_fee.setFee_v_amt(rest_amt - rest_s_amt);
		rest_fee.setRc_yn("0");		//default는 0(미수금)
		rest_fee.setRc_dt("");
		rest_fee.setRc_amt(0);
		rest_fee.setUpdate_id(user_id);
		rest_fee.setExt_dt(ext_dt);	
		rest_fee.setR_fee_est_dt(af_db.getValidDt(pay_fee.getR_fee_est_dt())); //수정 : 입금예정일을 그대로 간다.(20031030)
		rest_fee.setBill_yn("Y");
		rest_fee.setReq_dt		(pay_fee.getReq_dt());
		rest_fee.setR_req_dt	(pay_fee.getR_req_dt());
		rest_fee.setTax_out_dt	(pay_fee.getTax_out_dt());
		rest_fee.setUse_s_dt	(pay_fee.getUse_s_dt());
		rest_fee.setUse_e_dt	(pay_fee.getUse_e_dt());
		
		if(!af_db.insertFeeScdAdd(rest_fee))	flag += 1;
	}
	//없음
	else{	}


	boolean dly_flag = af_db.calDelayDtPrint(m_id, l_cd, b_dt, rent_dt);


	//네오엠 자동전표 처리-------------------------------
	String autodoc	= request.getParameter("autodoc")==null?"N":request.getParameter("autodoc");
	int count =0;
	user_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("입금담당"));
	String insert_id = user_bean.getId();
		
	if(autodoc.equals("Y")){
	
		NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		AutoDocuBean ad_bean = new AutoDocuBean();
		ad_bean.setNode_code("S101");	
	
		ad_bean.setVen_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
		ad_bean.setFirm_nm(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
		ad_bean.setAcct_dt(request.getParameter("acct_dt")==null?"":request.getParameter("acct_dt"));
		ad_bean.setAcct_code(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));
		ad_bean.setBank_code(request.getParameter("bank_code2")==null?"":request.getParameter("bank_code2"));
		ad_bean.setBank_name(request.getParameter("bank_name")==null?"":request.getParameter("bank_name"));
		ad_bean.setDeposit_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));
		ad_bean.setAcct_cont(request.getParameter("acct_cont")==null?"":request.getParameter("acct_cont"));
		ad_bean.setAmt(rc_amt);
		ad_bean.setInsert_id(insert_id);
	
		count = neoe_db.insertFeeAutoDocu(ad_bean); 	//-> neoe_db 변환
		
		String client_id	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
		ClientBean client = al_db.getClient(client_id);
		if(client.getVen_code().equals("")){
			client.setVen_code		(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
			if(al_db.updateClient2(client))	flag2 += 1;
		}
	}
	//---------------------------------------------------
%>
<html>
<head><title>FMS</title></head>
<body>
<form name='form1' action='/fms2/con_fee/fee_c_mgr_in.jsp' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='prv_mon_yn' value='<%=prv_mon_yn%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('오류발생!');
		location='about:blank';
<%	}else if(count == 1){%>
		alert('자동전표 오류발생!');
		location='about:blank';	
<%	}else{%>
		alert('처리되었습니다');
		<%if(page_gubun.equals("")){%>
		parent.opener.i_in.location='/fms2/con_fee/fee_c_mgr_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&prv_mon_yn=<%=prv_mon_yn%>';
		<%}else{%>
		parent.opener.i_in2.location='/acar/con_cls/fee_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&prv_mon_yn=<%=prv_mon_yn%>';
		<%}%>
		parent.close();
<%	}%>
</script>
</body>
</html>
