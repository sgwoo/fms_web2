<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>

<%
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
	
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")	==null?"":request.getParameter("br_id");
	
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
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
	//등록하기
	function save(){
		fm = document.form1;

		if(fm.start_row.value == '')		{ alert('시작행 번호를 입력하십시오.'); 	return; }
		if(fm.value_line.value == '')		{ alert('마지막행 번호를 입력하십시오.'); 	return; }		
		
		if(!confirm("등록하시겠습니까?"))	return;
		 
		
		fm.action = 'pay_excel_reg_step2.jsp';
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
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>

<table border="0" cellspacing="0" cellpadding="0" width="<%=30+(150*sheet.getColumns())%>">
  <tr>
    <td>&lt; 엑셀 파일 읽기 [출금] &gt; </td>
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
		  <input type='text' name='start_row' size='3' value='2' class='text'>번</td>
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
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td>※ 칼럼순 : [엑셀등록 기본양식]의 캄럼 구성 및 순서가 같아야 한다. 실제 값이 없어도 구성은 같게 해주세요.</td>
  </tr>        
  <tr>
    <td>&nbsp;</td>
  </tr>    
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">  
        <tr>
    	  <td width="30" class="title">연번</td>
    	  <td colspan='<%=sheet.getColumns()%>' class="title">엑셀 데이타</td>
  		</tr>
<%
	int vt_size = vt.size();
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=i%></td>
		  <% for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td width="150" align="center"><input name="value<%if(j<10){%>0<%}%><%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j))%>" size="15"></td>
		  <%	}%>
  		</tr>
<%	}%>
	  </table>
	</td>
  </tr> 
  <tr>  
    <td style="padding-top: 10px;">
	  <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" aligh="absmiddle" border="0"></a>&nbsp;

	  <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>