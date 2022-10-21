<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name=form1>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class="line">
                        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr> 
                                <td width='5%' class='title' rowspan="2">연번</td>
                                <td width='25%' class='title' rowspan="2">상호</td>
                                <td class='title' width="10%" rowspan="2" >계약자</td>
                                <td width='12%' class='title' rowspan="2">최초거래개시일</td>
                                <td width='10%' class='title' rowspan="2">계약진행건수</td>
                                <td colspan="4" class='title'>평가</td>
                            </tr>
                            <tr> 
                                <td width='9%' class='title'>결재</td>
                                <td width='9%' class='title'>성장성</td>
                                <td width='10%' class='title'>거래확장가능성</td>
                                <td width='10%' class='title'>종합평가</td>
                            </tr>
                        </table>
                    </td>
                    <td width=16>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(t_wd.equals("")){%>
    <tr> 
        <td>* 상호명으로 검색하십시오.</td>
    </tr>    
    <%}else{%>
    <tr> 
        <td><iframe src="./cus_app_sc_in.jsp?auth_rw=<%= auth_rw %>&t_wd=<%= t_wd %>&sort_gubun=<%= sort_gubun %>&sort=<%= sort %>" name="contList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <%}%>
</table>
</form>  
</body>
</html>
