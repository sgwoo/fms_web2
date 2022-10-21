<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String user_id 		= "";
	String br_id 		= "";
	String user_nm 		= "";
	String id 			= "";
	String user_psd 	= "";
	String user_cd 		= "";
	String user_ssn 	= "";
	String dept_id 		= "";
	String user_h_tel 	= "";
	String user_m_tel 	= "";
	String user_email 	= "";
	String user_pos 	= "";
	String user_aut 	= "";
	String lic_no 		= "";
	String lic_dt 		= "";
	String enter_dt 	= "";
	String cmd 			= "";
	String user_work 	= request.getParameter("user_work")==null?"":request.getParameter("user_work");	
	String user_i_tel 	= request.getParameter("user_i_tel")==null?"":request.getParameter("user_i_tel");
	String taste 		= request.getParameter("taste")==null?"":request.getParameter("taste");
	String special 		= request.getParameter("special")==null?"":request.getParameter("special");
	String sa_code 		= request.getParameter("sa_code")==null?"":request.getParameter("sa_code");
	String agent_id 	= request.getParameter("agent_id")==null?"":request.getParameter("agent_id");
	int count = 0;
	
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd"); //update, inpsert 구분

	if(cmd.equals("i")||cmd.equals("u"))
	{
		if(request.getParameter("user_id") !=null) 		user_id 	= request.getParameter("user_id");
		if(request.getParameter("br_id") !=null) 		br_id 		= request.getParameter("br_id");
		if(request.getParameter("user_nm") !=null) 		user_nm 	= request.getParameter("user_nm");
		if(request.getParameter("id") !=null) 			id 			= request.getParameter("id");
		if(request.getParameter("user_psd") !=null) 	user_psd 	= request.getParameter("user_psd");
		if(request.getParameter("user_cd") !=null) 		user_cd 	= request.getParameter("user_cd");
		if(request.getParameter("user_ssn") !=null) 	user_ssn 	= request.getParameter("user_ssn");
		if(request.getParameter("dept_id") !=null) 		dept_id 	= request.getParameter("dept_id");
		if(request.getParameter("user_h_tel") !=null) 	user_h_tel 	= request.getParameter("user_h_tel");
		if(request.getParameter("user_m_tel") !=null) 	user_m_tel 	= request.getParameter("user_m_tel");
		if(request.getParameter("user_email") !=null) 	user_email 	= request.getParameter("user_email");
		if(request.getParameter("user_pos") !=null) 	user_pos 	= request.getParameter("user_pos");
		if(request.getParameter("user_aut") !=null) 	user_aut 	= request.getParameter("user_aut");
		if(request.getParameter("lic_no") !=null) 		lic_no 		= request.getParameter("lic_no");
		if(request.getParameter("lic_dt") !=null) 		lic_dt 		= request.getParameter("lic_dt");
		if(request.getParameter("enter_dt") !=null) 	enter_dt 	= request.getParameter("enter_dt");
		
		user_bean.setUser_id	(user_id);
		user_bean.setBr_id		(br_id);
		user_bean.setUser_nm	(user_nm);
		user_bean.setId			(id);
		user_bean.setUser_psd	(user_psd);
		user_bean.setUser_cd	(user_cd);
		user_bean.setUser_ssn	(user_ssn);
		user_bean.setDept_id	(dept_id);
		user_bean.setUser_h_tel	(user_h_tel);
		user_bean.setUser_m_tel	(user_m_tel);
		user_bean.setUser_i_tel	(user_i_tel);
		user_bean.setUser_email	(user_email);
		user_bean.setUser_pos	(user_pos);
		user_bean.setUser_aut	(user_aut);
		user_bean.setLic_no		(lic_no);
		user_bean.setLic_dt		(lic_dt);
		user_bean.setEnter_dt	(enter_dt);
		user_bean.setUser_work	(user_work);
		user_bean.setZip		(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
		user_bean.setAddr		(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
		user_bean.setMail_id	(request.getParameter("mail_id")==null?"":request.getParameter("mail_id"));
		user_bean.setLoan_st	(request.getParameter("loan_st")==null?"":request.getParameter("loan_st"));
		user_bean.setTaste		(request.getParameter("taste")==null?"":request.getParameter("taste"));
		user_bean.setSpecial	(request.getParameter("special")==null?"":request.getParameter("special"));
		user_bean.setSa_code	(sa_code);	//영업사원코드 추가(20181105)
		user_bean.setUse_yn		("Y");
		
		
		
		if(cmd.equals("i")){
			count = umd.insertUser(user_bean);
			
			//에이전트 사용자 등록시 에이전트관리번호 연동처리
			if(dept_id.equals("1000") && !agent_id.equals("")){
				count = umd.updateEmpAgent(sa_code, agent_id);	
			}
			
		}else if(cmd.equals("u")){
			count = umd.updateUser(user_bean);
		}
		
		
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>

<script>
<%
	if(cmd.equals("u"))
	{
		if(count==1)
		{
%>
alert("정상적으로 수정되었습니다.");
parent.window.close();
parent.opener.location.reload();

<%
		}
	}else{
		if(count==1)
		{
%>
alert("정상적으로 등록되었습니다.");
parent.window.close();
parent.opener.location.reload();

<%
		}
	}
%>
</script>
</body>
</html>