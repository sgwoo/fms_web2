<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*, acar.coolmsg.*, acar.user_mng.*"%>
<%@ page import="acar.bill_mng.*, acar.incom.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
			
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
		
	String from_page 	=  "/fms2/account/incom_reg_etc_frame.jsp" ;
			
	
	// 리스트
	String acct_seq[] = request.getParameterValues("acct_seq");  //연번
	String tr_date[] = request.getParameterValues("tr_date");   //입금일
	String tr_date_seq[]  = request.getParameterValues("tr_date_seq");  //입금일 순번 
	String naeyoung[]  = request.getParameterValues("naeyoung");
	String bank_nm[] 	= request.getParameterValues("bank_nm");
	String bank_no[] 	= request.getParameterValues("bank_no");
	String ip_amt[] = request.getParameterValues("ip_amt");
	
	int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
										
	String n_ven_code 		= request.getParameter("n_ven_code")==null?"":request.getParameter("n_ven_code");
	String n_ven_name 		= request.getParameter("n_ven_name")==null?"":request.getParameter("n_ven_name");
	String ip_acct 		= request.getParameter("ip_acct")==null?"":request.getParameter("ip_acct");
	String acct_gubun =  request.getParameter("acct_gubun")==null?"":request.getParameter("acct_gubun");
	String remark 		= request.getParameter("remark")==null?"":request.getParameter("remark");
	
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	String node_code ="S101";  //네오엠 iu 에서는 회계단위:S101	
		
	String docu_gubun = "";
	String amt_gubun = "";
	
	//neoe는  현금출납장때문에 무조건 대체로 처리 - 현금도. 
	 docu_gubun = "3";		
	 amt_gubun = "2";	  

	//자동전표처리용 & 세금계산서
	Vector vt = new Vector();	
	String row_id = "";
	  		
	boolean flag2 = true;
	int flag1 = 0;
	int flag = 0;
	int count =0;
	int line =0;
	String doc_cont = "";
	
	int t_pay_amt =  0;	//기타입금분 처리시 사용		
	int ip_acct_amt = 0;
	String incom_dt = "";
	String deposit_no = "";
	String bank_code = "";
	String acc_cont = "";
			
 // 대여계약이 아닌경우 입금된것 처리 - 대출금. 캐쉬백 등 					
	for(int i=0; i<size; i++){

		ip_acct_amt = ip_amt[i]	==null?0 :AddUtil.parseDigit(ip_amt[i]);
	   incom_dt 		= 	 tr_date[i];
	   deposit_no 	=   	 bank_no[i];	
	   	   	
		String value[] = new String[2];
		StringTokenizer st = new StringTokenizer(bank_nm[i],":");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		bank_code 	=   	 value[0];	
	
		// Incom insert 
		IncomBean base = new IncomBean();
										
		base.setIncom_dt		(incom_dt);
	   base.setIncom_amt			(ip_acct_amt);  //입금액
		base.setIncom_gubun	("2");   //집금
		base.setIp_method		("1");
		base.setJung_type		("1");  //  입금대기 0,  1: 완료  2:  가수금  
		base.setP_gubun			("1");   //해당건 처리  
		base.setPay_gur			("0");  //대위변제여부
	   	base.setBank_nm		(bank_nm[i]);
		base.setBank_no		(deposit_no);
		base.setRemark			(naeyoung[i]);
			
		base.setAcct_seq	(acct_seq[i]);
		base.setTr_date_seq	(tr_date_seq[i]);
					
		base.setReg_id			(user_id);
						
		//=====[incom] insert=====
		base = in_db.insertIncom(base);
		int incom_seq 	= base.getIncom_seq();
			
		
	// 신한 집금 완료처리
		if(!ib_db.updateIbAcctTallTrDdFmsYn(acct_seq[i], tr_date[i], tr_date_seq[i]  )) flag += 1;	
		
		
		//경매 입금인 경우			
		int ep3 = 0;
		ep3 = remark.indexOf("자체출고캐쉬백수익");

		if (ep3 != -1) {

			//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
			UsersBean sender_bean = umd.getUsersBean(user_id);

			String sub = "자체출고캐쉬백수익  입금(합산)";
			String cont = "▣ 자체출고캐쉬백수익 확인 (합산):: "  +  n_ven_name + " - " + remark + " " +  naeyoung[i] + ", 입금일:" + incom_dt + ", 입금액: "
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
		//	xml_data += "    <TARGET>2013009</TARGET>"; //이송이 

			xml_data += "    <SENDER>" + sender_bean.getId() + "</SENDER>" + "    <MSGICON>10</MSGICON>"
					+ "    <MSGSAVE>1</MSGSAVE>" + "    <LEAVEDMSG>1</LEAVEDMSG>"
					+ "    <FLDTYPE>1</FLDTYPE>" + "  </ALERTMSG>" + "</COOLMSG>";

			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");

			flag2 = cm_db.insertCoolMsg(msg);

			System.out.println(
					"쿨메신저(자체출고캐쉬백수익 입금확인_합산), "  +  n_ven_name + " - " + remark + " " +  naeyoung[i] +  "-" +  AddUtil.parseDecimalLong(ip_acct_amt)	+ " --------------------" + target_bean.getUser_nm());
			
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
			i_etc.setRemark(remark + " " + naeyoung[i]);
			i_etc.setNeom("Y");
	//		System.out.println("acct_gubun="+ acct_gubun);
			i_etc.setAcct_gubun(acct_gubun);
						
			if(!in_db.insertIncomEtc(i_etc))	flag += 1;	
		}
		 
					
	   //전표처리
	   if ( ip_acct.equals("0")  ) {		
				 	
			line++;
			
			acc_cont =  "[선수금]" + "-" + n_ven_name + " " + remark + "  " +  naeyoung[i];	
			
			if ( acct_gubun.equals("D") ) {
				t_pay_amt =  ip_acct_amt*(-1);	
			} else {
				t_pay_amt =  ip_acct_amt;
			}			
								
		    if ( acct_gubun.equals("D") ) { //차변 
				docu_gubun = "3";		
				amt_gubun = "1";
		    } else {
			    docu_gubun = "3";		
			    amt_gubun = "2";
		    } 
		
			//선수금
			Hashtable ht25 = new Hashtable();			
			
			ht25.put("WRITE_DATE", 	incom_dt);  //row_id			
			ht25.put("ROW_NO",  	String.valueOf(line)); //row_no			
			ht25.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht25.put("CD_PC",  	node_code);  //회계단위
			ht25.put("CD_WDEPT",  dept_code);  //부서
			ht25.put("NO_DOCU",  	"");  //row_id와 같게 
			ht25.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht25.put("CD_COMPANY",  "1000");  
			ht25.put("ID_WRITE", insert_id);   
			ht25.put("CD_DOCU",  "11");  
			
			ht25.put("DT_ACCT",  incom_dt);  
			ht25.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				
			if ( acct_gubun.equals("D") ) {
				ht25.put("TP_DRCR",  amt_gubun); //차변		
			} else {
				ht25.put("TP_DRCR",  amt_gubun); //대변				
			}	
						
			ht25.put("CD_ACCT",  	"25900");  //선수금
			ht25.put("AMT",    	String.valueOf(t_pay_amt));		
			ht25.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체			
			ht25.put("CD_PARTNER",	n_ven_code); //거래처    - A06
	
			ht25.put("DT_START",  incom_dt);  	//발생일자					 
			ht25.put("CD_BIZAREA",		"");   //귀속사업장	
			ht25.put("CD_DEPT",		"");   //부서								 
			ht25.put("CD_CC",			"");   //코스트센터		
			ht25.put("CD_PJT",			"");   //프로젝트코드	
			ht25.put("CD_CARD",		"");   //신용카드			
			ht25.put("CD_EMPLOY",		"");   //사원					 		 
			ht25.put("NO_DEPOSIT",		"");  //예적금계좌
			ht25.put("CD_BANK",		"");  //금융기관	
		 	ht25.put("NO_ITEM",		"");  //item 	 
		 	
		 			// 부가세관련
			ht25.put("AM_TAXSTD",	"");  //과세표준액
			ht25.put("AM_ADDTAX",	"" );	 //세액
			ht25.put("TP_TAX",	"");  //과세(매출) :11
			ht25.put("NO_COMPANY",	""); //사업자등록번호
		
			ht25.put("NM_NOTE", acc_cont);  // 적요				
					
			vt.add(ht25);	
	   }			
						
				//  캐쉬백으로 선택시 
		if ( ip_acct.equals("6")  ||  ip_acct.equals("17") ) {
		
			line++;
			
			acc_cont =  "[캐쉬백]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];	
			
			if ( acct_gubun.equals("D") ) {
				t_pay_amt =  ip_acct_amt*(-1);	
			} else {
				t_pay_amt =  ip_acct_amt;
			}			
				
		    if ( acct_gubun.equals("D") ) { //차변 
				docu_gubun = "3";		
				amt_gubun = "1";
		    } else {
			    docu_gubun = "3";		
				amt_gubun = "2";
			}
		
			//캐쉬백
			Hashtable ht31= new Hashtable();
			
			ht31.put("WRITE_DATE", 	incom_dt);  //row_id		
			ht31.put("ROW_NO",  	String.valueOf(line)); //row_no
			
			ht31.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht31.put("CD_PC",  	node_code);  //회계단위
			ht31.put("CD_WDEPT",  dept_code);  //부서
			ht31.put("NO_DOCU",  	"");  // row_id와 같게 
			ht31.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht31.put("CD_COMPANY",  "1000");  
			ht31.put("ID_WRITE", insert_id);   
			ht31.put("CD_DOCU",  "11");  
			
			ht31.put("DT_ACCT",  incom_dt);  
			ht31.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				
			if ( acct_gubun.equals("D") ) {
				ht31.put("TP_DRCR",  amt_gubun); //차변		
			} else {
				ht31.put("TP_DRCR",  amt_gubun); //대변				
			}	
						
			ht31.put("CD_ACCT",    	"91100");  //카드캐쉬백
			ht31.put("AMT",    	String.valueOf(t_pay_amt));		
			ht31.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체				
			ht31.put("CD_PARTNER",	n_ven_code); //거래처    - A06
					
			ht31.put("DT_START",   	 "");  	//발생일자					 
			ht31.put("CD_BIZAREA",		"");   //귀속사업장	
			ht31.put("CD_DEPT",		"");   //부서								 
			ht31.put("CD_CC",			"");   //코스트센터		
			ht31.put("CD_PJT",			"");   //프로젝트코드	
			ht31.put("CD_CARD",		"");   //신용카드		 		 	
			ht31.put("CD_EMPLOY",		"");   //사원	
			ht31.put("NO_DEPOSIT",		"");  //예적금계좌
			ht31.put("CD_BANK",		"");  //금융기관	
		 	ht31.put("NO_ITEM",		"");  //item 	 
		 	
		 			// 부가세관련
			ht31.put("AM_TAXSTD",	"");  //과세표준액
			ht31.put("AM_ADDTAX",	"" );	 //세액
			ht31.put("TP_TAX",	"");  //과세(매출) :11
			ht31.put("NO_COMPANY",	""); //사업자등록번호	 
		
			ht31.put("NM_NOTE", acc_cont);  // 적요				
						
			vt.add(ht31);	
		}	
	
					
		// 가지급금
		if ( ip_acct.equals("11") ) {
							 	
			line++;
			
			acc_cont =  "[가지급금]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
								
			if ( acct_gubun.equals("D") ) { 
				t_pay_amt =  ip_acct_amt*(-1);	
			} else {
				t_pay_amt =  ip_acct_amt;
			}
					
		    if ( acct_gubun.equals("D") ) { //차변 
				docu_gubun = "3";		
				amt_gubun = "1";
		    } else {
			    docu_gubun = "3";		
				amt_gubun = "2";
		    } 
			
							
			// 가지급금
			Hashtable ht36= new Hashtable();
			
			ht36.put("WRITE_DATE", 	incom_dt);  //row_id			
			ht36.put("ROW_NO",  	String.valueOf(line)); //row_no
			
			ht36.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht36.put("CD_PC",  	node_code);  //회계단위
			ht36.put("CD_WDEPT",  dept_code);  //부서
			ht36.put("NO_DOCU",  	"");  //row_id와 같게 
			ht36.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht36.put("CD_COMPANY",  "1000");  
			ht36.put("ID_WRITE", insert_id);   
			ht36.put("CD_DOCU",  "11");  
			
			ht36.put("DT_ACCT",  incom_dt);  
			ht36.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				
			if ( acct_gubun.equals("D") ) {
				ht36.put("TP_DRCR",  amt_gubun); //차변		
			} else {
				ht36.put("TP_DRCR",  amt_gubun); //대변				
			}	
						
			ht36.put("CD_ACCT",    	 	"13400");  // 가지급금
			ht36.put("AMT",    	String.valueOf(t_pay_amt));		
			ht36.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체				
			ht36.put("CD_PARTNER",	n_ven_code); //거래처    - A06
					
			ht36.put("DT_START",   incom_dt);   	//발생일자					 
			ht36.put("CD_BIZAREA",		"");   //귀속사업장	
			ht36.put("CD_DEPT",		"");   //부서								 
			ht36.put("CD_CC",			"");   //코스트센터		
			ht36.put("CD_PJT",			"");   //프로젝트코드	
			ht36.put("CD_CARD",		"");   //신용카드		 		 	
			ht36.put("CD_EMPLOY",		"");   //사원
			ht36.put("NO_DEPOSIT",		"");  //예적금계좌
			ht36.put("CD_BANK",		"");  //금융기관	
		 	ht36.put("NO_ITEM",		"");  //item 	
		 	
		 			// 부가세관련
			ht36.put("AM_TAXSTD",	"");  //과세표준액
			ht36.put("AM_ADDTAX",	"" );	 //세액
			ht36.put("TP_TAX",	"");  //과세(매출) :11
			ht36.put("NO_COMPANY",	""); //사업자등록번호    	 
		
			ht36.put("NM_NOTE", acc_cont);  // 적요			
			
			vt.add(ht36);								
		
		}								
			
		// 사고수리비 - 과실 확정후 보험회사 수리비 입금건 - , 19:사고수리비. 20:운반비 , 18:이자수익 - 차변:환급분, 대변: 납부할금액  
		// 1:승계수수료 2:채권추심수수료, 3:과입금으로 인한 고객환불 , 4:면책금, 12: 잡이익, 16:단기차입금 - 차변:환급분, 대변: 납부할금액 , 13: 과태료 미수금  , 14:선급금, 15:미수금 10:미지급금 , 9:지급수수료 , 8:외상매출금 , 7:세금과공과 , 5:가수금
		if (  ip_acct.equals("1") ||  ip_acct.equals("2") ||  ip_acct.equals("3") ||  ip_acct.equals("4") ||  ip_acct.equals("5")  || ip_acct.equals("7") ||  ip_acct.equals("8") ||  ip_acct.equals("9") ||  ip_acct.equals("10") ||  ip_acct.equals("12") ||  ip_acct.equals("13") ||  ip_acct.equals("14")  || ip_acct.equals("15")  ||  ip_acct.equals("18") || ip_acct.equals("19") || ip_acct.equals("20") ||  ip_acct.equals("16")  ) {
				 	
			line++;
			
			acc_cont = "";
			String acct_code = "";			
			
		   if (  ip_acct.equals("19") ) {
		    		 acc_cont =  "[사고수리비]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
		    		 acct_code = "45510"; //차량사고수리정비비
		   } else if (  ip_acct.equals("1") ) {
			 		 acc_cont =  "[승계수수료]" + "-" + n_ven_name+ " " +remark + "  " +  naeyoung[i];		
			 		 acct_code = "45510";	   //면책금		  		  		 
		   } else if (  ip_acct.equals("2") ) {
			 		 acc_cont =  "[채권추심수수료]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "25300";	  	//미지급금 	  		 
		   } else if (  ip_acct.equals("3") ) {
			 		 acc_cont =  "[과입금 환불]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "25300";	  		//미지급금  
		    } else if (  ip_acct.equals("4") ) {
			 		 acc_cont =  "[면책금]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "45510";	 //차량사고수리정비비		 
		    } else if (  ip_acct.equals("5") ) {
			 		 acc_cont =  "[가수금]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];			
			 		 acct_code = "25700";	  		 
		   } else if (  ip_acct.equals("7") ) {
			 		 acc_cont =  "[세금과공과]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "46300";	  	 		  		 
		   } else if (  ip_acct.equals("8") ) {
			 		 acc_cont =  "[외상매출금]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "10800";	  	 		 
		   } else if (  ip_acct.equals("9") ) {
			 		 acc_cont =  "[지급수수료]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];			
			 		 acct_code = "83100";	  	 		 
		   } else if (  ip_acct.equals("10") ) {
			 		 acc_cont =  "[미지급금]" + "-" + n_ven_name+ " " +remark + "  " +  naeyoung[i];		
			 		 acct_code = "25300";	  		 
		   } else if (  ip_acct.equals("12") ) {
			 		 acc_cont =  "[잡이익]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "93000";	  		 
		   } else if (  ip_acct.equals("13") ) {
			 		 acc_cont =  "[과태료미수금]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "12400";	 
		  } else if (  ip_acct.equals("14") ) {
			 		 acc_cont =  "[선급금]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "13100";	 	 		  		 
		   } else if (  ip_acct.equals("15") ) {
			 		 acc_cont =  "[미수금]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "12000";	 		 
		   } else if (  ip_acct.equals("16") ) {
			 		 acc_cont =  "[단기차입금]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "26000";			 		  					 		 
			} else if (  ip_acct.equals("18") ) {
			 		 acc_cont =  "[이자수익]" + "-" + n_ven_name+ " " + remark + "  " +  naeyoung[i];		
			 		 acct_code = "90100";			 		  					
		   } else if (  ip_acct.equals("20") ) {
			 		 acc_cont =  "[운반비]" + "-" + n_ven_name+ " " +remark + "  " +  naeyoung[i];		
			 		 acct_code = "46400";
			}
			
			//채권추심인 경우 
			if (  ip_acct.equals("2") ) {
			  	if ( acct_gubun.equals("D") ) { 
					t_pay_amt =  ip_acct_amt;	
				} else {
					t_pay_amt = ip_acct_amt*(-1);	
				}
			} else {								
				if ( acct_gubun.equals("D") ) { 
					t_pay_amt =  ip_acct_amt*(-1);	
				} else {
					t_pay_amt =  ip_acct_amt;
				}
			}
					
		    if ( acct_gubun.equals("D") ) { //차변 
				docu_gubun = "3";		
				amt_gubun = "1";
		    } else {
			    docu_gubun = "3";		
				amt_gubun = "2";
		    } 
											
			Hashtable ht43 =  new Hashtable();
			
			ht43.put("WRITE_DATE", 	incom_dt);  //row_id			
			ht43.put("ROW_NO",  	String.valueOf(line)); //row_no			
			ht43.put("NO_TAX",  	"*");  //부가세 이외는 *
			ht43.put("CD_PC",  	node_code);  //회계단위
			ht43.put("CD_WDEPT",  dept_code);  //부서
			ht43.put("NO_DOCU",  	"");  //row_id와 같게 
			ht43.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht43.put("CD_COMPANY",  "1000");  
			ht43.put("ID_WRITE", insert_id);   
			ht43.put("CD_DOCU",  "11");  
			
			ht43.put("DT_ACCT",  incom_dt);  
			ht43.put("ST_DOCU",  "1");  //미결:1, 승인:2  
				
			if ( acct_gubun.equals("D") ) {
				ht43.put("TP_DRCR",  amt_gubun); //차변		
			} else {
				ht43.put("TP_DRCR",  amt_gubun); //대변				
			}	
						
			ht43.put("CD_ACCT",    	 		  acct_code); 
			ht43.put("AMT",    	String.valueOf(t_pay_amt));		
			ht43.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체				
			ht43.put("CD_PARTNER",	n_ven_code); //거래처    - A06
				
			ht43.put("DT_START",  incom_dt);   	//발생일자					 
			ht43.put("CD_BIZAREA",		"");   //귀속사업장	
			ht43.put("CD_DEPT",		"");   //부서								 
			ht43.put("CD_CC",			"");   //코스트센터		
			ht43.put("CD_PJT",			"");   //프로젝트코드	익
			ht43.put("CD_CARD",		"");   //신용카드		 		 	
			ht43.put("CD_EMPLOY",		"");   //사원	
			ht43.put("NO_DEPOSIT",		"");  //예적금계좌
			ht43.put("CD_BANK",		"");  //금융기관	
		 	ht43.put("NO_ITEM",		"");  //item   	
		 	
		 			// 부가세관련
			ht43.put("AM_TAXSTD",	"");  //과세표준액
			ht43.put("AM_ADDTAX",	"" );	 //세액
			ht43.put("TP_TAX",	"");  //과세(매출) :11
			ht43.put("NO_COMPANY",	""); //사업자등록번호		  	 	 
		
			ht43.put("NM_NOTE", acc_cont);  // 적요	
		
			vt.add(ht43);	
		}		
			
		
	   //행별로 보통예금 처리  
		line++;
		
		//보통예금
		Hashtable ht1 = new Hashtable();
		
		ht1.put("WRITE_DATE", 	incom_dt);  //row_id			
		ht1.put("ROW_NO",  	String.valueOf(line)); //row_no
									
		ht1.put("NO_TAX",  	"*");  //부가세 이외는 *
		ht1.put("CD_PC",  	node_code);  //회계단위
		ht1.put("CD_WDEPT",  dept_code);  //부서
		ht1.put("NO_DOCU",  	"");  //row_id와 같게 
		ht1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht1.put("CD_COMPANY",  "1000");  
		ht1.put("ID_WRITE", insert_id);   
		ht1.put("CD_DOCU",  "11");  
		
		ht1.put("DT_ACCT",  incom_dt);  
		ht1.put("ST_DOCU",  "1");  //미결:1, 승인:2  					
		ht1.put("TP_DRCR",  	"1");//차변
		ht1.put("CD_ACCT",    "10300");  //보통예금
		ht1.put("AMT",    	String.valueOf(ip_acct_amt));
		ht1.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체				
		ht1.put("CD_PARTNER",	""); //거래처    - A06
				
		ht1.put("DT_START",  "");   	//발생일자					 
		ht1.put("CD_BIZAREA",		"");   //귀속사업장	
		ht1.put("CD_DEPT",		"");   //부서								 
		ht1.put("CD_CC",			"");   //코스트센터		
		ht1.put("CD_PJT",			"");   //프로젝트코드	
		ht1.put("CD_CARD",		"");   //신용카드		 		 	
		ht1.put("CD_EMPLOY",		"");   //사원
		ht1.put("NO_DEPOSIT",	deposit_no);  //예적금계좌
		ht1.put("CD_BANK",		bank_code);  //금융기관	
	 	ht1.put("NO_ITEM",		"");  //item
	 	
	 			// 부가세관련
		ht1.put("AM_TAXSTD",	"");  //과세표준액
		ht1.put("AM_ADDTAX",	"" );	 //세액
		ht1.put("TP_TAX",	"");  //과세(매출) :11
		ht1.put("NO_COMPANY",	""); //사업자등록번호
	
		ht1.put("NM_NOTE", acc_cont);  // 적요			
					
		vt.add(ht1);
																								
																											
 }  //for loop						
			
 if  ( vt.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(incom_dt,  vt);		
 }
 	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
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

