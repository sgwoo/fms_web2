<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%	/*입금취소*/
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
	String tm_st2	= request.getParameter("h_tm_st2");
	String rent_seq = request.getParameter("h_rent_seq")==null?"1":request.getParameter("h_rent_seq");
	String page_gubun = request.getParameter("page_gubun")==null?"":request.getParameter("page_gubun");
	int fee_amt	= request.getParameter("h_fee_amt")==null?0:Integer.parseInt(request.getParameter("h_fee_amt"));
	int rc_amt	= request.getParameter("h_rc_amt")==null?0:Integer.parseInt(request.getParameter("h_rc_amt"));
	int flag = 0;
	
	//out.println("rc_amt="+rc_amt);
	//out.println("fee_amt="+fee_amt);
	//out.println("r_st="+r_st);
	//out.println("rent_seq="+rent_seq);
	//out.println("fee_tm="+fee_tm);
	//out.println("tm_st1="+tm_st1);
	//out.println("tm_st2="+tm_st2);
	
	FeeScdBean pay_fee = af_db.getScdNew(m_id, l_cd, r_st, rent_seq, fee_tm, tm_st1, tm_st2);
	pay_fee.setRc_yn("0");
	pay_fee.setRc_dt("");
	pay_fee.setRc_amt(0);
	pay_fee.setUpdate_id(user_id);
	
	if(rc_amt<fee_amt){	//입금예정액보다 실입금액이 적을경우--> 잔액라인 제거해줘야 함.
		
		//out.println("tm_st1="+String.valueOf(Integer.parseInt(tm_st1)+1));
		//취소회차이후 잔액은 삭제
		if(!af_db.dropFeeScdNew(m_id, l_cd, r_st, rent_seq, fee_tm, String.valueOf(Integer.parseInt(tm_st1)+1),tm_st2)) 			flag += 1;
		//취소회차 수정
		if(!af_db.updateFeeScd(pay_fee)) 			flag += 1;
		
	}else{
		
		if(!af_db.updateFeeScd(pay_fee)) 			flag += 1;
		
	}
	
	//if(1==1)return;
	
	af_db.calDelay(m_id, l_cd);	//연체료 계산
%>
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
<%	}else{%>
		alert('처리되었습니다');
		<%if(page_gubun.equals("")){%>
		parent.i_in.location='/fms2/con_fee/fee_c_mgr_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&prv_mon_yn=<%=prv_mon_yn%>';
		<%}else{%>
		parent.i_in2.location='/acar/con_cls/fee_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&prv_mon_yn=<%=prv_mon_yn%>';
		<%}%>		
		parent.close();
<%	}%>
</script>