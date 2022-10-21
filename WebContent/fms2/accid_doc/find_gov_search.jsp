<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	InsComBean[] banks = c_db.getInsComAll(t_wd);
	int bank_size = banks.length;
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//검색하기	
	function search(){
		var fm = document.form1;
		fm.action = "find_gov_search.jsp";		
		fm.submit();	
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function search_ok(ins_com_id, ins_com_f_nm, ins_com, zip, addr){
		var fm = opener.document.form1;
		fm.gov_id.value 	= ins_com_id;
		fm.gov_nm.value 	= ins_com_f_nm;
		fm.ins_com.value 	= ins_com;
		fm.t_zip.value 	= zip;
		fm.t_addr.value 	= addr;
		
		if(ins_com_f_nm =='') 	fm.gov_nm.value 	= ins_com;
	
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
						<span class=style1><span class=style5>보험사 조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>                   
                    <td width=270>보험사 : &nbsp;
                      <input type="text" name="t_wd" value='<%=t_wd%>' size="15" class="text">    
					  &nbsp;&nbsp;
					  <a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>                  
                    </td>
                  
                </tr>
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
                    <td class='title' width=10%>연번</td>
                    <td width=30% class='title'>보험사명</td>
                    <td width=60% class='title'>주소</td>         
                </tr>
          <%for(int i = 0 ; i < bank_size ; i++){
				InsComBean bank = banks[i]; %>				  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><a href="javascript:search_ok('<%= bank.getIns_com_id()%>','<%= bank.getIns_com_f_nm()%>','<%= bank.getIns_com_nm()%>','<%= bank.getZip()%>','<%= bank.getAddr()%>')" onMouseOver="window.status=''; return true"><%= bank.getIns_com_f_nm()%><%if(bank.getIns_com_f_nm().equals("")){%><%= bank.getIns_com_nm()%><%}%></a></td>
                    <td><%= bank.getAddr()%></td>
          
                </tr>
          <%}%>		  		  
            </table>
        </td>
    </tr>
    <tr> 
        <td align="center"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
