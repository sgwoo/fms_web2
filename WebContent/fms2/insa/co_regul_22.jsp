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
	{style-name:"������"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle1, LI.HStyle1, DIV.HStyle1
	{style-name:"����"; margin-left:15.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle2, LI.HStyle2, DIV.HStyle2
	{style-name:"���� 1"; margin-left:10.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle3, LI.HStyle3, DIV.HStyle3
	{style-name:"���� 2"; margin-left:20.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle4, LI.HStyle4, DIV.HStyle4
	{style-name:"���� 3"; margin-left:30.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle5, LI.HStyle5, DIV.HStyle5
	{style-name:"���� 4"; margin-left:40.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle6, LI.HStyle6, DIV.HStyle6
	{style-name:"���� 5"; margin-left:50.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle7, LI.HStyle7, DIV.HStyle7
	{style-name:"���� 6"; margin-left:60.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle8, LI.HStyle8, DIV.HStyle8
	{style-name:"���� 7"; margin-left:70.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle9, LI.HStyle9, DIV.HStyle9
	{style-name:"���� 8"; margin-left:80.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle10, LI.HStyle10, DIV.HStyle10
	{style-name:"���� 9"; margin-left:90.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle11, LI.HStyle11, DIV.HStyle11
	{style-name:"���� 10"; margin-left:100.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle12, LI.HStyle12, DIV.HStyle12
	{style-name:"�� ��ȣ"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:160%; font-size:10.0pt; font-family:���ʷҵ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle13, LI.HStyle13, DIV.HStyle13
	{style-name:"�Ӹ���"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:0.0pt; line-height:150%; font-size:9.0pt; font-family:���ʷҵ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle14, LI.HStyle14, DIV.HStyle14
	{style-name:"����"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle15, LI.HStyle15, DIV.HStyle15
	{style-name:"����"; margin-left:13.1pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:justify; text-indent:-13.1pt; line-height:130%; font-size:9.0pt; font-family:���ʷҹ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle16, LI.HStyle16, DIV.HStyle16
	{style-name:"�޸�"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:0.0pt; text-align:left; text-indent:0.0pt; line-height:130%; font-size:9.0pt; font-family:���ʷҵ���; letter-spacing:0.5pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle17, LI.HStyle17, DIV.HStyle17
	{style-name:"���� ����"; margin-left:0.0pt; margin-right:0.0pt; margin-top:12.0pt; margin-bottom:3.0pt; text-align:left; text-indent:0.0pt; line-height:160%; font-size:16.0pt; font-family:���ʷҵ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#2e74b5;}
P.HStyle18, LI.HStyle18, DIV.HStyle18
	{style-name:"���� 1"; margin-left:0.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:7.0pt; text-align:left; text-indent:0.0pt; line-height:160%; font-size:11.0pt; font-family:���ʷҵ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle19, LI.HStyle19, DIV.HStyle19
	{style-name:"���� 2"; margin-left:11.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:7.0pt; text-align:left; text-indent:0.0pt; line-height:160%; font-size:11.0pt; font-family:���ʷҵ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
P.HStyle20, LI.HStyle20, DIV.HStyle20
	{style-name:"���� 3"; margin-left:22.0pt; margin-right:0.0pt; margin-top:0.0pt; margin-bottom:7.0pt; text-align:left; text-indent:0.0pt; line-height:160%; font-size:11.0pt; font-family:���ʷҵ���; letter-spacing:0.0pt; font-weight:"normal"; font-style:"normal"; color:#000000;}
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ��԰��� > <span class=style5>������ �ܱ����Ա� ����ħ</span></span></td>
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
  
<P CLASS=HStyle0 STYLE='text-align:center;line-height:190%;'><SPAN STYLE='font-size:17.0pt;font-family:"����";font-weight:bold;text-decoration: underline;line-height:150%;'>������ �ܱ����Ա� ����ħ</SPAN></P>

<P CLASS=HStyle0 STYLE='text-align:right;line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:150%;'>2021.12.15.</SPAN></P>

<P CLASS=HStyle0 STYLE='text-align:right;line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:150%;'>(2021.12.17. ����)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:150%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>1. ������ �ܱ����Ա� ���</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;1) �ڱ� �뵵 : ������ڵ��� ���Դ�� �� ���� ����ڱ�</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;2) ���� ���� �ñ� : �ų� 12��31�� </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;3) ���������� : ���´���������(����û���� ���� ������)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� 2021�� ���� ������ : 4.6%&nbsp; </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:150%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>2. ���°���</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;1) ��� : �繫��� �ӡ������� �������� �� �����������¿� �Ա� </SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;2) �Ա� �ѵ� : ������ �ʿ��ڱ� ���� ��</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;3) ���°��� �ñ� : ������ �ڱ����� ����</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:150%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>3. �ߵ����� �� ����</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;1) �ߵ�����</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ��� : �繫��� �ӡ������� �������� �� �ñ� �� ����</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �ñ� : ����(�֡��ӡ���)�� �ʿ����(��Ը� �ڱ��� ����)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ���Աݹ�ȯ (����)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1) �������� : ���� �� ���� �Ͻû�ȯ</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2) �������� : ������ �Ϻ� �� ����(���� ���ݿ� ���� ����)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;2) ���� : �⸻(12��31��)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ���Աݹ�ȯ (����)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1) �������� : ���� �� ���� �Ͻû�ȯ</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2) �������� : ������ �Ϻ� �� ����(���Ա������� ����)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ���¿�����  : ���� �Ǵ� �Ϻ��� ������ �̿�(�ڵ�������)</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:150%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:150%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"����";line-height:160%;'>4. ��� �Ⱓ : ������ ���� �����ϱ���</SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'><BR></SPAN></P>

<P CLASS=HStyle0 STYLE='line-height:160%;'><SPAN STYLE='font-size:10.0pt;font-family:"����";line-height:160%;'><BR></SPAN></P>

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