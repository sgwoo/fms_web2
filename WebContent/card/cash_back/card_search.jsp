<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String card_kind_nm = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(s_kd.equals("agnt_nm") || s_kd.equals("master_nm")){
		card_kind_nm = c_db.getNameByIdCode("0031", card_kind, "");
	}
	
	//카드종류 리스트 조회
	Vector vt = CardDb.getCardSearch(s_kd, card_kind, card_kind_nm, t_wd);
	int vt_size = vt.size();	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="card_search.jsp";
		fm.target="_self";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	
	function setCard(cardno, card_name, cont_dt, limit_amt, mile_per){
		var fm = document.form1;	
		opener.form1.cardno.value 		= cardno;
		opener.form1.card_name.value 	= card_name;
		//opener.form1.cont_dt.value 		= ChangeDate(cont_dt);
		opener.form1.cont_amt.value 	= parseDecimal(limit_amt);
		opener.form1.save_per1.value 	= mile_per;
		window.close();
	}
	
	function setAgnt(agnt_nm, agnt_tel, agnt_m_tel){
		var fm = document.form1;	
		opener.form1.agnt_nm.value 		= agnt_nm;
		opener.form1.agnt_tel.value 	= agnt_tel;
		opener.form1.agnt_m_tel.value = agnt_m_tel;
		window.close();
	}	
	
	function setMaster(agnt_nm, agnt_tel, agnt_m_tel){
		var fm = document.form1;	
		opener.form1.master_nm.value 	= agnt_nm;
		opener.form1.master_tel.value 	= agnt_tel;
		opener.form1.master_m_tel.value = agnt_m_tel;
		window.close();
	}		
	
	function setVen(ven_name, ven_code){
		var fm = document.form1;	
		opener.form1.n_ven_name.value = ven_name;
		opener.form1.n_ven_code.value = ven_code;
		window.close();
	}	
	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

</head>
<body>
<form action="card_search.jsp" name="form1" method="POST">
<input type="hidden" name="s_kd" value="<%=s_kd%>">    
<input type="hidden" name="card_kind" value="<%=card_kind%>">    
<input type="hidden" name="go_url" value="<%=go_url%>">    
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>&nbsp;&nbsp;
        <input name="t_wd" type="text" class="text" value="<%=t_wd%>" size="20" onKeyDown="javasript:enter()" style='IME-MODE: active'>
        &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <%if(s_kd.equals("cardno")){%>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' class='title'>연번</td>
                    <td width='43%' class='title'>카드번호</td>
                    <td width='47%' class='title'>이름</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:setCard('<%=ht.get("CARDNO")%>','<%=ht.get("CARD_NAME")%>','<%=ht.get("CARD_SDATE")%>','<%=ht.get("LIMIT_AMT")%>','<%=ht.get("MILE_PER")%>')"><%=ht.get("CARDNO")%></a></td>
                    <td align="center"><%=ht.get("CARD_NAME")%></td>
                </tr>
		            <%	}%>
		            <%}else{%>
                <tr>
                    <td colspan="3" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
    <%}else if(s_kd.equals("agnt_nm")){%>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' class='title'>연번</td>
                    <td width='43%' class='title'>금융사</td>
                    <td width='47%' class='title'>이름</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:setAgnt('<%=ht.get("EMP_NM")%>','<%=ht.get("EMP_TEL")%>','<%=ht.get("EMP_MTEL")%>')"><%=ht.get("OFF_NM")%></a></td>
                    <td align="center"><%=ht.get("EMP_NM")%> <%=ht.get("EMP_MTEL")%></td>
                </tr>
		            <%	}%>
		            <%}else{%>
                <tr>
                    <td colspan="3" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>    
    <%}else if(s_kd.equals("master_nm")){%>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' class='title'>연번</td>
                    <td width='43%' class='title'>금융사</td>
                    <td width='47%' class='title'>이름</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:setMaster('<%=ht.get("EMP_NM")%>','<%=ht.get("EMP_TEL")%>','<%=ht.get("EMP_MTEL")%>')"><%=ht.get("OFF_NM")%></a></td>
                    <td align="center"><%=ht.get("EMP_NM")%> <%=ht.get("EMP_MTEL")%></td>
                </tr>
		            <%	}%>
		            <%}else{%>
                <tr>
                    <td colspan="3" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>   
    <%}else if(s_kd.equals("n_ven")){%>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' class='title'>연번</td>
                    <td width='43%' class='title'>거래처코드</td>
                    <td width='47%' class='title'>거래처명</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:setVen('<%=ht.get("N_VEN_NAME")%>','<%=ht.get("N_VEN_CODE")%>')"><%=ht.get("N_VEN_CODE")%></a></td>
                    <td align="center"><%=ht.get("N_VEN_NAME")%></td>
                </tr>
		            <%	}%>
		            <%}else{%>
                <tr>
                    <td colspan="3" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>    
    <%}%>
    <tr>
        <td align="right"><a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>

