<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.incom.*, acar.con_ins.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.fee.*, acar.bill_mng.*"%>
<%@ page import="acar.car_register.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")		==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
			
	String bank_code 	= request.getParameter("bank_code2")	==null?"":request.getParameter("bank_code2");
	String deposit_no 	= request.getParameter("deposit_no2")	==null?"":request.getParameter("deposit_no2");		
	String bank_name 	= request.getParameter("bank_name")	==null?"":request.getParameter("bank_name");
	String ip_method 	= request.getParameter("ip_method")	==null?"":request.getParameter("ip_method");
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	int    incom_amt 	 	= request.getParameter("incom_amt")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_amt"));
	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
	
	String not_yet 	= request.getParameter("not_yet")==null?"0":request.getParameter("not_yet");  //1:������
	String not_yet_reason 	= request.getParameter("not_yet_reason")==null?"":request.getParameter("not_yet_reason");  //1:������
	
	String n_ven_name 	= request.getParameter("n_ven_name")==null?"0":request.getParameter("n_ven_name");  //�׿��� �ŷ�ó��
	String n_ven_code 	= request.getParameter("n_ven_code")==null?"":request.getParameter("n_ven_code");  //�׿��� �ŷ�ó�ڵ�	
		
	CarRegDatabase crd = CarRegDatabase.getInstance();

	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();		

	String value0[]  = request.getParameterValues("gubun");
	String value1[]  = request.getParameterValues("rent_l_cd");
	String value2[]  = request.getParameterValues("car_mng_id");
	String value3[]  = request.getParameterValues("ins_st");
	String value4[]  = request.getParameterValues("ins_tm");//EXT_ID
	String value5[]  = request.getParameterValues("car_no");//������ȣ
	String value6[]  = request.getParameterValues("ins_com_id"); //�����
	String value7[]  = request.getParameterValues("ins_tm2"); // 
	String value8[]  = request.getParameterValues("pay_amt");  //�Աݾ� 
	String value9[]  = request.getParameterValues("car_use");  // 1:��Ʈ 1�̿�:���� 

	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));  //�׿������� ����	
	String node_code ="S101";  //�׿��� iu ������ ȸ�����:S101	
	
	Hashtable vendor = new Hashtable();	
		
	String car_no = "";	
	String docu_gubun = "";
	
	if (ip_method.equals("3")) {
		docu_gubun = "1";
	} else {
		docu_gubun = "3";	
	}
	
	//�ڵ���ǥó���� & ���ݰ�꼭
	Vector vt = new Vector();

	int data_no =0;
	String car_use = "";   //��Ʈ, ����
	String acct_code = "";
	
	String s_idno = "";	
	String client_st = "";
	String tax_no = "";
	String item_id = "";
  	String reg_code = "";	
  	String row_id = "";
	
  	int  a1_s_amt = 0;  //�뿩��
    int  a1_v_amt = 0;
		
	boolean flag2 = true;
	int flag1 = 0;
	int flag = 0;
	int count =0;
	int line =0;
	String doc_cont = "";
	String rtn_client = "";
		
		//�Աݰŷ����� ����
	IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
						
	
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
		ht1_1.put("CD_PC",  node_code);  //ȸ�����*
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
					
				//�ڵ�������
			CarRegBean cr_bean = crd.getCarRegBean(value2[i]);		
			car_no =	cr_bean.getCar_no();
		//	car_use =	cr_bean.getCar_use();			
			
			car_use =  value9[i];
			
			int pay_amt = value8[i]	==null?0 :AddUtil.parseDigit(value8[i]);
							
			if(pay_amt > 0){		
					
				//������� ȯ��
			   if(value0[i].equals("scd_ins")){
					out.println("������� ȯ��ó��="+pay_amt+", ");					
									
					InsurScdBean scd = ai_db.getInsScd(value2[i], value3[i], value4[i]);
					
					scd.setPay_yn("1");
					scd.setPay_dt(incom_dt);
					if(value7[i].equals("1")){  //����
						scd.setPay_amt(pay_amt*(-1));		
					} else {
						scd.setPay_amt(pay_amt);		
					}									
					scd.setIncom_dt	(incom_dt); //�����ȣ
					scd.setIncom_seq (incom_seq);
						
					if(!ai_db.updateInsScd(scd)) flag += 1; 
									
					//������� ȯ�� �ڵ���ǥ����									  				
					String acct_cont = "";	
															
					if(value7[i].equals("1")){  //����
					   acct_cont = "[���溸���ȯ��]";
					} else {  //����
					   acct_cont = "[���������ȯ��]";
					}
						
					 doc_cont = acct_cont+car_no;
									
					line++;
					
					//�������
					Hashtable ht2 = new Hashtable();
					
					ht2.put("WRITE_DATE", 		incom_dt);  //row_id				
					ht2.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht2.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht2.put("CD_PC",  	node_code);  //ȸ�����
					ht2.put("CD_WDEPT",  dept_code);  //�μ�
					ht2.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht2.put("CD_COMPANY",  "1000");  
					ht2.put("ID_WRITE", insert_id);   
					ht2.put("CD_DOCU",  "11");  
					
					ht2.put("DT_ACCT", 	 incom_dt);  
					ht2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
					
				//	if ( car_use.equals("1") ) { //��Ʈ��
				//		ht2.put("CD_ACCT",  	"13300");  //�뿩���� ���޺����
				//	} else {
			//			ht2.put("CD_ACCT",  	"13200");  //�������� ���޺����
				//	}	
					
					ht2.put("CD_ACCT",  	"12000");  //�̼���
					ht2.put("AMT",   	String.valueOf(pay_amt));
					ht2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht2.put("CD_PARTNER",	n_ven_code); //�ŷ�ó    - A06
											
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
				
					ht2.put("NM_NOTE", doc_cont);  // ����						
													
					vt.add(ht2);		
				}
			}  //pay_amt > 0
			out.println("<br>");
		}  //end for 
					
		if(line > 1){
			doc_cont = doc_cont+" ��";
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
	ht1.put("NO_DOCU",  	"");  //�̰��� '0' 
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
		row_id = neoe_db.insertSetAutoDocu(incom_dt, vt);
	}
			
	//�Աݿ���ó�� - jung_type :1->�Ϸ�
	if ( not_yet.equals("1") ) {
	   if(!in_db.updateIncomSet( incom_dt, incom_seq, not_yet_reason,  "2" )) flag += 1;
	} else {
	 if(!in_db.updateIncomSet( incom_dt, incom_seq, "1", 0, ip_method, doc_cont, 0 , row_id)) flag += 1;	
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

    fm.action='/fms2/account/incom_r_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
