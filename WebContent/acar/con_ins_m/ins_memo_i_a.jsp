<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.con_ins_m.*, acar.car_accident.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String tm_st = request.getParameter("tm_st")==null?"":request.getParameter("tm_st");	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	boolean flag = true;
	
	InsMemoBean memo = new InsMemoBean();
	memo.setRent_mng_id(m_id);
	memo.setRent_l_cd(l_cd);
	memo.setCar_mng_id(c_id);
	memo.setAccid_id(accid_id);
	memo.setServ_id(serv_id);
	memo.setTm_st(tm_st);
	memo.setSeq("");
	memo.setReg_id(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));	// cookie세팅
	memo.setReg_dt(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	memo.setContent(request.getParameter("content")==null?"":request.getParameter("content"));
	memo.setSpeaker(request.getParameter("speaker")==null?"":request.getParameter("speaker"));
	
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	flag = a_cad.insertInsMemo(memo);

%>
<form name='form1' action='/acar/con_ins_m/ins_memo_frame_s.jsp' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='tm_st' value='<%=tm_st%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='mng_id' value='<%=mng_id%>'>
</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
		location='about:blank';
<%	}else{%>
		alert('등록되었습니다');
		document.form1.target = 'INS_MEMO';
		document.form1.submit();
<%	}%>
</script>
</body>
</html>
