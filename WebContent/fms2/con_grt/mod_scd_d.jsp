<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String m_id		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String r_st		= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String p_st		= request.getParameter("p_st")==null?"":request.getParameter("p_st");
	String tm		= request.getParameter("tm")==null?"":request.getParameter("tm");
	
	String rent_st	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String ext_dt	= request.getParameter("ext_dt")==null?"":request.getParameter("ext_dt");
	String pay_dt	= request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	String est_dt	= request.getParameter("est_dt")==null?pay_dt:request.getParameter("est_dt");
	int pay_amt		= request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));
	
	ExtScdBean pay_grt = ae_db.getAGrtScd(m_id, l_cd, rent_st, p_st, tm);
%>
<form name='form1' method="POST">
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
</form>

<script language='javascript'>
<%	if(!ae_db.deleteGrt(pay_grt)){%>
		alert('오류발생!');
<%	}else{%>
		alert('처리되었습니다');
<%	}%>
		var fm = document.form1;
		fm.action= '/fms2/con_grt/grt_u.jsp';
		fm.target='d_content';
		fm.submit();
</script>
</body>
</html>