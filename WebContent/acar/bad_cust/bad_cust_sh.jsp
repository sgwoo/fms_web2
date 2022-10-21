<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function Search()
{
	var theForm = document.form1;
	theForm.target = "c_foot";
	theForm.submit();
}

//-->
</script>
</head>
<body>
<form name="form1" action="./bad_cust_sc.jsp" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>유의고객관리</span></span></td>
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
            <table border=0 cellspacing=1 cellpadding=0 border=0>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;</td>
                    <td>
                      <select name="s_kd">
                    	<option value="" <%if(s_kd.equals(""))%>selected<%%>>전체</option>
                    	<option value="1" <%if(s_kd.equals("1"))%>selected<%%>>성명</option>
                    	<option value="4" <%if(s_kd.equals("4"))%>selected<%%>>생년월일</option>
                    	<option value="2" <%if(s_kd.equals("2"))%>selected<%%>>주소</option>
                    	<option value="5" <%if(s_kd.equals("5"))%>selected<%%>>운전면허번호</option>
                    	<option value="6" <%if(s_kd.equals("6"))%>selected<%%>>휴대폰번호</option>
                    	<option value="7" <%if(s_kd.equals("7"))%>selected<%%>>이메일주소</option>
                    	<option value="8" <%if(s_kd.equals("8"))%>selected<%%>>FAX</option>
                    	<option value="3" <%if(s_kd.equals("3"))%>selected<%%>>피해업체</option>
        	       	  </select>&nbsp;
                    </td>
                    <td><input type="text" name="t_wd" size="15" value="<%=t_wd%>" style='IME-MODE: active'></td>
    			    <td>&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>
                </tr>
            </table>            
        </td>
    </tr>
</table>
</form>
</body>
</html>