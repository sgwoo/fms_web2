<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.debt.*, acar.common.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	

	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "02");
	
	ContDebtBean debt = a_db.getContDebt(m_id, l_cd);
	CommonDataBase c_db = CommonDataBase.getInstance();
	int tot_amt_tm = debt.getTot_alt_tm().equals("")?0:Integer.parseInt(debt.getTot_alt_tm());
	
	//계약정보
	Hashtable cont = ad_db.getAllotByCase(m_id, l_cd);
	
	if(car_id.equals("")) car_id = debt.getCar_mng_id();
		Vector debts = d_db.getDebtScd(car_id);
		int debt_size = debts.size();
		if(tot_amt_tm == 0) tot_amt_tm = debt_size;
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 8; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-65;//현황 라인수만큼 제한 아이프레임 사이즈
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function set_est_dt(){
		var fm = document.form1;
//		fm.t_fst_pay_dt.value=ChangeDate(fm.t_fst_pay_dt.value);
		if((fm.t_fst_pay_dt.value != '') && isDate(fm.t_fst_pay_dt.value) &&(fm.t_tot_amt_tm.value != '')){
			fm.action='/acar/con_debt/est_dt_nodisplay.jsp';
			fm.target='i_no';
			fm.submit();
		}else{}
	}
	
	function cng_est_dt(){
		var fm = document.form1;
		alert(fm.t_tot_amt_tm.value);
		if(fm.cng_tm.value != '' && fm.set_dt.value != '' && fm.t_tot_amt_tm.value != ''){
			fm.action='/acar/con_debt/est_dt_debt_nodisplay.jsp';
			fm.target='i_no';
			fm.submit();
		}else{}
	}	
	
	function set_fst_amt()
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		fm.t_fst_pay_amt.value=parseDecimal(fm.t_fst_pay_amt.value);
		var tm = i_fm.t_rest_amt.length;
		
		if(parseDigit(fm.t_fst_pay_amt.value).length > 9)		{	alert('1회차 상환금액을 확인하십시오');		return;	}
		
		for(var i = 1 ; i < tm ; i ++)
		{			
			i_fm.t_alt_amt[i].value = fm.t_fst_pay_amt.value;
			i_fm.t_alt_prn[i].value = parseDecimal(toInt(parseDigit(i_fm.t_alt_amt[i].value)) - toInt(parseDigit(i_fm.t_alt_int[i].value)));
		}
		cal_rest();				
	}
		
	function cal_allot(idx, obj)
	{
		var i_fm = i_in.form1;
		obj.value = parseDecimal(obj.value);
		i_fm.t_alt_prn[idx].value = parseDecimal(toInt(parseDigit(i_fm.t_alt_amt[idx].value)) - toInt(parseDigit(i_fm.t_alt_int[idx].value)));
		cal_rest();
	}
	
	function cal_rest()
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		var tm = i_fm.t_rest_amt.length;

		for(var i = 1 ; i < tm ; i ++)
		{			
			if(i == 1)
				i_fm.t_rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.t_lend_prn.value)) - toInt(parseDigit(i_fm.t_alt_prn[i].value)));
			else
				i_fm.t_rest_amt[i].value = parseDecimal(toInt(parseDigit(i_fm.t_rest_amt[i-1].value)) - toInt(parseDigit(i_fm.t_alt_prn[i].value)));
		}
		cal_total();
	}	
	
	function cal_total()
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		var tm = i_fm.t_alt_prn.length;
		var prn = 0;
		var int = 0;
		var amt = 0;
		for(var i = 1 ; i < tm ; i ++)
		{	
			prn += toInt(parseDigit(i_fm.t_alt_prn[i].value));
			int += toInt(parseDigit(i_fm.t_alt_int[i].value));
			amt += toInt(parseDigit(i_fm.t_alt_amt[i].value));
		}
			fm.t_tot_alt_prn.value = parseDecimal(prn);
			fm.t_tot_alt_int.value = parseDecimal(int);
			fm.t_tot_alt_amt.value = parseDecimal(amt);
	}

	
	function modify()
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		if(i_in.getDefMon() > 1){ alert('0회차 약정일과 1회차 약정일을 확인하십시오.'); return; }		
		if(confirm('수정하시겠습니까?'))
		{
			if(parseDigit(fm.t_fst_pay_amt.value).length > 9)
			{	alert('1회차 상환금액을 확인하십시오');		return;	}		
			i_fm.t_fst_pay_dt.value = fm.t_fst_pay_dt.value;
			i_fm.t_fst_pay_amt.value = fm.t_fst_pay_amt.value;
			i_fm.update_msg.value = fm.update_msg.value;
			i_in.in_modify();
		}
	}
	
	function go_to_list(){
		var fm = document.form1;	
		fm.action='debt_scd_frame_s.jsp';		
		fm.target='d_content';
		fm.submit();	
	}	
	
	//스케줄보기
	function go_to_reg(){
		var fm = document.form1;		
		fm.action='debt_reg_u.jsp';		
		fm.target='d_content';
		fm.submit();	
	}
	
	function bank_print(){
		var fm = document.form1;		
		fm.action='debt_scd_u_print.jsp';
		fm.target='_blank';
		fm.submit();		
	}	
	
	function set_add_tm(){
		var fm = document.form1;

		if( fm.from_tm.value != '' && fm.add_tm.value != '' ){
	
			fm.action='debt_scd_add_a.jsp';
			
			fm.target='i_no';
			fm.submit();
		}else{}
	}			
	
 	//엑셀
	function execl(){
		var fm = document.form1;
		fm.action.value = 'scd_alt_int.jsp';
		fm.target ='_blank';
		fm.action = '/acar/excel_reg/excel.jsp';
		fm.submit();
	}		
 	
	//기타비용스케줄
	function go_to_scd_etc(){
		var fm = document.form1;		
		fm.action='debt_scd_etc_u.jsp';
		fm.target='_blank';
		fm.submit();	
	}	 	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='/acar/con_debt/debt_scd_u_a.jsp' target='' method="post">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='tot_amt_tm' value='<%=tot_amt_tm%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
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
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='action' value=''>


<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 구매자금관리 > 할부금관리 > <span class=style1><span class=style5>할부금 상환 스케줄 수정(건별)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
	    <td class='line' colspan=2>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
		 	    <tr>
    		 		<td class='title'>계약번호</td>
    		 		<td>&nbsp;<%=debt.getRent_l_cd()%> </td>
    		 		<td class='title'> 대출금액 </td>
    		 		<td>&nbsp;<input type='text' name='t_lend_prn' size='10' value='<%=Util.parseDecimal(debt.getLend_prn())%>' class='whitenum' readonly>원&nbsp;</td>
    		 		<td class='title'>대출번호</td>
    		 		<td>&nbsp;<%=debt.getLend_no()%> </td>
    		 		<td class='title'> 할부금융사	</td>
    				<td colspan='3' align='left'>&nbsp;<%=c_db.getNameById(debt.getCpt_cd(), "BANK")%>&nbsp;&nbsp;(<%=cont.get("CAR_NO")%>/<%=car_id%>)</td>
		 	    </tr>
			    <tr>
    				<td width=9% class='title'>할부횟수</td>
    		 		<td width=11%>&nbsp;<input type='text' name='t_tot_amt_tm' size='3' value='<%=debt.getTot_alt_tm()%>' class='white' onBlur='javascript:blur()'>회&nbsp;</td>
    				<td width=9% class='title'> 이율 </td>
    		 		<td width=11%>&nbsp;<%=debt.getLend_int()%>%&nbsp;</td>
    				<td width=9% class='title'> 할부수수료 </td>
    		 		<td width=11%>&nbsp;<%=Util.parseDecimal(debt.getAlt_fee())%>원&nbsp;</td>
    		 		<td width=9% class='title'>공증료</title>
    				<td width=11%>&nbsp;<%=Util.parseDecimal(debt.getNtrl_fee())%>원&nbsp;</td>
    				<td width=9% class='title'>인지대</title>
    				<td width=11%'>&nbsp;<%=Util.parseDecimal(debt.getStp_fee())%>원&nbsp;</td>			
			    </tr>
			    <tr>
    				<td class='title'>할부금</td>
    		 		<td>&nbsp;<%=Util.parseDecimal(debt.getAlt_amt())%>원&nbsp;</td>
    		 		<td class='title'>약정일자</title>
    				<td>&nbsp;<%=debt.getRtn_est_dt()%>일</td>
    				<td class='title'>1회차결재일</td>
    				<td>&nbsp;<input type='text' size='12' name='t_fst_pay_dt' value='<%=debt.getFst_pay_dt()%>' class='text' value='' onBlur='javscript:this.value = ChangeDate(this.value); set_est_dt();'></td>
    				<td class='title'>1회차상환금액 </td>
				    <td>&nbsp;<input type='text' name='t_fst_pay_amt' value='<%=Util.parseDecimal(debt.getFst_pay_amt())%>' size='10' maxlength='11' class='num' onBlur='javascript:set_fst_amt()'>원&nbsp;</td>
    				<td class='title'>계정과목</title>
    				<td >&nbsp;<%if(debt.getAcct_code().equals("26000")){%>단기차입금<%}%>
                      <%if(debt.getAcct_code().equals("26400")||debt.getAcct_code().equals("29300")){%>장기차입금<%}%>
                      <%if(debt.getAcct_code().equals("45450")){%>리스료<%}%>
            </td>
			    </tr>
			    <tr>
    				<td class='title'>중도상환<br>수수료</td>
    		 		<td>&nbsp;<%=debt.getCls_rtn_fee_int()%>%&nbsp;</td>
    				<td class='title'>중도상환<br>특이사항</td>
    				<td colspan='7'>&nbsp;<%=debt.getCls_rtn_etc()%></td>
			    </tr>				
		    </table>
	    </td>
	</tr>
<%	if(tot_amt_tm>=1){%>
	<tr>
		<td align='right' colspan=2>
		  <%if(!from_page.equals("/fms2/bank_mng/debt_scd_reg_i.jsp")){ %>
		  <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		  <a href="javascript:bank_print()"><img src=../images/center/button_print.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		  <a href="javascript:execl()"><img src=../images/center/button_reg_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		  <%	}%>
		  
		  <a href='javascript:go_to_list();'><img src=../images/center/button_list.gif align=absmiddle border=0></a>
		  <%}%>
		  
		  <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		  <%	if(!from_page.equals("/fms2/bank_mng/debt_scd_reg_i.jsp")){ %>
		  <br><br>		  
		  ※ 사유 입력하고 스케줄 수정시 관련담당자 메시지 발송 <textarea rows='2' cols='90' name='update_msg'></textarea>
		  &nbsp;&nbsp;
		  <%	}%>
		  <a href="javascript:modify()"><img src=../images/center/button_modify.gif align=absmiddle border=0></a>
		  <%}%>
		</td>	
	</tr>
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(debt.getAcct_code().equals("45450")){%><%}else{%>할부금<%}%>스케줄</span></td>
	</tr>	
    <tr> 
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
		 	<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width=7% class='title'>회차</td>
					<td width=12% class='title'>약정일</td>
					<td width=15% class='title'><%if(debt.getAcct_code().equals("45450")){%>리스료<%}else{%>할부원금<%}%></td>
					<td width=15% class='title'><%if(debt.getAcct_code().equals("45450")){%>잔가<%}else{%>이자<%}%></td>
					<td width=15% class='title'><%if(debt.getAcct_code().equals("45450")){%>합계<%}else{%>할부금<%}%></td>
					<td width=15% class='title'>잔액</td>
					<td width=9% class='title'>결재여부</td>
					<td width=12% class='title'>결재일</td>
				</tr>
			</table>
		</td>
		<td width='17'>&nbsp;</td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="/acar/con_debt/debt_scd_u_in.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&car_id=<%=car_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>		
		</td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width=7% class='title'>합계 </td>
					<td width=12%>&nbsp;</td>
					<td width=15% align='right'><input type='text' name='t_tot_alt_prn' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width=15% align='right'><input type='text' name='t_tot_alt_int' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width=15% align='right'><input type='text' name='t_tot_alt_amt' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width=36% colspan='3'>&nbsp;</td>
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>	
<%	}else{%>
	<tr>
	</tr>
	<tr>
		<td colspan=2><br/>&nbsp;&nbsp;&nbsp;* 할부횟수가 세팅되지 않았습니다. <br/><br/>&nbsp;&nbsp;&nbsp;* 할부금내역을 입력한 후 스케줄을 작성하십시오</td>
	</tr>
<%	}%>
    <%if(!from_page.equals("/fms2/bank_mng/debt_scd_reg_i.jsp")){ %>
    <tr> 
      <td colspan="2" align="right"><a href="javascript:go_to_reg()"><img src=../images/center/button_see_hb.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>		
    
	<%if(nm_db.getWorkAuthUser("회계업무",ck_acar_id) || nm_db.getWorkAuthUser("계출담당",ck_acar_id)){%>
    <tr> 
      <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='cng_tm' size='2' value='' class='text' onBlur='javscript:document.form1.set_dt.value = i_in.document.form1.t_est_dt[this.value].value;'>회 부터 약정일을
	    <input type='text' size='12' name='set_dt' value='' class='text' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
	  부터 <a href="javascript:cng_est_dt()"><img src=../images/center/button_st.gif align=absmiddle border=0></a></td>
    </tr>	
	<%}%>	

	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("할부금스케줄관리",ck_acar_id) ){%>
	 <tr> 
	 <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;
	<input type='text' name='from_tm' size='2'  class='text' >회부터 <input type='text' name='add_tm' size='2'  class='text' >회 추가  
	<a href="javascript:set_add_tm()"><img src=../images/center/button_reg.gif align=absmiddle border=0></a> 	
	 </td>
	 </tr>
	<%}%>
	<%}%>		
	
	<%if(debt.getAlt_etc_amt() > 0 ){%>	
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타비용</span></td>
	</tr>	
    <tr> 
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
		 	<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
                <tr> 
                    <td class='title'  width=10%>기타비용</td>
                    <td>&nbsp;
                      내용 : 
                      <input type="text" name="alt_etc" value='<%=debt.getAlt_etc()%>' maxlength='100' size="40" class=whitetext>&nbsp; 
                      &nbsp; 총금액 :
                      <input type='text' name='alt_etc_amt' value='<%=AddUtil.parseDecimal(debt.getAlt_etc_amt())%>' maxlength='10' size='10' class='whitenum'>
                      원
                      &nbsp; 회차 :
                      <input type='text' name='alt_etc_tm' value='<%=debt.getAlt_etc_tm()%>' size='3' maxlength='2' class='whitenum'>
                      회
                      &nbsp;
                      (대출금에 포함되어 있으나 원금 별도 상환인 경우)
                      &nbsp;&nbsp;
                      <%if(nm_db.getWorkAuthUser("회계업무",ck_acar_id) || nm_db.getWorkAuthUser("계출담당",ck_acar_id)){%>
                      <a href="javascript:go_to_scd_etc()"><img src=../images/center/button_see_sch.gif align=absmiddle border=0></a>
                      <%}%>	
                      </td>                    
                </tr>					
				</tr>
			</table>
		</td>
		<td width='17'>&nbsp;</td>
	</tr>	
	<%}%>	

</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
