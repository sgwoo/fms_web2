<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 6; //검색 라인수
	int height = (cnt*sh_line_height)+(cnt*1)+40;
%>

<HTML>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "08", "03");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(s_kd.equals("") && t_wd.equals("") && gubun1.equals("")){
		
		MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		UserMngDatabase umd = UserMngDatabase.getInstance();
		user_bean 	= umd.getUsersBean(user_id);
		
		if(user_id.equals(nm_db.getWorkAuthUser("부산지점장")) || user_id.equals(nm_db.getWorkAuthUser("부산출납"))){
			s_kd = "5";
			t_wd = "";
			gubun1 = "부경자동차정비";
			gubun2 = "3";
		}
		if(user_id.equals(nm_db.getWorkAuthUser("대전지점장")) || user_id.equals(nm_db.getWorkAuthUser("대전출납"))){
			s_kd = "5";
			t_wd = "";
			gubun1 = "(주)현대카독크";
			gubun2 = "3";
		}
		if(nm_db.getWorkAuthUser("아마존카이외",user_id)){
			s_kd = "4";
			t_wd = "";
			gubun1 = user_bean.getUser_nm();
			gubun2 = "3";
		}
		if(user_id.equals(nm_db.getWorkAuthUser("본사총무팀장")) || user_id.equals(nm_db.getWorkAuthUser("본사영업팀장")) || user_id.equals(nm_db.getWorkAuthUser("본사영업부팀장"))){
			s_kd = "5";
			t_wd = "";
			gubun1 = "";
			gubun2 = "3";
		}
		
		if(s_kd.equals("")){
			if(!user_bean.getLoan_st().equals("")){
				s_kd = "2";
				t_wd = user_bean.getUser_nm();
				gubun1 = "";//스피드메이트
				gubun2 = "2";
			}else{
				s_kd = "5";
				t_wd = "";
				gubun1 = "";//스피드메이트
				gubun2 = "2";
			}
		}
		gubun1 = "";//협력업체-스피드메이트
		gubun2 = "1";//정비일자
		gubun3 = "1";//기간
		sort = "7";//정비일자 정렬
	}
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
	
%>
<frameset rows="<%=height%>, *" border=1 name=ex>
  <frame src="./serv_c2_sh.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame src="about:blank" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
</frameset>
</HTML>