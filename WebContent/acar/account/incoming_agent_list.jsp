<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_off_id 	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	
	//수금현황
	Vector fees = ac_db.getAgentFeeStatList(car_off_id, gubun);
	int fee_size = fees.size();	
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
 <input type='hidden' name='mode' value=''>
 <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 영업사원관리 > <span class=style5>수금현황(에이전트) 세부리스트</span></span></td>
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
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=5% class=title>연번</td>
                    <td width=10% class=title>계약번호</td>
                    <td width=20% class=title>상호</td>
                    <td width=10% class=title>차량번호</td>
                    <td width=15% class=title>차명</td>
                    <td width=10% class=title>대여개시일</td>
                    <td width=10% class=title>총대여료</td>
                    <td width=10% class=title>연체금액</td>
                    <td width=10% class=title>연체일수<br>기산일</td>                    
                </tr>
                <%if(fee_size > 0){
			for (int i = 0 ; i < fee_size ; i++){
				Hashtable ht = (Hashtable)fees.elementAt(i);
                %>	            
                <tr> 
                    <td align='center'><%=i+1%></td>              
                    <td align='center'><%=ht.get("RENT_L_CD")%></td>      
                    <td align='center'><%=ht.get("FIRM_NM")%></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%></td>                    
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("EST_AMT")))%></td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>                                        
                </tr>    				                                    				
		<%	}%>
		<%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>