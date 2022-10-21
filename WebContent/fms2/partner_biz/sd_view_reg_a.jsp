<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.partner.*"%>
<jsp:useBean id="BcBean" 	scope="page" class="acar.partner.BizcardBean"/>

<%@ include file="/acar/cookies.jsp" %>

<%

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID

	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");//1:방문, 3:전화  2:메일, 4:종결 
	String sd_dt 	= request.getParameter("sd_dt")==null?"":request.getParameter("sd_dt");
	String g_smng1 	= request.getParameter("g_smng1")==null?"":request.getParameter("g_smng1");
	String g_smng2 	= request.getParameter("g_smng2")==null?"":request.getParameter("g_smng2");
	String g_smng3 	= request.getParameter("g_smng3")==null?"":request.getParameter("g_smng3");
	
	String d_smng1 	= request.getParameter("d_smng1")==null?"":request.getParameter("d_smng1");
	String d_smng2 	= request.getParameter("d_smng2")==null?"":request.getParameter("d_smng2");
	String d_smng3 	= request.getParameter("d_smng3")==null?"":request.getParameter("d_smng3");
	
	String item1 	= request.getParameter("item1")==null?"":request.getParameter("item1");
	String item2	= request.getParameter("item2")==null?"":request.getParameter("item2");
	String note 	= request.getParameter("note")==null?"":request.getParameter("note"); 

	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");  	
	
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();

	int count = 0;
	
	if(serv_id.equals("")){
		serv_id = se_dt.getNextEvalServ_id(off_id);
	}
	
	if(cmd.equals("end")){
			count = se_dt.updateEndBCSD(user_id, "Y", off_id, serv_id);
	}else if(cmd.equals("sd_modify")){
		BcBean.setOff_id		(off_id);
		BcBean.setServ_id		(serv_id);
		BcBean.setGubun			(gubun);
		BcBean.setSd_dt			(sd_dt);
		BcBean.setG_smng1		(g_smng1);
		BcBean.setG_smng2		(g_smng2);
		BcBean.setG_smng3		(g_smng3);
		BcBean.setD_smng1		(d_smng1);
		BcBean.setD_smng2		(d_smng2);
		BcBean.setD_smng3		(d_smng3);
		BcBean.setItem1			(item1);		
		BcBean.setItem2			(item2);		
		BcBean.setNote			(note);
		BcBean.setUpdate_id		(user_id);
	
		count = se_dt.updatesd_vidw_modify(BcBean);
	}else{

	
		BcBean.setOff_id		(off_id);
		BcBean.setServ_id		(serv_id);
		BcBean.setGubun			(gubun);
		BcBean.setSd_dt			(sd_dt);
		BcBean.setG_smng1		(g_smng1);
		BcBean.setG_smng2		(g_smng2);
		BcBean.setG_smng3		(g_smng3);
		BcBean.setD_smng1		(d_smng1);
		BcBean.setD_smng2		(d_smng2);
		BcBean.setD_smng3		(d_smng3);
		BcBean.setItem1			(item1);		
		BcBean.setItem2			(item2);		
		BcBean.setNote			(note);
		BcBean.setReg_id		(user_id);
	
		count = se_dt.insertBCSD(BcBean);
		
	}	
	
		
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<% if(count==1){ %>
	alert("정상적으로 처리되었습니다.");
	parent.parent.location.reload();
	parent.close();				
<%}else{%>
	alert("에러발생!");
<%}%>

</script>
</body>
</html>

