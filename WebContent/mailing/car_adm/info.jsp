<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"002316":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"S105YNCL00040":request.getParameter("l_cd");
	String ins_st 	= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//���:������
	ContBaseBean base2 = a_db.getContBaseAll(m_id, l_cd);
	
	//���������
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("����������"));
	
	InsDatabase ai_db = InsDatabase.getInstance();
	if(ins_st.equals(""))	ins_st = ai_db.getInsSt(String.valueOf(base.get("CAR_MNG_ID")));
	
	//��������
	InsurBean ins = ai_db.getInsCase(String.valueOf(base.get("CAR_MNG_ID")), ins_st);
	
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>�Ƹ���ī ���뿩 �������� �ȳ�</title>
<style type="text/css">
<!--
.style1 {color: #88b228}
.style2 {color: #747474}
.style3 {color: #ffffff}
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style13 {color: #ff00ff}
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
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
    <!-- ��¥ -->
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=450>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/images/ment_02.gif width=414 height=12></td>
                    <td width=250 align=right><span class=style2><b><%= AddUtil.getDate() %></b></span>&nbsp;&nbsp;&nbsp;</td>
                </tr> 
            </table>
    <!-- ��¥ -->
        </td>
    </tr>
    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=454 valign=top>
                        <table width=454 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=14><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_up.gif width=14 height=16></td>
                                <td width=440 background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_up_bg.gif>&nbsp;</td>
                            </tr>
                            <tr>
                                <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_bg.gif>&nbsp;</td>
                                <td align=center>
                                    <table width=411 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td height=50 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/info_title.gif></td>
                                        </tr>
                                   <!-- ��ü�� -->
                                        <tr>
                                            <td height=20 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span class=style1><span class=style1><b><%=base.get("FIRM_NM")%></b></span>&nbsp;<span class=style2>�� ����</span> </span></td>
                                        </tr>
                                   <!-- ��ü�� -->
                                        <tr>
                                            <td height=9></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_line_up.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor=f7f7f7>
                                                <table width=411 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan=3 height=14></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=12>&nbsp;</td>
                                                        <td width=386 align=left>
                                                            <table width=386 border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=18><span class=style2>���� (��)�Ƹ���ī�� ������ ���� ã�ư��� ���񽺷� ���ɼ��ǲ� ����</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>������ �ص帮�� �ֽ��ϴ�.</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>������ ���������� ���Ͽ� ������ ���� ������ �˷� �帮���� �����</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>�����Ͻñ� �ٶ��ϴ�.</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=12>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 height=10></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_line_dw.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td height=15></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_left_dw.gif width=14 height=16></td>
                                <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_dw_bg.gif>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width=36 valign=top>
                        <table width=36 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_bg.gif>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_up.gif width=36 height=16></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                            </tr>
                            <tr>
                                <td height=129></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_img1.gif width=36 height=6></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_right_dw.gif width=36 height=16></td>
                            </tr>
                        </table>
                    </td>
                    <td width=187 valign=top>
            			<table width=187 border=0 cellpadding=0 cellspacing=0 bgcolor=574d89>
                            <tr>
                                <td width=187 bgcolor=594e8a>
                                    <table width=187 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=16 background=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_up_bg.gif></td>
                                        </tr>
                                        <tr>
                                            <td height=16><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_img1.gif width=187 height=51></td>
                                        </tr>
                                        <tr>
                                            <td height=17 align=left></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/sup.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=4></td>
                                        </tr>
                              <!-- ����� ��ȭ��ȣ -->
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=b_user.getUser_nm()%></strong></span><!--[$user_h_tel$]--> </td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=b_user.getUser_m_tel()%></strong></span><!--[$user_h_tel$]--></td>
                                        </tr>
                                        <tr>
                                            <td height=8></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/tax_bill/images/supervisor_2.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong>TEL. 02-392-4243 </strong></span></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong>FAX. 02-757-0803 </strong></span></td>
                                        </tr>
                              <!-- ����� ��ȭ��ȣ -->
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=16 background=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_dw_bg.gif>&nbsp;</td>
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
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=26>&nbsp;</td>
                    <td width=648>
                        <table width=648 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_1.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                       <!-- FMS���񽺶�? -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td width=55 height=24>&nbsp;</td>
                                            <td width=160 align=center bgcolor=f2f2f2><span class=style4>��ǰ����</span></td>
                                            <td width=268 align=center bgcolor=f2f2f2><span class=style4>��ȯ�ñ�</span></td>
                                            <td width=160 align=center bgcolor=f2f2f2><span class=style4>��Ÿ</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>1</span></td>
                                            <td align=center><span class=style5>��������</span></td>
                                            <td align=left>&nbsp;<span class=style7>����Ÿ� �� 7,000km ���ķ� ��ȯ </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>2</span></td>
                                            <td align=center><span class=style5>�Լǿ���</span></td>
                                            <td align=left>&nbsp;<span class=style7>����Ÿ� 40,000km ���� ��ȯ </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>3</span></td>
                                            <td align=center><span class=style5>Ÿ�ֺ̹�Ʈ</span></td>
                                            <td align=left>&nbsp;<span class=style7>����Ÿ� 80,000 ~ 100,000km ���� ��ȯ </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>4</span></td>
                                            <td align=center><span class=style5>��ȭ�÷���</span></td>
                                            <td align=left>&nbsp;<span class=style7>����Ÿ� 60,000km ���� ��ȯ </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>5</span></td>
                                            <td align=center><span class=style5>���̴ױ�ȯ</span></td>
                                            <td align=left>&nbsp;<span class=style7>����Ÿ� 40,000km ���� ��ȯ </span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style4>6</span></td>
                                            <td align=center><span class=style5>Ÿ�̾ȯ</span></td>
                                            <td align=left>&nbsp;<span class=style7>����Ÿ� 50,000km���� ��ȯ</span></td>
                                            <td>&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                      <!-- FMS���񽺶�? -->
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_2.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                      <!-- FMS�̿��� -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td width=200 height=24 align=center><span class=style4>�����ڹ���</span></td>
                                            <td width=105 align=center bgcolor=f2f2f2><span class=style4>��������</span></td>
                                            <td width=339 align=center bgcolor=f2f2f2><span class=style4>�������(�Ϲ����պ���)</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>�����, ������� ����/���� </span></td>
                                            <td rowspan=2 align=center><span class=style7>
											<%if(ins.getCar_mng_id().equals("")){%>
								                <%if(base2.getDriving_age().equals("0")){%> 26���̻� <%}%>
								                <%if(base2.getDriving_age().equals("3")){%> 24���̻� <%}%>
								                <%if(base2.getDriving_age().equals("1")){%> 21���̻� <%}%>
								                <%if(base2.getDriving_age().equals("2")){%> �������� <%}%>
											<%}else{%>
								                <%if(ins.getAge_scp().equals("1")){%>21���̻�<%}%> 
								                <%if(ins.getAge_scp().equals("4")){%>24���̻�<%}%> 
								                <%if(ins.getAge_scp().equals("2")){%>26���̻�<%}%> 
								                <%if(ins.getAge_scp().equals("3")){%>��������<%}%>		
											<%}%>									
											 </span></td>
                                            <td rowspan=2 align=center><span class=style7>
											<%if(ins.getCar_mng_id().equals("")){%>
								                å��,
												����(����),
								                <% if(base2.getGcp_kd().equals("1")){%>�빰(5õ����),<%}%>
								                <% if(base2.getGcp_kd().equals("2")){%>�빰(1���),<%}%>												
								                <% if(base2.getBacdt_kd().equals("1")){%>�ڱ��ü(5õ����),<%}%>
								                <% if(base2.getBacdt_kd().equals("2")){%>�ڱ��ü(1���),<%}%><br>
												����(<b>������å�� <%=AddUtil.parseDecimal(base2.getCar_ja())%>��</b> ����) 												
											<%}else{%>
											    å��,
								                <%if(ins.getVins_pcp_kd().equals("1")){%>����(����),<%}%> 
								                <%if(ins.getVins_pcp_kd().equals("2")){%>����(����),<%}%> 
								                <%if(ins.getVins_gcp_kd().equals("3")){%>�빰(1���),<%}%> 
								                <%if(ins.getVins_gcp_kd().equals("4")){%>�빰(5õ����),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("1")){%>�빰(3õ����),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("2")){%>�빰(1õ5�鸸��),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("5")){%>�빰(1õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("1")){%>�ڱ��ü(3���),<%}%> 
								                <%if(ins.getVins_bacdt_kd().equals("2")){%>�ڱ��ü(1��5õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("6")){%>�ڱ��ü(1���),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("5")){%>�ڱ��ü(5õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("3")){%>�ڱ��ü(3õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("4")){%>�ڱ��ü(1õ5�鸸��),<%}%><br>
												<%if(ins.getVins_canoisr_amt()>0){%>������������,<%}%>
												<%if(ins.getVins_spe_amt()>0){%>�ִ�ī,<%}%>												
												����(<b>������å�� <%=AddUtil.parseDecimal(base2.getCar_ja())%>��</b> ����)
											<%}%>																				
											</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>����� ������ ����</span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr>
                            <tr>
                                <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/img_1.gif></td>
                            </tr>
                      <!-- FMS�̿��� -->
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_3.gif></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                       <!-- FMS�������� -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=608>
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=30 align=left><span class=style2>���� �� �Ͼ ��� ��Ÿ �߻��� ��� ���Ͽ� ���� (��)�Ƹ���ī���� ��� ó���� �帮�� �ֽ��ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=25 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>��� �߻��ÿ� ����� �������� ����ڿ��� ��� �����ּž� �մϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=30 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>��������� ����, ������� �԰� ���� ����� �������� ���ÿ� ����� �ϸ�, ���� ���þ��� ����
���Ƿ� ��<br>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ���� ��� ������ ���δ��Դϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=25 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>���� ���� ����� ���� ��ġ�մϴ�.(���� ������ ��� ���ǿ� ���մϴ�.)</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=20></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3  align=center><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/img_2.gif></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_4.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                      <!-- ��Ÿ���� -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=608>
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=18 align=left><span class=style2>�������� ���� �� ���� ���Ͽ� 4�ð� �̻� ����������� �԰�� ��� �뿩������ 
                                                        ������ �������� ���� ���� 
��</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left><span class=style2>�񽺸� ������ �帳�ϴ�.</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/bar_5.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                      <!-- ��Ÿ���� -->
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=608>
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=18 align=left><span class=style2>�ӵ�����, �������� ����, ������ ����, ���� ����ī�޶� �� ���� ���� �� ���ߵ� ���·ᳪ ��Ģ���� ���Բ���</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left><span class=style2>�δ��ϼž� �մϴ�. (���� ����)</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_dw.gif width=648 height=7></td>
                                        </tr>
                                    </table>
                                </td>
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