<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd = request.getParameter("s_dd")==null?"":request.getParameter("s_dd");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	//검색하기
	function search(){
		var fm = document.form1;
		fm.target="c_foot";
		fm.action="board_sc.jsp";		
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//작성하기
	function Reg(){
		var fm = document.form1;
		fm.cmd.value = 'i';
		fm.target="d_content";
		fm.action="board_i.jsp";		
		fm.submit();
	}
		
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='board_sc.jsp' target='c_foot'>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="idx" value="<%=idx%>">
<input type='hidden' name="gubun" value="<%=gubun%>">
<input type='hidden' name="cmd" value="">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객FMS > <span class=style5><%if(gubun.equals("1")){%>
        				공지사항 
        			 <%}else if(gubun.equals("2")){%>
        				건의함 
        			<%}%></span></span>
        			</td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif align=absmiddle> 
         <font color="#666666">작성일(년/월), 제목/내용, 제목, 내용으로 검색을 하실 수 있습니다.</font></td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/icon_arrow.gif  align=absmiddle>
         <font color="#0066FF">제목을</font><font color="#666666"> 클릭하시면 상세내역을 보실 
        수 있습니다.</font></td>
    </tr>
    <tr>
        <td class=h colspan=2></td>
    </tr>
    <tr> 
        <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jsi.gif align=absmiddle>&nbsp; 
            <select name='s_yy'>
              <option value="">전체</option>
              <%for(int i=2004; i<=AddUtil.getDate2(1); i++){%>
              <option value="<%=i%>" <%if(AddUtil.parseInt(s_yy) == i){%>selected<%}%>><%=i%>년</option>
              <%}%>
            </select>
            <select name='s_mm'>
              <option value="">전체</option>
              <%for(int i=1; i<=12; i++){%>
              <option value="<%=i%>" <%if(AddUtil.parseInt(s_mm) == i){%>selected<%}%>><%=i%>월</option>
              <%}%>
            </select>
            <select name='s_kd'>
              <option value="1" <%if(s_kd.equals("1")){%>selected<%}%>>제목/내용</option>
              <option value="2" <%if(s_kd.equals("2")){%>selected<%}%>>제목</option>
              <option value="3" <%if(s_kd.equals("3")){%>selected<%}%>>내용</option>
            </select> 
            <input type="text" name="t_wd" size="15" value="<%=t_wd%>" onKeydown="EnterDown()">
            <a href='javascript:search();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
        <td align='right' width="100">
	    <%if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) && gubun.equals("1")){%>
	    <a href='javascript:Reg();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%></td>
    </tr>
</table>
</form>  
</body>
</html>
