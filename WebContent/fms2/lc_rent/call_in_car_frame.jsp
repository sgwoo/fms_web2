<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = (cnt*sh_line_height)+20;
%>

<HTML>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "07");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	if(s_kd.equals("") && t_wd.equals("") && gubun1.equals("")){
		
		UserMngDatabase umd = UserMngDatabase.getInstance();
		user_bean 	= umd.getUsersBean(user_id);
		
		if(!user_bean.getLoan_st().equals("")){
			s_kd 	= "4";
			t_wd 	= user_bean.getUser_nm();
			gubun1 	= "1";//미결
		}else{
			s_kd 	= "1";
			t_wd 	= "";
			gubun1 	= "1";//미결
		}
	}
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+
				   	"&sh_height="+height+"";
%>
<frameset rows="<%=height%>, *" border=1 name=ex>
  <frame src="./call_in_car_sh.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame src="./call_in_car_sc.jsp<%=valus%>" name="c_foot" marginwidth=10 marginheight=0 scrolling='no' noresize>
</frameset>
</HTML>