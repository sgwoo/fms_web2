<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
%>

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

  <table border="0" cellspacing="0" cellpadding="0" width="750">
   <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업효율 > <span class=style5>설명문</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>    
    </tr>
    <tr>
        <td class=h></td>
    </tr>        
    <tr>
      <td>&nbsp;</td>
    </tr>  
<%	int num = 1;%>
  <tr> 
  	  <td><%=num%>. 영업대수 : 6개월 이상 계약 기준</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 6개월 미만 계약건 : 총계약개월수와 영업효율 값에만 반영</td>
  </tr>
<%	num++;%>
  <tr> 
  	  <td><%=num%>. 적용 재리스차량 수리비는 실 재리스차량 수리비의 50% </td>
  </tr>
<%	num++;%>
  <tr> 
  	  <td><%=num%>. 메이커 추가탁송비용 = 실 지불 메이커 탁송료 - 견적프로그램상의 메이커 탁송료</td>
  </tr>
<%	num++;%>
  <tr> 
  	  <td><%=num%>. 메이커 추가D/C : 견적에만 반영 (2017년8월부터 추가 영업효율 미반영) </td>
  </tr>
  <!--
  <tr> 
  	  <td><%=num%>. 평가적용 위약금 면제금액 = 이전차 위약금 면제금액 - 신계약 월대여료총액의 3% ((계약월대여료*계약기간+선납금)*3%) </td>
  </tr>
  -->
<%	num++;%>
  <tr> 
  	  <td><%=num%>. 신차정산/재리스정산/연장정산</td>
  </tr>
  <tr> 
  	  <td>&nbsp;&nbsp;&nbsp; * 중도해지의 경우에는 계약시 적용되었던 영업효율이 다 실현될 수 없으므로, 중도해지 시점에 영업효율을 다시 산출하여  </td>
  </tr>
  <tr> 
  	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;정산함 </td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 정산 영업효율 = 실이용기간 영업효율 - 계약기간 영업효율</td>
  </tr>
<%	num++;%>
  <tr>
    <td><%=num%>. 추가이용 (영업효율)
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 계약서를 작성하지 않고 추가로 이용한 기간에 대해서는 최종 해지일에 실제 이용한 기간 만큼의 영업효율을 반영해줌</td>
  </tr>
<%	num++;%>
  <tr>
    <td><%=num%>. 해지정산금
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 해지정산금발생 = 해지 시점에 받아야 할 금액 - 위약금</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> = 과태료/범칙금, 채권회수비용, 차량회수비용, 면책금, 연체이자, 연체대여료 등</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> 위약금은 신차정산/재리스정산/연장정산에서 다 반영된 셈이므로 여기서는 빠짐</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 해지정산금수금 = 위약금을 포함한 실 수금액</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ->  신차정산/재리스정산/연장정산에서 마이너스 처리되었던 부분을 여기서 위약금을 받아 플러스로 되돌리는 효과 발생</td>
  </tr>
<%	num++;%>
  <tr>   
  	  <td><%=num%>. 영업효율이 귀속되는 담당자 </td>
  </tr>  
  <tr> 
  	  <td>&nbsp;&nbsp;&nbsp; * 추가이용 : 현재 영업담당자 </td>
  </tr>
  <tr> 
  	  <td>&nbsp;&nbsp;&nbsp; * 계약승계수수료 : 계약승계 계약담당자</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 위 두가지를 제외한 모든 영업효율은 최초영업자(연장계약은 연장 계약담당자)에게 귀속됨 </td>
  </tr>
<%	num++;%>
  <tr>
    <td><%=num%>. 평가반영 기준일</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 신차/재리스/연장 - 대여개시일</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 신차정산/재리스정산/연장정산/추가이용 - 해지일자</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 계약승계수수료 - 승계일자</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 해지정산금발생 - 해지일자</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 해지정산금수금 - 수금일자</td>
  </tr>
<%	num++;%>
  <tr>
    <td><%=num%>. 중도해지 위약금 감액분 발생시 (영업팀장 결재 사항)</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 대차계약을 이유로 중도해지 위약금을 감액해 줄 경우	</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> 원계약의 최초영업자와 대차계약의 최초영업자가 같은 경우 : 일반적인 해지정산금 발생/수금의 경우와 동일하게 처리</td>
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> 원계약의 최초영업자와 대차계약의 최초영업자가 다른 경우 : 위약금 감액분 만큼을 대차계약 최초영업자 영업효율에서 차감</td>
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp; * 기타의 이유로 중도해지 위약금을 감액해 줄 경우</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -> 기본적으로는 일반적인 해지정산금 발생/수금의 경우와 동일하게 처리하되,</td>
  </tr>  
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  특수한 사유가 있는 경우 영업팀장이 판단하여 현재 영업담당자에게 귀속시킬 수 있음</td>
  </tr>    
<%	num++;%>
  <tr>
    <td><%=num%>. 모든 영업효율의 평가는 2009-01-01 이후 대여개시된 건에만 적용</td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (단, ①계약승계수수료는 대여개시일 따지지 않음 ②추가이용 정산은 2009-01-01 이후 계약만기 건은 평가 반영)  
    </td>
  </tr>
  </table>
</form>
</body>
</html>
