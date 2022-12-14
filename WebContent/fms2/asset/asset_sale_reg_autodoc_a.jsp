<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.cont.*, acar.user_mng.*, acar.asset.*, acar.client.*, tax.*, acar.bill_mng.*"%>
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
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
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
	String chk			= request.getParameter("chk")==null?"":request.getParameter("chk");	// chk -> 1:?????? ????, 2:???? ????
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");  //????????
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code"); //??????
	String client_id2 	= request.getParameter("client_id2")==null?"":request.getParameter("client_id2"); //??????  - ?????? ?? 
	
	String hidden_value = "";
	
	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc;
					
	boolean flag = true;
	int count =0;
	boolean flag1 = true;
	int count1 =0;
	int	flag2 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AssetDatabase as_db = AssetDatabase.getInstance();
		
	//???????? ????-?????? ???????? ????
	String autodoc = request.getParameter("autodoc")==null?"N":request.getParameter("autodoc");
	
	//?????? ???? ???? 
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
	
	
	//?????????? ???????? - ?????????? ???? ????
	int sold_cnt = 1;
	
	sold_cnt  = ac_db.getCarSoldCnt(car_mng_id);
//	System.out.println(????  ???? ?????? ???? - " + sold_cnt);

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
//	String node_code = String.valueOf(per.get("NODE_CODE"));
	String node_code ="S101";  //?????? iu ?????? ????????:S101	
		
	Hashtable vendor = neoe_db.getVendorCase(ven_code);	  //?????? ????
	  
	if ( chk.equals("1") ) {
	
	   su_bean  = as_db.getInfoComm(car_mng_id);
	 			
	   amt = Integer.toString( su_bean.getComm1_sup() + su_bean.getComm2_sup()) + "^" + Integer.toString( su_bean.getComm3_sup())  + "^" +  Integer.toString( su_bean.getComm1_vat()+ su_bean.getComm2_vat() + su_bean.getComm3_vat() )   + "^" +  Integer.toString(su_bean.getComm1_sup()+ su_bean.getComm2_sup() + su_bean.getComm3_sup() +  su_bean.getComm1_vat()+ su_bean.getComm2_vat() + su_bean.getComm3_vat() ) ;
	
	   ad_bean.setNode_code("S101");		
	   ad_bean.setVen_code(ven_code);  //??????
	   ad_bean.setS_idno(String.valueOf(vendor.get("S_IDNO")));  // ?????? ??????????
	   ad_bean.setFirm_nm		(neoe_db.getCodeByNm("ven", ven_code));
	   ad_bean.setItem_name(su_bean.getCar_no());
 	   ad_bean.setAcct_dt(su_bean.getComm_date());
   	   ad_bean.setAcct_cont(amt); //?????????? ???????? :^???? ???????? :??????????^??????^??????^????????
	   ad_bean.setInsert_id(insert_id);
      	   count = neoe_db.insertAssetCommRegAutoDocu(ad_bean);
	   System.out.println("???? ??????????"+ amt);

	} else if ( chk.equals("2") ) {
		
		//???? ???? ????
	//	s_flag =  as_db.call_sp_insert_assetmove2_off(real_date.substring(0,4), real_date.substring(4,6), car_mng_id, user_id );
	//	System.out.println("????????(??????)????" + s_flag);
	  
	    su_bean  = as_db.getInfoSale(car_mng_id);
		
	    if ( client_id2.equals(su_bean.getClient_id()) ) { //?????? ???? ???? 
	    
			//????????????
			ClientBean client = al_db.getNewClient(su_bean.getClient_id());
	
			client_st = client.getClient_st(); //2:????
			ven_code2 = client.getVen_code(); //??????
			
			String i_ssn = "";
			i_ssn = client.getSsn1() + client.getSsn2();
			
			String i_enp_no = client.getEnp_no1() + client.getEnp_no2()+ client.getEnp_no3();
			if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() + client.getSsn2();
			
			if(ven_code2.equals("")){
				if(client_st.equals("2"))	ven_code2 = neoe_db.getVenCode(i_ssn,i_enp_no);
				if(!client_st.equals("2"))	ven_code2 = neoe_db.getVenCode2(i_ssn,i_enp_no);
			}
			
			if(client_st.equals("2")){
				ven_type = "1";  //????????
				s_idno   =	i_ssn;
			}else{
				ven_type = "0";  //??????
				s_idno   =	i_enp_no;
			}
					
				//???? ????	   
			Hashtable h_asset = as_db.getAssetSaleList(car_mng_id);
				
			String  car_use =  String.valueOf(h_asset.get("CAR_USE")) ;   // 1:????, 2:????		 
			int  sale_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SALE_AMT")))  ;   //??????		 
			String  assch_date =  String.valueOf(h_asset.get("ASSCH_DATE")) ;   //??????
		    int  get_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GET_AMT")))  ;   //??????
		    int  book_dr =  AddUtil.parseInt(String.valueOf(h_asset.get("BOOK_DR")))  ;   //????????
		    int  jun_reser =  AddUtil.parseInt(String.valueOf(h_asset.get("JUN_RESER")))  ;   //??????????????
		    int  dep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("DEP_AMT")))  ;   //??????????
		    int  gdep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GDEP_AMT")))  ;   //?????????? 
		    
		    sup_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SUP_AMT")))  ;   //??????
		    
		    amt_10800 = sale_amt + 	jun_reser + dep_amt + gdep_amt  - get_amt  - book_dr - ( sale_amt - sup_amt); 		
		  	
		  	String item_id = "";
		  	String reg_code = "";	
		
		    if (     sold_cnt  < 1) {
			    //???????? ?????????? 
				tax_no = IssueDb.getTaxNoNext(assch_date);
			
				//?????? item_id ????????
				item_id = IssueDb.getItemIdNext(assch_date);
			//	out.println("item_id="+item_id+"<br><br>");
			    		
				//???????? ????????
				reg_code  = Long.toString(System.currentTimeMillis());
			//	out.println("????????="+reg_code+"<br>");
			
				//[1????] ?????????? ?????? ????		
				TaxItemListBean til_bean = new TaxItemListBean();			
				til_bean.setItem_id(item_id);
				til_bean.setItem_seq(1);
				til_bean.setItem_g("????????????");
				til_bean.setItem_car_no(su_bean.getCar_no());
				til_bean.setItem_car_nm(su_bean.getCar_nm());
				til_bean.setItem_supply(sup_amt);
				til_bean.setItem_value(sale_amt - sup_amt );
				til_bean.setRent_l_cd("");
				til_bean.setCar_mng_id(car_mng_id);
			 	til_bean.setGubun("6");   //?????????? ?????? ?? :gubun = 1 ??????, 2 ??????, 3 ??????, 4 ??????????, 5 ??????, 6 ????????????, 7 ??????, 8 ??????, 9 self, 10 ????????, 11 ??????, 12 ??????, 13 ???????? 15:????????
				til_bean.setReg_id(user_id);
				til_bean.setReg_code(reg_code);				
				til_bean.setCar_use(""); //?????????????? ???????? ???? ????  
				til_bean.setItem_dt(assch_date);  //?????????????? ???????? ???? ????	
						
				if(!IssueDb.insertTaxItemList(til_bean)) flag2 += 1;
					    		
				//[2????] ?????????? ????
				Vector vt = IssueDb.getTaxItemListSusi(reg_code);
				int vt_size = vt.size();
			//	out.println("?????????? ????="+vt_size+"<br><br>");
				
				for(int j=0;j < vt_size;j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					TaxItemBean ti_bean = new TaxItemBean();
					ti_bean.setClient_id(su_bean.getClient_id());
					ti_bean.setSeq("");
					ti_bean.setItem_dt(assch_date);
					ti_bean.setTax_id("");
					ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
					ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"??");
					ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
					ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
					
					if(!IssueDb.insertTaxItem(ti_bean)) flag2 += 1;
				}
		
				//[3????] ?????????? ????		
				Vector vt2 = IssueDb.getTaxItemSusi(reg_code);
						    	
				int vt_size2 = vt2.size();
			//	out.println("?????????? ????="+vt_size2+"<br><br>");
				
				if (tax_branch.equals("")) tax_branch = br_id;
				
				for(int i=0;i < vt_size2;i++){
					Hashtable ht_t = (Hashtable)vt2.elementAt(i);
							
					tax.TaxBean t_bean = new tax.TaxBean();			
							
					t_bean.setClient_id(su_bean.getClient_id());  	
					t_bean.setTax_dt(assch_date);
					
					t_bean.setUnity_chk("0");//????????0=????,1=????
					t_bean.setRent_l_cd("");
					t_bean.setFee_tm("");
					t_bean.setCar_mng_id(car_mng_id);
					t_bean.setBranch_g(tax_branch);
					t_bean.setTax_g("????????????");
					t_bean.setTax_supply(sup_amt);
					t_bean.setTax_value(sale_amt - sup_amt);
					t_bean.setTax_id(su_bean.getClient_id());
					t_bean.setItem_id(item_id);
					t_bean.setTax_bigo("???????? - " + su_bean.getCar_no() );			
					
						//20090701???? ??????????????			
					if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
						//????????
						Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
						t_bean.setTax_bigo(" "+t_bean.getTax_bigo());
						t_bean.setBranch_g("S1");
						t_bean.setBranch_g2(tax_branch);
						t_bean.setTaxregno(String.valueOf(br2.get("TAXREGNO")));	 //?????????????? ???????? ???? ????
					} 
					
					t_bean.setSeq("");  
					t_bean.setTax_no(tax_no);
					t_bean.setCar_no(su_bean.getCar_no());
					t_bean.setCar_nm(su_bean.getCar_nm());
					t_bean.setTax_st("O");
					t_bean.setTax_type("1");  //?????? ????
					t_bean.setReg_id(user_id);
					t_bean.setGubun("6");
					t_bean.setPubForm("R");  //?????? 
					    					
					//?????????????? : 20090608 ????
					t_bean.setRecTel			(String.valueOf(ht_t.get("RECTEL")));
					t_bean.setRecCoRegNo		(String.valueOf(ht_t.get("RECCOREGNO")));
					t_bean.setRecCoName			(String.valueOf(ht_t.get("RECCONAME2")));
					t_bean.setRecCoCeo			(String.valueOf(ht_t.get("RECCOCEO2")));
					t_bean.setRecCoAddr			(String.valueOf(ht_t.get("RECCOADDR")));
					t_bean.setRecCoBizType		(String.valueOf(ht_t.get("RECCOBIZTYPE2")));
					t_bean.setRecCoBizSub		(String.valueOf(ht_t.get("RECCOBIZSUB2"))); 
									
					//?????????????? ???????? ???? ????	
					//???????????? ?????????? ?????? ????
					if(String.valueOf(ht_t.get("RECCOREGNO")).length() == 13){
						t_bean.setTax_bigo	(t_bean.getTax_bigo()+"-"+String.valueOf(ht_t.get("RECCOREGNO")));
						t_bean.setRecCoSsn	(String.valueOf(ht_t.get("RECCOREGNO")));
						t_bean.setReccoregnotype("02");//??????????-????????????
					}else {
						t_bean.setReccoregnotype("01");//??????????-??????????????
					}						
					
					if(!IssueDb.insertTax(t_bean)) flag2 += 1;  
					
					if(!IssueDb.updateTaxAutodocu(tax_no)) flag2 += 1;
				} 	
			    		
				//?????????????? ????	
				String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
				if (d_flag1.equals("1"))		flag2 += 1;
		  	}  //?????? ?????? ?????? ??????  //sold_cnt < 1
	  		 	  	
		// ?????? ^ ???????? ^  ???????? ^ ???????? ^ ???????????? ^ ???????? ?????? ^????????(????????)
	      	 
	  // f_sup_amt = AddUtil.parseFloat(Integer.toString(su_bean.getSale_amt()) )  /  AddUtil.parseFloat("1.1") ; //????????
	  // sup_amt= (int) f_sup_amt;	  
	///  sup_amt= su_bean.getSup_amt();  //??????	 	 
	  	 	   
	  	 String g_name = "";
	   	 if (gubun2.equals("1")) {
	   		g_name = "????";
	   	 } else {
	   		g_name = "????????";
	   	 }
	   	   
	  	 vat_amt = su_bean.getSale_amt() -  sup_amt;	//??????	
	   	   	   
	   	 remain_amt =  su_bean.getSale_amt() -  su_bean.getGet_amt() -  vat_amt + su_bean.getAdep_amt() + su_bean.getGdep_amt() ;  //???????? 
	     jangbu_amt =   su_bean.getGet_amt() -  su_bean.getAdep_amt() - su_bean.getGdep_amt(); //????????  
	     amt = Integer.toString( su_bean.getSale_amt() -  su_bean.getComm_amt() ) + "^" +  Integer.toString( su_bean.getComm_amt() ) + "^" +  Integer.toString( su_bean.getGet_amt() )  + "^" + Integer.toString(sup_amt) + "^" +  Integer.toString(vat_amt) + "^" +  Integer.toString(su_bean.getAdep_amt() ) + "^" + Integer.toString(remain_amt ) + "^" + Integer.toString(jangbu_amt ) + "^" + Integer.toString(gdep_amt ) ;	      
	   	   
	     if (!su_bean.getCar_no().equals(su_bean.getFirst_car_no() ) ) {
	       car_no =  g_name + " "+ su_bean.getSui_nm() + " " + su_bean.getFirst_car_no() + "(" + su_bean.getCar_no() + ")" ;
	     } else {
	       car_no =  g_name + " "+ su_bean.getSui_nm() + " " + su_bean.getCar_no();
	     }
	     	   
	     ad_bean.setAcct_code(acct_code);	
	     ad_bean.setNode_code("S101");	
	     ad_bean.setBank_code("260");
	     ad_bean.setBank_name("????");
	     ad_bean.setDeposit_no("140-004-023871");
	     ad_bean.setVen_code(ven_code);  //??????
	     ad_bean.setFirm_nm	(neoe_db.getCodeByNm("ven", ven_code));
	   
	     ad_bean.setVen_type(ven_type);  //??????????
	     ad_bean.setS_idno(s_idno);  //??????????
	     ad_bean.setVen_code2(ven_code2);  //??????
	     ad_bean.setFirm_nm2	(neoe_db.getCodeByNm("ven", ven_code2));  //??????
		   
	 //  System.out.println("ven_code2="+ven_code2 + ":s_idno=" + s_idno+ ": name= " + neoe_db.getCodeByNm("ven", ven_code2));
	   
	     ad_bean.setItem_name(car_no);  //???????????? ???????? ?? (???? ????)
  	     ad_bean.setAcct_dt(su_bean.getComm_date());
  	     ad_bean.setAcct_cont(amt); //?????????? ???????? :^???? ???????? :?????? ^ ???????? ^  ???????? ^ ???????? ^ ???????????? ^ ???????? ?????? ^????????(????????)^????????^??????????  
	     ad_bean.setInsert_id(insert_id);
	   
	     count = neoe_db.insertAssetSaleRegAutoDocu(ad_bean);
			
	     System.out.println("???? ????"+ amt);	
	    } //client_id2?? ???? ??????      
	}
	
	//???????? ???????????? ????????
	if(!car_mng_id.equals("")){
				
		// ?????? 
		if ( chk.equals("1") ) {
			count1 = as_db.updateSuiEtcComm(car_mng_id);
		}
		else {
		   count1 = as_db.updateSuiEtcSale(car_mng_id);
		}  
		 
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
		alert('?????????????? ????????!');
		location='about:blank';	
<%	}else if(count == 1){%>
		alert('???????? ????????!');
		location='about:blank';		
<%	}else if(count1 == 0){%>
		alert('???????? ???? ????????!');
		location='about:blank';	
<%	}else{%>
		alert('??????????????');	
<%	}%>
		var fm = document.form1;
		parent.location='asset_s6_sc_in.jsp<%=hidden_value%>';
		parent.close();
</script>
</body>
</html>
