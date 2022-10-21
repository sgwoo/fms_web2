<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.incom.*, acar.con_ins.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.fee.*, acar.bill_mng.*"%>
<%@ page import="acar.car_register.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")		==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
			
	String bank_code 	= request.getParameter("bank_code2")	==null?"":request.getParameter("bank_code2");
	String deposit_no 	= request.getParameter("deposit_no2")	==null?"":request.getParameter("deposit_no2");		
	String bank_name 	= request.getParameter("bank_name")	==null?"":request.getParameter("bank_name");
	String ip_method 	= request.getParameter("ip_method")	==null?"":request.getParameter("ip_method");
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	int    incom_amt 	 	= request.getParameter("incom_amt")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_amt"));
	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
	
	String not_yet 	= request.getParameter("not_yet")==null?"0":request.getParameter("not_yet");  //1:가수금
	String not_yet_reason 	= request.getParameter("not_yet_reason")==null?"":request.getParameter("not_yet_reason");  //1:가수금
	
	String n_ven_name 	= request.getParameter("n_ven_name")==null?"0":request.getParameter("n_ven_name");  //네오엠 거래처명
	String n_ven_code 	= request.getParameter("n_ven_code")==null?"":request.getParameter("n_ven_code");  //네오엠 거래처코드	
		
	CarRegDatabase crd = CarRegDatabase.getInstance();

	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();		

	String value0[]  = request.getParameterValues("gubun");
	String value1[]  = request.getParameterValues("rent_l_cd");
	String value2[]  = request.getParameterValues("car_mng_id");
	String value3[]  = request.getParameterValues("ins_st");
	String value4[]  = request.getParameterValues("ins_tm");//EXT_ID
	String value5[]  = request.getParameterValues("car_no");//차량번호
	String value6[]  = request.getParameterValues("ins_com_id"); //보험사
	String value7[]  = request.getParameterValues("ins_tm2"); // 
	String value8[]  = request.getParameterValues("pay_amt");  //입금액 
	String value9[]  = request.getParameterValues("car_use");  // 1:렌트 1이외:리스 

	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));  //네오엠관련 정보	
	String node_code ="S101";  //네오엠 iu 에서는 회계단위:S101	
	
	Hashtable vendor = new Hashtable();	
		
	String car_no = "";	
	String docu_gubun = "";
	
	if (ip_method.equals("3")) {
		docu_gubun = "1";
	} else {
		docu_gubun = "3";	
	}
	
	//자동전표처리용 & 세금계산서
	Vector vt = new Vector();

	int data_no =0;
	String car_use = "";   //렌트, 리스
	String acct_code = "";
	
	String s_idno = "";	
	String client_st = "";
	String tax_no = "";
	String item_id = "";
  	String reg_code = "";	
  	String row_id = "";
	
  	int  a1_s_amt = 0;  //대여료
    int  a1_v_amt = 0;
		
	boolean flag2 = true;
	int flag1 = 0;
	int flag = 0;
	int count =0;
	int line =0;
	String doc_cont = "";
	String rtn_client = "";
		
		//입금거래내역 정보
	IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
						
	
	//소속영업소 리스트 조회
	Hashtable br = c_db.getBranch("S1"); //무조건 본사 

	//가수금인 경우
	if ( not_yet.equals("1") ) {
	   	   	
		doc_cont = not_yet_reason;
							
	   	line++;
			 				   		
   		Hashtable ht1_1 = new Hashtable();
   		
   		ht1_1.put("WRITE_DATE", 	incom_dt);  //row_id	
		ht1_1.put("ROW_NO",  	String.valueOf(line)); //row_no		
		ht1_1.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
		ht1_1.put("CD_PC",  node_code);  //회계단위*
		ht1_1.put("CD_WDEPT",  dept_code);  //부서
		ht1_1.put("NO_DOCU",  	"");  //row_id와 같게
		ht1_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
		ht1_1.put("CD_COMPANY",  "1000");  
		ht1_1.put("ID_WRITE", insert_id);   
		ht1_1.put("CD_DOCU",  "11");  
		
		ht1_1.put("DT_ACCT",  incom_dt);  
		ht1_1.put("ST_DOCU",  "1");  //미결:1, 승인:2  
		ht1_1.put("TP_DRCR",  "2");   // 대변:2 , 차변:1
		ht1_1.put("CD_ACCT",  "25700");   //가수금
		ht1_1.put("AMT",    	String.valueOf(incom_amt));								
		ht1_1.put("TP_GUBUN",	docu_gubun);  //1:입금 2:출금 3:대체	
		ht1_1.put("CD_PARTNER",	"000131"); //거래처    - A06
			
		ht1_1.put("DT_START",  "");  	//발생일자			
		ht1_1.put("CD_BIZAREA",	"");   //귀속사업장	
		ht1_1.put("CD_DEPT",		"");   //부서								 
		ht1_1.put("CD_CC",			"");   //코스트센터		
		ht1_1.put("CD_PJT",			"");   //프로젝트코드	
		ht1_1.put("CD_CARD",		"");   //신용카드		 		 		
		ht1_1.put("CD_EMPLOY",		"");   //사원	
		ht1_1.put("NO_DEPOSIT",	"");  //예적금계좌
		ht1_1.put("CD_BANK",		"");  //금융기관	
		ht1_1.put("NO_ITEM",		"");  //item 	 
		
				// 부가세관련
		ht1_1.put("AM_TAXSTD",	"");  //과세표준액
		ht1_1.put("AM_ADDTAX",	"" );	 //세액
		ht1_1.put("TP_TAX",	"");  //과세(매출) :11
		ht1_1.put("NO_COMPANY",	""); //사업자등록번호
	
		ht1_1.put("NM_NOTE", doc_cont);  // 적요
				
		vt.add(ht1_1);		
	  
	} else  {   
		
		for(int i=0 ; i < scd_size ; i++){
					
				//자동차정보
			CarRegBean cr_bean = crd.getCarRegBean(value2[i]);		
			car_no =	cr_bean.getCar_no();
		//	car_use =	cr_bean.getCar_use();			
			
			car_use =  value9[i];
			
			int pay_amt = value8[i]	==null?0 :AddUtil.parseDigit(value8[i]);
							
			if(pay_amt > 0){		
					
				//보험관련 환급
			   if(value0[i].equals("scd_ins")){
					out.println("보험관련 환급처리="+pay_amt+", ");					
									
					InsurScdBean scd = ai_db.getInsScd(value2[i], value3[i], value4[i]);
					
					scd.setPay_yn("1");
					scd.setPay_dt(incom_dt);
					if(value7[i].equals("1")){  //변경
						scd.setPay_amt(pay_amt*(-1));		
					} else {
						scd.setPay_amt(pay_amt);		
					}									
					scd.setIncom_dt	(incom_dt); //원장번호
					scd.setIncom_seq (incom_seq);
						
					if(!ai_db.updateInsScd(scd)) flag += 1; 
									
					//보험관련 환급 자동전표생성									  				
					String acct_cont = "";	
															
					if(value7[i].equals("1")){  //변경
					   acct_cont = "[변경보험료환급]";
					} else {  //해지
					   acct_cont = "[해지보험료환급]";
					}
						
					 doc_cont = acct_cont+car_no;
									
					line++;
					
					//보험관련
					Hashtable ht2 = new Hashtable();
					
					ht2.put("WRITE_DATE", 		incom_dt);  //row_id				
					ht2.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht2.put("NO_TAX",  	"*");  //부가세 이외는 *
					ht2.put("CD_PC",  	node_code);  //회계단위
					ht2.put("CD_WDEPT",  dept_code);  //부서
					ht2.put("NO_DOCU",  	"");  //미결은 '0' 
					ht2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
					ht2.put("CD_COMPANY",  "1000");  
					ht2.put("ID_WRITE", insert_id);   
					ht2.put("CD_DOCU",  "11");  
					
					ht2.put("DT_ACCT", 	 incom_dt);  
					ht2.put("ST_DOCU",  "1");  //미결:1, 승인:2  
					ht2.put("TP_DRCR",   "2");   // 대변:2 , 차변:1
					
				//	if ( car_use.equals("1") ) { //렌트용
				//		ht2.put("CD_ACCT",  	"13300");  //대여차량 선급보험료
				//	} else {
			//			ht2.put("CD_ACCT",  	"13200");  //리스차량 선급보험료
				//	}	
					
					ht2.put("CD_ACCT",  	"12000");  //미수금
					ht2.put("AMT",   	String.valueOf(pay_amt));
					ht2.put("TP_GUBUN", "3");  //1:입금 2:출금 3:대체							
					ht2.put("CD_PARTNER",	n_ven_code); //거래처    - A06
											
					ht2.put("DT_START",  "");  	//발생일자										 
					ht2.put("CD_BIZAREA",		"");   //귀속사업장	
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
				
					ht2.put("NM_NOTE", doc_cont);  // 적요						
													
					vt.add(ht2);		
				}
			}  //pay_amt > 0
			out.println("<br>");
		}  //end for 
					
		if(line > 1){
			doc_cont = doc_cont+" 외";
		}			
	}
						
	line++;

	//보통예금
	Hashtable ht1 = new Hashtable();
	
	ht1.put("WRITE_DATE", 	incom_dt);  //row_id			
	ht1.put("ROW_NO",  	String.valueOf(line)); //row_no
	
	ht1.put("NO_TAX",  	"*");  //부가세 이외는 *
	ht1.put("CD_PC",  	node_code);  //회계단위
	ht1.put("CD_WDEPT",  dept_code);  //부서
	ht1.put("NO_DOCU",  	"");  //미결은 '0' 
	ht1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht1.put("CD_COMPANY",  "1000");  
	ht1.put("ID_WRITE", insert_id);   
	ht1.put("CD_DOCU",  "11");  
	
	ht1.put("DT_ACCT",  incom_dt);  
	ht1.put("ST_DOCU",  "1");  //미결:1, 승인:2  					
	ht1.put("TP_DRCR",  	"1");//차변
	ht1.put("CD_ACCT",    "10300");  //보통예금
	ht1.put("AMT",    	String.valueOf(incom_amt));
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

	ht1.put("NM_NOTE", doc_cont);  // 적요			
		
	vt.add(ht1);	
	
	if ( vt.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(incom_dt, vt);
	}
			
	//입금원장처리 - jung_type :1->완료
	if ( not_yet.equals("1") ) {
	   if(!in_db.updateIncomSet( incom_dt, incom_seq, not_yet_reason,  "2" )) flag += 1;
	} else {
	 if(!in_db.updateIncomSet( incom_dt, incom_seq, "1", 0, ip_method, doc_cont, 0 , row_id)) flag += 1;	
	}	
		
%>


<html>
<head><title>FMS</title></head>
<body style="font-size:12">

<form name='form1' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 저장 실패%>
	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				

    fm.action='/fms2/account/incom_r_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
