<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String card_kind 	= request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String scd_dt = request.getParameter("scd_dt")==null?"":request.getParameter("scd_dt");
	int serial 		= request.getParameter("serial")==null?0:AddUtil.parseInt(request.getParameter("serial"));
	int tm 				= request.getParameter("tm")==null?1:AddUtil.parseInt(request.getParameter("tm"));
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "/card/cash_back/cash_back_frame.jsp");
	
	CardStatBean csb_bean = CardDb.getCardStatBase(serial);
	
	//카드정보
	CardBean c_bean = CardDb.getCard(csb_bean.getCardno());
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//수정
	function Save(){
		var fm = document.form1;
		
		var ment = "수정하시겠습니까?";
		
		if(fm.reg_type[1].checked == true){
			ment = "카드사용 취소하시겠습니까?";
		}
		
		if(confirm(ment)){
			fm.action='card_day_ui_a.jsp';
			//fm.target='i_no';
			fm.submit();
		}
	}
		
	function Close(){
		window.close();
	}
	
	function setSaveAmt(){
		var fm = document.form1;
		fm.save_amt.value = parseDecimal( toInt(parseDigit(fm.base_amt.value)) * toFloat(fm.save_per.value) /100 ); 
	}

//-->
</script>

</head>
<body topmargin="10">
<form action="" name="form1" method="POST">
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='scd_dt' value='<%=scd_dt%>'>
<input type='hidden' name='card_kind' value='<%=card_kind%>'>
<input type='hidden' name='serial' value='<%=serial%>'>
<input type='hidden' name='tm' value='<%=tm%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>경영정보 > 재무회계 > <span class=style5>Cash 사용 수정 [<%=card_kind%> <%=csb_bean.getCardno()%>] </span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>  
	<tr><td class=line2></td></tr>  
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='20%'  class='title'>신용카드번호</td>
              <td>&nbsp;<%=c_bean.getCardno()%></td>
            </tr>
            <tr>
              <td width='20%'  class='title'>사용자구분</td>
              <td>&nbsp;<%=c_bean.getCard_name()%></td>
            </tr>            
		    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>* <%=serial%></td>
    </tr>
    <tr><td class=line2></td></tr> 	
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='20%' class='title'>사용일자</td>
              <td>&nbsp;<%=AddUtil.ChangeDate2(csb_bean.getBase_dt())%></td>
            </tr>
            <tr>
              <td class='title'>사용구분</td>
              <td>&nbsp;<%=csb_bean.getBase_g()%></td>
            </tr>
            <tr>
              <td class='title'>내용</td>
              <td>&nbsp;<%=csb_bean.getBase_bigo()%></td>
            </tr>        
            <tr>
              <td width='20%' class='title'>입금예정일</td>
              <td>&nbsp;<%=AddUtil.ChangeDate2(csb_bean.getEst_dt())%></td>
            </tr> 
            <tr>
              <td class='title'>사용금액</td>
              <td>&nbsp;<input type="text" name="base_amt" size="10" value="<%=AddUtil.parseDecimalLong(csb_bean.getBase_amt())%>" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>원</td>
            </tr>         
            <tr>
              <td class='title'>Cash back 적립율</td>
              <td>&nbsp;<input type="text" name="save_per" size="10" value="<%=csb_bean.getSave_per()%>" class=num onBlur='javascript:setSaveAmt()'>%</td>
            </tr>
            <tr>
              <td class='title'>Cash back 적립금</td>
              <td>&nbsp;<input type="text" name="save_amt" size="10" value="<%=AddUtil.parseDecimalLong(csb_bean.getSave_amt())%>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원</td>
            </tr>
            <tr>
              <td class='title'>변경구분</td>
              <td>&nbsp;
                  <input type='radio' name="reg_type" value='U' checked>
        				  수정
        	        <input type='radio' name="reg_type" value='C'>
        				  카드취소
              </td>
            </tr>            
          </table></td>
  </tr>
  <tr><td class=h></td></tr>  
    <tr> 
      <td align="right">
        <%if( auth_rw.equals("6")) {%>
        <a href="javascript:Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
        &nbsp;
        <%}%>
	      <a href="javascript:Close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
