<%@ page language="java" import="java.util.*, acar.util.*, acar.common.*" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 3; //�˻� ���μ�
	int height = cnt*sh_line_height;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1"); //��ȸ���� 1:�뿩��
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2"); //����ȸ 3:��ü
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3"); //�̼���
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4"); //3�����̸� 2:3�����̸�
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun"); //0:�Աݿ�����
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	String mode = request.getParameter("mode")	==null?"":request.getParameter("mode");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "07", "01", "02");
	
	//�ӿ��̰ų� �ѹ��������� ��ü�˻� / ����̰� �ѹ����� �ƴ� ������ �����Ҵ���ڷ� ��ȸ
	CommonDataBase c_db = CommonDataBase.getInstance();
	String id_chk = c_db.getUserBusYn(user_id);
	if(!id_chk.equals("") && s_kd.equals("0") && t_wd.equals("")){
		s_kd="8";
		t_wd=user_id;
	}
	
	
%>
<frameset rows="<%=height%>,*" border=1>
        <frame src="/acar/arrear/arrear_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&idx=<%=idx%>&sh_height=<%=height%>" name="c_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
		<frame src="/acar/arrear/arrear_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&idx=<%=idx%>&sh_height=<%=height%>" name="c_body" marginwidth=10 marginheight=10 scrolling="no">
</frameset>

</HTML>
