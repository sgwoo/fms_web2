<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	/* 대여료변경 */
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String prv_mon_yn = request.getParameter("prv_mon_yn")==null?"":request.getParameter("prv_mon_yn");//출고전대차기간포함여부
	String m_id	= request.getParameter("m_id");
	String l_cd	= request.getParameter("l_cd");
	int s_fee_tm = request.getParameter("s_fee_tm")==null?0:Util.parseDigit(request.getParameter("s_fee_tm"));	//선택된 회차
	int fee_s_amt = request.getParameter("t_fee_s_amt_c")==null?0:Util.parseDigit(request.getParameter("t_fee_s_amt_c"));
	int fee_v_amt = request.getParameter("t_fee_v_amt_c")==null?0:Util.parseDigit(request.getParameter("t_fee_v_amt_c"));
	String pay_cng_cau = request.getParameter("t_pay_cng_cau")==null?"":request.getParameter("t_pay_cng_cau");//변경사유
	int flag = 0;

	FeeScdBean ext_fee = new FeeScdBean();
	ext_fee.setRent_mng_id(m_id);
	ext_fee.setRent_l_cd(l_cd);
	ext_fee.setFee_s_amt(fee_s_amt);
	ext_fee.setFee_v_amt(fee_v_amt);
	ext_fee.setUpdate_id(user_id);
	ext_fee.setPay_cng_cau(pay_cng_cau);
	
	flag = af_db.changeFeeamt(ext_fee, s_fee_tm);	//연체료 계산
%>
<html><head><title>FMS</title></head>
<body>
<form name='form1' action='/fms2/con_fee/fee_c_mgr_in.jsp' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='prv_mon_yn' value='<%=prv_mon_yn%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{%>
		alert('처리되었습니다');
		parent.opener.i_in.location='/fms2/con_fee/fee_c_mgr_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&prv_mon_yn=<%=prv_mon_yn%>';				
		parent.close();		
<%	}%>
</script>
</body>
</html>
