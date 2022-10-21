<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.debt.*, acar.cls.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;
		if     (fm.cls_rtn_dt.value == '')	{ alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_rtn_dt.focus(); 	return;	}
		else if(fm.cls_rtn_cau.value == '')	{ alert('���������� �Է��Ͻʽÿ�'); 	fm.cls_rtn_cau.focus(); return; }
		else if(fm.nalt_rest.value == '')	{ alert('�̻�ȯ������ �Է��Ͻʽÿ�');	fm.nalt_rest.focus(); 	return; }
		else if(fm.cls_rtn_amt.value == '')	{ alert('�ߵ������ݾ׸� Ȯ���Ͻʽÿ�'); fm.cls_rtn_amt.focus(); return; }			

		if(toInt(fm.cls_rtn_fee_int.value)>0){
			var r_cls_rtn_fee_int_amt = parseDecimal(toInt(parseDigit(fm.nalt_rest.value))*fm.h_cls_rtn_fee_int.value/100);
			var def_amt = toInt(parseDigit(fm.cls_rtn_fee.value)) - r_cls_rtn_fee_int_amt;
			if(def_amt>10000 || def_amt<10000){
				alert('������ �ߵ������������ ���̰� ��10,000 ���̰� ���ϴ�. '); fm.cls_rtn_fee.focus(); return;	
			}
		}

		
		if(!confirm('�����Ͻðڽ��ϱ�?'))
			return;
		fm.target='i_no';
		fm.action='cls_i_a.jsp';
		fm.submit();		
	}

	//�Է½� �ڵ� ����ϱ�	
	function set_cls_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		fm.cls_rtn_amt.value = parseDecimal(toInt(parseDigit(fm.nalt_rest.value)) + toInt(parseDigit(fm.cls_rtn_fee.value))  + toInt(parseDigit(fm.cls_etc_fee.value)) + toInt(parseDigit(fm.cls_rtn_int_amt.value)) + toInt(parseDigit(fm.dly_alt.value)) - toInt(parseDigit(fm.be_alt.value)));			
	}
	
	//�հ� ó�� ����
	function set_cls_init(){
		var fm = document.form1;
		var r_cls_rtn_fee_int_amt = parseDecimal(toInt(parseDigit(fm.nalt_rest.value))*fm.h_cls_rtn_fee_int.value/100);
		fm.h_cls_rtn_fee.value = r_cls_rtn_fee_int_amt;
		fm.cls_rtn_amt.value = parseDecimal(toInt(parseDigit(fm.nalt_rest.value)) + toInt(parseDigit(fm.cls_rtn_fee.value)) + toInt(parseDigit(fm.cls_etc_fee.value)) + toInt(parseDigit(fm.cls_rtn_int_amt.value)) + toInt(parseDigit(fm.dly_alt.value)) - toInt(parseDigit(fm.be_alt.value)));			
	}
//-->
</script>
</head>
<body onload="javascript:document.form1.cls_rtn_cau.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "02");

	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");

	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] banks = c_db.getBankList("1"); /* �ڵ� ����:��1������ */	
	int bank_size = banks.length;
	
	Hashtable allot = ad_db.getAllotClsinfo(m_id, l_cd, car_id);
	String alt_tm=(String)allot.get("ALT_TM");
	Hashtable nalt = ad_db.getAllotNalt_rest(car_id, (String)allot.get("ALT_TM"));
	int dly_alt=ad_db.getAllotDly_alt(car_id);
	int be_alt=ad_db.getAllotBe_alt(car_id);
%>
<form name='form1' method='post' action='cls_i_a.jsp'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='reg_id' value='<%=user_id%>'>
<input type='hidden' name='reg_dt' value='<%=AddUtil.getDate()%>'>
<input type='hidden' name='cls_rtn_int' value='<%=allot.get("LEND_INT")%>'>
<input type='hidden' name='max_pay_dt' value='<%=nalt.get("PAY_DT")%>'>
<input type='hidden' name='alt_tm' value='<%=alt_tm%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;������ > �Һαݰ��� > <span class=style1><span class=style5>�Һα� �ߵ�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% class='title'>����ȣ</td>
                    <td width=14%>&nbsp;<%=l_cd%></td>
                    <td width=10% class='title'>��ȣ</td>
                    <td width=15%>&nbsp;<%=allot.get("FIRM_NM")%></td>
                    <td width=10% class='title'>�뿩����</td>
                    <td width=15%>&nbsp;<%=allot.get("CAR_NM")%></td>
                    <td width=12% class='title'>������ȣ</td>
                    <td width=14%>&nbsp;<%=allot.get("CAR_NO")%></td>
                </tr>
                <tr> 
                    <td class='title'>������</td>
                    <td>&nbsp;<%=c_db.getNameById((String)allot.get("CPT_CD"), "BANK")%></td>
                    <td class='title'>�����ȣ</td>
                    <td>&nbsp;<%=allot.get("LEND_NO")%></td>
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=allot.get("LEND_DT")%></td>
                    <td class='title'>����������</td>
                    <td align="right">&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)allot.get("LEND_PRN")))%>&nbsp;��&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>������</td>
                    <td>&nbsp;<%=allot.get("LEND_INT")%>%</td>
                    <td class='title'>�̻�ȯ����</td>
                    <td align='right'>&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)nalt.get("ALT_REST")))%>&nbsp;��&nbsp;&nbsp;</td>
                    <td class='title'>����������</td>
                    <td colspan='3'>&nbsp;<%=nalt.get("PAY_DT")%></td>                    
                </tr>
			    <tr>
    				<td class='title'>�ߵ���ȯ<br>������</td>
    		 		<td>&nbsp;<%=allot.get("CLS_RTN_FEE_INT")%>%&nbsp;</td>
    				<td class='title'>�ߵ���ȯ<br>Ư�̻���</td>
    				<td colspan='5'>&nbsp;<%=allot.get("CLS_RTN_ETC")%></td>
			    </tr>					
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ߵ������ݾ� ���⳻��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value)' value='<%=AddUtil.getDate()%>'> </td>
                </tr>		
                <tr> 
                    <td class='title'>�������� </td>
                    <td> &nbsp; 
                      <textarea name='cls_rtn_cau' rows='2' cols='100' style='IME-MODE: active'><%=AddUtil.parseDecimal(AddUtil.parseInt((String)nalt.get("ALT_REST")))%></textarea><!--/<%=AddUtil.parseDecimal(AddUtil.parseInt((String)nalt.get("NALT_REST_1")))%>/<%=AddUtil.parseDecimal(AddUtil.parseInt((String)nalt.get("NALT_REST_2")))%>  -->
                    </td>
                </tr>					
                <tr> 
                    <td width=15% class='title'> �̻�ȯ����</td>
                    <td width=85%>&nbsp; 
                      <input type='text' name='nalt_rest' size='15' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)nalt.get("ALT_REST")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this); document.form1.nalt_rest_2.value=this.value;'>
                      ��&nbsp;&nbsp;&nbsp;&nbsp;
					  (����������ä :
                      <input type='text' name='nalt_rest_1' size='15' value='<%//=AddUtil.parseDecimal(AddUtil.parseInt((String)nalt.get("NALT_REST_1")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                      ��, &nbsp;&nbsp;������Ա� :
                      <input type='text' name='nalt_rest_2' size='15' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)nalt.get("ALT_REST")))%><%//=AddUtil.parseDecimal(AddUtil.parseInt((String)nalt.get("NALT_REST_2")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                      ��&nbsp;&nbsp;)
					  </td>
                </tr>
                <tr> 
                    <td class='title'>�ߵ�����������</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_fee' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                      �� 
                      <input type='text' size='4' name='cls_rtn_fee_int' class='num' onBlur='javascript:set_cls_amt(this)' maxlength='4' value=''>
                      % 
					  <%if(!String.valueOf(allot.get("CLS_RTN_FEE_INT")).equals("")){%>
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  (���� : <input type='text' name='h_cls_rtn_fee' size='10' class='whitenum'>�� 
					          <input type='text' size='2' name='h_cls_rtn_fee_int' class='whitenum' maxlength='4' value='<%=allot.get("CLS_RTN_FEE_INT")%>'>%)
					  <%}%>
					</td>
                </tr> 
                <tr> 
                    <td class='title'> �������</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_int_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                      ��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'> ��Ÿ������</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_etc_fee' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                      ��&nbsp;(���縻�Ҵ���� ��)</td>
                </tr>                            
                <tr> 
                    <td class='title'> ��ü�Һα�</td>
                    <td>&nbsp; 
                      <input type='text' name='dly_alt' value='<%=AddUtil.parseDecimal(dly_alt)%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                      ��&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'> ������</td>
                    <td>&nbsp; 
                      <input type='text' name='be_alt' value='<%=AddUtil.parseDecimal(be_alt)%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                      ��&nbsp;</td>
                </tr>    
                <tr> 
                    <td class='title'> �հ�</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_amt' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=15% class='title'> �����</td>
                    <td width=20%>&nbsp; 
        			  <!--<input type="text" size="10" name="bk_code" class="text">-->
                      <select name='bk_code'>
                        <%	if(bank_size > 0){
        								for(int i = 0 ; i < bank_size ; i++){
        									CodeBean bank = banks[i];		%>
                        <option value='<%= bank.getCode()%>' ><%= bank.getNm()%></option>
                              <%		}
        							}		%>
                            </select>
                    </td>
                    <td width=10% class='title'> ���¹�ȣ</td>
                    <td width=18%>&nbsp; 
                      <input type="text" size="25" name="acnt_no" class="text">
                    </td>
                    <td class='title' width=10%>�����ָ�</td>
                    <td width=17%>&nbsp; 
                      <input type='text' size='19' name='acnt_user' class='text'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr align="right"> 
        <td> 
		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save();'><img src=../images/center/button_reg.gif align=absmiddle border=0></a>
		&nbsp; 
        <%}%>	
		<a href='javascript:window.close();'><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
	set_cls_init();
//-->
</script>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
