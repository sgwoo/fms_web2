<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>

<%
	
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
		
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");

		
	String mail_code	= request.getParameter("mail_code")==null?"":request.getParameter("mail_code");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//연장대여정보
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//연장직전대여정보
	ContFeeBean bfo_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(AddUtil.parseInt(rent_st)-1));
	
	//연장담당자
	UsersBean bus_user_bean = umd.getUsersBean(ext_fee.getExt_agnt());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//자동차등록정보
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>연장계약메일</title>
<link href=http://fms1.amazoncar.co.kr/acar/main_car_hp/style.css rel=stylesheet type=text/css>
<style type=text/css>
<!--
.style1 {color: #2e4168; font-size:13px;font-weight: bold;font-family:nanumgothic;}
.style2 {color: #636262;font-size:13px;font-family:nanumgothic;}
.style10 {color: #88b228;font-size:13px;font-family:nanumgothic;}
.style11 {
	color: #a71a41;
	font-weight: bold;
	font-family:nanumgothic;
	font-size:13px;
}
.style3{color:#000000;font-size:13px;font-weight: bold;font-family:nanumgothic;}
-->
</style>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/ask/images/img_bg.gif>
                <tr>
                    <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_img_1.gif height=430 align=center  valign=top>
                    	<table width=510 border=0 cellspacing=0 cellpadding=0>
                    		<tr>
                    			<td height=180></td>
                    		</tr>
                       		<tr>
	                            <td class=style2> &nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_arrow.gif align=absmiddle> <span class=style10><b><%=client.getFirm_nm()%> 님 </b></span></td>
	                        </tr> 
	                    </table>
                    </td>
                </tr>
                <tr>
                	<td height=30></td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=558 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_bar.gif align=absmiddle></td>
                                <td align=right><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_arrow_1.gif align=absmiddle> <span class=style3>영업담당 : <%=bus_user_bean.getUser_nm()%></span> <%=bus_user_bean.getUser_m_tel()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td height=10 colspan=2></td>
                            </tr>
                            <tr>
                            	<td align=center colspan=2>
                            		<table width=541 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                            			<tr>
                            				<td colspan=4 height=1></td>
                            			</tr> 
                            			<tr>
			                                <td bgcolor=f2f2f2 width=134 height=24 align=center><span class=style1>구 분</span></td>
			                                <td bgcolor=f2f2f2 width=134 align=center>&nbsp;<span class=style1>기존 계약</span></td>
			                                <td bgcolor=f2f2f2 width=125 align=center><span class=style1>연장 계약</span></td>
			                                <td bgcolor=f2f2f2 width=143 align=center>&nbsp;<span class=style1>비 고</span></td>
			                            </tr>                       
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>차량번호</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%=cr_bean.getCar_no()%></span></td>
			                                <td bgcolor=ffffff align=center><span class=style2>좌동</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>차 명</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%=cr_bean.getCar_nm()%></span></td>
			                                <td bgcolor=ffffff align=center><span class=style2>좌동</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>세부차명</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%=cm_bean.getCar_name()%></span></td>
			                                <td bgcolor=ffffff align=center><span class=style2>좌동</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>대여상품</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>장기렌트<%}else if(car_st.equals("3")){%>리스plus<%}else if(car_st.equals("4")){%>월렌트<%}%> <%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></span></td>
			                                <td bgcolor=ffffff align=center><span class=style2><%if(fee.getRent_way().equals(ext_fee.getRent_way())){%>좌동<%}else{%><%if(car_st.equals("1")){%>장기렌트<%}else if(car_st.equals("3")){%>리스plus<%}else if(car_st.equals("4")){%>월렌트<%}%> <%String rent_way2 = ext_fee.getRent_way();%><%if(rent_way2.equals("1")){%>일반식<%}else if(rent_way2.equals("3")){%>기본식<%}%><%}%></span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>이용기간</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%=bfo_fee.getCon_mon()%>개월</span></td>
			                                <td bgcolor=f2f2f2 align=center><span class=style11><%=ext_fee.getCon_mon()%>개월</span></td>
			                                <td bgcolor=ffffff align보=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>대여개시일</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%=AddUtil.ChangeDate2(bfo_fee.getRent_start_dt())%></span></td>
			                                <td bgcolor=ffffff align=center><span class=style2><%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>대여만료일</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%=AddUtil.ChangeDate2(bfo_fee.getRent_end_dt())%></span></td>
			                                <td bgcolor=ffffff align=center><span class=style2><%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%></span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>보증금</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%=AddUtil.parseDecimal(bfo_fee.getGrt_amt_s())%>원</span></td>
			                                <td bgcolor=f2f2f2 align=center><span class=style11><%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>원</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%if(bfo_fee.getGrt_amt_s()==ext_fee.getGrt_amt_s() || ext_fee.getGrt_suc_yn().equals("0")){%>기존보증금 승계<%}%></span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>선납금</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%=AddUtil.parseDecimal(bfo_fee.getPp_s_amt()+bfo_fee.getPp_v_amt())%>원</span></td>
			                                <td bgcolor=ffffff align=center><span class=style2><%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>원</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>개시대여료</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%=AddUtil.parseDecimal(bfo_fee.getIfee_s_amt()+bfo_fee.getIfee_v_amt())%>원</span></td>
			                                <td bgcolor=ffffff align=center><span class=style2><%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>원</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                            <%
			                            	//월대여료인하율
			                            	int cha_amt = (bfo_fee.getFee_s_amt()+bfo_fee.getFee_v_amt())-(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt());
				                            int cal_s_amt = bfo_fee.getPp_s_amt() / AddUtil.parseInt(bfo_fee.getCon_mon());
											              int cal_v_amt = bfo_fee.getPp_v_amt() / AddUtil.parseInt(bfo_fee.getCon_mon());
			                            	float cal1=0, cal2=0;
			                            	
			                            	if((bfo_fee.getPp_s_amt()+bfo_fee.getPp_v_amt()) > 0){
												              //fee_amt_per = AddUtil.parseFloat(String.valueOf(bfo_fee.getFee_s_amt()+bfo_fee.getFee_v_amt()+cal_s_amt+cal_v_amt-ext_fee.getFee_s_amt()-ext_fee.getFee_v_amt()))/AddUtil.parseFloat(String.valueOf(bfo_fee.getFee_s_amt()+bfo_fee.getFee_v_amt()+cal_s_amt+cal_v_amt))*100;
												              cal1 = bfo_fee.getFee_s_amt()+bfo_fee.getFee_v_amt()+cal_s_amt+cal_v_amt-ext_fee.getFee_s_amt()-ext_fee.getFee_v_amt();
												              cal2 = bfo_fee.getFee_s_amt()+bfo_fee.getFee_v_amt()+cal_s_amt+cal_v_amt;
										  	            }else{		
										  		            //fee_amt_per = AddUtil.parseFloat(String.valueOf(cha_amt)) / AddUtil.parseFloat(String.valueOf(bfo_fee.getFee_s_amt()+bfo_fee.getFee_v_amt())) * 100;
										  		            cal1 = cha_amt;
										  		            cal2 = bfo_fee.getFee_s_amt()+bfo_fee.getFee_v_amt();
										  	            }
			                            	float fee_amt_per = cal1/cal2*100;
			                            %>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>월대여료(VAT포함)</span></td>
			                                <td bgcolor=f2f2f2 align=center><span class=style11>
			                                	<%if(bfo_fee.getPp_s_amt()+bfo_fee.getPp_v_amt() > 0){ %>
			                                		<%=AddUtil.parseDecimal(bfo_fee.getFee_s_amt()+bfo_fee.getFee_v_amt()+cal_s_amt+cal_v_amt)%>원
			                                	<%}else{ %>
			                                		<%=AddUtil.parseDecimal(bfo_fee.getFee_s_amt()+bfo_fee.getFee_v_amt())%>원
			                                	<%} %>
			                                </span></td>
			                                <td bgcolor=f2f2f2 align=center><span class=style11><%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>원</span></td>
			                                <td bgcolor=f2f2f2 align=center><span class=style11><%if(bfo_fee.getFee_s_amt()>ext_fee.getFee_s_amt()){%>기존 대비 <%= AddUtil.calcMath("ROUND", String.valueOf(fee_amt_per), 1) %>% 인하<%}%></span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>중도해지 위약금율</span></td>
			                                <td bgcolor=ffffff align=center><span class=style2><%=bfo_fee.getCls_r_per()%>%</span></td>
			                                <td bgcolor=f2f2f2 align=center><span class=style11><%=ext_fee.getCls_r_per()%>%</span></td>
			                                <td bgcolor=ffffff align=center><span class=style2>
			                                <%if(bfo_fee.getPp_s_amt()+bfo_fee.getPp_v_amt() > 0){ %>
			                                	※ 기존대여료 = (선납금 ÷ 계약기간) + 월대여료
			                                <%}else{ %>
			                                	잔여기간 대여료 기준
			                                <%} %>
			                                </span></td>
			                            </tr>
			                            <tr>
			                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>매입옵션(VAT포함)</span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2><%if(bfo_fee.getOpt_s_amt()==0){%>없음<%}else{%><%=AddUtil.parseDecimal(bfo_fee.getOpt_s_amt()+bfo_fee.getOpt_v_amt())%>원<%}%></span></td>
			                                <td bgcolor=ffffff align=center><span class=style2><%if(ext_fee.getOpt_s_amt()==0){%>없음<%}else{%><%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt())%>원<%}%></span></td>
			                                <td bgcolor=ffffff align=center>&nbsp;<span class=style2>&nbsp;</span></td>
			                            </tr>
			                        </table>
                            	</td>
                            </tr>
                            <tr>
                            	<td height=15></td>
                            </tr>
                            <!--
                            <tr>
                            	<td colspan=2>&nbsp;&nbsp;&nbsp;※ 연장계약서는 <span class=style11>첨부파일</span>에서 확인 가능합니다. 계약서 확인 후 아래 버튼을 눌러주세요. </td>
                            </tr>
                            -->
                            <tr>
                            	<td colspan=2>&nbsp;&nbsp;&nbsp;<span class=style3>※ 연장계약서는 아래 버튼 <span class=style11>E-mail 답변 보내기로 가기</span>에서 확인 가능합니다. <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 아래 버튼을 눌러주세요.</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                	<td height=40></td>
                </tr>
                <tr>
                	<td align=center><a href=http://fms1.amazoncar.co.kr/mailing/rent/renew_email_re.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=rent_st%>&mail_code=<%=mail_code%> target=_blank><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_button_rtmail.gif border=0></a></td>
                </tr>
                <tr>
                    <td height=40></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_img_2.gif></td>
                </tr>
            </table> 
        </td>
    </tr>
    <tr>
        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=40>&nbsp;</td>
                    <td width=82 align=center><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=32>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=33>&nbsp;</td>
                    <td width=512><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>