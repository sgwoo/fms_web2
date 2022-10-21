<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>


<%
	String m_id 	= request.getParameter("m_id")==null?"002316":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"S105YNCL00040":request.getParameter("l_cd");
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
	
	int tae_sum = af_db.getTaeCnt(m_id);
	
	Vector fee_scd = new Vector();
	int fee_scd_size = 0;
	//�Ǻ� �뿩�� ������ ����Ʈ
	if(rent_st.equals("")){
		fee_scd = af_db.getFeeScdMail(l_cd);
		fee_scd_size = fee_scd.size();
	}else{
		fee_scd = af_db.getFeeScdEmailRentst(l_cd, rent_st, "");//fee.getPrv_mon_yn()
		fee_scd_size = fee_scd.size();
		if(!rent_st.equals("1")) tae_sum=0;
	}
	
	
	//���������
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("���ݰ�꼭�����"));
	
	//���¹�ȣ *�� ������
	int acc_len = cms.getCms_acc_no().length();
	String acc_no = "";
	String acc_no1 = "";
	String acc_no2 = "";
	if(acc_len > 0){
		if(cms.getCms_acc_no().lastIndexOf("-") == -1){
			acc_no1 = "*******";
			if(acc_len > 7){
				acc_no2 = cms.getCms_acc_no().substring(7,acc_len);
			}
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
	if(car_no_len > 3){
		car_no = String.valueOf(base.get("CAR_NO")).substring(0,car_no_len-2)+"**";
	}
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>�Ƹ���ī ���뿩 �̿�ȳ���</title>
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
                                            <td height=50 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_title.gif width=283 height=22></td>
                                        </tr>
                                   <!-- ��ü�� -->
                                        <tr>
                                            <td height=30 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span class=style1><span class=style1><b><%=base.get("FIRM_NM")%></b></span>&nbsp;<span class=style2>�� ����</span> </span></td>
                                        </tr>
                                   <!-- ��ü�� -->
                                        <tr>
                                            <td height=11></td>
                                        </tr>
                                        <tr>
                                            <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_line_up.gif width=410 height=3></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor=f7f7f7>
                                                <table width=411 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan=3 height=16></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=12>&nbsp;</td>
                                                        <td width=386 align=left>
                                                            <table width=386 border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=18><span class=style2>�ֻ��� ���񽺸� �����ϴ� ��ⷻƮ ���� ȸ�� (��)�Ƹ���ī�� �̿���</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>�ּż� �����մϴ�. ������ ������ �̿��Ͻ� ���� (��)�Ƹ���ī����</span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td height=18><span class=style2>���� ��� �� �뿩��� �����Դϴ�. ������ �����Ͻñ� �ٶ��ϴ�. </span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=12>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 height=14></td>
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
                                            <td align=left>&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_1.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=4></td>
                                        </tr>
                              <!-- ����� ��ȭ��ȣ -->
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=h_user.getUser_nm()%></strong></span><!--[$user_h_tel$]--> </td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=h_user.getHot_tel()%></strong></span><!--[$user_h_tel$]--></td>
                                        </tr>
                                        <tr>
                                            <td height=8></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_2.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=b_user.getUser_nm()%></strong></span></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;<span class=style3><strong><%=b_user.getUser_m_tel()%></strong></span></td>
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_1.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                          <!-- ������ -->
                                    <table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=cacaca>
                                        <tr align=center>
                                            <td width=225 height=24 bgcolor=f2f2f2><span class=style4>�뿩����</span></td>
                                            <td width=148 bgcolor=f2f2f2><span class=style4>���뿩��(VAT����)</span></td>
                                            <td width=120 bgcolor=f2f2f2><span class=style4>���뿩������</span></td>
                                            <td width=150 bgcolor=f2f2f2><span class=style4>���ô뿩��(VAT����)</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center><span class=style5><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span></td>
                                            <td align=center><span class=style6><%= Util.parseDecimal(fee.getFee_s_amt()) %>��</span></td>
                                            <td align=center><span class=style7><%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>��</span></td>
                                            <td align=center><span class=style7><%=AddUtil.parseDecimal(fee.getIfee_s_amt())%>��</span></td>
                                        </tr>
                                        <tr align=center>
                                            <td height=24 bgcolor=f2f2f2><span class=style4>�뿩�Ⱓ</span></td>
                                            <td bgcolor=f2f2f2><span class=style4>�뿩������</span></td>
                                            <td bgcolor=f2f2f2><span class=style4>�뿩������</span></td>
                                            <td bgcolor=f2f2f2><span class=style4>���</span></td>
                                        </tr>
                                        <tr align=center bgcolor=#FFFFFF>
                                            <td height=27><span class=style7><%=fee.getCon_mon()%>����</span></td>
                                            <td><span class=style7><%=fee.getRent_start_dt()%></span></td>
                                            <td><span class=style7><%=fee.getRent_end_dt()%></span></td>
                                            <td><span class=style7><%=car_no%></span></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_2.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_up.gif width=648 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=608>
                                       <!-- �뿩�� �Աݾȳ� -->
                                                <table width=608 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=20 align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/arrow.gif> 
                                                        <span class=style2>������ �뿩�� �������� �ſ� <span class=style8><font size=2><b><%if(fee.getFee_est_day().equals("99")){%>����<%}else{%><%= fee.getFee_est_day() %><%}%></b></font></span>���Դϴ�.</span></td></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/arrow.gif> 
                                                        <span class=style2>������ ������ ���Ͻô� ��� (��)�Ƹ���ī �ѹ��� <span class=style5>(Tel.02-392-4243)</span>���� ��û�� �ֽñ� �ٶ��ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left>&nbsp;&nbsp;&nbsp;&nbsp;<span class=style2>(������ ���� ������ �뿩�� ���� ��� û���� �߻��� �� �ֽ��ϴ�.)</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20 align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/arrow.gif> 
                                                        <span class=style2>�Աݿ������ڰ� <span class=style5>������/�ָ�</span>�� ��� <span class=style5>����</span>�� �Աݿ��������Դϴ�.</span></td>
                                                    </tr>
													
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=4></td>
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_3.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>
                         		<!-- �뿩���Ա� ������ -->
                                    <table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td width=35 height=24 align=center><span class=style9>ȸ��</span></td>
                                            <td width=165 align=center><span class=style9>���Ⱓ</span></td>
                                            <td width=110 align=center><span class=style9>�Աݿ�������</span></td>
                                            <td width=100 align=center><span class=style9>���ް�</span></td>
                                            <td width=100 align=center><span class=style9>�ΰ���</span></td>
                                            <td width=131 align=center><span class=style9>���뿩��</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td colspan=6>
                                                <table width=646 border=0 cellspacing=0 cellpadding=0>
        										<% 	if(fee_scd_size>0){
														for(int i = 0 ; i < fee_scd_size ; i++){
															FeeScdBean scd = (FeeScdBean)fee_scd.elementAt(i);%>												
                                                    <tr <%if(i%2 != 0){%>bgcolor=f7fae5<%}%>>
                                                        <td width=36 height=18 align=center>
                                                          <span class=style10>
                                                            <%if(scd.getTm_st2().equals("2")){%>b<%}%>
                                                            <%=scd.getFee_tm()%>
                                                          </span>
                                                        </td>
                                                        <td width=166 align=center><span class=style12><%=AddUtil.ChangeDate2(scd.getUse_s_dt())%> ~ <%=AddUtil.ChangeDate2(scd.getUse_e_dt())%> </span></td>
                                                        <td width=111 align=center><span class=style11><%=AddUtil.ChangeDate2(scd.getFee_est_dt())%></span></td>
                                                        <td width=101 align=right><span class=style12><%=Util.parseDecimal(scd.getFee_s_amt())%></span>&nbsp;&nbsp;</td>
                                                        <td width=101 align=right><span class=style12><%=Util.parseDecimal(scd.getFee_v_amt())%></span>&nbsp;&nbsp;</td>
                                                        <td width=131 align=right><span class=style11><b><%=Util.parseDecimal(scd.getFee_s_amt()+scd.getFee_v_amt())%></b> </span>&nbsp;&nbsp;</td>
                                                    </tr>
												<%}}%>	
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                            <!-- �뿩���Ա� ������ -->
                                </td>
                            </tr>
							<%if(tae_sum>0){%>
                            <tr>
                                <td height=20>(ȸ���� b�� ǥ�õ� ���� <%if(String.valueOf(base.get("CAR_NO")).equals(taecha.getCar_no())){%>�����Ī����<%}else{%>���������<%}%> �������Դϴ�.)</td>
                            </tr>
							<%}%>
                            <tr>
                                <td height=30></td>
                            </tr>
                     		<!-- �Աݹ�� : ������ -->							
							<%if(cms.getRent_l_cd().equals("")){%>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_4.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>							
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank.gif></td>
                            </tr>
                     		<!-- �Աݹ�� : �ڵ���ü -->							
							<%}else{%>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_4_1.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>							
                            <tr>
                                <td>
                                    <table width=648 border=0 cellpadding=0 cellspacing=0 bgcolor=f4f1e6>
                                        <tr>
                                            <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_up.gif width=648 height=4></td>
                                        </tr>
                                        <tr>
                                            <td width=22>&nbsp;</td>
                                            <td width=175><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_1.gif width=175 height=109></td>
                                            <td width=14>&nbsp;</td>
                                            <td width=418>
                                                <table width=418 border=0 cellpadding=0 cellspacing=0 background=http://fms1.amazoncar.co.kr/mailing/rent/images/bank_c_bg.gif>
                                                    <tr>
                                                        <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_c_up.gif width=418 height=3></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=5 height=10></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=20 height=20>&nbsp;</td>
                                                        <td width=12 align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td width=115 align=left><span class=style15>��û���� �ŷ�����</span></td>
                                                        <td width=20><span class=style16>|</span></td>
                                                        <td width=251 align=left><span class=style2><%=cms.getCms_bank()%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;</td>
                                                        <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td align=left><span class=style15>��û���¹�ȣ</span></td>
                                                        <td><span class=style16>|</span></td>
                                                        <td align=left><span class=style2><%=acc_no%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;</td>
                                                        <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td align=left><span class=style15>������������</span></td>
                                                        <td><span class=style16>|</span></td>
                                                        <td align=left><span class=style2><%=AddUtil.ChangeDate2(cms.getCms_start_dt())%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;</td>
                                                        <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td align=left><span class=style15>��������������</span></td>
                                                        <td><span class=style16>|</span></td>
                                                        <td align=left><span class=style2><%=AddUtil.ChangeDate2(cms.getCms_end_dt())%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20>&nbsp;</td>
                                                        <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                                        <td align=left><span class=style15>��ü��</span></td>
                                                        <td><span class=style16>|</span></td>
                                                        <td align=left><span class=style5>�ſ� <%=cms.getCms_day()%>��</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=5 height=7></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_c_dw.gif width=418 height=3></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=19>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_dw.gif width=648 height=4></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
							<%}%>							
                     <!-- �Աݹ�� -->
                            <tr>
                                <td height=15></td>
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