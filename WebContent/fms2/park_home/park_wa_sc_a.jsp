<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*, acar.util.*, acar.user_mng.*, acar.parking.*, acar.cus_reg.*, acar.car_service.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="pbean" scope="page" class="acar.parking.ParkBean"/> 
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");


	String wash_pay = request.getParameter("wash_pay")==null?"":request.getParameter("wash_pay"); // 세차금액
	String inclean_pay = request.getParameter("inclean_pay")==null?"":request.getParameter("inclean_pay"); // 실내크리닝비
	int park_seq = request.getParameter("park_seq")==null?0:Util.parseInt(request.getParameter("park_seq"));
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st");
	String wash_etc = request.getParameter("wash_etc")==null?"":request.getParameter("wash_etc");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	SimpleDateFormat form = new SimpleDateFormat ( "yyyy-MM-dd HH:mm");
	Date time = new Date();
	String timeform = form.format(time);
	String d_user_nm= "";
	String d_user_tel= "";
	String at_cont= "";
	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(reg_id);
	
	
	int count = 0;
	ParkIODatabase piod = ParkIODatabase.getInstance();
	
	/* 메세지 변수 정의  */
	String wash_gubun = "세차";
	String req_dt =  timeform ;
	String request_nm = user_bean.getUser_nm();
	String phone_num = user_bean.getUser_m_tel();
	if(wash_etc.equals("")){
		wash_etc = " 없음 ";
	}			
	String send_tel = "02-392-4242";
		 
	List<String> fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );

	if(wash_pay.equals("0") && inclean_pay.equals("")){
		
		wash_gubun = "세차";
		fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
		
		//작업지시서 등록시 김태천씨에게 전송
		d_user_nm 	= "김태천";		// 당사자 성명
		d_user_tel 	= "010-3383-5843";	// 당사자연락처
		//d_user_tel 	= "010-9497-6266";	// 당사자연락처
		
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
	 	
		//작업지시서 등록시  이현우담장자에게 전송
		d_user_nm 	= "이현우";		// 당사자 성명
		d_user_tel 	= "010-4503-2121";	// 당사자연락처
		
		//알림톡 acar0211 대여개시안내
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
		//작업지시서 등록시 박시방씨에게 친구톡 전송
		d_user_nm 	= "박시방";		// 당사자 성명
		d_user_tel 	= "010-5838-6899";	// 당사자연락처
		
		//알림톡 acar0211 대여개시안내
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
			
		
	}else if(wash_pay.equals("") && inclean_pay.equals("0")){
		
		wash_gubun = "실내크리닝 및 냄새 제거만";
		fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
		
		//작업지시서 등록시 김태천씨에게 전송
		d_user_nm 	= "김태천";		// 당사자 성명
		d_user_tel 	= "010-3383-5843";	// 당사자연락처
		//d_user_tel 	= "010-9497-6266";	// 당사자연락처
		
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
	 	
		//작업지시서 등록시  이현우담장자에게 전송
		d_user_nm 	= "이현우";		// 당사자 성명
		d_user_tel 	= "010-4503-2121";	// 당사자연락처
		
		//알림톡 acar0211 대여개시안내
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
		//작업지시서 등록시 박시방씨에게 친구톡 전송
		d_user_nm 	= "박시방";		// 당사자 성명
		d_user_tel 	= "010-5838-6899";	// 당사자연락처
		
		//알림톡 acar0211 대여개시안내
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
	}else if(wash_pay.equals("0") && inclean_pay.equals("0")){
		
		
		wash_gubun = "실내크리닝 및 냄새 제거와\n세차";
		fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
		
		//작업지시서 등록시 김태천씨에게 전송
		d_user_nm 	= "김태천";		// 당사자 성명
		d_user_tel 	= "010-3383-5843";	// 당사자연락처
		//d_user_tel 	= "010-9497-6266";	// 당사자연락처
		
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
	 	
		//작업지시서 등록시  이현우담장자에게 전송
		d_user_nm 	= "이현우";		// 당사자 성명
		d_user_tel 	= "010-4503-2121";	// 당사자연락처
		
		//알림톡 acar0211 대여개시안내
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
		//작업지시서 등록시 박시방씨에게 친구톡 전송
		d_user_nm 	= "박시방";		// 당사자 성명
		d_user_tel 	= "010-5838-6899";	// 당사자연락처
		
		//알림톡 acar0211 대여개시안내
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
	}
	
	count = piod.updateParkWashGubun(park_seq, wash_pay, inclean_pay, gubun_st);
			

%>
<html>
<head>
<title>FMS</title>
</head>
<script>
var fm = document.form1;
 <%	if(count==1){ %>

		<% 	if (park_seq==0) { %>
					alert("정상적으로 등록되었습니다.");
		<% 	} else { %>
					alert("정상적으로 수정되었습니다.");
		<% 	} %>
		parent.window.close();
		parent.opener.location.reload();
		
<%}else{%>
		alert('에러가 발생하였습니다. 관리자에게 문의해 주세요.');
		parent.window.document.getElementById("loader").style.visibility="hidden";
<%}%> 

</script>
</body>
</html>
