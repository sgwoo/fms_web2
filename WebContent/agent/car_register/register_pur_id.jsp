<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*, acar.cont.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%

	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");

	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
%>

<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Save()
	{
		var fm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?'))
		{
			return;
		}
		fm.cmd.value = "u";
		fm.target = "i_no"
		fm.submit();
	}
	
	//���/����: �������� �Է½� �ڵ�������� ����..
	function enter_car(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_car_amt(obj);
	}	
	//���/����: ���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_car_amt(obj)
	{
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		if(obj==fm.sd_cv_amt || obj==fm.sd_cs_amt){
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));		
		}
		if(obj==fm.car_fv_amt || obj==fm.car_fs_amt){
			fm.car_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
		}		
		sum_car_f_amt();	
	}

	//���� ���԰� �հ�
	function sum_car_f_amt(){
		var fm = document.form1;				
		
		fm.so_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.so_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.so_amt.value 	= parseDecimal(toInt(parseDigit(fm.so_s_amt.value)) + toInt(parseDigit(fm.so_v_amt.value)) );							

		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							
	}	
	
	//����DC
	function search_dc(){
		var fm = document.form1;
		window.open("/agent/lc_rent/search_dc.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "COMP_DC", "left=100, top=100, height=200, width=800, scrollbars=yes, status=yes");
	}
	
	//�ΰ�����������
	function cng_input_vat(st)
	{
		var fm 		= document.form1;
		var inVat 	= 0;
		var inAmt	= 0;
				
		if(st == 'car'){
			inVat	= toInt(parseDigit(fm.car_fv_amt.value));
			if(fm.vat_Rdio[0].checked == true && inVat > 0){	inAmt = Math.round(inVat + 1);	}
			if(fm.vat_Rdio[1].checked == true && inVat > 0){	inAmt = Math.round(inVat - 1);	}		
			fm.car_fv_amt.value = parseDecimal(inAmt);
			fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - inAmt);
		}else if(st == 'dc'){		
			inVat	= toInt(parseDigit(fm.dc_cv_amt.value));
			if(fm.vat_Rdio[2].checked == true && inVat > 0){	inAmt = Math.round(inVat + 1);	}
			if(fm.vat_Rdio[3].checked == true && inVat > 0){	inAmt = Math.round(inVat - 1);	}		
			fm.dc_cv_amt.value = parseDecimal(inAmt);
			fm.dc_cs_amt.value = parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - inAmt);							
		}else if(st == 'sd'){
			inVat	= toInt(parseDigit(fm.sd_cv_amt.value));
			if(fm.vat_Rdio[4].checked == true && inVat > 0){	inAmt = Math.round(inVat + 1);	}
			if(fm.vat_Rdio[5].checked == true && inVat > 0){	inAmt = Math.round(inVat - 1);	}		
			fm.sd_cv_amt.value = parseDecimal(inAmt);
			fm.sd_cs_amt.value = parseDecimal(toInt(parseDigit(fm.sd_c_amt.value)) - inAmt);		
		}		
		sum_car_f_amt();
	}	
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:sum_car_f_amt()">
<form action="./register_pur_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="cmd" value="">
 
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <input type="hidden" name="brch_id" value="<%=brch_id%>">
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
  <input type='hidden' name="s_dc1_re" 	value="<%=car.getS_dc1_re()%>">
  <input type='hidden' name="s_dc1_yn" 	value="<%=car.getS_dc1_yn()%>">
  <input type='hidden' name="s_dc1_amt"	value="<%=car.getS_dc1_amt()%>">
  <input type='hidden' name="s_dc2_re" 	value="<%=car.getS_dc2_re()%>">
  <input type='hidden' name="s_dc2_yn" 	value="<%=car.getS_dc2_yn()%>">
  <input type='hidden' name="s_dc2_amt"	value="<%=car.getS_dc2_amt()%>">
  <input type='hidden' name="s_dc3_re" 	value="<%=car.getS_dc3_re()%>">
  <input type='hidden' name="s_dc3_yn" 	value="<%=car.getS_dc3_yn()%>">
  <input type='hidden' name="s_dc3_amt"	value="<%=car.getS_dc3_amt()%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ������</span></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="3" class='title'>�������</td>
                    <td colspan="4">&nbsp;<input type="text" name="dlv_dt" value="<%=AddUtil.ChangeDate2(base.getDlv_dt())%>" size="11" maxlength='12' class=<%if(cmd.equals("ud")){%>white<%}%>text onBlur='javascript:this.value=ChangeDate(this.value);'>
        			(�����ȣ : <%=pur.getRpt_no()%>)
        			</td>
                </tr>
                <tr>
                    <td colspan="3" class='title'>����</td>
                    <td width="20%" class='title'>���ް�</td>
                    <td width="20%" class='title'>�ΰ���</td>
                    <td width="20%" class='title'><span class=b><a href="javascript:sum_car_f_amt()" title="���԰� �հ� ����ϱ�">�հ�</a></span></td>
                    <td width="20%" class='title'>�ΰ�����������</td>			
                </tr>
                <tr>
                    <td width="3%" rowspan="4" class=title>��<br>��<br>
                    ��<br>��</td>
                    <td width="3%" rowspan="3" class=title>��<br>��</td>
                    <td width="14%" class=title>�Һ��ڰ���</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='<%if(cmd.equals("ud")){%>white<%}%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
                      ��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='<%if(cmd.equals("ud")){%>white<%}%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
                      ��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' readonly maxlength='13' class='<%if(cmd.equals("ud")){%>white<%}else{%>fix<%}%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
                      ��</td>
                    <td align="center"><%	if(!cmd.equals("ud")){//����%><input type="radio" name="vat_Rdio" value="0" onClick="javascript:cng_input_vat('car')" > ����
        			      		<input type="radio" name="vat_Rdio" value="1" onClick="javascript:cng_input_vat('car')">����<%}%></td>			  
                </tr>
                <tr>
                    <td class=title>����D/C&nbsp;<a href="javascript:search_dc()" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></td>
                    <td align="center">&nbsp;
                      -<input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='<%if(cmd.equals("ud")){%>white<%}else{%>fix<%}%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
                      ��</td>
                    <td align="center">&nbsp;
                      -<input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='<%if(cmd.equals("ud")){%>white<%}else{%>fix<%}%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
                      ��</td>
                    <td align="center">&nbsp;
                      -<input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='<%if(cmd.equals("ud")){%>white<%}else{%>fix<%}%>num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
                      ��</td>
                    <td align="center"><%	if(!cmd.equals("ud")){//����%><input type="radio" name="vat_Rdio" value="0" onClick="javascript:cng_input_vat('dc')" > ����
        			      		<input type="radio" name="vat_Rdio" value="1" onClick="javascript:cng_input_vat('dc')">����<%}%></td>		
                </tr>		
                <tr>
                    <td align='center' class='title_p'>�Ұ�</td>
                    <td align="center" class='title_p'>&nbsp;
                      <input name='so_s_amt' type='text' class='rednum' id="so_s_amt" value='' size='10' readonly>
                      ��</td>
                    <td align="center" class='title_p'>&nbsp;
                      <input name='so_v_amt' type='text' class='rednum' id="so_v_amt" value='' size='10' readonly>
                      ��</td>
                    <td align="center" class='title_p'>&nbsp;
                      <input name='so_amt' type='text' class='rednum' id="so_amt" value='' size='10'  readonly>
                      ��</td>
        			<td class='title_p'>&nbsp;</td>  
                </tr>		    
                <tr>
                    <td class=title style='height:34'>��<br>
                    ��</td>
                    <td class=title>Ź�۷�</td>
                    <td height="12" align="center">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='<%if(cmd.equals("ud")){%>white<%}%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
                      ��</td>
                    <td height="12" align="center">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='<%if(cmd.equals("ud")){%>white<%}%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
                      ��</td>
                    <td height="12" align="center">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' readonly maxlength='7' class='<%if(cmd.equals("ud")){%>white<%}else{%>fix<%}%>num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
                      ��</td>
                    <td align="center"><%	if(!cmd.equals("ud")){//����%><input type="radio" name="vat_Rdio" value="0" onClick="javascript:cng_input_vat('sd')" > ����
        			      		<input type="radio" name="vat_Rdio" value="1" onClick="javascript:cng_input_vat('sd')">����<%}%></td>		          
    		    </tr>
                <tr>
                    <td colspan="3" align='center' class='title_p'>�հ�</td>
                    <td align="center" class='title_p'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='rednum' readonly>
                      ��</td>
                    <td align="center" class='title_p'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='rednum' readonly>
                      ��</td>
                    <td align="center" class='title_p'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='rednum'  readonly>
                      ��</td>
        			<td class='title_p'>&nbsp;</td>  
                </tr>
                <tr>
                    <td colspan="3" class='title'>�ݾ���������</td>
                    <td colspan="4">&nbsp;<input type="text" name="car_amt_dt" <%if(car.getCar_amt_dt().equals("")){%>value="<%=AddUtil.getDate()%>"<%}else{%>value="<%=AddUtil.ChangeDate2(car.getCar_amt_dt())%>"<%}%> size="11" maxlength='12' class=<%if(cmd.equals("ud")){%>white<%}%>text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>		  
                <tr>
                    <td colspan="3" class='title'>���ݰ�꼭����</td>
                    <td colspan="4">&nbsp;<input type="text" name="car_tax_dt" <%if(car.getCar_tax_dt().equals("")){%>value="<%=AddUtil.ChangeDate2(base.getDlv_dt())%>"<%}else{%>value="<%=AddUtil.ChangeDate2(car.getCar_tax_dt())%>"<%}%> size="11" maxlength='12' class=<%if(cmd.equals("ud")){%>white<%}%>text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>		  
            </table>
	    </td>
    </tr>
</table>
<%	if(!cmd.equals("ud")){//����%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td align="right"><a href="javascript:Save()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
<%	}%>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>