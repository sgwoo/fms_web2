<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.cont.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.coolmsg.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" scope="page" class="acar.forfeit_mng.FineDocBean"/>]
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String f_result = request.getParameter("f_result")==null?"":request.getParameter("f_result");
	String f_reason = request.getParameter("f_reason")==null?"":request.getParameter("f_reason");
	String send_msg = request.getParameter("send_msg")==null?"":request.getParameter("send_msg");
	String choice = request.getParameter("choice")==null?"":request.getParameter("choice");
	
	boolean flag=false;
	boolean msg_flag =false;
	String gubun_nm = "";
	if(!send_msg.equals("")) {
		
		//미수채권 리스트
		Vector FineList = FineDocDb.getSettleDocLists(doc_id);
		
		FineDocListBn = (FineDocListBean)FineList.elementAt(0);
		String rent_mng_id =  FineDocListBn.getRent_mng_id();
		String rent_l_cd =  FineDocListBn.getRent_l_cd();
		
		//계약기본정보
		ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);

		String reg_id= base.getMng_id();
		
		UserMngDatabase um = UserMngDatabase.getInstance();
		UsersBean suser  = um.getUsersBean(ck_acar_id);
		UsersBean tuser  = um.getUsersBean(reg_id);
		
		FineDocBn = FineDocDb.getFineDoc(doc_id);
		String target_id = tuser.getId();
      	String target_nm = tuser.getUser_nm();
		
		String title = "최고서발송대장";
    	String sender_id = suser.getId();
    	String sender_nm = suser.getUser_nm();
		
    	String cont="요청하신 [계약번호"+rent_l_cd+"] [고객명 "+FineDocBn.getGov_nm()+"] 내용증명 발송결과가 입력되었습니다. ";
    	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/fms2/credit/settle_doc_mng_sc_in_a.jsp";
    	
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+title+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
 					"    <URL>"+url+"</URL>";
		xml_data += "    <TARGET>"+target_id+"</TARGET>";
		xml_data += "    <SENDER>"+sender_id+"</SENDER>"+
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>"; 
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1"); 
		
		CoolMsgDatabase cm_db = CoolMsgDatabase.getInstance();
		msg_flag = cm_db.insertCoolMsg(msg); 
	}else{
		
		FineDocBn = FineDocDb.getFineDoc(doc_id);
		
		if(choice.equals("result")) FineDocBn.setF_result(f_result);
		if(choice.equals("reason")) FineDocBn.setF_reason(f_reason);
		
		flag = FineDocDb.updateFineDoc(FineDocBn);
	}
	
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
	var flag = '<%=flag%>';
	var msg_flag = '<%=msg_flag%>';
	
	if(flag == 'true'){
		 opener.location.reload();
		 alert("저장 되었습니다.");
		 window.close();
	}else if(msg_flag == 'true'){
		 opener.location.reload();
		 alert("메세지가 전송 되었습니다.");
		 window.close();
	}else{
		
	}
</script>
<body>
</body>
</head>
</html>
