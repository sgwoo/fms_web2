<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	boolean flag = true;
	
	String m_id		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st		= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	String fee_tm 		= request.getParameter("fee_tm")==null?"A":request.getParameter("fee_tm");
	String tm_st1 		= request.getParameter("tm_st1")==null?"0":request.getParameter("tm_st1");
	String check_all 	= request.getParameter("check_all")==null?"N":"Y";
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String memo_st 	= request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	String mm_st2 	= request.getParameter("mm_st2")==null?"settle":request.getParameter("mm_st2");
	
	if(check_all.equals("Y")) 	fee_tm = "A";
	if(fee_tm.equals("")) 		fee_tm = "A";
	
	if(tm_st1.equals("")) 		tm_st1 = "0";
	
	LoginBean login = LoginBean.getInstance();
	String reg_id = login.getCookieValue(request, "acar_id");
	
	FeeMemoBean memo = new FeeMemoBean();
	memo.setRent_mng_id	(m_id);
	memo.setRent_l_cd	(l_cd);
	memo.setRent_st		(r_st);
	memo.setTm_st1		(tm_st1);
	memo.setFee_tm		(fee_tm);
	memo.setReg_id		(reg_id);
	memo.setReg_dt		(request.getParameter("t_reg_dt"));
	memo.setContent		(AddUtil.nullToNbsp(request.getParameter("t_content")));
	memo.setSpeaker		(request.getParameter("t_speaker"));
	memo.setPromise_dt(request.getParameter("t_promise_dt")==null?"":request.getParameter("t_promise_dt"));
	memo.setMm_st2		(request.getParameter("t_mm_st")==null?"":request.getParameter("t_mm_st"));
	
	flag = af_db.insertFeeMemo(memo);
%>
<form name='form1' action='fee_memo_frame_s.jsp' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='fee_tm' value='<%=request.getParameter("fee_tm")%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='memo_st' value='<%=memo_st%>'>
<input type='hidden' name='mm_st2' value='<%=mm_st2%>'>
</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
<%	}else{%>
		alert('등록되었습니다');
		<%if(from_page.equals("credit_memo")){%>
		document.form1.action = 'credit_memo_sc.jsp';
		document.form1.target = 'cm_foot';
		<%}else{%>
		document.form1.action = 'fee_memo_frame_s.jsp';		
		document.form1.target = 'FEE_MEMO';
		<%}%>
		document.form1.submit();

<%	}%>

</script>
</body>
</html>
