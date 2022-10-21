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

<%@ page import="org.apache.commons.httpclient.*"%>
<%@ page import="org.apache.commons.httpclient.methods.*" %>
<%@ page import="org.apache.commons.httpclient.protocol.Protocol" %>

<%@ page import="acar.car_api.*" %>  

<%
	CarApiDatabase car_api = CarApiDatabase.getInstance();
			
	String token = car_api.getRecentToken();  //최근 token 호출 / 
	
	System.out.println("token=" + token);
		
	String f_license_no=request.getParameter("f_license_no"); //면허번호 
	String f_resident_name=request.getParameter("f_resident_name");  //이름
	String f_resident_date=request.getParameter("f_resident_date");  //6 생년월일
	String f_licn_con_code=request.getParameter("f_licn_con_code");  //면허종별 
	String f_from_date=request.getParameter("f_from_date");  //계약기간 : 8
	String f_to_date=request.getParameter("f_to_date"); //계약기간 : 8
		
	System.out.println("f_license_no= " + f_license_no + " : f_resident_name= " + f_resident_name);
		
	String val_string = car_api.getOneValiDatorV2(token,f_license_no, f_resident_name , f_resident_date, f_licn_con_code, f_from_date, f_to_date );  //면허정보 validate
	
	System.out.println("val_string >>> " + val_string);	
	
	//val_string return code가 담아서 올때 	
	if (val_string.equals("00")) {
		val_string = "정상";		
	} else if (val_string.equals("01")) {
		val_string = "면허번호 없음.";		
	} else if (val_string.equals("02")) {
		val_string = "재발급된 면허";		
	} else if (val_string.equals("03")) {
		val_string = "분실된 면허";		
	} else if (val_string.equals("04")) {
		val_string = "사망 취소된 면허";		
	} else if (val_string.equals("11")) {
		val_string = "취소된 면허";		
	} else if (val_string.equals("12")) {
		val_string = "정지된 면허";		
	} else if (val_string.equals("13")) {
		val_string = "기간 중 취소 면허";		
	} else if (val_string.equals("14")) {
		val_string = "기간 중 정지 면허";		
	} else if (val_string.equals("21")) {
		val_string = "정보불일치(이름)";		
	} else if (val_string.equals("22")) {
		val_string = "정보불일치(생년월일)";		
	} else if (val_string.equals("23")) {
		val_string = "정보불일치(암호일련번호)";		
	} else if (val_string.equals("24")) {
		val_string = "정보불일치(종별)";		
	} else if (val_string.equals("31")) {
		val_string = "암호화안 된 면허";			
	}
	
	/* 값 돌려주기 */
	response.setContentType("text/html; charset=utf-8");
	response.getWriter().write(val_string);

//jsp로 테스트 용
/*
	HttpClient client1 = new HttpClient();
	BufferedReader br1 = null;
	
	String client_secret = "4cb02ad65c6967c6161cc1d36e8fbe373c4ff49fe265a54ee914a09ae2158bb3";	
	String sno = "";
	String authHeader1 = OAuth2ClientUtil.generateBearerTokenHeaderString(token);
	String jsonBody = "{\"f_license_no\" : \""+f_license_no+"\","+
								"\"f_resident_name\" : \""+f_resident_name+"\","+
								"\"f_resident_date\" : \""+f_resident_date+"\","+
								"\"f_seq_no\" : \""+sno+"\","+						
								"\"f_licn_con_code\" : \""+f_licn_con_code+"\","+
								"\"f_from_date\" : \""+f_from_date+"\","+
								"\"f_to_date\" : \""+f_to_date+"\"}";
	System.out.println("jsonBody >>> " + jsonBody);		
	//System.out.println("client_secret encoding >>> " + Base64.encode(client_secret.getBytes()));
	ARIACipher256 ac = new ARIACipher256(Base64.encode(client_secret.getBytes()));
//	System.out.println("ac >>> " + ac);
	byte[] encBody = ac.encrypt(jsonBody.getBytes("EUC-KR"));
//	byte[] encBody = ac.encrypt(jsonBody.getBytes("UTF-8"));
	String encStr = Base64.encode(encBody);
	System.out.println("encStr >>> " + encStr);
		
	PostMethod post = new PostMethod("https://dlv.koroad.or.kr:443/api/onevalidatorv2.do");
	post.setRequestHeader("Authorization", authHeader1);
	String reqStr = "{\"header\" : {\"f_send_cnt\" : \"1\",\"f_request_date\" : \"20210122\",\"f_pin_info\" : \""+Base64.encode("12345678:1234".getBytes())+"\"},\"body\" : \""+encStr+"\"}";
	System.out.println("reqStr >>> " + reqStr);
	StringRequestEntity postingString = new StringRequestEntity(reqStr, "application/json", "UTF-8");
	//StringRequestEntity postingString = new StringRequestEntity(reqStr, "application/json", "EUC-KR");
	post.setRequestEntity(postingString);
	
	String temp_string = "";
	try {

		int returnCode = client1.executeMethod(post);
	//	System.out.println("returnCode >>> " + returnCode);
	//	System.out.println("HttpStatus.SC_OK >>> " + HttpStatus.SC_OK);
		if (returnCode == HttpStatus.SC_OK) {
			//br1 = new BufferedReader(new InputStreamReader(post.getResponseBodyAsStream()));
			br1 = new BufferedReader(new InputStreamReader(post.getResponseBodyAsStream() ,"UTF-8" ));
			String readLine;
			StringBuffer st = new StringBuffer();
			while (((readLine = br1.readLine()) != null)) {
				st.append(readLine);
			}
			
		//	System.out.println(st.toString());
			
			JSONParser parser = new JSONParser();
			
			JSONObject jsonObj = (JSONObject) parser.parse(st.toString());
			
			temp_string = jsonObj.toJSONString();
			System.out.println("jsonObj.toJSONString() >>> " + jsonObj.toJSONString());
		//	System.out.println("0".equals((String)((JSONObject)jsonObj.get("header")).get("f_rtn_cd")));
		//	System.out.println("encstr >>> " + jsonObj.get("body"));
			
			if (!"0".equals((String)((JSONObject)jsonObj.get("header")).get("f_rtn_cd"))) {
				System.out.println("####if####");
				System.out.println("header >>> " + jsonObj.toJSONString());
				temp_string = (String)((JSONObject)jsonObj.get("header")).get("f_rtn_msg");  //오류 메세지 
			} else {
				byte[] encBody1 = Base64.decode((String)jsonObj.get("body"));
				byte[] decBody = ac.decrypt(encBody1);
				
				JSONObject bodys = (JSONObject) parser.parse(new String(decBody, "UTF-8"));	
				//JSONObject bodys = (JSONObject) parser.parse(new String(decBody, "EUC-KR"));
		
				JSONObject headers = (JSONObject)jsonObj.get("header");
				
				System.out.println("####else####");
				System.out.println("header >>> " + headers.toJSONString());			
				System.out.println("body >>> " + bodys.toJSONString());					
							
				temp_string = (String)bodys.get("f_rtn_code");  //return code  - appendix a
											
			}
		}
	} catch (Exception e) {
		System.out.println("####error####"+e);
		e.printStackTrace();
	} finally {
	  post.releaseConnection();
	  if (br1 != null) try { br1.close(); } catch (Exception fe) {}
	} 
	
	//temp_string에 return code가 담아서 올때 	
	if (temp_string.equals("00")) {
		temp_string = "정상";		
	} else if (temp_string.equals("01")) {
		temp_string = "면허번호 없음.";		
	} else if (temp_string.equals("02")) {
		temp_string = "재발급된 면허";		
	} else if (temp_string.equals("03")) {
		temp_string = "분실된 면허";		
	} else if (temp_string.equals("04")) {
		temp_string = "사망 취소된 면허";		
	} else if (temp_string.equals("11")) {
		temp_string = "취소된 면허";		
	} else if (temp_string.equals("12")) {
		temp_string = "정지된 면허";		
	} else if (temp_string.equals("13")) {
		temp_string = "기간 중 취소 면허";		
	} else if (temp_string.equals("14")) {
		temp_string = "기간 중 정지 면허";		
	} else if (temp_string.equals("21")) {
		temp_string = "정보불일치(이름)";		
	} else if (temp_string.equals("22")) {
		temp_string = "정보불일치(생년월일)";		
	} else if (temp_string.equals("23")) {
		temp_string = "정보불일치(암호일련번호)";		
	} else if (temp_string.equals("24")) {
		temp_string = "정보불일치(종별)";		
	} else if (temp_string.equals("31")) {
		temp_string = "암호화안 된 면허";				
	}
*/
//	System.out.println("temp_string >>> " + temp_string);
			/* 값 돌려주기 */
//	response.setContentType("text/html; charset=utf-8");
//	response.getWriter().write(temp_string);
 
%>