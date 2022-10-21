<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	//String t_wd = request.getParameter("t_wd")==null?"":Util.toKSC(request.getParameter("t_wd"));
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean = umd.getUsersBean(ck_acar_id);	
	
	Vector clients = new Vector();
	int client_size = 0;
	if(!s_kd.equals("8") && !s_kd.equals("9") && t_wd.equals("")){
		
	}else{
		clients = al_db.getClientList(s_kd, t_wd, asc, ck_acar_id, user_bean.getSa_code());
		client_size = clients.size();
	}
%>

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


<table border="0" cellspacing="0" cellpadding="0" width='1360'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='360' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
					<td width='40' class='title'>연번</td>
					<td width='70' class='title'>연체금액</td>
					<td width='80' class='title'>고객구분</td>
					<td width='170' class='title'>상호</td>

				</tr>
			</table>
		</td>
		<td class='line' width='1000'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width='80' class='title'>담당자명</td>
					<td width='100' class='title'>전화번호</td>
					<td width='100' class='title'>휴대폰</td>					
					<td width='90' class='title'>사업자번호</td>
					<td width='150' class='title'>생년월일/법인번호</td>					
					<td width='230' class='title'>주소</td>
					<td width='200' class='title'>HomePage</td>					
					<td width='50' class='title'>메모</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	if(client_size > 0)
	{
%>
	<tr>
		<td class='line' width='360' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < client_size ; i++)
		{
			Hashtable client = (Hashtable)clients.elementAt(i);

%>
				<tr>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='40' align='center'><%=i+1%></td>									
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='70' align='center'><a href="javascript:parent.cl_dlyamt('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='80' align='center'><%=client.get("CLIENT_ST_NM")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='170'>&nbsp;<span title='<%=client.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=client.get("CLIENT_ST")%>', '<%=client.get("CLIENT_ID")%>', '<%=from_page%>', '<%=client.get("FIRM_NM")%>', '<%=client.get("CLIENT_NM")%>', '<%=client.get("O_ZIP")%>', '<%=client.get("O_ADDR")%>', '<%=client.get("ENP_NO")%>', '<%=client.get("SSN")%>', '<%=client.get("LIC_NO")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.substringbdot(String.valueOf(client.get("FIRM_NM")), 20)%></a></span></td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1000'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
		for(int i = 0 ; i < client_size ; i++)
		{
			Hashtable client = (Hashtable)clients.elementAt(i);

%>			
				<tr>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='80' align=center><span title='<%=client.get("CON_AGNT_NM")%>'><%=Util.subData(String.valueOf(client.get("CON_AGNT_NM")), 4)%></span></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='100' align='center'><%=client.get("O_TEL")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='100' align='center'><%=client.get("M_TEL")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='90' align='center'><%=AddUtil.ChangeEnp(String.valueOf(client.get("ENP_NO")))%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='150' align='center'><%=AddUtil.ChangeEnp(String.valueOf(client.get("SSN")))%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='230'>&nbsp;<span title='<%=client.get("O_ADDR")%>'><%=Util.subData(String.valueOf(client.get("O_ADDR")), 20)%></span></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='200'>&nbsp;<span title='<%=client.get("HOMEPAGE")%>'><a href='<%=client.get("HOMEPAGE")%>' target='about:blank'><%=Util.subData(String.valueOf(client.get("HOMEPAGE")), 25)%></a></span></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='50' align='center'><a href="javascript:parent.cl_mm('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_memo.gif align=absmiddle border=0></a></td>
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
		<td class='line' width='360' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1000'>
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
