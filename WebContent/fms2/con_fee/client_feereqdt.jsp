<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	//발행작업스케줄
	Vector fee_scd = ScdMngDb.getFeeScdClient(client_id);
	int fee_scd_size = fee_scd.size();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='client_feereqdt.jsp' target='' method="post">
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>발행예정일 확인</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  
    <tr>
        <td colspan=2 class=line2></td>
    </tR>			
	<tr>
	    <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td class='title'>차량번호</td>
                    <td class='title'>차명</td>					
                    <td class='title'>회차</td>
                    <td colspan="2" class='title'>사용기간</td>
                    <td class='title'>월대여료</td>
                    <td class='title'>발행예정일</td>
                    <td class='title'>세금일자</td>
                    <td class='title'>입금예정일</td>
                </tr>
                    <!--신차(연장)대여-->
	    					<%	if(fee_scd_size>0){%>  
                <%		for(int j = 0 ; j < fee_scd_size ; j++){
        								Hashtable ht = (Hashtable)fee_scd.elementAt(j);%>
                <tr>
                    <td width="10%" align="center"><%=ht.get("CAR_NO")%></td>
                    <td width="20%" align="center"><%=ht.get("CAR_NM")%></td>					
                    <td width="10%" align="center"><%=ht.get("FEE_TM")%></td>
                    <td width="10%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="10%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                </tr>
                <%		}%>
                <%	}%>  
            </table>
	    </td>
    </tr>    
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>


