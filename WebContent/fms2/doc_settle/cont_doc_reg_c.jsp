<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String fee_start_dt = "";
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	if(rent_l_cd.equals("")){
		Hashtable cont = a_db.getContViewUseYCarCase(c_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 		= String.valueOf(cont.get("RENT_L_CD"));
	}
	
	if(rent_l_cd.equals("") && !l_cd.equals("")){
		rent_mng_id = m_id;
		rent_l_cd 	= l_cd;
	}
	
	if(rent_l_cd.equals("") || rent_l_cd.equals("null")) return;
	
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "16");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(c_id.equals("")){
		c_id = base.getCar_mng_id();
	}
	
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
	int mgr_size = car_mgrs.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//길이 체크
	function CheckLen(f, max_len){
		if(get_length(f)>max_len){alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');}
	}
	
//오늘날짜 구하기
var dt = new Date();		
var month = dt.getMonth()+1;	if(month<10)	month = "0"+month;
var day = dt.getDate();
var year = dt.getFullYear();

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	
	//고객 보기
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=1000, height=700, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 보기
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=1000, height=700, scrollbars=yes");
	}		
	
	//등록
	function save(){
		var fm = document.form1;
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "u_chk"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("변경사항을 선택하세요.");
			return;
		}	
		
		//현재 1건 : 나중에 변경항목이 추가되면 배열 처리할것
		if(fm.u_chk.checked == true){
				if(fm.value01.value == ''){ 					alert('차량이용자 성명을 입력하십시오.');					return;				}
				if(fm.value02.value == ''){ 					alert('차량이용자 관계를 입력하십시오.');					return;				}
				if(fm.value04.value == ''){ 					alert('차량이용자 휴대폰을 입력하십시오.');				return;				}
				if(fm.value05.value == ''){ 					alert('차량이용자 운전면허번호를 입력하십시오.');		return;				}
				if(fm.value05.value.length < 12){
					alert('차량이용자 운전면허번호를 정확히 입력하십시오.');
					return;
				}
		}
		
		if(fm.cng_dt.value == '')			{ alert('변경일자를 입력하십시오.'); 						fm.cng_dt.focus(); 	return; }
		if(fm.cng_etc.value == '')		{ alert('사유 및 특이사항을 입력하십시오.'); 				fm.cng_etc.focus();	return; }
		
		
			
		if(confirm('등록하시겠습니까?')){	
		
			fm.action='cont_doc_reg_c_a.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}							
		
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
<form action='cont_doc_reg_c_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 			value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 			value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"	 	value="<%=ext_fee.getRent_st()%>">
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="c_id"	 		value="<%=c_id%>">  
  <input type='hidden' name="from_page" 	value="/fms2/doc_settle/cont_doc_reg_c.jsp">             
  <input type='hidden' name='st' value=''>        
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이전트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
                </tr>
                <tr>
                    <td class=title>상호</td>
                    <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a></td>
                    <td class=title>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>지점/현장</td>
                    <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=site.getR_site()%></a></td>
                </tr>
                <tr>
                    <td class=title>차량번호</td>
                    <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title width=10%>차명</td>
                    <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(차종코드:<%=cm_bean.getJg_code()%>)</font>
        			</td>
                </tr>		  
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr>
        <td class=line2></td>
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
                <%	CarMgrBean mgr1 = new CarMgrBean();
                		for(int i = 0 ; i < mgr_size ; i++){
        							CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        							if(mgr.getMgr_st().equals("차량이용자")){
        								mgr1 = mgr;
        							}
										}                       
                %>                	  
                <tr>
                    <td width='13%' class='title'>계약자 운전면허번호</td>
                    <td colspan=3 align='left'>&nbsp;<%=base.getLic_no()%></td>
                </tr>		       
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <%if(base.getCar_st().equals("4")){//월렌트%>
                  <tr> 
                    <td width="3%" rowspan="3" class=title>관<br>계<br>자</td>
                    <td class=title width="10%">구분</td>
                    <td class=title width="10%">성명</td>			
                    <td class=title width="12%">생년월일</td>
                    <td class=title width="15%">주소</td>
                    <td class=title width="10%">전화번호</td>
                    <td class=title width="10%">휴대폰</td>
                    <td width="10%" class=title>운전면허번호</td>
                    <td width="20%" class=title>기타(직위)</td>
                  </tr>
        		  <%String mgr_zip = "";
        			String mgr_addr = "";
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        						if(mgr.getMgr_st().equals("차량이용자")){
        		%>
                  <tr> 
                    <td align='center'><%=mgr.getMgr_st()%></td>
                    <td align='center'><%=mgr.getMgr_nm()%></td>
                    <td align='center'><%=AddUtil.ChangeEnpH(mgr.getSsn())%></td>
                    <td align='center'><%=mgr.getMgr_addr()%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_tel())%></td>
                    <td align='center'><%=AddUtil.phoneFormat(mgr.getMgr_m_tel())%></td>
                    <td align='center'><%=mgr.getLic_no()%></td>
                    <td align='center'><%=mgr.getEtc()%></td>
                  </tr>
        		  <%		}
        		  		} %>
                  <%}else{%>
                  <tr> 
                    <td width="3%" rowspan="3" class=title>관<br>계<br>자</td>
                    <td class=title width="10%">구분</td>
                    <td class=title width="10%">근무처</td>			
                    <td class=title width="10%">부서</td>
                    <td class=title width="10%">성명</td>
                    <td class=title width="10%">직위</td>
                    <td class=title width="13%">전화번호</td>
                    <td class=title width="13%">휴대폰</td>
                    <td width="21%" class=title>E-MAIL</td>
                  </tr>
        		  <%String mgr_zip = "";
        			String mgr_addr = "";
					String lic_no = "";
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("차량이용자")){
        					mgr_zip = mgr.getMgr_zip();
        					mgr_addr = mgr.getMgr_addr();
							lic_no	= mgr.getLic_no();
        				%>
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
        		  <%		}
        		  		} %>
                  <tr> 
                    <td colspan="2" class=title>차량이용자 실거주지 주소</td>
                    <td colspan="4">&nbsp;<%=mgr_zip%>&nbsp;<%=mgr_addr%></td>
					<td class=title>차량이용자 운전면허번호</td>
                    <td>&nbsp;<%=lic_no%></td>
                  </tr>
                  <%}%>                  
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경사항</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=3%>선택</td>
                    <td width="10%" class=title>구분</td>
                    <td class=title width=87%>변경내용</td>
                </tr>
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="1" checked></td> 
                    <td class=title>차량이용자</td>
                    <td>&nbsp;
					  성명 : <input type='text' name='value01' value=''  size='8' class='default' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'>&nbsp;
					  관계(직위) : <input type='text' name='value02' value=''  size='12' class='default' onBlur='javascript:CheckLen(this.value,20)' >&nbsp;
					  전화번호 : <input type='text' name='value03' value=''  size='14' class='text' onBlur='javascript:CheckLen(this.value,20)' >&nbsp;
					  휴대폰 : <input type='text' name='value04' value=''  size='15' class='default' onBlur='javascript:CheckLen(this.value,20)' >&nbsp;
					  운전면호번호 : <input type='text' name='value05' value=''  size='18' class='default' onBlur='javascript:CheckLen(this.value,20)' >&nbsp;
					  E-MAIL : <input type='text' name='value06' value=''  size='25' class='text' onBlur='javascript:CheckLen(this.value,80)'  style='IME-MODE: inactive'>
					  </td>
                </tr>                
            </table>
        </td>
    </tr>
	<tr>
	    <td>※ 변경항목 추가는 IT마케팅팀에 요청하세요.</td>
	</tr>	    
	<tr>
	    <td class=h></td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>변경일자</td>
                    <td>&nbsp;
        			  <input type='text' name='cng_dt' size='11' class='default' onBlur='javascript: this.value = ChangeDate(this.value);'>
					</td>
                </tr>
                <tr> 
                    <td class='title'>사유 및 특이사항</td>
                    <td>&nbsp;
        			  <textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
	<tr>
	    <td class=h></td>
	</tr>	

    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
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
