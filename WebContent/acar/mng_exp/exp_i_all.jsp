<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
  CommonDataBase c_db = CommonDataBase.getInstance();

  //�����������
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;
%>  
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table_t.css'>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1;
		if(!isDate(fm.exp_est_dt.value) || fm.exp_est_dt.value == ''){	alert('���⿹������ Ȯ���Ͻʽÿ�');	fm.exp_est_dt.focus(); return;	}	
		if(fm.car_no[0].value == ''){	alert('������ȣ�� �Է��Ͻʽÿ�');	fm.car_no[0].focus();  return;	}		
		if(fm.exp_st.options[fm.exp_st.selectedIndex].value == '3'){
			if(fm.exp_start_dt.value == '' || fm.exp_end_dt.value == '')
													{	alert('�����Ⱓ�� �Է��Ͻʽÿ�');	return;	}
		}		
		
		if(confirm('����Ͻðڽ��ϱ�?'))
		{
			fm.target='i_no';
//			fm.target='REG_EXP_ALL';
			fm.action='exp_i_all_a.jsp';						
			fm.submit();			
		}
	}
	
	function search_client()
	{
		window.open("/acar/mng_exp/car_s.jsp", "EXP_CAR", "left=100, top=100, width=520, height=450");
	}
	
	function set_car_id(idx, car_no)
	{
		var fm = document.form1;
		if(fm.exp_est_dt.value == ''){ alert("���⿹������ �Է��Ͻʽÿ�."); fm.exp_est_dt.focus(); return;}
		if(fm.exp_st.value == ''){ alert("���ⱸ���� �����Ͻʽÿ�."); fm.exp_st.focus(); return;}
		if(car_no != ''){
			fm.h_idx.value = idx;
			fm.h_car_no.value = car_no;
			fm.target='i_no';
			fm.action='exp_nodisplay.jsp';			
			fm.submit();
		}
	}
	
	//���÷��� Ÿ��
	function exp_display(){
		var fm = document.form1;
		if(fm.exp_st.options[fm.exp_st.selectedIndex].value == '3'){//�ڵ�����
			tr_dt.style.display	= '';
		}else{
			tr_dt.style.display	= 'none';
		}
	}
	
	//�����Ⱓ ����
	function set_exp_dt(){
		var fm = document.form1;
		var year = '<%=AddUtil.getDate(1)%>';
		var mon = <%=AddUtil.getDate(2)%>;		
		if(fm.dt_st.options[fm.dt_st.selectedIndex].value == '1'){//�ݱⳳ
			if(mon <=  6){
				fm.exp_start_dt.value 	= year+'-01-01';
				fm.exp_end_dt.value 	= year+'-06-30';
			}else{
				fm.exp_start_dt.value 	= year+'-07-01';
				fm.exp_end_dt.value 	= year+'-12-31';			
			}
		}else if(fm.dt_st.options[fm.dt_st.selectedIndex].value == '2'){//����
			fm.exp_start_dt.value 	= year+'-01-01';
			fm.exp_end_dt.value 	= year+'-12-31';			
		}else{
			fm.exp_start_dt.value 	= '';
			fm.exp_end_dt.value 	= '';
		}	
	}	
	
//-->
</script>
</head>
<body>

<form action='/acar/mng_exp/exp_i_all_a.jsp' name='form1' method='post'>
<input type='hidden' name='h_idx' value=''>
<input type='hidden' name='h_car_no' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�繫ȸ�� > ���������� > ��Ÿ��ϰ��ú�� > <span class=style1><span class=style5>������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td align='right'><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a></td>
	</tr>  
	<tr> 
        <td class=line2></td>
    </tr>  
    <tr>
        <td class='line'>            
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td width=18% class='title'>���ⱸ��</td>
                    <td width=32%> &nbsp; <select name='exp_st' onChange='javascript:exp_display()'>
                        <option value=''>����</option>
                        <option value='1'>�˻��</option>
                        <option value='2'>ȯ�氳���δ��</option>
                        <option value='3' selected>�ڵ�����</option>
                      </select> </td>
                    <td width=18% class='title'>���⿹����</td>
                    <td width=32%>&nbsp; <input type='text' name='exp_est_dt' value='' class='text' size='12' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                </tr>
                <tr id=tr_dt style="display:''"> 
					<td class='title'>�������� </td>
                    <td colspan=''> &nbsp; <select name='car_ext'>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        <%}%>
                      </select></td>
                    <td class='title'>�����Ⱓ</td>
                    <td colspan=""> &nbsp; <select name='dt_st' onChange='javascript:set_exp_dt()'>
                        <option value=''>����</option>
                        <option value='1'>�ݱⳳ</option>
                        <option value='2'>����</option>
                        <option value='3'>���ó�</option>
                      </select> <input type='text' name='exp_start_dt' class='text' size='12' maxlength='12' onBlur='javascript:this.value = ChangeDate(this.value);'>
                      ~ 
                      <input type='text' name='exp_end_dt' class='text' size='12' maxlength='12' onBlur='javascript:this.value = ChangeDate(this.value);'> 
                      &nbsp; </td>
                </tr>
                <%for(int i=0;i<10;i++){%>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp; <input type='text' name='car_no' class='text' size='15' onBlur='javascript:set_car_id(<%=i%>, this.value);' style='IME-MODE: active'> 
                      <input type='hidden' name='car_mng_id' value=''> </td>
                    <td class='title' width="100">�ݾ�</td>
                    <td>&nbsp; <input type='text' name='exp_amt' class='num' size='12' maxlength='12' onBlur='javascript:this.value = parseDecimal(this.value);'>
                      ��</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
<script language="JavaScript">
<!--
	var fm = document.form1;
	var year = '<%=AddUtil.getDate(1)%>';
	var mon = <%=AddUtil.getDate(2)%>;		
	if(mon <=  6){
		fm.exp_est_dt.value 	= year+'-06-30';
	}else{
		fm.exp_est_dt.value 	= year+'-12-31';			
	}	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>