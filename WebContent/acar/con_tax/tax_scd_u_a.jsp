<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.con_tax.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String f_list 	= request.getParameter("f_list")==null?"":request.getParameter("f_list");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String cls_st 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	boolean flag = true;

	TaxScdBean bean = t_db.getTaxScdCase(m_id, l_cd, car_id);
    bean.setSur_rate(request.getParameter("sur_rate"));
    bean.setSur_amt(request.getParameter("sur_amt")==null?0:Util.parseDigit(request.getParameter("sur_amt")));
    bean.setTax_rate(request.getParameter("tax_rate"));
    bean.setSpe_tax_amt(request.getParameter("spe_tax_amt")==null?0:Util.parseDigit(request.getParameter("spe_tax_amt")));
    bean.setEdu_tax_amt(request.getParameter("edu_tax_amt")==null?0:Util.parseDigit(request.getParameter("edu_tax_amt")));
    bean.setEst_dt(request.getParameter("est_dt")==null?"":request.getParameter("est_dt"));
    bean.setPay_dt(request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt"));
    bean.setPay_amt(request.getParameter("tax_amt")==null?0:Util.parseDigit(request.getParameter("tax_amt")));
	bean.setUpdate_id(user_id);
    bean.setCls_man_st(request.getParameter("cls_man_st")==null?"":request.getParameter("cls_man_st"));
    bean.setRtn_dt(request.getParameter("rtn_dt")==null?"":request.getParameter("rtn_dt"));
    bean.setRtn_amt(request.getParameter("rtn_amt")==null?0:Util.parseDigit(request.getParameter("rtn_amt")));
	//추가
    bean.setTax_st(request.getParameter("tax_st")==null?"":request.getParameter("tax_st"));
    bean.setTax_apply(request.getParameter("tax_apply")==null?"":request.getParameter("tax_apply"));
    bean.setTax_come_dt(request.getParameter("tax_come_dt")==null?"":request.getParameter("tax_come_dt"));
    bean.setRtn_cau(request.getParameter("rtn_cau")==null?"":request.getParameter("rtn_cau"));
    bean.setCar_fs_amt(request.getParameter("car_fs_amt")==null?0:Util.parseDigit(request.getParameter("car_fs_amt")));
	
	flag = t_db.updateTax(bean);
%>
<form action="tax_scd_u.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
<input type='hidden' name='gubun6' 	value='<%=gubun6%>'>
<input type='hidden' name='gubun7' 	value='<%=gubun7%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=car_id%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='cls_st' value='<%=cls_st%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>  
</form>

<script language='javascript'>
<!--
<%	if(!flag){%>
		alert('에러입니다.');
		location='about:blank';
<%	}else{%>		
		alert('수정되었습니다');
		document.form1.target="d_content";
		document.form1.submit();
<%	}%>
-->
</script>
</body>
</html>
