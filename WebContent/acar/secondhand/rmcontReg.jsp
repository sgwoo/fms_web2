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
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String reg_dt 		= request.getParameter("shres_reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("shres_reg_dt"));
	String seq 		= request.getParameter("shres_seq")==null?"":request.getParameter("shres_seq");	
	String cust_nm 		= request.getParameter("shres_cust_nm")==null?"":request.getParameter("shres_cust_nm");	
	String cust_tel 	= request.getParameter("shres_cust_tel")==null?"":request.getParameter("shres_cust_tel");		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String ret_dt 		= request.getParameter("ret_dt")==null?"":AddUtil.ChangeString(request.getParameter("ret_dt"));
	String car_name		= request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String sms_msg		= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");
	String sms_msg2		= request.getParameter("sms_msg2")==null?"":request.getParameter("sms_msg2");
	
	int result = 0;
	boolean flag5 = true;

	
	//월렌트계약연동
	String  d_flag1 =  shDb.call_sp_sh_res_rm_cont_reg(car_mng_id, seq);
	
	
	
	if(damdang_id.equals("")) damdang_id = user_id;
	
	UsersBean sender_bean 	= umd.getUsersBean(damdang_id);
	
	UsersBean target_bean 	= new UsersBean();
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	shBn = shDb.getShRes(car_mng_id, seq); //계약 확정일 가져오기
	
	cust_nm 	= shBn.getCust_nm();
	cust_tel 	= shBn.getCust_tel();
					
	
		//계약확정시 고객에게 문자발송
		if(!cust_nm.equals("") && !cust_tel.equals("") && AddUtil.lengthb(cust_tel) > 9){
				
				// jjlim add alimtalk
				// acar0039 월렌트 계약확정 안내
				String customer_name = cust_nm;								// 고객이름
				String car_num = cr_bean.getCar_no();						// 차량번호
				String car_take_date_mn = "";								// 인수날짜 (월/일)
				String end_date = shBn.getRes_end_dt();				
				String etc1 = "";
				String etc2 = ck_acar_id;
				if (!end_date.equals("") && end_date != null) {
					int month = Integer.parseInt(end_date.substring(4,6));
					int day = Integer.parseInt(end_date.substring(6,8));
					car_take_date_mn = month + "월 " + day + "일";
				} else {
					car_take_date_mn = "영업일 기준 익일";
				}
				String manager_name = sender_bean.getUser_nm();				// 담당자 이름
				String manager_phone = sender_bean.getUser_m_tel();			// 담당자 전화
				if(!sender_bean.getHot_tel().equals("")){
					manager_phone = sender_bean.getHot_tel();
				}
				String contract_supp = sms_msg;						// 계약 준비물
				String visit_place = "";									// 방문 장소
				String visit_place_url = "";
				// 약도
				if(sms_msg2.equals("seoul1")){
					visit_place = "서울시 양천구 목동 914-5 한마음 공영 주차장(서문출입구 직전 20m)\n TEL: 02-6263-6378";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/yd.jpg");
	
				}else if(sms_msg2.equals("seoul")){
					visit_place = "서울시 영등포구 영등포로 34길 9 영등포 영남주차장\n TEL: 02-6263-6378";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg");
	
				}else if(sms_msg2.equals("busan1")){
					visit_place = "부산시 연제구 반송로 69 부산지점 하이트빌딩 3층\n TEL: 051-851-0606";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_p_hite.jpg");
	
				}else if(sms_msg2.equals("busan2")){
					visit_place = "부산시 연제구 거제천로 230번길 70 지하1층 (연산동,웰메이드오피스텔)웰메이드주차장 \n TEL: 051-851-0606";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_p_wellmade.jpg");
	
				}else if(sms_msg2.equals("daejeon1")){
					visit_place = "대전시 대덕구 신탄진로 319 금호자동차공업사 2층\n TEL: 042-824-1770";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_dj_kh.jpg");
	
				}else if(sms_msg2.equals("daejeon2")){
					visit_place = "대전시 대덕구 벚꽃길 100 (주)현대카독크 2층\n TEL: 042-824-1770";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg");
	
				}else if(sms_msg2.equals("daegu")){
					visit_place = "대구시 달서구 달서대로109길 58 (주)성서현대정비센터\n TEL: 053-582-2998";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg");
	
				}else if(sms_msg2.equals("kwangju")){
					visit_place = "광주시 서구 상무누리로 131-1 상무1급자동차공업사\n TEL: 062-385-0133";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg");
				}
				//acar0039->acar0077->acar0201->acar0255
				List<String> fieldList = Arrays.asList(customer_name, car_num, car_take_date_mn, manager_name, manager_phone, contract_supp, visit_place, visit_place_url);
				at_db.sendMessageReserve("acar0255", fieldList, cust_tel,  manager_phone, null , etc1,  etc2);
		
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

<%if(d_flag1.equals("0")){%>
	alert("등록되었습니다.");
	parent.location.reload();
<%	}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%	}%>
//-->
</script>
</body>
</html>
