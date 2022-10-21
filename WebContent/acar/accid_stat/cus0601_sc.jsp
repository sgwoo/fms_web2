<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");		
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function view_detail(off_id){
	var url = "?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>";
	parent.location.href = "cus0601_d_frame.jsp"+url+"&off_id="+off_id;
}
	
function ServOffDel(off_id){
	if(!confirm('해당 정비업체와 연결된 정비건이 없읍니다.\n선택한 정비업체를 삭제하시겠습니까?')){ return; }
	var fm = document.form2;
	fm.off_id.value = off_id;
	fm.action = "./cus0601_d_cont_del.jsp";	
	fm.target = "i_no";
	fm.submit();
}
//-->
</script>
</head>

<body>
  <table width="800" border="0" cellspacing="1" cellpadding="0">
<form name="form1" action="" method="post">
    <tr> 
      <td><iframe src="cus0601_sc_in.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>" name="serv_offList" width="800" height="500" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
</form>

<form name="form2" action="" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="s_kd" value="<%= s_kd %>">
<input type="hidden" name="t_wd" value="<%= t_wd %>">
<input type="hidden" name="sort_gubun" value="<%= sort_gubun %>">
<input type="hidden" name="sort" value="<%= sort %>">
<input type="hidden" name="off_id" value="">
</form>
  </table>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</html>
