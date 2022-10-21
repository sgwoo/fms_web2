<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.util.*"%>
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
		
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cont_bn_st 	= request.getParameter("cont_bn_st")==null?"":request.getParameter("cont_bn_st");
	String cont_bn 		= request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String cont_bn2 	= request.getParameter("cont_bn2")==null?"":request.getParameter("cont_bn2");
	
	if(cont_bn_st.equals("2")) cont_bn=cont_bn2;
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	
	
	if(gubun.equals("")){
	
		BankLendBean bl = abl_db.getBankLend(lend_id);
		
		//은행정보
		bl.setCont_dt(request.getParameter("cont_dt")==null?"":request.getParameter("cont_dt"));
		bl.setCont_bn(cont_bn);
		bl.setCont_st(request.getParameter("cont_st")==null?"0":request.getParameter("cont_st"));
		bl.setBn_br(request.getParameter("bn_br")==null?"":request.getParameter("bn_br"));
		bl.setBn_tel(request.getParameter("bn_tel")==null?"":request.getParameter("bn_tel"));
		bl.setBn_fax(request.getParameter("bn_fax")==null?"":request.getParameter("bn_fax"));
		bl.setCont_bn_st(request.getParameter("cont_bn_st")==null?"":request.getParameter("cont_bn_st"));
		bl.setBr_id(request.getParameter("br_id")==null?"":request.getParameter("br_id"));
		bl.setMng_id(request.getParameter("mng_id")==null?"":request.getParameter("mng_id"));
		bl.setMove_st(request.getParameter("move_st")==null?"":request.getParameter("move_st"));
		//승인조건
		bl.setF_rat(request.getParameter("f_rat")==null?"":request.getParameter("f_rat"));
		bl.setCharge_amt(request.getParameter("charge_amt")==null?0:Util.parseDigit(request.getParameter("charge_amt")));
	 	bl.setNtrl_fee(request.getParameter("ntrl_fee")==null?0:Util.parseDigit(request.getParameter("ntrl_fee")));
 		bl.setStp_fee(request.getParameter("stp_fee")==null?0:Util.parseDigit(request.getParameter("stp_fee")));
		bl.setCondi(request.getParameter("condi")==null?"":request.getParameter("condi"));
		bl.setCl_lim(request.getParameter("cl_lim")==null?"":request.getParameter("cl_lim"));
		bl.setCl_lim_sub(request.getParameter("cl_lim_sub")==null?"":request.getParameter("cl_lim_sub"));
		bl.setPs_lim(request.getParameter("ps_lim")==null?"":request.getParameter("ps_lim"));
		bl.setLend_amt_lim(request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim"));
		bl.setMax_cltr_rat(request.getParameter("max_cltr_rat")==null?"":request.getParameter("max_cltr_rat"));
		bl.setLend_lim(request.getParameter("lend_lim")==null?"":request.getParameter("lend_lim"));
		bl.setLend_lim_st(request.getParameter("lend_lim_st")==null?"":request.getParameter("lend_lim_st"));
		bl.setLend_lim_et(request.getParameter("lend_lim_et")==null?"":request.getParameter("lend_lim_et"));
		bl.setCre_docs(request.getParameter("cre_docs")==null?"":request.getParameter("cre_docs"));
		bl.setNote(request.getParameter("note")==null?"":request.getParameter("note"));
		bl.setF_amt(request.getParameter("f_amt")==null?0:Util.parseDigit(request.getParameter("f_amt")));
		bl.setF_start_dt(request.getParameter("f_start_dt")==null?"":request.getParameter("f_start_dt"));
		bl.setF_end_dt(request.getParameter("f_end_dt")==null?"":request.getParameter("f_end_dt"));
		//계약정보
		bl.setCont_amt(request.getParameter("cont_amt")==null?0:AddUtil.parseDigit4(request.getParameter("cont_amt")));
		bl.setLend_int(request.getParameter("lend_int")==null?"":request.getParameter("lend_int"));
	 	bl.setBond_get_st(request.getParameter("bond_get_st")==null?"":request.getParameter("bond_get_st"));
 		bl.setBond_get_st_sub(request.getParameter("bond_get_st_sub")==null?"":request.getParameter("bond_get_st_sub"));
		bl.setDocs(request.getParameter("docs")==null?"":request.getParameter("docs"));
		bl.setRtn_st(request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st"));
		bl.setRtn_su(request.getParameter("rtn_su")==null?"":request.getParameter("rtn_su"));
		bl.setRtn_change(request.getParameter("rtn_change")==null?"":request.getParameter("rtn_change"));
		//추가
		bl.setLend_int_amt(0);
		bl.setPm_amt(0);
		bl.setLend_a_amt(0);
		bl.setPm_rest_amt(0);
		//자동전표
		bl.setAutodoc_yn(request.getParameter("autodoc_yn")==null?"N":request.getParameter("autodoc_yn"));
		if(bl.getAutodoc_yn().equals("Y")){
			bl.setBank_code(request.getParameter("bank_code2")==null?"":request.getParameter("bank_code2"));
			bl.setDeposit_no_d(request.getParameter("deposit_no_d")==null?"":request.getParameter("deposit_no_d"));
			bl.setAcct_code(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));			
		}else{
			bl.setBank_code("");
			bl.setDeposit_no_d("");
			bl.setAcct_code("");			
		}
		bl.setCls_rtn_fee_int	(request.getParameter("cls_rtn_fee_int")==null?"":request.getParameter("cls_rtn_fee_int"));
		bl.setCls_rtn_etc		(request.getParameter("cls_rtn_etc")==null?"":request.getParameter("cls_rtn_etc"));
		
		bl.setP_bank_id			(request.getParameter("ps_bank_id")==null?"":request.getParameter("ps_bank_id"));
		bl.setP_bank_nm			(request.getParameter("p_bank_nm")==null?"":request.getParameter("p_bank_nm"));
		bl.setP_bank_no			(request.getParameter("p_bank_no")==null?"":request.getParameter("p_bank_no"));
		
		
		flag1 = abl_db.updateBankLend(bl);


		//상환조건
		int rtn_no = Integer.parseInt(request.getParameter("rtn_st"));
		boolean flag = true;
		if(rtn_no != 0){
			if(rtn_no == 1) rtn_no = AddUtil.parseInt(request.getParameter("su"));
			else 			rtn_no = AddUtil.parseInt(request.getParameter("rtn_su"));
			int rtn_size = AddUtil.parseInt(request.getParameter("rtn_size")); //갯수
			BankRtnBean br = new BankRtnBean();
			br.setLend_id(lend_id);
			for(int i=0; i<rtn_size; i++){
				br.setSeq(request.getParameter("rtn_seq"+i)==null?"":request.getParameter("rtn_seq"+i));
				br.setRtn_move_st(request.getParameter("rtn_move_st"+i)==null?"":request.getParameter("rtn_move_st"+i));
				if(bl.getRtn_st().equals("1") && br.getRtn_move_st().equals("0")){//순차&&진행이면 입력하지 않는다.
					br.setRtn_cont_amt	(0);
					br.setRtn_tot_amt	(0);
				}else{
					br.setRtn_cont_amt	(request.getParameter("rtn_cont_amt"+i)==null?0:AddUtil.parseDigit4(request.getParameter("rtn_cont_amt"+i)));
					br.setRtn_tot_amt	(request.getParameter("rtn_tot_amt"+i)==null?0:AddUtil.parseDigit4(request.getParameter("rtn_tot_amt"+i)));
				}
													
				br.setCont_start_dt(request.getParameter("cont_start_dt"+i)==null?"":request.getParameter("cont_start_dt"+i));
				br.setCont_end_dt(request.getParameter("cont_end_dt"+i)==null?"":request.getParameter("cont_end_dt"+i));
				br.setCont_term(request.getParameter("cont_term"+i)==null?"":request.getParameter("cont_term"+i));
				br.setRtn_est_dt(request.getParameter("rtn_est_dt"+i)==null?"":request.getParameter("rtn_est_dt"+i));
				br.setAlt_amt(request.getParameter("alt_amt"+i)==null?0:Util.parseDigit(request.getParameter("alt_amt"+i)));
				br.setRtn_cdt(request.getParameter("rtn_cdt"+i)==null?"":request.getParameter("rtn_cdt"+i));
				br.setRtn_way(request.getParameter("rtn_way"+i)==null?"":request.getParameter("rtn_way"+i));
				br.setLoan_start_dt(request.getParameter("loan_start_dt"+i)==null?"":request.getParameter("loan_start_dt"+i));
				br.setLoan_end_dt(request.getParameter("loan_end_dt"+i)==null?"":request.getParameter("loan_end_dt"+i));
			 	br.setRtn_one_amt(request.getParameter("rtn_one_amt"+i)==null?0:Util.parseDigit(request.getParameter("rtn_one_amt"+i)));
				br.setRtn_one_dt(request.getParameter("rtn_one_dt"+i)==null?"":request.getParameter("rtn_one_dt"+i));
	 			br.setRtn_two_amt(request.getParameter("rtn_two_amt"+i)==null?0:Util.parseDigit(request.getParameter("rtn_two_amt"+i)));
		 		br.setCls_rtn_condi(request.getParameter("cls_rtn_condi"+i)==null?"":request.getParameter("cls_rtn_condi"+i));
			 	br.setDeposit_no(request.getParameter("deposit_no"+i)==null?"":request.getParameter("deposit_no"+i));
				br.setVen_code(request.getParameter("ven_code"+i)==null?"":request.getParameter("ven_code"+i));
								
				
				flag2 = abl_db.updateBankRtn(br);
			}
			for(int i=rtn_size; i<rtn_no; i++){
				br.setSeq(request.getParameter("rtn_seq"+i)==null?"":request.getParameter("rtn_seq"+i));
				br.setRtn_move_st(request.getParameter("rtn_move_st"+i)==null?"":request.getParameter("rtn_move_st"+i));
				br.setRtn_cont_amt(request.getParameter("rtn_cont_amt"+i)==null?0:AddUtil.parseDigit4(request.getParameter("rtn_cont_amt"+i)));
				br.setRtn_tot_amt(request.getParameter("rtn_tot_amt"+i)==null?0:AddUtil.parseDigit4(request.getParameter("rtn_tot_amt"+i)));
				br.setCont_start_dt(request.getParameter("cont_start_dt"+i)==null?"":request.getParameter("cont_start_dt"+i));
				br.setCont_end_dt(request.getParameter("cont_end_dt"+i)==null?"":request.getParameter("cont_end_dt"+i));
				br.setCont_term(request.getParameter("cont_term"+i)==null?"":request.getParameter("cont_term"+i));
				br.setRtn_est_dt(request.getParameter("rtn_est_dt"+i)==null?"":request.getParameter("rtn_est_dt"+i));
				br.setAlt_amt(request.getParameter("alt_amt"+i)==null?0:Util.parseDigit(request.getParameter("alt_amt"+i)));
				br.setRtn_cdt(request.getParameter("rtn_cdt"+i)==null?"":request.getParameter("rtn_cdt"+i));
				br.setRtn_way(request.getParameter("rtn_way"+i)==null?"":request.getParameter("rtn_way"+i));
				br.setLoan_start_dt(request.getParameter("loan_start_dt"+i)==null?"":request.getParameter("loan_start_dt"+i));
				br.setLoan_end_dt(request.getParameter("loan_end_dt"+i)==null?"":request.getParameter("loan_end_dt"+i));
			 	br.setRtn_one_amt(request.getParameter("rtn_one_amt"+i)==null?0:Util.parseDigit(request.getParameter("rtn_one_amt"+i)));
				br.setRtn_one_dt(request.getParameter("rtn_one_dt"+i)==null?"":request.getParameter("rtn_one_dt"+i));
		 		br.setRtn_two_amt(request.getParameter("rtn_two_amt"+i)==null?0:Util.parseDigit(request.getParameter("rtn_two_amt"+i)));
			 	br.setCls_rtn_condi(request.getParameter("cls_rtn_condi"+i)==null?"":request.getParameter("cls_rtn_condi"+i));
			 	br.setDeposit_no(request.getParameter("deposit_no"+i)==null?"":request.getParameter("deposit_no"+i));
				br.setVen_code(request.getParameter("ven_code"+i)==null?"":request.getParameter("ven_code"+i));
				
				flag2 = abl_db.insertBankRtn(br);
			}
		}
	}else if(gubun.equals("a_u")){
		//은행대출담당자 수정
		String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
		BankAgntBean ba = abl_db.getBankAgnt(lend_id, seq);
		ba.setBa_nm(request.getParameter("ba_nm")==null?"":request.getParameter("ba_nm"));
		ba.setBa_title(request.getParameter("ba_title")==null?"":request.getParameter("ba_title"));
		ba.setBa_tel(request.getParameter("ba_tel")==null?"":request.getParameter("ba_tel"));
		ba.setBa_email(request.getParameter("ba_email")==null?"":request.getParameter("ba_email"));
		
		flag3 = abl_db.updateBankAgnt(ba);
	
	}else{
		//은행대출담당자 등록
		BankAgntBean ba = new BankAgntBean();
		ba.setLend_id(lend_id);
		ba.setBa_nm(request.getParameter("ba_nm")==null?"":request.getParameter("ba_nm"));
		ba.setBa_title(request.getParameter("ba_title")==null?"":request.getParameter("ba_title"));
		ba.setBa_tel(request.getParameter("ba_tel")==null?"":request.getParameter("ba_tel"));
		ba.setBa_email(request.getParameter("ba_email")==null?"":request.getParameter("ba_email"));	
		
		flag3 = abl_db.insertBankAgnt(ba);
	}
%>
<script language='javascript'>
<!--
<%	if(!flag1){	%>
		alert('은행대출 오류발생');
<%	}else if(!flag3){	%>
		alert('은행대출담당자 오류발생');
<%	}else if(!flag2){	%>
		alert('상환정보 오류발생');
<%	}else{
		if(gubun.equals("a_i")){%>
		alert('처리되었습니다');
<%		}else{%>		
		alert('수정되었습니다');
<%		}%>		
		parent.location='bank_lend_u.jsp?bank_id=<%=bank_id%>&gubun1=<%=gubun1%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&lend_id=<%=lend_id%>&sh_height=<%=sh_height%>&lend_id=<%=lend_id%>';
<%	}	%>
//-->
</script>
</body>
</html>
