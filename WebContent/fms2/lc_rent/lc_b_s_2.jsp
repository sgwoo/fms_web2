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
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
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
	//대표이사보증
	function cng_input2(){
		if(document.form1.client_guar_st[0].checked==true){tr_client_guar.style.display='none';}//가입
		else{tr_client_guar.style.display='';}//면제
	}
	//공동임차인 운전면허검증 
	function cng_input4(){
		<%if(client.getClient_st().equals("2")){%>
		if(document.form1.client_share_st[0].checked==true){
			tr_client_share_st_test.style.display='';//가입
		}else{
			tr_client_share_st_test.style.display='none';//면제
		}
		<%}%>
	}	
	//연대보증인
	function guar_display(){
		if(document.form1.guar_st[0].checked==true){tr_guar2.style.display='';}//가입
		else{tr_guar2.style.display='none';}//면제
	}
	//관계자 조회
	function search_gur(idx){if('<%=base.getClient_id()%>' == ""){ alert("고객을 먼저 선택하십시오."); return;} window.open("search_gur.jsp?idx="+idx+"&client_id=<%=base.getClient_id()%>&from_page=/fms2/lc_rent/lc_b_s_2.jsp", "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");}

	//수정
	function update(idx){
		var fm = document.form1;
		if(<%=base.getRent_dt()%> > 20070831){

				<%-- if('<%=client.getClient_st()%>' == '1' && fm.client_share_st[0].checked == false && fm.client_share_st[1].checked == false){alert('대표이사 공동임차인여부를 선택하십시오.');return;} --%>
				if(fm.client_share_st[0].checked == false && fm.client_share_st[1].checked == false){alert('대표이사 공동임차인여부를 선택하십시오.');return;}	// 개인, 개인사업자도 대표 공동임차 사용. 20210308.
				<%-- if('<%=client.getClient_st()%>' != '1'){fm.client_share_st[1].checked = true;} --%>
				if('<%=client.getClient_st()%>' !='2' && fm.client_guar_st[1].checked == true){
					if(fm.guar_con.options[fm.guar_con.selectedIndex].value == ''){alert('대표이사보증 면제조건을 선택하십시오.');return;}
					if(fm.guar_sac_id.value == ''){ alert('대표이사보증 면제 결재자를 선택하십시오.');	return;}
				}			
				if(fm.guar_st[0].checked == true){
					if(fm.gur_nm[0].value == ''){alert('연대보증인 성명을 입력하십시오.');return;}
					if(fm.gur_ssn[0].value == ''){alert('연대보증인 생년월일를 입력하십시오.');return;}
					if(fm.t_addr[0].value == ''){alert('연대보증인 주소를 입력하십시오.');return;}
					if(fm.gur_tel[0].value == ''){alert('연대보증인 연락처를 입력하십시오.');return;}
					if(fm.gur_rel[0].value == ''){alert('연대보증인 관계를 입력하십시오.');	return;}
				}
		}
		
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_s_a.jsp';		
			fm.target='_self';
			fm.submit();
		}							
	}
	
	//직원조회
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
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
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_2.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">
  <input type='hidden' name="idx"	value="">
  <input type='hidden' name="gur_size"			value="<%=gur_size%>">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 공동임차</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <%-- <tr id=tr_client_share_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>"> --%> 
    <tr id='tr_client_share_st'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>공동임차여부</td>
                    <td align='left' colspan='4'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' <%if(cont_etc.getClient_share_st().equals("1"))%>checked<%%> onClick="javascript:cng_input4()">
        				있다
        	      <input type='radio' name="client_share_st" value='2' <%if(!cont_etc.getClient_share_st().equals("1"))%>checked<%%> onClick="javascript:cng_input4()">
        				없다</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr id=tr_client_share_st_test style="display:<%if(client.getClient_st().equals("2") && cont_etc.getClient_share_st().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <!-- 운전자격검증결과 -->
                <tr>
                    <td width='13%' class='title' rowspan='2'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <input type='text' name='test_lic_emp2' value='<%=base.getTest_lic_emp2()%>'  size='8' class='text'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='test_lic_rel2' value='<%=base.getTest_lic_rel2()%>'  size='10' class='text'></td>
		            <td width='40%'>&nbsp;검증결과 : <select name='test_lic_result2'>
        		          		<option value='' <%if(base.getTest_lic_result2().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(base.getTest_lic_result2().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 연대보증</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_client_guar_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증여부</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1' onClick="javascript:cng_input2()" <%if(cont_etc.getClient_guar_st().equals("1"))%>checked<%%>>
        				입보
        			  <input type='radio' name="client_guar_st" value='2' onClick="javascript:cng_input2()" <%if(cont_etc.getClient_guar_st().equals("2"))%>checked<%%>>
        				면제</td>
                </tr>
                <tr id=tr_client_guar style="display:<%if(cont_etc.getClient_guar_st().equals("2")){%>''<%}else{%>none<%}%>">
                    <td class='title'>면제조건</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <select name='guar_con'>
                          <option value="">선택</option>
                          <option value="6" <%if(cont_etc.getGuar_con().equals("6")){%>selected<%}%>>대표공동임차</option>
                          <option value="1" <%if(cont_etc.getGuar_con().equals("1")){%>selected<%}%>>신용우수법인</option>
                          <option value="2" <%if(cont_etc.getGuar_con().equals("2")){%>selected<%}%>>선수금으로대체</option>
                          <option value="3" <%if(cont_etc.getGuar_con().equals("3")){%>selected<%}%>>보증보험으로대체</option>
                          <option value="5" <%if(cont_etc.getGuar_con().equals("5")){%>selected<%}%>>전문경영인</option>
                          <option value="4" <%if(cont_etc.getGuar_con().equals("4")){%>selected<%}%>>기타 결재획득</option>
                        </select>
                    </td>
                    <td width="10%" class='title'>결재자</td>
                    <td class='left'>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getGuar_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="guar_sac_id" value="<%=cont_etc.getGuar_sac_id()%>">			
			<a href="javascript:User_search('guar_sac_id', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
        	    </td>
                </tr>
            </table>  
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연대보증인 <%if(client.getClient_st().equals("1")){%>(대표 외)<%}%></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증유무</td>
                    <td width='87%' align='left'>&nbsp;
                      <input type='radio' name="guar_st" value='1' onClick="javascript:guar_display()" <%if(cont_etc.getGuar_st().equals("1")){%>checked<%}%>>
        				입보
        			  <input type='radio' name="guar_st" value='2' onClick="javascript:guar_display()" <%if(cont_etc.getGuar_st().equals("2")){%>checked<%}%>>
        				면제</td>
                </tr>
                <tr id=tr_guar2 <%if(cont_etc.getGuar_st().equals("1")){%>style="display:''"<%}else{%>style='display:none'<%}%>>
                    <td height="26" colspan="2" class=line>
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
                <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>                
                            
                      <%for(int i = 0 ; i < gur_size ; i++){
        					        Hashtable gur = (Hashtable)gurs.elementAt(i);
                          String gur_ssn = String.valueOf(gur.get("GUR_SSN"));
        					        if(gur_ssn.length()==13){
                    	      gur_ssn = gur_ssn.substring(0,6)+"-"+gur_ssn.substring(6,7);
                    	    }
        					%>	
                            <tr>
                                <td class=title>연대보증인<input type='hidden' name='gur_id' value='<%=gur.get("GUR_ID")%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value='<%=gur.get("GUR_NM")%>'></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" maxlength='8' class='text' value='<%=gur_ssn%>'></td>
								<script>
									function openDaumPostcode<%=i%>() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip<%=i%>').value = data.zonecode;
												document.getElementById('t_addr<%=i%>').value = data.address;
											}
										}).open();
									}
								</script>
                                <td align="center">
									<input type="text" name="t_zip"  id="t_zip<%=i%>" size="7" maxlength='7' value="<%=gur.get("GUR_ZIP")%>">
									<input type="button" onclick="openDaumPostcode<%=i%>()" value="우편번호 찾기"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr<%=i%>" size="25" value="<%=gur.get("GUR_ADDR")%>">
								</td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value='<%=gur.get("GUR_TEL")%>'></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value='<%=gur.get("GUR_REL")%>'></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                      <%}%>
                      <%for(int i=gur_size; i<3; i++){%>
                            <tr>
                                <td class=title>연대보증인<input type='hidden' name='gur_id' value='<%=i+1%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" class='text' value=''></td>
								<script>
									function openDaumPostcode<%=i%>() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip<%=i%>').value = data.zonecode;
												document.getElementById('t_addr<%=i%>').value = data.address;
											}
										}).open();
									}
								</script>
                                <td align="center">
									<input type="text" name="t_zip"  id="t_zip<%=i%>" size="7" maxlength='7' value="">
									<input type="button" onclick="openDaumPostcode<%=i%>()" value="우편번호 찾기"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr<%=i%>" size="25" value="">
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
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||   auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('2')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
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
