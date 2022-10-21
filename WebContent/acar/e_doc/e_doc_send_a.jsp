<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, tax.*, acar.cont.*, acar.alink.*, acar.coolmsg.*, acar.estimate_mng.*, acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.im_email.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      	scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<% 
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String document_st		= request.getParameter("document_st")		== null ? "" : request.getParameter("document_st");		// 문서 대분류
	String document_type	= request.getParameter("document_type")	== null ? "" : request.getParameter("document_type");	// 문서 구분
	String send_type			= request.getParameter("send_type")			== null ? "" : request.getParameter("send_type");			// 발송 구분 mail: 메일,  talk: 알림톡, driver: 기사, park: 현장
// 	String sign_type			= request.getParameter("sign_type")			== null ? "" : request.getParameter("sign_type");			// 서명 구분. 0: 서명없음, 1: 인증서, 2: 자필서명
	String doc_name 			= request.getParameter("doc_name")			== null ? "" : request.getParameter("doc_name");			// 문서명

	String rent_mng_id 		= request.getParameter("rent_mng_id")		== null ? "" : request.getParameter("rent_mng_id");
	String rent_l_cd 			= request.getParameter("rent_l_cd")			== null ? "" : request.getParameter("rent_l_cd");
	String rent_st	 			= request.getParameter("rent_st")				== null ? "" : request.getParameter("rent_st");
	String client_id			= request.getParameter("client_id")			== null ? "" : request.getParameter("client_id");
	
	String mgr_nm 			= request.getParameter("mgr_nm")		== null ? "" : request.getParameter("mgr_nm");			// 수신자 이름
	String mgr_email 		= request.getParameter("mgr_email")	== null ? "" : request.getParameter("mgr_email");		// 수신자 메일 계정
	String mgr_m_tel 		= request.getParameter("mgr_m_tel")	== null ? "" : request.getParameter("mgr_m_tel");		// 수신자 연락처
	String mgr_cng 			= request.getParameter("mgr_cng")		== null ? "" : request.getParameter("mgr_cng");
	
	String repre_email 		= request.getParameter("repre_email")	== null ? "" : request.getParameter("repre_email");	// 공동임차인 메일 계정
	String repre_m_tel 		= request.getParameter("repre_m_tel")	== null ? "" : request.getParameter("repre_m_tel");	// 공동임차인 전화번호
	
	String suc_mgr_nm 	= request.getParameter("suc_mgr_nm")		== null ? "" : request.getParameter("suc_mgr_nm");		// 기존 임차인 이름
	String suc_mgr_email 	= request.getParameter("suc_mgr_email")	== null ? "" : request.getParameter("suc_mgr_email");	// 기존 임차인 메일 계정
	String suc_mgr_m_tel 	= request.getParameter("suc_mgr_m_tel")	== null ? "" : request.getParameter("suc_mgr_m_tel");	// 기존 임차인 전화번호
	
	String bus_id 	= request.getParameter("bus_id")	== null ? "" : request.getParameter("bus_id");
	String bus_st 	= request.getParameter("bus_st")	== null ? "" : request.getParameter("bus_st");
	
	String cms_type 	= request.getParameter("cms_type")	== null ? "" : request.getParameter("cms_type");
	
	String client_repre_st 	= request.getParameter("client_repre_st")	== null ? "" : request.getParameter("client_repre_st");	// 대표자 선택
	
	String doc_st = request.getParameter("doc_st")	== null ? "" : request.getParameter("doc_st");	// 전자계약서 구분 선택(1: 인증서, 2: 자필서명)
	
	String client_st 		= request.getParameter("client_st")		== null ? "" : request.getParameter("client_st");
	String suc_client_st	= request.getParameter("suc_client_st")	== null ? "" : request.getParameter("suc_client_st");
	
	String view_amt 	= request.getParameter("view_amt")	== null ? "" : request.getParameter("view_amt");
	String pay_way 	= request.getParameter("pay_way")	== null ? "" : request.getParameter("pay_way");

	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	// 문서 구분
	String doc_type = document_st;
	
	// 문서 번호
	String doc_code  = Long.toString(System.currentTimeMillis());
	
	// CMS 자동이체 신청서 발송 시 사용할 문서번호.
	String doc_code_cms = "";
	
	// 발신자 정보 조회
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean 	= umd.getUsersBean(user_id);
	
	// 계약 기본 정보 조회
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	// 고객 정보  조회
	ClientBean client = al_db.getNewClient(base.getClient_id());
	String firm_nm = client.getFirm_nm();
	
	// 해당 대여 정보 조회
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	// 자동차 등록 정보 조회
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	boolean flag1 = true;		// alink 문서 테이블 저장
	boolean flag2 = true;		// 메일/알림톡 발송
	boolean flag3 = true;		// 전자문서 테이블 저장
	boolean flag4 = true;		// 전자계약서 발송 시 CMS 출금이체 신청서 메일/알림톡 발송.
	boolean flag6 = true;		// 장기계약서 발송 시 CMS 출금이체 신청서 전자문서 테이블 저장.
	
	String sender_contact = "";		// 발신자 연락처. 발송 구분에 따라 메일 계정 또는 전화번호.
	String receiver_contact = "";		// 수신자 연락처. 발송 구분에 따라 메일 계정 또는 전화번호.
	
	String doc_url = "";			// 문서 url
	String sign_type = "";		// 서명 구분. 0: 서명없음, 1: 인증서, 2: 자필서명
	String sign_st = "1";		// 서명자 구분(1: 계약자(고객), 2: 공동임차인, 3: 계약승계원계약자)
	String pdf_yn = "Y";			// PDF 생성 여부. Y: 생성, N: 생성 X, 계약 건 다음 서명자.
	
	boolean checkSendCms = false;	// CMS 자동이체 신청서 추가 발송 유무 체크
	if( document_type.equals("1") || document_type.equals("2") ) checkSendCms = true;	// 장기계약서, 계약승계계약서의 경우 CMS 자동이체신청서 추가 발송. 
	if( document_type.equals("4") && client_st.equals("1") && cms_type.equals("cms") ) checkSendCms = true;	// 월렌트계약서 법인이면서 cms_type이 cms인 경우 CMS 자동이체신청서 추가 발송.
	

	/******************** 데이터 저장 및 문서 번호 처리 ********************/
	if( document_st.equals("1") ){
		
		if( !document_type.equals("4") ){		// 신규, 승계, 연장 계약서
			String sender = "";
		
			if(bus_st.equals("7") && user_id.equals("000057")){ 	// 계약 구분이 에이전트 계약이고 접속자 고연미 과장님일 경우 발신자를 최초영업자로.
				sender = bus_id;
			} else {
				sender = user_id;
			}
			
			// 개인사업자의 공동 대표자 처리
			boolean flag5 = a_db.updateClientRepreSt(client_repre_st, rent_mng_id, rent_l_cd);
			
			// 장기계약서 데이터 저장
			flag1 = ln_db.insertALinkRentLinkM( doc_code, document_type, rent_l_cd, rent_st, mgr_nm, mgr_email, mgr_m_tel, sender, suc_mgr_nm, suc_mgr_email, suc_mgr_m_tel, cms_type, repre_email, repre_m_tel, "", send_type );

			doc_code = "LC" + doc_code;
			
		} else {		// 월렌트 계약서
			
			// 월렌트 계약서 데이터 저장
			flag1 = ln_db.insertALinkRentLinkM( doc_code, document_type, rent_l_cd, rent_st, mgr_nm, mgr_email, mgr_m_tel, user_id, suc_mgr_nm, suc_mgr_email, suc_mgr_m_tel, cms_type, repre_email, repre_m_tel, "", send_type );
		
			doc_code = "RM" + doc_code;
		
		}
	} else if( document_st.equals("3") || document_st.equals("4") ){
		doc_code = "CT" + doc_code;
	}
	
	
	if(!flag1) return;
	
	
	/******************** 메일 또는 알림톡 발송 처리 ********************/
	if(send_type.equals("mail")){	/*** 메일 발송 ***/
		
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
		
		if(document_st.equals("1")){		// 계약서
			
			d_bean.setGubun		(rent_l_cd+""+rent_st);
			d_bean.setSubject		("[아마존카] "+firm_nm+" 님의 자동차대여이용 "+doc_name+"입니다.");
		
			if(document_type.equals("4")){	// 월렌트
				content_st = "rmcar_doc";
			} else {									// 신규/증차/대차, 계약승계, 연장
				content_st = "newcar_doc";
			}
			
			
			/* 계약서 발송 대상(서명인 구분) 체크. */
			if(document_type.equals("4")){	// 월렌트는 항상 계약자
				receiver_contact = mgr_email;
				sign_st = "1";
			} else {
				// 월렌트 외 계약서의 경우 우선순위: 1. 승계원계약자(또는 기존임차인), 2. 공동임차인, 3. 계약자(또는 변경임차인)
				if( !"".equals(suc_mgr_email) ){
					receiver_contact = suc_mgr_email;	// 수신인 연락처 = 승계원계약자(또는 기존임차인) 메일 계정
					sign_st = "3";
				} else if( !"".equals(repre_email) ){
					receiver_contact = repre_email;			// 수신인 연락처 = 공동임차인 메일 계정
					sign_st = "2";
				} else {
					receiver_contact = mgr_email;			// 수신인 연락처 = 계약자(또는 변경임차인) 메일 계정
					sign_st = "1";
				}
			}

			d_bean.setSql					("SSV:" + receiver_contact);
			d_bean.setMailto				("\"" + firm_nm + "\"<" + receiver_contact + ">");
			d_bean.setV_mailto			(receiver_contact);
			
			d_bean.setGubun2			(doc_code + "" + content_st);
			d_bean.setContent			("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			d_bean.setV_content		("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			
			/***** 계약서 메일 발송 *****/
			if( !"".equals(receiver_contact) ){
	 			flag2 = ImEmailDb.insertDEmail(d_bean, "5", "", "+7");
			}
			
			
			/* 계약서 메일 발송 후 CMS 자동이체 신청서 메일 추가 발송 */
			if( flag2 ){
				
				if( checkSendCms ){
					
					// 발송 대상이 계약자인 경우에만 CMS 자동이체 신청서 발송함
					if( receiver_contact.equals(mgr_email) && sign_st.equals("1") ){
						doc_code_cms  = "CT"+Long.toString(System.currentTimeMillis());
						DmailBean d_bean_cms = new DmailBean();
						
						d_bean_cms.setSubject				("[아마존카] " + firm_nm + " 고객님 아마존카 자동이체신청서입니다.");
						d_bean_cms.setSql						("SSV:"+ receiver_contact);
						d_bean_cms.setReject_slist_idx	(0);
						d_bean_cms.setBlock_group_idx	(0);
						d_bean_cms.setMailfrom				(sender_contact);
						d_bean_cms.setMailto					("\""+ firm_nm +"\"<"+ receiver_contact +">");
						d_bean_cms.setReplyto				("\"아마존카\"<no-reply@amazoncar.co.kr>");
						d_bean_cms.setErrosto				("\"아마존카\"<return@amazoncar.co.kr>");
						d_bean_cms.setHtml					(1);
						d_bean_cms.setEncoding				(0);
						d_bean_cms.setCharset				("euc-kr");
						d_bean_cms.setDuration_set		(1);
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
				
			}
			
		} else if( document_st.equals("3") || document_st.equals("4") ){	// 확인서/요청서

			receiver_contact = mgr_email;
			
			d_bean.setSubject			("[아마존카] "+firm_nm+" 님 아마존카 전자문서입니다.");
			d_bean.setSql					("SSV:"+ receiver_contact);
			d_bean.setMailto				("\""+ firm_nm +"\"<"+ receiver_contact +">");
			d_bean.setGubun			("docs");
			d_bean.setContent			("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			
			if( !"".equals(receiver_contact) ){
				flag2 = ImEmailDb.insertDEmail(d_bean, "4", "", "+7");
			}
			
		} 
		
		
	} else if(send_type.equals("talk")){		/*** 친구톡 발송 ***/
		
		// 알림톡 발송 시 발신자는 전화번호.
		sender_contact = "02-392-4243";
	
		// 친구톡 메시지 내용
		String talk_msg = firm_nm + " 고객님 아마존카입니다. 전자문서를 발송합니다. \n\n";
		
		String index_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code;	// 전자 문서 인덱스 페이지 url
		String short_index_url = ShortenUrlGoogle.getShortenUrl(index_url);		// 전자 문서 인덱스 페이지 url bitly화
		
		talk_msg += short_index_url + " ";
		
		if(document_st.equals("1")){ // 계약서
			
			/* 계약서 발송 대상(서명인 구분) 체크. */
			if(document_type.equals("4")){	// 월렌트는 항상 계약자
				receiver_contact = mgr_m_tel;
				sign_st = "1";
			} else {
				// 월렌트 외 계약서의 경우 우선순위: 1. 승계원계약자(또는 기존임차인), 2. 공동임차인, 3. 계약자(또는 변경임차인)
				if( !"".equals(suc_mgr_m_tel) ){
					receiver_contact = suc_mgr_m_tel;	// 수신인 연락처 = 승계원계약자(또는 기존임차인) 전화번호
					sign_st = "3";
				} else if( !"".equals(repre_m_tel) ){
					receiver_contact = repre_m_tel;		// 수신인 연락처 = 공동임차인 전화번호
					sign_st = "2";
				} else {
					receiver_contact = mgr_m_tel;			// 수신인 연락처 = 계약자(또는 변경임차인) 전화번호
					sign_st = "1";
				}
			}
		
			/***** 계약서 친구톡 발송 *****/
			if( !"".equals(receiver_contact) ){	
				flag2 = at_db.sendMessage(1009, "0", talk_msg, receiver_contact, sender_contact, null, rent_l_cd, user_id);
			}
		
			/* 계약서 친구톡 발송 후 CMS 자동이체 신청서 친구톡 추가 발송 */
			if(flag2){
				
				if( checkSendCms ){
					
					// 발송 대상이 계약자인 경우에만 CMS 자동이체 신청서 발송함
					if( receiver_contact.equals(mgr_m_tel) && sign_st.equals("1") ){
						doc_code_cms  = "CT"+Long.toString(System.currentTimeMillis());
						
						String talk_msg_cms = firm_nm + " 고객님 아마존카입니다. 전자문서를 발송합니다. \n\n";
						
						String index_url_cms = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code_cms;
						String short_index_url_cms = ShortenUrlGoogle.getShortenUrl(index_url_cms);
						
						talk_msg_cms += short_index_url_cms + " ";
						
						flag4 = at_db.sendMessage(1009, "0", talk_msg_cms, receiver_contact, sender_contact, null, rent_l_cd, user_id);
					}
				
				}
				
			}
		
		} else if( document_st.equals("3") || document_st.equals("4") ){	// 확인서/요청서
			
			receiver_contact = mgr_m_tel;
		
			if( !"".equals(receiver_contact) ){	
				flag2 = at_db.sendMessage(1009, "0", talk_msg, receiver_contact, sender_contact, null, rent_l_cd, user_id);
			}
			
		}
		
	}
	
	
	
	if(!flag2 || !flag4 ) return;
	
	
	
	/******************** 전자문서 처리 ********************/
	
	// 유효기간. +30일
	String term_dt = AddUtil.getDate(4);
	term_dt = af_db.getValidDt(c_db.addDay(term_dt, 30));
	
	// 서명 고객 구분. 1: 법인, 2: 개인, 3: 개인사업자, 0: 구분 필요 없음
	String sign_client_st	= "";
	
	/***** 전자문서관리 테이블 저장 시 데이터 처리 *****/
	if( document_st.equals("1") ){	// 계약서
		
		
		/*  서명 고객 구분 처리 */
		switch( sign_st ){
			case "1": 
					sign_client_st = client_st;		// 계약자 서명 시 서명 고객 구분은 계약자의 고객 구분
					break;
			case "2":
					sign_client_st = "2";				// 공동임차인 서명 시 서명 고객 구분은 항상 2(개인)
					break;
			case "3":
					sign_client_st = suc_client_st;	// 승계원계약자 서명 시 서명 고객 구분은 승계원계약자의 고객 구분
					break;
		}
		
		// 개인사업자의 서명 고객 구분 처리. 기존 개인사업자에 해당하는 고객 구분 3~6은 모두 3으로 처리.
		if( !sign_client_st.equals("1") && !sign_client_st.equals("2") ){
			sign_client_st = "3";
		}
		
		/* 서명인 정보 값(sign_key) 처리 */
		String sign_key = "";
		if(sign_st.equals("1")){	// 계약자(또는 변경임차인)
			
			switch( sign_client_st ){
				case "1": 
					sign_key = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3();	// 법인이면 사업자번호
					break;
				case "2":
					sign_key = client.getSsn1();		// 개인이면 생년월일
					break;
				case "3":
					sign_key = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3() + client.getSsn1();	// 개인사업자면 사업자번호+생년월일
					break;
			}
		
		} else if( sign_st.equals("2")){	// 공동임차인
			
			// 전자 계약서 데이터 조회
			Hashtable link_ht = ln_db.getLcRentLinkM(doc_code);
		
			sign_key = String.valueOf(link_ht.get("REPRE_SSN")).substring(2);	// sign_key는 공동임차인 생년월일 6자리 YYYYMMDD
			
		} else if( sign_st.equals("3")){	// 승계원계약자(기존임차인)
			
			Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
			switch( sign_client_st ){
				case "1": 
					sign_key = String.valueOf(begin.get("ENP_NO"));	// 법인이면 사업자번호
					break;
				case "2":
					sign_key = String.valueOf(begin.get("SSN"));			// 개인이면 생년월일
					break;
				case "3":
					sign_key = String.valueOf(begin.get("ENP_NO")) + String.valueOf(begin.get("SSN"));	// 개인사업자면 사업자번호+생년월일
					break;
			}
			
		}  
		
		
		/* 문서 URL 및 pdf_yn 처리 */
		if( !document_type.equals("4") ){		// 장기 계약서(신규/증차/대차, 계약 승계, 연장)
			
			doc_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/newcar_doc.jsp?doc_code="+doc_code;
			
			// PDF_YN 처리. 공동임차인(sign_st=2)이나 승계원계약자(또는 기존임차인, sign_st=3)에게 발송 시 이후 서명인이 있으므로 pdf_yn = N처리.
			pdf_yn = sign_st.equals("1") ? "Y" : "N";
			
		} else {		// 월렌트 계약서

			doc_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/rmcar_doc.jsp?doc_code="+doc_code+"&cms_type="+cms_type;
			
			if( send_type.equals("park") ){
				receiver_contact = mgr_m_tel;
			}
		}
		
		if( !receiver_contact.equals("") || send_type.equals("park") ){
			
			// 연장계약서의 경우 서명 구분은 항상 자필서명. 장기, 승계, 월렌트 계약서는 서명 구분 별도 저장하지 않음. 고객이 선택.
			if( document_type.equals("3") ){
				sign_type = "2";
			}
			
			// 전자문서 관리 테이블 저장.
			flag3 = ln_db.insertALinkEdoc(doc_code, doc_type, sign_type, send_type, doc_name, doc_url, firm_nm, receiver_contact, user_id, term_dt, client_id, rent_mng_id, rent_l_cd, "", "", rent_st, sign_st, sign_client_st, pdf_yn, sign_key, doc_code);
			
			/***** CMS 자동이체 신청서 추가 저장 *****/
			if( checkSendCms ){
				
				// 발송 대상이 계약자인 경우에만 CMS 자동이체 신청서 발송. 공동임차인 및 승계원계약자의 경우 불필요.
				if( sign_st.equals("1") && (receiver_contact.equals(mgr_email) || receiver_contact.equals(mgr_m_tel)) ){
				
					String doc_url_cms = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/";
					String doc_name_cms = "";	// CMS 신청서 문서명
					String doc_type_cms = "";	// CMS 신청서 문서 구분
					String sign_type_cms = "";	// CMS 신청서 서명 구분
					
					if(sign_client_st.equals("1")){	// 법인 고객용
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
					flag6 = ln_db.insertALinkEdoc(doc_code_cms, doc_type_cms, sign_type_cms, send_type, doc_name_cms, doc_url_cms, firm_nm, receiver_contact, user_id, term_dt, client_id, rent_mng_id, rent_l_cd, "", "", rent_st, sign_st, sign_client_st, "Y", "", doc_code_cms);
					
				}
				
			}
			
			/***** 월렌트 계약서 발송 시 월렌트 인도인수증 추가 저장. *****/
			if( document_type.equals("4") && send_type.equals("park")){
				
				String link_doc_code = doc_code.replace("RM", "");
				
				// 인도인수증 데이터 조회. 월렌트 인도인수증의 탁송번호는 월렌트계약서 문서번호가 저장됨. 
				Hashtable cons_ht = ln_db.getConsignmentLink(link_doc_code);
				
				String doc_code_cons = String.valueOf(cons_ht.get("TMSG_SEQ"));	// 전자문서테이블 문서번호는 인도인수증 TMSG_SEQ 컬럼과 동일.
				String doc_type_cons = "2";		// 문서 구분 인도인수증
				String sign_type_cons = "2";	// 서명 구분 자필서명. 
				String doc_name_cons = "인도인수증";	// 문서명
				String doc_url_cons = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/deli_taking.jsp?doc_code="+doc_code_cons;	// 문서 url
				
				// 월렌트 인도 인도인수증 데이터 저장
				flag6 = ln_db.insertALinkEdoc(doc_code_cons, doc_type_cons, sign_type_cons, send_type, doc_name_cons, doc_url_cons, firm_nm, receiver_contact, user_id, term_dt, client_id, rent_mng_id, rent_l_cd, link_doc_code, "", rent_st, sign_st, "0", "Y", "", doc_code_cons);
			}
		}
	
		
	} else if( document_st.equals("3") || document_st.equals("4")){	// 확인서/요청서
		
		// 서명구분. 확인서는 항상 서명없음(0), 요청서는 항상 자필서명(2).
		sign_type = document_st.equals("3") ? "0" : "2";		
		
		// 문서 url
		doc_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/confirm_template_link"+document_type+".jsp?doc_code="+doc_code;
		if( document_type.equals("2") ){	// 자동차 대여이용 계약사실 확인서
			doc_url += "&view_amt=" + view_amt;
		} else if( document_type.equals("4") ){		// 자동차 장기대여 대여료의 결제수단 안내
			doc_url += "&pay_way=" + pay_way;
		}
		
		// 서명 고객 구분 처리
		sign_client_st = client_st;
		
		// 전자문서 관리 테이블 저장.
		flag3 = ln_db.insertALinkEdoc(doc_code, doc_type, sign_type, send_type, doc_name, doc_url, firm_nm, receiver_contact, user_id, term_dt, client_id, rent_mng_id, rent_l_cd, "", "", rent_st, sign_st, sign_client_st, pdf_yn, "", doc_code);
		
	}
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
</head>
<body>
<form name='form1' method='post' target="">
  <input type='hidden' name='user_id' 				value='<%=user_id%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 			value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st" 				value="<%=rent_st%>">
  <input type='hidden' name="client_id" 			value="<%=client_id%>">
  <input type='hidden' name="document_st" 		value="<%=document_st%>">
  <input type='hidden' name="document_type"	value="<%=document_type%>">
  <input type='hidden' name="send_type"			value="<%=send_type%>">
  <input type='hidden' name="mgr_email"			value="<%=mgr_email%>">
  <input type='hidden' name="mgr_m_tel"			value="<%=mgr_m_tel%>">
  <input type='hidden' name="view_amt"			value="<%=view_amt%>">
  <input type='hidden' name="pay_way"				value="<%=pay_way%>">
</form>
<script language="JavaScript">
<%if(!flag1){%>
	alert("저장 실패");
<%}else if(!flag2){%>
	alert("전자문서 발송 실패");
<%}else if(!flag3){%>
	alert("전자문서 등록 실패");
<%-- <%}else if(!flag4){%> --%>
// 	alert("CMS출금이체신청서 발송 실패");
<%-- <%}else if(!flag6){%> --%>
// 	alert("CMS출금이체신청서 등록 실패");
<%}else{%>
	
	alert("정상적으로 발송되었습니다.");
	var fm = document.form1;
	<%if( document_st.equals("1") ){				// 계약서 %>
		fm.action='cont_doc_send.jsp';	
	<%} else if( document_st.equals("3") || document_st.equals("4") ){	// 확인서 %>
		fm.action='confirm_doc_send.jsp';	
	<%}%>
	fm.submit();
	
	<%if(document_st.equals("1") && document_type.equals("4") && send_type.equals("park") ){ // 월렌트계약서 현장 선택 시%>
		var doc_url = '<%=doc_url%>';
		window.open(doc_url, 'doc');
	<%}%>
	
<%}%>

</script>
</body>
</html>