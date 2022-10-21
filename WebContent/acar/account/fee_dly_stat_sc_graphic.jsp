<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>

<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int    s_days 		= 31;
	String while_day 	= "31";
	String all 		= "";
	
	
	Hashtable ht = ac_db.getStatIncomPayDlyList(12, s_yy+""+s_mm);			

	for(int i=1; i<=s_days; i++){
	
		all += String.valueOf(ht.get("AMT_"+AddUtil.addZero2(i)));
		
		if(i < s_days) all += "/";
	}
	
	
%>
<form name='form1' method='post' action=''>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_yy'  	value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 	value='<%=s_mm%>'>		
  <table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr> 
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="3">&nbsp;</td>
		  </tr>	
          <tr>
            <td width="150">&nbsp;</td>			
            <td>
			  <applet codebase="/applet" code="StatGraphic.class" width=570 height=400>
				<PARAM name="height" value="400">
				<PARAM name="width" value="570">
				<PARAM name="from_day" value="<%=s_yy%><%=s_mm%>01">
				<PARAM name="while_day" value="<%=while_day%>">
				<PARAM name="heigh_max" value="100">
				<PARAM name="all" value="<%=all%>">
				<PARAM name="succ" value="0">
				<PARAM name="wait" value="0">
				<PARAM name="fail" value="0">				
			  </applet>										  
			</td>
            <td width="100">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
