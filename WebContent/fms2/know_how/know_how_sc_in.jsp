<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.know_how.*" %>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	Know_how_Database kh_db = Know_how_Database.getInstance();
	
	Vector vt = kh_db.Know_how_AllList(gubun,  gubun_nm,  gubun1, acar_de);
	int vt_size = vt.size();
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
//	function Know_how_Disp(know_how_id, user_id){
//		var SUBWIN="know_how_c.jsp?know_how_id="+know_how_id+"&user_id="+user_id;	
//		window.open(SUBWIN, "Know_how_Disp", "left=100, top=100, width=650, height=700, scrollbars=yes");
//	}
	

	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<tr> 
					<td class='title' width='10%'>연번</td>
					<td class='title' width='10%'>카테고리</td>
					<td class='title' width='50%'>제목</td>
					<td class='title' width='10%'>등록자</td>
					<td class='title' width='10%'>등록일</td>
					<td class='title' width='10%'>댓글</td>		  
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=line2>
			<table border=0 cellspacing=1 width=100%>
<% if(vt.size()>0){
	for(int i=0; i< vt.size(); i++){
	Hashtable ht = (Hashtable)vt.elementAt(i);
	
%>            	
				<tr>
					<td width='10%' align="center" ><%=i+1%></td>
					<td width='10%' align="center" ><%if(ht.get("KNOW_HOW_ST").equals("1")){%>지식Q&A<%}else{%>오픈지식<%}%></td>
					<td width='50%'><table width=100% border=0 cellspacing=0 cellpadding=5><tr><td><a href="javascript:parent.Know_how_Disp('<%=ht.get("KNOW_HOW_ID")%>','<%=ht.get("USER_ID")%>')" onMouseOver="window.status=''; return true" ><%=ht.get("TITLE")%></td></tr></table></td>
					<td width='10%' align="center" ><%=ht.get("USER_NM")%></td>
					<td width='10%' align="center" ><%= AddUtil.ChangeDate2((String)ht.get("REG_DT")) %></td>
					<td width='10%' align="center" ><%=ht.get("REPLY_CNT")%></td>
				</tr>
<%}
}else{%>
				<tr>
					<td colspan='8' align='center'>등록된 데이터가 없습니다</td>
				</tr>
<%}%>
			</table>
		</td>
	</tr>
</table>
</body>
</html>