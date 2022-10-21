<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String client_id	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	Vector vt = ec_db.getContReviewList(client_id);
	int vt_size = vt.size();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--

//-->
</script>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width='1880'>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style5>거래처 심사 참고자료</span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
            				<tr>
            				    <td width='50' class=title>연번</td>
            				    <td width='80' class=title>차량번호</td>
            				    <td width='130' class=title>차명</td>
            				    <td width='100' class=title>계약번호</td>
            				    <td width='80' class=title>계약일자</td>
            				    <td width='150' class=title>구분</td>
            				    <td width='60' class=title>대여기간</td>
            				    <td width='80' class=title>대여개시일<br>/승계일자</td>
            				    <td width='80' class=title>대여만료일<br>/해지일자</td>
            				    <td width='560' class=title>특이사항</td>
            				    <td width='170'  class=title>정비/사고</td>
            				    <td width='170'  class=title>채권</td>
            				    <td width='170'  class=title>초과운행</td>
            				</tr>
			
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable cont = (Hashtable)vt.elementAt(i);
			
			String td_color = "";
			
			if(String.valueOf(cont.get("USE_YN")).equals("N")){
				td_color = "class=is";				
			}
			
%>
				<tr>
					<td <%=td_color%> align='center'><%=i+1%></td>
					<td <%=td_color%> align='center'><%=cont.get("CAR_NO")%></td>
					<td <%=td_color%> align='center'><%=cont.get("CAR_NM")%></td>
					<td <%=td_color%> align='center'><%=cont.get("RENT_L_CD")%></td>
					<td <%=td_color%> align='center'><%=cont.get("RENT_DT")%></td>					
					<td <%=td_color%>>
					   <table width='95%'>
					     <tr><td <%=td_color%> align='center' width='50%'>진행구분:</td><td <%=td_color%>  width='50%'><%if(String.valueOf(cont.get("USE_YN")).equals("N")){%><font color=red><%}%><%=cont.get("USE_YN_NM")%><%if(String.valueOf(cont.get("USE_YN")).equals("N")){%></font><%}%></td></tr>
					     <tr><td <%=td_color%> align='center'>차량구분:</td><td <%=td_color%>><%=cont.get("CAR_GU")%></td></tr>
					     <tr><td <%=td_color%> align='center'>용도구분:</td><td <%=td_color%>><%=cont.get("CAR_ST")%></td></tr>
					     <tr><td <%=td_color%> align='center'>관리구분:</td><td <%=td_color%>><%=cont.get("RENT_WAY")%></td></tr>
					     <tr><td <%=td_color%> align='center'>계약구분:</td><td <%=td_color%>><%=cont.get("RENT_TYPE")%></td></tr>
					     <tr><td <%=td_color%> align='center'>영업구분:</td><td <%=td_color%>><%=cont.get("BUS_ST")%></td></tr>
					     <tr><td <%=td_color%> align='center'>해지구분:</td><td <%=td_color%>><%=cont.get("CLS_ST")%></td></tr>
					   </table>					   
					</td>					
					<td <%=td_color%> align='center'><%=cont.get("CON_MON")%>개월</td>
					<td <%=td_color%> align='center'><%=cont.get("RENT_START_DT")%><br>/<%=cont.get("RENT_SUC_DT")%></td>
					<td <%=td_color%> align='center'><%=cont.get("RENT_END_DT")%><br>/<%=cont.get("CLS_DT")%></td>
					<td <%=td_color%>>
					   <table width='100%'>
					     <tr><td <%=td_color%> align='center' width='60'>신용평가:</td><td <%=td_color%>><%=cont.get("DEC_ETC")%></td></tr>
					     <tr><td <%=td_color%> align='center'>대여차량:</td><td <%=td_color%>><%=cont.get("REMARK")%></td></tr>
					     <tr><td <%=td_color%> align='center'>보험사항:</td><td <%=td_color%>><%=cont.get("OTHERS")%></td></tr>
					     <tr><td <%=td_color%> align='center'>대여요금:</td><td <%=td_color%>><%=cont.get("FEE_CDT")%></td></tr>
					     <tr><td <%=td_color%> align='center'>특약사항:</td><td <%=td_color%>><%=cont.get("CON_ETC")%></td></tr>
					     <tr><td <%=td_color%> align='center'>영업효율:</td><td <%=td_color%>><%=cont.get("BC_ETC")%></td></tr>
					     <tr><td <%=td_color%> align='center'>체결사유:</td><td <%=td_color%>><%=cont.get("BUS_CAU")%></td></tr>
					     <tr><td <%=td_color%> align='center'>해지비고:</td><td <%=td_color%>><%=cont.get("CLS_ETC")%></td></tr>
					   </table>						   					
					</td>                   	
					<td <%=td_color%>>
					   <table width='95%'>
					     <tr><td <%=td_color%> align='center' width='50%'>정비건수:</td><td <%=td_color%> align='right' width='50%'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_CNT")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>총정비비:</td><td <%=td_color%> align='right'><u><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT")))%></u></td></tr>
					     <tr><td <%=td_color%> align='center'>순회점검비:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT1")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>일반수리비:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT2")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>보증수리비:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT3")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>재리스정비비:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT4")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>신차정비비:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT5")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>해지수리비:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT6")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>사고수리비:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT7")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>사고건수:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_ACCID_CNT")))%></td></tr>
					   </table>  					 					
					<td <%=td_color%>>
					   <table width='95%'>
					     <tr><td <%=td_color%> align='center' colspan='2'>[현재 선수금,위약금 등 미입금]</td></tr>
					     <tr><td <%=td_color%> align='center' width='50%'>건수:</td><td <%=td_color%> align='right' width='50%'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_CNT1")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>금액:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_AMT1")))%></td></tr>
					     <tr><td <%=td_color%> align='center' colspan='2'>[현재 연체대여료] </td></tr>
					     <tr><td <%=td_color%> align='center'>건수:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_CNT2")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>금액:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_AMT2")))%></td></tr>
					     <tr><td <%=td_color%> align='center' colspan='2'>[누적 연체료] </td></tr>
					     <tr><td <%=td_color%> align='center'>일수:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_CNT3")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>금액:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_AMT3")))%></td></tr>
					   </table>							 
					</td>
					<td <%=td_color%>>
					   <table width='95%'>					     
					     <tr><td <%=td_color%> align='center' width='50%'>초과운행거리:</td><td <%=td_color%> align='right' width='50%'><%=AddUtil.parseDecimal(String.valueOf(cont.get("OVER_DIST")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>정산산출금액:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("R_OVER_AMT")))%></td></tr>
					   </table>						
					</td>																		
				</tr>
<%
		}
%>
			</table>
		</td>
	</tr>
</table>
</body>
</html>