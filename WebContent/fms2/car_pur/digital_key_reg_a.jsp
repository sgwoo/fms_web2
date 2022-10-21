<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	boolean flag = true;
	boolean flag2 = true;
	
	//디지탈키정보
	Hashtable key = ec_db.getDigitalKey(m_id, l_cd);
	
	key.put("FIRM_NM",  request.getParameter("com_firm_nm")==null?"":request.getParameter("com_firm_nm"));
	key.put("FIRM_TEL", request.getParameter("com_firm_tel")==null?"":request.getParameter("com_firm_tel"));
	key.put("ETC",      request.getParameter("etc")==null?"":request.getParameter("etc"));
	key.put("START_DT", request.getParameter("start_dt")==null?"":request.getParameter("start_dt"));
	key.put("END_DT",   request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));
	
	if(mode.equals("i") || String.valueOf(key.get("RENT_L_CD")).equals("")||String.valueOf(key.get("RENT_L_CD")).equals("null")){
		key.put("RENT_MNG_ID",  m_id);
		key.put("RENT_L_CD",  l_cd);
		key.put("REG_ID",  ck_acar_id);
		//등록
		flag = ec_db.insertCarDigitalKey(key);
		
		Hashtable est = a_db.getRentEst(m_id, l_cd);
		
		//출고관리자 메시지 발송
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		
		String sub 		= "디지털키 신청";
		String cont 	= "["+firm_nm+" "+String.valueOf(est.get("CAR_NO"))+"] 디지털키 등록 신청합니다. 처리하시기 바랍니다.";
		
		UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
		
		String target_id = nm_db.getWorkAuthUser("출고관리자");
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String target_id2 = nm_db.getWorkAuthUser("디지털키부담당");
		UsersBean target_bean2 	= umd.getUsersBean(target_id2);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL></URL>";
		
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		
		//휴가시 업무대체자
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_bean.getUser_id());
		if(!cs_bean.getUser_id().equals("")){
			target_bean 	= umd.getUsersBean(cs_bean.getWork_id());
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		}
		
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
		
	}else if(mode.equals("u")){
		//수정
		flag = ec_db.updateCarDigitalKey(key);
	}else if(mode.equals("d")){
		//삭제
		flag = ec_db.deleteCarDigitalKey(key);
	}
	
	
	
%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<script language='javascript'>
<%		if(!flag){	%>	alert('디지털키 등록 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>       
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='m_id' 	value='<%=m_id%>'>
  <input type='hidden' name='l_cd' 	value='<%=l_cd%>'>
  <input type='hidden' name='mode' 	value='<%=mode%>'>
  
</form>
<script language='javascript'>
<%	if(!flag){%>
alert("처리되지 않았습니다");
location='about:blank';		
<%	}else{		%>		
alert("처리되었습니다");
parent.window.close();
parent.opener.location.reload();
<%	}			%>
</script>
</body>
</html>