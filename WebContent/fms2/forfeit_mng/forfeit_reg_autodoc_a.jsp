<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<body>
<%

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
			
	String acct_dt = request.getParameter("acct_dt")==null?AddUtil.getDate():request.getParameter("acct_dt");
	
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	AddForfeitDatabase 	a_fdb 	= AddForfeitDatabase.getInstance();

	Vector vt = a_fdb.getForfeitSearchList(acct_dt, acct_dt, s_kd, t_wd, sort, asc);	
	
	int ser_size = vt.size();
		
	int vat_amt  = 0;
	int gr_amt = 0;
			
	//자동전표 발행-네오엠 자동전표 처리
	String autodoc = request.getParameter("autodoc")==null?"N":request.getParameter("autodoc");
			
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));
	String node_code ="S101";  //네오엠 iu 에서는 회계단위:S101	
									
	int flag = 0;
	boolean flag1 = true;
				
    	String ven_code     = "";    

	Vector vt_auto = new Vector();
	int line =0;
	String doc_cont = "";	
	int data_no = 0;
	String row_id = "";
	
	Hashtable vendor = new Hashtable();	
				
	for(int i = 0 ; i < ser_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
						 					 
			int v_amt = AddUtil.parseInt((String)ht.get("PAID_AMT")); //금액
			
			ven_code =   String.valueOf(ht.get("VEN_CODE"));
		         vendor = neoe_db.getVendorCase(ven_code);	
		     
		    // 누계
			gr_amt  = gr_amt  + v_amt;	
		 	
		 	doc_cont = "[선납과태료 환불] " + String.valueOf(ht.get("CAR_NO") )  + " " + String.valueOf(vendor.get("VEN_NAME")) +  " " +  String.valueOf(ht.get("VIO_DT")) + " " +  String.valueOf(ht.get("VIO_PLA"));
			
			line++;
								 				
			Hashtable ht7 = new Hashtable();		// 과태료
			
			ht7.put("WRITE_DATE", 	acct_dt);//row_id	
			ht7.put("ROW_NO",  	String.valueOf(line)); //row_no		
			ht7.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
			ht7.put("CD_PC",  	node_code);  //회계단위*
			ht7.put("CD_WDEPT",  dept_code);  //부서
			ht7.put("NO_DOCU",  	"");  //row_id와 같게
			ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
			ht7.put("CD_COMPANY",  "1000");  
			ht7.put("ID_WRITE", insert_id);   
			ht7.put("CD_DOCU",  "11");  
			
			ht7.put("DT_ACCT",  acct_dt); 
			ht7.put("ST_DOCU",  "1");  //미결:1, 승인:2  
			ht7.put("TP_DRCR",  "1");   // 대변:2 , 차변:1
			ht7.put("CD_ACCT",  "12400");   // 과태료미수금
			ht7.put("AMT",    	String.valueOf(v_amt * (-1) ) );								
			ht7.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체	
			ht7.put("CD_PARTNER",  ven_code);  //거래처    - A06
				
			ht7.put("DT_START", "") ;  	//발생일자			
			ht7.put("CD_BIZAREA",	"");   //귀속사업장	
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
		
			ht7.put("NM_NOTE", doc_cont); // 적요	
								
			vt_auto.add(ht7);    //과태료	
		
	}
		
	line++;
				
	Hashtable ht10 = new Hashtable();		// 가수금 합계
	
	ht10.put("WRITE_DATE", 	acct_dt);//row_id	
	ht10.put("ROW_NO",  	String.valueOf(line)); //row_no		
	ht10.put("NO_TAX",  	"*");  //부가세 이외는 * ,  no_docu || no_doline
	ht10.put("CD_PC",  	node_code);  //회계단위*
	ht10.put("CD_WDEPT",  dept_code);  //부서
	ht10.put("NO_DOCU",  	"");  //row_id와 같게
	ht10.put("NO_DOLINE",  String.valueOf(line)); //row_no  : 미결인 경우???
	ht10.put("CD_COMPANY",  "1000");  
	ht10.put("ID_WRITE", insert_id);   
	ht10.put("CD_DOCU",  "11");  
	
	ht10.put("DT_ACCT",  acct_dt); 
	ht10.put("ST_DOCU",  "1");  //미결:1, 승인:2  
	ht10.put("TP_DRCR",  "1");   // 대변:2 , 차변:1
	ht10.put("CD_ACCT",  "25700");   //가수금
	ht10.put("AMT",    	 String.valueOf(gr_amt) );											
	ht10.put("TP_GUBUN",	"3");  //1:입금 2:출금 3:대체	
	ht10.put("CD_PARTNER",	"003957"); //거래처    - A06
		
	ht10.put("DT_START", "") ;  	//발생일자			
	ht10.put("CD_BIZAREA",	"");   //귀속사업장	
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

	ht10.put("NM_NOTE",  "아마존카 선납과태료 환불"); // 적요	
							
	vt_auto.add(ht10);  // 선납과태료 환불
			
	 if ( vt_auto.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(acct_dt,  vt_auto);
  	}
  			
%>
<form name='form1' method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">
</form>

<script language='javascript'>

<%	if(flag != 0){%>
		alert('오류발생!');
<%	}else if( row_id.equals("0")  ){%>
		alert('자동전표 오류발생!');		
<%	}else{%>
		alert('처리되었습니다');			
<%	}%>
	
</script>
</body>
</html>
