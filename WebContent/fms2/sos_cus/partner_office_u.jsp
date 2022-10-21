<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.partner.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="pt_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	String po_id = request.getParameter("po_id")==null?"":request.getParameter("po_id");
	
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	String user_id = "";
	String upd_dt = "";
	String upd_id = "";
	String po_gubun = "";
	String po_nm = "";
	String po_own = "";
	String po_no = "";
	String po_sta = "";
	String po_item = "";
	String po_o_tel = "";
	String po_m_tel = "";
	String po_fax = "";
	String po_post = "";
	String po_addr = "";
	String po_web = "";
	String po_note = "";
	
	
	
	int count = 0;
	
	
	reg_dt = Util.getDate();
	user_id = login.getCookieValue(request, "acar_id");
	u_bean = umd.getUsersBean(user_id);
	
	Hashtable ht = pt_db.Partner(po_id);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

function PartherUpdate()
{
	var theForm = document.form1;
	theForm.cmd.value = "u";
		
	if(confirm('�����Ͻðڽ��ϱ�?')){	
			theForm.action='partner_a.jsp';		
			theForm.target='i_no';
			theForm.submit();
		}
}


function PartherDel()
{
	var theForm = document.form1;
	theForm.cmd.value = "d";
		
	if(confirm('�����Ͻðڽ��ϱ�?')){	
			theForm.action='partner_a.jsp';		
			theForm.target='i_no';
			theForm.submit();
		}
}	
//-->
</script>
<style type=text/css>

<!--

.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body leftmargin="15" onLoad="self.focus()">

<form action="" name="form1" method="POST" >
<input type='hidden' name="po_id" value="<%=po_id%>"> 
<input type='hidden' name="user_id" value="<%=user_id%>"> 
<input type='hidden' name='cmd' value=''>
	
<table border=0 cellspacing=0 cellpadding=0 width="800">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> �λ���� > �������� > ��󿬶��� > <span class=style5>���¾�ü����</span></span></td>
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
	    	<table border="0" cellspacing="1" cellpadding="0" width="100%">
	    		<tr>
			    	<td class=title>����</td>
			    	<td colspan='5'>&nbsp;
			    		<SELECT NAME="po_gubun">
							<OPTION VALUE="1" <%if(ht.get("PO_GUBUN").equals("1")){%>selected<%}%>>�ڵ��� ����</OPTION>
							<OPTION VALUE="2" <%if(ht.get("PO_GUBUN").equals("2")){%>selected<%}%>>�����ü</OPTION>
							<OPTION VALUE="8" <%if(ht.get("PO_GUBUN").equals("8")){%>selected<%}%>>�˻��ü</OPTION>
							<OPTION VALUE="3" <%if(ht.get("PO_GUBUN").equals("3")){%>selected<%}%>>Ź�۾�ü</OPTION>
							<OPTION VALUE="6" <%if(ht.get("PO_GUBUN").equals("6")){%>selected<%}%>>��ǰ��ü</OPTION>
							<OPTION VALUE="4" <%if(ht.get("PO_GUBUN").equals("4")){%>selected<%}%>>�����</OPTION>
							<OPTION VALUE="7" <%if(ht.get("PO_GUBUN").equals("7")){%>selected<%}%>>����⵿</OPTION>
							<OPTION VALUE="5" <%if(ht.get("PO_GUBUN").equals("5")){%>selected<%}%>>��Ÿ</OPTION>
							<OPTION VALUE="N" <%if(ht.get("PO_GUBUN").equals("N")){%>selected<%}%>>�̻��</OPTION>
						</SELECT></td>
			    </tr>
	    		<tr>
			    	<td width=10% class=title>��ȣ</td>
			    	<td width=25%>&nbsp;
					  <input type="text" name="po_nm" value="<%=ht.get("PO_NM")%>" size="25" class=text ></td>
			    	<td width=10% class=title>����</td>
			    	<td width=25%>&nbsp;
					  <input type="text" name="po_own" value="<%=ht.get("PO_OWN")%>" size="25" class=text></td>					
			    	<td width=10% class=title>����ڹ�ȣ</td>
			    	<td width=20%>&nbsp;
					  <input type="text" name="po_no" value="<%=ht.get("PO_NO")%>" size="20" class=text></td>
			    </tr>			
			    <tr>
			    	<td class=title>�ڵ���</td>
			    	<td>&nbsp;
					  <input type="text" name="po_m_tel" value="<%=ht.get("PO_M_TEL")%>" size="20" class=text></td>
			    	<td class=title>��ȭ</td>
			    	<td>&nbsp;
					  <input type="text" name="po_o_tel" value="<%=ht.get("PO_O_TEL")%>" size="20" class=text></td>
			    	<td class=title>�ѽ�</td>
			    	<td>&nbsp;
					  <input type="text" name="po_fax" value="<%=ht.get("PO_FAX")%>" size="20" class=text></td>
			    </tr>
			    <tr>
			    	<td class=title>�����</td>
			    	<td>&nbsp;
					  <input type="text" name="po_agnt_nm" value="<%=ht.get("PO_AGNT_NM")%>" size="20" class=text></td>
			    	<td class=title>�ڵ���</td>
			    	<td>&nbsp;
					  <input type="text" name="po_agnt_m_tel" value="<%=ht.get("PO_AGNT_M_TEL")%>" size="20" class=text></td>
			    	<td class=title>������ȭ</td>
			    	<td>&nbsp;
					  <input type="text" name="po_agnt_o_tel" value="<%=ht.get("PO_AGNT_O_TEL")%>" size="20" class=text></td>
			    </tr>
			    <tr>
			    	<td class=title>����2</td>
			    	<td>&nbsp;
					  <input type="text" name="po_item" value="<%=ht.get("PO_ITEM")%>" size="20" class=text></td>
			    	<td class=title>Ű����</td>
			    	<td colspan='3'>&nbsp;
					  <input type="text" name="po_sta" value="<%=ht.get("PO_STA")%>" size="50" class=text></td>
			    </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>������ּ�</td>
				  <td colspan=5>&nbsp;
					<input type="text" name="po_post" id="t_zip" size="7" maxlength='7' value="<%=ht.get("PO_POST")%>">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name="po_addr" id="t_addr" size="90" value="<%=ht.get("PO_ADDR")%>">
				  </td>
				</tr>
				
   			    <tr>
			    	<td class=title>�̸���</td>
			    	<td>&nbsp;
					  <input type="text" name="po_email" value="<%=ht.get("PO_EMAIL")%>" size="25" class=text></td>				
			    	<td class=title>Ȩ������</td>
			    	<td colspan="3" >&nbsp;
					  <input type="text" name="po_web" value="<%=ht.get("PO_WEB")%>" size="50" class=text></td>
		    	</tr>				
			    <tr>
			    	<td class=title>Ư�̻���</td>
			    	<td colspan="5">&nbsp;
					  <input type="text" name="po_note" value="<%=ht.get("PO_NOTE")%>" size="50" class=text></td>
		    	</tr>				
			</table>
    	</td>
    </tr>
    
	<tr>
    	<td align="right" height=25>
    		<a href="javascript:PartherUpdate()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp;
    		<a href="javascript:PartherDel()"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>&nbsp;
    		<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>

</form>

</body>
</html>