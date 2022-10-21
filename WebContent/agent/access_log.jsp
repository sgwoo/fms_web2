<%@ page import="acar.util.*" %>
<%	
	AccessLog log_db = AccessLog.getInstance();
	String m_st 	= request.getParameter("m_st")==null? "":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null? "":request.getParameter("m_cd");
	
	//페이지 오픈 로그
	if(!m_st.equals("") && !m_st2.equals("") && !m_cd.equals("")){
		String login_ip = request.getRemoteAddr();//로그인IP
		
		String url 	= request.getParameter("url")==null? "":request.getParameter("url");
		
		log_db.insertAccessLog(m_st, m_st2, m_cd, ck_acar_id, login_ip, url);
	}
%>