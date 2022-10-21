<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>자동차대여요금정산서</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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
		factory.printing.topMargin 	= 25.0; //상단여백    
		factory.printing.bottomMargin 	= 20.0; //하단여백	
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:onprint()"><!---->
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<%
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
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
	//선수금정보
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	ScdRentBean sr_bean6 = rs_db.getScdRentCase(s_cd, "6");
	//단기대여정산정보
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
	//용역비용정보
	ScdDrivBean sd_bean1 = rs_db.getScdDrivCase(s_cd, "1");
	ScdDrivBean sd_bean2 = rs_db.getScdDrivCase(s_cd, "2");
	
	//입금처리
	Vector conts = rs_db.getScdRentList(s_cd);
	int cont_size = conts.size();
	
	//미수채권
	Vector conts2 = rs_db.getScdRentNoList(s_cd);
	int cont_size2 = conts2.size();
	
	//연장계약
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
	
	int ext_pay_rent_s_amt = 0;
	int ext_pay_rent_v_amt = 0;
	if(cont_size > 0){
		for(int i = 0 ; i < cont_size ; i++){
    			Hashtable sr = (Hashtable)conts.elementAt(i);
    			if(String.valueOf(sr.get("RENT_ST")).equals("5")){
    				ext_pay_rent_s_amt = ext_pay_rent_s_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    				ext_pay_rent_v_amt = ext_pay_rent_v_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    			}
    		}
    	}		
		
	int no_pay_rent_amt = 0;	
	if(cont_size2 > 0){
		for(int i = 0 ; i < cont_size2 ; i++){
    			Hashtable sr = (Hashtable)conts2.elementAt(i);
    			if(String.valueOf(sr.get("RENT_ST")).equals("5")){
    				ext_pay_rent_s_amt = ext_pay_rent_s_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    				ext_pay_rent_v_amt = ext_pay_rent_v_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    			}    			
			no_pay_rent_amt = no_pay_rent_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
			no_pay_rent_amt = no_pay_rent_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    		}
    	}
    	
    	//종사업장
	Hashtable br = c_db.getBranch(rc_bean.getBrch_id());			
	
    	//담당자들
    	UsersBean user_bean1 	= umd.getUsersBean(rc_bean.getBus_id());
    	UsersBean user_bean2 	= umd.getUsersBean(rc_bean.getMng_id());
	
%>
<form action="res_rent_u_a.jsp" name="form1" method="post" >
  <table border=0 cellspacing=0 cellpadding=0 width=700>
    <tr> 
      <td height="70" width="220"><img src="/images/logo.gif" aligh="absmiddle" border="0" width="128" height="30"> 
      </td>
      <td height="70" width="480" colspan="2"><font size="5"><b>자 동 차 대 여 요 금 
        정 산 서</b></font></td>
    </tr>
    <tr> 
      <td width="220" align="right">&nbsp;</td>
      <td width="120" align="right">&nbsp;</td>
      <td align="right" width="360"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000">
          <tr> 
            <td class=title width='90' align="center">계약번호</td>
            <td width='100' align="center">&nbsp;<%=rc_bean.getRent_s_cd()%></td>
            <td class=title width='80' align="center">영업소</td>
            <td width="100" align="center" >&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
            <td class=title width='80' align="center">영업담당자</td>
            <td width="250" align="left" >&nbsp;<%=user_bean1.getUser_nm()%> <%=user_bean1.getUser_m_tel()%></td>
          </tr>
          <tr> 
            <td class=title width='90' align="center">고객구분</td>
            <td width='100' align="center">&nbsp;<%=rc_bean2.getCust_st()%></td>
            <td class=title width='80' align="center">대여구분</td>
            <td width="100" align="center" >&nbsp;월렌트</td>
            <td class=title width='80' align="center">관리담당자</td>
            <td width="250" align="left" >&nbsp;<%=user_bean2.getUser_nm()%> <%=user_bean2.getUser_m_tel()%><br>&nbsp;사고처리,정비,계약연장,반납 담당</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="4">&nbsp;<b><font size="3">고.객.사.항</font></b></td>
          </tr>
          <%if(rc_bean2.getCust_st().equals("개인")){%>
          <tr> 
            <td class=title2 width='90'>성명</td>
            <td width="260" align="center">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title2 width='90'>생년월일</td>
            <td width="260" align="center">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
          </tr>
          <%}else{%>
          <tr> 
            <td class=title2 width='90'>상호</td>
            <td align="center">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
            <td class=title2>사업자등록번호</td>
            <td align="center">&nbsp;<%=rc_bean2.getEnp_no()%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>성명</td>
            <td width="260" align="center">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title2 width='90'><%if(rc_bean2.getCust_st().equals("법인")){%>법인등록번호<%}else{%>생년월일<%}%></td>
            <td width="260" align="center">&nbsp;<%if(rc_bean2.getCust_st().equals("법인")){%><%=rc_bean2.getSsn()%><%}else%><%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%><%}%></td>
          </tr>
          <%}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="6">&nbsp;<b><font size="3">차.량.사.항</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90">차종</td>
            <td width="180" align="center" >&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
            <td width="80" align="center" >차량번호</td>
            <td width="120" align="center" ><%=reserv.get("CAR_NO")%></td>
            <td class=title2 width="90" >누적주행거리<br>(반차시)</td>
            <td align="center" width="140">&nbsp;<%=rs_bean.getRun_km()%>km</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">배.차 
              / 반.차</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90">배차일시</td>
            <td align="center" colspan="2">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
            <td class=title2 width='130'>반차일시</td>
            <td align="center" width="220">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
          </tr>
          <tr> 
            <td class=title2 rowspan="2">이용기간</td>
            <td class=title2 width="130">&nbsp;당초약정시간</td>
            <td class=title2 width="130">추가이용시간</td>
            <td class=title2 width="130">총이용시간</td>
            <td class=title2>&nbsp;비고</td>
          </tr>
          <tr> 
            <td align="center" height="22">&nbsp;<input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="1" class=whitenum >
                      시간 
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="1" class=whitenum >
                      일 
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="1" class=whitenum >
                      개월 </td></td>
            <td align="center">&nbsp;<input type="text" name="add_hour" value="<%=rs_bean.getAdd_hour()%>" size="1" class=whitenum >
                      시간 
                      <input type="text" name="add_days" value="<%=rs_bean.getAdd_days()%>" size="1" class=whitenum >
                      일 
                      <input type="text" name="add_months" value="<%=rs_bean.getAdd_months()%>" size="1" class=whitenum >
                      개월 </td>
            <td align="center">&nbsp;<input type="text" name="tot_hour" value="<%=rs_bean.getTot_hour()%>" size="1" class=whitenum >
                      시간 
                      <input type="text" name="tot_days" value="<%=rs_bean.getTot_days()%>" size="1" class=whitenum >
                      일 
                      <input type="text" name="tot_months" value="<%=rs_bean.getTot_months()%>" size="1" class=whitenum >
                      개월 </td>
            <td align="center">&nbsp;<%=rs_bean.getEtc()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td class="line" colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">대.여.요.금.정.산</font></b></td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;1. 정상대여료</td>
          </tr>
          <tr> 
            <td class=title2 width="120">대여료총액</td>
            <td class=title2 width="120">배차료</td>
            <td class=title2 width="120">반차료</td>
            <td class=title2 width="120">소계(①)</td>
            <td class=title2 width="220">합계(VAT포함)(ⓐ)</td>
          </tr>
          <tr> 
            <td align="center">￦ 
              <input type="text" name="ag_t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum>
            </td>
            <td align="center">￦ 
              <input type="text" name="ag_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="ag_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum>
            </td>
            <td align="center" >￦ 
              <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt)%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;2. 추가이용 대여료</td>
          </tr>
          <tr> 
            <td class=title2>대여료총액</td>
            <td class=title2>배차료</td>
            <td class=title2>반차료</td>
            <td class=title2>소계(②)</td>
            <td class=title2>합계(VAT포함)(ⓑ)</td>
          </tr>
          <tr> 
            <td align="center">￦ 
              <input type="text" name="add_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">￦ 
              <input type="text" name="add_cons1_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons1_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="add_cons2_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="add_tot_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >￦ 
              <input type="text" name="add_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;3. 정산대여료</td>
          </tr>
          <tr> 
            <td class=title2>대여료총액</td>
            <td class=title2>배차료</td>
            <td class=title2>반차료</td>
            <td class=title2>소계(③)</td>
            <td class=title2>합계(VAT포함)(ⓒ)</td>
          </tr>
          <tr> 
            <td align="center">￦ 
              <input type="text" name="tot_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+ext_pay_rent_s_amt+rs_bean.getAdd_fee_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center">￦ 
              <input type="text" name="tot_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rs_bean.getAdd_cons1_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="tot_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt()+ext_pay_rent_s_amt+rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >￦ 
              <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt+rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt())%>" size="10" class=whitenum>
            </td>
          </tr>          
          <tr> 
            <td height="22" colspan="4">&nbsp;4. 부대비용</td>
            <td height="22">&nbsp;5. 정산금</td>
          </tr>
          <tr> 
            <td class=title2>위약금</td>
            <td class=title2>면책금</td>
            <td class=title2>휴차료</td>
            <td class=title2>소계(④)</td>
            <td class=title2>합계(VAT포함)(ⓑ+④)</td>
          </tr>
          <tr> 
            <td align="center">￦ 
              <input type="text" name="cls_amt" value="<%=AddUtil.parseDecimal(rs_bean.getCls_s_amt()+rs_bean.getCls_v_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">￦ 
              <input type="text" name="ins_m_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="ins_h_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt())%>" size="10" class=whitenum>
            </td>
            <td rowspan="3" align="center"> ￦ 
              <input type="text" name="etc_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getCls_s_amt()+rs_bean.getCls_v_amt()+rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()+rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()+rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt()+rs_bean.getKm_s_amt()+rs_bean.getKm_v_amt()+rs_bean.getFine_s_amt())%>" size="10" class=whitenum>              
            </td>
            <td rowspan="3" align="center" >￦ 
              <input type="text" name="s_rent_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt()+rs_bean.getCls_s_amt()+rs_bean.getCls_v_amt()+rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()+rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()+rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt()+rs_bean.getKm_s_amt()+rs_bean.getKm_v_amt()+rs_bean.getFine_s_amt())%>" size="10" class=whitenum>              
            </td>
          </tr>          
          <tr> 
            <td class=title2>유류비</td>
            <td class=title2>KM초과운행</td>
            <td class=title2>미수과태료</td>
          </tr>
          <tr> 
            <td align="center">￦ 
              <input type="text" name="oil_amt" value="<%=AddUtil.parseDecimal(rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">￦ 
              <input type="text" name="km_amt" value="<%=AddUtil.parseDecimal(rs_bean.getKm_s_amt()+rs_bean.getKm_v_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="fine_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getFine_s_amt())%>" size="10" class=whitenum>
            </td>
          </tr>

        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td colspan="3" height="5"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr> 
            <td height="25" colspan="3" bgcolor="#CCCCCC">&nbsp;<b><font size="3">보.증.금</font></b></td>
            <td height="25" bgcolor="#CCCCCC">&nbsp;<b><font size="3">미.수.채.권</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="120">금액</td>
            <td class=title2 width="120">결제일자</td>
            <td class=title2 width="120">결제방법</td>
            <td class=title2 width="340">금액</td>
          </tr>
          <tr> 
            <td class=title2>￦
            <input type="text" name="grt_amt" value="<%=AddUtil.parseDecimal(sr_bean6.getPay_amt())%>" size="10" class=whitenum></td>
            <td class=title2><%=AddUtil.ChangeDate2(sr_bean6.getPay_dt())%></td>
            <td class=title2>
              <%if(!sr_bean6.getPay_dt().equals("")){%>
                <%if(sr_bean6.getPaid_st().equals("1")){%>
                신용카드  
                <%}else if(sr_bean6.getPaid_st().equals("2")){%>
                현금
                <%}else if(sr_bean6.getPaid_st().equals("3")){%>
                자동이체
                <%}else if(sr_bean6.getPaid_st().equals("3")){%>
                무통장입금
                <%}%>
              <%}%>  
            </td>
            <td class=title2>￦
            <input type="text" name="no_pay_rent_amt" value="<%=AddUtil.parseDecimal(no_pay_rent_amt)%>" size="10" class=whitenum></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="3" height="15" align="right"></td>
    </tr>
    <tr> 
      <td colspan="3"> 
        <table border="1" cellspacing="0" cellpadding="0" width=700 bordercolor="#000000" height="25">
          <tr align="center"> 
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">고객께서 납입하실 금액 : 
              일금 <input type="text" name="rent_sett_amt_text" value="" size="20" class=titlenum>&nbsp;원정&nbsp;(￦<input type="text" name="rent_sett_amt" value="" size="10" class=titlenum>)</font></b>
              <font size="1">(정산금-보증금+미수채권)</font>
              </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="20">&nbsp;</td>
      <td colspan="2" height="20" valign="bottom">&nbsp;</td>
    </tr>
    <tr> 
      <td height="20">&nbsp;</td>
      <td colspan="2" height="20" align="right">&nbsp;<%=AddUtil.ChangeDate2(rs_bean.getSett_dt())%></td>
    </tr>
    <tr> 
      <td class=line height="20">(주)아마존카</td>
      <td class=line colspan="2" height="20">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><font size="1">* 주소 : 서울시 영등포구 여의도동 17-3 / www.amazoncar.co.kr</font></td>
    </tr>
    <tr> 
      <td colspan="3"><font size="1">* TEL : 02-757-0802(영업팀), 02-392-4243(총무팀), 02-392-4242(관리팀), 02-537-5877(강남지점), 051-851-0606(부산지점),<br>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;042-824-1770(대전지점), 053-582-2998(대구지점), 062-385-0133(광주지점)</font></td>
    </tr>
  </table>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
	
	<%if(rent_st.equals("12") && ext_size > 0){
    		for(int i = 0 ; i < ext_size ; i++){
    			Hashtable ext = (Hashtable)exts.elementAt(i);
    			if(AddUtil.parseInt(String.valueOf(ext.get("PAY_AMT"))) > 0){
    	%>	
    				fm.rent_months.value 	= toInt(fm.rent_months.value)	+ <%=ext.get("RENT_MONTHS")%>;
    				fm.rent_days.value 	= toInt(fm.rent_days.value)	+ <%=ext.get("RENT_DAYS")%>;
    	<%		}
    		}
    	  }
    	%>	
    		
	fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_rent_tot_amt.value)) - toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.no_pay_rent_amt.value)));
	
	//금액 : 숫자형식에서 문자형식으로 변환
	var amt = parseDigit(fm.rent_sett_amt.value);

	if(amt.length > 0){
		var str = '';
		for(i=amt.length-1; i>=0; i--){
			if(amt.charAt(i) != 0 && amt.length-i == 1) str = AmtChang(amt.charAt(i))+'';
			if(amt.charAt(i) != 0 && amt.length-i == 2) str = AmtChang(amt.charAt(i))+'십' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 3) str = AmtChang(amt.charAt(i))+'백' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 4) str = AmtChang(amt.charAt(i))+'천' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 5) str = AmtChang(amt.charAt(i))+'만' + str;
			if(amt.charAt(i) == 0 && amt.length-i == 5) str = '만' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 6) str = AmtChang(amt.charAt(i))+'십' + str;
			if(amt.charAt(i) != 0 && amt.length-i == 7) str = AmtChang(amt.charAt(i))+'백' + str;		
			if(amt.charAt(i) != 0 && amt.length-i == 8) str = AmtChang(amt.charAt(i))+'천' + str;				
		}
		fm.rent_sett_amt_text.value = str;
		//fm.rent_sett_amt.value = parseDecimal(amt);
	}
		
	function AmtChang(str){
		if(str == '1')	str = '일';
		if(str == '2')	str = '이';
		if(str == '3')	str = '삼';
		if(str == '4')	str = '사';
		if(str == '5')	str = '오';
		if(str == '6')	str = '육';
		if(str == '7')	str = '칠';
		if(str == '8')	str = '팔';
		if(str == '9')	str = '구';
		return str;
	}
//-->
</script>
</body>
</html>
