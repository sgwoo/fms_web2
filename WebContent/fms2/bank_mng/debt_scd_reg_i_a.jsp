<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.forfeit_mng.*, acar.cont.*, acar.bank_mng.*, acar.fee.*, acar.debt.*, acar.coolmsg.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="code_bean" scope="page" class="acar.common.CodeBean"/>
<jsp:useBean id="ce_bean" class="acar.common.CodeEtcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
	
	String cont_dt1 	= request.getParameter("cont_dt1")==null?"":request.getParameter("cont_dt1");
	String doc_id 		= request.getParameter("doc_id")==null?"":request.getParameter("doc_id"); //대출문서번호
	String cpt_cd 		= request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String cpt_cd_st 	= request.getParameter("cpt_cd_st")==null?"":request.getParameter("cpt_cd_st");
	String loan_st 		= request.getParameter("loan_st")==null?"1":request.getParameter("loan_st");
	String lend_id 		= request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq 		= request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	
	String rtn_est_dt 	= request.getParameter("rtn_est_dt")==null?"":request.getParameter("rtn_est_dt");
	String fst_pay_dt 	= request.getParameter("fst_pay_dt")==null?"":request.getParameter("fst_pay_dt");
	String lend_int = request.getParameter("lend_int")==null?"":request.getParameter("lend_int");
	String lend_int_way 	= request.getParameter("lend_int_way")==null?"":request.getParameter("lend_int_way");
	String lend_int_way2 	= request.getParameter("lend_int_way2")==null?"":request.getParameter("lend_int_way2");
	String lend_int_per 	= request.getParameter("lend_int_per")==null?"":request.getParameter("lend_int_per");
	
	String lend_alt_way 	= request.getParameter("lend_alt_way")==null?"":request.getParameter("lend_alt_way");
	String f_day_account 	= request.getParameter("f_day_account")==null?"":request.getParameter("f_day_account");
	String e_day_account 	= request.getParameter("e_day_account")==null?"":request.getParameter("e_day_account");
	String int_day_account 	= request.getParameter("int_day_account")==null?"":request.getParameter("int_day_account");
	
	String card_yn		= request.getParameter("card_yn")==null?"":request.getParameter("card_yn");
	int f_prn_amt = request.getParameter("f_prn_amt")==null?0:Util.parseDigit(request.getParameter("f_prn_amt"));
	String lend_scd_reg_yn		= request.getParameter("lend_scd_reg_yn")==null?"":request.getParameter("lend_scd_reg_yn");
	
	
	
	String out_text = "";
	
	
	String fund_id 	= request.getParameter("fund_id")==null?"":request.getParameter("fund_id");
	
	if(loan_st.equals("2") && rtn_seq.equals("")){
		rtn_seq = "1";
	}
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	
	int lend_prn = 0;
	int pay_sch_amt = 0;
	int dif_amt = 0;
	int use_days = 0;
	
	
	int flag = 0;
	int flag2 = 0;
	int flag3 = 0;
	
	int count = 0;
	
	boolean flag1 = true;
	boolean b_flag2 = true;
	boolean flag7 = true;
	
	//대출번호 수정
	String reg_yn[] 		= request.getParameterValues("reg_yn");
	String case_m_id[] 		= request.getParameterValues("case_m_id");
	String case_l_cd[] 		= request.getParameterValues("case_l_cd");
	String case_lend_prn[] 		= request.getParameterValues("case_lend_prn");
	String case_alt_tm[] 		= request.getParameterValues("case_alt_tm");
	String case_lend_int_amt[] 	= request.getParameterValues("case_lend_int_amt");
	String case_rtn_tot_amt[] 	= request.getParameterValues("case_rtn_tot_amt");
	String case_alt_amt[] 		= request.getParameterValues("case_alt_amt");
	String case_lend_no[] 		= request.getParameterValues("case_lend_no");
	String f_case_alt_amt[] 		= request.getParameterValues("f_case_alt_amt");
	String cardno[] 		= request.getParameterValues("cardno");
	String card_end_dt[] 		= request.getParameterValues("card_end_dt");
	
	
	//대출신청리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	
	for(int i=0; i<FineList.size(); i++){ 
		Hashtable ht = (Hashtable)FineList.elementAt(i);
		
		if(mode.equals("")){
			count = FineDocDb.updateFineDocScd_yn(doc_id);    //대출금 상환스케쥴 등록 = Y
		}
		
		
		if(reg_yn[i].equals("Y")){
			
			if(cpt_cd.equals("0011")){
				lend_prn 	= AddUtil.parseInt(String.valueOf(ht.get("AMT4")));	
			}else{
				lend_prn 	= AddUtil.parseInt(String.valueOf(ht.get("AMT4"))) +  AddUtil.parseInt(String.valueOf(ht.get("AMT5")));
			}
						
			pay_sch_amt 	= AddUtil.parseInt(String.valueOf(ht.get("AMT3"))) ;
			dif_amt 	= pay_sch_amt - lend_prn;
			
			
			//allot update-------------------------------------------------------------------------------------------
			ContDebtBean debt = a_db.getContDebt(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));
			
		    debt.setAllot_st		("2");//구매구분-할부구매
		    debt.setCpt_cd			(cpt_cd);//금융사코드
			debt.setCpt_cd_st		(cpt_cd_st);
		    debt.setLend_int		(lend_int);//대출이율
		    debt.setLend_prn		(case_lend_prn[i]==null?0:Util.parseDigit(case_lend_prn[i]));//대출원금
	    	debt.setAlt_fee			(0);//할부수수료
		    debt.setLoan_debtor		("2");//상환의무자-당사
		    debt.setRtn_cdt			("1");//상환조건-원리금균등
	    	debt.setRtn_way			("1");//상환방법-자동이체
			debt.setRtn_est_dt			(rtn_est_dt);//상환약정일-매월00일자
		    debt.setNtrl_fee		(0);//공증료
	    	debt.setStp_fee			(0);//인지대
		    debt.setLend_dt			(request.getParameter("lend_dt")==null?"":request.getParameter("lend_dt"));//대출일자
		    
		    if(card_yn.equals("Y") && !cardno[i].equals("") && !card_end_dt[i].equals("")){
		    	debt.setLend_dt		(card_end_dt[i]);//대출일자=카드할부실행일		    	
		    }
		    	
	    	debt.setBond_get_st		("2");//채권확보유형-계약서+인감증명서
			debt.setLoan_st			(loan_st);
			
			if ( loan_st.equals("1")) {
			    	debt.setLend_no		(case_lend_no[i]==null?"":case_lend_no[i]);//대출번호
			    	debt.setLend_int_amt	(case_lend_int_amt[i]==null?0:Util.parseDigit(case_lend_int_amt[i]));//대출이자
			    	debt.setAlt_amt		(case_alt_amt[i]==null?0:Util.parseDigit(case_alt_amt[i]));//월상환료
				debt.setRtn_tot_amt	(case_rtn_tot_amt[i]==null?0:Util.parseDigit(case_rtn_tot_amt[i]));//상환총금액
			 	debt.setTot_alt_tm	(case_alt_tm[i]==null?"":case_alt_tm[i]);//할부횟수
		    		debt.setAlt_start_dt	(request.getParameter("fst_pay_dt")==null?"":request.getParameter("fst_pay_dt"));
			    	debt.setFst_pay_dt	(request.getParameter("fst_pay_dt")==null?"":request.getParameter("fst_pay_dt"));//1회차결재일
			    	debt.setFst_pay_amt	(debt.getAlt_amt());//1회차상환금액
				debt.setLend_id		("");//건별 할부는 은행대출아이디는 없다.
				debt.setRtn_seq		("");//건별 할부는 은행대출아이디-일련번호는 없다.
				
				if(!String.valueOf(ht.get("CAR_MNG_ID")).equals("")){
					debt.setCar_mng_id	(String.valueOf(ht.get("CAR_MNG_ID")));//자동차관리번호
				}
				
				debt.setLoan_st_dt	(String.valueOf(ht.get("DOC_DT")));//대출신청일
				debt.setLoan_sch_amt	(debt.getLend_prn());//대출예정금액
				debt.setPay_sch_amt	(pay_sch_amt);//지출예정금액
				debt.setDif_amt		(dif_amt);//차감입금액
		    		debt.setAutodoc_yn	("Y");
				debt.setAcct_code	(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));
				debt.setVen_code	(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
				debt.setBank_code	(request.getParameter("bank_code2")==null?"":request.getParameter("bank_code2"));
				debt.setDeposit_no	(request.getParameter("deposit_no")==null?"":request.getParameter("deposit_no"));
				debt.setCls_rtn_fee_int	(request.getParameter("cls_rtn_fee_int")==null?"":request.getParameter("cls_rtn_fee_int"));
				debt.setCls_rtn_etc		(request.getParameter("cls_rtn_etc")==null?"":request.getParameter("cls_rtn_etc"));
			} else {
				debt.setLend_id		(lend_id); //묶음대출 계약번호.
				debt.setRtn_seq		(rtn_seq); //묶음대출 계약번호 - 일련번호
			}
			debt.setFund_id			(fund_id);
			
			if(mode.equals("")){
				if(!ad_db.updateContDebt(debt))	flag += 1;
			}
			
			
			//20140408 계약승계 등으로 해지된 경우 할부정보 넘기기
			
			//계약기본정보
			ContBaseBean base = a_db.getCont(debt.getRent_mng_id(), debt.getRent_l_cd());
			
			if(base.getUse_yn().equals("N")){
				//allot
				ContDebtBean b_debt = debt;
				
				Hashtable b_cont_view = a_db.getContViewUseYCarCase(base.getCar_mng_id());
				
				if( !String.valueOf(b_cont_view.get("RENT_L_CD")).equals("") && !String.valueOf(b_cont_view.get("RENT_L_CD")).equals(base.getRent_l_cd()) ){
					b_debt.setRent_mng_id	(String.valueOf(b_cont_view.get("RENT_MNG_ID")));
					b_debt.setRent_l_cd	(String.valueOf(b_cont_view.get("RENT_L_CD")));
					if(mode.equals("")){
						if(!ad_db.updateContDebt(b_debt))	flag += 1;
					}	
				}
			}
			
			
			
			
			
			//건별 할부스케줄 생성
			if ( loan_st.equals("1")) {
				
				int r_alt_tm = 0;
				
				//0회차 생성
				DebtScdBean debt0 = new DebtScdBean();
				debt0 = d_db.getADebtScd(debt.getCar_mng_id(), "0");
				
				String use_yn = "N";
				if(!debt0.getCar_mng_id().equals("")) use_yn = "Y";
				
				debt0.setCar_mng_id		(debt.getCar_mng_id());
				debt0.setAlt_tm			(String.valueOf(r_alt_tm));
				debt0.setAlt_est_dt		(debt.getLend_dt());
				debt0.setAlt_prn		(0);
				debt0.setAlt_int		(0);
				debt0.setAlt_rest		(debt.getLend_prn());
				debt0.setPay_yn			("1");
				debt0.setPay_dt			(debt.getLend_dt());
				debt0.setR_alt_est_dt	(debt.getLend_dt());
				
				if(mode.equals("") && !debt.getCar_mng_id().equals("")){
					if(use_yn.equals("N")){
						if(!abl_db.insertScdAltCase(debt0)) flag2 = 1;
					}else{
						if(!d_db.updateDebtScd(debt0)) flag2 = 1;						
					}
				}
				
				
				int tot_amt_tm 	= debt.getTot_alt_tm().equals("")?0:Integer.parseInt(debt.getTot_alt_tm());
				
				if(mode.equals("view") || ck_acar_id.equals("000029")){
					out.println("<br>--할부금상환스케줄생성--<br>");
					out.println("* tot_amt_tm = "+tot_amt_tm+"<br>");
				}	
				
			   	int alt_amt[]	 = new int[tot_amt_tm+1];
				int alt_rest[]	 = new int[tot_amt_tm+1];
				int alt_int[]	 = new int[tot_amt_tm+1];
				String alt_dt[]	 = new String[tot_amt_tm+1];
				
				alt_amt[0]	= debt0.getAlt_prn();
				alt_int[0] 	= debt0.getAlt_int();
				alt_rest[0] 	= debt0.getAlt_rest();
				alt_dt[0]   	= debt0.getAlt_est_dt();
				
				
				
				int tm_add_cnt = 0;
				
				if(mode.equals("view") || ck_acar_id.equals("000029")){
					out.println("car_no="+String.valueOf(ht.get("CAR_NO"))+"<br>");
				}	
				
				for(int j = 1 ; j < tot_amt_tm+1 ; j++){
					
					
					String set_dt = c_db.addMonth(fst_pay_dt, j-1);//1회차납입일+1개월씩 증가
					
					if(!debt.getRtn_est_dt().equals("99")){
						if(!set_dt.substring(5,10).equals("02-28") && !set_dt.substring(5,10).equals("02-29")){
							set_dt=set_dt.substring(0,8)+AddUtil.addZero(debt.getRtn_est_dt());
						}
					}
					
					if(j==1){
						set_dt = fst_pay_dt;
					}
					if(j==tot_amt_tm && e_day_account.equals("Y")){ //마지막회차 일자계산 한다는 별도 계산
						String set_dt2 = c_db.addMonth(debt.getLend_dt(), (tot_amt_tm-1));						
						if(AddUtil.parseInt(alt_dt[j-1])<AddUtil.parseInt(set_dt2)){
							set_dt = set_dt2;
						}
					}
					
					use_days = AddUtil.parseInt(rs_db.getDay(alt_dt[j-1], set_dt))-1;
					

					String str_alt_int = "";
					
					if(mode.equals("view") || ck_acar_id.equals("000029")){
						out.println("st_dt="	+alt_dt[j-1]);
						out.println("ed_dt="	+set_dt);
					}	
					
					
					if(lend_int_way.equals("2")){				//실이용일적용(365)
						str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(debt.getLend_int()) / 100 / 365 * use_days );
					}else if(lend_int_way.equals("4")){	//실이용일적용(실제일수)
						int year_days = year_days = AddUtil.parseInt(rs_db.getDay(alt_dt[j-1].substring(0,4)+""+"0101", set_dt.substring(0,4)+""+"1231"));
						str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(debt.getLend_int()) / 100 / year_days * use_days );
						if(!alt_dt[j-1].substring(0,4).equals(set_dt.substring(0,4))){
							//년도1
							int use_days_1  		= AddUtil.parseInt(rs_db.getDay(alt_dt[j-1], alt_dt[j-1].substring(0,4)+""+"1231"));
							if(int_day_account.equals("2")){//시작일미포함
								use_days_1 = use_days_1-1;
							}
							int year_days_1 		= year_days = AddUtil.parseInt(rs_db.getDay(alt_dt[j-1].substring(0,4)+""+"0101", alt_dt[j-1].substring(0,4)+""+"1231"));
							String str_alt_int_1 	= String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(debt.getLend_int()) / 100 / year_days_1 * use_days_1 );
							//년도2
							int use_days_2 				= AddUtil.parseInt(rs_db.getDay(set_dt.substring(0,4)+""+"0101", set_dt)); //둘다 -1이면 안된다.
							if(int_day_account.equals("1")){//시작일포함
								use_days_2 = use_days_2-1;
							}
							int year_days_2 			= year_days = AddUtil.parseInt(rs_db.getDay(set_dt.substring(0,4)+""+"0101", set_dt.substring(0,4)+""+"1231"));
							String str_alt_int_2 	= String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(debt.getLend_int()) / 100 / year_days_2 * use_days_2 );
							if(year_days_1>year_days_2 || year_days_1<year_days_2){
								str_alt_int = String.valueOf(AddUtil.parseDouble(str_alt_int_1)+AddUtil.parseDouble(str_alt_int_2));
								if(mode.equals("view") || ck_acar_id.equals("000029")){
									out.println("연도가 다름, year_days="+year_days);									
									out.println("year_days_1="+year_days_1);
									out.println("year_days_2="+year_days_2);
									out.println("use_days="+use_days);
									out.println("use_days_1="+use_days_1);
									out.println("use_days_2="+use_days_2);
									out.println("str_alt_int="+str_alt_int);
									out.println("str_alt_int_1="+str_alt_int_1);
									out.println("str_alt_int_2="+str_alt_int_2);																		
								}
							}else{
								str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(debt.getLend_int()) / 100 / year_days * use_days );
							}
						}else{
							if(mode.equals("view") || ck_acar_id.equals("000029")){
								out.println("연도가 같음, year_days="+year_days);
							}							
						}							
					}else if(lend_int_way.equals("3")){	//별도입력값					
						str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(debt.getLend_int()) / 100 / AddUtil.parseDouble(lend_int_per) );						
					}else{					//12개월나누기	
						int year_days = year_days = AddUtil.parseInt(rs_db.getDay(alt_dt[j-1].substring(0,4)+""+"0101", set_dt.substring(0,4)+""+"1231"));
						if(j==1 && f_day_account.equals("Y")){ //1회차 일자계산 한다는 별도 계산
							str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(debt.getLend_int()) / 100 / year_days * use_days );
						}else if(j==tot_amt_tm && e_day_account.equals("Y")){ //마지막회차 일자계산 한다는 별도 계산
							str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(debt.getLend_int()) / 100 / year_days * use_days );
						}else{
							str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(debt.getLend_int()) /100 / 12 );
						}	
					}
					
					if(lend_int_way2.equals("2")){		//소숫점 반올림
						str_alt_int 	= AddUtil.parseFloatRoundZero   (str_alt_int);
					}else if(lend_int_way2.equals("1")){	//소숫점 절사
						str_alt_int 	= AddUtil.parseFloatTruncZero   (str_alt_int);
					}else if(lend_int_way2.equals("8")){	//소숫점 절상 (20210505)											
						str_alt_int 	= AddUtil.parseFloatTruncTenZero(AddUtil.calcMath("CEIL", str_alt_int, 0));
					}else if(lend_int_way2.equals("7")){	//원단위 절상 (20180918)											
						str_alt_int 	= AddUtil.parseFloatTruncTenZero(AddUtil.calcMath("CEIL", str_alt_int, -1));
					}else if(lend_int_way2.equals("3")){	//원단위 절사
						str_alt_int 	= AddUtil.parseFloatTruncTenZero(str_alt_int);
					}else if(lend_int_way2.equals("4")){	//십원단위 절상											
						str_alt_int 	= AddUtil.parseFloatTruncTenZero(AddUtil.calcMath("CEIL", str_alt_int, -2));
					}else if(lend_int_way2.equals("5")){	//십원단위 절사
						str_alt_int 	= AddUtil.parseFloatTruncZero   (str_alt_int);
					}else if(lend_int_way2.equals("6")){	//십원단위 반올림
						str_alt_int 	= AddUtil.calcMath("ROUND", str_alt_int, -2);
					}					
					
					//절사
					str_alt_int 	= AddUtil.parseFloatTruncZero   (str_alt_int);
					//문자에서 숫자로 변환
					alt_int[j] 	= AddUtil.parseInt(str_alt_int);
					
					if(lend_int_way2.equals("5")){	//십원단위 절사
						alt_int[j] 	= AddUtil.sl_th_rnd(alt_int[j]);
					}
					
					alt_amt[j]  = debt.getAlt_amt() - alt_int[j];

					//1회차 상환액이 다른경우
					if(j==1 && Util.parseDigit(f_case_alt_amt[i]) >0 ){
						alt_amt[j]  = Util.parseDigit(f_case_alt_amt[i]) - alt_int[j];						
					}
					
					alt_rest[j] = alt_rest[j-1] - alt_amt[j];
					
					alt_dt[j]   = set_dt;
					
					if(j==tot_amt_tm){
					 	//alt_int[j] 	= alt_int[j] - alt_rest[j];
						alt_amt[j]	= alt_rest[j-1];
						alt_rest[j] 	= 0;
					}
					
					if(j==1){
						//0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가한다. (20110520)
						String dt_0_mon = c_db.getDtMonth(debt0.getAlt_est_dt());
						String dt_1_mon = c_db.getDtMonth(set_dt);
						
						String dt_2_mon = c_db.getDtMonth(c_db.addMonth(debt0.getAlt_est_dt(), 1));
						
						Hashtable mon_ht = af_db.getUseMonDay(set_dt, debt0.getAlt_est_dt());
						
						int u_mon = AddUtil.parseInt(String.valueOf(mon_ht.get("U_MON")));
						int u_day = AddUtil.parseInt(String.valueOf(mon_ht.get("U_DAY")));
						
						if(u_day > 0){
							u_mon = u_mon+1;
						}
						
						if(AddUtil.parseInt(dt_1_mon)-AddUtil.parseInt(dt_0_mon) >1 || (u_mon> 1 && !dt_1_mon.equals(dt_2_mon))){
							
							tm_add_cnt = AddUtil.parseInt(dt_1_mon)-AddUtil.parseInt(dt_0_mon)-1;
							tm_add_cnt = 1; //메시지발송되나 스케줄생성안되어 확인
							for(int k = 1 ; k <= tm_add_cnt ; k++){
								r_alt_tm = r_alt_tm+1;
								debt0 = d_db.getADebtScd(debt.getCar_mng_id(), String.valueOf(r_alt_tm));
								use_yn = "N";
								if(!debt0.getCar_mng_id().equals("")) use_yn = "Y";								
								debt0.setAlt_tm			(String.valueOf(r_alt_tm));
								debt0.setAlt_est_dt		(c_db.addMonth(debt.getLend_dt(), k));
								debt0.setAlt_prn		(0);
								debt0.setAlt_int		(0);
								debt0.setAlt_rest		(debt.getLend_prn());
								debt0.setPay_yn			("1");
								debt0.setPay_dt			(debt0.getAlt_est_dt());
								debt0.setR_alt_est_dt	(debt0.getAlt_est_dt());
								if(mode.equals("") && !debt.getCar_mng_id().equals("")){
									if(use_yn.equals("N")){
										debt0.setCar_mng_id(debt.getCar_mng_id());
										if(!d_db.insertDebtScd(debt0)) flag2 = 1;
									}else{
										if(!d_db.updateDebtScd(debt0)) flag2 = 1;										
									}
								}
								if(mode.equals("view") || ck_acar_id.equals("000029")){
									out.println("alt_tm=|"+debt0.getAlt_tm()+"|");
									out.println("alt_dt="	+debt0.getAlt_est_dt());
									out.println("alt_amt="	+debt0.getAlt_prn());
									out.println("<font color='red'>alt_int="	+debt0.getAlt_int()+"</font>");
									out.println("alt_rest="	+debt0.getAlt_rest()+"<br>");
								}	
							}
							if(mode.equals("") && i==0){
								System.out.println("<br>0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가<br>");
								System.out.println("<br>dt_0_mon="+dt_0_mon+"<br>");
								System.out.println("<br>dt_1_mon="+dt_1_mon+"<br>");
							}
							if(mode.equals("view") || ck_acar_id.equals("000029")){
								out.println("<br>0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가<br>");
								out.println("<br>dt_0_mon="+dt_0_mon);
								out.println("<br>dt_1_mon="+dt_1_mon+"<br><br>");
							}	
							
							String xml_data = "";
							xml_data =  "<COOLMSG>"+
	  							"<ALERTMSG>"+
			  					"    <BACKIMG>4</BACKIMG>"+
  								"    <MSGTYPE>104</MSGTYPE>"+
  								"    <SUB>개별할부 0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가</SUB>"+
				  				"    <CONT>개별할부 0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가 &lt;br&gt; &lt;br&gt; (car_mng_id="+debt.getCar_mng_id()+")</CONT>"+
  								"    <URL></URL>";
							xml_data += "    <SENDER></SENDER>"+
				  				"    <MSGICON>10</MSGICON>"+
				  				"    <MSGSAVE>1</MSGSAVE>"+
				  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
				  				"    <FLDTYPE>1</FLDTYPE>"+
				  				"  </ALERTMSG>"+
				  				"</COOLMSG>";
				
							CdAlertBean msg = new CdAlertBean();
							msg.setFlddata(xml_data);
							msg.setFldtype("1");
				
							if(mode.equals("")){
								flag7 = cm_db.insertCoolMsg(msg);
							}
							
						}
						
					}
					
					r_alt_tm = r_alt_tm+1;
					
					
					DebtScdBean debt1 = new DebtScdBean();
					debt1 = d_db.getADebtScd(debt.getCar_mng_id(), String.valueOf(r_alt_tm));
					
					use_yn = "N";
					if(!debt1.getCar_mng_id().equals("")) use_yn = "Y";
					
					debt1.setCar_mng_id		(debt.getCar_mng_id());
					debt1.setAlt_tm			(String.valueOf(r_alt_tm));
					debt1.setAlt_prn		(alt_amt[j]);
					debt1.setAlt_int		(alt_int[j]);
					debt1.setAlt_rest		(alt_rest[j]);
					debt1.setAlt_est_dt		(set_dt);
					debt1.setR_alt_est_dt		(af_db.getValidDt(debt1.getAlt_est_dt()));
					
					
					debt1.setPay_yn			("0");	//default값은 0	(미지급)
					debt1.setPay_dt			("");
					if(mode.equals("") && !debt.getCar_mng_id().equals("")){
						if(use_yn.equals("N")){
							if(!d_db.insertDebtScd(debt1)) flag3 = 1;
						}else{
							if(!d_db.updateDebtScd(debt1)) flag3 = 1;
						}
						
						if(j==tot_amt_tm){
							debt.setAlt_end_dt	(set_dt);
							if(!ad_db.updateContDebt(debt))	flag += 1;
						}
					}
					if(mode.equals("view") || ck_acar_id.equals("000029")){
						out.println("alt_tm=|"+debt1.getAlt_tm()+"|");						
						out.println("alt_dt="	+alt_dt[j]);
						out.println("use_days="	+use_days);
						out.println("alt_amt="	+alt_amt[j]);						
						out.println("<font color='red'>alt_int="	+alt_int[j]+"</font>");
						out.println("alt_rest="	+alt_rest[j]+"<br>");
						if(j==12 || j==24 || j==36 || j==48){
							out.println("---------------------------------------------------------------------------------------------------------------------------------------------------------<br>");
						}
					}	
					
				}
				if(mode.equals("view") || ck_acar_id.equals("000029")){
					out.println("===================================================================<br><br>");
				}	
			}
			
			if(loan_st.equals("1")) {
				
				int alt_sum_amt1 = 0;
				int alt_sum_amt2 = 0;
				//스케줄 합산 대출이자,상환총금액,월상환료 반영
				Vector debt_scds = d_db.getDebtScd(debt.getCar_mng_id());
				int debt_scd_size = debt_scds.size();
				for(int l = 0 ; l < debt_scd_size ; l++){
					DebtScdBean a_debt = (DebtScdBean)debt_scds.elementAt(l);
					alt_sum_amt1 = alt_sum_amt1 + a_debt.getAlt_int();
					alt_sum_amt2 = alt_sum_amt2 + a_debt.getAlt_prn()+a_debt.getAlt_int();
				}	
			
				if(mode.equals("view") || ck_acar_id.equals("000029")){
					out.println("alt_sum_amt1="+alt_sum_amt1);						
					out.println("alt_sum_amt1="+alt_sum_amt2);
				}				
				if(debt.getLend_int_amt() > alt_sum_amt1 || debt.getLend_int_amt() < alt_sum_amt1 || debt.getRtn_tot_amt() > alt_sum_amt2 || debt.getRtn_tot_amt() < alt_sum_amt2){
			    	debt.setLend_int_amt(alt_sum_amt1);//대출이자
		    		debt.setRtn_tot_amt	(alt_sum_amt2);//상환총금액
					if(mode.equals("")){
						if(!ad_db.updateContDebt(debt))	flag += 1;
					}
					if(mode.equals("view") || ck_acar_id.equals("000029")){
						out.println("대출이자총액과 상환총금액 update<br>");						
					}	
				}	
			}
			
		}
	}
	
	
	//묶음 할부
	if ( loan_st.equals("2")) {
		
		if(mode.equals("")){
			count = FineDocDb.updateFineDocScd_yn(doc_id);    //대출금 상환스케쥴 등록 = Y
		}
		
		BankLendBean bl = abl_db.getBankLend(lend_id);
		
		String deposit_no 	= request.getParameter("deposit_no")==null?"":request.getParameter("deposit_no");
		int tot_alt_amt 	= request.getParameter("tot_alt_amt").equals("")?0:Util.parseDigit(request.getParameter("tot_alt_amt"));
		
		if(!deposit_no.equals("")){
			//자동전표
			bl.setAutodoc_yn("Y");
			bl.setBank_code			(request.getParameter("bank_code2")==null?"":request.getParameter("bank_code2"));
			bl.setDeposit_no_d		(request.getParameter("deposit_no")==null?"":request.getParameter("deposit_no"));
			bl.setAcct_code			(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));
			bl.setCls_rtn_fee_int	(request.getParameter("cls_rtn_fee_int")==null?"":request.getParameter("cls_rtn_fee_int"));
			bl.setCls_rtn_etc		(request.getParameter("cls_rtn_etc")==null?"":request.getParameter("cls_rtn_etc"));
			bl.setFst_pay_dt		(request.getParameter("fst_pay_dt")==null?"":request.getParameter("fst_pay_dt"));
			bl.setFst_pay_amt		(request.getParameter("tot_alt_amt")==null?0:Util.parseDigit(request.getParameter("tot_alt_amt")));
			
			if(mode.equals("")){
				flag1 = abl_db.updateBankLend(bl);
				
				if(!fund_id.equals("")){
					flag1 = abl_db.updateBankLendFundId(bl, fund_id);
				}
						
				boolean br_flag = abl_db.updateBankRtnVencode(lend_id, "", ven_code);
			}	
						
		}
		
		
		if(!lend_scd_reg_yn.equals("N") && !bl.getLend_id().equals("")){

			//건별 할부스케줄 생성
			if ( loan_st.equals("2")) {
				
				int r_alt_tm = 0;
				
				if(mode.equals("view") || ck_acar_id.equals("000029")){
					out.println("lend_id=|"+lend_id+"|");						
					out.println("rtn_seq="	+rtn_seq);
					out.println("mode="	+mode);
					out.println("f_prn_amt="	+f_prn_amt);					
				}	
				
				//0회차 생성
				BankScdBean debt0 = abl_db.getBankScd("scd_bank", lend_id, rtn_seq, "0");
				
				String use_yn = "Y";
				if(debt0 == null || debt0.getLend_id().equals("")){				
					use_yn = "N";
					debt0 = new BankScdBean();
				}
				
				debt0.setLend_id		(lend_id);				
				debt0.setRtn_seq		(rtn_seq);
				debt0.setAlt_tm			("0");
				debt0.setAlt_est_dt		(request.getParameter("lend_dt"));
				debt0.setAlt_prn_amt	(0);
				debt0.setAlt_int_amt	(0);
				debt0.setPay_dt			(request.getParameter("lend_dt"));
				debt0.setPay_yn			("1");
				debt0.setAlt_rest		(request.getParameter("tot_lend_prn").equals("")?0:Util.parseDigitLong(request.getParameter("tot_lend_prn")));
				debt0.setR_alt_est_dt	(request.getParameter("lend_dt"));
				
				if(mode.equals("") && !lend_id.equals("")){
					if(use_yn.equals("N")){
						if(!abl_db.insertBankScd(debt0))	flag2 = 1;						
					}else{
						if(!abl_db.updateBankScd("scd_bank", debt0))	flag2 = 1;												
					}
				}
								
				int tot_amt_tm 	= request.getParameter("all_alt_tm").equals("")?0:Integer.parseInt(request.getParameter("all_alt_tm"));
				
				if(mode.equals("view") || ck_acar_id.equals("000029")){
					out.println("<br>--할부금상환스케줄생성--<br>");
					out.println("* tot_amt_tm = "+tot_amt_tm+"<br>");
				}		
								
			   	int alt_amt[]	 = new int[tot_amt_tm+1];
				long alt_rest[]	 = new long[tot_amt_tm+1];
				int alt_int[]	 = new int[tot_amt_tm+1];
				String alt_dt[]	 = new String[tot_amt_tm+1];
				
				alt_amt[0]		= debt0.getAlt_prn_amt();
				alt_int[0] 		= debt0.getAlt_int_amt();
				alt_rest[0] 	= debt0.getAlt_rest();
				alt_dt[0]   	= debt0.getAlt_est_dt();
								
				int tm_add_cnt = 0;
				
				if(mode.equals("view") || ck_acar_id.equals("000029")){
					out.println("alt_amt[0]="+alt_amt[0]);
					out.println("alt_int[0]="+alt_int[0]);
					out.println("alt_rest[0]="+alt_rest[0]);
					out.println("alt_dt[0]="+alt_dt[0]+"<br>");
				}	
				
				for(int j = 1 ; j < tot_amt_tm+1 ; j++){
					
					
					String set_dt = c_db.addMonth(fst_pay_dt, j-1);//1회차납입일+1개월씩 증가
					
					if(!rtn_est_dt.equals("99")){
						if(!set_dt.substring(5,10).equals("02-28") && !set_dt.substring(5,10).equals("02-29")){
							set_dt=set_dt.substring(0,8)+AddUtil.addZero(rtn_est_dt);
						}
					}
					
					if(j==1){
						set_dt = fst_pay_dt;
					}
					if(j==tot_amt_tm && e_day_account.equals("Y")){ //마지막회차 일자계산 한다는 별도 계산
						String set_dt2 = c_db.addMonth(request.getParameter("lend_dt"), (tot_amt_tm-1));
						if(AddUtil.parseInt(alt_dt[j-1])<AddUtil.parseInt(set_dt2)){
							set_dt = set_dt2;
						}
					}
					
					use_days = AddUtil.parseInt(rs_db.getDay(alt_dt[j-1], set_dt))-1;
					

					String str_alt_int = "";
					
					if(mode.equals("view") || ck_acar_id.equals("000029")){
						out.println("st_dt="	+alt_dt[j-1]);
						out.println("ed_dt="	+set_dt);
					}	
					
					if(lend_int_way.equals("2")){				//실이용일적용(365)
						//str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) / 100 / 365 * use_days );
						str_alt_int = c_db.getIntAmt(String.valueOf(alt_rest[j-1]), String.valueOf(lend_int), "365", String.valueOf(use_days) );
					}else if(lend_int_way.equals("4")){	//실이용일적용(실제일수)
						int year_days = year_days = AddUtil.parseInt(rs_db.getDay(alt_dt[j-1].substring(0,4)+""+"0101", set_dt.substring(0,4)+""+"1231"));
						//str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) / 100 / year_days * use_days );
						str_alt_int = c_db.getIntAmt(String.valueOf(alt_rest[j-1]), String.valueOf(lend_int), String.valueOf(year_days), String.valueOf(use_days) );
						if(!alt_dt[j-1].substring(0,4).equals(set_dt.substring(0,4))){
							//년도1
							int use_days_1  			= AddUtil.parseInt(rs_db.getDay(alt_dt[j-1], alt_dt[j-1].substring(0,4)+""+"1231"));
							if(int_day_account.equals("2")){//시작일미포함
								use_days_1 = use_days_1-1;
							}
							int year_days_1 			= year_days = AddUtil.parseInt(rs_db.getDay(alt_dt[j-1].substring(0,4)+""+"0101", alt_dt[j-1].substring(0,4)+""+"1231"));
							//String str_alt_int_1 	= String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) / 100 / year_days_1 * use_days_1 );
							String str_alt_int_1 	= c_db.getIntAmt(String.valueOf(alt_rest[j-1]), String.valueOf(lend_int), String.valueOf(year_days_1), String.valueOf(use_days_1) );
							//년도2
							int use_days_2 				= AddUtil.parseInt(rs_db.getDay(set_dt.substring(0,4)+""+"0101", set_dt)); //둘다 -1이면 안된다.
							if(int_day_account.equals("1")){//시작일포함
								use_days_2 = use_days_2-1;
							}
							int year_days_2 			= year_days = AddUtil.parseInt(rs_db.getDay(set_dt.substring(0,4)+""+"0101", set_dt.substring(0,4)+""+"1231"));
							//String str_alt_int_2 	= String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) / 100 / year_days_2 * use_days_2 );							
							String str_alt_int_2 	= c_db.getIntAmt(String.valueOf(alt_rest[j-1]), String.valueOf(lend_int), String.valueOf(year_days_2), String.valueOf(use_days_2) );
							if(year_days_1>year_days_2 || year_days_1<year_days_2){
								str_alt_int = String.valueOf(AddUtil.parseDouble(str_alt_int_1)+AddUtil.parseDouble(str_alt_int_2));
								if(mode.equals("view") || ck_acar_id.equals("000029")){
									out.println("연도가 다름, year_days="+year_days);									
									out.println("year_days_1="+year_days_1);
									out.println("year_days_2="+year_days_2);
									out.println("use_days="+use_days);
									out.println("use_days_1="+use_days_1);
									out.println("use_days_2="+use_days_2);
									out.println("str_alt_int="+str_alt_int);
									out.println("str_alt_int_1="+str_alt_int_1);
									out.println("str_alt_int_2="+str_alt_int_2);																		
								}
							}else{
								//str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) / 100 / year_days * use_days );
								str_alt_int = c_db.getIntAmt(String.valueOf(alt_rest[j-1]), String.valueOf(lend_int), String.valueOf(year_days), String.valueOf(use_days) );
							}
						}else{
							if(mode.equals("view") || ck_acar_id.equals("000029")){
								out.println("연도가 같음, year_days="+year_days);
							}							
						}							
					}else if(lend_int_way.equals("3")){	//별도입력값					
						//str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) / 100 / AddUtil.parseDouble(lend_int_per) );
						str_alt_int = c_db.getIntAmt(String.valueOf(alt_rest[j-1]), String.valueOf(lend_int), lend_int_per, "" );
					}else{					//12개월나누기	
						int year_days = year_days = AddUtil.parseInt(rs_db.getDay(alt_dt[j-1].substring(0,4)+""+"0101", set_dt.substring(0,4)+""+"1231"));
						if(j==1 && f_day_account.equals("Y")){ //1회차 일자계산 한다는 별도 계산
							//str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) / 100 / year_days * use_days );
							str_alt_int = c_db.getIntAmt(String.valueOf(alt_rest[j-1]), String.valueOf(lend_int), String.valueOf(year_days), String.valueOf(use_days) );
						}else if(j==tot_amt_tm && e_day_account.equals("Y")){ //마지막회차 일자계산 한다는 별도 계산
							//str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) / 100 / year_days * use_days );
							str_alt_int = c_db.getIntAmt(String.valueOf(alt_rest[j-1]), String.valueOf(lend_int), String.valueOf(year_days), String.valueOf(use_days) );
						}else{
							//str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) /100 / 12 );
							str_alt_int = c_db.getIntAmt(String.valueOf(alt_rest[j-1]), String.valueOf(lend_int), "12", "" );
						}	
					}
					
					//if(AddUtil.parseFloatTruncZero   (str_alt_int).equals("1")){
					//	out.println("Double 범위를 넘습니다. 은행대출관리에서 스케줄 등록하십시오. ");
					//}
					
					
					if(lend_int_way2.equals("2")){		//소숫점 반올림
						str_alt_int 	= AddUtil.parseFloatRoundZero   (str_alt_int);
					}else if(lend_int_way2.equals("1")){	//소숫점 절사
						str_alt_int 	= AddUtil.parseFloatTruncZero   (str_alt_int);
					}else if(lend_int_way2.equals("8")){	//소숫점 절상 (20210505)									
						str_alt_int 	= AddUtil.parseFloatTruncTenZero(AddUtil.calcMath("CEIL", str_alt_int, 0));
					}else if(lend_int_way2.equals("7")){	//원단위 절상 (20180918)											
						str_alt_int 	= AddUtil.parseFloatTruncTenZero(AddUtil.calcMath("CEIL", str_alt_int, -1));
					}else if(lend_int_way2.equals("3")){	//원단위 절사
						str_alt_int 	= AddUtil.parseFloatTruncTenZero(str_alt_int);
					}else if(lend_int_way2.equals("4")){	//십원단위 절상											
						str_alt_int 	= AddUtil.parseFloatTruncTenZero(AddUtil.calcMath("CEIL", str_alt_int, -2));
					}else if(lend_int_way2.equals("5")){	//십원단위 절사
						str_alt_int 	= AddUtil.parseFloatTruncZero   (str_alt_int);
					}else if(lend_int_way2.equals("6")){	//십원단위 반올림
						str_alt_int 	= AddUtil.calcMath("ROUND", str_alt_int, -2);
					}					
					
					//절사
					str_alt_int 	= AddUtil.parseFloatTruncZero   (str_alt_int);
					//문자에서 숫자로 변환
					alt_int[j] 	= AddUtil.parseInt(str_alt_int);
					
					if(lend_int_way2.equals("5")){	//십원단위 절사
						alt_int[j] 	= AddUtil.sl_th_rnd(alt_int[j]);
					}
					
					alt_amt[j]  = tot_alt_amt - alt_int[j];
					
					//1회차 월상환금액 별도 금액이 있는 경우
					if(j==1 && f_prn_amt>0){
						alt_amt[j]  = f_prn_amt - alt_int[j];
					}
					
					alt_rest[j] = alt_rest[j-1] - (long)alt_amt[j];
					
					alt_dt[j]   = set_dt;
					
					if(j==tot_amt_tm){					 
						alt_amt[j]	= (int)alt_rest[j-1];
						alt_rest[j] 	= 0;
					}					
					
					if(j==1){
						//0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가한다. (20110520)
						String dt_0_mon = c_db.getDtMonth(debt0.getAlt_est_dt());
						String dt_1_mon = c_db.getDtMonth(set_dt);
						
						String dt_2_mon = c_db.getDtMonth(c_db.addMonth(debt0.getAlt_est_dt(), 1));
						
						Hashtable mon_ht = af_db.getUseMonDay(set_dt, debt0.getAlt_est_dt());
						
						int u_mon = AddUtil.parseInt(String.valueOf(mon_ht.get("U_MON")));
						int u_day = AddUtil.parseInt(String.valueOf(mon_ht.get("U_DAY")));
						
						if(u_day > 0){
							u_mon = u_mon+1;
						}
						
						if(AddUtil.parseInt(dt_1_mon)-AddUtil.parseInt(dt_0_mon) >1 || (u_mon> 1 && !dt_1_mon.equals(dt_2_mon))){
							tm_add_cnt = AddUtil.parseInt(dt_1_mon)-AddUtil.parseInt(dt_0_mon)-1;
							tm_add_cnt = 1; //메시지발송되나 스케줄생성안되어 확인
							
							

							for(int k = 1 ; k <= tm_add_cnt ; k++){
								r_alt_tm = r_alt_tm+1;
								//추가회차 생성
								BankScdBean debt3 = abl_db.getBankScd("scd_bank", lend_id, rtn_seq, String.valueOf(r_alt_tm));
								use_yn = "Y";
								if(debt3 == null || debt3.getLend_id().equals("")){				
									use_yn = "N";
									debt3 = new BankScdBean();
								}								
								debt3.setLend_id		(debt0.getLend_id());
								debt3.setRtn_seq		(debt0.getRtn_seq());
								debt3.setAlt_tm			(String.valueOf(r_alt_tm));
								debt3.setAlt_est_dt		(c_db.addMonth(debt0.getAlt_est_dt(), k));
								debt3.setAlt_prn_amt	(0);
								debt3.setAlt_int_amt	(0);
								debt3.setPay_dt			(debt0.getAlt_est_dt());
								debt3.setPay_yn			("1");
								debt3.setAlt_rest		(request.getParameter("tot_lend_prn").equals("")?0:Util.parseDigitLong(request.getParameter("tot_lend_prn")));
								debt3.setR_alt_est_dt	(debt3.getAlt_est_dt());								
								if(mode.equals("") && !lend_id.equals("")){
									if(use_yn.equals("N")){
										if(!abl_db.insertBankScd(debt3))	flag2 = 1;						
									}else{
										if(!abl_db.updateBankScd("scd_bank", debt3))	flag2 = 1;												
									}
								}
																
								if(mode.equals("view") || ck_acar_id.equals("000029")){
									out.println("alt_tm=|"+debt0.getAlt_tm()+"|");
									out.println("alt_dt="	+debt0.getAlt_est_dt());
									out.println("alt_amt="	+debt0.getAlt_prn_amt());
									out.println("<font color='red'>alt_int="	+debt0.getAlt_int_amt()+"</font>");
									out.println("alt_rest="	+debt0.getAlt_rest()+"<br>");
								}	
								
								if(mode.equals("")){
									System.out.println("<br>0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가<br>");
									System.out.println("<br>dt_0_mon="+dt_0_mon+"<br>");
									System.out.println("<br>dt_1_mon="+dt_1_mon+"<br>");
								}
								if(mode.equals("view") || ck_acar_id.equals("000029")){
									out.println("<br>0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가<br>");
									out.println("<br>dt_0_mon="+dt_0_mon);
									out.println("<br>dt_1_mon="+dt_1_mon+"<br><br>");
								}	
								
								String xml_data = "";
								xml_data =  "<COOLMSG>"+
		  							"<ALERTMSG>"+
				  					"    <BACKIMG>4</BACKIMG>"+
	  								"    <MSGTYPE>104</MSGTYPE>"+
	  								"    <SUB>묶음할부 0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가</SUB>"+
					  				"    <CONT>묶음할부 0회차와 1회차 납일일이 한달이상 차이날때 중간회차 추가 &lt;br&gt; &lt;br&gt; (lend_id="+lend_id+")</CONT>"+
	  								"    <URL></URL>";
								xml_data += "    <SENDER></SENDER>"+
					  				"    <MSGICON>10</MSGICON>"+
					  				"    <MSGSAVE>1</MSGSAVE>"+
					  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
					  				"    <FLDTYPE>1</FLDTYPE>"+
					  				"  </ALERTMSG>"+
					  				"</COOLMSG>";
					
								CdAlertBean msg = new CdAlertBean();
								msg.setFlddata(xml_data);
								msg.setFldtype("1");
					
								if(mode.equals("")){
									flag7 = cm_db.insertCoolMsg(msg);
								}
																
							}						
						}	
					}						
						
						
						r_alt_tm = r_alt_tm+1;
						
						
						BankScdBean debt1 = abl_db.getBankScd("scd_bank", lend_id, rtn_seq, String.valueOf(r_alt_tm));
						
						use_yn = "Y";
						if(debt1 == null || debt1.getLend_id().equals("")){				
							use_yn = "N";
							debt1 = new BankScdBean();
						}
						
						debt1.setLend_id		(lend_id);				
						debt1.setRtn_seq		(rtn_seq);
						debt1.setAlt_tm			(String.valueOf(r_alt_tm));
						debt1.setAlt_est_dt		(set_dt);
						debt1.setAlt_prn_amt	(alt_amt[j]);
						debt1.setAlt_int_amt	(alt_int[j]);
						debt1.setPay_dt			("");
						debt1.setPay_yn			("0");
						debt1.setAlt_rest		(alt_rest[j]);
						debt1.setR_alt_est_dt	(af_db.getValidDt(debt1.getAlt_est_dt()));
						
						if(mode.equals("") && !lend_id.equals("")){
							if(use_yn.equals("N")){
								if(!abl_db.insertBankScd(debt1))	flag2 = 1;						
							}else{
								if(!abl_db.updateBankScd("scd_bank", debt1))	flag2 = 1;												
							}
						}
												
						if(mode.equals("view") || ck_acar_id.equals("000029")){
							out.println("alt_tm=|"+debt1.getAlt_tm()+"|");						
							out.println("alt_dt="	+alt_dt[j]);
							out.println("use_days="	+use_days);
							out.println("alt_amt="	+alt_amt[j]);						
							out.println("<font color='red'>alt_int="	+alt_int[j]+"</font>");
							out.println("alt_rest="	+alt_rest[j]);
							if(j==12 || j==24 || j==36 || j==48){
								out.println("<br>---------------------------------------------------------------------------------------------------------------------------------------------------------");
							}
						}	

						
					
					if(mode.equals("view") || ck_acar_id.equals("000029")){
						out.println("<br>");						
					}	
					
				}

			}		
		}else{		
			
			if(!lend_scd_reg_yn.equals("N")){
				out.println("은행대출관리에 선 등록하고 처리하십시오.");	
				out_text = "은행대출관리에 선 등록하고 처리하십시오.";
			}	

		}
		
		
		
	}
	
	
	if(mode.equals("")){
	
		code_bean = c_db.getCodeBean("0003", cpt_cd, "");
		if(!code_bean.getVar1().equals(lend_alt_way) || !code_bean.getVar2().equals(lend_int_way) || !code_bean.getVar3().equals(lend_int_way2) || !code_bean.getVar4().equals(f_day_account) || !code_bean.getVar5().equals(e_day_account) || !code_bean.getVar6().equals(int_day_account)){
			code_bean.setVar1(lend_alt_way);
			code_bean.setVar2(lend_int_way);
			code_bean.setVar3(lend_int_way2);
			code_bean.setVar4(f_day_account);
			code_bean.setVar5(e_day_account);
			code_bean.setVar6(int_day_account);
			count = c_db.updateCode(code_bean);
		}
		ce_bean =  c_db.getCodeEtc("0003", cpt_cd);
		if(!ce_bean.getVen_code().equals(ven_code)){
			ce_bean.setVen_code(ven_code);
			count = c_db.insupdCodeEtc(ce_bean);  
		}
	}else{	
		if(1==1)return;
	}	
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">

</form>
<script language='javascript'>
<!--
<%	if(flag != 0){%>
		alert('에러입니다.\n\n할부금이 등록되지 않았습니다');
		location='about:blank';

<%	}else{%>		
		<%if(out_text.equals("")){%>
		alert('등록되었습니다');
		<%}else{%>
		alert('<%=out_text%>');
		<%}%>
//		document.form1.target='d_content';
//		document.form1.action='/acar/con_debt/debt_scd_frame_s.jsp';
//		document.form1.submit();
<%	}%>
-->
</script>
</body>
</html>
