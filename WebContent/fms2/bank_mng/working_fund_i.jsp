<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.bill_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "15");	
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	//�ڵ屸��:��1������
	CodeBean[] banks = c_db.getBankList("1"); 
	int bank_size = banks.length;
	
	//�ڵ屸��:��2������
	CodeBean[] banks2 = c_db.getBankList("2"); 
	int bank_size2 = banks2.length;
	
	//�ڵ屸�� : ���رݸ�
	CodeBean[] code23 = c_db.getCodeAll("0023"); 
	int cd23_size = code23.length;

	//�׿��� ���ฮ��Ʈ
	CodeBean[] a_banks = neoe_db.getCodeAll();
	int a_bank_size = a_banks.length;
	

	
	//�α��� ���������
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//���
	function save()
	{
		var fm = document.form1;		
		
		if(fm.deposit_no_d.value != ''){
			var deposit_no = fm.deposit_no_d.options[fm.deposit_no_d.selectedIndex].value;		
			if(deposit_no.indexOf(":") == -1){
				fm.deposit_no_d.value = deposit_no;
			}else{
				var deposit_split = deposit_no.split(":");
				fm.deposit_no_d.value = deposit_split[0];	
			}
		}
		
		if(fm.user_id.value != '000029'){
			if(fm.cont_bn.value 	== '')					{ 	alert('������� ������� �Է��Ͻʽÿ�.'); 		fm.cont_bn.focus(); 		return; }
			if(fm.bn_br.value 	== '')					{ 	alert('������� �ŷ������� �Է��Ͻʽÿ�.'); 		fm.bn_br.focus(); 		return; }
			if(fm.ba_title.value 	== '')					{	alert('����� ��å�� �Է��Ͻʽÿ�');			fm.ba_title.focus(); 		return;	}
			if(fm.ba_agnt.value 	== '')					{	alert('����� ������ �Է��Ͻʽÿ�');			fm.ba_agnt.focus(); 		return;	}
			if(toInt(parseDigit(fm.cont_amt.value)) == 0)			{	alert('�����ѵ��ݾ��� �Է��Ͻʽÿ�');			fm.cont_amt.focus(); 		return;	}
			if(fm.cont_dt.value 	== '')					{	alert('�������ڸ� �Է��Ͻʽÿ�');			fm.cont_dt.focus(); 		return;	}
//			if(fm.cls_est_dt.value 	== '')					{	alert('���⿹�����ڸ� �Է��Ͻʽÿ�');			fm.cls_est_dt.focus(); 		return;	}
//			if(fm.bank_code.value 	== '')					{	alert('������� ������� �Է��Ͻʽÿ�');		fm.bank_code.focus(); 		return;	}
//			if(fm.deposit_no_d.value== '')					{	alert('������� ���¹�ȣ�� �Է��Ͻʽÿ�');		fm.deposit_no_d.focus(); 		return;	}
			if(fm.pay_st.value 	== '')					{	alert('�ڱ��������� �Է��Ͻʽÿ�');			fm.pay_st.focus(); 		return;	}
			if(fm.security_st1.checked==false && fm.security_st2.checked==false && fm.security_st3.checked==false){
											alert('�㺸������ �����Ͻʽÿ�.');			fm.security_st1.focus(); 	return;
			}
			if(toInt(fm.fund_int.value) == 0)				{	alert('����ݸ��� �Է��Ͻʽÿ�');			fm.fund_int.focus(); 		return;	}
//			if(fm.validity_s_dt.value 	== '')				{	alert('�ݸ� ��ȿ�Ⱓ�� �Է��Ͻʽÿ�');			fm.validity_s_dt.focus(); 	return;	}
//			if(fm.validity_e_dt.value 	== '')				{	alert('�ݸ� ��ȿ�Ⱓ�� �Է��Ͻʽÿ�');			fm.validity_e_dt.focus(); 	return;	}			
			if(fm.int_st.value 		== '')				{	alert('�ݸ� ���뱸���� �Է��Ͻʽÿ�');			fm.int_st.focus(); 		return;	}
			if(fm.int_st.value		== '2'){//�����ݸ���
				if(fm.spread[0].checked == false && fm.spread[1].checked == false){
												alert('SPREAD ��/���� �����Ͻʽÿ�.');			fm.spread[0].focus(); 		return;
				}
				if(fm.spread[0].checked == true && toInt(fm.spread_int.value) == 0){
												alert('SPREAD �ݸ��� �Է��Ͻʽÿ�.');			fm.spread_int.focus(); 		return;
				}
				if(fm.app_b_st.value 	== '')					{	alert('���رݸ��� �����Ͻʽÿ�');			fm.app_b_st.focus(); 		return;	}
				if(fm.app_b_dt.value 	== '')					{	alert('����������ڸ� �Է��Ͻʽÿ�');			fm.app_b_dt.focus(); 		return;	}
			}
		
			if(fm.security_st2.checked == true){
				if(fm.gua_org.value 	== '')				{ 	alert('���������������� �Է��Ͻʽÿ�.'); 		fm.gua_org.focus(); 		return; }
				if(fm.gua_s_dt.value 	== '')				{	alert('������ ��ȿ�Ⱓ�� �Է��Ͻʽÿ�');		fm.gua_s_dt.focus(); 		return;	}
				if(fm.gua_e_dt.value 	== '')				{	alert('������ ��ȿ�Ⱓ�� �Է��Ͻʽÿ�');		fm.gua_s_dt.focus(); 		return;	}
				if(toInt(fm.gua_int.value) == 0)			{	alert('�������� �Է��Ͻʽÿ�');				fm.gua_int.focus(); 		return;	}
				if(toInt(parseDigit(fm.gua_amt.value)) == 0)		{	alert('�����ݾ��� �Է��Ͻʽÿ�');			fm.gua_amt.focus(); 		return;	}
				if(toInt(parseDigit(fm.gua_fee.value)) == 0)		{	alert('��������Ḧ �Է��Ͻʽÿ�');			fm.gua_fee.focus(); 		return;	}
			}
		
			if(fm.security_st3.checked == true){
				if(fm.realty_nm.value 	== '')				{ 	alert('�㺸���ε������ �Է��Ͻʽÿ�.'); 		fm.realty_nm.focus(); 		return; }
				if(fm.t_addr.value 	== '')				{	alert('�㺸�� �ּҸ� �Է��Ͻʽÿ�');			fm.t_addr.focus(); 		return;	}
			}		
		
			//����
			if(fm.bank_code.value != ''){
				var bank_code 		= fm.bank_code.options[fm.bank_code.selectedIndex].value;
				fm.bank_code2.value 	= bank_code.substring(0,3);
				fm.bank_name.value 	= bank_code.substring(3);				
			}
		}
			
		if(confirm('����Ͻðڽ��ϱ�?'))
		{
			fm.action = 'working_fund_i_a.jsp';
			fm.target = 'i_no';
			//fm.target = '_blank';
			fm.submit();
		}
	}
	
	//����Ʈ
	function go_to_list()
	{
		var fm = document.form1;	
		fm.action = 'working_fund_frame.jsp';
		fm.target = 'd_content';		
		fm.submit();
	}


	//���÷��� Ÿ��
	function cng_input(){
		var fm = document.form1;
		
		if(fm.security_st2.checked == true){
			tr_gua_1.style.display = "";
			tr_gua_2.style.display = "";
			tr_gua_3.style.display = "";
		}else{
			tr_gua_1.style.display = "none";
			tr_gua_2.style.display = "none";
			tr_gua_3.style.display = "none";
		}
		
		if(fm.security_st3.checked == true){
			tr_realty_1.style.display = "";
			tr_realty_2.style.display = "";
			tr_realty_3.style.display = "";
		}else{
			tr_realty_1.style.display = "none";
			tr_realty_2.style.display = "none";
			tr_realty_3.style.display = "none";
		}

	}
	
	//�ü��ڱ� ��ȸ
	function search_lend_bank(){
		var fm = document.form1;
		if(fm.fund_type[1].checked == true){
			window.open("s_lend_bank.jsp?from_page=/fms2/bank_mng/working_fund_i.jsp", "SEARCH_LEND_BANK", "left=50, top=50, width=750, height=600, resizable=yes, scrollbars=yes, status=yes");		
		}else{
			alert("����ڱ��� ������������ �������� �ʽ��ϴ�.");
		}
	}		
	
	//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		//����
		var bank_code 		= fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value 	= bank_code.substring(0,3);
		fm.bank_name.value 	= bank_code.substring(3);
				
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/acar/bank_mng/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no_d.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no_d.options[deposit_len-(i+1)] = null;
		}
	}		
	function add_deposit(idx, val, str){
		document.form1.deposit_no_d[idx] = new Option(str, val);		
	}
	
	//�ڵ����
	function reg_app_b_st(){
		window.open("/acar/common/code_frame_s.jsp?auth_rw=<%=auth_rw%>&c_st=0023&from_page=/fms2/bank_mng/working_fund_frame.jsp", "CODE", "left=100, top=100, height=400, width=450, resizable=yes, scrollbars=yes, status=yes");
	}		
//-->
</script>
</head>
<body leftmargin="15">
<form action="working_fund_i_a.jsp" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='bank_id' value='<%=bank_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='/fms2/bank_mng/working_fund_frame.jsp'>  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>�繫ȸ�� > �����ڱݰ��� ><span class=style5>�ڱݰ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:go_to_list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
	<tr> 
    <tr>
        <td class=h></td>
    </tR>
    <!--
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>���ⱸ��</td>
                <td>&nbsp;
                  <input name="fund_type" type="radio" value="1" checked>
                  ����ڱ�
                  <input type="radio" name="fund_type" value="2">�ü��ڱ�
                  <a href="javascript:search_lend_bank()"><span title="������������ �����մϴ�."><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></span></a>                  
                  <input type='hidden' name='lend_id' value=''>                      
		</td>
              </tr>	
            </table>
        </td>
    </tr>       
    <tr>
      <td class=h></td>
    </tr>	
    -->
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="6%" rowspan="2" class=title>�������</td>
                    <td width="7%" class=title>�����</td>
                    <td width="25%">&nbsp;
                      <select name='cont_bn_st'>
                        <option value="1" selected>��1������</option>
                        <option value="2">��2������</option>
                      </select>
                      &nbsp;
                      <select name="cont_bn" id="cont_bn">
                        <option value="" >����</option>
			<%	if(bank_size > 0){
        				for(int i = 0 ; i < bank_size ; i++){
        					CodeBean bank = banks[i];%>
                        <option value="<%= bank.getCode()%>"><%= bank.getNm()%></option>
                        <%		}
        			}%>
			<%	if(bank_size2 > 0){
        				for(int i = 0 ; i < bank_size2 ; i++){
        					CodeBean bank = banks2[i];%>
                        <option value="<%= bank.getCode()%>"><%= bank.getNm()%></option>
                        <%		}
        			}%>
                      </select>
		    </td>
                    <td width="6%" rowspan="2" class=title>�����</td>
                    <td width="8%" class=title>��å/����</td>
                    <td width="20%">&nbsp;
                      <input type="text" class="text" name="ba_title" value="" size="13" maxlength="20" style="IME-MODE: active">
                      /
                      <input type="text" class="text" name="ba_agnt" value="" size="12" maxlength="20" style="IME-MODE: active">
		    </td>
                    <td width="13%" class=title>������ȣ</td>
                    <td width="15%">&nbsp;<font color='#CCCCCC'>�ڵ����</font></td>
                </tr>
                <tr>
                  <td class=title>�ŷ�����</td>
                  <td>&nbsp;
                    <input type="text" class="text" name="bn_br" value="" size="28" maxlength="20" style="IME-MODE: active">
		  </td>
                  <td class=title>����ó</td>
                  <td>&nbsp;
                    <input type="text" class="text" name="bn_tel" value="" size="13" maxlength="15">
		  </td>
                  <td class=title>���ʵ������</td>
                  <td>&nbsp;<font color='#CCCCCC'>�ڵ����</font></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tR>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td colspan="2" class=title>���ⱸ��</td>
                <td>&nbsp;
                  <input name="fund_type" type="radio" value="1">
                  ����ڱ�
                  <input type="radio" name="fund_type" value="2">
                  �ü��ڱ�
		</td>    
                <td width="6%" rowspan="4" class=title>��������</td>
                <td width="8%" class=title>��������</td>
                <td width="10%">&nbsp;
                  <input type="text" class="text" name="cont_dt" id="cont_dt" size="11" maxlength="10" value="" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td width="6%" rowspan="2" class=title>�������</td>
                <td width="7%" class=title>�����</td>
                <td width="30%">&nbsp;
                  <select name='bank_code' onChange='javascript:change_bank()'>
                        <option value=''>����</option>
                        <%if(a_bank_size > 0){
        			for(int i = 0 ; i < a_bank_size ; i++){
        				CodeBean a_bank = a_banks[i];%>
                        <option value='<%= a_bank.getCode()%><%= a_bank.getNm()%>'><%= a_bank.getNm()%></option>
                        <%	}
        		  }%>
                  </select>
                  <input type='hidden' name='bank_code2' value=''>
		  <input type='hidden' name='deposit_no2' value=''>
		  <input type='hidden' name='bank_name' value=''>
		</td>
              </tr>
              <tr>
                <td colspan="2" class=title>�����ѵ�</td>
                <td>&nbsp;
                  <input type="text" class="num" name="cont_amt" id="cont_amt" size="15" maxlength="15" value="" onBlur="javascript:this.value=parseDecimal(this.value)">
                  ��				
                </td>              
                <td class=title>��������</td>
                <td>&nbsp;
                  <input type="text" class="whitetext" name="renew_dt" id="renew_dt" size="11" maxlength="10" value="" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td class=title>���¹�ȣ</td>
                <td>&nbsp;
                  <select name='deposit_no_d'>
                        <option value=''>���¸� �����ϼ���</option>
                  </select>                  
		</td>
              </tr>
              <tr>
                <td width="6%" rowspan="2" class=title>�����ܾ�</td>
                <td width="7%" class=title>�ݾ�</td>
                <td width="20%">&nbsp;
                  <input type="text" class="num" name="rest_amt" id="rest_amt" size="15" maxlength="15" value="" onBlur="javascript:this.value=parseDecimal(this.value)">��
		</td>
                <td class=title>���⿹������</td>
                <td>&nbsp;
                  <input type="text" class="text" name="cls_est_dt" id="cls_est_dt" size="11" maxlength="10" value="" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td colspan="2" class=title>�ڱ�������</td>
                <td>&nbsp;
                  <select name="pay_st" id="pay_st">
				    <option value="" >����</option>
				    <option value="1">�Ͻ����</option>
				    <option value="2">���������</option>
                  </select>
		</td>
              </tr>
              <tr>
                <td class=title>��������</td>
                <td>&nbsp;
                  <input type="text" class="text" name="rest_b_dt" id="rest_b_dt" size="11" maxlength="10" value="" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td class=title>��������</td>
                <td>&nbsp;
                  <input type="text" class="whitetext" name="cls_dt" id="cls_dt" size="11" maxlength="10" value="" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td colspan="2" class=title>�㺸����</td>
                <td>&nbsp;
                  <input type="checkbox" name="security_st1" id="security_st1" value="Y" onClick="javascript:cng_input();">
                  �ſ�
                  <input type="checkbox" name="security_st2" id="security_st2" value="Y" onClick="javascript:cng_input();">
                  ������
                  <input type="checkbox" name="security_st3" id="security_st3" value="Y" onClick="javascript:cng_input();">
                  �ε���
		</td>
              </tr>			
              <tr>
                <td colspan='2' class=title>ȸ��(������)����</td>
                <td colspan='7'>&nbsp;
                  <input type="radio" name="revolving" value="N">
                  Non
                  <input type="radio" name="revolving" value="Y">
                  ȸ��
		</td>
              </tr>		                
            </table>
	</td>
    </tr>	
    <tr>
        <td class=h></td>
    </tR>
	<tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ݸ�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="6%" rowspan="2" class=title>�ݸ�</td>
                <td width="7%" class=title>����ݸ�</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="fund_int" id="fund_int" size="5" maxlength="5" value="">%
				</td>
                <td width="6%" rowspan="2" class=title>�ݸ�����</td>
                <td width="8%" class=title>���뱸��</td>
                <td width="20%">&nbsp;
                  <select name="int_st" id="int_st">
                    <option value="" >����</option>
                    <option value="1">Ȯ���ݸ�</option>
                    <option value="2">�����ݸ�</option>
                  </select>
				</td>
                <td width="6%" rowspan="2" class=title>�������</td>
                <td width="7%" class=title>���رݸ�</td>
                <td width="20%">&nbsp;
                  <select name="app_b_st" id="app_b_st">
                    <option value="" >����</option>
                    <%	if(cd23_size > 0){
        			for(int i = 0 ; i < cd23_size ; i++){
        				CodeBean code = code23[i];%>
                    <option value="<%= code.getNm_cd()%>"><%= code.getNm()%></option>
                    <%		}
        		}%>
                  </select>
                  &nbsp;<a href="javascript:reg_app_b_st()"><span title="���رݸ� ���/����"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></span></a>
		</td>
              </tr>
              <tr>
                <td class=title>��ȿ�Ⱓ</td>
                <td>&nbsp;
                  <input type="text" class="text" name="validity_s_dt" id="validity_s_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
                  ~
                  <input type="text" class="text" name="validity_e_dt" id="validity_e_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td class=title> SPREAD </td>
                <td>&nbsp;
                  <input type="radio" name="spread" value="Y">��(<input type="text" class="text" name="spread_int" id="spread_int" value="" size="5" maxlength="5">%)
                  <input type="radio" name="spread" value="N">��                  
		</td>
                <td class=title>��������</td>
                <td>&nbsp;
                  <input type="text" class="text" name="app_b_dt" id="app_b_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
              </tr>
              <tr>
                <td colspan="2" class=title>Ư�����</td>
                <td colspan="7">&nbsp;
                  <textarea name="note" id="note" cols="90" rows="2"></textarea>
		</td>
              </tr>
            </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr id=tr_gua_1 style='display:none'>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ſ뺸���� �㺸 </span></td>
    </tr>
    <tr id=tr_gua_2 style='display:none'>
        <td class=line2></td>
    </tr>
    <tr id=tr_gua_3 style='display:none'>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>��������������</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="gua_org" id="gua_org" value="" size="28" maxlength="20" style="IME-MODE: active"></td>
                <td colspan="2" class=title>��������ȿ�Ⱓ</td>
                <td>&nbsp;
                  <input type="text" class="text" name="gua_s_dt" id="gua_s_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)"> 
                  ~ 
                  <input type="text" class="text" name="gua_e_dt" id="gua_e_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td width="13%" class=title>������</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="gua_int" id="gua_int" value="" size="5" maxlength="5">%
		</td>
              </tr>
              <tr>
                <td class=title>�����ݾ�</td>
                <td>&nbsp;
                  <input type="text" class="num" name="gua_amt" id="gua_amt" value="" size="15" maxlength="15" onBlur="javascript:this.value=parseDecimal(this.value)">��
		</td>
                <td width="6%" rowspan="2" class=title>�����</td>
                <td width="8%" class=title>��å/����</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="gua_title" value="" size="13" maxlength="20">
                  /
                  <input type="text" class="text" name="gua_agnt" value="" size="12" maxlength="20">
		</td>
                <td class=title>���������ſ�����</td>
                <td>&nbsp;
                    <input type="text" class="text" name="gua_est_dt" id="gua_est_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
              </tr>
              <tr>
                <td class=title>�����</td>
                <td>&nbsp;
                  <input type="text" class="num" name="gua_fee" id="gua_fee" value="" size="13" maxlength="11" onBlur="javascript:this.value=parseDecimal(this.value)">��
		</td>
                <td class=title>����ó</td>
                <td>&nbsp;
                  <input type="text" class="text" name="gua_tel" value="" size="13" maxlength="15"></td>
                <td class=title>�������������⼭��</td>
                <td>&nbsp;
                  <input type="text" class="text" name="gua_docs" id="gua_docs" value="" size="28" maxlength="50" style="IME-MODE: active">
		</td>
              </tr>
            </table></td>
    </tr>
    <tr id=tr_realty_1 style='display:none'>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ε��� �����缳�� �㺸 </span></td>
    </tr>
    <tr id=tr_realty_2 style='display:none'>
        <td class=line2></td>
    </tr>
    <tr id=tr_realty_3 style='display:none'>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>�㺸���ε����</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="realty_nm" id="realty_nm" value="" size="28" maxlength="30" style="IME-MODE: active">
				</td>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>
                <td width="14%" class=title>�㺸���ּ�</td>
                <td colspan="3">&nbsp;
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="50" value="">
				</td>
              </tr>
              <tr>
                <td class=title>�����缳���ݾ�</td>
                <td>&nbsp;
                  <input type="text" class="num" name="cltr_amt" id="cltr_amt" value="" size="13" maxlength="11" onBlur="javascript:this.value=parseDecimal(this.value)">��
		</td>
                <td class=title>��������</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="cltr_dt" id="cltr_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)"></td>
                <td width="13%" class=title>����Ǽ���</td>
                <td width="20%">&nbsp;
                  <input type="radio" name="cltr_st" value="Y">��
                  <input type="radio" name="cltr_st" value="N">��
		</td>
              </tr>
              <tr>
                <td class=title>��������</td>
                <td>&nbsp;
                  <input type="text" class="text" name="cltr_user" value="" size="28" maxlength="30" style="IME-MODE: active"></td>
                <td class=title>��������</td>
                <td colspan="3">&nbsp;
                  <input type="text" class="text" name="cltr_lank" value="" size="5" maxlength="1" maxlength="15">��</td>
              </tr>
            </table>
	</td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
     <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>	
	<tr>	   
	    <td align="center"><a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>	
    <% } %>			
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>