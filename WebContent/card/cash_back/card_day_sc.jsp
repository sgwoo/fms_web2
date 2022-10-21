<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");

	//카드 일일현황 조회
	Vector vt = CardDb.getCardDayStat(s_yy, s_mm);
	int vt_size = vt.size();
	
	long total_amt0 = 0;
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	
	if(vt_size > 0){
		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			total_amt0 = total_amt0 + AddUtil.parseLong(String.valueOf(ht.get("AMT0")));
			total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
			total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
			total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
			total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
			total_amt6 = total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
			total_amt7 = total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
			total_amt8 = total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
			total_amt9 = total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
			total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
		}
	}
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function Search(){
		var fm = document.form1;
		if(fm.s_yy.value == '2018' && toInt(fm.s_mm.value) < 7){
			alert('2018년7월 이전 데이타는 없습니다.'); return;
		}
		fm.action = "card_day_sc.jsp";
		fm.target = "_self";
		fm.submit();
  }
  
  function CardStatBase(scd_dt, card_kind){
		var fm = document.form1;
		fm.scd_dt.value = scd_dt;
		fm.card_kind.value = card_kind;
		fm.action = "card_day_list.jsp";
		window.open("about:blank", "CardDayList", "left=350, top=50, width=1250, height=800, scrollbars=yes, status=yes");
		fm.target = "CardDayList";
		fm.submit();
  }
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='scd_dt' value=''>
<input type='hidden' name='card_kind' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>일일현황</span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
						<select name="s_yy">
			  			<%for(int i=2018; i<=AddUtil.getDate2(1)+1; i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>
	        			<select name="s_mm">
	          			<%for(int i=1; i<=12; i++){%>
	          				<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>월</option>
	          			<%}%>
	        			</select>             			  
            			  &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					</td>
                </tr>
            </table>
        </td>
    </tr>	  
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='8%' class='title'>사용일자</td>
                    <td width='8%' class='title'>롯데카드</td>
                    <td width='8%' class='title'>광주카드</td>
                    <td width='8%' class='title'>국민카드</td>
                    <td width='8%' class='title'>삼성카드</td>
                    <td width='8%' class='title'>우리비씨</td>
                    <td width='8%' class='title'>신한카드</td>
                    <td width='8%' class='title'>전북카드</td>
                    <td width='8%' class='title'>하나카드</td>
                    <td width='8%' class='title'>현대카드</td>
                    <td width='8%' class='title'>기타</td>
                    <td class='title'>합계</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					      %>
                <tr>
                    <td class='title'><%=ht.get("DAY")%></td>
                    <td align="right"><a href="javascript:CardStatBase('<%=ht.get("SCD_DT")%>', '<%=ht.get("CARD_KIND1")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('<%=ht.get("SCD_DT")%>', '<%=ht.get("CARD_KIND2")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('<%=ht.get("SCD_DT")%>', '<%=ht.get("CARD_KIND3")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('<%=ht.get("SCD_DT")%>', '<%=ht.get("CARD_KIND4")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('<%=ht.get("SCD_DT")%>', '<%=ht.get("CARD_KIND5")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('<%=ht.get("SCD_DT")%>', '<%=ht.get("CARD_KIND6")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT6")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('<%=ht.get("SCD_DT")%>', '<%=ht.get("CARD_KIND7")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT7")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('<%=ht.get("SCD_DT")%>', '<%=ht.get("CARD_KIND8")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT8")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('<%=ht.get("SCD_DT")%>', '<%=ht.get("CARD_KIND9")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT9")))%></a></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT10")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT0")))%></td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title'>합계</td>
                    <td align="right"><a href="javascript:CardStatBase('', '0007')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right"><a href="javascript:CardStatBase('', '0001')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><a href="javascript:CardStatBase('', '0002')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><a href="javascript:CardStatBase('', '0011')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td align="right"><a href="javascript:CardStatBase('', '0016')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                    <td align="right"><a href="javascript:CardStatBase('', '0012')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt6)%></td>
                    <td align="right"><a href="javascript:CardStatBase('', '0017')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt7)%></td>
                    <td align="right"><a href="javascript:CardStatBase('', '0019')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt8)%></td>
                    <td align="right"><a href="javascript:CardStatBase('', '0022')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(total_amt9)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt10)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt0)%></td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="11" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <%if(total_amt10>0){%>
    <tr> 
        <td>※ 기타카드 사용금액 : <%=AddUtil.parseDecimalLong(total_amt10)%>원</td>
    </tr>
    <%}%>
  </table>
</form>
</body>
</html>
