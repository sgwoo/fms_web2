<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.memo.*, acar.coolmsg.*, acar.user_mng.*, tax.*" %>
<jsp:useBean id="memo_db" scope="page" class="acar.memo.Memo_Database"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String send_st 	= request.getParameter("send_st")==null?""  :request.getParameter("send_st");
	String title 	= request.getParameter("title")==null?""  	:request.getParameter("title");
	String content 	= request.getParameter("content")==null?""  :request.getParameter("content");
	String rece_id 	= request.getParameter("rece_id")==null?""  :request.getParameter("rece_id");
	String send_id 	= request.getParameter("send_id")==null?ck_acar_id:request.getParameter("send_id");
	String send_phone = request.getParameter("send_phone")==null?""  :request.getParameter("send_phone");
	
	String flag = "";
	boolean flag3 = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//사용자 정보 조회
	UsersBean target_bean 	= umd.getUsersBean(rece_id);
	UsersBean sender_bean 	= umd.getUsersBean(send_id);
	
	
	//메모------------------------------------------------------------------------------------------------------
	/*
	if(send_st.equals("1")){
		
		MemoBean memo_bn = new MemoBean();
		memo_bn.setSend_id	(send_id);
		memo_bn.setRece_id	(rece_id);
		memo_bn.setTitle	(title);
		memo_bn.setContent	(content);
		
		if(!memo_db.sendMemo(memo_bn)){
			flag = "error";
		}
		

	}else
	*/	
	//메세지------------------------------------------------------------------------------------------------------
		if(send_st.equals("2")){
		
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+title+"</SUB>"+
	  				"    <CONT>"+content+"</CONT>"+
 					"    <URL></URL>";
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
		
		flag3 = cm_db.insertCoolMsg(msg);
		
		if(!flag3){
			flag = "error";
		}
		
	//문자------------------------------------------------------------------------------------------------------
	}else if(send_st.equals("3")){
		
		content = content + " -아마존카 "+sender_bean.getUser_nm()+"-";
		
		int i_msglen = AddUtil.lengthb(content);
		
		String msg_type = "0";
		
		//80이상이면 장문자
		if(i_msglen>80) msg_type = "5";
		
		if(send_phone.equals("")){
			send_phone = sender_bean.getUser_m_tel();
		
			if(!sender_bean.getHot_tel().equals("")){
				send_phone = sender_bean.getHot_tel();
			}
		
		}
		
		if(!target_bean.getUser_m_tel().equals("")){
			IssueDb.insertsendMail_V5_H(send_phone, sender_bean.getUser_nm(), target_bean.getUser_m_tel(), target_bean.getUser_nm(), "", "", msg_type, title, content, "", "", ck_acar_id, "emp");
		}
		
	}
%>
<script language='javascript'>
<%	if(flag.equals("error")){%>		
		alert('오류발생!');
		parent.location='about:blank';
<%	}else{%>		
		alert('처리했습니다.');
		parent.window.close();
<%	}%>
</script>
</body>
</html>
