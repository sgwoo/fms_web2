<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//���
	function naviReg(){
		var fm = document.form1;
	
		fm.cmd.value = "i";		
	//	if(fm.serial_no.value!=""){	alert("�������� �����մϴ�.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('����Ͻðڽ��ϱ�?')){
			return;
		}
		fm.target = "i_no"
		fm.submit();
	}

	//����
	function naviUp(){
		var fm = document.form1;
		
		fm.cmd.value = "u";		
	
		if(fm.serial_no.value==""){	alert("��ϸ��� �����մϴ�.");	return;	}
		if(!CheckField()){	return;	}
				
		if(!confirm('�����Ͻðڽ��ϱ�?')){
			return;
		}
		
		setSerial_no()
		
		fm.target = "i_no";
		fm.submit();
	}

	function ClearM(){
		var fm = document.form1;
	
		fm.serial_no.value = '';
		fm.model.value = '';
		fm.gubun.value = '';
		fm. remark.value = '';
	
	}
	
	//�Է°� null üũ
	function CheckField(){
		var fm = document.form1;
		if(fm.serial_no.value=="" && fm.cmd.value=="u"){	alert(" �׺���̼� S/N�� �Է��Ͻʽÿ�");	fm.serial_no.focus();	return false;	}
		if(fm.model.value==""){	alert("�𵨸��� �Է��Ͻʽÿ�");	fm.model.focus();	return false;	}
		return true;
	}
	
	function setSerial_no(){
		var fm = document.form1;
		fm.serial_no.readOnly = false;
	}
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");

%>
<form action="lc_navi_stat_sc_a.jsp" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>		
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td class=line2></td>
                </tr>
				<tr>					
                    <td class='line'> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td class=title>S / N</td>
                            
                                <td><input type="text" name="serial_no" size="30" class="text"   ></td>
                                <td class=title> �𵨸�</td>
                                <td colspan="3"><input type="text" name="model" size="80" style='IME-MODE: active' class=text   ></td>
                            </tr>
                     
                            <tr> 
                                <td class=title>����</td>
                                <td ><select name="gubun">
                                      <option value=""></option>
                                        <option value="N">�뿩��</option>      
                                        <option value="R">������</option>              
                                       <option value="M">������</option>                                
                                    </select></td>                              
                                <td class=title >Ư�̻���</td>
                                 <td colspan="3"><input type="text" name="remark" size="80" class=text></td>
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
        <td align="right">
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>       
        <a href="javascript:naviReg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
        <a href="javascript:naviUp()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
        <a href="javascript:ClearM()"><img src=/acar/images/center/button_init.gif border=0 align=absmiddle></a> 
        <%}%>
	    </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>