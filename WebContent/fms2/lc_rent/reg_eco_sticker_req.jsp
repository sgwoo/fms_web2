<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	//����� �������
	LongRentBean base = ScdMngDb.getScdMngLongRentInfo(rent_mng_id, rent_l_cd);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script src='/include/common.js'></script>
<script>
<!--
	function save()
	{
		var fm = document.form1;
		
		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.action = "reg_eco_sticker_req_a.jsp";	
			fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>

<body>
<form action='' name='form1' method='post'>
<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
<table border=0 cellspacing=0 cellpadding=0 width=600>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> <span class=style5>�����ؽ�ƼĿ ��߱޿�û</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
			    <tr>
			    	<td width="80" class='title'>����ȣ</td>
			    	<td width="120">&nbsp;<%=rent_l_cd%></td>
			    	<td width="80" class='title'>��ȣ</td>
			    	<td width="320">&nbsp;<%=base.getFirm_nm()%></td>
			    </tr>		
			    <tr>
			    	<td class='title'>������ȣ</td>
			    	<td>&nbsp;<%=base.getCar_no()%></td>
			    	<td class='title'>����</td>
			    	<td>&nbsp;<%=base.getCar_nm()%></td>
			    </tr>
			    <tr>		
			    	<td class='title'>�ּ�����</td>
			    	<td>&nbsp;
			    		<select name='post_st'>
								<option value='���þ���'>����</option>
								<option value="�����" selected>�����</option>		
								<option value="����">����</option>
								<option value="�����ּ���">�����ּ���</option>
								<option value="��Ÿ">��Ÿ</option>
               			</select>
               		</td>
             		<td class='title'>����ó</td>
			     	<td>&nbsp;<%=base.getM_tel()%></td>
			     </tr>
               	<tr >
            		<td colspan="1" class='title' >���</td>
			     	<td colspan="3" >&nbsp;<input type="text" name="post_etc" size="50" class="text" value=""></td>
			    </tr>
            	
			</table>
		</td>
	</tr>	
    <tr>
        <td class=h></td>
    </tr> 		
    <tr>
        <td><font color='red'>�� ��� �ݼ�/�н� ���� ��û���� ���� ���� ������ �ּ� Ȯ�� �ʼ�</font></td>
    </tr> 		    
    <tr>
	    <td align='center'>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>			
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
			    