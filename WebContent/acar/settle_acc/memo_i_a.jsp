<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.fee.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	boolean flag = true;
	String m_id		= request.getParameter("m_id");
	String l_cd		= request.getParameter("l_cd");
	String r_st		= request.getParameter("r_st");
	String fee_tm	= request.getParameter("fee_tm");
	String tm_st1	= request.getParameter("tm_st1");
	String check_all = request.getParameter("check_all")==null?"N":"Y";
	if(check_all.equals("Y")) fee_tm = "A";
	
	LoginBean login = LoginBean.getInstance();
	String reg_id = login.getCookieValue(request, "acar_id");

	FeeMemoBean memo = new FeeMemoBean();
	memo.setRent_mng_id(m_id);
	memo.setRent_l_cd(l_cd);
	memo.setRent_st(r_st);
	memo.setTm_st1(tm_st1);
	//memo.setSeq("");
	memo.setFee_tm(fee_tm);
	memo.setReg_id(reg_id);	// cookie세팅
	memo.setReg_dt(request.getParameter("t_reg_dt"));
	memo.setContent(request.getParameter("t_content"));
	memo.setSpeaker(request.getParameter("t_speaker"));
	
	flag = af_db.insertFeeMemo(memo);


%>
<form name='form1' action='/fms2/con_fee/fee_memo_frame_s.jsp' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='fee_tm' value='<%=request.getParameter("fee_tm")%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='auth_rw' value='R/W'>
</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{%>
		alert('등록되었습니다');
		document.form1.target = 'FEE_MEMO';
		document.form1.submit();
<%	}%>

</script>
</body>
</html>
