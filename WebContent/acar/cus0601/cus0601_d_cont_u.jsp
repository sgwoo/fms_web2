<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.cus0601.*, acar.bill_mng.*, acar.pay_mng.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
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
	else if(fm.ent_no.value==""){ alert("����ڹ�ȣ�� �Է��� �ּ���!"); fm.ent_no.focus(); return; }
	else if(!isTel(fm.ent_no.value)){ alert("����ڹ�ȣ�� �ٽ� Ȯ���� �ּ���!"); fm.ent_no.focus(); return; }

	if(!confirm('�ش������ü�� �����Ͻðڽ��ϱ�?')){ return; }
	fm.action = "cus0601_d_cont_up.jsp";
	fm.target = "i_no";
	fm.submit();
}
function search_zip()
{
	window.open("/acar/car_rent/zip_s.jsp", "�����ȣ�˻�", "left=200, top=100, height=500, width=400, scrollbars=yes");
}
	//�׿��� ��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, scrollbars=yes");		
	}		
	
//����ڵ�Ϲ�ȣ üũ
function CheckBizNo(a) {

 	var strNumb = a.value;
    if (strNumb.length != 10) {
        alert("����ڵ�Ϲ�ȣ�� �߸��Ǿ����ϴ�.");
		document.form1.ent_no.value='';
        return;
    }
    
        sumMod  =   0;
        sumMod  +=  parseInt(strNumb.substring(0,1));
        sumMod  +=  parseInt(strNumb.substring(1,2)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(2,3)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(3,4)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(4,5)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(5,6)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(6,7)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(7,8)) * 3 % 10;
        sumMod  +=  Math.floor(parseInt(strNumb.substring(8,9)) * 5 / 10);
        sumMod  +=  parseInt(strNumb.substring(8,9)) * 5 % 10;
        sumMod  +=  parseInt(strNumb.substring(9,10));
    
		if (sumMod % 10  !=  0) {
			alert("����ڵ�Ϲ�ȣ�� �߸��Ǿ����ϴ�.");
			document.form1.ent_no.value='';
			return;
		}
			alert("�ùٸ� ����� ��Ϲ�ȣ �Դϴ�.");
			return;
}
//-->
</script>
</head>
<body leftmargin="10">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
<input type="hidden" name="off_id" value="<%=off_id%>">
<input type="hidden" name="upd_id" value="<%=user_id%>">
<input type='hidden' name='from_page' value='<%=from_page%>'> 
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="3" align=left>&nbsp;<input type="text" name="off_nm" value="<%=c61_soBn.getOff_nm()%>" size="68" class=text></td>
                    <td class=title>������ü</td>
                    <td>&nbsp;<select name="car_comp_id" style="width:100px">
                        <%for(int i=0; i<cc_r.length; i++){
        											cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <% if(cc_bean.getCode().equals(c61_soBn.getCar_comp_id())){ %>selected<% } %>><%= cc_bean.getNm() %></option>
                        <%}%>
                      </select> </td>
                    <td class=title>���</td>
                    <td>&nbsp;<select name="off_st">
                        <option value="1" <% if(c61_soBn.getOff_st().equals("1")){ %>selected<% } %>>1��</option>
                        <option value="2" <% if(c61_soBn.getOff_st().equals("2")){ %>selected<% } %>>2��</option>
                        <option value="3" <% if(c61_soBn.getOff_st().equals("3")){ %>selected<% } %>>3��</option>
                        <option value="4" <% if(c61_soBn.getOff_st().equals("4")){ %>selected<% } %>>4��</option>
                        <option value="5" <% if(c61_soBn.getOff_st().equals("5")){ %>selected<% } %>>5��</option>
                        <option value="6" <% if(c61_soBn.getOff_st().equals("6")){ %>selected<% } %>>��Ÿ</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class=title width=10%>��ǥ��</td>
                    <td width=15%>&nbsp;<input type="text" name="own_nm" value="<%=c61_soBn.getOwn_nm()%>" size="23" class=text></td>
                    <td width=10% class=title>����ڹ�ȣ</td>
                    <td width=15%>&nbsp;<input type="text" name="ent_no" value="<%=c61_soBn.getEnt_no()%>" size="23" readonly class=text OnBlur="CheckBizNo(this);"></td>
                    <td width=10% class=title>����</td>
                    <td width=15%>&nbsp;<input type="text" name="off_sta" value="<%=c61_soBn.getOff_sta()%>" size="23" class=text></td>
                    <td width=10% class=title>����</td>
                    <td width=15%>&nbsp;<input type="text" name="off_item" value="<%=c61_soBn.getOff_item()%>" size="23" class=text></td>
                </tr>
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
				<tr>
				  <td class=title>�ּ�</td>
				  <td colspan=5> 
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=c61_soBn.getOff_post()%>">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="71" value="<%=c61_soBn.getOff_addr()%>">
				  </td>
                    <td class=title>�繫����ȭ</td>
                    <td>&nbsp;<input type="text" name="off_tel" value="<%=c61_soBn.getOff_tel()%>" size="23" class=text></td>
                </tr>
                <tr> 
                    <td class=title>���°�������</td>
                    <td>&nbsp;
                    	<input type='hidden' name="bank" 			value="<%=c61_soBn.getBank_cd()%>">
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
                    <td class=title>���¹�ȣ</td>
                    <td>&nbsp;<input type="text" name="acc_no" value="<%=c61_soBn.getAcc_no()%>" size="23" class=text></td>
                    <td class=title>������</td>
                    <td>&nbsp;<input type="text" name="acc_nm" value="<%=c61_soBn.getAcc_nm()%>" size="23" class=text></td>
                    <td class=title>�ѽ�</td>
                    <td>&nbsp;<input type="text" name="off_fax" value="<%=c61_soBn.getOff_fax()%>" size="23" class=text></td>
                </tr>
                <tr> 
                    <td class=title>Ư�̻���</td>
                    <td align=left colspan=7>&nbsp;<input type="text" name="note" value="<%=c61_soBn.getNote()%>" size="158" class=text></td>
                </tr>
                <tr> 
                    <td class=title>�׿����ŷ�ó</td>
                    <td align=left colspan=7>&nbsp;&nbsp;<input type='text' name='ven_name' size='20' value='<%=ven.get("VEN_NAME")==null?c61_soBn.getOff_nm():ven.get("VEN_NAME")%>' class='text' style='IME-MODE: active'>
					  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  		  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �ڵ� : <input type='text' name='ven_code' size='8' value='<%=ven_code%>' class='text'>
					</td>					
                </tr>
				
            </table>
        </td>
    </tr>
	<tr> 
        <td align="right"><a href='javascript:ServOffUp()' onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
        <a href='javascript:history.back()' onMouseOver="window.status=''; return true"><img src=../images/center/button_cancel.gif border=0 align=absmiddle></a> 
        </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>