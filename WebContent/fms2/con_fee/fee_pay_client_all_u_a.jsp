<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*, acar.con_ins_m.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")		==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"2":request.getParameter("s_cnt");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String deposit_no 	= request.getParameter("deposit_no")	==null?"":request.getParameter("deposit_no");
	String rc_dt 		= request.getParameter("rc_dt")			==null?"":request.getParameter("rc_dt");
	int    rc_amt 	 	= request.getParameter("rc_amt")		==null?0 :AddUtil.parseDigit(request.getParameter("rc_amt"));
	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
	String autodoc		= request.getParameter("autodoc")==null?"N":request.getParameter("autodoc");
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String row_id = "";
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//거래처지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	String client_id = base.getClient_id();
	String site_id   = base.getR_site();
	
	String value0[]  = request.getParameterValues("gubun");
	String value1[]  = request.getParameterValues("rent_st");
	String value2[]  = request.getParameterValues("rent_seq");
	String value3[]  = request.getParameterValues("fee_tm");
	String value4[]  = request.getParameterValues("tm_st1");//EXT_ID
	String value5[]  = request.getParameterValues("tm_st2");//EXT_ST
	String value6[]  = request.getParameterValues("est_amt");
	String value7[]  = request.getParameterValues("pay_amt");
	String value8[]  = request.getParameterValues("jan_amt");
	String value9[]  = request.getParameterValues("rent_mng_id");
	String value10[] = request.getParameterValues("rent_l_cd");
	String value11[] = request.getParameterValues("car_mng_id");
	String value12[] = request.getParameterValues("accid_id");
	String value13[] = request.getParameterValues("rtn_client_id");
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	String node_code = "S101";
	
//	String node_code = String.valueOf(per.get("NODE_CODE"));
	
	
	out.println(insert_id);
	
	Hashtable deposit = neoe_db.getFeeDepositCase(deposit_no);
	
	String ven_code = client.getVen_code();
	if(ven_code.equals("")){
		if(client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCode(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
		if(!client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCode2(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
		//거래처테이블에 거래처코드 넣기
		af_db.updateClientVenCode(base.getClient_id(), ven_code);
	}
	
	//지점발행이라면..
	if(base.getTax_type().equals("2") && !base.getR_site().equals("") && !site.getEnp_no().equals("") && !site.getEnp_no().equals(client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3())){
		ven_code = site.getVen_code();
	}
	String org_ven_code = ven_code;
	
	Hashtable vendor = neoe_db.getVendorCase(ven_code);
	
	//자동전표처리용
	Vector vt = new Vector();
	
	boolean flag2 = true;
	int flag1 = 0;
	int flag = 0;
	int count =0;
	int line =0;
	String doc_cont = "";
	String rtn_client = "";
	
	for(int i=0 ; i < scd_size ; i++){
		
		rtn_client = value13[i]	==null?"":value13[i];
		
		if(!rtn_client.equals("") && rtn_client.equals(client_id)){//분할청구고객
			//고객정보
			client = al_db.getNewClient(rtn_client);
			ven_code = client.getVen_code();
			if(ven_code.equals("")){
				if(client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCode(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
				if(!client.getClient_st().equals("2"))		ven_code = neoe_db.getVenCode2(client.getSsn1()+client.getSsn2(), client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
				//거래처테이블에 거래처코드 넣기
				af_db.updateClientVenCode(rtn_client, ven_code);
			}
			vendor = neoe_db.getVendorCase(ven_code);
		}else{
			if(!client_id.equals(client.getClient_id())){
				//고객정보
				client = al_db.getNewClient(client_id);
				vendor = neoe_db.getVendorCase(org_ven_code);
			}
		}
		
		//System.out.println("[대여료입금처리]"+ven_code);
		
		//계약기본정보
		ContBaseBean base2 = a_db.getCont(value9[i], value10[i]);
		
		//자동차정보
		CarRegBean cr_bean = crd.getCarRegBean(base2.getCar_mng_id());
		
		int pay_amt = value7[i]	==null?0 :AddUtil.parseDigit(value7[i]);
		
		
		if(pay_amt > 0){
			//대여료
			if(value0[i].equals("scd_fee")){
				
				FeeScdBean pay_fee = af_db.getScdNew(value9[i], value10[i], value1[i], value2[i], value3[i], value4[i]);
				
				pay_fee.setRc_yn	("1");
				pay_fee.setRc_dt	(rc_dt);
				pay_fee.setRc_amt	(pay_amt);
				pay_fee.setUpdate_id(user_id);
				if(!af_db.updateFeeScd(pay_fee))	flag += 1;
				
				if(pay_amt == (pay_fee.getFee_s_amt()+pay_fee.getFee_v_amt())){
					out.println("전액입금처리="+pay_amt+", ");
				}else{
					out.println("부분입금처리="+pay_amt+", ");
					
					int rest_amt 	= (pay_fee.getFee_s_amt()+pay_fee.getFee_v_amt()) - pay_amt;
					int rest_s_amt 	= (new Double(rest_amt/1.1)).intValue();
					out.println(" 잔액생성="+rest_amt);
					
					FeeScdBean rest_fee = new FeeScdBean();
					rest_fee.setRent_mng_id	(pay_fee.getRent_mng_id());
					rest_fee.setRent_l_cd	(pay_fee.getRent_l_cd());
					rest_fee.setFee_tm		(pay_fee.getFee_tm());
					rest_fee.setRent_st		(pay_fee.getRent_st());
					rest_fee.setRent_seq	(pay_fee.getRent_seq());
					rest_fee.setTm_st1		(String.valueOf(Integer.parseInt(pay_fee.getTm_st1())+1));	//잔액대여료. 기존 회차구분+1
					rest_fee.setTm_st2		("0");														//일반대여료(not 회차연장대여료)
					rest_fee.setFee_est_dt	(pay_fee.getFee_est_dt());									//원 대여료의 입금예정일
					rest_fee.setFee_s_amt	(rest_s_amt);
					rest_fee.setFee_v_amt	(rest_amt - rest_s_amt);
					rest_fee.setRc_yn		("0");															//default는 0(미수금)
					rest_fee.setRc_dt		("");
					rest_fee.setRc_amt		(0);
					rest_fee.setUpdate_id	(user_id);
					rest_fee.setR_fee_est_dt(af_db.getValidDt(pay_fee.getR_fee_est_dt())); 				//수정 : 입금예정일을 그대로 간다.(20031030)
					rest_fee.setBill_yn		("Y");
					rest_fee.setRent_seq	(pay_fee.getRent_seq());
					rest_fee.setReq_dt		(pay_fee.getReq_dt());
					rest_fee.setR_req_dt	(pay_fee.getR_req_dt());
					rest_fee.setTax_out_dt	(pay_fee.getTax_out_dt());
					rest_fee.setUse_s_dt	(pay_fee.getUse_s_dt());
					rest_fee.setUse_e_dt	(pay_fee.getUse_e_dt());
					
					if(!af_db.insertFeeScdAdd(rest_fee))	flag += 1;
				}
				
				//대여료 자동전표생성
				
				String acct_cont = "[대여료]"+pay_fee.getFee_tm()+"회차:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
				
				if(doc_cont.equals("")){
					doc_cont = acct_cont;
				}
				
				line++;
				
				//외상매출금
				Hashtable ht2 = new Hashtable();
				
				ht2.put("WRITE_DATE", 	rc_dt);  //row_id							
				ht2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht2.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht2.put("CD_PC",  	node_code);  //회계단위
				ht2.put("CD_WDEPT",  dept_code);  //부서
				ht2.put("NO_DOCU",  	"");  //row_id와 같게 
				ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht2.put("CD_COMPANY",  "1000");  
				ht2.put("ID_WRITE", insert_id);   
				ht2.put("CD_DOCU",  "11");  
				
				ht2.put("DT_ACCT",  rc_dt);  
				ht2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht2.put("TP_DRCR",  "2");   // 대변:2 , 차변:1
				ht2.put("CD_ACCT",  "10800");   // 
				ht2.put("AMT",    	String.valueOf(pay_amt));	
				ht2.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체							
				ht2.put("CD_PARTNER",	ven_code); //거래처    - A06
											
				ht2.put("DT_START",  "");  	//발생일자										 
				ht2.put("CD_BIZAREA",		"");   //귀속사업장	
				ht2.put("CD_DEPT",		"");   //부서								 
				ht2.put("CD_CC",			"");   //코스트센터		
				ht2.put("CD_PJT",			"");   //프로젝트코드		
				ht2.put("CD_CARD",		"");   //신용카드		 	
				ht2.put("CD_EMPLOY",		"");   //사원									 		 
				ht2.put("NO_DEPOSIT",	"");  //예적금계좌
				ht2.put("CD_BANK",		"");  //금융기관	
				ht2.put("NO_ITEM",		"");  //item	  	  	
				
						// 부가세관련
				ht2.put("AM_TAXSTD",	"");  //과세표준액
				ht2.put("AM_ADDTAX",	"" );	 //세액
				ht2.put("TP_TAX",	"");  //과세(매출) :11
				ht2.put("NO_COMPANY",	""); //사업자등록번호 
			
				ht2.put("NM_NOTE", acct_cont);  // 적요		
			
				vt.add(ht2);
				
				
			//연체료
			}else if(value0[i].equals("scd_dly")){
				out.println("연체료입금처리="+pay_amt+", ");
				
				FeeDlyScdBean dly_bean = new FeeDlyScdBean();
				dly_bean.setRent_mng_id	(value9[i]);
				dly_bean.setRent_l_cd	(value10[i]);
				dly_bean.setPay_amt		(pay_amt);
				dly_bean.setPay_dt		(rc_dt);
				dly_bean.setEtc			("");
				dly_bean.setReg_id		(user_id);
				
				flag2 = af_db.insertFeeDlyScd(dly_bean);	//수금 연체료 등록
				
				//연체료 자동전표생성
				
				String acct_cont = "[연체료]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
				
				if(doc_cont.equals("")){
					doc_cont = acct_cont;
				}
				
				line++;
				
				//연체료수익
				Hashtable ht2 = new Hashtable();
				
				ht2.put("WRITE_DATE", 	rc_dt);  //row_id					
				ht2.put("ROW_NO",  	String.valueOf(line)); //row_no					
				ht2.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht2.put("CD_PC",  	node_code);  //회계단위
				ht2.put("CD_WDEPT",  dept_code);  //부서
				ht2.put("NO_DOCU",  	"");  //row_id와 같게 
				ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht2.put("CD_COMPANY",  "1000");  
				ht2.put("ID_WRITE", insert_id);   
				ht2.put("CD_DOCU",  "11");  
				
				ht2.put("DT_ACCT",  rc_dt);  
				ht2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht2.put("TP_DRCR",  "2");   // 대변:2 , 차변:1
				ht2.put("CD_ACCT",  "91300");   // 
				ht2.put("AMT",    	String.valueOf(pay_amt));	
				ht2.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체					
				ht2.put("CD_PARTNER",	ven_code); //거래처    - A06
								
				ht2.put("DT_START",  "");  	//발생일자							 
				ht2.put("CD_BIZAREA",		"");   //귀속사업장	
				ht2.put("CD_DEPT",			"");   //부서								 
				ht2.put("CD_CC",			"");   //코스트센터		
				ht2.put("CD_PJT",			"");   //프로젝트코드	
				ht2.put("CD_CARD",		"");   //신용카드	
				ht2.put("CD_EMPLOY",		"");   //사원							 		 
				ht2.put("NO_DEPOSIT",	"");  //예적금계좌
				ht2.put("CD_BANK",		"");  //금융기관	
	 			ht2.put("NO_ITEM",		"");  //item 
			
						// 부가세관련
				ht2.put("AM_TAXSTD",	"");  //과세표준액
				ht2.put("AM_ADDTAX",	"" );	 //세액
				ht2.put("TP_TAX",	"");  //과세(매출) :11
				ht2.put("NO_COMPANY",	""); //사업자등록번호
	
				ht2.put("NM_NOTE", acct_cont);  // 적요								
											
				vt.add(ht2);
				
				
			//면책금
			}else if(value0[i].equals("scd_serv")){
				
				InsMScdBean cng_ins_ms = ae_db.getScd(value9[i], value10[i], value11[i], value12[i], value4[i], value3[i]);
				
				cng_ins_ms.setCust_pay_dt(rc_dt);
				cng_ins_ms.setPay_amt(pay_amt);
				cng_ins_ms.setUpdate_id(user_id);
				
				flag2 = ae_db.updateInsMScd(cng_ins_ms, "p", "1");
				
				out.println(cng_ins_ms.getRent_mng_id());
				out.println(cng_ins_ms.getRent_l_cd());
				out.println(cng_ins_ms.getCar_mng_id());
				out.println(cng_ins_ms.getServ_id());
				
				
				
				//면책금 자동전표생성
				
				String acct_cont = "[면책금]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
				
				if(doc_cont.equals("")){
					doc_cont = acct_cont;
				}
				
				line++;
				
				Hashtable ht2 = new Hashtable();
				
				//외상매출금
				if(cng_ins_ms.getExt_v_amt()>0){
								
					ht2.put("WRITE_DATE", 	rc_dt);  //row_id							
					ht2.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht2.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht2.put("CD_PC",  	node_code);  //회계단위
					ht2.put("CD_WDEPT",  dept_code);  //부서
					ht2.put("NO_DOCU",  	"");  //row_id와 같게 
					ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht2.put("CD_COMPANY",  "1000");  
					ht2.put("ID_WRITE", insert_id);   
					ht2.put("CD_DOCU",  "11");  
					
					ht2.put("DT_ACCT",  rc_dt);  
					ht2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht2.put("TP_DRCR",  "2");   // 대변:2 , 차변:1
					ht2.put("CD_ACCT",  "10800");   // 
					ht2.put("AMT",    	String.valueOf(pay_amt));	
					ht2.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체							
					ht2.put("CD_PARTNER",	ven_code); //거래처    - A06
												
					ht2.put("DT_START",  "");  	//발생일자										 
					ht2.put("CD_BIZAREA",		"");   //귀속사업장	
					ht2.put("CD_DEPT",		"");   //부서								 
					ht2.put("CD_CC",			"");   //코스트센터		
					ht2.put("CD_PJT",			"");   //프로젝트코드		
					ht2.put("CD_CARD",		"");   //신용카드		 	
					ht2.put("CD_EMPLOY",		"");   //사원									 		 
					ht2.put("NO_DEPOSIT",	"");  //예적금계좌
					ht2.put("CD_BANK",		"");  //금융기관	
					ht2.put("NO_ITEM",		"");  //item	  	  	
					
							// 부가세관련
					ht2.put("AM_TAXSTD",	"");  //과세표준액
					ht2.put("AM_ADDTAX",	"" );	 //세액
					ht2.put("TP_TAX",	"");  //과세(매출) :11
					ht2.put("NO_COMPANY",	""); //사업자등록번호 
				
					ht2.put("NM_NOTE", acct_cont);  // 적요		
			
				//차량손해면책금
				}else{
									
					ht2.put("WRITE_DATE", 	rc_dt);  //row_id   							
					ht2.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht2.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht2.put("CD_PC",  	node_code);  //회계단위
					ht2.put("CD_WDEPT",  dept_code);  //부서
					ht2.put("NO_DOCU",  	"");  //row_id와 같게 
					ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht2.put("CD_COMPANY",  "1000");  
					ht2.put("ID_WRITE", insert_id);   
					ht2.put("CD_DOCU",  "11");  
					
					ht2.put("DT_ACCT",  incom_dt);  
					ht2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht2.put("TP_DRCR",  "2");   // 대변:2 , 차변:1
					ht2.put("CD_ACCT",  "91800");   //면책금(91800)
					ht2.put("AMT",    	String.valueOf(pay_amt));	
					ht2.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체								
					ht2.put("CD_PARTNER",	ven_code); //거래처    - A06
												
					ht2.put("DT_START",  "");  	//발생일자									 
					ht2.put("CD_BIZAREA",		"");   //귀속사업장	
					ht2.put("CD_DEPT",		"");   //부서								 
					ht2.put("CD_CC",			"");   //코스트센터		
					ht2.put("CD_PJT",			"");   //프로젝트코드	
					ht2.put("CD_CARD",		"");   //신용카드		 	
					ht2.put("CD_EMPLOY",		"");   //사원									 		 
					ht2.put("NO_DEPOSIT",	"");  //예적금계좌
					ht2.put("CD_BANK",		"");  //금융기관	
 					ht2.put("NO_ITEM",		"");  //item	  	
 					
 							// 부가세관련
					ht2.put("AM_TAXSTD",	"");  //과세표준액
					ht2.put("AM_ADDTAX",	"" );	 //세액
					ht2.put("TP_TAX",	"");  //과세(매출) :11
					ht2.put("NO_COMPANY",	""); //사업자등록번호 
				
					ht2.put("NM_NOTE", acct_cont);  // 적요				
				}
				
				vt.add(ht2);
				
			}
			
		}
		out.println("<br>");
	}
			
	if(line > 1){
		doc_cont = doc_cont+" 외";
	}
	
	line++;
	
	//보통예금
	Hashtable ht1 = new Hashtable();
	
	ht1.put("WRITE_DATE", 	rc_dt);  //row_id			
	ht1.put("ROW_NO",  	String.valueOf(line)); //row_no
						
	ht1.put("NO_TAX",  	"*");  //부가세 이외는 *
	ht1.put("CD_PC",  	node_code);  //회계단위
	ht1.put("CD_WDEPT",  dept_code);  //부서
	ht1.put("NO_DOCU",  	"");  //row_id와 같게 
	ht1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht1.put("CD_COMPANY",  "1000");  
	ht1.put("ID_WRITE", insert_id);   
	ht1.put("CD_DOCU",  "11");  
	
	ht1.put("DT_ACCT",  rc_dt);  
	ht1.put("ST_DOCU",  "1");  //미결:1, 승인:2  					
	ht1.put("TP_DRCR",  	"1");//차변
	ht1.put("CD_ACCT",    "10300");  //보통예금
	ht1.put("AMT",    	String.valueOf(rc_amt));
	ht1.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체				
	ht1.put("CD_PARTNER",	""); //거래처    - A06
			
	ht1.put("DT_START",  "");   	//발생일자					 
	ht1.put("CD_BIZAREA",		"");   //귀속사업장	
	ht1.put("CD_DEPT",		"");   //부서								 
	ht1.put("CD_CC",			"");   //코스트센터		
	ht1.put("CD_PJT",			"");   //프로젝트코드	
	ht1.put("CD_CARD",		"");   //신용카드		 		 	
	ht1.put("CD_EMPLOY",		"");   //사원
	ht1.put("NO_DEPOSIT",   String.valueOf(deposit.get("DEPOSIT_NO"))); //예적금계좌
	ht1.put("CD_BANK",		String.valueOf(deposit.get("BANK_CODE")));//금융기관	
 	ht1.put("NO_ITEM",		"");  //item
 	
 			// 부가세관련
	ht1.put("AM_TAXSTD",	"");  //과세표준액
	ht1.put("AM_ADDTAX",	"" );	 //세액
	ht1.put("TP_TAX",	"");  //과세(매출) :11
	ht1.put("NO_COMPANY",	""); //사업자등록번호

	ht1.put("NM_NOTE", doc_cont);  // 적요			
		
	vt.add(ht1);
	
	if(autodoc.equals("Y") && vt.size() > 0){
	//	count = neoe_db.insertDebtSettleAutoDocu(rc_dt, vt);
		 row_id = neoe_db.insertSetAutoDocu(rc_dt,  vt);

		if(row_id.equals("0")){
			count = 1;
		}		
	}
		
	int    stop_size 	= request.getParameter("stop_size")		==null?0 :AddUtil.parseInt(request.getParameter("stop_size"));
	
	if(stop_size >0){
	
		//계산서발행 중지 해제처리
		String value21[]  = request.getParameterValues("stop_seq");
		String value22[]  = request.getParameterValues("cancel_dt");
		String value23[]  = request.getParameterValues("stop_rent_mng_id");
		String value24[]  = request.getParameterValues("stop_rent_l_cd");
		
		int vid_size = 0;
		vid_size = value21.length;
		
		for(int j=0;j < vid_size;j++){
			
			String stop_seq  = value21[j]	==null?"":value21[j];
			String cancel_dt = value22[j]	==null?"":value22[j];
			
			if(!stop_seq.equals("") && !cancel_dt.equals("")){
				
				//세금계산서 발행 일시중지 등록 ----------------------------------------------------------------------
				FeeScdStopBean fee_stop = af_db.getFeeScdStop(value23[j], value24[j], stop_seq);
				
				fee_stop.setCancel_dt	(cancel_dt);		//중지해제일
				if(!fee_stop.getCancel_dt().equals("") && fee_stop.getCancel_id().equals(""))		fee_stop.setCancel_id(user_id);
				
				if(!af_db.updateFeeScdStop(fee_stop)) flag1 += 1;
			}
		}
	}
%>


<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<%

%>
<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='s_cnt' value='<%=s_cnt%>'>
</form>
<script language='javascript'>
alert('처리되었습니다.');
self.close();
</script>
</body>
</html>
