<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//사용자별 정보 등록/수정 처리 페이지
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");//update, inpsert 구분
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_nm 		= request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String id 		= request.getParameter("id")==null?"":request.getParameter("id");
	String user_psd 	= request.getParameter("user_psd")==null?"":request.getParameter("user_psd");
	String user_cd 		= request.getParameter("user_cd")==null?"":request.getParameter("user_cd");
	String user_ssn 	= request.getParameter("user_ssn")==null?"":request.getParameter("user_ssn");
	String dept_id 		= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_h_tel 	= request.getParameter("user_h_tel")==null?"":request.getParameter("user_h_tel");
	String user_m_tel 	= request.getParameter("user_m_tel")==null?"":request.getParameter("user_m_tel");
	String user_i_tel 	= request.getParameter("user_i_tel")==null?"":request.getParameter("user_i_tel");
	String user_email 	= request.getParameter("user_email")==null?"":request.getParameter("user_email");
	String user_pos 	= request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String user_job 	= request.getParameter("user_job")==null?"":request.getParameter("user_job");
	String user_aut2 	= request.getParameter("user_aut2")==null?"":request.getParameter("user_aut2");
	String lic_no 		= request.getParameter("lic_no")==null?"":request.getParameter("lic_no");
	String lic_dt 		= request.getParameter("lic_dt")==null?"":request.getParameter("lic_dt");
	String enter_dt 	= request.getParameter("enter_dt")==null?"":request.getParameter("enter_dt");
	String content 		= request.getParameter("content")==null?"":request.getParameter("content");
	String filename 	= request.getParameter("filename")==null?"":request.getParameter("filename");
	String user_work 	= request.getParameter("user_work")==null?"":request.getParameter("user_work");
	String fax_id	 	= request.getParameter("fax_id")==null?"":request.getParameter("fax_id");
	String fax_pw	 	= request.getParameter("fax_pw")==null?"":request.getParameter("fax_pw");
	String partner_id 	= request.getParameter("partner_id")==null?"":request.getParameter("partner_id");
	String i_fax	 	= request.getParameter("i_fax")==null?"":request.getParameter("i_fax");
	String in_tel	 	= request.getParameter("in_tel")==null?"":request.getParameter("in_tel");
	String hot_tel	 	= request.getParameter("hot_tel")==null?"":request.getParameter("hot_tel");
	String taste 		= request.getParameter("taste")==null?"":request.getParameter("taste");
	String special 		= request.getParameter("special")==null?"":request.getParameter("special");
	String gundea 		= request.getParameter("gundea")==null?"":request.getParameter("gundea");
	String area_id 		= request.getParameter("area_id")==null?"":request.getParameter("area_id");
	
	int count = 0;
	boolean user_m_tel_chk = false;
	boolean hot_tel_chk = false;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	user_bean 	= umd.getUsersBean(user_id);
	
	if(!user_bean.getUser_m_tel().replace("-","").equals(user_m_tel.replace("-",""))){		user_m_tel_chk = true;	}
	if(!user_bean.getHot_tel().replace("-","").equals(hot_tel.replace("-",""))){			hot_tel_chk = true;		}
	
	String o_psd = user_bean.getUser_psd();
	
	
	user_bean.setBr_id(br_id);
	user_bean.setDept_id(dept_id);
	user_bean.setUser_pos(user_pos);
	user_bean.setUser_job(user_job);
	user_bean.setLoan_st(request.getParameter("loan_st")==null?"":request.getParameter("loan_st"));
	user_bean.setIn_tel(in_tel);
	user_bean.setHot_tel(hot_tel);
	user_bean.setI_fax(i_fax);
	user_bean.setPartner_id(partner_id);
	user_bean.setUser_h_tel(user_h_tel);
	user_bean.setUser_m_tel(user_m_tel);
	user_bean.setUser_email(user_email);
	user_bean.setZip(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
	user_bean.setAddr(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
	user_bean.setHome_zip(request.getParameter("h_zip")==null?"":request.getParameter("h_zip"));
	user_bean.setHome_addr(request.getParameter("h_addr")==null?"":request.getParameter("h_addr"));
	user_bean.setUser_work(user_work);
	user_bean.setContent(content);

	if(cmd.equals("u")){	
		count = umd.updateUser(user_bean);
	}else if(cmd.equals("d")){
		user_bean.setOut_dt(request.getParameter("out_dt")==null?"":request.getParameter("out_dt"));
		user_bean.setDept_id(request.getParameter("dept_id")==null?"":request.getParameter("dept_id"));
		count = umd.updateUserOut(user_bean);
	}
	
	//사용자 휴대전화번호, 사무실(직통)번호 수정시 류길선과장 에게 쿨메신저 발송(2018.05.25) 
	if(cmd.equals("u") && count == 1){
		if(user_m_tel_chk == true || hot_tel_chk == true){
			
			UsersBean target_bean 	= umd.getUsersBean("000096");	//류길선과장님
			
			String sub 		= "[사용자 연락처 변경 안내]";
			String cont 	= "[사용자 연락처 변경 안내]\n\n[ "+ user_nm + " ] 님 의 \n\n";
			if(user_m_tel_chk == true){	cont += "휴대전화번호가 " + user_m_tel + " (으)로 \n\n";	}
			if(hot_tel_chk == true){	cont += "사무실(직통)번호가 " + hot_tel + " (으)로 \n\n";	}
			cont += "변경되었습니다.";
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
	  					"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
	  					"    <CONT>"+cont+"</CONT>"+
	  					"    <URL></URL>";
			//받는사람
			xml_data += "    <TARGET>"+ target_bean.getId() +"</TARGET>";
			//보낸사람
			xml_data += "    <SENDER>"+ id +"</SENDER>"+
	  					"    <MSGICON>10</MSGICON>"+
	  					"    <MSGSAVE>1</MSGSAVE>"+
	  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
	  					"  </ALERTMSG>"+
	  					"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			boolean flag = cm_db.insertCoolMsg(msg);
		}		
	}
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<%	if(cmd.equals("u")){
		if(count==1){%>
	alert("정상적으로 수정되었습니다.");
	parent.location.reload();
<%		}
	}else{
		if(count==1){%>
	alert("정상적으로 퇴사처리 되었습니다.");
	parent.location.reload();
<%		}
	}%>

</script>
</body>
</html>