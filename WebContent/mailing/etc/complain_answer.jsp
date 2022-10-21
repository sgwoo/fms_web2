<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.complain.*"%>
<jsp:useBean id="bean" class="acar.complain.OpinionBean" scope="page"/>

<%
		
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	ComplainDatabase oad = ComplainDatabase.getInstance();
	
	//공지사항 한건 조회
	bean = oad.getComplainBean(seq);
	
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>안내문</title>
<link href=http://fms1.amazoncar.co.kr/acar/main_car_hp/common.css rel=stylesheet type=text/css>
<style type=text/css>
<!--
body{padding:0px; margin:0px;}
.style1 {color: #2e4168; font-weight: bold;}
.style2 {color: #636262}
.style10 {color: #0441da}
.style11 {
	color: #ff00ff;
	font-weight: bold;
}
.box table {width:100%;border:none; margin:0px; border-radius:10px; border-collapse: separate;
    border-spacing: 0;}
.box table td{ border:1px solid #96c2cb; border-radius:15px; padding:30px;}
img{border:0; margin:0px; padding:0px;}
-->
</style>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=http://fms1.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            <!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=http://fms1.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=http://fms1.amazoncar.co.kr/mailing/images/layout_top.gif></td>
    </tr>
    <tr>
        <td style="text-align:center;"  background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellpadding=0 cellspacing=0 style="text-align:center;" >
            	<tr>
            		<td height=50></td>
            	</tr>
                <tr>
                    <td align=center><img src=http://fms1.amazoncar.co.kr/mailing/etc/images/complain_img_01.jpg></td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=608 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=15></td>
                            </tr>
                            <tr>
                                <td align=center class="box">
                                    <table width=500>
                                        <tr>
                                            <th align=left height=28>&nbsp;&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/mailing/etc/images/complain_bar_01.jpg border=0></th>
										</tr>
                                        <tr>
                                        	<td style="font-family:'NanumGothic','Tahoma','verdana','Helvetica','Arial'; font-size:14px; line-height: 1.6em;">
                                        	 <%=bean.getContents().replaceAll("\r\n", "<br/>")%>
                                        	</td>
                                      	</tr>
                                       
                                    </table>
                                </td>
                            </tr>
                            <tr>
                            	<td height=50></td>
                          	</tr>
                            <tr>
                                <td align=center class="box">
                                    <table width=500 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <th align=left height=28>&nbsp;&nbsp;&nbsp;<img src=http://fms1.amazoncar.co.kr/mailing/etc/images/complain_bar_02.jpg border=0></th>
										</tr>
                                        <tr>
                                        	<td style="font-family:'NanumGothic','Tahoma','verdana','Helvetica','Arial'; font-size:14px; line-height: 1.6em;">
                                        		<%=bean.getAnswer().replaceAll("\r\n", "<br/>")%>
                                        	</td>
                                      	</tr>
                                       
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=50></td>
                </tr>
            </table> 
        </td>
    </tr>
    <tr>
        <td align=center background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=http://fms1.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=60 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif align=center style="font-family:'NanumGothic','Tahoma','verdana','Helvetica','Arial'; font-size:11px; line-height: 1.6em;">아마존카의 답변에 만족하셨나요? <br>★ 아직도 부족한 점이 있으시다면 아래 전화번호로 연락주십시요. 친절하게 해결해 드리도록 하겠습니다 ★</td>
    </tr>
    <tr>
        <td align=center background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=http://fms1.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=85><img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=http://fms1.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=http://fms1.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>