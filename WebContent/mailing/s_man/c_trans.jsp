<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	if(rent_l_cd.equals("")){
		rent_mng_id = "021321";
		rent_l_cd="S113KK5R00471";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������+������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//�����븮��
	CommiBean emp4 	= a_db.getCommi(rent_mng_id, rent_l_cd, "4");
	
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
	
	String user_id = base.getBus_id();
	user_bean 	= umd.getUsersBean(user_id);
	
	
%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>���޼����� ���޳��� �ȳ�</title>

<style type=text/css>
<!--
.style1 {color: #444444}
.style2 {color: #747474; font-size: 8pt;}
.style3 {color: #707166; font-size: 8pt;}
.style4 {color: #909090; font-size: 8pt;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #af2f98; font-size:8pt;}
.style7 {color: #d07f43; font-size:8pt;}
.style8 {color: #476299; font-size:8pt;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>

<body>
<table width=730 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/s_man/images/up_2.gif>
    <tr>
        <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/s_man/images/up_1.gif width=730 height=80></td>
    </tr>
    <tr>
        <td colspan=3 height=25></td>
    </tr>
    <tr>
        <td width=8 align=center>&nbsp;</td>
        <td width=714 height=194 align=center valign=top style="background:url(https://fms5.amazoncar.co.kr/mailing/s_man/images/up_3.gif) no-repeat;">
            <table width=714 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=85 colspan=3></td>
                </tr>
                <tr>
                    <td width=50>&nbsp;</td>
                    <td width=25>&nbsp;</td>
                    <td width=639 style="font-family:nanumgothic;font-size:13px;"><span style="color:#476299;"><b><%=emp1.getEmp_nm()%></b></span>�� ����</span></td>
                </tr>
                <tr>
                    <td colspan=3 height=10></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td colspan=2><span style="font-family:nanumgothic;font-size:13px;">������ ������ ����Ͻ� ������ �ε������� �������翡 ���ؼ� �˷��帳�ϴ�.<br>
                    ������ �����Ͻñ� �ٶ��ϴ�. </span></td>
                </tr>
            </table>
        </td>
        <td width=8 align=center>&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>
            <table width=714 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=15>&nbsp;</td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=664 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=30>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/s_man/images/bar_up_1.gif width=69 height=15></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=664 border=0 cellpadding=0 cellspacing=1 bgcolor=cacaca>
                                        <tr bgcolor=#FFFFFF>
                                            <td width=100 height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">��ü��</td>
                                            <td width=229 style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=client.getFirm_nm()%></td>
                                            <td width=100 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">����ڸ�</td>
                                            <td width=230 style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=client.getClient_nm()%></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">����</td>
                                            <td colspan=3 style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�뿩��ǰ</td>
                                            <td colspan=3 style="font-family:nanumgothic;font-size:13px;">&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��ⷻƮ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>��⸮��<%}%>
											 <%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}else if(rent_way.equals("2")){%>�����<%}%>
											 <%if(base.getCar_gu().equals("1")){%>(�����뿩)<%}else{%>(�縮���뿩)<%}%></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�������</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                                            <td align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">���Ⱓ</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=fee.getCon_mon()%>���� (<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%> ~ <%=AddUtil.ChangeDate2(fee.getRent_end_dt())%>)</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�������</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=AddUtil.ChangeDate2(base.getDlv_dt())%></td>
                                            <td align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�������</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=25>&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=30>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/s_man/images/bar_up_2.gif width=67 height=15></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=664 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/s_man/images/up_7.gif>
                                        <tr>
                                            <td colspan=2><img src=https://fms5.amazoncar.co.kr/mailing/s_man/images/up_5.gif width=664 height=7></td>
                                        </tr>
                                        <tr>
                                            <td width=125 align=right><img src=https://fms5.amazoncar.co.kr/mailing/s_man/images/up_8.gif width=107 height=56></td>
                                            <td width=539 height=80 valign=middle>
                                                <table width=539 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;<span style="font-family:nanumgothic;font-size:13px;"> �����ε����� <span style="color:#ef620c;font-weight:bold;">[<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>]</span> �Դϴ�.</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan=2><img src=https://fms5.amazoncar.co.kr/mailing/s_man/images/up_6.gif width=664 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=25>&nbsp;</td>
                            </tr>
                            <tr>
                                <td height=30>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/s_man/images/bar_up_3.gif width=124 height=15></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=664 border=0 cellpadding=0 cellspacing=1 bgcolor=ffcf97>
                                        <tr bgcolor=#FFFFFF>
                                            <td width=126 height=28 align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">�������</td>
                                            <td width=188 style="font-family:nanumgothic;font-size:13px;">&nbsp;<%if(emp1.getCommi_car_st().equals("")||emp1.getCommi_car_st().equals("1")){%>��������<%}else{%>-<%}%></td>
                                            <td width=126 align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">&nbsp;���ذ���</td>
                                            <td width=210 style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>��</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=28 align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">�Ǽ�����</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=emp1.getEmp_acc_nm()%></td>
                                            <td align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">�ŷ�����</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=emp1.getEmp_bank()%></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=28 align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">���ޱݾ�</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<span style="color:#ef620c;font-weight:bold;"><%=AddUtil.parseDecimal(emp1.getDif_amt())%> ��&nbsp;</span></td>
                                            <td align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">��������</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=AddUtil.ChangeDate2(emp1.getSup_dt())%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                            </tr>
							<% 	int rowspan = 8;
								if(emp1.getAdd_amt1() == 0) 		rowspan = rowspan-1;
								if(emp1.getAdd_amt2() == 0) 		rowspan = rowspan-1;
								if(emp1.getAdd_amt3() == 0) 		rowspan = rowspan-1;
								if(emp1.getDlv_con_commi() == 0) 	rowspan = rowspan-1;
								if(emp1.getDlv_tns_commi() == 0) 	rowspan = rowspan-1;
								if(emp1.getAgent_commi() == 0) 		rowspan = rowspan-1;
							%>
                            <tr>
                                <td>
                                    <table width=664 border=0 cellpadding=0 cellspacing=1 bgcolor=cacaca>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 colspan=2 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">����</td>
                                            <td width=188 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�ݾ�</td>
                                            <td width=337 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">����</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td width=40 rowspan=<%=rowspan%> align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�ҵ�</td>
                                            <td width=85 height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">��������</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp1.getCommi())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;���ذ����� <%=AddUtil.parseDecimal(emp1.getComm_r_rt())%>%</td>
                                        </tr>
                                        
										<%if(emp1.getDlv_con_commi()>0 || emp1.getDlv_con_commi()<0){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">���������</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp1.getDlv_con_commi())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td></tr>
										<%}%>
                                        
										<%if(emp1.getDlv_tns_commi()>0 || emp1.getDlv_tns_commi()<0){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�����̰��������</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp1.getDlv_tns_commi())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td></tr>
										<%}%>

										<%if(emp1.getAgent_commi()>0 || emp1.getAgent_commi()<0){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�����������</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp1.getAgent_commi())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td></tr>
										<%}%>

										<%if(emp1.getAdd_amt1()>0 || emp1.getAdd_amt1()<0){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">��������</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp1.getAdd_amt1())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;<%=emp1.getAdd_cau1()%></td>
                                        </tr>
										<%}%>
										<%if(emp1.getAdd_amt2()>0 || emp1.getAdd_amt2()<0){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">��������</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp1.getAdd_amt2())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;<%=emp1.getAdd_cau2()%></td>
                                        </tr>
										<%}%>
										<%if(emp1.getAdd_amt3()>0 || emp1.getAdd_amt3()<0){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">��������</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp1.getAdd_amt3())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;<%=emp1.getAdd_cau3()%></td>
                                        </tr>
										<%}%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�Ұ�</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=Util.parseDecimal(emp1.getCommi()+emp1.getDlv_con_commi()+emp1.getDlv_tns_commi()+emp1.getAdd_amt1()+emp1.getAdd_amt2()+emp1.getAdd_amt3()+emp1.getAgent_commi())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td>
                                        </tr>
                                        <%	String incom_st = ""; %>
                                        <%if(emp1.getVat_amt()>0){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 colspan=2 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�ΰ���</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp1.getVat_amt())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 colspan=2 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">���ޱݾ�</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><span style="color:#ef620c;font-weight:bold;"><%=AddUtil.parseDecimal(emp1.getDif_amt())%> ��</span>&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td>
                                        </tr>
                                        <%}else{%>
                                        <tr bgcolor=#FFFFFF>
                                            <td rowspan=3 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">����</td>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�ҵ漼</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=Util.parseDecimal(emp1.getInc_amt())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;<% incom_st = emp1.getRec_incom_st(); if(emp1.getRec_incom_st().equals("")) incom_st = coe_bean.getCust_st();%><%if(incom_st.equals("2")){%>����ҵ漼�� 3%<%}else if(incom_st.equals("3")){%>��Ÿ����ҵ� 5%<%}%></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">���漼</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=Util.parseDecimal(emp1.getRes_amt())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;�ҵ漼�� 10%</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�Ұ�</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=Util.parseDecimal(emp1.getTot_amt())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 colspan=2 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�������޾�</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><span style="color:#ef620c;font-weight:bold;"><%=AddUtil.parseDecimal(emp1.getDif_amt())%> ��</span>&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td>
                                        </tr>
                                        <%}%>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>
                            <%if(emp1.getVat_amt()==0){%>
                            <tr>
                                <td align=left style="font-family:nanumgothic;font-size:12px;">&nbsp;&nbsp;* <span style="color:#476299;"><b><%if(incom_st.equals("2")){%>����ҵ�<%}else if(incom_st.equals("3")){%>��Ÿ����ҵ�<%}%>��������</b></span>�� �ʿ��Ͻ� ���� ���������<!--<span style="color:#476299;"><b><%=user_bean.getUser_nm()%> <%=user_bean.getUser_pos()%> (TEL. <%=user_bean.getUser_m_tel()%>)</b></span>-->���� �����Ͻñ� �ٶ��ϴ�.</span></td>
                            </tr>
                            <%}%>                                                        
                            <!--�����븮-->
                            <%if(emp4.getDif_amt()>0){%>
                            <tr>
                                <td height=25>&nbsp;</td>
                            </tr>                            
                            <tr>
                                <td>
                                    <table width=664 border=0 cellpadding=0 cellspacing=1 bgcolor=ffcf97>
                                        <tr bgcolor=#FFFFFF>
                                            <td width=126 height=28 align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">�Ǽ�����</td>
                                            <td width=188 style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=emp4.getEmp_acc_nm()%></td>
                                            <td width=126 align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">�ŷ�����</td>
                                            <td width=210 style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=emp4.getEmp_bank()%></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=28 align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">���ޱݾ�</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<span style="color:#476299;"><b><%=AddUtil.parseDecimal(emp4.getDif_amt())%> ��</b>&nbsp;</span></td>
                                            <td align=center bgcolor=fceed2 style="font-family:nanumgothic;font-size:13px;">��������</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<%=AddUtil.ChangeDate2(emp4.getSup_dt())%></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                            </tr>                            							
                            <tr>
                                <td>
                                    <table width=664 border=0 cellpadding=0 cellspacing=1 bgcolor=cacaca>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 colspan=2 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">����</td>
                                            <td width=188 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�ݾ�</td>
                                            <td width=337 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">����</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td width=40 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�ҵ�</td>
                                            <td width=85 height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�����������</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp4.getCommi())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<span class=style4>&nbsp;�븮����</td>
                                        </tr>                                        
                                        <%	incom_st = ""; %>
                                        <%if(emp4.getVat_amt()>0){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 colspan=2 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�ΰ���</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=AddUtil.parseDecimal(emp4.getVat_amt())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;<span class=style4>&nbsp;</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 colspan=2 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">���ޱݾ�</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><span style="color:#476299;"><b><%=AddUtil.parseDecimal(emp4.getDif_amt())%> ��</b></span>&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td>
                                        </tr>
                                        <%}else{%>
                                        <tr bgcolor=#FFFFFF>
                                            <td rowspan=3 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">����</td>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�ҵ漼</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=Util.parseDecimal(emp4.getInc_amt())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;<% incom_st = emp4.getRec_incom_st(); if(emp4.getRec_incom_st().equals("")) incom_st = coe_bean.getCust_st();%><%if(incom_st.equals("2")){%>����ҵ漼�� 3%<%}else if(incom_st.equals("3")){%>��Ÿ����ҵ� 5%<%}%></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">���漼</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=Util.parseDecimal(emp4.getRes_amt())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;�ҵ漼�� 10%</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�Ұ�</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><%=Util.parseDecimal(emp4.getTot_amt())%> ��&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=25 colspan=2 align=center bgcolor=f2f2f2 style="font-family:nanumgothic;font-size:13px;">�������޾�</td>
                                            <td align=right bgcolor=FFFFFF style="font-family:nanumgothic;font-size:13px;"><span style="color:#476299;"><%=AddUtil.parseDecimal(emp4.getDif_amt())%> ��</span>&nbsp;&nbsp;</td>
                                            <td style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;</td>
                                        </tr>
                                        <%}%>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=10></td>
                            </tr>                                                        
                            <%if(emp4.getVat_amt()==0){%>
                            <tr>
                                <td align=left>&nbsp;&nbsp;* <span style="color:#476299;"><b><%if(incom_st.equals("2")){%>����ҵ�<%}else if(incom_st.equals("3")){%>��Ÿ����ҵ�<%}%>��������</b></span>�� �ʿ��Ͻ� ���� ���������<!--<span style="color:#476299;"><b><%=user_bean.getUser_nm()%> <%=user_bean.getUser_pos()%> (TEL. <%=user_bean.getUser_m_tel()%>)</b></span>-->���� �����Ͻñ� �ٶ��ϴ�.</td>
                            </tr>
                            <%}%>
                            <%}%>
                        </table>
                    </td>
                </tr> 
                <tr>
                    <td height=30>&nbsp;</td>
                </tr>
                <tr>
                    <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
                </tr>
                <tr>
			        <td align=center height=50 style="font-family:nanumgothic;font-size:11px;">�� ������ �߽����� �����̹Ƿ� �ñ��� ������ <a href=mailto:tax@amazoncar.co.kr><span style="font-size:11px;color:#af2f98;font-family:nanumgothic;">���Ÿ���(tax@amazoncar.co.kr)</span></a>�� �����ֽñ� �ٶ��ϴ�.</span></td>
			    </tr>
                <tr>
                    <td align=center><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
                </tr>
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td>
                        <table width=700 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=35>&nbsp;</td>
                                <td width=82><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_logo.png></td>
                                <td width=28>&nbsp;</td>
                                <td width=1 bgcolor=dbdbdb></td>
                                <td width=32>&nbsp;</td>
                                <td width=523><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                            </tr>
                            <map name=Map1>
                                <area shape=rect coords=283,53,403,67 href=mailto:webmaster@amazoncar.co.kr>
                            </map>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
            </table>
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/s_man/images/up_4.gif width=730 height=27></td>
    </tr>
</table>
</body>
</html>
