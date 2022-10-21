<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String tax_no 	= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	long item_s_amt = 0;
	long item_v_amt = 0;
	int height = 0;
	String reg_code = "";
	
	
	//���ݰ�꼭 ��ȸ
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
//	Hashtable t_ht 			= IssueDb.getTaxHt(tax_no);
	//�ŷ����� ��ȸ
	TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(t_bean.getItem_id());
	//�ŷ����� ����Ʈ ��ȸ
	Vector tils	            = IssueDb.getTaxItemListCase(t_bean.getItem_id());
	int til_size            = tils.size();
	//������
	Hashtable br            = c_db.getBranch(t_bean.getBranch_g().trim());
	//�ŷ�ó����
	ClientBean client       = al_db.getClient(t_bean.getClient_id().trim());
	
	//�ŷ�ó��������
	ClientSiteBean site     = al_db.getClientSite(t_bean.getClient_id(), t_bean.getSeq());
	//�׿��� �ŷ�ó ����
	Hashtable ven           = neoe_db.getVendorCase(client.getVen_code());
	//����� �������
	LongRentBean bean       = ScdMngDb.getScdMngLongRentInfo("", t_bean.getRent_l_cd().trim());
	if(til_size > 1){
	  TaxItemListBean til = (TaxItemListBean)tils.elementAt(0);
	  bean  = ScdMngDb.getScdMngLongRentInfo("", til.getRent_l_cd());
	  reg_code = til.getReg_code();
	}
	 
	
	Vector branches = c_db.getBranchs(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();
	
	String tax_supply 	= String.valueOf(t_bean.getTax_supply());
	String tax_value 	= String.valueOf(t_bean.getTax_value());
	String i_enp_no 	= client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	String i_ssn 		= client.getSsn1() +"-"+ client.getSsn2();
	if(client.getEnp_no1().equals("")) i_enp_no = "000-00-00000";
	String i_firm_nm 	= client.getFirm_nm();
	String i_client_nm 	= client.getClient_nm();
	String i_addr 		= client.getO_addr();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	String i_ven_code	= client.getVen_code();
	
	if(t_bean.getGubun().equals("18")){
		i_enp_no 	= t_bean.getRecCoRegNo		();
		i_firm_nm 	= t_bean.getRecCoName		();
		i_client_nm 	= t_bean.getRecCoCeo		();
		i_addr 		= t_bean.getRecCoAddr		();
		i_sta 		= t_bean.getRecCoBizType	();
		i_item 		= t_bean.getRecCoBizSub		();
		if(i_enp_no.equals("") && t_bean.getReccoregnotype().equals("02")){
	  		i_enp_no = t_bean.getRecCoSsn		();
		}	
		i_ven_code		= t_bean.getVen_code();
	}else{	
		if(t_bean.getTax_type().equals("2") && !site.getClient_id().equals("")){
		  	i_enp_no 		= site.getEnp_no();
	  		i_firm_nm 		= site.getR_site();
		  	i_client_nm 	= site.getSite_jang();
		  	i_addr 			= site.getAddr();
	  		i_sta 			= site.getBus_cdt();
		  	i_item 			= site.getBus_itm();
		  	i_ven_code		= site.getVen_code();
		}
	
		if(t_bean.getReccoregnotype().equals("03")){
			i_enp_no 		= "9999999999999";
		}
	
		if(t_bean.getRecCoName().equals("")){
			t_bean.setRecCoRegNo	(i_enp_no);
			t_bean.setRecCoName		(i_firm_nm);
			t_bean.setRecCoCeo		(i_client_nm);
			t_bean.setRecCoAddr		(i_addr);
			t_bean.setRecCoBizType	(i_sta);
			t_bean.setRecCoBizSub	(i_item);
			t_bean.setRecTel		(t_bean.getCon_agnt_m_tel());
			t_bean.setVen_code		(i_ven_code);
		}
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//��ϰ���
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "tax_mng_frame.jsp";
		fm.submit();
	}
	
	//�� ����
	function view_client()
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/tax/tax_mng/tax_mng_u_m.jsp&client_id=<%=t_bean.getClient_id()%>", "CLIENT", "left=10, top=10, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	
	//��������ϱ�	
	function tax_update(){
		var fm = document.form1;
		
		if(fm.doctype[0].checked == false && fm.doctype[1].checked == false && fm.doctype[2].checked == false && fm.doctype[3].checked == false && fm.doctype[4].checked == false){
			alert("�����ڵ��� �����Ͻʽÿ�.");
			return;
		}
		if(fm.doctype_01_dt.value == '' && fm.doctype_02_dt.value == '' && fm.doctype_03_dt.value == '' && fm.doctype_04_dt.value == '' && fm.doctype_06_dt.value == ''){
			alert("������꼭 �ۼ����ڸ� �Է��Ͻʽÿ�.");
			return;
		}	
		
		if(fm.doctype[2].checked == true || fm.doctype[3].checked == true){
			if(<%=t_bean.getTax_supply()%> < 0){
				alert("(-)�ݾ��� ��� ȯ�� Ȥ�� ����� ������ �Ҽ� �����ϴ�.");	
				return;
			}
		}
				
		
		//�����������
		if(fm.doctype[0].checked == true){		
		
			if(fm.o_br_id[1].value == '')	{ alert("������ ���࿵���Ҹ� �Է��Ͻʽÿ�."); 	return;}
			if(fm.tax_dt[1].value == '')	{ alert("������ �������ڸ� �Է��Ͻʽÿ�."); 	return;}
			if(fm.tax_supply[1].value == '' || fm.tax_supply[1].value == '0')	{ alert("������ ���ް��� �Է��Ͻʽÿ�."); 	return;}
			if(fm.tax_value[1].value == '' || fm.tax_value[1].value == '0')		{ alert("������ �ΰ����� �Է��Ͻʽÿ�."); 	return;}
			if(fm.tax_g[1].value == '')	{ alert("������ ǰ���� �Է��Ͻʽÿ�."); 		return;}
//			if(fm.tax_bigo[1].value == '')	{ alert("������ ��� �Է��Ͻʽÿ�."); 		return;}

		
			var reccoregnotype = '';

			if(fm.reccoregnotype[0].checked == true) reccoregnotype='����ڵ�Ϲ�ȣ';
			if(fm.reccoregnotype[1].checked == true) reccoregnotype='�ֹε�Ϲ�ȣ';
			if(fm.reccoregnotype[2].checked == true) reccoregnotype='�ܱ��ι�ȣ';				
			
			if(reccoregnotype != ''){
				if(!confirm('����ڱ����� '+reccoregnotype+'�� �½��ϱ�?')) return;
			}			
		}		
		
		<%if(!ti_bean.getItem_id().equals("")){%>
		if(fm.tax_supply[1].value != fm.t_item_supply.value)	{ alert("���ݰ�꼭 ���ް��� �ŷ����� ���ް� �հ谡 Ʋ���ϴ�. Ȯ���Ͻʽÿ�."); 	return;}
		if(fm.tax_value[1].value != fm.t_item_value.value)		{ alert("���ݰ�꼭 �ΰ����� �ŷ����� �ΰ��� �հ谡 Ʋ���ϴ�. Ȯ���Ͻʽÿ�."); 	return;}

		fm.item_hap_num.value = parseDigit(fm.t_item_amt.value);
		<%}%>
		
		if(confirm('�������ݰ�꼭�� �߱��Ͻðڽ��ϱ�?')){
		if(confirm('������ �������ݰ�꼭�� �߱��Ͻðڽ��ϱ�?\n\n���⼭ Ȯ���� �����ϸ� ���̻� ����� �ʰ� �ٷ� �߱޵˴ϴ�. ')){
			fm.action = 'tax_mng_u_eu_a.jsp';
//			fm.target = 'i_no';
			fm.target = 'd_content';
			fm.submit();
		}}
	}
	
	
	//�ŷ����� �ݾ׼���
	function set_amt(idx){
		
		var fm = document.form1;		
			
		fm.item_value[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) * 0.1 );
		fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
				
		
		fm.t_item_supply.value = 0;
		fm.t_item_value.value = 0;
		fm.t_item_amt.value = 0;	
		
		
		//�ŷ����� �հ� ���
		for(i=0; i<idx+1; i++){			
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));			
		}
			
		fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));				
				
		
		fm.tax_supply[1].value		= fm.t_item_supply.value;
		fm.tax_value[1].value		= fm.t_item_value.value;
		
		
//		fm.tax_supply.value			= fm.t_item_supply.value;
//		fm.tax_value.value			= fm.t_item_value.value;
//		fm.tax_amt.value			= fm.t_item_amt.value;
		
//		set_tax_amt();			
	}	
	
	
	<%if(!ti_bean.getItem_id().equals("")){%>	
	//�ŷ����� ����Ʈ ������
	function item_amt_set(obj, idx){
		var fm = document.form1;
		var size = toInt(fm.item_size.value);
		fm.t_item_supply.value = 0;
		fm.t_item_value.value = 0;		
		if(obj == 's'){
			fm.item_value[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) * 0.1 );
			fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
		}			
		if(obj == 'v'){
			fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
		}
		if(obj == 'a'){
		
		}
			
		//�ŷ����� �հ� ���
		for(i=0; i<size; i++){			
			if(fm.del_chk[i].value != "Y"){
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));			
			}
		}

		fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));
		
		fm.tax_supply[1].value		= fm.t_item_supply.value;
		fm.tax_value[1].value		= fm.t_item_value.value;
		
	}
		
	//�ŷ��������� ����
	function del_chk_set(idx){
		var fm = document.form1;
		var size = toInt(fm.item_size.value);
		//�ŷ����� �հ� ���
		for(i=0; i<size; i++){
			if(i== idx && fm.del_chk[idx].value == "Y"){
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) - toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) - toInt(parseDigit(fm.item_value[i].value)));			
			}else if(i== idx && fm.del_chk[idx].value == "N"){
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));						
			}
		}

		fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));
		
		fm.tax_supply[1].value		= fm.t_item_supply.value;
		fm.tax_value[1].value		= fm.t_item_value.value;		
	}
	<%}%>
	
	//�������м��ý�
	function cng_input()
	{
		var fm = document.form1;		
		if(fm.doctype[0].checked == true){			//�������
			tr_doctype01.style.display 	= '';					
			tr_doctype02.style.display 	= 'none';			
			tr_doctype03.style.display 	= 'none';			
			tr_doctype04.style.display 	= 'none';									
		}else if(fm.doctype[1].checked == true){		//���ް���
			tr_doctype01.style.display 	= '';								
			tr_doctype02.style.display 	= 'none';			
			tr_doctype03.style.display 	= 'none';			
			tr_doctype04.style.display 	= 'none';											
		}else if(fm.doctype[2].checked == true){		//ȯ��
			tr_doctype01.style.display 	= 'none';					
			tr_doctype02.style.display 	= 'none';			
			tr_doctype03.style.display 	= '';			
			tr_doctype04.style.display 	= 'none';											
		}else if(fm.doctype[3].checked == true){		//�������
			tr_doctype01.style.display 	= 'none';					
			tr_doctype02.style.display 	= 'none';			
			tr_doctype03.style.display 	= 'none';			
			tr_doctype04.style.display 	= '';											
		}else if(fm.doctype[4].checked == true){		//���߹߱�
			tr_doctype01.style.display 	= 'none';					
			tr_doctype02.style.display 	= 'none';			
			tr_doctype03.style.display 	= 'none';			
			tr_doctype04.style.display 	= 'none';											
		}
	}	
	
	//�ŷ����� �ݾ׼���
	function set_amt02(st){		
		var fm = document.form1;				
		if(st ==1){	
			fm.tax_value02[1].value 	= parseDecimal(toInt(parseDigit(fm.tax_supply02[1].value)) * 0.1 );
		}					
		fm.tax_tot02[1].value 			= parseDecimal(toInt(parseDigit(fm.tax_supply02[1].value)) + toInt(parseDigit(fm.tax_value02[1].value)));							
		if(fm.tax_supply_st02.value == '-'){
			fm.tax_cha02.value 		= parseDecimal(toInt(parseDigit(fm.tax_tot02[0].value)) - toInt(parseDigit(fm.tax_tot02[1].value)));					
		}else{
			fm.tax_cha02.value 		= parseDecimal(toInt(parseDigit(fm.tax_tot02[0].value)) + toInt(parseDigit(fm.tax_tot02[1].value)));					
		}		
	}	
	//�ŷ����� �ݾ׼���
	function set_amt03(st){	
		var fm = document.form1;		
		if(st ==1){	
			fm.tax_value03[1].value 	= parseDecimal(toInt(parseDigit(fm.tax_supply03[1].value)) * 0.1 );
		}					
		fm.tax_tot03[1].value 			= parseDecimal(toInt(parseDigit(fm.tax_supply03[1].value)) + toInt(parseDigit(fm.tax_value03[1].value)));							
		fm.tax_cha03.value 			= parseDecimal(toInt(parseDigit(fm.tax_tot03[0].value)) - toInt(parseDigit(fm.tax_tot03[1].value)));					
	}	
	
	//�� ��ȸ
	function search_client()
	{
		var fm = document.form1;
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=850,height=600,left=50,top=50');		
		fm.action = "/tax/pop_search/s_tax_client.jsp";		
		fm.target = "search_open";
		fm.submit();				
	}	
	
	function item_search(item_seq){
		var fm = document.form1;
		var t_wd = '<%=client.getFirm_nm()%>';
		window.open("/tax/issue_1_tax/tax_item_list_search.jsp?client_id="+fm.client_id.value+"&seq="+fm.site_id.value+"&idx="+item_seq+"&t_wd="+t_wd, "ITEM_LIST", "left=50, top=50, width=1150, height=550, scrollbars=yes");		
	}				
//-->
</script>
</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="tax_no" value="<%=tax_no%>">
  <input type="hidden" name="item_id" value="<%=t_bean.getItem_id()%>">  
  <input type="hidden" name="item_size" value="<%=til_size%>">
  <input type="hidden" name="item_hap_num" value="">
  <input type="hidden" name="reg_code" value="<%=reg_code%>">
  <input type="hidden" name="rent_l_cd" value="<%//=t_bean.getRent_l_cd()%>">    
  <input type="hidden" name="client_id" value="<%//=t_bean.getClient_id()%>">
  <input type="hidden" name="site_id" value="<%//=t_bean.getSeq()%>">          
<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ�꼭���� > ���ݰ�꼭������ ><span class=style5>
						�������ݰ�꼭 �߱�</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	
    <tr> 
        <td align="right"><a href="javascript:go_list();"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;
	    <a href="javascript:history.go(-1);"><img src="/acar/images/center/button_back_p.gif" align="absmiddle" border="0"></a></td>	  
    </tr>
    <%if(t_bean.getGubun().equals("18")){%>
    <%}else{%>    
    <tr>
		<td class=line2 colspan=2></td>
	</tr>  
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                  <td width='10%' class='title'>��ȣ</td>
                  <td colspan="3">&nbsp;
					<a href="javascript:view_client()"><%=bean.getFirm_nm()%></a>
					&nbsp;</td>
                  <td class='title'>����/����</td>
                  <td colspan="3" >&nbsp;<span title='<%=site.getR_site()%>'><%=Util.subData(site.getR_site(), 25)%></span></td>
                </tr>
                <tr>
                  <td class='title'>���౸��</td>
                  <td width="15%">&nbsp;<%=bean.getPrint_st()%></td>
                  <td width="10%" class='title'>���࿵����</td>
                  <td>&nbsp;<%=bean.getBr_nm()%></td>
                  <td width='10%' class='title'>���޹޴���</td>
                  <td width='15%' >&nbsp;<%=bean.getTax_type()%></td>
                  <td width="10%" class='title'>�׿���</td>
                  <td width="15%">&nbsp;
                      <% if(!client.getVen_code().equals("")){%>
              (<%=client.getVen_code()%>)<span title='<%=ven.get("VEN_NAME")%>'><%=Util.subData(String.valueOf(ven.get("VEN_NAME")), 4)%>
              <% }%>
                </span></td>
                </tr>
                <tr>
                  <td class='title'>�����ּ�</td>
                  <td colspan="3">&nbsp;(<%=bean.getP_zip()%>) <span title='<%=bean.getP_addr()%>'><%=Util.subData(bean.getP_addr(), 25)%></span></td>
                  <td class='title'>����������</td>
                  <td colspan="3" >&nbsp;<%=bean.getTax_agnt()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
		<td class=line2 colspan=2></td>
	</tr>  
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='15%' class='title'>�����ڵ�</td>
                    <td width='25%' class='title'>�ۼ�����</td>
                    <td width='60%' class='title'>���λ��� �� ���</td>
                </tr>
                <tr>
                    <td>
					  <input type="radio" name="doctype" value="01" checked onClick="javascript:cng_input()">��������� ����.����
					</td>
                    <td>&nbsp;					  
					  <input name="doctype_01_dt" type="text" class="taxtext" value="" size="11" onBlur='javscript:this.value = ChangeDate(this.value);'>
					  ����,���������� �ν��� ��
					</td>
                    <td>&nbsp;�ʿ��� ������� ���� ������ �߸� ����� ���(2�� ����)<br>
                                    &nbsp;-���������� �����Ͽ� �����ϱ� ������ ���ݰ�꼭�� �ۼ��ϵ�, ���ʿ� ������ ���ݰ�꼭 ������ �ϵ� ��(-)�Ǽ��ݰ�꼭�� �����ϰ�, �����Ͽ� �����ϴ� ���ݰ�꼭�� ��(+)�� ���ݰ�꼭 �ۼ�<br>
					       &nbsp;* �ʿ��� ������� :  �������� ��� ������ ����ڹ�ȣ/��ȣ/��ǥ�ڸ�, ���޹޴����� ��� ���޹޴��� ����� ��ȣ, �ۼ������/���ް���/���� �Դϴ�. �� �ܴ� ��� ������ ������׵��Դϴ�.<br>
						   &nbsp;* ������� ���� ���� ���� �� �ۼ��������� �߸� ������ ��찡 �ƴ� ��, ��(+)/��(-)�� ���ݰ�꼭�� �ۼ��������� ���� �ۼ��� ���ݰ�꼭�� �ۼ����̴�.
					</td>					
                </tr>
                <tr>
                    <td>
					  <input type="radio" name="doctype" value="02" onClick="javascript:cng_input()">���ް��׺���
					</td>
                    <td>&nbsp;								  
					  <input name="doctype_02_dt" type="text" class="taxtext" value="" size="11" onBlur='javscript:this.value = ChangeDate(this.value);'>
					  ���������߻���
					</td>					
					<td>&nbsp;���ް��׿� �߰� �Ǵ� �����Ǵ� �ݾ��� �߻��� ���(1�� ����)<br>
                                    &nbsp;- ���������� �߻��� ���� �ۼ����ڷ� �����ϰ�, �߰��Ǵ� �ݾ��� ��(+)�� ���ݰ�꼭�� �����ϰ�, �����Ǵ� �ݾ��� ��(-)�� ǥ�÷� �ۼ��Ͽ� ����</td>					
                </tr>				
                <tr>
                    <td>
					  <input type="radio" name="doctype" value="03" onClick="javascript:cng_input()">ȯ��
					</td>
					<td>&nbsp;								  
					  <input name="doctype_03_dt" type="text" class="taxtext" value="" size="11" onBlur='javscript:this.value = ChangeDate(this.value);'>
					  ȯ�Եȳ�
					</td>	
					<td>&nbsp;���� ������ ��ȭ�� ȯ�Ե� ���(1�� ����)<br>
                                    &nbsp;- ��ȭ�� ȯ�Ե� ���� �ۼ����ڷ� �����ϰ�, ������ ���� ���ݰ�꼭 �ۼ����ڸ� �α��� �� ���� ǥ�ø� �Ͽ� ����</td>					
                </tr>				
                <tr>
                    <td>
					  <input type="radio" name="doctype" value="04" onClick="javascript:cng_input()">����� ����
					</td>
					<td>&nbsp;								  
					  <input name="doctype_04_dt" type="text" class="taxtext" value="" size="11" onBlur='javscript:this.value = ChangeDate(this.value);'>
					  ���������
					</td>
					<td>&nbsp;����� ������ ���Ͽ� ��ȭ �Ǵ� �뿪�� ���޵��� �ƴ��� ���(1�� ����)<br>
                                            &nbsp;- <!--����� ������ ���� �� �ۼ����ڴ� ���� ���ݰ�꼭 �ۼ����ڸ� �����ϰ� ������ ����������� �α��� �� ���� ǥ�ø� �Ͽ� ����-->
                                            ����� ������ ���� �� �ۼ����ڴ� ����������� �����ϰ� ������ ���� ���ݰ�꼭 �ۼ����ڸ� �α��� �� ���� ǥ�ø� �Ͽ� ����
                                            <br>
                                            &nbsp;(2012-07-01 �ۼ�������-�������ڷ� ����)
					</td>					
                </tr>				
                <tr>
                    <td>
					  <input type="radio" name="doctype" value="06" onClick="javascript:cng_input()">������ ���� ���߹߱�
					</td>
					<td>&nbsp;								  
					  <input name="doctype_06_dt" type="text" class="taxtext" value="" size="11" onBlur='javscript:this.value = ChangeDate(this.value);'>
					  ����,���������� �ν��� ��
					</td>
					<td>&nbsp;������ �������� �߱��� ���(1�� ����)<br> 
                                    &nbsp;- �ۼ����ڴ� ���� ���ݰ�꼭 �ۼ����ڸ� �����ϰ� ���ʿ� �߱��� ���ݰ�꼭�� ������ ��(-)�� ǥ�ø� �Ͽ� �߱�
					</td>					
                </tr>				
            </table>
        </td>
    </tr>	
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr id=tr_doctype01 style="display:''">
        <td colspan="2">
		  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭</span></td>
			</tr>
		    <tr>
			  <td class=line2></td>
			</tr>
		    <tr>
			  <td class="line">
                <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                    <tr>
                        <td width='10%' class='title'>�Ϸù�ȣ</td>
                        <td width="90%" colspan="2">&nbsp;<span class="ledger_cont"><%=tax_no%></span></td>
                    </tr>
                    <tr>
                        <td class='title'>����</td>
                        <td width="45%" class='title'>������</td>
                        <td width="45%" class='title'>������</td>
                    </tr>
                    <tr>
                        <td class='title'>������<span class="ledger_contC">(�������)</span> </td>
                        <td align="center"><span class="ledger_contC">
            			    <input type="hidden" name="o_br_id" value="<%=t_bean.getBranch_g()%>">
            			    <select name='o_br_id_cd' disabled>
            		          <option value=''>����</option>
                      			<%	if(brch_size > 0){
        		    					for (int i = 0 ; i < brch_size ; i++){
        			    					Hashtable branch = (Hashtable)branches.elementAt(i);%>
            			      <option value='<%=branch.get("BR_ID")%>'  <%if(t_bean.getBranch_g().equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                      			<%		}
            						}%>
        	    	        </select>			  
                        </span></td>
                      <td align="center"><span class="ledger_contC">
            			    <select name='o_br_id'>
            		          <option value=''>����</option>
                      			<%	if(brch_size > 0){
        		    					for (int i = 0 ; i < brch_size ; i++){
        			    					Hashtable branch = (Hashtable)branches.elementAt(i);%>
        			          <option value='<%=branch.get("BR_ID")%>'  <%if(t_bean.getBranch_g().equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                      			<%		}
            						}%>
       	    	          </select>	
        	    		    </span></td>
                    </tr>
                    <tr>
                      <td class='title'>���޹޴���</td>
                      <td align="center">
					    <table width="90%"  border="1">
                          <tr align="center">
                            <td colspan="2"><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="reccoregno" size="30" value="<%=t_bean.getRecCoRegNo()%>" class="whitetext" readonly>
							  &nbsp;
							  (������ڹ�ȣ : <input type="text" name="reccotaxregno" size="4" value="<%=t_bean.getRecCoTaxRegNo()%>" class="whitetext" readonly>)
                            </span></span></td>
                          </tr>
                          <tr align="center">
                            <td colspan="2"><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="reccossn" size="30" value="<%=t_bean.getRecCoSsn()%>" class="whitetext" readonly>
                            </span></span></td>
                          </tr>
                          <tr align="center">
                            <td><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="recconame" size="20" value="<%=t_bean.getRecCoName()%>" class="whitetext" readonly>
                            </span></span></td>
                            <td><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="reccoceo" size="20" value="<%=t_bean.getRecCoCeo()%>" class="whitetext" readonly>
                            </span></span></td>
                          </tr>
                          <tr align="center">
                            <td colspan="2"><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="reccoaddr" size="55" value="<%=t_bean.getRecCoAddr()%>" class="whitetext" readonly>
                            </span></span></td>
                            </tr>
                          <tr align="center">
                            <td><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="reccobiztype" size="20" value="<%=t_bean.getRecCoBizType()%>" class="whitetext" readonly>
                            </span></span></td>
                            <td><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="reccobizsub" size="20" value="<%=t_bean.getRecCoBizSub()%>" class="whitetext" readonly>
                            </span></span></td>
                          </tr>
                          <tr align="center">
                            <td><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="con_agnt_nm" size="20" value="<%=t_bean.getCon_agnt_nm()%>" class="whitetext" readonly>
                            </span></span></td>
                            <td><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="rectel" size="20" value="<%=t_bean.getRecTel()%>" class="whitetext" readonly>
                            </span></span></td>
                          </tr>
                        </table>
					  </td>
                      <td align="center">
					    <table width="90%"  border="1">
                          <tr align="center">
                            <td colspan="2"><span class="ledger_contC">
                              <input name="reccoregno" type="text" class="taxtext" value="<%=i_enp_no%>" size="30" >
							  &nbsp;
							  (������ڹ�ȣ : <input type="text" name="reccotaxregno" size="4" value="<%=t_bean.getRecCoTaxRegNo()%>" class="taxtext">)
							  <!--����ȸ-->
							  <%//if(til_size==1){%>
							  &nbsp;&nbsp;<span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
							  <%//}%>
                            </span></td>
                          </tr>
                          <tr align="center">
                            <td colspan="2"><span class="ledger_cont"><span class="ledger_contC">
                              <input type="text" name="reccossn" size="30" value="<%=i_ssn%>" size="40" >
                            </span></span></td>
                          </tr>					
                          <tr align="center">
                            <td><span class="ledger_contC">
                              <input name="recconame" type="text" class="taxtext" value="<%=i_firm_nm%>" size="20" >
                            </span></td>
                            <td><span class="ledger_contC">
                              <input name="reccoceo" type="text" class="taxtext" value="<%=i_client_nm%>" size="20" >
                            </span></td>
                          </tr>
                          <tr align="center">
                            <td colspan="2"><span class="ledger_contC">
                                <input name="reccoaddr" type="text" class="taxtext" value="<%=i_addr%>" size="55" >
                            </span></td>
                          </tr>
                          <tr align="center">
                            <td><span class="ledger_contC">
                              <input name="reccobiztype" type="text" class="taxtext" value="<%=i_sta%>" size="20" >
                            </span></td>
                            <td><span class="ledger_contC">
                              <input name="reccobizsub" type="text" class="taxtext" value="<%=i_item%>" size="20" >
                            </span></td>
                          </tr>
                          <tr align="center">
                            <td><span class="ledger_contC">
                            <span class="ledger_cont">
                              <input type="text" name="con_agnt_nm" size="20" value="<%=t_bean.getCon_agnt_nm()%>" class="taxtext" >
                            </span>                      </span></td>
                            <td><span class="ledger_contC">
                            <span class="ledger_cont">
                              <input type="text" name="rectel" size="20" value="<%=t_bean.getRecTel()%>" class="taxtext" >
                            </span>                      </span></td>
                          </tr>
                        </table>
					  </td>
                    </tr>
                    <tr>
                        <td class='title'>��������</td>
                        <td align="center"><span class="ledger_contC">
                        <input name="tax_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(t_bean.getTax_dt())%>" size="40" readonly>
                        </span></td>
                        <td align="center"><span class="ledger_contC">
                        <input name="tax_dt" type="text" class="taxtext" value="<%=AddUtil.ChangeDate2(t_bean.getTax_dt())%>" size="40" onBlur='javscript:this.value = ChangeDate(this.value);'>
                        </span></td>
                    </tr>
                    <tr>
                        <td class='title'>���ް�</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_supply" size="38" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="whitetext" readonly>��
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_supply" size="38" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="taxtext" onBlur='javascript:this.value=parseDecimal(this.value)'>��
                        </span></span></td>
                    </tr>
                    <tr>
                        <td class='title'>�ΰ���</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_value" size="38" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="whitetext" readonly>��
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_value" size="38" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="taxtext" onBlur='javascript:this.value=parseDecimal(this.value)'>��
                        </span></span></td>
                    </tr>
                    <tr>
                        <td class='title'>ǰ��</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
						<%if(AddUtil.parseInt(t_bean.getReg_dt()) >= 20100929 && t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("")){%>
					  	<%=t_bean.getFee_tm()%>ȸ��
					  	<%}%>															
                          <input type="text" name="tax_g" size="40" value="<%=t_bean.getTax_g()%>" class="whitetext" readonly>
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
						<%if(AddUtil.parseInt(t_bean.getReg_dt()) >= 20100929 && t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("")){%>
					  	<%=t_bean.getFee_tm()%>ȸ��
					  	<%}%>									
                          <input type="text" name="tax_g" size="40" value="<%=t_bean.getTax_g()%>" class="taxtext">
                        </span></span></td>
                    </tr>
                    <tr>
                        <td class='title'>���</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_bigo" size="40" value="<%=t_bean.getTax_bigo()%>" class="taxtext">
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_bigo" size="40" value="<%=t_bean.getTax_bigo()%>" class="taxtext">
                        </span></span></td>
                    </tr>
                    <tr>
                        <td class='title'>�׿����ŷ�ó�ڵ�</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="ven_code" size="40" value="<%=t_bean.getVen_code()%>" class="whitetext" readonly>
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="ven_code" size="40" value="<%=i_ven_code%>" class="taxtext">
                        </span></span></td>
                    </tr>                    
                <tr>
                    <td class='title'>����ڱ���</td>
                    <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                     <%if(t_bean.getReccoregnotype().equals("01")){%>����ڵ�Ϲ�ȣ
                     <%}else if(t_bean.getReccoregnotype().equals("02")){%>�ֹε�Ϲ�ȣ
					 <%}else if(t_bean.getReccoregnotype().equals("03")){%>�ܱ��ι�ȣ
					 <%}%>                                          
                    </span></span></td>
                    <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                      <input type="radio" name="reccoregnotype" value="01" <%if(t_bean.getReccoregnotype().equals("01")||t_bean.getPubForm().equals("")){%>checked<%}%>>����ڵ�Ϲ�ȣ
                      <input type="radio" name="reccoregnotype" value="02" <%if(t_bean.getReccoregnotype().equals("02")){%>checked<%}%>>�ֹε�Ϲ�ȣ 
					  <input type="radio" name="reccoregnotype" value="03" <%if(t_bean.getReccoregnotype().equals("03")){%>checked<%}%>>�ܱ��ι�ȣ 
                    </span></span></td>
                </tr>											
                <tr>
                    <td class='title'>������</td>
                    <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                     <%if(t_bean.getPubForm().equals("R")){%>����                               
					 <%}else{%>û��
					 <%}%>                                          
                    </span></span></td>
                    <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                      <input type="radio" name="pubform" value="R" <%if(t_bean.getPubForm().equals("R")){%>checked<%}%>>����
                      <input type="radio" name="pubform" value="D" <%if(t_bean.getPubForm().equals("D")||t_bean.getPubForm().equals("")){%>checked<%}%>>û�� 
                    </span></span></td>
                </tr>								
                </table>			  
			  </td>
			</tr>
			<%if(!t_bean.getGubun().equals("18")){%>
		    <tr>
			  <td><font color="red">* ��ȣ�� Ŭ���ϸ� ������ ���γ����� Ȯ���Ҽ� �ֽ��ϴ�. (���󼼳���,����ڵ����,��������..)</font></td>
			</tr>			
			<%}%>
    		<tr>
      			<td><font color="red">* ����ڱ����� �ܱ����� ��� ��� �ֹι�ȣ�� �Է��Ͻʽÿ�.</font></td>
    		</tr>  			
			<!--
		    <tr>
			  <td><font color="red">* �����ڰ� �������(����)�� ��� ��� �������� �Է��ؾ� �մϴ�. </font></td>
			</tr>			
			-->
			<%if(!ti_bean.getItem_id().equals("")){%>
		    <tr>
			  <td>&nbsp;</td>
			</tr>			
		    <tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ŷ�����</span></td>
			</tr>			
		    <tr>
			  <td class=line2></td>
			</tr>
		    <tr>
			  <td class="line">
                <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                    <tr>
                      <td width='10%' class='title'>�Ϸù�ȣ</td>
                      <td width="90%" colspan="2">&nbsp;<span class="ledger_cont"><%=ti_bean.getItem_id()%></span></td>
                    </tr>
                    <tr>
                      <td class='title'>����</td>
                      <td width="45%" class='title'>������</td>
                      <td width="45%" class='title'>������</td>
                    </tr>
                    <tr>
                      <td class='title'>�ۼ�����</td>
                      <td align="center"><span class="ledger_contC">
                        <input name="item_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(ti_bean.getItem_dt())%>" size="40" readonly>
                      </span></td>
                      <td align="center"><span class="ledger_contC">
                        <input name="item_dt" type="text" class="taxtext" value="<%=AddUtil.ChangeDate2(ti_bean.getItem_dt())%>" size="40" onBlur='javscript:this.value = ChangeDate(this.value);'>
                      </span></td>
                    </tr>
                </table>			  
			  </td>
			</tr> 
		    <tr>
			  <td class="line">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="center" bgcolor="#CCCCCC">
                      <td rowspan="2" width="5%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                      <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">�ŷ�����</td>
                      <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">������ȣ</td>
                      <td width="18%" rowspan="2" bgcolor="#CCCCCC" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                      <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">û��(�ŷ�)������</td>
                      <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">���ް���</td>
                      <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                      <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid;">�հ�</td>
                      <td rowspan="2" width="7%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">����</td>
                    </tr>
                    <tr>
                      <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~����</td>
                      <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~����</td>
                    </tr>
                <% for(int i = 0 ; i < til_size ; i++){
        			    TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);%>
            		<input type='hidden' name="item_seq" value="<%=til_bean.getItem_seq()%>">											
                    <tr align="center">
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=i+1%></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_g" size="10" value="<%=til_bean.getItem_g()%>" class="taxtext"></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_car_no" size="13" value="<%=til_bean.getItem_car_no()%>" class="taxtext"></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_car_nm" size="20" value="<%=til_bean.getItem_car_nm()%>" class="taxtext"></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_dt1" size="11" value="<%=AddUtil.ChangeDate2(til_bean.getItem_dt1())%>" class="taxtext" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_dt2" size="11" value="<%=AddUtil.ChangeDate2(til_bean.getItem_dt2())%>" class="taxtext" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_supply" size="10" value="<%=Util.parseDecimal(til_bean.getItem_supply())%>" class="taxnum" onBlur="javascript:this.value=parseDecimal(this.value); item_amt_set('s', <%=i%>);"></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_value" size="10" value="<%=Util.parseDecimal(til_bean.getItem_value())%>" class="taxnum" onBlur="javascript:this.value=parseDecimal(this.value); item_amt_set('v', <%=i%>);"></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><input type="text" name="item_amt" size="10" value="<%=Util.parseDecimal(til_bean.getItem_supply()+til_bean.getItem_value())%>" class="taxnum" onBlur="javascript:this.value=parseDecimal(this.value); item_amt_set('a', <%=i%>);"></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">
        	    	  <%if(til_size>1){%>
            			    <select name='del_chk' onchange="javascript:del_chk_set(<%=i%>);">
            		          <option value='N'>����</option>
            		          <option value='Y'>����</option>				  
        	    	        </select>				  
            		  <%}else{%>&nbsp;
            		      <select name='del_chk'>
            		          <option value='N'>����</option>        		        			  
        	    	        </select>   		          		         		  
            		  <%}%></td>
                    </tr>
                    <%  		item_s_amt = item_s_amt  + Long.parseLong(String.valueOf(til_bean.getItem_supply()));
        	    				 item_v_amt = item_v_amt  + Long.parseLong(String.valueOf(til_bean.getItem_value()));
        		     }%>
    			<%for(int i =0; i<3; i++){%>			
    				<input type='hidden' name="item_seq" value="<%=til_size+i+1%>">
	    	        <tr>
		              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=til_size+i+1%><!--<a href="javascript:item_search('<%=til_size%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>--></td>
		              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		                <input type="text" name="item_g" size="12" value="" class="taxtext" onBlur='javascript:document.form1.tax_g.value=this.value;'>
    		          </span></td>
	    	          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		                <input type="text" name="item_car_no" size="12" value="" class="taxtext" onBlur='javascript:document.form1.tax_bigo.value=this.value;'>
		              </span></td>
		              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		                <input type="text" name="item_car_nm" size="25" value="" class="taxtext">
    		          </span></td>
	    	          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		                <input type="text" name="item_dt1" size="10" value="" class="taxtext">
		              </span></td>
		              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
    		            <input type="text" name="item_dt2" size="10" value="" class="taxtext">
	    	          </span></td>
		              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
		                <input type="text" name="item_supply" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(<%=til_size+i%>);'> 
		                </span></td>
    		          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
	    	            <input type="text" name="item_value" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(<%=til_size+i%>);'>
		    			</span></td>
		              <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><span class="ledger_contC">
    		            <input type="text" name="item_amt" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value);'>
	    				</span></td>
		    		  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp; 	
        	    		    <select name='del_chk' >
        		    	      <option value='A'>�߰�</option>         		                		        	  
        		            </select>				  
            		  </td>
	    	        </tr>
		    	<%}%>	        		         	        		 
                    <tr>
                      <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>�հ�
                              <!--(��)-->
                      </b></font></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_supply" size="10" value="<%=Util.parseDecimal(item_s_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_value" size="10" value="<%=Util.parseDecimal(item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><input type="text" name="t_item_amt" size="10" value="<%=Util.parseDecimal(item_s_amt+item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                    </tr>
                </table>	  
			  </td>
			</tr> 
			<%}%>				
		    <tr>
			  <td>&nbsp;</td>
			</tr>				 			
		  </table>
		</td>		
    </tr>	
    <tr id=tr_doctype02 style='display:none'>
        <td colspan="2">
		  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭 ���ް���</span></td>
			</tr>
		    <tr>
			  <td class=line2></td>
			</tr>	
		    <tr>
			  <td class="line">
                <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                    <tr>
                        <td width='20%' class='title'>�Ϸù�ȣ</td>
                        <td width="80%" colspan="4">&nbsp;<span class="ledger_cont"><%=tax_no%></span></td>
                    </tr>
                    <tr>
                        <td width='20%' class='title'>���ʼ��ݰ�꼭�ۼ���</td>
                        <td width="80%" colspan="4">&nbsp;<%=AddUtil.ChangeDate2(t_bean.getTax_dt())%></td>
                    </tr>
                    <tr>
                        <td class='title'>����</td>
                        <td width="25%" class='title'>���ʱݾ�</td>
                        <td width="25%" class='title' colspan='2'>�����ݾ�</td>
                        <td width="30%" class='title'>���</td>						
                    </tr>	
                    <tr>
                        <td class='title'>���ް�</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_supply02" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="whitenum" readonly>��
                        </span></span></td>
						<td align="center" rowspan='3'>
						   <select name='tax_supply_st02' onchange="javascript:set_amt02(1)">
            		          <option value='+'>+</option>				  
							  <option value='-' selected>-</option>				  
        	    	        </select></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">                            	
							<input type="text" name="tax_supply02" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt02(1);'>��
                        </span></span></td>
						<td rowspan='2'>&nbsp;�߰� �Ǵ� �����Ǵ� �ݾ�</td>
                    </tr>
                    <tr>
                        <td class='title'>�ΰ���</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_value02" size="10" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="whitenum" readonly>��
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                            <input type="text" name="tax_value02" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt02(2);'>��
                        </span></span></td>
                    </tr>		
                    <tr>
                        <td class='title'>�հ�</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_tot02" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply()+t_bean.getTax_value())%>" class="whitenum" readonly>��
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">                            						
                          <input type="text" name="tax_tot02" size="10" value="" class="whitenum" onBlur='javascript:this.value=parseDecimal(this.value)'>��
                        </span></span></td>
                        <td>&nbsp;<span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_cha02" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply()+t_bean.getTax_value())%>" class="whitenum" readonly>��
                        </span></span></td>						
                    </tr>										
                </table>	  
			  </td>
			</tr> 				
		  </table>
		</td>		
    </tr>			
    <tr id=tr_doctype03 style='display:none'>
        <td colspan="2">
		  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭 ȯ��</span></td>
			</tr>
		    <tr>
			  <td class=line2></td>
			</tr>	
		    <tr>
			  <td class="line">
                <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                    <tr>
                        <td width='20%' class='title'>�Ϸù�ȣ</td>
                        <td width="80%" colspan="4">&nbsp;<span class="ledger_cont"><%=tax_no%></span></td>
                    </tr>
                    <tr>
                        <td width='20%' class='title'>���ʼ��ݰ�꼭�ۼ���</td>
                        <td width="80%" colspan="4">&nbsp;<%=AddUtil.ChangeDate2(t_bean.getTax_dt())%></td>
                    </tr>
                    <tr>
                        <td width='20%' class='title'>��꼭 ���</td>
                        <td width="80%" colspan="4">&nbsp;<textarea name="tax_bigo03" cols="120" rows="3" class=default style='IME-MODE: active'><%=t_bean.getTax_bigo()%></textarea> 
                        	<br>(���� ��� [<%=t_bean.getTax_dt()%> ���� ���ݰ�꼭 �ۼ�����] �߰��˴ϴ�. 150byte ������ �������ϴ�.)
                        	 </td>
                    </tr>
                    <tr>
                        <td class='title'>����</td>
                        <td width="25%" class='title'>���ʱݾ�</td>
                        <td width="25%" class='title' colspan='2'>�����ݾ�</td>
                        <td width="30%" class='title'>���</td>						
                    </tr>	
                    <tr>
                        <td class='title'>���ް�</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_supply03" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="whitenum" readonly>��
                        </span></span></td>
						<td align="center"rowspan='3'>
						   <select name='tax_supply_st03'>
            		          <option value='-'>-</option>				  
        	    	        </select></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">                            	
							<input type="text" name="tax_supply03" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="whitenum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt03(1);'>��
                        </span></span></td>
						<td rowspan='2'>&nbsp;��ȭȯ�Ժ� �ݾ�</td>
                    </tr>
                    <tr>
                        <td class='title'>�ΰ���</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_value03" size="10" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="whitenum" readonly>��
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                            <input type="text" name="tax_value03" size="10" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="whitenum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt03(2);'>��
                        </span></span></td>
                    </tr>		
                    <tr>
                        <td class='title'>�հ�</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_tot03" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply()+t_bean.getTax_value())%>" class="whitenum" readonly>��
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">                            						
                          <input type="text" name="tax_tot03" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply()+t_bean.getTax_value())%>" class="whitenum" onBlur='javascript:this.value=parseDecimal(this.value)'>��
                        </span></span></td>
                        <td>&nbsp;<span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_cha03" size="10" value="0" class="whitenum" readonly>��
                        </span></span></td>						
                    </tr>									
                </table>	  
			  </td>
			</tr> 									
		  </table>
		</td>		
    </tr>			
    <tr id=tr_doctype04 style='display:none'>
        <td colspan="2">
		  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭 �������</span></td>
			</tr>
		    <tr>
			  <td class=line2></td>
			</tr>	
		    <tr>
			  <td class="line">
                <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                    <tr>
                        <td width='20%' class='title'>�Ϸù�ȣ</td>
                        <td width="80%" colspan="4">&nbsp;<span class="ledger_cont"><%=tax_no%></span></td>
                    </tr>
                    <tr>
                        <td width='20%' class='title'>���ʼ��ݰ�꼭�ۼ���</td>
                        <td width="80%" colspan="4">&nbsp;<%=AddUtil.ChangeDate2(t_bean.getTax_dt())%></td>
                    </tr>
                    <tr>
                        <td class='title'>����</td>
                        <td width="25%" class='title'>���ʱݾ�</td>
                        <td width="25%" class='title' colspan='2'>�����ݾ�</td>
                        <td width="30%" class='title'>���</td>						
                    </tr>	
                    <tr>
                        <td class='title'>���ް�</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_supply04" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="whitenum" readonly>��
                        </span></span></td>
						<td align="center" rowspan='3'>
						  <select name='tax_supply_st04'>
            		          <option value='-'>-</option>				  
        	    	        </select>	</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">                          
							<input type="text" name="tax_supply04" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="whitenum" onBlur='javascript:this.value=parseDecimal(this.value)' readonly>��
                        </span></span></td>
						<td rowspan='2'>&nbsp;���ʼ��ݰ�꼭 �ݾ�</td>
                    </tr>
                    <tr>
                        <td class='title'>�ΰ���</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_value04" size="10" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="whitenum" readonly>��
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_value04" size="10" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="whitenum" onBlur='javascript:this.value=parseDecimal(this.value)' readonly>��
                        </span></span></td>
                    </tr>	
                    <tr>
                        <td class='title'>�հ�</td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_tot04" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply()+t_bean.getTax_value())%>" class="whitenum" readonly>��
                        </span></span></td>
                        <td align="center"><span class="ledger_cont"><span class="ledger_contC">                            						
                          <input type="text" name="tax_tot04" size="10" value="<%=Util.parseDecimal(t_bean.getTax_supply()+t_bean.getTax_value())%>" class="whitenum" onBlur='javascript:this.value=parseDecimal(this.value)'>��
                        </span></span></td>
                        <td>&nbsp;<span class="ledger_cont"><span class="ledger_contC">
                          <input type="text" name="tax_cha04" size="10" value="0" class="whitenum" readonly>��
                        </span></span></td>						
                    </tr>												
                </table>	  
			  </td>
			</tr> 							
		  </table>
		</td>		
    </tr>						
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2" align="right"><a href="javascript:tax_update();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>
</table>
<script language="JavaScript">
<!--
//-->
</script>  
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>