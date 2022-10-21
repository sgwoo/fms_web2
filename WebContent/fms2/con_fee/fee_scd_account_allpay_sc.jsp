<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.car_mst.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String t_wd1 	= request.getParameter("t_wd1")==null?"":request.getParameter("t_wd1");
	String t_wd2 	= request.getParameter("t_wd2")==null?"":request.getParameter("t_wd2");
	String t_wd3 	= request.getParameter("t_wd3")==null?"":request.getParameter("t_wd3");
	String t_wd4 	= request.getParameter("t_wd4")==null?"":request.getParameter("t_wd4");
	
	String print_yn 	= request.getParameter("print_yn")==null?"":request.getParameter("print_yn");

	int total_amt1 = 0;
	int total_amt2 = 0;
	int total_amt3 = 0;
	int total_amt4 = 0;
	
	int s_s = 0;
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<style type-"text/css>
<!--	
input.whitetext13b		{ text-align:left; font-size : 13pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#303030;  font-weight:bold;}
input.whitenumber13b	{ text-align:right; font-size : 13pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#303030;  font-weight:bold;}
//-->
</style>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' target='' method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<%if(t_wd1.equals("")||t_wd2.equals("")||t_wd3.equals("")||t_wd4.equals("")){%>
	<input type='hidden' name='t_amt' value='0'>
	<tr>
	    <td align="center"> * 조건을 선택하시고 검색하십시오.</td>
	</tr>		
	<%}else{
		
		//건별 대여료 스케줄 통계
		Hashtable fee_stat = af_db.getFeeScdStatPrint2(m_id, l_cd);
		
		s_s = AddUtil.parseInt(String.valueOf(fee_stat.get("DT")))-AddUtil.parseInt(String.valueOf(fee_stat.get("DT2")));
				
		//대여료 스케줄
		Vector fee_scd = af_db.getFeeScdPrint2(l_cd, "", false);
		int fee_scd_size = fee_scd.size();	
		
		int dly_scd_yn = 0;
		
		FeeScdBean s_fee_scd = new FeeScdBean();
		for(int i = 0 ; i < fee_scd_size ; i++){
			FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
			if(AddUtil.parseInt(t_wd1)<=AddUtil.parseInt(a_fee.getFee_tm()) && AddUtil.parseInt(t_wd2)>=AddUtil.parseInt(a_fee.getFee_tm()) && a_fee.getRc_yn().equals("0")){ //미입금
				if(a_fee.getFee_tm().equals(t_wd1)){
					s_fee_scd = a_fee;
				}
				if(AddUtil.parseInt(AddUtil.replace(t_wd4,"-",""))>=AddUtil.parseInt(AddUtil.replace(a_fee.getR_fee_est_dt(),"-","")) || !a_fee.getDly_days().equals("0")){
					dly_scd_yn++;
					if(!a_fee.getDly_days().equals("0") && a_fee.getDly_fee() >0){
						s_s = s_s-a_fee.getDly_fee();
					}
				}
			}
		}
		
		//기본정보
		Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
		
		//최초대여정보
		ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, s_fee_scd.getRent_st());
		
		//마지막대여정보
		ContFeeBean max_fee = a_db.getContFeeNew(m_id, l_cd, s_fee_scd.getRent_st());
		
		//자동차회사&차종&자동차명
		AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
		CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
		

		
	%>
	<tr>
	  <td colspan='2'><img src="/acar/images/logo_1.png" style="margin-left: 30px;"></td>
	</tr>
	<tr> 
  	<td colspan='2' style="font-size : 15pt;" align='center'><span class=style2>대여료 일시납 계산</span></td>	
	</tr>
	<tr>
	  <td colspan='2' align="center">&nbsp;</td>
	</tr>
	<tr>
	  <td colspan='2' class=line2></td>
	</tr>
  <tr> 
    <td colspan='2' class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='10%' class='title' >계약번호</td>
                                <td width='15%'>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                                <td width='10%' class='title' >상호</td>
                                <td colspan='3'>&nbsp;<%=fee.get("FIRM_NM")%></td>
                                <td width='10%' class='title' >고객명</td>
                                <td width='15%'>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                            </tr>
                            <tr> 
                                <td class='title' >차량번호</td>
                                <td>&nbsp;<%=fee.get("CAR_NO")%></td>
                                <td class='title' >차명</td>
                                <td colspan='3'>&nbsp;<%=mst.getCar_nm()+" "+mst.getCar_name()%></td>
                                <td class='title' >대여방식</td>
                                <td> 
                                <%if(max_fee.getRent_way().equals("1")){%>
                                &nbsp;일반식 
                                <%}else if(max_fee.getRent_way().equals("2")){%>
                                &nbsp;맞춤식 
                                <%}else{%>
                                &nbsp;기본식 
                                <%}%>
                                </td>
                            </tr>
                            <tr> 
                                <td class='title' >채권유형</td>
                                <td>&nbsp;<%=fee.get("GI_ST")%></td>
                                <td class='title' > 대여기간 </td>
                                <td>&nbsp;<%=f_fee.getCon_mon()%>개월</td>
                                <td width='10%' class='title' > 개시일 </td>
                                <td width='15%'>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                                <td class='title' > 만료일 </td>
                                <td>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_end_dt())%></td>
                            </tr>                            	
                            <tr> 
                                <td class='title' > 선납금 </td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getPp_s_amt()+f_fee.getPp_v_amt())%>원
                                	<%if(f_fee.getPp_chk().equals("0")){%><br>&nbsp;매월균등발행<%}%>
                                </td>
                                <td class='title' > 보증금 </td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getGrt_amt_s())%>원&nbsp;</td>
                                <td class='title' >개시대여료</td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getIfee_s_amt()+f_fee.getIfee_v_amt())%>원</td>
                                <td class='title' >월대여료</td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getFee_s_amt()+f_fee.getFee_v_amt())%>원
                                <%if(f_fee.getFee_chk().equals("1")){%><br>&nbsp;일시완납<%}%>	
                                </td>
                            </tr>
                        </table>
    </td>
  </tr>
  <tr>
    <td colspan='2'>&nbsp;</td>
  </tr>
	<tr>
	  <td colspan='2' class=line2></td>
	</tr>
  <tr> 
    <td colspan='2' class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='25%' class='title' >납부예정일<br>(현재가치 계산 기준일)</td>
                                <td width='25%' align='center'><input type='text' name='t_wd4' size='13' class='whitetext13b' value='<%=AddUtil.ChangeDate2(t_wd4)%>' readonly></td>
                                <td width='25%' class='title' >납부할 회차</td>
                                <td width='25%' align='center'>하단참조</td>
                            </tr>
                            <tr> 
                                <td class='title' >고객님께서 납부할 총액<br>(VAT포함)</td>
                                <td align='center' style="font-size : 13pt;"><input type='text' name='t_amt' size='12' class='whitenumber13b' value='' readonly>원
                                <td colspan='2' align='center'>월대여료 현재가치 합계<%if(dly_scd_yn>0){%> + 미납대여료(연체료 포함) <%}%>
                                </td>
                            </tr>
                        </table>
    </td>
  </tr>
  <tr> 
    <td colspan='2' class=h></td>
  </tr>
  <tr> 
    <td width='70%'>▶ 미도래 대여료 현재가치 계산 </td>	
    <td width='30%' align='right'>VAT포함</td>	
	</tr>
	<tr>
	  <td colspan='2' class=line2></td>
	</tr>
  <tr> 
    <td colspan='2' class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='5%' class='title'>회차</td>
                    <td width='12%' class='title'>구분</td>
                    <td width='12%' class='title'>원 입금예정일</td>
                    <td width='12%' class='title'>월대여료</td>
                    <td width='12%' class='title'>납부예정일</td>
                    <td width='18%' class='title'>월대여료 현재가치</td>
                    <td width='12%' class='title'>현재가치율</td>
                    <td width='17%' class='title'>선납 일수</td>
                </tr>
                <tr> 
            <td align='center'>&nbsp;</td>
            <td align='center'>&nbsp;</td>
            <td align='center'>(1)</td>
            <td align='center'>(2)</td>
            <td align='center'>(3)</td>
            <td align='center'>(4)=(2)×(5)</td>
            <td align='center'>(5)</td>
            <td align='center'>(6)=(1)-(3)</td>
                </tr>                
                <%		for(int i = 0 ; i < fee_scd_size ; i++){
												FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
												if(AddUtil.parseInt(AddUtil.replace(t_wd4,"-",""))<AddUtil.parseInt(AddUtil.replace(a_fee.getR_fee_est_dt(),"-","")) && AddUtil.parseInt(t_wd1)<=AddUtil.parseInt(a_fee.getFee_tm()) && AddUtil.parseInt(t_wd2)>=AddUtil.parseInt(a_fee.getFee_tm()) && a_fee.getRc_yn().equals("0") && a_fee.getDly_days().equals("0")){
													int prepay_day = AddUtil.parseInt(rs_db.getDay(t_wd4, a_fee.getR_fee_est_dt()))-1;
													double d_t_wd3 = AddUtil.parseDouble(t_wd3)/100;
													double d_prepay_day = AddUtil.parseDouble(String.valueOf(prepay_day));
													double d_fee_per = 1/Math.pow(1+d_t_wd3/12,d_prepay_day/365*12);
													float f_fee_per = Math.round(AddUtil.parseFloat(String.valueOf(d_fee_per))*10000)/100f;
													double d_now_value_amt = (a_fee.getFee_s_amt()+a_fee.getFee_v_amt())*d_fee_per;
													int i_now_value_amt = AddUtil.parseInt(AddUtil.parseFloatRoundZero(String.valueOf(d_now_value_amt)));
													total_amt1 = total_amt1 + a_fee.getFee_s_amt()+a_fee.getFee_v_amt();
													total_amt2 = total_amt2 + i_now_value_amt;
								%>
                <tr> 
            <td align='center'><%=a_fee.getFee_tm()%></td>
            <td align='center'>대여료</td>
            <td align='center'><%=AddUtil.ChangeDate2(a_fee.getFee_est_dt())%></td>
            <td align='right'><%=AddUtil.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>원</td>
            <td align='center'><%=AddUtil.ChangeDate2(t_wd4)%></td>
            <td align='right'><%=AddUtil.parseDecimal(i_now_value_amt)%>원</td>
            <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(f_fee_per),2)%>%</td>
            <td align='right'><%=prepay_day%></td>
                </tr>
                <%			}%>
                <%		}%>
                <tr> 
                    <td colspan='3' class='title'>합계</td>
                    <td align='right'><%=AddUtil.parseDecimal(total_amt1)%>원</td>
                    <td align='center'>-</td>
                    <td class='title' style='font-size : 10pt;text-align:right;'><%=AddUtil.parseDecimal(total_amt2)%>원</td>
                    <td colspan='2' class='title' style="font-size : 8pt;">원 납부 금액대비 <%=AddUtil.parseFloatCipher(String.valueOf(Math.round(AddUtil.parseFloat(String.valueOf(total_amt2))/AddUtil.parseFloat(String.valueOf(total_amt1))*10000)/100f),1)%>%(<%=AddUtil.parseDecimal(total_amt2-total_amt1)%>원)</td>
                </tr>                
                        </table>
    </td>
  </tr>	
  <tr> 
    <td colspan='2'>※ 납부일에 따라 미도래 대여료의 현재가치는 변동됩니다.</td>
	</tr>
                <%if(dly_scd_yn>0){%>
  <tr> 
    <td colspan='2' class=h></td>
  </tr>       
  <tr> 
    <td colspan='2'>▶ 미납 대여료 (납부예정일 기준, 연체료 포함) </td>	
	</tr>
	<tr>
	  <td colspan='2' class=line2></td>
	</tr>
  <tr> 
    <td colspan='2' class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='5%' class='title'>회차</td>
                    <td width='12%' class='title'>구분</td>
                    <td width='12%' class='title'>원 입금예정일</td>
                    <td width='12%' class='title'>월대여료<br>(VAT포함)</td>
                    <td width='12%' class='title'>납부예정일</td>
                    <td width='18%' class='title'>실입금액</td>
                    <td width='12%' class='title'>연체일수</td>
                    <td width='17%' class='title'>연체료</td>
                </tr>
                <%if(s_s>0){%>
                <tr> 
            <td align='center'>-</td>
            <td align='center'>미납연체료</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='right'><%=AddUtil.parseDecimal(s_s)%>원</td>
                </tr>                
                <%}%>
                <%		for(int i = 0 ; i < fee_scd_size ; i++){
												FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
												if(AddUtil.parseInt(t_wd1)<=AddUtil.parseInt(a_fee.getFee_tm()) && AddUtil.parseInt(t_wd2)>=AddUtil.parseInt(a_fee.getFee_tm()) && a_fee.getRc_yn().equals("0") && (AddUtil.parseInt(AddUtil.replace(t_wd4,"-",""))>=AddUtil.parseInt(AddUtil.replace(a_fee.getR_fee_est_dt(),"-","")) || !a_fee.getDly_days().equals("0"))){
													int i_dly_day = AddUtil.parseInt(rs_db.getDay(a_fee.getR_fee_est_dt(), t_wd4))-1;
													double d_dly_amt = (a_fee.getFee_s_amt()+a_fee.getFee_v_amt())*0.24/365*i_dly_day;
													int i_dly_amt = AddUtil.parseInt(AddUtil.parseFloatRoundZero(String.valueOf(d_dly_amt)));
													total_amt3 = total_amt3 + a_fee.getFee_s_amt()+a_fee.getFee_v_amt();
													total_amt4 = total_amt4 + i_dly_amt;
								%>
                <tr> 
            <td align='center'><%=a_fee.getFee_tm()%></td>
            <td align='center'><%if(a_fee.getTm_st1().equals("0")){%>대여료<%}else{%>잔액<%}%></td>
            <td align='center'><%=AddUtil.ChangeDate2(a_fee.getFee_est_dt())%></td>
            <td align='right'><%=AddUtil.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>원</td>
            <td align='center'><%=AddUtil.ChangeDate2(t_wd4)%></td>
            <td align='right'>0</td>
            <td align='right'><%=i_dly_day%>일</td>
            <td align='right'><%=AddUtil.parseDecimal(i_dly_amt)%>원</td>
                </tr>
                <%			}%>
                <%		}%>
                <tr> 
                    <td colspan='3' align='center'>합계</td>
                    <td align='right'><%=AddUtil.parseDecimal(total_amt3)%>원</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>                                        
                    <td align='right'><%=AddUtil.parseDecimal(total_amt4+s_s)%>원</td>
                </tr>                
                        </table>
    </td>
  </tr>		
  <tr>
    <td colspan='2' class=h></td>
  </tr>   
  <tr> 
    <td colspan='2'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='41%' class='line'>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='70%' align='center'>미납대여료(A)</td>
                    <td width='30%' align='right'><%=AddUtil.parseDecimal(total_amt3)%>원</td>
                </tr>	
                <tr> 
                    <td align='center'>납부 예정일 기준 연체료(B)</td>
                    <td align='right'><%=AddUtil.parseDecimal(total_amt4+s_s)%>원</td>
                </tr>	
                <tr> 
                    <td class='title'>합계[(A)+(B)]</td>
                    <td class='title' style='font-size : 10pt;text-align:right;'><%=AddUtil.parseDecimal(total_amt3+total_amt4+s_s)%>원</td>
                </tr>	
                  </table>	
                    </td>
                    <td width='59%'>&nbsp;</td>
                </tr>    
                        </table>
    </td>
  </tr>		
                <%}%>           
  <tr>
    <td colspan='2'>&nbsp;</td>
  </tr>                   
	<tr> 
  	<td colspan='2' style="font-size : 15pt;font-family:바탕체;" align='center'><span class=style2>주식회사 아마존카 대표이사 조성희</span></td>	
	</tr>                                     
	<%}%>
</table>
<script language='javascript'>
<!--
	var fm = document.form1;	
	fm.t_amt.value = parseDecimal(<%=total_amt2+total_amt3+total_amt4+s_s%>);
	
	<%if(print_yn.equals("Y")){%>
		window.print();
	<%}%>
//-->
</script>
</body>
</html>


