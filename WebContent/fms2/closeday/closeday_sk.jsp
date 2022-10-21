<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.closeday.*, acar.user_mng.*, acar.coolmsg.*, acar.doc_settle.*" %>
<%@ page import="acar.car_sche.*" %>
<jsp:useBean id="cd_bean" class="acar.closeday.CloseDayBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%

	CloseDayDatabase cd_db = CloseDayDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //연차의뢰자
	String dept_id	= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String br_id	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String reg_dt	= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
		
//결재	
	
	int flag = 0;
			
	String  login_id = request.getParameter("login_id")==null?"":request.getParameter("login_id");  //로그인 id
	login_id = login.getCookieValue(request, "acar_id");
	
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	String target_id 	= "";
	String sender_id	= "";
	int count = 0;
	int count2 = 0;
	boolean flag6 = true;
	
	String req_id 	= request.getParameter("req_id")==null?"":request.getParameter("req_id");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");

	String doc_st 	= request.getParameter("doc_st")==null?"21":request.getParameter("doc_st");
	String doc_step 	= request.getParameter("doc_step")==null?"":request.getParameter("doc_step");
	String user_id1 	= request.getParameter("user_id1")==null?"":request.getParameter("user_id1");
	String user_id2 	= request.getParameter("user_id2")==null?"":request.getParameter("user_id2");
	String user_id3 	= request.getParameter("user_id3")==null?"":request.getParameter("user_id3");
	String user_id4 	= request.getParameter("user_id4")==null?"":request.getParameter("user_id4");
	String user_id7 	= request.getParameter("user_id7")==null?"":request.getParameter("user_id7");
	String user_id8 	= request.getParameter("user_id8")==null?"":request.getParameter("user_id8");
	String user_id9 	= request.getParameter("user_id9")==null?"":request.getParameter("user_id9");
	String user_id10 	= request.getParameter("user_id10")==null?"":request.getParameter("user_id10");
	

	//문서품의
	DocSettleBean doc = new DocSettleBean();

	doc = d_db.getDocSettleOver_time("23", doc_no);
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	
	if(cmd.equals("cm")){ // 결재 등록
	
		cd_bean.setUser_id(user_id);
		cd_bean.setCheck_id(login_id);
		cd_bean.setDoc_no(doc_no);
		
		count = cd_db.CloseDay_Check(cd_bean);
			
		int cnt = 0;
		
	//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	   	target_id = doc.getUser_id1();			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
		sender_id = doc.getUser_id2();			
		UsersBean sender_bean 	= umd.getUsersBean(sender_id);
						
		String sub 		= "중식대 신청 결재 안내";
		String cont 	= "["+target_bean.getUser_nm()+"]님의 중식대 신청서에 결재가 완료되었습니다. 확인바랍니다.";
		String url 		= "/fms2/closeday/closeday_c.jsp?user_id="+user_id+"|doc_no="+doc_no;
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				//"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	  				"<URL></URL>";
	
					
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
	
//		System.out.println("(중식대신청 결과 안내)----------------------- "+sender_bean.getUser_nm() + "->" +target_bean.getUser_nm() + ":" + doc_no);
	
	// 메신져 끝
		
	//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
				
		flag1 = d_db.updateDocSettleOt2(doc_no, "2", "3", login_id, "23");
		
		//팀장인 경우 총무팀장에게 전달
		if ( user_id.equals("000005") || user_id.equals("000026") ) {
		
			xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				//"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
						"<URL></URL>";
			
		 	UsersBean target_bean1 	= umd.getUsersBean("000004");
					
			//받는사람
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
		
			//보낸사람
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+	
			 			"    <MSGICON>10</MSGICON>"+
		  				"    <MSGSAVE>1</MSGSAVE>"+
		  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
		  				"  </ALERTMSG>"+
		  				"</COOLMSG>";
		
			CdAlertBean msg1 = new CdAlertBean();
			msg1.setFlddata(xml_data);
			msg1.setFldtype("1");
		
			flag6 = cm_db.insertCoolMsg(msg1);
		
	//		System.out.println("(중식대신청 결과 안내)팀장----------------------- "+sender_bean.getUser_nm() + "->" +target_bean1.getUser_nm() + ":" + doc_no);		
		
		}
		
		
		
	}else if(cmd.equals("d")){ //신청서 삭제  -- 결재난건은 삭제 불가
		
		doc.setDoc_st("23");
		doc.setDoc_no(doc_no);
		flag2 = d_db.Free_deleteDocSettle("23", doc_no);
		
		cd_bean.setUser_id(user_id);
		cd_bean.setDoc_no(doc_no);
		count = cd_db.CloseDay_del(cd_bean);
		
	}
%>
<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>



</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<% if(cmd.equals("cm")){
	if(count==1){
	%>
	alert("결재완료.");
	fm.action='/fms2/closeday/closeday_frame.jsp';
	fm.target='d_content';
	fm.submit();					
<%	}

}else if(cmd.equals("d")){
	if(count==1){
%>
	alert("삭제 되었습니다.");
	fm.action='/fms2/closeday/closeday_frame.jsp';
	fm.target='d_content';
	fm.submit();	
<%	}	
}
%>	
//-->
</script>
</body>
</html>
