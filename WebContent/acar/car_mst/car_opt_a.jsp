<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="co_bean" class="acar.car_mst.CarOptBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd 		= request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_id 		= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq 		= request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String view_dt 		= request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String car_b_dt 	= request.getParameter("car_b_dt")==null?"":request.getParameter("car_b_dt");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	int count = 0;
		
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	co_bean.setCar_comp_id	(car_comp_id);
	co_bean.setCar_cd				(car_cd);
	co_bean.setCar_id				(car_id);
	co_bean.setCar_u_seq		(car_seq);
	co_bean.setCar_s_seq		(request.getParameter("h_car_s_seq")==null?"":request.getParameter("h_car_s_seq"));
	co_bean.setUse_yn				(request.getParameter("h_use_yn")==null?"N":request.getParameter("h_use_yn"));
	co_bean.setCar_s				(request.getParameter("h_car_s")==null?"":request.getParameter("h_car_s"));
	co_bean.setCar_s_p			(request.getParameter("h_car_s_p")==null?0:AddUtil.parseDigit(request.getParameter("h_car_s_p")));
	co_bean.setCar_s_dt			(request.getParameter("h_car_s_dt")==null?"":request.getParameter("h_car_s_dt"));
	co_bean.setOpt_b				(request.getParameter("h_opt_b")==null?"":request.getParameter("h_opt_b"));
	co_bean.setJg_opt_st		(request.getParameter("h_jg_opt_st")==null?"":request.getParameter("h_jg_opt_st"));
	co_bean.setJg_tuix_st		(request.getParameter("h_jg_tuix_st")==null?"":request.getParameter("h_jg_tuix_st"));
	co_bean.setLkas_yn			(request.getParameter("h_lkas_yn")==null?"":request.getParameter("h_lkas_yn"));
	co_bean.setLdws_yn			(request.getParameter("h_ldws_yn")==null?"":request.getParameter("h_ldws_yn"));
	co_bean.setAeb_yn			(request.getParameter("h_aeb_yn")==null?"":request.getParameter("h_aeb_yn"));
	co_bean.setFcw_yn			(request.getParameter("h_fcw_yn")==null?"":request.getParameter("h_fcw_yn"));
	co_bean.setCar_rank		(request.getParameter("h_car_rank")==null?"":request.getParameter("h_car_rank"));
	co_bean.setJg_opt_yn		(request.getParameter("h_jg_opt_yn")==null?"":request.getParameter("h_jg_opt_yn"));
	co_bean.setGarnish_yn		(request.getParameter("h_garnish_yn")==null?"":request.getParameter("h_garnish_yn"));
	co_bean.setHook_yn		(request.getParameter("h_hook_yn")==null?"":request.getParameter("h_hook_yn"));
			
	if (mode.equals("i")) {
		count = a_cmb.insertCarOpt(co_bean);
	} else if (mode.equals("u")) {
		count = a_cmb.updateCarOpt(co_bean);
	} else if (mode.equals("d")) {
		count = a_cmb.deleteCarOpt(co_bean);		
	} else if (mode.equals("ob")) {
		//순서정렬 저장
		String car_s_seq[]	= request.getParameterValues("car_s_seq");
		String car_rank[]  	= request.getParameterValues("car_rank");
		
		int v_size = car_s_seq.length;
		
		for (int i = 0; i < v_size; i++) {
			co_bean = a_cmb.getCarOptCase(car_comp_id, car_cd, car_id, car_seq, car_s_seq[i]);
			if (!co_bean.getCar_comp_id().equals("")) {
				//수정
				co_bean.setCar_s_seq	(car_s_seq[i]);
				co_bean.setCar_rank	(car_rank[i]);
				
				count = a_cmb.updateCarOptOderby(co_bean);
			}		
		}
		
	} else if (mode.equals("all")) {
		//전체수정		
		String car_s_seq[]	= request.getParameterValues("car_s_seq");
		String car_s[]		= request.getParameterValues("car_s");	
		String car_s_p[]  	= request.getParameterValues("car_s_p");
		String car_s_dt[]  	= request.getParameterValues("car_s_dt");
		String use_yn[]  	= request.getParameterValues("use_yn");	
		String opt_b[]		= request.getParameterValues("opt_b");	
		String jg_opt_st[]	= request.getParameterValues("jg_opt_st");	
		String jg_tuix_st[]	= request.getParameterValues("jg_tuix_st");
		String lkas_yn[]  	= request.getParameterValues("lkas_yn");
		String ldws_yn[]  	= request.getParameterValues("ldws_yn");	
		String aeb_yn[]  	= request.getParameterValues("aeb_yn");	
		String fcw_yn[]  	= request.getParameterValues("fcw_yn");
		String car_rank[]  	= request.getParameterValues("car_rank");
		String jg_opt_yn[]  	= request.getParameterValues("jg_opt_yn");
		String garnish_yn[]  	= request.getParameterValues("garnish_yn");
		String hook_yn[]  	= request.getParameterValues("hook_yn");
		
		int v_size 		= car_s_seq.length;
				
		for(int i=0; i < v_size; i++){
			co_bean = a_cmb.getCarOptCase(car_comp_id, car_cd, car_id, car_seq, car_s_seq[i]);
			if(!co_bean.getCar_comp_id().equals("")){
				//수정
				co_bean.setCar_s_seq	(car_s_seq[i]);
				co_bean.setUse_yn			(use_yn[i]);
				co_bean.setCar_s			(car_s[i]);
				co_bean.setCar_s_p		(AddUtil.parseDigit(car_s_p[i]));
				co_bean.setCar_s_dt		(car_s_dt[i]);
				co_bean.setOpt_b			(opt_b[i]);
				co_bean.setJg_opt_st	(jg_opt_st[i]);
				co_bean.setJg_tuix_st	(jg_tuix_st[i]);
				co_bean.setLkas_yn		(lkas_yn[i]);
				co_bean.setLdws_yn		(ldws_yn[i]);
				co_bean.setAeb_yn		(aeb_yn[i]);
				co_bean.setFcw_yn		(fcw_yn[i]);
				co_bean.setCar_rank	(car_rank[i]);
				co_bean.setJg_opt_yn	(jg_opt_yn[i]);
				co_bean.setGarnish_yn		(garnish_yn[i]);
				co_bean.setHook_yn		(hook_yn[i]);
				
				count = a_cmb.updateCarOpt(co_bean);
				
			}else{				
				//등록
				co_bean.setCar_comp_id	(car_comp_id);
				co_bean.setCar_cd			(car_cd);
				co_bean.setCar_id			(car_id);
				co_bean.setCar_u_seq	(car_seq);				
				co_bean.setUse_yn			(use_yn[i]);
				co_bean.setCar_s			(car_s[i]);
				co_bean.setCar_s_p		(AddUtil.parseDigit(car_s_p[i]));
				co_bean.setCar_s_dt		(car_s_dt[i]);
				co_bean.setOpt_b			(opt_b[i]);
				co_bean.setJg_opt_st	(jg_opt_st[i]);
				co_bean.setJg_tuix_st	(jg_tuix_st[i]);
				co_bean.setLkas_yn		(lkas_yn[i]);
				co_bean.setLdws_yn		(ldws_yn[i]);
				co_bean.setAeb_yn		(aeb_yn[i]);
				co_bean.setFcw_yn		(fcw_yn[i]);
				co_bean.setCar_rank	(car_rank[i]);
				co_bean.setJg_opt_yn	(jg_opt_yn[i]);
				co_bean.setGarnish_yn		(garnish_yn[i]);
				co_bean.setHook_yn		(hook_yn[i]);
								
				if(co_bean.getCar_s_p() >0){
					count = a_cmb.insertCarOpt(co_bean);
				}
				
			}			
		}
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
<form action="car_opt.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">    
  <input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
  <input type="hidden" name="car_cd" value="<%=car_cd%>">
  <input type="hidden" name="car_id" value="<%=car_id%>">
  <input type="hidden" name="car_seq" value="<%=car_seq%>">
  <input type="hidden" name="car_nm" value="<%=car_nm%>">    
  <input type="hidden" name="view_dt" value="<%=view_dt%>">
  <input type="hidden" name="car_b_dt" value="<%=car_b_dt%>">    
  <input type="hidden" name="cmd" value="<%=cmd%>">
</form>
<script>
<%	if(count==1){%>
		alert("정상적으로 처리되었습니다.");
		document.form1.target='popwin2';
		document.form1.submit();		
<%	}else{%>
		alert("처리오류 발생!!");
<%	}	%>
</script>
</body>
</html>