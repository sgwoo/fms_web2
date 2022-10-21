<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  card.*, acar.user_mng.*" %>
<jsp:useBean id="bean" class="card.BudgetBean" scope="page"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	//사용자별 정보 등록/수정 처리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");//update, inpsert 구분
		
	int count = 0;
	
	bean.setUser_id(user_id);
		
	bean.setPrv(request.getParameter("prv")==null?0:AddUtil.parseDigit(request.getParameter("prv")));
	bean.setJan(request.getParameter("jan")==null?0:AddUtil.parseDigit(request.getParameter("jan")));
	bean.setFeb(request.getParameter("feb")==null?0:AddUtil.parseDigit(request.getParameter("feb")));
	bean.setMar(request.getParameter("mar")==null?0:AddUtil.parseDigit(request.getParameter("mar")));
	bean.setApr(request.getParameter("apr")==null?0:AddUtil.parseDigit(request.getParameter("apr")));
	bean.setMay(request.getParameter("may")==null?0:AddUtil.parseDigit(request.getParameter("may")));
	bean.setJun(request.getParameter("jun")==null?0:AddUtil.parseDigit(request.getParameter("jun")));
	bean.setJul(request.getParameter("jul")==null?0:AddUtil.parseDigit(request.getParameter("jul")));
	bean.setAug(request.getParameter("aug")==null?0:AddUtil.parseDigit(request.getParameter("aug")));
	bean.setSep(request.getParameter("sep")==null?0:AddUtil.parseDigit(request.getParameter("sep")));
	bean.setOct(request.getParameter("oct")==null?0:AddUtil.parseDigit(request.getParameter("oct")));
	bean.setNov(request.getParameter("nov")==null?0:AddUtil.parseDigit(request.getParameter("nov")));
	bean.setDec(request.getParameter("dec")==null?0:AddUtil.parseDigit(request.getParameter("dec"))); //회식
	
	bean.setJan1(request.getParameter("jan1")==null?0:AddUtil.parseDigit(request.getParameter("jan1")));
	bean.setFeb1(request.getParameter("feb1")==null?0:AddUtil.parseDigit(request.getParameter("feb1")));
	bean.setMar1(request.getParameter("mar1")==null?0:AddUtil.parseDigit(request.getParameter("mar1")));
	bean.setApr1(request.getParameter("apr1")==null?0:AddUtil.parseDigit(request.getParameter("apr1")));
	bean.setMay1(request.getParameter("may1")==null?0:AddUtil.parseDigit(request.getParameter("may1")));
	bean.setJun1(request.getParameter("jun1")==null?0:AddUtil.parseDigit(request.getParameter("jun1")));
	bean.setJul1(request.getParameter("jul1")==null?0:AddUtil.parseDigit(request.getParameter("jul1")));
	bean.setAug1(request.getParameter("aug1")==null?0:AddUtil.parseDigit(request.getParameter("aug1")));
	bean.setSep1(request.getParameter("sep1")==null?0:AddUtil.parseDigit(request.getParameter("sep1")));
	bean.setOct1(request.getParameter("oct1")==null?0:AddUtil.parseDigit(request.getParameter("oct1")));
	bean.setNov1(request.getParameter("nov1")==null?0:AddUtil.parseDigit(request.getParameter("nov1")));
	bean.setDec1(request.getParameter("dec1")==null?0:AddUtil.parseDigit(request.getParameter("dec1"))); //포상(장기근속)
	
	bean.setByear(request.getParameter("byear")==null?"":request.getParameter("byear"));
	bean.setBgubun(request.getParameter("bgubun")==null?"1":request.getParameter("bgubun"));
		
	if(cmd.equals("i")){
		count = CardDb.insertUserBudget(bean);
	}else if(cmd.equals("u")){
		count = CardDb.updateUserBudget(bean);
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<%	if(cmd.equals("u")){
		if(count==1){%>
	alert("정상적으로 수정되었습니다.");
	parent.location.reload();
<%		}
	}else{
		if(count==1){%>
	alert("정상적으로 등록되었습니다.");
	parent.location.reload();
<%		}
	}%>
</script>
</body>
</html>