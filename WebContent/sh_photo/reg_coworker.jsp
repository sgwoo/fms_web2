<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.database.* ,acar.util.*, acar.user_mng.*, acar.off_anc.*, acar.attend.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<!DOCTYPE HTML>
<%
	
	String name 	= request.getParameter("name")==null?"":request.getParameter("name");
	String passwd 	= request.getParameter("passwd")==null?"":request.getParameter("passwd");
	String empName[] = request.getParameterValues("empName");
	String cellphone[] = request.getParameterValues("cellphone");

	//---------------------------------------------------------------------------------- 로그인 처리
	LoginBean login = LoginBean.getInstance();
	int loginResult = login.getLogin(name, passwd, response, request);
	String user_id 	= login.getSessionValue(request, "USER_ID");	
	login.setDisplayCookie("300", "500", response);
	
	//---------------------------------------------------------------------------------- 로그인 정보 생성 및 작업자 등록
	String loginId = pk_db.getSHPhotoLoginId();
	for(int i=0; i<empName.length; i++){
	    if(!empName[i].equals("") && empName[i] != null){
	    	pk_db.insertSHPhotoLoginInfo(empName[i],cellphone[i],loginId, empName.length);
	    }
	}
	
	//---------------------------------------------------------------------------------- 작업ID 생성
	int workId = pk_db.insertSHPhotoWorkInfo(loginId);
%>
<html>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta name="viewport" content="width=device-width, user-scalable=no">
<head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"
	integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css" />
<link rel="stylesheet" href="/sh_photo/sh_photo.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
</head>
<body>
<script>

$(document).ready(function(){
	$.cookie("sh_photo_loginId",["<%=loginId%>","<%=workId%>"],{path:'/',expires:1});
	var result = parseInt('<%=workId%>');
	if(result > 0){
		location.replace("sh_photo_list.jsp");
	}else{
		alert("로그인에 실패하였습니다. 관리자에게 문의하세요.");
	}
})
</script>
</body>

</html>