<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.credit.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/agent/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
		
	//검색구분
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	
	//기본정보
	Hashtable fee_base = af_db.getFeebasecls3(rent_mng_id, rent_l_cd);

	//대여스케줄 여부
	int scd_size = Integer.parseInt(a_db.getFeeScdYn(rent_mng_id, rent_l_cd, "1"));

	//대여스케줄중 연체리스트
	Vector fee_scd = af_db.getFeeScdDly(rent_mng_id);
	int fee_scd_size = fee_scd.size();

	//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st();
	
	
		//해지기타 추가 정보
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);
	
	int pp_amt = AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT"));
	

//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_p.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//선납금액정산 셋팅
	function set_a_amt(){
		var fm = document.form1;	
			
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
		set_cls_amt();		
	}
	
	//미납입금액정산 셋팅
	function set_b_amt(){
		var fm = document.form1;
		set_cls_amt();
	}	
	
	//고객납입하실 금액 셋팅
	function set_c_amt(){
		var fm = document.form1;	
		fm.fdft_amt1_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) );
		set_cls_amt();
	}	
				
	//고객납입하실 금액 셋팅
	function set_cls_amt(){
		var fm = document.form1;	
		
		fm.fdft_amt2.value 		= 	parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );			
	}	
	
	//위약금
		
//-->
</script>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 10.0; //좌측여백   
		factory.printing.rightMargin 	= 10.0; //우측여백
		factory.printing.topMargin 	= 5.0; //상단여백    
		factory.printing.bottomMargin 	= 5.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}

</script>

</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form name='form1' method='post' >
<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
<input type='hidden' name='rent_way' value='<%=ext_fee.getRent_way()%>'>
<input type='hidden' name='con_mon' value='<%=fee_base.get("TOT_CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
<input type='hidden' name='fee_chk' value='<%=fee_base.get("FEE_CHK")%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=650>
    <tr align="center"> 
       <td colspan="2"><font color="#006600">&lt; 장기대여 <%=cls.getCls_st()%> 정산서 &gt;</font></td>
    </tr>  
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>계약번호</td>
            <td width="15%"><%=rent_l_cd%></td>
            <td width='10%' class='title'>상호</td>
            <td colspan="3"><%=fee_base.get("FIRM_NM")%></td>
            <td class='title' width="10%">고객명</td>
            <td width="15%"><%=fee_base.get("CLIENT_NM")%></td>
          </tr>
          <tr> 
            <td class='title' width="10%">차량번호</td>
            <td width="15%"><font color="#000099"><b><%=fee_base.get("CAR_NO")%></b></font></td>
            <td width='10%' class='title'>차명</td>
            <td colspan="3"><%=fee_base.get("CAR_NM")%></td>
            <td class='title' width="10%">최초등록일</td>
            <td><%=fee_base.get("INIT_REG_DT")%></td>
          </tr>
          <tr> 
            <td class='title' width="10%">대여방식</td>
            <td width="15%"><font color="#000099"> 
              <%if(ext_fee.getRent_way().equals("1")){%>
              일반식 
              <%}else if(ext_fee.getRent_way().equals("2")){%>
              맞춤식 
              <%}else{%>
              기본식 
              <%}%>
              </font></td>
            <td class='title' width="10%">대여기간</td>
            <td colspan="3"><%=fee_base.get("RENT_START_DT")%>~&nbsp; 
              <%if(fee_base.get("RENT_ST").equals("1")){ out.println(fee_base.get("RENT_END_DT")); }else{ out.println(fee_base.get("EX_RENT_END_DT")); }%>
            </td>
            <td class='title' width="10%">계약기간</td>
            <td><%=fee_base.get("TOT_CON_MON")%> 개월</td>
          </tr>
          <tr> 
            <td class='title' width="10%">월대여료</td>
            <td width="15%"> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_FEE_AMT")))%> 
              <%}%>
              원</td>
            <td class='title' width="10%">선납금</td>
            <td width="15%"> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("PP_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_PP_AMT"))%> 
              <%}%>
              원</td>
            <td class='title' width="10%">개시대여료</td>
            <td width="15%"> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("IFEE_AMT"))%> 
              <%}else{%>
              <%//=AddUtil.parseDecimal((String)fee_base.get("EX_IFEE_AMT"))%>
			  <%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>  
              <%}%>
              원</td>
            <td class='title' width="10%">보증금</td>
            <td> 
              <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("GRT_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_GRT_AMT"))%> 
              <%}%>
              원</td>
          </tr>
        </table>
      </td>
    </tr>
   
    <tr>
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='10%' class='title'>해지구분</td>
            <td width="15%"><%=cls.getCls_st()%> 
            </td>
            <td width='10%' class='title'>해지일</td>
            <td width="15%"> 
              <%=cls.getCls_dt()%>
            </td>
            <td class='title' width="10%">이용기간</td>
            <td width="40%"> 
              <%=cls.getR_mon()%>
              개월 
              <%=cls.getR_day()%>
              일</td>
          </tr>
		
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp; </td>
    </tr>	
    
    <!-- 매입옵션인 경우 매입옵션 관련 사항  -->
    <tr id=tr_opt style="display:<%if( cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 

 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매입옵션</span></td>
 	 	  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	 <input type='hidden' name='opt_amt' value='<%=AddUtil.parseDecimal(cls.getOpt_amt())%>' >
		    	 <input type='hidden' name='sui_d_amt' value='<%=AddUtil.parseDecimal(clsm.getSui_d_amt())%>' >
		    	 
		          <tr> 
		             <td class='title' width="13%">매입옵션가</td>
		             <td colspan=6>&nbsp;<%=AddUtil.parseDecimal(cls.getOpt_amt())%> 원&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT포함)</td> 
		           
                  </tr>	
                                
		          <tr> 
		 	 	     <td class='title' width="13%" rowspan=3>이전등록비용</td>
		             <td class='title' width="13%">등록세</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d1_amt())%> 원 
		             <td class='title' width="13%">채권할인</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d2_amt())%> 원 
		             <td class='title' width="13%">취득세</td>
		             <td >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d3_amt())%> 원 
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">인지대</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d4_amt())%> 원
		             <td class='title' width="13%">증지대</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d5_amt())%> 원
		             <td class='title' width="13%">번호판대</td>
		             <td >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d6_amt())%> 원
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">보조번호판대</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d7_amt())%> 원
		             <td class='title' width="13%">등록대행료</td>
		             <td width="13%" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d8_amt())%> 원
		             <td class='title' width="13%">계</td>
		             <td >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d_amt())%> 원
		          </tr>  
		       </table>
		      </td>        
         </tr>   
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
       
    <tr id=tr_default style="display:''"> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선납금액 정산</span></td>
            <td align="right">[공급가]</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
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
                    <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    원</td>
                  <td class='title'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">개<br>
                    시<br>
                    대<br>
                    여<br>
                    료</td>
                  <td width="20%" align="center" >경과기간</td>
                  <td width="35%" align="center"> 
                    <input type='text' size='3' name='ifee_mon' value='<%=cls.getIfee_mon()%>' class='num' maxlength='4' >
                    개월&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='ifee_day' value='<%=cls.getIfee_day()%>' class='num' maxlength='4' >
                    일</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td width="20%" align="center">경과금액</td>
                  <td width="35%" align="center"> 
                    <input type='text' name='ifee_ex_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원</td>
                  <td>=개시대여료×경과기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 개시대여료(B)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원</td>
                  <td class='title'>=개시대여료-경과금액</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">선<br>
                    납<br>
                    금</td>
                  <td align='center' width="20%">월공제액 </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='pded_s_amt' value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td>=선납금÷계약기간</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">선납금 공제총액 </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원</td>
                  <td>=월공제액×실이용기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 선납금(C)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
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
                <tr> 
                  <td class='title' align='right' colspan="3">추가입금액</td>
                  <td  width='35%' align="center" class='title' > 
                    <input type='text' name='ex_ip_amt' value='<%=AddUtil.parseDecimal(clsm.getEx_ip_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원</td>
                  <td >=추가입금액이 있는 경우</td>
                </tr>
              </table>			
            </td>
          </tr>
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납입금액 정산</span></td>
            <td align='right'>[공급가]</td>
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
                  <td class="title" rowspan="18" width="5%">미<br>
                    납<br>
                    입<br>
                    금<br>
                    액</td>
                  <td colspan="3" class="title">과태료/범칙금(D)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='fine_amt_1' value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td class='title' >&nbsp;</td>
                </tr>
                 <tr> 
                  <td colspan="3" class="title">자기차량손해면책금(E)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='car_ja_amt_1' value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원 </td>
                  <td class='title'>&nbsp;</td>
                </tr>
                <tr> 
                   <td class="title" rowspan="4" width="5%"><br>
                    대<br>
                    여<br>
                    료</td>
                  <td align="center" colspan="2">과부족</td>
                  <td align="center">&nbsp; 
                    <input type='text' name='ex_di_amt_1' value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                  원&nbsp; </td>
                  <td >&nbsp; </td>
                </tr>
                <tr> 
                  <td rowspan="2" align="center" width="10%">미납입</td>
                  <td width='10%' align="center">기간</td>
                  <td align="center"> &nbsp; 
                    <input type='text' size='4' name='nfee_mon' value='<%=cls.getNfee_mon()%>' class='num' maxlength='4'>
                    개월 
                    <input type='text' size='4' name='nfee_day' value='<%=cls.getNfee_day()%>' class='num'  maxlength='4'>
                  일</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">금액</td>
                  <td align="center"> 
                    <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원</td>
                  <td >매출 세금계산서 발행</td>
                </tr>
                
                <tr> 
                  <td class="title" colspan="2">소계(F)</td>
                  <td class='title' align="center">
                    <input type='text' name='dfee_amt' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' onBlur='javascript:this.value=parseDecimal(this.value); '>
                  원 </td>
                  <td class='title' >&nbsp;</td>
                </tr>
                 <input type='hidden' name='d_amt' size='15' class='whitenum' >
                <tr> 
                  <td rowspan="6" class="title">중<br>
                    도<br>
                    해<br>
                    지<br>
                    위<br>
                    약<br>
                    금</td>
                  <td align="center" colspan="2">대여료총액</td>
                  <td align="center"> 
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원</td>
                  <td >=선납금+월대여료총액</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">월대여료(환산)</td>
                  <td align="center"> 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원</td>
                  <td >=대여료총액÷계약기간</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여대여계약기간</td>
                  <td align="center"> 
                    <input type='text' name='rcon_mon' size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4'>
                    개월 
                    <input type='text' name='rcon_day' size='3' value='<%=cls.getRcon_day()%>' class='num' maxlength='4' onBlur='javascript:set_b_amt();'>
                  일</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여기간 대여료 총액</td>
                  <td align="center"> 
                    <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">위약금 적용요율</td>
                  <td align="center"> 
                    <input type='text' name='dft_int' value='<%=cls.getDft_int()%>' size='5' class='num' onBlur='javascript:set_b_amt()' maxlength='4'>
                  %</td>
                  <td >잔여기간 대여료 총액 기준</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">중도해지위약금(G)</td>
                  <td class='title' align="center"> 
                    <input type='text' name='dft_amt_1' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원&nbsp;</td>
                  <td align="left"><%if(cls.getTax_chk0().equals("Y")){%>위약금 계산서 발행<%}%></td>
                </tr>
                         
                <tr> 
                 <td class="title" rowspan="5" width="5%"><br>
                    기<br>
                    타</td> 
                
                  <td colspan="2" class="title">연체료(H)</td>
                  <td align="center" width=20%> 
                    <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원 </td>
                  <td >&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="2" class="title">차량회수외주비용(I)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td align="left"><%if(cls.getTax_chk1().equals("Y")){%>차량회수외주비용 계산서 발행<%}%></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">차량회수부대비용(J)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc2_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td align="left"><%if(cls.getTax_chk2().equals("Y")){%>차량회수부대비용 계산서 발행<%}%></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">잔존차량가격(K)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc3_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">기타손해배상금(L)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc4_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td align="left"><%if(cls.getTax_chk3().equals("Y")){%>기타손해배상금 계산서 발행<%}%></td>
                </tr>
              
                <tr> 
                  <td colspan="3" class="title">부가세(M)</td>
                  <td class='title' align="center"> 
                    <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원 </td>
                  <td class='title' width='35%' >
                  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td id=td_cancel_n style="display:''" class='title'>=(미납입금액-B-C)×10% + 계산서 발행부가세
                        </td>
                        <td id=td_cancel_y style='display:none' class='title'>=(미납입금액-B-C)×10% + 계산서 발행부가세
                        </td>
                      </tr>
                      </table>
                    </td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">계</td>
                  <td class='title' align="center"> 
                    <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원 </td>
                  <td class='title' width='35%' >=(D+E+F+G+H+I+J+K+L+M)</td>
                </tr>
              </table>
            </td>
          </tr>
          
         <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객께서 납입하실 금액</span></td>
          </tr>
          <tr> 
            <td colspan="2" class="line"> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%">고객납입금액</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt2' value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>'size='15' class='num' maxlength='15'>
                  원 </td>
                  <td class='title' width="35%"> =미납입금액계-환불금액계</td>
                </tr>
                <tr id=tr_sale style="display:<%if( cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 
                 
		    	  <td class='title' width="30%">매입옵션시 고객납입금액</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt3' value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>'size='15' class='num' maxlength='15'>
                  원 </td>
                  <td class='title' width="35%"> =고객납입금액+차량매각금액+이전등록비용(발생한 경우)</td>			
                </tr>
              </table>
            </td>
          </tr>
          <%	//이행보증보험
				ContGiInsBean gins = a_db.getContGiIns(rent_mng_id, rent_l_cd);%>
          <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증보험 가입</span></td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%"> 
                    <%if(gins.getGi_amt() > 0){%>
                    가입 
                    <%}else{%>
                    면제 
                    <%}%>
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
      <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>입금계좌</span>&nbsp;&nbsp;&nbsp;* 신한은행 140-004-023871 (주)아마존카</td>
    </tr>	

  </table>
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
		fm.d_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
	}
//-->
</script>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
