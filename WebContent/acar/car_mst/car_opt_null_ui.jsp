<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="co_bean" class="acar.car_mst.CarOptBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");
	String h_car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String view_dt 		= request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	int count = 0;
	String car_u_seq 	= h_car_id.substring(0,2);
	String car_id 		= h_car_id.substring(2);	

	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	co_bean.setCar_comp_id	(car_comp_id);
	co_bean.setCar_cd	(code);
	co_bean.setCar_id	(car_id);	
	co_bean.setUse_yn	("Y");	
	co_bean.setCar_u_seq	(car_u_seq);
	co_bean.setCar_s_seq	(request.getParameter("car_s_seq")==null?"":request.getParameter("car_s_seq"));
	co_bean.setCar_s	(request.getParameter("car_s")==null?"":request.getParameter("car_s"));
	co_bean.setCar_s_p	(request.getParameter("car_s_p")==null?0:AddUtil.parseDigit(request.getParameter("car_s_p")));
	co_bean.setCar_s_dt	(request.getParameter("car_s_dt")==null?"":request.getParameter("car_s_dt"));
	co_bean.setOpt_b	(request.getParameter("opt_b")==null?"":request.getParameter("opt_b"));
	co_bean.setUse_yn	(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
	co_bean.setJg_opt_st	(request.getParameter("jg_opt_st")==null?"":request.getParameter("jg_opt_st"));
	co_bean.setJg_tuix_st	(request.getParameter("jg_tuix_st")==null?"":request.getParameter("jg_tuix_st"));
	co_bean.setLkas_yn	(request.getParameter("lkas_yn")==null?"":request.getParameter("lkas_yn"));
	co_bean.setLdws_yn	(request.getParameter("ldws_yn")==null?"":request.getParameter("ldws_yn"));
	co_bean.setAeb_yn	(request.getParameter("aeb_yn")==null?"":request.getParameter("aeb_yn"));
	co_bean.setFcw_yn	(request.getParameter("fcw_yn")==null?"":request.getParameter("fcw_yn"));
	co_bean.setGarnish_yn	(request.getParameter("garnish_yn")==null?"":request.getParameter("garnish_yn"));
	co_bean.setHook_yn	(request.getParameter("hook_yn")==null?"":request.getParameter("hook_yn"));
	
	if(co_bean.getUse_yn().equals("")) co_bean.setUse_yn("Y");
	
	if(cmd.equals("i")){
		count = a_cmb.insertCarOpt(co_bean);
	}else if(cmd.equals("u")){
		co_bean.setCar_u_seq(request.getParameter("car_u_seq")==null?"":request.getParameter("car_u_seq"));
		count = a_cmb.updateCarOpt(co_bean);
	}else if(cmd.equals("d")){
		co_bean.setCar_u_seq(request.getParameter("car_u_seq")==null?"":request.getParameter("car_u_seq"));
		count = a_cmb.deleteCarOpt(co_bean);
	}
	

%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>

<script>
<%	if(cmd.equals("u")){
		if(count==1){%>

			alert("정상적으로 수정되었습니다.");
			parent.Search();

<%		}
	}else if(cmd.equals("i")){
		if(count==1){%>

			alert("정상적으로 등록되었습니다.");
			parent.Search();

<%		}
	}else{
		if(count==1){%>

			alert("정상적으로 삭제되었습니다.");
			parent.Search();

<%		}
	}	%>
</script>
</body>
</html>