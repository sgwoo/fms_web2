<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_bus.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String year = request.getParameter("year")==null?AddUtil.getDate(1):request.getParameter("year");
	String mon = request.getParameter("mon")==null?AddUtil.getDate(2):request.getParameter("mon");
					
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15 rightmargin=0>  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td align=right>    
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class="line">
                        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        				    <tr> 
            					<td width='7%' class='title'>연번</td>
            					<td width='12%' class='title'>계약번호</td>
            					<td width='12%' class='title'>상호</td>
            					<td width='10%' class='title'>차량번호</td>
            					<td width='11%' class='title'>차종</td>
            					<td width='10%' class='title'>대여개시일</td>
            					<td width='10%' class='title'>대여만료일</td>
            					<td width='10%' class='title'>대여구분</td>
            					<td width='9%' class='title'>영업담당</td>
            					<td width='9%' class='title'>관리담당</td>
        				    </tr>
                        </table>
                    </td>
                    <td width=16>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><iframe src="./cus_bue_sc_in.jsp?auth_rw=<%= auth_rw %>&year=<%= year %>&mon=<%= mon %>" name="contList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
