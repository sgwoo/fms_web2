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
	}
	Vector branches = c_db.getBranchs(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();
	
	String tax_supply = String.valueOf(t_bean.getTax_supply());
	String tax_value = String.valueOf(t_bean.getTax_value());
	String i_enp_no = client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +"-"+ client.getSsn2();
	String i_firm_nm = client.getFirm_nm();
	String i_client_nm = client.getClient_nm();
	String i_addr = client.getO_addr();
	String i_sta = client.getBus_cdt();
	String i_item = client.getBus_itm();
	
	if(t_bean.getTax_type().equals("2") && !site.getClient_id().equals("")){
	  i_enp_no = site.getEnp_no();
	  i_firm_nm = site.getR_site();
	  i_client_nm = site.getSite_jang();
	  i_addr = site.getAddr();
	  i_sta = site.getBus_cdt();
	  i_item = site.getBus_itm();
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
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
	
	
	//��������ϱ�	
	function tax_update(){
		var fm = document.form1;
		if(fm.o_br_id[1].value == '')	{ alert("������ ���࿵���Ҹ� �Է��Ͻʽÿ�."); 	return;}
		if(fm.tax_dt[1].value == '')	{ alert("������ �������ڸ� �Է��Ͻʽÿ�."); 	return;}
		if(fm.tax_supply[1].value == '' || fm.tax_supply[1].value == '0')	{ alert("������ ���ް��� �Է��Ͻʽÿ�."); 	return;}
		if(fm.tax_value[1].value == '' || fm.tax_value[1].value == '0')		{ alert("������ �ΰ����� �Է��Ͻʽÿ�."); 	return;}
		if(fm.tax_g[1].value == '')		{ alert("������ ǰ���� �Է��Ͻʽÿ�."); 		return;}
		if(fm.tax_bigo[1].value == '')	{ alert("������ ��� �Է��Ͻʽÿ�."); 		return;}
		
		<%if(!ti_bean.getItem_id().equals("")){%>
		if(fm.tax_supply[1].value != fm.t_item_supply.value)	{ alert("���ݰ�꼭 ���ް��� �ŷ����� ���ް� �հ谡 Ʋ���ϴ�. Ȯ���Ͻʽÿ�."); 	return;}
		if(fm.tax_value[1].value != fm.t_item_value.value)		{ alert("���ݰ�꼭 �ΰ����� �ŷ����� �ΰ��� �հ谡 Ʋ���ϴ�. Ȯ���Ͻʽÿ�."); 	return;}

		fm.item_hap_num.value = parseDigit(fm.t_item_amt.value);
		<%}%>
		
		if(confirm('���� �Ͻðڽ��ϱ�?')){
			fm.action = 'tax_mng_u_m_a.jsp';
//			fm.target = 'i_no';
			fm.submit();
		}
	}
	
	<%if(!ti_bean.getItem_id().equals("")){%>	
	//�ŷ����� ����Ʈ ������
	function item_amt_set(obj, idx){
		var fm = document.form1;
		var size = toInt(fm.item_size.value);
		if(size == 1){//1��
			if(obj == 's'){
				fm.item_value.value 	= parseDecimal(toInt(parseDigit(fm.item_supply.value)) * 0.1 );
				fm.item_amt.value 		= parseDecimal(toInt(parseDigit(fm.item_supply.value)) + toInt(parseDigit(fm.item_value.value)));			
			}
			if(obj == 'v'){
//				fm.item_supply.value 	= parseDecimal(toInt(parseDigit(fm.item_value.value)) / 0.1 );
				fm.item_amt.value 		= parseDecimal(toInt(parseDigit(fm.item_supply.value)) + toInt(parseDigit(fm.item_value.value)));			
			}
			if(obj == 'a'){
//				fm.item_supply.value 	= parseDecimal(toInt(parseDigit(fm.item_value.value)) / 1.1 );
//				fm.item_value.value 	= parseDecimal(toInt(parseDigit(fm.item_value.value)) - toInt(parseDigit(fm.item_supply.value)));			
			}			
			fm.t_item_supply.value	= fm.item_supply.value;
			fm.t_item_value.value 	= fm.item_value.value;
		}else{//������
			fm.t_item_supply.value = 0;
			fm.t_item_value.value = 0;		
			if(obj == 's'){
				fm.item_value[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) * 0.1 );
				fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
			}			
			if(obj == 'v'){
//				fm.item_supply[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_value[idx].value)) / 0.1 );
				fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
			}
			if(obj == 'a'){
//				fm.item_supply[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_value[idx].value)) / 1.1 );
//				fm.item_value[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_value[idx].value)) - toInt(parseDigit(fm.item_supply[idx].value)));			
			}
			
			//�ŷ����� �հ� ���
			for(i=0; i<size; i++){			
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
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="tax_no" value="<%=tax_no%>">
  <input type="hidden" name="item_id" value="<%=t_bean.getItem_id()%>">  
  <input type="hidden" name="item_size" value="<%=til_size%>">
  <input type="hidden" name="item_hap_num" value="">
  <table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr> 
      <td><font color="navy">���ݰ�꼭������ -&gt;  </font><span class="style1">���ݰ�꼭</span></td>
      <td align="right"><input type="button" name="b_ms2" value="���" onClick="javascript:go_list();" class="btn">
	  &nbsp;<input type="button" name="b_ms3" value="�ڷΰ���" onClick="javascript:history.go(-1);" class="btn"></td>	  
    </tr>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='10%' class='title'>��ȣ</td>
          <td colspan="3">&nbsp;<%=client.getFirm_nm()%>&nbsp;</td>
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
      </table></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2">&lt; ���ݰ�꼭 &gt; </td>
    </tr>
    <tr>
      <td colspan="2" class="line">
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
            <td class='title'>���࿵����</td>
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
              <input type="text" name="tax_g" size="40" value="<%=t_bean.getTax_g()%>" class="whitetext" readonly>
            </span></span></td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_g" size="40" value="<%=t_bean.getTax_g()%>" class="taxtext">
            </span></span></td>
          </tr>
          <tr>
            <td class='title'>���</td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_bigo" size="40" value="<%=t_bean.getTax_bigo()%>" class="whitetext" readonly>
            </span></span></td>
            <td align="center"><span class="ledger_cont"><span class="ledger_contC">
              <input type="text" name="tax_bigo" size="40" value="<%=t_bean.getTax_bigo()%>" class="taxtext">
            </span></span></td>
          </tr>
        </table>
      </td>
    </tr>
	<%if(!ti_bean.getItem_id().equals("")){%>
    <tr>
      <td colspan="2">&lt; �ŷ����� &gt; </td>
    </tr>	
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
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
      </table></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
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
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><input type="text" name="item_car_no" size="10" value="<%=til_bean.getItem_car_no()%>" class="taxtext"></td>
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
		  <%}else{%>&nbsp;<%}%></td>
        </tr>
        <%  item_s_amt = item_s_amt  + Long.parseLong(String.valueOf(til_bean.getItem_supply()));
										    item_v_amt = item_v_amt  + Long.parseLong(String.valueOf(til_bean.getItem_value()));
									     }%>
        <tr>
          <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>�հ�
                  <!--(��)-->
          </b></font></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_supply" size="10" value="<%=Util.parseDecimal(item_s_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
          <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="center"><input type="text" name="t_item_value" size="10" value="<%=Util.parseDecimal(item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><input type="text" name="t_item_amt" size="10" value="<%=Util.parseDecimal(item_s_amt+item_v_amt)%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value)'></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
        </tr>
      </table></td>
    </tr>
	<%}%>	
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
	<% 	if(!t_bean.getResseq().equals("")){%>
    <tr>
      <td colspan="2">* Ʈ������ ����� ��߱� ���� : 
      <input type="checkbox" name="ebill_yn" value="Y" checked></td>
    </tr>	
	<%}else{%>
	  <input type="hidden" name="ebill_yn" value="N">	
	<%}%>	
    <tr>
      <td colspan="2" align="right"><input type="button" name="b_upd" value="����" onClick="javascript:tax_update();" class="btn"></td>
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