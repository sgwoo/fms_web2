<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%

String user_id  = request.getParameter("user_id")==null?"":request.getParameter("user_id");
//System.out.println(user_id);

MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function test(idx) {
		
		var open_link = "";
	
		if (idx == 0) {
			open_link = "https://fms3.amazoncar.co.kr/data/doc/" + encodeURIComponent("����������������") + ".pdf";
		} else if (idx == 1) {
			open_link = "https://fms3.amazoncar.co.kr/data/doc/" + encodeURIComponent("����Ư�����ѹ�") + ".pdf";
		}
		
		window.open(open_link);
	}
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ��԰��� > <span class=style5>�ŷ� ������ �ſ�ī�� ���� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
     
	<tr>
        <td colspan=2></td>
    </tr>
	<tr>
        <td>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ŷ� ������ �ſ�ī�� ���� ���� / ���� ����</span></td>
        <td align=right>&nbsp;(2019-10-24, 2022-05-31 ����)</td>
    </tr>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>  
    
    <tr>
        <td  colspan=2 class=line>
            <table width=100%  border=0 cellspacing=1 cellpadding=0 style="text-align:center">
            	<tr>
            		<td class=title style=height:35 width=15%>����</td>
                    <td class=title width=20%>�ſ�ī��ŷ� ���� ����</td>  
                    <td class=title width=20%>CMS�������ξ� ȯ�Դ�� ����</td>
                    <td class=title>����</td>                     
                </tr>
                <tr>
                	<td class=title>�� �뿩��</td>
                	<td style=height:35>����</td>
                	<td>ȯ�Դ��</td>
                	<td>&nbsp;</td>
				</tr>
				<tr>
                	<td class=title>�ʰ����� �뿩��</td>
                	<td style=height:35>����</td>
                	<td>ȯ�Դ��</td>
                	<td>&nbsp;</td>
				</tr>
				<tr>
                	<td class=title>���ô뿩��</td>
                	<td style=height:35>����</td>
                	<td>ȯ�Դ��</td>
                	<td>&nbsp;</td>
				</tr>
				<tr>
                	<td class=title>������</td>
                	<td style=height:35>����</td>
                	<td>ȯ�Դ��</td>
                	<td>&nbsp;</td>
				</tr>
				<tr>
                	<td class=title>��å��</td>
                	<td style=height:35>�Ұ�</td>
                	<td>��� �ƴ�</td>
                	<td style="text-align:left;">&nbsp;��ǰ�ŷ� �Ǵ� �뿪�� �밡�� �ƴմϴ�.</td>
				</tr>
				<tr>
                	<td class=title>������</td>
                	<td style=height:35>�Ұ�</td>
                	<td>��� �ƴ�</td>
                	<td style="text-align:left;">&nbsp;����Ư�����ѹ� �� ���������������� ����</td>
				</tr>
				<tr>
                	<td class=title>�����</td>
                	<td style=height:35>�Ұ�</td>
                	<td>��� �ƴ�</td>
                	<td style="text-align:left;">&nbsp;����Ư�����ѹ� �� ���������������� ����</td>
				</tr>
                
            </table>
        </td>
    </tr>
    <tr>
        <td colspan=2></td>
    </tr>
	
    <tr>
    	<td>�� ��� �ſ�ī��ŷ� ���� ���� ������ ����Ư�����ѹ� �� ���������������� � �ٰ��Ͽ� �ŷ���� ������������ ��� ���� ���θ� �����Ͽ����ϴ�.</td>
 	</tr>
	<tr>
        <td style="height:20;"></td>
    </tr>
    <tr>
    	<td>�� ���� ��� �����鿡�� ��� ��û�� �� ���� �� �ڸ����� ��ȣ�ϰ� �ź����� ���� ���� ��Ȳ�� �� ���캸�� �ѹ������ �����Ͽ� �����Ͻñ� �ٶ��ϴ�.</td>
 	</tr> 
	<tr>
        <td style="height:20;"></td>
    </tr>
	<tr>
    	<td>�� ���� �ŷ������ �ſ�ī��� ������ ��û�ϴ� �����δ� ī��� ������ ����Ʈ ��� �������꿡�� �ſ�ī��ҵ������ Ȱ���� ������ ��κ��� ���Դϴ�.<br>&nbsp;&nbsp;&nbsp;
    	         �������δ� ������� �ſ� �Ǵ� �繫���¿� ������ �߻����� �� �ִٴ� ��ȣ�� ���� �ֽ��ϴ�. ���� ���� ����ϸ鼭 ���� �������� �ֽ��Ͽ� �����ؾ߸� �� ���Դϴ�.
        </td>
 	</tr>
	<tr>
        <td style="height:20;"></td>
    </tr>
	<tr>
    	<td>�� �ڵ��� ���Ժ�� �� �ڵ��� ������ �� �뿩��� �ҵ���� ���ܴ���Դϴ�. ��, �߰����� �ſ�ī�� ������ ������ ��� ���Աݾ��� 10%�� �ҵ���� <br>&nbsp;&nbsp;&nbsp; ��� ���Ե˴ϴ�  (�����ٰ� : ����Ư�����ѹ� �� �����Ģ ����)</td>
 	</tr> 
	<tr>
        <td style="height:35;"></td>
    </tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp; ��<span class=style5>����������������</span>�� <a href="https://fms3.amazoncar.co.kr/data/doc/����������������.pdf" target=_blank><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;��<span class=style5>����Ư�����ѹ� �� �����Ģ</span>�� <a href="https://fms3.amazoncar.co.kr/data/doc/����Ư�����ѹ�.pdf" target=_blank><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>
		</td>
	</tr>
	<tr>
        <td style="height:35;"></td>
    </tr>
	<tr>
		<td>�� ���ù� PDF������ �Ϻ� ���������� �� �������� �ֽ��ϴ�. <a href=https://helpx.adobe.com/kr/acrobat/kb/cant-view-pdf-web.html target=_blank>[��� ����Ʈ �����ذ�]</a> Ȥ�� �ڷ��-�ѹ����������Ŀ� �ִ� [�ŷ��������ſ�ī��������� �� ���ù���] ������ �����ϼ���.
		
		</td>
	</tr>	
	<%if(nm_db.getWorkAuthUser("������",user_id)){%>
	<!--  
	<tr>
        <td style="height:50;"></td>
    </tr>	
	<tr>
		<td>&nbsp;&nbsp;&nbsp; ��<span class=style5>����������������</span>�� <img src=/acar/images/center/button_see.gif align=absmiddle border=0 style="cursor: pointer;" onclick="test(0);">&nbsp;&nbsp;&nbsp;&nbsp;��<span class=style5>����Ư�����ѹ� �� �����Ģ</span>�� <img src=/acar/images/center/button_see.gif align=absmiddle border=0 style="cursor: pointer;" onclick="test(1);">
		</td>
	</tr>
	-->
    <%}%>
</table>
</body>
</html>