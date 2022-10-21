<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	
	//excel ������ ���� ���
	String path = request.getRealPath("/file/pay/");
	Vector vt = new Vector();
	
	ExcelUpload file = new ExcelUpload(path, request.getInputStream());	
	String filename = file.getFilename();
	
	FileInputStream fi = new FileInputStream(new File(path+""+filename+".xls"));

	Workbook workbook = Workbook.getWorkbook(fi);
	
	//������ ù��° sheet ������ �´�. 
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
	
	
	//��ǥ�����Ѵ�.
	int vt_size = vt.size();
	
	out.println("vt_size="+vt_size);
	out.println("<br>");
				
	//vt_size = 10;
	
	
	
	
	//���������-����
	Hashtable per = neoe_db.getPerinfoDept(login.getAcarName(nm_db.getWorkAuthUser("���ݰ�꼭�����")));
	String insert_id = String.valueOf(per.get("SA_CODE"));	
	
	for (int i = 6 ; i < vt_size ; i++){
		
		//��ǥ��
		Vector a_vt = new Vector();
		int a_vt_size = 0;

		
		Hashtable content = (Hashtable)vt.elementAt(i);
		
		String WRITE_DATE = content.get(Integer.toString(0))+"";
		
		String VEN_CODE = content.get(Integer.toString(4))+""; //�ŷ�ó
		String TP_TAX = "26"; //��������(�鼼��꼭)
		String DT_START = AddUtil.replace(content.get(Integer.toString(0))+"","-",""); //�߻�����
		String AM_TAXSTD = AddUtil.parseDigit3(content.get(Integer.toString(15))+""); //����ǥ�ؾ�
		String NO_COMPANY = AddUtil.replace(content.get(Integer.toString(4))+"","-",""); //����ڵ�Ϲ�ȣ
		String CD_BIZAREA = "S101"; //�ͼӻ����
		String NM_NOTE = content.get(Integer.toString(25))+""; //����
		
		//CHECKD_CODE1 �ŷ�ó����
		VEN_CODE = "996204"; //�Ե����丮��[�����]
		/*		
		TradeBean[] vens = neoe_db.getBaseTradeList("", CHECKD_CODE5); 
		int ven_size = vens.length;
		
		if(ven_size == 1){
			TradeBean ven = vens[0];
			VEN_CODE = ven.getCust_code()+"";
		}
		*/
		
		//���� �ΰ�����ޱ� 13500
		Hashtable ht1 = new Hashtable();
		ht1.put("DEPT_CODE",  	"200");
		ht1.put("INSERT_ID",	insert_id);
		ht1.put("WRITE_DATE", 	WRITE_DATE);
		ht1.put("AMT_GUBUN",  	"3");//����
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
	
	out.println("��ǥ����Ǿ����ϴ�.");
	
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