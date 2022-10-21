<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
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
function SearchRentCond()
{
	var theForm = document.RentCondSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 계약관리 > <span class=style5>계약만료현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	      
	<form action="./rent_end_cond_sc.jsp" name="RentCondSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
    <tr>
        <td>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
            		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            			<input type="radio" name="dt" value="1"> 당월
            			<input type="radio" name="dt" value="2" checked> 당월+경과
            			<input type="radio" name="dt" value="4"> 당월+익월+경과
            			<input type="radio" name="dt" value="5"> 당월+익월+익익월+경과
            			<input type="radio" name="dt" value="3"> 기간+경과
            			&nbsp;&nbsp;
            		    <input type="text" name="ref_dt1" size="10" value="" class=text> ~ <input type="text" name="ref_dt2" size="10" value="" class=text>
            		    &nbsp;&nbsp;<img src=/acar/images/center/arrow_ddj.gif align=absmiddle>&nbsp;
		                <select name="gubun3" >
		                  <option value=""  <%if(gubun3.equals(""))%>selected<%%>>전체</option>
		                  <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>최초영업자</option>
		                  <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>영업담당자</option>
		                  <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>관리담당자</option>
						  <option value="4" <%if(gubun3.equals("4"))%>selected<%%>>진행담당자</option>
		                </select>&nbsp;
		                <input type="text" class="text" name="gubun4" size="15" value="<%= gubun4 %>" align="absbottom">
            		    &nbsp;&nbsp;
            		    <a href="javascript:SearchRentCond()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
				    </td>
				</tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>