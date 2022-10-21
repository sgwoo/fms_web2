<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.coolmsg.*, acar.car_sche.* "%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	boolean flag1 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	

			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub 		= "자동차등록완료";
			String cont 	= "신차 자동차등록이 완료되었습니다. 확인바랍니다.";
			String target_id = nm_db.getWorkAuthUser("본사보험담당");
			
			
			CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_id);
			if(!cs_bean7.getUser_id().equals("")){
				if(cs_bean7.getTitle().equals("오전반휴")){
					//등록시간이 오전(12시전)이라면 대체자, 아니면 본인
					target_id = nm_db.getWorkAuthUser("본사보험담당");
				}else if(cs_bean7.getTitle().equals("오후반휴")){
					//등록시간이 오후(12시이후)라면 대체자, 아니면 본인
					target_id = nm_db.getWorkAuthUser("보험담당자");
				}else{//연차
					target_id = nm_db.getWorkAuthUser("보험담당자");
				}
			}
			
			//사용자 정보 조회
			UsersBean target_bean2 	= umd.getUsersBean(target_id);
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			xml_data2 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			flag1 = cm_db.insertCoolMsg(msg2);
		
		
%>
<script language='javascript'>

<%	if(result>0){%>
		alert("처리되지 않았습니다");
<%	}else{		%>		
		alert("처리되었습니다");
<%	}			%>
</script>