<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*, acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>

<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15">
<%
	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m1_no = request.getParameter("m1_no")==null?"":request.getParameter("m1_no");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String che_dt = request.getParameter("che_dt")==null?"":request.getParameter("che_dt");
	String che_nm = request.getParameter("che_nm")==null?"":request.getParameter("che_nm");
	int tot_dist = request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist"));
	String che_type = request.getParameter("che_type")==null?"":request.getParameter("che_type");
	int che_amt = request.getParameter("che_amt")==null?0:AddUtil.parseDigit(request.getParameter("che_amt"));
	String che_remark = request.getParameter("che_remark")==null?"":request.getParameter("che_remark");
	String m1_content = request.getParameter("m1_content")==null?"":request.getParameter("m1_content");
	String use_yn = request.getParameter("use_yn")==null?"":request.getParameter("use_yn");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
		
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
		
	int count = 1;
	boolean flag1 = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();	
		
	if (cmd.equals("D") ) {
		flag1 = mc_db.deleteCarMaintReq(che_dt, m1_no);
	} else {
	//정비정보	
		flag1 = mc_db.updateCarMaintInfo(car_mng_id, m1_no, che_dt, che_nm, tot_dist, che_type, che_amt, che_remark, use_yn, m1_content);
	}	
	
	//검사완료인 경우 담당자에게 메세지 보내기
	//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	String target_id 	= "";
	String sender_id	= "";
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");		
	
   	target_id = mng_id;			
	UsersBean target_bean 	= umd.getUsersBean(target_id);
		
	sender_id = user_id;			
	UsersBean sender_bean 	= umd.getUsersBean(sender_id);
	
	boolean flag6 = true;
	
	if (!cmd.equals("D") ) {
		
		if ( use_yn.equals("Y") && !che_dt.equals("")  ) {	
				
			String sub 		= "자동차 검사 결과안내";
			String cont 	= "["+target_bean.getUser_nm()+"]님이 검사의뢰한 차량번호 "+ car_no + "의 검사가 " + che_dt + "에 완료되었습니다. 검사 등록바랍니다.";
			String url 		= "/acar/cus_pre/cus_pre_frame.jsp?user_id="+mng_id;
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
						
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
		
			flag6 = cm_db.insertCoolMsg(msg);
		
			System.out.println("(자동차검사 결과 안내)----------------------- "+sender_bean.getUser_nm() + "->" +target_bean.getUser_nm() + ":" +car_no +" : 검사일 :" + che_dt);
	
		}	
	
		if ( use_yn.equals("N") || use_yn.equals("X") ) {	
					
			String sub 		= "자동차 검사 진행 안내";
			String cont 	= "["+target_bean.getUser_nm()+"]님이 검사의뢰한 차량번호 "+ car_no + "의 검사가 취소(보류)되었습니다. 담당자 확인후 검사 재의뢰 또는 진행사항 체크 바랍니다.";
			String url 		= "/acar/cus_pre/cus_pre_frame.jsp?user_id="+mng_id;
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";	
						
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
		
			flag6 = cm_db.insertCoolMsg(msg);
		
			System.out.println("(자동차검사 진행 안내)----------------------- "+sender_bean.getUser_nm() + "->" +target_bean.getUser_nm() + ":" +car_no +" : 특이사항 :" + che_remark);
	
		}					
	}
%>
<script language='javascript'>
<%	if(flag1){%>
		alert('정상적으로 처리되었습니다');
		parent.window.close();
	
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
