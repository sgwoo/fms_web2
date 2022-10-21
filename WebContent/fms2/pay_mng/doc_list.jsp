<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.pay_mng.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String ven_code	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	String doc_dt 	= request.getParameter("doc_dt")==null?"":request.getParameter("doc_dt");
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	
	doc_dt = AddUtil.replace(doc_dt,"-","");
	
	//거래처정보
	Vector vt =  pm_db.getDocudList(ven_code, doc_dt);
	int vt_size = vt.size();
%>

<html>
<head><title>거래처 검색</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function Search(){
		var fm = document.form1;
		fm.action = "doc_list.jsp";
		fm.submit();
	}
	
	function save(){
		var fm = opener.document.form1;
		
		if(document.form1.size.value == '0'){
			fm.tax_yn.checked = true;	
		}
		window.close();
	}
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:document.form1.ven_code.focus();">
<form name='form1' method='post' action='doc_list.jsp'>
<input type='hidden' name='go_url' value='/fms2/pay_mng/off_list.jsp'>
<input type='hidden' name='size' value='<%=vt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td align='left'>
      &nbsp;&nbsp;거래처코드 : &nbsp;
        <input type='text' name='ven_code' size='8' value='<%=ven_code%>' class='text'>
      &nbsp;&nbsp;결의일자  : &nbsp;
        <input type='text' name='doc_dt' size='11' value='<%=doc_dt%>' class='text'>

        &nbsp;<a href="javascript:Search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
		&nbsp;&nbsp;
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='5%' class='title'>연번</td>
            <td width="15%" class='title'>결의일자</td>			
            <td width="65%" class='title'>적요</td>			
            <td width="15%" class='title'>금액</td>						
          </tr>
                <%if(vt_size > 0){
						for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><%=ht.get("ACCT_DATE")%></td>						
            <td align="center"><%=ht.get("NOTE_NAME")%></td>									
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("CR_AMT")))%>원&nbsp;</td>						         						
          </tr>
                <%	}
				}%>		  
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"> 
            <a href="javascript:save();"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>
        </td>
    </tr>  	
  </table>
</form>
</body>
</html>