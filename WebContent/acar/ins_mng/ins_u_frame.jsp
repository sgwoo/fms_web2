<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.insur.*, acar.estimate_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");//�ڵ���������ȣ
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//���������ȣ
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cha_amt = request.getParameter("cha_amt")==null?"":request.getParameter("cha_amt");
	
	if(mode.equals("") || mode.equals("0")) mode = "1";
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "06", "03");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	if(ins_st.equals(""))	ins_st = ai_db.getInsSt(c_id);
	
	String update_yn = "Y";
		
	//����
	String var1 = e_db.getEstiSikVarCase("1", "", "ins_modify_dt");
	String var2 = e_db.getEstiSikVarCase("1", "", "ins_modify_mon");
		
	if(!ins_st.equals("")){
	
		InsurBean ins = ai_db.getInsCase(c_id, ins_st);

		String modify_deadline = c_db.addMonth(ins.getIns_exp_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) < AddUtil.parseInt(AddUtil.getDate(4))){
			update_yn = "N";
		}
		
	}
	
	
%> 
<HTML>
<HEAD>
<title>FMS</title>
</HEAD>
<% 	if(!ins_st.equals("")){%>
<FRAMESET rows="340, *" border=0>
	<FRAME SRC="ins_u_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&ins_st=<%=ins_st%>&gubun0=<%=gubun0%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&brch_id=<%=brch_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&go_url=<%=go_url%>&cmd=<%=cmd%>&s_st=<%=s_st%>&idx=<%=idx%>&gubun=<%=gubun%>&cha_amt=<%=cha_amt%>&update_yn=<%=update_yn%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
	<FRAME SRC="ins_u_in<%=mode%>.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&ins_st=<%=ins_st%>&gubun0=<%=gubun0%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&brch_id=<%=brch_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&go_url=<%=go_url%>&cmd=<%=cmd%>&s_st=<%=s_st%>&idx=<%=idx%>&gubun=<%=gubun%>&cha_amt=<%=cha_amt%>&update_yn=<%=update_yn%>" name="c_foot" frameborder=0 marginwidth="10" marginheight="10" scrolling="auto" noresize>	
</FRAMESET>
<%	}else{
		auth_rw = rs_db.getAuthRw(user_id, "04", "06", "01");%>
<FRAMESET rows="60, *" border=0>
	<FRAME SRC="../ins_reg/ins_reg_sh.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&client_id=<%=client_id%>&ins_st=<%=ins_st%>&gubun0=<%=gubun0%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&brch_id=<%=brch_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&go_url=<%=go_url%>&s_st=<%=s_st%>&idx=<%=idx%>&gubun=<%=gubun%>" name="c_body" frameborder=0 marginwidth="10" marginheight="10" scrolling="no" noresize>
	<%if(c_id.equals("")){%>
 	<FRAME SRC="../ins_reg/ins_reg_help.htm" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">
	<%}else{%>
 	<FRAME SRC="../ins_reg/ins_reg_sc.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&client_id=<%=client_id%>&ins_st=<%=ins_st%>&gubun0=<%=gubun0%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&gubun7=<%=gubun7%>&brch_id=<%=brch_id%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>&go_url=<%=go_url%>&s_st=<%=s_st%>&idx=<%=idx%>&gubun=<%=gubun%>" name="c_foot" frameborder=0 scrolling="auto" topmargin=0 marginwidth="10" marginheight="10">	
	<%}%>	
</FRAMESET>
<%	}%>
<NOFRAMES>
<BODY>
<P>�� �������� ������, �������� �� �� �ִ� �������� �ʿ��մϴ�.</P>
</body>
</NOFRAMES>
</HTML>
