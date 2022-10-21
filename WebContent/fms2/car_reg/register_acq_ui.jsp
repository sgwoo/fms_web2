<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*" %>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");

	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String acq_std = request.getParameter("acq_std")==null?"":AddUtil.parseDigit3(request.getParameter("acq_std"));
	int acq_acq = request.getParameter("acq_acq")==null?0:AddUtil.parseDigit(request.getParameter("acq_acq"));
	String acq_f_dt = request.getParameter("acq_f_dt")==null?"":request.getParameter("acq_f_dt");
	String acq_ex_dt = request.getParameter("acq_ex_dt")==null?"":request.getParameter("acq_ex_dt");
	String acq_re = request.getParameter("acq_re")==null?"":request.getParameter("acq_re");
	String acq_is_p = request.getParameter("acq_is_p")==null?"":request.getParameter("acq_is_p");
	String acq_is_o = request.getParameter("acq_is_o")==null?"":request.getParameter("acq_is_o");
	int count = 0;
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	if(cmd.equals("u")){
		cr_bean.setCar_mng_id(car_mng_id);
		cr_bean.setAcq_std(acq_std); 					//취득세_과세표준
		cr_bean.setAcq_acq(acq_acq); 					//취득세_취득세
		cr_bean.setAcq_f_dt(acq_f_dt); 					//취득세_납기일자
		cr_bean.setAcq_ex_dt(acq_ex_dt); 					//취득세_지출일자
		cr_bean.setAcq_re(acq_re); 						//취득세_문의처
		cr_bean.setAcq_is_p(acq_is_p); 					//취득세_고지서발급자
		cr_bean.setAcq_is_o(acq_is_o); 					//취득세_발급처
		count = crd.updateCarAcq(cr_bean);
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language="JavaScript">
<!--
	function NullAction(){
	<%if(cmd.equals("u")){
		if(count==1){%>
		alert("정상적으로 수정되었습니다.");

		var theForm2 = parent.c_body.CarRegForm;
		var theForm1 = parent.c_foot.CarAcqForm;
		theForm2.acq_std.value = theForm1.acq_std.value;
		theForm2.acq_acq.value = theForm1.acq_acq.value;
		theForm2.acq_f_dt.value = theForm1.acq_f_dt.value;
		theForm2.acq_ex_dt.value = theForm1.acq_ex_dt.value;
		theForm2.acq_re.value = theForm1.acq_re.value;
		theForm2.acq_is_p.value = theForm1.acq_is_p.value;
		theForm2.acq_is_o.value = theForm1.acq_is_o.value;
		theForm2.car_mng_id.value = theForm1.car_mng_id.value;
		theForm2.rent_mng_id.value = theForm1.rent_mng_id.value;
		theForm2.rent_l_cd.value = theForm1.rent_l_cd.value;
		window.location="about:blank";
	<%	}
	}%>
	}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form  name="form2" method="post">
<input type="hidden" name="cmd" value="ud">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
</form>
</body>
</html>