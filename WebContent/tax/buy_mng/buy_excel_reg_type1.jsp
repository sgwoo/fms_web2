<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//excel 파일의 절대 경로
	String path = request.getRealPath("/file/pay/");
	Vector vt = new Vector();
	
	ExcelUpload file = new ExcelUpload(path, request.getInputStream());	
	String filename = file.getFilename();
	
	FileInputStream fi = new FileInputStream(new File(path+""+filename+".xls"));

	Workbook workbook = Workbook.getWorkbook(fi);
	
	//엑셀의 첫번째 sheet 가지고 온다. 
	Sheet sheet = workbook.getSheet(0);
	
	for(int i = 0; i < sheet.getRows(); i++){
	
		Hashtable ht = new Hashtable();
		
		for(int j = 0; j < sheet.getColumns(); j++){
			
			Cell cell = sheet.getCell(j,i);
			
			ht.put(Integer.toString(j), cell.getContents());
			
		}
		vt.add(ht);
	}
	
	String doc_dt 	= file.getParameter("doc_dt")==null?"":AddUtil.replace(file.getParameter("doc_dt"),"-","");

	out.println("doc_dt="+doc_dt);
	out.println("<br>");
	
	
	//전표생성한다.
	int vt_size = vt.size();
	
	out.println("vt_size="+vt_size);
	out.println("<br>");
				
	//vt_size = 10;
	
	
	
	
	//사용자정보-더존
	Hashtable per = neoe_db.getPerinfoDept(login.getAcarName(nm_db.getWorkAuthUser("세금계산서담당자")));
	String insert_id = String.valueOf(per.get("SA_CODE"));	
	
	for (int i = 6 ; i < vt_size ; i++){
		
		//전표용
		Vector a_vt = new Vector();
		int a_vt_size = 0;

		
		Hashtable content = (Hashtable)vt.elementAt(i);
		
		String WRITE_DATE = content.get(Integer.toString(0))+"";
		
		String VEN_CODE = content.get(Integer.toString(4))+""; //거래처
		String TP_TAX = "26"; //세무구분(면세계산서)
		String DT_START = AddUtil.replace(content.get(Integer.toString(0))+"","-",""); //발생일자
		String AM_TAXSTD = AddUtil.parseDigit3(content.get(Integer.toString(15))+""); //과세표준액
		String NO_COMPANY = AddUtil.replace(content.get(Integer.toString(4))+"","-",""); //사업자등록번호
		String CD_BIZAREA = "S101"; //귀속사업장
		String NM_NOTE = content.get(Integer.toString(25))+""; //적요
		
		//CHECKD_CODE1 거래처고정
		VEN_CODE = "996204"; //롯데오토리스[대출금]
		/*		
		TradeBean[] vens = neoe_db.getBaseTradeList("", CHECKD_CODE5); 
		int ven_size = vens.length;
		
		if(ven_size == 1){
			TradeBean ven = vens[0];
			VEN_CODE = ven.getCust_code()+"";
		}
		*/
		
		//차변 부가세대급금 13500
		Hashtable ht1 = new Hashtable();
		ht1.put("DEPT_CODE",  	"200");
		ht1.put("INSERT_ID",	insert_id);
		ht1.put("WRITE_DATE", 	WRITE_DATE);
		ht1.put("AMT_GUBUN",  	"3");//차변
		ht1.put("ACCT_CODE",  	"13500");
		ht1.put("VEN_CODE",	    VEN_CODE);
		ht1.put("TP_TAX",	    TP_TAX);
		ht1.put("DT_START",	    DT_START);
		ht1.put("AM_TAXSTD",	AM_TAXSTD);
		ht1.put("NO_COMPANY",	NO_COMPANY);
		ht1.put("CD_BIZAREA",	CD_BIZAREA);
		ht1.put("NM_NOTE",	    NM_NOTE);
				
		a_vt.add(ht1);
		
		out.println(" i="+i);
		out.println(" WRITE_DATE="+WRITE_DATE);
		out.println(" VEN_CODE="+VEN_CODE);
		out.println(" TP_TAX="+TP_TAX);
		out.println(" DT_START="+DT_START);
		out.println(" AM_TAXSTD="+AM_TAXSTD);
		out.println(" NO_COMPANY="+NO_COMPANY);
		out.println(" CD_BIZAREA="+CD_BIZAREA);
		out.println(" NM_NOTE="+NM_NOTE);
		out.println("<br>");
		
		if(!WRITE_DATE.equals("")){
			String row_id = neoe_db.insertBuyTaxAutoDocu(WRITE_DATE, a_vt);
		}
				
	}
	
	out.println("전표발행되었습니다.");
	
	if(1==1)return;
	
	
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/table.css">
<script language="JavaScript" src="/acar/include/info.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<SCRIPT LANGUAGE="JavaScript">
<!--

//-->
</SCRIPT>
<style type="text/css">
<!--
.style1 {color: #999999}
-->
</style>
</HEAD>
<BODY>
<p>
</p>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>