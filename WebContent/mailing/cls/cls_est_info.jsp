<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%
	String m_id 	= request.getParameter("m_id")==null?"002316":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"S105YNCL00040":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");

	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//���������
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("����������"));
	
		//��������
	//�����Ƿ�����
	ClsEstBean cls = ac_db.getClsEstCase(m_id, l_cd);
	String cls_st = cls.getCls_st_r();
			

	//�⺻����
	Hashtable fee_base = af_db.getFeebasecls3(m_id, l_cd);
	
		//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(m_id, l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//��꼭 ���࿩��
	Hashtable cls_tax = ac_db.getClsGetTaxYN(m_id, l_cd);
	
//	System.out.println("hash size="+cls_tax.size() );


		//fee ��Ÿ - ����Ÿ� �ʰ��� ���  - fee_etc ��  over_run_amt > 0���� ū ��� �ش��
	ContCarBean  car1 = a_db.getContFeeEtc(m_id, l_cd, Integer.toString(fee_size));
	

	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>�Ƹ���ī ���뿩 �������� ��������  �ȳ���</title>
<style type="text/css">
<!--
.style1 {color: #88b228}
.style2 {color: #747474}
.style3 {color: #ffffff}
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #8c8c8c}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
.style15 {color: #53544e;}
.style16 {color: #ff00ff;}
-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

</head>
<body topmargin=0 leftmargin=0>
<form name='form1' method='post' >
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>            		
                    <td width=114 valign=baseline>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif></td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
    		<!-- ��¥ -->
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=450>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width=250 align=right style="font-family:nanumgothic;font-size:12px;"><b><%= AddUtil.getDate() %></b>&nbsp;&nbsp;&nbsp;</td>
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
            <table width=677 border=0 cellspacing=0 cellpadding=0 style="background:url(https://fms5.amazoncar.co.kr/mailing/images/img_top.gif) no-repeat;">
                <tr>
                    <td width=464 valign=top>
                        <table width=464 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td>&nbsp;</td>
                                <td align=center>
                                    <table width=411 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=50 align=left>&nbsp;&nbsp;
                                         <% if (cls_st.equals("1")) {%>
                                            <img src=https://fms5.amazoncar.co.kr/mailing/cls/images/gyml_info.gif>
                                         <% } else  if (cls_st.equals("2"))  { %>   
                                            <img src=https://fms5.amazoncar.co.kr/mailing/cls/images/hjjs_info.gif>
                                         <% } else  if (cls_st.equals("8"))  { %>   
                                         <!--���Կɼ��ϰ�� -->
                                         <img src=https://fms5.amazoncar.co.kr/mailing/cls/images/opt_info.gif>
                                         <% } %>
                                         </td>
                                        </tr>
                                   <!-- ��ü�� -->
                                        <tr>
                                            <td height=30 align=left style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span style="color:#747474;"><b><%=base.get("FIRM_NM")%></b></span>&nbsp;�� ����</td>
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
                                                <table width=400 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td colspan=3 height=7></td>
                                                    </tr>
                                                    <tr>
                                                        <td width=12>&nbsp;</td>
                                                        <td width=386 align=left>
                                                            <table width=386 border=0 cellspacing=0 cellpadding=0>
                                                                <tr>
                                                                    <td height=15><span style="font-family:nanumgothic;font-size:13px;"><span style="color:#88b228;"><b>[<%=base.get("CAR_NO")%>]</b></span> ������ �����곻���Դϴ�.<br>
                                                                	���ݱ��� �Ƹ���ī�� �̿��� �ּż� �������� ����帮��, ������ �κ�
                                                                	�� �־��ٸ� �ʱ׷��� ������ �ֽʽÿ�. ����� ������ ������� �ٽ�
                                                                	ã�ƺ˰ڽ��ϴ�.</span></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width=12>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=3 height=7></td>
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
                        </table>
                    </td>
                    <td width=26>&nbsp;</td>
                    <td width=187 valign=top>
            			<table width=187 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=187  height=233>
                                    <table width=187 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=50 align=left></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;&nbsp;&nbsp; <img src=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_1.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=4></td>
                                        </tr>
                              <!-- ����� ��ȭ��ȣ -->
                                        <tr>
                                            <td align=left height=17 style="font-family:nanumgothic;font-size:13px;color:#FFFFFF;font-weight:bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;<%=h_user.getUser_nm()%><!--[$user_h_tel$]--> </td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17 style="font-family:nanumgothic;font-size:13px;color:#FFFFFF;font-weight:bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;<%=h_user.getHot_tel()%><!--[$user_h_tel$]--></td>
                                        </tr>
                                        <tr>
                                            <td height=8></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;&nbsp;&nbsp; <img src=https://fms5.amazoncar.co.kr/mailing/car_adm/images/sup.gif></td>
                                        </tr>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17 style="font-family:nanumgothic;font-size:13px;color:#FFFFFF;font-weight:bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;<%=b_user.getUser_nm()%></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17 style="font-family:nanumgothic;font-size:13px;color:#FFFFFF;font-weight:bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;<%=b_user.getUser_m_tel()%></td>
                                        </tr>
                              <!-- ����� ��ȭ��ȣ -->
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
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/cls/images/bar_1.gif width=648 height=21></td>
                            </tr>
                            <tr>
                                <td height=25></td>
                            </tr>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/cls/images/subbar_5.gif></td>
                            </tr>
                            <tr>
                                <td height=3></td>
                            </tr>
                            <tr>
                            	<td bgcolor=cacaca height=1></td>
							</tr>
                     		<tr>
              					<td>
                           			<table border="0" cellspacing="1" cellpadding="0" width="100%" bgcolor=cacaca>
			   							<tr> 
			                  				<td bgcolor=f2f2f2 align='center' height=24 style="font-family:nanumgothic;font-size:12px;">����ȣ</td>
			                  				<td colspan=5 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=l_cd%></td>
			                			</tr>
			                			<tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 width=12% style="font-family:nanumgothic;font-size:12px;">��ȣ</td>
			                		        <td bgcolor=ffffff width=26% style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("FIRM_NM")%></td>
			                		        <td bgcolor=f2f2f2 align=center width=12% style="font-family:nanumgothic;font-size:12px;">����</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
			                		        <td bgcolor=f2f2f2 align=center width=12% style="font-family:nanumgothic;font-size:12px;">������ȣ</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("CAR_NO")%></td>
                                        </tr>
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">����</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("CAR_NM")%></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">���ʵ����</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("INIT_REG_DT")%></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">�뿩���</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;
			                		         <%if(fee_base.get("RENT_WAY").equals("1")){%>
									              �Ϲݽ� 
									              <%}else if(fee_base.get("RENT_WAY").equals("2")){%>
									              ����� 
									              <%}else{%>
									              �⺻�� 
									              <%}%>			                		        
			                		        </td>
                                        </tr>
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">�뿩�Ⱓ</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;
			                		        <%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~&nbsp; 
              <%if(fee_size == 1){ out.println(AddUtil.ChangeDate2(fee.getRent_end_dt())); }else{ out.println(AddUtil.ChangeDate2(ext_fee.getRent_end_dt())); }%>
			                		        </td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">���Ⱓ</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;
			                		          <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=fee.getCon_mon()%> <!-- //AddUtil.parseInt((String)fee.get("CON_MON")) -->
              <%}else{%>
              <%//=fee_base.get("TOT_CON_MON")%>
			  <%int con_mon= 0;
			   	for(int i=0; i<fee_size; i++){
					ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i+1));
					con_mon = con_mon+ AddUtil.parseInt(fees.getCon_mon());
				}
				%>					
			  <%=con_mon%> 
              <%}%>			
			                		        ����</td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">���뿩��</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;
			                		          <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%> 
              <%}else{%>
              <%//=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_FEE_AMT")))%> 
			  <%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%> 
              <%}%>
			                		        ��</td>
                                        </tr>
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">������</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<span style="color:#e60011;">
			                		             <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("PP_AMT"))%> 
              <%}else{%>
              <%//=AddUtil.parseDecimal((String)fee_base.get("EX_PP_AMT"))%> 
			  <%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%> 
              <%}%>
			                		         ��</span></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">���ô뿩��</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<span style="color:#e60011;">
			                		          <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("IFEE_AMT"))%> 
              <%}else{%>
              <%//=AddUtil.parseDecimal((String)fee_base.get("EX_IFEE_AMT"))%>
			  <%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>  
              <%}%>
			                		        ��</span></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">������</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<span style="color:#e60011;">
			                		          <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("GRT_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_GRT_AMT"))%> 
              <%}%>
			                		        ��</span></td>
                                        </tr>
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">��������</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=cls.getCls_st()%></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">������</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">�̿�Ⱓ</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=cls.getR_mon()%>���� <%=cls.getR_day()%>��</td>
                                        </tr>
                                  <% if (  cls_st.equals("8") ) {%>            
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">���ԿɼǱݾ�</td>
			                		        <td colspan=5 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<span style="color:#e60011;"><%=AddUtil.parseDecimal(cls.getOpt_amt())%> �� </span> ( VAT���� ) </td>
			                		       </tr>
                                  <% } %>
                                   <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">����Ÿ�</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=AddUtil.parseDecimal(cls.getTot_dist() )%> km</td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">�������ϸ���(��)</td>
			                		        <td colspan=3  bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>			                		      
                                     </tr>
                                     
                                	</table>
                               </td>
                            </tr>    
                            <tr>
                                <td height=20></td>
                            </tr>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/cls/images/subbar_1.gif></td>
                            </tr>
                            <tr>
                                <td height=3></td>
                            </tr>
                            <tr>
                            	<td bgcolor=cacaca height=1></td>
                          	</tr>
                            <tr>
                                <td>
                          <!-- �����ݾ� ���� -->
                                    <table border="0" cellspacing="1" cellpadding="0" width="100%" bgcolor=cacaca>
            			                <tr> 
            			                  <td bgcolor=f2f2f2 align='center' colspan="3" height=27 style="font-family:nanumgothic;font-size:12px;">�׸�</td>
            			                  <td bgcolor=f2f2f2 width='30%' align="center" style="font-family:nanumgothic;font-size:12px;">����</td>
            			                  <td bgcolor=f2f2f2 width="37%" align='center' style="font-family:nanumgothic;font-size:12px;">���</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb rowspan="7" align=center style="font-family:nanumgothic;font-size:12px;">ȯ<br>
            			                    ��<br>
            			                    ��<br>
            			                    ��</td>
            			                  <td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">������(A)</span></td>
            			                  <td width="30%" bgcolor=ecf9fb align=right style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getGrt_amt())%> ��</td>
            			                  <td bgcolor=ecf9fb>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb rowspan="3" align=center style="font-family:nanumgothic;font-size:12px;">��<br>
            			                    ��<br>
            			                    ��<br>
            			                    ��<br>
            			                    ��</td>
            			                  <td bgcolor=ffffff width="22%" align="center" height=24 style="font-family:nanumgothic;font-size:12px;">����Ⱓ</td>
            			                  <td bgcolor=ffffff width="30%" align="center" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=cls.getIfee_mon()%>  ����&nbsp;&nbsp;&nbsp;<%=cls.getIfee_day()%>  ��</td>
            			                  <td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr>
            			                  <td bgcolor=ffffff align="center"  height=24 style="font-family:nanumgothic;font-size:12px;">����ݾ�</td>
            			                  <td bgcolor=ffffff  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>  ��</td>
            			                  <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= ���ô뿩�᡿����Ⱓ</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb align=center  height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">�ܿ� ���ô뿩��(B)</span></td>
            			                  <td bgcolor=ecf9fb  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>  ��</td>
            			                  <td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;= ���ô뿩��-����ݾ�</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb rowspan="3" align=center style="font-family:nanumgothic;font-size:12px;">��<br>
            			                    ��<br>
            			                    ��</td>
            			                  <td bgcolor=ffffff align='center'  height=24 style="font-family:nanumgothic;font-size:12px;">��������</td>
            			                  <td bgcolor=ffffff  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getPded_s_amt())%> ��</td>
            			                  <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= �����ݡ����Ⱓ</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ffffff align='center'  height=24 style="font-family:nanumgothic;font-size:12px;">������ �����Ѿ�</td>
            			                  <td bgcolor=ffffff  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getTpded_s_amt())%> ��</td>
            			                  <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= �������ס����̿�Ⱓ</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb align=center  height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">�ܿ� ������(C)</span></td>
            			                  <td bgcolor=ecf9fb  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>  ��</td>
            			                  <td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;= ������-������ �����Ѿ�</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=fffdcb align=center colspan="3" height=27 style="font-family:nanumgothic;font-size:12px;">��</td>
            			                  <td bgcolor=fffdcb  align="right" style="font-family:nanumgothic;font-weight:bold;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getGrt_amt()+cls.getRifee_s_amt()+cls.getRfee_s_amt())%>  ��</td>
            			                  <td bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;= (A+B+C)</td>
            			                </tr>
            			             
            			            </table>
            			                    			            
            			          
            			       <!-- �����ݾ� ���� -->
                                </td>
                            </tr>
                            <tr>
                                <td align=right height=19 style="font-family:nanumgothic;font-size:12px;">[���ް�]</td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/cls/images/subbar_2.gif></td>
                            </tr>
                            <tr>
                                <td height=3></td>
                            </tr>
                            <tr>
                            	<td bgcolor=cacaca height=1></td>
                          	</tr>
                            <tr>
                                <td>
                         		<!-- �̳��Աݾ� ���� -->
                                    <table border="0" cellspacing="1" cellpadding="0" width=100% bgcolor=cacaca>
            			                <tr> 
            			                  	<td bgcolor=f2f2f2 colspan="4" align="center" height=27 style="font-family:nanumgothic;font-size:12px;">�׸�</td>
            			                  	<td bgcolor=f2f2f2 width='30%' align="center" style="font-family:nanumgothic;font-size:12px;">����</td>
            			                  	<td bgcolor=f2f2f2 width='37%' align="center" style="font-family:nanumgothic;font-size:12px;">���</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb rowspan="19" align="center" width=5% style="font-family:nanumgothic;font-size:12px;">��<br>
            			                    ��<br>
            			                    ��<br>
            			                    ��<br>
            			                    ��</td>
            			                  	<td bgcolor=ecf9fb colspan="3" align="center" height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">���·�/��Ģ��(D)</span></td>
            			                  	<td bgcolor=ecf9fb width='30%' align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getFine_amt_1())%>  ��</td>
            			                  	<td bgcolor=ecf9fb width='37%' style="font-family:nanumgothic;font-size:12px;">&nbsp;* ���·�߻��� ����ں������� ���� ���ұ������ ���� û���մϴ�.</td>
            			                 </tr>
            			                 <tr> 
            			                  	<td bgcolor=ecf9fb colspan="3" align="center" height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">�ڱ��������ظ�å��(E)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;">
            			                    <%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>  ��</td>
            			                  	<td bgcolor=ecf9fb>&nbsp;</td>
            			                </tr>
            			                 <tr>
            			                  	<td bgcolor=ecf9fb rowspan="5" align="center" style="font-family:nanumgothic;font-size:12px;"><br>
            			                    ��<br>
            			                    ��<br>
            			                    ��</td>
            			                  	<td bgcolor=ffffff width=23% align="center" colspan="2" align="center" height=24 style="font-family:nanumgothic;font-size:12px;">������</td>
            			                  	<td bgcolor=ffffff align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>  ��</td>
            			                  	<td width='35%' bgcolor=ffffff>&nbsp; </td>
            			                </tr>
            			                            			            
            			                <tr> 
            			                  	<td rowspan="2" align="center" bgcolor=ffffff width=5% style="font-family:nanumgothic;font-size:12px;">��<br>
            			                    ��<br>
            			                    ��</td>
            			                  	<td align="center" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">�Ⱓ</td>
            			                  	<td align="center" bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;"> 
            			                    	<%=cls.getNfee_mon()%>  ����&nbsp;&nbsp;&nbsp;<%=cls.getNfee_day()%> ��</td>
            			                  	<td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td align="center" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">�ݾ�</td>
            			                  	<td  align="right" bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;"> 
            			                    	<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%> ��</td>
            			                  	<td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;���� ���ݰ�꼭 ����</td>
            			                </tr>
            			                <tr> 
            			                  	<td colspan="2" align="center" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">��ü��</td>
            			                  	<td align="right" bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getDly_amt_1())%>  ��</td>
            			                  	<td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" align="center" height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">�Ұ�(F)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;">  
            			                    <%=AddUtil.parseDecimal(cls.getEx_di_amt_1() + cls.getNfee_amt_1() + cls.getDly_amt_1())%>  ��</td>
            			                  	<td bgcolor=ecf9fb>&nbsp;</td>
            			                </tr>            			              
            			                <tr> 
            			                  	<td rowspan="6" align="center" bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">��<br>
            			                    ��<br>
            			                    ��<br>
            			                    ��<br>
            			                    ��<br>
            			                    ��<br>
            			                    ��</td>
            			                  	<td align="center" colspan="2" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">�뿩���Ѿ�</td>
            			                  	<td align="right" bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">  
            			                    <%=AddUtil.parseDecimal(cls.getTfee_amt())%>  ��</td>
            			                  	<td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= ������+���뿩���Ѿ�</td>
            			                </tr>
            			                <tr> 
            			                  	<td align="center" colspan="2" height=24 bgcolor=fffff style="font-family:nanumgothic;font-size:12px;">���뿩��(ȯ��)</td>
            			                  	<td bgcolor=ffffff align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getMfee_amt())%>  ��</td>
            			                  	<td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= �뿩���Ѿס����Ⱓ</td>
            			                </tr>
            			                <tr> 
            			                  	<td align="center" colspan="2" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">�ܿ��뿩���Ⱓ</td>
            			                  	<td bgcolor=ffffff align="center" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=cls.getRcon_mon()%> ����&nbsp;&nbsp;&nbsp;<%=cls.getRcon_day()%> ��</td>
            			                  	<td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ffffff colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
            			                  	<td bgcolor=ffffff align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getTrfee_amt())%>  ��</td>
            			                  	<td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ffffff align="center" colspan="2" height=24 style="font-family:nanumgothic;font-size:12px;">����� 
            			                    �������</td>
            			                  	<td bgcolor=ffffff align="center" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=cls.getDft_int()%>  %</td>
            			                  	<td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;�ܿ��Ⱓ �뿩�� �Ѿ� ����</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=fffdcb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">�ߵ����������(G)</span></td>
            			                  	<td bgcolor=fffdcb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getDft_amt_1())%>  ��</td>
            			                  	<td bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			              <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK0").equals("Y")  ) {%>            			                  			                  
            			                 			 ���� ���ݰ�꼭 ����
            			              <%     }            			               			 
            			              	 } %>    
            			                  	&nbsp;</td>
            			                </tr>      
            			           
            			                <tr> 
            			                  	<td bgcolor=ecf9fb rowspan="6" align=center style="font-family:nanumgothic;font-size:12px;"><br>
            			                    ��<br>
            			                    Ÿ</td> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">����ȸ�����ֺ��(H)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>  ��</td>
            			                  	<td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			                <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK1").equals("Y")  ) {%>            			                  			                  
            			                 			 ���� ���ݰ�꼭 ����
            			              <%     }            			               			 
            			              	 } %>      
            			                  	&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">����ȸ���δ���(I)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>  ��</td>
            			                  	<td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			              <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK2").equals("Y")  ) {%>            			                  			                  
            			                 			 ���� ���ݰ�꼭 ����
            			              <%     }            			               			 
            			              	 } %>       
            			                  	&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">������������(J)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>  ��</td>
            			                  	<td bgcolor=ecf9fb>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">��Ÿ���ع���(K)</span></td>
            			                  	<td bgcolor=ecf9fb align="right"> 
            			                    <span style="font-family:nanumgothic;font-size:12px;"><%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%> ��</span></td>
            			                  	<td bgcolor=ecf9fb height=24 style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			                <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK3").equals("Y")  ) {%>            			                  			                  
            			                 			 ���� ���ݰ�꼭 ����
            			              <%     }            			               			 
            			              	 } %>    
            			                  	&nbsp;</td>
            			                </tr>            			                
            			                
            			                
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">�ʰ�����뿩��(L)</span></td>
            			                  	<td bgcolor=ecf9fb align="right"> 
            			                    <span style="font-family:nanumgothic;font-size:12px;"><%=AddUtil.parseDecimal(cls.getOver_amt_1())%> ��</span></td>
            			                  	<td bgcolor=ecf9fb height=24 style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			                <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK4").equals("Y")  ) {%>            			                  			                  
            			                 			 ���� ���ݰ�꼭 ����
            			              <%     }            			               			 
            			              	 } %>    
            			                  	&nbsp;</td>
            			                </tr>        			          
            			            
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=32 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">�ΰ���(M)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>  ��</td>
            			                  	<td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;= (�뿩��̳��Աݾ�-B-C)��10% + ��꼭 ����<br>&nbsp;&nbsp;&nbsp;&nbsp;�ΰ���</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=fffdcb colspan="4" height=27 align=center style="font-family:nanumgothic;font-size:12px;">��</td>
            			                  	<td bgcolor=fffdcb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                   <%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>  ��</td>
            			                  	<td bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;= (D+E+F+G+H+I+J+K+L+M)</td>
            			                </tr>
            			            </table>
                            <!-- �̳��Աݾ� ���� -->
                                </td>
                            </tr>
                            <tr>
                                <td align=right height=18 style="font-family:nanumgothic;font-size:12px;">[���ް�]</td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/cls/images/subbar_3.gif></td>
                            </tr>
                            <tr>
                                <td height=3></td>
                            </tr>
                            <tr>
                            	<td bgcolor=cacaca height=1></td>
                          	</tr>
                            <tr>
                                <td>
                                    <table border="0" cellspacing="1" cellpadding="0" width="100%" bgcolor=cacaca>
                                       <% if (  !cls_st.equals("8") ) {%> 
            			                <tr> 
            			                  <td bgcolor=f2f2f2 align='center' height=27 style="font-family:nanumgothic;font-size:12px;"><span style="color:#e60011;">*</span> �����Աݾ�</td>
            			                  <td width="30%" bgcolor=fffdcb align=right style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getFdft_amt2())%> ��</td>
            			                  <td width="37%" bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;= �̳��Աݾ�-ȯ�ұݾװ�</td>
            			                </tr>
            			              <% } %>   
            			              <% if (  cls_st.equals("8") ) {%>  
            			                 <tr>            
									    	    <td bgcolor=f2f2f2 align='center' height=27 style="font-family:nanumgothic;font-size:12px;"><span style="color:#e60011;">*</span> ���Կɼǽ� �����Աݾ�</td>
							                  <td width="30%" bgcolor=fffdcb align=right style="font-family:nanumgothic;font-size:12px;"> 
							                    <%=AddUtil.parseDecimal(cls.getFdft_amt3())%>   ��</td>							                
							                  <td width="37%" bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;=�����Աݾ�+�����Ű��ݾ�+������Ϻ��(�߻��� ���)</td>										                  						                  
							                </tr>
                                   <% } %> 
			                        </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=20></td>
                            </tr>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/cls/images/subbar_4.gif></td>
                            </tr>
                            <tr>
                                <td height=3></td>
                            </tr>
                            <tr>
                            	<td bgcolor=cacaca height=1></td>
                          	</tr>
				            <tr>
				              <%	//���ຸ������
											ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);%>
				
                                <td>
                                    <table border="0" cellspacing="1" cellpadding="0" width="100%" bgcolor=cacaca>
            			                <tr> 
            			                  <td bgcolor=f2f2f2 align='center' height=27 style="font-family:nanumgothic;font-size:12px;">
            			                  <%if(gins.getGi_st().equals("1")){%>����<%}else if(gins.getGi_st().equals("0")){ gins.setGi_amt(0);%>����<%}%>
            			                  </td>
            			                  <td width="30%" bgcolor=ffffff align=right style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(gins.getGi_amt())%>   ��</td>
            			                  <td width="37%" bgcolor=ffffff>&nbsp;&nbsp;</td>
            			                </tr>
			                        </table>
                                </td>
                            </tr>
                            <tr>
                                <td height=40></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/cls/images/bar_2.gif width=648 height=22></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td style="border:1px solid #cacaca; margin:0px; border-radius:8px; border-collapse: separate;padding:20px; border-spacing: 0;">
                                	<table border=0 cellspacing=0 cellpadding=0>
                                		<tr>
                                			<td><img src=https://fms5.amazoncar.co.kr/mailing/cls/images/bar_bank01.gif></td>
                                		</tr>
                                		<tr>
                                			<td height=10></td>
                                		</tr>
                                		<tr>
                                			<td style="font-family:nanumgothic;font-size:13px;line-height:22px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#385c9d;"><b>��������</b></span> &nbsp; 140-004-023871 &nbsp;&nbsp;&nbsp;&nbsp;
                                				<span style="color:#385c9d;"><b>�츮����</b></span> &nbsp; 103-293206-13-001 &nbsp;&nbsp;&nbsp;&nbsp;
                                				<span style="color:#385c9d;"><b>��������</b></span> &nbsp; 367-17-014214
                                			</td>
                                		</tr>
                                		<tr>
                                			<td height=10></td>
                                		</tr>
                                		<tr>
                                			<td><img src=https://fms5.amazoncar.co.kr/mailing/cls/images/bar_bank02.gif></td>
                                		</tr>
                                		<tr>
                                			<td height=10></td>
                                		</tr>
                                		<tr>
                                			<td style="font-family:nanumgothic;font-size:13px;line-height:22px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)�Ƹ���ī</td>
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
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif style="font-family:nanumgothic;font-size:11px;">* �������꼭�Դϴ�.&nbsp;���� ����� �ݾ� ���̰� ���� �� �ֽ��ϴ�</td>
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif style="font-family:nanumgothic;font-size:11px;">�� ������ �߽����� �����̹Ƿ� �ñ��� ������ <a href=mailto:tax@amazoncar.co.kr><span style="font-size:11px;color:#af2f98;font-family:nanumgothic;">���Ÿ���(tax@amazoncar.co.kr)</span></a>�� �����ֽñ� �ٶ��ϴ�.</td>
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
                    <td width=82><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
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
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;	
		
	//	fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
	//	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));		
	}
//-->
</script>


</body>
</html>