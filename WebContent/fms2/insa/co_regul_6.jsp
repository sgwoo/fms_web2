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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ��԰��� > <span class=style5>�λ��� ����ǥ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
        <td></td>
    </tr>
	<tr>
        <td align=right><img src=/acar/images/center/arrow.gif>  2019�� 04�� 12�� ����&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> <a href=co_regul_6_2016.jsp>2016�� 01�� 01��</a>&nbsp;</td>
    </tr>
    <tr>
        <td>
	        <span class=style2>�� �λ��򰡱���(�ܱ���) �Ϻ� �������</span><br><br>
	        <img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>&nbsp; �������� : ���(2019.04.12)</span>
       	</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line>
        	<table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10% rowspan="2">����</td>
            		<td class=title style=height:35 width=30% colspan="2">������(����/����)</td>
            		<td class=title style=height:35 width=30% colspan="2">������(����/����)</td>                 
                </tr>
            	<tr>
                    <td class=title style=height:35>�������</td>
                    <td class=title style=height:35>������</td>
                    <td class=title style=height:35>�������</td>
                    <td class=title style=height:35>������</td>
                </tr>
                <tr>
                	<td class=title style=height:35>ä��</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>30%</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>30%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>����</td>
                    <td style=height:35>80%</td>
                    <td style=height:35>30%</td>
                    <td style=height:35>80%</td>
                    <td style=height:35>30%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>����</td>
                    <td style=height:35>10%</td>
                    <td style=height:35>10%</td>
                    <td style=height:35>5%</td>
                    <td style=height:35>5%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>���</td>
                    <td style=height:35>10%</td>
                    <td style=height:35>15%</td>
                    <td style=height:35>5%</td>
                    <td style=height:35>15%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>�������</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>15%</td>
                    <td style=height:35>0%</td>
                    <td style=height:35>10%</td>
                </tr>
                <tr>
                	<td class=title style=height:35>������</td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>&nbsp;2015��</span>&nbsp;</td>
    </tr>  
   
    <tr>
        <td class=line2></td>
    </tr>  
    
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10% colspan=2>&nbsp;</td>
            		<td class=title style=height:35 width=12%>ä��</td>
                    <td class=title style=height:35 width=12%>����</td>  
                    <td class=title style=height:35 width=12%>����</td>
                    <td class=title style=height:35 width=12%>���</td>
                    <td class=title style=height:35 width=12%>����</td>
                    <td class=title style=height:35 width=12%>�������</td>       
                    <td class=title style=height:35 width=12%>��</td>                    
                </tr>
                <tr>
                	<td class=title  rowspan=2 width=7%>����</td>
                	<td class=title width=4%>&nbsp;����&nbsp;</td>
                	<td style=height:35>0%</td>
                	<td><font color=red>80%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%</td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>����</td>
                	<td style=height:35>0%</td>
                	<td><font color=red>80%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%<br>(������ ��)</td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title  rowspan=2>&nbsp;������&nbsp;</td>
                	<td class=title>����</td>
                	<td style=height:35><font color=red>30%</font></td>
                	<td><font color=red>30%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td>0%</td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>����</td>
                	<td style=height:35><font color=red>30%</font></td>
                	<td><font color=red>30%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td>0%<br>(������ ��)</td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title colspan=2>������</td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>&nbsp;2014��</span>&nbsp;</td>
    </tr>  
   
    <tr>
        <td class=line2></td>
    </tr>  
    
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10% colspan=2>&nbsp;</td>
            		<td class=title style=height:35 width=12%>ä��</td>
                    <td class=title style=height:35 width=12%>����</td>  
                    <td class=title style=height:35 width=12%>����</td>
                    <td class=title style=height:35 width=12%>���</td>
                    <td class=title style=height:35 width=12%>����</td>
                    <td class=title style=height:35 width=12%>�������</td>       
                    <td class=title style=height:35 width=12%>��</td>                    
                </tr>
                <tr>
                	<td class=title  rowspan=2 width=7%>����</td>
                	<td class=title width=4%>&nbsp;����&nbsp;</td>
                	<td style=height:35>0%</td>
                	<td><font color=red>80%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%</td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>����</td>
                	<td style=height:35>0%</td>
                	<td><font color=red>80%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%<br>(������ ��)</td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title  rowspan=2>&nbsp;������&nbsp;</td>
                	<td class=title>����</td>
                	<td style=height:35><font color=red>30%</font></td>
                	<td><font color=red>30%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td>0%</td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>����</td>
                	<td style=height:35><font color=red>30%</font></td>
                	<td><font color=red>30%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td>0%<br>(������ ��)</td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title colspan=2>������</td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>&nbsp;2013��</span>&nbsp;</td>
    </tr>  
   
    <tr>
        <td class=line2></td>
    </tr>  
    
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10% colspan=2>&nbsp;</td>
            		<td class=title style=height:35 width=12%>ä��</td>
                    <td class=title style=height:35 width=12%>����</td>  
                    <td class=title style=height:35 width=12%>����</td>
                    <td class=title style=height:35 width=12%>���</td>
                    <td class=title style=height:35 width=12%>����</td>
                    <td class=title style=height:35 width=12%>�������</td>       
                    <td class=title style=height:35 width=12%>��</td>                    
                </tr>
                <tr>
                	<td class=title  rowspan=2 width=7%>����</td>
                	<td class=title width=4%>&nbsp;����&nbsp;</td>
                	<td style=height:35><font color=red>10%</font></td>
                	<td><font color=red>60%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>����</td>
                	<td style=height:35><font color=red>10%</font></td>
                	<td><font color=red>60%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%<br>(������ ��)</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title  rowspan=2>&nbsp;������&nbsp;</td>
                	<td class=title>����</td>
                	<td style=height:35><font color=red>25%</font></td>
                	<td><font color=red>25%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>����</td>
                	<td style=height:35><font color=red>25%</font></td>
                	<td><font color=red>25%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><font color=red>10%<br>(������ ��)</font></td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title colspan=2>������</td>
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
    	<td>�� 2013�⵵���� �����忡 ���� �λ��򰡴� ����ȸ�ǿ��� �մϴ�.
 			   ��, ������ ������ ���⵵ ��� ������ �м��ϰ� ������� ������ ���մϴ�.
 		</td>
 	</tr>
             
   
      <tr>
        <td></td>
    </tr>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>&nbsp;2011�� ~ 2012��</span>&nbsp;</td>
    </tr>  
   
    <tr>
        <td class=line2></td>
    </tr>  
    
    <tr>
        <td class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title width=10%>&nbsp;</td>
            		<td class=title style=height:35 width=12%>ä��</td>
                    <td class=title style=height:35 width=12%>����</td>  
                    <td class=title style=height:35 width=12%>����</td>
                    <td class=title style=height:35 width=12%>���</td>
                    <td class=title style=height:35 width=12%>����</td>
                    <td class=title style=height:35 width=12%>�������</td>       
                    <td class=title style=height:35 width=12%>��</td>                    
                </tr>
                <tr>
                	<td class=title>����</td>
                	<td style=height:35><font color=red>20%</font></td>
                	<td><font color=red>50%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>10%</font></td>
                	<td>0%</td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>������</td>
                	<td style=height:35><font color=red>25%</font></td>
                	<td><font color=red>25%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><font color=red>10%</font></td>
                	<td><font color=red>15%</font></td>
                	<td><b>100%</b></td>
                </tr>
                <tr>
                	<td class=title>������</td>
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