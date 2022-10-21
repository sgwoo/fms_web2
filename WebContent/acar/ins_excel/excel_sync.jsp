<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//excel 파일의 절대 경로
	String path = request.getRealPath("/file/insur/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	ExcelUpload file = new ExcelUpload(path , request.getInputStream());
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

%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/info.js"></script>
<!-- <link rel=stylesheet type="text/css" href="../../include/table.css"> -->
<script>
$(function() {
    $('.load_more').live("click",function() {    
      var last_msg_id = $(this).attr("id");      // 현재 리스트의 마지막글 번호를 가져온다. 마지막글 번호는 아래 더보기 버튼의 id값이
	  $.ajax({
	        type: "POST",
	        url: "testList_ajax.jsp",      // 더보기 눌렀을때 데이터리스트를 html 형태로 만들어서 현재 리스트페이지로 보내준다.
	        data: "lastmsg="+ last_msg_id, // 현재 리스트에 뿌려져있는 마지막 글 번호를 넣어준다. 그래야지 리스트의 마지막글 다음부터의 리스트를 가져온다.
	        beforeSend:  function() {
	        $('a.load_more').append('<img src="../img/facebook_style_loader.gif" />');    // 로딩 진행줄일때 .gif로 로딩중이라는거 표시                  
	    },
	    success: function(html){            // testList_ajax.jsp 와 연결이 성공하면 ajax 페이지에서 생성한 리스트목록 가져와서
	        $(".facebook_style").remove();  // Show Older Posts▼ 버튼을 제거하고 
	        $("ol#updates").append(html);   // 추가로만든 리스트목록과 Show Older Posts▼ 버튼을 붙여 넣는다.
	    }
	});
    return false;
    });
});

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
		var num = parseInt(str, 10);
		return checkNaN(num);
	}

	//등록하기
	function save(){
		fm = document.form1;
		
		var b_size = 7;
		var r_size = <%=sheet.getColumns()%>;	
		if(b_size > r_size){
			alert('엑셀데이타가 양식폼하고 틀립니다.\n\n확인하십시오.');
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
		 	alert("시작행을 선택하세요.");
			return;
		}	
		if(cnt > 1){
		 	alert("하나의 시작행만 선택하세요.");
			return;
		}		
			
		fm.start_row.value = idnum;
		
		if(!confirm("등록하시겠습니까?"))	return;
		
		fm.action = "excel_sync_excel.jsp";
		fm.submit();
	}
</SCRIPT>
<style type="text/css">
.style1 {color: #999999}
</style>
</HEAD>
<BODY>
<p>
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='row_size' value='<%=sheet.getRows()%>'>
<input type='hidden' name='col_size' value='<%=sheet.getColumns()%>'>
<input type='hidden' name='start_row' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="<%=70+(120*sheet.getColumns())+60%>">
  <tr>
    <td>&lt; 엑셀 파일 읽기 &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">
        <tr>
          <td width="30"  class="title">연번</td>
          <td width="40"  class="title">시작행</td>
          <td width="170" class="title">①증권번호</td>
          <td width="120" class="title">②차량번호</td>
          <td width="240" class="title">③상호</td>
          <td width="120" class="title">④사업자번호</td>
          <td width="120" class="title">⑤연령</td>
          <td width="120" class="title">⑥대물</td>
          <td width="120" class="title">⑦임직원</td>
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
    	  <td width="30" class="title">연번</td>
    	  <td width="40" class="title">시작행</td>	
    	  <td colspan='<%=sheet.getColumns()%>' class="title">엑셀 데이타</td>
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
    	  <td width="30"  height="30" class="title"><%=value_line+1%></td>
    	  <td width="40"  align="center"><input name="ch_start" type="checkbox" class="style1" value="<%=value_line%>"></td>	
    	  <td width="170" align="center"><input name="ins_con_no" type="text" class=text style1   value="<%=content.get("0")%>"size="21"></td>
    	  <td width="120" align="center"><input name="car_no" type="text" class=text style1   value="<%=content.get("1")%>"size="13"></td>
    	  <td width="240" align="center"><input name="firm_emp_nm" type="text" class=text style1   value="<%=content.get("2")%>"size="33"></td>
    	  <td width="120" align="center"><input name="enp_no" type="text" class=text style1   value="<%=content.get("3")%>"size="13"></td>
    	  <td width="120" align="center"><input name="age_scp" type="text" class=text style1   value="<%=content.get("4")%>"size="13"></td>
    	  <td width="120" align="center"><input name="vins_gcp_kd" type="text" class=text style1   value="<%=content.get("5")%>"size="13"></td>
    	  <td width="120" align="center"><input name="com_emp_yn" type="text" class=text style1   value="<%=content.get("6")%>"size="13"></td>
  		</tr>
<%			value_line++;
		}
	}
	%>
	  </table>
	</td>
  </tr>  
  <tr>
    <td>* 시작행을 선택하십시오</td>
  </tr>  
  <tr>  
    <td align="center"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_excel.gif" width="" height="18" aligh="absmiddle" border="0"></a></td>
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