<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.util.*, java.util.List" %>
<%@ page import="java.text.DateFormat, java.text.ParseException, java.text.SimpleDateFormat" %>
<%@ page import="java.net.URLEncoder, java.net.URLDecoder" %>
<%@ page import="acar.util.*, acar.common.*, acar.ars.*, acar.estimate_mng.*, acar.cont.*" %>
<%@ page import="acar.user_mng.*, acar.client.*, acar.cont.*, acar.insur.*, acar.car_register.*, acar.biz_tel_mng.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ars_db" class="acar.ars.ArsApiDatabase" scope="page"/>

<jsp:useBean id="bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ars_bean" class="acar.ars.ArsApiBean" scope="page"/>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();	
	EstiDatabase e_db = EstiDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	/*
		type
		info : 모든정보 조회
		car_no : 차량번호 인증 조회
		msg_send : 알림톡 템플릿 발송
		call_info : ARS 통화결과 INSERT
		
		gubun
		phone : 고객 연락처 검색(장기렌트,월렌트,업무대여)
		dept : 고객 지점 연락처 검색(장기렌트,월렌트,업무대여)
		manager : 고객 관계자 연락처 검색(장기렌트,월렌트,업무대여)
		
		send_type
    	insur - 보험
    	maint - 정비
    	sos - 긴급출동
    	accident - 교통사고
    	
    	code
	    200 : 성공
	    400 : 실패
	    401 : 실패 - search_type 없음
	    402 : 실패 - number 없음
	    403 : 실패 - search_type, 전화번호 없음
	    405 : 실패 - type error
	    500 : 데이터없음
	*/
    
	String ENC_STR = "EUC-KR";
    //String ENC_STR = "UTF-8";

    String type = request.getParameter("type")==null?"": request.getParameter("type");    
    String search_type = request.getParameter("search_type")==null?"": request.getParameter("search_type");
    String number = request.getParameter("number")==null?"": request.getParameter("number");
    String origin_number = request.getParameter("origin_number")==null?"": request.getParameter("origin_number");
    String gubun = request.getParameter("gubun")==null?"": request.getParameter("gubun");
    String client_id = request.getParameter("client_id")==null?"": request.getParameter("client_id");
    String firm_nm = request.getParameter("firm_nm")==null?"": request.getParameter("firm_nm");
    String car_no = request.getParameter("car_no")==null?"": request.getParameter("car_no");
    String br_id = request.getParameter("br_id")==null?"": request.getParameter("br_id");
    String user_id = request.getParameter("user_id")==null?"": request.getParameter("user_id");
    String user_nm = request.getParameter("user_nm")==null?"": request.getParameter("user_nm");
    String user_m_tel = request.getParameter("user_m_tel")==null?"": request.getParameter("user_m_tel");
    String send_type = request.getParameter("send_type")==null?"": request.getParameter("send_type");
    String test_num = request.getParameter("test_num")==null?"": request.getParameter("test_num");
    String rent_mng_id = request.getParameter("rent_mng_id")==null?"": request.getParameter("rent_mng_id");
    String rent_l_cd = request.getParameter("rent_l_cd")==null?"": request.getParameter("rent_l_cd");
    String data = request.getParameter("data")==null?"": request.getParameter("data");
    
    //LOG_DATA
    String id = request.getParameter("id")==null?"": request.getParameter("id");
    String user_type = request.getParameter("user_type")==null?"": request.getParameter("user_type");
    String cid = request.getParameter("cid")==null?"": request.getParameter("cid");
    String redirect_number = request.getParameter("redirect_number")==null?"": request.getParameter("redirect_number");
    String hangup_time = request.getParameter("hangup_time")==null?"": request.getParameter("hangup_time");
    String bill_duration = request.getParameter("bill_duration")==null?"": request.getParameter("bill_duration");
    String call_status = request.getParameter("call_status")==null?"": request.getParameter("call_status");
    String info_type = request.getParameter("info_type")==null?"": request.getParameter("info_type");
    
    String called_number = request.getParameter("called_number")==null?"": request.getParameter("called_number");
    String access_number = request.getParameter("access_number")==null?"": request.getParameter("access_number");
    String call_date = request.getParameter("call_date")==null?"": request.getParameter("call_date");
    String dial_time = request.getParameter("dial_time")==null?"": request.getParameter("dial_time");
    String answer_time = request.getParameter("answer_time")==null?"": request.getParameter("answer_time");
    String call_duration = request.getParameter("call_duration")==null?"": request.getParameter("call_duration");
    String dtmf_string = request.getParameter("dtmf_string")==null?"": request.getParameter("dtmf_string");
    String callback_flag = request.getParameter("callback_flag")==null?"": request.getParameter("callback_flag");
    
    String api_call_url = request.getRequestURL().toString();
    String api_call_param = request.getQueryString().toString();    
    String api_call_full_url = api_call_url + "?" + api_call_param;
    
    ars_bean.setApi_call_url(api_call_full_url);
    
    String ars_group = "";

    String return_code = "200";
    String return_code_1 = "200";
    String return_code_2 = "200";
    String return_code_3 = "200";
    
    String result_txt = "";
    
    List<ArsApiBean> ArsBeanList = new ArrayList<ArsApiBean>();
    List<ArsApiBean> ArsBeanList2 = new ArrayList<ArsApiBean>();
    List<ArsApiBean> ArsBeanList3 = new ArrayList<ArsApiBean>();        
    
    boolean log_temp_flag = true; 
    
    //정보 조회
    if (type.equals("info")) {

        JSONParser parser = new JSONParser();
        
        JSONArray result = new JSONArray();
        
        if (search_type.equals("")) {
        	return_code = "401";
        }
        if (number.equals("")) {
        	return_code = "402";
        }
        if (search_type.equals("") && number.equals("")) {
        	return_code = "403";
        }        
        if (type.equals("") && !(type.equals("info") || type.equals("msg_send"))) {
        	return_code = "405";
        }
        
        if (return_code.equals("401") || return_code.equals("402") || return_code.equals("403") || return_code.equals("405")) {
        	
        	if (return_code.equals("401")) {
        		result_txt = "No search_type";
        	} else if (return_code.equals("402")) {
        		result_txt = "No number";
        	} else if (return_code.equals("403")) {
        		result_txt = "No search_type, number";
        	} else if (return_code.equals("405")) {
        		result_txt = "Invalid type";
        	}
        	
        	JSONObject arsApiJson = new JSONObject();
        	
        	arsApiJson.put("code", return_code);
        	arsApiJson.put("result", result_txt);
        	
        	result.put(arsApiJson);
        	
        	ars_bean.setType(type);
			ars_bean.setResult_code(return_code);
			
			log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
        	
        } else {
			
        	//고객 연락처 검색(장기렌트,월렌트,업무대여)
        	ArsBeanList = ars_db.selectSearchClientNumInfo2(search_type, number, car_no);
        	int ArsBeanList_size = ArsBeanList.size();
        	
        	//고객 지점 연락처 검색(장기렌트,월렌트,업무대여)
        	ArsBeanList2 = ars_db.selectSearchClientDeptNumInfo2(search_type, number, car_no);
        	int ArsBeanList2_size = ArsBeanList2.size();
        	
        	//관계자 연락처 검색(장기렌트,월렌트,업무대여)
        	ArsBeanList3 = ars_db.selectSearchClientManagerNumInfo2(search_type, number, car_no);
        	int ArsBeanList3_size = ArsBeanList3.size();
        	
        	if (ArsBeanList_size == 0 && ArsBeanList2_size == 0 && ArsBeanList3_size == 0) {
        		
        		JSONObject arsApiJson = new JSONObject();
            	arsApiJson.put("type", "info");
            	arsApiJson.put("code", "500");
            	arsApiJson.put("result", "No data");
            	result.put(arsApiJson);
            	
            	ars_bean.setType(type);
    			ars_bean.setResult_code("500");
    			
    			log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
            	
        	} else {
        		
        		//phone
        		if (ArsBeanList_size > 0 && (ArsBeanList2_size >= 0 && ArsBeanList3_size >= 0)) {
        			
        			if (ArsBeanList_size >= 1) {
                		ArsBeanList_size = 1;
                	}
                	
    				for (int i = 0; i < ArsBeanList_size; i++) {
    		        	ArsApiBean arsApi = ArsBeanList.get(i);
    		        	
    		            JSONObject arsApiJson = new JSONObject();
    		        	
    		            arsApiJson.put("search_type", search_type);
    		            arsApiJson.put("gubun", "phone");
    		            arsApiJson.put("client_id", arsApi.getClient_id());
    		            
    		            if (ArsBeanList.size() == 1) {
    		            	arsApiJson.put("car_no", arsApi.getCar_no());
    		            	arsApiJson.put("car_no_enc", URLEncoder.encode(arsApi.getCar_no(), ENC_STR));
    		            	arsApiJson.put("rent_mng_id", arsApi.getRent_mng_id());
    		            	arsApiJson.put("rent_l_cd", arsApi.getRent_l_cd());
    		            } else {
    		            	arsApiJson.put("car_no", "");
    		            	arsApiJson.put("car_no_enc", "");
    		            	arsApiJson.put("rent_mng_id", "");
    		            	arsApiJson.put("rent_l_cd", "");
    		            }
    		            
    		            arsApiJson.put("firm_nm", arsApi.getFirm_nm());
    		            arsApiJson.put("firm_nm_enc", URLEncoder.encode(arsApi.getFirm_nm(), ENC_STR));

    		            arsApiJson.put("user_id", arsApi.getUser_id());
    		            arsApiJson.put("user_nm", arsApi.getUser_nm());
    		            arsApiJson.put("user_nm_enc", URLEncoder.encode(arsApi.getUser_nm(), ENC_STR));
    		            arsApiJson.put("user_m_tel", arsApi.getUser_m_tel());
    		            
    		          	//사용자 정보 조회
    		          	ars_group = arsApi.getArs_group();
    		          	String[] ars_group_split = ars_group.split("/");
    		          	
    		          	if (ars_group.equals("")) {
    		          		arsApiJson.put("user_id_1", arsApi.getUser_id());
        		            arsApiJson.put("user_nm_1", arsApi.getUser_nm());
        		            arsApiJson.put("user_nm_enc_1", URLEncoder.encode(arsApi.getUser_nm(), ENC_STR));
        		            arsApiJson.put("user_m_tel_1", arsApi.getUser_m_tel());

        		            arsApiJson.put("user_id_2", arsApi.getUser_id());
        		            arsApiJson.put("user_nm_2", arsApi.getUser_nm());
        		            arsApiJson.put("user_nm_enc_2", URLEncoder.encode(arsApi.getUser_nm(), ENC_STR));
        		            arsApiJson.put("user_m_tel_2", arsApi.getUser_m_tel());
        		            
    		          	} else {
	    		        	
    		          		for (int j = 0; j < ars_group_split.length; j++) {
	    		        		String split_user_id = ars_group_split[j];
	    		        		
	    		        		if (split_user_id.equals("")) {
	    		        			
	    		        			arsApiJson.put("user_id_" + (j+1), arsApi.getUser_id());
		        		            arsApiJson.put("user_nm_" + (j+1), arsApi.getUser_nm());
		        		            arsApiJson.put("user_nm_enc_" + (j+1), URLEncoder.encode(arsApi.getUser_nm(), ENC_STR));
		        		            arsApiJson.put("user_m_tel_" + (j+1), arsApi.getUser_m_tel());
		        		            
	    		        		} else {	    		        			
		    		        		
	    		        			user_bean = umd.getUsersBean(split_user_id);
		    		        		
		    		        		arsApiJson.put("user_id_" + (j+1), user_bean.getUser_id());
		        		            arsApiJson.put("user_nm_" + (j+1), user_bean.getUser_nm());
		        		            arsApiJson.put("user_nm_enc_" + (j+1), URLEncoder.encode(user_bean.getUser_nm(), ENC_STR));
		        		            arsApiJson.put("user_m_tel_" + (j+1), user_bean.getUser_m_tel().replace("-", ""));
	    		        		}	    		        		
	    		        	}
    		          	}
    		            
    		            arsApiJson.put("code", return_code_1);
    	
    		            result.put(arsApiJson);
    		            
    		            ars_bean.setType(type);
    					ars_bean.setResult_code(return_code_1);
    					
    					log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
    		            
    		        }
				
   				//dept
        		} else if (ArsBeanList2_size > 0 && (ArsBeanList_size >= 0 && ArsBeanList3_size >= 0)) {
        			
        			if (ArsBeanList2_size >= 1) {
                		ArsBeanList2_size = 1;
                	}
                	
    		        for (int i = 0; i < ArsBeanList2_size; i++) {
    		        	ArsApiBean arsApi2 = ArsBeanList2.get(i);
    		        	
    		            JSONObject arsApiJson = new JSONObject();
    		            
    		            arsApiJson.put("search_type", search_type);
    		            arsApiJson.put("gubun", "dept");
    		            arsApiJson.put("client_id", arsApi2.getClient_id());
    		            
    		            if (ArsBeanList2.size() == 1) {
    		            	arsApiJson.put("car_no", arsApi2.getCar_no());
    		            	arsApiJson.put("car_no_enc", URLEncoder.encode(arsApi2.getCar_no(), ENC_STR));
    		            	arsApiJson.put("rent_mng_id", arsApi2.getRent_mng_id());
    		            	arsApiJson.put("rent_l_cd", arsApi2.getRent_l_cd());
    		            } else {
    		            	arsApiJson.put("car_no", "");
    		            	arsApiJson.put("car_no_enc", "");
    		            	arsApiJson.put("rent_mng_id", "");
    		            	arsApiJson.put("rent_l_cd", "");
    		            }
    		            
    		            arsApiJson.put("firm_nm", arsApi2.getFirm_nm());
    		            arsApiJson.put("firm_nm_enc", URLEncoder.encode(arsApi2.getFirm_nm(), ENC_STR));
    		                		            
    		            arsApiJson.put("user_id", arsApi2.getUser_id());
    		            arsApiJson.put("user_nm", arsApi2.getUser_nm());
    		            arsApiJson.put("user_nm_enc", URLEncoder.encode(arsApi2.getUser_nm(), ENC_STR));
    		            arsApiJson.put("user_m_tel", arsApi2.getUser_m_tel());
    		            
    		          	//사용자 정보 조회
    		          	ars_group = arsApi2.getArs_group();
    		          	String[] ars_group_split = ars_group.split("/");
    		          	
    		          	if (ars_group.equals("")) {
    		          		arsApiJson.put("user_id_1", arsApi2.getUser_id());
        		            arsApiJson.put("user_nm_1", arsApi2.getUser_nm());
        		            arsApiJson.put("user_nm_enc_1", URLEncoder.encode(arsApi2.getUser_nm(), ENC_STR));
        		            arsApiJson.put("user_m_tel_1", arsApi2.getUser_m_tel());

        		            arsApiJson.put("user_id_2", arsApi2.getUser_id());
        		            arsApiJson.put("user_nm_2", arsApi2.getUser_nm());
        		            arsApiJson.put("user_nm_enc_2", URLEncoder.encode(arsApi2.getUser_nm(), ENC_STR));
        		            arsApiJson.put("user_m_tel_2", arsApi2.getUser_m_tel());
        		            
    		          	} else {
	    		        	
    		          		for (int j = 0; j < ars_group_split.length; j++) {
	    		        		String split_user_id = ars_group_split[j];
	    		        		
	    		        		if (split_user_id.equals("")) {
	    		        			
	    		        			arsApiJson.put("user_id_" + (j+1), arsApi2.getUser_id());
		        		            arsApiJson.put("user_nm_" + (j+1), arsApi2.getUser_nm());
		        		            arsApiJson.put("user_nm_enc_" + (j+1), URLEncoder.encode(arsApi2.getUser_nm(), ENC_STR));
		        		            arsApiJson.put("user_m_tel_" + (j+1), arsApi2.getUser_m_tel());
		        		            
	    		        		} else {	    		        			
		    		        		
	    		        			user_bean = umd.getUsersBean(split_user_id);
		    		        		
		    		        		arsApiJson.put("user_id_" + (j+1), user_bean.getUser_id());
		        		            arsApiJson.put("user_nm_" + (j+1), user_bean.getUser_nm());
		        		            arsApiJson.put("user_nm_enc_" + (j+1), URLEncoder.encode(user_bean.getUser_nm(), ENC_STR));
		        		            arsApiJson.put("user_m_tel_" + (j+1), user_bean.getUser_m_tel().replace("-", ""));
	    		        		}	    		        		
	    		        	}
    		          	}
    		            
    		            arsApiJson.put("code", return_code_2);
    	
    		            result.put(arsApiJson);
    		            
    		            ars_bean.setType(type);
    					ars_bean.setResult_code(return_code_2);
    					
    					log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
    		            
    		        }
    		        
				//manager
        		} else if (ArsBeanList3_size > 0 && (ArsBeanList_size >= 0 && ArsBeanList2_size >= 0)) {
        			
        			if (ArsBeanList3_size >= 1) {
                		ArsBeanList3_size = 1;
                	}
                	
                	for (int i = 0; i < ArsBeanList3_size; i++) {
    		        	ArsApiBean arsApi3 = ArsBeanList3.get(i);

    		            JSONObject arsApiJson = new JSONObject();

    		            arsApiJson.put("search_type", search_type);
    		            arsApiJson.put("gubun", "manager");
    		            arsApiJson.put("client_id", arsApi3.getClient_id());
    		            
    		            if (ArsBeanList3.size() == 1) {
    		            	arsApiJson.put("car_no", arsApi3.getCar_no());
    		            	arsApiJson.put("car_no_enc", URLEncoder.encode(arsApi3.getCar_no(), ENC_STR));
    		            	arsApiJson.put("rent_mng_id", arsApi3.getRent_mng_id());
    		            	arsApiJson.put("rent_l_cd", arsApi3.getRent_l_cd());
    		            } else {
    		            	arsApiJson.put("car_no", "");
    		            	arsApiJson.put("car_no_enc", "");
    		            	arsApiJson.put("rent_mng_id", "");
    		            	arsApiJson.put("rent_l_cd", "");
    		            }
    		            
    		            arsApiJson.put("firm_nm", arsApi3.getFirm_nm());
    		            arsApiJson.put("firm_nm_enc", URLEncoder.encode(arsApi3.getFirm_nm(), ENC_STR));

    		            arsApiJson.put("user_id", arsApi3.getUser_id());
    		            arsApiJson.put("user_nm", arsApi3.getUser_nm());
    		            arsApiJson.put("user_nm_enc", URLEncoder.encode(arsApi3.getUser_nm(), ENC_STR));
    		            arsApiJson.put("user_m_tel", arsApi3.getUser_m_tel());
    		            
    		          	//사용자 정보 조회
    		          	ars_group = arsApi3.getArs_group();
    		          	String[] ars_group_split = ars_group.split("/");
    		          	
    		          	if (ars_group.equals("")) {
    		          		arsApiJson.put("user_id_1", arsApi3.getUser_id());
        		            arsApiJson.put("user_nm_1", arsApi3.getUser_nm());
        		            arsApiJson.put("user_nm_enc_1", URLEncoder.encode(arsApi3.getUser_nm(), ENC_STR));
        		            arsApiJson.put("user_m_tel_1", arsApi3.getUser_m_tel());

        		            arsApiJson.put("user_id_2", arsApi3.getUser_id());
        		            arsApiJson.put("user_nm_2", arsApi3.getUser_nm());
        		            arsApiJson.put("user_nm_enc_2", URLEncoder.encode(arsApi3.getUser_nm(), ENC_STR));
        		            arsApiJson.put("user_m_tel_2", arsApi3.getUser_m_tel());
        		            
    		          	} else {
	    		        	
    		          		for (int j = 0; j < ars_group_split.length; j++) {
	    		        		String split_user_id = ars_group_split[j];
	    		        		
	    		        		if (split_user_id.equals("")) {
	    		        			
	    		        			arsApiJson.put("user_id_" + (j+1), arsApi3.getUser_id());
		        		            arsApiJson.put("user_nm_" + (j+1), arsApi3.getUser_nm());
		        		            arsApiJson.put("user_nm_enc_" + (j+1), URLEncoder.encode(arsApi3.getUser_nm(), ENC_STR));
		        		            arsApiJson.put("user_m_tel_" + (j+1), arsApi3.getUser_m_tel());
		        		            
	    		        		} else {	    		        			
		    		        		
	    		        			user_bean = umd.getUsersBean(split_user_id);
		    		        		
		    		        		arsApiJson.put("user_id_" + (j+1), user_bean.getUser_id());
		        		            arsApiJson.put("user_nm_" + (j+1), user_bean.getUser_nm());
		        		            arsApiJson.put("user_nm_enc_" + (j+1), URLEncoder.encode(user_bean.getUser_nm(), ENC_STR));
		        		            arsApiJson.put("user_m_tel_" + (j+1), user_bean.getUser_m_tel().replace("-", ""));
	    		        		}	    		        		
	    		        	}
    		          	}

    		            arsApiJson.put("code", return_code_3);

    		            result.put(arsApiJson);
    		            
    		            ars_bean.setType(type);
    					ars_bean.setResult_code(return_code_3);
    					
    					log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
    		            
    		        }
        			
        		}
        		
        	}
        	
        }

        out.print(result);
        out.flush();
    
    }
    
    //차량번호 인증
    if (type.equals("car_no")) {
		
    	JSONParser parser = new JSONParser();
        
        JSONArray result = new JSONArray();
        
    	if (gubun.equals("phone")) {
    		//고객 연락처 검색(장기렌트,월렌트,업무대여)
        	ArsBeanList = ars_db.selectSearchClientNumInfo2(search_type, number, car_no);
    	} else if (gubun.equals("dept")) {
    		//고객 지점 연락처 검색(장기렌트,월렌트,업무대여)
        	ArsBeanList = ars_db.selectSearchClientDeptNumInfo2(search_type, number, car_no);
    	} else if (gubun.equals("manager")) {
    		//관계자 연락처 검색(장기렌트,월렌트,업무대여)
        	ArsBeanList = ars_db.selectSearchClientManagerNumInfo2(search_type, number, car_no);
    	}
    	
    	int ArsBeanList_size = ArsBeanList.size();
    	
    	if (ArsBeanList_size == 0) {
    		
    		JSONObject arsApiJson = new JSONObject();
        	arsApiJson.put("type", "car_no");
        	arsApiJson.put("code", "500");
        	arsApiJson.put("result", "No data");
        	result.put(arsApiJson);
        	
        	ars_bean.setType(type);
			ars_bean.setResult_code("500");
			
			log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
        	
    	} else {
    		
			if (ArsBeanList_size > 0) {
				
				if (ArsBeanList_size >= 1) {
	        		ArsBeanList_size = 1;
	        	}
	        	
				for (int i = 0; i < ArsBeanList_size; i++) {
		        	ArsApiBean arsApi = ArsBeanList.get(i);
		        	
		            JSONObject arsApiJson = new JSONObject();
		        	
		            arsApiJson.put("search_type", search_type);
		            arsApiJson.put("gubun", gubun);
		            arsApiJson.put("client_id", arsApi.getClient_id());
		            
	            	arsApiJson.put("car_no", arsApi.getCar_no());
	            	arsApiJson.put("car_no_enc", URLEncoder.encode(arsApi.getCar_no(), ENC_STR));
	            	arsApiJson.put("rent_mng_id", arsApi.getRent_mng_id());
	            	arsApiJson.put("rent_l_cd", arsApi.getRent_l_cd());
		            
		            arsApiJson.put("firm_nm", arsApi.getFirm_nm());
		            arsApiJson.put("firm_nm_enc", URLEncoder.encode(arsApi.getFirm_nm(), ENC_STR));

		            arsApiJson.put("user_id", arsApi.getUser_id());
		            arsApiJson.put("user_nm", arsApi.getUser_nm());
		            arsApiJson.put("user_nm_enc", URLEncoder.encode(arsApi.getUser_nm(), ENC_STR));
		            arsApiJson.put("user_m_tel", arsApi.getUser_m_tel());
		            
		          	//사용자 정보 조회
		          	ars_group = arsApi.getArs_group();
		          	String[] ars_group_split = ars_group.split("/");
		          	
		          	if (ars_group.equals("")) {
		          		arsApiJson.put("user_id_1", arsApi.getUser_id());
    		            arsApiJson.put("user_nm_1", arsApi.getUser_nm());
    		            arsApiJson.put("user_nm_enc_1", URLEncoder.encode(arsApi.getUser_nm(), ENC_STR));
    		            arsApiJson.put("user_m_tel_1", arsApi.getUser_m_tel());

    		            arsApiJson.put("user_id_2", arsApi.getUser_id());
    		            arsApiJson.put("user_nm_2", arsApi.getUser_nm());
    		            arsApiJson.put("user_nm_enc_2", URLEncoder.encode(arsApi.getUser_nm(), ENC_STR));
    		            arsApiJson.put("user_m_tel_2", arsApi.getUser_m_tel());
    		            
		          	} else {
    		        	
		          		for (int j = 0; j < ars_group_split.length; j++) {
    		        		String split_user_id = ars_group_split[j];
    		        		
    		        		if (split_user_id.equals("")) {
    		        			
    		        			arsApiJson.put("user_id_" + (j+1), arsApi.getUser_id());
	        		            arsApiJson.put("user_nm_" + (j+1), arsApi.getUser_nm());
	        		            arsApiJson.put("user_nm_enc_" + (j+1), URLEncoder.encode(arsApi.getUser_nm(), ENC_STR));
	        		            arsApiJson.put("user_m_tel_" + (j+1), arsApi.getUser_m_tel());
	        		            
    		        		} else {
	    		        		
    		        			user_bean = umd.getUsersBean(split_user_id);
	    		        		
	    		        		arsApiJson.put("user_id_" + (j+1), user_bean.getUser_id());
	        		            arsApiJson.put("user_nm_" + (j+1), user_bean.getUser_nm());
	        		            arsApiJson.put("user_nm_enc_" + (j+1), URLEncoder.encode(user_bean.getUser_nm(), ENC_STR));
	        		            arsApiJson.put("user_m_tel_" + (j+1), user_bean.getUser_m_tel().replace("-", ""));
    		        		}	    		        		
    		        	}
		          	}
		            
		            arsApiJson.put("code", return_code_1);
		            
		            ars_bean.setType(type);
					ars_bean.setResult_code(return_code_1);
					
					log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
	
		            result.put(arsApiJson);
		        }				
			}	        
    	}
    	
		out.print(result);
        out.flush();
    	
    }    
    
    //ARS상담요청 등록
	if (type.equals("consult")) {
    	
		JSONObject result = new JSONObject();
		
		DateFormat regFormat = new SimpleDateFormat("yyyyMMddHHmm");
    	Date today = new Date();
    	String regDate = regFormat.format(today).toString();
    	String regCode = Long.toString(System.currentTimeMillis());
    	String newEstimateId = regCode + "1";
    	
    	access_number = access_number.replace("-", "");
    	
    	String est_area = "서울/본사";
    	
    	if (!access_number.equals("")) {
    		
	   		Hashtable br = ars_db.getBranch(access_number);    	
	    	
	    	if (br.get("BR_ID").equals("S1")) {
	    		est_area = "서울/본사";
	    	} else if (br.get("BR_ID").equals("I1")) {
	    		est_area = "인천/인천";
	    	} else if (br.get("BR_ID").equals("S2")) {
	    		est_area = "서울/강남";
	    	} else if (br.get("BR_ID").equals("B1")) {
	    		est_area = "부산/부산";
	    	} else if (br.get("BR_ID").equals("D1")) {
	    		est_area = "대전/대전";
	    	} else if (br.get("BR_ID").equals("G1")) {
	    		est_area = "대구/대구";
	    	} else if (br.get("BR_ID").equals("J1")) {
	    		est_area = "광주/광주";
	    	} else if (br.get("BR_ID").equals("S4")) {
	    		est_area = "서울/본사";
	    	} else if (br.get("BR_ID").equals("K3")) {
	    		est_area = "수원/수원";
	    	} else if (br.get("BR_ID").equals("S3")) {
	    		est_area = "서울/본사";
	    	} else if (br.get("BR_ID").equals("S5")) {
	    		est_area = "서울/광화문";
	    	} else if (br.get("BR_ID").equals("S6")) {
	    		est_area = "서울/송파";
	    	} else {
	    		est_area = "서울/본사";
	    	}
	    	
    	}
   		
   		bean.setEst_id		(newEstimateId); //고객상담요청관리번호 생성
		bean.setEst_st		("ARS");
		bean.setEst_tel		(number);
		bean.setEst_area	(est_area);
    	
		if (client_id.equals("")) {
			//고객상담요청 - 미인증고객			
			bean.setEst_nm		("ARS 상담신청 고객");
			bean.setEtc			("ARS 상담신청");
		} else {
			//고객상담요청 - 인증고객
			bean.setEst_nm		(URLDecoder.decode(firm_nm, ENC_STR));
			bean.setEtc			("ARS 상담신청");
		}

		int count = e_db.insertEstiGst(bean);
		
		if (count == 1) {
			result.put("code", "200");
			result.put("result", "OK");
			
			ars_bean.setType(type);
			ars_bean.setResult_code("200");
			
			log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
			
		} else {			
			result.put("code", "400");
			result.put("result", "FAIL");
			
			ars_bean.setType(type);
			ars_bean.setResult_code("400");
			
			log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
			
		}
        
        out.print(result);
        out.flush();
    	
    }
    
	//알림톡 발송
    if (type.equals("msg_send")) {
            	
        String customer_name = URLDecoder.decode(firm_nm, ENC_STR);
        String car_num = URLDecoder.decode(car_no, ENC_STR);
        String manager_name = URLDecoder.decode(user_nm, ENC_STR);
        String manager_phone = URLDecoder.decode(user_m_tel, ENC_STR);
        
      	//테스트용으로 메세지 받을 번호(임시)
        //origin_number = "01036736292";
        
        if (!test_num.equals("")) {
        	origin_number = test_num;
        }
        
        /* 
        maint - 정비
    	sos - 긴급출동
    	accident - 교통사고 
    	*/
    	
    	String move_page = "ars_info";
        
    	/* if (send_type.equals("maint")) {
    		move_page = "ars_info_maint";
    	} else if (send_type.equals("sos")) {
    		move_page = "ars_info_sos";
    	} else if (send_type.equals("accident")) {
    		move_page = "ars_info_accident";
    	} */
        
        String send_link = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/ars/"+move_page+".jsp?send_type=" + send_type + "&client_id=" + client_id + "&user_id=" + user_id + "&rent_mng_id=" + rent_mng_id + "&rent_l_cd=" + rent_l_cd + "&origin_number=" + origin_number);
        //사고
        String send_link_1 = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/ars/ars_info_accident.jsp?send_type=accident&client_id=" + client_id + "&user_id=" + user_id + "&rent_mng_id=" + rent_mng_id + "&rent_l_cd=" + rent_l_cd + "&origin_number=" + origin_number);
        //긴급출동
        String send_link_2 = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/ars/ars_info_sos.jsp?send_type=sos&client_id=" + client_id + "&user_id=" + user_id + "&rent_mng_id=" + rent_mng_id + "&rent_l_cd=" + rent_l_cd + "&origin_number=" + origin_number);
        //정비
        String send_link_3 = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/ars/ars_info_maint.jsp?send_type=maint&client_id=" + client_id + "&user_id=" + user_id + "&rent_mng_id=" + rent_mng_id + "&rent_l_cd=" + rent_l_cd + "&origin_number=" + origin_number);

        JSONObject result = new JSONObject();
        
      	//ARS 시스템 번호 02-6679-0400 
   		/* List<String> fieldList = Arrays.asList(customer_name, car_num, send_link, manager_name, manager_phone);
  		at_db.sendMessageReserve("acar0227", fieldList, origin_number, user_m_tel, null, "", ""); */
        
        if (send_type.equals("maint")) {
    		
        	List<String> fieldList = Arrays.asList(customer_name, car_num, send_link_1, send_link_2, send_link_3, manager_name, manager_phone);
      		at_db.sendMessageReserve("acar0235", fieldList, origin_number, user_m_tel, null, "", "");
      		
    	} else if (send_type.equals("sos") || send_type.equals("accident")) {
    		
    		List<String> fieldList = Arrays.asList(customer_name, car_num, send_link_1, send_link_2, manager_name, manager_phone);
      		at_db.sendMessageReserve("acar0234", fieldList, origin_number, user_m_tel, null, "", "");
      		
    	}
                
        result.put("code", "200");
		result.put("result", "OK");
        
        out.print(result);
        out.flush();
        
        ars_bean.setType(type);
		ars_bean.setResult_code("200");
		
		log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
    	
    }
	
  	//ARS 통화결과 insert
    if (type.equals("call_info")) {
    	
    	JSONObject result = new JSONObject();
    	
    	ars_bean.setId(AddUtil.parseInt(id));
    	
    	ars_bean.setUser_type(user_type);
    	ars_bean.setUser_id(user_id);
    	ars_bean.setCid(cid);
    	ars_bean.setRedirect_number(redirect_number);    	
    	ars_bean.setHangup_time(hangup_time);    	
    	ars_bean.setBill_duration(AddUtil.parseInt(bill_duration));
    	ars_bean.setCall_status(call_status);
    	ars_bean.setClient_id(client_id);    	
    	ars_bean.setCar_no(URLDecoder.decode(car_no, ENC_STR));    	
    	ars_bean.setInfo_type(info_type);
    	
    	ars_bean.setCalled_number(called_number);
    	ars_bean.setAccess_number(access_number);
    	ars_bean.setCall_date(call_date);
    	ars_bean.setDial_time(dial_time);
    	ars_bean.setAnswer_time(answer_time);
    	ars_bean.setCall_duration(AddUtil.parseInt(call_duration));
    	ars_bean.setDtmf_string(URLDecoder.decode(dtmf_string, ENC_STR));
    	ars_bean.setCallback_flag(callback_flag);
    	
    	boolean log_flag = ars_db.arsInsertLog(ars_bean);
    	
    	if (log_flag == true) {
			result.put("code", "200");
			result.put("result", "OK");
			
			ars_bean.setType(type);
			ars_bean.setResult_code("200");
			
			log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
			
		} else {
			result.put("code", "400");
			result.put("result", "FAIL");
			
			ars_bean.setType(type);
			ars_bean.setResult_code("400");
			
			log_temp_flag = ars_db.arsCallLogTempInsert(ars_bean);
		}
        
        out.print(result);
        out.flush();
    	
    }

%>

