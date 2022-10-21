<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>

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
		
		if(!confirm("등록하시겠습니까?"))	return;		
		fm.action = 'excel_deep_a.jsp';
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

<form action="" method='post' name="form1">
<input type='hidden' name='user_id' value='<%= user_id %>'>
<input type='hidden' name='gubun1' value='<%= gubun1 %>'>
<input type='hidden' name='row_size' value='<%= rowSize %>'>
<input type='hidden' name='col_size' value='<%= columnSize %>'>
<input type='hidden' name='start_row' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="<%= 70 + (150 * columnSize)%>">
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
		  <td width="150" class="title">차량번호</td>
          <td width="150" class="title">경매일자</td>
		  <td width="150" class="title">딥러닝<br>예측낙찰가</td>
          <td width="150" class="title">딥러닝<br>예측낙찰가<br>(해당연월 반영,해당차량 미반영)</td>		  
          <td width="150" class="title">딥러닝<br>예측낙찰가<br>(해당연월 반영,해당차량 반영)</td>
          <td width="150" class="title">딥러닝<br>예측낙찰가<br>(분당)</td>
          <td width="150" class="title">딥러닝<br>예측낙찰가<br>(시화)</td>
		  <td width="150" class="title">딥러닝<br>예측낙찰가<br>(양산)</td>
		  <td width="150" class="title">딥러닝<br>예측낙찰가<br>(롯데)</td>
		  <td width="150" class="title">딥러닝<br>예측낙찰가<br>(AJ)</td>
        </tr>
      </table></td>
  </tr>  
  <tr>
    <td><hr></td>
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

		if (String.valueOf(content.get(0)).equals("")) { // && String.valueOf(content.get(1)).equals("") && String.valueOf(content.get(2)).equals("")
			continue;  
		}
%>
        <tr>
    	  <td width="30" height="30" class="title"><%= (i + 1) %></td>
    	  <td width="40" align="center"><input name="ch_start" type="checkbox" class="style1" value="<%= i %>"></td>	
<%		for (int j = 0; j < columnSize; j++) { %>
    	  <td width="150" align="center"><input name="value<%= j %>" type="text" class=text style1 value="<%= content.get(j) %>" size="13"></td>
<%		} %>
  		</tr>
<%
		value_line = i + 1;
	}
%>
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