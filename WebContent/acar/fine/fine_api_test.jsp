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

    String gubun = request.getParameter("gubun")==null?"": request.getParameter("gubun"); // 구분 : 1.주정차위반, 2.버스전용차로 위반, 3.장애인주차구역위반
    String car_no = request.getParameter("car_no")==null?"": request.getParameter("car_no"); // 차량번호
    String gov_nm = request.getParameter("gov_nm")==null?"": request.getParameter("gov_nm"); // 청구기관
    String paid_no = request.getParameter("paid_no")==null?"": request.getParameter("paid_no"); // 납부고지서 번호
    String vio_dt = request.getParameter("vio_dt")==null?"": request.getParameter("vio_dt"); // 위반일시
    String vio_pla = request.getParameter("vio_pla")==null?"": request.getParameter("vio_pla"); // 위반장소
    String vio_cont = request.getParameter("vio_cont")==null?"": request.getParameter("vio_cont"); // 위반내용
    String paid_amt = request.getParameter("paid_amt")==null?"": request.getParameter("paid_amt"); //  납부금액
    String obj_end_dt = request.getParameter("obj_end_dt")==null?"" : request.getParameter("obj_end_dt"); // 의견진술기한
    String paid_end_dt = request.getParameter("paid_end_dt")==null?"": request.getParameter("paid_end_dt"); // 납부기한
    String file_name = request.getParameter("file_name")==null?"": request.getParameter("file_name"); // 파일명
    String file_size = request.getParameter("file_size")==null?"": request.getParameter("file_size"); // 파일사이즈
    String file_type = request.getParameter("file_type")==null?"": request.getParameter("file_type"); // 파일종류
    String save_file = request.getParameter("save_file")==null?"": request.getParameter("save_file"); // 저장파일명
    String save_folder = request.getParameter("save_folder")==null?"": request.getParameter("save_folder"); // 저장경로
    
    JSONObject result = new JSONObject();
    
    // 최초 진입 시 데이터 값 체크
    if(car_no == null || car_no.equals("")) {
   		result.put("result","차량번호가 없습니다.");
    } else if(gov_nm == null || gov_nm.equals("")) {
   		result.put("result","청구기관이 없습니다.");
    } else if(paid_no == null || paid_no.equals("")) {
   		result.put("result","고지서번호가 없습니다.");
    } else if(vio_dt == null || vio_dt.equals("")) {
   		result.put("result","위반일시가 없습니다.");
    } else if(vio_pla == null || vio_pla.equals("")) {
   		result.put("result","위반장소가 없습니다.");
    } else if(vio_cont == null || vio_cont.equals("")) {
   		result.put("result","위반내용이 없습니다.");
    } else if(paid_amt == null || paid_amt.equals("")) {
   		result.put("result","납부금액이 없습니다.");
    } else if(obj_end_dt == null || obj_end_dt.equals("")) {
   		result.put("result","의견진술기한이 없습니다.");
    } else if(paid_end_dt == null || paid_end_dt.equals("")) {
   		result.put("result","납부기한이 없습니다.");
    } 
    else {
   		result.put("result", "OK");
    }
    
    System.out.println("gubun > " + gubun);
    System.out.println("car_no > " + car_no);
    System.out.println("gov_nm > " + gov_nm);
    System.out.println("paid_no > " + paid_no);
    System.out.println("vio_dt > " + vio_dt);
    System.out.println("vio_pla > " + vio_pla);
    System.out.println("vio_cont > " + vio_cont);
    System.out.println("paid_amt > " + paid_amt);
    System.out.println("obj_end_dt > " + obj_end_dt);
    System.out.println("paid_end_dt > " + paid_end_dt);
    System.out.println("file_name > " + file_name);
    System.out.println("file_size > " + file_size);
    System.out.println("file_type > " + file_type);
    System.out.println("save_file > " + save_file);
    out.print(result);
    out.flush();

%>

