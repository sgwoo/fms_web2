<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		window.open(theURL,winName,features);
	}
	
//-->
</script>

 <STYLE>
<!--
P.HStyle0, LI.HStyle0, DIV.HStyle0
	{style-name:"바탕글"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle1, LI.HStyle1, DIV.HStyle1
	{style-name:"본문"; margin-left:15.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle2, LI.HStyle2, DIV.HStyle2
	{style-name:"개요 1"; margin-left:10.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle3, LI.HStyle3, DIV.HStyle3
	{style-name:"개요 2"; margin-left:20.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle4, LI.HStyle4, DIV.HStyle4
	{style-name:"개요 3"; margin-left:30.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle5, LI.HStyle5, DIV.HStyle5
	{style-name:"개요 4"; margin-left:40.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle6, LI.HStyle6, DIV.HStyle6
	{style-name:"개요 5"; margin-left:50.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle7, LI.HStyle7, DIV.HStyle7
	{style-name:"개요 6"; margin-left:60.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle8, LI.HStyle8, DIV.HStyle8
	{style-name:"개요 7"; margin-left:70.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle9, LI.HStyle9, DIV.HStyle9
	{style-name:"개요 8"; margin-left:80.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle10, LI.HStyle10, DIV.HStyle10
	{style-name:"개요 9"; margin-left:90.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle11, LI.HStyle11, DIV.HStyle11
	{style-name:"개요 10"; margin-left:100.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle12, LI.HStyle12, DIV.HStyle12
	{style-name:"쪽 번호"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:함초롬돋움; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle13, LI.HStyle13, DIV.HStyle13
	{style-name:"머리말"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:150%; font-size:9.0pt; font-family:함초롬돋움; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle14, LI.HStyle14, DIV.HStyle14
	{style-name:"각주"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle15, LI.HStyle15, DIV.HStyle15
	{style-name:"미주"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:함초롬바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle16, LI.HStyle16, DIV.HStyle16
	{style-name:"메모"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:left; text-indent:0.0pt; line-height:130%; font-size:9.0pt; font-family:함초롬돋움; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle17, LI.HStyle17, DIV.HStyle17
	{style-name:"차례 제목"; margin-left:0.0pt; margin-right:0.0pt; margin-top:12.0pt; margin-bottom:3.0pt; text-align:left; text-indent:0.0pt; line-height:160%; font-size:16.0pt; font-family:함초롬돋움; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#2e74b5;}
P.HStyle18, LI.HStyle18, DIV.HStyle18
	{style-name:"차례 1"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:7.0pt; text-align:left; text-indent:0.0pt; line-height:160%; font-size:11.0pt; font-family:함초롬돋움; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle19, LI.HStyle19, DIV.HStyle19
	{style-name:"차례 2"; margin-left:11.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:7.0pt; text-align:left; text-indent:0.0pt; line-height:160%; font-size:11.0pt; font-family:함초롬돋움; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle20, LI.HStyle20, DIV.HStyle20
	{style-name:"차례 3"; margin-left:22.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:7.0pt; text-align:left; text-indent:0.0pt; line-height:160%; font-size:11.0pt; font-family:함초롬돋움; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
-->
</STYLE>
</HEAD>


<body leftmargin="15">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 사규관리 > <span class=style5>주임종 단기차입금 운용방침</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    
     <tr>
        <td class=line align=center colspan=2>
            <table width=100% border=0 cellspacing=1 cellpadding=15>
                <tr>
                    <td align=center>
                        <table width=90% border=0 cellspacing=0 cellpadding=0>
                            <tr>    
                                <td></td>
                            </tr>
                            <tr>
                                <td>
            <div>
  
<P CLASS=HStyle0 STYLE='text-align:center;line-height:190%;'><SPAN STYLE='font-size:17.0pt;font-family:"바탕";font-weight:bold;text-decoration: underline;line-height:150%;'>주임종 단기차입금 운용방침</SPAN></P>

<P CLASS=HStyle0 STYLE='text-align:right;line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:150%;'>2021.12.15.</SPAN></P>

<P CLASS=HStyle0 STYLE='text-align:right;line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:150%;'>(2021.12.17. 수정)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:150%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"바탕";line-height:160%;'>1. 주임종 단기차입금 운용</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;1) 자금 용도 : 사업용자동차 구입대금 및 법인 운용자금</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;2) 이자 지급 시기 : 매년 12월31일 </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;3) 지급이자율 : 당좌대출이자율(국세청장이 정한 이자율)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※ 2021년 현재 이자율 : 4.6%&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:150%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"바탕";line-height:160%;'>2. 계좌개설</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;1) 방법 : 재무담당 임·직원과 사전협의 후 법인지정계좌에 입금 </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;2) 입금 한도 : 법인의 필요자금 범위 내</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;3) 계좌개설 시기 : 법인의 자금조달 시점</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:150%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"바탕";line-height:160%;'>3. 중도해지 및 만기</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;1) 중도해지</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;① 방법 : 재무담당 임·직원과 사전협의 후 시기 등 결정</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;② 시기 : 대주(주·임·종)의 필요시점(대규모 자금은 협의)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;③ 차입금반환 (인출)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1) 전액인출 : 원금 및 이자 일시상환</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2) 분할인출 : 원금의 일부 및 이자(분할 원금에 대한 이자)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;2) 만기 : 기말(12월31일)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;① 차입금반환 (인출)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1) 전액인출 : 원금 및 이자 일시상환</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2) 분할인출 : 원금의 일부 및 이자(차입금전액의 이자)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;② 계좌연장계약  : 전액 또는 일부의 원금을 이월(자동연장계약)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:150%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"바탕";line-height:160%;'>4. 운용 기간 : 별도의 종료 공지일까지</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"바탕";line-height:160%;'><BR></SPAN></P>

</div>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>