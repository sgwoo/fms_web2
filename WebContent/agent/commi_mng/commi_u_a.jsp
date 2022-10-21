<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.commi_mng.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.commi_mng.CommiDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소

	String m_id	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String emp_id	= request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String agnt_st	= request.getParameter("agnt_st")==null?"":request.getParameter("agnt_st");
	String cust_st	= request.getParameter("h_cust_st")==null?"":request.getParameter("h_cust_st");
	String mode	= request.getParameter("mode")==null?"":request.getParameter("mode");	
	
	CommiBean commi = cm_db.getCommi(m_id, l_cd, emp_id, agnt_st);
	
	commi.setCommi(Util.parseDigit(request.getParameter("commi")));
	commi.setInc_amt(Util.parseDigit(request.getParameter("inc_amt")));
	commi.setRes_amt(Util.parseDigit(request.getParameter("res_amt")));
	commi.setTot_amt(Util.parseDigit(request.getParameter("tot_amt")));
	commi.setDif_amt(Util.parseDigit(request.getParameter("dif_amt")));
	commi.setSup_dt(request.getParameter("sup_dt")==null?"":request.getParameter("sup_dt"));
%>
<script language='javascript'>
<%	if(!cm_db.updateCommi(commi)){%>		
		alert('오류발생');
<%	}else{%>	
		alert('처리되었습니다');
		parent.inner.location='/acar/commi_mng/commi_u_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&emp_id=<%=emp_id%>&cust_st=<%=cust_st%>';
<%	}%>
</script>
</body>
</html>
