<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.credit.*, acar.client.*, acar.fee.*,  acar.user_mng.*, acar.cls.*,  acar.cont.*, tax.*, acar.bill_mng.*"%>
<%@ page import="acar.asset.*"%>
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
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	String firm_nm = request.getParameter("firm_nm")==null?"":	request.getParameter("firm_nm");
	 	
	int	flag = 0;
	int	count = 0;
	String s_flag = "";
	
	String from_page 	= "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
				
	AssetDatabase ass_db = AssetDatabase.getInstance();
	
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
	
	//매입옵션 행사자 
	String m_client_id 	= request.getParameter("m_client_id")==null?"":request.getParameter("m_client_id");

	String sui_nm 	= request.getParameter("sui_nm")==null?"":request.getParameter("sui_nm");
	String ssn 	= request.getParameter("ssn")==null?"":request.getParameter("ssn");
	String enp_no 	= request.getParameter("enp_no")==null?"":request.getParameter("enp_no");
//	String bus_cdt 	= request.getParameter("bus_cdt")==null?"":request.getParameter("bus_cdt"); //업태
//	String bus_itm 	= request.getParameter("bus_itm")==null?"":request.getParameter("bus_itm"); //업종
		
   //해지정보					
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
	//해지사유
	cls_st = "8";
	 
	from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	
	//선수금 입금
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
		//매입옵션일 (sui)
	String m_sui_dt = request.getParameter("m_sui_dt")==null?"":request.getParameter("m_sui_dt");
		
	String real_date = "";
	
	real_date = cls.getCls_dt();	
	
	
	if ( !m_sui_dt.equals("") ) {
		 real_date = m_sui_dt;	
	} else {
		if ( !opt_ip_dt1.equals("") ) {	    	    	
				if ( !cls.getCls_dt().equals(opt_ip_dt1) ) {
				//   real_date = opt_ip_dt1;
				    real_date = cls.getCls_dt();
				} else {
				   real_date = cls.getCls_dt();
				}		   		
		}		
	}
	
				
	//계약:고객관련
	ContBaseBean base 	= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	client_id = base.getClient_id();
	
	if(base.getTax_type().equals("2")){//지점
		site_id = base.getR_site();
	}else{
		site_id = "";
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
	String i_ven_code	= client.getVen_code(); //계약서상의 거래처
		
	if(base.getTax_type().equals("2")){//지점	
		if(! base.getR_site().equals("")){
			//거래처지점정보
			ClientSiteBean site = al_db.getClientSite(client_id, site_id);
			
			i_ven_code = site.getVen_code();
			if(!i_ven_code.equals("")){
							i_enp_no 		= site.getEnp_no();
							i_addr 			= site.getAddr();
							i_sta 			= site.getBus_cdt();
							i_item 			= site.getBus_itm();
							i_ven_code		= site.getVen_code();
							i_ssn 		    = "";								
			}	
		}
	}
		
	if(i_ven_code.equals("")) i_ven_code = neoe_db.getVenCode(i_ssn, i_enp_no);
		
	Hashtable vendor = neoe_db.getVendorCase(i_ven_code);
	
	//실제  매입옵션 
	ClientBean mclient = al_db.getNewClient(m_client_id);
	
	String m_ven_type = "";
	String m_s_idno = "";
	
	String m_client_st = mclient.getClient_st(); //2:개인
	
	String foreigner=  mclient.getNationality();
	
	String m_i_ssn = "";
	m_i_ssn = mclient.getSsn1() + mclient.getSsn2();
		
	String m_i_enp_no = mclient.getEnp_no1() + mclient.getEnp_no2()+ mclient.getEnp_no3();
	if(mclient.getEnp_no1().equals("")) m_i_enp_no = mclient.getSsn1() + mclient.getSsn2();
		
	String m_i_addr 		= mclient.getO_addr();
	String m_i_sta 		= mclient.getBus_cdt();
	String m_i_item 		= mclient.getBus_itm();
	String m_i_ven_code	= mclient.getVen_code(); //매입옵션
		
	if(m_i_ven_code.equals("")) m_i_ven_code = neoe_db.getVenCode(m_i_ssn, m_i_enp_no);
		
	Hashtable mvendor = neoe_db.getVendorCase(m_i_ven_code);
	
	//네오엠 세금계산서
	
	if(m_client_st.equals("2")){
			m_ven_type = "1";
			m_s_idno   =	m_i_ssn;
	}else{
			m_ven_type = "0";
			m_s_idno   =	m_i_enp_no;
	}	
				
	//세금계산서 발행관련 - 매각계산서 발행 유무
	int sold_cnt = 0;
	
	sold_cnt  = ac_db.getCarSoldCnt(car_mng_id);
//	System.out.println("매입옵션 사전 계산서 발행 - " + sold_cnt);
		
	String tax_no = "";
	int data_no =0;
	String row_id = "";
  	int tax_cnt = 0;
  	
  	int line =0;
	int amt_10800 = 0;
	int jangbu_amt = 0;
	String doc_cont = "";
	
	//자산 매각 등록
	s_flag =  ass_db.call_sp_insert_assetmove2_off(real_date.substring(0,4), real_date.substring(5,7), car_mng_id, user_id );
	System.out.println("자산매각 등록=" + car_no + "|"+ s_flag);
		
	//자산 정보	   
	Hashtable h_asset = ass_db.getAssetSaleList(car_mng_id);
		
	String  car_use =  String.valueOf(h_asset.get("CAR_USE")) ;   // 1:리스, 2:렌트		 
	int  sale_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SALE_AMT")))  ;   //매각액		 
	String  assch_date =  String.valueOf(h_asset.get("ASSCH_DATE")) ;   //매각일
	    int  get_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GET_AMT")))  ;   //기초가
	    int  book_dr =  AddUtil.parseInt(String.valueOf(h_asset.get("BOOK_DR")))  ;   //당기중가
	    int  jun_reser =  AddUtil.parseInt(String.valueOf(h_asset.get("JUN_RESER")))  ;   //전년누계상각액
	    int  dep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("DEP_AMT")))  ;   //당기상각액
	    int  gdep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GDEP_AMT")))  ;   //구매보조금 
	    
	    int  sup_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SUP_AMT")))  ;   //공급가
	    
	    jangbu_amt =    get_amt  + book_dr   - jun_reser - dep_amt - gdep_amt  ;  //장부가액  
	       
	    amt_10800 = sale_amt + 	jun_reser + dep_amt  +  gdep_amt - get_amt  - book_dr - ( sale_amt - sup_amt); 		
  	
  	String item_id = "";
  	String reg_code = "";	
//  	String ven_code = "";

	//사전에 매각계산서가 발행이 안된경우 처리
        if (     sold_cnt  < 1) {

	    //자산매각 세금계산서 
	//	tax_no = IssueDb.getTaxNoNext(real_date);
			
		//사용할 item_id 가져오기
			
		//[1단계] 거래명세서 리스트 생성		
		TaxItemListBean til_bean = new TaxItemListBean();			
//		til_bean.setItem_id(item_id);
		til_bean.setItem_seq(1);
		til_bean.setItem_g("차량매각대금");
		til_bean.setItem_car_no(car_no);
		til_bean.setItem_car_nm(car_nm);
		til_bean.setItem_supply(sup_amt);
		til_bean.setItem_value(sale_amt - sup_amt );
		til_bean.setRent_l_cd(rent_l_cd);
		til_bean.setCar_mng_id(car_mng_id);
	 	til_bean.setGubun("6");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
		til_bean.setReg_id(user_id);
	//	til_bean.setReg_code(reg_code);
				
		til_bean.setCar_use(base.getCar_st()); //전자세금계산서 의무시행 관련 변경 - 1:렌트 2:리스
		til_bean.setItem_dt(real_date);  //전자세금계산서 의무시행 관련 변경	
			
		//사용할 item_id 가져오기
		item_id = IssueDb.getItemIdNext(real_date);
			//	out.println("item_id="+item_id+"<br><br>");
		  		
				//실행코드 가져오기
		reg_code  = Long.toString(System.currentTimeMillis());
			//	out.println("실행코드="+reg_code+"<br>");
		
		til_bean.setItem_id(item_id);
		til_bean.setReg_code(reg_code);
		
		if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
			    		
		//[2단계] 거래명세서 생성
		Vector vt = IssueDb.getTaxItemListSusi(reg_code);
		int vt_size = vt.size();
	//	out.println("거래명세서 생성="+vt_size+"<br><br>");
		
		for(int j=0;j < vt_size;j++){
			Hashtable ht = (Hashtable)vt.elementAt(j);
			TaxItemBean ti_bean = new TaxItemBean();
			ti_bean.setClient_id(m_client_id);
			ti_bean.setSeq("");
			ti_bean.setItem_dt(real_date);
			ti_bean.setTax_id("");
			ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
			ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"원");
			ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
			ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
			
			if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
		}
	
		//[3단계] 세금계산서 생성		
		Vector vt2 = IssueDb.getTaxItemSusi(reg_code);
				    	
		int vt_size2 = vt2.size();
		out.println("세금계산서 생성="+vt_size2+"<br><br>");
		
		if (tax_branch.equals("")) tax_branch = br_id;
		
		for(int i=0;i < vt_size2;i++){
			Hashtable ht_t = (Hashtable)vt2.elementAt(i);
					
			tax.TaxBean t_bean = new tax.TaxBean();			
					
			t_bean.setClient_id(m_client_id);  	
			t_bean.setTax_dt(real_date);
			
			t_bean.setUnity_chk("0");//통합여부0=개별,1=통합
			t_bean.setRent_l_cd(rent_l_cd);
			t_bean.setFee_tm("");
			t_bean.setCar_mng_id(car_mng_id);
			t_bean.setBranch_g(tax_branch);
			t_bean.setTax_g("차량매각대금");
			t_bean.setTax_supply(sup_amt);
			t_bean.setTax_value(sale_amt - sup_amt);
			t_bean.setTax_id(m_client_id);
			t_bean.setItem_id(item_id);
			t_bean.setTax_bigo("차량매각 - " + car_no );			
			
				//20090701부터 사업자단위과세			
			if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
				//종사업장
				Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
				t_bean.setTax_bigo(" "+t_bean.getTax_bigo());
	//				t_bean.setTax_bigo(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
				t_bean.setBranch_g("S1");
				t_bean.setBranch_g2(tax_branch);
				t_bean.setTaxregno(String.valueOf(br2.get("TAXREGNO")));	 //전자세금계산서 의무시행 관련 변경
			} 
			
			t_bean.setSeq("");  
		//	t_bean.setTax_no(tax_no);
			t_bean.setCar_no(car_no);
			t_bean.setCar_nm(car_nm);
			t_bean.setTax_st("O");
			t_bean.setTax_type("1");  //무조건 본사
			t_bean.setReg_id(user_id);
			t_bean.setGubun("6");
			t_bean.setPubForm("R");
			    					
			//공급받는자정보 : 20090608 작업
			t_bean.setRecTel			(String.valueOf(ht_t.get("RECTEL")));
			t_bean.setRecCoRegNo		(String.valueOf(ht_t.get("RECCOREGNO")));
			t_bean.setRecCoName			(String.valueOf(ht_t.get("RECCONAME2")));
			t_bean.setRecCoCeo			(String.valueOf(ht_t.get("RECCOCEO2")));
			t_bean.setRecCoAddr			(String.valueOf(ht_t.get("RECCOADDR")));
			t_bean.setRecCoBizType		(String.valueOf(ht_t.get("RECCOBIZTYPE2")));
			t_bean.setRecCoBizSub		(String.valueOf(ht_t.get("RECCOBIZSUB2"))); 
				
			
			//전자세금계산서 의무시행 관련 변경	
			//공급받는자가 개인일때와 법인일의 처리
			if(String.valueOf(ht_t.get("RECCOREGNO")).length() == 13){
				t_bean.setTax_bigo	(t_bean.getTax_bigo()+"-"+String.valueOf(ht_t.get("RECCOREGNO")));
				t_bean.setRecCoSsn	(String.valueOf(ht_t.get("RECCOREGNO")));
				t_bean.setReccoregnotype("02");//사업자구분-주민등록번호
			}else {
				t_bean.setReccoregnotype("01");//사업자구분-사업자등록번호
			}						
			
			//--외국인
			 if(foreigner.equals("2") ) {
			      		 t_bean.setReccoregnotype("03");     //외국인
			                    t_bean.setRecCoRegNo("9999999999999");	
			                    t_bean.setTax_bigo(t_bean.getTax_bigo() +" "+  String.valueOf(ht_t.get("RECCOREGNO")) );	       
			  };
			
			  //insert 직전에 계산값 구하기  
			tax_no = IssueDb.getTaxNoNext(real_date);
			t_bean.setTax_no(tax_no);
			 
			if(!IssueDb.insertTax(t_bean)) flag += 1;  
			
			if(!IssueDb.updateTaxAutodocu(tax_no)) flag += 1;
		}
		    		
		//전자세금계산서 발행
		   		
		//본사-영업소
	//	Hashtable br1 = c_db.getBranch("S1");
	//	String resseq = IssueDb.getResSeqNext();
	//	if(!IssueDb.insertSaleEBillCase(resseq, tax_no, String.valueOf(br1.get("BR_ENT_NO")))) flag += 1;
	
		String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
		if (d_flag1.equals("1"))		flag += 1;
		
	}
	
	
	//자동전표처리용
	Vector vt_auto = new Vector();

 //-----------------선수금 금액 관련 ------------------------	
	
	int opt_ip_amt = 0;
	
//	opt_ip_amt =   AddUtil.parseDigit(request.getParameter("opt_ip_amt1"))  + AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) - AddUtil.parseDigit(request.getParameter("fdft_amt2")) - AddUtil.parseDigit(request.getParameter("opt_amt"))  -  AddUtil.parseDigit(request.getParameter("sui_d_amt")) ;
  		
	  
 	//선수금 - 매입옵션금액 	

	doc_cont = "매입옵션 선수금" + "-" + car_no + " " + firm_nm;
 		
	line++;
				
	Hashtable ht2_1 = new Hashtable();
		
	ht2_1.put("WRITE_DATE", 	real_date);//row_id	
	ht2_1.put("ROW_NO",  	String.valueOf(line)); //row_no		
	ht2_1.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
	ht2_1.put("CD_PC",  	node_code);  //회계단위*
	ht2_1.put("CD_WDEPT",  dept_code);  //부서
	ht2_1.put("NO_DOCU",  	"");  //row_id와 같게
	ht2_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht2_1.put("CD_COMPANY",  "1000");  
	ht2_1.put("ID_WRITE", insert_id);   
	ht2_1.put("CD_DOCU",  "11");  
	
	ht2_1.put("DT_ACCT",real_date); 
	ht2_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
	ht2_1.put("TP_DRCR",  "1");   // 대변:2 , 차변:1
	ht2_1.put("CD_ACCT",  "25900");   //선수금
	ht2_1.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("opt_amt")) ));									
	ht2_1.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체	
	ht2_1.put("CD_PARTNER",	i_ven_code); //거래처    - A06
		
	ht2_1.put("DT_START", real_date) ;  	//발생일자			
	ht2_1.put("CD_BIZAREA",	"");   //귀속사업장	
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
	
	vt_auto.add(ht2_1);  
	 
   //-----------------자산 상각 관련 ------------------------
   		  
 // 리스 / 대여사업차량
 
	if (cls_st.equals("1") ) {
		 doc_cont = "계약만료 - " + car_no + " " + firm_nm;
	} else if (cls_st.equals("8") ) {
		 doc_cont = "매입옵션 - " + car_no + " " + firm_nm;
	} else {
		 doc_cont = "중도해지 - " + car_no + " " + firm_nm;
	} 
	
	line++;
	
	Hashtable ht3 = new Hashtable();
	
	ht3.put("WRITE_DATE", 		real_date);//row_id				
	ht3.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht3.put("NO_TAX",  	"*");  //부가세 이외는 *
	ht3.put("CD_PC",  	node_code);  //회계단위
	ht3.put("CD_WDEPT",  dept_code);  //부서
	ht3.put("NO_DOCU",  	"");  //미결은 '0' 
	ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht3.put("CD_COMPANY",  "1000");  
	ht3.put("ID_WRITE", insert_id);   
	ht3.put("CD_DOCU",  "11");  
	
	ht3.put("DT_ACCT", 	real_date);
	ht3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
	ht3.put("TP_DRCR",   "2");   // 대변:2 , 차변:1	
	
	if ( car_use.equals("2") ) { //렌트이면
		ht3.put("CD_ACCT",  	"21700");    //대여사업차량
	} else {
		ht3.put("CD_ACCT",  	"21900");  //리스사업차량
	}	
	
	ht3.put("AMT",   	String.valueOf( get_amt + book_dr )); //기초가액	
	ht3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
	ht3.put("CD_PARTNER",	"000131"); //거래처    - A06
							
	ht3.put("DT_START",  "");  	//발생일자										 
	ht3.put("CD_BIZAREA",		"");   //귀속사업장	
	ht3.put("CD_DEPT",		"");   //부서								 
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

	ht3.put("NM_NOTE", doc_cont);  // 적요				
	
	vt_auto.add(ht3);  // 대여/리스사업 차량
 
  //부가세 예수금
		
	line++;
	
	Hashtable ht4 = new Hashtable();
	
	ht4.put("WRITE_DATE", 	real_date); //row_id							
	ht4.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht4.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
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
	ht4.put("CD_ACCT",  	"25500");  //부가세예수금					
	ht4.put("AMT",   	String.valueOf( sale_amt - sup_amt) );							
	ht4.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
	ht4.put("CD_PARTNER",	m_i_ven_code);  //실제 매입옵션 거래처
								
	ht4.put("DT_START", real_date);  	//발생일자 - 부가세										 
	ht4.put("CD_BIZAREA",		"S101");   //귀속사업장	
	ht4.put("CD_DEPT",		"");   //부서								 
	ht4.put("CD_CC",			"");   //코스트센터		
	ht4.put("CD_PJT",			"");   //프로젝트코드		
	ht4.put("CD_CARD",		"");   //신용카드		 	
	ht4.put("CD_EMPLOY",		"");   //사원									 		 
	ht4.put("NO_DEPOSIT",	"");  //예적금계좌
	ht4.put("CD_BANK",		"");  //금융기관	
	ht4.put("NO_ITEM",		"");  //item	 	  	 
		
// 부가세관련
	ht4.put("AM_TAXSTD",		String.valueOf(sup_amt));
	ht4.put("AM_ADDTAX",	 	String.valueOf(sale_amt - sup_amt) );	 //매각액 - 공급가
	ht4.put("TP_TAX",	"11");  //과세(매출) :11
	if(m_ven_type.equals("1")){
		ht4.put("NO_COMPANY",   "8888888888"); //개인인 경우 사업자등록번호에 8888888888
	} else {
		ht4.put("NO_COMPANY",   m_s_idno); //사업자등록번호
	}								
	ht4.put("NM_NOTE", doc_cont);  // 적요	
							
	vt_auto.add(ht4);  // 부가세	
 	 	 
 	// 감가상각 누계액 - 리스/ 대여사업차량
 	if (cls_st.equals("1") ) {
		 doc_cont = "계약만료 감가상각누계액- " + car_no + " " + firm_nm;
	} else if (cls_st.equals("8") ) {
		 doc_cont = "매입옵션 감가상각누계액 - " + car_no + " " + firm_nm;
	} else {
		 doc_cont = "중도해지 감가상각누계액 - " + car_no + " " + firm_nm;
	} 
	
	line++;
	
	Hashtable ht6 = new Hashtable();
	
	ht6.put("WRITE_DATE", 		real_date);//row_id				
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
	ht6.put("TP_DRCR",   "1");   // 대변:2 , 차변:1	
	
	if ( car_use.equals("2") ) { //렌트이면
		ht6.put("CD_ACCT",  	"21800");    //대여사업차량 감가상각 누계액
	} else {
		ht6.put("CD_ACCT",  	"22000");  //리스사업차량 감가상각 누계액
	}	
	
	ht6.put("AMT",   String.valueOf( jun_reser + dep_amt ));
	ht6.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
	ht6.put("CD_PARTNER",	""); //거래처    - A06
							
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
				
	vt_auto.add(ht6);  // 감가상각 누계액
 
   //국가보조금이 있는 경우 - 친환경차에대해서
   
   	if ( gdep_amt  > 0 ) {
    	 
    		// 친환경차 보조금  - 리스/ 대여사업차량
	 	if (cls_st.equals("1") ) {
			 doc_cont = "계약만료 친환경차보조금 - " + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "매입옵션 친환경차보조금 - " + car_no + " " + firm_nm;
		} else {
			 doc_cont = "중도해지 친환경차보조금 - " + car_no + " " + firm_nm;
		} 
	 
	 	line++;
		
		Hashtable ht6_1 = new Hashtable();
		
		ht6_1.put("WRITE_DATE", 		real_date);//row_id				
		ht6_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht6_1.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht6_1.put("CD_PC",  	node_code);  //회계단위
		ht6_1.put("CD_WDEPT",  dept_code);  //부서
		ht6_1.put("NO_DOCU",  	"");  //미결은 '0' 
		ht6_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht6_1.put("CD_COMPANY",  "1000");  
		ht6_1.put("ID_WRITE", insert_id);   
		ht6_1.put("CD_DOCU",  "11");  
		
		ht6_1.put("DT_ACCT", 	real_date);
		ht6_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht6_1.put("TP_DRCR",   "1");   // 대변:2 , 차변:1	
		
	//	ht6_1.put("CD_ACCT",  	"21810");    //대여사업차량 국가보조금 
		//	 현재는 렌트밖에 없어서 계정이 하나 - 20170112 
		if ( car_use.equals("2") ) { //렌트이면
			ht6_1.put("CD_ACCT",  	"21810");    //대여사업차량 국가보조금 
		} else {
			ht6_1.put("CD_ACCT",  	"22010");  //리스사업차량 감가상각 누계액
		}	
			
		ht6_1.put("AMT",   String.valueOf( gdep_amt ));
		ht6_1.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
	    ht6_1.put("CD_PARTNER",	"000131"); //거래처    - A06
								
		ht6_1.put("DT_START",  "");  	//발생일자										 
		ht6_1.put("CD_BIZAREA",		"");   //귀속사업장	
		ht6_1.put("CD_DEPT",		"");   //부서								 
		ht6_1.put("CD_CC",			"");   //코스트센터		
		ht6_1.put("CD_PJT",			"");   //프로젝트코드		
		ht6_1.put("CD_CARD",		"");   //신용카드		 	
		ht6_1.put("CD_EMPLOY",		"");   //사원									 		 
		ht6_1.put("NO_DEPOSIT",	"");  //예적금계좌
		ht6_1.put("CD_BANK",		"");  //금융기관	
		ht6_1.put("NO_ITEM",		"");  //item	  
		
				// 부가세관련
		ht6_1.put("AM_TAXSTD",	"");  //과세표준액
		ht6_1.put("AM_ADDTAX",	"" );	 //세액
		ht6_1.put("TP_TAX",	"");  //과세(매출) :11
		ht6_1.put("NO_COMPANY",	""); //사업자등록번호	  	 
	
		ht6_1.put("NM_NOTE", doc_cont);  // 적요				
					
		vt_auto.add(ht6_1);  // 국가보조금 
	
	}
  
  	 	//처분이익 	
  /*
   	if ( amt_10800  > 0 ) {
	 // 대여/리스차량 처분이익  
	 	if (cls_st.equals("1") ) {
			 doc_cont = "계약만료 처분이익 - " + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "매입옵션 처분이익 - " + car_no + " " + firm_nm;
		} else {
			 doc_cont = "중도해지 처분이익 - " + car_no + " " + firm_nm;
		} 
		
		line++;
		
		Hashtable ht7 = new Hashtable();
							
		ht7.put("WRITE_DATE", 		real_date);//row_id				
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
		ht7.put("TP_DRCR",   "2");   // 대변:2 , 차변:1	
		
		if ( car_use.equals("2") ) { //렌트이면
			ht7.put("CD_ACCT",  	"41300");    //대여사업차량 처분이익
		} else {
			ht7.put("CD_ACCT",  	"41500");  //리스사업차량 처분이익
		}	
		
		ht7.put("AMT",   String.valueOf( amt_10800 ));		 	
		ht7.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht7.put("CD_PARTNER",	"000131"); //거래처    - A06
								
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
		
		vt_auto.add(ht7);  // 처분이익 / 손실
  }
 
  	 //처분손실 	
   	if ( amt_10800 < 0 ) {
	 // 대여/리스차량 손실
	 	if (cls_st.equals("1") ) {
			 doc_cont = "계약만료 처분손실 - " + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "매입옵션 처분손실 - " + car_no + " " + firm_nm;
		} else {
			 doc_cont = "중도해지 처분손실 - " + car_no + " " + firm_nm;
		} 
		
		line++;
		
		Hashtable ht8 = new Hashtable();
						
		ht8.put("WRITE_DATE", 		real_date);//row_id				
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
		ht8.put("TP_DRCR",   "1");   // 대변:2 , 차변:1	
		
		if (car_use.equals("2") ) { //렌트이면
			ht8.put("CD_ACCT",  	"45300");   //대여사업차량 처분손실
		} else {
			ht8.put("CD_ACCT",  	"45400");  //리스사업차량 처분손실
		}	
		
		ht8.put("AMT",      String.valueOf( amt_10800 * (-1) ));	
		ht8.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
		ht8.put("CD_PARTNER",	"000131"); //거래처    - A06
								
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
						
		vt_auto.add(ht8);  // 처분이익 / 손실
  }  
  */
  
        // 대여/리스차량  매각액   
	line++;
	 doc_cont = "매입옵션 처분수익  - " + car_no + " " + firm_nm;
		 
	Hashtable ht7 = new Hashtable();
	
	ht7.put("WRITE_DATE", 		real_date);//row_id				
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
	ht7.put("TP_DRCR",   "2");   // 대변:2 , 차변:1	
	
	if (car_use.equals("2") ) { //렌트이면
		ht7.put("CD_ACCT",  	"41310");    //대여사업차량
	} else {
		ht7.put("CD_ACCT",  	"41510");  //리스사업차량
	}	
	
	ht7.put("AMT",   String.valueOf( sup_amt ));		 	//매출액   
	ht7.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
	ht7.put("CD_PARTNER",	"000131"); //거래처    - A06
							
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
		
	vt_auto.add(ht7);  // 매출액 
	
		
	// 장부가
	line++;
	 doc_cont = "매입옵션 처분원가  - " + car_no + " " + firm_nm;
	
	Hashtable ht8 = new Hashtable();
		
	ht8.put("WRITE_DATE", 		real_date);//row_id				
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
	ht8.put("TP_DRCR",   "1");   // 대변:2 , 차변:1	
	
	if (car_use.equals("2") ) { //렌트이면
		ht8.put("CD_ACCT",  	"45310");    //대여사업차량
	} else {
		ht8.put("CD_ACCT",  	"45410");  //리스사업차량
	}	
		
	ht8.put("AMT",   String.valueOf( jangbu_amt ));		
	ht8.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
	ht8.put("CD_PARTNER",	"000131"); //거래처    - A06
							
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
			
	vt_auto.add(ht8);  // 처분이익 / 손실
	
  if ( vt_auto.size() > 0){
	row_id = neoe_db.insertSetAutoDocu(real_date, vt_auto);
  }
      
    //회계처리 
  if(!ac_db.updateClsEtcAuto(rent_mng_id, rent_l_cd, "Y")) flag += 1;  
  
  // cls_cont cls_dt를 매입옵션일로 수정
  
     //회계처리 
  if(!ac_db.updateClsContDt(rent_mng_id, rent_l_cd, real_date )) flag += 1;  

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
    fm.action ='<%=from_page%>';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
