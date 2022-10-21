<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type=text/css>

<!--

.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
select {
    width: 40%;
    padding: 4px 8px;
    border: 1px solid ;
    border-radius: 4px;
    background-color: #ffff;
	font-size: 1em;
}
</style>
<script language='javascript'>
<!--
var popObj = null;

	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}
	
//-->
</script>
</head>

<body leftmargin="15">
<div class="navigation">
	<span class=style1>인사관리 > 성희롱예방및교육 ></span><span class=style5></span>
</div>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><label><i class="fa fa-check-circle"></i> 예방교육 </label></td>
        <td align=right>&nbsp;</td>
    </tr>
    <tr>
    	<td class=line2 colspan=2></td>
   	</tr>
    <tr>
        <td class=line align=center colspan=2>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td class=title>연번</td>
                    <td class=title>교육년도</td>
                    <td class=title>교육내용</td>
                    <td class=title>비 고</td>
                </tr>
                <tr>
                	<td align=center>1</td>
                	<td align=center>2008년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2008.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2008년도 성희롱 교육</a></td>
                	<td align=center>본점 및 지점 개별교육</td>
             	</tr>
               	<tr>
                	<td align=center>2</td>
                	<td align=center>2009년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2009.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2009년도 성희롱 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
             	<tr>
                	<td align=center>3</td>
                	<td align=center>2010년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2010.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2010년도 성희롱 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
             	<tr>
                	<td align=center>4</td>
                	<td align=center>2011년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2011.zip','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2011년도 성희롱 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
             	<tr>
                	<td align=center>5</td>
                	<td align=center>2012년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2012.zip','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2012년도 성희롱 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
				<tr>
                	<td align=center>6</td>
                	<td align=center>2013년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2013.zip','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2013년도 성희롱 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
				<tr>
                	<td align=center>7</td>
                	<td align=center>2014년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2014.zip','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2014년도 성희롱 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
				<tr>
                	<td align=center>8</td>
                	<td align=center>2015년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2015.zip','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2015년도 성희롱 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
				<tr>
                	<td align=center>9</td>
                	<td align=center>2016년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2016.zip','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2016년도 성희롱 교육 / 개인정보보호 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
             	<tr>
                	<td align=center>10</td>
                	<td align=center>2017년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2017.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2017년도 성희롱 교육 / 개인정보보호 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
             	<tr>
                	<td align=center>11</td>
                	<td align=center>2018년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2018.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2018년도 성희롱 교육 / 개인정보보호 교육 / 장애인인식개선교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
             	<tr>
                	<td align=center>12</td>
                	<td align=center>2019년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2019.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2019년도 성희롱 교육 / 개인정보보호 교육 / 장애인인식개선교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
             	<tr>
                	<td align=center>13</td>
                	<td align=center>2020년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2020.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2020년도 성희롱 교육 / 개인정보보호 교육 / 장애인인식개선교육 / 직장내 괴롭힘 방지법 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
             	<tr>
                	<td align=center>14</td>
                	<td align=center>2021년</td>
                	<td align=center><a href="javascript:MM_openBrWindow('sprev_2021.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">2021년도 성희롱 교육 / 개인정보보호 교육 / 장애인인식개선교육 / 직장내 괴롭힘 방지법 교육</a></td>
                	<td align=center>워크샵 기간 중 전체교육</td>
             	</tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
