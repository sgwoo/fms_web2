<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.res_search.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>



<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	
	
	String rent_s_cd 	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String s_cd 		= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String cmd 		= request.getParameter("cmd")==null?"rent":request.getParameter("cmd");
	
	if(rent_s_cd.equals("") && !s_cd.equals("")){
		rent_s_cd 	= s_cd;
		car_mng_id 	= c_id;
	}

	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(car_mng_id);
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(rent_s_cd, car_mng_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(rent_s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(rent_s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(rent_s_cd, "3");
	RentMgrBean rm_bean4 = rs_db.getRentMgrCase(rent_s_cd, "4");
	//단기대여정보
	RentFeeBean rf_bean = rs_db.getRentFeeCase(rent_s_cd);
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//자동차보험정보
	String ins_com_id = shDb.getCarInsCom(car_mng_id);
	
	//견적정보
	EstimateBean e_bean = new EstimateBean();
	
	e_bean = e_db.getEstimateShCase(rf_bean.getEst_id());
	
	
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>무제 문서</title>
</head>
<style>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	font-family: dotum,'돋움',gulim,'굴림',Helvetica,Apple-Gothic,sans-serif;
	font-size:0.8em;
	text-align:center;
	}
.style1 {
	font-size:2.15em;
	font-weight:bold;
}
.style2 {
	font-size:1.1em;
	font-weight:bold;}
.style3{
	font-size:0.8em;}
.style4{
	font-size:0.9em;}
.style5{
	text-decoration:underline;
	}
.style6{
	font-size:1.1em;}
-->
</style>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body  onLoad="javascript:onprint();"> 
<div id="Layer1" style="position:absolute; left:250px; top:1930px; width:54px; height:41px; z-index:1"><img src="/acar/main_car_hp/images/stamp.png" width="75" height="75"></div>
<div align="center">
<table width="680" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td><div align="center"><span class=style1>자 동 차 대 여 이 용 계 약 서</span></div></td>
	</tr>
	<tr>
		<td height=13></td>
	</tr>
  	<tr>
    		<td>
			<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		      		<tr bgcolor="#FFFFFF" height="21">
			        	<td width="13%" height="21" bgcolor="e8e8e8"><div align="center">계약번호</div></td>
			        	<td width="21%"><div align="left">&nbsp;<%=rent_s_cd%></div></td>
			        	<td width="13%" bgcolor="e8e8e8"><div align="center">영업소</div></td>
			        	<td width="20%"><div align="left">&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(),"BRCH")%></div></td>
			        	<td width="13%" bgcolor="e8e8e8"><div align="center">담당자</div></td>
			        	<td width="20%"><div align="left">&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(),"USER")%></div></td>
		      		</tr>
				<tr bgcolor="#FFFFFF" height="21">
			        	<td bgcolor="e8e8e8" height="21"><div align="center">고객구분</div></td>
			        	<td><div align="left">&nbsp;<%=rc_bean2.getCust_st()%></div></td>
			        	<td bgcolor="e8e8e8"><div align="center">대여구분</div></td>
			        	<td colspan="3"><div align="left">&nbsp;<%if(rent_st.equals("1")){%>
                단기대여 
                <%}else if(rent_st.equals("2")){%>
                정비대차 
                <%}else if(rent_st.equals("3")){%>
                사고대차 
                <%}else if(rent_st.equals("9")){%>
                보험대차 
                <%}else if(rent_st.equals("10")){%>
                지연대차 
                <%}else if(rent_st.equals("4")){%>
                업무대여 
                <%}else if(rent_st.equals("5")){%>
                업무지원 
                <%}else if(rent_st.equals("6")){%>
                차량정비 
                <%}else if(rent_st.equals("7")){%>
                차량점검 
                <%}else if(rent_st.equals("8")){%>
                사고수리 
                <%}else if(rent_st.equals("11")){%>
                장기대기
                <%}else if(rent_st.equals("12")){%>
                월렌트
                <%}%>	
                    				</div>
                    			</td>
				</tr>
    			</table>
    		</td>
    	</tr>
    	<tr>
    		<td height=10></td>
    	</tr>
    	<tr>
    		<td><div align="left"><img src=/images/cardoc_arrow.gif> <span class=style2>고객사항</span></td>
    	</tr>
    	<tr>
    		<td>
      			<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td width="13%" height="21"><div align="center">성명(대표자)</div></td>
		          	<td width="34%" colspan="2"><div align="left">&nbsp;<%=rc_bean2.getCust_nm()%></div></td>
		          	<td width="18%"><div align="center">주민(법인)등록번호</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rc_bean2.getSsn()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">상호</div></td>
		         	 <td colspan="2"><div align="left">&nbsp;<%=rc_bean2.getFirm_nm()%></div></td>
		          	<td><div align="center">사업자등록번호</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rc_bean2.getEnp_no()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">주소</div></td>
		          	<td colspan="5"><div align="left">&nbsp;<%=rc_bean2.getAddr()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">운전면허번호</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rm_bean4.getLic_no()%></div></td>
		         	<td rowspan="2"><div align="center">연락처</div></td>
		          	<td width="9%"><div align="center">전화번호 </div></td>
		          	<td width="26%"><div align="left">&nbsp;<%=rm_bean4.getTel()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">면허종류</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%if(rm_bean4.getLic_st().equals("1")){%>2종보통<%}%>
                        		<%if(rm_bean4.getLic_st().equals("2")){%>1종보통<%}%>
                        		<%if(rm_bean4.getLic_st().equals("3")){%>1종대형<%}%>
                        	</td>
		          	<td><div align="center">휴대폰</div></td>
		          	<td><div align="left">&nbsp;<%=rm_bean4.getEtc()%></div></td>
		        </tr>
		    </table>
		</td>
	</tr>
	<tr><td></td></tr>
	<tr>
		<td>	
			<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td width="85" rowspan="4"><div align="center">추가운전자</div></td>
		          	<td height="21" width="64"><div align="center">성명</div></td>
		         	<td width="162"><div align="left">&nbsp;<%=rm_bean1.getMgr_nm()%></div></td>
		          	<td width="121"><div align="center">주민등록번호</div></td>
		          	<td width="242" colspan="2"><div align="left">&nbsp;<%=rm_bean1.getSsn()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">주소</div></td>
		         	<td colspan="4"><div align="left">&nbsp;<%=rm_bean1.getAddr()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">전화번호</div></td>
		          	<td><div align="left">&nbsp;<%=rm_bean1.getTel()%></div></td>
		          	<td><div align="center">운전면허번호</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=rm_bean1.getLic_no()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center">기타</div></td>
		          	<td colspan="4"><div align="left">&nbsp;<%=rm_bean1.getEtc()%></div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr>
    	<td height=10></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> 대여차량 및 이용기간</span></div></td>
    </tr>
    <tr>
		<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
        		<tr bgcolor="e8e8e8" height="21">
		          	<td  height="21"width="13%" ><div align="center">차명</div></td>
		          	<td colspan="4"><div align="left">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></div></td>
		          	<td width="13%"><div align="center">차량번호</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=reserv.get("CAR_NO")%></div></td>
       		 	</tr>
        		<tr bgcolor="e8e8e8" height="21">
		          	<td height="21"><div align="center">연료종류</div></td>
		          	<td colspan="2"><div align="left">&nbsp;<%=reserv.get("FUEL_KD")%></div></td>
		          	<td width="13%"><div align="center">누적주행거리</div></td>
		          	<td width="20%"><div align="left">&nbsp;<%=AddUtil.parseDecimal(rf_bean.getDist_km())%>km</div></td>
		          	<td><div align="center">추가대여품목</div></td>
		          	<td><div align="left">&nbsp;<%if(rf_bean.getNavi_yn().equals("Y")){%>거치형내비게이션<%}%></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="21">
		          	<td  height="21"rowspan="3"><div align="center">이용기간</div></td>
		          	<td width="9%"><div align="center">기간</div></td>
		          	<td colspan="5"><div align="left">&nbsp;<%=rc_bean.getRent_months()%>개월
		          	<%if(!rc_bean.getRent_days().equals("0")){%><%=rc_bean.getRent_days()%>일<%}%>
		          	</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="21">
		          	<td height="21"><div align="center">날짜</div></td>
		          	<td colspan="5"><div align="left">&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_start_dt_d())%> <!--<%=rc_bean.getRent_start_dt_h()%>시 <%=rc_bean.getRent_start_dt_s()%>분--> ~ <%=AddUtil.ChangeDate2(rc_bean.getRent_end_dt_d())%> <!--<%=rc_bean.getRent_end_dt_h()%>시 <%=rc_bean.getRent_end_dt_s()%>분--></div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="21">
		          	<td height="21" colspan="6"><div align="left">&nbsp;대여요금은 월단위로 산정하며, 1개월 미만을 일자정산하여야 할 경우에는 30일을 1개월로 봅니다.</div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr>
    	<td height=10></td>
    </tr>		
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> 배차/반차 예정사항</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">배/반차시간<br>및 장소</div></td>
		        	<td height="20" width="9%"><div align="center">배차</div></td>
		          	<td><div align="left">&nbsp;<%if(rc_bean.getDeli_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getDeli_plan_dt_d())%> <%=rc_bean.getDeli_plan_dt_h()%>시<%=rc_bean.getDeli_plan_dt_s()%>분<%}else{%><%=AddUtil.ChangeDate2(rc_bean.getDeli_dt_d())%> <%=rc_bean.getDeli_dt_h()%>시<%=rc_bean.getDeli_dt_s()%>분<%}%></div></td>
		          	<td width="9%"><div align="center">반차</div></td>
		        	<td><div align="left">&nbsp;<%if(rc_bean.getRet_dt_d().equals("")){%><%=AddUtil.ChangeDate2(rc_bean.getRet_plan_dt_d())%> <%=rc_bean.getRet_plan_dt_h()%>시<%=rc_bean.getRet_plan_dt_s()%>분<%}else{%><%=AddUtil.ChangeDate2(rc_bean.getRet_dt_d())%> <%=rc_bean.getRet_dt_h()%>시<%=rc_bean.getRet_dt_s()%>분<%}%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20"><div align="center">장소</div></td>
		          	<td><div align="left">&nbsp;<%=rc_bean.getDeli_loc()%></div></td>
		          	<td><div align="center">장소</div></td>
		          	<td><div align="left">&nbsp;<%=rc_bean.getRet_loc()%></div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr>
    	<td height=10></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> 대여요금</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="0" cellspacing="1" bgcolor="#000000">
		        <tr>
		          	<td  width="13%" rowspan="2"  bgcolor="e8e8e8"><div align="center">구분</div></td>
		          	<td colspan="4" bgcolor="e8e8e8" height="26"><div align="center">월대여료</div></td>
		          	<td width="13%" bgcolor="e8e8e8"><div align="center">대여료 총액</div></td>
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">배차료</div></td>
		          	<td width="13%" rowspan="2" bgcolor="e8e8e8"><div align="center">반차료</div></td>
		        </tr>
		        <tr>
		          	<td height="26" width="12%" bgcolor="e8e8e8"><div align="center">차량</div></td>
		          	<td width="12%" bgcolor="e8e8e8"><div align="center">내비게이션</div></td>
		        	<td width="12%" bgcolor="e8e8e8"><div align="center">기타</div></td>
		          	<td width="12%" bgcolor="e8e8e8"><div align="center">합계</div></td>
		          	<td bgcolor="e8e8e8"><div align="center"><%=rc_bean.getRent_months()%>개월
		          	<%if(!rc_bean.getRent_days().equals("0")){%><%=rc_bean.getRent_days()%>일<%}%></div></td>
		        </tr>
		        <tr>
		          	<td height="26" bgcolor="e8e8e8"><div align="center">공급가</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="26" bgcolor="e8e8e8"><div align="center">부가세</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="26" bgcolor="e8e8e8"><div align="center">합계</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()+rf_bean.getInv_v_amt()+rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>&nbsp;</div></td>
		          	<td bgcolor="e8e8e8"><div align="right"><%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>&nbsp;</div></td>
		        </tr>
		        <tr>
		          	<td height="26" bgcolor="e8e8e8" style="border-bottom:1px solid #000000;"><div align="center">결제방법</div></td>
		          	<td colspan="5" bgcolor="e8e8e8" style="border-bottom:1px solid #000000;"><div align="left">&nbsp;<%if(rf_bean.getF_paid_way().equals("1")){%>1개월치씩<%}%> <%if(rf_bean.getF_paid_way().equals("2")){%>대여료 전액 <%}%>
		          	  <%if(rf_bean.getPaid_way().equals("1")){%>선불<%}%><%if(rf_bean.getPaid_way().equals("2")){%>후불<%}%>
		          	  </div></td>
		          	<td colspan="2" bgcolor="e8e8e8" style="border-bottom:1px solid #000000;"><div align="left">&nbsp;배/반차료는 선불입니다</div></td>
		        </tr>
		        <tr>
		        	<td height="26" bgcolor="e8e8e8"><div align="center">최초결제금액</div></td>
		        	<td colspan="7" bgcolor="e8e8e8"><div align="left">&nbsp;<%=AddUtil.parseDecimal(rf_bean.getF_rent_tot_amt())%>원, 
		        	<%if(rf_bean.getF_paid_way().equals("1")){%>첫회차 대여료<%}%>
		        	<%if(rf_bean.getF_paid_way().equals("2")){%>대여료 총액<%}%>
		        	
		        	<%if(rf_bean.getCons1_s_amt()>0){%>+ 배차료<%}%>
		        	<%if(rf_bean.getF_paid_way2().equals("1")){%>+ 반차료<%}%>
		        	 
		        	
		        	</div></td>
		        </tr>
		        <tr>
		        	<td height="44" bgcolor="e8e8e8"><div align="center">비고</div></td>
		        	<td colspan="4" bgcolor="e8e8e8"><div align="left">&nbsp;<%=rf_bean.getFee_etc()%></div></td>
		          	<td bgcolor="e8e8e8"><div align="center">결제수단</div></td>
		          	<td colspan="2" bgcolor="e8e8e8"><div align="left">&nbsp;<%if(rf_bean.getPaid_st().equals("1")){%>현금<%}%>
                            	      <%if(rf_bean.getPaid_st().equals("2")){%>신용카드<%}%>
                            	      <%if(rf_bean.getPaid_st().equals("3")){%>자동이체<%}%>
                            	      <%if(rf_bean.getPaid_st().equals("4")){%>무통장입금<%}%></div></td>
		        </tr>
      		</table>
      	</td>
	</tr>
	<tr><td></td></tr>
	<tr>
		<td>
			<table width="680" border="0" cellpadding="0" cellspacing="1" bgcolor="#000000">
				<tr bgcolor="#FFFFFF">
          			<td width="13%" rowspan=3 bgcolor="e8e8e8"><div align="center">자동이체<br>신청</div></td>
          			<td width="13%" height="38"><div align="center">자동이체<br>결제계좌번호</div></td>
          			<td width="35%" style="line-height:20px;">     			
          			<%if(rf_bean.getCms_bank().equals("")){%>
          			<div align="left">&nbsp;&nbsp;&nbsp;&nbsp;<span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><br>
          			(&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;은행&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;지점&nbsp;&nbsp;)</div>
          			<%}else{%>
          			<div align="center"><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=rf_bean.getCms_acc_no()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><br>
          			(&nbsp;&nbsp;<%=rf_bean.getCms_bank()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;지점&nbsp;&nbsp;)</div>
          			<%}%>
          			</td>
          			<td width="13%"><div align="center">예금주<br>(대여이용자)</div></td>
          			<td width="26%"><div align="right"><%=rf_bean.getCms_dep_nm()%>&nbsp;(인)&nbsp;</div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="38">
        			<td height="42">자동이체<br>대상</td>
        			<td colspan="3"><div align="left"> &nbsp;대여료, 연체이자, 중도해지정산금, 면책금, 과태료, 배차료, 반차료</div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF">
        			<td colspan="4" height="38"><div align="left">&nbsp;&nbsp;본 계약과 관련된 대여료 및 기타 채무를 변제함에 있어, 고객(대여이용자)의 사정으로 결제가<br>
        			&nbsp;&nbsp;지연될 경우 아마존카가 해당금액을 자동이체로 출금</div>
        			</td>
        		</tr>
        	</table>
        </td>
    </tr>
	<tr>
    	<td height=5></td>
    </tr>
    <tr>
    	<td><div align="right">(계약번호 <%=rent_s_cd%> : Page 1/2)&nbsp;</div>
    </tr>
	<tr>
    	<td height=5></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> 보험사항 및 고객책임사항</span>
    	        (
    		<%if(ins_com_id.equals("0007")){%>		삼성화재 사고접수 1588-5114, 
    		<%}else if(ins_com_id.equals("0008")){%>	동부화재 사고접수 1588-0100, 
    		<%}%>
    		긴급출동 마스타자동차관리 1588-6688 
    		)    	
    	    </div>
    	</td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="0" cellspacing="1" bgcolor="#000000">
        		<tr bgcolor="e8e8e8" height="27">
          			<td  height="27"width="10%" ><div align="center"><span class=style4>운전자연령</span></div></td>
          			<td width="12%"><div align="center"><span class=style4>운전자범위</span></div></td>
          			<td colspan="2"><div align="center"><span class=style4>보험가입내역(보상한도)</span></div></td>
          			<td colspan="2"><div align="center"><span class=style4>자기차량손해 사고시</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="38">
          			<td height="38" rowspan="4"><div align="center"><span class=style4>만26세<br>이상</span></div></td>
          			<td rowspan="4" bgcolor="e8e8e8">
          				<table width="100%" border=0 cellspacing=0 cellpadding=0>
          					<tr>
          						<td><div align="left">&nbsp;<span class=style4>(1)계약자</span></td>
          					</tr>
          					<tr>
          						<td height=3></td>
          					</tr>
          					<tr>
          						<td><div align="left">&nbsp;<span class=style4>(2)계약서상<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명시된<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;추가운전자</span></div></td>
          					</tr>
          				</table>
          			<td width="12%" bgcolor="e8e8e8"><div align="center"><span class=style4>대인배상</span></div></td>
          			<td width="15%" bgcolor="e8e8e8"><div align="center"><span class=style4>무한<br>(대인배상Ⅰ,Ⅱ)</span></div></td>
          			<td width="37%" rowspan="4" valign=top>
          				<table width=100% border=0 cellspacing=0 cellpadding=0>
          					<tr>
          						<td height=16></td>
          					</tr>
          					<tr>
          						<td><div align="left">&nbsp; <span class=style4>선택1. 자기차량손해 면책금(사고 건당)<br>
			          			&nbsp;&nbsp;&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(rf_bean.getCar_ja()==300000)%>checked<%%>> 30만원 / <input type="checkbox" name="checkbox" value="checkbox" <%if(!String.valueOf(rf_bean.getCar_ja()).equals("300000"))%>checked<%%>> 기타(<%if(!String.valueOf(rf_bean.getCar_ja()).equals("300000") && rf_bean.getCar_ja()>=100000){%><%=rf_bean.getCar_ja()/10000%><%}else{%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%>)만원</span><br><br>
			      				&nbsp; <span class=style3>(별도의 당사 차량손해면책제도에 의거 보상-좌측의<br> 
			      				&nbsp; 종합보험 가입보험사 약관에 준함. 단,도난사고 발생<br>
			      				&nbsp; 시에는 차량잔존가치[=신차가격×(1-(차령개월수×<br>
			      				&nbsp; 0.01))]의 20% 금액은 고객이 부담함.)</span></div></td>
			      			</tr>
			      		</table>
			      	</tr>
          			<td width="14%" rowspan="4" valign=top>
          				<table width=100% border=0 cellspacing=0 cellpadding=0>
          					<tr>
          						<td height=16></td>
          					</tr>
          					<tr>
          						<td><div align="left">&nbsp; <span class=style4>선택2.<br> &nbsp;&nbsp;수리기간 동안<br>
          							&nbsp; 의 휴차보상료<br>&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(rf_bean.getMy_accid_yn().equals("Y")){%>checked<%}%>> 고객부담<br>&nbsp; <input type="checkbox" name="checkbox" value="checkbox" <%if(rf_bean.getMy_accid_yn().equals("N")){%>checked<%}%>> 면제</span></div></td>
          					</tr>
          				</table>
          			</td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="25">
          			<td height="25"><div align="center"><span class=style4>대물배상</span></div></td>
          			<td><div align="center"><span class=style4>1억원</span></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="36">
          			<td height="36"><div align="center"><span class=style4>자기신체사고</span></div></td>
          			<td><div align="center"><span class=style4>사망/장해 1억원<br>부상 1500만원</span></div></td>
        		</tr>
        		<tr bgcolor="e8e8e8" height="25">
         	 		<td height="25"><div align="center"><span class=style4>무보험차상해</span></div></td>
          			<td><div align="center"><span class=style4>2억원</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="41">
          			<td height="41" colspan="6"><div align="left">&nbsp;&nbsp;<span class=style4>※ 휴차보상 : 고객의 귀책사유에 의한 사고 발생시, 대여차량의 수리기간에 해당하는 대여요금(아마존카 단기렌트 요금표<br> 
          			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;기준)의 50%를 고객이 부담하셔야 합니다. (자동차대여 표준약관 제19조에 의함)</span></div></td>
        		</tr>
      		</table>
      	</td>
	</tr>
	<tr><td></td></tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21" rowspan="3" width="13%"><div align="center">아마존카<br>단기렌트<br>요금</div></td>
		          	<td><div align="center">대여차량</div></td>
		          	<td colspan="4"><div align="center">대여기간별 1일 요금 (부가세 포함)</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20" rowspan="2"><div align="center"><%=rf_bean.getCars()%></div></td>
		          	<td width="12%"><div align="center">1~2일</div></td>
		          	<td width="12%"><div align="center">3~4일</div></td>
		          	<td width="12%"><div align="center">5~6일</div></td>
		          	<td width="12%"><div align="center">7일이상</div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="21">
		          	<td height="21"><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_01d()*1.1)%>원</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_03d()*1.1)%>원</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_05d()*1.1)%>원</div></td>
		          	<td><div align="center"><%=AddUtil.parseDecimal(rf_bean.getAmt_07d()*1.1)%>원</div></td>
		        </tr>
			</table>
		</td>
	</tr>
	<tr>
    	<td height=13></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> 기타계약조건</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
		        <tr bgcolor="#FFFFFF" height="34">
		          	<td height="34" bgcolor="e8e8e8"><div align="center">약정<br>운행거리</div></td>
		          	<td><div align="left">&nbsp;<%if(rent_s_cd.equals("022197")){%>2,000km<%}else{%>5,000km<%}%> / 1개월, 초과시 1km당 <%=AddUtil.parseDecimal(rf_bean.getOver_run_amt())%>원의 추가요금이 부과됩니다.</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="34">
		          	<td height="34" ><div align="center">유류대 정산</div></td>
		          	<td bgcolor="e8e8e8"><div align="left">&nbsp;<span class=style4><b>본 계약은 월렌트(장기계약)의 특성상 유류대 정산을 하지 않습니다.<br>
		      			&nbsp;이용자께서는 이점을 감안하시어 이용하시기 바랍니다.</b></span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="80">
		          	<td height="80" bgcolor="e8e8e8"><div align="center">과태료<br>차량정비<br>사고시</div></td>
		          	<td><div align="left">&nbsp;<span class=style4>1) 차량의 임차기간 중 발생되는 주정차 위반 및 교통법규 위반 과태료와 범칙금 등은 고객이 부담하여야<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;합니다.<br>
		      			&nbsp;2) 차량 이용 중 정비(고장수리, 엔진오일 교환 등)가 필요한 경우 필히 아마존카 관리담당자에게 연락하여야 하며,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			 차량 정비시 아마존카 지정정비업체로 직접 방문해 주셔야 합니다. 정비비는 아마존카에서 지불하며,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 개인비용으로 처리시 비용처리가 안됩니다.<br>
		      			&nbsp;3) 차량 이용 중 사고가 발생했을 경우 필히 아마존카 관리담당자에게 연락하여야 합니다.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="34">
		          	<td height="34" bgcolor="e8e8e8"><div align="center">계약 연장</div></td>
		          	<td><div align="left">&nbsp;<span class=style4>1) 최초계약기간보다 연장하여 이용하고자 할 경우에는 사전에 당사의 승인을 받아야 합니다.<br>
		      			&nbsp;2) 당사의 승인을 받은 후 추가이용기간에 대한 대여료를 선불로 결재하여야 계약연장이 인정됩니다.</span</div></td>
		        </tr>
		        <tr bgcolor="e8e8e8" height="34">
		          	<td height="34"><div align="center">중도해지시</div></td>
		          	<td bgcolor="e8e8e8"><div align="left">&nbsp;<span class=style4>1) 실이용기간이 1개월 이상일 경우 : 잔여기간 대여요금의 10%의 위약금이 부과됩니다.<br>
		      			&nbsp;2) 실이용기간이 1개월 미만일 경우 : 아래 명시된 요금정산 방법을 따릅니다.</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="45">
		          	<td height="45" bgcolor="e8e8e8"><div align="center">기타<br>특이사항</div></td>
		          	<td><div align="left">&nbsp;<%=rc_bean.getEtc()%></div></td>
		        </tr>
      		</table>
		</td>
	</tr>

	<tr>
    	<td height=13></td>
    </tr>
	<tr>
    	<td><div align="left"><span class=style2><img src=/images/cardoc_arrow.gif> 실이용기간이 1개월 미만일 경우의 요금정산</span> <span class=style4>(아래 기준에 의거 이용일 수 만큼의 대여료가 적용됩니다.)
    	&nbsp;&nbsp;<span class=style3>※ 기준:일, %</span></div></td>
    </tr>
	<tr>
		<td>
      		<table width="680" border="0" cellpadding="2" cellspacing="1" bgcolor="#000000">
        		<tr bgcolor="#E8E8E8" height="21">
		          	<td width="107" height="21"><div align="center"><span class=style3>이용일수</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>1</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>2</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>3</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>4</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>5</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>6</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>7</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>8</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>9</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>10</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>11</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>12</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>13</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>14</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>15</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>16</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>17</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>18</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>19</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>20</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>21</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>22</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>23</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>24</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>25</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>26</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>27</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>28</span></div></td>
		          	<td width="18"><div align="center"><span class=style3>29</span></div></td>
		          	<td width="19"><div align="center"><span class=style3>30</span></div></td>
        		</tr>
        		<tr bgcolor="#FFFFFF" height="28">
		          	<td height="28" bgcolor="e8e8e8"><div align="center"><span class=style3>월대여료대비<br>적용율</span></div></td>
		          	<td><div align="center"><span class=style3>31</span></div></td>
		          	<td><div align="center"><span class=style3>37</span></div></td>
		          	<td><div align="center"><span class=style3>42</span></div></td>
		          	<td><div align="center"><span class=style3>46</span></div></td>
		          	<td><div align="center"><span class=style3>50</span></div></td>
		          	<td><div align="center"><span class=style3>53</span></div></td>
		          	<td><div align="center"><span class=style3>56</span></div></td>
		          	<td><div align="center"><span class=style3>59</span></div></td>
		          	<td><div align="center"><span class=style3>62</span></div></td>
		          	<td><div align="center"><span class=style3>64</span></div></td>
		          	<td><div align="center"><span class=style3>66</span></div></td>
		          	<td><div align="center"><span class=style3>69</span></div></td>
		          	<td><div align="center"><span class=style3>71</span></div></td>
		          	<td><div align="center"><span class=style3>73</span></div></td>
		          	<td><div align="center"><span class=style3>75</span></div></td>
		          	<td><div align="center"><span class=style3>77</span></div></td>
		          	<td><div align="center"><span class=style3>79</span></div></td>
		          	<td><div align="center"><span class=style3>81</span></div></td>
		          	<td><div align="center"><span class=style3>83</span></div></td>
		          	<td><div align="center"><span class=style3>84</span></div></td>
		          	<td><div align="center"><span class=style3>86</span></div></td>
		          	<td><div align="center"><span class=style3>88</span></div></td>
		          	<td><div align="center"><span class=style3>89</span></div></td>
		          	<td><div align="center"><span class=style3>91</span></div></td>
		          	<td><div align="center"><span class=style3>93</span></div></td>
		          	<td><div align="center"><span class=style3>94</span></div></td>
		          	<td><div align="center"><span class=style3>96</span></div></td>
		          	<td><div align="center"><span class=style3>97</span></div></td>
		          	<td><div align="center"><span class=style3>99</span></div></td>
		          	<td><div align="center"><span class=style3>100</span></div></td>
        		</tr>
     		</table>
     	</td>
	</tr>
	<tr>
		<td height=13></td>
	</tr>		
	<tr>
		<td>
			<table width="680" border="0" cellpadding="3" cellspacing="1" bgcolor="#000000">
				<tr>
					<td height=24 bgcolor="#FFFFFF" colspan=4><div align="center"><span class=style2>계약일 &nbsp;&nbsp;: &nbsp;&nbsp;<%=rc_bean.getRent_dt().substring(0,4)%>년 &nbsp;&nbsp;<%=rc_bean.getRent_dt().substring(4,6)%>월 &nbsp;&nbsp;<%=rc_bean.getRent_dt().substring(6,8)%>일</span></div></td>
				</tr>
		        <tr bgcolor="#FFFFFF">
		          	<td width="44%" height=155 style="padding-top:8px; padding-bottom:5px;"><div align="left">&nbsp;&nbsp;<span class=style2>대여제공자(임대인)</span><br>&nbsp;&nbsp;<span class=style4>서울시 영등포구 여의도동 17-3 삼환까뮤빌딩 802호</span><br><br><br><br><br><br><br><br>
		      			&nbsp;&nbsp;<span class=style6>(주)아마존카 대표이사 &nbsp;&nbsp;&nbsp;&nbsp;조 &nbsp;&nbsp;성 &nbsp;&nbsp;희 &nbsp;(인)</span></div></td>
		          	<td colspan="3" style="padding-top:8px; padding-bottom:5px;"><div align="left">&nbsp;&nbsp;&nbsp;<span class=style2>대여이용자 (임차인)</span><br>
		      			&nbsp;&nbsp;&nbsp;<span class=style4>본 계약의 내용을 확인하여 계약을 체결하고 계약서 1통을 정히<br>&nbsp;&nbsp;&nbsp;수령함.<br>
		      			&nbsp;&nbsp;&nbsp;위 대여이용자</span><br><br><br><br><br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		      			
		      			(인)</span></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20" rowspan="3"><div align="left">&nbsp;<span class=style3>본 연대보증인은 임차인이 (주)아마존카와 체결한 위 &quot;자동차<br>
		          	&nbsp;대여 계약&quot; 이용에 대하여 그 내용을 숙지하고 임차인과 연대 <br>
		          	&nbsp;하여 동계약상 일체의 채권·채무를 이행할 것을 확약합니다.</span></div></td>
		          	<td width="9%" rowspan="3"><div align="center"><span class=style6>연대<br>보증인</span></div></td>
		          	<td width="13%"><div align="center">주 소 </div></td>
		          	<td width="34%"><div align="left">&nbsp;<%=rm_bean3.getAddr()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20"><div align="center">주민등록번호</div></td>
		          	<td><div align="left">&nbsp;<%=rm_bean3.getSsn()%></div></td>
		        </tr>
		        <tr bgcolor="#FFFFFF" height="20">
		          	<td height="20"><div align="center">성명</div></td>
		          	<td><div align="right"><%=rm_bean3.getMgr_nm()%>(인)</div></td>
		        </tr>
     	 	</table>
		</td>
  	</tr>
  	<tr>
    	<td height=5></td>
    </tr>
    <tr>
    	<td><div align="right">(계약번호 <%=rent_s_cd%> : Page 2/2)&nbsp;</div>
    </tr>
</table>
</div>
</body>
</html>

<script>
function onprint(){

factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 10.0; //좌측여백   
factory.printing.topMargin = 10.0; //상단여백    
factory.printing.rightMargin = 10.0; //우측여백
factory.printing.bottomMargin = 8.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>
