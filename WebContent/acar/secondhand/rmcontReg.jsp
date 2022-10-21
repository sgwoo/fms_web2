<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.res_search.*, tax.*" %>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.car_register.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn"  class="acar.secondhand.ShResBean" scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	CarRegDatabase 	crd 	= CarRegDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String reg_dt 		= request.getParameter("shres_reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("shres_reg_dt"));
	String seq 		= request.getParameter("shres_seq")==null?"":request.getParameter("shres_seq");	
	String cust_nm 		= request.getParameter("shres_cust_nm")==null?"":request.getParameter("shres_cust_nm");	
	String cust_tel 	= request.getParameter("shres_cust_tel")==null?"":request.getParameter("shres_cust_tel");		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String ret_dt 		= request.getParameter("ret_dt")==null?"":AddUtil.ChangeString(request.getParameter("ret_dt"));
	String car_name		= request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String sms_msg		= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");
	String sms_msg2		= request.getParameter("sms_msg2")==null?"":request.getParameter("sms_msg2");
	
	int result = 0;
	boolean flag5 = true;

	
	//����Ʈ��࿬��
	String  d_flag1 =  shDb.call_sp_sh_res_rm_cont_reg(car_mng_id, seq);
	
	
	
	if(damdang_id.equals("")) damdang_id = user_id;
	
	UsersBean sender_bean 	= umd.getUsersBean(damdang_id);
	
	UsersBean target_bean 	= new UsersBean();
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	shBn = shDb.getShRes(car_mng_id, seq); //��� Ȯ���� ��������
	
	cust_nm 	= shBn.getCust_nm();
	cust_tel 	= shBn.getCust_tel();
					
	
		//���Ȯ���� ������ ���ڹ߼�
		if(!cust_nm.equals("") && !cust_tel.equals("") && AddUtil.lengthb(cust_tel) > 9){
				
				// jjlim add alimtalk
				// acar0039 ����Ʈ ���Ȯ�� �ȳ�
				String customer_name = cust_nm;								// ���̸�
				String car_num = cr_bean.getCar_no();						// ������ȣ
				String car_take_date_mn = "";								// �μ���¥ (��/��)
				String end_date = shBn.getRes_end_dt();				
				String etc1 = "";
				String etc2 = ck_acar_id;
				if (!end_date.equals("") && end_date != null) {
					int month = Integer.parseInt(end_date.substring(4,6));
					int day = Integer.parseInt(end_date.substring(6,8));
					car_take_date_mn = month + "�� " + day + "��";
				} else {
					car_take_date_mn = "������ ���� ����";
				}
				String manager_name = sender_bean.getUser_nm();				// ����� �̸�
				String manager_phone = sender_bean.getUser_m_tel();			// ����� ��ȭ
				if(!sender_bean.getHot_tel().equals("")){
					manager_phone = sender_bean.getHot_tel();
				}
				String contract_supp = sms_msg;						// ��� �غ�
				String visit_place = "";									// �湮 ���
				String visit_place_url = "";
				// �൵
				if(sms_msg2.equals("seoul1")){
					visit_place = "����� ��õ�� �� 914-5 �Ѹ��� ���� ������(�������Ա� ���� 20m)\n TEL: 02-6263-6378";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/yd.jpg");
	
				}else if(sms_msg2.equals("seoul")){
					visit_place = "����� �������� �������� 34�� 9 ������ ����������\n TEL: 02-6263-6378";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg");
	
				}else if(sms_msg2.equals("busan1")){
					visit_place = "�λ�� ������ �ݼ۷� 69 �λ����� ����Ʈ���� 3��\n TEL: 051-851-0606";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_p_hite.jpg");
	
				}else if(sms_msg2.equals("busan2")){
					visit_place = "�λ�� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵������� \n TEL: 051-851-0606";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_p_wellmade.jpg");
	
				}else if(sms_msg2.equals("daejeon1")){
					visit_place = "������ ����� ��ź���� 319 ��ȣ�ڵ��������� 2��\n TEL: 042-824-1770";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_dj_kh.jpg");
	
				}else if(sms_msg2.equals("daejeon2")){
					visit_place = "������ ����� ���ɱ� 100 (��)����ī��ũ 2��\n TEL: 042-824-1770";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg");
	
				}else if(sms_msg2.equals("daegu")){
					visit_place = "�뱸�� �޼��� �޼����109�� 58 (��)��������������\n TEL: 053-582-2998";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg");
	
				}else if(sms_msg2.equals("kwangju")){
					visit_place = "���ֽ� ���� �󹫴����� 131-1 ��1���ڵ���������\n TEL: 062-385-0133";
					visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg");
				}
				//acar0039->acar0077->acar0201->acar0255
				List<String> fieldList = Arrays.asList(customer_name, car_num, car_take_date_mn, manager_name, manager_phone, contract_supp, visit_place, visit_place_url);
				at_db.sendMessageReserve("acar0255", fieldList, cust_tel,  manager_phone, null , etc1,  etc2);
		
		}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--

<%if(d_flag1.equals("0")){%>
	alert("��ϵǾ����ϴ�.");
	parent.location.reload();
<%	}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
<%	}%>
//-->
</script>
</body>
</html>
