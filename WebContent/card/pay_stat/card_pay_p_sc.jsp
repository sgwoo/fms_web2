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
	function CardMngUpd(s_dt, e_dt){
		var fm = document.form1;
		fm.chk1.value = "3";
		fm.st_dt.value = s_dt;
		fm.end_dt.value = e_dt;
		fm.action = "../doc_stat2/card_use_com_m_frame.jsp";
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
<table border="0" cellspacing="0" cellpadding="0" width='<%if(s_width.equals("1024")){%>1500<%}else{%>1500<%}%>'>
  	<tr><td class=line2 colspan="2"></td></tr>	    	
  <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='20%' id='td_title' style='position:relative;'> 
<%	Vector vts2 = CardDb.getCardPayStat(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size2 = vts2.size();%>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width='11%' rowspan="2" class='title' style='height:45'>연번</td>
            <td width='59%' rowspan="2" class='title'>카드사</td>
            <td width='30%' rowspan="2" class='title'><br>한도<br>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='80%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td colspan="4" class='title'>당월</td>
            <td colspan="4" class='title'>익월</td>
            <td colspan="4" class='title'>익익월</td>
          </tr>
          <tr>
            <td width='13%' class='title'>사용기간</td>
            <td width='7%' class='title'>사용금액</td>
            <td width='7%' class='title'>잔여한도</td>
            <td width='7%' class='title'>결제일자</td>
            <td width='12%' class='title'>사용기간</td>
            <td width='7%' class='title'>사용금액</td>
            <td width='7%' class='title'>잔여한도</td>
            <td width='7%' class='title'>결제일자</td>
            <td width='12%' class='title'>사용기간</td>
            <td width='7%' class='title'>사용금액</td>
            <td width='7%' class='title'>잔여한도</td>
            <td width='7%' class='title'>결제일자</td>
          </tr>
        </table>
	</td>
  </tr>	
<%	if(vt_size2 > 0){%>
  <tr>
	  <td class='line' width='20%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	String  j_chk[]   = new String[5];
			long j_amt[]   = new long[5];%>
        <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);%>
          <tr> 
            <td width='11%' align="center"><%=i+1%></td>
            <td width='59%' align="center"><%=ht.get("COM_NAME")%></td>
            <td width='30%' align="center"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("LIMIT_AMT")))%>원</td>
          </tr>
          <%}%>
        </table></td>
	<td class='line' width='80%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					int today = AddUtil.getDate2(4);
					long h_amt = AddUtil.parseLong(String.valueOf(ht.get("LIMIT_AMT")));
					for(int j=1; j<4; j++){
						if(today < AddUtil.parseInt(String.valueOf(ht.get("USE_E_DT"+j)))) 	j_chk[j] = "Y";
						else																j_chk[j] = "N";
//						if(j_chk[j].equals("Y")){
							j_amt[j] = h_amt-AddUtil.parseLong(String.valueOf(ht.get("BUY_AMT"+j)));
//						}
					}
					%>
          <tr> 
            <td width='13%' align="center"><a href="javascript:CardMngUpd('<%=ht.get("USE_S_DT1")%>','<%=ht.get("USE_E_DT1")%>')"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT1")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT1")))%></a></td>
            <td width='7%'  align="right"><span title="<%=ht.get("BUY_CNT1")%>"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT1")))%>원</span></td>
            <td width='7%'  align="right"><%=Util.parseDecimal(j_amt[1])%>원</td>
            <td width='7%'  align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_EST_DT1")))%></td>
            <td width='12%' align="center"><a href="javascript:CardMngUpd('<%=ht.get("USE_S_DT2")%>','<%=ht.get("USE_E_DT2")%>')"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT2")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT2")))%></a></td>
            <td width='7%'  align="right"><span title="<%=ht.get("BUY_CNT2")%>"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT2")))%>원</span></td>
            <td width='7%'  align="right"><%=Util.parseDecimal(j_amt[2])%>원</td>
            <td width='7%'  align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_EST_DT2")))%></td>
            <td width='12%' align="center"><a href="javascript:CardMngUpd('<%=ht.get("USE_S_DT3")%>','<%=ht.get("USE_E_DT3")%>')"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT3")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT3")))%></a></td>
            <td width='7%'  align="right"><span title="<%=ht.get("BUY_CNT3")%>"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT3")))%>원</span></td>
            <td width='7%'  align="right"><%=Util.parseDecimal(j_amt[3])%>원</td>
            <td width='7%'  align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PAY_EST_DT3")))%></td>
          </tr>
          <%}%>
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='20%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table></td>
	<td class='line' width='80%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>&nbsp;</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
  </table>
</form>
</body>
</html>
