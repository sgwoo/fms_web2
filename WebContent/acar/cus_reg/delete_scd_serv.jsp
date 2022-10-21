<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	/* 스케줄 삭제 */
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	int res_cnt = 0;
	int scd_cnt = 0;
	int result = 0;
	
	if(!car_mng_id.equals("") && !serv_id.equals("")){
		
		//예약시스템-정비대차 연결된 정비는 삭제하지 못한다.
		res_cnt = rs_db.getRentContServChk(car_mng_id, serv_id);
		
		//면책금 스케줄 있는거 삭제 못한다.
		scd_cnt = rs_db.getScdExtServChk(car_mng_id, serv_id);
		
		if((res_cnt+scd_cnt) == 0){
			result 	= cr_db.deleteScdServ(car_mng_id, serv_id);
			result 	= cr_db.delServ_item_all(car_mng_id, serv_id);
		}
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language='javascript'>
<%	if(res_cnt > 0 && scd_cnt == 0){%>
		alert("예약시스템-정비대차에 연결되어 있습니다. 예약시스템에서 먼저 삭제해야 합니다.");
		location='about:blank';		
<%	}else if(res_cnt == 0 && scd_cnt > 0){%>
		alert("면책금 수금스케줄에 연결되어 있습니다. 삭제할 수 없습니다.");
		location='about:blank';		
<%	}else if(res_cnt > 0 && scd_cnt > 0){%>
		alert("예약시스템-정비대차에 연결되어 있고, 면책금 수금스케줄에도 연결되어 있습니다. 삭제할 수 없습니다.");
		location='about:blank';		
<%	}else{		%>		
		alert("해당 스케줄이 삭제되었습니다");
		parent.scd_serv.location.href="cus_reg_service_in.jsp?car_mng_id=<%=car_mng_id%>&serv_id=<%= serv_id %>";
<%	}			%>
</script>
</body>
</html>