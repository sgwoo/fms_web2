<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.* "%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/agent/cookies_base.jsp" %>

<%
	String seq 		= 	request.getParameter("seq")		==null?"":request.getParameter("seq");
	String car_no 	= 	request.getParameter("car_no")	==null?"":request.getParameter("car_no");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Hashtable ht = sc_db.getOneCarScrap(seq, car_no);
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
function save_keep_etc(){
	var fm = document.form1;
	if(confirm("수정하시겠습니까?")){
		fm.target = "KEEP_ETC";
		fm.submit();
	}
}
</script>
</head>

<body onload="document.form1.keep_etc.focus()">
<form name='form1' method='post' action='new_car_num_pop_a.jsp'>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style5>
						신규자동차번호관리 - 번호 킵 비고</span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=100%>
          <tr> 
            <td class=title width="20%">차량번호</td>
            <td class=title width="*">비고</td>
          </tr>
          <tr align="center"> 
            <td><%=ht.get("CAR_NO")%></td>
            <td>
            	<input type="hidden" name="car_no" value="<%=ht.get("CAR_NO")%>">
            	<input type="hidden" name="seq" value="<%=ht.get("SEQ")%>">
            	<input type="text" name="keep_etc" value="<%=ht.get("KEEP_ETC")%>" size="60">
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align="center">
      	<input type="button" class="button" value="수정" onclick="javascript:save_keep_etc();">
      	<input type="button" class="button" value="닫기" onclick="javascript:window.close();">		
      </td>
    </tr>
  </table>
</form>
</body>
</html>