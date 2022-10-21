<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function insert_item(){
	var fm = document.form1;
	if(fm.item.value==""){	alert("���񳻿��� �Է��� �ּ���!");	fm.item.focus(); return; }
	
	if(confirm('����Ͻðڽ��ϱ�?')){
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
		
		fm.action = "item_serv_iu.jsp";
		fm.target = "i_no";
		fm.submit();
		
		link.getAttribute('href',originFunc);
	}
}
function item_del(){
	var fm = document.item_serv_in.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;
			}
		}
	}
	if(cnt == 0){ alert("������ �۾��̳� ��ǰ�� �����ϼ��� !"); return; }
	if(!confirm('������ �κ��� ���� �Ͻðڽ��ϱ�?')){	return;	}
	fm.action = "item_serv_del.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>";
	fm.target = "i_no";
	fm.submit();
}
function item_del_all(){
	fm = document.form1;
	if(!confirm('��ü ���� �Ͻðڽ��ϱ�?')){	return;	}
	fm.action = "item_serv_del.jsp?del=all";
	fm.target = "i_no";
	fm.submit();
}
function itemAmt(danga){
	var fm = document.form1;
	var cnt = parseDigit(fm.count.value);
	fm.amt.value = parseDecimal(cnt * parseDigit(danga));
	fm.amt.focus(); //fm.labor.focus(); ����
	return parseDecimal(danga);
}
function changeWk_st(arg){
	var fm = document.form1;
	if(arg=="1"){
		fm.wk_st.value = "��ȯ";
	}else if(arg=="2"){
		fm.wk_st.value = "����";
	}else if(arg=="3"){
		fm.wk_st.value = "Ż��";
	}else if(arg=="4"){
		fm.wk_st.value = "����Ȧ";		
	}else if(arg=="5"){
		fm.wk_st.value = "�Ǳ�";		
	}

}
function changeItem_st(arg){
	var fm = document.form1;
	if(arg=="1"){
		fm.item_st.value = "���۾�";
	}else if(arg=="2"){
		fm.item_st.value = "�μ��۾�";		
	}else if(arg=="3"){
		fm.item_st.value = "��ǰ";
	}
}

//-->
</script>
</head>

<body onLoad="document.form1.item_st.focus();">
<form name="form1" action="" method="post">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="serv_id" value="<%= serv_id %>">
<input type="hidden" name="seq_no" value="">
<input type="hidden" name="item_id" value="">
<table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td width="75%"><img src=../images/center/icon_arrow.gif border=0 align=absmiddle> <span class=style2>�����׸�</span>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="javascript:item_del()"><img src=../images/center/button_delete_s.gif border=0 align=absmiddle></a> 
                    <a href="javascript:item_del_all()"><img src=../images/center/button_delete_all.gif border=0 align=absmiddle></a>
                    </td>
                    <td width="25%">&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td class=title width=5%>����</td>
                                            <td class=title width=5%>����</td>
                                            <td class=title width=7%>����</td>
                                            <td class=title width=20%>����</td>
                                            <td class=title width=7%>�۾�</td>
                                            <td class=title width=7%>����</td>
                                            <td class=title width=10%>�ܰ�</td>
                                            <td class=title width=10%>��ǰ�ڵ�</td>
                                            <td class=title width=10%>��ǰ����</td>
                                            <td class=title width=10%>����</td>
                                            <td class=title width=9%>����ó</td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=17>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2"><iframe src="item_serv_in.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>" name="item_serv_in" width="100%" height="112" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                </tr>
                <tr> 
                    <td colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td class="line">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                            <td width=5%>&nbsp;</td>
                                            <td width=5% align="center">&nbsp;</td>
                                            <td width=7% align="center"><input type="text" name="item_st" size="6" class=text onBlur='javascript:changeItem_st(this.value)'></td>
                                            <td width=20%>&nbsp; <input type="text" name="item" size="20" class=text style='IME-MODE: active'></td>
                                            <td width=7% align="center"><input type="text" name="wk_st" size="6" class=text onBlur='javascript:changeWk_st(this.value)'></td>
                                            <td width=7% align="center"><input type=text name="count" value="" size=3 class=num onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                                            <td width=10% align="center"><input type=text name="price" value="" size=7 class=num onBlur='javascript:this.value=itemAmt(this.value)'></td>
                                            <td width=10%>&nbsp; <input type="text" name="item_cd" size="10" class=text></td>						
                                            <td width=10% align="center"><input type=text name="amt" value="" size=8 class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                                              ��</td>
                                            <td width=10% align="center"><input type=text name="labor" value="" size=8 class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
                                              ��</td>
                                            <td width=9% align="center"><select name="bpm">
                                                <option value="1">�ڰ�</option>
                                                <option value="2" selected>��ü</option>
                                              </select></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=17>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td><div align="left">
                        <a id="submitLink" href="javascript:insert_item()"><img src=../images/center/button_conf.gif border=0 align=absmiddle></a>
                        </div></td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td><div align="left"><font color="red">�ر���(1:���۾�,2:�μ��۾�,3:��ǰ) 
                        &nbsp;&nbsp;&nbsp;���۾�(1:��ȯ,2:����,3:Ż��,4:����Ȧ,5:�Ǳ�)</font>                        
                        </div></td>
                    <td>&nbsp;</td>
                </tr>                
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
