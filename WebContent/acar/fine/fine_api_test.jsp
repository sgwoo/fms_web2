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
		info : ������� ��ȸ
		car_no : ������ȣ ���� ��ȸ
		msg_send : �˸��� ���ø� �߼�
		call_info : ARS ��ȭ��� INSERT
		
		gubun
		phone : �� ����ó �˻�(��ⷻƮ,����Ʈ,�����뿩)
		dept : �� ���� ����ó �˻�(��ⷻƮ,����Ʈ,�����뿩)
		manager : �� ������ ����ó �˻�(��ⷻƮ,����Ʈ,�����뿩)
		
		send_type
    	insur - ����
    	maint - ����
    	sos - ����⵿
    	accident - ������
    	
    	code
	    200 : ����
	    400 : ����
	    401 : ���� - search_type ����
	    402 : ���� - number ����
	    403 : ���� - search_type, ��ȭ��ȣ ����
	    405 : ���� - type error
	    500 : �����;���
	*/
    
	String ENC_STR = "EUC-KR";
    //String ENC_STR = "UTF-8";

    String gubun = request.getParameter("gubun")==null?"": request.getParameter("gubun"); // ���� : 1.����������, 2.������������ ����, 3.�����������������
    String car_no = request.getParameter("car_no")==null?"": request.getParameter("car_no"); // ������ȣ
    String gov_nm = request.getParameter("gov_nm")==null?"": request.getParameter("gov_nm"); // û�����
    String paid_no = request.getParameter("paid_no")==null?"": request.getParameter("paid_no"); // ���ΰ����� ��ȣ
    String vio_dt = request.getParameter("vio_dt")==null?"": request.getParameter("vio_dt"); // �����Ͻ�
    String vio_pla = request.getParameter("vio_pla")==null?"": request.getParameter("vio_pla"); // �������
    String vio_cont = request.getParameter("vio_cont")==null?"": request.getParameter("vio_cont"); // ���ݳ���
    String paid_amt = request.getParameter("paid_amt")==null?"": request.getParameter("paid_amt"); //  ���αݾ�
    String obj_end_dt = request.getParameter("obj_end_dt")==null?"" : request.getParameter("obj_end_dt"); // �ǰ���������
    String paid_end_dt = request.getParameter("paid_end_dt")==null?"": request.getParameter("paid_end_dt"); // ���α���
    String file_name = request.getParameter("file_name")==null?"": request.getParameter("file_name"); // ���ϸ�
    String file_size = request.getParameter("file_size")==null?"": request.getParameter("file_size"); // ���ϻ�����
    String file_type = request.getParameter("file_type")==null?"": request.getParameter("file_type"); // ��������
    String save_file = request.getParameter("save_file")==null?"": request.getParameter("save_file"); // �������ϸ�
    String save_folder = request.getParameter("save_folder")==null?"": request.getParameter("save_folder"); // ������
    
    JSONObject result = new JSONObject();
    
    // ���� ���� �� ������ �� üũ
    if(car_no == null || car_no.equals("")) {
   		result.put("result","������ȣ�� �����ϴ�.");
    } else if(gov_nm == null || gov_nm.equals("")) {
   		result.put("result","û������� �����ϴ�.");
    } else if(paid_no == null || paid_no.equals("")) {
   		result.put("result","��������ȣ�� �����ϴ�.");
    } else if(vio_dt == null || vio_dt.equals("")) {
   		result.put("result","�����Ͻð� �����ϴ�.");
    } else if(vio_pla == null || vio_pla.equals("")) {
   		result.put("result","������Ұ� �����ϴ�.");
    } else if(vio_cont == null || vio_cont.equals("")) {
   		result.put("result","���ݳ����� �����ϴ�.");
    } else if(paid_amt == null || paid_amt.equals("")) {
   		result.put("result","���αݾ��� �����ϴ�.");
    } else if(obj_end_dt == null || obj_end_dt.equals("")) {
   		result.put("result","�ǰ����������� �����ϴ�.");
    } else if(paid_end_dt == null || paid_end_dt.equals("")) {
   		result.put("result","���α����� �����ϴ�.");
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

