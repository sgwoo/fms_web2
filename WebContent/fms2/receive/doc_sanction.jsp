<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.receive.*"%>
<%@ page import="acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
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
		
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
			
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	String from_page 	= "";
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	int result = 0;
	int count = 0;
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
	//p_st: 1:청구 2: 입금 3:완료	
	if ( doc_bit.equals("1") || doc_bit.equals("2")  ) {
		if(!rc_db.updateClsGuarSt(rent_mng_id, rent_l_cd, "1"))	result += 1;	    
	} else if ( doc_bit.equals("4")    ) {
		if(!rc_db.updateClsGuarSt(rent_mng_id, rent_l_cd, "2"))	result += 1;	    
 	} else  if (  doc_bit.equals("5")  ) {
 		if(!rc_db.updateClsGuarSt(rent_mng_id, rent_l_cd, "3"))	result += 1;	    
 	}
		
	from_page = "/fms2/receive/gua_d_frame.jsp";
			
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
		
	String doc_step = "2";
	if(doc_bit.equals("5")){
		doc_step = "3";				
	}
	
	flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
	//out.println("문서처리전 결재<br>");
		
	//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
	
	//문서 결재여부
	String sub = "";
	String cont = "";
	String target_id = "";
	
	if ( doc_bit.equals("1") || doc_bit.equals("2")  ) {
		sub 		= "보증보험 청구결재";
		cont 		= "[계약번호:"+rent_l_cd+"]  보증보험 청구결재요청합니다.";
		target_id 	= doc.getUser_id2();
         }  else if  ( doc_bit.equals("4")   ) {
         		sub 		= "보증보험 입금결재";
		cont 		= "[계약번호:"+rent_l_cd+"]  보증보험 입금결재요청합니다.";
		target_id 	= doc.getUser_id5();
         }		
		
	String url 		= "/fms2/receive/gua_c_8_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
	String m_url = "/fms2/receive/gua_d_frame.jsp";
			
	//사용자 정보 조회
	UsersBean target_bean 	= umd.getUsersBean(target_id);	
	
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
				"    <BACKIMG>4</BACKIMG>"+
				"    <MSGTYPE>104</MSGTYPE>"+
				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
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
	System.out.println("쿨메신저 보증보험관리 ("+cont+")-----------------------"+target_bean.getUser_nm());
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