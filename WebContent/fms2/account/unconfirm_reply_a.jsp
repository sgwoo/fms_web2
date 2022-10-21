<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*,  acar.car_sche.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
		
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	int incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit(request.getParameter("incom_amt"));
	
	String reply_id = request.getParameter("reply_id")==null?"":request.getParameter("reply_id");
	String reply_cont = request.getParameter("reply_cont")==null?"":request.getParameter("reply_cont");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int count = 0;
	boolean flag2 = true;
	
	if(!in_db.insertIncomReply( incom_dt, incom_seq, reply_id,  reply_cont  )) count += 1;	
		
		 //담당자에게 메세지 전송------------------------------------------------------------------------------------------							
	UsersBean sender_bean 	= umd.getUsersBean(reply_id);
		
	String sub 		= "미확인입금분확인";
	String cont 	= "▣ 미확인입금 확인관련 입금처리요청 :: 요청자:" + sender_bean.getUser_nm()+ ", 입금일:"+ incom_dt+ ", " + incom_seq + ", 입금액: "+ incom_amt + ", 내용: " + reply_cont ;  	
								
	String url 		= "";	
	String m_url  ="/fms2/account/f_incom_frame.jsp";
	url 		= "/fms2/account/f_incom_frame.jsp";		 
	 	
	String target_id =nm_db.getWorkAuthUser("입금담당");  	
		
	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
	if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
						
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
	
	flag2 = cm_db.insertCoolMsg(msg);
		
	System.out.println("쿨메신저(미확인입금 입금처리의뢰)"+incom_dt+"---"+ incom_seq +"----"+target_bean.getUser_nm());	

	reply_cont = sender_bean.getUser_nm() + "-" + reply_cont;
	
 	//입금확인
	if(!in_db.updatIncomReason(incom_dt, incom_seq, "Y",  reply_cont ))	count += 1;		
	
%>
<script language='javascript'>
<%	if(count == 0){%>
		alert('정상적으로 처리되었습니다');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
