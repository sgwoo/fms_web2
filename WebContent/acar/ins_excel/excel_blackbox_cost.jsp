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
<script language='JavaScript' src='/include/common.js'></script>
<!-- <link rel=stylesheet type="text/css" href="../../include/table.css"> -->
<script>
/* $(function() {
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

	//등록하기
	function save(){
		fm = document.form1;
		
		
		var b_size = 26;
		var r_size = <%=sheet.getColumns()%>;	
		if(b_size > r_size){
			alert('엑셀데이타가 양식폼하고 틀립니다.\n\n확인하십시오.');
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
			alert("배서기준일 형식은 2019-05-10 처럼 입력해주세요");
			return;
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
    <td>&lt; 엑셀 파일 읽기 &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
	<tr>
		<td>여러번 등록할 경우 보험변경사항에 중복된 값이 계속 들어가니, 저장이 성공된 건들은 엑셀에서 제외하고 등록해주시기 바랍니다.</td>
	</tr>	
	<tr>
		<td></td>
	</tr>	
	<tr>
		<td>배서 기준일 : <input type="text" name="ch_dt" value='' onBlur='javascript:this.value=ChangeDate(this.value)' size="12"> * 반드시 입력해주세요  </td> 
 	</tr>
 	<tr>	
		<td></td>
 	</tr>
  <tr>
    <td class="line">
	<table border="0" cellspacing="1" cellpadding="0">  
		<tr style="height:30px;">
    	  <td class="title">연번</td>
          <td class="title">시작행</td>
          <td class="title">No</td>
          <td class="title">차량구분</td>
          <td class="title">고객명</td>
          <td class="title">사업자번호</td>
          <td class="title">차량번호</td>
          <td class="title">차대번호</td>
          <td class="title">차종</td>
          <td class="title">최초등록일</td>
          <td class="title">등록사유</td>
          <td class="title">담보구분</td>
          <td class="title">보험회사</td>
          <td class="title">증권번호</td>
          <td class="title">보험기간</td>
          <td class="title">보험료</td>
          <td class="title">블랙박스</td>
          <td class="title">시리얼번호</td>
          <td class="title">블랙박스금액</td>
          <td class="title">대인배상1</td>
          <td class="title">대인배상2</td>
          <td class="title">대물배상</td>
          <td class="title">자기신체사고</td>
          <td class="title">무보험자동차에의한상해</td>
          <td class="title">자기차량손해</td>
          <td class="title">차량단독사고보상</td>
          <td class="title">다른자동차차량손해지원특별약관</td>
          <td class="title">설계번호</td>
          <td class="title">블랙박스 할인보험료</td>
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
    	  <td align="center"><input name="value1"	type="text" 	class="text"   		value="<%=content.get("1")%>"></td>     <!-- 차량구분 -->               
    	  <td align="center"><input name="value2"	type="text" 	class="text"   		value="<%=content.get("2")%>"></td>     <!-- 고객명 -->                
    	  <td align="center"><input name="value3"	type="text" 	class="text"   		value="<%=content.get("3")%>"></td>     <!-- 사업자번호 -->              
    	  <td align="center"><input name="value4"	type="text" 	class="text"   		value="<%=content.get("4")%>"></td>     <!-- 차량번호 -->               
    	  <td align="center"><input name="value5"	type="text" 	class="text"   		value="<%=content.get("5")%>"></td>     <!-- 차대번호 -->             
    	  <td align="center"><input name="value6"	type="text" 	class="text"   		value="<%=content.get("6")%>"></td>     <!-- 차종 -->                
    	  <td align="center"><input name="value7"	type="text" 	class="text"   		value="<%=content.get("7")%>"></td>     <!-- 최초등록일 -->              
    	  <td align="center"><input name="value8"	type="text" 	class="text"   		value="<%=content.get("8")%>"></td>     <!-- 등록사유 -->              
    	  <td align="center"><input name="value9"	type="text" 	class="text"   		value="<%=content.get("9")%>"></td>     <!-- 담보구분 -->              
    	  <td align="center"><input name="value10"	type="text" 	class="text"   		value="<%=content.get("10")%>"></td>    <!-- 보험회사 -->               
    	  <td align="center"><input name="value11"	type="text" 	class="text"   		value="<%=content.get("11")%>"></td>    <!-- 증권번호 -->               
    	  <td align="center"><input name="value12"	type="text" 	class="text"   		value="<%=content.get("12")%>"></td>    <!-- 보험기간 -->               
    	  <td align="center"><input name="value13"	type="text" 	class="text"   		value="<%=content.get("13")%>"></td>    <!-- 보험료 -->             
    	  <td align="center"><input name="value14"	type="text" 	class="text"   		value="<%=content.get("14")%>"></td>    <!-- 블랙박스 -->            
    	  <td align="center"><input name="value15"	type="text" 	class="text"   		value="<%=content.get("15")%>"></td>    <!-- 시리얼번호 -->            
    	  <td align="center"><input name="value16"	type="text" 	class="text"   		value="<%=content.get("16")%>"></td>    <!-- 블랙박스금액 -->           
    	  <td align="center"><input name="value17"	type="text" 	class="text"   		value="<%=content.get("17")%>"></td>    <!-- 대인배상1 -->            
    	  <td align="center"><input name="value18"	type="text" 	class="text"   		value="<%=content.get("18")%>"></td>    <!-- 대인배상2 -->           
    	  <td align="center"><input name="value19"	type="text" 	class="text"   		value="<%=content.get("19")%>"></td>    <!-- 대물배상  -->              
    	  <td align="center"><input name="value20"	type="text" 	class="text"   		value="<%=content.get("20")%>"></td>    <!-- 자기신체사고   -->           
    	  <td align="center"><input name="value21"	type="text" 	class="text"   		value="<%=content.get("21")%>"></td>    <!-- 무보험자동차에의한상해 -->
    	  <td align="center"><input name="value22" 	type="text" 	class="text"   		value="<%=content.get("22")%>"></td>    <!-- 자기차량손해 -->            
    	  <td align="center"><input name="value23"	type="text" 	class="text"   		value="<%=content.get("23")%>"></td>    <!-- 차량단독사고보상 -->      
    	  <td align="center"><input name="value24"	type="text" 	class="text"   		value="<%=content.get("24")%>"></td>    <!-- 다른자동차차량손해지원특별약관 -->  
    	  <td align="center"><input name="value25"	type="text" 	class="text"   		value="<%=content.get("25")%>"></td>    <!-- 설계번호 -->            
    	  <td align="center"><input name="value26"	type="text" 	class="text"   		value="<%=content.get("26")%>"></td>    <!-- 블랙박스 할인보험료  -->      
  		</tr>       
  	<%		value_line++;
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
    <td align="center"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="" height="18" aligh="absmiddle" border="0"></a></td>
  	<!-- <input type="submit" class="button" value="보험 배서 요청 등록" onclick="javascript:select_c2_ins_excel_com();"> -->
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