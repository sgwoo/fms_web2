<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*"%>
<%@ page import="acar.cus0601.*, acar.bill_mng.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//�������Ȳ
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
	//�׿��� �ŷ�ó ����	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code = c61_soBn.getVen_code();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
	
	//��೻��
	Vector vt = pk_db.getOffWashContList(off_id);
	int vt_size = vt.size();
	
	//�������Ȳ
	Vector vt2 = pk_db.getOffWashUserList(off_id);
	int vt_size2 = vt2.size();
	
	int count=0;
		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<body leftmargin="15">
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='off_id' value='<%=off_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>									
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ���������� > �����弼����Ȳ > <span class=style5>�������Ȳ</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>            
		</td>
	</tr>
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������Ȳ</span></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">
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
   			       <% } else {%> 
                    <td class=title>����ڹ�ȣ</td>
                    <td>&nbsp;&nbsp;<%=AddUtil.ChangeEnt_no(c61_soBn.getEnt_no())%></td>
                   <% } %> 
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
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����</span></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">				
				<tr>
				    <td width='25%' class='title' height="35" >�ܰ�</td>
				    <td width='30%' class='title' >��������</td>
				    <td class='title' height="35" >����</td>
				</tr>
				<% 
				if( vt_size > 0) {
					count = 0;
					for(int i = 0 ; i < vt_size ; i++) {
						Hashtable ht = (Hashtable)vt.elementAt(i);
						if(String.valueOf(ht.get("GUBUN")).equals("wash")){
							count++;
				%>
				<tr> 
					<td align="center"><%=AddUtil.parseDecimal(ht.get("WASH_PAY"))%> (vat ����)</td>	                                
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("APPLY_DT")))%></td>
					<td align="center"><%=ht.get("CONT_ETC")%></td>
				</tr>
				<%	
						}
					}
				%>
				<%
				} 
				if(count == 0) {
				%>
				<tr> 
					<td align="center" colspan="3">�����Ͱ� �����ϴ�.</td>
				</tr>
				<%
				}
				%>                        
			</table>
		</td>
    </tr>	
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ǳ�ũ���� �� ��������</span></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">				
				<tr>
				    <td width='25%' class='title' height="35" >�ܰ�</td>
				    <td width='30%' class='title' >��������</td>
				    <td class='title' height="35" >����</td>
				</tr>
				<% 
				if( vt_size > 0) {
					count=0;
					for(int i = 0 ; i < vt_size ; i++) {
						Hashtable ht = (Hashtable)vt.elementAt(i);
						if(String.valueOf(ht.get("GUBUN")).equals("inclean")){
						count++;
				%>
				<tr> 
					<td align="center"><%=AddUtil.parseDecimal(ht.get("WASH_PAY"))%> (vat ����)</td>	                                
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("APPLY_DT")))%></td>
					<td align="center"><%=ht.get("CONT_ETC")%></td>
				</tr>
				<%
						}
					}
				%>
				<%
				} 
				if(count == 0) {
				%>
				<tr> 
					<td align="center" colspan="3">�����Ͱ� �����ϴ�.</td>
				</tr>
				<%
				}
				%>                        
			</table>
		</td>
    </tr>	
	<tr  style="height: 20px;"> 
		<td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������Ȳ</span></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
			<table width=100% height="" border="0" cellpadding='0' cellspacing="1">
				<tr>
					<td width='5%' class='title' height="35" rowspan="2">����</td>
					<td width='15%' class='title' rowspan="2">����</td>
					<td width='15%' class='title' height="35" rowspan="2">����ó</td>
					<td class='title' height="35" rowspan="2">�ּ�</td>
					<!-- <td width='10%' class='title' height="35" rowspan="2">�ֹε�ϵ</td>
					<td width='10%' class='title' height="35" rowspan="2">�ź����纻</td> -->
					<td width='30%' class='title' height="35" colspan="2">�ٹ���Ȳ</td>
				</tr>
				<tr>
					<td width='15%' class='title' height="35">�Ի�����</td>
					<td width='15%' class='title' height="35">�������</td>
				</tr>
				<% 
				if( vt_size2 > 0) {
					for(int i = 0 ; i < vt_size2 ; i++) {
						Hashtable ht2 = (Hashtable)vt2.elementAt(i);
				%>
				<tr> 
					<td align="center"><%=i+1%></td>
					<td align="center"><%=ht2.get("WASH_USER_NM")%></td>
					<td align="center"><%=ht2.get("WASH_USER_ID")%></td>
					<td align="center"><%=ht2.get("WASH_USER_ADDR")%></td>
					<!-- <td align="center"></td>
					<td align="center"></td> -->
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("WASH_USER_ENTER_DT")))%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("WASH_USER_END_DT")))%></td>
				</tr>
				<%
					}
				} else {
				%>
				<tr> 
					<td align="center" colspan="6">�����Ͱ� �����ϴ�.</td>
				</tr>
				<%
				}
				%>
			</table>
		</td>
    </tr>
</table>
</form>
<!-- <iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize> -->
</body>
</html>