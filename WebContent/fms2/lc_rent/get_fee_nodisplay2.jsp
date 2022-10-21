<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<%
	//��¥�� ���� �� ����ϴ� ������
	
	String rent_start_dt		=  request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt		=  request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	
	String con_mon 			=  "";
	String con_day 			=  "";
	String rent_sub_dt  =  "";
	int con_mon_sub = 0;
	int con_day_sub = 0;
	
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	
	// �뿩�Ⱓ (�뿩������ ~ �뿩������+��ళ����-1��)
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	con_mon = c_db.getMons(rent_end_dt, rent_start_dt);
	con_mon_sub = (int) Double.parseDouble(con_mon) ;
	rent_sub_dt =	c_db.addMonth(rent_start_dt,con_mon_sub);
	con_day_sub = c_db.getDays(rent_end_dt,rent_sub_dt);
	

%>

	parent.document.form1.con_mon.value		= '<%=con_mon_sub%>';
	parent.document.form1.con_day.value 		= '<%=con_day_sub%>';
	parent.set_cont_date();

</script>
</body>
</html>
