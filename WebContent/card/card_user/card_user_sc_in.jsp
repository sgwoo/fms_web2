<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	Vector vts = CardDb.getCardUserList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "09", "02");
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
	
	//카드회수
	function CardUserBack(cardno, seq){
		var fm = document.form1;
		if(fm.auth_rw.value == '6'){		
			fm.cardno.value = cardno;
			fm.seq.value = seq;
			fm.action = "card_user_b.jsp";
			window.open("about:blank", "CardUserView", "left=50, top=50, width=600, height=400, scrollbars=yes, status=yes");
			fm.target = "CardUserView";
			fm.submit();
		}else{
			alert('권한이 없습니다.');
		}
	}
	//사용자변경
	function CardUserUpd(cardno, seq){
		var fm = document.form1;
		if(fm.auth_rw.value == '6'){
			fm.cardno.value = cardno;
			fm.seq.value = seq;
			fm.action = "card_user_u.jsp";
			window.open("about:blank", "CardUserView", "left=50, top=50, width=600, height=400, scrollbars=yes, status=yes");
			fm.target = "CardUserView";
			fm.submit();
		}else{
			alert('권한이 없습니다.');
		}
	}
	//사용자지정
	function CardUserReg(cardno){
		var fm = document.form1;
		if(fm.auth_rw.value == '6'){
			fm.cardno.value = cardno;
			fm.action = "card_user_i.jsp";
			window.open("about:blank", "CardUserView", "left=50, top=50, width=600, height=400, scrollbars=yes, status=yes");
			fm.target = "CardUserView";
			fm.submit();
		}else{
			alert('권한이 없습니다.');
		}
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
<input type='hidden' name='seq' value=''>
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
            <td width='18%' class='title'>근무지</td>
            <td width='15%' class='title'>부서</td>
            <td width='17%' class='title'>이름</td>
            <td width='25%' class='title'>지급일자</td>
            <td width='25%' class='title'>처리</td>			
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
            <td width='28%' align="center"><%=ht.get("CARDNO")%></td>
            <td width='32%' align="center"><%=ht.get("CARD_NAME")%></td>
          </tr>
          <%}%>
        </table></td>
	<td class='line' width='50%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td width='18%' align="center"><%=ht.get("BR_NM")%></td>
            <td width='15%' align="center"><%=ht.get("DEPT_NM")%></td>
            <td width='17%' align="center"><%=ht.get("USER_NM")%></td>
            <td width='25%' align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("USE_S_DT")))%></td>
            <td width='25%' align="center">
			<%if(String.valueOf(ht.get("USER_NM")).equals("")){%>
<a href="javascript:CardUserReg('<%=ht.get("CARDNO")%>');"><img src=/acar/images/center/button_in_jj.gif border=0 align=absmiddle></a>
			<%}else{%>			
			<a href="javascript:CardUserBack('<%=ht.get("CARDNO")%>', '<%=ht.get("SEQ")%>');"><img src=/acar/images/center/button_in_hs.gif border=0 align=absmiddle></a>
			&nbsp;
			<a href="javascript:CardUserUpd('<%=ht.get("CARDNO")%>', '<%=ht.get("SEQ")%>');"><img src=/acar/images/center/button_in_si.gif border=0 align=absmiddle></a>
			<%}%>
			</td>			
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
