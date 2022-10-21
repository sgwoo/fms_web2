<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.client.*, cust.member.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>


<%	
	String item_id 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_s_cd 	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String reg_code = "";
	long item_s_amt = 0;
	long item_v_amt = 0;
	int height = 0;
	
	//������ �� ���߻��� �ŷ������� �������͸� ������� ������ ������Ʈ(20181217)
	boolean upd_client = false; 
	if(!rent_s_cd.equals("")){
		upd_client = IssueDb.updateClient_idInTax_item(rent_s_cd, item_id);
	}
	
	//�ŷ����� ��ȸ
	TaxItemBean ti_bean 		= IssueDb.getTaxItemCase(item_id);
	//�ŷ����� ����Ʈ ��ȸ
	Vector tils	            = IssueDb.getTaxItemScdListCase(item_id);
	int til_size            = tils.size();
	
	//�ŷ�ó����
	ClientBean client       = al_db.getClient(ti_bean.getClient_id().trim());
	//�ŷ�ó��������
	ClientSiteBean site     = al_db.getClientSite(ti_bean.getClient_id(), ti_bean.getSeq());
	
	//��FMS
	MemberBean m_bean = m_db.getMemberCase(ti_bean.getClient_id(), ti_bean.getSeq(), "");
	if(m_bean.getMember_id().equals("")) m_bean = m_db.getMemberCase(ti_bean.getClient_id(), "", "");
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	
	function Remail(){
		var fm = document.form1;		
				
		if(confirm('������ ����� �Ͻðڽ��ϱ�?')){
			fm.action = '/acar/accid_mng/accid_u_in7_mail_a.jsp';
			fm.target = 'TaxItem';
			fm.submit();		
		}			
	}
	

//-->
</script>
</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="item_id" value="<%=item_id%>">  
  <input type="hidden" name="item_size" value="<%=til_size%>">
  <input type="hidden" name="client_id" value="<%=ti_bean.getClient_id()%>">  
  <input type="hidden" name="seq" value="<%=ti_bean.getSeq()%>">  
  <input type="hidden" name="from_page" value="accid_u_in7_mail.jsp">
  <input type="hidden" name="item_hap_num" value="">
<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
	<% for(int i = 0 ; i < til_size ; i++){
				TaxItemListBean til_bean = (TaxItemListBean)tils.elementAt(i);
				reg_code = til_bean.getReg_code();%>
				<input type='hidden' name="item_seq" value="<%=til_bean.getItem_seq()%>">
  <%}%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̸��� �߼�</span></td>
      <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>	
		  
    	<% 	Vector vts = ScdMngDb.getTaxItemMailHistoryList(item_id);
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
            <td align='center'><%=ht.get("MSGFLAG_NM")%></td>
          </tr>
          <%	}%>				  
        </table>
      </td>
    </tr>
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>���ϼ�����</td>
            <td colspan="5"><table border="0" cellspacing="1" cellpadding="0" width='90%'>
			  <%if(!ti_bean.getSeq().equals("") && !site.getAgnt_email().equals("")){%>
              <tr>
                <td>
								&nbsp;��&nbsp;&nbsp;&nbsp;�� : <input type='text' size='20' name='con_agnt_nm' value='<%=site.getAgnt_nm()%>' maxlength='20' class='text' style='IME-MODE: active'>
                &nbsp;&nbsp;EMAIL : <input type='text' size='30' name='con_agnt_email' value='<%=site.getAgnt_email()%>' maxlength='40' class='text' style='IME-MODE: inactive'>
                &nbsp;&nbsp;�̵���ȭ : <input type='text' size='20' name='con_agnt_m_tel' value='<%=site.getAgnt_m_tel()%>' maxlength='20' class='text'>
								&nbsp;&nbsp;<a href="javascript:Remail();"><img src="/acar/images/center/button_jbh.gif" align="absmiddle" border="0"></a>
				</td>
              </tr>
			  <%}else{%>
              <tr>
                <td>
								&nbsp;��&nbsp;&nbsp;&nbsp;�� : <input type='text' size='20' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text' style='IME-MODE: active'>
                &nbsp;&nbsp;EMAIL : <input type='text' size='30' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='40' class='text' style='IME-MODE: inactive'>
                &nbsp;&nbsp;�̵���ȭ : <input type='text' size='20' name='con_agnt_m_tel' value='<%=client.getCon_agnt_m_tel()%>' maxlength='20' class='text'>
								&nbsp;&nbsp;<a href="javascript:Remail();"><img src="/acar/images/center/button_jbh.gif" align="absmiddle" border="0"></a>
				</td>
              </tr>			  
			  <%}%>
            </table></td>
          </tr>
        </table>
      </td>
    </tr>	
    <%if(client.getItem_mail_yn().equals("N")){%>
    <tr>
        <td><font color=red>* �ŷ��������ϼ��ſ��ΰ� �ź��Դϴ�.</font></td>
    </tr>
    <%}%>
</table>
<%if(!rent_s_cd.equals("") && upd_client == false){ %>
<div style="margin-top: 10px;">�� ������� �������� ����� �ݿ����� �ʾ� �߼��� ������ ���� �ŷ������� ������ ������ �ֽ��ϴ�. �������� �����ϼ���.</div>
<%} %>
<script language="JavaScript">
<!--
//-->
</script>  
<input type="hidden" name="reg_code" value="<%=reg_code%>">
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>