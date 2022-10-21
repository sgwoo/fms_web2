<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body leftmargin="15">
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String m_mail1 = request.getParameter("m_mail1")==null?"":request.getParameter("m_mail1");
	String m_mail2 = request.getParameter("m_mail2")==null?"":request.getParameter("m_mail2");
	String m_mail3 = request.getParameter("m_mail3")==null?"":request.getParameter("m_mail3");
	String m_st1 = request.getParameter("m_st1")==null?"":request.getParameter("m_st1");
	String m_st2 = request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_st3 = request.getParameter("m_st3")==null?"":request.getParameter("m_st3");
	String mm_yn1 = request.getParameter("mm_yn1")==null?"Y":request.getParameter("mm_yn1");
	String mm_yn2 = request.getParameter("mm_yn2")==null?"Y":request.getParameter("mm_yn2");
	String mm_yn3 = request.getParameter("mm_yn3")==null?"Y":request.getParameter("mm_yn3");
	
	if(mm_yn1.equals("")) mm_yn1 = "Y";
	if(mm_yn2.equals("")) mm_yn2 = "Y";
	if(mm_yn3.equals("")) mm_yn3 = "Y";
	
	boolean flag = true;

	CarMgrBean mgr1 = a_db.getCarMgr(m_id, l_cd, m_st1);
	mgr1.setMgr_email(m_mail1.trim());
	mgr1.setEmail_yn(mm_yn1);
	
	if(!mgr1.getMgr_nm().equals("")){
		flag = a_db.updateCarMgr(mgr1);
		
		//동일인물은 자동입력
		flag = al_db.updateClientMgrEmail(client_id, mgr1.getMgr_nm(), mgr1.getMgr_email(), mm_yn1);
	}


	CarMgrBean mgr2 = a_db.getCarMgr(m_id, l_cd, m_st2);
	mgr2.setMgr_email(m_mail2.trim());
	mgr2.setEmail_yn(mm_yn2);
	if(!mgr2.getMgr_nm().equals("")){
		flag = a_db.updateCarMgr(mgr2);
		
		//동일인물은 자동입력
		flag = al_db.updateClientMgrEmail(client_id, mgr2.getMgr_nm(), mgr2.getMgr_email(), mm_yn2);
	}

	CarMgrBean mgr3 = a_db.getCarMgr(m_id, l_cd, m_st3);
	mgr3.setMgr_email(m_mail3.trim());
	mgr3.setEmail_yn(mm_yn3);
	if(!mgr3.getMgr_nm().equals("")){
		flag = a_db.updateCarMgr(mgr3);
		
		//동일인물은 자동입력
		flag = al_db.updateClientMgrEmail(client_id, mgr3.getMgr_nm(), mgr3.getMgr_email(), mm_yn3);
	}
%>
<script language='javascript'>
<%	if(flag){%>
		alert('수정되었습니다');
		parent.location.href = "client_email.jsp?client_id=<%=client_id%>";
<%	}else{%>
		alert('수정되지 않았습니다');
<%	}%>
</script>
</body>
</html>
