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
		if(fm.ncar_spe_dc_cau.value=='') 	{ alert('특별할인사유를 입력하십시오.'); 		return; }
		if(fm.ncar_spe_dc_amt.value==0) 	{ alert('특별할인금액을 입력하십시오.'); 		return; }	
		if(fm.ncar_spe_dc_day.value=='') 	{ alert('특별할인기간을 입력하십시오.'); 		return; }
		<%}%>
		
		if(confirm('등록하시겠습니까?')){
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 오프리스현황 > <span class=style5>특별할인결정</span></span></td>
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
                    <td class='title' width='15%'>차량번호</td>
                    <td width='35%'>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class='title' width='15%'>최초등록일</td>
                    <td width='35%'>&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                </tr>
                <tr> 
                    <td class='title'>차명</td>
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
                    <td class=title width='15%'>특별할인사유</td>
                    <td >&nbsp;<textarea rows='3' cols='70' name='ncar_spe_dc_cau'><%=cr_bean.getNcar_spe_dc_cau()%></textarea></td>
                </tr>                
                <tr> 
                    <td class=title>특별할인금액</td>
                    <td >&nbsp;<input type="text" name="ncar_spe_dc_amt" size="10" value='<%=AddUtil.parseDecimal(cr_bean.getNcar_spe_dc_amt())%>' class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					원</td>
                </tr>
                <tr> 
                    <td class=title>특별할인기간</td>
                    <td >&nbsp;<input type="text" name="ncar_spe_dc_day" size="10" value='<%=cr_bean.getNcar_spe_dc_day()%>' class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					일(결정일로부터)</td>
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