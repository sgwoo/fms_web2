<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수

	int height = cnt*sh_line_height+10;
%>

<HTML>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "07", "06", "10");
	
	String s_kd 	= request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun0 	= request.getParameter("gubun0")==null?Integer.toString(AddUtil.getDate2(1)):request.getParameter("gubun0");
	
	
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));
	
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
				
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String valus = 	"?st_mon="+st_mon+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun0="+gubun0+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun2="+gubun2+"&gubun3="+gubun3+"&asc="+asc+
				   	"&sh_height="+height+"";
%>
<frameset rows="<%=height%>, *" border=1> 
  <frame src="./card_tax_s_sh.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame src="./card_tax_s_sc.jsp<%=valus%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no'>
</frameset>
</HTML>