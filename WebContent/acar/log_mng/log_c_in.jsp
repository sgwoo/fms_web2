<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	String s_gubun4 = request.getParameter("s_gubun4")==null?"":request.getParameter("s_gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	
	
	Vector conts = m_db.getLogListCase(client_id, r_site, member_id, s_yy, AddUtil.addZero(s_mm));
	int cont_size = conts.size();
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td class='line'> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<%if(cont_size > 0){
				for(int i = 0 ; i < cont_size ; i++){
				Hashtable cont = (Hashtable)conts.elementAt(i);
				String yn=String.valueOf(cont.get("Y_CNT"));
				%>
				<tr> 
					<td <%if(yn.equals("0"))%>class=is2<%%> align='center' width="8%"><a name=<%=i+1%>><%=i+1%></a></td>
					<td <%if(yn.equals("0"))%>class=is2<%%> align='center' width="25%"> 
					<%=AddUtil.ChangeDate3(String.valueOf(cont.get("LOGIN_DT")))%></td>
					<td <%if(yn.equals("0"))%>class=is2<%%> align='center' width="25%"><%=AddUtil.ChangeDate3(String.valueOf(cont.get("LOGOUT_DT")))%></td>
					<td <%if(yn.equals("0"))%>class=is2<%%> align='center' width="42%"><%=cont.get("IP")%></td>
				</tr>
					<%	}
					}else{%>
				<tr> 
					<td align='center' colspan="4" >해당 데이타가 없습니다.</td>
				</tr>
					<%}%>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
