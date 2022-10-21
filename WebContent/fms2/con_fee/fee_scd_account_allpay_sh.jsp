<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String t_wd1 	= request.getParameter("t_wd1")==null?"":request.getParameter("t_wd1");
	String t_wd2 	= request.getParameter("t_wd2")==null?"":request.getParameter("t_wd2");
	String t_wd3 	= request.getParameter("t_wd3")==null?"":request.getParameter("t_wd3");
	String t_wd4 	= request.getParameter("t_wd4")==null?"":request.getParameter("t_wd4");

	
	Vector fee_scd = af_db.getFeeScdPrint2(l_cd, "", false);
	int fee_scd_size = fee_scd.size();
	
	int f_tm = 0;
	int l_tm = 0;
	
	for(int i = 0 ; i < fee_scd_size ; i++){
		FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
		if(a_fee.getRc_yn().equals("0")){ //���Ա�
			if(f_tm == 0){
				f_tm = AddUtil.parseInt(a_fee.getFee_tm());
			}
			l_tm = AddUtil.parseInt(a_fee.getFee_tm());
		}
	}
	
	if(t_wd1.equals("")) t_wd1 = String.valueOf(f_tm);
	if(t_wd2.equals("")) t_wd2 = String.valueOf(l_tm);
	if(t_wd4.equals("")) t_wd4 = AddUtil.getDate(4);
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
		if(fm.t_wd1.value == ''){ alert('����ȸ���� �����Ͻʽÿ�.'); return;}
		if(fm.t_wd2.value == ''){ alert('������ȸ���� �����Ͻʽÿ�.'); return;}
		if(fm.t_wd3.value == ''){ alert('�������� �����Ͻʽÿ�.'); return;}
		if(fm.t_wd4.value == ''){ alert('���ο������ڸ� �����Ͻʽÿ�.'); return;}
		fm.print_yn.value = '';
		fm.action='fee_scd_account_allpay_sc.jsp';
		fm.target = 'p_body';
		fm.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function print_view(){
		if(toInt(parent.p_body.document.form1.t_amt.value) >0){ 
			var fm = document.form1;
			window.open("about:blank", "AllPayAccountPrint", "left=150, top=20, width=900, height=900, scrollbars=yes");
			fm.print_yn.value = 'Y';
			fm.action = "fee_scd_account_allpay_sc.jsp";
			fm.target = "AllPayAccountPrint";
			fm.submit();			
		}else{
			alert('����Ʈ�� ������ �����ϴ�.');
		}
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='fee_scd_account_allpay_sc.jsp' target='p_body' method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='print_yn' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�뿩�� �Ͻó� ���(6����ġ �̻�)</span></span></td>
                    <td class=bar style='text-align:right'>&nbsp;</td>
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
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width=20%>���� ����ȸ��</td>
                    <td width=30%>&nbsp;
                        <select name='t_wd1'>
                        	<%for(int i = f_tm ; i < l_tm ; i++){%>
                        	<option value='<%=i%>' <%if(i==AddUtil.parseInt(t_wd1)){%>selected<%}%>><%=i%></option>
                        	<%}%>
   					            </select> ȸ��
                    </td>
                    <td>&nbsp; �̳� �Ǵ� �̵��� ȸ���� ���ð���</td>
                </tr>    
                <tr>
                    <td class='title' width=20%>���� ������ȸ��</td>
                    <td>&nbsp;
                        <select name='t_wd2'>
                        	<%int l_cnt = 0;
                        		for(int i = f_tm+5 ; i < l_tm+1 ; i++){
                        			l_cnt++;
                        	%>
                        	<option value='<%=i%>' <%if(i==AddUtil.parseInt(t_wd2)){%>selected<%}%>><%=i%></option>
                        	<%}%>
                        	<%if(l_cnt==0){%>
                        	<option value='-'>-</option>
                        	<%}%>
   					            </select> ȸ��
                    </td>
                    <td>&nbsp; �̳� �Ǵ� �̵��� ȸ���� ���ð���</td>
                </tr>    
                <tr>
                    <td class='title' width=20%>������</td>
                    <td>&nbsp;
                        <select name='t_wd3'>
                        	<option value='4.5' <%if(t_wd3.equals("4.5")){%>selected<%}%>>4.5% (�⺻��)</option>
                        	<option value='5' <%if(t_wd3.equals("5")){%>selected<%}%>>5% (�����������)</option>
   					            </select>
                    </td>
                    <td>&nbsp;</td>
                </tr>         
                <tr>
                    <td class='title' width=20%>���ο�������</td>
                    <td>&nbsp;
                        <input type='text' name='t_wd4' value='<%=AddUtil.ChangeDate2(t_wd4)%>' maxlength='10' size='12' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);' onKeyDown='javascript:enter()'>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <%if(l_cnt>0){%>
                        <input type="button" class="button" value="����ϱ�" onclick="javascript:search();">
                        <%}else{%>
                        <font color=red>6�����̸����� �Ͻó������ �ȵ˴ϴ�.</font>
                        <%}%>
                    </td>
                    <td>&nbsp; �� �뿩�� �Ͻó� ����� 6����ġ �̻� ����</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
        	<a href="javascript:print_view();" title='�⺻' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<a href='javascript:parent.window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr> 
        <td><hr></td>
    </tr>
</table>
</form>
</body>
</html>
