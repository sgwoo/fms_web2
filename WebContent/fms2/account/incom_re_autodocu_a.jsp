<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.incom.*, acar.common.*, acar.user_mng.*, acar.ext.*, acar.credit.*, tax.*, acar.coolmsg.*, acar.forfeit_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*, acar.con_ins_m.*, acar.accid.*, acar.con_ins_h.*,  acar.cls.*, acar.car_sche.*"%>
<%@ page import="acar.kakao.*, tax.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="ass_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")		==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	if ( from_page.equals("")) from_page = "/fms2/account/incom_d_frame.jsp" ;
			
	String bank_code 	= request.getParameter("bank_code2")	==null?"":request.getParameter("bank_code2");
	String deposit_no 	= request.getParameter("deposit_no2")	==null?"":request.getParameter("deposit_no2");		
	String bank_name 	= request.getParameter("bank_name")	==null?"":request.getParameter("bank_name");
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	long  incom_amt 			= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
//	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
			 			
	//ī��� ����� ��� ������
	String ip_method 		= "";
	int    card_tax 	 	= request.getParameter("card_tax")	==null?0 :AddUtil.parseDigit(request.getParameter("card_tax"));  //ī�� ������
			
	String neom		= request.getParameter("neom")==null?"Y":request.getParameter("neom"); 
//	String s_neom		= request.getParameter("s_neom")==null?"N":request.getParameter("s_neom");  //�˻��� �ŷ�ó������ �󼼳�����ǥ���� 
	String s_neom = "Y"; //��ǥ����
	
	String neom1 = "";
	
	//��Ÿ�Աݰ���
	String n_ven_code 		= request.getParameter("n_ven_code")	==null?"":request.getParameter("n_ven_code");
	String n_ven_name 		= request.getParameter("n_ven_name")	==null?"":request.getParameter("n_ven_name");
	String ip_acct 		= request.getParameter("ip_acct")	==null?"":request.getParameter("ip_acct");
	String acct_gubun 		= request.getParameter("acct_gubun")	==null?"4":request.getParameter("acct_gubun"); //��/�� ���� -> ����:D, �뺯:C
	long     ip_acct_amt 	 	= request.getParameter("ip_acct_amt")	==null?0 :AddUtil.parseDigit4(request.getParameter("ip_acct_amt"));
	String remark 		= request.getParameter("remark")	==null?"":request.getParameter("remark");
				
	//��/������	
	String tax_yn = "N";	
		
	CarRegDatabase crd = CarRegDatabase.getInstance();

	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
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
	String value13[] = request.getParameterValues("rtn_client_id");	//
	String value14[] = request.getParameterValues("rent_s_cd");   //����Ʈ, �������
	String value15[] = request.getParameterValues("cls_amt");   //��/������ �� û�������� ���Ը� 1��
	String value16[]  = request.getParameterValues("tm1_nm");//�׸� - �뿩��/��å�ݵ� 	 - ����������� ��� ������ 
		
	int scd_size = value0.length;  //������� �Ա�ó���� ����
	
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
	String car_nm = "";	
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
		
		//�Աݰŷ����� ����
	IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
	String card_nm = base.getCard_nm();
	ip_method = base.getIp_method();
		
	long t_pay_amt =  0;	//��Ÿ�Աݺ� ó���� ���		
	
	int i_tax_supply = 0;  //����Ʈ ī���� ��� ���ް�, 20200101���� �����뿩�� ó���� ��� (20191226)
	int i_tax_value = 0;  //����Ʈ ī���� ��� vat , 20200101���� �����뿩�� ó���� ��� (20191226)
			  	
	int cal_tax = 0;  //ī���� ��� ������ ����
	int a_cal_tax = 0; //����
	
	String green_chk = "";
	String pp_chk = ""; //������ �յ� check ->0:�յ� 
	String tax_branch = "";
	String foreigner= "";
	//�Ҽӿ����� ����Ʈ ��ȸ
	Hashtable br = c_db.getBranch("S1"); //������ ���� 
   
	String not_yet= "0"; //��ǥ������ ������ ó����ǥ ���� ����.
	String not_yet_reason= "������ ó��"; //��ǥ������ ������ ó����ǥ ���� ����.
	//�������� ���
	if ( not_yet.equals("1") ) {
	   	   	
		doc_cont = not_yet_reason;
					
	   	line++;
	 				   		
   		Hashtable ht1_1 = new Hashtable();
   		   								
		ht1_1.put("WRITE_DATE", 	incom_dt);  //row_id	
		ht1_1.put("ROW_NO",  	String.valueOf(line)); //row_no		
		ht1_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� * ,  no_docu || no_doline
		ht1_1.put("CD_PC",  node_code);  //ȸ�����*
		ht1_1.put("CD_WDEPT",  dept_code);  //�μ�
		ht1_1.put("NO_DOCU",  	"");  //row_id�� ����
		ht1_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht1_1.put("CD_COMPANY",  "1000");  
		ht1_1.put("ID_WRITE", insert_id);   
		ht1_1.put("CD_DOCU",  "11");  
		
		ht1_1.put("DT_ACCT",  incom_dt);  
		ht1_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht1_1.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
		ht1_1.put("CD_ACCT",  "25700");   //������
		ht1_1.put("AMT",    	String.valueOf(incom_amt));								
		ht1_1.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü	
		ht1_1.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
	
		ht1_1.put("DT_START",  "");  	//�߻�����			
		ht1_1.put("CD_BIZAREA",	"");   //�ͼӻ����	
		ht1_1.put("CD_DEPT",		"");   //�μ�								 
		ht1_1.put("CD_CC",			"");   //�ڽ�Ʈ����		
		ht1_1.put("CD_PJT",			"");   //������Ʈ�ڵ�	
		ht1_1.put("CD_CARD",		"");   //�ſ�ī��		 		 		
		ht1_1.put("CD_EMPLOY",		"");   //���	
		ht1_1.put("NO_DEPOSIT",	"");  //�����ݰ���
		ht1_1.put("CD_BANK",		"");  //�������	
		ht1_1.put("NO_ITEM",		"");  //item 	 
		
		// �ΰ�������
		ht1_1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
		ht1_1.put("AM_ADDTAX",	"" );	 //����
		ht1_1.put("TP_TAX",	"");  //����(����) :11
		ht1_1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
	
		ht1_1.put("NM_NOTE", doc_cont);  // ����
	
		vt.add(ht1_1);	
		
		neom1 = "Y"; //���뿹�� ��ǥ���� 
	  
	} else  {   //20130901���� ����Ʈ�� cont���� ���� - car_st = '4'
		
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
				car_nm =	cr_bean.getCar_nm();
			}  else {	
				//�ڵ�������
				cr_bean = crd.getCarRegBean(value11[i]);		
				car_no =	cr_bean.getCar_no();
				car_nm =	cr_bean.getCar_nm();
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
				foreigner=  client.getNationality();
				
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
											
		  	  }	
		
			  int est_amt = value6[i]	==null?0 :AddUtil.parseDigit(value6[i]);
			  int pay_amt = value7[i]	==null?0 :AddUtil.parseDigit(value7[i]);
					
			  if(pay_amt != 0){	
				if (s_neom.equals("Y")) {
					neom1 = "Y"; //���뿹�� ��ǥ���� 
				}else {
					neom1 = "N"; //���뿹�� ��ǥ���� 
				}
						
				//������ - ������, ������, ���ô뿩�� , ���ź�����  -- 2020����� ���ô뿩��, �������Ͻó�, �뿩���Ͻó��� ��� �ܻ������� �ƴ� �����뿩�� �������(���ް��� ), �ΰ��������� 
				if( value0[i].equals("01") ){  //
					
					String SeqId = "";
					String cha_gubun = "";  // ��å�� ���� 
					
					//������ �յ� ���� 
					if ( value16[i].equals("������") ) {			
					//�뿩����
						ContFeeBean fee = a_db.getContFeeNew(value9[i], value10[i], value1[i]);
						pp_chk = fee.getPp_chk();
					}
					
					//������ �ڵ���ǥ����					
					String acct_cont = "";
					
					if ( value16[i].equals("������")){
						acct_cont = "[���뿩������]"+ value10[i]+"("+client.getFirm_nm()+")";
					} else if (value16[i].equals("������")){				
						if (pp_chk.equals("0") ) {
							acct_cont = "[������ �յ�]"+ value10[i]+"("+client.getFirm_nm()+")";
						} else {
							acct_cont = "[������]"+ value10[i]+"("+client.getFirm_nm()+")";	
						}
					} else if (value16[i].equals("���ô뿩��")){
						acct_cont = "[���ô뿩��]"+ value10[i]+"("+client.getFirm_nm()+")";
					} else if (value16[i].equals("�°������")){
						acct_cont = "[�°������]"+ value10[i]+"("+client.getFirm_nm()+")";	
					} else if (value16[i].equals("���ź�����")){
						acct_cont = "[���ź�����]"+ value10[i]+"("+client.getFirm_nm()+")";		
					}	
					
					
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;
					
					//������
					Hashtable ht15 = new Hashtable();
					
					if ( value16[i].equals("������")){
					
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
					
					} else if ( value16[i].equals("������")){ //20191220 �յ������ ���: ������ , �׿�:�ܻ����� 
					
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
							
							if (pp_chk.equals("0") ) {
								ht15.put("CD_ACCT",  "25900");   //������ - ������
							} else {
								ht15.put("CD_ACCT",  "10800");   //������ - �ܻ����� 
							}
							
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
																					
							if ( value16[i].equals("���ź�����")){
									ht15.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
									if ( cr_bean.getCar_use().equals("1") ) { //��Ʈ�̸�
										ht15.put("CD_ACCT",  "21810");     //���ź����� 	
										ht15.put("CD_PARTNER",	"996189"); //�ŷ�ó    - A06										
									} else {
										ht15.put("CD_ACCT",  "22010");     //���ź�����
										ht15.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
									}
									ht15.put("AMT",    	String.valueOf(pay_amt));	
							} else {
							//	ht15.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
							//	ht15.put("CD_ACCT",  "91800");   //��å��(91800)
							//	ht15.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06	
							//	ht15.put("AMT",    	String.valueOf(pay_amt));	
								
								ht15.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
								ht15.put("CD_ACCT",  "45510");   //��å��(91800) -�������������(45510)�� ����ó�� (20211116)
								ht15.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06		
								ht15.put("AMT",    	String.valueOf(pay_amt *(-1)));	
							}						
														
				//			ht15.put("AMT",    	String.valueOf(pay_amt));	
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
				 						
				//�뿩��
				}else if(value0[i].equals("02")){
							
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
						 acct_cont = "[ī��뿩��]"+value3[i]+"ȸ��:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					} else {
						 acct_cont = "[�뿩��]"+value3[i]+"ȸ��:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
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
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);	
						} else 	if ( card_nm.equals("�̳�����") ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);	
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}					
							
				//��ü��
				}else if(value0[i].equals("03")){
					
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
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);	
						}  else if ( card_nm.equals("�̳�����")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}	
					
					//���·�
				}else if(value0[i].equals("04")){
								
					//���·� �ڵ���ǥ����				
					
					String acct_cont = "";					
					if ( ip_method.equals("2") ) {
					  acct_cont = "[ī����·�]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") ";
					} else {
					  acct_cont = "[���·�]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") ";
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
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);	
					 	}  else if ( card_nm.equals("�̳�����")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);	
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}					
								
				//��å��
				}else if(value0[i].equals("05")){
																	
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
					/* ����� ���̻� ������ (��å���� ��꼭 �������)
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
					}else{ */
					
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
						//ht2.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
						//ht2.put("CD_ACCT",  "91800");   //��å��(91800)
						//ht2.put("AMT",    	String.valueOf(pay_amt));	
						
						ht2.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
						ht2.put("CD_ACCT",  "45510");   //��å��(91800) - �������������(45510)���� ��ü(20211116)
						ht2.put("AMT",    	String.valueOf(pay_amt*(-1)));	
						
						
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
					
				/*	} */
					
					if (s_neom.equals("Y")) {	
						vt.add(ht2);
					}	
				
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP")  || card_nm.equals("KCP2")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);		
					  	}  else if ( card_nm.equals("���̿�")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);		
						}  else if ( card_nm.equals("�̳�����")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);			
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}
							
					//��/������
				}else if(value0[i].equals("06") ||  value0[i].equals("07") ){
								
					//û���� ������� - - ���� ������ ó�� - 20211206 
				//	if ( value15[i].equals("1")) 	value4[i] = "1";
															
					// ��/������ �ڵ���ǥ����					
					String acct_cont = "";					
					
					if (value0[i].equals("06")){
				//	if (value4[i].equals("1")){
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
					if (value0[i].equals("07")){
				//	if (value4[i].equals("2")){
					
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
					
					//�������ظ�å�� - ������ó�� 
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
						//ht3.put("TP_DRCR",  amt_gubun);   // �뺯:2 , ����:1
						//ht3.put("CD_ACCT",  "91800");   //��å��(91800)
						//ht3.put("AMT",    	String.valueOf(pay_amt));	
						ht3.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
						ht3.put("CD_ACCT",  "45510");   //��å��(91800)
						ht3.put("AMT",    	String.valueOf(pay_amt*(-1)));	
						
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
				
					//��ǥ������� ��������� ó�� - ī��ó��??
				}else if(value0[i].equals("10")){
			
					
					//����Ʈ�� �ڵ���ǥ���� - ī���� ��� ����� �ΰ���.... �߰��� �� 				
					String acct_cont = "";
									
					acct_cont = "[�������]" + cr_bean.getCar_no() + "(" + client.getFirm_nm() + ")";
							
					if (doc_cont.equals("")) {
						doc_cont = acct_cont;
					}
		
					line++;
		
					Hashtable ht44 = new Hashtable();

					ht44.put("WRITE_DATE", incom_dt); //row_id						
					ht44.put("ROW_NO", String.valueOf(line)); //row_no						
					ht44.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
					ht44.put("CD_PC", node_code); //ȸ�����
					ht44.put("CD_WDEPT", dept_code); //�μ�
					ht44.put("NO_DOCU", ""); //row_id�� ���� 
					ht44.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
					ht44.put("CD_COMPANY", "1000");
					ht44.put("ID_WRITE", insert_id);
					ht44.put("CD_DOCU", "11");

					ht44.put("DT_ACCT", incom_dt);
					ht44.put("ST_DOCU", "1"); //�̰�:1, ����:2  
					ht44.put("TP_DRCR", amt_gubun); // �뺯:2 , ����:1
					ht44.put("CD_ACCT", "10800"); // �ܻ����� (����Ʈ�뿩��, �������)
					ht44.put("AMT", String.valueOf(pay_amt));
					ht44.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü						
					ht44.put("CD_PARTNER", ven_code); //�ŷ�ó    - A06

					ht44.put("DT_START", ""); //�߻�����									 
					ht44.put("CD_BIZAREA", ""); //�ͼӻ����	
					ht44.put("CD_DEPT", ""); //�μ�								 
					ht44.put("CD_CC", ""); //�ڽ�Ʈ����		
					ht44.put("CD_PJT", ""); //������Ʈ�ڵ�	
					ht44.put("CD_CARD", ""); //�ſ�ī��		
					ht44.put("CD_EMPLOY", ""); //���								 		 
					ht44.put("NO_DEPOSIT", ""); //�����ݰ���
					ht44.put("CD_BANK", ""); //�������	
					ht44.put("NO_ITEM", ""); //item	 

					// �ΰ�������
					ht44.put("AM_TAXSTD", ""); //����ǥ�ؾ�
					ht44.put("AM_ADDTAX", ""); //����
					ht44.put("TP_TAX", ""); //����(����) :11
					ht44.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ

					ht44.put("NM_NOTE", acct_cont); // ����							

					if (s_neom.equals("Y")) {
						vt.add(ht44); // ��������ΰ��
					}	
					
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP")  || card_nm.equals("KCP2")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);		
					  	}  else if ( card_nm.equals("���̿�")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);		
						}  else if ( card_nm.equals("�̳�����")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);			
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}

					//���������
				} else if (value0[i].equals("09")) {
					//������� ����ȭ�Ҽ� ����.
					//����Ʈ�� �ڵ���ǥ���� - ī���� ��� ����� �ΰ���.... �߰��� �� 				
					String acct_cont = "";
									
					acct_cont = "[��������]" + cr_bean.getCar_no() + "(" + client.getFirm_nm() + ")";
							
					if (doc_cont.equals("")) {
						doc_cont = acct_cont;
					}
					
					line++;
					
					Hashtable ht11 = new Hashtable();
		
					ht11.put("WRITE_DATE", incom_dt); //row_id	
					ht11.put("ROW_NO", String.valueOf(line)); //row_no		
					ht11.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
					ht11.put("CD_PC", node_code); //ȸ�����
					ht11.put("CD_WDEPT", dept_code); //�μ�
					ht11.put("NO_DOCU", ""); //row_id�� ���� 
					ht11.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
					ht11.put("CD_COMPANY", "1000");
					ht11.put("ID_WRITE", insert_id);
					ht11.put("CD_DOCU", "11");
		
					ht11.put("DT_ACCT", incom_dt);
					ht11.put("ST_DOCU", "1"); //�̰�:1, ����:2  					
					ht11.put("TP_DRCR", amt_gubun);//�뺯
					ht11.put("CD_ACCT", "25700"); // ������ --> (20200410���� )
				//	ht21.put("CD_ACCT", "93000"); // ������ --> ���������� ó��(20200101���� )
					ht11.put("AMT", String.valueOf(pay_amt));
					ht11.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü				
		
					if (card_nm.equals("KCP") || card_nm.equals("KCP2")) {
						ht11.put("CD_PARTNER", "105320"); //�ŷ�ó    - A06  �ѱ����̹�����(KCP)
					} else if (card_nm.equals("���̿�")) {
						ht11.put("CD_PARTNER", "996282"); //�ŷ�ó    - ���̿�(payat)		
					} else if (card_nm.equals("���̽�")) {
						ht11.put("CD_PARTNER", "996283"); //�ŷ�ó    - ���̽� 	
					} else if (card_nm.equals("�̳�����")) {
						ht11.put("CD_PARTNER", "996548"); //�ŷ�ó    - �̳����� 		
					} else {
						ht11.put("CD_PARTNER", "109691"); //�ŷ�ó    - A06		
					}
		
					ht11.put("DT_START", ""); //�߻�����				 
					ht11.put("CD_BIZAREA", ""); //�ͼӻ����	
					ht11.put("CD_DEPT", ""); //�μ�								 
					ht11.put("CD_CC", ""); //�ڽ�Ʈ����		
					ht11.put("CD_PJT", ""); //������Ʈ�ڵ�	
					ht11.put("CD_CARD", ""); //�ſ�ī��		 		 	
					ht11.put("CD_EMPLOY", ""); //���	
					ht11.put("NO_DEPOSIT", ""); //�����ݰ���
					ht11.put("CD_BANK", ""); //�������	
					ht11.put("NO_ITEM", ""); //item   	
		
					// �ΰ�������
					ht11.put("AM_TAXSTD", ""); //����ǥ�ؾ�
					ht11.put("AM_ADDTAX", ""); //����
					ht11.put("TP_TAX", ""); //����(����) :11
					ht11.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ	  	 	 
		
					ht11.put("NM_NOTE", doc_cont); // ����	
					
					if (s_neom.equals("Y")) {
						vt.add(ht11); // ���������
					}					

					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP")  || card_nm.equals("KCP2")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);		
					  	}  else if ( card_nm.equals("���̿�")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);		
						}  else if ( card_nm.equals("�̳�����")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);			
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}	
					
				} //���������

			} //pay_amt > 0
			out.println("<br>");
		} //end for 

		if (line > 1) {
			doc_cont = doc_cont + " ��";
		}
	}

	if (neom.equals("Y")) {
	
		if (ip_acct.equals("0")) {

			line++;

			String acc_cont = "[������]" + "-" + n_ven_name + " " + remark;

			if (acct_gubun.equals("D")) {
				t_pay_amt = ip_acct_amt * (-1);
			} else {
				t_pay_amt = ip_acct_amt;
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //���� 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			//������
			Hashtable ht25 = new Hashtable();

			ht25.put("WRITE_DATE", incom_dt); //row_id			
			ht25.put("ROW_NO", String.valueOf(line)); //row_no			
			ht25.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
			ht25.put("CD_PC", node_code); //ȸ�����
			ht25.put("CD_WDEPT", dept_code); //�μ�
			ht25.put("NO_DOCU", ""); //row_id�� ���� 
			ht25.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
			ht25.put("CD_COMPANY", "1000");
			ht25.put("ID_WRITE", insert_id);
			ht25.put("CD_DOCU", "11");

			ht25.put("DT_ACCT", incom_dt);
			ht25.put("ST_DOCU", "1"); //�̰�:1, ����:2  

			if (acct_gubun.equals("D")) {
				ht25.put("TP_DRCR", amt_gubun); //����		
			} else {
				ht25.put("TP_DRCR", amt_gubun); //�뺯				
			}

			ht25.put("CD_ACCT", "25900"); //������
			ht25.put("AMT", String.valueOf(t_pay_amt));
			ht25.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü			
			ht25.put("CD_PARTNER", n_ven_code); //�ŷ�ó    - A06

			ht25.put("DT_START", incom_dt); //�߻�����					 
			ht25.put("CD_BIZAREA", ""); //�ͼӻ����	
			ht25.put("CD_DEPT", ""); //�μ�								 
			ht25.put("CD_CC", ""); //�ڽ�Ʈ����		
			ht25.put("CD_PJT", ""); //������Ʈ�ڵ�	
			ht25.put("CD_CARD", ""); //�ſ�ī��			
			ht25.put("CD_EMPLOY", ""); //���					 		 
			ht25.put("NO_DEPOSIT", ""); //�����ݰ���
			ht25.put("CD_BANK", ""); //�������	
			ht25.put("NO_ITEM", ""); //item 	 

			// �ΰ�������
			ht25.put("AM_TAXSTD", ""); //����ǥ�ؾ�
			ht25.put("AM_ADDTAX", ""); //����
			ht25.put("TP_TAX", ""); //����(����) :11
			ht25.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ

			ht25.put("NM_NOTE", acc_cont); // ����				

			vt.add(ht25);
		}

		//  ĳ�������� ���ý� 
		if (ip_acct.equals("6") || ip_acct.equals("17")) {

			line++;

			String acc_cont = "[ĳ����]" + "-" + n_ven_name + " " + remark;

			if (acct_gubun.equals("D")) {
				t_pay_amt = ip_acct_amt * (-1);
			} else {
				t_pay_amt = ip_acct_amt;
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //���� 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			//ĳ����
			Hashtable ht31 = new Hashtable();

			ht31.put("WRITE_DATE", incom_dt); //row_id		
			ht31.put("ROW_NO", String.valueOf(line)); //row_no

			ht31.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
			ht31.put("CD_PC", node_code); //ȸ�����
			ht31.put("CD_WDEPT", dept_code); //�μ�
			ht31.put("NO_DOCU", ""); // row_id�� ���� 
			ht31.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
			ht31.put("CD_COMPANY", "1000");
			ht31.put("ID_WRITE", insert_id);
			ht31.put("CD_DOCU", "11");

			ht31.put("DT_ACCT", incom_dt);
			ht31.put("ST_DOCU", "1"); //�̰�:1, ����:2  

			if (acct_gubun.equals("D")) {
				ht31.put("TP_DRCR", amt_gubun); //����		
			} else {
				ht31.put("TP_DRCR", amt_gubun); //�뺯				
			}

			ht31.put("CD_ACCT", "91100"); //ī��ĳ����
			ht31.put("AMT", String.valueOf(t_pay_amt));
			ht31.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü				
			ht31.put("CD_PARTNER", n_ven_code); //�ŷ�ó    - A06

			ht31.put("DT_START", ""); //�߻�����					 
			ht31.put("CD_BIZAREA", ""); //�ͼӻ����	
			ht31.put("CD_DEPT", ""); //�μ�								 
			ht31.put("CD_CC", ""); //�ڽ�Ʈ����		
			ht31.put("CD_PJT", ""); //������Ʈ�ڵ�	
			ht31.put("CD_CARD", ""); //�ſ�ī��		 		 	
			ht31.put("CD_EMPLOY", ""); //���	
			ht31.put("NO_DEPOSIT", ""); //�����ݰ���
			ht31.put("CD_BANK", ""); //�������	
			ht31.put("NO_ITEM", ""); //item 	 

			// �ΰ�������
			ht31.put("AM_TAXSTD", ""); //����ǥ�ؾ�
			ht31.put("AM_ADDTAX", ""); //����
			ht31.put("TP_TAX", ""); //����(����) :11
			ht31.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ	 

			ht31.put("NM_NOTE", acc_cont); // ����				

			vt.add(ht31);
		}

		//  ��������� ���� ���ý� ->�����޿� (80200) ���� -  
		if (ip_acct.equals("22")) {

			line++;

			String acc_cont = "[û���������]" + "-" + n_ven_name + " " + remark;

			if (acct_gubun.equals("D")) {
				t_pay_amt = ip_acct_amt * (-1);
			} else {
				t_pay_amt = ip_acct_amt;
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //���� 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			//���������
			Hashtable ht37 = new Hashtable();

			ht37.put("WRITE_DATE", incom_dt); //row_id		
			ht37.put("ROW_NO", String.valueOf(line)); //row_no

			ht37.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
			ht37.put("CD_PC", node_code); //ȸ�����
			ht37.put("CD_WDEPT", dept_code); //�μ�
			ht37.put("NO_DOCU", ""); // row_id�� ���� 
			ht37.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
			ht37.put("CD_COMPANY", "1000");
			ht37.put("ID_WRITE", insert_id);
			ht37.put("CD_DOCU", "11");

			ht37.put("DT_ACCT", incom_dt);
			ht37.put("ST_DOCU", "1"); //�̰�:1, ����:2  

			if (acct_gubun.equals("D")) {
				ht37.put("TP_DRCR", amt_gubun); //����		
			} else {
				ht37.put("TP_DRCR", amt_gubun); //�뺯				
			}

			ht37.put("CD_ACCT", "80200"); // �����޿� ���� 
			ht37.put("AMT", String.valueOf(t_pay_amt));
			ht37.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü				
			ht37.put("CD_PARTNER", n_ven_code); //�ŷ�ó    - A06

			ht37.put("DT_START", ""); //�߻�����					 
			ht37.put("CD_BIZAREA", ""); //�ͼӻ����	
			ht37.put("CD_DEPT", ""); //�μ�								 
			ht37.put("CD_CC", ""); //�ڽ�Ʈ����		
			ht37.put("CD_PJT", ""); //������Ʈ�ڵ�	
			ht37.put("CD_CARD", ""); //�ſ�ī��		 		 	
			ht37.put("CD_EMPLOY", ""); //���	
			ht37.put("NO_DEPOSIT", ""); //�����ݰ���
			ht37.put("CD_BANK", ""); //�������	
			ht37.put("NO_ITEM", ""); //item 	 

			// �ΰ�������
			ht37.put("AM_TAXSTD", ""); //����ǥ�ؾ�
			ht37.put("AM_ADDTAX", ""); //����
			ht37.put("TP_TAX", ""); //����(����) :11
			ht37.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ	 

			ht37.put("NM_NOTE", acc_cont); // ����				

			vt.add(ht37);
		}

		// �����ޱ�
		if (ip_acct.equals("11")) {
			
			line++;

			String acc_cont = "[�����ޱ�]" + "-" + n_ven_name + " " + remark;

			if (acct_gubun.equals("D")) {
				t_pay_amt = ip_acct_amt * (-1);
			} else {
				t_pay_amt = ip_acct_amt;
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //���� 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			// �����ޱ�
			Hashtable ht36 = new Hashtable();

			ht36.put("WRITE_DATE", incom_dt); //row_id			
			ht36.put("ROW_NO", String.valueOf(line)); //row_no

			ht36.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
			ht36.put("CD_PC", node_code); //ȸ�����
			ht36.put("CD_WDEPT", dept_code); //�μ�
			ht36.put("NO_DOCU", ""); //row_id�� ���� 
			ht36.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
			ht36.put("CD_COMPANY", "1000");
			ht36.put("ID_WRITE", insert_id);
			ht36.put("CD_DOCU", "11");

			ht36.put("DT_ACCT", incom_dt);
			ht36.put("ST_DOCU", "1"); //�̰�:1, ����:2  

			if (acct_gubun.equals("D")) {
				ht36.put("TP_DRCR", amt_gubun); //����		
			} else {
				ht36.put("TP_DRCR", amt_gubun); //�뺯				
			}

			ht36.put("CD_ACCT", "13400"); // �����ޱ�
			ht36.put("AMT", String.valueOf(t_pay_amt));
			ht36.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü				
			ht36.put("CD_PARTNER", n_ven_code); //�ŷ�ó    - A06

			ht36.put("DT_START", incom_dt); //�߻�����					 
			ht36.put("CD_BIZAREA", ""); //�ͼӻ����	
			ht36.put("CD_DEPT", ""); //�μ�								 
			ht36.put("CD_CC", ""); //�ڽ�Ʈ����		
			ht36.put("CD_PJT", ""); //������Ʈ�ڵ�	
			ht36.put("CD_CARD", ""); //�ſ�ī��		 		 	
			ht36.put("CD_EMPLOY", ""); //���
			ht36.put("NO_DEPOSIT", ""); //�����ݰ���
			ht36.put("CD_BANK", ""); //�������	
			ht36.put("NO_ITEM", ""); //item 	

			// �ΰ�������
			ht36.put("AM_TAXSTD", ""); //����ǥ�ؾ�
			ht36.put("AM_ADDTAX", ""); //����
			ht36.put("TP_TAX", ""); //����(����) :11
			ht36.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ    	 

			ht36.put("NM_NOTE", acc_cont); // ����			

			vt.add(ht36);

		}

		// �������� - ���� Ȯ���� ����ȸ�� ������ �Աݰ� - , 19:��������. 20:��ݺ� , 18:���ڼ��� - ����:ȯ�޺�, �뺯: �����ұݾ�  
		// 1:�°������ 2:ä���߽ɼ�����, 3:���Ա����� ���� ��ȯ�� , 4:��å��, 12: ������, 16:�ܱ����Ա� - ����:ȯ�޺�, �뺯: �����ұݾ� , 13: ���·� �̼���  , 14:���ޱ�, 15:�̼��� 10:�����ޱ� , 9:���޼����� , 8:�ܻ����� , 7:���ݰ����� , 5:������ �� 22:��������� 
		// 24:������������Ա�, 25:����ȸ��������Ա�, 26:�ǹ������
		if (ip_acct.equals("1") || ip_acct.equals("2") || ip_acct.equals("3") || ip_acct.equals("4")
				|| ip_acct.equals("5") || ip_acct.equals("7") || ip_acct.equals("8") || ip_acct.equals("9")
				|| ip_acct.equals("10") || ip_acct.equals("12") || ip_acct.equals("13") || ip_acct.equals("14")
				|| ip_acct.equals("15") || ip_acct.equals("18") || ip_acct.equals("19") || ip_acct.equals("20")
				|| ip_acct.equals("16") || ip_acct.equals("21")  || ip_acct.equals("23") || ip_acct.equals("24") 
				|| ip_acct.equals("25") || ip_acct.equals("26") ) {

			line++;

			String acc_cont = "";
			String acct_code = "";

			if (ip_acct.equals("19")) { // ��������(45600) -> �������������(45510)
				acc_cont = "[��������]" + "-" + n_ven_name + " " + remark;
				acct_code = "45510";
			} else if (ip_acct.equals("1")) {
				acc_cont = "[�°������]" + "-" + n_ven_name + " " + remark;
				acct_code = "45510"; //��å��		  		  		 
			} else if (ip_acct.equals("2")) {
				acc_cont = "[ä���߽ɼ�����]" + "-" + n_ven_name + " " + remark;
				acct_code = "25300"; //�����ޱ� 	  		 
			} else if (ip_acct.equals("3")) {
				acc_cont = "[���Ա� ȯ��]" + "-" + n_ven_name + " " + remark;
				acct_code = "25300"; //�����ޱ�  
			} else if (ip_acct.equals("4")) { // ��å��(91800) -> �������������(45510)
				acc_cont = "[��å��]" + "-" + n_ven_name + " " + remark;
				acct_code = "45510";
			} else if (ip_acct.equals("5")) {
				acc_cont = "[������]" + "-" + n_ven_name + " " + remark;
				acct_code = "25700";
			} else if (ip_acct.equals("7")) {
				acc_cont = "[���ݰ�����]" + "-" + n_ven_name + " " + remark;
				acct_code = "46300";
			} else if (ip_acct.equals("8")) {
				acc_cont = "[�ܻ�����]" + "-" + n_ven_name + " " + remark;
				acct_code = "10800";
			} else if (ip_acct.equals("9")) {
				acc_cont = "[���޼�����]" + "-" + n_ven_name + " " + remark;
				acct_code = "83100";
			} else if (ip_acct.equals("10")) {
				acc_cont = "[�����ޱ�]" + "-" + n_ven_name + " " + remark;
				acct_code = "25300";
			} else if (ip_acct.equals("12")) {
				acc_cont = "[������]" + "-" + n_ven_name + " " + remark;
				acct_code = "93000";
			} else if (ip_acct.equals("13")) {
				acc_cont = "[���·�̼���]" + "-" + n_ven_name + " " + remark;
				acct_code = "12400";
			} else if (ip_acct.equals("14")) {
				acc_cont = "[���ޱ�]" + "-" + n_ven_name + " " + remark;
				acct_code = "13100";
			} else if (ip_acct.equals("15")) {
				acc_cont = "[�̼���]" + "-" + n_ven_name + " " + remark;
				acct_code = "12000";
			} else if (ip_acct.equals("16")) {
				acc_cont = "[�ܱ����Ա�]" + "-" + n_ven_name + " " + remark;
				acct_code = "26000";
			} else if (ip_acct.equals("18")) {
				acc_cont = "[���ڼ���]" + "-" + n_ven_name + " " + remark;
				acct_code = "90100";
			} else if (ip_acct.equals("20")) {
				acc_cont = "[��ݺ�]" + "-" + n_ven_name + " " + remark;
				acct_code = "46400";
			} else if (ip_acct.equals("21")) {
				acc_cont = "[�������]" + "-" + n_ven_name + " " + remark;
				acct_code = "81200";
			} else if (ip_acct.equals("23")) {  // ���������(45700) -> �������������(45510)
				acc_cont = "[���������]" + "-" + n_ven_name + " " + remark;
				acct_code = "45510";
			//	System.out.println("acc_cont=" + acc_cont);
			} else if (ip_acct.equals("24")) {
				acc_cont = "[������������Ա�]" + "-" + n_ven_name + " " + remark;
				acct_code = "30300";
			} else if (ip_acct.equals("25")) {
				acc_cont = "[����ȸ��������Ա�]" + "-" + n_ven_name + " " + remark;
				acct_code = "30400";
			} else if (ip_acct.equals("26")) {
				acc_cont = "[�ǹ������]" + "-" + n_ven_name + " " + remark;
				acct_code = "46200";
			}

			//ä���߽��� ��� 
			if (ip_acct.equals("2")) {
				if (acct_gubun.equals("D")) {
					t_pay_amt = ip_acct_amt;
				} else {
					t_pay_amt = ip_acct_amt * (-1);
				}
			} else {
				if (acct_gubun.equals("D")) {
					t_pay_amt = ip_acct_amt * (-1);
				} else {
					t_pay_amt = ip_acct_amt;
				}
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}
		
			System.out.println("doc_cont=" + doc_cont);
					
			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //���� 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			Hashtable ht43 = new Hashtable();

			ht43.put("WRITE_DATE", incom_dt); //row_id			
			ht43.put("ROW_NO", String.valueOf(line)); //row_no			
			ht43.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
			ht43.put("CD_PC", node_code); //ȸ�����
			ht43.put("CD_WDEPT", dept_code); //�μ�
			ht43.put("NO_DOCU", ""); //row_id�� ���� 
			ht43.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
			ht43.put("CD_COMPANY", "1000");
			ht43.put("ID_WRITE", insert_id);
			ht43.put("CD_DOCU", "11");

			ht43.put("DT_ACCT", incom_dt);
			ht43.put("ST_DOCU", "1"); //�̰�:1, ����:2  

			if (acct_gubun.equals("D")) {
				ht43.put("TP_DRCR", amt_gubun); //����		
			} else {
				ht43.put("TP_DRCR", amt_gubun); //�뺯				
			}

			ht43.put("CD_ACCT", acct_code);
			ht43.put("AMT", String.valueOf(t_pay_amt));
			ht43.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü				
			ht43.put("CD_PARTNER", n_ven_code); //�ŷ�ó    - A06

			ht43.put("DT_START", incom_dt); //�߻�����					 
			ht43.put("CD_BIZAREA", ""); //�ͼӻ����	
			ht43.put("CD_DEPT", ""); //�μ�								 
			ht43.put("CD_CC", ""); //�ڽ�Ʈ����		
			ht43.put("CD_PJT", ""); //������Ʈ�ڵ�	��
			ht43.put("CD_CARD", ""); //�ſ�ī��		 		 	
			ht43.put("CD_EMPLOY", ""); //���	
			ht43.put("NO_DEPOSIT", ""); //�����ݰ���
			ht43.put("CD_BANK", ""); //�������	
			ht43.put("NO_ITEM", ""); //item   	

			// �ΰ�������
			ht43.put("AM_TAXSTD", ""); //����ǥ�ؾ�
			ht43.put("AM_ADDTAX", ""); //����
			ht43.put("TP_TAX", ""); //����(����) :11
			ht43.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ		  	 	 

			ht43.put("NM_NOTE", acc_cont); // ����	

			vt.add(ht43);
		}

	}

	//ī�� ������
	if (ip_method.equals("2")) {

		if (card_tax > 0) {

			line++;

			String acc_cont = "[ī�������]" + "(" + i_firm_nm + ")" + card_nm;

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			//������� ������

			//������
			Hashtable ht21 = new Hashtable();

			ht21.put("WRITE_DATE", incom_dt); //row_id	
			ht21.put("ROW_NO", String.valueOf(line)); //row_no		
			ht21.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
			ht21.put("CD_PC", node_code); //ȸ�����
			ht21.put("CD_WDEPT", dept_code); //�μ�
			ht21.put("NO_DOCU", ""); //row_id�� ���� 
			ht21.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
			ht21.put("CD_COMPANY", "1000");
			ht21.put("ID_WRITE", insert_id);
			ht21.put("CD_DOCU", "11");

			ht21.put("DT_ACCT", incom_dt);
			ht21.put("ST_DOCU", "1"); //�̰�:1, ����:2  					
			ht21.put("TP_DRCR", amt_gubun);//�뺯
			ht21.put("CD_ACCT", "25700"); // ������ --> (20200410���� )
		//	ht21.put("CD_ACCT", "93000"); // ������ --> ���������� ó��(20200101���� )
			ht21.put("AMT", String.valueOf(card_tax));
			ht21.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü				

			if (card_nm.equals("KCP") || card_nm.equals("KCP2")) {
				ht21.put("CD_PARTNER", "105320"); //�ŷ�ó    - A06  �ѱ����̹�����(KCP)
			} else if (card_nm.equals("���̿�")) {
				ht21.put("CD_PARTNER", "996282"); //�ŷ�ó    - ���̿�(payat)		
			} else if (card_nm.equals("���̽�")) {
				ht21.put("CD_PARTNER", "996283"); //�ŷ�ó    - ���̽� 	
			} else if (card_nm.equals("�̳�����")) {
				ht21.put("CD_PARTNER", "996548"); //�ŷ�ó    - �̳����� 		
			} else {
				ht21.put("CD_PARTNER", "109691"); //�ŷ�ó    - A06		
			}

			ht21.put("DT_START", ""); //�߻�����				 
			ht21.put("CD_BIZAREA", ""); //�ͼӻ����	
			ht21.put("CD_DEPT", ""); //�μ�								 
			ht21.put("CD_CC", ""); //�ڽ�Ʈ����		
			ht21.put("CD_PJT", ""); //������Ʈ�ڵ�	
			ht21.put("CD_CARD", ""); //�ſ�ī��		 		 	
			ht21.put("CD_EMPLOY", ""); //���	
			ht21.put("NO_DEPOSIT", ""); //�����ݰ���
			ht21.put("CD_BANK", ""); //�������	
			ht21.put("NO_ITEM", ""); //item   	

			// �ΰ�������
			ht21.put("AM_TAXSTD", ""); //����ǥ�ؾ�
			ht21.put("AM_ADDTAX", ""); //����
			ht21.put("TP_TAX", ""); //����(����) :11
			ht21.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ	  	 	 

			ht21.put("NM_NOTE", acc_cont); // ����	

			vt.add(ht21);
		}

	}

	if (ip_method.equals("2")) {
		line++;

		//ī�� �̼���
		Hashtable ht22 = new Hashtable();

		ht22.put("WRITE_DATE", incom_dt); //row_id	
		ht22.put("ROW_NO", String.valueOf(line)); //row_no		
		ht22.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
		ht22.put("CD_PC", node_code); //ȸ�����
		ht22.put("CD_WDEPT", dept_code); //�μ�
		ht22.put("NO_DOCU", ""); //row_id�� ���� 
		ht22.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
		ht22.put("CD_COMPANY", "1000");
		ht22.put("ID_WRITE", insert_id);
		ht22.put("CD_DOCU", "11");

		ht22.put("DT_ACCT", incom_dt);
		ht22.put("ST_DOCU", "1"); //�̰�:1, ����:2  					
		ht22.put("TP_DRCR", "1");//����
		ht22.put("CD_ACCT", "12000"); // �̼���
		ht22.put("AMT", String.valueOf(incom_amt));
		ht22.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü				

		if (card_nm.equals("KCP") || card_nm.equals("KCP2")) {
			ht22.put("CD_PARTNER", "105320"); //�ŷ�ó    - A06  �ѱ����̹�����(KCP)		
		} else if (card_nm.equals("���̿�")) {
			ht22.put("CD_PARTNER", "996282"); //�ŷ�ó    - ���̿�(payat)			
		} else if (card_nm.equals("���̽�")) {
			ht22.put("CD_PARTNER", "996283"); //�ŷ�ó    - ���̽� 	
		} else if (card_nm.equals("�̳�����")) {
			ht22.put("CD_PARTNER", "996548"); //�ŷ�ó    - �̳����� 			
		} else {

			ht22.put("CD_PARTNER", "109691"); //�ŷ�ó    - A06		
		}

		ht22.put("DT_START", ""); //�߻�����				 
		ht22.put("CD_BIZAREA", ""); //�ͼӻ����	
		ht22.put("CD_DEPT", ""); //�μ�								 
		ht22.put("CD_CC", ""); //�ڽ�Ʈ����		
		ht22.put("CD_PJT", ""); //������Ʈ�ڵ�	
		ht22.put("CD_CARD", ""); //�ſ�ī��		 		 	
		ht22.put("CD_EMPLOY", ""); //���	
		ht22.put("NO_DEPOSIT", ""); //�����ݰ���
		ht22.put("CD_BANK", ""); //�������	
		ht22.put("NO_ITEM", ""); //item   

		// �ΰ�������
		ht22.put("AM_TAXSTD", ""); //����ǥ�ؾ�
		ht22.put("AM_ADDTAX", ""); //����
		ht22.put("TP_TAX", ""); //����(����) :11
		ht22.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ				  	 	 	 	 

		ht22.put("NM_NOTE", doc_cont); // ����	

		vt.add(ht22);

	} else if (ip_method.equals("5")) { //��ü	

		if (neom.equals("Y") || neom1.equals("Y")) {
			line++;

			doc_cont = "[��üó��] " + doc_cont;

			//�����ޱ�
			Hashtable ht24 = new Hashtable();

			ht24.put("WRITE_DATE", incom_dt); //row_id	
			ht24.put("ROW_NO", String.valueOf(line)); //row_no			
			ht24.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
			ht24.put("CD_PC", node_code); //ȸ�����
			ht24.put("CD_WDEPT", dept_code); //�μ�
			ht24.put("NO_DOCU", ""); //row_id�� ���� 
			ht24.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
			ht24.put("CD_COMPANY", "1000");
			ht24.put("ID_WRITE", insert_id);
			ht24.put("CD_DOCU", "11");

			ht24.put("DT_ACCT", incom_dt);
			ht24.put("ST_DOCU", "1"); //�̰�:1, ����:2  					
			ht24.put("TP_DRCR", "1");//����
			ht24.put("CD_ACCT", "25300"); //�����ޱ�
			ht24.put("AMT", String.valueOf(incom_amt));
			ht24.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü					
			ht24.put("CD_PARTNER", ven_code); //�ŷ�ó    - A06

			ht24.put("DT_START", ""); //�߻�����					 
			ht24.put("CD_BIZAREA", ""); //�ͼӻ����	
			ht24.put("CD_DEPT", ""); //�μ�								 
			ht24.put("CD_CC", ""); //�ڽ�Ʈ����		
			ht24.put("CD_PJT", ""); //������Ʈ�ڵ�	
			ht24.put("CD_CARD", ""); //�ſ�ī��		 		 	
			ht24.put("CD_EMPLOY", ""); //���	
			ht24.put("NO_DEPOSIT", ""); //�����ݰ���
			ht24.put("CD_BANK", ""); //�������	
			ht24.put("NO_ITEM", ""); //item   		

			// �ΰ�������
			ht24.put("AM_TAXSTD", ""); //����ǥ�ؾ�
			ht24.put("AM_ADDTAX", ""); //����
			ht24.put("TP_TAX", ""); //����(����) :11
			ht24.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ		 	 	 	 	  	 

			ht24.put("NM_NOTE", doc_cont); // ����	

			vt.add(ht24);
		}

	} else if (ip_method.equals("3")) { //����	

		if (neom.equals("Y") || neom1.equals("Y")) {
			line++;

			//����
			Hashtable ht41 = new Hashtable();

			ht41.put("WRITE_DATE", incom_dt); //row_id	
			ht41.put("ROW_NO", String.valueOf(line)); //row_no			
			ht41.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
			ht41.put("CD_PC", node_code); //ȸ�����
			ht41.put("CD_WDEPT", dept_code); //�μ�
			ht41.put("NO_DOCU", ""); //row_id�� ���� 
			ht41.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
			ht41.put("CD_COMPANY", "1000");
			ht41.put("ID_WRITE", insert_id);
			ht41.put("CD_DOCU", "11");

			ht41.put("DT_ACCT", incom_dt);
			ht41.put("ST_DOCU", "1"); //�̰�:1, ����:2  					
			ht41.put("TP_DRCR", "1");//����
			ht41.put("CD_ACCT", "10100"); //����
			ht41.put("AMT", String.valueOf(incom_amt));
			ht41.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü					
			ht41.put("CD_PARTNER", ""); //�ŷ�ó    - A06

			ht41.put("DT_START", ""); //�߻�����					 
			ht41.put("CD_BIZAREA", ""); //�ͼӻ����	
			ht41.put("CD_DEPT", dept_code); //�μ�								 
			ht41.put("CD_CC", ""); //�ڽ�Ʈ����		
			ht41.put("CD_PJT", ""); //������Ʈ�ڵ�	
			ht41.put("CD_CARD", ""); //�ſ�ī��		 		 	
			ht41.put("CD_EMPLOY", ""); //���	
			ht41.put("NO_DEPOSIT", ""); //�����ݰ���
			ht41.put("CD_BANK", ""); //�������	
			ht41.put("NO_ITEM", ""); //item   		

			// �ΰ�������
			ht41.put("AM_TAXSTD", ""); //����ǥ�ؾ�
			ht41.put("AM_ADDTAX", ""); //����
			ht41.put("TP_TAX", ""); //����(����) :11
			ht41.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ		 	 	 	 	  	 

			ht41.put("NM_NOTE", doc_cont); // ����	

			vt.add(ht41);
		}

	} else if (ip_method.equals("1")) {

		if (neom.equals("Y") || neom1.equals("Y")) {

			line++;

			//���뿹��
			Hashtable ht1 = new Hashtable();

			ht1.put("WRITE_DATE", incom_dt); //row_id			
			ht1.put("ROW_NO", String.valueOf(line)); //row_no

			ht1.put("NO_TAX", "*"); //�ΰ��� �ܴ̿� *
			ht1.put("CD_PC", node_code); //ȸ�����
			ht1.put("CD_WDEPT", dept_code); //�μ�
			ht1.put("NO_DOCU", ""); //row_id�� ���� 
			ht1.put("NO_DOLINE", String.valueOf(line)); //row_no  : �̰��� ���???
			ht1.put("CD_COMPANY", "1000");
			ht1.put("ID_WRITE", insert_id);
			ht1.put("CD_DOCU", "11");

			ht1.put("DT_ACCT", incom_dt);
			ht1.put("ST_DOCU", "1"); //�̰�:1, ����:2  					
			ht1.put("TP_DRCR", "1");//����
			ht1.put("CD_ACCT", "10300"); //���뿹��
			ht1.put("AMT", String.valueOf(incom_amt));
			ht1.put("TP_GUBUN", docu_gubun); //1:�Ա� 2:��� 3:��ü				
			ht1.put("CD_PARTNER", ""); //�ŷ�ó    - A06

			ht1.put("DT_START", ""); //�߻�����					 
			ht1.put("CD_BIZAREA", ""); //�ͼӻ����	
			ht1.put("CD_DEPT", ""); //�μ�								 
			ht1.put("CD_CC", ""); //�ڽ�Ʈ����		
			ht1.put("CD_PJT", ""); //������Ʈ�ڵ�	
			ht1.put("CD_CARD", ""); //�ſ�ī��		 		 	
			ht1.put("CD_EMPLOY", ""); //���
			ht1.put("NO_DEPOSIT", deposit_no); //�����ݰ���
			ht1.put("CD_BANK", bank_code); //�������	
			ht1.put("NO_ITEM", ""); //item

			// �ΰ�������
			ht1.put("AM_TAXSTD", ""); //����ǥ�ؾ�
			ht1.put("AM_ADDTAX", ""); //����
			ht1.put("TP_TAX", ""); //����(����) :11
			ht1.put("NO_COMPANY", ""); //����ڵ�Ϲ�ȣ

			ht1.put("NM_NOTE", doc_cont); // ����			

			vt.add(ht1);

		}

	}

	if (vt.size() > 0) {
		row_id = neoe_db.insertSetAutoDocu(incom_dt, vt);
	}

	//�Աݿ���ó�� - jung_type :1->�Ϸ�
	if (not_yet.equals("1")) {
		if (!in_db.updateIncomSet(incom_dt, incom_seq, not_yet_reason, "2"))
			flag += 1;
	} else {
		if (!in_db.updateIncomSet(incom_dt, incom_seq, "1", card_tax, ip_method, doc_cont, a_cal_tax, row_id))
			flag += 1;
	}
	
	//row_idó��  -
	if (row_id.equals("0"))  flag += 1;
	
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
    fm.action='<%=from_page%>';
   
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>

</body>
</html>
