<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String card_user_id 	= request.getParameter("card_user_id")==null?"":request.getParameter("card_user_id");
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
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
	function CardUseList(chk2, t_date, cardno){
		var fm = document.form1;
		fm.gubun5.value = cardno;
		if(chk2 != ''){
			fm.chk2.value = chk2;
			fm.chk1.value = '3';
			fm.st_dt.value = t_date+'01';
			fm.end_dt.value = t_date+'31';		
			fm.action = "card_use_card_m_frame.jsp";
		}else{
			fm.action = "card_use_card_u_frame.jsp";
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
<%	Vector vts2 = CardDb.getCardUseCardStat(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size2 = vts2.size();%>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='5%' rowspan="2" class='title'>연번</td>
          <td width='8%' rowspan="2" class='title'>카드종류</td>
          <td width='15%' rowspan="2" class='title'>카드번호</td>
          <td colspan="3" class='title'> 사용자 </td>
          <td colspan="2" class='title'>당월</td>
          <td colspan="2" class='title'>전월</td>
          <td colspan="2" class='title'>전전월</td>
          </tr>
        <tr>
          <td width='8%' class='title'>근무지</td>
          <td width='8%' class='title'>부서</td>
          <td width='8%' class='title'>이름</td>
          <td width='6%' class='title'>건수</td>
          <td width='10%' class='title'>금액</td>
          <td width='6%' class='title'>건수</td>
          <td width='10%' class='title'>금액</td>
          <td width='6%' class='title'>건수</td>
          <td width='10%' class='title'>금액</td>
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
          <td align="center"><%=i+1%></td>
          <td align="center"><%=ht.get("CARD_KIND")%></td>
          <td align="center"><a href="javascript:CardUseList('','','<%=ht.get("CARDNO")%>')"><%=ht.get("CARDNO")%></a></td>
          <td align="center"><%=ht.get("BR_NM")%></td>
          <td align="center"><%=ht.get("DEPT_NM")%></td>
          <td align="center"><%=ht.get("USER_NM")%></td>
          <td align="right"><a href="javascript:CardUseList('1','<%=ht.get("T4")%>','<%=ht.get("CARDNO")%>')"><%=cnt2[1]%></a></td>
          <td align="right"><a href="javascript:CardUseList('1','<%=ht.get("T4")%>','<%=ht.get("CARDNO")%>')"><%=Util.parseDecimal(amt2[1])%></a></td>
          <td align="right"><a href="javascript:CardUseList('2','<%=ht.get("T5")%>','<%=ht.get("CARDNO")%>')"><%=cnt2[2]%></a></td>
          <td align="right"><a href="javascript:CardUseList('2','<%=ht.get("T5")%>','<%=ht.get("CARDNO")%>')"><%=Util.parseDecimal(amt2[2])%></a></td>
          <td align="right"><a href="javascript:CardUseList('3','<%=ht.get("T6")%>','<%=ht.get("CARDNO")%>')"><%=cnt2[3]%></a></td>
          <td align="right"><a href="javascript:CardUseList('3','<%=ht.get("T6")%>','<%=ht.get("CARDNO")%>')"><%=Util.parseDecimal(amt2[3])%></a></td>
          </tr>
        <%	}%>
        <tr>
          <td colspan="6" align="center" class=title>합계</td>
          <%for(int j=1; j<4; j++){%>
          <td style="text-align:right" class="title"><%=t_cnt2[j]%></td>
          <td style="text-align:right" class="title"><%=Util.parseDecimal(t_amt2[j])%></td>
          <%}%>
        </tr>
        <%}%>
      </table></td>
    </tr>		
  </table>
</form>
</body>
</html>
