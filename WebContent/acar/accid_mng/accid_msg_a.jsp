<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*"%>
<%@ page import="acar.accid.*, acar.user_mng.*, acar.cont.*, acar.doc_settle.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
			
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String req_id = request.getParameter("req_id")==null?"":request.getParameter("req_id");
	String doc_no = request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
		
	String client_id   = "";
	String site_id		= "";
	
	String from_page		= "/fms2/settle_acc/fault_bad_complaint_frame.jsp";	 //결재리스트 페이지로 수정 	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
			
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	int flag = 0;	
	int count = 0;
	boolean flag2 = true;
	boolean flag3 = true;
	
				
	if(gubun.equals("1")){	//소송요청 결재시작			
		//결재요청
		//1. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		String sub 		= " 과실미확정 사고 소송 요청 의뢰 ";
		String cont1 	= "사고 관련 소송을 의뢰합니다. &lt;br&gt; &lt;br&gt; 계약번호 : "+l_cd+"  &lt;br&gt; &lt;br&gt;  차량번호 : " + String.valueOf(cont.get("CAR_NO")) + " &lt;br&gt; &lt;br&gt;  사고일 " +AddUtil.ChangeDate2(a_bean.getAccid_dt()) + " ";
																
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st("43");//시고소송 의뢰
		doc.setDoc_id(c_id+""+accid_id);  //
		doc.setSub(sub);
		doc.setCont(cont1);
		doc.setEtc("");
		doc.setUser_nm1("기안자");
		doc.setUser_nm2("고객관리팀장");		
		doc.setUser_nm3("법무담당");	//진행처리(접수처리)	
		doc.setUser_nm4("총무팀장");		
		doc.setUser_nm5("법무담당");  //완료처리		
		doc.setUser_nm6("총무팀장");		
		
		doc.setUser_id1(user_id);  //기안자
		
		String user_id2 = "";
		String user_id3 = "";
		String user_id4 = "";
		String user_id5 = "";
		String user_id6 = "";
			
		doc.setDoc_bit("1");//수신1단계
		doc.setDoc_step("1");//기안		
	
		user_id2 = nm_db.getWorkAuthUser("본사관리팀장"); 	
	//	user_id2 = "000063"; 	
	//	user_id3 = nm_db.getWorkAuthUser("고소장담당"); 	
		user_id3 = nm_db.getWorkAuthUser("채권관리자"); 	 //20211029 변경
		user_id4 = nm_db.getWorkAuthUser("본사총무팀장"); 	 
		user_id5 = nm_db.getWorkAuthUser("채권관리자"); 	//20220310 변경  
		user_id6 = nm_db.getWorkAuthUser("본사총무팀장"); 
		
		//연차처리  - 추후 		
		doc.setUser_id2(user_id2);//본사관리팀장
		doc.setUser_id3(user_id3);//고소장담당
		doc.setUser_id4(user_id4);//총무팀장
		doc.setUser_id5(user_id5);//고소장담당
		doc.setUser_id6(user_id6);//총무팀장
		
	//=====[doc_settle] insert=====
		flag2 = d_db.insertDocSettle(doc);				
						
		String url 		= "/fms2/settle_acc/fault_bad_complaint_frame.jsp";	 //결재리스트 페이지로 수정 
		CdAlertBean msg = new CdAlertBean();
		
		String xml_data = "";
		
		String target_id = doc.getUser_id2();
							
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont1+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";		
		xml_data += "    <TARGET>2006007</TARGET>";
			
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
		
		
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저(사고 소송관련) "+l_cd +"---------------------"+target_bean.getUser_nm());
		
		count = as_db.updateAccidSuitDoc_dt(c_id , accid_id);  //소송일??
	}
		
	if(gubun.equals("9")){	//고객팀장 메세지 		
		//결재요청
		//1. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		String sub 		= " 과실미확정 사고 소송 요청 확인 ";
		String cont1 	= "사고 관련 소송을 확인하세요. &lt;br&gt; &lt;br&gt; 계약번호 : "+l_cd+"  &lt;br&gt; &lt;br&gt;  차량번호 : " + String.valueOf(cont.get("CAR_NO")) + " &lt;br&gt; &lt;br&gt;  사고일 " +AddUtil.ChangeDate2(a_bean.getAccid_dt()) + " ";
								
		String url 		= "/fms2/settle_acc/fault_bad_complaint_frame.jsp";	 //결재리스트 페이지로 수정 
		CdAlertBean msg = new CdAlertBean();
		
		String xml_data = "";
		
		String target_id = nm_db.getWorkAuthUser("본사관리팀장");  
							
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont1+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";		
				
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
		
		
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저(사고 소송관련) " + l_cd + "---------------------"+target_bean.getUser_nm());
				
	}
	
	if(gubun.equals("cancel")){	//고객팀장 결재취소 		
		
		//1. 문서처리전 등록-------------------------------------------------------------------------------------------
		String sanction_req_cancel = request.getParameter("sanction_req_cancel")==null?""        :request.getParameter("sanction_req_cancel");
	
		//소송불가 처리 
		AccidSuitBean as_bean 	= as_db.getAccidSuitBean(c_id, accid_id);
	
		as_bean.setUpdate_id(user_id);
		as_bean.setSuit_type("N");
		as_bean.setSuit_rem(sanction_req_cancel);
		count = as_db.updateAccidSuit(as_bean);
		
		//doc_settle 삭제
		//문서품의  -  과실미확정소송  : 43		
		flag3 = d_db.deleteDocSettle("43", c_id+""+accid_id);
					
		String sub 		= " 과실미확정 사고 소송 결재요청 취소 ";
		String cont1 	= "사고 관련 소송을 확인하세요. &lt;br&gt; &lt;br&gt; 계약번호 : "+l_cd+"  &lt;br&gt; &lt;br&gt;  차량번호 : " + String.valueOf(cont.get("CAR_NO")) + " &lt;br&gt; &lt;br&gt;  사고일 " +AddUtil.ChangeDate2(a_bean.getAccid_dt()) + " &lt;br&gt; &lt;br&gt;  취소사유 : "+sanction_req_cancel;
		
		String url 	=  "/acar/accid_mng/accid_s_frame.jsp";		 
		
	//	String url 		= "/fms2/settle_acc/fault_bad_complaint_frame.jsp";	 //결재리스트 페이지로 수정 
		CdAlertBean msg = new CdAlertBean();
		
		String xml_data = "";
		
		String target_id = req_id;
								
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont1+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";	
		xml_data += "    <TARGET>2006007</TARGET>";		
				
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
		
		
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저(사고 소송 결재요청 취소관련) "+l_cd + "---------------------"+target_bean.getUser_nm());
				
	}
%>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>

<input type='hidden' name="mode" value='<%=mode%>'>
<input type='hidden' name="cmd" value='<%=cmd%>'>

</form>
<script language='javascript'>
<%	if(flag2){	%>		
var fm = document.form1;	
fm.action ='<%=from_page%>';
fm.target = 'd_content';
fm.submit();	
<%	}else{	%>
alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
</body>
</html>
