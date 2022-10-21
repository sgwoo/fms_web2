<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, cust.member.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String rent_l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 		= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")){ base.setCar_gu(base.getReg_id()); }
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//네오엠 거래처 정보	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable ven = new Hashtable();
	if(!client.getVen_code().equals("")){
		ven = neoe_db.getVendorCase(client.getVen_code());
	}
	
	//고객FMS
	MemberBean m_bean = m_db.getMemberCase(base.getClient_id(), base.getR_site(), "");
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
	int mgr_size = car_mgrs.size();
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//보험정보
	String ins_st = "";
	String ins_com_nm = "";
	
	//차량등록정보&보험
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		
		ins_st 	= ai_db.getInsSt(base.getCar_mng_id());
		ins 	= ai_db.getIns(base.getCar_mng_id(), ins_st);
		ins_com_nm = ai_db.getInsComNm(base.getCar_mng_id());
	}
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//기본사양 포함 차명
	String car_b_inc_name = cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//영업,출고사원
	Hashtable mgrs = a_db.getCommiNInfo(rent_mng_id, rent_l_cd);
	Hashtable mgr_bus = (Hashtable)mgrs.get("BUS");
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");
	
	//자동이체정보
	ContCmsBean cms 	= a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	//계약승계 혹은 차종변경일때 승계계약 해지내용
	Hashtable cng_cont = af_db.getScdFeeCngContA(rent_mng_id, rent_l_cd);
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<table border=0 cellspacing=0 cellpadding=0 width=780>
	<%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계") || String.valueOf(cng_cont.get("CLS_ST")).equals("차종변경") || String.valueOf(cng_cont.get("CLS_ST")).equals("4") || String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>
	<tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>[계약승계] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("FIRM_NM")%>, 승계일자 : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%> <%}%>
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>[차종변경] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, 변경일자 : <%=begin.get("CLS_DT")%><%}%>            	    
					
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>[계약승계] 승계계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 승계일자 : <%if(String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("")){%><%=cng_cont.get("CLS_DT")%><%}else{%><%=cng_cont.get("RENT_SUC_DT")%><%}%> <%if(!String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("") && !String.valueOf(cng_cont.get("RENT_SUC_DT")).equals(String.valueOf(cng_cont.get("CLS_DT")))){%>, 해지일자 : <%=cng_cont.get("CLS_DT")%><%}%> <%}%>
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>[차종변경] 변경계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 변경일자 : <%=cng_cont.get("CLS_DT")%> <%}%>					
					</font>&nbsp;
					</td>					
                </tr>
            </table>            
        </td>
    </tr>    
    <tr> 
        <td class=h></td>
    </tr>
    <%}%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=7% style="font-size : 8pt;">계약번호</td>
                    <td width=14%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=7% style="font-size : 8pt;">영업지점</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=7% style="font-size : 8pt;">관리지점</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                    <td class=title width=7% style="font-size : 8pt;">최초영업</td>
                    <td width=8%>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title width=7% style="font-size : 8pt;">영업담당</td>
                    <td width=8%>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                    <td class=title width=7% style="font-size : 8pt;">관리담당</td>
                    <td width=8%>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title style="font-size : 8pt;">계약일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title style="font-size : 8pt;">계약구분</td>
                    <td>&nbsp;<%if(base.getRent_st().equals("1")){%>신규<%}else if(base.getRent_st().equals("3")){%>대차<%}else if(base.getRent_st().equals("4")){%>증차<%}%></td>
                    <td class=title style="font-size : 8pt;">영업구분</td>
                    <td>&nbsp;<%if(base.getBus_st().equals("1")){%>인터넷<%}else if(base.getBus_st().equals("2")){%>영업사원<%}else if(base.getBus_st().equals("3")){%>업체소개<%}else if(base.getBus_st().equals("4")){%>catalog<%}else if(base.getBus_st().equals("5")){%>전화상담<%}else if(base.getBus_st().equals("6")){%>기존업체<%}else if(base.getBus_st().equals("7")){%>에이전트<%}else if(base.getBus_st().equals("8")){%>모바일<%}%></td>
                    <td class=title style="font-size : 8pt;">차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}else if(car_gu.equals("3")){%>월렌트<%}%></td>
                    <td class=title style="font-size : 8pt;">용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("4")){%>월렌트<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
                    <td class=title style="font-size : 8pt;">관리구분</td>
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td style='height:5'>
        	<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %>&nbsp;(에이전트 계약진행담당자:<%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)<%}%>
        </td>
    </tr> 
    <tr>
        <td style='height:20' align="right"><a href="lc_rent_doc_bag.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=rent_st%>" target='_blank'><img src=/acar/images/center/button_gybt.gif align=absmiddle border=0></a></td>
    </tr> 
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="10%" class='title' style="font-size : 8pt;">상호/성명</td>
        		    <td colspan="3">&nbsp;<b><font color='#990000'><%=client.getFirm_nm()%></font></b>&nbsp;<%if(!client.getClient_st().equals("2")){%><%=client.getClient_nm()%><%}%></td>
                    <td width="10%" class='title' style="font-size : 8pt;"> 고객구분 </td>
                    <td colspan="3">&nbsp; 
                      <%if(client.getClient_st().equals("1")){ 		out.println("법인");
                      }else if(client.getClient_st().equals("2")){  out.println("개인");
                      }else if(client.getClient_st().equals("3")){ 	out.println("개인사업자(일반과세)");
                      }else if(client.getClient_st().equals("4")){	out.println("개인사업자(간이과세)");
                      }else if(client.getClient_st().equals("5")){ 	out.println("개인사업자(면세사업자)"); }%>
                    </td>
                </tr>
    		    <%if(!client.getClient_st().equals("2")){%>
    		    <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">사업자번호<br/></td>
        		    <td colspan="3">&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;"><%if(client.getClient_st().equals("1")){%>법인번호<%}else{%>생년월일<%}%></td>
        		    <td colspan="3">&nbsp;<%=client.getSsn1()%>-<%if(client.getClient_st().equals("1")){%><%=client.getSsn2()%><%}else{%><%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%><%}%></td>
		        </tr>
		        <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">업태</td>
        		    <td colspan="3"">&nbsp;<%=client.getBus_cdt()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">종목</td>
        		    <td colspan="3">
        		        <table width=100% border=0 cellspacing=0 cellpadding=3>
        		            <tr>
        		                <td><%=client.getBus_itm()%></td>
        		            </tr>
        		        </table>
        		    </td>
		        </tr>
		        <tr>
        		    <td class='title' style="font-size : 8pt;">사업장 주소</td>
        		    <td colspan="7">&nbsp;<%if(!client.getO_addr().equals("")){%>(<%=client.getO_zip()%>)<%=client.getO_addr()%><%}%></td>
		        </tr>
		        <tr>
        		    <td class='title' style="font-size : 8pt;"><%if(client.getClient_st().equals("1")){%>본점 소재지<%}else{%>사업자 주소<%}%></td>
        		    <td colspan="7">&nbsp;<%if(!client.getHo_addr().equals("")){%>(<%=client.getHo_zip()%>)<%=client.getHo_addr()%><%}%></td>
		        </tr>
		        <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">휴대폰번호</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">자택번호</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">사무실번호</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">팩스번호</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
		        </tr>
		        <%}else{%>
		        <tr>
        		    <td class='title' style="font-size : 8pt;">생년월일</td>
        		    <td colspan="3">&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%></td>
        		    <td class='title' style="font-size : 8pt;">자택주소</td>
        		    <td colspan="3" style="font-size : 8pt;">&nbsp;<%if(!client.getHo_addr().equals("")){%>(<%=client.getHo_zip()%>)<%=client.getHo_addr()%><%}%></td>
    		    </tr>
	            <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">휴대폰번호</td>
        		    <td width="15%" >&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">자택번호</td>
        		    <td width="15%" >&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">직장번호</td>
        		    <td width="15%" >&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">직장FAX</td>
        		    <td width="15%" >&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
		        </tr>
			        <tr>
	        		    <td class='title' style="font-size : 8pt;">직업</td>
	        		    <td>&nbsp;<%=client.getJob()%></td>
	        		    <td class='title' style="font-size : 8pt;">소득구분</td>
	        		    <td>&nbsp;<%if(client.getPay_st().equals("1")){ 		out.println("급여소득");
		        		    }else if(client.getPay_st().equals("2")){    out.println("사업소득");
		        		    }else if(client.getPay_st().equals("3")){    out.println("기타사업소득"); }%>
	        		    </td>
	        		    <td class='title' style="font-size : 8pt;">근속연수</td>
	        		    <td>&nbsp;<%=client.getWk_year()%>년</td>
	        		    <td class='title' style="font-size : 8pt;">연소득</td>
	        		    <td>&nbsp;<%=client.getPay_type()%>만원</td>
			        </tr>
		        <tr>
        		    <td class='title' style="font-size : 8pt;">직장명</td>
        		    <td>&nbsp;<%=client.getCom_nm()%></td>
        		    <td class='title' style="font-size : 8pt;">부서/직위</td>
        		    <td>&nbsp;<%=client.getDept()%>/<%=client.getTitle()%></td>
        		    <td class='title' style="font-size : 8pt;">직장주소</td>
        		    <td colspan="3">&nbsp;<%if(!client.getComm_addr().equals("")){%>(<%=client.getComm_zip()%>)<%=client.getComm_addr()%><%}%></td>   
		        </tr>			
    		    <%}%>   
                <tr>
                    <td class='title' style="font-size : 8pt;">발행구분</td>
                    <td>&nbsp;
                      <%if(client.getPrint_st().equals("1")){ 		out.println("계약건별");
                      }else if(client.getPrint_st().equals("2")){   out.println("거래처통합");
                      }else if(client.getPrint_st().equals("3")){ 	out.println("지점통합");
                      }else if(client.getPrint_st().equals("4")){	out.println("현장통합"); }%>
                    </td>
                    <td class='title' style="font-size : 8pt;">계산서비고</td>
                    <td>&nbsp;<%if(!client.getBigo_yn().equals("Y")){%>미표시<%}%></td>
                    <td class='title' style="font-size : 8pt;">네오엠코드</td>
                    <td colspan="3">&nbsp;<%if(!client.getVen_code().equals("")){%>(<%=client.getVen_code()%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%></td>
                </tr>
                <tr>
                    <td class='title' style="font-size : 7pt;">거래명세서메일</td>
                    <td colspan="3">&nbsp;<%  if(client.getItem_mail_yn().equals("N")){ 		out.println("거부");
                    	}else{   										out.println("승락"); }
                     	%></td>		   
                    <td class='title' style="font-size : 7pt;">세금계산서메일</td>
                    <td colspan="3">&nbsp;<%  if(client.getTax_mail_yn().equals("N")){ 		out.println("거부");
                    	}else{   										out.println("승락"); }
                     	%></td>		   									
    		    <tr>
                    <td class='title' style="font-size : 8pt;">메일거부사유</td>
                    <td colspan="3">&nbsp;<%=client.getEtax_not_cau()%></td>		   
                    <td class='title' style="font-size : 8pt;">연체문자수신</td>
                    <td colspan="3">&nbsp;<%  if(client.getDly_sms().equals("N")){ 		out.println("거부");
                    	}else{   										out.println("승락"); }%></td>		   					
                </tr>	
                <tr>
                    <td class='title' style="font-size : 8pt;">면책금CMS청구여부</td>
                    <td colspan="3">&nbsp;<%  if (client.getEtc_cms().equals("N")){ 		out.println("거부");
	                    }else if (client.getEtc_cms().equals("Y")){ 	out.println("승락");
	    				}else{  										out.println("  "); }
                     	%>
                      &nbsp;&nbsp;* CMS 거래고객에 한함.</td>		   
                    <td class='title' style="font-size : 8pt;">선납과태료청구여부</td>
                    <td colspan="3">&nbsp;<%  if (client.getFine_yn().equals("N")){ 		out.println("거부");
	                    }else if (client.getFine_yn().equals("Y")){ 	out.println("승락");
	                    }else{  										out.println("  "); }
                     	%>
                    </td>		   					
                </tr>	                		
                 <tr>
                    <td class='title' style="font-size : 8pt;">연체이자 CMS청구여부</td>
                    <td colspan="7">&nbsp;<%  if (client.getDly_yn().equals("N")){ 		out.println("거부");
	                    }else if (client.getDly_yn().equals("Y")){ 	out.println("승락");
	                    }else{  										out.println("  "); }
                     	%>
                      &nbsp;&nbsp;* CMS 거래고객에 한함.</td>	   
                  		   					
                </tr>	                                	                       
		        <%if(!client.getEtc().equals("")){%>
		<tr>
                    <td class='title' style="font-size : 8pt;"> 특이사항 </td>
                    <td colspan="7">
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td><%=Util.htmlBR(client.getEtc())%></td>	
                            </tr>
                        </table>
                    </td>	  
                </tr>
		        <%}%>
            </table>
        </td>
	</tr>    
  <%if(!site.getR_site().equals("")){%>
  <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
        		    <td class='title' style="font-size : 8pt;">상호/성명</td>
        		    <td colspan='3'>&nbsp;<b><%=site.getR_site()%></b>&nbsp;<%=site.getSite_jang()%></td>		  
                    <td class='title' style="font-size : 8pt;"> 구분 </td>
                    <td colspan='3'>&nbsp; 
                      <%if(site.getSite_st().equals("1")){ 		out.println("지점");
                      	}else if(site.getSite_st().equals("2")){  out.println("현장"); }%>
                    </td>
                </tr>
		        <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">사업자번호</td>
        		    <td width="15%">&nbsp;<%=site.getEnp_no()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">네오엠코드</td>
        		    <td width="15%">&nbsp;<%=site.getVen_code()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">사무실번호</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(site.getTel())%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">팩스번호</td>
        		    <td width="15%">&nbsp;<%=AddUtil.phoneFormat(site.getFax())%></td>				  
		        </tr>
		        <tr>
        		    <td class='title' style="font-size : 8pt;">주소</td>
        		    <td colspan='7' style="font-size : 8pt;">&nbsp;<%if(!site.getAddr().equals("")){%>(<%=site.getZip()%>)<%=site.getAddr()%><%}%></td>
		        </tr>
		        <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">업태</td>
        		    <td colspan='3' >&nbsp;<%=site.getBus_cdt()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;">종목</td>
        		    <td colspan='3' >&nbsp;<%=site.getBus_itm()%></td>
		        </tr>
            </table>
        </td>
	</tr> 
	<%}%> 
    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='10%' class='title' style="font-size : 8pt;">우편물주소</td>
                    <td align='left'>&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
                </tr>		  
                <%if(!nm_db.getWorkAuthUser("아마존카이외",ck_acar_id)){%>
                <tr>
                    <td width='10%' class='title' style="font-size : 8pt;">FMS</td>
                    <td align='left'>&nbsp;ID:&nbsp;<%=m_bean.getMember_id()%> &nbsp;PW:&nbsp;<%=m_bean.getPwd()%></td>			
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
     	
    <tr>
        <td style='height:15'></td>
    </tr>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객관계자</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="10%" style="font-size : 8pt;">구분</td>
                    <td class=title width="10%" style="font-size : 8pt;">근무처</td>			
                    <td class=title width="10%" style="font-size : 8pt;">부서</td>
                    <td class=title width="10%" style="font-size : 8pt;">성명</td>
                    <td class=title width="10%" style="font-size : 8pt;">직위</td>
                    <td class=title width="13%" style="font-size : 8pt;">전화번호</td>
                    <td class=title width="13%" style="font-size : 8pt;">휴대폰</td>
                    <td class=title style="font-size : 8pt;">E-MAIL</td>
                </tr>
		        <%if(base.getTax_type().equals("1")){%>
                <tr> 
                    <td align='center'>세금계산서</td>
                    <td align='center'>본사</td>
                    <td align='center'><%=client.getCon_agnt_dept()%></td>
                    <td align='center'><%=client.getCon_agnt_nm()%></td>
                    <td align='center'><%=client.getCon_agnt_title()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%></td>
                    <td align='center'><%=client.getCon_agnt_email()%></td>
                </tr>		  
                <tr> 
                    <td align='center'>세금계산서</td>
                    <td align='center'>추가담당자</td>
                    <td align='center'><%=client.getCon_agnt_dept2()%></td>
                    <td align='center'><%=client.getCon_agnt_nm2()%></td>
                    <td align='center'><%=client.getCon_agnt_title2()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(client.getCon_agnt_o_tel2())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(client.getCon_agnt_m_tel2())%></td>
                    <td align='center'><%=client.getCon_agnt_email2()%></td>
                </tr>		                
		        <%}else if(base.getTax_type().equals("2")){%>
                <tr> 
                    <td align='center'>세금계산서</td>
                    <td align='center'>지점</td>
                    <td align='center'><%=site.getAgnt_dept()%></td>
                    <td align='center'><%=site.getAgnt_nm()%></td>
                    <td align='center'><%=site.getAgnt_title()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(site.getAgnt_tel())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(site.getAgnt_m_tel())%></td>
                    <td align='center'><%=site.getAgnt_email()%></td>
                </tr>
<tr> 
                    <td align='center'>세금계산서</td>
                    <td align='center'>추가담당자</td>
                    <td align='center'><%=site.getAgnt_dept2()%></td>
                    <td align='center'><%=site.getAgnt_nm2()%></td>
                    <td align='center'><%=site.getAgnt_title2()%></td>
                    <td align='center'><%=site.getAgnt_tel2()%></td>
                    <td align='center'><%=site.getAgnt_m_tel2()%></td>
                    <td align='center'><%=site.getAgnt_email2()%></td>
                </tr>                     
        		  <%}%>
        		  <%String mgr_zip = "";
        			String mgr_addr = "";
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("차량이용자")){
        					mgr_zip = mgr.getMgr_zip();
        					mgr_addr = mgr.getMgr_addr();
        				}%>
                <tr> 
                    <td align='center'><%=mgr.getMgr_st()%></td>
                    <td align='center'><%=mgr.getCom_nm()%></td>
                    <td align='center'><%=mgr.getMgr_dept()%></td>
                    <td align='center'><%=mgr.getMgr_nm()%></td>
                    <td align='center'><%=mgr.getMgr_title()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_tel())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_m_tel())%></td>
                    <td align='center'><%=mgr.getMgr_email()%></td>
                </tr>
		        <%	} %>
            </table>
        </td>
    </tr>
    <%if(!nm_db.getWorkAuthUser("아마존카이외",ck_acar_id)){%>    	  
    <tr>
        <td style='height:15'></td>
    </tr>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차영업소</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class=title style="font-size : 8pt;">구분</td>
        	        <td width='15%' class=title style="font-size : 8pt;">회사</td>
                    <td width='15%' class=title style="font-size : 8pt;">영업소</td>
                    <td width='7%' class=title style="font-size : 8pt;">이름</td>
                    <td width='8%' class=title style="font-size : 8pt;">직위</td>
                    <td width='12%' class=title style="font-size : 8pt;">전화번호</td>
                    <td width='12%' class=title style="font-size : 8pt;">휴대폰</td>
                    <td width='12%' class=title style="font-size : 8pt;">FAX</td>
                    <td width='9%' class=title style="font-size : 8pt;">영업수당</td>					
                </tr>
		        <%if(!String.valueOf(mgr_bus.get("NM")).equals("") && !String.valueOf(mgr_bus.get("NM")).equals("null")){%>
                <tr> 
                    <td align='center'>영업</td>
                    <td align='center'><%=mgr_bus.get("COM_NM")%></td>
                    <td align='center'><%=mgr_bus.get("CAR_OFF_NM")%></td>
                    <td align='center'><%=mgr_bus.get("NM")%></td>
                    <td align='center'><%=mgr_bus.get("POS")%> </td>
                    <td align='center'><%=mgr_bus.get("O_TEL")%> </td>
                    <td align='center'><%=mgr_bus.get("TEL")%> </td>
                    <td align='center'><%=mgr_bus.get("FAX")%> </td>
                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(mgr_bus.get("COMMI")))%>원</td>					
                </tr>		  
        		  <%}%>
        		  <%if(!String.valueOf(mgr_dlv.get("NM")).equals("") && !String.valueOf(mgr_dlv.get("NM")).equals("null")){%>
                <tr> 
                    <td align='center'>출고</td>
                    <td align='center'><%=mgr_dlv.get("COM_NM")%></td>
                    <td align='center'><%=mgr_dlv.get("CAR_OFF_NM")%></td>
                    <td align='center'><%=mgr_dlv.get("NM")%></td>
                    <td align='center'><%=mgr_dlv.get("POS")%> </td>
                    <td align='center'><%=mgr_dlv.get("O_TEL")%> </td>
                    <td align='center'><%=mgr_dlv.get("TEL")%> </td>
                    <td align='center'><%=mgr_dlv.get("FAX")%> </td>
                    <td align='center'>-</td>					
                </tr>
		        <%}%>
            </table>
        </td>
    </tr>
    <%}%>	
    <tr>
        <td style='height:15'></td>
    </tr>  
	<%if(!ins.getCar_mng_id().equals("")){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차보험</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="10%" class=title style="font-size : 8pt;">보험회사</td>
                    <td width="15%">&nbsp;<b><font color='#990000'><span title='가입기간 : <%=ins.getIns_start_dt()%> 24시~<%=ins.getIns_exp_dt()%> 24시'><%=ins_com_nm%></span></font></b></td>
                    <td class=title width="10%" style="font-size : 8pt;">대인배상Ⅱ</td>
                    <td width=15%> 
                      <%if(ins.getVins_pcp_kd().equals("1")){%>
                      &nbsp;무한
                      <%}%>
                      <%if(ins.getVins_pcp_kd().equals("2")){%>
                      &nbsp;유한
                      <%}%>
                    </td>
                    <td width=10% class=title style="font-size : 8pt;">대물배상</td>
                    <td> 
                      <%if(ins.getVins_gcp_kd().equals("6")){%>
                      &nbsp;5억원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("8")){%>
                      &nbsp;3억원 
                      <%}%>
					  <%if(ins.getVins_gcp_kd().equals("7")){%>
                      &nbsp;2억원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("3")){%>
                      &nbsp;1억원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("1")){%>
                      &nbsp;3천만원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("2")){%>
                      &nbsp;1천5백만원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("5")){%>
                      &nbsp;1천만원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("4")){%>
                      &nbsp;5천만원 
                      <%}%>
                    </td>
                </tr>
                <tr>
                  <td width="10%" class=title style="font-size : 8pt;">피보험자</td>
                  <td width="15%">&nbsp;
                    <%if(ins.getCon_f_nm().equals("아마존카")){%>
                    <%=ins.getCon_f_nm()%>
                    <%}else{%>
                    <b><font color='#990000'><%=ins.getCon_f_nm()%></font></b>
                  <%}%></td>
                  <td class=title style="font-size : 8pt;">보험연령</td>
                  <td>&nbsp;
                    <%if(ins.getAge_scp().equals("1")){%>
                    21세이상
                    <%}%>
                    <%if(ins.getAge_scp().equals("4")){%>
                    24세이상
                    <%}%>
                    <%if(ins.getAge_scp().equals("2")){%>
                    26세이상
                    <%}%>
                    <%if(ins.getAge_scp().equals("3")){%>
                    전연령
                    <%}%>
                    <%if(ins.getAge_scp().equals("5")){%>
                    30세이상
                    <%}%>
                    <%if(ins.getAge_scp().equals("6")){%>
                    35세이상
                    <%}%>
                    <%if(ins.getAge_scp().equals("7")){%>
                    43세이상
                    <%}%>
                    <%if(ins.getAge_scp().equals("8")){%>
                    48세이상
                    <%}%></td>
                  <td class=title style="font-size : 8pt;">자기신체</td>
                  <td>&nbsp;1인당사망/장애:
                    <%if(ins.getVins_bacdt_kd().equals("1")){%>
					3억원
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("2")){%>
					1억5천만원
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("3")){%>
					3천만원
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("4")){%>
					1천5백만원
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("5")){%>
					5천만원
					<%}%>
					<%if(ins.getVins_bacdt_kd().equals("6")){%>
					1억원
					<%}%>
					, 1인당부상:
					<%if(ins.getVins_bacdt_kc2().equals("1")){%>
					3억원
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("2")){%>
					1억5천만원
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("3")){%>
					3천만원
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("4")){%>
					1천5백만원
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("5")){%>
					5천만원
					<%}%>
					<%if(ins.getVins_bacdt_kc2().equals("6")){%>
					1억원
					<%}%>
					</td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">자차면책금</td>
                  <td>&nbsp; <%=AddUtil.parseDecimal(base.getCar_ja())%>원</td>
                  <td class=title style="font-size : 8pt;">무보험차상해</td>
                  <td>&nbsp;
                    <%if(ins.getVins_canoisr_amt()>0){%>
가입
<%}else{%>
-
<%}%></td>
                  <td class=title style="font-size : 8pt;">자기차량손해</td>
                  <td>&nbsp;
                    <%if(ins.getVins_cacdt_cm_amt()>0){%>
					<b><font color='#990000'>
가입 ( 차량 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>만원, 자기부담금 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>만원)
                    </font></b>
					<%}else{%>
                    -
                    <%}%></td>
                </tr>	                			
            </table>
        </td>
    </tr>
    <tr>
        <td style='height:15'></td>
    </tr>
	<%}%>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여차량</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		    <%if(!cr_bean.getCar_no().equals("")){%>
		        <tr>
                	<td width="10%" class='title' style="font-size : 8pt;">차량번호</td>
        		    <td width="15%">&nbsp;<b><font color='#990000'><%=cr_bean.getCar_no()%></font></b></td>
        		    <td width='10%' class='title' style="font-size : 8pt;">관리번호</td>
        		    <td width="15%">&nbsp;<%=cr_bean.getCar_doc_no()%></td>
                	<td width="10%" class='title' style="font-size : 8pt;">최초등록일</td>
        		    <td width="15%">&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                	<td width="10%" class='title' style="font-size : 8pt;">차령만료일</td>
        		    <td width="15%">&nbsp;<%=cr_bean.getCar_end_dt()%></td>
		        </tr>			  
		        <%}%>	  
                <tr>
                    <td class='title' style="font-size : 8pt;">자동차회사</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' style="font-size : 8pt;">차명</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' style="font-size : 8pt;">차종</td>
                    <td colspan="3">&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[저공해]<%}%><%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class='title' style="font-size : 8pt;">옵션</td>
                    <td colspan="7">&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr>
                    <td class='title' style="font-size : 8pt;">색상</td>
                    <td colspan="7">&nbsp;<%=car.getColo()%>&nbsp;/&nbsp;<%=car.getIn_col()%>&nbsp;/&nbsp;<%=car.getGarnish_col()%></td>
                </tr>
                <tr>
                    <td  width="10%" class='title' style="font-size : 8pt;"> 썬팅</td>
                    <td width="15%">&nbsp;<%=car.getSun_per()%>%</td>
                    <td  width="10%" class='title' style="font-size : 8pt;">소분류 </td>
                    <td width="15%">&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%>&nbsp;<%=cm_bean.getSh_code()%></td>
                    <td  width="10%" class='title' style="font-size : 8pt;">배기량</td>
                    <td width="15%">&nbsp;<%=cm_bean.getDpm()%>cc</td>
                    <td  width="10%" class='title' style="font-size : 8pt;">등록지역</td>			
                    <td width="15%">&nbsp;<%String car_ext = car.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%></td>
                </tr>
                <%if(!nm_db.getWorkAuthUser("아마존카이외",ck_acar_id)){%>    	  
                <tr>
                    <td class='title' style="font-size : 8pt;">기본차가</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>원</td>
                    <td class='title' style="font-size : 8pt;">옵션가</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>원</td>
                    <td class='title' style="font-size : 8pt;">색상가</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>원</td>
                    <td class='title' style="font-size : 8pt;">매출DC</td>			
                    <td>&nbsp;<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>원</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <%if(!nm_db.getWorkAuthUser("아마존카이외",ck_acar_id)){%>    	  
    <tr>
        <td style='height:15'></td>
    </tr>  	
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여조건</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="4%" class=title rowspan="2">연번</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">계약일자</td>
                    <td style="font-size : 8pt;" width="4%" class=title rowspan="2">이용<br>기간</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">대여개시일</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">대여만료일</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">담당자</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">월대여료</td>
                    <td style="font-size : 8pt;" class=title colspan="2">보증금</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">선납금</td>
                    <td style="font-size : 8pt;" class=title colspan="2">개시대여료</td>
                    <td style="font-size : 8pt;" class=title colspan="2">매입옵션</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="9%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="4%" class=title>승계</td>
                    <td style="font-size : 8pt;" width="9%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="4%" class=title>승계</td>
                    <td style="font-size : 8pt;" width="9%" class=title>금액</td>
                    <td style="font-size : 8pt;" width="4%" class=title>%</td>			
                </tr>
		        <%for(int i=0; i<fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getRent_dt()%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getRent_start_dt()%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getRent_end_dt()%></td>
                    <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
		        <%}}%>
            </table>
	    </td>
	</tr>
	<%if(!cms.getCms_bank().equals("")){%>
	<tr>
        <td style='height:15'></td>
    </tr>  	
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동이체</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td  width="10%" class='title' style="font-size : 8pt;">거래은행</td>
                    <td width="15%">&nbsp;<%=cms.getCms_bank()%></td>
                    <td  width="10%" class='title' style="font-size : 8pt;">이체일 </td>
                    <td width="15%">&nbsp;<%=cms.getCms_day()%>일</td>
                    <td  width="10%" class='title' style="font-size : 8pt;">인출기간</td>
                    <td width="40%">&nbsp;<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>
					&nbsp;&nbsp;
					<!--
					<b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
        			&nbsp;&nbsp;<a href="acms_list.jsp?acode=<%=rent_l_cd%>" target="_blank"><img src=/acar/images/center/button_in_acms.gif border=0 align=absmiddle></a>
        			-->
        			</td>
                </tr>
            </table>
        </td>
    </tr>
	<%}%>	
	<%-- <%if(gins.getGi_st().equals("1") || car.getGi_st().equals("1")){%>
	<tr>
        <td style='height:15'></td>
    </tr>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증보험</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="10%" class='title' style="font-size : 8pt;">가입금액</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(gins.getGi_amt())%>원</td>
                    <td width="10%" class=title  style="font-size : 8pt;">보증보험료</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(gins.getGi_fee())%>원</td>
                    <td width="10%" class=title style="font-size : 8pt;">발행지점</td>
                    <td width="15%">&nbsp;<%=gins.getGi_jijum()%></td>
                    <!-- 보증보험 가입개월 추가(2018.03.22) -->
                    <td width="10%" class=title style="font-size : 8pt;">가입개월</td>
                    <td width="15%">&nbsp;<%=gins.getGi_month()%><%if(!gins.getGi_month().equals("")){%>개월<%}%></td>
                </tr>
            </table>
	    </td>
    </tr>    
	<%}%> --%>
	
	<!-- 연장계약건은 보증보험 이력 모두 표시(20190826) -->
	<%if(!base.getCar_st().equals("4")){%>
    <%	
		  //이행보증보험
		  	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
		  	if(gin_size==0) gin_size = 1;
		  	String user_id = ck_acar_id;
			for(int f=1; f<=gin_size ; f++){
				ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));
		%>       
    <tr>
        <td class=h></td>
    </tr> 
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(f >1){%><%=f%>차 연장 <%}%>보증보험</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr id=tr_gi style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">가입여부</td>
                    <td colspan="5">&nbsp;<%if(ext_gin.getGi_st().equals("1")){%>가입<%}else if(ext_gin.getGi_st().equals("0")){%>면제<%}%></td>
                </tr>
                <tr id=tr_gi1 style="display:<%if(ext_gin.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>발행지점</td>
                    <td width="20%">&nbsp;<%=ext_gin.getGi_jijum()%></td>
                    <td width="10%" class='title'>가입금액</td>
                    <td width="20%" >&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>원</td>
                    <td width="10%" class=title >보증보험료</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>원</td>
                </tr>
                <tr id=tr_gi2 style="display:<%if(ext_gin.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>증권번호</td>
                    <td width="20%">&nbsp;제<%=ext_gin.getGi_no()%>호</td>
                    <td width="10%" class='title'>보험기간</td>
                    <td width="20%" >&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_start_dt())%>~<%=AddUtil.ChangeDate2(ext_gin.getGi_end_dt())%></td>
                    <td class=title >보험가입일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
   		<%}%>
    <%}%>
	
    <%}%>
	<%if(!cls.getRent_l_cd().equals("")){%>
	<tr>
        <td style='height:15'></td>
    </tr>  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약해지</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="10%" class='title' style="font-size : 8pt;">해지구분</td>
                    <td width="15%">&nbsp;<%=cls.getCls_st()%></td>
                    <td width="10%" class=title  style="font-size : 8pt;">해지일자</td>
                    <td width="15%">&nbsp;<%=cls.getCls_dt()%></td>
                    <td width="10%" class=title style="font-size : 8pt;">해지내용</td>
                    <td width="40%">&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%></td>
                </tr>
            </table>
	    </td>
    </tr>    
	<%}%>	
    <tr>
        <td align='center'><span class="c"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></span></td>
    </tr>
</table>	
</body>
</html>
