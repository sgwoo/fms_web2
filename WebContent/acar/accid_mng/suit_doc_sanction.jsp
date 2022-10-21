<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.accid.*, acar.cont.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//@ author : JHM - 사고처리결과문서관리
	
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
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고
	String mean_dt 	= request.getParameter("mean_dt")==null?"":request.getParameter("mean_dt"); //판결일 
	
	String mode ="14";
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");

	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");

	String suit_type	= request.getParameter("suit_type")==null?"":request.getParameter("suit_type");
	String suit_dt	= request.getParameter("suit_dt")==null?"":request.getParameter("suit_dt");
	
	//System.out.println("suit_type:"+suit_type);
		
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	int result = 0;
	int count = 0;
	
	String from_page = "";
		
	String sub = "";
	String cont1 = "";
	String target_id = "";
	String url  = "";	
	
	from_page = "/fms2/settle_acc/fault_bad_complaint_frame.jsp";
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
		//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
		
	//문서품의  -  과실미확정소송  : 43		
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	if(doc.getDoc_id().equals("")){
		doc = d_db.getDocSettleCommi("43", c_id+""+accid_id);
		doc_no = doc.getDoc_no();
	}
		
		//결재진행중 
//		System.out.println(" doc_sanction doc_bit = " + doc_bit + ": doc_no = :" + doc_no +":user_id = " + user_id + ": rent_l_cd = " + rent_l_cd);
							
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
				
	String doc_step = "2";
		
		//총무팀장 결재이면 추심 종결처리료
	if(doc_bit.equals("6"))	doc_step = "3";  
	if(suit_type.equals("N"))	doc_step = "3";  
			
	flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		//out.println("문서처리전 결재<br>");
		
	if (doc_bit.equals("5")  ) {	//추심종결일 저장	  - 종결처리 기안시 
			flag3 = as_db.updateAccidMean_dt(c_id, accid_id, mean_dt, user_id ) ; // 업무대여인  결재완료
	}
			
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
	if (doc_bit.equals("2")  ) {		
		sub 		= "과실미확정사고 소송 진행 요청 ";
		cont1 	= "[계약번호:"+l_cd+"] 차량번호 : " + String.valueOf(cont.get("CAR_NO")) + ", 사고일 " +AddUtil.ChangeDate2(a_bean.getAccid_dt()) + "  &lt;br&gt; &lt;br&gt;  과실미확정사고 관련 소송 진행 결재를 요청합니다!!.";
		target_id = doc.getUser_id3();
	} else if (doc_bit.equals("3")  ) {		
		sub 		= "과실미확정사고 소송 진행 요청 ";
		cont1 	= "[계약번호:"+l_cd+"] 차량번호 : " + String.valueOf(cont.get("CAR_NO")) + ", 사고일 " +AddUtil.ChangeDate2(a_bean.getAccid_dt()) + "  &lt;br&gt; &lt;br&gt;  과실미확정사고 관련 소송 진행 결재를 의뢰합니다.!!";
		target_id = doc.getUser_id4();
	} else if (doc_bit.equals("4")  ) {		  
		sub 		= "과실미확정사고 소송 진행 결재 완료  ";
		cont1	= "[계약번호:"+l_cd+"] 차량번호 : " + String.valueOf(cont.get("CAR_NO")) + ", 사고일 " +AddUtil.ChangeDate2(a_bean.getAccid_dt()) + "  &lt;br&gt; &lt;br&gt;  과실미확정사고 관련 소송진행 결재가 완료되었습니다.!!";
		target_id = doc.getUser_id5();	
	} else if (doc_bit.equals("5")  ) {		  
		sub 		= "과실미확정사고 소송 종결 결재 요청 ";
		cont1 	= "[계약번호:"+l_cd+"] 차량번호 : " + String.valueOf(cont.get("CAR_NO")) + ", 사고일 " +AddUtil.ChangeDate2(a_bean.getAccid_dt()) + "  &lt;br&gt; &lt;br&gt;  과실미확정사고 관련 소송결과 결재를 요청합니다.!!";
		target_id = doc.getUser_id6();	
	} else if (doc_bit.equals("6")  ) {		
		sub 	= "과실미확정사고 소송 종결 결재 완료 ";
		cont1 	= "[계약번호:"+l_cd+"] 차량번호 : " + String.valueOf(cont.get("CAR_NO")) + ", 사고일 " +AddUtil.ChangeDate2(a_bean.getAccid_dt()) + "  &lt;br&gt; &lt;br&gt;  과실미확정 사고 관련 소송결과 결재가 완료되었습니다.!!";
		target_id = doc.getUser_id5();	
	}
		
	
	url = "/acar/accid_mng/accid_u_frame.jsp?m_id="+m_id+"|l_cd="+l_cd+"|c_id="+c_id+"|accid_id="+accid_id+"|from_page="+from_page+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
				
		//사용자 정보 조회
	UsersBean target_bean 	= umd.getUsersBean(target_id);
				
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
	 			"<ALERTMSG>"+
				"    <BACKIMG>4</BACKIMG>"+
				"    <MSGTYPE>104</MSGTYPE>"+
				"    <SUB>"+sub+"</SUB>"+
				"    <CONT>"+cont1+"</CONT>"+
				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+from_page+"</URL>";
	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
//	xml_data += "    <TARGET>2006007</TARGET>";
	
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
	System.out.println("쿨메신저("+cont1+")-----------------------"+target_bean.getUser_nm());
	
	
	
	//기안자에게 메세지보내기
	if (doc_bit.equals("4")  ) {	
		sub 	= "과실미확정사고 소송 진행 결재 완료 ";
		cont1 	= "남부지방법으로 소송 접수되었습니다. &lt;br&gt; &lt;br&gt; 계약번호 : "+l_cd+" &lt;br&gt; &lt;br&gt;  상호 : "+String.valueOf(cont.get("FIRM_NM"))+" &lt;br&gt; &lt;br&gt;  차량번호 : "+ String.valueOf(cont.get("CAR_NO")) + "] " +AddUtil.getDate3(suit_dt) + " ";
		target_id = doc.getUser_id1();	
		
		url = "/acar/accid_mng/accid_u_frame.jsp?m_id="+m_id+"|l_cd="+l_cd+"|c_id="+c_id+"|accid_id="+accid_id+"|from_page="+from_page+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
		
		//사용자 정보 조회
		target_bean 	= umd.getUsersBean(target_id);
					
		xml_data = "";
		xml_data =  "<COOLMSG>"+
		 			"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont1+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+from_page+"</URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	//	xml_data += "    <TARGET>2006007</TARGET>";
		
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
					"    <MSGICON>10</MSGICON>"+
					"    <MSGSAVE>1</MSGSAVE>"+
					"    <LEAVEDMSG>1</LEAVEDMSG>"+
					"    <FLDTYPE>1</FLDTYPE>"+
					"  </ALERTMSG>"+
					"</COOLMSG>";
			
		CdAlertBean msg2 = new CdAlertBean();
		msg2.setFlddata(xml_data);
		msg2.setFldtype("1");
			
		flag4 = cm_db.insertCoolMsg(msg2);							
		
	}
	
	//System.out.println(xml_data);	
			
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
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>

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