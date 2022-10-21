<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>


<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_way 	= request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
	
	if(l_cd.equals("") || l_cd.equals("null")){
		out.println("정상적인 호출이 아닙니다.");	
		return;
	}
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//cont
	ContBaseBean cont = a_db.getCont(m_id, l_cd);
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여갯수 카운터
	int fee_count = af_db.getFeeCount(l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//출고전대차 조회
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//대여기본정보
	ContFeeBean fee = a_db.getContFee(m_id, l_cd, rent_st);
	
	int tae_sum = af_db.getTaeCnt(m_id);
	
	Vector fee_scd = new Vector();
	Vector fee_scd_sun_nap = new Vector();// 선납금 2018.04.13
	int fee_scd_size = 0;
	int fee_scd_sun_nap_size = 0;// 선납금 2018.04.13
	//건별 대여료 스케줄 리스트
	if(rent_st.equals("")){
		fee_scd = af_db.getFeeScdMail2(l_cd, false);	// 선납금을 제외한 대여료입금 스케줄 2018.04.13
		fee_scd_sun_nap = af_db.getFeeScdMail2(l_cd, true);// 선납금 2018.04.13
		fee_scd_size = fee_scd.size();
		fee_scd_sun_nap_size = fee_scd_sun_nap.size();
	}else{
		fee_scd = af_db.getFeeScdEmailRentst2(l_cd, rent_st, "", false);//fee.getPrv_mon_yn()		// 선납금을 제외한 대여료입금 스케줄 2018.04.13
		fee_scd_sun_nap = af_db.getFeeScdEmailRentst2(l_cd, rent_st, "", true);		// 선납금 2018.04.13
		fee_scd_size = fee_scd.size();
		fee_scd_sun_nap_size = fee_scd_sun_nap.size();
		if(!rent_st.equals("1")) tae_sum=0;
	}
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean b_user2 = b_user;
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
	
	if(String.valueOf(base.get("BUS_ST_NM")).equals("에이전트")){
		b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID")));
		
		//에이전트 계약진행담당자
		if(!cont.getAgent_emp_id().equals("")){ 
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(cont.getAgent_emp_id()); 
				b_user.setUser_m_tel(a_coe_bean.getEmp_m_tel());
				b_user.setUser_nm		(a_coe_bean.getEmp_nm());
		}
	}
	
	
	//계좌번호 *로 가리기
	int acc_len = cms.getCms_acc_no().length();
	String acc_no = "";
	String acc_no1 = "";
	String acc_no2 = "";
	if(acc_len > 0){
		if(cms.getCms_acc_no().lastIndexOf("-") == -1){
			acc_no1 = "*******";
			if(acc_len > 7){
				acc_no2 = cms.getCms_acc_no().substring(7,acc_len);
			}
			acc_no = acc_no1+acc_no2;
		}else{
			acc_no1 = cms.getCms_acc_no().substring(0,cms.getCms_acc_no().lastIndexOf("-"));
			acc_no2 = cms.getCms_acc_no().substring(cms.getCms_acc_no().lastIndexOf("-"));
    		for (int i = 0; i < acc_no1.length(); i++){
	    		char c = (char) acc_no1.charAt(i);
    			if ( c == '-') 
    				acc_no += "-";
    			else 
	    			acc_no += "*";
    		}
			acc_no += acc_no+acc_no2;
		}
	}
	
	//차량 뒷번호 가리기
	int car_no_len = String.valueOf(base.get("CAR_NO")).length();
	String car_no = "";
	if(car_no_len > 3){
		car_no = String.valueOf(base.get("CAR_NO")).substring(0,car_no_len-2)+"**";
	}
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>자동차 관리 서비스 안내문</title>
<link href=http://fms1.amazoncar.co.kr/acar/main_car_hp/style.css rel=stylesheet type=text/css>
<style type="text/css">
<!--
.style1 {color: #88b228;font-size:13px; font-family:nanumgothic;}
.style2 {color: #333333;font-size:13px;font-family:nanumgothic;}
.style4 {color: #707166;font-size:13px; font-weight: bold;font-family:nanumgothic;}
.style5 {color: #e86e1b;font-family:nanumgothic;}
.style6 {color: #385c9d; font-weight: bold;font-family:nanumgothic;}
.style7 {color: #77786b;font-family:nanumgothic;}
.style8 {color: #e60011;font-family:nanumgothic;}
.style9 {color: #707166; font-size:13px; font-weight: bold;font-family:nanumgothic;}
.style10 {color: #454545; font-size:8pt;font-family:nanumgothic;}
.style11 {color: #6b930f; font-size:8pt;font-family:nanumgothic;}
.style12 {color: #77786b; font-size:8pt;font-family:nanumgothic;}
.style14 {color: #af2f98; font-size:8pt;font-family:nanumgothic;}
.style15 {font-size:13px;font-family:nanumgothic;}
-->
</style>

</head>
<body topmargin=0 leftmargin=0 bgcolor=#eef0dc>
<br><br><br><br>
<table width=835 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/tt_bg.gif align=center>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_up.gif width=835 height=55></td>
    </tr>
    <tr>
        <td align=center>
        	<table width=736 border=0 cellspacing=0 cellpadding=0>
	            <tr>
	                <td>
		                <table width=736 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td width=505 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/total_stitle.gif><br><br>
		                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style1><b>[ <%=base.get("FIRM_NM")%> ]</b></span>&nbsp;<span class=style2>님</span> </span></td>
		                        <td width=231>
			                        <table width=231 border=0 cellspacing=0 cellpadding=0>
			                        	<tr>
			                        		<td colspan=2 height=12></td>
			                        	</tr>
			                            <tr>
			                                <td width=75><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_bsn.gif width=68 height=18></td>
			                                <td><span class=style2><%=b_user.getUser_nm()%> <%=b_user.getUser_m_tel()%></span></td>
			                  			</tr>
			                  			<tr>
			                        		<td colspan=2 height=2></td>
			                        	</tr>
			                            <tr>
			                                <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_mng.gif width=68 height=18></td>
			                                <td><span class=style2><%=b_user2.getUser_nm()%> <%=b_user2.getUser_m_tel()%></span></td>
			                       		</tr>
			                       		<tr>
			                        		<td colspan=2 height=2></td>
			                        	</tr>
			                            <tr>
			                                <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_acct.gif width=68 height=18></td>
			                                <td><span class=style2><%=h_user.getUser_nm()%> <%=h_user.getHot_tel()%></span></td>
			                     		</tr>
			                        </table>
			                    </td>
		                    </tr>
		                </table>
		            </td>
	        	</tr>
	            <tr>
	                <td height=25 align=center></td>
	      		</tr>
	            <tr>
	                <td>
		                <table width=736 border=0 cellspacing=0 cellpadding=0>
							<%if(String.valueOf(base.get("RENT_WAY")).equals("기본식")){%> <!-- 기본식일경우 -->
		                	<tr>
		                		<td width=245><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gscd.gif border=0></td>
		                		<td width=245><a href=http://fms1.amazoncar.co.kr/mailing/total/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gcfms_gr.gif border=0></a></td>
		                		<td width=245><a href=http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gcar_gr.gif border=0></a></td>
		                        
		                	</tr>
							<%}else{%>
		                    <tr>
		                        <td width=184><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_scd.gif border=0></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_cfms_gr.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_car_gr.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/rep_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_rep_gr.gif border=0></a></td>
		                    </tr>
							<%}%>
		                </table>
		            </td>
	            </tr>
	            <tr>
	            	<td height=15></td>
	            </tr>
	            <tr>
	                <td align=center>
	                	<table width=683 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td width=567 style="line-height:18px;">&nbsp;<span class=style2>다음은 당사와 계약 체결한 자동차 및 대여요금 안내입니다.</span></td>
		                        <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_scd_img.gif  height=99>&nbsp;</td>
		                    </tr>
	                	</table>
	               	</td>
	            </tr>
	            <tr>
	                <td align=center>
	                	<table width=683 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/scd_bar_1.gif width=683 height=21></td>
		                	</tr>
		                    <tr>
		                        <td>
		                        	<table width=683 border=0 cellpadding=3 cellspacing=1 bgcolor=cacaca>
                                        <tr align=center>
                                            <td width=251 height=24 bgcolor=f2f2f2 colspan=4><span class=style4>대여차종</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center colspan=4><span class=style5><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span></td>
                                        </tr>
                                        <tr align=center>
                                        	<td width=151 height=24 bgcolor=f2f2f2><span class=style4>월대여료(VAT별도)</span></td>
                                        	<td width=123 bgcolor=f2f2f2><span class=style4>보증금</span></td>
                                        	<td width=123 bgcolor=f2f2f2><span class=style4>선납금(VAT별도)</span></td>
                                        	<td width=153 bgcolor=f2f2f2><span class=style4>개시대여료(VAT별도)</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                        	<td height=27 align=center><span class=style6><%= Util.parseDecimal(fee.getFee_s_amt()) %>원</span></td>
                                        	<td align=center><span class=style7><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>원</span></td>
                                        	<td align=center><span class=style7><%=AddUtil.parseDecimal(fee.getPp_s_amt())%>원</span></td>
                                        	<td align=center><span class=style7><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>원</span></td>
                                        </tr>
                                        <tr align=center>
                                            <td height=24 bgcolor=f2f2f2><span class=style4>대여기간</span></td>
                                            <td bgcolor=f2f2f2><span class=style4>대여개시일</span></td>
                                            <td bgcolor=f2f2f2><span class=style4>대여만료일</span></td>
                                            <td bgcolor=f2f2f2><span class=style4>자동차등록번호</span></td>
                                        </tr>
                                        <tr align=center bgcolor=#FFFFFF>
                                            <td height=27><span class=style7><%=fee.getCon_mon()%>개월</span></td>
                                            <td><span class=style7><%=fee.getRent_start_dt()%></span></td>
                                            <td><span class=style7><%=fee.getRent_end_dt()%></span></td>
                                            <td><span class=style7><%=base.get("CAR_NO")%></span></td>
                                        </tr>
                                    </table>
                            	</td>
		               		</tr>
		                    <tr>
		                        <td height=25></td>
		            		</tr>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/scd_bar_2.gif width=683 height=21></td>
		         			</tr>
		                    <tr>
		                        <td>
		                        	<table width=683 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_up.gif width=683 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=643>
                                       <!-- 대여료 입금안내 -->
                                                <table width=643 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=20 align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/arrow.gif> 
                                                        <span class=style2>고객님의 대여료 납부일은 매월 <span class=style8><font size=2><b><%if(fee.getFee_est_day().equals("99")){%>말일<%}else{%><%= fee.getFee_est_day() %><%}%></b></font></span>일입니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/arrow.gif> 
                                                        <span class=style2>결제일자 변경은 총무팀 <span class=style5>(Tel.02-392-4243)</span>에 요청바랍니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left>&nbsp;&nbsp;&nbsp;&nbsp;<span class=style2>(결제일자를 변경하시면 변경 후 초회 대여료 금액이 변경될 수 있습니다.(일할계산))</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/arrow.gif> 
                                                        <span class=style2>입금예정일자가 <span class=style5>공휴일/주말(토,일)</span>인 경우 <span class=style5>익일</span>이 입금예정일자입니다.</span></td>
                                                    </tr>
													
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=4></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_dw.gif width=683 height=7></td>
                                        </tr>
                                    </table>
		                        </td>
		              		</tr>
		                    <tr>
		                        <td height=25></td>
		             		</tr>
		                    <tr><!-- 대여료 스케줄 -->
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/scd_bar_3_1.gif width=635 height=21><a href="javascript:pop_excel('dyr');"
		                        	><img src=https://fms5.amazoncar.co.kr/acar/images/center/button_excel.gif border=0></a></td>
		             		</tr>
		                    <tr>
		                        <td>
		                        	<table width=683 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td width=41 height=24 align=center><span class=style9>회차</span></td>
                                            <td width=172 align=center><span class=style9>사용기간</span></td>
                                            <td width=117 align=center><span class=style9>입금예정일자</span></td>
                                            <td width=107 align=center><span class=style9>공급가</span></td>
                                            <td width=107 align=center><span class=style9>부가세</span></td>
                                            <td width=138 align=center><span class=style9>월대여료</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td colspan=6>
                                                <table width=680 border=0 cellspacing=0 cellpadding=0>
        										<% 	if(fee_scd_size>0){
														for(int i = 0 ; i < fee_scd_size ; i++){
															FeeScdBean scd = (FeeScdBean)fee_scd.elementAt(i);%>												
                                                    <tr <%if(i%2 != 0){%>bgcolor=f7fae5<%}%>>
                                                        <td width=41 height=18 align=center>
                                                          <span class=style10>
                                                            <%if(scd.getTm_st2().equals("2")){%>b<%}%>
                                                            <%=scd.getFee_tm()%>
                                                          </span>
                                                        </td>
                                                        <td width=172 align=center><span class=style12><%=AddUtil.ChangeDate2(scd.getUse_s_dt())%> ~ <%=AddUtil.ChangeDate2(scd.getUse_e_dt())%> </span></td>
                                                        <td width=117 align=center><span class=style11><%=AddUtil.ChangeDate2(scd.getFee_est_dt())%></span></td>
                                                        <td width=106 align=right><span class=style12><%=Util.parseDecimal(scd.getFee_s_amt())%></span>&nbsp;&nbsp;</td>
                                                        <td width=106 align=right><span class=style12><%=Util.parseDecimal(scd.getFee_v_amt())%></span>&nbsp;&nbsp;</td>
                                                        <td width=137 align=right><span class=style11><b><%=Util.parseDecimal(scd.getFee_s_amt()+scd.getFee_v_amt())%></b> </span>&nbsp;&nbsp;</td>
                                                    </tr>
												<%}}%>	
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
		                        </td>
		            		</tr>
		            		<%if(tae_sum>0){%>
	                    	<tr>
	                     		<td height=20>(회차에 b가 표시된 것은 <%if(String.valueOf(base.get("CAR_NO")).equals(taecha.getCar_no())){%>만기매칭대차<%}else{%>출고전대차<%}%> 스케줄입니다.)</td>
	                    	</tr>
							<%}%>
							<%if(fee_scd_sun_nap_size>0){%>
		                    <tr><!-- 2018.04.13 start -->
		                        <td height=25></td>
		               		</tr>
		               		<tr><!-- 선납대여료균등발행 스케줄 -->
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/scd_bar_3_2.gif width=635 height=21><a href="javascript:pop_excel('sn');"
		                        	><img src=https://fms5.amazoncar.co.kr/acar/images/center/button_excel.gif border=0></a></td>
		             		</tr>
		                    <tr>
		                        <td>
		                        	<table width=683 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td width=41 height=24 align=center><span class=style9>회차</span></td>
                                            <td width=172 align=center><span class=style9>사용기간</span></td>
                                            <td width=117 align=center><span class=style9>세금계산서일자</span></td>
                                            <td width=107 align=center><span class=style9>공급가</span></td>
                                            <td width=107 align=center><span class=style9>부가세</span></td>
                                            <td width=138 align=center><span class=style9>월대여료</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td colspan=6>
                                                <table width=680 border=0 cellspacing=0 cellpadding=0>
        										<% 	
														for(int i = 0 ; i < fee_scd_sun_nap_size ; i++){
															FeeScdBean scd_sn = (FeeScdBean)fee_scd_sun_nap.elementAt(i);%>												
                                                    <tr <%if(i%2 != 0){%>bgcolor=f7fae5<%}%>>
                                                        <td width=41 height=18 align=center>
                                                          <span class=style10>
                                                            <%if(scd_sn.getTm_st2().equals("2")){%>b<%}%>
                                                            <%=scd_sn.getFee_tm()%>
                                                          </span>
                                                        </td><!-- 회차 -->
                                                        <td width=172 align=center><span class=style12><%=AddUtil.ChangeDate2(scd_sn.getUse_s_dt())%> ~ <%=AddUtil.ChangeDate2(scd_sn.getUse_e_dt())%> </span></td><!-- 사용기간 -->
                                                        <td width=117 align=center><span class=style11><%=AddUtil.ChangeDate2(scd_sn.getTax_out_dt())%></span></td><!-- 세금계산서일자 -->
                                                        <td width=106 align=right><span class=style12><%=Util.parseDecimal(scd_sn.getFee_s_amt())%></span>&nbsp;&nbsp;</td><!-- 공급가 -->
                                                        <td width=106 align=right><span class=style12><%=Util.parseDecimal(scd_sn.getFee_v_amt())%></span>&nbsp;&nbsp;</td><!-- 부가세 -->
                                                        <td width=137 align=right><span class=style11><b><%=Util.parseDecimal(scd_sn.getFee_s_amt()+scd_sn.getFee_v_amt())%></b> </span>&nbsp;&nbsp;</td><!-- 월대여료 -->
                                                    </tr>
												<%}%>	
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
		                        </td>
		            		</tr>
		            		<%}%><!-- 2018.04.13 end -->
		                    <tr>
		                        <td height=25></td>
		               		</tr>
		               		<!-- 입금방법 : 무통장 -->							
							<%if(cms.getRent_l_cd().equals("")){%>
                            <tr>
                                <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/scd_bar_4.gif width=648 height=21></td>
                            </tr>						
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank.gif></td>
                            </tr>
                     		<!-- 입금방법 : 자동이체 -->							
							<%}else{%>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/scd_bar_4_1.gif width=683 height=21></td>
		               		</tr>
		                    <tr>
		                        <td>
		                        	<table width=683 border=0 cellpadding=0 cellspacing=0 bgcolor=f4f1e6>
                                        <tr>
                                            <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/total/images/bank_up.gif width=683 height=4></td>
                                        </tr>
                                        <tr>
                                            <td width=29>&nbsp;</td>
                                            <td width=182><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_1.gif width=175 height=109></td>
                                            <td width=21>&nbsp;</td>
                                            <td width=425>
                                                <table width=425 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/bank_c_bg.gif>
                                                    <tr>
                                                        <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/total/images/bank_c_up.gif width=425 height=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=5 height=10></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=21 height=20>&nbsp;</td>
                                                        <td width=13 align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td width=118 align=left><span class=style15>신청계좌 거래은행</span></td>
                                                        <td width=21><span class=style16>|</span></td>
                                                        <td width=252 align=left><span class=style2><%=cms.getCms_bank()%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;</td>
                                                        <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td align=left><span class=style15>신청계좌번호</span></td>
                                                        <td><span class=style16>|</span></td>
                                                        <td align=left><span class=style2><%=acc_no%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;</td>
                                                        <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td align=left><span class=style15>최초인출예정</span></td>
                                                        <td><span class=style16>|</span></td>
                                                        <td align=left><span class=style2><%=AddUtil.ChangeDate2(cms.getCms_start_dt())%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;</td>
                                                        <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td align=left><span class=style15>마지막인출일자</span></td>
                                                        <td><span class=style16>|</span></td>
                                                        <td align=left><span class=style2><%=AddUtil.ChangeDate2(cms.getCms_end_dt())%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;</td>
                                                        <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td align=left><span class=style15>자동이체일</span></td>
                                                        <td><span class=style16>|</span></td>
                                                        <td align=left><span class=style5>매월 <%=cms.getCms_day()%>일</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=5 height=7></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/total/images/bank_c_dw.gif width=425 height=3></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=26>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/total/images/bank_dw.gif width=683 height=4></td>
                                        </tr>
                                    </table>
		                        </td>
	                        </tr>
	                        <%}%>							
                     <!-- 입금방법 -->
                     		
	                	</table>
	              	</td>
	            </tr>
	            <tr>
	            	<td height=60></td>
	            </tr>
	            <tr>
	                <td align=center>
	                	<table width=700 border=0 cellspacing=0 cellpadding=0>
			                <tr>
			                    <td width=35>&nbsp;</td>
			                    <td width=92><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
			                    <td width=35>&nbsp;</td>
			                    <td width=1 bgcolor=dbdbdb></td>
			                    <td width=40>&nbsp;</td>
			                    <td width=499><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
			                </tr>
			                <map name=Map1>
			                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
			                </map>
			            </table>
	                </td>
	            </tr>
			</table>
		</td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_dw.gif width=835 height=55></td>
    </tr>
</table>
<br><br><br><br>
<form name="form1" method="post"><!-- 2018.04.06 -->
	<input type="hidden" name="m_id" value="<%=m_id%>">
	<input type="hidden" name="l_cd" value="<%=l_cd%>">
	<input type="hidden" name="rent_st" value="<%=rent_st%>">
</form>
<script>
//리스트 엑셀 전환		2018.04.06
//선납금 추가 2018.04.13
function pop_excel(gubun){
	var fm = document.form1;
	fm.target = "_blank";
	if(gubun=="sn"){
		fm.action = "scd_info_sn_excel.jsp";
	}else{
		fm.action = "scd_info_excel.jsp";
	}
	fm.submit();
}
</script>
</body>
</html>