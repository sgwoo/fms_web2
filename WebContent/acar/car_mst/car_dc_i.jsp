<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String car_u_seq 	= request.getParameter("car_u_seq")	==null?"":request.getParameter("car_u_seq");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	
	if(car_comp_id.equals("")) car_comp_id="0001";
	
	//�ڵ���ȸ�� ����Ʈ
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�ڵ���ȸ�� ���ý� �����ڵ� ����ϱ�
	function GetCarCode(){
		re_init(1);
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}

	//���� ���ý� ���ؿ� ����ϱ�
	function GetViewDt(){
		re_init(1);
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.view_dt;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.view_dt";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.code.value = fm.code.value;		
		fm2.mode.value = '3';
		fm2.target="i_no";
		fm2.submit();
		if(fm.view_dt.value != ''){
			Search();
		}
	}
	
	//�ε��� �ڵ���ȸ��=������ �����ڵ� ����ϱ�
	function init(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = '<%=car_comp_id%>';
		fm2.mode.value = '1';
		fm2.target="i_no";
		fm2.submit();
	}
	
	//�ε���
	function re_init(st){
		var theForm = parent.document.form1;	
		if(st == '1'){
			theForm.car_u_seq.value = '';
		}
		theForm.car_d_seq.value 	= '';
		theForm.car_d.value 		= '';
		theForm.car_d_dt.value 		= '';	
		theForm.car_d_dt2.value 	= '';	
		theForm.car_d_p.value 		= '';		
		theForm.car_d_per.value 	= '';				
		theForm.car_d_p2.value 		= '';		
		theForm.car_d_per2.value 	= '';	
		theForm.car_d_per_b.value 	= '';		
		theForm.car_d_per_b2.value 	= '';		
		theForm.ls_yn.checked 		= false;
		parent.tr_ls1.style.display = "none";
		parent.tr_ls2.style.display = "none";				
	}
		
	function CarNmReg(){
		var theForm = document.form1;
		if(!CheckField()){	return;	}
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "i";
		theForm.target="i_no";
		theForm.action="car_dc_null_ui.jsp";
		theForm.submit();
	}

	function CarNmUp(){
		var theForm = document.form1;
		if(!CheckField()){	return;	}
		if(theForm.car_d_seq.value == ''){ alert('���� ��ϵ��� ���� DC�Դϴ�.');}
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "u";
		theForm.target="i_no";
		theForm.action="car_dc_null_ui.jsp";
		theForm.submit();
	}

	function CarNmDel(){
		var theForm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "d";
		theForm.target="i_no";
		theForm.action="car_dc_null_ui.jsp";
		theForm.submit();
	}
	
	function CarDcUpg(){
		var theForm = document.form1;
		if(!confirm('�ϰ� ���׷��̵� �Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "upd";
		theForm.target="i_no";
		theForm.action="car_dc_null_ui.jsp";
		theForm.submit();	
	}
	
	function CarDcUpgSee(){
		var theForm = document.form1;
		if(theForm.upd_d_dt.value==""){
			alert("�ϰ����⸦ �� �������ڸ� �Է��ϼ���.");
			theForm.upd_d_dt.focus();
			return;
		}
		theForm.target="_blank";
		theForm.action="car_dc_list.jsp";
		theForm.submit();	
	}


	function Search(){
		var fm = document.form1;
		var fm2 = document.SearchCarNmForm;
		fm2.car_comp_id.value 	= fm.car_comp_id.value;
		fm2.code.value 		= fm.code.value;
		fm2.car_u_seq.value 	= fm.view_dt.value;		
		fm2.view_dt.value 	= fm.view_dt.value;
		fm2.target="i_in";
		
		fm2.submit();
	}

	function CheckField(){
		var theForm = document.form1;
		if(theForm.car_comp_id.value==""){
			alert("�ڵ���ȸ�縦 �����Ͻʽÿ�.");
			theForm.car_comp_id.focus();
			return false;
		}
		if(theForm.code.value==""){
			alert("������ �����Ͻʽÿ�.");
			theForm.code.focus();
			return false;
		}
		if(theForm.view_dt.value==""){
			alert("�������ڸ� �����Ͻʽÿ�.");
			theForm.view_dt.focus();
			return false;
		}		
		if(theForm.car_d.value==""){
			alert("������ �Է��Ͻʽÿ�.");
			theForm.car_d.focus();
			return false;
		}
		if(theForm.car_d_p.value==""){
			alert("�ݾ��� �Է��Ͻʽÿ�.");
			theForm.car_d_p.focus();
			return false;
		}
		if(theForm.car_d_dt.value==""){
			alert("�������ڸ� �Է��Ͻʽÿ�.");
			theForm.car_c_dt.focus();
			return false;
		}				
		return true;
	}
	
	//���÷��� Ÿ��
	function cng_input() {
		var fm = document.form1;
		if(fm.ls_yn.checked == true){
			tr_ls1.style.display = "";
			tr_ls2.style.display = "";
		}else{
			tr_ls1.style.display = "none";
			tr_ls2.style.display = "none";
		}
	}	
	
	//������DC ����/��� ��
	function CarDcMonView(){
		var theForm = document.form1;		
		theForm.target="_blank";
		theForm.action="car_dc_mon_list.jsp";
		theForm.submit();	
	}	
			
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:init()">


<form action="./car_dc_null_ui.jsp" name="form1" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width="700">
    <tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>������DC����</span></span>
                &nbsp;&nbsp;&nbsp;<a href="javascript:CarDcMonView()" onMouseOver="window.status=''; return true" title='������DC ����/��� ��'>.</a>
            </td>
            <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td colspan="2" align="right" class=title>�ڵ���ȸ��</td>
                    <td width="80%">&nbsp; 
                      <select name="car_comp_id" onChange="javascript:GetCarCode()">
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%=cc_bean.getCode()%>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" align="right" class=title>����</td>
                    <td>&nbsp; 
                      <select name="code" onChange="javascript:GetViewDt()">
                        <!--onChange="javascript:GetViewDt()"-->
                        <option value="">��ü</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" align="right" class=title>��������(����)</td>
                    <td>&nbsp; 
                      <select name="view_dt" onChange="javascript:Search()">
                        <!--onChange="javascript:GetCarId()"-->
                        <option value="">��ü</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" align="right" class=title>D/C����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_d" value="" size="70" class=text>
                    </td>
                </tr>				
                <tr> 
                    <td colspan="2" align="right" class=title>D/C��</td>
                    <td>&nbsp;
                      <select name="car_d_per_b">
                        <option value="1">D/C�ݾ� �ݿ��� ������</option>
                        <option value="2">D/C�ݾ� �ݿ��� ������</option>                        
                      </select>
                      <input type="text" name="car_d_per" value="" size="4" class=num>
                      %
		      <input type="hidden" name="car_d_seq" value="">					  
		    </td>
                </tr>     	
                <tr> 
                    <td colspan="2" align="right" class=title>D/C�ݾ�</td>
                    <td>&nbsp; 
                      <input type="text" name="car_d_p" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
					  ��
                    </td>
                </tr>     	
                <tr> 
                    <td colspan="2" align="right" class=title>��������</td>
                    <td>&nbsp; 
                      <input type="text" name="car_d_dt" size="12" value="" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>						
                <tr> 
                    <td colspan="2" align="right" class=title>�Ϸ�����</td>
                    <td>&nbsp; 
                      <input type="text" name="car_d_dt2" size="12" value="" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>						
                <tr> 
                    <td colspan="2" align="right" class=title>���뱸��</td>
                    <td>&nbsp;<input type="checkbox" name="ls_yn" value="Y" onClick="javascript:cng_input()">
                    ��Ʈ,���� ���� ����</td>
                </tr>						
                <tr id=tr_ls1 style='display:none'> 
                    <td width="10%" rowspan="2" align="right" class=title>����D/C</td>
                    <td align="right" width="10%" class=title>D/C��</td>
                    <td>&nbsp;
                      <select name="car_d_per_b2">
                        <option value="1">D/C�ݾ� �ݿ��� ������</option>
                        <option value="2">D/C�ݾ� �ݿ��� ������</option>                        
                      </select>
                      <input type="text" name="car_d_per2" value="" size="4" class=num>
                      %					  
		        </td>
                </tr>     	
                <tr id=tr_ls2 style='display:none'> 
                    <td align="right" class=title>D/C�ݾ�</td>
                    <td>&nbsp; 
                      <input type="text" name="car_d_p2" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
					  ��
                    </td>
                </tr>  
                <tr>
                	<td colspan="2" align="right" class=title>Ȩ������ ����<br/>������ ����</td>
                	<td>&nbsp;<input type="checkbox" name="hp_flag" value="N" id="hp_flag">
                		<label for="hp_flag">Ȩ������ �ǽð� ������ ������</label>
                	</td>
                </tr>
                <tr>
                	<td colspan="2" align="right" class=title>������ ������D/C<br/>��Ÿ �߰� ����</td>
                	<td align="center" style="white-space: pre-wrap; word-wrap: break-word;">
                		<textarea name="esti_d_etc" id="esti_d_etc" cols="85" class="text" rows="2" placeholder="(������ ��Ÿ���� �������� ������D/C �߰� ���� �κ��Դϴ�)" maxlength="200" style="white-space: pre-wrap !important; word-wrap: break-word !important;"></textarea>
                	</td>
                </tr>
                <tr>
                	<td colspan="2" align="right" class=title>���</td>
                	<td align="center" style="white-space: pre-wrap; word-wrap: break-word;">
                		<textarea rows="6" cols="85" name="car_d_etc" id="car_d_etc" placeholder="(2000�� ����)" maxlength="2000" style="white-space: pre-wrap !important; word-wrap: break-word !important;"></textarea>
                		<pre id="asd"></pre>
                	</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"> 
                      <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:CarNmReg()" onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
                      <%}%>
                      <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:CarNmUp()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
                      <%}%>
                      <%if(auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:CarNmDel()" onMouseOver="window.status=''; return true"><img src=../images/center/button_delete.gif border=0 align=absmiddle></a>
                      <%}%>
                      <a href="javascript:self.close();window.close();" onMouseOver="window.status=''; return true"><img src=../images/center/button_close.gif border=0 align=absmiddle></a> 
      </td>
    </tr>

    <tr>
	<td>			
            <table border="0" cellspacing="0" cellpadding="0" width=700>
                <tr>
		  <td class='line'>						 		              
                      <table border="0" cellspacing="1" cellpadding="0" width=680>
                        <tr> 
                          <td width="7%" rowspan="2" class=title>����</td>
                          <td width="29%" rowspan="2" class=title>D/C����</td>						  
                          <td colspan="2" class=title>����/��Ʈ</td>
                          <td colspan="3" class=title>����</td>
                          <td width="13%" class=title>��������</td>
                          <td width="5%" class=title rowspan="2">HP</td>
                        </tr>
                        <tr>
                          <td width="7%" class=title>D/C��</td>
                          <td width="15%" class=title>D/C�ݾ�</td>
                          <td width="4%" class=title>����</td>						  						  
                          <td width="7%" class=title>D/C��</td>
                          <td width="15%" class=title>D/C�ݾ�</td>
                          <td width="13%" class=title>�Ϸ�����</td>
                        </tr>
                      </table>
		  </td>
		  <td width="20">&nbsp;</td>		  
                </tr>
            </table>
	</td>
    </tr>	
    <tr>
	<td><iframe src="./car_dc_i_in.jsp?auth_rw=<%=auth_rw%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>" name="i_in" width="700" height="320" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr> 
    <tr>
	<td>* �������� : <input type="text" name="upd_d_dt" size="12" value="" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
	      | �Ϸ����� : <input type="text" name="upd_d_dt2" size="12" value="" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
		<a href="javascript:CarDcUpg()" onMouseOver="window.status=''; return true" title='������DC �ϰ� ���׷��̵�'>[������DC �ϰ� ���׷��̵�]</a>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:CarDcUpgSee()" onMouseOver="window.status=''; return true" title='�������� �������� ������DC �ϰ� ���׷��̵� ����Ʈ Ȯ��'><img src=../images/center/button_see.gif border=0 align=absmiddle></a>
	</td>
    </tr>     
</table>
<input type="hidden" name="cmd" value="">
<input type="hidden" name="car_u_seq" value="">
<input type="hidden" name="upgrade_dt" value="">
<input type="hidden" name="upgrade_seq" value="">
</form>
<form action="./car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">    
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">
  <input type="hidden" name="from_page" value="/acar/car_mst/car_mst_sh.jsp">
</form>
<form action="./car_dc_i_in.jsp" name="SearchCarNmForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
<input type="hidden" name="code" value="<%=code%>">
<input type="hidden" name="car_id" value="<%=car_id%>">
<input type="hidden" name="car_u_seq" value="<%=car_u_seq%>">
<input type="hidden" name="view_dt" value="<%=view_dt%>">
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</body>
</html>