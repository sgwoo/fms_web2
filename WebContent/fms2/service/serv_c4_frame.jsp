<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 6; //�˻� ���μ�
	int height = (cnt*sh_line_height)+(cnt*1)+40;
%>

<HTML>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "08", "03");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(s_kd.equals("") && t_wd.equals("") && gubun1.equals("")){
		
		MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		UserMngDatabase umd = UserMngDatabase.getInstance();
		user_bean 	= umd.getUsersBean(user_id);
		
		if(user_id.equals(nm_db.getWorkAuthUser("�λ�������")) || user_id.equals(nm_db.getWorkAuthUser("�λ��ⳳ"))){
			s_kd = "5";
			t_wd = "";
			gubun1 = "�ΰ��ڵ�������";
			gubun2 = "3";
		}
		if(user_id.equals(nm_db.getWorkAuthUser("����������")) || user_id.equals(nm_db.getWorkAuthUser("�����ⳳ"))){
			s_kd = "5";
			t_wd = "";
			gubun1 = "(��)����ī��ũ";
			gubun2 = "3";
		}
		if(nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){
			s_kd = "4";
			t_wd = "";
			gubun1 = user_bean.getUser_nm();
			gubun2 = "3";
		}
		if(user_id.equals(nm_db.getWorkAuthUser("�����ѹ�����")) || user_id.equals(nm_db.getWorkAuthUser("���翵������")) || user_id.equals(nm_db.getWorkAuthUser("���翵��������"))){
			s_kd = "5";
			t_wd = "";
			gubun1 = "";
			gubun2 = "3";
		}
		
		if(s_kd.equals("")){
			if(!user_bean.getLoan_st().equals("")){
				s_kd = "2";
				t_wd = user_bean.getUser_nm();
				gubun1 = "";
				gubun2 = "3";
			}else{
				s_kd = "5";
				t_wd = "";
				gubun1 = "";
				gubun2 = "3";
			}
		}
		gubun3 = "4";
		sort = "8";
	}
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
%>
<frameset rows="<%=height%>, <%=AddUtil.parseInt(s_height)-height%>" border=1 name=ex>
  <frame src="./serv_c4_sh.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame src="./serv_c4_sc.jsp<%=valus%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
</frameset>
</HTML>