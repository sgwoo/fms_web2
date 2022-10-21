<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cooperation.*, java.io.*,acar.user_mng.*"%>
<%@ page import="acar.util.*,acar.coolmsg.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>


<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//content_code 받아오기
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String in_id = request.getParameter("in_id")==null?"":request.getParameter("in_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String out_content = request.getParameter("out_content")==null?"":request.getParameter("out_content");
	
	
	int count = 0;
	boolean flag=false;
	//출력 후의 처리 표시
	 cp_bean = cp_db.getCooperationBean(seq);
	 if(gubun.equals("sub_dt")){
			count = cp_db.updateSubdt(cp_bean);
				
			//메세지 보내기 - 채권관리자한테 보내기
			if(count > 0){
				UserMngDatabase um = UserMngDatabase.getInstance();
				UsersBean suser  = um.getUsersBean(ck_acar_id);
				in_id = nm_db.getWorkAuthUser("운행정지명령담당자");
				UsersBean tuser  = um.getUsersBean(in_id);
				
				
				String target_id = tuser.getId();
		      	String target_nm = tuser.getUser_nm();
				
				String title = "운행정지명령신청요청";
		    	String sender_id = suser.getId();
		    	String sender_nm = suser.getUser_nm();
				
		    	String content= cp_bean.getTitle()+ "고객의 \n"+ 
		    				"운행정지명령신청요청이 승인처리되었습니다. 확인부탁드립니다.";
		    	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/fms2/cooperation/cooperation_n4_frame.jsp";
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
				
		}else if(gubun.equals("back")){
			// sub_dt 등록
			count = cp_db.updateSubdt(cp_bean);
			
			// out_dt 등록
			cp_bean.setOut_content	(out_content);
			count = cp_db.updateOutdt(cp_bean);
				
		}else if(gubun.equals("sub_cancel")){
			cp_bean.setSub_dt("");
		
			count = cp_db.updateCooperation(cp_bean);
				
			//메세지 보내기 - 채권관리자한테 보내기
			if(count > 0){
				UserMngDatabase um = UserMngDatabase.getInstance();
				UsersBean suser  = um.getUsersBean(ck_acar_id);
				in_id = nm_db.getWorkAuthUser("운행정지명령담당자");
				UsersBean tuser  = um.getUsersBean(in_id);
				
				
				String target_id = tuser.getId();
		      	String target_nm = tuser.getUser_nm();
				
				String title = "운행정지명령신청요청";
		    	String sender_id = suser.getId();
		    	String sender_nm = suser.getUser_nm();
				
		    	String content= cp_bean.getTitle()+ "고객의 \n"+ 
		    				"운행정지명령신청요청이 승인 처리가 취소 되었습니다. 확인부탁드립니다.";
		    	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/fms2/cooperation/cooperation_n4_frame.jsp";
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
				
		}else if(gubun.equals("back_cancel")){
			cp_bean.setSub_dt("");
			cp_bean.setOut_dt("");
			cp_bean.setOut_content("");
		
			count = cp_db.updateCooperation(cp_bean);
				
			//메세지 보내기 - 채권관리자한테 보내기
			if(count > 0){
				UserMngDatabase um = UserMngDatabase.getInstance();
				UsersBean suser  = um.getUsersBean(ck_acar_id);
				in_id = nm_db.getWorkAuthUser("운행정지명령담당자");
				UsersBean tuser  = um.getUsersBean(in_id);
				
				
				String target_id = tuser.getId();
		      	String target_nm = tuser.getUser_nm();
				
				String title = "운행정지명령신청요청";
		    	String sender_id = suser.getId();
		    	String sender_nm = suser.getUser_nm();
				
		    	String content= cp_bean.getTitle()+ "고객의 \n"+ 
		    				"운행정지명령신청요청이 반려 처리가 취소 되었습니다. 확인부탁드립니다.";
		    	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/fms2/cooperation/cooperation_n4_frame.jsp";
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
				
		}else if(gubun.equals("out_dt")){
		if(!cp_bean.getOut_content().equals("발송") && !in_id.equals("")){
			cp_bean.setOut_content	("발송");
			count = cp_db.updateOutdt(cp_bean);
			
			//메세지 보내기 - 등록자한테 보내기
			if(count > 0){
				UserMngDatabase um = UserMngDatabase.getInstance();
				UsersBean suser  = um.getUsersBean(ck_acar_id);
				UsersBean tuser  = um.getUsersBean(in_id);
				
				
				String target_id = tuser.getId();
		      	String target_nm = tuser.getUser_nm();
				
				String title = "운행정지명령신청요청";
		    	String sender_id = suser.getId();
		    	String sender_nm = suser.getUser_nm();
				
		    	String content= cp_bean.getTitle()+ "고객의 \n"+ 
		    				"운행정지명령신청요청이 처리되었습니다. 확인부탁드립니다.";
		    	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/fms2/cooperation/cooperation_n4_frame.jsp";
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
	}else if(gubun.equals("cls_dt")){
		if(cls_dt.equals("")){
			cp_bean.setCls_dt	(cls_dt);			
		}else{
			cls_dt = cls_dt.replaceAll("-","");
			if(cls_dt.length()>8) cls_dt.substring(0,8);
			cp_bean.setCls_dt	(cls_dt);
		}
		count = cp_db.updateClsdt(cp_bean);
		if(count>0) flag = true;
		
	}else if(gubun.equals("cancel")){
		if(!cp_bean.getOut_dt().equals("") && !in_id.equals("")){
			if(cp_bean.getOut_content().equals("발송")){
				cp_bean.setOut_content	("");
			}
			cp_bean.setOut_dt	("");
			count = cp_db.updateCancel(cp_bean);
			
			//메세지 보내기 - 등록자한테 보내기
			if(count > 0){
				UserMngDatabase um = UserMngDatabase.getInstance();
				UsersBean suser  = um.getUsersBean(ck_acar_id);
				UsersBean tuser  = um.getUsersBean(in_id);
				
				
				String target_id = tuser.getId();
		      	String target_nm = tuser.getUser_nm();
				
				String title = "운행정지명령신청요청";
		    	String sender_id = suser.getId();
		    	String sender_nm = suser.getUser_nm();
				
		    	String content= cp_bean.getTitle()+ "고객의 \n"+ 
		    				"운행정지명령신청요청이 취소되었습니다. 확인부탁드립니다.";
		    	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/fms2/cooperation/cooperation_n4_frame.jsp";
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
	}else if(gubun.equals("delete")){
		if(!cp_bean.getOut_content().equals("발송") && !in_id.equals("")){
			count = cp_db.delcooperation(cp_bean);
			if(count>0) flag = true;
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
	var gubun ='<%=gubun%>';
	if(flag){
		if(gubun == 'out_dt'){
			opener.parent.parent.location='cooperation_n4_frame.jsp?gubun2=3'; 
		}else{
			opener.parent.location.reload();
		}		
		self.close();
	}else{
		alert("처리중 오류발생");
		opener.parent.location.reload();
		document.window.close();
		
	}
	

</script>
</head>
<body>
	

</body>
</html>
