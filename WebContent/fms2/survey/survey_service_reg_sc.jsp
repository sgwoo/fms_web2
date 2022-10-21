<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
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
	
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_id 	= request.getParameter("s_id")==null?"":request.getParameter("s_id");
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String accid_st 	= request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String p_gubun 	= request.getParameter("p_gubun")==null?"":request.getParameter("p_gubun");
	
	//[�˻��׸�]
	String s_kd 	= request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");		//�˻��׸�
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	//�������ڵ�
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");	//������
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");		//�˻��ܾ�
	String cont_st 	= request.getParameter("cont_st")==null?"":request.getParameter("cont_st");	//��౸��
	String b_lst 	= request.getParameter("b_lst")==null?"cont":request.getParameter("b_lst"); //��û����������
	
	String type 	= request.getParameter("type")==null?"1":request.getParameter("type"); //����������
	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	
	String poll_st 	= request.getParameter("poll_st")==null?"":request.getParameter("poll_st");		//���Ÿ��
	String serv_dt 	= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link><script language="JavaScript">
<!--

//-->
</script>
</head>

<frameset cols="50%, *" border=1>  
  <frame name="c_body" src="survey_service_reg_hi_u.jsp?dt=<%=dt%>&gubun2=<%=gubun2%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&type=<%=type%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&use_yn=<%=use_yn%>&c_id=<%=c_id%>&s_id=<%=s_id%>&p_gubun=<%=p_gubun%>&poll_st=<%=poll_st%>" marginwidth=10 marginheight=10 scrolling='auto' >
  <frame name="c_foot" src="survey_service_reg_all_u.jsp?dt=<%=dt%>&gubun2=<%=gubun2%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&type=<%=type%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&s_id=<%=s_id%>&p_gubun=<%=p_gubun%>&poll_st=<%=poll_st%>&serv_dt=<%=serv_dt%>" marginwidth=10 marginheight=10 scrolling="auto">
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>

</html>