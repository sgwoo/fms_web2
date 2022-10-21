<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, tax.*, acar.user_mng.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html> 
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
		
	String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
	String sendphone	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
	String destphone	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String msg 		= request.getParameter("msg")==null?"":request.getParameter("msg");
	String msglen 		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_no 	= request.getParameter("car_no")==null?"1":request.getParameter("car_no");	
	String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	
	msg_type = "5";

	if(!destphone.equals("")){
		
				//MMS
				String rqdate = "";
				if(msg_subject.equals("")) msg_subject = "차량 검사 안내 문자";
				
				//즉시
	
				String reg_id = ck_acar_id;
				
				//알림톡 acar0051 차량 검사 안내 문자
				String customer_name 	= firm_nm;				// 고객이름
				String car_num 				= car_no;					// 차량번호
				String etc1 = l_cd;
				String etc2 = reg_id;
	
	      //acar0051 -> acar0070 -> acar0208 문구수정
				List<String> fieldList = Arrays.asList(customer_name, car_num, sendname, sendphone);
			
				
					//즉시
				if(req_dt.equals("")){
					at_db.sendMessageReserve("acar0208", fieldList, destphone, sendphone, null , etc1,  etc2);
				//예약	
				}else{
					String req_time = req_dt;
					
					if(req_dt_h.equals("")) req_dt_h = "09";
					if(req_dt_s.equals("")) req_dt_s = "00";
					
					req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
					at_db.sendMessageReserve("acar0208", fieldList, destphone, sendphone, req_time , etc1, etc2 );
			  }
	}
%>
<script language='javascript'>
<!--
	alert('전송되었습니다.');
//-->
</script>
</body>
</html>