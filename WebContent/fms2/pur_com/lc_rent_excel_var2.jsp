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
	//등록하기
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
		 	alert("시작행을 선택하세요.");
			return;
		}	
		if(cnt > 1){
		 	alert("하나의 시작행만 선택하세요.");
			return;
		}		
			
		fm.start_row.value = idnum;
		
		if(!confirm("등록하시겠습니까?"))	return;
		
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
                    <td width="40" class="title">시작행</td>
                    <td width='120' class='title'>0 연번</td>
                    <td width='120' class='title'>1 상태</td>
                    <td width="120" class='title'>2 특판계약번호</td>                    
                    <td width='120' class='title'>3 계약등록일</td>
                    <td width="120" class='title'>4 출고희망일</td>        	    
                    <td width="120" class='title'>5 배정구분</td>       		
                    <td width="120" class='title'>6 배정예정일</td>       		
        	          <td width="120" class='title'>7 변경구분</td>
                    <td width='120' class='title'>8 변경등록</td>
                    <td width='120' class='title'>9 처리구분</td>     
                    <td width='120' class='title'>10 제조사</td>                    
                    <td width='120' class='title'>11 영업소</td>                   
                    <td width='120' class='title'>12 차명</td>                    
        	    <td width="120" class='title'>13 선택사양</td>
        	    <td width="120" class='title'>14 색상</td>		  
        	    <td width='120' class='title'>15 인수지</td>
        	    <td width='120' class='title'>16 과세구분</td>
        	    <td width='120' class='title'>17 차량가격</td>
        	    <td width='120' class='title'>18 DC금액</td> 
        	    <td width="120" class="title">19 추가D/C</td>       	    
        	    <td width='120' class='title'>20 탁송료</td>        	    
        	    <td width='120' class='title'>21 결제금액</td>        	            	            	            	    
        	    <td width='120' class='title'>22 계약자</td>
        	    <td width='120' class='title'>23 최초영업자</td>        	
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
    	  <!--<td width="30" class="title">연번</td>-->
    	  <td width="40" class="title">시작행</td>	
    	  <td colspan='<%=sheet.getColumns()%>' class="title">엑셀 데이타</td>
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
    <td>* 시작행을 선택하십시오</td>
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