<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.credit.*, acar.client.*, acar.cls.*,  acar.cont.*, tax.*, acar.bill_mng.*"%>
<%@ page import="acar.user_mng.*, acar.fee.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
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
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	String firm_nm = request.getParameter("firm_nm")==null?"":	request.getParameter("firm_nm");
	 		
	String match 	= request.getParameter("match")==null?"":request.getParameter("match"); //만기매칭 :Y
	 	
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
		
	String re_bank =  request.getParameter("re_bank")==null?"":	request.getParameter("re_bank");
	String re_acc_nm =  request.getParameter("re_acc_nm")==null?"":	request.getParameter("re_acc_nm");
	String re_acc_no =  request.getParameter("re_acc_no")==null?"":	request.getParameter("re_acc_no");
	String re_bank_nm = "";
		
	String r_tax_dt = request.getParameter("r_tax_dt")==null?"":request.getParameter("r_tax_dt");
	
	String use_e_dt	= request.getParameter("use_e_dt")==null?"":request.getParameter("use_e_dt"); // 대여스케쥴 만기일
	
	if (!re_bank.equals("")) re_bank_nm = c_db.getNameById( re_bank, "CMS_BNK");
		
   //해지정보					
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
   
	
	//해지사유
	if ( cls.getCls_st().equals("계약만료") ) {
		cls_st = "1";
	} else	if ( cls.getCls_st().equals("중도해약") ) {
		cls_st = "2";
	} else	if ( cls.getCls_st().equals("매입옵션") ) {
		cls_st = "8";
	} else	if ( cls.getCls_st().equals("월렌트해지") ) {
		cls_st = "14";	
	} else	if ( cls.getCls_st().equals("출고전해지(신차)") ) {
		cls_st = "7";		
	} else	if ( cls.getCls_st().equals("개시전해지(재리스)") ) {
		cls_st = "10";		
	} 
	
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";		
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}
		
	//계약:고객관련
	ContBaseBean base 	= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	client_id = base.getClient_id();
	
	if(base.getTax_type().equals("2")){//지점
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
		
	
	String car_st = "1";
   if (base.getCar_st().equals("3")) {
   			car_st = "2";
   } else {
         car_st = "1";
   }
   	
	//대여정보
	ContFeeBean fee = a_db.getContFee(rent_mng_id, rent_l_cd, "1");
	tax_branch = fee.getBr_id()==""?br_id:fee.getBr_id();
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	String pp_chk ="";
	//대여정보
	
	ContFeeBean fee1 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	pp_chk = fee1.getPp_chk();
			
	//거래처정보
	ClientBean client = al_db.getNewClient(client_id);
	
	String ven_type = "";
	String s_idno = "";
	
	String client_st = client.getClient_st(); //2:개인
	
	String foreigner=  client.getNationality();
		
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
	
	
	//해지의뢰정보
	ClsEtcBean clse = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	
	match= clse.getMatch(); //만기매칭 다시 확인 
	
	//싼타페등 연비보상
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id(), "Y" );	
		
	String return_remark = "";
	Hashtable  return1 =   new Hashtable();
	
    if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "Y"); 	
	   	return_remark = (String)return1.get("REMARK");
    }
    	
	//마지막 거래명세서 발행 유무
	String tax_item_id_tm = ac_db.getMaxFeeTaxItemTm(rent_l_cd);  // tm
		
	//마지막 거래명세서 발행관련 - 해지정산시
	Hashtable item_tax = ac_db.getLastFeeTaxItemItemId(rent_l_cd, tax_item_id_tm);
	
	
	//마지막 거래명세서는 N으로 변경
	if(!match.equals("Y")){// 
		
		if ( String.valueOf(item_tax.get("USE_YN")).equals("Y") ) {
			if ( String.valueOf(item_tax.get("TAX_NO")).equals("") ) {
				if(!ac_db.updateTaxItemUseYn(String.valueOf(item_tax.get("ITEM_ID")) ) ) flag += 1;
			}		
		}
	
	}
		
		//마지막 세금계산서
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
	if(!match.equals("Y")){// 
		 if(!ac_db.updateScdFeeCls4(rent_mng_id, rent_l_cd, fee_tm, user_id))	flag += 1;	//선납 균등인경우 계산서 발행- bill_yn - 'N'처리 - 20201230
	}
			
	//세금계산서 발행관련 - 해지정산시
	Hashtable l_tax = ac_db.getLastFeeTaxDt(rent_l_cd, fee_tm);	
	
			//마지막 계산서 발행날짜 + 1 
	String item_dt2_p = "";
//	item_dt2_p = c_db.addDay(String.valueOf(l_tax.get("ITEM_DT2")), 1);
	
	//만기 또는 중도해지 fm.ifee_s_amt.value != '0' 
	if (  cls.getCls_st().equals("출고전해지(신차)")  || cls.getCls_st().equals("개시전해지(재리스)") ) {
	} else {
					if (  String.valueOf(l_tax.get("ITEM_DT2")).equals("") ||  String.valueOf(l_tax.get("ITEM_DT2")).equals("null") ) {
					} else {
						
						item_dt2_p = c_db.addDay(String.valueOf(l_tax.get("ITEM_DT2")), 1);   //계산서 마지막일 + 1	
					}	
	}
		
					// 취소로 계산된 경우 처리는 별도 - 20190502 ( 마이너스 금액인 경우 )		
	if (	 AddUtil.parseInt(String.valueOf(l_tax.get("ITEM_SUPPLY"))) < 0 ) {
			   		item_dt2_p = String.valueOf(item_tax.get("ITEM_DT1")); //거래명세서상 시작일
	}
		
	//개시대여료, 선납금 환급이 있는 경우
		String tdt4 = "";
		tdt4	=	ac_db.getTaxGubunDt(rent_l_cd, "4"); //개시대여료
		
		String tdt3 = "";
		tdt3	=ac_db.getTaxGubunDt(rent_l_cd, "3"); //선납금
		
		//미입금된 면책금 중 계산서 미발행분
		//면책금 기청구된 건중 매출처리 여부 구분
		int car_ja_no_amt = ac_db.getClsEtcCarNoAmt(rent_mng_id, rent_l_cd);
				
		//세금계산서 작성 및 네오엠 외상매출금 처리

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
	  	int  a1_s_amt = 0;  //잔여개시대여료 - 계산서 필수 
	    int  a1_v_amt = 0;
	    int  a2_s_amt = 0;  //잔여선납금 - 계산서 필수
	    int  a2_v_amt = 0;
	    int  a3_s_amt = 0;  //취소대여료 - 계산서 필수
	    int  a3_v_amt = 0;
	    int  a4_s_amt = 0;  //미납대여료 - 계산서 필수
	    int  a4_v_amt = 0;
	    int  a5_s_amt = 0;  //해지위약금
	    int  a5_v_amt = 0;
	    int  a6_s_amt = 0;  //회수외주비용
	    int  a6_v_amt = 0;
	    int  a7_s_amt = 0;  //회수부대비용
	    int  a7_v_amt = 0;
	    int  a8_s_amt = 0;  //손해배상
	    int  a8_v_amt = 0;
	    int  a9_s_amt = 0;  //초과 운행추가대여료 - 계산서 필수  - 202208  초과운행 환불은 계산서 해지시 발행할 수 없음 ( 정상발행분을 취소하는 방식이어야함. 단독 마이너스게산서 발행 불가 .. 외상매출금만 처리!!!)
	    int  a9_v_amt = 0;
	    
	    int i_tax_supply = 0;  //통합발행시 공급가
		int i_tax_value = 0;  //통합발행시 vat
	  	
	  	String item_id = "";
	  	String reg_code = "";	
	  	String ven_code = "";

		int cls_fee1 =  0;
		int cls_fee2 =  0;
		
		
		//  취소대여료가 있었던 경우 
		if (AddUtil.parseDigit(tax_r_supply[2]) != 0   ) {
		   cls_fee1++;
		}
			  
		for(int ii = 0; ii<tax_size; ii++){
			
			String tax_r_chk = request.getParameter("tax_r_chk"+ii)==null?"N":	request.getParameter("tax_r_chk"+ii);
			
			if(tax_r_chk.equals("Y")){				
				if ( tax_r_g[ii].equals("해지 취소 대여료") ) {
				    	cls_fee1++;
			   }
			   if ( tax_r_g[ii].equals("해지 미납 대여료")  || tax_r_g[ii].equals("해지 대여료")  ) {
					    	cls_fee2++;
			   }	
			}
			
		}
			
		String tax_reg_gu = request.getParameter("tax_reg_gu")==null?"":	request.getParameter("tax_reg_gu");
		
		if( tax_reg_gu.equals("Y")){// 항목별 통합발행 (1장)   	
				  		
	  	  		for(int i = 0; i<tax_size; i++){
		    			String tax_r_chk = request.getParameter("tax_r_chk"+i)==null?"N":	request.getParameter("tax_r_chk"+i);
			
						if(tax_r_chk.equals("Y")){
	      	    			out.println("선택"+i+"=<br><br>");
	            			i_tax_supply  = i_tax_supply + AddUtil.parseDigit(tax_r_supply[i]);
	            			i_tax_value   = i_tax_value + AddUtil.parseDigit(tax_r_value[i]);
	            		//	tax_cnt++;
	          			}
		    	}
		
	  	  		if(cls.getCls_dt().equals("")){
	  	  			cls.setCls_dt(cls_dt);
				}
		    	
		    	
		    	//사용할 item_id 가져오기	    
		    	item_id = IssueDb.getItemIdNext(cls.getCls_dt());	    	
			
				out.println("item_id="+item_id+"<br><br>");
				    		
	    		//실행코드 가져오기
				reg_code  = Long.toString(System.currentTimeMillis());
				out.println("실행코드="+reg_code+"<br>");
	    		
	    		//[1단계] 거래명세서 리스트 생성		
				TaxItemListBean til_bean = new TaxItemListBean();			
				til_bean.setItem_id(item_id);
				til_bean.setItem_seq(1);
				til_bean.setItem_g("해지정산금");
				til_bean.setItem_car_no(car_no);
				til_bean.setItem_car_nm(car_nm);
				til_bean.setItem_supply(i_tax_supply);
				til_bean.setItem_value(i_tax_value);
				til_bean.setRent_l_cd(rent_l_cd);
				til_bean.setCar_mng_id(car_mng_id);
			 	til_bean.setGubun("15");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
				til_bean.setReg_id(user_id);
				til_bean.setReg_code(reg_code);
			    til_bean.setCar_use(car_st); //전자세금계산서 의무시행 관련 변경 - 1:렌트 2:리스
				til_bean.setItem_dt(cls.getCls_dt());  //전자세금계산서 의무시행 관련 변경	
				
						
				if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
						    		
		    	//[2단계] 거래명세서 생성
		    	//Vector vt = IssueDb.getTaxItemList(reg_code); //분할청구포함??
		    		
				Vector vt = IssueDb.getTaxItemListSusi(reg_code);
				int vt_size = vt.size();
				out.println("거래명세서 생성="+vt_size+"<br><br>");
				
				for(int j=0;j < vt_size;j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					TaxItemBean ti_bean = new TaxItemBean();
					ti_bean.setClient_id(client_id);
					ti_bean.setSeq(site_id);
					ti_bean.setItem_dt(cls.getCls_dt());
					
					ti_bean.setTax_id("");
					ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
					ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"원");
					ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
					ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
					
					if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
				}
		
		    	//[3단계] 세금계산서 생성
		    	tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());	  
		    		
		    	Vector vt2 = IssueDb.getTaxItemSusi(reg_code);
		    	
				int vt_size2 = vt2.size();
				out.println("세금계산서 생성="+vt_size2+"<br><br>");
				
			//	if (tax_branch.equals("")) tax_branch = br_id;
				if (tax_branch.equals("")) tax_branch = "S1";   //br_id
		    	
		    	for(int k=0;k < vt_size2;k++){
					Hashtable ht_t = (Hashtable)vt2.elementAt(k);
								
					tax.TaxBean t_bean = new tax.TaxBean();				
					t_bean.setClient_id(client_id);  
					t_bean.setTax_dt(cls.getCls_dt());	    
					
		      			
		      		t_bean.setUnity_chk("1");//통합여부0=개별,1=통합
					t_bean.setRent_l_cd(rent_l_cd);
					t_bean.setFee_tm("");
		    		t_bean.setCar_mng_id(car_mng_id);    		    	
		    		t_bean.setBranch_g(tax_branch);
		    		t_bean.setTax_g("해지정산금");
		    		t_bean.setTax_supply(i_tax_supply);
		   	 		t_bean.setTax_value(i_tax_value);
		    		t_bean.setTax_id(client_id);
		    		t_bean.setItem_id(item_id);
		    		t_bean.setTax_bigo(request.getParameter("car_no")==null?"":	request.getParameter("car_no")+" 해지");		
	    							
					//20090701부터 사업자단위과세			
					if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
						//종사업장
						Hashtable br2 = c_db.getBranch(tax_branch);
					//	Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
						t_bean.setTax_bigo(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
						t_bean.setBranch_g("S1");
						t_bean.setBranch_g2(tax_branch);
						t_bean.setTaxregno(String.valueOf(br2.get("TAXREGNO")));	 //전자세금계산서 의무시행 관련 변경
					}
	    		   		   	    		
			    		t_bean.setSeq(site_id);  
			    		t_bean.setTax_no(tax_no);
			    		t_bean.setCar_no(car_no);
			    		t_bean.setCar_nm(car_nm);
			    		t_bean.setTax_st("O");
			    		t_bean.setTax_type(base.getTax_type());  
			    		t_bean.setReg_id(user_id);
			    		t_bean.setGubun("15");
	    					
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
					}else{
						t_bean.setReccoregnotype("01");//사업자구분-사업자등록번호
					}
					
					//--외국인
				          if(foreigner.equals("2") ) {
				         		 t_bean.setReccoregnotype("03");     //외국인
				                    t_bean.setRecCoRegNo("9999999999999");	
				                    t_bean.setTax_bigo(t_bean.getTax_bigo() +" "+  String.valueOf(ht_t.get("RECCOREGNO")) );	       
				          };

		    			if(!IssueDb.insertTax(t_bean)) flag += 1;  
		    			
		    			if(!IssueDb.updateTaxAutodocu(tax_no)) flag += 1;
		    	}

	    		//전자세금계산서 발행 - 의무시행 2010
	       		
	    		//본사-영업소
				Hashtable br1 = c_db.getBranch("S1");
		//		String resseq = IssueDb.getResSeqNext();
				
			//	if(!IssueDb.insertSaleEBillCase(resseq, tax_no, String.valueOf(br1.get("BR_ENT_NO")))) flag += 1;
									
				String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
				if (d_flag1.equals("1"))		flag += 1;					
	 
		} else {	
					
			for(int i = 0; i<tax_size; i++){ 		
			
				String tax_r_chk = request.getParameter("tax_r_chk"+i)==null?"N":	request.getParameter("tax_r_chk"+i);
				out.println(tax_r_chk);
				if(tax_r_chk.equals("Y") && AddUtil.parseDigit(tax_r_supply[i]) != 0 ){  //금액이 0이 아니면???
					out.println("선택"+i+"=<br><br>");
				
			    //		tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());
			    		
			  //  		out.println("tax_no="+tax_no+"<br>");
			    		out.println("tax_dt="+cls.getCls_dt()+"<br>");
			    		out.println("tax_r_g="+tax_r_g[i]+"<br>");
			    		out.println("tax_r_supply="+tax_r_supply[i]+"<br>");
			    		
						//사용할 item_id 가져오기
				//	item_id = IssueDb.getItemIdNext(cls.getCls_dt());
						
			//		out.println("item_id="+item_id+"<br><br>");
						    		
			    		//실행코드 가져오기
			//			reg_code  = Long.toString(System.currentTimeMillis());
			//			out.println("실행코드="+reg_code+"<br>");
			    		
			    		//[1단계] 거래명세서 리스트 생성		
						TaxItemListBean til_bean = new TaxItemListBean();			
				//		til_bean.setItem_id(item_id);
						til_bean.setItem_seq(1);
						til_bean.setItem_g(tax_r_g[i]);
						til_bean.setItem_car_no(car_no);
						til_bean.setItem_car_nm(car_nm);
						til_bean.setItem_supply(AddUtil.parseDigit(tax_r_supply[i]));
						til_bean.setItem_value(AddUtil.parseDigit(tax_r_value[i]));
						til_bean.setRent_l_cd(rent_l_cd);
						til_bean.setCar_mng_id(car_mng_id);
					 	til_bean.setGubun("15");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
						til_bean.setReg_id(user_id);
				//		til_bean.setReg_code(reg_code);
						
						til_bean.setCar_use(car_st); //전자세금계산서 의무시행 관련 변경 - 1:렌트 2:리스
					
						til_bean.setItem_dt(cls.getCls_dt());  //전자세금계산서 의무시행 관련 변경
						
						if ( tax_r_g[i].equals("해지 취소 대여료") ) {
				    			til_bean.setItem_dt1(String.valueOf(l_tax.get("ITEM_DT1"))  );   //마지막 계산서의 사용기간
				    			til_bean.setItem_dt2(String.valueOf(l_tax.get("ITEM_DT2"))  );   //	    		
			    		}   		
		    		
		    					    		//개시대여료 제외 - 마지막스케쥴이 대여기간보다 적은 경우는 계산안함.        		  	
				      	if ( tax_r_g[i].equals("해지 미납 대여료") ||   tax_r_g[i].equals("해지 대여료")  ) {
				    		       
				    		          //해지취소대여료와 미납대여료가 있는 경우는 마지막계산서 전
					    		 if ( cls_fee1 == 1 ) {				    		  					    		   	
					    		   	Hashtable l_tax1 = ac_db.getLastFeeTaxDt(rent_l_cd, Integer.toString(Integer.parseInt(fee_tm)  - 1));
					    		   	item_dt2_p = c_db.addDay(String.valueOf(l_tax1.get("ITEM_DT2")), 1);   //계산서 마지막일 + 1				    		
					    		 }	     
					    		   			    				    		
				    	 	 	if ( AddUtil.parseDigit(request.getParameter("ifee_s_amt")) > 0 ) {
				    	 	 	  if ( AddUtil.parseDigit(request.getParameter("rifee_s_amt")) > 0 ) {  //잔여개시대여료가 남아있는 경우에 한해서 
				    	 	 	      if ( AddUtil.parseDigit(AddUtil.getReplace_dt(cls.getCls_dt()))  >  AddUtil.parseDigit(use_e_dt) ) {
				    	 	 	      		til_bean.setItem_dt1(item_dt2_p);   // 마지막계산서 + 1 사용기간
				    					til_bean.setItem_dt2(use_e_dt );   // 스캐쥴 만기일		    	 	 	      
				    	 	 	      } else {
				    	 	 	     	         til_bean.setItem_dt1(item_dt2_p);   // 마지막계산서 + 1 사용기간
				    					til_bean.setItem_dt2(cls.getCls_dt() );  //해지일/	 	    	 	 	      
				    	 	 	      }	    	 	 	
				    	 	 	  }
				    	 	 	}else {
				    	  			til_bean.setItem_dt1(item_dt2_p);   //사용기간
				    				til_bean.setItem_dt2(cls.getCls_dt() );   //	    	
				    			}	
				    	}	
		    			    
		    	 		//사용할 item_id 가져오기 - 저장직전에 값을 가져오는 걸로 변경- 20190121 (중복 발생 )  
						item_id = IssueDb.getItemIdNext(cls.getCls_dt());
							
						out.println("item_id="+item_id+"<br><br>");
						    		
			    		//실행코드 가져오기
						reg_code  = Long.toString(System.currentTimeMillis());
						out.println("실행코드="+reg_code+"<br>"); 
							  
						til_bean.setItem_id(item_id);
						til_bean.setReg_code(reg_code);  
									    		    			
						if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
						    		
				    	//[2단계] 거래명세서 생성
						Vector vt = IssueDb.getTaxItemListSusi(reg_code);
						int vt_size = vt.size();
						out.println("거래명세서 생성="+vt_size+"<br><br>");
						
						for(int j=0;j < vt_size;j++){
							Hashtable ht = (Hashtable)vt.elementAt(j);
							TaxItemBean ti_bean = new TaxItemBean();
							ti_bean.setClient_id(client_id);
							ti_bean.setSeq(site_id);
							ti_bean.setItem_dt(cls.getCls_dt());
							
						//	if ( tax_r_g[i].equals("해지 취소 대여료") ) {
						//		ti_bean.setItem_dt(String.valueOf(l_tax.get("TAX_DT"))  );  //전자세금계산서 의무시행 관련 변경
						//	}
							
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
					    	
					   	if (tax_branch.equals("")) tax_branch = "S1";   //br_id
					    		    	 
					   	for(int k=0;k < vt_size2;k++){
							Hashtable ht_t = (Hashtable)vt2.elementAt(k);
											
							tax.TaxBean t_bean = new tax.TaxBean();						
							t_bean.setClient_id(client_id); 
								
							//	if ( tax_r_g[i].equals("해지 취소 대여료") ) {
					    	//		t_bean.setTax_dt( String.valueOf(l_tax.get("TAX_DT"))  );   //마이너스 계산서 발행일
					    	//	} else {
					    			t_bean.setTax_dt(cls.getCls_dt());		    		
					    	//	}	
					    		
					      		t_bean.setUnity_chk("0");//통합여부0=개별,1=통합
							t_bean.setRent_l_cd(rent_l_cd);
							t_bean.setFee_tm("");
						    	t_bean.setCar_mng_id(car_mng_id);
							t_bean.setBranch_g(tax_branch);
					    		t_bean.setTax_g(tax_r_g[i]);
					    		t_bean.setTax_supply(AddUtil.parseDigit(tax_r_supply[i]));
					   	 	t_bean.setTax_value(AddUtil.parseDigit(tax_r_value[i]));
					    		t_bean.setTax_id(client_id);
					    		t_bean.setItem_id(item_id);
					    		t_bean.setTax_bigo(tax_bigo[i]);	
					    		
					    			//20090701부터 사업자단위과세			
							if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
									//종사업장
									Hashtable br2 = c_db.getBranch(tax_branch);
								//	Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
									t_bean.setTax_bigo(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
									t_bean.setBranch_g("S1");
									t_bean.setBranch_g2(tax_branch);
									t_bean.setTaxregno(String.valueOf(br2.get("TAXREGNO")));	 //전자세금계산서 의무시행 관련 변경
							}			    		
					    		
				    		t_bean.setSeq(site_id);  
				    	//	t_bean.setTax_no(tax_no);
				    		t_bean.setCar_no(car_no);
				    		t_bean.setCar_nm(car_nm);
				    		t_bean.setTax_st("O");
				    		t_bean.setTax_type(base.getTax_type());  
				    		t_bean.setReg_id(user_id);
				    		t_bean.setGubun("15");
				    		    					
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
							}else{
									t_bean.setReccoregnotype("01");//사업자구분-사업자등록번호
							}									
								
								
								// 마이너스 계산서인 경우 사유 등록 
							if ( tax_r_g[i].equals("해지 개시대여료 환급")) {
								   t_bean.setDoctype("02");   //공급가변동으로 처리
								    t_bean.setTax_bigo	( tdt4+"(당초 세금계산서 작성일)" + car_no);  
							}else if ( tax_r_g[i].equals("해지 선납금 환급")) {
					    			   t_bean.setDoctype("02");   //공급가변동으로 처리
					    			  t_bean.setTax_bigo	( tdt3+"(당초 세금계산서 작성일)" + car_no);
								
					    		}else if ( tax_r_g[i].equals("해지 취소 대여료") ) {
					    		   //해지취소대여료만 있는 경우와 취소,미납대여료가 같이 있는 경우 처리는 틀림 :
						    		   if ( cls_fee2 == 1   ) {
						    		             t_bean.setDoctype("04");  //계약해지로 처리
						    		    } else {          
						    			  t_bean.setDoctype("02");  //공급가변동으로 처리
						    			  t_bean.setTax_bigo	( String.valueOf(l_tax.get("TAX_DT"))+"(당초 세금계산서 작성일)" + car_no);					    		 
						    		   }	     
					    		}										
								
								//--외국인
						          if(foreigner.equals("2") ) {
						         		 t_bean.setReccoregnotype("03");     //외국인
						                    t_bean.setRecCoRegNo("9999999999999");	
						                    t_bean.setTax_bigo(t_bean.getTax_bigo() +" "+  String.valueOf(ht_t.get("RECCOREGNO")) );	       
						          };
				          
						        /* 직전에 계산값 가져오기 */   
						       	tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());
				  		   		out.println("tax_no="+tax_no+"<br>");
				  		   		
				  		  	    t_bean.setTax_no(tax_no);
				  		  	
				    			if(!IssueDb.insertTax(t_bean)) flag += 1;  
				    			
				    			if(!IssueDb.updateTaxAutodocu(tax_no)) flag += 1;
				    			    						    			 
				    			 // 세금계산서 발행분 공급가 및 부가세 저장				    			
					    		 if ( tax_r_g[i].equals("해지 취소 대여료") ) {
					    		   a3_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
					    		   a3_v_amt = AddUtil.parseDigit(tax_r_value[i]);
					    		}else if ( tax_r_g[i].equals("해지 미납 대여료")   ||  tax_r_g[i].equals("해지 대여료")      ) {
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
					    		}else if ( tax_r_g[i].equals("해지 초과운행추가대여료") ||  tax_r_g[i].equals("해지 초과운행대여료") ) {
					    		   a9_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
					    		   a9_v_amt = AddUtil.parseDigit(tax_r_value[i]);    	   
				    			}    			
		    			
		    			   			
			         }  ////금액이 0이 아니면??? end for vt_size2  세금계산서 생성
				
					   
					//전자세금계산서 발행 - 의무시행 2010
					    		   		
			    		//본사-영업소
					Hashtable br1 = c_db.getBranch("S1");
					   //	Hashtable br1 = c_db.getBranch(tax_branch);
			    //		String resseq = IssueDb.getResSeqNext();
			    		
					//	if(!IssueDb.insertSaleEBillCase(resseq, tax_no, String.valueOf(br1.get("BR_ENT_NO")))) flag += 1;
						
					String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
					if (d_flag1.equals("1"))		flag += 1;					
			    						
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
			
		}	
			
		//자동전표처리용
		Vector vt_m_auto = new Vector();
		Vector vt_auto = new Vector();
				
		int line =0;
		int amt_10800 = 0;
		String doc_cont = "";
			
		
		 //통합발행인 경우
	    if ( i_tax_supply > 0 ) {
		 
		 	//  렌트(리스)사업매출인 경우는 부가세처리 
		 		 if (cls_st.equals("7") ) {
					 doc_cont = "출고전해지(신차) 해지정산금" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " 해지정산금" + "-" + car_no + " " + firm_nm;
		 	      	}	  
		 	  						
				line++;
						
				Hashtable ht21_3 = new Hashtable();
				
				ht21_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht21_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht21_3.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht21_3.put("CD_PC",  	node_code);  //회계단위
				ht21_3.put("CD_WDEPT",  dept_code);  //부서
				ht21_3.put("NO_DOCU",  	"");  //row_id와 같게 
				ht21_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht21_3.put("CD_COMPANY",  "1000");  
				ht21_3.put("ID_WRITE", insert_id);   
				ht21_3.put("CD_DOCU",  "11");  
				
				ht21_3.put("DT_ACCT", 	cls.getCls_dt()); 
				ht21_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht21_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
				ht21_3.put("CD_ACCT",  "10800");   // 
				ht21_3.put("AMT",    	String.valueOf( i_tax_supply + i_tax_value) );		
				ht21_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht21_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht21_3.put("DT_START",  "");  	//발생일자										 
				ht21_3.put("CD_BIZAREA",		"");   //귀속사업장	
				ht21_3.put("CD_DEPT",		"");   //부서								 
				ht21_3.put("CD_CC",			"");   //코스트센터		
				ht21_3.put("CD_PJT",			"");   //프로젝트코드		
				ht21_3.put("CD_CARD",		"");   //신용카드		 	
				ht21_3.put("CD_EMPLOY",		"");   //사원									 		 
				ht21_3.put("NO_DEPOSIT",	"");  //예적금계좌
				ht21_3.put("CD_BANK",		"");  //금융기관	
				ht21_3.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht21_3.put("AM_TAXSTD",	"");  //과세표준액
				ht21_3.put("AM_ADDTAX",	"" );	 //세액
				ht21_3.put("TP_TAX",	"");  //과세(매출) :11
				ht21_3.put("NO_COMPANY",	""); //사업자등록번호
						
				ht21_3.put("NM_NOTE", doc_cont);  // 적요									
									
				vt_auto.add(ht21_3);  //  외상매출금									
					
				line++;
							
				Hashtable ht21 = new Hashtable();
				
				ht21.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht21.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht21.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht21.put("CD_PC",  	node_code);  //회계단위
				ht21.put("CD_WDEPT",  dept_code);  //부서
				ht21.put("NO_DOCU",  	"");  //미결은 '0' 
				ht21.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht21.put("CD_COMPANY",  "1000");  
				ht21.put("ID_WRITE", insert_id);   
				ht21.put("CD_DOCU",  "11");  
				
				ht21.put("DT_ACCT", 	cls.getCls_dt()); 
				ht21.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht21.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				
				if ( car_st.equals("1")  ) { //렌트이면
					ht21.put("CD_ACCT",  	"41200");  //해지정산금 통합
				} else {
					ht21.put("CD_ACCT",  	"41700");  //해지정산금 통합
				}	
				
				ht21.put("AMT",    String.valueOf( i_tax_supply ) );		
				ht21.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht21.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht21.put("DT_START",  "");  	//발생일자										 
				ht21.put("CD_BIZAREA",		"");   //귀속사업장	
				ht21.put("CD_DEPT",		"");   //부서								 
				ht21.put("CD_CC",			"");   //코스트센터		
				ht21.put("CD_PJT",			"");   //프로젝트코드		
				ht21.put("CD_CARD",		"");   //신용카드		 	
				ht21.put("CD_EMPLOY",		"");   //사원									 		 
				ht21.put("NO_DEPOSIT",	"");  //예적금계좌
				ht21.put("CD_BANK",		"");  //금융기관	
				ht21.put("NO_ITEM",		"");  //item	  
				
						// 부가세관련
				ht21.put("AM_TAXSTD",	"");  //과세표준액
				ht21.put("AM_ADDTAX",	"" );	 //세액
				ht21.put("TP_TAX",	"");  //과세(매출) :11
				ht21.put("NO_COMPANY",	""); //사업자등록번호	  	 
			
				ht21.put("NM_NOTE", doc_cont);  // 적요									
					
				vt_auto.add(ht21);  //  공급가
								
				line++;
				
				Hashtable ht21_2 = new Hashtable();
					
				ht21_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht21_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht21_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
				ht21_2.put("CD_PC",  	node_code);  //회계단위
				ht21_2.put("CD_WDEPT",  dept_code);  //부서
				ht21_2.put("NO_DOCU",  	"");  //미결은 '0' 
				ht21_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht21_2.put("CD_COMPANY",  "1000");  
				ht21_2.put("ID_WRITE", insert_id);   
				ht21_2.put("CD_DOCU",  "11");  
				
				ht21_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht21_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht21_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
				ht21_2.put("CD_ACCT",  		"25500");  //부가세예수금					
				ht21_2.put("AMT",   	String.valueOf( i_tax_value) );				
				ht21_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht21_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht21_2.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
				ht21_2.put("CD_BIZAREA",		"S101");   //귀속사업장	
				ht21_2.put("CD_DEPT",		"");   //부서								 
				ht21_2.put("CD_CC",			"");   //코스트센터		
				ht21_2.put("CD_PJT",			"");   //프로젝트코드		
				ht21_2.put("CD_CARD",		"");   //신용카드		 	
				ht21_2.put("CD_EMPLOY",		"");   //사원									 		 
				ht21_2.put("NO_DEPOSIT",	"");  //예적금계좌
				ht21_2.put("CD_BANK",		"");  //금융기관	
				ht21_2.put("NO_ITEM",		"");  //item	 	  	 
					
			// 부가세관련
				ht21_2.put("AM_TAXSTD",	String.valueOf(i_tax_supply));  //과세표준액
				ht21_2.put("AM_ADDTAX",	String.valueOf( i_tax_value) );	 //세액
				ht21_2.put("TP_TAX",	"11");  //과세(매출) :11
				if(ven_type.equals("1")){ //개인
					ht21_2.put("NO_COMPANY",	"8888888888"); // 개인사업자등록번호
				} else {
					ht21_2.put("NO_COMPANY",	s_idno); //사업자등록번호
				}								
				ht21_2.put("NM_NOTE", doc_cont);  // 적요	
							
				vt_auto.add(ht21_2);  // 부가세	
						
	   } 
		
		// 매출취소인 경우 원매출전표 발생일 (계산서 발행일로 )
		//세금계산서 취소건 - 매출 마이너스 (세금계산서 발행일이 전표생성일이어야 함)
		
	   if ( a3_s_amt < 0 ) {
	 
	 	//  렌트(리스)사업매출인 경우는 부가세처리 
	 	 	if (cls_st.equals("7") ) {
					 doc_cont = "출고전해지(신차) 대여료" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " 대여료" + "-" + car_no + " " + firm_nm;
		 	}	  
		     	 	  							
			line++;
						
			Hashtable ht7 = new Hashtable();
			
			ht7.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht7.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht7.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht7.put("CD_PC",  	node_code);  //회계단위
			ht7.put("CD_WDEPT",  dept_code);  //부서
			ht7.put("NO_DOCU",  	"");  //미결은 '0' 
			ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht7.put("CD_COMPANY",  "1000");  
			ht7.put("ID_WRITE", insert_id);   
			ht7.put("CD_DOCU",  "11");  
			
			ht7.put("DT_ACCT", 	cls.getCls_dt()); 
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
				
			ht7_1.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht7_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht7_1.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht7_1.put("CD_PC",  	node_code);  //회계단위
			ht7_1.put("CD_WDEPT",  dept_code);  //부서
			ht7_1.put("NO_DOCU",  	"");  //미결은 '0' 
			ht7_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht7_1.put("CD_COMPANY",  "1000");  
			ht7_1.put("ID_WRITE", insert_id);   
			ht7_1.put("CD_DOCU",  "11");  
			
			ht7_1.put("DT_ACCT", 	cls.getCls_dt()); 
			ht7_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht7_1.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			
			if ( car_st.equals("1")  ) { //렌트이면
					ht7_1.put("CD_ACCT",  	"41200");  //해지정산금 통합
			} else {
					ht7_1.put("CD_ACCT",  	"41700");  //해지정산금 통합
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
			
			ht7_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht7_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht7_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
			ht7_2.put("CD_PC",  node_code);  //회계단위
			ht7_2.put("CD_WDEPT",  dept_code);  //부서
			ht7_2.put("NO_DOCU",  	"");  //미결은 '0' 
			ht7_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht7_2.put("CD_COMPANY",  "1000");  
			ht7_2.put("ID_WRITE", insert_id);   
			ht7_2.put("CD_DOCU",  "11");  
			
			ht7_2.put("DT_ACCT", 	cls.getCls_dt()); 
			ht7_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht7_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
			ht7_2.put("CD_ACCT",  		"25500");  //부가세예수금					
			ht7_2.put("AMT",   		String.valueOf( a3_v_amt) );						
			ht7_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht7_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht7_2.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
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
			if(ven_type.equals("1")){ //개인
				ht7_2.put("NO_COMPANY",	"8888888888"); //사업자등록번호
			} else {
				ht7_2.put("NO_COMPANY",	s_idno); //사업자등록번호
			}
											
			ht7_2.put("NM_NOTE", doc_cont);  // 적요	
									
			vt_m_auto.add(ht7_2);  // 부가세	
				
			line =0;	
	 
	  }
	   	
		 //-----------------선납금액 관련 ------------------------	
	String jung_st = request.getParameter("jung_st")==null?"1":request.getParameter("jung_st");		 //합계정산인경우만 전표
		
	   	//선수금 - 보증금 	
	   	if ( AddUtil.parseDigit(request.getParameter("grt_amt"))  > 0 ) {
	  
	  		if (cls_st.equals("7") ) {
					 doc_cont = "출고전해지(신차) 보증금" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " 보증금" + "-" + car_no + " " + firm_nm;
		 	}	
		 			
			line++;
						
			Hashtable ht2_1 = new Hashtable();
			
			ht2_1.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht2_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht2_1.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht2_1.put("CD_PC",  	node_code);  //회계단위
			ht2_1.put("CD_WDEPT",  dept_code);  //부서
			ht2_1.put("NO_DOCU",  	"");  //미결은 '0' 
			ht2_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht2_1.put("CD_COMPANY",  "1000");  
			ht2_1.put("ID_WRITE", insert_id);   
			ht2_1.put("CD_DOCU",  "11");  
			
			ht2_1.put("DT_ACCT", 	cls.getCls_dt()); 
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
			
			vt_auto.add(ht2_1);  //
		} 	
		  
	      //선수금 - 잔여개시대여료 
	   	if ( AddUtil.parseDigit(request.getParameter("rifee_s_amt")) > 0 ) {
	   	  
	   	  	if (cls_st.equals("7") ) {
					 doc_cont = "출고전해지(신차) 개시대여료" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " 개시대여료" + "-" + car_no + " " + firm_nm;
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
					
		/*	사용안함 - 20140101	
		
			line++;				
			Hashtable ht2_2 = new Hashtable();
			
			ht2_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht2_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht2_2.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht2_2.put("CD_PC",  node_code);  //회계단위
			ht2_2.put("CD_WDEPT",  dept_code);  //부서
			ht2_2.put("NO_DOCU",  	"");  //미결은 '0' 
			ht2_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht2_2.put("CD_COMPANY",  "1000");  
			ht2_2.put("ID_WRITE", insert_id);   
			ht2_2.put("CD_DOCU",  "11");  
			
			ht2_2.put("DT_ACCT", 	cls.getCls_dt()); 
			ht2_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht2_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			
			
			if ( car_st.equals("1")  ) { //렌트이면
				ht2_2.put("CD_ACCT",  	"41200");  //해지정산금 통합
			} else {
				ht2_2.put("CD_ACCT",  	"41700");  //해지정산금 통합
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
			
			ht3_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht3_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht3_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
			ht3_2.put("CD_PC",  	node_code);  //회계단위
			ht3_2.put("CD_WDEPT",  dept_code);  //부서
			ht3_2.put("NO_DOCU",  	"");  //미결은 '0' 
			ht3_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht3_2.put("CD_COMPANY",  "1000");  
			ht3_2.put("ID_WRITE", insert_id);   
			ht3_2.put("CD_DOCU",  "11");  
			
			ht3_2.put("DT_ACCT", 	cls.getCls_dt()); 
			ht3_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht3_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
			ht3_2.put("CD_ACCT",  		"25500");  //부가세예수금					
			ht3_2.put("AMT",   		String.valueOf( a1_v_amt) );							
			ht3_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht3_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht3_2.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
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
		
			if(ven_type.equals("1")){ //개인
				ht3_2.put("NO_COMPANY",	"8888888888"); //사업자등록번호
			} else {
				ht3_2.put("NO_COMPANY",	s_idno); //사업자등록번호
			}								
			ht3_2.put("NM_NOTE", doc_cont);  // 적요	
								
			vt_auto.add(ht3_2);  // 부가세	   
		*/
		
			
	    } 
	   	  
	   	  //선수금 - 잔여선납금 
	   if ( AddUtil.parseDigit(request.getParameter("rfee_s_amt")) > 0 ) {
	   	  
	   	  	if (cls_st.equals("7") ) {
					 doc_cont = "출고전해지(신차) 선납금" + "-" + rent_l_cd + " " + firm_nm;
			} else {
				if (pp_chk.equals("0") ) {
					 doc_cont =  cls.getCls_st()  + " 선납금 균등" + "-" + car_no + " " + firm_nm;
				} else {
					 doc_cont =  cls.getCls_st()  + " 선납금" + "-" + car_no + " " + firm_nm;
				} 				
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
			
			if (pp_chk.equals("0") ) {
				ht3_4.put("CD_ACCT",  "25900");   //선납금 - 선수금  균등 
			} else {
				ht3_4.put("CD_ACCT",  "10800");   //선납금 - 외상매출금 
			}
						
		//	ht3_4.put("CD_ACCT",  	"10800");  //외상매출금	
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
				
	/*			
			line++;
						
			Hashtable ht2_3 = new Hashtable();
			
			ht2_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht2_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht2_3.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht2_3.put("CD_PC",  node_code);  //회계단위
			ht2_3.put("CD_WDEPT",  dept_code);  //부서
			ht2_3.put("NO_DOCU",  	"");  //미결은 '0' 
			ht2_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht2_3.put("CD_COMPANY",  "1000");  
			ht2_3.put("ID_WRITE", insert_id);   
			ht2_3.put("CD_DOCU",  "11");  
			
			ht2_3.put("DT_ACCT", 	cls.getCls_dt()); 
			ht2_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht2_3.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			
			if ( car_st.equals("1")  ) { //렌트이면
				ht2_3.put("CD_ACCT",  	"41200");  //해지정산금 통합
			} else {
				ht2_3.put("CD_ACCT",  	"41700");  //해지정산금 통합
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
			
			ht3_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht3_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht3_3.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
			ht3_3.put("CD_PC",  node_code);  //회계단위
			ht3_3.put("CD_WDEPT",  dept_code);  //부서
			ht3_3.put("NO_DOCU",  	"");  //미결은 '0' 
			ht3_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht3_3.put("CD_COMPANY",  "1000");  
			ht3_3.put("ID_WRITE", insert_id);   
			ht3_3.put("CD_DOCU",  "11");  
			
			ht3_3.put("DT_ACCT", 	cls.getCls_dt()); 
			ht3_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht3_3.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
			ht3_3.put("CD_ACCT",  		"25500");  //부가세예수금					
			ht3_3.put("AMT",   		String.valueOf( a2_v_amt) );								
			ht3_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht3_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht3_3.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
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
			if(ven_type.equals("1")){ //개인
				ht3_3.put("NO_COMPANY",	"8888888888"); //사업자등록번호
			} else {	
				ht3_3.put("NO_COMPANY",	s_idno); //사업자등록번호
			}								
			ht3_3.put("NM_NOTE", doc_cont);  // 적요	
							
			vt_auto.add(ht3_3);  // 부가세		
	*/		
	   }
	   
	 	  int  ex_ip_amt 		= request.getParameter("ex_ip_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ex_ip_amt"));	//추가입금액 	
	    
	   	//추가입금 	   
	         if ( ex_ip_amt > 0 ) {
	  		if (cls_st.equals("7") ) {
					 doc_cont = "출고전해지(신차) 추가입금" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " 추가입금" + "-" + car_no + " " + firm_nm;
		 	}	
		 			
			line++;
						
			Hashtable ht3_5 = new Hashtable();
			
			ht3_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht3_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht3_5.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht3_5.put("CD_PC",  	node_code);  //회계단위
			ht3_5.put("CD_WDEPT",  dept_code);  //부서
			ht3_5.put("NO_DOCU",  	"");  //미결은 '0' 
			ht3_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht3_5.put("CD_COMPANY",  "1000");  
			ht3_5.put("ID_WRITE", insert_id);   
			ht3_5.put("CD_DOCU",  "11");  
			
			ht3_5.put("DT_ACCT", 	cls.getCls_dt()); 
			ht3_5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht3_5.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
			ht3_5.put("CD_ACCT",  	"25900");  //가수금-> 선수금
			ht3_5.put("AMT",    	String.valueOf(ex_ip_amt )  );	
			ht3_5.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht3_5.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht3_5.put("DT_START",  "");  	//발생일자										 
			ht3_5.put("CD_BIZAREA",		"");   //귀속사업장	
			ht3_5.put("CD_DEPT",		"");   //부서								 
			ht3_5.put("CD_CC",			"");   //코스트센터		
			ht3_5.put("CD_PJT",			"");   //프로젝트코드		
			ht3_5.put("CD_CARD",		"");   //신용카드		 	
			ht3_5.put("CD_EMPLOY",		"");   //사원									 		 
			ht3_5.put("NO_DEPOSIT",	"");  //예적금계좌
			ht3_5.put("CD_BANK",		"");  //금융기관	
			ht3_5.put("NO_ITEM",		"");  //item	  	 
			
				// 부가세관련
			ht3_5.put("AM_TAXSTD",	"");  //과세표준액
			ht3_5.put("AM_ADDTAX",	"" );	 //세액
			ht3_5.put("TP_TAX",	"");  //과세(매출) :11
			ht3_5.put("NO_COMPANY",	""); //사업자등록번호
					
			ht3_5.put("NM_NOTE", doc_cont);  // 적요									
			
			vt_auto.add(ht3_5);  //
		} 	 
	      
	   //-----------------미납금액 관련 ------------------------
	// 구분정산이 아니면
	//if ( !jung_st.equals("2") ) {		  		  

		 // 과태료 상계 -  미수금
	   if ( AddUtil.parseDigit(request.getParameter("fine_amt_2")) > 0 ) {
		 	
		 	if (cls_st.equals("7") ) {
					 doc_cont = "출고전해지(신차) 과태료" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " 과태료" + "-" + car_no + " " + firm_nm;
		 	}		 
		 					
			line++;
			
			Hashtable ht4 = new Hashtable();
			
			ht4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht4.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht4.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht4.put("CD_PC",  	node_code);  //회계단위
			ht4.put("CD_WDEPT",  dept_code);  //부서
			ht4.put("NO_DOCU",  	"");  //미결은 '0' 
			ht4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht4.put("CD_COMPANY",  "1000");  
			ht4.put("ID_WRITE", insert_id);   
			ht4.put("CD_DOCU",  "11");  
			
			ht4.put("DT_ACCT", 	cls.getCls_dt()); 
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
	 	   
	 	   if (cls_st.equals("7") ) {
					 doc_cont = "출고전해지(신차) 면책금" + "-" + rent_l_cd + " " + firm_nm;
		   } else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " 면책금" + "-" + car_no + " " + firm_nm;
		   }	
				
	 	   if ( amt_10800 > 0) {  //외상매출금이 있는 경우만 
		 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
		 	  
				line++;
							
				Hashtable ht5_1 = new Hashtable();
				
				ht5_1.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht5_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht5_1.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht5_1.put("CD_PC",  	node_code);  //회계단위
				ht5_1.put("CD_WDEPT",  dept_code);  //부서
				ht5_1.put("NO_DOCU",  	"");  //미결은 '0' 
				ht5_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht5_1.put("CD_COMPANY",  "1000");  
				ht5_1.put("ID_WRITE", insert_id);   
				ht5_1.put("CD_DOCU",  "11");  
				
				ht5_1.put("DT_ACCT", 	cls.getCls_dt()); 
				ht5_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			//	ht5_1.put("TP_DRCR",   "2");   // 대변:2 , 차변:1	
			//	ht5_1.put("CD_ACCT",  	"91800");  //면책금 
			//	ht5_1.put("AMT",   String.valueOf( amt_10800) );	
				
				ht5_1.put("TP_DRCR",   "1");   // 대변:2 , 차변:1	
				ht5_1.put("CD_ACCT",  	"45510");  //면책금 - > 차량수리정비비(45510)로 처리 ->20211116변경 
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
		   		
		   		ht5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht5.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht5.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht5.put("CD_PC",  	node_code);  //회계단위
				ht5.put("CD_WDEPT",  dept_code);  //부서
				ht5.put("NO_DOCU",  	"");  //미결은 '0' 
				ht5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht5.put("CD_COMPANY",  "1000");  
				ht5.put("ID_WRITE", insert_id);   
				ht5.put("CD_DOCU",  "11");  
				
				ht5.put("DT_ACCT", 	cls.getCls_dt()); 
				ht5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				
			//	ht5.put("TP_DRCR",   "2");   // 대변:2 , 차변:1		
			//	ht5.put("CD_ACCT",  	"91800");  //차량손해면책금
			//	ht5.put("AMT",  	String.valueOf( AddUtil.parseDigit(request.getParameter("car_ja_amt_2")) ));		//입금액으로 변경 - 160422
				
				ht5.put("TP_DRCR",   "1");   // 대변:2 , 차변:1		
				ht5.put("CD_ACCT",  	"45510");  //차량손해면책금
				ht5.put("AMT",  	String.valueOf( AddUtil.parseDigit(request.getParameter("car_ja_amt_2")) * (-1) ));		//입금액으로 변경 - 160422
				
					
			//	ht5.put("AMT",  	String.valueOf( car_ja_no_amt ));				
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
	  	
		  	if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 연체료" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
			 	      		  doc_cont =  cls.getCls_st()  + " 연체료" + "-" + car_no + " " + firm_nm;
			}	
		 			
			line++;
				 				   		
	   		Hashtable ht6 = new Hashtable();
	   		
			ht6.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht6.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht6.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht6.put("CD_PC",  	node_code);  //회계단위
			ht6.put("CD_WDEPT",  dept_code);  //부서
			ht6.put("NO_DOCU",  	"");  //미결은 '0' 
			ht6.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht6.put("CD_COMPANY",  "1000");  
			ht6.put("ID_WRITE", insert_id);   
			ht6.put("CD_DOCU",  "11");  
			
			ht6.put("DT_ACCT", 	cls.getCls_dt()); 
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
	 		if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 대여료" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
			 	      		  doc_cont =  cls.getCls_st()  + " 대여료" + "-" + car_no + " " + firm_nm;
			}	
			
			if ( AddUtil.parseDigit(request.getParameter("dfee_amt_2"))  == 0 ) { 	 //상계가 없으면 외상매출금 추가 
				
					line++;
							
					Hashtable ht8_3 = new Hashtable();
					
					ht8_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht8_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht8_3.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht8_3.put("CD_PC",  node_code);  //회계단위
					ht8_3.put("CD_WDEPT",  dept_code);  //부서
					ht8_3.put("NO_DOCU",  	"");  //미결은 '0' 
					ht8_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht8_3.put("CD_COMPANY",  "1000");  
					ht8_3.put("ID_WRITE", insert_id);   
					ht8_3.put("CD_DOCU",  "11");  
					
					ht8_3.put("DT_ACCT", 	cls.getCls_dt()); 
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
			
			ht8_1.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht8_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_1.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht8_1.put("CD_PC",  	node_code);  //회계단위
			ht8_1.put("CD_WDEPT",  dept_code);  //부서
			ht8_1.put("NO_DOCU",  	"");  //미결은 '0' 
			ht8_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht8_1.put("CD_COMPANY",  "1000");  
			ht8_1.put("ID_WRITE", insert_id);   
			ht8_1.put("CD_DOCU",  "11");  
			
			ht8_1.put("DT_ACCT", 	cls.getCls_dt()); 
			ht8_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht8_1.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
			
			if ( car_st.equals("1")  ) { //렌트이면
					ht8_1.put("CD_ACCT",  	"41200");  //해지정산금 통합
			} else {
					ht8_1.put("CD_ACCT",  	"41700");  //해지정산금 통합
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
				
			ht8_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht8_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
			ht8_2.put("CD_PC",  	node_code);  //회계단위
			ht8_2.put("CD_WDEPT",  dept_code);  //부서
			ht8_2.put("NO_DOCU",  	"");  //미결은 '0' 
			ht8_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht8_2.put("CD_COMPANY",  "1000");  
			ht8_2.put("ID_WRITE", insert_id);   
			ht8_2.put("CD_DOCU",  "11");  
			
			ht8_2.put("DT_ACCT", 	cls.getCls_dt()); 
			ht8_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht8_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
			ht8_2.put("CD_ACCT",  		"25500");  //부가세예수금					
			ht8_2.put("AMT",   		String.valueOf( a4_v_amt) );								
			ht8_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
			ht8_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
										
			ht8_2.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
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
			if(ven_type.equals("1")){ //개인
				ht8_2.put("NO_COMPANY",	"8888888888"); //사업자등록번호
			} else {
				ht8_2.put("NO_COMPANY",	s_idno); //사업자등록번호
			}								
			ht8_2.put("NM_NOTE", doc_cont);  // 적요	
						
			vt_auto.add(ht8_2);  // 부가세	
			
	  }
	 	 	 
	  //대여료 외상매출금 상계 - 외상매출금, 리스/렌트 사업매출 구분하여 처리 - 선납인경우는 대변에 마이너스금액
	  if ( AddUtil.parseDigit(request.getParameter("dfee_amt_2"))  < 0 ) {
	 	 		
	 	   amt_10800 = AddUtil.parseDigit(request.getParameter("dfee_amt_2")) + AddUtil.parseDigit(request.getParameter("dfee_amt_2_v"))- a4_s_amt - a4_v_amt;
	 	   
	 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
		 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
			 	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 대여료" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " 대여료" + "-" + car_no + " " + firm_nm;
				}	
				 	  			
				line++;
							
				Hashtable ht8 = new Hashtable();
					
				ht8.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht8.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht8.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht8.put("CD_PC",  	node_code);  //회계단위
				ht8.put("CD_WDEPT",  dept_code);  //부서
				ht8.put("NO_DOCU",  	"");  //미결은 '0' 
				ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht8.put("CD_COMPANY",  "1000");  
				ht8.put("ID_WRITE", insert_id);   
				ht8.put("CD_DOCU",  "11");  
				
				ht8.put("DT_ACCT", 	cls.getCls_dt()); 
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
			 	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 대여료" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " 대여료" + "-" + car_no + " " + firm_nm;
				}	
		 	  					
				line++;
							
				Hashtable ht8_5 = new Hashtable();
				
				ht8_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht8_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht8_5.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht8_5.put("CD_PC",  	node_code);  //회계단위
				ht8_5.put("CD_WDEPT",  dept_code);  //부서
				ht8_5.put("NO_DOCU",  	"");  //미결은 '0' 
				ht8_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht8_5.put("CD_COMPANY",  "1000");  
				ht8_5.put("ID_WRITE", insert_id);   
				ht8_5.put("CD_DOCU",  "11");  
				
				ht8_5.put("DT_ACCT", 	cls.getCls_dt()); 
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
			 	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 대여료" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " 대여료" + "-" + car_no + " " + firm_nm;
				}	
					 	  			
				line++;
							
				Hashtable ht8_7 = new Hashtable();
				
				ht8_7.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht8_7.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht8_7.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht8_7.put("CD_PC",  node_code);  //회계단위
				ht8_7.put("CD_WDEPT",  dept_code);  //부서
				ht8_7.put("NO_DOCU",  	"");  //미결은 '0' 
				ht8_7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht8_7.put("CD_COMPANY",  "1000");  
				ht8_7.put("ID_WRITE", insert_id);   
				ht8_7.put("CD_DOCU",  "11");  
				
				ht8_7.put("DT_ACCT", 	cls.getCls_dt()); 
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
	     	 
	//중도해지위약금 세금 계산서 발행건 처리   
	  if ( a5_s_amt > 0 ) {
		 
		 	//  렌트(리스)사업매출인 경우는 부가세처리 
			 	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 해지위약금" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " 해지위약금" + "-" + car_no + " " + firm_nm;
				}	
				 	  
				if ( AddUtil.parseDigit(request.getParameter("dft_amt_2"))  < 1 ) { 	  //외상매출금 추가
				
					line++;
							
					Hashtable ht9_3 = new Hashtable();
					
					ht9_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht9_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht9_3.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht9_3.put("CD_PC",  	node_code);  //회계단위
					ht9_3.put("CD_WDEPT",  dept_code);  //부서
					ht9_3.put("NO_DOCU",  	"");  //미결은 '0' 
					ht9_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht9_3.put("CD_COMPANY",  "1000");  
					ht9_3.put("ID_WRITE", insert_id);   
					ht9_3.put("CD_DOCU",  "11");  
					
					ht9_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht9_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht9_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht9_3.put("CD_ACCT",  "10800");   // 
					ht9_3.put("AMT",    		String.valueOf( a5_s_amt + a5_v_amt ));
					ht9_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht9_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06
												
					ht9_3.put("DT_START",  "");  	//발생일자										 
					ht9_3.put("CD_BIZAREA",		"");   //귀속사업장	
					ht9_3.put("CD_DEPT",		"");   //부서								 
					ht9_3.put("CD_CC",			"");   //코스트센터		
					ht9_3.put("CD_PJT",			"");   //프로젝트코드		
					ht9_3.put("CD_CARD",		"");   //신용카드		 	
					ht9_3.put("CD_EMPLOY",		"");   //사원									 		 
					ht9_3.put("NO_DEPOSIT",	"");  //예적금계좌
					ht9_3.put("CD_BANK",		"");  //금융기관	
					ht9_3.put("NO_ITEM",		"");  //item	  	 
					
						// 부가세관련
					ht9_3.put("AM_TAXSTD",	"");  //과세표준액
					ht9_3.put("AM_ADDTAX",	"" );	 //세액
					ht9_3.put("TP_TAX",	"");  //과세(매출) :11
					ht9_3.put("NO_COMPANY",	""); //사업자등록번호
							
					ht9_3.put("NM_NOTE", doc_cont);  // 적요									
											
					vt_auto.add(ht9_3);  //  외상매출금						
				}	
				
				line++;
							
				Hashtable ht9 = new Hashtable();
					
				ht9.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht9.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht9.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht9.put("CD_PC",  	node_code);  //회계단위
				ht9.put("CD_WDEPT",  dept_code);  //부서
				ht9.put("NO_DOCU",  	"");  //미결은 '0' 
				ht9.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht9.put("CD_COMPANY",  "1000");  
				ht9.put("ID_WRITE", insert_id);   
				ht9.put("CD_DOCU",  "11");  
				
				ht9.put("DT_ACCT", 	cls.getCls_dt()); 
				ht9.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht9.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				
				if ( car_st.equals("1")  ) { //렌트이면
						ht9.put("CD_ACCT",  	"41200");  //위약금  //41200  41410
				} else {
						ht9.put("CD_ACCT",  	"41700");  //위약금  //41700  41810
				}	
				
				ht9.put("AMT",    	String.valueOf( a5_s_amt ) );			
				ht9.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht9.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht9.put("DT_START",  "");  	//발생일자										 
				ht9.put("CD_BIZAREA",		"");   //귀속사업장	
				ht9.put("CD_DEPT",		"");   //부서								 
				ht9.put("CD_CC",			"");   //코스트센터		
				ht9.put("CD_PJT",			"");   //프로젝트코드		
				ht9.put("CD_CARD",		"");   //신용카드		 	
				ht9.put("CD_EMPLOY",		"");   //사원									 		 
				ht9.put("NO_DEPOSIT",	"");  //예적금계좌
				ht9.put("CD_BANK",		"");  //금융기관	
				ht9.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht9.put("AM_TAXSTD",	"");  //과세표준액
				ht9.put("AM_ADDTAX",	"" );	 //세액
				ht9.put("TP_TAX",	"");  //과세(매출) :11
				ht9.put("NO_COMPANY",	""); //사업자등록번호
						
				ht9.put("NM_NOTE", doc_cont);  // 적요									
									
				vt_auto.add(ht9);  //  공급가
				
				line++;
				
				Hashtable ht9_2 = new Hashtable();
					
				ht9_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht9_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht9_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
				ht9_2.put("CD_PC",  	node_code);  //회계단위
				ht9_2.put("CD_WDEPT",  dept_code);  //부서
				ht9_2.put("NO_DOCU",  	"");  //미결은 '0' 
				ht9_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht9_2.put("CD_COMPANY",  "1000");  
				ht9_2.put("ID_WRITE", insert_id);   
				ht9_2.put("CD_DOCU",  "11");  
				
				ht9_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht9_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht9_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
				ht9_2.put("CD_ACCT",  		"25500");  //부가세예수금					
				ht9_2.put("AMT",   		String.valueOf( a5_v_amt ) );								
				ht9_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht9_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht9_2.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
				ht9_2.put("CD_BIZAREA",		"S101");   //귀속사업장	
				ht9_2.put("CD_DEPT",		"");   //부서								 
				ht9_2.put("CD_CC",			"");   //코스트센터		
				ht9_2.put("CD_PJT",			"");   //프로젝트코드		
				ht9_2.put("CD_CARD",		"");   //신용카드		 	
				ht9_2.put("CD_EMPLOY",		"");   //사원									 		 
				ht9_2.put("NO_DEPOSIT",	"");  //예적금계좌
				ht9_2.put("CD_BANK",		"");  //금융기관	
				ht9_2.put("NO_ITEM",		"");  //item	 	  	 
					
			// 부가세관련
				ht9_2.put("AM_TAXSTD",	 String.valueOf( a5_s_amt) );		 //과세표준액
				ht9_2.put("AM_ADDTAX",	String.valueOf( a5_v_amt) );		 //세액
				ht9_2.put("TP_TAX",	"11");  //과세(매출) :11
				if(ven_type.equals("1")){ //개인
					ht9_2.put("NO_COMPANY",	"8888888888"); //사업자등록번호
				} else {
					ht9_2.put("NO_COMPANY",	s_idno); //사업자등록번호
				}									
				ht9_2.put("NM_NOTE", doc_cont);  // 적요	
								
				vt_auto.add(ht9_2);  // 부가세					
						 	
				//해지위약금 일부 상계 - 외상매출금, 리스/렌트 사업매출 구분하여 처리 
			    if ( AddUtil.parseDigit(request.getParameter("dft_amt_2"))  > 0 ) {
			 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("dft_amt_2")) + AddUtil.parseDigit(request.getParameter("dft_amt_2_v"))- a5_s_amt - a5_v_amt;
			 	   
			 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
				 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
				 	  	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 해지위약금" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	  doc_cont =  cls.getCls_st()  + " 해지위약금" + "-" + car_no + " " + firm_nm;
						}	
							
						line++;
									
						Hashtable ht9_4 = new Hashtable();
							
						ht9_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht9_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht9_4.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht9_4.put("CD_PC",  	node_code);  //회계단위
						ht9_4.put("CD_WDEPT",  dept_code);  //부서
						ht9_4.put("NO_DOCU",  	"");  //미결은 '0' 
						ht9_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht9_4.put("CD_COMPANY",  "1000");  
						ht9_4.put("ID_WRITE", insert_id);   
						ht9_4.put("CD_DOCU",  "11");  
						
						ht9_4.put("DT_ACCT", 	cls.getCls_dt()); 
						ht9_4.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						ht9_4.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
						ht9_4.put("CD_ACCT",  "10800");   // 
						ht9_4.put("AMT",    	String.valueOf( amt_10800 * (-1) ));
						ht9_4.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
						ht9_4.put("CD_PARTNER",	i_ven_code); //거래처    - A06
													
						ht9_4.put("DT_START",  "");  	//발생일자										 
						ht9_4.put("CD_BIZAREA",		"");   //귀속사업장	
						ht9_4.put("CD_DEPT",		"");   //부서								 
						ht9_4.put("CD_CC",			"");   //코스트센터		
						ht9_4.put("CD_PJT",			"");   //프로젝트코드		
						ht9_4.put("CD_CARD",		"");   //신용카드		 	
						ht9_4.put("CD_EMPLOY",		"");   //사원									 		 
						ht9_4.put("NO_DEPOSIT",	"");  //예적금계좌
						ht9_4.put("CD_BANK",		"");  //금융기관	
						ht9_4.put("NO_ITEM",		"");  //item	  	 
						
							// 부가세관련
						ht9_4.put("AM_TAXSTD",	"");  //과세표준액
						ht9_4.put("AM_ADDTAX",	"" );	 //세액
						ht9_4.put("TP_TAX",	"");  //과세(매출) :11
						ht9_4.put("NO_COMPANY",	""); //사업자등록번호
								
						ht9_4.put("NM_NOTE", doc_cont);  // 적요									
												
						vt_auto.add(ht9_4);  //  외상매출금
					}	
							
			  }
		
		 // 세금계산서 발행이 안되었을 경우
		 } else {
		 
		 	  // 해지수익 세금 계산서 미리 발행건일 수도 있음 - 이때는 외상매출금 
			 if ( clse.getTax_chk0().equals("Y")) {
		  		 
		  		 if ( AddUtil.parseDigit(request.getParameter("dft_amt_2"))  > 0 ) {
					 
					 	   amt_10800 = AddUtil.parseDigit(request.getParameter("dft_amt_2")) + AddUtil.parseDigit(request.getParameter("dft_amt_2_v"));
					 	   
					 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
						 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
							 	if (cls_st.equals("7") ) {
									 doc_cont = "출고전해지(신차) 해지위약금" + "-" + rent_l_cd + " " + firm_nm;
								} else {		 
								 	   doc_cont =  cls.getCls_st()  + " 해지위약금" + "-" + car_no + " " + firm_nm;
								}	
						 							
								line++;
											
								Hashtable ht9_5 = new Hashtable();
								
								ht9_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
								ht9_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
								ht9_5.put("NO_TAX",  	"*");  //부가세 이외는 *
								ht9_5.put("CD_PC",  	node_code);  //회계단위
								ht9_5.put("CD_WDEPT",  dept_code);  //부서
								ht9_5.put("NO_DOCU",  	"");  //미결은 '0' 
								ht9_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
								ht9_5.put("CD_COMPANY",  "1000");  
								ht9_5.put("ID_WRITE", insert_id);   
								ht9_5.put("CD_DOCU",  "11");  
								
								ht9_5.put("DT_ACCT", 	cls.getCls_dt()); 
								ht9_5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
								ht9_5.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
								ht9_5.put("CD_ACCT",  "10800");   // 
								ht9_5.put("AMT",    	String.valueOf( amt_10800) );					
								ht9_5.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
								ht9_5.put("CD_PARTNER",	i_ven_code); //거래처    - A06
															
								ht9_5.put("DT_START",  "");  	//발생일자										 
								ht9_5.put("CD_BIZAREA",		"");   //귀속사업장	
								ht9_5.put("CD_DEPT",		"");   //부서								 
								ht9_5.put("CD_CC",			"");   //코스트센터		
								ht9_5.put("CD_PJT",			"");   //프로젝트코드		
								ht9_5.put("CD_CARD",		"");   //신용카드		 	
								ht9_5.put("CD_EMPLOY",		"");   //사원									 		 
								ht9_5.put("NO_DEPOSIT",	"");  //예적금계좌
								ht9_5.put("CD_BANK",		"");  //금융기관	
								ht9_5.put("NO_ITEM",		"");  //item	  	 
								
									// 부가세관련
								ht9_5.put("AM_TAXSTD",	"");  //과세표준액
								ht9_5.put("AM_ADDTAX",	"" );	 //세액
								ht9_5.put("TP_TAX",	"");  //과세(매출) :11
								ht9_5.put("NO_COMPANY",	""); //사업자등록번호
										
								ht9_5.put("NM_NOTE", doc_cont);  // 적요									
													
								vt_auto.add(ht9_5);  //  외상매출금
							}								
				  }	 		 	
		  
		     } else { //면책금 계정이면
		 	 
				if ( AddUtil.parseDigit(request.getParameter("dft_amt_2"))  > 0 ) { 	 	 	 	   
			 	// 세금계산서 발행분을 제외한 부분을 해지수익으로
				 	if (cls_st.equals("7") ) {
								 doc_cont = "출고전해지(신차) 해지위약금" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	      		  doc_cont =  cls.getCls_st()  + " 해지위약금" + "-" + car_no + " " + firm_nm;
					}	
						
					line++;
								
					Hashtable ht10 = new Hashtable();
					
					ht10.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht10.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht10.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht10.put("CD_PC",  	node_code);  //회계단위
					ht10.put("CD_WDEPT",  dept_code);  //부서
					ht10.put("NO_DOCU",  	"");  //미결은 '0' 
					ht10.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht10.put("CD_COMPANY",  "1000");  
					ht10.put("ID_WRITE", insert_id);   
					ht10.put("CD_DOCU",  "11");  
					
					ht10.put("DT_ACCT", 	cls.getCls_dt()); 
					ht10.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht10.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
					
					if ( car_st.equals("1")  ) { //렌트이면
							ht10.put("CD_ACCT",  	"41400");  //해지수익
					} else {
							ht10.put("CD_ACCT",  	"41800");  //해지수익
					}	
					
					ht10.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("dft_amt_2")) ) );				
					ht10.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht10.put("CD_PARTNER",	"000131"); //거래처    - 아마존카
												
					ht10.put("DT_START",  "");  	//발생일자										 
					ht10.put("CD_BIZAREA",		"");   //귀속사업장	
					ht10.put("CD_DEPT",		"");   //부서								 
					ht10.put("CD_CC",			"");   //코스트센터		
					ht10.put("CD_PJT",			"");   //프로젝트코드		
					ht10.put("CD_CARD",		"");   //신용카드		 	
					ht10.put("CD_EMPLOY",		"");   //사원									 		 
					ht10.put("NO_DEPOSIT",	"");  //예적금계좌
					ht10.put("CD_BANK",		"");  //금융기관	
					ht10.put("NO_ITEM",		"");  //item	  	 
					
						// 부가세관련
					ht10.put("AM_TAXSTD",	"");  //과세표준액
					ht10.put("AM_ADDTAX",	"" );	 //세액
					ht10.put("TP_TAX",	"");  //과세(매출) :11
					ht10.put("NO_COMPANY",	""); //사업자등록번호
							
					ht10.put("NM_NOTE", doc_cont);  // 적요									
										
					vt_auto.add(ht10);  //  공급가			
			  }				 
		 
		 }
		 
	  } 	 	 

	  
	 /* 
	 if ( a6_s_amt > 0 ) {
		 
		 	//  렌트(리스)사업매출인 경우는 부가세처리
		 		if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 차량회수비용" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " 차량회수비용" + "-" + car_no + " " + firm_nm;
				}	
			 	  			
				if ( AddUtil.parseDigit(request.getParameter("etc_amt_2"))  < 1 ) { 	  //외상매출금 추가
				
					line++;
							
					Hashtable ht11_3 = new Hashtable();
					
					ht11_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht11_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht11_3.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht11_3.put("CD_PC",  	node_code);  //회계단위
					ht11_3.put("CD_WDEPT",  dept_code);  //부서
					ht11_3.put("NO_DOCU",  	"");  //미결은 '0' 
					ht11_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht11_3.put("CD_COMPANY",  "1000");  
					ht11_3.put("ID_WRITE", insert_id);   
					ht11_3.put("CD_DOCU",  "11");  
					
					ht11_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht11_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht11_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht11_3.put("CD_ACCT",  "10800");   // 
					ht11_3.put("AMT",    	String.valueOf( a6_s_amt + a6_v_amt) );			
					ht11_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht11_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06
												
					ht11_3.put("DT_START",  "");  	//발생일자										 
					ht11_3.put("CD_BIZAREA",		"");   //귀속사업장	
					ht11_3.put("CD_DEPT",		"");   //부서								 
					ht11_3.put("CD_CC",			"");   //코스트센터		
					ht11_3.put("CD_PJT",			"");   //프로젝트코드		
					ht11_3.put("CD_CARD",		"");   //신용카드		 	
					ht11_3.put("CD_EMPLOY",		"");   //사원									 		 
					ht11_3.put("NO_DEPOSIT",	"");  //예적금계좌
					ht11_3.put("CD_BANK",		"");  //금융기관	
					ht11_3.put("NO_ITEM",		"");  //item	  	 
					
						// 부가세관련
					ht11_3.put("AM_TAXSTD",	"");  //과세표준액
					ht11_3.put("AM_ADDTAX",	"" );	 //세액
					ht11_3.put("TP_TAX",	"");  //과세(매출) :11
					ht11_3.put("NO_COMPANY",	""); //사업자등록번호
							
					ht11_3.put("NM_NOTE", doc_cont);  // 적요					
													
					vt_auto.add(ht11_3);  //  외상매출금
							
				}	
					
				line++;
							
				Hashtable ht11 = new Hashtable();
					
				ht11.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht11.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht11.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht11.put("CD_PC",  	node_code);  //회계단위
				ht11.put("CD_WDEPT",  dept_code);  //부서
				ht11.put("NO_DOCU",  	"");  //미결은 '0' 
				ht11.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht11.put("CD_COMPANY",  "1000");  
				ht11.put("ID_WRITE", insert_id);   
				ht11.put("CD_DOCU",  "11");  
				
				ht11.put("DT_ACCT", 	cls.getCls_dt()); 
				ht11.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht11.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				
				if ( car_st.equals("1")  ) { //렌트이면
						ht11.put("CD_ACCT",  	"41200");  //차량외주비용 통합
				} else {
						ht11.put("CD_ACCT",  	"41700");  //차량외주비용 통합
				}	
				
				ht11.put("AMT",    	String.valueOf( a6_s_amt ) );				
				ht11.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht11.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht11.put("DT_START",  "");  	//발생일자										 
				ht11.put("CD_BIZAREA",		"");   //귀속사업장	
				ht11.put("CD_DEPT",		"");   //부서								 
				ht11.put("CD_CC",			"");   //코스트센터		
				ht11.put("CD_PJT",			"");   //프로젝트코드		
				ht11.put("CD_CARD",		"");   //신용카드		 	
				ht11.put("CD_EMPLOY",		"");   //사원									 		 
				ht11.put("NO_DEPOSIT",	"");  //예적금계좌
				ht11.put("CD_BANK",		"");  //금융기관	
				ht11.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht11.put("AM_TAXSTD",	"");  //과세표준액
				ht11.put("AM_ADDTAX",	"" );	 //세액
				ht11.put("TP_TAX",	"");  //과세(매출) :11
				ht11.put("NO_COMPANY",	""); //사업자등록번호
					
				ht11.put("NM_NOTE", doc_cont);  // 적요	
															
				vt_auto.add(ht11);  //  공급가
				
				line++;
				
				Hashtable ht11_2 = new Hashtable();
				
				ht11_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht11_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht11_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
				ht11_2.put("CD_PC",  	node_code);  //회계단위
				ht11_2.put("CD_WDEPT",  dept_code);  //부서
				ht11_2.put("NO_DOCU",  	"");  //미결은 '0' 
				ht11_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht11_2.put("CD_COMPANY",  "1000");  
				ht11_2.put("ID_WRITE", insert_id);   
				ht11_2.put("CD_DOCU",  "11");  
				
				ht11_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht11_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht11_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
				ht11_2.put("CD_ACCT",  		"25500");  //부가세예수금					
				ht11_2.put("AMT",   			String.valueOf( a6_v_amt) );						
				ht11_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht11_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht11_2.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
				ht11_2.put("CD_BIZAREA",		"S101");   //귀속사업장	
				ht11_2.put("CD_DEPT",		"");   //부서								 
				ht11_2.put("CD_CC",			"");   //코스트센터		
				ht11_2.put("CD_PJT",			"");   //프로젝트코드		
				ht11_2.put("CD_CARD",		"");   //신용카드		 	
				ht11_2.put("CD_EMPLOY",		"");   //사원									 		 
				ht11_2.put("NO_DEPOSIT",	"");  //예적금계좌
				ht11_2.put("CD_BANK",		"");  //금융기관	
				ht11_2.put("NO_ITEM",		"");  //item	 	  	 
					
			// 부가세관련
				ht11_2.put("AM_TAXSTD",	 String.valueOf( a6_s_amt) );		 //과세표준액
				ht11_2.put("AM_ADDTAX",	String.valueOf( a6_v_amt) );		 //세액
				ht11_2.put("TP_TAX",	"11");  //과세(매출) :11
				if(ven_type.equals("1")){ //개인
					ht11_2.put("NO_COMPANY",	"8888888888"); //사업자등록번호
				} else {
					ht11_2.put("NO_COMPANY",	s_idno); //사업자등록번호
				}	
												
				ht11_2.put("NM_NOTE", doc_cont);  // 적요	
											
				vt_auto.add(ht11_2);  // 부가세				
			
				//차량회수비용 일부 상계 - 외상매출금, 리스/렌트 사업매출 구분하여 처리 
			    if ( AddUtil.parseDigit(request.getParameter("etc_amt_2"))  > 0 ) {
			 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc_amt_2")) + AddUtil.parseDigit(request.getParameter("etc_amt_2_v"))- a6_s_amt - a6_v_amt;
			 	   
			 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
				 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
					 	if (cls_st.equals("7") ) {
								 doc_cont = "출고전해지(신차) 차량회수비용" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	      	  doc_cont =  cls.getCls_st()  + " 차량회수비용" + "-" + car_no + " " + firm_nm;
						}	
							 	  					
						line++;
									
						Hashtable ht11_4 = new Hashtable();
						
						ht11_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht11_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht11_4.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht11_4.put("CD_PC",  	node_code);  //회계단위
						ht11_4.put("CD_WDEPT",  dept_code);  //부서
						ht11_4.put("NO_DOCU",  	"");  //미결은 '0' 
						ht11_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht11_4.put("CD_COMPANY",  "1000");  
						ht11_4.put("ID_WRITE", insert_id);   
						ht11_4.put("CD_DOCU",  "11");  
						
						ht11_4.put("DT_ACCT", 	cls.getCls_dt()); 
						ht11_4.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						ht11_4.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
						ht11_4.put("CD_ACCT",  "10800");   // 
						ht11_4.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
						ht11_4.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
						ht11_4.put("CD_PARTNER",	i_ven_code); //거래처    - A06
													
						ht11_4.put("DT_START",  "");  	//발생일자										 
						ht11_4.put("CD_BIZAREA",		"");   //귀속사업장	
						ht11_4.put("CD_DEPT",		"");   //부서								 
						ht11_4.put("CD_CC",			"");   //코스트센터		
						ht11_4.put("CD_PJT",			"");   //프로젝트코드		
						ht11_4.put("CD_CARD",		"");   //신용카드		 	
						ht11_4.put("CD_EMPLOY",		"");   //사원									 		 
						ht11_4.put("NO_DEPOSIT",	"");  //예적금계좌
						ht11_4.put("CD_BANK",		"");  //금융기관	
						ht11_4.put("NO_ITEM",		"");  //item	  	 
						
							// 부가세관련
						ht11_4.put("AM_TAXSTD",	"");  //과세표준액
						ht11_4.put("AM_ADDTAX",	"" );	 //세액
						ht11_4.put("TP_TAX",	"");  //과세(매출) :11
						ht11_4.put("NO_COMPANY",	""); //사업자등록번호
								
						ht11_4.put("NM_NOTE", doc_cont);  // 적요									
			
						vt_auto.add(ht11_4);  //  외상매출금
					}								
			  }
		 
		  // 세금계산서 발행이 안되었을 경우
	  } else { */
	  			 	
		  	  // 차량회수비용 세금 계산서 미리 발행건일 수도 있음 - 이때는 외상매출금 
			/* if ( clse.getTax_chk1().equals("Y")) {
		  		 
		  		 if ( AddUtil.parseDigit(request.getParameter("etc_amt_2"))  > 0 ) {
					 
				 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc_amt_2")) + AddUtil.parseDigit(request.getParameter("etc_amt_2_v"));
				 	   
				 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
					 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
					 		if (cls_st.equals("7") ) {
								 doc_cont = "출고전해지(신차) 차량회수비용" + "-" + rent_l_cd + " " + firm_nm;
							} else {		 
							      	  doc_cont =  cls.getCls_st()  + " 차량회수비용" + "-" + car_no + " " + firm_nm;
							}	
					 	  															
							line++;
										
							Hashtable ht11_5 = new Hashtable();
							
							ht11_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
							ht11_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
							ht11_5.put("NO_TAX",  	"*");  //부가세 이외는 *
							ht11_5.put("CD_PC",  	node_code);  //회계단위
							ht11_5.put("CD_WDEPT",  dept_code);  //부서
							ht11_5.put("NO_DOCU",  	"");  //미결은 '0' 
							ht11_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
							ht11_5.put("CD_COMPANY",  "1000");  
							ht11_5.put("ID_WRITE", insert_id);   
							ht11_5.put("CD_DOCU",  "11");  
							
							ht11_5.put("DT_ACCT", 	cls.getCls_dt()); 
							ht11_5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
							ht11_5.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
							ht11_5.put("CD_ACCT",  "10800");   // 
							ht11_5.put("AMT",    	String.valueOf( amt_10800) );		
							ht11_5.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
							ht11_5.put("CD_PARTNER",	i_ven_code); //거래처    - A06
														
							ht11_5.put("DT_START",  "");  	//발생일자										 
							ht11_5.put("CD_BIZAREA",		"");   //귀속사업장	
							ht11_5.put("CD_DEPT",		"");   //부서								 
							ht11_5.put("CD_CC",			"");   //코스트센터		
							ht11_5.put("CD_PJT",			"");   //프로젝트코드		
							ht11_5.put("CD_CARD",		"");   //신용카드		 	
							ht11_5.put("CD_EMPLOY",		"");   //사원									 		 
							ht11_5.put("NO_DEPOSIT",	"");  //예적금계좌
							ht11_5.put("CD_BANK",		"");  //금융기관	
							ht11_5.put("NO_ITEM",		"");  //item	  	 
							
								// 부가세관련
							ht11_5.put("AM_TAXSTD",	"");  //과세표준액
							ht11_5.put("AM_ADDTAX",	"" );	 //세액
							ht11_5.put("TP_TAX",	"");  //과세(매출) :11
							ht11_5.put("NO_COMPANY",	""); //사업자등록번호
									
							ht11_5.put("NM_NOTE", doc_cont);  // 적요									
															
							vt_auto.add(ht11_5);  //  외상매출금
						}								
				  }	 		 	
		  
		     } else { //면책금 계정이면
	         */
				if ( AddUtil.parseDigit(request.getParameter("etc_amt_2"))  > 0 ) { 	 	 	 	   
			 	// 세금계산서 발행분을 제외한 부분을 차량손해면책금으로
			 		if (cls_st.equals("7") ) {
								 doc_cont = "출고전해지(신차) 차량회수비용" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
						 	      	  doc_cont =  cls.getCls_st()  + " 차량회수비용" + "-" + car_no + " " + firm_nm;
					}	
							 	  	
						
					line++;
								
					Hashtable ht12 = new Hashtable();
					
					ht12.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht12.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht12.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht12.put("CD_PC",  	node_code);  //회계단위
					ht12.put("CD_WDEPT",  dept_code);  //부서
					ht12.put("NO_DOCU",  	"");  //미결은 '0' 
					ht12.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht12.put("CD_COMPANY",  "1000");  
					ht12.put("ID_WRITE", insert_id);   
					ht12.put("CD_DOCU",  "11");  
					
					ht12.put("DT_ACCT", 	cls.getCls_dt()); 
					ht12.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					//ht12.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
					//ht12.put("CD_ACCT",   	"91800");  //차량손해면책금
					//ht12.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc_amt_2"))) );	
					
					ht12.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht12.put("CD_ACCT",   	"45510");  //차량손해면책금
					ht12.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc_amt_2"))*(-1)  ) );	
					
					
					ht12.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht12.put("CD_PARTNER",	i_ven_code); //거래처    - A06
												
					ht12.put("DT_START",  "");  	//발생일자										 
					ht12.put("CD_BIZAREA",		"");   //귀속사업장	
					ht12.put("CD_DEPT",		"");   //부서								 
					ht12.put("CD_CC",			"");   //코스트센터		
					ht12.put("CD_PJT",			"");   //프로젝트코드		
					ht12.put("CD_CARD",		"");   //신용카드		 	
					ht12.put("CD_EMPLOY",		"");   //사원									 		 
					ht12.put("NO_DEPOSIT",	"");  //예적금계좌
					ht12.put("CD_BANK",		"");  //금융기관	
					ht12.put("NO_ITEM",		"");  //item	  	 
					
						// 부가세관련
					ht12.put("AM_TAXSTD",	"");  //과세표준액
					ht12.put("AM_ADDTAX",	"" );	 //세액
					ht12.put("TP_TAX",	"");  //과세(매출) :11
					ht12.put("NO_COMPANY",	""); //사업자등록번호
							
					ht12.put("NM_NOTE", doc_cont);  // 적요	
											
					vt_auto.add(ht12);  //  공급가
				}
						
		//	 }		 	 	 
	 // } 
	 		 	 
	 // 차량부대비용 세금 계산서 발행건 처리 
	 /* if ( a7_s_amt > 0 ) {
		 
		 	//  렌트(리스)사업매출인 경우는 부가세처리 
		 		if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 차량부대비용" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      	  doc_cont =  cls.getCls_st()  + " 차량부대비용" + "-" + car_no + " " + firm_nm;
				}	
		 	  				
				if ( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))  < 1 ) { 	  //외상매출금 추가
				
					line++;
							
					Hashtable ht13_3 = new Hashtable();
					
					ht13_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht13_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht13_3.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht13_3.put("CD_PC",  	node_code);  //회계단위
					ht13_3.put("CD_WDEPT",  dept_code);  //부서
					ht13_3.put("NO_DOCU",  	"");  //미결은 '0' 
					ht13_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht13_3.put("CD_COMPANY",  "1000");  
					ht13_3.put("ID_WRITE", insert_id);   
					ht13_3.put("CD_DOCU",  "11");  
					
					ht13_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht13_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht13_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht13_3.put("CD_ACCT",  "10800");  //외상매출금
					ht13_3.put("AMT",    	String.valueOf( a7_s_amt + a7_v_amt) );		
					ht13_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht13_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06
												
					ht13_3.put("DT_START",  "");  	//발생일자										 
					ht13_3.put("CD_BIZAREA",		"");   //귀속사업장	
					ht13_3.put("CD_DEPT",		"");   //부서								 
					ht13_3.put("CD_CC",			"");   //코스트센터		
					ht13_3.put("CD_PJT",			"");   //프로젝트코드		
					ht13_3.put("CD_CARD",		"");   //신용카드		 	
					ht13_3.put("CD_EMPLOY",		"");   //사원									 		 
					ht13_3.put("NO_DEPOSIT",	"");  //예적금계좌
					ht13_3.put("CD_BANK",		"");  //금융기관	
					ht13_3.put("NO_ITEM",		"");  //item	  	 
					
						// 부가세관련
					ht13_3.put("AM_TAXSTD",	"");  //과세표준액
					ht13_3.put("AM_ADDTAX",	"" );	 //세액
					ht13_3.put("TP_TAX",	"");  //과세(매출) :11
					ht13_3.put("NO_COMPANY",	""); //사업자등록번호
							
					ht13_3.put("NM_NOTE", doc_cont);  // 적요	
												
					vt_auto.add(ht13_3);  //  외상매출금
							
				}	
					
				line++;
							
				Hashtable ht13 = new Hashtable();
				
				ht13.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht13.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht13.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht13.put("CD_PC",  	node_code);  //회계단위
				ht13.put("CD_WDEPT",  dept_code);  //부서
				ht13.put("NO_DOCU",  	"");  //미결은 '0' 
				ht13.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht13.put("CD_COMPANY",  "1000");  
				ht13.put("ID_WRITE", insert_id);   
				ht13.put("CD_DOCU",  "11");  
				
				ht13.put("DT_ACCT", 	cls.getCls_dt()); 
				ht13.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht13.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				
				if ( car_st.equals("1")  ) { //렌트이면
						ht13.put("CD_ACCT",  	"41200");  //차량부대비용
				} else {
						ht13.put("CD_ACCT",  	"41700");  //차량부대비용
				}	
				
				ht13.put("AMT",    	String.valueOf( a7_s_amt ) );			
				ht13.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht13.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht13.put("DT_START",  "");  	//발생일자										 
				ht13.put("CD_BIZAREA",		"");   //귀속사업장	
				ht13.put("CD_DEPT",		"");   //부서								 
				ht13.put("CD_CC",			"");   //코스트센터		
				ht13.put("CD_PJT",			"");   //프로젝트코드		
				ht13.put("CD_CARD",		"");   //신용카드		 	
				ht13.put("CD_EMPLOY",		"");   //사원									 		 
				ht13.put("NO_DEPOSIT",	"");  //예적금계좌
				ht13.put("CD_BANK",		"");  //금융기관	
				ht13.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht13.put("AM_TAXSTD",	"");  //과세표준액
				ht13.put("AM_ADDTAX",	"" );	 //세액
				ht13.put("TP_TAX",	"");  //과세(매출) :11
				ht13.put("NO_COMPANY",	""); //사업자등록번호
						
				ht13.put("NM_NOTE", doc_cont);  // 적요	
							
				vt_auto.add(ht13);  //  공급가
				
				line++;
				
				Hashtable ht13_2 = new Hashtable();
				
				ht13_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht13_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht13_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
				ht13_2.put("CD_PC",  	node_code);  //회계단위
				ht13_2.put("CD_WDEPT",  dept_code);  //부서
				ht13_2.put("NO_DOCU",  	"");  //미결은 '0' 
				ht13_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht13_2.put("CD_COMPANY",  "1000");  
				ht13_2.put("ID_WRITE", insert_id);   
				ht13_2.put("CD_DOCU",  "11");  
				
				ht13_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht13_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht13_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
				ht13_2.put("CD_ACCT",  		"25500");  //부가세예수금					
				ht13_2.put("AMT",   		String.valueOf( a7_v_amt ));				
				ht13_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht13_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht13_2.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
				ht13_2.put("CD_BIZAREA",		"S101");   //귀속사업장	
				ht13_2.put("CD_DEPT",		"");   //부서								 
				ht13_2.put("CD_CC",			"");   //코스트센터		
				ht13_2.put("CD_PJT",			"");   //프로젝트코드		
				ht13_2.put("CD_CARD",		"");   //신용카드		 	
				ht13_2.put("CD_EMPLOY",		"");   //사원									 		 
				ht13_2.put("NO_DEPOSIT",	"");  //예적금계좌
				ht13_2.put("CD_BANK",		"");  //금융기관	
				ht13_2.put("NO_ITEM",		"");  //item	 	  	 
					
			// 부가세관련
				ht13_2.put("AM_TAXSTD",	 String.valueOf( a7_s_amt) );		 //과세표준액
				ht13_2.put("AM_ADDTAX",	String.valueOf( a7_v_amt) );		 //세액
				ht13_2.put("TP_TAX",	"11");  //과세(매출) :11
				if(ven_type.equals("1")){ //개인
					ht13_2.put("NO_COMPANY",	"8888888888"); //사업자등록번호
				} else {
					ht13_2.put("NO_COMPANY",	s_idno); //사업자등록번호
				}								
				ht13_2.put("NM_NOTE", doc_cont);  // 적요			
							
				vt_auto.add(ht13_2);  // 부가세		
						
				//차량부대비용 일부 상계 - 외상매출금, 리스/렌트 사업매출 구분하여 처리 
			    if ( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))  > 0 ) {
			 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc2_amt_2")) + AddUtil.parseDigit(request.getParameter("etc2_amt_2_v"))- a7_s_amt - a7_v_amt;
			 	   
			 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
				 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
					 	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 차량부대비용" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	   doc_cont =  cls.getCls_st()  + " 차량부대비용" + "-" + car_no + " " + firm_nm;
						}	
							 	  					
						line++;
									
						Hashtable ht13_4 = new Hashtable();

						ht13_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht13_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht13_4.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht13_4.put("CD_PC",  	node_code);  //회계단위
						ht13_4.put("CD_WDEPT",  dept_code);  //부서
						ht13_4.put("NO_DOCU",  	"");  //미결은 '0' 
						ht13_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht13_4.put("CD_COMPANY",  "1000");  
						ht13_4.put("ID_WRITE", insert_id);   
						ht13_4.put("CD_DOCU",  "11");  
						
						ht13_4.put("DT_ACCT", 	cls.getCls_dt()); 
						ht13_4.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						ht13_4.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
						ht13_4.put("CD_ACCT",  "10800");   // 
						ht13_4.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
						ht13_4.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
						ht13_4.put("CD_PARTNER",	i_ven_code); //거래처    - A06
													
						ht13_4.put("DT_START",  "");  	//발생일자										 
						ht13_4.put("CD_BIZAREA",		"");   //귀속사업장	
						ht13_4.put("CD_DEPT",		"");   //부서								 
						ht13_4.put("CD_CC",			"");   //코스트센터		
						ht13_4.put("CD_PJT",			"");   //프로젝트코드		
						ht13_4.put("CD_CARD",		"");   //신용카드		 	
						ht13_4.put("CD_EMPLOY",		"");   //사원									 		 
						ht13_4.put("NO_DEPOSIT",	"");  //예적금계좌
						ht13_4.put("CD_BANK",		"");  //금융기관	
						ht13_4.put("NO_ITEM",		"");  //item	  	 
						
							// 부가세관련
						ht13_4.put("AM_TAXSTD",	"");  //과세표준액
						ht13_4.put("AM_ADDTAX",	"" );	 //세액
						ht13_4.put("TP_TAX",	"");  //과세(매출) :11
						ht13_4.put("NO_COMPANY",	""); //사업자등록번호
								
						ht13_4.put("NM_NOTE", doc_cont);  // 적요		
									
						vt_auto.add(ht13_4);  //  외상매출금
					}	
							
			  }			
		 
		 // 세금계산서 발행이 안되었을 경우
	   } else {	*/
				 	
		  	  // 차량부대비용 세금 계산서 미리 발행건일 수도 있음 - 이때는 외상매출금 
		/*	 if ( clse.getTax_chk2().equals("Y")) {
		  		 
		  		 if ( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))  > 0 ) {
					 
				 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc2_amt_2")) + AddUtil.parseDigit(request.getParameter("etc2_amt_2_v"));
				 	   
				 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
					 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
						 	if (cls_st.equals("7") ) {
									 doc_cont = "출고전해지(신차) 차량부대비용" + "-" + rent_l_cd + " " + firm_nm;
							} else {		 
							 	      	  doc_cont =  cls.getCls_st()  + " 차량부대비용" + "-" + car_no + " " + firm_nm;
							}	
					 	  															
							line++;
										
							Hashtable ht13_5 = new Hashtable();
							
							ht13_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
							ht13_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
							ht13_5.put("NO_TAX",  	"*");  //부가세 이외는 *
							ht13_5.put("CD_PC",  	node_code);  //회계단위
							ht13_5.put("CD_WDEPT",  dept_code);  //부서
							ht13_5.put("NO_DOCU",  	"");  //미결은 '0' 
							ht13_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
							ht13_5.put("CD_COMPANY",  "1000");  
							ht13_5.put("ID_WRITE", insert_id);   
							ht13_5.put("CD_DOCU",  "11");  
							
							ht13_5.put("DT_ACCT", 	cls.getCls_dt()); 
							ht13_5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
							ht13_5.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
							ht13_5.put("CD_ACCT",  "10800");   // 
							ht13_5.put("AMT",    	String.valueOf( amt_10800) );			
							ht13_5.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
							ht13_5.put("CD_PARTNER",	i_ven_code); //거래처    - A06
														
							ht13_5.put("DT_START",  "");  	//발생일자										 
							ht13_5.put("CD_BIZAREA",		"");   //귀속사업장	
							ht13_5.put("CD_DEPT",		"");   //부서								 
							ht13_5.put("CD_CC",			"");   //코스트센터		
							ht13_5.put("CD_PJT",			"");   //프로젝트코드		
							ht13_5.put("CD_CARD",		"");   //신용카드		 	
							ht13_5.put("CD_EMPLOY",		"");   //사원									 		 
							ht13_5.put("NO_DEPOSIT",	"");  //예적금계좌
							ht13_5.put("CD_BANK",		"");  //금융기관	
							ht13_5.put("NO_ITEM",		"");  //item	  	 
							
								// 부가세관련
							ht13_5.put("AM_TAXSTD",	"");  //과세표준액
							ht13_5.put("AM_ADDTAX",	"" );	 //세액
							ht13_5.put("TP_TAX",	"");  //과세(매출) :11
							ht13_5.put("NO_COMPANY",	""); //사업자등록번호
									
							ht13_5.put("NM_NOTE", doc_cont);  // 적요							
														
							vt_auto.add(ht13_5);  //  외상매출금
						}								
				  }	 		 	
		  
		     } else { //면책금 계정이면
		*/
				if ( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))  > 0 ) { 	 	 	 	   
			 	// 세금계산서 발행분을 제외한 부분을 차량손해면책금으로
				 	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 차량부대비용" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	      	  doc_cont =  cls.getCls_st()  + " 차량부대비용" + "-" + car_no + " " + firm_nm;
					}	
			 	  						
					line++;
								
					Hashtable ht14 = new Hashtable();
					
					ht14.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht14.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht14.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht14.put("CD_PC",  	node_code);  //회계단위
					ht14.put("CD_WDEPT",  dept_code);  //부서
					ht14.put("NO_DOCU",  	"");  //미결은 '0' 
					ht14.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht14.put("CD_COMPANY",  "1000");  
					ht14.put("ID_WRITE", insert_id);   
					ht14.put("CD_DOCU",  "11");  
					
					ht14.put("DT_ACCT", 	cls.getCls_dt()); 
					ht14.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					//ht14.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
					//ht14.put("CD_ACCT", 	"91800");  //차량손해면책금
					//ht14.put("AMT",    		String.valueOf( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))) );		
					
					ht14.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht14.put("CD_ACCT", 	"45510");  //차량손해면책금
					ht14.put("AMT",    		String.valueOf( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))*(-1)  ) );		
					
					ht14.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht14.put("CD_PARTNER",	i_ven_code); //거래처    - A06
												
					ht14.put("DT_START",  "");  	//발생일자										 
					ht14.put("CD_BIZAREA",		"");   //귀속사업장	
					ht14.put("CD_DEPT",		"");   //부서								 
					ht14.put("CD_CC",			"");   //코스트센터		
					ht14.put("CD_PJT",			"");   //프로젝트코드		
					ht14.put("CD_CARD",		"");   //신용카드		 	
					ht14.put("CD_EMPLOY",		"");   //사원									 		 
					ht14.put("NO_DEPOSIT",	"");  //예적금계좌
					ht14.put("CD_BANK",		"");  //금융기관	
					ht14.put("NO_ITEM",		"");  //item	  	 
					
						// 부가세관련
					ht14.put("AM_TAXSTD",	"");  //과세표준액
					ht14.put("AM_ADDTAX",	"" );	 //세액
					ht14.put("TP_TAX",	"");  //과세(매출) :11
					ht14.put("NO_COMPANY",	""); //사업자등록번호
							
					ht14.put("NM_NOTE", doc_cont);  // 적요	
								
					vt_auto.add(ht14);  //  공급가					
			    }
			    	
		//     }	  
	//  }	
	  
	 	  
	  //잔존차량가치 -연비보상 
	  if ( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))  < 0 ) {	 	 	 	 	   
			 	//  차량손해면책금으로
				 	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 잔존차량가격" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	     doc_cont =  cls.getCls_st()  + " 연비보상 " + "-" + car_no + " " + firm_nm;
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
			//		ht16_3.put("CD_ACCT", 	"25900");  //선수금
					ht16_3.put("AMT",    		 	String.valueOf( AddUtil.parseDigit(request.getParameter("etc3_amt_2")) * (-1)     )    );				
					ht16_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체	
				//	ht16_3.put("CD_PARTNER",	"000048"); //거래처    - A06					
				/*
				   if (  return_remark.equals("싼타페") ) {
					   ht16_3.put("CD_PARTNER",	"000048"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322) 
				   } else if (  return_remark.equals("볼보") ) {
					   ht16_3.put("CD_PARTNER",	"995591"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322)
				   } else if (  return_remark.equals("혼다") ) {  //혼다는 매입옵션만 
					   ht16_3.put("CD_PARTNER",	"996528"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322)
				   } else if (  return_remark.equals("벤츠") ) {
					   ht16_3.put("CD_PARTNER",	"996322"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322)
				   } else {
					   ht16_3.put("CD_ACCT", 	"45510");  //차량손해면책금
					   ht16_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06
				   }*/
				
					if (  return_remark.equals("싼타페") ) {
							ht16_3.put("CD_ACCT", 	"25900");  //선수금
						   ht16_3.put("CD_PARTNER",	"000048"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322) 
					 } else if (  return_remark.equals("볼보") ) {
							ht16_3.put("CD_ACCT", 	"25900");  //선수금 
							 ht16_3.put("CD_PARTNER",	"995591"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322)
					 } else if (  return_remark.equals("혼다") ) {  //혼다는 매입옵션만 
							ht16_3.put("CD_ACCT", 	"25900");  //선수금  
						 	ht16_3.put("CD_PARTNER",	"996528"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322)
					 } else if (  return_remark.equals("벤츠") ) {
							ht16_3.put("CD_ACCT", 	"25900");  //선수금 
						 	ht16_3.put("CD_PARTNER",	"996322"); //거래처    - A06  //현대자동차(000048) 혼다(996528) 볼보(995591) , 벤츠(996322)
					 } else{
						 ht16_3.put("CD_ACCT", 	"45510");  //차량손해면책금
						 ht16_3.put("CD_PARTNER",	i_ven_code); //거래처    - A06 
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
	 	   
	 //잔존차량가치 
	  if ( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))  > 0 ) {	 	 	 	 	   
			 	//  차량손해면책금으로
				 	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 잔존차량가격" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	      	  doc_cont =  cls.getCls_st()  + " 잔존차량가격" + "-" + car_no + " " + firm_nm;
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
				//	ht16_3.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				//	ht16_3.put("CD_ACCT", 	"91800");  //차량손해면책금
				//	ht16_3.put("AMT",    		 	String.valueOf( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))) );	
					
					ht16_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht16_3.put("CD_ACCT", 	"45510");  //차량손해면책금
					ht16_3.put("AMT",    		 	String.valueOf( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))*(-1) ) );	
					
					
					ht16_3.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht16_3.put("CD_PARTNER",	"000131"); //거래처    - A06
												
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

	 // 기타손해배상금 세금 계산서 발행건 처리  
	/*  if ( a8_s_amt > 0 ) {
		 
		 	//  렌트(리스)사업매출인 경우는 부가세처리
		 	 	if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 손해배상금" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
					 	    doc_cont =  cls.getCls_st()  + " 손해배상금" + "-" + car_no + " " + firm_nm;
				}		
						
				if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  < 1 ) { 	  //외상매출금 추가
				
					line++;
							
					Hashtable ht15_3 = new Hashtable();
					
					ht15_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht15_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht15_3.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht15_3.put("CD_PC",  	node_code);  //회계단위
					ht15_3.put("CD_WDEPT",  dept_code);  //부서
					ht15_3.put("NO_DOCU",  	"");  //미결은 '0' 
					ht15_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht15_3.put("CD_COMPANY",  "1000");  
					ht15_3.put("ID_WRITE", insert_id);   
					ht15_3.put("CD_DOCU",  "11");  
					
					ht15_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht15_3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					//ht15_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					//ht15_3.put("CD_ACCT",  "91800");   // 차량손해배상금 				
					//ht15_3.put("AMT",    	String.valueOf( a8_s_amt + a8_v_amt) );		
					
					ht15_3.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht15_3.put("CD_ACCT",  "91800");   // 차량손해배상금 				
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
				
				ht15.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht15.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht15.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht15.put("CD_PC",  	node_code);  //회계단위
				ht15.put("CD_WDEPT",  dept_code);  //부서
				ht15.put("NO_DOCU",  	"");  //미결은 '0' 
				ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht15.put("CD_COMPANY",  "1000");  
				ht15.put("ID_WRITE", insert_id);   
				ht15.put("CD_DOCU",  "11");  
				
				ht15.put("DT_ACCT", 	cls.getCls_dt()); 
				ht15.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht15.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				
				if ( car_st.equals("1")  ) { //렌트이면
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
					
				ht15_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht15_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht15_2.put("NO_TAX",  	"");  //부가세 이외는 * row_id || row_no
				ht15_2.put("CD_PC",  	node_code);  //회계단위
				ht15_2.put("CD_WDEPT",  dept_code);  //부서
				ht15_2.put("NO_DOCU",  	"");  //미결은 '0' 
				ht15_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht15_2.put("CD_COMPANY",  "1000");  
				ht15_2.put("ID_WRITE", insert_id);   
				ht15_2.put("CD_DOCU",  "11");  
				
				ht15_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht15_2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht15_2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1			
				ht15_2.put("CD_ACCT",  	"25500");  //부가세예수금					
				ht15_2.put("AMT",   	String.valueOf( a8_v_amt) );						
				ht15_2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht15_2.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht15_2.put("DT_START", cls.getCls_dt());  	//발생일자 - 부가세										 
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
				if(ven_type.equals("1")){ //개인
					ht15_2.put("NO_COMPANY",	"8888888888"); //사업자등록번호
				} else {
					ht15_2.put("NO_COMPANY",	s_idno); //사업자등록번호
				}								
				ht15_2.put("NM_NOTE", doc_cont);  // 적요			
							
				vt_auto.add(ht15_2);  // 부가세		
						
					//기타손해배상금 일부 상계 - 외상매출금, 리스/렌트 사업매출 구분하여 처리 
			    if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  > 0 ) {
			 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc4_amt_2")) + AddUtil.parseDigit(request.getParameter("etc4_amt_2_v"))- a8_s_amt - a8_v_amt;
			 	   
			 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
				 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
					 	if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 손해배상금" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
							 	    doc_cont =  cls.getCls_st()  + " 손해배상금" + "-" + car_no + " " + firm_nm;
						}	
				 	  						
						line++;
									
						Hashtable ht15_4 = new Hashtable();
						
						ht15_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht15_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht15_4.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht15_4.put("CD_PC",  	node_code);  //회계단위
						ht15_4.put("CD_WDEPT",  dept_code);  //부서
						ht15_4.put("NO_DOCU",  	"");  //미결은 '0' 
						ht15_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht15_4.put("CD_COMPANY",  "1000");  
						ht15_4.put("ID_WRITE", insert_id);   
						ht15_4.put("CD_DOCU",  "11");  
						
						ht15_4.put("DT_ACCT", 	cls.getCls_dt()); 
						ht15_4.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						ht15_4.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
				//		ht15_4.put("CD_ACCT",  "10800");   // 
						ht15_4.put("CD_ACCT",  "91800");   //
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
	  } else {
	 */ 	
	  	  // 기타손해배상금 세금 계산서 미리 발행건일 수도 있음 - 이때는 외상매출금 
		/* if ( clse.getTax_chk3().equals("Y")) {
	  		 
	  		 if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  > 0 ) {
				 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc4_amt_2")) + AddUtil.parseDigit(request.getParameter("etc4_amt_2_v"));
			 	   
			 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
				 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
				 		if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 손해배상금" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	    doc_cont =  cls.getCls_st()  + " 손해배상금" + "-" + car_no + " " + firm_nm;
						}	
				 	  	
														
						line++;
									
						Hashtable ht15_5 = new Hashtable();
				
						ht15_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht15_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht15_5.put("NO_TAX",  	"*");  //부가세 이외는 *
						ht15_5.put("CD_PC",  	node_code);  //회계단위
						ht15_5.put("CD_WDEPT",  dept_code);  //부서
						ht15_5.put("NO_DOCU",  	"");  //미결은 '0' 
						ht15_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
						ht15_5.put("CD_COMPANY",  "1000");  
						ht15_5.put("ID_WRITE", insert_id);   
						ht15_5.put("CD_DOCU",  "11");  
						
						ht15_5.put("DT_ACCT", 	cls.getCls_dt()); 
						ht15_5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
						ht15_5.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				//		ht15_5.put("CD_ACCT",  "10800");   // 
						ht15_5.put("CD_ACCT",  "91800");   // 
						ht15_5.put("AMT",    		String.valueOf( amt_10800) );			
						ht15_5.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
						ht15_5.put("CD_PARTNER",	i_ven_code); //거래처    - A06
													
						ht15_5.put("DT_START",  "");  	//발생일자										 
						ht15_5.put("CD_BIZAREA",		"");   //귀속사업장	
						ht15_5.put("CD_DEPT",		"");   //부서								 
						ht15_5.put("CD_CC",			"");   //코스트센터		
						ht15_5.put("CD_PJT",			"");   //프로젝트코드		
						ht15_5.put("CD_CARD",		"");   //신용카드		 	
						ht15_5.put("CD_EMPLOY",		"");   //사원									 		 
						ht15_5.put("NO_DEPOSIT",	"");  //예적금계좌
						ht15_5.put("CD_BANK",		"");  //금융기관	
						ht15_5.put("NO_ITEM",		"");  //item	  	 
						
							// 부가세관련
						ht15_5.put("AM_TAXSTD",	"");  //과세표준액
						ht15_5.put("AM_ADDTAX",	"" );	 //세액
						ht15_5.put("TP_TAX",	"");  //과세(매출) :11
						ht15_5.put("NO_COMPANY",	""); //사업자등록번호
								
						ht15_5.put("NM_NOTE", doc_cont);  // 적요	
													
						vt_auto.add(ht15_5);  //  외상매출금
					}								
			  }	 		 	
	  
	     } else { //면책금 계정이면
	  */
			 if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  > 0 ) {	 	 	 	 	   
			 	// 세금계산서 발행분을 제외한 부분을 차량손해면책금으로
			 		if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 손해배상금" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
							    doc_cont =  cls.getCls_st()  + " 손해배상금" + "-" + car_no + " " + firm_nm;
					}		 	  		
						
					line++;
								
					Hashtable ht16 = new Hashtable();		
					
					ht16.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht16.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht16.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht16.put("CD_PC",  	node_code);  //회계단위
					ht16.put("CD_WDEPT",  dept_code);  //부서
					ht16.put("NO_DOCU",  	"");  //미결은 '0' 
					ht16.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht16.put("CD_COMPANY",  "1000");  
					ht16.put("ID_WRITE", insert_id);   
					ht16.put("CD_DOCU",  "11");  
					
					ht16.put("DT_ACCT", 	cls.getCls_dt()); 
					ht16.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				//	ht16.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				//	ht16.put("CD_ACCT",   	"91800");  //차량손해면책금
				//	ht16.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))) );	
					
					ht16.put("TP_DRCR",   "1");   // 대변:2 , 차변:1
					ht16.put("CD_ACCT",   	"45510");  //차량손해면책금
					ht16.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))*(-1)  ) );	
					
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
	//	 }	   
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
				
				if ( car_st.equals("1")  ) { //렌트이면
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
	  	
	  	  // 초과운행 세금 계산서 미리 발행건일 수도 있음 - 이때는 외상매출금 
		 if ( clse.getTax_chk4().equals("Y")) {
	  		 
	  		 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {
				 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("over_amt_2")) + AddUtil.parseDigit(request.getParameter("over_amt_2_v"));
			 	   
			 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
				 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
				 		if (cls_st.equals("7") ) {
							 doc_cont = "출고전해지(신차) 초과운행대여료" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	    doc_cont =  cls.getCls_st()  + " 초과운행대여료" + "-" + car_no + " " + firm_nm;
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
	  
	     } /* else { 
	    	 //해지수익 계정이면
	  
			 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {	 	 	 	 	   
			 	// 세금계산서 발행분을 제외한 부분을 해지수익으로
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
					
					if ( car_st.equals("1")  ) { //렌트이면
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
		 }	*/   

	 }					 	

	 // 초과운행 - 고객 환불건 	 - 20220822추가   
	 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  < 0 ) {
		 // 초과운행 - 이때는 외상매출금 
  		 if ( clse.getTax_chk4().equals("Y")) { //해지의뢰시 초과운해은  tax_chk4 "Y"로 setting ( 실제발행여부와 상관 없음)
			 
		 	   amt_10800 = AddUtil.parseDigit(request.getParameter("over_amt_2")) + AddUtil.parseDigit(request.getParameter("over_amt_2_v"));
		 	   
		 	   if ( amt_10800 != 0) {  //외상매출금이 있는 경우만 
			 	// 세금계산서 발행분을 제외한 부분을 외상매출금으로
			 		if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 초과운행대여료" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	    doc_cont =  cls.getCls_st()  + " 초과운행대여료" + "-" + car_no + " " + firm_nm;
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
	 }	 
	 	 
	 
	//} // jung_st = 1 인경우에만 해당	  
	   	
	 if ( jung_st.equals("2")) {
	   //고객에게 돌려줄 금액
		  if ( AddUtil.parseDigit(request.getParameter("h5_amt"))  > 0 ) {
		 		 
		 		 if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 환불" + "-" + rent_l_cd + " " + firm_nm + " " + re_bank_nm + "-" + re_acc_no + "-" + re_acc_nm;
				} else {		 
						 doc_cont =  cls.getCls_st()  + " 환불" + "-" + car_no + " " + firm_nm + " " + re_bank_nm + "-" + re_acc_no + "-" + re_acc_nm;
				}		
		 						
				line++;
					 				   		
		   		Hashtable ht17 = new Hashtable(); 		
		   		
				ht17.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht17.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht17.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht17.put("CD_PC",  	node_code);  //회계단위
				ht17.put("CD_WDEPT",  dept_code);  //부서
				ht17.put("NO_DOCU",  	"");  //미결은 '0' 
				ht17.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht17.put("CD_COMPANY",  "1000");  
				ht17.put("ID_WRITE", insert_id);   
				ht17.put("CD_DOCU",  "11");  
				
				ht17.put("DT_ACCT", 	cls.getCls_dt()); 
				ht17.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht17.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				ht17.put("CD_ACCT",   	"25300");  //미지급금
				ht17.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("h5_amt")) ) );				
				ht17.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht17.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht17.put("DT_START",  "");  	//발생일자										 
				ht17.put("CD_BIZAREA",		"");   //귀속사업장	
				ht17.put("CD_DEPT",		"");   //부서								 
				ht17.put("CD_CC",			"");   //코스트센터		
				ht17.put("CD_PJT",			"");   //프로젝트코드		
				ht17.put("CD_CARD",		"");   //신용카드		 	
				ht17.put("CD_EMPLOY",		"");   //사원									 		 
				ht17.put("NO_DEPOSIT",	"");  //예적금계좌
				ht17.put("CD_BANK",		"");  //금융기관	
				ht17.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht17.put("AM_TAXSTD",	"");  //과세표준액
				ht17.put("AM_ADDTAX",	"" );	 //세액
				ht17.put("TP_TAX",	"");  //과세(매출) :11
				ht17.put("NO_COMPANY",	""); //사업자등록번호
						
				ht17.put("NM_NOTE", doc_cont);  // 적요				
									
				vt_auto.add(ht17);  // 고객환불	 	
		  } 
	 
	 } else {
	   	
		  //고객에게 돌려줄 금액
		  if ( AddUtil.parseDigit(request.getParameter("fdft_amt2"))  < 0 ) {
		 		 
		 		 if (cls_st.equals("7") ) {
						 doc_cont = "출고전해지(신차) 환불" + "-" + rent_l_cd + " " + firm_nm + " " + re_bank_nm + "-" + re_acc_no + "-" + re_acc_nm;
				} else {		 
						 doc_cont =  cls.getCls_st()  + " 환불" + "-" + car_no + " " + firm_nm + " " + re_bank_nm + "-" + re_acc_no + "-" + re_acc_nm;
				}		
		 						
				line++;
					 				   		
		   		Hashtable ht17 = new Hashtable(); 		
		   		
				ht17.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht17.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht17.put("NO_TAX",  	"*");  //부가세 이외는 *
				ht17.put("CD_PC",  	node_code);  //회계단위
				ht17.put("CD_WDEPT",  dept_code);  //부서
				ht17.put("NO_DOCU",  	"");  //미결은 '0' 
				ht17.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
				ht17.put("CD_COMPANY",  "1000");  
				ht17.put("ID_WRITE", insert_id);   
				ht17.put("CD_DOCU",  "11");  
				
				ht17.put("DT_ACCT", 	cls.getCls_dt()); 
				ht17.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				ht17.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
				ht17.put("CD_ACCT",   	"25300");  //미지급금
				ht17.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("fdft_amt2"))*(-1)  ) );				
				ht17.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
				ht17.put("CD_PARTNER",	i_ven_code); //거래처    - A06
											
				ht17.put("DT_START",  "");  	//발생일자										 
				ht17.put("CD_BIZAREA",		"");   //귀속사업장	
				ht17.put("CD_DEPT",		"");   //부서								 
				ht17.put("CD_CC",			"");   //코스트센터		
				ht17.put("CD_PJT",			"");   //프로젝트코드		
				ht17.put("CD_CARD",		"");   //신용카드		 	
				ht17.put("CD_EMPLOY",		"");   //사원									 		 
				ht17.put("NO_DEPOSIT",	"");  //예적금계좌
				ht17.put("CD_BANK",		"");  //금융기관	
				ht17.put("NO_ITEM",		"");  //item	  	 
				
					// 부가세관련
				ht17.put("AM_TAXSTD",	"");  //과세표준액
				ht17.put("AM_ADDTAX",	"" );	 //세액
				ht17.put("TP_TAX",	"");  //과세(매출) :11
				ht17.put("NO_COMPANY",	""); //사업자등록번호
						
				ht17.put("NM_NOTE", doc_cont);  // 적요				
									
				vt_auto.add(ht17);  // 고객환불	 	
		  } 

	}
	  
	  if ( vt_m_auto.size() > 0){
		row_id_t = neoe_db.insertSetAutoDocu(cls_dt, vt_m_auto);
	  }	
	  // 차대가 틀려도 생성이 안되면 어디서 틀렸는지 파악 불가 
	  if ( vt_auto.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(cls_dt, vt_auto);
	  }
	   
	  //회계처리 
	  if(!ac_db.updateClsEtcAuto(rent_mng_id, rent_l_cd, "Y")) flag += 1; 

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
//		fm.t_wd.value = fm.rent_l_cd.value;
	    fm.action ='<%=from_page%>';
	    fm.target='d_content';		
	    fm.submit();
	<%	
		} %>
	</script>
	</body>
	</html>