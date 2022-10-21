<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.coolmsg.*,   acar.cus_samt.*,  acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.cus_samt.CusSamt_Database"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");	
		
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
				
    System.out.println("s_year=" + s_year + ":s_mon =" + s_mon+ ":acct=" + acct+ ":t_wd = " + t_wd);
           		
         
         //견적서 첨부여부   		
           		
	boolean flag1 = true;
	boolean flag2 = true;
	
	int scan_cnt = 0;
	
	scan_cnt = cs_db. getScanFileCnt(s_year,  s_mon, t_wd, acct);
		
	if (scan_cnt < 1) { 
	
		flag1 = cs_db.updateServiceSetReqDt( s_year, s_mon, t_wd, acct, user_id);
		
		//고객지원부팀장에게 메세지 전달
		String doc_cont = "";
		
		if ( acct.equals("000620") ) {
				doc_cont = "명진자동차공업사" + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요
		} else if (acct.equals("002105") ) {
				doc_cont = "부경자동차정비" + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요
		} else if (acct.equals("000286") ) {
				doc_cont = "정일현대자동차공업(주)" + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요		
		} else if (acct.equals("006858") ) {
				doc_cont = " 오토크린 " + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요			
		} else if (acct.equals("007603") ) {
				doc_cont = " 노블래스 " + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요					
		} else if (acct.equals("001816") ) {
				doc_cont = " 삼일정비 " + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요		
		} else if (acct.equals("007897") ) {
				doc_cont = " 1급금호자동차정비 " + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요					
		} else if (acct.equals("008462") ) {
				doc_cont = "(주) 성서현대정비센터  " + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요					
		} else if (acct.equals("008507") ) {
				doc_cont = " 상무현대정비 " + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요		
		} else if (acct.equals("008611") ) {
				doc_cont = " (주)옥산자동차공업사 " + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요											
		} else {
			         doc_cont = "(주)현대카독크" + s_year + "년" + s_mon + "월" + t_wd + "회차 차량정비비"; //적요		
		}
		
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
		String sub 	= "정비비 결재 청구 확인";
		String cont 	= "▣ 정비비결재 청구 확인요청 :: 요청자:" + sender_bean.getUser_nm()+ ", 내용:"+doc_cont ;  	
									
		String url 		= "";	
		url 		= "/acar/cus_samt/cus_samt_s1_frame.jsp";		 
		 	
		String target_id = "000026";  //고객지원부팀장 		 
			
							
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	//	xml_data += "    <TARGET>2006007</TARGET>";
		
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
			
		System.out.println("쿨메신저(정비비 결재 청구 확인)"+s_year + s_mon +  "---"+ acct +"----"+target_bean.getUser_nm());	
	
	}
%>
<script language='javascript'>
<% if ( scan_cnt > 0) {%>
		alert('견적서 첨부가 안된건이 있습니다. 청구할 수 없습니다.!!!');	
<% } else {%>		
<%	if(flag1){%>
		alert('정상적으로 처리되었습니다');	
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
<% }%>
</script>
</body>
</html>
