<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	if(gubun1.equals("") && st_dt.equals("") && end_dt.equals("")){
		gubun1 = "1";
	}

	//카드 일일현황 조회
	Vector vt = CardDb.getCardMonStat(gubun1, st_dt, end_dt);
	int vt_size = vt.size();
	
	long total_amt0 = 0;
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	
	if(vt_size > 0){
		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			total_amt0 = total_amt0 + AddUtil.parseLong(String.valueOf(ht.get("AMT0")));
			total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
			total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
			total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT")));
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
		if(fm.gubun1.value == '3' && toInt(fm.st_dt.value) < 20180701){
			alert('2018년7월 이전 데이타는 없습니다.'); return;
		}
		if(fm.gubun1.value == '3' && ( fm.st_dt.value =='' || fm.st_dt.value =='')){
			alert('기간을 입력하십시오.'); return;
		}
		fm.action = "card_mon_sc.jsp";
		fm.target = "_self";
		fm.submit();
  }
  
  function CardStatBase(st, card_kind){
		var fm = document.form1;
		fm.st.value = st;
		fm.card_kind.value = card_kind;
		fm.action = "card_mon_list.jsp";
		window.open("about:blank", "CardMonList", "left=350, top=50, width=1250, height=800, scrollbars=yes, status=yes");
		fm.target = "CardMonList";
		fm.submit();
  }
  
  function CardStatBaseAll(st, card_kind){
		var fm = document.form1;
		fm.st.value = st;
		fm.card_kind.value = card_kind;
		fm.action = "card_mon_list_allup.jsp";
		window.open("about:blank", "CardMonListAll", "left=350, top=50, width=1500, height=800, scrollbars=yes, status=yes");
		fm.target = "CardMonListAll";
		fm.submit();
  }  
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='st' value=''>
<input type='hidden' name='card_kind' value=''>	
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월간현황</span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
						            <select name='gubun1'>
                          <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>당월</option>
                          <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>전월</option>
                          <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>기간</option>
                        </select>
            			      &nbsp;&nbsp;&nbsp;
            			      <input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                                ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
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
                    <td width='5%' rowspan='2' class='title'>연번</td>
                    <td width='12%' rowspan='2' class='title'>거래처</td>
                    <td colspan='4' class='title'>사용현황</td>
                    <td width='12%' rowspan='2' class='title'>적립금 수금액</td>
                    <td width='15%' rowspan='2' class='title'>점유비<br>(구매자금사용금액)</td>
                </tr>
                <tr>
                    <td width='12%' class='title'>구매자금</td>
                    <td width='12%' class='title'>업무용 등</td>
                    <td width='12%' class='title'>국세/지방세</td>
                    <td width='15%' class='title'>합계</td>
                </tr>                
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            float incom_per	= AddUtil.parseFloat(String.valueOf(ht.get("AMT1")))/AddUtil.parseFloat(String.valueOf(total_amt1))*100;
					      %>
                <tr>
                    <td class='title'><%=i+1%></td>
                    <td align="center"><%=ht.get("CARD_KIND_NM")%></td>
                    <td align="right"><a href="javascript:CardStatBase('1', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('2', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('3', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('4', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT0")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBaseAll('5', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("INCOM_AMT")))%></a></td>
                    <td align="center"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per),2)%>%</td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title' colspan='2'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt0)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td align="center">100%</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="8" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
        <td>※ 점유비가 높은 순서</td>
    </tr>       
    <tr> 
        <td>※ 업무용 등 : 자동차보험료, 광고비, 차량정비비, 통신비, 지급수수료, 임직원업무카드</td>
    </tr>       
  </table>
</form>
</body>
</html>
