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
            		<!-- ���� FMS�α��� ��ư -->
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
                    			<td class="style1" valign=top height=30> <b><%=String.valueOf(base.get("FIRM_NM"))%></b> ������</td>
                    		</tr>
                    		<tr>
                    			<td height=30>��ü�뿩�� ���ι���� ������ ���� ����Ǿ����� �˷��帳�ϴ�.</td>
                    		</tr>
                    		<tr>
                    			<td height=40><b>1.</b> ��������: 2017�� 04�� 01��</td>
                    		</tr>
                    		<tr>
                    			<td height=30><b>2.</b> ���泻��</td>
                    		</tr>
                    		<tr>
                    			<td>
                    				<table width=520 border=0 cellpadding=3 cellspacing=1 bgcolor=cacaca  align=center>
                    					<tr>
                    						<th height=40 bgcolor=f2f2f2 width=14%>�̿���</th>
                    						<th bgcolor=f2f2f2 width=43%>���� (3�� 31�� ����)</th>
                    						<th bgcolor=f2f2f2 width=43%><span class="style2 style1">���� (4�� 1�� ����)</span></th>
                    					</tr>
                    					<tr bgcolor=#FFFFFF align=center>
                    						<td height=85>1��</td>
                    						<td>���� ȸ�� �뿩��� �ջ� û�� <br>�� CMS ����<br>(��, ���� ���� �� ���� ����)</td>
                    						<td>����� ����</td>
                    					</tr>
                    					<tr bgcolor=#FFFFFF align=center>
                    						<td height=85>1�� �̻�</td>
                    						<td>��ü�뿩�� �߻� ��� �ȳ� �� <br>����(���� ��) ����</td>
                    						<td>���� ȸ�� �뿩��� �ջ� û�� <br>�� CMS ���� <br>(��, ���� ���� �� ���� ����)</td>
                    					</tr>
                    				</table>
                    			</td>
                    		</tr>
                    		<tr>
                    			<td height=10></td>
                    		</tr>
                    		<tr>
                    			<td height=40><b>3.</b> ������(4�� 1��) ������ �߻��� ��ü�뿩�� ���� ����� ����� �����մϴ�.</td>
                    		</tr>
                    		<tr>
                    			<td height=50><b>4.</b> ���� ���Ŀ��� ���� ������� �����ϱ⸦ ���Ͻø�, ���� ȸ����(2017��  3��  00��) �������� �Ʒ� ����ڿ� ������ �ֽñ� �ٶ��ϴ�.</td>
                    		</tr>
                    		<tr>
                    			<td height=120><b>5.</b> �� ������ �������� ��ü ���ο� ������� �Ƹ���ī ��ǰ�� �̿��ϴ� ��� �������� �ϰ������� �߼��ϴ� �ȳ����Դϴ�.
                    			       ���� �̿����� ������ �뿩�� ��ü ���� �� ��ü �ݾ� Ȯ���� <b>������ FMS</b>(<a href="https://fms.amazoncar.co.kr/service/index.jsp" target="_blank">http://fms.amazoncar.co.kr/service/index.jsp</a>)���� 
                    			       ���� �Ͻ� �� ������, �Ʒ� ����ڸ� ���ؼ� �ȳ� ������ ���� �ֽ��ϴ�</td>
                    		</tr>
                    		<tr>
                    			<td height=50><span class="style1"><b>�� <%=String.valueOf(base.get("FIRM_NM"))%> �������� ������Դϴ�.</b></span><br>
									&nbsp;&nbsp;&nbsp;&nbsp;<b>��</b> ���� :  <b><%=String.valueOf(base.get("USER_NM"))%></b>  &nbsp;&nbsp;&nbsp;&nbsp; <b>��</b> ����ó : <b><%=String.valueOf(base.get("USER_M_TEL"))%></b> 
								</td>
							</tr>
							<tr>
								<td  height=120>������ FMS�� �����Ͻø� �޽��� �� ���� ����(����)�� �̿��� �Ƹ���ī �̿�� ���õ� ��� ������ �����ϰ� �ż��ϰ� 
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