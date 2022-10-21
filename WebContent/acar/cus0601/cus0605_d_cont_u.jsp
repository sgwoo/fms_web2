<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.cus0601.*, acar.bill_mng.*, acar.pay_mng.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
	
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//�׿��� �ŷ�ó ����	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code = c61_soBn.getVen_code();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
	
	//�����縮��Ʈ
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function ServOffUp(){
	var fm = document.form1;
	if(fm.off_nm.value==""){ alert("��ȣ�� �Է��� �ּ���!"); fm.off_nm.focus(); return; }
	else if(fm.own_nm.value==""){ alert("��ǥ�ڸ� �Է��� �ּ���!"); fm.own_nm.focus(); return; }
	else if(fm.est_st.value != "����"){
		if(fm.ent_no.value==""){
			alert("����ڹ�ȣ�� �Է��� �ּ���!"); 
			//fm.ent_no.focus(); 
			return; 
		}
	}	
	else if(!isTel(fm.ent_no.value)){ alert("����ڹ�ȣ�� �ٽ� Ȯ���� �ּ���!"); fm.ent_no.focus(); return; }

	if(!confirm('�ش缼����ü�� �����Ͻðڽ��ϱ�?')){ return; }
	fm.action = "cus0605_d_cont_up.jsp";
	fm.target = "nodisplay";
	fm.submit();
}
	//�׿��� ��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, scrollbars=yes");		
	}		

//-->
</script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	function openDaumPostcode() {
		new daum.Postcode({
			oncomplete: function(data) {
				document.getElementById('t_zip').value = data.zonecode;
				document.getElementById('t_addr').value = data.address +" ("+ data.buildingName+")";
				
			}
		}).open();
	}
</script>		
</head>
<body leftmargin="10">

<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
<input type="hidden" name="off_id" value="<%=off_id%>">
<input type="hidden" name="upd_id" value="<%=user_id%>">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="7" align=left>&nbsp;&nbsp;<input type="text" name="off_nm" value="<%=c61_soBn.getOff_nm()%>" size="67" class=text></td>
                </tr>
                <tr>
                	<td class=title>����</td>
                	<td colspan="7">
                		&nbsp;<input type="radio" name="est_st" id="gubun-enterprise" value="���λ����"<%if(c61_soBn.getEst_st().equals("���λ����")){%>checked<%}%>><label for="gubun-enterprise">���λ����</label>
                		&nbsp;<input type="radio" name="est_st" id="gubun-business" value="���λ����"<%if(c61_soBn.getEst_st().equals("���λ����")){%>checked<%}%>><label for="gubun-business">���λ����</label>
                		&nbsp;<input type="radio" name="est_st" id="gubun-personal" value="����"<%if(c61_soBn.getEst_st().equals("����")){%>checked<%}%>><label for="gubun-personal">����</label>
                	</td>
                </tr>
                <tr> 
                    <td class=title>��ǥ��</td>
                    <td>&nbsp;&nbsp;<input type="text" name="own_nm" value="<%=c61_soBn.getOwn_nm()%>" size="22" class=text></td>
                  
                   <% if (c61_soBn.getEst_st().equals("����")) { %>   
                	<td class=title>�ֹι�ȣ</td>
                    <td>&nbsp;&nbsp;<input type="text" name="ssn" value="<%=c61_soBn.getSsn()%>" readonly size="22" class=text></td>
                <% } else { %>          
                    <td class=title>����ڹ�ȣ</td>
                    <td>&nbsp;&nbsp;<input type="text" name="ent_no" value="<%=c61_soBn.getEnt_no()%>" readonly size="22" class=text></td>
                <% }  %> 
                
                    <td class=title>����</td>
                    <td>&nbsp;&nbsp;<input type="text" name="off_sta" value="<%=c61_soBn.getOff_sta()%>" size="22" class=text></td>
                    <td class=title>����</td>
                    <td>&nbsp;&nbsp;<input type="text" name="off_item" value="<%=c61_soBn.getOff_item()%>" size="22" class=text></td>
                </tr>					
				<tr>
				  <td class=title>�ּ�</td>
				  <td colspan=5> 
					&nbsp;&nbsp;<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=c61_soBn.getOff_post()%>">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text"  name="t_addr" id="t_addr" size="71" value="<%=c61_soBn.getOff_addr()%>">
				  </td>
                    <td class=title>�繫����ȭ</td>
                    <td>&nbsp;&nbsp;<input type="text" name="off_tel" value="<%=c61_soBn.getOff_tel()%>" size="22" class=text></td>
                </tr>
                <tr> 
                    <td class=title width=10%>���°�������</td>
                    <td width=15%>&nbsp;&nbsp;
                    	<input type='hidden' name="bank" value="<%=c61_soBn.getBank_cd()%>">
                    	<select name='bank_cd'>
			                <option value=''>����</option>
			                <%	for(int i = 0 ; i < bank_size ; i++){
														Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
														//�ű��ΰ�� �̻������ ����
														if(String.valueOf(bank_ht.get("USE_YN")).equals("N"))	 continue;
											%>
			                <option value='<%= bank_ht.get("CODE")%>' <%if(String.valueOf(bank_ht.get("NM")).equals(c61_soBn.getBank())||String.valueOf(bank_ht.get("CODE")).equals(c61_soBn.getBank_cd()))	%>selected<%%>><%= bank_ht.get("NM")%></option>
			                <%	}%>
		                </select>
					</td>
                    <td class=title width=10%>���¹�ȣ</td>
                    <td width=15%>&nbsp;&nbsp;<input type="text" name="acc_no" value="<%=c61_soBn.getAcc_no()%>" size="22" class=text></td>
                    <td class=title width=10%>������</td>
                    <td width=15%>&nbsp;&nbsp;<input type="text" name="acc_nm" value="<%=c61_soBn.getAcc_nm()%>" size="22" class=text></td>
                    <td class=title width=10%>�ѽ�</td>
                    <td width=15%>&nbsp;&nbsp;<input type="text" name="off_fax" value="<%=c61_soBn.getOff_fax()%>" size="22" class=text></td>
                </tr>
                <tr> 
                    <td class=title>Ư�̻���</td>
                    <td align=left colspan=7>&nbsp;&nbsp;<input type="text" name="note" value="<%=c61_soBn.getNote()%>" size="157" class=text></td>
                </tr>
                <tr> 
                    <td class=title>�׿����ŷ�ó</td>
                    <td align=left colspan=7>&nbsp;&nbsp;<input type='text' name='ven_name' size='20' value='<%=ven.get("VEN_NAME")==null?c61_soBn.getOff_nm():ven.get("VEN_NAME")%>' class='text' style='IME-MODE: active'>
					  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  		  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �ڵ� : <input type='text' name='ven_code' size='6' value='<%=ven_code%>' class='text'>
					</td>					
                </tr>				
            </table>
        </td>
    </tr>
	<tr> 
        <td align="right">
	        <a href='javascript:ServOffUp()' onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
	        <a href='javascript:history.back()' onMouseOver="window.status=''; return true"><img src=../images/center/button_cancel.gif border=0 align=absmiddle></a> 
        </td>
    </tr>
</table>
</form>
</body>
</html>