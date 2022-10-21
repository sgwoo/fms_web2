<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*, acar.cont.*,acar.client.*, acar.car_sche.*"%>
<%@ page import="acar.kakao.*" %><!-- 2018.03.12 -->
<%@ page import="acar.accid.*, acar.watch.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;	//ä�Ǿ絵������/������ ���Ȯ�ο� (20181123)
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag9 = true;
	boolean flag12 = true;
	int result = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	WatchDatabase wc_db = WatchDatabase.getInstance();
	
%>


<%
	String cons_no	 	= "";
	String accid_id		= "";
	String accid_reg_yn = "";
	String ac_car_no	= "";
	int    seq	 		= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	
	int    cons_su	 	= request.getParameter("cons_su")==null?1:AddUtil.parseInt(request.getParameter("cons_su"));
	String cons_st	 	= request.getParameter("cons_st")==null?"1":request.getParameter("cons_st");
	String off_id	 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String off_nm	 	= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
//	String req_id	 	= request.getParameter("req_id")==null?"":request.getParameter("req_id");
	String acar_driver_id= "";
	String off_msg	 	= request.getParameter("off_msg")==null?"N":request.getParameter("off_msg");
	String sms_msg	 	= request.getParameter("sms_msg")==null?"":request.getParameter("sms_msg");
	String sms_msg2	 	= request.getParameter("sms_msg2")==null?"":request.getParameter("sms_msg2");
//	String cmp_app	 	= request.getParameter("cmp_app")==null?"":request.getParameter("cmp_app");
	String after_yn	 	= request.getParameter("after_yn")==null?"N":request.getParameter("after_yn");
	String mm_seq	 	= request.getParameter("mm_seq")==null?"":request.getParameter("mm_seq");
	String bond_trf_yn	= request.getParameter("bond_trf_yn")==null?"N":request.getParameter("bond_trf_yn");
	
	
	String target_id 	= "";
	String f_req_id 	= "";
	String today	 	= AddUtil.getDate();
	int    after_cnt	= 0;
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	String car_mng_id	[]		= request.getParameterValues("car_mng_id");
	String req_id		[]		= request.getParameterValues("req_id");
	String cmp_app		[]		= request.getParameterValues("cmp_app");
	String rent_mng_id	[] 		= request.getParameterValues("rent_mng_id");
	String rent_l_cd	[] 		= request.getParameterValues("rent_l_cd");
	String client_id	[] 		= request.getParameterValues("client_id");
	String car_no		[] 		= request.getParameterValues("car_no");
	String car_nm		[] 		= request.getParameterValues("car_nm");
	String cons_cau		[] 		= request.getParameterValues("cons_cau");
	String cons_cau_etc	[]		= request.getParameterValues("cons_cau_etc");
	String cost_st      [] 		= request.getParameterValues("cost_st");
	String pay_st       [] 		= request.getParameterValues("pay_st");
	String from_st      [] 		= request.getParameterValues("from_st");
	String from_place   [] 		= request.getParameterValues("from_place");
	String from_comp    [] 		= request.getParameterValues("from_comp");
	String from_title   [] 		= request.getParameterValues("from_title");
	String from_man     [] 		= request.getParameterValues("from_man");
	String from_tel		[] 		= request.getParameterValues("from_tel");
	String from_m_tel   []		= request.getParameterValues("from_m_tel");
	String from_req_dt  [] 		= request.getParameterValues("from_req_dt");
	String from_req_h  	[] 		= request.getParameterValues("from_req_h");
	String from_req_s  	[] 		= request.getParameterValues("from_req_s");
	String from_est_dt  [] 		= request.getParameterValues("from_est_dt");
	String from_est_h  	[] 		= request.getParameterValues("from_est_h");
	String from_est_s  	[] 		= request.getParameterValues("from_est_s");
	String from_dt      [] 		= request.getParameterValues("from_dt");
	String to_st		[] 		= request.getParameterValues("to_st");
	String to_place     [] 		= request.getParameterValues("to_place");
	String to_comp      [] 		= request.getParameterValues("to_comp");
	String to_title     [] 		= request.getParameterValues("to_title");
	String to_man       [] 		= request.getParameterValues("to_man");
	String to_tel	    []		= request.getParameterValues("to_tel");
	String to_m_tel     [] 		= request.getParameterValues("to_m_tel");
	String to_req_dt    [] 		= request.getParameterValues("to_req_dt");
	String to_req_h    	[] 		= request.getParameterValues("to_req_h");
	String to_req_s    	[] 		= request.getParameterValues("to_req_s");
	String to_est_dt    [] 		= request.getParameterValues("to_est_dt");
	String to_est_h    	[] 		= request.getParameterValues("to_est_h");
	String to_est_s    	[] 		= request.getParameterValues("to_est_s");
	String to_dt        [] 		= request.getParameterValues("to_dt");
	String driver_id    [] 		= request.getParameterValues("driver_id");
	String driver_nm    [] 		= request.getParameterValues("driver_nm");
	String driver_m_tel [] 		= request.getParameterValues("driver_m_tel");
	String wash_yn      [] 		= request.getParameterValues("wash_yn");
	String oil_yn       [] 		= request.getParameterValues("oil_yn");
	String oil_liter    []		= request.getParameterValues("oil_liter");
	String oil_est_amt  [] 		= request.getParameterValues("oil_est_amt");
	String etc          [] 		= request.getParameterValues("etc");
	String cons_amt     [] 		= request.getParameterValues("cons_amt");
	String wash_amt     [] 		= request.getParameterValues("wash_amt");
	String oil_amt      [] 		= request.getParameterValues("oil_amt");
	String other        [] 		= request.getParameterValues("other");
	String other_amt    [] 		= request.getParameterValues("other_amt");
	String tot_amt      [] 		= request.getParameterValues("tot_amt");
	String pay_dt       []		= request.getParameterValues("pay_dt");
	String cust_amt     [] 		= request.getParameterValues("cust_amt");
	String cons_copy    [] 		= request.getParameterValues("cons_copy");
	String hipass_yn    [] 		= request.getParameterValues("hipass_yn");
	String sub_l_cd    [] 		= request.getParameterValues("sub_rent_l_cd");
	
	String f_man	 	= request.getParameter("f_man")==null?"N":request.getParameter("f_man");
	String d_man	 	= request.getParameter("d_man")==null?"N":request.getParameter("d_man");
	
	String  t_cmp_app = "";  //����Ź�۱���
 	int  t_cmp_amt = 0;    //����Ź�۱������
	
	//1. Ź���Ƿ� ���----------------------------------------------------------------------------------------	
	
	
	for(int i=0;i<cons_su;i++){
		
//		after_yn = "";
		
		ConsignmentBean cons = new ConsignmentBean();
		
		//1��Ź���Ƿ��ڰ� ��������� �����Ѵ�.
		if(i==0)		f_req_id = req_id[i]==null?"":req_id[i];
		
		cons.setCons_no			(cons_no);
		cons.setSeq					(i+1);
		cons.setCons_su			(cons_su);
		cons.setReg_code			(reg_code);
		cons.setOff_id				(off_id);
		cons.setOff_nm				(off_nm);
		cons.setCons_st			(cons_st);
		cons.setCmp_app			(cmp_app   			[i] ==null?"": cmp_app   		[i]);
		cons.setReq_id				(req_id   				[i] ==null?"": req_id   		[i]);
		cons.setReg_id				(user_id);
		cons.setReg_dt				(AddUtil.getDate());
		cons.setCar_mng_id		(car_mng_id   		[i] ==null?"": car_mng_id   	[i]);
		cons.setRent_mng_id	(rent_mng_id  		[i] ==null?"": rent_mng_id  	[i]);
		cons.setRent_l_cd			(rent_l_cd    			[i] ==null?"": rent_l_cd    	[i]);
		cons.setClient_id			(client_id    			[i] ==null?"": client_id    	[i]);
		cons.setCar_no				(car_no       			[i] ==null?"": car_no       	[i]);
		cons.setCar_nm			(car_nm       			[i] ==null?"": car_nm       	[i]);
		cons.setCons_cau			(cons_cau     		[i] ==null?"": cons_cau     	[i]);
		cons.setCons_cau_etc	(cons_cau_etc  		[i] ==null?"": cons_cau_etc    	[i]);
		cons.setCost_st				(cost_st      			[i] ==null?"": cost_st      	[i]);
		cons.setPay_st				(pay_st       			[i] ==null?"": pay_st       	[i]);
		cons.setFrom_st      		(from_st      			[i] ==null?"": from_st      	[i]);
		cons.setFrom_place   	(from_place   		[i] ==null?"": from_place   	[i]);
		cons.setFrom_comp    	(from_comp    		[i] ==null?"": from_comp    	[i]);
		cons.setFrom_title   		(from_title   			[i] ==null?"": from_title   	[i]);
		cons.setFrom_man     	(from_man     		[i] ==null?"": from_man     	[i]);
		cons.setFrom_tel	  		(from_tel	  			[i] ==null?"": from_tel	  		[i]);
		cons.setFrom_m_tel   	(from_m_tel   		[i] ==null?"": from_m_tel   	[i]);
		cons.setFrom_req_dt  	(from_req_dt[i]+from_req_h[i]+from_req_s[i]);
//		cons.setFrom_est_dt  	(from_req_dt[i]+from_req_h[i]+from_req_s[i]);
//		cons.setFrom_est_dt  	(from_est_dt  		[i] ==null?"": from_est_dt  	[i]);
//		cons.setFrom_dt      		(from_dt      			[i] ==null?"": from_dt      	[i]);
		cons.setTo_st		  		(to_st		  			[i] ==null?"": to_st		  	[i]);
		cons.setTo_place     		(to_place     			[i] ==null?"": to_place     	[i]);
		cons.setTo_comp      	(to_comp      		[i] ==null?"": to_comp      	[i]);
		cons.setTo_title     		(to_title     			[i] ==null?"": to_title     	[i]);
		cons.setTo_man       		(to_man      		 	[i] ==null?"": to_man       	[i]);
		cons.setTo_tel	      		(to_tel	      			[i] ==null?"": to_tel	      	[i]);
		cons.setTo_m_tel     		(to_m_tel    		 	[i] ==null?"": to_m_tel     	[i]);
		cons.setTo_req_dt   	 	(to_req_dt[i]+to_req_h[i]+to_req_s[i]);
//		cons.setTo_est_dt    		(to_req_dt[i]+to_req_h[i]+to_req_s[i]);
//		cons.setTo_est_dt    		(to_est_dt   	 		[i] ==null?"": to_est_dt    	[i]);
//		cons.setTo_dt        		(to_dt        			[i] ==null?"": to_dt        	[i]);
		cons.setDriver_nm		(driver_nm    		[i] ==null?"": driver_nm    	[i]);
		cons.setDriver_m_tel	(driver_m_tel 		[i] ==null?"": driver_m_tel 	[i]);
		cons.setWash_yn    		(wash_yn      		[i] ==null?"N": wash_yn      	[i]);
		cons.setOil_yn     			(oil_yn       			[i] ==null?"N": oil_yn       	[i]);
		cons.setOil_liter  			(oil_liter    			[i] ==null?0 : AddUtil.parseDigit(oil_liter    	[i]));
		cons.setOil_est_amt		(oil_est_amt  		[i] ==null?0 : AddUtil.parseDigit(oil_est_amt  	[i]));
		cons.setEtc					(etc          			[i] ==null?"": etc          	[i]);
//		cons.setCons_amt			(cons_amt     		[i] ==null?0 : AddUtil.parseDigit(cons_amt     	[i]));
//		cons.setOil_amt			(wash_amt     		[i] ==null?0 : AddUtil.parseDigit(wash_amt     	[i]));
//		cons.setWash_amt		(oil_amt      			[i] ==null?0 : AddUtil.parseDigit(oil_amt      	[i]));
		cons.setOther				(other        			[i] ==null?"": other        	[i]);
//		cons.setOther_amt		(other_amt    		[i] ==null?0 : AddUtil.parseDigit(other_amt    	[i]));
//		cons.setTot_amt			(tot_amt      			[i] ==null?0 : AddUtil.parseDigit(tot_amt      	[i]));
//		cons.setPay_dt				(pay_dt       			[i] ==null?"": pay_dt       	[i]);
		cons.setCust_amt			(cust_amt      		[i] ==null?0 : AddUtil.parseDigit(cust_amt     	[i]));
		cons.setHipass_yn		(hipass_yn    		[i] ==null?"": hipass_yn    	[i]);
		cons.setAfter_yn			(after_yn);
		
		cons.setF_man				(f_man);
		cons.setD_man				(d_man);
		cons.setMm_seq			(mm_seq);
		
		cons.setSub_l_cd		(sub_l_cd    		[i] ==null?"": sub_l_cd    	[i]);
		
		if(off_id.equals("003158")){
			acar_driver_id = driver_id[i] ==null?"":driver_id[i];
			cons.setDriver_nm	(acar_driver_id);
			cons.setFrom_est_dt	(cons.getFrom_req_dt());
			cons.setTo_est_dt	(cons.getTo_req_dt());
		}
		
		if(off_id.equals("002740") ||  off_id.equals("009217") ||  off_id.equals("010255")   ){  //����Ź��,  �Ƹ���Ź�� , ������TS �̸� ���õ� ������ Ź�ۿ�� setting
			t_cmp_app = cmp_app[i]	==null?"":cmp_app[i];  //Ź�۱���
			//�պ��ΰ�� 2��? ������ �ݾ�����   cons_st :2 					
			if(!t_cmp_app.equals("")){
				t_cmp_amt = c_db.getCmp_app_amt(t_cmp_app);
			}
			
			if ( cons_st.equals("2") ) {
		 	   if(i==1) 		t_cmp_amt = t_cmp_amt /2 ;
		 	}
			cons.setCons_amt		(t_cmp_amt);		
		}
		
		//���������� �߰�(20190509)	//�����ʱ�� ����Ʈ������ �����Է��ϰ�. ���ĵ��Կ���.
		/* if(		   wash_yn[i].equals("M")){			cons.setWash_fee(5000);			}	//��輼�� ��� 5000��
		else if(wash_yn[i].equals("H")){			cons.setWash_fee(8000);			}	//�ռ��� ��� 8000��
		else {													cons.setWash_fee(0);				} */	 
		
		//�����Է¿���
//		if( AddUtil.parseInt(AddUtil.replace(today,"-","")) > AddUtil.parseInt(AddUtil.replace(from_req_dt[i],"-","")) ){
//			after_yn = "Y";
//			after_cnt++;
//			cons.setAfter_yn(after_yn);
//		}
		
		//=====[consignment] insert=====
		cons_no = cs_db.insertConsignment(cons);
		
		// Ź�ۻ���(��������ȸ��, �������ȸ��, ������ȸ��, ��������ȸ��, �������ȸ��, �ߵ�����ȸ��, ����ݳ�, �뿩����ȸ��, ����Ʈ����ȸ��)�� ��� ������ ���� ��� �˸��� �߼� 2018.03.13
		//	��������ȸ��:8, �������ȸ��:9, ������ȸ��:10, ��������ȸ��:11, �������ȸ��:12, �ߵ�����ȸ��:13, ����ݳ�:14, �뿩����ȸ��:15, ����Ʈ����ȸ��:22
		String cc_val = cons_cau[i];
		String customer_m_tel = "";
		String match1 = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
		String match2 =  "\\s{2,}";
		String arrival_date = "";
		String cons_no_seq = "";
		if(cc_val.equals("8")||cc_val.equals("9")||cc_val.equals("10")||cc_val.equals("11")||cc_val.equals("12")||cc_val.equals("13")||cc_val.equals("14")||cc_val.equals("15")||
				cc_val.equals("22")){
			if(from_st[i].equals("2")){// ��� ������ ���� ���
				customer_m_tel = from_m_tel[i].replaceAll(match1, "");	// �� ��ȭ��ȣ Ư������ ����
				customer_m_tel = customer_m_tel.replaceAll(match2, "");	// �� ��ȭ��ȣ ���� ����
				arrival_date = from_req_dt[i];
				arrival_date += " ";
				arrival_date += from_req_h[i];
				arrival_date += ":";
				arrival_date += from_req_s[i];
				/*
					from_comp[i]:ȸ���, car_no[i]:������ȣ, car_nm[i]:����, arrival_date:���� ���� �Ͻ�, from_place[i]:������, driver_nm[i]:Ź�۱�� ����, driver_m_tel[i]:Ź�۱�� ����ó
					rent_l_cd[i]: ����ȣ
				*/
				// step1 ���� �˸��� ������ Ź�۱�� ����� ����ó�� �־�߸� ���� ����
				// �˸��� ���̺� etc_text_1 �÷��� Ź�� ��ȣ(cons_no�� seq�� �Բ� ����)�� �����Ѵ�.
				cons_no_seq = cons_no;
				cons_no_seq += cons.getSeq();
				// step1 ���� �˸��� ������ Ź�۱�� ����� ����ó�� �־�߸� ���� ����
				if(customer_m_tel.length() > 9 && driver_nm[i].length() > 1 && driver_m_tel[i].length() > 7 && cons_no_seq.length() > 1){
					List<String> fieldList = Arrays.asList(from_comp[i], car_no[i], car_nm[i], arrival_date, from_place[i], 
							driver_nm[i], driver_m_tel[i]);
					flag7 = at_db.sendMessageReserve("acar0125", fieldList, customer_m_tel, "02-392-4243", null, cons_no_seq, "999999");
				}
			}
		}
		
		if(cons_no.equals("")){
			result++;
		}else{
			
			//�縮�� �뿩�����ε� Ź���Ƿڽ� �������ڿ��� �������� �޽��� �߼�
			
			//cont
			ContBaseBean base = a_db.getCont(cons.getRent_mng_id(), cons.getRent_l_cd());
			
			if(base.getCar_gu().equals("0") && cons.getCons_cau().equals("1") && cons.getTo_st().equals("2")){ //�縮��&�뿩�����ε�&������
				
				//��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
				//������
				ClientBean client = al_db.getNewClient(base.getClient_id());
				
				String sub2		= "�縮�� �뿩�����ε� Ź���Ƿ� ���";
				String cont_b = "[ "+cons.getRent_l_cd()+" "+client.getFirm_nm();
				if(client.getClient_st().equals("2")){
					cont_b = cont_b + " "+client.getSsn1()+" "+cons.getCar_no();
		  		}else{
		  			cont_b = cont_b + " "+client.getEnp_no1()+"-"+client.getEnp_no2()+"-"+client.getEnp_no3()+" "+cons.getCar_no();
				}
				
				String cont2 = cont_b + " ] �縮�� ";
				cont2 = cont2 + ec_db.getContCngInsCngMsg(cons.getRent_mng_id(), cons.getRent_l_cd(), "1");
				
				//���躯���û ���ν��� ȣ��
				String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub2, cons.getRent_mng_id(), cons.getRent_l_cd(), "1");
				
				String target_id2 = nm_db.getWorkAuthUser("�λ꺸����");
				CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id2);
				if(!cs_bean2.getUser_id().equals("")){
					target_id2 = nm_db.getWorkAuthUser("���纸����");
					//�������� ��� �ް��϶�
					cs_bean2 = csd.getCarScheTodayBean(target_id2);
					if(!cs_bean2.getWork_id().equals("")) target_id2 = cs_bean2.getWork_id();
				}
				//����� ���� ��ȸ
				UsersBean target_bean2 	= umd.getUsersBean(target_id2);
				UsersBean sender_bean2 	= umd.getUsersBean(cons.getReq_id());
			
				String xml_data2 = "";
				xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub2+"</SUB>"+
		  				"    <CONT>"+cont2+"</CONT>"+
 							"    <URL></URL>";
				xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
				xml_data2 += "    <SENDER>"+sender_bean2.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
				CdAlertBean msg2 = new CdAlertBean();
				msg2.setFlddata(xml_data2);
				msg2.setFldtype("1");
			
				//�뿩�����϶� �߼��ϱ�� ��.
				//flag12 = cm_db.insertCoolMsg(msg2);
			}

			//���� - �����̵� �̸� �������� ����ڿ��� �޼���(20190826)
			if(cc_val.equals("17")){
				String sub3 = "�����̵� Ź�� ���";
				String cont3 = "[ "+ cons.getCar_no()+" ] ������ ���� �����̵� Ź���� ��ϵǾ����ϴ�.";
				//����� ���� ��ȸ
				UsersBean target_bean3 	= umd.getUsersBean(base.getMng_id());
				UsersBean sender_bean3 	= umd.getUsersBean(cons.getReq_id());			
				String xml_data3 = "";
				xml_data3 =  "<COOLMSG>"+
	  							  	  "	<ALERTMSG>"+
 										  "    <BACKIMG>4</BACKIMG>"+
  									  "    <MSGTYPE>104</MSGTYPE>"+
  									  "    <SUB>"+sub3+"</SUB>"+
		  							  "    <CONT>"+cont3+"</CONT>"+
 									  "    <URL></URL>"+
									  "    <TARGET>"+target_bean3.getId()+"</TARGET>"+
									  "    <SENDER>"+sender_bean3.getId()+"</SENDER>"+
  									  "    <MSGICON>10</MSGICON>"+
  									  "    <MSGSAVE>1</MSGSAVE>"+
  									  "    <LEAVEDMSG>1</LEAVEDMSG>"+
		  							  "    <FLDTYPE>1</FLDTYPE>"+
  									  "	</ALERTMSG>"+
  									  "</COOLMSG>";
			
				CdAlertBean msg3 = new CdAlertBean();
				msg3.setFlddata(xml_data3);
				msg3.setFldtype("1");
				boolean flag17 = cm_db.insertCoolMsg(msg3);
			}
		}	
	}


	if(result>0){
		//�κн��н� ��� ����
		flag3 = cs_db.deleteConsignments(reg_code);
		
	}else{
		
		UsersBean sender_bean 	= umd.getUsersBean(f_req_id);
		
		//2. ����ó���� ���-------------------------------------------------------------------------------------------
		
		String sub 		= "Ź���Ƿ�";
		String cont 	= sms_msg2;
		
		if(off_id.equals("000620")) target_id = "000047";//����������
		if(off_id.equals("002371")) target_id = "000094";//�ڸ���Ź��
		if(off_id.equals("002740")) target_id = "000095";//����Ź��
		if(off_id.equals("004107")) target_id = "000127";//�ڸ���Ź�ۺλ�
		if(off_id.equals("004171")||off_id.equals("007547")) target_id = "000139";//����ī�޴���, ����ī�޺λ�
		if(off_id.equals("007751")) target_id = "000187";//(��)����Ư��
		if(off_id.equals("009026")) target_id = "000222";//(��)��������
		if(off_id.equals("011372")) target_id = "000308";//�������(��)
		if(off_id.equals("009217")) target_id = "000223";//(��)�Ƹ���Ź��
		if(off_id.equals("010255")) target_id = "000263";//������TS
		if(off_id.equals("011790")) target_id = "000328";//�۽�Ʈ����̺�
		
	//	if(off_id.equals("008411")||off_id.equals("008468") ||off_id.equals("008516") )   target_id = "000196";//�ϵ�����Ź�۹���
	//	if(off_id.equals("010919")||off_id.equals("010920") ||off_id.equals("010921") )   target_id = "000196";//�ϵ�����Ź�۹���		 
		if(off_id.equals("010919")||off_id.equals("010920") ||off_id.equals("010921") ||off_id.equals("008516") ||off_id.equals("008411") ||off_id.equals("008468") )   target_id = "000196";//�ϵ�����Ź�۹���
		


		if(off_id.equals("003158") && !acar_driver_id.equals(""))	target_id = acar_driver_id;//�Ƹ���ī-������ ������
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st("2");//Ź���Ƿ�
		doc.setDoc_id(cons_no);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		doc.setUser_nm1("�Ƿ�");
		doc.setUser_nm2("����");
		doc.setUser_nm3("����");
		doc.setUser_id1(f_req_id);
		doc.setUser_id2(target_id);
		doc.setUser_id3(target_id);
		if(!off_id.equals("003158")){
			doc.setUser_nm4("û��");
			doc.setUser_nm5("Ȯ��");
			doc.setUser_nm6("����");
			doc.setUser_id4(target_id);
			doc.setUser_id5(f_req_id);
		}
		doc.setDoc_bit("1");//���Ŵܰ�
		doc.setDoc_step("1");//���
		
		
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
		
		
		if(off_id.equals("003158") && req_id.equals(target_id)){
			DocSettleBean doc2 = d_db.getDocSettleCommi("2", cons_no);
			flag2 = d_db.updateDocSettle(doc2.getDoc_no(), user_id, "2", "2");
			out.println("����ó���� ����<br>");
		}
		
		
		
if(!f_man.equals("Y") && !d_man.equals("Y")){//�����/Ź�۾�ü üũ�Ǹ�(��=Y) ����		
		
		//3. ��޽��� �˶� ���----------------------------------------------------------------------------------------
			
		
		if(!target_id.equals("")){
		
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String cont_replace = cont.replace("]", "]\n");
			cont_replace = cont_replace.replace("/", "\n");
			cont_replace = cont_replace.replace("//", "\n\n");
			
			String url 		= "/fms2/consignment_new/cons_rec_frame.jsp";
			String m_url  = "/fms2/consignment_new/cons_rec_frame.jsp";
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub+"</SUB>"+
	  					"    <CONT>"+cont_replace+"</CONT>"+
  						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			
			//�޴»��
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
			//�������
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
			
			if(!target_bean.getId().equals(sender_bean.getId())){
				
				// ���� ��¥ �� �ð� ��ȸ
				Date today2 = new Date();
				SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
				SimpleDateFormat time = new SimpleDateFormat("HHmmss");
				
				String year  	= String.valueOf(date.format(today2)).substring(0,4);
			    String month 	= String.valueOf(date.format(today2)).substring(4,6);
			    String day   	= String.valueOf(date.format(today2)).substring(6,8);
		        String hms   	= time.format(today2);
			    
		        // ������ ��ȸ
			    WatchScheBean ws_bean = new WatchScheBean();
			    ws_bean = wc_db.getWatchSche(year, month, day, "1");
			    
				// Ź�� ��ü�� �Ƹ���Ź���̸鼭 ������ 18�� ����, �ָ�/�������� �˸��� �߼�. ������ ���δ� ������ ������ üũ.
				if(target_id.equals("000223") && (ws_bean.getMember_id3().equals("") || Integer.parseInt(String.valueOf(hms)) >= 180000) ){
					// �˸��� �߼�
//					if(off_id.equals("003158")){
					cont = sms_msg+" [�Ƿ���:"+sender_bean.getUser_nm()+"-"+sender_bean.getUser_m_tel()+"]";
					//	}
			
					String temp_cont = sms_msg.replace("]", "]\n");
					temp_cont = temp_cont.replace("/", "\n");
					
					String result_cont = temp_cont + "\n\n[�Ƿ���:"+sender_bean.getUser_nm()+"-"+sender_bean.getUser_m_tel()+"]";
					
					//4. SMS ���� �߼�------------------------------------------------------------
					if(after_yn.equals("N") && !target_bean.getUser_m_tel().equals("")){
						String sendphone 	= sender_bean.getUser_m_tel();
						String sendname 	= "(��)�Ƹ���ī "+sender_bean.getUser_nm();
						String destphone 	= target_bean.getUser_m_tel();
						String destname 	= target_bean.getUser_nm();
						
						if(off_id.equals("010255")) {
							destphone = target_bean.getHot_tel();
						}
								
						int i_msglen = AddUtil.lengthb(cont);
					
						String msg_type = "0";
			
						//80�̻��̸� �幮��
						if(i_msglen>80) msg_type = "5";
					
						//at_db.sendMessage(1009, "0", cont, destphone, sendphone, null, cons_no, ck_acar_id);
						at_db.sendMessage(1009, "0", result_cont, destphone, sendphone, null, cons_no, ck_acar_id);
					
					}
				} else { // �Ƹ���Ź�� �� �ٸ� Ź�� ��ü�ų� ������ �����ð��� ��� �޽��� �߼�.
					flag2 = cm_db.insertCoolMsg(msg);
					
				}
				
			}
		}else{
		
			//�����ڰ� ������...����ڿ��� ���ں�����.
			if(after_yn.equals("N") && off_id.equals("003158") && acar_driver_id.equals("")){
				
				String standby_dt 	= from_req_dt[0];
				String standby_dt_h = from_req_h[0];
				String standby_st 	= "2";
				
				if(AddUtil.parseInt(standby_dt_h) > 12)	 standby_st = "3";
				
				Vector s_vt = cs_db.getConsStandbyList("", standby_dt, standby_st);
				int s_vt_size = s_vt.size();
				
				if(s_vt_size > 0)	{
					for(int i = 0 ; i < s_vt_size ; i++){
						Hashtable ht = (Hashtable)s_vt.elementAt(i);
						
						//4. SMS ���� �߼�------------------------------------------------------------
						if(!sender_bean.getUser_nm().equals(String.valueOf(ht.get("USER_NM"))) && !String.valueOf(ht.get("USER_M_TEL")).equals("")){
							String sendphone 	= sender_bean.getUser_m_tel();
							String sendname 	= "(��)�Ƹ���ī "+sender_bean.getUser_nm();
							String destphone 	= String.valueOf(ht.get("USER_M_TEL"));
							String destname 	= String.valueOf(ht.get("USER_NM"));
							
							int i_msglen = AddUtil.lengthb(sms_msg+"-"+sender_bean.getUser_nm());
		
							String msg_type = "0";
		
							//80�̻��̸� �幮��
							if(i_msglen>80) msg_type = "5";
				
							IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, destname, "", "", msg_type, "(��)�Ƹ���ī �����", sms_msg+"-"+sender_bean.getUser_nm(), "", "", ck_acar_id, "cons");
							
							
						}
					}
				}
			}
		}


}//��

		//ä�Ǿ絵 ������ �� ������ �����Ͱ� ������ ���(20181123)
		if(bond_trf_yn.equals("Y")){
		    accid_id	 			= request.getParameter("ac_accid_id")==null?"":request.getParameter("ac_accid_id");
			String ac_rent_mng_id	= request.getParameter("ac_rent_mng_id")==null?"":request.getParameter("ac_rent_mng_id");
			String ac_rent_l_cd		= request.getParameter("ac_rent_l_cd")==null?"":request.getParameter("ac_rent_l_cd");
			String ins_com_id		= request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");
			String ins_com_nm		= request.getParameter("ins_com_nm")==null?"":request.getParameter("ins_com_nm");
			String ac_client_id		= request.getParameter("ac_client_id")==null?"":request.getParameter("ac_client_id");
			String ac_client_st		= request.getParameter("ac_client_st")==null?"":request.getParameter("ac_client_st");
			String ac_client_nm		= request.getParameter("ac_client_nm")==null?"":request.getParameter("ac_client_nm");
			String ac_firm_nm	 	= request.getParameter("ac_firm_nm")==null?"":request.getParameter("ac_firm_nm");
			String ac_birth	 		= request.getParameter("ac_birth")==null?"":request.getParameter("ac_birth");
			String ac_enp_no	 	= request.getParameter("ac_enp_no")==null?"":request.getParameter("ac_enp_no");
			String ac_zip	 		= request.getParameter("ac_zip")==null?"":request.getParameter("ac_zip");
			String ac_addr	 		= request.getParameter("ac_addr")==null?"":request.getParameter("ac_addr");
			int    ins_req_amt		= request.getParameter("ins_req_amt")==null?0:AddUtil.parseInt(AddUtil.replace(String.valueOf(request.getParameter("ins_req_amt")),",",""));
			String ac_car_mng_id	= request.getParameter("ac_car_mng_id")==null?"":request.getParameter("ac_car_mng_id");
			String ac_car_st		= request.getParameter("ac_car_st")==null?"":request.getParameter("ac_car_st");
			ac_car_no				= request.getParameter("ac_car_no")==null?"":request.getParameter("ac_car_no");
			String ac_car_nm		= request.getParameter("ac_car_nm")==null?"":request.getParameter("ac_car_nm");
			String accid_dt	 		= request.getParameter("accid_dt")==null?"":request.getParameter("accid_dt");
			String ins_use_st		= request.getParameter("ins_use_st")==null?"":request.getParameter("ins_use_st");
			String use_st_h	 		= request.getParameter("use_st_h")==null?"":request.getParameter("use_st_h");
			String use_st_s	 		= request.getParameter("use_st_s")==null?"":request.getParameter("use_st_s");
			String ins_use_et		= request.getParameter("ins_use_et")==null?"":request.getParameter("ins_use_et");
			String use_et_h	 		= request.getParameter("use_et_h")==null?"":request.getParameter("use_et_h");
			String use_et_s	 		= request.getParameter("use_et_s")==null?"":request.getParameter("use_et_s");
			ins_use_st	= 	ins_use_st+""+use_st_h+""+use_st_s;
			ins_use_et	= 	ins_use_et+""+use_et_h+""+use_et_s;
			ins_use_st	=	AddUtil.replace(ins_use_st,"-","");
			ins_use_et	=	AddUtil.replace(ins_use_et,"-","");
			
			flag4 = cs_db.insertBondTransferDoc(accid_id, cons_no, cons_st, ac_rent_mng_id, ac_rent_l_cd, ins_com_id, ins_com_nm
												, ac_client_id, ac_client_st, ac_client_nm, ac_firm_nm, ac_birth, ac_enp_no, ac_zip, ac_addr, ins_req_amt
												, ac_car_mng_id, ac_car_no, ac_car_nm, accid_dt, ins_use_st, ins_use_et);	//22
												

		}
	}

	%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <%if(off_id.equals("003158") && req_id.equals(target_id))%>  <input type="hidden" name="cons_no" 			value="<%=cons_no%>">
</form>
<script language='javascript'>
	var flag = 0;	
<%		if(result>0){	%>	alert('Ź���Ƿ� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');				flag = 1;<%		}	%>		
<%		if(!flag1){		%>	alert('����ǰ�Ǽ� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');			flag = 1;<%		}	%>		
<%		if(!flag2){		%>	alert('��޽��� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');				flag = 1;<%		}	%>
<%		if(!flag9){		%>	alert('��޽��� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');				flag = 1;<%		}	%>
<%		if(!flag7){		%>	alert('������ ������ �˸��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		flag = 1;<%		}	%>
<%		if(!flag4){		%>	alert('ä�Ǿ絵������/������ ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		flag = 1;<%		}	%>	//�߰� (20181123)
<%-- <%		if(bond_trf_yn.equals("Y") && accid_id.equals("") && accid_reg_yn.equals("")){%>	alert('����� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		flag = 1;<%		}	%>	//�߰� (20190104) --%>
<%-- <%		if(bond_trf_yn.equals("Y") && accid_id.equals("") && !accid_reg_yn.equals("")){%>	alert('�⺻�����ͷ� �ڵ������ �Ǿ����ϴ�.\n\n�����ȸ���� �߰����� �Է��Ͻʽÿ�. >> <%=ac_car_no%>'); <%}%>	//�߰� (20190104) --%>
	if(flag == 0){
		alert('��ϵǾ����ϴ�.');
		var fm = document.form1;	
		<%if(off_id.equals("003158") && req_id.equals(target_id)){%>	
		fm.action = 'cons_reg_step3.jsp'; 
		<%}else{%>
		fm.action = 'cons_reg_step1.jsp';		
		<%}%>		
		fm.target = 'd_content';
		fm.submit();		
	}else{
		alert('��ϵ��� �ʾҽ��ϴ�. Ȯ�ιٶ��ϴ�.');
	}
</script>
</body>
</html>
 