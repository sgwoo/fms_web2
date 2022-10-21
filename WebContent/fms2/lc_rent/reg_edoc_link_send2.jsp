<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.alink.*, acar.coolmsg.*, acar.user_mng.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<% 
	String auth_rw 				= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 				= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 					= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 					= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 					= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 					= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 				= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 				= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 				= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 				= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 				= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 					= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 				= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 			= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 			= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat	 			= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	String link_table 			= request.getParameter("link_table")==null?"":request.getParameter("link_table");
	String link_type 			= request.getParameter("link_type")==null?"":request.getParameter("link_type");
	String link_rent_st 		= request.getParameter("link_rent_st")==null?"":request.getParameter("link_rent_st");
	String link_im_seq 		= request.getParameter("link_im_seq")==null?"":request.getParameter("link_im_seq");

	String link_com 			= request.getParameter("link_com")==null?"":request.getParameter("link_com");
	
	String mgr_nm 				= request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm");
	String mgr_email 			= request.getParameter("mgr_email")==null?"":request.getParameter("mgr_email");
	String mgr_m_tel 			= request.getParameter("mgr_m_tel")==null?"":request.getParameter("mgr_m_tel");
	String mgr_cng 			= request.getParameter("mgr_cng")==null?"":request.getParameter("mgr_cng");
	
	//공동임차인 추가(20190613)
	String repre_email 		= request.getParameter("repre_email")==null?"":request.getParameter("repre_email");
	
	String suc_mgr_nm 		= request.getParameter("suc_mgr_nm")==null?"":request.getParameter("suc_mgr_nm");
	String suc_mgr_email 	= request.getParameter("suc_mgr_email")==null?"":request.getParameter("suc_mgr_email");
	String suc_mgr_m_tel 	= request.getParameter("suc_mgr_m_tel")==null?"":request.getParameter("suc_mgr_m_tel");
	
	String send_alert 			= request.getParameter("send_alert")==null?"":request.getParameter("send_alert");
	String cms_type 			= request.getParameter("cms_type")==null?"":request.getParameter("cms_type");
	String bus_id 	= request.getParameter("bus_id")==null?"":request.getParameter("bus_id");
	String bus_st 	= request.getParameter("bus_st")==null?"":request.getParameter("bus_st");
	String cms_mail_yn 	= request.getParameter("cms_mail_send_yn")==null?"":request.getParameter("cms_mail_send_yn");
	
	// 대표자 선택
	String client_repre_st 	= request.getParameter("client_repre_st")==null?"":request.getParameter("client_repre_st");
	
	// 전자계약서 구분 선택(1: 공동인증, 2: 비대면)
	String doc_st = request.getParameter("doc_st")==null?"":request.getParameter("doc_st");
	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String sender = "";
	if(bus_st.equals("7") && user_id.equals("000057")){ // 계약 구분이 에이전트 계약이고 고연미 과장님일 경우 발신자를 최초영업자로.
		sender = bus_id;
	} else {
		sender = user_id;
	}
	
	if(link_table.equals("rm_rent_link") && link_com.equals("2")){
		link_table = "rm_rent_link_m";
	}
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag7 = true;	
	
	Hashtable ht = new Hashtable();
	
	String doc_code  = Long.toString(System.currentTimeMillis());
	String doc_code2  = "";
	
// 	if(!client_repre_st.equals("")){
		boolean flag8 = a_db.updateClientRepreSt(client_repre_st, rent_mng_id, rent_l_cd);
// 	}
	
	int alink_y_count = ln_db.getALinkCntY(link_table, rent_l_cd, link_rent_st);
	
	if(alink_y_count == 0){
		
		//전자문서 전송데이터 처리		
// 		flag1 = ln_db.insertALink2(doc_code, link_table, link_type, rent_l_cd, link_rent_st, link_im_seq, mgr_nm, mgr_email, mgr_m_tel, user_id, suc_mgr_nm, suc_mgr_email, suc_mgr_m_tel, link_com, cms_type, repre_email);
 		flag1 = ln_db.insertALink2(doc_code, link_table, link_type, rent_l_cd, link_rent_st, link_im_seq, mgr_nm, mgr_email, mgr_m_tel, sender, suc_mgr_nm, suc_mgr_email, suc_mgr_m_tel, link_com, cms_type, repre_email, doc_st, cms_mail_yn);
		
		//계약담당자 업데이트
		if(flag1 && mgr_cng.equals("Y") && link_table.equals("lc_rent_link_m")){
			//계약담당자
			CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "계약담당자");
			mgr.setMgr_nm			(mgr_nm);
			mgr.setMgr_email	(mgr_email.trim());
			mgr.setMgr_m_tel	(mgr_m_tel);
			//=====[CAR_MGR] update=====
			flag2 = a_db.updateCarMgrNew(mgr);
		}
	
		//전자문서 전송 함수 타기 : 데이터코리아
		if(flag1){
			ht = ln_db.getALink(link_table, doc_code);
			
			if((link_type.equals("1") || link_type.equals("3")) && (String.valueOf(ht.get("CAR_ST")).equals("리스plus 기본식") || String.valueOf(ht.get("CAR_ST")).equals("리스plus 일반식"))){
				ht.put("DOC_TYPE","7");
			}
			if(link_type.equals("2") && (String.valueOf(ht.get("CAR_ST")).equals("리스plus 기본식") || String.valueOf(ht.get("CAR_ST")).equals("리스plus 일반식"))){
				ht.put("DOC_TYPE","8");
			}	
			
			if(String.valueOf(ht.get("COMPANY_NAME")).equals("")){
				flag1 = false;
			}
			
			//알림톡 메세지 송신(20190509)
			/* String customer_name 	= mgr_nm;
			String customer_email 	= mgr_email;
			String car_name 			= String.valueOf(ht.get("CAR_NM"));
			String manager_name 	= String.valueOf(ht.get("ACAR_USER_NM"));
			String manager_phone 	= String.valueOf(ht.get("ACAR_USER_TEL"));
			String customer_m_tel 	= mgr_m_tel;
			
			if(customer_m_tel.length() > 9){
				List<String> fieldList = Arrays.asList(customer_name, car_name, customer_email, manager_name, manager_phone);
				flag7 = at_db.sendMessageReserve("acar0217", fieldList, customer_m_tel, manager_phone, null, null, null);
			}
			if(!suc_mgr_m_tel.equals("") && !suc_mgr_email.equals("")){	//승계계약 기존임차인
				if(suc_mgr_m_tel.length() > 9){
					List<String> fieldList = Arrays.asList(suc_mgr_nm, car_name, suc_mgr_email, manager_name, manager_phone);
					flag7 = at_db.sendMessageReserve("acar0217", fieldList, suc_mgr_m_tel, manager_phone, null, null, null);
				}
			} */
			
			if(flag1 &&(!suc_mgr_email.equals("")||!repre_email.equals(""))){	//전자계약서 전송순서 메세지
				String sub 		= "전자계약서 메일 전송순서";
				String cont 		= "["+ rent_l_cd+" ] 계약건 전자계약서 발송순서  &lt;br&gt; &lt;br&gt;  ";
				if(!suc_mgr_email.equals("")){		cont += suc_mgr_email +"(기존임차인) - ";		}
				if(!repre_email.equals("")){			cont += repre_email +"(공동임차인) - ";			}
				cont += mgr_email +"(계약자) 순으로  &lt;br&gt; &lt;br&gt; 이전단계에서 승인하면 다음수신자에게 발송됩니다.";
				//사용자 정보 조회
				UserMngDatabase umd = UserMngDatabase.getInstance();
				UsersBean target_bean 	= umd.getUsersBean(user_id);

				String xml_data = "";
				xml_data =  "<COOLMSG>"+
									 "<ALERTMSG>"+
	  								 "    <BACKIMG>4</BACKIMG>"+
									 "    <MSGTYPE>104</MSGTYPE>"+
									 "    <SUB>"+sub+"</SUB>"+
			  						 "    <CONT>"+cont+"</CONT>"+
									 "    <URL></URL>";
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				xml_data += "    <SENDER></SENDER>"+
	  								 "    <MSGICON>10</MSGICON>"+
									 "    <MSGSAVE>1</MSGSAVE>"+
	  								 "    <LEAVEDMSG>1</LEAVEDMSG>"+
									 "    <FLDTYPE>1</FLDTYPE>"+
	  								 "  </ALERTMSG>"+
									 "</COOLMSG>";
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");

				boolean flag_msg = cm_db.insertCoolMsg(msg);
			}
		}
		
	}else{
		flag1 = false;
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
<form name='form1' action='reg_edoc_link2.jsp' method='post' target="EDOC_LINK2">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 		value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>      
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="now_stat" 		value="<%=now_stat%>">   
  <input type='hidden' name="link_table" 	value="<%=link_table%>">  
  <input type='hidden' name="link_type" 	value="<%=link_type%>">  
  <input type='hidden' name="link_rent_st" 	value="<%=link_rent_st%>">  
  <input type='hidden' name="link_im_seq" 	value="<%=link_im_seq%>">  
</form>
<script language="JavaScript">
<!--
<%if(flag1){%>
	
	alert("정상적으로 발송 되었습니다.");
	var fm = document.form1;		
	fm.action='reg_edoc_link2.jsp';		
	fm.target='EDOC_LINK2';
	fm.submit();
	
<%}else{%>

	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	<%if(alink_y_count > 0){%>
		alert("이미 전송된 전자문서가 있습니다.");
	<%}%>

<%}%>

//-->
</script>
</body>
</html>