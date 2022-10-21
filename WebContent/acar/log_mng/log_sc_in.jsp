<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector conts = m_db.getLogList(s_gubun1, s_gubun2, s_gubun3, s_gubun4, s_kd, t_wd);
	int cont_size = conts.size();
	
	//임원이거나 총무팀직원은 전체검색 / 사원이고 총무팀가 아닌 직원은 영업소담당자로 조회
	String id_chk = c_db.getUserBusYn(user_id);
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr> 
		<td class='line' width='100%'> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<%if(cont_size > 0){
				for(int i = 0 ; i < cont_size ; i++){
				Hashtable cont = (Hashtable)conts.elementAt(i);
				String yn=String.valueOf(cont.get("Y_CNT"));
				%>
				<tr> 
					<td <%if(yn.equals("0"))%>class=g<%%> align='center' width=5%><a name=<%=i+1%>><%=i+1%></a></td>
					<td <%if(yn.equals("0"))%>class=g<%%> align='center' width=13%><%=cont.get("MEMBER_ID")%></td>
					<td <%if(yn.equals("0"))%>class=g<%%> align='center' width=22%><span title='<%=cont.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(cont.get("FIRM_NM")), 20)%></span></td>
					<td <%if(yn.equals("0"))%>class=g<%%> align='center' width=12%><span title='<%=cont.get("CLIENT_NM")%>'><%=AddUtil.subData(String.valueOf(cont.get("CLIENT_NM")), 5)%></span></td>
					<td <%if(yn.equals("0"))%>class=g<%%> align='center' width=18%> 
						<span title='<%=cont.get("R_SITE_NM")%>'><%=AddUtil.subData(String.valueOf(cont.get("R_SITE_NM")), 10)%></span></td>
					<td <%if(yn.equals("0"))%>class=g<%%> align='center' width=15%><a href="javascript:parent.getViewCont('<%=i+1%>','<%=cont.get("CLIENT_ID")%>','<%=cont.get("R_SITE")%>','<%=cont.get("MEMBER_ID")%>')"><%=AddUtil.ChangeDate3(String.valueOf(cont.get("LOGIN_DT")))%></a></td>
					<td <%if(yn.equals("0"))%>class=g<%%> align='center' width=15%><%=cont.get("IP")%></td>
				</tr>
					<%	}
					}else{%>
				<tr> 
					<td align='center' colspan="7">해당 데이타가 없습니다.</td>
				</tr>
					<%}%>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
