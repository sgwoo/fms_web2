<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*,  acar.util.*, acar.common.*"%>

<%
	String client_id 	= request.getParameter("client_id")==null?"002316":request.getParameter("client_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
		//cont_view
	Hashtable base = c_db.getContViewCmsCase(client_id);
		
	
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>CMS������׾ȳ�</title>
<link href=http://fms1.amazoncar.co.kr/mailing/style.css rel=stylesheet type=text/css>
<style type="text/css">
<!--
td {line-height:22px; font-size:13px;}
.style1 {font-size:14px;}
.style2 {color:#FF0000;}

-->
</style>

</head>
<body topmargin=0 leftmargin=0 >
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=http://fms1.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- �� FMS�α��� ��ư -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=http://fms1.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=http://fms1.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellspacing=0 cellpadding=0 background="http://fms1.amazoncar.co.kr/mailing/images/cms_mod.jpg">
                <tr>
                    <td height=1000 align=center valign=top>
                    	<table width=520 border=0 cellspacing=0 cellpadding=0>
							<tr>
								<td height=160></td>
							</tr>
                    		<tr>
                    			<td class="style1" valign=top height=30> <b><%=String.valueOf(base.get("FIRM_NM"))%></b> ����</td>
                    		</tr>
                    		<tr>
                    			<td height=30>CMS ���� ��������� �־ �˷��帳�ϴ�.</td>
                    		</tr>
                    	
                    		<tr>
                    			<td height=10></td>
                    		</tr>
                    	
                    		<tr>
                    			<td height=120><b>.</b> ���� �̿����� ������ �뿩�ᰡ ��� �ý��ۺ������� ���ؼ�  10�� 25�� ����п� ���ؼ� 10�� 26�Ϸ� ������� �˷��帳�ϴ�.
                    			       ���� ������  �ſ� 25�� ������� �˷��帳�ϴ�.</td>
                    		</tr>
                    	
							</tr>
							<tr>
								<td  height=120>���� FMS�� �����Ͻø� �޽��� �� ���� ����(����)�� �̿��� �Ƹ���ī �̿�� ���õ� ��� ������ ���ϰ� �ż��ϰ� 
								ó���� �� �ֽ��ϴ�(������ ȸ������ ���� ����). <br>�� ������(����, ��������, �渮ȸ�� ��) ����ڿ� �ǽð����� ������ 
								���� �� �� �ְ�, <br>����� ���� ������ ���� �����Ե� �پ��� ���� �̿� �ٶ��ϴ�.</td>
							</tr>
						</table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
                    
    <tr>
        <td height=30 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <!--
    <tr>
        <td align=center background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=http://fms1.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style12>�� ������ �߽����� �����̹Ƿ� �ñ��� ������ <a href=mailto:tax@amazoncar.co.kr><span class=style14>���Ÿ���(tax@amazoncar.co.kr)</span></a>�� �����ֽñ� �ٶ��ϴ�.</span></td>
    </tr>
    <tr>
        <td height=20 background=http://fms1.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>-->
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
                    <td width=86><img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
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