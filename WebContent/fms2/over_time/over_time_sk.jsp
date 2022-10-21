<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.over_time.*, acar.user_mng.*, acar.coolmsg.*, acar.doc_settle.*" %>
<jsp:useBean id="ot_bean" scope="page" class="acar.over_time.Over_TimeBean"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>	
<%@ include file="/acar/cookies.jsp" %>

<%

	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String dept_id	= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String br_id	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String reg_dt	= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	String s_check = request.getParameter("s_check")==null?"":request.getParameter("s_check");
	String s_check_dt = request.getParameter("s_check_dt")==null?"":request.getParameter("s_check_dt");
	String s_check_id = request.getParameter("s_check_id")==null?"":request.getParameter("s_check_id");
	
	String s_check1 = request.getParameter("s_check1")==null?"":request.getParameter("s_check1");
	String s_check1_dt = request.getParameter("s_check1_dt")==null?"":request.getParameter("s_check1_dt");
	String s_check1_id = request.getParameter("s_check1_id")==null?"":request.getParameter("s_check1_id");
	
	String t_check = request.getParameter("t_check")==null?"":request.getParameter("t_check");
	String t_check_dt = request.getParameter("t_check_dt")==null?"":request.getParameter("t_check_dt");
	String t_check_id = request.getParameter("t_check_id")==null?"":request.getParameter("t_check_id");
	
	String t_check1 = request.getParameter("t_check1")==null?"":request.getParameter("t_check1");
	String t_check1_dt = request.getParameter("t_check1_dt")==null?"":request.getParameter("t_check1_dt");
	String t_check1_id = request.getParameter("t_check1_id")==null?"":request.getParameter("t_check1_id");
	
	String t_check2 = request.getParameter("t_check2")==null?"":request.getParameter("t_check2");
	String t_check2_dt = request.getParameter("t_check2_dt")==null?"":request.getParameter("t_check2_dt");
	String t_check2_id = request.getParameter("t_check2_id")==null?"":request.getParameter("t_check2_id");
	
	String t_check3 = request.getParameter("t_check3")==null?"":request.getParameter("t_check3");
	String t_check3_dt = request.getParameter("t_check3_dt")==null?"":request.getParameter("t_check3_dt");
	String t_check3_id = request.getParameter("t_check3_id")==null?"":request.getParameter("t_check3_id");
	
	int over_scgy = request.getParameter("over_scgy")==null?0:Util.parseInt(request.getParameter("over_scgy"));
	String over_scgy_dt = request.getParameter("over_scgy_dt")==null?"":request.getParameter("over_scgy_dt");
	String over_scgy_pl_dt = request.getParameter("over_scgy_pl_dt")==null?"":request.getParameter("over_scgy_pl_dt");
	
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String us_id 	= request.getParameter("us_id")==null?"":request.getParameter("us_id");
	
	String req_id 	= request.getParameter("req_id")==null?"":request.getParameter("req_id");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_step 	= request.getParameter("doc_step")==null?"":request.getParameter("doc_step");
	String user_id1 	= request.getParameter("user_id1")==null?"":request.getParameter("user_id1");
	String user_id2 	= request.getParameter("user_id2")==null?"":request.getParameter("user_id2");
	String user_id3 	= request.getParameter("user_id3")==null?"":request.getParameter("user_id3");
	String user_id4 	= request.getParameter("user_id4")==null?"":request.getParameter("user_id4");
	String user_id7 	= request.getParameter("user_id7")==null?"":request.getParameter("user_id7");
	String user_id8 	= request.getParameter("user_id8")==null?"":request.getParameter("user_id8");
	String user_id9 	= request.getParameter("user_id9")==null?"":request.getParameter("user_id9");
	String user_id10 	= request.getParameter("user_id10")==null?"":request.getParameter("user_id10");
	
	String over_time_year = request.getParameter("over_time_year")==null?"":request.getParameter("over_time_year");
	String over_time_mon = request.getParameter("over_time_mon")==null?"":request.getParameter("over_time_mon");
		
	String jb_time = request.getParameter("jb_time")==null?"":request.getParameter("jb_time");
	
	String req_code  = Long.toString(System.currentTimeMillis());

	
	int s_year2 = AddUtil.parseInt(Util.getDate(1));
	String s_month2 = Util.getDate(2);
	int s_day2 = AddUtil.parseInt(Util.getDate(3)) ;
	
	if (s_month2.equals("12") ) {
		if ( s_day2 > 24 ) {
		    s_year2 = s_year2 + 1 ;
		    s_month2 = "01";
		} 	
	} else {
		if ( s_day2 > 24 ) {
		    s_year2 = s_year2 ;
		    s_month2 =AddUtil.addZero2(AddUtil.parseInt(s_month2)+1 );		
	    }
	}	
	
	//문서품의
	DocSettleBean doc = new DocSettleBean();
	
	doc = d_db.getDocSettleOver_time("8", doc_no);
		
	boolean flag1 = true;
	boolean flag2 = true;
	
	String target_id1 	= "";
	String target_id2 	= "";
	
	int count = 0;
	
	boolean flag6 = true;
	
	OverTimeDatabase otd = OverTimeDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	user_bean = umd.getUsersBean(user_id);
	

//sender
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
if(cmd.equals("ok")){ //최종-인사담당 결재

	ot_bean.setUser_id(user_id);
	ot_bean.setDoc_no(doc_no);
//	ot_bean.setT_check_id(us_id);
	ot_bean.setT_check(t_check);
//	ot_bean.setT_check_dt(t_check_dt);
	ot_bean.setJb_time(jb_time);
	ot_bean.setOver_time_mon(over_time_mon);
	
	count = otd.updTimeok(ot_bean);
	
	
//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
	flag1 = d_db.updateDocSettleOt7(doc_no, "7", "3", us_id, "8");
	
		
}else if(cmd.equals("d")){ //신청서 삭제 -- doc_settle 삭제 (특근만 결재전 삭제 가능)
	
	ot_bean.setUser_id(user_id);
	ot_bean.setDoc_no(doc_no);
	
	count =  otd.delTimedel(ot_bean);			
	flag1 =  otd.deleteDocSettleOverTime(doc_no);  //문서처리전 삭제
	
	
}else if(cmd.equals("sk")){ //사전결재 - 담당팀장 결재
	
	ot_bean.setUser_id(user_id);
	ot_bean.setDoc_no(doc_no);
	ot_bean.setS_check(s_check);
	ot_bean.setJb_time(jb_time);
//	ot_bean.setOver_time_year(s_year2);
//	ot_bean.setOver_time_mon(s_month2);
	
	count = otd.updScheck(ot_bean);
		

//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------	

	flag1 = d_db.updateDocSettleOt2(doc_no, "2", "2", us_id, "8");  //담당팀장 결재


//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	//String target_id = "";

	String sub 		= "특근 신청 등록 안내";
	String cont 	= "["+sender_bean.getUser_nm()+"]님의 특근 신청서가 등록 되었습니다. 확인바랍니다.";


	String url 		= "/fms2/over_time/over_time_frame.jsp";
	String m_url = "/fms2/over_time/over_time_frame.jsp";
	String xml_data = "";
	
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"<BACKIMG>4</BACKIMG>"+
  				"<MSGTYPE>104</MSGTYPE>"+
  				"<SUB>"+sub+"</SUB>"+
  				"<CONT>"+cont+"</CONT>"+
  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";


	//받는사람
	xml_data += "    <TARGET>2000002</TARGET>";  //총무 팀장
//	xml_data += "    <TARGET>2006007</TARGET>"; //당분간 test

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

//	System.out.println(xml_data);
	System.out.println("(특근결재자2)-----------------------"+sender_bean.getUser_nm() + " " + doc_no);

// 메신져 끝
}else if(cmd.equals("mo")){ //인정근로시간 수정
	
	ot_bean.setUser_id(user_id);
	ot_bean.setDoc_no(doc_no);
	ot_bean.setJb_time(jb_time);
	
	count = otd.UpdateJb_time(ot_bean);
	
}else if(cmd.equals("otm")){ //귀속월 수정
	
	ot_bean.setUser_id(user_id);
	ot_bean.setDoc_no(doc_no);
	ot_bean.setOver_time_year(over_time_year);
	ot_bean.setOver_time_mon(over_time_mon);
	
	count = otd.UpdateOver_time_mon(ot_bean);
	
}

%>
<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>

<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='us_id' value='<%=us_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   

</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<% if(cmd.equals("ok")){
	if(count==1){
	%>
	alert("결재 되었습니다.");
	fm.action='./over_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.target='d_content';
	fm.submit();					
<%	}

}else if(cmd.equals("ok1")){
	if(count==1){
	%>
	alert("결재 되었습니다.");
	fm.action='./over_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.target='d_content';
	fm.submit();					

<%	}

}else if(cmd.equals("sk")){
	if(count==1){
	%>
	alert("결재 되었습니다.");
	fm.action='./over_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.target='d_content';
	fm.submit();					
<%	}

}else if(cmd.equals("sk1")){
	if(count==1){
	%>
	alert("결재 되었습니다.");
	fm.action='./over_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.target='d_content';
	fm.submit();					
<%	}

}else if(cmd.equals("d")){
	if(count==1){
	%>
	alert("삭제 되었습니다.");
	fm.action='./over_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.target='d_content';
	fm.submit();					
<%	}

}else if(cmd.equals("mo")){
	if(count==1){
	%>
	alert("수정 되었습니다.");
	fm.action='./over_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.target='d_content';
	fm.submit();					
<%	}

}else if(cmd.equals("otm")){
	if(count==1){
	%>
	alert("수정 되었습니다.");
	fm.action='./over_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.target='d_content';
	fm.submit();					
<%	}
}
%>
//-->
</script>
</body>
</html>
