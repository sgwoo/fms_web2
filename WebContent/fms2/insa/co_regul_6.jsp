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
</head>

<body leftmargin="15">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 사규관리 > <span class=style5>인사평가 기준표</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
        <td></td>
    </tr>
	<tr>
        <td align=right><img src=/acar/images/center/arrow.gif>  2019년 04월 12일 현재&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> <a href=co_regul_6_2016.jsp>2016년 01월 01일</a>&nbsp;</td>
    </tr>
    <tr>
        <td>
	        <span class=style2>● 인사평가기준(외근직) 일부 변경시행</span><br><br>
	        <img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>&nbsp; 시행일자 : 즉시(2019.04.12)</span>
       	</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line>
        	<table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10% rowspan="2">구분</td>
            		<td class=title style=height:35 width=30% colspan="2">변경전(본사/지점)</td>
            		<td class=title style=height:35 width=30% colspan="2">변경후(본사/지점)</td>                 
                </tr>
            	<tr>
                    <td class=title style=height:35>영업담당</td>
                    <td class=title style=height:35>고객지원</td>
                    <td class=title style=height:35>영업담당</td>
                    <td class=title style=height:35>고객지원</td>
                </tr>
                <tr>
                	<td class=title style=height:35>채권</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>30%</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>30%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>영업</td>
                    <td style=height:35>80%</td>
                    <td style=height:35>30%</td>
                    <td style=height:35>80%</td>
                    <td style=height:35>30%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>제안</td>
                    <td style=height:35>10%</td>
                    <td style=height:35>10%</td>
                    <td style=height:35>5%</td>
                    <td style=height:35>5%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>비용</td>
                    <td style=height:35>10%</td>
                    <td style=height:35>15%</td>
                    <td style=height:35>5%</td>
                    <td style=height:35>15%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>관리대수</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>15%</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>10%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>팀장평가</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>10%</td>
                    <td style=height:35>10%</td>
                </tr>
            </table>
        </td>
    </tr>
	<!--
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>&nbsp;2015년</span>&nbsp;</td>
    </tr>  
   
    <tr>
        <td class=line2></td>
    </tr>  
    
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10% colspan=2>&nbsp;</td>
            		<td class=title style=height:35 width=12%>채권</td>
                    <td class=title style=height:35 width=12%>영업</td>  
                    <td class=title style=height:35 width=12%>제안</td>
                    <td class=title style=height:35 width=12%>비용</td>
                    <td class=title style=height:35 width=12%>팀장</td>
                    <td class=title style=height:35 width=12%>관리대수</td>       
                    <td class=title style=height:35 width=12%>계</td>                    
                </tr>
                <tr>
                	<td class=title  rowspan=2 width=7%>영업</td>
                	<td class=title width=4%>&nbsp;본사&nbsp;</td>
                	<td style=height:35>0%</td>
                	<td><font color=red>80%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%</td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>지점</td>
                	<td style=height:35>0%</td>
                	<td><font color=red>80%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%<br>(지점장 평가)</td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title  rowspan=2>&nbsp;고객지원&nbsp;</td>
                	<td class=title>본사</td>
                	<td style=height:35><font color=red>30%</font></td>
                	<td><font color=red>30%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td>0%</td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>지점</td>
                	<td style=height:35><font color=red>30%</font></td>
                	<td><font color=red>30%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td>0%<br>(지점장 평가)</td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title colspan=2>내근직</td>
                	<td style=height:35><font color=red>10%</font></td>
                	<td>0%</td>
                	<td><font color=red>10%</font></td>
                	<td>0%</td>
                	<td><font color=red>80%</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>&nbsp;2014년</span>&nbsp;</td>
    </tr>  
   
    <tr>
        <td class=line2></td>
    </tr>  
    
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10% colspan=2>&nbsp;</td>
            		<td class=title style=height:35 width=12%>채권</td>
                    <td class=title style=height:35 width=12%>영업</td>  
                    <td class=title style=height:35 width=12%>제안</td>
                    <td class=title style=height:35 width=12%>비용</td>
                    <td class=title style=height:35 width=12%>팀장</td>
                    <td class=title style=height:35 width=12%>관리대수</td>       
                    <td class=title style=height:35 width=12%>계</td>                    
                </tr>
                <tr>
                	<td class=title  rowspan=2 width=7%>영업</td>
                	<td class=title width=4%>&nbsp;본사&nbsp;</td>
                	<td style=height:35>0%</td>
                	<td><font color=red>80%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%</td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>지점</td>
                	<td style=height:35>0%</td>
                	<td><font color=red>80%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%<br>(지점장 평가)</td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title  rowspan=2>&nbsp;고객지원&nbsp;</td>
                	<td class=title>본사</td>
                	<td style=height:35><font color=red>30%</font></td>
                	<td><font color=red>30%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td>0%</td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>지점</td>
                	<td style=height:35><font color=red>30%</font></td>
                	<td><font color=red>30%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td>0%<br>(지점장 평가)</td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title colspan=2>내근직</td>
                	<td style=height:35><font color=red>10%</font></td>
                	<td>0%</td>
                	<td><font color=red>20%</font></td>
                	<td>0%</td>
                	<td><font color=red>70%</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td></td>
    </tr>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>&nbsp;2013년</span>&nbsp;</td>
    </tr>  
   
    <tr>
        <td class=line2></td>
    </tr>  
    
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10% colspan=2>&nbsp;</td>
            		<td class=title style=height:35 width=12%>채권</td>
                    <td class=title style=height:35 width=12%>영업</td>  
                    <td class=title style=height:35 width=12%>제안</td>
                    <td class=title style=height:35 width=12%>비용</td>
                    <td class=title style=height:35 width=12%>팀장</td>
                    <td class=title style=height:35 width=12%>관리대수</td>       
                    <td class=title style=height:35 width=12%>계</td>                    
                </tr>
                <tr>
                	<td class=title  rowspan=2 width=7%>영업</td>
                	<td class=title width=4%>&nbsp;본사&nbsp;</td>
                	<td style=height:35><font color=red>10%</font></td>
                	<td><font color=red>60%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>지점</td>
                	<td style=height:35><font color=red>10%</font></td>
                	<td><font color=red>60%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%<br>(지점장 평가)</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title  rowspan=2>&nbsp;고객지원&nbsp;</td>
                	<td class=title>본사</td>
                	<td style=height:35><font color=red>25%</font></td>
                	<td><font color=red>25%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>지점</td>
                	<td style=height:35><font color=red>25%</font></td>
                	<td><font color=red>25%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><font color=red>10%<br>(지점장 평가)</font></td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title colspan=2>내근직</td>
                	<td style=height:35><font color=red>10%</font></td>
                	<td>0%</td>
                	<td><font color=red>20%</font></td>
                	<td>0%</td>
                	<td><font color=red>70%</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td>※ 2013년도부터 지점장에 대한 인사평가는 팀장회의에서 합니다.
 			   즉, 본점과 지점의 전년도 대비 성과를 분석하고 지점운영의 내용을 평가합니다.
 		</td>
 	</tr>
             
   
      <tr>
        <td></td>
    </tr>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>&nbsp;2011년 ~ 2012년</span>&nbsp;</td>
    </tr>  
   
    <tr>
        <td class=line2></td>
    </tr>  
    
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10%>&nbsp;</td>
            		<td class=title style=height:35 width=12%>채권</td>
                    <td class=title style=height:35 width=12%>영업</td>  
                    <td class=title style=height:35 width=12%>제안</td>
                    <td class=title style=height:35 width=12%>비용</td>
                    <td class=title style=height:35 width=12%>팀장</td>
                    <td class=title style=height:35 width=12%>관리대수</td>       
                    <td class=title style=height:35 width=12%>계</td>                    
                </tr>
                <tr>
                	<td class=title>영업</td>
                	<td style=height:35><font color=red>20%</font></td>
                	<td><font color=red>50%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>고객지원</td>
                	<td style=height:35><font color=red>25%</font></td>
                	<td><font color=red>25%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>내근직</td>
                	<td style=height:35><font color=red>10%</font></td>
                	<td>0%</td>
                	<td><font color=red>20%</font></td>
                	<td>0%</td>
                	<td><font color=red>70%</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
            </table>
        </td>
    </tr> 
            -->
</table>
</body>
</html>