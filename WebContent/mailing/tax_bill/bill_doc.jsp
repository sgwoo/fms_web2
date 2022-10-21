<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*, acar.user_mng.*, acar.client.*"%>
<jsp:useBean id="IssueDb" class="tax.IssueDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String reg_id 		= request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String gubun 		= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String item_id 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String tax_no 		= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String reg_dt 		= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	
	if(gubun.length() >1 && reg_code.equals("") && tax_no.equals("")){
		if(gubun.length() == 28){//ex:1=201109210710013860==008812
			String t_gubun = gubun;
			gubun 		= t_gubun.substring(0,1);
			reg_code 	= t_gubun.substring(1,20);
			client_id	= t_gubun.substring(22,28);
		}
		if(gubun.length() == 30){//ex:1=201109210710013860=01=008812
			String t_gubun = gubun;
			gubun 		= t_gubun.substring(0,1);
			reg_code 	= t_gubun.substring(1,20);
			site_id 	= t_gubun.substring(21,23);
			client_id	= t_gubun.substring(24,30);
		}
	}
	
	if(!reg_code.equals("") && tax_no.equals("")){
		gubun = "1";
	}
	if(reg_code.equals("") && !tax_no.equals("")){
		gubun = "2";
	}
	
	Hashtable ht = IssueDb.getTaxItemMailCase(gubun, reg_code, item_id, client_id, site_id);
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(client_id, site_id);
	
	//계산서담당자
	UsersBean taxer_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
	
	if(String.valueOf(ht.get("CLIENT_ID")).equals("null") || String.valueOf(ht.get("CLIENT_ID")).equals("")){
		ht.put("NAME", 		client.getFirm_nm());
		ht.put("CLIENT_ID", client_id);
		ht.put("SEQ", 		site_id);
		ht.put("ITEM_DT",	AddUtil.getDate());
		ht.put("TAX_CNT",	"1");
		ht.put("TAX_YEAR",	AddUtil.getDate(1));
		ht.put("TAX_MON",	AddUtil.getDate(2));
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));
	
	if(String.valueOf(ht.get("USER_NM")).equals("null") || String.valueOf(ht.get("USER_NM")).equals("")){	
		ht.put("USER_NM",	taxer_bean.getUser_nm());
		ht.put("USER_H_TEL",	taxer_bean.getHot_tel());		
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));
	
	//차량이 1건일 때만 (통합발행은 담당자가 서로 상이하므로 담당자 노출 안함)
	
	String mng_nm = "";
	String mng_hp = "";
	
	String l_cd = String.valueOf(ht.get("RENT_L_CD"));
	
	if(!item_id.equals("")){
		l_cd = c_db.getTaxItemListRent_l_cd(item_id);
	}
	
	if ( !l_cd.equals("") ) {     
	    Hashtable ht1 = c_db.getDamdang(l_cd);	     
	    mng_nm = String.valueOf(ht1.get("USER_NM"));
		mng_hp = String.valueOf(ht1.get("HOT_TEL"));	
	}
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>거래명세서 메일링</title>
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
	font-weight: bold;
}
.button{
/*  	background-color: #8cb42c;  */
 	background-color: #78be20; 
	font-size: 14px;
	cursor: pointer;
	border-radius: 5px;
	color: #fff;
	border: 0;
	outline: 0;
	padding: 8px 10px;
	margin: 3px;
	text-decoration: none;
}
-->
</style>
<!-- <link href="http://fms1.amazoncar.co.kr/mailing/style.css" rel="stylesheet" type="text/css"> -->

</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align="center">
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0 >
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href="https://www.amazoncar.co.kr" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href="http://fms.amazoncar.co.kr/service/index.jsp" target="_blank" onFocus="this.blur();"><background=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
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
            <table width=677 border=0 cellspacing=0 cellpadding=0 style="background:url(https://fms5.amazoncar.co.kr/mailing/images/img_top_1.gif) no-repeat;">
                <tr>
                    <td width=436 valign=top>
                        <table width=436 border=0 cellspacing=0 cellpadding=0 height=309>
                            <tr>
                                <td width=35>&nbsp;</td>
                                <td align=center>
                                    <table width=401 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
				                  			<td height=20></td>
				                  		</tr>
                                        <tr>
                                            <td width=401 height=58 align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/doc_info_title.gif></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=401 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td width=31 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_left.gif width=11 height=67></td>
                                                        <td width=359>
                                                            <table width=359 border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=27 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/arrow.gif width=10 height=11> &nbsp;<span style="font-family:nanumgothic;font-size:13px;"><%=ht.get("NAME")%>&nbsp;님 </span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18 style="font-family:nanumgothic;font-size:13px;"><span style="color:#ff00ff;font-weight:bold;"><%=ht.get("TAX_MON")%>월</span> 거래명세서가 발행되었습니다.<br>
																	아래 "거래명세서 수신하기"  버튼을 누르시면 바로 확인가능합니다.</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=11><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_right.gif width=11 height=67></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="20">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=401 border=0 cellspacing=0 cellpadding=0>
                                                    <tr bgcolor=aea8b7>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr bgcolor=dfdde2>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=105 height=23 align=center bgcolor=efeef1><span style="font-family:nanumgothic;font-size:12px;">발급일자</span></td>
                                                        <td width=306 align=left>&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("ITEM_DT")%></span></td>
                                                    </tr>
                                                    <tr bgcolor=dfdde2>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=23 align=center bgcolor=efeef1><span style="font-family:nanumgothic;font-size:12px;">문서건수</span></td>
                                                        <td align=left>&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("TAX_CNT")%> 건</span></td>
                                                    </tr>
                                                    <tr bgcolor=dfdde2>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                    <tr bgcolor=aea8b7>
                                                        <td height=1 colspan=2></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=50 align=center valign=bottom>
                                            <%-- <a class="button" href="https://fms.amazoncar.co.kr/service/tax_index.jsp?client_id=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>&gubun=tax_item" target="_blank" onFocus="this.blur();">거래명세서 수신하기</a> --%>
                                            <a class="button" href="https://client.amazoncar.co.kr/clientIndex?clientId=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>&gubun=tax_item" target="_blank" onFocus="this.blur();">거래명세서 수신하기</a>
<%--                                             <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?client_id=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>&gubun=tax_item" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/button_receive_doc.gif width=174 height=34 border=0></a> --%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=30></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width=30>&nbsp;</td>
                    <td width=211 valign=top>
                        <table width=211 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                            	<td width=20>&nbsp;</td>
                                <td width=191>
                                    <table width=191 border=0 cellspacing=0 cellpadding=0>
                                      <tr>
				                        <td height=90 align=left></td>
				                      </tr>
     
                                      <tr>
                                        <td align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/sup_car.gif></td>
                                      </tr>
                                      <tr>
                                        <td height=5></td>
                                      </tr>
                                      <!-- 차량담당자 전화번호 -->
                                      <tr>
                                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic;font-size:13px;font-weight:bold;color:#ffffff;"><%=mng_nm%>&nbsp;&nbsp;<%=mng_hp%></span>
                                            <!--[$user_h_tel$]-->
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
                                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic;font-size:13px;font-weight:bold;color:#ffffff;"><%=ht.get("USER_NM")%>&nbsp;&nbsp;<%=ht.get("USER_H_TEL")%></span>
                                            <!--[$user_h_tel$]-->
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
                                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic;font-size:13px;font-weight:bold;color:#ffffff;">TEL. 02-392-4243 </span></td>
                                      </tr>
                                      <tr>
                                        <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic;font-size:13px;font-weight:bold;color:#ffffff;">FAX. 02-757-0803 </span></td>
                                      </tr>
                                      <tr>
                                        <td height=10></td>
                                      </tr>
                                      <!-- 담당자 전화번호 -->
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_02.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/doc_img_01.gif></td>
                            </tr>
							<tr>
								<td height=30></td>
							</tr>
							<tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_07.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=http://fms1.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                            <!-- 회계 담당자 연락처 -->
                                            <td width=608 align=left>
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=24><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> <span style="font-family:nanumgothic;font-size:13px;line-height:22px;">종이규격 세금계산서는 발행 및 사용이 불가합니다.<br>
	                                                    <img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> 기재사항정정은 발행일자기준 당월분에 한정합니다.<br>
	                                                    &nbsp;&nbsp; (기간을 경과한 세금계산서는 수정세금계산서로 추가발행 / 교부)<br>
                                                    	<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> 월합계세금계산서의 거래일자<br>
                                                    	&nbsp;&nbsp; 1. 매월(거래당월) 말일자<br>
														&nbsp;&nbsp; 2. 월간 마지막 거래일자<br>
														&nbsp;&nbsp; 3. 기타조건은 당사와 수용가능여부 사전협의<br>
                                                    	<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/dot.gif width=4 height=6> <span style="color: #f75802;font-weight:bold;">선 발행/교부(거래일자 도래이전 발행)는 불가</span>합니다.<br>
														&nbsp;&nbsp; (부가가치세법 제9조, 제16조 참조, 세금계산서 발행의 원천이라고 할 수 있는 관련 소프트웨어에 상기 법률이<br>&nbsp;&nbsp; 적용돼 있어 발행 자체가 불가능함)</span></td>
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_06.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=http://fms1.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                            <!-- 회계 담당자 연락처 -->
                                            <td width=608 align=left span style="font-family:nanumgothic;font-size:13px;line-height:22px;">날짜변경을 원하시면 반드시 <span style="color: #f75802;font-weight:bold;">회계담당자 <%=taxer_bean.getUser_nm()%></span> (<%=taxer_bean.getHot_tel()%>) 에게 연락주시기 바랍니다.</td>
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
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=http://fms1.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                            <!-- 회계 담당자 연락처 -->
                                            <td width=608 align=left style="font-family:nanumgothic;font-size:13px;line-height:22px;"><span style="color: #f75802;font-weight:bold;">고객 FMS</span>에 로그인하여 <span style="color: #f75802;font-weight:bold;">정보수정</span>에서 담당자를 직접 변경하시면 됩니다.</td>
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><background=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif style="font-family:nanumgothic;font-size:11px;">본 메일은 발신전용 메일이므로 궁금한 사항은 <a href=mailto:tax@amazoncar.co.kr><span style="font-size:11px;color:#af2f98;font-family:nanumgothic;">수신메일(tax@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</span></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><background=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=82><background=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><background=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
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