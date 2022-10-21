<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	int flag = 0;
	
	ClsAllotBean cls = new ClsAllotBean();
	
	cls.setRent_mng_id(m_id);
	cls.setRent_l_cd(l_cd);
	cls.setCar_mng_id(car_id);
	cls.setCls_rtn_dt(request.getParameter("cls_rtn_dt"));
	cls.setNalt_rest(request.getParameter("nalt_rest")==null?0:AddUtil.parseDigit(request.getParameter("nalt_rest")));
	cls.setCls_rtn_int(request.getParameter("cls_rtn_int")==null?"":request.getParameter("cls_rtn_int"));
	cls.setMax_pay_dt(request.getParameter("max_pay_dt")==null?"":request.getParameter("max_pay_dt"));
	cls.setCls_rtn_fee(request.getParameter("cls_rtn_fee")==null?0:AddUtil.parseDigit(request.getParameter("cls_rtn_fee")));
	cls.setCls_rtn_int_amt(request.getParameter("cls_rtn_int_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_rtn_int_amt")));
	cls.setDly_alt(request.getParameter("dly_alt")==null?0:AddUtil.parseDigit(request.getParameter("dly_alt")));
	cls.setBe_alt(request.getParameter("be_alt")==null?0:AddUtil.parseDigit(request.getParameter("be_alt")));
	cls.setCls_rtn_amt(request.getParameter("cls_rtn_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_rtn_amt")));
	cls.setBk_code(request.getParameter("bk_code")==null?"":request.getParameter("bk_code"));
	cls.setAcnt_no(request.getParameter("acnt_no")==null?"":request.getParameter("acnt_no"));
	cls.setAcnt_user(request.getParameter("acnt_user")==null?"":request.getParameter("acnt_user"));
	cls.setCls_rtn_cau(request.getParameter("cls_rtn_cau")==null?"":request.getParameter("cls_rtn_cau"));
	cls.setCls_rtn_fee_int(request.getParameter("cls_rtn_fee_int")==null?"":request.getParameter("cls_rtn_fee_int"));
	cls.setNalt_rest_1(request.getParameter("nalt_rest_1")==null?0:AddUtil.parseDigit(request.getParameter("nalt_rest_1")));
	cls.setNalt_rest_2(request.getParameter("nalt_rest_2")==null?0:AddUtil.parseDigit(request.getParameter("nalt_rest_2")));
	cls.setCls_etc_fee	(request.getParameter("cls_etc_fee")	==null?0:AddUtil.parseDigit(request.getParameter("cls_etc_fee")));
	
	if(!as_db.updateClsAllot(cls))	flag += 1;
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
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
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag != 0){ 	//해지테이블에 삽입 실패%>
		alert('수정 오류발생!');
<%	}else{ 			//해지테이블에 삽입 성공..%>
			alert('처리되었습니다');
			fm.action='../con_debt/debt_scd_frame_s.jsp';		
			fm.target='d_content';		
			parent.window.close();		
			fm.submit();			
<%	}%>
</script>
</body>
</html>