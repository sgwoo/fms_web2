<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String due_dt = c_db.addDay(FineDocBn.getEnd_dt(), 0);
	String due_dt2 = c_db.addDay(FineDocBn.getEnd_dt(), 1);
	
	//연체리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);

	
	String rent_st = "";
	int cls_per = 0;
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
<title>아마존카 계약해지 및 차량반납통보 안내문</title>
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
table td{font-size:10.7pt;}
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
 <!--   
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
    	 
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=450>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/images/ment_02.gif width=414 height=12></td>
                    <td width=250 align=right><span class=style2><b><%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%></b></span>&nbsp;&nbsp;&nbsp;</td>
                </tr> 
            </table>
   
        </td>
    </tr>
  -->  
  <!--
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=454 valign=top>
                        <table width=454 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=14><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_left_up.gif width=14 height=16></td>
                                <td width=440 background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_up_bg.gif>&nbsp;</td>
                            </tr>
                            <tr>
                                <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_bg.gif>&nbsp;</td>
                                <td align=center>
                                    <table width=411 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td height=50 align=left>&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/mailing/pay/images/info_title_h.gif></td>
                                        </tr>
                                  
                                        <tr>
                                            <td height=30 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span class=style1><span class=style1><b><%=c_db.getNameById(FineDocBn.getGov_id(), "CLIENT")%></b></span>&nbsp;<span class=style2>님 귀하</span> </span></td>
                                        </tr>
                                 
                                        <tr>
                                            <td height=11></td>
                                        </tr>
                                        <tr>
                                            <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_line_up.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor=f7f7f7>
                                                <table width=411 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan=3 height=16></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=12>&nbsp;</td>
                                                        <td width=386 align=left>
                                                            <table width=386 border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=18><span class=style2>당사는 귀사(귀하)와 원만한 거래관계가 지속되도록 최선을 다해왔으나</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>아래와 같이 계약해지 및 납부최고서를 보내게 되었음을 유감스럽게</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>생각합니다. </span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=12>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 height=14></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_line_dw.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_left_dw.gif width=14 height=16></td>
                                <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_dw_bg.gif>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width=36 valign=top>
                        <table width=36 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_bg.gif>
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_right_up.gif width=36 height=16></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                            </tr>
                            <tr>
                                <td height=129></td>
                            </tr>
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/info_right_dw.gif width=36 height=16></td>
                            </tr>
                        </table>
                    </td>
                    <td width=187 valign=top>
            			<table width=187 border=0 cellpadding=0 cellspacing=0 bgcolor=574d89>
                            <tr>
                                <td width=187 bgcolor=594e8a>
                                    <table width=187 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=16 background=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_up_bg.gif></td>
                                        </tr>
                                        <tr>
                                            <td height=16><img src=http://fms1.amazoncar.co.kr/mailing/rent/images/sup_img1.gif width=187 height=51></td>
                                        </tr>
                                        <tr>
                                            <td height=40 align=left></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;<img src=http://fms1.amazoncar.co.kr/mailing/car_adm/images/sup.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=4></td>
                                        </tr>
                               
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong>함윤원</strong></span> </td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong>02)392-4243</strong></span></td>
                                        </tr>
                                        <tr>
                                            <td height=48></td>
                                        </tr>
                         
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=16 background=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_dw_bg.gif>&nbsp;</td>
                            </tr>
                        </table>
            		</td>
                </tr>
            </table>
        </td>
    </tr>
   --> 
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_r_1.gif></td>
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
                                            <td height=45>&nbsp;&nbsp;1. 당사는 귀사(귀하)와 원만한 거래관계가 지속되도록 최선을 다해 왔으나, &nbsp;이 건 계약해지 및 
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;차량반납통보를 보내게 되었음을 유감스럽게 생각합니다.</td>
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;2. 주지하다시피 아래와 같이 귀사(귀하)와 당사와의 사이에 자동차 대여이용계약을 체결하였습니
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;다.</td>
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
						
					Hashtable base1 = as_db.getSettleBase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), "", "");
					de_day  =	AddUtil.parseInt((String)base1.get("S_MON")) * 30  +   AddUtil.parseInt((String)base1.get("S_DAY")); 
																	
					//cont
					Hashtable base = a_db.getContViewCase(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
					
					rent_st = FineDocDb.getMaxRentSt(FineDocListBn.getRent_l_cd());
					
					ContFeeBean fee = a_db.getContFeeNew(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd(), rent_st);
					
					ContEtcBean cont_etc = a_db.getContEtc(FineDocListBn.getRent_mng_id(), FineDocListBn.getRent_l_cd());
					
					cls_per = (int)fee.getCls_r_per();
						
					amt_6 += FineDocListBn.getAmt6();
				
								
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
                                                        <td align=center bgcolor=#FFFFFF width=244><span class=style12>잔여기간 대여료 총액의 (<%=cls_per%>) %</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tR>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;3. 그런데, 귀사(귀하)가 대여료를 (<span class=style15><%=de_day%></span>)일 이상 납부하지 않고 있어서 당사는 귀사(귀하)와 더 이상 
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;계약관계를 유지할 수 없으며 상기 중도해지 규정을 적용하여 중도해지 통보합니다.<br>
                                           </td>
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;4. 귀사(귀하)의 <b><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></b>&nbsp;현재 해지정산금은&nbsp;(&nbsp;<b><%=Util.parseDecimal(amt_6)%></b>&nbsp;) 원 입니다.</td>
                                        </tr>
                                       <!-- <tr>
                                            <td>
                                                <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=db9b06>
                                                    <tr bgcolor=f6ebcc>
                                                        <td width=321 align=center bgcolor=f6ebcc height=35><span class=style10><b>해지정산금</b></span></td>
                                                        <td align=center bgcolor=ffffff>&nbsp;&nbsp;<span class=style8><%=Util.parseDecimal(amt_6)%> 원</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td align=right><span class=style12>* 상기 해지정산금은 차량 회수일까지 변동됨을 알려드립니다.</span>&nbsp;&nbsp;&nbsp;</td>
                                        </tr>-->
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td height=50>&nbsp;&nbsp;5. 아래 일시까지 차량을 반납할 것을 통보하며, &nbsp;반납 하지 않을 경우 귀사(귀하)에게 <span class=style15>모든 법적책임
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(횡령죄로 형사 고소등)</span>을 물을 것입니다.</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=628 border=0 cellspacing=1 cellpadding=0 bgcolor=000000>
                            
                           <tr bgcolor=ffffff>
                                <td style="font-size : 9pt;" align=center bgcolor=f6ebcc colspan=2 height=25><span class=style10><b>차량반납기한</b></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2>&nbsp;<span class=style12><%=AddUtil.getDate3(due_dt)%></span></td>
								<td style="font-size : 9pt;" align=center bgcolor=f6ebcc colspan=2 height=25><span class=style10><b>법적절차진행예정일</b></span></td>
                                <td style="font-size : 9pt;" align=center bgcolor=ffffff colspan=2>&nbsp;<span class=style12><%=AddUtil.getDate3(due_dt2)%></span></td>
                          </tr>
                           
                        </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tR>
                                        <tr>
                                            <td height=60>&nbsp;&nbsp;6. 위 일시까지 차량반납이 안될시 당사는 귀사(귀하)와 &nbsp;연대보증인을 상대로 &nbsp;민·형사상 &nbsp;법적구제
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;절차 및 자구행위를 진행하고, &nbsp;이에 따르는 &nbsp;제비용(가압류,&nbsp; 임의경매 등의 &nbsp;소송관련 제비용,
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;차량회수 등 업무위탁에 따른 제비용 등 포함)을 별도 청구할 예정이며, 경우에 따라  보증보험청구
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;및 신용정보기관에 채권 추심의뢰와 채무불이행 정보를 등록할 것이며, 채무불이행 정보 등록 시 
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;개인 신용 평점 또는 기업신용등급이 하락하고 금리가 상승하는 등의 불이익이 발생 할 수 있음을 
                                            <br>&nbsp;&nbsp;&nbsp;&nbsp;알려드립니다. </td>                                                                          
                                            
                                        </tr>
                                        <tr>
                                            <td height=40>&nbsp;&nbsp;<span class=style7>※ 문의처 : 법무담당 장혁준 02-6263-6383</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        
                                        <tr>
                                            <td align=right><img src=https://fms5.amazoncar.co.kr/mailing/pay/images/pay_h_ceo_1.gif></td>
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
                    <td width=82><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=523><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
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