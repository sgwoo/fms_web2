<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.user_mng.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	

	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	String fee_rent_st = request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	//운전자격검증결과
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;	
				
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//길이 체크
	function CheckLen(f, max_len){
		if(get_length(f)>max_len){alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');}
	}
	//고객 조회
	function search_client(){window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_b_s_1.jsp","CLIENT","left=10,top=10,width=1100,height=600,scrollbars=yes,status=yes,resizable=yes");}
	//고객 보기
	function view_client(){if(document.form1.client_id.value==""){alert("선택된 고객이 없습니다.");return;}window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_b_s_1.jsp&client_id="+document.form1.client_id.value,"CLIENT","left=10,top=10,width=900,height=600,scrollbars=yes,status=yes,resizable=yes");}
	//지점/현장 조회
	function search_site(){if(document.form1.client_id.value==""){alert("고객을 먼저 선택하십시오.");return;}window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_b_s_1.jsp&client_id="+document.form1.client_id.value,"CLIENT_SITE","left=100,top=100,width=820,height=500,scrollbars=yes,status=yes,resizable=yes");}
	//지점/현장 보기
	function view_site(){if(document.form1.site_id.value==""){alert("선택된 지점이 없습니다.");return;}window.open("/fms2/client/client_site_i_p.jsp?cmd=view&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_b_s_1.jsp&client_id="+document.form1.client_id.value+"&site_id="+document.form1.site_id.value,"CLIENT_SITE","left=100,top=100,width=620,height=450");}
	//주소 조회
	function search_post(idx){if(document.form1.client_id.value==""){alert("고객을 먼저 선택하십시오.");return;}window.open("search_post.jsp?idx="+idx+"&client_id="+document.form1.client_id.value,"POST","left=100,top=100,height=500,width=800,scrollbars=yes,status=yes");}
	//관계자 조회
	function search_mgr(idx){if(document.form1.client_id.value==""){alert("고객을 먼저 선택하십시오.");return;}window.open("search_mgr.jsp?idx="+idx+"&client_id="+document.form1.client_id.value,"MGR","left=100,top=100,height=500,width=800,scrollbars=yes,status=yes");}

	//수정
	function update(idx){
		var fm = document.form1;
		
		<%if(!ck_acar_id.equals("000029")){%>
		
		if(fm.client_id.value == ''){alert('고객을 선택하십시오.');	return;}
		if(fm.t_addr[0].value == ''){alert('우편물주소를 확인하십시오.');return;}
		
			//개인,개인사업자는 운전면허번호 필수
			if(fm.client_st.value == '2' || fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){		
				if(fm.lic_no.value == '' && fm.mgr_lic_no.value == ''){
					alert('개인,개인사업자는 운전면허번호를 입력하십시오.');
					return;
				}
				if(fm.lic_no.value != '' && fm.lic_no.value.length < 12){
					alert('계약자 운전면허번호를 정확히 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_no.value.length < 12){
					alert('차량이용자 운전면허번호를 정확히 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_emp.value == ''){840806
					alert('차량이용자 운전면허번호 이름을 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_rel.value == ''){
					alert('차량이용자 운전면허번호 관계를 입력하십시오.');
					return;
				}
			}else if(fm.client_st.value == '1'||fm.client_st.value == '6'){	//법인
				if(fm.ssn.value==""){
					if(fm.lic_no.value == '' || fm.lic_no.value.length < 12){
						alert('법인번호가 없는 법인형태인 경우에는 운전면허번호를 입력하십시오.');
						return;
					}
				}
			}	
			if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_emp5.value == ''){
				alert('추가운전자 운전면허번호 이름을 입력하십시오.');
				return;
			}
			if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_rel5.value == ''){
				alert('추가운전자 운전면허번호 관계를 입력하십시오.');
				return;
			}
			if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_result5.value != '1'){
				alert('추가운전자의 운전면허검증결과를 확인해주세요. 운전자격 없는 자에게 차량을 대여할 수 없습니다.');
				return;
			}
			
		<%}%>
		
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}
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
<body>
<form action='lc_b_s_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name="user_id" value="<%=user_id%>">
  <input type='hidden' name="br_id"   value="<%=br_id%>">
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>  
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_1.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">
  <input type='hidden' name="idx"	value="">
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>미결계약</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객</span>(<%=client.getClient_id()%>)</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>상호/성명</td>
                    <td width='50%' align='left'>&nbsp;
                      <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='50' class='text' readonly>
                      <%if(client.getClient_id().equals("000228") || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id) || nm_db.getWorkAuthUser("계약결재",user_id)){//%>
        		<span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        	      <%}%>
        	      <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>					  
        	    </td>
                    <td width='10%' class='title'>대표자</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="client_nm" value='<%=client.getClient_nm()%>' size='22' class='whitetext' readonly></td>
                </tr>
                <tr>
                    <td class='title'>지점/현장</td>
                    <td height="26" class='left'>&nbsp; 
        			  <input type='text' name="site_nm" value='<%=site.getR_site()%>' size='50' class='text' readonly>
        			  <input type='hidden' name='site_id' value='<%=base.getR_site()%>'>
        			  <span class="b"><a href='javascript:search_site()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
        			</td>
                    <td width='10%' class='title'>개업년월일</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="open_year" value='<%=client.getOpen_year()%>' size='22' class='whitetext' readonly></td>					
                </tr>
                <tr>
                    <td class='title'>우편물주소</td>
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
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=base.getP_zip()%>">
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="60" value="<%=base.getP_addr()%>">
						&nbsp;&nbsp;<span class="b"><a href="javascript:search_post('0')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					</td>
                    <td class='title'>우편물수취인</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='<%=base.getTax_agnt()%>' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
                </tr>	
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                	  
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
                
                
                <tr id=tr_lic_no1 <%if(!client.getClient_st().equals("1")){ %>style="display:''"<%}else{%>style="display:'none'"<%} %>>
                    <td class='title'>계약자 운전면허번호</td>
		            <td colspan='3'>&nbsp;<input type='text' name='lic_no' value='<%=base.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
						<input type="hidden" name="ssn" value="<%=client.getSsn1()%><%=client.getSsn2()%>">
					</td>
		            <td>&nbsp;(개인,개인사업자)&nbsp;※ 계약자(<%=client.getClient_nm()%>)의 운전면허번호를 기재</td>
                </tr>
                <tr id=tr_lic_no2 <%if(!client.getClient_st().equals("1")){ %>style="display:''"<%}else{%>style="display:'none'"<%} %>>
                    <td class='title' width='13%'>차량이용자 운전면허번호</td>
		            <td width='15%'>&nbsp;<input type='text' name='mgr_lic_no' value='<%=base.getMgr_lic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='20%'>&nbsp;이름 : <input type='text' name='mgr_lic_emp' value='<%=base.getMgr_lic_emp()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='mgr_lic_rel' value='<%=base.getMgr_lic_rel()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='40%'>&nbsp;(개인,개인사업자)<%if(client.getClient_st().equals("3")||client.getClient_st().equals("4")||client.getClient_st().equals("5")){%>&nbsp;※ 계약자가 운전면허가 없는 경우 차량이용자의 운전면허를 입력<%}%></td>
                </tr>  
                
                
	            <%//if(mgr5.getMgr_st().equals("추가운전자")){ %>    
                <tr id=tr_lic_no3 style="display:''">
                    <td class='title'>추가운전자 운전면허번호</td>
		            <td>&nbsp;<input type='text' name='mgr_lic_no5' value='<%=mgr5.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;이름 : <input type='text' name='mgr_lic_emp5' value='<%=mgr5.getMgr_nm()%>'  size='10' class='text'></td>
		            <td>&nbsp;관계 : <input type='text' name='mgr_lic_rel5' value='<%=mgr5.getEtc()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;검증결과 : <select name='mgr_lic_result5'>
        		          		<option value='' <%if(mgr5.getLic_result().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(mgr5.getLic_result().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        		<%}%> 
        		            </select>&nbsp;※ 계약서의 "운전자범위" 외의 운전자를 추가운전자로 허용하는 경우에는 추가운전자 운전가격을 검증</td>
                </tr>                
    	        <%//} %>         
            
                <!-- 운전자격검증결과 -->
                    
                <tr>
                    <td class='title' rowspan='2' width='13%'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <input type='text' name='test_lic_emp' value='<%=base.getTest_lic_emp()%>'  size='8' class='text'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='test_lic_rel' value='<%=base.getTest_lic_rel()%>'  size='10' class='text'></td>
		            <td width='40%'>&nbsp;검증결과 : <select name='test_lic_result'>
        		          		<option value='' <%if(base.getTest_lic_result().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(base.getTest_lic_result().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="3%" rowspan="<%=mgr_size+2%>" class=title>관<br>계<br>자</td>
                    <td class=title width="10%">구분</td>
                    <td class=title width="8%">근무처</td>			
                    <td class=title width="8%">부서</td>
                    <td class=title width="8%">성명</td>
                    <td class=title width="8%">직위</td>
                    <td class=title width="10%">전화번호</td>
                    <td class=title width="10%">휴대폰</td>
                    <td width="30%" class=title>E-MAIL</td>
                    <td width="5%" class=title>조회</td>
                </tr>
    		  <%String mgr_zip = "";
    			String mgr_addr = "";
    		  	for(int i = 0 ; i < mgr_size ; i++){
    				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
    				
    				//if(mgr.getMgr_st().equals("추가운전자")){
    				//	continue;
    				//}
    				
    				if(mgr.getMgr_st().equals("차량이용자")){
    					mgr_zip = mgr.getMgr_zip();
    					mgr_addr = mgr.getMgr_addr();
    				}%>
                <tr>                 <input type='hidden' name='mgr_id' value='<%=mgr.getMgr_id()%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%=mgr.getMgr_st()%>' class='white' readonly ></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' value='<%=mgr.getCom_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' value='<%=mgr.getMgr_dept()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' value='<%=mgr.getMgr_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' value='<%=mgr.getMgr_title()%>' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' value='<%=mgr.getMgr_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='<%=mgr.getMgr_m_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>				
                    <td align='center'><input type='text' name='mgr_email' size='30' value='<%=mgr.getMgr_email()%>' class='text' style='IME-MODE: inactive'><input type='hidden' name="email_1" value=""><input type='hidden' name="email_2" value=""></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		  <%	} %>
                <tr>                 <input type='hidden' name='mgr_id'  value='<%=mgr_size%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='' class='text'></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' value='' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_email' size='30' value='' class='text'><input type='hidden' name="email_1" value=""><input type='hidden' name="email_2" value=""></td>                    
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=mgr_size%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>		  		  
                <tr> 
                    <td colspan="2" class=title>차량이용자 실거주지 주소</td>
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
					<td colspan=8>&nbsp;
						<input type="text" name="t_zip" id="t_zip1" size="7" maxlength='7' value="<%=mgr_zip%>">
						<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr1" size="100" value="<%=mgr_addr%>">
					</td>					
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('1')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
	<tr>	

</table>
 
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
//-->
</script>
</body>
</html>
