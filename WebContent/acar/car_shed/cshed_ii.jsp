<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String brch 	= request.getParameter("brch")==null?"":request.getParameter("brch");
	
	
	
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--

	function save()
	{
		if(confirm('����Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;
			fm.target='i_no';
			fm.submit();
		}
	}
	
	function go_to_list()
	{
		location = '/acar/car_shed/cshed_frame_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>';
	}
	
	function set_zip(idx)
	{
		var fm = document.form1;
		fm.zip_idx.value = idx;
		window.open("/acar/car_shed/zip_s.jsp", "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
	
	function set_result(zip, addr)
	{
		var fm = document.form1;
		var idx = fm.zip_idx.value;
		if(idx == 1)
		{
			fm.lea_h_post.value = zip;
			fm.lea_h_addr.value = addr;
		}
		else if(idx == 2)
		{
			fm.lea_o_post.value = zip;
			fm.lea_o_addr.value = addr;
		}
		else if(idx == 3)
		{
			fm.lend_h_post.value = zip;
			fm.lend_h_addr.value = addr;
		}
		else if(idx == 4)
		{
			fm.lend_o_post.value = zip;
			fm.lend_o_addr.value = addr;
		}
		else if(idx == 5)
		{
			fm.lend_post.value = zip;
			fm.lend_addr.value = addr;
		}
	}
	
	//�Ӵ�/�߰��λ��� ������ּ�
	function set_lea_o_addr()
	{
		var fm = document.form1;
		if(fm.lea_o_addr_copy.checked == true)
		{
			fm.lea_o_post.value = fm.lea_h_post.value;
			fm.lea_o_addr.value = fm.lea_h_addr.value;
		}
		else
		{
			fm.lea_o_post.value = '';
			fm.lea_o_addr.value = '';
		}
	}		
	
	//�������� ������ּ�
	function set_lend_o_addr()
	{
		var fm = document.form1;
		if(fm.lend_o_addr_copy.checked == true)
		{
			fm.lend_o_post.value = fm.lend_h_post.value;
			fm.lend_o_addr.value = fm.lend_h_addr.value;
		}
		else
		{
			fm.lend_o_post.value = '';
			fm.lend_o_addr.value = '';
		}
	}	

//�ݾ� ����
	function set_amt(){
		var fm = document.form1;	
		
			fm.hsjsg_amt.value 	= toInt(parseDigit(fm.bjg_amt.value)) + (toInt(parseDigit(fm.wsg_amt.value)) * 100) ;

		}	
//-->
</script>
</head>
<body leftmargin="15">
<form action="/acar/car_shed/cshed_i_a.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brch' value='<%=brch%>'>
<input type='hidden' name='zip_idx' value=''>
<input type='hidden' name='shed_st' value='2'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > �ڵ���� > <span class=style5>�繫�ǰ����׵��</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
        <td></td>
    </tr>
	<tr>
    	<td align=right>
    		<a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
    		<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=../images/center/button_list.gif border=0 align=absmiddle></a>
    	</td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
    	<td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�繫�ǰ�����</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>

    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
    		<table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=12%>�ǹ���Ī</td>
               		<td width=21%>&nbsp;<input type="text" name="shed_nm" value="" size="30" maxlength='20' class=text></td>
               		<td class=title width=12%>������(�Ӵ���)</td>
               		<td width=20%>&nbsp;<input type="text" name="lea_nm" value="" size="30" maxlength='30' class=text></td>
               		<td class=title width=12%>������</td>
               		<td width=23%>&nbsp;<input type="text" name="bjg_amt" value="" size="25" maxlength='30' class=num onBlur='javascript:set_amt();'></td>
                </tr>
                <tr>
                    <td class=title>���Ⱓ</td>
               		<td>&nbsp;<input type="text" name="lea_st_dt" value="" size=12 maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' class='text'> - <input type="text" name="lea_end_dt" value="" size=10 maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' class='text'></td>
               		<td class=title>�Ӵ�����޾�������</td>
               		<td>&nbsp;<input type="text" name="im_in_dt" value="" size="12" maxlength='10' class=text></td>
               		<td class=title>������</td>
               		<td>&nbsp;<input type="text" name="wsg_amt" value="" size="25" maxlength='30' class=num onBlur='javascript:set_amt();'></td>
                </tr>
                <tr>
                    <td class=title>������</td>
               		<td>&nbsp;<select name="mng_off">
						<option value=''>��ü</option>
						<option value='S1'  >����</option>
						<option value='K2'  >��õ������</option>
						<option value='K1'  >���ֿ�����</option>
						<option value='D1'  >��������</option>
						<option value='B1'  >�λ�����</option>
						<option value='N1'  >���ؿ�����</option>
						<option value='I1'  >��õ����</option>
						<option value='S2'  >��������</option>
						<option value='J1'  >��������</option>
						<option value='G1'  >�뱸����</option>
						<option value='K3'  >��������</option>
						</select></td>
                    <td class=title>�ǿ�����</td>
               		<td>&nbsp;<select name="lend_region">
						<option value="������">������</option>
						<option value="�����ǿ�">�����ǿ�</option>
						</select>
					</td>
					<td class=title>ȯ��������</td>
               		<td>&nbsp;<input type="text" name="hsjsg_amt" value="" size="25" maxlength='30' class=num></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=12%>��������Ī</td>
                    <td width=24%>&nbsp;<input type="text" name="car_lend" value="" size="35" maxlength='120' class=text></td>
                    <td class=title width=12%>�Ӵ��(������)</td>
                    <td width=20%>&nbsp;<input type="text" name="car_lend_amt" value="" size="20" maxlength='120' class=num></td>
                    <td class=title width=14%>�Ӵ�����޾�������</td>
                    <td width=18%>&nbsp;<input type="text" name="car_lend_dt" value="" size="20" maxlength='20' class=text></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
