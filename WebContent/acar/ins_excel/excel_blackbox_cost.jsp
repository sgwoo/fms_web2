<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.insur.*"%>
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

%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/info.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<!-- <link rel=stylesheet type="text/css" href="../../include/table.css"> -->
<script>
/* $(function() {
    $('.load_more').live("click",function() {    
      var last_msg_id = $(this).attr("id");      // ���� ����Ʈ�� �������� ��ȣ�� �����´�. �������� ��ȣ�� �Ʒ� ������ ��ư�� id����
	  $.ajax({
	        type: "POST",
	        url: "testList_ajax.jsp",      // ������ �������� �����͸���Ʈ�� html ���·� ���� ���� ����Ʈ�������� �����ش�.
	        data: "lastmsg="+ last_msg_id, // ���� ����Ʈ�� �ѷ����ִ� ������ �� ��ȣ�� �־��ش�. �׷����� ����Ʈ�� �������� ���������� ����Ʈ�� �����´�.
	        beforeSend:  function() {
	        $('a.load_more').append('<img src="../img/facebook_style_loader.gif" />');    // �ε� �������϶� .gif�� �ε����̶�°� ǥ��                  
	    },
	    success: function(html){            // testList_ajax.jsp �� ������ �����ϸ� ajax ���������� ������ ����Ʈ��� �����ͼ�
	        $(".facebook_style").remove();  // Show Older Posts�� ��ư�� �����ϰ� 
	        $("ol#updates").append(html);   // �߰��θ��� ����Ʈ��ϰ� Show Older Posts�� ��ư�� �ٿ� �ִ´�.
	    }
	});
    return false;
    });
}); */

</script>
<SCRIPT LANGUAGE="JavaScript">
function checkNaN(num)
{
	if(isNaN(num))
		return 0;
	else
		return num;
}
	function toInt(str)
	{
		var num = parseInt(str, 26);
		return checkNaN(num);
	}

	//����ϱ�
	function save(){
		fm = document.form1;
		
		
		var b_size = 26;
		var r_size = <%=sheet.getColumns()%>;	
		if(b_size > r_size){
			alert('��������Ÿ�� ������ϰ� Ʋ���ϴ�.\n\nȮ���Ͻʽÿ�.');
			return;
		}		
		var row_size = Number(fm.value_line.value);		
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<row_size ; i++){
			if(fm.ch_start[i].checked){
				 cnt++;
				idnum=fm.ch_start[i].value; 
			} 
		}	
		if(fm.ch_dt.value.length != 10){
			alert("�輭������ ������ 2019-05-10 ó�� �Է����ּ���");
			return;
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
		
		fm.action = "excel_blackbox_cost_a.jsp";
		fm.submit();
	}
</SCRIPT>
<style type="text/css">
.style1 {color: #999999; }
input.text{border:0px;text-align:center;}
.title{}
</style>
</HEAD>
<BODY>
<p>
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='row_size' value='<%=sheet.getRows()%>'>
<input type='hidden' name='col_size' value='<%=sheet.getColumns()%>'>
<input type='hidden' name='start_row' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="<%=(120*sheet.getColumns())%>">
  <tr>
    <td>&lt; ���� ���� �б� &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
	<tr>
		<td>������ ����� ��� ���躯����׿� �ߺ��� ���� ��� ����, ������ ������ �ǵ��� �������� �����ϰ� ������ֽñ� �ٶ��ϴ�.</td>
	</tr>	
	<tr>
		<td></td>
	</tr>	
	<tr>
		<td>�輭 ������ : <input type="text" name="ch_dt" value='' onBlur='javascript:this.value=ChangeDate(this.value)' size="12"> * �ݵ�� �Է����ּ���  </td> 
 	</tr>
 	<tr>	
		<td></td>
 	</tr>
  <tr>
    <td class="line">
	<table border="0" cellspacing="1" cellpadding="0">  
		<tr style="height:30px;">
    	  <td class="title">����</td>
          <td class="title">������</td>
          <td class="title">No</td>
          <td class="title">��������</td>
          <td class="title">����</td>
          <td class="title">����ڹ�ȣ</td>
          <td class="title">������ȣ</td>
          <td class="title">�����ȣ</td>
          <td class="title">����</td>
          <td class="title">���ʵ����</td>
          <td class="title">��ϻ���</td>
          <td class="title">�㺸����</td>
          <td class="title">����ȸ��</td>
          <td class="title">���ǹ�ȣ</td>
          <td class="title">����Ⱓ</td>
          <td class="title">�����</td>
          <td class="title">���ڽ�</td>
          <td class="title">�ø����ȣ</td>
          <td class="title">���ڽ��ݾ�</td>
          <td class="title">���ι��1</td>
          <td class="title">���ι��2</td>
          <td class="title">�빰���</td>
          <td class="title">�ڱ��ü���</td>
          <td class="title">�������ڵ��������ѻ���</td>
          <td class="title">�ڱ���������</td>
          <td class="title">�����ܵ������</td>
          <td class="title">�ٸ��ڵ���������������Ư�����</td>
          <td class="title">�����ȣ</td>
          <td class="title">���ڽ� ���κ����</td>
  		</tr>
<%
	int value_line = 0;
	int vt_size = vt.size();
	String date="";
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);
		if(!content.get("0").equals("")){
		%>  
        <tr>
    	  <td height="30" class="title"><%=value_line+1%></td>
    	  <td align="center"><input	name="ch_start" type="checkbox" class="style1" 		value="<%=value_line%>"></td>	
    	  <td align="center"><input name="value0" 	type="text" 	class="text"   		value="<%=content.get("0")%>"></td>     
    	  <td align="center"><input name="value1"	type="text" 	class="text"   		value="<%=content.get("1")%>"></td>     <!-- �������� -->               
    	  <td align="center"><input name="value2"	type="text" 	class="text"   		value="<%=content.get("2")%>"></td>     <!-- ���� -->                
    	  <td align="center"><input name="value3"	type="text" 	class="text"   		value="<%=content.get("3")%>"></td>     <!-- ����ڹ�ȣ -->              
    	  <td align="center"><input name="value4"	type="text" 	class="text"   		value="<%=content.get("4")%>"></td>     <!-- ������ȣ -->               
    	  <td align="center"><input name="value5"	type="text" 	class="text"   		value="<%=content.get("5")%>"></td>     <!-- �����ȣ -->             
    	  <td align="center"><input name="value6"	type="text" 	class="text"   		value="<%=content.get("6")%>"></td>     <!-- ���� -->                
    	  <td align="center"><input name="value7"	type="text" 	class="text"   		value="<%=content.get("7")%>"></td>     <!-- ���ʵ���� -->              
    	  <td align="center"><input name="value8"	type="text" 	class="text"   		value="<%=content.get("8")%>"></td>     <!-- ��ϻ��� -->              
    	  <td align="center"><input name="value9"	type="text" 	class="text"   		value="<%=content.get("9")%>"></td>     <!-- �㺸���� -->              
    	  <td align="center"><input name="value10"	type="text" 	class="text"   		value="<%=content.get("10")%>"></td>    <!-- ����ȸ�� -->               
    	  <td align="center"><input name="value11"	type="text" 	class="text"   		value="<%=content.get("11")%>"></td>    <!-- ���ǹ�ȣ -->               
    	  <td align="center"><input name="value12"	type="text" 	class="text"   		value="<%=content.get("12")%>"></td>    <!-- ����Ⱓ -->               
    	  <td align="center"><input name="value13"	type="text" 	class="text"   		value="<%=content.get("13")%>"></td>    <!-- ����� -->             
    	  <td align="center"><input name="value14"	type="text" 	class="text"   		value="<%=content.get("14")%>"></td>    <!-- ���ڽ� -->            
    	  <td align="center"><input name="value15"	type="text" 	class="text"   		value="<%=content.get("15")%>"></td>    <!-- �ø����ȣ -->            
    	  <td align="center"><input name="value16"	type="text" 	class="text"   		value="<%=content.get("16")%>"></td>    <!-- ���ڽ��ݾ� -->           
    	  <td align="center"><input name="value17"	type="text" 	class="text"   		value="<%=content.get("17")%>"></td>    <!-- ���ι��1 -->            
    	  <td align="center"><input name="value18"	type="text" 	class="text"   		value="<%=content.get("18")%>"></td>    <!-- ���ι��2 -->           
    	  <td align="center"><input name="value19"	type="text" 	class="text"   		value="<%=content.get("19")%>"></td>    <!-- �빰���  -->              
    	  <td align="center"><input name="value20"	type="text" 	class="text"   		value="<%=content.get("20")%>"></td>    <!-- �ڱ��ü���   -->           
    	  <td align="center"><input name="value21"	type="text" 	class="text"   		value="<%=content.get("21")%>"></td>    <!-- �������ڵ��������ѻ��� -->
    	  <td align="center"><input name="value22" 	type="text" 	class="text"   		value="<%=content.get("22")%>"></td>    <!-- �ڱ��������� -->            
    	  <td align="center"><input name="value23"	type="text" 	class="text"   		value="<%=content.get("23")%>"></td>    <!-- �����ܵ������ -->      
    	  <td align="center"><input name="value24"	type="text" 	class="text"   		value="<%=content.get("24")%>"></td>    <!-- �ٸ��ڵ���������������Ư����� -->  
    	  <td align="center"><input name="value25"	type="text" 	class="text"   		value="<%=content.get("25")%>"></td>    <!-- �����ȣ -->            
    	  <td align="center"><input name="value26"	type="text" 	class="text"   		value="<%=content.get("26")%>"></td>    <!-- ���ڽ� ���κ����  -->      
  		</tr>       
  	<%		value_line++;
		}
	}
	%>
	  </table>
	</td>
  </tr>  
  <tr>
    <td>* �������� �����Ͻʽÿ�</td>
  </tr>  
  <tr>  
    <td align="center"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="" height="18" aligh="absmiddle" border="0"></a></td>
  	<!-- <input type="submit" class="button" value="���� �輭 ��û ���" onclick="javascript:select_c2_ins_excel_com();"> -->
    </tr>
</table>
<input type='hidden' name='value_line' value='<%=value_line%>'>   
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<SCRIPT>
<!--
//-->
</SCRIPT>
</BODY>
</HTML>