<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"5":request.getParameter("s_cnt");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//자동차정보
	CarRegBean cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	//은행계좌번호
	Vector banks = neoe_db.getFeeDepositList(); 	//-> neoe_db 변환
	int bank_size = banks.size();
	
	//대여료스케줄
	Vector fee_scds = af_db.getFeeScdSettleList(m_id, l_cd);
	int scd_size = fee_scds.size();
	
	//대여료통계
	Hashtable fee_stat = af_db.getFeeScdStatPrint(m_id, l_cd);
	
	//세금계산서 발행일시중지관리내역 리스트
	Vector stops = af_db.getFeeScdStopList2(m_id, l_cd);
	int stop_size = stops.size();
	
	//면책금
	Vector serv_scds = af_db.getServScdStatClient(base.getClient_id());
	int serv_size = serv_scds.size();
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function cal_rc_rest(){
		var fm = document.form1;
		
		var scd_size 	= toInt(fm.scd_size.value);		
		var rc_amt 		= toInt(parseDigit(fm.rc_amt.value));
		var t_pay_amt 	= 0;

		for(var i = 0 ; i < scd_size ; i ++){

			var est_amt = toInt(parseDigit(fm.est_amt[i].value));
			
			if(rc_amt < est_amt){
				fm.pay_amt[i].value = parseDecimal(rc_amt);
				rc_amt 		= rc_amt - toInt(parseDigit(fm.pay_amt[i].value));				
			}else{
				fm.pay_amt[i].value = parseDecimal(est_amt);
				rc_amt = rc_amt - toInt(parseDigit(fm.pay_amt[i].value));				
			}			
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));			
		}
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.rc_amt.value))-t_pay_amt);
	}
	
	function cal_rest(){
		var fm = document.form1;
		
		var scd_size 	= toInt(fm.scd_size.value);		
		var rc_amt 		= toInt(parseDigit(fm.rc_amt.value));
		var t_pay_amt 	= 0;

		for(var i = 0 ; i < scd_size ; i ++){
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));			
		}
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.rc_amt.value))-t_pay_amt);
	}	
		
	function save()
	{
		var fm = document.form1;

		if(fm.deposit_no.value == ""){ alert("계좌번호를 선택하십시오."); return; }		
				
		if( !isDate(fm.rc_dt.value) || (fm.rc_dt.value == '') || (fm.rc_amt.value == '') || (parseDigit(fm.rc_amt.value) == '0') || (parseDigit(fm.rc_amt.value).length > 9))
		{
			alert('입금예정일과 입금액을 확인하십시오');
			return;
		}
		
		if(toInt(parseDigit(fm.rc_amt.value)) > toInt(parseDigit(fm.t_pay_amt.value)) || toInt(parseDigit(fm.rc_amt.value)) < toInt(parseDigit(fm.t_pay_amt.value)))
		{
			alert('입금액을 확인하세요');
			return;
		}
		
		if(confirm('입금처리하시겠습니까?'))
		{		
			fm.target = 'i_no';
			//fm.target = '_blank';
			fm.action = 'fee_pay_all_u_a.jsp'
			fm.submit();
		}		
	}
	
	function search(){
		var fm = document.form1;	
		fm.target = '_self';
		fm.action = 'fee_pay_all_u.jsp'
		fm.submit();		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>

<form name='form1' action='/fms2/con_fee/fee_pay_all_u_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='scd_size' value=''>
<input type='hidden' name='stop_size' value='<%=stop_size%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>대여료 일괄 수금처리</span></span></td>	
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계약번호</td>
                    <td width='20%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>상호</td>
                    <td width='50%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=cr_bean.getCar_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp; <input type='text' name='s_cnt' size='2' value='<%=s_cnt%>' class='text'>건 <a href="javascript:search()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계좌번호</td>
                    <td colspan="3">&nbsp;
					  <select name='deposit_no'>
                        <option value=''>계좌를 선택하세요</option>
					    <%	if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									Hashtable bank = (Hashtable)banks.elementAt(i);%>
						<option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
			            <%		}
							}%>

                      </select>
					</td>
                </tr>
                <tr> 
                    <td class='title' width='15%'>입금일자</td>
                    <td width='20%'>&nbsp;
					  <input type='text' name='rc_dt' size='12' value='<%=Util.getDate()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                    <td class='title' width='15%'>입금금액</td>
                    <td width='50%'>&nbsp;
					  <input type='text' name='rc_amt' size='12' maxlength='15' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_rc_rest();'>&nbsp;원</td>
                </tr>
                <tr> 
                    <td class='title' width='15%'>자동전표</td>
                    <td colspan="3">&nbsp;
					  <input type="checkbox" name="autodoc" value="Y" checked> 발행
					</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='20%'>회차</td>
                    <td class="title" width='20%'>구분</td>					
                    <td class="title" width='20%'>입금예정일</td>
                    <td class="title" width='20%'>예정금액</td>
                    <td class="title" width='20%'>입금처리금액</td>
                </tr>
				<%	if(scd_size > 0){
						if(scd_size > AddUtil.parseInt(s_cnt))	scd_size = AddUtil.parseInt(s_cnt);
						for(int i = 0 ; i < scd_size ; i++){
							Hashtable fee_scd = (Hashtable)fee_scds.elementAt(i);%>
				<input type='hidden' name='gubun' value='scd_fee'>
				<input type='hidden' name='rent_st' value='<%=fee_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=fee_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=fee_scd.get("FEE_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=fee_scd.get("TM_ST1")%>'>
				<input type='hidden' name='tm_st2' value='<%=fee_scd.get("TM_ST2")%>'>				
                <tr>
                    <td align="center"><%=fee_scd.get("FEE_TM")%></td>
                    <td align="center"><%=fee_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("R_FEE_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("FEE_AMT")))%>'>원</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal_rest();'>원</td>
                </tr>							
				<%		}
					}%>
				<%
					int dly_tot_amt = AddUtil.parseInt(String.valueOf(fee_stat.get("DT")));
					int dly_pay_amt = AddUtil.parseInt(String.valueOf(fee_stat.get("DT2")));
				%>	
				<input type='hidden' name='gubun' value='scd_dly'>
				<input type='hidden' name='rent_st' value=''>
				<input type='hidden' name='rent_seq' value=''>
				<input type='hidden' name='fee_tm' value=''>
				<input type='hidden' name='tm_st1' value=''>
				<input type='hidden' name='tm_st2' value=''>								
                <tr>
                    <td colspan="3" align="center">대여료 연체료</td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(dly_tot_amt-dly_pay_amt)%>'>원</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal_rest();'>원</td>
                </tr>		
				<%	if(serv_size > 0){
						for(int i = 0 ; i < serv_size ; i++){
							Hashtable serv_scd = (Hashtable)serv_scds.elementAt(i);
							scd_size++;%>
				<input type='hidden' name='gubun' value='scd_serv'>
				<input type='hidden' name='rent_st' value='<%=serv_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=serv_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=serv_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%//=serv_scd.get("TM_ST1")%>'>
				<input type='hidden' name='tm_st2' value='<%//=serv_scd.get("TM_ST2")%>'>				
                <tr>
                    <td align="center"><%=serv_scd.get("EXT_TM")%></td>
                    <td align="center"><%=serv_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(serv_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(serv_scd.get("EXT_AMT")))%>'>원</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:javascript:this.value=parseDecimal(this.value); cal_rest();'>원</td>
                </tr>							
				<%		}
					}%>
				
                <tr>
                    <td colspan="3" class=title>합계</td>
                    <td class=title>&nbsp;</td>
                    <td class=title><input type='text' name='t_pay_amt' size='10' class='fixnum' value=''>원</td>
                </tr>																																				
                <tr>
                    <td colspan="3" class=title>잔액</td>
                    <td class=title>&nbsp;</td>
                    <td class=title><input type='text' name='t_jan_amt' size='10' class='fixnum' value=''>원</td>
                </tr>																																				
            </table>
        </td>
    </tr>
	<%	if(stop_size > 0){%>	
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계산서발행 일시중지 해제처리</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='10%'>구분</td>
                    <td class="title" width='30%'>사유</td>					
                    <td class="title" width='20%'>중지시작일</td>
                    <td class="title" width='20%'>중지종료일</td>
                    <td class="title" width='20%'>해제일자</td>
                </tr>
				<%	for(int i = 0 ; i < stop_size ; i++){
							Hashtable fee_stop = (Hashtable)stops.elementAt(i);%>
				<input type='hidden' name='stop_seq' value='<%=fee_stop.get("SEQ")%>'>
                <tr>
                    <td align="center"><%=fee_stop.get("STOP_ST_NM")%></td>
                    <td align="center"><%=fee_stop.get("STOP_CAU")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(fee_stop.get("STOP_S_DT")))%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(fee_stop.get("STOP_E_DT")))%></td>
                    <td align="center"><input type='text' name='cancel_dt' size='12' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value);'>&nbsp;&nbsp;</td>
                </tr>							
				<%	}%>
            </table>
        </td>
    </tr>
	<%	}%>
    <tr> 
        <td>&nbsp; </td>
    </tr>	
	<tr>
		<td align='right'><a href="javascript:save()"><img src=/acar/images/center/button_igcl.gif align=absmiddle border="0"></a></td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	var fm = document.form1;
	fm.scd_size.value = '<%=scd_size+1%>';	
//-->
</script>
</body>
</html>