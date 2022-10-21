<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.bill_mng.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String type = request.getParameter("type")==null?"":request.getParameter("type");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//거래처정보
	CodeBean[] vens = neoe_db.getCodeAll(t_wd);
	int ven_size = vens.length;
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') document.form1.submit();
	}

	function setVendor(ven_code, ven_name){

		
			var fm = opener.document.form1;		
		
				fm.ven_code.value = ven_code;
				fm.ven_name.value = ven_name;
			window.close();
		

	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post' action='vendor_list.jsp'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='type' value='<%=type%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>거래처 검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_glc.gif align=absmiddle>&nbsp;
            <input type='text' name='t_wd' size='30' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'>
            <a href='javascript:document.form1.submit()'><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> 
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
                    <td width=10% class='title'>연번</td>
                    <td width=90% class='title'>거래처명</td>
                </tr>
                <%if(ven_size > 0 && !t_wd.equals("")){
						for(int i = 0 ; i < ven_size ; i++){
							CodeBean ven = vens[i];	%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td>&nbsp;<a href="javascript:setVendor('<%= ven.getCode()%>','<%= ven.getNm()%>');">[<%= ven.getCode()%>]<%= ven.getNm()%>(<%= ven.getApp_st()%>, <%= ven.getCms_bk()%>)</a></td>            
                </tr>
                <%	}
				}%>		  
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan='6' align='right'> <a href='javascript:window.close()'><img src=../images/center/button_close.gif align=absmiddle border=0></a> 
        </td>
    </tr>
  </table>
</form>
</body>
</html>