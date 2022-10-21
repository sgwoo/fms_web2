<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	//String t_wd = request.getParameter("t_wd")==null?"":Util.toKSC(request.getParameter("t_wd"));
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	Vector clients = new Vector();
	int client_size = 0;
	if(t_wd.equals("")){
		
	}else{
		clients = al_db.getClientList(s_kd, t_wd, asc);
		client_size = clients.size();
	}
%>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='52%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
					<td width='50' class='title'>연번</td>
					<td width='160' class='title'>상호</td>
					<td width='90' class='title'>담당자명</td>
					<td width='110' class='title'>전화번호</td>
					<td width='110' class='title'>휴대폰</td>
				</tr>
			</table>
		</td>
		<td class='line' width='48%'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width='40%' class='title'>HomePage</td>
					<td width='40%' class='title'>주소</td>
					<td width='20%' class='title'>메모</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	if(client_size > 0)
	{
%>
	<tr>
		<td class='line' width='52%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < client_size ; i++)
		{
			Hashtable client = (Hashtable)clients.elementAt(i);

%>
			    <tr>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='50' align='center'><%=i+1%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='160'>&nbsp;<span title='<%=client.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(client.get("FIRM_NM")), 11)%></a></span></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='90'>&nbsp;<%=client.get("CON_AGNT_NM")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='110'>&nbsp;<%=client.get("O_TEL")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='110'>&nbsp;<%=client.get("M_TEL")%></td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='48%'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
		for(int i = 0 ; i < client_size ; i++)
		{
			Hashtable client = (Hashtable)clients.elementAt(i);

%>			
				<tr>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='40%'>&nbsp;<span title='<%=client.get("HOMEPAGE")%>'><a href='<%=client.get("HOMEPAGE")%>' target='about:blank'><%=Util.subData(String.valueOf(client.get("HOMEPAGE")), 20)%></a></title></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='40%%'>&nbsp;<span title='<%=client.get("O_ADDR")%>'><%=Util.subData(String.valueOf(client.get("O_ADDR")), 17)%></title></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='20%' align=center>&nbsp;<a href="javascript:parent.cl_mm('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_memo.gif align=absmiddle border=0></a></td>
				</tr>
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='52%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='48%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
</body>
</html>
