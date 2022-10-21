<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.coolmsg.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int  cltr_rat = request.getParameter("cltr_rat")==null?0:Util.parseInt(request.getParameter("cltr_rat"));  //�Ե����丮�������� ��� (202204)
		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String doc_id =  FineDocDb.getFineGovNoNext("�ѹ�");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String fund_yn = request.getParameter("fund_yn")==null?"":request.getParameter("fund_yn");
	
	int count = 0;
	boolean flag = true;
	boolean flag2 = true;
	
	//�ߺ�üũ
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(cmd.equals("m")){	
		// �����û�� �ѹ����� �� ����, �Ա�, ��� ����ڿ��� �޼��� ����------------------------------------------------------------------------------------------
		
		String bank_nm = request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
		String vio_dt = request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
		long amt_tot = request.getParameter("amt_tot")==null?0:Util.parseDigitLong(request.getParameter("amt_tot"));
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		String sub 		= "�����û�� �� ����ڿ��� �޽����� �뺸";
		String cont 	= bank_nm+" ����� "+Util.parseDecimalLong(amt_tot)+"�� "+vio_dt+ " �Աݿ����Դϴ�";	
		String url 		= "/acar/bank_mng/bank_doc_mng_frame.jsp";	 
		String target_id = "";  				
		CdAlertBean msg = new CdAlertBean();
		
		String xml_data = "";
		
		//�ѹ����忡�� �޼��� ������
			
		target_id =nm_db.getWorkAuthUser("CMS����"); //�Ⱥ���, ���¿�(2004005), �Աݴ����
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <TARGET>2004005</TARGET>";
		xml_data += "    <TARGET>2000002</TARGET>";//�������
		xml_data += "    <TARGET>2013002</TARGET>";//������
		xml_data += "    <TARGET>2017003</TARGET>";//���ؼ�
	
		//	xml_data += "    <TARGET>2006007</TARGET>";//
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
		
		
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("��޽���(�������)---------------------"+target_bean.getUser_nm());
		
		
	//�޼��� ���� ��
	}else if(!cmd.equals("m")){
	if(count == 0){
		//���� ���̺�
		FineDocBn.setDoc_id		(doc_id);
		FineDocBn.setDoc_dt		(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));
		FineDocBn.setFund_yn		(request.getParameter("fund_yn")==null?"":request.getParameter("fund_yn"));  //�����ڱ� ���� 
		FineDocBn.setGov_id		(bank_id);
		FineDocBn.setMng_dept		(request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept"));
		FineDocBn.setReg_id		(user_id);
		FineDocBn.setGov_st		(request.getParameter("lend_cond")==null?"":request.getParameter("lend_cond")); //��ȯ����
		FineDocBn.setFilename		(request.getParameter("lend_int")==null?"0.0":request.getParameter("lend_int")); //����ݸ� - �����û�� �����
		FineDocBn.setMng_nm		(request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm"));
		FineDocBn.setMng_pos		(request.getParameter("mng_pos")==null?"":request.getParameter("mng_pos"));
		FineDocBn.setTitle		(request.getParameter("title")==null?"":request.getParameter("title"));	
		FineDocBn.setH_mng_id		(request.getParameter("h_mng_id")==null?"":request.getParameter("h_mng_id"));
		FineDocBn.setB_mng_id		(request.getParameter("b_mng_id")==null?"":request.getParameter("b_mng_id"));
		FineDocBn.setApp_doc1		(request.getParameter("app_doc1")==null?"N":request.getParameter("app_doc1"));
		FineDocBn.setApp_doc2		(request.getParameter("app_doc2")==null?"N":request.getParameter("app_doc2"));
		FineDocBn.setApp_doc3		(request.getParameter("app_doc3")==null?"N":request.getParameter("app_doc3"));
		FineDocBn.setApp_doc4		(request.getParameter("app_doc4")==null?"N":request.getParameter("app_doc4"));
		FineDocBn.setApp_doc5		(request.getParameter("app_doc5")==null?"N":request.getParameter("app_doc5"));
		FineDocBn.setEnd_dt		(request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt")); //���� ��������
		
		FineDocBn.setOff_id		(request.getParameter("off_id")==null?"":request.getParameter("off_id")); //���� �����
		FineDocBn.setSeq		(request.getParameter("seq")==null?0:AddUtil.parseDigit(request.getParameter("seq"))); //���� 
		
		FineDocBn.setCltr_rat		(request.getParameter("cltr_rat")==null?"":request.getParameter("cltr_rat")); //�����缳����
		FineDocBn.setCltr_amt		(request.getParameter("cltr_amt")==null?0:AddUtil.parseDigit(request.getParameter("cltr_amt"))); //�����Ǵ�ݾ�
		
		if  (  bank_id.equals("0065")    )  {  //��ȭ������ - ÷������5 ����
			FineDocBn.setApp_doc5("N");
		}
		
		flag = FineDocDb.insertFineDoc(FineDocBn);

		//���� ����Ʈ
		String car_mng_id[]  = request.getParameterValues("car_mng_id");
		String rent_mng_id[] = request.getParameterValues("rent_mng_id");
		String rent_l_cd[]   = request.getParameterValues("rent_l_cd");
		String rent_s_cd[]   = request.getParameterValues("rent_s_cd");
		String firm_nm[] 	 = request.getParameterValues("firm_nm");
		String fee_amt[] 	 = request.getParameterValues("fee_amt");
		String tot_fee_amt[] = request.getParameterValues("tot_fee_amt");
		String car_amt[] 	 = request.getParameterValues("car_amt");
		String loan_amt[] 	 = request.getParameterValues("loan_amt");	
		String tax_amt[] 	 = request.getParameterValues("tax_amt");	//����ĳ��Ż(0011)�� �����ڱ��� ��� 4%��漼 (2%+ 2% �� ��� )
		String con_mon[] 	 = request.getParameterValues("con_mon");	
		String s_car_f_amt[] 	 = request.getParameterValues("car_f_amt");	 //�츮ī��(0046)�϶��� ���  		
		String s_car_dc_amt[] 	 = request.getParameterValues("car_dc_amt");	 //�츮ī��(0046)�϶��� ���  		
		int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
		
		long loan_amte = 0;
		long tax_amte = 0;
		long tot_amte = 0;
		
		int dam_amt = 0;
		float  dam_f_amt = 0;  //�㺸������	
		
		int  amt3 = 0;  //��������
		int  amt4 = 0;  //�����
		int  amt5 = 0;  //��漼
		int  car_f_amt = 0;   //�츮ī��(0046)�϶��� ���  		
		int  car_dc_amt = 0;   //�츮ī��(0046)�϶��� ���  		
		String exp_dt = request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt");
		
		for(int i=0; i<size; i++){
				
			FineDocListBn.setDoc_id			(doc_id);
			FineDocListBn.setCar_mng_id		(car_mng_id[i]);
			FineDocListBn.setSeq_no			(i + 1);
			FineDocListBn.setRent_mng_id	(rent_mng_id[i]);
			FineDocListBn.setRent_l_cd		(rent_l_cd[i]);
			FineDocListBn.setRent_s_cd		(rent_s_cd[i]);
			FineDocListBn.setFirm_nm		(firm_nm[i]==null?"":firm_nm[i]);
						
			FineDocListBn.setAmt1			(fee_amt[i]==null?0:AddUtil.parseDigit(fee_amt[i]));  //�뿩��
			FineDocListBn.setAmt2			(tot_fee_amt[i]==null?0:AddUtil.parseDigit(tot_fee_amt[i]));  // �Ѵ뿩��
			FineDocListBn.setAmt3			(car_amt[i]==null?0:AddUtil.parseDigit(car_amt[i]));     // ��������
			
			amt3 = car_amt[i]	==null?0 :AddUtil.parseDigit(car_amt[i]);
			amt4 = loan_amt[i]	==null?0 :AddUtil.parseDigit(loan_amt[i]);
			
			amt5 = tax_amt[i]	==null?0 :AddUtil.parseDigit(tax_amt[i]);
			
			car_f_amt = s_car_f_amt[i]	==null?0 :AddUtil.parseDigit(s_car_f_amt[i]);  //�츮ī��(0046)�϶��� ���  		
			car_dc_amt = s_car_dc_amt[i]	==null?0 :AddUtil.parseDigit(s_car_dc_amt[i]);  //�츮ī��(0046)�϶��� ���  		
			
			if ( bank_id.equals("0011") ) {	  //����ĳ��Ż_������ ��쿡 ���ؼ� ��漼 ( 2%*2 �� ��� (���ϼ��� ���� ��� - ���� 4% -20211021))
				if (fund_yn.equals("Y")) {
					amt5 = amt5 * 2;
				} else {
					amt5=0;
				}				
			}
			
			FineDocListBn.setAmt4			(amt4);   //����� 
			FineDocListBn.setAmt5			(amt5);   //��漼 
																
			 // �Ｚī��� 20% �㺸 
			if ( bank_id.equals("0018") ) {			
			        dam_amt =  FineDocDb.getDamAmt(amt4, 0);
			    	FineDocListBn.setAmt6		( dam_amt );		
		//	} else if ( bank_id.equals("0037")    ) { //���� - 20140324 ���� ����Ǽ�������			
		//	         FineDocListBn.setAmt6		(0 );	    	
			} else if (  bank_id.equals("0002")   ) {			
			        dam_amt =  FineDocDb.getDamAmt1(amt3);
			    	FineDocListBn.setAmt6		( dam_amt );	
			} else if  (  bank_id.equals("0044")   )  {  
			        FineDocListBn.setAmt6		(amt4+ amt5  );
			} else if  (  bank_id.equals("0058")  )  {
					FineDocListBn.setAmt6		(1000000);   //�㺸������
			} else if  (  bank_id.equals("0025") ||  bank_id.equals("0004") )  {  //��������, �λ����� , ��������(11/06)
					FineDocListBn.setAmt6		(0);   //�㺸������	
			} else if  (  bank_id.equals("0041") ||  bank_id.equals("0055")  ||  bank_id.equals("0069")  ||  bank_id.equals("0102") ||   bank_id.equals("0118") )  {  //�ϳ�ĳ��Ż �㺸 50%->20% ����, ����ĳ��Ż 0%->20%, bsĳ��Ż 50%->20%, �ѱ���Ƽ�׷�ĳ��Ż, ��������(0072) , bnkĳ��Ż(0102)
			        FineDocListBn.setAmt6		( (amt4 + amt5) /5 );	
			} else if  (  bank_id.equals("0011") ||  bank_id.equals("0108") )  {  //����ĳ��Ż �㺸 20%->50% ����
		         	FineDocListBn.setAmt6		( (amt4 + amt5) /2 );				
		    } else if (  bank_id.equals("0076")  ||  bank_id.equals("0081")  ||  bank_id.equals("0074")  ||  bank_id.equals("0090") ||  bank_id.equals("0084")  ) {		// aj�κ���Ʈ - ���԰����� 50% , �ϳ�����(0074), ��������(0081)  0084(�ﱹ- 20190617)
		        	dam_amt =  FineDocDb.getDamAmt2(amt3);		      		
			    	FineDocListBn.setAmt6		( dam_amt );				
			} else if ( bank_id.equals("0101")  || bank_id.equals("0114")  ) {		// jt����  - �������  50% , �Ե�ī��(0114) -202104����
		        	dam_amt =  FineDocDb.getDamAmt2(amt4);
		       		FineDocListBn.setAmt6		( dam_amt );	
		    } else if ( bank_id.equals("0072") ) {		// ��������   - 2019�Ǻ��� ������� 10% ,
	        		dam_amt =  FineDocDb.getDamAmtRate(10, amt4);
	        		FineDocListBn.setAmt6		( dam_amt );		        		
		    } else if ( bank_id.equals("0093")  ) {		// �Ե����丮��   - �������  70% - 2018�Ǻ��� ������� 70% (�����ڱ��� ���) , �Һ��ڱ��� ��� (202204 - ������� 60%)
		        	dam_amt =  FineDocDb.getDamAmtRate(cltr_rat, amt4);
		        	FineDocListBn.setAmt6		( dam_amt );	
		    } else if ( bank_id.equals("0033") ||  bank_id.equals("0029")   ) {		// ��������(0033) , ��������(0029)  - �������  120% - 2019�Ǻ���
			        dam_amt =  FineDocDb.getDamAmtRate(120, amt4); 
		       		FineDocListBn.setAmt6		( dam_amt );			       		    		
			} else if ( bank_id.equals("0059")  ) {		// hk����  - �������  30%
		        	dam_amt =  FineDocDb.getDamAmt3(amt4);
		       		FineDocListBn.setAmt6		( dam_amt );	
			} else if ( bank_id.equals("0064")     )  {  //�޸���  - ����� õ�������� ����	
			        dam_amt =  FineDocDb.getDamAmt4(amt4+amt5 , 3);
			    	FineDocListBn.setAmt6		( dam_amt );					 
			} else if ( bank_id.equals("0065")  ||  bank_id.equals("0038")  ||  bank_id.equals("0057")  )  {  //��ȭ������ - ����� 100% ,  kt����Ż(0056-> 20140724 �㺸100%) , �Ե�ĳ��Ż(0038>20140820 100%) , �ﱹ��ȣ(0084) - , ibkĳ��Ż(0057) - 50���ѵ��������� 202012)
			        dam_amt =  amt4;
			    	FineDocListBn.setAmt6		( dam_amt );	
			    	FineDocListBn.setAmt5			(0);   //��漼 
		//	} else if  (   bank_id.equals("0079"))  {  //�޸���ĳ��Ż 
		//	      dam_amt =  FineDocDb.getDamAmt4( amt4+amt5  );
		//	//        dam_amt =  amt4+amt5;
		//	    	FineDocListBn.setAmt6		( dam_amt );				     	
		//	} else if  ( bank_id.equals("0028")  )  {  //�ϳ��������� , �������� (20170412) - �������� 100%  -- ������� 110% (20200901)
		//	        dam_amt =  amt3;
		//	    	FineDocListBn.setAmt6		( dam_amt );	
		//	    	FineDocListBn.setAmt5			(0);   //��漼 	
			 } else if ( bank_id.equals("0028") ) {		// ��������   - �������  110% - 2019�Ǻ���
			        dam_amt =  FineDocDb.getDamAmtRate(110, amt4); 
		       		FineDocListBn.setAmt6		( dam_amt );	
		       		FineDocListBn.setAmt5			(0);   //��漼 						
		       		
			} else if ( bank_id.equals("0078") ||  bank_id.equals("0080")   ||  bank_id.equals("0087")  ||  bank_id.equals("0103")  )  {  //kb ĳ��Ż(00782) , ok����(0080) , ȿ��ĳ��Ż(0039) , IBKĳ��Ż(0057) , kb����(0103) - ������� 10%
			         FineDocListBn.setAmt6		( (amt4 + amt5) /10 );	 
						         
			} else if ( bank_id.equals("0046") ) {		// �츮ī�� (0046)  -��������(car_f_amt)
				    dam_amt =  car_f_amt - car_dc_amt;
					FineDocListBn.setAmt6		( dam_amt );	
		    } else if ( bank_id.equals("0001") ) { //�ϳ�����
		      	    dam_amt =  FineDocDb.getDamAmtRate(60, amt4); 
          		//	dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt4)) *60/100; 
          		//	dam_amt = (int)  dam_f_amt;
          		//	dam_amt =  AddUtil.th_rnd(dam_amt);	
          			FineDocListBn.setAmt6		( dam_amt );    
          	
			
		/*	} else if  (  bank_id.equals("0029")    )  {  //�������� - �������԰��డ�� 50%
				dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *50/100; 
		        dam_amt = (int)  dam_f_amt;
     			dam_amt =  AddUtil.th_rnd(dam_amt);	
		    	FineDocListBn.setAmt6		( dam_amt );	
		    	FineDocListBn.setAmt5			(0);   //��漼 	    	
			    	
			  } else if (bank_id.equals("0029") ) { //�������� 0  �������԰��ް��� 50%
			            dam_f_amt = ( AddUtil.parseFloat(Integer.toString(amt3)) / AddUtil.parseFloat("1.1") )* 50/100;
			            dam_amt = (int)  dam_f_amt;
			            dam_amt =  FineDocDb.getDamAmt4(dam_amt+dam_amt , 3);
          		//	  dam_amt =  AddUtil.th_rnd(dam_amt);	
          			  FineDocListBn.setAmt6		( dam_amt );          	 */           
			  			  	         
			} else if  (  bank_id.equals("0083")    )  {  //������������ - �������� 70%
					dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *70/100; 
			        dam_amt = (int)  dam_f_amt;
          			dam_amt =  AddUtil.th_rnd(dam_amt);	
			    	FineDocListBn.setAmt6		( dam_amt );	
			    	FineDocListBn.setAmt5			(0);   //��漼 	
			} else if  (  bank_id.equals("0115")    )  {  //��ȭ�������� - �������� 30%
				dam_amt =  FineDocDb.getDamAmtRound4(amt3, 30);
			//	dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *30/100; 
		     //   dam_amt = (int)  dam_f_amt;
      		//	dam_amt =  AddUtil.th_rnd(dam_amt);	
		    	FineDocListBn.setAmt6		( dam_amt );	
		    	FineDocListBn.setAmt5			(0);   //��漼 	    	
			    	
			} else if  (  bank_id.equals("0089") ||  bank_id.equals("0111")    )  {  //�μ���������, ��ȭ��������(0111) - �������� 10%
					dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *10/100; 
		         	dam_amt = (int)  dam_f_amt;
     				dam_amt =  AddUtil.th_rnd(dam_amt);	
		    		FineDocListBn.setAmt6		( dam_amt );	
		    		FineDocListBn.setAmt5			(0);   //��漼 	
		    	
			} else if  (  bank_id.equals("0085")   )  {  //KB��������,  - ��������10%
				//dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt3)) *50/100; 
			      //  dam_amt = (int)  dam_f_amt;
			       	dam_amt =  FineDocDb.getDamAmt10(amt3 );
          		//	dam_amt =  AddUtil.ml_th_rnd(dam_amt);	
			    	FineDocListBn.setAmt6		( dam_amt );	
			    	FineDocListBn.setAmt5			(0);   //��漼 				          		    		    		    	
			          		    		    		    	
	           }  else {  //  bank_id.equals("0039") -2021����� �㺸�� 50%
	                FineDocListBn.setAmt6		( (amt4 + amt5) /2 );
	           } 
                 				
			FineDocListBn.setPaid_no		(con_mon[i]==null?"0":con_mon[i]);
			
			FineDocListBn.setReg_id			(user_id);
			
			flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());
			
			loan_amte += loan_amt[i]==null?0:AddUtil.parseDigit(loan_amt[i]) ;
			tax_amte += tax_amt[i]==null?0:AddUtil.parseDigit(tax_amt[i]) ;
			
		}
		tot_amte = loan_amte + tax_amte;

	}
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
  <input type='hidden' name='doc_id' value='<%=doc_id%>'>
</form>
<script>
<%if(cmd.equals("m")){%>
	alert("�޼����� ���������� ���۵Ǿ����ϴ�.");
		var fm = document.form1;	
		fm.action = "bank_doc_mng_frame.jsp";	
		fm.target = 'd_content';
		fm.submit();
<%}else{%>
	
<%	if(count == 0){%>
<%		if(flag==true){%>
			alert("���������� ó���Ǿ����ϴ�.");
			parent.parent.location.reload();			
<%		}else{%>
			alert("�����߻�!");
<%		}%>
<%	}else{%>
			alert("�̹� ��ϵ� ������ȣ�Դϴ�. Ȯ���Ͻʽÿ�.");
//			parent.document.form1.bank_nm.focus();
<%	}%>
<%}%>
</script>
</body>
</html>

