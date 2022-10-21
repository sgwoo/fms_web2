<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, cust.member.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 		= request.getParameter("client_id")==null?"":request.getParameter("client_id");

	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객FMS
	MemberBean m_bean = m_db.getMemberCase(client_id, "", "");
		
	//회원정보 등록
	MemberBean no_m_bean = m_db.getNoMemberCase(client_id, "", "");
	
	int idcnt = m_db.checkMemberIdPwd("amazoncar", no_m_bean.getPwd());
	String member_pwd = no_m_bean.getPwd();
	if(idcnt > 0){
		member_pwd = member_pwd+""+String.valueOf(idcnt+1);
	}
	
	m_bean.setMember_id("amazoncar");
	m_bean.setPwd(member_pwd);
	
	int count2 = m_db.updateMember(m_bean);


%>
<script language='javascript'>
<%if (count2 == 0) {%>
	alert("처리되지 않았습니다");
	location='about:blank';
<%} else {%>
	alert("처리되었습니다");
	parent.location.reload();	
<%}%>
</script>
