<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.user_mng.*, acar.client.*, acar.bill_mng.*, acar.res_search.*, acar.car_office.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	out.println("세금계산서 발행하기 2단계"+"<br><br>");
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String brch_id 		= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String car_off_id 	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	
	String tax_g 		= request.getParameter("tax_g")==null?"":request.getParameter("tax_g");
	String tax_bigo 	= request.getParameter("tax_bigo")==null?"":request.getParameter("tax_bigo");
	String req_dt 		= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String reg_gu 		= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String item_list_cnt = request.getParameter("item_list_cnt")==null?"":request.getParameter("item_list_cnt");
	String tax_bigo_t 	= request.getParameter("tax_bigo_t")==null?"":request.getParameter("tax_bigo_t");
	String tax_bigo_50 	= request.getParameter("tax_bigo_50")==null?"":request.getParameter("tax_bigo_50");
	String tax_dt 		= request.getParameter("tax_dt")==null?"":request.getParameter("tax_dt");
	String rent_s_cd	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String cust_st		= request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	
	String i_enp_no 	= request.getParameter("i_enp_no")==null?"":request.getParameter("i_enp_no");
	String i_firm_nm 	= request.getParameter("i_firm_nm")==null?"":request.getParameter("i_firm_nm");
	String i_client_nm 	= request.getParameter("i_client_nm")==null?"":request.getParameter("i_client_nm");
	String i_addr	 	= request.getParameter("i_addr")==null?"":request.getParameter("i_addr");
	String i_sta	 	= request.getParameter("i_sta")==null?"":request.getParameter("i_sta");
	String i_item	 	= request.getParameter("i_item")==null?"":request.getParameter("i_item");
	
	
	
	String con_agnt_nm 	= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	
	String con_agnt_nm2 		= request.getParameter("con_agnt_nm2")==null?"":request.getParameter("con_agnt_nm2");
	String con_agnt_dept2 	= request.getParameter("con_agnt_dept2")==null?"":request.getParameter("con_agnt_dept2");
	String con_agnt_title2 	= request.getParameter("con_agnt_title2")==null?"":request.getParameter("con_agnt_title2");
	String con_agnt_email2 	= request.getParameter("con_agnt_email2")==null?"":request.getParameter("con_agnt_email2");
	String con_agnt_m_tel2 	= request.getParameter("con_agnt_m_tel2")==null?"":request.getParameter("con_agnt_m_tel2");	
		
	String pubform		= request.getParameter("pubform")==null?"":request.getParameter("pubform");
	String doc_st		= request.getParameter("doc_st")==null?"":request.getParameter("doc_st");
	
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String ebill_yn 	= request.getParameter("ebill_yn")==null?"N":request.getParameter("ebill_yn");//트러스빌사용여부
	String reccotaxregno 	= request.getParameter("reccotaxregno")==null?"":request.getParameter("reccotaxregno");//공급받는자 종사업자번호
	
	String etax_item_st		= request.getParameter("etax_item_st")==null?"":request.getParameter("etax_item_st");
	
	if(!con_agnt_email.equals(""))		ebill_yn = "Y";
	if(tax_dt.equals("")) 			tax_dt = req_dt;
	
	out.println("client_id  ="+client_id+"<br>");
	out.println("site_id  ="+site_id+"<br>");
	out.println("brch_id="+brch_id+"<br>");
	out.println("tax_g  ="+tax_g+"<br>");
	out.println("tax_bigo  ="+tax_bigo+"<br>");
	out.println("req_dt  ="+req_dt+"<br>");
	out.println("reg_gu  ="+reg_gu+"<br>");	
	out.println("reg_code="+reg_code+"<br>");
	out.println("item_list_cnt="+item_list_cnt+"<br><br>");
	
	//사용자
	UsersBean o_sender_bean 	= umd.getUsersBean(user_id);
	
	int flag = 0;
	int i_flag2 = 0;
	boolean b_flag1 = false;
	String item_man = "";
	int item_cnt = 0;


	//[2단계] 거래명세서 생성

	Vector vt = IssueDb.getTaxItemListSusi(reg_code);
	int vt_size = vt.size();
	if(reg_gu.equals("3_1")){//선수금
		out.println("선수금 거래구분="+reg_gu+"<br><br>");
	}else if(reg_gu.equals("3_2")){//단기대여
		out.println("단기대여 거래구분="+reg_gu+"<br><br>");
	}else if(reg_gu.equals("3_3")){//매각
		out.println("매각 거래구분="+reg_gu+"<br><br>");
	}else if(reg_gu.equals("3_4")){//차량수리
		out.println("차량수리 거래구분="+reg_gu+"<br><br>");
	}else if(reg_gu.equals("7")){//캐쉬백수익
		out.println("캐쉬백수익 거래구분="+reg_gu+"<br><br>");
	}
	out.println("거래명세서 생성="+vt_size+"<br><br>");
	
	
	
	//세금계산서 작성일 점검 : 발급일이 다음달 10일을 경과하면 안된다.---------------------------------------------------------------------------
	
	//다음달10일이 수정기한
	String modify_deadline = AddUtil.replace(c_db.addMonth(AddUtil.ChangeDate2(tax_dt), 1),"-","").substring(0,6)+"10";
	modify_deadline = AddUtil.replace(af_db.getValidDt(modify_deadline),"-","");
	if(modify_deadline.equals("20171010")) modify_deadline = "20171013";
	String today = AddUtil.getDate(4);
	
	
	//수정기한보다 오늘날짜가 클 경우 - 당월1일로 강제 셋팅한다.->강제중단
	if(AddUtil.parseInt(modify_deadline) < AddUtil.parseInt(today)){//!reg_gu.equals("6") && 
		//당월1일로 강제 셋팅한다.
		//tax_dt = today.substring(0,6)+"01";
		
		//강제중단 : 삭제
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;
		return;
	}
	
	
	for(int i=0;i < vt_size;i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		TaxItemBean ti_bean = new TaxItemBean();
		ti_bean.setClient_id		(client_id);
		ti_bean.setSeq			(site_id);
		ti_bean.setItem_dt		(tax_dt);
		ti_bean.setTax_id		("");
		ti_bean.setItem_id		(String.valueOf(ht.get("ITEM_ID")));
		ti_bean.setItem_hap_str		(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"원");
		ti_bean.setItem_hap_num		(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
		ti_bean.setItem_man		(String.valueOf(ht.get("ITEM_MAN")));
		ti_bean.setItem_dt		(String.valueOf(ht.get("ITEM_DT")));
		ti_bean.setCust_st		(cust_st);
		
		if(reg_gu.equals("7")){//캐쉬백수익
			ti_bean.setClient_id		(car_off_id);
		}
		
		if(ti_bean.getItem_dt().equals("") || ti_bean.getItem_dt().equals("null")) 	ti_bean.setItem_dt		(req_dt);
		
		ti_bean.setEtax_item_st		(etax_item_st);
		
		if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
		
		item_man = ti_bean.getItem_man();
		
		item_cnt = AddUtil.parseInt(String.valueOf(ht.get("ITEM_CNT")));
	}


	if(reg_gu.equals("6") && doc_st.equals("2")){		
			
	}else if(client_id.equals("022660")){	//만도 - 대여료는 타시스템 기타는 우리시스템 발해이 있을 수 있음.	

	}else{
	
		//[3단계] 세금계산서 생성
		if(!reg_gu.equals("3_6") && !reg_gu.equals("3_4")){//3_6 휴차료는 거래명세서 발행까지만 한다. 20161121 면책금 발행안한다.
		
			//사용할 tax_no 가져오기
			String tax_no = IssueDb.getTaxNoNext();
			String min_tax_no = tax_no;
			out.println("tax_no="+tax_no+"<br><br>");

			Vector vt2 = IssueDb.getTaxItemSusi(reg_code);
			int vt_size2 = vt2.size();
			out.println("세금계산서 생성="+vt_size2+"<br><br>");
		
			for(int i=0;i < vt_size2;i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);
			
				//tax_no = min_tax_no.substring(0,3)+AddUtil.addZero5(AddUtil.parseInt(min_tax_no.substring(3))+i);
			
				tax.TaxBean t_bean = new tax.TaxBean();
			
				t_bean.setCust_st		(cust_st);
				t_bean.setClient_id		(client_id);
				t_bean.setSeq			(site_id);
				t_bean.setTax_dt		(tax_dt);
				t_bean.setBranch_g		(brch_id);
				t_bean.setTax_g			(tax_g);
				t_bean.setTax_bigo		(tax_bigo);
				if(reg_gu.equals("3_9"))	t_bean.setTax_bigo(tax_bigo_50);
			
			
				if(!t_bean.getBranch_g().equals("S1")){
					//종사업장
					Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
//					t_bean.setTax_bigo(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
					t_bean.setBranch_g		("S1");
					t_bean.setBranch_g2		(brch_id);
					t_bean.setTaxregno		(String.valueOf(br2.get("TAXREGNO")));
				}
			
				t_bean.setTax_no		(tax_no);
				t_bean.setRent_l_cd		(String.valueOf(ht.get("RENT_L_CD")));
				t_bean.setFee_tm		(String.valueOf(ht.get("TM")));
				t_bean.setCar_mng_id		(String.valueOf(ht.get("CAR_MNG_ID")));
				
//				if(AddUtil.parseInt(item_list_cnt) == 1){
				if(item_cnt == 1){
					t_bean.setUnity_chk("0");//통합여부0=개별,1=통합
				}else{
					t_bean.setUnity_chk("1");//통합여부0=개별,1=통합
				}
			
				t_bean.setTax_supply		(AddUtil.parseInt(String.valueOf(ht.get("TAX_SUPPLY"))));
				t_bean.setTax_value		(AddUtil.parseInt(String.valueOf(ht.get("TAX_VALUE"))));
				t_bean.setTax_id		(String.valueOf(ht.get("CLIENT_ID")));
				t_bean.setItem_id		(String.valueOf(ht.get("ITEM_ID")));
				t_bean.setCar_no		(String.valueOf(ht.get("CAR_NO")));
				t_bean.setCar_nm		(String.valueOf(ht.get("CAR_NM")));
				t_bean.setTax_st		("O");
				t_bean.setReg_id		(user_id);
			
			  	if(site_id.equals("") || site_id.equals("00")){
		  			t_bean.setTax_type	("1");
  				}else{
  					t_bean.setTax_type	("2");
	  			}
			
				t_bean.setGubun			(String.valueOf(ht.get("GUBUN")));
				t_bean.setCon_agnt_nm		(con_agnt_nm);
				t_bean.setCon_agnt_dept		(con_agnt_dept);
				t_bean.setCon_agnt_title	(con_agnt_title);
				t_bean.setCon_agnt_email	(con_agnt_email.trim());
				t_bean.setCon_agnt_m_tel	(con_agnt_m_tel);
				t_bean.setCon_agnt_nm2		(con_agnt_nm2);
				t_bean.setCon_agnt_dept2		(con_agnt_dept2);
				t_bean.setCon_agnt_title2	(con_agnt_title2);
				t_bean.setCon_agnt_email2	(con_agnt_email2.trim());
				t_bean.setCon_agnt_m_tel2	(con_agnt_m_tel2);
				t_bean.setPubForm		(pubform);
			
			
				//공급받는자정보 : 20090608 작업
				t_bean.setRecTel		(String.valueOf(ht.get("RECTEL")));
				t_bean.setRecCoRegNo		(String.valueOf(ht.get("RECCOREGNO")));
				t_bean.setRecCoName		(String.valueOf(ht.get("RECCONAME2")));
				t_bean.setRecCoCeo		(String.valueOf(ht.get("RECCOCEO")));
				t_bean.setRecCoAddr		(String.valueOf(ht.get("RECCOADDR")));
				t_bean.setRecCoBizType		(String.valueOf(ht.get("RECCOBIZTYPE2")));
				t_bean.setRecCoBizSub		(String.valueOf(ht.get("RECCOBIZSUB2")));
				t_bean.setRecCoTaxRegNo		(reccotaxregno);
			
			
				//공급받는자가 개인일때와 법인일대의 처리
				if(String.valueOf(ht.get("RECCOREGNO")).length() == 13){//개인
					t_bean.setRecCoSsn	(String.valueOf(ht.get("RECCOREGNO")));
					t_bean.setReccoregnotype("02");//사업자구분-주민등록번호
					if(String.valueOf(ht.get("NATIONALITY")).equals("2")){//외국인 20120423					
						t_bean.setRecCoSsn		(t_bean.getRecCoRegNo());
						t_bean.setReccoregnotype	("03");//사업자구분-외국인등록번호
						if(!t_bean.getRecCoRegNo().equals("9999999999999")){//외국인
							t_bean.setTax_bigo	(t_bean.getTax_bigo()+" ("+t_bean.getRecCoRegNo()+")");
						}
						t_bean.setRecCoRegNo		("9999999999999");
					}
					
				}else{
					t_bean.setReccoregnotype("01");//사업자구분-사업자등록번호
				}
			
				if(reg_gu.equals("3_9")){
			 		t_bean.setPrint_dt(t_bean.getTax_dt());
				}
			
				//단기계약정보
				RentContBean rc_bean = rs_db.getRentContCase(t_bean.getRent_l_cd(), t_bean.getCar_mng_id());
			
				//직원 단기대여일때
				if(t_bean.getGubun().equals("9") && rc_bean.getCust_st().equals("4")){
					//고객정보
					RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
					t_bean.setRecTel			("");
					t_bean.setRecCoRegNo			(rc_bean2.getSsn());
					t_bean.setRecCoName			(rc_bean2.getCust_nm());
					t_bean.setRecCoCeo			(rc_bean2.getCust_nm());
					t_bean.setRecCoAddr			(rc_bean2.getAddr());
					t_bean.setRecCoBizType			("");
					t_bean.setRecCoBizSub			("");
					t_bean.setRecCoSsn			(rc_bean2.getSsn());
					t_bean.setReccoregnotype		("02");//사업자구분-주민등록번호
					t_bean.setRecCoTaxRegNo			("");
					t_bean.setCust_st			("4");
				
					cust_st = "4";
					rent_s_cd = t_bean.getRent_l_cd();
				}
				
				//대차료-업무지원
				if(reg_gu.equals("3_9") && !rent_s_cd.equals("") && cust_st.equals("4")){
					UsersBean cust_bean 	= umd.getUsersBean(client_id);
					t_bean.setRecTel			(cust_bean.getUser_m_tel());
					t_bean.setRecCoRegNo			(cust_bean.getUser_ssn());
					t_bean.setRecCoName			(cust_bean.getUser_nm());
					t_bean.setRecCoCeo			(cust_bean.getUser_nm());
					t_bean.setRecCoAddr			(cust_bean.getAddr());
					t_bean.setRecCoBizType			("");
					t_bean.setRecCoBizSub			("");
					t_bean.setRecCoSsn			(cust_bean.getUser_ssn());
					t_bean.setReccoregnotype		("02");//사업자구분-주민등록번호
					t_bean.setRecCoTaxRegNo			("");
					t_bean.setCust_st			("4");
				}
	
				//캐쉬백수익
				if(reg_gu.equals("7")){
					//공급받는자-영업소
					CarOffBean co_bean = cod.getCarOffBean(car_off_id);				
					
					t_bean.setRecTel			(co_bean.getCar_off_tel());
					t_bean.setRecCoRegNo			(i_enp_no);
					t_bean.setRecCoName			(i_firm_nm);
					t_bean.setRecCoCeo			(i_client_nm);
					t_bean.setRecCoAddr			(i_addr);
					t_bean.setRecCoBizType			(i_sta);
					t_bean.setRecCoBizSub			(i_item);
					t_bean.setRecCoSsn			("");
					t_bean.setReccoregnotype		("01");//사업자구분-사업자등록번호
					t_bean.setRecCoTaxRegNo			("");
					t_bean.setCust_st			("5");
					t_bean.setVen_code			(ven_code);
					t_bean.setClient_id			(car_off_id);
				}
			
				//직접발행 -부계산서일 겨우 수정세금계산서 처리
				if(t_bean.getGubun().equals("") && t_bean.getTax_supply()<0){
					t_bean.setDoctype			("02");
				}
				
				if(!reg_gu.equals("7")){
				
					//계산서 비고 미표시 요청업체
					if(String.valueOf(ht.get("BIGO_YN")).equals("N")){
						t_bean.setTax_bigo		("");
					//비고에 추가삽입분 적용
					}else if(String.valueOf(ht.get("BIGO_YN")).equals("A") || String.valueOf(ht.get("BIGO_YN")).equals("B")){
						if(String.valueOf(ht.get("BIGO_YN")).equals("B")){
							t_bean.setTax_bigo		("");
						}
						String tax_bigo_text = t_bean.getTax_bigo();
						tax_bigo_text = tax_bigo_text + " " + String.valueOf(ht.get("BIGO_VALUE1"));
						if(!String.valueOf(ht.get("BIGO_VALUE2")).equals("") && AddUtil.parseInt(String.valueOf(ht.get("BIGO_VALUE2"))) >0 ){
							tax_bigo_text = tax_bigo_text + " " + (AddUtil.parseInt(String.valueOf(ht.get("BIGO_VALUE2")))+1);
							//client bigo_value2 ++
							IssueDb.updateClientBigoValue2Add(client_id);
						}
						t_bean.setTax_bigo		(tax_bigo_text);
					}else if(String.valueOf(ht.get("BIGO_YN")).equals("C")){
						String tax_bigo_text = t_bean.getTax_bigo();
						//거래처지점정보
						ClientSiteBean site = al_db.getClientSite(client_id, site_id);
						tax_bigo_text = tax_bigo_text + " " + site.getBigo_value();
						t_bean.setTax_bigo		(tax_bigo_text);
					}
				}
			
				if(!IssueDb.insertTax(t_bean)) flag += 1;
				
				out.println("세금계산서 생성="+flag+"<br><br>");
			
				if(reg_gu.equals("3_9")){
					UsersBean sender_bean 	= umd.getUsersBean(user_id);
					UsersBean target_bean 	= umd.getUserNmBean(item_man);
					if(!sender_bean.getUser_nm().equals(target_bean.getUser_nm())){
						//IssueDb.insertsendMail(sender_bean.getUser_m_tel(), sender_bean.getUser_nm(), target_bean.getUser_m_tel(), target_bean.getUser_nm(), "", "", "[대차료계산서발행]"+t_bean.getCar_no());
					}
				}
			
				if(reg_gu.equals("3_9") && !rent_s_cd.equals("") && cust_st.equals("4")){
				}else if(reg_gu.equals("3_2") && !rent_s_cd.equals("") && cust_st.equals("4")){
				}else if(reg_gu.equals("7")){
				}else{
					
					//거래처 네오엠 등록관리
					if(site_id.equals("") || site_id.equals("00")){
						//거래처정보
						ClientBean client = al_db.getClient(client_id);
						ven_code = client.getVen_code();
						if(ven_code.equals("")){
							if(String.valueOf(ht.get("RECCOREGNO")).length() == 13)		ven_code = neoe_db.getVenCode(String.valueOf(ht.get("RECCOREGNO")), "");	
							else								ven_code = neoe_db.getVenCode2("", String.valueOf(ht.get("RECCOREGNO")));	
						
							if(ven_code.equals("")){
								TradeBean tr_bean = new TradeBean();
								//tr_bean.setCust_code	(cust_code);
								tr_bean.setCust_name	(AddUtil.substring(client.getFirm_nm(),15));
								tr_bean.setS_idno	(client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
								tr_bean.setId_no	(client.getSsn1()+client.getSsn2());
								tr_bean.setDname	(AddUtil.substring(client.getClient_nm(),15));
								tr_bean.setMail_no	(client.getO_zip());
								tr_bean.setS_address	(AddUtil.substring(client.getO_addr(),30));
								tr_bean.setUptae	(AddUtil.substring(client.getBus_cdt(),15));
								tr_bean.setJong		(AddUtil.substring(client.getBus_itm(),15));
								if(!neoe_db.insertTrade(tr_bean)) i_flag2 += 1;	//-> neoe_db 변환
							
								if(String.valueOf(ht.get("RECCOREGNO")).length() == 13)		ven_code = neoe_db.getVenCode(String.valueOf(ht.get("RECCOREGNO")), "");	
								else								ven_code = neoe_db.getVenCode2("", String.valueOf(ht.get("RECCOREGNO")));

								client.setVen_code	(ven_code);
								out.println("네오엠거래처 생성="+ven_code+"<br><br>");
							}else{
								client.setVen_code	(ven_code);
							}
							if(!al_db.updateNewClient2(client)) i_flag2 += 1;
						}
					}else{
						ClientSiteBean c_site = al_db.getClientSite(client_id, site_id);
						ven_code = c_site.getVen_code();
						if(ven_code.equals("")){
							if(String.valueOf(ht.get("RECCOREGNO")).length() == 13)		ven_code = neoe_db.getVenCode(String.valueOf(ht.get("RECCOREGNO")), "");	//-> neoe_db 변환
							else								ven_code = neoe_db.getVenCode2("", String.valueOf(ht.get("RECCOREGNO")));	//-> neoe_db 변환
						
							if(ven_code.equals("")){
								TradeBean tr_bean = new TradeBean();
								//tr_bean.setCust_code	(cust_code);
								tr_bean.setCust_name	(AddUtil.substring(c_site.getR_site(),15));
								if(String.valueOf(ht.get("RECCOREGNO")).length() == 10)		tr_bean.setS_idno	(c_site.getEnp_no());
								if(String.valueOf(ht.get("RECCOREGNO")).length() == 13)		tr_bean.setId_no	(c_site.getEnp_no());
								tr_bean.setDname	(AddUtil.substring(c_site.getSite_jang(),15));
								tr_bean.setMail_no	(c_site.getZip());
								tr_bean.setS_address	(AddUtil.substring(c_site.getAddr(),30));
								tr_bean.setUptae	(AddUtil.substring(c_site.getBus_cdt(),15));
								tr_bean.setJong		(AddUtil.substring(c_site.getBus_itm(),15));
								if(!neoe_db.insertTrade(tr_bean)) i_flag2 += 1;	//-> neoe_db 변환
								
								if(String.valueOf(ht.get("RECCOREGNO")).length() == 13)		ven_code = neoe_db.getVenCode(String.valueOf(ht.get("RECCOREGNO")), "");	//-> neoe_db 변환
								else								ven_code = neoe_db.getVenCode2("", String.valueOf(ht.get("RECCOREGNO")));	//-> neoe_db 변환
								
								c_site.setVen_code	(ven_code);
								out.println("네오엠거래처 생성="+ven_code+"<br><br>");
							}else{
								c_site.setVen_code	(ven_code);
							}
							b_flag1 = al_db.updateClientSite(c_site);
							out.println("거래명세서 생성="+vt_size+"<br><br>");
						}
					}
					
					out.println("거래처 수정="+ven_code+"<br><br>");
				}
			}	
		}
	}
	

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		
	//	fm.action = 'https://fms3.amazoncar.co.kr/acar/admin/call_sp_tax_ebill_etc.jsp';
		fm.action = '/acar/admin/call_sp_tax_ebill_etc.jsp';
		fm.submit();				
			
	}
	
	function p_tax_ebill_item_email(){
		var fm = document.form1;
		fm.action = '/tax/issue_1_item/tax_reg_step3_proc.jsp';
		fm.target = 'i_no';
		fm.submit();		
	}		
			
	/*
	function go_step(){
		var fm = document.form1;
		if(fm.reg_gu.value == '3_3'){		
			alert("정상적으로 발행하였습니다.");
			fm.action = '/tax/issue_3/issue_3_frame3.jsp';		
			fm.target = 'd_content';			
		}else if(fm.reg_gu.value == '3_6'){
			alert("정상적으로 발행하였습니다.");
			fm.action = '/tax/issue_3/issue_3_frame6.jsp';		
			fm.target = 'd_content';					
		}else{
			fm.action = '../issue_1/tax_reg_step4.jsp';
		}		
		fm.submit();
	}
	*/
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='client_id' 	value='<%=client_id%>'>
<input type='hidden' name='site_id' 	value='<%=site_id%>'>
<input type='hidden' name='brch_id' 	value='<%=brch_id%>'>
<input type='hidden' name='tax_g' 	value='<%=tax_g%>'>
<input type='hidden' name='tax_bigo' 	value='<%=tax_bigo%>'>
<input type='hidden' name='req_dt' 	value='<%=req_dt%>'>
<input type='hidden' name='reg_gu' 	value='<%=reg_gu%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='ebill_yn' 	value='<%=ebill_yn%>'>
<input type='hidden' name='tax_bigo_t' 	value='<%=tax_bigo_t%>'>
<input type='hidden' name='tax_bigo_50' value='<%=tax_bigo_50%>'>
<input type='hidden' name='go_url' 	value='<%=go_url%>'>
<input type="hidden" name="rent_s_cd" 	value="<%=rent_s_cd%>">      
<input type="hidden" name="cust_st"	value="<%=cust_st%>">             
<input type='hidden' name='sender_nm' 	value='<%=o_sender_bean.getSa_code()%>'>
<input type='hidden' name='doc_st' 	value='<%=doc_st%>'>

<a href="javascript:go_step()">3단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생
		//이미 작성한 거래명서세/세금계산서  삭제
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("거래명세서/세금계산서 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>

		<%if(reg_gu.equals("6") && doc_st.equals("2")){%>
		p_tax_ebill_item_email();
		<%}else if(client_id.equals("022660")){%>
		p_tax_ebill_item_email();
		<%}else{%>
		go_step();
		<%}%>
<%	}%>
//-->
</script>
</form>
</body>
</html>
