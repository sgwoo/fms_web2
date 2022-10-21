<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.incom.*, acar.common.*, acar.user_mng.*, acar.ext.*, acar.credit.*, tax.*, acar.coolmsg.*, acar.forfeit_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*, acar.con_ins_m.*, acar.accid.*, acar.con_ins_h.*,  acar.cls.*, acar.car_sche.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="ass_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")		==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	if ( from_page.equals("")) from_page = "/fms2/account/shinhan_erp_demand_inside_client.jsp" ;
		
	String bank_code 	= request.getParameter("incom_bank_nm")	==null?"":request.getParameter("incom_bank_nm");   //���� 
	String deposit_no 	= request.getParameter("incom_bank_no")	==null?"":request.getParameter("incom_bank_no");		 //���� 	
	
	String value_bank[] = new String[2];
	StringTokenizer st9 = new StringTokenizer(bank_code,":");
	int s9=0; 
	while(st9.hasMoreTokens()){
		value_bank[s9] = st9.nextToken();
		s9++;
	}
		
	String bank_name 	= request.getParameter("bank_name")	==null?"":request.getParameter("bank_name");
	
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	long  incom_amt 			= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	
	String incom_acct_seq			= request.getParameter("incom_acct_seq")==null?"":request.getParameter("incom_acct_seq");  //�Աݸ�Īó���� seq�� �����ؾ� ��. 
	String incom_tr_date_seq			= request.getParameter("incom_tr_date_seq")==null?"":request.getParameter("incom_tr_date_seq");  //�Աݸ�Īó���� seq�� �����ؾ� ��. 	
					
  	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
			 
	String not_yet 	= request.getParameter("not_yet")==null?"0":request.getParameter("not_yet");  //1:������
	String not_yet_reason 	= request.getParameter("not_yet_reason")==null?"":request.getParameter("not_yet_reason");  //1:������
		
	
	//ī��� ����� ��� ������
	String ip_method 		= request.getParameter("ip_method")	==null?"1":request.getParameter("ip_method");
	int    card_tax 	 	= request.getParameter("card_tax")	==null?0 :AddUtil.parseDigit(request.getParameter("card_tax"));

	String neom1 = "";
		
	//��Ÿ�Աݰ���
	String n_ven_code 		= request.getParameter("n_ven_code")	==null?"":request.getParameter("n_ven_code");
	String n_ven_name 		= request.getParameter("n_ven_name")	==null?"":request.getParameter("n_ven_name");
	String ip_acct 		= request.getParameter("ip_acct")	==null?"":request.getParameter("ip_acct");
	String acct_gubun 		= request.getParameter("acct_gubun")	==null?"4":request.getParameter("acct_gubun"); //��/�� ���� -> ����:D, �뺯:C
	
	String remark 		= request.getParameter("remark")	==null?"":request.getParameter("remark");
	String neom		= request.getParameter("neom")==null?"N":request.getParameter("neom"); 
	String s_neom		= request.getParameter("s_neom")==null?"N":request.getParameter("s_neom");  //�˻��� �ŷ�ó������ �󼼳�����ǥ���� 
	String cool		= request.getParameter("cool")==null?"N":request.getParameter("cool"); 
		
	//�Ա�ǥ
	String ebill		= request.getParameter("ebill")==null?"N":request.getParameter("ebill"); 
	
	String ext_msg = "";
	
	//������ �޼��� ����
     String gg_chk = "Y";
	      
	//��/������	
	String tax_yn = "N";	
		
	CarRegDatabase crd = CarRegDatabase.getInstance();

	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
			
	ClientBean client = new ClientBean();	
	
	String client_id = "";
	String site_id   = "";
	String car_st = "";   //����Ʈ car_st = '4'
			
	String value0[]  = request.getParameterValues("gubun");
	String value1[]  = request.getParameterValues("rent_st");
	String value2[]  = request.getParameterValues("rent_seq");
	String value3[]  = request.getParameterValues("fee_tm");
	String value4[]  = request.getParameterValues("tm_st1");//EXT_ID
	String value5[]  = request.getParameterValues("tm_st2");//EXT_ST
	String value6[]  = request.getParameterValues("est_amt"); //������
	String value7[]  = request.getParameterValues("pay_amt"); //�Աݾ�
	String value8[]  = request.getParameterValues("jan_amt");  //�ܾ�
	String value9[]  = request.getParameterValues("rent_mng_id");  
	String value10[] = request.getParameterValues("rent_l_cd");    
	String value11[] = request.getParameterValues("car_mng_id");
	String value12[] = request.getParameterValues("accid_id");
	String value13[] = request.getParameterValues("rtn_client_id");	
	String value14[] = request.getParameterValues("rent_s_cd");   //����Ʈ, �������
	String value15[] = request.getParameterValues("cls_amt");   //��/������ �� û�������� ���Ը� 1��
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));  //�׿������� ����	
	String node_code ="S101";  //�׿��� iu ������ ȸ�����:S101	
	
	Hashtable vendor = new Hashtable();	
	
	String ven_code = "";
	String s_ven_code = "";
	String car_no = "";	
	String docu_gubun = "";
	String amt_gubun = "";
	
	//neoe��  �����ⳳ�嶧���� ������ ��ü�� ó�� - ���ݵ�. 
	 docu_gubun = "3";		
	 amt_gubun = "2";	  

	//�ڵ���ǥó���� & ���ݰ�꼭
	Vector vt = new Vector();	
	String row_id = "";
	String ven_type = "";   //�ΰ��� ����
	String s_idno = "";	
	String client_st = "";
	String tax_no = "";
	String item_id = "";
  	String reg_code = "";	
	
  	int  a1_s_amt = 0;  //�뿩��
   	int  a1_v_amt = 0;
		
	boolean flag2 = true;
	int flag1 = 0;
	int flag = 0;
	int count =0;
	int line =0;
	String doc_cont = "";
	String rtn_client = "";
	String rent_s_cd = "";
	
	String i_enp_no 	= "";
	String i_ssn 		= "";
	String i_firm_nm 	= "";
	String i_client_nm 	= "";
	String i_sta 		= "";
	String i_item 		= "";
	String i_addr 		= "";
	String i_agnt_nm	= "";
	String i_agnt_email	= "";
	String i_agnt_m_tel = "";
	
	//���� ����
	String sendname = "(��)�Ƹ���ī";
	String sendphone = "02-392-4243";
	String first_id = "";			

	String card_nm =  "";
	
	boolean mail_chk = false;
	
	long t_pay_amt =  0;	//��Ÿ�Աݺ� ó���� ���		
	
	int i_tax_supply = 0;  //����Ʈ ī���� ��� ���ް�
	int i_tax_value = 0;  //����Ʈ ī���� ��� vat
		
	
	int cal_tax = 0;  //ī���� ��� ������ ����
	int a_cal_tax = 0; //����
	
	String green_chk = "";
	
	//�Ҽӿ����� ����Ʈ ��ȸ
	Hashtable br = c_db.getBranch("S1"); //������ ���� 	
		  	
	//�Աݿ��� ��� ó�� 
	IncomBean base = new IncomBean();
	
	base.setIncom_dt		(incom_dt);
	base.setIncom_amt		(incom_amt); //�Աݾ�
	base.setIncom_gubun		("2");  //��������
 	base.setIp_method		("1");   //���·� 
	base.setJung_type		("0");  //  �Աݴ��
	base.setP_gubun			("1");
	base.setPay_gur			("0");  //������������		
	base.setBank_nm		(bank_code);
	base.setBank_no		(deposit_no);
	base.setRemark		(request.getParameter("incom_naeyong")==null?"":request.getParameter("incom_naeyong"));
	base.setBank_office	(request.getParameter("incom_tr_branch")==null?"":request.getParameter("incom_tr_branch"));	
	base.setAcct_seq	(incom_acct_seq);
	base.setTr_date_seq	(incom_tr_date_seq);
	base.setReg_id			(user_id);
	
	//=====[incom] insert=====
	base = in_db.insertIncom(base);
	int incom_seq 	= base.getIncom_seq();
	
	//�������� �ƴ� ���
	if ( !not_yet.equals("1") ) {
	  
		for(int i=0 ; i < scd_size ; i++){
			
			ContBaseBean base2 = new ContBaseBean();	
			CarRegBean cr_bean  = new CarRegBean();
			
			if(!value9[i].equals("")){		//����Ʈ����
				//���⺻����
				base2 = a_db.getCont(value9[i], value10[i]);
										
				site_id = base2.getR_site();	
				first_id = base2.getBus_id();	
				car_st = base2.getCar_st();
									
					//�ڵ�������
				cr_bean = crd.getCarRegBean(base2.getCar_mng_id());		
				car_no =	cr_bean.getCar_no();
			}  else {	
				//�ڵ�������
				cr_bean = crd.getCarRegBean(value11[i]);		
				car_no =	cr_bean.getCar_no();
			}	
				
			rtn_client = value13[i]	==null?"":value13[i];  //�ŷ�ó (������??)	
			rent_s_cd = value14[i]	==null?"":value14[i];  //�ܱ��� ��  ����  - �����������. ����Ʈ(����), �������   	
			
			if ( !rent_s_cd.equals("") )	{		
					//�ܱ�������  - value1[i]: rent_st in('1', '2') -_rent_cont.bus_id  |   not in ('1', '2')  rent_cont.nvl(mng_id, bus_id)
					RentContBean rc_bean1 = rs_db.getRentContCase( value14[i], value11[i]);
					rtn_client = rc_bean1.getCust_id();			
			}
					
			if(!rtn_client.equals("")){
			
				client = al_db.getNewClient(rtn_client);
				ven_code = client.getVen_code();
				vendor = neoe_db.getVendorCase(ven_code);				
				client_st = client.getClient_st(); //2:����
				
				i_enp_no 		= client.getEnp_no1() + client.getEnp_no2() + client.getEnp_no3();
				if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() + client.getSsn2();
				i_ssn 			= client.getSsn1() + client.getSsn2();
				i_firm_nm 		= client.getFirm_nm();
				i_client_nm 	= client.getClient_nm();
				i_sta 			= Util.subData(client.getBus_cdt(),17);
				i_item 			= Util.subData(client.getBus_itm(),17);
				i_addr 			= client.getO_addr();
				i_agnt_nm		= client.getCon_agnt_nm();
				i_agnt_email	= client.getCon_agnt_email();
				i_agnt_m_tel	= client.getCon_agnt_m_tel();
					
				if(!site_id.equals("")){
					 if( !base2.getTax_type().equals("1")){ //���簡 �ƴ� ���
				
						//�ŷ�ó��������
						ClientSiteBean site = al_db.getClientSite(rtn_client, site_id);
						s_ven_code = site.getVen_code();
						if(!s_ven_code.equals("")){
							ven_code = s_ven_code;
							vendor = neoe_db.getVendorCase(ven_code);		
							i_enp_no 		= site.getEnp_no();
							i_firm_nm 		= site.getR_site();
							i_client_nm 	= site.getSite_jang();
							i_sta 			= Util.subData(site.getBus_cdt(),17);
							i_item 			= Util.subData(site.getBus_itm(),17);
							i_addr 			= site.getAddr();
							i_agnt_nm		= site.getAgnt_nm();
							i_agnt_email	= site.getAgnt_email();
							i_agnt_m_tel 	= site.getAgnt_m_tel();
						}	
					}	
				}
				
				if(!value9[i].equals("")){		//����Ʈ����										
						//�׿��� ���ݰ�꼭
					if(base2.getTax_type().equals("1")){ //����
						if(client_st.equals("2")){
								ven_type = "1";
								s_idno   =	i_ssn;	
												
						}else{
								ven_type = "0";
								s_idno   =	i_enp_no;		
						}
					}else{  //����
						if(i_enp_no.length() == 13){
								ven_type = "1";
								s_idno	 = i_enp_no;
						}else{
								ven_type = "0";
								s_idno   =	i_enp_no;
						}
					}
				} else { //����Ʈ�ΰ��
					if(client_st.equals("2")){
								ven_type = "1";
								s_idno   =	i_ssn;													
					}else{
								ven_type = "0";
								s_idno   =	i_enp_no;		
					}					
				}
											
				//���� check			
				for(int cc=0; cc< i_agnt_email.length(); cc++) {					
					if ( i_agnt_email.charAt(cc) == '@') {
						mail_chk = true;				       	
					}				
				}		
							
			}	
			
			int est_amt = value6[i]	==null?0 :AddUtil.parseDigit(value6[i]);
		  	int pay_amt = value7[i]	==null?0 :AddUtil.parseDigit(value7[i]);
		
			if(pay_amt != 0){
			
				if (s_neom.equals("Y")) {
					neom1 = "Y"; //���뿹�� ��ǥ���� 
				}else {
					neom1 = "N"; //���뿹�� ��ǥ���� 
				}
						
				//������ - ������, ������, ���ô뿩�� , ���ź�����
				if( value0[i].equals("scd_grt") || value0[i].equals("scd_pp") || value0[i].equals("scd_rfee") || value0[i].equals("scd_cha") || value0[i].equals("scd_green") ){
					
					String SeqId = "";
					String cha_gubun = "";  // ��å�� ���� 
										
					//��뷮ó���� ��� ������ ��� �ȵ�. 	- 20120502 �ϴ� ����	- 20121214 ���ι���			
					//�������� ��� - ������ ������ ����
					if ( value0[i].equals("scd_grt") && ebill.equals("Y")    ){	
															
						//�����Ա�ǥ�Ϸù�ȣ
					 	SeqId= IssueDb.getSeqIdNext("PayEBill","PE");
						System.out.println("Matching SeqId ="+SeqId+"|"+ value10[i] + "|" + rtn_client);
					}
						
													
					ExtScdBean pay_grt = ae_db.getAGrtScd(value9[i], value10[i], value1[i], value5[i], value3[i]);
											   
					   
					if ( value0[i].equals("scd_cha") ){
					    if ( pay_grt.getExt_v_amt() < 1 ) {
					    	cha_gubun = "Y";					    
					    }					
					}
					
					if (  value0[i].equals("scd_green") ){
							green_chk = "Y";
					    	cha_gubun = "Y";
					}					
					
					if ( value0[i].equals("scd_grt") && ebill.equals("Y")   ){	
						pay_grt.setSeqId(SeqId);
					}
					
				//	pay_grt.setExt_est_dt(incom_dt);
					pay_grt.setExt_pay_amt(pay_amt);
					pay_grt.setExt_pay_dt(incom_dt);
					pay_grt.setUpdate_id(user_id);
					pay_grt.setIncom_dt	(incom_dt); //�����ȣ
					pay_grt.setIncom_seq(incom_seq);//����
		
					if(!ae_db.receiptGrt(pay_grt))	flag += 1;
						
					//������ �ڵ���ǥ����					
					String acct_cont = "";
					
					if ( value0[i].equals("scd_grt")){
						acct_cont = "[���뿩������]"+ value10[i]+"("+client.getFirm_nm()+")";
					} else if (value0[i].equals("scd_pp")){
						acct_cont = "[������]"+ value10[i]+"("+client.getFirm_nm()+")";
					} else if (value0[i].equals("scd_rfee")){
						acct_cont = "[���ô뿩��]"+ value10[i]+"("+client.getFirm_nm()+")";
					} else if (value0[i].equals("scd_cha")){
						acct_cont = "[�°������]"+ value10[i]+"("+client.getFirm_nm()+")";	
					} else if (value0[i].equals("scd_green")){
						acct_cont = "[���ź�����]"+ value10[i]+"("+client.getFirm_nm()+")";		
					}	
						
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;
					
					//������
					Hashtable ht15 = new Hashtable();
					
					if ( value0[i].equals("scd_grt")){
					
						//������
						ht15.put("WRITE_DATE", 	incom_dt);  //row_id					
						ht15.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht15.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht15.put("CD_PC",  	node_code);  //ȸ�����
						ht15.put("CD_WDEPT",  dept_code);  //�μ�
						ht15.put("NO_DOCU",  	"");  //row_id�� ��' 
						ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht15.put("CD_COMPANY",  "1000");  
						ht15.put("ID_WRITE", insert_id);   
						ht15.put("CD_DOCU",  "11");  
											
						ht15.put("DT_ACCT",  incom_dt);  
						ht15.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht15.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
						ht15.put("CD_ACCT",  "31100");   //���뿩������
						ht15.put("AMT",    	String.valueOf(pay_amt));	
						ht15.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü						
						ht15.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
												
						ht15.put("DT_START",  "");  	//�߻�����									 
						ht15.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht15.put("CD_DEPT",		"");   //�μ�								 
						ht15.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht15.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht15.put("CD_CARD",		"");   //�ſ�ī��		 
						ht15.put("CD_EMPLOY",		"");   //���
						ht15.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht15.put("CD_BANK",		"");  //�������	
		 				ht15.put("NO_ITEM",		"");  //item	 
		 				
		 						// �ΰ�������
						ht15.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht15.put("AM_ADDTAX",	"" );	 //����
						ht15.put("TP_TAX",	"");  //����(����) :11
						ht15.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
						ht15.put("NM_NOTE", acct_cont);  // ����								
					
					} else {
					
					    if ( cha_gubun.equals("Y") ) {
							
							//�°������	 �Ǵ� ���ź�����  
							ht15.put("WRITE_DATE", 	incom_dt);  //row_id   							
							ht15.put("ROW_NO",  	String.valueOf(line)); //row_no							
							ht15.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
							ht15.put("CD_PC",  	node_code);  //ȸ�����
							ht15.put("CD_WDEPT",  dept_code);  //�μ�
							ht15.put("NO_DOCU",  	"");  //row_id�� ���� 
							ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
							ht15.put("CD_COMPANY",  "1000");  
							ht15.put("ID_WRITE", insert_id);   
							ht15.put("CD_DOCU",  "11");  
							
							ht15.put("DT_ACCT",  incom_dt);  
							ht15.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						//	ht15.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
																					
							if ( value0[i].equals("scd_green")){
									ht15.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
									if ( cr_bean.getCar_use().equals("1") ) { //��Ʈ�̸�
										ht15.put("CD_ACCT",  "21810");     //���ź����� 	
										ht15.put("CD_PARTNER",	"996189"); //�ŷ�ó    - A06										
									} else {
										ht15.put("CD_ACCT",  "22010");     //���ź�����
										ht15.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
									}																	
							} else {
								ht15.put("CD_ACCT",  "45510");   //��å��(91800)
								ht15.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
						//		ht15.put("CD_ACCT",  "91800");   //��å��(91800)
								ht15.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06							
							}						
														
					//		ht15.put("AMT",    	String.valueOf(pay_amt));	
							ht15.put("AMT",    	String.valueOf(pay_amt *(-1)));	
							ht15.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü								
				//			ht15.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
														
							ht15.put("DT_START",  "");  	//�߻�����									 
							ht15.put("CD_BIZAREA",		"");   //�ͼӻ����	
							ht15.put("CD_DEPT",		"");   //�μ�								 
							ht15.put("CD_CC",			"");   //�ڽ�Ʈ����		
							ht15.put("CD_PJT",			"");   //������Ʈ�ڵ�	
							ht15.put("CD_CARD",		"");   //�ſ�ī��		 	
							ht15.put("CD_EMPLOY",		"");   //���									 		 
							ht15.put("NO_DEPOSIT",	"");  //�����ݰ���
							ht15.put("CD_BANK",		"");  //�������	
		 					ht15.put("NO_ITEM",		"");  //item	  	
		 					
		 							// �ΰ�������
							ht15.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
							ht15.put("AM_ADDTAX",	"" );	 //����
							ht15.put("TP_TAX",	"");  //����(����) :11
							ht15.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ 
						
							ht15.put("NM_NOTE", acct_cont);  // ����								
					    
					    } else {
							//�ܻ�����
							
							ht15.put("WRITE_DATE", 	incom_dt);  //row_id							
							ht15.put("ROW_NO",  	String.valueOf(line)); //row_no							
							ht15.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
							ht15.put("CD_PC",  	node_code);  //ȸ�����
							ht15.put("CD_WDEPT",  dept_code);  //�μ�
							ht15.put("NO_DOCU",  	"");  //row_id�� ���� 
							ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
							ht15.put("CD_COMPANY",  "1000");  
							ht15.put("ID_WRITE", insert_id);   
							ht15.put("CD_DOCU",  "11");  
							
							ht15.put("DT_ACCT",  incom_dt);  
							ht15.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
							ht15.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
							ht15.put("CD_ACCT",  "10800");   // 
							ht15.put("AMT",    	String.valueOf(pay_amt));	
							ht15.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü							
							ht15.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
														
							ht15.put("DT_START",  "");  	//�߻�����										 
							ht15.put("CD_BIZAREA",		"");   //�ͼӻ����	
							ht15.put("CD_DEPT",		"");   //�μ�								 
							ht15.put("CD_CC",			"");   //�ڽ�Ʈ����		
							ht15.put("CD_PJT",			"");   //������Ʈ�ڵ�		
							ht15.put("CD_CARD",		"");   //�ſ�ī��		 	
							ht15.put("CD_EMPLOY",		"");   //���									 		 
							ht15.put("NO_DEPOSIT",	"");  //�����ݰ���
							ht15.put("CD_BANK",		"");  //�������	
		 					ht15.put("NO_ITEM",		"");  //item	  	  	
		 					
		 							// �ΰ�������
							ht15.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
							ht15.put("AM_ADDTAX",	"" );	 //����
							ht15.put("TP_TAX",	"");  //����(����) :11
							ht15.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ 
						
							ht15.put("NM_NOTE", acct_cont);  // ����													
						}			
					}
					
					if (s_neom.equals("Y")) {			
						vt.add(ht15);			
					}
				
				    //�������� ��� �Ա�ǥ����				    
				 	if ( value0[i].equals("scd_grt") && ebill.equals("Y")   ) {	
				 	
							//@,.�� �ְ�, �ڸ��� 5�� �̻�.
						if (  mail_chk && (AddUtil.lengthb(i_agnt_email) > 5 ) ) { 									
																						
							SaleEBillBean sb_bean = new SaleEBillBean();										
				
							sb_bean.setSeqID		(SeqId);
							sb_bean.setDocCode		("03");
							sb_bean.setRefCoRegNo	("");
							sb_bean.setRefCoName	("");
							sb_bean.setTaxSNum1		("");
							sb_bean.setTaxSNum2		("");
							sb_bean.setTaxSNum3		("");
							sb_bean.setDocAttr		("N");
							sb_bean.setOrigin		("");
							sb_bean.setPubDate		(incom_dt);
							sb_bean.setSystemCode	("KF");
							
							sb_bean.setDocKind		("03");
							sb_bean.setS_EbillKind	("1");//1:�Ϲ��Ա�ǥ 2:����Ź�Ա�ǥ					
							  
							//������------------------------------------------------------------------------------
							sb_bean.setMemID		("amazoncar11");
							sb_bean.setMemName		(user_bean.getUser_nm());
							sb_bean.setEmail		("tax@amazoncar.co.kr");		//��꼭 ��� ���� �ּ�
							sb_bean.setTel			("02-392-4243");
															
							sb_bean.setCoRegNo		(String.valueOf(br.get("BR_ENT_NO")));
							sb_bean.setCoName		("(��)�Ƹ���ī");
							sb_bean.setCoCeo		(String.valueOf(br.get("BR_OWN_NM")));
							sb_bean.setCoAddr		(String.valueOf(br.get("BR_ADDR")));
							sb_bean.setCoBizType	(String.valueOf(br.get("BR_STA")));
							sb_bean.setCoBizSub		(String.valueOf(br.get("BR_ITEM")));
							
							//���޹޴���--------------------------------------------------------------------------
							sb_bean.setRecMemID		("");
							sb_bean.setRecMemName	(i_agnt_nm);
							sb_bean.setRecEMail		(i_agnt_email);
							sb_bean.setRecTel		(i_agnt_m_tel);
																		
							sb_bean.setRemarks	("���뿩������-" + value10[i]);
							sb_bean.setRecCoRegNo(i_enp_no);
								
							sb_bean.setItemName1	("���뿩������");
							sb_bean.setRecCoName	(i_firm_nm);
							sb_bean.setRecCoCeo		(i_client_nm);
							sb_bean.setRecCoAddr	(i_addr);
							sb_bean.setRecCoBizType	(i_sta);
							sb_bean.setRecCoBizSub	(i_item);					
														
							//����-----------------------------------------------------------------------------------
							sb_bean.setSupPrice		(pay_amt);
							sb_bean.setTax			(0);
							sb_bean.setPubKind		("N");
							sb_bean.setLoadStatus	(0);
							sb_bean.setPubCode		("");
							sb_bean.setPubStatus	("");
							sb_bean.setClient_id	(rtn_client);
							
							if(!IssueDb.insertPayEBill(sb_bean)) 	flag += 1;
						}	
					}					
															
					if ( green_chk.equals("") ) { //ģȯ������ �ƴϰ�츸 ���� ���� 
				
					   if ( value0[i].equals("scd_grt")  || value0[i].equals("scd_pp")  ||  value0[i].equals("scd_rfee")   ){
					   		 	if ( value0[i].equals("scd_grt")){
					   				 ext_msg = "���뿩������";
					   			} else if (value0[i].equals("scd_pp")){
					   			    ext_msg = "������";
					   			} else if (value0[i].equals("scd_rfee")){  
					   		   		ext_msg = "���ô뿩��";
					   		   }
					   		   
								//���ڹ߼� - �� & ���ʿ�����					
								if(!i_agnt_m_tel.equals("")){ //��					
									
									at_db.sendMessage(1009, "0",  i_firm_nm+"�� " + ext_msg + "  �Ա� ó���Ǿ����ϴ�.-�Ƹ���ī-", i_agnt_m_tel, sendphone, null, value10[i],  "999999");		
													
								}
													
								//���ʿ�����
								UsersBean target_bean 	= umd.getUsersBean(first_id);						
								String destphone 	= target_bean.getUser_m_tel();
								String destname 	= target_bean.getUser_nm();
											
								if(!target_bean.getUser_m_tel().equals("")){
								
									
									at_db.sendMessage(1009, "0",  i_firm_nm+"�� " + ext_msg + "  �Ա� ó���Ǿ����ϴ�.-�Ƹ���ī-", destphone, sendphone, null, value10[i],  "999999");	
							
									
								}		
					  }										
					}							
				//�뿩��
				}else if(value0[i].equals("scd_fee")){
								
					FeeScdBean pay_fee = af_db.getScdNew(value9[i], value10[i], value1[i], value2[i], value3[i], value4[i]);
					
					pay_fee.setRc_yn	("1");
					pay_fee.setRc_dt	(incom_dt);
					pay_fee.setRc_amt	(pay_amt);
					pay_fee.setUpdate_id(user_id);
					pay_fee.setIncom_dt	(incom_dt); //�����ȣ
					pay_fee.setIncom_seq(incom_seq);
									
					if(!af_db.updateFeeScd(pay_fee))	flag += 1;
					
					if(pay_amt == (pay_fee.getFee_s_amt()+pay_fee.getFee_v_amt())){
						out.println("�����Ա�ó��="+pay_amt+", ");
					}else{
						out.println("�κ��Ա�ó��="+pay_amt+", ");
						
						int rest_amt 	= (pay_fee.getFee_s_amt()+pay_fee.getFee_v_amt()) - pay_amt;
						int rest_s_amt 	= (new Double(rest_amt/1.1)).intValue();
						out.println(" �ܾ׻���="+rest_amt);
						
						FeeScdBean rest_fee = new FeeScdBean();
						rest_fee.setRent_mng_id	(pay_fee.getRent_mng_id());
						rest_fee.setRent_l_cd	(pay_fee.getRent_l_cd());
						rest_fee.setFee_tm		(pay_fee.getFee_tm());
						rest_fee.setRent_st		(pay_fee.getRent_st());
						rest_fee.setRent_seq	(pay_fee.getRent_seq());
						rest_fee.setTm_st1		(String.valueOf(Integer.parseInt(pay_fee.getTm_st1())+1));	//�ܾ״뿩��. ���� ȸ������+1
						rest_fee.setTm_st2		(pay_fee.getTm_st2());										//�Ϲݴ뿩��.....
						rest_fee.setFee_est_dt	(pay_fee.getFee_est_dt());									//�� �뿩���� �Աݿ�����
						rest_fee.setFee_s_amt	(rest_s_amt);
						rest_fee.setFee_v_amt	(rest_amt - rest_s_amt);
						rest_fee.setDly_days	("0");	
						rest_fee.setDly_fee		(0);	
						rest_fee.setRc_yn		("0");															//default�� 0(�̼���)
						rest_fee.setRc_dt		("");
						rest_fee.setRc_amt		(0);
						rest_fee.setUpdate_id	(user_id);
						rest_fee.setR_fee_est_dt(af_db.getValidDt(pay_fee.getR_fee_est_dt())); 				//���� : �Աݿ������� �״�� ����.(20031030)
						rest_fee.setBill_yn		("Y");
						rest_fee.setRent_seq	(pay_fee.getRent_seq());
						rest_fee.setReq_dt		(pay_fee.getReq_dt());
						rest_fee.setR_req_dt	(pay_fee.getR_req_dt());
						rest_fee.setTax_out_dt	(pay_fee.getTax_out_dt());
						rest_fee.setUse_s_dt	(pay_fee.getUse_s_dt());
						rest_fee.setUse_e_dt	(pay_fee.getUse_e_dt());
						
						if(!af_db.insertFeeScdAdd(rest_fee))	flag += 1;
					}
					
					//20111212 �߰� - ���� ��������� ���� - ä�ǵ�� ��ü�� ���� �߰� ��
					//�⺻����
					Hashtable f_fee = af_db.getFeebaseNew(value9[i], value10[i]);
					
					//��������
					ClsBean cls = ass_db.getClsCase(value9[i], value10[i]);
	
					//��ü�� ���� - �ŷ����� ��ü���� �߰��� ���ؼ� ���� 20130429
					boolean dly_flag = af_db.calDelayDtPrint(value9[i], value10[i], cls.getCls_dt(), String.valueOf(f_fee.get("RENT_DT")));
									
					//�뿩�� �ڵ���ǥ����
					//�����̸鼭 site_id�� �ִ� ���
					int fee_rtn_cnt = in_db.getFeeRtnCnt(value9[i], value10[i]);
					if (fee_rtn_cnt > 0 ) {
						  String f_ven_code = in_db.getFeeRtnVencode(value9[i], value10[i], value1[i], value2[i] );
						  if ( !f_ven_code.equals("")) {
						 	  ven_code = f_ven_code;
							  vendor = neoe_db.getVendorCase(ven_code);		
						  }	  						
					}			  		      				                      				                
										
					String acct_cont = "";					
					if ( ip_method.equals("2") ) {
						 acct_cont = "[ī��뿩��]"+pay_fee.getFee_tm()+"ȸ��:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					} else {
						 acct_cont = "[�뿩��]"+pay_fee.getFee_tm()+"ȸ��:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					}
					
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;
					
					//�ܻ�����
					Hashtable ht2 = new Hashtable();

					ht2.put("WRITE_DATE", 	incom_dt);  //row_id				
					ht2.put("ROW_NO",  	String.valueOf(line)); //row_no					
					ht2.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht2.put("CD_PC",  	node_code);  //ȸ�����
					ht2.put("CD_WDEPT",  dept_code);  //�μ�
					ht2.put("NO_DOCU",  	"");  //row_id�� ���� 
					ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht2.put("CD_COMPANY",  "1000");  
					ht2.put("ID_WRITE", insert_id);   
					ht2.put("CD_DOCU",  "11");  
					
					ht2.put("DT_ACCT",  incom_dt);  
					ht2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht2.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
					ht2.put("CD_ACCT",  "10800");   // 
					ht2.put("AMT",    	String.valueOf(pay_amt));	
					ht2.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü					
					ht2.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
									
					ht2.put("DT_START",  "");  	//�߻�����							 
					ht2.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht2.put("CD_DEPT",			"");   //�μ�								 
					ht2.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht2.put("CD_CARD",		"");   //�ſ�ī��
					ht2.put("CD_EMPLOY",		"");   //���							 		 
					ht2.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht2.put("CD_BANK",		"");  //�������	
		 			ht2.put("NO_ITEM",		"");  //item 
				
							// �ΰ�������
					ht2.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht2.put("AM_ADDTAX",	"" );	 //����
					ht2.put("TP_TAX",	"");  //����(����) :11
					ht2.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
		
					ht2.put("NM_NOTE", acct_cont);  // ����								
						
					if (s_neom.equals("Y")) {				
						vt.add(ht2);
					}
										
					//20130117 �ݿ�	
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP") ||  card_nm.equals("KCP2") ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);
					 	} else 	if ( card_nm.equals("���̿�") ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.32);	
						}  else if ( card_nm.equals("�̳�����")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);						 								 	
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}
								
					//�̹��� �뿩�� ���ݰ�꼭 ����
					//�ش�뿩�� ��꼭 ���� ����
								
				   
					 //�̹����꼭�� �ִ� ��� �޼��� ������ .								
					if ( AddUtil.parseInt(pay_fee.getReq_dt().substring(0,4)+ pay_fee.getReq_dt().substring(5,7)+ pay_fee.getReq_dt().substring(8,10)) < AddUtil.parseInt(incom_dt) ) {
					
						int stop_cnt = in_db.getFeeScdStop(value9[i], value10[i]);
						
						if (stop_cnt < 1) {
							int tax_cnt = IssueDb.getTaxMakeCheck2(value10[i], value3[i], value1[i], value2[i]);					
							
						    if (tax_cnt < 1) { //��꼭 �̹���
						    
						       	   int tax_item_cnt  = IssueDb.getTaxMakeCheck3(value10[i], value3[i], value1[i], value2[i]);		
						       
							   if (tax_item_cnt < 1) {  //�ŷ����� �̹���
							    
											      //����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
											UsersBean sender_bean 	= umd.getUsersBean(user_id);
													
											String sub 		= "�뿩�� ��꼭 �����û";
											String cont 	= "�� �뿩�� ��꼭 �����û :: "+pay_fee.getFee_tm()+"ȸ��:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") �Ա���:"+ incom_dt + ", �Աݾ�: "+ pay_amt ;  	
																
											String url 		= "";				
																
											url 		= "/tax/issue_1/issue_1_frame.jsp";		 
										
											String target_id =nm_db.getWorkAuthUser("���ݰ�꼭�����"); 	   // "000131"; //��꼭 �����		//000113->000058->�Ǹ��(000131) -> 000129(���μ�)
													
											//����� ���� ��ȸ
											UsersBean target_bean 	= umd.getUsersBean(target_id);
											
											String xml_data = "";
											xml_data =  "<COOLMSG>"+
										  				"<ALERTMSG>"+
										  				"    <BACKIMG>4</BACKIMG>"+
										  				"    <MSGTYPE>104</MSGTYPE>"+
										  				"    <SUB>"+sub+"</SUB>"+
										  				"    <CONT>"+cont+"</CONT>"+
										 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+url+"</URL>";
											
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
											
											if ( !car_st.equals("4")  ) {
												flag2 = cm_db.insertCoolMsg(msg);												
												System.out.println("��޽���(�뿩���꼭�����û�Ƿ�) "+pay_fee.getFee_tm()+"ȸ��:"+cr_bean.getCar_no()+"---------------------"+target_bean.getUser_nm());
											}							    
							       }//tax_item_cnt
						    } //tax_cnt						    
						}    
						    
				    } //�޼��� ������
							
				//��ü��
				}else if(value0[i].equals("scd_dly")){
					out.println("��ü���Ա�ó��="+pay_amt+", ");
					
					FeeDlyScdBean dly_bean = new FeeDlyScdBean();
					dly_bean.setRent_mng_id	(value9[i]);
					dly_bean.setRent_l_cd	(value10[i]);
					dly_bean.setPay_amt		(pay_amt);
					dly_bean.setPay_dt		(incom_dt);
					dly_bean.setEtc			("�����Ա�");
					dly_bean.setReg_id		(user_id);
					dly_bean.setIncom_dt	(incom_dt); //�����ȣ
					dly_bean.setIncom_seq	(incom_seq);
					
					if(!af_db.insertFeeDlyScd( dly_bean)) flag += 1; //���� ��ü�� ���
									
					//��ü�� �ڵ���ǥ����					
				
					String acct_cont = "";					
					if ( ip_method.equals("2") ) {
					   acct_cont = "[ī�忬ü��]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					} else {
					   acct_cont = "[��ü��]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					}
					
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;
					
					//��ü�����
					Hashtable ht2 = new Hashtable();
					
					ht2.put("WRITE_DATE", 	incom_dt);  //row_id					
					ht2.put("ROW_NO",  	String.valueOf(line)); //row_no					
					ht2.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht2.put("CD_PC",  	node_code);  //ȸ�����
					ht2.put("CD_WDEPT",  dept_code);  //�μ�
					ht2.put("NO_DOCU",  	"");  //row_id�� ���� 
					ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht2.put("CD_COMPANY",  "1000");  
					ht2.put("ID_WRITE", insert_id);   
					ht2.put("CD_DOCU",  "11");  
					
					ht2.put("DT_ACCT",  incom_dt);  
					ht2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht2.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
					ht2.put("CD_ACCT",  "91300");   // 
					ht2.put("AMT",    	String.valueOf(pay_amt));	
					ht2.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü					
					ht2.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
									
					ht2.put("DT_START",  "");  	//�߻�����							 
					ht2.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht2.put("CD_DEPT",			"");   //�μ�								 
					ht2.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht2.put("CD_PJT",			"");   //������Ʈ�ڵ�	
					ht2.put("CD_CARD",		"");   //�ſ�ī��	
					ht2.put("CD_EMPLOY",		"");   //���							 		 
					ht2.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht2.put("CD_BANK",		"");  //�������	
		 			ht2.put("NO_ITEM",		"");  //item 
				
							// �ΰ�������
					ht2.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht2.put("AM_ADDTAX",	"" );	 //����
					ht2.put("TP_TAX",	"");  //����(����) :11
					ht2.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
		
					ht2.put("NM_NOTE", acct_cont);  // ����								
									
					if (s_neom.equals("Y")) {					
						vt.add(ht2);
					}
					
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP") ||  card_nm.equals("KCP2")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);			
					 	}  else if ( card_nm.equals("���̿�")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.32);					 	
						}  else if ( card_nm.equals("�̳�����")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);					 	
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}	
					
					//���·�
				}else if(value0[i].equals("scd_fine")){
					out.println("���·��Ա�ó��="+pay_amt+", ");
					
					String vio_pla = "";
					String vio_dt = "";
					String proxy_dt = "";
				         String f_reg_id = ""; //���ʵ����  �λ�:000107
					
					f_bean = a_fdb.getForfeitDetailAll( value11[i], value9[i], value10[i], value5[i]);
					
					vio_pla = f_bean.getVio_pla();
					vio_dt = f_bean.getVio_dt();
					proxy_dt = f_bean.getProxy_dt(); //��������
					f_reg_id = f_bean.getReg_id(); //���ʵ����  �λ�:000107
					
					f_bean.setColl_dt(incom_dt);
					f_bean.setUpdate_id(user_id);
					f_bean.setUpdate_dt(AddUtil.getDate());						
					f_bean.setIncom_dt	(incom_dt); //�����ȣ
					f_bean.setIncom_seq	(incom_seq);
											
					count = a_fdb.updateForfeit(f_bean);			
					
					//������ ��� ����		
					if ( proxy_dt.equals("") ) {		
					
					  //����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
						UsersBean sender_bean 	= umd.getUsersBean(user_id);
								
						String sub 		= "���·� ���Կ�û";
						String cont 	= "�� ���·� ���Կ�û :: "+ client.getFirm_nm() + ", " + cr_bean.getCar_no() + ", �Ա���:"+ incom_dt + ", �Աݾ�: "+ pay_amt +", �������:" + vio_pla + ", ������:"+ vio_dt;  	
													
						String url 		= "";				
											
						url 		= "/acar/fine_mng/fine_mng_frame.jsp?c_id="+value11[i]+"|m_id="+value9[i]+"|l_cd="+value10[i]+"|seq_no="+value5[i];		 
				
						String target_id =nm_db.getWorkAuthUser("���·�����"); 
													
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
							
						System.out.println("��޽���(���·ᳳ�Կ�û�Ƿ�)"+cr_bean.getCar_no()+", ������:"+ vio_dt+ " --------------------"+target_bean.getUser_nm());	
					}				
													
					//���·� �ڵ���ǥ����				
					
					String acct_cont = "";					
					if ( ip_method.equals("2") ) {
					  acct_cont = "[ī����·�]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") " + vio_pla;
					} else {
					  acct_cont = "[���·�]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") " + vio_pla;
					}
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;					
					
					Hashtable ht14 = new Hashtable();
					
					ht14.put("WRITE_DATE", 	incom_dt);  //row_id				
					ht14.put("ROW_NO",  	String.valueOf(line)); //row_no					
					ht14.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht14.put("CD_PC",  	node_code);  //ȸ�����
					ht14.put("CD_WDEPT",  dept_code);  //�μ�
					ht14.put("NO_DOCU",  	"");  //row_id�� ���� 
					ht14.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht14.put("CD_COMPANY",  "1000");  
					ht14.put("ID_WRITE", insert_id);   
					ht14.put("CD_DOCU",  "11");  
					
					ht14.put("DT_ACCT",  incom_dt);  
					ht14.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht14.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
					ht14.put("CD_ACCT",  "12400");   //���·Ό����(27400) : , ���·�̼��� (12400)
					ht14.put("AMT",    	String.valueOf(pay_amt));	
					ht14.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü						
					ht14.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
									
					ht14.put("DT_START",  "");  	//�߻�����							 
					ht14.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht14.put("CD_DEPT",		"");   //�μ�								 
					ht14.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht14.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht14.put("CD_CARD",		"");   //�ſ�ī��	
					ht14.put("CD_EMPLOY",		"");   //���						
					ht14.put("NO_DEPOSIT",	 "");  //�����ݰ���
					ht14.put("CD_BANK",		"");  //�������	
		 			ht14.put("NO_ITEM",		"");  //item
		 			
		 					// �ΰ�������
					ht14.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht14.put("AM_ADDTAX",	"" );	 //����
					ht14.put("TP_TAX",	"");  //����(����) :11
					ht14.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
					ht14.put("NM_NOTE", acct_cont);  // ����								
									
					if (s_neom.equals("Y")) {				
						vt.add(ht14);  // ���·�	
					}	
					
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP") ||  card_nm.equals("KCP2") ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);	
					  	}  else if ( card_nm.equals("���̿�")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.32);					 		
						}  else if ( card_nm.equals("�̳�����")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);						 	
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}
						
				//��Ÿó������	- ��������, �ڵ����� ȯ�� ��
								
				//��å��
				}else if(value0[i].equals("scd_serv")){
					
					InsMScdBean cng_ins_ms = ae_db.getScd(value9[i], value10[i], value11[i], value12[i], value4[i], value3[i]);
					
					cng_ins_ms.setCust_pay_dt(incom_dt);
					cng_ins_ms.setPay_amt(pay_amt);
					cng_ins_ms.setUpdate_id(user_id);
					
					if(!ae_db.updateInsMScd(cng_ins_ms, "p", "1", incom_dt, incom_seq)) flag += 1; //
								
					out.println(cng_ins_ms.getRent_mng_id());
					out.println(cng_ins_ms.getRent_l_cd());
					out.println(cng_ins_ms.getCar_mng_id());
					out.println(cng_ins_ms.getServ_id());
					
				  //�Ա�ǥ�����û����  	  
					if ( cng_ins_ms.getSaleebill_yn().equals("1")  ) {
					
							//�����Ա�ǥ�Ϸù�ȣ
						   String SeqId1 = "";
					 		SeqId1= IssueDb.getSeqIdNext("PayEBill","PE");
							System.out.println("SeqId1 ="+SeqId1+"|"+ value10[i]);
												
							SaleEBillBean sb_bean1 = new SaleEBillBean();										
				
							sb_bean1.setSeqID		(SeqId1);
							sb_bean1.setDocCode		("03");
							sb_bean1.setRefCoRegNo	("");
							sb_bean1.setRefCoName	("");
							sb_bean1.setTaxSNum1		("");
							sb_bean1.setTaxSNum2		("");
							sb_bean1.setTaxSNum3		("");
							sb_bean1.setDocAttr		("N");
							sb_bean1.setOrigin		("");
							sb_bean1.setPubDate		(incom_dt);
							sb_bean1.setSystemCode	("KF");
							
							sb_bean1.setDocKind		("03");
							sb_bean1.setS_EbillKind	("1");//1:�Ϲ��Ա�ǥ 2:����Ź�Ա�ǥ					
							  
							//������------------------------------------------------------------------------------
							sb_bean1.setMemID		("amazoncar11");
							sb_bean1.setMemName		(user_bean.getUser_nm());
							sb_bean1.setEmail		("tax@amazoncar.co.kr");		//��꼭 ��� ���� �ּ�
							sb_bean1.setTel			("02-392-4243");
																		
							sb_bean1.setCoRegNo		(String.valueOf(br.get("BR_ENT_NO")));
							sb_bean1.setCoName		("(��)�Ƹ���ī");
							sb_bean1.setCoCeo		(String.valueOf(br.get("BR_OWN_NM")));
							sb_bean1.setCoAddr		(String.valueOf(br.get("BR_ADDR")));
							sb_bean1.setCoBizType	(String.valueOf(br.get("BR_STA")));
							sb_bean1.setCoBizSub		(String.valueOf(br.get("BR_ITEM")));
							
							//���޹޴���--------------------------------------------------------------------------
							sb_bean1.setRecMemID		("");
							sb_bean1.setRecMemName	(i_agnt_nm);
							
							if ( !cng_ins_ms.getAgnt_email().equals("") ) {
								sb_bean1.setRecEMail		(cng_ins_ms.getAgnt_email());
								sb_bean1.setRecTel		("");
							} else {	
								sb_bean1.setRecEMail	(i_agnt_email);
								sb_bean1.setRecTel		(i_agnt_m_tel);												
							}
												
							sb_bean1.setRemarks	("��å�� - " + cr_bean.getCar_no());
							sb_bean1.setRecCoRegNo(i_enp_no);
								
							sb_bean1.setItemName1	("��å��");
							sb_bean1.setRecCoName	(i_firm_nm);
							sb_bean1.setRecCoCeo		(i_client_nm);
							sb_bean1.setRecCoAddr	(i_addr);
							sb_bean1.setRecCoBizType	(i_sta);
							sb_bean1.setRecCoBizSub	(i_item);					
														
							//����-----------------------------------------------------------------------------------
							sb_bean1.setSupPrice		(pay_amt);
							sb_bean1.setTax			(0);
							sb_bean1.setPubKind		("N");
							sb_bean1.setLoadStatus	(0);
							sb_bean1.setPubCode		("");
							sb_bean1.setPubStatus	("");
							
							if(!IssueDb.insertPayEBill(sb_bean1)) 	flag += 1;		
							
						//	if(!ae_db.updateScdExtSeqId(value9[i], value10[i], cng_ins_ms.getRent_st(),  value3[i], SeqId1, "car_ja" ))	flag += 1;
							if(!ae_db.updateScdExtSeqId(value9[i], value10[i], cng_ins_ms.getRent_st(),  value4[i],  value3[i], SeqId1, "car_ja" ))	flag += 1;   //value
					
					}
														
					//��å�� �ڵ���ǥ����
					
					String acct_cont = "";					
					if ( ip_method.equals("2") ) {
						 acct_cont = "[ī���å��]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					} else {
					     acct_cont = "[��å��]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					}
					
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}							
														
					line++;
					
					Hashtable ht2 = new Hashtable();
					
					//�ܻ�����
					if( cng_ins_ms.getBill_doc_yn().equals("1") ){
					
						ht2.put("WRITE_DATE", 	incom_dt);  //row_id				
						ht2.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht2.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht2.put("CD_PC",  	node_code);  //ȸ�����
						ht2.put("CD_WDEPT",  dept_code);  //�μ�
						ht2.put("NO_DOCU",  	"");  //row_id �� ���� 
						ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht2.put("CD_COMPANY",  "1000");  
						ht2.put("ID_WRITE", insert_id);   
						ht2.put("CD_DOCU",  "11");  
						
						ht2.put("DT_ACCT",  incom_dt);  
						ht2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht2.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
						ht2.put("CD_ACCT",  "10800");   // 
						ht2.put("AMT",    	String.valueOf(pay_amt));	
						ht2.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü						
						ht2.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
													 
						ht2.put("DT_START",  "");  	//�߻�����									 
						ht2.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht2.put("CD_DEPT",			"");   //�μ�								 
						ht2.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht2.put("CD_CARD",		"");   //�ſ�ī��		
						ht2.put("CD_EMPLOY",		"");   //���								 		 
						ht2.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht2.put("CD_BANK",		"");  //�������	
		 				ht2.put("NO_ITEM",		"");  //item	 
		 				
		 						// �ΰ�������
						ht2.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht2.put("AM_ADDTAX",	"" );	 //����
						ht2.put("TP_TAX",	"");  //����(����) :11
						ht2.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
						ht2.put("NM_NOTE", acct_cont);  // ����								
										
					//�������ظ�å��
					}else{
					
						ht2.put("WRITE_DATE", 	incom_dt);  //row_id					
						ht2.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht2.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht2.put("CD_PC",  	node_code);  //ȸ�����
						ht2.put("CD_WDEPT",  dept_code);  //�μ�
						ht2.put("NO_DOCU",  	"");  //row_id �� ���� 						
						ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht2.put("CD_COMPANY",  "1000");  
						ht2.put("ID_WRITE",  insert_id);   
						ht2.put("CD_DOCU",  "11");  
						
						ht2.put("DT_ACCT",  incom_dt);  
						ht2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht2.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
						ht2.put("CD_ACCT",  "45510");   //��å��(91800) -> 45510
					//	ht2.put("AMT",    	String.valueOf(pay_amt));	
						ht2.put("AMT",    	String.valueOf(pay_amt *(-1)));	
						ht2.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü							
						ht2.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
													
						ht2.put("DT_START",  "");  	//�߻�����									 
						ht2.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht2.put("CD_DEPT",		"");   //�μ�								 
						ht2.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht2.put("CD_CARD",		"");   //�ſ�ī��		
						ht2.put("CD_EMPLOY",		"");   //���								 		 
						ht2.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht2.put("CD_BANK",		"");  //�������	
		 				ht2.put("NO_ITEM",		"");  //item	 	
		 				
		 						// �ΰ�������
						ht2.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht2.put("AM_ADDTAX",	"" );	 //����
						ht2.put("TP_TAX",	"");  //����(����) :11
						ht2.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ 	 
					
						ht2.put("NM_NOTE", acct_cont);  // ����									
					
					}
					
					if (s_neom.equals("Y")) {	
						vt.add(ht2);
					}	
				
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP")  || card_nm.equals("KCP2")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);		
					  	}  else if ( card_nm.equals("���̿�")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.32);		
						}  else if ( card_nm.equals("�̳�����")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);		
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}
							
					//��/������
				}else if(value0[i].equals("scd_insh")){
					out.println("��/�������Ա�ó��="+pay_amt+", ");
					
					MyAccidBean ma_bean = ae_db.getAccidScd(value9[i], value10[i], value11[i], value12[i], AddUtil.parseInt(value5[i]), value3[i]);
			
					//�������������� ��ȯ - 20110209
					ma_bean.setIns_pay_amt	(pay_amt);	//�Աݾ�
					ma_bean.setIns_pay_dt	(incom_dt);	//�Ա�����					
					ma_bean.setUpdate_id(user_id);				
					ma_bean.setPay_gu		(value4[i]);  //1:������ 2:������
					ma_bean.setIncom_dt	(incom_dt); //�����ȣ
					ma_bean.setIncom_seq	(incom_seq);
					
					if(!ae_db.updateAccidMScd(ma_bean, "p", "1", incom_dt, incom_seq)) flag += 1; //
					
					//û���� ������� - - ���� ������ ó�� - 20211206 
					if ( value15[i].equals("1")) 	value4[i] = "1";
					
					//�������ϰ�� ��꼭�����û�޽����߼�---------------------------
					if(!value13[i].equals("000228") && !value13[i].equals("000231") && value4[i].equals("2")){
						
						//���ݰ�꼭 ��ȸ
						tax.TaxBean t_bean 		= IssueDb.getTax_accid(value10[i], value11[i], value12[i], value5[i] );
												
						//�̹���
						if(t_bean.getTax_dt().equals("")){
							tax_yn = "Y";
						//����� - 
						}else{
							tax_yn = "U";
							tax_no = t_bean.getTax_no();
							
							//�Աݱݾ��� û���ݾװ� Ʋ�� ���
							int o_tax_amt = t_bean.getTax_supply()+t_bean.getTax_value();
							int n_tax_amt = o_tax_amt - pay_amt;
							
							if(n_tax_amt==0){
								tax_yn = "";
							}							
						}						
						
						if (tax_yn.equals("Y") || tax_yn.equals("U") ) {
							//�����ȸ
							AccidentBean a_bean = as_db.getAccidentBean(value11[i], value12[i]);
								
						  //����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
							UsersBean sender_bean 	= umd.getUsersBean(user_id);
									
							String sub 		= "�������꼭�����û";
							String cont 	= "�� �������꼭�����û :: "+ i_firm_nm + ", " + cr_bean.getCar_no() + ", ����Ͻ�:" + a_bean.getAccid_dt()+ ", �Ա���:"+ incom_dt + ", �Աݾ�: "+ pay_amt;  	
														
							String url 		= "";		 
							
							if ( tax_yn.equals("Y") ) {
								url 		= "/tax/issue_3/issue_3_sc9.jsp";		 
							} else {
								url 		= "/tax/tax_mng/tax_mng_u_m.jsp?tax_no="+tax_no;	
							}	 
							
							String target_id =nm_db.getWorkAuthUser("CMS����");  //�Աݴ����
																						
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
							
				//			flag2 = cm_db.insertCoolMsg(msg);
								
							System.out.println("��޽���(�������꼭�����Ƿ�)"+cr_bean.getCar_no()+"---------------------"+target_bean.getUser_nm());	
						
						}				
					}
										
					// ��/������ �ڵ���ǥ����					
					String acct_cont = "";
					
					if (value4[i].equals("1")){
						acct_cont = "[������]"+ value10[i]+"("+cr_bean.getCar_no()+")";
					} else if (value4[i].equals("2")){
						acct_cont = "[������]"+ value10[i]+"("+cr_bean.getCar_no()+")";
					}	
						
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}					
												
					line++;
					
					//��/������
					Hashtable ht3 = new Hashtable();
										
					//�ܻ����� -- ������
					if (value4[i].equals("2")){
					
						ht3.put("WRITE_DATE", 	incom_dt);  //row_id						
						ht3.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht3.put("CD_PC",  	node_code);  //ȸ�����
						ht3.put("CD_WDEPT",  dept_code);  //�μ�
						ht3.put("NO_DOCU",  	"");  //row_id�� ���� 
						ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht3.put("CD_COMPANY",  "1000");  
						ht3.put("ID_WRITE", insert_id);   
						ht3.put("CD_DOCU",  "11");  
						
						ht3.put("DT_ACCT",  incom_dt);  
						ht3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht3.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
						ht3.put("CD_ACCT",  "10800");   // 
						ht3.put("AMT",    	String.valueOf(pay_amt));	
						ht3.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü						
						ht3.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
												
						ht3.put("DT_START",  "");  	//�߻�����									 
						ht3.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht3.put("CD_DEPT",			"");   //�μ�								 
						ht3.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht3.put("CD_PJT",			"");   //������Ʈ�ڵ�	
						ht3.put("CD_CARD",		"");   //�ſ�ī��		
						ht3.put("CD_EMPLOY",		"");   //���								 		 
						ht3.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht3.put("CD_BANK",		"");  //�������	
		 				ht3.put("NO_ITEM",		"");  //item	 
		 				
		 						// �ΰ�������
						ht3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht3.put("AM_ADDTAX",	"" );	 //����
						ht3.put("TP_TAX",	"");  //����(����) :11
						ht3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
						ht3.put("NM_NOTE", acct_cont);  // ����							
					
					//�������ظ�å��
					}else{
					
						ht3.put("WRITE_DATE", 	incom_dt);  //row_id				
						ht3.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht3.put("CD_PC",  	node_code);  //ȸ�����
						ht3.put("CD_WDEPT",  dept_code);  //�μ�
						ht3.put("NO_DOCU",  	"");  //row_id�� ���� 
						ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht3.put("CD_COMPANY",  "1000");  
						ht3.put("ID_WRITE", insert_id);   
						ht3.put("CD_DOCU",  "11");  
						
						ht3.put("DT_ACCT",  incom_dt);  
						ht3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht3.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
						ht3.put("CD_ACCT",  "45510");   //��å��(91800) -> 45510
					//	ht3.put("AMT",    	String.valueOf(pay_amt));	
						ht3.put("AMT",    	String.valueOf(pay_amt *(-1)));	
						ht3.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü						
						ht3.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
												
						ht3.put("DT_START",  "");  	//�߻�����									 
						ht3.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht3.put("CD_DEPT",			"");   //�μ�								 
						ht3.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht3.put("CD_CARD",		"");   //�ſ�ī��		
						ht3.put("CD_EMPLOY",		"");   //���															 		 
						ht3.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht3.put("CD_BANK",		"");  //�������	
		 				ht3.put("NO_ITEM",		"");  //item	 
		 				
		 				// �ΰ�������
						ht3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht3.put("AM_ADDTAX",	"" );	 //����
						ht3.put("TP_TAX",	"");  //����(����) :11
						ht3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	 
					
						ht3.put("NM_NOTE", acct_cont);  // ����						
					
					}
					
					if (s_neom.equals("Y")) {					
						vt.add(ht3);				
					}				
						//����Ʈ, �������
				}else if(value0[i].equals("scd_rent")){
					out.println("����Ʈ, ������� �Ա�ó��="+pay_amt+", ");
			//		System.out.println( "����Ʈ=" +  value14[i] + ":" + value11[i]	);									
					//�ܱ�������  - value1[i]: rent_st in('1', '2') -_rent_cont.bus_id  |   not in ('1', '2')  rent_cont.nvl(mng_id, bus_id)
					RentContBean rc_bean = rs_db.getRentContCase( value14[i], value11[i]);
					//rent_st :6 ������ 									
					ScdRentBean  rent_bean = rs_db.getScdRentCase(value14[i],  value1[i],  value3[i]);
					
					System.out.println("����Ʈ(�������)��=" + value14[i] + " : " + value1[i] + " : " + value3[i] ) ;
					
					int  r_supply = rent_bean.getRent_s_amt();
					int  r_value =  rent_bean.getRent_v_amt();
						
					String full = "";						
					// paid_st :  2 -> �ſ�ī�� , ī���Ա��̸� paid_st�� '2'�� ����
					if ( ip_method.equals("2") ) {
						rent_bean.setPaid_st	("2");
					}
					
					if(pay_amt == ( rent_bean.getRent_s_amt()+rent_bean.getRent_v_amt())){
						out.println("�����Ա�ó��="+pay_amt+", ");
						full = "Y";
					}else{
						full = "N";
						int rest_s1_amt 	= (new Double(pay_amt/1.1)).intValue();
									
						rent_bean.setRent_s_amt	(rest_s1_amt);
						rent_bean.setRent_v_amt	(pay_amt - rest_s1_amt);
					}	
					
					rent_bean.setPay_dt	(incom_dt);
					rent_bean.setPay_amt	(pay_amt);
					rent_bean.setReg_id(user_id);
					rent_bean.setIncom_dt	(incom_dt); //�����ȣ
					rent_bean.setIncom_seq(incom_seq);
															
					count = rs_db.updateScdRent(rent_bean); 	
					
					i_tax_supply = rent_bean.getRent_s_amt();
					i_tax_value =  rent_bean.getRent_v_amt();
						
					if( full.equals("Y") ) {
						System.out.println("�����Ա�ó��="+pay_amt+", rent_s_cd = " + rent_bean.getRent_s_cd());
					}else{
						System.out.println("�κ��Ա�ó��="+pay_amt+", rent_s_cd = " + rent_bean.getRent_s_cd());
						
						int rest_amt 	= (r_supply+r_value) - pay_amt;
						int rest_s_amt 	= (new Double(rest_amt/1.1)).intValue();
						out.println(" �ܾ׻���="+rest_amt);
						    						
						ScdRentBean rest_fee = new ScdRentBean();
						rest_fee.setRent_s_cd	(rent_bean.getRent_s_cd());
						rest_fee.setRent_st		(rent_bean.getRent_st());
						rest_fee.setTm		(rent_bean.getTm()+1);
				
						rest_fee.setPaid_st		(rent_bean.getPaid_st());
						rest_fee.setEst_dt	(rent_bean.getEst_dt());									//�� �뿩���� �Աݿ�����
						rest_fee.setRent_s_amt	(rest_s_amt);
						rest_fee.setRent_v_amt	(rest_amt - rest_s_amt);
						rest_fee.setDly_days	("0");	
						rest_fee.setDly_amt		(0);	//default�� 0(�̼���)
						rest_fee.setPay_dt		("");
						rest_fee.setPay_amt		(0);
						rest_fee.setReg_id	(user_id);						
						rest_fee.setBill_yn		("Y");
											
						count = rs_db.insertScdRent(rest_fee);	
						
					}
									                                  				
					System.out.println("����Ʈ�� bean=" +rent_bean.getRent_s_cd() + " : " + rent_bean.getRent_st()  + " : " + rent_bean.getTm()  + ": count="+ count + ":user_id=" + user_id + ":incom_dt =" +incom_dt + ":incom_seq = "+ incom_seq ) ;
					
					
					// ������� ����
					if ( !rc_bean.getRent_st().equals("2") ) {
																																		
					      //����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
						UsersBean sender_bean 	= umd.getUsersBean(user_id);
								
						String sub 	= "�ܱ� ����Ʈ�� �Ա�Ȯ��";
						String cont        =  "";
						
						
						//6:������
						if (value1[i].equals("6")){										 
							if ( ip_method.equals("2") ) {
								cont 	= "�� �ܱ� ����Ʈ ������  ī�� �Ա�Ȯ�� :: "+rent_bean.getRent_st()+"ȸ��:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") �Ա���:"+ incom_dt + ", �Աݾ�: "+ pay_amt ;  	
							} else {
							         cont 	= "�� �ܱ� ����Ʈ ������  �Ա�Ȯ�� :: "+rent_bean.getRent_st()+"ȸ��:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") �Ա���:"+ incom_dt + ", �Աݾ�: "+ pay_amt ;  	
							}
						} else {
							if ( ip_method.equals("2") ) {
								cont 	= "�� �ܱ� ����Ʈ��  ī�� �Ա�Ȯ�� :: "+rent_bean.getRent_st()+"ȸ��:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") �Ա���:"+ incom_dt + ", �Աݾ�: "+ pay_amt ;  	
							} else {
							         cont 	= "�� �ܱ� ����Ʈ��  �Ա�Ȯ�� :: "+rent_bean.getRent_st()+"ȸ��:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") �Ա���:"+ incom_dt + ", �Աݾ�: "+ pay_amt ;  	
							}					
						}
																				
						String url 		= "";				
											
						url 		= "/tax/issue_3/issue_3_frame.jsp";		 
					
						String target_id =nm_db.getWorkAuthUser("���ݰ�꼭�����"); 
					//	String target_id = "000129"; //��꼭 �����		//000113->000058->�Ǹ��(000131) -> 000129
								
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
						xml_data += "    <TARGET>2006007</TARGET>";  //ó���Ǹ� �޼��� ����.
						
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
							
						System.out.println("��޽���(����Ʈ���꼭�����û�Ƿ�) "+rent_bean.getRent_st()+"ȸ��:"+cr_bean.getCar_no()+"---------------------"+target_bean.getUser_nm());							    
						
						url 		= "/acar/res_stat/res_st_frame_s.jsp";		 	
						
						target_id = "000153"; //����Ʈ �����		//000113->000058->�Ǹ��(000131) -> 000129
							
						//ùȸ�������� & �������ΰ��
						if ( 	value1[i].equals("1") || value1[i].equals("2") || value1[i].equals("6") ) {
						    target_id = 	rc_bean.getBus_id();				
						}  else {
						    target_id = 	rc_bean.getBus_id();		
						    if ( !rc_bean.getMng_id().equals("") ) {		
							 target_id = 	rc_bean.getMng_id();	
						   }
						}
													
						//����� ���� ��ȸ
						UsersBean target_bean1 	= umd.getUsersBean(target_id);
						
						xml_data = "";
						xml_data =  "<COOLMSG>"+
					  				"<ALERTMSG>"+
					  				"    <BACKIMG>4</BACKIMG>"+
					  				"    <MSGTYPE>104</MSGTYPE>"+
					  				"    <SUB>"+sub+"</SUB>"+
					  				"    <CONT>"+cont+"</CONT>"+
					 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
						
						xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
						
						xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
					  				"    <MSGICON>10</MSGICON>"+
					  				"    <MSGSAVE>1</MSGSAVE>"+
					  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
					  				"    <FLDTYPE>1</FLDTYPE>"+
					  				"  </ALERTMSG>"+
					  				"</COOLMSG>";
						
						CdAlertBean msg1 = new CdAlertBean();
						msg1.setFlddata(xml_data);
						msg1.setFldtype("1");
						
						flag2 = cm_db.insertCoolMsg(msg1);
				
					}
													
					//����Ʈ�� �ڵ���ǥ���� - ī���� ��� ����� �ΰ���.... �߰��� �� 				
					String acct_cont = "";	
					
					if ( !rc_bean.getRent_st().equals("2") ) {
					
						if (value1[i].equals("6")){										
							if ( ip_method.equals("2") ) {
								 acct_cont = "[ī�� �ܱ� ����Ʈ ������]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
							} else {
							     acct_cont = "[�ܱ� ����Ʈ ������]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
							}
						} else {
							if ( ip_method.equals("2") ) {
								 acct_cont = "[ī�� �ܱ� ����Ʈ��]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
							} else {
							     acct_cont = "[�ܱ� ����Ʈ��]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
							}
						}	
					
					} else { //�������					
						acct_cont = "[ �������]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					}
					
					
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}						
					
					line++;					
					
					Hashtable ht44 = new Hashtable();
					
					
					if (value1[i].equals("6")) {	// �������� ���	- ī��� �ȵ� - �����ٵ���.
					
						//���뿩�� ī���� ��� ����� ó�� - ��꼭 ���� ����.						
						if ( ip_method.equals("2") ) {
																					
						} else {												
					
							ht44.put("WRITE_DATE", 	incom_dt);  //row_id						
							ht44.put("ROW_NO",  	String.valueOf(line)); //row_no						
							ht44.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
							ht44.put("CD_PC",  	node_code);  //ȸ�����
							ht44.put("CD_WDEPT",  dept_code);  //�μ�
							ht44.put("NO_DOCU",  	"");  //row_id�� ���� 
							ht44.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
							ht44.put("CD_COMPANY",  "1000");  
							ht44.put("ID_WRITE", insert_id);   
							ht44.put("CD_DOCU",  "11");  
							
							ht44.put("DT_ACCT",  incom_dt);  
							ht44.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
							ht44.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
							ht44.put("CD_ACCT",  "31100");   //���뿩������
							ht44.put("AMT",    	String.valueOf(pay_amt));	
							ht44.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü						
							ht44.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
													
							ht44.put("DT_START",  "");  	//�߻�����									 
							ht44.put("CD_BIZAREA",		"");   //�ͼӻ����	
							ht44.put("CD_DEPT",			"");   //�μ�								 
							ht44.put("CD_CC",			"");   //�ڽ�Ʈ����		
							ht44.put("CD_PJT",			"");   //������Ʈ�ڵ�	
							ht44.put("CD_CARD",		"");   //�ſ�ī��		
							ht44.put("CD_EMPLOY",		"");   //���								 		 
							ht44.put("NO_DEPOSIT",	"");  //�����ݰ���
							ht44.put("CD_BANK",		"");  //�������	
			 				ht44.put("NO_ITEM",		"");  //item	 
			 				
			 						// �ΰ�������
							ht44.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
							ht44.put("AM_ADDTAX",	"" );	 //����
							ht44.put("TP_TAX",	"");  //����(����) :11
							ht44.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
							ht44.put("NM_NOTE", acct_cont);  // ����							
							
							if (s_neom.equals("Y")) {				
								vt.add(ht44);  // ����Ʈ
							}								
						}	
							
					} else {  //�뿩���ΰ��
					
					//���뿩�� ī���� ��� ����� ó�� - ��꼭 ���� ����.	 ������ ����Ʈ�� ���ݰ�꼭 �߱� 							
					/*
						if ( ip_method.equals("2") ) {
						
							ht44.put("WRITE_DATE", 	incom_dt); //row_id							
							ht44.put("ROW_NO",  	String.valueOf(line)); //row_no							
							ht44.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
							ht44.put("CD_PC",  	node_code);  //ȸ�����
							ht44.put("CD_WDEPT",  dept_code);  //�μ�
							ht44.put("NO_DOCU",  	"");   //row_id�� ����
							ht44.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
							ht44.put("CD_COMPANY",  "1000");  
							ht44.put("ID_WRITE", insert_id);   
							ht44.put("CD_DOCU",  "11");  
										
							ht44.put("DT_ACCT",  incom_dt);  
							ht44.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
							ht44.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
							ht44.put("CD_ACCT",  "41200");   // 
							ht44.put("AMT",    	String.valueOf(i_tax_supply));  
							ht44.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü						
							ht44.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																			
							ht44.put("DT_START",  "");  	//�߻�����										 
							ht44.put("CD_BIZAREA",		"");   //�ͼӻ����	
							ht44.put("CD_DEPT",		"");   //�μ�								 
							ht44.put("CD_CC",			"");   //�ڽ�Ʈ����		
							ht44.put("CD_PJT",			"");   //������Ʈ�ڵ�		
							ht44.put("CD_CARD",		"");   //�ſ�ī��		 	
							ht44.put("CD_EMPLOY",		"");   //���									 		 
							ht44.put("NO_DEPOSIT",	"");  //�����ݰ���
							ht44.put("CD_BANK",		"");  //�������	
							ht44.put("NO_ITEM",		"");  //item	  
							
									// �ΰ�������
							ht44.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
							ht44.put("AM_ADDTAX",	"" );	 //����
							ht44.put("TP_TAX",	"");  //����(����) :11
							ht44.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	  	 
						
							ht44.put("NM_NOTE", doc_cont);  // ����									
								
							if (s_neom.equals("Y")) {				
								vt.add(ht44);  // ����Ʈ
							}	
																
							line++;
							
							Hashtable ht44_2 = new Hashtable();
							
							ht44_2.put("WRITE_DATE", 	incom_dt); //row_id							
							ht44_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
							ht44_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� *
							ht44_2.put("CD_PC",  	node_code);  //ȸ�����
							ht44_2.put("CD_WDEPT",  dept_code);  //�μ�
							ht44_2.put("NO_DOCU",  	"");   //row_id�� ����
							ht44_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
							ht44_2.put("CD_COMPANY",  "1000");  
							ht44_2.put("ID_WRITE", insert_id);   
							ht44_2.put("CD_DOCU",  "11");  
																		
							ht44_2.put("DT_ACCT", 	incom_dt); 
							ht44_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
							ht44_2.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1			
							ht44_2.put("CD_ACCT",  	"25500");  //�ΰ���������					
							ht44_2.put("AMT",   	String.valueOf( i_tax_value) );				
							ht44_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
							ht44_2.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
														
							ht44_2.put("DT_START", incom_dt);  	//�߻����� - �ΰ���										 
							ht44_2.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
							ht44_2.put("CD_DEPT",		"");   //�μ�								 
							ht44_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
							ht44_2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
							ht44_2.put("CD_CARD",		"");   //�ſ�ī��		 	
							ht44_2.put("CD_EMPLOY",		"");   //���									 		 
							ht44_2.put("NO_DEPOSIT",	"");  //�����ݰ���
							ht44_2.put("CD_BANK",		"");  //�������	
							ht44_2.put("NO_ITEM",		"");  //item	 	  	
							 				 
								
						// �ΰ�������
							ht44_2.put("AM_TAXSTD",	String.valueOf(i_tax_supply));  //����ǥ�ؾ�
							ht44_2.put("AM_ADDTAX",	String.valueOf( i_tax_value) );	 //����
							ht44_2.put("TP_TAX",	"12");  //����(����) :12 (�ſ�ī��)
							if(ven_type.equals("1")){ //����
								ht44_2.put("NO_COMPANY",	"8888888888"); // ���λ���ڵ�Ϲ�ȣ
							} else {
								ht44_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
							}								
							ht44_2.put("NM_NOTE", doc_cont);  // ����	
							
							if (s_neom.equals("Y")) {				
								vt.add(ht44_2);  // ����Ʈ
							}				
						
							*/
							
					//	} else {												
						
							ht44.put("WRITE_DATE", 	incom_dt);  //row_id						
							ht44.put("ROW_NO",  	String.valueOf(line)); //row_no						
							ht44.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
							ht44.put("CD_PC",  	node_code);  //ȸ�����
							ht44.put("CD_WDEPT",  dept_code);  //�μ�
							ht44.put("NO_DOCU",  	"");  //row_id�� ���� 
							ht44.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
							ht44.put("CD_COMPANY",  "1000");  
							ht44.put("ID_WRITE", insert_id);   
							ht44.put("CD_DOCU",  "11");  
							
							ht44.put("DT_ACCT",  incom_dt);  
							ht44.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
							ht44.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
							ht44.put("CD_ACCT",  "10800");   // �ܻ����� (����Ʈ�뿩��, �������)
							ht44.put("AMT",    	String.valueOf(pay_amt));	
							ht44.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü						
							ht44.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
													
							ht44.put("DT_START",  "");  	//�߻�����									 
							ht44.put("CD_BIZAREA",		"");   //�ͼӻ����	
							ht44.put("CD_DEPT",			"");   //�μ�								 
							ht44.put("CD_CC",			"");   //�ڽ�Ʈ����		
							ht44.put("CD_PJT",			"");   //������Ʈ�ڵ�	
							ht44.put("CD_CARD",		"");   //�ſ�ī��		
							ht44.put("CD_EMPLOY",		"");   //���								 		 
							ht44.put("NO_DEPOSIT",	"");  //�����ݰ���
							ht44.put("CD_BANK",		"");  //�������	
			 				ht44.put("NO_ITEM",		"");  //item	 
			 				
			 						// �ΰ�������
							ht44.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
							ht44.put("AM_ADDTAX",	"" );	 //����
							ht44.put("TP_TAX",	"");  //����(����) :11
							ht44.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
							ht44.put("NM_NOTE", acct_cont);  // ����							
							
							if (s_neom.equals("Y")) {				
								vt.add(ht44);  // ����Ʈ
							}
										
					//      }		
												
				     }
				
				 	//���������
				}else if(value0[i].equals("scd_cls")){
					
					ExtScdBean cls_scd = ae_db.getScd(value9[i], value10[i], value3[i]);					
					
					cls_scd.setExt_pay_dt(incom_dt);
					cls_scd.setExt_pay_amt(pay_amt);
					cls_scd.setUpdate_id(user_id);
					cls_scd.setIncom_dt	(incom_dt); //�����ȣ
					cls_scd.setIncom_seq(incom_seq);
								
					if(!ae_db.updateClsScd(cls_scd, "p", "Y", "1")) flag += 1; //
								
					//20180508 - ��������� �����ݾװ� ����ݾ��� ���� ��� , ȯ���� �ȵȰ��� ���
					if ( est_amt == pay_amt && cls_scd.getJung_st().equals("2")) {
					
						   //��������� ȯ�� ���� 
						Hashtable pay = ac_db.getPayMngDt(value9[i], value10[i]);	
	                    
		               if ( pay.get("P_PAY_DT") == null  ) {
							
							  //����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
								UsersBean sender_bean 	= umd.getUsersBean(user_id);
																									
								String sub 		= " ��������� ��������� �Ա�";
								String cont 	= "�� ���������� ��������� �Ա� Ȯ�� :: "+ client.getFirm_nm() + ", " + cr_bean.getCar_no() + ", �Ա���:"+ incom_dt + ", �Աݾ�: "+ pay_amt ;  										
								String url 		= "/fms2/cls_cont/lc_cls_d_frame.jsp";		 				
														
							    String target_id =nm_db.getWorkAuthUser("����������");  //�Աݴ����
																									
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
								
								System.out.println("��޽���(��������� ��������� �Ա�Ȯ��) "+client.getFirm_nm() +" :"+cr_bean.getCar_no()+"---------------------"+target_bean.getUser_nm());							    
						}										
			     }											
								
					out.println(cls_scd.getRent_mng_id());
					out.println(cls_scd.getRent_l_cd());
								
					//���Աݵ� ��å�� �� ��꼭 �̹����
					//��å�� ��û���� ���� ����ó�� ���� ����
					int car_ja_no_amt =0;
					car_ja_no_amt = ac_db.getClsEtcCarNoAmt(value9[i], value10[i]);										
								
					//��������� �ڵ���ǥ���� �� �������� cls_etc_sub ����										
					String cls_value[] = new String[12];
					StringTokenizer st = new StringTokenizer(value12[i], "^");
										
					int s=0; 
					while(st.hasMoreTokens()){
						cls_value[s] = st.nextToken();
				//		System.out.println(cls_value[s]);
						s++;
					}
						    
			    		String cls_value0[]  = new String[12];  //cid        
			    		String cls_value1[]  = new String[12];  //xxx_amt_1  (no_v_amt_1) 
			    		String cls_value2[]  = new String[12];  //xxx_amt_2  (no_v_amt_2) 
			    		String cls_value3[]  = new String[12];  //xxx_amt_2_v  
			    		String cls_value4[]  = new String[12];  //���⿩��		    			    
		    	     
					for(int ii = 0; ii < s; ii++){
					
						StringTokenizer st1 = new StringTokenizer(cls_value[ii],":");
						
						int s1=0; 
											
						while(st1.hasMoreTokens()){
								cls_value0[ii] = st1.nextToken();
								cls_value1[ii] = st1.nextToken();
								cls_value2[ii] = st1.nextToken();
								cls_value3[ii] = st1.nextToken();
								cls_value4[ii] = st1.nextToken();																
						}							
					
					}					
					
					String cid = "";
					int amt_1 = 0;
					int amt_2 = 0;
					int amt_2_v = 0;
					String  s_gubun = "";		
			      		 int amt_10800 = 0;
				
					//�����Ƿڳ��� ����
					ClsEtcSubBean clss = new ClsEtcSubBean();
					clss.setRent_mng_id(value9[i]);
					clss.setRent_l_cd(value10[i]);
					clss.setReg_id(user_id);
									
					for(int j=0 ; j < s ; j++){
			
						cid = cls_value0[j]	==null?"":cls_value0[j];  //cid
						amt_1 = cls_value1[j]	==null?0 :AddUtil.parseDigit(cls_value1[j]);
						amt_2 = cls_value2[j]	==null?0 :AddUtil.parseDigit(cls_value2[j]);
						amt_2_v = cls_value3[j]	==null?0 :AddUtil.parseDigit(cls_value3[j]);
						s_gubun = cls_value4[j]	==null?"":cls_value4[j];
						
						//���·�
						if(cid.equals("fine")){
							clss.setFine_amt_1	(amt_1);
							if(amt_2 > 0){						
								
								clss.setFine_amt_2	(amt_2);
																							
									 // ���·� ��� -  �̼���
	 							doc_cont = "[�������� ���·�]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();
							
								line++;
								
								Hashtable ht11_1 = new Hashtable();
								
								ht11_1.put("WRITE_DATE", 	incom_dt);  //row_id						
								ht11_1.put("ROW_NO",  	String.valueOf(line)); //row_no								
								ht11_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
								ht11_1.put("CD_PC",  	node_code);  //ȸ�����
								ht11_1.put("CD_WDEPT",  dept_code);  //�μ�
								ht11_1.put("NO_DOCU",  	"");  //row_id�� ���� 
								ht11_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
								ht11_1.put("CD_COMPANY",  "1000");  
								ht11_1.put("ID_WRITE", insert_id);   
								ht11_1.put("CD_DOCU",  "11");  
								
								ht11_1.put("DT_ACCT",  incom_dt);  
								ht11_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
								ht11_1.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
								ht11_1.put("CD_ACCT",  "12400");   //���·Ό����(27400) : , ���·�̼��� (12400)
								ht11_1.put("AMT",    	String.valueOf( amt_2 ));		
								ht11_1.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü								
								ht11_1.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																	 
								ht11_1.put("DT_START",  "");  	//�߻�����											 
								ht11_1.put("CD_BIZAREA",		"");   //�ͼӻ����	
								ht11_1.put("CD_DEPT",		"");   //�μ�								 
								ht11_1.put("CD_CC",			"");   //�ڽ�Ʈ����		
								ht11_1.put("CD_PJT",			"");   //������Ʈ�ڵ�	
								ht11_1.put("CD_CARD",		"");   //�ſ�ī��			
								ht11_1.put("CD_EMPLOY",		"");   //���									
								ht11_1.put("NO_DEPOSIT",	"");  //�����ݰ���
								ht11_1.put("CD_BANK",		"");  //�������	
		 						ht11_1.put("NO_ITEM",		"");  //item 
							
									// �ΰ�������
								ht11_1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
								ht11_1.put("AM_ADDTAX",	"" );	 //����
								ht11_1.put("TP_TAX",	"");  //����(����) :11
								ht11_1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
		
								ht11_1.put("NM_NOTE", doc_cont);  // ����		
								
								if (s_neom.equals("Y")) {				
									vt.add(ht11_1);  // ���·�				
								}	
							}
					    }					   
					   	//��å��
						if(cid.equals("car_ja")){
							clss.setCar_ja_amt_1	(amt_1);
							if(amt_2 > 0){						
							
								clss.setCar_ja_amt_2	(amt_2);
							
								
								amt_10800 = amt_2 - car_ja_no_amt;
								
								doc_cont = "[�������� ��å��]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();
							
								if ( amt_10800 > 0) {  //�ܻ������� �ִ� ��츸 
							 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������							 	  
									line++;
										 			
									Hashtable ht11_2 = new Hashtable();
									
									ht11_2.put("WRITE_DATE", 	incom_dt);  //row_id								
									ht11_2.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_2.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_2.put("CD_PC",  	node_code);  //ȸ�����
									ht11_2.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_2.put("NO_DOCU",  	"");  // row_id�� ���� 
									ht11_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_2.put("CD_COMPANY",  "1000");  
									ht11_2.put("ID_WRITE", insert_id);   
									ht11_2.put("CD_DOCU",  "11");  
									
									ht11_2.put("DT_ACCT",  incom_dt);  
									ht11_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_2.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
							//		ht11_2.put("CD_ACCT",  "10800");   // 
									ht11_2.put("CD_ACCT",  "45510");   //��å��(91800) - 45510
									ht11_2.put("AMT",    	String.valueOf(amt_10800 *(-1)));	
								//	ht11_2.put("AMT",    	String.valueOf(amt_10800) );		
									ht11_2.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü										
									ht11_2.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																			 
									ht11_2.put("DT_START",  "");  	//�߻�����														 
									ht11_2.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_2.put("CD_DEPT",			"");   //�μ�								 
									ht11_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_2.put("CD_PJT",			"");   //������Ʈ�ڵ�	
									ht11_2.put("CD_CARD",		"");   //�ſ�ī��			
									ht11_2.put("CD_EMPLOY",		"");   //���											 		 
									ht11_2.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_2.put("CD_BANK",		"");  //�������	
		 							ht11_2.put("NO_ITEM",		"");  //item  
		 							
		 									// �ΰ�������
									ht11_2.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_2.put("AM_ADDTAX",	"" );	 //����
									ht11_2.put("TP_TAX",	"");  //����(����) :11
									ht11_2.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
									ht11_2.put("NM_NOTE", doc_cont);  // ����		
										
									if (s_neom.equals("Y")) {				
										vt.add(ht11_2);  //  �ܻ�����
									}	
								}	
								
								if ( car_ja_no_amt > 0) {  //�������ظ�å���� �ִ� ��츸 
	
									line++;
										 				   		
							   		Hashtable ht11_3 = new Hashtable();
							   		
							   		ht11_3.put("WRITE_DATE", 	incom_dt);  //row_id							
									ht11_3.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_3.put("CD_PC",  	node_code);  //ȸ�����
									ht11_3.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_3.put("NO_DOCU",  	"");  //row_id�� ���� 
									ht11_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_3.put("CD_COMPANY",  "1000");  
									ht11_3.put("ID_WRITE", insert_id);   
									ht11_3.put("CD_DOCU",  "11");  
									
									ht11_3.put("DT_ACCT",  incom_dt);  
									ht11_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_3.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
									ht11_3.put("CD_ACCT",  "45510");   //��å��(91800) -> 45510
								//	ht11_3.put("AMT",  	String.valueOf( amt_2 ) );		//�Աݾ����� ���� - 180425
									ht11_3.put("AMT", String.valueOf(amt_2*(-1))); //�Աݾ����� ���� - 180425			
							//		ht11_3.put("AMT",    	String.valueOf( car_ja_no_amt ));	
									ht11_3.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü											
									ht11_3.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																	
									ht11_3.put("DT_START",  "");  	//�߻�����											 
									ht11_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_3.put("CD_DEPT",		"");   //�μ�								 
									ht11_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_3.put("CD_PJT",			"");   //������Ʈ�ڵ�	
									ht11_3.put("CD_CARD",		"");   //�ſ�ī��				
									ht11_3.put("CD_EMPLOY",		"");   //���											 		 
									ht11_3.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_3.put("CD_BANK",		"");  //�������	
		 							ht11_3.put("NO_ITEM",		"");  //item  	 
		 							
		 									// �ΰ�������
									ht11_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_3.put("AM_ADDTAX",	"" );	 //����
									ht11_3.put("TP_TAX",	"");  //����(����) :11
									ht11_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ			 
								
									ht11_3.put("NM_NOTE", doc_cont);  // ����		
																		
									if (s_neom.equals("Y")) {				
										vt.add(ht11_3);  // ��å�� 
									}	
								}				
													
							}
					    }		
					   
					   	//��ü��
					    if(cid.equals("dly")){
					   		clss.setDly_amt_1	(amt_1);
							if(amt_2 != 0){						
							
								clss.setDly_amt_2	(amt_2);
															
								doc_cont = "[�������� ��ü��]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();
								
								line++;
			 				   		
						   		Hashtable ht11_4 = new Hashtable();
												
								ht11_4.put("WRITE_DATE", 	incom_dt);  //row_id							
								ht11_4.put("ROW_NO",  	String.valueOf(line)); //row_no								
								ht11_4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
								ht11_4.put("CD_PC",  	node_code);  //ȸ�����
								ht11_4.put("CD_WDEPT",  dept_code);  //�μ�
								ht11_4.put("NO_DOCU",  	"");  //row_id�� ���� 
								ht11_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
								ht11_4.put("CD_COMPANY",  "1000");  
								ht11_4.put("ID_WRITE", insert_id);   
								ht11_4.put("CD_DOCU",  "11");  
								
								ht11_4.put("DT_ACCT",  incom_dt);  
								ht11_4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
								ht11_4.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
								ht11_4.put("CD_ACCT",  "91300");  //��ü��
								ht11_4.put("AMT",    	String.valueOf( amt_2 ) );		
								ht11_4.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü									
								ht11_4.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																		 
								ht11_4.put("DT_START",  "");  	//�߻�����													 
								ht11_4.put("CD_BIZAREA",		"");   //�ͼӻ����	
								ht11_4.put("CD_DEPT",			"");   //�μ�								 
								ht11_4.put("CD_CC",			"");   //�ڽ�Ʈ����		
								ht11_4.put("CD_PJT",			"");   //������Ʈ�ڵ�	
								ht11_4.put("CD_CARD",		"");   //�ſ�ī��			
								ht11_4.put("CD_EMPLOY",		"");   //���										 		 
								ht11_4.put("NO_DEPOSIT",	"");  //�����ݰ���
								ht11_4.put("CD_BANK",		"");  //�������	
		 						ht11_4.put("NO_ITEM",		"");  //item  
		 						
		 								// �ΰ�������
								ht11_4.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
								ht11_4.put("AM_ADDTAX",	"" );	 //����
								ht11_4.put("TP_TAX",	"");  //����(����) :11
								ht11_4.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	 	  
							
								ht11_4.put("NM_NOTE", doc_cont);  // ����	
								
								if (s_neom.equals("Y")) {				
									vt.add(ht11_4);  // ��ü��		
								}				
							}
					    }		
					   
					    	//�뿩��
						if(cid.equals("fee")){
							clss.setDfee_amt_1	(amt_1);
							if(amt_2 != 0){						
							
								clss.setDfee_amt_2	(amt_2);
								clss.setDfee_amt_2_v(amt_2_v);		
								
								doc_cont = "[�������� �뿩��]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();
							
								line++;
									 			
								Hashtable ht11_5 = new Hashtable();
									
								ht11_5.put("WRITE_DATE", 	incom_dt);  //row_id							
								ht11_5.put("ROW_NO",  	String.valueOf(line)); //row_no								
								ht11_5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
								ht11_5.put("CD_PC",  	node_code);  //ȸ�����
								ht11_5.put("CD_WDEPT",  dept_code);  //�μ�
								ht11_5.put("NO_DOCU",  	"");  //row_id�� ���� 
								ht11_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
								ht11_5.put("CD_COMPANY",  "1000");  
								ht11_5.put("ID_WRITE", insert_id);   
								ht11_5.put("CD_DOCU",  "11");  
								
								ht11_5.put("DT_ACCT",  incom_dt);  
								ht11_5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
								ht11_5.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
								ht11_5.put("CD_ACCT",  "10800");   // 
								ht11_5.put("AMT",    String.valueOf(amt_2 + amt_2_v) );		
								ht11_5.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü									
								ht11_5.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																
								ht11_5.put("DT_START",  "");  	//�߻�����													 
								ht11_5.put("CD_BIZAREA",		"");   //�ͼӻ����	
								ht11_5.put("CD_DEPT",			"");   //�μ�								 
								ht11_5.put("CD_CC",			"");   //�ڽ�Ʈ����		
								ht11_5.put("CD_PJT",			"");   //������Ʈ�ڵ�	
								ht11_5.put("CD_CARD",		"");   //�ſ�ī��				
								ht11_5.put("CD_EMPLOY",		"");   //���										 		 
								ht11_5.put("NO_DEPOSIT",	"");  //�����ݰ���
								ht11_5.put("CD_BANK",		"");  //�������	
		 						ht11_5.put("NO_ITEM",		"");  //item  		 
		 						
		 								// �ΰ�������
								ht11_5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
								ht11_5.put("AM_ADDTAX",	"" );	 //����
								ht11_5.put("TP_TAX",	"");  //����(����) :11
								ht11_5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
								ht11_5.put("NM_NOTE", doc_cont);  // ����		
									
								if (s_neom.equals("Y")) {				
									vt.add(ht11_5);  //  �ܻ�����		
								}			
							}
					    }		
					   
					   	//�����
						if(cid.equals("dft")){
							clss.setDft_amt_1	(amt_1);
							if(amt_2 > 0){						
							
								clss.setDft_amt_2	(amt_2);
								clss.setDft_amt_2_v(amt_2_v);			
								
								doc_cont = "[�������� �����]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();
									
								if ( s_gubun.equals("Y") ) {
								
									line++;
									 			
									Hashtable ht11_6 = new Hashtable();
									
									ht11_6.put("WRITE_DATE", 	incom_dt);  //row_id								
									ht11_6.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_6.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_6.put("CD_PC",  	node_code);  //ȸ�����
									ht11_6.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_6.put("NO_DOCU",  	"");  // row_id�� ���� 
									ht11_6.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_6.put("CD_COMPANY",  "1000");  
									ht11_6.put("ID_WRITE", insert_id);   
									ht11_6.put("CD_DOCU",  "11");  
									
									ht11_6.put("DT_ACCT",  incom_dt);  
									ht11_6.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_6.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
									ht11_6.put("CD_ACCT",  "10800");   // 
									ht11_6.put("AMT",    String.valueOf(amt_2 + amt_2_v) );			
									ht11_6.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü													
									ht11_6.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																	
									ht11_6.put("DT_START",  "");  	//�߻�����														 
									ht11_6.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_6.put("CD_DEPT",			"");   //�μ�								 
									ht11_6.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_6.put("CD_PJT",			"");   //������Ʈ�ڵ�	
									ht11_6.put("CD_CARD",		"");   //�ſ�ī��		
									ht11_6.put("CD_EMPLOY",		"");   //���										 		 
									ht11_6.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_6.put("CD_BANK",		"");  //�������	
		 							ht11_6.put("NO_ITEM",		"");  //item  		 
		 							
		 									// �ΰ�������
									ht11_6.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_6.put("AM_ADDTAX",	"" );	 //����
									ht11_6.put("TP_TAX",	"");  //����(����) :11
									ht11_6.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
									ht11_6.put("NM_NOTE", doc_cont);  // ����									
										
									if (s_neom.equals("Y")) {				
										vt.add(ht11_6);  //  �ܻ�����		
									}			
								
							  } else {
							
									line++;
							
								  	 Hashtable ht11_7 = new Hashtable();
								  	 
									ht11_7.put("WRITE_DATE", 	incom_dt);  //row_id								
									ht11_7.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_7.put("CD_PC",  	node_code);  //ȸ�����
									ht11_7.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_7.put("NO_DOCU",  	"");  // row_id�� ���� 
									ht11_7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_7.put("CD_COMPANY",  "1000");  
									ht11_7.put("ID_WRITE", insert_id);   
									ht11_7.put("CD_DOCU",  "11");  
									
									ht11_7.put("DT_ACCT",  incom_dt);  
									ht11_7.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_7.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
									
									if ( cr_bean.getCar_use().equals("1") ) { //��Ʈ�̸�
										ht11_7.put("CD_ACCT",  "41400");     //��������	
									} else {
										ht11_7.put("CD_ACCT",  "41800");     //��������
									}
																		
									ht11_7.put("AMT",    	String.valueOf( amt_2 ) );		
									ht11_7.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü											
									ht11_7.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
																		
									ht11_7.put("DT_START",  "");  	//�߻�����																							 
									ht11_7.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_7.put("CD_DEPT",		"");   //�μ�								 
									ht11_7.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_7.put("CD_PJT",			"");   //������Ʈ�ڵ�		
									ht11_7.put("CD_CARD",		"");   //�ſ�ī��		
									ht11_7.put("CD_EMPLOY",		"");   //���											 		 
									ht11_7.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_7.put("CD_BANK",		"");  //�������	
		 							ht11_7.put("NO_ITEM",		"");  //item  		
		 							
		 									// �ΰ�������
									ht11_7.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_7.put("AM_ADDTAX",	"" );	 //����
									ht11_7.put("TP_TAX",	"");  //����(����) :11
									ht11_7.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ  	 
								
									ht11_7.put("NM_NOTE", doc_cont);  // ����	 				
																	
									if (s_neom.equals("Y")) {				
										vt.add(ht11_7);  //  ���ް�			
									}	
							   }			
																			
							}
					    }		
					   
					   	//ȸ�����
						if(cid.equals("etc")){
							clss.setEtc_amt_1	(amt_1);
							if(amt_2 > 0){						
							
								clss.setEtc_amt_2	(amt_2);
								clss.setEtc_amt_2_v(amt_2_v);		
								
								doc_cont = "[�������� ȸ�����]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();	
								
								if ( s_gubun.equals("Y") ) {
								
									line++;
									 			
									Hashtable ht11_8 = new Hashtable();
										
									ht11_8.put("WRITE_DATE", 	incom_dt);  //row_id								
									ht11_8.put("ROW_NO",  	String.valueOf(line)); //row_no
									
									ht11_8.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_8.put("CD_PC",  	node_code);  //ȸ�����
									ht11_8.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_8.put("NO_DOCU",  	"");  //row_id�� ����
									ht11_8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_8.put("CD_COMPANY",  "1000");  
									ht11_8.put("ID_WRITE", insert_id);   
									ht11_8.put("CD_DOCU",  "11");  
									
									ht11_8.put("DT_ACCT",  incom_dt);  
									ht11_8.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_8.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
									ht11_8.put("CD_ACCT",  "10800");   // 
									ht11_8.put("AMT",    		String.valueOf(amt_2 + amt_2_v) );	
									ht11_8.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü	
									ht11_8.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																		
									ht11_8.put("DT_START",  "");  	//�߻�����														 
									ht11_8.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_8.put("CD_DEPT",			"");   //�μ�								 
									ht11_8.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_8.put("CD_PJT",			"");   //������Ʈ�ڵ�	
									ht11_8.put("CD_CARD",		"");   //�ſ�ī��			
									ht11_8.put("CD_EMPLOY",		"");   //���											 		 
									ht11_8.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_8.put("CD_BANK",		"");  //�������	
		 							ht11_8.put("NO_ITEM",		"");  //item  		
		 							
		 									// �ΰ�������
									ht11_8.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_8.put("AM_ADDTAX",	"" );	 //����
									ht11_8.put("TP_TAX",	"");  //����(����) :11
									ht11_8.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ  	 
								
									ht11_8.put("NM_NOTE", doc_cont);  // ����		
							
									if (s_neom.equals("Y")) {				
										vt.add(ht11_8);  //  �ܻ�����			
									}		
								
							  } else {
							
									line++;
							
								   	Hashtable ht11_9 = new Hashtable();
								   	 
								   	ht11_9.put("WRITE_DATE", 	incom_dt);  //row_id
									ht11_9.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_9.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_9.put("CD_PC",  	node_code);  //ȸ�����
									ht11_9.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_9.put("NO_DOCU",  	"");  //row_id�� ���� 
									ht11_9.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_9.put("CD_COMPANY",  "1000");  
									ht11_9.put("ID_WRITE", insert_id);   
									ht11_9.put("CD_DOCU",  "11");  
									
									ht11_9.put("DT_ACCT",  incom_dt);  
									ht11_9.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_9.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
									ht11_9.put("CD_ACCT",  "45510");   //��å��(91800) - 45510
							//		ht11_9.put("AMT",    	String.valueOf( amt_2 ) );	
									ht11_9.put("AMT", String.valueOf(amt_2*(-1)));
									ht11_9.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü											
									ht11_9.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
																	
									ht11_9.put("DT_START",  "");  	//�߻�����														 
									ht11_9.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_9.put("CD_DEPT",		"");   //�μ�								 
									ht11_9.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_9.put("CD_PJT",			"");   //������Ʈ�ڵ�		
									ht11_9.put("CD_CARD",		"");   //�ſ�ī��	
									ht11_9.put("CD_EMPLOY",		"");   //���											 		 
									ht11_9.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_9.put("CD_BANK",		"");  //�������	
		 							ht11_9.put("NO_ITEM",		"");  //item  		   	 
		 							
		 									// �ΰ�������
									ht11_9.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_9.put("AM_ADDTAX",	"" );	 //����
									ht11_9.put("TP_TAX",	"");  //����(����) :11
									ht11_9.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
									ht11_9.put("NM_NOTE", doc_cont);  // ����					
										
									if (s_neom.equals("Y")) {				
										vt.add(ht11_9);  //  ���ް�	
									}			
							   }
											
							}
					    }		
					   					   
					   	//�δ���
						if(cid.equals("etc2")){
							clss.setEtc2_amt_1	(amt_1);
							if(amt_2 > 0){						
							
								clss.setEtc2_amt_2	(amt_2);
								clss.setEtc2_amt_2_v(amt_2_v);		
								
								doc_cont = "[�������� �δ���]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();	
								
								if ( s_gubun.equals("Y") ) {
								
									line++;
									 			
									Hashtable ht11_10 = new Hashtable();
									
									ht11_10.put("WRITE_DATE", 	incom_dt);  //row_id								
									ht11_10.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_10.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_10.put("CD_PC",  	node_code);  //ȸ�����
									ht11_10.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_10.put("NO_DOCU",  	"");  //row_id�� ���� 
									ht11_10.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_10.put("CD_COMPANY",  "1000");  
									ht11_10.put("ID_WRITE", insert_id);   
									ht11_10.put("CD_DOCU",  "11");  
									
									ht11_10.put("DT_ACCT",  incom_dt);  
									ht11_10.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_10.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
									ht11_10.put("CD_ACCT",  "10800");   // 
									ht11_10.put("AMT",    		String.valueOf(amt_2 + amt_2_v) );	
									ht11_10.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü										
									ht11_10.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																	
									ht11_10.put("DT_START",  "");  	//�߻�����											 
									ht11_10.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_10.put("CD_DEPT",			"");   //�μ�								 
									ht11_10.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_10.put("CD_PJT",			"");   //������Ʈ�ڵ�		
									ht11_10.put("CD_CARD",		"");   //�ſ�ī��	
									ht11_10.put("CD_EMPLOY",		"");   //���											 		 
									ht11_10.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_10.put("CD_BANK",		"");  //�������	
		 							ht11_10.put("NO_ITEM",		"");  //item  		   	 
		 							
		 									// �ΰ�������
									ht11_10.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_10.put("AM_ADDTAX",	"" );	 //����
									ht11_10.put("TP_TAX",	"");  //����(����) :11
									ht11_10.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	 
								
									ht11_10.put("NM_NOTE", doc_cont);  // ����		
																											
									if (s_neom.equals("Y")) {				
										vt.add(ht11_10);  //  �ܻ�����
									}					
								
							  } else {
							
									line++;
							
								   	Hashtable ht11_11 = new Hashtable();
								    	
								   	ht11_11.put("WRITE_DATE", 	incom_dt);  //row_id								
									ht11_11.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_11.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_11.put("CD_PC",  	node_code);  //ȸ�����
									ht11_11.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_11.put("NO_DOCU",  	"");  //row_id�� ���� 
									ht11_11.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_11.put("CD_COMPANY",  "1000");  
									ht11_11.put("ID_WRITE", insert_id);   
									ht11_11.put("CD_DOCU",  "11");  
									
									ht11_11.put("DT_ACCT",  incom_dt);  
									ht11_11.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_11.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
									ht11_11.put("CD_ACCT",  "45510");   //�δ��� 
							//		ht11_11.put("AMT",    	String.valueOf( amt_2 ) );	
									ht11_11.put("AMT", String.valueOf(amt_2*(-1)));
									ht11_11.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü										
									ht11_11.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
								
									ht11_11.put("DT_START",  "");  	//�߻�����	
									ht11_11.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_11.put("CD_DEPT",		"");   //�μ�								 
									ht11_11.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_11.put("CD_PJT",			"");   //������Ʈ�ڵ�	
									ht11_11.put("CD_CARD",		"");   //�ſ�ī��		
									ht11_11.put("CD_EMPLOY",		"");   //���											 		 
									ht11_11.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_11.put("CD_BANK",		"");  //�������	
		 							ht11_11.put("NO_ITEM",		"");  //item  		  
		 							
		 									// �ΰ�������
									ht11_11.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_11.put("AM_ADDTAX",	"" );	 //����
									ht11_11.put("TP_TAX",	"");  //����(����) :11
									ht11_11.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ 	 	 	 	 
								
									ht11_11.put("NM_NOTE", doc_cont);  // ����					
							
									if (s_neom.equals("Y")) {				
										vt.add(ht11_11);  //  ���ް�			
									}	
							   }				
							}
					    }			
						
						 	//��Ÿ���ع���
					    if(cid.equals("etc4")){
					    	clss.setEtc4_amt_1	(amt_1);
							if(amt_2 > 0){						
							
								clss.setEtc4_amt_2	(amt_2);
								clss.setEtc4_amt_2_v(amt_2_v);	
								
								doc_cont = "[�������� ��Ÿ���ع���]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();	
								
								if ( s_gubun.equals("Y") ) {
								
									line++;
									 			
									Hashtable ht11_12 = new Hashtable();
									
									ht11_12.put("WRITE_DATE", 	incom_dt);  //row_id								
									ht11_12.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_12.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_12.put("CD_PC",  	node_code);  //ȸ�����
									ht11_12.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_12.put("NO_DOCU",  	"");  //row_id�� ���� 
									ht11_12.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_12.put("CD_COMPANY",  "1000");  
									ht11_12.put("ID_WRITE", insert_id);   
									ht11_12.put("CD_DOCU",  "11");  
									
									ht11_12.put("DT_ACCT",  incom_dt);  
									ht11_12.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_12.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
									ht11_12.put("CD_ACCT",  "10800");   // 
									ht11_12.put("AMT",    		String.valueOf(amt_2 + amt_2_v) );		
									ht11_12.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü										
									ht11_12.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																	
									ht11_12.put("DT_START",  "");  	//�߻�����	
									ht11_12.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_12.put("CD_DEPT",			"");   //�μ�								 
									ht11_12.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_12.put("CD_PJT",			"");   //������Ʈ�ڵ�	
									ht11_12.put("CD_CARD",		"");   //�ſ�ī��		
									ht11_12.put("CD_EMPLOY",		"");   //���											 		 
									ht11_12.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_12.put("CD_BANK",		"");  //�������	
		 							ht11_12.put("NO_ITEM",		"");  //item  	
		 							
		 									// �ΰ�������
									ht11_12.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_12.put("AM_ADDTAX",	"" );	 //����
									ht11_12.put("TP_TAX",	"");  //����(����) :11
									ht11_12.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	   	 	 	 
								
									ht11_12.put("NM_NOTE", doc_cont);  // ����	
							
									if (s_neom.equals("Y")) {				
										vt.add(ht11_12);  //  �ܻ�����	
									}				
								
							  } else {
							
									line++;
							
								    Hashtable ht11_13 = new Hashtable();
								  	  
									ht11_13.put("WRITE_DATE", 	incom_dt);  //row_id									
									ht11_13.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_13.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_13.put("CD_PC",  	node_code);  //ȸ�����
									ht11_13.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_13.put("NO_DOCU",  	"");  //row_id�� ���� 
									ht11_13.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_13.put("CD_COMPANY",  "1000");  
									ht11_13.put("ID_WRITE", insert_id);   
									ht11_13.put("CD_DOCU",  "11");  
									
									ht11_13.put("DT_ACCT",  incom_dt);  
									ht11_13.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_13.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
									ht11_13.put("CD_ACCT",  "45510");   //�δ���
								//	ht11_13.put("AMT",    	String.valueOf( amt_2 ) );	
									ht11_13.put("AMT", String.valueOf(amt_2*(-1)));
									ht11_13.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü											
									ht11_13.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
																	
									ht11_13.put("DT_START",  "");  	//�߻�����											 
									ht11_13.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_13.put("CD_DEPT",		"");   //�μ�								 
									ht11_13.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_13.put("CD_PJT",			"");   //������Ʈ�ڵ�	
									ht11_13.put("CD_CARD",		"");   //�ſ�ī��			
									ht11_13.put("CD_EMPLOY",		"");   //���											 		 
									ht11_13.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_13.put("CD_BANK",		"");  //�������	
		 							ht11_13.put("NO_ITEM",		"");  //item  
		 							
		 									// �ΰ�������
									ht11_13.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_13.put("AM_ADDTAX",	"" );	 //����
									ht11_13.put("TP_TAX",	"");  //����(����) :11
									ht11_13.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ		   	 
								
									ht11_13.put("NM_NOTE", doc_cont);  // ����					
																	
									if (s_neom.equals("Y")) {				
										vt.add(ht11_13);  //  ���ް�	
									}			
							   }									
							}
					    }			
					
							 	//�ʰ�����
					 	if(cid.equals("over")){
							clss.setOver_amt_1	(amt_1);
							if(amt_2 > 0){						
							
								clss.setOver_amt_2	(amt_2);
								clss.setOver_amt_2_v(amt_2_v);		
								
								doc_cont = "[�������� �߰�����δ��]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();
								
								if ( s_gubun.equals("Y") ) {
								
									line++;
									 			
									Hashtable ht11_14 = new Hashtable();
									
									ht11_14.put("WRITE_DATE", 	incom_dt);  //row_id								
									ht11_14.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_14.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_14.put("CD_PC",  	node_code);  //ȸ�����
									ht11_14.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_14.put("NO_DOCU",  	"");  //row_id�� ���� 
									ht11_14.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_14.put("CD_COMPANY",  "1000");  
									ht11_14.put("ID_WRITE", insert_id);   
									ht11_14.put("CD_DOCU",  "11");  
									
									ht11_14.put("DT_ACCT",  incom_dt);  
									ht11_14.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_14.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
									ht11_14.put("CD_ACCT",  "10800");   // 
									ht11_14.put("AMT",    		String.valueOf(amt_2 + amt_2_v) );		
									ht11_14.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü										
									ht11_14.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																	
									ht11_14.put("DT_START",  "");  	//�߻�����	
									ht11_14.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_14.put("CD_DEPT",			"");   //�μ�								 
									ht11_14.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_14.put("CD_PJT",			"");   //������Ʈ�ڵ�	
									ht11_14.put("CD_CARD",		"");   //�ſ�ī��		
									ht11_14.put("CD_EMPLOY",		"");   //���											 		 
									ht11_14.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_14.put("CD_BANK",		"");  //�������	
		 							ht11_14.put("NO_ITEM",		"");  //item  	
		 							
		 									// �ΰ�������
									ht11_14.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_14.put("AM_ADDTAX",	"" );	 //����
									ht11_14.put("TP_TAX",	"");  //����(����) :11
									ht11_14.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	   	 	 	 
								
									ht11_14.put("NM_NOTE", doc_cont);  // ����	
							
									if (s_neom.equals("Y")) {				
										vt.add(ht11_14);  //  �ܻ�����	
									}				
								
							  } else {
							
									line++;
							
								  	 Hashtable ht11_15 = new Hashtable();
								  	 
									ht11_15.put("WRITE_DATE", 	incom_dt);  //row_id								
									ht11_15.put("ROW_NO",  	String.valueOf(line)); //row_no									
									ht11_15.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
									ht11_15.put("CD_PC",  	node_code);  //ȸ�����
									ht11_15.put("CD_WDEPT",  dept_code);  //�μ�
									ht11_15.put("NO_DOCU",  	"");  // row_id�� ���� 
									ht11_15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
									ht11_15.put("CD_COMPANY",  "1000");  
									ht11_15.put("ID_WRITE", insert_id);   
									ht11_15.put("CD_DOCU",  "11");  
									
									ht11_15.put("DT_ACCT",  incom_dt);  
									ht11_15.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
									ht11_15.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
									
									if ( cr_bean.getCar_use().equals("1") ) { //��Ʈ�̸�
										ht11_15.put("CD_ACCT",  "41400");     //��������	
									} else {
										ht11_15.put("CD_ACCT",  "41800");     //��������
									}
																		
									ht11_15.put("AMT",    	String.valueOf( amt_2 ) );		
									ht11_15.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü											
									ht11_15.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
																		
									ht11_15.put("DT_START",  "");  	//�߻�����																							 
									ht11_15.put("CD_BIZAREA",		"");   //�ͼӻ����	
									ht11_15.put("CD_DEPT",		"");   //�μ�								 
									ht11_15.put("CD_CC",			"");   //�ڽ�Ʈ����		
									ht11_15.put("CD_PJT",			"");   //������Ʈ�ڵ�		
									ht11_15.put("CD_CARD",		"");   //�ſ�ī��		
									ht11_15.put("CD_EMPLOY",		"");   //���											 		 
									ht11_15.put("NO_DEPOSIT",	"");  //�����ݰ���
									ht11_15.put("CD_BANK",		"");  //�������	
		 							ht11_15.put("NO_ITEM",		"");  //item  		
		 							
		 									// �ΰ�������
									ht11_15.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
									ht11_15.put("AM_ADDTAX",	"" );	 //����
									ht11_15.put("TP_TAX",	"");  //����(����) :11
									ht11_15.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ  	 
								
									ht11_15.put("NM_NOTE", doc_cont);  // ����	 				
																	
									if (s_neom.equals("Y")) {				
										vt.add(ht11_15);  //  ���ް�			
									}	
							   }									
							}
					    }			
					    
					      	//�����ޱ� - ī���� ��� ��� 
					    if(cid.equals("c_pay")){
					
							if(amt_2 != 0){						
										
															
								doc_cont = "[�������� �����ޱ�]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();
								
								line++;
			 				   		
						   		Hashtable ht11_16 = new Hashtable();
												
								ht11_16.put("WRITE_DATE", 	incom_dt);  //row_id							
								ht11_16.put("ROW_NO",  	String.valueOf(line)); //row_no								
								ht11_16.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
								ht11_16.put("CD_PC",  	node_code);  //ȸ�����
								ht11_16.put("CD_WDEPT",  dept_code);  //�μ�
								ht11_16.put("NO_DOCU",  	"");  //row_id�� ���� 
								ht11_16.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
								ht11_16.put("CD_COMPANY",  "1000");  
								ht11_16.put("ID_WRITE", insert_id);   
								ht11_16.put("CD_DOCU",  "11");  
								
								ht11_16.put("DT_ACCT",  incom_dt);  
								ht11_16.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
								ht11_16.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
								ht11_16.put("CD_ACCT",  "25300");  //�����ޱ�
								ht11_16.put("AMT",    	String.valueOf( amt_2 ) );		
								ht11_16.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü									
								ht11_16.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
																		 
								ht11_16.put("DT_START",  "");  	//�߻�����													 
								ht11_16.put("CD_BIZAREA",		"");   //�ͼӻ����	
								ht11_16.put("CD_DEPT",			"");   //�μ�								 
								ht11_16.put("CD_CC",			"");   //�ڽ�Ʈ����		
								ht11_16.put("CD_PJT",			"");   //������Ʈ�ڵ�	
								ht11_16.put("CD_CARD",		"");   //�ſ�ī��			
								ht11_16.put("CD_EMPLOY",		"");   //���										 		 
								ht11_16.put("NO_DEPOSIT",	"");  //�����ݰ���
								ht11_16.put("CD_BANK",		"");  //�������	
		 						ht11_16.put("NO_ITEM",		"");  //item  
		 						
		 								// �ΰ�������
								ht11_16.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
								ht11_16.put("AM_ADDTAX",	"" );	 //����
								ht11_16.put("TP_TAX",	"");  //����(����) :11
								ht11_16.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	 	  
							
								ht11_16.put("NM_NOTE", doc_cont);  // ����	
								
								if (s_neom.equals("Y")) {				
									vt.add(ht11_16);  // �����ޱ� 
								}				
							}
					    }		
					    
					  	//vat��
					    if(cid.equals("vat")){
							clss.setNo_v_amt_1	(amt_1);
							clss.setNo_v_amt_2	(amt_2);
					    }
					    					
				   } //end for	
	
				   //�����Ƿڼ��곻�� ����	
				   if(!ac_db.insertClsEtcSubIncom(clss))	flag += 1;		
				
				} //���������
				
			}  //pay_amt > 0
			out.println("<br>");
		}  //end for 
					
		if(line > 1){
			doc_cont = doc_cont+" ��";
		}			
	}
		
	if ( ip_method.equals("1") ) {	
		
		if (neom.equals("Y") ||  neom1.equals("Y") ) {
					
			line++;
		
			//���뿹��
			Hashtable ht1 = new Hashtable();
			
			ht1.put("WRITE_DATE", 	incom_dt);  //row_id			
			ht1.put("ROW_NO",  	String.valueOf(line)); //row_no
										
			ht1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht1.put("CD_PC",  	node_code);  //ȸ�����
			ht1.put("CD_WDEPT",  dept_code);  //�μ�
			ht1.put("NO_DOCU",  	"");  //row_id�� ���� 
			ht1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht1.put("CD_COMPANY",  "1000");  
			ht1.put("ID_WRITE", insert_id);   
			ht1.put("CD_DOCU",  "11");  
			
			ht1.put("DT_ACCT",  incom_dt);  
			ht1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  					
			ht1.put("TP_DRCR",  	"1");//����
			ht1.put("CD_ACCT",    "10300");  //���뿹��
			ht1.put("AMT",    	String.valueOf(incom_amt));
			ht1.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü				
			ht1.put("CD_PARTNER",	""); //�ŷ�ó    - A06
					
			ht1.put("DT_START",  "");   	//�߻�����					 
			ht1.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht1.put("CD_DEPT",		"");   //�μ�								 
			ht1.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht1.put("CD_PJT",			"");   //������Ʈ�ڵ�	
			ht1.put("CD_CARD",		"");   //�ſ�ī��		 		 	
			ht1.put("CD_EMPLOY",		"");   //���
			ht1.put("NO_DEPOSIT",	deposit_no);  //�����ݰ���
			ht1.put("CD_BANK",		value_bank[0]);  //�������	
		 	ht1.put("NO_ITEM",		"");  //item
		 	
		 			// �ΰ�������
			ht1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht1.put("AM_ADDTAX",	"" );	 //����
			ht1.put("TP_TAX",	"");  //����(����) :11
			ht1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
		
			ht1.put("NM_NOTE", doc_cont);  // ����			
						
			vt.add(ht1);
			
		}
					
	}
	
	if ( vt.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(incom_dt,  vt);		
	}
	  		
	//�Աݿ���ó�� - jung_type :1->�Ϸ�
	 if(!in_db.updateIncomSet( incom_dt, incom_seq, "1", card_tax, ip_method, doc_cont, a_cal_tax , row_id)) flag += 1;	
	
	//�������� �Ϸ�ó��	
	if(!ib_db.updateIbAcctTallTrDdFmsYn(incom_acct_seq, incom_dt, incom_tr_date_seq  )) flag += 1;		
		   	
%>


<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//���̺� ���� ����%>
	alert('��� �����߻�!');

<%	}else{ 			//���̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');				
    parent.window.close();	
 //   fm.action='<%=from_page%>';
   
 //   fm.target='d_content';		
 //   fm.submit();
<%	
	} %>
</script>

</body>
</html>
