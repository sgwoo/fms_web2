<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.estimate_mng.*, acar.car_register.*, cust.member.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%

	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
	int mgr_size = car_mgrs.size();
	
	//고객FMS
	MemberBean m_bean = m_db.getMemberCase(base.getClient_id(), base.getR_site(), "");
	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	
	//고객재무제표
	ClientFinBean c_fin = al_db.getClientFin(base.getClient_id(), cont_etc.getFin_seq());
	
	//신용평가 조회
	ContEvalBean eval1 = new ContEvalBean();
	ContEvalBean eval2 = new ContEvalBean();
	ContEvalBean eval3 = new ContEvalBean();
	ContEvalBean eval4 = new ContEvalBean();
	ContEvalBean eval5 = new ContEvalBean();
	ContEvalBean eval6 = new ContEvalBean();
	ContEvalBean eval7 = new ContEvalBean();
	ContEvalBean eval8 = new ContEvalBean();	
	
	//신용등급코드
	CodeBean[] gr_cd1 = c_db.getCodeAll2("0013", "1");
	CodeBean[] gr_cd2 = c_db.getCodeAll2("0013", "2");
	CodeBean[] gr_cd3 = c_db.getCodeAll2("0013", "3");
	//자산형태
	CodeBean[] ass_cd = c_db.getCodeAll2("0014", "");
	
	from_page = "/agent/lc_rent/lc_c_c_client.jsp";
	
	String valus = 	"?user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정
	function update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id'){
			window.open("/agent/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}else{
			var height = 500;
			if(st == 'client') 				height = 450;
			else if(st == 'mgr') 			height = 500;
			else if(st == 'client_guar') 	height = 250;
			else if(st == 'guar') 			height = 300;
			else if(st == 'dec') 			height = 700;			
			window.open("/agent/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
		}
	}
	
	//신용평가 보기(이력)
	function view_dec(){
		var fm = document.form1;
		window.open("/agent/lc_rent/view_dec.jsp?user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_c_c_client.jsp&client_id="+fm.client_id.value+"&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "VIEW_DEC", "left=50, top=50, width=850, height=600, scrollbars=yes");
	}
	//재무제표 보기(이력)
	function view_fin(){
		var fm = document.form1;
		window.open("/agent/client/client_fin_s_p.jsp?user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_c_c_client.jsp&client_id="+fm.client_id.value+"&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "VIEW_FIN", "left=50, top=50, width=750, height=500, scrollbars=yes");
	}
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
	}
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='lc_c_u_a.jsp' name="form1" method='post'>
  
  <input type='hidden' name='user_id' 			value='<%=user_id%>'>
  <input type='hidden' name='br_id' 			value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객 (<%=base.getClient_id()%>) <%if(base.getBus_id().equals(user_id)){%>&nbsp;<a href="javascript:update('client')" title="회계업무 권한자"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%></span></span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan='2' class='title'> 고객구분 </td>
                    <td colspan='3'> 
                      &nbsp;<%if(client.getClient_st().equals("1")) 		out.println("법인");
                      	else if(client.getClient_st().equals("2"))  out.println("개인");
                      	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");%>
                    </td>
                </tr>
    		    <%if(!client.getClient_st().equals("2")){%>
    		    <tr>
    		          <td colspan="2" class='title'>개업일자</td>
    		          <td>
    		            &nbsp;<%= client.getOpen_year()%></td>
    		          <td class='title'>설립일자</td>
    		          <td>
    		            &nbsp;<%= client.getFound_year()%></td>
    		    </tr>
    		    <tr>
    		          <td width='3%' rowspan="5" class='title'>사<br>
    					업<br>
    					자<br>
    					등<br>
    					록<br>
    					증</td>
    		          <td width="10%" class='title'>상호</td>
    		          <td width="37%" align='left'>&nbsp;<%=client.getFirm_nm()%></td>
    		          <td width="12%" class='title'>대표자</td>
    		          <td width="38%">&nbsp;<%=client.getClient_nm()%></td>
    		    </tr>
    		    <tr>
    		          <td class='title'>사업자번호<br/>
    		          </td>
    		          <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
    		          <td class='title'><%if(client.getClient_st().equals("1")){%>법인번호<%}else{%>생년월일<%}%></td>
    		          <td>&nbsp;<%=client.getSsn1()%>-<%if(client.getClient_st().equals("1")){%><%=client.getSsn2()%><%}else{%><%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******<%}%></td>
    		    </tr>
    		    <tr>
    		          <td class='title'>사업장 주소</td>
    		          <td colspan='3'>
    		              &nbsp;<%if(!client.getO_addr().equals("")){%>
    		              ( 
    		              <%}%>
    		              <%=client.getO_zip()%> 
    		              <%if(!client.getO_addr().equals("")){%>
    		              )&nbsp; 
    		              <%}%>
    		              <%=client.getO_addr()%>
    		           </td>
    		    </tr>		
    		    <tr>
    		          <td class='title'><%if(client.getClient_st().equals("1")){%>본점 소재지<%}else{%>사업자 주소<%}%></td>
    		          <td colspan='3'>
    		            &nbsp;<%if(!client.getHo_addr().equals("")){%>
    		              ( 
    		              <%}%>
    		              <%=client.getHo_zip()%> 
    		              <%if(!client.getHo_addr().equals("")){%>
    		              )&nbsp; 
    		              <%}%>
    		              <%=client.getHo_addr()%>
    		          </td>
    		    </tr>				
    		    <tr>
    		          <td class='title'>업태</td>
    		          <td>&nbsp;<%=client.getBus_cdt()%></td>
    		          <td width="10%" class='title'>종목</td>
    		          <td>&nbsp;<%=client.getBus_itm()%></td>
    		    </tr>
    		    <tr>
    		          <td rowspan="2" class='title'>대<br>
    					표<br>
    					자</td>
    		          <td class='title'>생년월일</td>
    		          <td>&nbsp;
    			        <%=client.getRepre_ssn1()%>-<%if(client.getRepre_ssn2().length() > 1){%><%=client.getRepre_ssn2().substring(0,1)%><%}%>******    			        
    	              </td>
    		          <td class='title'>주소</td>
    		          <td>&nbsp;<%if(!client.getRepre_addr().equals("")){%>
    		              ( 
    		              <%}%>
    		              <%=client.getRepre_zip()%> 
    		              <%if(!client.getRepre_addr().equals("")){%>
    		              )&nbsp; 
    		              <%}%>
    		              <%=client.getRepre_addr()%></td>				  
    		    </tr>
    		    <tr>
    		          <td class='title'>휴대폰번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
    		          <td class='title'>자택번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
    		    </tr>
    		    <tr>
    		          <td colspan="2" class='title'>사무실번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
    		          <td class='title'>팩스번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
    		    </tr>
    		    <tr>
    		          <td colspan="2" class='title'>Homepage</td>
    		          <td colspan="3">&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
    		    </tr>
    			<%}else{%>
    		    <tr>
    		          <td colspan="2" class='title'>성명</td>
    		          <td width="300" align='left'>&nbsp;<%=client.getFirm_nm()%></td>
    		          <td width="10%" class='title'>생년월일</td>
    		          <td width="300">&nbsp;<%=client.getSsn1()%>-*******</td>
                </tr>
    		    <tr>
    		          <td colspan="2" class='title'>자택주소</td>
    		          <td colspan='3'>&nbsp;
    		         	  <%if(!client.getHo_addr().equals("")){%>
    		              ( 
    		              <%}%>
    		              <%=client.getHo_zip()%> 
    		              <%if(!client.getHo_addr().equals("")){%>
    		              )&nbsp; 
    		              <%}%>
    		              <%=client.getHo_addr()%>
    					</td>
    		    </tr>
    		    <tr>
    		          <td colspan="2" class='title'>휴대폰</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
    		          <td class='title'>자택전화번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
    		    </tr>
    		    <tr>
    		          <td colspan="2" class='title'>Homepage</td>
    		          <td colspan="3">&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
    		    </tr>
    		    <tr>
    		          <td width="3%" rowspan="6" class='title'>소<br>
    		            득<br>정<br>
    		            보</td>
    		          <td width="10%" class='title'>직업</td>
    		          <td>&nbsp;<%=client.getJob()%></td>
    		          <td class='title'>소득구분</td>
    		          <td>&nbsp; 
    		            <%if(client.getPay_st().equals("1")) 		out.println("급여소득");
    	              	else if(client.getPay_st().equals("2"))    out.println("사업소득");
    	               	else if(client.getPay_st().equals("3"))	out.println("기타사업소득");%>
    	              </td>
    		    </tr>
    		    <tr>
    		          <td class='title'>직장명</td>
    		          <td colspan="3">&nbsp;<%=client.getCom_nm()%></td>
    		    </tr>
    		    <tr>
    		          <td class='title'>부서명</td>
    		          <td>&nbsp;<%=client.getDept()%></td>
    		          <td class='title'>직위</td>
    		          <td>&nbsp;<%=client.getTitle()%></td>
    		    </tr>
    		    <tr>
    		          <td class='title'>전화번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
    		          <td class='title'>FAX</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
    		    </tr>
    		    <tr>
    		          <td class='title'>직장주소</td>
    		          <td colspan="3">
    		            &nbsp;<%if(!client.getComm_addr().equals("")){%>
    		              ( 
    		              <%}%>
    		              <%=client.getComm_zip()%> 
    		              <%if(!client.getComm_addr().equals("")){%>
    		              )&nbsp; 
    		              <%}%>
    		              <%=client.getComm_addr()%>
    		           </td>   
    		    </tr>
    		    <tr>
    		          <td class='title'>근속연수</td>
    		          <td>&nbsp;<%=client.getWk_year()%>년</td>
    		          <td class='title'>연소득</td>
    		          <td>&nbsp;<%=client.getPay_type()%>만원</td>
    		    </tr>				  
    			
    			<%}%>
                <tr>
                      <td width="15%" colspan="2" rowspan='2' class='title'>세금계산서<br>
                        수신담당자</td>
                      <td colspan='3'>&nbsp;성명:<%=client.getCon_agnt_nm()%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사무실:<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이동전화:<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAX:<%=AddUtil.phoneFormat(client.getCon_agnt_fax())%>
            		  </td>
                </tr>
                <tr>
                      <td colspan='3'>&nbsp;EMAIL:<%=client.getCon_agnt_email()%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;근무부서:<%=client.getCon_agnt_dept()%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;직위:<%=client.getCon_agnt_title()%>
                      </td>
                </tr>
                <tr>
                      <td width="15%" colspan="2" rowspan='2' class='title'>세금계산서<br>
                        추가담당자</td>
                      <td colspan='3'>&nbsp;성명:<%=client.getCon_agnt_nm2()%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사무실:<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel2())%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이동전화:<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel2())%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAX:<%=AddUtil.phoneFormat(client.getCon_agnt_fax2())%>
            		  </td>
                </tr>
                <tr>
                      <td colspan='3'>&nbsp;EMAIL:<%=client.getCon_agnt_email2()%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;근무부서:<%=client.getCon_agnt_dept2()%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;직위:<%=client.getCon_agnt_title2()%>
                      </td>
                </tr>                      
                <tr>
                      <td colspan="2" class='title'>계산서발행구분</td>
                      <td width="35%">
                         &nbsp;<%if(client.getPrint_st().equals("1")) 		out.println("계약건별");
                          	else if(client.getPrint_st().equals("2"))   out.println("거래처통합");
                          	else if(client.getPrint_st().equals("3")) 	out.println("지점통합");
                         	else if(client.getPrint_st().equals("4"))	out.println("현장통합");%>
                       </td>
                      <td width="10%" class='title'>메일거부사유</td>
                      <td width="35%">&nbsp;<%=client.getEtax_not_cau()%></td>
                </tr>
                <tr>
                      <td colspan="2" class='title'>거래명세서메일</td>
                      <td>&nbsp;<%  if(client.getItem_mail_yn().equals("N")) 		out.println("거부");
                          	else   										out.println("승락");
                        %></td>
                      <td width="10%" class='title'>세금계산서메일</td>
                      <td width="35%">
            		    &nbsp;<%  if(client.getTax_mail_yn().equals("N")) 		out.println("거부");
                          	else   										out.println("승락");
                        %></td>
                </tr>					
                <tr>
                      <td colspan="2" class='title'>네오엠코드</td>
                      <td>&nbsp;<%=client.getVen_code()%></td>
                      <td width="10%" class='title'>연체문자수신여부</td>
                      <td width="35%">
            		    &nbsp;<%  if(client.getDly_sms().equals("N")) 		out.println("거부");
                          	else   										out.println("승락");
                        %></td>
                </tr>		
                <tr>
                      <td colspan="2" class='title'> 특이사항 </td>
                      <td colspan='3' align=center>
                        <table width=99% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td><%=Util.htmlBR(client.getEtc())%></td>
                            </tr>
                            <tr>
                                <td style='height:3'></td>
                            </tr>
                        </table>
                      </td>                    
                </tr>		  
            </table>
        </td>
	</tr>    
  <%if(!site.getR_site().equals("")){%>
    <tr> 
        <td class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan='2' class='title'> 구분 </td>
                    <td colspan='3'>&nbsp; 
                      <%if(site.getSite_st().equals("1")) 		out.println("지점");
                      	else if(site.getSite_st().equals("2"))  out.println("현장");%>
                    </td>
                </tr>
				<%if(site.getSite_st().equals("1")){//지점%>
    		    <tr>
    		          <td width='3%' rowspan="4" class='title'>사<br>
    					업<br>
    					자<br>
    					등<br>
    					록<br>
    					증</td>
    		          <td width="10%" class='title'>상호</td>
    		          <td width="37%" align='left'>&nbsp;<%=site.getR_site()%></td>
    		          <td width="10%" class='title'>대표자</td>
    		          <td width="40%">&nbsp;<%=site.getSite_jang()%></td>
    		    </tr>
    		    <tr>
    		          <td class='title'>사업자번호</td>
    		          <td colspan='3'>&nbsp;<%=site.getEnp_no()%></td>
    		    </tr>
    		    <tr>
    		          <td class='title'>주소</td>
    		          <td colspan='3'>
    		            &nbsp;<%if(!site.getAddr().equals("")){%>
    		              ( 
    		              <%=site.getZip()%>					  
    		              )&nbsp; 
    		              <%}%>
    		              <%=site.getAddr()%>
    		          </td>
    		    </tr>
    		    <tr>
    		          <td class='title'>업태</td>
    		          <td>&nbsp;<%=site.getBus_cdt()%></td>
    		          <td class='title'>종목</td>
    		          <td>&nbsp;<%=site.getBus_itm()%></td>
    	        </tr>
    	        <tr>
    		          <td colspan="2" class='title'>사무실번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(site.getTel())%></td>
    		          <td class='title'>팩스번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(site.getFax())%></td>
    		    </tr>
                <tr>
                      <td width="15%" colspan="2" rowspan='2' class='title'>세금계산서<br>
                        담당자</td>
                      <td colspan='3'>&nbsp;성명:<%=site.getAgnt_nm()%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사무실:<%=AddUtil.phoneFormat(site.getAgnt_tel())%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이동전화:<%=AddUtil.phoneFormat(site.getAgnt_m_tel())%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAX:<%=AddUtil.phoneFormat(site.getAgnt_fax())%>
            		  </td>
                </tr>
                <tr>
                      <td colspan='3'>&nbsp;EMAIL:<%=site.getAgnt_email()%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;근무부서:<%=site.getAgnt_dept()%>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;직위:<%=site.getAgnt_title()%>
                      </td>
                </tr>
				<%}else{//현장-실사용지%>
    		    <tr>
    		          <td width='3%' rowspan="2" class='title'>현<br>
    					장</td>
    		          <td width="10%" class='title'>현장명</td>
    		          <td width="37%" align='left'>&nbsp;<%=site.getR_site()%></td>
    		          <td width="10%" class='title'>담당자</td>
    		          <td width="40%">&nbsp;<%=site.getSite_jang()%></td>
    		    </tr>
    		    <tr>
    		          <td class='title'>주소</td>
    		          <td colspan='3'>
    		            &nbsp;<%if(!site.getAddr().equals("")){%>
    		              ( 
    		              <%=site.getZip()%>					  
    		              )&nbsp; 
    		              <%}%>
    		              <%=site.getAddr()%>
    		          </td>
    		    </tr>
    	        <tr>
    		          <td colspan="2" class='title'>전화번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(site.getTel())%></td>
    		          <td class='title'>팩스번호</td>
    		          <td>&nbsp;<%=AddUtil.phoneFormat(site.getFax())%></td>
    		    </tr>				
				<%}%>
            </table>
        </td>
	</tr> 
	<%}%> 
	<tr>
        <td class=h></td>
    </tr>	  		
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>우편물주소</td>
                    <td width='37%' align='left'>&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>
                    </td>
                    <td width='12%' class='title'>우편물수취인</td>
                    <td width="38%" class='left'>&nbsp;<%=base.getTax_agnt()%></td>
                </tr>	
                <tr>
                    <td width='13%' class='title'>FMS ID</td>
                    <td width='37%' align='left'>&nbsp;<%=m_bean.getMember_id()%></td>
                    <td width='10%' class='title'>FMS PW</td>
                    <td width="40%" class='left'>&nbsp;<%=m_bean.getPwd()%></td>
                </tr>		  
            </table>
        </td>
	</tr>      
	<tr>
        <td class=h></td>
    </tr>	  		
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>	           	  
                <%	CarMgrBean mgr1 = new CarMgrBean();
                	CarMgrBean mgr5 = new CarMgrBean();
                	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("차량이용자")){
        					mgr1 = mgr;
        				}
        				if(mgr.getMgr_st().equals("추가운전자")){
            				mgr5 = mgr;
            			}
					}                       
                %>      
                <%if(!client.getClient_st().equals("1")){ %>    
                <tr>
                    <td class='title'>계약자 운전면허번호</td>
		            <td colspan='3'>&nbsp;<%=base.getLic_no()%></td>
		            <td>&nbsp;(개인,개인사업자)&nbsp;※ 계약자(<%=client.getClient_nm()%>)의 운전면허번호를 기재</td>
                </tr>
                <tr>
                    <td class='title' width='13%'>차량이용자 운전면허번호</td>
		            <td width='15%'>&nbsp;<%=base.getMgr_lic_no()%></td>
		            <td width='20%'>&nbsp;이름 : <%=base.getMgr_lic_emp()%></td>
		            <td width='12%'>&nbsp;관계 : <%=base.getMgr_lic_rel()%></td>
		            <td width='40%'>&nbsp;(개인,개인사업자)<%if(client.getClient_st().equals("3")||client.getClient_st().equals("4")||client.getClient_st().equals("5")){%>&nbsp;※ 계약자가 운전면허가 없는 경우 차량이용자의 운전면허를 입력<%}%></td>
                </tr>  
                <%} %>       
                <%//if(mgr5.getMgr_st().equals("추가운전자")){ %>
                <tr>
                    <td class='title'>추가운전자 운전면허번호</td>
		            <td>&nbsp;<%=mgr5.getLic_no()%></td>
		            <td>&nbsp;이름 : <%=mgr5.getMgr_nm()%></td>
		            <td>&nbsp;관계 : <%=mgr5.getEtc()%></td>
		            <td>&nbsp;</td>
                </tr>    
                <%//} %>                         	                      
                <!-- 운전자격검증결과 -->
                 
                <tr>
                    <td class='title' rowspan='2' width='13%'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <%=base.getTest_lic_emp()%></td>
		            <td width='12%'>&nbsp;관계 : <%=base.getTest_lic_rel()%></td>
		            <td width='40%'>&nbsp;검증결과 : <%=c_db.getNameByIdCode("0050", "", base.getTest_lic_result())%></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;※ 개인고객은 계약자 본인을, 개인사업자/법인사업자 고객은 계약서상 차량이용자의 운전자격을 검증</td>
                </tr>   
                                  
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>관계자 &nbsp;<%if(base.getBus_id().equals(user_id)){%><a href="javascript:update('mgr')" title="수정하기"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%></span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td width="3%" rowspan="<%=mgr_size+1%>" class=title>관<br>계<br>자</td>
                    <td class=title width="10%">구분</td>
                    <td class=title width="10%">근무처</td>			
                    <td class=title width="10%">부서</td>
                    <td class=title width="10%">성명</td>
                    <td class=title width="10%">직위</td>
                    <td class=title width="13%">전화번호</td>
                    <td class=title width="13%">휴대폰</td>
                    <td width="21%" class=title>E-MAIL</td>
                    <!--<td width="5%" class=title>수정</td>-->
                  </tr>
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
                  <tr> 
                    <td colspan="3" class=title>차량이용자 실거주지 주소</td>
                    <td colspan="6">&nbsp;<%=mgr_zip%>&nbsp;<%=mgr_addr%></td>
                  </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(!client.getClient_st().equals("2")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>요약 재무제표&nbsp;<a href="javascript:view_fin()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a>&nbsp;</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr>
		       
		            <td colspan="2" rowspan="2" class=title>구분<br>yyyy-mm-dd</td>
		            <td width="42%" class=title>당기(
		                <input type='text' name='c_kisu' size='2' value='<%=c_fin.getC_kisu()%>' maxlength='20' class='t_color' >
		      기)</td>
		            <td width="43%" class=title>전기(
		                <input type='text' name='f_kisu' size='2' value='<%=c_fin.getF_kisu()%>' maxlength='20' class='t_color' >
		      기)</td>
		          </tr>
		          <tr>
		            <td class=title>&nbsp;&nbsp;
					(
		            	<input type='text' name='c_ba_year_s' size='11' class='t_color' maxlength='10' value='<%=c_fin.getC_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='c_ba_year' size='10' class='t_color' maxlength='10' value='<%=c_fin.getC_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		     
		            <td class='title'>&nbsp;&nbsp;
					(
		            	<input type='text' name='f_ba_year_s' size='11' class='t_color' maxlength='10' value='<%=c_fin.getF_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='f_ba_year' size='10' class='t_color' maxlength='10' value='<%=c_fin.getF_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		              
		          </tr>
		          <tr>
		            <td colspan="2" class=title>자산총계</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_asset_tot' size='10' maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getC_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_asset_tot' size='10' maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getF_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원 </td>
		          </tr>
		          <tr>
		            <td width="3%" rowspan="2" class=title>자<br>
		      본</td>
		            <td width="9%" class=title>자본금</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap' size='10'  maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getC_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap' size='10'  maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getF_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원 </td>
		          </tr>
		          <tr>
		            <td class=title>자본총계</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap_tot' size='10'  maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getC_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원</td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap_tot' size='10'  maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getF_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원</td>
		          </tr>
		          <tr>
		            <td colspan="2" class=title>매출</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_sale' size='10'  maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getC_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_sale' size='10'  maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getF_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원 </td>
		          </tr>
		          <tr>
		            <td colspan="2" class=title>당기순이익</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_profit' size='10'  maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getC_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_profit' size='10'  maxlength='13' class=whitenum value='<%=AddUtil.parseDecimal(c_fin.getF_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      백만원 </td>
		          </tr>
		    </table>	     
        </td>
    </tr>	
	<%}%>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용등급&nbsp;</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr>
                    <td width="13%" class=title>구분</td>
                    <td width="16%" class=title>상호/성명</td>
                    <td width="12%" class=title>판정기관</td>
                    <td width="13%" class='title'>신용평점</td>
                    <td width="16%" class='title'>신용등급</td>
                    <td width="16%" class='title'>평가(산출)일자</td>					
                    <td width="16%" class='title'>조회일자</td>
                  </tr>
        		  <%int eval_cnt = -1;
        		  	if(client.getClient_st().equals("2")){
        		  		eval3 = a_db.getContEval(rent_mng_id, rent_l_cd, "3", "");
        				if(eval3.getEval_nm().equals("")) eval3.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                  <tr>
                    <td class=title>계약자<input type='hidden' name='eval_gu' value='3'><input type='hidden' name='e_seq' value='<%=eval3.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval3.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)" disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval3.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval3.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval3.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval3.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval3.getEval_off().equals("2")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval3.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                          		switch(eval3.getEval_gr()){
    	                      		case "1": scope = "(955~1000)"; break;
    	        					case "2": scope = "(907~954)"; break;
    	        					case "3": scope = "(837~906)"; break;
    	        					case "4": scope = "(770~836)"; break;
    	        					case "5": scope = "(693~769)"; break;
    	        					case "6": scope = "(620~692)"; break;
    	        					case "7": scope = "(535~619)"; break;
    	        					case "8": scope = "(475~534)"; break;
    	        					case "9": scope = "(390~474)"; break;
    	        					case "10": scope = "(1~389)"; break;
                          		}	
        					%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval3.getEval_off().equals("1")||eval3.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class=whitetext value='<%=AddUtil.ChangeDate2(eval3.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                  </tr>
        		  <%
        		  		eval5 = a_db.getContEval(rent_mng_id, rent_l_cd, "5", "");
        				if(eval5.getEval_nm().equals("")) eval5.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                  <tr>
                    <td class=title>계약자<input type='hidden' name='eval_gu' value='5'><input type='hidden' name='e_seq' value='<%=eval5.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval5.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                      <select name='eval_off' disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval5.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval5.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval5.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval5.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval5.getEval_off().equals("2")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval5.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                          		switch(eval5.getEval_gr()){
    	                      		case "1": scope = "(955~1000)"; break;
    	        					case "2": scope = "(907~954)"; break;
    	        					case "3": scope = "(837~906)"; break;
    	        					case "4": scope = "(770~836)"; break;
    	        					case "5": scope = "(693~769)"; break;
    	        					case "6": scope = "(620~692)"; break;
    	        					case "7": scope = "(535~619)"; break;
    	        					case "8": scope = "(475~534)"; break;
    	        					case "9": scope = "(390~474)"; break;
    	        					case "10": scope = "(1~389)"; break;
                          		}	
        					%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval5.getEval_off().equals("1")||eval5.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class=whitetext value='<%=AddUtil.ChangeDate2(eval5.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                  </tr>                  
        		  <%}else{
        		  		eval1 = a_db.getContEval(rent_mng_id, rent_l_cd, "1", "");
        				if(eval1.getEval_nm().equals("")) eval1.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                  <tr id=tr_eval_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>법인<input type='hidden' name='eval_gu' value='1'><input type='hidden' name='e_seq' value='<%=eval1.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval1.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)" disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval1.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval1.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval1.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval1.getEval_off().equals("2")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval1.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                          		switch(eval1.getEval_gr()){
    	                      		case "1": scope = "(955~1000)"; break;
    	        					case "2": scope = "(907~954)"; break;
    	        					case "3": scope = "(837~906)"; break;
    	        					case "4": scope = "(770~836)"; break;
    	        					case "5": scope = "(693~769)"; break;
    	        					case "6": scope = "(620~692)"; break;
    	        					case "7": scope = "(535~619)"; break;
    	        					case "8": scope = "(475~534)"; break;
    	        					case "9": scope = "(390~474)"; break;
    	        					case "10": scope = "(1~389)"; break;
                          		}	
        					%>
        					<option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval1.getEval_off().equals("1")||eval1.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd3.length; i++){
        						CodeBean cd = gr_cd3[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center"><input type='text' name='eval_b_dt' size='11' class=whitetext value='<%=AddUtil.ChangeDate2(eval1.getEval_b_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class=whitetext value='<%=AddUtil.ChangeDate2(eval1.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                  </tr>
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){
        		  			eval2 = a_db.getContEval(rent_mng_id, rent_l_cd, "2", "");
        					if(eval2.getEval_nm().equals("")) eval2.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                  <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='2'><input type='hidden' name='e_seq' value='<%=eval2.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval2.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)" disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval2.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval2.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval2.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval2.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval2.getEval_off().equals("2")||eval2.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval2.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                          		switch(eval2.getEval_gr()){
    	                      		case "1": scope = "(955~1000)"; break;
    	        					case "2": scope = "(907~954)"; break;
    	        					case "3": scope = "(837~906)"; break;
    	        					case "4": scope = "(770~836)"; break;
    	        					case "5": scope = "(693~769)"; break;
    	        					case "6": scope = "(620~692)"; break;
    	        					case "7": scope = "(535~619)"; break;
    	        					case "8": scope = "(475~534)"; break;
    	        					case "9": scope = "(390~474)"; break;
    	        					case "10": scope = "(1~389)"; break;
                          		}	
        					%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval2.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class=whitetext value='<%=AddUtil.ChangeDate2(eval2.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                  </tr>
        		  <%	
        		  			eval6 = a_db.getContEval(rent_mng_id, rent_l_cd, "6", "");
        					if(eval6.getEval_nm().equals("")) eval6.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                  <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='6'><input type='hidden' name='e_seq' value='<%=eval6.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval6.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval6.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval6.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval6.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval6.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval6.getEval_off().equals("2")||eval6.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval6.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                          		switch(eval6.getEval_gr()){
    	                      		case "1": scope = "(955~1000)"; break;
    	        					case "2": scope = "(907~954)"; break;
    	        					case "3": scope = "(837~906)"; break;
    	        					case "4": scope = "(770~836)"; break;
    	        					case "5": scope = "(693~769)"; break;
    	        					case "6": scope = "(620~692)"; break;
    	        					case "7": scope = "(535~619)"; break;
    	        					case "8": scope = "(475~534)"; break;
    	        					case "9": scope = "(390~474)"; break;
    	        					case "10": scope = "(1~389)"; break;
                          		}	
        					%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval6.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class=whitetext value='<%=AddUtil.ChangeDate2(eval6.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                  </tr>                  
        		  <%	}%>
        		  
        		  <%	
        		  		if(cont_etc.getClient_share_st().equals("1")){
        		  			eval7 = a_db.getContEval(rent_mng_id, rent_l_cd, "7", "");
        					if(eval7.getEval_nm().equals("")) eval7.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                  <tr>
                    <td class=title>공동임차인<input type='hidden' name='eval_gu' value='7'><input type='hidden' name='e_seq' value='<%=eval7.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval7.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval7.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval7.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval7.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval7.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval7.getEval_off().equals("2")||eval7.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval7.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                          		switch(eval7.getEval_gr()){
    	                      		case "1": scope = "(955~1000)"; break;
    	        					case "2": scope = "(907~954)"; break;
    	        					case "3": scope = "(837~906)"; break;
    	        					case "4": scope = "(770~836)"; break;
    	        					case "5": scope = "(693~769)"; break;
    	        					case "6": scope = "(620~692)"; break;
    	        					case "7": scope = "(535~619)"; break;
    	        					case "8": scope = "(475~534)"; break;
    	        					case "9": scope = "(390~474)"; break;
    	        					case "10": scope = "(1~389)"; break;
                          		}	
        					%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval7.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class=whitetext value='<%=AddUtil.ChangeDate2(eval7.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                  </tr>
        		  <%	
        		  			eval8 = a_db.getContEval(rent_mng_id, rent_l_cd, "8", "");
        					if(eval8.getEval_nm().equals("")) eval8.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                  <tr>
                    <td class=title>공동임차인<input type='hidden' name='eval_gu' value='8'><input type='hidden' name='e_seq' value='<%=eval8.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval8.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval8.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval8.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval8.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval8.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval8.getEval_off().equals("2")||eval8.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval8.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                          		switch(eval8.getEval_gr()){
    	                      		case "1": scope = "(955~1000)"; break;
    	        					case "2": scope = "(907~954)"; break;
    	        					case "3": scope = "(837~906)"; break;
    	        					case "4": scope = "(770~836)"; break;
    	        					case "5": scope = "(693~769)"; break;
    	        					case "6": scope = "(620~692)"; break;
    	        					case "7": scope = "(535~619)"; break;
    	        					case "8": scope = "(475~534)"; break;
    	        					case "9": scope = "(390~474)"; break;
    	        					case "10": scope = "(1~389)"; break;
                          		}	
        					%>
        					<option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval8.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class=whitetext value='<%=AddUtil.ChangeDate2(eval8.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                  </tr>                  
        		  <%	}%>
        		          		  
        		  <%}%>
        		  <%if(gur_size > 0){
        		  		for(int i = 0 ; i < gur_size ; i++){
        				Hashtable gur = (Hashtable)gurs.elementAt(i);
        				eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));
        				if(eval4.getEval_nm().equals("")) eval4.setEval_nm(String.valueOf(gur.get("GUR_NM")));
        				eval_cnt++;%>
                  <tr>
                    <td class=title>연대보증인<%=i+1%><input type='hidden' name='eval_gu' value='4'><input type='hidden' name='e_seq' value='<%=eval4.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval4.getEval_nm()%>'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)" disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval4.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval4.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval4.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval4.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval4.getEval_off().equals("2")){
        				    for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("3")){
        					  for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];
        						String scope = "";
                          		switch(eval4.getEval_gr()){
    	                      		case "1": scope = "(955~1000)"; break;
    	        					case "2": scope = "(907~954)"; break;
    	        					case "3": scope = "(837~906)"; break;
    	        					case "4": scope = "(770~836)"; break;
    	        					case "5": scope = "(693~769)"; break;
    	        					case "6": scope = "(620~692)"; break;
    	        					case "7": scope = "(535~619)"; break;
    	        					case "8": scope = "(475~534)"; break;
    	        					case "9": scope = "(390~474)"; break;
    	        					case "10": scope = "(1~389)"; break;
                          		}	
        					%>
        					<option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("1")||eval4.getEval_off().equals("")){
        				    for(int j =0; j<gr_cd2.length; j++){
        						CodeBean cd = gr_cd2[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class=whitetext value='<%=AddUtil.ChangeDate2(eval4.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                  </tr>
        		  <%	}
        		  	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자산현황&nbsp;</td>
	</tr>
	<%int zip_cnt =4;%>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr>
                    <td width="13%" rowspan="2" class=title>구분</td>
                    <td colspan="2" class=title>물건지1</td>
                    <td colspan="2" class=title>물건지2</td>
                  </tr>
                  <tr>
                    <td width="15%" class=title>형태</td>
                    <td width="28%" class='title'>주소</td>
                    <td width="15%" class=title>형태</td>
                    <td width="29%" class='title'>주소</td>
                  </tr>	  
        		  <%if(client.getClient_st().equals("2")){%>
                  <tr>
                    <td class=title>계약자</td>
        			<td align="center">
        			<% zip_cnt++;%>
                      <select name='ass1_type' disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
						function openDaumPostcode() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip').value = data.zonecode;
									document.getElementById('t_addr').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=eval3.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="25" value="<%=eval3.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type' disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode1() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip1').value = data.zonecode;
									document.getElementById('t_addr1').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=eval3.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr1" size="25" value="<%=eval3.getAss2_addr()%>">
					</td>
                    
                  </tr> 
                  <% }else{%>
                  <tr id=tr_dec_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>법인</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type' disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode2() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip2').value = data.zonecode;
									document.getElementById('t_addr2').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value="<%=eval1.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr2" size="25" value="<%=eval1.getAss1_addr()%>">
					</td>
                    
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type' disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode3() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip3').value = data.zonecode;
									document.getElementById('t_addr3').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip3" size="7" maxlength='7' value="<%=eval1.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr3" size="25" value="<%=eval1.getAss2_addr()%>">
					</td>
                    
                  </tr>
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){%>
                  <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%></td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type' disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode4() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip4').value = data.zonecode;
									document.getElementById('t_addr4').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip4" size="7" maxlength='7' value="<%=eval2.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode4()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr4" size="25" value="<%=eval2.getAss1_addr()%>">
					</td>
                    
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type' disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode5() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip5').value = data.zonecode;
									document.getElementById('t_addr5').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip5" size="7" maxlength='7' value="<%=eval2.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode5()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr5" size="25" value="<%=eval2.getAss2_addr()%>">
					</td>
                    
                  </tr>
        		  <% 	} %>
        		  
        		  
        		  <%	if(cont_etc.getClient_share_st().equals("1")){%>
                  <tr>
                    <td class=title>공동임차인</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type' disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode6() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip6').value = data.zonecode;
									document.getElementById('t_addr6').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip6" size="7" maxlength='7' value="<%=eval7.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode6()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr6" size="25" value="<%=eval7.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type' disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode7() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip7').value = data.zonecode;
									document.getElementById('t_addr7').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip7" size="7" maxlength='7' value="<%=eval7.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode7()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr7" size="25" value="<%=eval7.getAss2_addr()%>">
					</td>
                  </tr>
        		  <% 	} %>
        		          		  
        		  <% } %>
        		  <%if(gur_size > 0){
        		  		for(int i = 0 ; i < gur_size ; i++){
        				Hashtable gur = (Hashtable)gurs.elementAt(i);
        				eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));%>		  	  
                  <tr>
                    <td class=title>연대보증인<%=i+1%></td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type' disabled>
                          <option value="">선택</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode8() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip8').value = data.zonecode;
									document.getElementById('t_addr8').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip8" size="7" maxlength='7' value="<%=eval4.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode8()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr8" size="25" value="<%=eval4.getAss1_addr()%>">
					</td>
                    
        			<% zip_cnt++;%>
        			<td align="center">
                      <select name='ass2_type' disabled>
                          <option value="">선택</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode9() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip9').value = data.zonecode;
									document.getElementById('t_addr9').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip9" size="7" maxlength='7' value="<%=eval4.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode9()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr9" size="25" value="<%=eval4.getAss2_addr()%>">
					</td>
                    
                  </tr>
        		  <%	}
        		  	}%>		
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타참고사항&nbsp;</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>기타</td>
                    <td>&nbsp;<%=HtmlUtil.htmlBR(cont_etc.getDec_etc())%></td>
                </tr>
    		</table>	  
	    </td>
	</tr>	
	<tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객신용등급판정&nbsp;</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr>
                    <td width="13%" rowspan="2" class=title>판정신용등급</td>
                    <td colspan="2" class=title>심사</td>
                    <td colspan="2" class=title>결재</td>
                  </tr>
                  <tr>
                    <td width="20%" class=title>담당자</td>
                    <td width="20%" class='title'>판정일자</td>
                    <td width="20%" class=title>결재자</td>
                    <td width="27%" class='title'>결재일자</td>
                  </tr>
                  <tr>
                    <td align="center">
        			  <%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
        			  <% if(cont_etc.getDec_gr().equals("3")) out.print("신설법인"); 	%>
                      <% if(cont_etc.getDec_gr().equals("0")) out.print("일반고객"); 	%>
                      <% if(cont_etc.getDec_gr().equals("1")) out.print("우량기업"); 	%>
                      <% if(cont_etc.getDec_gr().equals("2")) out.print("초우량기업");  %>
        			  <a href="javascript:view_dec()" title="이력"><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a>
                    </td>                       
                    <td align="center">
        			  <%=c_db.getNameById(cont_etc.getDec_f_id(),"USER")%>
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(cont_etc.getDec_f_dt())%></td>
                    <td align="center">
        			  <%=c_db.getNameById(cont_etc.getDec_l_id(),"USER")%>                           
                	</td>
                    <td align="center"><%=AddUtil.ChangeDate2(cont_etc.getDec_l_dt())%></td>
                  </tr>
            </table>
        </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
