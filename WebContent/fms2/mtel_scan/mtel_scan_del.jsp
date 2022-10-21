<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.car_register.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String cha_seq 		= request.getParameter("cha_seq")==null?"":request.getParameter("cha_seq");
	String scanfile 	= request.getParameter("scanfile_nm")==null?"":request.getParameter("scanfile_nm");//기존스캔
	String file_type 	= request.getParameter("scanfile_type")==null?"":request.getParameter("scanfile_type");//기존스캔
	
	String save_dt 		= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String c_yy 		= request.getParameter("yy")==null?"":request.getParameter("yy");
	String c_mm 		= request.getParameter("mm")==null?"":request.getParameter("mm");
	
	int count = ac_db.deleteMtel_scan(save_dt,seq,c_yy,c_mm);
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<script language="JavaScript">
<!--
	function go_parent(){
		var fm = document.form1;
		fm.action = "./mtel_scan_frame.jsp";
		fm.target = '_parent';
		//if(confirm('등록페이지를 새로고침 하시겠습니까?')){	
			fm.submit();
		//}
	}

//-->
</script>
<form name='form1' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
</form>
<body>
<script language="JavaScript">
<!--
<%if(count >= 1){%>
	alert("삭제되었습니다.");
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>
