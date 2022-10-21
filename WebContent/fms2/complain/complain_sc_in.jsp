<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.complain.*"%>
<jsp:useBean id="bean" class="acar.complain.OpinionBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	int count = 0;
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-125;//현황 라인수만큼 제한 아이프레임 사이즈
	
	ComplainDatabase oad = ComplainDatabase.getInstance();
	
	OpinionBean a_r [] = oad.getComplain2( gubun,  gubun_nm,  user_id );
	
%>


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">

	function ComplainDisp(seq){
		var SUBWIN="./complain_c.jsp?seq=" + seq;	
		window.open(SUBWIN, "ComplainDisp", "left=10, top=10, width=650, height=750, scrollbars=yes");
	}
	
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
		<td class=line2></td>
	</tr>
	<tr> 
        <td class=line>
	        <table border=0 cellspacing=1 width=100%>
                <tr> 
                  <td class='title' width='5%'>번호</td>
                  <td class='title' width='51%'>제목</td>
                  <td class='title' width='7%'>작성자</td>
                  <td class='title' width='15%'>작성시간</td> 
                  <td class='title' width='7%'>답변자</td>
                  <td class='title' width='15%'>답변시간</td>
                </tr>
	  		</table>
	  	</td>
	</tr>
    <tr>
        <td class=line2>
            <table border=0 cellspacing=1 width=100%>
		<% 	
			if(a_r.length > 0){
		
			    for(int i=0; i<a_r.length; i++){
		    	    bean = a_r[i];
		%>
            	<tr>
            		<td width='5%' align="center"><%=i+1%></td>	
            		<td width="51%" align="left"><a href="javascript:ComplainDisp('<%=bean.getSeq()%>')" onMouseOver="window.status=''; return true"><%=bean.getTitle()%></a></td>
            		<td width='7%' align="center"><%=bean.getName()%></td>
            		<td width='15%' align="center"><%=bean.getReg_dt()%></td>
            		<td width='7%' align="center"><%=bean.getAns_nm()%></td>
            		<td width='15%' align="center"><%=bean.getAns_dt()%></td>
            	</tr>
				
			<% } %>
		<% } %>
			</table>
        </td>
    </tr>
</table>
</body>
</html>
<style>
	a:link { font-family: 굴림, Gulim, AppleGothic, Seoul, Arial; text-decoration:underline; font-size:9pt; color:#666666; padding-left: 10px;}
	a:visited { font-family: 굴림, Gulim, AppleGothic, Seoul, Arial; text-decoration:underline; font-size:9pt; color:#666666; padding-left: 10px;}
	a:hover { font-family: 굴림, Gulim, AppleGothic, Seoul, Arial; text-decoration:underline; font-size:9pt; color:#666666; padding-left: 10px;}
</style>