<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>

<%
	//20210420 미사용
	out.println("미사용 페이지 입니다.");
	if(1==1)return;

	//세금계산서 메일
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String gubun 		= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
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
	
	Hashtable ht = IssueDb.getTaxMailCase(gubun, reg_code, tax_no, client_id, site_id);	
	
	if(String.valueOf(ht.get("CLIENT_ID")).equals("null") || String.valueOf(ht.get("CLIENT_ID")).equals("")){
		ht = IssueDb.getTaxMailCase2(gubun, reg_code, tax_no, client_id, site_id);
	}
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(client_id, site_id);
	
	if(String.valueOf(ht.get("CLIENT_ID")).equals("null") || String.valueOf(ht.get("CLIENT_ID")).equals("")){
		ht.put("NAME", 		client.getFirm_nm());
		ht.put("CLIENT_ID", client_id);
		ht.put("SEQ", 		site_id);
		ht.put("REG_DT",	AddUtil.getDate());
		ht.put("TAX_CNT",	"1");
		ht.put("TAX_YEAR",	AddUtil.getDate(1));
		ht.put("TAX_MON",	AddUtil.getDate(2));		
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));

	if(String.valueOf(ht.get("USER_NM")).equals("null") || String.valueOf(ht.get("USER_NM")).equals("")){	
		String tax_user_id = nm_db.getWorkAuthUser("세금계산서담당자");
		UsersBean tax_user_bean = umd.getUsersBean(tax_user_id);
		
		ht.put("USER_NM",	tax_user_bean.getUser_nm());
		ht.put("USER_H_TEL",	tax_user_bean.getHot_tel());
	}
	
	//out.println(ht.get("USER_NM"));
	//out.println(ht.get("USER_H_TEL"));
	
	
	//차량이 1건일 때만 (통합발행은 담당자가 서로 상이하므로 담당자 노출 안함)
	
	String mng_nm = "";
	String mng_hp = "";
	
	String l_cd = "";
	l_cd = c_db.getTaxRent_l_cd(tax_no);
	
	if ( !l_cd.equals("") ) {
	     
	     Hashtable ht1 = c_db.getDamdang(l_cd);
	     
	     mng_nm = String.valueOf(ht1.get("USER_NM"));
		 mng_hp = String.valueOf(ht1.get("HOT_TEL"));
	
	}
		
%>

<html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>전자 세금계산서 메일링</title>
<style type="text/css">
<!--
.style1 {
	color: #747474;
	font-weight: bold;
	font-family:nanumgothic;
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
<!-- <link href="http://fms1.amazoncar.co.kr/mailing/style.css" rel="stylesheet" type="text/css"> -->

</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align="center">
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href="https://www.amazoncar.co.kr" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>           
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
        	<table width=677 border=0 cellspacing=0 cellpadding=0 style="background:url(http://fms1.amazoncar.co.kr/mailing/images/img_top_1.gif) no-repeat;">
          		<tr>
            		<td width=436 valign=top>
            			<table width=436 border=0 cellspacing=0 cellpadding=0 height=309>
                			<tr>
			                  	<td width=35>&nbsp;</td>
			                  	<td align=center width=401>
				                  	<table width=401 border=0 cellspacing=0 cellpadding=0 align=center>
				                  		<tr>
				                  			<td height=20></td>
				                  		</tr>
				                      	<tr>
				                        	<td width=401 align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_title.gif width=340 height=22></td>
				                      	</tr>
				                      	<tr>
				                  			<td height=15></td>
				                  		</tr>
				                      	<tr>
				                        	<td>
				                        		<table width=401 border=0 cellspacing=0 cellpadding=0>
						                            <tr>
						                              	<td width=31 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_left.gif width=11 height=67></td>
						                              	<td width=359>
						                              		<table width=359 border=0 cellspacing=0 cellpadding=0>
								                                  <tr>
								                                    <td height=27 align=left><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/arrow.gif width=10 height=11> &nbsp;<span style="font-family:nanumgothic;font-size:13px;"><b><%=ht.get("NAME")%></b>&nbsp;님 </span></td>
								                                  </tr>
								                                  <tr>
								                                    <td height=18 align=left style="font-family:nanumgothic;font-size:13px;"><span style="color:#ff00ff;font-weight:bold;"><%=ht.get("TAX_MON")%>월</span> 세금계산서가 발행되었습니다. <br>
								                                    아래 수신방법을 참고하셔서 수신하시기 바랍니다.</td>
								                                  </tr>
						                              		</table>
						                              	</td>
						                              	<td width=11><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/info_right.gif width=11 height=67></td>
						                            </tr>
				                        		</table>
				                        	</td>
					            		</tr>
					               		<tr>
					                   		<td height=25>&nbsp;</td>
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
						                              <td width=306 align=left>&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("REG_DT")%></span></td>
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
					                      	<%-- <td height=50 align=center valign=bottom><a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?client_id=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/button_receive.gif width=174 height=34 border=0></a></td> --%>
					                      	<td height=50 align=center valign=bottom><a href="https://client.amazoncar.co.kr/clientIndex?clientId=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/button_receive.gif width=174 height=34 border=0></a></td>
					                  	</tr>
					                 	<tr>
					                      	<td height=16></td>
					                  	</tr>
					                      <!--
					                      <tr>
					                        <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/ment.gif width=355 height=41></td>
					                      </tr>-->
                  					</table>
                  				</td>
			                </tr>
            			</table>
            		</td>
            		<td width=30>&nbsp;</td>
            		<td width=211 valign=top align=center>
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_03.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td  align=left><span style="font-family:nanumgothic;font-size:13px;line-height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 비밀번호는 &quot;고객 FMS&quot; 로그인 비밀번호를 입력하셔야 합니다.<br>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 처음 방문하시는 고객은 법인/개인사업자-사업자등록번호, 개인-주민등록번호를 입력하셔야 합니다.<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 입력하신 비밀번호가 일치하지 않을 경우에는 <span style="color: #f75802;">IT팀 02-392-4243</span> 또는 <span style="color: #f75802;">메일(<a href=mailto:dev@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">dev@amazoncar.co.kr</span></a>)</span>로<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 연락주시기 바랍니다. </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
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
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                            				<!-- 회계 담당자 연락처 -->
                                            <td align=left style="font-family:nanumgothic;font-size:12px;line-height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;<span style="color: #f75802;">고객 FMS</span>&quot;에 로그인하여 담당자를 직접 변경하거나 <span style="color: #f75802;">회계담당자 <%=ht.get("USER_H_TEL")%></span> 에게 연락주시기 바랍니다. </span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
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
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td align=left style="font-family:nanumgothic;font-size:13px;line-height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고객님께서 수신할 문서가 아니시면 <span style="color: #f75802;">메일(<a href=mailto:tax@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">tax@amazoncar.co.kr</span></a>)</span>로 연락주시기 바랍니다.</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
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
                            <!--
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
                                                        <td style="font-family:nanumgothic;font-size:13px;line-height:20px;">세금계산서의 교부라 함은 세금계산서를 발행하여 거래상대방에게 넘겨주는 것을 말하는 것으로, 
                                                        사업자가 부가가치세법 제 16조의 규정에 의한 세금계산서를 교부함에 있어, 그 거래시기에 별지 제 11호 세금계산서 양식
                                                        에 기재 사항을 기재하여 이를 e-mail에 의하여 전송하고 공급자와 공급받는 자가 각각 출력하여 보관하는 경
														우에는 세금계산서를 교부한 것으로 보는 것이고(서삼-1032, 2005.7.6), 단순히 이메일 형태로 보관하는 것은
														세금계산서의 교부에 해당하지 아니한다.</td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=25>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
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
                            </tr>-->
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif style="font-family:nanumgothic;font-size:11px;">본 메일은 발신전용 메일이므로 궁금한 사항은 <a href=mailto:tax@amazoncar.co.kr><span style="font-size:11px;color:#af2f98;font-family:nanumgothic;">수신메일(tax@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</span></td>
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
                    <td width=82><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
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