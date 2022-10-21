<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, acar.cus_reg.*, acar.car_service.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="pbean" scope="page" class="acar.parking.ParkBean"/> 
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>	
<%@ include file="/agent/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");

	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");  // ��������ȣ
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");  // ��������ȣ
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");  // ����������ȣ
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st"); // �뿩��������
	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no"); // ������ȣ
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm"); // ����
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id"); // �뿩��������
	String users_comp = request.getParameter("users_comp")==null?"":request.getParameter("users_comp"); // �����
	String user_m_tel = request.getParameter("user_m_tel")==null?"":request.getParameter("user_m_tel"); // ����� ����ó
		
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id"); // ������
	String park_mng = request.getParameter("park_mng")==null?"":request.getParameter("park_mng"); // �����
	String wash_dt = request.getParameter("wash_dt")==null?"":request.getParameter("wash_dt"); // �����Ͻ�
	String wash_pay = request.getParameter("wash_pay")==null?"":request.getParameter("wash_pay"); // �����ݾ�
	String wash_etc = request.getParameter("wash_etc")==null?"":request.getParameter("wash_etc"); // ����
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st"); // ������Ȳ
	String inclean_pay = request.getParameter("inclean_pay")==null?"":request.getParameter("inclean_pay"); // �ǳ�ũ���׺�
	
	int park_seq = request.getParameter("park_seq")==null?0:Util.parseInt(request.getParameter("park_seq"));
		
	String[] req_check = request.getParameterValues("req_check");  // checkbox ��
	String del = request.getParameter("del")==null?"":request.getParameter("del"); // ���� ���� �Ķ����
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String start_h = request.getParameter("start_h")==null?"":request.getParameter("start_h");
	String start_m = request.getParameter("start_m")==null?"":request.getParameter("start_m");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");

	String own_type = request.getParameter("own_type")==null?"":request.getParameter("own_type");
	String scd_time_yn = request.getParameter("scd_time_yn")==null?"":request.getParameter("scd_time_yn");
	String scd_time = request.getParameter("scd_time")==null?"":request.getParameter("scd_time");
	
	int count = 0;
	int chk =0;
	ParkIODatabase piod = ParkIODatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	user_bean = umd.getUsersBean(user_id);

	
	String d_user_nm ="";	
	String d_user_tel ="";
	                  
	String at_cont   ="";
	
	String etc =  own_type ;
	
	if(scd_time_yn.equals("Y")){
		etc += ", "+ scd_time ;
	}
	
	if(!wash_etc.equals("")){
		etc += ", "+wash_etc;
	}
	
	String wash_st = "";
	String inclean_st = "";
	
	//���߿� ������ �ǳ�ũ���׿� ���� ��û���α��и� ���� ����
	if(wash_pay.equals("0")){
		wash_st ="1";
	}
	
	if(inclean_pay.equals("0")){
		inclean_st ="1";
		
	}
	 
	
	
	// ����������, ���������Ͻ�, ���並 ���ļ� �ٽ� ���信 ���
	wash_etc = etc;
	
	
	//��ü�� ���(���) rent_mng_id, rent_l_cd, car_mng_id, car_st, 
	//				car_no, car_nm, park_id, user_id, wash_etc, start_dt, 
	//				start_h, start_m, gubun_st, 
	//				mng_id, users_comp, user_m_tel, wash_pay, inclean_pay
	
	// ���� rent_mng_id, rent_l_cd, car_mng_id, car_st, car_no, car_nm, 
	//		users_comp, park_id, park_mng, wash_dt, park_seq
	pbean = new ParkBean();
	pbean.setRent_mng_id(rent_mng_id);	
	pbean.setRent_l_cd(rent_l_cd);	
	pbean.setCar_mng_id(car_mng_id);	
	pbean.setCar_st(car_st);
	pbean.setCar_no(car_no);
	pbean.setCar_nm(car_nm);
	pbean.setPark_id(park_id);
	pbean.setUser_id(user_id);
	pbean.setWash_etc(wash_etc);
	pbean.setStart_dt(start_dt);
	pbean.setStart_h(start_h);
	pbean.setStart_m(start_m);
	pbean.setGubun_st(gubun_st);
	pbean.setUsers_comp(users_comp);
	pbean.setUser_m_tel(user_m_tel);
	pbean.setWash_pay(wash_pay);
	pbean.setInclean_pay(inclean_pay);
	pbean.setWash_st(wash_st);
	pbean.setInclean_st(inclean_st);
	pbean.setPark_mng(park_mng);
	pbean.setWash_dt(wash_dt);
	pbean.setPark_seq(park_seq);
	
	/* �޼��� ���� ����  */
	String wash_gubun = "����";
	String req_dt =  start_dt + " "+ start_h + ":" +  start_m ;
	String request_nm = user_bean.getUser_nm();
	String phone_num = user_bean.getUser_m_tel();
	
		
	String send_tel = "02-392-4242";
	
	List<String> fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
	
	
	if (del.equals("del")) { // ����
		
		int cnt = req_check.length;		
		for (int i=0; i < cnt; i++) {
			String[] reqArr = req_check[i].split("/",5);
			int pr_id = Integer.parseInt(reqArr[0]);
			wash_pay = reqArr[1];
			inclean_pay = reqArr[2];
			car_no = reqArr[3];
			gubun2 = reqArr[4];
			
			
			count = piod.deleteParkWash(pr_id);
			
			
			
			//������ ����Ѱ��
			if(wash_pay.equals("0") && inclean_pay.equals("")){
				
				wash_gubun = "����";
				fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
				
				//�۾����ü� ��Ͻ� ����õ������ ����
				d_user_nm 	= "����õ";		// ����� ����
				d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
				//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
				
				at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
			 	
				//�۾����ü� ��Ͻ�  ����������ڿ��� ����
				d_user_nm 	= "������";		// ����� ����
				d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
				
				//�˸��� acar0211 �뿩���þȳ�
				at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
				d_user_nm 	= "�ڽù�";		// ����� ����
				d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
				
				//�˸��� acar0211 �뿩���þȳ�
				at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				
			//�ǳ�ũ���� �� ���� ���Ÿ� �Ѱ��
			}else if(wash_pay.equals("") && inclean_pay.equals("0") ){
				
				//������ / �ڽù��簡 ���� ����� ���
				if(user_id.equals("000297") || user_id.equals("000313")){
					
					wash_gubun = "�ǳ�ũ���� �� ���� ���Ÿ�";
					fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
					
					//�۾����ü� ��Ͻ� ����õ������ ����
					d_user_nm 	= "����õ";		// ����� ����
					d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
					//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
					
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				 	
					//�۾����ü� ��Ͻ�  ����������ڿ��� ����
					d_user_nm 	= "������";		// ����� ����
					d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
					d_user_nm 	= "�ڽù�";		// ����� ����
					d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					

				//�ٸ��������� ��û���� ���	
				}else{
					
					wash_gubun = "�ǳ�ũ���� �� ���� ���Ÿ�";
					fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
					
					
					if(!gubun2.equals("����")){
						d_user_nm 	= "����õ";		// ����� ����
						d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
						//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
						
						at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					}
					
					//�۾����ü� ��Ͻ�  ����������ڿ��� ����
					d_user_nm 	= "������";		// ����� ����
					d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
					d_user_nm 	= "�ڽù�";		// ����� ����
					d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					
	
				}
			
			//������ �ǳ� �Ѵ� ����Ѱ��	
			}else if(wash_pay.equals("0") && inclean_pay.equals("0") ){
			 
				//������ / �ڽù��簡 ���� ����� ���
				if(user_id.equals("000297") || user_id.equals("000313")){
				
					wash_gubun = "�ǳ�ũ���� �� ���� ���ſ�\n����";
					fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
					
					//�۾����ü� ��Ͻ� ����õ������ ����
					d_user_nm 	= "����õ";		// ����� ����
					d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
					//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
					
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				 	
					//�۾����ü� ��Ͻ�  ����������ڿ��� ����
					d_user_nm 	= "������";		// ����� ����
					d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
					d_user_nm 	= "�ڽù�";		// ����� ����
					d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
				//�ٸ��������� ��û���� ���
				}else{
					
					gubun_st = "";
					wash_gubun = "�ǳ�ũ���� �� ���� ���ſ�\n����";
					fieldList = Arrays.asList(wash_gubun, car_no, request_nm, phone_num );
					
					if(!gubun2.equals("����")){
						d_user_nm 	= "����õ";		// ����� ����
						d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
						//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
						
						at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					}
					
					
					//�۾����ü� ��Ͻ�  ����������ڿ��� ����
					d_user_nm 	= "������";		// ����� ����
					d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
					d_user_nm 	= "�ڽù�";		// ����� ����
					d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0238", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
				}
			}
		}
	} else {
		if (park_seq == 0) { // ���
			
			//������ ����Ѱ��
			if(wash_pay.equals("0") && inclean_pay.equals("")){
				wash_gubun = "����";
				fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
				
				//�۾����ü� ��Ͻ� ����õ������ ����
				d_user_nm 	= "����õ";		// ����� ����
				d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
				//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
				
				at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
			 	
				//�۾����ü� ��Ͻ�  ����������ڿ��� ����
				d_user_nm 	= "������";		// ����� ����
				d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
				
				//�˸��� acar0211 �뿩���þȳ�
				at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
				d_user_nm 	= "�ڽù�";		// ����� ����
				d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
				
				//�˸��� acar0211 �뿩���þȳ�
				at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				
				 
			
			//�ǳ�ũ���� �� ���� ���Ÿ� �Ѱ��
			}else if(wash_pay.equals("") && inclean_pay.equals("0") ){
				
				//������ / �ڽù��簡 ���� ����� ���
				if(user_id.equals("000297") || user_id.equals("000313")){
					
					wash_gubun = "�ǳ�ũ���� �� ���� ���Ÿ�";
					fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
					
					//�۾����ü� ��Ͻ� ����õ������ ����
					d_user_nm 	= "����õ";		// ����� ����
					d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
					//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
					
					at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				 	
					//�۾����ü� ��Ͻ�  ����������ڿ��� ����
					d_user_nm 	= "������";		// ����� ����
					d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
					d_user_nm 	= "�ڽù�";		// ����� ����
					d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					 
				//�ٸ��������� ��û���� ���	
				}else{
					gubun_st = "";
					
					wash_gubun = "�ǳ�ũ���� �� ���� ���Ÿ�";
					fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
					
					//�۾����ü� ��Ͻ�  ����������ڿ��� ����
					d_user_nm 	= "������";		// ����� ����
					d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0237", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
					d_user_nm 	= "�ڽù�";		// ����� ����
					d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0237", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
				}
			
			//������ �ǳ� �Ѵ� ����Ѱ��	
			}else if(wash_pay.equals("0") && inclean_pay.equals("0") ){
			 
				//������ / �ڽù��簡 ���� ����� ���
				if(user_id.equals("000297") || user_id.equals("000313")){
					
					wash_gubun = "�ǳ�ũ���� �� ���� ���ſ�\n����";
					fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
					
					//�۾����ü� ��Ͻ� ����õ������ ����
					d_user_nm 	= "����õ";		// ����� ����
					d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
					//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
					
					at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
				 	
					//�۾����ü� ��Ͻ�  ����������ڿ��� ����
					d_user_nm 	= "������";		// ����� ����
					d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
					d_user_nm 	= "�ڽù�";		// ����� ����
					d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					
				//�ٸ��������� ��û���� ���
				}else{
					
					gubun_st = "";
					
					wash_gubun = "�ǳ�ũ���� �� ���� ���ſ�\n����";
					fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
					
					//�۾����ü� ��Ͻ�  ����������ڿ��� ����
					d_user_nm 	= "������";		// ����� ����
					d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0237", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
					//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
					d_user_nm 	= "�ڽù�";		// ����� ����
					d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
					
					//�˸��� acar0211 �뿩���þȳ�
					at_db.sendMessageReserve("acar0237", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
					
				}
				
			}
				
			chk = piod.chkParkWash(car_mng_id, start_dt);
			
			if(chk == 0){			
				count = piod.insertParkWash(pbean);
			}else{
				count =2;
			}
			
		} else { // ����
			count = piod.updateParkWash(pbean);
		}
	}

%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >

<form name='form1' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" 	value="<%=car_mng_id%>">
<input type="hidden" name="car_no" 	value="<%=car_no%>">
<input type="hidden" name="gubun1" 	value="<%=gubun1%>">
<input type="hidden" name="gubun2" 	value="<%=gubun2%>">
<input type="hidden" name="s_kd" 	value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="start_dt" value="<%=start_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
</form>
<script language='javascript'>
<!--
var fm = document.form1;
<%	if(count==1){ %>

	<% 	if (del.equals("del")) { %>
				alert("���������� �����Ǿ����ϴ�.");
				fm.action = "park_w_frame.jsp";
				fm.target = "d_content";
			    fm.submit();
	<% 	} else { %>
		<% 	if (park_seq==0) { %>
					alert("���������� ��ϵǾ����ϴ�.");
		<% 	} else { %>
					alert("���������� �����Ǿ����ϴ�.");
		<% 	} %>
				parent.window.close();
				parent.opener.location.reload();
	<% 	} %>
<%}else if(count==2){%>
	alert('������������ ������ �ֽ��ϴ�.\n�ش������� �Ϸ� �Ǵ� ���� �� ������ּ���');
//	parent.window.document.getElementById("loader").style.visibility="hidden";
	
<%}else{%>
		alert('������ �߻��Ͽ����ϴ�. �����ڿ��� ������ �ּ���.');
	//	parent.window.document.getElementById("loader").style.visibility="hidden";
<%}%>
//-->

</script>
</body>
</html>
