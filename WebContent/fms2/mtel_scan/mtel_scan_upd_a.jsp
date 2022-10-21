<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.car_register.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%

	/* multipart/form-data 로 FileUpload객체 생성 */ 
	FileUpload file = new FileUpload("C:\\Inetpub\\wwwroot\\data\\carReg\\", request.getInputStream());

	String auth_rw 	= file.getParameter("auth_rw")==null?"":file.getParameter("auth_rw"); //권한
	String user_id 	= file.getParameter("user_id")==null?"":file.getParameter("user_id");
	String br_id 	= file.getParameter("br_id")==null?"":file.getParameter("br_id");
	
	String st 			= file.getParameter("st")==null?"":file.getParameter("st");
	String gubun 		= file.getParameter("gubun")==null?"":file.getParameter("gubun");
	String gubun_nm 	= file.getParameter("gubun_nm")==null?"":file.getParameter("gubun_nm");
	String q_sort_nm 	= file.getParameter("q_sort_nm")==null?"":file.getParameter("q_sort_nm");
	String q_sort 		= file.getParameter("q_sort")==null?"":file.getParameter("q_sort");
	String ref_dt1 		= file.getParameter("ref_dt1")==null?"":file.getParameter("ref_dt1");
	String ref_dt2 		= file.getParameter("ref_dt2")==null?"":file.getParameter("ref_dt2");
	
	String rent_mng_id 	= file.getParameter("rent_mng_id")==null?"":file.getParameter("rent_mng_id");
	String rent_l_cd 	= file.getParameter("rent_l_cd")==null?"":file.getParameter("rent_l_cd");
	String car_mng_id 	= file.getParameter("car_mng_id")==null?"":file.getParameter("car_mng_id");
	String cmd 			= file.getParameter("cmd")==null?"":file.getParameter("cmd");
	
	String cha_cau 		= file.getParameter("cha_cau")==null?"":file.getParameter("cha_cau");
	String filename2 	= file.getFilename()==null?"":file.getFilename();//스캔
	String cha_seq 		= file.getParameter("cha_seq");
	
	//스캔
	String old_scan = file.getParameter("scanfile") == null ? "" : file.getParameter("scanfile");//기존스캔
	String new_scan = filename2;
	if(!new_scan.equals("")){
		if(!old_scan.equals("") && !new_scan.equals("")){
			File drop_file = new File("C:\\Inetpub\\wwwroot\\data\\carReg\\"+old_scan+".pdf");
			drop_file.delete();
		}
	}else{
		filename2 = old_scan;
	}
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	ch_bean.setCar_mng_id	(car_mng_id);
	ch_bean.setCha_seq		(cha_seq);
	ch_bean.setCha_car_no	(file.getParameter("cha_car_no"));
	ch_bean.setCha_dt		(AddUtil.ChangeString(file.getParameter("cha_dt")));
	ch_bean.setCha_cau		(file.getParameter("cha_cau"));
	ch_bean.setCha_cau_sub	(file.getParameter("cha_cau_sub"));
	ch_bean.setReg_id		(user_id);
	ch_bean.setScanfile		(filename2);
	int result = crd.updateCarHis(ch_bean);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){%>
	alert("수정되었습니다.");
	parent.parent.location.href = "./register_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=car_mng_id%>&cmd=<%=cmd%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>"; 	
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>
