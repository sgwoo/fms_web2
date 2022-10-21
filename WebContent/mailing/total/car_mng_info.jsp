<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insur.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String ins_st 	= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_way 	= request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
	
	if(l_cd.equals("") || l_cd.equals("null")){
		out.println("�������� ȣ���� �ƴմϴ�.");	
		return;
	}
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	//cont
	ContBaseBean cont = a_db.getCont(m_id, l_cd);
	
	//���:������
	ContBaseBean base2 = a_db.getContBaseAll(m_id, l_cd);
	
	//���������
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean b_user2 = b_user;
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("���ݰ�꼭�����"));
	
	if(String.valueOf(base.get("BUS_ST_NM")).equals("������Ʈ")){
		b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID")));
		
		//������Ʈ �����������
		if(!cont.getAgent_emp_id().equals("")){ 
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(cont.getAgent_emp_id()); 
				b_user.setUser_m_tel(a_coe_bean.getEmp_m_tel());
				b_user.setUser_nm		(a_coe_bean.getEmp_nm());
		}
	}
		
	if(ins_st.equals(""))	ins_st = ai_db.getInsSt(String.valueOf(base.get("CAR_MNG_ID")));
	
	//��������
	InsurBean ins = ai_db.getInsCase(String.valueOf(base.get("CAR_MNG_ID")), ins_st);
	
	
	
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>�ڵ��� ���� ���� �ȳ���</title>
<style type="text/css">
<!--
.style1 {color: #88b228;font-size:13px;font-family:nanumgothic;}
.style2 {color: #333333;font-size:13px;font-family:nanumgothic;}
.style3 {color: #ffffff;font-family:nanumgothic;}
.style4 {color: #707166;font-size:13px; font-weight: bold;font-family:nanumgothic;}
.style5 {color: #e86e1b;font-size:13px;font-family:nanumgothic;}
.style6 {color: #385c9d; font-weight: bold;font-family:nanumgothic;}
.style7 {color: #77786b;font-size:13px;font-family:nanumgothic;}
.style8 {color: #e60011;font-family:nanumgothic;}
.style9 {color: #707166; font-weight: bold;font-family:nanumgothic;}
.style10 {color: #454545; font-size:8pt;font-family:nanumgothic;}
.style11 {color: #6b930f; font-size:8pt;font-family:nanumgothic;}
.style12 {color: #77786b; font-size:8pt;font-family:nanumgothic;}
.style13 {color: #ff00ff;font-family:nanumgothic;}
.style14 {color: #af2f98; font-size:8pt;font-family:nanumgothic;}
-->
</style>
<link href=http://fms1.amazoncar.co.kr/acar/main_car_hp/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0 bgcolor=#eef0dc>
<br><br><br><br>
<table width=835 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/tt_bg.gif align=center>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_up.gif width=835 height=55></td>
    </tr>
    <tr>
        <td align=center>
        	<table width=736 border=0 cellspacing=0 cellpadding=0>
	            <tr>
	                <td>
		                <table width=736 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td width=505 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/total_stitle.gif><br><br>
		                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style1><b>[ <%=base.get("FIRM_NM")%> ]</b></span>&nbsp;<span class=style2>��</span> </span></td>
		                        <td width=231>
			                        <table width=231 border=0 cellspacing=0 cellpadding=0>
			                        	<tr>
			                        		<td colspan=2 height=12></td>
			                        	</tr>
			                            <tr>
			                                <td width=75><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_bsn.gif width=68 height=18></td>
			                                <td><span class=style2><%=b_user.getUser_nm()%> <%=b_user.getUser_m_tel()%></span></td>
			                  			</tr>
			                  			<tr>
			                        		<td colspan=2 height=2></td>
			                        	</tr>
			                            <tr>
			                                <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_mng.gif width=68 height=18></td>
			                                <td><span class=style2><%=b_user2.getUser_nm()%> <%=b_user2.getUser_m_tel()%></span></td>
			                       		</tr>
			                       		<tr>
			                        		<td colspan=2 height=2></td>
			                        	</tr>
			                            <tr>
			                                <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_sup_acct.gif width=68 height=18></td>
			                                <td><span class=style2><%=h_user.getUser_nm()%> <%=h_user.getHot_tel()%></span></td>
			                     		</tr>
			                        </table>
			                    </td>
		                    </tr>
		                </table>
		            </td>
	        	</tr>
	            <tr>
	                <td height=25 align=center></td>
	      		</tr>
	            <tr>
	                <td>
		                <table width=736 border=0 cellspacing=0 cellpadding=0>
		                	<%if(String.valueOf(base.get("RENT_WAY")).equals("�⺻��")){%><!--�⺻���ϰ��-->
		                	<tr>
		                		<td width=245><a href=http://fms1.amazoncar.co.kr/mailing/total/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gscd_gr.gif border=0></a></td>
		                		<td width=245><a href=http://fms1.amazoncar.co.kr/mailing/total/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gcfms_gr.gif border=0></a></td>
		                		<td width=245><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_gcar.gif border=0></td>
		                       
		                	</tr>
							<%}else{%>
		                    <tr>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/scd_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_scd_gr.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/fms_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_cfms_gr.gif border=0></a></td>
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/car_mng_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_car.gif border=0></a></td>		                       
		                        <td width=184><a href="http://fms1.amazoncar.co.kr/mailing/total/rep_info.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&rent_st=<%=rent_st%>"><img src=https://fms5.amazoncar.co.kr/mailing/total/images/btn_rep_gr.gif border=0></a></td>

		                    </tr>
							<%}%>
		                </table>
		            </td>
	            </tr>
	            <tr>
	            	<td height=15></td>
	            </tr>
	            <tr>
	                <td align=center>
	                	<table width=683 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td width=567>&nbsp;<span class=style2>&nbsp;</span></td>
		                        <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_car_img.gif>&nbsp;</td>
		                    </tr>
	                	</table>
	               	</td>
	            </tr>
	            <tr>
	                <td align=center>
	                	<table width=683 border=0 cellspacing=0 cellpadding=0>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_1.gif width=683 height=21></td>
		                	</tr>
	                	 	<%if(!ins.getCon_f_nm().equals("�Ƹ���ī")){%>
		                	 <tr>
			          			<td height=24 valign=top><span class=style2>�Ǻ�����:&nbsp;<%=ins.getCon_f_nm()%></span></td>
			  				 </tr>
		  					<%}%>
		                    <tr>
		                        <td>
		                        	<table width=683 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td height=24 align=center><span class=style4>�����</span></td>
                                            <td colspan='2' align=center bgcolor=#FFFFFF><span class=style4>                                                
                                                <%if(ins.getIns_com_id().equals("0007")){%>		�Ｚȭ�� (������� 1588-5114) 
    						<%}else if(ins.getIns_com_id().equals("0008")){%>	����ȭ�� (������� 1588-0100) 
    						<%}else if(ins.getIns_com_id().equals("0038")){%>	����ī�������� (������� 1661-7977)
    						<%}else{%>    						<%=ai_db.getInsComNm(ins.getCar_mng_id())%>
    						<%}%>
                                            </span></td>                                            
                                        </tr>
                                        <tr bgcolor=f2f2f2>
                                            <td width=255 height=24 align=center><span class=style4>�����ڹ���</span></td>
                                            <td width=102 align=center bgcolor=f2f2f2><span class=style4>��������</span></td>
                                            <td width=332 align=center bgcolor=f2f2f2><span class=style4>�������</span></td>
                                        </tr> 
                            <!-- ���ΰ�, �ش�����, ���������뺸�� ���Խ�-->
                            <%if(ins.getCom_emp_yn().equals("Y")){%>
                            			      
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>������ �Ҽ��� �̻�� ���� </span></td>
                                            <td rowspan=3 align=center><span class=style2>
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
												<%if(ins.getAge_scp().equals("5")){%>30���̻�<%}%> 
												<%if(ins.getAge_scp().equals("6")){%>35���̻�<%}%> 
												<%if(ins.getAge_scp().equals("7")){%>43���̻�<%}%> 
												<%if(ins.getAge_scp().equals("8")){%>48���̻�<%}%> 
											<%}%>									
											 </span></td>
                                            <td rowspan=3 align=left style="padding:10px;"><span class=style2>
											<%if(ins.getCar_mng_id().equals("")){%>
								                å��,
												����(����),
												
								                <% if(base2.getGcp_kd().equals("1")){%>�빰(5õ����),<%}%>
								                <% if(base2.getGcp_kd().equals("2")){%>�빰(1���),<%}%>
												<% if(base2.getGcp_kd().equals("4")){%>�빰(2���),<%}%>
												<% if(base2.getGcp_kd().equals("8")){%>�빰(3���),<%}%>
												<% if(base2.getGcp_kd().equals("3")){%>�빰(4���),<%}%>
												
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
												<%if(ins.getVins_gcp_kd().equals("6")){%>�빰(5���),<%}%>
												<%if(ins.getVins_gcp_kd().equals("7")){%>�빰(2���),<%}%>
												
								                <%if(ins.getVins_bacdt_kd().equals("1")){%>�ڱ��ü(3���),<%}%> 
								                <%if(ins.getVins_bacdt_kd().equals("2")){%>�ڱ��ü(1��5õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("6")){%>�ڱ��ü(1���),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("5")){%>�ڱ��ü(5õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("3")){%>�ڱ��ü(3õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("4")){%>�ڱ��ü(1õ5�鸸��),<%}%><br>
												
												<%if(ins.getVins_canoisr_amt()>0){%>������������<%}%><%if(ins.getVins_spe_amt()>0){%>, <%=ins.getVins_spe()%><%}%>	<br>	
												
												<%if(!ins.getCon_f_nm().equals("�Ƹ���ī")){%>
													�� �ڱ���������: ���� <%=AddUtil.parseDecimal(ins.getVins_cacdt_car_amt())%>����, 
													������� �������� <%=AddUtil.parseDecimal(ins.getVins_cacdt_mebase_amt())%>����/
													(�ִ�)�ڱ�δ�� <%=AddUtil.parseDecimal(ins.getVins_cacdt_me_amt())%>���� /
													(�ּ�)�ڱ�δ�� <%=AddUtil.parseDecimal(ins.getVins_cacdt_memin_amt())%>����
			  									<%}else{%>							
													�� �ڱ��������ش� �Ƹ���ī �ڱ��������ظ�å������ �ǰ� ���� (�ڱ�δ�� ���Ǵ� <b>�ְ� <%=AddUtil.parseDecimal(base2.getCar_ja())%>��</b>)
												<%}%>																				
											<%}%>																				
											</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=60 align=center bgcolor=#FFFFFF><span class=style5>������ �Ҽ��� ����</span><br><span class=style7>(����� ���� ����, ��,����� ������ ���<br>���ΰ� ü���� �ٷΰ��Ⱓ�� ����)</span></td>
                                        </tr> 
                                       	<tr bgcolor=#FFFFFF>
                                            <td height=60 align=center bgcolor=#FFFFFF><span class=style5>�������� ������ ���Ͽ� �� �ڵ����� ����<br>�ϴ� �ڷμ� �����ΰ� �����迡 �ִ�<br>��ü�� �Ҽӵ� ��</span></td>
                                        </tr> 
                               <!-- ���ΰ�, �ش�����, ���������뺸�� �̰��Խ�-->   
                               <%}else{%>      
                                        <%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>�����, ������� ����/���� </span></td>
                                            <td rowspan=2 align=center><span class=style2>
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
												<%if(ins.getAge_scp().equals("5")){%>30���̻�<%}%> 
												<%if(ins.getAge_scp().equals("6")){%>35���̻�<%}%> 
												<%if(ins.getAge_scp().equals("7")){%>43���̻�<%}%> 
												<%if(ins.getAge_scp().equals("8")){%>48���̻�<%}%> 
											<%}%>									
											 </span></td>
                                            <td rowspan=2 align=left style="padding:10px;"><span class=style2>
											<%if(ins.getCar_mng_id().equals("")){%>
								                å��,
												����(����),
												
								                <% if(base2.getGcp_kd().equals("1")){%>�빰(5õ����),<%}%>
								                <% if(base2.getGcp_kd().equals("2")){%>�빰(1���),<%}%>
												<% if(base2.getGcp_kd().equals("4")){%>�빰(2���),<%}%>
												<% if(base2.getGcp_kd().equals("8")){%>�빰(3���),<%}%>
												<% if(base2.getGcp_kd().equals("3")){%>�빰(4���),<%}%>
												
								                <% if(base2.getBacdt_kd().equals("1")){%>�ڱ��ü(5õ����),<%}%>
								                <% if(base2.getBacdt_kd().equals("2")){%>�ڱ��ü(1���),<%}%><br>
												
												�� �ڱ��������ش� �Ƹ���ī �ڱ��������ظ�å������ �ǰ� ���� (�ڱ�δ�� ���Ǵ� <b>�ְ� <%=AddUtil.parseDecimal(base2.getCar_ja())%>��</b>) 												
												
											<%}else{%>
											    å��,
								                <%if(ins.getVins_pcp_kd().equals("1")){%>����(����),<%}%> 
								                <%if(ins.getVins_pcp_kd().equals("2")){%>����(����),<%}%> 
												
								                <%if(ins.getVins_gcp_kd().equals("3")){%>�빰(1���),<%}%> 
								                <%if(ins.getVins_gcp_kd().equals("4")){%>�빰(5õ����),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("1")){%>�빰(3õ����),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("2")){%>�빰(1õ5�鸸��),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("5")){%>�빰(1õ����),<%}%>
												<%if(ins.getVins_gcp_kd().equals("6")){%>�빰(5���),<%}%>
												<%if(ins.getVins_gcp_kd().equals("7")){%>�빰(2���),<%}%>
												
								                <%if(ins.getVins_bacdt_kd().equals("1")){%>�ڱ��ü(3���),<%}%> 
								                <%if(ins.getVins_bacdt_kd().equals("2")){%>�ڱ��ü(1��5õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("6")){%>�ڱ��ü(1���),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("5")){%>�ڱ��ü(5õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("3")){%>�ڱ��ü(3õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("4")){%>�ڱ��ü(1õ5�鸸��),<%}%><br>
												
												<%if(ins.getVins_canoisr_amt()>0){%>������������<%}%><%if(ins.getVins_spe_amt()>0){%>, <%=ins.getVins_spe()%><%}%>	<br>
																							
												�� �ڱ��������ش� �Ƹ���ī �ڱ��������ظ�å������ �ǰ� ���� (�ڱ�δ�� ���Ǵ� <b>�ְ�
												<%=AddUtil.parseDecimal(base2.getCar_ja())%>��</b>)
											<%}%>																				
											</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>����� ������ ����</span></td>
                                        </tr>
                                         
                                        <%}else{ %>
                                          <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>���谡�� Ư����׿� ����</span></td>
                                            <td rowspan=2 align=center><span class=style2>
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
												<%if(ins.getAge_scp().equals("5")){%>30���̻�<%}%> 
												<%if(ins.getAge_scp().equals("6")){%>35���̻�<%}%> 
												<%if(ins.getAge_scp().equals("7")){%>43���̻�<%}%> 
												<%if(ins.getAge_scp().equals("8")){%>48���̻�<%}%> 
											<%}%>									
											 </span></td>
                                            <td rowspan=2 align=left style="padding:10px;"><span class=style2>
											<%if(ins.getCar_mng_id().equals("")){%>
								                å��,
												����(����),
												
								                <% if(base2.getGcp_kd().equals("1")){%>�빰(5õ����),<%}%>
								                <% if(base2.getGcp_kd().equals("2")){%>�빰(1���),<%}%>
												<% if(base2.getGcp_kd().equals("4")){%>�빰(2���),<%}%>
												<% if(base2.getGcp_kd().equals("8")){%>�빰(3���),<%}%>
												<% if(base2.getGcp_kd().equals("3")){%>�빰(4���),<%}%>
												
								                <% if(base2.getBacdt_kd().equals("1")){%>�ڱ��ü(5õ����),<%}%>
								                <% if(base2.getBacdt_kd().equals("2")){%>�ڱ��ü(1���),<%}%><br>
												
												�� �ڱ��������ش� �Ƹ���ī �ڱ��������ظ�å������ �ǰ� ���� (�ڱ�δ�� ���Ǵ� <b>�ְ� <%=AddUtil.parseDecimal(base2.getCar_ja())%>��</b>) 												
												
											<%}else{%>
											    å��,
								                <%if(ins.getVins_pcp_kd().equals("1")){%>����(����),<%}%> 
								                <%if(ins.getVins_pcp_kd().equals("2")){%>����(����),<%}%> 
												
								                <%if(ins.getVins_gcp_kd().equals("3")){%>�빰(1���),<%}%> 
								                <%if(ins.getVins_gcp_kd().equals("4")){%>�빰(5õ����),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("1")){%>�빰(3õ����),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("2")){%>�빰(1õ5�鸸��),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("5")){%>�빰(1õ����),<%}%>
												<%if(ins.getVins_gcp_kd().equals("6")){%>�빰(5���),<%}%>
												<%if(ins.getVins_gcp_kd().equals("7")){%>�빰(2���),<%}%>
												
								                <%if(ins.getVins_bacdt_kd().equals("1")){%>�ڱ��ü(3���),<%}%> 
								                <%if(ins.getVins_bacdt_kd().equals("2")){%>�ڱ��ü(1��5õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("6")){%>�ڱ��ü(1���),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("5")){%>�ڱ��ü(5õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("3")){%>�ڱ��ü(3õ����),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("4")){%>�ڱ��ü(1õ5�鸸��),<%}%><br>
												
												<%if(ins.getVins_canoisr_amt()>0){%>������������<%}%><%if(ins.getVins_spe_amt()>0){%>, <%=ins.getVins_spe()%><%}%>	<br>
																							
												<%if(!ins.getCon_f_nm().equals("�Ƹ���ī")){%>
													�� �ڱ���������: ���� <%=AddUtil.parseDecimal(ins.getVins_cacdt_car_amt())%>����, 
													������� �������� <%=AddUtil.parseDecimal(ins.getVins_cacdt_mebase_amt())%>����/
													(�ִ�)�ڱ�δ�� <%=AddUtil.parseDecimal(ins.getVins_cacdt_me_amt())%>���� /
													(�ּ�)�ڱ�δ�� <%=AddUtil.parseDecimal(ins.getVins_cacdt_memin_amt())%>����
												<%}%>		
											<%}%>																				
											</span></td>
                                        </tr>
                                        
                                        <%} %>
                                                                     
                                      
                                        <%}%>
                                    </table>
                            	</td>
		               		</tr>
		               		<!-- ���ΰ�, �ش�����, ���������뺸�� ���Խ�-->
                           	<%if(ins.getCom_emp_yn().equals("Y")){%>
		               		<tr>
		                       <%--  <td height=24 valign=top><span class=style2>�Ǻ�����:&nbsp;<%=ins.getFirm_emp_nm()%></span></td> --%>
		                        <td height=24 valign=top><span class=style2>����������������Ư�� ����</span></td>
		                	</tr>
		               		<%}else{ %>
		               			<%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%>
            			  	<tr bgcolor=#FFFFFF  >
                            	<td colspan="3" height=27 bgcolor=#FFFFFF><span class=style2>�ؿ��⼭ �����̶� �θ�, �����, ������� �θ�, �ڳ�, �����, ������ ���մϴ�. (����, �ڸŴ� ������)</span></td>
                            </tr>
                            	<%} %>
		               		<%} %>
		               		<tr>
		               			<td height=15></td>
		               		</tr>
		               		<!-- ����, ����, ���λ����, ���������뺸�� �̰��Խ�-->
	               		
		               		<!-- ���ΰ�, �ش�����, ���������뺸�� ����, �Ǻ����ڰ� ���� �ƴҽ�-->
		               		<%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%>
		               		<tr>
		               			<td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img1.gif></td>
		               		</tr>
		               		<%} %>
		                    <tr>
		                        <td height=25></td>
		            		</tr>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_2.gif width=683 height=21></td>
		         			</tr>
		                    <tr>
                                <td>
                                	<table width=683 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_up.gif width=683 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=643>
                                                <table width=643 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=30 align=left><span class=style2>���� �� �Ǵ� ��Ÿ �뿩�ڵ��� ���� ���� ��� ��簡 ó���� �帳�ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=25 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>��� �߻��� �켱 ��� �������� ����ڿ��� �����մϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=30 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>��������� ����, ������� �԰� ���� <span class=style5>��� �����ڿ� ���� �� ó��</span>�մϴ�.<br>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(����: ������ ����, ����� �������� ���� �� �ֽ��ϴ�.)</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=25 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>��� ���ó���� ���� ����� �����ϴ�.</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img8.gif></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_dw.gif width=683 height=7></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                           	<tr>
		                        <td height=25></td>
		            		</tr>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_3.gif width=683 height=21></td>
		         			</tr>
		         			<tr>
		         				<td>
		         					 <table width=683 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_up.gif width=683 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=643>
                                                <table width=643 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=18 align=left style="line-height:18px;"><span class=style2>�ڵ������� �� ��� ������ 4�ð� �̻� ������� � �԰�ǰų� ������ �Ұ��� �ϰ� �� ��� �뿩������ ������
                                                         �������� �������񽺸� �����մϴ�.</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_dw.gif width=683 height=7></td>
                                        </tr>
                                    </table>
		         				</td>
		         			</tr>
		         			<tr>
		                        <td height=25></td>
		            		</tr>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_4.gif width=683 height=21></td>
		         			</tr>
		         			<tr>
		         				<td>
		         					<table width=683 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_up.gif width=683 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=643>
                                                <table width=643 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td  style="line-height:18px;" align=left colspan=2><span class=style2>365�� 24�ð� �������� ������ ��Ȳ�߻����� ���� �������� ����� ������ �����ִ� �����Դϴ�.<br>
														���� ��������� ����⵿ ������ü�� <br><font color=red><b>(��)����Ÿ�ڵ�������(1588-6688), SK��Ʈ����(1670-5494)</b></font>�� �̿��ϰ� �ֽ��ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20></td>
                                                    </tr>
                                                    <tr>
                                                        <td align=center colspan=2><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img2.jpg></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=20></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left colspan=2>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style5>���͸� ���� ����</span></td>
                                                    </tr>
                                                    <tr>
                                                    	<td width=84 align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img3.gif></td>
                                                        <td width=559><span class=style2>�ڵ��� ���͸� ���� �� ���͸��� ������ ���������� �����ϵ��� ���͵帳�ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5 colspan=2></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left colspan=2>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style5>����Ÿ�̾� ��ü ����</span></td>
                                                    </tr>
                                                    <tr>
                                                    	<td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img4.gif></td>
                                                        <td><span class=style2>Ÿ�̾� ��ũ�� ����Ÿ�̾ �ִ� ��� �ջ�� Ÿ�̾�� ��ü�� �帳�ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left colspan=2>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style5>������ ����</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=10 colspan=2></td>
                                                    </tr>
                                                    <tr>
                                                    	<td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img5.gif></td>
                                                        <td><span class=style2>�ڵ��� ���ᰡ �����Ǿ� ������ �Ұ����� ��� �ֹ��� 3����/���� 3���� �̳��� ����(3���� �̻��� ����)���� ���Ḧ ������ �帮��, LPG�� �����ұ��� ����(10km�̳��� ����, 10km�̻��� ����)�� �帳�ϴ�.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=10></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left colspan=2>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style5>���� ����</span></td>
                                                    </tr>
                                                    <tr>
                                                    	<td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img6.gif></td>
                                                        <td><span class=style2>���� ������ ������ �Ұ����ϰ� ������ ���� ������ �ʿ��� ��쿡 ���� �մϴ�.<br>
                                                        (10km �̳��� ����, 10km �̻��� 1km �߰��� 2000�� ����)</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left colspan=2>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style5>��Ÿ �⵿����</span></td>
                                                    </tr>
                                                    <tr>
                                                    	<td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img7.gif></td>
                                                        <td><span class=style2>�� �׸� �� ������ ���� �Ǵ� �̻����� �õ��ҷ� �� �������� ������ ����� ��� �������� ������ ������ ���� �⵿���� �Դϴ�.</span></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_dw.gif width=683 height=7></td>
                                        </tr>
                                    </table>
		         				</td>
		         			</tr>
		         			<tr>
		                        <td height=25></td>
		            		</tr>
		                    <tr>
		                        <td height=24 valign=top><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_5.gif width=683 height=21></td>
		         			</tr>
		         			<tr>
		         				<td>
		         					<table width=683 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/total/images/con_bg.gif>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_up.gif width=683 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20>&nbsp;</td>
                                            <td width=643><span class=style2>�ӵ�����, �������� ����, ������ ����, ���� ����ī�޶� �� ���� ���� �� ���ߵ� ���·ᳪ ��Ģ���� ���Բ��� �δ��ϼž� �մϴ�. (���� ����)</span></td>
                                            <td width=20>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=3><img src=https://fms5.amazoncar.co.kr/mailing/total/images/con_dw.gif width=683 height=7></td>
                                        </tr>
                                    </table>
		         				</td>
		         			</tr>
	                	</table>
	              	</td>
	            </tr>
	            <tr>
	            	<td height=60></td>
	            </tr>
	            <tr>
	                <td align=center>
	                	<table width=700 border=0 cellspacing=0 cellpadding=0>
			                <tr>
			                    <td width=35>&nbsp;</td>
			                    <td width=92><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
			                    <td width=35>&nbsp;</td>
			                    <td width=1 bgcolor=dbdbdb></td>
			                    <td width=40>&nbsp;</td>
			                    <td width=499><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
			                </tr>
			                <map name=Map1>
			                    <area shape=rect coords=283,53,403,67 href=mailto:webmaster@amazoncar.co.kr>
			                </map>
			            </table>
	                </td>
	            </tr>
			</table>
		</td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/total/images/tt_dw.gif width=835 height=55></td>
    </tr>
</table>
<br><br><br><br>

</body>
</html>