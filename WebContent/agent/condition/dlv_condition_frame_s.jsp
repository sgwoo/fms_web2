<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>
<%@ include file="/agent/access_log.jsp" %> 

<%
	int cnt = 3; //검색 라인수
	int height = cnt*sh_line_height+10;
%>

<HTML>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt 		= request.getParameter("dt")==null?"2":request.getParameter("dt");
			
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&dt="+dt+
				   	"&sh_height="+height+"";
%>

<frameset rows="<%=height%>, *" border=1>
        <frame src="dlv_condition_sh.jsp<%=valus%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="dlv_condition_sc.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
