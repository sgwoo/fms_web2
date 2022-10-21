<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_register.*, acar.cont.*, acar.bill_mng.*, acar.client.*, acar.credit.*, tax.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String m_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String trusbill_gubun 	= request.getParameter("trusbill_gubun")==null?"":request.getParameter("trusbill_gubun");
	String item_dt	= request.getParameter("pay_dt")==null?Util.getDate():request.getParameter("item_dt");
	int pay_amt		= request.getParameter("pay_amt")==null?0:Util.parseDigit(request.getParameter("pay_amt"));	

	String mode 	= request.getParameter("mode")==null?"ebill":request.getParameter("mode");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();

	String client_id	= "";
	String site_id 		= "";
	String tax_branch	= "";
	String bank_code 	= "";
	String deposit_no 	= "";	
	
	//계약:고객관련
	ContBaseBean base 		= a_db.getContBaseAll(m_id, l_cd);
	if(base.getTax_type().equals("2")){//지점
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	client_id = base.getClient_id();
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//대여정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	tax_branch 	= fee.getBr_id()==""?br_id:fee.getBr_id();
	
	//거래처정보
	ClientBean client = al_db.getClient(client_id);
	bank_code 	= client.getBank_code()==""?"260":client.getBank_code();
	deposit_no 	= client.getDeposit_no();
	
	String i_enp_no = client.getEnp_no1() +""+ client.getEnp_no2() +""+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() +""+ client.getSsn2();
	String i_ssn 		= client.getSsn1() +""+ client.getSsn2();
	String i_firm_nm 	= client.getFirm_nm();
	String i_client_nm 	= client.getClient_nm();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	String i_zip 		= client.getO_zip();
	String i_addr 		= client.getO_addr();
	String i_tel 		= client.getO_tel();
	String i_agnt_nm	= client.getCon_agnt_nm();
	String i_agnt_email	= client.getCon_agnt_email();
	String i_agnt_m_tel = client.getCon_agnt_m_tel();
	
	if(!site_id.equals("")){
		//거래처지점정보
		ClientSiteBean site = al_db.getClientSite(client_id, site_id);
		i_enp_no 		= site.getEnp_no();
		i_firm_nm 		= site.getR_site();
		i_client_nm 	= site.getSite_jang();
		i_sta 			= site.getBus_cdt();
		i_item 			= site.getBus_itm();
		i_zip 			= site.getZip();
		i_addr 			= site.getAddr();
		i_tel 			= site.getTel();
		i_agnt_nm		= site.getAgnt_nm();
		i_agnt_email	= site.getAgnt_email();
		i_agnt_m_tel 	= site.getAgnt_m_tel();
	}

		//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(m_id, l_cd);
	String cls_st = cls.getCls_st();
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
		var ment  = '';
			
		
		if(fm.agnt_nm.value == "")		{ alert("수신담당자명을 입력하십시오."); return; }
			if(fm.agnt_email.value == "")	{ alert("수신이메일를 입력하십시오."); return; }
			
			if(fm.agnt_email.value.indexOf("@") == -1) { alert('이메일 주소를 확인하십시오.'); return;}

			ment = '거래명세서를 발행하시겠습니까?';
			
			fm.firm_nm.value 	= charRound(fm.firm_nm.value  	,38);
			fm.client_nm.value 	= charRound(fm.client_nm.value	,18);
			fm.i_sta.value 		= charRound(fm.i_sta.value  	,38);				
			fm.i_item.value 	= charRound(fm.i_item.value  	,38);		
			
			if(confirm(ment))
			{		
				fm.target = 'i_no';
				fm.action = 'lc_cls_taxitem_u_a.jsp'
				fm.submit();
		}
			
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='/fms2/cls_cont/lc_cls_payebill_u_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=base.getCar_mng_id()%>'>

<input type='hidden' name='node_code' value='S101'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='site_id' value='<%=site_id%>'>

<input type='hidden' name='car_no' value='<%=cr_bean.getCar_no()%>'>
<input type='hidden' name='car_nm' value='<%=cr_bean.getCar_nm()%>'>
<input type='hidden' name='car_st' value='<%=base.getCar_st()%>'>

<!--트러스빌거래처-->
<input type='hidden' name='tax_branch' value='<%=tax_branch%>'>
<input type='hidden' name='client_st' value='<%=client.getClient_st()%>'>
<input type='hidden' name='firm_nm'	  value='<%=i_firm_nm%>'>
<input type='hidden' name='client_nm' value='<%=i_client_nm%>'>
<input type='hidden' name='enp_no' 	  value='<%=i_enp_no%>'>
<input type='hidden' name='ssn' 	  value='<%=i_ssn%>'>
<input type='hidden' name='i_sta' 	  value='<%=i_sta%>'>
<input type='hidden' name='i_item' 	  value='<%=i_item%>'>
<input type='hidden' name='zip' 	  value='<%=i_zip%>'>
<input type='hidden' name='addr' 	  value='<%=i_addr%>'>
<input type='hidden' name='tel' 	  value='<%=i_tel%>'>
<input type='hidden' name='trusbill_gubun' 	  value='<%=trusbill_gubun%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>입금표 처리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
			        <td class=line2></td>
			    </tr>
			 	<tr>
			 		<td class='line'>
			 			<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<tr>
								<td width=15% class='title'>계약번호</td>
								<td width=20%>&nbsp;<%=l_cd%></td>
								<td width=15% class='title'>상호</td>
								<td width=30%>&nbsp;<%=i_firm_nm%></td>
								<td class='title'>구분</td>
								<td>&nbsp;<%if(trusbill_gubun.equals("dly")){%>연체료<%}else if(trusbill_gubun.equals("dft")){%>해지위약금<%}else if(trusbill_gubun.equals("etc")){%>회수외주비용<%}else if(trusbill_gubun.equals("etc2")){%>회수부대비용<%}else if(trusbill_gubun.equals("etc4")){%>기타손해배상금<%}%></td>
							</tr>
							<tr>
								<td width=15% class='title'>차량번호</td>
								<td colspan=2>&nbsp;<%=cr_bean.getCar_no()%></td>
								<td width=15% class='title'>차명</td>
								<td colspan=2>&nbsp;<%=cr_bean.getCar_nm()%></td>
							</tr>
							
							<tr>
							  <td class='title'>청구일</td>
							  <td>
						      &nbsp;<input type='text' name='item_dt'  size='10' value='<%=cls.getCls_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
							  <td class='title'>청구액</td>
							  <td colspan=3>
						      &nbsp;<input type='text' name='pay_amt'   size='15' maxlength='10' value='<%=AddUtil.parseDecimal(pay_amt)%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>원</td>
						 	
						   </tr>
						</table>
					</td>
				</tr>				
				<tr>
					<td colspan='6' >&nbsp;</td>
				</tr>
			
				<tr>
			        <td class=line2></td>
			    </tr>
				<tr>
					<td colspan='6' class='line'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>								
						
							<tr>
								<td class='title'>담당자</td>
								<td>&nbsp;
							    <input type='text' size='15' name='agnt_nm' value='<%=i_agnt_nm%>' maxlength='20' class='text'></td>
							</tr>
							<tr>
							  <td class='title'>EMAIL</td>
							  <td>&nbsp;
						      <input type='text' size='40' name='agnt_email' value='<%=i_agnt_email%>' maxlength='30' class='text'></td>
						  </tr>
							<tr>
							  <td class='title'>이동전화</td>
							  <td>&nbsp;
                                <input type='text' size='15' name='agnt_m_tel' value='<%=i_agnt_m_tel%>' maxlength='15' class='text'></td>
						  </tr>
						   <tr>
							  <td class='title'>비고</td>
							  <td>&nbsp;
								<textarea name="bigo" cols="80" class="text" rows="2"><%=cls_st%>-<%if(trusbill_gubun.equals("dly")){%>연체료 <%}else if(trusbill_gubun.equals("dft")){%> 해지위약금 <%}else if(trusbill_gubun.equals("etc")){%> 회수외주비용 <%}else if(trusbill_gubun.equals("etc2")){%> 회수부대비용 <%}else if(trusbill_gubun.equals("etc4")){%> 기타손해배상금 <%}%></textarea>
                                </td>
						  </tr>
							
					  </table>
					</td>
				</tr>		
			
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'>
	
		<%if(mode.equals("ebill") ){%><a href="javascript:save()"><img src=/acar/images/center/button_cgsbh.gif align=absmiddle border=0></a><%}%>
		&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>