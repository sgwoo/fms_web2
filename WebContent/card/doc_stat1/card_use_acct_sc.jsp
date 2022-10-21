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
	function CardUseList(dept_id, acct_code){
		var fm = document.form1;
		fm.gubun3.value = dept_id;
		fm.gubun4.value = acct_code;
		if(fm.chk1.value == '1'){
			fm.chk1.value = '3';
			fm.st_dt.value = "<%=AddUtil.getDate()%>";
			fm.action = "card_use_acct_d_frame.jsp";
		}else{
			fm.action = "card_use_acct_m_frame.jsp";
		}
		fm.target = "d_content";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
<%	Vector vts2 = CardDb.getCardUseAcctStat2("", s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size2 = vts2.size();%>
	<tr><td class=line2></td></tr>
    <tr>
      <td class="line">
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='5%' rowspan="2" class='title'>연번</td>
          <td width='10%' rowspan="2" class='title'>계정과목</td>
          <td colspan="2" class='title' width='17%' >합계</td>
          <td colspan="2" class='title' width='17%' >영업팀</td>
          <td colspan="2" class='title' width='17%' >관리팀</td>
          <td colspan="2" class='title' width='17%' >총무팀</td>
          <td colspan="2" class='title' width='17%' >임원</td>
        </tr>
        <tr>
          <td width='7%' class='title'>건수</td>
          <td width='9%' class='title'>금액</td>
          <td width='7%' class='title'>건수</td>
          <td width='9%' class='title'>금액</td>
          <td width='7%' class='title'>건수</td>
          <td width='9%' class='title'>금액</td>
          <td width='7%' class='title'>건수</td>
          <td width='9%' class='title'>금액</td>
          <td width='7%' class='title'>건수</td>
          <td width='9%' class='title'>금액</td>
        </tr>
        <%	int  cnt2[]   = new int[5];
		  	long amt2[]   = new long[5];
			int  t_cnt2[] = new int[5];
		  	long t_amt2[] = new long[5];
			if(vt_size2 > 0){%>
        <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					for(int j=0; j<5; j++){
						cnt2[j]  = AddUtil.parseInt(String.valueOf(ht.get("CNT"+j)));
						amt2[j]  = AddUtil.parseLong(String.valueOf(ht.get("AMT"+j)));
					}
					for(int j=0; j<5; j++){
						t_cnt2[j] += cnt2[j];
						t_amt2[j] += amt2[j];
					}
					%>
        <tr>
          <td align="center"><%= i+1%></td>
          <td align="center"><%=ht.get("ACCT_CODE_NM")%></td>
          <td align="right"><a href="javascript:CardUseList('','<%=ht.get("ACCT_CODE")%>')"><%=cnt2[0]%>건</a>&nbsp;</td>
          <td align="right"><a href="javascript:CardUseList('','<%=ht.get("ACCT_CODE")%>')"><%=Util.parseDecimal(amt2[0])%>원</a>&nbsp;</td>
          <td align="right"><a href="javascript:CardUseList('0001','<%=ht.get("ACCT_CODE")%>')"><%=cnt2[1]%>건</a>&nbsp;</td>
          <td align="right"><a href="javascript:CardUseList('0001','<%=ht.get("ACCT_CODE")%>')"><%=Util.parseDecimal(amt2[1])%>원</a>&nbsp;</td>
          <td align="right"><a href="javascript:CardUseList('0002','<%=ht.get("ACCT_CODE")%>')"><%=cnt2[2]%>건</a>&nbsp;</td>
          <td align="right"><a href="javascript:CardUseList('0002','<%=ht.get("ACCT_CODE")%>')"><%=Util.parseDecimal(amt2[2])%>원</a>&nbsp;</td>
          <td align="right"><a href="javascript:CardUseList('0003','<%=ht.get("ACCT_CODE")%>')"><%=cnt2[3]%>건</a>&nbsp;</td>
          <td align="right"><a href="javascript:CardUseList('0003','<%=ht.get("ACCT_CODE")%>')"><%=Util.parseDecimal(amt2[3])%>원</a>&nbsp;</td>
          <td align="right"><a href="javascript:CardUseList('0004','<%=ht.get("ACCT_CODE")%>')"><%=cnt2[4]%>건</a>&nbsp;</td>
          <td align="right"><a href="javascript:CardUseList('0004','<%=ht.get("ACCT_CODE")%>')"><%=Util.parseDecimal(amt2[4])%>원</a>&nbsp;</td>
        </tr>
        <%	}%>
        <tr>
          <td align="center" class=title colspan=2>합계</td>
          <%for(int j=0; j<5; j++){%>
          <td style="text-align:right" class="title"><%=t_cnt2[j]%>건&nbsp;</td>
          <td style="text-align:right" class="title"><%=Util.parseDecimal(t_amt2[j])%>원&nbsp;</td>
          <%}%>
        </tr>
        <%}%>
      </table></td>
    </tr>		
  </table>
</form>
</body>
</html>
