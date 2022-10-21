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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style5>�ŷ�ó �ɻ� �����ڷ�</span></td>
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
            				    <td width='50' class=title>����</td>
            				    <td width='80' class=title>������ȣ</td>
            				    <td width='130' class=title>����</td>
            				    <td width='100' class=title>����ȣ</td>
            				    <td width='80' class=title>�������</td>
            				    <td width='150' class=title>����</td>
            				    <td width='60' class=title>�뿩�Ⱓ</td>
            				    <td width='80' class=title>�뿩������<br>/�°�����</td>
            				    <td width='80' class=title>�뿩������<br>/��������</td>
            				    <td width='560' class=title>Ư�̻���</td>
            				    <td width='170'  class=title>����/���</td>
            				    <td width='170'  class=title>ä��</td>
            				    <td width='170'  class=title>�ʰ�����</td>
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
					     <tr><td <%=td_color%> align='center' width='50%'>���౸��:</td><td <%=td_color%>  width='50%'><%if(String.valueOf(cont.get("USE_YN")).equals("N")){%><font color=red><%}%><%=cont.get("USE_YN_NM")%><%if(String.valueOf(cont.get("USE_YN")).equals("N")){%></font><%}%></td></tr>
					     <tr><td <%=td_color%> align='center'>��������:</td><td <%=td_color%>><%=cont.get("CAR_GU")%></td></tr>
					     <tr><td <%=td_color%> align='center'>�뵵����:</td><td <%=td_color%>><%=cont.get("CAR_ST")%></td></tr>
					     <tr><td <%=td_color%> align='center'>��������:</td><td <%=td_color%>><%=cont.get("RENT_WAY")%></td></tr>
					     <tr><td <%=td_color%> align='center'>��౸��:</td><td <%=td_color%>><%=cont.get("RENT_TYPE")%></td></tr>
					     <tr><td <%=td_color%> align='center'>��������:</td><td <%=td_color%>><%=cont.get("BUS_ST")%></td></tr>
					     <tr><td <%=td_color%> align='center'>��������:</td><td <%=td_color%>><%=cont.get("CLS_ST")%></td></tr>
					   </table>					   
					</td>					
					<td <%=td_color%> align='center'><%=cont.get("CON_MON")%>����</td>
					<td <%=td_color%> align='center'><%=cont.get("RENT_START_DT")%><br>/<%=cont.get("RENT_SUC_DT")%></td>
					<td <%=td_color%> align='center'><%=cont.get("RENT_END_DT")%><br>/<%=cont.get("CLS_DT")%></td>
					<td <%=td_color%>>
					   <table width='100%'>
					     <tr><td <%=td_color%> align='center' width='60'>�ſ���:</td><td <%=td_color%>><%=cont.get("DEC_ETC")%></td></tr>
					     <tr><td <%=td_color%> align='center'>�뿩����:</td><td <%=td_color%>><%=cont.get("REMARK")%></td></tr>
					     <tr><td <%=td_color%> align='center'>�������:</td><td <%=td_color%>><%=cont.get("OTHERS")%></td></tr>
					     <tr><td <%=td_color%> align='center'>�뿩���:</td><td <%=td_color%>><%=cont.get("FEE_CDT")%></td></tr>
					     <tr><td <%=td_color%> align='center'>Ư�����:</td><td <%=td_color%>><%=cont.get("CON_ETC")%></td></tr>
					     <tr><td <%=td_color%> align='center'>����ȿ��:</td><td <%=td_color%>><%=cont.get("BC_ETC")%></td></tr>
					     <tr><td <%=td_color%> align='center'>ü�����:</td><td <%=td_color%>><%=cont.get("BUS_CAU")%></td></tr>
					     <tr><td <%=td_color%> align='center'>�������:</td><td <%=td_color%>><%=cont.get("CLS_ETC")%></td></tr>
					   </table>						   					
					</td>                   	
					<td <%=td_color%>>
					   <table width='95%'>
					     <tr><td <%=td_color%> align='center' width='50%'>����Ǽ�:</td><td <%=td_color%> align='right' width='50%'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_CNT")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>�������:</td><td <%=td_color%> align='right'><u><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT")))%></u></td></tr>
					     <tr><td <%=td_color%> align='center'>��ȸ���˺�:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT1")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>�Ϲݼ�����:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT2")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>����������:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT3")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>�縮�������:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT4")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>���������:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT5")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>����������:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT6")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>��������:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_SERV_AMT7")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>���Ǽ�:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("TOT_ACCID_CNT")))%></td></tr>
					   </table>  					 					
					<td <%=td_color%>>
					   <table width='95%'>
					     <tr><td <%=td_color%> align='center' colspan='2'>[���� ������,����� �� ���Ա�]</td></tr>
					     <tr><td <%=td_color%> align='center' width='50%'>�Ǽ�:</td><td <%=td_color%> align='right' width='50%'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_CNT1")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>�ݾ�:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_AMT1")))%></td></tr>
					     <tr><td <%=td_color%> align='center' colspan='2'>[���� ��ü�뿩��] </td></tr>
					     <tr><td <%=td_color%> align='center'>�Ǽ�:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_CNT2")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>�ݾ�:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_AMT2")))%></td></tr>
					     <tr><td <%=td_color%> align='center' colspan='2'>[���� ��ü��] </td></tr>
					     <tr><td <%=td_color%> align='center'>�ϼ�:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_CNT3")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>�ݾ�:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("DLY_AMT3")))%></td></tr>
					   </table>							 
					</td>
					<td <%=td_color%>>
					   <table width='95%'>					     
					     <tr><td <%=td_color%> align='center' width='50%'>�ʰ�����Ÿ�:</td><td <%=td_color%> align='right' width='50%'><%=AddUtil.parseDecimal(String.valueOf(cont.get("OVER_DIST")))%></td></tr>
					     <tr><td <%=td_color%> align='center'>�������ݾ�:</td><td <%=td_color%> align='right'><%=AddUtil.parseDecimal(String.valueOf(cont.get("R_OVER_AMT")))%></td></tr>
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