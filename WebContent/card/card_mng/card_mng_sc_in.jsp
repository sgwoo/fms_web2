<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	Vector vts = CardDb.getCardMngList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "09", "01");
%>

<html>
<head><title>FMS</title>
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
	function CardMngUpd(cardno){
		var fm = document.form1;
		if(fm.auth_rw.value == '6'){
			fm.cardno.value = cardno;
			fm.action = "card_mng_u.jsp";
			window.open("about:blank", "CardMngView", "left=50, top=50, width=600, height=600, scrollbars=yes, status=yes");
			fm.target = "CardMngView";
			fm.submit();
		}else{
			alert('권한이 없습니다.');
		}
	}
	//카드폐기처리하기
	function CardMngDel(cardno){
		var fm = document.form1;
		if(fm.auth_rw.value == '6'){
			fm.cardno.value = cardno;
			fm.action = "card_mng_d.jsp";
			window.open("about:blank", "CardMngView", "left=50, top=50, width=600, height=600, scrollbars=yes, status=yes");
			fm.target = "CardMngView";
			fm.submit();
		}else{
			alert('권한이 없습니다.');
		}
	}		
	//폐기카드 부활하기
	function CardMngRevival(cardno){
		var fm = document.form1;
		if(fm.auth_rw.value == '6'){
			fm.cardno.value = cardno;
			fm.action = "card_mng_r.jsp";
			window.open("about:blank", "CardMngView", "left=50, top=50, width=5, height=5, scrollbars=yes, status=yes");
			fm.target = "CardMngView";
			fm.submit();
		}else{
			alert('권한이 없습니다.');
		}
	}		
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
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
<table border="0" cellspacing="0" cellpadding="0" width='1480'>
    <tr><td class=line2 colspan=2></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='690' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>		  
				<td width='30' class='title'>연번</td>
                <td width='100' class='title'>용도구분</td>
                <td width='100' class='title'>지불구분</td>
                <td width='100' class='title'>카드종류</td>
                <td width='150' class='title'>카드번호</td>
                <td width='180' class='title'>사용자구분</td>
              </tr>
            </table></td>
	<td class='line' width='790'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width='100' class='title'>발급일자</td>
            <td width='100' class='title'>만기일자</td>
            <td width='60' class='title'>결제일</td>
            <td width='100' class='title'>한도금액</td>			
            <td width='200' class='title'>비고</td>
            <td width='150' class='title'>결제계좌</td>			
            <td width='80' class='title'>폐기처리</td>			
          </tr>
        </table>
	</td>
  </tr>
<%	if(vt_size > 0){%>
  <tr>
	  <td class='line' width='690' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td width='30' align="center"><input type="checkbox" name="ch_cd" value="<%=ht.get("CARDNO")%>"></td>
			<td width='30' align="center"><%=i+1%></td>
            <td width='100' align="center"><%=ht.get("CARD_ST_NM")%></td>
            <td width='100' align="center">
            <%if(String.valueOf(ht.get("CARD_PAID")).equals("2")){%>선불카드
            <%}else if(String.valueOf(ht.get("CARD_PAID")).equals("3")){%>후불카드
            <%}else if(String.valueOf(ht.get("CARD_PAID")).equals("5")){%>포인트
            <%}else if(String.valueOf(ht.get("CARD_PAID")).equals("7")){%>카드할부
            <%}%>
            </td>
            <td width='100' align="center"><span title='<%=ht.get("CARD_KIND")%>'><%=Util.subData(String.valueOf(ht.get("CARD_KIND")), 6)%></span></td>
            <td width='150' align="center"><a href="javascript:CardMngUpd('<%=ht.get("CARDNO")%>')"><%=ht.get("CARDNO")%></a></td>
            <td width='180' align="center"><span title='<%=ht.get("CARD_NAME")%>'><%=Util.subData(String.valueOf(ht.get("CARD_NAME")), 15)%></td>
          </tr>
          <%}%>
        </table></td>
	<td class='line' width='790'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td width='100' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CARD_SDATE")))%></td>
            <td width='100' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CARD_EDATE")))%></td>
            <td width='60' align="center"><%=ht.get("PAY_DAY")%>일</td>
            <td width='100' align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("LIMIT_AMT")))%>원</td>			
            <td width='200' >&nbsp;<span title='<%=ht.get("ETC")%>'><%=Util.subData(String.valueOf(ht.get("ETC")), 15)%></span></td>						
            <td width='150' align="center"><%=ht.get("ACC_NO")%></td>			
            <td width='80' align="center">
			<%if(String.valueOf(ht.get("USE_YN")).equals("Y")){%>
								<a href="javascript:CardMngDel('<%=ht.get("CARDNO")%>');"><img src=/acar/images/center/button_in_pg.gif border=0 align=absmiddle></a>
			<%}else{%>
			                    <a href="javascript:CardMngRevival('<%=ht.get("CARDNO")%>');"><img src=/acar/images/center/button_in_alive.gif border=0 align=absmiddle></a>
			<%}%>			
			</td>			
          </tr>
          <%}%>
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='690' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table></td>
	<td class='line' width='790'>
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
