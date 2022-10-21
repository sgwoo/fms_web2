<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.car_board.*"%>
<jsp:useBean id="cb_db" scope="page" class="acar.car_board.CarBoardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	boolean flag = true;
	
   String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
		
	LoginBean login = LoginBean.getInstance();
	String reg_id = login.getCookieValue(request, "acar_id");
	
	CarBoardBean memo = new CarBoardBean();
	memo.setCar_mng_id		(car_mng_id);
	memo.setRent_mng_id	(m_id);
	memo.setRent_l_cd	(l_cd);
	memo.setGubun		(gubun);
	memo.setReg_id		(reg_id);
	memo.setReg_dt		(request.getParameter("t_reg_dt"));
	memo.setContent		(AddUtil.nullToNbsp(request.getParameter("t_content")));
	
	flag = cb_db.insertCarBoardMemo(memo);
%>
<form name='form1'  method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>

</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
<%	}else{%>
		alert('등록되었습니다');		
		document.form1.action = 'car_board_sc.jsp';
		document.form1.target = 'cm_foot';	
		document.form1.submit();

<%	}%>

</script>
</body>
</html>
