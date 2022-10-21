package acar.util;

import java.io.*;
import java.sql.*;
import java.util.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.UnknownHostException;

import org.json.JSONObject;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
 
// 성냥   : Map으로 사용하고자 할 경우 import
//import java.util.HashMap;
//import java.util.Map;
//import org.codehaus.jackson.map.ObjectMapper;
//import org.codehaus.jackson.type.TypeReference;
 
public class ShortenUrlGoogle {
	
	/* public ShortenUrlGoogle() {
		    
	    }
 */
    // 성냥   : Google 단축URL 사용을 위한 URL
    public static final String SHORTENER_URL = "https://www.googleapis.com/urlshortener/v1/url?key=";
     
   // public static final String API_KEY = "AIzaSyDTLDbQYFNKRuHhdqjLnz3WwUCvqpEyWMM"; // 새로운 키 등록 필요  
    
     public static final String API_KEY = "AIzaSyB_6VzWUm7EmfZ_XqQCbJnyPheH6R0xrbM"; //  amazoncarads 
     

     
    //#######################################################################################
    // 성냥   : 단축시킬 URL 주소를 String 문자열로 입력받고, Google API에 전송 (JSON 첨부)
    //      : 결과 JSON String 데이터를 수신하여, JSONObject 혹은 Map(현재주석처리)으로 변환
    //      : JSONObject 에서 단축URL을 String 타입으로 return
    //      : 인증키당 일 100,000 변환 가능
    //#######################################################################################   
    public static String getShortenUrl2(String originalUrl) {
         
        //System.out.println("[DEBUG] INPUT_URL : " + originalUrl );
         
        // 성냥   : Exception에 대비해 결과 URL은 처음에 입력 URL로 셋팅
        String resultUrl = originalUrl;
         
        // 성냥   : Google Shorten URL API는 JSON으로 longUrl 파라미터를 사용하므로, JSON String 데이터 생성
        String originalUrlJsonStr = "{\"longUrl\":\"" + originalUrl + "\"}";
        //System.out.println("[DEBUG] INPUT_JSON : " + originalUrlJsonStr);
         
        // 성냥   : Google에 변환 요청을 보내기위해 java.net.URL, java.net.HttpURLConnection 사용
        URL                 url         = null;
        HttpURLConnection   connection  = null;
        OutputStreamWriter  osw         = null;
        BufferedReader      br          = null; 
        StringBuffer        sb          = null; // Google의 단축URL서비스 결과 JSON String Data
        JSONObject          jsonObj     = null; // 결과 JSON String Data로 생성할 JSON Object
         
        // 성냥   : Google 단축 URL 요청을 위한 주소 - https://www.googleapis.com/urlshortener/v1/url
        //      : get방식으로 key(사용자키) 파라미터와, JSON 데이터로 longUrl(단축시킬 원본 URL이 담긴 JSON 데이터) 를 셋팅하여 전송
        try {
            url = new URL(SHORTENER_URL + API_KEY);
            //System.out.println("[DEBUG] DESTINATION_URL : " + url.toString() );
             
        }catch(Exception e){
            System.out.println("[ERROR] URL set Failed");
            e.printStackTrace();
            return resultUrl;
        }
         
        // 성냥   : 지정된 URL로 연결 설정
        try{
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("User-Agent", "toolbar");
            connection.setDoOutput(true);
            connection.setRequestProperty("Content-Type", "application/json");
        }catch(Exception e){
            System.out.println("[ERROR] Connection open Failed");
            e.printStackTrace();
            return resultUrl;
        }
         
        // 성냥   : 결과 JSON String 데이터를 StringBuffer에 저장
        //      : 필요에 따라 JSON Obejct 혹은 Map으로 셋팅 (현재 Map은 주석처리)
        try{
            // 성냥   : Google 단축URL 서비스 요청
            osw = new OutputStreamWriter(connection.getOutputStream());
            osw.write(originalUrlJsonStr);
            osw.flush();
 
            // 성냥   : BufferedReader에 Google에서 받은 데이터를 넣어줌
            br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
             
            // 성냥   : BufferedReader 내 데이터 StringBuffer sb 에 저장
            sb = new StringBuffer();
            String buf = "";
            while ((buf = br.readLine()) != null) {
                sb.append(buf);
            }
           //System.out.println("[DEBUG] RESULT_JSON_DATA : " + sb.toString());
             
            // 성냥   : Google에서 받은 JSON String을 JSONObject로 변환
            jsonObj = new JSONObject(sb.toString());
             
            // 성냥   : 결과 JSON Object의 데이터 확인 (주석처리)
            //String[] str = JSONObject.getNames(jsonObj);
            //for( String idx : str ){
            //  System.out.println("[DEBUG] PARSING_JSON_DATA : [" + idx + "] - [" + jsonObj.getString(idx) + "]");
            //}
             
            // 성냥   : 수신받은 JSON String 데이터를 필요시 Map에 저장
            //      : return 타입을 Map 으로 받고자 할 때 사용 (현재는 결과 url만 String으로 리턴할 것이므로 주석처리)
            //ObjectMapper mapper = new ObjectMapper();
            //Map<String,String> map = mapper.readValue(sb.toString(), new TypeReference<HashMap<String, String>>() {});
            //resultUrl = (String) map.get("id"); // Map 으로 저장했을 때
             
            resultUrl = jsonObj.getString("id");
             
        }catch (Exception e) {
            System.out.println("[ERROR] Result JSON Data(From Google) set JSONObject Failed");
            e.printStackTrace();
            return resultUrl;
        }finally{
            if (osw != null)    try{ osw.close();   } catch(Exception e) { e.printStackTrace(); }
            if (br  != null)    try{ br.close();    } catch(Exception e) { e.printStackTrace(); }
        }
         
        //System.out.println("[DEBUG] RESULT_URL : " + resultUrl);
        return resultUrl;
    }
    
    /*
     ****************************************
		Bitly 단축 url 서비스
		goo.gl 지원중단(2019년 03월 30일 까지 운영)
		인증키당 6000개 변환 가능		
		단축시킬 URL 주소를 String 문자열로 입력받고, Bitly API에 전송 (JSON 첨부)
		JSONObject 에서 단축URL을 String 타입으로 return
	 ****************************************
    */
    public static String getShortenUrl(String originalUrl) throws UnknownHostException, SocketTimeoutException {
    	
    	/* 
	 	Bitly에서 변환해야 할 URL 파라미터에 &가 들어갈경우 %26으로 replace 되어야 한다.
	 	( 변경하지 않으면 &기준 이후 파라미터가 모두 사라진다. )
		필요에 따라서는 originalUrl에 들어가는 특수문자를 위와 같이 변경해야 할수도 있음
		( https://dev.bitly.com/spreadsheets.html ) 확인 가능
    	*/
    	
    	String resultUrl = originalUrl;
        String replaceLongUrl = originalUrl.replace("&", "%26");
        
        String url = "http://api.bitly.com/v3/shorten?callback=?";
        //String url = "http://67.199.248.22/v3/shorten?callback=?";
        //String url = "http://api-ssl.bitly.com/v3/shorten?";
        //String url = "https://api-ssl.bitly.com/v3/shorten?callback=?";
        
        String apiKey = "";
    	String login = "";
    	String token = "";
    	
    	String curTime = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
    	String str_day = curTime.split("-")[2];
    	int parse_num = AddUtil.parseInt(str_day);
    	
    	//api.bitly.com 사용시 간혹 UnknownHostException 발생
    	//URL을 통해 getHostAddress로 조회하여 사용
    	try{
    		InetAddress[] iaArr = InetAddress.getAllByName("api.bitly.com");
        	if (iaArr.length > 0) {
        		url = "http://"+iaArr[0].getHostAddress()+"/v3/shorten?callback=?";
      //  		System.out.println("http://api.bitly.com >>> " + iaArr[0].getHostAddress());
        	}
       // 	System.out.println(url);
	    } catch (UnknownHostException e) {
			//e.printStackTrace();
	    	System.out.println("[ERROR] Bitly UnknownHostException");
			return originalUrl;			
	    }  	
        
        //현재날짜에 따라 11일, 21일, 이후 기준으로 3개의 apikey와 loginkey 변경
        if (parse_num < 10) {
        	apiKey = "R_21f7cc9eec1e4782a39f779fd2dd2881";
        	login = "tax100";
        	token = "428dd7797cfcc431fece84da06bb702bcd77ffc1";        	
        } else if (parse_num < 21) {
        	apiKey = "R_a8d1106fb23c4e56a8342dc570b33782";
        	login = "tax200";
        	token = "81b28f92990ccd317560a74a6360171dad7be8a2";
        } else {
        	apiKey = "R_fb94416e7d944122b607d7642fb0b905";
        	login = "amazoncar";
        	token = "d4fef3974e9581e77691f5a425ca743cf0da3f70";
        }
       
        String param = "format=json"+"&apiKey="+ apiKey +"&login="+ login +"&longUrl=" + replaceLongUrl;
        //String param = "access_token="+ token + "&longUrl=" + replaceLongUrl;
        
        HttpURLConnection con	= null;
        OutputStream os = null;
        InputStream	is = null;
        BufferedReader br = null;        
        //Bitly의 단축URL서비스 결과 JSON String Data
        StringBuffer sb = null;        
        //결과 JSON String Data로 생성할 JSON Object
        JSONObject jsonObj = null;
        
        try {
        	con = (HttpURLConnection) new URL(url).openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("User-Agent", "toolbar");
            con.setDoOutput(true);
            con.setDoInput(true);
            con.setRequestProperty("Accept", "application/json");
        } catch(Exception e) {
        	//e.printStackTrace();
            System.out.println("[ERROR] Connection open Failed");
            return originalUrl;
        }
        
        try {
            // Bitly 단축URL 서비스 요청
        	os	= con.getOutputStream();
            os.write(param.getBytes());
            os.flush();
            
            //BufferedReader 내 데이터 StringBuffer sb 에 저장
            br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
            sb = new StringBuffer();
            String buf = "";
            while ((buf = br.readLine()) != null) {
                sb.append(buf);
            }
             
            //Bitly에서 받은 JSON String을 JSONObject로 변환
            jsonObj = new JSONObject(sb.toString());
            resultUrl = jsonObj.getJSONObject("data").getString("url");
            
            //System.out.println(sb.toString());
            
        } catch (Exception e) {
        	//e.printStackTrace(); //error
        	System.out.println("originalUrl >>> " + originalUrl );
        	System.out.println(sb.toString());        	
            //System.out.println("[ERROR] Result JSON Data(From Bitly) set JSONObject Failed");
            return originalUrl;
            
        } finally {
            if (os != null) try{ os.close();   } catch(Exception e) { e.printStackTrace(); }
            if (br != null) try{ br.close();    } catch(Exception e) { e.printStackTrace(); }
        }
        
     //   System.out.println("resultUrl >>> " + originalUrl + "->" + resultUrl);
        
        return resultUrl;
    }
    
    //Bitly AccessToken 받기 - 테스트중
	public String getBitlyAccessToken(String token) {
		
		String RequestUrl = "https://api-ssl.bitly.com/oauth/access_token";
		
		String grant_type = "authorization_code";
		String client_id = "54869108bce682f779c8bf91e862f924";
		String redirect_uri = token;
		
		String return_value = "";
		
		try {
			List <NameValuePair> postParams = new ArrayList<NameValuePair>();
			
			postParams.add(new BasicNameValuePair("grant_type", grant_type));
		    postParams.add(new BasicNameValuePair("client_id", client_id));    // REST API KEY
		    postParams.add(new BasicNameValuePair("redirect_uri", redirect_uri));    // 리다이렉트 URI
		    postParams.add(new BasicNameValuePair("code", token));    // 로그인 과정중 얻은 code 값
			
			HttpClient client = HttpClientBuilder.create().build();
			HttpPost post = new HttpPost(RequestUrl);
			
			JsonNode returnNode = null;
			
			post.setEntity(new UrlEncodedFormEntity(postParams));
			
			HttpResponse response = client.execute(post);
			int responseCode = response.getStatusLine().getStatusCode();
			
			/*
			System.out.println("\nSending 'POST' request to URL : " + RequestUrl);
		    System.out.println("Post parameters : " + postParams);
		    System.out.println("Response Code : " + responseCode);
		    */
			
			//JSON 형태 반환값 처리
			ObjectMapper mapper = new ObjectMapper();	            
            returnNode = mapper.readTree(response.getEntity().getContent());
            //System.out.println("getKakaoAccessToken returnNode : " + returnNode);
            
            return_value = returnNode.get("access_token").getTextValue().toString();
			
		} catch (Exception e) {
			System.out.println("ShortenUrlGoogle:getBitlyAccessToken : " + e);
		}
		
		return return_value;
	}
 
    //테스트용 main
    //inputURL에 변환대상 URL을 String으로 저장후 GoogleShortUrl 클래스의 getShortenUrl() 메서드 호출
    //getShortenUrl(String originalUrl) 은 static 이므로 객체생성없이 바로 사용
    public static void main(String[] args) throws UnknownHostException, SocketTimeoutException {
        String originalUrl = "http://www.google.com";
        System.out.println("[DEBUG] main() RESULT_URL  : " + ShortenUrlGoogle.getShortenUrl(originalUrl));
    }
}