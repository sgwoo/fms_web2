<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>

<%

	//20210420 �̻��
	out.println("�̻�� ������ �Դϴ�.");
	if(1==1)return;

	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//��꼭�����
	UsersBean taxer_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("���ݰ�꼭�����"));
%>
<html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>���� ���ݰ�꼭 ���Ź��</title>
<style type="text/css">
<!--
.style1 {
	color: #747474;
	font-weight: bold;
	font-family:nanumgothic;
}
.style2 {color: #747474}
.style3 {
	color: #ff00ff;
	font-weight: bold;
}
.style4 {color: #626262}
.style5 {color: #376100}
.style6 {
	color: #FFFFFF;
	font-weight: bold;
}
.style8 {color: #696969}
.style9 {
	color: #f75802;
}
-->
</style>


</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align="center">
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href="https://www.amazoncar.co.kr" target="_blank" onFocus="this.blur();"><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>           
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>    
    <!-- ���� -->
    <tr>
        <td align=center style="font-size:20px;" background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>�Ƹ���ī ���ݰ�꼭 ���� ���</td>
    </tr>   
    <tr>
        <td height=40 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>         
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=26>&nbsp;</td>
                    <td width=648>
                        <table width=648 border=0 cellspacing=0 cellpadding=0>
                        
							<tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_02.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/img_01.gif></td>
                            </tr>
							<tr>
                                <td height=30></td>
                            </tr>
                                                    
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_03.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td  align=left><span style="font-family:nanumgothic;font-size:13px;line-height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. ��й�ȣ�� &quot;�� FMS&quot; �α��� ��й�ȣ�� �Է��ϼž� �մϴ�.<br>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. ó�� �湮�Ͻô� ���� ����/���λ����-����ڵ�Ϲ�ȣ, ����-�ֹε�Ϲ�ȣ�� �Է��ϼž� �մϴ�.<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. �Է��Ͻ� ��й�ȣ�� ��ġ���� ���� ��쿡�� <span style="color: #f75802;">IT�� 02-392-4243</span> �Ǵ� <span style="color: #f75802;">����(<a href=mailto:dev@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">dev@amazoncar.co.kr</span></a>)</span>��<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �����ֽñ� �ٶ��ϴ�. </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>                                   
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_04.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                            				<!-- ȸ�� ����� ����ó -->
                                            <td align=left style="font-family:nanumgothic;font-size:12px;line-height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;<span style="color: #f75802;">�� FMS</span>&quot;�� �α����Ͽ� ����ڸ� ���� �����ϰų� <span style="color: #f75802;">ȸ������ <%=taxer_bean.getHot_tel()%></span> ���� �����ֽñ� �ٶ��ϴ�. </span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/bar_01.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_bg.gif>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td align=left style="font-family:nanumgothic;font-size:13px;line-height:20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���Բ��� ������ ������ �ƴϽø� <span style="color: #f75802;">����(<a href=mailto:tax@amazoncar.co.kr><span style="font-family:nanumgothic;color: #f75802;">tax@amazoncar.co.kr</span></a>)</span>�� �����ֽñ� �ٶ��ϴ�.</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr> 
                            <tr>
                                <td height=30></td>
                            </tr>

                        </table>
                    </td>
                    <td width=26>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>

    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=82><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
</body>
</html>