<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, jxl.*"%>
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
		String j_content="";
		for(int j = 0; j < sheet.getColumns(); j++){
			
			Cell cell = sheet.getCell(j,i);
			if(j==10){
			
				j_content = cell.getContents()+"";
				j_content = j_content.replace(",","");
				ht.put(Integer.toString(j), j_content);
			}else{
				j_content = cell.getContents()+"";
				ht.put(Integer.toString(j), j_content);		
			}
			
			
		}
		vt.add(ht);
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
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
		
		var b_size = 12;
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
		
		if(row_size > 200){			alert('200행을 초과합니다. 사이즈 조절을 하셔야 합니다.'); return; }
		
		if(fm.ins_rent_dt.value == ''){ 	alert('보험가입일를 입력하십시오.'); return; }
		if(fm.ins_start_dt.value == ''){ 	alert('보험시작일를 입력하십시오.'); return; }		
		if(fm.ins_end_dt.value == ''){ 		alert('보험만료일를 입력하십시오.'); return; }				
		if(fm.t_pay_est_dt.value == ''){ 	alert('보험납입일를 입력하십시오.'); return; }
		if(fm.ins_com_id.value == ''){ 		alert('보험사코드를 입력하십시오.'); return; }
		
		if(!confirm("등록하시겠습니까?"))	return;
		
		
		if(fm.gubun2[0].checked == true){			
		
			fm.action = 'excel_renew2_a.jsp';			
		
		}else if(fm.gubun2[1].checked == true){			
		
			fm.action = 'excel_renew_proc_a.jsp';							
			
		}
		
				
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
          <td width="150" class="title">②차량번호</td>
          <td width="120" class="title">③대인배상Ⅰ</td>
          <td width="120" class="title">④대인배상Ⅱ</td>
          <td width="120" class="title">⑤대물배상</td>
          <td width="120" class="title">⑥자기신체사고</td>
          <td width="120" class="title">⑦무보험차상해</td>
          <td width="120" class="title">⑧분담금할증한정</td>
          <td width="120" class="title">⑨자기차량손해</td>
          <td width="120" class="title">⑩애니카</td>
          <td width="120" class="title">⑪총보험료</td> 
          <td width="120" class="title">⑫임직원전용자동차보험가입여부</td> 
          <!--         
          <td width="120" class="title">⑪납입횟수</td>
          <td width="120" class="title">⑫초회보험료</td>
          <td width="120" class="title">⑬차기납입일</td>
          <td width="120" class="title">⑭차기납입액</td>
          <td width="120" class="title">⑮보험사코드</td>		            
          -->
        </tr>
      </table></td>
  </tr>  
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <%
  	String ins_start_dt 	= AddUtil.getDate();
        String ins_exp_dt 	= (AddUtil.getDate2(1)+1)+""+AddUtil.getDate(2)+""+AddUtil.getDate(3);
        String ins_est_dt 	= ins_start_dt;
        
        ins_est_dt = c_db.addMonth(ins_est_dt, 1);
	ins_est_dt = ins_est_dt.substring(0,8)+"10";
        				
       					
  %>
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="70" rowspan="6" class="title">공통</td>
    	  <td width="150" height="30" class="title">보험가입일
		  </td>
    	  <td>&nbsp;
		  <input name="ins_rent_dt" type="text" class=text value="<%=AddUtil.ChangeDate2(ins_start_dt)%>"size="18" style1></td>
        </tr>
        <tr>
    	  <td width="150" height="30" class="title">보험시작일
		  </td>
    	  <td>&nbsp;
		  <input name="ins_start_dt" type="text" class=text value="<%=AddUtil.ChangeDate2(ins_start_dt)%>"size="18" style1></td>
        </tr>
        <tr>
    	  <td width="150" height="30" class="title">보험만료일
		  </td>
    	  <td>&nbsp;
		  <input name="ins_end_dt" type="text" class=text value="<%=AddUtil.ChangeDate2(ins_exp_dt)%>"size="18" style1></td>
        </tr>
        <tr>
    	  <td width="150" height="30" class="title">보험납입일
		  </td>
    	  <td>&nbsp;
		  <input name="t_pay_est_dt" type="text" class=text value="<%=AddUtil.ChangeDate2(ins_est_dt)%>"size="18" style1></td>
        </tr>	
        <tr>
    	  <td width="150" height="30" class="title">보험사코드
		  </td>
    	  <td>&nbsp;
		  <input name="ins_com_id" type="text" class=text value=""size="18" style1>
		  <!-- 영업용갱신은 동부화재-->
		  </td>
        </tr>        
        <tr>
    	  <td width="150" height="30" class="title">처리구분
		  </td>
    	  <td>&nbsp;
		  <input type="radio" name="gubun2" value="1" checked> 기존 웹페이지
		  
		  <input type="radio" name="gubun2" value="2"> DB 프로시저
		  
		  </td>
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