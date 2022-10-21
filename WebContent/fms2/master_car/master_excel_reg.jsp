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
	
	String gubun1 	= file.getParameter("gubun1")==null?"":file.getParameter("gubun1");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/table.css">
<script language="JavaScript" src="/acar/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	//등록하기
	function save(){
		fm = document.form1;
		fm.start_row.value = '1';
		fm.gubun1.value= '<%=gubun1%>';
		if(fm.dt1.value == '')				{ alert('결재예정일을 입력하십시오'); 		fm.dt1.focus(); 		return;	}
		
		if(!confirm("등록하시겠습니까?"))	return;
		fm.target= '_parent';
//		fm.action = 'https://fms3.amazoncar.co.kr/acar/admin/master_excel_reg_a.jsp';
		fm.action = 'master_excel_reg_a.jsp';
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
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='row_size' value='<%=sheet.getRows()%>'>
<input type='hidden' name='col_size' value='<%=sheet.getColumns()%>'>
<input type='hidden' name='start_row' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="<%=70+(120*sheet.getColumns())+30%>">
  <tr>
    <td>&lt; 엑셀 파일 읽기 &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td align="center"><span class="style1">- 양식폼 - </span></td>
  </tr>
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">
        <tr>
          <td width="30" class="title">연번</td>
          <td width="40" class="title">시작행</td>
          <td width="120" class="title">접수일자</td>
          <td width="120" class="title">No</td>		  
          <td width="120" class="title">시간</td>
          <td width="120" class="title">서비스항목</td>
          <td width="120" class="title">가맹점명</td>
          <td width="120" class="title">고객명</td>
          <td width="120" class="title">차량번호</td>		  		  
          <td width="120" class="title">실입고지</td>		  
          <td width="120" class="title">핸드폰</td>		  
          <td width="120" class="title">실비구분</td>		  
          <td width="120" class="title">접수상세내역</td>		  
          <td width="120" class="title">조치상세내역</td>		  
          <td width="120" class="title">접수방법</td>		  
          <td width="120" class="title">결재예정일</td>		  
          <td width="120" class="title">결재일</td>		  
          <td width="120" class="title">차량코드</td>		  
          <td width="120" class="title">계약코드</td>		  
          <td width="120" class="title">장기계약번호</td>		  
          <td width="120" class="title">단기계약번호</td>		  
          <td width="120" class="title">담당자</td>		  
        </tr>
      </table></td>
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
    	  <td width="100" height="30" rowspan="2" class="title">구분</td>
    	  <td width="150">&nbsp;
		   긴급출동내역
    	  <td width="100" height="30" rowspan="2" class="title">결재예정일</td>
    	  <td width="150">&nbsp;
		  <input name="dt1" type="text" class=text value="" size="12"></td>
    	  <td width="100" height="30" class="title">결재일</td>
    	  <td>&nbsp;
		  <input name="dt2" type="text" class=text value="" size="12"></td>
        </tr>
	  </table>
	</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
  </tr>    
  <tr>  
    <td align=""><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">  
        <tr>
    	  <td width="30" class="title">연번</td>
    	  <td width="40" class="title">시작행</td>	
    	  <td colspan='<%=sheet.getColumns()%>' class="title">엑셀 데이타</td>
  		</tr>
<%
	int value_line = 0;
	int vt_size = vt.size();
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);
		if(String.valueOf(content.get("0")).equals("") && String.valueOf(content.get("1")).equals("") && String.valueOf(content.get("2")).equals(""))  continue;%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=i+1%></td>
    	  <td width="40" align="center"><input name="ch_start" type="checkbox" class="style1" value="<%=i%>"></td>	
		  <% for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td width="120" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j)) %>" size="13"></td>
		  <%	}%>
  		</tr>
<%		value_line++;
	}%>
	  </table>
	</td>
  </tr> 
  <tr>
    <td>* 시작행을 선택하십시오</td>
  </tr>  
  
</table>
<input type='hidden' name='value_line' value='<%=value_line%>'>   
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>