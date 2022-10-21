<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*, acar.cont.*, acar.user_mng.*, acar.cls.*, acar.coolmsg.* , acar.estimate_mng.*"%>
<%@ page import="acar.insur.*, acar.car_sche.*, acar.res_search.*, acar.common.*,   acar.im_email.*,  acar.memo.*, acar.client.* , tax.*,acar.offls_sui.* "%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="sui_db" scope="page" class="acar.offls_sui.Offls_suiDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>

<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"Y":request.getParameter("cls_doc_yn");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	//String match 	= request.getParameter("match")==null?"":request.getParameter("match"); //�����Ī :Y
	
	String car_st 	= request.getParameter("car_st")==null?"":request.getParameter("car_st"); // �����뿩 :5
					
	String reco_st 	= request.getParameter("reco_st")==null?"":request.getParameter("reco_st"); // ��ȸ��:N
					
	boolean flag1 = true;
	boolean flag2 = true;
	 	
	int	flag = 0;	
	int	count = 0;	
		
	String from_page 	= "";	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	CarSchDatabase csd = CarSchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();		
	EstiDatabase e_db = EstiDatabase.getInstance();
			
	ClsBean cls = new ClsBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	//�����Ƿ�����
	ClsEtcBean clsEtc = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = clsEtc.getCls_st_r();
	String match 	=clsEtc.getMatch();
		
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}
			
	String car_mng_id = "";
	
	String bus_id2 = "";
	
	String mng_id = "";
	
	//���⺻����
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	car_mng_id = base.getCar_mng_id();
	
	//�������� 
	
	bus_id2 = base.getBus_id2();

	String bus_nm = c_db.getNameById(bus_id2,"USER");
	 
			//�ŷ�ó����
	ClientBean client       = al_db.getClient(base.getClient_id());
				
		//������ �Ա���
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
	String real_date = "";
	String r_add_date = "";  //�������� 1�� �� -> �������� 1���� �� --> �������� 3�� ��
		
	real_date = cls_dt;
	r_add_date =  c_db.addDay(real_date, 3);  
			
	if (cls_st.equals("8") ) {
	   if ( !opt_ip_dt1.equals("") ) {	    		    	    	
				if ( !cls_dt.equals(opt_ip_dt1) ) {
				 //  real_date = opt_ip_dt1;
				   real_date = cls_dt;
				} else {
				   real_date = cls_dt;
				}		   		
		}	
	}
		
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setTerm_yn("Y");  //�������
	cls.setCls_st(cls_st);
	cls.setCls_dt(real_date);
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//���̿�Ⱓ ��
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//���̿�Ⱓ ��
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//��������
	
	cls.setCls_doc_yn("Y");
	cls.setReg_id(reg_id); //�����id
	
	if(cls_st.equals("8")){//���Կɼ��ΰ�� 
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));	
		cls.setFdft_amt3(request.getParameter("fdft_amt3")==null?0:			AddUtil.parseDigit(request.getParameter("fdft_amt3")));	  //���Կɼǽ� �����Ծ�
	
	} else {
	 
		//�ߵ�����, ���Կɼ�, �������� �����Ƿ� ���
		cls.setCancel_yn(request.getParameter("cancel_yn")==null?"":request.getParameter("cancel_yn"));
		cls.setGrt_amt(request.getParameter("grt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("grt_amt")));
		cls.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
		cls.setIfee_mon(request.getParameter("ifee_mon")==null?"":		request.getParameter("ifee_mon"));
		cls.setIfee_day(request.getParameter("ifee_day")==null?"":		request.getParameter("ifee_day"));
		cls.setIfee_ex_amt(request.getParameter("ifee_ex_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_ex_amt")));
		cls.setRifee_s_amt(request.getParameter("rifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_s_amt")));
		cls.setRifee_v_amt(request.getParameter("rifee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_v_amt")));
		cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
		cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
		cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
		cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
		cls.setRfee_v_amt(request.getParameter("rfee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_v_amt")));
		cls.setNfee_s_amt(request.getParameter("nfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("nfee_s_amt")));
		cls.setNfee_mon(request.getParameter("nfee_mon")==null?"":		request.getParameter("nfee_mon"));
		cls.setNfee_day(request.getParameter("nfee_day")==null?"":		request.getParameter("nfee_day"));
		cls.setNfee_amt(request.getParameter("nfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt_1"))); //�̳��뿩�� ���ʱݾ�
		cls.setEx_di_amt(request.getParameter("ex_di_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt_1"))); //������ �뿩�� �ݾ� (���� �Ǵ� �ܾ�)
		cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt"))); //�뿩�� �Ѿ�
		cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt"))); //����մ뿩��
		cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));  //�ܿ��Ⱓ
		cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));   //�ܿ��Ⱓ
		cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt"))); //�ܿ��Ⱓ�Ѵ뿩��
		cls.setDft_int(request.getParameter("dft_int_1")==null?"":		request.getParameter("dft_int_1")); //�ߵ����� ������
		cls.setDft_amt(request.getParameter("dft_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //�ߵ���������� ���ʱݾ�
		cls.setCar_ja_amt(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //��å�� ���ʱݾ�
		cls.setDly_amt(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //��ü�� ���ʱݾ�
		cls.setEtc_amt(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //����ȸ�����ֺ� ���ʱݾ�
		cls.setEtc2_amt(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //����ȸ���δ�� ���ʱݾ�
		cls.setEtc3_amt(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //������������ ���ʱݾ�
		cls.setEtc4_amt(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //��Ÿ���ع��� ���ʱݾ�
	
		cls.setFine_amt(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //���·� ���ʱݾ�
		cls.setNo_v_amt(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //�ΰ��� ���ʱݾ�
		cls.setFdft_amt1(request.getParameter("fdft_amt1_1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//�հ� ���ʱݾ�
		cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));//�����Աݾ�
				
		cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_s_amt")));   //��������� ���ް�
		cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_v_amt")));   //��������� �ΰ���
		cls.setCls_est_dt(request.getParameter("est_dt")==null?"":	request.getParameter("est_dt"));

		if(cls.getCls_est_dt().equals(""))	cls.setCls_est_dt(real_date);			
				
		//�߰��Աݾ��� ���� ��� - ���꼭 �ۼ�������
		cls.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //�߰��Ա���
		cls.setEx_ip_amt(request.getParameter("ex_ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_ip_amt")));	  //�߰��Աݾ� 	
		cls.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //�Ա�����
		cls.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //�Աݱ���
		cls.setTot_dist(request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist")));   //��������Ÿ�
		
		cls.setCms_chk(request.getParameter("cms_chk")==null?"N":request.getParameter("cms_chk"));  //cms�����Ƿ�
				
		cls.setOver_amt(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //�ʰ����� Ȯ���ݾ�	
		cls.setOver_v_amt(request.getParameter("over_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt_1"))); //�ʰ����� Ȯ���ݾ� vat
		
		cls.setDfee_s_amt(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1"))); //�뿩�� Ȯ���ݾ�	
		cls.setDfee_v_amt(request.getParameter("dfee_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_v_amt_1"))); //�뿩�� Ȯ���ݾ� vat
	}
			
	//����������  - ���걸�� : 1-> �ջ����� , 2->�������� , 3->ī������ 
	String jung_st = request.getParameter("jung_st")==null?"1":request.getParameter("jung_st");	
	int    h5_amt	= request.getParameter("h5_amt")==null?0:AddUtil.parseDigit(request.getParameter("h5_amt"));
	int    h7_amt	= request.getParameter("h7_amt")==null?0:AddUtil.parseDigit(request.getParameter("h7_amt"));
	String r_date = request.getParameter("r_date")==null?"":request.getParameter("r_date");	
	h5_amt = h5_amt * (-1);
	h7_amt = h7_amt;
	
//ī�� ����� ��� 
	if ( jung_st.equals("3") ) {		
			
		//����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
				
		String sub 		= " �������� ī�� ��Ұ� Ȯ��";
		String cont 	= "��  �������� ī�� ��� �� �� ����� Ȯ�ο�û :: "+ rent_l_cd + ", " +  car_no + ", ������:"+ real_date + ", ��ұݾ�:" + AddUtil.parseDecimal(h5_amt)  + " , �����ݾ�:" + AddUtil.parseDecimal(h7_amt) ;  	
									
		String url 		= "";				
		
		url 		= "/fms2/cls_cont/lc_cls_rm_u3.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;	
	
			
	//	String url 		= "";				
	//	url 		= "/acar/menu/emp_frame.jsp";	
	
						
		String target_id = nm_db.getWorkAuthUser("CMS����"); 
				
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <TARGET>2008003</TARGET>";
		xml_data += "    <TARGET>2006007</TARGET>";
		
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
		
		flag2 = cm_db.insertCoolMsg(msg);
			
		System.out.println("��޽���(ī����� Ȯ�ο�û�Ƿ�)"+car_no+", ������ :"+ real_date +" ---------------------"+target_bean.getUser_nm());	
		
	}
					

   if ( car_st.equals("5") ) { //�����뿩 
		if(!as_db.insertCls(cls))	flag += 1;   
    
	} else {
		if ( jung_st.equals("2")  || jung_st.equals("3") ) { 
		
			if(!as_db.insertCls2(cls, h5_amt, h7_amt, jung_st ))	flag += 1;	
		} else {
			if(!as_db.insertCls2(cls))	flag += 1;
		}
	}
	
   
   if ( car_st.equals("5") ) { //�����뿩 
   
		//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------	
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String sub 		= "���� �������� ���� �뺸";
		String cont 	= " ���������� ���� �Ǿ����ϴ�. : " + bus_nm  + ",  ������ȣ  : "+ car_no +" , ������ :   "+ cls_dt + " ������ ���� �ٶ��ϴ�.!!!";
	
		String target_id = nm_db.getWorkAuthUser("�����������");  //������ ������ "000144"; 
				
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	 				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>"+sub+"</SUB>"+
	 				"    <CONT>"+cont+"</CONT>"+
					"    <URL></URL>";		
		xml_data += "    <TARGET>2010006</TARGET>";	
		xml_data += "    <TARGET>2010004</TARGET>";	
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
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("��޽���[���������� ���� ] "+rent_l_cd+"-----------------------"+target_bean.getUser_nm());		

   }
	
//	System.out.println(" ������� flag 1=" + flag);
		
	//���ݾ� �� ���·�, ��å��,  ��ü�� ó�� (���·�,��å���� �Ϻλ�� �Ұ�)  - �Ϻλ��ݾ��� ������ó����.
	// ���·� ���
	 if ( AddUtil.parseDigit(request.getParameter("fine_amt_2"))  > 0) {
	 
	     if ( AddUtil.parseDigit(request.getParameter("fine_amt_2"))   == AddUtil.parseDigit(request.getParameter("fine_amt_1"))  ) {  //�Ϻλ��ó���� �ƴϸ� ó��.
	 			   		
		   		Vector vt1 = ac_db.getForfeitDetailCls(rent_mng_id, rent_l_cd);  //�̳��� ���·� 
				int vt1_size = vt1.size();
				
				int seq_no = 0;
				String f_car_mng_id = "";
				String f_vio_dt = "";
				String f_vio_pla = "";
				String f_proxy_dt = "";
											
				for(int i = 0 ; i < vt1_size ; i++){
					Hashtable ht = (Hashtable)vt1.elementAt(i);
								
					seq_no 	 = 	 Util.parseDigit(String.valueOf(ht.get("SEQ_NO")));  //����
					f_car_mng_id = 	 String.valueOf(ht.get("CAR_MNG_ID"));  //����������ȣ
					f_vio_dt 	 = 	 String.valueOf(ht.get("VIO_DT"));  //������
					f_vio_pla 	 = 	 String.valueOf(ht.get("VIO_PLA"));  //���ݳ���
					f_proxy_dt 	 = 	 String.valueOf(ht.get("PROXY_DT"));  //������
					
					if (!ac_db.updateForfeitDetailCls(rent_mng_id, rent_l_cd, seq_no, real_date, user_id) )	flag += 1; //�̳��� ���·�  ����� �Ա�ó��
					
					//������ ��� ����		
					if ( f_proxy_dt.equals("") ) {		
							
						//����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
						UsersBean sender_bean 	= umd.getUsersBean(user_id);
								
						String sub 		= "���·� ���Կ�û";
						String cont 	= "�� ���·� ���Կ�û :: "+ car_no + ", ������:"+ real_date + ", �������:" + f_vio_pla + ", ������:"+ f_vio_dt;  	
													
						String url 		= "";				
											
						url 		= "/acar/fine_mng/fine_mng_frame.jsp?c_id="+f_car_mng_id+"|m_id="+rent_mng_id+"|l_cd="+rent_l_cd+"|seq_no="+seq_no;		 
									
						//	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("������������ⳳ"));
				
						String target_id = nm_db.getWorkAuthUser("��ݴ��");  //  "000048";  //���Կɼ� �����		
						
				//		String target_id =   "000128"; //���·� ����� 000058->000114->000130-> 000128(���ֿ�)		
								
						//����� ���� ��ȸ
						UsersBean target_bean 	= umd.getUsersBean(target_id);
						
						String xml_data = "";
						xml_data =  "<COOLMSG>"+
					  				"<ALERTMSG>"+
					  				"    <BACKIMG>4</BACKIMG>"+
					  				"    <MSGTYPE>104</MSGTYPE>"+
					  				"    <SUB>"+sub+"</SUB>"+
					  				"    <CONT>"+cont+"</CONT>"+
					 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
						
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
						
						flag2 = cm_db.insertCoolMsg(msg);
							
						System.out.println("��޽���(���·ᳳ�Կ�û�Ƿ�)"+car_no+", ������:"+ f_vio_dt +" ---------------------"+target_bean.getUser_nm());	
						
					}
							
	//				System.out.println(" ���·� flag 2=" + flag);
								
				}  //end for	
			}	
	 }
	 	 
	 //��å�� ���
	 if ( AddUtil.parseDigit(request.getParameter("car_ja_amt_2") ) > 0 ) {
	 	
	 	   if ( AddUtil.parseDigit(request.getParameter("car_ja_amt_2") )  == AddUtil.parseDigit(request.getParameter("car_ja_amt_1") ) ) {  //�Ϻλ��ó���� �ƴϸ� ó�� .	
	 			   		
		   		Vector vt2 = ac_db.getServiceDetailCls(rent_mng_id, rent_l_cd);  //�̳��� ��å��
				int vt2_size = vt2.size();			
				
				String serv_id = "";
				String ext_tm = "";
				int  car_ja_amt = 0;
					
				for(int i = 0 ; i < vt2_size ; i++){
					Hashtable ht2 = (Hashtable)vt2.elementAt(i);
								
					serv_id	 	 = 	 String.valueOf(ht2.get("EXT_ID")); //����id
					ext_tm	 	 = 	 String.valueOf(ht2.get("EXT_TM")); //����
					car_ja_amt 	 = 	 Util.parseDigit(String.valueOf(ht2.get("CAR_JA_AMT")));  //��å�ݾ�
					
					if (!ac_db.updateServiceDetailCls(rent_mng_id, rent_l_cd, serv_id, car_ja_amt, ext_tm, real_date, user_id) )	flag += 1;	//�̳��� ��å�� �Ա� ó��
	//				System.out.println("��å�� ��� flag 3=" + flag);
				}  //end for	
	 	}
	 }
	 
	 //�ڱ��������ظ�å���� ��������ݿ� ����ó�� - 20100624 �߰�
	 if ( AddUtil.parseDigit(request.getParameter("car_ja_amt_1") ) > 0 ) {
	 			   		
	   		Vector vt3 = ac_db.getServiceDetailCls(rent_mng_id, rent_l_cd);  //�̳��� ��å��
			int vt3_size = vt3.size();			
			
			String serv_id = "";
			String ext_tm = "";
			int  car_ja_amt = 0;
			String bill_doc_yn = "";
				
			for(int i = 0 ; i < vt3_size ; i++){
				Hashtable ht3 = (Hashtable)vt3.elementAt(i);
							
				serv_id	 	 = 	 String.valueOf(ht3.get("EXT_ID")); //����id
				ext_tm	 	 = 	 String.valueOf(ht3.get("EXT_TM")); //����
				car_ja_amt 	 = 	 Util.parseDigit(String.valueOf(ht3.get("CAR_JA_AMT")));  //��å�ݾ�
				bill_doc_yn	 	 = 	 String.valueOf(ht3.get("BILL_DOC_YN")); // 1:��꼭 ���� , 0:�̹���
				
				if (!ac_db.updateServiceDetailCls2(rent_mng_id, rent_l_cd, serv_id, car_ja_amt, ext_tm, real_date, user_id, bill_doc_yn ) )	flag += 1;	//�̳��� ��å�� �Ա� ó��
//				System.out.println("��å�� ��������� ����  flag 3_1=" + flag);
			}  //end for	
	 }
	 	 
	  //��ü��  ����ó��
	 if ( AddUtil.parseDigit(request.getParameter("dly_amt")) > 0 ){
	 		int dly_amt_0 = AddUtil.parseDigit(request.getParameter("dly_amt"));
	 		int dly_amt_1 = AddUtil.parseDigit(request.getParameter("dly_amt_1"));
	 		if ( (dly_amt_0 - dly_amt_1) > 0 ) { 
	 			int j_dly = dly_amt_0 - dly_amt_1;
		 		if(!ac_db.insertScdDlyCls(rent_mng_id, rent_l_cd, j_dly , real_date, user_id, "1"))	flag += 1;	//�̳��� ��å�� �Ա� ó��	 
//		 		System.out.println("��ü�� ���� flag 4=" + flag);		 		
	 		} 
	 }	
	 			 
	 //��ü�� ���
	 if ( AddUtil.parseDigit(request.getParameter("dly_amt_2"))  > 0 ){
	 		int dly_amt = AddUtil.parseDigit(request.getParameter("dly_amt_2"));
	 		//��ü�� ���
	 		if(!ac_db.insertScdDlyCls(rent_mng_id, rent_l_cd, dly_amt, real_date, user_id, "2"))	flag += 1;	//�̳��� ��å�� �Ա� ó��	 
//	 		System.out.println("��ü�� flag 4=" + flag);		
	 }	
	 
	 	 //�뿩�� ��� - ���������� ����ݿ� ����  - �����Ī�ΰ��� ���� - ������ �̰���.
	 if(!match.equals("Y")){// 
		 if(!ac_db.updateScdFeeCls(rent_mng_id, rent_l_cd, real_date, user_id))	flag += 1;	//�̳��� �뿩�� ���ó��	
	 }	  
//	 System.out.println(" �뿩�� ��� flag 5=" + flag); 	
	 
	 //����Ʈ�ΰ�� - ���� ������  bill_yn = 'N'���� - 20151022
	 if (cls_st.equals("14") ) {	 
	  	if(!ac_db.updateScdFeeClsBill(rent_mng_id, rent_l_cd, real_date, user_id))	flag += 1;	//�̳��� �뿩�� ���ó��	
	 }
	 
//	 if ( AddUtil.parseDigit(request.getParameter("dfee_amt_1"))  > 0 ){
//	 		int fee_amt = AddUtil.parseDigit(request.getParameter("dfee_amt_2")) + AddUtil.parseDigit(request.getParameter("dfee_amt_2_v"));
	 	
	 		//�뿩�� ���
//	 		if(!ac_db.updateScdFeeCls(rent_mng_id, rent_l_cd, real_date, user_id))	flag += 1;	//�̳��� �뿩�� ���ó��	
//	 		System.out.println(" �뿩�� ��� flag 5=" + flag); 		
//	 }	
	 
	  		
	//�����ִ� ����Ÿ�� ���� �� ����������� ������ ����
	 String dl_amt = "";
	 if ( AddUtil.parseDigit(request.getParameter("dly_amt_2"))  > 0 ){
	   dl_amt =  Integer.toString(AddUtil.parseDigit(request.getParameter("dly_amt_2")));
	 
	 }	 
	 
	//����ȸ���� ���¶�� -- ����ȸ�� ���� ����  - ����ȸ�� �� �ݳ�(��������� ���ؼ�)
	if(!ac_db.updateCarCallIn(rent_mng_id, rent_l_cd, real_date)) flag += 1;	
//	System.out.println(" ����ȸ��(�ݳ�) ó�� flag 6_1=" + flag);
	 	 
		   
	if(!as_db.closeCont(rent_mng_id, rent_l_cd, cls_st, "", dl_amt, car_no, real_date ))	flag += 1;	
//	System.out.println(" ���� ó�� flag 6=" + flag);
	
	if(cls_st.equals("7")){//��������� ��� - 
		 	if(!ac_db.updateContEtcClear(rent_mng_id, rent_l_cd))	flag += 1;	//������� �����ݽ°����� ������ ����Ÿ ����
		 	
		 	//��ü������ ���� 20220426
		 	String  d_flag3 = ec_db.call_sp_com_pre_cls_cont(rent_mng_id, rent_l_cd);	 
   }	
    
	//������ ��������� ���� ���� - �ߵ�����, ��ุ��, �縮�������������� ��� - loan_st = '2'�� ��쿡 ���ؼ�, ����Ʈ�����ΰ�쵵 ����
	if ( cls_st.equals("1") || cls_st.equals("2") || cls_st.equals("10") ||  cls_st.equals("14") ) {
	
	 //	if ( !cls_st.equals("14") ) {	 	//����Ʈ�ΰ��� �̹� ����� ������. 
		 	UsersBean bus_id2_bean 	= umd.getUsersBean(bus_id2);	 	
		 	if ( !bus_id2_bean.getLoan_st().equals("1") ) {
		 		if(!ac_db.sendMemo(cls_dt, car_no))	flag += 1;	
		 	
		 	}	 	 
	// 	}
	 	
	 	int count2 = 0;
	 	
	 	String park = request.getParameter("park")==null?"":request.getParameter("park"); //��������ġ
		String park_cont = request.getParameter("park_cont")==null?"":request.getParameter("park_cont"); //���� ��Ÿ			
		count = rs_db.updateCarPark(car_mng_id, park, park_cont);			
		
		code_bean = c_db.getCodeBean("0027",park);
	//	CodeBean code = c_db.getCodeBean("27",park);
		
		//	if(park.equals("1") || park.equals("3") || park.equals("7") || park.equals("8")|| park.equals("4") || park.equals("9")  || park.equals("11")  || park.equals("12")   || park.equals("13")  ){//����� ������ ����
		if ( !code_bean.getCms_bk().equals("")) {
			Hashtable ht6 = pk_db.getRentParkIOSearch2(car_mng_id);
			count2 = pk_db.UpdateParkIO(String.valueOf(ht6.get("CAR_MNG_ID")));	
		}	
		
		//������ ���뿩�� ���
		ac_db.call_sp_esti_reg_sh_res (real_date, car_mng_id);	
				
		//  �縮��//����Ʈ ���� - ������
		if ( base.getCar_st().equals("1") ||   base.getCar_st().equals("4")  ) {
			e_db.call_sp_esti_reg_sh(car_mng_id);
		}
					
		//����ġ�� Ʋ�� ���������� ��� ��������  ���� - 2012-10-09 - ��Ÿ�ΰ��¿���ó��
		String n_mng_br_id = "";
		String n_user_id = nm_db.getWorkAuthUser("�����������");	
		
		if ( !code_bean.getCms_bk().equals("")) {
			n_mng_br_id = code_bean.getCms_bk();
		}
		
		
		if( n_mng_br_id.equals("S1") ){	
			n_user_id = nm_db.getWorkAuthUser("�����������");	
		}else if(n_mng_br_id.equals("B1") ){	
			n_user_id = nm_db.getWorkAuthUser("�λ�������");	
		}else if(n_mng_br_id.equals("D1") ){	
			n_user_id = nm_db.getWorkAuthUser("����������");	
		}else if(n_mng_br_id.equals("J1") ){	
			n_user_id = nm_db.getWorkAuthUser("����������");	
		}else if(n_mng_br_id.equals("G1") ){	
			n_user_id = nm_db.getWorkAuthUser("�뱸������");
		} else 	{	
			n_user_id = nm_db.getWorkAuthUser("�����������");		
		}
		
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		//����Ÿ����
		ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont.get("RENT_MNG_ID")), String.valueOf(cont.get("RENT_L_CD")));
		
		if(!n_mng_br_id.equals("") && cont_etc.getRent_mng_id().equals("")){
		
			cont_etc.setMng_br_id		(n_mng_br_id);
		
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
			cont_etc.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
			boolean flag21 = a_db.insertContEtc(cont_etc);
		}else{
		
			String o_mng_br_id = cont_etc.getMng_br_id();
			
			if(!n_mng_br_id.equals("") && !o_mng_br_id.equals(n_mng_br_id)){
				
				
				//�������� �����̷µ�� & �������� ���� ����
				LcRentCngHBean bean = new LcRentCngHBean();	
				bean.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
				bean.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
				bean.setCng_item	("mng_br_id");
				bean.setOld_value	(o_mng_br_id);
				bean.setNew_value	(n_mng_br_id);
				bean.setCng_cau		("������ ����ġ ����");
				bean.setCng_id		(ck_acar_id);
				bean.setRent_st		(String.valueOf(cont.get("FEE_RENT_ST")));
				bean.setS_amt		(0);
				bean.setV_amt		(0);	
				boolean flag23 = a_db.updateLcRentCngH(bean);
					 
			
			}		
		}
									
	}
	
	if ( !cls_st.equals("8") ) {
		if (!a_db.updateCarStatCng(car_mng_id))	flag += 1;
//		System.out.println(" �縮�� ó�� flag7=" + flag);		
   }	
	
	//���Կɼ� �̸� - ���Կɼ� ����ڿ��� ���� 
	
	if ( cls_st.equals("8") ) {
		//������ ���Կɼ� ����ڿ��� �޼��� ����------------------------------------------------------------------------------------------
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
		String sub 		= "������� ���Կɼ� ���� ���";
		String cont 	= "[������ȣ:"+car_no+"] ���Կɼ� ����(���) �ϼ���.";	
			
		String url 		= "/acar/off_ls_after/off_ls_after_opt_frame.jsp";		 	 
		
		String target_id = nm_db.getWorkAuthUser("���Կɼǰ�����");  //  "000048";  //���Կɼ� �����		
		
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);  
		
	//	String target_id = "000277" ;  // �ӽ�		
	
		if(!cs_bean2.getWork_id().equals("")) target_id = cs_bean2.getWork_id(); 
						
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
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
		
		flag2 = cm_db.insertCoolMsg(msg);
			
//		System.out.println("��޽���(���Կɼǰ���)"+car_no+"---------------------"+target_bean.getUser_nm());	
	
	} else if ( cls_st.equals("7") ) {	
		
//	 	System.out.println("��޽���(���������(����))"+car_no+"---------------------");	
	
	} else if ( cls_st.equals("10") ) {	
		
//	 	System.out.println("��޽���(����������(�縮��))"+car_no+"---------------------");	   
	
	} else {
		//������ ������ ���������� ��� �޼��� ����------------------------------------------------------------------------------------------
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
		String sub 		= "������� ������ ���� ���";
		String cont 	= "[������ȣ:"+car_no+"] ������ ����(���) Ȯ���ϼ���.";	
			
		String url 		= "/acar/rent_prepare/rent_pr_frame_s.jsp";
				
		String target_id = nm_db.getWorkAuthUser("����������");  
		
				
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
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
		
		//flag2 = cm_db.insertCoolMsg(msg); 20121022 ���¿��븮 ��û���� �޽��� ���� ���� : ��������������ȭ�� �ʿ������
			
//		System.out.println("��޽���(����������)"+car_no+"---------------------"+target_bean.getUser_nm());	
	}  
		
	//��Ÿ��� ���񺸻�
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(car_mng_id, "N" );		
	
	String return_remark = "";
	Hashtable  return1 =   new Hashtable();
	
    if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "N"); 	
	   	return_remark = (String)return1.get("REMARK");
    }
  	 	
    //ȥ�ٴ� ���Կɼ��� ���� 
    if ( fuel_cnt > 0  && (  return_remark.equals("��Ÿ��") || return_remark.equals("����") || return_remark.equals("ȥ��")  || return_remark.equals("����")  ) )  {
       		//���񺸻����
	       if (    AddUtil.parseDigit(request.getParameter("etc3_amt_1")) <   0) {
	       	  	if (!ac_db.updateFuelCng(car_mng_id))	flag += 1;
	       	  	
	       	  	UsersBean sender_bean 	= umd.getUsersBean(user_id);
									
				String sub 		= "������� ���� ���� ���� ���";
				String cont 	= "[������ȣ:"+car_no+"]   ���񺸻� ������ Ȯ���ϼ���.  ����ݾ� : " + request.getParameter("etc3_amt_1") ;	
				
				String target_id = "000197";   
				
				//����� ���� ��ȸ
				UsersBean target_bean 	= umd.getUsersBean(target_id);
											
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL></URL>";
				
		//		xml_data += "    <TARGET>2013002</TARGET>";
				xml_data += "    <TARGET>2006007</TARGET>";
				
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
				
				flag2 = cm_db.insertCoolMsg(msg);
					
				System.out.println("��޽���  ����Ϸ� "+car_no+"---------------------"+target_bean.getUser_nm());	
	   	  }
    }  	
		 	
		
	//���� �Ǻ������� ��� && 21���̸��� ���  20160901-������ ����ȳ� ��ü������� ���� ;
	//������ �������ڿ��� ���� ���� ����ó�� �޼��� ����------------------------------------------------------------------------------------------

	//����������� �ƴ� ��츸 	
	if ( cls_st.equals("7") || cls_st.equals("10")   ) {
	
	} else {
	
		//��������
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		InsurBean ins  = ai_db.getIns(base.getCar_mng_id(), ins_st);
		Hashtable ins_info = ai_db.getInsClsCoolMsg(base.getCar_mng_id(),ins_st);
		
		//20170207 �Ű��̳� ���Կɼ��� ��쿡�� ���������� ��� �ȵǾ� ������  ���� �ٲٱ�
		String msgGubun = "�������";
		if( cls_st.equals("6") || cls_st.equals("8") ){
			//���������� ã��
			SuiBean sui = sui_db.getSui(base.getCar_mng_id());
			if(sui.getMigr_dt().equals("")){
				if( cls_st.equals("6")  ){ msgGubun = "�Ű�" ; }
				if( cls_st.equals("8")  ){ msgGubun = "���Կɼ�" ; }
			}
		}
		
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
								
			String sub 		= "������� �Ϸ��� ���� ���� üũ���";
			String cont 	=  msgGubun+" ["+car_no+","+ins_info.get("CAR_NM")+","+ins_info.get("FIRM_NM")+","+ins_info.get("ENP_NO")+","+ins_info.get("INS_START_DT")+","+ins_info.get("INS_EXP_DT")+","+ins_info.get("INS_CON_NO")+"]";	
			String  d_flag2 = "";
			//���躯���û ���ν��� ȣ��
			if ( !cls_st.equals("8")   ) {   //���Կɼ��� �ƴϸ� 	
				 d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, "");	 
		   }	
		   
		   System.out.println("��޽���(���� �������)"+ String.valueOf(ins_info.get("CAR_NO"))  +"---------------------"+rent_l_cd );					
	}	
			
	if(clsEtc.getServ_st().equals("N")) {
		
		//���� �� ���������ʿ� ��Ͻ� ��������� ����
		RentContBean rc_bean = new RentContBean();
		rc_bean.setCar_mng_id	(car_mng_id);
		rc_bean.setRent_st		("6");
		rc_bean.setRent_dt		(real_date);
		rc_bean.setBrch_id		("");
		rc_bean.setBus_id		(reg_id);
		rc_bean.setRent_start_dt(r_add_date+"0000");
		rc_bean.setEtc			("������ �������� �ڵ����� ");
		rc_bean.setDeli_plan_dt	(r_add_date+"0000");
		rc_bean.setUse_st		("1");
		rc_bean.setReg_id		(reg_id);
		rc_bean.setMng_id		(reg_id);
		rc_bean = rs_db.insertRentCont(rc_bean);	
	
	//	System.out.println("��������� ������"+car_no);	
					
		//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------	
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String sub 		= "������ ó�� �뺸";
		String cont 	= "[����]�������� ���-"+car_no+",  "+rc_bean.getEtc() + "�� �Ǿ����ϴ�. ���� ������  ������ ����Ͽ� �������� Ȱ���� �� �ְ� �ϼž� �մϴ�.!!!";
	//	String target_id = reg_id;
		String target_id = clsEtc.getReg_id();//�����
					
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
 					"    <URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>system</SENDER>"+
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("��޽���[������ ó�� �뺸-������ �������� �ڵ�����] "+car_no+"-----------------------"+target_bean.getUser_nm());	
		
	}
	
		
		//������ ����κ� ��� - ������ ������ ���� - 20161005
	if(!clsEtc.getServ_gubun().equals("")) {	  	  
	//	  if ( clsEtc.getServ_st().equals("Y") ) {
		  	 	 count = ac_db.setCar_prepare(car_mng_id, clsEtc.getServ_gubun());
	//	   }			
	}
	
	
	//��ȸ������ ó�� 		
	if ( cls_st.equals("10") || cls_st.equals("7") ) {
	} else {
		if ( reco_st.equals("N")   ) {
		   
			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------	
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String sub 		= "��ȸ���������� �뺸";
			String cont 	= " ��ȸ�������� ���� �Ǿ����ϴ�. ����ȣ : "+rent_l_cd +" , ������ :   "+ cls_dt + " ������ ���� �ٶ��ϴ�.!!!";
		
			String target_id = nm_db.getWorkAuthUser("�����������");  //������ ������ "000144"; 
					
			//����� ���� ��ȸ
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
	  					"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
	 					"    <URL></URL>";
	 		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";				
			xml_data += "    <TARGET>2006007</TARGET>";
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
			
			flag2 = cm_db.insertCoolMsg(msg);
			System.out.println("��޽���[��ȸ������ ���� ] "+rent_l_cd+"-----------------------"+target_bean.getUser_nm());		
		
		}
	}	
	
	//�������꼭 ���Ϲ߼�
	
	//[5�ܰ�] �������Ϸ� �߼� : d-mail ����

	if ( cls_st.equals("1") || cls_st.equals("2")  || cls_st.equals("8") ) {   //�ߵ��ؾ�, ��ุ��
	
		//	1. d-mail ���-------------------------------	
		String con_agnt_email = "";
		String firm_nm = "";		
		//cont_view
		Hashtable baseV = a_db.getContViewCase(rent_mng_id, rent_l_cd);			
		
		con_agnt_email = client.getCon_agnt_email();		
		firm_nm =String.valueOf( baseV.get("FIRM_NM"));	
				
		if(!con_agnt_email.equals("")){
									
				DmailBean d_bean = new DmailBean();
				        		
				d_bean.setSubject(firm_nm+"��, (��)�Ƹ���ī �������� ���� �ȳ����Դϴ�.");
			
				d_bean.setSql				("SSV:"+con_agnt_email.trim());
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setMailto			("\""+firm_nm+"\"<"+con_agnt_email.trim()+">");
				d_bean.setReplyto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setErrosto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setHtml				(1);
				d_bean.setEncoding			(0);
				d_bean.setCharset			("euc-kr");
				d_bean.setDuration_set		(1);
				d_bean.setClick_set			(0);
				d_bean.setSite_set			(0);
				d_bean.setAtc_set			(0);
				d_bean.setGubun				(rent_l_cd+"cls_info");				
				d_bean.setRname				("mail");
				d_bean.setMtype       		(0);
				d_bean.setU_idx       		(1);//admin����
				d_bean.setG_idx				(1);//admin����
				d_bean.setMsgflag     		(0);				
				d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/cls/cls_con_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&cls_st="+cls_st);
			
				if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
		}	
	}
	
	cls.setDly_amt(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //��ü�� ���ʱݾ�
	cls.setEtc_amt(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //����ȸ�����ֺ� ���ʱݾ�
	cls.setEtc2_amt(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //����ȸ���δ�� ���ʱݾ�
	cls.setEtc3_amt(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //������������ ���ʱݾ�
	cls.setEtc4_amt(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //��Ÿ���ع��� ���ʱݾ�
		
	String item_id = "";
  	String reg_code = "";	
  	String tax_chk1 = request.getParameter("tax_chk1")==null?"N":request.getParameter("tax_chk1"); //���ֺ��  
  	String tax_chk2 = request.getParameter("tax_chk2")==null?"N":request.getParameter("tax_chk2"); //�δ��� 
  	String client_id 	= "";
	String site_id 		= "";
				
  	client_id = base.getClient_id();
  	
  	if(base.getTax_type().equals("2")){//����
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
  	
  	//�ŷ�ó����
	ClientSiteBean site = null; 
	if(!site_id.equals("")){
		//�ŷ�ó��������
		site = al_db.getClientSite(client_id, site_id);
		if(site.getEnp_no().equals("")){
			site_id = "";
		}
	}
	
	
  	//�����,��ü����. ������������, ��Ÿ���ع����� �ִٸ� 
  	if ( AddUtil.parseDigit(request.getParameter("dft_amt_1"))  > 0   ||   AddUtil.parseDigit(request.getParameter("dly_amt_1"))  > 0  ||   AddUtil.parseDigit(request.getParameter("etc3_amt_1"))  > 0  ||   AddUtil.parseDigit(request.getParameter("etc4_amt_1"))  > 0  )   {
  		//����� item_id ��������	    
	    	item_id = IssueDb.getItemIdNext(real_date);	    	
  		   out.println("item_id="+item_id+"<br><br>");
  			//�����ڵ� ��������
			reg_code  = Long.toString(System.currentTimeMillis());
			out.println("�����ڵ�="+reg_code+"<br>");
	
	}
	int item_seq = 0;		
	  	
	 	//��꼭 ������ϴ� �ŷ����� ó�� - 201703 ���� ����
	if ( AddUtil.parseDigit(request.getParameter("dft_amt_1"))  > 0  ){
		 	 	
		 	item_seq +=1;
		 	 		
    		//[1�ܰ�] �ŷ����� ����Ʈ ����		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("���������");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("dft_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		   til_bean.setCar_use(base.getCar_st()); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 3:����
			til_bean.setItem_dt(real_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			til_bean.setEtc("�����");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
    	
	//��꼭 ������ϴ� �ŷ����� ó�� - 201703 ���� ����
	if ( AddUtil.parseDigit(request.getParameter("dly_amt_1"))  > 0  ){
		 	 	
		 	 item_seq +=1;		
    		//[1�ܰ�] �ŷ����� ����Ʈ ����		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("���������");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("dly_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		   til_bean.setCar_use(base.getCar_st()); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 3:����
			til_bean.setItem_dt(real_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			til_bean.setEtc("��ü����");
			
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
			
		//��꼭 ������ϴ� �ŷ����� ó�� - 201703 ���� ���� - ����ȸ�����ֺ�� 
	if ( AddUtil.parseDigit(request.getParameter("etc_amt_1"))  > 0  && tax_chk1.equals("Y")   ){
		 	 
		  	 item_seq +=1;		 		
    		//[1�ܰ�] �ŷ����� ����Ʈ ����		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("���������");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("etc_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		   til_bean.setCar_use(base.getCar_st()); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 3:����
			til_bean.setItem_dt(real_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			til_bean.setEtc("����ȸ�����ֺ��");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
   	
   		//��꼭 ������ϴ� �ŷ����� ó�� - 201703 ���� ����
	if ( AddUtil.parseDigit(request.getParameter("etc2_amt_1"))  > 0  && tax_chk2.equals("Y")  ){
		 	 		
		 	   	 item_seq +=1;		 				
    		//[1�ܰ�] �ŷ����� ����Ʈ ����		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("���������");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("etc2_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		   til_bean.setCar_use(base.getCar_st()); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 3:����
			til_bean.setItem_dt(real_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			til_bean.setEtc("����ȸ���δ���");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
   
   	//��꼭 ������ϴ� �ŷ����� ó�� - 201703 ���� ����
	if ( AddUtil.parseDigit(request.getParameter("etc3_amt_1"))  > 0  ){
		 	 	
		 	  	 item_seq +=1;		 		 		
    		//[1�ܰ�] �ŷ����� ����Ʈ ����		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("���������");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("etc3_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		    til_bean.setCar_use(base.getCar_st()); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 3:����
			til_bean.setItem_dt(real_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			til_bean.setEtc("������������");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
   
   	//��꼭 ������ϴ� �ŷ����� ó�� - 201703 ���� ����
	if ( AddUtil.parseDigit(request.getParameter("etc4_amt_1"))  > 0  ){
		 	
		 	 	 item_seq +=1;		 		 		
    		//[1�ܰ�] �ŷ����� ����Ʈ ����		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("���������");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("etc4_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		    til_bean.setCar_use(base.getCar_st()); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 3:����
			til_bean.setItem_dt(real_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			til_bean.setEtc("��Ÿ���ع���");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
   	
   	 	//[2�ܰ�] �ŷ����� ����
	    		
	Vector vt = IssueDb.getTaxItemListSusi(reg_code);
	int vt_size = vt.size();
	out.println("�ŷ����� ����="+vt_size+"<br><br>");
		
	for(int j=0;j < vt_size;j++){
			Hashtable ht = (Hashtable)vt.elementAt(j);
			TaxItemBean ti_bean = new TaxItemBean();
			ti_bean.setClient_id(client_id);
			ti_bean.setSeq(site_id);
			ti_bean.setItem_dt(real_date);
			
			ti_bean.setTax_id("");
			ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
			ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"��");
			ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
			ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
			
			if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
	}
	
	
	if ( vt_size > 0) {	
	
		//�����
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
		String con_agnt_nm			= "";
		String con_agnt_email		= "";
		String con_agnt_m_tel		= "";
		
		if(!site_id.equals("")){
			con_agnt_nm			= site.getAgnt_nm();
			con_agnt_email		= site.getAgnt_email();
			con_agnt_m_tel		= site.getAgnt_m_tel();
		}else{
			con_agnt_nm			= client.getCon_agnt_nm();
			con_agnt_email		= client.getCon_agnt_email();
			con_agnt_m_tel		= client.getCon_agnt_m_tel();
		}
	
		
		//���ν��� ȣ��
		int flag5 = 0;
		String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", sender_bean.getId(), reg_code, item_id, con_agnt_nm, con_agnt_email, con_agnt_m_tel);
		System.out.println(d_flag2);
		if (!d_flag2.equals("0")) flag5 = 1;
		System.out.println(" ���� - �ŷ����� ���� ���ν��� �ڵ����"+item_id + ","+ sender_bean.getUser_nm() +","+ con_agnt_nm + "," + con_agnt_email);
		
	}
	
	System.out.println("������� "+car_no+"--------"+ rent_l_cd);	
			    		
	//����
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>

<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//�������̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');				
     fm.s_kd.value = '2';
   <% if (  !cls_st.equals("14")  ) {%>	
    fm.action='/fms2/cls_cont/lc_cls_u3.jsp';
    <% } else { %>
        fm.action='/fms2/cls_cont/lc_cls_rm_u3.jsp';
    <% } %>    
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
