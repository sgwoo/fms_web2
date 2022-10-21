<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.cont.*, tax.*, acar.user_mng.*, acar.car_register.*, acar.car_mst.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 		= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	
	String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
	String sendphone	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
	String destphone	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String msg 			= request.getParameter("msg")==null?"":request.getParameter("msg");
	String msglen 		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
	String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
	String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
	String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
	String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
	String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");
	String bond_msg_type 	= request.getParameter("bond_msg_type")==null?"":request.getParameter("bond_msg_type");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mng_send 	= request.getParameter("mng_send")==null?"":request.getParameter("mng_send");
	
	String customer_name 	= request.getParameter("customer_name")==null?"":request.getParameter("customer_name");
	String cur_date 	= request.getParameter("cur_date")==null?"":request.getParameter("cur_date");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String car_count 	= request.getParameter("car_count")==null?"0":request.getParameter("car_count");
	String car_num_name_count 	= request.getParameter("car_num_name_count")==null?"":request.getParameter("car_num_name_count");
	String short_url 	= request.getParameter("short_url")==null?"":request.getParameter("short_url");
	String unpaid 		= request.getParameter("unpaid")==null?"":request.getParameter("unpaid");
	String bank_full 	= request.getParameter("bank_full")==null?"":request.getParameter("bank_full");
	
	String manager_name 	= request.getParameter("manager_name")==null?"":request.getParameter("manager_name");
	String manager_phone 	= request.getParameter("manager_phone")==null?"":request.getParameter("manager_phone");
	
	String destphone_multi 	= request.getParameter("destphone_multi")==null?"":request.getParameter("destphone_multi");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));	
	
	Hashtable insur = a_db.getInsurOfCont(l_cd, m_id);
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	String url1 = "http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+r_st+"";
	String url2 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_accident.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
	
	if(destphone_multi.equals("")){
		destphone_multi = destphone;
	}
	
	if(!destphone_multi.equals("")){
		     	
	     	// jjlim add alimtalk				
			String insur_mng_name = String.valueOf(insur.get("USER_NM"));			// ���ó�� �����  
			String insur_mng_pos =String.valueOf(insur.get("USER_POS"));			// ���ó�� ����� ���� 
			String insur_mng_phone =String.valueOf(insur.get("USER_M_TEL"));		// ���ó�� ����� ��ȭ 
			String insurance_name = String.valueOf(insur.get("INS_COM_NM"));		// ���ó�� �����
			String insurance_phone = String.valueOf(insur.get("INS_TEL"));			// ���ó�� ����� ��ȭ
			
			UsersBean user_bean = umd.getUsersBean(String.valueOf(insur.get("MNG_ID")));
			UsersBean sener_user_bean = umd.getUsersBean(ck_acar_id);
			
			insur_mng_pos =user_bean.getUser_pos();		// ���ó�� ����� ���� 
			
			String etc1 = l_cd;
			String etc2 = ck_acar_id;
			String sos_service_info = "����Ÿ�ڵ��� (1588-6688)";												// ����⵿
			String car_service_info = "���ǵ����Ʈ (https://www.speedmate.com/shop_search/shop_search.do)";	// �����ü
			String marster_car_num = "1588-6688"; //������ �ڵ��� ����ó
			String sk_net_num = "1670-5494"; //sk��Ʈ���� ����ó
			String sk_net_info = "sk��Ʈ���� (1670-5494)"; //sk��Ʈ���� ����ó
			String insur_info_url = ShortenUrlGoogle.getShortenUrl(url1);
			String accident_url = ShortenUrlGoogle.getShortenUrl(url2);
			
			//���Ź�ȣ ��Ƽ
			int s=0; 
			String app_value[] = new String[20];	
			StringTokenizer st = new StringTokenizer(destphone_multi,"////");				
			while(st.hasMoreTokens()){
				app_value[s] = st.nextToken();
				out.println(app_value[s]);
				s++;				
			}	
			
			
			//�߽��ڹ�ȣ
			if (sendphone.equals("")) {
				sendphone = sener_user_bean.getUser_m_tel();
			}
			
				
			if ( msg_subject.equals("[�Ƹ���ī ���ó�� �ȳ�]") ) {
				//acar0037 -> acar0090 (��������) -> acar0111 (�ִ�ī����) -> acar0174 (sk��Ʈ�����߰�) -> acar0218 -> acar0233 ���� �� �Ķ���� ��������
				List<String> fieldList = Arrays.asList(firm_nm, cr_bean.getCar_no(), insurance_name, insurance_phone, marster_car_num, sk_net_num, insur_mng_name, insur_mng_phone, accident_url);
				//��
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];
					at_db.sendMessageReserve("acar0233", fieldList, destphone, sendphone, null , etc1,  etc2);		 
				}
				//�����	
				for(int j=0 ; j < 1 ; j++){
					destphone = app_value[j];
					if (mng_send.equals("Y")) {
						List<String> fieldList2 = Arrays.asList(firm_nm+"("+destphone+")", cr_bean.getCar_no(), insurance_name, insurance_phone, marster_car_num, sk_net_num, insur_mng_name, insur_mng_phone, accident_url);
						if (  !sener_user_bean.getUser_m_tel().equals(user_bean.getUser_m_tel()) )	{
							at_db.sendMessageReserve("acar0233", fieldList2, user_bean.getUser_m_tel(), sener_user_bean.getUser_m_tel(), null , etc1,  etc2);				 	 
						}
					}
				}	
			}else if ( msg_subject.equals("[�Ƹ���ī �������� �� ���ó�� �ȳ�]") ) {
				//acar0089
				List<String> fieldList = Arrays.asList(insurance_name, insurance_name, insurance_phone, insur_mng_name, insur_mng_pos, insur_mng_phone, firm_nm, cr_bean.getCar_no(), cm_bean.getCar_nm()+" "+cm_bean.getCar_name(), insur_info_url, sener_user_bean.getUser_nm(), sener_user_bean.getUser_pos(), sener_user_bean.getUser_m_tel());
				//��
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];
					at_db.sendMessageReserve("acar0089", fieldList, destphone, sendphone , null , etc1,  etc2);			
				}	
				//����� 
				for(int j=0 ; j < 1 ; j++){
					destphone = app_value[j];
					if (mng_send.equals("Y")) {
						List<String> fieldList2 = Arrays.asList(insurance_name, insurance_name, insurance_phone, insur_mng_name, insur_mng_pos, insur_mng_phone, firm_nm+"("+destphone+")", cr_bean.getCar_no(), cm_bean.getCar_nm()+" "+cm_bean.getCar_name(), insur_info_url, sener_user_bean.getUser_nm(), sener_user_bean.getUser_pos(), sener_user_bean.getUser_m_tel());
						if (  !sener_user_bean.getUser_m_tel().equals(user_bean.getUser_m_tel()) ) {
							at_db.sendMessageReserve("acar0089", fieldList2, user_bean.getUser_m_tel(), sener_user_bean.getUser_m_tel() , null , etc1,  etc2);			
						}
					}
				}	
			}else if ( msg_subject.equals("[����(�Ϲݽ�) �ȳ�]") ) {
				//acar0114->acar0204
				List<String> fieldList = Arrays.asList(firm_nm, cr_bean.getCar_no(), car_service_info, insur_mng_name, insur_mng_phone);
				//��
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];	
					at_db.sendMessageReserve("acar0204", fieldList, destphone, sendphone , null , etc1,  etc2);
				}	
			} else if ( msg_subject.equals("[�Ƹ���ī ����Ʈ �ȳ�]") ) {
					
				//�����⺻����
				ContCarBean f_fee_etc = a_db.getContFeeEtc(m_id, l_cd, "1");
  				
			 	//������
				ClientBean client = al_db.getNewClient(insur.get("CLIENT_ID")+"");
			   
			   	//���ΰ�����������
				Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "");
				int mgr_size = car_mgrs.size();
				String f_person = "";
			    String s_person = "";
			    for(int i = 0 ; i < mgr_size ; i++){
			        CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
			       	if(mgr.getMgr_st().equals("�߰��̿���") || mgr.getMgr_st().equals("�߰�������")){
			        		s_person =mgr.getMgr_nm();
			       	}
			   	} 
     
				String dist = AddUtil.parseDecimal(f_fee_etc.getAgree_dist());			// ����Ÿ�
				String dist_fee = AddUtil.parseDecimal(f_fee_etc.getOver_run_amt());	// ����Ÿ� �ʰ� ���
				String driver = String.valueOf(client.getClient_nm()) + " ";			// ������
				String driver2 = s_person + " ���� ";			// �߰�������
			
				if(!s_person.equals("")){
					//driver += ", " + s_person + " ��";
				}else{
					driver2 = "����";
				}
				
				String visit_place = null;												// �ݳ����
				String return_place = null;												// �൵
				String parking_map = "";													// �൵
				if ((insur.get("BR_ID")+"").equals("D1")) {
					visit_place = "����ī��ũ 2�� (042-824-1770)\n������ ����� ���ɱ� 100";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg";
					parking_map = "http://kko.to/5kTS9j74J";
				}
				else if ((insur.get("BR_ID")+"").equals("G1")) {
					visit_place = "�������������� (053-582-2998)\n�뱸�� �޼��� �޼����109�� 58";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg";
					parking_map = "http://kko.to/9ZRdpTTmd";
				}
				else if ((insur.get("BR_ID")+"").equals("J1")) {
					visit_place = "��1���ڵ��������� (062-385-0133)���� ���� �󹫴����� 131-1";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg";
					parking_map = "http://kko.to/-VXvHD_ol";
				}
				else if ((insur.get("BR_ID")+"").equals("B1")) {
					visit_place = "�ΰ��ڵ������� (051-851-0606)\n�λ� ������ ����õ�� 270���� 5";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_bugyung.jpg";
					parking_map = "http://kko.to/0peONPKDI";
				}
				else {
					visit_place = "���������� (02-6263-6378)\n����� �������� �������� 34�� 9";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg";
					parking_map = "http://kko.to/M3C3ewyaQ";
				}
				if(!parking_map.equals("")){
					//return_place = "�൵ �ٷ� ���� "+ShortenUrlGoogle.getShortenUrl(parking_map); // �൵
					return_place = "�൵ �ٷ� ���� "+parking_map; // �൵
				}
				
				//acar0063- > acar0076 (��������) -> acar0110 (�ִ�ī����) -> 20220511 acar_0262, acar_0264
				//List<String> fieldList = Arrays.asList(firm_nm, driver, dist, dist_fee, insur_mng_name, insur_mng_phone, insurance_name, insurance_phone,  car_service_info, sos_service_info,  insur_mng_name,  insur_mng_phone, visit_place, return_place);
				List<String> fieldList = Arrays.asList(firm_nm, driver, driver2, dist, dist_fee, insur_mng_name, insur_mng_phone, insurance_name, insurance_phone);
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];	
					at_db.sendMessageReserve("acar_0262", fieldList, destphone, sendphone, null , etc1,  etc2);
				}	
				
				//�ð�����
				for(int t = 0; t <2; t++){
					Thread.sleep(1000);
				}
				
				
				List<String> fieldList2 = Arrays.asList(firm_nm, car_service_info, sos_service_info,  sk_net_info, insur_mng_name,  insur_mng_phone, visit_place, return_place, firm_nm);
				for(int j=0 ; j < s ; j++){
					destphone = app_value[j];	
					at_db.sendMessageReserve("acar_0264", fieldList2, destphone, sendphone, null , etc1,  etc2);
				}	
													
							
			} else if ( msg_subject.equals("bond") ) { //ä�Ǿ˸���
				
				if (bond_msg_type.equals("contract")) {
					//��ະ
					List<String> fieldList = Arrays.asList(customer_name, cur_date, car_no, car_nm, short_url, unpaid, bank_full, manager_name, manager_phone);
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessageReserve("acar0215", fieldList, destphone, sendphone, null , etc1, etc2);
					}	
					
				} else if (bond_msg_type.equals("client")) {
					//����
					List<String> fieldList = Arrays.asList(customer_name, cur_date, car_num_name_count, short_url, unpaid, bank_full);
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessageReserve("acar0222", fieldList, destphone, sendphone, null , etc1, etc2);
					}	
					
				} else {
					//type�� ���� ��ο��� �߼۽�
					List<String> fieldList = Arrays.asList(customer_name, cur_date, car_no, car_nm, short_url, unpaid, bank_full, manager_name, manager_phone);
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessageReserve("acar0215", fieldList, destphone, sendphone, null , etc1, etc2);
					}	
					
				}
			
			} else if ( msg_subject.equals("[���� ���� �ȳ�]") ) { //�����ȳ� ģ���� 
				
				String url3 = "http://fms1.amazoncar.co.kr/fms2/cls_cont/lc_cls_print.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
				String cls_url = ShortenUrlGoogle.getShortenUrl(url3);
				msg = firm_nm +  " ��  �Ƹ���ī�Դϴ�.\n\n" + 
				"["+ cr_bean.getCar_no() + "] ������  �������곻���Դϴ�. \n\n" + cls_url + " " ;
				
			
				msg_type = "5";
				
				msg = msg +"\n\n(��)�Ƹ���ī www.amazoncar.co.kr";
				 
				System.out.println("msg="+ msg);
				
				String rqdate = "";
				
				if(req_dt.equals("")){
					
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessage(1009, "0", msg, destphone, sendphone, null, l_cd, ck_acar_id);
					}	
				}else{
					String req_time = req_dt;
						
					if(req_dt_h.equals("")) req_dt_h = "09";
					if(req_dt_s.equals("")) req_dt_s = "00";
						
					req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
						
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessage(1009, "0", msg, destphone, sendphone, req_time, l_cd, ck_acar_id);
					}	
				}
			
			
			} else { //�����Է��� ���
				
				msg_type = "5";
				
				msg = msg +"\n\n(��)�Ƹ���ī www.amazoncar.co.kr";
				     	
				String rqdate = "";
				
				if(req_dt.equals("")){
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessage(1009, "0", msg, destphone, sendphone, null, l_cd, ck_acar_id);
					}	
				}else{
					String req_time = req_dt;
						
					if(req_dt_h.equals("")) req_dt_h = "09";
					if(req_dt_s.equals("")) req_dt_s = "00";
						
					req_time = req_time+""+req_dt_h+""+req_dt_s+"00";
						
					for(int j=0 ; j < s ; j++){
						destphone = app_value[j];
						at_db.sendMessage(1009, "0", msg, destphone, sendphone, req_time, l_cd, ck_acar_id);
					}	
				}
			}
				
	}
	
%>
<script language='javascript'>
<!--
	<%if(destphone_multi.equals("")){%>
		alert("���Ź�ȣ�� Ȯ���Ͽ� �ֽñ� �ٶ��ϴ�.");
	<%} else {%>
		alert('���۵Ǿ����ϴ�.');
		parent.document.form1.msg.value = '';
		parent.document.form1.msg_subject.value = '';
		parent.document.getElementById("vbt").style.display = "none";
		parent.document.getElementById("manager_send_use").checked = true;
	<%}%>
//-->
</script>
</body>
</html>