<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	Vector vts = CardDb.getCardEndList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
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
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//카드내용보기
	function CardMngDel(cardno){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.action = "../card_mng/card_mng_d.jsp";
		window.open("about:blank", "CardMngView", "left=50, top=50, width=600, height=525, scrollbars=yes, status=yes");
		fm.target = "CardMngView";
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='cardno' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='<%if(s_width.equals("1024")){%>900<%}else{%>100%<%}%>'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='50%' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td width='7%' class='title'>연번</td>
                <td width='20%' class='title'>용도구분</td>
                <td width='13%' class='title'>카드종류</td>
                <td width='28%' class='title'>카드번호</td>
                <td width='32%' class='title'>카드이름</td>
              </tr>
            </table></td>
	    <td class='line' width='50%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td width='20%' class='title'>발급일자</td>
                <td width='20%' class='title'>만기일자</td>
                <td width='20%' class='title'>결제일</td>
                <td width='40%' class='title'>비고</td>
              </tr>
            </table>
	    </td>
  </tr>
<%	if(vt_size > 0){%>
  <tr>
	  <td class='line' width='50%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td width='7%' align="center"><%=i+1%></td>
            <td width='20%' align="center"><%=ht.get("CARD_ST_NM")%></td>
            <td width='13%' align="center"><span title='<%=ht.get("CARD_KIND")%>'><%=Util.subData(String.valueOf(ht.get("CARD_KIND")), 4)%></span></td>
            <td width='28%' align="center"><a href="javascript:CardMngDel('<%=ht.get("CARDNO")%>')"><%=ht.get("CARDNO")%></a></td>
            <td width='32%' align="center"><%=ht.get("CARD_NAME")%></td>
          </tr>
          <%}%>
        </table></td>
	<td class='line' width='50%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td width='20%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CARD_SDATE")))%></td>
            <td width='20%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CARD_EDATE")))%></td>
            <td width='20%' align="center"><%=ht.get("PAY_DAY")%>일</td>
            <td width='40%' >&nbsp;<span title='<%=ht.get("ETC")%>'><%=Util.subData(String.valueOf(ht.get("ETC")), 15)%></span></td>						
          </tr>
          <%}%>
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='50%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table></td>
	<td class='line' width='50%'>
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
