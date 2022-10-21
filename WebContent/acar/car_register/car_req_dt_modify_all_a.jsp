<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*"%>
<%@ page import="acar.car_register.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<title>FMS</title>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String end_req_dt = request.getParameter("end_req_dt")==null?"":request.getParameter("end_req_dt"); //ó��������
			
	String[] car_mng_id_arr = request.getParameterValues("car_mng_id");
	int cnt = car_mng_id_arr.length;	
	boolean flag = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	for(int i=0; i < cnt; i++){	//������ ���� �� ���� for�� ����
		String car_mng_id = car_mng_id_arr[i];	
		flag = crd.updateCarEndReqDt(end_req_dt, user_id, car_mng_id);
		
	}
%>
	<script type="text/javascript" >
		var flag = <%=flag%>;
		if(flag==true){
			alert("��ϵǾ����ϴ�.");
		}else{
			alert("���� �� �����߻�! \n\n�����ڿ��� �����ϼ���.");
		}
		window.opener.document.location.reload();
		window.close();
	
	</script>
<%	
%>	
</body>
</html>