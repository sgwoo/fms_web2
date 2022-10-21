<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>

<%
	//excel ������ ���� ���
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	ExcelUpload file = new ExcelUpload(path, request.getInputStream());	
	
	
	String filename 	= file.getFilename();
	String car_mng_id 	= file.getParameter("car_mng_id")==null?"":file.getParameter("car_mng_id");
	String serv_id 		= file.getParameter("serv_id")==null?"":file.getParameter("serv_id");
	String user_id 		= file.getParameter("user_id")==null?"":file.getParameter("user_id");
	
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
	
	System.out.println("������ excel ��� 2010_autofor: car_mng_id=" + car_mng_id  + ":serv_id=" + serv_id + ":user_id=" + user_id);
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_start"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
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
		
		if(<%=sheet.getColumns()%> < 8){ alert('����Ÿ���� ���� �ʽ��ϴ�. Ȯ���Ͽ� �ֽʽÿ�.'); return;}
		if(fm.car_mng_id.value == ''){ 	alert('�ڵ����� ���õ��� �ʾҽ��ϴ�.'); return; }
		if(fm.serv_id.value == ''){ 	alert('�����ȣ�� �������� �ʾҽ��ϴ�.'); return; }
		
		if(!confirm("����Ͻðڽ��ϱ�?"))	return;
//		fm.action = 'excel_item_2010_autofor_a.jsp';
		fm.action = 'excel_item_2010_autofor_gtt.jsp';
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
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='row_size' value='<%=sheet.getRows()%>'>
<input type='hidden' name='col_size' value='<%=sheet.getColumns()%>'>
<input type='hidden' name='start_row' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="<%=70+(100*(sheet.getColumns()-1))+200%>">
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
          <td width="30" class="title">����</td>��
          <td width="40" class="title">������</td>
          <td width="100" class="title">(A)�ڵ�</td>		  
          <td width="200" class="title">(B)�۾�����</td>
          <td width="100" class="title">(C)�۾�</td>		  		  
          <td width="100" class="title">(D)����</td>		  
          <td width="100" class="title">(E)��ǰ��</td>
          <td width="100" class="title">(F)���Ӿ�</td>		  
          <td width="100" class="title">(G)�۾���</td>
          <td width="100" class="title">(H)����</td>
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
    	  <td width="30" class="title">����</td>
    	  <td width="40" class="title">������</td>	
    	  <td colspan='<%=sheet.getColumns()%>' class="title">���� ����Ÿ</td>
  		</tr>
<%
	int value_line = 0;
	int vt_size = vt.size();
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);
		//if(String.valueOf(content.get("0")).equals("") && String.valueOf(content.get("1")).equals("") && String.valueOf(content.get("2")).equals(""))  continue;
		int start_row = 2;%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=i+1%></td>
    	  <td width="40" align="center"><input name="ch_start" type="checkbox" class="style1" value="<%=i%>" <%if(i == 2){//start_row > 0 && i+1==start_row%>checked<%}%>></td>	
		  <% for(int j = 0; j < sheet.getColumns(); j++){%>
		  <%	if(j==1){%>
    	  <td width="200" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j))%>"size="30"></td>
		  <%	}else{%>
    	  <td width="100" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j))%>"size="13"></td>
		  <%	}%>		  
		  <% }%>
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