<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.user_mng.*, acar.bank_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String vid1[] = request.getParameterValues("l_id");
	String vid2[] = request.getParameterValues("cpt_cd");
	String vid3[] = request.getParameterValues("cont_dt");
	String vid4[] = request.getParameterValues("gubun");		
		
	int vid_size = 0;
	vid_size = vid1.length;
	
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String cont_dt1 = request.getParameter("cont_dt1")==null?"":request.getParameter("cont_dt1");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
		
	String ch_l_id="";  
	String ch_cpt_cd="";
	String ch_cont_dt="";
	String ch_gubun="";
		
	int flag = 0;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	
	String node_code ="S101";  //네오엠 iu 에서는 회계단위:S101	
		
	Hashtable vendor = new Hashtable();	
	
	String ven_code = "";

	String doc_cont = "";
	String cont_dt = "";
	int line =0;
	long cont_amt = 0;
	long a_cont_amt = 0;
	
	//자동전표처리용 & 세금계산서
	Vector vt = new Vector();
	int data_no =0;
	String row_id = "";				
				
	for(int i=0;i < vid_size;i++){
		
		ch_l_id = vid1[i];
		ch_cpt_cd = vid2[i];
		ch_cont_dt = vid3[i];
		ch_gubun = vid4[i];
				
				//대출관련 정보 조회
		Hashtable bank_lend = abl_db.getBankLendAcctList( ch_l_id);
			
		//기타비용		
		if (	ch_gubun.equals("3") ) {	
			bank_lend = abl_db.getBankLendAcctListEtc(ch_l_id);
		}
									
		long b_amt 	= AddUtil.parseLong((String)bank_lend.get("B_AMT"));  //당해년도 차입금
		long a_amt 	= AddUtil.parseLong((String)bank_lend.get("A_AMT"));  //당해년도 차입금
		long c_amt  = 0;
		cont_amt 	= AddUtil.parseLong((String)bank_lend.get("CONT_AMT"));  //대출금(선수금)
		ven_code 	= (String)bank_lend.get("VEN_CODE")==null?"":(String)bank_lend.get("VEN_CODE");
		cont_dt 	= (String)bank_lend.get("CONT_DT");
		String acct_code 	= (String)bank_lend.get("ACCT_CODE");   //리스료:45450 롯데캐피탈 운용리스건 
		String car_no 	= (String)bank_lend.get("CAR_NO");
		String car_use 	= (String)bank_lend.get("CAR_USE");
		
		if(!ven_code.equals("") && !ven_code.equals("null") ){
		
			vendor = neoe_db.getVendorCase(ven_code);	
												
			//대출선수금 자동전표생성					
			String acct_cont = "";
							
			if (	ch_gubun.equals("2") ) {			
				acct_cont = vendor.get("VEN_NAME")+"( " + car_no +" - " + ch_l_id + " )";
			} else if (	ch_gubun.equals("3") ) {			
					acct_cont = vendor.get("VEN_NAME")+"( " + car_no +" - " + ch_l_id + " 기타비용 )";				
			} else {
				acct_cont = vendor.get("VEN_NAME")+"( " + ch_l_id + " )";
			}						
			if(doc_cont.equals("")){
				doc_cont = acct_cont;
			}
			
			//유동성장기부채인 경우 - 당해년도 발생분 
			if ( acct_code.equals("26400") ||  acct_code.equals("29300") ) { 
				//12개월이후는 장기차입금 ( 202012월 - b_amt+a_amt를 장기차입금(29300)으로 )
				c_amt = b_amt + a_amt; 
			//	if ( cont_amt != c_amt) {
			//		System.out.println("대출 전표 cont_amt = " + cont_amt + " : c_amt = "+ c_amt + ": ch_l_id = "+ ch_l_id );					
			//	}
			/*	if (b_amt > 0) {			
					line++;
						
					//부채관련계정
					Hashtable ht1 = new Hashtable();
					
					ht1.put("WRITE_DATE", 	cont_dt);//row_id	
					ht1.put("ROW_NO",  	String.valueOf(line)); //row_no		
					ht1.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
					ht1.put("CD_PC",  	node_code);  //회계단위*
					ht1.put("CD_WDEPT",  dept_code);  //부서
					ht1.put("NO_DOCU",  	"");  //row_id와 같게
					ht1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht1.put("CD_COMPANY",  "1000");  
					ht1.put("ID_WRITE", insert_id);   
					ht1.put("CD_DOCU",  "11");  
					
					ht1.put("DT_ACCT",cont_dt); 
					ht1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht1.put("TP_DRCR",  "2");   // 대변:2 , 차변:1
					ht1.put("CD_ACCT",  "26400");  //유동성장기부채
					ht1.put("AMT",    	String.valueOf(b_amt));									
					ht1.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체	
					ht1.put("CD_PARTNER",	ven_code); //거래처    - A06
						
					ht1.put("DT_START", cont_dt) ;  	//발생일자			
					ht1.put("CD_BIZAREA",	"");   //귀속사업장	
					ht1.put("CD_DEPT",		"");   //부서								 
					ht1.put("CD_CC",			"");   //코스트센터		
					ht1.put("CD_PJT",			"");   //프로젝트코드	
					ht1.put("CD_CARD",		"");   //신용카드		 		 		
					ht1.put("CD_EMPLOY",		"");   //사원	
					ht1.put("NO_DEPOSIT",	"");  //예적금계좌
					ht1.put("CD_BANK",		"");  //금융기관	
					ht1.put("NO_ITEM",		"");  //item 	 
					
							// 부가세관련
					ht1.put("AM_TAXSTD",	"");  //과세표준액
					ht1.put("AM_ADDTAX",	"" );	 //세액
					ht1.put("TP_TAX",	"");  //과세(매출) :11
					ht1.put("NO_COMPANY",	""); //사업자등록번호
				
					ht1.put("NM_NOTE", acct_cont);  // 적요
						
					vt.add(ht1);					
				}
				*/
				//장기차입금이 있으면 - 당해년 이후 상환금액이 있는 경우	 
				if (c_amt > 0) {				
					line++;
					
					//부채관련계정
					Hashtable ht2 = new Hashtable();
					
					ht2.put("WRITE_DATE", 	cont_dt);//row_id	
					ht2.put("ROW_NO",  	String.valueOf(line)); //row_no		
					ht2.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
					ht2.put("CD_PC",  	node_code);  //회계단위*
					ht2.put("CD_WDEPT",  dept_code);  //부서
					ht2.put("NO_DOCU",  	"");  //row_id와 같게
					ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht2.put("CD_COMPANY",  "1000");  
					ht2.put("ID_WRITE", insert_id);   
					ht2.put("CD_DOCU",  "11");  
					
					ht2.put("DT_ACCT",cont_dt); 
					ht2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht2.put("TP_DRCR",  "2");   // 대변:2 , 차변:1
					ht2.put("CD_ACCT",  "29300");  //장기차입금
					ht2.put("AMT",    	String.valueOf(c_amt));						
					ht2.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체	
					ht2.put("CD_PARTNER",	ven_code); //거래처    - A06
						
					ht2.put("DT_START", cont_dt) ;  	//발생일자			
					ht2.put("CD_BIZAREA",	"");   //귀속사업장	
					ht2.put("CD_DEPT",		"");   //부서								 
					ht2.put("CD_CC",			"");   //코스트센터		
					ht2.put("CD_PJT",			"");   //프로젝트코드	
					ht2.put("CD_CARD",		"");   //신용카드		 		 		
					ht2.put("CD_EMPLOY",		"");   //사원	
					ht2.put("NO_DEPOSIT",	"");  //예적금계좌
					ht2.put("CD_BANK",		"");  //금융기관	
					ht2.put("NO_ITEM",		"");  //item 	 
					
							// 부가세관련
					ht2.put("AM_TAXSTD",	"");  //과세표준액
					ht2.put("AM_ADDTAX",	"" );	 //세액
					ht2.put("TP_TAX",	"");  //과세(매출) :11
					ht2.put("NO_COMPANY",	""); //사업자등록번호
				
					ht2.put("NM_NOTE", acct_cont);  // 적요
								
					vt.add(ht2);				
				}
			
			
			} else { //단기차입금
			
				if (b_amt > 0) {		
					line++;
						
						//부채관련계정 - 단기차입금
					Hashtable ht5 = new Hashtable();
					
					ht5.put("WRITE_DATE", 	cont_dt);//row_id	
					ht5.put("ROW_NO",  	String.valueOf(line)); //row_no		
					ht5.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
					ht5.put("CD_PC",  	node_code);  //회계단위*
					ht5.put("CD_WDEPT",  dept_code);  //부서
					ht5.put("NO_DOCU",  	"");  //row_id와 같게
					ht5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht5.put("CD_COMPANY",  "1000");  
					ht5.put("ID_WRITE", insert_id);   
					ht5.put("CD_DOCU",  "11");  
					
					ht5.put("DT_ACCT",cont_dt); 
					ht5.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht5.put("TP_DRCR",  "2");   // 대변:2 , 차변:1
					ht5.put("CD_ACCT",  "26000");  //단기차입금
					ht5.put("AMT",    	String.valueOf(b_amt));				
					ht5.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체	
					ht5.put("CD_PARTNER",	ven_code); //거래처    - A06
						
					ht5.put("DT_START", cont_dt) ;  	//발생일자			
					ht5.put("CD_BIZAREA",	"");   //귀속사업장	
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
				
					ht5.put("NM_NOTE", acct_cont);  // 적요
				
					vt.add(ht5);	
				}				
			}
			
			
			if (	!ch_gubun.equals("3") ) {	
				//대출(차입)전표 생성							
				if(!abl_db.updateFacctYn(ch_l_id, ch_gubun))	flag += 1;
			}	
			
			a_cont_amt = a_cont_amt + cont_amt;
			
		} // 거래처가 있는 경우	
	
		
	} // end for -선택된대출
	
	System.out.println("대출 선수금 = " + a_cont_amt );
	line++;
					
	//선수금계정
	Hashtable ht3 = new Hashtable();
	
	//대출금선수금
	ht3.put("WRITE_DATE", 	cont_dt);//row_id	
	ht3.put("ROW_NO",  	String.valueOf(line)); //row_no		
	ht3.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
	ht3.put("CD_PC",  	node_code);  //회계단위*
	ht3.put("CD_WDEPT",  dept_code);  //부서
	ht3.put("NO_DOCU",  	"");  //row_id와 같게
	ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht3.put("CD_COMPANY",  "1000");  
	ht3.put("ID_WRITE", insert_id);   
	ht3.put("CD_DOCU",  "11");  
	
	ht3.put("DT_ACCT",cont_dt); 
	ht3.put("ST_DOCU",  "1");  //미결:1, 승인:2  
	ht3.put("TP_DRCR",  "1");   // 대변:2 , 차변:1
	ht3.put("CD_ACCT",  	"25900"); //선수금
	ht3.put("AMT",    	String.valueOf(a_cont_amt));	
	ht3.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체	
	ht3.put("CD_PARTNER",	ven_code); //거래처    - A06
		
	ht3.put("DT_START", cont_dt) ;  	//발생일자			
	ht3.put("CD_BIZAREA",	"");   //귀속사업장	
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
				
	vt.add(ht3);
	
	if ( vt.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(cont_dt,  vt);
	}
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step2(){		
	
		var fm = document.form1;	
		
		fm.action = 'debt_r_frame.jsp';
		fm.target = "d_content";
		fm.submit();
		
		parent.window.close();	
	
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='from_page' value='/fms2/bank_mng/debt_r_frame.jsp'>
</form>

<script language='javascript'>
<!--
<%		if(flag > 0) { %>   
			alert("에러가 발생하였습니다.");
<%		} else if ( row_id.equals("0") ) { %>
			alert("전표생성 에러가 발생하였습니다.");				
<%		} else { %>
			alert("등록되었습니다.");
			go_step2();
<%		}%>
//-->
</script>
</body>
</html>