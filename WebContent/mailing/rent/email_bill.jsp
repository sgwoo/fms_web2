<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"003458":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"S107HVEL00001":request.getParameter("l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//�뿩���� ī����
	int fee_count = af_db.getFeeCount(l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//��������� ��ȸ
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//�뿩�⺻����
	ContFeeBean fee = a_db.getContFee(m_id, l_cd, rent_st);
	
	Vector fee_scd = new Vector();
	int fee_scd_size = 0;
	//�Ǻ� �뿩�� ������ ����Ʈ
	if(rent_st.equals("")){
		fee_scd = af_db.getFeeScdMail(l_cd);
		fee_scd_size = fee_scd.size();
	}else{
		fee_scd = af_db.getFeeScdEmailRentst(l_cd, rent_st, fee.getPrv_mon_yn());
		fee_scd_size = fee_scd.size();
	}
	//���������
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("MNG_ID")));
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("������������ⳳ"));
	
	//���¹�ȣ *�� ������
	int acc_len = cms.getCms_acc_no().length();
	String acc_no = "";
	String acc_no1 = "";
	String acc_no2 = "";
	if(acc_len > 0){
		if(cms.getCms_acc_no().lastIndexOf("-") == -1){
			acc_no1 = "*******";
			acc_no2 = cms.getCms_acc_no().substring(7,acc_len);
			acc_no = acc_no1+acc_no2;
		}else{
			acc_no1 = cms.getCms_acc_no().substring(0,cms.getCms_acc_no().lastIndexOf("-"));
			acc_no2 = cms.getCms_acc_no().substring(cms.getCms_acc_no().lastIndexOf("-"));
    		for (int i = 0; i < acc_no1.length(); i++){
	    		char c = (char) acc_no1.charAt(i);
    			if ( c == '-') 
    				acc_no += "-";
    			else 
	    			acc_no += "*";
    		}
			acc_no += acc_no+acc_no2;
		}
	}
	
	//���� �޹�ȣ ������
	int car_no_len = String.valueOf(base.get("CAR_NO")).length();
	String car_no = "";
	if(car_no_len > 0){
		car_no = String.valueOf(base.get("CAR_NO")).substring(0,car_no_len-2)+"**";
	}
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>�Ƹ���ī û����</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #63676a}
.style3 {color: #ff8004}
.style4 {color: #c09b33; font-weight: bold;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- �� FMS�α��� ��ư -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_top_e.gif height=60 style='font-size:14px'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style1><b>2009�� 09��</b></span></td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=676 border=0 cellspacing=0 cellpadding=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bg1.gif>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=435 height=40><span class=style2><span class=style1><b><%=base.get("FIRM_NM")%> </b>��</span></span></td>
                    <td width=221><span class=style2><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ddj.gif align=absmiddle>&nbsp;&nbsp;<%=b_user.getUser_nm()%>&nbsp;&nbsp;<%=b_user.getUser_m_tel()%></span></td>
                </tr>
                <tr>
                    <td height=72>&nbsp;</td>
                    <td colspan=2>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=18><span class=style2><span class=style1><b>2009��12��05��</b></span> �����Ͻ� �ݾ��� <span class=style3><b>856,000</b></span> ���Դϴ�.</span></td>
                            </tr>
                            <tr>
                                <td height=18><span class=style2>�Ƹ���ī�� �̿��� �ּż� �������� ����帮��, �ñ��Ͻ� ������ �����ø� ����ڿ��� ��ȭ�ֽñ� �ٶ��ϴ�.</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_1.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_up.gif></td>
                </tr>
                <tr>
                    <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/e_ud_bg.gif>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=15></td>
                            </tr>
                            <tr>
                                <td width=15>&nbsp;</td>
                                <td width=245 valign=top>
                                    <table width=245 border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td width=95 height=22>&nbsp;&nbsp;<span class=style4>����</span></td>
                                            <td><span class=style1><%=base.get("FIRM_NM")%></span></td>
                                        </tr>
                                        <tr>
                                            <td height=1 bgcolor=f5e4c6 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td height=2></td>
                                        </tr>
                                        <tr>
                                            <td height=22>&nbsp;&nbsp;<span class=style4>��������</span></td>
                                            <td><span class=style1>���� XXX-XXXXXX</span></td>
                                        </tr>
                                        <tr>
                                            <td height=1 bgcolor=f5e4c6 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td height=2></td>
                                        </tr>
                                        <tr>
                                            <td height=22>&nbsp;&nbsp;<span class=style4>��������</span></td>
                                            <td><span class=style1>2009�� 12�� 5��</span></td>
                                        </tr>
                                        <tr>
                                            <td height=1 bgcolor=f5e4c6 colspan=2></td>
                                        </tr>
                                        <tr>
                                            <td height=2></td>
                                        </tr>
                                        <tr>
                                            <td height=22>&nbsp;&nbsp;<span class=style4>��û���ݾ�</span></td>
                                            <td><span class=style3><b>856,000<b> ��</span></td>
                                        </tr>
                                        <tr>
                                            <td height=1 bgcolor=f5e4c6 colspan=2></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=10></td>
                                <td width=371 valign=top>
                                    <table width=371 border=0 cellpadding=0 cellspacing=0>
                                        <tr>
                                            <td width=95 height=22>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_dot.gif align=absmiddle>&nbsp;<span class=style4>�����̿볻��</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width=371 border=0 cellspacing=1 cellpadding=0 bgcolor=fbe1c8>
                                                    <tr>
                                                        <td bgcolor=f9f1dc width=180 height=24 align=center><span class=style5>�뿩����</span></td>
                                                        <td bgcolor=f9f1dc width=95 align=center><span class=style5>������ȣ</span></td>
                                                        <td bgcolor=f9f1dc align=center><span class=style5>�ѱݾ�</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=ffffff height=24 align=center><span class=style2><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></td>
                                                        <td bgcolor=ffffff align=center><span class=style2><%=car_no%></span></td>
                                                        <td bgcolor=ffffff align=center><span class=style1>856,000��</span></td>
                                                    </tr>
                                                    <!--2���̻��ϰ��-->
                                                    <tr>
                                                        <td bgcolor=ffffff height=24 align=center><span class=style2><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></td>
                                                        <td bgcolor=ffffff align=center><span class=style2><%=car_no%></span></td>
                                                        <td bgcolor=ffffff align=center><span class=style1>856,000��</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor=ffffff height=24 align=center><span class=style2><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></td>
                                                        <td bgcolor=ffffff align=center><span class=style2><%=car_no%></span></td>
                                                        <td bgcolor=ffffff align=center><span class=style1>856,000��</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=15>&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=17></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_dw.gif></td>
                </tr>
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_2.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td height=2 bgcolor=e5b94e></td>
                </tr>
                <tr>
                    <td>
                        <table width=656 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                            <tr>
                                <td height=24 colspan=3 align=center bgcolor=f2f2f2><span class=style1>û������</span></td>
                                <td align=center bgcolor=f2f2f2><span class=style1>�ݾ�</span></td>
                                <td align=center bgcolor=f2f2f2><span class=style1>�հ�</span></td>
                            </tr>
                            <tr>
                                <td width=168 rowspan=5 align=center bgcolor=f9f1dc><%=car_no%><br>
                                (<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>) </td>
                                <td width=91 rowspan=2 align=center bgcolor=faf6ec><span class=style6>�뿩��</span></td>
                                <td width=120 height=24 align=center bgcolor=ffffff><span class=style1>26ȸ��</span></td>
                                <td width=136 align=right bgcolor=ffffff><span class=style2>780,000 ��</span>&nbsp;&nbsp;</td>
                                <td width=136 rowspan=2 align=right bgcolor=ffffff><span class=style1>811,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=24 align=center bgcolor=ffffff><span class=style1>��ü��</span></td>
                                <td align=right bgcolor=ffffff><span class=style2>31,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=24 align=center bgcolor=faf6ec><span class=style6>���·�</span></td>
                                <td align=center bgcolor=ffffff><span class=style1>2006-02-25 ����</span></td>
                                <td align=right bgcolor=ffffff><span class=style2>70,000 ��</span>&nbsp;&nbsp;</td>
                                <td align=right bgcolor=ffffff><span class=style1>811,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=24 align=center bgcolor=faf6ec><span class=style6>��å��</span></td>
                                <td align=center bgcolor=ffffff><span class=style1>2008-01-13 ����</span></td>
                                <td align=right bgcolor=ffffff><span class=style2>300,000 ��</span>&nbsp;&nbsp;</td>
                                <td align=right bgcolor=ffffff><span class=style1>811,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=24 align=center bgcolor=faf6ec><span class=style6>���հ�</span></td>
                                <td colspan=3 align=right bgcolor=ffffff><span class=style3>811,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                            
                            <tr>
                                <td width=168 rowspan=5 align=center bgcolor=f9f1dc><span class=style1><%=car_no%><br>
                                (<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>) </td>
                                <td width=91 rowspan=2 align=center bgcolor=faf6ec><span class=style6>�뿩��</span></td>
                                <td width=120 height=24 align=center bgcolor=ffffff><span class=style1>26ȸ��</span></td>
                                <td width=136 align=right bgcolor=ffffff><span class=style2>780,000 ��</span>&nbsp;&nbsp;</td>
                                <td width=136 rowspan=2 align=right bgcolor=ffffff><span class=style1>811,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=24 align=center bgcolor=ffffff><span class=style1>��ü��</span></td>
                                <td align=right bgcolor=ffffff><span class=style2>31,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=24 align=center bgcolor=faf6ec><span class=style6>���·�</span></td>
                                <td align=center bgcolor=ffffff><span class=style1>2006-02-25 ����</span></td>
                                <td align=right bgcolor=ffffff><span class=style2>70,000 ��</span>&nbsp;&nbsp;</td>
                                <td align=right bgcolor=ffffff><span class=style1>811,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=24 align=center bgcolor=faf6ec><span class=style6>��å��</span></td>
                                <td align=center bgcolor=ffffff><span class=style1>2008-01-13 ����</span></td>
                                <td align=right bgcolor=ffffff><span class=style2>300,000 ��</span>&nbsp;&nbsp;</td>
                                <td align=right bgcolor=ffffff><span class=style1>811,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=24 align=center bgcolor=faf6ec><span class=style6>���հ�</span></td>
                                <td colspan=3 align=right bgcolor=ffffff><span class=style3>811,000 ��</span>&nbsp;&nbsp;</td>
                            </tr>
                        </table>                      
                    </td>
                </tr>
                <tr></tr><tr></tr><tr></tr>
                <tr>
                    <td align=right>
                        <table width=275 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                            <tr>
                                <td height=24 align=center bgcolor=f9f1dc><span class=style2><b>���հ�</b></span></td>
                                <td width=136 align=right bgcolor=ffffff><span class=style3><b>811,000 ��</b></span>&nbsp;&nbsp;</td>
                            </tr>
                        </table>                      
                    </td>
                </tr>
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_3.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>�̿���</span></td>
                                <td bgcolor=ffffff colspan=3>&nbsp;<span class=style2>ȫ�浿</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>������ȣ</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=car_no%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>����</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>�����Ͻ�</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2>&nbsp;</span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>���ݳ���</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2>&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>�������</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2>&nbsp;</span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>���αݾ�</span></span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style3>40,000 ��</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_4.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=648 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 align=center><span class=style1>�̿���</span></td>
                                <td bgcolor=ffffff colspan=3>&nbsp;<span class=style2>ȫ�浿</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>������ȣ</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=car_no%></span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>����</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>�����Ͻ�</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2>&nbsp;</span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>���ݳ���</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2>&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=24 width=90 align=center><span class=style1>�������</span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style2>&nbsp;</span></td>
                                <td bgcolor=f2f2f2 width=90 align=center><span class=style1>���αݾ�</span></span></td>
                                <td bgcolor=ffffff>&nbsp;<span class=style3>70,000 ��</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_bar_5.gif></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/e_img1.gif usemap=#map border=0></td>
                </tr>
                <map name="Map">
                    <area shape="rect" coords="567,162,643,182" href="http://fms1.amazoncar.co.kr/mailing/fms/fms_info.html" target=_blank>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><span class=style12>�� ������ �߽����� �����̹Ƿ� �ñ��� ������ <a href=mailto:tax@amazoncar.co.kr><span class=style14>���Ÿ���(tax@amazoncar.co.kr)</span></a>�� �����ֽñ� �ٶ��ϴ�.</span></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=112><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
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