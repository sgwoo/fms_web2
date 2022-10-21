<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	int count = 0;
%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <tr>        
    <td>1. 핵심변수</td>
  </tr>
  <tr>
    <td class=line>            
      <table border=0 cellspacing=1 width=100%>
        <tr> 
          <td class=title width="100">변수기호</td>
          <td class=title width="100">변수코드</td>
          <td class=title width="500" colspan="2">변수명</td>
          <td class=title width="100">변수값</td>
        </tr>
        <tr> 
          <td align="center">F</td>
          <td align="center">a_f</td>
          <td colspan="2">적용이자율</td>
          <td align="right">10%</td>
        </tr>
        <tr> 
          <td align="center" rowspan="4">G</td>
          <td align="center">a_g_1</td>
          <td rowspan="4" width="400">10만원당 월할부금</td>
          <td width="100" align="center">36개월</td>
          <td align="right">3,227</td>
        </tr>
        <tr> 
          <td align="center">a_g_2</td>
          <td width="100" align="center">24개월</td>
          <td align="right">4,615</td>
        </tr>
        <tr> 
          <td align="center">a_g_3</td>
          <td width="100" align="center">18개월</td>
          <td align="right">6,006</td>
        </tr>
        <tr> 
          <td align="center">a_g_4</td>
          <td width="100" align="center">12개월</td>
          <td align="right">8,792</td>
        </tr>
        <tr> 
          <td align="center">⑫</td>
          <td align="center">o_12</td>
          <td colspan="2">특소세 환입율(6개월후)</td>
          <td align="right">82.9%</td>
        </tr>
        <tr> 
          <td align="center">(3)</td>
          <td align="center">g_3</td>
          <td colspan="2">종합보험비용 적용율(현보험료 대비)</td>
          <td align="right">70%</td>
        </tr>
        <tr> 
          <td align="center">(5)</td>
          <td align="center">g_5</td>
          <td colspan="2">자차보험비용 적용율(신설법인보험료대비)</td>
          <td align="right">50%</td>
        </tr>
        <tr> 
          <td align="center">추가ⓑ</td>
          <td align="center">oa_b</td>
          <td colspan="2">대물, 자손 보험 1억 가입시 대여료 인상액</td>
          <td align="right">50%</td>
        </tr>
        <tr> 
          <td align="center">추가ⓒ</td>
          <td align="center">oa_c</td>
          <td colspan="2">만21세이상 운전보험 가입시 대여료 인상1(차가대비)</td>
          <td align="right">50%</td>
        </tr>
        <tr> 
          <td align="center">(8)</td>
          <td align="center">g_8</td>
          <td colspan="2">기본식 기본보증금율</td>
          <td align="right">20%</td>
        </tr>
        <tr> 
          <td align="center" rowspan="3">(9)</td>
          <td align="center">g_9_1</td>
          <td rowspan="3">기본식 목표마진(계약고 대비)</td>
          <td width="100" align="center">36개월</td>
          <td align="right">10%</td>
        </tr>
        <tr> 
          <td align="center">g_9_2</td>
          <td width="100" align="center">24개월</td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr> 
          <td align="center">g_9_3</td>
          <td width="100" align="center"><%if(gubun1.equals("1")) {%>18개월 <%}else{%>12개월 <%}%></td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr> 
          <td align="center">(10)</td>
          <td align="center">g_10</td>
          <td colspan="2">일반식 개시대여료 기본납입 개월수</td>
          <td align="right">3</td>
        </tr>
        <tr> 
          <td align="center" rowspan="3">(11)</td>
          <td align="center">g_11_1</td>
          <td rowspan="3">일반식 목표마진(계약고 대비)</td>
          <td width="100" align="center">36개월</td>
          <td align="right">12%</td>
        </tr>
        <tr> 
          <td align="center">g_11_2</td>
          <td width="100" align="center">24개월</td>
          <td align="right">&nbsp;</td>
        </tr>
        <tr> 
          <td align="center">g_11_3</td>
          <td width="100" align="center">
            <%if(gubun1.equals("1")) {%>
            18개월
            <%}else{%>
            12개월
            <%}%>
          </td>
          <td align="right">&nbsp;</td>
        </tr>
      </table>
        </td>
    </tr>
  <tr>        
    <td>&nbsp;</td>
  </tr>
  <tr>        
    <td>2. 기타변수</td>
  </tr>
  <tr>
    <td class=line>            
      <table border=0 cellspacing=1 width=100%>
        <tr> 
          <td class=title width="100">변수기호</td>
          <td class=title width="100">변수코드</td>
          <td class=title width="500" colspan="2">변수명</td>
          <td class=title width="100">변수값</td>
        </tr>
        <tr> 
          <td align="center" rowspan="2">⑧</td>
          <td align="center">o_8_1</td>
          <td rowspan="2" width="400">채권할인율</td>
          <td width="100" align="center">서울</td>
          <td align="right">20%</td>
        </tr>
        <tr> 
          <td align="center">o_8_2</td>
          <td width="100" align="center">경기</td>
          <td align="right">15%</td>
        </tr>
        <tr> 
          <td align="center" rowspan="2">⑨</td>
          <td align="center">a_9_1</td>
          <td rowspan="2">등록부대비용</td>
          <td width="100" align="center">서울</td>
          <td align="right">69,500</td>
        </tr>
        <tr> 
          <td align="center">a_9_2</td>
          <td width="100" align="center">경기</td>
          <td align="right">99,500</td>
        </tr>
        <tr> 
          <td align="center">⑩</td>
          <td align="center">o_10</td>
          <td colspan="2">공급가대비 대출율</td>
          <td align="right">100%</td>
        </tr>
        <tr> 
          <td align="center">ⓔ</td>
          <td align="center">o_e</td>
          <td colspan="2">견적기준일의 년말일자</td>
          <td align="right">2004-12-31</td>
        </tr>
        <tr> 
          <td align="center">(1)</td>
          <td align="center">g_1</td>
          <td colspan="2">차고지 유지비</td>
          <td align="right">0</td>
        </tr>
      </table>
        </td>
    </tr>
</table>
</body>
</html>