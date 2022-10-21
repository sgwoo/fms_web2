<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String height = request.getParameter("height")==null?"":request.getParameter("height");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	//하단페이지 보기
	function display_sc(st){
		var fm = document.form1;	
		<%-- var param = '<%=values%>'; --%>
		fm.action = 'park_' + st + '_sc.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15" >
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brid' value='<%=brid%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='off_id' value=''>
<input type='hidden' name='height' value='<%=height%>'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <!-- <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 예비차관리 > <span class=style5>주차장현황</span></span></td> -->
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>차량관리 > 보유차관리 > <span class=style5>주차장 세차현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
		<td class=h></td>
	</tr>	
	<tr>
		<td align="center">
			<input type="button" class="button" value="작업지시서" onclick="javascript:display_sc('wa');">&nbsp;
			<input type="button" class="button" value="일일작업현황" onclick="javascript:display_sc('wd');">&nbsp;
			<input type="button" class="button" value="세차현황" onclick="javascript:display_sc('w');">&nbsp;
			<input type="button" class="button" value="사업장현황" onclick="javascript:display_sc('wb');">		
			<input type="button" class="button" value="재리스/월렌트 출고예정현황" onclick="javascript:display_sc('est');">
		</td>
	</tr>
</table>
</form> 
</body>
</html>

