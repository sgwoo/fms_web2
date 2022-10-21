<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.ext.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String h_fee_tm = request.getParameter("h_fee_tm")==null?"":request.getParameter("h_fee_tm");
	String h_tm_st1 = request.getParameter("h_tm_st1")==null?"":request.getParameter("h_tm_st1");
	String cls_tm = request.getParameter("cls_tm")==null?"":request.getParameter("cls_tm");
	String rent_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String table_nm = request.getParameter("credit_st")==null?"":request.getParameter("credit_st");
	int count = 0;
	
	if(table_nm.equals("scd_ext")){
		if(!ae_db.getCreditScd(table_nm, m_id, l_cd, rent_st, cls_tm, "", user_id)) 			count = 1;
	}else{
		if(!ae_db.getCreditScd(table_nm, m_id, l_cd, rent_st, h_fee_tm, h_tm_st1, user_id )) 	count = 1;
	}
%>

<script language='javascript'>
<%	if(count == 1){%>
		alert('오류발생!');
<%	}else{%>
		alert('처리되었습니다');
		<%if(table_nm.equals("scd_cls")){%>
			parent.i_in.document.URL='/fms2/con_cls/cls_c_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>';
		<%}else{%>
			parent.i_in2.document.URL='/fms2/con_cls/fee_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>';		
		<%}%>
<%	}%>
</script>