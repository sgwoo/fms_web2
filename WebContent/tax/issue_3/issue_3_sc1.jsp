<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*"%>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String pp_st_nm 	= request.getParameter("pp_st_nm")==null?"":request.getParameter("pp_st_nm");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String ext_st 		= request.getParameter("ext_st")==null?"":request.getParameter("ext_st");
	String ext_tm 		= request.getParameter("ext_tm")==null?"":request.getParameter("ext_tm");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	int tae_sum = 0;
	int max_table_line = 3;
	int height = 0;
	String tax_supply = "";
	String tax_value = "";
	String tax_branch 	= "";
	String chk_check_box = "";
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "11");
	
	//���:������
	ContBaseBean base 		= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	if(base.getTax_type().equals("2")){//����
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	
	
	//�뿩����
	ContFeeBean fee = a_db.getContFee(rent_mng_id, rent_l_cd, "1");
	tax_branch = fee.getBr_id()==""?br_id:fee.getBr_id();
	
	String br_bigo = "";	
	//20090701���� ����ڴ�������
	if(!tax_branch.equals("S1") &&  AddUtil.parseInt(AddUtil.getDate(4)) > 20090631 ){
			
			//�������
			Hashtable br2 = c_db.getBranch(tax_branch);
			
			br_bigo = String.valueOf(br2.get("BR_NM"));
			tax_branch = "S1";
		//	t_bean.setBranch_g("S1");
		//	t_bean.setBranch_g2(String.valueOf(ht.get("BR_ID")));
	}
	
	
	//�ŷ�ó����
	ClientBean client = al_db.getClient(client_id);
	
	//���°� ����ü - ����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	ClientBean client2 = new ClientBean();
	if(!cont_etc.getRent_suc_dt().equals("") && !cont_etc.getRent_suc_l_cd().equals("")){
		ContBaseBean base2 = a_db.getContBaseAll(rent_mng_id, cont_etc.getRent_suc_l_cd());
		client2 = al_db.getClient(base2.getClient_id());
	}
	
	//���°�-�°��ü
	Hashtable cng_cont = af_db.getScdFeeCngContA(rent_mng_id, rent_l_cd);
	ClientBean client3 = new ClientBean();
	if(!String.valueOf(cng_cont.get("CLIENT_ID")).equals("") && !String.valueOf(cng_cont.get("CLIENT_ID")).equals("null")){		
		client3 = al_db.getClient(String.valueOf(cng_cont.get("CLIENT_ID")));
		out.println("�°��ü");
	}	
	
	//�׿��� �ŷ�ó ����	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	Hashtable ven = neoe_db.getVendorCase(client.getVen_code());
	
	//����
	Vector c_sites = ClientMngDb.getClientSites(client_id, "1");
	int c_site_size = c_sites.size();
	
	String i_enp_no = client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +"-"+ client.getSsn2();
	String i_firm_nm 	= client.getFirm_nm();
	String i_client_nm 	= client.getClient_nm();
	String i_addr 		= client.getO_addr();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	String i_taxregno	= client.getTaxregno();
	
	if(pp_st_nm.equals("�°������") && cont_etc.getRent_suc_commi_pay_st().equals("1")){
		i_enp_no 		= client2.getEnp_no1() +"-"+ client2.getEnp_no2() +"-"+ client2.getEnp_no3();
		if(client2.getEnp_no1().equals("")) i_enp_no = client2.getSsn1() +"-"+ client2.getSsn2();
		i_firm_nm 	= client2.getFirm_nm();
		i_client_nm = client2.getClient_nm();
		i_addr 			= client2.getO_addr();
		i_sta 			= client2.getBus_cdt();
		i_item 			= client2.getBus_itm();
		i_taxregno	= client2.getTaxregno();
	}
	
	if(!site_id.equals("")){
		//�ŷ�ó��������
		ClientSiteBean site = al_db.getClientSite(client_id, site_id);
		i_enp_no 		= site.getEnp_no();
		i_firm_nm 		= site.getR_site();
		i_client_nm 	= site.getSite_jang();
		i_addr 			= site.getAddr();
		i_sta 			= site.getBus_cdt();
		i_item 			= site.getBus_itm();
		i_taxregno		= site.getTaxregno();
		
		client.setCon_agnt_nm	(site.getAgnt_nm());
		client.setCon_agnt_dept	(site.getAgnt_dept());
		client.setCon_agnt_title(site.getAgnt_title());
		client.setCon_agnt_email(site.getAgnt_email().trim());
		client.setCon_agnt_m_tel(site.getAgnt_m_tel());		
		
		client.setCon_agnt_nm2	 (site.getAgnt_nm2());
		client.setCon_agnt_dept2 (site.getAgnt_dept2());
		client.setCon_agnt_title2(site.getAgnt_title2());
		client.setCon_agnt_email2(site.getAgnt_email2().trim());
		client.setCon_agnt_m_tel2(site.getAgnt_m_tel2());
		
	}
	
	Vector branches = c_db.getBranchs(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();
	
	Hashtable br = c_db.getBranch(tax_branch); //�Ҽӿ����� ����Ʈ ��ȸ
	
	//������ ������
	Vector grts = new Vector();
	int grt_size = 0;
	if(!client_id.equals("")){
		//grts = ScdMngDb.getGrtScdList("", client_id, "N");
		//grts = ScdMngDb.getGrtScdContList(pp_st_nm, rent_mng_id, rent_l_cd);
		grts = ScdMngDb.getGrtScdContList(rent_mng_id, rent_l_cd, rent_st, ext_st, ext_tm);
		grt_size = grts.size();	
	}
	//�Ա����� ǥ�ú���
	String ext_pay_dt_y = "";
	String ext_pay_dt_m = "";
	String ext_pay_dt_d = "";
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//����
	function tax_reg(){
		var fm = document.form1;	
		if(fm.scd_size.value == '0'){	alert('������ �������� �����ϴ�.'); return; }
		if(fm.count.value == '0'){		alert('���õ� ������ �������� �����ϴ�.'); return; }		
		if(fm.req_y.value == '' || fm.req_m.value == '' || fm.req_d.value == ''){	alert('���ݰ�꼭 �ۼ����ڸ� �Է��Ͻʽÿ�.'); return; }
		if(fm.tax_bigo.value == ''){	alert('���ݰ�꼭 ��� �Է��Ͻʽÿ�.'); return; }

		if(confirm('���ù��� �Ͻðڽ��ϱ�?'))
		{			
			//fm.target = "i_no";
			fm.action = "tax_reg_step1.jsp";
			fm.submit();						
		}
	}

	//������ ����
	function out_set(){
		var fm = document.form1;
		var o_brch = fm.o_enp_no.options[fm.o_enp_no.selectedIndex].value;
		var o_brch_split 	= o_brch.split("||");
		fm.o_br_id.value 	= o_brch_split[0];
		fm.o_addr.value 	= o_brch_split[1];
		fm.o_item.value 	= o_brch_split[2];
		fm.o_sta.value 		= o_brch_split[3];				
	}
	
	//���޹޴��� ����
	function in_set(){
		var fm = document.form1;
		var i_brch = fm.i_enp_no.options[fm.i_enp_no.selectedIndex].value;
		var i_brch_split 	= i_brch.split("||");
		fm.i_site_id.value 	= i_brch_split[0];
		fm.i_firm_nm.value 	= i_brch_split[1];
		fm.i_client_nm.value= i_brch_split[2];
		fm.i_addr.value 	= i_brch_split[3];				
		fm.i_item.value 	= i_brch_split[4];
		fm.i_sta.value 		= i_brch_split[5];		
		fm.i_taxregno.value = i_brch_split[6];		
		
		if(i_brch_split[7] != '0'){
			fm.client_id.value = i_brch_split[7];
		}else{
			fm.client_id.value = '<%=client_id%>';
		}		
		
	}	
	
	//��ϰ���
	function go_list(){
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "issue_3_frame1.jsp";
		fm.submit();
	}
	
	//������ ����
	function scd_select(idx){
		var fm = document.form1;
		var size = toInt(fm.scd_size.value);
		var count = 0;
		
		scd_clear();
				
		if(size == 1){//1��
			if(fm.ch_l_cd.checked == true){
				var ch_l_cd = fm.ch_l_cd.value;
				var ch_split = ch_l_cd.split(",");
				fm.l_cd.value 			= ch_split[0];
				fm.c_id.value 			= ch_split[1];	
				fm.tm.value 			= ch_split[2];		
				fm.item_g.value 		= ch_split[3];
				fm.item_car_no.value 	= ch_split[4];
				if(fm.item_car_no.value == '�̵��') fm.item_car_no.value = "";
				fm.item_car_nm.value 	= ch_split[5];
				fm.item_dt1.value 		= "";				
				fm.item_dt2.value 		= "";
				fm.item_supply.value 	= parseDecimal(ch_split[6]);
				fm.item_value.value 	= parseDecimal(ch_split[7]);
				fm.item_amt.value 		= parseDecimal(ch_split[8]);
				fm.tax_g.value			= fm.item_g.value;
//				fm.tax_bigo.value 		= fm.item_g.value + ch_split[9]+"����("+ch_split[4]+")";
				if(ch_split[4] == '�̵��'){
					if(ch_split[3] == '���ô뿩��')		fm.tax_bigo.value 		= fm.item_g.value + ch_split[9]+"����("+ch_split[0]+")";
					else 								fm.tax_bigo.value 		= fm.item_g.value + "("+ch_split[0]+")";
				}else{
					if(ch_split[3] == '���ô뿩��')		fm.tax_bigo.value 		= fm.item_g.value + ch_split[9]+"����("+ch_split[4]+")";
					else 								fm.tax_bigo.value 		= fm.item_g.value + "("+ch_split[4]+")";
				}				
				fm.tax_supply.value 	= fm.item_supply.value;
				fm.tax_value.value 		= fm.item_value.value;	
				fm.tax_amt.value 		= fm.item_amt.value;		
				fm.t_item_supply.value	= fm.item_supply.value;			
				fm.t_item_value.value 	= fm.item_value.value;
				
				//�Ա����� ������ ���ݰ�꼭�� ����(20190828)
				if(fm.ext_pay_dt.value!=""){
					var ext_pay_dt = fm.ext_pay_dt.value.split("-");
					fm.req_y.value = ext_pay_dt[0];
					fm.req_m.value = ext_pay_dt[1];
					fm.req_d.value = ext_pay_dt[2];
				}
				
				fm.count.value = 1;	
				count = 1;
			}
					
		}else{//������
			//����
			for(i=0; i<size; i++){
				if(fm.ch_l_cd[i].checked == true){	
					var ch_l_cd = fm.ch_l_cd[i].value;
					var ch_split = ch_l_cd.split(",");		
					fm.l_cd[count].value 		= ch_split[0];
					fm.c_id[count].value 		= ch_split[1];	
					fm.tm[count].value 			= ch_split[2];		
					fm.item_g[count].value 		= ch_split[3];
					fm.item_car_no[count].value = ch_split[4];
					if(fm.item_car_no[count].value == '�̵��') fm.item_car_no[count].value = "";					
					fm.item_car_nm[count].value = ch_split[5];
					fm.item_dt1[count].value 	= "";				
					fm.item_dt2[count].value 	= "";
					fm.item_supply[count].value = parseDecimal(ch_split[6]);
					fm.item_value[count].value 	= parseDecimal(ch_split[7]);
					fm.item_amt[count].value 	= parseDecimal(ch_split[8]);					
					count++;			
				}	
			}
			fm.count.value = count;
			
			//�ŷ����� �հ� ���
			for(i=0; i<count; i++){
				fm.t_item_supply.value	= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.item_supply[i].value)));			
				fm.t_item_value.value 	= parseDecimal(toInt(parseDigit(fm.t_item_value.value)) + toInt(parseDigit(fm.item_value[i].value)));			
			}
			if(count > 0){
				fm.tax_g.value			= fm.item_g[0].value;
				fm.tax_bigo.value		= fm.item_g[0].value;	
				if(count > 1){ 
					if(fm.item_car_no[0].value == "") 				
						fm.tax_bigo.value 		= fm.tax_bigo.value + "("+ fm.item_car_nm[0].value +")�� "+(count-1)+"��";									
					else
						fm.tax_bigo.value 		= fm.tax_bigo.value + "("+ fm.item_car_no[0].value +")�� "+(count-1)+"��";														
				}else{
					if(ch_split[4] == '�̵��'){
						if(ch_split[3] == '���ô뿩��')		fm.tax_bigo.value 		= "���ô뿩��" + ch_split[9]+"����("+ch_split[0]+")";
						else 													fm.tax_bigo.value 		= fm.item_g[0].value + "("+ch_split[0]+")";
					}else{
						if(ch_split[3] == '���ô뿩��')		fm.tax_bigo.value 		= "���ô뿩��" + ch_split[9]+"����("+ch_split[4]+")";
						else 													fm.tax_bigo.value 		= fm.item_g[0].value + "("+ch_split[4]+")";
					}
				}
			}
		}
		fm.tax_bigo.value 		= fm.tax_bigo.value + ' ' + fm.br_bigo.value;
		
		if(count > 0){		
			fm.t_item_amt.value 		= parseDecimal(toInt(parseDigit(fm.t_item_supply.value)) + toInt(parseDigit(fm.t_item_value.value)));			
			fm.tax_supply.value 		= fm.t_item_supply.value;
			fm.tax_value.value 			= fm.t_item_value.value;	
			fm.tax_amt.value 			= fm.t_item_amt.value;		
		
			var s_len = parseDigit(fm.tax_supply.value).length;
			var v_len = parseDigit(fm.tax_value.value).length;		
			fm.gongran.value 			= 11-s_len;
			var cnt = 0;
			for(i=11-s_len;i<11;i++){//���ް�
				fm.s_amt[i].value = parseDigit(fm.tax_supply.value).charAt(cnt);
				cnt++;
			}		
			cnt = 0;
			for(i=10-v_len;i<10;i++){//�ΰ���
				fm.v_amt[i].value = parseDigit(fm.tax_value.value).charAt(cnt);
				cnt++;
			}				
		}
	}
	
	//������ Ŭ����
	function scd_clear(){
		var fm = document.form1;
		var size = toInt(fm.scd_size.value);		
		//Ŭ����
		for(i=0; i<size; i++){
			fm.l_cd<%if(grt_size>1){%>[i]<%}%>.value 			= "";
			fm.c_id<%if(grt_size>1){%>[i]<%}%>.value 			= "";
			fm.tm<%if(grt_size>1){%>[i]<%}%>.value 				= "";
			fm.item_g<%if(grt_size>1){%>[i]<%}%>.value 			= "";
			fm.item_car_no<%if(grt_size>1){%>[i]<%}%>.value 	= "";
			fm.item_car_nm<%if(grt_size>1){%>[i]<%}%>.value 	= "";
			fm.item_dt1<%if(grt_size>1){%>[i]<%}%>.value 		= "";		
			fm.item_dt2<%if(grt_size>1){%>[i]<%}%>.value 		= "";
			fm.item_supply<%if(grt_size>1){%>[i]<%}%>.value 	= "0";
			fm.item_value<%if(grt_size>1){%>[i]<%}%>.value 		= "0";
			fm.item_amt<%if(grt_size>1){%>[i]<%}%>.value 		= "0";										
		}		
		fm.t_item_supply.value	= "0";			
		fm.t_item_value.value 	= "0";
		fm.t_item_amt.value 	= "0";			
		fm.tax_g.value 			= "";
		fm.tax_bigo.value 		= "";		
		fm.tax_supply.value 	= "0";
		fm.tax_value.value 		= "0";
		fm.tax_amt.value 		= "0";
		fm.gongran.value 		= "0";		
		fm.count.value			= "0";
		
		for(i=0;i<11;i++){//���ް�
			fm.s_amt[i].value = "";
		}		
		for(i=0;i<10;i++){//�ΰ���
			fm.v_amt[i].value = "";
		}					
	}	
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}		
//-->
</script>

</head>
<body leftmargin=10>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <%if(pp_st_nm.equals("�°������")){ %>
  <input type="hidden" name="o_client_id" value="<%=client_id%>">
  <%}%>
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="tax_branch" value="<%=tax_branch%>">        
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">  
  <input type="hidden" name="mode" value="<%=mode%>">  
  <input type="hidden" name="scd_size" value="<%=grt_size%>">
  <input type="hidden" name="count" value="0">
  <input type="hidden" name="br_bigo" value="<%=br_bigo%>">
  
<table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ�꼭���� > ���ù��� > <span class=style5>
						������</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
	    <td align="right" colspan=2><a href="javascript:go_list();"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>  
	</tr> 	 	
    <tr>
        <td colspan="2">
            <table width="100%"  border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="49%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���޹޴���</span></td>
          <td width="1%">&nbsp;</td>
          <td width="50%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
        </tr>
        <tr>
          <td class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
          	<tr>
          	    <td class=line2 style='height:1'></td>
          	</tr>
            <tr>
              <td width='20%' class='title'>��Ϲ�ȣ</td>
              <td colspan="3">&nbsp;
			  <input type="hidden" name="i_site_id" value="<%=site_id%>">
			    <select name='i_enp_no' onChange='javascript:in_set();'>
				<%if(c_site_size > 0){%>
		          <option value=''>����</option>
				<%}%>  
		          <option value='00||<%=client.getFirm_nm()%>||<%=client.getClient_nm()%>||<%=client.getO_addr()%>||<%=client.getBus_cdt()%>||<%=client.getBus_itm()%>||<%=client.getTaxregno()%>||0'  <%if(site_id.equals("") && !cont_etc.getRent_suc_commi_pay_st().equals("1")){%>selected<%}%>><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%> ����</option>				  
					<%	for(int i = 0 ; i < c_site_size ; i++){
							ClientSiteBean site = (ClientSiteBean)c_sites.elementAt(i);%>	  		

			      <option value='<%=site.getSeq()%>||<%=site.getR_site()%>||<%=site.getSite_jang()%>||<%=site.getAddr()%>||<%=site.getBus_itm()%>||<%=site.getBus_cdt()%>||<%=site.getTaxregno()%>||0' <%if(site_id.equals(site.getSeq())){%>selected<%}%>><%=AddUtil.ChangeSsn(AddUtil.ChangeEnp(site.getEnp_no()))%> <%=Util.subData(site.getR_site(), 15)%></option>
          			<%	}%>
          			
          			<!--���°� ����� ��ü-->
          			<%if(!client2.getFirm_nm().equals("")){%>
          			<option value='00||<%=client2.getFirm_nm()%>||<%=client2.getClient_nm()%>||<%=client2.getO_addr()%>||<%=client2.getBus_cdt()%>||<%=client2.getBus_itm()%>||<%=client2.getTaxregno()%>||<%=client2.getClient_id()%>' <%if(pp_st_nm.equals("�°������") && cont_etc.getRent_suc_commi_pay_st().equals("1")){%>selected<%}%>><%if(!client2.getEnp_no1().equals("")){%><%=client2.getEnp_no1()%>-<%=client2.getEnp_no2()%>-<%=client2.getEnp_no3()%><%}else{%><%=client2.getSsn1()%>-<%=client2.getSsn2()%><%}%> �°�����ü <%=client2.getFirm_nm()%></option>				  
          			<%	//�°� ����ü�� ����
          				Vector c_sites2 = ClientMngDb.getClientSites(client2.getClient_id(), "1");
          				int c_site_size2 = c_sites2.size(); 
          				for(int i = 0 ; i < c_site_size2 ; i++){
          					ClientSiteBean site = (ClientSiteBean)c_sites2.elementAt(i);	
          			%>
          			<option value='<%=site.getSeq()%>||<%=site.getR_site()%>||<%=site.getSite_jang()%>||<%=site.getAddr()%>||<%=site.getBus_itm()%>||<%=site.getBus_cdt()%>||<%=site.getTaxregno()%>||<%=client2.getClient_id()%>'><%=AddUtil.ChangeSsn(AddUtil.ChangeEnp(site.getEnp_no()))%> �°�����ü���� <%=Util.subData(site.getR_site(), 15)%></option>
          			<%	} %>
          			<%}%>
          			<!--���°� �İ�� ��ü-->
          			<%if(!client3.getFirm_nm().equals("")){%>
          			<option value='00||<%=client3.getFirm_nm()%>||<%=client3.getClient_nm()%>||<%=client3.getO_addr()%>||<%=client3.getBus_cdt()%>||<%=client3.getBus_itm()%>||<%=client3.getTaxregno()%>||<%=client3.getClient_id()%>' ><%if(!client3.getEnp_no1().equals("")){%><%=client3.getEnp_no1()%>-<%=client3.getEnp_no2()%>-<%=client3.getEnp_no3()%><%}else{%><%=client3.getSsn1()%>-<%=client3.getSsn2()%><%}%> �°��ľ�ü <%=client3.getFirm_nm()%></option>				  
          			<%}%>

          			
		        </select>		
				&nbsp;(��������ȣ : <input type="text" name="i_taxregno" size="4" value="<%=i_taxregno%>" class="whitetext" readonly>)	 			    
			    </td>
              </tr>
            <tr>
              <td class='title'>��ȣ(���θ�)</td>
              <td colspan="3">&nbsp;<input type="text" name="i_firm_nm" size="50" value="<%=i_firm_nm%>" class="whitetext" readonly>
              <%if(client.getClient_st().equals("2")){%>������� : <%=client.getSsn1()%><%}%></td>
              </tr>
            <tr>
              <td class='title'>����</td>
              <td colspan="3">&nbsp;<input type="text" name="i_client_nm" size="50" value="<%=i_client_nm%>" class="whitetext" readonly></td>
              </tr>
            <tr>
              <td class='title'>������ּ�</td>
              <td colspan="3">&nbsp;<input type="text" name="i_addr" size="50" value="<%=i_addr%>" class="whitetext" readonly></td>
            </tr>
            <tr>
              <td class='title'>����</td>
              <td width="30%">&nbsp;<input type="text" name="i_sta" size="16" value="<%=i_sta%>" class="whitetext" readonly></td>
              <td width="15%" class='title'>����</td>
              <td width="35%">&nbsp;<input type="text" name="i_item" size="20" value="<%=i_item%>" class="whitetext" readonly></td>
            </tr>
          </table></td>
          <td>&nbsp;</td>
          <td class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
          	    <td class=line2 style='height:1'></td>
          	</tr>
            <tr>
              <td width='20%' class='title'>��Ϲ�ȣ</td>
              <td colspan="3">&nbsp;
			    <input type="hidden" name="o_br_id" value="<%=br.get("BR_ID")%>">  
			    <select name='o_enp_no' onChange='javascript:out_set();'>
		          <option value=''>����</option>
          			<%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
			      <option value='<%=branch.get("BR_ID")%>||<%=branch.get("BR_ADDR")%>||<%=branch.get("BR_ITEM")%>||<%=branch.get("BR_STA")%>'  <%if(tax_branch.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>><%= AddUtil.ChangeEnp(String.valueOf(branch.get("BR_ENT_NO")))%> <%= branch.get("BR_NM")%></option>
          			<%		}
						}%>
		        </select>			  
			  </td>
            </tr>
            <tr>
              <td class='title'>��ȣ(���θ�)</td>
              <td colspan="3">&nbsp;(��)�Ƹ���ī</td>
            </tr>
            <tr>
              <td class='title'>����</td>
              <td colspan="3">&nbsp;<%=br.get("BR_OWN_NM")%></td>
            </tr>
            <tr>
              <td class='title'>������ּ�</td>
              <td colspan="3">&nbsp;<input type="text" name="o_addr" size="50" value="<%=br.get("BR_ADDR")%>" class="whitetext" readonly></td>
            </tr>
            <tr>
              <td class='title'>����</td>
              <td width="30%">&nbsp;<input type="text" name="o_sta" size="16" value="<%=br.get("BR_STA")%>" class="whitetext" readonly></td>
              <td width="15%" class='title'>����</td>
              <td width="35%">&nbsp;<input type="text" name="o_item" size="20" value="<%=br.get("BR_ITEM")%>" class="whitetext" readonly></td>
            </tr>
          </table></td>
        </tr>
      </table></td>
    </tr>		
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ������</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
      	<tr><td class=line2 style='height:1'></td></tr>
        <tr>
          <td width='3%' class='title'>����</td>
          <td width='8%' class='title'>����</td>
          <td width='10%' class='title'>����ȣ</td>
          <td width='8%' class='title'>������ȣ</td>
          <td width='*' class='title'>����</td>
          <td width='8%' class='title'>���ް�</td>
          <td width='6%' class='title'>�ΰ���</td>
          <td width='8%' class='title'>�հ�</td>
          <td width='8%' class='title'>�뿩������</td>
          <td width='8%' class='title'>�Աݿ�����</td>
          <td width='8%' class='title'>�Աݱݾ�</td>
          <td width='8%' class='title'>�Ա�����</td>
        </tr>
		<%	if(grt_size > 0){
				for (int i = 0 ; i < grt_size ; i++){
					Hashtable grt = (Hashtable)grts.elementAt(i);
					if(!String.valueOf(grt.get("EXT_PAY_DT")).equals("")){	
						//chk_check_box = "PAID";
						ext_pay_dt_y = String.valueOf(grt.get("EXT_PAY_DT")).substring(0, 4);
						ext_pay_dt_m = String.valueOf(grt.get("EXT_PAY_DT")).substring(4, 6);
						ext_pay_dt_d = String.valueOf(grt.get("EXT_PAY_DT")).substring(6, 8);
					}
					//chk_check_box ������(20191004)
					int ext_s_amt  		= AddUtil.parseInt(String.valueOf(grt.get("EXT_S_AMT")));
					int ext_v_amt  		= AddUtil.parseInt(String.valueOf(grt.get("EXT_V_AMT")));
					int ext_pay_amt  	= AddUtil.parseInt(String.valueOf(grt.get("EXT_PAY_AMT")));
					if(ext_pay_amt == (ext_s_amt + ext_v_amt)){		chk_check_box = "PAID";		}
					
					//20191101 �߰�����
					String grt_rent_l_cd 		= String.valueOf(grt.get("RENT_L_CD"));
					String grt_rent_mng_id = String.valueOf(grt.get("RENT_MNG_ID"));
					String grt_rent_st 			= String.valueOf(grt.get("RENT_ST"));
					String grt_rent_seq 		= String.valueOf(grt.get("RENT_SEQ"));
					String grt_ext_st 			= String.valueOf(grt.get("EXT_ST"));
					String grt_ext_id 			= String.valueOf(grt.get("EXT_ID"));
					
					Vector grts2 = ScdMngDb.getGrtScdList2(grt_rent_l_cd, grt_rent_mng_id, grt_rent_st, grt_rent_seq, grt_ext_st, grt_ext_id);
					int grts2_size = grts2.size();
					int ext_pay_amt_tot = 0;
					String ext_pay_dt = "";
					if(grts2_size>1){	//�Աݳ����� 2�� �̻����� Ȯ��
						for(int j=0;j<grts2_size;j++){
							Hashtable grt2 = (Hashtable)grts2.elementAt(j);
							if(!String.valueOf(grt.get("RENT_SUC_DT")).equals("") && String.valueOf(grt.get("SUC_RENT_ST")).equals(grt_rent_st)){
								if(AddUtil.parseInt(String.valueOf(grt.get("RENT_SUC_DT")))<=AddUtil.parseInt(String.valueOf(grt2.get("EXT_PAY_DT")))){
									ext_pay_amt_tot += AddUtil.parseInt(String.valueOf(grt2.get("EXT_PAY_AMT")));
								}
							}else{
								ext_pay_amt_tot += AddUtil.parseInt(String.valueOf(grt2.get("EXT_PAY_AMT")));
							}
							if(j==grts2_size-1){	
								if(!String.valueOf(grt2.get("EXT_PAY_DT")).equals("")){
									ext_pay_dt = String.valueOf(grt2.get("EXT_PAY_DT"));
									ext_pay_dt_y = String.valueOf(grt2.get("EXT_PAY_DT")).substring(0, 4);
									ext_pay_dt_m = String.valueOf(grt2.get("EXT_PAY_DT")).substring(4, 6);
									ext_pay_dt_d = String.valueOf(grt2.get("EXT_PAY_DT")).substring(6, 8);
								}
							}	//�Աݳ�¥�� �������� �������� ����. 
						}
						
						if(ext_s_amt + ext_v_amt == ext_pay_amt_tot){			chk_check_box = "PAID";		}
						else{																			chk_check_box = "";				}
					}
					
					//out.println("RENT_SUC_DT="+String.valueOf(grt.get("RENT_SUC_DT")));
					//out.println("SUC_RENT_ST="+String.valueOf(grt.get("SUC_RENT_ST")));
					//out.println("grt_rent_st="+grt_rent_st);
					
					//���°�ó��
					if(!String.valueOf(grt.get("RENT_SUC_DT")).equals("") && String.valueOf(grt.get("SUC_RENT_ST")).equals(grt_rent_st))
					{
						//out.println("���°�ó��");
						if(String.valueOf(grt.get("PP_ST_NM")).equals("������") && AddUtil.parseInt(String.valueOf(grt.get("PP_SUC_R_AMT")))>0){
							grt.put("EXT_S_AMT",grt.get("PP_SUC_S_AMT"));
							grt.put("EXT_V_AMT",grt.get("PP_SUC_V_AMT"));
							grt.put("PP_AMT",grt.get("PP_SUC_R_AMT"));
						}
						if(String.valueOf(grt.get("PP_ST_NM")).equals("���ô뿩��") && AddUtil.parseInt(String.valueOf(grt.get("IFEE_SUC_R_AMT")))>0){
							grt.put("EXT_S_AMT",grt.get("IFEE_SUC_S_AMT"));
							grt.put("EXT_V_AMT",grt.get("IFEE_SUC_V_AMT"));
							grt.put("PP_AMT",grt.get("IFEE_SUC_R_AMT"));
						}						
					}
						
		%>		
        <tr>
          <td align="center"><input type="checkbox" name="ch_l_cd" onclick="javascript:scd_select(<%=i%>)" value="<%=grt.get("RENT_L_CD")%>,<%=grt.get("CAR_MNG_ID")%>,<%=grt.get("RENT_ST")%>,<%=grt.get("PP_ST_NM")%>,<%=grt.get("CAR_NO")%>,<%=grt.get("CAR_NM")%>,<%=grt.get("EXT_S_AMT")%>,<%=grt.get("EXT_V_AMT")%>,<%=grt.get("PP_AMT")%>,<%=grt.get("PERE_R_MTH")%>" <%if(grt_size==1)%>checked<%%>></td>
          <td align="center"><%=grt.get("PP_ST_NM")%><a href="javascript:view_client('<%=grt.get("RENT_MNG_ID")%>', '<%=grt.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true">.</a></td>
          <td align="center"><%if(client_id.equals("")){%><a href="javascript:client_select('<%=grt.get("CLIENT_ID")%>','<%=grt.get("SITE_ID")%>')"><%=grt.get("RENT_L_CD")%></a><%}else{%><%=grt.get("RENT_L_CD")%><%}%></td>
          <td align="center"><%=grt.get("CAR_NO")%></td>
          <td align="center"><span title='<%=grt.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("CAR_NM")), 5)%></td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("EXT_S_AMT")))%>&nbsp;</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("EXT_V_AMT")))%>&nbsp;</td>
          <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("PP_AMT")))%>&nbsp;</td>
          <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("RENT_START_DT")))%></td>
          <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("EXT_EST_DT")))%></td>
          <td align="right">
          <%if(grts2_size>1){%>
          	<%=Util.parseDecimal(String.valueOf(ext_pay_amt_tot))%>
          <%}else{%>
          	<%=Util.parseDecimal(String.valueOf(grt.get("EXT_PAY_AMT")))%>
          <%}%>	
          	&nbsp;</td>
          <%-- <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("EXT_PAY_DT")))%></td> --%>
          <td align="center"><input type="text" size="8" class="white" name="ext_pay_dt" 
          <%if(grts2_size>1 && !ext_pay_dt.equals("")){%>
          	value="<%=AddUtil.ChangeDate2(ext_pay_dt)%>"
          <%}else{%>
          	value="<%=AddUtil.ChangeDate2(String.valueOf(grt.get("EXT_PAY_DT")))%>"
          <%}%>	
          ></td>
        </tr>
		<%		}
			}else{%>
	    <tr>
	      <td colspan="10" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
    	</tr>
		<% 	}%>			
      </table></td>
    </tr>
    <!-- ���°� -->
	<%		if(pp_st_nm.equals("������") && cont_etc.getPp_suc_r_amt()>0 && cont_etc.getPp_suc_o_amt()!=cont_etc.getPp_suc_r_amt()){ %>
	<tr> 
        <td>�� ���°� : <%=AddUtil.parseDecimal(cont_etc.getPp_suc_o_amt())%>���� ������� <%=AddUtil.parseDecimal(cont_etc.getPp_suc_o_amt()-cont_etc.getPp_suc_r_amt())%>��, ���°��� <%=AddUtil.parseDecimal(cont_etc.getPp_suc_r_amt())%>��</td>
    </tr>
	<%		} %>
	<!-- ���°� -->
	<%		if(pp_st_nm.equals("���ô뿩��") && cont_etc.getIfee_suc_r_amt()>0 && cont_etc.getIfee_suc_o_amt()!=cont_etc.getIfee_suc_r_amt()){ %>
	<tr> 
        <td>�� ���°� : <%=AddUtil.parseDecimal(cont_etc.getIfee_suc_o_amt())%>���� ������� <%=AddUtil.parseDecimal(cont_etc.getIfee_suc_o_amt()-cont_etc.getIfee_suc_r_amt())%>��, ���°��� <%=AddUtil.parseDecimal(cont_etc.getIfee_suc_r_amt())%>��</td>
    </tr>
	<%		} %>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ŷ�����</span></td>
      <td align="right">
	  </td>
    </tr>	
    <tr>
      <td colspan="2" class="line"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="center" bgcolor="#CCCCCC">
          <td rowspan="2" width="5%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">�ŷ�����</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">������ȣ</td>
          <td width="25%" rowspan="2" bgcolor="#CCCCCC" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
          <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">û��(�ŷ�)������</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">���ް���</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
          <td rowspan="2" width="10%" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">�հ�</td>
        </tr>
        <tr>
          <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~����</td>
          <td height="20" width="10%" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~����</td>
        </tr>
		<%for(int i =0; i<grt_size; i++){%>
		<input type='hidden' name="l_cd">
		<input type='hidden' name="c_id">		
		<input type='hidden' name="tm">
		<input type='hidden' name="rent_st">		
		<input type='hidden' name="seq" value="<%=i+1%>">
        <tr>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=i+1%></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_g" size="12" value="" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_car_no" size="12" value="" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_car_nm" size="25" value="" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_dt1" size="10" value="" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_dt2" size="10" value="" class="whitetext" readonly>
          </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_supply" size="10" value="" class="whitenum" readonly> 
            </span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_value" size="10" value="" class="whitenum" readonly>
			</span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="item_amt" size="10" value="" class="whitenum" readonly>
			</span></td>
        </tr>
		<%}%>		
        <tr>
          <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">�հ�</td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="t_item_supply" size="10" value="" class="whitenum" readonly>
			</span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="t_item_value" size="10" value="" class="whitenum" readonly>
			</span></td>
          <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid"><span class="ledger_contC">
            <input type="text" name="t_item_amt" size="10" value="" class="whitenum" readonly>
			</span></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭</span> <font color=red>(�ۼ����ڰ� ���ú��� ũ�� ������ ���� �ʽ��ϴ�.)</font></td>
      <td align="right">
	  </td>
    </tr>	
    <tr>
      <td colspan="2"><table style="BORDER-COLLAPSE: collapse" cellspacing=0 cellpadding=0 width=100%>
        <tbody>
          <tr align="center">
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=3 height=25>�� ��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=12 height=25>�� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=10 height=25>�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=36% height=25>�� &nbsp;��</td>
          </tr>
          <tr>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=8% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=6% height=25 align="center">������</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">õ</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">õ</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">õ</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">õ</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=2% height=25 align="center">��</td>
            <td rowspan=2 align="center" class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid"><span class="ledger_contC">
              <input type="text" name="tax_bigo" size="40" value="" class="taxtext">
            </span></td>
          </tr>
          <tr>
            <%-- <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_y" size="4" value="<%=AddUtil.getDate(1)%>" class="taxtext"></td>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_m" size="2" value="<%=AddUtil.getDate(2)%>" class="taxtext" onBlur="javascript:document.form1.tax_m.value=this.value;"></td>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_d" size="2" value="<%=AddUtil.getDate(3)%>" class="taxtext" onBlur="javascript:document.form1.tax_d.value=this.value;"></td> --%>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_y" size="4" value="<%=ext_pay_dt_y%>" class="taxtext"></td>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_m" size="2" value="<%=ext_pay_dt_m%>" class="taxtext" onBlur="javascript:document.form1.tax_m.value=this.value;"></td>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_d" size="2" value="<%=ext_pay_dt_d%>" class="taxtext" onBlur="javascript:document.form1.tax_d.value=this.value;"></td>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="gongran" size="1" value="" class="taxtext"></td>
            <%for(int i=0; i<11-tax_supply.length(); i++){%>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="s_amt" size="1" value="" class="whitetext"></td>
            <%}%>
            <%for(int i=0; i<tax_supply.length(); i++){%>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="s_amt" size="1" value="" class="whitetext"></td>
            <%}%>
            <%for(int i=0; i<10-tax_value.length(); i++){%>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="v_amt" size="1" value="" class="whitetext"></td>
            <%}%>
            <%for(int i=0; i<tax_value.length(); i++){%>
            <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="v_amt" size="1" value="" class="whitetext"></td>
            <%}%>
          </tr>
        </tbody>
      </table>
        <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
          <tbody>
          <tbody>
            <tr>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=2 height=30 align="center">��&nbsp;&nbsp;��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=26% height=30 align="center">ǰ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=10% height=30 align="center">�� ��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=10% height=30 align="center">�� ��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=10% height=30 align="center">�� ��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=30 align="center">���ް���</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=30 align="center">�� ��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=6% height=30 align="center">�� ��</td>
            </tr>
            <tr>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_m" size="2" value="" class="whitetext"></td>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_d" size="2" value="" class="whitetext"></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25>&nbsp;<span class="ledger_contC">
                <input type="text" name="tax_g" size="25" value="" class="taxtext">
              </span> </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25><nobr></nobr></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                <input type="text" name="tax_supply" size="11" value="" class="whitenum" readonly>
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                <input type="text" name="tax_value" size="10" value="" class="whitenum" readonly>
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
            </tr>
          </tbody>
        </table>
        <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
          <tbody>
          <tbody>
            <tr>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">�հ�ݾ�</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ǥ</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=16% height=25 align="center">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=25 align="center">�� �� �� �� ��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 0px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" align=middle width=21% rowspan=2><table cellspacing=0 cellpadding=0 width=140 border=0>
                  <tbody>
                    <tr class=ledger_titleB>
                      <td width="47%">�̱ݾ���</td>
                      <td width="45%">
               		  	  <input type="radio" name="pubform" value="R" <%if(chk_check_box.equals("PAID")){%>checked<%}%>>����<br>
                          <input type="radio" name="pubform" value="D" <%if(!chk_check_box.equals("PAID")){%>checked<%}%>>û�� </td>
                      <td width="8%">��</td>
                    </tr>
                  </tbody>
              </table></td>
            </tr>
            <tr>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=30 align="center"><span class="ledger_contC">
                <input type="text" name="tax_amt" size="11" value="" class="whitenum">
              </span>��</td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
            </tr>
          </tbody>
        </table></td>
    </tr>	
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ڼ��ݰ�꼭 �̸��� �߼�</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
      	<tr><td class=line2 style='height:1'></td></tr>
        <tr>
          <td width='10%' class='title'>���Ŵ����</td>
          <td>&nbsp;�̸� : 
          	<input type='text' size='15' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text'>
          	&nbsp;�μ� : 
            <input type='text' size='15' name='con_agnt_dept' value='<%=client.getCon_agnt_dept()%>' maxlength='15' class='text'>
            &nbsp;���� : 
            <input type='text' size='15' name='con_agnt_title' value='<%=client.getCon_agnt_title()%>' maxlength='10' class='text'>
            &nbsp;EMAIL : 
            <input type='text' size='40' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'>
            &nbsp;�̵���ȭ :                         
            <input type='text' size='15' name='con_agnt_m_tel' value='<%=client.getCon_agnt_m_tel()%>' maxlength='15' class='text'>
          </td>
        </tr>
        <tr>
          <td width='10%' class='title'>�߰������</td>
          <td>&nbsp;�̸� : 
          	<input type='text' size='15' name='con_agnt_nm2' value='<%=client.getCon_agnt_nm2()%>' maxlength='20' class='text'>
          	&nbsp;�μ� : 
            <input type='text' size='15' name='con_agnt_dept2' value='<%=client.getCon_agnt_dept2()%>' maxlength='15' class='text'>
            &nbsp;���� : 
            <input type='text' size='15' name='con_agnt_title2' value='<%=client.getCon_agnt_title2()%>' maxlength='10' class='text'>
            &nbsp;EMAIL : 
            <input type='text' size='40' name='con_agnt_email2' value='<%=client.getCon_agnt_email2()%>' maxlength='30' class='text'>
            &nbsp;�̵���ȭ :                         
            <input type='text' size='15' name='con_agnt_m_tel2' value='<%=client.getCon_agnt_m_tel2()%>' maxlength='15' class='text'>
          </td>
        </tr>        
      </table></td>
    </tr>	
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ⱸ��</span></td>
      <td align="right">
	  </td>
    </tr>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
      	<tr><td class=line2 style='height:1'></td></tr>
        <tr>
          <td width='10%' class='title'>����</td>
          <td width='90%'>&nbsp;
		      <input type="radio" name="car_use" value="1" <%if(base.getCar_st().equals("1"))%>checked<%%>>
              �뿩�������&nbsp;
              <input type="radio" name="car_use" value="2" <%if(base.getCar_st().equals("3"))%>checked<%%>>
              �����������&nbsp;
			  </td>
          </tr>
      </table></td>
    </tr>		
    <tr>
      <td colspan="2"></td>
    </tr>	
    <tr>
      <td colspan="2" align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <a href="javascript:tax_reg();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
	  
	  <%}%>
	  </td>
    </tr>		
  </table>
<script language="JavaScript">
<!--
	var fm = document.form1;
	
	fm.tax_m.value = fm.req_m.value;
	fm.tax_d.value = fm.req_d.value;	
	
	if(fm.scd_size.value == '1'){

		var ch_l_cd = fm.ch_l_cd.value;
		var ch_split = ch_l_cd.split(",");
	
		fm.l_cd.value 			= ch_split[0];
		fm.c_id.value 			= ch_split[1];	
		fm.tm.value 			= ch_split[2];		
		fm.item_g.value 		= ch_split[3];
		fm.item_car_no.value 	= ch_split[4];
		fm.item_car_nm.value 	= ch_split[5];
		fm.item_dt1.value 		= "";				
		fm.item_dt2.value 		= "";
		fm.item_supply.value 	= parseDecimal(ch_split[6]);
		fm.item_value.value 	= parseDecimal(ch_split[7]);
		fm.item_amt.value 		= parseDecimal(ch_split[8]);	
		fm.t_item_supply.value	= fm.item_supply.value;
		fm.t_item_value.value 	= fm.item_value.value;
		fm.t_item_amt.value 	= fm.item_amt.value;	
		fm.tax_g.value			= fm.item_g.value;
		if(ch_split[4] == '�̵��'){
			if(ch_split[3] == '���ô뿩��')		fm.tax_bigo.value 		= fm.item_g.value + ch_split[9]+"����("+ch_split[0]+")" + " " + fm.br_bigo.value;		
			else 								fm.tax_bigo.value 		= fm.item_g.value + "("+ch_split[0]+")"+ " " + fm.br_bigo.value;		
		}else{
			if(ch_split[3] == '���ô뿩��')		fm.tax_bigo.value 		= fm.item_g.value + ch_split[9]+"����("+ch_split[4]+")"+ " " + fm.br_bigo.value;		
			else 								fm.tax_bigo.value 		= fm.item_g.value + "("+ch_split[4]+")" + " " + fm.br_bigo.value;		
		}
	
		fm.tax_supply.value 	= fm.item_supply.value;
		fm.tax_value.value 		= fm.item_value.value;	
		fm.tax_amt.value 		= fm.item_amt.value;		
		fm.count.value 			= 1;
		var s_len = parseDigit(fm.tax_supply.value).length;
		var v_len = parseDigit(fm.tax_value.value).length;		
		fm.gongran.value 		= 11-s_len;
		var cnt = 0;
		for(i=11-s_len;i<11;i++){//���ް�
			fm.s_amt[i].value = parseDigit(fm.tax_supply.value).charAt(cnt);
			cnt++;
		}		
		cnt = 0;
		for(i=10-v_len;i<10;i++){//�ΰ���
			fm.v_amt[i].value = parseDigit(fm.tax_value.value).charAt(cnt);
			cnt++;
		}				
	}		
	
	in_set();
	
	if(fm.ext_pay_dt.value == ''){
		alert('���Աݽ������Դϴ�.');
	}
	
//-->
</script>  
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>