<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id		= request.getParameter("m_id");
	String l_cd		= request.getParameter("l_cd");
	String r_st		= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String p_st		= request.getParameter("p_st")==null?"":request.getParameter("p_st");
	
	String pp_tm		= request.getParameter("pp_tm")==null?"":request.getParameter("pp_tm");
	String pp_est_dt	= request.getParameter("pp_est_dt")==null?"":request.getParameter("pp_est_dt");
	int pp_s_amt		= request.getParameter("pp_s_amt")==null?0:Util.parseDigit(request.getParameter("pp_s_amt"));
	int pp_v_amt		= request.getParameter("pp_v_amt")==null?0:Util.parseDigit(request.getParameter("pp_v_amt"));
	int flag = 0;
	
	ExtScdBean grt = new ExtScdBean();
	grt.setRent_mng_id	(m_id);
	grt.setRent_l_cd	(l_cd);
	grt.setRent_st		(r_st);	
	grt.setExt_st		(p_st);	
	grt.setExt_tm		(pp_tm);
	grt.setExt_est_dt	(pp_est_dt);
	grt.setExt_s_amt	(pp_s_amt);
	grt.setExt_v_amt	(pp_v_amt);
	grt.setUpdate_id	(user_id);

%>
<html><head><title>FMS</title></head>
<body>
<form name='form1' action='/fms2/con_grt/grt_u.jsp' method="POST" target=d_content>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
</form>
<script language='javascript'>
<%	if(!ae_db.insertGrt(grt)){%>
		alert('오류발생!');
		parent.close();
<%	}else{%>
		alert('처리되었습니다');
		parent.opener.location='/fms2/con_grt/grt_u.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>';		
		parent.close();
<%	}%>
</script>
</body>
</html>
