<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, cust.member.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>


<%
	String pack_id 	= request.getParameter("pack_id")==null?"":request.getParameter("pack_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String est_nm 	= request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
	
	
	
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
		
 
	Vector fines = afm_db.getFinePreDemList2( pack_id );
	int fine_size = fines.size();

	String firm_nm = est_nm;	
	
	long tot_fine = 0;
	String bus_id2 = "";	
	String mng_id = "";
	
	for(int i = 0 ; i < fine_size ; i++){
			Hashtable ht = (Hashtable)fines.elementAt(i);			                    
			tot_fine += AddUtil.parseLong(String.valueOf(ht.get("PAID_AMT")));									 
			bus_id2 = String.valueOf(ht.get("BUS_ID2"));
			mng_id = String.valueOf(ht.get("MNG_ID"));
	}	
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(mng_id);		//	bus_id2	
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 선납과태료 청구서</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #63676a}
.style3 {color: #ff8004}
.style4 {color: #c09b33; font-weight: bold;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

<script language="JavaScript">
<!--	
//-->
</script>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_top_e1.gif height=60 style='font-size:14px'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <span class=style1><b></b></span></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35><span class=style2><span class=style1><b><%=firm_nm%> </b>님</span></span></td>
                    <td width=221><span class=style2><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%=b_user.getUser_nm()%>&nbsp;&nbsp;<%=b_user.getUser_m_tel()%></span></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine2.gif>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=636>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=24>
								  <span class=style2>결제하실 금액은 <span class=style3><b><%=AddUtil.parseDecimal(tot_fine)%></b></span> 원입니다.</span></td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>고객FMS 로그인 후 과태료 메뉴를 선택하시면 선납고지서를 확인/출력하실 수 있습니다.  </span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>증빙이 필요할 시 아래 영수증 발급기관을 참조하시고 해당 연락처로 요청하시면 영수증을 발급받으실 수 있습니다.</span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>청구서를 발송한 이후 계약자의 계좌에서 인출(CMS) 또는 계좌입금한 대금에서 우선처리됩니다.</span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>(단, 실사용자가 별도로 납부하는 방식을 택한 고객(당사에 사전요청)은 제외)</span></td>
                            </tr>
                         
                            <tr>
                                <td height=18><span class=style2>아마존카를 이용해 주셔서 진심으로 감사드리며, 궁금하신 사항이 있으시면 담당자에게 전화주시기 바랍니다.</span></td>
                            </tr>
                        </table>
                    </td>
                    <td width=20>&nbsp;</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine_dw.gif></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_3.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
<%	for(int i = 0 ; i < fine_size ; i++){
			Hashtable ht = (Hashtable)fines.elementAt(i);%>               
                
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                        
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>차량번호</span></td>
                                <td bgcolor=ffffff width=231>&nbsp;<span class=style2><%=ht.get("CAR_NO")%>&nbsp;<%=ht.get("RES_ST")%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>차종</span></td>
                                <td bgcolor=ffffff width=232>&nbsp;<span class=style2><%=ht.get("CAR_NM")%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>위반일시</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=ht.get("VIO_DT")%> </span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>위반내용</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=ht.get("VIO_CONT")%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>위반장소</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=Util.subData(String.valueOf(ht.get("VIO_PLA")), 15)%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>청구기관</span></td>
                                <td bgcolor=ffffff>
                                    <table width=100% border=0 cellspacing=0 cellpadding=5>
                                        <tr>
                                            <td><span class=style2><%=ht.get("GOV_NM")%></span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>선납일자</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=ht.get("PROXY_DT")%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>위반금액</span></span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style3><%=AddUtil.parseDecimal(String.valueOf(ht.get("PAID_AMT")))%> 원</span></td>
                            </tr>
<%if(!ht.get("FILE_NAME").equals("")){%>							
							<tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>고지서</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><a href="https://fms3.amazoncar.co.kr/data/fine/<%=ht.get("FILE_NAME")%><%=ht.get("FILE_TYPE")%>">보기</a></span></td>
<%}else{%>								
                                <td bgcolor=f2f2f2 width=90 align=center height=24><span class=style1>고지서</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2></td>
<%}%>
<%if(!ht.get("FILE_NAME2").equals("")){%>								
                                <td bgcolor=f2f2f2 width=90 align=center height=24><span class=style1>영수증</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><a href="https://fms3.amazoncar.co.kr/data/fine/<%=ht.get("FILE_NAME2")%><%=ht.get("FILE_TYPE2")%>">보기</a></td>
<%}else{%>								
								<td bgcolor=f2f2f2 width=90 align=center height=24><span class=style1>영수증</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2></td>
<%}%>
							</tr>

                        </table>
                    </td>
                </tr>
                <tr></tr><tr></tr><tr></tr>
<%	}%>             
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_6.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_img2.gif></td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_7.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_img4.gif></td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_5.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_img1.gif usemap=#map border=0></td>
                </tr>
                <map name="Map">
                    <area shape="rect" coords="565,148,643,168" href="http://fms1.amazoncar.co.kr/mailing/fms/fms_info.html" target=_blank>
                </map>
                
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style12>본 메일은 발신전용 메일이므로 궁금한 사항은 <a href=mailto:tax300@amazoncar.co.kr><span class=style14>수신메일(tax300@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</span></td>
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