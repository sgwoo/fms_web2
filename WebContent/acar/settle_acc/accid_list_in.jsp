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
	String h_title = request.getParameter("h_title")==null?"":request.getParameter("h_title");
	
	
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>휴/대차료</span>
        <a href="javascript:parent.page_move2('5');"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>     
    <tr> 
        <td  class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=13% class='title'>계약번호</td>
                    <td width=10% class='title'>사고구분</td>
                    <td width=10% class='title'>사고일자</td>
                    <td width=25% class='title'>보험회사</td>
                    <td width=12% class='title'>청구일자</td>
                    <td width=10% class='title'>청구금액</td>
                    <td width=10% class='title'>연체일수</td>
                    <td width=10% class='title'>연체료</td>
                </tr>
<%
	//휴/대차료 리스트
	Vector accid_lists = s_db.getAccidList(m_id, l_cd, client_id, mode, gubun2, today);
	int accid_size = accid_lists.size();
	if(accid_size > 0){
		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid_list = (Hashtable)accid_lists.elementAt(i);
%>				  
                <tr> 
                    <td align="center"><a href="javascript:parent.move_scd('4','<%=accid_list.get("RENT_MNG_ID")%>','<%=accid_list.get("RENT_L_CD")%>','<%=accid_list.get("CAR_MNG_ID")%>','<%=accid_list.get("ACCID_ID")%>','');" title="<%=h_title%> 스케줄로 이동"><%=accid_list.get("RENT_L_CD")%></a></td>
                    <td align="center"><%=accid_list.get("ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(accid_list.get("ACCID_DT")))%></td>			
                    <td align="center"><span title='<%=accid_list.get("OT_INS")%>'><%=Util.subData(String.valueOf(accid_list.get("OT_INS")), 9)%></span></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(accid_list.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(accid_list.get("AMT")))%>원&nbsp;</td>
                    <td align="right"><%=accid_list.get("DLY_DAYS")%>일&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(accid_list.get("DLY_AMT")))%>원</td>
                </tr>
<%		}
	}else{%>		  
                <tr> 
                    <td align="center" colspan="8">자료가 없습니다.</td>
                </tr>
<%	} %> 
            </table>
        </td>
    </tr>
</table>
</body>
</html>
