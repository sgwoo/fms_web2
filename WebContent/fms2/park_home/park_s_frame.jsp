<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%

	int height = 150; //�˻� ���μ�(�����ϰ� ������ ���̿� �����ִ� ���� ����)
%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
		
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "13", "01", "02");
	
	if(s_kd.equals("") && t_wd.equals("") && gubun1.equals("") && gubun2.equals("")){
		s_kd = "";
	}
	
	if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")){
		brid = "1";
	}else if(br_id.equals("B1")){
		brid = "3";
	}else if(br_id.equals("D1")){
		brid = "4";
	}else if(br_id.equals("J1")){
		brid = "5";
	}else if(br_id.equals("G1")){
		brid = "6";
	}
	
	String sort_gubun = request.getParameter("sort_gubun")==null?"5":request.getParameter("sort_gubun");
	
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&brid="+brid+"&asc="+asc+"&gubun="+gubun+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort_gubun="+sort_gubun+"&asc="+asc+
				   	"&sh_height="+height+"";
%>
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<FRAMESET rows="<%=height%>, *" >
	<FRAME SRC="./park_s_sh.jsp<%=valus%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" >
	<FRAME SRC="./park_s_sc.jsp<%=valus%>" name="c_foot" frameborder=0 scrolling="no"  marginwidth="10" topmargin=10 noresize>
</FRAMESET>

<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
