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
	String area_id 		= request.getParameter("gundea")==null?"":request.getParameter("area_id");
	
	int count = 0;
	boolean user_m_tel_chk = false;
	boolean hot_tel_chk = false;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean 	= umd.getUsersBean(user_id);
	if(!user_bean.getUser_m_tel().replace("-","").equals(user_m_tel.replace("-",""))){	user_m_tel_chk = true;	}
	if(!user_bean.getHot_tel().replace("-","").equals(hot_tel.replace("-",""))){			hot_tel_chk = true;		}
	
	String o_psd = user_bean.getUser_psd();
	
	
//	user_bean.setUser_id(user_id);
	user_bean.setBr_id(br_id);
	user_bean.setUser_nm(user_nm);
	user_bean.setId(id);
	user_bean.setUser_psd(user_psd);
	user_bean.setUser_cd(user_cd);
	user_bean.setUser_ssn(user_ssn);
	user_bean.setDept_id(dept_id);
	user_bean.setUser_h_tel(user_h_tel);
	user_bean.setUser_m_tel(user_m_tel);
	user_bean.setUser_i_tel(user_i_tel);
	user_bean.setUser_email(user_email);
	user_bean.setUser_pos(user_pos);
	user_bean.setUser_aut(user_aut2);
	user_bean.setLic_no(lic_no);
	user_bean.setLic_dt(lic_dt);
	user_bean.setEnter_dt(enter_dt);
	user_bean.setContent(content);
	user_bean.setFilename(filename);
	user_bean.setZip(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
	user_bean.setAddr(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
	user_bean.setMail_id(request.getParameter("mail_id")==null?"":request.getParameter("mail_id"));
	user_bean.setLoan_st(request.getParameter("loan_st")==null?"":request.getParameter("loan_st"));
	user_bean.setUser_work(user_work);
	user_bean.setFax_id(fax_id);
	user_bean.setFax_pw(fax_pw);
	user_bean.setPartner_id(partner_id);
	user_bean.setI_fax(i_fax);
	user_bean.setIn_tel(in_tel);
	user_bean.setHot_tel(hot_tel);
	user_bean.setTaste	(request.getParameter("taste")==null?"":request.getParameter("taste"));
	user_bean.setSpecial	(request.getParameter("special")==null?"":request.getParameter("special"));
	user_bean.setGundea	(request.getParameter("gundea")==null?"":request.getParameter("gundea"));
	user_bean.setAdd_per	(request.getParameter("add_per")	==null? 0:AddUtil.parseFloat(request.getParameter("add_per")));
	user_bean.setArea_id	(request.getParameter("area_id")==null?"":request.getParameter("area_id"));
	user_bean.setHome_zip(request.getParameter("h_zip")==null?"":request.getParameter("h_zip"));
	user_bean.setHome_addr(request.getParameter("h_addr")==null?"":request.getParameter("h_addr"));
	
	if(cmd.equals("i")){
		count = umd.insertUser(user_bean);
	}else if(cmd.equals("u")){
		count = umd.updateUser(user_bean);
		
		String n_psd = user_bean.getUser_psd();

		//비밀번호 변경시 메신저 동기화 프로시저 호출
		if(!o_psd.equals(n_psd)){
			//프로시저 호출
			int flag4 = 0;
			String  d_flag1 =  cm_db.call_sp_sync_db_all();
			System.out.println(d_flag1);
			if (!d_flag1.equals("0")) flag4 = 1;
			System.out.println("비밀번호 변경시 메신저 동기화 프로시저 호출 등록="+user_bean.getUser_nm());
		}

		
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
			String cont 	= "[사용자 연락처 변경 안내] &lt;br&gt; &lt;br&gt; [ "+ user_nm + " ] 님 의  &lt;br&gt; &lt;br&gt; ";
			if(user_m_tel_chk == true){	cont += "휴대전화번호가 " + user_m_tel + " (으)로  &lt;br&gt; &lt;br&gt; ";	}
			if(hot_tel_chk == true){	cont += "사무실(직통)번호가 " + hot_tel + " (으)로  &lt;br&gt; &lt;br&gt; ";	}
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
	}else if(cmd.equals("i")){
		if(count==1){%>
	alert("정상적으로 등록되었습니다.");
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