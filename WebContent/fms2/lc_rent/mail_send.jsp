<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, tax.*, acar.estimate_mng.*, acar.common.* " %>
<%@ page import="acar.cont.*,acar.client.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.im_email.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          	scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      	scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>


<%@ include file="/acar/cookies.jsp" %>

<% 
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String content_st 	= request.getParameter("content_st")==null?"":request.getParameter("content_st");	
		
	String mail_addr 	= request.getParameter("mail_addr")==null?"":request.getParameter("mail_addr");
	String replyto_st 	= request.getParameter("replyto_st")==null?"1":request.getParameter("replyto_st");
	String replyto 		= request.getParameter("replyto")==null?"":request.getParameter("replyto");	
	String tel_number 	= request.getParameter("tel_number")==null?"":request.getParameter("tel_number");	
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();			
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//해당대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//자동차등록정보
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	
	LcScanBean scan17 = new LcScanBean();
	LcScanBean scan18 = new LcScanBean();
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	
	int attach_17_vt_size = 0;	
	int attach_18_vt_size = 0;	
	
	content_code = "LC_SCAN";
	content_seq  = rent_mng_id+""+rent_l_cd+""+rent_st+"17";

	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size = attach_vt.size();
	attach_17_vt_size = attach_vt_size;
		
	if(attach_vt_size > 0){
		for (int j = 0 ; j < attach_vt_size ; j++){
    			Hashtable ht = (Hashtable)attach_vt.elementAt(j);   
    			scan17.setFile_name(String.valueOf(ht.get("SAVE_FOLDER"))+""+String.valueOf(ht.get("SAVE_FILE")));
    			scan17.setFile_type(String.valueOf(ht.get("FILE_TYPE")));
    			scan17.setSeq(String.valueOf(ht.get("SEQ")));
    		}
    	}		
	content_code = "LC_SCAN";
	content_seq  = rent_mng_id+""+rent_l_cd+""+rent_st+"18";

	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size = attach_vt.size();
	attach_18_vt_size = attach_vt_size;	
		
	if(attach_vt_size > 0){
		for (int j = 0 ; j < attach_vt_size ; j++){
    			Hashtable ht = (Hashtable)attach_vt.elementAt(j);   
    			scan18.setFile_name(String.valueOf(ht.get("SAVE_FOLDER"))+""+String.valueOf(ht.get("SAVE_FILE")));
    			scan18.setFile_type(String.valueOf(ht.get("FILE_TYPE")));
    			scan18.setSeq(String.valueOf(ht.get("SEQ")));
    		}
    	}		
    		
	
	int mail_send_chk = 0;
	String mail_send_yn = "Y";
	
	
	if(content_st.equals("newcar_doc")){
		if(scan17.getFile_type().equals(".jpg") || scan17.getFile_type().equals(".JPG") || scan17.getFile_type().equals("image/jpeg") || scan17.getFile_type().equals("image/pjpeg")){
			mail_send_chk++;
		}
	
		if(scan18.getFile_type().equals(".jpg") || scan18.getFile_type().equals(".JPG") || scan18.getFile_type().equals("image/jpeg") || scan18.getFile_type().equals("image/pjpeg")){
			mail_send_chk++;
		}
		
		if(mail_send_chk < 2) mail_send_yn = "N";
	}
	
	
	//System.out.println("메일발송 : mail_addr="+mail_addr);
	//System.out.println("rent_l_cd 	="+rent_l_cd);	
	//System.out.println("rent_st 	="+rent_st);	
	//System.out.println("content_st 	="+content_st);
	//System.out.println("reg_id 	="+ck_acar_id);	
	//System.out.println("mail_send_yn ="+mail_send_yn);	
	
		//발신자 사용자 정보 조회
	user_bean 	= umd.getUsersBean(ck_acar_id);
	
	
	//수신메일	
	String user_email = "";
	
	user_email = "sales@amazoncar.co.kr";

	//회사메일
	if(replyto_st.equals("1")){
		replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
	//사용자등록메일
	}else if(replyto_st.equals("2")){
		replyto = "\"아마존카 "+user_bean.getUser_nm()+"\"<"+user_bean.getUser_email()+">";
		
		//회신메일이 아마존카이면 발신메일도 회신메일로 한다.
		if (replyto.indexOf("@amazoncar.co.kr") != -1){
			user_email = user_bean.getUser_email();
		}
			
	//직접입력
	}else if(replyto_st.equals("3")){
		if(!replyto.equals("")){
		
			//회신메일이 아마존카이면 발신메일도 회신메일로 한다.
			if (replyto.indexOf("@amazoncar.co.kr") != -1){
				user_email = replyto;
			}		
			replyto = "\"아마존카\"<"+replyto+">";
			
		}else{
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
		}
	}
	
	
	String mail_code  = Long.toString(System.currentTimeMillis());
	
	DmailBean d_bean = new DmailBean();
	d_bean.setSql				("SSV:"+mail_addr.trim());
	d_bean.setReject_slist_idx	(0);
	d_bean.setBlock_group_idx	(0);
	d_bean.setMailfrom			(replyto);
	d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+mail_addr.trim()+">");
	d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
	d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");
	d_bean.setHtml				(1);
	d_bean.setEncoding			(0);
	d_bean.setCharset			("euc-kr");
	d_bean.setDuration_set		(1);
	d_bean.setClick_set			(0);
	d_bean.setSite_set			(0);
	d_bean.setAtc_set			(0);
	d_bean.setGubun				(rent_l_cd+""+rent_st);
	d_bean.setGubun2			(mail_code+""+content_st);
	d_bean.setRname				("mail");
	d_bean.setMtype     	  	(0);
	d_bean.setU_idx      		(1);//admin계정
	d_bean.setG_idx				(1);//admin계정
	d_bean.setMsgflag     		(0);	
	
	//회사메일
	if(replyto_st.equals("1")){
		d_bean.setV_mailfrom		("sales@amazoncar.co.kr");		
	//사용자등록메일
	}else if(replyto_st.equals("2")){
		d_bean.setV_mailfrom		(user_bean.getUser_email());		
	//직접입력
	}else if(replyto_st.equals("3")){
		if(!replyto.equals("")){
			d_bean.setV_mailfrom	(request.getParameter("replyto")==null?"":request.getParameter("replyto"));			
		}else{
			d_bean.setV_mailfrom	("sales@amazoncar.co.kr");			
		}
	}	
	
	d_bean.setV_mailto			(mail_addr);
					
	if(content_st.equals("newcar_doc")){
		d_bean.setSubject		("[아마존카] "+client.getFirm_nm()+" 님의 자동차대여이용 연장계약서 입니다.");	
		d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/rent/renew_email.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&mail_code="+mail_code);
		d_bean.setV_content		("http://fms1.amazoncar.co.kr/mailing/rent/renew_email.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&mail_code="+mail_code);
		
		//파일첨부
		d_bean.setEncoding		(3); //파일첨부
		//d_bean.setAtc_set		(2); //첨부갯수  : _f를 쓰고 실제 메일첨부를 하지는 않는다. 파일서버에 접근이 어렵다.
	}

	
	boolean flag = true;
		
	
	if(mail_send_yn.equals("Y")){
			
		flag = ImEmailDb.insertDEmail(d_bean, "5", "", "+7");
	
	
		if(content_st.equals("newcar_doc")){
		
	
			//파일첨부-연장계약서앞
			String add_fileinfo 		= "연장계약서_"+cr_bean.getCar_no()+"_"+AddUtil.ChangeDate(fee.getRent_dt(),"YYYYMM")+"_1_"+AddUtil.subDataCut(client.getFirm_nm(),15)+".jpg";
			String add_content 		= "https://fms3.amazoncar.co.kr/data/"+AddUtil.replace(AddUtil.replace(scan17.getFile_path(),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/")+""+scan17.getFile_name()+""+scan17.getFile_type();			

			if(attach_17_vt_size>0){				
				add_content 		= "https://fms3.amazoncar.co.kr"+scan17.getFile_name();			
			}

			
			flag = ImEmailDb.insertDEmailEnc("5", d_bean.getGubun(), d_bean.getGubun2(), add_fileinfo, add_content, scan17.getSeq(), add_fileinfo);
	
			//파일첨부-연장계약서뒤
			add_fileinfo 			= "연장계약서_"+cr_bean.getCar_no()+"_"+AddUtil.ChangeDate(fee.getRent_dt(),"YYYYMM")+"_2_"+AddUtil.subDataCut(client.getFirm_nm(),15)+".jpg";
			add_content 			= "https://fms3.amazoncar.co.kr/data/"+AddUtil.replace(AddUtil.replace(scan18.getFile_path(),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/")+""+scan18.getFile_name()+""+scan18.getFile_type();

			if(attach_18_vt_size>0){				
				add_content 		= "https://fms3.amazoncar.co.kr"+scan18.getFile_name();			
			}
					
			
			flag = ImEmailDb.insertDEmailEnc("5", d_bean.getGubun(), d_bean.getGubun2(), add_fileinfo, add_content, scan18.getSeq(), add_fileinfo);
			
						
			//문자발송
			if(!tel_number.equals("") && AddUtil.lengthb(tel_number) >= 10){				
				String sendphone 	= user_bean.getUser_m_tel();
				String sendname 	= "(주)아마존카 "+user_bean.getUser_nm();
				String destphone 	= tel_number;				
				String destname 	= client.getFirm_nm();
				
				//String msg_cont		= client.getFirm_nm()+" 님의 자동차대여이용 연장계약서를 "+mail_addr+"로 메일발송하였습니다. 확인바랍니다. - 아마존카-";
				String msg_cont		= client.getFirm_nm()+" 고객님 안녕하십니까, 아마존카입니다. 고객님의 담당자 "+sendname+" "+sendphone+" 님이 자동차대여이용 연장계약서를 "+mail_addr+"로 메일발송하였습니다. 확인 후 처리바랍니다. (주)아마존카 www.amazoncar.co.kr";
				
				String msg_type = "0";
				String msg_subject = "0";				
				int msg_len = 0;
			
				msg_len = AddUtil.lengthb(msg_cont);
		
				if(msg_len>80){
					msg_type = "5";
					msg_subject = "연장계약서 메일발송 알림";
				}
				
		
				// jjlim add alimtalk
				// acar0050 연장계약서 메일발송 알림
				if (!destphone.equals("") && !destphone.equals("-") && !destphone.equals("--")) {
					String customer_name = client.getFirm_nm();				// 고객 이름
					String manager_name = user_bean.getUser_nm();			// 매니저 이름
					String manager_phone = user_bean.getUser_m_tel();		// 매니저 전화
					String customer_email = mail_addr;						// 고객 이메일
					String etc1 = rent_l_cd;
					String etc2 = ck_acar_id;
					
					Date today = new Date();
					SimpleDateFormat format = new SimpleDateFormat("yyyy년 MM월 dd일");
					String reg_date = String.valueOf(format.format(today));
					
					//acar0050->acar0084->acar0155
					List<String> fieldList = Arrays.asList(customer_name, reg_date, customer_email, manager_name, manager_phone);
					at_db.sendMessageReserve("acar0155", fieldList, destphone, sendphone, null , etc1,  etc2);
				}


			}
		}
	}
	

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">



</script>
</head>
<body>
<script language="JavaScript">
<!--
<%if(flag){%>
	alert("메일이 정상적으로 발송 되었습니다.");
	parent.window.close();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.window.close();				
<%}%>
//-->
</script>
</body>
</html>




