<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
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

	//등록하기
	function save(){
		fm = document.form1;
		
		var b_size = 56;
		var r_size = <%=sheet.getColumns()%>;	
		if('<%=ck_acar_id%>' != '000029' && (b_size > r_size || b_size < r_size)){
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
		
		if(row_size > 100){			alert('100행을 초과합니다. 사이즈 조절을 하셔야 합니다.'); return; }
		
		
		if(!confirm("등록하시겠습니까?"))	return;
		
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
          <td width="150" class="title">1.증권번호</td>
          <td width="150" class="title">2.배서번호</td>
          <td width="120" class="title">3.피공제자명</td>
          <td width="120" class="title">4.계약자명</td>
          <td width="120" class="title">5.소유주명</td>
          <td width="120" class="title">6.가입시차량번호</td>
          <td width="120" class="title">7.차량번호</td>
          <td width="120" class="title">8.차명</td>
          <td width="120" class="title">9.연령</td>
          <td width="120" class="title">10.공제기간</td>
          <td width="120" class="title">11.납입방법</td>
          <td width="120" class="title">12.분납회차</td> 
          <td width="120" class="title">13.배서코드</td> 
          <td width="150" class="title">14.배서항목명</td>
          <td width="150" class="title">15.변경전</td>
          <td width="150" class="title">16.변경후</td>
          <td width="150" class="title">17.가입담보</td>
          <td width="150" class="title">18.대인원</td>
          <td width="150" class="title">19.대인투</td>
          <td width="150" class="title">20.대물배상</td>
          <td width="150" class="title">21.자손</td>
          <td width="150" class="title">22.무보험</td>
          <td width="150" class="title">23.자차</td>
          <td width="150" class="title">24.대여자동차복구</td>
          <td width="150" class="title">25.자상</td>
          <td width="150" class="title">26.긴출</td>
          <td width="150" class="title">27.휴업손해</td>
          <td width="150" class="title">28.분담금할증한정</td>
          <td width="150" class="title">29.차대차한정</td>
          <td width="150" class="title">30.장기여부</td>
          <td width="150" class="title">31.차종</td>
          <td width="150" class="title">32.차량등록일</td>
          <td width="150" class="title">33.결제예정금액</td>
          <td width="150" class="title">34.수납일자</td>
          <td width="150" class="title">35.납입구분</td>
          <td width="150" class="title">36.신규갱신</td>
          <td width="150" class="title">37.공제종목</td>
          <td width="150" class="title">38.배서기준일</td>
          <td width="150" class="title">39.담보별보험료</td>
          <td width="150" class="title">40.대인원</td>
          <td width="150" class="title">41.대인투</td>
          <td width="150" class="title">42.대물배상</td>
          <td width="150" class="title">43.자손</td>
          <td width="150" class="title">44.무보험</td>
          <td width="150" class="title">45.자차</td>
          <td width="150" class="title">46.대여자동차복구</td>
          <td width="150" class="title">47.자상</td>
          <td width="150" class="title">48.긴출</td>
          <td width="150" class="title">49.휴업손해</td>
          <td width="150" class="title">50.분담금할증한정</td>
          <td width="150" class="title">51.차대차한정</td>
          <td width="150" class="title">52.운전자명</td>
          <td width="150" class="title">53.운전자순번</td>
          <td width="150" class="title">54.면허번호</td>
          <td width="150" class="title">55.운전자한정시기</td>
          <td width="150" class="title">56.운전자한정종기</td>
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
    <td>* 시작행을 선택하십시오</td>
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