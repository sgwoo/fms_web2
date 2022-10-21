<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.*" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*, acar.user_mng.*, acar.coolmsg.*" %>
<jsp:useBean id="cu_db" class="acar.customer.Customer_Database" scope="page"/>
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
	    
	    String car_no = jsonObj.isNull("car_no") == true ? "" : (String) jsonObj.get("car_no"); // 차량번호
	    String vio_dt = jsonObj.isNull("vio_dt") == true ? "" : (String) jsonObj.get("vio_dt"); // 위반일시
	    String gov_id = jsonObj.isNull("gov_id") == true ? "" : (String) jsonObj.get("gov_id"); // 위반일시
		
	    String js_dt = vio_dt.substring(0,8);
	    
	    AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	    
	    Vector vt_s = a_fdb.getFineSearchContList(car_no, js_dt); // 계약 된 고객인지 확인
	    
	    String c_id = "";
		String m_id = "";
		String l_cd = "";
		String mng_id = "";
		String s_cd = "";
		String rent_st = "";
	    
	    if(vt_s.size() == 1){
		    Hashtable ht_s2 = (Hashtable)vt_s.elementAt(0);
	    	if(!String.valueOf(ht_s2.get("CAR_ST")).equals("2")){
				c_id 		= String.valueOf(ht_s2.get("CAR_MNG_ID")); 
				m_id 		= String.valueOf(ht_s2.get("RENT_MNG_ID")); 
				l_cd 		= String.valueOf(ht_s2.get("RENT_L_CD")); 
				mng_id 		= String.valueOf(ht_s2.get("MNG_ID")); 
				s_cd 		= String.valueOf(ht_s2.get("RENT_S_CD"));		
				rent_st 	= String.valueOf(ht_s2.get("RENT_ST"));
				
				result.put("result", "OK");
				result.put("c_id", c_id);
				result.put("m_id", m_id);
				result.put("l_cd", l_cd);
				result.put("mng_id", mng_id);
				result.put("s_cd", s_cd);
				result.put("rent_st", rent_st);
			}	
	    } else if(vt_s.size()>1){
	    	result.put("result", "고객 정보 중복");
		}
	    
	    if(c_id.equals("")){	
			Vector vt_s2 = cu_db.getFine_maker(car_no, js_dt); // 위반 일시에 따른 고객 찾기
			if(vt_s2.size() == 1){
				for(int j=0; j<vt_s2.size();j++){
					Hashtable ht_s2 = (Hashtable)vt_s2.elementAt(j);
				
					c_id 		= String.valueOf(ht_s2.get("CAR_MNG_ID")); 
					m_id 		= String.valueOf(ht_s2.get("RENT_MNG_ID")); 
					l_cd 		= String.valueOf(ht_s2.get("RENT_L_CD")); 
					mng_id 		= String.valueOf(ht_s2.get("MNG_ID")); 
					s_cd 		= String.valueOf(ht_s2.get("RENT_S_CD"));		
					rent_st 	= String.valueOf(ht_s2.get("RENT_ST"));
					
					result.put("result", "OK");
					result.put("c_id", c_id);
					result.put("m_id", m_id);
					result.put("l_cd", l_cd);
					result.put("mng_id", mng_id);
					result.put("s_cd", s_cd);
					result.put("rent_st", rent_st);
				}
			}else if(vt_s2.size()>1){
				result.put("result", "고객 정보 중복");
			}else{
				result.put("result", "고객 정보 없음");
			}
		} 
	    
	    if(c_id.equals("null")){
	    	result.put("result", "고객 정보 없음");
		}
	    
	    if(s_cd.equals("")||s_cd.equals("null")){
			s_cd = "";
		}
	    
	    Vector c_fines = a_fdb.getFineCheckList2(c_id, vio_dt);
	    int c_fine_size = c_fines.size();
	    
	    if(c_fine_size > 0) {
	    	result.put("result", "이미 등록된 과태료 정보");
	    	result.put("c_id", c_id);
			result.put("m_id", m_id);
			result.put("l_cd", l_cd);
			result.put("mng_id", mng_id);
			result.put("s_cd", s_cd);
			result.put("rent_st", rent_st);
	    }
	    // 결과값 리턴
	    response.setContentType("application/json");
	    out.print(result);
	   
	}catch(Exception e) {
	    System.out.println("Error reading JSON string: " + e.toString());
	}

%>

