<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.watch.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String park_id 	= request.getParameter("park_id")==null?"":request.getParameter("park_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
%>
<HTML>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">

<script language='javascript'>
<!--
function save()
{
	var theForm = document.from;
	if(theForm.km.value == ''||theForm.km.value == '0'||theForm.km.value == ' ')						{	alert('��Ȯ�� ����Ÿ��� �Է��Ͻʽÿ�');			theForm.km.focus(); 		return;	}
	if(theForm.car_arr_id.value == '') {	alert('������� �����Ͻʽÿ�');			theForm.car_arr_id.focus(); 		return;	}
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	
	theForm.target = "i_no";
	theForm.submit();
}

//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</HEAD>
<BODY onLoad="javascript:document.from.km.focus();">
<form action="off_ls_km_a.jsp" name='from' method='post'>
    <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
	<input type="hidden" name="park_id" value="<%=park_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �Ű�����������Ȳ >  <span class=style5>����Ÿ� / ����� ��� ���</span></span></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="" class='title'>������� ��������Ÿ�</td>
                    <td>&nbsp;<input type="text" name="km" value="" class="num">km</td>
                </tr>
				<tr> 
                    <td width="" class='title'>����� Ź�ۿϷ�����</td>
                    <td>&nbsp;<input type="text" name="car_out_dt" value="<%=AddUtil.getDate()%>"></td>
                </tr>
				<tr> 
                    <td width="" class='title'>��Ÿ����</td>
                    <td>&nbsp;<input type="text" name="car_gita" value=""></td>
                </tr>
				<tr> 
                    <td width="" class='title'>�����</td>
                    <td>&nbsp;
	                    <select name="car_arr_id">
			                <option value="">����</option>
			                <option value="000502">����۷κ�(��)-��ȭ</option>
							<option value="013011">����۷κ�(��)-�д�</option>
			                <option value="020385">�������̼�ī(��)</option>
							<option value="022846">�Ե���Ż((��)����Ƽ��Ż)</option>
			           </select>
                    </td>
                </tr>
            </table>
        </td>
	</tr>
	<tr>
		<td align="right"><a href="javascript:save()"><img src=/acar/images/center/button_reg.gif border=0  align=absmiddle></a></td>
	</tr>
</table>

</form>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</BODY>
</HTML>
