<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*, acar.coolmsg.*, acar.user_mng.*"%>
<%@ page import="acar.bill_mng.*, acar.incom.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
			
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
		
	String from_page 	=  "/fms2/account/incom_reg_etc_frame.jsp" ;
			
	
	// ����Ʈ
	String acct_seq[] = request.getParameterValues("acct_seq");  //����
	String tr_date[] = request.getParameterValues("tr_date");   //�Ա���
	String tr_date_seq[]  = request.getParameterValues("tr_date_seq");  //�Ա��� ���� 
	String naeyoung[]  = request.getParameterValues("naeyoung");
	String bank_nm[] 	= request.getParameterValues("bank_nm");
	String bank_no[] 	= request.getParameterValues("bank_no");
	String ip_amt[] = request.getParameterValues("ip_amt");
	
	int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
										
	String n_ven_code 		= request.getParameter("n_ven_code")==null?"":request.getParameter("n_ven_code");
	String n_ven_name 		= request.getParameter("n_ven_name")==null?"":request.getParameter("n_ven_name");
	String ip_acct 		= request.getParameter("ip_acct")==null?"":request.getParameter("ip_acct");
	String acct_gubun =  request.getParameter("acct_gubun")==null?"":request.getParameter("acct_gubun");
	String remark 		= request.getParameter("remark")==null?"":request.getParameter("remark");
	
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	String node_code ="S101";  //�׿��� iu ������ ȸ�����:S101	
		
	String docu_gubun = "";
	String amt_gubun = "";
	
	//neoe��  �����ⳳ�嶧���� ������ ��ü�� ó�� - ���ݵ�. 
	 docu_gubun = "3";		
	 amt_gubun = "2";	  

	//�ڵ���ǥó���� & ���ݰ�꼭
	Vector vt = new Vector();	
	String row_id = "";
	  		
	boolean flag2 = true;
	int flag1 = 0;
	int flag = 0;
	int count =0;
	int line =0;
	String doc_cont = "";
	
	int t_pay_amt =  0;	//��Ÿ�Աݺ� ó���� ���		
	int ip_acct_amt = 0;
	String incom_dt = "";
	String deposit_no = "";
	String bank_code = "";
	String acc_cont = "";
			
 // �뿩����� �ƴѰ�� �ԱݵȰ� ó�� - �����. ĳ���� �� 					
	for(int i=0; i<size; i++){

		ip_acct_amt = ip_amt[i]	==null?0 :AddUtil.parseDigit(ip_amt[i]);
	   incom_dt 		= 	 tr_date[i];
	   deposit_no 	=   	 bank_no[i];	
	   	   	
		String value[] = new String[2];
		StringTokenizer st = new StringTokenizer(bank_nm[i],":");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		bank_code 	=   	 value[0];	
	
		// Incom insert 
		IncomBean base = new IncomBean();
										
		base.setIncom_dt		(incom_dt);
	   base.setIncom_amt			(ip_acct_amt);  //�Աݾ�
		base.setIncom_gubun	("2");   //����
		base.setIp_method		("1");
		base.setJung_type		("1");  //  �Աݴ�� 0,  1: �Ϸ�  2:  ������  
		base.setP_gubun			("1");   //�ش�� ó��  
		base.setPay_gur			("0");  //������������
	   	base.setBank_nm		(bank_nm[i]);
		base.setBank_no		(deposit_no);
		base.setRemark			(naeyoung[i]);
			
		base.setAcct_seq	(acct_seq[i]);
		base.setTr_date_seq	(tr_date_seq[i]);
					
		base.setReg_id			(user_id);
						
		//=====[incom] insert=====
		base = in_db.insertIncom(base);
		int incom_seq 	= base.getIncom_seq();
			
		
	// ���� ���� �Ϸ�ó��
		if(!ib_db.updateIbAcctTallTrDdFmsYn(acct_seq[i], tr_date[i], tr_date_seq[i]  )) flag += 1;	
		
		
		//��� �Ա��� ���			
		int ep3 = 0;
		ep3 = remark.indexOf("��ü���ĳ�������");

		if (ep3 != -1) {

			//����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
			UsersBean sender_bean = umd.getUsersBean(user_id);

			String sub = "��ü���ĳ�������  �Ա�(�ջ�)";
			String cont = "�� ��ü���ĳ������� Ȯ�� (�ջ�):: "  +  n_ven_name + " - " + remark + " " +  naeyoung[i] + ", �Ա���:" + incom_dt + ", �Աݾ�: "
					+ AddUtil.parseDecimalLong(ip_acct_amt) + "�� �ԱݵǾ����ϴ�.";
			String url = "/fms2/car_cash_back/car_cash_back_frame.jsp";

			String target_id = "000131";

			//����� ���� ��ȸ -
			UsersBean target_bean = umd.getUsersBean(target_id);
			String xml_data = "";

			xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
					+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>" + cont
					+ "</CONT>"
					+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
					+ url + "</URL>";

			xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";
			xml_data += "    <TARGET>2006007</TARGET>";
		//	xml_data += "    <TARGET>2010003</TARGET>"; //���ֿ� 
		//	xml_data += "    <TARGET>2013009</TARGET>"; //�̼��� 

			xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
					+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>"
					+ "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>" + "</COOLMSG>";

			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");

			flag2 = cm_db.insertCoolMsg(msg);

			System.out.println(
					"��޽���(��ü���ĳ������� �Ա�Ȯ��_�ջ�), "  +  n_ven_name + " - " + remark + " " +  naeyoung[i] +  "-" +  AddUtil.parseDecimalLong(ip_acct_amt)	+ " --------------------" + target_bean.getUser_nm());
			
		}

		
			//��Ÿ �Ա�ó��
		if (!ip_acct.equals("")) {
				
			IncomEtcBean i_etc = new IncomEtcBean();						
				
			i_etc.setIncom_dt(incom_dt); //�����ȣ
			i_etc.setIncom_seq(incom_seq);//����						
			i_etc.setSeq_id(1);
			i_etc.setN_ven_code(n_ven_code);
			i_etc.setN_ven_name(n_ven_name);
			i_etc.setIp_acct(ip_acct);
			i_etc.setIp_acct_amt(ip_acct_amt);
			i_etc.setRemark(remark + " " + naeyoung[i]);
			i_etc.setNeom("Y");
	//		System.out.println("acct_gubun="+ acct_gubun);
			i_etc.setAcct_gubun(acct_gubun);
						
			if(!in_db.insertIncomEtc(i_etc))	flag += 1;	
		}
		 
					
	   //��ǥó��
	   if ( ip_acct.equals("0")  ) {		
				 	
			line++;
			
			acc_cont =  "[������]" + "-" + n_ven_name + " " + remark + "  " +  naeyoung[i];	
			
			if ( acct_gubun.equals("D") ) {
				t_pay_amt =  ip_acct_amt*(-1);	
			} else {
				t_pay_amt =  ip_acct_amt;
			}			
								
		    if ( acct_gubun.equals("D") ) { //���� 
				docu_gubun = "3";		
				amt_gubun = "1";
		    } else {
			    docu_gubun = "3";		
			    amt_gubun = "2";
		    } 
		
			//������
			Hashtable ht25 = new Hashtable();			
			
			ht25.put("WRITE_DATE", 	incom_dt);  //row_id			
			ht25.put("ROW_NO",  	String.valueOf(line)); //row_no			
			ht25.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht25.put("CD_PC",  	node_code);  //ȸ�����
			ht25.put("CD_WDEPT",  dept_code);  //�μ�
			ht25.put("NO_DOCU",  	"");  //row_id�� ���� 
			ht25.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht25.put("CD_COMPANY",  "1000");  
			ht25.put("ID_WRITE", insert_id);   
			ht25.put("CD_DOCU",  "11");  
			
			ht25.put("DT_ACCT",  incom_dt);  
			ht25.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				
			if ( acct_gubun.equals("D") ) {
				ht25.put("TP_DRCR",  amt_gubun); //����		
			} else {
				ht25.put("TP_DRCR",  amt_gubun); //�뺯				
			}	
						
			ht25.put("CD_ACCT",  	"25900");  //������
			ht25.put("AMT",    	String.valueOf(t_pay_amt));		
			ht25.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü			
			ht25.put("CD_PARTNER",	n_ven_code); //�ŷ�ó    - A06
	
			ht25.put("DT_START",  incom_dt);  	//�߻�����					 
			ht25.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht25.put("CD_DEPT",		"");   //�μ�								 
			ht25.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht25.put("CD_PJT",			"");   //������Ʈ�ڵ�	
			ht25.put("CD_CARD",		"");   //�ſ�ī��			
			ht25.put("CD_EMPLOY",		"");   //���					 		 
			ht25.put("NO_DEPOSIT",		"");  //�����ݰ���
			ht25.put("CD_BANK",		"");  //�������	
		 	ht25.put("NO_ITEM",		"");  //item 	 
		 	
		 			// �ΰ�������
			ht25.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht25.put("AM_ADDTAX",	"" );	 //����
			ht25.put("TP_TAX",	"");  //����(����) :11
			ht25.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
		
			ht25.put("NM_NOTE", acc_cont);  // ����				
					
			vt.add(ht25);	
	   }			
						
				//  ĳ�������� ���ý� 
		if ( ip_acct.equals("6")  ||  ip_acct.equals("17") ) {
		
			line++;
			
			acc_cont =  "[ĳ����]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];	
			
			if ( acct_gubun.equals("D") ) {
				t_pay_amt =  ip_acct_amt*(-1);	
			} else {
				t_pay_amt =  ip_acct_amt;
			}			
				
		    if ( acct_gubun.equals("D") ) { //���� 
				docu_gubun = "3";		
				amt_gubun = "1";
		    } else {
			    docu_gubun = "3";		
				amt_gubun = "2";
			}
		
			//ĳ����
			Hashtable ht31= new Hashtable();
			
			ht31.put("WRITE_DATE", 	incom_dt);  //row_id		
			ht31.put("ROW_NO",  	String.valueOf(line)); //row_no
			
			ht31.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht31.put("CD_PC",  	node_code);  //ȸ�����
			ht31.put("CD_WDEPT",  dept_code);  //�μ�
			ht31.put("NO_DOCU",  	"");  // row_id�� ���� 
			ht31.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht31.put("CD_COMPANY",  "1000");  
			ht31.put("ID_WRITE", insert_id);   
			ht31.put("CD_DOCU",  "11");  
			
			ht31.put("DT_ACCT",  incom_dt);  
			ht31.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				
			if ( acct_gubun.equals("D") ) {
				ht31.put("TP_DRCR",  amt_gubun); //����		
			} else {
				ht31.put("TP_DRCR",  amt_gubun); //�뺯				
			}	
						
			ht31.put("CD_ACCT",    	"91100");  //ī��ĳ����
			ht31.put("AMT",    	String.valueOf(t_pay_amt));		
			ht31.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü				
			ht31.put("CD_PARTNER",	n_ven_code); //�ŷ�ó    - A06
					
			ht31.put("DT_START",   	 "");  	//�߻�����					 
			ht31.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht31.put("CD_DEPT",		"");   //�μ�								 
			ht31.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht31.put("CD_PJT",			"");   //������Ʈ�ڵ�	
			ht31.put("CD_CARD",		"");   //�ſ�ī��		 		 	
			ht31.put("CD_EMPLOY",		"");   //���	
			ht31.put("NO_DEPOSIT",		"");  //�����ݰ���
			ht31.put("CD_BANK",		"");  //�������	
		 	ht31.put("NO_ITEM",		"");  //item 	 
		 	
		 			// �ΰ�������
			ht31.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht31.put("AM_ADDTAX",	"" );	 //����
			ht31.put("TP_TAX",	"");  //����(����) :11
			ht31.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	 
		
			ht31.put("NM_NOTE", acc_cont);  // ����				
						
			vt.add(ht31);	
		}	
	
					
		// �����ޱ�
		if ( ip_acct.equals("11") ) {
							 	
			line++;
			
			acc_cont =  "[�����ޱ�]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
								
			if ( acct_gubun.equals("D") ) { 
				t_pay_amt =  ip_acct_amt*(-1);	
			} else {
				t_pay_amt =  ip_acct_amt;
			}
					
		    if ( acct_gubun.equals("D") ) { //���� 
				docu_gubun = "3";		
				amt_gubun = "1";
		    } else {
			    docu_gubun = "3";		
				amt_gubun = "2";
		    } 
			
							
			// �����ޱ�
			Hashtable ht36= new Hashtable();
			
			ht36.put("WRITE_DATE", 	incom_dt);  //row_id			
			ht36.put("ROW_NO",  	String.valueOf(line)); //row_no
			
			ht36.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht36.put("CD_PC",  	node_code);  //ȸ�����
			ht36.put("CD_WDEPT",  dept_code);  //�μ�
			ht36.put("NO_DOCU",  	"");  //row_id�� ���� 
			ht36.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht36.put("CD_COMPANY",  "1000");  
			ht36.put("ID_WRITE", insert_id);   
			ht36.put("CD_DOCU",  "11");  
			
			ht36.put("DT_ACCT",  incom_dt);  
			ht36.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				
			if ( acct_gubun.equals("D") ) {
				ht36.put("TP_DRCR",  amt_gubun); //����		
			} else {
				ht36.put("TP_DRCR",  amt_gubun); //�뺯				
			}	
						
			ht36.put("CD_ACCT",    	 	"13400");  // �����ޱ�
			ht36.put("AMT",    	String.valueOf(t_pay_amt));		
			ht36.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü				
			ht36.put("CD_PARTNER",	n_ven_code); //�ŷ�ó    - A06
					
			ht36.put("DT_START",   incom_dt);   	//�߻�����					 
			ht36.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht36.put("CD_DEPT",		"");   //�μ�								 
			ht36.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht36.put("CD_PJT",			"");   //������Ʈ�ڵ�	
			ht36.put("CD_CARD",		"");   //�ſ�ī��		 		 	
			ht36.put("CD_EMPLOY",		"");   //���
			ht36.put("NO_DEPOSIT",		"");  //�����ݰ���
			ht36.put("CD_BANK",		"");  //�������	
		 	ht36.put("NO_ITEM",		"");  //item 	
		 	
		 			// �ΰ�������
			ht36.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht36.put("AM_ADDTAX",	"" );	 //����
			ht36.put("TP_TAX",	"");  //����(����) :11
			ht36.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ    	 
		
			ht36.put("NM_NOTE", acc_cont);  // ����			
			
			vt.add(ht36);								
		
		}								
			
		// �������� - ���� Ȯ���� ����ȸ�� ������ �Աݰ� - , 19:��������. 20:��ݺ� , 18:���ڼ��� - ����:ȯ�޺�, �뺯: �����ұݾ�  
		// 1:�°������ 2:ä���߽ɼ�����, 3:���Ա����� ���� ��ȯ�� , 4:��å��, 12: ������, 16:�ܱ����Ա� - ����:ȯ�޺�, �뺯: �����ұݾ� , 13: ���·� �̼���  , 14:���ޱ�, 15:�̼��� 10:�����ޱ� , 9:���޼����� , 8:�ܻ����� , 7:���ݰ����� , 5:������
		if (  ip_acct.equals("1") ||  ip_acct.equals("2") ||  ip_acct.equals("3") ||  ip_acct.equals("4") ||  ip_acct.equals("5")  || ip_acct.equals("7") ||  ip_acct.equals("8") ||  ip_acct.equals("9") ||  ip_acct.equals("10") ||  ip_acct.equals("12") ||  ip_acct.equals("13") ||  ip_acct.equals("14")  || ip_acct.equals("15")  ||  ip_acct.equals("18") || ip_acct.equals("19") || ip_acct.equals("20") ||  ip_acct.equals("16")  ) {
				 	
			line++;
			
			acc_cont = "";
			String acct_code = "";			
			
		   if (  ip_acct.equals("19") ) {
		    		 acc_cont =  "[��������]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
		    		 acct_code = "45510"; //���������������
		   } else if (  ip_acct.equals("1") ) {
			 		 acc_cont =  "[�°������]" + "-" + n_ven_name+ " " +remark + "  " +  naeyoung[i];		
			 		 acct_code = "45510";	   //��å��		  		  		 
		   } else if (  ip_acct.equals("2") ) {
			 		 acc_cont =  "[ä���߽ɼ�����]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "25300";	  	//�����ޱ� 	  		 
		   } else if (  ip_acct.equals("3") ) {
			 		 acc_cont =  "[���Ա� ȯ��]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "25300";	  		//�����ޱ�  
		    } else if (  ip_acct.equals("4") ) {
			 		 acc_cont =  "[��å��]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "45510";	 //���������������		 
		    } else if (  ip_acct.equals("5") ) {
			 		 acc_cont =  "[������]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];			
			 		 acct_code = "25700";	  		 
		   } else if (  ip_acct.equals("7") ) {
			 		 acc_cont =  "[���ݰ�����]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "46300";	  	 		  		 
		   } else if (  ip_acct.equals("8") ) {
			 		 acc_cont =  "[�ܻ�����]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "10800";	  	 		 
		   } else if (  ip_acct.equals("9") ) {
			 		 acc_cont =  "[���޼�����]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];			
			 		 acct_code = "83100";	  	 		 
		   } else if (  ip_acct.equals("10") ) {
			 		 acc_cont =  "[�����ޱ�]" + "-" + n_ven_name+ " " +remark + "  " +  naeyoung[i];		
			 		 acct_code = "25300";	  		 
		   } else if (  ip_acct.equals("12") ) {
			 		 acc_cont =  "[������]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "93000";	  		 
		   } else if (  ip_acct.equals("13") ) {
			 		 acc_cont =  "[���·�̼���]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "12400";	 
		  } else if (  ip_acct.equals("14") ) {
			 		 acc_cont =  "[���ޱ�]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "13100";	 	 		  		 
		   } else if (  ip_acct.equals("15") ) {
			 		 acc_cont =  "[�̼���]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "12000";	 		 
		   } else if (  ip_acct.equals("16") ) {
			 		 acc_cont =  "[�ܱ����Ա�]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "26000";			 		  					 		 
			} else if (  ip_acct.equals("18") ) {
			 		 acc_cont =  "[���ڼ���]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "90100";			 		  					
		   } else if (  ip_acct.equals("20") ) {
			 		 acc_cont =  "[��ݺ�]" + "-" + n_ven_name+ " " +remark + "  " +  naeyoung[i];		
			 		 acct_code = "46400";
			}
			
			//ä���߽��� ��� 
			if (  ip_acct.equals("2") ) {
			  	if ( acct_gubun.equals("D") ) { 
					t_pay_amt =  ip_acct_amt;	
				} else {
					t_pay_amt = ip_acct_amt*(-1);	
				}
			} else {								
				if ( acct_gubun.equals("D") ) { 
					t_pay_amt =  ip_acct_amt*(-1);	
				} else {
					t_pay_amt =  ip_acct_amt;
				}
			}
					
		    if ( acct_gubun.equals("D") ) { //���� 
				docu_gubun = "3";		
				amt_gubun = "1";
		    } else {
			    docu_gubun = "3";		
				amt_gubun = "2";
		    } 
											
			Hashtable ht43 =  new Hashtable();
			
			ht43.put("WRITE_DATE", 	incom_dt);  //row_id			
			ht43.put("ROW_NO",  	String.valueOf(line)); //row_no			
			ht43.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht43.put("CD_PC",  	node_code);  //ȸ�����
			ht43.put("CD_WDEPT",  dept_code);  //�μ�
			ht43.put("NO_DOCU",  	"");  //row_id�� ���� 
			ht43.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht43.put("CD_COMPANY",  "1000");  
			ht43.put("ID_WRITE", insert_id);   
			ht43.put("CD_DOCU",  "11");  
			
			ht43.put("DT_ACCT",  incom_dt);  
			ht43.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				
			if ( acct_gubun.equals("D") ) {
				ht43.put("TP_DRCR",  amt_gubun); //����		
			} else {
				ht43.put("TP_DRCR",  amt_gubun); //�뺯				
			}	
						
			ht43.put("CD_ACCT",    	 		  acct_code); 
			ht43.put("AMT",    	String.valueOf(t_pay_amt));		
			ht43.put("TP_GUBUN",	docu_gubun);  //1:�Ա� 2:��� 3:��ü				
			ht43.put("CD_PARTNER",	n_ven_code); //�ŷ�ó    - A06
				
			ht43.put("DT_START",  incom_dt);   	//�߻�����					 
			ht43.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht43.put("CD_DEPT",		"");   //�μ�								 
			ht43.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht43.put("CD_PJT",			"");   //������Ʈ�ڵ�	��
			ht43.put("CD_CARD",		"");   //�ſ�ī��		 		 	
			ht43.put("CD_EMPLOY",		"");   //���	
			ht43.put("NO_DEPOSIT",		"");  //�����ݰ���
			ht43.put("CD_BANK",		"");  //�������	
		 	ht43.put("NO_ITEM",		"");  //item   	
		 	
		 			// �ΰ�������
			ht43.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht43.put("AM_ADDTAX",	"" );	 //����
			ht43.put("TP_TAX",	"");  //����(����) :11
			ht43.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ		  	 	 
		
			ht43.put("NM_NOTE", acc_cont);  // ����	
		
			vt.add(ht43);	
		}		
			
		
	   //�ະ�� ���뿹�� ó��  
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
		ht1.put("AMT",    	String.valueOf(ip_acct_amt));
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
	
		ht1.put("NM_NOTE", acc_cont);  // ����			
					
		vt.add(ht1);
																								
																											
 }  //for loop						
			
 if  ( vt.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(incom_dt,  vt);		
 }
 	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
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

