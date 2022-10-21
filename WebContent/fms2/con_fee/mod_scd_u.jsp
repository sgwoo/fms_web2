<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%	/* 미입금 대여료, 입금된 대여료의 입금일 변경 */
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
	String rent_seq = request.getParameter("h_rent_seq");
	int fee_s_amt	= request.getParameter("h_fee_s_amt")==null?0:Util.parseDigit(request.getParameter("h_fee_s_amt"));
	int fee_v_amt	= request.getParameter("h_fee_v_amt")==null?0:Util.parseDigit(request.getParameter("h_fee_v_amt"));
	String rc_dt	= request.getParameter("h_rc_dt");
	String ext_dt = request.getParameter("h_fee_ext_dt")==null?"":request.getParameter("h_fee_ext_dt");//세금계산서발행일자
	String page_gubun = request.getParameter("page_gubun")==null?"":request.getParameter("page_gubun");

	FeeScdBean cng_fee = af_db.getScdNew(m_id, l_cd, r_st, rent_seq, fee_tm, tm_st1);
	cng_fee.setRent_l_cd(l_cd);
	cng_fee.setFee_s_amt(fee_s_amt);
	cng_fee.setFee_v_amt(fee_v_amt);
	cng_fee.setRc_dt(rc_dt);
	cng_fee.setExt_dt(ext_dt);
	cng_fee.setUpdate_id(user_id);
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
<%	if(!af_db.updateFeeScd(cng_fee)){%>
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