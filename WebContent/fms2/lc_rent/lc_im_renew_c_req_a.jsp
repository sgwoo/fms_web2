<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String m_id				= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd				= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String mode	 			= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_no	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String im_req_cont 	= request.getParameter("im_req_cont")	==null?"":request.getParameter("im_req_cont");
	
	boolean flag7 = true;
	
	
	//쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	String url = "/fms2/lc_rent/lc_im_renew_frame.jsp";
	String m_url = "/fms2/lc_rent/lc_im_renew_frame.jsp";
	String sub 		= "임의연장등록요청";
	String cont 	= "["+firm_nm+" "+car_no+"] 영업용차량, 차령만료일이 연장만료일자 경과를 하여 등록이 안됩니다. \n\n 임의연장 등록을 요청합니다. \n\n 요청사유 : "+im_req_cont;
	String target_id = nm_db.getWorkAuthUser("본사관리팀장");
	
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
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
	
	flag7 = cm_db.insertCoolMsg(msg);
	
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 			value="<%=rent_st%>">        
</form>
<script language='javascript'>
<%	if(!flag7){%>
		alert("정상처리되지 않았습니다.");
<%	}else{		%>		
		alert("메시지를 발송했습니다.");
<%	}			%>
</script>
</body>
</html>
