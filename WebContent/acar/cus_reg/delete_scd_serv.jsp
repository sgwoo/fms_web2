<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	/* ������ ���� */
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	int res_cnt = 0;
	int scd_cnt = 0;
	int result = 0;
	
	if(!car_mng_id.equals("") && !serv_id.equals("")){
		
		//����ý���-������� ����� ����� �������� ���Ѵ�.
		res_cnt = rs_db.getRentContServChk(car_mng_id, serv_id);
		
		//��å�� ������ �ִ°� ���� ���Ѵ�.
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
		alert("����ý���-��������� ����Ǿ� �ֽ��ϴ�. ����ý��ۿ��� ���� �����ؾ� �մϴ�.");
		location='about:blank';		
<%	}else if(res_cnt == 0 && scd_cnt > 0){%>
		alert("��å�� ���ݽ����ٿ� ����Ǿ� �ֽ��ϴ�. ������ �� �����ϴ�.");
		location='about:blank';		
<%	}else if(res_cnt > 0 && scd_cnt > 0){%>
		alert("����ý���-��������� ����Ǿ� �ְ�, ��å�� ���ݽ����ٿ��� ����Ǿ� �ֽ��ϴ�. ������ �� �����ϴ�.");
		location='about:blank';		
<%	}else{		%>		
		alert("�ش� �������� �����Ǿ����ϴ�");
		parent.scd_serv.location.href="cus_reg_service_in.jsp?car_mng_id=<%=car_mng_id%>&serv_id=<%= serv_id %>";
<%	}			%>
</script>
</body>
</html>