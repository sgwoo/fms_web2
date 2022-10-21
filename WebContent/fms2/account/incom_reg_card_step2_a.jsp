<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*, acar.common.*, acar.user_mng.*, acar.credit.*, tax.*"%>
<%@ page import="acar.cont.*, acar.bill_mng.*, acar.client.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")		==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
			
	String bank_code 	= request.getParameter("bank_code2")	==null?"":request.getParameter("bank_code2");
	String deposit_no 	= request.getParameter("deposit_no2")	==null?"":request.getParameter("deposit_no2");		
	String bank_name 	= request.getParameter("bank_name")	==null?"":request.getParameter("bank_name");
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	int    incom_amt 	 	= request.getParameter("incom_amt")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_amt"));
	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
	
	String not_yet 	= request.getParameter("not_yet")==null?"0":request.getParameter("not_yet");  //1:������
	String not_yet_reason 	= request.getParameter("not_yet_reason")==null?"":request.getParameter("not_yet_reason");  //1:������	
		
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();		
		
	
	
	String value0[]  = request.getParameterValues("gubun"); //scd_card
	String value1[]  = request.getParameterValues("card_dt");
	String value2[]  = request.getParameterValues("card_seq");
	String value3[]  = request.getParameterValues("card_amt"); //û���ݾ�
	String value4[]  = request.getParameterValues("card_tax");//������
	String value5[]  = request.getParameterValues("card_nm");//ī���
	String value6[]  = request.getParameterValues("card_no"); //ī���ȣ
	String value7[]  = request.getParameterValues("card_remark"); //����
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	String node_code ="S101";  //�׿��� iu ������ ȸ�����:S101	
	
	
	Hashtable vendor = new Hashtable();	
	
	String ven_code = "";
	
	String docu_gubun = "3";
	
	//�ڵ���ǥó����
	Vector vt = new Vector();
	
	boolean flag2 = true;
	int flag1 = 0;
	int flag = 0;
	int count =0;
	int line =0;
	String doc_cont = "";
	String card_dt = "";
	String row_id = "";
	
 	int amt_10800 = 0;
 	int card_amt = 0;
 	int card_tax = 0;
		
		//�Աݰŷ����� ����
//	IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
//	String card_nm = base.getCard_nm();
				
	
	//�Ҽӿ����� ����Ʈ ��ȸ
	Hashtable br = c_db.getBranch("S1"); //������ ���� 

	//�������� ���
	if ( not_yet.equals("1") ) {
	   	   	
		doc_cont = not_yet_reason;
							
	   	line++;
			 				   		
   		Hashtable ht1_1 = new Hashtable();
   		
   		ht1_1.put("WRITE_DATE", 	incom_dt);  //row_id	
		ht1_1.put("ROW_NO",  	String.valueOf(line)); //row_no		
		ht1_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� * ,  no_docu || no_doline
		ht1_1.put("CD_PC",  	node_code);  //ȸ�����*
		ht1_1.put("CD_WDEPT",  dept_code);  //�μ�
		ht1_1.put("NO_DOCU",  	"");  //row_id�� ����
		ht1_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht1_1.put("CD_COMPANY",  "1000");  
		ht1_1.put("ID_WRITE", insert_id);   
		ht1_1.put("CD_DOCU",  "11");  
		
		ht1_1.put("DT_ACCT",  incom_dt);  
		ht1_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht1_1.put("TP_DRCR",  "2");   // �뺯:2 , ����:1
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
	  
	} else  {   
		
		for(int i=0 ; i < scd_size ; i++){	
						
			card_dt = value1[i]	== null?"":value1[i];  //ī��û����
			int card_seq = value2[i]	==null?0 :AddUtil.parseDigit(value2[i]); //ī�忬�� (���ݿ���)					
			int pay_amt = value3[i]	==null?0 :AddUtil.parseDigit(value3[i]); //û���ݾ� 
										
			if(pay_amt != 0){  // kcp ��Ұ��� -ó��.
					
				if( value0[i].equals("scd_card") ){							
														
					IncomItemBean i_item = new IncomItemBean();						
									
					i_item.setItem_nm(value0[i]);
					i_item.setItem_dt(value1[i]);
					i_item.setItem_seq(card_seq);
					i_item.setIncom_dt	(incom_dt); //�����ȣ
					i_item.setIncom_seq(incom_seq);//����
			
					if(!in_db.insertIncomItem(i_item))	flag += 1;										
					if(!in_db.updateIncomSet(card_dt, card_seq, "6")) flag += 1;
					 
					 	//�Աݰŷ����� ����
					IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
					String card_nm = base.getCard_nm();
			
					//ī��̼��� �ڵ���ǥ����					
					String acct_cont = "";
					
					if ( value0[i].equals("scd_card")){
						acct_cont = "[ī��̼���]"+ value7[i]+"("+value5[i]+")";
					}	
						
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;
					
					//�̼���
					Hashtable ht15 = new Hashtable();			
				        	      
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
					ht15.put("TP_DRCR",  "2"); //�뺯							
					ht15.put("CD_ACCT",    	 		  	"12000");  // �̼���
					ht15.put("AMT",  	String.valueOf(pay_amt));
					ht15.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü				
					
				   if (  doc_cont.indexOf("KCP") != -1 ) {//ī��� ��������� ���					
				//	if (  card_nm.equals("KCP")  ) {//ī��� ��������� ���		
						ht15.put("CD_PARTNER",	"105320"); //�ŷ�ó    - A06  �ѱ����̹�����(KCP)
					} else if (   doc_cont.indexOf("���̿�") != -1   ) {//ī��� ��������� ���		
						ht15.put("CD_PARTNER",	"996282"); //�ŷ�ó   - A06  ���̿� 
					} else if (   doc_cont.indexOf("���̽�") != -1   ) {//ī��� ��������� ���		
						ht15.put("CD_PARTNER",	"996283"); //�ŷ�ó   - A06  ���̿� 
					} else if (   doc_cont.indexOf("�̳�����") != -1   ) {//ī��� ��������� ���		
						ht15.put("CD_PARTNER",	"996548"); //�ŷ�ó   - A06  ���̿� 		
					}	else {
						ht15.put("CD_PARTNER",	"109691"); //�ŷ�ó    - A06		
					}
			
					ht15.put("DT_START",  incom_dt);   	//�߻�����					 
					ht15.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht15.put("CD_DEPT",		"");   //�μ�								 
					ht15.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht15.put("CD_PJT",			"");   //������Ʈ�ڵ�	
					ht15.put("CD_CARD",		"");   //�ſ�ī��		 		 	
					ht15.put("CD_EMPLOY",		"");   //���	
					ht15.put("NO_DEPOSIT",		"");  //�����ݰ���
					ht15.put("CD_BANK",		"");  //�������	
				 	ht15.put("NO_ITEM",		"");  //item   	
				 	
				 			// �ΰ�������
					ht15.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht15.put("AM_ADDTAX",	"" );	 //����
					ht15.put("TP_TAX",	"");  //����(����) :11
					ht15.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ		  	 	 
				
					ht15.put("NM_NOTE", acct_cont);  // ����				
												
					vt.add(ht15);	
					
					card_amt = card_amt + pay_amt;
											
				
					int c_t_amt = value4[i]	==null?0 :AddUtil.parseDigit(value4[i]); //������ - �����ޱ� 
				
					
					card_tax = card_tax + c_t_amt;
										
					acct_cont = "[ī�������]"+ value7[i]+"("+value5[i]+")";
					
				    if  ( c_t_amt > 0 ) {	//�����Ḧ ������� (����ǰ�� ���)					
						line++;
						
						//ī�������
						Hashtable ht21 = new Hashtable();		
						
						ht21.put("WRITE_DATE", 	incom_dt);  //row_id			
						ht21.put("ROW_NO",  	String.valueOf(line)); //row_no			
						ht21.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht21.put("CD_PC",  	node_code);  //ȸ�����
						ht21.put("CD_WDEPT",  dept_code);  //�μ�
						ht21.put("NO_DOCU",  	"");  //row_id�� ����
						ht21.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht21.put("CD_COMPANY",  "1000");  
						ht21.put("ID_WRITE", insert_id);   
						ht21.put("CD_DOCU",  "11");  
						
						ht21.put("DT_ACCT",  incom_dt);  
						ht21.put("ST_DOCU",  "1");  //�̰�:1, ����:2  	
						ht21.put("TP_DRCR",  "1"); //����							
						
						ht21.put("AMT",  		String.valueOf(c_t_amt));
						ht21.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü				
							
						if (  doc_cont.indexOf("KCP") != -1 ) {//ī��� ��������� ���					
					//	if ( card_nm.equals("KCP") ) {							
							ht21.put("CD_PARTNER",	"105320"); //�ŷ�ó    - A06  �ѱ����̹�����(KCP)
							ht21.put("CD_ACCT",    	 		  	"25700");  // ������
						//	ht21.put("CD_ACCT",    	 		  	"13400");  // �����ޱ�
						} else if (  doc_cont.indexOf("���̿�") != -1  ) {//ī��� ��������� ���		
							ht21.put("CD_PARTNER",	"996282"); //�ŷ�ó   - A06  ���̿� 
							ht21.put("CD_ACCT",    	 		  	"25700");  // ������
						//	ht21.put("CD_ACCT",    	 		  	"13400");  // �����ޱ�
						//	ht21.put("CD_ACCT",    	 		  	"83100");  // ���޼������ ó��  20200402)
						} else if (   doc_cont.indexOf("���̽�") != -1   ) {//ī��� ��������� ���		
							ht21.put("CD_PARTNER",	"996283"); //�ŷ�ó   - A06  ���̽� 		
						//	ht21.put("CD_ACCT",    	 		  	"13400");  // �����ޱ� -  ī�� cms �ΰ�� 	
							ht21.put("CD_ACCT",    	 		  	"83100");  // ���޼������ ó��  20200402)
						} else if (   doc_cont.indexOf("�̳�����") != -1   ) {//ī��� ��������� ���		
							ht21.put("CD_PARTNER",	"996548"); //�ŷ�ó   - A06  ���̽� 		
						//	ht21.put("CD_ACCT",    	 		  	"13400");  // �����ޱ� -  ī�� cms �ΰ�� 	
							ht21.put("CD_ACCT",    	 		  	"25700");  // ���޼������ ó��  20200402)
						} else {							
							ht21.put("CD_PARTNER",	"109691"); //�ŷ�ó    - A06		
							ht21.put("CD_ACCT",    	 		  	"25700");  // ������
						//	ht21.put("CD_ACCT",    	 		  	"83100");  // ���޼������ ó�� 
						}
					
						ht21.put("DT_START",  incom_dt);   	//�߻�����					 
						ht21.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht21.put("CD_DEPT",		"");   //�μ�								 
						ht21.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht21.put("CD_PJT",			"");   //������Ʈ�ڵ�	
						ht21.put("CD_CARD",		"");   //�ſ�ī��		 		 	
						ht21.put("CD_EMPLOY",		"");   //���	
						ht21.put("NO_DEPOSIT",		"");  //�����ݰ���
						ht21.put("CD_BANK",		"");  //�������	
					 	ht21.put("NO_ITEM",		"");  //item   	
					 	
					 			// �ΰ�������
						ht21.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht21.put("AM_ADDTAX",	"" );	 //����
						ht21.put("TP_TAX",	"");  //����(����) :11
						ht21.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ		  	 	 
					
						ht21.put("NM_NOTE", acct_cont);  // ����									
										
						vt.add(ht21);	
					}		
			
				}	
			}  //pay_amt != 0
			out.println("<br>");
		}  //end for 
					
		if(line > 1){
			doc_cont = doc_cont+" ��";
		}
				
			//������ �Ǵ� ��ս�
		amt_10800 = incom_amt  + card_tax  - card_amt;
			
			//������ 	
	   	if ( amt_10800  > 0 ) {
				
			line++;
			
			Hashtable ht7 = new Hashtable();
				
			ht7.put("WRITE_DATE", 	incom_dt);  //row_id			
			ht7.put("ROW_NO",  	String.valueOf(line)); //row_no			
			ht7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht7.put("CD_PC",  	node_code);  //ȸ�����
			ht7.put("CD_WDEPT",  dept_code);  //�μ�
			ht7.put("NO_DOCU",  	"");  //row_id�� ����
			ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht7.put("CD_COMPANY",  "1000");  
			ht7.put("ID_WRITE", insert_id);   
			ht7.put("CD_DOCU",  "11");  
			
			ht7.put("DT_ACCT",  incom_dt);  
			ht7.put("ST_DOCU",  "1");  //�̰�:1, ����:2  	
			ht7.put("TP_DRCR",  "2"); //�뺯							
			ht7.put("CD_ACCT",    	"93000");  //������
			ht7.put("AMT",  		 String.valueOf( amt_10800 ));		
			ht7.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü				
			ht7.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
				
			ht7.put("DT_START",  incom_dt);   	//�߻�����					 
			ht7.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht7.put("CD_DEPT",		"");   //�μ�								 
			ht7.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht7.put("CD_PJT",			"");   //������Ʈ�ڵ�	
			ht7.put("CD_CARD",		"");   //�ſ�ī��		 		 	
			ht7.put("CD_EMPLOY",		"");   //���	
			ht7.put("NO_DEPOSIT",		"");  //�����ݰ���
			ht7.put("CD_BANK",		"");  //�������	
		 	ht7.put("NO_ITEM",		"");  //item   	
		 	
		 			// �ΰ�������
			ht7.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht7.put("AM_ADDTAX",	"" );	 //����
			ht7.put("TP_TAX",	"");  //����(����) :11
			ht7.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ		  	 	 
		
			ht7.put("NM_NOTE", doc_cont);  // ����									
													
			vt.add(ht7);  // ó������
	  	}
	 
	 	
	 	 //ó�мս� 	
	   	if ( amt_10800 < 0 ) {
			
				line++;
			
				Hashtable ht8 = new Hashtable();
			
		         		   
       			ht8.put("WRITE_DATE", 	incom_dt);  //row_id			
				ht8.put("ROW_NO",  	String.valueOf(line)); //row_no			
				ht8.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht8.put("CD_PC",  	node_code);  //ȸ�����
				ht8.put("CD_WDEPT",  dept_code);  //�μ�
				ht8.put("NO_DOCU",  	"");  //�̰��� '0'  //row_id�� ����
				ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht8.put("CD_COMPANY",  "1000");  
				ht8.put("ID_WRITE", insert_id);   
				ht8.put("CD_DOCU",  "11");  
				
				ht8.put("DT_ACCT",  incom_dt);  
				ht8.put("ST_DOCU",  "1");  //�̰�:1, ����:2  	
				ht8.put("TP_DRCR",  "1"); //����							
				ht8.put("CD_ACCT",    	"13400");  //�����ޱ�
				ht8.put("AMT",  		 String.valueOf( amt_10800* (-1) ));
				ht8.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü			
				
				if (  doc_cont.indexOf("KCP") != -1 ) {//ī��� ��������� ���		
					ht8.put("CD_ACCT",    	"13400");  //�����ޱ�		
					ht8.put("CD_PARTNER",	"105320"); //�ŷ�ó    - A06  �ѱ����̹�����(KCP)
				} else if (  doc_cont.indexOf("���̿�") != -1  ) {//ī��� ��������� ���	
					ht8.put("CD_ACCT",    	"83100");  //���޼����� 	(20200402)				
				//	ht8.put("CD_ACCT",    	"13400");  //�����ޱ�	
					ht8.put("CD_PARTNER",	"996282"); //�ŷ�ó   - A06  ���̿� 
				} else if (   doc_cont.indexOf("���̽�") != -1   ) {//ī��� ��������� ���		
				//	ht8.put("CD_ACCT",    	"13400");  //�����ޱ�
					ht8.put("CD_ACCT",    	"83100");  //���޼����� 	(20200402)	
					ht8.put("CD_PARTNER",	"996283"); //�ŷ�ó   - A06  ���̽� - ī��  cms �ΰ�� 	
				} else if (   doc_cont.indexOf("�̳�����") != -1   ) {//ī��� ��������� ���		
					//	ht8.put("CD_ACCT",    	"13400");  //�����ޱ�
						ht8.put("CD_ACCT",    	"83100");  //���޼����� 	(20200402)	
						ht8.put("CD_PARTNER",	"996548"); //�ŷ�ó   - A06  ���̽� - ī��  cms �ΰ�� 		
				} else {			
					ht8.put("CD_ACCT",    	"83100");  //���޼�����				
					ht8.put("CD_PARTNER",	"109691"); //�ŷ�ó    - A06		
				}
					
					
				ht8.put("DT_START",  incom_dt);   	//�߻�����					 
				ht8.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht8.put("CD_DEPT",		"");   //�μ�								 
				ht8.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht8.put("CD_PJT",			"");   //������Ʈ�ڵ�	
				ht8.put("CD_CARD",		"");   //�ſ�ī��		 		 	
				ht8.put("CD_EMPLOY",		"");   //���	
				ht8.put("NO_DEPOSIT",		"");  //�����ݰ���
				ht8.put("CD_BANK",		"");  //�������	
			 	ht8.put("NO_ITEM",		"");  //item   	
			 	
			 			// �ΰ�������
				ht8.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht8.put("AM_ADDTAX",	"" );	 //����
				ht8.put("TP_TAX",	"");  //����(����) :11
				ht8.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ		  	 	 
			
				ht8.put("NM_NOTE", doc_cont);  // ����				
  			
	     		vt.add(ht8);  // ó�мս�
  	  }
	  	
	}
	  	
	line++;

	//���뿹��
	Hashtable ht1 = new Hashtable();
	
	ht1.put("WRITE_DATE", 	incom_dt);  //row_id			
	ht1.put("ROW_NO",  	String.valueOf(line)); //row_no
	
	ht1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
	ht1.put("CD_PC",  	node_code);  //ȸ�����
	ht1.put("CD_WDEPT",  dept_code);  //�μ�
	ht1.put("NO_DOCU",  	"");  //�̰��� '0'  -> row_id �� ����
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
	ht1.put("CD_BANK",		bank_code);  //�������	
 	ht1.put("NO_ITEM",		"");  //item
 	
 			// �ΰ�������
	ht1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
	ht1.put("AM_ADDTAX",	"" );	 //����
	ht1.put("TP_TAX",	"");  //����(����) :11
	ht1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ

	ht1.put("NM_NOTE", doc_cont);  // ����			
		
	vt.add(ht1);	
	
	if ( vt.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(incom_dt,  vt);
	}	

	//�Աݿ���ó��
	if ( not_yet.equals("1") ) {
	   if(!in_db.updateIncomSet( incom_dt, incom_seq, not_yet_reason,  "2" )) flag += 1;  //������
	} else {
	   if(!in_db.updateIncomSet( incom_dt, incom_seq, "1", card_tax, "1", "", 0, row_id )) flag += 1;	
	}	
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

<%	if(flag != 0){ 	//�������̺� ���� ����%>
	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');				

    fm.action='/fms2/account/incom_reg_step1.jsp';
 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>

</body>
</html>
