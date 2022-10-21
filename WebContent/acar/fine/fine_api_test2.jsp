<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="org.apache.http.client.HttpClient" %>
<%@ page import="org.apache.http.impl.client.HttpClientBuilder" %>
<%@ page import="org.apache.http.client.methods.HttpPost" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="org.apache.http.entity.ByteArrayEntity" %>


<%
// 	request.setCharacterEncoding("euc-kr");
	// 요청 받음
	BufferedReader requestReader = null;
    JSONObject requestJSON = null;
    JSONObject result = new JSONObject();
    try {

        // json 파싱
        requestReader = new BufferedReader(new InputStreamReader(request.getInputStream()));
        StringBuffer stringBuffer = new StringBuffer();
        String l = "";
        
        while ((l = requestReader.readLine()) != null) {
//         	System.out.println(URLDecoder.decode(l,"EUC-KR"));
            stringBuffer.append(l);
        }

        JSONParser jsonParser = new JSONParser();
//         System.out.println(URLDecoder.decode(stringBuffer.toString(),"EUC-KR"));
        requestJSON = (JSONObject)jsonParser.parse(stringBuffer.toString());
        
//         String paidNo = requestJSON.getString("paid_no");
//         System.out.println(paidNo);
        
        System.out.println(requestJSON);
        result.put("result", "성공");
        
       

    } catch (IOException e) {
        e.printStackTrace();
    } catch (ParseException e) {
        e.printStackTrace();
    } finally {
        if (requestReader != null) {
            requestReader.close();
        }
    }
    
    out.print(result);
    out.flush();

//     // 2. papyless 요청 보냄
//     HttpClient client = HttpClientBuilder.create().build();
//     BufferedReader responseReader = null;
//     StringBuffer responseBuffer = null;
//     try {

//         // 2-1. url 생성
//         String url = baseUrl + requestJSON.get("url");

//         // 2-2. header 생성
//         String method = (String)requestJSON.get("method");
//         HttpPost post = new HttpPost(url);
//         post.setHeader("Content-Type", "text/xml; charset=utf-8");
//         post.setHeader("SOAPAction",  "http://tempuri.org/" + method);

//         // 2-3. body 생성 (UTF-8 변환 확인)
//         String body = URLDecoder.decode((String)requestJSON.get("body"), "UTF-8");
//         post.setEntity(new ByteArrayEntity(body.getBytes("UTF-8")));

//         // 3. papyless 응답 받음
//         HttpResponse res = client.execute(post);

//         responseReader = new BufferedReader(new InputStreamReader(res.getEntity().getContent()));
//         responseBuffer = new StringBuffer();
//         String l = "";
//         while ((l = responseReader.readLine()) != null) {
//             responseBuffer.append(l);
//         }

//     } catch (IOException e) {
//         e.printStackTrace();
//     } finally {
//         if (responseReader != null) {
//             responseReader.close();
//         }
//     }

//     // 4. proxy 응답 보냄
//     JSONObject result = new JSONObject();
//     result.put("result", responseBuffer.toString());
//     out.print(result);
//     out.flush();

%>