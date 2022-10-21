<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*, acar.insur.*"%>

<%
	//excel ������ ���� ���
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	ExcelUpload file = new ExcelUpload(path , request.getInputStream());
	
	String pay_dt = file.getParameter("pay_dt")==null?"":file.getParameter("pay_dt");//����-��������
	String est_dt = file.getParameter("est_dt")==null?"":file.getParameter("est_dt");//����-��������
	
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
	
	int value_line = 0;
	int vt_size = vt.size();
	int value_cnt = 0;
	
	String result[]  = new String[vt_size];
	String value1[]  = new String[vt_size];
	String value2[]  = new String[vt_size];
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	
	
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);
		
		int flag 			= 0;
		
		if(String.valueOf(content.get("0")).equals("") && String.valueOf(content.get("1")).equals("")){
			value1[i] 	= String.valueOf(content.get("0")); //�ݾ�
			value2[i] 	= String.valueOf(content.get("1")); //���ǹ�ȣ
			result[i]   = "���� ������";			
		}else{
		
			value1[i] 	= String.valueOf(content.get("0")); //�ݾ�
			value2[i] 	= String.valueOf(content.get("1")); //���ǹ�ȣ
			
			int ins_amt 		= value1[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(value1[i]," ",""),"_",""));
			String ins_con_no 	= value2[i] ==null?"":                   AddUtil.replace(AddUtil.replace(value2[i]," ",""),"_","");
			
			//���� ��ȸ-------------------------------------------------
			InsurScdBean scd = ai_db.getInsExcelScdCase(ins_con_no, est_dt, ins_amt);
			
			if(scd.getCar_mng_id().equals("")){
				result[i]   = "�̹� ����ó���Ǿ��ų�, �������� �� ã�ҽ��ϴ�.";		
			}else{
				if(!ai_db.updateInsScdExcelPay(scd.getCar_mng_id(), scd.getIns_st(), scd.getIns_tm(), pay_dt)) flag += 1;
				if(flag != 0)	result[i] = "���� ����ó���� ���� �߻�";
				else			result[i] = "���� ����ó���Ǿ����ϴ�.";
			}			
		}		
	}
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/info.js"></script>
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
<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr>
    <td>&lt; ���� ���� ���� ó�� ��� &gt; </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="30" class="title">����</td>
    	  <td width="100" class="title">�ݾ�</td>
    	  <td width="100" class="title">���ǹ�ȣ</td>    	  
    	  <td class="title">ó�����</td>
        </tr>
<%	for (int i = 0 ; i < vt_size ; i++){%>		
        <tr>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=value1[i]%></td>
          <td align="center"><%=value2[i]%></td>
          <td>&nbsp;<%=result[i]%></td>		  
        </tr>
<%	}%>		
	  </table>
	</td>
  </tr>  
  <tr>
    <td align="center">&nbsp;</td>
  </tr>  
  <tr>  
    <td align="center"><a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
  </tr>
</table>
</BODY>
</HTML>