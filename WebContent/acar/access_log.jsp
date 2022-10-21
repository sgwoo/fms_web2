<%@ page import="acar.util.*" %>
<%	
	AccessLog log_db = AccessLog.getInstance();

	String m_st 	= request.getParameter("m_st")==null? "":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null? "":request.getParameter("m_cd");
	
	if(!m_st.equals("") && !m_st2.equals("") && !m_cd.equals("")){
		String url 	= request.getParameter("url")==null? request.getRequestURI():request.getParameter("url");
		String login_ip = request.getRemoteAddr();
	
		log_db.insertAccessLog(m_st, m_st2, m_cd, ck_acar_id, login_ip, url);
	}	
	
%>