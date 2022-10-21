<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>

<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String due_dt = c_db.addDay(FineDocBn.getEnd_dt(), 1);
		
	//연체리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);

	
	String rent_st = "";
	int cls_per = 0;
	
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
<title>아마존카 계약해지 및 납부최고 안내문</title>
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
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
.style15 {color: #334ec5;}
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_1.gif></td>
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
                                            <td><%=FineDocBn.getGov_nm()%></td>
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
                                            <td>서울특별시 영등포구 의사당대로 8, 까뮤이앤씨빌딩 8층 802호 (여의도동)</td>
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
                                            <td height=45>&nbsp;&nbsp;1. 당사는 귀사(귀하)와 원만한 거래관계가 지속되도록 최선의 노력을 다해왔으나, 이 건 계약해지 및 납부최고를<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;보내게 되었음을 유감스럽게 생각합니다.</td>
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
												
					//cont
					Hashtable base = a_db.getContViewCase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
					
					rent_st = FineDocDb.getMaxRentSt(FineDocListBn.getRent_l_cd());
					
					ContFeeBean fee = a_db.getContFeeNew(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), rent_st);
					
					ContEtcBean cont_etc = a_db.getContEtc(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
					
					cls_per = (int) fee.getCls_r_per();
					
					Hashtable ht2 = s_db.getContSettleCase1("2", FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd() , "", "1", "6", FineDocBn.getDoc_dt());
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
					amt_7 += FineDocListBn.getAmt7(); //연체이자
					
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
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getGrt_amt_s())%>&nbsp;</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>&nbsp;</span></td>
                                                        <td align=right bgcolor=#FFFFFF><span class=style12><%=Util.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>&nbsp;</span></td>
                                                       
                                                    </tr>
<%
start_dt = AddUtil.ChangeStringInt(String.valueOf(base.get("RENT_START_DT")));
if(!cont_etc.getRent_suc_dt().equals("")){
	start_dt = AddUtil.parseInt(cont_etc.getRent_suc_dt());	
}
%>                                                     
<% 		}
	} %>                                                    
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
                                                        <td align=center bgcolor=#FFFFFF width=244><span class=style12>잔여기간 대여료 총액의 (<%=cls_per%>)%</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tR>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;3. 귀사(귀하)의 <span class=style15><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%> 현재 미납 금액</span>은 아래 표와 같습니다. </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=135 align=center bgcolor=f6ebcc height=35><span class=style10><b>연체대여료</b></span></td>
                                                        <td align=right width=186 bgcolor=ffffff>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_2)%> 원&nbsp;</span></td>
                                                        <td width=135 align=center bgcolor=f6ebcc><span class=style10><b>연체이자</b></span></td>
                                                        <td align=right width=187 bgcolor=ffffff>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_i)%> 원&nbsp;</span></td>
                                                    </tr>
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=f6ebcc><span class=style10><b>교통위반과태료 등</b></span></td>
                                                        <td align=right bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_3)%> 원&nbsp;</span></td>
                                                        <td align=center bgcolor=f6ebcc><span class=style10><b>면책금</b></span></td>
                                                        <td align=right bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_4)%> 원&nbsp;</span></td>
                                                    </tr>
                                                 
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=f6ebcc><span class=style10><b>해지정산금</b></span></td>
                                                        <td align=right bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_5)%> 원&nbsp;</span></td>
                                                        <td align=center bgcolor=f6ebcc><span class=style10><b>합계</b></span></td>
                                                        <td align=right bgcolor=#FFFFFF>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_2+amt_3+amt_4+amt_5+amt_i)%> 원&nbsp;</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tR>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;4. 납부기한 및 대여차량 회수 예정일자는 아래 표와 같습니다.</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=135 align=center bgcolor=f6ebcc height=35><span class=style10><b>납부기한</b></span></td>
                                                        <td width=186 bgcolor=fffff>&nbsp;<span class=style12><%=AddUtil.getDate3(FineDocBn.getEnd_dt())%></span></td>
                                                        <td width=135 align=center bgcolor=f6ebcc><span class=style10><b>대여차량회수예정일</b></span></td>
                                                        <td width=187 bgcolor=fffff>&nbsp;<span class=style12><%=AddUtil.getDate3(due_dt)%></span></td>
                                                    </tr>
                                                    <tr bgcolor=#FFFFFF>
                                                        <td height=35 align=center bgcolor=f6ebcc><span class=style10><b>입금계좌번호</b></span></td>
                                                        <td bgcolor=#fffff colspan=3>&nbsp;<span class=style12>&nbsp;신한 140-004-023871</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tR>
                                        <tr>
                                            <td height=60>&nbsp;&nbsp;5. 귀사(귀하)는 당사의 수차례 안내에도 불구하고 아직까지 상기 미납금액을 납부하지 않고 있으며, 당사는 이 건 때문<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;에 업무상 상당한 지장을 받고 있습니다. 이에 당사는 상기 납부기한 일까지 미납금액 전부를 납부할 것을 최고 하는<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;바이며, 만일 납부하지 않은 경우 상기 자동차대여계약은 별도의 해지통보없이 자동으로 해지될 것입니다.</td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tR>
                                        <tr>
                                            <td height=50>&nbsp;&nbsp;6. 위 일시까지 미납금액 전부를 납부하지 않은 경우 당사는 귀사(귀하)와 연대보증인을 상대로 민·형사상&nbsp; 법적구제절<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;차및 자구행위를 진행하고, 이에 따르는 제비용&nbsp;(가압류, 임의경매 등의 소송관련 제비용, &nbsp;차량회수 등&nbsp; 업무위탁에<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 따른 제비용 등 포함)을별도 청구할 예정이며,경우에 따라 보증보험금 청구 및 신용조사기관 등에 채무불이행 사실<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;을 통보 및 등재할 예정이므로 신용상 큰 불이익이 있을 수 있음을 알려드립니다.</td>
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;<span class=style7>※ 문의처 : 법무담당 장혁준 02-6263-6383</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20></td>
                                        </tr>
                                        <tr>
                                            <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_ceo.gif></td>
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
    <!--
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style12>본 메일은 발신전용 메일이므로 궁금한 사항은 <a href=mailto:tax@amazoncar.co.kr><span class=style14>수신메일(tax@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</span></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>-->
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