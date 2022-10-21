<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.database.* ,acar.util.*, java.net.URLDecoder"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%

	String workId = request.getParameter("workId")==null?"":request.getParameter("workId");
	String loginId = request.getParameter("loginId")==null?"":request.getParameter("loginId");
	String car_nm = request.getParameter("carName")==null?"":URLDecoder.decode(request.getParameter("carName"),"UTF-8");
	String car_no = request.getParameter("carNumber")==null?"":URLDecoder.decode(request.getParameter("carNumber"),"UTF-8");
	String car_mng_id = request.getParameter("carManagedId")==null?"":request.getParameter("carManagedId");
	
    int result = pk_db.insertSHPhotoWorkHistory(workId, car_nm, car_no, car_mng_id);
	if(result > 0){
	    pk_db.updateSHPhotoWorkCount(workId, loginId);
	}
%>
<!DOCTYPE HTML>
<html>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta name="viewport" content="width=device-width, user-scalable=no">
<head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"
	integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
	crossorigin="anonymous"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css" />
<link rel="stylesheet" href="/sh_photo/sh_photo.css" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>	
</head>
<script>
$(document).ready(function(){

});
</script>
<body>

</body>
</html>