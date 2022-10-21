<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.common.*, acar.cus_samt.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<body>
<%

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
					
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");	
	String acct_dt = request.getParameter("acct_dt")==null?AddUtil.getDate(4):request.getParameter("acct_dt");
	
	String s_year = acct_dt.substring(0,4);
	String s_mon = acct_dt.substring(4,6);
	String s_day = acct_dt.substring(6,8);
	
//	System.out.println("acct_dt="+ acct_dt);
//	System.out.println("acct="+ acct);
//	System.out.println("s_mon="+ s_mon);
//	System.out.println("s_day="+ s_day);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();
		
	Vector sers = cs_db.getServNewJList(acct, "3", s_year, s_mon, s_day, "", "", sort, asc);
			
	int ser_size = sers.size();
	
	//long amt8_old = 0;
	long amt[] 	= new long[12];
	
	long vat_amt  = 0;
	long gr_amt = 0;
	
	long r_labor  = 0;
	long amt_91800 =  0;	//��å�� minus 	
	
	long t_vat2 = 0;
	long vat2 = 0;
	
	String jungsan = "";
	String chk_jungsan = "";
	
	String s_set_dt = "";
	String s_jung_st = "";
	
	String s_yy		 = "";
	String s_mm		 = "";
		
	int ii = 0;
	int kk =0;
	String value[] = new String[2];
	boolean header = false;
	
	
	String i_ven_code = "";
	
	i_ven_code = cs_db.getServOffVenCode(acct);
	i_ven_code = i_ven_code.trim();
					
	//�ڵ���ǥ ����-�׿��� �ڵ���ǥ ó��
	String autodoc = request.getParameter("autodoc")==null?"N":request.getParameter("autodoc");
			
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
			
  	String firm_name=neoe_db.getCodeByNm("ven", i_ven_code);
	

	String ven_type = "0";  //����ڵ��
	String s_idno = neoe_db.getVendorEnpNo(i_ven_code);
							
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));
	String node_code ="S101";  //�׿��� iu ������ ȸ�����:S101	
											
	int flag = 0;
	int count =0;
	boolean flag1 = true;
	
	String car_no		="";
	String k_name		="";
	String sa_code		="";
	
	String labor 		="";
	  		
	Vector vt_auto = new Vector();
	
	Vector vt_save = new Vector();  //����ȸ�� ����Ÿ ���� - ������ (20191216)
		
	int line =0;
	String doc_cont = "";	
	int data_no = 0;
	String row_id = "";
	String s_row_id = "";
		
	for(int i = 0 ; i < ser_size ; i++){
			Hashtable exp = (Hashtable)sers.elementAt(i);

			jungsan = String.valueOf(exp.get("SS_DT")) +"^"+ String.valueOf(exp.get("SSS_ST"));  //������/����ȸ��
			 
			kk++;
			 
			if (i==0) { 
				 chk_jungsan = jungsan;
				 header = true;		
			}
					 
			StringTokenizer st = new StringTokenizer(jungsan,"^");
			int s=0;
			
			while(st.hasMoreTokens()){
				value[s] = st.nextToken();
				s++;
			}
			
			s_set_dt	= value[0];
			s_jung_st	= value[1];
								
			s_yy = s_set_dt.substring(0,4);
			s_mm = s_set_dt.substring(4,6);	
				 
			if (  !chk_jungsan.equals(jungsan) ) {	
				 //header = true;	 	
				// System.out.println("chk_jungsan="+ chk_jungsan + " vat2="+ vat2);		 
				 vat2 = vat2*10/100;  		 
				 vat2  =AddUtil.l_th_rnd_long(vat2);	
				 t_vat2=t_vat2 + vat2;
			//	 System.out.println("vat2="+ vat2 + " t_vat2="+ t_vat2);    
						 
				 vat2 = 0;
				 chk_jungsan = jungsan;   
			 }
		%>
		   	 
		<% // header ���
		 if ( header ) {	
			   ii++;
			   kk=0;    
		
			   header = false;
			   chk_jungsan = jungsan; 	
   		} 
	   %>   
       <%  		
			// ���� ��� ���Ǻ���
			 int our_fault = 0;
			 String ch_fault = "";
			 String ch_acc_st = "";
			 
			 String o_fault= cs_db.getOutFaultPer( (String)exp.get("CAR_MNG_ID"), (String)exp.get("ACCID_ID"));
			
			 StringTokenizer token2 = new StringTokenizer(o_fault,"^");
			
			 while(token2.hasMoreTokens()) {
					ch_fault = token2.nextToken().trim();	 
					ch_acc_st = token2.nextToken().trim();	 			
			 }
			 our_fault = AddUtil.parseInt (ch_fault);
			 
			 //�Ҽ��ΰ�� �Ҽ��� ��������� 
			 if ( !String.valueOf(exp.get("J_FAULT_PER")).equals("0") )  { 
				 our_fault =  AddUtil.parseInt(String.valueOf(exp.get("J_FAULT_PER"))) ;
			 }
			 
			 
			 long v_amt = AddUtil.parseLong((String)exp.get("AMT")); //��ǰ
			 
			 long v_dc_sup_amt = AddUtil.parseLong((String)exp.get("DC_SUP_AMT")); // dc ���ް�
			 
			 if ( exp.get("SERV_ST").equals("����")){	
			 	 	 v_amt = v_amt * our_fault/100;
		
			 }  
			 
			  //�ϴ��� ����   -20120223
			  v_amt  =AddUtil.l_th_rnd_long(v_amt);
			  v_dc_sup_amt  =AddUtil.l_th_rnd_long(v_dc_sup_amt);
				   
			 long v_labor = AddUtil.parseLong((String)exp.get("LABOR")); //����
			 
			  
			if ( exp.get("SERV_ST").equals("����")){   			
			 		 v_labor = v_labor * our_fault/100;			
			 }  
		   	 
			// long v_c_labor = AddUtil.parseLong((String)exp.get("A_LABOR")); //���� ���� ���� :õ����:dc���� 1~2õ����:10% 2~3õ����:15%, 3õ�����̻�:20% - ����dc ����
						 
			 long v_cnt =  AddUtil.parseLong((String)exp.get("CNT"));
			 
			 long v_cust_amt =  AddUtil.parseLong((String)exp.get("CUST_AMT"));
			 long v_ext_amt =  AddUtil.parseLong((String)exp.get("EXT_AMT"));
			 
			 StringTokenizer token1 = new StringTokenizer((String)exp.get("ITEM"),"^");
			 
			 String item1 = "";
			 String item2 = "";
			   
		     while(token1.hasMoreTokens()) {
			
			  	 item1 = token1.nextToken().trim();	//
			   	 item2 = token1.nextToken().trim();	//��ǰ							
		     }	
		  
		   
		    int c_rate = 0;
		    int vc_rate = 0;
		    int jj_amt = 0;
		    int jjj_amt = 0;
			   			 
			long s_dt = 	AddUtil.parseLong(String.valueOf(exp.get("SS_DT")));					   
		
			long  j_labor = v_labor - vc_rate; //����
			
			//�ϴ��� ���� - 20120223
			j_labor = AddUtil.l_th_rnd_long(j_labor);
									
		 	String item_nm = "";
		 			 	
		 	if(String.valueOf(exp.get("CNT")).equals("1")){  	item_nm = item2;
			}else{
			   item_nm = Util.subData(item2, 10)+ " ��" + AddUtil.parseDecimal(v_cnt - 1) + " ��";		  
			}
		 		 
		    doc_cont = Util.subData(String.valueOf(exp.get("CLIENT_NM")), 13) + " " + item_nm  + " " + exp.get("CAR_NO");
			k_name = c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER");
			sa_code   = c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER_SA");
			car_no = (String)exp.get("CAR_NO");
			
			amt[6]   = amt[6] + j_labor + v_amt - v_ext_amt - v_dc_sup_amt ;  //�Ѱ�
			
			amt[10]   = amt[10] + v_ext_amt;   //��������
			
			amt[11]   = amt[11] + v_dc_sup_amt;   //dc ������
			
			//ȸ���� vat ���� ��� 
     		vat2    = vat2  + j_labor + v_amt - v_ext_amt - v_dc_sup_amt; //vat���� 
			
			if (  j_labor != 0  ||  v_cust_amt   > 0 || v_ext_amt  > 0 )  { 
			  	
			  	line++;
							 				
				Hashtable ht7 = new Hashtable();		// ��������� or  ��������	
				
				ht7.put("WRITE_DATE", 	acct_dt); //row_id							
				ht7.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht7.put("CD_PC",  	node_code);  //ȸ�����
				ht7.put("CD_WDEPT",  dept_code);  //�μ�
				ht7.put("NO_DOCU",  	"");  //�̰��� '0'  -> row_id �� ����
				ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht7.put("CD_COMPANY",  "1000");  
				ht7.put("ID_WRITE", insert_id);   
				ht7.put("CD_DOCU",  "11");  
				
				ht7.put("DT_ACCT", 	acct_dt); 
				ht7.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht7.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
				
				if ( v_cust_amt > 0 || v_ext_amt  > 0  ) {
					ht7.put("CD_ACCT",  "45510");   // ��������(45600) -> ������������� 45510���� ó�� (20211101)
				} else {
					ht7.put("CD_ACCT",  "45510");   // ���������(45700) -> ������������� 45510���� ó�� (20211101)
				}
				
				ht7.put("AMT",    	String.valueOf(j_labor) );			
				ht7.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht7.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht7.put("DT_START",  "");  	//�߻�����										 
				ht7.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht7.put("CD_DEPT",		"");   //�μ�								 
				ht7.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht7.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht7.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht7.put("CD_EMPLOY",		sa_code);   //���									 		 
				ht7.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht7.put("CD_BANK",		"");  //�������	
				ht7.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht7.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht7.put("AM_ADDTAX",	"" );	 //����
				ht7.put("TP_TAX",	"");  //����(����) :11
				ht7.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
				ht7.put("YN_ISS",	  "");  //���ڼ��� ��꼭 
						
				ht7.put("NM_NOTE", doc_cont);  // ����
											
				vt_auto.add(ht7);  //  // ��������� or  ��������	
			
			}
				
		//	System.out.println("ht7 line = " + line);
			
			if ( v_amt  != 0 )  {   //�ߺ����� ���� ��ǰ ���̳ʽ��� �ִ�.
			  	line++;
			  				 
				Hashtable ht8 = new Hashtable();		// ���� ��ǰ��
				
				ht8.put("WRITE_DATE", 	acct_dt); //row_id							
				ht8.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht8.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht8.put("CD_PC",  	node_code);  //ȸ�����
				ht8.put("CD_WDEPT",  dept_code);  //�μ�
				ht8.put("NO_DOCU",  	"");  //�̰��� '0'  -> row_id �� ����
				ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht8.put("CD_COMPANY",  "1000");  
				ht8.put("ID_WRITE", insert_id);   
				ht8.put("CD_DOCU",  "11");  
				
				ht8.put("DT_ACCT", 	acct_dt); 
				ht8.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht8.put("TP_DRCR",   "1");   // �뺯:2 , ����:1						
				ht8.put("CD_ACCT",  "45510");   // ��ǰ(46000) -> ������������� 45510���� ó�� (20211101)				
				ht8.put("AMT",    	String.valueOf(v_amt) );			
				ht8.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht8.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht8.put("DT_START",  "");  	//�߻�����										 
				ht8.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht8.put("CD_DEPT",		"");   //�μ�								 
				ht8.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht8.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht8.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht8.put("CD_EMPLOY",		sa_code);   //���									 		 
				ht8.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht8.put("CD_BANK",		"");  //�������	
				ht8.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht8.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht8.put("AM_ADDTAX",	"" );	 //����
				ht8.put("TP_TAX",	"");  //����(����) :11
				ht8.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
				ht8.put("YN_ISS",	  "");  //���ڼ��� ��꼭 
						
				ht8.put("NM_NOTE", doc_cont);  // ����				
											
				vt_auto.add(ht8);  //  ������ǰ��
			}
			
		//	System.out.println("ht7_1 ����ȸ��"); // 20191216 
			Hashtable ht7_1 = new Hashtable();		// ��������� or  ��������	
			ht7_1.put("ACCT_DT", 	acct_dt); 
			ht7_1.put("SET_DT", 	String.valueOf(exp.get("SET_DT"))); 
			ht7_1.put("SERV_DT", 	String.valueOf(exp.get("SERV_DT"))); 
			ht7_1.put("CAR_MNG_ID", 	String.valueOf(exp.get("CAR_MNG_ID"))); 
			ht7_1.put("RENT_L_CD", 	String.valueOf(exp.get("RENT_L_CD"))); 			
			ht7_1.put("SERV_ST", 	String.valueOf(exp.get("SERV_ST"))); 
			ht7_1.put("JUNG_ST", 	String.valueOf(exp.get("JUNG_ST"))); 								
			ht7_1.put("OUR_FAULT",  String.valueOf(our_fault) );	
			ht7_1.put("V_AMT",    	String.valueOf(v_amt) );		
			ht7_1.put("V_LABOR",    	String.valueOf(v_labor) );		
			ht7_1.put("V_CUST_AMT",    	String.valueOf(v_cust_amt) );		
			ht7_1.put("V_EXT_AMT",    	String.valueOf(v_ext_amt) );	
			ht7_1.put("CAR_NO", 	String.valueOf(exp.get("CAR_NO"))); 	
			ht7_1.put("OFF_ID", 	acct); 	
			
			vt_save.add(ht7_1);  //  ���굥��Ÿ ���� 
	}
	
//	vat_amt =  amt[6] * 10/100;
	
	 //vat  �ϴ��� ����   -20120223
//	vat_amt  =AddUtil.l_th_rnd_long(vat_amt);
				   
//	gr_amt = amt[6] + vat_amt ;
  	
//�庰 �ΰ��� ����ó�� �� �հ�-2022-02-10
	vat2 = vat2*10/100;  	
	vat2  =AddUtil.l_th_rnd_long(vat2);	
	t_vat2=t_vat2 + vat2;
	
	gr_amt = amt[6] + t_vat2 ; //�����ޱ�

	doc_cont = firm_name  + " "  + s_year + "�� " + s_mon + "�� " + s_day +"��  ���������"; //����
				
	line++;
	
	Hashtable ht9 = new Hashtable();		// �ΰ���
	
	ht9.put("WRITE_DATE", 	acct_dt); //row_id							
	ht9.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht9.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� *
	ht9.put("CD_PC",  	node_code);  //ȸ�����
	ht9.put("CD_WDEPT",  dept_code);  //�μ�
	ht9.put("NO_DOCU",  	"");  //�̰��� '0'  -> row_id �� ����
	ht9.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht9.put("CD_COMPANY",  "1000");  
	ht9.put("ID_WRITE", insert_id);   
	ht9.put("CD_DOCU",  "11");  
	
	ht9.put("DT_ACCT", 	acct_dt); 
	ht9.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht9.put("TP_DRCR",   "1");   // �뺯:2 , ����:1						
	ht9.put("CD_ACCT",  "13500");   // �ΰ�����ޱ�		
//	ht9.put("AMT",    	String.valueOf(vat_amt) );		
	ht9.put("AMT",    	String.valueOf(t_vat2) );	
	ht9.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
	ht9.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
								
	ht9.put("DT_START",  acct_dt);  	//�߻�����										 
	ht9.put("CD_BIZAREA",	"S101");   //�ͼӻ����	  //�ΰ��� �ͼ��� S101
	ht9.put("CD_DEPT",		"");   //�μ�								 
	ht9.put("CD_CC",			"");   //�ڽ�Ʈ����		
	ht9.put("CD_PJT",			"");   //������Ʈ�ڵ�		
	ht9.put("CD_CARD",		"");   //�ſ�ī��		 	
	ht9.put("CD_EMPLOY",		"");   //���									 		 
	ht9.put("NO_DEPOSIT",	"");  //�����ݰ���
	ht9.put("CD_BANK",		"");  //�������	
	ht9.put("NO_ITEM",		"");  //item	  	 
	
		// �ΰ�������
	ht9.put("AM_TAXSTD",	 String.valueOf( amt[6] ) );	 //����ǥ�ؾ�
//	ht9.put("AM_ADDTAX",	String.valueOf( vat_amt) );		 //����
	ht9.put("AM_ADDTAX",	String.valueOf( t_vat2) );		 //����
	ht9.put("TP_TAX",	"21");  //����(����) :11, ����(����):21
	ht9.put("NO_COMPANY",	  s_idno);  //����ڵ�Ϲ�ȣ
	ht9.put("YN_ISS",	  "2");  //���ڼ��� ��꼭 
			
	ht9.put("NM_NOTE",  doc_cont  + " �ΰ���"); // ����									
						
	vt_auto.add(ht9);  //  // ��������� or  ��������		
	
	if ( amt[10]  > 0 ) { 
		//�� ���Ա��� �ִ� ���
		line++;
		
		amt_91800 = amt[10] * (-1);
		Hashtable ht11 = new Hashtable();		//���ع��� �հ�
		
		ht11.put("WRITE_DATE", 	acct_dt); //row_id							
		ht11.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht11.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht11.put("CD_PC",  	node_code);  //ȸ�����
		ht11.put("CD_WDEPT",  dept_code);  //�μ�
		ht11.put("NO_DOCU",  	"");  //�̰��� '0'  -> row_id �� ����
		ht11.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht11.put("CD_COMPANY",  "1000");  
		ht11.put("ID_WRITE", insert_id);   
		ht11.put("CD_DOCU",  "11");  
		
		ht11.put("DT_ACCT", 	acct_dt); 
		ht11.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	//	ht11.put("TP_DRCR",   "2");   // �뺯:2 , ����:1						
	//	ht11.put("CD_ACCT",  "91800");   // ���ع���(91800)		
		ht11.put("TP_DRCR",   "1");   // �뺯:2 , ����:1						
		ht11.put("CD_ACCT",  "45510");   // ���ع���(91800) -> ������������� 45510���� ó�� (20211101)	
		
		ht11.put("AMT",    	String.valueOf(amt_91800) );	//			
		ht11.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
		ht11.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
									
		ht11.put("DT_START",   		"");  	//�߻�����										 
		ht11.put("CD_BIZAREA",		"");   //�ͼӻ����	
		ht11.put("CD_DEPT",		"");   //�μ�								 
		ht11.put("CD_CC",			"");   //�ڽ�Ʈ����		
		ht11.put("CD_PJT",			"");   //������Ʈ�ڵ�		
		ht11.put("CD_CARD",		"");   //�ſ�ī��		 	
		ht11.put("CD_EMPLOY",		"");   //���									 		 
		ht11.put("NO_DEPOSIT",	"");  //�����ݰ���
		ht11.put("CD_BANK",		"");  //�������	
		ht11.put("NO_ITEM",		"");  //item	  	 
		
			// �ΰ�������
		ht11.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
		ht11.put("AM_ADDTAX",	"" );	 //����
		ht11.put("TP_TAX",	"");  //����(����) :11
		ht11.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
		ht11.put("YN_ISS",	  "");  //���ڼ��� ��꼭 
		
		ht11.put("NM_NOTE",  doc_cont  + " ���Ա�"); // ����									
																
		vt_auto.add(ht11);  //  ��������
	}
	
	if ( amt[11]  > 0 ) { 
		//dc�� �ִ� ���
		line++;
		
		Hashtable ht12 = new Hashtable();		//���ع��� �հ�
		
		ht12.put("WRITE_DATE", 	acct_dt); //row_id							
		ht12.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht12.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht12.put("CD_PC",  	node_code);  //ȸ�����
		ht12.put("CD_WDEPT",  dept_code);  //�μ�
		ht12.put("NO_DOCU",  	"");  //�̰��� '0'  -> row_id �� ����
		ht12.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht12.put("CD_COMPANY",  "1000");  
		ht12.put("ID_WRITE", insert_id);   
		ht12.put("CD_DOCU",  "11");  
		
		ht12.put("DT_ACCT", 	acct_dt); 
		ht12.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht12.put("TP_DRCR",   "2");   // �뺯:2 , ����:1						
		ht12.put("CD_ACCT",  "93000");   // ������	
		ht12.put("AMT",    	String.valueOf(amt[11]) );				
		ht12.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
		ht12.put("CD_PARTNER",	"000131");//�ŷ�ó    - A06
									
		ht12.put("DT_START",   		"");  	//�߻�����										 
		ht12.put("CD_BIZAREA",		"");   //�ͼӻ����	
		ht12.put("CD_DEPT",		"");   //�μ�								 
		ht12.put("CD_CC",			"");   //�ڽ�Ʈ����		
		ht12.put("CD_PJT",			"");   //������Ʈ�ڵ�		
		ht12.put("CD_CARD",		"");   //�ſ�ī��		 	
		ht12.put("CD_EMPLOY",		"");   //���									 		 
		ht12.put("NO_DEPOSIT",	"");  //�����ݰ���
		ht12.put("CD_BANK",		"");  //�������	
		ht12.put("NO_ITEM",		"");  //item	  	 
		
			// �ΰ�������
		ht12.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
		ht12.put("AM_ADDTAX",	"" );	 //����
		ht12.put("TP_TAX",	"");  //����(����) :11
		ht12.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
		ht12.put("YN_ISS",	  "");  //���ڼ��� ��꼭 
		
		ht12.put("NM_NOTE",  doc_cont  + " ������"); // ����									
																
		vt_auto.add(ht12);  //  ������
	}
			
	line++;
	
	Hashtable ht10 = new Hashtable();		// ������ �հ�
	
	ht10.put("WRITE_DATE", 	acct_dt); //row_id							
	ht10.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht10.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
	ht10.put("CD_PC",  	node_code);  //ȸ�����
	ht10.put("CD_WDEPT",  dept_code);  //�μ�
	ht10.put("NO_DOCU",  	"");  //�̰��� '0'  -> row_id �� ����
	ht10.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht10.put("CD_COMPANY",  "1000");  
	ht10.put("ID_WRITE", insert_id);   
	ht10.put("CD_DOCU",  "11");  
	
	ht10.put("DT_ACCT", 	acct_dt); 
	ht10.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht10.put("TP_DRCR",   "2");   // �뺯:2 , ����:1						
	ht10.put("CD_ACCT",   	"25300");   // �����ޱ�	
	ht10.put("AMT",    	String.valueOf(gr_amt) );			
	ht10.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
	ht10.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
								
	ht10.put("DT_START",  acct_dt);  	//�߻�����										 
	ht10.put("CD_BIZAREA",			"");   //�ͼӻ����		
	ht10.put("CD_DEPT",		"");   //�μ�								 
	ht10.put("CD_CC",			"");   //�ڽ�Ʈ����		
	ht10.put("CD_PJT",			"");   //������Ʈ�ڵ�		
	ht10.put("CD_CARD",		"");   //�ſ�ī��		 	
	ht10.put("CD_EMPLOY",		"");   //���									 		 
	ht10.put("NO_DEPOSIT",	"");  //�����ݰ���
	ht10.put("CD_BANK",		"");  //�������	
	ht10.put("NO_ITEM",		"");  //item	  	 
	
		// �ΰ�������
	ht10.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
	ht10.put("AM_ADDTAX",	"" );	 //����
	ht10.put("TP_TAX",	"");  //����(����) :11
	ht10.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
	ht10.put("YN_ISS",	  "");  //���ڼ��� ��꼭 
	
	ht10.put("NM_NOTE",  doc_cont ); // ����									
							
	vt_auto.add(ht10);  //  // ��������� or  ��������	
		
	 if ( vt_auto.size() > 0){
		row_id =neoe_db.insertSetAutoDocu(acct_dt,  vt_auto);
  	}
		
//	System.out.println("row_id="+ row_id);
	   	
	//���굥��Ÿ ���� 
	 if ( vt_save.size() > 0){
		s_row_id =cs_db.insertSetCusSamt(acct_dt,  vt_save);
  	 }
	
	//��ǥ������ �߰� - t_wd:jung_st
	if(!cs_db.updateServiceAutoDocuDt(s_year, s_mon, s_day,  "", acct, acct_dt, user_id)) flag += 1;
	
	//�������ǥ
	System.out.println("�������ǥ=" + doc_cont );
%>
<form name='form1' method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="gubun1" value="3">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">
</form>

<script language='javascript'>

<%	if(flag != 0){%>
		alert('�����߻�!');
<%	}else if(row_id.equals("1") ){%>
		alert('�ڵ���ǥ �����߻�!');	
<%	}else{%>
		alert('ó���Ǿ����ϴ�');			
<%	}%>
	
</script>
</body>
</html>
