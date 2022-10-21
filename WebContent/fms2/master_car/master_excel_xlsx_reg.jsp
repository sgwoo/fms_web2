<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<%//@ include file="/acar/cookies.jsp" %>
<%
	// 엑셀파일이 업로드될 폴더
	String uploadPath = request.getSession().getServletContext().getRealPath("/file/");

	// 엑셀파일 최대 크기
	int sizeLimit = 50 * 1024 * 1024 ;

	// 엑셀파일 업로드
	MultipartExcelUpload excelUploadComponent = MultipartExcelUpload.getInstance();

	Hashtable parameters = new Hashtable();

	parameters = excelUploadComponent.MultipartRequestExcelSave(request, response, sizeLimit, uploadPath);

	Vector vt = excelUploadComponent.getExcelData(response, uploadPath, (String) parameters.get("fileName"));

	if (vt == null) {
		out.write("엑셀 파일을 읽어들이지 못했습니다.");

		return;
	}

	int rowSize = vt.size();

	if (rowSize == 0 || vt.get(0) == null) {
		out.write("엑셀 파일 내용이 없습니다.");

		return;
	}

	int columnSize = ((ArrayList) vt.elementAt(0)).size();

	String gubun1 = (String) parameters.get("gubun1");
	String user_id = (String) parameters.get("user_id");
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
	//	fm.gubun1.value= '<%=gubun1%>';
		if(fm.dt1.value == '')				{ alert('결재예정일을 입력하십시오'); 		fm.dt1.focus(); 		return;	}
		
		if(!confirm("등록하시겠습니까?"))	return;
		fm.target= '_parent';
//		fm.action = 'https://fms3.amazoncar.co.kr/acar/admin/master_excel_reg_a.jsp';
		fm.action = 'master_excel_reg_a.jsp?gubun1=<%=gubun1%>';
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
<input type='hidden' name='user_id' value='<%= user_id %>'>
<input type='hidden' name='gubun1' value='<%= gubun1 %>'>
<input type='hidden' name='row_size' value='<%= rowSize %>'>
<input type='hidden' name='col_size' value='<%= columnSize %>'>
<input type='hidden' name='start_row' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="<%= 70 + (120 * columnSize)%>">
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
<!--		  
          		  
          <td width="120" class="title">결재일</td>		  
          <td width="120" class="title">차량코드</td>		  
          <td width="120" class="title">계약코드</td>		  
          <td width="120" class="title">장기계약번호</td>		  
          <td width="120" class="title">단기계약번호</td>		  
          <td width="120" class="title">담당자</td>		  
		  -->
        </tr>
      </table></td>
  </tr>  
  <tr>
    <td><hr></td>
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
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">  
        <tr>
    	  <td width="30" class="title">연번</td>
    	  <td width="40" class="title">시작행</td>	
    	  <td colspan='<%=columnSize%>' class="title">엑셀 데이타</td>
  		</tr>
<%
	int vt_size = vt.size();

	int value_line = 0;

	for (int i = 0 ; i < vt_size ; i++) {
		ArrayList content = (ArrayList) vt.elementAt(i);

		if (String.valueOf(content.get(0)).equals("")
		 && String.valueOf(content.get(1)).equals("")
		 && String.valueOf(content.get(2)).equals("")) {
			continue;  
		}
	%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=i+1%></td>
    	  <td width="40" align="center"><input name="ch_start" type="checkbox" class="style1" value="<%=i%>"></td>	
		  <% for(int j = 0; j < columnSize; j++){%>
    	  <td width="120" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(j) %>" size="13"></td>
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
    <td align="center"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
<input type='hidden' name='value_line' value='<%=value_line%>'>   
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>