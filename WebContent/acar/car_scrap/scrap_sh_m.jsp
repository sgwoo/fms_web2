<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"파주":request.getParameter("gubun");	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
  CommonDataBase c_db = CommonDataBase.getInstance();

  //차량등록지역
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
function search(){
	var fm = document.form1;
	fm.target = "c_foot";
	fm.action="scrap_sc_m.jsp";
	fm.submit();
}

function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}

function oldCar_scrap(){
	parent.location.href  = "scrap_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&gubun=<%=gubun%>";
}

function excel_list(){
	var fm = document.form1;
	fm.target = "_blank";
	fm.action="scrap_sc_in_m_excel.jsp";
	fm.submit();
}

</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="scrap_sc_m.jsp" name="form1" method="POST">
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="from_page" value="<%=from_page%>">
    <input type='hidden' name='sh_height' value='<%=sh_height%>'> 	
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>대폐차관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>		
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td width=8%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name='gubun'>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm()%>' <%if(gubun.equals(code.getNm())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select> </td>
                    <td width=8%> <select name='s_kd'>
                        <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>차량번호 
                        </option>
                      </select> </td>
                    <td width=11%> <input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
                      &nbsp; </td>
                    <td><a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
                    <td align="right"><!--<% if(auth_rw.equals("6")){ %><a href="javascript:oldCar_scrap();">기존대폐차조회</a><% } %>-->
                    	<a href='javascript:excel_list()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
                    	&nbsp;&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
        </td>
    </tr>
  </form>
</table>
</body>
</html>