<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.credit.*, acar.client.*, acar.fee.*,  acar.user_mng.*, acar.cls.*,  acar.cont.*, tax.*, acar.bill_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
//	System.out.println("lc_cls_cont_autodoc user_id="+ user_id);
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	String firm_nm = request.getParameter("firm_nm")==null?"":	request.getParameter("firm_nm");
	 	
	int	flag = 0;
	int	count = 0;
	
	String from_page 	= "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	//네오엠
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));
	String node_code ="S101";  //네오엠 iu 에서는 회계단위:S101	
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 	= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String client_id 	= "";
	String site_id 		= "";

	String tax_supply = "";
	String tax_value = "";
	String tax_branch 	= "";
		
	//선수금 입금일
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
		//매입옵션일 (sui)
	String m_sui_dt = request.getParameter("m_sui_dt")==null?"":request.getParameter("m_sui_dt");
	
	String real_date = "";
  	int opt_ip_amt = 0;  
	
		//해지의뢰정보
	ClsEtcBean clse = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String ext_st = clse.getExt_st();  //매입옵션 과입금액 환불여부
	    
   //해지정보					
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
		
	cls_st = "8";
	
	real_date = cls.getCls_dt();
				
	from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
			
//	if ( !m_sui_dt.equals("") ) {
//		 real_date = m_sui_dt;	
//	} else {
		if ( !opt_ip_dt1.equals("") ) {	    	    	
				if ( !cls.getCls_dt().equals(opt_ip_dt1) ) {
				  // real_date = opt_ip_dt1;
				   real_date = cls.getCls_dt();
				} else {
				   real_date = cls.getCls_dt();
				}		   		
		}		
//	}

		
	//계약:고객관련
	ContBaseBean base 	= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	client_id = base.getClient_id();
	
	if(base.getTax_type().equals("2")){//지점
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	
	//싼타페등 연비보상
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id(), "Y" );	
		
	String return_remark = "";
	Hashtable  return1 =   new Hashtable();
	
    if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "Y"); 	
	   	return_remark = (String)return1.get("REMARK");
    }
    
    
	//대여정보
	ContFeeBean fee = a_db.getContFee(rent_mng_id, rent_l_cd, "1");
	tax_branch = fee.getBr_id()==""?br_id:fee.getBr_id();
	
	//거래처정보
	ClientBean client = al_db.getNewClient(client_id);
	
	String ven_type = "";
	String s_idno = "";
	
	String client_st = client.getClient_st(); //2:개인
	
	String i_ssn = "";
	i_ssn = client.getSsn1() + client.getSsn2();
		
	String i_enp_no = client.getEnp_no1() + client.getEnp_no2()+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() + client.getSsn2();
		
	String i_addr 		= client.getO_addr();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	String i_ven_code	= client.getVen_code();
	
	if(base.getTax_type().equals("2")){//지점
	
		if(! base.getR_site().equals("")){
			//거래처지점정보
			ClientSiteBean site = al_db.getClientSite(client_id, site_id);
			i_enp_no 		= site.getEnp_no();
		
			i_addr 			= site.getAddr();
			i_sta 			= site.getBus_cdt();
			i_item 			= site.getBus_itm();
			i_ven_code		= site.getVen_code();
			i_ssn 		    = "";
		}
	}
		
	if(i_ven_code.equals("")) i_ven_code = neoe_db.getVenCode(i_ssn, i_enp_no);
		
	Hashtable vendor = neoe_db.getVendorCase(i_ven_code);
	
	//네오엠 세금계산서
	if(base.getTax_type().equals("1")){ //본사
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
	
		//마지막 세금계산서
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
		
	//세금계산서 발행관련 - 해지정산시
	Hashtable l_tax = ac_db.getLastFeeTaxDt(rent_l_cd, fee_tm);
	
	
	//미입금된 면책금 중 계산서 미발행분
	//면책금 기청구된 건중 매출처리 여부 구분
	int car_ja_no_amt = ac_db.getClsEtcCarNoAmt(rent_mng_id, rent_l_cd);
			
	//세금계산서 작성 및 네오엠 외상매출금 처리
	//String tax_j_hap[] = request.getParameterValues("tax_j_hap"); //정산금액 (잔액)
	String tax_r_g[] = request.getParameterValues("tax_r_g");
 	String tax_r_supply[] = request.getParameterValues("tax_rr_supply");
	String tax_r_value[] = request.getParameterValues("tax_rr_value");
	String tax_bigo[] = request.getParameterValues("tax_r_bigo");
 
	int tax_size = tax_r_g.length;
	String tax_no = "";
	int data_no =0;
	int data_no_t =0;
  	int tax_cnt = 0;
  	String row_id_t = "";
  	String row_id = "";
  	
  	//세금계산서 관련
  	    int  a1_s_amt = 0;  //잔여개시대여료
	    int  a1_v_amt = 0;
	    int  a2_s_amt = 0;  //잔여선납금 
	    int  a2_v_amt = 0;
	    int  a3_s_amt = 0;  //취소대여료
	    int  a3_v_amt = 0;
	    int  a4_s_amt = 0;  //미납대여료
	    int  a4_v_amt = 0;
	    int  a5_s_amt = 0;  //해지위약금
	    int  a5_v_amt = 0;
	    int  a6_s_amt = 0;  //회수외주비용
	    int  a6_v_amt = 0;
	    int  a7_s_amt = 0;  //회수부대비용
	    int  a7_v_amt = 0;
	    int  a8_s_amt = 0;  //손해배상
	    int  a8_v_amt = 0;
	    int  a9_s_amt = 0;  //초과 운행추가대여료 - 계산서 필수
   		 int  a9_v_amt = 0;
  	  	
  	String item_id = "";
  	String reg_code = "";	
  	String ven_code = "";


	for(int i = 0; i<tax_size; i++){ 
	
		String tax_r_chk = request.getParameter("tax_r_chk"+i)==null?"N":	request.getParameter("tax_r_chk"+i);
		out.println(tax_r_chk);
		if(tax_r_chk.equals("Y")){
			out.println("선택"+i+"=<br><br>");
	    		tax_no = IssueDb.getTaxNoNext(real_date);
	    		out.println("tax_no="+tax_no+"<br>");
	    		out.println("tax_dt="+real_date+"<br>");
	    		out.println("tax_r_g="+tax_r_g[i]+"<br>");
	    		out.println("tax_r_supply="+tax_r_supply[i]+"<br>");
    				
			    			
	    		// 세금계산서 발행분 공급가 및 부가세 저장
	    		if ( tax_r_g[i].equals("해지 취소 대여료") ) {
	    		   a3_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
	    		   a3_v_amt = AddUtil.parseDigit(tax_r_value[i]);
	    		}else if ( tax_r_g[i].equals("해지 미납 대여료") ||   tax_r_g[i].equals("해지 대여료") ) {
	    		   a4_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
	    		   a4_v_amt = AddUtil.parseDigit(tax_r_value[i]);   
	    		}else if ( tax_r_g[i].equals("해지 위약금")) {
	    		   a5_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
	    		   a5_v_amt = AddUtil.parseDigit(tax_r_value[i]);
	    		}else if ( tax_r_g[i].equals("해지 회수외주비용")) {
	    		   a6_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
	    		   a6_v_amt = AddUtil.parseDigit(tax_r_value[i]);
	    		}else if ( tax_r_g[i].equals("해지 회수부대비용")) {
	    		   a7_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
	    		   a7_v_amt = AddUtil.parseDigit(tax_r_value[i]);
	    		}else if ( tax_r_g[i].equals("해지 손해배상금")) {
	    		   a8_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
	    		   a8_v_amt = AddUtil.parseDigit(tax_r_value[i]); 
	    		}else if ( tax_r_g[i].equals("해지 초과운행추가대여료") || tax_r_g[i].equals("해지 초과운행대여료") ) {
			       a9_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
			       a9_v_amt = AddUtil.parseDigit(tax_r_value[i]);    	       	
	    		}    			
				
		//	tax_cnt++;
		}
	} 	//end for	 

	
	 // 세금계산서 발행분 공급가 및 부가세 저장 -  선납금인 경우 무조건
	   if ( tax_r_g[0].equals("해지 개시대여료 환급")) {
	    		   a1_s_amt = AddUtil.parseDigit(request.getParameter("rifee_s_amt"))*(-1) ; 
	    		   a1_v_amt = AddUtil.parseDigit(request.getParameter("rifee_amt_2_v")) ; 		  
	   }
		if ( tax_r_g[1].equals("해지 선납금 환급")) {
	    		   a2_s_amt = AddUtil.parseDigit(request.getParameter("rfee_s_amt"))*(-1) ; 
	    		   a2_v_amt = AddUtil.parseDigit(request.getParameter("rfee_amt_2_v")) ; 					    		   
	   } 		   	    		
		   
	
	//자동전표처리용
	Vector vt_m_auto = new Vector();
	Vector vt_auto = new Vector();
			
	int line =0;
	int amt_10800 = 0;
	int amt_25900 = 0;
	String doc_cont = "";	
	
	// 매출취소인 경우 원매출전표 발생일 (계산서 발행일로 )
	
	//세금계산서 취소건 - 매출 마이너스 (세금계산서 발행일이 전표생성일이어야 함)
	
   if ( a3_s_amt < 0 ) {
 
 	//  렌트(리스)사업매출인 경우는 부가세처리 
 	  	if (cls_st.equals("1") ) {
				 doc_cont = "계약만료 대여료" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "매입옵션 대여료" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "중도해지 대여료" + "-" + car_no + " " + firm_nm;
		}		 
							
		line++;
					
		Hashtable ht7 = new Hashtable();
							
		ht7.put("WRITE_DATE", 	real_date); //row_id							
		ht7.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht7.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht7.put("CD_PC",  	node_code);  //회계단위
		ht7.put("CD_WDEPT",  dept_code);  //부서
		ht7.put("NO_DOCU",  	"");  //미결은 '0' 
		ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht7.put("CD_COMPANY",  "1000");  
		ht7.put("ID_WRITE", insert_id);   
		ht7.put("CD_DOCU",  "11");  
		
		ht7.put("DT_ACCT", 	real_date); 
		ht7.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht7.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
		ht7.put("CD_ACCT",  "10800");   // 
		ht7.put("AMT",    	String.valueOf(a3_s_amt + a3_v_amt) );			
		ht7.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht7.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht7.put("DT_START",  "");  	//발생일자										 
		ht7.put("CD_BIZAREA",		"");   //귀속사업장	
		ht7.put("CD_DEPT",		"");   //부서								 
		ht7.put("CD_CC",			"");   //코스트센터		
		ht7.put("CD_PJT",			"");   //프로젝트코드		
		ht7.put("CD_CARD",		"");   //신용카드		 	
		ht7.put("CD_EMPLOY",		"");   //사원									 		 
		ht7.put("NO_DEPOSIT",	"");  //예적금계좌
		ht7.put("CD_BANK",		"");  //금융기관	
		ht7.put("NO_ITEM",		"");  //item	  	 
		
			// 부가세관련
		ht7.put("AM_TAXSTD",	"");  //과세표준액
		ht7.put("AM_ADDTAX",	"" );	 //세액
		ht7.put("TP_TAX",	"");  //과세(매출) :11
		ht7.put("NO_COMPANY",	""); //사업자등록번호
				
		ht7.put("NM_NOTE", doc_cont);  // 적요									
						
		vt_m_auto.add(ht7);  //  외상매출금
				
		line++;
					
		Hashtable ht7_1 = new Hashtable();
		
		ht7_1.put("WRITE_DATE", 	real_date); //row_id							
		ht7_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht7_1.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht7_1.put("CD_PC",  	node_code);  //회계단위
		ht7_1.put("CD_WDEPT",  dept_code);  //부서
		ht7_1.put("NO_DOCU",  	"");  //미결은 '0' 
		ht7_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht7_1.put("CD_COMPANY",  "1000");  
		ht7_1.put("ID_WRITE", insert_id);   
		ht7_1.put("CD_DOCU",  "11");  
		
		ht7_1.put("DT_ACCT", 	real_date); 
		ht7_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht7_1.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
		
		if ( base.getCar_st().equals("1") ) { //렌트이면
				ht7_1.put("CD_ACCT",  	"41200");  //대여사업매출
		} else {
				ht7_1.put("CD_ACCT",  	"41700");  //리스사업매출
		}	
		
		ht7_1.put("AMT",    	String.valueOf( a3_s_amt ));			
		ht7_1.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht7_1.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht7_1.put("DT_START",  "");  	//발생일자										 
		ht7_1.put("CD_BIZAREA",		"");   //귀속사업장	
		ht7_1.put("CD_DEPT",		"");   //부서								 
		ht7_1.put("CD_CC",			"");   //코스트센터		
		ht7_1.put("CD_PJT",			"");   //프로젝트코드		
		ht7_1.put("CD_CARD",		"");   //신용카드		 	
		ht7_1.put("CD_EMPLOY",		"");   //사원									 		 
		ht7_1.put("NO_DEPOSIT",	"");  //예적금계좌
		ht7_1.put("CD_BANK",		"");  //금융기관	
		ht7_1.put("NO_ITEM",		"");  //item	  	 
		
			// 부가세관련
		ht7_1.put("AM_TAXSTD",	"");  //과세표준액
		ht7_1.put("AM_ADDTAX",	"" );	 //세액
		ht7_1.put("TP_TAX",	"");  //과세(매출) :11
		ht7_1.put("NO_COMPANY",	""); //사업자등록번호
				
		ht7_1.put("NM_NOTE", doc_cont);  // 적요									
						
		vt_m_auto.add(ht7_1);  //  공급가
		
		line++;
		
		Hashtable ht7_2 = new Hashtable();
			
		ht7_2.put("WRITE_DATE", 	real_date); //row_id							
		ht7_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht7_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
		ht7_2.put("CD_PC",  	node_code);  //회계단위
		ht7_2.put("CD_WDEPT",  dept_code);  //부서
		ht7_2.put("NO_DOCU",  	"");  //미결은 '0' 
		ht7_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht7_2.put("CD_COMPANY",  "1000");  
		ht7_2.put("ID_WRITE", insert_id);   
		ht7_2.put("CD_DOCU",  "11");  
		
		ht7_2.put("DT_ACCT", 	real_date); 
		ht7_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht7_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
		ht7_2.put("CD_ACCT",  		"25500");  //부가세예수금					
		ht7_2.put("AMT",   		String.valueOf( a3_v_amt) );						
		ht7_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht7_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht7_2.put("DT_START",  real_date);  	//발생일자 - 부가세										 
		ht7_2.put("CD_BIZAREA",		"S101");   //귀속사업장	
		ht7_2.put("CD_DEPT",		"");   //부서								 
		ht7_2.put("CD_CC",			"");   //코스트센터		
		ht7_2.put("CD_PJT",			"");   //프로젝트코드		
		ht7_2.put("CD_CARD",		"");   //신용카드		 	
		ht7_2.put("CD_EMPLOY",		"");   //사원									 		 
		ht7_2.put("NO_DEPOSIT",	"");  //예적금계좌
		ht7_2.put("CD_BANK",		"");  //금융기관	
		ht7_2.put("NO_ITEM",		"");  //item	 	  	 
			
	// 부가세관련
		ht7_2.put("AM_TAXSTD",	 String.valueOf( a3_s_amt) );		 //과세표준액
		ht7_2.put("AM_ADDTAX",	String.valueOf( a3_v_amt) );		 //세액
		ht7_2.put("TP_TAX",	"11");  //과세(매출) :11
		ht7_2.put("NO_COMPANY",	s_idno); //사업자등록번호
										
		ht7_2.put("NM_NOTE", doc_cont);  // 적요	
								
		vt_m_auto.add(ht7_2);  // 부가세	
								
		Hashtable ht7_2_1 = new Hashtable();	
			
		line =0;	
 
  }   	
	 //-----------------선납금액 관련 ------------------------	
			
   	//선수금 - 보증금 	
   	if ( AddUtil.parseDigit(request.getParameter("grt_amt"))  > 0 ) {
  
		if (cls_st.equals("1") ) {
				 doc_cont = "계약만료 보증금" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "매입옵션 보증금" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "중도해지 보증금" + "-" + car_no + " " + firm_nm;
		}		 
			
		line++;
					
		Hashtable ht2_1 = new Hashtable();
			
		ht2_1.put("WRITE_DATE", 	real_date); //row_id							
		ht2_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht2_1.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht2_1.put("CD_PC",   node_code);  //회계단위
		ht2_1.put("CD_WDEPT",  dept_code);  //부서
		ht2_1.put("NO_DOCU",  	"");  //미결은 '0' 
		ht2_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht2_1.put("CD_COMPANY",  "1000");  
		ht2_1.put("ID_WRITE", insert_id);   
		ht2_1.put("CD_DOCU",  "11");  
		
		ht2_1.put("DT_ACCT", 	real_date); 
		ht2_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht2_1.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
		ht2_1.put("CD_ACCT",  	"31100");  //장기대여보증금
		ht2_1.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("grt_amt") )  )  );	
		ht2_1.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht2_1.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht2_1.put("DT_START",  "");  	//발생일자										 
		ht2_1.put("CD_BIZAREA",		"");   //귀속사업장	
		ht2_1.put("CD_DEPT",		"");   //부서								 
		ht2_1.put("CD_CC",			"");   //코스트센터		
		ht2_1.put("CD_PJT",			"");   //프로젝트코드		
		ht2_1.put("CD_CARD",		"");   //신용카드		 	
		ht2_1.put("CD_EMPLOY",		"");   //사원									 		 
		ht2_1.put("NO_DEPOSIT",	"");  //예적금계좌
		ht2_1.put("CD_BANK",		"");  //금융기관	
		ht2_1.put("NO_ITEM",		"");  //item	  	 
		
			// 부가세관련
		ht2_1.put("AM_TAXSTD",	"");  //과세표준액
		ht2_1.put("AM_ADDTAX",	"" );	 //세액
		ht2_1.put("TP_TAX",	"");  //과세(매출) :11
		ht2_1.put("NO_COMPANY",	""); //사업자등록번호
				
		ht2_1.put("NM_NOTE", doc_cont);  // 적요									
						
	//	System.out.println(	"31100" );		
		vt_auto.add(ht2_1);  //
	} 	
	  
      //선수금 - 잔여개시대여료 
   	if ( AddUtil.parseDigit(request.getParameter("rifee_s_amt")) > 0 ) {
   	  
   	  	if (cls_st.equals("1") ) {
				 doc_cont = "계약만료 개시대여료" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "매입옵션 개시대여료" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "중도해지 개시대여료" + "-" + car_no + " " + firm_nm;
		}		 
			
		line++;		
		//계산서 발행이 안된 - 전자계산서 변경으로 인해서 20140101	
					
		Hashtable ht2_4 = new Hashtable();		
		ht2_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
		ht2_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht2_4.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht2_4.put("CD_PC",  node_code);  //회계단위
		ht2_4.put("CD_WDEPT",  dept_code);  //부서
		ht2_4.put("NO_DOCU",  	"");  //미결은 '0' 
		ht2_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht2_4.put("CD_COMPANY",  "1000");  
		ht2_4.put("ID_WRITE", insert_id);   
		ht2_4.put("CD_DOCU",  "11");  
		
		ht2_4.put("DT_ACCT", 	cls.getCls_dt()); 
		ht2_4.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht2_4.put("TP_DRCR",   "2");   // 대변:2 , 차변:1		
		ht2_4.put("CD_ACCT",  	"10800");  //외상매출금	
		ht2_4.put("AMT",    	String.valueOf( a1_s_amt + a1_v_amt ));		
		ht2_4.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht2_4.put("CD_PARTNER",	i_ven_code); //거래처    - A06	
										
		ht2_4.put("DT_START",  "");  	//발생일자										 
		ht2_4.put("CD_BIZAREA",		"");   //귀속사업장	
		ht2_4.put("CD_DEPT",		"");   //부서								 
		ht2_4.put("CD_CC",			"");   //코스트센터		
		ht2_4.put("CD_PJT",			"");   //프로젝트코드		
		ht2_4.put("CD_CARD",		"");   //신용카드		 	
		ht2_4.put("CD_EMPLOY",		"");   //사원									 		 
		ht2_4.put("NO_DEPOSIT",	"");  //예적금계좌
		ht2_4.put("CD_BANK",		"");  //금융기관	
		ht2_4.put("NO_ITEM",		"");  //item	  	 
		
			// 부가세관련
		ht2_4.put("AM_TAXSTD",	"");  //과세표준액
		ht2_4.put("AM_ADDTAX",	"" );	 //세액
		ht2_4.put("TP_TAX",	"");  //과세(매출) :11
		ht2_4.put("NO_COMPANY",	""); //사업자등록번호
				
		ht2_4.put("NM_NOTE", doc_cont);  // 적요		
					
		vt_auto.add(ht2_4);  //  외상매출금					

/*			
		line++;
					
		Hashtable ht2_2 = new Hashtable();
		
		ht2_2.put("WRITE_DATE", 	real_date); //row_id							
		ht2_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht2_2.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht2_2.put("CD_PC",  	node_code);  //회계단위
		ht2_2.put("CD_WDEPT",  dept_code);  //부서
		ht2_2.put("NO_DOCU",  	"");  //미결은 '0' 
		ht2_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht2_2.put("CD_COMPANY",  "1000");  
		ht2_2.put("ID_WRITE", insert_id);   
		ht2_2.put("CD_DOCU",  "11");  
		
		ht2_2.put("DT_ACCT", 	real_date); 
		ht2_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht2_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
		
		if ( base.getCar_st().equals("1") ) { //렌트이면
			ht2_2.put("CD_ACCT",  	"41200");  //잔여개시대여료
		} else {
			ht2_2.put("CD_ACCT",  	"41700");   //잔여개시대여료
		}	
		
		ht2_2.put("AMT",    String.valueOf( a1_s_amt ));			
		ht2_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht2_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht2_2.put("DT_START",  "");  	//발생일자										 
		ht2_2.put("CD_BIZAREA",		"");   //귀속사업장	
		ht2_2.put("CD_DEPT",		"");   //부서								 
		ht2_2.put("CD_CC",			"");   //코스트센터		
		ht2_2.put("CD_PJT",			"");   //프로젝트코드		
		ht2_2.put("CD_CARD",		"");   //신용카드		 	
		ht2_2.put("CD_EMPLOY",		"");   //사원									 		 
		ht2_2.put("NO_DEPOSIT",	"");  //예적금계좌
		ht2_2.put("CD_BANK",		"");  //금융기관	
		ht2_2.put("NO_ITEM",		"");  //item	  
		
				// 부가세관련
		ht2_2.put("AM_TAXSTD",	"");  //과세표준액
		ht2_2.put("AM_ADDTAX",	"" );	 //세액
		ht2_2.put("TP_TAX",	"");  //과세(매출) :11
		ht2_2.put("NO_COMPANY",	""); //사업자등록번호	  	 
	
		ht2_2.put("NM_NOTE", doc_cont);  // 적요									
						
		vt_auto.add(ht2_2);  //  공급가
		
		line++;
		
		Hashtable ht3_2 = new Hashtable();
		
		ht3_2.put("WRITE_DATE", 	real_date); //row_id							
		ht3_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht3_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
		ht3_2.put("CD_PC",  	node_code);  //회계단위
		ht3_2.put("CD_WDEPT",  dept_code);  //부서
		ht3_2.put("NO_DOCU",  	"");  //미결은 '0' 
		ht3_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht3_2.put("CD_COMPANY",  "1000");  
		ht3_2.put("ID_WRITE", insert_id);   
		ht3_2.put("CD_DOCU",  "11");  
		
		ht3_2.put("DT_ACCT", 	real_date); 
		ht3_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht3_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
		ht3_2.put("CD_ACCT",  		"25500");  //부가세예수금					
		ht3_2.put("AMT",   		String.valueOf( a1_v_amt) );							
		ht3_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht3_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht3_2.put("DT_START",  real_date);  	//발생일자 - 부가세										 
		ht3_2.put("CD_BIZAREA",		"S101");   //귀속사업장	
		ht3_2.put("CD_DEPT",		"");   //부서								 
		ht3_2.put("CD_CC",			"");   //코스트센터		
		ht3_2.put("CD_PJT",			"");   //프로젝트코드		
		ht3_2.put("CD_CARD",		"");   //신용카드		 	
		ht3_2.put("CD_EMPLOY",		"");   //사원									 		 
		ht3_2.put("NO_DEPOSIT",	"");  //예적금계좌
		ht3_2.put("CD_BANK",		"");  //금융기관	
		ht3_2.put("NO_ITEM",		"");  //item	 	  	 
			
	// 부가세관련
		ht3_2.put("AM_TAXSTD",	 String.valueOf( a1_s_amt) );		 //과세표준액
		ht3_2.put("AM_ADDTAX",	String.valueOf( a1_v_amt) );		 //세액
		ht3_2.put("TP_TAX",	"11");  //과세(매출) :11
		ht3_2.put("NO_COMPANY",	s_idno); //사업자등록번호
										
		ht3_2.put("NM_NOTE", doc_cont);  // 적요	
					
		vt_auto.add(ht3_2);  // 부가세	   	 

*/		   	   
   } 
   	  
   	  //선수금 - 잔여선납금 
   if ( AddUtil.parseDigit(request.getParameter("rfee_s_amt")) > 0 ) {
   	  
   	   	if (cls_st.equals("1") ) {
				 doc_cont = "계약만료 선납금" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "매입옵션 선납금" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "중도해지 선납금" + "-" + car_no + " " + firm_nm;
		}		 
			
		line++;		
		//계산서 발행이 안된 - 전자계산서 변경으로 인해서 20140101	
					
		Hashtable ht3_4 = new Hashtable();		
		ht3_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
		ht3_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht3_4.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht3_4.put("CD_PC",  node_code);  //회계단위
		ht3_4.put("CD_WDEPT",  dept_code);  //부서
		ht3_4.put("NO_DOCU",  	"");  //미결은 '0' 
		ht3_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht3_4.put("CD_COMPANY",  "1000");  
		ht3_4.put("ID_WRITE", insert_id);   
		ht3_4.put("CD_DOCU",  "11");  
		
		ht3_4.put("DT_ACCT", 	cls.getCls_dt()); 
		ht3_4.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht3_4.put("TP_DRCR",   "2");   // 대변:2 , 차변:1		
		ht3_4.put("CD_ACCT",  	"10800");  //외상매출금	
		ht3_4.put("AMT",    	String.valueOf( a2_s_amt + a2_v_amt ));		
		ht3_4.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht3_4.put("CD_PARTNER",	i_ven_code); //거래처    - A06	
										
		ht3_4.put("DT_START",  "");  	//발생일자										 
		ht3_4.put("CD_BIZAREA",		"");   //귀속사업장	
		ht3_4.put("CD_DEPT",		"");   //부서								 
		ht3_4.put("CD_CC",			"");   //코스트센터		
		ht3_4.put("CD_PJT",			"");   //프로젝트코드		
		ht3_4.put("CD_CARD",		"");   //신용카드		 	
		ht3_4.put("CD_EMPLOY",		"");   //사원									 		 
		ht3_4.put("NO_DEPOSIT",	"");  //예적금계좌
		ht3_4.put("CD_BANK",		"");  //금융기관	
		ht3_4.put("NO_ITEM",		"");  //item	  	 
		
			// 부가세관련
		ht3_4.put("AM_TAXSTD",	"");  //과세표준액
		ht3_4.put("AM_ADDTAX",	"" );	 //세액
		ht3_4.put("TP_TAX",	"");  //과세(매출) :11
		ht3_4.put("NO_COMPANY",	""); //사업자등록번호
				
		ht3_4.put("NM_NOTE", doc_cont);  // 적요		
					
		vt_auto.add(ht3_4);  //  외상매출금
	
/*		사용안함 - 20140101	
		line++;
					
		Hashtable ht2_3 = new Hashtable();
		
		ht2_3.put("WRITE_DATE", 	real_date); //row_id							
		ht2_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht2_3.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht2_3.put("CD_PC",  	node_code);  //회계단위
		ht2_3.put("CD_WDEPT",  dept_code);  //부서
		ht2_3.put("NO_DOCU",  	"");  //미결은 '0' 
		ht2_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht2_3.put("CD_COMPANY",  "1000");  
		ht2_3.put("ID_WRITE", insert_id);   
		ht2_3.put("CD_DOCU",  "11");  
		
		ht2_3.put("DT_ACCT", 	real_date); 
		ht2_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht2_3.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
		
		if ( base.getCar_st().equals("1") ) { //렌트이면
			ht2_3.put("CD_ACCT",  	"41200");  //잔여선납금
		} else {
			ht2_3.put("CD_ACCT",  	"41700");  //잔여선납금
		}	
		
		ht2_3.put("AMT",    String.valueOf( a2_s_amt) );				
		ht2_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht2_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht2_3.put("DT_START",  "");  	//발생일자										 
		ht2_3.put("CD_BIZAREA",		"");   //귀속사업장	
		ht2_3.put("CD_DEPT",		"");   //부서								 
		ht2_3.put("CD_CC",			"");   //코스트센터		
		ht2_3.put("CD_PJT",			"");   //프로젝트코드		
		ht2_3.put("CD_CARD",		"");   //신용카드		 	
		ht2_3.put("CD_EMPLOY",		"");   //사원									 		 
		ht2_3.put("NO_DEPOSIT",	"");  //예적금계좌
		ht2_3.put("CD_BANK",		"");  //금융기관	
		ht2_3.put("NO_ITEM",		"");  //item	  
		
				// 부가세관련
		ht2_3.put("AM_TAXSTD",	"");  //과세표준액
		ht2_3.put("AM_ADDTAX",	"" );	 //세액
		ht2_3.put("TP_TAX",	"");  //과세(매출) :11
		ht2_3.put("NO_COMPANY",	""); //사업자등록번호	  	 
	
		ht2_3.put("NM_NOTE", doc_cont);  // 적요									
						
		vt_auto.add(ht2_3);  //
		
		line++;
		
		Hashtable ht3_3 = new Hashtable();
		
		ht3_3.put("WRITE_DATE", 	real_date); //row_id							
		ht3_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht3_3.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
		ht3_3.put("CD_PC",  node_code);  //회계단위
		ht3_3.put("CD_WDEPT",  dept_code);  //부서
		ht3_3.put("NO_DOCU",  	"");  //미결은 '0' 
		ht3_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht3_3.put("CD_COMPANY",  "1000");  
		ht3_3.put("ID_WRITE", insert_id);   
		ht3_3.put("CD_DOCU",  "11");  
		
		ht3_3.put("DT_ACCT", 	real_date); 
		ht3_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht3_3.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
		ht3_3.put("CD_ACCT",  		"25500");  //부가세예수금					
		ht3_3.put("AMT",   		String.valueOf( a2_v_amt) );								
		ht3_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht3_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht3_3.put("DT_START", real_date);  	//발생일자 - 부가세										 
		ht3_3.put("CD_BIZAREA",		"S101");   //귀속사업장	
		ht3_3.put("CD_DEPT",		"");   //부서								 
		ht3_3.put("CD_CC",			"");   //코스트센터		
		ht3_3.put("CD_PJT",			"");   //프로젝트코드		
		ht3_3.put("CD_CARD",		"");   //신용카드		 	
		ht3_3.put("CD_EMPLOY",		"");   //사원									 		 
		ht3_3.put("NO_DEPOSIT",	"");  //예적금계좌
		ht3_3.put("CD_BANK",		"");  //금융기관	
		ht3_3.put("NO_ITEM",		"");  //item	 	  	 
			
	// 부가세관련
		ht3_3.put("AM_TAXSTD",	 String.valueOf( a2_s_amt) );		 //과세표준액
		ht3_3.put("AM_ADDTAX",	String.valueOf( a2_v_amt) );		 //세액
		ht3_3.put("TP_TAX",	"11");  //과세(매출) :11
		ht3_3.put("NO_COMPANY",	s_idno); //사업자등록번호
										
		ht3_3.put("NM_NOTE", doc_cont);  // 적요	
							
		vt_auto.add(ht3_3);  // 부가세

*/			
   }
        
   //-----------------미납금액 관련 ------------------------
	  		  
	 // 과태료 상계 -  미수금
   if ( AddUtil.parseDigit(request.getParameter("fine_amt_2")) > 0 ) {
	 
		if (cls_st.equals("1") ) {
			 doc_cont = "계약만료 과태료" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "매입옵션 과태료" + "-" + car_no + " " + firm_nm;
		} else {
			 doc_cont = "중도해지 과태료" + "-" + car_no + " " + firm_nm;
		} 
		
		
		line++;
		
		Hashtable ht4 = new Hashtable();
		
		ht4.put("WRITE_DATE", 	real_date); //row_id							
		ht4.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht4.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht4.put("CD_PC",  	node_code);  //회계단위
		ht4.put("CD_WDEPT",  dept_code);  //부서
		ht4.put("NO_DOCU",  	"");  //미결은 '0' 
		ht4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht4.put("CD_COMPANY",  "1000");  
		ht4.put("ID_WRITE", insert_id);   
		ht4.put("CD_DOCU",  "11");  
		
		ht4.put("DT_ACCT", 	real_date); 
		ht4.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht4.put("TP_DRCR",   "2");   // 대변:2 , 차변:1		
		ht4.put("CD_ACCT",  	"12400");  //과태료예수금(27400) : , 과태료미수금 (12400)		
		ht4.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("fine_amt_2")) ));				
		ht4.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht4.put("CD_PARTNER",	i_ven_code); //거래처    - A06	
										
		ht4.put("DT_START",  "");  	//발생일자										 
		ht4.put("CD_BIZAREA",		"");   //귀속사업장	
		ht4.put("CD_DEPT",		"");   //부서								 
		ht4.put("CD_CC",			"");   //코스트센터		
		ht4.put("CD_PJT",			"");   //프로젝트코드		
		ht4.put("CD_CARD",		"");   //신용카드		 	
		ht4.put("CD_EMPLOY",		"");   //사원									 		 
		ht4.put("NO_DEPOSIT",	"");  //예적금계좌
		ht4.put("CD_BANK",		"");  //금융기관	
		ht4.put("NO_ITEM",		"");  //item	  	 
		
			// 부가세관련
		ht4.put("AM_TAXSTD",	"");  //과세표준액
		ht4.put("AM_ADDTAX",	"" );	 //세액
		ht4.put("TP_TAX",	"");  //과세(매출) :11
		ht4.put("NO_COMPANY",	""); //사업자등록번호
				
		ht4.put("NM_NOTE", doc_cont);  // 적요	
								
		vt_auto.add(ht4);  // 과태료	

  }
 	 
	 //자기차량손해면책금 상계 - 면책금이 세금계산서 발행된 경우는 외상매출처리
  if ( AddUtil.parseDigit(request.getParameter("car_ja_amt_2")) > 0 ) {
 		
 	   amt_10800 = AddUtil.parseDigit(request.getParameter("car_ja_amt_2")) - car_ja_no_amt;
 	   
 	   if (cls_st.equals("1") ) {
			 doc_cont = "계약만료 면책금" + "-" + car_no + " " + firm_nm;
	   } else if (cls_st.equals("8") ) {
			 doc_cont = "매입옵션 면책금" + "-" + car_no + " " + firm_nm;
	   } else {
			 doc_cont = "중도해지 면책금" + "-" + car_no + " " + firm_nm;
	   }		 
		
 	   if ( amt_10800 > 0) {  //외상매출금이 있는 경우만 
	 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
	 	  
			line++;
						
			Hashtable ht5_1 = new Hashtable();
			
			ht5_1.put("WRITE_DATE", 	real_date); //row_id							
			ht5_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht5_1.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht5_1.put("CD_PC",  	node_code);  //회계단위
			ht5_1.put("CD_WDEPT",  dept_code);  //부서
			ht5_1.put("NO_DOCU",  	"");  //미결은 '0' 
			ht5_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht5_1.put("CD_COMPANY",  "1000");  
			ht5_1.put("ID_WRITE", insert_id);   
			ht5_1.put("CD_DOCU",  "11");  
			
			ht5_1.put("DT_ACCT", 	real_date); 
			ht5_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			//ht5_1.put("TP_DRCR",   "2");   // 대변:2 , 차변:1		
			//ht5_1.put("CD_ACCT",  	"91800");  //외상매출금		
			//ht5_1.put("AMT",   String.valueOf( amt_10800) );	
			
			ht5_1.put("TP_DRCR",   "1");   // 대변:2 , 차변:1		
			ht5_1.put("CD_ACCT",  	"45510");  //면책금  -차량수리정비비(45510) - 20211116 회계게정 변경 
			ht5_1.put("AMT",   String.valueOf( amt_10800 * (-1) ) );	
						
			ht5_1.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht5_1.put("CD_PARTNER",	i_ven_code); //거래처    - A06	
											
			ht5_1.put("DT_START",  "");  	//발생일자										 
			ht5_1.put("CD_BIZAREA",		"");   //귀속사업장	
			ht5_1.put("CD_DEPT",		"");   //부서								 
			ht5_1.put("CD_CC",			"");   //코스트센터		
			ht5_1.put("CD_PJT",			"");   //프로젝트코드		
			ht5_1.put("CD_CARD",		"");   //신용카드		 	
			ht5_1.put("CD_EMPLOY",		"");   //사원									 		 
			ht5_1.put("NO_DEPOSIT",	"");  //예적금계좌
			ht5_1.put("CD_BANK",		"");  //금융기관	
			ht5_1.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht5_1.put("AM_TAXSTD",	"");  //과세표준액
			ht5_1.put("AM_ADDTAX",	"" );	 //세액
			ht5_1.put("TP_TAX",	"");  //과세(매출) :11
			ht5_1.put("NO_COMPANY",	""); //사업자등록번호
					
			ht5_1.put("NM_NOTE", doc_cont);  // 적요					
								
			vt_auto.add(ht5_1);  //  외상매출금
		}	
		
		if ( car_ja_no_amt > 0) {  //차량손해면책금이 있는 경우만 
	
			line++;
				 				   		
	   		Hashtable ht5 = new Hashtable();
	   		
	   		ht5.put("WRITE_DATE", 	real_date); //row_id							
			ht5.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht5.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht5.put("CD_PC",  	node_code);  //회계단위
			ht5.put("CD_WDEPT",  dept_code);  //부서
			ht5.put("NO_DOCU",  	"");  //미결은 '0' 
			ht5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht5.put("CD_COMPANY",  "1000");  
			ht5.put("ID_WRITE", insert_id);   
			ht5.put("CD_DOCU",  "11");  
			
			ht5.put("DT_ACCT", 	real_date); 
			ht5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			//ht5.put("TP_DRCR",   "2");   // 대변:2 , 차변:1		
			//ht5.put("CD_ACCT",  	"91800");  //차량손해면책금
			//ht5.put("AMT",  	String.valueOf( car_ja_no_amt ));	
			
			ht5.put("TP_DRCR",   "1");   // 대변:2 , 차변:1		
			ht5.put("CD_ACCT",  	"45510");  //차량손해면책금
			ht5.put("AMT",  	String.valueOf( car_ja_no_amt * (-1) ));	
						
			ht5.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht5.put("CD_PARTNER",	i_ven_code); //거래처    - A06	
											
			ht5.put("DT_START",  "");  	//발생일자										 
			ht5.put("CD_BIZAREA",		"");   //귀속사업장	
			ht5.put("CD_DEPT",		"");   //부서								 
			ht5.put("CD_CC",			"");   //코스트센터		
			ht5.put("CD_PJT",			"");   //프로젝트코드		
			ht5.put("CD_CARD",		"");   //신용카드		 	
			ht5.put("CD_EMPLOY",		"");   //사원									 		 
			ht5.put("NO_DEPOSIT",	"");  //예적금계좌
			ht5.put("CD_BANK",		"");  //금융기관	
			ht5.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht5.put("AM_TAXSTD",	"");  //과세표준액
			ht5.put("AM_ADDTAX",	"" );	 //세액
			ht5.put("TP_TAX",	"");  //과세(매출) :11
			ht5.put("NO_COMPANY",	""); //사업자등록번호
					
			ht5.put("NM_NOTE", doc_cont);  // 적요	
											
			vt_auto.add(ht5);  // 면책금 
		}		
  }
 	 
  //연체료 상계
  if ( AddUtil.parseDigit(request.getParameter("dly_amt_2"))  != 0 ) {
 	
 		if (cls_st.equals("1") ) {
			 doc_cont = "계약만료 연체료" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "매입옵션 연체료" + "-" + car_no + " " + firm_nm;
		} else {
			 doc_cont = "중도해지 연체료" + "-" + car_no + " " + firm_nm;
		}		
		
		line++;
			 				   		
   		Hashtable ht6 = new Hashtable();
					
   		ht6.put("WRITE_DATE", 	real_date); //row_id							
		ht6.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht6.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht6.put("CD_PC",  	node_code);  //회계단위
		ht6.put("CD_WDEPT",  dept_code);  //부서
		ht6.put("NO_DOCU",  	"");  //미결은 '0' 
		ht6.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht6.put("CD_COMPANY",  "1000");  
		ht6.put("ID_WRITE", insert_id);   
		ht6.put("CD_DOCU",  "11");  
		
		ht6.put("DT_ACCT", 	real_date); 
		ht6.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht6.put("TP_DRCR",   "2");   // 대변:2 , 차변:1		
		ht6.put("CD_ACCT",  	"91300");  //연체료
		ht6.put("AMT",  	String.valueOf( AddUtil.parseDigit(request.getParameter("dly_amt_2")) ));					
		ht6.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht6.put("CD_PARTNER",	i_ven_code); //거래처    - A06	
										
		ht6.put("DT_START",  "");  	//발생일자										 
		ht6.put("CD_BIZAREA",		"");   //귀속사업장	
		ht6.put("CD_DEPT",		"");   //부서								 
		ht6.put("CD_CC",			"");   //코스트센터		
		ht6.put("CD_PJT",			"");   //프로젝트코드		
		ht6.put("CD_CARD",		"");   //신용카드		 	
		ht6.put("CD_EMPLOY",		"");   //사원									 		 
		ht6.put("NO_DEPOSIT",	"");  //예적금계좌
		ht6.put("CD_BANK",		"");  //금융기관	
		ht6.put("NO_ITEM",		"");  //item	  	 
		
			// 부가세관련
		ht6.put("AM_TAXSTD",	"");  //과세표준액
		ht6.put("AM_ADDTAX",	"" );	 //세액
		ht6.put("TP_TAX",	"");  //과세(매출) :11
		ht6.put("NO_COMPANY",	""); //사업자등록번호
				
		ht6.put("NM_NOTE", doc_cont);  // 적요						
						
		vt_auto.add(ht6);  // 연체료 		 	
  }  
  
 //대여료 세금 계산서 발행건 처리 
  if ( a4_s_amt > 0 ) {
 
 	//  렌트(리스)사업매출인 경우는 부가세처리 
 	  	if (cls_st.equals("1") ) {
				 doc_cont = "계약만료 대여료" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "매입옵션 대여료" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "중도해지 대여료" + "-" + car_no + " " + firm_nm;
		}		 
		
		if ( AddUtil.parseDigit(request.getParameter("dfee_amt_2"))  < 1 ) { 	 //외상매출금 추가
			
				line++;
						
				Hashtable ht8_3 = new Hashtable();
				
				ht8_3.put("WRITE_DATE", 	real_date); //row_id							
				ht8_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht8_3.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht8_3.put("CD_PC",  	node_code);  //회계단위
				ht8_3.put("CD_WDEPT",  dept_code);  //부서
				ht8_3.put("NO_DOCU",  	"");  //미결은 '0' 
				ht8_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht8_3.put("CD_COMPANY",  "1000");  
				ht8_3.put("ID_WRITE", insert_id);   
				ht8_3.put("CD_DOCU",  "11");  
				
				ht8_3.put("DT_ACCT", 	real_date); 
				ht8_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht8_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1		
				ht8_3.put("CD_ACCT",  	"10800");  //외상매출금	
				ht8_3.put("AMT",    	String.valueOf( a4_s_amt + a4_v_amt ));		
				ht8_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht8_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06	
												
				ht8_3.put("DT_START",  "");  	//발생일자										 
				ht8_3.put("CD_BIZAREA",		"");   //귀속사업장	
				ht8_3.put("CD_DEPT",		"");   //부서								 
				ht8_3.put("CD_CC",			"");   //코스트센터		
				ht8_3.put("CD_PJT",			"");   //프로젝트코드		
				ht8_3.put("CD_CARD",		"");   //신용카드		 	
				ht8_3.put("CD_EMPLOY",		"");   //사원									 		 
				ht8_3.put("NO_DEPOSIT",	"");  //예적금계좌
				ht8_3.put("CD_BANK",		"");  //금융기관	
				ht8_3.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht8_3.put("AM_TAXSTD",	"");  //과세표준액
				ht8_3.put("AM_ADDTAX",	"" );	 //세액
				ht8_3.put("TP_TAX",	"");  //과세(매출) :11
				ht8_3.put("NO_COMPANY",	""); //사업자등록번호
						
				ht8_3.put("NM_NOTE", doc_cont);  // 적요		
										
				vt_auto.add(ht8_3);  //  외상매출금
						
		}		
			
		line++;
					
		Hashtable ht8_1 = new Hashtable();
		
		ht8_1.put("WRITE_DATE", 	real_date); //row_id							
		ht8_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht8_1.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht8_1.put("CD_PC",  	node_code);  //회계단위
		ht8_1.put("CD_WDEPT",  dept_code);  //부서
		ht8_1.put("NO_DOCU",  	"");  //미결은 '0' 
		ht8_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht8_1.put("CD_COMPANY",  "1000");  
		ht8_1.put("ID_WRITE", insert_id);   
		ht8_1.put("CD_DOCU",  "11");  
		
		ht8_1.put("DT_ACCT", 	real_date); 
		ht8_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht8_1.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
		
		if ( base.getCar_st().equals("1") ) { //렌트이면
				ht8_1.put("CD_ACCT",  	"41200");  //대여사업매출
		} else {
				ht8_1.put("CD_ACCT",  	"41700");  //리스사업매출
		}	
		
		ht8_1.put("AMT",    	String.valueOf( a4_s_amt ));					
		ht8_1.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht8_1.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht8_1.put("DT_START",  "");  	//발생일자										 
		ht8_1.put("CD_BIZAREA",		"");   //귀속사업장	
		ht8_1.put("CD_DEPT",		"");   //부서								 
		ht8_1.put("CD_CC",			"");   //코스트센터		
		ht8_1.put("CD_PJT",			"");   //프로젝트코드		
		ht8_1.put("CD_CARD",		"");   //신용카드		 	
		ht8_1.put("CD_EMPLOY",		"");   //사원									 		 
		ht8_1.put("NO_DEPOSIT",	"");  //예적금계좌
		ht8_1.put("CD_BANK",		"");  //금융기관	
		ht8_1.put("NO_ITEM",		"");  //item	  	 
		
			// 부가세관련
		ht8_1.put("AM_TAXSTD",	"");  //과세표준액
		ht8_1.put("AM_ADDTAX",	"" );	 //세액
		ht8_1.put("TP_TAX",	"");  //과세(매출) :11
		ht8_1.put("NO_COMPANY",	""); //사업자등록번호
				
		ht8_1.put("NM_NOTE", doc_cont);  // 적요							
							
		vt_auto.add(ht8_1);  //  공급가
		
		line++;
		
		Hashtable ht8_2 = new Hashtable();
			
		ht8_2.put("WRITE_DATE", 	real_date); //row_id							
		ht8_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht8_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
		ht8_2.put("CD_PC",  	node_code);  //회계단위
		ht8_2.put("CD_WDEPT",  dept_code);  //부서
		ht8_2.put("NO_DOCU",  	"");  //미결은 '0' 
		ht8_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht8_2.put("CD_COMPANY",  "1000");  
		ht8_2.put("ID_WRITE", insert_id);   
		ht8_2.put("CD_DOCU",  "11");  
		
		ht8_2.put("DT_ACCT", 	real_date); 
		ht8_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht8_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
		ht8_2.put("CD_ACCT",  		"25500");  //부가세예수금					
		ht8_2.put("AMT",   		String.valueOf( a4_v_amt) );								
		ht8_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht8_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
									
		ht8_2.put("DT_START",  real_date);  	//발생일자 - 부가세										 
		ht8_2.put("CD_BIZAREA",		"S101");   //귀속사업장	
		ht8_2.put("CD_DEPT",		"");   //부서								 
		ht8_2.put("CD_CC",			"");   //코스트센터		
		ht8_2.put("CD_PJT",			"");   //프로젝트코드		
		ht8_2.put("CD_CARD",		"");   //신용카드		 	
		ht8_2.put("CD_EMPLOY",		"");   //사원									 		 
		ht8_2.put("NO_DEPOSIT",	"");  //예적금계좌
		ht8_2.put("CD_BANK",		"");  //금융기관	
		ht8_2.put("NO_ITEM",		"");  //item	 	  	 
			
	// 부가세관련
		ht8_2.put("AM_TAXSTD",	  String.valueOf( a4_s_amt) );		 //과세표준액
		ht8_2.put("AM_ADDTAX",	String.valueOf( a4_v_amt) );			 //세액
		ht8_2.put("TP_TAX",	"11");  //과세(매출) :11
		ht8_2.put("NO_COMPANY",	s_idno); //사업자등록번호
										
		ht8_2.put("NM_NOTE", doc_cont);  // 적요	
		
		vt_auto.add(ht8_2);  // 부가세	 
  }
 	 	 
  //대여료 외상매출금 상계 - 외상매출금, 리스/렌트 사업매출 구분하여 처리 - 선납인경우는 대변에 마이너스금액
  if ( AddUtil.parseDigit(request.getParameter("dfee_amt_2"))  < 0 ) {
 	 		
 	   amt_10800 = AddUtil.parseDigit(request.getParameter("dfee_amt_2")) + AddUtil.parseDigit(request.getParameter("dfee_amt_2_v"))- a4_s_amt - a4_v_amt;
 	   
 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
	 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "계약만료 대여료" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "매입옵션 대여료" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "중도해지 대여료" + "-" + car_no + " " + firm_nm;
			}		 
				
			line++;
						
			Hashtable ht8 = new Hashtable();
			
			ht8.put("WRITE_DATE", 	real_date); //row_id							
			ht8.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht8.put("CD_PC",  	node_code);  //회계단위
			ht8.put("CD_WDEPT",  dept_code);  //부서
			ht8.put("NO_DOCU",  	"");  //미결은 '0' 
			ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht8.put("CD_COMPANY",  "1000");  
			ht8.put("ID_WRITE", insert_id);   
			ht8.put("CD_DOCU",  "11");  
			
			ht8.put("DT_ACCT", 	real_date); 
			ht8.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht8.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			ht8.put("CD_ACCT",  "10800");   // 
			ht8.put("AMT",    	String.valueOf( amt_10800) );			
			ht8.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht8.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht8.put("DT_START",  "");  	//발생일자										 
			ht8.put("CD_BIZAREA",		"");   //귀속사업장	
			ht8.put("CD_DEPT",		"");   //부서								 
			ht8.put("CD_CC",			"");   //코스트센터		
			ht8.put("CD_PJT",			"");   //프로젝트코드		
			ht8.put("CD_CARD",		"");   //신용카드		 	
			ht8.put("CD_EMPLOY",		"");   //사원									 		 
			ht8.put("NO_DEPOSIT",	"");  //예적금계좌
			ht8.put("CD_BANK",		"");  //금융기관	
			ht8.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht8.put("AM_TAXSTD",	"");  //과세표준액
			ht8.put("AM_ADDTAX",	"" );	 //세액
			ht8.put("TP_TAX",	"");  //과세(매출) :11
			ht8.put("NO_COMPANY",	""); //사업자등록번호
					
			ht8.put("NM_NOTE", doc_cont);  // 적요									
								
			vt_auto.add(ht8);  //  외상매출금
		}	
		
  } 
    	 	 
  //대여료 외상매출금 일부 상계 - 외상매출금, 리스/렌트 사업매출 구분하여 처리  
  if ( AddUtil.parseDigit(request.getParameter("dfee_amt_2"))  > 0 ) {
 	 		
 	   amt_10800 = AddUtil.parseDigit(request.getParameter("dfee_amt_2")) + AddUtil.parseDigit(request.getParameter("dfee_amt_2_v"))- a4_s_amt - a4_v_amt;
 	   	    
 	   if ( amt_10800 >  0) {  //외상매출금이 있는 경우만  - 전체 금액 상각
	 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "계약만료 대여료" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "매입옵션 대여료" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "중도해지 대여료" + "-" + car_no + " " + firm_nm;
			}		 
				
			line++;
						
			Hashtable ht8_5 = new Hashtable();
				
			ht8_5.put("WRITE_DATE", 	real_date); //row_id							
			ht8_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_5.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht8_5.put("CD_PC",  node_code);  //회계단위
			ht8_5.put("CD_WDEPT",  dept_code);  //부서
			ht8_5.put("NO_DOCU",  	"");  //미결은 '0' 
			ht8_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht8_5.put("CD_COMPANY",  "1000");  
			ht8_5.put("ID_WRITE", insert_id);   
			ht8_5.put("CD_DOCU",  "11");  
			
			ht8_5.put("DT_ACCT", 	real_date); 
			ht8_5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht8_5.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			ht8_5.put("CD_ACCT",  "10800");   // 
			ht8_5.put("AMT",    	String.valueOf( amt_10800) );			
			ht8_5.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht8_5.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht8_5.put("DT_START",  "");  	//발생일자										 
			ht8_5.put("CD_BIZAREA",		"");   //귀속사업장	
			ht8_5.put("CD_DEPT",		"");   //부서								 
			ht8_5.put("CD_CC",			"");   //코스트센터		
			ht8_5.put("CD_PJT",			"");   //프로젝트코드		
			ht8_5.put("CD_CARD",		"");   //신용카드		 	
			ht8_5.put("CD_EMPLOY",		"");   //사원									 		 
			ht8_5.put("NO_DEPOSIT",	"");  //예적금계좌
			ht8_5.put("CD_BANK",		"");  //금융기관	
			ht8_5.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht8_5.put("AM_TAXSTD",	"");  //과세표준액
			ht8_5.put("AM_ADDTAX",	"" );	 //세액
			ht8_5.put("TP_TAX",	"");  //과세(매출) :11
			ht8_5.put("NO_COMPANY",	""); //사업자등록번호
					
			ht8_5.put("NM_NOTE", doc_cont);  // 적요
								
			vt_auto.add(ht8_5);  //  외상매출금
	   }		
 	   	   
 	   if ( amt_10800 < 0) {  //외상매출금이 일부 상각된 경우 
	 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "계약만료 대여료" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "매입옵션 대여료" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "중도해지 대여료" + "-" + car_no + " " + firm_nm;
			}		 
							
			line++;
						
			Hashtable ht8_7 = new Hashtable();
			
			ht8_7.put("WRITE_DATE", 	real_date); //row_id							
			ht8_7.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_7.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht8_7.put("CD_PC",  	node_code);  //회계단위
			ht8_7.put("CD_WDEPT",  dept_code);  //부서
			ht8_7.put("NO_DOCU",  	"");  //미결은 '0' 
			ht8_7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht8_7.put("CD_COMPANY",  "1000");  
			ht8_7.put("ID_WRITE", insert_id);   
			ht8_7.put("CD_DOCU",  "11");  
			
			ht8_7.put("DT_ACCT", 	real_date); 
			ht8_7.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht8_7.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
			ht8_7.put("CD_ACCT",  "10800");   // 
			ht8_7.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
			ht8_7.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht8_7.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht8_7.put("DT_START",  "");  	//발생일자										 
			ht8_7.put("CD_BIZAREA",		"");   //귀속사업장	
			ht8_7.put("CD_DEPT",		"");   //부서								 
			ht8_7.put("CD_CC",			"");   //코스트센터		
			ht8_7.put("CD_PJT",			"");   //프로젝트코드		
			ht8_7.put("CD_CARD",		"");   //신용카드		 	
			ht8_7.put("CD_EMPLOY",		"");   //사원									 		 
			ht8_7.put("NO_DEPOSIT",	"");  //예적금계좌
			ht8_7.put("CD_BANK",		"");  //금융기관	
			ht8_7.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht8_7.put("AM_TAXSTD",	"");  //과세표준액
			ht8_7.put("AM_ADDTAX",	"" );	 //세액
			ht8_7.put("TP_TAX",	"");  //과세(매출) :11
			ht8_7.put("NO_COMPANY",	""); //사업자등록번호
					
			ht8_7.put("NM_NOTE", doc_cont);  // 적요									
			
			vt_auto.add(ht8_7);  //  외상매출금 - 미상계부분
		}		
   } 
    
     //잔존차량가치 - 싼타페 연비보상 
  if ( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))  < 0 ) {	 
  		
				if (cls_st.equals("8") ) {
					 doc_cont = "매입옵션 연비보상" + "-" + car_no + " " + firm_nm;
				}		 
			 	   
				line++;
							
				Hashtable ht16_3 = new Hashtable();	
				
				ht16_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht16_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht16_3.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht16_3.put("CD_PC",  	node_code);  //회계단위
				ht16_3.put("CD_WDEPT",  dept_code);  //부서
				ht16_3.put("NO_DOCU",  	"");  //미결은 '0' 
				ht16_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht16_3.put("CD_COMPANY",  "1000");  
				ht16_3.put("ID_WRITE", insert_id);   
				ht16_3.put("CD_DOCU",  "11");  
			
			
				ht16_3.put("DT_ACCT", 	cls.getCls_dt()); 
				ht16_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht16_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
				ht16_3.put("CD_ACCT", 	"25900");  //선수금
				ht16_3.put("AMT",    		 	String.valueOf( AddUtil.parseDigit(request.getParameter("etc3_amt_2")) * (-1)     )    );				
				ht16_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체		
				
			//	ht16_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06 - 격락손해 등 특수 case
				
				if (  return_remark.equals("싼타페") ) {
					   ht16_3.put("CD_PARTNER",	"000048"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322) 
				 } else if (  return_remark.equals("볼보") ) {
					   ht16_3.put("CD_PARTNER",	"995591"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322)
				 } else if (  return_remark.equals("혼다") ) {  //혼다는 매입옵션만 
					   ht16_3.put("CD_PARTNER",	"996528"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322)
				 } else if (  return_remark.equals("벤츠") ) {
					   ht16_3.put("CD_PARTNER",	"996322"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322)
				 }		
																
				ht16_3.put("DT_START",  "");  	//발생일자										 
				ht16_3.put("CD_BIZAREA",		"");   //귀속사업장	
				ht16_3.put("CD_DEPT",		"");   //부서								 
				ht16_3.put("CD_CC",			"");   //코스트센터		
				ht16_3.put("CD_PJT",			"");   //프로젝트코드		
				ht16_3.put("CD_CARD",		"");   //신용카드		 	
				ht16_3.put("CD_EMPLOY",		"");   //사원									 		 
				ht16_3.put("NO_DEPOSIT",	"");  //예적금계좌
				ht16_3.put("CD_BANK",		"");  //금융기관	
				ht16_3.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht16_3.put("AM_TAXSTD",	"");  //과세표준액
				ht16_3.put("AM_ADDTAX",	"" );	 //세액
				ht16_3.put("TP_TAX",	"");  //과세(매출) :11
				ht16_3.put("NO_COMPANY",	""); //사업자등록번호
						
				ht16_3.put("NM_NOTE", doc_cont);  // 적요	
														
				vt_auto.add(ht16_3);  //  공급가
					
 }
    
    /*
    if ( a8_s_amt > 0 ) {
	 
	 	//  렌트(리스)사업매출인 경우는 부가세처리 
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "계약만료 손해배상금" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "매입옵션 손해배상금" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "중도해지 손해배상금" + "-" + car_no + " " + firm_nm;
			}		 
				
			if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  < 1 ) { 	  //외상매출금 추가
			
				line++;
						
				Hashtable ht15_3 = new Hashtable();
				
				ht15_3.put("WRITE_DATE", 	real_date); //row_id							
				ht15_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht15_3.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht15_3.put("CD_PC",  	node_code);  //회계단위
				ht15_3.put("CD_WDEPT",  dept_code);  //부서
				ht15_3.put("NO_DOCU",  	"");  //미결은 '0' 
				ht15_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht15_3.put("CD_COMPANY",  "1000");  
				ht15_3.put("ID_WRITE", insert_id);   
				ht15_3.put("CD_DOCU",  "11");  
				
				ht15_3.put("DT_ACCT", 	real_date); 
				ht15_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht15_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
				ht15_3.put("CD_ACCT",  "10800");   // 
				ht15_3.put("AMT",    	String.valueOf( a8_s_amt + a8_v_amt) );				
				ht15_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht15_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht15_3.put("DT_START",  "");  	//발생일자										 
				ht15_3.put("CD_BIZAREA",		"");   //귀속사업장	
				ht15_3.put("CD_DEPT",		"");   //부서								 
				ht15_3.put("CD_CC",			"");   //코스트센터		
				ht15_3.put("CD_PJT",			"");   //프로젝트코드		
				ht15_3.put("CD_CARD",		"");   //신용카드		 	
				ht15_3.put("CD_EMPLOY",		"");   //사원									 		 
				ht15_3.put("NO_DEPOSIT",	"");  //예적금계좌
				ht15_3.put("CD_BANK",		"");  //금융기관	
				ht15_3.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht15_3.put("AM_TAXSTD",	"");  //과세표준액
				ht15_3.put("AM_ADDTAX",	"" );	 //세액
				ht15_3.put("TP_TAX",	"");  //과세(매출) :11
				ht15_3.put("NO_COMPANY",	""); //사업자등록번호
						
				ht15_3.put("NM_NOTE", doc_cont);  // 적요									
											
				vt_auto.add(ht15_3);  //  외상매출금
						
			}	
				
			line++;
						
			Hashtable ht15 = new Hashtable();
			
			ht15.put("WRITE_DATE", 	real_date); //row_id							
			ht15.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht15.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht15.put("CD_PC",  	node_code);  //회계단위
			ht15.put("CD_WDEPT",  dept_code);  //부서
			ht15.put("NO_DOCU",  	"");  //미결은 '0' 
			ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht15.put("CD_COMPANY",  "1000");  
			ht15.put("ID_WRITE", insert_id);   
			ht15.put("CD_DOCU",  "11");  
			
			ht15.put("DT_ACCT", 	real_date); 
			ht15.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht15.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			
			if ( base.getCar_st().equals("1") ) { //렌트이면
					ht15.put("CD_ACCT",  	"41200");  //손해배상금
			} else {
					ht15.put("CD_ACCT",  	"41700");  //손해배상금
			}	
			
			ht15.put("AMT",    String.valueOf( a8_s_amt ) );	
			ht15.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht15.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
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
					
			ht15.put("NM_NOTE", doc_cont);  // 적요									
								
			vt_auto.add(ht15);  //  공급가
			
			line++;
			
			Hashtable ht15_2 = new Hashtable();
			
			ht15_2.put("WRITE_DATE", 	real_date); //row_id							
			ht15_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht15_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
			ht15_2.put("CD_PC",  	node_code);  //회계단위
			ht15_2.put("CD_WDEPT",  dept_code);  //부서
			ht15_2.put("NO_DOCU",  	"");  //미결은 '0' 
			ht15_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht15_2.put("CD_COMPANY",  "1000");  
			ht15_2.put("ID_WRITE", insert_id);   
			ht15_2.put("CD_DOCU",  "11");  
			
			ht15_2.put("DT_ACCT", 	real_date); 
			ht15_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht15_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
			ht15_2.put("CD_ACCT",  	"25500");  //부가세예수금					
			ht15_2.put("AMT",   	String.valueOf( a8_v_amt) );						
			ht15_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht15_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht15_2.put("DT_START", real_date);  	//발생일자 - 부가세										 
			ht15_2.put("CD_BIZAREA",	"S101");   //귀속사업장	
			ht15_2.put("CD_DEPT",		"");   //부서								 
			ht15_2.put("CD_CC",			"");   //코스트센터		
			ht15_2.put("CD_PJT",		"");   //프로젝트코드		
			ht15_2.put("CD_CARD",		"");   //신용카드		 	
			ht15_2.put("CD_EMPLOY",	"");   //사원									 		 
			ht15_2.put("NO_DEPOSIT",	"");  //예적금계좌
			ht15_2.put("CD_BANK",		"");  //금융기관	
			ht15_2.put("NO_ITEM",		"");  //item	 	  	 
				
		// 부가세관련
			ht15_2.put("AM_TAXSTD",	 String.valueOf( a8_s_amt) );		 //과세표준액
			ht15_2.put("AM_ADDTAX",	String.valueOf( a8_v_amt) );		 //세액
			ht15_2.put("TP_TAX",	"11");  //과세(매출) :11
			ht15_2.put("NO_COMPANY",	s_idno); //사업자등록번호
											
			ht15_2.put("NM_NOTE", doc_cont);  // 적요			
		
			vt_auto.add(ht15_2);  // 부가세		
						
				//기타손해배상금 일부 상계 - 외상매출금, 리스/렌트 사업매출 구분하여 처리 
		    if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  > 0 ) {
		 
		 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc4_amt_2")) + AddUtil.parseDigit(request.getParameter("etc4_amt_2_v"))- a8_s_amt - a8_v_amt;
		 	   
		 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
			 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
			 	  	if (cls_st.equals("1") ) {
							 doc_cont = "계약만료 손해배상금" + "-" + car_no + " " + firm_nm;
					} else if (cls_st.equals("8") ) {
							 doc_cont = "매입옵션 손해배상금" + "-" + car_no + " " + firm_nm;
					} else {
							 doc_cont = "중도해지 손해배상금" + "-" + car_no + " " + firm_nm;
					}		 
						
					line++;
								
					Hashtable ht15_4 = new Hashtable();
					
					ht15_4.put("WRITE_DATE", 	real_date); //row_id							
					ht15_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht15_4.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht15_4.put("CD_PC",  	node_code);  //회계단위
					ht15_4.put("CD_WDEPT",  dept_code);  //부서
					ht15_4.put("NO_DOCU",  	"");  //미결은 '0' 
					ht15_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht15_4.put("CD_COMPANY",  "1000");  
					ht15_4.put("ID_WRITE", insert_id);   
					ht15_4.put("CD_DOCU",  "11");  
					
					ht15_4.put("DT_ACCT", 	real_date); 
					ht15_4.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht15_4.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht15_4.put("CD_ACCT",  "10800");   // 
					ht15_4.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
					ht15_4.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht15_4.put("CD_PARTNER",	i_ven_code); //거래처    - A06
												
					ht15_4.put("DT_START",  "");  	//발생일자										 
					ht15_4.put("CD_BIZAREA",		"");   //귀속사업장	
					ht15_4.put("CD_DEPT",		"");   //부서								 
					ht15_4.put("CD_CC",			"");   //코스트센터		
					ht15_4.put("CD_PJT",			"");   //프로젝트코드		
					ht15_4.put("CD_CARD",		"");   //신용카드		 	
					ht15_4.put("CD_EMPLOY",		"");   //사원									 		 
					ht15_4.put("NO_DEPOSIT",	"");  //예적금계좌
					ht15_4.put("CD_BANK",		"");  //금융기관	
					ht15_4.put("NO_ITEM",		"");  //item	  	 
					
						// 부가세관련
					ht15_4.put("AM_TAXSTD",	"");  //과세표준액
					ht15_4.put("AM_ADDTAX",	"" );	 //세액
					ht15_4.put("TP_TAX",	"");  //과세(매출) :11
					ht15_4.put("NO_COMPANY",	""); //사업자등록번호
							
					ht15_4.put("NM_NOTE", doc_cont);  // 적요	
											
					vt_auto.add(ht15_4);  //  외상매출금
				}	
						
		  }
	 
	 // 세금계산서 발행이 안되었을 경우
  } else {*/
	  
	 if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  > 0 ) {	 	 	 	 	   
	 	// 세금계산서 발행분을 제외한 부분을 차량손해면책금으로
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "계약만료 손해배상금" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "매입옵션 손해배상금" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "중도해지 손해배상금" + "-" + car_no + " " + firm_nm;
			}		 
				
			line++;
						
			Hashtable ht16 = new Hashtable();
			
			ht16.put("WRITE_DATE", 	real_date); //row_id							
			ht16.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht16.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht16.put("CD_PC",  	node_code);  //회계단위
			ht16.put("CD_WDEPT",  dept_code);  //부서
			ht16.put("NO_DOCU",  	"");  //미결은 '0' 
			ht16.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht16.put("CD_COMPANY",  "1000");  
			ht16.put("ID_WRITE", insert_id);   
			ht16.put("CD_DOCU",  "11");  
			
			ht16.put("DT_ACCT", 	real_date); 
			ht16.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		//	ht16.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
		//	ht16.put("CD_ACCT",   	"91800");  //차량손해면책금
		//	ht16.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))) );	
			
			ht16.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
			ht16.put("CD_ACCT",   	"45510");  //차량손해면책금
			ht16.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc4_amt_2")) *(-1) ) );	
			
			
			ht16.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht16.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht16.put("DT_START",  "");  	//발생일자										 
			ht16.put("CD_BIZAREA",		"");   //귀속사업장	
			ht16.put("CD_DEPT",		"");   //부서								 
			ht16.put("CD_CC",			"");   //코스트센터		
			ht16.put("CD_PJT",			"");   //프로젝트코드		
			ht16.put("CD_CARD",		"");   //신용카드		 	
			ht16.put("CD_EMPLOY",		"");   //사원									 		 
			ht16.put("NO_DEPOSIT",	"");  //예적금계좌
			ht16.put("CD_BANK",		"");  //금융기관	
			ht16.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht16.put("AM_TAXSTD",	"");  //과세표준액
			ht16.put("AM_ADDTAX",	"" );	 //세액
			ht16.put("TP_TAX",	"");  //과세(매출) :11
			ht16.put("NO_COMPANY",	""); //사업자등록번호
					
			ht16.put("NM_NOTE", doc_cont);  // 적요			
									
			vt_auto.add(ht16);  //  공급가
				
	  }
//  }	  
   
    //초과운행 부담금 계산서 발행건 처리   
  if ( a9_s_amt > 0 ) {
	 
	 	//  렌트(리스)사업매출인 경우는 부가세처리 
		 	if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차)  초과운행대여료" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
			 	      		  doc_cont =  cls.getCls_st()  + " 초과운행대여료" + "-" + car_no + " " + firm_nm;
			}	
			 	  
			if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  < 1 ) { 	  //외상매출금 추가
			
				line++;
						
				Hashtable ht16_4 = new Hashtable();
				
				ht16_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht16_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht16_4.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht16_4.put("CD_PC",  	node_code);  //회계단위
				ht16_4.put("CD_WDEPT",  dept_code);  //부서
				ht16_4.put("NO_DOCU",  	"");  //미결은 '0' 
				ht16_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht16_4.put("CD_COMPANY",  "1000");  
				ht16_4.put("ID_WRITE", insert_id);   
				ht16_4.put("CD_DOCU",  "11");  
				
				ht16_4.put("DT_ACCT", 	cls.getCls_dt()); 
				ht16_4.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht16_4.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
				ht16_4.put("CD_ACCT",  "10800");   // 
				ht16_4.put("AMT",    		String.valueOf( a9_s_amt + a9_v_amt ));
				ht16_4.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht16_4.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht16_4.put("DT_START",  "");  	//발생일자										 
				ht16_4.put("CD_BIZAREA",		"");   //귀속사업장	
				ht16_4.put("CD_DEPT",		"");   //부서								 
				ht16_4.put("CD_CC",			"");   //코스트센터		
				ht16_4.put("CD_PJT",			"");   //프로젝트코드		
				ht16_4.put("CD_CARD",		"");   //신용카드		 	
				ht16_4.put("CD_EMPLOY",		"");   //사원									 		 
				ht16_4.put("NO_DEPOSIT",	"");  //예적금계좌
				ht16_4.put("CD_BANK",		"");  //금융기관	
				ht16_4.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht16_4.put("AM_TAXSTD",	"");  //과세표준액
				ht16_4.put("AM_ADDTAX",	"" );	 //세액
				ht16_4.put("TP_TAX",	"");  //과세(매출) :11
				ht16_4.put("NO_COMPANY",	""); //사업자등록번호
						
				ht16_4.put("NM_NOTE", doc_cont);  // 적요									
										
				vt_auto.add(ht16_4);  //  외상매출금						
			}	
			
			line++;
						
			Hashtable ht16_5 = new Hashtable();
				
			ht16_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht16_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht16_5.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht16_5.put("CD_PC",  	node_code);  //회계단위
			ht16_5.put("CD_WDEPT",  dept_code);  //부서
			ht16_5.put("NO_DOCU",  	"");  //미결은 '0' 
			ht16_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht16_5.put("CD_COMPANY",  "1000");  
			ht16_5.put("ID_WRITE", insert_id);   
			ht16_5.put("CD_DOCU",  "11");  
			
			ht16_5.put("DT_ACCT", 	cls.getCls_dt()); 
			ht16_5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht16_5.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			
			if ( base.getCar_st().equals("1") ||  base.getCar_st().equals("4")  ) { //렌트이면
					ht16_5.put("CD_ACCT",  	"41200");  //초과운행 부담금
			} else {
					ht16_5.put("CD_ACCT",  	"41700");  //초과운행 부담금
			}	
			
			ht16_5.put("AMT",    	String.valueOf( a9_s_amt ) );			
			ht16_5.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht16_5.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht16_5.put("DT_START",  "");  	//발생일자										 
			ht16_5.put("CD_BIZAREA",		"");   //귀속사업장	
			ht16_5.put("CD_DEPT",		"");   //부서								 
			ht16_5.put("CD_CC",			"");   //코스트센터		
			ht16_5.put("CD_PJT",			"");   //프로젝트코드		
			ht16_5.put("CD_CARD",		"");   //신용카드		 	
			ht16_5.put("CD_EMPLOY",		"");   //사원									 		 
			ht16_5.put("NO_DEPOSIT",	"");  //예적금계좌
			ht16_5.put("CD_BANK",		"");  //금융기관	
			ht16_5.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht16_5.put("AM_TAXSTD",	"");  //과세표준액
			ht16_5.put("AM_ADDTAX",	"" );	 //세액
			ht16_5.put("TP_TAX",	"");  //과세(매출) :11
			ht16_5.put("NO_COMPANY",	""); //사업자등록번호
					
			ht16_5.put("NM_NOTE", doc_cont);  // 적요									
								
			vt_auto.add(ht16_5);  //  공급가
			
			line++;
			
			Hashtable ht16_6 = new Hashtable();
				
			ht16_6.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht16_6.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht16_6.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
			ht16_6.put("CD_PC",  	node_code);  //회계단위
			ht16_6.put("CD_WDEPT",  dept_code);  //부서
			ht16_6.put("NO_DOCU",  	"");  //미결은 '0' 
			ht16_6.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht16_6.put("CD_COMPANY",  "1000");  
			ht16_6.put("ID_WRITE", insert_id);   
			ht16_6.put("CD_DOCU",  "11");  
			
			ht16_6.put("DT_ACCT", 	cls.getCls_dt()); 
			ht16_6.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht16_6.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
			ht16_6.put("CD_ACCT",  		"25500");  //부가세예수금					
			ht16_6.put("AMT",   		String.valueOf( a9_v_amt ) );								
			ht16_6.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht16_6.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht16_6.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
			ht16_6.put("CD_BIZAREA",		"S101");   //귀속사업장	
			ht16_6.put("CD_DEPT",		"");   //부서								 
			ht16_6.put("CD_CC",			"");   //코스트센터		
			ht16_6.put("CD_PJT",			"");   //프로젝트코드		
			ht16_6.put("CD_CARD",		"");   //신용카드		 	
			ht16_6.put("CD_EMPLOY",		"");   //사원									 		 
			ht16_6.put("NO_DEPOSIT",	"");  //예적금계좌
			ht16_6.put("CD_BANK",		"");  //금융기관	
			ht16_6.put("NO_ITEM",		"");  //item	 	  	 
				
		// 부가세관련
			ht16_6.put("AM_TAXSTD",	 String.valueOf( a9_s_amt) );		 //과세표준액
			ht16_6.put("AM_ADDTAX",	String.valueOf( a9_v_amt) );		 //세액
			ht16_6.put("TP_TAX",	"11");  //과세(매출) :11
			if(ven_type.equals("1")){ //개인
				ht16_6.put("NO_COMPANY",	"8888888888"); //사업자등록번호
			} else {
				ht16_6.put("NO_COMPANY",	s_idno); //사업자등록번호
			}									
			ht16_6.put("NM_NOTE", doc_cont);  // 적요	
							
			vt_auto.add(ht16_6);  // 부가세		
			
			
					//초과운행부담금 일부 상계 - 외상매출금, 리스/렌트 사업매출 구분하여 처리 
		    if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {
		 
		 	   amt_10800 = AddUtil.parseDigit(request.getParameter("over_amt_2")) + AddUtil.parseDigit(request.getParameter("over_amt_2_v"))- a9_s_amt - a9_v_amt;
		 	   
		 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
			 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
				 	if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 초과운행대여료" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
						 	    doc_cont =  cls.getCls_st()  + " 초과운행대여료" + "-" + car_no + " " + firm_nm;
					}	
			 	  						
					line++;
								
					Hashtable ht16_7 = new Hashtable();
					
					ht16_7.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht16_7.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht16_7.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht16_7.put("CD_PC",  	node_code);  //회계단위
					ht16_7.put("CD_WDEPT",  dept_code);  //부서
					ht16_7.put("NO_DOCU",  	"");  //미결은 '0' 
					ht16_7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht16_7.put("CD_COMPANY",  "1000");  
					ht16_7.put("ID_WRITE", insert_id);   
					ht16_7.put("CD_DOCU",  "11");  
					
					ht16_7.put("DT_ACCT", 	cls.getCls_dt()); 
					ht16_7.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht16_7.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht16_7.put("CD_ACCT",  "10800");   // 
					ht16_7.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
					ht16_7.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht16_7.put("CD_PARTNER",	i_ven_code); //거래처    - A06
												
					ht16_7.put("DT_START",  "");  	//발생일자										 
					ht16_7.put("CD_BIZAREA",		"");   //귀속사업장	
					ht16_7.put("CD_DEPT",		"");   //부서								 
					ht16_7.put("CD_CC",			"");   //코스트센터		
					ht16_7.put("CD_PJT",			"");   //프로젝트코드		
					ht16_7.put("CD_CARD",		"");   //신용카드		 	
					ht16_7.put("CD_EMPLOY",		"");   //사원									 		 
					ht16_7.put("NO_DEPOSIT",	"");  //예적금계좌
					ht16_7.put("CD_BANK",		"");  //금융기관	
					ht16_7.put("NO_ITEM",		"");  //item	  	 
					
						// 부가세관련
					ht16_7.put("AM_TAXSTD",	"");  //과세표준액
					ht16_7.put("AM_ADDTAX",	"" );	 //세액
					ht16_7.put("TP_TAX",	"");  //과세(매출) :11
					ht16_7.put("NO_COMPANY",	""); //사업자등록번호
							
					ht16_7.put("NM_NOTE", doc_cont);  // 적요									
										
					vt_auto.add(ht16_7);  //  외상매출금
			}	
						
		 }			
	 // 세금계산서 발행이 안되었을 경우
  } else {
  	
  	  // 기타손해배상금 세금 계산서 미리 발행건일 수도 있음 - 이때는 외상매출금 
	 if ( clse.getTax_chk4().equals("Y")) {
  		 
  		 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {
			 
		 	   amt_10800 = AddUtil.parseDigit(request.getParameter("over_amt_2")) + AddUtil.parseDigit(request.getParameter("over_amt_2_v"));
		 	   
		 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
			 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
			 		if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 초과 운행추가대여료" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	    doc_cont =  cls.getCls_st()  + " 초과 운행추가대여료" + "-" + car_no + " " + firm_nm;
					}	
			 	  	
													
					line++;
								
					Hashtable ht16_8 = new Hashtable();
			
					ht16_8.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht16_8.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht16_8.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht16_8.put("CD_PC",  	node_code);  //회계단위
					ht16_8.put("CD_WDEPT",  dept_code);  //부서
					ht16_8.put("NO_DOCU",  	"");  //미결은 '0' 
					ht16_8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht16_8.put("CD_COMPANY",  "1000");  
					ht16_8.put("ID_WRITE", insert_id);   
					ht16_8.put("CD_DOCU",  "11");  
					
					ht16_8.put("DT_ACCT", 	cls.getCls_dt()); 
					ht16_8.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht16_8.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
					ht16_8.put("CD_ACCT",  "10800");   // 
					ht16_8.put("AMT",    		String.valueOf( amt_10800) );			
					ht16_8.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht16_8.put("CD_PARTNER",	i_ven_code); //거래처    - A06
												
					ht16_8.put("DT_START",  "");  	//발생일자										 
					ht16_8.put("CD_BIZAREA",		"");   //귀속사업장	
					ht16_8.put("CD_DEPT",		"");   //부서								 
					ht16_8.put("CD_CC",			"");   //코스트센터		
					ht16_8.put("CD_PJT",			"");   //프로젝트코드		
					ht16_8.put("CD_CARD",		"");   //신용카드		 	
					ht16_8.put("CD_EMPLOY",		"");   //사원									 		 
					ht16_8.put("NO_DEPOSIT",	"");  //예적금계좌
					ht16_8.put("CD_BANK",		"");  //금융기관	
					ht16_8.put("NO_ITEM",		"");  //item	  	 
					
						// 부가세관련
					ht16_8.put("AM_TAXSTD",	"");  //과세표준액
					ht16_8.put("AM_ADDTAX",	"" );	 //세액
					ht16_8.put("TP_TAX",	"");  //과세(매출) :11
					ht16_8.put("NO_COMPANY",	""); //사업자등록번호
							
					ht16_8.put("NM_NOTE", doc_cont);  // 적요	
												
					vt_auto.add(ht16_8);  //  외상매출금
				}								
		  }	 		 	
  
     } else { //해지수익 계정이면
  
		 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {	 	 	 	 	   
		 	// 세금계산서 발행분을 제외한 부분을 차량손해면책금으로
		 		if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 초과 운행추가대여료" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
						    doc_cont =  cls.getCls_st()  + " 초과 운행추가대여료" + "-" + car_no + " " + firm_nm;
				}		 	  		
					
				line++;
							
				Hashtable ht16_9 = new Hashtable();		
				
				ht16_9.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht16_9.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht16_9.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht16_9.put("CD_PC",  	node_code);  //회계단위
				ht16_9.put("CD_WDEPT",  dept_code);  //부서
				ht16_9.put("NO_DOCU",  	"");  //미결은 '0' 
				ht16_9.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht16_9.put("CD_COMPANY",  "1000");  
				ht16_9.put("ID_WRITE", insert_id);   
				ht16_9.put("CD_DOCU",  "11");  
				
				ht16_9.put("DT_ACCT", 	cls.getCls_dt()); 
				ht16_9.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht16_9.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				
				if ( base.getCar_st().equals("1") ||  base.getCar_st().equals("4")  ) { //렌트이면
						ht16_9.put("CD_ACCT",  	"41400");  //해지수익
				} else {
						ht16_9.put("CD_ACCT",  	"41800");  //해지수익
				}	
										
				ht16_9.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("over_amt_2"))) );			
				ht16_9.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht16_9.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht16_9.put("DT_START",  "");  	//발생일자										 
				ht16_9.put("CD_BIZAREA",		"");   //귀속사업장	
				ht16_9.put("CD_DEPT",		"");   //부서								 
				ht16_9.put("CD_CC",			"");   //코스트센터		
				ht16_9.put("CD_PJT",			"");   //프로젝트코드		
				ht16_9.put("CD_CARD",		"");   //신용카드		 	
				ht16_9.put("CD_EMPLOY",		"");   //사원									 		 
				ht16_9.put("NO_DEPOSIT",	"");  //예적금계좌
				ht16_9.put("CD_BANK",		"");  //금융기관	
				ht16_9.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht16_9.put("AM_TAXSTD",	"");  //과세표준액
				ht16_9.put("AM_ADDTAX",	"" );	 //세액
				ht16_9.put("TP_TAX",	"");  //과세(매출) :11
				ht16_9.put("NO_COMPANY",	""); //사업자등록번호
						
				ht16_9.put("NM_NOTE", doc_cont);  // 적요			
										
				vt_auto.add(ht16_9);  //  공급가
					
		  }
	 }	   

 }					 

   //매입옵션인 경우에만 해당
  
  //매입옵션 차량대금
  if ( AddUtil.parseDigit(request.getParameter("opt_amt"))  > 0 ) {
 	 	
 	 	//매입옵션금액 - 보통예금 금액 (이미 선수금 처리함)
 	 	
 	 	amt_25900 = AddUtil.parseDigit(request.getParameter("opt_amt")) - AddUtil.parseDigit(request.getParameter("opt_ip_amt1")) - AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) ; 
 	 	
 	 	 //0 이상인 경우
 	 	
 	 	if ( amt_25900 > 0 ) {
 	 		
			doc_cont = "매입옵션 차량구입대금" + "-" + car_no + " " + firm_nm;
				
			line++;
				 				   		
	   		Hashtable ht23 = new Hashtable();
	   		
	   		ht23.put("WRITE_DATE", 	real_date); //row_id							
			ht23.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht23.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht23.put("CD_PC",  	node_code);  //회계단위
			ht23.put("CD_WDEPT",  dept_code);  //부서
			ht23.put("NO_DOCU",  	"");  //미결은 '0' 
			ht23.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht23.put("CD_COMPANY",  "1000");  
			ht23.put("ID_WRITE", insert_id);   
			ht23.put("CD_DOCU",  "11");  
			
			ht23.put("DT_ACCT", 	real_date); 
			ht23.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht23.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			ht23.put("CD_ACCT",  	"25900");  //선수금
			ht23.put("AMT",    	String.valueOf( amt_25900 ));						
			ht23.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht23.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht23.put("DT_START",  real_date); 	//발생일자										 
			ht23.put("CD_BIZAREA",		"");   //귀속사업장	
			ht23.put("CD_DEPT",		"");   //부서								 
			ht23.put("CD_CC",			"");   //코스트센터		
			ht23.put("CD_PJT",			"");   //프로젝트코드		
			ht23.put("CD_CARD",		"");   //신용카드		 	
			ht23.put("CD_EMPLOY",		"");   //사원									 		 
			ht23.put("NO_DEPOSIT",	"");  //예적금계좌
			ht23.put("CD_BANK",		"");  //금융기관	
			ht23.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht23.put("AM_TAXSTD",	"");  //과세표준액
			ht23.put("AM_ADDTAX",	"" );	 //세액
			ht23.put("TP_TAX",	"");  //과세(매출) :11
			ht23.put("NO_COMPANY",	""); //사업자등록번호
					
			ht23.put("NM_NOTE", doc_cont);  // 적요	
										
			vt_auto.add(ht23);  // 차량대금
		}	
 
 	
 			 //선납금이 없는 경우는 
 	 	if ( amt_25900 < 0 ) {
 	 		
			doc_cont = "매입옵션 차량구입대금" + "-" + car_no + " " + firm_nm;
				
			line++;
				 				   		
	   		Hashtable ht23 = new Hashtable();
	   		
	   		ht23.put("WRITE_DATE", 	real_date); //row_id							
			ht23.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht23.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht23.put("CD_PC",  	node_code);  //회계단위
			ht23.put("CD_WDEPT",  dept_code);  //부서
			ht23.put("NO_DOCU",  	"");  //미결은 '0' 
			ht23.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht23.put("CD_COMPANY",  "1000");  
			ht23.put("ID_WRITE", insert_id);   
			ht23.put("CD_DOCU",  "11");  
			
			ht23.put("DT_ACCT", 	real_date); 
			ht23.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht23.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
			ht23.put("CD_ACCT",  	"25900");  //선수금
			ht23.put("AMT",    String.valueOf( amt_25900 * (-1) ));				
			ht23.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht23.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht23.put("DT_START",  real_date); 	//발생일자										 
			ht23.put("CD_BIZAREA",		"");   //귀속사업장	
			ht23.put("CD_DEPT",		"");   //부서								 
			ht23.put("CD_CC",			"");   //코스트센터		
			ht23.put("CD_PJT",			"");   //프로젝트코드		
			ht23.put("CD_CARD",		"");   //신용카드		 	
			ht23.put("CD_EMPLOY",		"");   //사원									 		 
			ht23.put("NO_DEPOSIT",	"");  //예적금계좌
			ht23.put("CD_BANK",		"");  //금융기관	
			ht23.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht23.put("AM_TAXSTD",	"");  //과세표준액
			ht23.put("AM_ADDTAX",	"" );	 //세액
			ht23.put("TP_TAX",	"");  //과세(매출) :11
			ht23.put("NO_COMPANY",	""); //사업자등록번호
					
			ht23.put("NM_NOTE", doc_cont);  // 적요	
		
			vt_auto.add(ht23);  // 차량대금
		}	 
  } 		
		  
		  
  //매입옵션 등록비용
  if ( AddUtil.parseDigit(request.getParameter("sui_d_amt"))  > 0 ) {
 	
	    doc_cont = "매입옵션 차량등록비용" + "-" + car_no + " " + firm_nm;
	
		line++;
			 				   		
   		Hashtable ht23_1 = new Hashtable();
   		
   		ht23_1.put("WRITE_DATE", 	real_date); //row_id							
		ht23_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht23_1.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht23_1.put("CD_PC",  	node_code);  //회계단위
		ht23_1.put("CD_WDEPT",  dept_code);  //부서
		ht23_1.put("NO_DOCU",  	"");  //미결은 '0' 
		ht23_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht23_1.put("CD_COMPANY",  "1000");  
		ht23_1.put("ID_WRITE", insert_id);   
		ht23_1.put("CD_DOCU",  "11");  
		
		ht23_1.put("DT_ACCT", 	real_date); 
		ht23_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht23_1.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
		ht23_1.put("CD_ACCT",  	"25700");  //가수금
		ht23_1.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("sui_d_amt"))) );							
		ht23_1.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht23_1.put("CD_PARTNER",	"000131"); //거래처    - A06
									
		ht23_1.put("DT_START",  ""); 	//발생일자										 
		ht23_1.put("CD_BIZAREA",		"");   //귀속사업장	
		ht23_1.put("CD_DEPT",		"");   //부서								 
		ht23_1.put("CD_CC",			"");   //코스트센터		
		ht23_1.put("CD_PJT",			"");   //프로젝트코드		
		ht23_1.put("CD_CARD",		"");   //신용카드		 	
		ht23_1.put("CD_EMPLOY",		"");   //사원									 		 
		ht23_1.put("NO_DEPOSIT",	"");  //예적금계좌
		ht23_1.put("CD_BANK",		"");  //금융기관	
		ht23_1.put("NO_ITEM",		"");  //item	  	 
		
			// 부가세관련
		ht23_1.put("AM_TAXSTD",	"");  //과세표준액
		ht23_1.put("AM_ADDTAX",	"" );	 //세액
		ht23_1.put("TP_TAX",	"");  //과세(매출) :11
		ht23_1.put("NO_COMPANY",	""); //사업자등록번호
				
		ht23_1.put("NM_NOTE", doc_cont);  // 적요	
							
		vt_auto.add(ht23_1);  // 차량등록비용
  } 		
		
  //기타 차액은 잡이익으로 일단///
     //고객에게 돌려줄 금액 : 		
 // opt_ip_amt =   AddUtil.parseDigit(request.getParameter("opt_ip_amt1"))  + AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) - AddUtil.parseDigit(request.getParameter("fdft_amt2")) - AddUtil.parseDigit(request.getParameter("opt_amt"))  - AddUtil.parseDigit(request.getParameter("fdft_amt1_2")) - AddUtil.parseDigit(request.getParameter("sui_d_amt")) ;
  
   opt_ip_amt =   AddUtil.parseDigit(request.getParameter("opt_ip_amt1"))  + AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) - AddUtil.parseDigit(request.getParameter("fdft_amt2")) - AddUtil.parseDigit(request.getParameter("opt_amt"))  -  AddUtil.parseDigit(request.getParameter("sui_d_amt")) ;
    
   System.out.println("매입옵션 차액 =" +opt_ip_amt);
    
   if ( ext_st.equals("1") ) { //고객환불
     	if ( opt_ip_amt > 0 ) {  //잡이익
    	
    	    doc_cont = "매입옵션 과입금분 고객환불" + "-" + car_no + " " + firm_nm;
		
			line++;
				 				   		
	   		Hashtable ht27 = new Hashtable();
	   		
	   		ht27.put("WRITE_DATE", 	real_date); //row_id							
			ht27.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht27.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht27.put("CD_PC",  	node_code);  //회계단위
			ht27.put("CD_WDEPT",  dept_code);  //부서
			ht27.put("NO_DOCU",  	"");  //미결은 '0' 
			ht27.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht27.put("CD_COMPANY",  "1000");  
			ht27.put("ID_WRITE", insert_id);   
			ht27.put("CD_DOCU",  "11");  
			
			ht27.put("DT_ACCT", 	real_date); 
			ht27.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht27.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			ht27.put("CD_ACCT",   	"25300");  //미지급금
			ht27.put("AMT",    	String.valueOf( opt_ip_amt ) );						
			ht27.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht27.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht27.put("DT_START",  "");  	//발생일자										 
			ht27.put("CD_BIZAREA",		"");   //귀속사업장	
			ht27.put("CD_DEPT",		"");   //부서								 
			ht27.put("CD_CC",			"");   //코스트센터		
			ht27.put("CD_PJT",			"");   //프로젝트코드		
			ht27.put("CD_CARD",		"");   //신용카드		 	
			ht27.put("CD_EMPLOY",		"");   //사원									 		 
			ht27.put("NO_DEPOSIT",	"");  //예적금계좌
			ht27.put("CD_BANK",		"");  //금융기관	
			ht27.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht27.put("AM_TAXSTD",	"");  //과세표준액
			ht27.put("AM_ADDTAX",	"" );	 //세액
			ht27.put("TP_TAX",	"");  //과세(매출) :11
			ht27.put("NO_COMPANY",	""); //사업자등록번호
					
			ht27.put("NM_NOTE", doc_cont);  // 적요	
												
			vt_auto.add(ht27);  // 환불금
	  }		
  } else {	  
	  if ( opt_ip_amt > 0 ) {  //잡이익
	   	
	 	    doc_cont = "매입옵션 차량구입대금" + "-" + car_no + " " + firm_nm;
		
			line++;
				 				   		
	   		Hashtable ht24 = new Hashtable();
	   		
	   		ht24.put("WRITE_DATE", 	real_date); //row_id							
			ht24.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht24.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht24.put("CD_PC",  	node_code);  //회계단위
			ht24.put("CD_WDEPT",  dept_code);  //부서
			ht24.put("NO_DOCU",  	"");  //미결은 '0' 
			ht24.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht24.put("CD_COMPANY",  "1000");  
			ht24.put("ID_WRITE", insert_id);   
			ht24.put("CD_DOCU",  "11");  
			
			ht24.put("DT_ACCT", 	real_date); 
			ht24.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht24.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			ht24.put("CD_ACCT",   		"93000");  //잡이익
			ht24.put("AMT",    		String.valueOf( opt_ip_amt ) );					
			ht24.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht24.put("CD_PARTNER",	"000131");//거래처    - A06
										
			ht24.put("DT_START",  "");  	//발생일자										 
			ht24.put("CD_BIZAREA",		"");   //귀속사업장	
			ht24.put("CD_DEPT",		"");   //부서								 
			ht24.put("CD_CC",			"");   //코스트센터		
			ht24.put("CD_PJT",			"");   //프로젝트코드		
			ht24.put("CD_CARD",		"");   //신용카드		 	
			ht24.put("CD_EMPLOY",		"");   //사원									 		 
			ht24.put("NO_DEPOSIT",	"");  //예적금계좌
			ht24.put("CD_BANK",		"");  //금융기관	
			ht24.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht24.put("AM_TAXSTD",	"");  //과세표준액
			ht24.put("AM_ADDTAX",	"" );	 //세액
			ht24.put("TP_TAX",	"");  //과세(매출) :11
			ht24.put("NO_COMPANY",	""); //사업자등록번호
					
			ht24.put("NM_NOTE", doc_cont);  // 적요	
				
			vt_auto.add(ht24);  // 차량대금
	  } 		
  
	   if ( opt_ip_amt < 0 ) {  //잡손실
	 	 			
			doc_cont = "매입옵션 차량구입대금" + "-" + car_no + " " + firm_nm;
				
			line++;
				 				   		
	   		Hashtable ht25 = new Hashtable();
	   		
	   		ht25.put("WRITE_DATE", 	real_date); //row_id							
			ht25.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht25.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht25.put("CD_PC",  	node_code);  //회계단위
			ht25.put("CD_WDEPT",  dept_code);  //부서
			ht25.put("NO_DOCU",  	"");  //미결은 '0' 
			ht25.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht25.put("CD_COMPANY",  "1000");  
			ht25.put("ID_WRITE", insert_id);   
			ht25.put("CD_DOCU",  "11");  
			
			ht25.put("DT_ACCT", 	real_date); 
			ht25.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht25.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
			ht25.put("CD_ACCT",   	"96000");  //잡손실
			ht25.put("AMT",    		String.valueOf( opt_ip_amt*(-1) ) );	;					
			ht25.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht25.put("CD_PARTNER",	"000131");//거래처    - A06
										
			ht25.put("DT_START",  "");  	//발생일자										 
			ht25.put("CD_BIZAREA",		"");   //귀속사업장	
			ht25.put("CD_DEPT",		"");   //부서								 
			ht25.put("CD_CC",			"");   //코스트센터		
			ht25.put("CD_PJT",			"");   //프로젝트코드		
			ht25.put("CD_CARD",		"");   //신용카드		 	
			ht25.put("CD_EMPLOY",		"");   //사원									 		 
			ht25.put("NO_DEPOSIT",	"");  //예적금계좌
			ht25.put("CD_BANK",		"");  //금융기관	
			ht25.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht25.put("AM_TAXSTD",	"");  //과세표준액
			ht25.put("AM_ADDTAX",	"" );	 //세액
			ht25.put("TP_TAX",	"");  //과세(매출) :11
			ht25.put("NO_COMPANY",	""); //사업자등록번호
					
			ht25.put("NM_NOTE", doc_cont);  // 적요	
									
			vt_auto.add(ht25);  // 차량대금
	  } 			
  } 
	
  if ( vt_m_auto.size() > 0){
	row_id_t = neoe_db.insertSetAutoDocu(real_date, vt_m_auto);
  }	
    
  if ( vt_auto.size() > 0){
	row_id = neoe_db.insertSetAutoDocu(real_date, vt_auto);
  }
  
      //회계처리 
//  if(!ac_db.updateClsEtcAuto(rent_mng_id, rent_l_cd, "1")) flag += 1;  

   //매입옵션 고객환불인 경우 scd_ext에 등록
    int cls_ma_cnt = 0;  
  
    if ( ext_st.equals("1")  &&  opt_ip_amt > 0 ) {  //매입옵션 고객환불
	  		cls_ma_cnt = ac_db.getScdExtClsCnt(rent_mng_id, rent_l_cd);
	  		if ( cls_ma_cnt < 1 ) {
	  			if(!ac_db.insertScdExtCls8(rent_mng_id, rent_l_cd, opt_ip_amt, real_date,  user_id)) flag += 1;  
	  		} else {
	  			if(!ac_db.updateScdExtCls8(rent_mng_id, rent_l_cd, opt_ip_amt, real_date,  user_id)) flag += 1;  
	  		}	  		
	}	
	  		  	
	  	
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cont_st' value=''>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 저장 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				
	fm.s_kd.value = '2';
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action ='<%=from_page%>';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
