<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %> 

<%
	int cnt = 5; //�˻� ���μ�
	int height = (cnt*sh_line_height)+(cnt*1);
	int height2 = (cnt*sh_line_height)+(cnt*1)+30;
%>

<HTML>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "22", "08");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String del_yn 	= request.getParameter("del_yn")==null?"":request.getParameter("del_yn");
	
	if(s_kd.equals("") && t_wd.equals("") && gubun1.equals("") && gubun2.equals("")){
		
		MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		UserMngDatabase umd = UserMngDatabase.getInstance();
		user_bean 	= umd.getUsersBean(user_id);
		
		if(user_id.equals(nm_db.getWorkAuthUser("�λ�������"))){
			s_kd = "1";
			t_wd = "B1";
		}
		if(user_id.equals(nm_db.getWorkAuthUser("����������"))){
			s_kd = "1";
			t_wd = "D1";
		}
	
		if(s_kd.equals("")){
			if(!user_bean.getLoan_st().equals("")){
				s_kd = "5";
				t_wd = user_bean.getUser_nm();
			}else{
				s_kd = "4";
				t_wd = "";
			}
		}
		gubun1 = "3";
	}
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&del_yn="+del_yn+
				   	"&sh_height="+height+"";
	
	String valus2 = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&del_yn="+del_yn+
				   	"&sh_height="+height2+"";
%>
<frameset rows="<%=height%>, *" border=1 name=ex>
  <frame src="./fine_ocr_del_sh.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <%if( t_wd.equals("") && gubun2.equals("") && gubun3.equals("") && st_dt.equals("") && end_dt.equals("")){%>
  <FRAME SRC="/acar/menu/about_blank.jsp" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>  
  <%}else{%>
  <frame src="./fine_ocr_del_sc.jsp<%=valus2%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <%}%>
</frameset>
</HTML>