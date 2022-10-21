<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*, acar.client.*"%>
<jsp:useBean id="s_db" scope="page"
	class="acar.settle_acc.SettleDatabase" />
<jsp:useBean id="al_db" scope="page"
	class="acar.client.AddClientDatabase" />
<%@ include file="/acar/cookies.jsp"%>

<%
	String badamt_chk_from = request.getParameter("badamt_chk_from")==null?"":request.getParameter("badamt_chk_from");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String shres_seq	= request.getParameter("shres_seq")==null?"":request.getParameter("shres_seq");	
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String damdang_id = request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String shres_reg_dt	= request.getParameter("shres_reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("shres_reg_dt"));

	
	ClientBean client = al_db.getNewClient(client_id);
	
	Vector vt = s_db.getStatSettleSubListClient(client_id);
	int vt_size = vt.size();
	
	long total_amt 	= 0;
	
%>

<html>
<head>
<title>Untitled</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//대여료메모
	function view_memo(m_id, l_cd)
	{
		//단기대여(월렌트)
		if(m_id == '' && l_cd.length ==6){
			var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd="+l_cd+"&c_id=&user_id=<%=ck_acar_id%>";	
			window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");					
		//장기대여
		}else{	
			window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=2&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
		}

	}	
	//계약정보 보기
	function view_client(m_id, l_cd)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	
	function view_scd(m_id, l_cd){
		window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_SCD", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	
	
	function save(){
		var ofm = opener.document.form1;
		ofm.badamt_chk.value = 'Y';
		self.moveTo(0,0); 
		self.close();
	}			
//-->	
</script>
</head>

<body>

	<form name='form1' method='post'>
		<input type='hidden' name='auth_rw' value=''> <input
			type='hidden' name='br_id' value=''> <input type='hidden'
			name='user_id' value=''> <input type='hidden' name='size'
			value='8'> <input type='hidden' name='m_id' value=''>
		<input type='hidden' name='l_cd' value=''>
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
				<td>
					<table width=100% border=0 cellpadding=0 cellspacing=0>
						<tr>
							<td width=7><img src=/acar/images/center/menu_bar_1.gif
								width=7 height=33></td>
							<td class=bar>&nbsp;&nbsp;&nbsp;<img
								src=/acar/images/center/menu_bar_dot.gif width=4 height=5
								align=absmiddle>&nbsp;<span class=style1>경영정보 >
									캠페인관리 > <span class=style5><%=client.getFirm_nm()%>
										채권리스트 </span>
							</span></td>
							<td width=7><img src=/acar/images/center/menu_bar_2.gif
								width=7 height=33></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class=h></td>
			</tr>
			<%if(!badamt_chk_from.equals("") && vt_size > 0 ){%>
			<tr>
				<td>※ 아래와 같이 연체금액이 있습니다. 계약진행시 참고하시기 바랍니다.</td>
			</tr>
			<%}%>
			<tr>
				<td class=line2></td>
			</tr>
			<tr>
				<td class='line'>
					<table border="0" cellspacing="1" cellpadding="0" width=100%>
						<tr>
							<td width=3% class='title'>연번</td>
							<td width=10% class='title'>계약번호</td>
							<td width=7% class='title'>영업담당자</td>
							<td width=15% class='title'>상호</td>
							<td width=8% class='title'>차량번호</td>
							<td width=11% class='title'>차명</td>
							<td width=7% class='title'>항목</td>
							<td width=12% class='title'>구분</td>
							<td width=8% class='title'>입금예정일</td>
							<td width=7% class='title'>연체금액</td>
							<td width=4% class='title'>통화</td>
							<td width=8% class='title'>납부약속일</td>
							<td width=7% class='title'>&nbsp;&nbsp;CMS&nbsp;&nbsp;</td>
						</tr>
						<%
	//대여료리스트
	if(vt_size > 0){
		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
						<tr>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=i+1%></td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><a
								href="javascript:view_client('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"
								title=""><%=ht.get("RENT_L_CD")%></a></td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=ht.get("USER_NM")%></td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=ht.get("FIRM_NM")%></td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=ht.get("CAR_NO")%>
								</td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=ht.get("CAR_NM")%>
								</td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>>
								<%if(String.valueOf(ht.get("CAR_ST")).equals("4")){%> <span
								style="color: red;">(월)</span>
								<%}%> <%if(String.valueOf(ht.get("GUBUN1")).equals("대여료")||String.valueOf(ht.get("GUBUN1")).equals("연체이자")){%>
								<a
								href="javascript:view_scd('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%=ht.get("GUBUN1")%></a>
								<%}else{%> <%=ht.get("GUBUN1")%> <%}%>
							</td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=ht.get("GUBUN2")%></td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
							<td align="right"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%>
								<%if(String.valueOf(ht.get("GUBUN2")).equals("월렌트") && !String.valueOf(ht.get("DLY_AMT")).equals(String.valueOf(ht.get("DLY_AMT2")))){%>
								<br>(<%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT2")))%>)
								<%}%></td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><a
								href="javascript:view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"
								title="">보기</a></td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROMISE_DT")))%></td>
							<td align="center"
								<%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%> class='is'
								<%%>><%=ht.get("CMS_BANK")%></td>
						</tr>
						<%			total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("DLY_AMT")));
		}
		%>
						<tr>
							<td class="title" colspan="9">합계</td>
							<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
							<td class="title">&nbsp;</td>
							<td class="title">&nbsp;</td>
							<td class="title">&nbsp;</td>
						</tr>
						<%	} %>
					</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td align='center'>
					<%if(from_page.equals("/fms2/lc_rent/lc_reg_step2.jsp")||from_page.equals("/fms2/lc_rent/lc_cng_client_c.jsp")||from_page.equals("/agent/lc_rent/lc_reg_step2.jsp")||from_page.equals("/agent/lc_rent/lc_cng_client_c.jsp")){%>
					<a href="javascript:save();"><img
						src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>
					&nbsp;&nbsp;&nbsp;&nbsp; <%}else{%> <%	if(!badamt_chk_from.equals("") && vt_size > 0){%>
					<a href="javascript:save();"><img
						src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>
					&nbsp;&nbsp;&nbsp;&nbsp; <%	}%> <%}%> <a
					href='javascript:window.close()'><img
						src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
				</td>
			</tr>
			<tr>
				<td class=h></td>
			</tr>
			<tr>
				<td align='center'>
					<%if(from_page.equals("/fms2/lc_rent/lc_reg_step2.jsp")||from_page.equals("/fms2/lc_rent/lc_cng_client_c.jsp")||from_page.equals("/agent/lc_rent/lc_reg_step2.jsp")||from_page.equals("/agent/lc_rent/lc_cng_client_c.jsp")){%>
					[확인] 버튼을 클릭하고 고객관리에서 다시 고객 상호를 선택하세요. <%}%>
				</td>
			</tr>

		</table>
	</form>
	<script language='javascript'>
<!--
	<%if(from_page.equals("/fms2/lc_rent/lc_reg_step2.jsp")||from_page.equals("/fms2/lc_rent/lc_cng_client_c.jsp")||from_page.equals("/agent/lc_rent/lc_reg_step2.jsp")||from_page.equals("/agent/lc_rent/lc_cng_client_c.jsp")){%>
	<%	if(vt_size == 0 ){%>
			alert('미수채권이 없습니다.');
			save();
	<%	}%>
	<%}else{%>
	<%	if(!badamt_chk_from.equals("") && vt_size == 0 ){%>
			alert('미수채권이 없습니다.');
			save();
	<%	}%>
	<%}%>
		
	//-->
	</script>
</body>
</html>
