<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 4; //검색 라인수
	int height = (cnt*sh_line_height)+(cnt*1);
%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "20");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(s_kd.equals("") && t_wd.equals("") && gubun2.equals("") && gubun3.equals("") && st_dt.equals("") && end_dt.equals("") && sort.equals("")){
		gubun1 	= "1";
		gubun2 	= "2";
	}
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&mode="+mode+
				   	"&sh_height="+height+"";
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<frameset rows="<%=height%>, *" border=1 name=ex>
 	<FRAME SRC="./sale_cost_good_sh.jsp<%=valus%>" name="c_head" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>	
	<FRAME SRC="./sale_cost_good_sc.jsp<%=valus%>" name="c_body" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
</FRAMESET>
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
</HTML>
