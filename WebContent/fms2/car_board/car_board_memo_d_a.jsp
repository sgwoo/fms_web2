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
	
	String m_id		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_mng_id		= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String  m_seq 		= request.getParameter("m_seq")==null?"0":request.getParameter("m_seq");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CarBoardBean memo = new CarBoardBean();
	memo.setCar_mng_id		(car_mng_id);
	memo.setSeq			(AddUtil.parseInt(m_seq));
	
	flag = cb_db.deleteCarBoardMemo(memo);

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
		alert('삭제되었습니다');	
		document.form1.action = 'car_board_sc.jsp';
		document.form1.target = 'cm_foot';
	
		document.form1.submit();
<%	}%>

</script>
</body>
</html>
