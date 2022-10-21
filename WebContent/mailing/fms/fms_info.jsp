<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, cust.member.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"002316":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"S105YNCL00040":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("고객FMS관리"));
	
	String r_client_id = String.valueOf(base.get("CLIENT_ID"));
	
		// 고객 fms id, pwd
	MemberBean  member = m_db.getMemberCase(r_client_id, "", "");
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 고객FMS서비스 이용안내</title>
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
<script language="JavaScript" type="text/JavaScript">
<!-- 
     function ViewLayer(){
        //만일 Pop라는 녀석이 닫혀있다면??
        if(document.getElementById("layer1").style.display=="none"){
           //열어주어라
           document.getElementById("layer1").style.display='inline'
        //그렇지 않은 모든 경우라면??
        }else{
           //닫아주어라
           document.getElementById("layer1").style.display='none'
        }
     }
	 function hidden(){
               document.all.layer1.style.display = "none";
			   }
			   
    function ViewLayer2(){
        if(document.getElementById("layer2").style.display=="none"){
           document.getElementById("layer2").style.display='inline'
        }else{
           document.getElementById("layer2").style.display='none'
        }
     }
	 function hidden2(){
               document.all.layer2.style.display = "none";
			   }
			   
	 function ViewLayer3(){
        if(document.getElementById("layer3").style.display=="none"){
           document.getElementById("layer3").style.display='inline'
        }else{
           document.getElementById("layer3").style.display='none'
        }
     }
	 function hidden3(){
               document.all.layer3.style.display = "none";
			   }
			   
	function ViewLayer4(){
        if(document.getElementById("layer4").style.display=="none"){
           document.getElementById("layer4").style.display='inline'
        }else{
           document.getElementById("layer4").style.display='none'
        }
     }
	 function hidden4(){
               document.all.layer4.style.display = "none";
			   }
			   
	function ViewLayer5(){
        if(document.getElementById("layer5").style.display=="none"){
           document.getElementById("layer5").style.display='inline'
        }else{
           document.getElementById("layer5").style.display='none'
        }
     }
	 function hidden5(){
               document.all.layer5.style.display = "none";
			   }
			   
	function ViewLayer6(){
        if(document.getElementById("layer6").style.display=="none"){
           document.getElementById("layer6").style.display='inline'
        }else{
           document.getElementById("layer6").style.display='none'
        }
     }
	 function hidden6(){
               document.all.layer6.style.display = "none";
			   }
			   
	function ViewLayer7(){
        if(document.getElementById("layer7").style.display=="none"){
           document.getElementById("layer7").style.display='inline'
        }else{
           document.getElementById("layer7").style.display='none'
        }
     }
	 function hidden7(){
               document.all.layer7.style.display = "none";
			   }
			   
	function ViewLayer8(){
        if(document.getElementById("layer8").style.display=="none"){
           document.getElementById("layer8").style.display='inline'
        }else{
           document.getElementById("layer8").style.display='none'
        }
     }
	 function hidden8(){
               document.all.layer8.style.display = "none";
			   }
			   
			   
			   
//-->			   
</script> 


<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
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
           			<td width=114 valign=baseline>&nbsp;<!--<a href='http://fms.amazoncar.co.kr/service/index.jsp?name=<%=member.getMember_id()%>&passwd=<%=member.getPwd()%>' target=_blank><img src=http://fms1.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                  
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
                                            <td height=50 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/info_title.gif></td>
                                        </tr>
                                   <!-- 업체명 -->
                                        <tr>
                                            <td height=25 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span class=style1><span class=style1><b><%=base.get("FIRM_NM")%></b></span>&nbsp;<span class=style2>님 귀하</span> </span></td>
                                        </tr>
                                   <!-- 업체명 -->
                                        <tr>
                                            <td height=10></td>
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
                                                                    <td height=18><span class=style2>저희 아마존카를 이용해 주시는 고객님께 진심으로 감사드립니다. </span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>저희는 고객님께 보다 나은 서비스를 제공하고자 지속적으로 프로그램</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>을 개발하고 있습니다. 고객전용 <b>FMS서비스</b>를 통해 고객님의 업무편의를 돕겠습니다. </span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=12>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 height=12></td>
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/bar_1.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                       <!-- FMS서비스란? -->
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
                                                        <td height=20 align=left><span class=style13><b>FMS(Fleet Management System)</b></span><span class=style2>는 저희 아마존카가 자체적으로 개발한 차량관리 토탈 솔루션으로 인터넷을 통해
                                                        실시간으로 고객님의 차량관리 정보확인 및 회계업무를 쉽게 처리하실 수 있도록 고안된 프로그램입니다.<br>
                                                        큰 의미로는 차량관리경영 시스템이지만, 당사 직원과 고객간의 커뮤니케이션을 대신할 수 있는 창구역할의 기능을
                                                        수행하게 될 것입니다.</span></td>
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
                      <!-- FMS서비스란? -->
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/bar_2.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                      <!-- FMS이용방법 -->
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
                                                	<!--
                                                    <tr>
                                                        <td height=20 align=left><img src=http://fms1.amazoncar.co.kr/mailing/fms/images/fms_img1_bar01.gif></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=7></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>메일 상단 오른쪽에 있는 <span class=style13><b>고객FMS로그인 버튼으로 접속</b></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=15></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left><img src=http://fms1.amazoncar.co.kr/mailing/fms/images/fms_img1_bar02.gif></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=7></td>
                                                    </tr>-->
                                                    <tr>
                                                        <td height=20 align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>아마존카 <span class=style13><b>홈페이지 접속</b></span> <a href=http://www.amazoncar.co.kr target=_blank>(www.amazoncar.co.kr)</a></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2><span class=style13><b>고객FMS 접속</b></span> (홈페이지 오른쪽 상단 또는 오른쪽 하단)</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=15></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 align=center><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/fms_img1.gif></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=15></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                      <!-- FMS이용방법 -->
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/bar_3.gif></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                       <!-- FMS제공내용 -->
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/fms_img3.gif usemap=#Map border=0></td>
                            </tr>
                            <map name="Map">
                                <area shape="rect" coords="472,462,595,488" href="https://fms5.amazoncar.co.kr/mailing/fms/cfms_con.html" target=_blank>
                            </map>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/bar_4.gif width=648 height=21></td>
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
                                                        <td height=20 align=left><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>궁금한 사항이 있으시면 아래의 연락처로 문의해 주시기 바랍니다. 감사합니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>문의처</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td align=left>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/tel.gif></td>
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=http://fms1.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=112><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.gif width=111 height=39></td>
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

<div id="layer1" style="position:absolute; left:255px; top:1800px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content1.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer2" style="position:absolute; left:198px; top:1930px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden2();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content2.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer3" style="position:absolute; left:155px; top:1800px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden3();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content3.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer4" style="position:absolute; left:255px; top:1920px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden4();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content4.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer5" style="position:absolute; left:198px; top:2080px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden5();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content5.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer6" style="position:absolute; left:155px; top:1963px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden6();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content6.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer7" style="position:absolute; left:255px; top:2155px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden7();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content7.png border=0></a></td>
    </tr>
</table>  
</div>

<div id="layer8" style="position:absolute; left:198px; top:1815Px; width:261px; height:70px; z-index:1; display:none;">
<table width="209" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><a href="javascript:hidden8();"><img src=https://fms5.amazoncar.co.kr/mailing/fms/images/cfms_content8.png border=0></a></td>
    </tr>
</table>  
</div>


</body>
</html>