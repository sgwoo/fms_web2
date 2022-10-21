<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.fee.*, acar.im_email.*, tax.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String doc_id 	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_nm 	= request.getParameter("gov_nm")==null?"":request.getParameter("gov_nm");
	String gov_zip = request.getParameter("gov_zip")==null?"":request.getParameter("gov_zip");
	String gov_addr = request.getParameter("gov_addr")==null?"":request.getParameter("gov_addr");
	String mng_dept = request.getParameter("mng_dept")==null?"":request.getParameter("mng_dept");
	String title 	= request.getParameter("title")==null?"":request.getParameter("title");
	String title_sub= request.getParameter("title_sub")==null?"":request.getParameter("title_sub");
	String doc_dt	= request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt");
	String email 	= request.getParameter("email")==null?"":request.getParameter("email");
			
	int count = 0;
	boolean flag = true;
	int flag1 = 0;
	
	//���ϳ�
    String cls_dt = AddUtil.getDate(4);
	
	//�ߺ�üũ
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){
		//�ְ��� ���̺�
		FineDocBn.setDoc_id		(doc_id);
		FineDocBn.setDoc_dt		(doc_dt);
		FineDocBn.setGov_id		(request.getParameter("gov_id")==null?"":request.getParameter("gov_id"));
		FineDocBn.setMng_dept	(mng_dept);
		FineDocBn.setReg_id		(user_id);
		FineDocBn.setGov_nm		(gov_nm);
		FineDocBn.setGov_addr	(gov_addr);
		FineDocBn.setGov_zip	(gov_zip);
		FineDocBn.setTitle		(title);
		FineDocBn.setRemarks	(email);  //�����ּҴ� remarks�� ....
		if(title.equals("��Ÿ")){
			FineDocBn.setTitle		(title_sub);
		}
		FineDocBn.setEnd_dt		(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));


		flag = FineDocDb.insertFineDoc(FineDocBn);

		//�̼�ä�Ǹ���Ʈ
		
		int size 			= request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
		String tax_yn 		= request.getParameter("tax_yn")==null?"N":request.getParameter("tax_yn");
		String ch_l_cd[]	= new  String[size];
		int seq = 0;
		
	//	System.out.println("fine doc list size = " + size);
		
		for(int i=0; i<size; i++){
			
			ch_l_cd[i] 		= request.getParameter("ch_l_cd_"+i)==null?"N":request.getParameter("ch_l_cd_"+i);
			
//			System.out.println("ch_l_cd= " + 	ch_l_cd[i] );
			
			if(ch_l_cd[i].equals("Y")){
				String m_id = request.getParameter("m_id_"+i)==null?"":request.getParameter("m_id_"+i);
				String l_cd = request.getParameter("l_cd_"+i)==null?"":request.getParameter("l_cd_"+i);
				String c_id = request.getParameter("c_id_"+i)==null?"":request.getParameter("c_id_"+i);
				
				FineDocListBn.setDoc_id			(doc_id);
				FineDocListBn.setSeq_no			(seq);
				FineDocListBn.setCar_mng_id		(c_id);
				FineDocListBn.setRent_mng_id	(m_id);
				FineDocListBn.setRent_l_cd		(l_cd);
				
				String car_no 	= request.getParameter("car_no_"+i)==null?"":request.getParameter("car_no_"+i);
			
				FineDocListBn.setCar_no			(car_no);
				
				FineDocListBn.setAmt1			(request.getParameter("amt1_"+i) ==null?0: AddUtil.parseDigit(request.getParameter("amt1_"+i)));
				FineDocListBn.setAmt2			(request.getParameter("amt2_"+i) ==null?0: AddUtil.parseDigit(request.getParameter("amt2_"+i)));
				FineDocListBn.setAmt3			(request.getParameter("amt3_"+i) ==null?0: AddUtil.parseDigit(request.getParameter("amt3_"+i)));
				FineDocListBn.setAmt4			(request.getParameter("amt4_"+i) ==null?0: AddUtil.parseDigit(request.getParameter("amt4_"+i)));
				FineDocListBn.setAmt5			(request.getParameter("amt5_"+i) ==null?0: AddUtil.parseDigit(request.getParameter("amt5_"+i)));
				FineDocListBn.setAmt6			(request.getParameter("amt6_"+i) ==null?0: AddUtil.parseDigit(request.getParameter("amt6_"+i)));
				FineDocListBn.setReg_id			(user_id);
				
				
				//�Ǻ� �뿩�� ������ ���
				Hashtable fee_stat = af_db.getFeeScdStatNew(m_id, l_cd, doc_dt, "", "");
					
				//�뿩�� ��ü����
				int amt_i = 0;
				long amt3[]   = new long[9];
				
				//������� �� �����ݳ� ���� �뺸 ����
				int lamt_1   = 0;
				int lamt_2   = 0;
				int lamt_3   = 0;
				int lamt_4   = 0;
				int lamt_5   = 0;
				int lamt_6   = 0;
				int lamt_7   = 0;
			
				int grt_amt   = 0;
				int pp_s_amt   = 0;
				int ifee_s_amt   = 0;
				int fee_s_amt   = 0;
				
				float f_amt1 = 0;
				float f_amt2 = 0;
				float f_amt3 = 0;
				float f_amt4 = 0;
				
			   /*			
				for(int j=0; j<9; j++){
						amt3[j]  += AddUtil.parseLong(String.valueOf(ht3.get("EST_AMT"+j)));
				}
				
				if (amt3[2]- amt3[8]  < 0  ) {
				   amt_i = 0;
				} else {
				   amt_i = (int) (amt3[2]-amt3[8]);
				}
				*/
								
				amt_i = AddUtil.parseInt(String.valueOf(fee_stat.get("DT"))) - AddUtil.parseInt(String.valueOf(fee_stat.get("DT2"))) ;
				
			//	System.out.println("amt3_2=" + amt3[2] + " amt3_8=" +  amt3[8] );
				
				FineDocListBn.setAmt7			(amt_i);  //��ü����
				
				
				float ifee_tm = 0;
				int i_ifee_tm = 0;
				
				int pay_tm = 0;
				float ifee_ex_amt = 0;
				int	rifee_s_amt = 0;
				int	nfee_ex_amt = 0;
				float pded_s_amt =0;
				float tpded_s_amt = 0;
				int n_tpded_s_amt = 0;
				int rfee_s_amt = 0;
				float f_lamt_2_vat= 0;
				int lamt_2_vat= 0;
				
				int ifee_mon = 0;
				int ifee_day = 0;
				
				int r_mon = 0;
				int r_day = 0;
				
					
				int s_mon = 0;
				int s_day = 0;
				
				int rcon_mon = 0;
				int rcon_day = 0;
				
				int nfee_mon = 0;
				int nfee_day = 0;
				float nfee_amt = 0;
				int n_nfee_amt = 0;
								
				int  mfee_amt = 0;
				int i_mfee_amt = 0;
				
				int pp_amt = 0;
				float trfee_amt = 0;
				
				int	 nfee_s_amt = 0;
				
				//�ܿ��뿩�Ⱓ ���ϱ� (function ���ó�� ) 	
				String r_ymd[] = new String[3]; 
				String rrcon_mon = "";
				String rrcon_day  = "";
								
				String rr_ymd = "";
								
				if ( title.equals("������� �� �����ݳ� �뺸")) {
				 				
				//�⺻����  - ��������� ���� �۾�
					Hashtable base = as_db.getSettleBase(m_id, l_cd, AddUtil.replace(doc_dt,"-",""), "");
					
					pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"));
			//		pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"))+AddUtil.parseInt((String)base.get("IFEE_S_AMT"));
								
					 //�����ݾ�
					grt_amt =	AddUtil.parseInt((String)base.get("GRT_AMT")); //������
					pp_s_amt =	AddUtil.parseInt((String)base.get("PP_S_AMT")); //������
					ifee_s_amt = AddUtil.parseInt((String)base.get("IFEE_S_AMT")); //���ô뿩��
					fee_s_amt = AddUtil.parseInt((String)base.get("FEE_S_AMT")); //���뿩��
					
					r_mon = AddUtil.parseInt((String)base.get("R_MON")); //����
					r_day = AddUtil.parseInt((String)base.get("R_DAY")); //�����
									
					nfee_mon = AddUtil.parseInt((String)base.get("S_MON")); //�̳���
					nfee_day = AddUtil.parseInt((String)base.get("S_DAY")); //�̳���
					
				//	rcon_mon = AddUtil.parseInt((String)base.get("N_MON")); //�ܿ���
				//	rcon_day = AddUtil.parseInt((String)base.get("N_DAY")); //�ܿ���
				
				    rr_ymd =  String.valueOf(base.get("R2_YMD"));
				
				   StringTokenizer token1 = new StringTokenizer(rr_ymd,"^");				
					while(token1.hasMoreTokens()) {			
							r_ymd[0] = token1.nextToken().trim();	//��
							r_ymd[1] = token1.nextToken().trim();	//�� 
							r_ymd[2] = token1.nextToken().trim();	//�� 
					}	
		
					//�������� ���Ⱓ ������ ���	 
					if  (AddUtil.parseInt(r_ymd[0]) < 0 ||  AddUtil.parseInt(r_ymd[1]) < 0 || AddUtil.parseInt(r_ymd[2]) < 0 ) {		
					   rrcon_mon =  "";
				 	   rrcon_day =  "";
					} else {
					   rrcon_mon =  Integer.toString( AddUtil.parseInt(r_ymd[0])*12  + AddUtil.parseInt(r_ymd[1]));
					   rrcon_day =   Integer.toString(  AddUtil.parseInt(r_ymd[2])) ;  	
				   }     
   				
   					rcon_mon = AddUtil.parseInt(rrcon_mon);
   					rcon_day = AddUtil.parseInt(rrcon_day);
   			
					if(r_day != 0){
						if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <=   AddUtil.parseInt(cls_dt) ) { //��������
														
						} else {  //�뿩�������� ���ڰ� �ִ���.. �ܿ��뿩�Ⱓ��� ����2010-07-06  - 30�ϱ������� ���
							  if (	r_day + rcon_day == 31 ) {
							    	rcon_day		= 30-r_day;	
							  }else if(r_day + rcon_day < 30){
								  rcon_day	= 30-r_day;
							  }
						}
												
					}			
				
					if ( ifee_s_amt > 0 ) { //���ô뿩��
						ifee_tm =  ifee_s_amt / fee_s_amt; //  ������ / ���뿩��
						i_ifee_tm = (int) ifee_tm; 
						pay_tm =  AddUtil.parseInt((String)base.get("CON_MON"))- i_ifee_tm;
						
						if ( r_mon > pay_tm || (r_mon == pay_tm && r_day > 0) ){
							ifee_mon 	= r_mon - pay_tm;
							ifee_day 	= r_day ;
						}		
						//				(���뿩�� * ���� ������ ) + (���뿩�� / 30 * �Ϻ� ������)
						ifee_ex_amt	= (fee_s_amt*ifee_mon) + ( fee_s_amt/30 *ifee_day );
						nfee_ex_amt = (int)  ifee_ex_amt;
						rifee_s_amt	=  ifee_s_amt - nfee_ex_amt;						
					}
		
					if ( pp_s_amt > 0 ) { //������	
						pded_s_amt =  pp_s_amt / AddUtil.parseInt((String)base.get("CON_MON"));
						tpded_s_amt = pded_s_amt*( r_mon + AddUtil.parseFloat(Integer.toString(r_day))/30 ) ;
						n_tpded_s_amt =	(int)tpded_s_amt;
						rfee_s_amt 	= pp_s_amt - n_tpded_s_amt;
					}					
						
					
					if ( rifee_s_amt < 0   ) {	 //�ܿ����ô뿩�ᰡ ���� ���										
						rifee_s_amt	= 0;   //ȯ�ұݾ�
					}
					
					if ( rfee_s_amt < 0) {	 //��������  ���� ���										
						rfee_s_amt	= 0;   //ȯ�ұݾ�
					}
					
					lamt_1	= grt_amt + rifee_s_amt + rfee_s_amt;   //ȯ�ұݾ� (������))							
					
					//�������� �ִٴ� ���� 
					if(ifee_s_amt == 0 ) {
						  if  (  AddUtil.parseInt((String)base.get("DI_AMT")) > 0  ) {	
									 if ( AddUtil.parseInt((String)base.get("S_MON"))  - 1  >= 0 ) {
										 nfee_mon 	= 	AddUtil.parseInt((String)base.get("S_MON")) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ����      
									 } 		
					   	    	 	
									 if ( AddUtil.parseInt((String)base.get("S_DAY")) > 1 &&  AddUtil.parseInt((String)base.get("S_MON"))  < 1 ) {
								   		  	if ( AddUtil.parseInt((String)base.get("HS_MON")) < 1  &&  AddUtil.parseInt((String)base.get("HS_DAY")) > 1 ) {  // �ܾ� �����쿡 �������� ���ԵǴ� ���
								   		  		nfee_day  = AddUtil.parseInt((String)base.get("HS_DAY")); 
											 }
								   	 }
									 
					   	    	      //������ �ִٸ� 
					   	    	     /* 
					   	    	     if (  AddUtil.parseInt((String)base.get("EX_S_AMT")) > 0 ){
					   	    	     	nfee_day = 0;
					   	    	     } else {	
					   	    	     	 if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <   AddUtil.parseInt(cls_dt) ) { //��������	  	    	      
						   	    	  	
						   	    	  		 if  ( AddUtil.parseInt((String)base.get("NFEE_S_AMT"))  == 0 ) {
						   	    	  	 		nfee_day 	= 	r_day;
						   	    	  	 	 }	
						   	    	  	 }  	
						   	    	 }  */
					  	  }  
					
					}   					
				
					//�̳��뿩��												 
				    nfee_amt =  fee_s_amt * ( nfee_mon + (AddUtil.parseFloat(Integer.toString(nfee_day))/30) );
				 /*
				    System.out.println("fee_s_amt=" + fee_s_amt );
				    System.out.println("nfee_mon=" + nfee_mon );
				    System.out.println("nfee_day=" + nfee_day );
				    System.out.println("nfee_amt=" + nfee_amt );
				 */	
			
					// ���ô뿩�� �ִ� ��쿡 ����. (�������� �뿩�Ⱓ�� ����� ��쿡 ���� )
				  	if ( ifee_s_amt > 0 ) { //���ô뿩��
				 	   				
				   		if ( rifee_s_amt < 0) {  //���ô뿩�Ḧ �� ������ ���
				   	   								
					   	    if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <   AddUtil.parseInt((String)base.get("USE_S_DT")) ) { //�������� �뿩�� �������� ������ ��� 
					   	       if ( AddUtil.parseInt((String)base.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base.get("DLY_S_DT")) ) { //������ ������ �̳����� �ִ� ���  
					   	      //     alert(" ���ô뿩�� ����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
					   	       	   nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_s_amt; 		
					   	        }else {
					   	      //     alert(" ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
					   	       	  nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ); 		
					   	       }
					   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
					   	       if ( AddUtil.parseInt((String)base.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base.get("DLY_S_DT")) ) { //������ ������ �̳����� �ִ� ���
					   	     //  alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
					   	           nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_s_amt; 		// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
					   	      }else {
					   	       //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
					   	       	   nfee_amt	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - rifee_s_amt ; 
					   	      	
					   	       }
					   	   }
					    } else {  //���ô뿩�ᰡ �����ִ� ���
					         if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <   AddUtil.parseInt((String)base.get("USE_S_DT")) ) { //�������� �뿩�� �������� ������ ��� 
					   	        if ( AddUtil.parseInt((String)base.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base.get("DLY_S_DT")) ) { //������ ������ �̳����� �ִ� ���  
					   	       	//   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
					   	       	   nfee_amt			= fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_ex_amt;	// �ѹ̳��ῡ�� - ���ô뿩�� ����
					   	       }else {
					   	        //   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
					   	       	    nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ); 	
					   	       }
					   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
					   	       if ( AddUtil.parseInt((String)base.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base.get("DLY_S_DT")) ) { //������ ������ �̳����� �ִ� ���
					   	       //    alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
					   	           nfee_amt 	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_ex_amt;	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
					   	      }else {
					   	        //   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����̾��� ���");
					   	       	   nfee_amt 	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) ;
					   	
					   	       }
					   	   }
					    } 
					      
				   	} 
				   	 	
				//	f_amt2	=	AddUtil.parseInt((String)base.get("DI_AMT"))  + nfee_amt;  //�뿩��		    	
		   		//	f_amt2	=	AddUtil.parseInt((String)base.get("DI_AMT")) - AddUtil.parseInt((String)base.get("EX_S_AMT")) + nfee_amt;  //�뿩��
		   		
		   			f_amt2	=	FineDocListBn.getAmt2();  //�뿩��
		   				   			
			 		lamt_2 = ( int ) f_amt2;
			 		
					//�̳��뿩�� --������ �ִ� ��� �뿩�� ȯ��							
				//	if ( pp_s_amt > 0 ) {
						mfee_amt	=   ( pp_amt+AddUtil.parseInt((String)base.get("TFEE_S_AMT")))  / AddUtil.parseInt((String)base.get("CON_MON"));
				//	}
					
					//�ߵ����� �����		 - �뿩���� ���Ĵ� ����ݾ���.			  		  			  				  		
			  		f_amt3 =	rcon_mon + (AddUtil.parseFloat( Integer.toString(rcon_day) ) / 30 );
					
			  		/*
			  		System.out.println("rcon_day=" + rcon_day);
			  		System.out.println("aaaa= " + AddUtil.parseFloat( Integer.toString(rcon_day) ) / 30 );
			  		System.out.println("bbbb= " + AddUtil.parseFloatCipher(AddUtil.parseFloat( Integer.toString(rcon_day) ) / 30 , 3));
			  		*/
			  		 				  		  
					 trfee_amt   	= mfee_amt*f_amt3 ; //�ܿ��Ⱓ �뿩�� �Ѿ� :������ �ִ� ���
					 
					 
			  	//	f_amt3 =	AddUtil.parseFloat((String)base.get("N_MON")) +( AddUtil.parseFloat((String)base.get("N_DAY")) / 30 ); 
			  	
			  		if (trfee_amt > 0) {
		   				f_amt4	=	 trfee_amt   *  ( AddUtil.parseFloat((String)base.get("CLS_R_PER")) /100) ;  //�ܿ��뿩��		   			
		   				//System.out.println("1  f_amt3=" + f_amt3 + ":f_am4=" + f_amt4);		  				  		
		   			} else {
		   				f_amt4	=	(f_amt3 * fee_s_amt) *  ( AddUtil.parseFloat((String)base.get("CLS_R_PER")) /100) ;  //�ܿ��뿩��		   			
		   				//System.out.println(" 2  f_amt3=" + f_amt3 + ":f_am4=" + f_amt4);		  				  		
		   			}
		   			lamt_5 = ( int ) f_amt4;
			  			
			  //	System.out.println("n_day=" + AddUtil.parseFloat((String)base.get("N_DAY"))  );	  				  		
			 	//	System.out.println("f_amt3=" + f_amt3 + ":f_am4=" + f_amt4);		  				  				  		
			  		
			  		lamt_3 =	AddUtil.parseInt((String)base.get("FINE_AMT")) ; //���·�
			  		lamt_4 =	AddUtil.parseInt((String)base.get("CAR_JA_AMT")); //��å��
			  		lamt_7 =	AddUtil.parseInt((String)base.get("DLY_AMT"));  //��ü����
			  			
			  		// vat (�뿩�ῡ �ش�)			  		
			  		if ( rifee_s_amt < 0 ) {
			  			f_lamt_2_vat = (lamt_2 - rfee_s_amt) * AddUtil.parseFloat("0.1") ;
			  		} else {
			  			f_lamt_2_vat = (lamt_2 - rifee_s_amt - rfee_s_amt) * AddUtil.parseFloat("0.1") ;
			  		}
			  		
			  		lamt_2_vat = ( int ) f_lamt_2_vat;
			  		
			  	//	System.out.println("f_lamt_2_vat=" + f_lamt_2_vat + ":lamt_2_vat=" + lamt_2_vat);	
						
						  					  		
//			  		lamt_6 = 	(lamt_1 - lamt_2 - lamt_3 - lamt_4 - lamt_5 - lamt_7 - lamt_2_vat )*(-1);
			  		lamt_6 = 	(lamt_2 + lamt_3 + lamt_4 + lamt_5 + lamt_7 + lamt_2_vat )- lamt_1; //
			  					
				    FineDocListBn.setAmt1			(lamt_1);  //������
				  	FineDocListBn.setAmt2			(lamt_2);  //�뿩��
					FineDocListBn.setAmt3			(lamt_3);  //���·�
					FineDocListBn.setAmt4			(lamt_4);  //��å��
					FineDocListBn.setAmt5			(lamt_5);  //�ߵ����������
					FineDocListBn.setAmt6			(lamt_6);  //��������� ( �Ǵ� �հ�)
					FineDocListBn.setAmt7			(lamt_7); //��ü����
					FineDocListBn.setVar1			(Integer.toString(grt_amt)); //
											
				} // ������� �� �����ݳ� �뺸
														
				seq++;
				flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());
				
				//���ݰ�꼭 ��������
				if(tax_yn.equals("Y")){
				
					//���ݰ�꼭 �����Ͻ������������� ����Ʈ
					Vector vt = af_db.getFeeScdStopList(m_id, l_cd);
					int vt_size = vt.size();
					
					FeeScdStopBean fee_scd = new FeeScdStopBean();
					
					fee_scd.setDoc_id		(doc_id);
					fee_scd.setRent_mng_id	(m_id);
					fee_scd.setRent_l_cd	(l_cd);
					fee_scd.setStop_st		(request.getParameter("stop_st")==null?"":request.getParameter("stop_st"));//��������
					fee_scd.setStop_s_dt	(request.getParameter("stop_s_dt")==null?"":request.getParameter("stop_s_dt"));//�����Ⱓ
					fee_scd.setStop_e_dt	(request.getParameter("stop_e_dt")==null?"":request.getParameter("stop_e_dt"));//�����Ⱓ
					
					String stop_cau 	= request.getParameter("stop_cau")==null?"":request.getParameter("stop_cau");
			
					fee_scd.setStop_cau		(stop_cau);//��������
					
					fee_scd.setStop_doc_dt	(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));//��������߽�����
					
								
					fee_scd.setReg_id		(user_id);
					fee_scd.setSeq			(String.valueOf(vt_size+1));
					if(!af_db.insertFeeScdStop(fee_scd)) flag1 += 1;
				}
				
			}
		}
	
		
	//�ȳ�����-------------------------------------------------------------------------------------------	
	
	String mail_yn 	= request.getParameter("mail_yn")==null?"N":request.getParameter("mail_yn");
	
	if(mail_yn.equals("Y")){
		
		String subject 		= gov_nm+"��, (��)�Ƹ���ī ä�� �ְ� �ȳ������Դϴ�.";
		String msg 			= gov_nm+"��, (��)�Ƹ���ī ä�� �ְ� �ȳ������Դϴ�.";
		String sendname 	= "(��)�Ƹ���ī";
		String sendphone 	= "02-392-4243";
		int seqidx			= 0;

		if(!email.equals("")){
			//	1. d-mail ���-------------------------------
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(subject);
			d_bean.setSql				("SSV:"+email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
			d_bean.setMailto			("\""+gov_nm+"\"<"+email.trim()+">");
			d_bean.setReplyto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
			d_bean.setErrosto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				("credit");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin����
			d_bean.setG_idx				(1);//admin����
			d_bean.setMsgflag     		(0);
		
	 	    if ( title.equals("������� �� �����ְ�") ) {	
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel.jsp?doc_id="+doc_id);
		    } else if ( title.equals("������� �� �����ݳ� �뺸")) {
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel_re.jsp?doc_id="+doc_id);
		    }else if ( title.equals("�����뺸 �� ��������� ���԰���")) {
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel_2.jsp?doc_id="+doc_id);
		    }
					
			seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", ""); // ����ŸȮ���� �߼��ؾ� ��. 

		}

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
			parent.parent.location.reload();			
<%		}else{%>
			alert("�����߻�!");
<%		}%>
<%	}else{%>
			alert("�̹� ��ϵ� ������ȣ�Դϴ�. Ȯ���Ͻʽÿ�.");
			parent.document.form1.gov_nm.focus();
<%	}%>
</script>
</body>
</html>

