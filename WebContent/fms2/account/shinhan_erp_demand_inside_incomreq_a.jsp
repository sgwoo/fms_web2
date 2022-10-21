<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*,  acar.car_sche.*"%>
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
		
	String tr_date 		= request.getParameter("tr_date")	==null?"":request.getParameter("tr_date");
	String naeyong 		= request.getParameter("naeyong")	==null?"":request.getParameter("naeyong");
	int ip_amt			= request.getParameter("ip_amt")==null? 0:AddUtil.parseDigit(request.getParameter("ip_amt"));
	String bank_name 		= request.getParameter("bank_name")	==null?"":request.getParameter("bank_name");
	String acct_nb 		= request.getParameter("acct_nb")	==null?"":request.getParameter("acct_nb");
	
	String reply_id = request.getParameter("reply_id")==null?"":request.getParameter("reply_id");
	String reply_cont = request.getParameter("reply_cont")==null?"":request.getParameter("reply_cont");
	String base_cont = request.getParameter("base_cont")==null?"":request.getParameter("base_cont");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int count = 0;
	boolean flag2 = true;
	
		
	//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
	UsersBean sender_bean 	= umd.getUsersBean(reply_id);
		
	String sub 		= "은행입금조회 입금처리요청";
	String cont 	= "▣ 은행입금조회 입금처리요청 :: 요청자:" + sender_bean.getUser_nm()+ ", 입금일:"+ tr_date+ ", 은행명:"+ bank_name + ", 계좌:"+ acct_nb + ", 거래내역:"+ naeyong+ ",  입금액: "+ ip_amt + ", 내용: " + reply_cont ;  	
								
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
		
	System.out.println("쿨메신저(은행입금조회 입금처리의뢰)"+cont);

	
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
