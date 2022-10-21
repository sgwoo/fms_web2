<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>자동차대여이용계약서</title>
<link rel="stylesheet" type="text/css" href="../../include/print.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 8.0; //좌측여백   
		factory.printing.rightMargin 	= 8.0; //우측여백
		factory.printing.topMargin 	= 8.0; //상단여백    
		factory.printing.bottomMargin 	= 8.0; //하단여백	
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}
	
	//금액 셋팅	
	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		if(obj==fm.fee_s_amt){
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_v_amt){
			fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_amt){
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));		
		}else if(obj==fm.dc_s_amt){
			fm.dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) * 0.1) ;
			fm.dc_amt.value = parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));
		}else if(obj==fm.dc_v_amt){
			fm.dc_s_amt.value = parseDecimal(toInt(parseDigit(fm.dc_v_amt.value)) / 0.1) ;
			fm.dc_amt.value = parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));
		}else if(obj==fm.dc_amt){
			fm.dc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.dc_amt.value))));
			fm.dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)));		
		}else if(obj==fm.etc_s_amt){
			fm.etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) * 0.1) ;
			fm.etc_amt.value = parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));
		}else if(obj==fm.etc_v_amt){
			fm.etc_s_amt.value = parseDecimal(toInt(parseDigit(fm.etc_v_amt.value)) / 0.1) ;
			fm.etc_amt.value = parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));
		}else if(obj==fm.etc_amt){
			fm.etc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.etc_amt.value))));
			fm.etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.etc_amt.value)) - toInt(parseDigit(fm.etc_s_amt.value)));		
		}
		fm.rent_tot_amt2.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.dc_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) );
		
	}			
	
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:onprint()">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	//단기대여정보
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//사고정보
	Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());
	
	if(rf_bean.getEtc_s_amt() == 0 && rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt()+rf_bean.getNavi_s_amt() >0){
		rf_bean.setEtc_s_amt(rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt()+rf_bean.getNavi_s_amt());
		rf_bean.setEtc_v_amt(rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt()+rf_bean.getNavi_v_amt());
	}	
	
%>
<form action="res_rent_u_a.jsp" name="form1" method="post" >
  <table border=0 cellspacing=0 cellpadding=0 width=700>
    <tr> 
      <td height="50" width="220"><img src="/images/logo.gif" aligh="absmiddle" border="0" width="128" height="30">
      </td>
      <td height="50" width="480" colspan="2"><font size="5"><b>자 동 차 대 여 이 용 
        계 약 서</b></font></td>
    </tr>
    <tr> 
      <td width="220" align="right">&nbsp;</td>
      <td width="120" align="right">&nbsp;</td>
      <td align="right" width="360">TEL.02-757-0802</td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000">
          <tr> 
            <td class=title width='90' align="center">계약번호</td>
            <td width='150' align="center">&nbsp;<%=rc_bean.getRent_s_cd()%></td>
            <td class=title width='80' align="center">영업소</td>
            <td width="150" align="center" >&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
            <td class=title width='80' align="center">담당자</td>
            <td width="150" align="center" >&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="2" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000">
          <tr> 
            <td class=title width='90' align="center">고객구분</td>
            <td width='260' align="center">&nbsp;<%=rc_bean2.getCust_st()%></td>
            <td class=title width='90' align="center">대여구분</td>
            <td width="260" align="center" >&nbsp; 
              <%if(rc_bean.getRent_st().equals("1")){%>
              단기대여 
              <%}else if(rc_bean.getRent_st().equals("2")){%>
              정비대차 
              <%}else if(rc_bean.getRent_st().equals("3")){%>
              사고대차 
              <%}else if(rc_bean.getRent_st().equals("9")){%>
              보험대차 			  
              <%}else if(rc_bean.getRent_st().equals("10")){%>
              지연대차 			  
              <%}else if(rc_bean.getRent_st().equals("4")){%>
              대여 
              <%}else if(rc_bean.getRent_st().equals("5")){%>
              업무지원 
              <%}else if(rc_bean.getRent_st().equals("6")){%>
              차량정비 
              <%}else if(rc_bean.getRent_st().equals("7")){%>
              차량점검 
              <%}else if(rc_bean.getRent_st().equals("8")){%>
              사고수리 
              <%}else if(rc_bean.getRent_st().equals("12")){%>
              월렌트
              <%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">고.객.사.항</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>성명</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title2 width='90'>생년월일</td>
            <td colspan="2" align="center">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>상호</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
            <td class=title2>사업자등록번호</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getEnp_no()%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>주소</td>
            <td colspan="5">&nbsp;<%=rc_bean2.getZip()%>&nbsp;&nbsp;<%=rc_bean2.getAddr()%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>운전면허번호</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getLic_no()%></td>
            <td class=title2 rowspan="2">연락처</td>
            <td class=title2 width='60'>전화번호</td>
            <td width='200' align="center">&nbsp;<%=rc_bean2.getTel()%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>면허종류</td>
            <td colspan="2" align="center">&nbsp;<%=rc_bean2.getLic_st()%></td>
            <td class=title2>휴대폰</td>
            <td align="center">&nbsp;<%=rc_bean2.getM_tel()%></td>
          </tr>
          <tr> 
            <td colspan="6" height="5"></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="3"><%if(rent_st.equals("12")){%>추가운전자<%}else{%>실운전자<%}%></td>
            <td class=title2 width="60">성명</td>
            <td width="200" align="center">&nbsp;<%=rm_bean1.getMgr_nm()%></td>
            <td class=title2 >생년월일</td>
            <td colspan="2" align="center">&nbsp;<%=AddUtil.ChangeEnpH(rm_bean1.getSsn())%></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="2">주소</td>
            <td>&nbsp;<%=rm_bean1.getZip()%>&nbsp;&nbsp;<%=rm_bean1.getAddr()%></td>
            <td class=title2 >운전면허번호</td>
            <td colspan="2" align="center">&nbsp;<%=rm_bean1.getLic_no()%></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td class=title2 >전화번호</td>
            <td colspan="2" align="center">&nbsp;<%=rm_bean1.getTel()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="3">&nbsp;<b><font size="3">대.여.계.약.사.항</font></b></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="2">이용기간</td>
            <td class=title2 width="60" >기간</td>
            <td align="center">&nbsp;<%=rc_bean.getRent_hour()%>시간 (Hours) <%=rc_bean.getRent_days()%>일(Days) 
              <%=rc_bean.getRent_months()%>개월(Months)</td>
          </tr>
          <tr> 
            <td class=title2 >날짜</td>
            <td align="center">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%> 
              ~ &nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%> </td>
          </tr>
          <tr> 
            <td class=title2 width='90'>기타 특이사항</td>
            <td colspan="2">&nbsp;<%=rc_bean.getEtc()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">차.량.사.항</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90">차명</td>
            <td colspan="3" align="center" >&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
            <td class=title2 width="90" >차종</td>
            <td align="center" width="150">&nbsp;<%=reserv.get("CAR_NM")%></td>
          </tr>
          <tr> 
            <td class=title2 >차량번호</td>
            <td align="center" width="150">&nbsp;<%=reserv.get("CAR_NO")%></td>
            <td class=title2 width="80">연료종류</td>
            <td width="140" align="center">&nbsp;<%=reserv.get("FUEL_KD")%></td>
            <td class=title2 >누적주행거리</td>
            <td align="center">&nbsp;<%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">대.여.요.금</font></b></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="4" width="90">대여요금</td>
            <td align="center" width="60" >&nbsp;</td>
            <td align="center" width="139" >정상대여료</td>
            <td class=title width="137">D/C</td>
            <td class=title width="137">선택보험료</td>
            <td class=title width="137">배/반차(기타)료</td>
          </tr>
          <tr> 
            <td class=title2>공급가</td>
            <td align="center"> ￦ 
              <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > ￦ 
              <input type="text" name="dc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title >-</td>
            <td class=title > ￦ 
              <input type="text" name="etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
          </tr>
          <tr> 
            <td class=title2>부가세</td>
            <td align="center"> ￦ 
              <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > ￦ 
              <input type="text" name="dc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_v_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title >-</td>
            <td class=title > ￦ 
              <input type="text" name="etc_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
          </tr>
          <tr> 
            <td class=title2>합계</td>
            <td align="center"> ￦ 
              <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > ￦ 
              <input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getDc_s_amt()+rf_bean.getDc_v_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > ￦ 
              <input type="text" name="ins_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td class=title > ￦ 
              <input type="text" name="etc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>" size="10" class=titlenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
          </tr>
          <tr> 
            <td colspan="2" align="center" ><b><font size="3">총결제금액</font></b></td>
            <td colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;￦ 
              <input type="text" name="rent_tot_amt2" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
          </tr>
          <tr> 
            <td class=title2 >결제방법</td>
            <td colspan="2">&nbsp; 
              <%if(rf_bean.getPaid_way().equals("1")){%>
              선불 
              <%}%>
              <%if(rf_bean.getPaid_way().equals("2")){%>
              후불 
              <%}%>
            </td>
            <td class=title2>결제수단</td>
            <td colspan="2">&nbsp; 
              <%if(rf_bean.getPaid_st().equals("1")){%>
              신용카드 &nbsp; (카드No.:<%=rf_bean.getCard_no()%> ) 
              <%}%>
              <%if(rf_bean.getPaid_st().equals("2")){%>
              현금 
              <%}%>
              <%if(rf_bean.getPaid_st().equals("2")){%>
              자동이체 
              <%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td colspan="3" height="5"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">배.차 
              / 반.차</font></b></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="2" width="90">배/반차시간<br>
              및 장소</td>
            <td class=title2 width='60'>배차</td>
            <td width="245" align="center">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
            <td class=title2 width='60'>반차</td>
            <td align="center" width="245">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_plan_dt())%></td>
          </tr>
          <tr> 
            <td class=title2>장소</td>
            <td align="center">&nbsp;<%=rc_bean.getDeli_loc()%></td>
            <td class=title2>장소</td>
            <td align="center">&nbsp;<%=rc_bean.getRet_loc()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td colspan="3" height="5"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">보.험.사.고.대.차</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90" >정비공장명</td>
            <td align="center" width="150">&nbsp;<%if(accid.get("OFF_NM") != null){%><%=accid.get("OFF_NM")%><%}%></td>
            <td class=title2 width="90">피해차량번호</td>
            <td width="150" align="center">&nbsp;<%if(accid.get("CAR_NO") != null){%><%=accid.get("CAR_NO")%><%}%></td>
            <td class=title2 width="60" >차종</td>
            <td align="center" width="160">&nbsp;<%if(accid.get("CAR_NM") != null){%><%=accid.get("CAR_NM")%><%}%></td>
          </tr>
          <tr> 
            <td class=title2 >접수번호</td>
            <td align="center" width="150">&nbsp;<%if(accid.get("P_NUM") != null){%><%=accid.get("P_NUM")%><%}%></td>
            <td class=title2 >가해자보험사</td>
            <td align="center">&nbsp;<%if(accid.get("G_INS") != null){%><%=accid.get("G_INS")%><%}%></td>
            <td class=title2 >담당자</td>
            <td align="center">&nbsp;<%if(accid.get("G_INS_NM") != null){%><%=accid.get("G_INS_NM")%><%}%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="5" align="right"></td>
    </tr>
    <tr> 
      <td colspan="2"> 
        <table border="1" cellspacing="0" cellpadding="0" width=335 bordercolor="#000000">
          <tr> 
            <td height="25" bgcolor="#CCCCCC">&nbsp;<b><font size="2">보험사항 및 고객책임사항</font></b></td>
          </tr>
          <tr> 
            <td> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="82" height="16">* 운전자연령</td>
                  <td height="16">: 만 26세 이상</td>
                </tr>
                <tr> 
                  <td width="82" height="16">* 운전자범위</td>
                  <td height="16">: 계약자, 계약자의 직원/가족, 계약자가</td>
                </tr>
                <tr> 
                  <td width="82" height="16">&nbsp;</td>
                  <td height="16">&nbsp;&nbsp;지정한 자</td>
                </tr>
                <tr> 
                  <td width="82" height="16">* 가입내역</td>
                  <td height="16">: 대인배상(Ⅰ,Ⅱ)무한,대물배상(3천만원한도)</td>
                </tr>
                <tr> 
                  <td width="82" height="16">&nbsp;</td>
                  <td height="16">&nbsp;&nbsp;자기신체사고보상(개인당 3천만원 한도)</td>
                </tr>
                <tr> 
                  <td width="82" height="16">* 고객책임사항</td>
                  <td height="16">: 도로교통법 위반에 따른 범칙금</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
      <td width='360'> 
        <table border="1" cellspacing="0" cellpadding="0" width=360 bordercolor="#000000">
          <tr> 
            <td height="25" bgcolor="#CCCCCC">&nbsp;<b><font size="2">선택보험</font></b></td>
          </tr>
          <tr> 
            <td> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="65" height="16">* 보상대상</td>
                  <td height="16">: 자기차량손해보상</td>
                </tr>
                <tr> 
                  <td width="65" height="16">* 보상범위</td>
                  <td height="16">: 운전자의 과실여부에 관계없이 대여차량의 파손보상</td>
                </tr>
                <tr> 
                  <td width="65" height="16">&nbsp;</td>
                  <td height="16">&nbsp;&nbsp;(망실제외)</td>
                </tr>
                <tr> 
                  <td colspan="2" height="16">* 수리기간 동안의 휴차보상료는 제외(표준대여료의 70%)</td>
                </tr>
                <tr> 
                  <td height="16">* 면책금 </td>
                  <td height="16">: 30만원(수입차 50만원)</td>
                </tr>
                <tr> 
                  <td height="16"><b>* 가입유무</b> </td>
                  <td height="16"><b><font size="3">: 
                    <%if(rf_bean.getIns_yn().equals("Y")){%>
                    가입 
                    <%}else{%>
                    미가입 
                    <%}%>
                    &nbsp;</font></b> </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="30">&nbsp;</td>
      <td colspan="2" height="30" align="right">계약일자 : <%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
    </tr>
    <tr> 
      <td class=line height="10">&nbsp; </td>
      <td class=line height="10">&nbsp;</td>
      <td class=line height="10">&nbsp;</td>
    </tr>
    <tr> 
      <td class=line>대여제공자(임대인)</td>
      <td class=line colspan="2">대여이용자(임차인)</td>
    </tr>
    <tr> 
      <td>서울시 영등포구 여의도동 17-3</td>
      <td colspan="2">본 계약 내용을 확인하여 계약 체결하고 계약서 1통을 정희 수령 함.</td>
    </tr>
    <tr> 
      <td class=line colspan="3">&nbsp; </td>
    </tr>
    <tr> 
      <td class=line>(주)아마존카 대표이사 조성희 (인)</td>
      <td class=line>위 대여이용자</td>
      <td class=line align="right">(인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>
