<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="detail" scope="page" class="acar.offls_actn.Offls_actnBean"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	detail = olaD.getActn_detail(car_mng_id);
	
	int a=1000;

%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>��ǰ��û��</title>
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
<link href=/include/style_opt.css rel=stylesheet type=text/css>
</head>

<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/ScriptX.cab" >
</object>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<form name='form1' method='post' action=''>

<div>
<table width=754 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td bgcolor=#FFFFFF valign=top align=center>
            <table width=714 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=15></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=428 align=center rowspan=3><img src=/acar/images/content/name.gif></td>
                                <td align=right>
                                    <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>�� ǰ ��</td>
                                            <td bgcolor=#FFFFFF align=center><%=AddUtil.getDate2(1)%> &nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp; <%=AddUtil.getDate2(2)%>&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp; <%=AddUtil.getDate2(3)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=7></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>������ȣ</td>
                                            <td bgcolor=#FFFFFF>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width=25% align=center bgcolor=#FFFFFF height=24>��ǰ��ȣ</td>
                                            <td bgcolor=#FFFFFF>&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=12></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td bgcolor=#dddddd height=24 width=8% align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF colspan=2>&nbsp;<%=detail.getCar_jnm() + " " +detail.getCar_nm() %></td>
                                <td bgcolor=#dddddd width=6% align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF colspan=2><span class=style5>&nbsp;A/T &nbsp;M/T &nbsp;SAT &nbsp;CVT</span></td>
                                <td bgcolor=#dddddd width=7% align=center><b>��ⷮ</b></td>
                                <td bgcolor=#FFFFFF colspan=2 width=10% align=right><span class=style5><%=detail.getDpm()%>CC&nbsp;</span></td>
                                <td bgcolor=#dddddd width=8% align=center><b>�����</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5>DR&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>��Ϲ�ȣ</b></td>
                                <td bgcolor=#FFFFFF width=24%>&nbsp;<b><%=detail.getCar_no()%></b></td>
                                <td bgcolor=#dddddd width=8% align=center><b>�����ȣ</b></td>
                                <td bgcolor=#FFFFFF colspan=6>&nbsp;<b><%=detail.getCar_num()%></b></td>
                                <td bgcolor=#dddddd align=center><b>����<br>ȭ��</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5> �ν�&nbsp;<br>TON&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF>&nbsp;<b><%=detail.getCar_y_form()%></b></td>
                                <td bgcolor=#dddddd rowspan=2 align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF rowspan=2 colspan=5>
                                    <table width=100% border=0 cellspacing=0 cellpadding=3>
                                        <tr><td><span class=style5>A/C &nbsp;P/S &nbsp;ADL &nbsp;CDP &nbsp;ABS &nbsp;���׽�Ʈ &nbsp;����� <br>
                                                �˷�̴��� &nbsp;�����(�̱ۡ����) &nbsp;ECS &nbsp;AV <br>
                                                ������̼�(&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</span></td>
                                        </tr>
                                    </table>
                                <td bgcolor=#dddddd width=6% align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF colspan=2>
                                <span class=style5>&nbsp;&nbsp;
                                <%=c_db.getNameByIdCode("0039", "", detail.getFuel_kd())%>                                                            
                                </span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>�����</b></td>
                                <td bgcolor=#FFFFFF>&nbsp;<b><%=AddUtil.ChangeDate2(detail.getInit_reg_dt())%></b></td>
                                <td bgcolor=#dddddd align=center><b>�� ��</b></td>
                                <td bgcolor=#FFFFFF colspan=2><span class=style5>&nbsp;<%=detail.getColo()%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=#dddddd height=24 align=center><b>����Ÿ�</b></td>
                                <td bgcolor=#FFFFFF align=right><span class=style5>Km �� �Ҹ�&nbsp;</span></td>
                                <td bgcolor=#dddddd align=center><b>����˻�</b></td>
                                <td bgcolor=#FFFFFF colspan=2 width=15%><span class=style5>&nbsp;200 &nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;&nbsp;��</span></td>
                                <td bgcolor=#dddddd width=8% align=center><b>���뵵</b></td>
                                <td bgcolor=#FFFFFF colspan=3><span class=style5>�ڰ� &nbsp;���� &nbsp;��� &nbsp;��Ʈ</span></td>
                                <td bgcolor=#dddddd align=center><b>��������</b></td>
                                <td bgcolor=#FFFFFF><span class=style5>&nbsp;����&nbsp;���&nbsp;����</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td width=39% bgcolor=#FFFFFF align=center valign=top height=140>
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=2 height=22>&nbsp;<span class=style3>��ɻ�����</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>��������ü : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>��������ġ : (��ȣ���ҷ�)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>���ð���ġ : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>��������ġ : (��ȣ���ҷ�)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>���Լ���ġ : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>��������,���� : (�� �� ��)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>��������ġ : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>��������ġ : (��ȣ���ҷ�)</td>
                                        </tr>
                                        <tr>
                                            <td height=20>�������ġ : (��ȣ���ҷ�)</td>
                                            <td>&nbsp;</td>
                                            <td>����Ÿ���� : (��ȣ���ҷ�)</td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=12% bgcolor=#FFFFFF align=center valign=top height=140>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22 align=center><span class=style3>���������</span></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=49% bgcolor=#FFFFFF rowspan=2 align=center valign=top height=340> 
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22 colspan=2>&nbsp;<span class=style3>�ܰ�������</span></td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td rowspan=7><img src=/acar/images/content/cp_img.gif height=291></td>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td colspan=2 bgcolor=#dddddd align=center height=15>ǥ�ñ�ȣ</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center width=55 height=15>�����ʿ�</td>
                                                        <td bgcolor=#ffffff align=center>P</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>��ȯ�ʿ�</td>
                                                        <td bgcolor=#ffffff align=center>X</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� ��</td>
                                                        <td bgcolor=#ffffff align=center>U</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>��ó����</td>
                                                        <td bgcolor=#ffffff align=center>A</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� ��</td>
                                                        <td bgcolor=#ffffff align=center>C</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� ��</td>
                                                        <td bgcolor=#ffffff align=center>T</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>��������</td>
                                                        <td bgcolor=#ffffff align=center>L</td>
                                                    </tr>
                                                </table>
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 Cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>�⺻����</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� Ű (������)</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�ٷ�ġ (������)</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>�ǳ�����</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� Ʈ (�硤��)</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� (�硤��)</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=3></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=81 border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td bgcolor=#dddddd height=15 align=center>��ü����</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#ffffff align=center height=15>�� �� ��</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table> 
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=#FFFFFF rowspan=2 align=center valign=top height=290>
                                    <table width=95% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                        <tr>
                                            <td height=22>&nbsp;<span class=style3>Ư�����(�Ϲ�)</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                    <tr>
                                                        <td rowspan=2 bgcolor=#dddddd align=center>��ǰ��<br>��϶�</td>
                                                        <td colspan=2 bgcolor=#FFFFFF height=22 align=center>���ݰ�꼭 ����</td>
                                                        <td bgcolor=#FFFFFF align=center>ʦ</td>
                                                        <td bgcolor=#FFFFFF align=center>��ʦ</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=2 bgcolor=#FFFFFF height=22 align=center>����Ź�۹��</td>
                                                        <td bgcolor=#FFFFFF align=center>Ź��</td>
                                                        <td bgcolor=#FFFFFF align=center>����</td>
                                                    </tr>
                                                    <tr>
                                                        <td rowspan=2 bgcolor=#dddddd align=center>�����<br>����</td>
                                                        <td bgcolor=#FFFFFF height=22 align=center>�����Է�</td>
                                                        <td bgcolor=#FFFFFF align=center>�з���ȸ</td>
                                                        <td bgcolor=#FFFFFF align=center>��ǰ����</td>
                                                        <td bgcolor=#FFFFFF align=center>Ź�۽�û</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=#FFFFFF height=38 align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                        <td bgcolor=#FFFFFF align=center>&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;<span class=style3>���� ���û���</span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;���������� :</td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;����&nbsp;��&nbsp;�� :&nbsp;&nbsp;<%=detail.getP_car_off_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;��ī������ :&nbsp;&nbsp;<%=detail.getP_emp_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� :
                                            <!--
											<%// if ( detail.getP_emp_id().equals("011815")) {%>D000137
                                            <%//} else {%>D000328
                                            <%//} %>
											-->
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;���ֹι�ȣ :</td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;����������ȣ :&nbsp;&nbsp;<%=detail.getP_rpt_no()%></td>
                                        </tr>
                                        <tr>
                                            <td height=7></td>
                                        </tr>
                                    </table>
                                </td>
                                <td bgcolor=#FFFFFF align=center height=190 valign=top>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=10></td>
                                        </tr>
                                        <tr>
                                            <td height=22 align=center><span class=style3>Ư�����<br>(��������)</span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor=#FFFFFF align=center height=90><span class=style3>�޸��</span></td>
                                <td bgcolor=#FFFFFF>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=7></td>
                </tr>
                <tr>
                    <td>
                        <table width=714 border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                            <tr>
                                <td bgcolor=#FFFFFF align=center>
                                    <table width=100% border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td width=48% align=center valign=top>
                                                <table width=96% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=22>&nbsp;<span class=style3>��ǰ������ (917)</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=18% rowspan=2 align=center bgcolor=#dddddd>�ֹι�ȣ</td>
                                                                    <td bgcolor=#ffffff rowspan=2 align=center>115611 - 0019610</td>
                                                                    <td width=18% align=center bgcolor=#dddddd height=25>����</td>
                                                                    <td bgcolor=#ffffff align=center>(��)�Ƹ���ī</td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd height=25>��ȭ��ȣ</td>
                                                                    <td bgcolor=#ffffff align=center>02-392-4243</td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd height=32>�� ��</td>
                                                                    <td bgcolor=#ffffff colspan=3>&nbsp;����� �������� ���ǵ��� 17-3 ��ȯ��� 802ȣ</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd><font color=c00000><b>�����</b></font></td>
                                                                    <td bgcolor=#ffffff height=30 align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=9% align=center><b>,</b></td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=12% align=center>����</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd><font color=c00000><b>���۰�</b></font></td>
                                                                    <td bgcolor=#ffffff height=30 align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=9% align=center><b>,</b></td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff align=center>&nbsp;</td>
                                                                    <td bgcolor=#ffffff width=12% align=center>����</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#dddddd>�� ��<br>�� ��</td>
                                                                    <td bgcolor=#ffffff height=60 align=center>
                                                                        <table width=95% border=0 cellspacing=0 cellpadding=0>
                                                                            <tr>
                                                                                <td height=25>������ ( �Ƹ���ī )  &nbsp;&nbsp;�ŷ����� ( ���� )</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=25>���¹�ȣ ( 140 - 004 - 023871 )</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td width=58 align=center bgcolor=#ffffff>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��<br>Ȯ�μ���</td>
                                                                    <td bgcolor=#ffffff>
                                                                        <table width=100% border=0 cellpadding=3 cellspacing=0>
                                                                            <tr>
                                                                                <td valign=top height=44 align=center><font style="font-size:5pt">��⳻���� Ʋ�������� Ȯ���ϸ� ���ǻ��׿� �����Ͽ� �����մϴ�.</font></td>
                                                                                <td align=right align=right><b>(��)</b></td>
                                                                             </tr>
                                                                         </table>
                                                                     </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#ffffff>�� �� ��<br>Ȯ�μ���</td>
                                                                    <td bgcolor=#ffffff>
                                                                        <table width=100% border=0 cellpadding=3 cellspacing=0>
                                                                            <tr>
                                                                                <td valign=top  height=44 align=center valign=top><font style="font-size:5pt">��⳻���� Ʋ�������� Ȯ���ϸ� ���ǻ��׿� �����Ͽ� �����մϴ�.</font></td>
                                                                                <td align=right><b>(��)</b></td>
                                                                             </tr>
                                                                         </table>
                                                                     </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=52%>
                                                <table width=99% border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=6></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=22 style="font-size:11px">&nbsp;<font color=c00000><b>�� ���Կ�� �� ���ǻ���</b></font></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� ������ ���� ���θ�Ī���� �ݵ�� ����Ͻʽÿ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��) ���Ǿ� 1.5 RS</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� ����Ÿ��� �ܴ������� �����Ͻʽÿ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp;<b> �� �ܰ����´� �ش� ������ ���� ǥ���ϰ� �����̷��� �����ÿ���<br>&nbsp;&nbsp;&nbsp;&nbsp;  �ܺο� ǥ���Ͻʽÿ�.</b></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� ������������� ������, �����, ��������, �������� ���� ����<br>&nbsp;&nbsp;&nbsp;&nbsp;  �����Ͻʽÿ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� �� �׸��� ��������� ������ �����Խ� �׿� ���� �Ρ������� å����<br>&nbsp;&nbsp;&nbsp;&nbsp; ��ǰ�ڰ� ���� �Ǵ� �����Ͻñ� �ٶ��ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� �μ��ڷκ��� �ߴ��� Ŭ����(����)�� ����� ��� ��ǰ��������<br>&nbsp;&nbsp;&nbsp;&nbsp; ���� ó���ؾ� �� �ǹ��� �ֽ��ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span class=style5>&nbsp;&nbsp; �� </b>������ Ź�۷�� ������ݿ��� �����ϸ�, ������ ����� �԰� �� ��<br>&nbsp;&nbsp;&nbsp;&nbsp; ���� Ź�۷�� �� �δ����� �����Ͻñ� �ٶ��ϴ�.</b></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=13></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width=99% border=0 cellspacing=1 cellpadding=0 bgcolor=#a7a7a7>
                                                                <tr>
                                                                    <td align=center bgcolor=#dddddd colspan=2 height=18><span class=style5>�� ���񼭷� ( ����� ������ Vǥ�� �ٶ��ϴ� )</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td align=center bgcolor=#FFFFFF height=18><span class=style5>����/���λ����</span></td>
                                                                    <td align=center bgcolor=#FFFFFF><span class=style5>���λ����</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td bgcolor=#ffffff align=center width=49% valign=top>
                                                                        <table width=95% border=0 cellpadding=0 cellspacing=0>
                                                                            <tr>
                                                                                <td height=5></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ�������� ����</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ΰ����� 1��</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ����絵���� ������(�ΰ�����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ�����(���漼) ��������</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ����� ���Ұ���û��(�ΰ�<����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� ����ڵ���� �纻 1��(���λ����)</font></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td bgcolor=#ffffff align=center width=51%>
                                                                        <table width=95% border=0 cellpadding=0 cellspacing=0>
                                                                            <tr>
                                                                                <td height=5></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ�������� ����</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� ���� �ΰ�����/���ε ��1��</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ����絵���� ������(�ΰ�����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ�����(���漼) ��������</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� �ڵ����� ���Ұ���û��(�ΰ�����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=15><font style="font-size:7pt">�� ����ڵ������� (��, ��뺻������<br>&nbsp;&nbsp;&nbsp; �������� �ּҰ� ������ ��츸 ����)</font></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height=3></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height=7></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=97% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=24 width=20%><img src=/acar/images/content/glovis.gif align=absmiddle></td>
                                <td><b>���롤����ڵ��������</td>
                                <td align=right><b>������ȭ :</b> 031-760-5300, 5354, 5350&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>FAX :</b> 031-760-5390</td>
                            </tr>
                        </table>
                    </td>
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


