<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	String vid[] 	= request.getParameterValues("ch_cd");
	String cardno 	= "";
	
	int vid_size = vid.length;
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
		if(confirm('일괄폐기하시겠습니까?')){					
			fm.action='card_all_del_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}

//-->
</script>

</head>
<body topmargin="10">
<form action="card_all_del_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<%for(int i=0;i < vid_size;i++){
	cardno = vid[i];%>
<input type='hidden' name='cardno' value='<%=cardno%>'>
<%}%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인카드관리 > <span class=style5>신용카드 일괄폐기</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr> 
      <td align="right">&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr> 	
    <tr>
      <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td class='title'>폐기일자</td>
              <td>&nbsp;
                  <input name="cls_dt" type="text" class="text" value="" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            </tr>
            <tr>
              <td class='title'>폐기사유</td>
              <td>&nbsp;
                  <input type="text" name="cls_cau" size="68" value="" class=text>
              </td>
            </tr>			
          </table></td>
  		</tr>
    	<tr> 
      	  <td align="right"><a href="javascript:window.Save();"><img src=/acar/images/center/button_dis.gif border=0 align=absmiddle></a>
      		&nbsp;
	  		<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    	</tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
