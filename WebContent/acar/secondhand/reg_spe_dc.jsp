<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*" %>
<jsp:useBean id="cr_bean" 	class="acar.car_register.CarRegBean" 		scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	
	
	cr_bean = crd.getCarRegBean(car_mng_id);
	
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
	function save(){
		fm = document.form1;
		
		if(fm.spe_dc_st.value=='Y'){
			if(fm.spe_dc_cau.value=='') 		{ alert('���� ������ �Է��Ͻʽÿ�.'); 		return; }
			if(toFloat(fm.spe_dc_per.value)==0) 	{ alert('�������� �Է��Ͻʽÿ�.'); 		return; }			
		}else{
			if(toFloat(fm.spe_dc_per.value)>0) 	{ alert('�������� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); 	return; }
		}
							
		if(!confirm("���� �Ͻðڽ��ϱ�?"))	return;
		fm.action = "reg_spe_dc_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="user_id=" value="<%=user_id%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5><%=cr_bean.getCar_no()%> Ư������ ����</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 ></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title>Ư������ ��������</td>
                    <td >&nbsp;<select name="spe_dc_st">
                      <option value="N" <%if(cr_bean.getSpe_dc_st().equals("N")){%>selected<%}%>>������</option>
                      <option value="Y" <%if(cr_bean.getSpe_dc_st().equals("Y")){%>selected<%}%>>����</option>
                    </select></td>
                </tr>
                <tr> 
                    <td class=title>���� ����</td>
                    <td >&nbsp;<input type="text" name="spe_dc_cau" value="<%=cr_bean.getSpe_dc_cau()%>" size="30" class=text style='IME-MODE: active'></td>
                </tr>                
                <tr> 
                    <td class=title>������</td>
                    <td >&nbsp;<input type="text" name="spe_dc_per" size="4" value='<%=cr_bean.getSpe_dc_per()%>' class=num>
					%</td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td >&nbsp;<input type='text' size='11' name='spe_dc_s_dt' class='text' value='<%=AddUtil.ChangeDate2(cr_bean.getSpe_dc_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    ~
                    <input type='text' size='11' name='spe_dc_d_dt' class='text' value='<%=AddUtil.ChangeDate2(cr_bean.getSpe_dc_d_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
					</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>  
        <td align="right">
	    <a href="javascript:save();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	    </td>	
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
