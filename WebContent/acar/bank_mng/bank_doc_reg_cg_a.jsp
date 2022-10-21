<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
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
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String fund_yn = request.getParameter("fund_yn")==null?"":request.getParameter("fund_yn");
	
	int  cltr_rat = request.getParameter("cltr_rat")==null?0:Util.parseInt(request.getParameter("cltr_rat"));  //�Ե����丮�������� ��� (202204)
	
	int count = 0;
	int dam_amt = 0;
	float  dam_f_amt = 0;  //�㺸������	
		
	int  amt3 = 0;  //��������
	int  amt4 = 0;  //�����
	int  amt5 = 0;  //��漼
	int car_f_amt = 0; //��������
	int car_dc_amt = 0; //dc����
		
	boolean flag = true;
	
	//�ߺ�üũ
//	count = FineDocDb.getDocIdChk(doc_id);
	int seq = 0;

	seq = FineDocDb.Seq_no_Next(doc_id);
	
	if(count == 0){
	
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
		String tax_amt[] 	 = request.getParameterValues("tax_amt");	
		String con_mon[] 	 = request.getParameterValues("con_mon");
		String s_car_f_amt[] 	 = request.getParameterValues("car_f_amt");  //�츮ī��(0046)�� ��� 
		String s_car_dc_amt[] 	 = request.getParameterValues("car_dc_amt");  //�츮ī��(0046)�� ��� 
		
		int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
		
		for(int i=0; i<size; i++){
			FineDocListBn.setDoc_id			(doc_id);
			FineDocListBn.setCar_mng_id		(car_mng_id[i]);
//			FineDocListBn.setSeq_no			(i + 1);
			FineDocListBn.setSeq_no			(seq + i +1);
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
			
			car_f_amt = s_car_f_amt[i]	==null?0 :AddUtil.parseDigit(s_car_f_amt[i]);
			car_dc_amt = s_car_dc_amt[i]	==null?0 :AddUtil.parseDigit(s_car_dc_amt[i]);
			
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
			if ( 		bank_id.equals("0018") ) {			
			    dam_amt =  FineDocDb.getDamAmt(amt4, 0);
			   	FineDocListBn.setAmt6		( dam_amt );
			} else if ( bank_id.equals("0002")   ) {			
			    dam_amt =  FineDocDb.getDamAmt1(amt3);
			   	FineDocListBn.setAmt6		( dam_amt );	
			} else if  ( bank_id.equals("0044")   )  {
			    FineDocListBn.setAmt6		(amt4+ amt5  );
			} else if  ( bank_id.equals("0058")  )  {
				FineDocListBn.setAmt6		(1000000);   //�㺸������
			} else if  ( bank_id.equals("0025") || bank_id.equals("0004")   )  {  //��������, �λ�����, �������, ��������(11/06)
				FineDocListBn.setAmt6		(0);   //�㺸������	
			} else if  ( bank_id.equals("0041") || bank_id.equals("0055")  ||  bank_id.equals("0069")  ||  bank_id.equals("0102") ||  bank_id.equals("0118")   )  {  //�ϳ�ĳ��Ż �㺸 50%->20% ����, ����ĳ��Ż 0%->20% 
			    FineDocListBn.setAmt6		( (amt4 + amt5) /5 );	
			} else if  ( bank_id.equals("0011") ||  bank_id.equals("0108") )  {  //����ĳ��Ż �㺸 20%->50% ���� 
		        FineDocListBn.setAmt6		( (amt4 + amt5) /2 );	
		    } else if ( bank_id.equals("0076")  || bank_id.equals("0081")  ||  bank_id.equals("0074")  ||  bank_id.equals("0090")  ||  bank_id.equals("0084")    ) {		//, aj�κ���Ʈ	- ���԰��� 50% 
		       	dam_amt =  FineDocDb.getDamAmt2(amt3);
			    FineDocListBn.setAmt6		( dam_amt );	
		    } else if ( bank_id.equals("0101") || bank_id.equals("0114") ) {		//, ����Ƽ����(0101)	- ���Ⱑ�� 50% , �Ե�ī��(0114) -202104����
		        dam_amt =  FineDocDb.getDamAmt2(amt4);
			    FineDocListBn.setAmt6		( dam_amt );	
			} else if (  bank_id.equals("0059")  ) {		// hk����  - �������  30%
		   		dam_amt =  FineDocDb.getDamAmt3(amt4);
		   		FineDocListBn.setAmt6		( dam_amt );			    
		   	} else if (  bank_id.equals("0093")  ) {		// �Ե����丮��  - �������  70%  - cltr_rat�� ó�� 
		   		dam_amt =  FineDocDb.getDamAmtRate(cltr_rat, amt4);
		   		FineDocListBn.setAmt6		( dam_amt );	
		   	} else if (  bank_id.equals("0072")   ) {		// ��������  - �������  10% 
    	    	dam_amt =  FineDocDb.getDamAmtRate(10, amt4);
 	    	 	FineDocListBn.setAmt6		( dam_amt );	  		
		    } else if (  bank_id.equals("0033") || bank_id.equals("0029")  ) {		// �������� (0033), ��������(0029)-2021��  - �������  120% - 2019�Ǻ���
		        dam_amt =  FineDocDb.getDamAmtRate(120, amt4); 
	       		FineDocListBn.setAmt6		( dam_amt );
		    } else if (  bank_id.equals("0028")  ) {		// ��������   - �������  110% - 202009�Ǻ���
		        dam_amt =  FineDocDb.getDamAmtRate(110, amt4); 
	       		FineDocListBn.setAmt6		( dam_amt );	
	       		FineDocListBn.setAmt5			(0);   //��漼 	
			} else if  (  bank_id.equals("0064")  )  {  //�޸���  - ����� õ�������� ����	
			    dam_amt =  FineDocDb.getDamAmt4(amt4+amt5, 3);
			  	FineDocListBn.setAmt6		( dam_amt );					 
			} else if  (  bank_id.equals("0065") || bank_id.equals("0038")  || bank_id.equals("0057") )  {  //��ȭ������ - ����� 100% ,  ktĳ��Ż(20140724 - 100%), �Ե�ĳ��Ż(0038>20140820 100%) , �ﱹ����(0084) , ibkĳ��Ż(0057)
			    dam_amt =  amt4;
			  	FineDocListBn.setAmt6		( dam_amt );	
			  	FineDocListBn.setAmt5			(0);   //��漼 
			} else if  (  bank_id.equals("0046")    )  {   //�츮ī��(0046) 
				dam_amt =  car_f_amt - car_dc_amt;
				FineDocListBn.setAmt6		( dam_amt );	
		//	} else if  (   bank_id.equals("0028")    )  {  //�ϳ�������, ����(20170412)  - �������� 100%
		//	    dam_amt =  amt3;
		//	  	FineDocListBn.setAmt6		( dam_amt );	
		//	   	FineDocListBn.setAmt5			(0);   //��漼 	
		 	} else if  (  bank_id.equals("0079")    )  {   //�޸���ĳ��Ż 
			   //      dam_amt =  amt4 + amt5;        
			    dam_amt =  FineDocDb.getDamAmt4( amt4+amt5 ); 
				FineDocListBn.setAmt6		( dam_amt );	
		  	} else if  (  bank_id.equals("0078") ||  bank_id.equals("0080")    ||   bank_id.equals("0087")  ||  bank_id.equals("0103") )  {  //kb ĳ��Ż(00782) , ok����(0080), ȿ��ĳ��Ż(0039),  �����̾�����(0087) -- ������� 10%
			    FineDocListBn.setAmt6		( (amt4 + amt5) /10 );	
		    } else if (   bank_id.equals("0001") ) { //�ϳ�����
		        dam_amt =  FineDocDb.getDamAmtRate(60, amt4); 
          	//	dam_f_amt =  AddUtil.parseFloat(Integer.toString(amt4)) *60/100; 
          	//	dam_amt = (int)  dam_f_amt;
          	//	dam_amt =  AddUtil.th_rnd(dam_amt);	
          		FineDocListBn.setAmt6		( dam_amt );	         
         /*   } else if (	   bank_id.equals("0029") ) { //�������� 0  �������԰��ް��� 50%
			    dam_f_amt = ( AddUtil.parseFloat(Integer.toString(amt3))/ AddUtil.parseFloat("1.1") )* 50/100;
			    dam_amt = (int)  dam_f_amt;
			    dam_amt =  FineDocDb.getDamAmt4(dam_amt+dam_amt , 3); */
          		 // dam_amt =  AddUtil.th_rnd(dam_amt);	
          		//FineDocListBn.setAmt6		( dam_amt );          	           	         
			} else if  (  bank_id.equals("0083")    )  {  //������������ - �������� 70%
			    dam_amt =  FineDocDb.getDamAmt7(amt3);
				FineDocListBn.setAmt6		( dam_amt );	
			    FineDocListBn.setAmt5			(0);   //��漼 	
			} else if  (  bank_id.equals("0115")    )  {  //��ȭ�������� - �������� 30%
			    dam_amt = FineDocDb.getDamAmtRound4(amt3, 30);
				FineDocListBn.setAmt6		( dam_amt );	
			    FineDocListBn.setAmt5			(0);   //��漼 	    
			} else if  (  bank_id.equals("0089") ||  bank_id.equals("0111")  )  {  //�μ��������� , ��ȭ��������(0111) - �������� 10%
			    dam_amt =  FineDocDb.getDamAmt11(amt3);
			   	FineDocListBn.setAmt6		( dam_amt );	
			    FineDocListBn.setAmt5			(0);   //��漼 	    	
			} else if  (  bank_id.equals("0085")  )  {  //kb�������� - �������� 50% , �������� (0029)
			    dam_amt =  FineDocDb.getDamAmt10(amt3);
			  	FineDocListBn.setAmt6		( dam_amt );	
			   	FineDocListBn.setAmt5			(0);   //��漼 			    	    	
	        }  else {   //  bank_id.equals("0039") -202103���� �㺸50%
	            FineDocListBn.setAmt6		( (amt4 + amt5) /2 );
	        } 
	                      			
			FineDocListBn.setPaid_no		(con_mon[i]==null?"0":con_mon[i]);
			FineDocListBn.setReg_id			(user_id);
			
			flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());
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
<script>
<%	if(count == 0){%>
<%		if(flag==true){%>
			alert("���������� ó���Ǿ����ϴ�.");
//			parent.parent.location.reload();	
			parent.window.close();		
<%		}else{%>
			alert("�����߻�!");
<%		}%>
<%	}else{%>
			alert("�̹� ��ϵ� ������ȣ�Դϴ�. Ȯ���Ͻʽÿ�.");
//			parent.document.form1.bank_nm.focus();
<%	}%>
	

			
</script>
</body>
</html>

