<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*, acar.res_search.*, tax.*" %>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*, acar.fee.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn"  class="acar.secondhand.ShResBean" scope="page"/>
<jsp:useBean id="rs_db" class="acar.res_search.ResSearchDatabase" scope="page"/>
<jsp:useBean id="cm_db" class="acar.coolmsg.CoolMsgDatabase" scope="page"/>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>

<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	CarRegDatabase 	crd = CarRegDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 				= request.getParameter("seq")==null?"":request.getParameter("seq");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String situation 		= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 			= request.getParameter("memo")==null?"":request.getParameter("memo");	
	String ret_dt 			= request.getParameter("ret_dt")==null?"":AddUtil.ChangeString(request.getParameter("ret_dt"));	
	String reg_dt 			= request.getParameter("reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("reg_dt"));	
	String gubun 			= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String sr_size 			= request.getParameter("sr_size")==null?"":request.getParameter("sr_size");
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");	
	String cust_tel 		= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String sms_add 		= request.getParameter("sms_add")==null?"":request.getParameter("sms_add");
	String sms_msg 		= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");   //��� �غ�  
	String reg_code		= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String sms_add2 		= request.getParameter("sms_add2")==null?"":request.getParameter("sms_add2");
	String sms_msg2 	= request.getParameter("sms_msg2")==null?"":request.getParameter("sms_msg2");
	String o_situation	= situation;
	String carName 		= request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String prevEstId		= request.getParameter("prevEstId")==null?"":request.getParameter("prevEstId");
	
	int result = 0;
	
	ShResBean srBn_chk = shDb.getShRes3(car_mng_id);	//����� ��ȸ
	
	UsersBean sender_bean = umd.getUsersBean(damdang_id);
	String send_phone = sender_bean.getHot_tel();
	
	if (!sender_bean.getLoan_st().equals("")) {
		send_phone = sender_bean.getUser_m_tel();
	}
	
	cr_bean = crd.getCarRegBean(car_mng_id);	
	
	//������ ���� 
	String parking_addr = ""; //������ ��ġ
	String parking_map = ""; //����
	
	String etc1 ="";
	String etc2 = ck_acar_id;
	
	if (sms_msg2.equals("��������")) {
		parking_addr = "����Ư���� ��õ�� �� 914-5 �Ѹ��� ���� ������(�������Ա� ���� 20m)\n TEL : 02-6263-6378";
	  	parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/yd.jpg";
	} else if (sms_msg2.equals("������������")) {
		parking_addr = "����� �������� �������� 34�� 9 ������ ����������\n TEL : 02-6263-6378";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg";
	} else if (sms_msg2.equals("�λ�������1")) {
    	parking_addr = "�λ�� ������ �ݼ۷� 69 �λ����� ����Ʈ���� 3��\n TEL : 051-851-0606";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_hite.jpg";
	} else if (sms_msg2.equals("�λ�������2")) {
    	parking_addr = "�λ�� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵������� \n TEL : 051-851-0606";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_wellmade.jpg";
	} else if (sms_msg2.equals("����������1")) {
		parking_addr = "������ ����� ��ź���� 319 ��ȣ�ڵ��������� 2��\n TEL : 042-824-1770";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_kh.jpg";
	} else if (sms_msg2.equals("����������2")) {
		parking_addr = "������ ����� ���ɱ� 100 (��)����ī��ũ 2��\n TEL : 042-824-1770";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg";				    
	} else if (sms_msg2.equals("�뱸������")) {
    	parking_addr = "�뱸�� �޼��� �޼����109�� 58 (��)��������������\n TEL : 053-582-2998";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg";
	} else if (sms_msg2.equals("����������")) {
    	parking_addr = "���ֽ� ���� �󹫴����� 131-1 ��1���ڵ���������\n TEL : 062-385-0133";
		parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg";
	}

	String a_gubun1 = "�縮��";										// ����	
	String customer_name = cust_nm;								// ���̸�
	String car_num = cr_bean.getCar_no();						// ������ȣ
	String manager_name = sender_bean.getUser_nm();	// ����� �̸�
	String manager_phone = send_phone;						// ����� ��ȭ
	String visit_place = parking_addr;								// �湮 ���
	String visit_place_url = "";										// �൵
	
	if (!parking_map.equals("")) {
		visit_place_url = ShortenUrlGoogle.getShortenUrl(parking_map); // �൵
	}
	
	if (from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")) {
		a_gubun1 = "����Ʈ";
	}

	if (gubun.equals("sms")) {
		//���Ȯ���� ������ ���ڹ߼�
		if ((!sms_msg.equals("") || !sms_msg2.equals("")) && !cust_nm.equals("") && !cust_tel.equals("") && AddUtil.lengthb(cust_tel) > 9) {
		
			if (!sms_msg2.equals("")) {
				if (sms_msg.equals("")) {
					List<String> fieldList = Arrays.asList(customer_name, a_gubun1, car_num, manager_name, manager_phone, visit_place, visit_place_url);
					at_db.sendMessageReserve("acar0225", fieldList, cust_tel, manager_phone, null, etc1, etc2);
				} else {
					//acar0034->acar0075->acar0205->acar0256
					List<String> fieldList = Arrays.asList(customer_name, manager_name, manager_phone, sms_msg, visit_place, visit_place_url);
					at_db.sendMessageReserve("acar0256", fieldList, cust_tel, manager_phone, null, etc1, etc2);
				}
			} else {
				//acar0066 �縮��/����Ʈ ���Ȯ�� �ȳ�
				List<String> fieldList = Arrays.asList(a_gubun1, customer_name, car_num, manager_name, manager_phone);
				at_db.sendMessageReserve("acar0066", fieldList, cust_tel, manager_phone, null, etc1, etc2);
			}
		}
	
	} else {
		  	
		//���ó���Ҷ� �̹� ��ϵȰ��� �ִٸ� ��������� ó��
		if (o_situation.equals("2") && srBn_chk.getSituation().equals("2")) {
			situation = "0";
		}

	  	//���� ������ ���
		if (!prevEstId.equals("") && prevEstId != null) {
		    String estId = Long.toString(System.currentTimeMillis());
		    int count = shDb.insertExistCustomerInfo(prevEstId, cust_nm, cust_tel, estId, carName); //prevEstId �� �� ������ ã�� esti_spe �� �־��ش�
		    int flag = shDb.insertSecondhandEstiInfo(estId, cust_nm, cust_tel, reg_code, car_mng_id);
		    int driverInsResult = shDb.insertExistDriverInfo(prevEstId,estId);
		    shBn.setEst_id(estId);
		    shBn.setReg_code(estId+"1");
		}
	  	
		shBn.setCar_mng_id(car_mng_id);
		shBn.setSeq(seq);
		shBn.setDamdang_id(damdang_id);
		shBn.setSituation(situation);
		shBn.setMemo(memo);
		shBn.setReg_dt(reg_dt);
		shBn.setCust_nm(cust_nm);
		shBn.setCust_tel(cust_tel);
	
		if (gubun.equals("i")) {
			result = shDb.shRes_i(shBn);
		} else if (gubun.equals("u")) {
			result = shDb.shRes_u(shBn);
		}
	
		//�������
		ShResBean srBn2 = shDb.getShRes(car_mng_id, damdang_id, reg_dt);
		
		//���Ȯ��
		if (situation.equals("2")) {
			
			if (AddUtil.parseInt(AddUtil.replace(reg_dt, "-", "")) > AddUtil.parseInt(AddUtil.replace(ret_dt, "-", ""))) {
				ret_dt = "";
			}
			
			//���Ȯ���� ������ ���ڹ߼�
			if (!cust_nm.equals("") && !cust_tel.equals("") && AddUtil.lengthb(cust_tel) > 9) {
				//��������
				String car_info = cr_bean.getCar_no()+"("+cr_bean.getCar_nm()+")";
								
				//����Ⱓ ������
				String res_start_date = AddUtil.ChangeDate2(srBn2.getReg_dt()); //��¥���� ����
				String res_start_day = AddUtil.getDateDay(srBn2.getReg_dt()); //��¥���� ����
				
				if (!ret_dt.equals("")) {
					srBn2.setReg_dt(ret_dt);
				}
				
				//1������+
				String res_end_dt_1 = af_db.getValidDt(c_db.addDay(srBn2.getReg_dt(), 1));
				//2������+
				String res_end_dt_2 = af_db.getValidDt(c_db.addDay(res_end_dt_1, 1));
				
				
				//����Ⱓ ������
				String res_end_date = AddUtil.ChangeDate2(res_end_dt_2); //��¥���� ����
				String res_end_day = AddUtil.getDateDay(res_end_dt_2); //��¥���� ����

				//�����ϰ� �������� ������ ����Ȯ�� ��ȿ�Ⱓ
				String expiry_date = res_start_date+"("+res_start_day+")"+"~"+res_end_date+"("+res_end_day+") 16:00����";
				
				if (!sms_msg2.equals("")) {
					if (sms_msg.equals("")) {
						if (a_gubun1.equals("�縮��")) {
							//�縮���� ����Ȯ�� ��ȿ�Ⱓ�߰��� �ű����ø� ���(�湮��� ����O)
							List<String> fieldList = Arrays.asList(customer_name, car_info, expiry_date, manager_name, manager_phone, visit_place, visit_place_url);
							at_db.sendMessageReserve("acar0226", fieldList, cust_tel, manager_phone, null, etc1, etc2);
						} else {							
							//acar0199 -> acar0225 �縮��/����Ʈ ���� �߰�
							List<String> fieldList = Arrays.asList(customer_name, a_gubun1, car_num, manager_name, manager_phone, visit_place, visit_place_url);
							at_db.sendMessageReserve("acar0225", fieldList, cust_tel, manager_phone, null, etc1, etc2);
						}
					} else {
						//acar0066 �縮��/����Ʈ ���Ȯ�� �ȳ� -> �縮���� acar0224�� ����(�湮��� ����X)
						if (a_gubun1.equals("�縮��")) {
							List<String> fieldList = Arrays.asList(customer_name, car_info, expiry_date, manager_name, manager_phone);
							at_db.sendMessageReserve("acar0224", fieldList, cust_tel, manager_phone, null, etc1, etc2);
						} else {
							List<String> fieldList = Arrays.asList(a_gubun1, customer_name, car_num, manager_name, manager_phone);
							at_db.sendMessageReserve("acar0066", fieldList, cust_tel, manager_phone, null, etc1, etc2);
						}
						//acar0034->acar0075->acar0205->acar0256
						List<String> fieldList2 = Arrays.asList(customer_name, manager_name, manager_phone, sms_msg, visit_place, visit_place_url);
						at_db.sendMessageReserve("acar0256", fieldList2, cust_tel, manager_phone, null, etc1, etc2);
					}
				} else {
					//acar0066 �縮��/����Ʈ ���Ȯ�� �ȳ� -> �縮���� acar0224�� ����
					if (a_gubun1.equals("�縮��")) {
						List<String> fieldList = Arrays.asList(customer_name, car_info, expiry_date, manager_name, manager_phone);
						at_db.sendMessageReserve("acar0224", fieldList, cust_tel, manager_phone, null, etc1, etc2);
					} else {
						List<String> fieldList = Arrays.asList(a_gubun1, customer_name, car_num, manager_name, manager_phone);
						at_db.sendMessageReserve("acar0066", fieldList, cust_tel, manager_phone, null, etc1, etc2);
					}
				}
			}
		}		
		
		if (ret_dt.equals("")) {
			ret_dt = srBn2.getReg_dt();
		}
		
		String d_flag1 = shDb.call_sp_sh_res_dire_dtset("i", car_mng_id, srBn2.getSeq(), ret_dt);

		//���Ȯ���� ��� ����ý��� ������ �ڵ���� �� �� ��� �Ű�����ڿ��� �޽��� �뺸
		if (gubun.equals("i") && situation.equals("2")) {
			//���� ����Ⱑ ������ ���ó��
			//������Ȳ
			Vector conts = rs_db.getResCarList(car_mng_id);
			int cont_size = conts.size();

			for (int i = 0 ; i < cont_size ; i++) {
				Hashtable reservs = (Hashtable)conts.elementAt(i);
				if (String.valueOf(reservs.get("RENT_ST")).equals("�����")) {	//String.valueOf(reservs.get("USE_ST")).equals("����") &&
					//�ܱ�뿩���� ����
					RentContBean rc_bean = rs_db.getRentContCase(String.valueOf(reservs.get("RENT_S_CD")), car_mng_id);
					rc_bean.setUse_st("5");
					int count = rs_db.updateRentCont(rc_bean);
				}
			}

			//�ܱ�뿩���� ���
			RentContBean rc_bean = new RentContBean();
			rc_bean.setCar_mng_id(car_mng_id);
			rc_bean.setRent_st("11");
			rc_bean.setRent_dt(reg_dt);
			rc_bean.setBrch_id(sender_bean.getBr_id());
			rc_bean.setBus_id(damdang_id);
			rc_bean.setRent_start_dt	(reg_dt+"0000");
			rc_bean.setEtc("�縮���������� ���Ȯ�� �ڵ�����, "+cust_nm+" "+cust_tel+" "+memo);
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
		
				if (!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")) {
					target_id = cs_bean.getWork_id();
				}
				
				if (!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")) {
					target_id = nm_db.getWorkAuthUser("�������");
				}
		
				//����� ���� ��ȸ
				UsersBean target_bean = umd.getUsersBean(target_id);
			
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
				System.out.println("��޽���[�縮���������� : �Ű��������� ���Ȯ�� �뺸 ] "+cr_bean.getCar_no()+"-----------------------"+target_bean.getUser_nm());			
			}
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
<%
	if (result >= 1) {
		if (gubun.equals("i")) {%>
			alert("��ϵǾ����ϴ�.");
			<%if (o_situation.equals("2") && srBn_chk.getSituation().equals("2")) {%>
			alert("���Ȯ������ ��ϵ� ���� �־� ��������� ����մϴ�.");
			<%}%>
	<%} else if (gubun.equals("u")) {%>
			alert("�����Ǿ����ϴ�.");
	<%}%>
			parent.opener.location.reload();
			parent.window.close();
<%} else {%>
	<%if (gubun.equals("sms")) {%>
			alert("ó���Ǿ����ϴ�.");
			window.close();
	<%} else {%>
			alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
			window.close();
	<%}%>
<%}%>
//-->
</script>
</body>
</html>