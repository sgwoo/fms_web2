<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	BranchBean br_r [] = umd.getBranchAll();
	
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchBrCond()
{
	var theForm = document.BrCondSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin=15>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>현황 및 통계 > 영업관리 > <span class=style5>계약해지현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./cls_cond_sc.jsp" name="BrCondSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
            	<tr>            		
            		<td width=17%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="dt" value="4"> 전월
            			<input type="radio" name="dt" value="2" checked> 당월
            			<input type="radio" name="dt" value="3"> 기간
            		</td>
            		<td width=16%><input type="text" name="ref_dt1" size="10" value="" class=text> ~ <input type="text" name="ref_dt2" size="10" value="" class=text></td>
            		
            		  <td width=10%><img src=../images/center/arrow_g.gif align=absmiddle>&nbsp;
                        <select name="gubun2">
                            <option value="" <%if(gubun2.equals(""))%>selected<%%>>전체</option>
                            <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>렌트</option>
                            <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>리스</option>
                        </select>
                         <select name="gubun3">
                            <option value="" <%if(gubun3.equals(""))%>selected<%%>>전체</option>
                            <option value="9" <%if(gubun3.equals("9"))%>selected<%%>>폐차</option>
                        
                        </select>
                        
                        </td>
            		
			<td><a href="javascript:SearchBrCond()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
            	</tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>