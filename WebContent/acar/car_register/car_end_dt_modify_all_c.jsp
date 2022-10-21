<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ page import="acar.car_register.*"%>
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
			
	String[] data_arr = request.getParameterValues("data");
	int cnt = data_arr.length;
	int resultCnt = 0;
	boolean flag = false;
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	for(int i=0; i < cnt; i++){	//������ ���� �� ���� for�� ����
		String param = data_arr[i];
		if(param.contains("////")){	//���� ���ɸ����� �������� �ڵ�����ȣ�̷��� �������� ���� ���
			resultCnt ++;
		}else{	//���ɸ����� �������� �ڵ��� ��ȣ �̷��� ������ �������� ������ ������ ���
			String[] param_arr = param.split("//");
			String car_mng_id = param_arr[0];
			String cha_seq 	  = param_arr[1];
			String cha_dt 	  = param_arr[2];
			if(!car_mng_id.equals("") && !car_mng_id.equals("") && !car_mng_id.equals("")){
				int result = crd.updateCarHis_cha_dt(car_mng_id, cha_seq, cha_dt);
				if(result==1){	resultCnt ++;	}
			}
		}	
	}
	
	if(cnt == resultCnt){	flag = true;	}
%>
	<script type="text/javascript" >
		var flag = <%=flag%>;
		if(flag==true){
			alert("�����Ǿ����ϴ�.");
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