<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	TaxRateBean bean = new TaxRateBean();
	bean.setTax_nm(request.getParameter("tax_nm")==null?"":request.getParameter("tax_nm"));
	bean.setDpm(request.getParameter("dpm")==null?"":request.getParameter("dpm"));
	bean.setRate_st1(request.getParameter("rate_st1")==null?"":request.getParameter("rate_st1"));
	bean.setRate_st2(request.getParameter("rate_st2")==null?"":request.getParameter("rate_st2"));	
	bean.setReg_id(user_id);
	bean.setTax_st_dt(request.getParameter("tax_st_dt")==null?"":request.getParameter("tax_st_dt"));
	bean.setTax_rate(request.getParameter("tax_rate")==null?"":request.getParameter("tax_rate"));
	if(cmd.equals("i")){		//���
		if(!t_db.insertTaxRate(bean))	count += 1;
	}else if(cmd.equals("u")){	//����
		if(!t_db.updateTaxRate(bean))	count += 1;
	}else{}
%>
<script language='javascript'>
<%	if(count != 0){%>
		alert('�����߻�!');
		location='about:blank';
<%	}else{%>
		alert('ó���Ǿ����ϴ�');
		parent.parent.location='/acar/con_tax/tax_rate_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>';
<%	}%>
</script>
</body>
</html>
