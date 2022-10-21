package acar.car_api;

import acar.database.*;
import acar.util.*;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;
import kr.co.grutech.anyauth2.client.*;
import kr.or.koroad.dlv.crypt.aria.cipher.*;
import kr.or.koroad.dlv.util.Base64;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.security.InvalidKeyException;
import java.io.UnsupportedEncodingException;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.client.config.RequestConfig;

import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import org.apache.commons.httpclient.*;
//import org.apache.commons.httpclient.contrib.ssl.EasySSLProtocolSocketFactory;
import org.apache.commons.httpclient.methods.*;
import org.apache.commons.httpclient.protocol.Protocol;

public class CarApiDatabase {

	private static final String ORG_NAME = "아마존카";
	private static final String ORG_UUID = "@아마존카";

	private Connection conn = null;
	public static CarApiDatabase db;

	public static CarApiDatabase getInstance() {
		if (CarApiDatabase.db == null)
			CarApiDatabase.db = new CarApiDatabase();
		return CarApiDatabase.db;
	}

	private DBConnectionManager connMgr = null;

	private void getConnection() {
		try {
			if (connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if (conn == null)
				conn = connMgr.getConnection("acar");
		} catch (Exception e) {
			System.out.println("i can't get a connection........");
		}
	}

	private void closeConnection() {
		if (conn != null) {
			connMgr.freeConnection("acar", conn);
		}
	}
		
	//운영
	static String client_id = "83948498-ec7a-47c9-9b2d-cc43bd901371";
	static String client_secret = "4cb02ad65c6967c6161cc1d36e8fbe373c4ff49fe265a54ee914a09ae2158bb3";	
	static String token_url = "https://dlv.koroad.or.kr:443/oauth2/token2";
	static String validator_url = "https://dlv.koroad.or.kr:443/api/onevalidatorv2.do";
	
		
	public static String getTokenTest() throws ClientProtocolException, IOException, URISyntaxException {
		
		String authHeader = OAuth2ClientUtil.generateBasicAuthHeaderString(client_id, client_secret);
   		/*	
		int timeout = 3;
		RequestConfig config = RequestConfig.custom().
		  setConnectTimeout(timeout * 1000).
		  setConnectionRequestTimeout(timeout * 1000).
		  setSocketTimeout(timeout * 1000).build();
		CloseableHttpClient client = HttpClientBuilder.create()
		  .setDefaultRequestConfig(config).build();
		*/
		
		//http client 생성
		CloseableHttpClient httpClient = HttpClients.createDefault();
		
		//http://203.243.39.19:80/oauth2/token2
		URIBuilder builder = new URIBuilder();
		builder.setScheme("https")
			.setHost("dlv.koroad.or.kr")
	        .setPort(443)
	        .setPath("/oauth2/token2")
			.setParameter("grantType", "password");
		URI uri = builder.build();
					
		
		String resString = "";
		try { 
			//get 메서드와 URL 설정
			HttpGet httpGet = new HttpGet(uri);
			httpGet.addHeader("Authorization", authHeader);
			
			//get 요청
			CloseableHttpResponse httpResponse = httpClient.execute(httpGet);
			
			System.out.println("::GET Response Status::");        
			//response의 status 코드 출력
			System.out.println(httpResponse.getStatusLine().getStatusCode());
	 
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					httpResponse.getEntity().getContent()
	        ));
	 
	        String inputLine;
	        StringBuffer res = new StringBuffer();
	 
	        while ((inputLine = reader.readLine()) != null) {
	        	res.append(inputLine);
	        }
	        reader.close();
	        //Print result
	        resString = res.toString();
			System.out.println(res.toString());
			httpClient.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resString;
		
	}
	
	// return url에 get으로 
	public static void getTokenVoid() throws ClientProtocolException, IOException {
			
			String authHeader = OAuth2ClientUtil.generateBasicAuthHeaderString(client_id, client_secret);
			
			System.out.println("getTokenVoid() java authHeader >>> " + authHeader);
						
			HttpClient client = new HttpClient();		
			
			GetMethod method = new GetMethod(token_url);
			method.setQueryString(
				new NameValuePair[] {
					new NameValuePair("grantType", "password")
				}
			);
			
			Header header = new Header();
			header.setName("Authorization");
			header.setValue(authHeader);
			method.setRequestHeader(header);			
		
			try { 
				
				// Protocol.registerProtocol("https", new Protocol("https",   new EasySSLProtocolSocketFactory(), 443));
				
			//	int hardTimeout = 5; // seconds
			//	TimerTask task = new TimerTask() {
			
			//	public void run() {
			//	        if (method != null) {
			//	        	method.abort();
			//	        }
			//	    }
			//	};
				
			//	new Timer(true).schedule(task, hardTimeout * 1000);
				
				int returnCode = client.executeMethod(method);
										
			//	System.out.println("token returnCode >>> " + returnCode);
			//	System.out.println("Token HttpStatus.SC_OK >>> " + HttpStatus.SC_OK);
			//	String rtnMsg = "";
				if (returnCode == HttpStatus.SC_OK) {
			//		rtnMsg = method.getResponseBodyAsString();		
			//		return_msg = rtnMsg;
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				method.releaseConnection();
				
			}
				
			
		}
		
	// return url에 get으로 
	public static String getToken() throws ClientProtocolException, IOException {
		
		String authHeader = OAuth2ClientUtil.generateBasicAuthHeaderString(client_id, client_secret);
		
		System.out.println("java authHeader >>> " + authHeader);
					
		HttpClient client = new HttpClient();		
							
	//	client.setTimeout(100);
	
		GetMethod method = new GetMethod(token_url);
		method.setQueryString(
			new NameValuePair[] {
				new NameValuePair("grantType", "password")
			}
		);
		
		Header header = new Header();
		header.setName("Authorization");
		header.setValue(authHeader);
		method.setRequestHeader(header);
		
		String return_msg = "";
		try { 
			
			// Protocol.registerProtocol("https", new Protocol("https",   new EasySSLProtocolSocketFactory(), 443));
			
		//	int hardTimeout = 5; // seconds
		//	TimerTask task = new TimerTask() {
		
		//	public void run() {
		//	        if (method != null) {
		//	        	method.abort();
		//	        }
		//	    }
		//	};
			
		//	new Timer(true).schedule(task, hardTimeout * 1000);
			
			int returnCode = client.executeMethod(method);
									
			System.out.println("token returnCode >>> " + returnCode);
			System.out.println("Token HttpStatus.SC_OK >>> " + HttpStatus.SC_OK);
			String rtnMsg = "";
			if (returnCode == HttpStatus.SC_OK) {
				rtnMsg = method.getResponseBodyAsString();
	//			System.out.println("rtnMsg >>> " + rtnMsg);
				return_msg = rtnMsg;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			method.releaseConnection();
			
		}
	
		return return_msg;
		
	}
	
	// return url에 get으로 
	public void getTokenVoid104() throws ClientProtocolException, IOException {
			
							
			HttpClient client = new HttpClient();		
								
		//	client.setTimeout(100);
		    String url = "http://211.174.180.104/fms2/car_api/car_api_ajax.jsp";
			GetMethod method = new GetMethod(url);				
		
			try { 
								
				int returnCode = client.executeMethod(method);
			//							
				System.out.println("104 get token returnCode >>> " + returnCode);
			//	System.out.println("Token HttpStatus.SC_OK >>> " + HttpStatus.SC_OK);
				String rtnMsg = "";
				if (returnCode == HttpStatus.SC_OK) {
				//	rtnMsg = method.getResponseBodyAsString();
				//	System.out.println(" 104 rtnMsg >>> " + rtnMsg);
				//	return_msg = rtnMsg;
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				method.releaseConnection();				
			}
			
		}
		
	// return url에 get으로 
	public static String getToken104() throws ClientProtocolException, IOException {
		
						
		HttpClient client = new HttpClient();		
							
	//	client.setTimeout(100);
	    String url = "http://211.174.180.104/fms2/car_api/car_api_ajax.jsp";
		GetMethod method = new GetMethod(url);
				
		String return_msg = "";
		try { 
			
			
			int returnCode = client.executeMethod(method);
									
		//	System.out.println("token returnCode >>> " + returnCode);
		//	System.out.println("Token HttpStatus.SC_OK >>> " + HttpStatus.SC_OK);
			String rtnMsg = "";
			if (returnCode == HttpStatus.SC_OK) {
				rtnMsg = method.getResponseBodyAsString();
				System.out.println(" 104 rtnMsg >>> " + rtnMsg);
				return_msg = rtnMsg;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			method.releaseConnection();
			
		}
	
		return return_msg;
		
	}
	
	public static String getOneValiDatorV2(String accesToken, String f_license_no, String f_resident_name, String f_resident_date, String f_licn_con_code, String f_from_date, String f_to_date ) throws UnknownHostException, SocketTimeoutException, InvalidKeyException, UnsupportedEncodingException {

		String authHeader = OAuth2ClientUtil.generateBearerTokenHeaderString(accesToken);
	//	String valkey = "";
		String seq_no = "";
		String request_dt= AddUtil.getDate(4); //yyyymmdd
						
		String jsonBody = "{\"f_license_no\" : \""+f_license_no+"\","+
									"\"f_resident_name\" : \""+f_resident_name+"\","+
									"\"f_resident_date\" : \""+f_resident_date+"\","+
								//	"\"f_seq_no\" : \"ND9UPI\","+
									"\"f_seq_no\" : \""+seq_no+"\","+
								//	"\"f_valid_key\" : \""+valkey+"\","+
									"\"f_licn_con_code\" : \""+f_licn_con_code+"\","+
									"\"f_from_date\" : \""+f_from_date+"\","+
									"\"f_to_date\" : \""+f_to_date+"\"}";
	//	System.out.println("accesToken="+accesToken);
	//	System.out.println("authHeader="+authHeader);
	//	System.out.println("jsonBody="+jsonBody);
		
		ARIACipher256 ac = new ARIACipher256(Base64.encode(client_secret.getBytes()));
		byte[] encBody = ac.encrypt(jsonBody.getBytes("EUC-KR"));
	//	byte[] encBody = ac.encrypt(jsonBody.getBytes("UTF-8"));
		String encStr = Base64.encode(encBody);
	//	System.out.println("encStr="+encStr);

		HttpClient client = new HttpClient();

		BufferedReader br = null;
		PostMethod post = new PostMethod(validator_url);
		post.setRequestHeader("Authorization", authHeader);
		String reqStr = "{\"header\" : {\"f_send_cnt\" : \"1\",\"f_request_date\" : \""+request_dt+"\",\"f_pin_info\" : \""+Base64.encode("1234567890:1234565".getBytes())+"\"},\"body\" : \""+encStr+"\"}";
	//	System.out.println("reqStr >>> " + reqStr);
		StringRequestEntity postingString = new StringRequestEntity(reqStr, "application/json", "UTF-8");
		post.setRequestEntity(postingString);
		
		String temp_string = "";
		try {

			int returnCode = client.executeMethod(post);
	//		System.out.println("returnCode >>> " + returnCode);
	//		System.out.println("HttpStatus.SC_OK >>> " + HttpStatus.SC_OK);
			if (returnCode == HttpStatus.SC_OK) {
				br = new BufferedReader(new InputStreamReader(post.getResponseBodyAsStream()));
			//	br = new BufferedReader(new InputStreamReader(post.getResponseBodyAsStream() ,"UTF-8" ));
				String readLine;
				StringBuffer st = new StringBuffer();
				while (((readLine = br.readLine()) != null)) {
					st.append(readLine);
				}
				 
				String st_s	= st.toString();	
			//   String st_s	= new String(st.toString().getBytes("utf-8"), "euc-kr");
						
				JSONParser parser = new JSONParser();
			//	JSONObject jsonObj = (JSONObject) parser.parse(st.toString());
				JSONObject jsonObj = (JSONObject) parser.parse(st_s);
				
			//	temp_string = jsonObj.toJSONString();
			//	System.out.println("jsonObj.toJSONString() >>> " + jsonObj.toJSONString());
			//	System.out.println("0".equals((String)((JSONObject)jsonObj.get("header")).get("f_rtn_cd")));
			//	System.out.println("encstr >>> " + jsonObj.get("body"));
				
				if (!"0".equals((String)((JSONObject)jsonObj.get("header")).get("f_rtn_cd"))) { //실패인 경우 body 없음. rtn_cd로 처리  f_rtn_msg
			//	if (!"0".equals((String)((JSONObject) parser.parse((String)jsonObj.get("header"))).get("f_rtn_cd"))) {
					System.out.println("####if####");
					System.out.println("header >>> " + jsonObj.toJSONString());	
					temp_string = (String)((JSONObject)jsonObj.get("header")).get("f_rtn_msg");  //오류 메세지 
				} else { //성공인 경우는 바디만  rtn_code로 처리 
					byte[] encBody1 = Base64.decode((String)jsonObj.get("body"));
					byte[] decBody = ac.decrypt(encBody1);
					JSONObject bodys = (JSONObject) parser.parse(new String(decBody, "UTF-8"));
					JSONObject headers = (JSONObject)jsonObj.get("header");
					System.out.println("####else####");
			//		System.out.println("header >>> " + headers.toJSONString());
					System.out.println("body >>> " + bodys.toJSONString());
					temp_string = (String)bodys.get("f_rtn_code");  //return code  - appendix a																		
				}
			}
		} catch (Exception e) {
			System.out.println("####error####"+e);
			e.printStackTrace();
		} finally {
		  post.releaseConnection();
		  if (br != null) try { br.close(); } catch (Exception fe) {}
		}
		
		return temp_string;
		
	}

	
	 public boolean  insertToken(String access_token) throws DatabaseException, DataSourceEmptyException{
		    getConnection();
	        PreparedStatement pstmt = null;       
	       
	        String query = "";     
	    	boolean flag = true;	
	      
	        query = " INSERT INTO car_token(access_token, reg_dt)"+
					" values(?, sysdate)\n";
		    
	        try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, access_token);			
			    pstmt.executeUpdate();
				pstmt.close();

				conn.commit();
			    
			} catch (SQLException e) {
				System.out.println("[CarApiDatabase:insertToken]\n"+e);
		  		e.printStackTrace();
		  		flag = false;
				conn.rollback();
		  	} catch (Exception e) {
			  	System.out.println("[CarApiDatabase:insertToken]\n"+e);
		  		e.printStackTrace();
		  		flag = false;
				conn.rollback();
			} finally {
				try{
					conn.setAutoCommit(true);
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
	 }
	 
	 //3시간 확인할 것 
	 public String  getRecentToken() throws DatabaseException, DataSourceEmptyException{
		    getConnection();
	        PreparedStatement pstmt = null;    
	        ResultSet rs = null;
	       
	        String query = "";     
	    	boolean flag = true;
	    	String access_token = "";
	      
	        query = " SELECT access_token FROM (SELECT * FROM car_token  ORDER BY reg_dt DESC) WHERE rownum=1 ";
						    
	        try 
			{
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
				if(rs.next()){
					access_token = rs.getString(1);
				}
				rs.close();
				pstmt.close();
			    
		  	} catch (Exception e) {
				System.out.println("[CarApiDatabase:getRecentToken]"+e);
				e.printStackTrace();
			} finally {
				try{	
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return access_token;
			}			
		}
}
