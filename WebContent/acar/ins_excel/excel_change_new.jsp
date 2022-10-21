<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//excel ������ ���� ���
	String path = request.getRealPath("/file/insur/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
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
	
	
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function checkNaN(num)
{
	if(isNaN(num))
		return 0;
	else
		return num;
}
	function toInt(str)
	{
		var num = parseInt(str, 10);
		return checkNaN(num);
	}

	//����ϱ�
	function save(){
		fm = document.form1;
		
		var b_size = 56;
		var r_size = <%=sheet.getColumns()%>;	
		if('<%=ck_acar_id%>' != '000029' && (b_size > r_size || b_size < r_size)){
			alert('��������Ÿ�� ������ϰ� Ʋ���ϴ�.\n\nȮ���Ͻʽÿ�.');
			return;
		}		
		
		var row_size = toInt(fm.value_line.value);		
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
		
		if(row_size > 100){			alert('100���� �ʰ��մϴ�. ������ ������ �ϼž� �մϴ�.'); return; }
		
		
		if(!confirm("����Ͻðڽ��ϱ�?"))	return;
		
		fm.action = 'excel_change_new_a.jsp';											
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
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<table border="0" cellspacing="0" cellpadding="0" width="<%=70+(120*sheet.getColumns())+60%>">
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
          <td width="30" class="title">����</td>
          <td width="40" class="title">������</td>
          <td width="150" class="title">1.���ǹ�ȣ</td>
          <td width="150" class="title">2.�輭��ȣ</td>
          <td width="120" class="title">3.�ǰ����ڸ�</td>
          <td width="120" class="title">4.����ڸ�</td>
          <td width="120" class="title">5.�����ָ�</td>
          <td width="120" class="title">6.���Խ�������ȣ</td>
          <td width="120" class="title">7.������ȣ</td>
          <td width="120" class="title">8.����</td>
          <td width="120" class="title">9.����</td>
          <td width="120" class="title">10.�����Ⱓ</td>
          <td width="120" class="title">11.���Թ��</td>
          <td width="120" class="title">12.�г�ȸ��</td> 
          <td width="120" class="title">13.�輭�ڵ�</td> 
          <td width="150" class="title">14.�輭�׸��</td>
          <td width="150" class="title">15.������</td>
          <td width="150" class="title">16.������</td>
          <td width="150" class="title">17.���Դ㺸</td>
          <td width="150" class="title">18.���ο�</td>
          <td width="150" class="title">19.������</td>
          <td width="150" class="title">20.�빰���</td>
          <td width="150" class="title">21.�ڼ�</td>
          <td width="150" class="title">22.������</td>
          <td width="150" class="title">23.����</td>
          <td width="150" class="title">24.�뿩�ڵ�������</td>
          <td width="150" class="title">25.�ڻ�</td>
          <td width="150" class="title">26.����</td>
          <td width="150" class="title">27.�޾�����</td>
          <td width="150" class="title">28.�д����������</td>
          <td width="150" class="title">29.����������</td>
          <td width="150" class="title">30.��⿩��</td>
          <td width="150" class="title">31.����</td>
          <td width="150" class="title">32.���������</td>
          <td width="150" class="title">33.���������ݾ�</td>
          <td width="150" class="title">34.��������</td>
          <td width="150" class="title">35.���Ա���</td>
          <td width="150" class="title">36.�ű԰���</td>
          <td width="150" class="title">37.��������</td>
          <td width="150" class="title">38.�輭������</td>
          <td width="150" class="title">39.�㺸�������</td>
          <td width="150" class="title">40.���ο�</td>
          <td width="150" class="title">41.������</td>
          <td width="150" class="title">42.�빰���</td>
          <td width="150" class="title">43.�ڼ�</td>
          <td width="150" class="title">44.������</td>
          <td width="150" class="title">45.����</td>
          <td width="150" class="title">46.�뿩�ڵ�������</td>
          <td width="150" class="title">47.�ڻ�</td>
          <td width="150" class="title">48.����</td>
          <td width="150" class="title">49.�޾�����</td>
          <td width="150" class="title">50.�д����������</td>
          <td width="150" class="title">51.����������</td>
          <td width="150" class="title">52.�����ڸ�</td>
          <td width="150" class="title">53.�����ڼ���</td>
          <td width="150" class="title">54.�����ȣ</td>
          <td width="150" class="title">55.�����������ñ�</td>
          <td width="150" class="title">56.��������������</td>
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
		if(String.valueOf(content.get("0")).equals("") && String.valueOf(content.get("1")).equals("") && String.valueOf(content.get("2")).equals(""))  continue;%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=value_line+1%></td>
    	  <td width="40" align="center"><input name="ch_start" type="checkbox" class="style1" value="<%=value_line%>"></td>	
		  <% for(int j = 0; j < sheet.getColumns(); j++){%>
		  <%	if(j==0 || j==1){%>
    	  <td width="150" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j))%>"size="18"></td>
		  <%	}else{%>
    	  <td width="120" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j))%>"size="13"></td>
		  <%	}%>		  
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
<SCRIPT LANGUAGE="JavaScript">
<!--
//-->
</SCRIPT>
</BODY>
</HTML>