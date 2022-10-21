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
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�� ��û����+�����ܰ�</span>
        <a href="javascript:parent.page_move2('1');"><img src=../images/center/button_see_ss.gif border=0 align=absmiddle></a></td>
    </tr> 
    <tr>
        <td class=line2></td>
    </tr> 
    <tr> 
        <td  class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=5% class='title'>����</td>
                    <td width=13% class='title'>����ȣ</td>
                    <td width=10% class='title'>ȸ��</td>
                    <td width=10% class='title'>����</td>
                    <td width=12% class='title'>��û��������</td>
                    <td width=10% class='title'>���ް�</td>
                    <td width=10% class='title'>�ΰ���</td>
                    <td width=10% class='title'>���뿩��</td>
                    <td width=10% class='title'>��ü�ϼ�</td>
                    <td width=10% class='title'>��ü��</td>
                </tr>		
<%
	Vector fee_lists = s_db.getEndEstList(m_id, l_cd, client_id, mode, gubun2, today);
	int fee_size = fee_lists.size();
	if(fee_size > 0){
		for (int i = 0 ; i < fee_size ; i++){
			Hashtable fee_list = (Hashtable)fee_lists.elementAt(i);
%>				  
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=fee_list.get("RENT_L_CD")%></td>
                    <td align="center"><%=fee_list.get("TM")%></td>
                    <td align="center"><%=fee_list.get("ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(fee_list.get("EST_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(fee_list.get("S_AMT")))%>��&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(fee_list.get("V_AMT")))%>��&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(fee_list.get("AMT")))%>��&nbsp;</td>
                    <td align="right"><%=fee_list.get("DLY_DAYS")%>��&nbsp;</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(fee_list.get("DLY_AMT")))%>��&nbsp;</td>
                </tr>
<%		}
	}else{%>		  
                <tr> 
                    <td align="center" colspan="10">�ڷᰡ �����ϴ�.</td>
                </tr>
<%	} %>		 
            </table>
        </td>
    </tr>
</table>
</body>
</html>
