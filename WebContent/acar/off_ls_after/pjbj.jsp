<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_pre.*"%>
<jsp:useBean id="olyBean" class="acar.offls_pre.Offls_preBean" scope="page"/>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>


<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	
	Offls_preBean olyb[] = olpD.getPre_lst(gubun, gubun_nm, brch_id);
	
	
	int totCsum = 0;
	int totFsum = 0;
	
	String actn_cnt = ""; //����� ���ȸ��
/*�߰� - gill sun */
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String actn_id = olpD.getActn_id(car_mng_id);
	
	if(cmd.equals("")){
		olyBean = olpD.getPre_detail(car_mng_id); //�Ű�����������Ȳ���� ������ ��½�
	}else{
		olyBean = olpD.getPre_detail2(car_mng_id); //��ǰ��Ȳ���� ������ ��½�
	}
	
	String car_no = olyBean.getCar_no();
	
	int a=1000;

%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>ǰ��������</title>
<style type=text/css>
<!--
.style1 {
	font-size: 13px;
	font-weight: bold;
}
.style2 {
	font-size: 11px;
	font-weight: bold;
}
.style4 {
	color: #C00000;
	font-size: 11px;
	font-weight: bold;
}
.style6 {
color: #C00000;}

.style3 {
color:26329e;
font-weight: bold;
}

.style5 {
	color: #000000;
	font-size: 11px;
}
-->
</style>
<link href=/include/style_home.css rel=stylesheet type=text/css>
</head>
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<form name='form1' method='post' action=''>


<div>
<table width=754 border=0 cellpadding=18 cellspacing=1 bgcolor=5B608C>
    <tr>
        <td bgcolor=#FFFFFF valign=top align=center>
            <table width=708 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=20% align=center><img src=/acar/images/logo_1.png></td>
                    <td align=right valign=bottom>������ȣ : <%=olyBean.getCar_doc_no()%> ȣ</td>
                </tr>
                <tr>
                    <td height=7 colspan=2 align=center></td></tr>
                <tr>
                    <td colspan=2><img src=/acar/images/content/bar2.gif width=708 height=37></td>
                </tr>
                <tr align=center>
                    <td colspan=2>
                        <table width=690 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=28>(��)�Ƹ���ī���� �Ǹ��� �ڵ����� ���� ���� ������ �Ʒ��� �����ϴ�. </td>
                            </tr>
                            <tr>
                                <td height=12><span class=style1>1. �߰����ڵ��� ǰ�� ��������</span></td>
                            </tr>
                            <tr>
                                <td height=20>�Ʒ��� ���� ������ ������ �� �帳�ϴ�. </td>
                            </tr>
                            <tr>
                                <td height=20>
                                    <table width=690 border=0 cellpadding=0 cellspacing=1 bgcolor=cde83a>
                                        <tr>
                                            <td width=20% align=center bgcolor=e4f778><span class=style2><font color=4e6101>��������</font></span></td>
                                            <td height=48 bgcolor=#FFFFFF style="font-size:11px">&nbsp;&nbsp;&nbsp;���� �� �����Ⱓ ���� �߻��� ���� �� Ʈ�����̼��� ������ ������ ��ǰ�� �������<br>
                                                &nbsp;&nbsp;&nbsp;(��, ����, �޺���̼Ƿ��� �� �ܰ� �� �Ҹ� ��ǰ�� ����)<br>
                                                &nbsp;&nbsp;&nbsp;* ���� ���� ���� ���� ����, ��ǰ�� ��ȯ �� ���� ������ ��� �������� �ʽ��ϴ�.</td>
                                        </tr>
                                        <tr>
                                            <td align=center bgcolor=e4f778><span class=style2><font color=4e6101>�����Ⱓ</font></span></td>
                                            <td height=48 bgcolor=#FFFFFF style="font-size:11px">&nbsp;&nbsp;&nbsp;�����Ⱓ : �����Ϸκ��� 7��<br>
                                                &nbsp;&nbsp;&nbsp;����Ÿ� : �� ����Ÿ� <%=AddUtil.parseDecimal(AddUtil.parseInt((String)olyBean.getKm())+1000)%>km �̳� (���� ����Ÿ� = <%=AddUtil.parseDecimal((String)olyBean.getKm())%>km)<br>
                                                &nbsp;&nbsp;&nbsp;* ��� ��¥ �Ǵ� ����Ÿ� �� ���� ������ ���� �����Ⱓ ����� ����</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=3></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style1>2. ��������</span></td>
                            </tr>
                            <tr>
                                <td height=20 style="font-size:11px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ���������� ��翡 �԰��Ͽ� ó���ϴ°��� ��Ģ���� �մϴ�. <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� �������<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ������ ������ ���忡�� �� ��� ������ ���� ���� �ϼž� �մϴ�.                            <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- �ڵ��� ���ۻ簡 ������ ������ҿ��� �����ؾ� �մϴ�.                            <br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- �ŷ�����(������), ���ݰ�꼭�� �ݵ�� ���� �Ǿ�� �մϴ�.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ��������� ��簡 ������ҿ� ���� �����մϴ�.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ��Ÿ �ڼ��� ������ ����� �ڵ��� �Ű� ����ڿ� ���� �Ͻʽÿ�.<br>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ��翡 �԰� ������ ��������� ������ ���� �δ���(Ź�۷�,������ ��)�� ������ �δ��Դϴ�.</td>
                            </tr>
                            <tr>
                                <td height=22><span class=style1>3. ���� ��� ����</span></td>
                            </tr>
                            <tr>
                                <td height=20>
                                    <table width=690 border=0 cellpadding=0 cellspacing=1 bgcolor=cde83a>
                                        <tr align=center>
                                            <td width=20% height=20 bgcolor=e4f778><span class=style2><font color=4e6101>�� ��</font></span></td>
                                            <td width=30% bgcolor=#FFFFFF><span class=style4><%=olyBean.getCar_jnm()%></span></td>
                                            <td width=20% bgcolor=e4f778><span class=style2><font color=4e6101>������ȣ</font></span></td>
                                            <td bgcolor=#FFFFFF><span class=style4><%=olyBean.getCar_no()%></span></td>
                                        </tr>
                                        <tr align=center>
                                            <td height=20 bgcolor=e4f778><span class=style2><font color=4e6101>��������</font></span></td>
                                            <td bgcolor=#FFFFFF style="font-size:11px">&nbsp;\ <%=AddUtil.parseDecimal(olyBean.getCar_cs_amt() + olyBean.getCar_cv_amt() + olyBean.getSd_cs_amt() + olyBean.getSd_cv_amt())%></td>
                                            <td bgcolor=e4f778><span class=style2><font color=4e6101>�����ȣ</font></span></td>
                                            <td bgcolor=#FFFFFF style="font-size:11px"><%=olyBean.getCar_num()%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=2></td>
                            </tr>
                            <tr>
                                <td height=25><span class=style1>4. �����ϴ� �ڵ����� �̷� : ����</span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style1>5. �����ϴ� �ڵ����� ����̷� : ÷��</span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style6>�� ������� �ڵ����� ���� ���系���� ������� Ȯ���ϸ�, �� ���������� ����� ������ ���� Ȯ���մϴ�. </span></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan=2><img src=/acar/images/content/bar1.gif width=708 height=37></td>
                </tr>
                <tr align=center>
                    <td colspan=2 height=340>
                        <table width=690 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=28>�Ʒ��� ���� ��� �ڵ����� �������� ���Բ� ǲ �ɼ�(Put Option)�� �Ǹ��� �ο��մϴ�.</td>
                            </tr>
                            <tr>
                                <td  valign=top>
                                    <table width=690 border=0 cellspacing=0 cellpadding=0 background=/acar/images/content/put.JPG height=325>
                                        <tr>
                                            <td>
                                                <table width=690 border=0 cellpadding=0 cellspacing=0>
                                                    <tr>
                                                        <td height=17></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=198>&nbsp;</td>
                                                        <td width=421><font color=FFFFFF><b>ǲ�ɼ��̶�?</b></font></td>
                                                        <td width=39>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td height=10 colspan=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td style="font-size:11px">
                                                        ���Բ��� ��簡 ��ǰ�� �ڵ����� ���� �޾�����, ���� ���� �ڵ����� �����Ⱓ��<br>
                                                        ����ϵ��� ó������ ���Ѱ��, ���� �ڵ����� ��翡 �ݳ��ϰ� ��������� 95%��<br>
                                                        ȯ�ҹ޴�ȹ������ �ŷ������Դϴ�. �̴� ��簡 ���� ���ʷ� ���� �����Ͽ�����,��<br>
                                                        �� �� ��ǰ������ �Ǹ��� �����մϴ�. ��簡 ��ǰ�ϴ� ��� �ڵ����� �����ϴ� ǰ<br>
                                                        �������� �� �籸�� �������� Ȥ�� ���� ������ �ս��� �ּ�ȭ�ϰ�, ������ �ش�<br>ȭ�� �������ִ� ��� �������� ���� ���������̾������Դϴ�.<br><font color=999999>(��������:2008�� 04�� 25��)</font></td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=11></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td width=56>&nbsp;</td>
                                                        <td width=288 valign=top>
                                                            <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td><span class=style3>���Ⱓ</span> <span class=style5>: �����Ϸκ��� 52�� ~56��° (���Ϻһ���)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    (8���� �� ~ �ݿ�����)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=7></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>�ɼ���翡 ���� ������� ȯ��</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=5></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>1. ȯ������ : ���� �ڵ����� ������ �߱޵� �ɼǰŷ� ��<br>&nbsp;&nbsp;&nbsp;&nbsp;���� ����(�����, ��� ������ ��)�� ��ҿ� ��ȯ<br>&nbsp;&nbsp;
                                                                    &nbsp;�� �Ϸ�� ���� (���ึ���ð� ����,���ٹ��� ����)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=3></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>2. ȯ�ұݾ� : ���������� 95%(�ʿ����� ����)<br>&nbsp;&nbsp;&nbsp;&nbsp;(��, ������ �δ��� ����������, Ź�۷�, ������ ��<br>&nbsp;&nbsp;&nbsp;&nbsp;�δ����� ����)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=3></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>3. ȯ������ : ��3�� ������ �Ǵ� ��3�ڿ��� ���� ������<br>&nbsp;&nbsp;&nbsp;&nbsp;�����ϵ��� �������� ���� �� ����</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=25>&nbsp;</td>
                                                        <td width=320>
                                                            <table width=100% border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td><span class=style3>�����</span><span class=style5> : ��翡 �ɼ���� �ǻ�ǥ�� (��,�������� ��<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ǰ��� ����ڿ��� �ǻ� ǥ�� �Ǵ� ����,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ѽ��� �̿�)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=9></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>�ɼ���� ���� ����</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=5></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>1. ����Ÿ� : &nbsp;&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)olyBean.getKm())+1000)%>km �ʰ�<br>&nbsp;&nbsp;&nbsp;&nbsp;(������ ����Ÿ� ��� 1000km �ʰ���)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=2></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>2. �����ջ��� �߻���</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=2></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style5>3. ��3�ڿ��� �絵�� ��� (������� ����)</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=11></td>
                                                                </tr>
                                                                <tr>
                                                                    <td><span class=style3>�ɼ���� �� �δ���<br>(Ź�۷�, ������� ���� ���δ�)</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=25></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr align=center>
                    <td colspan=2>
                        <table width=670 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td height=20 align=right colspan=2><%=AddUtil.getDate3(Util.getDate())%>&nbsp;</td>
                            </tr>
                            <tr>
                                <td align=right valign=middle width=83%><span class=style1>�ֽ�ȸ�� �Ƹ���ī ��ǥ�̻�</span></td>
                                <td align=right><img src=/acar/images/content/sign.gif  align=absmiddle></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=15 colspan=2>&nbsp;&nbsp;<span class=style6>�� �������ڿ� ������ ���ų�, ���� ������ ���� ��ȿ�Դϴ�.</span></td>
                </tr>
                <tr>
                    <td height=15 colspan=2>&nbsp;&nbsp;���� �������� ���ǵ��� 17-3 ����̾ؾ����� 8�� ( http://www.amazoncar.co.kr)  &nbsp;&nbsp;TEL. 02) 392-4243 / FAX. 02) 757-0803</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</div>
</body>
</html>

<script>
onprint();

function onprint(){
factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 5.0; //��������   
factory.printing.topMargin = 5.0; //��ܿ���    
factory.printing.rightMargin = 5.0; //��������
factory.printing.bottomMargin = 5.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>


