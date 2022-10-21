<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>

<%
	String car_st =  request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd =  request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String rent_mng_id 	= request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd");
	String car_comp_id 	= request.getParameter("car_comp_id");
	String car_mng_id 	= request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm");
	String car_name 	= request.getParameter("car_name");
	
	ContCarBean car = a_db.getContCar(rent_mng_id, rent_l_cd);
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//자동차회사 리스트
	CodeBean[] companys = c_db.getCodeAll("0001"); /* 코드 구분:자동차회사 */
	int com_size = companys.length;	
%>

	var fm = parent.opener.form1;
	fm.car_mng_id.value		='<%=car_mng_id%>';
	
    <%	for ( int i = 0 ; i < com_size ; i++){
			CodeBean company = companys[i];	%>		
			<%if(company.getCode().equals(car_comp_id)){%>
				fm.car_comp_id[<%=i%>].selected = true;
			<%}%>
    <%	}		%>
					
	fm.car_name.value		='<%=car_nm%> <%=car_name%>';
	fm.car_amt.value		='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>';
	fm.opt_amt.value		='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>';
	fm.car_no.value			='<%=car_no%>';	

	parent.close();

</script>
</body>
</html>
