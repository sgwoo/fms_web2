<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.*" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, tax.*, acar.cont.*, acar.alink.*, acar.coolmsg.*, acar.estimate_mng.*, acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.im_email.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      	scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>


<%
	request.setCharacterEncoding("UTF-8");
	
	StringBuffer jsonBuffer = new StringBuffer();
	JSONObject jsonObject = null;
	JSONObject result = new JSONObject();
	String json = null;
	String line = null;
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	
	try {
		
		// JSON 데이터 읽기
	    BufferedReader reader = request.getReader();
	   
	    while((line = reader.readLine()) != null) {
	        jsonBuffer.append(line);
	    }
	    
	    json =jsonBuffer.toString();
		
	    // JSON 데이터 각각 파싱 진행
	    JSONObject jsonObj = new JSONObject(json);
	    
	    String doc_code 		= jsonObj.isNull("doc_code") 		== true ? "" : (String) jsonObj.get("doc_code");	// 문서 번호
	    String end_name  	= jsonObj.isNull("end_name") 		== true ? "" : (String) jsonObj.get("end_name");	// 파일경로
	    String sign_type  	= jsonObj.isNull("sign_type") 		== true ? "" : (String) jsonObj.get("sign_type");	// 서명구분 : 0서명없음 1인증서 2자필서명
	    
	    
		 // 최초 진입 시 데이터 값 체크
	    if(doc_code == null || doc_code.equals("")) {
	   		
	    	result.put("result","doc_code does not exist.");
	   		
	    } else {

	    	HashMap<String, Object> map= new HashMap<>();
	   		map.put("doc_code", doc_code);
	   		map.put("end_name", end_name);
	   		map.put("sign_type", sign_type);
	   		
			AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
			CommonDataBase c_db = CommonDataBase.getInstance();
			UserMngDatabase umd = UserMngDatabase.getInstance();
	
			/*****  Update e_doc_mng *****/ 
			flag1 = ln_db.updateEdocResult(doc_code, end_name, sign_type);
			
			
			/*****  전자문서 데이터 조회 *****/ 
			Hashtable ht = ln_db.getEDocMng(doc_code);
			String doc_type 		= String.valueOf(ht.get("DOC_TYPE"));		// 문서 분류
			String doc_name		= String.valueOf(ht.get("DOC_NAME"));		// 문서명
			String send_type		= String.valueOf(ht.get("SEND_TYPE"));	// 전송 타입	메일/알림톡
			String sign_st 		= String.valueOf(ht.get("SIGN_ST"));		// 서명자 구분	계약자/공동임차인/승계원계약자
			String firm_nm 		=  String.valueOf(ht.get("FIRM_NM"));		
			String rent_l_cd 		= String.valueOf(ht.get("RENT_L_CD"));
			String rent_mng_id	= String.valueOf(ht.get("RENT_MNG_ID"));
			String rent_st 			= String.valueOf(ht.get("RENT_ST"));
			String user_id 		= String.valueOf(ht.get("REG_ID"));
			String client_id 		= String.valueOf(ht.get("CLIENT_ID"));
			String link_code		= String.valueOf(ht.get("LINK_CODE"));
			String pdf_yn			= String.valueOf(ht.get("PDF_YN"));
			
			String sender_contact = "";			// 발신자 연락처. 발송 구분에 따라 메일 계정 또는 전화번호.
			String receiver_contact = "";			// 수신자 연락처. 발송 구분에 따라 메일 계정 또는 전화번호.
			
			String next_doc_code  = "LC"+Long.toString(System.currentTimeMillis()); 	// 추가 발송할 문서 번호. 전자문서 추가 발송은 장기 계약서만 있음. LC
			String next_sign_st = "";				// 추가 발송할 문서의 서명자 구분(1: 계약자(고객), 2: 공동임차인, 3: 계약승계원계약자)
			String next_sign_client_st = "";	// 서명 고객 구분(1: 법인, 2: 개인, 3: 개인사업자, 0: 구분 필요 없음)
			String next_pdf_yn = "Y";			// PDF 생성 여부. Y: 생성, N: 생성 X, 계약 건 다음 서명자.
			String next_sign_key = "";
			String next_sign_type = "";
			
			String doc_code_cms = "";		// CMS 자동이체 신청서 발송 시 사용할 문서번호.
			
			
			if("N".equals(pdf_yn)){
				
				if( doc_type.equals("1") ){	// 계약서
				
					if(!doc_name.equals("월렌트계약서")){ 	// 월렌트 계약서 외 나머지 계약서. 신규, 승계, 연장.
					
						// 계약 기본 정보
						ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
					
						// 고객 정보
						ClientBean client = al_db.getNewClient(client_id);
					
						// 전자 계약서 데이터 단 건 조회
						Hashtable link_ht = ln_db.getLcRentLinkM(link_code);
						
						if(send_type.equals("mail")){	/*** 발송 구분: 메일 발송인 경우 ***/
							
							// 메일 발송 시 발신자는 메일 계정.
							sender_contact = "no-reply@amazoncar.co.kr";
							String content_st = "";
							
							DmailBean d_bean = new DmailBean();
							
							d_bean.setReject_slist_idx	(0);
							d_bean.setBlock_group_idx	(0);
							d_bean.setMailfrom			(sender_contact);
							d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
							d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");
							d_bean.setHtml				(1);
							d_bean.setEncoding			(0);
							d_bean.setCharset			("euc-kr");
							d_bean.setDuration_set	(1);
							d_bean.setClick_set			(0);
							d_bean.setSite_set			(0);
							d_bean.setAtc_set			(0);
							d_bean.setRname			("mail");
							d_bean.setMtype     	  	(0);
							d_bean.setU_idx      		(1);	// admin계정
							d_bean.setG_idx				(1);	// admin계정
							d_bean.setMsgflag     		(0);
							d_bean.setV_mailfrom		(sender_contact);
							d_bean.setGubun			(rent_l_cd+""+rent_st);
							
							content_st = "newcar_doc";
							d_bean.setSubject		("[아마존카] " + firm_nm + " 님의 자동차대여이용 "+doc_name+"입니다.");
							
							String mgr_email			= String.valueOf(link_ht.get("CLIENT_USER_EMAIL"));		// 계약자 메일 주소
							String repre_email 		= String.valueOf(link_ht.get("REPRE_EMAIL"));					// 공동임차인 메일 주소
							
							
							if( "3".equals(sign_st) ){		// 승계원계약자(또는 기존 임차인) 서명 완료 시
								
								if( !"".equals(repre_email) ){	// 승계원계약자(또는 기존 임차인) 서명 완료 후 공동임차인 발송
									
									next_sign_st = "2";						// 다음 서명자 구분: 공동임차인
									receiver_contact = repre_email;	// 수신인: 공동임차인 메일 계정
									
								} else if( !"".equals(mgr_email) ){	// 승계원계약자(기존 임차인) 서명 완료 후 변경 임차인(계약자) 발송 시
									
									next_sign_st = "1";
									receiver_contact = mgr_email;		// 수신인: 계약자(또는 변경임차인) 메일 계정
									
								}
								
							} else if( "2".equals(sign_st) ){	// 공동임차인 서명 완료 시
								
								if( !"".equals(mgr_email) ){
									next_sign_st = "1";
									receiver_contact = mgr_email;		// 수신인: 계약자(또는 변경임차인) 메일 계정
								}
								
							}
							
							if(!"".equals(receiver_contact)){
								
								d_bean.setSql					("SSV:"+receiver_contact.trim());
								d_bean.setMailto				("\""+firm_nm+"\"<"+receiver_contact.trim()+">");
								d_bean.setV_mailto			(receiver_contact);
								d_bean.setGubun2			(next_doc_code+""+content_st);
								d_bean.setContent			("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+next_doc_code);
								d_bean.setV_content		("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+next_doc_code);
								
								// 메일 발송
					 			flag2 = ImEmailDb.insertDEmail(d_bean, "5", "", "+7");
							}
							
							// 계약자에게 발송되는 장기 및 승계 계약서의 경우 CMS 자동이체 신청서 메일 추가 발송
							if( flag2 ){
								if( "1".equals(next_sign_st) && (doc_name.equals("장기계약서") || doc_name.equals("계약승계계약서")) ){
									doc_code_cms  = "CT"+Long.toString(System.currentTimeMillis());
									
									DmailBean d_bean_cms = new DmailBean();
									
									d_bean_cms.setSubject				("[아마존카] " + firm_nm + " 고객님 아마존카 자동이체신청서입니다.");
									d_bean_cms.setSql						("SSV:"+ receiver_contact);
									d_bean_cms.setReject_slist_idx		(0);
									d_bean_cms.setBlock_group_idx	(0);
									d_bean_cms.setMailfrom				(sender_contact);
									d_bean_cms.setMailto					("\""+ firm_nm +"\"<"+ receiver_contact +">");
									d_bean_cms.setReplyto				("\"아마존카\"<no-reply@amazoncar.co.kr>");
									d_bean_cms.setErrosto				("\"아마존카\"<return@amazoncar.co.kr>");
									d_bean_cms.setHtml					(1);
									d_bean_cms.setEncoding				(0);
									d_bean_cms.setCharset				("euc-kr");
									d_bean_cms.setDuration_set			(1);
									d_bean_cms.setClick_set				(0);
									d_bean_cms.setSite_set				(0);
									d_bean_cms.setAtc_set				(0);
									d_bean_cms.setGubun					("docs");
									d_bean_cms.setRname					("mail");
									d_bean_cms.setMtype       			(0);
									d_bean_cms.setU_idx       			(1);	// admin계정
									d_bean_cms.setG_idx					(1);	// admin계정
									d_bean_cms.setMsgflag     			(0);	
									d_bean_cms.setContent				("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code_cms);
									
									flag4 = ImEmailDb.insertDEmail(d_bean_cms, "4", "", "+7");
								}
							}
							
							
						} else if( send_type.equals("talk") ){ /*** 발송 구분: 알림톡 발송인 경우 ***/

							// 알림톡 발송 시 발신자는 전화번호.
							sender_contact = "02-392-4243";
						
							// 친구톡 메시지 내용
							String talk_msg = firm_nm + " 님 아마존카입니다. 전자문서를 발송합니다. \n\n";
						
							String repre_m_tel 	= String.valueOf(link_ht.get("REPRE_M_TEL"));			// 공동임차인 연락처
							String mgr_m_tel	= String.valueOf(link_ht.get("CLIENT_USER_TEL"));	// 계약자(변경임차인) 연락처
							
							String index_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+next_doc_code;	// 전자 문서 인덱스 페이지 url
							String short_index_url = ShortenUrlGoogle.getShortenUrl(index_url);
							
							talk_msg += short_index_url + " ";
							
							
							if( "3".equals(sign_st) ){		//  승계원계약자(또는 기존 임차인)이 서명 완료 시
								
								if( !"".equals(repre_m_tel) ){	// 승계원계약자(또는 기존 임차인) 서명 완료 후 공동임차인 발송
									
									next_sign_st = "2";						// 다음 서명자 구분: 공동임차인
									receiver_contact = repre_m_tel;	// 수신인 연락처 = 공동 임차인 전화번호
									
								} else if( !"".equals(mgr_m_tel) ){	// 승계원계약자(기존 임차인) 서명 완료 후 변경 임차인(계약자) 발송 시
									
									next_sign_st = "1";
									receiver_contact = mgr_m_tel;
									
								}
								
							} else if( "2".equals(sign_st) ){	// 공동임차인이 서명 완료 시
								
								if( !"".equals(mgr_m_tel) ){
									next_sign_st = "1";
									receiver_contact = mgr_m_tel;
								}
							
							}
							
							// 친구톡 발송
							if( !"".equals(receiver_contact) ){
								flag2 = at_db.sendMessage(1009, "0", talk_msg, receiver_contact, sender_contact, null, rent_l_cd, user_id);
							}
							
							// 계약자에게 발송되는 장기 및 승계 계약서의 경우 CMS 자동이체 신청서 친구톡 추가 발송
							if(flag2){
								if( "1".equals(next_sign_st) && (doc_name.equals("장기계약서") || doc_name.equals("계약승계계약서")) ){
									doc_code_cms  = "CT"+Long.toString(System.currentTimeMillis());
									String talk_msg_cms = firm_nm + " 고객님 아마존카입니다. 전자문서를 발송합니다. \n\n";
									
									String index_url_cms = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code_cms;
									String short_index_url_cms = ShortenUrlGoogle.getShortenUrl(index_url_cms);
									
									talk_msg_cms += short_index_url_cms + " ";
									
									flag4 = at_db.sendMessage(1009, "0", talk_msg_cms, receiver_contact, sender_contact, null, rent_l_cd, user_id);
								}
							}
							
						}
						
						
						/***** 전자문서 데이터 처리 *****/
						if("1".equals(next_sign_st)){ 	// 계약자(또는 변경 임차인) 추가 발송 시
							
							// 계약자는 항상 마지막에 계약서를 수신하므로 pdf_yn = Y
							next_pdf_yn = "Y";
							
							// 계약자의 서명 고객 구분 처리
							String client_st = client.getClient_st();
							if(!client_st.equals("1") && !client_st.equals("2")) client_st = "3";		// 개인사업자의 경우 sign_client_st는 항상 3
							next_sign_client_st = client_st;
							
							// 계약자의 sign_key
							switch( next_sign_client_st ){
								case "1": 
									next_sign_key = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3();		// 법인이면 사업자번호
									break;
								case "2":
									next_sign_key = client.getSsn1();		// 개인이면 생년월일
									break;
								case "3":
									next_sign_key = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3() + client.getSsn1();	// 개인사업자면 사업자번호+생년월일
									break;
							}
							
						} else if("2".equals(next_sign_st)){		// 공동임차인 추가 발송 시
							
							next_pdf_yn = "N";
							next_sign_client_st = "2";			// 공동임차인의 서명 고객 구분은 항상 2(개인)
							next_sign_key = String.valueOf(link_ht.get("REPRE_SSN")).substring(2);	// sign_key는 공동임차인 생년월일 6자리
							
						}
						
						// 연장계약서의 서명 구분은 항상 자필서명.
						if( doc_name.equals("연장계약서") ) next_sign_type = "2";
						
						// 유효기간. +30일
						String term_dt = AddUtil.getDate(4);
						term_dt = af_db.getValidDt(c_db.addDay(term_dt, 30));
						
						/***** 전자문서 테이블 등록 *****/
						if( !"".equals(receiver_contact) ){
							
							String doc_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/newcar_doc.jsp?doc_code="+next_doc_code;
						
			 				flag3 = ln_db.insertALinkEdoc(next_doc_code, doc_type, next_sign_type, send_type, doc_name, doc_url, firm_nm, receiver_contact, user_id, term_dt, client_id, rent_mng_id, rent_l_cd, "", "", rent_st, next_sign_st, next_sign_client_st, next_pdf_yn, next_sign_key, link_code);
							
			 				// 계약자에게 발송되는 장기 및 승계 계약서의 경우 CMS 자동이체 신청서 추가 발송
			 				if( "1".equals(next_sign_st) && (doc_name.equals("장기계약서") || doc_name.equals("계약승계계약서")) ){
			 					String doc_url_cms = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/";
								String doc_name_cms = "";	// CMS 신청서 문서명
								String doc_type_cms = "";	// CMS 신청서 문서 구분
								String sign_type_cms = "";	// CMS 신청서 서명 구분
								
								if(next_sign_client_st.equals("1")){	// 법인 고객용
									doc_url_cms += "confirm_template_link13.jsp";
									doc_name_cms = "CMS자동이체신청서(법인 고객용)";
									doc_type_cms = "3";
									sign_type_cms = "0";
								} else {		// 개인/개인사업자 고객용
									doc_url_cms += "confirm_template_link12.jsp";	
									doc_name_cms = "CMS자동이체신청서(개인/개인사업자 고객용)";
									doc_type_cms = "4";
									sign_type_cms = "2";
								}
								doc_url_cms += "?doc_code="+doc_code_cms;
								
								// CMS 자동이체 신청서 데이터 저장
								flag5 = ln_db.insertALinkEdoc(doc_code_cms, doc_type_cms, sign_type_cms, send_type, doc_name_cms, doc_url_cms, firm_nm, receiver_contact, user_id, term_dt, client_id, rent_mng_id, rent_l_cd, "", "", rent_st, next_sign_st, next_sign_client_st, "Y", "", doc_code_cms);
			 				}
						}
						
						
					}
					
				}
				
			} else {		// pdf_yn = Y. 서명 완료 및 pdf 변환 시.
				
				// 월렌트 계약서 현장 건. 서명 완료 시 완료 문서 알림톡 발송
				if( doc_name.equals("월렌트계약서") && send_type.equals("park")){
					
					// 전자 계약서 데이터 단 건 조회
					Hashtable link_ht = ln_db.getRmRentLinkM(link_code);
					String mgr_m_tel = String.valueOf(link_ht.get("CLIENT_USER_TEL"));
					
					// 알림톡 발송 시 발신자는 전화번호.
					sender_contact = "02-392-4243";
					
					// 친구톡 메시지 내용
					String talk_msg = firm_nm + " 님 아마존카입니다. 서명하신 "+doc_name+"를 발송합니다. \n\n";
					
					String index_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code;	// 전자 문서 인덱스 페이지 url
					String short_index_url = ShortenUrlGoogle.getShortenUrl(index_url);
					
					talk_msg += short_index_url + " ";
					
					receiver_contact = mgr_m_tel;
					
					// 친구톡 발송
					if( !"".equals(receiver_contact) ){
						flag2 = at_db.sendMessage(1009, "0", talk_msg, receiver_contact, sender_contact, null, rent_l_cd, user_id);
					}
					
				}
			
				// 수신자 정보 조회
				UsersBean target_bean 	= umd.getUsersBean(user_id);
			
				String subject = "전자문서 서명 알림";
				String cool_msg = "[전자문서] " + firm_nm + " 고객님(" + rent_l_cd + ")의 " + doc_name + " 서명이 완료되었습니다.";
			
				// 서명 완료 시 담당 직원 메신저 발송 처리.
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
							"<ALERTMSG>"+
							"    <BACKIMG>4</BACKIMG>"+
							"    <MSGTYPE>104</MSGTYPE>"+
							"    <SUB>"+subject+"</SUB>"+
							"    <CONT>"+cool_msg+"</CONT>";

				//받는사람
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";

				//보낸사람
				xml_data += "    <SENDER></SENDER>"+

							"    <MSGICON>10</MSGICON>"+
							"    <MSGSAVE>1</MSGSAVE>"+
							"    <LEAVEDMSG>1</LEAVEDMSG>"+
							"    <FLDTYPE>1</FLDTYPE>"+
							"  </ALERTMSG>"+
							"</COOLMSG>";
				
				CdAlertBean msg1 = new CdAlertBean();
				msg1.setFlddata(xml_data);
				msg1.setFldtype("1");
				
				flag3 = cm_db.insertCoolMsg(msg1);
					
			}
			
	    }
						
		if(!flag1){
			result.put("result", "update error");
		} else if(!flag2){
		    result.put("result", "send error");
		} else if(!flag3){
		    result.put("result", "insert e_doc_mng error");
		} else {
		    result.put("result", "success");
		}
	 
	    response.setContentType("application/json");
	    out.print(result);
	   
	} catch(Exception e) {
		
	    System.out.println("Error reading JSON string: " + e.toString());
	    
	}

%>

