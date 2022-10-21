<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.cls.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	if(m_id.equals(""))	m_id = as_db.getRent_mng_id(l_cd);

	//기본정보
	Hashtable base = as_db.getSettleBase(m_id, l_cd, "");
	
	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"));
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
%>	

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_p.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//디스플레이 타입
	function cancel_display(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[0].checked = true;
			alert('중도해지정산금액이 '+fm.fdft_amt2.value+'원으로 환불해야 합니다. \n\n이와 같은 경우에는 매출취소만 가능합니다.');
			return;			
		}
	}	
	
	//실이용기간 세싱
	function set_day(){
		var fm = document.form1;	
		if(fm.cls_dt.value == ''){ alert('해지일자를 입력하십시오'); fm.cls_dt.focus(); return;	}
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}		
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
			  //개시대여료가 있으면서 미납분이 있는 경우는 별도로 처리해야 함 - 환불에는 개시대여료 이후 경과금액에 표시, 미납은 개시대여료 이전까지만 표시해야함,
	 		  // 경과기간이 없는 경우 처리는 ??
			    if(fm.nfee_mon.value != '0' &&  fm.ifee_s_amt.value != '0'){
				    	 fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value) -toInt(fm.ifee_mon.value)) );				
				 } else {
				      	 fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
				 }	
			    			
			//	fm.nfee_amt.value 		= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
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
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.etc5_amt.value))+ toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
//		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt.value)) );
//		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)) );
	}	
		
//-->
</script>
</head>
<body>
<form name='form1' method='post' >
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='rent_start_dt' value='<%=base.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base.get("RENT_END_DT")%>'>
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>
<input type='hidden' name='con_mon' value='<%=base.get("CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base.get("IFEE_S_AMT")%>'>
<input type='hidden' name='fee_s_amt' value='<%=base.get("FEE_S_AMT")%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=630>
    <tr align="center"> 
      <td colspan="2"><font color="#006600">&lt; 장기대여 <input type='text' name='settle_title' value='중도해지' class='whitetext' size="7"> 정산서 &gt;</font></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
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
            <td colspan="5"><%=AddUtil.ChangeDate2((String)base.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String)base.get("RENT_END_DT"))%>&nbsp;(<%=base.get("CON_MON")%> 개월)</td>
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
          <tr> 
            <td class='title' width="11%"><font color="#FF0000">*</font>정산기준일</td>
            <td width="15%"> 
              <input type='text' name='cls_dt' value='<%=base.get("CLS_DT")%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'>
            </td>
            <td class='title' width="10%">이용기간</td>
            <td> 
              <input type='text' name='r_mon' value='<%=base.get("R_MON")%>'   class='text' size="2">
              개월 
              <input type='text' name='r_day' value='<%=base.get("R_DAY")%>' class='text' size="2">
              일 </td>
            <td class='title' colspan="2"><font color="#FF0000">*</font>잔여선납금 
              매출취소여부</td>
            <td colspan="2"> 
              <input type="radio" name="cancel_yn" value="Y" checked  onclick="javascript:cancel_display();">
              매출취소 
              <input type="radio" name="cancel_yn" value="N" onclick="javascript:cancel_display();">
              매출유지</td>
          </tr>
        </table>
      </td>
    </tr>
    <!-- 정산 -->
    <tr> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr align="right"> 
            <td colspan="2"><font color="#999999">※ 매출취소시 마이너스 세금계산서 발행</font></td>
          </tr>
          <tr> 
            <td>1. 선납금액 정산 </td>
            <td align="right">[공급가]</td>
          </tr>
          <tr> 
            <td  colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
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
                  <td width="35%" class='title' > 
                    <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
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
                  <td width="35%" align="center"> 
                    <input type='text' size='3' name='ifee_mon'  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    개월&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='ifee_day'  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    일</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td cwidth="15%" align="center" width="20%">경과금액</td>
                  <td width="35%" align="center"> 
                    <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td>=개시대여료×경과기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 개시대여료(B)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td class='title'>=개시대여료-경과금액</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">선<br>
                    납<br>
                    금</td>
                  <td align='center' width="20%">월공제액 </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td>=선납금÷계약기간</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">선납금 공제총액 </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td>=월공제액×실이용기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 선납금(C)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td class='title'>=선납금-선납금 공제총액</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">계</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='c_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title'>=(A+B+C)</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td align=''left> 2. 미납입금액 정산</td>
            <td align='right'left>[공급가]</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class="title" colspan="4">항목</td>
                  <td class="title" width='35%'> 내용</td>
                  <td class="title" width='35%'>비고</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="19" width="5%">미<br>
                    납<br>
                    입<br>
                    금<br>
                    액</td>
                  <td class="title" colspan="3">과태료/범칙금(D)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='fine_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FINE_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("FINE_CNT")%>건</font></a><font color="#66CCFF">&nbsp;</font></td>
                 </tr>
                 <tr> 
                  <td class="title" colspan="3">자기차량손해면책금(E)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='car_ja_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("CAR_JA_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("SERV_CNT")%>건</font></a><font color="#66CCFF">&nbsp;</font></td>
                </tr>
                 <tr>
                  <td class="title" rowspan="5" width="5%"><br>
                    대<br>
                    여<br>
                    료</td>
                  <td align="center" colspan="2">과부족</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='ex_di_amt' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_S_AMT"))+AddUtil.parseInt((String)base.get("DI_AMT2")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    원</td>
                  <td width='35%'>&nbsp; </td>
                </tr>
            
                <tr> 
                  <td rowspan="2" align="center" width="5%">미<br>
                    납<br>
                    입</td>
                  <td width='15%' align="center">기간</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' size='3' name='nfee_mon'  value='<%=AddUtil.parseInt((String)base.get("S_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt2(this);'>
                    개월&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='nfee_day'  value='<%=AddUtil.parseInt((String)base.get("S_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt2(this);'>
                    일</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="15%">금액</td>
                  <td width='35%' align="center"> 
                    <input type='text' size='15' name='nfee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    원</td>
                  <td width='35%'>매출 세금계산서 발행</td>
                </tr>
                <tr> 
                  <td colspan="2" align="center">연체료</td>
                  <td width='35%' align="center"> 
                    <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    원</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">대여료 계(F)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' size='15' name='d_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
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
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    원</td>
                  <td width='35%'>=선납금+월대여료총액</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">월대여료(환산)</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    원</td>
                  <td width='35%'>=대여료총액÷계약기간</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여대여계약기간</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='rcon_mon' size='3' value='<%=AddUtil.parseInt((String)base.get("N_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    개월&nbsp;&nbsp;&nbsp; 
                    <input type='text' name='rcon_day' size='3' value='<%=AddUtil.parseInt((String)base.get("N_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    일</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여기간 대여료 총액</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='trfee_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    원</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2"><font color="#FF0000">*</font>위약금 
                    적용요율</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='dft_int' value='<%=base.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                    %</td>
                  <td width='35%'>위약금 적용요율은 계약서를 확인</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">중도해지위약금(G)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='dft_amt' size='15' class='num' value='' onBlur='javascript:set_cls_amt()'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>      
           
                <tr> 
                  <td class="title" rowspan="6" width="5%"><br>
                    기<br>
                    타</td> 
                  <td class="title" colspan="2">차량회수외주비용(H)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">차량회수부대비용(I)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc2_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">잔존차량가격(J)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc3_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">기타손해배상금(K)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc4_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">기타(L)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc5_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">부가세(M)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='no_v_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td id=td_cancel_n style='display:block' class='title'>=(대여료 
                          미납입금액-B-C)×10% </td>
                        <td id=td_cancel_y style='display:none' class='title'>=대여료 
                          미납입금액×10% </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">계</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='fdft_amt1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>=(D+E+F+G+H+I+J+K+L+M)</td>
                </tr>
              </table>
            </td>
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
                    <input type='text' name='fdft_amt2' value='' size='15' class='num' maxlength='15'>
                    원</td>
                  <td class='title' width="35%"> =미납입금액계-환불금액계</td>
                </tr>
              </table>
            </td>
          </tr>
          <%	//이행보증보험
				ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);%>
          <tr> 
            <td  colspan="2" align=''left> 4. 보증보험 가입</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%"> 
                    <%if(car.getGi_st().equals("1")){%>가입<%}else if(car.getGi_st().equals("0")){ gins.setGi_amt(0);%>면제<%}%>
                  </td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' maxlength='15'>
                    원</td>
                  <td class='title' width="35%"></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
      <td>&nbsp; </td>
      <td align="right"> <a href='javascript:window.close();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
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

		//잔여선납금?
		if(fm.pp_s_amt.value != '0'){
			fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
			fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );//+ toInt(parseDigit(fm.ifee_s_amt.value)) 
		}else{
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;
		}
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );//

		//미납입금액 정산 초기 셋팅		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}
	
	   //개시대여료가 있으면서 미납분이 있는 경우는 별도로 처리해야 함 - 환불에는 개시대여료 이후 경과금액에 표시, 미납은 개시대여료 이전까지만 표시해야함,
	   // 경과기간이 없는 경우 처리는 ??
	    if(fm.nfee_mon.value != '0' &&  fm.ifee_s_amt.value != '0'){
	    	 fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value) -toInt(fm.ifee_mon.value)) );				
	    } else {
	      	 fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
		}
		   	
	  	//fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		
		if(fm.r_day.value != '0'){
			fm.rcon_mon.value 		= toInt(fm.con_mon.value) - toInt(fm.r_mon.value) - 1;
			fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
		}else{
			fm.rcon_mon.value = toInt(fm.con_mon.value) - toInt(fm.r_mon.value);
			fm.rcon_day.value = fm.r_day.value;			
		}	

		if(toInt(parseDigit(fm.pp_s_amt.value)) > 0){
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
		
		var no_v_amt 				= toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.ex_di_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) - toInt(parseDigit(fm.rifee_s_amt.value));
		var no_v_amt2 				= no_v_amt.toString();
		var len 					= no_v_amt2.length;
		no_v_amt2 					= no_v_amt2.substring(0, len-1);
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)));
		
		//고객이 납입할 금액 초기 셋팅	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			

		if(toInt(fm.rent_end_dt.value) <= toInt(replaceString("-","",fm.cls_dt.value))){
			fm.settle_title.value = '계약만료';
//			alert('계약만료');
		}else{
			fm.settle_title.value = '중도해지';		
//			alert('중도해지');		
		}
		
		if(toInt(parseDigit(fm.fee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			alert("월대여료와 중도해지위약금 월대여료(환산)이 틀립니다. 확인하시기 바랍니다.");
		}
		
	}	
	
	var msg = " 일할계산 ==> 대여료스케줄 확인 필!!";
	var cnt = 0;
	
	function stat(){
		if(cnt==0){
			window.status = msg;
			cnt++;
		}else{
			window.status = '';		
			cnt--;			
		}
		setTimeout("stat()",500);	
	}
	document.onload = stat();
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
