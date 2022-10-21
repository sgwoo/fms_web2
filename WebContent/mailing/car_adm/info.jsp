<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"002316":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"S105YNCL00040":request.getParameter("l_cd");
	String ins_st 	= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//계약:고객관련
	ContBaseBean base2 = a_db.getContBaseAll(m_id, l_cd);
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("보유차관리"));
	
	InsDatabase ai_db = InsDatabase.getInstance();
	if(ins_st.equals(""))	ins_st = ai_db.getInsSt(String.valueOf(base.get("CAR_MNG_ID")));
	
	//보험정보
	InsurBean ins = ai_db.getInsCase(String.valueOf(base.get("CAR_MNG_ID")), ins_st);
	
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 장기대여 차량관리 안내</title>
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
.style13 {color: #ff00ff}
.style14 {color: #af2f98; font-size:8pt;}
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
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
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
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
    <!-- 날짜 -->
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=450>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/images/ment_02.gif width=414 height=12></td>
                    <td width=250 align=right><span class=style2><b><%= AddUtil.getDate() %></b></span>&nbsp;&nbsp;&nbsp;</td>
                </tr> 
            </table>
    <!-- 날짜 -->
        </td>
    </tr>
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
                                <td width=14><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_up.gif width=14 height=16></td>
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
                                            <td height=50 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/info_title.gif></td>
                                        </tr>
                                   <!-- 업체명 -->
                                        <tr>
                                            <td height=20 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span class=style1><span class=style1><b><%=base.get("FIRM_NM")%></b></span>&nbsp;<span class=style2>님 귀하</span> </span></td>
                                        </tr>
                                   <!-- 업체명 -->
                                        <tr>
                                            <td height=9></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_line_up.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor=f7f7f7>
                                                <table width=411 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan=3 height=14></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=12>&nbsp;</td>
                                                        <td width=386 align=left>
                                                            <table width=386 border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=18><span class=style2>저희 (주)아마존카는 고객님을 직접 찾아가는 서비스로 성심성의껏 차량</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>관리를 해드리고 있습니다.</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>고객님의 안전운전을 위하여 다음과 같은 사항을 알려 드리오니 운행시</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>참고하시기 바랍니다.</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=12>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 height=10></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_line_dw.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_dw.gif width=14 height=16></td>
                                <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_dw_bg.gif>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width=36 valign=top>
                        <table width=36 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_bg.gif>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_up.gif width=36 height=16></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                            </tr>
                            <tr>
                                <td height=129></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_dw.gif width=36 height=16></td>
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
                                            <td height=16><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_img1.gif width=187 height=51></td>
                                        </tr>
                                        <tr>
                                            <td height=17 align=left></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/sup.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=4></td>
                                        </tr>
                              <!-- 담당자 전화번호 -->
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=b_user.getUser_nm()%></strong></span><!--[$user_h_tel$]--> </td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=b_user.getUser_m_tel()%></strong></span><!--[$user_h_tel$]--></td>
                                        </tr>
                                        <tr>
                                            <td height=8></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/supervisor_2.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong>TEL. 02-392-4243 </strong></span></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong>FAX. 02-757-0803 </strong></span></td>
                                        </tr>
                              <!-- 담당자 전화번호 -->
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
    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=26>&nbsp;</td>
                    <td width=648>
                        <table width=648 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_1.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                       <!-- FMS서비스란? -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td width=55 height=24>&nbsp;</td>
                                            <td width=160 align=center bgcolor=f2f2f2><span class=style4>부품종류</span></td>
                                            <td width=268 align=center bgcolor=f2f2f2><span class=style4>교환시기</span></td>
                                            <td width=160 align=center bgcolor=f2f2f2><span class=style4>기타</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>1</span></td>
                                            <td align=center><span class=style5>엔진오일</span></td>
                                            <td align=left>&nbsp;<span class=style7>주행거리 매 7,000km 전후로 교환 </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>2</span></td>
                                            <td align=center><span class=style5>밋션오일</span></td>
                                            <td align=left>&nbsp;<span class=style7>주행거리 40,000km 이후 교환 </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>3</span></td>
                                            <td align=center><span class=style5>타이밍벨트</span></td>
                                            <td align=left>&nbsp;<span class=style7>주행거리 80,000 ~ 100,000km 사이 교환 </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>4</span></td>
                                            <td align=center><span class=style5>점화플러그</span></td>
                                            <td align=left>&nbsp;<span class=style7>주행거리 60,000km 이후 교환 </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>5</span></td>
                                            <td align=center><span class=style5>라이닝교환</span></td>
                                            <td align=left>&nbsp;<span class=style7>주행거리 40,000km 이후 교환 </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>6</span></td>
                                            <td align=center><span class=style5>타이어교환</span></td>
                                            <td align=left>&nbsp;<span class=style7>주행거리 50,000km이후 교환</span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                      <!-- FMS서비스란? -->
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_2.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                      <!-- FMS이용방법 -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td width=200 height=24 align=center><span class=style4>운전자범위</span></td>
                                            <td width=105 align=center bgcolor=f2f2f2><span class=style4>운전연령</span></td>
                                            <td width=339 align=center bgcolor=f2f2f2><span class=style4>보험범위(일반종합보험)</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>계약자, 계약자의 직원/가족 </span></td>
                                            <td rowspan=2 align=center><span class=style7>
											<%if(ins.getCar_mng_id().equals("")){%>
								                <%if(base2.getDriving_age().equals("0")){%> 26세이상 <%}%>
								                <%if(base2.getDriving_age().equals("3")){%> 24세이상 <%}%>
								                <%if(base2.getDriving_age().equals("1")){%> 21세이상 <%}%>
								                <%if(base2.getDriving_age().equals("2")){%> 모든운전자 <%}%>
											<%}else{%>
								                <%if(ins.getAge_scp().equals("1")){%>21세이상<%}%> 
								                <%if(ins.getAge_scp().equals("4")){%>24세이상<%}%> 
								                <%if(ins.getAge_scp().equals("2")){%>26세이상<%}%> 
								                <%if(ins.getAge_scp().equals("3")){%>모든운전자<%}%>		
											<%}%>									
											 </span></td>
                                            <td rowspan=2 align=center><span class=style7>
											<%if(ins.getCar_mng_id().equals("")){%>
								                책임,
												대인(무한),
								                <% if(base2.getGcp_kd().equals("1")){%>대물(5천만원),<%}%>
								                <% if(base2.getGcp_kd().equals("2")){%>대물(1억원),<%}%>												
								                <% if(base2.getBacdt_kd().equals("1")){%>자기신체(5천만원),<%}%>
								                <% if(base2.getBacdt_kd().equals("2")){%>자기신체(1억원),<%}%><br>
												자차(<b>자차면책금 <%=AddUtil.parseDecimal(base2.getCar_ja())%>원</b> 포함) 												
											<%}else{%>
											    책임,
								                <%if(ins.getVins_pcp_kd().equals("1")){%>대인(무한),<%}%> 
								                <%if(ins.getVins_pcp_kd().equals("2")){%>대인(유한),<%}%> 
								                <%if(ins.getVins_gcp_kd().equals("3")){%>대물(1억원),<%}%> 
								                <%if(ins.getVins_gcp_kd().equals("4")){%>대물(5천만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("1")){%>대물(3천만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("2")){%>대물(1천5백만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("5")){%>대물(1천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("1")){%>자기신체(3억원),<%}%> 
								                <%if(ins.getVins_bacdt_kd().equals("2")){%>자기신체(1억5천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("6")){%>자기신체(1억원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("5")){%>자기신체(5천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("3")){%>자기신체(3천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("4")){%>자기신체(1천5백만원),<%}%><br>
												<%if(ins.getVins_canoisr_amt()>0){%>무보험차상해,<%}%>
												<%if(ins.getVins_spe_amt()>0){%>애니카,<%}%>												
												자차(<b>자차면책금 <%=AddUtil.parseDecimal(base2.getCar_ja())%>원</b> 포함)
											<%}%>																				
											</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>계약자 직원의 가족</span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr>
                            <tr>
                                <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/img_1.gif></td>
                            </tr>
                      <!-- FMS이용방법 -->
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_3.gif></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                       <!-- FMS제공내용 -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=608>
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=30 align=left><span class=style2>운행 중 일어난 사고나 기타 발생된 사고에 대하여 저희 (주)아마존카에서 모두 처리해 드리고 있습니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=25 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>사고 발생시에 당사의 차량관리 담당자에게 즉시 연락주셔야 합니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=30 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>사고차량의 견인, 정비공장 입고 등은 당사의 관리자의 지시에 따라야 하며, 별도 지시없이 고객의
임의로 정<br>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;비를 했을 경우 정비비는 고객부담입니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=25 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>사후 보험 약관에 따라 조치합니다.(사고시 대차는 계약 조건에 준합니다.)</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=20></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3  align=center><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/img_2.gif></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_4.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                      <!-- 기타문의 -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=608>
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=18 align=left><span class=style2>차량정비 문제 및 사고로 인하여 4시간 이상 정비공장으로 입고된 경우 대여차종과 
                                                        동급의 차량으로 무상 대차 
서</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left><span class=style2>비스를 제공해 드립니다.</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_5.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                      <!-- 기타문의 -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=608>
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=18 align=left><span class=style2>속도위반, 전용차로 위반, 주정차 위반, 무인 감시카메라 등 고객이 운행 중 적발된 과태료나 범칙금은 고객님께서</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left><span class=style2>부담하셔야 합니다. (별도 공지)</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width=26>&nbsp;</td>
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
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style12>본 메일은 발신전용 메일이므로 궁금한 사항은 <a href=mailto:tax@amazoncar.co.kr><span class=style14>수신메일(tax@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</span></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
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
                    <td width=112><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
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