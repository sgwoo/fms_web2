<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>자동차대여요금정산서</title>
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
	//단기대여정산정보
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
	//용역비용정보
	ScdDrivBean sd_bean1 = rs_db.getScdDrivCase(s_cd, "1");
	ScdDrivBean sd_bean2 = rs_db.getScdDrivCase(s_cd, "2");
%>
<form action="res_rent_u_a.jsp" name="form1" method="post" >
  <table border=0 cellspacing=0 cellpadding=0 width=700>
    <tr> 
      <td height="50" width="220"><img src="/images/logo.gif" aligh="absmiddle" border="0" width="128" height="30"> 
      </td>
      <td height="50" width="480" colspan="2"><font size="5"><b>자 동 차 대 여 요 금 
        정 산 서</b></font></td>
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
            <td class=title width='80' align="center">반차담당자</td>
            <td width="150" align="center" >&nbsp;<%=c_db.getNameById(rc_bean.getRet_mng_id(), "USER")%></td>
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
            <td height="25" bgcolor="#CCCCCC" colspan="4">&nbsp;<b><font size="3">고.객.사.항</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>성명</td>
            <td width="260" align="center">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title2 width='90'>생년월일</td>
            <td width="260" align="center">&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
          </tr>
          <tr> 
            <td class=title2 width='90'>상호</td>
            <td align="center">&nbsp;<%=rc_bean2.getFirm_nm()%></td>
            <td class=title2>사업자등록번호</td>
            <td align="center">&nbsp;<%=rc_bean2.getEnp_no()%></td>
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
      <td colspan="3" height="5" align="right"></td>
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
            <td class=title2 width="130">합계</td>
            <td class=title2>&nbsp;비고</td>
          </tr>
          <tr> 
            <td align="center" height="22">&nbsp;<%=rc_bean.getRent_hour()%>시간<%=rc_bean.getRent_days()%>일<%=rc_bean.getRent_months()%>개월</td>
            <td align="center">&nbsp;<%=rs_bean.getAdd_hour()%>시간<%=rs_bean.getAdd_days()%>일<%=rs_bean.getAdd_months()%>개월</td>
            <td align="center">&nbsp;<%=rs_bean.getTot_hour()%>시간<%=rs_bean.getTot_days()%>일<%=rs_bean.getTot_months()%>개월</td>
            <td align="center">&nbsp;<%=rs_bean.getEtc()%></td>
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
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">대.여.요.금.정.산</font></b></td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;1. 정상대여료</td>
          </tr>
          <tr> 
            <td class=title2 width="120">당초대여료</td>
            <td class=title2 width="120">선택보험료</td>
            <td class=title2 width="120">기타비용</td>
            <td class=title2 width="120">소계(①)</td>
            <td class=title2 width="220">합계(VAT포함)(ⓐ)</td>
          </tr>
          <tr> 
            <td align="center">￦ 
              <input type="text" name="ag_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()-rf_bean.getDc_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">￦ 
              <input type="text" name="ag_ins_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="ag_etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >￦ 
              <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;2. 추가이용 대여료</td>
          </tr>
          <tr> 
            <td class=title2>대여료</td>
            <td class=title2>선택보험료</td>
            <td class=title2>기타비용</td>
            <td class=title2>소계(②)</td>
            <td class=title2>합계(VAT포함)(ⓑ)</td>
          </tr>
          <tr> 
            <td align="center">￦ 
              <input type="text" name="add_fee_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">￦ 
              <input type="text" name="add_ins_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_ins_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="add_etc_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="add_tot_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_ins_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >￦ 
              <input type="text" name="add_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getAdd_fee_s_amt()+rs_bean.getAdd_fee_v_amt()+rs_bean.getAdd_ins_s_amt()+rs_bean.getAdd_etc_s_amt()+rs_bean.getAdd_etc_v_amt()+rs_bean.getAdd_cons1_s_amt()+rs_bean.getAdd_cons2_s_amt()+rs_bean.getAdd_cons1_v_amt()+rs_bean.getAdd_cons2_v_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;3. 부대비용</td>
          </tr>
          <tr> 
            <td class=title2>면책금</td>
            <td class=title2>휴차료</td>
            <td class=title2>유류비</td>
            <td class=title2>소계(③)</td>
            <td class=title2>합계(VAT포함)(ⓒ)</td>
          </tr>
          <tr> 
            <td align="center">￦ 
              <input type="text" name="ins_m_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center">￦ 
              <input type="text" name="ins_h_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_h_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="oil_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getOil_s_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="etc_tot_s_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt()+rs_bean.getIns_h_s_amt()+rs_bean.getOil_s_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" >￦ 
              <input type="text" name="etc_tot_amt" value="<%=AddUtil.parseDecimal(rs_bean.getIns_m_s_amt()+rs_bean.getIns_m_v_amt()+rs_bean.getIns_h_s_amt()+rs_bean.getIns_h_v_amt()+rs_bean.getOil_s_amt()+rs_bean.getOil_v_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td colspan="5" height="22">&nbsp;4. 정산대여료</td>
          </tr>
          <tr> 
            <td class=title2>대여료</td>
            <td class=title2>선택보험료</td>
            <td class=title2>기타비용</td>
            <td class=title2>소계(①+②+③)</td>
            <td class=title2>합계(VAT포함)(ⓐ+ⓑ+ⓒ)</td>
          </tr>
          <tr> 
            <td align="center">￦ 
              <input type="text" name="tot_fee_s_amt" value="" size="10" class=whitenum>
            </td>
            <td align="center">￦ 
              <input type="text" name="tot_ins_s_amt" value="" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="tot_etc_s_amt" value="" size="10" class=whitenum>
            </td>
            <td align="center"> ￦ 
              <input type="text" name="rent_tot_s_amt" value="" size="10" class=whitenum>
            </td>
            <td align="center" >￦ 
              <input type="text" name="s_rent_tot_amt" value="" size="10" class=whitenum>
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
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">선.수.금 
              / 보.증.금</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="90">&nbsp;</td>
            <td class=title2 width="120">&nbsp;예약보증금</td>
            <td class=title2 width="120">선수금</td>
            <td class=title2 width='120'>전액</td>
            <td class=title2 width="250">&nbsp;비고</td>
          </tr>
          <tr> 
            <td class=title2 width="90">금액</td>
            <td align="center" width="120">&nbsp;￦ 
              <input type="text" name="pay_amt1" value="<%=AddUtil.parseDecimal(sr_bean1.getPay_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" width="120">￦ 
              <input type="text" name="pay_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getPay_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center" width="120">￦ 
              <input type="text" name="rest_amt2" value="<%=AddUtil.parseDecimal(sr_bean2.getRest_amt())%>" size="10" class=whitenum>
            </td>
            <td rowspan="3" width="248"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="70" height="16">* 예약보증금</td>
                  <td height="16">: 대여료의 10%이상</td>
                </tr>
                <tr> 
                  <td width="70" height="16">* 선수금</td>
                  <td height="16">: 대여료 전액(배차시)</td>
                </tr>
                <tr> 
                  <td colspan="2" height="16">* 용역비용 등은 당사로 입금되지 않습니다.</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class=title2 width="90">결제일자</td>
            <td align="center" height="22" width="120">&nbsp;<%=AddUtil.ChangeDate2(sr_bean1.getPay_dt())%></td>
            <td align="center" width="120">&nbsp;<%=AddUtil.ChangeDate2(sr_bean1.getPay_dt())%></td>
            <td align="center" width="120">-</td>
          </tr>
          <tr> 
            <td class=title2 width="90">결제방법</td>
            <td align="center" height="22" width="120">&nbsp;
			<%if(sr_bean1.getPaid_st().equals("1")){%>신용카드<%}%>
			<%if(sr_bean1.getPaid_st().equals("2")){%>현금<%}%>
			<%if(sr_bean1.getPaid_st().equals("3")){%>자동이체<%}%>						
			</td>
            <td align="center" width="120">&nbsp;
			<%if(sr_bean2.getPaid_st().equals("1")){%>신용카드<%}%>
			<%if(sr_bean2.getPaid_st().equals("2")){%>현금<%}%>
			<%if(sr_bean2.getPaid_st().equals("3")){%>자동이체<%}%>									
			</td>
            <td align="center" width="120">-</td>
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
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">용.역.비.용(운전기사)</font></b></td>
          </tr>
          <tr> 
            <td class=title2 width="210" >결재방법</td>
            <td class=title2 width="90">&nbsp;</td>
            <td class=title2 width="120">입금</td>
            <td width="120" class=title2>OT/기타</td>
            <td class=title2 width="160" >합계&nbsp; </td>
          </tr>
          <tr> 
            <td class=title2 rowspan="3" > 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td height="16"> 
                    <input type="radio" name="driv_serv_st" value="radiobutton" <%if(rs_bean.getDriv_serv_st().equals("1"))%>chechked<%%>>
                    소속용역회사와 별도 정산</td>
                </tr>
                <tr> 
                  <td height="16"> 
                    <input type="radio" name="driv_serv_st" value="radiobutton" <%if(rs_bean.getDriv_serv_st().equals("2"))%>chechked<%%>>
                    대여료 정산시 합산</td>
                </tr>
                <tr> 
                  <td height="16">&nbsp; </td>
                </tr>
              </table>
            </td>
            <td class=title2 width="150">금액</td>
            <td align="center" >￦ 
              <input type="text" name="d_pay_amt1" value="<%=AddUtil.parseDecimal(sd_bean1.getPay_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">￦ 
              <input type="text" name="d_pay_amt2" value="<%=AddUtil.parseDecimal(sd_bean2.getPay_amt())%>" size="10" class=whitenum>
            </td>
            <td align="center">￦ 
              <input type="text" name="d_pay_tot_amt" value="<%=AddUtil.parseDecimal(sd_bean1.getPay_amt()+sd_bean2.getPay_amt())%>" size="10" class=whitenum>
            </td>
          </tr>
          <tr> 
            <td class=title2 width="150">결제일자</td>
            <td align="center">&nbsp;<%=AddUtil.ChangeDate2(sd_bean1.getPay_dt())%></td>
            <td align="center">&nbsp;<%=AddUtil.ChangeDate2(sd_bean2.getPay_dt())%></td>
            <td align="center">-</td>
          </tr>
          <tr> 
            <td class=title2 width="150">결제수단</td>
            <td align="center">&nbsp;
			<%if(sd_bean1.getPaid_st().equals("1")){%>신용카드<%}%>
			<%if(sd_bean1.getPaid_st().equals("2")){%>현금<%}%>
			<%if(sd_bean1.getPaid_st().equals("3")){%>자동이체<%}%>						
			</td>
            <td align="center">&nbsp;
			<%if(sd_bean2.getPaid_st().equals("1")){%>신용카드<%}%>
			<%if(sd_bean2.getPaid_st().equals("2")){%>현금<%}%>
			<%if(sd_bean2.getPaid_st().equals("3")){%>자동이체<%}%>									
			</td>
            <td align="center">-</td>
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
            <td height="25" bgcolor="#CCCCCC" colspan="5">&nbsp;<b><font size="3">총 
              정산금 : 일금 <input type="text" name="rent_sett_amt_text" value="" size="35" class=titlenum>&nbsp;원정&nbsp;(￦<input type="text" name="rent_sett_amt" value="" size="10" class=titlenum>)</font></b></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td height="20">&nbsp;</td>
      <td colspan="2" height="20" valign="bottom">&nbsp;</td>
    </tr>
    <tr> 
      <td height="15">&nbsp;</td>
      <td colspan="2" height="15" valign="bottom">상기 금액을 정히 수령 함.</td>
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
      <td colspan="3"><font size="1">* 주소 : 서울시 영등포구 여의도동 17-3 / TEL.02-757-0802(영업팀), 
        02-392-4243(총무팀), 02-392-4242(관리팀), www.amazoncar.co.kr</font></td>
    </tr>
  </table>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;
	fm.tot_fee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_s_amt.value)));
	fm.tot_ins_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)));
	fm.tot_etc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
	fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) + toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
	fm.s_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) + toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));
	fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value)) - toInt(parseDigit(fm.pay_amt2.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
	
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
		fm.rent_sett_amt.value = parseDecimal(amt);
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
