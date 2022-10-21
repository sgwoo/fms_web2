<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	int cnt = 2; //검색 라인수
	int height = cnt*sh_line_height;
%>
<HTML>
<HEAD>
<title>FMS</title>
<script language='javascript'>
</script>
</HEAD>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "01");
	
	String s_kd 	= request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cont_st 	= request.getParameter("cont_st")==null?"":request.getParameter("cont_st");
	String b_lst 	= request.getParameter("b_lst")==null?"cont":request.getParameter("b_lst");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	if(user_id.equals("000003") && cont_st.equals("")) 	cont_st = "24";
	
	if(mode.equals("")){
		if(t_wd.equals("")){
%>
<frameset rows="<%=height%>, *" border=1>
  <frame src="./con_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&b_lst=<%=b_lst%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>&sh_height=<%=height%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame src="./con_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&b_lst=<%=b_lst%>&s_kd=2&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=AddUtil.getDate().substring(0,7)%>&cont_st=24&sh_height=<%=height%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
</frameset>
<%		}else{	%>
<frameset rows="<%=height%>, *" border=1>
  <frame src="./con_sh.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&b_lst=<%=b_lst%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>&sh_height=<%=height%>" name="c_body" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame src="./con_sc.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&b_lst=<%=b_lst%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>&sh_height=<%=height%>" name="c_foot" marginwidth=10 marginheight=10 scrolling='no' noresize>
</frameset>
<%		}
	}else{
		String m_id = request.getParameter("m_id")	==null?"":request.getParameter("m_id");
		String l_cd = request.getParameter("l_cd")	==null?"":request.getParameter("l_cd");
		String c_id = request.getParameter("c_id")	==null?"":request.getParameter("c_id");%>
<frameset rows="270, *, 0" border=1>
  <frame name="c_body" src="./con_reg_hi_u.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&b_lst=<%=b_lst%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling='no' noresize>
  <frame name="c_foot" src="./con_reg_all_u.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&b_lst=<%=b_lst%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>&sh_height=<%=height%>" marginwidth=10 marginheight=10 scrolling="auto">
  <FRAME name="nodisplay" SRC="about:blank" frameborder=0 scrolling="no" topmargin=0 marginwidth="10" marginheight="10">
</frameset>
<% 	}	%>
</HTML>
