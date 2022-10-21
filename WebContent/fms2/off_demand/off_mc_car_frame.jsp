<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height;
%>
<!DOCTYPE html>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="<%=height%>,*,1" border=1 cols="*"> 
  <frame name="c_body" src="off_mc_car_sh.jsp?sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <FRAME SRC="/acar/menu/about_blank.jsp" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>
</frameset>
<noframes> 
</noframes>
</HTML>