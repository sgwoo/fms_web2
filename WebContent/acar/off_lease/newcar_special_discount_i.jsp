<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.car_register.*"%>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	CarRegDatabase crd 	= CarRegDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	if(car_mng_id.equals("")){
		String vid[] 	= request.getParameterValues("pr");
		int vid_size = vid.length;
		for(int i = 0 ; i < vid_size ; i++){
			car_mng_id = vid[i];
		}
	}
	
	cr_bean = crd.getCarRegBean(car_mng_id);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1;

		<%if(!ck_acar_id.equals("000029")){%>	
		if(fm.ncar_spe_dc_cau.value=='') 	{ alert('Ư�����λ����� �Է��Ͻʽÿ�.'); 		return; }
		if(fm.ncar_spe_dc_amt.value==0) 	{ alert('Ư�����αݾ��� �Է��Ͻʽÿ�.'); 		return; }	
		if(fm.ncar_spe_dc_day.value=='') 	{ alert('Ư�����αⰣ�� �Է��Ͻʽÿ�.'); 		return; }
		<%}%>
		
		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.action = "newcar_special_discount_i_a.jsp";	
			//fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>

<body>
<form action='' name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>

<table border=0 cellspacing=0 cellpadding=0 width=600>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> ����������Ȳ > <span class=style5>Ư�����ΰ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>������ȣ</td>
                    <td width='35%'>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class='title' width='15%'>���ʵ����</td>
                    <td width='35%'>&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td colspan='3'>&nbsp;<%=cr_bean.getCar_nm()%></td>                    
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>    
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width='15%'>Ư�����λ���</td>
                    <td >&nbsp;<textarea rows='3' cols='70' name='ncar_spe_dc_cau'><%=cr_bean.getNcar_spe_dc_cau()%></textarea></td>
                </tr>                
                <tr> 
                    <td class=title>Ư�����αݾ�</td>
                    <td >&nbsp;<input type="text" name="ncar_spe_dc_amt" size="10" value='<%=AddUtil.parseDecimal(cr_bean.getNcar_spe_dc_amt())%>' class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					��</td>
                </tr>
                <tr> 
                    <td class=title>Ư�����αⰣ</td>
                    <td >&nbsp;<input type="text" name="ncar_spe_dc_day" size="10" value='<%=cr_bean.getNcar_spe_dc_day()%>' class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					��(�����Ϸκ���)</td>
                </tr>
            </table>
        </td>
    </tr>	    
    <tr>
        <td class=h></td>
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