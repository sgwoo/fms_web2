<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String brch 		= request.getParameter("brch")		==null?"":request.getParameter("brch");
	String shed_st 	= request.getParameter("shed_st")	==null?"":request.getParameter("shed_st");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id 	= login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))		br_id 		= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw 	= rs_db.getAuthRw(user_id, "11", "03", "06");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--

	function view_shed(shed_id, shed_st)
	{
		if(shed_st == '1'){
			parent.location = '/acar/car_shed/cshed_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>&shed_st='+shed_st+'&shed_id='+shed_id;
		}else{
			parent.location = '/acar/car_shed/cshed_m_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>&shed_st='+shed_st+'&shed_id='+shed_id;
		}
	}
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>

</head>
<body topmargin=0>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brch' value='<%=brch%>'>
<input type='hidden' name='shed_st' value='<%=shed_st%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td align='left'>  
        <img src=../images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>자가</b></td>
    </tr>    
    <tr>
    	<td colspan=2>
			<iframe src="/acar/car_shed/cshed_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>&gubun1=<%=gubun1%>&shed_st=<%=shed_st%>" name="inner" width="100%" height="<%=height/2-20-150%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
    	</td>
    </tr>
    <tr> 
        <td>&nbsp;</tr>       
    <tr> 
        <td align='left'>  
        <img src=../images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>임대</b></td>
    </tr>       
    <tr>
    	<td colspan=2>
			<iframe src="/acar/car_shed/cshed_sc_in2.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>&gubun1=<%=gubun1%>&shed_st=<%=shed_st%>" name="inner" width="100%" height="<%=height/2-20+150%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
    	</td>
    </tr>    
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>

</body>
</html>