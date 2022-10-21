<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//예약시스템 예약등록시 대여만료일  셋팅 페이지
	
	String from_page  		= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	String rent_start_dt_y 		= request.getParameter("rent_start_dt_y")==null?"":request.getParameter("rent_start_dt_y");
	String rent_start_dt_m		= request.getParameter("rent_start_dt_m")==null?"":request.getParameter("rent_start_dt_m");
	String rent_start_dt_d  	= request.getParameter("rent_start_dt_d")==null?"":request.getParameter("rent_start_dt_d");	
	String rent_st		  	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");	
	int rent_mon 			= request.getParameter("rent_mon")==null?0:AddUtil.parseInt(request.getParameter("rent_mon"));	
	
	String rent_end_dt		="";
	String rent_start_dt		="";
	
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
%>	
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
	
	// 대여기간 (대여개시일 ~ 대여개시일+(개월수*30))
	if(from_page.equals("/acar/res_search/res_rent_i.jsp") || from_page.equals("/acar/res_stat/res_rent_u.jsp") || from_page.equals("/acar/rent_mng/res_rent_u.jsp")){
		
		rent_start_dt  	= request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");	
		rent_end_dt  	= request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");	
		


			
		//월렌트-장기대여와 같은 방식
		Hashtable ht = af_db.getUseMonDay(rent_end_dt, rent_start_dt);		
				
%>

		parent.document.form1.rent_months.value 	= '<%=ht.get("U_MON")%>';
		parent.document.form1.rent_days.value 		= '<%=ht.get("U_DAY")%>';
		parent.document.form1.rent_hour.value 		= '0';		
		
		parent.set_amt(parent.document.form1.inv_s_amt);
		
		<%if(from_page.equals("/acar/res_search/res_rent_i.jsp")){%>
		parent.document.form1.v_rent_months.value 	= '<%=ht.get("U_MON")%>';
		parent.document.form1.v_rent_days.value 	= '<%=ht.get("U_DAY")%>';		
		<%}%>
					
<%

	}else{

		if(from_page.equals("/acar/rent_mng/res_action.jsp")){
			rent_mon = request.getParameter("ext_rent_mon")==null?0:AddUtil.parseInt(request.getParameter("ext_rent_mon"));				
		}			

		
		if(rent_mon >0){
	
			rent_start_dt = rent_start_dt_y+""+rent_start_dt_m+""+rent_start_dt_d;
			
			
			if(from_page.equals("/acar/rent_mng/res_action.jsp")){
				rent_start_dt  	= request.getParameter("ext_rent_start_dt")==null?"":request.getParameter("ext_rent_start_dt");	
				rent_end_dt  	= request.getParameter("add_dt")==null?"":request.getParameter("add_dt");	
			}			
			

			//1.30일을 한달로 한다.
			//rent_end_dt = c_db.addDay(rent_start_dt, ((30*rent_mon)-1));
	
			//2.장기대여와 같은 방식
			rent_end_dt = c_db.addMonth(rent_start_dt, rent_mon);
			rent_end_dt = c_db.addDay(rent_end_dt, -1);
			
			
%>

		<%if(from_page.equals("/acar/rent_mng/res_action.jsp")){%>
		parent.document.form1.add_dt.value			= '<%=rent_end_dt%>';
		<%}else{%>
		parent.document.form1.rent_end_dt_y.value		= '<%=rent_end_dt.substring(0, 4)%>';
		parent.document.form1.rent_end_dt_m.value 		= '<%=rent_end_dt.substring(4, 6)%>';
		parent.document.form1.rent_end_dt_d.value 		= '<%=rent_end_dt.substring(6, 8)%>';		
		<%}%>

<%			
			
		}
		
	}
%>	

</script>
</body>
</html>
