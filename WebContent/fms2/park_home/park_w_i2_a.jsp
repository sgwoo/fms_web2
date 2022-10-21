<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,java.text.*, acar.user_mng.*, acar.parking.*, acar.cus_reg.*, acar.car_service.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="pbean" scope="page" class="acar.parking.ParkBean"/> 
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>	
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");

	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");  // 계약관리번호
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");  // 계약관리번호
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");  // 차량관리번호
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st"); // 대여차량구분
	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no"); // 차량번호
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm"); // 차명
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id"); // 대여차량구분
	String users_comp = request.getParameter("users_comp")==null?"":request.getParameter("users_comp"); // 담당자
	String user_m_tel = request.getParameter("user_m_tel")==null?"":request.getParameter("user_m_tel"); // 담당자
		
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id"); // 주차장
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng"); // 등록자
	String wash_dt = request.getParameter("wash_dt")==null?"":request.getParameter("wash_dt"); // 세차일시
	String wash_pay = request.getParameter("wash_pay")==null?"":request.getParameter("wash_pay"); // 세차가격
	String inclean_pay = request.getParameter("inclean_pay")==null?"":request.getParameter("inclean_pay"); //  실내가격
	String wash_etc = request.getParameter("wash_etc")==null?"":request.getParameter("wash_etc"); // 세차일시
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st"); // 세차일시
	//System.out.println("wash_pay>>>>" + wash_pay);
	int park_seq = request.getParameter("park_seq")==null?0:Util.parseInt(request.getParameter("park_seq"));
		
	String[] req_check = request.getParameterValues("req_check");  // checkbox 값
	String del = request.getParameter("del")==null?"":request.getParameter("del"); // 삭제 구분 파라미터
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String start_h = request.getParameter("start_h")==null?"":request.getParameter("start_h");
	String start_m = request.getParameter("start_m")==null?"":request.getParameter("start_m");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String reason = request.getParameter("reason")==null?"":request.getParameter("reason");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	SimpleDateFormat form = new SimpleDateFormat ( "yyyy-MM-dd HH:mm");
	Date time = new Date();
	String wash_start = form.format(time);
	String wash_end = form.format(time);
	String d_user_nm= "";
	String d_user_tel= "";
	String at_cont= "";
	
	car_no = car_no.replace(" ","");
	
	int count = 0;
	ParkIODatabase piod = ParkIODatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	

	String d_dt = wash_end.replaceAll("-", "").substring(0, 8);
	Hashtable ht = piod.ConsignmentInfo(car_no, d_dt);
	String driver_nm = String.valueOf(ht.get("DRIVER_NM")); 
	String driver_m_tel = String.valueOf(ht.get("DRIVER_M_TEL")); 
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(reg_id);

	/* 메세지 변수 정의  */
	String wash_gubun = "세차";
	String request_nm = user_bean.getUser_nm();
	String phone_num = user_bean.getUser_m_tel();
	if(wash_etc.equals("")){
		wash_etc = " 없음 ";
	}			
	String send_tel = "02-392-4242";
	List<String> fieldList = Arrays.asList(wash_gubun, car_no, wash_start, wash_end,  request_nm, phone_num, wash_etc );
		 
	
	if (del.equals("del")) { // 삭제 
		int cnt = req_check.length;		
		for (int i=0; i < cnt; i++) {
			int pr_id = Integer.parseInt(req_check[i]);
			count = piod.deleteParkWash(pr_id);
			
		}
	} else {
		if (park_seq == 0) { // 등록
			count = piod.insertParkWash2(rent_mng_id, rent_l_cd, car_mng_id, car_st, car_no, car_nm, park_id, user_id, wash_etc, start_dt, start_h, start_m, gubun_st, mng_id, users_comp, user_m_tel, wash_pay, inclean_pay, reason);
			
			/*세차만 완료된 경우  */
			if(wash_pay.equals("10000") && inclean_pay.equals("")){
				
				wash_gubun = "세차";
				fieldList = Arrays.asList(wash_gubun, car_no, wash_start, wash_end,  request_nm, phone_num, wash_etc );
				
				//작업지시서 등록시 김태천씨에게 전송
				d_user_nm 	= "김태천";		// 당사자 성명
				d_user_tel 	= "010-3383-5843";	// 당사자연락처
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
			 	
				//작업지시서 등록시  이현우담장자에게 전송
				d_user_nm 	= "이현우";		// 당사자 성명
				d_user_tel 	= "010-4503-2121";	// 당사자연락처
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				//작업지시서 등록시 박시방씨에게 알림톡 전송
				d_user_nm 	= "박시방";		// 당사자 성명
				d_user_tel 	= "010-5838-6899";	// 당사자연락처
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				//작업지시서 등록 등록자에게 알림톡 전송
				d_user_nm 	= user_bean.getUser_nm();		// 당사자 성명
				d_user_tel 	= user_bean.getUser_m_tel();	// 당사자연락처
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				if(driver_m_tel != null && !driver_m_tel.equals("") && !driver_m_tel.equals("null")){
					//탁송 기사님에게 알림톡 전송
					d_user_nm 	= driver_nm;		// 당사자 성명
					d_user_tel 	= driver_m_tel;	// 당사자연락처
					at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				}
				
			/*실내크리닝만 완료된 경우  */	
			}else if(wash_pay.equals("") && inclean_pay.equals("20000")){
				
				
				wash_gubun = "실내크리닝 및 냄새 제거만";
				fieldList = Arrays.asList(wash_gubun, car_no, wash_start, wash_end,  request_nm, phone_num, wash_etc );
				
				//작업지시서 등록시 김태천씨에게 전송
				d_user_nm 	= "김태천";		// 당사자 성명
				d_user_tel 	= "010-3383-5843";	// 당사자연락처
				//d_user_tel 	= "010-9497-6266";	// 당사자연락처
				
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
			 	
				//작업지시서 등록시  이현우담장자에게 전송
				d_user_nm 	= "이현우";		// 당사자 성명
				d_user_tel 	= "010-4503-2121";	// 당사자연락처
				
				//알림톡 acar0211 대여개시안내
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				//작업지시서 등록시 박시방씨에게 친구톡 전송
				d_user_nm 	= "박시방";		// 당사자 성명
				d_user_tel 	= "010-5838-6899";	// 당사자연락처
				
				//알림톡 acar0211 대여개시안내
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				//작업지시서 등록시 등록자에게 알림톡 전송
				d_user_nm 	= user_bean.getUser_nm();		// 당사자 성명
				d_user_tel 	= user_bean.getUser_m_tel();	// 당사자연락처

				//System.out.println(d_user_nm +  " " + d_user_tel );
				
				//알림톡 acar0211 대여개시안내
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				if(driver_m_tel != null && !driver_m_tel.equals("") && !driver_m_tel.equals("null")){
					//탁송 기사님에게 알림톡 전송
					d_user_nm 	= driver_nm;		// 당사자 성명
					d_user_tel 	= driver_m_tel;	// 당사자연락처
					at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				}
				
				
			/*세차랑 실내크리닝 모두 완료된 경우  */		
			}else if(wash_pay.equals("10000") && inclean_pay.equals("20000")){
				
				
				wash_gubun = "실내크리닝 및 냄새 제거와\n세차";
				fieldList = Arrays.asList(wash_gubun, car_no, wash_start, wash_end,  request_nm, phone_num, wash_etc );
				
				//작업지시서 등록시 김태천씨에게 전송
				d_user_nm 	= "김태천";		// 당사자 성명
				d_user_tel 	= "010-3383-5843";	// 당사자연락처
				//d_user_tel 	= "010-9497-6266";	// 당사자연락처
				
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
			 	
				//작업지시서 등록시  이현우담장자에게 전송
				d_user_nm 	= "이현우";		// 당사자 성명
				d_user_tel 	= "010-4503-2121";	// 당사자연락처
				
				//알림톡 acar0211 대여개시안내
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				//작업지시서 등록시 박시방씨에게 친구톡 전송
				d_user_nm 	= "박시방";		// 당사자 성명
				d_user_tel 	= "010-5838-6899";	// 당사자연락처
				
				//알림톡 acar0211 대여개시안내
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				//작업지시서 등록시 등록자에게 알림톡 전송
				d_user_nm 	= user_bean.getUser_nm();		// 당사자 성명
				d_user_tel 	= user_bean.getUser_m_tel();	// 당사자연락처

			//	System.out.println(d_user_nm +  " " + d_user_tel );
				
				//알림톡 acar0211 대여개시안내
				at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				if(driver_m_tel != null && !driver_m_tel.equals("") && !driver_m_tel.equals("null")){
					//탁송 기사님에게 알림톡 전송
					d_user_nm 	= driver_nm;		// 당사자 성명
					d_user_tel 	= driver_m_tel;	// 당사자연락처
					at_db.sendMessageReserve("acar0241", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				}
			}
	
		
		} else { // 수정
			pbean = new ParkBean();
			pbean.setRent_mng_id(rent_mng_id);	
			pbean.setRent_l_cd(rent_l_cd);	
			pbean.setCar_mng_id(car_mng_id);	
			pbean.setCar_st(car_st);
			pbean.setCar_no(car_no);
			pbean.setCar_nm(car_nm);
			pbean.setUsers_comp(users_comp);
			pbean.setPark_id(park_id);
			pbean.setPark_mng(park_mng);
			pbean.setWash_dt(wash_dt);
			pbean.setPark_seq(park_seq);
			
			/* count = piod.updateParkWash(rent_mng_id, rent_l_cd, car_mng_id, car_st, car_no,
					car_nm, users_comp, park_id, park_mng, wash_dt, park_seq); */
			count = piod.updateParkWash(pbean); 
		}
	}

%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >

<form name='form1' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" 	value="<%=car_mng_id%>">
<input type="hidden" name="car_no" 	value="<%=car_no%>">
<input type="hidden" name="gubun1" 	value="<%=gubun1%>">
<input type="hidden" name="gubun2" 	value="<%=gubun2%>">
<input type="hidden" name="s_kd" 	value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="start_dt" value="<%=start_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="sort" value="<%=sort%>">
</form>
<script language='javascript'>
<!--
var fm = document.form1;
<%	if(count==1){ %>

	<% 	if (del.equals("del")) { %>
				alert("정상적으로 삭제되었습니다.");
				fm.action = "park_w_frame.jsp";
				fm.target = "d_content";
			    fm.submit();
	<% 	} else { %>
		<% 	if (park_seq==0) { %>
					alert("정상적으로 등록되었습니다.");
		<% 	} else { %>
					alert("정상적으로 수정되었습니다.");
		<% 	} %>
				parent.window.close();
				parent.opener.location.reload();
	<% 	} %>
		
<%}else{%>
		alert('에러가 발생하였습니다. 관리자에게 문의해 주세요.');
		parent.window.document.getElementById("loader").style.visibility="hidden";
<%}%>
//-->

</script>
</body>
</html>
