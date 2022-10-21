<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	String s_vid_size	= request.getParameter("vid_size")	==null?"":request.getParameter("vid_size");
	String h_cnt	= request.getParameter("h_cnt")	==null?"":request.getParameter("h_cnt");

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String vid[] = request.getParameterValues("ch_cd");
	int vid_size=vid.length;
	int cnt = 0;
	
	String value01[] = request.getParameterValues("p_st1");
	String value02[] = request.getParameterValues("p_st2");
	String value03[] = request.getParameterValues("p_st3");
	String value04[] = request.getParameterValues("p_cd1");
	String value05[] = request.getParameterValues("p_cd2");
	String value06[] = request.getParameterValues("p_cd3");
	String value07[] = request.getParameterValues("amt");
	String value08[] = request.getParameterValues("bank_nm");
	String value09[] = request.getParameterValues("bank_no");
	String value10[] = request.getParameterValues("off_st");
	String value11[] = request.getParameterValues("off_id");
	String value12[] = request.getParameterValues("off_nm");
	String value13[] = request.getParameterValues("p_cont");
	String value14[] = request.getParameterValues("p_way");
	String value15[] = request.getParameterValues("p_cd4");
	String value16[] = request.getParameterValues("p_cd5");
	String value17[] = request.getParameterValues("p_st4");
	String value18[] = request.getParameterValues("p_st5");
	String value19[] = request.getParameterValues("est_dt");
	String value20[] = request.getParameterValues("ven_code");
	String value21[] = request.getParameterValues("ven_name");
	String value22[] = request.getParameterValues("bank_id");
	String value23[] = request.getParameterValues("sub_amt1");
	String value24[] = request.getParameterValues("sub_amt2");
	String value25[] = request.getParameterValues("sub_amt3");
	String value26[] = request.getParameterValues("card_id");
	String value27[] = request.getParameterValues("card_nm");
	String value28[] = request.getParameterValues("card_no");
	String value29[] = request.getParameterValues("sub_amt4");
	String value30[] = request.getParameterValues("sub_amt5");
	String value31[] = request.getParameterValues("a_bank_id");
	String value32[] = request.getParameterValues("a_bank_nm");
	String value33[] = request.getParameterValues("a_bank_no");
	String value34[] = request.getParameterValues("buy_user_id");
	String value35[] = request.getParameterValues("s_idno");
	String value36[] = request.getParameterValues("acct_code");
	String value37[] = request.getParameterValues("bank_acc_nm");
	String value38[] = request.getParameterValues("bank_cms_bk");
	String value39[] = request.getParameterValues("a_bank_cms_bk");
	String value40[] = request.getParameterValues("off_tel");
	String value41[] = request.getParameterValues("sub_amt6");
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<body>
<script language='javascript'>
<!--
	var fm = opener.document.form1;
  	
  	var s_idx = toInt(fm.h_cnt.value);
  	
  	
  	
  	<%
  		for(int i=0; i<vid.length;i++){
  		
  			int idx			= AddUtil.parseInt(vid[i]);
  	%>
  	
  			opener.tr_h_item<%=AddUtil.parseInt(h_cnt)+1+i%>.style.display = '';	
  			
  			fm.h_p_st2[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value02[idx]%>';
			fm.off_nm[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value12[idx]%>';
			fm.ven_name[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value21[idx]%>';
			fm.p_cont[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value13[idx]%>';
			fm.amt[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value07[idx]%>';
			fm.sub_amt2[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value24[idx]%>';
			fm.h_p_st3[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value03[idx]%>';
			fm.h_bank_nm[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value08[idx]%>';
			fm.h_bank_no[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value09[idx]%>';
			fm.h_card_nm[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value27[idx]%>';
			fm.h_card_no[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value28[idx]%>';
			
			fm.p_st1[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value01[idx]%>';
			fm.p_st2[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value02[idx]%>';
			fm.p_st3[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value03[idx]%>';
			fm.p_cd1[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value04[idx]%>';
			fm.p_cd2[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value05[idx]%>';
			fm.p_cd3[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value06[idx]%>';
			fm.bank_nm[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value08[idx]%>';
			fm.bank_no[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value09[idx]%>';
			fm.off_st[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value10[idx]%>';
			fm.off_id[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value11[idx]%>';
			fm.p_way[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value14[idx]%>';
			fm.p_cd4[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value15[idx]%>';
			fm.p_cd5[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value16[idx]%>';
			fm.p_st4[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value17[idx]%>';
			fm.p_st5[<%=AddUtil.parseInt(h_cnt)+i%>].value 		= '<%=value18[idx]%>';
			
			fm.est_dt[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value19[idx]%>';
			fm.ven_code[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value20[idx]%>';
			fm.bank_id[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value22[idx]%>';
			fm.sub_amt1[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value23[idx]%>';
			fm.sub_amt3[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value25[idx]%>';
			fm.card_id[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value26[idx]%>';
			fm.card_nm[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value27[idx]%>';
			fm.card_no[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value28[idx]%>';
			fm.sub_amt4[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value29[idx]%>';
			fm.sub_amt5[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value30[idx]%>';
			fm.a_bank_id[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value31[idx]%>';
			fm.a_bank_nm[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value32[idx]%>';
			fm.a_bank_no[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value33[idx]%>';
			fm.buy_user_id[<%=AddUtil.parseInt(h_cnt)+i%>].value= '<%=value34[idx]%>';
			fm.s_idno[<%=AddUtil.parseInt(h_cnt)+i%>].value		= '<%=value35[idx]%>';
			fm.acct_code[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value36[idx]%>';
			fm.bank_acc_nm[<%=AddUtil.parseInt(h_cnt)+i%>].value= '<%=value37[idx]%>';
			fm.bank_cms_bk[<%=AddUtil.parseInt(h_cnt)+i%>].value= '<%=value38[idx]%>';
			fm.a_bank_cms_bk[<%=AddUtil.parseInt(h_cnt)+i%>].value= '<%=value39[idx]%>';
			fm.off_tel[<%=AddUtil.parseInt(h_cnt)+i%>].value	= '<%=value40[idx]%>';
			fm.sub_amt6[<%=AddUtil.parseInt(h_cnt)+i%>].value 	= '<%=value41[idx]%>';
  	
  	<%	}  	%>
  	
  	fm.h_cnt.value = toInt(fm.h_cnt.value)+<%=vid.length%>;
  	
  	self.window.close();
  	
  	
  		
//-->
</script>
</body>
</html>
