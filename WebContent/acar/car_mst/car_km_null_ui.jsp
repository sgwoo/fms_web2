<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cd_bean" class="acar.car_mst.CarKmBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");
	String view_dt 		= request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String car_dt			= request.getParameter("car_k_dt")	==null?"":request.getParameter("car_k_dt");
	String upgrade_date = request.getParameter("upgrade_dt")==null?"":request.getParameter("upgrade_dt");
	
	int count = 0;
	//String car_u_seq = view_dt;
	String car_k_dt = car_dt.replace("-", "");
	String upgrade_dt = upgrade_date.replace("-", "");
	


	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	cd_bean.setCar_comp_id	(car_comp_id);
	cd_bean.setCar_cd	(code);
	cd_bean.setCar_k_dt 		(car_k_dt);
	cd_bean.setCar_k_seq	(request.getParameter("car_k_seq")	==null?"":request.getParameter("car_k_seq"));
	cd_bean.setCar_k			(request.getParameter("car_k")		==null?"":request.getParameter("car_k"));
	cd_bean.setEngine			(request.getParameter("engine")		==null?"":request.getParameter("engine"));
	cd_bean.setCar_k_etc			(request.getParameter("car_k_etc")		==null?"":request.getParameter("car_k_etc"));
	cd_bean.setUse_yn			(request.getParameter("use_yn")		==null?"":request.getParameter("use_yn"));
		
	CarKmBean [] co_r = a_cmb.getCarKmList(car_comp_id, code, view_dt);
	
	if(cmd.equals("i")){
		count = a_cmb.insertCarKm(cd_bean);
	}else if(cmd.equals("u")){
		count = a_cmb.updateCarKm(cd_bean);
	}else if(cmd.equals("d")){
		count = a_cmb.deleteCarKm(cd_bean);
	}else if(cmd.equals("ug")){//업그레이드
		for(int i=0; i<co_r.length; i++){
		    CarKmBean cc_bean = co_r[i];
			cc_bean.setCar_comp_id	(car_comp_id);
			//미사용처리
			cc_bean.setUse_yn	("N");
			count = a_cmb.updateCarKm(cc_bean);
			//업그레이드
			cc_bean.setUse_yn	("Y");
			//cc_bean.setCar_u_seq	(AddUtil.addZero(upgrade_seq));
			cc_bean.setCar_k_dt	(upgrade_dt);
			count = a_cmb.insertCarKm(cc_bean);
		}
	}else if(cmd.equals("no")){//미사용처리
		for(int i=0; i<co_r.length; i++){
		    CarKmBean cc_bean = co_r[i];
			cc_bean.setCar_comp_id	(car_comp_id);
			//미사용처리
			cc_bean.setUse_yn("N");
			count = a_cmb.updateCarKm(cc_bean);
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

<script>
<%	if(cmd.equals("u")){
		if(count==1){%>

			alert("정상적으로 수정되었습니다.");
			parent.Search();

<%		}
	}else if(cmd.equals("i") || cmd.equals("ug")){
		if(count==1){%>

			alert("정상적으로 등록되었습니다.");
			parent.Search();
			parent.re_init(2);
			parent.GetViewDt();

<%		}
	}else if(cmd.equals("no")){
		if(count==1){%>

			alert("정상적으로 처리되었습니다.");
			parent.Search();
			parent.re_init(2);
			parent.GetViewDt();

<%		}
	}else{
		if(count==1){%>

			alert("정상적으로 삭제되었습니다.");
			parent.Search();
			parent.re_init(1);			

<%		}
	}	%>
</script>
</body>
</html>