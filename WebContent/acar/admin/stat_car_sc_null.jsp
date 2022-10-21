<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String today = AddUtil.getDate(4);
	int flag = 0;
	int flag2 = 0;
	int flag3 = 0;
	
	flag2 = ad_db.getInsertYn("stat_car", today);
	//�����ߺ�üũ
	flag3 = ad_db.getCarOverlapChk();
	
	if(flag2 == 0 && flag3 == 0){
		String y2000[] = request.getParameterValues("y2000");
		String y2001[] = request.getParameterValues("y2001");
		String y2002[] = request.getParameterValues("y2002");
		String y2003[] = request.getParameterValues("y2003");
		String y2004[] = request.getParameterValues("y2004");
		String y2005[] = request.getParameterValues("y2005");
		
		for(int i=0; i<12; i++){
			StatCarBean bean = new StatCarBean();
			bean.setSave_dt(today);
			bean.setSeq(AddUtil.addZero2(i));
			bean.setY2000(AddUtil.parseDigit(y2000[i]));
			bean.setY2001(AddUtil.parseDigit(y2001[i]));
			bean.setY2002(AddUtil.parseDigit(y2002[i]));
			bean.setY2003(AddUtil.parseDigit(y2003[i]));
			bean.setY2004(AddUtil.parseDigit(y2004[i]));
			bean.setY2005(AddUtil.parseDigit(y2005[i]));
			bean.setReg_id(user_id);
			if(!ad_db.insertStatCar(bean)) flag = 1;
		}
	}
%>
<form name='form1' action='stat_car_sc.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=today%>'>
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag2 != 0){%>
	alert('�̹� ��ϵǾ����ϴ�.\n\n�������ڴ� �ѹ��� ��� �����մϴ�.');
<%	}else if(flag3 != 0){%>
	alert('�ߺ��� ������ �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');
<%	}else{
		if(flag != 0){%>
		alert('��� �����߻�!');
<%		}else{%>
		alert('��ϵǾ����ϴ�.');
		fm.submit();				
<%		}
	}%>
</script>
</body>
</html>