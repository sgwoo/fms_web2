<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.user_mng.*, acar.cooperation.*, acar.coolmsg.*"%>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
<%@ include file="/acar/cookies.jsp" %>
<%
	
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String title1 		= request.getParameter("title1")==null?"":request.getParameter("title1");
	String title 		= request.getParameter("title")==null?"":request.getParameter("title");
	String content 		= request.getParameter("content")==null?"":request.getParameter("content");
	String sub_id 		= request.getParameter("sub_id")==null?"":request.getParameter("sub_id");
	String out_id 		= request.getParameter("out_id")==null?"":request.getParameter("out_id");
	String com_id 		= request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String req_st 		= request.getParameter("req_st")==null?"1":request.getParameter("req_st");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	

	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	int count = 0;
	boolean flag6 = true;
	
	String valus = "?gubun=it&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_year="+s_year+"&s_mon="+s_mon+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
		   	"&sh_height="+sh_height+"";
	
	String sender_id = "";
	String target_id = "";
		
	CooperationDatabase cp_db = CooperationDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	cp_bean.setSeq			(seq);
	cp_bean.setIn_id		(user_id);
	cp_bean.setTitle		(title1+title);
	cp_bean.setContent		(content);
	cp_bean.setSub_id		(sub_id);
	cp_bean.setOut_id		(out_id);
	cp_bean.setReq_st		(req_st);
	cp_bean.setCom_id		(com_id);

	
	count = cp_db.insertCooperationIt(cp_bean);
		
		
	sender_id = cp_bean.getIn_id();
	target_id = cp_bean.getSub_id();
	
	if(target_id.equals("")) target_id = cp_bean.getOut_id();//협조자(업무담당자)가 없으면 관리자(협조부서장)에게 메세지 발송
	
	UsersBean sender_bean 	= umd.getUsersBean(sender_id);
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	if ( title1.equals("[IT마케팅팀개발업무]") ) {
		String sub 		= "FMS업무협조 등록";
		String cont 	= "["+sender_bean.getUser_nm()+"]님이 FMS업무협조를 요청하셨습니다. 확인바랍니다.";
		String url 		= "/fms2/cooperation/cooperation_it_frame.jsp";
		String m_url  = "/fms2/cooperation/cooperation_it_frame.jsp";
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  	 </ALERTMSG>"+
	  				"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		flag6 = cm_db.insertCoolMsg(msg);
		
	} else {
		String sub 		= "업무협조 등록";
		String cont 	= "["+sender_bean.getUser_nm()+"]님이 업무협조를 요청하셨습니다. 확인바랍니다.";
		String url 		= "/fms2/cooperation/cooperation_it_frame.jsp";
		String m_url  = "/fms2/cooperation/cooperation_it_frame.jsp";
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  	 </ALERTMSG>"+
	  				"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		flag6 = cm_db.insertCoolMsg(msg);
	}	
	
	System.out.println("업무협조 등록 --------"+ title1+title);	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<form action='' name='form1' method='post' >
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>    
  <input type='hidden' name='gubun2'	value='<%=gubun2%>'>     

</form>
<script language='javascript'>

<%	if(count > 0){	%>
		
		alert('등록되었습니다.');
		//self.window.close();
		top.window.close();
		

<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>