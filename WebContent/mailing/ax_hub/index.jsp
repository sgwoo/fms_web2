<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.cont.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>

<%

	//20210420 미사용
	out.println("미사용 페이지 입니다.");
	if(1==1)return;
	
	
	//결제시스템 인증메일
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String am_good_st	= request.getParameter("am_good_st")	==null?"":request.getParameter("am_good_st");
	String am_good_id1	= request.getParameter("am_good_id1")	==null?"":request.getParameter("am_good_id1");
	String am_good_id2 	= request.getParameter("am_good_id2")	==null?"":request.getParameter("am_good_id2");
	String am_good_amt	= request.getParameter("am_good_amt")	==null?"":request.getParameter("am_good_amt");
	String am_user_id	= request.getParameter("am_user_id")	==null?"":request.getParameter("am_user_id");
	
	String client_id 	= "";
	String site_id 		= "";
	String bus_id 		= "";
	String mng_id 		= "";
	
	if(am_good_st.equals("월렌트")){
		//단기계약정보
		RentContBean rc_bean = rs_db.getRentContCase(am_good_id1, am_good_id2);	//s_cd, c_id		
		
		client_id	= rc_bean.getCust_id();		
		bus_id		= rc_bean.getBus_id();		
		mng_id		= rc_bean.getMng_id();		
		
		if(  rc_bean.getMng_id().equals("000026") || rc_bean.getMng_id().equals("000053") || rc_bean.getMng_id().equals("000052")){
			mng_id		= rc_bean.getBus_id();		
		}
	}else{
		//계약기본정보
		ContBaseBean base = a_db.getCont(am_good_id1, am_good_id2);//rent_mng_id, rent_l_cd
		
		client_id	= base.getClient_id();		
		site_id		= base.getR_site();		
		bus_id		= base.getBus_id();		
		mng_id		= base.getBus_id2();		
	}
	

	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(client_id, site_id);
	
	//담당자정보 : 세금계산서담당자가 신용카드결제도 담당
	String tax_user_id = nm_db.getWorkAuthUser("세금계산서담당자");
	UsersBean tax_user_bean = umd.getUsersBean(tax_user_id);
	
	
	Hashtable ht = new Hashtable();
		
	ht.put("NAME", 		client.getFirm_nm());
	ht.put("CLIENT_ID",  	client_id);
	ht.put("SEQ", 		site_id);
	ht.put("REG_DT",	AddUtil.getDate());
	ht.put("USER_NM",	tax_user_bean.getUser_nm());
	ht.put("USER_H_TEL",	tax_user_bean.getHot_tel());

	//차량담당자	
	UsersBean mng_user_bean = umd.getUsersBean(mng_id);
	String mng_nm = mng_user_bean.getUser_nm();
	String mng_hp = mng_user_bean.getHot_tel();

		
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>결제인증메일링</title>
<style type="text/css">
<!--
.style1 {
	color: #747474;
	font-weight: bold;
}
.style2 {color: #747474}
.style3 {
	color: #ff00ff;
	font-weight: bold;
}
.style4 {color: #626262}
.style5 {color: #376100}
.style6 {
	color: #FFFFFF;
	font-weight: bold;
}
.style8 {color: #696969}
.style9 {
	color: #f75802;
}
-->
</style>
<link href="http://fms1.amazoncar.co.kr/mailing/style.css" rel="stylesheet" type="text/css">

</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align="center">
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href="http://www.amazoncar.co.kr" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>           
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
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/images/ment_02.gif width=414 height=12></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><table width=677 border=0 cellspacing=0 cellpadding=0>
          <tr>
            <td width=446 valign=top><table width=446 border=0 cellspacing=0 cellpadding=0>
                <tr>
                  <td width=14><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_up.gif width=14 height=16></td>
                  <td width=440 background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_up_bg.gif>&nbsp;</td>
                </tr>
                <tr>
                  <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_bg.gif>&nbsp;</td>
                  <td align=center><table width=421 border=0 cellspacing=0 cellpadding=0>
                      <tr>
                        <td width=421 height=58 align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_title.gif width=340 height=22></td>
                      </tr>
                      <tr>
                        <td><table width=411 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                              <td width=31 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_left.gif width=11 height=67></td>
                              <td width=369><table width=369 border=0 cellspacing=0 cellpadding=0>
                                  <tr>
                                    <td height=27 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/arrow.gif width=10 height=11> &nbsp;<span class=style1><%=ht.get("NAME")%>&nbsp;님 </span></td>
                                  </tr>
                                  <tr>
                                    <td height=18 align=left><span class=style2><span class=style3>결제용 인증번호가 휴대폰으로 문자 발행되었습니다. </span></td>
                                  </tr>
                                  <tr>
                                    <td height=18 align=left><span class=style2>아래 수신방법을 참고하셔서 결제하여 주시기 바랍니다. </span></td>
                                  </tr>
                              </table></td>
                              <td width=11><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_right.gif width=11 height=67></td>
                            </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="15">&nbsp;</td>
                      </tr>
                      <tr>
                        <td height=45 align=center valign=bottom><a href="http://211.52.73.124/ax_hub/ax_hub_index.jsp?var1=<%=am_good_st%>&var2=<%=am_good_id1%>&var3=<%=am_good_id2%>&var4=<%=am_good_amt%>" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/button_receive.gif width=174 height=34 border=0></a></td>
                      </tr>
                      <tr>
                        <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/ment.gif width=355 height=41></td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_dw.gif width=14 height=16></td>
                  <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_dw_bg.gif>&nbsp;</td>
                </tr>
            </table></td>
            <td width=36 valign=top><table width=36 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_bg.gif>
                <tr>
                  <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_up.gif width=36 height=16></td>
                </tr>
                <tr>
                  <td height=60></td>
                </tr>
                <tr>
                  <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                </tr>
                <tr>
                  <td height=145></td>
                </tr>
                <tr>
                  <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                </tr>
                <tr>
                  <td height=60></td>
                </tr>
                <tr>
                  <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_dw.gif width=36 height=16></td>
                </tr>
            </table></td>
            <td width=195 valign=top><table width=195 border=0 cellpadding=0 cellspacing=0 bgcolor=574d89>
                <tr>
                  <td width=187 bgcolor=594e8a><table width=187 border=0 cellspacing=0 cellpadding=0>
                      <tr>
                        <td height=16 background=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_up_bg.gif></td>
                      </tr>
                      <tr>
                        <td height=10></td>
                      </tr>
                      <tr>
                        <td height=16><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_img1.gif width=187 height=51></td>
                      </tr>
                      <tr>
                        <td height=21 align=left></td>
                      </tr>
                      <tr>
                        <td align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/sup_car.gif></td>
                      </tr>
                      <tr>
                        <td height=5></td>
                      </tr>
                      <!-- 차량담당자 전화번호 -->
                      <tr>
                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6><%=mng_nm%></span>&nbsp;&nbsp;<span class=style6><%=mng_hp%></span>
                          
                        </td>
                      </tr>
                      <tr>
                        <td height=15></td>
                      </tr>
                      <tr>
                        <td align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/sup_acc.gif></td>
                      </tr>
                      <tr>
                        <td height=5></td>
                      </tr>
                      <!-- 회계담당자 전화번호 -->
                      <tr>
                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6><%=ht.get("USER_NM")%></span>&nbsp;&nbsp;<span class=style6><%=ht.get("USER_H_TEL")%></span>
                          
                        </td>
                      </tr>
                      <tr>
                        <td height=15></td>
                      </tr>
                      <tr>
                        <td align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/supervisor_2.gif width=70 height=20></td>
                      </tr>
                      <tr>
                        <td height=5></td>
                      </tr>
                      <tr>
                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6><strong>TEL. 02-392-4243 </strong></span></td>
                      </tr>
                      <tr>
                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6><strong>FAX. 02-757-0803 </strong></span></td>
                      </tr>
                      <tr>
                        <td height=10></td>
                      </tr>
                      <!-- 담당자 전화번호 -->
                  </table></td>
                </tr>
                <tr>
                  <td height=16 background=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_dw_bg.gif>&nbsp;</td>
                </tr>
            </table></td>
          </tr>
        </table></td>
    </tr>
    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=26>&nbsp;</td>
                    <td width=648>
                        <table width=648 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_03.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background="http://fms1.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif">
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=608>
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=20 align=left><span class=style8>1. 비밀번호는 &quot;고객 FMS&quot; 로그인 비밀번호를 입력하셔야 합니다. </span></td>
                                                        </tr>
                                                    <tr>
                                                        <td height=20 align=left><span class=style8>2. 처음 방문하시는 고객은 법인/개인사업자-사업자등록번호, 개인-주민등록번호를 입력하셔야 합니다. </span></td>
                                                        </tr>
                                                    <tr>
                                                        <td height=20 align=left><span class=style8>3. 입력하신 비밀번호가 일치하지 않을 경우에는 <span class=style9>전산팀 02-392-4243</span> 또는 <span class=style9>메일(<a href=mailto:dev@amazoncar.co.kr><span class=style9>dev@amazoncar.co.kr</span></a>)</span>로 </span></td>
                                                  </tr>
                                                    <tr>
                                                      <td height=20 align=left><span class=style8>연락주시기 바랍니다. </span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_04.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                            <!-- 회계 담당자 연락처 -->
                                            <td width=608 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> <span class=style8>&quot;<span class=style9>고객 FMS</span>&quot;에 로그인하여 담당자를 직접 변경하거나 <span class=style9>회계담당자 <%=ht.get("USER_H_TEL")%></span> 에게 연락주시기 바랍니다. </span></td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_01.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=608 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> <span class=style8>고객님께서 수신할 문서가 아니시면 <span class=style9>메일(<a href=mailto:tax@amazoncar.co.kr><span class=style9>tax@amazoncar.co.kr</span></a>)</span>로 연락주시기 바랍니다.</span></td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr> 
                            <tr>
                                <td height=30></td>
                            </tr>
							<tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_02.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/img_01.gif></td>
                            </tr>
							<tr>
                                <td height=30></td>
                            </tr>
							<tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_05.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=25>&nbsp;</td>
                                            <td width=598 align=left>
                                                <table width=598 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=20><span class=style8>세금계산서의 교부라 함은 세금계산서를 발행하여 거래상대방에게 넘겨주는 것을 말하는 것으로, 사업자가 부</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20><span class=style8>가가치세법 제 16조의 규정에 의한 세금계산서를 교부함에 있어, 그 거래시기에 별지 제 11호 세금계산서 양식</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20><span class=style8>에 기재 사항을 기재하여 이를 e-mail에 의하여 전송하고 공급자와 공급받는 자가 각각 출력하여 보관하는 경</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20><span class=style8>우에는 세금계산서를 교부한 것으로 보는 것이고(서삼-1032, 2005.7.6), 단순히 이메일 형태로 보관하는 것은</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20><span class=style8>세금계산서의 교부에 해당하지 아니한다.</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=25>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr> 
							<tr>
								<td height=30></td>
							</tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=324><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/img_02.gif width=324 height=234></td>
                                            <td width=11>&nbsp;</td>
                                            <td width=313><a href="http://www.trusbill.or.kr/" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/img_03.gif width=313 height=234 border=0></a></td>
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/ment_03.gif usemap=#Map border=0></td>
    </tr>
    <map name=Map>
        <area shape=rect coords=202,1,371,10 href=mailto:tax@amazoncar.co.kr>
    </map>
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
                    <td width=112><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png ></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_right.gif usemap=#Map1 border=0></td>
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