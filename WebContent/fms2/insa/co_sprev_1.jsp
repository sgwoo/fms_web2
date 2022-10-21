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
//-->
</script>
<STYLE>
<!--
P.HStyle0, LI.HStyle0, DIV.HStyle0
	{style-name:"바탕글"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle1, LI.HStyle1, DIV.HStyle1
	{style-name:"본문"; margin-left:15.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle2, LI.HStyle2, DIV.HStyle2
	{style-name:"개요 1"; margin-left:10.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle3, LI.HStyle3, DIV.HStyle3
	{style-name:"개요 2"; margin-left:20.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle4, LI.HStyle4, DIV.HStyle4
	{style-name:"개요 3"; margin-left:30.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle5, LI.HStyle5, DIV.HStyle5
	{style-name:"개요 4"; margin-left:40.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle6, LI.HStyle6, DIV.HStyle6
	{style-name:"개요 5"; margin-left:50.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle7, LI.HStyle7, DIV.HStyle7
	{style-name:"개요 6"; margin-left:60.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle8, LI.HStyle8, DIV.HStyle8
	{style-name:"개요 7"; margin-left:70.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:바탕; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle9, LI.HStyle9, DIV.HStyle9
	{style-name:"쪽 번호"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:굴림; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle10, LI.HStyle10, DIV.HStyle10
	{style-name:"머리말"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:150%; font-size:9.0pt; font-family:굴림; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle11, LI.HStyle11, DIV.HStyle11
	{style-name:"각주"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:바탕; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle12, LI.HStyle12, DIV.HStyle12
	{style-name:"미주"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:바탕; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle13, LI.HStyle13, DIV.HStyle13
	{style-name:"메모"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:9.0pt; font-family:굴림; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
-->
</STYLE>
</head>

<body leftmargin="15">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 성희롱예방및교육 > <span class=style5>관계법률</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>관계법률</span></td>
        <td align=right>&nbsp;</td>
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

<P CLASS=HStyle0><SPAN STYLE='font-family:"굴림";font-weight:"bold";'>『남녀고용평등과 일·가정 양립지원에 관한 법률, 시행령, 시행규칙』</span></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";font-weight:"bold";'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:150%;'><SPAN STYLE='font-size:11.0pt;font-family:"굴림";font-weight:"bold";line-height:150%;'>(1)</SPAN><SPAN STYLE='font-size:11.0pt;font-family:"굴림";font-weight:"bold";line-height:150%;'>『남녀고용평등과 일·가정 양립지원에 관한 법률』 중 직장내 성희롱 관련 내용</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:150%;'><SPAN STYLE='font-size:11.0pt;font-family:"굴림";font-weight:"bold";line-height:150%;'>&nbsp;[(타)일부개정 2010.6.4 법률 제10339호] </SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><BR></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;text-align:center;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";font-weight:"bold";'>제2절 직장 내 성희롱의 금지 및 예방 &lt;개정 2007.12.21&gt;</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:16.5pt;'><SPAN STYLE='font-family:"굴림";'>제12조(직장 내 성희롱의 금지) 사업주, 상급자 또는 근로자는 직장 내 성희롱을 하여서는 아니 된다. [전문개정 </SPAN><SPAN STYLE='font-family:"굴림";'>2007.12.21</SPAN><SPAN STYLE='font-family:"굴림";'>]<BR><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:16.5pt;'><SPAN STYLE='font-family:"굴림";'>제13조(직장 내 성희롱 예방 교육) <br>① 사업주는 직장 내 성희롱을 예방하고 근로자가 안전한 근로환경에서 일할 수 있는 여건을 조성하기 위하여 직장 내 성희롱의 예방을 위한 교육(이하 “성희롱 예방 교육”이라 한다)을 실시하여야 한다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>② 성희롱 예방 교육의 내용·방법 및 횟수 등에 관하여 필요한 사항은 대통령령으로 정한다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>[전문개정 </SPAN><SPAN STYLE='font-family:"굴림";'>2007.12.21</SPAN><SPAN STYLE='font-family:"굴림";'>]<BR><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:16.5pt;'><SPAN STYLE='font-family:"굴림";'>제13조의2(성희롱 예방 교육의 위탁)<br>① 사업주는 성희롱 예방 교육을 고용노동부장관이 지정하는 기관(이하 “성희롱 예방 교육기관”이라 한다)에 위탁하여 실시할 수 있다.&lt;개정 </SPAN><SPAN STYLE='font-family:"굴림";'>2010.6.4</SPAN><SPAN STYLE='font-family:"굴림";'>&gt;</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>② 성희롱 예방 교육기관은 고용노동부령으로 정하는 기관 중에서 지정하되, 고용노동부령으로 정하는 강사를 1명 이상 두어야 한다.&lt;개정 </SPAN><SPAN STYLE='font-family:"굴림";'>2010.6.4</SPAN><SPAN STYLE='font-family:"굴림";'>&gt;</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>③ 성희롱 예방 교육기관은 고용노동부령으로 정하는 바에 따라 교육을 실시하고 교육이수증이나 이수자 명단 등 교육 실시 관련 자료를 보관하며 사업주나 피교육자에게 그 자료를 내주어야 한다.&lt;개정 </SPAN><SPAN STYLE='font-family:"굴림";'>2010.6.4</SPAN><SPAN STYLE='font-family:"굴림";'>&gt;</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>④ 고용노동부장관은 성희롱 예방 교육기관이 다음 각 호의 어느 하나에 해당하면 그 지정을 취소할 수 있다.&lt;개정 </SPAN><SPAN STYLE='font-family:"굴림";'>2010.6.4</SPAN><SPAN STYLE='font-family:"굴림";'>&gt;</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>1. 거짓이나 그 밖의 부정한 방법으로 지정을 받은 경우</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>2. 정당한 사유 없이 제2항에 따른 강사를 6개월 이상 계속하여 두지 아니한 경우</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>[전문개정 </SPAN><SPAN STYLE='font-family:"굴림";'>2007.12.21</SPAN><SPAN STYLE='font-family:"굴림";'>]<BR><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:16.5pt;'><SPAN STYLE='font-family:"굴림";'>제14조(직장 내 성희롱 발생 시 조치)<br>① 사업주는 직장 내 성희롱 발생이 확인된 경우 지체 없이 행위자에 대하여 징계나 그 밖에 이에 준하는 조치를 하여야 한다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>② 사업주는 직장 내 성희롱과 관련하여 피해를 입은 근로자 또는 성희롱 피해 발생을 주장하는 근로자에게 해고나 그 밖의 불리한 조치를 하여서는 아니 된다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>[전문개정 </SPAN><SPAN STYLE='font-family:"굴림";'>2007.12.21</SPAN><SPAN STYLE='font-family:"굴림";'>]<BR><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:16.5pt;'><SPAN STYLE='font-family:"굴림";'>제14조의2(고객 등에 의한 성희롱 방지)<br>① 사업주는 고객 등 업무와 밀접한 관련이 있는 자가 업무수행 과정에서 성적인 언동 등을 통하여 근로자에게 성적 굴욕감 또는 혐오감 등을 느끼게 하여 해당 근로자가 그로 인한 고충 해소를 요청할 경우 근무 장소 변경, 배치전환 등 가능한 조치를 취하도록 노력하여야 한다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>② 사업주는 근로자가 제1항에 따른 피해를 주장하거나 고객 등으로부터의 성적 요구 등에 불응한 것을 이유로 해고나 그 밖의 불이익한 조치를 하여서는 아니 된다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'>[본조신설 </SPAN><SPAN STYLE='font-family:"굴림";'>2007.12.21</SPAN></A><SPAN STYLE='font-family:"굴림";'>]</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.0pt;'><SPAN STYLE='font-family:"굴림";'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:150%;'><SPAN STYLE='font-size:11.0pt;font-family:"굴림";font-weight:"bold";line-height:150%;'>(2)</SPAN><SPAN STYLE='font-size:11.0pt;font-family:"굴림";font-weight:"bold";line-height:150%;'>『남녀고용평등과 일·가정 양립지원에 관한 법률 시행령』 중 성희롱 관련 내용</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:150%;'><SPAN STYLE='font-size:11.0pt;font-family:"굴림";font-weight:"bold";line-height:150%;'>[(타)타법개정 2010.7.12 대통령령 제22269호]</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;text-align:center;line-height:220%;'><SPAN STYLE='font-family:"굴림";'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;text-align:center;line-height:15.4pt;'><SPAN STYLE='font-family:"굴림";font-weight:"bold";'>제2장 고용에 있어서 남녀의 평등한 기회보장 및 대우 등</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.4pt;'><SPAN STYLE='font-family:"굴림";'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>제3조(직장 내 성희롱 예방 교육)</SPAN></p>
<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>① 사업주는 법 제13조에 따라 직장 내 성희롱 예방을 위한 교육을 연 1회 이상 하여야 한다 .</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>② 제1항에 따른 예방 교육에는 다음 각 호의 내용이 포함되어야 한다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>1. 직장 내 성희롱에 관한 법령</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>2. 해당 사업장의 직장 내 성희롱 발생 시의 처리 절차와 조치 기준</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>3. 해당 사업장의 직장 내 성희롱 피해 근로자의 고충상담 및 구제 절차</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>4. 그 밖에 직장 내 성희롱 예방에 필요한 사항</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>③ 제1항에 따른 예방 교육은 사업의 규모나 특성 등을 고려하여 직원연수ㆍ조회ㆍ회의, 인터넷 등 정보통신망을 이용한 사이버 교육 등을 통하여 실시할 수 있다. 다만, 단순히 교육자료 등을 배포ㆍ게시하거나 전자우편을 보내거나 게시판에 공지하는 데 그치는 등 근로자에게 교육 내용이 제대로 전달되었는지 확인하기 곤란한 경우에는 예방 교육을 한 것으로 보지 아니한다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>④ 제2항 및 제3항에도 불구하고 다음 각 호의 어느 하나에 해당하는 사업의 사업주는 제2항제1호부터 제4호까지의 내용을 근로자가 알 수 있도록 홍보물을 게시하거나 배포하는 방법으로 직장 내 성희롱 예방 교육을 할 수 있다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>1. 상시 10명 미만의 근로자를 고용하는 사업</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-left:8.0pt;margin-bottom:4.0pt;text-indent:-8.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>2. 사업주 및 근로자 모두가 남성 또는 여성 중 어느 한 성(性)으로 구성된 사업</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>⑤ 사업주가 소속 근로자에게 </SPAN><SPAN STYLE='font-family:"굴림";'>「근로자직업능력 개발법」 제24조</SPAN></A><SPAN STYLE='font-family:"굴림";'>에 따라 인정받은 훈련과정 중 제2항 각 호의 내용이 포함되어 있는 훈련과정을 수료하게 한 경우에는 그 훈련과정을 마친 근로자에게는 제1항에 따른 예방 교육을 한 것으로 본다.</SPAN><BR><BR></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:150%;'><SPAN STYLE='font-size:11.0pt;font-family:"굴림";letter-spacing:0.2pt;font-weight:"bold";line-height:150%;'>(3)</SPAN><SPAN STYLE='font-size:11.0pt;font-family:"굴림";letter-spacing:0.2pt;font-weight:"bold";line-height:150%;'>『남녀고용평등과 일·가정 양립지원에 관한 법률 </SPAN><SPAN STYLE='font-size:11.0pt;font-family:"굴림";letter-spacing:0.2pt;font-weight:"bold";line-height:150%;'>시행규칙</SPAN><SPAN STYLE='font-size:11.0pt;font-family:"굴림";letter-spacing:0.2pt;font-weight:"bold";line-height:150%;'>』 중 성희롱 관련 내용</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:150%;'><SPAN STYLE='font-size:11.0pt;font-family:"굴림";font-weight:"bold";line-height:150%;'>[일부개정 2010.7.12 고용노동부령 제1호]</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;text-align:center;line-height:120%;'><SPAN STYLE='font-family:"굴림";'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:15.6pt;'><SPAN STYLE='font-family:"굴림";'>제2조(직장 내 성희롱 판단기준의 예시) </SPAN><SPAN STYLE='font-family:"굴림";'>「남녀고용평등과 일·가정 양립 지원에 관한 법률」</SPAN><SPAN STYLE='font-family:"굴림";'>(이하 &quot;법&quot;이라 한다) 제2조제2호에 따른 직장 내 성희롱을 판단하기 위한 기준의 예시는 별표 1과 같다.</SPAN><BR><BR></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:16.0pt;'><SPAN STYLE='font-family:"굴림";'>제9조(직장 내 성희롱을 한 자에 대한 징계 등) 사업주는 법 제14조제1항에 따라 직장 내 성희롱을 한 자에 대한 징계나 그 밖에 이에 준하는 조치를 하는 경우에는 성희롱의 정도 및 지속성 등을 고려하여야 한다.</SPAN></P>

<P CLASS=HStyle0 STYLE='margin-bottom:4.0pt;line-height:16.0pt;'><SPAN STYLE='font-family:"굴림";'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";color:#339900;'>남녀고용평등과 일·가정 양립 지원에 관한 법률 시행규칙</SPAN><SPAN STYLE='font-family:"굴림";'> [별표 1] </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>[별표 1]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;직장 내 성희롱을 판단하기 위한 기준의 예시(제2조 관련)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;1. 성적인 언동의 예시&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;가. 육체적 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1) 입맞춤, 포옹 또는 뒤에서 껴안는 등의 신체적 접촉행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2) 가슴·엉덩이 등 특정 신체부위를 만지는 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(3) 안마나 애무를 강요하는 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;나. 언어적 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1) 음란한 농담을 하거나 음탕하고 상스러운 이야기를 하는 행위(전화통화를 포함한다)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2) 외모에 대한 성적인 비유나 평가를 하는 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(3) 성적인 사실 관계를 묻거나 성적인 내용의 정보를 의도적으로 퍼뜨리는 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(4) 성적인 관계를 강요하거나 회유하는 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(5) 회식자리 등에서 무리하게 옆에 앉혀 술을 따르도록 강요하는 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;다. 시각적 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1) 음란한 사진·그림·낙서·출판물 등을 게시하거나 보여주는 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(컴퓨터통신이나 팩시밀리 등을 이용하는 경우를 포함한다)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2) 성과 관련된 자신의 특정 신체부위를 고의적으로 노출하거나 만지는 행위&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;라. 그 밖에 사회통념상 성적 굴욕감 또는 혐오감을 느끼게 하는 것으로 인정되는 언어나 행동&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN><BR><BR></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;2. 고용에서 불이익을 주는 것의 예시&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;채용탈락, 감봉, 승진탈락, 전직(轉職), 정직(停職), 휴직, 해고 등과 같이 채용 또는 근로조건을 일방적으로 불리하게 하는 것&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;비고: 성희롱 여부를 판단하는 때에는 피해자의 주관적 사정을 고려하되, 사회통념상 합리적인 사람이 피해자의 입장이라면 문제가 되는 행동에 대하여</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;어떻게 판단하고 대응하였을 것인가를 함께 고려하여야 하며, 결과적으로 위협적·적대적인 고용환경을 형성하여 업무능률을 떨어뜨리게 되는지를</SPAN></P>
<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-family:"굴림";'>&nbsp;&nbsp;검토하여야 한다.</SPAN></P>

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