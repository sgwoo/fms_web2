<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = cs_db.getConsignmentOKSMSList(cons_no, seq);
	int vt_size = vt.size();
	
%>

<html lang="UTF-8">
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link rel=stylesheet type="text/css" href="../../include/table_ts.css">
</head>
<body>
<form name='form1' method='post'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>탁송인도확인</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
  	<tr><td class=line2 colspan="2"></td></tr>
	<tr>
		 <td class=line> 
            <table border=0 cellspacing=1 width=100%>
				<tr>
					<td width='20%' class='title'>탁송번호</td>
					<td width='5%' class='title'>연번</td>
					<td width='15%' class='title'>탁송기사</td>				  
					<td width='25%' class='title'>인도일시</td>
					<td width="15%" class='title'>차량번호</td>
					<td width="20%" class='title'>인도시 주행거리</td>				  
				</tr>
					<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
				<tr>
					<td width='20%' align='center'><%=ht.get("CONS_NO")%></td>
					<td width='5%' align='center'><%=ht.get("SEQ")%></td>
					<td width='15%' align='center'><%=ht.get("REG_NM")%></td>				  
					<td width='25%' align='center'><%=ht.get("REG_DT")%></td>
					<td width='15%' align='center'><%=ht.get("CAR_NO")%></td>
					<td width='20%' align='center'><%=AddUtil.parseDecimal(String.valueOf(ht.get("DIST_KM")))%>km</td>				  
				<tr>
				<%}%>
			</table>
		</td>
	</tr>
	<tr>
		<td align="right"><a href="javascript:window.close();" ><img src=/acar/images/center/button_close.gif align=absmiddle border="0"></a></td>
	</tr>
</table>
</form>
</body>
</html>