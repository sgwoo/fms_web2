<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.fee.*, tax.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="f_db" scope="page" class="acar.fee.FeeDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
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
	String rent_seq	= request.getParameter("h_rent_seq");
	String gubun	= request.getParameter("h_ext_gubun");
	String page_gubun = request.getParameter("page_gubun")==null?"":request.getParameter("page_gubun");
	int flag = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();

	//회차연장
	if(gubun.equals("EXT")){
		String fee_est_dt	= request.getParameter("t_fee_est_dt");
		int fee_s_amt		= request.getParameter("t_fee_s_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_s_amt"));
		int fee_v_amt		= request.getParameter("t_fee_v_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_v_amt"));
		
		FeeScdBean ext_fee = new FeeScdBean();
		ext_fee.setRent_mng_id(m_id);
		ext_fee.setRent_l_cd(l_cd);
		ext_fee.setFee_tm(fee_tm);
		ext_fee.setRent_st(r_st);
		ext_fee.setRent_seq(rent_seq);
		ext_fee.setTm_st1("0");	//월대여료로 세팅(not 잔액)
		ext_fee.setTm_st2("1");	//회차연장대여료 (not 일반대여료)
		ext_fee.setFee_est_dt(fee_est_dt);
		ext_fee.setFee_s_amt(fee_s_amt);
		ext_fee.setFee_v_amt(fee_v_amt);
		ext_fee.setRc_yn("0");
		ext_fee.setR_fee_est_dt(f_db.getValidDt(ext_fee.getFee_est_dt()));
		ext_fee.setUpdate_id(user_id);
		ext_fee.setBill_yn("Y");
		ext_fee.setRent_seq("1");
		
		if(!af_db.insertFeeScdAdd(ext_fee))	flag += 1;
		
		//회차연장 후 연체료 계산
		af_db.calDelay(ext_fee.getRent_mng_id(), ext_fee.getRent_l_cd());
	}
	
	//연장회차 삭제 
	else if(gubun.equals("DROP")){
		String tm_st1	= request.getParameter("h_tm_st1");	
		
		//대여료스케줄 한회차 정보
		FeeScdBean fee_scd = af_db.getScdNew(m_id, l_cd, r_st, rent_seq, fee_tm, tm_st1);
		
		//임의연장일 경우 계산서 발행직전이라면 기거래명세서는 사용중지한다.
		if(fee_scd.getTm_st2().equals("3")){
			//기발행 거래명세서 계산서 미발행상태일 경우 기발행 거래명세서 계산서예정일자도 변경 할것..
			int chk_cnt1 = af_db.getTaxDtChk(l_cd, r_st, rent_seq, fee_tm);
			String item_id = "";
			//계산서 미발행상태
			if(chk_cnt1 ==0){
				item_id = af_db.getTaxItemDtChk(l_cd, r_st, rent_seq, fee_tm);
				if(!item_id.equals("")){
					//거래명세서 조회
					TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
					ti_bean.setUse_yn	("N");
					if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
					System.out.println("대여료 스케줄 삭제시 거래명세서 사용중지 "+ l_cd +" "+fee_tm);
				}
			}
		}
		
		if(!af_db.dropFeeScdNew(m_id, l_cd, r_st, rent_seq, fee_tm, tm_st1)) 	flag += 1;
	}
	
	else{}
%>
<html><head><title>FMS</title></head>
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
		parent.close();
<%	}else{
		if(gubun.equals("EXT")){%>
		alert('처리되었습니다');
			<%if(page_gubun.equals("")){%>
				parent.opener.i_in.location='/fms2/con_fee/fee_c_mgr_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&prv_mon_yn=<%=prv_mon_yn%>';
			<%}else{%>
				parent.opener.i_in2.location='/acar/con_cls/fee_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&prv_mon_yn=<%=prv_mon_yn%>';
			<%}%>						
		<%}else{//삭제%>		
		alert('처리되었습니다');
		parent.i_in.location='/fms2/con_fee/fee_c_mgr_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&prv_mon_yn=<%=prv_mon_yn%>';
		<%}%>
		parent.close();	
<%	}%>
</script>
</body>
</html>
