<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	
	
	
	String cont_bn_st 	= request.getParameter("cont_bn_st")==null?"":request.getParameter("cont_bn_st");
	String cont_bn 		= request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String cont_bn2 	= request.getParameter("cont_bn2")==null?"":request.getParameter("cont_bn2");
	
	if(cont_bn_st.equals("2")) cont_bn = cont_bn2;
	
	
	BankLendBean bl = new BankLendBean();
	
	//은행정보
	bl.setCont_dt		(request.getParameter("cont_dt")==null?"":request.getParameter("cont_dt"));
	bl.setCont_bn		(cont_bn);
	bl.setCont_st		(request.getParameter("cont_st")==null?"0":request.getParameter("cont_st"));
	bl.setBn_br		(request.getParameter("bn_br")==null?"":request.getParameter("bn_br"));
	bl.setBn_tel		(request.getParameter("bn_tel")==null?"":request.getParameter("bn_tel"));
	bl.setBn_fax		(request.getParameter("bn_fax")==null?"":request.getParameter("bn_fax"));
	bl.setCont_bn_st	(request.getParameter("cont_bn_st")==null?"":request.getParameter("cont_bn_st"));
	bl.setBr_id		(request.getParameter("br_id")==null?"":request.getParameter("br_id"));
	bl.setMng_id		(request.getParameter("mng_id")==null?"":request.getParameter("mng_id"));
	bl.setMove_st		(request.getParameter("move_st")==null?"":request.getParameter("move_st"));
	//승인조건
	bl.setF_rat		(request.getParameter("f_rat")==null?"":request.getParameter("f_rat"));
	bl.setCharge_amt	(request.getParameter("charge_amt")==null?0:Util.parseDigit(request.getParameter("charge_amt")));
 	bl.setNtrl_fee		(request.getParameter("ntrl_fee")==null?0:Util.parseDigit(request.getParameter("ntrl_fee")));
 	bl.setStp_fee		(request.getParameter("stp_fee")==null?0:Util.parseDigit(request.getParameter("stp_fee")));
	bl.setCondi		(request.getParameter("condi")==null?"":request.getParameter("condi"));
	bl.setCl_lim		(request.getParameter("cl_lim")==null?"":request.getParameter("cl_lim"));
	bl.setCl_lim_sub	(request.getParameter("cl_lim_sub")==null?"":request.getParameter("cl_lim_sub"));
	bl.setPs_lim		(request.getParameter("ps_lim")==null?"":request.getParameter("ps_lim"));
	bl.setLend_amt_lim	(request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim"));
	bl.setMax_cltr_rat	(request.getParameter("max_cltr_rat")==null?"":request.getParameter("max_cltr_rat"));
	bl.setLend_lim		(request.getParameter("lend_lim")==null?"":request.getParameter("lend_lim"));
	bl.setLend_lim_st	(request.getParameter("lend_lim_st")==null?"":request.getParameter("lend_lim_st"));
	bl.setLend_lim_et	(request.getParameter("lend_lim_et")==null?"":request.getParameter("lend_lim_et"));
	bl.setCre_docs		(request.getParameter("cre_docs")==null?"":request.getParameter("cre_docs"));
	bl.setNote		(request.getParameter("note")==null?"":request.getParameter("note"));
	bl.setF_amt		(request.getParameter("f_amt")==null?0:Util.parseDigit(request.getParameter("f_amt")));
	bl.setF_start_dt	(request.getParameter("f_start_dt")==null?"":request.getParameter("f_start_dt"));
	bl.setF_end_dt		(request.getParameter("f_end_dt")==null?"":request.getParameter("f_end_dt"));
	//계약정보
	bl.setCont_amt		(request.getParameter("cont_amt")==null?0:AddUtil.parseDigit4(request.getParameter("cont_amt")));
	bl.setLend_int		(request.getParameter("lend_int")==null?"":request.getParameter("lend_int"));
 	bl.setBond_get_st	(request.getParameter("bond_get_st")==null?"":request.getParameter("bond_get_st"));
 	bl.setBond_get_st_sub(request.getParameter("bond_get_st_sub")==null?"":request.getParameter("bond_get_st_sub"));
	bl.setDocs			(request.getParameter("docs")==null?"":request.getParameter("docs"));
	bl.setRtn_st		(request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st"));
	bl.setRtn_su		(request.getParameter("rtn_su")==null?"":request.getParameter("rtn_su"));
	bl.setRtn_change	(request.getParameter("rtn_change")==null?"":request.getParameter("rtn_change"));
	//추가
	bl.setLend_int_amt	(0);
	bl.setPm_amt		(0);
	bl.setLend_a_amt	(0);
	bl.setPm_rest_amt	(0);
	bl.setCls_rtn_fee_int	(request.getParameter("cls_rtn_fee_int")==null?"":request.getParameter("cls_rtn_fee_int"));
	bl.setCls_rtn_etc	(request.getParameter("cls_rtn_etc")==null?"":request.getParameter("cls_rtn_etc"));
	bl.setFund_id		(request.getParameter("fund_id")==null?"":request.getParameter("fund_id"));
	
	
	
	bl = abl_db.insertBankLend(bl);
	
	
	//상환조건
	int rtn_no = Integer.parseInt(request.getParameter("rtn_st"));
	boolean flag = true;
	if(rtn_no != 0){
		if(rtn_no == 1) rtn_no = 1;
		else 			rtn_no = Integer.parseInt(request.getParameter("rtn_su"));
		BankRtnBean br = new BankRtnBean();
		br.setLend_id	(bl.getLend_id());
		for(int i=0; i<rtn_no; i++){
			br.setSeq		(request.getParameter("rtn_seq"+i)==null?"":request.getParameter("rtn_seq"+i));
			br.setRtn_move_st	(request.getParameter("rtn_move_st"+i)==null?"":request.getParameter("rtn_move_st"+i));
			br.setRtn_cont_amt	(request.getParameter("rtn_cont_amt"+i)==null?0:AddUtil.parseDigit4(request.getParameter("rtn_cont_amt"+i)));
			br.setRtn_tot_amt	(request.getParameter("rtn_tot_amt"+i)==null?0:AddUtil.parseDigit4(request.getParameter("rtn_tot_amt"+i)));
			br.setCont_start_dt	(request.getParameter("cont_start_dt"+i)==null?"":request.getParameter("cont_start_dt"+i));
			br.setCont_end_dt	(request.getParameter("cont_end_dt"+i)==null?"":request.getParameter("cont_end_dt"+i));
			br.setCont_term		(request.getParameter("cont_term"+i)==null?"":request.getParameter("cont_term"+i));
			br.setRtn_est_dt	(request.getParameter("rtn_est_dt"+i)==null?"":request.getParameter("rtn_est_dt"+i));
			br.setAlt_amt		(request.getParameter("alt_amt"+i)==null?0:Util.parseDigit(request.getParameter("alt_amt"+i)));
			br.setRtn_cdt		(request.getParameter("rtn_cdt"+i)==null?"":request.getParameter("rtn_cdt"+i));
			br.setRtn_way		(request.getParameter("rtn_way"+i)==null?"":request.getParameter("rtn_way"+i));
			br.setLoan_start_dt	(request.getParameter("loan_start_dt"+i)==null?"":request.getParameter("loan_start_dt"+i));
			br.setLoan_end_dt	(request.getParameter("loan_end_dt"+i)==null?"":request.getParameter("loan_end_dt"+i));
		 	br.setRtn_one_amt	(request.getParameter("rtn_one_amt"+i)==null?0:Util.parseDigit(request.getParameter("rtn_one_amt"+i)));
			br.setRtn_one_dt	(request.getParameter("rtn_one_dt"+i)==null?"":request.getParameter("rtn_one_dt"+i));
 			br.setRtn_two_amt	(request.getParameter("rtn_two_amt"+i)==null?0:Util.parseDigit(request.getParameter("rtn_two_amt"+i)));
		 	br.setCls_rtn_condi	(request.getParameter("cls_rtn_condi"+i)==null?"":request.getParameter("cls_rtn_condi"+i));
		 	br.setDeposit_no	(request.getParameter("deposit_no"+i)==null?"":request.getParameter("deposit_no"+i));
			flag = abl_db.insertBankRtn(br);
		}
	}
	
	//은행대출담당자 등록
	boolean flag2 = true;
	String ba_nm = request.getParameter("ba_nm")==null?"":request.getParameter("ba_nm");
	if(!ba_nm.equals("")){
		BankAgntBean ba = new BankAgntBean();
		ba.setLend_id	(bl.getLend_id());
		ba.setBa_nm		(ba_nm);
		ba.setBa_title	(request.getParameter("ba_title")==null?"":request.getParameter("ba_title"));
		ba.setBa_tel	(request.getParameter("ba_tel")==null?"":request.getParameter("ba_tel"));
		ba.setBa_email	(request.getParameter("ba_email")==null?"":request.getParameter("ba_email"));	
		flag2 = abl_db.insertBankAgnt(ba);
	}
%>
<script language='javascript'>
<!--
<%	if((!flag) || (!flag2) || (bl == null))	{	%>
		alert('오류발생');
<%	}else{%>
		alert('등록되었습니다');
		parent.parent.location='bank_reg_frame.jsp?bank_id=<%=bank_id%>&gubun1=<%=gubun1%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&lend_id=<%=bl.getLend_id()%>&sh_height=<%=sh_height%>&lend_id=<%=bl.getLend_id()%>';
<%	}	%>
//-->
</script>
</body>
</html>
