<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*, acar.cont.*, acar.offls_sui.*, acar.cls.*, acar.credit.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
		
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int    size = request.getParameter("size")==null?0:Util.parseInt(request.getParameter("size"));
	

	String vid[] 	= request.getParameterValues("ch_cd");	
	int vid_size = vid.length;
	
	String chk_cont[]	 = new String[vid_size];
	
	String vid_num		= "";
	String reg_code 	= "";
	String seq 	= "";
	int    idx = 0;
	int    count = 0;
	int flag = 0;
	
	
%>

<html>
<head>
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>

</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>

	var fm = parent.document.form1;
	
<%
	for(int i=0;i < vid_size;i++){
		chk_cont[i] = "정상";
		vid_num = vid[i];
		idx = i;
		int s=0;
	%>	
		fm.chk_cont[<%=i%>].value = '정상';
		<%
	}
%>
	


</script>