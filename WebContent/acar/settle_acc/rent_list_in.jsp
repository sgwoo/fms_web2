<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
	<title>Untitled</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">	
<script language='JavaScript' src='/include/common.js'></script>
</head>

<body>
<%
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String today = request.getParameter("today")==null?"":request.getParameter("today");
	
	
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>단기요금</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>     
    <tr> 
        <td  class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=3% class='title'>연번</td>
                    <td width=15% class='title'>계약번호</td>
                    <td width=13% class='title'>차량번호</td>
                    <td width=9% class='title'>구분</td>
                    <td width=12% class='title'>입금예정일</td>
                    <td width=10% class='title'>공급가</td>
                    <td width=10% class='title'>부가세</td>
                    <td width=10% class='title'>월대여료</td>
                    <td width=8% class='title'>연체일수</td>
                    <td width=8% class='title'>연체료</td>
                </tr>		
<%
	//단기요금리스트
	Vector fee_lists = s_db.getRentList(m_id, l_cd, client_id, mode, gubun2, today);
	int fee_size = fee_lists.size();
	if(fee_size > 0){
		for (int i = 0 ; i < fee_size ; i++){
			Hashtable fee_list = (Hashtable)fee_lists.elementAt(i);
%>				  
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:parent.move_scd('6','<%=fee_list.get("RENT_MNG_ID")%>','<%=fee_list.get("RENT_L_CD")%>','<%=fee_list.get("CAR_MNG_ID")%>','','');" title="단기요금 스케줄로 이동"><%=fee_list.get("RENT_L_CD")%></a></td>
                    <td align="center"><%=fee_list.get("CAR_NO")%></td>
                    <td align="center"><%=fee_list.get("ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(fee_list.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(fee_list.get("S_AMT")))%>원&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(fee_list.get("V_AMT")))%>원&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(fee_list.get("AMT")))%>원&nbsp;</td>
                    <td align="right"><%=fee_list.get("DLY_DAYS")%>일&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(fee_list.get("DLY_AMT")))%>원</td>
                </tr>
<%		}
	}else{%>		  
                <tr> 
                    <td align="center" colspan="10">자료가 없습니다.</td>
                </tr>
<%	} %>		 
            </table>
        </td>
    </tr>
</table>
</body>
</html>
