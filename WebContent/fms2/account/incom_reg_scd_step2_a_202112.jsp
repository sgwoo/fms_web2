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
	if ( from_page.equals("")) from_page = "/fms2/account/incom_reg_step1.jsp" ;
	
	String rr 	= request.getParameter("rr")==null?"":request.getParameter("rr");	
	if ( rr.equals("r")) from_page = "/fms2/account/incom_r_frame.jsp" ;
	if ( rr.equals("f")) from_page = "/fms2/account/f_incom_frame.jsp" ;		
	
	String bank_code 	= request.getParameter("bank_code2")	==null?"":request.getParameter("bank_code2");
	String deposit_no 	= request.getParameter("deposit_no2")	==null?"":request.getParameter("deposit_no2");		
	String bank_name 	= request.getParameter("bank_name")	==null?"":request.getParameter("bank_name");
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	long  incom_amt 			= request.getParameter("incom_amt")	==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	
//	int    incom_amt 	 	= request.getParameter("incom_amt")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_amt"));
	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
			 
	String not_yet 	= request.getParameter("not_yet")==null?"0":request.getParameter("not_yet");  //1:가수금
	String not_yet_reason 	= request.getParameter("not_yet_reason")==null?"":request.getParameter("not_yet_reason");  //1:가수금
		
	//카드로 계산한 경우 수수료
	String ip_method 		= request.getParameter("ip_method")	==null?"":request.getParameter("ip_method");
	int    card_tax 	 	= request.getParameter("card_tax")	==null?0 :AddUtil.parseDigit(request.getParameter("card_tax"));
		
	//채권추심인 경우 수수료
	String pay_gur 		= request.getParameter("pay_gur")	==null?"0":request.getParameter("pay_gur");
	String pay_gur_nm 		= request.getParameter("pay_gur_nm")	==null?"":request.getParameter("pay_gur_nm");
	String pay_gur_rel 		= request.getParameter("pay_gur_rel")	==null?"":request.getParameter("pay_gur_rel");
	String neom1 = "";
		
	//기타입금관련
	String n_ven_code 		= request.getParameter("n_ven_code")	==null?"":request.getParameter("n_ven_code");
	String n_ven_name 		= request.getParameter("n_ven_name")	==null?"":request.getParameter("n_ven_name");
	String ip_acct 		= request.getParameter("ip_acct")	==null?"":request.getParameter("ip_acct");
	String acct_gubun 		= request.getParameter("acct_gubun")	==null?"4":request.getParameter("acct_gubun"); //차/대 구분 -> 차변:D, 대변:C
	long     ip_acct_amt 	 	= request.getParameter("ip_acct_amt")	==null?0 :AddUtil.parseDigit4(request.getParameter("ip_acct_amt"));
	String remark 		= request.getParameter("remark")	==null?"":request.getParameter("remark");
	String neom		= request.getParameter("neom")==null?"N":request.getParameter("neom"); 
	String s_neom		= request.getParameter("s_neom")==null?"N":request.getParameter("s_neom");  //검색후 거래처선택후 상세내용전표발행 
	String cool		= request.getParameter("cool")==null?"N":request.getParameter("cool"); 
		
	//입금표
	String ebill		= request.getParameter("ebill")==null?"N":request.getParameter("ebill"); 
	
	String ext_msg = "";
	
	//선수금 메세지 관련
     String gg_chk = "Y";
	      
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
	
	boolean mail_chk = false;
	
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
										
			//메일 check			
			for(int cc=0; cc< i_agnt_email.length(); cc++) {					
				if ( i_agnt_email.charAt(cc) == '@') {
					mail_chk = true;				       	
				}	
			//	if ( i_agnt_email.charAt(cc) == '.') {
			//		mail_chk = true;				       	
			//	}			
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
		if( value0[i].equals("scd_grt") || value0[i].equals("scd_pp") || value0[i].equals("scd_rfee") || value0[i].equals("scd_cha") || value0[i].equals("scd_green") ){
			
			String SeqId = "";
			String cha_gubun = "";  // 면책금 여부 
								
			//대용량처리인 경우 개인인 경우 안됨. 	- 20120502 일단 수정	- 20121214 개인발행			
			//보증금인 경우 - 연번은 무조건 생성
			if ( value0[i].equals("scd_grt") && ebill.equals("Y")    ){	
													
				//전자입금표일련번호
			 	SeqId= IssueDb.getSeqIdNext("PayEBill","PE");
				System.out.println("SeqId ="+SeqId+"|"+ value10[i] + "|" + rtn_client);
				
			}
				
											
			ExtScdBean pay_grt = ae_db.getAGrtScd(value9[i], value10[i], value1[i], value5[i], value3[i]);
									   
			i_tax_supply = pay_grt.getExt_s_amt();
			i_tax_value =  pay_grt.getExt_v_amt();
			
			if ( value0[i].equals("scd_cha") ){  //승계수수료는 계산서 발행 
			    if ( pay_grt.getExt_v_amt() < 1 ) {
			    	cha_gubun = "Y";					    
			    }					
			}
			
			if (  value0[i].equals("scd_green") ){
					green_chk = "Y";
			    	cha_gubun = "Y";   			    				
			}
			
			
			if ( value0[i].equals("scd_grt") && ebill.equals("Y")   ){	
				pay_grt.setSeqId(SeqId);
			}
			
		//	pay_grt.setExt_est_dt(incom_dt);
			pay_grt.setExt_pay_amt(pay_amt);
			pay_grt.setExt_pay_dt(incom_dt);
			pay_grt.setUpdate_id(user_id);
			pay_grt.setIncom_dt	(incom_dt); //원장번호
			pay_grt.setIncom_seq(incom_seq);//연번
		
			if(!ae_db.receiptGrt(pay_grt))	flag += 1;
			
			//계약승계시 보증금 별도건 처리 - 해지담당자에게 메세지
			if ( value0[i].equals("scd_grt") ) {
				//대여정보
				ContFeeBean fee = a_db.getContFeeNew(value9[i], value10[i], value1[i]);
				Hashtable new_firm = a_db.getContViewCase(value9[i], value10[i]);
				//계약기타정보
				ContEtcBean cont_etc = a_db.getContEtc(value9[i], value10[i]);				
				Hashtable old_firm = a_db.getContViewCase(value9[i], cont_etc.getRent_suc_l_cd());
											
				//현계약 보증금이 있고, 승계여부 별도이며, 계약승계일자가 있고, 동일 rent_st이고 원계약자 보증금이 있다.
				if(fee.getGrt_amt_s()>0 && fee.getGrt_suc_yn().equals("1") && !cont_etc.getRent_suc_dt().equals("") && fee.getRent_st().equals(cont_etc.getSuc_rent_st()) && cont_etc.getGrt_suc_o_amt() >0) {
						//메시지발송
			    	  //담당자에게 메세지 전송------------------------------------------------------------------------------------------							
						UsersBean sender_bean 	= umd.getUsersBean(user_id);
								
						String sub 		= "계약승계시 보증금  별도 입금";
						String cont 	= "▣ 계약승계시 보증금  입금처리 되었으니 원계약자 보증금 환불처리하세요 :: 원계약 : "+cont_etc.getRent_suc_l_cd()+" " + String.valueOf(old_firm.get("FIRM_NM")) + " , 승계계약: "+value10[i]+" " + String.valueOf(new_firm.get("FIRM_NM")) + "  차량번호: " + car_no + ", 입금일: "+ incom_dt + ", 입금액: "+ pay_amt ;  	
											
						String url 		= "/fms2/pay_mng/pay_list_reg.jsp";		 
														
						String target_id =nm_db.getWorkAuthUser("해지관리자"); 	  							
						//사용자 정보 조회
						UsersBean target_bean 	= umd.getUsersBean(target_id);
						
						String xml_data = "";
						xml_data =  "<COOLMSG>"+
					  				"<ALERTMSG>"+
					  				"    <BACKIMG>4</BACKIMG>"+
					  				"    <MSGTYPE>104</MSGTYPE>"+
					  				"    <SUB>"+sub+"</SUB>"+
					  				"    <CONT>"+cont+"</CONT>"+
					 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+url+"</URL>";
						
						xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
						
						xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
					  				"    <MSGICON>10</MSGICON>"+
					  				"    <MSGSAVE>1</MSGSAVE>"+
					  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
					  				"    <FLDTYPE>1</FLDTYPE>"+
					  				"  </ALERTMSG>"+
					  				"</COOLMSG>";
						
						CdAlertBean msg = new CdAlertBean();
						msg.setFlddata(xml_data);
						msg.setFldtype("1");					
					
						flag2 = cm_db.insertCoolMsg(msg);												
						System.out.println("쿨메신저(약승계시 보증금  별도 입금) 원계약 : "+cont_etc.getRent_suc_l_cd()+" , 승계계약: "+value10[i]+"---------------------"+target_bean.getUser_nm());
							
								
				}
											
			}
			
			if ( value0[i].equals("scd_pp") ) {
			
			//대여정보
				ContFeeBean fee = a_db.getContFeeNew(value9[i], value10[i], value1[i]);
				pp_chk = fee.getPp_chk();
			}
			
			//선수금 자동전표생성					
			String acct_cont = "";
			
			if ( value0[i].equals("scd_grt")){
				acct_cont = "[장기대여보증금]"+ value10[i]+"("+client.getFirm_nm()+")";
			} else if (value0[i].equals("scd_pp")){				
				if (pp_chk.equals("0") ) {
					acct_cont = "[선납금 균등]"+ value10[i]+"("+client.getFirm_nm()+")";
				} else {
					acct_cont = "[선납금]"+ value10[i]+"("+client.getFirm_nm()+")";	
				}
			} else if (value0[i].equals("scd_rfee")){
				acct_cont = "[개시대여료]"+ value10[i]+"("+client.getFirm_nm()+")";
			} else if (value0[i].equals("scd_cha")){
				acct_cont = "[승계수수료]"+ value10[i]+"("+client.getFirm_nm()+")";	
			} else if (value0[i].equals("scd_green")){
				acct_cont = "[구매보조금]"+ value10[i]+"("+client.getFirm_nm()+")";		
			}	
						
			
			if(doc_cont.equals("")){
				doc_cont = acct_cont;
			}
			
			line++;
			
			//선수금
			Hashtable ht15 = new Hashtable();
			
			if ( value0[i].equals("scd_grt")){
			
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
			
			} else if ( value0[i].equals("scd_pp")){ //20191220 균등발행인 경우: 선수금 , 그외:외상매출금 
			
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
																			
					if ( value0[i].equals("scd_green")){
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
				    
		    //보증금인 경우 입금표발행		    
		 	if ( value0[i].equals("scd_grt") && ebill.equals("Y")   ) {	
		 	
					//@,.가 있고, 자리수 5자 이상.
				if (  mail_chk && (AddUtil.lengthb(i_agnt_email) > 5 ) ) { 									
																				
					SaleEBillBean sb_bean = new SaleEBillBean();										
		
					sb_bean.setSeqID		(SeqId);
					sb_bean.setDocCode		("03");
					sb_bean.setRefCoRegNo	("");
					sb_bean.setRefCoName	("");
					sb_bean.setTaxSNum1		("");
					sb_bean.setTaxSNum2		("");
					sb_bean.setTaxSNum3		("");
					sb_bean.setDocAttr		("N");
					sb_bean.setOrigin		("");
					sb_bean.setPubDate		(incom_dt);
					sb_bean.setSystemCode	("KF");
					
					sb_bean.setDocKind		("03");
					sb_bean.setS_EbillKind	("1");//1:일반입금표 2:위수탁입금표					
					  
					//공급자------------------------------------------------------------------------------
					sb_bean.setMemID		("amazoncar11");
					sb_bean.setMemName		(user_bean.getUser_nm());
					sb_bean.setEmail		("tax@amazoncar.co.kr");		//계산서 담당 메일 주소
					sb_bean.setTel			("02-392-4243");
													
					sb_bean.setCoRegNo		(String.valueOf(br.get("BR_ENT_NO")));
					sb_bean.setCoName		("(주)아마존카");
					sb_bean.setCoCeo		(String.valueOf(br.get("BR_OWN_NM")));
					sb_bean.setCoAddr		(String.valueOf(br.get("BR_ADDR")));
					sb_bean.setCoBizType	(String.valueOf(br.get("BR_STA")));
					sb_bean.setCoBizSub		(String.valueOf(br.get("BR_ITEM")));
					
					//공급받는자--------------------------------------------------------------------------
					sb_bean.setRecMemID		("");
					sb_bean.setRecMemName	(i_agnt_nm);
					sb_bean.setRecEMail		(i_agnt_email);
					sb_bean.setRecTel		(i_agnt_m_tel);
																
					sb_bean.setRemarks	("장기대여보증금-" + value10[i]);
					
					sb_bean.setRecCoRegNo(i_enp_no);
					
					//외국인이고 개인인 경우 
					if (foreigner.equals("2") && client_st.equals("2") ) {
						sb_bean.setRecCoRegNo("0000000000");
						sb_bean.setRemarks	("장기대여보증금-" + value10[i] + "-" + i_ssn);
						
					}
					
					sb_bean.setItemName1	("장기대여보증금");
					sb_bean.setRecCoName	(i_firm_nm);
					sb_bean.setRecCoCeo		(i_client_nm);
					sb_bean.setRecCoAddr	(i_addr);
					sb_bean.setRecCoBizType	(i_sta);
					sb_bean.setRecCoBizSub	(i_item);					
												
					//내용-----------------------------------------------------------------------------------
					sb_bean.setSupPrice		(pay_amt);
					sb_bean.setTax			(0);
					sb_bean.setPubKind		("N");
					sb_bean.setLoadStatus	(0);
					sb_bean.setPubCode		("");
					sb_bean.setPubStatus	("");
					sb_bean.setClient_id	(rtn_client);
					
					if(!IssueDb.insertPayEBill(sb_bean)) 	flag += 1;
				}	
			}					
													
			if ( green_chk.equals("") ) { //친환경차가 아니경우만 문자 보냄 
		
			   if ( value0[i].equals("scd_grt")  || value0[i].equals("scd_pp")  ||  value0[i].equals("scd_rfee")   ){
			   		 	if ( value0[i].equals("scd_grt")){
			   				 ext_msg = "장기대여보증금";
			   			} else if (value0[i].equals("scd_pp")){
			   			    ext_msg = "선납금";
			   			} else if (value0[i].equals("scd_rfee")){  
			   		   		ext_msg = "개시대여료";
			   		   }
			   		   
						//문자발송 - 고객 & 최초영업자					
						if(!i_agnt_m_tel.equals("")){ //고객					
						//	IssueDb.insertsendMail(sendphone, sendname, i_agnt_m_tel, i_firm_nm, "", "+0.01", i_firm_nm+"님 " + ext_msg + "  입금 처리되었습니다.-아마존카-");	
							at_db.sendMessage(1009, "0",  i_firm_nm+"님 " + ext_msg + "  입금 처리되었습니다.-아마존카-", i_agnt_m_tel, sendphone, null, value10[i],  "999999");		
											
						}
											
						//최초영업자
						UsersBean target_bean 	= umd.getUsersBean(first_id);						
						String destphone 	= target_bean.getUser_m_tel();
						String destname 	= target_bean.getUser_nm();
									
						if(!target_bean.getUser_m_tel().equals("")){
						//	IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "+0.01", i_firm_nm+"님 " + ext_msg + "  입금 처리되었습니다.-아마존카-");
							
							at_db.sendMessage(1009, "0",  i_firm_nm+"님 " + ext_msg + "  입금 처리되었습니다.-아마존카-", destphone, sendphone, null, value10[i],  "999999");	
					
							
						}		
			  }										
			}							
		//대여료
		}else if(value0[i].equals("scd_fee")){
						
			FeeScdBean pay_fee = af_db.getScdNew(value9[i], value10[i], value1[i], value2[i], value3[i], value4[i]);
			
			pay_fee.setRc_yn	("1");
			pay_fee.setRc_dt	(incom_dt);
			pay_fee.setRc_amt	(pay_amt);
			pay_fee.setUpdate_id(user_id);
			pay_fee.setIncom_dt	(incom_dt); //원장번호
			pay_fee.setIncom_seq(incom_seq);
							
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
				rest_fee.setTm_st2		(pay_fee.getTm_st2());										//일반대여료.....
				rest_fee.setFee_est_dt	(pay_fee.getFee_est_dt());									//원 대여료의 입금예정일
				rest_fee.setFee_s_amt	(rest_s_amt);
				rest_fee.setFee_v_amt	(rest_amt - rest_s_amt);
				rest_fee.setDly_days	("0");	
				rest_fee.setDly_fee		(0);	
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
			
			//20111212 추가 - 현재 사용하지는 않음 - 채권등에서 연체료 재계산 추가 함
			//기본정보
			Hashtable f_fee = af_db.getFeebaseNew(value9[i], value10[i]);
			
			//해지정보
			ClsBean cls = ass_db.getClsCase(value9[i], value10[i]);
	
			//연체료 재계산 - 거래명세서 연체이자 추가로 인해서 재계산 20130429
			boolean dly_flag = af_db.calDelayDtPrint(value9[i], value10[i], cls.getCls_dt(), String.valueOf(f_fee.get("RENT_DT")));
							
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
				 acct_cont = "[카드대여료]"+pay_fee.getFee_tm()+"회차:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
			} else {
				 acct_cont = "[대여료]"+pay_fee.getFee_tm()+"회차:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+")";
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
						
			//미발행 대여료 세금계산서 발행
			//해당대여료 계산서 발행 유무
						
		   
			 //미발행계산서가 있는 경우 메세지 보내기 .								
			if ( AddUtil.parseInt(pay_fee.getReq_dt().substring(0,4)+ pay_fee.getReq_dt().substring(5,7)+ pay_fee.getReq_dt().substring(8,10)) < AddUtil.parseInt(incom_dt) ) {
			
				int stop_cnt = in_db.getFeeScdStop(value9[i], value10[i]);
				
				if (stop_cnt < 1) {
					int tax_cnt = IssueDb.getTaxMakeCheck2(value10[i], value3[i], value1[i], value2[i]);					
					
				    if (tax_cnt < 1) { //계산서 미발행
				    
				       	   int tax_item_cnt  = IssueDb.getTaxMakeCheck3(value10[i], value3[i], value1[i], value2[i]);		
				       
					   if (tax_item_cnt < 1) {  //거래명세서 미발행
					    
									      //담당자에게 메세지 전송------------------------------------------------------------------------------------------							
									UsersBean sender_bean 	= umd.getUsersBean(user_id);
											
									String sub 		= "대여료 계산서 발행요청";
									String cont 	= "▣ 대여료 계산서 발행요청 :: "+pay_fee.getFee_tm()+"회차:"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") 입금일:"+ incom_dt + ", 입금액: "+ pay_amt ;  	
														
									String url 		= "/tax/issue_1/issue_1_frame.jsp";		 		
																
									String target_id =nm_db.getWorkAuthUser("세금계산서담당자"); 	   
											
									//사용자 정보 조회
									UsersBean target_bean 	= umd.getUsersBean(target_id);
									
									String xml_data = "";
									xml_data =  "<COOLMSG>"+
								  				"<ALERTMSG>"+
								  				"    <BACKIMG>4</BACKIMG>"+
								  				"    <MSGTYPE>104</MSGTYPE>"+
								  				"    <SUB>"+sub+"</SUB>"+
								  				"    <CONT>"+cont+"</CONT>"+
								 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+url+"</URL>";
									
									xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
									
									xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
								  				"    <MSGICON>10</MSGICON>"+
								  				"    <MSGSAVE>1</MSGSAVE>"+
								  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
								  				"    <FLDTYPE>1</FLDTYPE>"+
								  				"  </ALERTMSG>"+
								  				"</COOLMSG>";
									
									CdAlertBean msg = new CdAlertBean();
									msg.setFlddata(xml_data);
									msg.setFldtype("1");
									
									if ( !car_st.equals("4")  ) {
										flag2 = cm_db.insertCoolMsg(msg);												
										System.out.println("쿨메신저(대여료계산서발행요청의뢰) "+pay_fee.getFee_tm()+"회차:"+cr_bean.getCar_no()+"---------------------"+target_bean.getUser_nm());
									}							    
					       }//tax_item_cnt
				    } //tax_cnt						    
				}    
				    
		    } //메세지 보내기
					
		//연체료
		}else if(value0[i].equals("scd_dly")){
			out.println("연체료입금처리="+pay_amt+", ");
			
			FeeDlyScdBean dly_bean = new FeeDlyScdBean();
			dly_bean.setRent_mng_id	(value9[i]);
			dly_bean.setRent_l_cd	(value10[i]);
			dly_bean.setPay_amt		(pay_amt);
			dly_bean.setPay_dt		(incom_dt);
			dly_bean.setEtc			("집금입금");
			dly_bean.setReg_id		(user_id);
			dly_bean.setIncom_dt	(incom_dt); //원장번호
			dly_bean.setIncom_seq	(incom_seq);
			
			if(!af_db.insertFeeDlyScd( dly_bean)) flag += 1; //수금 연체료 등록
							
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
		}else if(value0[i].equals("scd_fine")){
			out.println("과태료입금처리="+pay_amt+", ");
			
			String vio_pla = "";
			String vio_dt = "";
			String proxy_dt = "";
		         String f_reg_id = ""; //최초등록자  부산:000107
			
			f_bean = a_fdb.getForfeitDetailAll( value11[i], value9[i], value10[i], value5[i]);
			
			vio_pla = f_bean.getVio_pla();
			vio_dt = f_bean.getVio_dt();
			proxy_dt = f_bean.getProxy_dt(); //납부일자
			f_reg_id = f_bean.getReg_id(); //최초등록자  부산:000107
			
			f_bean.setColl_dt(incom_dt);
			f_bean.setUpdate_id(user_id);
			f_bean.setUpdate_dt(AddUtil.getDate());						
			f_bean.setIncom_dt	(incom_dt); //원장번호
			f_bean.setIncom_seq	(incom_seq);
									
			count = a_fdb.updateForfeit(f_bean);			
			
			//선납한 경우 제외		
			if ( proxy_dt.equals("") ) {		
			
			  //담당자에게 메세지 전송------------------------------------------------------------------------------------------							
				UsersBean sender_bean 	= umd.getUsersBean(user_id);
						
				String sub 		= "과태료 납입요청";
				String cont 	= "▣ 과태료 납입요청 :: "+ client.getFirm_nm() + ", " + cr_bean.getCar_no() + ", 입금일:"+ incom_dt + ", 입금액: "+ pay_amt +", 위반장소:" + vio_pla + ", 위반일:"+ vio_dt;  	
											
				String url 		=  "/acar/fine_mng/fine_mng_frame.jsp?c_id="+value11[i]+"|m_id="+value9[i]+"|l_cd="+value10[i]+"|seq_no="+value5[i];			
					
				String target_id =nm_db.getWorkAuthUser("과태료담당자"); 
							
				//사용자 정보 조회
				UsersBean target_bean 	= umd.getUsersBean(target_id);
				
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
				
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				
				xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
			  				"    <MSGICON>10</MSGICON>"+
			  				"    <MSGSAVE>1</MSGSAVE>"+
			  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
			  				"  </ALERTMSG>"+
			  				"</COOLMSG>";
				
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
				
				flag2 = cm_db.insertCoolMsg(msg);
					
				System.out.println("쿨메신저(과태료납입요청의뢰)"+cr_bean.getCar_no()+", 위반일:"+ vio_dt+ " --------------------"+target_bean.getUser_nm());	
			}				
											
			//과태료 자동전표생성				
			
			String acct_cont = "";					
			if ( ip_method.equals("2") ) {
			  acct_cont = "[카드과태료]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") " + vio_pla;
			} else {
			  acct_cont = "[과태료]"+cr_bean.getCar_no()+"("+client.getFirm_nm()+") " + vio_pla;
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
				
		//기타처리관련	- 보험해지, 자동차세 환급 등
						
		//면책금
		}else if(value0[i].equals("scd_serv")){
			
			InsMScdBean cng_ins_ms = ae_db.getScd(value9[i], value10[i], value11[i], value12[i], value4[i], value3[i]);
			
			cng_ins_ms.setCust_pay_dt(incom_dt);
			cng_ins_ms.setPay_amt(pay_amt);
			cng_ins_ms.setUpdate_id(user_id);
			
			if(!ae_db.updateInsMScd(cng_ins_ms, "p", "1", incom_dt, incom_seq)) flag += 1; //
						
			out.println(cng_ins_ms.getRent_mng_id());
			out.println(cng_ins_ms.getRent_l_cd());
			out.println(cng_ins_ms.getCar_mng_id());
			out.println(cng_ins_ms.getServ_id());
						
							
		  //입금표발행요청관련  	  
			if ( cng_ins_ms.getSaleebill_yn().equals("1")  ) {
			
					//전자입금표일련번호
				   String SeqId1 = "";
			 		SeqId1= IssueDb.getSeqIdNext("PayEBill","PE");
					System.out.println("SeqId1 ="+SeqId1+"|"+ value10[i]);
										
					SaleEBillBean sb_bean1 = new SaleEBillBean();										
		
					sb_bean1.setSeqID		(SeqId1);
					sb_bean1.setDocCode		("03");
					sb_bean1.setRefCoRegNo	("");
					sb_bean1.setRefCoName	("");
					sb_bean1.setTaxSNum1		("");
					sb_bean1.setTaxSNum2		("");
					sb_bean1.setTaxSNum3		("");
					sb_bean1.setDocAttr		("N");
					sb_bean1.setOrigin		("");
					sb_bean1.setPubDate		(incom_dt);
					sb_bean1.setSystemCode	("KF");
					
					sb_bean1.setDocKind		("03");
					sb_bean1.setS_EbillKind	("1");//1:일반입금표 2:위수탁입금표					
					  
					//공급자------------------------------------------------------------------------------
					sb_bean1.setMemID		("amazoncar11");
					sb_bean1.setMemName		(user_bean.getUser_nm());
					sb_bean1.setEmail		("tax@amazoncar.co.kr");		//계산서 담당 메일 주소
					sb_bean1.setTel			("02-392-4243");
																
					sb_bean1.setCoRegNo		(String.valueOf(br.get("BR_ENT_NO")));
					sb_bean1.setCoName		("(주)아마존카");
					sb_bean1.setCoCeo		(String.valueOf(br.get("BR_OWN_NM")));
					sb_bean1.setCoAddr		(String.valueOf(br.get("BR_ADDR")));
					sb_bean1.setCoBizType	(String.valueOf(br.get("BR_STA")));
					sb_bean1.setCoBizSub		(String.valueOf(br.get("BR_ITEM")));
					
					//공급받는자--------------------------------------------------------------------------
					sb_bean1.setRecMemID		("");
					sb_bean1.setRecMemName	(i_agnt_nm);
					
					if ( !cng_ins_ms.getAgnt_email().equals("") ) {
						sb_bean1.setRecEMail		(cng_ins_ms.getAgnt_email());
						sb_bean1.setRecTel		("");
					} else {	
						sb_bean1.setRecEMail	(i_agnt_email);
						sb_bean1.setRecTel		(i_agnt_m_tel);												
					}
										
					sb_bean1.setRemarks	("면책금 - " + cr_bean.getCar_no());
					sb_bean1.setRecCoRegNo(i_enp_no);
						
					sb_bean1.setItemName1	("면책금");
					sb_bean1.setRecCoName	(i_firm_nm);
					sb_bean1.setRecCoCeo		(i_client_nm);
					sb_bean1.setRecCoAddr	(i_addr);
					sb_bean1.setRecCoBizType	(i_sta);
					sb_bean1.setRecCoBizSub	(i_item);					
												
					//내용-----------------------------------------------------------------------------------
					sb_bean1.setSupPrice		(pay_amt);
					sb_bean1.setTax			(0);
					sb_bean1.setPubKind		("N");
					sb_bean1.setLoadStatus	(0);
					sb_bean1.setPubCode		("");
					sb_bean1.setPubStatus	("");
					sb_bean1.setClient_id	(rtn_client);
					
					if(!IssueDb.insertPayEBill(sb_bean1)) 	flag += 1;		
					
				//	if(!ae_db.updateScdExtSeqId(value9[i], value10[i], cng_ins_ms.getRent_st(),  value3[i], SeqId1, "car_ja" ))	flag += 1;
					if(!ae_db.updateScdExtSeqId(value9[i], value10[i], cng_ins_ms.getRent_st(),  value4[i],  value3[i], SeqId1, "car_ja" ))	flag += 1;   //value
			
			}
												
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
			if( cng_ins_ms.getBill_doc_yn().equals("1") ){  //현재는 더이상 사용안함 (면책금은 계산서 발행안함)
			
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
			}else{
			
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
			
			}
			
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
		}else if(value0[i].equals("scd_insh")){
			out.println("휴/대차료입금처리="+pay_amt+", ");
			
			MyAccidBean ma_bean = ae_db.getAccidScd(value9[i], value10[i], value11[i], value12[i], AddUtil.parseInt(value5[i]), value3[i]);
	
			//스케쥴형식으로 전환 - 20110209
			ma_bean.setIns_pay_amt	(pay_amt);	//입금액
			ma_bean.setIns_pay_dt	(incom_dt);	//입금일자					
			ma_bean.setUpdate_id(user_id);				
			ma_bean.setPay_gu		(value4[i]);  //1:휴차료 2:대차료
			ma_bean.setIncom_dt	(incom_dt); //원장번호
			ma_bean.setIncom_seq	(incom_seq);
			
			if(!ae_db.updateAccidMScd(ma_bean, "p", "1", incom_dt, incom_seq)) flag += 1; //
			
			//청구서 발행안함 - - 강제 휴차료 처리 - 20211206 
			if ( value15[i].equals("1")) 	value4[i] = "1";
												
			//대차료일경우 계산서발행요청메시지발송---------------------------
			if(!value13[i].equals("000228") && !value13[i].equals("000231") && value4[i].equals("2")){
				
				//세금계산서 조회
				tax.TaxBean t_bean 		= IssueDb.getTax_accid(value10[i], value11[i], value12[i], value5[i] );
										
				//미발행
				if(t_bean.getTax_dt().equals("")){
					tax_yn = "Y";
				//기발행 - 
				}else{
					tax_yn = "U";
					tax_no = t_bean.getTax_no();
					
					//입금금액이 청구금액과 틀린 경우
					int o_tax_amt = t_bean.getTax_supply()+t_bean.getTax_value();
					int n_tax_amt = o_tax_amt - pay_amt;
					
					if(n_tax_amt==0){
						tax_yn = "";
					}							
				}						
				
				if (tax_yn.equals("Y") || tax_yn.equals("U") ) {
					//사고조회
					AccidentBean a_bean = as_db.getAccidentBean(value11[i], value12[i]);
		
				
				  //담당자에게 메세지 전송------------------------------------------------------------------------------------------							
					UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
					String sub 		= "대차료계산서발행요청";
					String cont 	= "▣ 대차료계산서발행요청 :: "+ i_firm_nm + ", " + cr_bean.getCar_no() + ", 사고일시:" + a_bean.getAccid_dt()+ ", 입금일:"+ incom_dt + ", 입금액: "+ pay_amt;  	
												
					String url 		= "";		 
					
					if ( tax_yn.equals("Y") ) {
						url 		= "/tax/issue_3/issue_3_sc9.jsp";		 
					} else {
						url 		= "/tax/tax_mng/tax_mng_u_m.jsp?tax_no="+tax_no;	
					}	 
					
					String target_id =nm_db.getWorkAuthUser("CMS관리");  //입금담당자
																				
					//사용자 정보 조회
					UsersBean target_bean 	= umd.getUsersBean(target_id);
					
					String xml_data = "";
					xml_data =  "<COOLMSG>"+
				  				"<ALERTMSG>"+
				  				"    <BACKIMG>4</BACKIMG>"+
				  				"    <MSGTYPE>104</MSGTYPE>"+
				  				"    <SUB>"+sub+"</SUB>"+
				  				"    <CONT>"+cont+"</CONT>"+
				 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
					
					xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					
					xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
				  				"    <MSGICON>10</MSGICON>"+
				  				"    <MSGSAVE>1</MSGSAVE>"+
				  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
				  				"    <FLDTYPE>1</FLDTYPE>"+
				  				"  </ALERTMSG>"+
				  				"</COOLMSG>";
					
					CdAlertBean msg = new CdAlertBean();
					msg.setFlddata(xml_data);
					msg.setFldtype("1");
					
		//			flag2 = cm_db.insertCoolMsg(msg);
						
					System.out.println("쿨메신저(대차료계산서발행의뢰)"+cr_bean.getCar_no()+"---------------------"+target_bean.getUser_nm());	
				
				}				
			}			
			
			// 휴/대차료 자동전표생성					
			String acct_cont = "";					
			
			if (value4[i].equals("1")){
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
			if (value4[i].equals("2")){
			
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
		
				//월렌트, 정비대차
		}else if(value0[i].equals("scd_rent")){
			out.println("월렌트, 정비대차 입금처리="+pay_amt+", ");
	//		System.out.println( "월렌트=" +  value14[i] + ":" + value11[i]	);									
			//단기계약정보  - value1[i]: rent_st in('1', '2') -_rent_cont.bus_id  |   not in ('1', '2')  rent_cont.nvl(mng_id, bus_id)
			RentContBean rc_bean = rs_db.getRentContCase( value14[i], value11[i]);
			//rent_st :6 보증금 									
			ScdRentBean  rent_bean = rs_db.getScdRentCase(value14[i],  value1[i],  value3[i]);
			
			System.out.println("월렌트(정비대차)료=" + value14[i] + " : " + value1[i] + " : " + value3[i] ) ;
			
			int  r_supply = rent_bean.getRent_s_amt();
			int  r_value =  rent_bean.getRent_v_amt();
				
			String full = "";						
			// paid_st :  2 -> 신용카드 , 카드입금이면 paid_st는 '2'로 변경
			if ( ip_method.equals("2") ) {
				rent_bean.setPaid_st	("2");
			}
			
			if(pay_amt == ( rent_bean.getRent_s_amt()+rent_bean.getRent_v_amt())){
				out.println("전액입금처리="+pay_amt+", ");
				full = "Y";
			}else{
				full = "N";
				int rest_s1_amt 	= (new Double(pay_amt/1.1)).intValue();
							
						rent_bean.setRent_s_amt(rest_s1_amt);
						rent_bean.setRent_v_amt(pay_amt - rest_s1_amt);
					}

					rent_bean.setPay_dt(incom_dt);
					rent_bean.setPay_amt(pay_amt);
					rent_bean.setReg_id(user_id);
					rent_bean.setIncom_dt(incom_dt); //원장번호
					rent_bean.setIncom_seq(incom_seq);

					count = rs_db.updateScdRent(rent_bean);

					i_tax_supply = rent_bean.getRent_s_amt();
					i_tax_value = rent_bean.getRent_v_amt();

					if (full.equals("Y")) {
						System.out.println("전액입금처리=" + pay_amt + ", rent_s_cd = " + rent_bean.getRent_s_cd());
					} else {
						System.out.println("부분입금처리=" + pay_amt + ", rent_s_cd = " + rent_bean.getRent_s_cd());

						int rest_amt = (r_supply + r_value) - pay_amt;
						int rest_s_amt = (new Double(rest_amt / 1.1)).intValue();
						out.println(" 잔액생성=" + rest_amt);

						ScdRentBean rest_fee = new ScdRentBean();
						rest_fee.setRent_s_cd(rent_bean.getRent_s_cd());
						rest_fee.setRent_st(rent_bean.getRent_st());
						rest_fee.setTm(rent_bean.getTm() + 1);

						rest_fee.setPaid_st(rent_bean.getPaid_st());
						rest_fee.setEst_dt(rent_bean.getEst_dt()); //원 대여료의 입금예정일
						rest_fee.setRent_s_amt(rest_s_amt);
						rest_fee.setRent_v_amt(rest_amt - rest_s_amt);
						rest_fee.setDly_days("0");
						rest_fee.setDly_amt(0); //default는 0(미수금)
						rest_fee.setPay_dt("");
						rest_fee.setPay_amt(0);
						rest_fee.setReg_id(user_id);
						rest_fee.setBill_yn("Y");

						count = rs_db.insertScdRent(rest_fee);

					}

					System.out.println("월렌트료 bean=" + rent_bean.getRent_s_cd() + " : " + rent_bean.getRent_st()
							+ " : " + rent_bean.getTm() + ": count=" + count + ":user_id=" + user_id
							+ ":incom_dt =" + incom_dt + ":incom_seq = " + incom_seq);

					// 정비대차 제외
					if (!rc_bean.getRent_st().equals("2")) {

						//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
						UsersBean sender_bean = umd.getUsersBean(user_id);

						String sub = "단기 월렌트료 입금확인";
						String cont = "";

						//6:보증금
						if (value1[i].equals("6")) {
							if (ip_method.equals("2")) {
								cont = "▣ 단기 월렌트 보증금  카드 입금확인 :: " + rent_bean.getRent_st() + "회차:"
										+ cr_bean.getCar_no() + "(" + client.getFirm_nm() + ") 입금일:" + incom_dt
										+ ", 입금액: " + pay_amt;
							} else {
								cont = "▣ 단기 월렌트 보증금  입금확인 :: " + rent_bean.getRent_st() + "회차:"
										+ cr_bean.getCar_no() + "(" + client.getFirm_nm() + ") 입금일:" + incom_dt
										+ ", 입금액: " + pay_amt;
							}
						} else {
							if (ip_method.equals("2")) {
								cont = "▣ 단기 월렌트료  카드 입금확인 :: " + rent_bean.getRent_st() + "회차:"
										+ cr_bean.getCar_no() + "(" + client.getFirm_nm() + ") 입금일:" + incom_dt
										+ ", 입금액: " + pay_amt;
							} else {
								cont = "▣ 단기 월렌트료  입금확인 :: " + rent_bean.getRent_st() + "회차:"
										+ cr_bean.getCar_no() + "(" + client.getFirm_nm() + ") 입금일:" + incom_dt
										+ ", 입금액: " + pay_amt;
							}
						}

						String url = "/tax/issue_3/issue_3_frame.jsp";
					
						String target_id = nm_db.getWorkAuthUser("세금계산서담당자");
						//	String target_id = "000129"; //계산서 담당자		//000113->000058->권명숙(000131) -> 000129

						//사용자 정보 조회
						UsersBean target_bean = umd.getUsersBean(target_id);

						String xml_data = "";
						xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
								+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>"
								+ cont + "</CONT>"
								+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
								+ url + "</URL>";

						xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";

						xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>"
								+ "    <MSGICON>10</MSGICON>" + "    <MSGSAVE>1</MSGSAVE>"
								+ "    <LEAVEDMSG>1</LEAVEDMSG>" + "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>"
								+ "</COOLMSG>";

						CdAlertBean msg = new CdAlertBean();
						msg.setFlddata(xml_data);
						msg.setFldtype("1");

						flag2 = cm_db.insertCoolMsg(msg);

						System.out.println("쿨메신저(월렌트료계산서발행요청의뢰) " + rent_bean.getRent_st() + "회차:"
								+ cr_bean.getCar_no() + "---------------------" + target_bean.getUser_nm());

						url = "/acar/res_stat/res_st_frame_s.jsp";

						target_id = "000153"; //월렌트 담당자		//000113->000058->권명숙(000131) -> 000129

						//첫회차스케쥴 & 보증금인경우
						if (value1[i].equals("1") || value1[i].equals("2") || value1[i].equals("6")) {
							target_id = rc_bean.getBus_id();
						} else {
							target_id = rc_bean.getBus_id();
							if (!rc_bean.getMng_id().equals("")) {
								target_id = rc_bean.getMng_id();
							}
						}

						//사용자 정보 조회
						UsersBean target_bean1 = umd.getUsersBean(target_id);

						xml_data = "";
						xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
								+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>"
								+ cont + "</CONT>"
								+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
								+ url + "</URL>";

						xml_data += "    <TARGET>" + target_bean1.getId() + "</TARGET>";

						xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>"
								+ "    <MSGICON>10</MSGICON>" + "    <MSGSAVE>1</MSGSAVE>"
								+ "    <LEAVEDMSG>1</LEAVEDMSG>" + "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>"
								+ "</COOLMSG>";

						CdAlertBean msg1 = new CdAlertBean();
						msg1.setFlddata(xml_data);
						msg1.setFldtype("1");

						flag2 = cm_db.insertCoolMsg(msg1);

					}

					//월렌트료 자동전표생성 - 카드인 경우 매출로 부가세.... 추가할 것 				
					String acct_cont = "";

					if (!rc_bean.getRent_st().equals("2")) {

						if (value1[i].equals("6")) {
							if (ip_method.equals("2")) {
								acct_cont = "[카드 단기 월렌트 보증금]" + cr_bean.getCar_no() + "(" + client.getFirm_nm()
										+ ")";
							} else {
								acct_cont = "[단기 월렌트 보증금]" + cr_bean.getCar_no() + "(" + client.getFirm_nm()
										+ ")";
							}
						} else {
							if (ip_method.equals("2")) {
								acct_cont = "[카드 단기 월렌트료]" + cr_bean.getCar_no() + "(" + client.getFirm_nm()
										+ ")";
							} else {
								acct_cont = "[단기 월렌트료]" + cr_bean.getCar_no() + "(" + client.getFirm_nm() + ")";
							}
						}

					} else { //정비대차					
						acct_cont = "[ 정비대차]" + cr_bean.getCar_no() + "(" + client.getFirm_nm() + ")";
					}

					if (doc_cont.equals("")) {
						doc_cont = acct_cont;
					}

					line++;

					Hashtable ht44 = new Hashtable();

					if (value1[i].equals("6")) { // 보증금인 경우	- 카드는 안됨 - 돌려줄돈임.

						//월대여료 카드인 경우 매출로 처리 - 계산서 발행 안함.						
						if (ip_method.equals("2")) {

						} else {

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
							ht44.put("CD_ACCT", "31100"); //장기대여보증금
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
								vt.add(ht44); // 월렌트
							}
						}

					} else { //대여료인경우

						//월대여료 카드인 경우 매출로 처리 - 계산서 발행 안함.	- 지금은 월렌트로 세금계산서 발급 					
						if (ip_method.equals("2")) {

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
							ht44.put("CD_ACCT", "41200"); // 
							ht44.put("AMT", String.valueOf(i_tax_supply));
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

							ht44.put("NM_NOTE", doc_cont); // 적요									

							if (s_neom.equals("Y")) {
								vt.add(ht44); // 월렌트
							}

							line++;

							Hashtable ht44_2 = new Hashtable();

							ht44_2.put("WRITE_DATE", incom_dt); //row_id							
							ht44_2.put("ROW_NO", String.valueOf(line)); //row_no							
							ht44_2.put("NO_TAX", ""); //부가세 이외는 *
							ht44_2.put("CD_PC", node_code); //회계단위
							ht44_2.put("CD_WDEPT", dept_code); //부서
							ht44_2.put("NO_DOCU", ""); //row_id와 같게
							ht44_2.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
							ht44_2.put("CD_COMPANY", "1000");
							ht44_2.put("ID_WRITE", insert_id);
							ht44_2.put("CD_DOCU", "11");

							ht44_2.put("DT_ACCT", incom_dt);
							ht44_2.put("ST_DOCU", "1"); //미결:1, 승인:2  
							ht44_2.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1			
							ht44_2.put("CD_ACCT", "25500"); //부가세예수금					
							ht44_2.put("AMT", String.valueOf(i_tax_value));
							ht44_2.put("TP_GUBUN", "3"); //1:입금 2:출금 3:대체							
							ht44_2.put("CD_PARTNER", ven_code); //거래처    - A06

							ht44_2.put("DT_START", incom_dt); //발생일자 - 부가세										 
							ht44_2.put("CD_BIZAREA", "S101"); //귀속사업장	
							ht44_2.put("CD_DEPT", ""); //부서								 
							ht44_2.put("CD_CC", ""); //코스트센터		
							ht44_2.put("CD_PJT", ""); //프로젝트코드		
							ht44_2.put("CD_CARD", ""); //신용카드		 	
							ht44_2.put("CD_EMPLOY", ""); //사원									 		 
							ht44_2.put("NO_DEPOSIT", ""); //예적금계좌
							ht44_2.put("CD_BANK", ""); //금융기관	
							ht44_2.put("NO_ITEM", ""); //item	 	  	

							// 부가세관련
							ht44_2.put("AM_TAXSTD", String.valueOf(i_tax_supply)); //과세표준액
							ht44_2.put("AM_ADDTAX", String.valueOf(i_tax_value)); //세액
							ht44_2.put("TP_TAX", "12"); //과세(매출) :12 (신용카드)
							if (ven_type.equals("1")) { //개인
								ht44_2.put("NO_COMPANY", "8888888888"); // 개인사업자등록번호
							} else {
								ht44_2.put("NO_COMPANY", s_idno); //사업자등록번호
							}
							ht44_2.put("NM_NOTE", doc_cont); // 적요	

							if (s_neom.equals("Y")) {
								vt.add(ht44_2); // 월렌트
							}

						} else {

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
								vt.add(ht44); // 월렌트
							}

						}

					}

					//해지정산금
				} else if (value0[i].equals("scd_cls")) {

					ExtScdBean cls_scd = ae_db.getScd(value9[i], value10[i], value3[i]);

					cls_scd.setExt_pay_dt(incom_dt);
					cls_scd.setExt_pay_amt(pay_amt);
					cls_scd.setUpdate_id(user_id);
					cls_scd.setIncom_dt(incom_dt); //원장번호
					cls_scd.setIncom_seq(incom_seq);

					if (!ae_db.updateClsScd(cls_scd, "p", "Y", "1"))
						flag += 1; //

					//20180508 - 구분정산시 예정금액과 정산금액이 같은 경우 , 환불이 안된건인 경우
					if (est_amt == pay_amt && cls_scd.getJung_st().equals("2")) {

						//해지정산금 환불 정보 
						Hashtable pay = ac_db.getPayMngDt(value9[i], value10[i]);

						if (pay.get("P_PAY_DT") == null) {

							//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
							UsersBean sender_bean = umd.getUsersBean(user_id);

							String sub = " 구분정산시 해지정산금 입금";
							String cont = "▣ 구분정산시 해지정산금 입금 확인 :: " + client.getFirm_nm() + ", "	+ cr_bean.getCar_no() + ", 입금일:" + incom_dt + ", 입금액: " + pay_amt;
							String url = "/fms2/cls_cont/lc_cls_d_frame.jsp";

							String target_id = nm_db.getWorkAuthUser("해지관리자"); //입금담당자							
							CarScheBean cs_bean3 = csd.getCarScheTodayBean(target_id);

							if(!cs_bean3.getWork_id().equals("")) target_id =  cs_bean3.getWork_id();    // cs_bean
								
							//사용자 정보 조회
							UsersBean target_bean = umd.getUsersBean(target_id);

							String xml_data = "";
							xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
									+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>"
									+ cont + "</CONT>"
									+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
									+ url + "</URL>";

							xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";

							xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>"
									+ "    <MSGICON>10</MSGICON>" + "    <MSGSAVE>1</MSGSAVE>"
									+ "    <LEAVEDMSG>1</LEAVEDMSG>" + "    <FLDTYPE>1</FLDTYPE>"
									+ "  </ALERTMSG>" + "</COOLMSG>";

							CdAlertBean msg = new CdAlertBean();
							msg.setFlddata(xml_data);
							msg.setFldtype("1");

							flag2 = cm_db.insertCoolMsg(msg);

							System.out.println("쿨메신저(구분정산시 해지정산금 입금확인) " + client.getFirm_nm() + " :"
									+ cr_bean.getCar_no() + "---------------------" + target_bean.getUser_nm());
						}
					}

					out.println(cls_scd.getRent_mng_id());
					out.println(cls_scd.getRent_l_cd());

					//미입금된 면책금 중 계산서 미발행분
					//면책금 기청구된 건중 매출처리 여부 구분
					int car_ja_no_amt = 0;
					car_ja_no_amt = ac_db.getClsEtcCarNoAmt(value9[i], value10[i]);

					//해지정산금 자동전표생성 및 해지정산 cls_etc_sub 생성										
					String cls_value[] = new String[12];
					StringTokenizer st = new StringTokenizer(value12[i], "^");

					int s = 0;
					while (st.hasMoreTokens()) {
						cls_value[s] = st.nextToken();
						//		System.out.println(cls_value[s]);
						s++;
					}

					String cls_value0[] = new String[12]; //cid        
					String cls_value1[] = new String[12]; //xxx_amt_1  (no_v_amt_1) 
					String cls_value2[] = new String[12]; //xxx_amt_2  (no_v_amt_2) 
					String cls_value3[] = new String[12]; //xxx_amt_2_v  
					String cls_value4[] = new String[12]; //매출여부		    			    

					for (int ii = 0; ii < s; ii++) {

						StringTokenizer st1 = new StringTokenizer(cls_value[ii], ":");

						int s1 = 0;

						while (st1.hasMoreTokens()) {
							cls_value0[ii] = st1.nextToken();
							cls_value1[ii] = st1.nextToken();
							cls_value2[ii] = st1.nextToken();
							cls_value3[ii] = st1.nextToken();
							cls_value4[ii] = st1.nextToken();
						}

					}

					String cid = "";
					int amt_1 = 0;
					int amt_2 = 0;
					int amt_2_v = 0;
					String s_gubun = "";
					int amt_10800 = 0;

					//해지의뢰내역 저장
					ClsEtcSubBean clss = new ClsEtcSubBean();
					clss.setRent_mng_id(value9[i]);
					clss.setRent_l_cd(value10[i]);
					clss.setReg_id(user_id);

					for (int j = 0; j < s; j++) {

						cid = cls_value0[j] == null ? "" : cls_value0[j]; //cid
						amt_1 = cls_value1[j] == null ? 0 : AddUtil.parseDigit(cls_value1[j]);
						amt_2 = cls_value2[j] == null ? 0 : AddUtil.parseDigit(cls_value2[j]);
						amt_2_v = cls_value3[j] == null ? 0 : AddUtil.parseDigit(cls_value3[j]);
						s_gubun = cls_value4[j] == null ? "" : cls_value4[j];

						//과태료
						if (cid.equals("fine")) {
							clss.setFine_amt_1(amt_1);
							if (amt_2 > 0) {

								clss.setFine_amt_2(amt_2);

								// 과태료 상계 -  미수금
								doc_cont = "[해지정산 과태료]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();

								line++;

								Hashtable ht11_1 = new Hashtable();

								ht11_1.put("WRITE_DATE", incom_dt); //row_id						
								ht11_1.put("ROW_NO", String.valueOf(line)); //row_no								
								ht11_1.put("NO_TAX", "*"); //부가세 이외는 *
								ht11_1.put("CD_PC", node_code); //회계단위
								ht11_1.put("CD_WDEPT", dept_code); //부서
								ht11_1.put("NO_DOCU", ""); //row_id와 같게 
								ht11_1.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
								ht11_1.put("CD_COMPANY", "1000");
								ht11_1.put("ID_WRITE", insert_id);
								ht11_1.put("CD_DOCU", "11");

								ht11_1.put("DT_ACCT", incom_dt);
								ht11_1.put("ST_DOCU", "1"); //미결:1, 승인:2  
								ht11_1.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
								ht11_1.put("CD_ACCT", "12400"); //과태료예수금(27400) : , 과태료미수금 (12400)
								ht11_1.put("AMT", String.valueOf(amt_2));
								ht11_1.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체								
								ht11_1.put("CD_PARTNER", ven_code); //거래처    - A06

								ht11_1.put("DT_START", ""); //발생일자											 
								ht11_1.put("CD_BIZAREA", ""); //귀속사업장	
								ht11_1.put("CD_DEPT", ""); //부서								 
								ht11_1.put("CD_CC", ""); //코스트센터		
								ht11_1.put("CD_PJT", ""); //프로젝트코드	
								ht11_1.put("CD_CARD", ""); //신용카드			
								ht11_1.put("CD_EMPLOY", ""); //사원									
								ht11_1.put("NO_DEPOSIT", ""); //예적금계좌
								ht11_1.put("CD_BANK", ""); //금융기관	
								ht11_1.put("NO_ITEM", ""); //item 

								// 부가세관련
								ht11_1.put("AM_TAXSTD", ""); //과세표준액
								ht11_1.put("AM_ADDTAX", ""); //세액
								ht11_1.put("TP_TAX", ""); //과세(매출) :11
								ht11_1.put("NO_COMPANY", ""); //사업자등록번호

								ht11_1.put("NM_NOTE", doc_cont); // 적요		

								if (s_neom.equals("Y")) {
									vt.add(ht11_1); // 과태료				
								}
							}
						}
						//면책금
						if (cid.equals("car_ja")) {
							clss.setCar_ja_amt_1(amt_1);
							if (amt_2 > 0) {

								clss.setCar_ja_amt_2(amt_2);

								amt_10800 = amt_2 - car_ja_no_amt;

								doc_cont = "[해지정산 면책금]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();

								if (amt_10800 > 0) { //외상매출금이 있는 경우만 
									// 세금계산서 발행분을 제외한 부분을 외상매출금으로							 	  
									line++;

									Hashtable ht11_2 = new Hashtable();

									ht11_2.put("WRITE_DATE", incom_dt); //row_id								
									ht11_2.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_2.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_2.put("CD_PC", node_code); //회계단위
									ht11_2.put("CD_WDEPT", dept_code); //부서
									ht11_2.put("NO_DOCU", ""); // row_id와 같게 
									ht11_2.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_2.put("CD_COMPANY", "1000");
									ht11_2.put("ID_WRITE", insert_id);
									ht11_2.put("CD_DOCU", "11");

									ht11_2.put("DT_ACCT", incom_dt);
									ht11_2.put("ST_DOCU", "1"); //미결:1, 승인:2  
									//ht11_2.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1								 // 
									//ht11_2.put("CD_ACCT", "91800"); //면책금(91800)
									//ht11_2.put("AMT", String.valueOf(amt_10800));
									
									ht11_2.put("TP_DRCR", "1"); // 대변:2 , 차변:1		// 면책금에서 차량수리정비비(45510)으로 변경(20211116)
									ht11_2.put("CD_ACCT", "45510"); //면책금(91800)
									ht11_2.put("AMT", String.valueOf(amt_10800*(-1)));
									
									
									ht11_2.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체										
									ht11_2.put("CD_PARTNER", ven_code); //거래처    - A06

									ht11_2.put("DT_START", ""); //발생일자														 
									ht11_2.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_2.put("CD_DEPT", ""); //부서								 
									ht11_2.put("CD_CC", ""); //코스트센터		
									ht11_2.put("CD_PJT", ""); //프로젝트코드	
									ht11_2.put("CD_CARD", ""); //신용카드			
									ht11_2.put("CD_EMPLOY", ""); //사원											 		 
									ht11_2.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_2.put("CD_BANK", ""); //금융기관	
									ht11_2.put("NO_ITEM", ""); //item  

									// 부가세관련
									ht11_2.put("AM_TAXSTD", ""); //과세표준액
									ht11_2.put("AM_ADDTAX", ""); //세액
									ht11_2.put("TP_TAX", ""); //과세(매출) :11
									ht11_2.put("NO_COMPANY", ""); //사업자등록번호

									ht11_2.put("NM_NOTE", doc_cont); // 적요		

									if (s_neom.equals("Y")) {
										vt.add(ht11_2); //  외상매출금
									}
								}

								if (car_ja_no_amt > 0) { //차량손해면책금이 있는 경우만 

									line++;

									Hashtable ht11_3 = new Hashtable();

									ht11_3.put("WRITE_DATE", incom_dt); //row_id							
									ht11_3.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_3.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_3.put("CD_PC", node_code); //회계단위
									ht11_3.put("CD_WDEPT", dept_code); //부서
									ht11_3.put("NO_DOCU", ""); //row_id와 같게 
									ht11_3.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_3.put("CD_COMPANY", "1000");
									ht11_3.put("ID_WRITE", insert_id);
									ht11_3.put("CD_DOCU", "11");

									ht11_3.put("DT_ACCT", incom_dt);
									ht11_3.put("ST_DOCU", "1"); //미결:1, 승인:2  
									//ht11_3.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
									//ht11_3.put("CD_ACCT", "91800"); //면책금(91800)
									//ht11_3.put("AMT", String.valueOf(amt_2)); //입금액으로 변경 - 180425
									
									ht11_3.put("TP_DRCR", "1"); // 대변:2 , 차변:1
									ht11_3.put("CD_ACCT", "45510"); //면책금(91800)
									ht11_3.put("AMT", String.valueOf(amt_2*(-1))); //입금액으로 변경 - 180425			
									
									ht11_3.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체											
									ht11_3.put("CD_PARTNER", ven_code); //거래처    - A06

									ht11_3.put("DT_START", ""); //발생일자											 
									ht11_3.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_3.put("CD_DEPT", ""); //부서								 
									ht11_3.put("CD_CC", ""); //코스트센터		
									ht11_3.put("CD_PJT", ""); //프로젝트코드	
									ht11_3.put("CD_CARD", ""); //신용카드				
									ht11_3.put("CD_EMPLOY", ""); //사원											 		 
									ht11_3.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_3.put("CD_BANK", ""); //금융기관	
									ht11_3.put("NO_ITEM", ""); //item  	 

									// 부가세관련
									ht11_3.put("AM_TAXSTD", ""); //과세표준액
									ht11_3.put("AM_ADDTAX", ""); //세액
									ht11_3.put("TP_TAX", ""); //과세(매출) :11
									ht11_3.put("NO_COMPANY", ""); //사업자등록번호			 

									ht11_3.put("NM_NOTE", doc_cont); // 적요		

									if (s_neom.equals("Y")) {
										vt.add(ht11_3); // 면책금 
									}
								}

							}
						}

						//연체료
						if (cid.equals("dly")) {
							clss.setDly_amt_1(amt_1);
							if (amt_2 != 0) {

								clss.setDly_amt_2(amt_2);

								doc_cont = "[해지정산 연체료]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();

								line++;

								Hashtable ht11_4 = new Hashtable();

								ht11_4.put("WRITE_DATE", incom_dt); //row_id							
								ht11_4.put("ROW_NO", String.valueOf(line)); //row_no								
								ht11_4.put("NO_TAX", "*"); //부가세 이외는 *
								ht11_4.put("CD_PC", node_code); //회계단위
								ht11_4.put("CD_WDEPT", dept_code); //부서
								ht11_4.put("NO_DOCU", ""); //row_id와 같게 
								ht11_4.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
								ht11_4.put("CD_COMPANY", "1000");
								ht11_4.put("ID_WRITE", insert_id);
								ht11_4.put("CD_DOCU", "11");

								ht11_4.put("DT_ACCT", incom_dt);
								ht11_4.put("ST_DOCU", "1"); //미결:1, 승인:2  
								ht11_4.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
								ht11_4.put("CD_ACCT", "91300"); //연체료
								ht11_4.put("AMT", String.valueOf(amt_2));
								ht11_4.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체									
								ht11_4.put("CD_PARTNER", ven_code); //거래처    - A06

								ht11_4.put("DT_START", ""); //발생일자													 
								ht11_4.put("CD_BIZAREA", ""); //귀속사업장	
								ht11_4.put("CD_DEPT", ""); //부서								 
								ht11_4.put("CD_CC", ""); //코스트센터		
								ht11_4.put("CD_PJT", ""); //프로젝트코드	
								ht11_4.put("CD_CARD", ""); //신용카드			
								ht11_4.put("CD_EMPLOY", ""); //사원										 		 
								ht11_4.put("NO_DEPOSIT", ""); //예적금계좌
								ht11_4.put("CD_BANK", ""); //금융기관	
								ht11_4.put("NO_ITEM", ""); //item  

								// 부가세관련
								ht11_4.put("AM_TAXSTD", ""); //과세표준액
								ht11_4.put("AM_ADDTAX", ""); //세액
								ht11_4.put("TP_TAX", ""); //과세(매출) :11
								ht11_4.put("NO_COMPANY", ""); //사업자등록번호	 	  

								ht11_4.put("NM_NOTE", doc_cont); // 적요	

								if (s_neom.equals("Y")) {
									vt.add(ht11_4); // 연체료		
								}
							}
						}

						//대여료
						if (cid.equals("fee")) {
							clss.setDfee_amt_1(amt_1);
							if (amt_2 != 0) {

								clss.setDfee_amt_2(amt_2);
								clss.setDfee_amt_2_v(amt_2_v);

								doc_cont = "[해지정산 대여료]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();

								line++;

								Hashtable ht11_5 = new Hashtable();

								ht11_5.put("WRITE_DATE", incom_dt); //row_id							
								ht11_5.put("ROW_NO", String.valueOf(line)); //row_no								
								ht11_5.put("NO_TAX", "*"); //부가세 이외는 *
								ht11_5.put("CD_PC", node_code); //회계단위
								ht11_5.put("CD_WDEPT", dept_code); //부서
								ht11_5.put("NO_DOCU", ""); //row_id와 같게 
								ht11_5.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
								ht11_5.put("CD_COMPANY", "1000");
								ht11_5.put("ID_WRITE", insert_id);
								ht11_5.put("CD_DOCU", "11");

								ht11_5.put("DT_ACCT", incom_dt);
								ht11_5.put("ST_DOCU", "1"); //미결:1, 승인:2  
								ht11_5.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
								ht11_5.put("CD_ACCT", "10800"); // 
								ht11_5.put("AMT", String.valueOf(amt_2 + amt_2_v));
								ht11_5.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체									
								ht11_5.put("CD_PARTNER", ven_code); //거래처    - A06

								ht11_5.put("DT_START", ""); //발생일자													 
								ht11_5.put("CD_BIZAREA", ""); //귀속사업장	
								ht11_5.put("CD_DEPT", ""); //부서								 
								ht11_5.put("CD_CC", ""); //코스트센터		
								ht11_5.put("CD_PJT", ""); //프로젝트코드	
								ht11_5.put("CD_CARD", ""); //신용카드				
								ht11_5.put("CD_EMPLOY", ""); //사원										 		 
								ht11_5.put("NO_DEPOSIT", ""); //예적금계좌
								ht11_5.put("CD_BANK", ""); //금융기관	
								ht11_5.put("NO_ITEM", ""); //item  		 

								// 부가세관련
								ht11_5.put("AM_TAXSTD", ""); //과세표준액
								ht11_5.put("AM_ADDTAX", ""); //세액
								ht11_5.put("TP_TAX", ""); //과세(매출) :11
								ht11_5.put("NO_COMPANY", ""); //사업자등록번호

								ht11_5.put("NM_NOTE", doc_cont); // 적요		

								if (s_neom.equals("Y")) {
									vt.add(ht11_5); //  외상매출금		
								}
							}
						}

						//위약금
						if (cid.equals("dft")) {
							clss.setDft_amt_1(amt_1);
							if (amt_2 > 0) {

								clss.setDft_amt_2(amt_2);
								clss.setDft_amt_2_v(amt_2_v);

								doc_cont = "[해지정산 위약금]" + "-" + cr_bean.getCar_no() + " " + client.getFirm_nm();

								if (s_gubun.equals("Y")) {

									line++;

									Hashtable ht11_6 = new Hashtable();

									ht11_6.put("WRITE_DATE", incom_dt); //row_id								
									ht11_6.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_6.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_6.put("CD_PC", node_code); //회계단위
									ht11_6.put("CD_WDEPT", dept_code); //부서
									ht11_6.put("NO_DOCU", ""); // row_id와 같게 
									ht11_6.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_6.put("CD_COMPANY", "1000");
									ht11_6.put("ID_WRITE", insert_id);
									ht11_6.put("CD_DOCU", "11");

									ht11_6.put("DT_ACCT", incom_dt);
									ht11_6.put("ST_DOCU", "1"); //미결:1, 승인:2  
									ht11_6.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
									ht11_6.put("CD_ACCT", "10800"); // 
									ht11_6.put("AMT", String.valueOf(amt_2 + amt_2_v));
									ht11_6.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체													
									ht11_6.put("CD_PARTNER", ven_code); //거래처    - A06

									ht11_6.put("DT_START", ""); //발생일자														 
									ht11_6.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_6.put("CD_DEPT", ""); //부서								 
									ht11_6.put("CD_CC", ""); //코스트센터		
									ht11_6.put("CD_PJT", ""); //프로젝트코드	
									ht11_6.put("CD_CARD", ""); //신용카드		
									ht11_6.put("CD_EMPLOY", ""); //사원										 		 
									ht11_6.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_6.put("CD_BANK", ""); //금융기관	
									ht11_6.put("NO_ITEM", ""); //item  		 

									// 부가세관련
									ht11_6.put("AM_TAXSTD", ""); //과세표준액
									ht11_6.put("AM_ADDTAX", ""); //세액
									ht11_6.put("TP_TAX", ""); //과세(매출) :11
									ht11_6.put("NO_COMPANY", ""); //사업자등록번호

									ht11_6.put("NM_NOTE", doc_cont); // 적요									

									if (s_neom.equals("Y")) {
										vt.add(ht11_6); //  외상매출금		
									}

								} else {

									line++;

									Hashtable ht11_7 = new Hashtable();

									ht11_7.put("WRITE_DATE", incom_dt); //row_id								
									ht11_7.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_7.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_7.put("CD_PC", node_code); //회계단위
									ht11_7.put("CD_WDEPT", dept_code); //부서
									ht11_7.put("NO_DOCU", ""); // row_id와 같게 
									ht11_7.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_7.put("CD_COMPANY", "1000");
									ht11_7.put("ID_WRITE", insert_id);
									ht11_7.put("CD_DOCU", "11");

									ht11_7.put("DT_ACCT", incom_dt);
									ht11_7.put("ST_DOCU", "1"); //미결:1, 승인:2  
									ht11_7.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1

									if (cr_bean.getCar_use().equals("1")) { //렌트이면
										ht11_7.put("CD_ACCT", "41400"); //해지수익	
									} else {
										ht11_7.put("CD_ACCT", "41800"); //해지수익
									}

									ht11_7.put("AMT", String.valueOf(amt_2));
									ht11_7.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체											
									ht11_7.put("CD_PARTNER", "000131"); //거래처    - A06

									ht11_7.put("DT_START", ""); //발생일자																							 
									ht11_7.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_7.put("CD_DEPT", ""); //부서								 
									ht11_7.put("CD_CC", ""); //코스트센터		
									ht11_7.put("CD_PJT", ""); //프로젝트코드		
									ht11_7.put("CD_CARD", ""); //신용카드		
									ht11_7.put("CD_EMPLOY", ""); //사원											 		 
									ht11_7.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_7.put("CD_BANK", ""); //금융기관	
									ht11_7.put("NO_ITEM", ""); //item  		

									// 부가세관련
									ht11_7.put("AM_TAXSTD", ""); //과세표준액
									ht11_7.put("AM_ADDTAX", ""); //세액
									ht11_7.put("TP_TAX", ""); //과세(매출) :11
									ht11_7.put("NO_COMPANY", ""); //사업자등록번호  	 

									ht11_7.put("NM_NOTE", doc_cont); // 적요	 				

									if (s_neom.equals("Y")) {
										vt.add(ht11_7); //  공급가			
									}
								}

							}
						}

						//회수비용
						if (cid.equals("etc")) {
							clss.setEtc_amt_1(amt_1);
							if (amt_2 > 0) {

								clss.setEtc_amt_2(amt_2);
								clss.setEtc_amt_2_v(amt_2_v);

								doc_cont = "[해지정산 회수비용]" + "-" + cr_bean.getCar_no() + " "
										+ client.getFirm_nm();

								if (s_gubun.equals("Y")) {

									line++;

									Hashtable ht11_8 = new Hashtable();

									ht11_8.put("WRITE_DATE", incom_dt); //row_id								
									ht11_8.put("ROW_NO", String.valueOf(line)); //row_no

									ht11_8.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_8.put("CD_PC", node_code); //회계단위
									ht11_8.put("CD_WDEPT", dept_code); //부서
									ht11_8.put("NO_DOCU", ""); //row_id와 같게
									ht11_8.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_8.put("CD_COMPANY", "1000");
									ht11_8.put("ID_WRITE", insert_id);
									ht11_8.put("CD_DOCU", "11");

									ht11_8.put("DT_ACCT", incom_dt);
									ht11_8.put("ST_DOCU", "1"); //미결:1, 승인:2  
									ht11_8.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
									ht11_8.put("CD_ACCT", "10800"); // 
									ht11_8.put("AMT", String.valueOf(amt_2 + amt_2_v));
									ht11_8.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체	
									ht11_8.put("CD_PARTNER", ven_code); //거래처    - A06

									ht11_8.put("DT_START", ""); //발생일자														 
									ht11_8.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_8.put("CD_DEPT", ""); //부서								 
									ht11_8.put("CD_CC", ""); //코스트센터		
									ht11_8.put("CD_PJT", ""); //프로젝트코드	
									ht11_8.put("CD_CARD", ""); //신용카드			
									ht11_8.put("CD_EMPLOY", ""); //사원											 		 
									ht11_8.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_8.put("CD_BANK", ""); //금융기관	
									ht11_8.put("NO_ITEM", ""); //item  		

									// 부가세관련
									ht11_8.put("AM_TAXSTD", ""); //과세표준액
									ht11_8.put("AM_ADDTAX", ""); //세액
									ht11_8.put("TP_TAX", ""); //과세(매출) :11
									ht11_8.put("NO_COMPANY", ""); //사업자등록번호  	 

									ht11_8.put("NM_NOTE", doc_cont); // 적요		

									if (s_neom.equals("Y")) {
										vt.add(ht11_8); //  외상매출금			
									}

								} else {

									line++;

									Hashtable ht11_9 = new Hashtable();

									ht11_9.put("WRITE_DATE", incom_dt); //row_id
									ht11_9.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_9.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_9.put("CD_PC", node_code); //회계단위
									ht11_9.put("CD_WDEPT", dept_code); //부서
									ht11_9.put("NO_DOCU", ""); //row_id와 같게 
									ht11_9.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_9.put("CD_COMPANY", "1000");
									ht11_9.put("ID_WRITE", insert_id);
									ht11_9.put("CD_DOCU", "11");

									ht11_9.put("DT_ACCT", incom_dt);
									ht11_9.put("ST_DOCU", "1"); //미결:1, 승인:2  
									//ht11_9.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
									//ht11_9.put("CD_ACCT", "91800"); //면책금(91800)
									//ht11_9.put("AMT", String.valueOf(amt_2));
									ht11_9.put("TP_DRCR", "1"); // 대변:2 , 차변:1
									ht11_9.put("CD_ACCT", "45510"); //면책금(91800)
									ht11_9.put("AMT", String.valueOf(amt_2*(-1)));
									
									ht11_9.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체											
									ht11_9.put("CD_PARTNER", "000131"); //거래처    - A06

									ht11_9.put("DT_START", ""); //발생일자														 
									ht11_9.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_9.put("CD_DEPT", ""); //부서								 
									ht11_9.put("CD_CC", ""); //코스트센터		
									ht11_9.put("CD_PJT", ""); //프로젝트코드		
									ht11_9.put("CD_CARD", ""); //신용카드	
									ht11_9.put("CD_EMPLOY", ""); //사원											 		 
									ht11_9.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_9.put("CD_BANK", ""); //금융기관	
									ht11_9.put("NO_ITEM", ""); //item  		   	 

									// 부가세관련
									ht11_9.put("AM_TAXSTD", ""); //과세표준액
									ht11_9.put("AM_ADDTAX", ""); //세액
									ht11_9.put("TP_TAX", ""); //과세(매출) :11
									ht11_9.put("NO_COMPANY", ""); //사업자등록번호

									ht11_9.put("NM_NOTE", doc_cont); // 적요					

									if (s_neom.equals("Y")) {
										vt.add(ht11_9); //  공급가	
									}
								}

							}
						}

						//부대비용
						if (cid.equals("etc2")) {
							clss.setEtc2_amt_1(amt_1);
							if (amt_2 > 0) {

								clss.setEtc2_amt_2(amt_2);
								clss.setEtc2_amt_2_v(amt_2_v);

								doc_cont = "[해지정산 부대비용]" + "-" + cr_bean.getCar_no() + " "
										+ client.getFirm_nm();

								if (s_gubun.equals("Y")) {

									line++;

									Hashtable ht11_10 = new Hashtable();

									ht11_10.put("WRITE_DATE", incom_dt); //row_id								
									ht11_10.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_10.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_10.put("CD_PC", node_code); //회계단위
									ht11_10.put("CD_WDEPT", dept_code); //부서
									ht11_10.put("NO_DOCU", ""); //row_id와 같게 
									ht11_10.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_10.put("CD_COMPANY", "1000");
									ht11_10.put("ID_WRITE", insert_id);
									ht11_10.put("CD_DOCU", "11");

									ht11_10.put("DT_ACCT", incom_dt);
									ht11_10.put("ST_DOCU", "1"); //미결:1, 승인:2  
									ht11_10.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
									ht11_10.put("CD_ACCT", "10800"); // 
									ht11_10.put("AMT", String.valueOf(amt_2 + amt_2_v));
									ht11_10.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체										
									ht11_10.put("CD_PARTNER", ven_code); //거래처    - A06

									ht11_10.put("DT_START", ""); //발생일자											 
									ht11_10.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_10.put("CD_DEPT", ""); //부서								 
									ht11_10.put("CD_CC", ""); //코스트센터		
									ht11_10.put("CD_PJT", ""); //프로젝트코드		
									ht11_10.put("CD_CARD", ""); //신용카드	
									ht11_10.put("CD_EMPLOY", ""); //사원											 		 
									ht11_10.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_10.put("CD_BANK", ""); //금융기관	
									ht11_10.put("NO_ITEM", ""); //item  		   	 

									// 부가세관련
									ht11_10.put("AM_TAXSTD", ""); //과세표준액
									ht11_10.put("AM_ADDTAX", ""); //세액
									ht11_10.put("TP_TAX", ""); //과세(매출) :11
									ht11_10.put("NO_COMPANY", ""); //사업자등록번호	 

									ht11_10.put("NM_NOTE", doc_cont); // 적요		

									if (s_neom.equals("Y")) {
										vt.add(ht11_10); //  외상매출금
									}

								} else {

									line++;

									Hashtable ht11_11 = new Hashtable();

									ht11_11.put("WRITE_DATE", incom_dt); //row_id								
									ht11_11.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_11.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_11.put("CD_PC", node_code); //회계단위
									ht11_11.put("CD_WDEPT", dept_code); //부서
									ht11_11.put("NO_DOCU", ""); //row_id와 같게 
									ht11_11.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_11.put("CD_COMPANY", "1000");
									ht11_11.put("ID_WRITE", insert_id);
									ht11_11.put("CD_DOCU", "11");

									ht11_11.put("DT_ACCT", incom_dt);
									ht11_11.put("ST_DOCU", "1"); //미결:1, 승인:2  
									//ht11_11.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
									//ht11_11.put("CD_ACCT", "91800"); //부대비용
									//ht11_11.put("AMT", String.valueOf(amt_2));
									ht11_11.put("TP_DRCR", "1"); // 대변:2 , 차변:1
									ht11_11.put("CD_ACCT", "45510"); //부대비용
									ht11_11.put("AMT", String.valueOf(amt_2*(-1)));
									
									ht11_11.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체										
									ht11_11.put("CD_PARTNER", "000131"); //거래처    - A06

									ht11_11.put("DT_START", ""); //발생일자	
									ht11_11.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_11.put("CD_DEPT", ""); //부서								 
									ht11_11.put("CD_CC", ""); //코스트센터		
									ht11_11.put("CD_PJT", ""); //프로젝트코드	
									ht11_11.put("CD_CARD", ""); //신용카드		
									ht11_11.put("CD_EMPLOY", ""); //사원											 		 
									ht11_11.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_11.put("CD_BANK", ""); //금융기관	
									ht11_11.put("NO_ITEM", ""); //item  		  

									// 부가세관련
									ht11_11.put("AM_TAXSTD", ""); //과세표준액
									ht11_11.put("AM_ADDTAX", ""); //세액
									ht11_11.put("TP_TAX", ""); //과세(매출) :11
									ht11_11.put("NO_COMPANY", ""); //사업자등록번호 	 	 	 	 

									ht11_11.put("NM_NOTE", doc_cont); // 적요					

									if (s_neom.equals("Y")) {
										vt.add(ht11_11); //  공급가			
									}
								}
							}
						}

						//기타손해배상금
						if (cid.equals("etc4")) {
							clss.setEtc4_amt_1(amt_1);
							if (amt_2 > 0) {

								clss.setEtc4_amt_2(amt_2);
								clss.setEtc4_amt_2_v(amt_2_v);

								doc_cont = "[해지정산 기타손해배상금]" + "-" + cr_bean.getCar_no() + " "
										+ client.getFirm_nm();

								if (s_gubun.equals("Y")) {

									line++;

									Hashtable ht11_12 = new Hashtable();

									ht11_12.put("WRITE_DATE", incom_dt); //row_id								
									ht11_12.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_12.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_12.put("CD_PC", node_code); //회계단위
									ht11_12.put("CD_WDEPT", dept_code); //부서
									ht11_12.put("NO_DOCU", ""); //row_id와 같게 
									ht11_12.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_12.put("CD_COMPANY", "1000");
									ht11_12.put("ID_WRITE", insert_id);
									ht11_12.put("CD_DOCU", "11");

									ht11_12.put("DT_ACCT", incom_dt);
									ht11_12.put("ST_DOCU", "1"); //미결:1, 승인:2  
									ht11_12.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
									ht11_12.put("CD_ACCT", "10800"); // 
									ht11_12.put("AMT", String.valueOf(amt_2 + amt_2_v));
									ht11_12.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체										
									ht11_12.put("CD_PARTNER", ven_code); //거래처    - A06

									ht11_12.put("DT_START", ""); //발생일자	
									ht11_12.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_12.put("CD_DEPT", ""); //부서								 
									ht11_12.put("CD_CC", ""); //코스트센터		
									ht11_12.put("CD_PJT", ""); //프로젝트코드	
									ht11_12.put("CD_CARD", ""); //신용카드		
									ht11_12.put("CD_EMPLOY", ""); //사원											 		 
									ht11_12.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_12.put("CD_BANK", ""); //금융기관	
									ht11_12.put("NO_ITEM", ""); //item  	

									// 부가세관련
									ht11_12.put("AM_TAXSTD", ""); //과세표준액
									ht11_12.put("AM_ADDTAX", ""); //세액
									ht11_12.put("TP_TAX", ""); //과세(매출) :11
									ht11_12.put("NO_COMPANY", ""); //사업자등록번호	   	 	 	 

									ht11_12.put("NM_NOTE", doc_cont); // 적요	

									if (s_neom.equals("Y")) {
										vt.add(ht11_12); //  외상매출금	
									}

								} else {

									line++;

									Hashtable ht11_13 = new Hashtable();

									ht11_13.put("WRITE_DATE", incom_dt); //row_id									
									ht11_13.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_13.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_13.put("CD_PC", node_code); //회계단위
									ht11_13.put("CD_WDEPT", dept_code); //부서
									ht11_13.put("NO_DOCU", ""); //row_id와 같게 
									ht11_13.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_13.put("CD_COMPANY", "1000");
									ht11_13.put("ID_WRITE", insert_id);
									ht11_13.put("CD_DOCU", "11");

									ht11_13.put("DT_ACCT", incom_dt);
									ht11_13.put("ST_DOCU", "1"); //미결:1, 승인:2  
								//	ht11_13.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
								//	ht11_13.put("CD_ACCT", "91800"); //부대비용
								//	ht11_13.put("AMT", String.valueOf(amt_2));
									ht11_13.put("TP_DRCR", "1"); // 대변:2 , 차변:1
									ht11_13.put("CD_ACCT", "45510"); //부대비용
									ht11_13.put("AMT", String.valueOf(amt_2*(-1)));
									ht11_13.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체											
									ht11_13.put("CD_PARTNER", "000131"); //거래처    - A06

									ht11_13.put("DT_START", ""); //발생일자											 
									ht11_13.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_13.put("CD_DEPT", ""); //부서								 
									ht11_13.put("CD_CC", ""); //코스트센터		
									ht11_13.put("CD_PJT", ""); //프로젝트코드	
									ht11_13.put("CD_CARD", ""); //신용카드			
									ht11_13.put("CD_EMPLOY", ""); //사원											 		 
									ht11_13.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_13.put("CD_BANK", ""); //금융기관	
									ht11_13.put("NO_ITEM", ""); //item  

									// 부가세관련
									ht11_13.put("AM_TAXSTD", ""); //과세표준액
									ht11_13.put("AM_ADDTAX", ""); //세액
									ht11_13.put("TP_TAX", ""); //과세(매출) :11
									ht11_13.put("NO_COMPANY", ""); //사업자등록번호		   	 

									ht11_13.put("NM_NOTE", doc_cont); // 적요					

									if (s_neom.equals("Y")) {
										vt.add(ht11_13); //  공급가	
									}
								}
							}
						}

						//초과운행
						if (cid.equals("over")) {
							clss.setOver_amt_1(amt_1);
							if (amt_2 > 0) {

								clss.setOver_amt_2(amt_2);
								clss.setOver_amt_2_v(amt_2_v);

								doc_cont = "[해지정산 추가운행부담금]" + "-" + cr_bean.getCar_no() + " "
										+ client.getFirm_nm();

								if (s_gubun.equals("Y")) {

									line++;

									Hashtable ht11_14 = new Hashtable();

									ht11_14.put("WRITE_DATE", incom_dt); //row_id								
									ht11_14.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_14.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_14.put("CD_PC", node_code); //회계단위
									ht11_14.put("CD_WDEPT", dept_code); //부서
									ht11_14.put("NO_DOCU", ""); //row_id와 같게 
									ht11_14.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_14.put("CD_COMPANY", "1000");
									ht11_14.put("ID_WRITE", insert_id);
									ht11_14.put("CD_DOCU", "11");

									ht11_14.put("DT_ACCT", incom_dt);
									ht11_14.put("ST_DOCU", "1"); //미결:1, 승인:2  
									ht11_14.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
									ht11_14.put("CD_ACCT", "10800"); // 
									ht11_14.put("AMT", String.valueOf(amt_2 + amt_2_v));
									ht11_14.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체										
									ht11_14.put("CD_PARTNER", ven_code); //거래처    - A06

									ht11_14.put("DT_START", ""); //발생일자	
									ht11_14.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_14.put("CD_DEPT", ""); //부서								 
									ht11_14.put("CD_CC", ""); //코스트센터		
									ht11_14.put("CD_PJT", ""); //프로젝트코드	
									ht11_14.put("CD_CARD", ""); //신용카드		
									ht11_14.put("CD_EMPLOY", ""); //사원											 		 
									ht11_14.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_14.put("CD_BANK", ""); //금융기관	
									ht11_14.put("NO_ITEM", ""); //item  	

									// 부가세관련
									ht11_14.put("AM_TAXSTD", ""); //과세표준액
									ht11_14.put("AM_ADDTAX", ""); //세액
									ht11_14.put("TP_TAX", ""); //과세(매출) :11
									ht11_14.put("NO_COMPANY", ""); //사업자등록번호	   	 	 	 

									ht11_14.put("NM_NOTE", doc_cont); // 적요	

									if (s_neom.equals("Y")) {
										vt.add(ht11_14); //  외상매출금	
									}

								} else {

									line++;

									Hashtable ht11_15 = new Hashtable();

									ht11_15.put("WRITE_DATE", incom_dt); //row_id								
									ht11_15.put("ROW_NO", String.valueOf(line)); //row_no									
									ht11_15.put("NO_TAX", "*"); //부가세 이외는 *
									ht11_15.put("CD_PC", node_code); //회계단위
									ht11_15.put("CD_WDEPT", dept_code); //부서
									ht11_15.put("NO_DOCU", ""); // row_id와 같게 
									ht11_15.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
									ht11_15.put("CD_COMPANY", "1000");
									ht11_15.put("ID_WRITE", insert_id);
									ht11_15.put("CD_DOCU", "11");

									ht11_15.put("DT_ACCT", incom_dt);
									ht11_15.put("ST_DOCU", "1"); //미결:1, 승인:2  
									ht11_15.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1

									if (cr_bean.getCar_use().equals("1")) { //렌트이면
										ht11_15.put("CD_ACCT", "41400"); //해지수익	
									} else {
										ht11_15.put("CD_ACCT", "41800"); //해지수익
									}

									ht11_15.put("AMT", String.valueOf(amt_2));
									ht11_15.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체											
									ht11_15.put("CD_PARTNER", "000131"); //거래처    - A06

									ht11_15.put("DT_START", ""); //발생일자																							 
									ht11_15.put("CD_BIZAREA", ""); //귀속사업장	
									ht11_15.put("CD_DEPT", ""); //부서								 
									ht11_15.put("CD_CC", ""); //코스트센터		
									ht11_15.put("CD_PJT", ""); //프로젝트코드		
									ht11_15.put("CD_CARD", ""); //신용카드		
									ht11_15.put("CD_EMPLOY", ""); //사원											 		 
									ht11_15.put("NO_DEPOSIT", ""); //예적금계좌
									ht11_15.put("CD_BANK", ""); //금융기관	
									ht11_15.put("NO_ITEM", ""); //item  		

									// 부가세관련
									ht11_15.put("AM_TAXSTD", ""); //과세표준액
									ht11_15.put("AM_ADDTAX", ""); //세액
									ht11_15.put("TP_TAX", ""); //과세(매출) :11
									ht11_15.put("NO_COMPANY", ""); //사업자등록번호  	 

									ht11_15.put("NM_NOTE", doc_cont); // 적요	 				

									if (s_neom.equals("Y")) {
										vt.add(ht11_15); //  공급가			
									}
								}
							}
						}

						//미지급금 - 카드인 경우 취소 
						if (cid.equals("c_pay")) {

							if (amt_2 != 0) {

								doc_cont = "[해지정산 미지급금]" + "-" + cr_bean.getCar_no() + " "
										+ client.getFirm_nm();

								line++;

								Hashtable ht11_16 = new Hashtable();

								ht11_16.put("WRITE_DATE", incom_dt); //row_id							
								ht11_16.put("ROW_NO", String.valueOf(line)); //row_no								
								ht11_16.put("NO_TAX", "*"); //부가세 이외는 *
								ht11_16.put("CD_PC", node_code); //회계단위
								ht11_16.put("CD_WDEPT", dept_code); //부서
								ht11_16.put("NO_DOCU", ""); //row_id와 같게 
								ht11_16.put("NO_DOLINE", String.valueOf(line)); //row_no  : 미결인 경우???
								ht11_16.put("CD_COMPANY", "1000");
								ht11_16.put("ID_WRITE", insert_id);
								ht11_16.put("CD_DOCU", "11");

								ht11_16.put("DT_ACCT", incom_dt);
								ht11_16.put("ST_DOCU", "1"); //미결:1, 승인:2  
								ht11_16.put("TP_DRCR", amt_gubun); // 대변:2 , 차변:1
								ht11_16.put("CD_ACCT", "25300"); //미지급금
								ht11_16.put("AMT", String.valueOf(amt_2));
								ht11_16.put("TP_GUBUN", docu_gubun); //1:입금 2:출금 3:대체									
								ht11_16.put("CD_PARTNER", ven_code); //거래처    - A06

								ht11_16.put("DT_START", ""); //발생일자													 
								ht11_16.put("CD_BIZAREA", ""); //귀속사업장	
								ht11_16.put("CD_DEPT", ""); //부서								 
								ht11_16.put("CD_CC", ""); //코스트센터		
								ht11_16.put("CD_PJT", ""); //프로젝트코드	
								ht11_16.put("CD_CARD", ""); //신용카드			
								ht11_16.put("CD_EMPLOY", ""); //사원										 		 
								ht11_16.put("NO_DEPOSIT", ""); //예적금계좌
								ht11_16.put("CD_BANK", ""); //금융기관	
								ht11_16.put("NO_ITEM", ""); //item  

								// 부가세관련
								ht11_16.put("AM_TAXSTD", ""); //과세표준액
								ht11_16.put("AM_ADDTAX", ""); //세액
								ht11_16.put("TP_TAX", ""); //과세(매출) :11
								ht11_16.put("NO_COMPANY", ""); //사업자등록번호	 	  

								ht11_16.put("NM_NOTE", doc_cont); // 적요	

								if (s_neom.equals("Y")) {
									vt.add(ht11_16); // 미지급금 
								}
							}
						}

						//vat계
						if (cid.equals("vat")) {
							clss.setNo_v_amt_1(amt_1);
							clss.setNo_v_amt_2(amt_2);
						}

					} //end for	

					//해지의뢰서브내역 저장	
					if (!ac_db.insertClsEtcSubIncom(clss))
						flag += 1;

				} //해지정산금

			} //pay_amt > 0
			out.println("<br>");
		} //end for 

		if (line > 1) {
			doc_cont = doc_cont + " 외";
		}
	}

	if (neom.equals("Y")) {

		// 선수금 , 가수금 
		if (ip_acct.equals("0") || ip_acct.equals("15")) {

			//메세지 보내기 체크된 경우
			if (cool.equals("Y")) {

				//대출금 입금인 경우			
				int ep = 0;
				ep = remark.indexOf("대출금");

				if (ep != -1) {

					//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
					UsersBean sender_bean = umd.getUsersBean(user_id);

					String sub = "대출금 입금";
					String cont = "▣ 대출금입금 확인 :: " + n_ven_name + ", " + remark + ", 입금일:" + incom_dt
							+ ", 입금액: " + AddUtil.parseDecimalLong(ip_acct_amt) + "이 입금되었습니다.";
					String url = "/acar/bank_mng/bank_doc_mng_frame.jsp";
					String target_id = "";

					target_id = "000004"; //총무팀장	

					//사용자 정보 조회 - 대출담당자
					UsersBean target_bean = umd.getUsersBean(target_id);
					String xml_data = "";

					xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
							+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>" + cont
							+ "</CONT>"
							+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
							+ url + "</URL>";

					xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";
					xml_data += "    <TARGET>2004005</TARGET>"; //김태우
					xml_data += "    <TARGET>2010003</TARGET>"; //박휘영 
					xml_data += "    <TARGET>2013002</TARGET>"; //조현준

					xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
							+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>"
							+ "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>" + "</COOLMSG>";

					CdAlertBean msg = new CdAlertBean();
					msg.setFlddata(xml_data);
					msg.setFldtype("1");

					flag2 = cm_db.insertCoolMsg(msg);

					System.out.println(
							"쿨메신저(대출선수금입금확인)" + n_ven_name + ", " + AddUtil.parseDecimalLong(ip_acct_amt)
									+ " --------------------" + target_bean.getUser_nm());

					gg_chk = "N";

				}

				//경매 입금인 경우			
				int ep1 = 0;
				ep1 = remark.indexOf("경매");

				if (ep1 != -1) {

					//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
					UsersBean sender_bean = umd.getUsersBean(user_id);

					String sub = "경매매각대금 입금";
					String cont = "▣ 경매매각대금입금 확인 :: " + n_ven_name + ", " + remark + ", 입금일:" + incom_dt
							+ ", 입금액: " + AddUtil.parseDecimalLong(ip_acct_amt) + "이 입금되었습니다.";
					String url = "/acar/bank_mng/bank_doc_mng_frame.jsp";
					String target_id = "";

					target_id = "000004"; //총무팀장	

					//사용자 정보 조회 -경매매각 담당자
					UsersBean target_bean = umd.getUsersBean(target_id);
					String xml_data = "";

					xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
							+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>" + cont
							+ "</CONT>"
							+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
							+ url + "</URL>";

					xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";				
			//		xml_data += "    <TARGET>2013002</TARGET>"; //조현준
					xml_data += "    <TARGET>2011008</TARGET>"; //계성진

					xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
							+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>"
							+ "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>" + "</COOLMSG>";

					CdAlertBean msg = new CdAlertBean();
					msg.setFlddata(xml_data);
					msg.setFldtype("1");

					flag2 = cm_db.insertCoolMsg(msg);

					System.out.println(
							"쿨메신저(경매선수금입금확인)" + n_ven_name + ", " + AddUtil.parseDecimalLong(ip_acct_amt)
									+ " --------------------" + target_bean.getUser_nm());

					gg_chk = "N";
				}

				//경매 입금인 경우			
				int ep2 = 0;
				ep2 = remark.indexOf("수의계약");

				if (ep2 != -1) {

					//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
					UsersBean sender_bean = umd.getUsersBean(user_id);

					String sub = "수의계약 입금";
					String cont = "▣ 수의계약 확인 :: " + n_ven_name + ", " + remark + ", 입금일:" + incom_dt + ", 입금액: "
							+ AddUtil.parseDecimalLong(ip_acct_amt) + "이 입금되었습니다.";
					String url = "/acar/off_ls_sui/off_ls_sui_frame.jsp";

					String target_id = "000197";

					//사용자 정보 조회 -경매매각 담당자
					UsersBean target_bean = umd.getUsersBean(target_id);
					String xml_data = "";

					xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
							+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>" + cont
							+ "</CONT>"
							+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
							+ url + "</URL>";

					xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";

					xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
							+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>"
							+ "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>" + "</COOLMSG>";

					CdAlertBean msg = new CdAlertBean();
					msg.setFlddata(xml_data);
					msg.setFldtype("1");

					flag2 = cm_db.insertCoolMsg(msg);

					System.out.println(
							"쿨메신저(수의계약 입금확인)" + n_ven_name + ", " + AddUtil.parseDecimalLong(ip_acct_amt)
									+ " --------------------" + target_bean.getUser_nm());

					gg_chk = "N";
				}

				
				//경매 입금인 경우			
				int ep3 = 0;
				ep3 = remark.indexOf("자체출고캐쉬백수익");

				if (ep3 != -1) {

					//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
					UsersBean sender_bean = umd.getUsersBean(user_id);

					String sub = "자체출고캐쉬백수익  입금";
					String cont = "▣ 자체출고캐쉬백수익 확인 :: " + n_ven_name + ", " + remark + ", 입금일:" + incom_dt + ", 입금액: "
							+ AddUtil.parseDecimalLong(ip_acct_amt) + "이 입금되었습니다.";
					String url = "/fms2/car_cash_back/car_cash_back_frame.jsp";

					String target_id = "000131";

					//사용자 정보 조회 -
					UsersBean target_bean = umd.getUsersBean(target_id);
					String xml_data = "";

					xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
							+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>" + cont
							+ "</CONT>"
							+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
							+ url + "</URL>";

					xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";
					xml_data += "    <TARGET>2006007</TARGET>";
				//	xml_data += "    <TARGET>2010003</TARGET>"; //박휘영 
					xml_data += "    <TARGET>2013009</TARGET>"; //이송이 

					xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
							+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>"
							+ "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>" + "</COOLMSG>";

					CdAlertBean msg = new CdAlertBean();
					msg.setFlddata(xml_data);
					msg.setFldtype("1");

					flag2 = cm_db.insertCoolMsg(msg);

					System.out.println(
							"쿨메신저(자체출고캐쉬백수익 입금확인)" + n_ven_name + ", " + AddUtil.parseDecimalLong(ip_acct_amt)
									+ " --------------------" + target_bean.getUser_nm());

					gg_chk = "N";
				}
	
				if (gg_chk.equals("Y")) {

					//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
					UsersBean sender_bean = umd.getUsersBean(user_id);

					String sub = "선수금 입금";
					String cont = "▣ 선수금입금 처리 요청 :: " + n_ven_name + ", " + remark + ", 입금일:" + incom_dt
							+ ", 입금액: " + AddUtil.parseDecimalLong(ip_acct_amt);

					String url = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
			
					String target_id = nm_db.getWorkAuthUser("해지관리자");

					CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);

					if (!cs_bean2.getWork_id().equals(""))
						target_id = cs_bean2.getWork_id(); // 대체근무자

					//사용자 정보 조회
					UsersBean target_bean = umd.getUsersBean(target_id);

					String xml_data = "";
					xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
							+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>" + cont
							+ "</CONT>"
							+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
							+ url + "</URL>";

					xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";

					xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
							+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>"
							+ "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>" + "</COOLMSG>";

					CdAlertBean msg = new CdAlertBean();
					msg.setFlddata(xml_data);
					msg.setFldtype("1");

					flag2 = cm_db.insertCoolMsg(msg);

					System.out.println(
							"쿨메신저(선수금입금처리요청)" + n_ven_name + ", " + AddUtil.parseDecimalLong(ip_acct_amt)
									+ " --------------------" + target_bean.getUser_nm());
				}

			} //메세지 보내기					 

		} //선수금 또는 미수금 인경우 

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

			//사장님께 메세지 전송------------------------------------------------------------------------------------------							
			UsersBean sender_bean = umd.getUsersBean(user_id);

			String sub = "캐쉬백 입금";
			String cont = "▣ 캐쉬백 입금 안내 :: " + n_ven_name + ", " + remark + ", 입금일:" + incom_dt + ", 입금액: "
					+ AddUtil.parseDecimal(ip_acct_amt) + " 확인되었습니다.";

			String url = "/acar/menu/emp_frame.jsp";
		
			String target_id = "";

			target_id = "000003"; //사장님	

			//사용자 정보 조회 - 부장님께
			UsersBean target_bean = umd.getUsersBean(target_id);

			String xml_data = "";
			xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>" + "    <MSGTYPE>104</MSGTYPE>"
					+ "    <SUB>" + sub + "</SUB>" + "    <CONT>" + cont + "</CONT>"
					+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
					+ url + "</URL>";

			if (ip_acct.equals("6")) {

				xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";
				xml_data += "    <TARGET>2000002</TARGET>";
			} else { //제조사 캐쉬백	- 수입차 - 권용식대리		
				//	xml_data += "    <TARGET>2007011</TARGET>";
				//	xml_data += "    <TARGET>2006001</TARGET>";
			}

			xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
					+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>" + "    <FLDTYPE>1</FLDTYPE>"
					+ "  </ALERTMSG>" + "</COOLMSG>";

			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");

			flag2 = cm_db.insertCoolMsg(msg);

			System.out.println("쿨메신저(캐쉬백입금확인)" + n_ven_name + ", " + AddUtil.parseDecimal(ip_acct_amt)
					+ " --------------------" + target_bean.getUser_nm());

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

			//총무팀장  메세지 전송------------------------------------------------------------------------------------------							
			UsersBean sender_bean = umd.getUsersBean(user_id);

			String sub = "국가장려금  입금";
			String cont = "▣ 국가장려금 입금 안내 :: " + n_ven_name + ", " + remark + ", 입금일:" + incom_dt + ", 입금액: "
					+ AddUtil.parseDecimal(ip_acct_amt) + " 확인되었습니다.";

			String url = "/acar/menu/emp_frame.jsp";

			String target_id = "";

			target_id = "000004"; //총무팀장	

			//사용자 정보 조회 - 부장님께
			UsersBean target_bean = umd.getUsersBean(target_id);

			String xml_data = "";
			xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>" + "    <MSGTYPE>104</MSGTYPE>"
					+ "    <SUB>" + sub + "</SUB>" + "    <CONT>" + cont + "</CONT>"
					+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
					+ url + "</URL>";

			xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";
			xml_data += "    <TARGET>2006007</TARGET>";

			xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
					+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>" + "    <FLDTYPE>1</FLDTYPE>"
					+ "  </ALERTMSG>" + "</COOLMSG>";

			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");

			flag2 = cm_db.insertCoolMsg(msg);

			System.out.println("쿨메신저(청년고용장려금입금확인)" + n_ven_name + ", " + AddUtil.parseDecimal(ip_acct_amt)
					+ " --------------------" + target_bean.getUser_nm());

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

			//메세지 보내기 체크된 경우
			if (cool.equals("Y")) {
				//대출처리담당자에게 메세지 전송------------------------------------------------------------------------------------------							
				UsersBean sender_bean = umd.getUsersBean(user_id);

				String sub = "자동차 근저당권설정비용 입금";
				String cont = "▣ 자동차 근저당권설정비용 입금 안내 :: " + n_ven_name + ", " + remark + ", 입금일:" + incom_dt
						+ ", 입금액: " + AddUtil.parseDecimal(ip_acct_amt) + " 확인되었습니다.";

				String url = "/acar/menu/emp_frame.jsp";
			
				String target_id = nm_db.getWorkAuthUser("대출관리자");

				//사용자 정보 조회
				UsersBean target_bean = umd.getUsersBean(target_id);

				String xml_data = "";
				xml_data = "<COOLMSG>" + "<ALERTMSG>" + "    <BACKIMG>4</BACKIMG>"
						+ "    <MSGTYPE>104</MSGTYPE>" + "    <SUB>" + sub + "</SUB>" + "    <CONT>" + cont
						+ "</CONT>"
						+ "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="
						+ url + "</URL>";

				xml_data += "    <TARGET>" + target_bean.getId() + "</TARGET>";
				xml_data += "    <TARGET>2013002</TARGET>";

				xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
						+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>"
						+ "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>" + "</COOLMSG>";

				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");

				flag2 = cm_db.insertCoolMsg(msg);

				System.out.println("쿨메신저(자동차 근저당권설정비용입금확인)" + n_ven_name + ", " + remark
						+ " --------------------" + target_bean.getUser_nm());
			}

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

	//기타 입금처리
	if (!ip_acct.equals("")) {

		IncomEtcBean i_etc = new IncomEtcBean();

		i_etc.setIncom_dt(incom_dt); //원장번호
		i_etc.setIncom_seq(incom_seq);//연번						
		i_etc.setSeq_id(1);
		i_etc.setN_ven_code(n_ven_code);
		i_etc.setN_ven_name(n_ven_name);
		i_etc.setIp_acct(ip_acct);
		i_etc.setIp_acct_amt(ip_acct_amt);
		i_etc.setRemark(remark);
		i_etc.setNeom(neom);
		i_etc.setAcct_gubun(acct_gubun);

		if (!in_db.insertIncomEtc(i_etc))
			flag += 1;
	}

	//대위변제
	if (!pay_gur.equals("0")) {
		if (!in_db.updateIncomFeeSet(incom_dt, incom_seq, pay_gur, pay_gur_nm, pay_gur_rel))
			flag += 1;
	}

	//입금원장처리 - jung_type :1->완료
	if (not_yet.equals("1")) {
		if (!in_db.updateIncomSet(incom_dt, incom_seq, not_yet_reason, "2"))
			flag += 1;
	} else {
		if (!in_db.updateIncomSet(incom_dt, incom_seq, "1", card_tax, ip_method, doc_cont, a_cal_tax, row_id))
			flag += 1;
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
