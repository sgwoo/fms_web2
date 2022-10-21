<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.res_search.*, tax.*" %>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn"  class="acar.secondhand.ShResBean" scope="page"/>
<jsp:useBean id="rs_db" class="acar.res_search.ResSearchDatabase" scope="page"/>
<jsp:useBean id="cm_db" class="acar.coolmsg.CoolMsgDatabase" scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>


<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	CarSchDatabase csd 		= CarSchDatabase.getInstance();
	CarRegDatabase 	crd 		= CarRegDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String situation 		= request.getParameter("situation")==null?"":request.getParameter("situation");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String reg_dt 			= request.getParameter("shres_reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("shres_reg_dt"));
	String seq 				= request.getParameter("shres_seq")==null?"":request.getParameter("shres_seq");	
	String cust_nm 		= request.getParameter("shres_cust_nm")==null?"":request.getParameter("shres_cust_nm");	
	String cust_tel 		= request.getParameter("shres_cust_tel")==null?"":request.getParameter("shres_cust_tel");		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String ret_dt 			= request.getParameter("ret_dt")==null?"":AddUtil.ChangeString(request.getParameter("ret_dt"));
	String car_name 		= request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String sms_msg 		= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");
	String sms_msg2 	= request.getParameter("sms_msg2")==null?"":request.getParameter("sms_msg2");
	
	if (AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) > AddUtil.parseInt(AddUtil.replace(ret_dt,"-",""))) {
		ret_dt = AddUtil.getDate();
	}
	
	int result = 0;
	boolean flag5 = true;
	
	result = shDb.shRes_2cng(car_mng_id, seq);
	
	//�����ȯ
	String d_flag1 = shDb.call_sp_sh_res_dire_dtset("i", car_mng_id, seq, ret_dt);
	
	if (damdang_id.equals("")) {
		damdang_id = user_id;
	}

	UsersBean sender_bean = umd.getUsersBean(damdang_id);
	String send_phone = sender_bean.getHot_tel();
	if (!sender_bean.getLoan_st().equals("")) {
		send_phone = sender_bean.getUser_m_tel();
	}
	
	UsersBean target_bean = new UsersBean();
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	shBn = shDb.getShRes(car_mng_id, seq); //��� Ȯ���� ��������
	
	String alim_type = "";
	String etc1 = "";
	String etc2 = ck_acar_id ;
	
	//���Ȯ���� ������ ���ڹ߼�
	if (!cust_nm.equals("") && !cust_tel.equals("") && AddUtil.lengthb(cust_tel) > 9) {

		String a_gubun1 = "�縮��";										// ����
		String customer_name = cust_nm;								// ���̸�
		String car_num = cr_bean.getCar_no();						// ������ȣ
		String manager_name = sender_bean.getUser_nm();	// ����� �̸�
		String manager_phone = sender_bean.getHot_tel();	 	// ����� ��ȭ
		if (!sender_bean.getLoan_st().equals("")) {
			manager_phone = sender_bean.getUser_m_tel();
		}

		alim_type = "sh";
		if (from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")) {
			alim_type = "mf";
		  	a_gubun1 = "����Ʈ";
		} else if (from_page.equals("/acar/estimate_mng/esti_spe_hp_i.jsp")) {
		  	alim_type = "ma";
		}
	
		if (alim_type.equals("sh") || alim_type.equals("mf")) {
			// acar0066 �縮��/����Ʈ ���Ȯ�� �ȳ� -> �縮���� acar0224�� ����
			if (a_gubun1.equals("�縮��")) {
				//��������
				String car_info = cr_bean.getCar_no()+"("+cr_bean.getCar_nm()+")";
				//����Ⱓ ������
				String res_start_dt = AddUtil.ChangeDate2(shBn.getRes_st_dt()); //��¥���� ����
				String res_start_day = AddUtil.getDateDay(shBn.getRes_st_dt()); //��¥���� ����
				//����Ⱓ ������
				String res_end_dt = AddUtil.ChangeDate2(shBn.getRes_end_dt()); //��¥���� ����
				String res_end_day = AddUtil.getDateDay(shBn.getRes_end_dt()); //��¥���� ����
				//��¥
				String expiry_date = res_start_dt+"("+res_start_day+")"+"~"+res_end_dt+"("+res_end_day+") 16:00����";
				
				List<String> fieldList = Arrays.asList(customer_name, car_info, expiry_date, manager_name, manager_phone);
				at_db.sendMessageReserve("acar0224", fieldList, cust_tel, manager_phone, null,  etc1, etc2);
			} else {
				List<String> fieldList = Arrays.asList(a_gubun1, customer_name, car_num, manager_name, manager_phone);
				at_db.sendMessageReserve("acar0066", fieldList, cust_tel, manager_phone, null,  etc1, etc2);
			}
	  	} else {
			//acar0041->acar0079->acar0202 ����Ʈ ����Ȯ�� �ȳ�
			String contract_supp = sms_msg; // ��� �غ�
			String visit_place = ""; // �湮 ���
			String visit_place_url = ""; // �൵
			if (sms_msg2.equals("seoul1")) {
				visit_place = "����� ��õ�� �� 914-5 �Ѹ��� ���� ������(�������Ա� ���� 20m)\n TEL: 02-6263-6378";
				visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/yd.jpg");
			} else if(sms_msg2.equals("seoul")) {
				visit_place = "����� �������� �������� 34�� 9 ������ ����������\n TEL: 02-6263-6378";
				visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg");
			} else if(sms_msg2.equals("busan1")) {
				visit_place = "�λ�� ������ �ݼ۷� 69 �λ����� ����Ʈ���� 3��\n TEL: 051-851-0606";
				visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_p_hite.jpg");
			} else if(sms_msg2.equals("busan2")) {
				visit_place = "�λ�� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵������� \n TEL: 051-851-0606";
				visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_p_wellmade.jpg");
			} else if(sms_msg2.equals("daejeon1")) {
				visit_place = "������ ����� ��ź���� 319 ��ȣ�ڵ��������� 2��\n TEL: 042-824-1770";
				visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_dj_kh.jpg");
			} else if(sms_msg2.equals("daejeon2")) {
				visit_place = "������ ����� ���ɱ� 100 (��)����ī��ũ 2��\n TEL: 042-824-1770";
				visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg");
			} else if(sms_msg2.equals("daegu")) {
				visit_place = "�뱸�� �޼��� �޼����109�� 58 (��)��������������\n TEL: 053-582-2998";
				visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg");
			} else if(sms_msg2.equals("kwangju")) {
				visit_place = "���ֽ� ���� �󹫴����� 131-1 ��1���ڵ���������\n TEL: 062-385-0133";
				visit_place_url = ShortenUrlGoogle.getShortenUrl("http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg");
			}
			//acar0041->acar0079->acar0202
			List<String> fieldList = Arrays.asList(customer_name, car_num, manager_name, manager_phone, contract_supp, visit_place, visit_place_url);
			at_db.sendMessageReserve("acar0202", fieldList, cust_tel, manager_phone, null,  etc1, etc2 );
		}
	}
	
	//���Ȯ���� ��� ����ý��� ������ �ڵ���� �� ����������ڿ��� �޽��� �뺸

	//�ܱ�뿩���� ���
	RentContBean rc_bean = new RentContBean();
	rc_bean.setCar_mng_id(car_mng_id);
	rc_bean.setRent_st("11");
	rc_bean.setRent_dt(reg_dt);
	rc_bean.setBrch_id(sender_bean.getBr_id());
	rc_bean.setBus_id(damdang_id);
	rc_bean.setRent_start_dt(reg_dt+"0000");
	rc_bean.setEtc("�縮���������� ���Ȯ�� �ڵ�����");
	rc_bean.setDeli_plan_dt(reg_dt+"0000");
	rc_bean.setUse_st("1");
	rc_bean.setReg_id(damdang_id);
	rc_bean = rs_db.insertRentCont(rc_bean);		
	
	if (cr_bean.getOff_ls().equals("1")) {
	
		//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
	
		boolean flag3 = true;
		String sub = "�Ű��������� ���Ȯ�� �뺸";
		String cont = "�Ű����������� ���Ȯ���� �Ǿ����ϴ�.  &lt;br&gt; &lt;br&gt; "+cr_bean.getCar_no()+", "+rc_bean.getEtc();
		String target_id = nm_db.getWorkAuthUser("��������");
	
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
	
		if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")) {
			target_id = cs_bean.getWork_id();
		}
		
		if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")) {
			target_id = nm_db.getWorkAuthUser("�������");
		}

		//����� ���� ��ȸ
		target_bean = umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
 					"    <BACKIMG>4</BACKIMG>"+
 					"    <MSGTYPE>104</MSGTYPE>"+
 					"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
					"    <URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
 					"    <MSGICON>10</MSGICON>"+
 					"    <MSGSAVE>1</MSGSAVE>"+
 					"    <LEAVEDMSG>1</LEAVEDMSG>"+
  				"    <FLDTYPE>1</FLDTYPE>"+
 					"  </ALERTMSG>"+
 					"</COOLMSG>";
	
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
	
		flag3 = cm_db.insertCoolMsg(msg);
		System.out.println("��޽���[�縮���������� : �Ű��������� ���Ȯ�� �뺸] "+cr_bean.getCar_no()+"-----------------------"+target_bean.getUser_nm());
	
	}	
		
	//��������ڵ鿡�� ���Ȯ�� �뺸
	Vector sr = shDb.getShResList(car_mng_id);
	int sr_size = sr.size();
	
	for (int i = 0 ; i < sr_size ; i++) {
		Hashtable sr_ht = (Hashtable)sr.elementAt(i);
		if (String.valueOf(sr_ht.get("SITUATION")).equals("0") && !String.valueOf(sr_ht.get("SEQ")).equals(seq)) {
			
			String customer_nm = String.valueOf(sr_ht.get("CUST_NM"));
			if (customer_nm.equals("")) {
				customer_nm = "����";
			}
			
			String customer_num = String.valueOf(sr_ht.get("CUST_TEL"));
			if (customer_num.equals("")) {
				customer_num = "����";
			}
			
			String customer_memo = String.valueOf(sr_ht.get("MEMO"));			
			if (customer_memo.equals("")) {
				customer_memo = "����";
			}
			
			//����� ���� ��ȸ
			target_bean = umd.getUsersBean(String.valueOf(sr_ht.get("DAMDANG_ID")));
		
			String xml_data1 = "";
			xml_data1 =  "<COOLMSG>"+
	  					"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>�縮�� 1���� ����� ���Ȯ��ó��</SUB>"+
		  					"<CONT>"+
							"�縮�� 1���� ����ڰ� ���Ȯ��ó���Ͽ����ϴ�.  &lt;br&gt; &lt;br&gt; ������ȣ: "+cr_bean.getCar_no()+
							" &lt;br&gt; &lt;br&gt;  ��ȣ : "+customer_nm+
							" &lt;br&gt; &lt;br&gt;  ����ó : "+customer_num+
							" &lt;br&gt; &lt;br&gt; �޸� : "+customer_memo+
							"</CONT>"+
 						"    <URL></URL>";
			xml_data1 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data1 += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
	  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			/* 
			xml_data1 =  "<COOLMSG>"+
  					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>�縮�� 1���� ����� ���Ȯ��ó��</SUB>"+
	  				"    <CONT>�縮�� 1���� ����ڰ� ���Ȯ��ó���Ͽ����ϴ�. : "+cr_bean.getCar_no()+"</CONT>"+
						"    <URL></URL>";
			xml_data1 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data1 += "    <SENDER></SENDER>"+
						"    <MSGICON>10</MSGICON>"+
						"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
						"  </ALERTMSG>"+
						"</COOLMSG>"; 
			*/
			
			CdAlertBean msg1 = new CdAlertBean();
			msg1.setFlddata(xml_data1);
			msg1.setFldtype("1");
		
			flag5 = cm_db.insertCoolMsg(msg1);	
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
