<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*,acar.cls.*, acar.forfeit_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");

	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String due_dt = c_db.addDay(FineDocBn.getEnd_dt(), 0);
	String due_dt2 = c_db.addDay(FineDocBn.getEnd_dt(), 1);
		
	//연체리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);

	
	String rent_st = "";
	String cls_per = "";
	String cls_dt = "";
	int de_day = 0;
	
	int start_dt = 0;	
	
	long amt3[]   = new long[9];
	
	int amt_1 = 0;
	int amt_2 = 0;
	int amt_3 = 0;
	int amt_4 = 0;
	int amt_5 = 0;
	int amt_6 = 0;
	int amt_7 = 0;
	long amt_i = 0;
	

%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 해지통보 및 해지정산금 납입고지 안내문</title>
<style type="text/css">
<!--
.style1 {color: #88b228}
.style2 {color: #747474}
.style3 {color: #ffffff}
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:9pt;}
.style11 {color: #6b930f; font-size:9pt;}
.style12 {color: #77786b; font-size:9pt;}
.style14 {color: #af2f98; font-size:9pt;}
.style15 {color: #334ec5;}
table td{font-size:10.5pt;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=https://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
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
        <td height=5 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=30></td>
                </tR>
                <tr>
                    <td align=center>
                        <table width=677 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_bg.gif>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_c_1.gif></td>
                            </tr>
                            <tr>
                                <td height=40></tD>
                            </tr>
                            <tr>
                                <td align=center>
                                    <table width=619 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=92><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t1.gif></td>
                                            <td><span class=style15><%=FineDocBn.getDoc_id()%> </span></td>
                                        </tr>
                                        <tr>
                                            <td height=3 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td width=92><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t4.gif></td>
                                            <td><span class=style15><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></span></td>
                                        </tr>
                                        <tr>
                                            <td height=3 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t2.gif></td>
                                            <td><%=FineDocBn.getGov_nm()%>&nbsp;<%=FineDocBn.getMng_dept()%></td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td><%=FineDocBn.getGov_addr()%></td>
                                        </tr>
                                        <tr>
                                            <td height=3 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t3.gif></td>
                                            <td>(주)아마존카 대표이사 조성희</td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>서울특별시 영등포구 의사당대로 8, 태흥빌딩 8층 802호 (여의도동)</td>
                                        </tr>
                                        <tr>
                                            <td height=3 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_t5.gif></td>
                                            <td><%=FineDocBn.getTitle()%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td align=center height=40><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_line.gif></td>
                            </tr>
                           <tr>
                                <td align=center>
                                    <table width=648 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width="708" height="25" style="font-size : 10pt;"><p>&nbsp;&nbsp;1. 당사는 귀사(귀하)와 원만한 거래관계가 지속되도록 최선의 노력을 다해왔으나, 이 건 <b>해지통보 및 해지<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;정산금 납입고지</b>를 보내게 되었음을 유감스럽게 생각합니다.</p>
                    </td>
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;2. 당사와 귀사(귀하)와의 사이에 체결한 자동차대여계약 주요내용은 아래 표와 같습니다.</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=105 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>차명</b></span></td>
                                                        <td width=96 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>차량번호</b></span></td>
                                                        <td height=22 colspan=3 align=center bgcolor=f6ebcc><span class=style10><b>대여이용계약기간</b></span></td>
                                                        <td width=80 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>보증금</b></span></td>
                                                        <td width=80 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>개시대여료</b></span></td>
                                                        <td width=82 rowspan=2 align=center bgcolor=f6ebcc><span class=style10><b>월대여료</b></span></td>
                                                    </tr>
                                                    <tr bgcolor=#FFFFFF>
                                                        <td width=72 height=22 align=center bgcolor=f6ebcc><span class=style10><b>개시일</b></span></td>
                                                        <td width=72 align=center bgcolor=f6ebcc><span class=style10><b>종료일</b></span></td>
                                                        <td width=52 align=center bgcolor=f6ebcc><span class=style10><b>비고</b></span></td>
                                                    </tr>
													  <% if(FineList.size()>0){
															for(int i=0; i<FineList.size(); i++){ 
																FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
																ClsBean cls = as_db.getClsCase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
																de_day  =	AddUtil.parseInt((String)cls.getNfee_mon()) * 30  +   AddUtil.parseInt((String)cls.getNfee_day()); 
																												
																//cont
																Hashtable base = a_db.getContViewCase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
																
																rent_st = FineDocDb.getMaxRentSt(FineDocListBn.getRent_l_cd());
																
																ContFeeBean fee = a_db.getContFeeNew(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), rent_st);
																
																ContEtcBean cont_etc = a_db.getContEtc(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
																
																cls_per = cls.getDft_int();
																cls_dt	= cls.getCls_dt();
																	
																amt_6 += FineDocListBn.getAmt6();
											
																//연체료 정산
																Hashtable ht3 = s_db.getContSettleCase2("",FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd() , "", "1", "6", FineDocBn.getDoc_dt());
														
														
																for(int j=0; j<9; j++){
																	amt3[j]  += AddUtil.parseLong(String.valueOf(ht3.get("EST_AMT"+j)));
																}
																
																if (amt3[2]- amt3[8]  < 0  ) {
																   amt_i = 0;
																} else {
																   amt_i = amt3[2]-amt3[8];
																}
																
																amt_2 += FineDocListBn.getAmt2();
																amt_3 += FineDocListBn.getAmt3();
																amt_4 += FineDocListBn.getAmt4();
																amt_5 += FineDocListBn.getAmt5();
																amt_7 += FineDocListBn.getAmt7();
																
																if ( amt_7 > 0 ) {
																  amt_i = amt_7;   
																}			
													%>	
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=#FFFFFF><span class=style12><%=base.get("CAR_NM")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style11><%=base.get("CAR_NO")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style12><%=base.get("RENT_START_DT")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style12><%=base.get("RENT_END_DT")%></span></td>
                                                        <td align=center bgcolor=#FFFFFF><span class=style12><%=base.get("CON_MON")%>개월</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getGrt_amt_s())%> 원&nbsp;</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%> 원&nbsp;</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%> 원&nbsp;</span></td>
                                                       
                                                    </tr>
													<%
																start_dt = AddUtil.ChangeStringInt(String.valueOf(base.get("RENT_START_DT")));
																if(!cont_etc.getRent_suc_dt().equals("")){
																	start_dt = AddUtil.parseInt(cont_etc.getRent_suc_dt());	
																}
												 			}
														} 
													%>                                                    
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=105 align=center bgcolor=f6ebcc height=35><span class=style10><b>중도해지조건</b></span></td>
                                                        <td colspan=3 bgcolor=ffffff>&nbsp;<span class=style12>월대여료를 30일 이상 연체할 시 계약의 해지 및 대여중인 차량을 회수</span></td>
                                                    </tr>
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=f6ebcc><span class=style10><b>연체이자율</b></span></td>
                                                        <td align=center bgcolor=#FFFFFF width=214><span class=style12><%if(start_dt < 20081010 ) {%>연 18%<%}else if(start_dt >= 20081010 && start_dt < 20220101) {%>연 24%<%}else{%>연 20%<%}%></span></td>
                                                        <td align=center bgcolor=f6ebcc width=80><span class=style10><b>위약금</b></span></td>
                                                        <td align=center bgcolor=#FFFFFF width=244><span class=style12>잔여기간 대여료 총액의 (<%=cls_per%>) %</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tR>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;3. 그런데, 귀사(귀하)가 대여료를 (<span class=style15><%=de_day%></span>)일 이상 미납 및  (주)아마존카의 차량 반납 요청에도 불구하고 
                                            	<br>&nbsp;&nbsp;&nbsp;&nbsp;차량을 반납하고 있지 않아 당사는 귀사(귀하)와 더 이상 계약관계를 유지할수 없으며 상기 중도해지
                                            	<br>&nbsp;&nbsp;&nbsp;&nbsp;규정을 적용하여 중도해지 및  고소장이 접수 되었음을 알려드립니다.<br>
                                           </td>
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;4. 귀사(귀하)의 해지정산금은 아래 표와 같습니다. </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=#FFFFFF>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 height=25 width=157><span class=style10><font face="바탕"><b>해지정산일</b></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 width=157>&nbsp;<span class=style12><font face="바탕"> <b><%=AddUtil.getDate3(cls_dt)%></b></font></span></td>
								 <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 height=25 width=157><span class=style10><font face="바탕"><b>해지정산금</b></font></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2 width=157>&nbsp;<span class=style12><font face="바탕"><b><%=Util.parseDecimal(amt_5)%>원</b></font></span></td>
                            </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td height=50>&nbsp;&nbsp;5. 아래 일시까지 중도해지정산금을 납부하지 않을 경우 귀하에게 채권회수에 따른 법적인 모든  
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;책임을 물을 것입니다.<br>
											</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
													<tr bgcolor=ffffff>
														<td style="font-size : 9pt;" align=center bgcolor=ffffff height=25 width=157><span class=style10><font face="바탕"><b>해지정산금납부기한</b></font></span></td>
														<td style="font-size : 9pt;" align=center bgcolor=ffffff width=157>&nbsp;<span class=style12><font face="바탕"><b><%=AddUtil.getDate3(due_dt)%></b></font></span></td>
														<td style="font-size : 9pt;" align=center bgcolor=ffffff height=25 width=157><span class=style10><font face="바탕"><b>채권회수절차진행예정일</b></font></span></td>
														<td style="font-size : 9pt;" align=center bgcolor=ffffff width=157>&nbsp;<span class=style12><font face="바탕"><b><%=AddUtil.getDate3(due_dt2)%></b></font></span></td>
													</tr>
													<tr bgcolor=#FFFFFF>
														<td height=35 align=center bgcolor=f6ebcc><span class=style10><b>입금계좌번호</b></span></td>
														<td bgcolor=#fffff colspan=3 align=center>&nbsp;<span class=style12>&nbsp;<b>신한 140-004-023871</b></span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tr>
                                              <tr>
                     							<td height="25" >&nbsp;&nbsp;6. 또한 위 일시까지 중도해지정산금 일체를 납입하지 아니할 경우, 당사는 귀사(귀하)와 연대보증인을 
								                     <br>&nbsp;&nbsp;&nbsp;&nbsp;상대로 연체채권(중도해지위약금포함) 회수 과정에서 발생할 수 있는 모든 비용(가압류 및 
								                     <br>&nbsp;&nbsp;&nbsp;&nbsp;임의경매등의 소송관련 제비용, 기타 법적인 조치, 업무위탁에따른 제비용 등을 포함)을 별도 청구할 
								                     <br>&nbsp;&nbsp;&nbsp;&nbsp;예정이며,경우에 따라 보증보험 청구 및 신용정보기관에 채권추심 의뢰와 채무불이행 정보를 등록
								                     <br>&nbsp;&nbsp;&nbsp;&nbsp;할 것임을 통보 드립니다. -끝-</td>
								                </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;<span class=style7>※ 문의처 : 법무담당 장혁준 02-6263-6383</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td align=right><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_ceo.gif></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=20></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_2.gif></td>
                            </tr>
                        </table>
                    </td>
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
                    <td width=35>&nbsp;</td>
                    <td width=112><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
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