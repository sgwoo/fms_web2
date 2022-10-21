<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno = request.getParameter("cardno")==null?"":request.getParameter("cardno");
	
	//카드정보
	CardBean c_bean = CardDb.getCard(cardno);
	
	//카드종류 리스트 조회
	Vector vt = CardDb.getCardContList("card_h", cardno);
	int vt_size = vt.size();	
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='cardno' value=''>
<input type='hidden' name='seq' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=cardno%> <%=c_bean.getCard_name()%> 약정이력</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>연번</td>
                    <td width='10%' class='title'>약정일자</td>
                    <td width='10%' class='title'>신용공여일수</td>
                    <td width='10%' class='title'>신용한도</td>
                    <td width='10%' class='title'>Cash back 적립율</td>
                    <td width='20%' class='title'>적립금입금예정일</td>
                    <td width='10%' class='title'>담당자</td>
                    <td width='15%' class='title'>적요</td>
                    <td width='10%' class='title'>등록일</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT")))%></td>
                    <td align="center"><%=ht.get("GIVE_DAY")%>일</td>
                    <td align="center"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CONT_AMT")))%>원</td>
                    <td align="center">일반 : <%=ht.get("SAVE_PER1")%>%<%if(String.valueOf(ht.get("CARD_PAID")).equals("선불카드")||String.valueOf(ht.get("CARD_PAID")).equals("카드할부")){%><br>대출연계 : <%=ht.get("SAVE_PER2")%>%<%}%></td>
                    <td>
                    	&nbsp;<%if(String.valueOf(ht.get("SAVE_IN_DT_ST1")).equals("Y")){%>수시<%}%>
            	        &nbsp;<%if(String.valueOf(ht.get("SAVE_IN_DT_ST2")).equals("Y")){%>약정일<%}%>
            	        &nbsp;<%if(String.valueOf(ht.get("SAVE_IN_DT_ST3")).equals("Y")){%>매월 <%=ht.get("SAVE_IN_DT")%>일<%}%>
            	        <%if(!String.valueOf(ht.get("SAVE_IN_ST")).equals("")){%><br>&nbsp;<%=ht.get("SAVE_IN_ST")%><%}%>
            	      </td>
                    <td align="center"><%=ht.get("AGNT_NM")%><br><%=ht.get("AGNT_TEL")%><br><%=ht.get("AGNT_M_TEL")%></td>
                    <td align="center"><%=ht.get("ETC")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                </tr>
		            <%	}%>
		            <%}else{%>
                <tr>
                    <td colspan="9" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr> 
    <tr><td class=h></td></tr>  
    <tr> 
      <td align="right">
	      <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>    
  </table>
</form>
</body>
</html>
