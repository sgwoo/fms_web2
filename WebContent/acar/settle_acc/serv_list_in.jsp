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
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>면책금</span>
        <a href="javascript:parent.page_move2('4');"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr> 
    <tr>
        <td class=line2></td>
    </tr>   
    <tr> 
        <td  class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=13% class='title'>계약번호</td>
                    <td width=10% class='title'>정비구분</td>
                    <td width=10% class='title'>정비일자</td>			
                    <td width=19% class='title'>정비업체</td>
                    <td width=10% class='title'>정비금액</td>
                    <td width=10% class='title'>입금예정일</td>
                    <td width=10% class='title'>청구금액</td>
                    <td width=9%' class='title'>연체일수</td>
                    <td width=9% class='title'>연체료</td>
                </tr>
<%
	//면책금리스트
	Vector serv_lists = s_db.getServList(m_id, l_cd, client_id, mode, gubun2, today);
	int serv_size = serv_lists.size();
	if(serv_size > 0){
		for (int i = 0 ; i < serv_size ; i++){
			Hashtable serv_list = (Hashtable)serv_lists.elementAt(i);
%>				  
                <tr> 
                    <td align="center"><a href="javascript:parent.move_scd('3','<%=serv_list.get("RENT_MNG_ID")%>','<%=serv_list.get("RENT_L_CD")%>','<%=serv_list.get("CAR_MNG_ID")%>','<%=serv_list.get("ACCID_ID")%>','<%=serv_list.get("SERV_ID")%>');" title="면책금 스케줄로 이동"><%=serv_list.get("RENT_L_CD")%></a></td>
                    <td align="center"><%=serv_list.get("ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(serv_list.get("SERV_DT")))%></td>			
                    <td align="center"><span title='<%=serv_list.get("OFF_NM")%>'><%=Util.subData(String.valueOf(serv_list.get("OFF_NM")), 9)%></span></td>
                    <td align="center"><%=Util.parseDecimal(String.valueOf(serv_list.get("REP_AMT")))%>원&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(serv_list.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(serv_list.get("AMT")))%>원&nbsp;</td>
                    <td align="right"><%=serv_list.get("DLY_DAYS")%>일&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(serv_list.get("DLY_AMT")))%>원</td>
                </tr>
<%		}
	}else{%>		  
                <tr> 
                    <td align="center" colspan="9">자료가 없습니다.</td>
                </tr>
<%	} %>	
            </table>
        </td>
    </tr>
</table>
</body>
</html>
