<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt =5; //검색 라인수
	int height = (cnt*sh_line_height);
%>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");
	
	String 	s_kd 	= request.getParameter("s_kd")==null?	"":request.getParameter("s_kd");
	String 	t_wd 	= request.getParameter("t_wd")==null?	"":request.getParameter("t_wd");
	String 	gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");
	String 	gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");
	String  gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");
	String 	st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String 	end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	if(s_kd.equals("") && t_wd.equals("") && gubun1.equals("") && gubun2.equals("") && gubun3.equals("") && st_dt.equals("") && end_dt.equals("")){
		s_kd 	= "1";//검색조건-상호		
		gubun1 	= "1";
		gubun2 	= "4";
	}
	
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&s_kd="+s_kd+"&t_wd="+t_wd+
					"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&sh_height="+height+"";
				   	
				   	
%>

<HTML>
<HEAD>
<title>FMS</title>
<script language='javascript'>
</script>
</HEAD>
<frameset rows="<%=height%>, *" border=1 name=ex>
  <frame src="./alink_deli_rece_sh.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <FRAME SRC="./alink_deli_rece_sc.jsp<%=valus%>" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>
</frameset>
</HTML>
