<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<%
	String pack_id 	= request.getParameter("pack_id")==null?"":request.getParameter("pack_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String est_nm 	= request.getParameter("est_nm")==null?"고객":request.getParameter("est_nm");
	
	String memo = request.getParameter("memo")==null?"":request.getParameter("memo");	
	String mail_dyr_ggr = request.getParameter("mail_dyr_ggr")==null?"":request.getParameter("mail_dyr_ggr");	
	String mail_etc_ycr = request.getParameter("mail_etc_ycr")==null?"":request.getParameter("mail_etc_ycr");	
	String mail_dyr_bgs = request.getParameter("mail_dyr_bgs")==null?"":request.getParameter("mail_dyr_bgs");	
	String mail_etc_gtr = request.getParameter("mail_etc_gtr")==null?"":request.getParameter("mail_etc_gtr");	
	String mail_etc_hap = request.getParameter("mail_etc_hap")==null?"":request.getParameter("mail_etc_hap");	
	String mail_dyr_hap = request.getParameter("mail_dyr_hap")==null?"":request.getParameter("mail_dyr_hap");	
	String settle_mny = request.getParameter("settle_mny")==null?"":request.getParameter("settle_mny");	
	String card_fee = request.getParameter("card_fee")==null?"":request.getParameter("card_fee");	
	String kj_ggr = request.getParameter("kj_ggr")==null?"":request.getParameter("kj_ggr");	
	String kj_bgs = request.getParameter("kj_bgs")==null?"":request.getParameter("kj_bgs");	
	String good_mny = request.getParameter("good_mny")==null?"":request.getParameter("good_mny");	
	String card_per = request.getParameter("card_per")==null?"":request.getParameter("card_per");


	String rent_dt  = "";
	String est_talbe= "estimate";
	
	

	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 업무서식 안내서</title>
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
//New 로그인
	function getLogin2(member_id, pwd){	
		var w = 450;
		var h = 250;
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var SUBWIN="https://fms.amazoncar.co.kr/service/index.jsp?name="+member_id+"&passwd="+pwd;	
//		window.open(SUBWIN, "InfoUp", "left="+winl+", top="+wint+", width="+w+", height="+h+", scrollbars=yes");
		window.open(SUBWIN, "InfoUp1", "left=5, top=5, width=1240, height=760, scrollbars=yes, status=yes, menubar=yes, toolbar=yes, resizable=yes");		
		
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
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
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg_fine1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=35 align="left"><span class=style2><span class=style1><b><%=est_nm%> </b>님</span></span></td>
                    <td width=221 align="left"><span class=style10><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%=user_bean.getUser_nm()%>&nbsp;&nbsp;<%=user_bean.getUser_m_tel()%></span></td>
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
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td height=18 align="left"><span class=style2>대여료, 과태료, 면책금 등을 고객님의 요청에 따라서 신용카드 ARS 결제 시스템을 이용하여 대금결제를 다음과 같이 진행합니다.&nbsp;결제금액의 합계는 아래와 같으며, 아래 결제에 대한 자세한 안내는 <a href="https://fms.amazoncar.co.kr/service/index.jsp"><b><font color=red>고객 FMS</font></b></a>에서 확인 가능합니다.</span></td>
                            </tr>
                            <tr>
                                <td height=18 align="left"><br><span class=style2>언제나 아마존카를 이용해주셔서 감사드리며, 더 좋은 서비스로 보답하기 위해 노력하겠습니다.</span></td>
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
                <!-- 
                <tr>
                    <td align="left">&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_ars_detail.png></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                 -->
                <tr>
                	<td align=center>
                		<table width=648 border=0 cellspacing=0 cellpadding=0>
                			<tr>
                        		<td height=2 bgcolor=656e7f colspan=2></td>
                        	</tr>
                        </table>
      				</td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                            <tr>
                	<td class=title width=10% rowspan='8' bgcolor=f2f2f2 style="text-align:center;">정산<br>내역</td>
                	<td class=title width=10% rowspan='3' bgcolor=f2f2f2 style="text-align:center;">대여료</td>
                	<td class=title width=10% style="height:30px;text-align:center;" bgcolor=f2f2f2 >공급가</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='mail_dyr_ggr' size='20' value='<%=mail_dyr_ggr%>' class='text' style="text-align:right;" readonly></td>
                </tr> 
                 <tr>
                	<td class=title width=10% style="height:30px;text-align:center;" bgcolor=f2f2f2>부가세</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='mail_dyr_bgs' size='20' value='<%=mail_dyr_bgs%>' class='text' style="text-align:right;" readonly></td>
                </tr>  
                <tr>
                	<td class=title width=10% style="height:30px;text-align:center;" bgcolor=f2f2f2>소계</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='mail_dyr_hap' size='20' value='<%=mail_dyr_hap%>' class='text' style="text-align:right;" readonly></td>
                </tr> 
                <tr>
                	<td class=title width=10% rowspan='3' bgcolor=f2f2f2 style="text-align:center;">기타<br>(VAT<br>비과세)</td>
                	<td class=title width=10% style="height:30px;text-align:center;" bgcolor=f2f2f2>과태료 등</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='mail_etc_gtr' size='20' value='<%=mail_etc_gtr%>' class='text' style="text-align:right;" readonly></td>
                </tr>  
                <tr>
                	<td class=title width=10% style="height:30px;text-align:center;" bgcolor=f2f2f2>연체료</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='mail_etc_ycr' size='20' value='<%=mail_etc_ycr%>' class='text' style="text-align:right;" readonly></td>
                </tr> 
                <tr>
                	<td class=title width=10% style="height:30px;text-align:center;" bgcolor=f2f2f2>소계</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='mail_etc_hap' size='20' value='<%=mail_etc_hap%>' class='text' style="text-align:right;" readonly></td>
                </tr> 
                <tr>
                	<td class=title width=10% colspan='2' style="height:30px;text-align:center;" bgcolor=f2f2f2>합계</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='settle_mny' size='20' value='<%=settle_mny%>' class='text' style="text-align:right;" readonly></td>
                </tr> 
                <tr>
                	<td class=title width=10% colspan='2' style="height:30px;text-align:center;" bgcolor=f2f2f2>취급수수료</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='card_fee' size='20' value='<%=card_fee%>' class='text' style="text-align:right;" readonly>&nbsp;&nbsp;정산금 합계 x <%if(card_per.equals("")){%>3.2<%}else{%><%=card_per%><%}%>%</td>
                </tr>      
                 <tr>
                	<td class=title width=10% rowspan='4' bgcolor=f2f2f2 style="text-align:center;">결제<br>금액</td>
                </tr>           
                 <tr>
                	<td class=title width=10% colspan='2' style="height:30px;text-align:center;" bgcolor=f2f2f2>공급가</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='kj_ggr' size='20' value='<%=kj_ggr%>' class='text' style="text-align:right;" readonly>&nbsp;&nbsp;대여료(공급가)+기타+취급수수료</td>
                </tr>  
                 <tr>
                	<td class=title width=10% colspan='2' style="height:30px;text-align:center;" bgcolor=f2f2f2>부가세</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='kj_bgs' size='20' value='<%=kj_bgs%>' class='text' style="text-align:right;" readonly></td>
                </tr>       						
                 <tr>
                	<td class=title width=10% colspan='2' style="height:30px;text-align:center;" bgcolor=f2f2f2>합계</td>
                	<td bgcolor=ffffff>&nbsp;
                        <input type='text' name='good_mny' size='20' value='<%=good_mny%>' class='text' style="text-align:right;font-weight:bold;" readonly></td>
                </tr>  
                        </table>
                    </td>
                </tr>
                 
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td align="left">&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_memo.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=0 cellpadding=0>
                        	<tr>
                        		<td height=2 bgcolor=656e7f></td>
                        	</tr>
                            <tr>
                            	<td>
                            		<table width=648 border=0 cellspacing=0 cellpadding=20 bgcolor=f2f2f2>
                            			<tr>
                                			<td><span class=style1><%=memo%></span></td>
                                		</tr>
                                	</table>
                                </td>
                            </tr>
                            <tr>
                            	<td height=1 bgcolor=d6d6d6></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<tr>
					<td height=60></td>
				</tr>                
            </table>
        </td>
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
                    <td width=85><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
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