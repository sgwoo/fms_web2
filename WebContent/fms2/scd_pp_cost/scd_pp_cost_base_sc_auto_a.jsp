<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.debt.*, acar.bill_mng.*, acar.ext.*"%>
<%@ page import="acar.bank_mng.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	out.println("<<일괄결산전표처리>>"+"<br><br>");
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String auto_dt 	= request.getParameter("auto_dt")==null?"":request.getParameter("auto_dt");
	
	if(auto_dt.equals("")) auto_dt = "20191130";
	
	String size = request.getParameter("size")==null?"0":request.getParameter("size");
	
	String vid[] = request.getParameterValues("ch_l_cd");
	int vid_size = vid.length;
	out.println("* 선택건수="+vid_size+"<br><br>");
	
	String value[] = new String[10];
	
	String rent_mng_id  ="";
	String rent_l_cd	="";
	String rent_st		="";
	String client_id	="";
	String firm_nm		="";
	String ven_code		="";
	String car_no		="";
	String rest_amt		="";
	String ven_name		="";
	
	int flag = 0;
	int count =0;
	int line =0;
	
	//사용자정보-더존
	Hashtable per = neoe_db.getPerinfoDept(login.getAcarName(ck_acar_id));
	String insert_id = String.valueOf(per.get("SA_CODE"));
	
	
	Vector vt = new Vector();


	//[1단계] 
	
	for(int i=0; i < vid_size; i++){
		
		out.print("=============================================================");out.println("<br>");
		out.print(i+1+". ");
		
		
		StringTokenizer st = new StringTokenizer(vid[i],"/");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		rent_mng_id 	= value[0]==null?"":value[0];
		rent_l_cd		= value[1]==null?"":value[1];
		rent_st			= value[2]==null?"":value[2];
		client_id 		= value[3]==null?"":value[3];
		firm_nm			= value[4]==null?"":value[4];
		ven_code		= value[5]==null?"":value[5];
		car_no			= value[6]==null?"":value[6];
		rest_amt 		= value[7]==null?"":value[7];
		
		if(ven_code.equals("")){
			out.println("[거래처코드없음] ");
		}else{
			
			ven_name 	= neoe_db.getCodeByNm("ven", ven_code);
			
			line++;
			
			//선수금
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
			ht1.put("AMT_GUBUN",  	"4");//대변
			
			ht1.put("DR_AMT",    	rest_amt);
			ht1.put("CR_AMT",     	"0");
			ht1.put("ACCT_CODE",  	"25900");
			ht1.put("CHECK_CODE1",	"A06");//거래처
			ht1.put("CHECK_CODE2",	"B21");//발생일자
			ht1.put("CHECK_CODE3",	"");
			ht1.put("CHECK_CODE4",	"");
			ht1.put("CHECK_CODE5",	"");
			ht1.put("CHECK_CODE6",	"");
			ht1.put("CHECK_CODE7",	"");
			ht1.put("CHECK_CODE8",	"");
			ht1.put("CHECK_CODE9",	"");
			ht1.put("CHECK_CODE10",	"");
			ht1.put("CHECKD_CODE1",	ven_code);//거래처
			ht1.put("CHECKD_CODE2",	"");//발생일자
			ht1.put("CHECKD_CODE3",	"");
			ht1.put("CHECKD_CODE4",	"");
			ht1.put("CHECKD_CODE5",	"");
			ht1.put("CHECKD_CODE6",	"");
			ht1.put("CHECKD_CODE7",	"");
			ht1.put("CHECKD_CODE8",	"");
			ht1.put("CHECKD_CODE9",	"");
			ht1.put("CHECKD_CODE10","");
			ht1.put("CHECKD_NAME1",	"");//거래처
			ht1.put("CHECKD_NAME2",	"");//발생일자
			ht1.put("CHECKD_NAME3",	"");
			ht1.put("CHECKD_NAME4",	"");
			ht1.put("CHECKD_NAME5",	car_no+" 선납금균등발행분 외상매출금 선수금계정으로 대체");//표준적요
			ht1.put("CHECKD_NAME6",	"");
			ht1.put("CHECKD_NAME7",	"");
			ht1.put("CHECKD_NAME8",	"");
			ht1.put("CHECKD_NAME9",	"");
			ht1.put("CHECKD_NAME10","");
			ht1.put("INSERT_ID",	insert_id);
			
			line++;
			
			//외상매출금
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
			ht2.put("AMT_GUBUN",  	"3");//차변
			ht2.put("DR_AMT",    	"0");
			ht2.put("CR_AMT",     	rest_amt);
			ht2.put("ACCT_CODE",  	"10800");
			ht2.put("CHECK_CODE1",	"A06");//거래처
			ht2.put("CHECK_CODE2",	"A03");//부서
			ht2.put("CHECK_CODE3",	"A05");//프로젝트
			ht2.put("CHECK_CODE4",	"");//표준적요
			ht2.put("CHECK_CODE5",	"");
			ht2.put("CHECK_CODE6",	"");
			ht2.put("CHECK_CODE7",	"");
			ht2.put("CHECK_CODE8",	"");
			ht2.put("CHECK_CODE9",	"");
			ht2.put("CHECK_CODE10",	"");
			ht2.put("CHECKD_CODE1",	ven_code);//거래처
			ht2.put("CHECKD_CODE2",	"");//발생일자
			ht2.put("CHECKD_CODE3",	"");//프로젝트
			ht2.put("CHECKD_CODE4",	"");//표준적요
			ht2.put("CHECKD_CODE5",	"");
			ht2.put("CHECKD_CODE6",	"");
			ht2.put("CHECKD_CODE7",	"");
			ht2.put("CHECKD_CODE8",	"");
			ht2.put("CHECKD_CODE9",	"");
			ht2.put("CHECKD_CODE10","");
			ht2.put("CHECKD_NAME1",	"");//거래처
			ht2.put("CHECKD_NAME2",	"");//발생일자
			ht2.put("CHECKD_NAME3",	"");//프로젝트
			ht2.put("CHECKD_NAME4",	"");
			ht2.put("CHECKD_NAME5",	car_no+" 선납금균등발행분 외상매출금 선수금계정으로 대체");//표준적요
			ht2.put("CHECKD_NAME6",	"");
			ht2.put("CHECKD_NAME7",	"");
			ht2.put("CHECKD_NAME8",	"");
			ht2.put("CHECKD_NAME9",	"");
			ht2.put("CHECKD_NAME10","");
			ht2.put("INSERT_ID",	insert_id);
						
			vt.add(ht1);
			vt.add(ht2);
		}
	}
	
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