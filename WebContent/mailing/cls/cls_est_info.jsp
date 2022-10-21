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
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("해지관리자"));
	
		//해지정보
	//해지의뢰정보
	ClsEstBean cls = ac_db.getClsEstCase(m_id, l_cd);
	String cls_st = cls.getCls_st_r();
			

	//기본정보
	Hashtable fee_base = af_db.getFeebasecls3(m_id, l_cd);
	
		//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(m_id, l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//계산서 발행여부
	Hashtable cls_tax = ac_db.getClsGetTaxYN(m_id, l_cd);
	
//	System.out.println("hash size="+cls_tax.size() );


		//fee 기타 - 주행거리 초과분 계산  - fee_etc 의  over_run_amt > 0보다 큰 경우 해당됨
	ContCarBean  car1 = a_db.getContFeeEtc(m_id, l_cd, Integer.toString(fee_size));
	

	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>아마존카 장기대여 해지정산 사전내역  안내문</title>
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
    		<!-- 날짜 -->
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=450>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td width=250 align=right style="font-family:nanumgothic;font-size:12px;"><b><%= AddUtil.getDate() %></b>&nbsp;&nbsp;&nbsp;</td>
                </tr> 
            </table>
    <!-- 날짜 -->
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
                                         <!--매입옵션일경우 -->
                                         <img src=https://fms5.amazoncar.co.kr/mailing/cls/images/opt_info.gif>
                                         <% } %>
                                         </td>
                                        </tr>
                                   <!-- 업체명 -->
                                        <tr>
                                            <td height=30 align=left style="font-family:nanumgothic;font-size:13px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span style="color:#747474;"><b><%=base.get("FIRM_NM")%></b></span>&nbsp;님 귀하</td>
                                        </tr>
                                   <!-- 업체명 -->
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
                                                                    <td height=15><span style="font-family:nanumgothic;font-size:13px;"><span style="color:#88b228;"><b>[<%=base.get("CAR_NO")%>]</b></span> 차량의 상세정산내역입니다.<br>
                                                                	지금까지 아마존카를 이용해 주셔서 진심으로 감사드리고, 부족한 부분
                                                                	이 있었다면 너그럽게 양해해 주십시요. 더욱더 발전된 모습으로 다시
                                                                	찾아뵙겠습니다.</span></td>
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
                              <!-- 담당자 전화번호 -->
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
                              <!-- 담당자 전화번호 -->
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
			                  				<td bgcolor=f2f2f2 align='center' height=24 style="font-family:nanumgothic;font-size:12px;">계약번호</td>
			                  				<td colspan=5 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=l_cd%></td>
			                			</tr>
			                			<tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 width=12% style="font-family:nanumgothic;font-size:12px;">상호</td>
			                		        <td bgcolor=ffffff width=26% style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("FIRM_NM")%></td>
			                		        <td bgcolor=f2f2f2 align=center width=12% style="font-family:nanumgothic;font-size:12px;">고객명</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("CLIENT_NM")%></td>
			                		        <td bgcolor=f2f2f2 align=center width=12% style="font-family:nanumgothic;font-size:12px;">차량번호</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("CAR_NO")%></td>
                                        </tr>
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">차명</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("CAR_NM")%></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">최초등록일</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=fee_base.get("INIT_REG_DT")%></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">대여방식</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;
			                		         <%if(fee_base.get("RENT_WAY").equals("1")){%>
									              일반식 
									              <%}else if(fee_base.get("RENT_WAY").equals("2")){%>
									              맞춤식 
									              <%}else{%>
									              기본식 
									              <%}%>			                		        
			                		        </td>
                                        </tr>
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">대여기간</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;
			                		        <%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~&nbsp; 
              <%if(fee_size == 1){ out.println(AddUtil.ChangeDate2(fee.getRent_end_dt())); }else{ out.println(AddUtil.ChangeDate2(ext_fee.getRent_end_dt())); }%>
			                		        </td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">계약기간</td>
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
			                		        개월</td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">월대여료</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;
			                		          <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("FEE_AMT")))%> 
              <%}else{%>
              <%//=AddUtil.parseDecimal(AddUtil.parseInt((String)fee_base.get("EX_FEE_AMT")))%> 
			  <%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%> 
              <%}%>
			                		        원</td>
                                        </tr>
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">선납금</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<span style="color:#e60011;">
			                		             <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("PP_AMT"))%> 
              <%}else{%>
              <%//=AddUtil.parseDecimal((String)fee_base.get("EX_PP_AMT"))%> 
			  <%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%> 
              <%}%>
			                		         원</span></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">개시대여료</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<span style="color:#e60011;">
			                		          <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("IFEE_AMT"))%> 
              <%}else{%>
              <%//=AddUtil.parseDecimal((String)fee_base.get("EX_IFEE_AMT"))%>
			  <%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>  
              <%}%>
			                		        원</span></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">보증금</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<span style="color:#e60011;">
			                		          <%if(fee_base.get("RENT_ST").equals("1")){%>
              <%=AddUtil.parseDecimal((String)fee_base.get("GRT_AMT"))%> 
              <%}else{%>
              <%=AddUtil.parseDecimal((String)fee_base.get("EX_GRT_AMT"))%> 
              <%}%>
			                		        원</span></td>
                                        </tr>
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">해지구분</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=cls.getCls_st()%></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">해지일</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">이용기간</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=cls.getR_mon()%>개월 <%=cls.getR_day()%>일</td>
                                        </tr>
                                  <% if (  cls_st.equals("8") ) {%>            
                                        <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">매입옵션금액</td>
			                		        <td colspan=5 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<span style="color:#e60011;"><%=AddUtil.parseDecimal(cls.getOpt_amt())%> 원 </span> ( VAT포함 ) </td>
			                		       </tr>
                                  <% } %>
                                   <tr>
			                		        <td bgcolor=f2f2f2 align=center height=24 style="font-family:nanumgothic;font-size:12px;">주행거리</td>
			                		        <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;<%=AddUtil.parseDecimal(cls.getTot_dist() )%> km</td>
			                		        <td bgcolor=f2f2f2 align=center style="font-family:nanumgothic;font-size:12px;">약정마일리지(년)</td>
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
                          <!-- 선납금액 정산 -->
                                    <table border="0" cellspacing="1" cellpadding="0" width="100%" bgcolor=cacaca>
            			                <tr> 
            			                  <td bgcolor=f2f2f2 align='center' colspan="3" height=27 style="font-family:nanumgothic;font-size:12px;">항목</td>
            			                  <td bgcolor=f2f2f2 width='30%' align="center" style="font-family:nanumgothic;font-size:12px;">내용</td>
            			                  <td bgcolor=f2f2f2 width="37%" align='center' style="font-family:nanumgothic;font-size:12px;">비고</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb rowspan="7" align=center style="font-family:nanumgothic;font-size:12px;">환<br>
            			                    불<br>
            			                    금<br>
            			                    액</td>
            			                  <td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">보증금(A)</span></td>
            			                  <td width="30%" bgcolor=ecf9fb align=right style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getGrt_amt())%> 원</td>
            			                  <td bgcolor=ecf9fb>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb rowspan="3" align=center style="font-family:nanumgothic;font-size:12px;">개<br>
            			                    시<br>
            			                    대<br>
            			                    여<br>
            			                    료</td>
            			                  <td bgcolor=ffffff width="22%" align="center" height=24 style="font-family:nanumgothic;font-size:12px;">경과기간</td>
            			                  <td bgcolor=ffffff width="30%" align="center" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=cls.getIfee_mon()%>  개월&nbsp;&nbsp;&nbsp;<%=cls.getIfee_day()%>  일</td>
            			                  <td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr>
            			                  <td bgcolor=ffffff align="center"  height=24 style="font-family:nanumgothic;font-size:12px;">경과금액</td>
            			                  <td bgcolor=ffffff  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>  원</td>
            			                  <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= 개시대여료×경과기간</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb align=center  height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">잔여 개시대여료(B)</span></td>
            			                  <td bgcolor=ecf9fb  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>  원</td>
            			                  <td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;= 개시대여료-경과금액</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb rowspan="3" align=center style="font-family:nanumgothic;font-size:12px;">선<br>
            			                    납<br>
            			                    금</td>
            			                  <td bgcolor=ffffff align='center'  height=24 style="font-family:nanumgothic;font-size:12px;">월공제액</td>
            			                  <td bgcolor=ffffff  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getPded_s_amt())%> 원</td>
            			                  <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= 선납금÷계약기간</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ffffff align='center'  height=24 style="font-family:nanumgothic;font-size:12px;">선납금 공제총액</td>
            			                  <td bgcolor=ffffff  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getTpded_s_amt())%> 원</td>
            			                  <td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= 월공제액×실이용기간</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=ecf9fb align=center  height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">잔여 선납금(C)</span></td>
            			                  <td bgcolor=ecf9fb  align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>  원</td>
            			                  <td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;= 선납금-선납금 공제총액</td>
            			                </tr>
            			                <tr> 
            			                  <td bgcolor=fffdcb align=center colspan="3" height=27 style="font-family:nanumgothic;font-size:12px;">계</td>
            			                  <td bgcolor=fffdcb  align="right" style="font-family:nanumgothic;font-weight:bold;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getGrt_amt()+cls.getRifee_s_amt()+cls.getRfee_s_amt())%>  원</td>
            			                  <td bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;= (A+B+C)</td>
            			                </tr>
            			             
            			            </table>
            			                    			            
            			          
            			       <!-- 선납금액 정산 -->
                                </td>
                            </tr>
                            <tr>
                                <td align=right height=19 style="font-family:nanumgothic;font-size:12px;">[공급가]</td>
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
                         		<!-- 미납입금액 정산 -->
                                    <table border="0" cellspacing="1" cellpadding="0" width=100% bgcolor=cacaca>
            			                <tr> 
            			                  	<td bgcolor=f2f2f2 colspan="4" align="center" height=27 style="font-family:nanumgothic;font-size:12px;">항목</td>
            			                  	<td bgcolor=f2f2f2 width='30%' align="center" style="font-family:nanumgothic;font-size:12px;">내용</td>
            			                  	<td bgcolor=f2f2f2 width='37%' align="center" style="font-family:nanumgothic;font-size:12px;">비고</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb rowspan="19" align="center" width=5% style="font-family:nanumgothic;font-size:12px;">미<br>
            			                    납<br>
            			                    입<br>
            			                    금<br>
            			                    액</td>
            			                  	<td bgcolor=ecf9fb colspan="3" align="center" height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">과태료/범칙금(D)</span></td>
            			                  	<td bgcolor=ecf9fb width='30%' align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getFine_amt_1())%>  원</td>
            			                  	<td bgcolor=ecf9fb width='37%' style="font-family:nanumgothic;font-size:12px;">&nbsp;* 과태료발생시 사용자변경으로 인해 관할기관에서 따로 청구합니다.</td>
            			                 </tr>
            			                 <tr> 
            			                  	<td bgcolor=ecf9fb colspan="3" align="center" height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">자기차량손해면책금(E)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;">
            			                    <%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>  원</td>
            			                  	<td bgcolor=ecf9fb>&nbsp;</td>
            			                </tr>
            			                 <tr>
            			                  	<td bgcolor=ecf9fb rowspan="5" align="center" style="font-family:nanumgothic;font-size:12px;"><br>
            			                    대<br>
            			                    여<br>
            			                    료</td>
            			                  	<td bgcolor=ffffff width=23% align="center" colspan="2" align="center" height=24 style="font-family:nanumgothic;font-size:12px;">과부족</td>
            			                  	<td bgcolor=ffffff align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>  원</td>
            			                  	<td width='35%' bgcolor=ffffff>&nbsp; </td>
            			                </tr>
            			                            			            
            			                <tr> 
            			                  	<td rowspan="2" align="center" bgcolor=ffffff width=5% style="font-family:nanumgothic;font-size:12px;">미<br>
            			                    납<br>
            			                    입</td>
            			                  	<td align="center" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">기간</td>
            			                  	<td align="center" bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;"> 
            			                    	<%=cls.getNfee_mon()%>  개월&nbsp;&nbsp;&nbsp;<%=cls.getNfee_day()%> 일</td>
            			                  	<td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td align="center" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">금액</td>
            			                  	<td  align="right" bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;"> 
            			                    	<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%> 원</td>
            			                  	<td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;매출 세금계산서 발행</td>
            			                </tr>
            			                <tr> 
            			                  	<td colspan="2" align="center" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">연체료</td>
            			                  	<td align="right" bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getDly_amt_1())%>  원</td>
            			                  	<td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" align="center" height=24 style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">소계(F)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;">  
            			                    <%=AddUtil.parseDecimal(cls.getEx_di_amt_1() + cls.getNfee_amt_1() + cls.getDly_amt_1())%>  원</td>
            			                  	<td bgcolor=ecf9fb>&nbsp;</td>
            			                </tr>            			              
            			                <tr> 
            			                  	<td rowspan="6" align="center" bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">중<br>
            			                    도<br>
            			                    해<br>
            			                    지<br>
            			                    위<br>
            			                    약<br>
            			                    금</td>
            			                  	<td align="center" colspan="2" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">대여료총액</td>
            			                  	<td align="right" bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">  
            			                    <%=AddUtil.parseDecimal(cls.getTfee_amt())%>  원</td>
            			                  	<td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= 선납금+월대여료총액</td>
            			                </tr>
            			                <tr> 
            			                  	<td align="center" colspan="2" height=24 bgcolor=fffff style="font-family:nanumgothic;font-size:12px;">월대여료(환산)</td>
            			                  	<td bgcolor=ffffff align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getMfee_amt())%>  원</td>
            			                  	<td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;= 대여료총액÷계약기간</td>
            			                </tr>
            			                <tr> 
            			                  	<td align="center" colspan="2" height=24 bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">잔여대여계약기간</td>
            			                  	<td bgcolor=ffffff align="center" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=cls.getRcon_mon()%> 개월&nbsp;&nbsp;&nbsp;<%=cls.getRcon_day()%> 일</td>
            			                  	<td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ffffff colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;">잔여기간 대여료 총액</td>
            			                  	<td bgcolor=ffffff align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getTrfee_amt())%>  원</td>
            			                  	<td bgcolor=ffffff>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ffffff align="center" colspan="2" height=24 style="font-family:nanumgothic;font-size:12px;">위약금 
            			                    적용요율</td>
            			                  	<td bgcolor=ffffff align="center" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=cls.getDft_int()%>  %</td>
            			                  	<td bgcolor=ffffff style="font-family:nanumgothic;font-size:12px;">&nbsp;잔여기간 대여료 총액 기준</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=fffdcb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">중도해지위약금(G)</span></td>
            			                  	<td bgcolor=fffdcb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getDft_amt_1())%>  원</td>
            			                  	<td bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			              <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK0").equals("Y")  ) {%>            			                  			                  
            			                 			 매출 세금계산서 발행
            			              <%     }            			               			 
            			              	 } %>    
            			                  	&nbsp;</td>
            			                </tr>      
            			           
            			                <tr> 
            			                  	<td bgcolor=ecf9fb rowspan="6" align=center style="font-family:nanumgothic;font-size:12px;"><br>
            			                    기<br>
            			                    타</td> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">차량회수외주비용(H)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>  원</td>
            			                  	<td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			                <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK1").equals("Y")  ) {%>            			                  			                  
            			                 			 매출 세금계산서 발행
            			              <%     }            			               			 
            			              	 } %>      
            			                  	&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">차량회수부대비용(I)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>  원</td>
            			                  	<td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			              <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK2").equals("Y")  ) {%>            			                  			                  
            			                 			 매출 세금계산서 발행
            			              <%     }            			               			 
            			              	 } %>       
            			                  	&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">잔존차량가격(J)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>  원</td>
            			                  	<td bgcolor=ecf9fb>&nbsp;</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">기타손해배상금(K)</span></td>
            			                  	<td bgcolor=ecf9fb align="right"> 
            			                    <span style="font-family:nanumgothic;font-size:12px;"><%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%> 원</span></td>
            			                  	<td bgcolor=ecf9fb height=24 style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			                <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK3").equals("Y")  ) {%>            			                  			                  
            			                 			 매출 세금계산서 발행
            			              <%     }            			               			 
            			              	 } %>    
            			                  	&nbsp;</td>
            			                </tr>            			                
            			                
            			                
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=24 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">초과운행대여료(L)</span></td>
            			                  	<td bgcolor=ecf9fb align="right"> 
            			                    <span style="font-family:nanumgothic;font-size:12px;"><%=AddUtil.parseDecimal(cls.getOver_amt_1())%> 원</span></td>
            			                  	<td bgcolor=ecf9fb height=24 style="font-family:nanumgothic;font-size:12px;">&nbsp;
            			                <% if ( cls_tax.size() > 0 ) {
            			                     if (cls_tax.get("TAX_CHK4").equals("Y")  ) {%>            			                  			                  
            			                 			 매출 세금계산서 발행
            			              <%     }            			               			 
            			              	 } %>    
            			                  	&nbsp;</td>
            			                </tr>        			          
            			            
            			                <tr> 
            			                  	<td bgcolor=ecf9fb colspan="2" height=32 align=center style="font-family:nanumgothic;font-size:12px;"><span style="color:#385c9d;">부가세(M)</span></td>
            			                  	<td bgcolor=ecf9fb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>  원</td>
            			                  	<td bgcolor=ecf9fb style="font-family:nanumgothic;font-size:12px;">&nbsp;= (대여료미납입금액-B-C)×10% + 계산서 발행<br>&nbsp;&nbsp;&nbsp;&nbsp;부가세</td>
            			                </tr>
            			                <tr> 
            			                  	<td bgcolor=fffdcb colspan="4" height=27 align=center style="font-family:nanumgothic;font-size:12px;">계</td>
            			                  	<td bgcolor=fffdcb align="right" style="font-family:nanumgothic;font-size:12px;"> 
            			                   <%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>  원</td>
            			                  	<td bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;= (D+E+F+G+H+I+J+K+L+M)</td>
            			                </tr>
            			            </table>
                            <!-- 미납입금액 정산 -->
                                </td>
                            </tr>
                            <tr>
                                <td align=right height=18 style="font-family:nanumgothic;font-size:12px;">[공급가]</td>
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
            			                  <td bgcolor=f2f2f2 align='center' height=27 style="font-family:nanumgothic;font-size:12px;"><span style="color:#e60011;">*</span> 고객납입금액</td>
            			                  <td width="30%" bgcolor=fffdcb align=right style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(cls.getFdft_amt2())%> 원</td>
            			                  <td width="37%" bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;= 미납입금액-환불금액계</td>
            			                </tr>
            			              <% } %>   
            			              <% if (  cls_st.equals("8") ) {%>  
            			                 <tr>            
									    	    <td bgcolor=f2f2f2 align='center' height=27 style="font-family:nanumgothic;font-size:12px;"><span style="color:#e60011;">*</span> 매입옵션시 고객납입금액</td>
							                  <td width="30%" bgcolor=fffdcb align=right style="font-family:nanumgothic;font-size:12px;"> 
							                    <%=AddUtil.parseDecimal(cls.getFdft_amt3())%>   원</td>							                
							                  <td width="37%" bgcolor=fffdcb style="font-family:nanumgothic;font-size:12px;">&nbsp;=고객납입금액+차량매각금액+이전등록비용(발생한 경우)</td>										                  						                  
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
				              <%	//이행보증보험
											ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);%>
				
                                <td>
                                    <table border="0" cellspacing="1" cellpadding="0" width="100%" bgcolor=cacaca>
            			                <tr> 
            			                  <td bgcolor=f2f2f2 align='center' height=27 style="font-family:nanumgothic;font-size:12px;">
            			                  <%if(gins.getGi_st().equals("1")){%>가입<%}else if(gins.getGi_st().equals("0")){ gins.setGi_amt(0);%>면제<%}%>
            			                  </td>
            			                  <td width="30%" bgcolor=ffffff align=right style="font-family:nanumgothic;font-size:12px;"> 
            			                    <%=AddUtil.parseDecimal(gins.getGi_amt())%>   원</td>
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
                                			<td style="font-family:nanumgothic;font-size:13px;line-height:22px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#385c9d;"><b>신한은행</b></span> &nbsp; 140-004-023871 &nbsp;&nbsp;&nbsp;&nbsp;
                                				<span style="color:#385c9d;"><b>우리은행</b></span> &nbsp; 103-293206-13-001 &nbsp;&nbsp;&nbsp;&nbsp;
                                				<span style="color:#385c9d;"><b>농협은행</b></span> &nbsp; 367-17-014214
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
                                			<td style="font-family:nanumgothic;font-size:13px;line-height:22px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(주)아마존카</td>
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif style="font-family:nanumgothic;font-size:11px;">* 사전정산서입니다.&nbsp;실제 정산시 금액 차이가 있을 수 있습니다</td>
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
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif style="font-family:nanumgothic;font-size:11px;">본 메일은 발신전용 메일이므로 궁금한 사항은 <a href=mailto:tax@amazoncar.co.kr><span style="font-size:11px;color:#af2f98;font-family:nanumgothic;">수신메일(tax@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</td>
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