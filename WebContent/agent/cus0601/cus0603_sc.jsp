<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>
<%
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(from_page.equals("/agent/consignment/cons_i_c.jsp")){
		height = 480;
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function view_detail(off_id, off_nm){
	<%if(from_page.equals("/agent/tint/tint_reg_step1.jsp")){%>
		parent.opener.form1.off_id.value = off_id;
		parent.opener.form1.off_nm.value = off_nm;
		parent.self.close();
	<%}else{%>
		var url = "?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>";
		parent.location.href = "cus0603_d_frame.jsp"+url+"&off_id="+off_id;
	<%}%>
}
	

//-->
</script>
</head>

<body>
  <table width="100%" border="0" cellspacing="1" cellpadding="0">
<form name="form1" action="" method="post">
    <tr> 
      <td><iframe src="cus0603_sc_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>&from_page=<%=from_page%>" name="serv_offList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
</form>

<form name="form2" action="" method="post">
<input type="hidden" name="s_kd" value="<%= s_kd %>">
<input type="hidden" name="t_wd" value="<%= t_wd %>">
<input type="hidden" name="sort_gubun" value="<%= sort_gubun %>">
<input type="hidden" name="sort" value="<%= sort %>">
<input type="hidden" name="from_page" value="<%= from_page %>">
<input type="hidden" name="off_id" value="">
</form>
  </table>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</html>
