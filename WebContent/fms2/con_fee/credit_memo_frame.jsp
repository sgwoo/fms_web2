<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	String fee_tm 	= request.getParameter("fee_tm")==null?"A":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"0":request.getParameter("tm_st1");
	String bus_id2 	= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String mode 	= request.getParameter("mode")==null?"dly_mm":request.getParameter("mode");
	String memo_st 	= request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	String mm_st2 	= request.getParameter("mm_st2")==null?"settle":request.getParameter("mm_st2");
	
	
	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");
	
	if(acar_de.equals("1000")){
		auth_rw = rs_db.getAuthRwOld(ck_acar_id, "22", "01", "03");
	}	
	
%>
<frameset rows="140,*" border=1>
  <frame src="credit_memo_sh.jsp?auth_rw=<%=auth_rw%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&fee_tm=<%=fee_tm%>&tm_st1=<%=tm_st1%>&bus_id2=<%=bus_id2%>&mode=<%=mode%>&memo_st=<%=memo_st%>&mm_st2=<%=mm_st2%>" name="cm_head" marginwidth=10 marginheight=10 scrolling="auto" noresize>
  <frame src="credit_memo_sc.jsp?auth_rw=<%=auth_rw%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&fee_tm=<%=fee_tm%>&tm_st1=<%=tm_st1%>&bus_id2=<%=bus_id2%>&mode=<%=mode%>&memo_st=<%=memo_st%>&mm_st2=<%=mm_st2%>" name="cm_foot" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>