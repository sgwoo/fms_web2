<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ page import="kr.co.grutech.anyauth2.client.*" %>
<%@ page import="kr.or.koroad.dlv.crypt.aria.cipher.*" %>
<%@ page import="kr.or.koroad.dlv.util.Base64" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URI" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="org.json.JSONArray" %>

<%@ page import="java.net.URISyntaxException" %>
<%@ page import="java.net.SocketTimeoutException" %>
<%@ page import="java.net.UnknownHostException" %>
<%@ page import="java.security.InvalidKeyException" %>

<%@ page import="org.apache.http.client.ClientProtocolException" %>
<%@ page import="org.apache.http.client.ResponseHandler" %>
<%@ page import="org.apache.http.client.methods.CloseableHttpResponse" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.client.utils.URIBuilder" %>

<%@ page import="org.apache.http.impl.client.BasicResponseHandler" %>
<%@ page import="org.apache.http.impl.client.CloseableHttpClient" %>
<%@ page import="org.apache.http.impl.client.HttpClientBuilder" %>
<%@ page import="org.apache.http.impl.client.HttpClients" %>

<%-- <%@ page import="org.apache.http.util.EntityUtils" %> --%>

<%@ page import="org.apache.commons.httpclient.*"%>
<%@ page import="org.apache.commons.httpclient.methods.*" %>
<%@ page import="org.apache.http.client.methods.HttpPost" %>

<%@ page import="acar.car_api.*" %>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS CAR API</title>
<script type="text/javascript" src="http://code.jquery.com/jquery.js"></script>

<script type="text/javascript">
$(document).ready( function() {
	
	$("#authorize").click(function() {
		
		var dataTemp;
		
		// input 입력여부 확인
		var vForm = document.form1;
					
		if(vForm.f_license_no.value == "")	{	alert("운전면허정보를 입력하십시오."); vForm.f_license_no.focus();	return;		}
		if(vForm.f_resident_name.value == "")	{	alert("이름을 입력하십시오."); vForm.f_resident_name.focus();	return;		}
		if(vForm.f_resident_date.value == "")	{	alert("생년월일을 입력하십시오."); vForm.f_resident_date.focus();	return;		}
		if(vForm.f_from_date.value == "")	{	alert("대여기간(시작일)를 입력하십시오."); vForm.f_from_date.focus();	return;		}
		if(vForm.f_to_date.value == "")	{	alert("대여기간(종료일)를 입력하십시오."); vForm.f_to_date.focus();	return;		}
		if(vForm.f_licn_con_code.value == "")	{	alert("면허종별을 입력하십시오."); vForm.f_licn_con_code.focus();	return;		}
				
		//token 생성후 db insert 
		$.get("/fms2/car_api/call_car_api.jsp");
						
		var param = $("form[name=form1]").serialize();

		 $.ajax({  
			   method: "post",
			   url: "/fms2/car_api/car_api_result.jsp",
			   data: param,			
			   success:function(result){			 
				alert(result);
			   },
			   error:function(result){
			    alert("error");
			   }
		  });
		 
  });

	
})
</script>

</head>

<body leftmargin="15">
<form name="form1" id="form1" method="post" >
	운전면허정보(12자리)<input type="text" name="f_license_no" id="f_license_no" ><br/>
	이름<input type="text" name="f_resident_name" id="f_resident_name" ><br/>
	생년월일(YYMMDD)<input type="text" name="f_resident_date" id="f_resident_date" maxlength=6 ><br/>	
	대여기간(YYYYMMDD)<input type="text" name="f_from_date" id="f_from_date" maxlength=8>~<input type="text" name="f_to_date" id="f_to_date" maxlength=8><br/>
	면허종별(아래코드)<input type="text" name="f_licn_con_code" id="f_licn_con_code" maxlength=2><br/>
	1종대형(11), 1종보통(12), 1종소형(13), 1종대형견인차(14), 10종구난차(15), 1종소형견인차(16)<br/>
	2종보통(32), 2종소형(33), 2종원동기(38)
</form>
<P>
<button id="authorize">면허검증</button>

</body>
</html>

