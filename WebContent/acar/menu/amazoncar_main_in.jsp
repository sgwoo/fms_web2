<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	a_bean = oad.getAncLastBean();
%>
<html>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type="text/css">
a:link { text-decoration: none;}
</style>
<script language='javascript'>
<!--
-->
</script>
</HEAD>
<BODY topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
<center>
<table border=0 cellspacing=0 cellpadding=0 width=500>
<%	AncBean a_r [] = oad.getAncAll(acar_id);
    for(int i=0; i<a_r.length; i++){
        a_bean = a_r[i];
		String r_ch = a_bean.getRead_chk();
		String cont = AddUtil.replace(a_bean.getContent(),"\\","&#92;&#92;");
		cont = AddUtil.replace(cont,"\"","&#34;");
		cont = Util.htmlR(cont);
%>
   	<tr>
    	<td>&nbsp;&nbsp;<a href="javascript:parent.AncDisp('<%=a_bean.getBbs_id()%>','<%=a_bean.getTitle()%>','<%=cont%>')"><%if(a_bean.getRead_yn().equals("Y")){%><b><%}%><%if(a_bean.getRead_yn().equals("Y")){%><img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%><%if(r_ch.equals("1")){%><font color="#666666"><%=a_bean.getTitle()%> ( <%=a_bean.getUser_nm()%> )<%if(!a_bean.getComment_cnt().equals("")){%>-댓글<%=a_bean.getComment_cnt()%><%}%></font><%}else{%><%=a_bean.getTitle()%> ( <%=a_bean.getUser_nm()%> )<%if(!a_bean.getComment_cnt().equals("")){%>-댓글<%=a_bean.getComment_cnt()%><%}%><%}%><%if(a_bean.getRead_yn().equals("Y")){%></b><%}%><%if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>&nbsp;<font color="Fuchsia" size="1"><b>New</b></font><%}%></a></td>
   	</tr>
<%}%>
</table>
</center>
</body>
</html>


