<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.commi_mng.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<body>
<%
	String auth_rw	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String m_id	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String emp_id	= request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String agnt_st	= request.getParameter("agnt_st")==null?"":request.getParameter("agnt_st");
	String cust_st	= request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String mode	= request.getParameter("mode")==null?"":request.getParameter("mode");	
	
	CommiBean commi = new CommiBean();
	
	commi.setRent_mng_id(m_id);
	commi.setRent_l_cd(l_cd);
	commi.setEmp_id(emp_id);
	commi.setAgnt_st("3");
	commi.setRel("");
	commi.setCommi_st("2");
	commi.setCommi(Util.parseDigit(request.getParameter("commi")));
	commi.setInc_amt(Util.parseDigit(request.getParameter("inc_amt")));
	commi.setRes_amt(Util.parseDigit(request.getParameter("res_amt")));
	commi.setTot_amt(Util.parseDigit(request.getParameter("tot_amt")));
	commi.setDif_amt(Util.parseDigit(request.getParameter("dif_amt")));
	commi.setSup_dt(request.getParameter("sup_dt")==null?"":request.getParameter("sup_dt"));
%>
<script language='javascript'>
<%	if(!cm_db.insertCommi(commi)){%>		
		alert('오류발생');
<%	}else{%>	
		alert('처리되었습니다');
		parent.inner.location='/acar/commi_mng/commi_u_in.jsp?auth_rw=<%=auth_rw%>&emp_id=<%=emp_id%>&cust_st=<%=cust_st%>';
<%	}%>
</script>
</body>
</html>
