<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.admin.*,acar.common.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		fm.work_st.value = work_st;
		fm.target = 'i_no';
		fm.action = 'autowork_a.jsp';
		fm.submit();
	}
	
	function popup(url)
	{
		var fm = document.form1;
				
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}	
	
	function popup2(url, s_var)
	{
		var fm = document.form1;
		fm.s_var.value = s_var;		
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}
	
	function popup3()
	{
		var fm = document.form1;				
		fm.target = '_blank';
		
		if(fm.stat_st.value == 'a'){
			alert('대용량자료는 월마감 보관 폴더에서 확인하십시오.');		
			return;
		}else{
			
			if(fm.stat_st.value == '1') 		fm.action = 'select_stat_end_cont_list_db.jsp';
			if(fm.stat_st.value == '2') 		fm.action = 'select_stat_end_car_list_db.jsp';
			if(fm.stat_st.value == '3') 		fm.action = 'select_stat_end_bank_debt_list_db.jsp';
			if(fm.stat_st.value == '4') 		fm.action = 'select_stat_end_car_comp_db.jsp';
			if(fm.stat_st.value == '5') 		fm.action = 'select_stat_end_fee_dly_list_db.jsp';
			if(fm.stat_st.value == '6') 		fm.action = 'select_stat_end_bank_debt_list_int_db.jsp';
			if(fm.stat_st.value == '7') 		fm.action = 'select_stat_end_bank_debt_ls_list_db.jsp';
			if(fm.stat_st.value == '8') 		fm.action = 'select_stat_end_asset_db.jsp';
			if(fm.stat_st.value == '9') 		fm.action = 'select_stat_end_asset_list_db.jsp';
			if(fm.stat_st.value == '10') 		fm.action = 'select_stat_end_bank_debt_stat_db.jsp';
			if(fm.stat_st.value == '11') 		fm.action = 'select_stat_end_cont_fee_list_db.jsp';
			if(fm.stat_st.value == '12') 		fm.action = 'select_stat_end_12_list_db.jsp';
			if(fm.stat_st.value == '13') 		fm.action = 'select_stat_end_13_list_db.jsp';
			if(fm.stat_st.value == '14') 		fm.action = 'select_stat_end_14_list_db.jsp';
			if(fm.stat_st.value == '15') 		fm.action = 'select_stat_end_15_list_db.jsp';
			if(fm.stat_st.value == '16') 		fm.action = 'select_stat_end_16_list_db.jsp';
			if(fm.stat_st.value == '17') 		fm.action = 'select_stat_end_17_list_db.jsp';
			if(fm.stat_st.value == '18') 		fm.action = 'select_stat_end_18_list_db.jsp';
			if(fm.stat_st.value == '19') 		fm.action = 'select_stat_end_19_list_db.jsp';
			if(fm.stat_st.value == '20') 		fm.action = 'select_stat_end_20_list_db.jsp';
			if(fm.stat_st.value == '21') 		fm.action = 'select_stat_end_21_list_db.jsp';
			if(fm.stat_st.value == '') 			return;
								
			fm.submit();		
		}
		
	}	
		
	//등록하기
	function save2(ment){
		var fm = document.form1;	
		
		if(!confirm(ment+'을 마감하시겠습니까?'))
			return;
				
		fm.action = 'select_stat_end_a.jsp';						
		fm.target = 'i_no';
		fm.submit();	
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//관리현황
	Vector deb1s = ad_db.getStatDebtList("stat_rent_month");
	int deb1_size = deb1s.size();
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
	
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_var' value=''>
<input type='hidden' name='s_unit' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>마감관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※ <b>DB 월마감 등록</b> - <a href="javascript:save2('계약현황');"><img src=/acar/images/center/button_dimg.gif align=absmiddle border=0></a>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※ <b>DB 월마감 보기</b> - 
		<select name="save_dt">
			<%	if(deb1_size > 0){
				    for(int i = 0 ; i < deb1_size ; i++){
						StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>		
			<option value="<%=sd.getSave_dt()%>">[<%=sd.getSave_dt()%>] <%=sd.getReg_dt()%></option>		
			<%		}
				}%>
		</select>
		<select name="stat_st">
			<option value="">선택</option>		
			<option value="">===월마감===</option>
			<option value="1">계약현황(거래처명|대여대수|월대여료|비고)</option>
			<option value="2">차량현황(차명|차량번호|등록일|비고)</option>
			<option value="4">제조사별차량현황</option>
			<option value="3">차입금상환스케줄</option>
			<option value="6">차입금상환스케줄(이자포함)</option>			
			<option value="5">대여료연체현황(거래처명|차량번호|연체건수|연체대여료)</option>			
			<option value="">===자산===</option>
			<option value="8">자산현황</option>
			<option value="10">금융사별차입금세부현황</option>
			<option value="12">신규영업 중단하고 대여사업 계속시(현재가치,백만원단위)</option>
			<option value="13">신규영업 중단하고 대여사업 계속시(현재가치,원단위)</option>
			<option value="18">대여일시 종료시 정산가치(원단위) - 점검용</option>
			<option value="19">신규영업 중단하고 대여사업 계속시 CASH FLOW(종합,백만원단위)</option>			
			<option value="20">신규영업 중단하고 대여사업 계속시 CASH FLOW(종합,원단위)</option>
			<option value="">===외부요청===</option>
			<option value="14">연체현황(계약번호|차량번호|월대여료|연체대여료|남은개월수|미도래대여료|합계)</option>
			<option value="15">금융사별대출현황(금융사명|실행일자|만기일자|실행금액|상환방법|할부개월수|약정금리|잔액)</option>
			<option value="11">계약현황(차량정보|고객정보|대여정보)</option>
			<option value="">===대용량-별도보관===</option>
			<option value="a" disabled>차량별자산현황 Excel</option><!-- 9 -->
			<option value="a" disabled>신규영업 중단하고 대여사업 계속시(현재가치) 차량별세부리스트 Excel - 외부제출용</option><!-- 16 -->
			<option value="a" disabled>신규영업 중단하고 대여사업 계속시(현재가치) 차량별세부리스트 Excel - 내부점검용</option><!-- 17 -->
			<option value="a" disabled>신규영업 중단하고 대여사업 계속시 CASH FLOW(개별차량) Excel</option><!-- 20 -->
			<option value="a" disabled>신규영업 중단하고 대여사업 계속시 CASH FLOW(검산) Excel</option><!-- 21 -->
			<!--<option value="7">리스료지급스케줄</option>-->
		</select>
		&nbsp;&nbsp;<a href="javascript:popup3()"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>		
	</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>* 계약현황, 차량현황, 차입금상환스케줄 등 마감한 데이타입니다.</font></td>
  </tr>  
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(자산 데이터는 자산등록 기간을 감안하여 익월초(1~10)에 재마감이 됩니다.)</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(자산 데이터는 2020년11월부터 월별로 변경)</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 월마감 - <b>계약현황</b> : 마감월의 마지막일자 <input type='text' size='11' name='cont_end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-"+AddUtil.getMonthDate(AddUtil.getDate2(1),AddUtil.getDate2(2))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('select_stat_end_cont_list.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		   &nbsp;&nbsp;(연번 | 거래처명 | 대여대수	| 월대여료 | 비고)
		   &nbsp;&nbsp;<font color=red>* 현재기준 실시간데이타입니다.</font>
		   

	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 월마감 - <b>차량현황</b> : 마감월의 마지막일자 <input type='text' size='11' name='car_end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-"+AddUtil.getMonthDate(AddUtil.getDate2(1),AddUtil.getDate2(2))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
	       &nbsp;&nbsp;<a href="javascript:popup('select_stat_end_car_list.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		   &nbsp;&nbsp;(연번 | 차명 | 차량번호 | 등록일 | 비고)
		   &nbsp;&nbsp;<font color=red>* 현재기준 실시간데이타입니다.</font>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* SBI+SBI3+SBI4 합 , KB캐피탈+우리파이낸셜 합</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 월마감 - <b>차입금상환일정표</b> : 마감월의 첫일자 <input type='text' size='11' name='bank_end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)+"-01"%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
		   &nbsp;&nbsp;(상환 | 잔액)
		   &nbsp;&nbsp;[예시] 기준일자 2009-12-31 -> 조회일자 2009-12-01
		   &nbsp;&nbsp;<font color=red>* 현재기준 실시간데이타입니다.</font>
	</td>
  </tr>
    <tr>
	<td>
	    <table width="100%"  border="0">
                <%if(bank_size > 0){
        		for(int i = 0 ; i < bank_size ; i++){
        			CodeBean bank = banks[i];
        	%>
		<tr>
                    <td>&nbsp;</td>
                    <td width="20%"><%= bank.getNm()%></td>
                    <td width="20%"><a href="javascript:popup2('select_stat_end_bank_debt_list.jsp','<%=bank.getCode()%>')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></td>
                    <td width="40%">&nbsp;<!--  <%if(bank.getNm().equals("롯데오토리스")){%>리스료스케줄 <a href="javascript:popup2('select_stat_end_bank_debt_ls_list.jsp','<%=bank.getCode()%>')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a><%}%>-->
                    	
                    </td>
                </tr>
                <%	}
        	}%>	
        	

    </table></td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <%if(ck_acar_id.equals("000029")){ %>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;## <a href="javascript:popup('temp_bacth_excel.jsp')">[엑셀파일을 이용한 일괄처리]</a>
	</td>
  </tr>  
  <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
