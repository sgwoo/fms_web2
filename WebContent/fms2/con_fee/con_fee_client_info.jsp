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
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	
	String rent_mng_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String rent_l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 		= request.getParameter("r_st")==null?"":request.getParameter("r_st");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
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
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
                    <td class=title style="font-size : 8pt;">용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
                    <td class=title style="font-size : 8pt;">관리구분</td>
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td style='height:5'></td>
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
                      <%if(client.getClient_st().equals("1")) 		out.println("법인");
                      	else if(client.getClient_st().equals("2"))  out.println("개인");
                      	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");%>
                    </td>
                </tr>
    		    <%if(!client.getClient_st().equals("2")){%>
    		    <tr>
        		    <td width="10%" class='title' style="font-size : 8pt;">사업자번호<br/></td>
        		    <td colspan="3">&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
        		    <td width="10%" class='title' style="font-size : 8pt;"><%if(client.getClient_st().equals("1")){%>법인번호<%}else if(client.getClient_st().equals("2")){%>생년월일<%}else{%>생년월일<%}%></td>
        		    <td colspan="3">&nbsp;<%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%></td>
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
        		    <td colspan="3">&nbsp;<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
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
        		    <td>&nbsp;<%if(client.getPay_st().equals("1")) 		out.println("급여소득");
        	              	else if(client.getPay_st().equals("2"))    out.println("사업소득");
        	               	else if(client.getPay_st().equals("3"))	out.println("기타사업소득");%></td>
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
                      <%if(client.getPrint_st().equals("1")) 		out.println("계약건별");
                      	else if(client.getPrint_st().equals("2"))   out.println("거래처통합");
                      	else if(client.getPrint_st().equals("3")) 	out.println("지점통합");
                     	else if(client.getPrint_st().equals("4"))	out.println("현장통합");%></td>
                    <td class='title' style="font-size : 8pt;">계산서비고</td>
                    <td>&nbsp;<%if(!client.getBigo_yn().equals("Y")){%>미표시<%}%></td>
                    <td class='title' style="font-size : 8pt;">네오엠코드</td>
                    <td colspan="3">&nbsp;<%if(!client.getVen_code().equals("")){%>(<%=client.getVen_code()%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%></td>
		        </tr>
    		    <tr>
                    <td class='title' style="font-size : 7pt;">거래명세서메일</td>
                    <td colspan="3">&nbsp;<%  if(client.getItem_mail_yn().equals("N")) 		out.println("거부");
                      	else   										out.println("승락");
                     	%></td>		   
                    <td class='title' style="font-size : 7pt;">세금계산서메일</td>
                    <td colspan="3">&nbsp;<%  if(client.getTax_mail_yn().equals("N")) 		out.println("거부");
                      	else   										out.println("승락");
                     	%></td>		   									
    		    <tr>
                    <td class='title' style="font-size : 8pt;">메일거부사유</td>
                    <td colspan="3">&nbsp;<%=client.getEtax_not_cau()%></td>		   
                    <td class='title' style="font-size : 8pt;">연체문자수신</td>
                    <td colspan="3">&nbsp;<%  if(client.getDly_sms().equals("N")) 		out.println("거부");
                      	else   										out.println("승락");
                     	%></td>		   					
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
                      <%if(site.getSite_st().equals("1")) 		out.println("지점");
                      	else if(site.getSite_st().equals("2"))  out.println("현장");%>
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
                    <td width='65%' align='left'>&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
                    <td width='10%' class='title' style="font-size : 8pt;">FMS</td>
                    <td width='15%' align='left' style="font-size : 8pt;">&nbsp;ID&nbsp; :<%=m_bean.getMember_id()%><br>&nbsp;PW:<%=m_bean.getPwd()%></td>			
                </tr>		  
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
    <tr>
        <td style='height:15'></td>
    </tr>  
    <tr>
        <td align='right'><span class="c"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></span></td>
    </tr>
</table>	
</body>
</html>
