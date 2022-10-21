<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.cus0601.*, acar.bill_mng.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);	
	
	
	//�׿��� �ŷ�ó ����	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code = c61_soBn.getVen_code();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function ServOffUpDisp(){
	location.href = "cus0605_d_cont_u.jsp?auth_rw=<%= auth_rw %>&off_id=<%= off_id %>";
}
//-->
</script>
</head>
<body leftmargin="10">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="7">&nbsp;&nbsp;<%=c61_soBn.getOff_nm()%></td>                
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="7">&nbsp;&nbsp;<%=c61_soBn.getEst_st()%></td>
                </tr>
                <tr> 
                    <td class=title>��ǥ��</td>
                    <td>&nbsp;&nbsp;<%=c61_soBn.getOwn_nm()%></td>
                <% if (c61_soBn.getEst_st().equals("����")) { %>   
                	<td class=title>�ֹι�ȣ</td>
                    <td>&nbsp;&nbsp;<%=AddUtil.ChangeEnt_no(c61_soBn.getSsn())%></td>
                <% } else { %>          
                    <td class=title>����ڹ�ȣ</td>
                    <td>&nbsp;&nbsp;<%=AddUtil.ChangeEnt_no(c61_soBn.getEnt_no())%></td>
                <% }  %>    
                    <td class=title>����</td>
                    <td>&nbsp;&nbsp;<%=c61_soBn.getOff_sta()%></td>
                    <td class=title>����</td>
                    <td>&nbsp;&nbsp;<%=c61_soBn.getOff_item()%></td>
                </tr>
                <tr> 
                    <td class=title>�ּ�</td>
                    <td align=left colspan=5>&nbsp;&nbsp;<%=c61_soBn.getOff_post()%>&nbsp;<%=c61_soBn.getOff_addr()%></td>
                    <td class=title>�繫����ȭ</td>
                    <td>&nbsp;&nbsp;<%=c61_soBn.getOff_tel()%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>���°�������</td>
                    <td width=15%>&nbsp;&nbsp;<%=c61_soBn.getBank()%></td>
                    <td class=title width=10%>���¹�ȣ</td>
                    <td width=15%>&nbsp;&nbsp;<%=c61_soBn.getAcc_no()%></td>
                    <td class=title width=10%>������</td>
                    <td width=15%>&nbsp;&nbsp;<%=c61_soBn.getAcc_nm()%></td>
                    <td class=title width=10%>�ѽ�</td>
                    <td width=15%>&nbsp;&nbsp;<%=c61_soBn.getOff_fax()%></td>
                </tr>
                <tr> 
                    <td class=title>Ư�̻���</td>
                    <td align=left colspan=7>&nbsp;&nbsp;<%=c61_soBn.getNote()%></td>
                </tr>
                <tr> 
                    <td class=title>�׿����ŷ�ó</td>
                    <td align=left colspan=7>&nbsp;&nbsp;<%if(!ven_code.equals("")){%>(<%=ven_code%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%><input type="hidden" name="ven_code" value="<%= ven_code %>"></td>
                </tr>				
            </table>
        </td>
    </tr>
	<tr>
        <td align="right">
	  <%if(from_page.equals("/fms2/consignment_new/cons_i_c.jsp")){%>
	    <a href="javascript:parent.close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a>
	  <%}else{%>
	  <% if(!auth_rw.equals("1")){ %>
	  	<a href="javascript:ServOffUpDisp()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify_s.gif align=absmiddle border=0></a>
	  <% } %>
	  <% } %></td>
    </tr>
</table>
</body>
</html>