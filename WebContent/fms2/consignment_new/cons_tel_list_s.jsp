<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String rent_mng_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String rent_l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");

	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
		
	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
		
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
	int mgr_size = car_mgrs.size();
		
	//탁송등 연락처 추가 - 20200611
	Vector ctel_list = cs_db.getConsignmentTelList(rent_l_cd);
	
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
		        <% } %>
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
   
	<tr>
        <td style='height:15'></td>
    </tr>  	
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객연락처</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
               <tr>
          		    <td class=title width="20%" style="font-size : 8pt;">담당자</td>
          		    <td class=title width="15%" style="font-size : 8pt;">직급</td>
                    <td class=title width="25%" style="font-size : 8pt;">사무실</td>			
                    <td class=title width="25%" style="font-size : 8pt;">휴대폰</td>
                    <td class=title width="15%" style="font-size : 8pt;">탁송월</td>
               </tr>     
              <%
        		  	for(int i = 0 ; i <ctel_list.size()  ; i++){
        		  		
        		  		Hashtable ht1 = (Hashtable)ctel_list.elementAt(i);        			
        	  %>
            
                <tr> 
                    <td align='center'><%=ht1.get("MAN")%></td>
                    <td align='center'><%=ht1.get("TITLE")%></td>
                    <td align='center'><%=ht1.get("TEL")%></td>
                    <td align='center'><%=ht1.get("M_TEL")%></td>
                    <td align='center'><%=ht1.get("YM")%></td>               
                  
                </tr>
               <% } %> 
            </table>
        </td>
    </tr>
	
    <tr>
        <td align='center'><span class="c"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></span></td>
    </tr>
</table>	
</body>
</html>
