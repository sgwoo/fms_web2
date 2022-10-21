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
	String ebill_st 	= request.getParameter("ebill_st")==null?"2":request.getParameter("ebill_st");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String flist = request.getParameter("flist")==null?"":request.getParameter("flist");
	String pubcode = "";
	long item_s_amt = 0;
	long item_v_amt = 0;
	int height = 0;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "07", "01");
	
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
	
	if(t_bean.getTax_no().equals("")){
		out.println("계산서 일련번호가 맞지 않습니다. 확인하십시오.");
		return;
	}
	
	//공급자
	Hashtable br            = c_db.getBranch(t_bean.getBranch_g().trim());
	
	//거래처정보
	ClientBean client       = al_db.getClient(t_bean.getClient_id().trim());
	
	//거래처지점정보
	ClientSiteBean site     = al_db.getClientSite(t_bean.getClient_id(), t_bean.getSeq());
	
	//네오엠 거래처 정보
	Hashtable ven           = neoe_db.getVendorCase(client.getVen_code());
	
	//장기계약 상단정보
	LongRentBean bean       = ScdMngDb.getScdMngLongRentInfo("", t_bean.getRent_l_cd().trim());
	
	//업무대여일때
	UserMngDatabase umd = UserMngDatabase.getInstance();
	if(t_bean.getGubun().equals("13")){
		user_bean = umd.getUsersBean(t_bean.getClient_id().trim());
	}
	
	MemberBean m_bean = m_db.getMemberCase(t_bean.getClient_id(), t_bean.getSeq(), "");
	if(m_bean.getMember_id().equals("")) m_bean = m_db.getMemberCase(t_bean.getClient_id(), "", "");
	
	String tax_supply = String.valueOf(t_bean.getTax_supply());
	String tax_value = String.valueOf(t_bean.getTax_value());
	String i_enp_no = client.getEnp_no1() +"-"+ client.getEnp_no2() +"-"+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +"-"+ client.getSsn2();
	String i_firm_nm = client.getFirm_nm();
	String i_client_nm = client.getClient_nm();
	String i_addr = client.getO_addr();
	String i_sta = client.getBus_cdt();
	String i_item = client.getBus_itm();
	
	if(t_bean.getGubun().equals("13")){
		  i_enp_no = user_bean.getUser_ssn1()+"-"+user_bean.getUser_ssn2();
		  i_firm_nm = user_bean.getUser_nm();
		  i_client_nm = "";
		  i_addr = user_bean.getAddr();
		  i_sta = "";
		  i_item = "";
	}else{
		if(t_bean.getTax_type().equals("2") && !site.getClient_id().equals("")){
		  i_enp_no = site.getEnp_no();
		  i_firm_nm = site.getR_site();
		  i_client_nm = site.getSite_jang();
		  i_addr = site.getAddr();
		  i_sta = site.getBus_cdt();
		  i_item = site.getBus_itm();
		}
	}
	
	if(!t_bean.getRecCoName().equals("")){
		  i_enp_no 		= t_bean.getRecCoRegNo		();
		  i_firm_nm 	= t_bean.getRecCoName		();
		  i_client_nm 	= t_bean.getRecCoCeo		();
		  i_addr 		= t_bean.getRecCoAddr		();
		  i_sta 		= t_bean.getRecCoBizType	();
		  i_item 		= t_bean.getRecCoBizSub		();
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
	function Ebill_reg(){
		var fm = document.form1;	
		if(fm.tax_no.value == '')			{	alert('세금계산서 일련번호가 없습니다. 확인하십시오.'); return; }
		
		if(toInt(fm.msglen.value) > 80)		{	alert('문자내용이 80byte를 초과합니다.'); return; }
		
		if(fm.ebill_st[0].checked == false && fm.ebill_st[1].checked == false && fm.ebill_st[2].checked == false && fm.ebill_st[3].checked == false && fm.ebill_st[4].checked == false && fm.ebill_st[5].checked == false){
			alert("구분을 선택하십시오.");
			return;
		}

		if(fm.ebill_st[0].checked == true || fm.ebill_st[1].checked == true){
			if(fm.con_agnt_email.value == '')	{	alert('수신메일주소를 입력하십시오.'); return; }
		}

		if(fm.ebill_st[3].checked == true || fm.ebill_st[4].checked == true){
			if(fm.con_agnt_email2.value == '')	{	alert('추가수신자 수신메일주소를 입력하십시오.'); return; }
		}

				  
		if(confirm('등록 하시겠습니까?'))
		{
			fm.target = "i_no";
			fm.action = "saleebill_reg_a2.jsp";
			fm.submit();
		}	
	}
	
//메시지 입력시 string() 길이 체크
function checklen()
{
	var msgtext, msglen;
	
	msgtext = document.form1.msg.value;
	msglen = document.form1.msglen.value;
	
	var i=0,l=0;
	var temp,lastl;
	
	//길이를 구한다.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>80)
		{
			alert("메시지란에 허용 길이 이상의 글을 쓰셨습니다.\n 메시지란에는 한글 40자, 영문80자까지만 쓰실 수 있습니다.");
			temp = document.form1.msg.value.substr(0,i);
			document.form1.msg.value = temp;
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}
	form1.msglen.value=l;
}
	
	//문자열 일정길이 자르기
	function charRound(f, b_len){	
	
		var max_len = f.length;
		var ff = '';
		var len = 0;
		
		for(k=0;k<max_len;k++) {
		
			if(len >= b_len) break; //지정길이보다 길면 종료
			
			t = f.charAt(k);			
			ff += t;
			
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}	
		return ff;			
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
  <input type="hidden" name="flist" value="<%=flist%>">  
  <input type="hidden" name="tax_dt" value="<%=t_bean.getTax_dt()%>">  
  <input type='hidden' name="firm_nm" value="<%=i_firm_nm%>">
  <input type='hidden' name="tax_mon" value="<%=t_bean.getTax_dt().substring(4,6)%>">  
  <input type='hidden' name="pubCode" value="">    
  <input type='hidden' name="docType" value="">
  <input type='hidden' name="userType" value=""> 
  <input type="hidden" name="tax_bigo_t" value="<%=t_bean.getTax_bigo()%>">           
  <table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > 세금계산서보관함 ><span class=style5>
						세금계산서</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	

	    <tr>
	      <td colspan=2><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>전자세금계산서</span></td>
	    </tr>
	    <tr>
			<td class=line2 colspan=2></td>
		</tr> 
	    <tr>
	      <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	          <tr>
	            <td width='10%' class='title'>구분</td>
	            <td colspan="5"><table width="100%"  border="0" cellpadding="1">
	              <tr>
	                <td><input type="radio" name="ebill_st" value="2" <%if(ebill_st.equals("2"))%>checked<%%>>
						이메일발송+문자발송</td>
	              </tr>
	              <tr>
	                <td><input type="radio" name="ebill_st" value="4" <%if(ebill_st.equals("4"))%>checked<%%>>
						이메일발송</td>
	              </tr>
	              <tr>
	                <td><input type="radio" name="ebill_st" value="5" <%if(ebill_st.equals("5"))%>checked<%%>>
						문자발송</td>
	              </tr>
	              <tr>
	                <td><input type="radio" name="ebill_st" value="6" <%if(ebill_st.equals("6"))%>checked<%%>>
						추가수신자 이메일발송+문자발송</td>
	              </tr>
	              <tr>
	                <td><input type="radio" name="ebill_st" value="7" <%if(ebill_st.equals("7"))%>checked<%%>>
						추가수신자 이메일발송</td>
	              </tr>
	              <tr>
	                <td><input type="radio" name="ebill_st" value="8" <%if(ebill_st.equals("8"))%>checked<%%>>
						추가수신자 문자발송</td>
	              </tr>	              
	            </table></td>
	          </tr>
	          <tr>
	            <td class='title'>메일수신자</td>
	            <td colspan='5'>&nbsp;
	            	<input type="checkbox" name="angt_cng" value="Y" checked>변경    
				</td>
	          </tr>			  
			  <%if(t_bean.getTax_type().equals("2") && !site.getAgnt_email().equals("")){%>
	          <tr>
	            <td width='10%' class='title'>이름</td>
	            <td width='20%'>&nbsp;
	                <input type='text' size='15' name='con_agnt_nm' value='<%=site.getAgnt_nm()%>' maxlength='20' class='text'></td>
	            <td width="10%" class='title'>근무부서</td>
	            <td width="20%">&nbsp;
	                <input type='text' size='15' name='con_agnt_dept' value='<%=site.getAgnt_dept()%>' maxlength='15' class='text'></td>
	            <td width="10%" class='title'>직위</td>
	            <td width="30%">&nbsp;
	                <input type='text' size='15' name='con_agnt_title' value='<%=site.getAgnt_title()%>' maxlength='10' class='text'></td>
	          </tr>	          
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td colspan='5'>&nbsp;
	                <input type='text' size='40' name='con_agnt_email' value='<%=site.getAgnt_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'></td>
	          </tr>
	          <tr>
	            <td class='title'>이동전화</td>
	            <td colspan='5'>&nbsp;
	              <input type='text' size='15' name='con_agnt_m_tel' value='<%=site.getAgnt_m_tel()%>' maxlength='15' class='text'></td>
	          </tr>
	          <tr>
	            <td class='title'>추가수신자</td>
	            <td colspan='5'>&nbsp;이름 :
	              <input type='text' size='15' name='con_agnt_nm2' value='<%=site.getAgnt_nm2()%>' maxlength='15' class='text'>
	              &nbsp;EMAIL :
	              <input type='text' size='15' name='con_agnt_email2' value='<%=site.getAgnt_email2()%>' maxlength='15' class='text'>
	              &nbsp;이동전화 :
	              <input type='text' size='15' name='con_agnt_m_tel2' value='<%=site.getAgnt_m_tel2()%>' maxlength='15' class='text'>
	            </td>
	          </tr>	          
			  <%}else{%>
	          <tr>
	            <td width='10%' class='title'>이름</td>
	            <td width='20%'>&nbsp;
	                <input type='text' size='15' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text'></td>
	            <td width="10%" class='title'>근무부서</td>
	            <td width="20%">&nbsp;
	                <input type='text' size='15' name='con_agnt_dept' value='<%=client.getCon_agnt_dept()%>' maxlength='15' class='text'></td>
	            <td width="10%" class='title'>직위</td>
	            <td width="30%">&nbsp;
	                <input type='text' size='15' name='con_agnt_title' value='<%=client.getCon_agnt_title()%>' maxlength='10' class='text'></td>
	          </tr>
	          <tr>
	            <td class='title'>EMAIL</td>
	            <td colspan='5'>&nbsp;
	                <input type='text' size='40' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'></td>
	          </tr>
	          <tr>
	            <td class='title'>이동전화</td>
	            <td colspan='5'>&nbsp;
	              <input type='text' size='15' name='con_agnt_m_tel' value='<%=client.getCon_agnt_m_tel()%>' maxlength='15' class='text'></td>
	          </tr>
	          <tr>
	            <td class='title'>추가수신자</td>
	            <td colspan='5'>&nbsp;이름 :
	              <input type='text' size='15' name='con_agnt_nm2' value='<%=client.getCon_agnt_nm2()%>' maxlength='15' class='text'>
	              &nbsp;EMAIL :
	              <input type='text' size='15' name='con_agnt_email2' value='<%=client.getCon_agnt_email2()%>' maxlength='15' class='text'>
	              &nbsp;이동전화 :
	              <input type='text' size='15' name='con_agnt_m_tel2' value='<%=client.getCon_agnt_m_tel2()%>' maxlength='15' class='text'>
	            </td>
	          </tr>	  	          
			  <%}%>		  
	          <tr>
	            <td class='title'>문자내용</td>
	            <td colspan='5'>&nbsp;
	              <input type='text' size='80' name='msg' value='<%=client.getFirm_nm()%>님 <%=t_bean.getTax_dt().substring(4,6)%>월 세금계산서를 발행하였습니다.-아마존카-' maxlength='80' class='text' onKeyUp="javascript:checklen()">
				  <input class="phonemsglen" type="text" name="msglen" size="2" maxlength="2" readonly value=0>/80byte</td>
	          </tr>
	      </table></td>
	    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="right">
          <a href="javascript:Ebill_reg();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
          
		  &nbsp;<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
      </td>
    </tr>		
  </table>
</form>	

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	var msgtext, msglen;
	
	msgtext = document.form1.msg.value;
	msglen = document.form1.msglen.value;
	
	var i=0,l=0;
	var temp,lastl;
	
	//길이를 구한다.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>80)
		{
			alert("메시지란에 허용 길이 이상의 글을 쓰셨습니다.\n 메시지란에는 한글 40자, 영문80자까지만 쓰실 수 있습니다.");
			temp = document.form1.msg.value.substr(0,i);
			document.form1.msg.value = temp;
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}
	form1.msglen.value=l;
//-->
</script>

</body>
</html>
