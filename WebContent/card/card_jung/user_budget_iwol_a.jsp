<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.user_mng.*" %>"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body style="font-size:12">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String job_st = request.getParameter("job_st")==null?"":request.getParameter("job_st");
	
    String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");		
	int s_amt = request.getParameter("s_amt")==null?0:Integer.parseInt(request.getParameter("s_amt"));
	String bu_st = request.getParameter("bu_st")==null?"":request.getParameter("bu_st");
	
	String s_flag = "";
		
	int flag = 0;
	int count = 0;
	
	//������ �ܾ��� ������.( -�ܾ��� �޿�����, �̿��ܾ��� 0 , +�ܾ��� �̿���)	
	//2009�� ������ ���ݾ�(5��,10������):44000, 5��,10��:205000(161000+44000) ���� SETTING
	//2009�� ������ ���ݾ�:360000
	//2010�� :900000
	//2010�� ������ �����ѵ��ο�
	//2019sus : ��Ÿ :�̻� 300000, ���� :150000 �ο� , ������� �ѵ� ����.
	
	if ( job_st.equals("1") ) {			
	 	s_flag =  CardDb.call_sp_insert_user_budget(s_year, bu_st, user_id);
	 	System.out.println("���̿� ���" + s_flag);
	}else if ( job_st.equals("2") ) {	
	 //���ݾ� settting
	  s_flag =  CardDb.updateBudgetAmt(s_year, s_month, bu_st, s_amt);
	  System.out.println("���ݾ�setting���" + s_flag);
	  //������ �������� ���� - ���� �ѹ���, ��������, �����ƴ븮
	  if (bu_st.equals("2")) {
	   	 s_flag =  CardDb.updateBudgetAmtN(s_year, s_month, bu_st, s_amt);
	  }
	}	
		
%>
<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

</form>
<script language='javascript'>
<%	if(!s_flag.equals("0")){  %>
		alert("ó������ �ʾҽ��ϴ�");
<%	}else{		%>
		alert("ó���Ǿ����ϴ�");
<%	}			%>
</script>
</body>
</html>