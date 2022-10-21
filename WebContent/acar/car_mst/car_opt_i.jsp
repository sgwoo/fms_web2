<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_comp_id = request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_u_seq = request.getParameter("car_u_seq")==null?"":request.getParameter("car_u_seq");	
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	
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

	//�����ڵ� ���ý� ���� ����ϱ�
	function GetCarId(){
		var fm = document.form1;
		var fm2 = document.form2;
		fm.car_s_dt.value = ChangeDate3(fm.view_dt.value);
		te = fm.car_id;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';		
		fm2.sel.value = "form1.car_id";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.code.value = fm.code.value;		
		fm2.view_dt.value = fm.view_dt.value;				
		fm2.mode.value = '10';//������+����+���ؿ�
//		fm2.mode.value = '2';//������+����=>�ֱٰ�
//		fm2.target="d_content";
		fm2.target="i_no";
		fm2.submit();
	}

	//���� ���ý� ���ؿ� ����ϱ�
	function GetViewDt(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.view_dt;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.view_dt";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.code.value = fm.code.value;		
		fm2.car_id.value = fm.car_id.value;
		fm2.mode.value = '3';
		fm2.target="i_no";
		fm2.submit();
		if(fm.view_dt.value != ''){
			GetCarId();
		}
	}

	//�����ڵ� ���ý� ���� ����ϱ�
	function GetJgOptSt(){
		var fm = document.form1;
		var fm2 = document.form2;
		fm.car_s_dt.value = ChangeDate3(fm.view_dt.value);
		te = fm.jg_opt_st;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';		
		fm2.sel.value = "form1.jg_opt_st";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.code.value = fm.code.value;		
		fm2.view_dt.value = fm.view_dt.value;	
		fm2.car_id.value = fm.car_id.value.substring(2);			
		fm2.mode.value = '15';
		fm2.target="i_no";
		fm2.submit();
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
	
	function CarNmReg(){
		var theForm = document.form1;
		if(!CheckField()){	return;	}
//		if(theForm.car_s_seq.value != ''){ alert('�̹� ��ϵ� ǰ���Դϴ�.')}		
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "i";
		theForm.target="i_no";
		theForm.submit();
	}

	function CarNmUp(){
		var theForm = document.form1;
		if(!CheckField()){	return;	}
		if(theForm.car_s_seq.value == ''){ alert('���� ��ϵ��� ���� ǰ���Դϴ�.')}
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "u";
		theForm.target="i_no";
		theForm.submit();
	}

	function CarNmDel(){
		var theForm = document.form1;
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		theForm.cmd.value = "d";
		theForm.target="i_no";
		theForm.submit();
	}

/*	function GetCarKind(){
		var theForm1 = document.CarNmForm;
		var theForm2 = document.CarKindSearchForm;
		te = theForm1.code;
		theForm2.sel.value = "CarNmForm.code";
		theForm2.car_comp_id.value = theForm1.car_comp_id.value;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		theForm2.target="i_no";
		theForm2.submit();
	}
*/		
	function Search(){
		var fm = document.form1;
		var fm2 = document.SearchCarNmForm;
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.code.value = fm.code.value;
		fm2.car_id.value = fm.car_id.value.substring(2);
		fm2.car_u_seq.value = fm.car_id.value.substring(0,2);		
		fm2.view_dt.value = fm.view_dt.value;		
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
		if(theForm.car_id.value==""){
			alert("������ �����Ͻʽÿ�.");
			theForm.car_id.focus();
			return false;
		}		
		if(theForm.car_s.value==""){
			alert("���û��ǰ���� �Է��Ͻʽÿ�.");
			theForm.car_d.focus();
			return false;
		}
		if(theForm.car_s_p.value==""){
			alert("�ݾ��� �Է��Ͻʽÿ�.");
			theForm.car_d_p.focus();
			return false;
		}
		if(theForm.car_s_dt.value==""){
			alert("�������ڸ� �Է��Ͻʽÿ�.");
			theForm.car_s_dt.focus();
			return false;
		}				
		return true;
	}
//-->
</script>
</head>
<body leftmargin="15"  onLoad="javascript:init()">

<form action="./car_opt_null_ui.jsp" name="form1" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width="1200">
    <tr>
		<td>
	        <table border="0" cellspacing="0" cellpadding="0" width=1180>
	        	<tr>
					<td>						 		              
						<table border="0" cellspacing="0" cellpadding="0" width=100%>
							<tr>
					            <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
					            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>�ɼǰ���</span></span></td>
					            <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
				          	</tr>
						</table>
					</td>
				</tr>
	        </table>
      	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	  	<td>			
			<table border="0" cellspacing="0" cellpadding="0" width=1180>
				<tr>
					<td class='line'>						 		              
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
						  	<tr> 
			                    <td width="20%" align="right" class=title>�ڵ���ȸ��</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="car_comp_id" onChange="javascript:GetCarCode()">
			                        <%for(int i=0; i<cc_r.length; i++){
			        						        cc_bean = cc_r[i];%>
			                        	<option value="<%=cc_bean.getCode()%>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
			                        <%	}	%>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>����</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="code" onChange="javascript:GetViewDt()">
				                        <!--onChange="javascript:GetViewDt()"-->
				                        <option value="">��ü</option>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>��������</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="view_dt" onChange="javascript:GetCarId()">
			                        	<!--onChange="javascript:GetCarId()"-->
			                        	<option value="">��ü</option>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>����</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="car_id" onChange="javascript:Search(); GetJgOptSt();">
			                        	<!-- onChange="javascript:Search()"-->
			                        	<option value="">��ü</option>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right"  class=title>���û��ǰ��</td>
			                    <td colspan="5">
			                      	&nbsp;<input type="hidden" name="car_s_seq" value="" >
			                      	<textarea cols="100" rows="3" name="car_s" id="car_s" placeholder="&#39; &#34; &#60; &#62; ���� Ư�����ڴ� �Է��� �Ұ��� �մϴ�."></textarea>                      
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right"  class=title>���γ���</td>
			                    <td colspan="5">
			                      	&nbsp;
			                      	<textarea cols="100" rows="3" name="opt_b"></textarea>                      
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>�����ܰ�</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="jg_opt_st">                        
			                        	<option value="">����</option>
			                      	</select>
			                    </td>
			                </tr>    
			                <tr> 
			                    <td align="right" class=title>TUIX/TUON �ɼǿ���</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="jg_tuix_st">                        
				                        <option value="">����</option>
				                        <option value="N">���ش�</option>
				                        <option value="Y">�ش�</option>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>������Ż ������</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="lkas_yn">                        
				                        <option value="">����</option>
				                        <option value="N">���ش�</option>
				                        <option value="Y">�ش�</option>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>������Ż �����</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="ldws_yn">                        
				                        <option value="">����</option>
				                        <option value="N">���ش�</option>
				                        <option value="Y">�ش�</option>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>������� ������</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="aeb_yn">                        
				                        <option value="">����</option>
				                        <option value="N">���ش�</option>
				                        <option value="Y">�ش�</option>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>������� �����</td>
			                    <td colspan="5">&nbsp; 
			                      	<select name="fcw_yn">                        
				                        <option value="">����</option>
				                        <option value="N">���ش�</option>
				                        <option value="Y">�ش�</option>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>���Ͻ� �ɼǿ���</td>
			                    <td colspan="5">&nbsp;
			                      	<select name="garnish_yn">
				                        <option value="">����</option>
				                        <option value="N">���ش�</option>
				                        <option value="Y">�ش�</option>
			                      	</select>
			                    </td>
			                </tr>
							<tr> 
			                    <td align="right" class=title>���ΰ�(Ʈ���Ϸ���)</td>
			                    <td colspan="5">&nbsp;
			                      	<select name="hook_yn">
				                        <option value="">����</option>
				                        <option value="N">���ش�</option>
				                        <option value="Y">�ش�</option>
			                      	</select>
			                    </td>
			                </tr>
			                <tr> 
			                    <td align="right" class=title>�ݾ�</td>
			                    <td width="20%">&nbsp;
			                      	<input type="text" name="car_s_p" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'> ��
			                    </td>
			                    <td width="15%" align="right" class=title>��������</td>
			                    <td width="20%">&nbsp; 
			                      	<input type="text" name="car_s_dt" size="12" value="" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
			                    </td>
			                    <td width="15%" align="right" class=title>��뿩��</td>
			                    <td width="15%">&nbsp; 
			                      	<select name="use_yn">
			                        	<option value="">����</option>
			        					<option value="Y">Y</option>
			        					<option value="N">N</option>
					      			</select>  
			                    </td>
			                </tr>
						</table>
					</td>
					<!-- <td width="20">&nbsp;</td> -->
				</tr>
			</table>
	  	</td>	  
	</tr>
    <tr>
        <td class=h style="height: 20px;"></td>
    </tr>
    <tr>
		<td>
	        <table border="0" cellspacing="0" cellpadding="0" width=1180>
	        	<tr>
					<td>						 		              
						<table border="0" cellspacing="0" cellpadding="0" width=100%>
							<tr>
					            <td align="right"> <!-- ó�� -->
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
						</table>
					</td>
				</tr>
	        </table>
      	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	  	<td>			
			<table border="0" cellspacing="0" cellpadding="0" width=1180>
				<tr>
					<td class='line'>						 		              
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
						  	<tr> 
							    <td class=title width="3%">����</td>
							    <td class=title width="20%">���û��ǰ��</td>
							    <td class=title width="*">���γ���</td>
							    <td class=title width="5%">�����ܰ�</td>
							    <td class=title width="6%">TUIX/TUON<br>�ɼǿ���</td>
							    <td class=title width="5%">������Ż<br>������</td>
							    <td class=title width="5%">������Ż<br>�����</td>
							    <td class=title width="5%">�������<br>������</td>
							    <td class=title width="5%">�������<br>�����</td>
							    <td class=title width="5%">���Ͻ�<br>�ɼǿ���</td>
							    <td class=title width="7%">���ΰ�<br>(Ʈ���Ϸ���)</td>
							    <td class=title width="7%">�ݾ�</td>
							    <td class=title width="7%">��������</td>
							    <td class=title width="5%">��뿩��</td>
						  	</tr>
						</table>
					</td>
					<!-- <td width="20">&nbsp;</td> -->
				</tr>
			</table>
	  	</td>	  
	</tr>
    <tr>
		<td><iframe src="./car_opt_i_in.jsp?auth_rw=<%=auth_rw%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&car_id=<%=car_id%>&car_u_seq=<%=car_u_seq%>&view_dt=<%=view_dt%>" name="i_in" width="1200" height="300" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
	</tr> 
</table>
<input type="hidden" name="cmd" value="">
<input type="hidden" name="car_u_seq" value="">
</form>
<form action="./car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">    
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">
</form>
<form action="./car_opt_i_in.jsp" name="SearchCarNmForm" method="post">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
	<input type="hidden" name="code" value="<%=code%>">
	<input type="hidden" name="car_id" value="<%=car_id%>">
	<input type="hidden" name="car_u_seq" value="<%=car_u_seq%>">
	<input type="hidden" name="view_dt" value="<%=view_dt%>">
</form>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script>
	//���û��ǰ�� Ư������ �Է� ����
	var regex = /[\'\"<>]/gi;
	var car_s;
	
	// ���û��ǰ�� ' " < > ����
	$("#car_s").bind("keyup",function(){
		car_s = $("#car_s").val();
		if(regex.test(car_s)){
			$("#car_s").val(car_s.replace(regex,""));
		}
	});
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</body>
</html>
