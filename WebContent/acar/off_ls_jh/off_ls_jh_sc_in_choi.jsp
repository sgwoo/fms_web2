<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 			= request.getParameter("seq")==null?"01":request.getParameter("seq");
	String actn_cnt 	= request.getParameter("actn_cnt")==null?"0":request.getParameter("actn_cnt");
	String user_id		= ck_acar_id;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
		//권한
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "06", "05", "01");
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
function reAuction(){
	fm = document.form1;
	fm.action = "off_ls_jh_actn_mng_re.jsp";
	fm.submit();
}
function banAuction(){
	fm = document.form1;
	fm.action = "off_ls_jh_actn_mng_ban.jsp";
	fm.submit();
}
function cancelAuction(){
	fm = document.form1;
	fm.action = "off_ls_jh_actn_mng_cancel.jsp";
	fm.submit();
}
-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="actn_cnt" value="<%=actn_cnt%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>최종유찰</span></td>
  </tr>
  <tr> 
    <td>
     <%if( auth_rw.equals("4") || auth_rw.equals("6")){%>
      <a href="javascript:reAuction();"><img src=/acar/images/center/button_jcp.gif align=absmiddle border=0></a>&nbsp;&nbsp;
      <a href="javascript:banAuction();"><img src=/acar/images/center/button_bc.gif align=absmiddle border=0></a>&nbsp;&nbsp;
      <% } %>
	  <%if(nm_db.getWorkAuthUser("전산팀",user_id)){// || nm_db.getWorkAuthUser("출고관리자",user_id)%>
	  <a href="javascript:cancelAuction();"><img src=/acar/images/center/button_cancel_yc.gif align=absmiddle border=0></a>
	  <%}%>
	</td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>

</body>
</html>
