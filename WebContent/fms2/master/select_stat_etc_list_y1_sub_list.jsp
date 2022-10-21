<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String content_code	= request.getParameter("content_code")==null?"":request.getParameter("content_code");
	String settle_month	= request.getParameter("settle_month")==null?"":request.getParameter("settle_month");
	
	
	//알림톡발송현황
	Vector vt = ad_db.getSelectStatEtc_list_y1_sublist(content_code, settle_year, settle_month);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=1200>
	<tr>
	  <td colspan="5" align="center"><%=AddUtil.parseInt(settle_year)%>년<%=AddUtil.parseInt(settle_month)%>월 <%=content_code%> 알림톡발송현황</td>
	</tr>		
	<tr>
	  <td colspan="5">&nbsp;</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td width="50" class="title">연번</td>
				  <td width="85" class="title">요청시간</td>
				  <td width="85" class="title">전송시간</td>
				  <td width="100" class="title">결과(코드)</td>
				  <td width="100" class="title">발신번호</td>
				  <td width="100" class="title">수신번호</td>
				  <td width="680" class="title">내용</td>
			    </tr>			    	    
			    <%	for(int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);	   
    					String ENC_STR = "UTF-8";  
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("DATE_CLIENT_REQ")%></td>
				  <td align="right"><%=ht.get("DATE_MT_SENT")%></td>
				  <td align="center"><%=ht.get("REPORT_CODE_NM")%>(<%=ht.get("REPORT_CODE")%>)</td>
				  <td align="center"><%=ht.get("CALLBACK")%></td>
				  <td align="center"><%=ht.get("RECIPIENT_NUM")%></td>
				  <td align="center"><textarea rows='6' cols='100' name='CONTENT' style="border:0" ><%=ht.get("CONTENT")%></textarea></td>
			    </tr>
			    <%	}%>		    
			</table>
		</td>
	</tr>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>


