<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	int cnt = 5; //검색 라인수
	int height = (cnt*sh_line_height)+(cnt*1);
%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?AddUtil.getDate(1):request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	if(s_kd.equals("") && t_wd.equals("") && gubun1.equals("") && gubun2.equals("") && gubun3.equals("") && gubun4.equals("")){
		s_kd 	= "5";
		t_wd 	= session_user_nm;
		gubun2 	= "2";
	}
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_year="+s_year+"&s_mon="+s_mon+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
				   	"&sh_height="+height+"";
%>
<frameset rows="<%=height%>, *" border=1 name=ex>
        <frame src="/fms2/cooperation/cooperation_it_sh.jsp<%=valus%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/fms2/cooperation/cooperation_it_sc.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
