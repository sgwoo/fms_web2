<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

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
	function CardMngUpd(pay_day){
		var fm = document.form1;
		fm.gubun5.value = pay_day;
		fm.action = "card_pay_p_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<table border="0" cellspacing="0" cellpadding="0" width='<%if(s_width.equals("1024")){%>900<%}else{%>100%<%}%>'>
	<tr><td class=line2 colspan="2"></td></tr>
  <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='20%' id='td_title' style='position:relative;'> 
<%	Vector vts2 = CardDb.getCardPayDtStat(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size2 = vts2.size();%>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	    	
          <tr> 
            <td width='30%' rowspan="2" class='title' style='height:45'>연번</td>
            <td width='70%' rowspan="2" class='title'><br>결제일<br>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='80%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td colspan="2" class='title'>당월</td>
            <td colspan="2" class='title'>익월</td>
            <td colspan="2" class='title'>익익월</td>
          </tr>
          <tr>
            <td width='14%' class='title'>건수</td>
            <td width='20%' class='title'>금액</td>
            <td width='13%' class='title'>건수</td>
            <td width='20%' class='title'>금액</td>
            <td width='13%' class='title'>건수</td>
            <td width='20%' class='title'>금액</td>
          </tr>
        </table>
	</td>
  </tr>	
<%	if(vt_size2 > 0){%>
  <tr>
	  <td class='line' width='20%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	int  t_cnt[] = new int[12];
  			long t_amt[] = new long[12];%>
        <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);%>
          <tr> 
            <td width='30%' align="center"><%=i+1%></td>
            <td width='70%' align="center"><a href="javascript:CardMngUpd('<%=ht.get("PAY_DAY")%>')"><%=ht.get("PAY_DAY")%>일</a></td>
          </tr>
          <%}%>
          <tr> 
            <td class=title colspan="2" align="center">합계</td>
          </tr>		  
        </table></td>
	<td class='line' width='80%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					for(int j=1; j<4; j++){
						t_cnt[j] += AddUtil.parseInt(String.valueOf(ht.get("BUY_CNT"+j)));
						t_amt[j] += AddUtil.parseLong(String.valueOf(ht.get("BUY_AMT"+j)));
					}
					%>
          <tr> 
            <td width='14%' align="center"><%=ht.get("BUY_CNT1")%>건</td>
            <td width='20%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT1")))%>원&nbsp;</td>
            <td width='13%' align="center"><%=ht.get("BUY_CNT2")%>건</td>
            <td width='20%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT2")))%>원&nbsp;</td>
            <td width='13%' align="center"><%=ht.get("BUY_CNT3")%>건</td>
            <td width='20%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT3")))%>원&nbsp;</td>
          </tr>
          <%}%>
          <tr> 
            <td class=title align="center"><%=t_cnt[1]%>건</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt[1])%>원&nbsp;</td>
            <td class=title align="center"><%=t_cnt[2]%>건</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt[2])%>원&nbsp;</td>
            <td class=title align="center"><%=t_cnt[3]%>건</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt[3])%>원&nbsp;</td>
          </tr>		  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='20%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='80%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
  </table>
</form>
</body>
</html>
