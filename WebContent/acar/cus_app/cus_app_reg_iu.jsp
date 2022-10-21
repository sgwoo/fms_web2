<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_app.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String aaa = request.getParameter("aaa")==null?"":request.getParameter("aaa");
	String aab = request.getParameter("aab")==null?"":request.getParameter("aab");
	String aac = request.getParameter("aac")==null?"":request.getParameter("aac");
	String aad = request.getParameter("aad")==null?"":request.getParameter("aad");
	String aae = request.getParameter("aae")==null?"":request.getParameter("aae");
	String aba = request.getParameter("aba")==null?"":request.getParameter("aba");
	String abb = request.getParameter("abb")==null?"":request.getParameter("abb");
	String abc = request.getParameter("abc")==null?"":request.getParameter("abc");
	String abd = request.getParameter("abd")==null?"":request.getParameter("abd");
	String aca = request.getParameter("aca")==null?"":request.getParameter("aca");
	String acb = request.getParameter("acb")==null?"":request.getParameter("acb");
	String acc = request.getParameter("acc")==null?"":request.getParameter("acc");
	String ada = request.getParameter("ada")==null?"":request.getParameter("ada");
	String adb = request.getParameter("adb")==null?"":request.getParameter("adb");
	String baa = request.getParameter("baa")==null?"":request.getParameter("baa");
	String bba = request.getParameter("bba")==null?"":request.getParameter("bba");
	String bbb = request.getParameter("bbb")==null?"":request.getParameter("bbb");
	String bbc = request.getParameter("bbc")==null?"":request.getParameter("bbc");
	String bbd = request.getParameter("bbd")==null?"":request.getParameter("bbd");
	String bca = request.getParameter("bca")==null?"":request.getParameter("bca");
	String bcb = request.getParameter("bcb")==null?"":request.getParameter("bcb");
	String bcc = request.getParameter("bcc")==null?"":request.getParameter("bcc");
	String bcd = request.getParameter("bcd")==null?"":request.getParameter("bcd");
	String bda = request.getParameter("bda")==null?"":request.getParameter("bda");
	String bdb = request.getParameter("bdb")==null?"":request.getParameter("bdb");
	String bdc = request.getParameter("bdc")==null?"":request.getParameter("bdc");
	String bdd = request.getParameter("bdd")==null?"":request.getParameter("bdd");
	String caa = request.getParameter("caa")==null?"":request.getParameter("caa");
	String cbb = request.getParameter("cbb")==null?"":request.getParameter("cbb");
	String ccc = request.getParameter("ccc")==null?"":request.getParameter("ccc");
	String cdd = request.getParameter("cdd")==null?"":request.getParameter("cdd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	int result = 0;
	
	CusAppBean caBn = new CusAppBean();
	caBn.setClient_id(client_id);
	caBn.setAaa(aaa);
	caBn.setAab(aab);
	caBn.setAac(aac);
	caBn.setAad(aad);
	caBn.setAae(aae);
	caBn.setAba(aba);
	caBn.setAbb(abb);
	caBn.setAbc(abc);
	caBn.setAbd(abd);
	caBn.setAca(aca);
	caBn.setAcb(acb);
	caBn.setAcc(acc);
	caBn.setAda(ada);
	caBn.setAdb(adb);
	caBn.setBaa(baa);
	caBn.setBba(bba);
	caBn.setBbb(bbb);
	caBn.setBbc(bbc);
	caBn.setBbd(bbd);
	caBn.setBca(bca);
	caBn.setBcb(bcb);
	caBn.setBcc(bcc);
	caBn.setBcd(bcd);
	caBn.setBda(bda);
	caBn.setBdb(bdb);
	caBn.setBdc(bdc);
	caBn.setBdd(bdd);
	caBn.setCaa(caa);
	caBn.setCbb(cbb);
	caBn.setCcc(ccc);
	caBn.setCdd(cdd);

	CusApp_Database ca_db = CusApp_Database.getInstance();
	if(gubun.equals("i")){
		result = ca_db.insertCus_app(caBn);
	}else if(gubun.equals("u")){
		result = ca_db.updateCus_app(caBn);
	}
	
%>

<html>
<head><title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result>0){
	if(gubun.equals("i")){%>
		alert("등록되었습니다.");
	<%}else if(gubun.equals("u")){%>
		alert("수정되었습니다.");
	<%}%>
	parent.location.href ="cus_app_reg.jsp?client_id=<%= client_id %>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>
