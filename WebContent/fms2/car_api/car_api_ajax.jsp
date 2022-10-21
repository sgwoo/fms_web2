<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>

<%@ page import="kr.co.grutech.anyauth2.client.*" %>
<%@ page import="kr.or.koroad.dlv.crypt.aria.cipher.*" %>
<%@ page import="kr.or.koroad.dlv.util.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.util.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.net.URI" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="org.json.simple.parser.JSONParser" %>


<%@ page import="java.net.URISyntaxException" %>
<%@ page import="java.net.SocketTimeoutException" %>
<%@ page import="java.net.UnknownHostException" %>
<%@ page import="java.security.InvalidKeyException" %>

<%@ page import="org.apache.http.client.ClientProtocolException" %>
<%@ page import="org.apache.http.client.ResponseHandler" %>
<%@ page import="org.apache.http.client.methods.CloseableHttpResponse" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.client.methods.HttpPost" %>  
<%@ page import="org.apache.http.client.utils.URIBuilder" %>
<%@ page import="org.apache.http.client.config.RequestConfig" %>

<%@ page import="org.apache.http.impl.client.BasicResponseHandler" %>
<%@ page import="org.apache.http.impl.client.CloseableHttpClient" %>
<%@ page import="org.apache.http.impl.client.HttpClientBuilder" %>
<%@ page import="org.apache.http.impl.client.HttpClients" %>

<%-- 
<%@ page import="org.apache.http.util.EntityUtils" %> 
<%@ page import="org.apache.commons.httpclient.contrib.ssl.EasySSLProtocolSocketFactory" %>
--%>

<%@ page import="org.apache.commons.httpclient.*"%>
<%@ page import="org.apache.commons.httpclient.methods.*" %>
<%@ page import="org.apache.commons.httpclient.protocol.Protocol" %>

<%@ page import="acar.car_api.*" %>  

<%
	CarApiDatabase car_api = CarApiDatabase.getInstance();
	
	String access_token = request.getParameter("access_token")==null? "":request.getParameter("access_token");
			
	String token = "";
	
	//token을 저장 - 3시간 유효 
	if (access_token.equals("") ) {
		car_api.getTokenVoid();  //token 호출 /	
	} else {
		   car_api.insertToken(access_token);	
		   System.out.println(" insert token = "  + access_token );
	}

%>