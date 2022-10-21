<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String acct_code 	= request.getParameter("acct_code")==null?"00001":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String acct_code_nm = request.getParameter("acct_code_nm")==null?"�����Ļ���":request.getParameter("acct_code_nm");
	String acct_code_g_nm = request.getParameter("acct_code_g_nm")==null?"":request.getParameter("acct_code_g_nm");

	
	end_dt = "";
	
	Vector vts = CardDb.getCardUseAcctDList("", acct_code, acct_code_g, s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	//ī�峻�뺸��
	function CardUseList(dept_id, acct_code){
		var fm = document.form1;
		fm.gubun3.value = dept_id;
		fm.gubun4.value = acct_code;
		fm.action = "card_use_acct_d_frame.jsp";
		fm.target = "d_content";
//		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='acct_code' value='<%=acct_code%>'>
<input type='hidden' name='acct_code_g' value='<%=acct_code_g%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                  <td width='4%' class='title'>����</td>
                  <td width='7%' class='title'>�ٹ���</td>
                  <td width="9%" class='title'>�μ�</td>
                  <td width="7%" class='title'>�̸�</td>
                  <td width="10%" class='title'>��������</td>
                  <td width="10%" class='title'>�ŷ�����</td>
                  <td width="15%" class='title'>�ŷ�ó</td>
                  <td width="10%" class='title'>�ݾ�</td>
                  <td width="28%" class='title'>���</td>
                </tr>
                <%	if(vt_size > 0){%>
                <%	for(int i = 0 ; i < vt_size ; i++){
        					Hashtable ht = (Hashtable)vts.elementAt(i);%>		
                <tr>
                  <td align="center"><%=i+1%></td>
                  <td align="center"><%=ht.get("BR_NM")%></td>
                  <td align="center"><%=ht.get("NM")%></td>
                  <td align="center"><%=ht.get("USER_NM")%></td>
                  <td align="center"><%=ht.get("ACCT_CODE_NM")%></td>
                  <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BUY_DT")))%></td>
                  <td align="center"><span title='<%=ht.get("VEN_NAME")%>'><%=Util.subData(String.valueOf(ht.get("VEN_NAME")), 8)%></span></td>
                  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT")))%>��&nbsp;</td>
                  <td>&nbsp;<span title='<%=ht.get("ACCT_CONT_NM")%>'><%=Util.subData(String.valueOf(ht.get("ACCT_CONT_NM")), 20)%></span></td>
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
