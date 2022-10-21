<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.res_search.*, tax.*" %>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.car_register.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn"  class="acar.secondhand.ShResBean" scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd 	= UserMngDatabase.getInstance();	
	CarRegDatabase 	crd 	= CarRegDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();

	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");	
	String ret_dt 		= request.getParameter("ret_dt")==null?"":AddUtil.ChangeString(request.getParameter("ret_dt"));	
	String reg_dt 		= request.getParameter("reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("reg_dt"));	
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String sr_size 		= request.getParameter("sr_size")==null?"":request.getParameter("sr_size");
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");	
	String cust_tel 	= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");	
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String cust_sms_yn 	= request.getParameter("cust_sms_yn")==null?"":request.getParameter("cust_sms_yn");	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cust_sms_y 	= request.getParameter("cust_sms_y")==null?"":request.getParameter("cust_sms_y");	
	String o_situation	= situation;
	String sms_msg 			= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");
	String sms_msg2 			= request.getParameter("sms_msg2")==null?"":request.getParameter("sms_msg2");
	
	int result = 0;
		
	shBn.setCar_mng_id	(car_mng_id);
	shBn.setSeq		(seq);
	shBn.setMemo		(memo);
	shBn.setCust_nm		(cust_nm);
	shBn.setCust_tel	(cust_tel);
			
	result = shDb.shRes_u_M(shBn);
	
	
	UsersBean sender_bean 	= umd.getUsersBean(damdang_id);
	String send_phone = sender_bean.getHot_tel();			
	if(!sender_bean.getLoan_st().equals("")){send_phone = sender_bean.getUser_m_tel();}				
	cr_bean = crd.getCarRegBean(car_mng_id);	

	//차고지 설정 
	String parking_addr = ""; //주차장 위치
	String parking_map = ""; //지도
				
	String etc1 ="";
	String etc2 = ck_acar_id ;
					
	if(sms_msg2.equals("목동주차장")){
	  parking_addr = "서울특별시 양천구 목동 914-5 한마음 공영 주차장(서문출입구 직전 20m)\n TEL : 02-6263-6378";
	  parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/yd.jpg";
	}else if(sms_msg2.equals("영등포주차장")){
		parking_addr = "서울시 영등포구 영등포로 34길 9 영등포 영남주차장\n TEL : 02-6263-6378";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg";
	}else if(sms_msg2.equals("부산주차장1")){
	  parking_addr = "부산시 연제구 반송로 69 부산지점 하이트빌딩 3층\n TEL : 051-851-0606";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_hite.jpg";
	}else if(sms_msg2.equals("부산주차장2")){
	  parking_addr = "부산시 연제구 거제천로 230번길 70 지하1층 (연산동,웰메이드오피스텔)웰메이드주차장 \n TEL : 051-851-0606";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_wellmade.jpg";
	}else if(sms_msg2.equals("대전주차장1")){
		parking_addr = "대전시 대덕구 신탄진로 319 금호자동차공업사 2층\n TEL : 042-824-1770";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_kh.jpg";
	}else if(sms_msg2.equals("대전주차장2")){
		parking_addr = "대전시 대덕구 벚꽃길 100 (주)현대카독크 2층\n TEL : 042-824-1770";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg";				    
	}else if(sms_msg2.equals("대구주차장")){
    parking_addr = "대구시 달서구 달서대로109길 58 (주)성서현대정비센터\n TEL : 053-582-2998";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg";
	}else if(sms_msg2.equals("광주주차장")){
    parking_addr = "광주시 서구 상무누리로 131-1 상무1급자동차공업사\n TEL : 062-385-0133";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg";
	}
	
	shBn = shDb.getShRes(car_mng_id, seq); //계약 확정일 가져오기
	
	if(situation.equals("2") && (cust_sms_yn.equals("Y")|| cust_sms_y.equals("YM")|| cust_sms_y.equals("YS")) ){//계약확정
		//계약확정시 고객에게 문자발송
		if(!cust_nm.equals("") && !cust_tel.equals("") && AddUtil.lengthb(cust_tel) > 9){
			String a_gubun1 = "재리스";													// 구분	
			String customer_name = cust_nm;										// 고객이름
			String car_num = cr_bean.getCar_no();							// 차량번호
			String manager_name = sender_bean.getUser_nm();		// 담당자 이름
			String manager_phone = send_phone;								// 담당자 전화
			String visit_place = parking_addr;								// 방문 장소
			String visit_place_url = ""; // 약도
			if(!parking_map.equals("")){
				visit_place_url = ShortenUrlGoogle.getShortenUrl(parking_map); // 약도
			}
	
			if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){
				a_gubun1 = "월렌트";
			}
			
			if(!sms_msg2.equals("")){
				if(sms_msg.equals("")){
					List<String> fieldList = Arrays.asList(customer_name, car_num, manager_name, manager_phone, visit_place, visit_place_url);
					at_db.sendMessageReserve("acar0199", fieldList, cust_tel, manager_phone, null,  etc1, etc2 );
				}else{
					//acar0034->acar0075->acar0205->acar0256
					List<String> fieldList = Arrays.asList(customer_name, manager_name, manager_phone, sms_msg, visit_place, visit_place_url);
					at_db.sendMessageReserve("acar0256", fieldList, cust_tel, manager_phone, null,  etc1, etc2 );
				}
			}else{
				// acar0066 재리스/월렌트 계약확정 안내
				// 재리스는 acar0224 예약기간추가로 해당 템플릿 사용
				if (a_gubun1.equals("재리스")) {
					//차량정보
					String car_info = cr_bean.getCar_no()+"("+cr_bean.getCar_nm()+")";
					//예약기간 시작일
					String res_start_dt = AddUtil.ChangeDate2(shBn.getRes_st_dt()); //날짜포맷 변경
					String res_start_day = AddUtil.getDateDay(shBn.getRes_st_dt()); //날짜요일 리턴
					//예약기간 종료일
					String res_end_dt = AddUtil.ChangeDate2(shBn.getRes_end_dt()); //날짜포맷 변경
					String res_end_day = AddUtil.getDateDay(shBn.getRes_end_dt()); //날짜요일 리턴
					//날짜
					String expiry_date = res_start_dt+"("+res_start_day+")"+"~"+res_end_dt+"("+res_end_day+") 16:00까지";
					
					List<String> fieldList = Arrays.asList(customer_name, car_info, expiry_date, manager_name, manager_phone);
					at_db.sendMessageReserve("acar0224", fieldList, manager_phone, manager_phone, null,  etc1, etc2);
				} else {					
					List<String> fieldList = Arrays.asList(a_gubun1, customer_name, car_num, manager_name, manager_phone);
					at_db.sendMessageReserve("acar0066", fieldList, cust_tel, manager_phone, null,  etc1, etc2 );
				}
			}
		}
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--

<%	if(result >= 1){%>		
		alert("수정되었습니다.");
		parent.opener.location.reload();
		parent.window.close();	
<%	}else{%>
		alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
		window.close();				
<%	}%>
//-->
</script>
</body>
</html>
