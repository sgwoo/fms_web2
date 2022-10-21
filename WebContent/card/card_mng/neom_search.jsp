<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, tax.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//카드종류 리스트 조회
	Vector vt = neoe_db.getCodeSearch(s_kd, t_wd);//-> neoe_db 변환
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
		fm.action="neom_search.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	function setCardCode(code, name, sdate, edate, etc){
		var fm = document.form1;	
		opener.form1.cardno.value 		= code;		
		if(fm.go_url.value != ''){
			opener.parent.cd_foot.location.href = fm.go_url.value+'?cardno='+code;
		}else{
			opener.form1.card_name.value 	= name;
			opener.form1.card_sdate.value 	= sdate;
			if(edate.length == 6){
				edate = edate+getMonthDateCnt(edate.substring(0,4), edate.substring(4,6));
			}	
			opener.form1.card_edate.value 	= edate;		
			opener.form1.etc.value 			= etc;		
		}
		window.close();		
	}
	function setCode(code, name){
		opener.form1.<%=s_kd%>_code.value 	= code;
		opener.form1.<%=s_kd%>_name.value 	= name;
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
<form action="./neom_search.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">  
  <input type="hidden" name="go_url" value="<%=go_url%>">    
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>&nbsp;&nbsp;<%if(s_kd.equals("cardno")){%><img src=/acar/images/center/arrow_cardm.gif align=absmiddle>&nbsp;<%}else if(s_kd.equals("item")){%><img src=/acar/images/center/arrow_carm.gif align=absmiddle>&nbsp;<%}else if(s_kd.equals("ven")){%><img src=/acar/images/center/arrow_glcm.gif align=absmiddle>&nbsp;<%}else if(s_kd.equals("depositma")){%><img src=/acar/images/center/arrow_bank.gif align=absmiddle>&nbsp;<%}%>&nbsp;
        <input name="t_wd" type="text" class="text" value="" size="20" onKeyDown="javasript:enter()" style='IME-MODE: active'>
        &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' class='title'>연번</td>
                    <td width='43%' class='title'>코드</td>
                    <td width='47%' class='title'>이름</td>
                </tr>
          <%if(vt_size > 0){
				for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>			
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center">
        			<%if(s_kd.equals("cardno")){%>
        			<a href="javascript:setCardCode('<%=ht.get("CODE")%>','<%=ht.get("NAME")%>','<%=ht.get("CARD_SDATE")%>','<%=ht.get("CARD_EDATE")%>','<%=ht.get("ETC")%>')"><%=ht.get("CODE")%></a>
        			<%}else{%>
        			<a href="javascript:setCode('<%=ht.get("CODE")%>','<%=ht.get("NAME")%>')"><%=ht.get("CODE")%></a>
        			<%}%>			
        			</td>
                    <td align="center"><%=ht.get("NAME")%></td>
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
    <tr>
        <td align="right"><a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
</form>
</body>
</html>

