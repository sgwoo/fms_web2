<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.con_ser.*"%>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String pay_yn = request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	String set_dt = request.getParameter("set_dt")==null?"":request.getParameter("set_dt");
	
	ConSerDatabase cs_db = ConSerDatabase.getInstance();
%>
<script language='javascript'>
<%	if(!cs_db.updateServiceScd(m_id, l_cd, c_id, accid_id, serv_id, set_dt, user_id)){%>
		alert('오류발생!');
<%	}else{%>
		alert('처리되었습니다');
		parent.inner.document.URL='/acar/con_ser/service_u_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>';
<%	}%>
</script>