<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.estimate_mng.*, acar.common.*" %>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiMBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();		
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	EstiMBean em_r [] = e_db.getEstiMAll(est_id, user_id);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--


//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <%
    for(int i=0; i<em_r.length; i++){
        em_bean = em_r[i];
%>
                <tr> 
                    <td width=22% align=center><%= AddUtil.ChangeDate3(em_bean.getReg_dt()) %></td>
                    <td width=14% align=center><%=c_db.getNameById(em_bean.getUser_id(), "USER")%></td>
                    <td width=64%>&nbsp;<%=Util.htmlBR(em_bean.getNote())%></td>
                </tr>
        <%}%>
        <% if(em_r.length == 0) { %>
                <tr> 
                    <td align=center height=25 colspan="3">등록된 데이타가 없습니다.</td>
                </tr>
        <%}%>
            </table>
        </td>
    </tr>
</table>
<form action="./esti_memo_i_in.jsp" name="form1" method="post">
<input type="hidden" name="est_id" value="<%=est_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
</form>

</body>
</html>