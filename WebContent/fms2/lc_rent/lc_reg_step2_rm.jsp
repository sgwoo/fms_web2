<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP", "Y");
	int user_size = users.size();
	
	//월렌트정보
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	
	UsersBean busid_bean 	= umd.getUsersBean(base.getBus_id());
	
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
	//고객 조회
	function search_client()
	{
		window.open("/fms2/client/client_s_frame.jsp?car_st=<%=base.getCar_st()%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2_rm.jsp", "CLIENT", "left=10, top=10, width=1100, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("선택된 고객이 없습니다."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 조회
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=600");
	}			
	//지점/현장 보기
	function view_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}
		if(fm.site_id.value == "")	{ alert("지점/현장을 먼저 선택하십시오."); return;}		
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=600");
	}			

	//관계자 조회
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_mgr.jsp?car_st=<%=base.getCar_st()%>&idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
	
	//연대보증인
	function cng_input(){
		var fm = document.form1;		
		if(fm.guar_st[0].checked == true){ 				//가입
			tr_guar2.style.display	= '';
		}else{											//면제
			tr_guar2.style.display	= 'none';
		}
	}	
	
	//대표이사보증
	function cng_input2(){	
		var fm = document.form1;		
		if(fm.client_guar_st[0].checked == true){ 		//가입
			tr_client_guar.style.display = 'none';		
		}else{											//면제
			tr_client_guar.style.display = '';				
		}
	}
	
	//공동임차인 운전면허검증
	function cng_input4(){
		if(document.form1.client_st.value == '2' && document.form1.client_share_st[0].checked==true){
			tr_client_share_st_test.style.display='';//가입
		}else{
			tr_client_share_st_test.style.display='none';//면제
		}
	}	

	//관계자 조회
	function search_gur(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_gur.jsp?idx="+idx+"&client_id="+fm.client_id.value, "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//주소 조회
	function search_post(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_post.jsp?idx="+idx+"&client_id="+fm.client_id.value, "POST", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//다음단계로 넘어가기
	function save(){
		var fm = document.form1;
		if(fm.client_id.value == '')		{ alert('고객을 선택하십시오.'); 					return;}
		
		<%if(!ck_acar_id.equals("000029")){%>
		
		if(fm.guar_st[0].checked == true){
			if(fm.gur_nm[0].value == '')	{ alert('연대보증인 성명을 입력하십시오.'); 			return;}
			if(fm.gur_ssn[0].value == '')	{ alert('연대보증인 생년월일을 입력하십시오.'); 		return;}
			if(fm.t_addr[2].value == '')	{ alert('연대보증인 주소를 입력하십시오.'); 			return;}
			if(fm.gur_tel[0].value == '')	{ alert('연대보증인 연락처를 입력하십시오.'); 		return;}
			if(fm.gur_rel[0].value == '')	{ alert('연대보증인 관계를 입력하십시오.'); 			return;}												
		}		
				
		if(fm.client_share_st[0].checked == false && fm.client_share_st[1].checked == false){		
			alert('대표이사 공동임차인여부를 선택하십시오.'); return;			
		}
		if(fm.client_st.value != '1'){		
			fm.client_share_st[1].checked = true;		
		}
		
		if(fm.client_st.value == '1' && fm.client_guar_st[1].checked == true){		
			if(fm.guar_con.options[fm.guar_con.selectedIndex].value == '')		{ alert('대표이사보증 면제조건을 선택하십시오.'); 	return;}			
			if(fm.guar_sac_id.options[fm.guar_sac_id.selectedIndex].value == '')	{ alert('대표이사보증 면제 결재자를 선택하십시오.'); 	return;}						
		}
		

		//월렌트는 차량운전자의 운전면허번호 필수
		if(fm.mgr_lic_no[0].value == '' || fm.mgr_lic_no[0].value.length < 12){
			alert('월렌트 차량운전자의 운전면허번호를 입력하십시오.'); 			
			return;
		}				
		
		if(fm.test_lic_emp.value == '' || fm.test_lic_rel.value == '' || fm.test_lic_result.value == ''){
			alert('운전면허정보검증 대상자정보 및 검증결과를 입력하십시오.');
			return;
		}
		if(fm.test_lic_result.value != '1'){
			alert('운전자격 없는 자에게 차량을 대여할 수 없습니다. 운전자격 검증결과를 확인해주세요.');
			return;
		}		
		//추가운전자 있으면 검증필수
		if(fm.mgr_lic_no[4].value != ''){	
			if(fm.test_lic_result2.value == ''){
				alert('추가운전자 운전면허정보검증 대상자정보 및 검증결과를 입력하십시오.');
				return;
			}
			if(fm.test_lic_result2.value != '1'){
				alert('추가운전자 운전자격 없는 자에게 차량을 대여할 수 없습니다. 운전자격 검증결과를 확인해주세요.');
				return;
			}
		}
		
		
		if(fm.mgr_nm[0].value == '' || fm.mgr_nm[0].value.length < 2){
			alert('차량이용자 성명을 입력하십시오.'); 			
			return;
		}
		if(fm.mgr_m_tel[0].value == '' || fm.mgr_m_tel[0].value.length < 10){
			alert('차량이용자 휴대폰을 입력하십시오.'); 			
			return;
		}
		
		<%if(busid_bean.getLoan_st().equals("1")){%>
		if(fm.mng_type[0].checked == false && fm.mng_type[1].checked == false){		
			alert('영업담당자 배정방식을 선택하십시오.'); return;			
		}
		<%}else{%>
	    <%	if(base.getRent_st().equals("3")||base.getRent_st().equals("4")){//증차,대차%>
	    	if(fm.mng_type[0].checked == false && fm.mng_type[1].checked == false){		
				alert('영업담당자 배정방식을 선택하십시오.'); return;			
			}
	    <%	}%>
		<%}%>	
		
		<%}%>
		
		if(confirm('2단계를 등록하시겠습니까?')){		
			fm.action='lc_reg_step2_a.jsp';
			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}		
	}
	
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
	}
		
//-->
</script> 
</head>
<body leftmargin="15">
<form action='lc_reg_step2_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="old_rent_mng_id" 	value="<%=old_rent_mng_id%>">
  <input type='hidden' name="old_rent_l_cd" 	value="<%=old_rent_l_cd%>">

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan='2'>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <!--
    <tr>
        <td align='right'>&nbsp;<a href="javascript:history.go(-1);"><img src=/acar/images/center/button_back_p.gif align=absmiddle border=0></a></td>
    </tr>
    -->
    <tr>
        <td align='left'>&nbsp;&nbsp; <span class=style2> <font color=red>[2단계]</font> 고객사항</span></td>
        <td align='right'>&nbsp;</td>
    </tr>
    <tr>
        <td align='left'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%> (<%=rent_mng_id%>)</td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;<%=base.getRent_dt()%></td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}else if(car_gu.equals("3")){%>월렌트<%}%><%if(base.getReject_car().equals("Y")){%>&nbsp;(인수거부차량)<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<b><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("4")){%>월렌트<%}else if(car_st.equals("5")){%>업무대여<%}%></b></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<b><%String rent_way = base.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></b></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%><%if(!base.getAgent_emp_id().equals("")){%>&nbsp;(계약진행담당자:<%=c_db.getNameById(base.getAgent_emp_id(),"CAR_OFF_EMP")%>)<%}%></td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객</span></td>
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
                      <input type='text' name="firm_nm" size='50' class='text' readonly>
        			  <input type='hidden' name='client_id' value=''>
        			  <input type='hidden' name='client_st' value=''>
        			  <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>&nbsp;
        			  <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
        			  </td>
                    <td width='10%' class='title'>대표자</td>
                    <td align='left'>&nbsp;
                      <input type='text' name="client_nm" value='' size='22' class='whitetext' readonly></td>
                </tr>
                <tr>
                    <td class='title'>지점/현장</td>
                    <td height="26" colspan="3" class='left'>&nbsp; 
        			  <input type='text' name="site_nm" value='' size='50' class='text' readonly>
        			  <input type='hidden' name='site_id' value=''>
        			  <span class="b"><a href='javascript:search_site()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
        			</td>
                </tr>
				
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
					
                <tr>
                    <td class='title'>우편물주소</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="" readonly>
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="40" value="" readonly>
						&nbsp;상세주소 : <input type="text" name="t_addr_sub" size="30" >
						&nbsp;&nbsp;<span class="b"><a href="javascript:search_post('0')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					</td>

                    <td class='title'>우편물수취인</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
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
                <tr id=tr_lic_no1 style="display:''">
                    <td class='title' width='13%'>계약자 운전면허번호</td>
		            <td colspan='3'>&nbsp;<input type='text' name='lic_no' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
						<input type="hidden" name="ssn" value="">
					</td>
		            <td>&nbsp;(개인,개인사업자)&nbsp;※ 계약자의 운전면허번호를 기재</td>
                </tr>
                                  	 
                <!-- 운전자격검증결과 -->
                <tr>
                    <td class='title' rowspan='2'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <input type='text' name='test_lic_emp' value=''  size='8' class='text'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='test_lic_rel' value=''  size='10' class='text'></td>
		            <td width='40%'>&nbsp;검증결과 : <select name='test_lic_result'>
        		          		<option value='' <%if(base.getTest_lic_result().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
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
                    <td width="3%" rowspan="6" class=title>관<br>계<br>자</td>
                    <td class=title width="10%">구분</td>
                    <td class=title width="10%">성명</td>			
                    <td class=title width="12%">생년월일</td>
                    <td class=title width="15%">주소</td>
                    <td class=title width="10%">전화번호</td>
                    <td class=title width="10%">휴대폰</td>
                    <td width="10%" class=title>운전면허번호</td>
                    <td width="15%" class=title>기타</td>
                    <td width="5%" class=title>조회</td>
                </tr>    		    
    		<%	for(int i=0; i<=4; i++){%>
                <tr> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%if(i==0) out.println("차량이용자"); else if(i==1) out.println("차량관리자"); else if(i==2) out.println("회계관리자"); else if(i==3) out.println("계약담당자"); else if(i==4) out.println("추가이용자");%>' class='white' readonly ></td>
                    <td align='center'><input type='text' name='mgr_nm'   size='13' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_ssn'  size='15' maxlength='8' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_addr'  size='20' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_tel'    size='13' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
                    <td align='center'><input type='text' name='mgr_lic_no'   size='13' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
                    <td align='center'><input type='text' name='mgr_etc' size='20' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		<%	} %>   
    		<!-- 운전자격검증결과 -->
                <tr>
                    <td class='title' colspan='2'>추가운전자 운전자격검증</td>
		            <td>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>		            
		            <td colspan='2'>&nbsp;검증결과 : <select name='test_lic_result2'>
        		          		<option value='' <%if(base.getTest_lic_result2().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
		            <td colspan='5'>&nbsp;※ 추가운전자가 있는 경우 운전자격을 검증</td>
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
                <tr>
                    <td width='13%' class='title'>차량이용지 주소</td>                    
                    <td colspan=2>&nbsp;
		                <script>
							function openDaumPostcode3() {
								new daum.Postcode({
									oncomplete: function(data) {
										document.getElementById('c_u_zip').value = data.zonecode;
										document.getElementById('c_u_addr').value = data.address;
										
									}
								}).open();
							}
						</script>
						<input type="text" name="c_u_zip" id="c_u_zip" size="7" maxlength='7' value="">
						<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<input type="text" name="car_use_addr" id="c_u_addr" size="60" value="<%=cont_etc.getCar_use_addr()%>">
					</td>
                </tr>  
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 공동임차</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_client_share_st style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>공동임차여부</td>
                    <td colspan="4" align='left'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' onClick="javascript:cng_input4()">
        				있다
        	      <input type='radio' name="client_share_st" value='2' <%if(car_st.equals("4")){%>checked<%}%> onClick="javascript:cng_input4()">
        				없다</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr id=tr_client_share_st_test style="display:none"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                     
                <tr>
                    <td width='13%' class='title' rowspan='2'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <input type='text' name='test_lic_emp2' value=''  size='8' class='text'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='test_lic_rel2' value=''  size='10' class='text'></td>
		            <td width='40%'>&nbsp;검증결과 : <select name='test_lic_result2'>
        		          		<option value=''>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;(개인)&nbsp;※ 개인고객의 공동임차인이 있는 경우 운전자격을 검증</td>
                </tr> 
            </table>  
        </td>
    </tr>        
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 연대보증</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_client_guar_st style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증여부</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1' onClick="javascript:cng_input2()" checked>
        				입보
        			  <input type='radio' name="client_guar_st" value='2' onClick="javascript:cng_input2()" <%if(car_st.equals("4")){%>checked<%}%>>
        				면제</td>
                </tr>
                <tr id=tr_client_guar style='display:none'>
                    <td width='13%' class='title'>면제조건</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <select name='guar_con'>
                          <option  value="">선택</option>
                          <option value="6">대표공동임차</option>
                          <option value="1">신용우수법인</option>
                          <option value="2">선수금으로대체</option>
                          <option value="3">보증보험으로대체</option>
                          <option value="5">전문경영인</option>
                          <option value="4">기타 결재획득</option>
                        </select>
                    </td>
                    <td width="10%" class='title'>결재자</td>
                    <td width='27%' class='left'>&nbsp;
        			  <select name="guar_sac_id">
        			    <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
        			</td>
                </tr>
            </table>  
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연대보증인 (대표 외)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증유무</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="guar_st" value='1' onClick="javascript:cng_input()">
        				입보
        			  <input type='radio' name="guar_st" value='2' onClick="javascript:cng_input()" checked>
        				면제</td>
                </tr>
                <tr id=tr_guar2 style='display:none'>
                    <td height="26" colspan="4" class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width="13%" class=title>구분</td>
                                <td width="10%" class=title>성명</td>
                                <td width="15%" class='title'>생년월일</td>
                                <td width="28%" class='title'>주소</td>
                                <td width="13%" class='title'>연락처</td>
                                <td width="16%" class='title'>관계</td>
                                <td width="5%" class='title'>조회</td>
                            </tr>
                            <%for(int i=0; i<3; i++){%>
                            <tr>
                                <td class=title>연대보증인</td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" maxlength='8' class='text' value=''></td>
                                <td align="center">
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
									<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value="<%=base.getP_zip()%>">
									<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr2" size="25" value="<%=base.getP_addr()%>">
								</td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value=''></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                            <%}%>
                        </table>
                    </td>
                </tr>
            </table>  
        </td>
    </tr>
    <%if(busid_bean.getLoan_st().equals("1")){%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업담당자 배정</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>배정방식</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="mng_type" value='1'>
        				최초영업자 본인
        			  <input type='radio' name="mng_type" value='2'>
        				자동배정 (차량이용지역 지점별 권역 기준으로 배정) </td>
                </tr>
            </table>
        </td>
    </tr>    
    <%}else{%>
    <%	if(base.getRent_st().equals("3")||base.getRent_st().equals("4")){//증차,대차%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업담당자 배정</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>배정방식</td>
                    <td colspan="3" align='left'>&nbsp;                    
                      <input type='radio' name="mng_type" value='3'>
        				기존담당자
        			  <input type='radio' name="mng_type" value='2'>
        				자동배정 (차량이용지역 지점별 권역 기준으로 배정) </td>
                </tr>
            </table>
        </td>
    </tr>     
    <%	}else{%>
    <input type="hidden" name="mng_type" value="2">
    <%	}%>
    <%}%>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr>
		<td align='right'><a href="javascript:save();"><img src=/acar/images/center/button_next.gif align=absmiddle border=0></a></td>
	</tr>
    <%}%>	
	<tr>
	    <td></td>
	</tr>
	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
    <tr>
        <td align='right'>
    	 <a href="lc_reg_step4_rm.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&auth_rw=<%=auth_rw%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp;
    	 <a href="lc_b_u_rm.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&auth_rw=<%=auth_rw%>" target='d_content'><img src=/acar/images/center/button_mig.gif align=absmiddle border=0></a>&nbsp;
    	 <a href="lc_c_frame.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>
    	  </td>
    </tr>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
