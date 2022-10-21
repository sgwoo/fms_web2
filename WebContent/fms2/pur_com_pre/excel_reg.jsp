<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*, card.*,acar.common.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>

<%
	//excel 파일의 절대 경로
	String path = request.getRealPath("/file/");
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
	
	int v_td_width = 120;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
			
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
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
		fm.action = 'excel_reg_a.jsp';
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
<table border="0" cellspacing="0" cellpadding="0" width="<%=80+(v_td_width*sheet.getColumns())%>">
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
          <td width="50" class="title">시작행</td>         
                                <td width="<%=v_td_width%>" class="title">1)출고영업소</td>
                                <td width="<%=v_td_width%>" class="title">2)계출번호</td>
                                <td width="<%=v_td_width%>" class="title">3)요청일시</td><!-- 요청일시 추가(20181107)-->
                                <td width="<%=v_td_width%>" class="title">4)차명</td>
                                <td width="<%=v_td_width%>" class="title">5)선택품목</td>
                                <td width="<%=v_td_width%>" class="title">6)외장색상</td>
                                <td width="<%=v_td_width%>" class="title">7)내장색상</td>
                                <td width="<%=v_td_width%>" class="title">8)가니쉬색상</td>
                                <td width="<%=v_td_width%>" class="title">9)소비자가</td>
                                <td width="<%=v_td_width%>" class="title">10)계약금</td>
                                <td width="<%=v_td_width%>" class="title">11)계약금지급일자</td>
                                <td width="<%=v_td_width%>" class="title">12)출고예정일</td>
                                <td width="<%=v_td_width%>" class="title">13)비고</td>
                                <td width="<%=v_td_width%>" class="title">14)담당자</td>
                                <td width="<%=v_td_width%>" class="title">15)고객명</td>
                                <td width="<%=v_td_width%>" class="title">16)고객주소지</td>
                                <td width="<%=v_td_width%>" class="title">17)아마존카계약번호</td>
                                <td width="<%=v_td_width%>" class="title">18)엔진구분</td>
                                <td width="<%=v_td_width%>" class="title">19)에이전트노출여부</td>
                                <td width="<%=v_td_width%>" class="title">20)자체영업여부</td>
                                <!--<td width="<%=v_td_width%>" class="title">21)Q코드</td>-->
                                <td width="<%=v_td_width%>" class="title">21)계약금지급방식</td>
                                <td width="<%=v_td_width%>" class="title">22)카드/금융사</td>
                                <td width="<%=v_td_width%>" class="title">23)계좌종류</td>
                                <td width="<%=v_td_width%>" class="title">24)카드/계좌번호</td>
                                <td width="<%=v_td_width%>" class="title">25)적요/예금주</td>
                                <td width="<%=v_td_width%>" class="title">26)계약금지출예정일</td>
                                
        </tr>
      </table></td>
  </tr>  
  <tr>
    <td>* 에이전트노출여부, 자체영업여부에 <!--Q코드는--> 해당되면 영문대문자 Y 를 넣어주십시오. (공백 없이)</td>
  </tr> 
  <tr>
    <td>* 계약금지급방식 : 현금=1, 후불카드=3 숫자값으로 넣어주세요.</td>
  </tr> 
  <tr>
    <td>* 카드/금융사는 select문 <select name='con_bank'>
                        <option value=''>보기</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>'><%=bank.getNm()%></option>
                        <%		}
        					}%>
                        <%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>'><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
                    </select> 에 있는 글자 그대로 넣어주세요.</td>
  </tr> 
  <tr>
    <td>* 계약금지급방식이 카드인 경우 지급방식만 넣고, 계좌정보는 입력하지 않아도 됩니다.</td>
  </tr>
  <tr>
    <td>* 계좌종류 : 영구계좌=1, 가상계좌=2 숫자값으로 넣어주세요.</td>
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
    	  <td width="50" class="title">시작행</td>	
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
    	  <td width="50" align="center"><input name="ch_start" type="checkbox" class="style1" value="<%=value_line%>"></td>	
    	  <% for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td width="<%=v_td_width%>" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j))%>"size="13"></td>
    	  <%}%>
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
    <td align="left"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
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