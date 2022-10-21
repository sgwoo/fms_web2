<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<%

	String ii=  request.getParameter("ii")==null?"":request.getParameter("ii");
	String tr_branch =  request.getParameter("tr_branch")==null?"":request.getParameter("tr_branch");
	String naeyong =  request.getParameter("naeyong")==null?"":request.getParameter("naeyong");
	String jukyo =  request.getParameter("jukyo")==null?"":request.getParameter("jukyo");
		
//	System.out.println("ii=" + ii + "| tr_branch =" + tr_branch + " |naeyong=" + naeyong + "| jukyo = " + jukyo );
			
	Hashtable base = in_db.getInsideClient(tr_branch, naeyong, jukyo);
				
			
%>
	t_fm = parent.form1;
	
	t_fm.firm_nm[<%=ii%>].value		= '<%=base.get("FIRM_NM")%>';
	t_fm.client_id[<%=ii%>].value 		= '<%=base.get("CLIENT_ID")%>';
      
	parent.set_init();		
	
</script>
</body>
</html>
