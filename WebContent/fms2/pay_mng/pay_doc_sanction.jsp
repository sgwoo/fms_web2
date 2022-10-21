<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.cont.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	String non_id2 	= request.getParameter("non_id2")==null?"N":request.getParameter("non_id2");
	String non_id3 	= request.getParameter("non_id3")==null?"N":request.getParameter("non_id3");
	String at_once 	= request.getParameter("at_once")==null?"":request.getParameter("at_once");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int flag = 0;
	int result = 0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	DocSettleBean doc = new DocSettleBean();
	
	doc = d_db.getDocSettle(doc_no);
	
	UsersBean reger_bean 	= umd.getUsersBean(doc.getUser_id1());
%>


<%
	if(doc_no.equals("") && doc_bit.equals("1")){
	
		String reqseq[]	= request.getParameterValues("reqseq");
		
		int    size	 	= request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
		String est_dt	= request.getParameter("est_dt")==null?"":request.getParameter("est_dt");
		
		String doc_code = Long.toString(System.currentTimeMillis());
		
		for(int i = 0 ; i < size ; i++){
			
			//1. 출금원장 수정-------------------------------------------------------------------------------------------
			
			PayMngBean pay 	= pm_db.getPay(reqseq[i]);
			
			pay.setDoc_code		(doc_code);
			pay.setP_est_dt2	(est_dt);
			pay.setP_step		("2");
			
			//=====[PAY_LEGDER] update=====
			if(!pm_db.updatePayD(pay)) flag += 1;
			
		}
		
		//2. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		String sub 		= "출금원장결재";
		String cont 	= "출금원장 결재를 요청합니다.";
		String target_id = "";
		
		doc.setDoc_st	("31");
		doc.setDoc_id	(doc_code);
		doc.setSub	(sub);
		doc.setCont	(cont);
		doc.setEtc	("");
		doc.setUser_nm1	("기안자");
		doc.setUser_nm2	("지점장");
		doc.setUser_nm3	("총무팀장");
		
		String user_id1 = user_id;
		String user_id2 = "";
		String user_id3 = nm_db.getWorkAuthUser("본사총무팀장");

		
		if(br_id.equals("B1")){
			user_id2 = nm_db.getWorkAuthUser("부산지점장");
			doc.setUser_id2(user_id2);
			doc.setDoc_step("1");
			if(non_id2.equals("1") || at_once.equals("Y")){
				user_id2 = "XXXXXX";
				doc.setUser_id2(user_id2);
				doc.setDoc_step("2");
			}
		}else if(br_id.equals("D1")){
			user_id2 = nm_db.getWorkAuthUser("대전지점장");
			doc.setUser_id2(user_id2);
			doc.setDoc_step("1");
			if(non_id2.equals("1") || at_once.equals("Y")){
				user_id2 = "XXXXXX";
				doc.setUser_id2(user_id2);
				doc.setDoc_step("2");
			}
		}else if(br_id.equals("G1")){
			user_id2 = nm_db.getWorkAuthUser("대구지점장");
			doc.setUser_id2(user_id2);
			doc.setDoc_step("1");
			if(non_id2.equals("1") || at_once.equals("Y")){
				user_id2 = "XXXXXX";
				doc.setUser_id2(user_id2);
				doc.setDoc_step("2");
			}
		}else if(br_id.equals("J1")){
			user_id2 = nm_db.getWorkAuthUser("광주지점장");
			doc.setUser_id2(user_id2);
			doc.setDoc_step("1");
			if(non_id2.equals("1") || at_once.equals("Y")){
				user_id2 = "XXXXXX";
				doc.setUser_id2(user_id2);
				doc.setDoc_step("2");
			}
		}else{
			user_id2 = "XXXXXX";
			doc.setUser_id2(user_id2);
			doc.setDoc_step("2");
		}
		
		doc.setUser_id1	(user_id1);
		doc.setUser_id2	(user_id2);
		doc.setUser_id3	(user_id3);
		doc.setDoc_bit	("1");
		
		
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
		
		//out.println("문서처리전 등록<br>");
		
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/pay_mng/pay_d_frame.jsp";
		String m_url = "/fms2/pay_mng/pay_d_frame.jsp";
		target_id = doc.getUser_id2();
		
		if(doc.getDoc_step().equals("2"))	target_id = doc.getUser_id3();
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";		
		
		//보낸사람
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
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저(출금원장대금결재기안)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm());
	}
	
	if(!doc_no.equals("") && doc_bit.equals("2")){
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		String doc_step = "2";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		out.println("문서처리전 결재<br>");
		
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/pay_mng/pay_d_frame.jsp";
		String sub 		= "출금원장결재";
		String cont 	= "출금원장 결재를 요청합니다.";
		String m_url = "/fms2/pay_mng/pay_d_frame.jsp";
		String target_id = "";
		
		target_id = doc.getUser_id3();
		
		
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getUser_id().equals("")){
			//팀장휴가시 출금담당자가 전결처리
			CarScheBean cs_bean2 = csd.getCarScheTodayBean(nm_db.getWorkAuthUser("출금담당"));
			if(!cs_bean2.getUser_id().equals("")){
				if(!cs_bean2.getWork_id().equals("")){
					target_id = cs_bean2.getWork_id();
				}else{
					target_id = nm_db.getWorkAuthUser("출금담당");
				}
			}else{
				target_id = nm_db.getWorkAuthUser("출금담당");//총무팀장 휴가시 출금담당자가 전결처리
			}
		}
		
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
		//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		//보낸사람
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
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저(출금원장대금결재요청)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm());
	}
	
	if(!doc_no.equals("") && doc_bit.equals("3")){
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		String doc_step = "3";
		
		if(non_id3.equals("1")){
			//=====[doc_settle] update=====
			flag2 = d_db.updateDocSettleNon(doc_no, user_id, doc_bit, doc_step);
		}else{
			//=====[doc_settle] update=====
			flag2 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		}
		out.println("문서처리전 결재<br>");
		
		if(!from_page.equals("/fms2/pay_mng/pay_m_frame.jsp")){//사후결재에는 필요없다.
			
			//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
			
			String url 		= "/fms2/pay_mng/pay_a_frame.jsp";
			String sub 		= "출금결재 완결";
			String cont 	= "출금문서 지출을 결재 완결하니 출금 집행하세요";
			String target_id = "";
			String m_url = "/fms2/pay_mng/pay_a_frame.jsp";
			target_id = nm_db.getWorkAuthUser("영업수당회계관리자");
			
			if(reger_bean.getBr_id().equals("B1")||reger_bean.getBr_id().equals("G1"))		target_id = nm_db.getWorkAuthUser("부산출납");
			else if(reger_bean.getBr_id().equals("D1")||reger_bean.getBr_id().equals("J1"))		target_id = nm_db.getWorkAuthUser("대전출납");
			else											target_id = nm_db.getWorkAuthUser("영업수당회계관리자");
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals("")){
				if(!cs_bean.getWork_id().equals("")){
					target_id = cs_bean.getWork_id();
				}else{
					target_id = nm_db.getWorkAuthUser("입금담당");
				}
			}
			
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
	  					"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
  						"    <CONT>"+cont+"</CONT>"+
  						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			
			//받는사람
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
//			target_id = nm_db.getWorkAuthUser("영업수당회계관리자");
//			target_bean = umd.getUsersBean(target_id);
//			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
			//보낸사람
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
			
			flag2 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저(출금원장대금결재완료)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm());
		}
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 			value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 			value='<%=gubun5%>'>      
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
	parent.window.close();
//	parent.opener.location.reload();
</script>
</body>
</html>