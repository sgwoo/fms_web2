<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//�����ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");		//�Ҽ�����ID
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "16", "01", "02");
	
	String mode_str = request.getParameter("mode")==null?"":request.getParameter("mode"); 		//���,��ȸ(����)����
	String use_yn 	= request.getParameter("use_yn")==null?"":request.getParameter("use_yn"); 	//������
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id"); 		//��༭������ȣ(rent_mng_id)
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd"); 		//����ȣ		(rent_l_cd)
	String cls_st 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st"); 	//�����϶�(����̰�,��������)
	
	//[�˻��׸�]
	String s_kd 	= request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");		//�˻��׸�
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	//�������ڵ�
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");	//������
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");		//�˻��ܾ�
	String cont_st 	= request.getParameter("cont_st")==null?"":request.getParameter("cont_st");	//��౸��
	String b_lst 	= request.getParameter("b_lst")==null?"cont":request.getParameter("b_lst"); //��û����������
	
	String type 	= request.getParameter("type")==null?"1":request.getParameter("type"); //����������
	
	String poll_st 	= request.getParameter("poll_st")==null?"":request.getParameter("poll_st");		//���Ÿ��
	String cls_dt 	= request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
%>


<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>

<FRAMESET rows="50, *" border=0>
	<FRAME SRC="./survey_rm_reg_sh.jsp?type=<%=type%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&use_yn=<%=use_yn%>&poll_st=<%=poll_st%>&cls_dt=<%=cls_dt%>" name="c_body" frameborder=0  marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="./survey_rm_reg_sc.jsp?type=<%=type%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&use_yn=<%=use_yn%>&poll_st=<%=poll_st%>&from_page=<%=from_page%>&cls_dt=<%=cls_dt%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
</FRAMESET>

</HTML>
