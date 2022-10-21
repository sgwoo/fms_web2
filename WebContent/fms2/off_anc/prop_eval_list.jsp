<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String eval_dt = request.getParameter("eval_dt")==null?"":request.getParameter("eval_dt");
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
		
	Vector vt = p_db.getOffPropEvalList(eval_dt);
	int vt_size = vt.size();		
	
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//팝업창 닫기
function AncClose()
{
	self.close();
	
}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus()">
<form name="AncDispForm" method="post">
	
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="acar_id" value="<%=acar_id%>">	

<center>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5> 제안심사결과</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
		
	<tr>
		<td align=right><a href="javascript:AncClose()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align=absmiddle border=0></a>&nbsp;</td>
	</tr>
		
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>&nbsp;심사일:<%=AddUtil.ChangeDate2(eval_dt)%></span></td>
    </tr>
    	
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
    </tr>	
	
	<tr>
<%	if(vt_size > 0)	{%>
	
		<td>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
<% if ( String.valueOf(ht.get("OPEN_YN")).equals("Y")   ) { %><%=ht.get("USER_NM")%>
<% } else {  %>
	비공개 
<% } %>&nbsp;:&nbsp;
	<%=ht.get("TITLE")%>&nbsp;&nbsp;(<%=ht.get("REG_DT")%>)--&nbsp;
	<%=ht.get("USE_YN_NM")%>&nbsp;<br>
	&nbsp;==><%=ht.get("CONTENT")%>&nbsp;<br><br>	
	
<%		}} %>
  	  </td>	
	</tr>
	<tr>
	  <td>&nbsp;</td>
    </tr>
    
	<tr>
		<td class=line2 ></td>
	</tr>
</table>
</center>

</form>		
</body>
</html>