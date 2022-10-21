<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.cls.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");

	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "09");

	//사원 사용자 리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();	

	//영업소코드
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();

	//기본정보
	Hashtable fee_base = af_db.getFeebasecls3(m_id, l_cd);

	//기본정보
	Hashtable base = as_db.getSettleBase(m_id, l_cd, "");

	//대여스케줄 여부
	int scd_size = Integer.parseInt(a_db.getFeeScdYn(m_id, l_cd, "1"));
	
	//대여스케줄중 연체리스트
	Vector fee_scd = af_db.getFeeScdDly(m_id);
	int fee_scd_size = fee_scd.size();
	
	//과부족대여료 및 연체료
//	Hashtable exdi = as_db.getFeeNoAmt(m_id, l_cd);
		
	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"))+AddUtil.parseInt((String)base.get("IFEE_S_AMT"));
	int t_dly_amt = 0;
%>	

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;

		//계약만료시 미수금 없어야 함.
/*		if(fm.cls_st.value == '1'){
			var nopay_amt = toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value));
			if(nopay_amt > 0){ 	
				if(toInt(parseDigit(fm.ex_di_amt.value)) > 0)	{ 	alert('과부족 대여료가 있습니다. 확인하십시오.'); return; }
				if(toInt(parseDigit(fm.nfee_amt.value)) > 0)	{ 	alert('미납입 대여료가 있습니다. 확인하십시오.'); return; }
				if(toInt(parseDigit(fm.dly_amt.value)) > 0)		{ 	alert('대여료 연체료가 있습니다. 확인하십시오.'); return; }
				if(toInt(parseDigit(fm.car_ja_amt.value)) > 0)	{ 	alert('자기차량손해면책금이 있습니다. 확인하십시오.'); return; }
				if(toInt(parseDigit(fm.fine_amt.value)) > 0)	{ 	alert('과태료/범칙금이 있습니다. 확인하십시오.'); return; }
			}
		}
*/
		//중도해지,계약만료시 연체리스트 체크 안한거 제외하고 나머지는 삭제한다.
/*		2005-07-18 변경 : 삭제없이 대손처리
		if(fm.cls_st.value == '1' || fm.cls_st.value == '2'){
			var len=fm.elements.length;
			var cnt=0;
			var idnum="";
			for(var i=0 ; i<len ; i++){
				var ck=fm.elements[i];		
				if(ck.name == "dly_chk"){		
					if(ck.checked == true){
						cnt++;
						idnum+=ck.value+",";	//구분자 ',' 포함
					}
				}
			}
			fm.dly_count.value = cnt;
			fm.dly_value.value = idnum.substring(0,idnum.lastIndexOf(","));			
		}
*/		

		if(fm.cls_st.value == '')				{ alert('해지구분을 선택하십시오'); 		fm.cls_dt.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('해지일자를 입력하십시오'); 		fm.cls_dt.focus(); 		return;	}
		if(fm.cls_st.value == '2' && fm.cls_doc_yn.value == 'Y'){
			if(fm.dft_amt.value == '')			{ alert('중도해지위약금을 입력하십시오'); 	fm.dft_amt.focus(); 	return; }
			else if(fm.fdft_amt1.value == '')	{ alert('중도해지정산금을 입력하십시오');	fm.fdft_amt1.focus(); 	return; }
		}
		if(!max_length(fm.cls_cau.value, 400))	{ alert('해지사유는 영문 400자, 한글 200자까지 입력할 수 있습니다'); 	fm.cls_cau.focus(); 	return; }
			
		if(!confirm('처리하시겠습니까?')){ 	return; }
		
		fm.target='i_no';
//		fm.target='CLS_I';
		fm.action='cls_i_a.jsp';
		fm.submit();		
	}
	
	//디스플레이 타입
	function cls_display(){
		var fm = document.form1;
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '3'){ //영업소변경 선택시 디스플레이
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'block';
			tr_opt.style.display 		= 'none';			
		}else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '2'){ //중도해지 선택시 디스플레이
			tr_default.style.display	= 'block';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';	
			fm.cls_doc_yn.value			= 'Y';		
		}else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //매입옵션 선택시 디스플레이
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'block';			
		}else{
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';			
		}
	}	

	//디스플레이 타입
	function cls_display2(){
		var fm = document.form1;
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '2' && fm.cls_doc_yn.options[fm.cls_doc_yn.selectedIndex].value == 'Y'){ //정산서 여부 
			tr_default.style.display	= 'block';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';			
		}else{
			tr_default.style.display	= 'none';
			tr_brch.style.display 		= 'none';
			tr_opt.style.display 		= 'none';			
		}
	}	

	//디스플레이 타입
	function cancel_display(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[1].selected = true;
			alert('중도해지정산금액이 '+fm.fdft_amt2.value+'원으로 환불해야 합니다. \n\n이와 같은 경우에는 매출취소만 가능합니다.');
			return;			
		}		
	}	
	
	//변경된 해지일자로 다시 계산
	function set_day(){
		var fm = document.form1;	
		if(fm.cls_dt.value == ''){ 	alert('해지일자를 입력하십시오'); 	fm.cls_dt.focus(); 	return;	}
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}					
//		fm.action='./cls_nodisplay.jsp';
		fm.action='./cls_settle_nodisplay.jsp';		
		fm.target='i_no';
		fm.submit();
	}
		
	//선납금액 정산 : 자동계산
	function set_cls_amt1(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.ifee_mon || obj == fm.ifee_day){ //개시대여료 경과기간
			if(fm.ifee_s_amt.value != '0'){		
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );		
			}
		}else if(obj == fm.ifee_ex_amt){ //개시대여료 경과금액
			if(fm.ifee_s_amt.value != '0'){		
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );				
			}
		}else if(obj == fm.pded_s_amt){ //선납금 월공제액
			if(fm.pp_s_amt.value != '0'){		
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //선납금 월공제액
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		set_cls_amt();
	}		
	//미납 대여료 정산 : 자동계산
	function set_cls_amt2(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.nfee_mon || obj == fm.nfee_day){ //미납입대여료 기간
			if(fm.nfee_s_amt.value != '0'){		
				fm.nfee_amt.value 		= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
			}
			var no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) - toInt(parseDigit(fm.rifee_s_amt.value));
			var no_v_amt2 				= no_v_amt.toString();
			var len 					= no_v_amt2.length;
			no_v_amt2 					= no_v_amt2.substring(0, len-1);
			fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );								
		}
		fm.d_amt.value 					= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		set_cls_amt();
	}			
	//미납 중도해지위약금 정산 : 자동계산
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //잔여대여계약기간
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			}
		}else if(obj == fm.dft_int){ //위약금 적용요율
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			}			
		}
		fm.d_amt.value 						= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		set_cls_amt();
	}				
	//고객납입하실 금액 셋팅
	function set_cls_amt(){
		var fm = document.form1;	
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)) );
	}	
		
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='./cls_i_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='rent_start_dt' value='<%=base.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base.get("RENT_END_DT")%>'>
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>
<input type='hidden' name='con_mon' value='<%=base.get("CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base.get("IFEE_S_AMT")%>'>
<input type='hidden' name='p_brch_cd' value='<%=l_cd.substring(0,2)%>'>
<input type='hidden' name='dly_count' value=''>
<input type='hidden' name='dly_value' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr> 
      <td><font color="navy">기초정보관리 -> </font><font color="navy">계약관리</font> -> 
        <font color="red">계약조건변경</font> </td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='11%' class='title'>계약번호</td>
            <td width="15%"><%=l_cd%></td>
            <td width='10%' class='title'>상호</td>
            <td><%=base.get("FIRM_NM")%></td>
            <td class='title' width="10%">차량번호</td>
            <td width="14%"><%=base.get("CAR_NO")%></td>
            <td class='title' width="10%">차명</td>
            <td width="15%"><%=base.get("CAR_NM")%></td>
          </tr>
          <tr> 
            <td class='title' width="11%">대여방식</td>
            <td width="15%"><%=base.get("RENT_WAY")%></td>
            <td class='title' width="10%">계약기간</td>
            <td colspan="5"><%=AddUtil.ChangeDate2((String)base.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String)base.get("RENT_END_DT"))%>&nbsp;(<%=base.get("CON_MON")%> 
              개월)</td>
          </tr>
          <tr> 
            <td class='title' width="11%">월대여료</td>
            <td width="15%"><%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>원</td>
            <td class='title' width="10%">선납금</td>
            <td width="15%"><%=AddUtil.parseDecimal((String)base.get("PP_S_AMT"))%>원</td>
            <td class='title' width="10%">개시대여료</td>
            <td width="14%"><%=AddUtil.parseDecimal((String)base.get("IFEE_S_AMT"))%>원</td>
            <td class='title' width="10%">보증금</td>
            <td><%=AddUtil.parseDecimal((String)base.get("GRT_AMT"))%>원</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>해지구분</td>
            <td width="40%"> 
			  <select name="cls_st" onChange='javascript:cls_display()'>
                <option value="1">계약만료</option>
                <option value="8">매입옵션</option>
                <option value="9">폐차</option>
                <option value="2">중도해약</option>
                <option value="3">영업소변경</option>
                <option value="4">출고후차종변경</option>
                <option value="5">계약이관</option>
                <option value="6">매각</option>
                <option value="7">출고전해지</option>
                <option value="10">개시전해지(재리스)</option>
              </select> </td>
            <td width='10%' class='title'>해지일</td>
            <td width="15%"><input type='text' name='cls_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'> 
            </td>
            <td class='title' width="10%">이용기간</td>
            <td width="15%"><input type='text' name='r_mon' value='<%=base.get("R_MON")%>' class='text' size="2">
              개월 
              <input type='text' name='r_day' value='<%=base.get("R_DAY")%>' class='text' size="2">
              일 </td>
          </tr>
          <tr> 
            <td width='10%' class='title'>해지내역 </td>
            <td colspan="5"><textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"></textarea> 
            </td>
          </tr>
          <tr> 
            <td width='10%' class='title'>선납금<br>
              납입방식</td>
            <td> 
			  <select name="pp_st">
                <option value='' <% if(base.get("IFEE_S_AMT").equals("0") && base.get("PP_S_AMT").equals("0")){%>selected<%}%>>해당사항없음</option>
                <option value='1' <% if(!base.get("IFEE_S_AMT").equals("0")){%>selected<%}%>>3개월치대여료 
                선납식</option>
                <option value='2' <% if(!base.get("PP_S_AMT").equals("0")){%>selected<%}%>>고객선택형 
                선납식</option>
              </select> 
			</td>
            <td class='title'>정산서<br>
              작성여부 </td>
            <td> 
			  <select name="cls_doc_yn" onChange='javascript:cls_display2()'>
                <option value="N" selected>없음</option>
                <option value="Y">있음</option>
              </select> 
			</td>
            <td class='title'>잔여선납금<br>
              매출취소여부</td>
            <td> 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'>
                <option value="N">매출유지</option>
                <option value="Y" selected>매출취소</option>
              </select>
			</td>
          </tr>
        </table>
      </td>
    </tr>
    <!-- 정산 -->
    <tr id=tr_default style='display:none'> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td>1. 선납금액 정산 </td>
            <td align="right">[공급가]</td>
          </tr>
          <tr> 
            <td  colspan="2" class='line'> <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' align='right' colspan="3">항목</td>
                  <td class='title' width='35%' align="center">내용</td>
                  <td class='title' width="35%">비고</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="7">환<br>
                    불<br>
                    금<br>
                    액</td>
                  <td class='title' colspan="2">보증금(A)</td>
                  <td width="35%" class='title' > <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td class='title'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">개<br>
                    시<br>
                    대<br>
                    여<br>
                    료</td>
                  <td cwidth="15%" align="center" width="20%">경과기간</td>
                  <td width="35%" align="center"> <input type='text' size='3' name='ifee_mon' value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    개월&nbsp;&nbsp;&nbsp; <input type='text' size='3' name='ifee_day' value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    일</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td cwidth="15%" align="center" width="20%">경과금액</td>
                  <td width="35%" align="center"> <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td>=개시대여료×경과기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 개시대여료(B)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='rifee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td class='title'>=개시대여료-경과금액</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">선<br>
                    납<br>
                    금</td>
                  <td align='center' width="20%">월공제액 </td>
                  <td width='35%' align="center"> <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td>=선납금÷계약기간</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">선납금 공제총액 </td>
                  <td width='35%' align="center"> <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td>=월공제액×실이용기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 선납금(C)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='rfee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td class='title'>=선납금-선납금 공제총액</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">계</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='c_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title'>=(A+B+C)</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td align=''left> 2. 미납입금액 정산</td>
            <td align='right'left>[공급가]</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class="title" colspan="4">항목</td>
                  <td class="title" width='35%'> 내용</td>
                  <td class="title" width='35%'>비고</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="15" width="5%">미<br>
                    납<br>
                    입<br>
                    금<br>
                    액</td>
                  <td class="title" rowspan="5" width="5%"><br>
                    대<br>
                    여<br>
                    료</td>
                  <td align="center" colspan="2">과부족</td>
                  <td class='' width='35%' align="center"> <input type='text' name='ex_di_amt' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_S_AMT"))+AddUtil.parseInt((String)base.get("DI_AMT2")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    원</td>
                  <td width='35%'>&nbsp; </td>
                </tr>
                <tr> 
                  <td rowspan="2" align="center" width="5%">미<br>
                    납<br>
                    입</td>
                  <td width='15%' align="center">기간</td>
                  <td class='' width='35%' align="center"> <input type='text' size='3' name='nfee_mon' value='<%=AddUtil.parseInt((String)base.get("S_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt2(this);'>
                    개월&nbsp;&nbsp;&nbsp; <input type='text' size='3' name='nfee_day' value='<%=AddUtil.parseInt((String)base.get("S_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt2(this);'>
                    일</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="15%">금액</td>
                  <td width='35%' align="center"> <input type='text' size='15' name='nfee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    원</td>
                  <td width='35%'>매출 세금계산서 발행</td>
                </tr>
                <tr> 
                  <td colspan="2" align="center">연체료</td>
                  <td width='35%' align="center"> <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    원</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">대여료 계(D)</td>
                  <td class='title' width='35%' align="center"> <input type='text' size='15' name='d_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td rowspan="6" class="title">중<br>
                    도<br>
                    해<br>
                    지<br>
                    위<br>
                    약<br>
                    금</td>
                  <td align="center" colspan="2">대여료총액</td>
                  <td class='' width='35%' align="center"> <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    원</td>
                  <td width='35%'>=선납금+월대여료총액</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">월대여료(환산)</td>
                  <td class='' width='35%' align="center"> <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    원</td>
                  <td width='35%'>=대여료총액÷계약기간</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여대여계약기간</td>
                  <td class='' width='35%' align="center"> <input type='text' name='rcon_mon' size='3' value='<%=AddUtil.parseInt((String)base.get("N_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    개월&nbsp;&nbsp;&nbsp; <input type='text' name='rcon_day' size='3' value='<%=AddUtil.parseInt((String)base.get("N_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    일</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여기간 대여료 총액</td>
                  <td class='' width='35%' align="center"> <input type='text' name='trfee_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    원</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2"><font color="#FF0000">*</font>위약금 
                    적용요율</td>
                  <td class='' width='35%' align="center"> <input type='text' name='dft_int' value='<%=base.get("CLS_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                    %</td>
                  <td width='35%'>위약금 적용요율은 계약서를 확인</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">중도해지위약금(E)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='dft_amt' size='15' class='num' value='' onBlur='javascript:set_cls_amt()'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td rowspan="4" class="title">기<br>
                    타</td>
                  <td class="title" colspan="2">자기차량손해면책금(F)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='car_ja_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("CAR_JA_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("SERV_CNT")%>건</font></a><font color="#66CCFF">&nbsp;</font></td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">과태료/범칙금(G)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='fine_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FINE_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("FINE_CNT")%>건</font></a><font color="#66CCFF">&nbsp;</font></td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">차량회수비용(H)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='etc_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">부가세(I)</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='no_v_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td id=td_cancel_n style='display:block' class='title'>=(대여료 
                          미납입금액-B-C)×10% </td>
                        <td id=td_cancel_y style='display:none' class='title'>=대여료 
                          미납입금액×10% </td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">계</td>
                  <td class='title' width='35%' align="center"> <input type='text' name='fdft_amt1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>=(D+E+F+G+H+I)</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td  colspan="2" align=''left> 3. 고객께서 납입하실 금액</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%">총 액</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt2' value=''size='15' class='num' maxlength='15'>
                    원 </td>
                  <td class='title' width="35%"> =미납입금액계-환불금액계</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="2" align='left' > <<정산내역>> </td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width="20%"> DC</td>
                  <td  colspan="3"> 
                    <input type='text' name='fdft_dc_amt' value='' size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                </tr>
                <tr> 
                  <td class='title' width="20%"> 공급가</td>
                  <td width="30%"> 
                    <input type='text' name='cls_s_amt' value=''size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td class='title' width="20%"> 부가세</td>
                  <td width="30%"> 
                    <input type='text' name='cls_v_amt' value='' size='15' class='num' maxlength='15' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                </tr>
                <tr> 
                  <td class='title' width="20%">위약금지급예정일 </td>
                  <td width="30%"> 
                    <input type='text' name='cls_est_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                  </td>
                  <td class='title' width="20%"> 세금계산서발행일</td>
                  <td width="30%"> 
                    <input type='text' name='ext_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                    <select name='ext_id'>
                      <option value=''>담당자</option>
                      <%if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                      <option value='<%= user.get("USER_ID") %>' ><%= user.get("USER_NM")%></option>
                      <%	}
					}		%>
                    </select>
                  </td>
                </tr>
                <tr> 
                  <td class='title' width="20%"> 위약금면제여부 </td>
                  <td colspan="3">면제 
                    <input type='checkbox' name='no_dft_yn' value="Y">
                    &nbsp;&nbsp;면제사유: 
                    <textarea name='no_dft_cau' rows='2' cols='80'></textarea>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
		  <!--
          <%if(fee_scd_size>0){//2005-07-18 변경 : 삭제없이 대손처리%>
          <tr> 
            <td colspan="2" align='left' > <<연체리스트>> </td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width="100">회차</td>
                  <td class='title' width="110">구분</td>
                  <td class='title' width="200">월대여료</td>
                  <td class='title' width="150">연체일수</td>
                  <td class='title' width="150">연체료</td>
                  <td class='title' width="90">면제</td>
                </tr>
                <%for(int i = 0 ; i < fee_scd_size ; i++){
				  FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);%>
                <tr> 
                  <td width="100" align="center"> 
                    <%if(a_fee.getTm_st1().equals("0")){%>
                    <%=a_fee.getFee_tm()%> 
                    <%}%>
                  </td>
                  <td width="110" align="center"> 
                    <%if(a_fee.getTm_st1().equals("0")){%>
                    대여료 
                    <%}else{%>
                    잔액 
                    <%}%>
                  </td>
                  <td width="200" align='right'><%=AddUtil.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>원&nbsp;</td>
                  <td width="150" align="center"><%=a_fee.getDly_days()%>일</td>
                  <td width="150" align='right'><%=AddUtil.parseDecimal(a_fee.getDly_fee())%>원&nbsp;</td>
                  <td align="center" width="90"> 
                    <input type='checkbox' name='dly_chk' value='<%=a_fee.getRent_st()+a_fee.getFee_tm()+a_fee.getTm_st1()%>'>
                  </td>
                </tr>
                <%	t_dly_amt = t_dly_amt + a_fee.getDly_fee();
				}%>
              </table>
            </td>
          </tr>
          <%	}	%>
		  -->
        </table>
      </td>
    </tr>
    <!-- 영업소변경 -->
    <tr id=tr_brch style='display:none'> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td> <<영업소변경>> </td>
          </tr>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width="10%">전관리지점</td>
                  <td width="15%"><%=c_db.getNameById((String)fee_base.get("BRCH_ID"), "BRCH")%>(<%=fee_base.get("BRCH_ID")%>) 
                  </td>
                  <td class='title' width="10%">이관관리저점</td>
                  <td width="15%">
                    <select name='new_brch_cd'>
                      <option value=''>선택</option>
                      <%if(brch_size > 0)	{
						for(int i = 0 ; i < brch_size ; i++){
							Hashtable branch = (Hashtable)branches.elementAt(i);		%>
                      <option value='<%=branch.get("BR_ID")%>'><%= branch.get("BR_NM")%></option>
                      <%	}
					  }	%>
                    </select>
                  </td>
                  <td class='title' width="10%">이관일자</td>
                  <td width="40%">
                    <input type='text' name='trf_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <!-- 매입옵션 -->
    <tr id=tr_opt style='display:none'> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td> <<매입옵션>> </td>
          </tr>
          <tr> 
            <td class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width="10%">매입옵션율</td>
                  <td width="15%"> 
                    <input type='text' name='opt_per' value='<%=fee_base.get("OPT_PER")%>' size='5' class='num' maxlength='4'>
                    %</td>
                  <td class='title' width="10%">매입옵션가</td>
                  <td width="15%">
                    <input type='text' name='opt_amt'size='13' class='num' value="<%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("OPT_AMT")))%>" onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td class='title' width="10%">이전일자</td>
                  <td width="15%">
                    <input type='text' name='opt_dt' size='10' class='text' onBlur='javascript: this.value = ChangeDate(this.value)'>
                  </td>
                  <td class='title' width="10%">이전담당자</td>
                  <td width="15%">
            	  <select name='opt_mng'>
	                <option value=''>담당자</option>
    	            <%if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	
					%>
                	<option value='<%= user.get("USER_ID") %>'><%= user.get("USER_NM")%></option>
	                <%	}
						}		%>
        	      </select>				  
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp; </td>
      <td align="right">&nbsp;</td>
    </tr>
    <tr>
      <td>
        <%if(fee_base.get("FEE_CHK").equals("1")){%>
        <font color="#FF0000">※</font>월대여료 일시완납입니다. 중도해지 위약금은 없습니다. 
        <%}%>
      </td>
      <td align="right">
	  <a href='javascript:<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>save();<%}else{%>alert("권한이 없습니다");<%}%>' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0" alt="등록"></a>
		<a href='javascript:window.close();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="닫기"></a></td>
    </tr>
  </table>  
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;

		var ifee_tm = 0;
		var pay_tm = 0;
		
		//잔여개시대여료
		if(fm.ifee_s_amt.value != '0'){
			ifee_tm = toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value)) ;
			pay_tm = toInt(fm.con_mon.value)-ifee_tm;
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
				fm.ifee_day.value 	= fm.r_day.value;
			}
			var ifee_ex_amt = 0;
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
		}
		
		//선납금액 정산 초기 셋팅
		if(fm.pp_s_amt.value != '0'){
			if(fm.ifee_s_amt.value == '0'){
				fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
			}
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );
		}else{
			fm.pded_s_amt.value 	= "0";
			fm.tpded_s_amt.value 	= "0";
			fm.rfee_s_amt.value 	= "0";
		}
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );

		//미납입금액 정산 초기 셋팅		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}
		fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		
		if(fm.r_day.value != '0'){
			fm.rcon_mon.value 		= toInt(fm.con_mon.value) - toInt(fm.r_mon.value) - 1;
			fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
		}else{
			fm.rcon_mon.value = toInt(fm.con_mon.value) - toInt(fm.r_mon.value);
			fm.rcon_day.value = fm.r_day.value;			
		}	
		if(fm.pp_s_amt.value != '0'){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}		
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}				
		if(fm.dft_int.value == '')	fm.dft_int.value 			= 30;
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
		
		var no_v_amt =0;
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'Y'){
			no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) - toInt(parseDigit(fm.rifee_s_amt.value));
		}else{
			no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value));
		}				
		var no_v_amt2 				= no_v_amt.toString();
		var len 					= no_v_amt2.length;
		no_v_amt2 					= no_v_amt2.substring(0, len-1);
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)));
		
		//고객이 납입할 금액 초기 셋팅	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)) );		
	}
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
