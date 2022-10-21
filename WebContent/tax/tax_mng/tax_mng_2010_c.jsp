<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.common.*, tax.*, acar.bill_mng.*, acar.client.*, acar.user_mng.*, cust.member.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String tax_no 		= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String pubcode = "";
	String nts_issueid = "";
	String etax_reason = "";
	long item_s_amt = 0;
	long item_v_amt = 0;
	long item_s_amt2 = 0;
	int height = 0;
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "07", "01");
	
	//���ݰ�꼭 ��ȸ
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no, gubun2);
	
	//�ŷ������� ��ȸ
	TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(t_bean.getItem_id(), gubun2);
	//�ŷ������� ����Ʈ ��ȸ
	Vector tils	            = IssueDb.getTaxItemListCase2010(t_bean.getItem_id(), gubun2);
	int til_size            = tils.size();
	//�ŷ������� ��Ÿ ����Ʈ ��ȸ
	Vector tiks	        = IssueDb.getTaxItemKiCase(t_bean.getItem_id());
	int tik_size            = tiks.size();
	//reg_code
	String reg_code			= "";
	if(til_size>0){
		TaxItemListBean til_bean_code = (TaxItemListBean)tils.elementAt(0);
		reg_code 	 		= til_bean_code.getReg_code();
	}
	
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
	//�����뿩�϶�
	UserMngDatabase umd = UserMngDatabase.getInstance();
	if(t_bean.getGubun().equals("13")){
		user_bean = umd.getUsersBean(t_bean.getClient_id().trim());
	}
	
	MemberBean m_bean = m_db.getMemberCase(t_bean.getClient_id(), t_bean.getSeq(), "");
	if(m_bean.getMember_id().equals("")) m_bean = m_db.getMemberCase(t_bean.getClient_id(), "", "");
	
	String tax_supply 	= String.valueOf(t_bean.getTax_supply());
	String tax_value 	= String.valueOf(t_bean.getTax_value());
	String i_enp_no 	= client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +"-"+ client.getSsn2();
	String i_firm_nm 	= client.getFirm_nm();
	String i_client_nm 	= client.getClient_nm();
	String i_addr 		= client.getO_addr();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	
	if(!t_bean.getRecCoName().equals("")){
		i_enp_no 	= t_bean.getRecCoRegNo		();
		i_firm_nm 	= t_bean.getRecCoName		();
		i_client_nm 	= t_bean.getRecCoCeo		();
		i_addr 		= t_bean.getRecCoAddr		();
		i_sta 		= t_bean.getRecCoBizType	();
		i_item 		= t_bean.getRecCoBizSub		();
		if(i_enp_no.equals("") && t_bean.getReccoregnotype().equals("02")){
	  		i_enp_no = t_bean.getRecCoSsn		();
		}
	}else{	
		if(t_bean.getGubun().equals("13")){
			i_enp_no 	= user_bean.getUser_ssn1()+"-"+user_bean.getUser_ssn2();
			i_firm_nm 	= user_bean.getUser_nm();
			i_client_nm 	= "";
			i_addr 		= user_bean.getAddr();
			i_sta 		= "";
		  	i_item 		= "";
		}else{
			if(t_bean.getTax_type().equals("2") && !site.getClient_id().equals("")){
				i_enp_no 	= site.getEnp_no();
			  	i_firm_nm 	= site.getR_site();
			  	i_client_nm 	= site.getSite_jang();
		  		i_addr 		= site.getAddr();
		  		i_sta 		= site.getBus_cdt();
		  		i_item 		= site.getBus_itm();
			}
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
		fm.action = "tax_mng_2010_frame.jsp";
		fm.submit();
	}

		
	function  viewTaxInvoice(pubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=680px, height=760px");
		document.form1.action="https://www.trusbill.or.kr/jsp/directTax/TaxViewIndex.jsp";
		document.form1.method="post";
		document.form1.pubCode.value=pubCode;
		document.form1.docType.value="T"; //���ݰ�꼭
		document.form1.userType.value="S"; // S=�������� ó��ȭ��, R= �޴��� ó��ȭ��
		document.form1.target="taxInvoice";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.pubCode.value="";
		taxInvoice.focus();
		return;
	}
		
//-->
</script>

</head>
<body>
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="tax_no" value="<%=tax_no%>">
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
  <input type="hidden" name="mode" value="<%=mode%>">
  <input type="hidden" name="tax_dt" value="<%=t_bean.getTax_dt()%>">  
  <input type="hidden" name="item_id" value="<%=t_bean.getItem_id()%>">    
  <input type='hidden' name="ebill_st" value="">
  <input type='hidden' name="pubCode" value="">
  <input type='hidden' name="docType" value="">
  <input type='hidden' name="userType" value="">  
  <input type='hidden' name="flist" value="cont">    
  <input type='hidden' name="reg_code" value="cont">   
  <input type='hidden' name="from_page" value="<%=from_page%>">   
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ�꼭���� > ���ݰ�꼭������5���� > <span class=style5>
						���ݰ�꼭</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr> 
	<tr>
	    <td align="right"  colspan=10>
							<a href="javascript:go_list();"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;
	    </td>
	</tr> 	  	
    
	<%if(t_bean.getGubun().equals("18")){%>
	
	<%}else if(!t_bean.getGubun().equals("13")){%>
	<tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class='line'>
        <% if(t_bean.getRent_l_cd().trim().length()==13){%>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	
          <tr>
            <td width='10%' class='title'>����ȣ</td>
            <td width='15%'>&nbsp;<%=t_bean.getRent_l_cd()%></td>
            <td width='10%' class='title'>��ȣ</td>
            <td colspan="3">&nbsp;<%=bean.getFirm_nm()%>&nbsp;<%=bean.getClient_id()%></td>
            <td width='10%' class='title'>����/����</td>
            <td width='15%'>&nbsp;<span title='<%=bean.getSite_nm()%>'><%=Util.subData(bean.getSite_nm(), 10)%></span></td>
          </tr>
          <tr>
            <td class='title'>������ȣ</td>
            <td>&nbsp;<%=bean.getCar_no()%></td>
            <td class='title'>����</td>
            <td colspan="3">&nbsp;<%=bean.getCar_nm()%>&nbsp;<%=bean.getCar_name()%></td>
            <td class='title'>���ʵ����</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(bean.getInit_reg_dt())%></td>
          </tr>
          <tr>
            <td class='title'>�뿩���</td>
            <td>&nbsp;
                <%if(bean.getRent_way().equals("1")) 			out.println("�Ϲݽ�");
              	else if(bean.getRent_way().equals("2"))  	out.println("�����");
              	else if(bean.getRent_way().equals("3")) 	out.println("�⺻��");%>
            </td>
            <td width='10%' class='title'>�뿩�Ⱓ</td>
            <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(bean.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(bean.getRent_end_dt())%>&nbsp;(<%=bean.getCon_mon()%>����)</td>
            <td class='title'>�������</td>
            <td width='15%'>&nbsp;<%=bean.getLeave_day()%>��</td>
          </tr>
          <% if(!bean.getCms_bank().equals("")){%>
          <tr>
            <td class='title'>�ڵ���ü</td>
            <td>&nbsp;<%=bean.getCms_bank()%></td>
            <td width='10%' class='title'>��ü�Ⱓ</td>
            <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(bean.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(bean.getCms_end_dt())%></td>
            <td class='title'>��ü����</td>
            <td width='15%'>&nbsp;�ſ� <%=bean.getCms_day()%>��</td>
          </tr>
          <% }%>
          <tr>
            <td class='title'>���౸��</td>
            <td>&nbsp;<%=bean.getPrint_st()%></td>
            <td class='title'>���࿵����</td>
            <td>&nbsp;<%=bean.getBr_nm()%></td>
            <td width='10%' class='title'>���޹޴���</td>
            <td width='15%' >&nbsp;<%=bean.getTax_type()%></td>
            <td class='title'>�׿���</td>
            <td>&nbsp;
            <% if(!bean.getVen_code().equals("")){%>
            (<%=bean.getVen_code()%>)<span title='<%=ven.get("VEN_NAME")%>'><%=Util.subData(String.valueOf(ven.get("VEN_NAME")), 4)%></span>
            <% }%>
            </td>
          </tr>
          <tr>
            <td class='title'>�������ּ�</td>
            <td colspan="3">&nbsp;(<%=bean.getP_zip()%>) <span title='<%=bean.getP_addr()%>'><%=Util.subData(bean.getP_addr(), 25)%></td>
            <td class='title'>������������</td>
            <td >&nbsp;<%=bean.getTax_agnt()%></td>
            <td class='title'>���ڹ����߱�</td>
            <td >&nbsp;<%=client.getEtax_not_cau()%></td>
          </tr>          
        </table>
        <% }else{%>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>��ȣ</td>
            <td colspan="3">&nbsp;<%=client.getFirm_nm()%>&nbsp;<%=client.getClient_id()%></td>
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
            </td>
          </tr>
          <tr>
            <td class='title'>�������ּ�</td>
            <td colspan="3">&nbsp;(<%=bean.getP_zip()%>) <span title='<%=bean.getP_addr()%>'><%=Util.subData(bean.getP_addr(), 25)%></td>
            <td class='title'>������������</td>
            <td >&nbsp;<%=bean.getTax_agnt()%></td>
            <td class='title'>���ڹ����߱�</td>
            <td >&nbsp;<%=client.getEtax_not_cau()%></td>
          </tr>
        </table>
        <% }%>
      </td>	  
    </tr>  
    <tr></tr><tr></tr>
    <tr>
      <td colspan="2" class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='10%' class='title'>�繫�ǹ�ȣ</td>
          <td width='15%'>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
          <td width="10%" class='title'>���ù�ȣ</td>
          <td width="15%">&nbsp;
              <%=AddUtil.phoneFormat(client.getH_tel())%></td>
          <td width="10%" class='title'>�ڵ�����ȣ</td>
          <td width="15%">&nbsp; <%=AddUtil.phoneFormat(client.getM_tel())%></td>
          <td width="10%" class='title'>�ѽ���ȣ</td>
          <td width="15%">&nbsp; <%=AddUtil.phoneFormat(client.getFax())%></td>
        </tr>
        <tr>
          <td class='title'>���̵�</td>
          <td>&nbsp;<%=m_bean.getMember_id()%></td>
          <td class='title'>��й�ȣ</td>
          <td>&nbsp;<%=m_bean.getPwd()%>
		  </td>
          <td class='title'>����ڹ�ȣ</td>
          <td>&nbsp; <%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
          <td class='title'>���ι�ȣ/�������</td>
          <td>&nbsp; <%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%></td>
        </tr>
		<% 	if(!client.getEtax_not_cau().equals("")){%>
        <tr>
          <td class='title'>�̸��ϼ��Űź�</td>
          <td colspan="7">&nbsp;<%=client.getEtax_not_cau()%></td>
        </tr>
		<%}%>		
        <tr>
          <td class='title'>reg_code</td>
          <td colspan="7">&nbsp;<%=reg_code%></td>
        </tr>
      </table></td>
    </tr>	
    <tr>
        <td><%if(t_bean.getGubun().equals("")){%><font color='red'><b>[���������]</b></font><%}%></td>
    </tr>
     <tr>
      <td colspan="2" align="center">
     		  <%if(!m_bean.getMember_id().equals("") && !m_bean.getMember_id().equals("amazoncar")){%>
		  <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?mode=1&client_id=<%=t_bean.getClient_id()%>&r_site=<%=t_bean.getSeq()%>&name=<%=m_bean.getMember_id()%>&passwd=<%=m_bean.getPwd()%>&s_yy=<%=t_bean.getTax_dt().substring(0,4)%>&s_mm=<%=t_bean.getTax_dt().substring(4,6)%>" target="_blank" onFocus="this.blur();"><img src=/acar/images/center/button_e_cfms.gif align=absmiddle border=0></a>&nbsp;
		  <%}else{
		  		String ssn = "";				
				if(client.getClient_st().equals("2")) 	ssn = client.getSsn1();
				else 								 	ssn = client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3();%>
		  <% 	if ( !m_bean.getMember_id().equals("") ) {%> 
		  <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?mode=2&client_id=<%=t_bean.getClient_id()%>&r_site=<%=t_bean.getSeq()%>&ssn=<%=ssn%>&s_yy=<%=t_bean.getTax_dt().substring(0,4)%>&s_mm=<%=t_bean.getTax_dt().substring(4,6)%>" target="_blank" onFocus="this.blur();"><img src=/acar/images/center/button_e_cfms.gif align=absmiddle border=0></a>&nbsp; 
		  <% 	} %> 
		  <%}%>
		  <%if(!t_bean.getResseq().equals("")){%>
		  <a href="http://fms1.amazoncar.co.kr/mailing/tax_bill/index_simple.jsp?gubun=2&client_id=<%=t_bean.getClient_id()%>&site_id=<%=t_bean.getSeq()%>&tax_no=<%=tax_no%>" target="_blank" onFocus="this.blur();"><img src=/acar/images/center/button_e_email.gif align=absmiddle border=0></a>
		  <%}%>
 	  </td>
    </tr>	
    
	<%}else{%>	
    <tr>
      <td colspan="2" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>	
          <tr>
            <td class='title' width="10%">reg_code</td>
            <td>&nbsp;<%=reg_code%></td>
          </tr>
        </table>
	  </td>
    </tr>		
	<%}%>
	

    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>		
	<% 	if(!t_bean.getResseq().equals("")){%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̸��� �߼�</span></td>
      <td align="right">
      	</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>���ϼ�����</td>
            <td colspan="5"><table border="0" cellspacing="1" cellpadding="0" width='650'>
              <tr>
                <td width='200'>&nbsp;��&nbsp;&nbsp;&nbsp;�� : <%=t_bean.getCon_agnt_nm()%></td>
                <td width='150'>�ٹ��μ� : <%=t_bean.getCon_agnt_dept()%></td>
                <td>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� : <%=t_bean.getCon_agnt_title()%></td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;EMAIL : <%=t_bean.getCon_agnt_email()%></td>
                <td>�̵���ȭ : <%=t_bean.getCon_agnt_m_tel()%></td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td width='10%' class='title'>�߰�������</td>
            <td colspan="5"><table border="0" cellspacing="1" cellpadding="0" width='650'>
              <tr>
                <td width='200'>&nbsp;��&nbsp;&nbsp;&nbsp;�� : <%=t_bean.getCon_agnt_nm2()%></td>
                <td width='150'>�ٹ��μ� : <%=t_bean.getCon_agnt_dept2()%></td>
                <td>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� : <%=t_bean.getCon_agnt_title2()%></td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;EMAIL : <%=t_bean.getCon_agnt_email2()%></td>
                <td>�̵���ȭ : <%=t_bean.getCon_agnt_m_tel2()%></td>
                </tr>
            </table></td>
          </tr>          
    	<% 	Vector vts = ScdMngDb.getMailHistoryList(tax_no, gubun2);
			int vt_size = vts.size();%>		
          <tr>
            <td width='10%' class='title'>����</td>
            <td width="20%" class='title'>�߼��Ͻ�</td>
            <td width="20%" class='title'>�̸����ּ�</td>
            <td width="30%" class='title'>�����Ͻ�</td>
            <td width="10%" class='title'>���ſ���</td>
            <td width="10%" class='title'>�߼ۻ���</td>
          </tr>
          <%	for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>		  
          <tr>
            <td align='center'><%=i+1%></td>
            <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>
            <td align='center'><%=ht.get("EMAIL")%></td>
            <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("OTIME")))%></td>
            <td align='center'><%=ht.get("OCNT_NM")%></td>
            <td align='center'><%=ht.get("MSGFLAG_NM")%><%//=ht.get("ERRCODE")%></td>
          </tr>
          <%	}%>				  
        </table>
      </td>
    </tr>
	<%}%>	
	<% 	if(!t_bean.getAutodocu_data_no().equals("")){%>	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
      <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ���ǥ</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>�ڵ���ǥ</td>
            <td>&nbsp;��ǥ���� : <%=t_bean.getAutodocu_write_date()%>, ��ǥ��ȣ : <%=t_bean.getAutodocu_data_no()%>
		  </td>
        </tr>	
        </table>
      </td>
    </tr>	
	<%	}%>
	<% 	if(!t_bean.getResseq().equals("")){%>	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
      <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>Ʈ������ & ����û���� ����</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>		 
    	<% 	Vector vts = ScdMngDb.getEbHistoryList_2010(tax_no, gubun2);
			int vt_size = vts.size();%>		
          <tr>
            <td width='10%' class='title'>����</td>
            <td width="20%" class='title'>�����Ͻ�</td>
            <td width="30%" class='title'>���ڹ�������</td>
            <td width="40%" class='title'>��Ÿ</td>
          </tr>
          <%	for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);
					  pubcode 		= String.valueOf(ht.get("PUBCODE"));
					  etax_reason 	= String.valueOf(ht.get("REASON"));
					  %>
          <tr>
            <td align='center'><%=i+1%></td>
            <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STATUSDATE")))%></td>
            <td align='center'><%=ht.get("STATUS_NM")%></td>
            <td>&nbsp;<%=ht.get("REASON")%></td>
          </tr>
          <%	}%>		
          <tr>
            <td width='10%' class='title'>Ʈ�������ڵ�</td>
            <td colspan="3">&nbsp;<%=t_bean.getResseq()%>&nbsp;( <%=pubcode%> )</td>
          </tr>		
    	<% 	vts = ScdMngDb.getEbNtsHistoryList_2010(tax_no, gubun2);
			vt_size = vts.size();%>		
          <tr>
            <td width='10%' class='title'>����</td>
            <td width="20%" class='title'>�����Ͻ�</td>
            <td width="10%" class='title'>����û���ۻ���</td>			
            <td width="15%" class='title'>����û���۰��</td>						
          </tr>
          <%	for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);
				      nts_issueid 	= String.valueOf(ht.get("NTS_ISSUEID"));
				      %>
          <tr>
            <td align='center'><%=i+1%></td>
            <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("NTS_DATETIME")))%></td>
            <td align='center'><%=ht.get("NTS_STAT_NM")%></td>
            <td>&nbsp;<%=ht.get("NTS_MSG")%>&nbsp;<%=ht.get("NTS_RESULT_CONT")%></td>						
          </tr>
          <%	}%>				  				  		    		 		  
          <tr>
            <td width='10%' class='title'>����û���ι�ȣ</td>
            <td colspan="3">&nbsp;<%=nts_issueid%></td>
          </tr>						  		    		 		  
        </table>
      </td>
    </tr>
	<%}%>
    <% if(t_bean.getTax_st().equals("M") || t_bean.getTax_st().equals("C") || !t_bean.getM_tax_no().equals("")){
          //���ݰ�꼭 ��ȸ
	        TaxCngBean tc_bean = IssueDb.getTaxCng(tax_no);
	        if(t_bean.getTax_st().equals("O")) tc_bean = IssueDb.getTaxCng(t_bean.getM_tax_no());
	        %>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
      <td colspan="2"><% if(t_bean.getTax_st().equals("C")){%>
      <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span>
      <%}else{%>
      <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span>
      <%}%></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>��һ���</td>
            <td colspan="3">&nbsp;<%=tc_bean.getCng_cau()%></td>
          </tr>
          <tr>
            <td class='title'>�������</td>
            <td width="40%">&nbsp;<%=AddUtil.ChangeDate2(tc_bean.getCng_dt())%></td>
            <td width="10%" class='title'>�����</td>
            <td width="40%">&nbsp;<%=c_db.getNameById(tc_bean.getCng_id(), "USER")%></td>
          </tr>
        </table>
      </td>
    </tr>
    <% }%>
    <tr>
        <td class=h></td>
    </tr>   
    <tr>
      <td colspan="2">
        <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
          <tbody>
           <tr>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 0px solid" width=64% height=38 rowspan=2 align="center"><p>�� �� �� �� �� (���޹޴��� ������)</p></td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=15 align="center">å �� ȣ</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" align=right width=21% height=15>&nbsp;<font color=#0166a9>��&nbsp; ȣ</font></td>
           </tr>
           <tr>
             <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=15 align="center">�Ϸù�ȣ </td>
              <td class=ledger_cont  style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=15 align="center">&nbsp;<%=tax_no%>
              </td>
            </tr>
          </tbody>
        </table>
        <table style="BORDER-COLLAPSE: collapse" cellspacing=0 cellpadding=0 width="100%">
          <tbody>
            <tr>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 0px solid" width=4% rowspan=4 align="center">
                ��<br>
                <br>
                ��<br>
                <br>
                ��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20 align="center" width="8%">��Ϲ�ȣ</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 0px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" colspan=2 height=20><%= AddUtil.ChangeEnp(String.valueOf(br.get("BR_ENT_NO")))%></td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 0px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20>
                <table cellspacing=0 cellpadding=0 align=right border=0>
                  <tbody>
                    <tr>
                      <td width=40 height=1></td>
                    </tr>
                  </tbody>
                </table>
              </td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" width=4% height=20 rowspan=4 align="center">
                ��<br>
                ��<br>
                ��<br>
                ��<br>
                ��</td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" width=8% height=20 align="center">��Ϲ�ȣ</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 2px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" colspan=3 height=20><%=AddUtil.ChangeEnp(i_enp_no)%><%if(!t_bean.getRecCoTaxRegNo().equals("")){%>&nbsp;(������ڹ�ȣ:<%=t_bean.getRecCoTaxRegNo()%>)<%}%></td>
            </tr>
            <tr>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=20 align="center"><p>�� ȣ<br>
                (���θ�)</p></td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=15% height=20>�ֽ�ȸ��Ƹ���ī </td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=8% height=20 align="center">�� ��<br>
                (��ǥ��)</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=15% height=20><%=br.get("BR_OWN_NM")%></td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20 align="center">�� ȣ<br>
                (���θ�)</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=20><%=i_firm_nm%></td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=8% height=20 align="center">�� ��<br>
                (��ǥ��)</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=15% height=13><%=i_client_nm%></td>
            </tr>
            <tr>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20 align="center">�� �� ��<br>
                �ּ� </td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height="20" colspan=3><%=br.get("BR_ADDR")%></td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=20 align="center">�� �� ��<br>
                �ּ�<br>
              </td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height="20" colspan=3><%=i_addr%></td>
            </tr>
            <tr>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20 align="center">�� ��</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20><%=br.get("BR_STA")%></td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20 align="center">�� ��</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20><%=br.get("BR_ITEM")%></td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20 align="center">�� ��</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20><%=i_sta%></td>
              <td class=ledger_titleB style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=20 align="center">�� ��</td>
              <td class=ledger_cont   style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 0px solid" height=13><%=i_item%></td>
            </tr>
          </tbody>
        </table>
        <table style="BORDER-COLLAPSE: collapse" cellspacing=0 cellpadding=0 width=100%>
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
                <input type="text" name="tax_bigo" size="40" value="<%=t_bean.getTax_bigo()%>" class="whitetext">
              </span></td>
            </tr>
            <tr>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_y" size="4" value="<%=t_bean.getTax_dt().substring(0,4)%>" class="whitetext"></td>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_m" size="2" value="<%=t_bean.getTax_dt().substring(4,6)%>" class="whitetext" onBlur="javascript:document.form1.tax_m.value=this.value;"></td>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="req_d" size="2" value="<%=t_bean.getTax_dt().substring(6,8)%>" class="whitetext" onBlur="javascript:document.form1.tax_d.value=this.value;"></td>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="gongran" size="1" value="<%=11-tax_supply.length()%>" class="whitetext"></td>
              <%for(int i=0; i<11-tax_supply.length(); i++){%>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="s_amt" size="1" value="" class="whitetext"></td>
              <%}%>
              <%for(int i=0; i<tax_supply.length(); i++){%>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="s_amt" size="1" value="<%=tax_supply.charAt(i)%>" class="whitetext"></td>
              <%}%>
              <%for(int i=0; i<10-tax_value.length(); i++){%>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="v_amt" size="1" value="" class="whitetext"></td>
              <%}%>
              <%for(int i=0; i<tax_value.length(); i++){%>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" height=25 align="center"><input type="text" name="v_amt" size="1" value="<%=tax_value.charAt(i)%>" class="whitetext"></td>
              <%}%>
            </tr>
          </tbody>
        </table>
        <table style="BORDER-COLLAPSE: collapse" cellspacing=0 bordercolordark=white cellpadding=0 width=100% bordercolorlight=#0166a9>
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
			<%if(ti_bean.getEtax_item_st().equals("2")){//�׸� ��� ǥ��%>
			<% for(int i = 0 ; i < til_size ; i++){
        			    TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);%>
            <tr>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_m" size="2" value="<%if(til_bean.getItem_dt().length() >= 8){%><%=til_bean.getItem_dt1().substring(4,6)%><%}%>" class="whitetext"></td>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_d" size="2" value="<%if(til_bean.getItem_dt().length() >= 8){%><%=til_bean.getItem_dt1().substring(6,8)%><%}%>" class="whitetext"></td>
              <td class=ledger_cont  style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25>&nbsp;<span class="ledger_contC">
               <%if(AddUtil.parseInt(t_bean.getReg_dt()) >= 20100929 && t_bean.getGubun().equals("1") && !til_bean.getTm().equals("") && !client.getTm_print_yn().equals("N")){%>
			   <%=til_bean.getTm()%>ȸ��
			   <%}%>
			    <input type="text" name="tax_g" size="25" value="<%=til_bean.getItem_g()%> <%=til_bean.getItem_car_no()%> <%=til_bean.getItem_car_nm()%>" class="whitetext">
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                <input type="text" name="tax_supply" size="11" value="<%=Util.parseDecimal(til_bean.getItem_supply())%>" class="whitenum" readonly>
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                <input type="text" name="tax_value" size="10" value="<%=Util.parseDecimal(til_bean.getItem_value())%>" class="whitenum" readonly>
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
            </tr>			
			<%}%>
			<%}else{//�׸� ���ٸ� ǥ��%>
            <tr>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_m" size="2" value="<%=t_bean.getTax_dt().substring(4,6)%>" class="whitetext"></td>
              <td class=ledger_contC style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" width=4% height=25 align="center"><input type="text" name="tax_d" size="2" value="<%=t_bean.getTax_dt().substring(6,8)%>" class="whitetext"></td>
              <td class=ledger_cont  style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25>&nbsp;<span class="ledger_contC">
               <%if(AddUtil.parseInt(t_bean.getReg_dt()) >= 20100929 && t_bean.getGubun().equals("1") && !t_bean.getFee_tm().equals("") && !client.getTm_print_yn().equals("N")){%>
			   <%=t_bean.getFee_tm()%>ȸ��
			   <%}%>
			    <input type="text" name="tax_g" size="25" value="<%=t_bean.getTax_g()%>" class="whitetext">
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                <input type="text" name="tax_supply" size="11" value="<%=Util.parseDecimal(t_bean.getTax_supply())%>" class="whitenum" readonly>
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25 align="center"><span class="ledger_contC">
                <input type="text" name="tax_value" size="10" value="<%=Util.parseDecimal(t_bean.getTax_value())%>" class="whitenum" readonly>
              </span></td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 2px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 1px solid" height=25></td>
            </tr>
			<%}%>
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
                      <td width="45%"><input type="radio" name="pubform" value="R" <%if(t_bean.getPubForm().equals("R")){%>checked<%}%>>����<br>
                          <input type="radio" name="pubform" value="D" <%if(t_bean.getPubForm().equals("D")){%>checked<%}%>>û�� </td>
                      <td width="8%">��</td>
                    </tr>
                  </tbody>
              </table></td>
            </tr>
            <tr>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 2px solid; BORDER-BOTTOM: #0166a9 2px solid" height=30 align="center"><span class="ledger_contC">
                <input type="text" name="tax_amt" size="11" value="<%=Util.parseDecimal(t_bean.getTax_supply()+t_bean.getTax_value())%>" class="whitenum">
              </span>��</td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
              <td class=ledger_cont style="BORDER-RIGHT: #0166a9 1px solid; BORDER-TOP: #0166a9 1px solid; BORDER-LEFT: #0166a9 1px solid; BORDER-BOTTOM: #0166a9 2px solid" width=100 height=30 align="right">&nbsp; 0 </td>
            </tr>
          </tbody>
        </table></td>
    </tr>	
    <%if(!ti_bean.getItem_id().equals("")){%>
    <tr>
      <td colspan="2"></td>
    </tr>
    <tr>
      <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td style="border: #000000 2px solid" align="center" valign="middle"><table width="95%" border="0" cellspacing="0" cellpadding="0" height="95%">
              <tr>
                <td height="20">&nbsp;</td>
                <td height="20">&nbsp;</td>
                <td height="20">&nbsp;</td>
              </tr>
              <tr>
                <td width="260">&nbsp;</td>
                <td align="center" width="180" style="border-bottom: #000000 1px solid" height="30"><font size="5">�� �� �� �� ��</font></td>
                <td width="260">&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td align="center" height="25" valign="bottom">(�� �� ��)</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="50%" height="40">&nbsp;</td>
                      <td width="5%">&nbsp;</td>
                      <td rowspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td height="150" rowspan="5" width="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">��<br>
                                <br>
                        ��<br>
                        <br>
                        ��</td>
                            <td height="30" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">��Ϲ�ȣ</td>
                            <td height="30" colspan="3" align="center" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-right: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%= AddUtil.ChangeEnp(String.valueOf(br.get("BR_ENT_NO")))%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">��ȣ</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont">�ֽ�ȸ��Ƹ���ī </span></td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_OWN_NM")%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">�����<br>�ּ�</td>
                            <td height="30" colspan="3" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_ADDR")%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%=br.get("BR_STA")%></span></td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("BR_ITEM")%></span></td>
                          </tr>
                          <tr>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">��ǥ��ȭ</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><span class="ledger_cont"><%=br.get("TEL")%></span>&nbsp;</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">�ѽ�</td>
                            <td height="30" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;"><span class="ledger_cont"><%=br.get("FAX")%></span>&nbsp;</td>
                          </tr>
                      </table></td>
                    </tr>
                    <tr>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td height="22" width="20%">��&nbsp;��&nbsp;��&nbsp;ȣ</td>
                            <td height="22" width="5%" align="center">:</td>
                            <td height="22" colspan="2">&nbsp;&nbsp;<span class="ledger_cont"><%=ti_bean.getItem_id()%></span></td>
                            <td height="22" width="17%">&nbsp;</td>
                          </tr>
                          <tr>
                            <td height="22">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</td>
                            <td height="22" align="center">:</td>
                            <td height="22" colspan="2">&nbsp;&nbsp;<span class="ledger_cont"><%=AddUtil.ChangeDate2(ti_bean.getItem_dt())%></span></td>
                            <td height="22">&nbsp;</td>
                          </tr>
                          <tr>
                            <td height="22">��ȣ&nbsp;(����)</td>
                            <td height="22" align="center">:</td>
                            <td height="22" colspan="3">&nbsp;&nbsp;<span class="ledger_cont">
							<%=i_firm_nm%>
							</span></td>
                          </tr>
                          <tr>
                            <td height="22" colspan="5"><b>�Ʒ��� ���� ����մϴ�.</b></td>
                          </tr>
                          <tr>
                            <td height="22">��&nbsp;��&nbsp;��&nbsp;��</td>
                            <td height="22" align="center">:</td>
                            <td height="22" width="10%" style="border-bottom: #000000 1px solid">�ϱ�</td>
                            <td height="22" style="border-bottom: #000000 1px solid" align="right" width="48%"><span class="ledger_cont"><%=ti_bean.getItem_hap_str()%></span></td>
                            <td height="22" align="right" style="border-bottom: #000000 1px solid">��(��+��)</td>
                          </tr>
                      </table></td>
                      <td>&nbsp;</td>
                    </tr>
                </table></td>
              </tr>
              <tr>
                <td height="20" align="right">(��<span class="ledger_cont"><%=Util.parseDecimal(ti_bean.getItem_hap_num())%></span>)</td>
                <td height="30" rowspan="2">&nbsp;</td>
                <td height="30" align="right" rowspan="2">�ۼ��� : &nbsp;<span class="ledger_cont"><%=ti_bean.getItem_man()%></span>&nbsp;</td>
              </tr>
              <tr>
                <td height="15" align="right">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="center" bgcolor="#CCCCCC">
                      <td rowspan="2" width="30" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                      <td rowspan="2" width="150" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">�ŷ�����</td>
                      <td rowspan="2" width="90" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">������ȣ</td>
                      <td rowspan="2" width="200" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">����</td>
                      <td height="20" colspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">û��(�ŷ�)������</td>
                      <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">���ް���</td>
                      <td rowspan="2" width="60" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">����</td>
                      <td rowspan="2" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid;">�հ�</td>
                      <td rowspan="2" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">���</td>
                    </tr>
                    <tr>
                      <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~����</td>
                      <td height="20" width="70" bgcolor="#CCCCCC" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">~����</td>
                    </tr>
                    <% for(int i = 0 ; i < til_size ; i++){
										    TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);%>
                    <tr>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=i+1%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">
					  <%if(!til_bean.getReg_dt().equals("") && AddUtil.parseInt(AddUtil.replace(til_bean.getReg_dt().substring(0,10),"-","")) >= 20100929 && til_bean.getGubun().equals("1") && !til_bean.getTm().equals("") && !client.getTm_print_yn().equals("N")){%>
			          <%=til_bean.getTm()%>ȸ��
			          <%}%>
					  <%=til_bean.getItem_g()%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=til_bean.getItem_car_no()%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=til_bean.getItem_car_nm()%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=AddUtil.ChangeDate2(til_bean.getItem_dt1())%></td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=AddUtil.ChangeDate2(til_bean.getItem_dt2())%></td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(til_bean.getItem_supply())%>&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(til_bean.getItem_value())%>&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;"><%=Util.parseDecimal(til_bean.getItem_supply()+til_bean.getItem_value())%>&nbsp;</td>
                      <td height="22" align="left" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;<%=til_bean.getEtc()%></td>
                    </tr>
                    <%  item_s_amt = item_s_amt  + Long.parseLong(String.valueOf(til_bean.getItem_supply()));
										    item_v_amt = item_v_amt  + Long.parseLong(String.valueOf(til_bean.getItem_value()));
									     }%>
                    <% if(til_size < 10){%>
                    <% for(int i = 0 ; i < 10-til_size ; i++){%>
                    <tr>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;">&nbsp;</td>
                      <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                    </tr>
                    <% }%>
                    <% }%>
                    <tr>
                      <td height="22" colspan="6" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>�հ�<!--(��)--></b></font></td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_s_amt)%>&nbsp;</td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_v_amt)%>&nbsp;</td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid;" align="right"><%=Util.parseDecimal(item_s_amt+item_v_amt)%>&nbsp;</td>
                      <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid" align="right">&nbsp;</td>
                    </tr>
                </table></td>
              </tr>
              <tr>
                <td colspan="3"><font size="1">�� ���Ұ��(�뿩��) : (���뿩�ᥪ�뿩�ϼ�)��30��</font></td>
              </tr>

              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td><font size="3"><b>�� ��Ÿ</b></font></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="center" bgcolor="#CCCCCC">
                      <td height="25" width="110" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">û������</td>
                      <td height="25" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC">����</td>
                      <td height="25" width="70" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid">�ݾ�</td>
                      <td height="25" width="130" style="border-top: #000000 1px solid; border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid;">���</td>
                    </tr>
                    <% 	for(int i = 0 ; i < tik_size ; i++){
            					TaxItemKiBean tik_bean = (TaxItemKiBean)tiks.elementAt(i);%>
                                <tr>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=tik_bean.getItem_ki_g()%></td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;<%=tik_bean.getItem_ki_app()%></td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid"><%=Util.parseDecimal(tik_bean.getItem_ki_pr())%>&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;<%=tik_bean.getItem_ki_bigo()%></td>
                                </tr>
                                <%		item_s_amt2 = item_s_amt2  + Long.parseLong(String.valueOf(tik_bean.getItem_ki_pr()));
            				}%>
                                <%	for(int i = 0 ; i < 5-tik_size ; i++){%>
                                <tr>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="right" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid">&nbsp;</td>
                                  <td height="22" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                </tr>
                                <%	}%>
                                <tr>
                                  <td height="22" colspan="2" align="center" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" bgcolor="#CCCCCC"><font size="3"><b>�հ�<!--(��)--></b></font></td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid" align="right"><%=Util.parseDecimal(item_s_amt2)%>&nbsp;</td>
                                  <td height="22" style="border-left: #000000 1px solid; border-bottom: #000000 1px solid; border-right: #000000 1px solid">&nbsp;</td>
                                </tr>
                </table></td>
              </tr>
              
              <tr>
                <td height="20">&nbsp;</td>
                <td height="20">&nbsp;</td>
                <td height="20">&nbsp;</td>
              </tr>
          </table></td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>	
    <%}%>    
    <tr>
      <td colspan="2" align="right">&nbsp;	</td>
    </tr>		
  </table>
  
  <input type='hidden' name="etax_reason" value="<%=etax_reason%>">
<script language="JavaScript">
<!--
//-->
</script>  
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>