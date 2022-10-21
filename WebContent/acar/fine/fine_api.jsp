<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.*" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.*, acar.forfeit_mng.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	StringBuffer jsonBuffer = new StringBuffer();
	JSONObject jsonObject = null;
	JSONObject result = new JSONObject();
	String json = null;
	String line = null;
	
	try {
		// JSON 데이터 읽기
	    BufferedReader reader = request.getReader();
	   
	    while((line = reader.readLine()) != null) {
	        jsonBuffer.append(line);
	    }
	    
	    json =jsonBuffer.toString();
		
	    // JSON 데이터 각각 파싱 진행
	    JSONObject jsonObj = new JSONObject(json);
	    
	    String gubun = jsonObj.isNull("gubun") == true ? "" : (String) jsonObj.get("gubun"); // 구분 : 1.주정차위반, 2.버스전용차로 위반, 3.장애인주차구역위반
	    String car_no = jsonObj.isNull("car_no") == true ? "" : (String) jsonObj.get("car_no"); // 차량번호
	    String gov_nm = jsonObj.isNull("gov_nm") == true ? "" : (String) jsonObj.get("gov_nm"); // 청구기관
	    String paid_no = jsonObj.isNull("paid_no") == true ? "" : (String) jsonObj.get("paid_no"); // 납부고지서 번호
	    String vio_dt = jsonObj.isNull("vio_dt") == true ? "" : (String) jsonObj.get("vio_dt"); // 위반일시
	    String vio_pla = jsonObj.isNull("vio_pla") == true ? "" : (String) jsonObj.get("vio_pla"); // 위반장소
	    String vio_cont = jsonObj.isNull("vio_cont") == true ? "" : (String) jsonObj.get("vio_cont"); // 위반내용
	    int paid_amt = jsonObj.isNull("paid_amt") == true ? 0 : (int) jsonObj.get("paid_amt"); // 납부금액
	    String obj_end_dt = jsonObj.isNull("obj_end_dt") == true ? "" : (String) jsonObj.get("obj_end_dt"); // 의견진술기한
	    String paid_end_dt = jsonObj.isNull("paid_end_dt") == true ? "" : (String) jsonObj.get("paid_end_dt"); // 납부기한
	    String file_name = jsonObj.isNull("file_name") == true ? "" : (String) jsonObj.get("file_name"); // 파일명
	    String save_folder = jsonObj.isNull("save_folder") == true ? "" : (String) jsonObj.get("save_folder"); // 저장경로
	    
   		result.put("result", "OK");
		// 과태료 정보 등록	   		
   		ForfeitDatabase fdb = ForfeitDatabase.getInstance();
   		
		HashMap<String, Object> map= new HashMap<>();
   		map.put("gubun",gubun);
   		map.put("car_no",car_no);
   		map.put("gov_nm",gov_nm);
   		map.put("paid_no",paid_no);
   		map.put("vio_pla",vio_pla);
   		map.put("vio_dt",vio_dt);
   		map.put("vio_cont",vio_cont);
   		map.put("paid_amt",paid_amt);
   		map.put("obj_end_dt",obj_end_dt);
   		map.put("paid_end_dt",paid_end_dt);
   		map.put("file_name",file_name);
   		map.put("save_folder",save_folder);
		
   		fdb.insertFine(map);
	 
	    response.setContentType("application/json");
	    out.print(result);
	   
	}catch(Exception e) {
	    System.out.println("Error reading JSON string: " + e.toString());
	}

%>

