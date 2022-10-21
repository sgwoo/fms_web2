<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String ven_code	= request.getParameter("ven_code")==null? "":request.getParameter("ven_code");
	String ven_name	= request.getParameter("ven_name")==null? "" :request.getParameter("ven_name");
	String st_dt	= request.getParameter("st_dt")==null? "":request.getParameter("st_dt");
	
	if(ven_code.equals("")) return;
	
	
	Vector vt1 = s_db.getClienfSettleLcPp(ven_code, st_dt);
	int vt1_size = vt1.size();
	
	Vector vt2 = s_db.getClienfSettleLcFee(ven_code, st_dt);
	int vt2_size = vt2.size();
	
	Vector vt5 = s_db.getClienfSettleLcCls(ven_code, st_dt);
	int vt5_size = vt5.size();
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="client_fee_c.jsp";
		fm.submit();
	}	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">

<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='ven_code' 	value='<%=ven_code%>'>
  <input type='hidden' name='ven_name' 	value='<%=ven_name%>'>
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="15%" class=title>거래처코드</td>
                    <td width="35%">&nbsp;<%=ven_code%></td>
                    <td width="15%" class=title>거래처명</td>
                    <td width="35%">&nbsp;<%=ven_name%></td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_bhyji.gif" align=absmiddle>&nbsp; 
        <input type="text" name="st_dt" size="4" value="<%=st_dt%>" class="text">년
	    &nbsp;&nbsp;
		<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td style="font-size : 8pt;" width="3%" class=title>연번</td>
                    <td style="font-size : 8pt;" width="10%" class=title>차량번호</td>
                    <td style="font-size : 8pt;" width="10%" class=title>구분</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금예정일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>매출발생일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>공급가</td>
                    <td style="font-size : 8pt;" width="10%" class=title>부가세</td>
                    <td style="font-size : 8pt;" width="10%" class=title>합계</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금액</td>					
                    <td style="font-size : 8pt;" width="3%" class=title>면제<br>여부</td>
                    <td style="font-size : 8pt;" width="4%" class=title>대손<br>여부</td>
                </tr>
				<%for(int i = 0 ; i < vt1_size ; i++){
				      Hashtable ht = (Hashtable)vt1.elementAt(i);
					  String class_is = "";
					  if(!String.valueOf(ht.get("EXT_PAY_AMT")).equals("0"))	class_is = "class=is";
					  %>
                <tr>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=i+1%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("CAR_NO")%></td>
                  <td style="font-size : 8pt;" <%=class_is%>><%=ht.get("EXT_TM")%>회차</td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("EXT_EST_DT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("EXT_PAY_DT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center">&nbsp;<%=ht.get("TAX_DT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("EXT_S_AMT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("EXT_V_AMT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("EXT_AMT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("EXT_PAY_AMT")%></td>				  
                  <td style="font-size : 8pt;" <%=class_is%> align="center">&nbsp;</td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("BILL_YN")%></td>
                </tr>
				<%}%>
            </table>
	    </td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>장기대여료</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td style="font-size : 8pt;" width="3%" class=title>연번</td>
                    <td style="font-size : 8pt;" width="10%" class=title>차량번호</td>
                    <td style="font-size : 8pt;" width="10%" class=title>구분</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금예정일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>매출발생일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>공급가</td>
                    <td style="font-size : 8pt;" width="10%" class=title>부가세</td>
                    <td style="font-size : 8pt;" width="10%" class=title>합계</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금액</td>					
                    <td style="font-size : 8pt;" width="3%" class=title>면제<br>여부</td>
                    <td style="font-size : 8pt;" width="4%" class=title>대손<br>여부</td>
                </tr>
				<%for(int i = 0 ; i < vt2_size ; i++){
				      Hashtable ht = (Hashtable)vt2.elementAt(i);
					  String class_is = "";
					  if(!String.valueOf(ht.get("RC_AMT")).equals("0"))	class_is = "class=is";
					  %>
                <tr>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=i+1%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("CAR_NO")%></td>
                  <td style="font-size : 8pt;" <%=class_is%>><%=ht.get("FEE_TM")%>회차</td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("FEE_EST_DT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("RC_DT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("TAX_DT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("FEE_S_AMT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("FEE_V_AMT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("FEE_AMT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("RC_AMT")%></td>				  
                  <td style="font-size : 8pt;" <%=class_is%> align="center">&nbsp;</td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("BILL_YN")%></td>
                </tr>
				<%}%>
            </table>
	    </td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>단기대여료</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td style="font-size : 8pt;" width="5%" class=title>연번</td>
                    <td style="font-size : 8pt;" width="10%" class=title>차량번호</td>
                    <td style="font-size : 8pt;" width="15%" class=title>구분</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금예정일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>매출발생일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>공급가</td>
                    <td style="font-size : 8pt;" width="10%" class=title>부가세</td>
                    <td style="font-size : 8pt;" width="10%" class=title>합계</td>
                    <td style="font-size : 8pt;" width="5%" class=title>면제<br>여부</td>
                    <td style="font-size : 8pt;" width="5%" class=title>대손<br>여부</td>
                </tr>
                <tr>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>면책금</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td style="font-size : 8pt;" width="5%" class=title>연번</td>
                    <td style="font-size : 8pt;" width="10%" class=title>차량번호</td>
                    <td style="font-size : 8pt;" width="15%" class=title>구분</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금예정일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>매출발생일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>공급가</td>
                    <td style="font-size : 8pt;" width="10%" class=title>부가세</td>
                    <td style="font-size : 8pt;" width="10%" class=title>합계</td>
                    <td style="font-size : 8pt;" width="5%" class=title>면제<br>여부</td>
                    <td style="font-size : 8pt;" width="5%" class=title>대손<br>여부</td>
                </tr>
                <tr>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                  <td style="font-size : 8pt;">&nbsp;</td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지정산금</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td style="font-size : 8pt;" width="3%" class=title>연번</td>
                    <td style="font-size : 8pt;" width="10%" class=title>차량번호</td>
                    <td style="font-size : 8pt;" width="10%" class=title>구분</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금예정일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>매출발생일</td>
                    <td style="font-size : 8pt;" width="10%" class=title>공급가</td>
                    <td style="font-size : 8pt;" width="10%" class=title>부가세</td>
                    <td style="font-size : 8pt;" width="10%" class=title>합계</td>
                    <td style="font-size : 8pt;" width="10%" class=title>입금액</td>					
                    <td style="font-size : 8pt;" width="3%" class=title>면제<br>여부</td>
                    <td style="font-size : 8pt;" width="4%" class=title>대손<br>여부</td>
                </tr>
				<%for(int i = 0 ; i < vt5_size ; i++){
				      Hashtable ht = (Hashtable)vt5.elementAt(i);
					  String class_is = "";
					  if(!String.valueOf(ht.get("EXT_PAY_AMT")).equals("0"))	class_is = "class=is";
					  %>
                <tr>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=i+1%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("CAR_NO")%></td>
                  <td style="font-size : 8pt;" <%=class_is%>><%=ht.get("EXT_TM")%>회차</td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("EXT_EST_DT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("EXT_PAY_DT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center">&nbsp;<%//=ht.get("TAX_DT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("EXT_S_AMT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("EXT_V_AMT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("EXT_AMT")%></td>
                  <td style="font-size : 8pt;" <%=class_is%> align="right"><%=ht.get("EXT_PAY_AMT")%></td>				  
                  <td style="font-size : 8pt;" <%=class_is%> align="center">&nbsp;</td>
                  <td style="font-size : 8pt;" <%=class_is%> align="center"><%=ht.get("BILL_YN")%></td>
                </tr>
				<%}%>
            </table>
	    </td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1;'></td>
	</tr>			
    <tr>
        <td>&nbsp;</td>
    </tr>
	<!--
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
	-->
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
