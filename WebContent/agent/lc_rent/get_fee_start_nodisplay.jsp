<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.cont.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/agent/cookies.jsp" %>



<%
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	
	String rent_start_dt		=  request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt		=  request.getParameter("rent_end_dt")==null?"":request.getParameter("rent_end_dt");	
	
	int t_con_mon 			=  request.getParameter("con_mon")==null?0:AddUtil.parseInt(request.getParameter("con_mon"));	
	int fee_pay_tm 			=  request.getParameter("fee_pay_tm")==null?0:AddUtil.parseInt(request.getParameter("fee_pay_tm"));
	int pere_r_mth 			=  request.getParameter("pere_r_mth")==null?0:AddUtil.parseInt(request.getParameter("pere_r_mth"));
	
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	String base_dt = rent_start_dt;
	
	if(!fee.getRent_start_dt().equals("")){
		base_dt = fee.getRent_start_dt();
	}	
	
	
	if(pere_r_mth>0)		fee_pay_tm = t_con_mon - pere_r_mth;
	else 				fee_pay_tm = t_con_mon;
	
	
	
	//신차개시 및 스케줄생성 처리
	String from_page	  	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String reg_type	  		= request.getParameter("reg_type")==null?"":request.getParameter("reg_type");
	String fee_est_day1  		= request.getParameter("fee_est_day1")==null?"":request.getParameter("fee_est_day1");
	String fee_est_day2  		= request.getParameter("fee_est_day2")==null?"":request.getParameter("fee_est_day2");
	String fee_est_day3  		= request.getParameter("fee_est_day3")==null?"":request.getParameter("fee_est_day3");
	String fee_fst_dt3  		= request.getParameter("fee_fst_dt3")==null?"":request.getParameter("fee_fst_dt3");
	int    fee_amt 			= request.getParameter("fee_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_amt"));
	int    fee_s_amt 		= request.getParameter("fee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int    fee_v_amt 		= request.getParameter("fee_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_v_amt"));
	
	String fee_est_day		= "";
	String fee_est_dt		= "";
	String fee_est_dt2		= "";
	
	//동일 혹은 변경전
	//1회차 시작일
	String f_use_s_dt		= "";
	//1회차 실종료일
	String f_use_e_dt		= "";
	//마지막회차 시작일
	String l_use_s_dt		= "";
	//마지막회차 실종료일
	String l_use_e_dt		= "";	
	
	int f_fee_amt		= 0;	
	int l_fee_amt		= 0;	

	//변경후		
	//1회차 시작일
	String f_use_s_dt2		= "";
	//1회차 실종료일
	String f_use_e_dt2		= "";
	//마지막회차 시작일
	String l_use_s_dt2		= "";
	//마지막회차 실종료일
	String l_use_e_dt2		= "";	
	
	//일자계산내역
	String f_etc		= "";
	String l_etc		= "";
	
	
	
	if(pere_r_mth>0){
		//20170421 기준변경 (예)대여기간 2017-04-18 ~ 2020-04-18
		if(AddUtil.parseInt(AddUtil.replace(base_dt,"-","")) < 20170421){
			rent_end_dt = c_db.minusDay(c_db.addMonth(rent_start_dt, fee_pay_tm), 1);
		}else{
			rent_end_dt = c_db.addMonth(rent_start_dt, fee_pay_tm);
		}
	}
	
	
	String use_s_dt[]	 = new String[fee_pay_tm+1];
	String use_e_dt[]	 = new String[fee_pay_tm+1];
	int    scd_fee_amt[]	 = new int[fee_pay_tm+1];
	int    scd_fee_s_amt[]	 = new int[fee_pay_tm+1];
	int    scd_fee_v_amt[]	 = new int[fee_pay_tm+1];
	
	
	int f_fee_amt2		= 0;	
	int l_fee_amt2		= 0;	


	//System.out.println("* 대여개시등록 예비스케줄 계산 : "+rent_l_cd);


	if(from_page.equals("/agent/lc_rent/lc_c_u_start.jsp")){
	
		if(reg_type.equals("1") || reg_type.equals("2")){
		
			//20170421 기준변경 (예)대여기간 2017-04-18 ~ 2020-04-18
			if(AddUtil.parseInt(AddUtil.replace(base_dt,"-","")) < 20170421){
				fee_est_dt 	= c_db.minusDay(c_db.addMonth(rent_start_dt, 1), 1);
			}else{
				fee_est_dt 	= c_db.addMonth(rent_start_dt, 1);
			}
			f_use_s_dt	= rent_start_dt;
			f_use_e_dt	= fee_est_dt;
			l_use_s_dt	= c_db.minusDay(c_db.addMonth(rent_end_dt, -1), -1);
			l_use_e_dt	= rent_end_dt;
			f_fee_amt	= fee_amt;
			l_fee_amt	= fee_amt;
			
			//말일자여부
			int chk_dt = AddUtil.getMonthDate(AddUtil.parseInt(f_use_e_dt.substring(0,4)),AddUtil.parseInt(f_use_e_dt.substring(5,7))); 
			
			//말일자
			if(f_use_e_dt.equals(f_use_e_dt.substring(0,8)+String.valueOf(chk_dt))){
				fee_est_day = "99";
			}else{
				fee_est_day = f_use_e_dt.substring(8,10);
			}
			
		}
		
		if(reg_type.equals("2") && !fee_est_day3.equals("")){
			
			//선택한 납일일자 갖고 처리하기
			
			if(fee_est_day3.equals("31")){
				fee_est_day3 = "99";
			}
			
			//대여개시후전일 - 변경전과 같다.			
			if(fee_est_day3.equals("98")){

				fee_est_dt2	= fee_est_dt;
				f_use_s_dt2	= f_use_s_dt;
				f_use_e_dt2	= f_use_e_dt;
				l_use_s_dt2	= l_use_s_dt;
				l_use_e_dt2	= l_use_e_dt;
				f_fee_amt2	= f_fee_amt;
				l_fee_amt2	= l_fee_amt;
				
			//말일자
			}else if(fee_est_day3.equals("99")){
			
				f_use_s_dt2	= f_use_s_dt;
			
				fee_est_dt2	= f_use_s_dt2.substring(0,7)+"-"+AddUtil.getMonthDate(AddUtil.parseInt(f_use_s_dt2.substring(0,4)),AddUtil.parseInt(f_use_s_dt2.substring(5,7)));

				out.println("시작일자="+f_use_s_dt2);
				out.println("시작월말일자="+fee_est_dt2);
				
				//일수
				int use_days = AddUtil.parseInt(rs_db.getDay(f_use_s_dt2, fee_est_dt2));
				if(AddUtil.parseInt(AddUtil.replace(base_dt,"-","")) >= 20170421){
					  use_days = AddUtil.parseInt(rs_db.getDay2(f_use_s_dt2, fee_est_dt2));
				}
				
				//7일미만이면 익월말일
				if(use_days < 7){
					fee_est_dt2	= c_db.addMonth(fee_est_dt2, 1);
					
					out.println("1회차사용일수="+use_days);
					out.println("시작익월말일자="+fee_est_dt2);
					
				}
				
				f_use_e_dt2 	= fee_est_dt2;
				l_use_e_dt2	= l_use_e_dt;
				
			//매월30일	
			}else if(fee_est_day3.equals("30")){
			
				f_use_s_dt2	= f_use_s_dt;
				
				fee_est_dt2 = f_use_s_dt2.substring(0,7)+"-"+AddUtil.addZero(fee_est_day3); 
				
				if(fee_est_dt2.substring(5,7).equals("02")){
					int i_max_dd2 	= AddUtil.getMonthDate(AddUtil.parseInt(fee_est_dt2.substring(0,4)), AddUtil.parseInt(fee_est_dt2.substring(5,7)));
					fee_est_dt2 = f_use_s_dt2.substring(0,7)+"-"+AddUtil.addZero2(i_max_dd2); 
				}
				
				out.println("매월결제일자="+fee_est_day3);
				out.println("시작일자="+f_use_s_dt2);
				out.println("시작월말일자="+fee_est_dt2);

				//일수
				int use_days = AddUtil.parseInt(rs_db.getDay(f_use_s_dt2, fee_est_dt2));
				if(AddUtil.parseInt(AddUtil.replace(base_dt,"-","")) >= 20170421){
					  use_days = AddUtil.parseInt(rs_db.getDay2(f_use_s_dt2, fee_est_dt2));
				}
				
				if(use_days ==0 || use_days < 0){
					//익월
					fee_est_dt2	= c_db.addMonth(fee_est_dt2, 1);
					
					String s_cng_dt = AddUtil.replace(fee_est_dt2,"-",""); 
					int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
					int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
					int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
					int i_tax_dd 	= AddUtil.parseInt(fee_est_day3);
					int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
								
					//31일-> 30일
					if(i_tax_dd < i_cng_dd ){
						fee_est_dt2 = fee_est_dt2.substring(0,7)+"-"+AddUtil.addZero2(i_tax_dd);
					}
					//28,29일
					if(i_tax_dd > i_cng_dd ){
						fee_est_dt2 = fee_est_dt2.substring(0,7)+"-"+AddUtil.addZero2(i_max_dd);
					}
											
					out.println("일할계산");
					out.println("1회차사용일수="+use_days);
					out.println("시작익월말일자="+fee_est_dt2);

				}
				
				//7일미만이면 익월말일
				if(use_days>0 && use_days < 7){
					fee_est_dt2	= c_db.addMonth(fee_est_dt2, 1);
					
					String s_cng_dt = AddUtil.replace(fee_est_dt2,"-",""); 
					int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
					int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
					int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
					int i_tax_dd 	= AddUtil.parseInt(fee_est_day3);
					int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
								
					//31일-> 30일
					if(i_tax_dd < i_cng_dd ){
						fee_est_dt2 = fee_est_dt2.substring(0,7)+"-"+AddUtil.addZero2(i_tax_dd);
					}
					//28,29일
					if(i_tax_dd > i_cng_dd ){
						fee_est_dt2 = fee_est_dt2.substring(0,7)+"-"+AddUtil.addZero2(i_max_dd);
					}
					
					out.println("7일미만이면 익월말일");
					out.println("1회차사용일수="+use_days);
					out.println("시작익월말일자="+fee_est_dt2);
					
				}				
				
				f_use_e_dt2 	= fee_est_dt2;
				l_use_e_dt2	= l_use_e_dt;
				
				//if(1==1)return;
				
			}else{
			
				f_use_s_dt2	= f_use_s_dt;
				
				fee_est_dt2 = f_use_s_dt2.substring(0,7)+"-"+AddUtil.addZero(fee_est_day3); 				
				
				out.println("매월결제일자="+fee_est_day3);
				out.println("시작일자="+f_use_s_dt2);
				out.println("시작월말일자="+fee_est_dt2);

				//일수
				int use_days = AddUtil.parseInt(rs_db.getDay(f_use_s_dt2, fee_est_dt2));
				if(AddUtil.parseInt(AddUtil.replace(base_dt,"-","")) >= 20170421){
					  use_days = AddUtil.parseInt(rs_db.getDay2(f_use_s_dt2, fee_est_dt2));
				}
				
				if(use_days ==0 || use_days < 0){
					//익월
					fee_est_dt2	= c_db.addMonth(fee_est_dt2, 1);

					out.println("1회차사용일수="+use_days);
					out.println("시작익월말일자="+fee_est_dt2);

				}
				
				//7일미만이면 익월말일
				if(use_days>0 && use_days < 7){
					fee_est_dt2	= c_db.addMonth(fee_est_dt2, 1);
					
					out.println("1회차사용일수="+use_days);
					out.println("시작익월말일자="+fee_est_dt2);
					
				}				
				
				f_use_e_dt2 	= fee_est_dt2;
				l_use_e_dt2	= l_use_e_dt;
			}
			
			
			
			if(!fee_fst_dt3.equals("")){
			
				f_use_e_dt2 = fee_fst_dt3;
				
				//일수
				int use_days = AddUtil.parseInt(rs_db.getDay(f_use_s_dt2, f_use_e_dt2));
				if(AddUtil.parseInt(AddUtil.replace(base_dt,"-","")) >= 20170421){
					  use_days = AddUtil.parseInt(rs_db.getDay2(f_use_s_dt2, f_use_e_dt2));
				}
				
				//7일미만이면 익월로
				if(use_days>0 && use_days < 7){
					f_use_e_dt2	= c_db.addMonth(f_use_e_dt2, 1);
					
					out.println("1회차사용일수="+use_days);
					out.println("시작익월말일자="+f_use_e_dt2);
					
				}				
				
			}

			out.println("1회차시작일="+f_use_s_dt2);
			out.println("1회차종료일="+f_use_e_dt2);
			
			out.println("<br><br>");
			
			//if(!f_use_e_dt.equals(f_use_e_dt2)){
			
				int count1 = 0;	
				String r_use_end_dt = "";
				
				int u_mon = 0;
				int u_day = 0;
				
				
				out.println("총회차="+fee_pay_tm+"<br>");

				//스케줄합계					
				int r_t_fee_s_amt		= 0;
				int r_t_fee_v_amt		= 0;

				//총대여료
				int t_fee_amt			= (fee_s_amt+fee_v_amt) * fee_pay_tm;
				int t_fee_s_amt			= fee_s_amt * fee_pay_tm;
				int t_fee_v_amt			= t_fee_amt - t_fee_s_amt;
				
				
			
				for(int i = 0 ; i < fee_pay_tm ; i++){
					//1회차---------------------------------------------------------------------------------------------
					if(i == 0){
						use_s_dt[0] = f_use_s_dt2;
						use_e_dt[0] = f_use_e_dt2;																	
					//2회차부터----------------------------------------------------------------------------------------
					}else{
						//2회차 기간시작일은 전회차 다음날로 한다.
						use_s_dt[i] = c_db.addDay(r_use_end_dt, 1);				
						use_e_dt[i] = c_db.addMonth(f_use_e_dt2, count1);
						
						if(reg_type.equals("2") && fee_est_day3.equals("30")){
							String s_cng_dt = AddUtil.replace(use_e_dt[i],"-",""); 
							int i_cng_yy 	= AddUtil.parseInt(s_cng_dt.substring(0,4));
							int i_cng_mm 	= AddUtil.parseInt(s_cng_dt.substring(4,6));
							int i_cng_dd 	= AddUtil.parseInt(s_cng_dt.substring(6,8));
							int i_tax_dd 	= AddUtil.parseInt(fee_est_day3);
							int i_max_dd 	= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
									
							//31일-> 30일
							if(i_tax_dd < i_cng_dd ){
								fee_est_dt2 = use_e_dt[i].substring(0,7)+"-"+AddUtil.addZero2(i_tax_dd);
							}
							//28,29일
							if(i_tax_dd > i_cng_dd ){
								fee_est_dt2 = use_e_dt[i].substring(0,7)+"-"+AddUtil.addZero2(i_max_dd);
							}
						}	
						
						//마지막회차이면
						if(i == (fee_pay_tm-1)){
							use_e_dt[i] = rent_end_dt;
						}					
					}
					
					//일자계산
					Hashtable ht = af_db.getUseMonDay(use_e_dt[i], use_s_dt[i]);
					if(i==0 && AddUtil.parseInt(AddUtil.replace(base_dt,"-","")) >= 20170421){
						        ht = af_db.getUseMonDay2(use_e_dt[i], use_s_dt[i]);
					}
					
					
					u_mon = AddUtil.parseInt(String.valueOf(ht.get("U_MON")));
					u_day = AddUtil.parseInt(String.valueOf(ht.get("U_DAY")));
					
					int cont_fee_amt = fee_s_amt+fee_v_amt;					
							
					scd_fee_amt[i]   = af_db.getUseMonDayAmt(cont_fee_amt, u_mon, u_day);
					scd_fee_s_amt[i] = af_db.getSupAmt(scd_fee_amt[i]);
					scd_fee_v_amt[i] = scd_fee_amt[i]-scd_fee_s_amt[i];
					
					if(reg_type.equals("2") && fee_est_day3.equals("30")){
						if(i > 0 && i < (fee_pay_tm-1)){
							scd_fee_amt[i] = cont_fee_amt;	
							scd_fee_s_amt[i] = fee_s_amt;
							scd_fee_v_amt[i] = fee_v_amt;
						}
					}
					
					if(i==0){
						f_etc = "";
						if(u_mon==1 && u_day==0){
						}else{
							if(u_mon == 0){
								f_etc = "일자계산내역:"+cont_fee_amt+"원(월대여료VAT포함)/30일*"+u_day+"일치";
							}else{
								f_etc = "일자계산내역:"+cont_fee_amt+"원(월대여료VAT포함)*"+u_mon+"개월+"+cont_fee_amt+"/30일*"+u_day+"일치";
							}	
						}
					}
					
					//마지막회차이면
					if(i == (fee_pay_tm-1)){
						scd_fee_amt[i] = (t_fee_s_amt-r_t_fee_s_amt)+(t_fee_v_amt-r_t_fee_v_amt);
						if(scd_fee_amt[i] > cont_fee_amt || scd_fee_amt[i] < cont_fee_amt){
							l_etc = "계산내역:"+cont_fee_amt+"원(월대여료VAT포함)*"+t_con_mon+"개월에서 전스케줄합계를 뺀 나머지 금액";
						}
					}else{		
						r_t_fee_s_amt 		= r_t_fee_s_amt + scd_fee_s_amt[i];
						r_t_fee_v_amt 		= r_t_fee_v_amt + scd_fee_v_amt[i];						
					}					
					
					
					
					//다음회차 시작일을 위해 넘기는 값
					r_use_end_dt 		= use_e_dt[i];
					
					count1++;
					
					out.println(i+"회차 사용기간="+use_s_dt[i]+"~"+use_e_dt[i]+", 대여료="+AddUtil.parseDecimal(scd_fee_amt[i])+"원<br>");
					//System.out.println(i+"회차 사용기간="+use_s_dt[i]+"~"+use_e_dt[i]+", 대여료="+AddUtil.parseDecimal(scd_fee_amt[i])+"원<br>");
					
				}
				
				//일수
				int use_days = AddUtil.parseInt(rs_db.getDay(use_s_dt[fee_pay_tm-1], use_e_dt[fee_pay_tm-1]));
				
				out.println("마지막회차 일수="+use_days+"<br>");
				out.println("월대여료="+fee_amt+"<br>");
				out.println("t_fee_s_amt="+t_fee_s_amt+"<br>");
				out.println("t_fee_v_amt="+t_fee_v_amt+"<br>");
				out.println("r_t_fee_s_amt="+r_t_fee_s_amt+"<br>");
				out.println("r_t_fee_v_amt="+r_t_fee_v_amt+"<br>");
				
				//마지막회차 기간일 길면 분류
				if(use_days > 40){
				
					out.println("마지막회차 기간일="+use_days+"<br>");
					
					
					//전회차는 전전회차 한달차
					use_e_dt[fee_pay_tm-1] = c_db.addMonth(f_use_e_dt2, count1-1);

					//일자계산
					Hashtable ht = af_db.getUseMonDay(use_e_dt[fee_pay_tm-1], use_s_dt[fee_pay_tm-1]);
					u_mon = AddUtil.parseInt(String.valueOf(ht.get("U_MON")));
					u_day = AddUtil.parseInt(String.valueOf(ht.get("U_DAY")));
										
					scd_fee_amt[fee_pay_tm-1] = (fee_s_amt+fee_v_amt);

					
					//System.out.println((fee_pay_tm-1)+"회차 사용기간="+use_s_dt[fee_pay_tm-1]+"~"+use_e_dt[fee_pay_tm-1]+", 대여료="+AddUtil.parseDecimal(scd_fee_amt[fee_pay_tm-1])+"원<br>");
					
					r_use_end_dt 		= use_e_dt[fee_pay_tm-1];
					
					use_s_dt[fee_pay_tm] = c_db.addDay(r_use_end_dt, 1);	
					use_e_dt[fee_pay_tm] = rent_end_dt;
					
					//일자계산
					ht = af_db.getUseMonDay(use_e_dt[fee_pay_tm], use_s_dt[fee_pay_tm]);
					u_mon = AddUtil.parseInt(String.valueOf(ht.get("U_MON")));
					u_day = AddUtil.parseInt(String.valueOf(ht.get("U_DAY")));
							
										
					scd_fee_amt[fee_pay_tm] = (t_fee_s_amt-r_t_fee_s_amt)+(t_fee_v_amt-r_t_fee_v_amt)-(fee_s_amt+fee_v_amt);
					
					
					//System.out.println(fee_pay_tm+"회차 사용기간="+use_s_dt[fee_pay_tm]+"~"+use_e_dt[fee_pay_tm]+", 대여료="+AddUtil.parseDecimal(scd_fee_amt[fee_pay_tm])+"원<br>");
				}
			
			//}
			
			
			
			
		}	
	}
	
%>

<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>

	<%if(from_page.equals("/agent/lc_rent/lc_c_u_start.jsp")){%>
	
	<%	if(reg_type.equals("1")){%>
			
		
		parent.document.form1.fee_est_day1.value 			= <%=AddUtil.parseDecimal(fee_est_day)%>;		
		parent.document.form1.fee_pay_start_dt1.value = parent.document.form1.fee_pay_start_dt.value;		
		parent.document.form1.fee_pay_end_dt1.value 	= parent.document.form1.fee_pay_end_dt.value;	
		parent.document.form1.fee_fst_dt1.value 			= '<%=AddUtil.ChangeDate2(f_use_e_dt)%>';
		parent.document.form1.fee_fst_amt1.value 			= '<%=AddUtil.parseDecimal(f_fee_amt)%>';
		parent.document.form1.fee_fst_amt1_etc.value 	= '<%=f_etc%>';
		parent.document.form1.fee_lst_dt1.value 			= '<%=AddUtil.ChangeDate2(l_use_e_dt)%>';
		parent.document.form1.fee_lst_amt1.value 			= '<%=AddUtil.parseDecimal(l_fee_amt)%>';
		parent.document.form1.fee_lst_amt1_etc.value 	= '<%=l_etc%>';
		parent.document.form1.end_chk.value						= 'Y';
		
	
	<%	}else if(reg_type.equals("2")){%>

		parent.document.form1.fee_est_day2.value 			= '<%=AddUtil.parseDecimal(fee_est_day)%>';		
		parent.document.form1.fee_pay_start_dt2.value = parent.document.form1.fee_pay_start_dt.value;		
		parent.document.form1.fee_pay_end_dt2.value 	= parent.document.form1.fee_pay_end_dt.value;	
		parent.document.form1.fee_fst_dt2.value 			= '<%=AddUtil.ChangeDate2(f_use_e_dt)%>';
		parent.document.form1.fee_fst_amt2.value 			= '<%=AddUtil.parseDecimal(f_fee_amt)%>';
		parent.document.form1.fee_lst_dt2.value 			= '<%=AddUtil.ChangeDate2(l_use_e_dt)%>';
		parent.document.form1.fee_lst_amt2.value 			= '<%=AddUtil.parseDecimal(l_fee_amt)%>';
		
		
		<%if(reg_type.equals("2") && !fee_est_day3.equals("")){%>

		parent.document.form1.fee_pay_start_dt3.value = parent.document.form1.fee_pay_start_dt.value;		
		parent.document.form1.fee_pay_end_dt3.value 	= parent.document.form1.fee_pay_end_dt.value;	
		
		<%//if(!f_use_e_dt.equals(f_use_e_dt2)){%>
		parent.document.form1.fee_fst_dt3.value 			= '<%=AddUtil.ChangeDate2(use_e_dt[0])%>';
		parent.document.form1.fee_fst_amt3.value 			= '<%=AddUtil.parseDecimal(scd_fee_amt[0])%>';
		parent.document.form1.fee_fst_amt3_etc.value 	= '<%=f_etc%>';
		<%	if(scd_fee_amt[fee_pay_tm] > 0){%>		
		parent.document.form1.fee_lst_dt3.value 			= '<%=AddUtil.ChangeDate2(use_e_dt[fee_pay_tm])%>';
		parent.document.form1.fee_lst_amt3.value 			= '<%=AddUtil.parseDecimal(scd_fee_amt[fee_pay_tm])%>';
		<%	}else{%>
		parent.document.form1.fee_lst_dt3.value 			= '<%=AddUtil.ChangeDate2(use_e_dt[fee_pay_tm-1])%>';
		parent.document.form1.fee_lst_amt3.value 			= '<%=AddUtil.parseDecimal(scd_fee_amt[fee_pay_tm-1])%>';
		<%	}%>
		parent.document.form1.fee_lst_amt3_etc.value 	= '<%=l_etc%>';
		<%//}else{%>
		//parent.document.form1.fee_fst_dt3.value 		= '<%=AddUtil.ChangeDate2(f_use_e_dt2)%>';
		//parent.document.form1.fee_fst_amt3.value 		= '<%=AddUtil.parseDecimal(f_fee_amt2)%>';
		//parent.document.form1.fee_lst_dt3.value 		= '<%=AddUtil.ChangeDate2(l_use_e_dt2)%>';
		//parent.document.form1.fee_lst_amt3.value 		= '<%=AddUtil.parseDecimal(l_fee_amt2)%>';
		<%//}%>
		parent.document.form1.end_chk.value						= 'Y';
		
		<%}%>
	
	<%	}%>
	
	
	
	<%}%>
	
</script>
</body>
</html>
