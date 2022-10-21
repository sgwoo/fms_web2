<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<html>
<HEAD>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
//-->
</script>
<style>
.h_40 {
	height: 40px !important;
}
.h_50 {
	height: 50px !important;
}
</style>
</head>

<body leftmargin="15">
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>노사규정관리 > <span class=style5>최저임금관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td>
   			<table width=50% border=0 cellspacing=0 cellpadding=0>
                <tr>
                	<td align="right">매1월1일기준</td>
                </tr>
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                        	<tr>
                        		<td align="center" width="20%" rowspan="2" class="title">귀속년</td>
                        		<td align="center" colspan="3" class="title h_40">근로시간별 급여</td>
                        		<td align="center" width="20%" rowspan="2" class="title">인상율<br>(전년대비)</td>
                        	</tr>
                        	<tr>
                        		<td align="center" width="20%" class="title h_50">시급<br>(1시간)</td>
                        		<td align="center" width="20%" class="title h_50">일급<br>(8시간)</td>
                        		<td align="center" width="20%" class="title h_50">월급<br>(209시간)</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2023 년</td>
                        		<td align="right">9,620&nbsp;&nbsp;</td>
                        		<td align="right">76,960&nbsp;&nbsp;</td>
                        		<td align="right">2,010,580&nbsp;&nbsp;</td>
                        		<td align="center">5.0%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2022 년</td>
                        		<td align="right">9,160&nbsp;&nbsp;</td>
                        		<td align="right">73,280&nbsp;&nbsp;</td>
                        		<td align="right">1,914,440&nbsp;&nbsp;</td>
                        		<td align="center">4.8%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2021 년</td>
                        		<td align="right">8,720&nbsp;&nbsp;</td>
                        		<td align="right">69,760&nbsp;&nbsp;</td>
                        		<td align="right">1,822,480&nbsp;&nbsp;</td>
                        		<td align="center">1.5%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2020 년</td>
                        		<td align="right">8,590&nbsp;&nbsp;</td>
                        		<td align="right">68,720&nbsp;&nbsp;</td>
                        		<td align="right">1,795,310&nbsp;&nbsp;</td>
                        		<td align="center">2.9%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2019 년</td>
                        		<td align="right">8,350&nbsp;&nbsp;</td>
                        		<td align="right">66,800&nbsp;&nbsp;</td>
                        		<td align="right">1,745,150&nbsp;&nbsp;</td>
                        		<td align="center">10.9%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2018 년</td>
                        		<td align="right">7,530&nbsp;&nbsp;</td>
                        		<td align="right">60,240&nbsp;&nbsp;</td>
                        		<td align="right">1,573,770&nbsp;&nbsp;</td>
                        		<td align="center">16.4%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2017 년</td>
                        		<td align="right">6,470&nbsp;&nbsp;</td>
                        		<td align="right">51,760&nbsp;&nbsp;</td>
                        		<td align="right">1,352,230&nbsp;&nbsp;</td>
                        		<td align="center">7.3%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2016 년</td>
                        		<td align="right">6,030&nbsp;&nbsp;</td>
                        		<td align="right">48,240&nbsp;&nbsp;</td>
                        		<td align="right">1,260,270&nbsp;&nbsp;</td>
                        		<td align="center">8.1%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2015 년</td>
                        		<td align="right">5,580&nbsp;&nbsp;</td>
                        		<td align="right">44,640&nbsp;&nbsp;</td>
                        		<td align="right">1,166,220&nbsp;&nbsp;</td>
                        		<td align="center">7.1%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2014 년</td>
                        		<td align="right">5,210&nbsp;&nbsp;</td>
                        		<td align="right">41,680&nbsp;&nbsp;</td>
                        		<td align="right">1,088,890&nbsp;&nbsp;</td>
                        		<td align="center">7.2%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2013 년</td>
                        		<td align="right">4,860&nbsp;&nbsp;</td>
                        		<td align="right">38,880&nbsp;&nbsp;</td>
                        		<td align="right">1,015,740&nbsp;&nbsp;</td>
                        		<td align="center">6.1%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2012 년</td>
                        		<td align="right">4,580&nbsp;&nbsp;</td>
                        		<td align="right">36,640&nbsp;&nbsp;</td>
                        		<td align="right">957,220&nbsp;&nbsp;</td>
                        		<td align="center">6.0%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2011 년</td>
                        		<td align="right">4,320&nbsp;&nbsp;</td>
                        		<td align="right">34,560&nbsp;&nbsp;</td>
                        		<td align="right">902,880&nbsp;&nbsp;</td>
                        		<td align="center">5.1%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2010 년</td>
                        		<td align="right">4,110&nbsp;&nbsp;</td>
                        		<td align="right">32,880&nbsp;&nbsp;</td>
                        		<td align="right">858,990&nbsp;&nbsp;</td>
                        		<td align="center">2.8%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2009 년</td>
                        		<td align="right">4,000&nbsp;&nbsp;</td>
                        		<td align="right">32,000&nbsp;&nbsp;</td>
                        		<td align="right">836,000&nbsp;&nbsp;</td>
                        		<td align="center">6.1%</td>
                        	</tr>
                        	<tr>
                        		<td align="center" class="title h_40">2008 년</td>
                        		<td align="right">3,770&nbsp;&nbsp;</td>
                        		<td align="right">30,160&nbsp;&nbsp;</td>
                        		<td align="right">787,930&nbsp;&nbsp;</td>
                        		<td align="center"></td>
                        	</tr>
                            <!-- <tr>
                                <td align=center rowspan="4" class=title width=15%>2019년</td>
                                <td width=15% class=title>구분</td>
                                <td width=15% class=title>근로시간(기준)</td>
                                <td width=55% class=title>급여</td>
                            </tr>
                            <tr>
                            	<td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">8,350 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">66,800 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>월급</td>
                            	<td class=title>209시간</td>
                            	<td align="right">1,745,150 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2018년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">7,530 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">60,240 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2017년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">6,470 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">51,760 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2016년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">6,030 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">48,240 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2015년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">5,580 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">44,640 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2014년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">5,210 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">41,680 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2013년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,860 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">38,880 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2012년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,580 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">36,640 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2011년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,320 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">34,560 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2010년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,110 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">32,880 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2009년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,000 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">32,000 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2008년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">3,770 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">30,160 원&nbsp;&nbsp;</td>
                            </tr> -->
                        </table>
                    </td>
                </tr>
            </table>
    	</td>
    </tr>
    <!-- <tr>
    	<td>
   			<table width=50% border=0 cellspacing=0 cellpadding=0>
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan="4" class=title width=15%>2019년</td>
                                <td width=15% class=title>구분</td>
                                <td width=15% class=title>근로시간(기준)</td>
                                <td width=55% class=title>급여</td>
                            </tr>
                            <tr>
                            	<td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">8,350 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">66,800 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>월급</td>
                            	<td class=title>209시간</td>
                            	<td align="right">1,745,150 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2018년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">7,530 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">60,240 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2017년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">6,470 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">51,760 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2016년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">6,030 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">48,240 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2015년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">5,580 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">44,640 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2014년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">5,210 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">41,680 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2013년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,860 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">38,880 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2012년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,580 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">36,640 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2011년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,320 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">34,560 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2010년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,110 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">32,880 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2009년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">4,000 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">32,000 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=center rowspan="2" class=title>2008년</td>
                                <td class=title>시급</td>
                            	<td class=title>1시간</td>
                            	<td align="right">3,770 원&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                            	<td class=title>일급</td>
                            	<td class=title>8시간</td>
                            	<td align="right">30,160 원&nbsp;&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
    	</td>
    </tr> -->
    <!-- <tr>
        <td>    
            <table width=50% border=0 cellspacing=0 cellpadding=0>
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2018년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;7,530원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;60,240원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<tr>
                    <td class=h></td>
                </tr>
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2017년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;6,470원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;51,760원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<tr>
                    <td class=h></td>
                </tr>
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2016년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;6,030원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;48,240원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2015년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;5,580원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;44,640원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2014년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;5,210원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;41,680원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
               
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2013년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;4,860원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;38,880원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2012년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;4,580원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;36,640원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2011년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;4,320원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;34,560원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                
                 <tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2010년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;4,110원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;32,880원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2009년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;4,000원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;32,000원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
				<tr>
                    <td class=line2></td>
                </tr>
                <tr>                
                    <td class=line align=center>
                        <table width=100% border=0 cellspacing=1 cellpadding=0>
                            <tr>
                                <td align=center rowspan=2 class=title width=20%>2008년</td>
                                <td width=20% class=title>시급</td>
                                <td width=60%>&nbsp;&nbsp;3,770원</td>
                            </tr>
                            <tr>
                                <td class=title>일급</td>
                                <td>&nbsp;&nbsp;30,160원</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class=h></td>
                </tr>
                
               
            </table>
        </td>
    </tr> -->
    <!-- ************************** -->
    <!-- <tr>
    	<td></td>
    </tr> -->
    <!-- ************************** -->    
</table>
<!-- </table> -->
</body>
</html>