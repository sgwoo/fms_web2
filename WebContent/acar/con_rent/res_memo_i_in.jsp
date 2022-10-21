<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="em_bean" class="acar.res_search.RentMBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String msg_st = request.getParameter("msg_st")==null?"":request.getParameter("msg_st");
	
	RentMBean em_r [] = rs_db.getRentMAll(s_cd);
		
	CommonDataBase c_db = CommonDataBase.getInstance();
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
<form action="./res_memo_i_in.jsp" name="form1" method="post">
 <input type="hidden" name="user_id" value="<%=user_id%>">
 <input type="hidden" name="s_cd" value="<%=s_cd%>">
 <input type="hidden" name="c_id" value="<%=c_id%>">
 <input type="hidden" name="msg_st" value="<%=msg_st%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <%
    for(int i=0; i<em_r.length; i++){
        em_bean = em_r[i];
%>
                <tr> 
                    <td width=10% align=center><%if(em_bean.getSub().equals("반차알림")){%>알림<%}else{%>통화<%}%></td>
                    <td width=16% align=center><%= AddUtil.ChangeDate2(em_bean.getReg_dt()) %></td>
                    <td width=13% align=center><%=c_db.getNameById(em_bean.getUser_id(), "USER")%></td>
                    <td width=13% align="center"><%=em_bean.getSub()%></td>
                    <td width=48%>&nbsp;<%=Util.htmlBR(em_bean.getNote())%></td>
                </tr>
        <%}%>
        <% if(em_r.length == 0) { %>
                <tr> 
                    <td align=center height=25 colspan="5">등록된 데이타가 없습니다.</td>
                </tr>
        <%}%>
            </table>
        </td>
    </tr>
</table> 
</form>
</body>
</html>