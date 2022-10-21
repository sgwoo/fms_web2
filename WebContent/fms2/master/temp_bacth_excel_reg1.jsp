<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.debt.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>

<%
	//excel ������ ���� ���
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	ExcelUpload file = new ExcelUpload(path , request.getInputStream());
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
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/table.css">
<script language="JavaScript" src="/acar/include/info.js"></script>
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
<form action="" method='post' name="form1">
<table border="0" cellspacing="0" cellpadding="0" width="<%=100+(300*sheet.getColumns())%>">
  <tr>
    <td>&lt; ���� ���� �б� &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>   
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">  
        <tr>
    	  <td width="100" class="title">����</td>
    	  <td colspan='<%=sheet.getColumns()%>' class="title">���� ����Ÿ</td>
  		</tr>
        <tr>
    	  <td class="title">-</td>
    	  <%for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td class="title"><%=j %></td>
    	  <%}%>
  		</tr>  		
<%
	int vt_size = vt.size();	
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);
		
		int debt_size = 0;
		int last_rest = 0;
		int last_prn = 0;
		String cnk1 = "";
		String cnk2 = "";
		int u_idx1 = 5;
		int u_idx2 = 6;
		int u_idx3 = 7;
		if(i>1){
			//�����ȣ�� �Һα���ȸ
			Vector debts = d_db.getDebtScdBacth(String.valueOf(content.get("1")));
			debt_size = debts.size();	
			if(debt_size>0){
				last_rest = 4*debt_size+3; 		
				last_prn = last_rest-1;
				cnk1 = last_rest+"/"+last_prn;
				//������ȸ�� ��ȸ������=0, ������ȸ�� ����>0 �̸� �����̴�
				if(Util.parseDigit(String.valueOf(content.get(Integer.toString(last_rest))))==0 && Util.parseDigit(String.valueOf(content.get(Integer.toString(last_prn))))>0){
					cnk1 = "����";
					for(int k = 0 ; k < debt_size ; k++){
						int flag = 0;
						DebtScdBean a_debt = (DebtScdBean)debts.elementAt(k);
						//�������ݾ�(DB�Һν�����)
						int a_alt_int 	= a_debt.getAlt_int();
						int a_alt_prn 	= a_debt.getAlt_prn();
						int a_alt_rest 	= a_debt.getAlt_rest();
						//�����ıݾ�(��������)
						//1ȸ�� 5,6,7
						//2ȸ�� 9,10,11
                        //.....						
						int b_alt_int 	= Util.parseDigit(String.valueOf(content.get(Integer.toString(u_idx1))));
						int b_alt_prn 	= Util.parseDigit(String.valueOf(content.get(Integer.toString(u_idx2))));
						int b_alt_rest 	= Util.parseDigit(String.valueOf(content.get(Integer.toString(u_idx3))));
						//���Աݺи� ����
						if(a_debt.getPay_dt().equals("") && a_alt_prn >0 && a_alt_prn != b_alt_prn){
							cnk2 = u_idx3+"";
							a_debt.setAlt_int (b_alt_int);
							a_debt.setAlt_prn (b_alt_prn);
							a_debt.setAlt_rest(b_alt_rest);	
							if(!d_db.updateDebtScd(a_debt))	flag += 1;
						}
						u_idx1 = u_idx1+4;
						u_idx2 = u_idx2+4;
						u_idx3 = u_idx3+4;
					}
				}
			}
		}
%>  
        <tr>
    	  <td class="title"><%=i%>/<%=debt_size%>/<%=cnk1%><%=cnk2%></td>
		  <%for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td width="300" align="center"><%=content.get(Integer.toString(j))%><%if(j==last_rest){%>/������ȸ���ܾ�<%}%><%if(j==last_prn){%>/������ȸ������<%}%></td>
		  <%}%>
  		</tr>
<%	}%>
	  </table>
	</td>
  </tr>  
</table>
</form>
</BODY>
</HTML>