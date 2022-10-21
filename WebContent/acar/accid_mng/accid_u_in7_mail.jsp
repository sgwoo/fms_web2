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
	
	//사고대차 중 사고발생시 거래명세서의 고객데이터를 원계약의 고객으로 업데이트(20181217)
	boolean upd_client = false; 
	if(!rent_s_cd.equals("")){
		upd_client = IssueDb.updateClient_idInTax_item(rent_s_cd, item_id);
	}
	
	//거래명세서 조회
	TaxItemBean ti_bean 		= IssueDb.getTaxItemCase(item_id);
	//거래명세서 리스트 조회
	Vector tils	            = IssueDb.getTaxItemScdListCase(item_id);
	int til_size            = tils.size();
	
	//거래처정보
	ClientBean client       = al_db.getClient(ti_bean.getClient_id().trim());
	//거래처지점정보
	ClientSiteBean site     = al_db.getClientSite(ti_bean.getClient_id(), ti_bean.getSeq());
	
	//고객FMS
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
				
		if(confirm('메일을 재발행 하시겠습니까?')){
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
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>이메일 발송</span></td>
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
            <td width='10%' class='title'>연번</td>
            <td width="20%" class='title'>발송일시</td>
            <td width="20%" class='title'>이메일주소</td>
            <td width="30%" class='title'>열람일시</td>
            <td width="10%" class='title'>수신여부</td>
            <td width="10%" class='title'>발송상태</td>
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
            <td width='10%' class='title'>메일수신자</td>
            <td colspan="5"><table border="0" cellspacing="1" cellpadding="0" width='90%'>
			  <%if(!ti_bean.getSeq().equals("") && !site.getAgnt_email().equals("")){%>
              <tr>
                <td>
								&nbsp;이&nbsp;&nbsp;&nbsp;름 : <input type='text' size='20' name='con_agnt_nm' value='<%=site.getAgnt_nm()%>' maxlength='20' class='text' style='IME-MODE: active'>
                &nbsp;&nbsp;EMAIL : <input type='text' size='30' name='con_agnt_email' value='<%=site.getAgnt_email()%>' maxlength='40' class='text' style='IME-MODE: inactive'>
                &nbsp;&nbsp;이동전화 : <input type='text' size='20' name='con_agnt_m_tel' value='<%=site.getAgnt_m_tel()%>' maxlength='20' class='text'>
								&nbsp;&nbsp;<a href="javascript:Remail();"><img src="/acar/images/center/button_jbh.gif" align="absmiddle" border="0"></a>
				</td>
              </tr>
			  <%}else{%>
              <tr>
                <td>
								&nbsp;이&nbsp;&nbsp;&nbsp;름 : <input type='text' size='20' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text' style='IME-MODE: active'>
                &nbsp;&nbsp;EMAIL : <input type='text' size='30' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='40' class='text' style='IME-MODE: inactive'>
                &nbsp;&nbsp;이동전화 : <input type='text' size='20' name='con_agnt_m_tel' value='<%=client.getCon_agnt_m_tel()%>' maxlength='20' class='text'>
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
        <td><font color=red>* 거래명세서메일수신여부가 거부입니다.</font></td>
    </tr>
    <%}%>
</table>
<%if(!rent_s_cd.equals("") && upd_client == false){ %>
<div style="margin-top: 10px;">※ 원계약의 고객정보가 제대로 반영되지 않아 발송한 메일을 통한 거래명세서가 열리지 않을수 있습니다. 전산팀에 문의하세요.</div>
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