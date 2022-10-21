<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String settle_dt 	= request.getParameter("settle_dt")==null?"":request.getParameter("settle_dt");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");

	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
		
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	int result = 0;
	int count = 0;
	
	String from_page = "";
		
	String sub = "";
	String cont = "";
	String target_id = "";
	String url  = "";	
	
	from_page = "/fms2/receive/receive_d6_frame.jsp";
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();	
		
	//doc_settle : 채권소송: doc_st:96,  최초 1회	
		
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	if(doc.getDoc_id().equals("")){
		doc = d_db.getDocSettleCommi("96", rent_l_cd);
		doc_no = doc.getDoc_no();
	}
	
	if(doc_no.equals("")){
	
		sub 	= "채권소송진행의뢰  ";
		cont 	= "[계약번호:"+rent_l_cd+"]  채권소송 진행 의뢰 요청합니다.";  //진행요청 
				
		doc.setDoc_st	("96");
		doc.setDoc_id	(rent_l_cd);
		doc.setSub	(sub);
		doc.setCont	(cont);
		doc.setEtc	("");
		doc.setUser_nm1	("기안자");
		doc.setUser_nm2	("총무팀장");
		doc.setUser_nm3	("");
		doc.setUser_nm4	("");
		doc.setUser_id1(user_id);
		doc.setUser_id2	("");
		doc.setUser_id3	("");
		doc.setUser_id4	("");
		doc.setDoc_bit	("1");//수신단계
		doc.setDoc_step	("1");//기안
			
		String user_id2 = "";
		user_id2 = nm_db.getWorkAuthUser("본사총무팀장");	
		doc.setUser_id2(user_id2);//팀장/지점장	
		//user_id2 = "000063";
					
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);	
		
		
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------

		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
			//사용자 정보 조회
		target_id = doc.getUser_id2();
								
		UsersBean target_bean 	= umd.getUsersBean(target_id);
					
		url 		= "/fms2/receive/receive_6_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
								
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+from_page+"</URL>";
		
		
		//받는사람
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <TARGET>2006007</TARGET>";
				
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
		
		System.out.println("쿨메신저(채권소송의뢰요청)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
		
	} else {
		//결재진행중 
//		System.out.println(" doc_sanction doc_bit = " + doc_bit + ": doc_no = :" + doc_no +":user_id = " + user_id + ": rent_l_cd = " + rent_l_cd);
							
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
				
		String doc_step = "2";
		
		//총무팀장 결재이면 추심 종결처리료
		if(doc_bit.equals("2"))	doc_step = "3";  
			
		flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		//out.println("문서처리전 결재<br>");
						
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
		if (doc_bit.equals("2")  ) {		
			sub 		= "채권소송의뢰 결재 완료 ";
			cont 	= "[ "+rent_l_cd +" "+ "채권소송의뢰 결재가 완료되었습니다. 채권소송을 진행해주십시요!!.";
			target_id = doc.getUser_id1();	
		}
				
		url = "/fms2/receive/receive_6_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
				
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
				
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+from_page+"</URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
//		xml_data += "    <TARGET>2006007</TARGET>";
	
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
		
		flag4 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저("+cont+")-----------------------"+target_bean.getUser_nm());
		//System.out.println(xml_data);	
	}		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>

<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="rent_mng_id" value='<%=rent_mng_id%>'>
<input type='hidden' name="rent_l_cd" value='<%=rent_l_cd%>'>

<input type='hidden' name="mode" value='<%=mode%>'>
<input type='hidden' name="cmd" value='<%=cmd%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>  		
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action ='<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();	
<%	}else{	%>
	alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>