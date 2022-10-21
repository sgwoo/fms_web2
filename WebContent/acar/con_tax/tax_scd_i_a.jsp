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
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	boolean flag = true;
	
	TaxScdBean bean = new TaxScdBean();
    	bean.setRent_mng_id(m_id);
    	bean.setRent_l_cd(l_cd);
    	bean.setRent_l_cd(l_cd);
	bean.setCar_mng_id(car_id);
    	bean.setSur_rate(request.getParameter("sur_rate"));
    	bean.setSur_amt(request.getParameter("sur_amt")==null?0:Util.parseDigit(request.getParameter("sur_amt")));
    	bean.setTax_rate(request.getParameter("tax_rate"));
    	bean.setSpe_tax_amt(request.getParameter("spe_tax_amt")==null?0:Util.parseDigit(request.getParameter("spe_tax_amt")));
    	bean.setEdu_tax_amt(request.getParameter("edu_tax_amt")==null?0:Util.parseDigit(request.getParameter("edu_tax_amt")));
    	bean.setEst_dt(request.getParameter("est_dt")==null?"":request.getParameter("est_dt"));
    	bean.setPay_dt(request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt"));
    	bean.setPay_amt(request.getParameter("tax_amt")==null?0:Util.parseDigit(request.getParameter("tax_amt")));
	bean.setReg_id(user_id);
    	bean.setCls_man_st(request.getParameter("cls_man_st")==null?"":request.getParameter("cls_man_st"));
    	bean.setRtn_dt(request.getParameter("rtn_dt")==null?"":request.getParameter("rtn_dt"));
    	bean.setRtn_amt(request.getParameter("rtn_amt")==null?0:Util.parseDigit(request.getParameter("rtn_amt")));
	//추가
    	bean.setTax_st(request.getParameter("tax_st")==null?"":request.getParameter("tax_st"));
    	bean.setTax_apply(request.getParameter("tax_apply")==null?"":request.getParameter("tax_apply"));
    	bean.setTax_come_dt(request.getParameter("tax_come_dt")==null?"":request.getParameter("tax_come_dt"));
    	bean.setRtn_cau(request.getParameter("rtn_cau")==null?"":request.getParameter("rtn_cau"));
    	bean.setCar_fs_amt(request.getParameter("car_fs_amt")==null?0:Util.parseDigit(request.getParameter("car_fs_amt")));
	
	
	
	
		String est_dt = AddUtil.replace(bean.getEst_dt(),"-","").substring(0,6));
		String pay_mon = "";
		if(est_dt.equals("201001")) pay_mon = "201004";
		if(est_dt.equals("201002")) pay_mon = "201004";
		if(est_dt.equals("201003")) pay_mon = "201004";
		if(est_dt.equals("201004")) pay_mon = "201007";
		if(est_dt.equals("201005")) pay_mon = "201007";
		if(est_dt.equals("201006")) pay_mon = "201007";
		if(est_dt.equals("201007")) pay_mon = "201010";
		if(est_dt.equals("201008")) pay_mon = "201010";
		if(est_dt.equals("201009")) pay_mon = "201010";
		if(est_dt.equals("201010")) pay_mon = "201101";
		if(est_dt.equals("201011")) pay_mon = "201101";
		if(est_dt.equals("201012")) pay_mon = "201101";
		
		if(est_dt.equals("201101")) pay_mon = "201104";
		if(est_dt.equals("201102")) pay_mon = "201104";
		if(est_dt.equals("201103")) pay_mon = "201104";
		if(est_dt.equals("201104")) pay_mon = "201107";
		if(est_dt.equals("201105")) pay_mon = "201107";
		if(est_dt.equals("201106")) pay_mon = "201107";
		if(est_dt.equals("201107")) pay_mon = "201110";
		if(est_dt.equals("201108")) pay_mon = "201110";
		if(est_dt.equals("201109")) pay_mon = "201110";
		if(est_dt.equals("201110")) pay_mon = "201201";
		if(est_dt.equals("201111")) pay_mon = "201201";
		if(est_dt.equals("201112")) pay_mon = "201201";
		
		if(est_dt.equals("201201")) pay_mon = "201204";
		if(est_dt.equals("201202")) pay_mon = "201204";
		if(est_dt.equals("201203")) pay_mon = "201204";
		if(est_dt.equals("201204")) pay_mon = "201207";
		if(est_dt.equals("201205")) pay_mon = "201207";
		if(est_dt.equals("201206")) pay_mon = "201207";
		if(est_dt.equals("201207")) pay_mon = "201210";
		if(est_dt.equals("201208")) pay_mon = "201210";
		if(est_dt.equals("201209")) pay_mon = "201210";
		if(est_dt.equals("201210")) pay_mon = "201301";
		if(est_dt.equals("201211")) pay_mon = "201301";
		if(est_dt.equals("201212")) pay_mon = "201301";
		
		if(est_dt.equals("201301")) pay_mon = "201304";
		if(est_dt.equals("201302")) pay_mon = "201304";
		if(est_dt.equals("201303")) pay_mon = "201304";
		if(est_dt.equals("201304")) pay_mon = "201307";
		if(est_dt.equals("201305")) pay_mon = "201307";
		if(est_dt.equals("201306")) pay_mon = "201307";
		if(est_dt.equals("201307")) pay_mon = "201310";
		if(est_dt.equals("201308")) pay_mon = "201310";
		if(est_dt.equals("201309")) pay_mon = "201310";
		if(est_dt.equals("201310")) pay_mon = "201401";
		if(est_dt.equals("201311")) pay_mon = "201401";
		if(est_dt.equals("201312")) pay_mon = "201401";
		
		if(est_dt.equals("201401")) pay_mon = "201404";
		if(est_dt.equals("201402")) pay_mon = "201404";
		if(est_dt.equals("201403")) pay_mon = "201404";
		if(est_dt.equals("201404")) pay_mon = "201407";
		if(est_dt.equals("201405")) pay_mon = "201407";
		if(est_dt.equals("201406")) pay_mon = "201407";
		if(est_dt.equals("201407")) pay_mon = "201410";
		if(est_dt.equals("201408")) pay_mon = "201410";
		if(est_dt.equals("201409")) pay_mon = "201410";
		if(est_dt.equals("201410")) pay_mon = "201501";
		if(est_dt.equals("201411")) pay_mon = "201501";
		if(est_dt.equals("201412")) pay_mon = "201501";		


		if(pay_mon.equals("")){
			bean.setEst_dt2		(bean.getEst_dt());
		}else{
			pay_mon = pay_mon+"25";
			bean.setEst_dt2		(pay_mon);
		}
		
	flag = t_db.insertTax(bean);
	
	String f_list 	= request.getParameter("f_list")==null?"":request.getParameter("f_list");
%>
<form action="tax_scd_frame_s.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
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
</form>

<script language='javascript'>
<!--
<%	if(!flag){%>
		alert('에러입니다.');
		location='about:blank';
<%	}else{%>		
		alert('등록되었습니다');
		if(document.form1.f_list.value == 'pay') 	document.form1.action = 'tax_frame_s.jsp';		
		document.form1.target="d_content";
		document.form1.submit();
<%	}%>
-->
</script>
</body>
</html>
