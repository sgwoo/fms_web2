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
 
// ����   : Map���� ����ϰ��� �� ��� import
//import java.util.HashMap;
//import java.util.Map;
//import org.codehaus.jackson.map.ObjectMapper;
//import org.codehaus.jackson.type.TypeReference;
 
public class ShortenUrlGoogle {
	
	/* public ShortenUrlGoogle() {
		    
	    }
 */
    // ����   : Google ����URL ����� ���� URL
    public static final String SHORTENER_URL = "https://www.googleapis.com/urlshortener/v1/url?key=";
     
   // public static final String API_KEY = "AIzaSyDTLDbQYFNKRuHhdqjLnz3WwUCvqpEyWMM"; // ���ο� Ű ��� �ʿ�  
    
     public static final String API_KEY = "AIzaSyB_6VzWUm7EmfZ_XqQCbJnyPheH6R0xrbM"; //  amazoncarads 
     

     
    //#######################################################################################
    // ����   : �����ų URL �ּҸ� String ���ڿ��� �Է¹ް�, Google API�� ���� (JSON ÷��)
    //      : ��� JSON String �����͸� �����Ͽ�, JSONObject Ȥ�� Map(�����ּ�ó��)���� ��ȯ
    //      : JSONObject ���� ����URL�� String Ÿ������ return
    //      : ����Ű�� �� 100,000 ��ȯ ����
    //#######################################################################################   
    public static String getShortenUrl2(String originalUrl) {
         
        //System.out.println("[DEBUG] INPUT_URL : " + originalUrl );
         
        // ����   : Exception�� ����� ��� URL�� ó���� �Է� URL�� ����
        String resultUrl = originalUrl;
         
        // ����   : Google Shorten URL API�� JSON���� longUrl �Ķ���͸� ����ϹǷ�, JSON String ������ ����
        String originalUrlJsonStr = "{\"longUrl\":\"" + originalUrl + "\"}";
        //System.out.println("[DEBUG] INPUT_JSON : " + originalUrlJsonStr);
         
        // ����   : Google�� ��ȯ ��û�� ���������� java.net.URL, java.net.HttpURLConnection ���
        URL                 url         = null;
        HttpURLConnection   connection  = null;
        OutputStreamWriter  osw         = null;
        BufferedReader      br          = null; 
        StringBuffer        sb          = null; // Google�� ����URL���� ��� JSON String Data
        JSONObject          jsonObj     = null; // ��� JSON String Data�� ������ JSON Object
         
        // ����   : Google ���� URL ��û�� ���� �ּ� - https://www.googleapis.com/urlshortener/v1/url
        //      : get������� key(�����Ű) �Ķ���Ϳ�, JSON �����ͷ� longUrl(�����ų ���� URL�� ��� JSON ������) �� �����Ͽ� ����
        try {
            url = new URL(SHORTENER_URL + API_KEY);
            //System.out.println("[DEBUG] DESTINATION_URL : " + url.toString() );
             
        }catch(Exception e){
            System.out.println("[ERROR] URL set Failed");
            e.printStackTrace();
            return resultUrl;
        }
         
        // ����   : ������ URL�� ���� ����
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
         
        // ����   : ��� JSON String �����͸� StringBuffer�� ����
        //      : �ʿ信 ���� JSON Obejct Ȥ�� Map���� ���� (���� Map�� �ּ�ó��)
        try{
            // ����   : Google ����URL ���� ��û
            osw = new OutputStreamWriter(connection.getOutputStream());
            osw.write(originalUrlJsonStr);
            osw.flush();
 
            // ����   : BufferedReader�� Google���� ���� �����͸� �־���
            br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
             
            // ����   : BufferedReader �� ������ StringBuffer sb �� ����
            sb = new StringBuffer();
            String buf = "";
            while ((buf = br.readLine()) != null) {
                sb.append(buf);
            }
           //System.out.println("[DEBUG] RESULT_JSON_DATA : " + sb.toString());
             
            // ����   : Google���� ���� JSON String�� JSONObject�� ��ȯ
            jsonObj = new JSONObject(sb.toString());
             
            // ����   : ��� JSON Object�� ������ Ȯ�� (�ּ�ó��)
            //String[] str = JSONObject.getNames(jsonObj);
            //for( String idx : str ){
            //  System.out.println("[DEBUG] PARSING_JSON_DATA : [" + idx + "] - [" + jsonObj.getString(idx) + "]");
            //}
             
            // ����   : ���Ź��� JSON String �����͸� �ʿ�� Map�� ����
            //      : return Ÿ���� Map ���� �ް��� �� �� ��� (����� ��� url�� String���� ������ ���̹Ƿ� �ּ�ó��)
            //ObjectMapper mapper = new ObjectMapper();
            //Map<String,String> map = mapper.readValue(sb.toString(), new TypeReference<HashMap<String, String>>() {});
            //resultUrl = (String) map.get("id"); // Map ���� �������� ��
             
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
		Bitly ���� url ����
		goo.gl �����ߴ�(2019�� 03�� 30�� ���� �)
		����Ű�� 6000�� ��ȯ ����		
		�����ų URL �ּҸ� String ���ڿ��� �Է¹ް�, Bitly API�� ���� (JSON ÷��)
		JSONObject ���� ����URL�� String Ÿ������ return
	 ****************************************
    */
    public static String getShortenUrl(String originalUrl) throws UnknownHostException, SocketTimeoutException {
    	
    	/* 
	 	Bitly���� ��ȯ�ؾ� �� URL �Ķ���Ϳ� &�� ����� %26���� replace �Ǿ�� �Ѵ�.
	 	( �������� ������ &���� ���� �Ķ���Ͱ� ��� �������. )
		�ʿ信 ���󼭴� originalUrl�� ���� Ư�����ڸ� ���� ���� �����ؾ� �Ҽ��� ����
		( https://dev.bitly.com/spreadsheets.html ) Ȯ�� ����
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
    	
    	//api.bitly.com ���� ��Ȥ UnknownHostException �߻�
    	//URL�� ���� getHostAddress�� ��ȸ�Ͽ� ���
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
        
        //���糯¥�� ���� 11��, 21��, ���� �������� 3���� apikey�� loginkey ����
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
        //Bitly�� ����URL���� ��� JSON String Data
        StringBuffer sb = null;        
        //��� JSON String Data�� ������ JSON Object
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
            // Bitly ����URL ���� ��û
        	os	= con.getOutputStream();
            os.write(param.getBytes());
            os.flush();
            
            //BufferedReader �� ������ StringBuffer sb �� ����
            br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
            sb = new StringBuffer();
            String buf = "";
            while ((buf = br.readLine()) != null) {
                sb.append(buf);
            }
             
            //Bitly���� ���� JSON String�� JSONObject�� ��ȯ
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
    
    //Bitly AccessToken �ޱ� - �׽�Ʈ��
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
		    postParams.add(new BasicNameValuePair("redirect_uri", redirect_uri));    // �����̷�Ʈ URI
		    postParams.add(new BasicNameValuePair("code", token));    // �α��� ������ ���� code ��
			
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
			
			//JSON ���� ��ȯ�� ó��
			ObjectMapper mapper = new ObjectMapper();	            
            returnNode = mapper.readTree(response.getEntity().getContent());
            //System.out.println("getKakaoAccessToken returnNode : " + returnNode);
            
            return_value = returnNode.get("access_token").getTextValue().toString();
			
		} catch (Exception e) {
			System.out.println("ShortenUrlGoogle:getBitlyAccessToken : " + e);
		}
		
		return return_value;
	}
 
    //�׽�Ʈ�� main
    //inputURL�� ��ȯ��� URL�� String���� ������ GoogleShortUrl Ŭ������ getShortenUrl() �޼��� ȣ��
    //getShortenUrl(String originalUrl) �� static �̹Ƿ� ��ü�������� �ٷ� ���
    public static void main(String[] args) throws UnknownHostException, SocketTimeoutException {
        String originalUrl = "http://www.google.com";
        System.out.println("[DEBUG] main() RESULT_URL  : " + ShortenUrlGoogle.getShortenUrl(originalUrl));
    }
}