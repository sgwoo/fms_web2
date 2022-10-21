<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
 	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dest_gubun= request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");
	String send_dt 	= request.getParameter("send_dt")==null?"1":request.getParameter("send_dt");
	String s_bus 	= request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-95;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun="+gubun+"&gubun_nm="+gubun_nm+"&dest_gubun="+dest_gubun+"&send_dt="+send_dt+"&s_bus="+s_bus+
					"&sort="+sort+"&sort_gubun="+sort_gubun+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&s_kd="+s_kd+"&t_wd="+t_wd+
				   	"&sh_height="+height+"";
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td><iframe src="v5_sms_mng_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		</iframe>
	</td>
  </tr>
</table>
</body>
</html>