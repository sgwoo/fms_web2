<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String set_code = request.getParameter("set_code")==null?"":request.getParameter("set_code");
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	EstimateBean e_bean1 = new EstimateBean();
	EstimateBean e_bean2 = new EstimateBean();
	EstimateBean e_bean3 = new EstimateBean();
	EstimateBean e_bean4 = new EstimateBean();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	e_bean1 = e_db.getEstimateCase(est_id);
	
	cm_bean = a_cmb.getCarNmCase(e_bean1.getCar_id(), e_bean1.getCar_seq());
	
	Vector vars = e_db.getABTypeEstIds(set_code, est_id);
	int size = vars.size();
	
	for(int i = 0 ; i < size ; i++){
		Hashtable var = (Hashtable)vars.elementAt(i);
		
		if(i==0) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
		if(i==1) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
		if(i==2) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//������ã��
	function search_cust(){
		var fm = document.form1;
		var SUBWIN="search_cust_list.jsp?t_wd="+fm.est_nm.value;		
		window.open(SUBWIN, "SubCust", "left=10, top=10, width=1250, height=800, scrollbars=yes, status=yes");		
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search_cust();
	}	
	
	//�ڵ���ȸ�� ����� �����ڵ� ����ϱ�
	function GetCarCode(){
		var fm = document.form1;
		var fm2 = document.form2;
		te = fm.code;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm2.sel.value = "form1.code";
		fm2.car_comp_id.value = fm.car_comp_id.value;
		fm2.mode.value = '8';
		fm2.rent_way.value = '';		
		fm2.a_a.value = '';		
		fm2.target="i_no";
		fm2.submit();
	}
	
	//���θ���Ʈ (����,�ɼ�,����)
	function sub_list(idx){
		var fm = document.form1;
		if(fm.code.value == ''){ alert('������ �����Ͻʽÿ�.'); return;}
		var SUBWIN="./search_sub_list.jsp?idx="+idx+"&a_a=&car_comp_id="+fm.car_comp_id.value+"&car_cd="+fm.code.value+"&car_id="+fm.car_id.value+"&car_seq="+fm.car_seq.value+"&car_nm="+fm.code.options[fm.code.selectedIndex].text;	
		window.open(SUBWIN, "SubList", "left=100, top=100, width=600, height=400, scrollbars=yes, status=yes");
	}

		
	//����==�ݾ� ��ȯ
	function compare(idx, obj){
		var fm = document.form1;
		
		if(obj == fm.rg_8[idx]){
			fm.rg_8_amt[idx].value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.rg_8[idx].value)/100);	
		}else if(obj == fm.rg_8_amt[idx]){
			var rg_8 = toInt(parseDigit(fm.rg_8_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) * 100;
			fm.rg_8[idx].value = Math.round(rg_8);	
		}else if(obj == fm.pp_per[idx]){
			fm.pp_amt[idx].value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.pp_per[idx].value)/100);						
		}else if(obj == fm.pp_amt[idx]){
			fm.pp_per[idx].value = Math.round(toInt(parseDigit(fm.pp_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}else if(obj == fm.ro_13[idx]){
			fm.ro_13_amt[idx].value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.ro_13[idx].value)/100);		
		}else if(obj == fm.ro_13_amt[idx]){
			var ro_13 = toInt(parseDigit(fm.ro_13_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) * 100;
			fm.ro_13[idx].value = Math.round(ro_13);		
		}else if(obj == fm.gi_per[idx]){
			fm.gi_amt[idx].value = parseDecimal(toInt(parseDigit(fm.o_1.value)) * toInt(fm.gi_per[idx].value)/100);						
		}else if(obj == fm.pp_amt[idx]){
			fm.gi_per[idx].value = Math.round(toInt(parseDigit(fm.gi_amt[idx].value)) / toInt(parseDigit(fm.o_1.value)) * 100);
		}	
	}
				
	//������D/C �Է��� ��������ϱ�
	function set_amt(){
		var fm = document.form1;	
		fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));		
	}
	
	//�ִ��ܰ��� ��ȸ
	function searchO13(idx){
		var fm = document.sh_form;
		var fm2 = document.form1;		

		if(fm2.car_id.value == ''){ 	alert('������ �����Ͻʽÿ�'); 		return; }
		if(fm2.car_amt.value == ''){ 	alert('�����ݾ��� Ȯ���Ͻʽÿ�'); 	return; }						
		if(fm2.a_a[idx].value == ''){ 	alert('�뿩��ǰ�� �����Ͻʽÿ�'); 	return; }
		if(fm2.a_b[idx].value == ''){ 	alert('�뿩�Ⱓ�� �����Ͻʽÿ�'); 	return; }
		
		if(fm2.est_yn[idx].checked ==false)  fm2.est_yn[idx].checked = true;
		
		fm.car_id.value 	= fm2.car_id.value;
		fm.car_seq.value 	= fm2.car_seq.value;
		fm.car_amt.value 	= fm2.car_amt.value;
		fm.opt_amt.value 	= fm2.opt_amt.value;
		fm.col_amt.value 	= fm2.col_amt.value;
		fm.dc_amt.value 	= fm2.dc_amt.value;
		fm.o_1.value 		= fm2.o_1.value;		
		fm.a_a.value 		= fm2.a_a[idx].value;
		fm.a_b.value 		= fm2.a_b[idx].value;		
		fm.idx.value 		= idx;		
		
		var car_price 		= toInt(parseDigit(fm.o_1.value));
		
		fm2.rg_8[idx].value 		= '25';
		fm2.rg_8_amt[idx].value 	= parseDecimal(car_price * 25 /100 );
		
		if(fm.a_a.value == '22' || fm.a_a.value == '21'){
			if(car_price < 25000000){
				fm2.rg_8[idx].value 		= '20';
				fm2.rg_8_amt[idx].value 	= parseDecimal(car_price * 20 /100 );
			}						
		}		
		
		fm.action = '/acar/estimate_mng/get_o13_20110101.jsp';		
		fm.target = 'i_no';
		fm.submit();
	}	
		
	//��������
	function EstiReg(){
		var fm = document.form1;
		
		if(fm.est_nm.value == ''){ 		alert('��/��ȣ�� �Է��Ͻʽÿ�'); 	return; }				
		if(fm.code.value == ''){ 		alert('������ �����Ͻʽÿ�'); 			return; }
		if(fm.car_id.value == ''){ 		alert('������ �����Ͻʽÿ�'); 			return; }
		if(fm.car_amt.value == ''){ 	alert('���������� Ȯ���Ͻʽÿ�'); 		return; }				
		if(fm.a_a[0].value == ''){ 		alert('�뿩��ǰ�� �����Ͻʽÿ�'); 		return; }
		if(fm.a_b[0].value == ''){ 		alert('�뿩�Ⱓ�� �����Ͻʽÿ�'); 		return; }
		
		var a_h = 1;
		var a_e = fm.s_st.value;
		var au28 = 0;
		var av28 = 0;
		if(a_e == 402 || a_e == 501 || a_e == 502 || a_e == 601 || a_e == 602) au28 = 1;//7-9�ν�2000cc�ʰ�¤����
		if(a_e == 104 || a_e == 105 || a_e == 106 || a_e == 107 || a_e == 201) av28 = 1;//�����¿뿩��
		
		for(i=0; i<4 ; i++){
			
			if(fm.est_yn[i].checked == true && fm.o_13[i].value == ''){ 	alert((i+1)+'�� ���� �ִ��ܰ����� �Է��Ͻʽÿ�'); 	return; }	
			
			var a_a = fm.a_a[i].options[fm.a_a[i].selectedIndex].value;		
			a_a = a_a.substring(0,1);					
			if(a_a != ''){
				if(a_a==1){//����		
					a_h = 4;	
				}else{//��Ʈ
					if(fm.udt_st[i].value == '1') 				a_h = 2; //�����μ��϶� ���
					else if(fm.udt_st[i].value == '2') 			a_h = 4; //�λ��μ��ϴ� �泲
					else if(fm.udt_st[i].value == '3') 			a_h = 4; //�����μ��϶� �泲
				}
				fm.a_h[0].value = a_h;
			}
		}
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return; }
		fm.cmd.value = "i";
		fm.action = 'esti_mng_atype_i_a.jsp';
//		fm.target = "d_content";
		fm.target = "i_no";
//		fm.submit();
	}
	


	
//-->
</script>
</head>
<body leftmargin="15" rightmargin=0 onload="javascript:document.form1.est_nm.focus();">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="/acar/estimate_mng/get_carcd_null.jsp" name="form2" method="post">
    <input type="hidden" name="sel" value="">
    <input type="hidden" name="car_comp_id" value="">
    <input type="hidden" name="code" value="">
    <input type="hidden" name="mode" value="">
    <input type="hidden" name="rent_way" value="">	
    <input type="hidden" name="a_a" value="">		
  </form>
<form action='/acar/estimate_mng/get_o13_20110101.jsp' name="sh_form" method='post'>
  <input type='hidden' name="car_id"			value="">    
  <input type='hidden' name="car_seq"			value="">    
  <input type='hidden' name="car_amt"			value="">  
  <input type='hidden' name="opt_amt"			value="">  
  <input type='hidden' name="col_amt"			value="">      
  <input type='hidden' name="dc_amt"			value="">      
  <input type='hidden' name="o_1"				value="">          
  <input type='hidden' name="a_a"				value="">
  <input type='hidden' name="a_b"				value="">  
  <input type='hidden' name="esti_type"			value="a">    
  <input type='hidden' name="idx"				value="0">      
</form>
  <form action="./esti_mng_atype_i_a.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="cmd" value="">
    <input type="hidden" name="s_st" value="">
    <input type="hidden" name="a_e" value="">
	<input type="hidden" name="a_h" value="">		
	<input type="hidden" name="a_h" value="">		
	<input type="hidden" name="a_h" value="">		
	<input type="hidden" name="a_h" value="">					
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �����ý��� > <span class=style5>������������-AŸ��</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span> </td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>��ȣ/����</td>
                    <td width=19%> 
                        &nbsp;<input type="text" name="est_nm" value="<%=e_bean1.getEst_nm()%>" size="27" class=text onKeyDown='javascript:enter()' style='IME-MODE: active'>
						
                  </td>
                    <td class=title width=13%>�����/�������</td>
                    <td width=14%> 
                        &nbsp;<input type="text" name="est_ssn" value="<%=e_bean1.getEst_ssn()%>" size="15" class=text>
                    </td>
                    <td class=title width=10%>��ȭ��ȣ</td>
                    <td width=12%> 
                        &nbsp;<input type="text" name="est_tel" value="<%=e_bean1.getMgr_nm()%>" size="12" class=text>
                    </td>
                    <td class=title width=10%>FAX</td>
                    <td width=12%> 
                        &nbsp;<input type="text" name="est_fax" value="<%=e_bean1.getMgr_ssn()%>" size="12" class=text>
                    </td>
                </tr>
                <tr>				
                    <td class=title>������</td>
                    <td colspan="7">&nbsp;<input type="radio" name="doc_type" value="1" <% if(e_bean1.getDoc_type().equals("1")||e_bean1.getDoc_type().equals("")) out.print("checked"); %>>
                      ���ΰ�
					  <input type="radio" name="doc_type" value="2" <% if(e_bean1.getDoc_type().equals("2")) out.print("checked"); %>>
                      ���λ���� 
					  <input type="radio" name="doc_type" value="3" <% if(e_bean1.getDoc_type().equals("3")) out.print("checked"); %>>
                      ���� 					  
                      </td>
                </tr>					  
                <tr>
                    <td class=title>������ȿ�Ⱓ</td>
                    <td colspan="7">&nbsp;<input type="radio" name="vali_type" value="0" <% if(e_bean1.getVali_type().equals("0")||e_bean1.getVali_type().equals("")) out.print("checked"); %>>
                      ��¥��ǥ��(10��)
					  <input type="radio" name="vali_type" value="1" <% if(e_bean1.getVali_type().equals("1")) out.print("checked"); %>>
                      ����ĿD/C ���� ���ɼ� ��� 
					  <input type="radio" name="vali_type" value="2" <% if(e_bean1.getVali_type().equals("2")) out.print("checked"); %>>
                      ��Ȯ������ 
                      </td>
                </tr>				
                <tr>
                    <td class=title>�ſ뵵</td>
                    <td colspan="7">&nbsp;<b><% if(e_bean1.getSpr_yn().equals("2")){%>�ʿ췮���<% }else if(e_bean1.getSpr_yn().equals("1")){%>�췮���<% }else if(e_bean1.getSpr_yn().equals("0")){%>�Ϲݱ��<% }else if(e_bean1.getSpr_yn().equals("3")){%>�ż�����<%}%></b>
                      </td>
                </tr>										
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
        <td align="right"><a href="#"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>������</td>
                    <td colspan="2"> 
                      &nbsp;<%=cm_bean.getCar_comp_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td colspan="2"> 
                      &nbsp;<%=cm_bean.getCar_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td width=70%> 
                      &nbsp;<%=cm_bean.getCar_name()%></td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getCar_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title>�ɼ�</td>
                    <td> 
                      &nbsp;<%=e_bean1.getOpt()%></td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getOpt_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td> 
                      &nbsp;<%=e_bean1.getCol()%></td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getCol_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title>������DC</td>
                    <td>&nbsp; 
                      </td>
                    <td align="right"> 
                      -<%=AddUtil.parseDecimal(e_bean1.getDc_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">��������</td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getO_1())%>��</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span>
		(<%=set_code%>)
		</td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>

    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td colspan='2' class=title>����</td>
                  <td width="24%" class=title>����1</td>
                  <td width="22%" class=title><%if(!e_bean2.getEst_id().equals("")){%>����2<%}%></td>
                  <td width="22%" class=title><%if(!e_bean3.getEst_id().equals("")){%>����3<%}%></td>
                  <td width="22%" class=title><%if(!e_bean4.getEst_id().equals("")){%>����4<%}%></td>
                </tr>		
                <tr> 
                    <td colspan='2' class=title>�뿩��ǰ</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean1.getA_a())%>
                    </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%>
                    </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean3.getA_a())%>
                    </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%>
                    </td>
                </tr>
                <tr> 
                    <td colspan='2' class=title>�뿩�Ⱓ</td>
                    <td>&nbsp;<%=e_bean1.getA_b()%>����</td>
                    <td>&nbsp;<%=e_bean2.getA_b()%>����</td>
                    <td>&nbsp;<%=e_bean3.getA_b()%>����</td>
                    <td>&nbsp;<%=e_bean4.getA_b()%>����</td>
                </tr>
                <tr> 
                    <td width='3%' rowspan="3" class=title>��<br>��</td>
                    <td class=title width='7%'>�ִ��ܰ���</td>
                    <td>&nbsp;������ <%=e_bean1.getO_13()%>%</td>
                    <td>&nbsp;������ <%=e_bean2.getO_13()%>%</td>
                    <td>&nbsp;������ <%=e_bean3.getO_13()%>%</td>
                    <td>&nbsp;������ <%=e_bean4.getO_13()%>%</td>															
                </tr>				
                <tr> 
                    <td class=title width='7%'>�����ܰ���</td>
                    <td>&nbsp;������ <%=e_bean1.getRo_13()%>% &nbsp;�����ܰ��ݾ� <%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%>��</td>
                    <td>&nbsp;������ <%=e_bean2.getRo_13()%>% &nbsp;�����ܰ��ݾ� <%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>��</td>
                    <td>&nbsp;������ <%=e_bean3.getRo_13()%>% &nbsp;�����ܰ��ݾ� <%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>��</td>
                    <td>&nbsp;������ <%=e_bean4.getRo_13()%>% &nbsp;�����ܰ��ݾ� <%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>��</td>
                </tr>									
                <tr> 
                    <td class=title>���Կɼ�</td>
                    <td>&nbsp;<%if(e_bean1.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean1.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean2.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean3.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getOpt_chk().equals("0")){%>�̺ο�<%}else if(e_bean4.getOpt_chk().equals("1")){%>�ο�<%}%></td>
                </tr>				  		  		
                <tr> 
                    <td rowspan="3" class=title>��<br>��</td>
                    <td class=title>������</td>
                    <td>&nbsp;������ <%=e_bean1.getRg_8()%>% &nbsp;���뺸���ݾ� <%=AddUtil.parseDecimal(e_bean1.getRg_8_amt())%>��</td>
					<td>&nbsp;������ <%=e_bean2.getRg_8()%>% &nbsp;���뺸���ݾ� <%=AddUtil.parseDecimal(e_bean2.getRg_8_amt())%>��</td>
					<td>&nbsp;������ <%=e_bean3.getRg_8()%>% &nbsp;���뺸���ݾ� <%=AddUtil.parseDecimal(e_bean3.getRg_8_amt())%>��</td>
					<td>&nbsp;������ <%=e_bean4.getRg_8()%>% &nbsp;���뺸���ݾ� <%=AddUtil.parseDecimal(e_bean4.getRg_8_amt())%>��</td>                    
                </tr>
                <tr> 
                    <td class=title>������</td>
					<td>&nbsp;������ <%=e_bean1.getPp_per()%>% &nbsp;���뼱���ݾ� <%=AddUtil.parseDecimal(e_bean1.getPp_amt())%>��</td>
					<td>&nbsp;������ <%=e_bean2.getPp_per()%>% &nbsp;���뼱���ݾ� <%=AddUtil.parseDecimal(e_bean2.getPp_amt())%>��</td>
					<td>&nbsp;������ <%=e_bean3.getPp_per()%>% &nbsp;���뼱���ݾ� <%=AddUtil.parseDecimal(e_bean3.getPp_amt())%>��</td>
					<td>&nbsp;������ <%=e_bean4.getPp_per()%>% &nbsp;���뼱���ݾ� <%=AddUtil.parseDecimal(e_bean4.getPp_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title>���ô뿩��</td>
                    <td>&nbsp;<%=e_bean1.getG_10()%>����ġ �뿩�� ����</td>
                    <td>&nbsp;<%=e_bean2.getG_10()%>����ġ �뿩�� ����</td>
                    <td>&nbsp;<%=e_bean3.getG_10()%>����ġ �뿩�� ����</td>
                    <td>&nbsp;<%=e_bean4.getG_10()%>����ġ �뿩�� ����</td>															
                </tr>
                <tr> 
                    <td rowspan="6" class=title>��<br>��</td>
                    <td class=title>��������</td>
					<td>&nbsp;<%if(e_bean1.getInsurant().equals("1")){%>�Ƹ���ī <%}else if(e_bean1.getInsurant().equals("2")){%>�� <%}%></td>
					<td>&nbsp;<%if(e_bean2.getInsurant().equals("1")){%>�Ƹ���ī <%}else if(e_bean2.getInsurant().equals("2")){%>�� <%}%></td>
					<td>&nbsp;<%if(e_bean3.getInsurant().equals("1")){%>�Ƹ���ī <%}else if(e_bean3.getInsurant().equals("2")){%>�� <%}%></td>
					<td>&nbsp;<%if(e_bean4.getInsurant().equals("1")){%>�Ƹ���ī <%}else if(e_bean4.getInsurant().equals("2")){%>�� <%}%></td>					
                </tr>
                <tr>                     
                    <td class=title>�Ǻ�����</td>
					<td>&nbsp;<%if(e_bean1.getIns_per().equals("1")){%>�Ƹ���ī(��������)<%}else if(e_bean1.getIns_per().equals("2")){%>��(���������)<%}%></td>
					<td>&nbsp;<%if(e_bean2.getIns_per().equals("1")){%>�Ƹ���ī(��������)<%}else if(e_bean2.getIns_per().equals("2")){%>��(���������)<%}%></td>
					<td>&nbsp;<%if(e_bean3.getIns_per().equals("1")){%>�Ƹ���ī(��������)<%}else if(e_bean3.getIns_per().equals("2")){%>��(���������)<%}%></td>
					<td>&nbsp;<%if(e_bean4.getIns_per().equals("1")){%>�Ƹ���ī(��������)<%}else if(e_bean4.getIns_per().equals("2")){%>��(���������)<%}%></td>					
                </tr>
                <tr>
                  <td class=title>�빰/�ڼ�</td>
                  <td>&nbsp;<%if(e_bean1.getIns_dj().equals("1")){%>5õ����<%}else if(e_bean1.getIns_dj().equals("2")){%>1���<%}%></td>
                  <td>&nbsp;<%if(e_bean2.getIns_dj().equals("1")){%>5õ����<%}else if(e_bean2.getIns_dj().equals("2")){%>1���<%}%></td>
                  <td>&nbsp;<%if(e_bean3.getIns_dj().equals("1")){%>5õ����<%}else if(e_bean3.getIns_dj().equals("2")){%>1���<%}%></td>
                  <td>&nbsp;<%if(e_bean4.getIns_dj().equals("1")){%>5õ����<%}else if(e_bean4.getIns_dj().equals("2")){%>1���<%}%></td>				  				  				  
                </tr>
                <tr>
                  <td class=title>�����ڿ���</td>
				  <td>&nbsp;<%if(e_bean1.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean1.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean1.getIns_age().equals("3")){%>��24���̻�<%}%></td>
				  <td>&nbsp;<%if(e_bean2.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean2.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean2.getIns_age().equals("3")){%>��24���̻�<%}%></td>
				  <td>&nbsp;<%if(e_bean3.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean3.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean3.getIns_age().equals("3")){%>��24���̻�<%}%></td>
				  <td>&nbsp;<%if(e_bean4.getIns_age().equals("1")){%>��26���̻�<%}else if(e_bean4.getIns_age().equals("2")){%>��21���̻�<%}else if(e_bean4.getIns_age().equals("3")){%>��24���̻�<%}%></td>
                </tr>
                <tr> 
                    <td class=title>������å��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getCar_ja())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getCar_ja())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getCar_ja())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getCar_ja())%>��</td>										
                </tr>
                <tr> 
                    <td class=title>��������</td>
					<td>&nbsp;������ <%=e_bean1.getGi_per()%>% &nbsp;���Աݾ� <%=AddUtil.parseDecimal(e_bean1.getGi_amt())%>��</td>
					<td>&nbsp;������ <%=e_bean2.getGi_per()%>% &nbsp;���Աݾ� <%=AddUtil.parseDecimal(e_bean2.getGi_amt())%>��</td>
					<td>&nbsp;������ <%=e_bean3.getGi_per()%>% &nbsp;���Աݾ� <%=AddUtil.parseDecimal(e_bean3.getGi_amt())%>��</td>
					<td>&nbsp;������ <%=e_bean4.getGi_per()%>% &nbsp;���Աݾ� <%=AddUtil.parseDecimal(e_bean4.getGi_amt())%>��</td>
                </tr>
                <tr> 
                    <td rowspan="4" class=title>��<br>Ÿ</td>				
                    <td class=title>�����μ�����</td>
                    <td>&nbsp;<%if(e_bean1.getUdt_st().equals("1")){%>���ﺻ��<%}else if(e_bean1.getUdt_st().equals("2")){%>�λ�����<%}else if(e_bean1.getUdt_st().equals("3")){%>��������<%}else if(e_bean1.getUdt_st().equals("4")){%>��<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getUdt_st().equals("1")){%>���ﺻ��<%}else if(e_bean2.getUdt_st().equals("2")){%>�λ�����<%}else if(e_bean2.getUdt_st().equals("3")){%>��������<%}else if(e_bean2.getUdt_st().equals("4")){%>��<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getUdt_st().equals("1")){%>���ﺻ��<%}else if(e_bean3.getUdt_st().equals("2")){%>�λ�����<%}else if(e_bean3.getUdt_st().equals("3")){%>��������<%}else if(e_bean3.getUdt_st().equals("4")){%>��<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getUdt_st().equals("1")){%>���ﺻ��<%}else if(e_bean4.getUdt_st().equals("2")){%>�λ�����<%}else if(e_bean4.getUdt_st().equals("3")){%>��������<%}else if(e_bean4.getUdt_st().equals("4")){%>��<%}%></td>															
                </tr>			
                <tr> 
                    <td class=title>�ǵ������</td>
                    <td>&nbsp;<%if(e_bean1.getA_h().equals("1")){%>����<%}else if(e_bean1.getA_h().equals("2")){%>����<%}else if(e_bean1.getA_h().equals("3")){%>�λ�<%}else if(e_bean1.getA_h().equals("4")){%>����<%}else if(e_bean1.getA_h().equals("5")){%>����<%}else if(e_bean1.getA_h().equals("6")){%>��õ<%}else if(e_bean1.getA_h().equals("7")){%>��õ<%}else if(e_bean1.getA_h().equals("8")){%>����<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getA_h().equals("1")){%>����<%}else if(e_bean2.getA_h().equals("2")){%>����<%}else if(e_bean2.getA_h().equals("3")){%>�λ�<%}else if(e_bean2.getA_h().equals("4")){%>����<%}else if(e_bean2.getA_h().equals("5")){%>����<%}else if(e_bean2.getA_h().equals("6")){%>��õ<%}else if(e_bean2.getA_h().equals("7")){%>��õ<%}else if(e_bean2.getA_h().equals("8")){%>����<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getA_h().equals("1")){%>����<%}else if(e_bean3.getA_h().equals("2")){%>����<%}else if(e_bean3.getA_h().equals("3")){%>�λ�<%}else if(e_bean3.getA_h().equals("4")){%>����<%}else if(e_bean3.getA_h().equals("5")){%>����<%}else if(e_bean3.getA_h().equals("6")){%>��õ<%}else if(e_bean3.getA_h().equals("7")){%>��õ<%}else if(e_bean3.getA_h().equals("8")){%>����<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getA_h().equals("1")){%>����<%}else if(e_bean4.getA_h().equals("2")){%>����<%}else if(e_bean4.getA_h().equals("3")){%>�λ�<%}else if(e_bean4.getA_h().equals("4")){%>����<%}else if(e_bean4.getA_h().equals("5")){%>����<%}else if(e_bean4.getA_h().equals("6")){%>��õ<%}else if(e_bean4.getA_h().equals("7")){%>��õ<%}else if(e_bean4.getA_h().equals("8")){%>����<%}%></td>
                </tr>			
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;������<%=e_bean1.getO_11()%>%</td>
                    <td>&nbsp;������<%=e_bean2.getO_11()%>%</td>
                    <td>&nbsp;������<%=e_bean3.getO_11()%>%</td>
                    <td>&nbsp;������<%=e_bean4.getO_11()%>%</td>
                </tr>											
                <tr> 
                    <td class=title>�뿩��D/C</td>
                    <td>&nbsp;�뿩����<%=e_bean1.getFee_dc_per()%>%</td>
                    <td>&nbsp;�뿩����<%=e_bean2.getFee_dc_per()%>%</td>
                    <td>&nbsp;�뿩����<%=e_bean3.getFee_dc_per()%>%</td>
                    <td>&nbsp;�뿩����<%=e_bean4.getFee_dc_per()%>%</td>
                </tr>	
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span>
		</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td colspan='2' class=title>����</td>
                  <td width="24%" class=title><input type="checkbox" name="est_yn" value="Y" checked >����1</td>
                  <td width="22%" class=title><%if(!e_bean2.getEst_id().equals("")){%><input type="checkbox" name="est_yn" value="Y" checked><%}%>����2</td>
                  <td width="22%" class=title><%if(!e_bean3.getEst_id().equals("")){%><input type="checkbox" name="est_yn" value="Y" checked><%}%>����3</td>
                  <td width="22%" class=title><%if(!e_bean4.getEst_id().equals("")){%><input type="checkbox" name="est_yn" value="Y" checked><%}%>����4</td>
                </tr>		
                <tr> 
                    <td width='3%' rowspan="3" class=title>��<br>��<br>��<br>��</td>				
                    <td class=title>���ް�</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getFee_s_amt())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getFee_s_amt())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getFee_s_amt())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getFee_s_amt())%>��</td>															
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getFee_v_amt())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getFee_v_amt())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getFee_v_amt())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getFee_v_amt())%>��</td>															
                </tr>						
                <tr> 
                    <td class=title>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt())%>��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt())%>��</td>															
                </tr>		
                <tr> 
                    <td rowspan="2" class=title>��<br>��<br>��</td>				
                    <td class=title>�ʿ�������</td>
                    <td>&nbsp;<%=e_bean1.getCls_n_per()%>%</td>
                    <td>&nbsp;<%=e_bean2.getCls_n_per()%>%</td>
                    <td>&nbsp;<%=e_bean3.getCls_n_per()%>%</td>
                    <td>&nbsp;<%=e_bean4.getCls_n_per()%>%</td>
                </tr>
                <tr> 
                    <td class=title>����������</td>
                    <td>&nbsp;<%=e_bean1.getCls_per()%>%&nbsp;<a href='#'><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a></td>
                    <td>&nbsp;<%=e_bean2.getCls_per()%>%&nbsp;<a href='#'><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a></td>
                    <td>&nbsp;<%=e_bean3.getCls_per()%>%&nbsp;<a href='#'><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a></td>
                    <td>&nbsp;<%=e_bean4.getCls_per()%>%&nbsp;<a href='#'><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="����"></a></td>
                </tr>		
                <tr> 
                    <td colspan='2' class=title>������</td>
                    <td>&nbsp;<a href='#'>����</a></td>
                    <td>&nbsp;<%if(!e_bean2.getEst_id().equals("")){%><a href='#'>����</a><%}%></td>
                    <td>&nbsp;<%if(!e_bean3.getEst_id().equals("")){%><a href='#'>����</a><%}%></td>
                    <td>&nbsp;<%if(!e_bean4.getEst_id().equals("")){%><a href='#'>����</a><%}%></td>
                </tr>			
                <tr> 
                    <td colspan='2' class=title>�񱳰���</td>
                    <td>&nbsp;<a href='#'>AŸ��</a>&nbsp;&nbsp;<a href='#'>BŸ��</a></td>
                    <td>&nbsp;<%if(!e_bean2.getEst_id().equals("")){%><a href='#'>AŸ��</a>&nbsp;&nbsp;<a href='#'>BŸ��</a><%}%></td>
                    <td>&nbsp;<%if(!e_bean3.getEst_id().equals("")){%><a href='#'>AŸ��</a>&nbsp;&nbsp;<a href='#'>BŸ��</a><%}%></td>
                    <td>&nbsp;<%if(!e_bean4.getEst_id().equals("")){%><a href='#'>AŸ��</a>&nbsp;&nbsp;<a href='#'>BŸ��</a><%}%></td>
                </tr>																																			
            </table>
        </td>
    </tr>	
    <tr> 
        <td colspan="2"><font color="#666666">* AŸ�� : �������� �ٸ��������� ����</font> </td>
    </tr>		
    <tr> 
        <td colspan="2"><font color="#666666">* BŸ�� : ������������ �������� ����</font> </td>
    </tr>		
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align=center colspan="2"> 
            <a href='#'>[��������Ʈ�ϱ�]</a>&nbsp;&nbsp;&nbsp;
            <a href='#'>[���ø��Ϲ߼��ϱ�]</a>&nbsp;&nbsp;&nbsp;
			<a href='#'>[���ں�����]</a>&nbsp;&nbsp;&nbsp;
			<a href='#'>[���ϰ� �ٸ� �����ϱ�]</a>
        </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>