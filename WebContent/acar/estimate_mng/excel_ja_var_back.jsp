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
						
			double numberb2 = 0; 
			
			//숫자데이터일때 Float 인것 (소숫점3자리 이상 처리위해)
			if ( ( j==5 || (j>6 && j<13) || (j>14 && j<19) || j==20 || j==21 || j==37 || j==38 || (j>40 && j<44) || (j>44 && j<48) || j==53 || (j>55 && j<65) ||  (j>67 && j<73)  || j==83 || (j>87 && j<92) || j>160) 
			     && 
			     cell.getType() == CellType.NUMBER
			   ) { 
				
  				NumberCell nc = (NumberCell) cell; 
  				numberb2 = nc.getValue(); 
  				
  				ht.put(Integer.toString(j), String.valueOf(numberb2));
			}else{
				
				ht.put(Integer.toString(j), cell.getContents());
			} 
			
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
<link rel=stylesheet type="text/css" href="../../include/table.css">
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
		//fm.action = 'https://fms3.amazoncar.co.kr/acar/admin/excel_ja_var_a.jsp';
		fm.action = 'excel_ja_var_a.jsp';
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
    <td>&nbsp;</td>
  </tr>      
  <tr>
      <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
              <tr>    	  
    	          <td width="150" height="30" class="title">기준일자</td>
    	          <td>&nbsp;<input name="reg_dt" type="text" class=text value="<%=AddUtil.getDate()%>"size="18" style1></td>
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
          <td width="120" class="title">0 차종코드</td>
          <td width="120" class="title">1 제조사</td>
          <td width="120" class="title">2 차명</td>
          <td width="120" class="title">3 신차판매여부</td>
          <td width="120" class="title">4 적용일자</td>
          <td width="120" class="title">5 현시점차량<br>24개월잔가율</td>
          <td width="120" class="title">6 일반승용<br>LPG여부</td>
          <td width="120" class="title">7 기본특소세율</td>
          <td width="120" class="title">8 납부시점특소세율</td>
          <td width="120" class="title">9 최저잔가율<br>조정승수</td>
          <td width="120" class="title">10 환경변수<br>(36개월효과기분)</td>
          <td width="120" class="title">11 재리스환경변수</td>
          <td width="120" class="title">12 기본차량<br>잔가율승수</td>
          <td width="120" class="title">13 기본차량<br>가격</td>
          <td width="120" class="title">14 초과차량가격<br>잔가율승수</td>
          <td width="120" class="title">15 선택사양가격<br>잔가율승수</td>
          <td width="120" class="title">16 선택사양포함차량<br>가격잔가율승수</td>
          <td width="120" class="title">17 g1, g2 결정변수</td>
          <td width="120" class="title">18 리스크조절변수</td>
          <td width="120" class="title">19 신차판매여부</td>
          <td width="120" class="title">20 표준주행거리초과1만km당중고차가조정율(낙찰가,재리스잔존가관련)</td>
          <td width="120" class="title">21 표준주행거리초과1만km당중고차가조정율(약정운행거리관련)</td>
          <td width="120" class="title">22 차종분류코드</td>
          <td width="120" class="title">23 디젤차여부</td>
          <td width="120" class="title">24 배기량</td>
          <td width="120" class="title">25 탁송료(서울)</td>
          <td width="120" class="title">26 탁송료(부산)</td>
          <td width="120" class="title">27 탁송료(대전)</td>		  
          <td width="120" class="title">28 탁송료(대구)</td>
          <td width="120" class="title">29 탁송료(광주)</td>		  
          <td width="120" class="title">30 tuix탁송료(서울)</td>
          <td width="120" class="title">31 tuix탁송료(부산)</td>
          <td width="120" class="title">32 tuix탁송료(대전)</td>		  
          <td width="120" class="title">33 tuix탁송료(대구)</td>
          <td width="120" class="title">34 tuix탁송료(광주)</td>		  
          <td width="120" class="title">35 LPG키트종류</td>
          <td width="120" class="title">36 직접분사LPG키트비용</td>		  
          <td width="120" class="title">37 영업직원수당율렌트</td>
          <td width="120" class="title">38 영업직원수당율리스</td>
          <td width="120" class="title">39 렌트운영여부</td>
          <td width="120" class="title">40 리스운영여부</td>
          <td width="120" class="title">41 할부이자율12/24개월</td>
          <td width="120" class="title">42 할부이자율36개월</td>
          <td width="120" class="title">43 할부이자율48개월이상</td>
          <td width="120" class="title">44 대차서비스제공</td>		  
          <td width="120" class="title">45 환경개선부담금부담율</td>
          <td width="120" class="title">46 자체출고효율D-대리점수수료율</td>		  
          <td width="120" class="title">47 자체출고효율E-영업사원지급요율</td>		  
          <td width="120" class="title">48 자체출고효율G-추가금액</td>				    		  		  		  		  		  		  	
          <td width="120" class="title">49 리무진여부</td>		
          <td width="120" class="title">50 단기대여구분</td>		
          <td width="120" class="title">51 주행거리무제한가능여부</td>		
          <td width="120" class="title">52 정비비용제한차종</td>		
          <td width="120" class="title">53 카드리베이트율</td>				  
          <td width="120" class="title">54 월렌트차명</td>				  
          <td width="120" class="title">55 수입차 여부</td>		
          <td width="120" class="title">56 출고보전수당지급율</td>		          
          <td width="120" class="title">57 특판DC율</td>		          
          <td width="120" class="title">58 자차보험승수/td>		          
          <td width="120" class="title">59 신차 단기마진율조정치</td>
          <td width="120" class="title">60 0개월잔가산정을 위한 신차DC율</td>		          
          <td width="120" class="title">61 자체영업비중</td>
          <td width="120" class="title">62 사고수리비 반영관련 차종승수</td>
          <td width="120" class="title">63 재리스잔존가 산출 승수</td>
          <td width="120" class="title">64 일반식 관리비 조정 승수</td>
          <td width="120" class="title">65 친환경차 구분</td>
          <td width="120" class="title">66 정부보조금 지급여부</td>
          <td width="120" class="title">67 0개월잔가 적용방식 구분</td>
          <td width="120" class="title">68 0개월 기준잔가 조정율</td>
          <td width="120" class="title">69 일반승용LPG 현시점 차령60개월 이상일 경우 잔가 조정율</td>
          <td width="120" class="title">70 일반승용LPG 종료시점 차령60개월 이상일 경우 잔가 조정율</td>
          <td width="120" class="title">71 1000km당 중고차가 조정율 반영승수(약정운행거리 계약시)</td>
          <td width="120" class="title">72 재리스 단기 마진율 조정치&nbsp;</td>
          <td width="120" class="title">73 전기차 정부보조금&nbsp;</td>
          <td width="120" class="title">74 저공해 스티커 발급대상(해당1)&nbsp;</td>
          <td width="120" class="title">75 승차정원&nbsp;</td>
          
          <!-- 수출효과 과련 컬럼추가(20180528) -->
          <td width="120" class="title">76 수출효과 대상 차종구분(해당1)</td>
          <td width="120" class="title">77 수출가능연도-신차등록연도</td>
          <td width="120" class="title">78 수출효과 반감기간(년)X2</td>
          <td width="120" class="title">79 수출불가사양</td>
          <td width="120" class="title">80 신차 수출가능견적 대여만료일(일자)(10월31일 대여만료기준, 10월31일 - 1월1일)</td>
          <td width="120" class="title">81 신차 출고 납기일수 + 7일</td>
          <td width="120" class="title">82 신차 수출효과 최대값(대여 만료일기준)</td>
          <td width="120" class="title">83 신차 주행거리 상쇄효과 반영율(수출확률과 비례관계)</td>
          <td width="120" class="title">84 수출가능한 신차등록년도 시작일(현시점)</td>
          <td width="120" class="title">85 재리스 수출가능견적 대여만료일(일자)(10월31일 대여만료기준, 10월10일 - 1월1일)</td>
          <td width="120" class="title">86 수출효과 최대값(현시점)</td>
          <td width="120" class="title">87 수출효과 최대값(재리스 종료시점)</td>
          <td width="120" class="title">88 재리스 주행거리 상쇄효과 반영율(수출확률과 비례관계)</td>
          <td width="120" class="title">89 수출불가 사고금액 기준율(신차가 대비, 1위사고기준)</td>
          <td width="120" class="title">90 매입옵션있는 신차 연장견적시 수출효과 적용율</td>
          <td width="120" class="title">91 매입옵션있는 재리스 연장견적시 수출효과 적용율</td>
          <td width="120" class="title">92 신차 장기렌트 홈페이지 인기차종(국산/수입) 인기1</td>
          <td width="120" class="title">93 신차 리스 홈페이지 인기차종(국산/수입) 인기1</td>
          <td width="120" class="title">94 단기대여구분(대차료 청구용)</td>
          <td width="120" class="title">95&nbsp;</td>
          
          <td width="120" class="title">96 코드</td>	
          <td width="120" class="title">97 참고값</td>
          <td width="120" class="title">98 이름1</td>
          <td width="120" class="title">99 내수적용값(48개월기준)</td>
          <td width="120" class="title">100 수출기준차령(개월)</td>
          <td width="120" class="title">101 수출적용값(기준차령)</td>
          <td width="120" class="title">102 수출적용값반감기</td>
          <td width="120" class="title">103 신차기준차령(개월)</td>
          <td width="120" class="title">104 신차견적적용값(기준차령)</td>
          <td width="120" class="title">105 신차견적비고란설명문(직원전용)</td>
          <td width="120" class="title">106 신차견적비고란설명문(고객.직원전용)</td>
          <td width="120" class="title">107 이름2</td>
          <td width="120" class="title">108 내수적용값(48개월기준)</td>
          <td width="120" class="title">109 수출기준차령(개월)</td>
          <td width="120" class="title">110 수출적용값(기준차령)</td>
          <td width="120" class="title">111 수출적용값반감기</td>
          <td width="120" class="title">112 신차기준차령(개월)</td>
          <td width="120" class="title">113 신차견적적용값(기준차령)</td>
          <td width="120" class="title">114 신차견적비고란설명문(직원전용)</td>
          <td width="120" class="title">115 신차견적비고란설명문(고객.직원전용)</td>
          <td width="120" class="title">116 이름3</td>
          <td width="120" class="title">117 내수적용값(48개월기준)</td>
          <td width="120" class="title">118 수출기준차령(개월)</td>
          <td width="120" class="title">119 수출적용값(기준차령)</td>
          <td width="120" class="title">120 수출적용값반감기</td>
          <td width="120" class="title">121 신차기준차령(개월)</td>
          <td width="120" class="title">122 신차견적적용값(기준차령)</td>
          <td width="120" class="title">123 신차견적비고란설명문(직원전용)</td>
          <td width="120" class="title">124 신차견적비고란설명문(고객.직원전용)</td>
          <td width="120" class="title">125 이름4</td>
          <td width="120" class="title">126 내수적용값(48개월기준)</td>
          <td width="120" class="title">127 수출기준차령(개월)</td>
          <td width="120" class="title">128 수출적용값(기준차령)</td>
          <td width="120" class="title">129 수출적용값반감기</td>
          <td width="120" class="title">130 신차기준차령(개월)</td>
          <td width="120" class="title">131 신차견적적용값(기준차령)</td>
          <td width="120" class="title">132 신차견적비고란설명문(직원전용)</td>
          <td width="120" class="title">133 신차견적비고란설명문(고객.직원전용)</td>
          <td width="120" class="title">134 이름5</td>
          <td width="120" class="title">135 내수적용값(48개월기준)</td>
          <td width="120" class="title">136 수출기준차령(개월)</td>
          <td width="120" class="title">137 수출적용값(기준차령)</td>
          <td width="120" class="title">138 수출적용값반감기</td>
          <td width="120" class="title">139 신차기준차령(개월)</td>
          <td width="120" class="title">140 신차견적적용값(기준차령)</td>
          <td width="120" class="title">141 신차견적비고란설명문(직원전용)</td>
          <td width="120" class="title">142 신차견적비고란설명문(고객.직원전용)</td>
          <td width="120" class="title">143 이름6</td>
          <td width="120" class="title">144 내수적용값(48개월기준)</td>
          <td width="120" class="title">145 수출기준차령(개월)</td>
          <td width="120" class="title">146 수출적용값(기준차령)</td>
          <td width="120" class="title">147 수출적용값반감기</td>
          <td width="120" class="title">148 신차기준차령(개월)</td>
          <td width="120" class="title">149 신차견적적용값(기준차령)</td>
          <td width="120" class="title">150 신차견적비고란설명문(직원전용)</td>
          <td width="120" class="title">151 신차견적비고란설명문(고객.직원전용)</td>
          <td width="120" class="title">152 이름7</td>
          <td width="120" class="title">153 내수적용값(48개월기준)</td>
          <td width="120" class="title">154 수출기준차령(개월)</td>
          <td width="120" class="title">155 수출적용값(기준차령)</td>
          <td width="120" class="title">156 수출적용값반감기</td>
          <td width="120" class="title">157 신차기준차령(개월)</td>
          <td width="120" class="title">158 신차견적적용값(기준차령)</td>
          <td width="120" class="title">159 신차견적비고란설명문</td>
          <td width="120" class="title">160 신차견적비고란설명문</td>
          <td width="120" class="title">161 &nbsp;</td>
          <!--20151001 추가 end-->
          <td width="120" class="title">162 기간별특소세율1</td>
          <td width="120" class="title">163 기간별특소세율2</td>
          <td width="120" class="title">164 기간별특소세율3</td>
          <td width="120" class="title">165 기간별특소세율4</td>
          <td width="120" class="title">166 기간별특소세율5</td>
          <td width="120" class="title">167 기간별특소세율6</td>
          <td width="120" class="title">168 기간별특소세율7</td>
          <td width="120" class="title">169 기간별특소세율8</td>
          <td width="120" class="title">170 기간별특소세율9</td>
          <td width="120" class="title">171 기간별특소세율10</td>
          <td width="120" class="title">172 기간별특소세율11</td>
          <td width="120" class="title">173 기간별특소세율12</td>
          <td width="120" class="title">174 기간별특소세율13</td>
          <td width="120" class="title">175 기간별특소세율14</td>
          <td width="120" class="title">176 기간별특소세율15</td>
          <td width="120" class="title">177 기간별특소세율16</td>
          <td width="120" class="title">178 기간별특소세율17</td>
          <td width="120" class="title">179 기간별특소세율18</td>
          <td width="120" class="title">180 기간별특소세율19</td>
          <td width="120" class="title">181 기간별특소세율20</td>
          <td width="120" class="title">182 기간별특소세율21</td>
          <td width="120" class="title">183 기간별특소세율22</td>
          <td width="121" class="title">184 기간별특소세율23</td>
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
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);
%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=i+1%></td>
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