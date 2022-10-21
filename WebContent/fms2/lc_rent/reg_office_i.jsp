<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");

	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CarCompBean cc_r [] = cod.getCarCompAll();
	CodeBean cd_r [] = c_db.getCodeAll("0003");	//������� �����´�.
	
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	
	function save(){
		var fm = document.form1;	
		//NN check
		if(fm.car_comp_id.value == '')			{ alert('�Ҽӻ縦 �������ּ���');			return;	 }
		else if(fm.car_off_st.value == '')		{ alert('�Ҽӻ籸���� �������ּ���');		return; }			
		else if((fm.car_off_nm.value == ''))	{ alert('����(�븮��)���� �Է����ּ���'); 	return; }
		else if(fm.car_off_tel.value == '')	{ alert('��ȭ��ȣ�� �Է��Ͻʽÿ�');			return; }
		else if(fm.car_off_fax.value == '')	{ alert('�ѽ���ȣ�� �Է��Ͻʽÿ�'); 		return; }
		else if(fm.t_addr.value == '')			{ alert('�ּҸ� �Է��Ͻʽÿ�'); 			return; }
					
		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//�׿��� ��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=400, scrollbars=yes");		
	}		
//-->
</script>
</head>

<body onload="javascript:document.form1.car_comp_id.focus();">
<form name='form1' action='reg_office_i_a.jsp' method='post'>
<input type="hidden" name="gubun_st" value="<%=gubun_st%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type='hidden' name='page_gubun' value='NEW'><!--���ο� ���� �����Ѵٴ� �ǹ�-->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�ڵ��������ҵ��</span></span> : �ڵ��������ҵ��</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align=right>
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a> 
        &nbsp;
        <%}%>
        <a href='javascript:history.go(-1);'><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>  
    <tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title">���ۻ�</td>
                    <td>&nbsp;<select name="car_comp_id">
                        <option value="">==����==</option>
                        <%for(int i=0; i<cc_r.length; i++){
        							cc_bean = cc_r[i]; %>
                        <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
                        <%}%>
                      </select></td>
                </tr>
                <tr> 
                    <td height="22" class="title">����</td>
                    <td>&nbsp;<input type="radio" name="car_off_st" value="1">
                      ����&nbsp; <input type="radio" name="car_off_st" value="2">
                      �븮��&nbsp; </td>
                </tr>
                <tr> 
                    <td height="22" class="title">����(�븮��)��</td>
                    <td>&nbsp;<input type='text' name='car_off_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
               	    <td>&nbsp;
               	      <input type='text' name='enp_no' value='' size='15' class='text' maxlength='15'> ('-'����)							
               	    </td>
                </tr>                       
                <tr> 
                    <td class="title">��ȭ��ȣ</td>
                    <td>&nbsp;<input type='text' name='car_off_tel' value='' size='30' class='text' maxlength='30'></td>
                </tr>
                <tr> 
                    <td class="title">�ѽ���ȣ</td>
                    <td>&nbsp;<input type='text' name='car_off_fax' size="30" maxlength='30' class='text' value=''></td>
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
                    <td class="title">�ּ�</td>
                    <td>&nbsp;
					<input type="text" name='t_zip' id="t_zip" value="" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" value="" size="45">
                    </td>
                </tr>
                <tr> 
                    <td class="title">���°�������</td>
                    <td>&nbsp;<select name="bank">
                        <option value="">����</option>
                        <%
        						for(int i=0; i<cd_r.length; i++){
        							cd_bean = cd_r[i];
        					%>
                        <option value="<%= cd_bean.getNm() %>"><%= cd_bean.getNm() %></option>
                        <%}%>
                      </select></td>
                </tr>
                <tr> 
                    <td class="title">���¹�ȣ</td>
                    <td>&nbsp;<input type='text' name='acc_no' size="30" maxlength='30' class='text' value=''></td>
                </tr>
                <tr> 
                    <td class="title">������</td>
                    <td>&nbsp;<input type='text' name='acc_nm' size="30" maxlength='30' class='text' value='' style='IME-MODE: active'></td>
                </tr>
                <tr>
               		<td class=title>�׿����ŷ�ó</td>
               		<td colspan=3>&nbsp;<input type='text' name='ven_name' size='40' value='' class='text' style='IME-MODE: active'>
					  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a> 	
			  		  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �ڵ� : <input type='text' name='ven_code' size='5' value='' class='text'>		
			  		  <br>
			  		  &nbsp;<input type="checkbox" name="ven_autoreg_yn" value="Y" <%if(gubun_st.equals("DLV")){ %>checked<%} %>> ������ ��Ͻ� �׿����ŷ�ó�� �ڵ� ����Ѵ�. (�����Ҹ�, ����ڵ�Ϲ�ȣ)
					</td>
                </tr>                    
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
