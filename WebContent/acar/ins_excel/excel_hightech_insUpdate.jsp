<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*,java.lang.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
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
			
			CellType type = cell.getType();
			
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
		
		var b_size = 7;
		var r_size = <%=sheet.getColumns()%>;	
		alert(r_size);
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
		
		//if(row_size > 200){			alert('200행을 초과합니다. 사이즈 조절을 하셔야 합니다.'); return; }
		
		
		if(!confirm("등록하시겠습니까?"))	return;
					
		fm.action = 'excel_hightech_insUpdate_a.jsp';									
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
          <td width="150" class="title">①증권번호</td>
          <td width="150" class="title">②보험순번</td>
          <td width="120" class="title">③차선이탈(제어형)</td>
          <td width="120" class="title">④차선이탈(경고형)</td>
          <td width="120" class="title">⑤긴급제동(제어형)</td>
          <td width="120" class="title">⑥긴급제동(경고형)</td>
          <td width="120" class="title">⑦전기자동차</td>
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
		if(((String)content.get("1")).contains("/")){
			int yearStartNum = ((String)content.get("1")).lastIndexOf( "/" );
			int montStartNum = ((String)content.get("1")).indexOf( "/" );
			
			int contentLengh = ((String)content.get("1")).length();
			
			
			String year = ((String)content.get("1")).substring(yearStartNum+1,contentLengh);
			if(year.length() < 2){
				year=200+year;
			}else{
				year=20+year;
			}
			
			String month = ((String)content.get("1")).substring(0,montStartNum);
			if(month.length() < 2){
				month=0+month;
			}else{
				month=month;
			}
			
			String day = ((String)content.get("1")).substring(montStartNum+1,yearStartNum);
			if(day.length() < 2){
				day=0+day;
			}else{
				day=day;
			}
			
			date = year+month+day;
			
			//reg_dt = (reg_dt.replaceAll("-","")).replaceAll("/","");
		}
		//if(String.valueOf(content.get("0")).equals("") && String.valueOf(content.get("1")).equals("") && String.valueOf(content.get("2")).equals(""))  continue;
		%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=value_line+1%></td>
    	  <td width="40" align="center"><input name="ch_start" type="checkbox" class="style1" value="<%=value_line%>"></td>	
    	  <td width="150" align="center"><input name="ins_con_no" type="text" class=text style1  value="<%=content.get("0")%>"size="17"></td>
    	  <td width="150" align="center"><input name="ins_start_dt" type="text" class=text style1  value="<%=content.get("1")%>"size="17"></td>
    	  <td width="120" align="center"><input name="lkas_yn" type="text" class=text style1   value="<%=content.get("2")%>"size="13"></td>
    	  <td width="120" align="center"><input name="ldws_yn" type="text" class=text style1   value="<%=content.get("3")%>"size="13"></td>
    	  <td width="120" align="center"><input name="aeb_yn" type="text" class=text style1   value="<%=content.get("4")%>"size="13"></td>
    	  <td width="120" align="center"><input name="fcw_yn" type="text" class=text style1   value="<%=content.get("5")%>"size="13"></td>
    	  <td width="120" align="center"><input name="ev_yn" type="text" class=text style1   value="<%=content.get("6")%>"size="13"></td>
  		</tr>
<%		value_line++;
	}
	%>
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