<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>

<%
	//excel ������ ���� ���
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
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
	
	int value_line = 0;
	int vt_size = vt.size();
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
		
		var row_size = <%=sheet.getRows()%>;
		var cnt=0;
		var idnum="";
		
		for(var i=0 ; i<row_size ; i++){
			if(fm.ch_start[i].checked == true){
				cnt++;
				idnum=fm.ch_start[i].value;
			}
		}	
		if(cnt == 0){
		 	alert("�������� �����ϼ���.");
			return;
		}	
		if(cnt > 1){
		 	alert("�ϳ��� �����ุ �����ϼ���.");
			return;
		}		
			
		fm.start_row.value = idnum;
		
		if(!confirm("����Ͻðڽ��ϱ�?"))	return;
		
		fm.action = 'lc_rent_excel_var2_a.jsp';		
		
		fm.submit();
	}
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
<input type='hidden' name='row_size' value='<%=sheet.getRows()%>'>
<input type='hidden' name='col_size' value='<%=sheet.getColumns()%>'>
<input type='hidden' name='start_row' value=''>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width="<%=40+(120*sheet.getColumns())%>">
  <tr>
    <td>&lt; ���� ���� �б� &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td align="center"><span class="style1">- ����� - </span></td>
  </tr>      
  <tr>
    <td class="line">
      <table border="0" cellspacing="1" cellpadding="0">
        <tr>
                    <td width="40" class="title">������</td>
                    <td width='120' class='title'>0 ����</td>
                    <td width='120' class='title'>1 ����</td>
                    <td width="120" class='title'>2 Ư�ǰ���ȣ</td>                    
                    <td width='120' class='title'>3 �������</td>
                    <td width="120" class='title'>4 ��������</td>        	    
                    <td width="120" class='title'>5 ��������</td>       		
                    <td width="120" class='title'>6 ����������</td>       		
        	          <td width="120" class='title'>7 ���汸��</td>
                    <td width='120' class='title'>8 ������</td>
                    <td width='120' class='title'>9 ó������</td>     
                    <td width='120' class='title'>10 ������</td>                    
                    <td width='120' class='title'>11 ������</td>                   
                    <td width='120' class='title'>12 ����</td>                    
        	    <td width="120" class='title'>13 ���û��</td>
        	    <td width="120" class='title'>14 ����</td>		  
        	    <td width='120' class='title'>15 �μ���</td>
        	    <td width='120' class='title'>16 ��������</td>
        	    <td width='120' class='title'>17 ��������</td>
        	    <td width='120' class='title'>18 DC�ݾ�</td> 
        	    <td width="120" class="title">19 �߰�D/C</td>       	    
        	    <td width='120' class='title'>20 Ź�۷�</td>        	    
        	    <td width='120' class='title'>21 �����ݾ�</td>        	            	            	            	    
        	    <td width='120' class='title'>22 �����</td>
        	    <td width='120' class='title'>23 ���ʿ�����</td>        	
        </tr>
      </table></td>
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
    	  <!--<td width="30" class="title">����</td>-->
    	  <td width="40" class="title">������</td>	
    	  <td colspan='<%=sheet.getColumns()%>' class="title">���� ����Ÿ</td>
  		</tr>
<%
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);%>  
        <tr>
    	  <!--<td width="30" height="30" class="title"><%=i+1%></td>-->
    	  <td width="40" align="center"><input name="ch_start" type="checkbox" value="<%=i%>"></td>	
	  <% for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td width="120" align="center"><input name="value<%=j%>" type="text" class=text value="<%=content.get(String.valueOf(j))%>"size="13"></td>
	  <%	}%>
  	</tr>
<%		value_line++;
	}%>
	  </table>
	</td>
  </tr>  
  <tr>
    <td>* �������� �����Ͻʽÿ�</td>
  </tr>  
  <tr>  
    <td align="center"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
<input type='hidden' name='value_line' value='<%=value_line%>'>   
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>