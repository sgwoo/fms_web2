<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cd_bean" class="acar.car_mst.CarDcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");
	String view_dt 		= request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String upd_d_dt 	= request.getParameter("upd_d_dt")==null?"":request.getParameter("upd_d_dt");
	String upd_d_dt2 	= request.getParameter("upd_d_dt2")==null?"":request.getParameter("upd_d_dt2");
	
	int count = 0;
	String car_u_seq = view_dt;


	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	cd_bean.setCar_comp_id	(car_comp_id);
	cd_bean.setCar_cd	(code);
	cd_bean.setCar_u_seq	(car_u_seq);
	cd_bean.setCar_d_seq	(request.getParameter("car_d_seq")	==null?"":request.getParameter("car_d_seq"));
	cd_bean.setCar_d_dt	(request.getParameter("car_d_dt")	==null?"":request.getParameter("car_d_dt"));
	cd_bean.setCar_d	(request.getParameter("car_d")		==null?"":request.getParameter("car_d"));
	cd_bean.setCar_d_p	(request.getParameter("car_d_p")	==null? 0:AddUtil.parseDigit(request.getParameter("car_d_p")));
	cd_bean.setCar_d_per	(request.getParameter("car_d_per")	==null? 0:AddUtil.parseFloat(request.getParameter("car_d_per")));
	cd_bean.setCar_d_p2	(request.getParameter("car_d_p2")	==null? 0:AddUtil.parseDigit(request.getParameter("car_d_p2")));
	cd_bean.setCar_d_per2	(request.getParameter("car_d_per2")	==null? 0:AddUtil.parseFloat(request.getParameter("car_d_per2")));
	cd_bean.setLs_yn	(request.getParameter("ls_yn")		==null?"N":request.getParameter("ls_yn"));
	cd_bean.setCar_d_per_b	(request.getParameter("car_d_per_b")	==null?"":request.getParameter("car_d_per_b"));
	cd_bean.setCar_d_per_b2	(request.getParameter("car_d_per_b2")	==null?"":request.getParameter("car_d_per_b2"));
	cd_bean.setCar_d_dt2	(request.getParameter("car_d_dt2")	==null?"":request.getParameter("car_d_dt2"));
	cd_bean.setCar_d_etc	(request.getParameter("car_d_etc")	==null?"":request.getParameter("car_d_etc"));	//비고 추가(2018.01.22)
	cd_bean.setEsti_d_etc	(request.getParameter("esti_d_etc")	==null?"":request.getParameter("esti_d_etc"));	//견적서 기타 표기내용 추가(2020.05.07)
	cd_bean.setHp_flag		(request.getParameter("hp_flag")	==null?"":request.getParameter("hp_flag"));
	
	
	if(cd_bean.getLs_yn().equals("N")){
		if(cd_bean.getCar_d_p2() > 0 || cd_bean.getCar_d_per2() > 0) cd_bean.setLs_yn("Y");
	}
	
	if(cmd.equals("i")){
		count = a_cmb.insertCarDc(cd_bean);
	}else if(cmd.equals("u")){
		count = a_cmb.updateCarDc(cd_bean);
	}else if(cmd.equals("d")){
		count = a_cmb.deleteCarDc(cd_bean);
	}else if(cmd.equals("upd")){
		CarDcBean [] cs_r = a_cmb.getCarDcMaxUpdList();
		for(int i=0; i<cs_r.length; i++){		
			cd_bean = cs_r[i];
			cd_bean.setCar_d_seq	(AddUtil.addZero2(AddUtil.parseInt(cd_bean.getCar_d_seq())+1));
			cd_bean.setCar_d_dt	(upd_d_dt);
			cd_bean.setCar_d_dt2	(upd_d_dt2);
			count = a_cmb.insertCarDc(cd_bean);			
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
	}else if(cmd.equals("i")){
		if(count==1){%>

			alert("정상적으로 등록되었습니다.");
			parent.Search();
			parent.re_init(2);

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