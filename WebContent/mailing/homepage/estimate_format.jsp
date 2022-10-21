<%@ page language="java" contentType="text/html;charset=euc-kr"%>

<%
	//request.setCharacterEncoding("utf-8");
	String url = request.getParameter("url")==null?"":java.net.URLDecoder.decode(request.getParameter("url"), "euc_kr");
	String title = request.getParameter("title")==null?"":request.getParameter("title");
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 견적서</title>
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
                    <td width=558><a href=http://www.amazoncar.co.kr target="_blank" onFocus="this.blur();"><img src="http://fms1.amazoncar.co.kr/mailing/images/logo.gif" width=332 height=52 border=0></a></td>
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
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top_est.gif></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>

    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>

    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/images/e_bg_fine.png>
                <tr>
                    <td width=20>&nbsp;</td>
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
                                <td height=24 align="left"><span style="font-family:nanumgothic;font-size:13px;">고객님께서 요청하신 견적서입니다.</span></td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                                <td height=18 align="left"><span style="font-family:nanumgothic;font-size:13px;line-height:20px;">견적내용 살펴보시고, 견적서보기에서 <span style="color:red;">견적클릭!</span>을 누르시면 해당 견적서가 보여집니다.<br>
                         		견적클릭 후 <span style="color:red;">차종(차량모델명)</span>을 누르시면 차량 상세사양정보가 보여집니다.<br>
                            	아마존카를 이용해 주셔서 진심으로 감사드리며, 궁금하신 사항이 있으시면 담당자에게 전화주시기 바랍니다.</span></td>
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
        <td align=center background=../images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td align="left">&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_est.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
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
                                <td bgcolor=f2f2f2 height=30 width=450 align=center><span style="font-family:nanumgothic;font-size:12px;">견적내용</span></td>
                                <td bgcolor=f2f2f2 align=center><span style="font-family:nanumgothic;font-size:12px;">견적서보기</span></td>
                            </tr>
                            <tr>
                            	<td bgcolor=ffffff align=center height=20><%=title%></td>
                            	
                            	<td bgcolor=ffffff align=center height=20><a href="<%=url%>">견적클릭!</a></td>
                            </tr>
                            <tr>
                            	<td></td>
                            	<td></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
         </td>
     </tr>
     <tr>
     	<td height=50 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
     </tr>
    <tr>
        <td height=20 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
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
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>    
</table>
</body>
</html>