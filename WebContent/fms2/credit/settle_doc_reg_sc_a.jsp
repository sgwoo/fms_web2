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
	String user_id	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
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
	
	//당일날
    String cls_dt = AddUtil.getDate(4);
	
	//중복체크
	count = FineDocDb.getDocIdChk(doc_id);
	
	if(count == 0){
		//최고장 테이블
		FineDocBn.setDoc_id		(doc_id);
		FineDocBn.setDoc_dt		(doc_dt);
		FineDocBn.setGov_id		(request.getParameter("gov_id")==null?"":request.getParameter("gov_id"));
		FineDocBn.setMng_dept	(mng_dept);
		FineDocBn.setReg_id		(user_id);
		FineDocBn.setGov_nm		(gov_nm);
		FineDocBn.setGov_addr	(gov_addr);
		FineDocBn.setGov_zip	(gov_zip);
		FineDocBn.setTitle		(title);
		FineDocBn.setRemarks	(email);  //메일주소는 remarks로 ....
		if(title.equals("기타")){
			FineDocBn.setTitle		(title_sub);
		}
		FineDocBn.setEnd_dt		(request.getParameter("end_dt")==null?"":request.getParameter("end_dt"));


		flag = FineDocDb.insertFineDoc(FineDocBn);

		//미수채권리스트
		
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
				
				
				//건별 대여료 스케줄 통계
				Hashtable fee_stat = af_db.getFeeScdStatNew(m_id, l_cd, doc_dt, "", "");
					
				//대여료 연체이자
				int amt_i = 0;
				long amt3[]   = new long[9];
				
				//계약해지 및 차량반납 관련 통보 변수
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
				
				FineDocListBn.setAmt7			(amt_i);  //연체이자
				
				
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
				
				//잔여대여기간 구하기 (function 사용처리 ) 	
				String r_ymd[] = new String[3]; 
				String rrcon_mon = "";
				String rrcon_day  = "";
								
				String rr_ymd = "";
								
				if ( title.equals("계약해지 및 차량반납 통보")) {
				 				
				//기본정보  - 해지정산금 관련 작업
					Hashtable base = as_db.getSettleBase(m_id, l_cd, AddUtil.replace(doc_dt,"-",""), "");
					
					pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"));
			//		pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"))+AddUtil.parseInt((String)base.get("IFEE_S_AMT"));
								
					 //선납금액
					grt_amt =	AddUtil.parseInt((String)base.get("GRT_AMT")); //보증금
					pp_s_amt =	AddUtil.parseInt((String)base.get("PP_S_AMT")); //선납금
					ifee_s_amt = AddUtil.parseInt((String)base.get("IFEE_S_AMT")); //개시대여료
					fee_s_amt = AddUtil.parseInt((String)base.get("FEE_S_AMT")); //월대여료
					
					r_mon = AddUtil.parseInt((String)base.get("R_MON")); //사용월
					r_day = AddUtil.parseInt((String)base.get("R_DAY")); //사용일
									
					nfee_mon = AddUtil.parseInt((String)base.get("S_MON")); //미납월
					nfee_day = AddUtil.parseInt((String)base.get("S_DAY")); //미납일
					
				//	rcon_mon = AddUtil.parseInt((String)base.get("N_MON")); //잔여월
				//	rcon_day = AddUtil.parseInt((String)base.get("N_DAY")); //잔여일
				
				    rr_ymd =  String.valueOf(base.get("R2_YMD"));
				
				   StringTokenizer token1 = new StringTokenizer(rr_ymd,"^");				
					while(token1.hasMoreTokens()) {			
							r_ymd[0] = token1.nextToken().trim();	//년
							r_ymd[1] = token1.nextToken().trim();	//월 
							r_ymd[2] = token1.nextToken().trim();	//일 
					}	
		
					//해지일이 계약기간 이후인 경우	 
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
						if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <=   AddUtil.parseInt(cls_dt) ) { //만기이후
														
						} else {  //대여개월수가 일자가 있더라.. 잔여대여기간계산 수정2010-07-06  - 30일기준으로 계산
							  if (	r_day + rcon_day == 31 ) {
							    	rcon_day		= 30-r_day;	
							  }else if(r_day + rcon_day < 30){
								  rcon_day	= 30-r_day;
							  }
						}
												
					}			
				
					if ( ifee_s_amt > 0 ) { //개시대여료
						ifee_tm =  ifee_s_amt / fee_s_amt; //  선수금 / 월대여료
						i_ifee_tm = (int) ifee_tm; 
						pay_tm =  AddUtil.parseInt((String)base.get("CON_MON"))- i_ifee_tm;
						
						if ( r_mon > pay_tm || (r_mon == pay_tm && r_day > 0) ){
							ifee_mon 	= r_mon - pay_tm;
							ifee_day 	= r_day ;
						}		
						//				(월대여료 * 월별 선수금 ) + (월대여료 / 30 * 일별 선수금)
						ifee_ex_amt	= (fee_s_amt*ifee_mon) + ( fee_s_amt/30 *ifee_day );
						nfee_ex_amt = (int)  ifee_ex_amt;
						rifee_s_amt	=  ifee_s_amt - nfee_ex_amt;						
					}
		
					if ( pp_s_amt > 0 ) { //선납금	
						pded_s_amt =  pp_s_amt / AddUtil.parseInt((String)base.get("CON_MON"));
						tpded_s_amt = pded_s_amt*( r_mon + AddUtil.parseFloat(Integer.toString(r_day))/30 ) ;
						n_tpded_s_amt =	(int)tpded_s_amt;
						rfee_s_amt 	= pp_s_amt - n_tpded_s_amt;
					}					
						
					
					if ( rifee_s_amt < 0   ) {	 //잔여개시대여료가 없는 경우										
						rifee_s_amt	= 0;   //환불금액
					}
					
					if ( rfee_s_amt < 0) {	 //선납금이  없는 경우										
						rfee_s_amt	= 0;   //환불금액
					}
					
					lamt_1	= grt_amt + rifee_s_amt + rfee_s_amt;   //환불금액 (선수금))							
					
					//스케쥴이 있다는 가정 
					if(ifee_s_amt == 0 ) {
						  if  (  AddUtil.parseInt((String)base.get("DI_AMT")) > 0  ) {	
									 if ( AddUtil.parseInt((String)base.get("S_MON"))  - 1  >= 0 ) {
										 nfee_mon 	= 	AddUtil.parseInt((String)base.get("S_MON")) - 1;  // 잔액이 발생되었기에 1달 빼줌      
									 } 		
					   	    	 	
									 if ( AddUtil.parseInt((String)base.get("S_DAY")) > 1 &&  AddUtil.parseInt((String)base.get("S_MON"))  < 1 ) {
								   		  	if ( AddUtil.parseInt((String)base.get("HS_MON")) < 1  &&  AddUtil.parseInt((String)base.get("HS_DAY")) > 1 ) {  // 잔액 스케쥴에 해지일이 포함되는 경우
								   		  		nfee_day  = AddUtil.parseInt((String)base.get("HS_DAY")); 
											 }
								   	 }
									 
					   	    	      //선납이 있다면 
					   	    	     /* 
					   	    	     if (  AddUtil.parseInt((String)base.get("EX_S_AMT")) > 0 ){
					   	    	     	nfee_day = 0;
					   	    	     } else {	
					   	    	     	 if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <   AddUtil.parseInt(cls_dt) ) { //만기이후	  	    	      
						   	    	  	
						   	    	  		 if  ( AddUtil.parseInt((String)base.get("NFEE_S_AMT"))  == 0 ) {
						   	    	  	 		nfee_day 	= 	r_day;
						   	    	  	 	 }	
						   	    	  	 }  	
						   	    	 }  */
					  	  }  
					
					}   					
				
					//미납대여료												 
				    nfee_amt =  fee_s_amt * ( nfee_mon + (AddUtil.parseFloat(Integer.toString(nfee_day))/30) );
				 /*
				    System.out.println("fee_s_amt=" + fee_s_amt );
				    System.out.println("nfee_mon=" + nfee_mon );
				    System.out.println("nfee_day=" + nfee_day );
				    System.out.println("nfee_amt=" + nfee_amt );
				 */	
			
					// 개시대여료 있는 경우에 한함. (해지일이 대여기간을 경과한 경우에 한함 )
				  	if ( ifee_s_amt > 0 ) { //개시대여료
				 	   				
				   		if ( rifee_s_amt < 0) {  //개시대여료를 다 소진한 경우
				   	   								
					   	    if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <   AddUtil.parseInt((String)base.get("USE_S_DT")) ) { //만기이후 대여료 스케쥴이 생성된 경우 
					   	       if ( AddUtil.parseInt((String)base.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base.get("DLY_S_DT")) ) { //만기일 이전에 미납분이 있는 경우  
					   	      //     alert(" 개시대여료 소진, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
					   	       	   nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_s_amt; 		
					   	        }else {
					   	      //     alert(" 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");
					   	       	  nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ); 		
					   	       }
					   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
					   	       if ( AddUtil.parseInt((String)base.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base.get("DLY_S_DT")) ) { //만기일 이전에 미납분이 있는 경우
					   	     //  alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
					   	           nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_s_amt; 		// 총미납료에서 - 개시대여료 공제   	   
					   	      }else {
					   	       //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
					   	       	   nfee_amt	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - rifee_s_amt ; 
					   	      	
					   	       }
					   	   }
					    } else {  //개시대여료가 남아있는 경우
					         if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <   AddUtil.parseInt((String)base.get("USE_S_DT")) ) { //만기이후 대여료 스케쥴이 생성된 경우 
					   	        if ( AddUtil.parseInt((String)base.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base.get("DLY_S_DT")) ) { //만기일 이전에 미납분이 있는 경우  
					   	       	//   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
					   	       	   nfee_amt			= fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_ex_amt;	// 총미납료에서 - 개시대여료 공제
					   	       }else {
					   	        //   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");
					   	       	    nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ); 	
					   	       }
					   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
					   	       if ( AddUtil.parseInt((String)base.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base.get("DLY_S_DT")) ) { //만기일 이전에 미납분이 있는 경우
					   	       //    alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
					   	           nfee_amt 	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_ex_amt;	// 총미납료에서 - 개시대여료 공제   	   
					   	      }else {
					   	        //   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이없는 경우");
					   	       	   nfee_amt 	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) ;
					   	
					   	       }
					   	   }
					    } 
					      
				   	} 
				   	 	
				//	f_amt2	=	AddUtil.parseInt((String)base.get("DI_AMT"))  + nfee_amt;  //대여료		    	
		   		//	f_amt2	=	AddUtil.parseInt((String)base.get("DI_AMT")) - AddUtil.parseInt((String)base.get("EX_S_AMT")) + nfee_amt;  //대여료
		   		
		   			f_amt2	=	FineDocListBn.getAmt2();  //대여료
		   				   			
			 		lamt_2 = ( int ) f_amt2;
			 		
					//미납대여료 --선납이 있는 경우 대여료 환산							
				//	if ( pp_s_amt > 0 ) {
						mfee_amt	=   ( pp_amt+AddUtil.parseInt((String)base.get("TFEE_S_AMT")))  / AddUtil.parseInt((String)base.get("CON_MON"));
				//	}
					
					//중도해지 위약금		 - 대여만기 이후는 위약금없음.			  		  			  				  		
			  		f_amt3 =	rcon_mon + (AddUtil.parseFloat( Integer.toString(rcon_day) ) / 30 );
					
			  		/*
			  		System.out.println("rcon_day=" + rcon_day);
			  		System.out.println("aaaa= " + AddUtil.parseFloat( Integer.toString(rcon_day) ) / 30 );
			  		System.out.println("bbbb= " + AddUtil.parseFloatCipher(AddUtil.parseFloat( Integer.toString(rcon_day) ) / 30 , 3));
			  		*/
			  		 				  		  
					 trfee_amt   	= mfee_amt*f_amt3 ; //잔여기간 대여료 총액 :선납이 있는 경우
					 
					 
			  	//	f_amt3 =	AddUtil.parseFloat((String)base.get("N_MON")) +( AddUtil.parseFloat((String)base.get("N_DAY")) / 30 ); 
			  	
			  		if (trfee_amt > 0) {
		   				f_amt4	=	 trfee_amt   *  ( AddUtil.parseFloat((String)base.get("CLS_R_PER")) /100) ;  //잔여대여료		   			
		   				//System.out.println("1  f_amt3=" + f_amt3 + ":f_am4=" + f_amt4);		  				  		
		   			} else {
		   				f_amt4	=	(f_amt3 * fee_s_amt) *  ( AddUtil.parseFloat((String)base.get("CLS_R_PER")) /100) ;  //잔여대여료		   			
		   				//System.out.println(" 2  f_amt3=" + f_amt3 + ":f_am4=" + f_amt4);		  				  		
		   			}
		   			lamt_5 = ( int ) f_amt4;
			  			
			  //	System.out.println("n_day=" + AddUtil.parseFloat((String)base.get("N_DAY"))  );	  				  		
			 	//	System.out.println("f_amt3=" + f_amt3 + ":f_am4=" + f_amt4);		  				  				  		
			  		
			  		lamt_3 =	AddUtil.parseInt((String)base.get("FINE_AMT")) ; //과태료
			  		lamt_4 =	AddUtil.parseInt((String)base.get("CAR_JA_AMT")); //면책금
			  		lamt_7 =	AddUtil.parseInt((String)base.get("DLY_AMT"));  //연체이자
			  			
			  		// vat (대여료에 해당)			  		
			  		if ( rifee_s_amt < 0 ) {
			  			f_lamt_2_vat = (lamt_2 - rfee_s_amt) * AddUtil.parseFloat("0.1") ;
			  		} else {
			  			f_lamt_2_vat = (lamt_2 - rifee_s_amt - rfee_s_amt) * AddUtil.parseFloat("0.1") ;
			  		}
			  		
			  		lamt_2_vat = ( int ) f_lamt_2_vat;
			  		
			  	//	System.out.println("f_lamt_2_vat=" + f_lamt_2_vat + ":lamt_2_vat=" + lamt_2_vat);	
						
						  					  		
//			  		lamt_6 = 	(lamt_1 - lamt_2 - lamt_3 - lamt_4 - lamt_5 - lamt_7 - lamt_2_vat )*(-1);
			  		lamt_6 = 	(lamt_2 + lamt_3 + lamt_4 + lamt_5 + lamt_7 + lamt_2_vat )- lamt_1; //
			  					
				    FineDocListBn.setAmt1			(lamt_1);  //선수금
				  	FineDocListBn.setAmt2			(lamt_2);  //대여료
					FineDocListBn.setAmt3			(lamt_3);  //과태료
					FineDocListBn.setAmt4			(lamt_4);  //면책금
					FineDocListBn.setAmt5			(lamt_5);  //중도해지위약금
					FineDocListBn.setAmt6			(lamt_6);  //해지정산금 ( 또는 합계)
					FineDocListBn.setAmt7			(lamt_7); //연체이자
					FineDocListBn.setVar1			(Integer.toString(grt_amt)); //
											
				} // 계약해지 및 차량반납 통보
														
				seq++;
				flag = FineDocDb.insertFineDocList(FineDocListBn, FineDocBn.getDoc_dt());
				
				//세금계산서 발행중지
				if(tax_yn.equals("Y")){
				
					//세금계산서 발행일시중지관리내역 리스트
					Vector vt = af_db.getFeeScdStopList(m_id, l_cd);
					int vt_size = vt.size();
					
					FeeScdStopBean fee_scd = new FeeScdStopBean();
					
					fee_scd.setDoc_id		(doc_id);
					fee_scd.setRent_mng_id	(m_id);
					fee_scd.setRent_l_cd	(l_cd);
					fee_scd.setStop_st		(request.getParameter("stop_st")==null?"":request.getParameter("stop_st"));//중지구분
					fee_scd.setStop_s_dt	(request.getParameter("stop_s_dt")==null?"":request.getParameter("stop_s_dt"));//중지기간
					fee_scd.setStop_e_dt	(request.getParameter("stop_e_dt")==null?"":request.getParameter("stop_e_dt"));//중지기간
					
					String stop_cau 	= request.getParameter("stop_cau")==null?"":request.getParameter("stop_cau");
			
					fee_scd.setStop_cau		(stop_cau);//중지사유
					
					fee_scd.setStop_doc_dt	(request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt"));//내용증명발신일자
					
								
					fee_scd.setReg_id		(user_id);
					fee_scd.setSeq			(String.valueOf(vt_size+1));
					if(!af_db.insertFeeScdStop(fee_scd)) flag1 += 1;
				}
				
			}
		}
	
		
	//안내메일-------------------------------------------------------------------------------------------	
	
	String mail_yn 	= request.getParameter("mail_yn")==null?"N":request.getParameter("mail_yn");
	
	if(mail_yn.equals("Y")){
		
		String subject 		= gov_nm+"님, (주)아마존카 채권 최고서 안내메일입니다.";
		String msg 			= gov_nm+"님, (주)아마존카 채권 최고서 안내메일입니다.";
		String sendname 	= "(주)아마존카";
		String sendphone 	= "02-392-4243";
		int seqidx			= 0;

		if(!email.equals("")){
			//	1. d-mail 등록-------------------------------
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(subject);
			d_bean.setSql				("SSV:"+email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setMailto			("\""+gov_nm+"\"<"+email.trim()+">");
			d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
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
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(1);//admin계정
			d_bean.setMsgflag     		(0);
		
	 	    if ( title.equals("계약해지 및 납부최고") ) {	
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel.jsp?doc_id="+doc_id);
		    } else if ( title.equals("계약해지 및 차량반납 통보")) {
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel_re.jsp?doc_id="+doc_id);
		    }else if ( title.equals("해지통보 및 해지정산금 납입고지")) {
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/pay/cont_cancel_2.jsp?doc_id="+doc_id);
		    }
					
			seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", ""); // 데이타확인후 발송해야 함. 

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
			alert("정상적으로 처리되었습니다.");
			parent.parent.location.reload();			
<%		}else{%>
			alert("에러발생!");
<%		}%>
<%	}else{%>
			alert("이미 등록된 문서번호입니다. 확인하십시오.");
			parent.document.form1.gov_nm.focus();
<%	}%>
</script>
</body>
</html>

