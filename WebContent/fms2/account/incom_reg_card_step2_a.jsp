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
	
	String not_yet 	= request.getParameter("not_yet")==null?"0":request.getParameter("not_yet");  //1:가수금
	String not_yet_reason 	= request.getParameter("not_yet_reason")==null?"":request.getParameter("not_yet_reason");  //1:가수금	
		
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();		
		
	
	
	String value0[]  = request.getParameterValues("gubun"); //scd_card
	String value1[]  = request.getParameterValues("card_dt");
	String value2[]  = request.getParameterValues("card_seq");
	String value3[]  = request.getParameterValues("card_amt"); //청구금액
	String value4[]  = request.getParameterValues("card_tax");//수수료
	String value5[]  = request.getParameterValues("card_nm");//카드사
	String value6[]  = request.getParameterValues("card_no"); //카드번호
	String value7[]  = request.getParameterValues("card_remark"); //적요
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	String node_code ="S101";  //네오엠 iu 에서는 회계단위:S101	
	
	
	Hashtable vendor = new Hashtable();	
	
	String ven_code = "";
	
	String docu_gubun = "3";
	
	//자동전표처리용
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
		
		//입금거래내역 정보
//	IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
//	String card_nm = base.getCard_nm();
				
	
	//소속영업소 리스트 조회
	Hashtable br = c_db.getBranch("S1"); //무조건 본사 

	//가수금인 경우
	if ( not_yet.equals("1") ) {
	   	   	
		doc_cont = not_yet_reason;
							
	   	line++;
			 				   		
   		Hashtable ht1_1 = new Hashtable();
   		
   		ht1_1.put("WRITE_DATE", 	incom_dt);  //row_id	
		ht1_1.put("ROW_NO",  	String.valueOf(line)); //row_no		
		ht1_1.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
		ht1_1.put("CD_PC",  	node_code);  //회계단위*
		ht1_1.put("CD_WDEPT",  dept_code);  //부서
		ht1_1.put("NO_DOCU",  	"");  //row_id와 같게
		ht1_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht1_1.put("CD_COMPANY",  "1000");  
		ht1_1.put("ID_WRITE", insert_id);   
		ht1_1.put("CD_DOCU",  "11");  
		
		ht1_1.put("DT_ACCT",  incom_dt);  
		ht1_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht1_1.put("TP_DRCR",  "2");   // 대변:2 , 차변:1
		ht1_1.put("CD_ACCT",  "25700");   //가수금
		ht1_1.put("AMT",    	String.valueOf(incom_amt));								
		ht1_1.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체	
		ht1_1.put("CD_PARTNER",	"000131"); //거래처    - A06
			
		ht1_1.put("DT_START",  "");  	//발생일자			
		ht1_1.put("CD_BIZAREA",	"");   //귀속사업장	
		ht1_1.put("CD_DEPT",		"");   //부서								 
		ht1_1.put("CD_CC",			"");   //코스트센터		
		ht1_1.put("CD_PJT",			"");   //프로젝트코드	
		ht1_1.put("CD_CARD",		"");   //신용카드		 		 		
		ht1_1.put("CD_EMPLOY",		"");   //사원	
		ht1_1.put("NO_DEPOSIT",	"");  //예적금계좌
		ht1_1.put("CD_BANK",		"");  //금융기관	
		ht1_1.put("NO_ITEM",		"");  //item 	 
		
				// 부가세관련
		ht1_1.put("AM_TAXSTD",	"");  //과세표준액
		ht1_1.put("AM_ADDTAX",	"" );	 //세액
		ht1_1.put("TP_TAX",	"");  //과세(매출) :11
		ht1_1.put("NO_COMPANY",	""); //사업자등록번호
	
		ht1_1.put("NM_NOTE", doc_cont);  // 적요
			
		vt.add(ht1_1);	
	  
	} else  {   
		
		for(int i=0 ; i < scd_size ; i++){	
						
			card_dt = value1[i]	== null?"":value1[i];  //카드청구일
			int card_seq = value2[i]	==null?0 :AddUtil.parseDigit(value2[i]); //카드연번 (집금연번)					
			int pay_amt = value3[i]	==null?0 :AddUtil.parseDigit(value3[i]); //청구금액 
										
			if(pay_amt != 0){  // kcp 취소건은 -처리.
					
				if( value0[i].equals("scd_card") ){							
														
					IncomItemBean i_item = new IncomItemBean();						
									
					i_item.setItem_nm(value0[i]);
					i_item.setItem_dt(value1[i]);
					i_item.setItem_seq(card_seq);
					i_item.setIncom_dt	(incom_dt); //원장번호
					i_item.setIncom_seq(incom_seq);//연번
			
					if(!in_db.insertIncomItem(i_item))	flag += 1;										
					if(!in_db.updateIncomSet(card_dt, card_seq, "6")) flag += 1;
					 
					 	//입금거래내역 정보
					IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
					String card_nm = base.getCard_nm();
			
					//카드미수금 자동전표생성					
					String acct_cont = "";
					
					if ( value0[i].equals("scd_card")){
						acct_cont = "[카드미수금]"+ value7[i]+"("+value5[i]+")";
					}	
						
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;
					
					//미수금
					Hashtable ht15 = new Hashtable();			
				        	      
					ht15.put("WRITE_DATE", 	incom_dt);  //row_id			
					ht15.put("ROW_NO",  	String.valueOf(line)); //row_no			
					ht15.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht15.put("CD_PC",  	node_code);  //회계단위
					ht15.put("CD_WDEPT",  dept_code);  //부서
					ht15.put("NO_DOCU",  	"");  //row_id와 같게
					ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht15.put("CD_COMPANY",  "1000");  
					ht15.put("ID_WRITE", insert_id);   
					ht15.put("CD_DOCU",  "11");  
					
					ht15.put("DT_ACCT",  incom_dt);  
					ht15.put("ST_DOCU",  "1");  //미결:1, 승인:2  	
					ht15.put("TP_DRCR",  "2"); //대변							
					ht15.put("CD_ACCT",    	 		  	"12000");  // 미수금
					ht15.put("AMT",  	String.valueOf(pay_amt));
					ht15.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체				
					
				   if (  doc_cont.indexOf("KCP") != -1 ) {//카드사 결재대행인 경우					
				//	if (  card_nm.equals("KCP")  ) {//카드사 결재대행인 경우		
						ht15.put("CD_PARTNER",	"105320"); //거래처    - A06  한국사이버결재(KCP)
					} else if (   doc_cont.indexOf("페이엣") != -1   ) {//카드사 결재대행인 경우		
						ht15.put("CD_PARTNER",	"996282"); //거래처   - A06  페이엣 
					} else if (   doc_cont.indexOf("나이스") != -1   ) {//카드사 결재대행인 경우		
						ht15.put("CD_PARTNER",	"996283"); //거래처   - A06  페이엣 
					} else if (   doc_cont.indexOf("이노페이") != -1   ) {//카드사 결재대행인 경우		
						ht15.put("CD_PARTNER",	"996548"); //거래처   - A06  페이엣 		
					}	else {
						ht15.put("CD_PARTNER",	"109691"); //거래처    - A06		
					}
			
					ht15.put("DT_START",  incom_dt);   	//발생일자					 
					ht15.put("CD_BIZAREA",		"");   //귀속사업장	
					ht15.put("CD_DEPT",		"");   //부서								 
					ht15.put("CD_CC",			"");   //코스트센터		
					ht15.put("CD_PJT",			"");   //프로젝트코드	
					ht15.put("CD_CARD",		"");   //신용카드		 		 	
					ht15.put("CD_EMPLOY",		"");   //사원	
					ht15.put("NO_DEPOSIT",		"");  //예적금계좌
					ht15.put("CD_BANK",		"");  //금융기관	
				 	ht15.put("NO_ITEM",		"");  //item   	
				 	
				 			// 부가세관련
					ht15.put("AM_TAXSTD",	"");  //과세표준액
					ht15.put("AM_ADDTAX",	"" );	 //세액
					ht15.put("TP_TAX",	"");  //과세(매출) :11
					ht15.put("NO_COMPANY",	""); //사업자등록번호		  	 	 
				
					ht15.put("NM_NOTE", acct_cont);  // 적요				
												
					vt.add(ht15);	
					
					card_amt = card_amt + pay_amt;
											
				
					int c_t_amt = value4[i]	==null?0 :AddUtil.parseDigit(value4[i]); //수수료 - 가지급금 
				
					
					card_tax = card_tax + c_t_amt;
										
					acct_cont = "[카드수수료]"+ value7[i]+"("+value5[i]+")";
					
				    if  ( c_t_amt > 0 ) {	//수수료를 받은경우 (장기상품인 경우)					
						line++;
						
						//카드수수료
						Hashtable ht21 = new Hashtable();		
						
						ht21.put("WRITE_DATE", 	incom_dt);  //row_id			
						ht21.put("ROW_NO",  	String.valueOf(line)); //row_no			
						ht21.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht21.put("CD_PC",  	node_code);  //회계단위
						ht21.put("CD_WDEPT",  dept_code);  //부서
						ht21.put("NO_DOCU",  	"");  //row_id와 같게
						ht21.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht21.put("CD_COMPANY",  "1000");  
						ht21.put("ID_WRITE", insert_id);   
						ht21.put("CD_DOCU",  "11");  
						
						ht21.put("DT_ACCT",  incom_dt);  
						ht21.put("ST_DOCU",  "1");  //미결:1, 승인:2  	
						ht21.put("TP_DRCR",  "1"); //차변							
						
						ht21.put("AMT",  		String.valueOf(c_t_amt));
						ht21.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체				
							
						if (  doc_cont.indexOf("KCP") != -1 ) {//카드사 결재대행인 경우					
					//	if ( card_nm.equals("KCP") ) {							
							ht21.put("CD_PARTNER",	"105320"); //거래처    - A06  한국사이버결재(KCP)
							ht21.put("CD_ACCT",    	 		  	"25700");  // 가수금
						//	ht21.put("CD_ACCT",    	 		  	"13400");  // 가지급금
						} else if (  doc_cont.indexOf("페이엣") != -1  ) {//카드사 결재대행인 경우		
							ht21.put("CD_PARTNER",	"996282"); //거래처   - A06  페이엣 
							ht21.put("CD_ACCT",    	 		  	"25700");  // 가수금
						//	ht21.put("CD_ACCT",    	 		  	"13400");  // 가지급금
						//	ht21.put("CD_ACCT",    	 		  	"83100");  // 지급수수료로 처리  20200402)
						} else if (   doc_cont.indexOf("나이스") != -1   ) {//카드사 결재대행인 경우		
							ht21.put("CD_PARTNER",	"996283"); //거래처   - A06  나이스 		
						//	ht21.put("CD_ACCT",    	 		  	"13400");  // 가지급금 -  카드 cms 인경우 	
							ht21.put("CD_ACCT",    	 		  	"83100");  // 지급수수료로 처리  20200402)
						} else if (   doc_cont.indexOf("이노페이") != -1   ) {//카드사 결재대행인 경우		
							ht21.put("CD_PARTNER",	"996548"); //거래처   - A06  나이스 		
						//	ht21.put("CD_ACCT",    	 		  	"13400");  // 가지급금 -  카드 cms 인경우 	
							ht21.put("CD_ACCT",    	 		  	"25700");  // 지급수수료로 처리  20200402)
						} else {							
							ht21.put("CD_PARTNER",	"109691"); //거래처    - A06		
							ht21.put("CD_ACCT",    	 		  	"25700");  // 가수금
						//	ht21.put("CD_ACCT",    	 		  	"83100");  // 지급수수료로 처리 
						}
					
						ht21.put("DT_START",  incom_dt);   	//발생일자					 
						ht21.put("CD_BIZAREA",		"");   //귀속사업장	
						ht21.put("CD_DEPT",		"");   //부서								 
						ht21.put("CD_CC",			"");   //코스트센터		
						ht21.put("CD_PJT",			"");   //프로젝트코드	
						ht21.put("CD_CARD",		"");   //신용카드		 		 	
						ht21.put("CD_EMPLOY",		"");   //사원	
						ht21.put("NO_DEPOSIT",		"");  //예적금계좌
						ht21.put("CD_BANK",		"");  //금융기관	
					 	ht21.put("NO_ITEM",		"");  //item   	
					 	
					 			// 부가세관련
						ht21.put("AM_TAXSTD",	"");  //과세표준액
						ht21.put("AM_ADDTAX",	"" );	 //세액
						ht21.put("TP_TAX",	"");  //과세(매출) :11
						ht21.put("NO_COMPANY",	""); //사업자등록번호		  	 	 
					
						ht21.put("NM_NOTE", acct_cont);  // 적요									
										
						vt.add(ht21);	
					}		
			
				}	
			}  //pay_amt != 0
			out.println("<br>");
		}  //end for 
					
		if(line > 1){
			doc_cont = doc_cont+" 외";
		}
				
			//잡이익 또는 잡손실
		amt_10800 = incom_amt  + card_tax  - card_amt;
			
			//잡이익 	
	   	if ( amt_10800  > 0 ) {
				
			line++;
			
			Hashtable ht7 = new Hashtable();
				
			ht7.put("WRITE_DATE", 	incom_dt);  //row_id			
			ht7.put("ROW_NO",  	String.valueOf(line)); //row_no			
			ht7.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht7.put("CD_PC",  	node_code);  //회계단위
			ht7.put("CD_WDEPT",  dept_code);  //부서
			ht7.put("NO_DOCU",  	"");  //row_id와 같게
			ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht7.put("CD_COMPANY",  "1000");  
			ht7.put("ID_WRITE", insert_id);   
			ht7.put("CD_DOCU",  "11");  
			
			ht7.put("DT_ACCT",  incom_dt);  
			ht7.put("ST_DOCU",  "1");  //미결:1, 승인:2  	
			ht7.put("TP_DRCR",  "2"); //대변							
			ht7.put("CD_ACCT",    	"93000");  //잡이익
			ht7.put("AMT",  		 String.valueOf( amt_10800 ));		
			ht7.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체				
			ht7.put("CD_PARTNER",	"000131"); //거래처    - A06
				
			ht7.put("DT_START",  incom_dt);   	//발생일자					 
			ht7.put("CD_BIZAREA",		"");   //귀속사업장	
			ht7.put("CD_DEPT",		"");   //부서								 
			ht7.put("CD_CC",			"");   //코스트센터		
			ht7.put("CD_PJT",			"");   //프로젝트코드	
			ht7.put("CD_CARD",		"");   //신용카드		 		 	
			ht7.put("CD_EMPLOY",		"");   //사원	
			ht7.put("NO_DEPOSIT",		"");  //예적금계좌
			ht7.put("CD_BANK",		"");  //금융기관	
		 	ht7.put("NO_ITEM",		"");  //item   	
		 	
		 			// 부가세관련
			ht7.put("AM_TAXSTD",	"");  //과세표준액
			ht7.put("AM_ADDTAX",	"" );	 //세액
			ht7.put("TP_TAX",	"");  //과세(매출) :11
			ht7.put("NO_COMPANY",	""); //사업자등록번호		  	 	 
		
			ht7.put("NM_NOTE", doc_cont);  // 적요									
													
			vt.add(ht7);  // 처분이익
	  	}
	 
	 	
	 	 //처분손실 	
	   	if ( amt_10800 < 0 ) {
			
				line++;
			
				Hashtable ht8 = new Hashtable();
			
		         		   
       			ht8.put("WRITE_DATE", 	incom_dt);  //row_id			
				ht8.put("ROW_NO",  	String.valueOf(line)); //row_no			
				ht8.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht8.put("CD_PC",  	node_code);  //회계단위
				ht8.put("CD_WDEPT",  dept_code);  //부서
				ht8.put("NO_DOCU",  	"");  //미결은 '0'  //row_id와 같게
				ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht8.put("CD_COMPANY",  "1000");  
				ht8.put("ID_WRITE", insert_id);   
				ht8.put("CD_DOCU",  "11");  
				
				ht8.put("DT_ACCT",  incom_dt);  
				ht8.put("ST_DOCU",  "1");  //미결:1, 승인:2  	
				ht8.put("TP_DRCR",  "1"); //차변							
				ht8.put("CD_ACCT",    	"13400");  //가지급금
				ht8.put("AMT",  		 String.valueOf( amt_10800* (-1) ));
				ht8.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체			
				
				if (  doc_cont.indexOf("KCP") != -1 ) {//카드사 결재대행인 경우		
					ht8.put("CD_ACCT",    	"13400");  //가지급금		
					ht8.put("CD_PARTNER",	"105320"); //거래처    - A06  한국사이버결재(KCP)
				} else if (  doc_cont.indexOf("페이엣") != -1  ) {//카드사 결재대행인 경우	
					ht8.put("CD_ACCT",    	"83100");  //지급수수료 	(20200402)				
				//	ht8.put("CD_ACCT",    	"13400");  //가지급금	
					ht8.put("CD_PARTNER",	"996282"); //거래처   - A06  페이엣 
				} else if (   doc_cont.indexOf("나이스") != -1   ) {//카드사 결재대행인 경우		
				//	ht8.put("CD_ACCT",    	"13400");  //가지급금
					ht8.put("CD_ACCT",    	"83100");  //지급수수료 	(20200402)	
					ht8.put("CD_PARTNER",	"996283"); //거래처   - A06  나이스 - 카드  cms 인경우 	
				} else if (   doc_cont.indexOf("이노페이") != -1   ) {//카드사 결재대행인 경우		
					//	ht8.put("CD_ACCT",    	"13400");  //가지급금
						ht8.put("CD_ACCT",    	"83100");  //지급수수료 	(20200402)	
						ht8.put("CD_PARTNER",	"996548"); //거래처   - A06  나이스 - 카드  cms 인경우 		
				} else {			
					ht8.put("CD_ACCT",    	"83100");  //지급수수료				
					ht8.put("CD_PARTNER",	"109691"); //거래처    - A06		
				}
					
					
				ht8.put("DT_START",  incom_dt);   	//발생일자					 
				ht8.put("CD_BIZAREA",		"");   //귀속사업장	
				ht8.put("CD_DEPT",		"");   //부서								 
				ht8.put("CD_CC",			"");   //코스트센터		
				ht8.put("CD_PJT",			"");   //프로젝트코드	
				ht8.put("CD_CARD",		"");   //신용카드		 		 	
				ht8.put("CD_EMPLOY",		"");   //사원	
				ht8.put("NO_DEPOSIT",		"");  //예적금계좌
				ht8.put("CD_BANK",		"");  //금융기관	
			 	ht8.put("NO_ITEM",		"");  //item   	
			 	
			 			// 부가세관련
				ht8.put("AM_TAXSTD",	"");  //과세표준액
				ht8.put("AM_ADDTAX",	"" );	 //세액
				ht8.put("TP_TAX",	"");  //과세(매출) :11
				ht8.put("NO_COMPANY",	""); //사업자등록번호		  	 	 
			
				ht8.put("NM_NOTE", doc_cont);  // 적요				
  			
	     		vt.add(ht8);  // 처분손실
  	  }
	  	
	}
	  	
	line++;

	//보통예금
	Hashtable ht1 = new Hashtable();
	
	ht1.put("WRITE_DATE", 	incom_dt);  //row_id			
	ht1.put("ROW_NO",  	String.valueOf(line)); //row_no
	
	ht1.put("NO_TAX",  	"*");  //부가세 이외는 *
	ht1.put("CD_PC",  	node_code);  //회계단위
	ht1.put("CD_WDEPT",  dept_code);  //부서
	ht1.put("NO_DOCU",  	"");  //미결은 '0'  -> row_id 와 같게
	ht1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht1.put("CD_COMPANY",  "1000");  
	ht1.put("ID_WRITE", insert_id);   
	ht1.put("CD_DOCU",  "11");  
	
	ht1.put("DT_ACCT",  incom_dt);  
	ht1.put("ST_DOCU",  "1");  //미결:1, 승인:2  					
	ht1.put("TP_DRCR",  	"1");//차변
	ht1.put("CD_ACCT",    "10300");  //보통예금
	ht1.put("AMT",    	String.valueOf(incom_amt));
	ht1.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체				
	ht1.put("CD_PARTNER",	""); //거래처    - A06
			
	ht1.put("DT_START",  "");   	//발생일자					 
	ht1.put("CD_BIZAREA",		"");   //귀속사업장	
	ht1.put("CD_DEPT",		"");   //부서								 
	ht1.put("CD_CC",			"");   //코스트센터		
	ht1.put("CD_PJT",			"");   //프로젝트코드	
	ht1.put("CD_CARD",		"");   //신용카드		 		 	
	ht1.put("CD_EMPLOY",		"");   //사원
	ht1.put("NO_DEPOSIT",	deposit_no);  //예적금계좌
	ht1.put("CD_BANK",		bank_code);  //금융기관	
 	ht1.put("NO_ITEM",		"");  //item
 	
 			// 부가세관련
	ht1.put("AM_TAXSTD",	"");  //과세표준액
	ht1.put("AM_ADDTAX",	"" );	 //세액
	ht1.put("TP_TAX",	"");  //과세(매출) :11
	ht1.put("NO_COMPANY",	""); //사업자등록번호

	ht1.put("NM_NOTE", doc_cont);  // 적요			
		
	vt.add(ht1);	
	
	if ( vt.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(incom_dt,  vt);
	}	

	//입금원장처리
	if ( not_yet.equals("1") ) {
	   if(!in_db.updateIncomSet( incom_dt, incom_seq, not_yet_reason,  "2" )) flag += 1;  //가수금
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

<%	if(flag != 0){ 	//해지테이블에 저장 실패%>
	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				

    fm.action='/fms2/account/incom_reg_step1.jsp';
 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>

</body>
</html>
