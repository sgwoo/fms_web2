<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.user_mng.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>


<% 
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String acar_id = request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");	
	String mail_st = request.getParameter("mail_st")==null?"":request.getParameter("mail_st");	
	String opt_chk = request.getParameter("opt_chk")==null?"0":request.getParameter("opt_chk");	
	String fee_opt_amt = request.getParameter("fee_opt_amt")==null?"0":request.getParameter("fee_opt_amt");
	String content_st = request.getParameter("content_st")==null?"":request.getParameter("content_st");	
	String reg_id = request.getParameter("write_id")==null?"":request.getParameter("write_id");
	String est_m_tel = request.getParameter("est_m_tel")==null?"":request.getParameter("est_m_tel");	
	String sms_cont2	= request.getParameter("sms_cont2")==null?"":request.getParameter("sms_cont2");
	String est_nm	= request.getParameter("est_nm")	==null?"":request.getParameter("est_nm");
	String u_nm = request.getParameter("u_nm")==null?"":request.getParameter("u_nm");
	String u_mt = request.getParameter("u_mt")==null?"":request.getParameter("u_mt");	
	String sms1_yn = request.getParameter("sms1_yn")==null?"":request.getParameter("sms1_yn");
	String sms2_yn = request.getParameter("sms2_yn")==null?"":request.getParameter("sms2_yn");		
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String user_m_tel = request.getParameter("user_m_tel")==null?"":request.getParameter("user_m_tel");	
	String manager_id = request.getParameter("manager_id")==null?"":request.getParameter("manager_id");	
	String manager_nm 	= request.getParameter("manager_nm")==null?"":request.getParameter("manager_nm");	
	String manager_use	= request.getParameter("manager_use")==null?"":request.getParameter("manager_use");
	
	LoginBean login = LoginBean.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String manager_num = login.getUser_m_tel(manager_id);
	
	if (manager_num == null) {
		manager_num = "02-392-4243";
	}
	
	String select_sms 	= request.getParameter("select_sms")==null?"":request.getParameter("select_sms"); // �������������� ����Ʈ ���ð��� (���߼��ð� ���� ����)	
	
	EstiDatabase e_db = EstiDatabase.getInstance();

	bean = e_db.getEstimateCase(est_id);
	
	if(sms1_yn.equals("Y")){	
		//�˸��� acar0042 ������ �߼� �˸�
		String customer_name 	= est_nm;				// ���̸�
		String esti_send_way 	= sms_cont2;		// �������߼�
		String manager_name 	= u_nm;					// ����� �̸�
		String manager_phone 	= u_mt;					// ����� ��ȭ
		if(sms_cont2.equals("�ѽ�") && !bean.getEst_fax().equals("")   && bean.getEst_fax().length()   >6) 	esti_send_way = esti_send_way + "("+bean.getEst_fax()+")";
		if(sms_cont2.equals("����") && !bean.getEst_email().equals("") && bean.getEst_email().length() >4) 	esti_send_way = esti_send_way + "("+bean.getEst_email()+")";
		//acar0042 -> acar0072 ��������
		List<String> fieldList = Arrays.asList(customer_name, esti_send_way, manager_name, manager_phone);
		at_db.sendMessageReserve("acar0072", fieldList, est_m_tel,  u_mt, null , "",  acar_id);			
	}
		
	if(sms2_yn.equals("Y")){	
		//�˸��� acar0057 ������ �߼� �˸�
		String a_car_name 		= request.getParameter("a_car_name")==null?"":request.getParameter("a_car_name");					// �����̸�
		String a_car_amount 	= request.getParameter("a_car_amount")==null?"":request.getParameter("a_car_amount");								// ��������
		String a_gubun1 			= request.getParameter("a_gubun1")==null?"":request.getParameter("a_gubun1");			// ����1
		String a_gubun2 			= request.getParameter("a_gubun2")==null?"":request.getParameter("a_gubun2");			// ����2
		String a_month 			= bean.getA_b();		// ����
		String a_deposit_rate = String.valueOf(bean.getRg_8());		// ��������
		String a_distance 		= AddUtil.parseDecimal(bean.getAgree_dist());		// ��������Ÿ�
		String a_rent_fee 		= AddUtil.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt());		// ���뿩��
		String a_esti_link 		= request.getParameter("a_url")==null?"":request.getParameter("a_url");			// ����������
		String manager_name 	= u_nm;					// ����� �̸�
		String manager_phone 	= u_mt;					// ����� ��ȭ
		//acar0064->acar0073
		List<String> fieldList = Arrays.asList(a_car_name, a_car_amount, a_gubun1, a_gubun2, a_month, a_deposit_rate, a_distance, a_rent_fee, a_esti_link, manager_name, manager_phone);
		at_db.sendMessageReserve("acar0073", fieldList, est_m_tel,  u_mt, null , "",  acar_id);			
	}
	
	if (select_sms.equals("select_sms")) {
		
		String temp_est_id[]			= request.getParameterValues("a_est_id");
		String temp_car_name[] 		= request.getParameterValues("car_name");			// �����̸�
		String temp_car_amount[] 		= request.getParameterValues("car_amount"); 	// ��������
		String temp_gubun1[] 			= request.getParameterValues("gubun1");			 	// ����1 (����/ ����)
		String temp_gubun2[] 			= request.getParameterValues("gubun2"); 				// ����2 (�Ϲݽ�/ �⺻��)
		String temp_month[] 				= request.getParameterValues("month"); 			// �뿩�Ⱓ
		String temp_deposit_rate[] 	= request.getParameterValues("deposit_rate"); 		// ������
		String temp_distance[] 		= request.getParameterValues("distance"); 			// ����Ÿ�
		String temp_rent_fee[] 		= request.getParameterValues("rent_fee"); 			// ���뿩��
		String temp_esti_link[] 		= request.getParameterValues("esti_link"); 			// ������ ��ũ
		String temp_content_st[] 		= request.getParameterValues("content_st"); 			// ȭ�鱸��
				
		List<String> fieldList = new ArrayList<String>();
		
		for (int i = 0; i < temp_est_id.length; i++) {
			String select_est_id	= temp_est_id[i];
			String car_name 		= temp_car_name[i];
			String car_amount 	= AddUtil.parseDecimal(temp_car_amount[i]);
			String gubun1 		= temp_gubun1[i];
			String gubun2 		= temp_gubun2[i];
			String month 			= temp_month[i];
			String deposit_rate 	= temp_deposit_rate[i];
			String distance 		= AddUtil.parseDecimal(temp_distance[i]);
			String rent_fee 		= AddUtil.parseDecimal(temp_rent_fee[i]);
			String esti_link 		= temp_esti_link[i];
			String content_st_a	= temp_content_st[i];
			
			//��������
			EstimateBean e_bean = new EstimateBean();
			
			e_bean = e_db.getEstimateCase(select_est_id);
			/* if(content_st_a.equals("sh_fms") || content_st_a.equals("sh_fms_ym")){
			}else{
				e_bean = e_db.getEstimateShCase(select_est_id);
			} */
			
			if (e_bean.getEst_st().equals("1")) {
				if (e_bean.getA_a().equals("11")||e_bean.getA_a().equals("12")) {
					gubun1 += "(�縮��)";
				} else {
					gubun1 += "(�緻Ʈ)";
				}
			} else if (e_bean.getEst_st().equals("2")) {
				gubun1 += "(����)";
			} else if (e_bean.getEst_st().equals("3")) {
				gubun1 += "(�߰��� ����)";
			}
			
			fieldList.add(car_name);
			fieldList.add(car_amount);
			fieldList.add(gubun1);
			fieldList.add(gubun2);
			fieldList.add(month);
			fieldList.add(deposit_rate);
			fieldList.add(distance);
			fieldList.add(rent_fee);
			fieldList.add(esti_link);
		}
		
		if (manager_use.equals("N")) {
			fieldList.add("");
			fieldList.add("");
		} else {
			fieldList.add(manager_nm);
			fieldList.add(manager_num);
		}
		
		if (temp_est_id.length == 1) {			
			at_db.sendMessageReserve("acar0073", fieldList, est_m_tel, manager_num, null, manager_nm, manager_id);			
		} else if (temp_est_id.length == 2) {			
			at_db.sendMessageReserve("acar0147", fieldList, est_m_tel, manager_num, null, manager_nm, manager_id);			
		} else if (temp_est_id.length == 3) {			
			at_db.sendMessageReserve("acar0148", fieldList, est_m_tel, manager_num, null, manager_nm, manager_id);			
		} else if (temp_est_id.length == 4) {			
			at_db.sendMessageReserve("acar0149", fieldList, est_m_tel, manager_num, null, manager_nm, manager_id);			
		} else if (temp_est_id.length == 5) {			
			at_db.sendMessageReserve("acar0150", fieldList, est_m_tel, manager_num, null, manager_nm, manager_id);			
		}
		
		/* for (int i = 0; i < temp_est_id.length; i++) {
			String select_est_id	= temp_est_id[i];
			String car_name 		= temp_car_name[i];
			String car_amount 	= AddUtil.parseDecimal(temp_car_amount[i]);
			String gubun1 			= temp_gubun1[i];
			String gubun2 			= temp_gubun2[i];
			String month 			= temp_month[i];
			String deposit_rate 	= temp_deposit_rate[i];
			String distance 			= AddUtil.parseDecimal(temp_distance[i]);
			String rent_fee 			= AddUtil.parseDecimal(temp_rent_fee[i]);
			String esti_link 			= temp_esti_link[i];
			
			String manager_name 	= u_nm;					// ����� �̸�
			String manager_phone 	= u_mt;					// ����� ��ȭ
			
			List<String> fieldList = Arrays.asList(car_name, car_amount, gubun1, gubun2, month, deposit_rate, distance, rent_fee, esti_link, manager_name, manager_phone);
			at_db.sendMessageReserve("acar0073", fieldList, est_m_tel, "02-392-4243", null, "", select_est_id);
		} */
	}
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
<script language="JavaScript">
<!--
	<%if (select_sms.equals("select_sms")) {%>
			alert("���ڰ� ���������� �߼� �Ǿ����ϴ�.");
	<%} else {%>
			alert("������ ���������� �߼� �Ǿ����ϴ�.");
	<%}%>
	parent.window.close();
//-->
</script>
</body>
</html>




