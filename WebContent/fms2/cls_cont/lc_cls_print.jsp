<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.credit.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
		
	//검색구분
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String gg = request.getParameter("gg")==null?"":request.getParameter("gg");
	
	
	//사원 사용자 리스트
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
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
	
		//기본정보
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls.getCls_dt(), "");
	
	
	int pp_amt = AddUtil.parseInt((String)fee_base.get("PP_AMT"))+AddUtil.parseInt((String)fee_base.get("IFEE_AMT"));
	

//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	ContCarBean  car1 =  new ContCarBean();
		//fee 기타 - 주행거리 초과분 계산  - fee_etc 의  over_run_amt > 0보다 큰 경우 해당됨
    if ( cls_st.equals("월렌트해지")) {
   		  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
    } else {	
		  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	}
		
	ClsEtcOverBean co = ac_db.getClsEtcOver(rent_mng_id, rent_l_cd);
		
	// 선수금정산정보	
	ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);
	
	ClsEtcAddBean clsa 	= ac_db.getClsEtcAddInfo(rent_mng_id, rent_l_cd);
	
	int vt_size8 = 0;
		
	Vector vts8 = ac_db.getClsEtcDetailList(rent_mng_id,  rent_l_cd);
	vt_size8 = vts8.size(); 	
	
	int maeip_amt = 0;	 //매입옵션인 경우 대체입금 
	int m_ext_amt = 0;  //매입옵션인 경우 환불/잡이익 
		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<!--<link rel=stylesheet type="text/css" href="../../include/table.css">-->
<link rel=stylesheet type="text/css" href="../../include/table_p.css">
<!-- <style>
.a4 { page: a4sheet; page-break-after: always }
</style> -->

<style type="text/css" media="print">
    @page {
        size:  auto;
        margin: 5mm 0mm 5mm 0mm;
    }
    html {
        background-color: #FFFFFF;
        margin: 0px;
    }
    body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	/* transform: scale(.8); */    	
        /* margin으로 프린트 여백 조정 */
        /* IE */
        margin: 0mm 0mm 0mm 18mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*상단*/
		-webkit-margin-end: 0mm; /*우측*/
		-webkit-margin-after: 0mm; /*하단*/
		-webkit-margin-start: 20mm; /*좌측*/
    }
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//선납금액정산 셋팅
	function set_a_amt(){
		var fm = document.form1;	
			
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value))   + toInt(parseDigit(fm.ex_ip_amt.value)) );
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
		fm.fdft_amt1_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.no_v_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value)) );
		set_cls_amt();
	}	
				
	//고객납입하실 금액 셋팅
	function set_cls_amt(){
		var fm = document.form1;	
		
		fm.fdft_amt2.value 		= 	parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value))  + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );			
	}	
	
	//위약금
		
//-->
</script>
<script language="JavaScript" type="text/JavaScript">	
	/* function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 10.0; //좌측여백   
		factory.printing.rightMargin 	= 10.0; //우측여백
		factory.printing.topMargin 	= 5.0; //상단여백    
		factory.printing.bottomMargin 	= 5.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	
	} */
	function ieprint() {
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 10.0; //좌측여백   
		factory.printing.rightMargin 	= 10.0; //우측여백
		factory.printing.topMargin 	= 5.0; //상단여백    
		factory.printing.bottomMargin 	= 5.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}
	
	function onprint() {
		var userAgent=navigator.userAgent.toLowerCase();
		
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			ieprint();
		}
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
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

   <!--초과운행 거리 계산 -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='over_run_day' value='<%=car1.getOver_run_day()%>'>
  
<input type='hidden' name='sh_km' value='<%=car1.getSh_km()%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=650>
    <tr align="center"> 
       <td colspan="2"><font color="#006600">&lt; 
       <% if  (  !gg.equals("m") ) { %>장기대여 <% } %> <%=cls.getCls_st()%> 정산서 &gt;</font></td>
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
          <!-- 매입옵션인 경우  -->
         <%if( cls.getCls_st().equals("매입옵션") ) {%> 
          <tr> 
            <td class='title' width="10%">매입옵션<br>(계약서)</td>
            <td colspan=7>             
              <%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt())%>            
              원&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT포함)</td> 	
          
          </tr>
        <% } %>  
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
              <%=AddUtil.ChangeDate2(cls.getCls_dt()) %>
            </td>
            <td class='title' width="10%">이용기간</td>
             <td colspan=3> 
              <%=cls.getR_mon()%>
              개월 
              <%=cls.getR_day()%>
              일</td>          
          </tr>
		   <tr> 
            <td width='10%' class='title'>주행거리</td>
            <td width="15%"> &nbsp;<%=AddUtil.parseDecimal(cls.getTot_dist())%> km</td>
            <td width='10%' class='title'>
            <%if( cls.getCls_st_r().equals("14") ){%> 약정마일리지(월)<%}else{%> 약정마일리지(년)<%}%>
           
      		</td>
            <td colspan=5> 
              &nbsp;<%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
            
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp; </td>
    </tr>	
        
    <!-- 매입옵션인 경우 매입옵션 관련 사항  -->
   
    <tr id=tr_opt <%if( !cls.getCls_st().equals("매입옵션") ) {%> style='display:none;'<%}%>> 

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
		             <td colspan=6 >&nbsp;<%=AddUtil.parseDecimal(cls.getOpt_amt())%> 원&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT포함)</td> 		           
                  </tr>	
 <% if ( clsm.getSui_d1_amt()     > 0 ) { %>                                                   
		          <tr> 
		 	 	     <td class='title' width="13%" rowspan=3>이전등록비용</td>
		             <td class='title' width="13%">등록세</td>
		             <td width="13%"  align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d1_amt())%> 원 
		             <td class='title' width="13%">채권할인</td>
		             <td width="13%"  align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d2_amt())%> 원 
		             <td class='title' width="13%">취득세</td>
		             <td  align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d3_amt())%> 원 </td>
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">인지대</td>
		             <td width="13%"   align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d4_amt())%> 원
		             <td class='title' width="13%">증지대</td>
		             <td width="13%" align="center"  >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d5_amt())%> 원
		             <td class='title' width="13%">번호판대</td>
		             <td  align="center"  >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d6_amt())%> 원 </td>
		          </tr>  
		          <tr> 
		 	 	     <td class='title' width="13%">보조번호판대</td>
		             <td width="13%"  align="center"  >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d7_amt())%> 원
		             <td class='title' width="13%">등록대행료</td>
		             <td width="13%"  align="center"  >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d8_amt())%> 원
		             <td class='title' width="13%">계</td>
		             <td  align="center" >&nbsp;<%=AddUtil.parseDecimal(clsm.getSui_d_amt())%> 원</td>
		          </tr>  
		<% } %>	          
		       </table>
		      </td>        
         </tr>   
      <%if (clsa.getMt().equals("1") ||  clsa.getMt().equals("2")) {%>  
        <tr>
        	<td>&nbsp;* 매입옵션가 산출식</td>
    	</tr>
    	 <%if (clsa.getMt().equals("2")) {%>  
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= 연장전 매입옵션 - (연장계약 매입옵션 감가액  * 이용일수 / 연장계약일수)</td>
    	   </tr>
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= <%=AddUtil.parseDecimal(clsa.getB_old_opt_amt())%> - {(<%=AddUtil.parseDecimal(clsa.getB_old_opt_amt())%> -<%=AddUtil.parseDecimal(clsa.getOld_opt_amt())%>) * <%=clsa.getCount1()%> / <%=clsa.getCount2()%>}</td>
    	   </tr>
    	
    	 <% } else { %>
    	     <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= 계약시 매입옵션가격 * 현재가치율  + 자동차세,보험료 제외요금의 현재가치 합계</td>
    	   </tr>
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= <%=AddUtil.parseDecimal(clsa.getOld_opt_amt())%> * <%=clsa.getRc_rate()%> + <%=AddUtil.parseDecimal(clsa.getM_r_fee_amt())%></td>
    	   </tr>
    	 <% } %>
        <% } %>
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
                  <td class='title' width='25%' >정산</td>
                  <td class='title' width="10%">과세구분</td>
                  <td class='title' width="35%">비고</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="7">환<br>
                    불<br>
                    금<br>
                    액</td>
                  <td class='title' colspan="2">보증금(A)</td>
                  <td width="25%" align="center" > 
                    <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_a_amt();'>
                    원</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">개<br>
                    시<br>
                    대<br>
                    여<br>
                    료</td>
                  <td width="20%" align="center" >경과기간</td>
                  <td width="25%" align="center"> 
                    <input type='text' size='3' name='ifee_mon' value='<%=cls.getIfee_mon()%>' class='whitenum' maxlength='4' >
                    개월
                    <input type='text' size='3' name='ifee_day' value='<%=cls.getIfee_day()%>' class='whitenum' maxlength='4' >
                    일</td>
                  <td>&nbsp;</td>
                   <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td width="20%" align="center">경과금액</td>
                  <td width="25%" align="center"> 
                    <input type='text' name='ifee_ex_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원</td>
                    <td>&nbsp;</td>
                  <td>=개시대여료×경과기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 개시대여료(B)</td>
                  <td width='25%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원</td>
                   <td>&nbsp;</td>
                  <td>=개시대여료-경과금액</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">선<br>
                    납<br>
                    금</td>
                  <td align='center' width="20%">월공제액 </td>
                  <td width='25%' align="center"> 
                    <input type='text' name='pded_s_amt' value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                  <td>&nbsp;</td>  
                  <td>=선납금÷계약기간</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">선납금 공제총액 </td>
                  <td width='25%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원</td>
                  <td>&nbsp;</td>  
                  <td>=월공제액×실이용기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 선납금(C)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원</td>
                   <td>&nbsp;</td>  
                  <td>=선납금-선납금 공제총액</td>
                </tr>
                 <input type='hidden' name='ex_ip_amt' >
             
                <tr> 
                  <td class='title' align='right' colspan="3">계</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='c_amt' value='' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td>&nbsp;</td>  
                  <td>=(A+B+C)</td>
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
                  <td class="title" width='25%'>정산</td>
                  <td class="title" width='10%'>과세구분</td>
                  <td class="title" width='35%'>비고</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="19" width="5%">미<br>
                    납<br>
                    입<br>
                    금<br>
                    액</td>
                  <td colspan="3" class="title">과태료/범칙금(D)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='fine_amt_1' value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                   <td  align="center">&nbsp;<%if(cls.getFine_amt_1() > 0 ){%>비과세 <% } %></td>
                  <td >&nbsp;* 과태료발생시 사용자변경으로 인해 관할기관에서 따로 청구합니다.</td>
                </tr>
                 <tr> 
                  <td colspan="3" class="title">자기차량손해면책금(E)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='car_ja_amt_1' value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                    원 </td>
                  <td  align="center">&nbsp;<%if(cls.getCar_ja_amt_1() > 0 ){%>비과세 <% } %></td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                   <td class="title" rowspan="4" width="5%"><br>
                    대<br>
                    여<br>
                    료</td>
                  <td align="center" colspan="2">과부족</td>
                  <td align="center" width='25%' >&nbsp; 
                    <input type='text' name='ex_di_amt_1' value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                  원&nbsp; </td>
                    <td >&nbsp;</td> 
                  <td >&nbsp; </td>
                </tr>
                <tr> 
                  <td rowspan="2" align="center" width="10%">미납</td>
                  <td width='10%' align="center">기간</td>
                  <td align="center"> &nbsp; 
                    <input type='text' size='3' name='nfee_mon' value='<%=cls.getNfee_mon()%>' class='whitenum' maxlength='4'>
                    개월 
                    <input type='text' size='3' name='nfee_day' value='<%=cls.getNfee_day()%>' class='whitenum'  maxlength='4'>
                  일</td>
                     <td >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center">금액</td>
                  <td align="center" width='25%' > 
                    <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원</td>
                  <td  align="center">&nbsp;<%if(cls.getNfee_amt_1() !=  0 ){%>과세 <% } %></td>
                  <td > </td>
                </tr>
               
                <tr> 
                  <td class="title" colspan="2">소계(F)</td>
                  <td  align="center">
                    <input type='text' name='dfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
                  원 </td>
                     <td >&nbsp;</td>
                  <td >&nbsp;</td>
                    <input type='hidden' name='d_amt' size='15' class='whitenum' >
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
                  <td align="center" width='25%' > 
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원</td>
                     <td >&nbsp;</td>
                  <td >=선납금+월대여료총액</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">월대여료(환산)</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원</td>
                     <td >&nbsp;</td>
                  <td >=대여료총액÷계약기간</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여대여계약기간</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='rcon_mon' size='3' value='<%=cls.getRcon_mon()%>' class='whitenum' maxlength='4'>
                    개월 
                    <input type='text' name='rcon_day' size='3' value='<%=cls.getRcon_day()%>' class='whitenum' maxlength='4' onBlur='javascript:set_b_amt();'>
                  일</td>
                     <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여기간 대여료 총액</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원&nbsp;</td>
                     <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">위약금 적용요율</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='dft_int' value='<%=cls.getDft_int_1()%>' size='5' class='whitenum' onBlur='javascript:set_b_amt()' maxlength='4'>
                  %</td>
                     <td >&nbsp;</td>
                  <td >=잔여기간 대여료 총액 기준</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">중도해지위약금(G)</td>
                  <td  align="center" width='25%' > 
                    <input type='text' name='dft_amt_1' size='15' class='whitenum' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원&nbsp;</td>
                  <td  align="center" >&nbsp;<%if(cls.getDft_amt_1() > 0 ){ if(cls.getTax_chk0().equals("Y")){%>과세 <%} else {%>비과세 <% } } %> </td>
                  <td align="left"></td>
                </tr>
                         
                <tr> 
                 <td class="title" rowspan="6" width="5%"><br>
                    기<br>
                    타</td> 
                  <td colspan="2" class="title">연체료(H)</td>
                  <td align="center" width=25%> 
                    <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원 </td>
                  <td  align="center">&nbsp;<%if(cls.getDly_amt_1() > 0 ){%>비과세 <% } %></td>
                  <td >&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="2" class="title">차량회수외주비용(I)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='etc_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td  align="center">&nbsp;<%if(cls.getEtc_amt_1() > 0 ){ if (cls.getTax_chk1().equals("Y")){%>과세 <%} else {%>비과세 <% } } %></td>
                  <td align="left"></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">차량회수부대비용(J)</td>
                  <td width='25%' align="center"> 
                    <input type='text' name='etc2_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td  align="center">&nbsp;<%if(cls.getEtc2_amt_1() > 0 ){ if (cls.getTax_chk2().equals("Y")){%>과세 <%} else {%>비과세 <% } } %></td>
                  <td align="left"></td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">잔존차량가격(K)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='etc3_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                   <td  align="center">&nbsp;<%if(cls.getEtc3_amt_1() > 0 ){ %>비과세 <% } %></td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" class="title">기타손해배상금(L)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='etc4_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td align="center">&nbsp;<%if(cls.getEtc4_amt_1() > 0 ){ if (cls.getTax_chk3().equals("Y")){%>과세 <%} else {%>비과세 <% } } %></td>
                  <td align="left"></td>
                </tr>
               <tr> 
                  <td colspan="2" class="title">초과운행대여료(M)</td>
                  <td  width='25%' align="center"> 
                    <input type='text' name='over_amt_1' value='<%=AddUtil.parseDecimal(cls.getOver_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원 </td>
                  <td align="center">&nbsp;<%if(cls.getOver_amt_1() > 0 ){ if(cls.getTax_chk4().equals("Y")){%>과세 <%} else {%>비과세 <% } }%></td>
                  <td align="left"></td>
                </tr>
                
                <tr> 
                  <td colspan="3" class="title">부가세(N)</td>
                  <td align="center" width='25%' > 
                    <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원 </td>
                     <td >&nbsp;</td>
                  <td width='35%' >=(F+M-B-C)×10%</td>     
                </tr>
                <tr> 
                  <td class="title" colspan="4">계</td>
                  <td  align="center"> 
                    <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' size='15' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원 </td>
                     <td >&nbsp;</td>
                  <td width='35%' >=(D+E+F+G+H+I+J+K+L+M+N)</td>
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
 <%if( !cls.getCls_st().equals("매입옵션") ) {%>               
              
    <%if( cct.getJung_st().equals("2")   ) {%>
     		<tr> 
                  <td class='title' width="30%">고객환불금액</td>
                  <td width="25%" align="center"> 
                    <input type='text' readonly   name=h5_amt' value='<%=AddUtil.parseDecimal(cct.getH5_amt())%>'size='15' class='whitenum' maxlength='15'>
                  원 </td>
                  <td ' width="45%"></td>
                </tr>
                	<tr> 
                  <td class='title' width="30%">고객청구금액</td>
                  <td  width="25%" align="center"> 
                    <input type='text' readonly   name='h7_amt' value='<%=AddUtil.parseDecimal(cct.getH7_amt())%>'size='15' class='whitenum' maxlength='15'>
                  원 </td>
                  <td  width="45%"><%if(cls.getCms_chk().equals("Y")){%>( CMS 인출의뢰 )<% } %> </td>
                </tr>
    
    <%} else if( cct.getJung_st().equals("3")   ) {%>
     		<tr> 
                  <td class='title' width="30%"> 카드 취소금액</td>
                  <td width="25%" align="center"> 
                    <input type='text' readonly   name='h5_amt' value='<%=AddUtil.parseDecimal(cct.getH5_amt())%>'size='15' class='whitenum' maxlength='15'>
                  원 </td>
                  <td ' width="45%"></td>
                </tr>
                	<tr> 
                  <td class='title' width="30%"> 카드 재결재금액</td>
                  <td  width="25%" align="center"> 
                    <input type='text' readonly   name='h7_amt' value='<%=AddUtil.parseDecimal(cct.getH7_amt())%>'size='15' class='whitenum' maxlength='15'>
                  원 </td>
                  <td  width="45%">&nbsp;</td>
                </tr>
    
    <% } else { %>                   
                <tr> 
                  <td class='title' width="30%">고객납입금액</td>
                  <td  width="25%" align="center"> 
                    <input type='text' readonly   name='fdft_amt2' value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>'size='15' class='whitenum' maxlength='15'>
                  원 </td>
                  <td  width="45%"> =미납입금액계-환불금액계 <%if(cls.getCms_chk().equals("Y")){%>( CMS 인출의뢰 )<% } %> </td>
                </tr>
       <% } %>             
  <%} %>  <!--  매입옵션이 아닌 경우 -->                            
              
                <tr id=tr_sale <%if( !cls.getCls_st().equals("매입옵션") ) {%> style='display:none;'<%}%>>                  
		    	  <td class='title' width="30%">매입옵션시 고객납입금액</td>
                  <td  width="25%" align="center"> 
                    <input type='text' name='fdft_amt3' value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>'size='15' class='whitenum' maxlength='15'>
                  원 </td>
                  <td width="45%">
     				   <% if ( clsm.getSui_d1_amt()    > 0 ) { %>=매입옵션가+미납입금액계-환불금액계+이전등록비용(발생한 경우)
       			   <% } else {%>=매입옵션가+미납입금액계-환불금액계
                   <% } %>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          
          
           <%  //매입옵션인경우만 
	      if ( cls.getCls_st().equals("매입옵션") ) {
	    //	 System.out.println("status = " + clsm.getStatus());
	    	 if ( !clsm.getStatus().equals("0") ) {  
	    		 maeip_amt =  clsm.getM_dae_amt();
	    		 m_ext_amt =  clsm.getExt_amt();
	    	 }  else { //계산된 값으로 
		    	 if (cls.getFdft_amt2() < 0) {  
			 		   maeip_amt = cls.getFdft_amt2()* (-1);
					 
					   if (maeip_amt > cls.getOpt_amt() ) {
						    maeip_amt = cls.getOpt_amt();						  
					   }  				    	
			     }
	    	 
		    	 if (cls.getFdft_amt3() < 0) {  
		    	    m_ext_amt  = (cls.getFdft_amt3() * (-1)) + maeip_amt + cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2() - cls.getOpt_amt() - clsm.getSui_d_amt() ;	
	    	  //   } else {
	    	  //  	m_ext_amt  = maeip_amt +cls.getOpt_ip_amt2()  + cls.getOpt_ip_amt1() - cls.getOpt_amt() - cls.getSui_d_amt() ;	
	    	     } 	    	  
		    
		     }
		    
		   }   
	   %> 
	   
          <%if( cls.getCls_st().equals("매입옵션") ) {%> 
           <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매입옵션 입금</span></td>
          </tr> 
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                       
		          <tr> 
		                  <td class='title' width="30%">대체입금</td>
		                  <td  width="25%" align="center"> 
		                    <input type='text' name='m_dae_amt'   value='<%=AddUtil.parseDecimal(maeip_amt)%>' size='15' class='whitenum' maxlength='15'>
		                  원 </td>
		                  <td  width="45%"></td>
		                </tr>
		          
		           <tr> 
		                  <td class='title' width="30%">계좌입금</td>
		                  <td  width="25%" align="center"> 
		                   <input type='text' name='i_dae_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getOpt_ip_amt1()+cls.getOpt_ip_amt2())%>'  size='15' class='whitenum' maxlength='15'>
		                  원 </td>
		                  <td  width="45%"> <%if(cls.getExt_st().equals("1")) { %>=고객환불  <%=AddUtil.parseDecimal(m_ext_amt)%> 원 <% } %>  </td>
		                </tr>
               </table>
            </td>
           </tr>    
                      
           <% } %>
          
          <tr>
          
          <%	//이행보증보험
				ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString( fee_size) );%>
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
                    미가입 
                    <%}%>
                  </td>
                  <td  width="25%" align="center"> 
                    <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='whitenum' maxlength='15'>
                    원</td>
                  <td width="45%"></td>
                </tr>
              </table>
            </td>
          </tr>
         </table>
      </td>
    </tr>
    
    <tr> 
      <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>입금계좌</span>&nbsp;&nbsp;&nbsp;* 신한은행 140-004-023871 (주)아마존카</td>
    </tr>
        
    <!-- 중도매입옵션인경우-->
     
  <%if ( clsa.getOld_opt_amt()  >  0  &&   fee_size  ==  1 ) {%>   
  <!-- 마지막 페이지 출력 -->  
 <!-- <p style='page-break-before:always'><br style="height:0; line-height:0"></P> -->
     
    <tr> 
      <td colspan="2" class="a4">&nbsp; </td>
    </tr>    
    <tr>    
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
         <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중도 정산서</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
        </tr> 	 	 	 	
 	 	  <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  rowspan="2"  width='4%'>회차</td>
              <td class="title"  rowspan="2" width='10%'>납입할날짜</td>                
       <!--       <td class="title"  rowspan="2" width='9%'>월대여료<br>(공급가)</td> -->
              <td class="title"  rowspan="2" width='9%'>보증금 이자효과 반영전<br> 월대여료(공급가)</td> 
              <td class="title"  rowspan="2" width='8%'>자동차세</td>               
              <td class="title"  rowspan="2" width='8%'>보험료+<br>정비비용</td>
              <td class="title"  rowspan="2" width='10%'>자동차세,보험료+정비비용 <br> 제외요금<br>(공급가)</td>                
              <td class="title"  width='30%' colspan=3>자동차세,보험료 제외요금의 현재가치</td>             
              <td class="title"  width='20%' colspan=2>현재가치 산출 보조자료<br>(이자율: 년 <%=clsa.getA_f()%>%)</td>             
            </tr>          
            
            <tr> 
              <td class="title"  width='10%' >공급가</td>
              <td class="title"  width='10%'>부가세</td>
              <td class="title"  width='10%'>합계</td>
              <td class="title"  width='8%'>현재<br>가치율</td>
              <td class="title"  width='10%'>기준일대비<br>경과일수</td>
             </tr>  
             <tr> 
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td align="center"> (1) </td>
              <td align="center"> (2) </td>
              <td align="center"> (3) </td>
              <td align="center"> (4) = (1)-(2)-(3)</td>
              <td align="center"> (5) = (4) * (8) </td>
              <td align="center"> (6) = (5) * 0.1</td>
              <td align="center"> (7) = (5) + (6)</td>
              <td align="center"> (8) </td>
              <td align="center"> (9) </td>                          
             </tr>              
                           
<%	
		
	int t_s_grt_amt = 0;       
	int t_s_g_fee_amt = 0;       	
	int t_fee_s_amt = 0;            
	int t_s_cal_amt = 0;
	int t_r_fee_s_amt = 0;
	int t_r_fee_v_amt = 0;
	int t_r_fee_amt = 0;
	int  s_tax_is_amt = 0;
	int  s_g_fee_amt = 0;
	
					
	for(int i = 0 ; i < vt_size8 ; i++){
					Hashtable ht8 = (Hashtable)vts8.elementAt(i); 					
										
					t_s_grt_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_GRT_AMT")));
				
					t_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT")));
					t_s_cal_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_CAL_AMT")));
					t_r_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_S_AMT")));
					t_r_fee_v_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_V_AMT")));
					t_r_fee_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_AMT")));
					
					s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_G_FEE_AMT"))) ;
					if ( s_g_fee_amt < 1) s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT"))) ;			
					t_s_g_fee_amt += s_g_fee_amt;		
										
					s_tax_is_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_TAX_AMT"))) + AddUtil.parseInt(String.valueOf(ht8.get("S_IS_AMT")));
					
%>       
	 		   <tr>
                    <td>&nbsp;<%=ht8.get("S_FEE_TM")%> </td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht8.get("S_R_FEE_EST_DT")))%> </td>
              <!--       <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_FEE_S_AMT")))%></td> -->
                    <td align=right>&nbsp;<%=Util.parseDecimal(s_g_fee_amt)%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_TAX_AMT")))%> </td>   
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_IS_AMT")))%> </td>   
               <!--        <td align=right>&nbsp;<%=Util.parseDecimal(s_tax_is_amt)%> </td> -->             
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_AMT")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_S_AMT")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_V_AMT")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_AMT")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseFloat(String.valueOf(ht8.get("S_RC_RATE")))%></td>
                    <td align=right>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_DAYS")))%></td>
                   
               </tr>
<% } %>
               
               <tr>
                    <td colspan="2" class=title>합계</td>
             <!--       <td class=title><%=Util.parseDecimal(t_fee_s_amt)%></td> -->
                    <td class=title><%=Util.parseDecimal(t_s_g_fee_amt)%></td>
                    <td class=title></td>
                      <td class=title></td>
                    <td class=title><%=Util.parseDecimal(t_s_cal_amt)%></td>
                    <td class=title><%=Util.parseDecimal(t_r_fee_s_amt)%></td>
                    <td class=title><%=Util.parseDecimal(t_r_fee_v_amt)%></td>
                    <td class=title><%=Util.parseDecimal(t_r_fee_amt)%></td>
                    <td class=title></td>
                    <td class=title></td>                   
                  
               </tr>	  
                   
             </table>
            </td>
         </tr>         
    	
     	</table>
      </td>	 
  </tr>	 
   	 	    
  <% } %> 

    <!-- 초과운행부담금이 있는 경우  -->     
  
    <tr> 
      <td colspan="2" class="a4">&nbsp; </td>
    </tr>
    
    <%if ( co.getR_over_amt() >  0  &&  cls_st.equals("월렌트해지")) {%>          
    <tr>           	
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>초과운행 대여료</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	 	 	
 	 	 <tr> 
 	      <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="3"  width='34%'>항목</td>
              <td class="title" width='24%'>내용</td>                
              <td class="title" width='42%'>비고</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="6" >계<br>약<br>사<br>항</td>   
              <td class="title"  rowspan=3>계약내용</td>
              <td class="title" >계약기간</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
              <td align="left" >&nbsp;당초계약기간</td>
             </tr>
              <tr> 
              <td class="title" >약정거리 (가)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;
               <%if( cls.getCls_st_r().equals("14") ){%>월간<%}else{%>년간<%}%>
       
              </td>
             </tr>      
              <tr> 
              <td class="title" > 단가(부담금) (a)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>원</td>
               <td align="left" >&nbsp;=1km</td>
             </tr>           
            <tr> 
              <td class="title"  rowspan=3>정산기준</td>
              <td class="title" >대여기간</td>
              <td align="center">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
              <td align="left" >&nbsp;실제대여기간</td>
             </tr>   
              <tr> 
              <td class="title" >대여일수(나)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(co.getRent_days() )%>' size='7' class='whitenum' > 일 </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title" >약정거리(한도)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7'  value='<%=AddUtil.parseDecimal(co.getCal_dist() )%>' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(가)x(나) / <% if ( cls.getCls_st().equals("월렌트해지") ) {%>30<% } else {%>365 <% } %></td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >운<br>행<br>거<br>리</td>      
               <td class="title"  rowspan=3>운행거리</td>
              <td class="title" >최초주행거리계(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value='<%=AddUtil.parseDecimal(co.getFirst_dist() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;신차(고객 인도시점 주행거리) , 보유차 (계약서에 명시된 주행거리)</td>
             </tr>   
             <tr> 
              <td class="title" >최종주행거리계(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly value='<%=AddUtil.parseDecimal(co.getLast_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title" >실운행거리(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly   value='<%=AddUtil.parseDecimal(co.getReal_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
              <tr> 
              <td class="title"  rowspan=3>정산기준</td>
              <td class="title" >초과운행거리(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly   value='<%=AddUtil.parseDecimal(co.getOver_dist() )%>'   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title" >서비스마일리지</td>
              <td align="right" ><input type='text' name='add_dist' readonly value='<%=AddUtil.parseDecimal(co.getAdd_dist() )%>'      size='7' class='whitenum' > km</td>
                <td align="left" >&nbsp;</td>
             </tr>      
              <tr> 
              <td class="title" >정산기준(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly value='<%=AddUtil.parseDecimal(co.getJung_dist() )%>'      size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>정<br>산</td>
              <td class="title" colspan=2 >산출금액(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getR_over_amt() )%>'     size='10' class='whitenum' >원</td>
              <td align="left" >&nbsp;=(a)x(b)</td>
             </tr>
              <tr> 
              <td class="title"   colspan=2 >감액(i)</td>
              <td align="right"><input type='text' name='m_over_amt'  value='<%=AddUtil.parseDecimal(co.getM_over_amt() )%>'     readonly  size='10'  class='whitenum'> 원</td>
              <td align="left" > </td>
             </tr>      
              <tr> 
              <td class="title"   colspan=2 >정산(납부)금액</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getJ_over_amt() )%>'     size='10' class='whitenum' >원</td>
              <td align="left" >&nbsp;=(h)-(i)</td>
             </tr>  
            </table>
           </td>
         </tr>  
       	</table>
      </td>	 
    </tr>	      
   <% } else if  ( co.getR_over_amt() !=  0  &&  !cls_st.equals("월렌트해지")) {%> 
	     <tr>           	
	 	   <td> 
	    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
	          <tr> 
	 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>환급/초과운행 대여료</span></td>
	 	 	  </tr>
	 	 	  <tr>
	      		 <td class=line2></td>
	   		  </tr>
	 	 	 	 	
	 	 	  <tr> 
	 	      <td colspan="2" class='line'> 
	          <table border="0" cellspacing="1" cellpadding="0" width=100%>
	           <tr> 
	              <td class="title"  colspan="5"  width='34%'>항목</td>
	              <td class="title" width='24%'>내용</td>                
	              <td class="title" width='42%'>비고</td>
	            </tr>
	            <tr> 
	              <td class="title"  rowspan="7" >계<br>약<br>사<br>항</td>   
	              <td class="title"  rowspan=4>기<br>준</td>
	              <td class="title"  colspan=3>계약기간</td>
	              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
	              <td align="left" >&nbsp;당초계약기간</td>
	             </tr>
	             <tr> 
	              <td class="title" rowspan=3>운행<br>거리<br>약정</td>
	              <td class="title"  colspan=2>연간약정거리 (가)</td>
	              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
	              <td align="left" >&nbsp;</td>
	             </tr>  
	             <tr> 
	              <td class="title" rowspan=2>단가<br>(1km) </td>
	              <td class="title" >환급대여료 (a1)</td>
	              <td align="right" ><%=AddUtil.parseDecimal(car1.getRtn_run_amt() )%>원</td>
	              <td align="left" >&nbsp;약정거리 이하운행</td>
	             </tr>            
	             <tr> 
	              <td class="title" >초과운행대여료(a2)</td>
	              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>원</td>
	               <td align="left" >&nbsp;약정거리 초과운행</td>
	            </tr> 
	             <tr> 
	              <td class="title"  rowspan=3>정<br>산</td>
	              <td class="title"  rowspan=2>이용<br>기간</td>  
	              <td class="title"  colspan=2 >실이용기간	</td>     
	              <td align="center">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
	              <td align="left" >&nbsp;실제대여기간</td>
	            </tr>   
	            <tr> 
	              <td class="title"  colspan=2 >실이용일수	(나)</td>
	              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(co.getRent_days() )%>' size='7' class='whitenum' > 일 </td>
	              <td align="left" >&nbsp;</td>
	             </tr>
	             <tr> 
	              <td class="title"  colspan=3 >약정거리(한도)(c)</td>
	              <td align="right" ><input type='text' name='cal_dist' readonly   size='7'  value='<%=AddUtil.parseDecimal(co.getCal_dist() )%>' class='whitenum' > km</td>
	               <td align="left" >&nbsp;=(가)x(나) / 365</td>
	             </tr>
	             <tr> 
	              <td class="title"  rowspan="6" >운<br>행<br>거<br>리</td>      
	              <td class="title"  rowspan=3>기<br>준</td>
	              <td class="title"  colspan=3 >최초주행거리계(d)</td>
	             <td align="right" ><input type='text' name='first_dist' readonly  value='<%=AddUtil.parseDecimal(co.getFirst_dist() )%>'  size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;신차(고객 인도시점 주행거리) , 보유차 (계약서에 명시된 주행거리)</td>
	             </tr>   
	             <tr> 
	              <td class="title"  colspan=3>최종주행거리계(e)</td>
	              <td align="right" ><input type='text' name='last_dist' readonly value='<%=AddUtil.parseDecimal(co.getLast_dist() )%>'    size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;</td>
	             </tr>     
	              <tr> 
	              <td class="title"  colspan=3 >실운행거리(f)</td>
	              <td align="right" ><input type='text' name='real_dist' readonly   value='<%=AddUtil.parseDecimal(co.getReal_dist() )%>'    size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;=(e)-(d) </td>
	             </tr>                          
	             <tr> 
	              <td class="title"  rowspan=3>정<br>산</td>
	              <td class="title"   colspan=3 >정산기준운행거리	(g)</td>
	              <td align="right" ><input type='text' name='over_dist' readonly   value='<%=AddUtil.parseDecimal(co.getOver_dist() )%>'   size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;=(f)-(c) </td>
	             </tr>
	              <tr> 
	              <td class="title"   colspan=3 >기본공제거리</td>
	             <% if (  AddUtil.parseInt(base.getRent_dt()) > 20220414 ) { %>             
	              <td align="right" >&nbsp;±1,000 km</td>
	            <% } else { %>
	              <td align="right" >&nbsp;1,000 km</td>
	            <% }  %>  
	                <td align="left" >&nbsp;<input type='hidden' name='add_dist'  value='<%=AddUtil.parseDecimal(co.getAdd_dist() )%>'   readonly> </td>
	             </tr>      
	             <tr> 
	              <td class="title"  colspan=3 >대여료정산기준운행거리	(b)</td>
	              <td align="right" ><input type='text' name='jung_dist' readonly value='<%=AddUtil.parseDecimal(co.getJung_dist() )%>'      size='7' class='whitenum' > km</td>
	                <% if (  AddUtil.parseInt(base.getRent_dt())  > 20220414 ) { %>  
	              <td align="left" >&nbsp;(g)가 ±1,000km 이내이면 미정산(0km) , (g)가  ±1,000km가 아니면 (g)±기본공제거리 </td>
	                <% } else { %>
	               <td align="left" >&nbsp;</td> 
	                <% }  %>             
	           
	             </tr>  
	             <tr> 
	              <td class="title"  rowspan=3>대<br>여<br>료</td>
	              <td class="title"  rowspan=2>조<br>정</td>
	              <td class="title"  colspan=3 >산출금액(h)</td>
	              <td align="right" ><input type='text' name='r_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getR_over_amt() )%>'     size='10' class='whitenum' >원</td>
	              <td align="left" >&nbsp;(b)가  0km 미만이면 (a1)*(b),<br>&nbsp;(b)가 1km이상이면 (a2)*(b)</td>
	             </tr>
	             <tr> 
	              <td class="title"   colspan=3 >가감액(i)</td>
	              <td align="right"><input type='text' name='m_over_amt'  value='<%=AddUtil.parseDecimal(co.getM_over_amt() )%>'   size='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> 원</td>
	              <td align="left" >&nbsp;</td>
	             </tr>      
	             <tr> 
	              <td class="title"  colspan=4 >정산(부과/환급예정)금액</td>
	              <td align="right" ><input type='text' name='j_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getJ_over_amt() )%>'     size='10' class='whitenum' >원</td>
	              <td align="left" >&nbsp;=(h)-(i), 환급(-)</td>
	             </tr>    
            
	           </table>
	         </td>
	        </tr>  
	   	</table>
      </td>	 
    </tr>	   
  <% } %>                 
    
  </table>      
</form>

<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;		
			
		fm.c_amt.value 			= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value))   + toInt(parseDigit(fm.ex_ip_amt.value)) );
		fm.d_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		fm.dfee_amt.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
	   		
	}
//-->
</script>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
