<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.ext.*, acar.bill_mng.*, acar.client.*, tax.*"%>
<%@ page import="acar.con_ins_m.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String ext_tm 	= request.getParameter("ext_tm")==null?"":request.getParameter("ext_tm");
	
	
	InsMScdBean cng_ins_ms = ae_db.getScd(m_id, l_cd, c_id, accid_id, serv_id, ext_tm);
	
	
	String client_id	= "";
	String site_id 		= "";
	String tax_branch	= "";
	
	//장기계약 상단정보
	LongRentBean bean       = ScdMngDb.getScdMngLongRentInfo("", l_cd);
	
	//계약:고객관련
	ContBaseBean base 		= a_db.getContBaseAll(m_id, l_cd);
	if(base.getTax_type().equals("2")){//지점
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	client_id = base.getClient_id();
	
	//대여정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	tax_branch 	= fee.getBr_id()==""?br_id:fee.getBr_id();
	
	  // 대차인 경우 원계약 정보 구해서 처리 	
	Hashtable ht1	= in_db.getOriRent(l_cd , serv_id );
	client_id = String.valueOf(ht1.get("CLIENT_ID"));
	
	//거래처정보
	ClientBean client = al_db.getClient(client_id);
	
	String i_enp_no 	= client.getEnp_no1() +""+ client.getEnp_no2() +""+ client.getEnp_no3();
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
		
		if(fm.agnt_nm.value == "")					{ alert("수신담당자명을 입력하십시오."); return; }
		if(fm.agnt_email.value == "")				{ alert("수신이메일를 입력하십시오."); return; }			
		if(fm.agnt_email.value.indexOf("@") == -1) 	{ alert('이메일 주소를 확인하십시오.'); return;}
		if(fm.agnt_email.value.indexOf(".") == -1) 	{ alert('이메일 주소를 확인하십시오.'); return;}

		ment = '트러스빌 전자입금표를 발행하시겠습니까?';
			
		fm.firm_nm.value 	= charRound(fm.firm_nm.value  	,38);
		fm.client_nm.value 	= charRound(fm.client_nm.value	,18);
		fm.i_sta.value 		= charRound(fm.i_sta.value  	,38);				
		fm.i_item.value 	= charRound(fm.i_item.value  	,38);						
			
		if(confirm(ment))
		{		
//			fm.target = 'i_no';
			fm.action = 'payebill_i_a.jsp'
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
<form name='form1' action='/fms2/con_insm_m/payebill_i_a.jsp' method='post'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

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
<input type='hidden' name='idx' value='<%=idx%>'>

<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='ext_tm' value='<%=ext_tm%>'>
<!--트러스빌거래처-->
<input type='hidden' name='tax_branch' value='<%=tax_branch%>'>
<input type='hidden' name='client_id' value='<%=client.getClient_id()%>'>
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

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > 면책금 관리 > <span class=style5>입금표발행</span></span></td>
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
								<td width=20% class='title'>계약번호</td>
								<td width=30%>&nbsp;<%=l_cd%></td>
								<td width=20% class='title'>상호</td>
								<td width=30%>
								    <table border="0" cellspacing="0" cellpadding="3" width=100%>
							            <tr><td><%=i_firm_nm%></td>
							            </tr>
							        </table>
							    </td>
							</tr>
							<tr>
								<td class='title'>공급가</td>
								<td>&nbsp;<input type='text' name='grt_s_amt' size='10' value='<%=Util.parseDecimal(cng_ins_ms.getExt_s_amt())%>' class='whitenum' readonly>원</td>
								<td class='title'>부가세</td>
								<td>&nbsp;<input type='text' name='grt_v_amt' size='10' value='<%=Util.parseDecimal(cng_ins_ms.getExt_v_amt())%>' class='whitenum' readonly>원</td>
							</tr>
							<tr>
							  <td class='title'>입금예정일</td>
							  <td>&nbsp;<%=cng_ins_ms.getCust_plan_dt()%></td>
							  <td class='title'>합계</td>
							  <td>&nbsp;<input type='text' name='grt_amt' size='10' value='<%=Util.parseDecimal(cng_ins_ms.getExt_s_amt()+cng_ins_ms.getExt_v_amt())%>' class='whitenum' readonly>원</td>
						  </tr>
							<tr>
							  <td class='title'>입금일자</td>
							  <td>
						      &nbsp;<input type='text' name='pay_dt' size='11' value='<%=cng_ins_ms.getCust_pay_dt()%>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
							  <td class='title'>실입금액</td>
							  <td>
						      &nbsp;<input type='text' name='pay_amt' size='10' maxlength='10' value='<%=Util.parseDecimal(cng_ins_ms.getPay_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>원</td>
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
								<td rowspan="5" width=7% class='title' align="center">트<br>러<br>스<br>빌</td>
								<td width='20%' class='title'>담당자</td>
								<td width="73%">&nbsp;
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
								<textarea name="bigo" cols="45" class="text" rows="2">면책금 <%=bean.getCar_no()%></textarea>
                                </td>
						  </tr>
							
					  </table>
					</td>
				</tr>	
				<tr>
					<td colspan='6' >&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'>
		<a href="javascript:save()"><img src=/acar/images/center/button_igpbh.gif align=absmiddle border=0></a>
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