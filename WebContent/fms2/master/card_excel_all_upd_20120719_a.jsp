<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.bill_mng.*"%>
<%@ page import="card.*" %>
<%@ include file="/acar/cookies.jsp"%>


<%
	int row_size 		= request.getParameter("row_size")	==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size 		= request.getParameter("col_size")	==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row 		= request.getParameter("start_row")	==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line 		= request.getParameter("value_line")	==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	
	
	String result[]  = new String[value_line+10];
	String value0[]  = request.getParameterValues("value0");//연번
	String value1[]  = request.getParameterValues("value1");//거래처코드
	String value2[]  = request.getParameterValues("value2");//거래처명
	String value3[]  = request.getParameterValues("value3");//이용금액
	String value4[]  = request.getParameterValues("value4");
	String value5[]  = request.getParameterValues("value5");
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	
	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();

	
	
	//자동전표처리용
	Vector vt = new Vector();
	int line = 0;
	int total_amt =0;
	String acct_cont = "";
	String acct_code = "25300"; //미지급금
			
	
	Hashtable per = neoe_db.getPerinfoDept("송인숙");
	
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));

							
	for(int i=start_row ; i <= value_line ; i++){
				
		String ven_code	= value1[i]  ==null?"":value1[i];
		String ven_name	= value2[i]  ==null?"":value2[i];		
		int    buy_amt	= value3[i]  ==null?0:AddUtil.parseDigit(value3[i]);
		
		total_amt = total_amt + buy_amt;
				
		acct_cont = "카드전표 미지급금 거래처 오류분 정정 : "+ven_name+ " -> 삼성카드사";
							
		line++;		
		
		//미지급금-비용거래처
		Hashtable ht1 = new Hashtable();
		ht1.put("DATA_GUBUN", 	"53");
		ht1.put("WRITE_DATE", 	AddUtil.getDate());
		ht1.put("DATA_NO",    	"");
		ht1.put("DATA_LINE",  	String.valueOf(line));
		ht1.put("DATA_SLIP",  	"1");
		ht1.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
		ht1.put("NODE_CODE",  	"S101");
		ht1.put("C_CODE",     	"1000");
		ht1.put("DATA_CODE",  	"");
		ht1.put("DOCU_STAT",  	"0");
		ht1.put("DOCU_TYPE",  	"11");
		ht1.put("DOCU_GUBUN", 	"3");
		ht1.put("AMT_GUBUN",  	"3");//차변
		ht1.put("DR_AMT",    	buy_amt);
		ht1.put("CR_AMT",     	"0");
		ht1.put("ACCT_CODE",  	acct_code);
		ht1.put("CHECK_CODE1",	"A07");//거래처
		ht1.put("CHECK_CODE2",	"A19");//전표번호
		ht1.put("CHECK_CODE3",	"F47");//신용카드번호
		ht1.put("CHECK_CODE4",	"A13");//project
		ht1.put("CHECK_CODE5",	"A05");//표준적요
		ht1.put("CHECK_CODE6",	"");
		ht1.put("CHECK_CODE7",	"");
		ht1.put("CHECK_CODE8",	"");
		ht1.put("CHECK_CODE9",	"");
		ht1.put("CHECK_CODE10",	"");
		ht1.put("CHECKD_CODE1",	ven_code);//거래처
		ht1.put("CHECKD_CODE2",	"");//전표번호
		ht1.put("CHECKD_CODE3",	"");//신용카드번호
		ht1.put("CHECKD_CODE4",	"");//project
		ht1.put("CHECKD_CODE5",	"0");//표준적요
		ht1.put("CHECKD_CODE6",	"");
		ht1.put("CHECKD_CODE7",	"");
		ht1.put("CHECKD_CODE8",	"");
		ht1.put("CHECKD_CODE9",	"");
		ht1.put("CHECKD_CODE10","");
		ht1.put("CHECKD_NAME1",	ven_name);//거래처
		ht1.put("CHECKD_NAME2",	"");//전표번호
		ht1.put("CHECKD_NAME3",	"");//신용카드번호
		ht1.put("CHECKD_NAME4",	"");//project
		ht1.put("CHECKD_NAME5",	acct_cont);//표준적요
		ht1.put("CHECKD_NAME6",	"");
		ht1.put("CHECKD_NAME7",	"");
		ht1.put("CHECKD_NAME8",	"");
		ht1.put("CHECKD_NAME9",	"");
		ht1.put("CHECKD_NAME10","");

		ht1.put("INSERT_ID",	insert_id);
			

		vt.add(ht1);

								
	}
	
	
		line++;
			
		//미지급금-삼성카드사
		Hashtable ht2 = new Hashtable();
		ht2.put("DATA_GUBUN", 	"53");
		ht2.put("WRITE_DATE", 	AddUtil.getDate());
		ht2.put("DATA_NO",    	"");
		ht2.put("DATA_LINE",  	String.valueOf(line));
		ht2.put("DATA_SLIP",  	"1");
		ht2.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
		ht2.put("NODE_CODE",  	"S101");
		ht2.put("C_CODE",     	"1000");
		ht2.put("DATA_CODE",  	"");
		ht2.put("DOCU_STAT",  	"0");
		ht2.put("DOCU_TYPE",  	"11");
		ht2.put("DOCU_GUBUN", 	"3");
		ht2.put("AMT_GUBUN",  	"4");//대변
		ht2.put("DR_AMT",    	"0");
		ht2.put("CR_AMT",     	total_amt);
		ht2.put("ACCT_CODE",  	"25300");
		ht2.put("CHECK_CODE1",	"A07");//거래처
		ht2.put("CHECK_CODE2",	"A19");//전표번호
		ht2.put("CHECK_CODE3",	"F47");//신용카드번호
		ht2.put("CHECK_CODE4",	"A13");//project
		ht2.put("CHECK_CODE5",	"A05");//표준적요
		ht2.put("CHECK_CODE6",	"");
		ht2.put("CHECK_CODE7",	"");
		ht2.put("CHECK_CODE8",	"");
		ht2.put("CHECK_CODE9",	"");
		ht2.put("CHECK_CODE10",	"");
		ht2.put("CHECKD_CODE1",	"900142");//거래처
		ht2.put("CHECKD_CODE2",	"");//전표번호
		ht2.put("CHECKD_CODE3",	"");//신용카드번호
		ht2.put("CHECKD_CODE4",	"");//project
		ht2.put("CHECKD_CODE5",	"0");//표준적요
		ht2.put("CHECKD_CODE6",	"");
		ht2.put("CHECKD_CODE7",	"");
		ht2.put("CHECKD_CODE8",	"");
		ht2.put("CHECKD_CODE9",	"");
		ht2.put("CHECKD_CODE10","");
		ht2.put("CHECKD_NAME1",	"삼성카드사");//거래처
		ht2.put("CHECKD_NAME2",	"");//전표번호
		ht2.put("CHECKD_NAME3",	"");//신용카드번호
		ht2.put("CHECKD_NAME4",	"");//project
		ht2.put("CHECKD_NAME5",	"카드전표 미지급금 거래처 오류분 정정 "+(line-1)+"건");//표준적요
		ht2.put("CHECKD_NAME6",	"");
		ht2.put("CHECKD_NAME7",	"");
		ht2.put("CHECKD_NAME8",	"");
		ht2.put("CHECKD_NAME9",	"");
		ht2.put("CHECKD_NAME10","");
		ht2.put("INSERT_ID",	insert_id);
		vt.add(ht2);				
				
	
	int vt_size = vt.size();
	
	if(vt_size>0){
	
		String row_id = neoe_db.insertDebtSettleAutoDocu(AddUtil.getDate(), vt);	//-> neoe_db 변환
	}
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 보험 등록하기
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
//-->
</SCRIPT>
</BODY>
</HTML>