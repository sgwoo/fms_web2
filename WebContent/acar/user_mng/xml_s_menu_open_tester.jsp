<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String m_st = request.getParameter("m_st")==null?"":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	
	String vid1[] 		= request.getParameterValues("ch_m_cd");
	String vid2[] 		= request.getParameterValues("m_url");
	
	int vid_size = vid1.length;
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>사용자관리</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>

</head>

<body>

<form name="form1" method="POST" >
<%for(int i=0;i < vid_size;i++){ %>
<input type='hidden' name='menu' value='<%=vid2[i]%>'>
<%} %>
<table border=0 cellspacing=0 cellpadding=0  width=500>
    <tr>
        <td><font color=red>[메뉴 테스트]</font></td>
    </tr>
    <tr>
        <td width="right">(<%=vid_size %>건)</td>
    </tr>    
 
</table>
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
	
	for(i=0; i<<%=vid_size%>; i++){
		var o_var;
		if(<%=vid_size%>==1){
			o_var = fm.menu.value;
		}else{
			o_var = fm.menu[i].value;
		}
		var o_var_split = o_var.split("||");
		var m_st 	= o_var_split[0];
		var m_st2 	= o_var_split[1];
		var m_cd  	= o_var_split[2];
		var url  	= o_var_split[3];
		window.open(url+"?m_st="+m_st+"&m_st2="+m_st2+"&m_cd="+m_cd, "OpenMneu_"+i, "left=10, top=10, width=1600, height=900, scrollbars=yes");
	}						
//-->
</script>
</body>
</html>