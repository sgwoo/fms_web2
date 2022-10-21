<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--

//-->
</script>
</head>
<body>
<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//미수과태료
	Vector settle_fine = rs_db.getFineSettleList(s_cd);
	int settle_fine_size = settle_fine.size();
	
	int settle_fine_amt = 0;
%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템  > 재무회계 > <span class=style5>미수과태료 리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr>		
        <td class='line' width='100%'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='5%' class='title'>연번</td>
                    <td width='15%' class='title'>위반일시</td>
                    <td width='25%' class='title'>위반장소</td>
                    <td width='35%' class='title'>위반내용</td>
                    <td width='10%' class='title'>위반금액</td>
                    <td width='10%' class='title'>등록일자</td>
                </tr>
		<%	for(int i = 0 ; i < settle_fine_size ; i++){
				Hashtable ht = (Hashtable)settle_fine.elementAt(i);
				settle_fine_amt = settle_fine_amt + AddUtil.parseInt(String.valueOf(ht.get("PAID_AMT")));%>	
                <tr> 
                    <td align='center'><%=i+1%></td>		  
                    <td>&nbsp;<%=ht.get("VIO_DT")%></td>
                    <td align='center'><%=ht.get("VIO_PLA")%></td>
                    <td>&nbsp;<%=ht.get("VIO_CONT")%></td>		  
                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("PAID_AMT")))%>원</td>
                    <td align='center'><%=ht.get("REG_DT")%></td>
                </tr>
        	<%	}%>
        	<tr>
        	    <td class=title colspan="4">합계</td>
        	    <td align='right'><%=AddUtil.parseDecimal(settle_fine_amt)%>원</td>
        	    <td align='right'>&nbsp;</td>
        	</tr>
	    </table>
	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	<td align="right"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    <tr>        
</table>
</body>
</html>
