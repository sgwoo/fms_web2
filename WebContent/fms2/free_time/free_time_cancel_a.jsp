<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.free_time.*,  acar.car_sche.*, acar.coolmsg.*, acar.doc_settle.*"%>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="fc_bean" class="acar.free_time.Free_CancelBean" scope="page"/>
<jsp:useBean id="ft_bean" class="acar.free_time.Free_timeBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<%@ include file="/acar/cookies.jsp" %>
<%
	Free_timeDatabase fsd = Free_timeDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //의뢰자
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String doc_no 			= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String cancel_tit 	= request.getParameter("cancel_tit")==null?"":request.getParameter("cancel_tit");
	String cancel_cmt 	= request.getParameter("cancel_cmt")==null?"":request.getParameter("cancel_cmt");
	String cancel_dt 	= request.getParameter("cancel_dt")==null?"":request.getParameter("cancel_dt");
			
	
	String cancel 	= request.getParameter("cancel")==null?"":request.getParameter("cancel");
	
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	String start_date = request.getParameter("start_date")==null?"":request.getParameter("start_date");
	String end_date = request.getParameter("end_date")==null?"":request.getParameter("end_date");
	
	int count = 0;
	
	int count2 = 0;
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag6 = true;
    boolean flag = true;
	   
	String target_id1 	= "";

	String target_id 	= "";
	String sender_id 	= "";
		
	String login_id 	= request.getParameter("login_id")==null?ck_acar_id:request.getParameter("login_id");	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(user_id);
	CarSchDatabase c_sd = CarSchDatabase.getInstance();
			
			//문서품의
	DocSettleBean doc = new DocSettleBean();

	doc = d_db.getDocSettleOver_time("22", doc_no);
		
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
	if(sender_bean.getDept_id().equals("0001")  ) {  		// 
			target_id1 = "000028";						// 타겟은 000028 (영업부 팀장-김진좌)
	
	}else if( sender_bean.getDept_id().equals("0020")   ) { //영업 기획
			target_id1 = "000005";	
		
	}else if( sender_bean.getDept_id().equals("0002") ||   sender_bean.getDept_id().equals("0014")  || sender_bean.getDept_id().equals("0015")  ) { //고객지원
			target_id1 = "000026";
						
	}else if(sender_bean.getDept_id().equals("0013") ||sender_bean.getDept_id().equals("0009") ||sender_bean.getDept_id().equals("0012")  ||sender_bean.getDept_id().equals("0017")   ||sender_bean.getDept_id().equals("0018")  ) { //수원
			if( sender_bean.getLoan_st().equals("1")){ //관리
				target_id1 = "000026";
			}else { //영업
				target_id1 = "000028";
			}
						
	}else if(sender_bean.getDept_id().equals("0003")) {
			target_id1 = "000004";
					
	}else if(sender_bean.getDept_id().equals("0005")) {
			target_id1 = "000237";
				
	}else if( sender_bean.getDept_id().equals("0007") ||  sender_bean.getDept_id().equals("0016")   ) {
			if(sender_bean.getUser_id().equals("000053")){
				target_id1 = "000004";
			}else{
				target_id1 = "000053";
			}
			
	}else if(sender_bean.getDept_id().equals("0008")) {
			if(sender_bean.getUser_id().equals("000052")){
				target_id1 = "000004";
			}else{
				target_id1 = "000052";
			}
	}else if(sender_bean.getDept_id().equals("0010")) {//광주지점 은 박영규차장 , 오성호과장 연차시 총무팀장
			if(sender_bean.getUser_id().equals("000219")){
				target_id1 = "000004";
			}else{
				target_id1 = "000219";
			}
	}else if(sender_bean.getDept_id().equals("0011")) {		//대구지점 윤영탁대리, 윤영탁대리 연차시 총무팀장
			if(sender_bean.getUser_id().equals("000054")){
				target_id1 = "000004";
			}else{
				target_id1 = "000054";
			}
	}
			
	
	CarScheBean cs_bean2 = c_sd.getCarScheTodayBean(target_id1);  	
					
			//담당팀장 연차시 결재 skip 
	if(!cs_bean2.getWork_id().equals("")) target_id1 = "XXXXXX"; //생략		
		

	if(cmd.equals("i")){
	
		fc_bean.setDoc_no(doc_no);
		fc_bean.setUser_id(user_id);
		fc_bean.setCancel_dt(cancel_dt);
		fc_bean.setCancel_tit(cancel_tit);
		fc_bean.setCancel_cmt(cancel_cmt);

		if (target_id1.equals("XXXXXX")) {
				fc_bean.setCm_check("Y");	//팀장연차시	
		}
			
		count = fsd.InsertCancelFree(fc_bean);

		ft_bean.setCancel(cancel);
		ft_bean.setUser_id(user_id);
		ft_bean.setDoc_no(doc_no);
		
		count2 = fsd.UpdateCancel(ft_bean);
		
		
		
		
//1. 문서처리전 등록-------------------------------------------------------------------------------------------					
		
		String sub 		= "연차취소 신청 등록 안내";
		String cont 	= "["+sender_bean.getUser_nm()+"]님의 휴가 취소신청서 결재를 요청합니다.";
						
		doc.setDoc_st("22");//연차취소신청
		doc.setDoc_id(doc_no);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		doc.setUser_nm1("연차취소");
		doc.setUser_nm2("부서팀장");		
		
		doc.setUser_id1(user_id);
		doc.setUser_id2(target_id1);		

		if (target_id1.equals("XXXXXX")) {
				doc.setDoc_bit("2");//결재 skip
				doc.setDoc_step("3");//기안			
		} else {
				doc.setDoc_bit("1");//수신단계
				doc.setDoc_step("1");//기안		
		}			
				
//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
						
		//문서처리전 등록 끝	
		if (target_id1.equals("XXXXXX")) { //팀장연차시 결재 skip
		//	count2 = fsd.Cancel_free(user_id, start_date, end_date);  //년차 삭제						
			flag =  fsd.UpdateCancel_freetime(doc_no, user_id);
				
				
		}	
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
				
		//사용자 정보 조회				
		target_id = doc.getUser_id2();
			
		if (!target_id.equals("XXXXXX")) {	
			UsersBean target_bean 	= umd.getUsersBean(target_id);
		
			String url 		= "/fms2/free_time/free_time_cancel_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
	//		String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_cancel_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
			String m_url = "/fms2/free_time/free_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
			
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
		
			flag6 = cm_db.insertCoolMsg(msg);		
			
			System.out.println("쿨메신저(연차취소 신청)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );		
			
		    // 메신져 끝		
		}
		
			
		//대체근무정보
		Hashtable ht3= fsd.getFree_work(user_id, doc_no);
		
		if (!String.valueOf(ht3.get("W_ID")).equals("")) {	
			//업무대체자한테 연차취소 안내
			UsersBean target_bean 	= umd.getUsersBean(String.valueOf(ht3.get("WORK_ID")));
	
			sub 		= "휴가결재 취소 안내";
			cont 	= "["+sender_bean.getUser_nm()+"]님의 휴가가 취소되어 대체근무자("+target_bean.getUser_nm()+") 지정도 자동취소되었습니다.";	
			String xml_data = "";
								
			xml_data = "";	
			xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL></URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>"; //받는사람
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+	//보낸사람
		 			"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
	
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");	
	
			flag6 = cm_db.insertCoolMsg(msg);
		}
		
		
		
	}else if(cmd.equals("c")){ //팀장 결재
		
	
	//	count2 = fsd.Cancel_free(user_id, start_date, end_date,);  //년차 삭제		
	
		flag =  fsd.UpdateCancel_freetime(doc_no, user_id);
		
		count = fsd.UpdateCancel_check(doc_no, user_id);
		
		
	//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		login_id = doc.getUser_id2();
					
		flag1 = d_db.updateDocSettleOt2(doc_no, "2", "3", login_id, "22");			
		
		//3. 쿨메신저 알람 등록----------------------------------------------------------------------------------------

	    target_id = doc.getUser_id1();			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		sender_id = doc.getUser_id2();			
		UsersBean sender_bean1 	= umd.getUsersBean(sender_id);
						
						
		String sub 		= "휴가 취소 결재 안내";
// 		String cont 	= "["+target_bean.getUser_nm()+"]님의 휴가 취소신청서에 결재가 완료되었습니다. 확인바랍니다.";
		String cont 	= "["+target_bean.getUser_nm()+"]님의 휴가 취소요청이 결재되었습니다.";
	//	String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
		String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
		String xml_data = "";
		String m_url = "/fms2/free_time/free_time_frame.jsp";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
	
	
		//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
		//보낸사람
		xml_data += "    <SENDER>"+sender_bean1.getId()+"</SENDER>"+	
		 			"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
	
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
	
		flag6 = cm_db.insertCoolMsg(msg);
	
		System.out.println("(휴가신청취소 결과 안내)----------------------- "+sender_bean1.getUser_nm() + "->" +target_bean.getUser_nm() + ":" + doc_no);
		
		
		
	
	// 메신져 끝

	
	}else if(cmd.equals("s_cm")){ //담당자 -> 결재자 메세지 재전송
			
		
	    target_id = doc.getUser_id2();			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		sender_id = doc.getUser_id1();			
		UsersBean sender_bean2 	= umd.getUsersBean(sender_id);
			
	//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
		String sub 		= "연차취소 신청 등록 안내";
		String cont 	= "["+sender_bean2.getUser_nm()+"]님의 휴가 취소신청서 결재를 요청합니다.";
	
		String url 		= "/fms2/free_time/free_time_cancel_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"&doc_no="+doc_no;
	//	String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_cancel_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"&doc_no="+doc_no;
		String m_url = "/fms2/free_time/free_time_frame.jsp";
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	
	
		//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
			
		
			//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
		//보낸사람
		xml_data += "    <SENDER>"+sender_bean2.getId()+"</SENDER>"+	
		 			"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
	
	
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
			
		flag6 = cm_db.insertCoolMsg(msg);
			
		System.out.println("(연차취소 신청자)-----------------------"+sender_bean2.getUser_nm() + "->" +target_bean.getUser_nm() + " " + doc_no);
		count = 1;
		
	// 메신져 끝	
			
	}	
%>


<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<% if(cmd.equals("i")){
		if(count==1){
%>
		alert("정상적으로 취소 신청되었습니다.");
		fm.action='free_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
		fm.target='d_content';
		top.window.close();
		fm.submit();					
				
<%	}

}else if(cmd.equals("c")){
		if(count2==1){
%>
		alert("결재되었습니다.");
		fm.action='free_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
		fm.target='d_content';
		top.window.close();
		fm.submit();
				
<%	}
	
}else if(cmd.equals("s_cm")){
		if(count==1){
%>
		alert("메세지 재전송 되었습니다.");
		fm.action='free_time_frame.jsp';
		fm.target='d_content';
		top.window.close();
		fm.submit();	
						
<%	}
}
%>
//-->
</script>

</body>
</html>