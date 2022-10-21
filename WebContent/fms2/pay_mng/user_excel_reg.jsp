<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>

<%
	//excel 파일의 절대 경로
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	ExcelUpload file = new ExcelUpload(path, request.getInputStream());	
	String filename = file.getFilename();
	
	FileInputStream fi = new FileInputStream(new File(path+""+filename+".xls"));


	int sheet_num 	= file.getParameter("sheet_num")==null?0:AddUtil.parseInt(file.getParameter("sheet_num"));


	Workbook workbook = Workbook.getWorkbook(fi);
	
	//엑셀의 첫번째 sheet 가지고 온다. 
	Sheet sheet = workbook.getSheet(sheet_num);
	
	for(int i = 0; i < sheet.getRows(); i++){
	
		Hashtable ht = new Hashtable();
		
		for(int j = 0; j < sheet.getColumns(); j++){
			
			Cell cell = sheet.getCell(j,i);
			
			ht.put(Integer.toString(j), cell.getContents());
			
		}
		vt.add(ht);
	}
	
	int vt_size = vt.size();
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<!--<script language="JavaScript" src="/acar/include/info.js"></script>-->
<SCRIPT LANGUAGE="JavaScript">
<!--
	//등록하기
	function save(){
		fm = document.form1;

		if(fm.start_row.value == '')		{ alert('시작행 번호를 입력하십시오.'); 	return; }
		if(fm.value_line.value == '')		{ alert('마지막행 번호를 입력하십시오.'); 	return; }		
		
		if(!confirm("등록하시겠습니까?"))	return;
		
		var idx = 1;
		
		for(i=toInt(fm.start_row.value); i<=toInt(fm.value_line.value); i++){
		
			opener.form1.user_nm[idx].value 		= fm.value0[i].value;						
			opener.form1.money[idx-1].value 		= fm.value1[i].value;			
			opener.form1.user_case_id[idx-1].value 	= '';
			
			idx++;

		}
				
		
		opener.Keyvalue();
		
		opener.tr_acct99.style.display	 	= '';
		opener.tr_acct101.style.display 	= '';
		
		window.close();
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

<table border="0" cellspacing="0" cellpadding="0" width="<%=100+(200*sheet.getColumns())%>">
  <tr>
    <td>&lt; 엑셀 파일 읽기 &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td>&lt; 공통 &gt; </td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="100" height="30" class="title">시작행</td>
    	  <td>&nbsp;
		  <input type='text' name='start_row' size='3' value='0' class='text'>번</td>
        </tr>
        <tr>
    	  <td width="100" height="30" class="title">마지막행</td>
    	  <td>&nbsp;
		  <input type='text' name='value_line' size='3' value='<%=vt.size()-1%>' class='text'>번</td>
        </tr>
	  </table>
	</td>
  </tr>  
    <tr> 
      <td align="right">&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td>※ 칼럼순 : [A]이름 (공백 없을것)	 [B]금액 </td>
  </tr>        
  <tr>
    <td>&nbsp;</td>
  </tr>    
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">  
        <tr>
    	  <td width="100" class="title">연번</td>
    	  <td colspan='<%=sheet.getColumns()%>' class="title">엑셀 데이타</td>
  		</tr>
<%
	
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);%>  
        <tr>
    	  <td width="100" height="30" class="title"><%=i%></td>
		  <% for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td width="200" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j))%>" size="15"></td>
		  <%	}%>
  		</tr>
<%	}%>
	  </table>
	</td>
  </tr> 
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>  
    <td align="center">
	  <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" aligh="absmiddle" border="0"></a>&nbsp;
	  <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>