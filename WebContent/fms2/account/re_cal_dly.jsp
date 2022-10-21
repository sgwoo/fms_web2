<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String incom_dt = request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	
	int dly_amt = 0;
	
	dly_amt = in_db.getReCalDelayAmt(m_id, l_cd, incom_dt);		
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>

</script>
</head>
<body leftmargin="15" ">
<form action="" name="form1" method="post" >
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='incom_dt' value='<%=incom_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width=250>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>계약번호: <%=l_cd%> </span></td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
      <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle>입금일&nbsp;&nbsp;: <%=AddUtil.ChangeDate2(incom_dt)%> </td>
    </tr>
       <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle>연체료&nbsp;&nbsp;: <%=AddUtil.parseDecimal(dly_amt)%> </td>
    </tr>
   
    <tr> 
        <td align="right"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
