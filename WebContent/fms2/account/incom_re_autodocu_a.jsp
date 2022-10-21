<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.incom.*, acar.common.*, acar.user_mng.*, acar.ext.*, acar.credit.*, tax.*, acar.coolmsg.*, acar.forfeit_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*, acar.con_ins_m.*, acar.accid.*, acar.con_ins_h.*,  acar.cls.*, acar.car_sche.*"%>
<%@ page import="acar.kakao.*, tax.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="ass_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")		==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	if ( from_page.equals("")) from_page = "/fms2/account/incom_d_frame.jsp" ;
			
	String bank_code 	= request.getParameter("bank_code2")	==null?"":request.getParameter("bank_code2");
	String deposit_no 	= request.getParameter("deposit_no2")	==null?"":request.getParameter("deposit_no2");		
	String bank_name 	= request.getParameter("bank_name")	==null?"":request.getParameter("bank_name");
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	long  incom_amt 			= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
//	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
			 			
	//카드로 계산한 경우 수수료
	String ip_method 		= "";
	int    card_tax 	 	= request.getParameter("card_tax")	==null?0 :AddUtil.parseDigit(request.getParameter("card_tax"));  //카드 수수료
			
	String neom		= request.getParameter("neom")==null?"Y":request.getParameter("neom"); 
//	String s_neom		= request.getParameter("s_neom")==null?"N":request.getParameter("s_neom");  //검색후 거래처선택후 상세내용전표발행 
	String s_neom = "Y"; //전표발행
	
	String neom1 = "";
	
	//기타입금관련
	String n_ven_code 		= request.getParameter("n_ven_code")	==null?"":request.getParameter("n_ven_code");
	String n_ven_name 		= request.getParameter("n_ven_name")	==null?"":request.getParameter("n_ven_name");
	String ip_acct 		= request.getParameter("ip_acct")	==null?"":request.getParameter("ip_acct");
	String acct_gubun 		= request.getParameter("acct_gubun")	==null?"4":request.getParameter("acct_gubun"); //차/대 구분 -> 차변:D, 대변:C
	long     ip_acct_amt 	 	= request.getParameter("ip_acct_amt")	==null?0 :AddUtil.parseDigit4(request.getParameter("ip_acct_amt"));
	String remark 		= request.getParameter("remark")	==null?"":request.getParameter("remark");
				
	//휴/대차료	
	String tax_yn = "N";	
		
	CarRegDatabase crd = CarRegDatabase.getInstance();

	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
		
	ClientBean client = new ClientBean();	
	
	String client_id = "";
	String site_id   = "";
	String car_st = "";   //월렌트 car_st = '4'
	
	String value0[]  = request.getParameterValues("gubun");
	String value1[]  = request.getParameterValues("rent_st");
	String value2[]  = request.getParameterValues("rent_seq");
	String value3[]  = request.getParameterValues("fee_tm");
	String value4[]  = request.getParameterValues("tm_st1");//EXT_ID
	String value5[]  = request.getParameterValues("tm_st2");//EXT_ST
	String value6[]  = request.getParameterValues("est_amt"); //예정액
	String value7[]  = request.getParameterValues("pay_amt"); //입금액
	String value8[]  = request.getParameterValues("jan_amt");  //잔액
	String value9[]  = request.getParameterValues("rent_mng_id");  
	String value10[] = request.getParameterValues("rent_l_cd");    
	String value11[] = request.getParameterValues("car_mng_id");
	String value12[] = request.getParameterValues("accid_id");
	String value13[] = request.getParameterValues("rtn_client_id");	//
	String value14[] = request.getParameterValues("rent_s_cd");   //월렌트, 정비대차
	String value15[] = request.getParameterValues("cls_amt");   //휴/대차료 건 청구서발행 안함면 1로
	String value16[]  = request.getParameterValues("tm1_nm");//항목 - 대여료/면책금등 	 - 해지정산금인 경우 가수금 
		
	int scd_size = value0.length;  //스케쥴로 입금처리된 갯수
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));  //네오엠관련 정보	
	String node_code ="S101";  //네오엠 iu 에서는 회계단위:S101	
	
	Hashtable vendor = new Hashtable();	
	
	String ven_code = "";
	String s_ven_code = "";
	String car_no = "";	
	String car_nm = "";	
	String docu_gubun = "";
	String amt_gubun = "";
	
	//neoe는  현금출납장때문에 무조건 대체로 처리 - 현금도. 
	 docu_gubun = "3";		
	 amt_gubun = "2";	  

	//자동전표처리용 & 세금계산서
	Vector vt = new Vector();	
	String row_id = "";
	String ven_type = "";   //부가세 관련
	String s_idno = "";	
	String client_st = "";
	String tax_no = "";
	String item_id = "";
  	String reg_code = "";	
	
  	int  a1_s_amt = 0;  //대여료
   	int  a1_v_amt = 0;
		
	boolean flag2 = true;
	int flag1 = 0;
	int flag = 0;
	int count =0;
	int line =0;
	String doc_cont = "";
	String rtn_client = "";
	String rent_s_cd = "";
	
	String i_enp_no 	= "";
	String i_ssn 		= "";
	String i_firm_nm 	= "";
	String i_client_nm 	= "";
	String i_sta 		= "";
	String i_item 		= "";
	String i_addr 		= "";
	String i_agnt_nm	= "";
	String i_agnt_email	= "";
	String i_agnt_m_tel = "";
	
	//문자 관련
	String sendname = "(주)아마존카";
	String sendphone = "02-392-4243";
	String first_id = "";			
		
		//입금거래내역 정보
	IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
	String card_nm = base.getCard_nm();
	ip_method = base.getIp_method();
		
	long t_pay_amt =  0;	//기타입금분 처리시 사용		
	
	int i_tax_supply = 0;  //월렌트 카드인 경우 공급가, 20200101이후 선수대여료 처리시 사용 (20191226)
	int i_tax_value = 0;  //월렌트 카드인 경우 vat , 20200101이후 선수대여료 처리시 사용 (20191226)
			  	
	int cal_tax = 0;  //카드인 경우 수수료 계산용
	int a_cal_tax = 0; //누적
	
	String green_chk = "";
	String pp_chk = ""; //선납금 균등 check ->0:균등 
	String tax_branch = "";
	String foreigner= "";
	//소속영업소 리스트 조회
	Hashtable br = c_db.getBranch("S1"); //무조건 본사 
   
	String not_yet= "0"; //전표재발행시 가수금 처리전표 발행 안함.
	String not_yet_reason= "가수금 처리"; //전표재발행시 가수금 처리전표 발행 안함.
	//가수금인 경우
	if ( not_yet.equals("1") ) {
	   	   	
		doc_cont = not_yet_reason;
					
	   	line++;
	 				   		
   		Hashtable ht1_1 = new Hashtable();
   		   								
		ht1_1.put("WRITE_DATE", 	incom_dt);  //row_id	
		ht1_1.put("ROW_NO",  	String.valueOf(line)); //row_no		
		ht1_1.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
		ht1_1.put("CD_PC",  node_code);  //회계단위*
		ht1_1.put("CD_WDEPT",  dept_code);  //부서
		ht1_1.put("NO_DOCU",  	"");  //row_id와 같게
		ht1_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht1_1.put("CD_COMPANY",  "1000");  
		ht1_1.put("ID_WRITE", insert_id);   
		ht1_1.put("CD_DOCU",  "11");  
		
		ht1_1.put("DT_ACCT",  incom_dt);  
		ht1_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht1_1.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
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
		
		neom1 = "Y"; //보통예금 전표생성 
	  
	} else  {   //20130901부터 월렌트도 cont에서 관리 - car_st = '4'
		
		for(int i=0 ; i < scd_size ; i++){
	
			ContBaseBean base2 = new ContBaseBean();	
			CarRegBean cr_bean  = new CarRegBean();
			
				
			if(!value9[i].equals("")){		//월렌트제외
				//계약기본정보
				base2 = a_db.getCont(value9[i], value10[i]);
										
				site_id = base2.getR_site();	
				first_id = base2.getBus_id();	
				car_st = base2.getCar_st();
									
					//자동차정보
				cr_bean = crd.getCarRegBean(base2.getCar_mng_id());		
				car_no =	cr_bean.getCar_no();
				car_nm =	cr_bean.getCar_nm();
			}  else {	
				//자동차정보
				cr_bean = crd.getCarRegBean(value11[i]);		
				car_no =	cr_bean.getCar_no();
				car_nm =	cr_bean.getCar_nm();
			}	
			
			rtn_client = value13[i]	==null?"":value13[i];  //거래처 (지점은??)	
			rent_s_cd = value14[i]	==null?"":value14[i];  //단기계약 건  관련  - 지연대차사고. 월렌트(예전), 정비대차   	
			
			if ( !rent_s_cd.equals("") )	{		
					//단기계약정보  - value1[i]: rent_st in('1', '2') -_rent_cont.bus_id  |   not in ('1', '2')  rent_cont.nvl(mng_id, bus_id)
					RentContBean rc_bean1 = rs_db.getRentContCase( value14[i], value11[i]);
					rtn_client = rc_bean1.getCust_id();			
			}
				
			if(!rtn_client.equals("")){
			
				client = al_db.getNewClient(rtn_client);
				ven_code = client.getVen_code();
				vendor = neoe_db.getVendorCase(ven_code);				
				client_st = client.getClient_st(); //2:개인
				foreigner=  client.getNationality();
				
				i_enp_no 		= client.getEnp_no1() + client.getEnp_no2() + client.getEnp_no3();
				if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() + client.getSsn2();
				i_ssn 			= client.getSsn1() + client.getSsn2();
				i_firm_nm 		= client.getFirm_nm();
				i_client_nm 	= client.getClient_nm();
				i_sta 			= Util.subData(client.getBus_cdt(),17);
				i_item 			= Util.subData(client.getBus_itm(),17);
				i_addr 			= client.getO_addr();
				i_agnt_nm		= client.getCon_agnt_nm();
				i_agnt_email	= client.getCon_agnt_email();
				i_agnt_m_tel	= client.getCon_agnt_m_tel();
					
				if(!site_id.equals("")){
					 if( !base2.getTax_type().equals("1")){ //본사가 아닌 경우
				
						//거래처지점정보
						ClientSiteBean site = al_db.getClientSite(rtn_client, site_id);
						s_ven_code = site.getVen_code();
						if(!s_ven_code.equals("")){
							ven_code = s_ven_code;
							vendor = neoe_db.getVendorCase(ven_code);		
							i_enp_no 		= site.getEnp_no();
							i_firm_nm 		= site.getR_site();
							i_client_nm 	= site.getSite_jang();
							i_sta 			= Util.subData(site.getBus_cdt(),17);
							i_item 			= Util.subData(site.getBus_itm(),17);
							i_addr 			= site.getAddr();
							i_agnt_nm		= site.getAgnt_nm();
							i_agnt_email	= site.getAgnt_email();
							i_agnt_m_tel 	= site.getAgnt_m_tel();
						}	
					}	
				}
				
				if(!value9[i].equals("")){		//월렌트제외										
						//네오엠 세금계산서
					if(base2.getTax_type().equals("1")){ //본사
						if(client_st.equals("2")){
								ven_type = "1";
								s_idno   =	i_ssn;	
												
						}else{
								ven_type = "0";
								s_idno   =	i_enp_no;		
						}
					}else{  //지점
						if(i_enp_no.length() == 13){
								ven_type = "1";
								s_idno	 = i_enp_no;
						}else{
								ven_type = "0";
								s_idno   =	i_enp_no;
						}
					}
				} else { //월렌트인경우
					if(client_st.equals("2")){
								ven_type = "1";
								s_idno   =	i_ssn;													
					}else{
								ven_type = "0";
								s_idno   =	i_enp_no;		
					}					
				}
											
		  	  }	
		
			  int est_amt = value6[i]	==null?0 :AddUtil.parseDigit(value6[i]);
			  int pay_amt = value7[i]	==null?0 :AddUtil.parseDigit(value7[i]);
					
			  if(pay_amt != 0){	
				if (s_neom.equals("Y")) {
					neom1 = "Y"; //보통예금 전표생성 
				}else {
					neom1 = "N"; //보통예금 전표생성 
				}
						
				//선수금 - 보증금, 선납금, 개시대여료 , 구매보조금  -- 2020년부터 개시대여료, 선납금일시납, 대여료일시납인 경우 외상매출금이 아닌 선수대여료 계정사용(공급가만 ), 부가세예수금 
				if( value0[i].equals("01") ){  //
					
					String SeqId = "";
					String cha_gubun = "";  // 면책금 여부 
					
					//선납금 균등 여우 
					if ( value16[i].equals("선납금") ) {			
					//대여정보
						ContFeeBean fee = a_db.getContFeeNew(value9[i], value10[i], value1[i]);
						pp_chk = fee.getPp_chk();
					}
					
					//선수금 자동전표생성					
					String acct_cont = "";
					
					if ( value16[i].equals("보증금")){
						acct_cont = "[장기대여보증금]"+ value10[i]+"("+client.getFirm_nm()+")";
					} else if (value16[i].equals("선납금")){				
						if (pp_chk.equals("0") ) {
							acct_cont = "[선납금 균등]"+ value10[i]+"("+client.getFirm_nm()+")";
						} else {
							acct_cont = "[선납금]"+ value10[i]+"("+client.getFirm_nm()+")";	
						}
					} else if (value16[i].equals("개시대여료")){
						acct_cont = "[개시대여료]"+ value10[i]+"("+client.getFirm_nm()+")";
					} else if (value16[i].equals("승계수수료")){
						acct_cont = "[승계수수료]"+ value10[i]+"("+client.getFirm_nm()+")";	
					} else if (value16[i].equals("구매보조금")){
						acct_cont = "[구매보조금]"+ value10[i]+"("+client.getFirm_nm()+")";		
					}	
					
					
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;
					
					//선수금
					Hashtable ht15 = new Hashtable();
					
					if ( value16[i].equals("보증금")){
					
						//보증금
						ht15.put("WRITE_DATE", 	incom_dt);  //row_id					
						ht15.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht15.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht15.put("CD_PC",  	node_code);  //회계단위
						ht15.put("CD_WDEPT",  dept_code);  //부서
						ht15.put("NO_DOCU",  	"");  //row_id와 같' 
						ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht15.put("CD_COMPANY",  "1000");  
						ht15.put("ID_WRITE", insert_id);   
						ht15.put("CD_DOCU",  "11");  
											
						ht15.put("DT_ACCT",  incom_dt);  
						ht15.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						ht15.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
						ht15.put("CD_ACCT",  "31100");   //장기대여보증금
						ht15.put("AMT",    	String.valueOf(pay_amt));	
						ht15.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체						
						ht15.put("CD_PARTNER",	ven_code); //거래처    - A06
												
						ht15.put("DT_START",  "");  	//발생일자									 
						ht15.put("CD_BIZAREA",		"");   //귀속사업장	
						ht15.put("CD_DEPT",		"");   //부서								 
						ht15.put("CD_CC",			"");   //코스트센터		
						ht15.put("CD_PJT",			"");   //프로젝트코드		
						ht15.put("CD_CARD",		"");   //신용카드		 
						ht15.put("CD_EMPLOY",		"");   //사원
						ht15.put("NO_DEPOSIT",	"");  //예적금계좌
						ht15.put("CD_BANK",		"");  //금융기관	
				 		ht15.put("NO_ITEM",		"");  //item	 
				 						// 부가세관련
						ht15.put("AM_TAXSTD",	"");  //과세표준액
						ht15.put("AM_ADDTAX",	"" );	 //세액
						ht15.put("TP_TAX",	"");  //과세(매출) :11
						ht15.put("NO_COMPANY",	""); //사업자등록번호
					
						ht15.put("NM_NOTE", acct_cont);  // 적요
					
					} else if ( value16[i].equals("선납금")){ //20191220 균등발행인 경우: 선수금 , 그외:외상매출금 
					
							//선납금 
							ht15.put("WRITE_DATE", 	incom_dt);  //row_id					
							ht15.put("ROW_NO",  	String.valueOf(line)); //row_no						
							ht15.put("NO_TAX",  	"*");  //부가세 이외는 *
							ht15.put("CD_PC",  	node_code);  //회계단위
							ht15.put("CD_WDEPT",  dept_code);  //부서
							ht15.put("NO_DOCU",  	"");  //row_id와 같' 
							ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
							ht15.put("CD_COMPANY",  "1000");  
							ht15.put("ID_WRITE", insert_id);   
							ht15.put("CD_DOCU",  "11");  
												
							ht15.put("DT_ACCT",  incom_dt);  
							ht15.put("ST_DOCU",  "1");  //미결:1, 승인:2  
							ht15.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
							
							if (pp_chk.equals("0") ) {
								ht15.put("CD_ACCT",  "25900");   //선납금 - 선수금
							} else {
								ht15.put("CD_ACCT",  "10800");   //선납금 - 외상매출금 
							}
							
							ht15.put("AMT",    	String.valueOf(pay_amt));	
							ht15.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체						
							ht15.put("CD_PARTNER",	ven_code); //거래처    - A06
													
							ht15.put("DT_START",  "");  	//발생일자									 
							ht15.put("CD_BIZAREA",		"");   //귀속사업장	
							ht15.put("CD_DEPT",		"");   //부서								 
							ht15.put("CD_CC",			"");   //코스트센터		
							ht15.put("CD_PJT",			"");   //프로젝트코드		
							ht15.put("CD_CARD",		"");   //신용카드		 
							ht15.put("CD_EMPLOY",		"");   //사원
							ht15.put("NO_DEPOSIT",	"");  //예적금계좌
							ht15.put("CD_BANK",		"");  //금융기관	
					 		ht15.put("NO_ITEM",		"");  //item	 
					 				
					 						// 부가세관련
							ht15.put("AM_TAXSTD",	"");  //과세표준액
							ht15.put("AM_ADDTAX",	"" );	 //세액
							ht15.put("TP_TAX",	"");  //과세(매출) :11
							ht15.put("NO_COMPANY",	""); //사업자등록번호
									
							ht15.put("NM_NOTE", acct_cont);  // 적요							
					 
					} else {
					
					    if ( cha_gubun.equals("Y") ) {
							
							//승계수수료	 또는 구매보조금  
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
						//	ht15.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
																					
							if ( value16[i].equals("구매보조금")){
									ht15.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
									if ( cr_bean.getCar_use().equals("1") ) { //렌트이면
										ht15.put("CD_ACCT",  "21810");     //구매보조금 	
										ht15.put("CD_PARTNER",	"996189"); //거래처    - A06										
									} else {
										ht15.put("CD_ACCT",  "22010");     //구매보조금
										ht15.put("CD_PARTNER",	ven_code); //거래처    - A06
									}
									ht15.put("AMT",    	String.valueOf(pay_amt));	
							} else {
							//	ht15.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
							//	ht15.put("CD_ACCT",  "91800");   //면책금(91800)
							//	ht15.put("CD_PARTNER",	ven_code); //거래처    - A06	
							//	ht15.put("AMT",    	String.valueOf(pay_amt));	
								
								ht15.put("TP_DRCR",  "1");   // 대변:2 , 차변:1
								ht15.put("CD_ACCT",  "45510");   //면책금(91800) -차량수리정비비(45510)로 계정처리 (20211116)
								ht15.put("CD_PARTNER",	ven_code); //거래처    - A06		
								ht15.put("AMT",    	String.valueOf(pay_amt *(-1)));	
							}						
														
				//			ht15.put("AMT",    	String.valueOf(pay_amt));	
							ht15.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체								
				//			ht15.put("CD_PARTNER",	ven_code); //거래처    - A06
														
							ht15.put("DT_START",  "");  	//발생일자									 
							ht15.put("CD_BIZAREA",		"");   //귀속사업장	
							ht15.put("CD_DEPT",		"");   //부서								 
							ht15.put("CD_CC",			"");   //코스트센터		
							ht15.put("CD_PJT",			"");   //프로젝트코드	
							ht15.put("CD_CARD",		"");   //신용카드		 	
							ht15.put("CD_EMPLOY",		"");   //사원									 		 
							ht15.put("NO_DEPOSIT",	"");  //예적금계좌
							ht15.put("CD_BANK",		"");  //금융기관	
				 			ht15.put("NO_ITEM",		"");  //item	  	
				 					
				 							// 부가세관련
							ht15.put("AM_TAXSTD",	"");  //과세표준액
							ht15.put("AM_ADDTAX",	"" );	 //세액
							ht15.put("TP_TAX",	"");  //과세(매출) :11
							ht15.put("NO_COMPANY",	""); //사업자등록번호 
						
							ht15.put("NM_NOTE", acct_cont);  // 적요						
					    
					    } else {
							//외상매출금
							
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
							ht15.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
							ht15.put("CD_ACCT",  "10800");   // 
							ht15.put("AMT",    	String.valueOf(pay_amt));	
							ht15.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체							
							ht15.put("CD_PARTNER",	ven_code); //거래처    - A06
														
							ht15.put("DT_START",  "");  	//발생일자										 
							ht15.put("CD_BIZAREA",		"");   //귀속사업장	
							ht15.put("CD_DEPT",		"");   //부서								 
							ht15.put("CD_CC",			"");   //코스트센터		
							ht15.put("CD_PJT",			"");   //프로젝트코드		
							ht15.put("CD_CARD",		"");   //신용카드		 	
							ht15.put("CD_EMPLOY",		"");   //사원									 		 
							ht15.put("NO_DEPOSIT",	"");  //예적금계좌
							ht15.put("CD_BANK",		"");  //금융기관	
				 			ht15.put("NO_ITEM",		"");  //item	  	  	
				 					
				 							// 부가세관련
							ht15.put("AM_TAXSTD",	"");  //과세표준액
							ht15.put("AM_ADDTAX",	"" );	 //세액
							ht15.put("TP_TAX",	"");  //과세(매출) :11
							ht15.put("NO_COMPANY",	""); //사업자등록번호 
						
							ht15.put("NM_NOTE", acct_cont);  // 적요		
												
						}			
					}
					
					if (s_neom.equals("Y")) {			
						vt.add(ht15);			
					}
				 						
				//대여료
				}else if(value0[i].equals("02")){
							
					//대여료 자동전표생성
					//분할이면서 site_id가 있는 경우
					int fee_rtn_cnt = in_db.getFeeRtnCnt(value9[i], value10[i]);
					if (fee_rtn_cnt > 0 ) {
						  String f_ven_code = in_db.getFeeRtnVencode(value9[i], value10[i], value1[i], value2[i] );
						  if ( !f_ven_code.equals("")) {
						 	  ven_code = f_ven_code;
							  vendor = neoe_db.getVendorCase(ven_code);		
						  }	  						
					}			  		      				                      				                
										
					String acct_cont = "";					
					if ( ip_method.equals("2") ) {
						 acct_cont = "[카드대여료]"+value3[i]+"회차:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					} else {
						 acct_cont = "[대여료]"+value3[i]+"회차:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					}
					
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;
					
					//외상매출금
					Hashtable ht2 = new Hashtable();
		
					ht2.put("WRITE_DATE", 	incom_dt);  //row_id				
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
					ht2.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
					ht2.put("CD_ACCT",  "10800");   // 
					ht2.put("AMT",    	String.valueOf(pay_amt));	
					ht2.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체					
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
						
					if (s_neom.equals("Y")) {				
						vt.add(ht2);
					}
										
					//20130117 반영	
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP") ||  card_nm.equals("KCP2") ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);
					 	} else 	if ( card_nm.equals("페이엣") ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);	
						} else 	if ( card_nm.equals("이노페이") ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);	
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}					
							
				//연체료
				}else if(value0[i].equals("03")){
					
					//연체료 자동전표생성	
					String acct_cont = "";					
					if ( ip_method.equals("2") ) {
					   acct_cont = "[카드연체료]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					} else {
					   acct_cont = "[연체료]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					}
					
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;
					
					//연체료수익
					Hashtable ht2 = new Hashtable();
					
					ht2.put("WRITE_DATE", 	incom_dt);  //row_id					
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
					ht2.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
					ht2.put("CD_ACCT",  "91300");   // 
					ht2.put("AMT",    	String.valueOf(pay_amt));	
					ht2.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체					
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
									
					if (s_neom.equals("Y")) {					
						vt.add(ht2);
					}
					
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP") ||  card_nm.equals("KCP2")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);			
					 	}  else if ( card_nm.equals("페이엣")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);	
						}  else if ( card_nm.equals("이노페이")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}	
					
					//과태료
				}else if(value0[i].equals("04")){
								
					//과태료 자동전표생성				
					
					String acct_cont = "";					
					if ( ip_method.equals("2") ) {
					  acct_cont = "[카드과태료]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") ";
					} else {
					  acct_cont = "[과태료]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") ";
					}
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}
					
					line++;					
					
					Hashtable ht14 = new Hashtable();
					
					ht14.put("WRITE_DATE", 	incom_dt);  //row_id				
					ht14.put("ROW_NO",  	String.valueOf(line)); //row_no					
					ht14.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht14.put("CD_PC",  	node_code);  //회계단위
					ht14.put("CD_WDEPT",  dept_code);  //부서
					ht14.put("NO_DOCU",  	"");  //row_id와 같게 
					ht14.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht14.put("CD_COMPANY",  "1000");  
					ht14.put("ID_WRITE", insert_id);   
					ht14.put("CD_DOCU",  "11");  
					
					ht14.put("DT_ACCT",  incom_dt);  
					ht14.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht14.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
					ht14.put("CD_ACCT",  "12400");   //과태료예수금(27400) : , 과태료미수금 (12400)
					ht14.put("AMT",    	String.valueOf(pay_amt));	
					ht14.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체						
					ht14.put("CD_PARTNER",	ven_code); //거래처    - A06
									
					ht14.put("DT_START",  "");  	//발생일자							 
					ht14.put("CD_BIZAREA",		"");   //귀속사업장	
					ht14.put("CD_DEPT",		"");   //부서								 
					ht14.put("CD_CC",			"");   //코스트센터		
					ht14.put("CD_PJT",			"");   //프로젝트코드		
					ht14.put("CD_CARD",		"");   //신용카드	
					ht14.put("CD_EMPLOY",		"");   //사원						
					ht14.put("NO_DEPOSIT",	 "");  //예적금계좌
					ht14.put("CD_BANK",		"");  //금융기관	
				 	ht14.put("NO_ITEM",		"");  //item
				 			
				 					// 부가세관련
					ht14.put("AM_TAXSTD",	"");  //과세표준액
					ht14.put("AM_ADDTAX",	"" );	 //세액
					ht14.put("TP_TAX",	"");  //과세(매출) :11
					ht14.put("NO_COMPANY",	""); //사업자등록번호
						
					ht14.put("NM_NOTE", acct_cont);  // 적요								
									
					if (s_neom.equals("Y")) {				
						vt.add(ht14);  // 과태료	
					}	
					
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP") ||  card_nm.equals("KCP2") ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);	
					  	}  else if ( card_nm.equals("페이엣")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);	
					 	}  else if ( card_nm.equals("이노페이")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);	
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}					
								
				//면책금
				}else if(value0[i].equals("05")){
																	
					//면책금 자동전표생성			
					String acct_cont = "";					
					if ( ip_method.equals("2") ) {
						 acct_cont = "[카드면책금]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					} else {
					     acct_cont = "[면책금]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
					}
					
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}							
														
					line++;
					
					Hashtable ht2 = new Hashtable();
					
					//외상매출금
					/* 현재는 더이상 사용안함 (면책금은 계산서 발행안함)
					if( cng_ins_ms.getBill_doc_yn().equals("1") ){  
					
						ht2.put("WRITE_DATE", 	incom_dt);  //row_id				
						ht2.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht2.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht2.put("CD_PC",  	node_code);  //회계단위
						ht2.put("CD_WDEPT",  dept_code);  //부서
						ht2.put("NO_DOCU",  	"");  //row_id 와 같게 
						ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht2.put("CD_COMPANY",  "1000");  
						ht2.put("ID_WRITE", insert_id);   
						ht2.put("CD_DOCU",  "11");  
						
						ht2.put("DT_ACCT",  incom_dt);  
						ht2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						ht2.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
						ht2.put("CD_ACCT",  "10800");   // 
						ht2.put("AMT",    	String.valueOf(pay_amt));	
						ht2.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체						
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
										
					//차량손해면책금
					}else{ */
					
						ht2.put("WRITE_DATE", 	incom_dt);  //row_id					
						ht2.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht2.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht2.put("CD_PC",  	node_code);  //회계단위
						ht2.put("CD_WDEPT",  dept_code);  //부서
						ht2.put("NO_DOCU",  	"");  //row_id 와 같게 						
						ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht2.put("CD_COMPANY",  "1000");  
						ht2.put("ID_WRITE",  insert_id);   
						ht2.put("CD_DOCU",  "11");  
						
						ht2.put("DT_ACCT",  incom_dt);  
						ht2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						//ht2.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
						//ht2.put("CD_ACCT",  "91800");   //면책금(91800)
						//ht2.put("AMT",    	String.valueOf(pay_amt));	
						
						ht2.put("TP_DRCR",  "1");   // 대변:2 , 차변:1
						ht2.put("CD_ACCT",  "45510");   //면책금(91800) - 차량수리정비비(45510)으로 대체(20211116)
						ht2.put("AMT",    	String.valueOf(pay_amt*(-1)));	
						
						
						ht2.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체							
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
					
				/*	} */
					
					if (s_neom.equals("Y")) {	
						vt.add(ht2);
					}	
				
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP")  || card_nm.equals("KCP2")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);		
					  	}  else if ( card_nm.equals("페이엣")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);		
						}  else if ( card_nm.equals("이노페이")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);			
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}
							
					//휴/대차료
				}else if(value0[i].equals("06") ||  value0[i].equals("07") ){
								
					//청구서 발행안함 - - 강제 휴차료 처리 - 20211206 
				//	if ( value15[i].equals("1")) 	value4[i] = "1";
															
					// 휴/대차료 자동전표생성					
					String acct_cont = "";					
					
					if (value0[i].equals("06")){
				//	if (value4[i].equals("1")){
						acct_cont = "[휴차료]"+ value10[i]+"("+cr_bean.getCar_no()+")";
					} else if (value4[i].equals("2")){
						acct_cont = "[대차료]"+ value10[i]+"("+cr_bean.getCar_no()+")";
					}	
						
					if(doc_cont.equals("")){
						doc_cont = acct_cont;
					}					
												
					line++;
					
					//휴/대차료
					Hashtable ht3 = new Hashtable();
										
					//외상매출금 -- 대차료
					if (value0[i].equals("07")){
				//	if (value4[i].equals("2")){
					
						ht3.put("WRITE_DATE", 	incom_dt);  //row_id						
						ht3.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht3.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht3.put("CD_PC",  	node_code);  //회계단위
						ht3.put("CD_WDEPT",  dept_code);  //부서
						ht3.put("NO_DOCU",  	"");  //row_id와 같게 
						ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht3.put("CD_COMPANY",  "1000");  
						ht3.put("ID_WRITE", insert_id);   
						ht3.put("CD_DOCU",  "11");  
						
						ht3.put("DT_ACCT",  incom_dt);  
						ht3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						ht3.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
						ht3.put("CD_ACCT",  "10800");   // 
						ht3.put("AMT",    	String.valueOf(pay_amt));	
						ht3.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체						
						ht3.put("CD_PARTNER",	ven_code); //거래처    - A06
												
						ht3.put("DT_START",  "");  	//발생일자									 
						ht3.put("CD_BIZAREA",		"");   //귀속사업장	
						ht3.put("CD_DEPT",			"");   //부서								 
						ht3.put("CD_CC",			"");   //코스트센터		
						ht3.put("CD_PJT",			"");   //프로젝트코드	
						ht3.put("CD_CARD",		"");   //신용카드		
						ht3.put("CD_EMPLOY",		"");   //사원								 		 
						ht3.put("NO_DEPOSIT",	"");  //예적금계좌
						ht3.put("CD_BANK",		"");  //금융기관	
				 		ht3.put("NO_ITEM",		"");  //item	 
				 				
				 						// 부가세관련
						ht3.put("AM_TAXSTD",	"");  //과세표준액
						ht3.put("AM_ADDTAX",	"" );	 //세액
						ht3.put("TP_TAX",	"");  //과세(매출) :11
						ht3.put("NO_COMPANY",	""); //사업자등록번호
							
						ht3.put("NM_NOTE", acct_cont);  // 적요							
					
					//차량손해면책금 - 휴차료처리 
					}else{
					
						ht3.put("WRITE_DATE", 	incom_dt);  //row_id				
						ht3.put("ROW_NO",  	String.valueOf(line)); //row_no						
						ht3.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht3.put("CD_PC",  	node_code);  //회계단위
						ht3.put("CD_WDEPT",  dept_code);  //부서
						ht3.put("NO_DOCU",  	"");  //row_id와 같게 
						ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht3.put("CD_COMPANY",  "1000");  
						ht3.put("ID_WRITE", insert_id);   
						ht3.put("CD_DOCU",  "11");  
						
						ht3.put("DT_ACCT",  incom_dt);  
						ht3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						//ht3.put("TP_DRCR",  amt_gubun);   // 대변:2 , 차변:1
						//ht3.put("CD_ACCT",  "91800");   //면책금(91800)
						//ht3.put("AMT",    	String.valueOf(pay_amt));	
						ht3.put("TP_DRCR",  "1");   // 대변:2 , 차변:1
						ht3.put("CD_ACCT",  "45510");   //면책금(91800)
						ht3.put("AMT",    	String.valueOf(pay_amt*(-1)));	
						
						ht3.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체						
						ht3.put("CD_PARTNER",	ven_code); //거래처    - A06
												
						ht3.put("DT_START",  "");  	//발생일자									 
						ht3.put("CD_BIZAREA",		"");   //귀속사업장	
						ht3.put("CD_DEPT",			"");   //부서								 
						ht3.put("CD_CC",			"");   //코스트센터		
						ht3.put("CD_PJT",			"");   //프로젝트코드		
						ht3.put("CD_CARD",		"");   //신용카드		
						ht3.put("CD_EMPLOY",		"");   //사원															 		 
						ht3.put("NO_DEPOSIT",	"");  //예적금계좌
						ht3.put("CD_BANK",		"");  //금융기관	
				 		ht3.put("NO_ITEM",		"");  //item	 
				 				
				 				// 부가세관련
						ht3.put("AM_TAXSTD",	"");  //과세표준액
						ht3.put("AM_ADDTAX",	"" );	 //세액
						ht3.put("TP_TAX",	"");  //과세(매출) :11
						ht3.put("NO_COMPANY",	""); //사업자등록번호	 
					
						ht3.put("NM_NOTE", acct_cont);  // 적요						
					
					}
					
					if (s_neom.equals("Y")) {					
						vt.add(ht3);				
					}
				
					//전표재발행은 정비대차만 처리 - 카드처리??
				}else if(value0[i].equals("10")){
			
					
					//월렌트료 자동전표생성 - 카드인 경우 매출로 부가세.... 추가할 것 				
					String acct_cont = "";
									
					acct_cont = "[정비대차]" + cr_bean.getCar_no() + "(" + client.getFirm_nm() + ")";
							
					if (doc_cont.equals("")) {
						doc_cont = acct_cont;
					}
		
					line++;
		
					Hashtable ht44 = new Hashtable();

					ht44.put("WRITE_DATE", incom_dt); //row_id						
					ht44.put("ROW_NO", String.valueOf(line)); //row_no						
					ht44.put("NO_TAX", "*"); //부가세 이외는 *
					ht44.put("CD_PC", node_code); //회계단위
					ht44.put("CD_WDEPT", dept_code); //부서
					ht44.put("NO_DOCU", ""); //row_id와 같게 
					ht44.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
					ht44.put("CD_COMPANY", "1000");
					ht44.put("ID_WRITE", insert_id);
					ht44.put("CD_DOCU", "11");

					ht44.put("DT_ACCT", incom_dt);
					ht44.put("ST_DOCU", "1"); //미결:1, 승인:2  
					ht44.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
					ht44.put("CD_ACCT", "10800"); // 외상매출금 (월렌트대여료, 정비대차)
					ht44.put("AMT", String.valueOf(pay_amt));
					ht44.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체						
					ht44.put("CD_PARTNER", ven_code); //거래처    - A06

					ht44.put("DT_START", ""); //발생일자									 
					ht44.put("CD_BIZAREA", ""); //귀속사업장	
					ht44.put("CD_DEPT", ""); //부서								 
					ht44.put("CD_CC", ""); //코스트센터		
					ht44.put("CD_PJT", ""); //프로젝트코드	
					ht44.put("CD_CARD", ""); //신용카드		
					ht44.put("CD_EMPLOY", ""); //사원								 		 
					ht44.put("NO_DEPOSIT", ""); //예적금계좌
					ht44.put("CD_BANK", ""); //금융기관	
					ht44.put("NO_ITEM", ""); //item	 

					// 부가세관련
					ht44.put("AM_TAXSTD", ""); //과세표준액
					ht44.put("AM_ADDTAX", ""); //세액
					ht44.put("TP_TAX", ""); //과세(매출) :11
					ht44.put("NO_COMPANY", ""); //사업자등록번호

					ht44.put("NM_NOTE", acct_cont); // 적요							

					if (s_neom.equals("Y")) {
						vt.add(ht44); // 정비대차인경우
					}	
					
					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP")  || card_nm.equals("KCP2")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);		
					  	}  else if ( card_nm.equals("페이엣")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);		
						}  else if ( card_nm.equals("이노페이")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);			
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}

					//해지정산금
				} else if (value0[i].equals("09")) {
					//재발행은 세분화할수 없음.
					//월렌트료 자동전표생성 - 카드인 경우 매출로 부가세.... 추가할 것 				
					String acct_cont = "";
									
					acct_cont = "[해지정산]" + cr_bean.getCar_no() + "(" + client.getFirm_nm() + ")";
							
					if (doc_cont.equals("")) {
						doc_cont = acct_cont;
					}
					
					line++;
					
					Hashtable ht11 = new Hashtable();
		
					ht11.put("WRITE_DATE", incom_dt); //row_id	
					ht11.put("ROW_NO", String.valueOf(line)); //row_no		
					ht11.put("NO_TAX", "*"); //부가세 이외는 *
					ht11.put("CD_PC", node_code); //회계단위
					ht11.put("CD_WDEPT", dept_code); //부서
					ht11.put("NO_DOCU", ""); //row_id와 같게 
					ht11.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
					ht11.put("CD_COMPANY", "1000");
					ht11.put("ID_WRITE", insert_id);
					ht11.put("CD_DOCU", "11");
		
					ht11.put("DT_ACCT", incom_dt);
					ht11.put("ST_DOCU", "1"); //미결:1, 승인:2  					
					ht11.put("TP_DRCR", amt_gubun);//대변
					ht11.put("CD_ACCT", "25700"); // 가수금 --> (20200410수정 )
				//	ht21.put("CD_ACCT", "93000"); // 가수금 --> 잡이익으로 처리(20200101부터 )
					ht11.put("AMT", String.valueOf(pay_amt));
					ht11.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체				
		
					if (card_nm.equals("KCP") || card_nm.equals("KCP2")) {
						ht11.put("CD_PARTNER", "105320"); //거래처    - A06  한국사이버결재(KCP)
					} else if (card_nm.equals("페이엣")) {
						ht11.put("CD_PARTNER", "996282"); //거래처    - 페이엣(payat)		
					} else if (card_nm.equals("나이스")) {
						ht11.put("CD_PARTNER", "996283"); //거래처    - 나이스 	
					} else if (card_nm.equals("이노페이")) {
						ht11.put("CD_PARTNER", "996548"); //거래처    - 이노페이 		
					} else {
						ht11.put("CD_PARTNER", "109691"); //거래처    - A06		
					}
		
					ht11.put("DT_START", ""); //발생일자				 
					ht11.put("CD_BIZAREA", ""); //귀속사업장	
					ht11.put("CD_DEPT", ""); //부서								 
					ht11.put("CD_CC", ""); //코스트센터		
					ht11.put("CD_PJT", ""); //프로젝트코드	
					ht11.put("CD_CARD", ""); //신용카드		 		 	
					ht11.put("CD_EMPLOY", ""); //사원	
					ht11.put("NO_DEPOSIT", ""); //예적금계좌
					ht11.put("CD_BANK", ""); //금융기관	
					ht11.put("NO_ITEM", ""); //item   	
		
					// 부가세관련
					ht11.put("AM_TAXSTD", ""); //과세표준액
					ht11.put("AM_ADDTAX", ""); //세액
					ht11.put("TP_TAX", ""); //과세(매출) :11
					ht11.put("NO_COMPANY", ""); //사업자등록번호	  	 	 
		
					ht11.put("NM_NOTE", doc_cont); // 적요	
					
					if (s_neom.equals("Y")) {
						vt.add(ht11); // 해지정산금
					}					

					if ( ip_method.equals("2")  ) {
					 	if ( card_nm.equals("KCP")  || card_nm.equals("KCP2")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.037);		
					  	}  else if ( card_nm.equals("페이엣")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.032);		
						}  else if ( card_nm.equals("이노페이")  ) {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.027);			
					 	} else {
					 		cal_tax = 	in_db.getCalTax(pay_amt, 0.022);					 		
					 	}
					 	a_cal_tax = a_cal_tax + cal_tax;								
					}	
					
				} //해지정산금

			} //pay_amt > 0
			out.println("<br>");
		} //end for 

		if (line > 1) {
			doc_cont = doc_cont + " 외";
		}
	}

	if (neom.equals("Y")) {
	
		if (ip_acct.equals("0")) {

			line++;

			String acc_cont = "[선수금]" + "-" + n_ven_name + " " + remark;

			if (acct_gubun.equals("D")) {
				t_pay_amt = ip_acct_amt * (-1);
			} else {
				t_pay_amt = ip_acct_amt;
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //차변 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			//선수금
			Hashtable ht25 = new Hashtable();

			ht25.put("WRITE_DATE", incom_dt); //row_id			
			ht25.put("ROW_NO", String.valueOf(line)); //row_no			
			ht25.put("NO_TAX", "*"); //부가세 이외는 *
			ht25.put("CD_PC", node_code); //회계단위
			ht25.put("CD_WDEPT", dept_code); //부서
			ht25.put("NO_DOCU", ""); //row_id와 같게 
			ht25.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
			ht25.put("CD_COMPANY", "1000");
			ht25.put("ID_WRITE", insert_id);
			ht25.put("CD_DOCU", "11");

			ht25.put("DT_ACCT", incom_dt);
			ht25.put("ST_DOCU", "1"); //미결:1, 승인:2  

			if (acct_gubun.equals("D")) {
				ht25.put("TP_DRCR", amt_gubun); //차변		
			} else {
				ht25.put("TP_DRCR", amt_gubun); //대변				
			}

			ht25.put("CD_ACCT", "25900"); //선수금
			ht25.put("AMT", String.valueOf(t_pay_amt));
			ht25.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체			
			ht25.put("CD_PARTNER", n_ven_code); //거래처    - A06

			ht25.put("DT_START", incom_dt); //발생일자					 
			ht25.put("CD_BIZAREA", ""); //귀속사업장	
			ht25.put("CD_DEPT", ""); //부서								 
			ht25.put("CD_CC", ""); //코스트센터		
			ht25.put("CD_PJT", ""); //프로젝트코드	
			ht25.put("CD_CARD", ""); //신용카드			
			ht25.put("CD_EMPLOY", ""); //사원					 		 
			ht25.put("NO_DEPOSIT", ""); //예적금계좌
			ht25.put("CD_BANK", ""); //금융기관	
			ht25.put("NO_ITEM", ""); //item 	 

			// 부가세관련
			ht25.put("AM_TAXSTD", ""); //과세표준액
			ht25.put("AM_ADDTAX", ""); //세액
			ht25.put("TP_TAX", ""); //과세(매출) :11
			ht25.put("NO_COMPANY", ""); //사업자등록번호

			ht25.put("NM_NOTE", acc_cont); // 적요				

			vt.add(ht25);
		}

		//  캐쉬백으로 선택시 
		if (ip_acct.equals("6") || ip_acct.equals("17")) {

			line++;

			String acc_cont = "[캐쉬백]" + "-" + n_ven_name + " " + remark;

			if (acct_gubun.equals("D")) {
				t_pay_amt = ip_acct_amt * (-1);
			} else {
				t_pay_amt = ip_acct_amt;
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //차변 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			//캐쉬백
			Hashtable ht31 = new Hashtable();

			ht31.put("WRITE_DATE", incom_dt); //row_id		
			ht31.put("ROW_NO", String.valueOf(line)); //row_no

			ht31.put("NO_TAX", "*"); //부가세 이외는 *
			ht31.put("CD_PC", node_code); //회계단위
			ht31.put("CD_WDEPT", dept_code); //부서
			ht31.put("NO_DOCU", ""); // row_id와 같게 
			ht31.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
			ht31.put("CD_COMPANY", "1000");
			ht31.put("ID_WRITE", insert_id);
			ht31.put("CD_DOCU", "11");

			ht31.put("DT_ACCT", incom_dt);
			ht31.put("ST_DOCU", "1"); //미결:1, 승인:2  

			if (acct_gubun.equals("D")) {
				ht31.put("TP_DRCR", amt_gubun); //차변		
			} else {
				ht31.put("TP_DRCR", amt_gubun); //대변				
			}

			ht31.put("CD_ACCT", "91100"); //카드캐쉬백
			ht31.put("AMT", String.valueOf(t_pay_amt));
			ht31.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체				
			ht31.put("CD_PARTNER", n_ven_code); //거래처    - A06

			ht31.put("DT_START", ""); //발생일자					 
			ht31.put("CD_BIZAREA", ""); //귀속사업장	
			ht31.put("CD_DEPT", ""); //부서								 
			ht31.put("CD_CC", ""); //코스트센터		
			ht31.put("CD_PJT", ""); //프로젝트코드	
			ht31.put("CD_CARD", ""); //신용카드		 		 	
			ht31.put("CD_EMPLOY", ""); //사원	
			ht31.put("NO_DEPOSIT", ""); //예적금계좌
			ht31.put("CD_BANK", ""); //금융기관	
			ht31.put("NO_ITEM", ""); //item 	 

			// 부가세관련
			ht31.put("AM_TAXSTD", ""); //과세표준액
			ht31.put("AM_ADDTAX", ""); //세액
			ht31.put("TP_TAX", ""); //과세(매출) :11
			ht31.put("NO_COMPANY", ""); //사업자등록번호	 

			ht31.put("NM_NOTE", acc_cont); // 적요				

			vt.add(ht31);
		}

		//  국가장려금 으로 선택시 ->직원급여 (80200) 차변 -  
		if (ip_acct.equals("22")) {

			line++;

			String acc_cont = "[청년고용장려금]" + "-" + n_ven_name + " " + remark;

			if (acct_gubun.equals("D")) {
				t_pay_amt = ip_acct_amt * (-1);
			} else {
				t_pay_amt = ip_acct_amt;
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //차변 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			//국가장려금
			Hashtable ht37 = new Hashtable();

			ht37.put("WRITE_DATE", incom_dt); //row_id		
			ht37.put("ROW_NO", String.valueOf(line)); //row_no

			ht37.put("NO_TAX", "*"); //부가세 이외는 *
			ht37.put("CD_PC", node_code); //회계단위
			ht37.put("CD_WDEPT", dept_code); //부서
			ht37.put("NO_DOCU", ""); // row_id와 같게 
			ht37.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
			ht37.put("CD_COMPANY", "1000");
			ht37.put("ID_WRITE", insert_id);
			ht37.put("CD_DOCU", "11");

			ht37.put("DT_ACCT", incom_dt);
			ht37.put("ST_DOCU", "1"); //미결:1, 승인:2  

			if (acct_gubun.equals("D")) {
				ht37.put("TP_DRCR", amt_gubun); //차변		
			} else {
				ht37.put("TP_DRCR", amt_gubun); //대변				
			}

			ht37.put("CD_ACCT", "80200"); // 직원급여 계정 
			ht37.put("AMT", String.valueOf(t_pay_amt));
			ht37.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체				
			ht37.put("CD_PARTNER", n_ven_code); //거래처    - A06

			ht37.put("DT_START", ""); //발생일자					 
			ht37.put("CD_BIZAREA", ""); //귀속사업장	
			ht37.put("CD_DEPT", ""); //부서								 
			ht37.put("CD_CC", ""); //코스트센터		
			ht37.put("CD_PJT", ""); //프로젝트코드	
			ht37.put("CD_CARD", ""); //신용카드		 		 	
			ht37.put("CD_EMPLOY", ""); //사원	
			ht37.put("NO_DEPOSIT", ""); //예적금계좌
			ht37.put("CD_BANK", ""); //금융기관	
			ht37.put("NO_ITEM", ""); //item 	 

			// 부가세관련
			ht37.put("AM_TAXSTD", ""); //과세표준액
			ht37.put("AM_ADDTAX", ""); //세액
			ht37.put("TP_TAX", ""); //과세(매출) :11
			ht37.put("NO_COMPANY", ""); //사업자등록번호	 

			ht37.put("NM_NOTE", acc_cont); // 적요				

			vt.add(ht37);
		}

		// 가지급금
		if (ip_acct.equals("11")) {
			
			line++;

			String acc_cont = "[가지급금]" + "-" + n_ven_name + " " + remark;

			if (acct_gubun.equals("D")) {
				t_pay_amt = ip_acct_amt * (-1);
			} else {
				t_pay_amt = ip_acct_amt;
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //차변 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			// 가지급금
			Hashtable ht36 = new Hashtable();

			ht36.put("WRITE_DATE", incom_dt); //row_id			
			ht36.put("ROW_NO", String.valueOf(line)); //row_no

			ht36.put("NO_TAX", "*"); //부가세 이외는 *
			ht36.put("CD_PC", node_code); //회계단위
			ht36.put("CD_WDEPT", dept_code); //부서
			ht36.put("NO_DOCU", ""); //row_id와 같게 
			ht36.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
			ht36.put("CD_COMPANY", "1000");
			ht36.put("ID_WRITE", insert_id);
			ht36.put("CD_DOCU", "11");

			ht36.put("DT_ACCT", incom_dt);
			ht36.put("ST_DOCU", "1"); //미결:1, 승인:2  

			if (acct_gubun.equals("D")) {
				ht36.put("TP_DRCR", amt_gubun); //차변		
			} else {
				ht36.put("TP_DRCR", amt_gubun); //대변				
			}

			ht36.put("CD_ACCT", "13400"); // 가지급금
			ht36.put("AMT", String.valueOf(t_pay_amt));
			ht36.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체				
			ht36.put("CD_PARTNER", n_ven_code); //거래처    - A06

			ht36.put("DT_START", incom_dt); //발생일자					 
			ht36.put("CD_BIZAREA", ""); //귀속사업장	
			ht36.put("CD_DEPT", ""); //부서								 
			ht36.put("CD_CC", ""); //코스트센터		
			ht36.put("CD_PJT", ""); //프로젝트코드	
			ht36.put("CD_CARD", ""); //신용카드		 		 	
			ht36.put("CD_EMPLOY", ""); //사원
			ht36.put("NO_DEPOSIT", ""); //예적금계좌
			ht36.put("CD_BANK", ""); //금융기관	
			ht36.put("NO_ITEM", ""); //item 	

			// 부가세관련
			ht36.put("AM_TAXSTD", ""); //과세표준액
			ht36.put("AM_ADDTAX", ""); //세액
			ht36.put("TP_TAX", ""); //과세(매출) :11
			ht36.put("NO_COMPANY", ""); //사업자등록번호    	 

			ht36.put("NM_NOTE", acc_cont); // 적요			

			vt.add(ht36);

		}

		// 사고수리비 - 과실 확정후 보험회사 수리비 입금건 - , 19:사고수리비. 20:운반비 , 18:이자수익 - 차변:환급분, 대변: 납부할금액  
		// 1:승계수수료 2:채권추심수수료, 3:과입금으로 인한 고객환불 , 4:면책금, 12: 잡이익, 16:단기차입금 - 차변:환급분, 대변: 납부할금액 , 13: 과태료 미수금  , 14:선급금, 15:미수금 10:미지급금 , 9:지급수수료 , 8:외상매출금 , 7:세금과공과 , 5:가수금 ㅡ 22:국가장려금 
		// 24:주임종장기차입금, 25:관계회사장기차입금, 26:의무보험료
		if (ip_acct.equals("1") || ip_acct.equals("2") || ip_acct.equals("3") || ip_acct.equals("4")
				|| ip_acct.equals("5") || ip_acct.equals("7") || ip_acct.equals("8") || ip_acct.equals("9")
				|| ip_acct.equals("10") || ip_acct.equals("12") || ip_acct.equals("13") || ip_acct.equals("14")
				|| ip_acct.equals("15") || ip_acct.equals("18") || ip_acct.equals("19") || ip_acct.equals("20")
				|| ip_acct.equals("16") || ip_acct.equals("21")  || ip_acct.equals("23") || ip_acct.equals("24") 
				|| ip_acct.equals("25") || ip_acct.equals("26") ) {

			line++;

			String acc_cont = "";
			String acct_code = "";

			if (ip_acct.equals("19")) { // 사고수리비(45600) -> 차량수리정비비(45510)
				acc_cont = "[사고수리비]" + "-" + n_ven_name + " " + remark;
				acct_code = "45510";
			} else if (ip_acct.equals("1")) {
				acc_cont = "[승계수수료]" + "-" + n_ven_name + " " + remark;
				acct_code = "45510"; //면책금		  		  		 
			} else if (ip_acct.equals("2")) {
				acc_cont = "[채권추심수수료]" + "-" + n_ven_name + " " + remark;
				acct_code = "25300"; //미지급금 	  		 
			} else if (ip_acct.equals("3")) {
				acc_cont = "[과입금 환불]" + "-" + n_ven_name + " " + remark;
				acct_code = "25300"; //미지급금  
			} else if (ip_acct.equals("4")) { // 면책금(91800) -> 차량수리정비비(45510)
				acc_cont = "[면책금]" + "-" + n_ven_name + " " + remark;
				acct_code = "45510";
			} else if (ip_acct.equals("5")) {
				acc_cont = "[가수금]" + "-" + n_ven_name + " " + remark;
				acct_code = "25700";
			} else if (ip_acct.equals("7")) {
				acc_cont = "[세금과공과]" + "-" + n_ven_name + " " + remark;
				acct_code = "46300";
			} else if (ip_acct.equals("8")) {
				acc_cont = "[외상매출금]" + "-" + n_ven_name + " " + remark;
				acct_code = "10800";
			} else if (ip_acct.equals("9")) {
				acc_cont = "[지급수수료]" + "-" + n_ven_name + " " + remark;
				acct_code = "83100";
			} else if (ip_acct.equals("10")) {
				acc_cont = "[미지급금]" + "-" + n_ven_name + " " + remark;
				acct_code = "25300";
			} else if (ip_acct.equals("12")) {
				acc_cont = "[잡이익]" + "-" + n_ven_name + " " + remark;
				acct_code = "93000";
			} else if (ip_acct.equals("13")) {
				acc_cont = "[과태료미수금]" + "-" + n_ven_name + " " + remark;
				acct_code = "12400";
			} else if (ip_acct.equals("14")) {
				acc_cont = "[선급금]" + "-" + n_ven_name + " " + remark;
				acct_code = "13100";
			} else if (ip_acct.equals("15")) {
				acc_cont = "[미수금]" + "-" + n_ven_name + " " + remark;
				acct_code = "12000";
			} else if (ip_acct.equals("16")) {
				acc_cont = "[단기차입금]" + "-" + n_ven_name + " " + remark;
				acct_code = "26000";
			} else if (ip_acct.equals("18")) {
				acc_cont = "[이자수익]" + "-" + n_ven_name + " " + remark;
				acct_code = "90100";
			} else if (ip_acct.equals("20")) {
				acc_cont = "[운반비]" + "-" + n_ven_name + " " + remark;
				acct_code = "46400";
			} else if (ip_acct.equals("21")) {
				acc_cont = "[여비교통비]" + "-" + n_ven_name + " " + remark;
				acct_code = "81200";
			} else if (ip_acct.equals("23")) {  // 차량정비비(45700) -> 차량수리정비비(45510)
				acc_cont = "[차량정비비]" + "-" + n_ven_name + " " + remark;
				acct_code = "45510";
			//	System.out.println("acc_cont=" + acc_cont);
			} else if (ip_acct.equals("24")) {
				acc_cont = "[주임종장기차입금]" + "-" + n_ven_name + " " + remark;
				acct_code = "30300";
			} else if (ip_acct.equals("25")) {
				acc_cont = "[관계회사장기차입금]" + "-" + n_ven_name + " " + remark;
				acct_code = "30400";
			} else if (ip_acct.equals("26")) {
				acc_cont = "[의무보험료]" + "-" + n_ven_name + " " + remark;
				acct_code = "46200";
			}

			//채권추심인 경우 
			if (ip_acct.equals("2")) {
				if (acct_gubun.equals("D")) {
					t_pay_amt = ip_acct_amt;
				} else {
					t_pay_amt = ip_acct_amt * (-1);
				}
			} else {
				if (acct_gubun.equals("D")) {
					t_pay_amt = ip_acct_amt * (-1);
				} else {
					t_pay_amt = ip_acct_amt;
				}
			}

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}
		
			System.out.println("doc_cont=" + doc_cont);
					
			if (ip_method.equals("3")) {
				docu_gubun = "1";
				amt_gubun = "1";
			} else {
				if (acct_gubun.equals("D")) { //차변 
					docu_gubun = "3";
					amt_gubun = "1";
				} else {
					docu_gubun = "3";
					amt_gubun = "2";
				}
			}

			Hashtable ht43 = new Hashtable();

			ht43.put("WRITE_DATE", incom_dt); //row_id			
			ht43.put("ROW_NO", String.valueOf(line)); //row_no			
			ht43.put("NO_TAX", "*"); //부가세 이외는 *
			ht43.put("CD_PC", node_code); //회계단위
			ht43.put("CD_WDEPT", dept_code); //부서
			ht43.put("NO_DOCU", ""); //row_id와 같게 
			ht43.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
			ht43.put("CD_COMPANY", "1000");
			ht43.put("ID_WRITE", insert_id);
			ht43.put("CD_DOCU", "11");

			ht43.put("DT_ACCT", incom_dt);
			ht43.put("ST_DOCU", "1"); //미결:1, 승인:2  

			if (acct_gubun.equals("D")) {
				ht43.put("TP_DRCR", amt_gubun); //차변		
			} else {
				ht43.put("TP_DRCR", amt_gubun); //대변				
			}

			ht43.put("CD_ACCT", acct_code);
			ht43.put("AMT", String.valueOf(t_pay_amt));
			ht43.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체				
			ht43.put("CD_PARTNER", n_ven_code); //거래처    - A06

			ht43.put("DT_START", incom_dt); //발생일자					 
			ht43.put("CD_BIZAREA", ""); //귀속사업장	
			ht43.put("CD_DEPT", ""); //부서								 
			ht43.put("CD_CC", ""); //코스트센터		
			ht43.put("CD_PJT", ""); //프로젝트코드	익
			ht43.put("CD_CARD", ""); //신용카드		 		 	
			ht43.put("CD_EMPLOY", ""); //사원	
			ht43.put("NO_DEPOSIT", ""); //예적금계좌
			ht43.put("CD_BANK", ""); //금융기관	
			ht43.put("NO_ITEM", ""); //item   	

			// 부가세관련
			ht43.put("AM_TAXSTD", ""); //과세표준액
			ht43.put("AM_ADDTAX", ""); //세액
			ht43.put("TP_TAX", ""); //과세(매출) :11
			ht43.put("NO_COMPANY", ""); //사업자등록번호		  	 	 

			ht43.put("NM_NOTE", acc_cont); // 적요	

			vt.add(ht43);
		}

	}

	//카드 수수료
	if (ip_method.equals("2")) {

		if (card_tax > 0) {

			line++;

			String acc_cont = "[카드수수료]" + "(" + i_firm_nm + ")" + card_nm;

			if (doc_cont.equals("")) {
				doc_cont = acc_cont;
			}

			//수수료는 가수금

			//수수료
			Hashtable ht21 = new Hashtable();

			ht21.put("WRITE_DATE", incom_dt); //row_id	
			ht21.put("ROW_NO", String.valueOf(line)); //row_no		
			ht21.put("NO_TAX", "*"); //부가세 이외는 *
			ht21.put("CD_PC", node_code); //회계단위
			ht21.put("CD_WDEPT", dept_code); //부서
			ht21.put("NO_DOCU", ""); //row_id와 같게 
			ht21.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
			ht21.put("CD_COMPANY", "1000");
			ht21.put("ID_WRITE", insert_id);
			ht21.put("CD_DOCU", "11");

			ht21.put("DT_ACCT", incom_dt);
			ht21.put("ST_DOCU", "1"); //미결:1, 승인:2  					
			ht21.put("TP_DRCR", amt_gubun);//대변
			ht21.put("CD_ACCT", "25700"); // 가수금 --> (20200410수정 )
		//	ht21.put("CD_ACCT", "93000"); // 가수금 --> 잡이익으로 처리(20200101부터 )
			ht21.put("AMT", String.valueOf(card_tax));
			ht21.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체				

			if (card_nm.equals("KCP") || card_nm.equals("KCP2")) {
				ht21.put("CD_PARTNER", "105320"); //거래처    - A06  한국사이버결재(KCP)
			} else if (card_nm.equals("페이엣")) {
				ht21.put("CD_PARTNER", "996282"); //거래처    - 페이엣(payat)		
			} else if (card_nm.equals("나이스")) {
				ht21.put("CD_PARTNER", "996283"); //거래처    - 나이스 	
			} else if (card_nm.equals("이노페이")) {
				ht21.put("CD_PARTNER", "996548"); //거래처    - 이노페이 		
			} else {
				ht21.put("CD_PARTNER", "109691"); //거래처    - A06		
			}

			ht21.put("DT_START", ""); //발생일자				 
			ht21.put("CD_BIZAREA", ""); //귀속사업장	
			ht21.put("CD_DEPT", ""); //부서								 
			ht21.put("CD_CC", ""); //코스트센터		
			ht21.put("CD_PJT", ""); //프로젝트코드	
			ht21.put("CD_CARD", ""); //신용카드		 		 	
			ht21.put("CD_EMPLOY", ""); //사원	
			ht21.put("NO_DEPOSIT", ""); //예적금계좌
			ht21.put("CD_BANK", ""); //금융기관	
			ht21.put("NO_ITEM", ""); //item   	

			// 부가세관련
			ht21.put("AM_TAXSTD", ""); //과세표준액
			ht21.put("AM_ADDTAX", ""); //세액
			ht21.put("TP_TAX", ""); //과세(매출) :11
			ht21.put("NO_COMPANY", ""); //사업자등록번호	  	 	 

			ht21.put("NM_NOTE", acc_cont); // 적요	

			vt.add(ht21);
		}

	}

	if (ip_method.equals("2")) {
		line++;

		//카드 미수금
		Hashtable ht22 = new Hashtable();

		ht22.put("WRITE_DATE", incom_dt); //row_id	
		ht22.put("ROW_NO", String.valueOf(line)); //row_no		
		ht22.put("NO_TAX", "*"); //부가세 이외는 *
		ht22.put("CD_PC", node_code); //회계단위
		ht22.put("CD_WDEPT", dept_code); //부서
		ht22.put("NO_DOCU", ""); //row_id와 같게 
		ht22.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
		ht22.put("CD_COMPANY", "1000");
		ht22.put("ID_WRITE", insert_id);
		ht22.put("CD_DOCU", "11");

		ht22.put("DT_ACCT", incom_dt);
		ht22.put("ST_DOCU", "1"); //미결:1, 승인:2  					
		ht22.put("TP_DRCR", "1");//차변
		ht22.put("CD_ACCT", "12000"); // 미수금
		ht22.put("AMT", String.valueOf(incom_amt));
		ht22.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체				

		if (card_nm.equals("KCP") || card_nm.equals("KCP2")) {
			ht22.put("CD_PARTNER", "105320"); //거래처    - A06  한국사이버결재(KCP)		
		} else if (card_nm.equals("페이엣")) {
			ht22.put("CD_PARTNER", "996282"); //거래처    - 페이엣(payat)			
		} else if (card_nm.equals("나이스")) {
			ht22.put("CD_PARTNER", "996283"); //거래처    - 나이스 	
		} else if (card_nm.equals("이노페이")) {
			ht22.put("CD_PARTNER", "996548"); //거래처    - 이노페이 			
		} else {

			ht22.put("CD_PARTNER", "109691"); //거래처    - A06		
		}

		ht22.put("DT_START", ""); //발생일자				 
		ht22.put("CD_BIZAREA", ""); //귀속사업장	
		ht22.put("CD_DEPT", ""); //부서								 
		ht22.put("CD_CC", ""); //코스트센터		
		ht22.put("CD_PJT", ""); //프로젝트코드	
		ht22.put("CD_CARD", ""); //신용카드		 		 	
		ht22.put("CD_EMPLOY", ""); //사원	
		ht22.put("NO_DEPOSIT", ""); //예적금계좌
		ht22.put("CD_BANK", ""); //금융기관	
		ht22.put("NO_ITEM", ""); //item   

		// 부가세관련
		ht22.put("AM_TAXSTD", ""); //과세표준액
		ht22.put("AM_ADDTAX", ""); //세액
		ht22.put("TP_TAX", ""); //과세(매출) :11
		ht22.put("NO_COMPANY", ""); //사업자등록번호				  	 	 	 	 

		ht22.put("NM_NOTE", doc_cont); // 적요	

		vt.add(ht22);

	} else if (ip_method.equals("5")) { //대체	

		if (neom.equals("Y") || neom1.equals("Y")) {
			line++;

			doc_cont = "[대체처리] " + doc_cont;

			//미지급금
			Hashtable ht24 = new Hashtable();

			ht24.put("WRITE_DATE", incom_dt); //row_id	
			ht24.put("ROW_NO", String.valueOf(line)); //row_no			
			ht24.put("NO_TAX", "*"); //부가세 이외는 *
			ht24.put("CD_PC", node_code); //회계단위
			ht24.put("CD_WDEPT", dept_code); //부서
			ht24.put("NO_DOCU", ""); //row_id와 같게 
			ht24.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
			ht24.put("CD_COMPANY", "1000");
			ht24.put("ID_WRITE", insert_id);
			ht24.put("CD_DOCU", "11");

			ht24.put("DT_ACCT", incom_dt);
			ht24.put("ST_DOCU", "1"); //미결:1, 승인:2  					
			ht24.put("TP_DRCR", "1");//차변
			ht24.put("CD_ACCT", "25300"); //미지급금
			ht24.put("AMT", String.valueOf(incom_amt));
			ht24.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체					
			ht24.put("CD_PARTNER", ven_code); //거래처    - A06

			ht24.put("DT_START", ""); //발생일자					 
			ht24.put("CD_BIZAREA", ""); //귀속사업장	
			ht24.put("CD_DEPT", ""); //부서								 
			ht24.put("CD_CC", ""); //코스트센터		
			ht24.put("CD_PJT", ""); //프로젝트코드	
			ht24.put("CD_CARD", ""); //신용카드		 		 	
			ht24.put("CD_EMPLOY", ""); //사원	
			ht24.put("NO_DEPOSIT", ""); //예적금계좌
			ht24.put("CD_BANK", ""); //금융기관	
			ht24.put("NO_ITEM", ""); //item   		

			// 부가세관련
			ht24.put("AM_TAXSTD", ""); //과세표준액
			ht24.put("AM_ADDTAX", ""); //세액
			ht24.put("TP_TAX", ""); //과세(매출) :11
			ht24.put("NO_COMPANY", ""); //사업자등록번호		 	 	 	 	  	 

			ht24.put("NM_NOTE", doc_cont); // 적요	

			vt.add(ht24);
		}

	} else if (ip_method.equals("3")) { //현금	

		if (neom.equals("Y") || neom1.equals("Y")) {
			line++;

			//현금
			Hashtable ht41 = new Hashtable();

			ht41.put("WRITE_DATE", incom_dt); //row_id	
			ht41.put("ROW_NO", String.valueOf(line)); //row_no			
			ht41.put("NO_TAX", "*"); //부가세 이외는 *
			ht41.put("CD_PC", node_code); //회계단위
			ht41.put("CD_WDEPT", dept_code); //부서
			ht41.put("NO_DOCU", ""); //row_id와 같게 
			ht41.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
			ht41.put("CD_COMPANY", "1000");
			ht41.put("ID_WRITE", insert_id);
			ht41.put("CD_DOCU", "11");

			ht41.put("DT_ACCT", incom_dt);
			ht41.put("ST_DOCU", "1"); //미결:1, 승인:2  					
			ht41.put("TP_DRCR", "1");//차변
			ht41.put("CD_ACCT", "10100"); //현금
			ht41.put("AMT", String.valueOf(incom_amt));
			ht41.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체					
			ht41.put("CD_PARTNER", ""); //거래처    - A06

			ht41.put("DT_START", ""); //발생일자					 
			ht41.put("CD_BIZAREA", ""); //귀속사업장	
			ht41.put("CD_DEPT", dept_code); //부서								 
			ht41.put("CD_CC", ""); //코스트센터		
			ht41.put("CD_PJT", ""); //프로젝트코드	
			ht41.put("CD_CARD", ""); //신용카드		 		 	
			ht41.put("CD_EMPLOY", ""); //사원	
			ht41.put("NO_DEPOSIT", ""); //예적금계좌
			ht41.put("CD_BANK", ""); //금융기관	
			ht41.put("NO_ITEM", ""); //item   		

			// 부가세관련
			ht41.put("AM_TAXSTD", ""); //과세표준액
			ht41.put("AM_ADDTAX", ""); //세액
			ht41.put("TP_TAX", ""); //과세(매출) :11
			ht41.put("NO_COMPANY", ""); //사업자등록번호		 	 	 	 	  	 

			ht41.put("NM_NOTE", doc_cont); // 적요	

			vt.add(ht41);
		}

	} else if (ip_method.equals("1")) {

		if (neom.equals("Y") || neom1.equals("Y")) {

			line++;

			//보통예금
			Hashtable ht1 = new Hashtable();

			ht1.put("WRITE_DATE", incom_dt); //row_id			
			ht1.put("ROW_NO", String.valueOf(line)); //row_no

			ht1.put("NO_TAX", "*"); //부가세 이외는 *
			ht1.put("CD_PC", node_code); //회계단위
			ht1.put("CD_WDEPT", dept_code); //부서
			ht1.put("NO_DOCU", ""); //row_id와 같게 
			ht1.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
			ht1.put("CD_COMPANY", "1000");
			ht1.put("ID_WRITE", insert_id);
			ht1.put("CD_DOCU", "11");

			ht1.put("DT_ACCT", incom_dt);
			ht1.put("ST_DOCU", "1"); //미결:1, 승인:2  					
			ht1.put("TP_DRCR", "1");//차변
			ht1.put("CD_ACCT", "10300"); //보통예금
			ht1.put("AMT", String.valueOf(incom_amt));
			ht1.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체				
			ht1.put("CD_PARTNER", ""); //거래처    - A06

			ht1.put("DT_START", ""); //발생일자					 
			ht1.put("CD_BIZAREA", ""); //귀속사업장	
			ht1.put("CD_DEPT", ""); //부서								 
			ht1.put("CD_CC", ""); //코스트센터		
			ht1.put("CD_PJT", ""); //프로젝트코드	
			ht1.put("CD_CARD", ""); //신용카드		 		 	
			ht1.put("CD_EMPLOY", ""); //사원
			ht1.put("NO_DEPOSIT", deposit_no); //예적금계좌
			ht1.put("CD_BANK", bank_code); //금융기관	
			ht1.put("NO_ITEM", ""); //item

			// 부가세관련
			ht1.put("AM_TAXSTD", ""); //과세표준액
			ht1.put("AM_ADDTAX", ""); //세액
			ht1.put("TP_TAX", ""); //과세(매출) :11
			ht1.put("NO_COMPANY", ""); //사업자등록번호

			ht1.put("NM_NOTE", doc_cont); // 적요			

			vt.add(ht1);

		}

	}

	if (vt.size() > 0) {
		row_id = neoe_db.insertSetAutoDocu(incom_dt, vt);
	}

	//입금원장처리 - jung_type :1->완료
	if (not_yet.equals("1")) {
		if (!in_db.updateIncomSet(incom_dt, incom_seq, not_yet_reason, "2"))
			flag += 1;
	} else {
		if (!in_db.updateIncomSet(incom_dt, incom_seq, "1", card_tax, ip_method, doc_cont, a_cal_tax, row_id))
			flag += 1;
	}
	
	//row_id처리  -
	if (row_id.equals("0"))  flag += 1;
	
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

<%	if(flag != 0){ 	//테이블에 저장 실패%>
	alert('등록 오류발생!');

<%	}else{ 			//테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				
    fm.action='<%=from_page%>';
   
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>

</body>
</html>
