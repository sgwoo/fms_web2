<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*,  acar.util.*, acar.cont.*, acar.user_mng.*, acar.asset.*, acar.client.*,  tax.*, acar.bill_mng.*"%>
<jsp:useBean id="su_bean" class="acar.offls_actn.Offls_sui_etcBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")  ==null?"S1":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String asset_code 	= request.getParameter("asset_code")==null?"":request.getParameter("asset_code");
	String assch_seri	= request.getParameter("assch_seri")==null?"0":request.getParameter("assch_seri");	
	String real_date	= request.getParameter("assch_date")==null?"":request.getParameter("assch_date");	
	String chk			= request.getParameter("chk")==null?"":request.getParameter("chk");	// chk -> 1:수수료 전표, 2:매각 전표
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");  //자산계정
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code"); //경매장
	String client_id2 	= request.getParameter("client_id2")==null?"":request.getParameter("client_id2"); //매매상  - 비교할 것 
	
	String hidden_value = "";
	
	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc;
					
	boolean flag = true;
	int count =0;
	boolean flag1 = true;
	int count1 =0;
	int	flag2 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AssetDatabase as_db = AssetDatabase.getInstance();
		
	//자동전표 발행-네오엠 자동전표 처리
	String autodoc = request.getParameter("autodoc")==null?"N":request.getParameter("autodoc");
			
	//수수료 관련 금액 
	String amt = "";
	int sup_amt = 0;
	float f_sup_amt = 0;
	int vat_amt = 0;
	int remain_amt = 0;
	int jangbu_amt = 0;
	String car_no = "";
	
	String ven_type = "";
	String s_idno = "";	
	String client_st = "";
	String ven_code2 = "";
	
	int amt_10800 = 0;
	String s_flag = "";
	
		
	//세금계산서 발행관련 - 매각계산서 발행 유무
	int sold_cnt = 1;
	
	sold_cnt  = ac_db.getCarSoldCnt(car_mng_id);
//	System.out.println(매각  사전 계산서 발행 - " + sold_cnt);

	String tax_no = "";
	int data_no =0;
	int data_no_t =0;
  	int tax_cnt = 0;
  	
  	String tax_supply = "";
	String tax_value = "";
	String tax_branch 	= "";	
	
	
  	UserMngDatabase umd = UserMngDatabase.getInstance();
  	UsersBean user_bean 	= umd.getUsersBean(user_id);
  	  			
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	AutoDocuBean ad_bean = new AutoDocuBean();
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	String node_code = String.valueOf(per.get("NODE_CODE"));
	
	Hashtable vendor = neoe_db.getVendorCase(ven_code);	  //경매장 정보
	  
	if ( chk.equals("1") ) {
	
	   su_bean  = as_db.getInfoComm(car_mng_id);
	 			
	   amt = Integer.toString( su_bean.getComm1_sup() + su_bean.getComm2_sup()) + "^" + Integer.toString( su_bean.getComm3_sup())  + "^" +  Integer.toString( su_bean.getComm1_vat()+ su_bean.getComm2_vat() + su_bean.getComm3_vat() )   + "^" +  Integer.toString(su_bean.getComm1_sup()+ su_bean.getComm2_sup() + su_bean.getComm3_sup() +  su_bean.getComm1_vat()+ su_bean.getComm2_vat() + su_bean.getComm3_vat() ) ;
	
	   ad_bean.setNode_code("S101");		
	   ad_bean.setVen_code(ven_code);  //경매장
	   ad_bean.setS_idno(String.valueOf(vendor.get("S_IDNO")));  // 경매장 사업자번호
	   ad_bean.setFirm_nm		(neoe_db.getCodeByNm("ven", ven_code));
	   ad_bean.setItem_name(su_bean.getCar_no());
 	   ad_bean.setAcct_dt(su_bean.getComm_date());
   	   ad_bean.setAcct_cont(amt); //수수료관련 전체비용 :^으로 파싱할것 :지급수수료^운반비^부가세^총지출액
	   ad_bean.setInsert_id(insert_id);
     	  count = neoe_db.insertAssetCommRegAutoDocu(ad_bean);
	   System.out.println("매각 수수료전표"+ amt);

	} else if ( chk.equals("2") ) {
			
		  	su_bean  = as_db.getInfoSale(car_mng_id);
			
		  	if ( client_id2.equals( su_bean.getClient_id()) ) { //매매상 다시 확인 
		  		 
			  	 //자동차매매상
				ClientBean client = al_db.getNewClient(su_bean.getClient_id());
		
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
					
				//자산 정보	   
				Hashtable h_asset = as_db.getAssetSaleList(car_mng_id);
					
				String  car_use =  String.valueOf(h_asset.get("CAR_USE")) ;   // 1:리스, 2:렌트		 
				int  sale_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SALE_AMT")))  ;   //매각액		 
				String  assch_date =  String.valueOf(h_asset.get("ASSCH_DATE")) ;   //매각일
			    int  get_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GET_AMT")))  ;   //기초가
			    int  gdep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GDEP_AMT")))  ;   //구매보조금 
			    
			    	// 입금액 ^ 수수료등 ^  취득가액 ^ 과세표준 ^ 부가세예수금 ^ 감가상각 누계액 ^처분이익(처분손실)	      	 
			  // f_sup_amt = AddUtil.parseFloat(Integer.toString(su_bean.getSale_amt()) )  /  AddUtil.parseFloat("1.1") ; //과세표준
			  // sup_amt= (int) f_sup_amt;	  
			  
			    sup_amt= su_bean.getSup_amt();  //공급가	 	 
			   
			   //처분이익(처분손실) 
			    vat_amt = su_bean.getSale_amt() -  sup_amt;	//부가세	
			   
			    
				String item_id = "";
			  	String reg_code = "";	
			
			    if (     sold_cnt  < 1) {
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
					til_bean.setItem_g("차량매각대금");
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
						t_bean.setTax_g("차량매각대금");
						t_bean.setTax_supply(sup_amt);
						t_bean.setTax_value(sale_amt - sup_amt);
						t_bean.setTax_id(su_bean.getClient_id());
						t_bean.setItem_id(item_id);
						t_bean.setTax_bigo("차량매각 - " + su_bean.getCar_no() );			
						
							//20090701부터 사업자단위과세			
						if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
							//종사업장
							Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
							t_bean.setTax_bigo(" "+t_bean.getTax_bigo());
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
						t_bean.setPubForm("R");  //영수함 
						    					
						//공급받는자정보 : 20090608 작업
						t_bean.setRecTel			(String.valueOf(ht_t.get("RECTEL")));
						t_bean.setRecCoRegNo		(String.valueOf(ht_t.get("RECCOREGNO")));
						t_bean.setRecCoName			(String.valueOf(ht_t.get("RECCONAME2")));
						t_bean.setRecCoCeo			(String.valueOf(ht_t.get("RECCOCEO2")));
						t_bean.setRecCoAddr			(String.valueOf(ht_t.get("RECCOADDR")));
						t_bean.setRecCoBizType		(String.valueOf(ht_t.get("RECCOBIZTYPE2")));
						t_bean.setRecCoBizSub		(String.valueOf(ht_t.get("RECCOBIZSUB2"))); 
										
						//전자세금계산서 의무시행 관련 변경	
						//공급받는자가 개인일때와 법인일때 의 처리
						if(String.valueOf(ht_t.get("RECCOREGNO")).length() == 13){
							t_bean.setTax_bigo	(t_bean.getTax_bigo()+"-"+String.valueOf(ht_t.get("RECCOREGNO")));
							t_bean.setRecCoSsn	(String.valueOf(ht_t.get("RECCOREGNO")));
							t_bean.setReccoregnotype("02");//사업자구분-주민등록번호
						}else {
							t_bean.setReccoregnotype("01");//사업자구분-사업자등록번호
						}						
						
						if(!IssueDb.insertTax(t_bean)) flag2 += 1;  
						
						if(!IssueDb.updateTaxAutodocu(tax_no)) flag2 += 1;
					}  //tax
				    		
						//전자세금계산서 발행	
					String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
					if (d_flag1.equals("1"))		flag2 += 1;
						
					System.out.println("자산매각(경매장)등록 계산서 재발행 car_mng_id: " + car_mng_id);
							
			    } //계산서 발행이 안되어 있다면  sold_cnt < 1
			 
			   	
			    String g_name = "";
			    if (gubun2.equals("1")) {
			    	g_name = "경매";
			    } else {
			    	g_name = "수의계약";
			    }
			   /*	   	   
			   remain_amt =  su_bean.getSale_amt() -  su_bean.getGet_amt() -  vat_amt + su_bean.getAdep_amt();
			    jangbu_amt =   su_bean.getGet_amt() -  su_bean.getAdep_amt(); //장부가액  
			   amt = Integer.toString( su_bean.getSale_amt() -  su_bean.getComm_amt() ) + "^" +  Integer.toString( su_bean.getComm_amt() ) + "^" +  Integer.toString( su_bean.getGet_amt() )  + "^" + Integer.toString(sup_amt) + "^" +  Integer.toString(vat_amt) + "^" +  Integer.toString(su_bean.getAdep_amt() ) + "^" + Integer.toString(remain_amt ) + "^" + Integer.toString(jangbu_amt ) ;	       
			   */
			   
			   remain_amt =  su_bean.getSale_amt() -  su_bean.getGet_amt() -  vat_amt + su_bean.getAdep_amt() + su_bean.getGdep_amt() ;  //사용안함 - 20170112
			   jangbu_amt =   su_bean.getGet_amt() -  su_bean.getAdep_amt() - su_bean.getGdep_amt(); //장부가액  
			   amt = Integer.toString( su_bean.getSale_amt() -  su_bean.getComm_amt() ) + "^" +  Integer.toString( su_bean.getComm_amt() ) + "^" +  Integer.toString( su_bean.getGet_amt() )  + "^" + Integer.toString(sup_amt) + "^" +  Integer.toString(vat_amt) + "^" +  Integer.toString(su_bean.getAdep_amt() ) + "^" + Integer.toString(remain_amt ) + "^" + Integer.toString(jangbu_amt ) + "^" + Integer.toString(gdep_amt ) ;	      
			    			   
			   if (!su_bean.getCar_no().equals(su_bean.getFirst_car_no() ) ) {
			      car_no = g_name + " "+  su_bean.getSui_nm() + " " + su_bean.getFirst_car_no() + "(" + su_bean.getCar_no() + ")" ;
			   } else {
			      car_no = g_name + " "+ su_bean.getSui_nm() + " " + su_bean.getCar_no();
			   }
			     	   
			   ad_bean.setAcct_code(acct_code);	
			   ad_bean.setNode_code("S101");	
			   ad_bean.setBank_code("260");
			   ad_bean.setBank_name("신한");
			   ad_bean.setDeposit_no("140-004-023871");
			   ad_bean.setVen_code(ven_code);  //경매장
			   ad_bean.setFirm_nm	(neoe_db.getCodeByNm("ven", ven_code));
			   
			   ad_bean.setVen_type(ven_type);  //사업자번호
			   ad_bean.setS_idno(s_idno);  //사업자번호
			   ad_bean.setVen_code2(ven_code2);  //매매상
			   ad_bean.setFirm_nm2	(neoe_db.getCodeByNm("ven", ven_code2));  //매매상
				   
			 //  System.out.println("ven_code2="+ven_code2 + ":s_idno=" + s_idno+ ": name= " + neoe_db.getCodeByNm("ven", ven_code2));
			   
			   ad_bean.setItem_name(car_no);  //최초등록번호 표시해야 함 (바뀐 경우)
		  	   ad_bean.setAcct_dt(su_bean.getComm_date());
		  	   ad_bean.setAcct_cont(amt); //수수료관련 전체비용 :^으로 파싱할것 :입금액 ^ 수수료등 ^  취득가액 ^ 과세표준 ^ 부가세예수금 ^ 감가상각 누계액 ^처분이익(처분손실)^장부가액^국가보조금  
			   ad_bean.setInsert_id(insert_id);
			   
		       count = neoe_db.insertAssetSaleRegAutoDocu(ad_bean);
				
		       System.out.println("매각 전표"+ amt);	
		  	} //client_id2와 같을 경우만      
	}

%>
<form name='form1' method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">

</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('자동차등록비용 오류발생!');
		location='about:blank';	
<%	}else if(count == 1){%>
		alert('자동전표 오류발생!');
		location='about:blank';	
<%	}else{%>
		alert('처리되었습니다');	
<%	}%>
		var fm = document.form1;
		parent.location='asset_s6_sc_in.jsp<%=hidden_value%>';
		parent.close();
</script>
</body>
</html>
