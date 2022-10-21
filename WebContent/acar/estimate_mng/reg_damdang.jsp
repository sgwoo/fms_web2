<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiMBean" scope="page"/>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();

	String userId = request.getParameter("id")==null?"":request.getParameter("id");
	String estId = request.getParameter("estId")==null?"":request.getParameter("estId");
	String note = "담당자 배정 완료";
	String sub = request.getParameter("sub")==null?"":request.getParameter("sub");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	int count = e_db.updateDamdangId(userId, estId);
	
	em_bean.setUser_id(userId);
	em_bean.setEst_id(estId);
	em_bean.setSub(sub);
	em_bean.setNote(note);
	em_bean.setGubun(gubun);
	
	count = e_db.insertEstiM(em_bean);
%>