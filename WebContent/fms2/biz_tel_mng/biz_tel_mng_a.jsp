<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ page import="acar.biz_tel_mng.*" %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="bean" class="acar.biz_tel_mng.Biztel_Bean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String tel_mng_id	= request.getParameter("tel_mng_id")==null?"":request.getParameter("tel_mng_id");
	String reg_dt	= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String tel_gubun	= request.getParameter("tel_gubun")==null?"":request.getParameter("tel_gubun");
	String tel_time	= request.getParameter("tel_time")==null?"":request.getParameter("tel_time");
	String tel_car	= request.getParameter("tel_car")==null?"":request.getParameter("tel_car");
	String tel_car_gubun	= request.getParameter("tel_car_gubun")==null?"":request.getParameter("tel_car_gubun");
	String tel_car_st	= request.getParameter("tel_car_st")==null?"":request.getParameter("tel_car_st");
	String tel_car_mng	= request.getParameter("tel_car_mng")==null?"":request.getParameter("tel_car_mng");
	String tel_firm_nm	= request.getParameter("tel_firm_nm")==null?"":request.getParameter("tel_firm_nm");
	String tel_firm_mng	= request.getParameter("tel_firm_mng")==null?"":request.getParameter("tel_firm_mng");
	String tel_firm_tel	= request.getParameter("tel_firm_tel")==null?"":request.getParameter("tel_firm_tel");
	String tel_est_yn	= request.getParameter("tel_est_yn")==null?"":request.getParameter("tel_est_yn");
	String tel_yp_gubun	= request.getParameter("tel_yp_gubun")==null?"":request.getParameter("tel_yp_gubun");
	String tel_yp_nm	= request.getParameter("tel_yp_nm")==null?"":request.getParameter("tel_yp_nm");
	String tel_note	= request.getParameter("tel_note")==null?"":request.getParameter("tel_note");
	String tel_esty_yn	= request.getParameter("tel_esty_yn")==null?"":request.getParameter("tel_esty_yn");
	String tel_esty_dt	= request.getParameter("tel_esty_dt")==null?"":request.getParameter("tel_esty_dt");
	String cmd	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	int count = 0;

	u_bean = umd.getUsersBean(user_id);
	
	BiztelDatabase biz_db = BiztelDatabase.getInstance();
	
//System.out.println(cmd);	


	if(cmd.equals("i")){
		bean.setReg_id			(user_id);
		bean.setTel_gubun		(tel_gubun);
		bean.setTel_time		(tel_time);
		bean.setTel_car			(tel_car);
		bean.setTel_car_gubun 	(tel_car_gubun);
		bean.setTel_car_st		(tel_car_st);
		bean.setTel_car_mng		(tel_car_mng);
		bean.setTel_firm_nm		(tel_firm_nm);
		bean.setTel_firm_mng	(tel_firm_mng);
		bean.setTel_firm_tel	(tel_firm_tel);
		bean.setTel_est_yn		(tel_est_yn);
		bean.setTel_yp_gubun	(tel_yp_gubun);
		bean.setTel_yp_nm		(tel_yp_nm);
		bean.setTel_note		(tel_note);

		count = biz_db.insertBiz_tel_mng(bean);
	
	}else if(cmd.equals("u")){

//	System.out.println(tel_esty_dt);	
//	System.out.println(tel_mng_id);		
	
//		bean.setReg_id			(user_id);
		bean.setTel_gubun		(tel_gubun);
		bean.setTel_car			(tel_car);
		bean.setTel_car_gubun 	(tel_car_gubun);
		bean.setTel_car_st		(tel_car_st);
		bean.setTel_car_mng		(tel_car_mng);
		bean.setTel_firm_nm		(tel_firm_nm);
		bean.setTel_firm_mng	(tel_firm_mng);
		bean.setTel_firm_tel	(tel_firm_tel);
		bean.setTel_est_yn		(tel_est_yn);
		bean.setTel_yp_gubun	(tel_yp_gubun);
		bean.setTel_yp_nm		(tel_yp_nm);
		bean.setTel_note		(tel_note);
		bean.setTel_esty_yn		(tel_esty_yn);
		bean.setTel_esty_dt		(tel_esty_dt);
		bean.setTel_mng_id		(tel_mng_id);

		count = biz_db.updateBiz_tel_mng(bean);
	
	}else if(cmd.equals("d")){
		bean.setTel_mng_id		(tel_mng_id);
		count = biz_db.deleteBiz_tel_mng(bean);
	}

%>

<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='POST' enctype=''>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>

</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<%if(cmd.equals("i")){
	if(count==1){%>
	alert("등록 되었습니다.");
	fm.action="biz_tel_mng_frame.jsp";  //새로고침
	parent.window.close();
<%	}else{%>
	alert("에러발생!");
<%	}
}else if(cmd.equals("u")){
	if(count==1){%>
	alert("수정 되었습니다.");
	fm.action="biz_tel_mng_frame.jsp";  //새로고침
	parent.window.close();
<%	}else{%>
	alert("에러발생!");
<%	}
}else if(cmd.equals("d")){
	if(count==1){%>
	alert("삭제 되었습니다.");
	fm.action="/fms2/biz_tel_mng/biz_tel_mng_frame.jsp";  //새로고침
	parent.window.close();
<%	}else{%>
	alert("에러발생!");
<%	}
}else{%>
	alert("에러발생!");
<%}%>



//-->
</script>
</body>
</html>
