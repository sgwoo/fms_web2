<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.user_mng.*, acar.estimate_mng.*"%>
<%
	String l_cd  =	 request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String m_id  =	 request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String s_cd  =	 request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id  =	 request.getParameter("c_id")==null?"":request.getParameter("c_id");
%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>아마존카 - 대차료 동의서 안내문 및 위임장 메일</title>
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
.button {background-color: #6d758c; font-size: 12px; cursor: pointer; border-radius: 2px; color: #fff; border: 0; outline: 0; padding: 5px 8px; margin: 3px;}
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
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
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
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top_no_title.png></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>

    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=20 style="padding:20px;line-height:25px;text-align:center;">
                    	<span style="font-size:15px;font-weight:500;">아마존카 대차료 동의서 안내문 및 위임장 링크 메일 입니다.<br/>아래 버튼을 클릭하시면 양식 확인 및  프린트 하실 수 있습니다.</span><Br/><br/>
                    	<!-- <input type="button" class="button" value="문서열기" onclick="javascript:go_doc_print();"><br/> -->
                    	<a href="http://fms1.amazoncar.co.kr/acar/res_stat/myaccid_doc_email.jsp?l_cd=<%=l_cd%>&m_id=<%=m_id%>&s_cd=<%=s_cd%>&c_id=<%=c_id%>" target="_blank">
                    		<input type="button" class="button" value="문서열기" style="background-color: #6d758c; font-size: 12px; cursor: pointer; border-radius: 2px; color: #fff; border: 0; outline: 0; padding: 5px 8px; margin: 3px;">
                    	</a>
                    	<br/>
                    </td>
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