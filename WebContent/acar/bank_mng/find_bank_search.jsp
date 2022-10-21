<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	
	CodeBean[] banks = c_db.getBankList(t_wd); 
	int bank_size = banks.length;
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//검색하기	
	function search(){
		var fm = document.form1;
		fm.action = "find_bank_search.jsp";		
		fm.submit();	
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function search_ok(bank_id, bank_nm){
		var fm = opener.document.form1;
		fm.bank_id.value = bank_id;
		fm.bank_nm.value = bank_nm;
//		fm.gov_st.value = gov_st_nm;		
//		fm.mng_dept.value = mng_dept;
//		fm.mng_nm.value = mng_nm;
//		fm.mng_pos.value = mng_pos;				
		window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>금융기관조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=14%>연번</td>
                    <td width=43% class='title'>금융사명</td>
                    <td width=43% class='title'>-</td>
         
                </tr>
          <%for(int i = 0 ; i < bank_size ; i++){
				CodeBean bank = banks[i]; %>				  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><a href="javascript:search_ok('<%= bank.getCode()%>','<%= bank.getNm()%>')" onMouseOver="window.status=''; return true"><%= bank.getNm()%></a></td>
                    <td></td>
          
                </tr>
          <%}%>		  		  
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
