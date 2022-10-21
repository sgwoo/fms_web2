<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	Vector vts = CardDb.getCardHoldStat();
	int vt_size = vts.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	//카드내용보기
	function CardMngUpd(cardno){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.action = "card_mng_u.jsp";
		window.open("about:blank", "CardMngView", "left=50, top=50, width=600, height=550, scrollbars=yes, status=yes");
		fm.target = "CardMngView";
		fm.submit();
	}
	//카드폐기처리하기
	function CardMngDel(cardno){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.action = "card_mng_d.jsp";
		window.open("about:blank", "CardMngView", "left=50, top=50, width=600, height=550, scrollbars=yes, status=yes");
		fm.target = "CardMngView";
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='cardno' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr><td class = line2></td></tr>
    <tr>
      <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='5%' rowspan="2" class='title'>연번</td>
            <td width='10%' rowspan="2" class='title'>카드종류</td>
            <td colspan="4" class='title'>합계</td>
            <td colspan="4" class='title'>본사</td>
            <td colspan="4" class='title'>부산지점</td>
            </tr>
          <tr>
            <td width="7%" class='title' style='height:36'>구매<br>자금용</td>
            <td width="7%" class='title'>공용</td>
            <td width="7%" class='title'>임직원<br>지급용</td>
            <td width="7%" class='title'>소계</td>
            <td width="7%" class='title'>구매<br>
              자금용</td>
            <td width="7%" class='title'>공용</td>
            <td width="7%" class='title'>임직원<br>
              지급용</td>
            <td width="7%" class='title'>소계</td>
            <td width="7%" class='title'>구매<br>
            자금용</td>
            <td width="7%" class='title'>공용</td>
            <td width="7%" class='title'>임직원<br>
            지급용</td>
            <td width="7%" class='title'>소계</td>
          </tr>
		  <%int cnt[] = new int[12];
			if(vt_size > 0){%>
          <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vts.elementAt(i);
					cnt[0]  += AddUtil.parseInt(String.valueOf(ht.get("CNT01")));
					cnt[1]  += AddUtil.parseInt(String.valueOf(ht.get("CNT02")));
					cnt[2]  += AddUtil.parseInt(String.valueOf(ht.get("CNT03")));
					cnt[3]  += AddUtil.parseInt(String.valueOf(ht.get("CNT00")));
					cnt[4]  += AddUtil.parseInt(String.valueOf(ht.get("CNT11")));
					cnt[5]  += AddUtil.parseInt(String.valueOf(ht.get("CNT12")));
					cnt[6]  += AddUtil.parseInt(String.valueOf(ht.get("CNT13")));
					cnt[7]  += AddUtil.parseInt(String.valueOf(ht.get("CNT10")));
					cnt[8]  += AddUtil.parseInt(String.valueOf(ht.get("CNT21")));
					cnt[9]  += AddUtil.parseInt(String.valueOf(ht.get("CNT22")));
					cnt[10] += AddUtil.parseInt(String.valueOf(ht.get("CNT23")));
					cnt[11] += AddUtil.parseInt(String.valueOf(ht.get("CNT20")));
					%>
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><%=ht.get("CARD_KIND")%></td>
            <td align="center"><%=ht.get("CNT01")%></td>
            <td align="center"><%=ht.get("CNT02")%></td>
            <td align="center"><%=ht.get("CNT03")%></td>
            <td align="center" class=is><%=ht.get("CNT00")%></td>
            <td align="center"><%=ht.get("CNT11")%></td>
            <td align="center"><%=ht.get("CNT12")%></td>
            <td align="center"><%=ht.get("CNT13")%></td>
            <td align="center" class=is><%=ht.get("CNT10")%></td>
            <td align="center"><%=ht.get("CNT21")%></td>
            <td align="center"><%=ht.get("CNT22")%></td>
            <td align="center"><%=ht.get("CNT23")%></td>
            <td align="center" class=is><%=ht.get("CNT20")%></td>
            <%	}%>		
          <tr align="center">
            <td colspan="2" class="title">합계</td>
			<%for(int i = 0; i<12; i++){%>
            <td class="title"><%=cnt[i]%></td>
			<%}%>
            </tr>
          <%}else{%>	
          <tr align="center">
            <td colspan="14">등록된 데이타가 없습니다.</td>
            </tr>		  
          <%}%>		  		  	  		  
        </table>
	</td>
  </tr>
  </table>
</form>
</body>
</html>
