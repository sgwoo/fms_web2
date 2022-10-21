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
	
	String document_st		= request.getParameter("document_st")		== null ? "" : request.getParameter("document_st");		// ���� ��з�
	String document_type	= request.getParameter("document_type")	== null ? "" : request.getParameter("document_type");	// ���� ����
	String send_type			= request.getParameter("send_type")			== null ? "" : request.getParameter("send_type");			// �߼� ���� mail: ����,  talk: �˸���, driver: ���, park: ����
// 	String sign_type			= request.getParameter("sign_type")			== null ? "" : request.getParameter("sign_type");			// ���� ����. 0: �������, 1: ������, 2: ���ʼ���
	String doc_name 			= request.getParameter("doc_name")			== null ? "" : request.getParameter("doc_name");			// ������

	String rent_mng_id 		= request.getParameter("rent_mng_id")		== null ? "" : request.getParameter("rent_mng_id");
	String rent_l_cd 			= request.getParameter("rent_l_cd")			== null ? "" : request.getParameter("rent_l_cd");
	String rent_st	 			= request.getParameter("rent_st")				== null ? "" : request.getParameter("rent_st");
	String client_id			= request.getParameter("client_id")			== null ? "" : request.getParameter("client_id");
	
	String mgr_nm 			= request.getParameter("mgr_nm")		== null ? "" : request.getParameter("mgr_nm");			// ������ �̸�
	String mgr_email 		= request.getParameter("mgr_email")	== null ? "" : request.getParameter("mgr_email");		// ������ ���� ����
	String mgr_m_tel 		= request.getParameter("mgr_m_tel")	== null ? "" : request.getParameter("mgr_m_tel");		// ������ ����ó
	String mgr_cng 			= request.getParameter("mgr_cng")		== null ? "" : request.getParameter("mgr_cng");
	
	String repre_email 		= request.getParameter("repre_email")	== null ? "" : request.getParameter("repre_email");	// ���������� ���� ����
	String repre_m_tel 		= request.getParameter("repre_m_tel")	== null ? "" : request.getParameter("repre_m_tel");	// ���������� ��ȭ��ȣ
	
	String suc_mgr_nm 	= request.getParameter("suc_mgr_nm")		== null ? "" : request.getParameter("suc_mgr_nm");		// ���� ������ �̸�
	String suc_mgr_email 	= request.getParameter("suc_mgr_email")	== null ? "" : request.getParameter("suc_mgr_email");	// ���� ������ ���� ����
	String suc_mgr_m_tel 	= request.getParameter("suc_mgr_m_tel")	== null ? "" : request.getParameter("suc_mgr_m_tel");	// ���� ������ ��ȭ��ȣ
	
	String bus_id 	= request.getParameter("bus_id")	== null ? "" : request.getParameter("bus_id");
	String bus_st 	= request.getParameter("bus_st")	== null ? "" : request.getParameter("bus_st");
	
	String cms_type 	= request.getParameter("cms_type")	== null ? "" : request.getParameter("cms_type");
	
	String client_repre_st 	= request.getParameter("client_repre_st")	== null ? "" : request.getParameter("client_repre_st");	// ��ǥ�� ����
	
	String doc_st = request.getParameter("doc_st")	== null ? "" : request.getParameter("doc_st");	// ���ڰ�༭ ���� ����(1: ������, 2: ���ʼ���)
	
	String client_st 		= request.getParameter("client_st")		== null ? "" : request.getParameter("client_st");
	String suc_client_st	= request.getParameter("suc_client_st")	== null ? "" : request.getParameter("suc_client_st");
	
	String view_amt 	= request.getParameter("view_amt")	== null ? "" : request.getParameter("view_amt");
	String pay_way 	= request.getParameter("pay_way")	== null ? "" : request.getParameter("pay_way");

	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	// ���� ����
	String doc_type = document_st;
	
	// ���� ��ȣ
	String doc_code  = Long.toString(System.currentTimeMillis());
	
	// CMS �ڵ���ü ��û�� �߼� �� ����� ������ȣ.
	String doc_code_cms = "";
	
	// �߽��� ���� ��ȸ
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean 	= umd.getUsersBean(user_id);
	
	// ��� �⺻ ���� ��ȸ
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	// �� ����  ��ȸ
	ClientBean client = al_db.getNewClient(base.getClient_id());
	String firm_nm = client.getFirm_nm();
	
	// �ش� �뿩 ���� ��ȸ
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	// �ڵ��� ��� ���� ��ȸ
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	boolean flag1 = true;		// alink ���� ���̺� ����
	boolean flag2 = true;		// ����/�˸��� �߼�
	boolean flag3 = true;		// ���ڹ��� ���̺� ����
	boolean flag4 = true;		// ���ڰ�༭ �߼� �� CMS �����ü ��û�� ����/�˸��� �߼�.
	boolean flag6 = true;		// ����༭ �߼� �� CMS �����ü ��û�� ���ڹ��� ���̺� ����.
	
	String sender_contact = "";		// �߽��� ����ó. �߼� ���п� ���� ���� ���� �Ǵ� ��ȭ��ȣ.
	String receiver_contact = "";		// ������ ����ó. �߼� ���п� ���� ���� ���� �Ǵ� ��ȭ��ȣ.
	
	String doc_url = "";			// ���� url
	String sign_type = "";		// ���� ����. 0: �������, 1: ������, 2: ���ʼ���
	String sign_st = "1";		// ������ ����(1: �����(��), 2: ����������, 3: ���°�������)
	String pdf_yn = "Y";			// PDF ���� ����. Y: ����, N: ���� X, ��� �� ���� ������.
	
	boolean checkSendCms = false;	// CMS �ڵ���ü ��û�� �߰� �߼� ���� üũ
	if( document_type.equals("1") || document_type.equals("2") ) checkSendCms = true;	// ����༭, ���°��༭�� ��� CMS �ڵ���ü��û�� �߰� �߼�. 
	if( document_type.equals("4") && client_st.equals("1") && cms_type.equals("cms") ) checkSendCms = true;	// ����Ʈ��༭ �����̸鼭 cms_type�� cms�� ��� CMS �ڵ���ü��û�� �߰� �߼�.
	

	/******************** ������ ���� �� ���� ��ȣ ó�� ********************/
	if( document_st.equals("1") ){
		
		if( !document_type.equals("4") ){		// �ű�, �°�, ���� ��༭
			String sender = "";
		
			if(bus_st.equals("7") && user_id.equals("000057")){ 	// ��� ������ ������Ʈ ����̰� ������ ���� ������� ��� �߽��ڸ� ���ʿ����ڷ�.
				sender = bus_id;
			} else {
				sender = user_id;
			}
			
			// ���λ������ ���� ��ǥ�� ó��
			boolean flag5 = a_db.updateClientRepreSt(client_repre_st, rent_mng_id, rent_l_cd);
			
			// ����༭ ������ ����
			flag1 = ln_db.insertALinkRentLinkM( doc_code, document_type, rent_l_cd, rent_st, mgr_nm, mgr_email, mgr_m_tel, sender, suc_mgr_nm, suc_mgr_email, suc_mgr_m_tel, cms_type, repre_email, repre_m_tel, "", send_type );

			doc_code = "LC" + doc_code;
			
		} else {		// ����Ʈ ��༭
			
			// ����Ʈ ��༭ ������ ����
			flag1 = ln_db.insertALinkRentLinkM( doc_code, document_type, rent_l_cd, rent_st, mgr_nm, mgr_email, mgr_m_tel, user_id, suc_mgr_nm, suc_mgr_email, suc_mgr_m_tel, cms_type, repre_email, repre_m_tel, "", send_type );
		
			doc_code = "RM" + doc_code;
		
		}
	} else if( document_st.equals("3") || document_st.equals("4") ){
		doc_code = "CT" + doc_code;
	}
	
	
	if(!flag1) return;
	
	
	/******************** ���� �Ǵ� �˸��� �߼� ó�� ********************/
	if(send_type.equals("mail")){	/*** ���� �߼� ***/
		
		// ���� �߼� �� �߽��ڴ� ���� ����.
		sender_contact = "no-reply@amazoncar.co.kr";
	
		String content_st = "";
		
		DmailBean d_bean = new DmailBean();
		
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			(sender_contact);
		d_bean.setReplyto			("\"�Ƹ���ī\"<no-reply@amazoncar.co.kr>");
		d_bean.setErrosto			("\"�Ƹ���ī\"<return@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set	(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setRname			("mail");
		d_bean.setMtype     	  	(0);
		d_bean.setU_idx      		(1);	// admin����
		d_bean.setG_idx				(1);	// admin����
		d_bean.setMsgflag     		(0);
		d_bean.setV_mailfrom		(sender_contact);
		
		if(document_st.equals("1")){		// ��༭
			
			d_bean.setGubun		(rent_l_cd+""+rent_st);
			d_bean.setSubject		("[�Ƹ���ī] "+firm_nm+" ���� �ڵ����뿩�̿� "+doc_name+"�Դϴ�.");
		
			if(document_type.equals("4")){	// ����Ʈ
				content_st = "rmcar_doc";
			} else {									// �ű�/����/����, ���°�, ����
				content_st = "newcar_doc";
			}
			
			
			/* ��༭ �߼� ���(������ ����) üũ. */
			if(document_type.equals("4")){	// ����Ʈ�� �׻� �����
				receiver_contact = mgr_email;
				sign_st = "1";
			} else {
				// ����Ʈ �� ��༭�� ��� �켱����: 1. �°�������(�Ǵ� ����������), 2. ����������, 3. �����(�Ǵ� ����������)
				if( !"".equals(suc_mgr_email) ){
					receiver_contact = suc_mgr_email;	// ������ ����ó = �°�������(�Ǵ� ����������) ���� ����
					sign_st = "3";
				} else if( !"".equals(repre_email) ){
					receiver_contact = repre_email;			// ������ ����ó = ���������� ���� ����
					sign_st = "2";
				} else {
					receiver_contact = mgr_email;			// ������ ����ó = �����(�Ǵ� ����������) ���� ����
					sign_st = "1";
				}
			}

			d_bean.setSql					("SSV:" + receiver_contact);
			d_bean.setMailto				("\"" + firm_nm + "\"<" + receiver_contact + ">");
			d_bean.setV_mailto			(receiver_contact);
			
			d_bean.setGubun2			(doc_code + "" + content_st);
			d_bean.setContent			("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			d_bean.setV_content		("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			
			/***** ��༭ ���� �߼� *****/
			if( !"".equals(receiver_contact) ){
	 			flag2 = ImEmailDb.insertDEmail(d_bean, "5", "", "+7");
			}
			
			
			/* ��༭ ���� �߼� �� CMS �ڵ���ü ��û�� ���� �߰� �߼� */
			if( flag2 ){
				
				if( checkSendCms ){
					
					// �߼� ����� ������� ��쿡�� CMS �ڵ���ü ��û�� �߼���
					if( receiver_contact.equals(mgr_email) && sign_st.equals("1") ){
						doc_code_cms  = "CT"+Long.toString(System.currentTimeMillis());
						DmailBean d_bean_cms = new DmailBean();
						
						d_bean_cms.setSubject				("[�Ƹ���ī] " + firm_nm + " ���� �Ƹ���ī �ڵ���ü��û���Դϴ�.");
						d_bean_cms.setSql						("SSV:"+ receiver_contact);
						d_bean_cms.setReject_slist_idx	(0);
						d_bean_cms.setBlock_group_idx	(0);
						d_bean_cms.setMailfrom				(sender_contact);
						d_bean_cms.setMailto					("\""+ firm_nm +"\"<"+ receiver_contact +">");
						d_bean_cms.setReplyto				("\"�Ƹ���ī\"<no-reply@amazoncar.co.kr>");
						d_bean_cms.setErrosto				("\"�Ƹ���ī\"<return@amazoncar.co.kr>");
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
						d_bean_cms.setU_idx       			(1);	// admin����
						d_bean_cms.setG_idx					(1);	// admin����
						d_bean_cms.setMsgflag     			(0);	
						d_bean_cms.setContent				("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code_cms);
						
						flag4 = ImEmailDb.insertDEmail(d_bean_cms, "4", "", "+7");
					}
					
				}
				
			}
			
		} else if( document_st.equals("3") || document_st.equals("4") ){	// Ȯ�μ�/��û��

			receiver_contact = mgr_email;
			
			d_bean.setSubject			("[�Ƹ���ī] "+firm_nm+" �� �Ƹ���ī ���ڹ����Դϴ�.");
			d_bean.setSql					("SSV:"+ receiver_contact);
			d_bean.setMailto				("\""+ firm_nm +"\"<"+ receiver_contact +">");
			d_bean.setGubun			("docs");
			d_bean.setContent			("https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/email_e_doc.jsp?doc_code="+doc_code);
			
			if( !"".equals(receiver_contact) ){
				flag2 = ImEmailDb.insertDEmail(d_bean, "4", "", "+7");
			}
			
		} 
		
		
	} else if(send_type.equals("talk")){		/*** ģ���� �߼� ***/
		
		// �˸��� �߼� �� �߽��ڴ� ��ȭ��ȣ.
		sender_contact = "02-392-4243";
	
		// ģ���� �޽��� ����
		String talk_msg = firm_nm + " ���� �Ƹ���ī�Դϴ�. ���ڹ����� �߼��մϴ�. \n\n";
		
		String index_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code;	// ���� ���� �ε��� ������ url
		String short_index_url = ShortenUrlGoogle.getShortenUrl(index_url);		// ���� ���� �ε��� ������ url bitlyȭ
		
		talk_msg += short_index_url + " ";
		
		if(document_st.equals("1")){ // ��༭
			
			/* ��༭ �߼� ���(������ ����) üũ. */
			if(document_type.equals("4")){	// ����Ʈ�� �׻� �����
				receiver_contact = mgr_m_tel;
				sign_st = "1";
			} else {
				// ����Ʈ �� ��༭�� ��� �켱����: 1. �°�������(�Ǵ� ����������), 2. ����������, 3. �����(�Ǵ� ����������)
				if( !"".equals(suc_mgr_m_tel) ){
					receiver_contact = suc_mgr_m_tel;	// ������ ����ó = �°�������(�Ǵ� ����������) ��ȭ��ȣ
					sign_st = "3";
				} else if( !"".equals(repre_m_tel) ){
					receiver_contact = repre_m_tel;		// ������ ����ó = ���������� ��ȭ��ȣ
					sign_st = "2";
				} else {
					receiver_contact = mgr_m_tel;			// ������ ����ó = �����(�Ǵ� ����������) ��ȭ��ȣ
					sign_st = "1";
				}
			}
		
			/***** ��༭ ģ���� �߼� *****/
			if( !"".equals(receiver_contact) ){	
				flag2 = at_db.sendMessage(1009, "0", talk_msg, receiver_contact, sender_contact, null, rent_l_cd, user_id);
			}
		
			/* ��༭ ģ���� �߼� �� CMS �ڵ���ü ��û�� ģ���� �߰� �߼� */
			if(flag2){
				
				if( checkSendCms ){
					
					// �߼� ����� ������� ��쿡�� CMS �ڵ���ü ��û�� �߼���
					if( receiver_contact.equals(mgr_m_tel) && sign_st.equals("1") ){
						doc_code_cms  = "CT"+Long.toString(System.currentTimeMillis());
						
						String talk_msg_cms = firm_nm + " ���� �Ƹ���ī�Դϴ�. ���ڹ����� �߼��մϴ�. \n\n";
						
						String index_url_cms = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/index.jsp?doc_code="+doc_code_cms;
						String short_index_url_cms = ShortenUrlGoogle.getShortenUrl(index_url_cms);
						
						talk_msg_cms += short_index_url_cms + " ";
						
						flag4 = at_db.sendMessage(1009, "0", talk_msg_cms, receiver_contact, sender_contact, null, rent_l_cd, user_id);
					}
				
				}
				
			}
		
		} else if( document_st.equals("3") || document_st.equals("4") ){	// Ȯ�μ�/��û��
			
			receiver_contact = mgr_m_tel;
		
			if( !"".equals(receiver_contact) ){	
				flag2 = at_db.sendMessage(1009, "0", talk_msg, receiver_contact, sender_contact, null, rent_l_cd, user_id);
			}
			
		}
		
	}
	
	
	
	if(!flag2 || !flag4 ) return;
	
	
	
	/******************** ���ڹ��� ó�� ********************/
	
	// ��ȿ�Ⱓ. +30��
	String term_dt = AddUtil.getDate(4);
	term_dt = af_db.getValidDt(c_db.addDay(term_dt, 30));
	
	// ���� �� ����. 1: ����, 2: ����, 3: ���λ����, 0: ���� �ʿ� ����
	String sign_client_st	= "";
	
	/***** ���ڹ������� ���̺� ���� �� ������ ó�� *****/
	if( document_st.equals("1") ){	// ��༭
		
		
		/*  ���� �� ���� ó�� */
		switch( sign_st ){
			case "1": 
					sign_client_st = client_st;		// ����� ���� �� ���� �� ������ ������� �� ����
					break;
			case "2":
					sign_client_st = "2";				// ���������� ���� �� ���� �� ������ �׻� 2(����)
					break;
			case "3":
					sign_client_st = suc_client_st;	// �°������� ���� �� ���� �� ������ �°��������� �� ����
					break;
		}
		
		// ���λ������ ���� �� ���� ó��. ���� ���λ���ڿ� �ش��ϴ� �� ���� 3~6�� ��� 3���� ó��.
		if( !sign_client_st.equals("1") && !sign_client_st.equals("2") ){
			sign_client_st = "3";
		}
		
		/* ������ ���� ��(sign_key) ó�� */
		String sign_key = "";
		if(sign_st.equals("1")){	// �����(�Ǵ� ����������)
			
			switch( sign_client_st ){
				case "1": 
					sign_key = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3();	// �����̸� ����ڹ�ȣ
					break;
				case "2":
					sign_key = client.getSsn1();		// �����̸� �������
					break;
				case "3":
					sign_key = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3() + client.getSsn1();	// ���λ���ڸ� ����ڹ�ȣ+�������
					break;
			}
		
		} else if( sign_st.equals("2")){	// ����������
			
			// ���� ��༭ ������ ��ȸ
			Hashtable link_ht = ln_db.getLcRentLinkM(doc_code);
		
			sign_key = String.valueOf(link_ht.get("REPRE_SSN")).substring(2);	// sign_key�� ���������� ������� 6�ڸ� YYYYMMDD
			
		} else if( sign_st.equals("3")){	// �°�������(����������)
			
			Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
			switch( sign_client_st ){
				case "1": 
					sign_key = String.valueOf(begin.get("ENP_NO"));	// �����̸� ����ڹ�ȣ
					break;
				case "2":
					sign_key = String.valueOf(begin.get("SSN"));			// �����̸� �������
					break;
				case "3":
					sign_key = String.valueOf(begin.get("ENP_NO")) + String.valueOf(begin.get("SSN"));	// ���λ���ڸ� ����ڹ�ȣ+�������
					break;
			}
			
		}  
		
		
		/* ���� URL �� pdf_yn ó�� */
		if( !document_type.equals("4") ){		// ��� ��༭(�ű�/����/����, ��� �°�, ����)
			
			doc_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/newcar_doc.jsp?doc_code="+doc_code;
			
			// PDF_YN ó��. ����������(sign_st=2)�̳� �°�������(�Ǵ� ����������, sign_st=3)���� �߼� �� ���� �������� �����Ƿ� pdf_yn = Nó��.
			pdf_yn = sign_st.equals("1") ? "Y" : "N";
			
		} else {		// ����Ʈ ��༭

			doc_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/rmcar_doc.jsp?doc_code="+doc_code+"&cms_type="+cms_type;
			
			if( send_type.equals("park") ){
				receiver_contact = mgr_m_tel;
			}
		}
		
		if( !receiver_contact.equals("") || send_type.equals("park") ){
			
			// �����༭�� ��� ���� ������ �׻� ���ʼ���. ���, �°�, ����Ʈ ��༭�� ���� ���� ���� �������� ����. ���� ����.
			if( document_type.equals("3") ){
				sign_type = "2";
			}
			
			// ���ڹ��� ���� ���̺� ����.
			flag3 = ln_db.insertALinkEdoc(doc_code, doc_type, sign_type, send_type, doc_name, doc_url, firm_nm, receiver_contact, user_id, term_dt, client_id, rent_mng_id, rent_l_cd, "", "", rent_st, sign_st, sign_client_st, pdf_yn, sign_key, doc_code);
			
			/***** CMS �ڵ���ü ��û�� �߰� ���� *****/
			if( checkSendCms ){
				
				// �߼� ����� ������� ��쿡�� CMS �ڵ���ü ��û�� �߼�. ���������� �� �°��������� ��� ���ʿ�.
				if( sign_st.equals("1") && (receiver_contact.equals(mgr_email) || receiver_contact.equals(mgr_m_tel)) ){
				
					String doc_url_cms = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/";
					String doc_name_cms = "";	// CMS ��û�� ������
					String doc_type_cms = "";	// CMS ��û�� ���� ����
					String sign_type_cms = "";	// CMS ��û�� ���� ����
					
					if(sign_client_st.equals("1")){	// ���� ����
						doc_url_cms += "confirm_template_link13.jsp";
						doc_name_cms = "CMS�ڵ���ü��û��(���� ����)";
						doc_type_cms = "3";
						sign_type_cms = "0";
					} else {		// ����/���λ���� ����
						doc_url_cms += "confirm_template_link12.jsp";	
						doc_name_cms = "CMS�ڵ���ü��û��(����/���λ���� ����)";
						doc_type_cms = "4";
						sign_type_cms = "2";
					}
					doc_url_cms += "?doc_code="+doc_code_cms;
					
					// CMS �ڵ���ü ��û�� ������ ����
					flag6 = ln_db.insertALinkEdoc(doc_code_cms, doc_type_cms, sign_type_cms, send_type, doc_name_cms, doc_url_cms, firm_nm, receiver_contact, user_id, term_dt, client_id, rent_mng_id, rent_l_cd, "", "", rent_st, sign_st, sign_client_st, "Y", "", doc_code_cms);
					
				}
				
			}
			
			/***** ����Ʈ ��༭ �߼� �� ����Ʈ �ε��μ��� �߰� ����. *****/
			if( document_type.equals("4") && send_type.equals("park")){
				
				String link_doc_code = doc_code.replace("RM", "");
				
				// �ε��μ��� ������ ��ȸ. ����Ʈ �ε��μ����� Ź�۹�ȣ�� ����Ʈ��༭ ������ȣ�� �����. 
				Hashtable cons_ht = ln_db.getConsignmentLink(link_doc_code);
				
				String doc_code_cons = String.valueOf(cons_ht.get("TMSG_SEQ"));	// ���ڹ������̺� ������ȣ�� �ε��μ��� TMSG_SEQ �÷��� ����.
				String doc_type_cons = "2";		// ���� ���� �ε��μ���
				String sign_type_cons = "2";	// ���� ���� ���ʼ���. 
				String doc_name_cons = "�ε��μ���";	// ������
				String doc_url_cons = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/deli_taking.jsp?doc_code="+doc_code_cons;	// ���� url
				
				// ����Ʈ �ε� �ε��μ��� ������ ����
				flag6 = ln_db.insertALinkEdoc(doc_code_cons, doc_type_cons, sign_type_cons, send_type, doc_name_cons, doc_url_cons, firm_nm, receiver_contact, user_id, term_dt, client_id, rent_mng_id, rent_l_cd, link_doc_code, "", rent_st, sign_st, "0", "Y", "", doc_code_cons);
			}
		}
	
		
	} else if( document_st.equals("3") || document_st.equals("4")){	// Ȯ�μ�/��û��
		
		// ������. Ȯ�μ��� �׻� �������(0), ��û���� �׻� ���ʼ���(2).
		sign_type = document_st.equals("3") ? "0" : "2";		
		
		// ���� url
		doc_url = "https://edoc.amazoncar.co.kr/edoc_fms/acar/e_doc/confirm_template_link"+document_type+".jsp?doc_code="+doc_code;
		if( document_type.equals("2") ){	// �ڵ��� �뿩�̿� ����� Ȯ�μ�
			doc_url += "&view_amt=" + view_amt;
		} else if( document_type.equals("4") ){		// �ڵ��� ���뿩 �뿩���� �������� �ȳ�
			doc_url += "&pay_way=" + pay_way;
		}
		
		// ���� �� ���� ó��
		sign_client_st = client_st;
		
		// ���ڹ��� ���� ���̺� ����.
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
	alert("���� ����");
<%}else if(!flag2){%>
	alert("���ڹ��� �߼� ����");
<%}else if(!flag3){%>
	alert("���ڹ��� ��� ����");
<%-- <%}else if(!flag4){%> --%>
// 	alert("CMS�����ü��û�� �߼� ����");
<%-- <%}else if(!flag6){%> --%>
// 	alert("CMS�����ü��û�� ��� ����");
<%}else{%>
	
	alert("���������� �߼۵Ǿ����ϴ�.");
	var fm = document.form1;
	<%if( document_st.equals("1") ){				// ��༭ %>
		fm.action='cont_doc_send.jsp';	
	<%} else if( document_st.equals("3") || document_st.equals("4") ){	// Ȯ�μ� %>
		fm.action='confirm_doc_send.jsp';	
	<%}%>
	fm.submit();
	
	<%if(document_st.equals("1") && document_type.equals("4") && send_type.equals("park") ){ // ����Ʈ��༭ ���� ���� ��%>
		var doc_url = '<%=doc_url%>';
		window.open(doc_url, 'doc');
	<%}%>
	
<%}%>

</script>
</body>
</html>