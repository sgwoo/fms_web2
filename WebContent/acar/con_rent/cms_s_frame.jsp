<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 5; //�˻� ���μ�
	int height = (cnt*sh_line_height)+(cnt*1)+40;
%>

<HTML>
<%
	//����ý���-�繫ȸ��-cms����
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "02", "04");
	
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
	
	
	String sc_in_chk = "";
	
	if(s_kd.equals("") && t_wd.equals("") && gubun1.equals("")){
			s_kd 	= "1";
			t_wd 	= "";
			gubun1 	= "";
			gubun2 	= "";	
			gubun3 	= "3";	
			gubun4 	= "9";	
			gubun5 	= "";				
	}
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
		   	"&sh_height="+height+"";
%>

<frameset rows="<%=height%>, <%=AddUtil.parseInt(s_height)-height%>" border=1 name=ex>
  <frame src="./cms_sh.jsp<%=valus%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <%if(sc_in_chk.equals("no")){%>
  <FRAME SRC="about:blank" name="c_foot" frameborder=0 marginwidth="10" topmargin=0 scrolling="auto" noresize>	
  <%}else{%>
  <frame src="./cms_sc.jsp<%=valus%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <%}%>
</frameset>
</HTML>