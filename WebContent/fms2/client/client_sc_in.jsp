<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*"%>
<%@ page import="acar.util.*,acar.common.*"%>
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
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	String car_st		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector clients = new Vector();
	int client_size = 0;
	if(!s_kd.equals("13") && !s_kd.equals("8") && !s_kd.equals("9") && t_wd.equals("")){
		
	}else{
		clients = al_db.getClientList(s_kd, t_wd, asc);
		client_size = clients.size();
	}
%>

<table border="0" cellspacing="0" cellpadding="0" width='1920'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='620' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
					<td width='40' class='title'>연번</td>
					<td width='50' class='title'>메모</td>					
					<td width='70' class='title'>장기대여</td>
					<td width='70' class='title'>월렌트</td>
					<td width='70' class='title'>매각</td>
					<td width='70' class='title'>연체금액</td>
					<td width='80' class='title'>고객구분</td>
					<td width='170' class='title'>상호</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1300'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width='80' class='title'>대표자명</td>
					<td width='120' class='title'>사업자번호</td>
					<td width='150' class='title'>법인번호/생년월일</td>										
					<td width='80' class='title'>담당자명</td>
					<td width='120' class='title'>전화번호</td>
					<td width='120' class='title'>휴대폰</td>										
					<td width='230' class='title'>주소</td>
					<td width='200' class='title'>HomePage</td>					
					<td width='100' class='title'>최초계약일</td>
					<td width='100' class='title'>최근담당자</td>

				</tr>
			</table>
		</td>
	</tr>
<%
	if(client_size > 0)
	{
%>
	<tr>
		<td class='line' width='620' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < client_size ; i++)
		{
			Hashtable client = (Hashtable)clients.elementAt(i);

%>
				<tr>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='40' align='center'><%=i+1%></td>	
          <td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='50' align='center'><a href="javascript:parent.cl_mm('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_memo.gif align=absmiddle border=0></a></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='70' align='center'><%=client.get("L_USE_CNT")%>/<%=client.get("LT_CNT")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='70' align='center'><%=client.get("S_USE_CNT")%>/<%=client.get("ST_CNT")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='70' align='center'><%=client.get("OT_CNT")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='70' align='center'><a href="javascript:parent.cl_dlyamt('<%=client.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='80' align='center'><%=client.get("CLIENT_ST_NM")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='170'>&nbsp;<span title='<%=client.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=client.get("CLIENT_ST")%>', '<%=client.get("CLIENT_ID")%>', '<%=from_page%>', '<%=client.get("FIRM_NM")%>', '<%=client.get("CLIENT_NM")%>', '<%=client.get("O_ZIP")%>', '<%=client.get("O_ADDR")%>', '<%=client.get("ENP_NO")%>', '<%=client.get("SSN")%>', '<%=client.get("LIC_NO")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.substringbdot(String.valueOf(client.get("FIRM_NM")), 20)%></a></span></td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1300'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
		for(int i = 0 ; i < client_size ; i++)
		{
			Hashtable client = (Hashtable)clients.elementAt(i);

%>			
				<tr>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='80' align=center><span title='<%=client.get("CLIENT_NM")%>'><%=Util.subData(String.valueOf(client.get("CLIENT_NM")), 4)%></span></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='120' align='center'><%=AddUtil.ChangeEnp(String.valueOf(client.get("ENP_NO")))%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='150' align='center'><%=AddUtil.ChangeEnpH(String.valueOf(client.get("SSN")))%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='80' align=center><span title='<%=client.get("CON_AGNT_NM")%>'><%=Util.subData(String.valueOf(client.get("CON_AGNT_NM")), 4)%></span></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='120' align='center'><%=client.get("O_TEL")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='120' align='center'><%=client.get("M_TEL")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='230'>&nbsp;<span title='<%=client.get("O_ADDR")%>'><%=Util.subData(String.valueOf(client.get("O_ADDR")), 20)%></span></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='200'>&nbsp;<span title='<%=client.get("HOMEPAGE")%>'><a href='<%=client.get("HOMEPAGE")%>' target='about:blank'><%=Util.subData(String.valueOf(client.get("HOMEPAGE")), 16)%></a></span></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='100' align='center'><%=client.get("F_RENT_DT")%></td>
					<td <%if(String.valueOf(client.get("USE_YN")).equals("N")){%>class=is<%}%> width='100' align='center'><%=c_db.getNameById(String.valueOf(client.get("BUS_ID2")), "USER")%></td>					
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
		<td class='line' width='620' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1300'>
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
