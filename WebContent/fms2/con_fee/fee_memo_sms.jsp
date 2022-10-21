<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.cont.*, tax.*, acar.user_mng.*, acar.car_register.*, acar.car_mst.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 		= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	
	String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
	String sendphone	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
	String destphone	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String msg 			= request.getParameter("msg")==null?"":request.getParameter("msg");
	String msglen 		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String bond_msg_type 	= request.getParameter("bond_msg_type")==null?"":request.getParameter("bond_msg_type");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mng_send 	= request.getParameter("mng_send")==null?"":request.getParameter("mng_send");
	
	String customer_name 	= request.getParameter("customer_name")==null?"":request.getParameter("customer_name");
	String cur_date 	= request.getParameter("cur_date")==null?"":request.getParameter("cur_date");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String car_count 	= request.getParameter("car_count")==null?"0":request.getParameter("car_count");
	String car_num_name_count 	= request.getParameter("car_num_name_count")==null?"":request.getParameter("car_num_name_count");
	String short_url 	= request.getParameter("short_url")==null?"":request.getParameter("short_url");
	String unpaid 		= request.getParameter("unpaid")==null?"":request.getParameter("unpaid");
	String bank_full 	= request.getParameter("bank_full")==null?"":request.getParameter("bank_full");
	
	String manager_name 	= request.getParameter("manager_name")==null?"":request.getParameter("manager_name");
	String manager_phone 	= request.getParameter("manager_phone")==null?"":request.getParameter("manager_phone");
	
	String destphone_multi 	= request.getParameter("destphone_multi")==null?"":request.getParameter("destphone_multi");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));	
	
	Hashtable insur = a_db.getInsurOfCont(l_cd, m_id);
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	String url1 = "http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+r_st+"";
	String url2 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_accident.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
	
	if(destphone_multi.equals("")){
		destphone_multi = destphone;
	}
	
	if(!destphone_multi.equals("")){
		     	
	     	// jjlim add alimtalk				
			String insur_mng_name = String.valueOf(insur.get("USER_NM"));			// 사고처리 담당자  
			String insur_mng_pos =String.valueOf(insur.get("USER_POS"));			// 사고처리 담당자 직급 
			String insur_mng_phone =String.valueOf(insur.get("USER_M_TEL"));		// 사고처리 담당자 전화 
			String insurance_name = String.valueOf(insur.get("INS_COM_NM"));		// 사고처리 보험사
			String insurance_phone = String.valueOf(insur.get("INS_TEL"));			// 사고처리 보험사 전화
			
			UsersBean user_bean = umd.getUsersBean(String.valueOf(insur.get("MNG_ID")));
			UsersBean sener_user_bean = umd.getUsersBean(ck_acar_id);
			
			insur_mng_pos =user_bean.getUser_pos();		// 사고처리 담당자 직급 
			
			String etc1 = l_cd;
			String etc2 = ck_acar_id;
			String sos_service_info = "마스타자동차 (1588-6688)";												// 긴급출동
			String car_service_info = "스피드메이트 (https://www.speedmate.com/shop_search/shop_search.do)";	// 정비업체
			String marster_car_num = "1588-6688"; //마스터 자동차 연락처
			String sk_net_num = "1670-5494"; //sk네트웍스 연락처
			String sk_net_info = "sk네트웍스 (1670-5494)"; //sk네트웍스 연락처
			String insur_info_url = ShortenUrlGoogle.getShortenUrl(url1);
			String accident_url = ShortenUrlGoogle.getShortenUrl(url2);
			
			//수신번호 멀티
			int s=0; 
			String app_value[] = new String[20];	
			StringTokenizer st = new StringTokenizer(destphone_multi,"////");				
			while(st.hasMoreTokens()){
				app_value[s] = st.nextToken();
				out.println(app_value[s]);
				s++;				
			}	
			
			
			//발신자번호
			if (sendphone.equals("")) {
				sendphone = sener_user_bean.getUser_m_tel();
			}
			
				
			if ( msg_subject.equals("[아마존카 사고처리 안내]") ) {
				//acar0037 -> acar0090 (문구수정) -> acar0111 (애니카종료) -> acar0174 (sk네트웍스추가) -> acar0218 -> acar0233 문구 및 파라미터 순서변경
				List<String> fieldList = Arrays.asList(firm_nm, cr_bean.getCar_no(), insurance_name, insurance_phone, marster_car_num, sk_net_num, insur_mng_name, insur_mng_phone, accident_url);
				//고객
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];
					at_db.sendMessageReserve("acar0233", fieldList, destphone, sendphone, null , etc1,  etc2);		 
				}
				//담당자	
				for(int j=0 ; j < 1 ; j++){
					destphone = app_value[j];
					if (mng_send.equals("Y")) {
						List<String> fieldList2 = Arrays.asList(firm_nm+"("+destphone+")", cr_bean.getCar_no(), insurance_name, insurance_phone, marster_car_num, sk_net_num, insur_mng_name, insur_mng_phone, accident_url);
						if (  !sener_user_bean.getUser_m_tel().equals(user_bean.getUser_m_tel()) )	{
							at_db.sendMessageReserve("acar0233", fieldList2, user_bean.getUser_m_tel(), sener_user_bean.getUser_m_tel(), null , etc1,  etc2);				 	 
						}
					}
				}	
			}else if ( msg_subject.equals("[아마존카 보험접수 및 사고처리 안내]") ) {
				//acar0089
				List<String> fieldList = Arrays.asList(insurance_name, insurance_name, insurance_phone, insur_mng_name, insur_mng_pos, insur_mng_phone, firm_nm, cr_bean.getCar_no(), cm_bean.getCar_nm()+" "+cm_bean.getCar_name(), insur_info_url, sener_user_bean.getUser_nm(), sener_user_bean.getUser_pos(), sener_user_bean.getUser_m_tel());
				//고객
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];
					at_db.sendMessageReserve("acar0089", fieldList, destphone, sendphone , null , etc1,  etc2);			
				}	
				//담당자 
				for(int j=0 ; j < 1 ; j++){
					destphone = app_value[j];
					if (mng_send.equals("Y")) {
						List<String> fieldList2 = Arrays.asList(insurance_name, insurance_name, insurance_phone, insur_mng_name, insur_mng_pos, insur_mng_phone, firm_nm+"("+destphone+")", cr_bean.getCar_no(), cm_bean.getCar_nm()+" "+cm_bean.getCar_name(), insur_info_url, sener_user_bean.getUser_nm(), sener_user_bean.getUser_pos(), sener_user_bean.getUser_m_tel());
						if (  !sener_user_bean.getUser_m_tel().equals(user_bean.getUser_m_tel()) ) {
							at_db.sendMessageReserve("acar0089", fieldList2, user_bean.getUser_m_tel(), sener_user_bean.getUser_m_tel() , null , etc1,  etc2);			
						}
					}
				}	
			}else if ( msg_subject.equals("[정비(일반식) 안내]") ) {
				//acar0114->acar0204
				List<String> fieldList = Arrays.asList(firm_nm, cr_bean.getCar_no(), car_service_info, insur_mng_name, insur_mng_phone);
				//고객
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];	
					at_db.sendMessageReserve("acar0204", fieldList, destphone, sendphone , null , etc1,  etc2);
				}	
			} else if ( msg_subject.equals("[아마존카 월렌트 안내]") ) {
					
				//차량기본정보
				ContCarBean f_fee_etc = a_db.getContFeeEtc(m_id, l_cd, "1");
  				
			 	//고객정보
				ClientBean client = al_db.getNewClient(insur.get("CLIENT_ID")+"");
			   
			   	//법인고객차량관리자
				Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "");
				int mgr_size = car_mgrs.size();
				String f_person = "";
			    String s_person = "";
			    for(int i = 0 ; i < mgr_size ; i++){
			        CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
			       	if(mgr.getMgr_st().equals("추가이용자") || mgr.getMgr_st().equals("추가운전자")){
			        		s_person =mgr.getMgr_nm();
			       	}
			   	} 
     
				String dist = AddUtil.parseDecimal(f_fee_etc.getAgree_dist());			// 주행거리
				String dist_fee = AddUtil.parseDecimal(f_fee_etc.getOver_run_amt());	// 주행거리 초과 비용
				String driver = String.valueOf(client.getClient_nm()) + " ";			// 운전자
				String driver2 = s_person + " 고객님 ";			// 추가운전자
			
				if(!s_person.equals("")){
					//driver += ", " + s_person + " 님";
				}else{
					driver2 = "없음";
				}
				
				String visit_place = null;												// 반납장소
				String return_place = null;												// 약도
				String parking_map = "";													// 약도
				if ((insur.get("BR_ID")+"").equals("D1")) {
					visit_place = "현대카독크 2층 (042-824-1770)\n대전시 대덕구 벚꽃길 100";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg";
					parking_map = "http://kko.to/5kTS9j74J";
				}
				else if ((insur.get("BR_ID")+"").equals("G1")) {
					visit_place = "성서현대정비센터 (053-582-2998)\n대구시 달서구 달서대로109길 58";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg";
					parking_map = "http://kko.to/9ZRdpTTmd";
				}
				else if ((insur.get("BR_ID")+"").equals("J1")) {
					visit_place = "상무1급자동차공업사 (062-385-0133)광주 서구 상무누리로 131-1";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg";
					parking_map = "http://kko.to/-VXvHD_ol";
				}
				else if ((insur.get("BR_ID")+"").equals("B1")) {
					visit_place = "부경자동차정비 (051-851-0606)\n부산 연제구 거제천로 270번길 5";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_bugyung.jpg";
					parking_map = "http://kko.to/0peONPKDI";
				}
				else {
					visit_place = "영남주차장 (02-6263-6378)\n서울시 영등포구 영등포로 34길 9";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg";
					parking_map = "http://kko.to/M3C3ewyaQ";
				}
				if(!parking_map.equals("")){
					//return_place = "약도 바로 가기 "+ShortenUrlGoogle.getShortenUrl(parking_map); // 약도
					return_place = "약도 바로 가기 "+parking_map; // 약도
				}
				
				//acar0063- > acar0076 (문구수정) -> acar0110 (애니카종료) -> 20220511 acar_0262, acar_0264
				//List<String> fieldList = Arrays.asList(firm_nm, driver, dist, dist_fee, insur_mng_name, insur_mng_phone, insurance_name, insurance_phone,  car_service_info, sos_service_info,  insur_mng_name,  insur_mng_phone, visit_place, return_place);
				List<String> fieldList = Arrays.asList(firm_nm, driver, driver2, dist, dist_fee, insur_mng_name, insur_mng_phone, insurance_name, insurance_phone);
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];	
					at_db.sendMessageReserve("acar_0262", fieldList, destphone, sendphone, null , etc1,  etc2);
				}	
				
				//시간지연
				for(int t = 0; t <2; t++){
					Thread.sleep(1000);
				}
				
				
				List<String> fieldList2 = Arrays.asList(firm_nm, car_service_info, sos_service_info,  sk_net_info, insur_mng_name,  insur_mng_phone, visit_place, return_place, firm_nm);
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];	
					at_db.sendMessageReserve("acar_0264", fieldList2, destphone, sendphone, null , etc1,  etc2);
				}	
													
							
			} else if ( msg_subject.equals("bond") ) { //채권알림톡
				
				if (bond_msg_type.equals("contract")) {
					//계약별
					List<String> fieldList = Arrays.asList(customer_name, cur_date, car_no, car_nm, short_url, unpaid, bank_full, manager_name, manager_phone);
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessageReserve("acar0215", fieldList, destphone, sendphone, null , etc1, etc2);
					}	
					
				} else if (bond_msg_type.equals("client")) {
					//고객별
					List<String> fieldList = Arrays.asList(customer_name, cur_date, car_num_name_count, short_url, unpaid, bank_full);
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessageReserve("acar0222", fieldList, destphone, sendphone, null , etc1, etc2);
					}	
					
				} else {
					//type이 없는 경로에서 발송시
					List<String> fieldList = Arrays.asList(customer_name, cur_date, car_no, car_nm, short_url, unpaid, bank_full, manager_name, manager_phone);
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessageReserve("acar0215", fieldList, destphone, sendphone, null , etc1, etc2);
					}	
					
				}
			
			} else if ( msg_subject.equals("[해지 정산 안내]") ) { //해지안내 친구톡 
				
				String url3 = "http://fms1.amazoncar.co.kr/fms2/cls_cont/lc_cls_print.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
				String cls_url = ShortenUrlGoogle.getShortenUrl(url3);
				msg = firm_nm +  " 님  아마존카입니다.\n\n" + 
				"["+ cr_bean.getCar_no() + "] 차량의  해지정산내역입니다. \n\n" + cls_url + " " ;
				
			
				msg_type = "5";
				
				msg = msg +"\n\n(주)아마존카 www.amazoncar.co.kr";
				 
				System.out.println("msg="+ msg);
				
				String rqdate = "";
				
				if(req_dt.equals("")){
					
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessage(1009, "0", msg, destphone, sendphone, null, l_cd, ck_acar_id);
					}	
				}else{
					String req_time = req_dt;
						
					if(req_dt_h.equals("")) req_dt_h = "09";
					if(req_dt_s.equals("")) req_dt_s = "00";
						
					req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
						
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessage(1009, "0", msg, destphone, sendphone, req_time, l_cd, ck_acar_id);
					}	
				}
			
			
			} else { //직접입력인 경우
				
				msg_type = "5";
				
				msg = msg +"\n\n(주)아마존카 www.amazoncar.co.kr";
				     	
				String rqdate = "";
				
				if(req_dt.equals("")){
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessage(1009, "0", msg, destphone, sendphone, null, l_cd, ck_acar_id);
					}	
				}else{
					String req_time = req_dt;
						
					if(req_dt_h.equals("")) req_dt_h = "09";
					if(req_dt_s.equals("")) req_dt_s = "00";
						
					req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
						
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessage(1009, "0", msg, destphone, sendphone, req_time, l_cd, ck_acar_id);
					}	
				}
			}
				
	}
	
%>
<script language='javascript'>
<!--
	<%if(destphone_multi.equals("")){%>
		alert("수신번호를 확인하여 주시기 바랍니다.");
	<%} else {%>
		alert('전송되었습니다.');
		parent.document.form1.msg.value = '';
		parent.document.form1.msg_subject.value = '';
		parent.document.getElementById("vbt").style.display = "none";
		parent.document.getElementById("manager_send_use").checked = true;
	<%}%>
//-->
</script>
</body>
</html>