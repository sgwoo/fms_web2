<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, acar.cus_reg.*, acar.car_service.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="pbean" scope="page" class="acar.parking.ParkBean"/> 
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>	
<%@ include file="/agent/cookies.jsp" %>
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
	String user_m_tel = request.getParameter("user_m_tel")==null?"":request.getParameter("user_m_tel"); // 담당자 연락처
		
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id"); // 주차장
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng"); // 등록자
	String wash_dt = request.getParameter("wash_dt")==null?"":request.getParameter("wash_dt"); // 세차일시
	String wash_pay = request.getParameter("wash_pay")==null?"":request.getParameter("wash_pay"); // 세차금액
	String wash_etc = request.getParameter("wash_etc")==null?"":request.getParameter("wash_etc"); // 적요
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st"); // 진행현황
	String inclean_pay = request.getParameter("inclean_pay")==null?"":request.getParameter("inclean_pay"); // 실내크리닝비
	
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

	String own_type = request.getParameter("own_type")==null?"":request.getParameter("own_type");
	String scd_time_yn = request.getParameter("scd_time_yn")==null?"":request.getParameter("scd_time_yn");
	String scd_time = request.getParameter("scd_time")==null?"":request.getParameter("scd_time");
	
	int count = 0;
	int chk =0;
	ParkIODatabase piod = ParkIODatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	user_bean = umd.getUsersBean(user_id);

	
	String d_user_nm ="";	
	String d_user_tel ="";
	                  
	String at_cont   ="";
	
	String etc =  own_type ;
	
	if(scd_time_yn.equals("Y")){
		etc += ", "+ scd_time ;
	}
	
	if(!wash_etc.equals("")){
		etc += ", "+wash_etc;
	}
	
	String wash_st = "";
	String inclean_st = "";
	
	//나중에 세차와 실내크리닝에 대한 요청여부구분를 따로 저장
	if(wash_pay.equals("0")){
		wash_st ="1";
	}
	
	if(inclean_pay.equals("0")){
		inclean_st ="1";
		
	}
	 
	
	
	// 차량소유자, 출차예정일시, 적요를 합쳐서 다시 적요에 담기
	wash_etc = etc;
	
	
	//객체에 담기(등록) rent_mng_id, rent_l_cd, car_mng_id, car_st, 
	//				car_no, car_nm, park_id, user_id, wash_etc, start_dt, 
	//				start_h, start_m, gubun_st, 
	//				mng_id, users_comp, user_m_tel, wash_pay, inclean_pay
	
	// 수정 rent_mng_id, rent_l_cd, car_mng_id, car_st, car_no, car_nm, 
	//		users_comp, park_id, park_mng, wash_dt, park_seq
	pbean = new ParkBean();
	pbean.setRent_mng_id(rent_mng_id);	
	pbean.setRent_l_cd(rent_l_cd);	
	pbean.setCar_mng_id(car_mng_id);	
	pbean.setCar_st(car_st);
	pbean.setCar_no(car_no);
	pbean.setCar_nm(car_nm);
	pbean.setPark_id(park_id);
	pbean.setUser_id(user_id);
	pbean.setWash_etc(wash_etc);
	pbean.setStart_dt(start_dt);
	pbean.setStart_h(start_h);
	pbean.setStart_m(start_m);
	pbean.setGubun_st(gubun_st);
	pbean.setUsers_comp(users_comp);
	pbean.setUser_m_tel(user_m_tel);
	pbean.setWash_pay(wash_pay);
	pbean.setInclean_pay(inclean_pay);
	pbean.setWash_st(wash_st);
	pbean.setInclean_st(inclean_st);
	pbean.setPark_mng(park_mng);
	pbean.setWash_dt(wash_dt);
	pbean.setPark_seq(park_seq);
	
	/* 메세지 변수 정의  */
	String wash_gubun = "세차";
	String req_dt =  start_dt + " "+ start_h + ":" +  start_m ;
	String request_nm = user_bean.getUser_nm();
	String phone_num = user_bean.getUser_m_tel();
	
		
	String send_tel = "02-392-4242";
	
	List<String> fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
	
	
	if (del.equals("del")) { // 삭제
		
		int cnt = req_check.length;		
		for (int i=0; i < cnt; i++) {
			String[] reqArr = req_check[i].split("/",5);
			int pr_id = Integer.parseInt(reqArr[0]);
			wash_pay = reqArr[1];
			inclean_pay = reqArr[2];
			car_no = reqArr[3];
			gubun2 = reqArr[4];
			
			
			count = piod.deleteParkWash(pr_id);
			
			
			
			//세차만 등록한경우
			if(wash_pay.equals("0") && inclean_pay.equals("")){
				
				wash_gubun = "세차";
				fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
				
				//작업지시서 등록시 김태천씨에게 전송
				d_user_nm 	= "김태천";		// 당사자 성명
				d_user_tel 	= "010-3383-5843";	// 당사자연락처
				//d_user_tel 	= "010-9497-6266";	// 당사자연락처
				
				at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
			 	
				//작업지시서 등록시  이현우담장자에게 전송
				d_user_nm 	= "이현우";		// 당사자 성명
				d_user_tel 	= "010-4503-2121";	// 당사자연락처
				
				//알림톡 acar0211 대여개시안내
				at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				//작업지시서 등록시 박시방씨에게 친구톡 전송
				d_user_nm 	= "박시방";		// 당사자 성명
				d_user_tel 	= "010-5838-6899";	// 당사자연락처
				
				//알림톡 acar0211 대여개시안내
				at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				
			//실내크리닝 및 냄새 제거만 한경우
			}else if(wash_pay.equals("") && inclean_pay.equals("0") ){
				
				//이현우 / 박시방기사가 직접 등록한 경우
				if(user_id.equals("000297") || user_id.equals("000313")){
					
					wash_gubun = "실내크리닝 및 냄새 제거만";
					fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
					
					//작업지시서 등록시 김태천씨에게 전송
					d_user_nm 	= "김태천";		// 당사자 성명
					d_user_tel 	= "010-3383-5843";	// 당사자연락처
					//d_user_tel 	= "010-9497-6266";	// 당사자연락처
					
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				 	
					//작업지시서 등록시  이현우담장자에게 전송
					d_user_nm 	= "이현우";		// 당사자 성명
					d_user_tel 	= "010-4503-2121";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//작업지시서 등록시 박시방씨에게 친구톡 전송
					d_user_nm 	= "박시방";		// 당사자 성명
					d_user_tel 	= "010-5838-6899";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					

				//다른직원들이 요청했을 경우	
				}else{
					
					wash_gubun = "실내크리닝 및 냄새 제거만";
					fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
					
					
					if(!gubun2.equals("보류")){
						d_user_nm 	= "김태천";		// 당사자 성명
						d_user_tel 	= "010-3383-5843";	// 당사자연락처
						//d_user_tel 	= "010-9497-6266";	// 당사자연락처
						
						at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					}
					
					//작업지시서 등록시  이현우담장자에게 전송
					d_user_nm 	= "이현우";		// 당사자 성명
					d_user_tel 	= "010-4503-2121";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//작업지시서 등록시 박시방씨에게 친구톡 전송
					d_user_nm 	= "박시방";		// 당사자 성명
					d_user_tel 	= "010-5838-6899";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					
	
				}
			
			//세차와 실내 둘다 등록한경우	
			}else if(wash_pay.equals("0") && inclean_pay.equals("0") ){
			 
				//이현우 / 박시방기사가 직접 등록한 경우
				if(user_id.equals("000297") || user_id.equals("000313")){
				
					wash_gubun = "실내크리닝 및 냄새 제거와\n세차";
					fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
					
					//작업지시서 등록시 김태천씨에게 전송
					d_user_nm 	= "김태천";		// 당사자 성명
					d_user_tel 	= "010-3383-5843";	// 당사자연락처
					//d_user_tel 	= "010-9497-6266";	// 당사자연락처
					
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				 	
					//작업지시서 등록시  이현우담장자에게 전송
					d_user_nm 	= "이현우";		// 당사자 성명
					d_user_tel 	= "010-4503-2121";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//작업지시서 등록시 박시방씨에게 친구톡 전송
					d_user_nm 	= "박시방";		// 당사자 성명
					d_user_tel 	= "010-5838-6899";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
				//다른직원들이 요청했을 경우
				}else{
					
					gubun_st = "";
					wash_gubun = "실내크리닝 및 냄새 제거와\n세차";
					fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
					
					if(!gubun2.equals("보류")){
						d_user_nm 	= "김태천";		// 당사자 성명
						d_user_tel 	= "010-3383-5843";	// 당사자연락처
						//d_user_tel 	= "010-9497-6266";	// 당사자연락처
						
						at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					}
					
					
					//작업지시서 등록시  이현우담장자에게 전송
					d_user_nm 	= "이현우";		// 당사자 성명
					d_user_tel 	= "010-4503-2121";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//작업지시서 등록시 박시방씨에게 친구톡 전송
					d_user_nm 	= "박시방";		// 당사자 성명
					d_user_tel 	= "010-5838-6899";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
				}
			}
		}
	} else {
		if (park_seq == 0) { // 등록
			
			//세차만 등록한경우
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
				
				 
			
			//실내크리닝 및 냄새 제거만 한경우
			}else if(wash_pay.equals("") && inclean_pay.equals("0") ){
				
				//이현우 / 박시방기사가 직접 등록한 경우
				if(user_id.equals("000297") || user_id.equals("000313")){
					
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
					
					 
				//다른직원들이 요청했을 경우	
				}else{
					gubun_st = "";
					
					wash_gubun = "실내크리닝 및 냄새 제거만";
					fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
					
					//작업지시서 등록시  이현우담장자에게 전송
					d_user_nm 	= "이현우";		// 당사자 성명
					d_user_tel 	= "010-4503-2121";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0237", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//작업지시서 등록시 박시방씨에게 친구톡 전송
					d_user_nm 	= "박시방";		// 당사자 성명
					d_user_tel 	= "010-5838-6899";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0237", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
				}
			
			//세차와 실내 둘다 등록한경우	
			}else if(wash_pay.equals("0") && inclean_pay.equals("0") ){
			 
				//이현우 / 박시방기사가 직접 등록한 경우
				if(user_id.equals("000297") || user_id.equals("000313")){
					
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
					
					
				//다른직원들이 요청했을 경우
				}else{
					
					gubun_st = "";
					
					wash_gubun = "실내크리닝 및 냄새 제거와\n세차";
					fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
					
					//작업지시서 등록시  이현우담장자에게 전송
					d_user_nm 	= "이현우";		// 당사자 성명
					d_user_tel 	= "010-4503-2121";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0237", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//작업지시서 등록시 박시방씨에게 친구톡 전송
					d_user_nm 	= "박시방";		// 당사자 성명
					d_user_tel 	= "010-5838-6899";	// 당사자연락처
					
					//알림톡 acar0211 대여개시안내
					at_db.sendMessageReserve("acar0237", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
				}
				
			}
				
			chk = piod.chkParkWash(car_mng_id, start_dt);
			
			if(chk == 0){			
				count = piod.insertParkWash(pbean);
			}else{
				count =2;
			}
			
		} else { // 수정
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
<input type="hidden" name="user_id" value="<%=user_id%>">
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
<%}else if(count==2){%>
	alert('현재진행중인 차량이 있습니다.\n해당차량을 완료 또는 삭제 후 등록해주세요');
//	parent.window.document.getElementById("loader").style.visibility="hidden";
	
<%}else{%>
		alert('에러가 발생하였습니다. 관리자에게 문의해 주세요.');
	//	parent.window.document.getElementById("loader").style.visibility="hidden";
<%}%>
//-->

</script>
</body>
</html>
