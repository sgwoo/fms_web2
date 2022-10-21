<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*, acar.common.*, acar.bill_mng.*,  acar.client.*, tax.*,   acar.user_mng.*"%>
<jsp:useBean id="su_bean" class="acar.offls_actn.Offls_sui_etcBean" scope="page"/>
<jsp:useBean id="bean" class="acar.asset.AssetMoveBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String asset_code = request.getParameter("asset_code")==null?"":request.getParameter("asset_code");	
	
	String assch_date= request.getParameter("assch_date")==null?"":request.getParameter("assch_date");
	String assch_type= request.getParameter("assch_type")==null?"":request.getParameter("assch_type");
	String assch_rmk= request.getParameter("assch_rmk")==null?"":request.getParameter("assch_rmk");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String bill_doc_yn 	= request.getParameter("bill_doc_yn")==null?"":request.getParameter("bill_doc_yn");
			
	int s_cnt = 0;
	String s_flag = "";
	int	flag2 = 0;
	int	flag3 = 0;

	AssetDatabase as_db = AssetDatabase.getInstance();
	
	//전표관련
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
					
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	String reg_ym = AddUtil.getDate(5);
	
	//네오엠
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
	bean.setAsset_code	(asset_code);
	bean.setAssch_date	(assch_date);
	bean.setAssch_type	(assch_type);
	bean.setAssch_rmk	(assch_rmk);
	bean.setCap_amt	(0);//
	bean.setSale_quant	(1); //
	bean.setSale_amt	(request.getParameter("sale_amt")==null?0:AddUtil.parseDigit(request.getParameter("sale_amt"))); //매각/폐기 금액
	bean.setSh_car_amt	(request.getParameter("sh_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("sh_car_amt"))); //매각/폐기시 잔가
	bean.setS_sup_amt	(request.getParameter("s_sup_amt")==null?0:AddUtil.parseDigit(request.getParameter("s_sup_amt"))); //매각/폐기시공급가
	bean.setClient_id2	(client_id); //공급받는자 
				
	s_cnt = as_db.insertAssetMove(bean);
	System.out.println("매각순번=" + s_cnt); 
		
	// 매각/폐기인 경우  매각/폐기 처리 
	if (assch_type.equals("3")) { 
	
	 	 s_flag =  as_db.call_sp_insert_assetmove1(asset_code, s_cnt, user_id );
		 System.out.println(asset_code + "|" + assch_date + "|" + assch_type  ); 
		 
		//폐차인경우 등록일 별도 수정	- 폐차월과 등록웡이 틀리면   assch_date.substr(0,6) 
		 if ( assch_rmk.equals("폐차") && !assch_date.substring(0,6).equals(reg_ym) ) {
			 flag3 = as_db.updateAssetMove(asset_code);
		 }	
	} 
	
	//자동전표처리용
	Vector vt_auto = new Vector();
	
	int opt_ip_amt = 0;
	int line =0;
	String doc_cont = "";
	int amt_10800 = 0;

	String tax_no = "";
	String row_id = "";	
	String ven_code2 = "";
	String client_st = "";
	
	String ven_type = "";
	String s_idno = "";
	
	AssetMaBean ass_bean =  as_db.getAssetMa(asset_code);
	
	String car_mng_id = ass_bean.getCar_mng_id();
	
	//자산 정보	   
	Hashtable h_asset = as_db.getAssetSaleList(car_mng_id);
		
	String  car_use =  String.valueOf(h_asset.get("CAR_USE")) ;   // 1:리스, 2:렌트		 		 
	int  sale_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SALE_AMT")))  ;   //매각액		 
	int  get_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GET_AMT")))  ;   //기초가
	int  book_dr =  AddUtil.parseInt(String.valueOf(h_asset.get("BOOK_DR")))  ;   //당기중가
	int  jun_reser =  AddUtil.parseInt(String.valueOf(h_asset.get("JUN_RESER")))  ;   //전년누계상각액
	int  dep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("DEP_AMT")))  ;   //당기상각액
	int  gdep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GDEP_AMT")))  ;   //국가보조금 
	int  sup_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SUP_AMT")))  ;   //공급가 (폐차는 부가세는 없다.)
   int jangbu_amt = 0;
   
	if ( !client_id.equals("") && bill_doc_yn.equals("1")  ) {	    
	 	amt_10800 = sale_amt + 	jun_reser + dep_amt + gdep_amt  - get_amt  - book_dr - ( sale_amt - sup_amt); 		
 	} else {
 	      amt_10800 = sale_amt + jun_reser + dep_amt  + gdep_amt - get_amt  - book_dr ; 	      	
 	}
 	
   jangbu_amt = 	get_amt  +  book_dr - jun_reser - dep_amt  - gdep_amt;
         
	if ( !client_id.equals("") && bill_doc_yn.equals("1")  ) {
	//자동차매매상
		ClientBean client = al_db.getNewClient(client_id);
					
		 su_bean  = as_db.getInfoSale1(car_mng_id);
		 		 
		 client_st = client.getClient_st(); //2:개인
		 ven_code2 = client.getVen_code(); //매매상
		
		String i_ssn = "";
		i_ssn = client.getSsn1() + client.getSsn2();
		
		String i_enp_no = client.getEnp_no1() + client.getEnp_no2()+ client.getEnp_no3();
		if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() + client.getSsn2();
		
		if(ven_code2.equals("")){
			if(client_st.equals("2"))	ven_code2 = neoe_db.getVenCode(i_ssn,i_enp_no);
			if(!client_st.equals("2"))	ven_code2 = neoe_db.getVenCode2(i_ssn,i_enp_no);
		}
		
		if(client_st.equals("2")){
			ven_type = "1";  //주민번호
			s_idno   =	i_ssn;
		}else{
			ven_type = "0";  //사업자
			s_idno   =	i_enp_no;
		}
				
		  	
	  	String item_id = "";
	  	String reg_code = "";	
	  	
	  	String tax_supply = "";
		String tax_value = "";
		String tax_branch 	= "";	
	
	    //자산매각 세금계산서 
		tax_no = IssueDb.getTaxNoNext(assch_date);
	
		//사용할 item_id 가져오기
		item_id = IssueDb.getItemIdNext(assch_date);
	//	out.println("item_id="+item_id+"<br><br>");
	    		
		//실행코드 가져오기
		reg_code  = Long.toString(System.currentTimeMillis());
	//	out.println("실행코드="+reg_code+"<br>");
	
		//[1단계] 거래명세서 리스트 생성		
		TaxItemListBean til_bean = new TaxItemListBean();			
		til_bean.setItem_id(item_id);
		til_bean.setItem_seq(1);
		til_bean.setItem_g("차량폐차대금");
		til_bean.setItem_car_no(su_bean.getCar_no());
		til_bean.setItem_car_nm(su_bean.getCar_nm());
		til_bean.setItem_supply(sup_amt);
		til_bean.setItem_value(sale_amt - sup_amt );
		til_bean.setRent_l_cd("");
		til_bean.setCar_mng_id(car_mng_id);
	 	til_bean.setGubun("6");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
		til_bean.setReg_id(user_id);
		til_bean.setReg_code(reg_code);				
		til_bean.setCar_use(""); //전자세금계산서 의무시행 관련 변경  
		til_bean.setItem_dt(assch_date);  //전자세금계산서 의무시행 관련 변경	
				
		if(!IssueDb.insertTaxItemList(til_bean)) flag2 += 1;
			    		
		//[2단계] 거래명세서 생성
		Vector vt = IssueDb.getTaxItemListSusi(reg_code);
		int vt_size = vt.size();
	//	out.println("거래명세서 생성="+vt_size+"<br><br>");
		
		for(int j=0;j < vt_size;j++){
			Hashtable ht = (Hashtable)vt.elementAt(j);
			TaxItemBean ti_bean = new TaxItemBean();
			ti_bean.setClient_id(su_bean.getClient_id());
			ti_bean.setSeq("");
			ti_bean.setItem_dt(assch_date);
			ti_bean.setTax_id("");
			ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
			ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"원");
			ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
			ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
			
			if(!IssueDb.insertTaxItem(ti_bean)) flag2 += 1;
		}

		//[3단계] 세금계산서 생성		
		Vector vt2 = IssueDb.getTaxItemSusi(reg_code);
				    	
		int vt_size2 = vt2.size();
	//	out.println("세금계산서 생성="+vt_size2+"<br><br>");
		
		if (tax_branch.equals("")) tax_branch = br_id;
		
		for(int i=0;i < vt_size2;i++){
			Hashtable ht_t = (Hashtable)vt2.elementAt(i);
					
			tax.TaxBean t_bean = new tax.TaxBean();			
					
			t_bean.setClient_id(su_bean.getClient_id());  	
			t_bean.setTax_dt(assch_date);
			
			t_bean.setUnity_chk("0");//통합여부0=개별,1=통합
			t_bean.setRent_l_cd("");
			t_bean.setFee_tm("");
			t_bean.setCar_mng_id(car_mng_id);
			t_bean.setBranch_g(tax_branch);
			t_bean.setTax_g("차량폐차대금");
			t_bean.setTax_supply(sup_amt);
			t_bean.setTax_value(sale_amt - sup_amt);
			t_bean.setTax_id(su_bean.getClient_id());
			t_bean.setItem_id(item_id);
			t_bean.setTax_bigo("차량폐차 - " + su_bean.getCar_no() );			
			
				//20090701부터 사업자단위과세			
			if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
				//종사업장
				Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
				t_bean.setTax_bigo(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
				t_bean.setBranch_g("S1");
				t_bean.setBranch_g2(tax_branch);
				t_bean.setTaxregno(String.valueOf(br2.get("TAXREGNO")));	 //전자세금계산서 의무시행 관련 변경
			} 
			
			t_bean.setSeq("");  
			t_bean.setTax_no(tax_no);
			t_bean.setCar_no(su_bean.getCar_no());
			t_bean.setCar_nm(su_bean.getCar_nm());
			t_bean.setTax_st("O");
			t_bean.setTax_type("1");  //무조건 본사
			t_bean.setReg_id(user_id);
			t_bean.setGubun("6");
			    					
			//공급받는자정보 : 20090608 작업
			t_bean.setRecTel			(String.valueOf(ht_t.get("RECTEL")));
			t_bean.setRecCoRegNo		(String.valueOf(ht_t.get("RECCOREGNO")));
			t_bean.setRecCoName			(String.valueOf(ht_t.get("RECCONAME2")));
			t_bean.setRecCoCeo			(String.valueOf(ht_t.get("RECCOCEO2")));
			t_bean.setRecCoAddr			(String.valueOf(ht_t.get("RECCOADDR")));
			t_bean.setRecCoBizType		(String.valueOf(ht_t.get("RECCOBIZTYPE2")));
			t_bean.setRecCoBizSub		(String.valueOf(ht_t.get("RECCOBIZSUB2"))); 
							
			//전자세금계산서 의무시행 관련 변경	
			//공급받는자가 개인일때와 법인일 경우의 처리
			if(String.valueOf(ht_t.get("RECCOREGNO")).length() == 13){
				t_bean.setTax_bigo	(t_bean.getTax_bigo()+"-"+String.valueOf(ht_t.get("RECCOREGNO")));
				t_bean.setRecCoSsn	(String.valueOf(ht_t.get("RECCOREGNO")));
				t_bean.setReccoregnotype("02");//사업자구분-주민등록번호
			}else {
				t_bean.setReccoregnotype("01");//사업자구분-사업자등록번호
			}						
			
			if(!IssueDb.insertTax(t_bean)) flag2 += 1;  
			
			if(!IssueDb.updateTaxAutodocu(tax_no)) flag2 += 1;
		}
	    		
		//전자세금계산서 발행	
		String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
		if (d_flag1.equals("1"))		flag2 += 1;
	
	} //계산서 발행건이면
		    	
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));
	String node_code ="S101";  //네오엠 iu 에서는 회계단위:S101	
			
	 //-----------------선수금 금액 관련 ------------------------	
		  
 	//폐차 	
	doc_cont = "폐차" + "-" + car_no  ;
 		
	line++;
				
	Hashtable ht2_1 = new Hashtable();
	
	ht2_1.put("WRITE_DATE", 	assch_date);//row_id	
	ht2_1.put("ROW_NO",  	String.valueOf(line)); //row_no		
	ht2_1.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
	ht2_1.put("CD_PC",  	node_code);  //회계단위*
	ht2_1.put("CD_WDEPT",  dept_code);  //부서
	ht2_1.put("NO_DOCU",  	"");  //row_id와 같게
	ht2_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht2_1.put("CD_COMPANY",  "1000");  
	ht2_1.put("ID_WRITE", insert_id);   
	ht2_1.put("CD_DOCU",  "11");  
	
	ht2_1.put("DT_ACCT",assch_date); 
	ht2_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
	ht2_1.put("TP_DRCR",  "1");   // 대변:2 , 차변:1
	ht2_1.put("CD_ACCT",  "25900");   //선수금
	ht2_1.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("sale_amt")) ));										
	ht2_1.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체	
	ht2_1.put("CD_PARTNER",	"000131"); //거래처    - A06
		
	ht2_1.put("DT_START", assch_date) ;  	//발생일자			
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
	line++;
	
	Hashtable ht3 = new Hashtable();
		
	ht3.put("WRITE_DATE", 		assch_date);//row_id				
	ht3.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht3.put("NO_TAX",  	"*");  //부가세 이외는 *
	ht3.put("CD_PC",  	node_code);  //회계단위
	ht3.put("CD_WDEPT",  dept_code);  //부서
	ht3.put("NO_DOCU",  	"");  //미결은 '0' 
	ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht3.put("CD_COMPANY",  "1000");  
	ht3.put("ID_WRITE", insert_id);   
	ht3.put("CD_DOCU",  "11");  
	
	ht3.put("DT_ACCT", 	assch_date);
	ht3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
	ht3.put("TP_DRCR",   "2");   // 대변:2 , 차변:1	
	
	if ( ass_bean.getCar_use().equals("2") ) { //렌트이면
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
	
	//폐차 계산서 발행인 경우
	if ( !client_id.equals("") && bill_doc_yn.equals("1")  ) { 
	
			line++;
		
			Hashtable ht8_2 = new Hashtable();
				
			ht8_2.put("WRITE_DATE", 	assch_date); //row_id							
			ht8_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
			ht8_2.put("CD_PC",  	node_code);  //회계단위
			ht8_2.put("CD_WDEPT",  dept_code);  //부서
			ht8_2.put("NO_DOCU",  	"");  //미결은 '0' 
			ht8_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht8_2.put("CD_COMPANY",  "1000");  
			ht8_2.put("ID_WRITE", insert_id);   
			ht8_2.put("CD_DOCU",  "11");  
			
			ht8_2.put("DT_ACCT", 	assch_date); 
			ht8_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht8_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
			ht8_2.put("CD_ACCT",  		"25500");  //부가세예수금					
			ht8_2.put("AMT",   		String.valueOf( sale_amt - sup_amt ) );								
			ht8_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht8_2.put("CD_PARTNER",	ven_code2); //거래처    - A06
										
			ht8_2.put("DT_START", assch_date);  	//발생일자 - 부가세										 
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
			ht8_2.put("AM_TAXSTD",	  String.valueOf( sup_amt) );		 //과세표준액
			ht8_2.put("AM_ADDTAX",	String.valueOf( sale_amt - sup_amt ) );			 //세액
			ht8_2.put("TP_TAX",	"11");  //과세(매출) :11
			if(ven_type.equals("1")){ //개인
				ht8_2.put("NO_COMPANY",	"8888888888"); //사업자등록번호
			} else {
				ht8_2.put("NO_COMPANY",	s_idno); //사업자등록번호
			}								
			ht8_2.put("NM_NOTE", doc_cont);  // 적요	
						
			vt_auto.add(ht8_2);  // 부가세				  
			  
	}		  
      	 	 
 	// 감가상각 누계액 - 리스/ 대여사업차량 	 	
	line++;
	
	Hashtable ht6 = new Hashtable();
	
	ht6.put("WRITE_DATE", 		assch_date);//row_id				
	ht6.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht6.put("NO_TAX",  	"*");  //부가세 이외는 *
	ht6.put("CD_PC",  	node_code);  //회계단위
	ht6.put("CD_WDEPT",  dept_code);  //부서
	ht6.put("NO_DOCU",  	"");  //미결은 '0' 
	ht6.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht6.put("CD_COMPANY",  "1000");  
	ht6.put("ID_WRITE", insert_id);   
	ht6.put("CD_DOCU",  "11");  
	
	ht6.put("DT_ACCT", 	assch_date);
	ht6.put("ST_DOCU",  "1");  //미결:1, 승인:2  
	ht6.put("TP_DRCR",   "1");   // 대변:2 , 차변:1	
	
	if ( ass_bean.getCar_use().equals("2") ) { //렌트이면
		ht6.put("CD_ACCT",  	"21800");    //대여사업차량
	} else {
		ht6.put("CD_ACCT",  	"22000");  //리스사업차량
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
      	 
	 	line++;
		
		Hashtable ht6_1 = new Hashtable();
					
		ht6_1.put("WRITE_DATE", 		assch_date);//row_id				
		ht6_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht6_1.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht6_1.put("CD_PC",  	node_code);  //회계단위
		ht6_1.put("CD_WDEPT",  dept_code);  //부서
		ht6_1.put("NO_DOCU",  	"");  //미결은 '0' 
		ht6_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht6_1.put("CD_COMPANY",  "1000");  
		ht6_1.put("ID_WRITE", insert_id);   
		ht6_1.put("CD_DOCU",  "11");  
	
			
		ht6_1.put("DT_ACCT", 	assch_date);
		ht6_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht6_1.put("TP_DRCR",   "1");   // 대변:2 , 차변:1	
		
		ht6_1.put("CD_ACCT",  	"21810");    //대여사업차량 국가보조금 
		
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
	  
         //2016년 회계처리 변경 
            
 	 	//처분이익 	
/* 	 	
   	if ( amt_10800  > 0 ) {
   	
	 // 대여/리스차량 처분이익  
		line++;
		
		Hashtable ht7 = new Hashtable();
			
		ht7.put("WRITE_DATE", 		assch_date);//row_id				
		ht7.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht7.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht7.put("CD_PC",  	node_code);  //회계단위
		ht7.put("CD_WDEPT",  dept_code);  //부서
		ht7.put("NO_DOCU",  	"");  //미결은 '0' 
		ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht7.put("CD_COMPANY",  "1000");  
		ht7.put("ID_WRITE", insert_id);   
		ht7.put("CD_DOCU",  "11");  
		
		ht7.put("DT_ACCT", 	assch_date);
		ht7.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht7.put("TP_DRCR",   "2");   // 대변:2 , 차변:1	
		
		if ( ass_bean.getCar_use().equals("2") ) { //렌트이면
			ht7.put("CD_ACCT",  	"41300");    //대여사업차량
		} else {
			ht7.put("CD_ACCT",  	"41500");  //리스사업차량
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
		line++;
		
		Hashtable ht8 = new Hashtable();
		
		ht8.put("WRITE_DATE", 		assch_date);//row_id				
		ht8.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht8.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht8.put("CD_PC",  	node_code);  //회계단위
		ht8.put("CD_WDEPT",  dept_code);  //부서
		ht8.put("NO_DOCU",  	"");  //미결은 '0' 
		ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht8.put("CD_COMPANY",  "1000");  
		ht8.put("ID_WRITE", insert_id);   
		ht8.put("CD_DOCU",  "11");  
		
		ht8.put("DT_ACCT", 	assch_date);
		ht8.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht8.put("TP_DRCR",   "1");   // 대변:2 , 차변:1	
		
		if ( ass_bean.getCar_use().equals("2") ) { //렌트이면
			ht8.put("CD_ACCT",  	"45300");    //대여사업차량
		} else {
			ht8.put("CD_ACCT",  	"45400");  //리스사업차량
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
	
	Hashtable ht7 = new Hashtable();
		
	ht7.put("WRITE_DATE", 		assch_date);//row_id				
	ht7.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht7.put("NO_TAX",  	"*");  //부가세 이외는 *
	ht7.put("CD_PC",  	node_code);  //회계단위
	ht7.put("CD_WDEPT",  dept_code);  //부서
	ht7.put("NO_DOCU",  	"");  //미결은 '0' 
	ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht7.put("CD_COMPANY",  "1000");  
	ht7.put("ID_WRITE", insert_id);   
	ht7.put("CD_DOCU",  "11");  
	
	ht7.put("DT_ACCT", 	assch_date);
	ht7.put("ST_DOCU",  "1");  //미결:1, 승인:2  
	ht7.put("TP_DRCR",   "2");   // 대변:2 , 차변:1	
	
	if ( ass_bean.getCar_use().equals("2") ) { //렌트이면
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
	
	vt_auto.add(ht7);  // 처분이익 / 손실
	
		
	// 장부가
	line++;
	
	Hashtable ht8 = new Hashtable();
	
	ht8.put("WRITE_DATE", 		assch_date);//row_id				
	ht8.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht8.put("NO_TAX",  	"*");  //부가세 이외는 *
	ht8.put("CD_PC",  	node_code);  //회계단위
	ht8.put("CD_WDEPT",  dept_code);  //부서
	ht8.put("NO_DOCU",  	"");  //미결은 '0' 
	ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht8.put("CD_COMPANY",  "1000");  
	ht8.put("ID_WRITE", insert_id);   
	ht8.put("CD_DOCU",  "11");  
	
	ht8.put("DT_ACCT", 	assch_date);
	ht8.put("ST_DOCU",  "1");  //미결:1, 승인:2  
	ht8.put("TP_DRCR",   "1");   // 대변:2 , 차변:1	
	
	if ( ass_bean.getCar_use().equals("2") ) { //렌트이면
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
		row_id = neoe_db.insertSetAutoDocu(assch_date, vt_auto);
	  }
 	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language="JavaScript">
<!--
	function NullAction(){	
	<%	if( s_flag.equals("0")){%>
 	  			alert("정상적으로 처리(전표발행)되었습니다.");
	 	  		var theForm = document.form1;
	 	  		theForm.target='d_content';
  				theForm.submit();
	<%	}else {%>
 	  			alert("수정 오류!");
	<% } %>
   
   }
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="./asset_s_frame.jsp" name="form1" method="post">
<input type="hidden" name="cmd" valaue="nd">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="asset_code" value="<%=asset_code%>">
</form>
</body>
</html>
