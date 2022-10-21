<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.consignment.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	boolean flag = true;
	int result = 0;
	
	
%>


<%
	String standby_st1	= request.getParameter("standby_st1")==null?"":request.getParameter("standby_st1");
	String standby_st2	= request.getParameter("standby_st2")==null?"":request.getParameter("standby_st2");
	
	String standby_dt1 = AddUtil.getDate(4);
	String standby_dt2 = af_db.getValidDt(rs_db.addDay(standby_dt1, 1));
	
	out.println(standby_dt1);
	out.println(standby_st1);out.println("<br>");
	out.println(standby_dt2);
	out.println(standby_st2);
	
	String chk1 = cs_db.getConsStandbySt(user_id, standby_dt1);
	String chk2 = cs_db.getConsStandbySt(user_id, standby_dt2);
	
	
	//오늘
	if(!standby_st1.equals("") && chk1.equals(""))				flag = cs_db.insertConsStandby(user_id, standby_dt1, standby_st1);
	else if(!standby_st1.equals("") && !chk1.equals(""))		flag = cs_db.updateConsStandby(user_id, standby_dt1, standby_st1);
	
	//내일
	if(!standby_st2.equals("") && chk2.equals(""))				flag = cs_db.insertConsStandby(user_id, standby_dt2, standby_st2);
	else if(!standby_st2.equals("") && !chk2.equals(""))		flag = cs_db.updateConsStandby(user_id, standby_dt2, standby_st2);
	%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
</form>
<script language='javascript'>
	alert('등록되었습니다.');
	parent.self.close();	
</script>
</body>
</html>