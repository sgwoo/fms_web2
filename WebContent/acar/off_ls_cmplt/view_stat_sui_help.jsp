<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">

  <table border="0" cellspacing="0" cellpadding="0" width="100%">
   <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>현황 및 통계 > 매각관리 > <span class=style5>매각차량잔가손익현황 설명문</span></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>    
    </tr>
    <tr>
        <td class=h></td>
    </tr>        
  <tr> 
  	  <td>※ 매각차량 잔가 손익 분석대상에서 제외</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 1. 차종변경 : 리스트에서 제외</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 2. 계약승계 : 리스트에서 제외</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 3. 계약은 존재하나 적용잔가 0 : 리스트에서 제외</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 4. 폐차사고 해지 차량 : 리스트에는 있으나 분석대상에서 제외</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 5. 업무대여 차량 : 리스트에서 제외 (나간 이력이 있는 차량도)</td>
  </tr>
    <tr>
        <td class=h></td>
    </tr>      
  <tr> 
  	  <td>※ 매각차량 잔가 손익 분석 리스트 필터 설정 </td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 1. 폐차사고 해지 해당시 분석대상에서 제외 -> 폐차사고해지 미해당으로 필터 설정</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 2. 신차등록일 2009년1월1일보다 크거나 같음으로 필터 설정</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 3. 미포함 대여기간 12개월보다 작거나 같음만 분석 필터 설정</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 4. 매각년월일 201301보다 크거나 같음으로 필터 설정</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 5. 일반승용 LPG여부 전체 / 1.해당 / 0.미해당 으로 구분하여 분석</td>
  </tr>
    <tr>
        <td class=h></td>
    </tr>      
  <tr> 
  	  <td>※ 잔가 총손익 : 재리스손익+연장손익+매각손익+초과운행대여료발생-매각수수료</td>
  </tr>
  <tr> 
  	  <td>※ 잔가손익 합계 : 재리스손익1+재리스손익2+연장손익+매각손익 </td>
  </tr>
  <tr> 
  	  <td>※ 초과운행 대여료 합계 : 해지정산서상의 초과운행대여료 공급가 × 1.1, 해지정산금 일부수금시 초과운행대여료 수금 항목만 추출 불가하므로, 발생값으로 대체 (받을 채권으로 인식)</td>
  </tr>
    <tr> 
  	  <td>※ 매각수수료 합계 (낙찰/출품/재출품수수료/중개수수료/탁송료) : 경매장 매각수수료 합계 (자산양수도시 중개수수료가 있을 경우에도 중개수수료도 합산)</td>
  </tr>  
  <tr> 
  	  <td>※ 적용잔가 재계산없는 임의연장 기간 : 추가이용효율 등록(대여만료일 이후 임의연장후 계약만료)이나 임의연장효율등록건(대여만료일이후 임의연장후 연장계약)에서 <br>&nbsp;&nbsp;&nbsp;적용잔가를 계산하지 않은 계약의 경우 실제대여기간과 계약상 대여기간의 차이를 합산하여 표기</td>
  </tr>  
  <tr> 
  	  <td>※ 월렌트 대여기간 : 월렌트 대여기간 있으면 대여기간 총개월수 표기 </td>
  </tr>
  <tr> 
  	  <td>※ 대여만료일 : 실제 계약만료 또는 중도해지일  </td>
  </tr>
  <tr> 
  	  <td>※ 매입옵션 있는 신차/재리스 연장 실제대여기간 : (실제 대여만료일- 대여개시일)/365*12 이다  </td>
  </tr>
    <tr>
        <td class=h></td>
    </tr> 
  <tr> 
  	  <td>※ 적용잔가 참조 DATA :  </td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 1. 계약만료시 적용잔가</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 2. 중도해약시 적용잔가 (중도해약시 재계산)</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 3. 추가이용효율 재계산 (임의연장 후 계약만료)</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 4. 임의연장효율 재계산 (임의연장 후 연장계약)</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 5. 중고차 자산양수시 중고차 매매금액</td>
  </tr>    
    <tr>
        <td class=h></td>
    </tr>                     
  <tr> 
  	  <td>※ 적용잔가  </td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 1. 계약구분이 계약만료일 경우 계약 적용잔가</td>
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 2. 중도해약일 경우 중도정산 영업효율에서 사용하고 있는 중도해약일 기준 적용잔가</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 3. 매입옵션있는 신차 연장건의 경우 연장 계약의 적용잔가</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 4. 임의연장후 계약만료건의 경우 경영정보 > 영업효율관리 > 추가이용효율등록의 만료일의 적용잔가</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; 5. 임의연장후 연장건의 경우 영업지원 > 계약관리 > 경영정보 > 영업효율관리 > 임의연장효율등록의 연장대여개시일기준의 적용잔가</td>
  </tr>
  <tr>
        <td class=h></td>
    </tr>                     
  <tr> 
  	  <td>※ 최종계약 : 신차, 신차연장, 재리스, 재리스연장  </td>
  </tr>
  <tr> 
  	  <td>※ 매각방식 (경매/매입옵션) : 매입옵션행사시 계약매입옵션이 매도가, 손익은0 </td>
  </tr>
  <tr> 
  	  <td>※ 매각손익 (최종 계약 적용잔가 기준) :계약만료일 경우 최종 계약 적용잔가를, 중도해약일 경우 중도정산 영업효율에서 사용하고 있는 중도해약일 기준 최종 계약 적용잔가를 기준으로 손익을 따진다  </td>
  </tr>
  <tr> 
  	  <td>※ 주행거리 : 경매건은 경매낙찰현황의 주행거리 사용하고 매입옵션 건은 예상주행거리 사용 </td>
  </tr>
  </table>
</form>
</body>
</html>
