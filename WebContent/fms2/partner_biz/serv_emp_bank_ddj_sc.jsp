<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");		
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String mail_yn = request.getParameter("mail_yn")==null?"":request.getParameter("mail_yn");
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "35", "01", "");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
function view_detail(off_id, cpt_cd){
	var url = "?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&br_id=<%=br_id%>";
	parent.location.href = "servemp_d_frame.jsp"+url+"&off_id="+off_id+"&cpt_cd="+cpt_cd;
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
  <table width="100%" border="0" cellspacing="1" cellpadding="0">
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="s_kd" value="<%= s_kd %>">
<input type="hidden" name="t_wd" value="<%= t_wd %>">
<input type="hidden" name="sort_gubun" value="<%= sort_gubun %>">
<input type="hidden" name="sort" value="<%= sort %>">

	
    <tr> 
      <td><iframe src="serv_emp_bank_ddj_sc_in.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&sort=<%=sort%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&br_id=<%=br_id%>&mail_yn=<%=mail_yn%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
</form>
  </table>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</html>
