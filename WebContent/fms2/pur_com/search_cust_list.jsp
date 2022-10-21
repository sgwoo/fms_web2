<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String bus_id 		= request.getParameter("bus_id")==null?"":request.getParameter("bus_id");
	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	Vector vars = new Vector();
	
	if(!bus_id.equals("")){
		vars = cod.getCustSubList(bus_id);
	}
	
	int size = vars.size();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function setCode(nm){
		var fm = opener.document.form1;				
		fm.pur_com_firm.value = nm;
		self.close();
	}
//-->
</script>
</head>
<body>
<form name='form1' action='search_cust_list.jsp' method='post'>
<input type='hidden' name='size' value='<%=size%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>고객조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>연번</td>
                    <td class=title width=70%>상호</td>                    
                    <td class=title width=20%>계약일자</td>
    		    </tr>				
			
              		<%for(int i = 0 ; i < size ; i++){
    					Hashtable var = (Hashtable)vars.elementAt(i);%>							
						<tr>
							<td align="center"><%=i+1%></td>
							<td>&nbsp;<a href="javascript:setCode('<%=var.get("FIRM_NM")%>');"><%=var.get("FIRM_NM")%></a></td>
							<td align="center"><%=var.get("RENT_DT")%></td>																					
						</tr>
              		<%}%>				
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right"> 
			<a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>  
</table>
</form>
</body>
</html>