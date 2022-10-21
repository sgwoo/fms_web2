<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	int cnt = 5; //검색 라인수
	int height = cnt*sh_line_height+30;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
</HEAD>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");	
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	int ja_amt 	= request.getParameter("ja_amt")==null?0:AddUtil.parseDigit(request.getParameter("ja_amt"));
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	if(ja_amt >0){
		EstimateBean e_bean = e_db.getEstimateCase(est_id);
		e_bean.setRo_13_amt(ja_amt);
		int flag = e_db.updateEstimate(e_bean);
	}	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&m_id="+m_id+"&l_cd="+l_cd+"&est_id="+est_id+
				   	"&sh_height="+height+"";	
%>
<frameset rows="40,*" border=1>
    <frame src="/fms2/lc_rent/rent_start_new_car_re_esti_sh.jsp<%=valus%>" name="p_head" marginwidth=10 marginheight=10 scrolling="no" noresize>
    <frame src="/fms2/lc_rent/rent_start_new_car_re_esti_sc.jsp<%=valus%>" name="p_body" marginwidth=10 marginheight=10 scrolling="auto">
</frameset>
</HTML>
