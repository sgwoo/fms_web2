<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*, acar.res_search.*, tax.*" %>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*, acar.fee.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn"  class="acar.secondhand.ShResBean" scope="page"/>
<jsp:useBean id="rs_db" class="acar.res_search.ResSearchDatabase" scope="page"/>
<jsp:useBean id="cm_db" class="acar.coolmsg.CoolMsgDatabase" scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>

<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	CarRegDatabase 	crd = CarRegDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 				= request.getParameter("seq")==null?"":request.getParameter("seq");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String situation 		= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 			= request.getParameter("memo")==null?"":request.getParameter("memo");	
	String ret_dt 			= request.getParameter("ret_dt")==null?"":AddUtil.ChangeString(request.getParameter("ret_dt"));	
	String reg_dt 			= request.getParameter("reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("reg_dt"));	
	String gubun 			= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String sr_size 			= request.getParameter("sr_size")==null?"":request.getParameter("sr_size");
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");	
	String cust_tel 		= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String sms_add 		= request.getParameter("sms_add")==null?"":request.getParameter("sms_add");
	String sms_msg 		= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");   //계약 준비물  
	String reg_code		= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String sms_add2 		= request.getParameter("sms_add2")==null?"":request.getParameter("sms_add2");
	String sms_msg2 	= request.getParameter("sms_msg2")==null?"":request.getParameter("sms_msg2");
	String o_situation	= situation;
	String carName 		= request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String prevEstId		= request.getParameter("prevEstId")==null?"":request.getParameter("prevEstId");
	
	int result = 0;
	
	ShResBean srBn_chk = shDb.getShRes3(car_mng_id);	//상담중 조회
	
	UsersBean sender_bean = umd.getUsersBean(damdang_id);
	String send_phone = sender_bean.getHot_tel();
	
	if (!sender_bean.getLoan_st().equals("")) {
		send_phone = sender_bean.getUser_m_tel();
	}
	
	cr_bean = crd.getCarRegBean(car_mng_id);	
	
	//차고지 설정 
	String parking_addr = ""; //주차장 위치
	String parking_map = ""; //지도
	
	String etc1 ="";
	String etc2 = ck_acar_id;
	
	if (sms_msg2.equals("목동주차장")) {
		parking_addr = "서울특별시 양천구 목동 914-5 한마음 공영 주차장(서문출입구 직전 20m)\n TEL : 02-6263-6378";
	  	parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/yd.jpg";
	} else if (sms_msg2.equals("영등포주차장")) {
		parking_addr = "서울시 영등포구 영등포로 34길 9 영등포 영남주차장\n TEL : 02-6263-6378";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg";
	} else if (sms_msg2.equals("부산주차장1")) {
    	parking_addr = "부산시 연제구 반송로 69 부산지점 하이트빌딩 3층\n TEL : 051-851-0606";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_hite.jpg";
	} else if (sms_msg2.equals("부산주차장2")) {
    	parking_addr = "부산시 연제구 거제천로 230번길 70 지하1층 (연산동,웰메이드오피스텔)웰메이드주차장 \n TEL : 051-851-0606";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_wellmade.jpg";
	} else if (sms_msg2.equals("대전주차장1")) {
		parking_addr = "대전시 대덕구 신탄진로 319 금호자동차공업사 2층\n TEL : 042-824-1770";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_kh.jpg";
	} else if (sms_msg2.equals("대전주차장2")) {
		parking_addr = "대전시 대덕구 벚꽃길 100 (주)현대카독크 2층\n TEL : 042-824-1770";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg";				    
	} else if (sms_msg2.equals("대구주차장")) {
    	parking_addr = "대구시 달서구 달서대로109길 58 (주)성서현대정비센터\n TEL : 053-582-2998";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg";
	} else if (sms_msg2.equals("광주주차장")) {
    	parking_addr = "광주시 서구 상무누리로 131-1 상무1급자동차공업사\n TEL : 062-385-0133";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg";
	}

	String a_gubun1 = "재리스";										// 구분	
	String customer_name = cust_nm;								// 고객이름
	String car_num = cr_bean.getCar_no();						// 차량번호
	String manager_name = sender_bean.getUser_nm();	// 담당자 이름
	String manager_phone = send_phone;						// 담당자 전화
	String visit_place = parking_addr;								// 방문 장소
	String visit_place_url = "";										// 약도
	
	if (!parking_map.equals("")) {
		visit_place_url = ShortenUrlGoogle.getShortenUrl(parking_map); // 약도
	}
	
	if (from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")) {
		a_gubun1 = "월렌트";
	}

	if (gubun.equals("sms")) {
		//계약확정시 고객에게 문자발송
		if ((!sms_msg.equals("") || !sms_msg2.equals("")) && !cust_nm.equals("") && !cust_tel.equals("") && AddUtil.lengthb(cust_tel) > 9) {
		
			if (!sms_msg2.equals("")) {
				if (sms_msg.equals("")) {
					List<String> fieldList = Arrays.asList(customer_name, a_gubun1, car_num, manager_name, manager_phone, visit_place, visit_place_url);
					at_db.sendMessageReserve("acar0225", fieldList, cust_tel, manager_phone, null, etc1, etc2);
				} else {
					//acar0034->acar0075->acar0205->acar0256
					List<String> fieldList = Arrays.asList(customer_name, manager_name, manager_phone, sms_msg, visit_place, visit_place_url);
					at_db.sendMessageReserve("acar0256", fieldList, cust_tel, manager_phone, null, etc1, etc2);
				}
			} else {
				//acar0066 재리스/월렌트 계약확정 안내
				List<String> fieldList = Arrays.asList(a_gubun1, customer_name, car_num, manager_name, manager_phone);
				at_db.sendMessageReserve("acar0066", fieldList, cust_tel, manager_phone, null, etc1, etc2);
			}
		}
	
	} else {
		  	
		//등록처리할때 이미 등록된것이 있다면 상담중으로 처리
		if (o_situation.equals("2") && srBn_chk.getSituation().equals("2")) {
			situation = "0";
		}

	  	//차종 변경인 경우
		if (!prevEstId.equals("") && prevEstId != null) {
		    String estId = Long.toString(System.currentTimeMillis());
		    int count = shDb.insertExistCustomerInfo(prevEstId, cust_nm, cust_tel, estId, carName); //prevEstId 로 고객 정보를 찾아 esti_spe 에 넣어준다
		    int flag = shDb.insertSecondhandEstiInfo(estId, cust_nm, cust_tel, reg_code, car_mng_id);
		    int driverInsResult = shDb.insertExistDriverInfo(prevEstId,estId);
		    shBn.setEst_id(estId);
		    shBn.setReg_code(estId+"1");
		}
	  	
		shBn.setCar_mng_id(car_mng_id);
		shBn.setSeq(seq);
		shBn.setDamdang_id(damdang_id);
		shBn.setSituation(situation);
		shBn.setMemo(memo);
		shBn.setReg_dt(reg_dt);
		shBn.setCust_nm(cust_nm);
		shBn.setCust_tel(cust_tel);
	
		if (gubun.equals("i")) {
			result = shDb.shRes_i(shBn);
		} else if (gubun.equals("u")) {
			result = shDb.shRes_u(shBn);
		}
	
		//예약상태
		ShResBean srBn2 = shDb.getShRes(car_mng_id, damdang_id, reg_dt);
		
		//계약확정
		if (situation.equals("2")) {
			
			if (AddUtil.parseInt(AddUtil.replace(reg_dt, "-", "")) > AddUtil.parseInt(AddUtil.replace(ret_dt, "-", ""))) {
				ret_dt = "";
			}
			
			//계약확정시 고객에게 문자발송
			if (!cust_nm.equals("") && !cust_tel.equals("") && AddUtil.lengthb(cust_tel) > 9) {
				//차량정보
				String car_info = cr_bean.getCar_no()+"("+cr_bean.getCar_nm()+")";
								
				//예약기간 시작일
				String res_start_date = AddUtil.ChangeDate2(srBn2.getReg_dt()); //날짜포맷 변경
				String res_start_day = AddUtil.getDateDay(srBn2.getReg_dt()); //날짜요일 리턴
				
				if (!ret_dt.equals("")) {
					srBn2.setReg_dt(ret_dt);
				}
				
				//1영업일+
				String res_end_dt_1 = af_db.getValidDt(c_db.addDay(srBn2.getReg_dt(), 1));
				//2영업일+
				String res_end_dt_2 = af_db.getValidDt(c_db.addDay(res_end_dt_1, 1));
				
				
				//예약기간 종료일
				String res_end_date = AddUtil.ChangeDate2(res_end_dt_2); //날짜포맷 변경
				String res_end_day = AddUtil.getDateDay(res_end_dt_2); //날짜요일 리턴

				//시작일과 종료일을 포함한 예약확정 유효기간
				String expiry_date = res_start_date+"("+res_start_day+")"+"~"+res_end_date+"("+res_end_day+") 16:00까지";
				
				if (!sms_msg2.equals("")) {
					if (sms_msg.equals("")) {
						if (a_gubun1.equals("재리스")) {
							//재리스는 예약확정 유효기간추가로 신규템플릿 사용(방문장소 포함O)
							List<String> fieldList = Arrays.asList(customer_name, car_info, expiry_date, manager_name, manager_phone, visit_place, visit_place_url);
							at_db.sendMessageReserve("acar0226", fieldList, cust_tel, manager_phone, null, etc1, etc2);
						} else {							
							//acar0199 -> acar0225 재리스/월렌트 구분 추가
							List<String> fieldList = Arrays.asList(customer_name, a_gubun1, car_num, manager_name, manager_phone, visit_place, visit_place_url);
							at_db.sendMessageReserve("acar0225", fieldList, cust_tel, manager_phone, null, etc1, etc2);
						}
					} else {
						//acar0066 재리스/월렌트 계약확정 안내 -> 재리스는 acar0224로 변경(방문장소 포함X)
						if (a_gubun1.equals("재리스")) {
							List<String> fieldList = Arrays.asList(customer_name, car_info, expiry_date, manager_name, manager_phone);
							at_db.sendMessageReserve("acar0224", fieldList, cust_tel, manager_phone, null, etc1, etc2);
						} else {
							List<String> fieldList = Arrays.asList(a_gubun1, customer_name, car_num, manager_name, manager_phone);
							at_db.sendMessageReserve("acar0066", fieldList, cust_tel, manager_phone, null, etc1, etc2);
						}
						//acar0034->acar0075->acar0205->acar0256
						List<String> fieldList2 = Arrays.asList(customer_name, manager_name, manager_phone, sms_msg, visit_place, visit_place_url);
						at_db.sendMessageReserve("acar0256", fieldList2, cust_tel, manager_phone, null, etc1, etc2);
					}
				} else {
					//acar0066 재리스/월렌트 계약확정 안내 -> 재리스는 acar0224로 변경
					if (a_gubun1.equals("재리스")) {
						List<String> fieldList = Arrays.asList(customer_name, car_info, expiry_date, manager_name, manager_phone);
						at_db.sendMessageReserve("acar0224", fieldList, cust_tel, manager_phone, null, etc1, etc2);
					} else {
						List<String> fieldList = Arrays.asList(a_gubun1, customer_name, car_num, manager_name, manager_phone);
						at_db.sendMessageReserve("acar0066", fieldList, cust_tel, manager_phone, null, etc1, etc2);
					}
				}
			}
		}		
		
		if (ret_dt.equals("")) {
			ret_dt = srBn2.getReg_dt();
		}
		
		String d_flag1 = shDb.call_sp_sh_res_dire_dtset("i", car_mng_id, srBn2.getSeq(), ret_dt);

		//계약확정일 경우 예약시스템 장기대기로 자동등록 및 의 경우 매각담당자에게 메시지 통보
		if (gubun.equals("i") && situation.equals("2")) {
			//기존 장기대기가 있으면 취소처리
			//예약현황
			Vector conts = rs_db.getResCarList(car_mng_id);
			int cont_size = conts.size();

			for (int i = 0 ; i < cont_size ; i++) {
				Hashtable reservs = (Hashtable)conts.elementAt(i);
				if (String.valueOf(reservs.get("RENT_ST")).equals("장기대기")) {	//String.valueOf(reservs.get("USE_ST")).equals("예약") &&
					//단기대여관리 수정
					RentContBean rc_bean = rs_db.getRentContCase(String.valueOf(reservs.get("RENT_S_CD")), car_mng_id);
					rc_bean.setUse_st("5");
					int count = rs_db.updateRentCont(rc_bean);
				}
			}

			//단기대여관리 등록
			RentContBean rc_bean = new RentContBean();
			rc_bean.setCar_mng_id(car_mng_id);
			rc_bean.setRent_st("11");
			rc_bean.setRent_dt(reg_dt);
			rc_bean.setBrch_id(sender_bean.getBr_id());
			rc_bean.setBus_id(damdang_id);
			rc_bean.setRent_start_dt	(reg_dt+"0000");
			rc_bean.setEtc("재리스결정차량 계약확정 자동예약, "+cust_nm+" "+cust_tel+" "+memo);
			rc_bean.setDeli_plan_dt(reg_dt+"0000");
			rc_bean.setUse_st("1");
			rc_bean.setReg_id(damdang_id);
			rc_bean = rs_db.insertRentCont(rc_bean);

			if (cr_bean.getOff_ls().equals("1")) {
		
				//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		
				boolean flag3 = true;
				String sub = "매각결정차량 계약확정 통보";
				String cont = "매각결정차량이 계약확정이 되었습니다.  &lt;br&gt; &lt;br&gt; "+cr_bean.getCar_no()+", "+rc_bean.getEtc();
				String target_id = nm_db.getWorkAuthUser("출고관리자");
		
				CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		
				if (!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")) {
					target_id = cs_bean.getWork_id();
				}
				
				if (!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")) {
					target_id = nm_db.getWorkAuthUser("고소장담당");
				}
		
				//사용자 정보 조회
				UsersBean target_bean = umd.getUsersBean(target_id);
			
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
 					"    <URL></URL>";
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
		
				flag3 = cm_db.insertCoolMsg(msg);
				System.out.println("쿨메신저[재리스결정차량 : 매각결정차량 계약확정 통보 ] "+cr_bean.getCar_no()+"-----------------------"+target_bean.getUser_nm());			
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
<%
	if (result >= 1) {
		if (gubun.equals("i")) {%>
			alert("등록되었습니다.");
			<%if (o_situation.equals("2") && srBn_chk.getSituation().equals("2")) {%>
			alert("계약확정으로 등록된 건이 있어 상담중으로 등록합니다.");
			<%}%>
	<%} else if (gubun.equals("u")) {%>
			alert("수정되었습니다.");
	<%}%>
			parent.opener.location.reload();
			parent.window.close();
<%} else {%>
	<%if (gubun.equals("sms")) {%>
			alert("처리되었습니다.");
			window.close();
	<%} else {%>
			alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
			window.close();
	<%}%>
<%}%>
//-->
</script>
</body>
</html>