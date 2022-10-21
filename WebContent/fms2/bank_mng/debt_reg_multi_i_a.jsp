<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.user_mng.*, acar.bank_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String vid1[] = request.getParameterValues("l_id");
	String vid2[] = request.getParameterValues("cpt_cd");
	String vid3[] = request.getParameterValues("cont_dt");
	String vid4[] = request.getParameterValues("gubun");		
		
	int vid_size = 0;
	vid_size = vid1.length;
	
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String cont_dt1 = request.getParameter("cont_dt1")==null?"":request.getParameter("cont_dt1");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//�α���-ID
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
		
	String ch_l_id="";  
	String ch_cpt_cd="";
	String ch_cont_dt="";
	String ch_gubun="";
		
	int flag = 0;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	
	String node_code ="S101";  //�׿��� iu ������ ȸ�����:S101	
		
	Hashtable vendor = new Hashtable();	
	
	String ven_code = "";

	String doc_cont = "";
	String cont_dt = "";
	int line =0;
	long cont_amt = 0;
	long a_cont_amt = 0;
	
	//�ڵ���ǥó���� & ���ݰ�꼭
	Vector vt = new Vector();
	int data_no =0;
	String row_id = "";				
				
	for(int i=0;i < vid_size;i++){
		
		ch_l_id = vid1[i];
		ch_cpt_cd = vid2[i];
		ch_cont_dt = vid3[i];
		ch_gubun = vid4[i];
				
				//������� ���� ��ȸ
		Hashtable bank_lend = abl_db.getBankLendAcctList( ch_l_id);
			
		//��Ÿ���		
		if (	ch_gubun.equals("3") ) {	
			bank_lend = abl_db.getBankLendAcctListEtc(ch_l_id);
		}
									
		long b_amt 	= AddUtil.parseLong((String)bank_lend.get("B_AMT"));  //���س⵵ ���Ա�
		long a_amt 	= AddUtil.parseLong((String)bank_lend.get("A_AMT"));  //���س⵵ ���Ա�
		long c_amt  = 0;
		cont_amt 	= AddUtil.parseLong((String)bank_lend.get("CONT_AMT"));  //�����(������)
		ven_code 	= (String)bank_lend.get("VEN_CODE")==null?"":(String)bank_lend.get("VEN_CODE");
		cont_dt 	= (String)bank_lend.get("CONT_DT");
		String acct_code 	= (String)bank_lend.get("ACCT_CODE");   //������:45450 �Ե�ĳ��Ż ��븮���� 
		String car_no 	= (String)bank_lend.get("CAR_NO");
		String car_use 	= (String)bank_lend.get("CAR_USE");
		
		if(!ven_code.equals("") && !ven_code.equals("null") ){
		
			vendor = neoe_db.getVendorCase(ven_code);	
												
			//���⼱���� �ڵ���ǥ����					
			String acct_cont = "";
							
			if (	ch_gubun.equals("2") ) {			
				acct_cont = vendor.get("VEN_NAME")+"( " + car_no +" - " + ch_l_id + " )";
			} else if (	ch_gubun.equals("3") ) {			
					acct_cont = vendor.get("VEN_NAME")+"( " + car_no +" - " + ch_l_id + " ��Ÿ��� )";				
			} else {
				acct_cont = vendor.get("VEN_NAME")+"( " + ch_l_id + " )";
			}						
			if(doc_cont.equals("")){
				doc_cont = acct_cont;
			}
			
			//����������ä�� ��� - ���س⵵ �߻��� 
			if ( acct_code.equals("26400") ||  acct_code.equals("29300") ) { 
				//12�������Ĵ� ������Ա� ( 202012�� - b_amt+a_amt�� ������Ա�(29300)���� )
				c_amt = b_amt + a_amt; 
			//	if ( cont_amt != c_amt) {
			//		System.out.println("���� ��ǥ cont_amt = " + cont_amt + " : c_amt = "+ c_amt + ": ch_l_id = "+ ch_l_id );					
			//	}
			/*	if (b_amt > 0) {			
					line++;
						
					//��ä���ð���
					Hashtable ht1 = new Hashtable();
					
					ht1.put("WRITE_DATE", 	cont_dt);//row_id	
					ht1.put("ROW_NO",  	String.valueOf(line)); //row_no		
					ht1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� * ,  no_docu || no_doline
					ht1.put("CD_PC",  	node_code);  //ȸ�����*
					ht1.put("CD_WDEPT",  dept_code);  //�μ�
					ht1.put("NO_DOCU",  	"");  //row_id�� ����
					ht1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht1.put("CD_COMPANY",  "1000");  
					ht1.put("ID_WRITE", insert_id);   
					ht1.put("CD_DOCU",  "11");  
					
					ht1.put("DT_ACCT",cont_dt); 
					ht1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht1.put("TP_DRCR",  "2");   // �뺯:2 , ����:1
					ht1.put("CD_ACCT",  "26400");  //����������ä
					ht1.put("AMT",    	String.valueOf(b_amt));									
					ht1.put("TP_GUBUN",	"3");  //1:�Ա� 2:��� 3:��ü	
					ht1.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
						
					ht1.put("DT_START", cont_dt) ;  	//�߻�����			
					ht1.put("CD_BIZAREA",	"");   //�ͼӻ����	
					ht1.put("CD_DEPT",		"");   //�μ�								 
					ht1.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht1.put("CD_PJT",			"");   //������Ʈ�ڵ�	
					ht1.put("CD_CARD",		"");   //�ſ�ī��		 		 		
					ht1.put("CD_EMPLOY",		"");   //���	
					ht1.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht1.put("CD_BANK",		"");  //�������	
					ht1.put("NO_ITEM",		"");  //item 	 
					
							// �ΰ�������
					ht1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht1.put("AM_ADDTAX",	"" );	 //����
					ht1.put("TP_TAX",	"");  //����(����) :11
					ht1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
				
					ht1.put("NM_NOTE", acct_cont);  // ����
						
					vt.add(ht1);					
				}
				*/
				//������Ա��� ������ - ���س� ���� ��ȯ�ݾ��� �ִ� ���	 
				if (c_amt > 0) {				
					line++;
					
					//��ä���ð���
					Hashtable ht2 = new Hashtable();
					
					ht2.put("WRITE_DATE", 	cont_dt);//row_id	
					ht2.put("ROW_NO",  	String.valueOf(line)); //row_no		
					ht2.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� * ,  no_docu || no_doline
					ht2.put("CD_PC",  	node_code);  //ȸ�����*
					ht2.put("CD_WDEPT",  dept_code);  //�μ�
					ht2.put("NO_DOCU",  	"");  //row_id�� ����
					ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht2.put("CD_COMPANY",  "1000");  
					ht2.put("ID_WRITE", insert_id);   
					ht2.put("CD_DOCU",  "11");  
					
					ht2.put("DT_ACCT",cont_dt); 
					ht2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht2.put("TP_DRCR",  "2");   // �뺯:2 , ����:1
					ht2.put("CD_ACCT",  "29300");  //������Ա�
					ht2.put("AMT",    	String.valueOf(c_amt));						
					ht2.put("TP_GUBUN",	"3");  //1:�Ա� 2:��� 3:��ü	
					ht2.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
						
					ht2.put("DT_START", cont_dt) ;  	//�߻�����			
					ht2.put("CD_BIZAREA",	"");   //�ͼӻ����	
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
								
					vt.add(ht2);				
				}
			
			
			} else { //�ܱ����Ա�
			
				if (b_amt > 0) {		
					line++;
						
						//��ä���ð��� - �ܱ����Ա�
					Hashtable ht5 = new Hashtable();
					
					ht5.put("WRITE_DATE", 	cont_dt);//row_id	
					ht5.put("ROW_NO",  	String.valueOf(line)); //row_no		
					ht5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� * ,  no_docu || no_doline
					ht5.put("CD_PC",  	node_code);  //ȸ�����*
					ht5.put("CD_WDEPT",  dept_code);  //�μ�
					ht5.put("NO_DOCU",  	"");  //row_id�� ����
					ht5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht5.put("CD_COMPANY",  "1000");  
					ht5.put("ID_WRITE", insert_id);   
					ht5.put("CD_DOCU",  "11");  
					
					ht5.put("DT_ACCT",cont_dt); 
					ht5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht5.put("TP_DRCR",  "2");   // �뺯:2 , ����:1
					ht5.put("CD_ACCT",  "26000");  //�ܱ����Ա�
					ht5.put("AMT",    	String.valueOf(b_amt));				
					ht5.put("TP_GUBUN",	"3");  //1:�Ա� 2:��� 3:��ü	
					ht5.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
						
					ht5.put("DT_START", cont_dt) ;  	//�߻�����			
					ht5.put("CD_BIZAREA",	"");   //�ͼӻ����	
					ht5.put("CD_DEPT",		"");   //�μ�								 
					ht5.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht5.put("CD_PJT",			"");   //������Ʈ�ڵ�	
					ht5.put("CD_CARD",		"");   //�ſ�ī��		 		 		
					ht5.put("CD_EMPLOY",		"");   //���	
					ht5.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht5.put("CD_BANK",		"");  //�������	
					ht5.put("NO_ITEM",		"");  //item 	 
					
							// �ΰ�������
					ht5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht5.put("AM_ADDTAX",	"" );	 //����
					ht5.put("TP_TAX",	"");  //����(����) :11
					ht5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
				
					ht5.put("NM_NOTE", acct_cont);  // ����
				
					vt.add(ht5);	
				}				
			}
			
			
			if (	!ch_gubun.equals("3") ) {	
				//����(����)��ǥ ����							
				if(!abl_db.updateFacctYn(ch_l_id, ch_gubun))	flag += 1;
			}	
			
			a_cont_amt = a_cont_amt + cont_amt;
			
		} // �ŷ�ó�� �ִ� ���	
	
		
	} // end for -���õȴ���
	
	System.out.println("���� ������ = " + a_cont_amt );
	line++;
					
	//�����ݰ���
	Hashtable ht3 = new Hashtable();
	
	//����ݼ�����
	ht3.put("WRITE_DATE", 	cont_dt);//row_id	
	ht3.put("ROW_NO",  	String.valueOf(line)); //row_no		
	ht3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� * ,  no_docu || no_doline
	ht3.put("CD_PC",  	node_code);  //ȸ�����*
	ht3.put("CD_WDEPT",  dept_code);  //�μ�
	ht3.put("NO_DOCU",  	"");  //row_id�� ����
	ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht3.put("CD_COMPANY",  "1000");  
	ht3.put("ID_WRITE", insert_id);   
	ht3.put("CD_DOCU",  "11");  
	
	ht3.put("DT_ACCT",cont_dt); 
	ht3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht3.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
	ht3.put("CD_ACCT",  	"25900"); //������
	ht3.put("AMT",    	String.valueOf(a_cont_amt));	
	ht3.put("TP_GUBUN",	"3");  //1:�Ա� 2:��� 3:��ü	
	ht3.put("CD_PARTNER",	ven_code); //�ŷ�ó    - A06
		
	ht3.put("DT_START", cont_dt) ;  	//�߻�����			
	ht3.put("CD_BIZAREA",	"");   //�ͼӻ����	
	ht3.put("CD_DEPT",		"");   //�μ�								 
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

	ht3.put("NM_NOTE", doc_cont);  // ����
				
	vt.add(ht3);
	
	if ( vt.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(cont_dt,  vt);
	}
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step2(){		
	
		var fm = document.form1;	
		
		fm.action = 'debt_r_frame.jsp';
		fm.target = "d_content";
		fm.submit();
		
		parent.window.close();	
	
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='from_page' value='/fms2/bank_mng/debt_r_frame.jsp'>
</form>

<script language='javascript'>
<!--
<%		if(flag > 0) { %>   
			alert("������ �߻��Ͽ����ϴ�.");
<%		} else if ( row_id.equals("0") ) { %>
			alert("��ǥ���� ������ �߻��Ͽ����ϴ�.");				
<%		} else { %>
			alert("��ϵǾ����ϴ�.");
			go_step2();
<%		}%>
//-->
</script>
</body>
</html>