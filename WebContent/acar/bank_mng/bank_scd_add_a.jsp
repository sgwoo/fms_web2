<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.bank_mng.*, acar.fee.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

	int from_tm	= request.getParameter("from_tm").equals("")?0:Integer.parseInt(request.getParameter("from_tm"));
	int add_tm	= request.getParameter("add_tm").equals("")?0:Integer.parseInt(request.getParameter("add_tm"));

	int flag = 0;
	int flag2 = 0;
	
	int cal_tm = from_tm + add_tm;
	
	for(int i = from_tm ; i <  cal_tm ; i++){
	
		BankScdBean bs = new BankScdBean();
		bs.setLend_id		(lend_id);
		bs.setRtn_seq		(rtn_seq);
		bs.setAlt_tm		(Integer.toString( i ));
		bs.setAlt_est_dt("");
		bs.setAlt_prn_amt	(0);
		bs.setAlt_int_amt	(0);
		bs.setPay_dt		("");
		bs.setPay_yn		("0");
		bs.setAlt_rest		(0);
		bs.setR_alt_est_dt	("");
		if(!abl_db.insertBankScd(bs))	flag += 1;
			
	}
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert('수정되지 않았습니다');
		location='about:blank';
<%	}else{%>
		alert('수정되었습니다');
		var fm = document.form1;
		fm.target='d_content';
		fm.action='bank_scd_u.jsp';
		fm.submit();
<%	}%>
</script>
</body>
</html>
