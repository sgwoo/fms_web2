<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//������ ��ȸ
	Vector vt2 = oc_db.getCarCashBackDayCd("");
	int vt_size2 = vt2.size();	
		
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String s_sort = request.getParameter("s_sort")==null?"1":request.getParameter("s_sort");
	
	//ī�彺���� ����Ʈ ��ȸ
	Vector vt = new Vector();
	int vt_size = 0;	
	
	if(!car_off_id.equals("")){
		vt = oc_db.getCarIncomStat(car_off_id, s_dt, s_sort);
		vt_size = vt.size();	
	}
	
	long total_amt0 = 0;
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;	
	
	String s_base_dt = "";
	String e_base_dt = "";
	
	if(vt_size > 0){
    for (int i = 0 ; i < vt_size ; i++){
      Hashtable ht = (Hashtable)vt.elementAt(i);
      if(i==0)         s_base_dt  = String.valueOf(ht.get("BASE_DT"));
      if(i+1==vt_size) e_base_dt  = String.valueOf(ht.get("BASE_DT"));
    }
	}	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function cng_car_off_id(value){
		var fm = document.form1;
		fm.s_dt.value = '';
		fm.action = "car_cash_back_incom_sc.jsp";
		fm.target = "_self";
		fm.submit();
  }
  
	function car_Search(){
		var fm = document.form1;
		fm.action="car_cash_back_incom_sc.jsp";
		fm.target="_self";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') car_Search();
	}	 
	
	function search_insidebank()
	{
		var fm = document.form1;
		var s_wd = fm.car_off_id.options[fm.car_off_id.selectedIndex].text;
		var bank_code = '';
		if(s_wd == '����븮��'){
			s_wd = '����';
			//bank_code = '220'; //�츮
		}
		if(s_wd == '���Ǵ�븮��'){
			s_wd = '��';
			//bank_code = '230'; //����
		}
		if(s_wd == '���ʹ븮��'){
			s_wd = '����';	
			//bank_code = '040'; //����
		}
		if(s_wd == '�����ͽ�(��)'){
			s_wd = '÷��';	
			//bank_code = '260'; //����
		}
		if(s_wd == '������û������'){
			s_wd = '������';	
			//bank_code = '260'; //����
		}
		if(s_wd == '�Ѱ��븮��'){
			s_wd = '�Ѱ�';
			//bank_code = '230'; //����
		}
		if(s_wd == '�����δ븮��'){
			s_wd = '���� ��';
			//bank_code = '260'; //����
		}		
		if(s_wd == '�����븮��'){
			s_wd = '�۵���';			
			//bank_code = '230'; //����
		}	
		if(s_wd == '�ѽŴ뿪�븮��'){
			s_wd = '�̼���';
			//bank_code = '230'; //����
		}	
				
		//fm.bank_code.value = bank_code;					
		fm.s_wd.value = s_wd;
		fm.action = "/fms2/account/shinhan_erp_demand_inside_etc.jsp?t_wd="+replaceString("-","",fm.incom_dt.value);		
		window.open("about:blank", "AncDisp", "left=350, top=50, width=1100, height=800, scrollbars=yes, status=yes");
		fm.target = "AncDisp";
		fm.submit();		
	}		 
	
	function setScdIncom(idx){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		var scd_amt = toInt(parseDigit(fm.incom_amt.value));
		if(scd_amt == 0){
			alert('�Ա��Ѿ��� �����ϴ�.'); return;
		}else{
			if(tm == 1){
					if(scd_amt > 0){
						if(scd_amt > toInt(parseDigit(fm.base_amt.value))){
							fm.base_incom_amt.value = fm.base_amt.value;
						}else{
							fm.base_incom_amt.value = parseDecimal(scd_amt);
						}
					}
			}else{
				for(var i = idx ; i < toInt(fm.size.value) ; i ++){	
					if(scd_amt > 0){
						if(scd_amt > toInt(parseDigit(fm.base_amt[i].value))){
							fm.base_incom_amt[i].value = fm.base_amt[i].value;
						}else{
							fm.base_incom_amt[i].value = parseDecimal(scd_amt);
						}
						scd_amt = scd_amt - toInt(parseDigit(fm.base_incom_amt[i].value));
					}
				}
			}
			cal_rest();
		}	
	}
	
	function cal_rest(){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		if(tm == 1){
				fm.rest_amt.value = parseDecimal(toInt(parseDigit(fm.base_amt.value)) - toInt(parseDigit(fm.base_incom_amt.value)) - toInt(parseDigit(fm.m_amt.value)));
				if(toInt(parseDigit(fm.base_incom_amt.value)) > 0 && toInt(parseDigit(fm.rest_amt.value)) >0){
					fm.incom_bigo2.value = '�ܾ׹߻�';
				}else{
					fm.incom_bigo2.value = '';
				}
		}else{
			for(var i = 0 ; i < tm ; i ++){
				fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.base_amt[i].value)) - toInt(parseDigit(fm.base_incom_amt[i].value)) - toInt(parseDigit(fm.m_amt[i].value)));
				if(toInt(parseDigit(fm.base_incom_amt[i].value)) > 0 && toInt(parseDigit(fm.rest_amt[i].value)) >0){
					fm.incom_bigo2[i].value = '�ܾ׹߻�';
				}else{
					fm.incom_bigo2[i].value = '';
				}
			}
		}
		cal_total();
	}
	
	function cal_total(){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		var incom_amt = 0;
		var m_amt = 0;
		var rest_amt = 0;
		var l_amt = 0;
		if(tm == 1){
				incom_amt += toInt(parseDigit(fm.base_incom_amt.value));
				m_amt     += toInt(parseDigit(fm.m_amt.value));
				rest_amt  += toInt(parseDigit(fm.rest_amt.value));
		}else{
			for(var i = 0 ; i < tm ; i ++){	
				incom_amt += toInt(parseDigit(fm.base_incom_amt[i].value));
				m_amt     += toInt(parseDigit(fm.m_amt[i].value));
				rest_amt  += toInt(parseDigit(fm.rest_amt[i].value));
			}
		}
		
		fm.t_incom_amt.value = parseDecimal(incom_amt);
		fm.t_m_amt.value = parseDecimal(m_amt);
		fm.t_rest_amt.value = parseDecimal(rest_amt);
		
		
	}	
	
	function cal_dt(){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		var dt = '';
		if(tm == 1){
				if(replaceString("-","",fm.incom_dt.value) == replaceString("-","",fm.est_dt.value) ){
					fm.start_scd.checked = true;
					setScdIncom(0);
				}
		}else{
			for(var i = 0 ; i < tm ; i ++){	
				if(dt == '' && replaceString("-","",fm.incom_dt.value) == replaceString("-","",fm.est_dt[i].value) ){
					fm.start_scd[i].checked = true;
					dt = replaceString("-","",fm.est_dt[i].value);
					setScdIncom(i);
				}
			}
		}	
	}
	
	function Save(){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		
		var bank_id = '';
		
		
		if(tm == 1){
		
			if(fm.autodoc_yn.checked == true && fm.bank_id.value == ''){
				alert('�ڵ���ǥ ������ �Ϸ��� �Աݿ��� ������ �Ǿ�� �մϴ�. ���������� �����ϴ�.');
			}	
		}else{
			for(var i = 0 ; i < tm ; i ++){	
				if(fm.bank_id[i].value != ''){
					bank_id = fm.bank_id[i].value;
				}
			}
		
			if(fm.autodoc_yn.checked == true && bank_id == ''){
				alert('�ڵ���ǥ ������ �Ϸ��� �Աݿ��� ������ �Ǿ�� �մϴ�. ���������� �����ϴ�.');
			}			
		}
		
		
		
		if(parseDigit(fm.incom_amt.value == '0') || parseDigit(fm.t_incom_amt.value == '0')){
			alert('�Ա��Ѿ� �� �Աݾ� �հ谡 �����ϴ�.'); return;
		}
		
		if(parseDigit(fm.incom_amt.value) != parseDigit(fm.t_incom_amt.value)){
			alert('�Ա��Ѿ� �� �Աݾ� �հ谡 �ٸ��ϴ�.'); return;
		}
		
		var chk = 0;
		if(tm == 1){
				if(fm.incom_bigo2.value != ''){
					chk = chk + 1;
				}
		}else{
			for(var i = 0 ; i < tm ; i ++){	
				if(fm.incom_bigo2[i].value != ''){
					chk = chk + 1;
				}
			}
		}
		
		if(chk >0){
			if(!confirm("�ܾ׹߻��� �ֽ��ϴ�. �Ա�ó���Ͻðڽ��ϱ�?"))	return;
		}else{
			if(!confirm("�Ա�ó���Ͻðڽ��ϱ�?"))	return;
		}
		fm.action = "car_cash_back_incom_sc_a.jsp";
		//fm.target = "i_no";
		fm.target = "_self";
		fm.submit();		
	}
	
	function setAmtType(amtset){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		//�ڵ�
		if(amtset == '1'){
			if(tm == 1){
					fm.base_incom_amt.readOnly = true;
					fm.rest_amt.readOnly = true;
					fm.base_incom_amt.className = "whitenum";
					fm.rest_amt.className = "whitenum";
			}else{
				for(var i = 0 ; i < tm ; i ++){	
					fm.base_incom_amt[i].readOnly = true;
					fm.rest_amt[i].readOnly = true;
					fm.base_incom_amt[i].className = "whitenum";
					fm.rest_amt[i].className = "whitenum";
				}
			}
			fm.incom_amt.readOnly = true;
			fm.incom_amt.className = "whitenum";
		//����
		}else{
			if(tm == 1){
					fm.base_incom_amt.readOnly = false;
					fm.rest_amt.readOnly = false;
					fm.base_incom_amt.className = "num";
					fm.rest_amt.className = "num";
			}else{
				for(var i = 0 ; i < tm ; i ++){	
					fm.base_incom_amt[i].readOnly = false;
					fm.rest_amt[i].readOnly = false;
					fm.base_incom_amt[i].className = "num";
					fm.rest_amt[i].className = "num";
				}
			}
		}
	}
	
	function setCarNum(carnumset){
		var fm = document.form1;
		var tm = toInt(fm.size.value);
		if(tm == 1){
			if(carnumset == '1'){
				fm.base_car_num.value = fm.car_num.value;	
			}else if(carnumset == '2'){
				fm.base_car_num.value = fm.car_num2.value;
			}else if(carnumset == '3'){
				fm.base_car_num.value = fm.car_num3.value;
			}else if(carnumset == '4'){
				fm.base_car_num.value = fm.car_num4.value;
			}			
		}else{
			for(var i = 0 ; i < toInt(fm.size.value) ; i ++){	
				if(carnumset == '1'){
					fm.base_car_num[i].value = fm.car_num[i].value;	
				}else if(carnumset == '2'){
					fm.base_car_num[i].value = fm.car_num2[i].value;
				}else if(carnumset == '3'){
					fm.base_car_num[i].value = fm.car_num3[i].value;
				}else if(carnumset == '4'){
					fm.base_car_num[i].value = fm.car_num4[i].value;	
				}				
			}
		}		
	}
	  
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='st' value=''>
<input type='hidden' name='base_dt' value=''>

<input type='hidden' name='size' value='<%=vt_size%>'>
<input type='hidden' name='s_kd' value='1'>
<input type='hidden' name='bank_code' value=''>
<input type='hidden' name='s_wd' value=''>
<input type='hidden' name='t_wd' value=''>
<input type='hidden' name='incom_st' value=''>

<input type='hidden' name='from_page' value='/card/cash_back/card_incom_sc.jsp'>

  <table border="0" cellspacing="0" cellpadding="0" width=1380>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Աݿ���(�Ǹ������)</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%'  class='title'>�ŷ�ó��</td>
            <td>&nbsp;
              <select name="car_off_id" id="car_off_id" onChange="javascript:cng_car_off_id(this.value)" >
                <option value=''>����</option>
                <%if(vt_size2 > 0){
                    for (int i = 0 ; i < vt_size2 ; i++){
                    	Hashtable ht = (Hashtable)vt2.elementAt(i);
                %>
                <option value='<%= ht.get("CAR_OFF_ID") %>' <%if(car_off_id.equals(String.valueOf(ht.get("CAR_OFF_ID")))){%>selected<%}%>><%=c_db.getNameById(String.valueOf(ht.get("CAR_OFF_ID")),"CAR_OFF")%></option>
                <%	}
                  }
                %>
              </select>
              <%if(!car_off_id.equals("") && vt_size > 0){%>
              &nbsp;&nbsp;&nbsp;&nbsp;
              �������� : <input name="s_dt" type="text" class="text" value="<%=s_dt%>" size="12" onKeyDown="javasript:enter()" style='IME-MODE: active'>
              &nbsp;<a href="javascript:car_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
              <%}else{%>
              <input type='hidden' name='s_dt' value=''>
              <%}%>
              &nbsp;&nbsp;&nbsp;&nbsp;
              1�������� : <select name="s_sort" id="s_sort">
                <option value='1'>�����</option>
                <option value='2'>�����ݾ�</option>
              </select>
              (�������� 0����)
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%if(!car_off_id.equals("")){%>
    <tr> 
        <td class=h></td>
    </tr>	
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='3%' rowspan='2' class='title'>����</td>
                    <td width='7%' rowspan='2' class='title'>�������</td>
                    <td width='7%' rowspan='2' class='title'>������ȣ</td>
                    <td width='11%' rowspan='2' class='title'>����</td>
                    <td width='7%' rowspan='2' class='title'>�����ȣ</td>
                    <td width='10%' rowspan='2' class='title'>�����ݾ�</td>
                    <td colspan='2' class='title'>�Ա�</td>
                    <td width='10%' rowspan='2' class='title'>�ܾ�</td>
                    <td width='10%' rowspan='2' class='title'>��������<br>(������ ����)</td>
                    <td width='10%' rowspan='2' class='title'>����</td>
                    <td width='7%' rowspan='2' class='title'></td>
                </tr>
                <tr>
                    <td width='10%' class='title'>�Աݾ�</td>
                    <td width='8%' class='title'>����ó��</td>
                </tr>                
                <%
                	String f_est_dt = "";
                	if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            total_amt0 = total_amt0 + AddUtil.parseLong(String.valueOf(ht.get("BASE_AMT")));					            
					            if(i==0) f_est_dt = AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")));
					      %>
<input type='hidden' name='tran_date_seq' value=''>
<input type='hidden' name='acct_seq' value=''>
<input type='hidden' name='bank_id' value=''>
<input type='hidden' name='bank_nm' value=''>
<input type='hidden' name='bank_no' value=''>					      
<input type='hidden' name='incom_bigo2' value=''>
<input type='hidden' name='bank_incom_dt' value=''>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td class='title'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%>
                    	<input type='hidden' name='serial' value='<%=ht.get("SERIAL")%>'>                    	
                    	<input type='hidden' name='est_dt' value='<%=ht.get("EST_DT")%>'>
                    </td> 
                    <td align="center"><%=ht.get("CAR_NO")%></td>                   
                    <td>&nbsp;<%=ht.get("CAR_NM")%></td>
                    <td align="center"><input type="text" name="base_car_num" size="10" value="<%=ht.get("CAR_NUM")%>" class=text>
                      <input type='hidden' name='car_num' value='<%=ht.get("CAR_NUM")%>'>
                      <input type='hidden' name='car_num2' value='<%=ht.get("CAR_NUM2")%>'>
                      <input type='hidden' name='car_num3' value='<%=ht.get("CAR_NUM3")%>'>
                      <input type='hidden' name='car_num4' value='<%=String.valueOf(ht.get("CAR_NUM3")).substring(0,4)%>'>
                    </td>
                    <td align="center"><input type="text" name="base_amt" size="12" value="<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BASE_AMT")))%>" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="base_incom_amt" size="12" value="0" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value);cal_rest();'>��</td>
                    <td align="center"><input type="text" name="m_amt" size="8" value="0" class=num onBlur='javascript:this.value=parseDecimal(this.value);cal_rest();'>��</td>
                    <td align="center"><input type="text" name="rest_amt" size="12" value="0" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type='radio' name="start_scd" value='<%=i%>' onClick="javascript:setScdIncom(<%=i%>)"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="center"><input type="text" name="incom_bigo" size="10" value="<%=ht.get("INCOM_BIGO")%>" class=text></td>
                    <td align="center"></td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title' colspan='5'>�հ�</td>
                    <td align="center"><input type="text" name="t_base_amt" size="12" value="<%=AddUtil.parseDecimalLong(total_amt0)%>" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="t_incom_amt" size="12" value="" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="t_m_amt" size="8" value="" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td align="center"><input type="text" name="t_rest_amt" size="12" value="" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value)'>��</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="12" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
        <td>�� �����ȣ : <input type='radio' name="carnumset" value='1' onClick="javascript:setCarNum(1)" checked>
                    	��6�ڸ����� 6��
                    	<input type='radio' name="carnumset" value='3' onClick="javascript:setCarNum(3)">
                    	��6�ڸ����� 5��
                    	<input type='radio' name="carnumset" value='4' onClick="javascript:setCarNum(4)">
                    	��6�ڸ����� 4��
                    	<input type='radio' name="carnumset" value='2' onClick="javascript:setCarNum(2)">
                    	��5�ڸ����� 5��

        </td>
    </tr>          
    <tr> 
        <td class=h></td>
    </tr>    
    <tr> 
        <td>�� �ϰ��Ա�ó��
        	&nbsp;<a href='javascript:search_insidebank()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_search.gif" align=absmiddle border="0"></a>	
        </td>
    </tr>      
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='10%' class='title'>�Ա�����</td>
                    <td width='10%'>&nbsp;<input type="text" name="incom_dt" class="text" value="<%=f_est_dt%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td width='10%' class='title'>�Ա��Ѿ�</td>
                    <td width='10%'>&nbsp;<input type="text" name="incom_amt" size="12" value="0" class=num onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                    <td width='10%' class='title'>�ڵ���ǥ</td>
                    <td>&nbsp;<input type="checkbox" name="autodoc_yn" value="Y" checked> ����</td>
                    <td width='10%' class='title'>�Աݹݿ�</td>
                    <td>&nbsp;
                    	<input type='radio' name="amtset" value='1' onClick="javascript:setAmtType(1)" checked>
                    	�ڵ�
                    	<input type='radio' name="amtset" value='2' onClick="javascript:setAmtType(2)">
                    	����
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
  <tr><td class=h></td></tr>  
    <tr> 
      <td align="right">
        <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�Աݴ��",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) || nm_db.getWorkAuthUser("ī��ĳ������",user_id)){%>
        <a href="javascript:Save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
        <%}%>
      </td>
    </tr>    
    <tr> 
        <td class=h></td>
    </tr>  
    <tr> 
        <td>�� �ܾ׹߻��� ��� ����ó���� �ݾ����� �Է��Ͽ� ������ �� �ֽ��ϴ�. �����Ա��� ��쿡�� ����ó������ ������.</td>
    </tr>      
    <tr> 
        <td>�� �Աݻ���ϰ� �ܾ��� ���� �ִ� ��쿡�� �� �ݾ����� �������� �߰� �����մϴ�.</td>
    </tr>    
    <tr> 
        <td>�� ���ͱݾ��� ��� ��1000�� �̻��̸� �Ǹ������ ����ڿ��� Ȯ�� �޽����� �߼��մϴ�.</td>
    </tr> 
    <%}%>  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
