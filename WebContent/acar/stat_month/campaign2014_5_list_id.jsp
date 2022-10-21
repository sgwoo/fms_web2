<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.stat_bus.*"%>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String user_nm 	= request.getParameter("user_nm")	==null?"":request.getParameter("user_nm");
	String bus_id 	= request.getParameter("bus_id")	==null?"":request.getParameter("bus_id");
	String cs_dt 	= request.getParameter("cs_dt")		==null?"":AddUtil.ChangeString(request.getParameter("cs_dt"));
	String ce_dt 	= request.getParameter("ce_dt")		==null?"":AddUtil.ChangeString(request.getParameter("ce_dt"));
	String bs_dt 	= request.getParameter("bs_dt")		==null?"":AddUtil.ChangeString(request.getParameter("bs_dt"));
	String be_dt 	= request.getParameter("be_dt")		==null?"":AddUtil.ChangeString(request.getParameter("be_dt"));	
	
	
	Vector vt = cmp_db.getStatBusCmpBaseBusList_2014_05(bus_id, "c", bs_dt, be_dt, cs_dt, ce_dt);
	
	
	float cnt3 	= 0.0f;
	float cnt4	= 0.0f;
	float v_cnt4 	= 0.0f;
		
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body>
<table width="1050" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <table width=100% border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
          <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > 영업캠페인 > <span class=style5>영업캠페인 실적</span></span></td>
          <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td class=h></td>
  </tr>
  <tr> 
    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=user_nm%></span></td>
  </tr>
  <tr>
    <td class=line2></td>
  </tr>
  <tr> 
    <td width="100%" class="line">
      <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td width="30" class="title">연번</td>
          <td width="55" class="title">계약구분</td>		  
          <td width="95" class="title">계약번호</td>
          <td width="210" class="title">상호</td>
          <td width="70" class="title">거래시작일</td>
          <td width="65" class="title">구분</td>
          <td width="50" class="title">최초<br>계약자</td>
          <td width="50" class="title">영업<br>대리인</td>
          <td width="50" class="title">영업<br>담당자</td>		  		  
          <td width="30" class="title">영업<br>사원</td>		  		  
          <td width="40" class="title">대여<br>구분</td>		  		  
          <td width="30" class="title">계약<br>개월</td>		  		  		            
          <td width="70" class="title">대여개시일</td>
          <td width="70" class="title">해지일</td>		  
          <td width="45" class="title">본인<br>영업<br>대수</td>
          <td width="45" class="title">유효<br>실적</td>
          <td width="45" class="title">적용<br>실적</td>		  
        </tr>
        <%	if(vt.size()>0){
			for(int i=0; i<vt.size(); i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
        <tr> 
          <td align="center"><%= i+1 %></td>
          <td align="center"><%= ht.get("GUBUN") %></td>
          <td align="center"><%= ht.get("RENT_L_CD") %></td>
          <td>&nbsp;<%= ht.get("FIRM_NM") %></td>
          <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("FIRST_RENT_START_DT")) %></td>          
          <td align="center"><%= ht.get("GUBUN2") %></td>		  
          <td align="center"><%= ht.get("BUS_NM") %><%if(String.valueOf(ht.get("BUS_NM")).equals("")){%><%=c_db.getNameById(String.valueOf(ht.get("F_BUS_ID")),"USER")%><%}%></td>
          <td align="center"><%= ht.get("BUS_AGNT_NM") %></td>		  
          <td align="center"><%= ht.get("BUS_NM2") %></td>		  		  
          <td align="center"><%= ht.get("BUS_EMP_ID_YN") %></td>		  		  
          <td align="center"><%= ht.get("RENT_WAY_NM") %></td>		  		  		  
          <td align="center"><%= ht.get("CON_MON") %></td>		  		  		            
          <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("RENT_START_DT")) %></td>
          <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("CLS_DT")) %></td>		            
          <td align="center"><%= ht.get("CC_CNT3") %></td>
          <td align="center"><%= ht.get("CC_CNT4") %></td>
          <td align="center"><%= ht.get("RR_CNT4") %></td>
        </tr>
        <% 			cnt3 	= cnt3	+ AddUtil.parseFloat((String)ht.get("CC_CNT3"));
				cnt4 	= cnt4 	+ AddUtil.parseFloat((String)ht.get("CC_CNT4"));
				v_cnt4 	= v_cnt4+ AddUtil.parseFloat((String)ht.get("RR_CNT4"));				
			}
	%>
        <tr> 
          <td colspan="14" class="title">&nbsp;</td>          
          <td align="center"><%= AddUtil.parseFloatCipher(cnt3,2) %></td>
          <td align="center"><%= AddUtil.parseFloatCipher(cnt4,2) %></td>
          <td align="center"><%= AddUtil.parseFloatCipher(v_cnt4,2) %></td>
        </tr>
        <%	}else{	 %>
        <tr> 
          <td colspan="16"><div align="center">해당 데이터가 없습니다.</div></td>
        </tr>
        <% 	} %>				
            </table>
    </td>
    </tr>
</table>
<p>
  <font color="#999999" style="font-size : 9pt;">
  <br>
  ♣ 캠페인 영업대수 적용실적 = 개인 적용실적합계 * 총실적부서별합계 / 적용실적부서별합계 
  <br>
  ♣ 캠페인 마감 데이타입니다. 실시간 데이타와 틀릴 수 있습니다.
  <!--
  <br>  
  ♣ 출고전해지건 : 전기계약후 당기해지시 유효실적 차감. 
  <br>
  ♣ 영업대리인 : 영업대리인이 있는 경우 최초영업자는 0.75, 영업대리인은 0.25를 실적인정.(2011년03월23일 이전 계약)
  <br>  
  ♣ [2011-03-30 공지] 영업대리인 실적이관 비율 상향 조정 : 2011년03월23일 계약건 부터 영업대리인에게 대수 1대 전체를 주고, 최초영업자는 영업효율을 100% 갖는다.
  <br>   
  ♣ 영업담당자 : 일반식 대여개시후 만 1년이 지난 업체에서  일반식 증차,대차,연장계약을 했을 때 계약서를 쓴 사람(FMS상 최초영업자)과 
  <br>
  &nbsp;&nbsp;&nbsp;그 차량을 관리할 사람(FMS상 영업담당자)이 다를 경우에는 캠페인 실적중 영업대수 0.5대를, FMS상 영업담당자에게 넘긴다.(적용시점: 11월 12일 계약건 부터)
  <br>  
  ♣ [2010-07-15 공지] 영업대수 카운터 기준 변경 : 6개월~11개월 계약시 0.5대 / 12개월이상 계약시 1대로 카운트 됩니다.
  <br> 
  ♣ 유효실적
  <br> 
  &nbsp;&nbsp;&nbsp;① 재리스 1.5배
  <br> 
  &nbsp;&nbsp;&nbsp;② 대량수요의 경우 5대 초과 분은 50%로 할인하고 동일업체에 대해 최대 10대까지 실적인정.
  <br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(예: 1대:1, 2대:2, 3대:3, 4대:4, 5대:5, 6대:5.5, 7대:6, 8대:6.5, 9대:7, 10대:7.5, 11대:8, 12대:8.5, 13대:9, 14대:9.5, 15대:10..) 
  <br> 
  &nbsp;&nbsp;&nbsp;③ 대량수요의 경우 신차와 재리스가 동일일자에 있는 경우 재리스를 우선 카운트한다.
  <br> 
  &nbsp;&nbsp;&nbsp;④ 대량수요의 경우 그중 일부가 출고전해지 및 개시전해지를 했을 경우 해지분은 나중에 입력한것으로 본다.  
  <br> 
  -->
  <br>  
  ♣ 대여개시일 기준으로 실적이 카운트됩니다.
  <br>  
  ♣ 본인영업대수 : 최초계약자 기준, 6개월 이상 계약만 1대로 카운트
  <br> 
  ♣ 유효실적
  <br> 
  &nbsp;&nbsp;&nbsp;- 신차 : 영업사원이 있으면 1대, 자체영업 2대, 플러그하이브리드 +1대, 전기 +2대, 신규는 +0.5대(신규 다수시 1대만 증가)
  <br> 
  &nbsp;&nbsp;&nbsp;- 재리스 : 24개월이상 2대, 12개월 이상 1.5대, 6~11개월 1대
  <br>
  &nbsp;&nbsp;&nbsp;- 연장 : 6개월 이상 0.5대
  <br> 
  &nbsp;&nbsp;&nbsp;※ 대량수요처 (캠페인 기간내 6대 이상 대여개시 고객) : 5대 초과 분은 50%로 할인하고 동일업체에 대해 최대 15번째 대여개시 건까지 실적 인정
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(① 대여개시일 순서로 5대까지는 100%, 6~15대는 50% 적용  ② 신차와 재리스가 동일일자에 있는 경우 재리스를 우선 카운트한다.)
  <br> 
  &nbsp;&nbsp;&nbsp;- 월렌트 : 신규 1대, 1개월이상 연장 0.2대, 1개월미만 연장 0.1대
  <br>   
  ♣ 적용실적
  <br> 
  &nbsp;&nbsp;&nbsp;- 최초영업자 : 아래의 경우 유효실적중 해당자에게 주고 남는 부분은 최초영업자에 귀속됨(적용실적이 마이너스가 되는 경우는 없음)
  <br> 
  &nbsp;&nbsp;&nbsp;- 영업대리인 : 1대 실적인정
  <br>
  &nbsp;&nbsp;&nbsp;- 관리담당자 : 대여개시후 1년 이상된 고객이 증차,대차,연장계약 했을 경우
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;① 일반식 : 유효실적중 1대 관리담당자에 귀속
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;② 기본식 : 유효실적중 0.5대 관리담당자에 귀속
  <br> 
  &nbsp;&nbsp;&nbsp;※ 대여개시후 1년이상된 업체의 증차,대차,연장계약에서 영업대리인이 있는 경우
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;① 영업대리인과 관리담당자가 다른 경우 : 유효실적을 영업대리인 50%, 관리담당자 50%로 나누어 귀속시킨다.
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;② 영업대리인과 관리담당자가 동일한 경우에는 100% 영업대리인(=관리담당자)에게 귀속된다.
  <br> 
  &nbsp;&nbsp;&nbsp;- 월렌트 : 신규계약은 최초영업자 실적이 되며, 연장계약은 관리담당자 실적이 됨
  <br> 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(영업대리인이 있는 경우 유효실적을 최초영업자 50%, 영업대리인 50%로 나누어 귀속시킨다.)
  <br>
  </font>    
</p>
</body>
</html>
