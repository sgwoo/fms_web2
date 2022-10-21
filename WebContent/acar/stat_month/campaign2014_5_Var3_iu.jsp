<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");	//로그인-ID
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	//로그인-영업소


	String save_dt 		= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");

	
	String year 		= request.getParameter("year")		==null?"":AddUtil.ChangeString(request.getParameter("year")); 
	String tm 		= request.getParameter("tm")		==null?"":AddUtil.ChangeString(request.getParameter("tm")); 
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	
	from_page = "/acar/stat_month/campaign2014_5_sc3.jsp";
	
	
	String o_cs_dt 		= request.getParameter("o_cs_dt")	==null?"":AddUtil.ChangeString(request.getParameter("o_cs_dt")); 
	String o_ce_dt 		= request.getParameter("o_ce_dt")	==null?"":AddUtil.ChangeString(request.getParameter("o_ce_dt"));
	
	
	String cs_dt 		= request.getParameter("cs_dt")		==null?"":AddUtil.ChangeString(request.getParameter("cs_dt")); 
	String ce_dt 		= request.getParameter("ce_dt")		==null?"":AddUtil.ChangeString(request.getParameter("ce_dt"));
	String bs_dt 		= request.getParameter("bs_dt")		==null?"":AddUtil.ChangeString(request.getParameter("bs_dt")); 
	String be_dt 		= request.getParameter("be_dt")		==null?"":AddUtil.ChangeString(request.getParameter("be_dt"));
	int up_per 		= request.getParameter("up_per")	==null?0:AddUtil.parseDigit(request.getParameter("up_per"));
	int down_per 		= request.getParameter("down_per")	==null?0:AddUtil.parseDigit(request.getParameter("down_per"));	
	int amt_per 		= request.getParameter("amt_per")	==null?0:AddUtil.parseDigit(request.getParameter("amt_per"));
	int car_amt 		= request.getParameter("car_amt")	==null?0:AddUtil.parseDigit(request.getParameter("car_amt"));
	int max_dalsung 	= request.getParameter("max_dalsung")	==null?0:AddUtil.parseDigit(request.getParameter("max_dalsung"));
	int min_dalsung 	= request.getParameter("min_dalsung")	==null?0:AddUtil.parseDigit(request.getParameter("min_dalsung"));
	int ga 			= request.getParameter("ga")		==null?0:AddUtil.parseDigit(request.getParameter("ga"));
	int new_ga 		= request.getParameter("new_ga")	==null?0:AddUtil.parseDigit(request.getParameter("new_ga"));
	int cnt_per 		= request.getParameter("cnt_per")	==null?0:AddUtil.parseDigit(request.getParameter("cnt_per"));
	int cost_per 		= request.getParameter("cost_per")	==null?0:AddUtil.parseDigit(request.getParameter("cost_per"));		
	String ns_dt1 		= request.getParameter("ns_dt1")	==null?"":AddUtil.ChangeString(request.getParameter("ns_dt1"));
	String ns_dt2 		= request.getParameter("ns_dt2")	==null?"":AddUtil.ChangeString(request.getParameter("ns_dt2"));
	String ns_dt3 		= request.getParameter("ns_dt3")	==null?"":AddUtil.ChangeString(request.getParameter("ns_dt3"));
	String ns_dt4 		= request.getParameter("ns_dt4")	==null?"":AddUtil.ChangeString(request.getParameter("ns_dt4"));
	String ne_dt1 		= request.getParameter("ne_dt1")	==null?"":AddUtil.ChangeString(request.getParameter("ne_dt1"));
	String ne_dt2 		= request.getParameter("ne_dt2")	==null?"":AddUtil.ChangeString(request.getParameter("ne_dt2"));
	String ne_dt3 		= request.getParameter("ne_dt3")	==null?"":AddUtil.ChangeString(request.getParameter("ne_dt3"));
	String ne_dt4 		= request.getParameter("ne_dt4")	==null?"":AddUtil.ChangeString(request.getParameter("ne_dt4"));
	int n_cnt1 		= request.getParameter("n_cnt1")	==null?0:AddUtil.parseDigit(request.getParameter("n_cnt1"));
	int n_cnt2 		= request.getParameter("n_cnt2")	==null?0:AddUtil.parseDigit(request.getParameter("n_cnt2"));
	int n_cnt3 		= request.getParameter("n_cnt3")	==null?0:AddUtil.parseDigit(request.getParameter("n_cnt3"));
	int n_cnt4 		= request.getParameter("n_cnt4")	==null?0:AddUtil.parseDigit(request.getParameter("n_cnt4"));
	String base_end_dt1 	= request.getParameter("base_end_dt1")	==null?"":AddUtil.ChangeString(request.getParameter("base_end_dt1"));
	String base_end_dt2 	= request.getParameter("base_end_dt2")	==null?"":AddUtil.ChangeString(request.getParameter("base_end_dt2"));


	int result = 0;
	
	//수정
	if(o_cs_dt.equals(cs_dt) && o_ce_dt.equals(ce_dt)){
	
		result 	= cmp_db.updateCampaignVar_20140501(year, tm, "2_1", cs_dt, ce_dt, bs_dt, be_dt, up_per, down_per, amt_per, car_amt, max_dalsung, ga, new_ga, ns_dt1, ns_dt2, ns_dt3, ns_dt4, ne_dt1, ne_dt2, ne_dt3, ne_dt4, n_cnt1, n_cnt2, n_cnt3, n_cnt4, cnt_per, cost_per, base_end_dt1, base_end_dt2, min_dalsung);
	
	//등록	
	}else{
	
		year 	= cs_dt.substring(0,4);
		tm 	= cs_dt.substring(4,6);
		
		result 	= cmp_db.insertCampaignVar_20140501(year, tm, "2_1", cs_dt, ce_dt, bs_dt, be_dt, up_per, down_per, amt_per, car_amt, max_dalsung, ga, new_ga, ns_dt1, ns_dt2, ns_dt3, ns_dt4, ne_dt1, ne_dt2, ne_dt3, ne_dt4, n_cnt1, n_cnt2, n_cnt3, n_cnt4, cnt_per, cost_per, base_end_dt1, base_end_dt2, min_dalsung);
		
	}
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='' method="POST">
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='from_page' 	value='<%=from_page%>'>
<input type='hidden' name='mode' 	value='9'>
</form>
<script language="JavaScript">
<!--

	var fm = document.form1;
	fm.action = '/acar/admin/stat_end_null_200911.jsp';
	
<%if(result >= 1){%>
	alert("수정되었습니다.\n\n변경된 변수가 반영된 캠페인을 마감합니다. 기다려 주십시오.");
	fm.submit();		
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>

//-->
</script>
</body>
</html>
