<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String m_st = request.getParameter("m_st")==null?"01":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//마이메뉴 리스트
	Vector menus1 = nm_db.getMyMenuList(user_id);
	int menu_size1 = menus1.size();
%>

<html>
<head>
<title>마이메뉴 순위 변경</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../../include/table.css">
<script language='javascript'>
<!--
	//수정
	function save(){
		var fm = document.form1;
		fm.target = 'i_no';
		fm.action = 'my_menu_sort_a.jsp';		
		fm.submit();
	}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <form name="form1" method="post" action="">
    <input type='hidden' name="cmd" value="<%=cmd%>">
    <input type='hidden' name="user_id" value="<%=user_id%>">
    <input type='hidden' name="size" value="<%=menu_size1%>">
    <tr> 
      <td class=line> 
        <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td class=title width="250" rowspan="2">메뉴명</td>
            <td class=title rowspan="2">순위</td>
          </tr>
          <tr> </tr>
          <%for (int i = 0 ; i < menu_size1 ; i++){
				Hashtable menu1 = (Hashtable)menus1.elementAt(i);%>
          <tr> 
            <td align="center">&nbsp;<%=menu1.get("M_NM")%> 
              <input type='hidden' name="seq" value="<%=menu1.get("SEQ")%>">
            </td>
            <td align="center"> 
              <input type='text' name="sort" value="<%=menu1.get("SORT")%>" size="2" class=num>
            </td>
          </tr>
          <%}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td align="right">&nbsp;</td>
    </tr>
    <tr>
      <td align="right"><a href="javascript:save()"><img src="../../../images/bbs/but_modi.gif" width="50" height="18" border="0"></a>&nbsp;
	  <a href="javascript:self.close()"><img src="../../../images/bbs/but_close.gif" width="50" height="18" border="0"></a></td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
