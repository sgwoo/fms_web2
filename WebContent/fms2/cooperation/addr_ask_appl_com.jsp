<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cooperation.*, java.io.*,acar.user_mng.*"%>
<%@ page import="acar.util.*,acar.coolmsg.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>


<%
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String in_id = request.getParameter("in_id")==null?"":request.getParameter("in_id");
	
	int count = 0;
	boolean flag=false;
	//��� ���� ó�� ǥ��
	 cp_bean = cp_db.getCooperationBean(seq);
	if(!cp_bean.getOut_content().equals("�߼�")){
		cp_bean.setOut_content	("�߼�");
		count = cp_db.updateOutdt(cp_bean);
		
		//�޼��� ������
		if(count > 0){
			UserMngDatabase um = UserMngDatabase.getInstance();
			UsersBean suser = um.getUsersBean(ck_acar_id);
			UsersBean tuser = um.getUsersBean(in_id);
			
			
			String target_id = tuser.getId();
	      	String target_nm = tuser.getUser_nm();
			
			String title = "ä�����ּ���ȸ��û";
	    	String sender_id = suser.getId();
	    	String sender_nm = suser.getUser_nm();
			
	    	String content= cp_bean.getTitle()+ "���� \n"+ 
	    				"ä�����ּ���ȸ��û�� ó���Ǿ����ϴ�. Ȯ�κ�Ź�帳�ϴ�.";
	    	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/fms2/cooperation/cooperation_n3_frame.jsp";
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
	  					"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+title+"</SUB>"+
		  				"    <CONT>"+content+"</CONT>"+
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
			flag = cm_db.insertCoolMsg(msg);
		}
		
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src='/include/common.js'></script>

<script>
	var flag = '<%=flag%>';
	if(flag){
		opener.parent.location.reload();
		self.close();
	}else{
		alert("ó���� �����߻�");
		opener.parent.location.reload();
		document.window.close();
		
	}
	

</script>
</head>
<body>
	

</body>
</html>
