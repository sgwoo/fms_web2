<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 6; //검색 라인수
	int height = (cnt*sh_line_height)+(cnt*1);
%>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "12");
	
	String s_kd 	= request.getParameter("s_kd")==null? "2":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc 		= request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	if(gubun5.equals("")) 	gubun5 = AddUtil.getDate(1);
	if(gubun6.equals("")){
	  if(AddUtil.getDate(2).equals("01")) gubun6 = "1";
	  if(AddUtil.getDate(2).equals("02")) gubun6 = "1";
	  if(AddUtil.getDate(2).equals("03")) gubun6 = "1";
	  if(AddUtil.getDate(2).equals("04")) gubun6 = "2";
	  if(AddUtil.getDate(2).equals("05")) gubun6 = "2";
	  if(AddUtil.getDate(2).equals("06")) gubun6 = "2";
	  if(AddUtil.getDate(2).equals("07")) gubun6 = "3";
	  if(AddUtil.getDate(2).equals("08")) gubun6 = "3";
	  if(AddUtil.getDate(2).equals("09")) gubun6 = "3";
	  if(AddUtil.getDate(2).equals("10")) gubun6 = "4";
	  if(AddUtil.getDate(2).equals("11")) gubun6 = "4";
	  if(AddUtil.getDate(2).equals("12")) gubun6 = "4";
	}
	if(gubun7.equals("")) gubun7 = AddUtil.getDate(2);
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&sort="+sort+"&asc="+asc+
				   	"&sh_height="+height+"";
%>

<HTML>
<HEAD>
<title>FMS</title>
<script language='javascript'>
</script>
</HEAD>
<frameset rows="<%=height%>, <%=AddUtil.parseInt(s_height)-height%>" border=1 name=ex>
  <frame src="./tax_m_sh.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame src="./tax_m_sc.jsp<%=valus%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
</frameset>
</HTML>
