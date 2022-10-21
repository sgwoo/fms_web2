<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	PayMngDatabase    	pm_db	= PayMngDatabase.getInstance();

	String off_id = request.getParameter("off_id")==null?ck_acar_id:request.getParameter("off_id");
	
	//거래처정보
	Vector vt =  pm_db.getPayDirUserList(off_id);
	int vt_size = vt.size();
%>

<html>
<head><title>직원전기차충전등록 리스트</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
			
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>직원전기차충전등록 리스트 <span class=style5>
						</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width="5%" class='title'>연번</td>
            <td width="15%" class='title'>지급일</td>
            <td width="15%" class='title'>거래처</td>			
            <td width="15%" class='title'>금액</td>
            <td width="50%" class='title'>적요</td>
          </tr>
                <%if(vt_size > 0){
						for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);							
				%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_PAY_DT")))%></td>			
            <td align="center"><%=ht.get("OFF_NM")%></td>						
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT")))%></td>
            <td>&nbsp;<%=ht.get("P_CONT")%></td>									
          </tr>
                <%	}
				}%>		  
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
      <td align='right'>
      	<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
      </td>
    </tr>

  </table>
</form>
</body>
</html>