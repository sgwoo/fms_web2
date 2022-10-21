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
		out.println("정상적인 호출이 아닙니다.");	
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
	
	//계약:고객관련
	ContBaseBean base2 = a_db.getContBaseAll(m_id, l_cd);
	
	//담당자정보
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean b_user2 = b_user;
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
	
	if(String.valueOf(base.get("BUS_ST_NM")).equals("에이전트")){
		b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID")));
		
		//에이전트 계약진행담당자
		if(!cont.getAgent_emp_id().equals("")){ 
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(cont.getAgent_emp_id()); 
				b_user.setUser_m_tel(a_coe_bean.getEmp_m_tel());
				b_user.setUser_nm		(a_coe_bean.getEmp_nm());
		}
	}
		
	if(ins_st.equals(""))	ins_st = ai_db.getInsSt(String.valueOf(base.get("CAR_MNG_ID")));
	
	//보험정보
	InsurBean ins = ai_db.getInsCase(String.valueOf(base.get("CAR_MNG_ID")), ins_st);
	
	
	
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>자동차 관리 서비스 안내문</title>
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
		                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style1><b>[ <%=base.get("FIRM_NM")%> ]</b></span>&nbsp;<span class=style2>님</span> </span></td>
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
		                	<%if(String.valueOf(base.get("RENT_WAY")).equals("기본식")){%><!--기본식일경우-->
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
	                	 	<%if(!ins.getCon_f_nm().equals("아마존카")){%>
		                	 <tr>
			          			<td height=24 valign=top><span class=style2>피보험자:&nbsp;<%=ins.getCon_f_nm()%></span></td>
			  				 </tr>
		  					<%}%>
		                    <tr>
		                        <td>
		                        	<table width=683 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td height=24 align=center><span class=style4>보험사</span></td>
                                            <td colspan='2' align=center bgcolor=#FFFFFF><span class=style4>                                                
                                                <%if(ins.getIns_com_id().equals("0007")){%>		삼성화재 (사고접수 1588-5114) 
    						<%}else if(ins.getIns_com_id().equals("0008")){%>	동부화재 (사고접수 1588-0100) 
    						<%}else if(ins.getIns_com_id().equals("0038")){%>	렌터카공제조합 (사고접수 1661-7977)
    						<%}else{%>    						<%=ai_db.getInsComNm(ins.getCar_mng_id())%>
    						<%}%>
                                            </span></td>                                            
                                        </tr>
                                        <tr bgcolor=f2f2f2>
                                            <td width=255 height=24 align=center><span class=style4>운전자범위</span></td>
                                            <td width=102 align=center bgcolor=f2f2f2><span class=style4>운전연령</span></td>
                                            <td width=332 align=center bgcolor=f2f2f2><span class=style4>보상범위</span></td>
                                        </tr> 
                            <!-- 법인고객, 해당차종, 임직원전용보험 가입시-->
                            <%if(ins.getCom_emp_yn().equals("Y")){%>
                            			      
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>임차인 소속의 이사와 감사 </span></td>
                                            <td rowspan=3 align=center><span class=style2>
											<%if(ins.getCar_mng_id().equals("")){%>
								                <%if(base2.getDriving_age().equals("0")){%> 26세이상 <%}%>
								                <%if(base2.getDriving_age().equals("3")){%> 24세이상 <%}%>
								                <%if(base2.getDriving_age().equals("1")){%> 21세이상 <%}%>
								                <%if(base2.getDriving_age().equals("2")){%> 모든운전자 <%}%>
											<%}else{%>
								                <%if(ins.getAge_scp().equals("1")){%>21세이상<%}%> 
								                <%if(ins.getAge_scp().equals("4")){%>24세이상<%}%> 
								                <%if(ins.getAge_scp().equals("2")){%>26세이상<%}%> 
								                <%if(ins.getAge_scp().equals("3")){%>모든운전자<%}%>		
												<%if(ins.getAge_scp().equals("5")){%>30세이상<%}%> 
												<%if(ins.getAge_scp().equals("6")){%>35세이상<%}%> 
												<%if(ins.getAge_scp().equals("7")){%>43세이상<%}%> 
												<%if(ins.getAge_scp().equals("8")){%>48세이상<%}%> 
											<%}%>									
											 </span></td>
                                            <td rowspan=3 align=left style="padding:10px;"><span class=style2>
											<%if(ins.getCar_mng_id().equals("")){%>
								                책임,
												대인(무한),
												
								                <% if(base2.getGcp_kd().equals("1")){%>대물(5천만원),<%}%>
								                <% if(base2.getGcp_kd().equals("2")){%>대물(1억원),<%}%>
												<% if(base2.getGcp_kd().equals("4")){%>대물(2억원),<%}%>
												<% if(base2.getGcp_kd().equals("8")){%>대물(3억원),<%}%>
												<% if(base2.getGcp_kd().equals("3")){%>대물(4억원),<%}%>
												
								                <% if(base2.getBacdt_kd().equals("1")){%>자기신체(5천만원),<%}%>
								                <% if(base2.getBacdt_kd().equals("2")){%>자기신체(1억원),<%}%><br>
												
												자차(<b>자차면책금 <%=AddUtil.parseDecimal(base2.getCar_ja())%>원</b> 포함) 		
												
												
											<%}else{%>
											    책임,
								                <%if(ins.getVins_pcp_kd().equals("1")){%>대인(무한),<%}%> 
								                <%if(ins.getVins_pcp_kd().equals("2")){%>대인(유한),<%}%> 
												
								                <%if(ins.getVins_gcp_kd().equals("3")){%>대물(1억원),<%}%> 
								                <%if(ins.getVins_gcp_kd().equals("4")){%>대물(5천만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("1")){%>대물(3천만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("2")){%>대물(1천5백만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("5")){%>대물(1천만원),<%}%>
												<%if(ins.getVins_gcp_kd().equals("6")){%>대물(5억원),<%}%>
												<%if(ins.getVins_gcp_kd().equals("7")){%>대물(2억원),<%}%>
												
								                <%if(ins.getVins_bacdt_kd().equals("1")){%>자기신체(3억원),<%}%> 
								                <%if(ins.getVins_bacdt_kd().equals("2")){%>자기신체(1억5천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("6")){%>자기신체(1억원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("5")){%>자기신체(5천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("3")){%>자기신체(3천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("4")){%>자기신체(1천5백만원),<%}%><br>
												
												<%if(ins.getVins_canoisr_amt()>0){%>무보험차상해<%}%><%if(ins.getVins_spe_amt()>0){%>, <%=ins.getVins_spe()%><%}%>	<br>	
												
												<%if(!ins.getCon_f_nm().equals("아마존카")){%>
													※ 자기차량손해: 차량 <%=AddUtil.parseDecimal(ins.getVins_cacdt_car_amt())%>만원, 
													물적사고 할증기준 <%=AddUtil.parseDecimal(ins.getVins_cacdt_mebase_amt())%>만원/
													(최대)자기부담금 <%=AddUtil.parseDecimal(ins.getVins_cacdt_me_amt())%>만원 /
													(최소)자기부담금 <%=AddUtil.parseDecimal(ins.getVins_cacdt_memin_amt())%>만원
			  									<%}else{%>							
													※ 자기차량손해는 아마존카 자기차량손해면책제도에 의거 보상 (자기부담금 사고건당 <b>최고 <%=AddUtil.parseDecimal(base2.getCar_ja())%>원</b>)
												<%}%>																				
											<%}%>																				
											</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=60 align=center bgcolor=#FFFFFF><span class=style5>임차인 소속의 직원</span><br><span class=style7>(계약직 직원 포함, 단,계약직 직원의 경우<br>법인과 체결한 근로계약기간에 한정)</span></td>
                                        </tr> 
                                       	<tr bgcolor=#FFFFFF>
                                            <td height=60 align=center bgcolor=#FFFFFF><span class=style5>임차인의 업무를 위하여 위 자동차를 운행<br>하는 자로서 임차인과 계약관계에 있는<br>업체에 소속된 자</span></td>
                                        </tr> 
                               <!-- 법인고객, 해당차종, 임직원전용보험 미가입시-->   
                               <%}else{%>      
                                        <%if(ins.getCon_f_nm().equals("아마존카")){%>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>계약자, 계약자의 직원/가족 </span></td>
                                            <td rowspan=2 align=center><span class=style2>
											<%if(ins.getCar_mng_id().equals("")){%>
								                <%if(base2.getDriving_age().equals("0")){%> 26세이상 <%}%>
								                <%if(base2.getDriving_age().equals("3")){%> 24세이상 <%}%>
								                <%if(base2.getDriving_age().equals("1")){%> 21세이상 <%}%>
								                <%if(base2.getDriving_age().equals("2")){%> 모든운전자 <%}%>
											<%}else{%>
								                <%if(ins.getAge_scp().equals("1")){%>21세이상<%}%> 
								                <%if(ins.getAge_scp().equals("4")){%>24세이상<%}%> 
								                <%if(ins.getAge_scp().equals("2")){%>26세이상<%}%> 
								                <%if(ins.getAge_scp().equals("3")){%>모든운전자<%}%>		
												<%if(ins.getAge_scp().equals("5")){%>30세이상<%}%> 
												<%if(ins.getAge_scp().equals("6")){%>35세이상<%}%> 
												<%if(ins.getAge_scp().equals("7")){%>43세이상<%}%> 
												<%if(ins.getAge_scp().equals("8")){%>48세이상<%}%> 
											<%}%>									
											 </span></td>
                                            <td rowspan=2 align=left style="padding:10px;"><span class=style2>
											<%if(ins.getCar_mng_id().equals("")){%>
								                책임,
												대인(무한),
												
								                <% if(base2.getGcp_kd().equals("1")){%>대물(5천만원),<%}%>
								                <% if(base2.getGcp_kd().equals("2")){%>대물(1억원),<%}%>
												<% if(base2.getGcp_kd().equals("4")){%>대물(2억원),<%}%>
												<% if(base2.getGcp_kd().equals("8")){%>대물(3억원),<%}%>
												<% if(base2.getGcp_kd().equals("3")){%>대물(4억원),<%}%>
												
								                <% if(base2.getBacdt_kd().equals("1")){%>자기신체(5천만원),<%}%>
								                <% if(base2.getBacdt_kd().equals("2")){%>자기신체(1억원),<%}%><br>
												
												※ 자기차량손해는 아마존카 자기차량손해면책제도에 의거 보상 (자기부담금 사고건당 <b>최고 <%=AddUtil.parseDecimal(base2.getCar_ja())%>원</b>) 												
												
											<%}else{%>
											    책임,
								                <%if(ins.getVins_pcp_kd().equals("1")){%>대인(무한),<%}%> 
								                <%if(ins.getVins_pcp_kd().equals("2")){%>대인(유한),<%}%> 
												
								                <%if(ins.getVins_gcp_kd().equals("3")){%>대물(1억원),<%}%> 
								                <%if(ins.getVins_gcp_kd().equals("4")){%>대물(5천만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("1")){%>대물(3천만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("2")){%>대물(1천5백만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("5")){%>대물(1천만원),<%}%>
												<%if(ins.getVins_gcp_kd().equals("6")){%>대물(5억원),<%}%>
												<%if(ins.getVins_gcp_kd().equals("7")){%>대물(2억원),<%}%>
												
								                <%if(ins.getVins_bacdt_kd().equals("1")){%>자기신체(3억원),<%}%> 
								                <%if(ins.getVins_bacdt_kd().equals("2")){%>자기신체(1억5천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("6")){%>자기신체(1억원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("5")){%>자기신체(5천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("3")){%>자기신체(3천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("4")){%>자기신체(1천5백만원),<%}%><br>
												
												<%if(ins.getVins_canoisr_amt()>0){%>무보험차상해<%}%><%if(ins.getVins_spe_amt()>0){%>, <%=ins.getVins_spe()%><%}%>	<br>
																							
												※ 자기차량손해는 아마존카 자기차량손해면책제도에 의거 보상 (자기부담금 사고건당 <b>최고
												<%=AddUtil.parseDecimal(base2.getCar_ja())%>원</b>)
											<%}%>																				
											</span></td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>계약자 직원의 가족</span></td>
                                        </tr>
                                         
                                        <%}else{ %>
                                          <tr bgcolor=#FFFFFF>
                                            <td height=27 align=center bgcolor=#FFFFFF><span class=style5>보험가입 특약사항에 의함</span></td>
                                            <td rowspan=2 align=center><span class=style2>
											<%if(ins.getCar_mng_id().equals("")){%>
								                <%if(base2.getDriving_age().equals("0")){%> 26세이상 <%}%>
								                <%if(base2.getDriving_age().equals("3")){%> 24세이상 <%}%>
								                <%if(base2.getDriving_age().equals("1")){%> 21세이상 <%}%>
								                <%if(base2.getDriving_age().equals("2")){%> 모든운전자 <%}%>
											<%}else{%>
								                <%if(ins.getAge_scp().equals("1")){%>21세이상<%}%> 
								                <%if(ins.getAge_scp().equals("4")){%>24세이상<%}%> 
								                <%if(ins.getAge_scp().equals("2")){%>26세이상<%}%> 
								                <%if(ins.getAge_scp().equals("3")){%>모든운전자<%}%>		
												<%if(ins.getAge_scp().equals("5")){%>30세이상<%}%> 
												<%if(ins.getAge_scp().equals("6")){%>35세이상<%}%> 
												<%if(ins.getAge_scp().equals("7")){%>43세이상<%}%> 
												<%if(ins.getAge_scp().equals("8")){%>48세이상<%}%> 
											<%}%>									
											 </span></td>
                                            <td rowspan=2 align=left style="padding:10px;"><span class=style2>
											<%if(ins.getCar_mng_id().equals("")){%>
								                책임,
												대인(무한),
												
								                <% if(base2.getGcp_kd().equals("1")){%>대물(5천만원),<%}%>
								                <% if(base2.getGcp_kd().equals("2")){%>대물(1억원),<%}%>
												<% if(base2.getGcp_kd().equals("4")){%>대물(2억원),<%}%>
												<% if(base2.getGcp_kd().equals("8")){%>대물(3억원),<%}%>
												<% if(base2.getGcp_kd().equals("3")){%>대물(4억원),<%}%>
												
								                <% if(base2.getBacdt_kd().equals("1")){%>자기신체(5천만원),<%}%>
								                <% if(base2.getBacdt_kd().equals("2")){%>자기신체(1억원),<%}%><br>
												
												※ 자기차량손해는 아마존카 자기차량손해면책제도에 의거 보상 (자기부담금 사고건당 <b>최고 <%=AddUtil.parseDecimal(base2.getCar_ja())%>원</b>) 												
												
											<%}else{%>
											    책임,
								                <%if(ins.getVins_pcp_kd().equals("1")){%>대인(무한),<%}%> 
								                <%if(ins.getVins_pcp_kd().equals("2")){%>대인(유한),<%}%> 
												
								                <%if(ins.getVins_gcp_kd().equals("3")){%>대물(1억원),<%}%> 
								                <%if(ins.getVins_gcp_kd().equals("4")){%>대물(5천만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("1")){%>대물(3천만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("2")){%>대물(1천5백만원),<%}%>
								                <%if(ins.getVins_gcp_kd().equals("5")){%>대물(1천만원),<%}%>
												<%if(ins.getVins_gcp_kd().equals("6")){%>대물(5억원),<%}%>
												<%if(ins.getVins_gcp_kd().equals("7")){%>대물(2억원),<%}%>
												
								                <%if(ins.getVins_bacdt_kd().equals("1")){%>자기신체(3억원),<%}%> 
								                <%if(ins.getVins_bacdt_kd().equals("2")){%>자기신체(1억5천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("6")){%>자기신체(1억원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("5")){%>자기신체(5천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("3")){%>자기신체(3천만원),<%}%>
								                <%if(ins.getVins_bacdt_kd().equals("4")){%>자기신체(1천5백만원),<%}%><br>
												
												<%if(ins.getVins_canoisr_amt()>0){%>무보험차상해<%}%><%if(ins.getVins_spe_amt()>0){%>, <%=ins.getVins_spe()%><%}%>	<br>
																							
												<%if(!ins.getCon_f_nm().equals("아마존카")){%>
													※ 자기차량손해: 차량 <%=AddUtil.parseDecimal(ins.getVins_cacdt_car_amt())%>만원, 
													물적사고 할증기준 <%=AddUtil.parseDecimal(ins.getVins_cacdt_mebase_amt())%>만원/
													(최대)자기부담금 <%=AddUtil.parseDecimal(ins.getVins_cacdt_me_amt())%>만원 /
													(최소)자기부담금 <%=AddUtil.parseDecimal(ins.getVins_cacdt_memin_amt())%>만원
												<%}%>		
											<%}%>																				
											</span></td>
                                        </tr>
                                        
                                        <%} %>
                                                                     
                                      
                                        <%}%>
                                    </table>
                            	</td>
		               		</tr>
		               		<!-- 법인고객, 해당차종, 임직원전용보험 가입시-->
                           	<%if(ins.getCom_emp_yn().equals("Y")){%>
		               		<tr>
		                       <%--  <td height=24 valign=top><span class=style2>피보험자:&nbsp;<%=ins.getFirm_emp_nm()%></span></td> --%>
		                        <td height=24 valign=top><span class=style2>※임직원운전한정특약 가입</span></td>
		                	</tr>
		               		<%}else{ %>
		               			<%if(ins.getCon_f_nm().equals("아마존카")){%>
            			  	<tr bgcolor=#FFFFFF  >
                            	<td colspan="3" height=27 bgcolor=#FFFFFF><span class=style2>※여기서 가족이란 부모, 배우자, 배우자의 부모, 자녀, 며느리, 사위를 말합니다. (형제, 자매는 미포함)</span></td>
                            </tr>
                            	<%} %>
		               		<%} %>
		               		<tr>
		               			<td height=15></td>
		               		</tr>
		               		<!-- 법인, 개인, 개인사업자, 임직원전용보험 미가입시-->
	               		
		               		<!-- 법인고객, 해당차종, 임직원전용보험 가입, 피보험자가 고객이 아닐시-->
		               		<%if(ins.getCon_f_nm().equals("아마존카")){%>
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
                                                        <td height=30 align=left><span class=style2>운행 중 또는 기타 대여자동차 관련 사고는 모두 당사가 처리해 드립니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=25 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>사고 발생시 우선 당사 차량관리 담당자에게 연락합니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=30 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>사고차량의 견인, 정비공장 입고 등은 <span class=style5>당사 관리자와 협의 후 처리</span>합니다.<br>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(주의: 임의적 견인, 정비는 보상하지 않을 수 있습니다.)</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=25 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style2>모든 사고처리는 보험 약관에 따릅니다.</span></td>
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
                                                        <td height=18 align=left style="line-height:18px;"><span class=style2>자동차정비 및 사고 등으로 4시간 이상 정비공장 등에 입고되거나 운행이 불가능 하게 된 경우 대여차량과 동급의
                                                         차종으로 대차서비스를 제공합니다.</span></td>
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
                                                        <td  style="line-height:18px;" align=left colspan=2><span class=style2>365일 24시간 운전자의 위급한 상황발생으로 인한 운전자의 생명과 안전을 지켜주는 서비스입니다.<br>
														당사는 국내보험사 긴급출동 전문업체인 <br><font color=red><b>(주)마스타자동차관리(1588-6688), SK네트웍스(1670-5494)</b></font>를 이용하고 있습니다.</span></td>
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
                                                        <span class=style5>배터리 충전 서비스</span></td>
                                                    </tr>
                                                    <tr>
                                                    	<td width=84 align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img3.gif></td>
                                                        <td width=559><span class=style2>자동차 배터리 방전 시 배터리를 충전해 차량운행이 가능하도록 도와드립니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5 colspan=2></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left colspan=2>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style5>예비타이어 교체 서비스</span></td>
                                                    </tr>
                                                    <tr>
                                                    	<td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img4.gif></td>
                                                        <td><span class=style2>타이어 펑크시 예비타이어가 있는 경우 손상된 타이어와 교체해 드립니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left colspan=2>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style5>비상급유 서비스</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=10 colspan=2></td>
                                                    </tr>
                                                    <tr>
                                                    	<td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img5.gif></td>
                                                        <td><span class=style2>자동차 연료가 소진되어 운행이 불가능한 경우 휘발유 3리터/경유 3리터 이내는 무상(3리터 이상은 유상)으로 연료를 공급해 드리며, LPG는 충전소까지 견인(10km이내는 무상, 10km이상은 유상)해 드립니다.</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=10></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left colspan=2>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style5>견인 서비스</span></td>
                                                    </tr>
                                                    <tr>
                                                    	<td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img6.gif></td>
                                                        <td><span class=style2>고장 등으로 운행이 불가능하고 수리를 위해 견인이 필요한 경우에 서비스 합니다.<br>
                                                        (10km 이내는 무상, 10km 이상은 1km 추가당 2000원 유상)</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=5></td>
                                                    </tr>
                                                    <tr>
                                                        <td height=18 align=left colspan=2>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/fms/images/arrow.gif> 
                                                        <span class=style5>기타 출동서비스</span></td>
                                                    </tr>
                                                    <tr>
                                                    	<td align=center><img src=https://fms5.amazoncar.co.kr/mailing/total/images/car_bar_img7.gif></td>
                                                        <td><span class=style2>위 항목 외 차량의 고장 또는 이상으로 시동불량 및 정상적인 운행이 어려운 경우 운전자의 안전과 운행을 위한 출동서비스 입니다.</span></td>
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
                                            <td width=643><span class=style2>속도위반, 전용차로 위반, 주정차 위반, 무인 감시카메라 등 고객이 운행 중 적발된 과태료나 범칙금은 고객님께서 부담하셔야 합니다. (별도 공지)</span></td>
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