<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*, acar.cost.*, acar.user_mng.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String ip_auth 	= request.getParameter("ip_auth")==null?"":request.getParameter("ip_auth");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String today 	= AddUtil.getDate(4);
	String save_dt 	= today;
	
	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;
	int flag5 = 0;
	int flag6 = 0;
	int flag7 = 0;
	int flag8 = 0;
	int flag9 = 0;
	int flag10 = 0;
	int flag11 = 0;
	int flag12 = 0;
	
	int flag3_2 = 0;
	
	int count = 0;


	//����� �뿩�� ��ü��Ȳ
	if(mode.equals("1") || mode.equals("all_1"))
	{
		String  d_flag =  ad_db.call_sp_stat_dly_magam();
	    if (!d_flag.equals("0")) flag1 = 1;
	    System.out.println("����� �뿩�� ��ü��Ȳ =" + d_flag);
	}


	//��ä��Ȳ
	if(mode.equals("2") || mode.equals("all_1"))
	{
		String  d_flag =  ad_db.call_sp_debt_magam(today, user_id);
	// 	String  d_flag =  ad_db.call_sp_debt_magam("20120912", user_id); //�ش����ڷ� ������ ��
	    if (!d_flag.equals("0")) flag2 = 1;
	    System.out.println("��ä���� ��� =" + d_flag);
	}


	//�ڵ�����Ȳ
	if(mode.equals("3") || mode.equals("all_1"))
	{
		//�����ߺ�üũ
		flag3_2 = ad_db.getCarOverlapChk();
		
		if(flag3_2 == 0){
			String  d_flag =  ad_db.call_sp_stat_car_magam();
	    	if (!d_flag.equals("0")) flag3 = 1;
	    	System.out.println("�ڵ�����Ȳ =" + d_flag);
			
		}
	}


	//����� ����������Ȳ
	if(mode.equals("5") || mode.equals("all_1"))
	{
		String  d_flag =  ad_db.call_sp_stat_mng_magam();
	    if (!d_flag.equals("0")) flag5 = 1;
	    System.out.println("����� ����������Ȳ =" + d_flag);
	}


	//����� ����������Ȳ
	if(mode.equals("6") || mode.equals("all_1"))
	{
		String  d_flag =  ad_db.call_sp_stat_bus_magam();
	    if (!d_flag.equals("0")) flag6 = 1;
	    System.out.println("����� ����������Ȳ =" + d_flag);
	}


	//ä��ķ����
	if(mode.equals("8") || mode.equals("all_1") || mode.equals("all_2"))
	{
		String  d_flag =  ad_db.call_sp_stat_settle_magam();
	    if (!d_flag.equals("0")) flag8 = 1;
	    System.out.println("ä��ķ���� =" + d_flag);
	}


	//����� �λ�������Ȳ
	if(mode.equals("7") || mode.equals("all_1"))
	{
		String  d_flag =  ad_db.call_sp_stat_total_magam();
	    if (!d_flag.equals("0")) flag7 = 1;
    	System.out.println("����� �λ�������Ȳ =" + d_flag);
	}


	//����ķ����
//	if(mode.equals("9") || mode.equals("all_2"))
	if(mode.equals("9_1_201905") || mode.equals("9_2_201905"))
	{
		//1. ����ȿ�� �⺻���� ����-------------------------------------------------------
		String  d_flag1 =  ac_db.call_sp_sale_cost_base_magam(today, user_id);
		if (!d_flag1.equals("0")) flag9 = 1;
		System.out.println("����ȿ����븶�� ��� =" + d_flag1);
		
		//2. ������� �⺻���� ����-------------------------------------------------------
		String  d_flag2 =  ad_db.call_sp_stat_bus_cmp_base_magam();
		if (!d_flag2.equals("0")) flag9 = 1;
		System.out.println("��������⺻���� ��� =" + d_flag2);
		
		String  d_flag =  ad_db.call_sp_stat_bus_cmp_magam();
	    if (!d_flag.equals("0")) flag9 = 1;
	    System.out.println("���տ���ķ���� =" + d_flag);

		String  d_flag3 =  ad_db.call_sp_stat_bus_cmp_magam_v19();
	    if (!d_flag3.equals("0")) flag9 = 1;
	    System.out.println("(��)���տ���ķ���� =" + d_flag);
	
	}
	
	//�� ����ķ����	
	//if(mode.equals("9_1_201905") || mode.equals("9_2_201905"))
	//{
	//	String  d_flag =  ad_db.call_sp_stat_bus_cmp_magam_v19();
	//    if (!d_flag.equals("0")) flag9 = 1;
	//    System.out.println("(��)���տ���ķ���� =" + d_flag);
	//}	


	//�������ķ����
	if(mode.equals("15") || mode.equals("all_2"))
	{
		//stord procedure call
		
		String  d_flag0 =  ac_db.call_sp_cost_accident_magam(today, user_id);	
		if (!d_flag0.equals("0")) flag2 = 1;	
		System.out.println("������� ����� ���");
			
		String  d_flag1 =  ac_db.call_sp_cost_base_magam(today, user_id);	
		if (!d_flag1.equals("0")) flag2 = 1;	
		System.out.println("������� ���ʸ��� ���");
		
		String  d_flag2 =  ac_db.call_sp_cost_pre_base_magam(today, user_id);	
		if (!d_flag2.equals("0")) flag2 = 1;	
		System.out.println("������� ������ ���ʸ��� ���");
					
		String  d_flag3 =  ac_db.call_sp_man_cost_magam(today, user_id);
		if (!d_flag3.equals("0")) flag2 = 1;
		    System.out.println("�������� ������븶�� ���");
		    
		String  d_flag4 =  ac_db.call_sp_man_cost3_magam(today, user_id);
		if (!d_flag4.equals("0")) flag2 = 1;
		    System.out.println("������ ������븶�� ���");    
	
	}


	//����ķ����
	if(mode.equals("22") || mode.equals("all_2"))
	{
		String  d_flag1 =  ac_db.call_sp_prop_magam(today, user_id);
		if (!d_flag1.equals("0")) flag11 = 1;
		System.out.println("���� ķ���� ���� ��� =" + d_flag1);
		
		String  d_flag2 =  ac_db.call_sp_prop_magam1(today, user_id);
	    if (!d_flag2.equals("0")) flag11 = 1;
	    System.out.println("�ܱ� ķ���� ���� ��� =" + d_flag2);
	}


	//����/������Ȳ
	if(mode.equals("30"))
	{
		String  d_flag =  ad_db.call_sp_stat_incom_pay_magam();
	}



%>
<form name='form1' action='stat_end_sc.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=today%>'>
<input type='hidden' name='mode' value=''>
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag1 != 0){%>
	alert('��ü��Ȳ ������� ���� �߻�!');
<%	}
	if(flag2 != 0){%>
	alert('��ä��Ȳ ������� ���� �߻�!');
<%	}
	if(flag3_2 != 0){%>
	alert('�ߺ��� ������ �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');		
<%	}
	if(flag3 != 0){%>
	alert('�ڵ�����Ȳ ������� ���� �߻�!');
<%	}
	if(flag5 != 0){%>
	alert('������Ȳ ������� ���� �߻�!');		
<%	}
	if(flag6 != 0){%>
	alert('����������Ȳ ������� ���� �߻�!');			
<%	}
	if(flag7 != 0){%>
	alert('�λ�������Ȳ ������� ���� �߻�!');				
<%	}
	if(flag8 != 0){%>
	alert('ä��ķ���� ������� ���� �߻�!');				
<%	}
	if(flag9 != 0){%>
	alert('���տ���ķ���� ������� ���� �߻�!');				
<%	}
	if(flag10 != 0){%>
	alert('�������ķ���� ������� ���� �߻�!');				
<%	}
	if(flag11 != 0){%>
	alert('����ķ���� ������� ���� �߻�!');				
<%	}%>


<%	if(mode.equals("8") && flag8 == 0 && from_page.equals("/acar/account/stat_settle_sc2.jsp")){%>
	fm.action = '<%=from_page%>';
<%	}else if(mode.equals("8") && flag8 == 0 && from_page.equals("/acar/account/stat_settle_sc3.jsp")){%>
	fm.action = '<%=from_page%>';
<%	}else if(mode.equals("8") && flag8 == 0 && from_page.equals("/acar/account/stat_settle_201103_sc2.jsp")){%>
	fm.action = '<%=from_page%>';
<%	}else if(mode.equals("8") && flag8 == 0 && from_page.equals("/acar/account/stat_settle_201103_sc3.jsp")){%>
	fm.action = '<%=from_page%>';
<%	}else if(mode.equals("9") && flag9 == 0 && from_page.equals("/acar/stat_month/campaign2011_5_sc2.jsp")){%>
	fm.action = '<%=from_page%>';
<%	}else if(mode.equals("9") && flag9 == 0 && from_page.equals("/acar/stat_month/campaign2011_5_sc3.jsp")){%>
	fm.action = '<%=from_page%>';
<%	}else if(mode.equals("30")){%>
	fm.action = '<%=from_page%>';
<%	}else if(mode.equals("9_1_201905") || mode.equals("9_2_201905")){%>
	fm.action = '<%=from_page%>'; 
<%	}else{%>
	fm.action = 'stat_end_sc.jsp';
<%	}%>
	
	fm.target = 'd_content';
	fm.submit();					

	
</script>
</body>
</html>