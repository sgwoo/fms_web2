<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 4; //검색 라인수
	int height = cnt*sh_line_height-25;
%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
 	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dest_gubun= request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");
	String send_dt 	= request.getParameter("send_dt")==null?"1":request.getParameter("send_dt");
	String s_bus 	= request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort 	= request.getParameter("sort")==null?"5":request.getParameter("sort");
	String sort_gubun= request.getParameter("sort_gubun")==null?"desc":request.getParameter("sort_gubun");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun="+gubun+"&gubun_nm="+gubun_nm+"&dest_gubun="+dest_gubun+"&send_dt="+send_dt+"&s_bus="+s_bus+
					"&sort="+sort+"&sort_gubun="+sort_gubun+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&s_kd="+s_kd+"&t_wd="+t_wd+
				   	"&sh_height="+height+"";
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="<%=height%>,*,0" border=0 cols="*"> 
  <frame name="c_body" src="v5_sms_cre_sh.jsp<%=valus%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="c_foot" src="v5_sms_cre_sc.jsp<%=valus%>" marginwidth=10 marginheight=5 scrolling="auto" noresize>
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<noframes> 
</noframes> 
</HTML>
