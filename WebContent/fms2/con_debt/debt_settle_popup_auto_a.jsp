<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.debt.*, acar.bill_mng.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	out.println("<<일괄결산전표처리>>"+"<br><br>");
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	String auto_dt 	= request.getParameter("auto_dt")==null?"":request.getParameter("auto_dt");
	
	if(auto_dt.equals("")) auto_dt = "20201231";
	
	String size = request.getParameter("size")==null?"0":request.getParameter("size");
	
	String vid[] = request.getParameterValues("ch_l_cd");
	int vid_size = vid.length;
	out.println("* 선택건수="+vid_size+"<br><br>");
	
	String value[] = new String[10];
	
	String gubun		="";
	String cpt_cd		="";
	String ven_code		="000131"; //아마존카 
	String lend_id		="";
	String rtn_seq 		="";
	String car_mng_id	="";
	String rent_l_cd	="";
	String deposit_no	="";
	String car_no 		="";
	String amt13 		="";
	String ven_name		="";
	
	long l_amt13 = 0;
	
	int flag = 0;
	int count =0;
	int line =0;
	
	//사용자정보-더존
	Hashtable per = neoe_db.getPerinfoDept(login.getAcarName(ck_acar_id));
	String insert_id = String.valueOf(per.get("SA_CODE"));
	
	
	Vector vt = new Vector();


	//[1단계] 거래명세서 리스트 생성
	
	for(int i=0; i < vid_size; i++){
		
		out.print("=============================================================");out.println("<br>");
		out.print(i+1+". ");
		
		
		StringTokenizer st = new StringTokenizer(vid[i],"/");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		gubun 		= value[0]==null?"":value[0];
		cpt_cd		= value[1]==null?"":value[1];
		ven_code	= value[2]==null?"":value[2];
		amt13 		= value[3]==null?"":value[3];
		lend_id		= value[4]==null?"":value[4];
		rtn_seq		= value[5]==null?"":value[5];
		car_mng_id 	= value[6]==null?"":value[6];
		rent_l_cd	= value[7]==null?"":value[7];
		deposit_no	= value[8]==null?"":value[8];
		car_no		= value[9]==null?"":value[9];
		
		l_amt13 = l_amt13 + AddUtil.parseLong(amt13);  //12개월내 상환도래 차입금			
				
	}	
		
	//	if(ven_code.equals("")){
	//		out.println("[거래처코드없음] ");
	//	}else{
			
			ven_name 	= neoe_db.getCodeByNm("ven", ven_code);
			
		/*	out.println("[0]gubun="+gubun+" ");
			out.println("[1]cpt_cd="+cpt_cd+" ");
			out.println("[2]ven_code="+ven_code+" ");
			out.println("[3]amt13="+amt13+" ");
			out.println("[4]lend_id="+lend_id+" ");
			out.println("[5]rtn_seq="+rtn_seq+" ");
			out.println("[6]car_mng_id="+car_mng_id+" ");
			out.println("[7]rent_l_cd="+rent_l_cd+" ");
			out.println("[8]deposit_no="+deposit_no+" ");
			out.println("[9]car_no="+car_no+" "); */
			
			line++;
			
			//장기차입금
			Hashtable ht1 = new Hashtable();
			ht1.put("DATA_GUBUN", 	"53");
			ht1.put("WRITE_DATE", 	auto_dt);
			ht1.put("DATA_NO",    	"");
			ht1.put("DATA_LINE",  	String.valueOf(line));
			ht1.put("DATA_SLIP",  	"1");
			ht1.put("DEPT_CODE",  	"200");
			ht1.put("NODE_CODE",  	"S101");
			ht1.put("C_CODE",     	"1000");
			ht1.put("DATA_CODE",  	"");
			ht1.put("DOCU_STAT",  	"0");
			ht1.put("DOCU_TYPE",  	"11");
			ht1.put("DOCU_GUBUN", 	"3");
			ht1.put("AMT_GUBUN",  	"3");//차변
			ht1.put("DR_AMT",    	String.valueOf(l_amt13) );
			ht1.put("CR_AMT",     	"0");
			ht1.put("ACCT_CODE",  	"29300");
			ht1.put("CHECK_CODE1",	"A07");//거래처
			ht1.put("CHECK_CODE2",	"F01");//차입금관리번호
			ht1.put("CHECK_CODE3",	"F19");//발생일자
			ht1.put("CHECK_CODE4",	"F21");//만기일자
			ht1.put("CHECK_CODE5",	"A19");//프로젝트
			ht1.put("CHECK_CODE6",	"A05");//표준적요
			ht1.put("CHECK_CODE7",	"");
			ht1.put("CHECK_CODE8",	"");
			ht1.put("CHECK_CODE9",	"");
			ht1.put("CHECK_CODE10",	"");
			ht1.put("CHECKD_CODE1",	ven_code);//거래처
			ht1.put("CHECKD_CODE2",	"");//차입금관리번호
			ht1.put("CHECKD_CODE3",	"");//발생일자
			ht1.put("CHECKD_CODE4",	"");//만기일자
			ht1.put("CHECKD_CODE5",	"");//프로젝트
			ht1.put("CHECKD_CODE6",	"0");//표준적요
			ht1.put("CHECKD_CODE7",	"");
			ht1.put("CHECKD_CODE8",	"");
			ht1.put("CHECKD_CODE9",	"");
			ht1.put("CHECKD_CODE10","");
			ht1.put("CHECKD_NAME1",	ven_name);//거래처
			ht1.put("CHECKD_NAME2",	"");//차입금관리번호
			ht1.put("CHECKD_NAME3",	auto_dt);//발생일자
			ht1.put("CHECKD_NAME4",	"");//만기일자
			ht1.put("CHECKD_NAME5",	"0");//프로젝트
			ht1.put("CHECKD_NAME6",	" 장기차입금 유동성장기부채계정으로 대체");//표준적요
			ht1.put("CHECKD_NAME7",	"");
			ht1.put("CHECKD_NAME8",	"");
			ht1.put("CHECKD_NAME9",	"");
			ht1.put("CHECKD_NAME10","");
			ht1.put("INSERT_ID",	insert_id);
			
		//	if(car_no.equals("") && !lend_id.equals("")){
		//		ht1.put("CHECKD_NAME6",	lend_id+"-"+rtn_seq+" 장기차입금 유동성장기부채계정으로 대체");//표준적요
		//	}
			
			line++;
			
			//유동성장기부채
			Hashtable ht2 = new Hashtable();
			ht2.put("DATA_GUBUN", 	"53");
			ht2.put("WRITE_DATE", 	auto_dt);
			ht2.put("DATA_NO",    	"");
			ht2.put("DATA_LINE",  	String.valueOf(line));
			ht2.put("DATA_SLIP",  	"1");
			ht2.put("DEPT_CODE",  	"200");
			ht2.put("NODE_CODE",  	"S101");
			ht2.put("C_CODE",     	"1000");
			ht2.put("DATA_CODE",  	"");
			ht2.put("DOCU_STAT",  	"0");
			ht2.put("DOCU_TYPE",  	"11");
			ht2.put("DOCU_GUBUN", 	"3");
			ht2.put("AMT_GUBUN",  	"4");//대변
			ht2.put("DR_AMT",    	"0");
			ht2.put("CR_AMT",     	String.valueOf(l_amt13) );
			ht2.put("ACCT_CODE",  	"26400");
			ht2.put("CHECK_CODE1",	"A07");//거래처
			ht2.put("CHECK_CODE2",	"F19");//발생일자
			ht2.put("CHECK_CODE3",	"A19");//프로젝트
			ht2.put("CHECK_CODE4",	"A05");//표준적요
			ht2.put("CHECK_CODE5",	"");
			ht2.put("CHECK_CODE6",	"");
			ht2.put("CHECK_CODE7",	"");
			ht2.put("CHECK_CODE8",	"");
			ht2.put("CHECK_CODE9",	"");
			ht2.put("CHECK_CODE10",	"");
			ht2.put("CHECKD_CODE1",	ven_code);//거래처
			ht2.put("CHECKD_CODE2",	"");//발생일자
			ht2.put("CHECKD_CODE3",	"");//프로젝트
			ht2.put("CHECKD_CODE4",	"0");//표준적요
			ht2.put("CHECKD_CODE5",	"");
			ht2.put("CHECKD_CODE6",	"");
			ht2.put("CHECKD_CODE7",	"");
			ht2.put("CHECKD_CODE8",	"");
			ht2.put("CHECKD_CODE9",	"");
			ht2.put("CHECKD_CODE10","");
			ht2.put("CHECKD_NAME1",	ven_name);//거래처
			ht2.put("CHECKD_NAME2",	auto_dt);//발생일자
			ht2.put("CHECKD_NAME3",	"0");//프로젝트
			ht2.put("CHECKD_NAME4",	" 장기차입금 유동성장기부채계정으로 대체");//표준적요
			ht2.put("CHECKD_NAME5",	"");
			ht2.put("CHECKD_NAME6",	"");
			ht2.put("CHECKD_NAME7",	"");
			ht2.put("CHECKD_NAME8",	"");
			ht2.put("CHECKD_NAME9",	"");
			ht2.put("CHECKD_NAME10","");
			ht2.put("INSERT_ID",	insert_id);
			
		//	if(car_no.equals("") && !lend_id.equals("")){
		//		ht2.put("CHECKD_NAME4",	lend_id+"-"+rtn_seq+" 장기차입금 유동성장기부채계정으로 대체");//표준적요
		//	}
						
			vt.add(ht1);
			vt.add(ht2);
	//	}
//	}
	
	if(line > 0 && vt.size() > 0){
		String row_id = neoe_db.insertDebtSettleAutoDocu(auto_dt, vt);
		
		if(row_id.equals("")){
			count = 1;
		}
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
/*
	function go_step(){
		var fm = document.form1;
		fm.action = 'debt_pay_sc.jsp';
		fm.target = 'c_body';
		//fm.submit();
	}
*/	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<script language='javascript'>
<!--
	<%if(count==1){%>
	alert('에러가 발생했습니다.');
	<%}else{%>
	alert('자동전표를 발행했습니다.');
	<%}%>
//-->
</script>
</body>
</html>
