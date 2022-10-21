<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.client.*, acar.util.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}

	function init(){		
		setupEvents();
	}	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	Vector clients = l_db.getClientList(s_kd, t_wd);
	int client_size = clients.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='420' id='td_title' style='position:relative;'>			
			<table border="0" cellspacing="1" cellpadding="0" width='440'>
				<tr>					
					<td width='140' class='title'>고객구분</td>
					<td width='200' class='title'>상호</td>
					<td width='100' class='title'>고객명</td>
				</tr>
			</table>
		</td>
		<td class='line' width='700'>			
			<table border="0" cellspacing="1" cellpadding="0" width='730'>
				<tr>
					<td width='90' class='title'>전화번호</td>
					<td width='90' class='title'>휴대폰</td>
					<td width='90' class='title'>FAX</td>
					
				<td width='160' class='title'>HomePage</td>
					<td width='300' class='title'>주소</td>
				</tr>
			</table>
		</td>
	</tr>
<%	if(client_size > 0){%>
	<tr>
		<td class='line' width='420' id='td_con' style='position:relative;'>			
			<table border="0" cellspacing="1" cellpadding="0" width='440'>
			<%for(int i = 0 ; i < client_size ; i++){
				Hashtable client = (Hashtable)clients.elementAt(i);%>
				<tr>					
					<td width='140' align="center"><%=client.get("CLIENT_ST_NM")%></td>
					<%if(String.valueOf(client.get("CLIENT_ST")).equals("1")){%>					
			        <td width='200' align="center"><a href="javascript:parent.view_client('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(client.get("FIRM_NM")), 18)%></a></td>
					<%}else{%>					
					<td width='200' align="center"><a href="javascript:parent.view_client('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(client.get("FIRM_NM")), 18)%></a></td>
					<%} %>					
					<td width='100' align="center"><span title='<%=client.get("CLIENT_NM")%>'><%=Util.subData(String.valueOf(client.get("CLIENT_NM")), 6)%></span></td>
				</tr>
			<%} %>
			</table>
		</td>
		<td class='line' width='700''>			
			<table border="0" cellspacing="1" cellpadding="0" width='730''>
			<%for(int i = 0 ; i < client_size ; i++){
				Hashtable client = (Hashtable)clients.elementAt(i);%>
				<tr>					
					<td width='90' align="center"><%=client.get("O_TEL")%></td>					
					<td width='90' align="center"><%=client.get("M_TEL")%></td>					
					<td width='90' align="center"><%=client.get("FAX")%></td>					
					<td width='160'>&nbsp;<span title='<%=client.get("HOMEPAGE")%>'><a href='<%=client.get("HOMEPAGE")%>' target='about:blank'><%=Util.subData(String.valueOf(client.get("HOMEPAGE")), 20)%></a></span></td>
					<td width='300'>&nbsp;<span title='<%=client.get("O_ADDR")%>'><%=Util.subData(String.valueOf(client.get("O_ADDR")), 25)%></span></td>
				</tr>
			<%} %>
			</table>
		</td>
<%	}else{%>
	<tr>
		<td class='line' width='420' id='td_con' style='position:relative;'>			
			<table border="0" cellspacing="1" cellpadding="0" width='440'>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='700''>			
			<table border="0" cellspacing="1" cellpadding="0" width='730''>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	} %>
</table>
</body>
</html>
