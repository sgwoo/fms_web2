<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*, acar.pay_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_type 	= request.getParameter("off_type")==null?"1":request.getParameter("off_type");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
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
function ServOffReg(){
	var fm = document.form1;
	if(fm.off_nm.value==""){ alert("��ȣ�� �Է��� �ּ���!"); fm.off_nm.focus(); return; }
	else if(fm.own_nm.value==""){ alert("��ǥ�ڸ� �Է��� �ּ���!"); fm.own_nm.focus(); return; }
	else if(fm.ent_no.value==""){ alert("����ڹ�ȣ�� �Է��� �ּ���!"); fm.ent_no.focus(); return; }
	else if(!isTel(fm.ent_no.value)){ alert("����ڹ�ȣ�� �ٽ� Ȯ���� �ּ���!"); fm.ent_no.focus(); return; }
	if(fm.acc_no.value!="" && fm.bank_cd.value=="" ){alert("������ ������ �ּ���!"); return;}
	if(!confirm('�ش������ü�� ����Ͻðڽ��ϱ�?')){ return; }
	fm.action = "cus0601_d_cont_in.jsp";
	fm.target = "i_no";
	fm.submit();
}
function search_zip()
{
	window.open("/acar/car_rent/zip_s.jsp", "�����ȣ�˻�", "left=200, top=100, height=500, width=400, scrollbars=yes");
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

<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="reg_id" value="<%=user_id%>">
<input type="hidden" name="off_type" value="<%=off_type%>">
<input type='hidden' name='from_page' value='<%=from_page%>'> 
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�����ü���</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>��ȣ</td>
                    <td colspan="3" align=left>&nbsp;<input type="text" name="off_nm" value="" size="49" class=text></td>
                    <td class=title>������ü</td>
                    <td>&nbsp;<select name="car_comp_id" style="width:100px">
                        <%for(int i=0; i<cc_r.length; i++){
        											cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                        <%}%>
                      </select> </td>
                    <td class=title>���</td>
                    <td>&nbsp;<select name="off_st">
                        <option value="1">1��</option>
                        <option value="2">2��</option>
                        <option value="3">3��</option>
                        <option value="4">4��</option>
                        <option value="5">5��</option>
                        <option value="6">��Ÿ</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class=title width=11%>��ǥ��</td>
                    <td width=15%>&nbsp;<input type="text" name="own_nm" value="" size="16" class=text></td>
                    <td width=10% class=title>����ڹ�ȣ</td>
                    <td width=15%>&nbsp;<input type="text" name="ent_no" value="" size="16" class=text OnBlur="CheckBizNo(this);"></td>
                    <td width=9% class=title>����</td>
                    <td width=15%>&nbsp;<input type="text" name="off_sta" value="" size="16" class=text></td>
                    <td width=10% class=title>����</td>
                    <td width=15%>&nbsp;<input type="text" name="off_item" value="" size="16" class=text></td>
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
				  <td colspan=5> &nbsp;
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="71">
				  </td>
                    <td class=title>�繫����ȭ</td>
                    <td>&nbsp;<input type="text" name="off_tel" value="" size="16" class=text></td>
                </tr>
                <tr> 
                    <td class=title>���°�������</td>
                    <td>&nbsp;
                    	<input type='hidden' name="bank" 			value="">
                    	<select name='bank_cd'>
                <option value=''>����</option>
                <%	for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
											//�ű��ΰ�� �̻������ ����
											if(String.valueOf(bank_ht.get("USE_YN")).equals("N"))	 continue;
								%>
                <option value='<%= bank_ht.get("CODE")%>' ><%= bank_ht.get("NM")%></option>
                <%	}%>
              </select></td>
                    <td class=title>���¹�ȣ</td>
                    <td>&nbsp;<input type="text" name="acc_no" value="" size="16" class=text></td>
                    <td class=title>������</td>
                    <td>&nbsp;<input type="text" name="acc_nm" value="" size="16" class=text></td>
                    <td class=title>�ѽ�</td>
                    <td>&nbsp;<input type="text" name="off_fax" value="" size="16" class=text></td>
                </tr>
                <tr> 
                    <td class=title>Ư�̻���</td>
                    <td align=left colspan=7>&nbsp;<input type="text" name="note" value="" size="115" class=text></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr> 
        <td align="right"><a href='javascript:ServOffReg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a> 
        &nbsp;&nbsp;<a href='javascript:self.close();window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
        </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>