<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.user_mng.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
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
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	if(fee_size > 1) rent_st = Integer.toString(fee_size);
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");	
	//마지막대여정보
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
		
	//영업소리스트
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&from_page="+from_page+"&now_stat="+now_stat+"&san_st="+san_st+"&fee_rent_st="+fee_rent_st;
		
	//이름조회
	int user_idx = 0;
	
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
	//수정
	function update(idx){
		var fm = document.form1;
		if(<%=base.getRent_dt()%> > 20070831){
				if(fm.rent_dt.value == ''){alert('계약일자를 확인하십시오.');return;}
				if(fm.mng_br_id.value == ''){alert('관리지점을 확인하십시오.');return;}
				if(fm.car_st.value == ''){alert('용도구분을 확인하십시오.');return;}
				//예비차가 아닌 경우
				if(fm.car_st.value != '2' && fm.car_st.value != '5'){
					if(fm.bus_id2.value == ''){alert('영업담당자를 확인하십시오.');return;}
					if(fm.mng_id.value == ''){alert('관리담당자를 확인하십시오.');return;}
					if(fm.rent_st.value == ''){alert('계약구분을 확인하십시오.');return;}
					if(fm.bus_st.value == ''){alert('영업구분을 확인하십시오.');return;}
					if(fm.rent_way.value == ''){alert('관리구분을 확인하십시오.');return;}
					if(fm.bus_agnt_id.value.substring(0,1) == '1'){alert('영업대리인이 부서로 선택되었습니다. 확인해주세요.');return;}
					if(fm.bus_id2.value.substring(0,1) == '1'){alert('영업담당자가 부서로 선택되었습니다. 확인해주세요.');return;}
					if(fm.mng_id.value.substring(0,1) == '1'){alert('관리담당자가 부서로 선택되었습니다. 확인해주세요.');return;}
					if(fm.mng_id2.value.substring(0,1) == '1'){alert('예비배정자가 부서로 선택되었습니다. 확인해주세요.');return;}
					if(fm.car_st.value != '<%=base.getCar_st()%>'){alert('용도구분을 변경하는 경우에 대여요금, 영업수당 등을 확인하고 수정하셔야 합니다.');}
					if(fm.rent_way.value != '<%=max_fee.getRent_way()%>'){alert('관리구분을 변경하는 경우에 대여요금, 보험사항 차량관리서비스제공범위 등을 확인하고 수정하셔야 합니다.');}
				}
		}
		
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){
			fm.action='lc_b_s_a.jsp';
			fm.target='_self';
			fm.submit();
		}
	}

	//변경이력관리항목 수정
	function item_cng_update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id' || st == 'bus_st' || st == 'est_area'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650, status=yes, scrollbars=yes");
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
	//에이전트직원조회
	function Agent_User_search(nm)
	{
		var fm = document.form1;
		if(fm.bus_id.value == '')		{ alert('최초영업자를 선택하십시오.'); 		return;}
		var t_wd = fm.agent_emp_nm.value;
		window.open("about:blank",'Agent_User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');
		fm.action = "/fms2/lc_rent/search_agent_user.jsp?mode=EMP_Y&nm="+nm+"&t_wd="+t_wd+"&agent_user_id="+fm.bus_id.value;
		fm.target = "Agent_User_search";
		fm.submit();
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
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_0.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="fee_rent_st"	value="<%=fee_rent_st%>">
  <input type='hidden' name="idx"	value="">
     
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
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%>(<%=rent_mng_id%>)</td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%if(cont_etc.getMng_br_id().equals("")) cont_etc.setMng_br_id(base.getBrch_id());%>
                    <%if(acar_de.equals("1000")){ %>
                    <%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%>
                    <input type='hidden' name="mng_br_id"	value="<%=cont_etc.getMng_br_id()%>">
                    <%}else{ %>
        	        <select name='mng_br_id'>
                            <option value=''>선택</option>
                            <%for (int i = 0 ; i < brch_size ; i++){
        			Hashtable branch = (Hashtable)branches.elementAt(i);%>
                            <option value='<%=branch.get("BR_ID")%>' <%if(cont_etc.getMng_br_id().equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                            <%}%>
                        </select>
                    <%} %>    
                    </td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;
					  <%if((nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id) || user_id.equals(base.getBus_id()) || user_id.equals(cont_etc.getBus_agnt_id()))){%>					  
        			  	  <input type="text" name="rent_dt" value="<%=AddUtil.ChangeDate2(base.getRent_dt())%>" size="12" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(base.getRent_dt())%><input type='hidden' name='rent_dt' 	value='<%=base.getRent_dt()%>'>
					  <%}%>
					</td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;
        			  <select name="rent_st">
                      <option value=''>선택</option>
                      <option value='1' <%if(base.getRent_st().equals("1")){%>selected<%}%>>신규</option>
                      <option value='3' <%if(base.getRent_st().equals("3")){%>selected<%}%>>대차</option>
                      <option value='4' <%if(base.getRent_st().equals("4")){%>selected<%}%>>증차</option>
                    </select></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;
                    <%if(acar_de.equals("1000")){ %>
                    <%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%>
                    <input type='hidden' name="bus_st"	value="<%=bus_st%>">
                    <%}else{ %>
        			  <select name="bus_st">
                        <option value="">선택</option>                        
                        <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>인터넷</option>
                        <option value="8" <%if(base.getBus_st().equals("8")){%>selected<%}%>>모바일</option>
                        <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>전화상담</option>                        
                        <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>영업사원</option>
                        <option value="7" <%if(base.getBus_st().equals("7")){%>selected<%}%>>에이젼트</option>                        
                        <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>기존업체</option>
                        <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>업체소개</option>
                        <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog</option>                        
                      </select>
                      <%} %>
                      </td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%>
                      <input type='hidden' name="car_gu"		value="<%=base.getCar_gu()%>">      
                    </td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("5")){%>업무대여<%}%>
                      <input type='hidden' name="car_st"		value="<%=base.getCar_st()%>">      
                    </td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;
        			  <select name="rent_way">
                        <option value=''>선택</option>
                        <option value='1' <%if(max_fee.getRent_way().equals("1")){%>selected<%}%>>일반식</option>
                        <option value='2' <%if(max_fee.getRent_way().equals("2")){%>selected<%}%>>맞춤식</option>
                        <option value='3' <%if(max_fee.getRent_way().equals("3")){%>selected<%}%>>기본식</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;
                    	<%if(acar_de.equals("1000")){ %>
                    	<%=c_db.getNameById(base.getBus_id(), "USER")%>
                    	<input type='hidden' name="user_nm"	value="">
                    	<%}else{ %>
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(base.getBus_id(), "USER")%>" size="12"> 
						<%	if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id)){%>
						<a href="javascript:User_search('bus_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
						<%	}%>
						<%}%>
						<input type="hidden" name="bus_id" value="<%=base.getBus_id()%>">
					<% user_idx++;%>		                                            
                    </td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getBus_agnt_id(), "USER")%>" size="12"> 
			<input type="hidden" name="bus_agnt_id" value="<%=cont_etc.getBus_agnt_id()%>">
			<a href="javascript:User_search('bus_agnt_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
		    </td>
                    <td class=title>예비배정자</td>
                    <td>&nbsp;
                    	<%if(acar_de.equals("1000")){ %>
                    	<input type='hidden' name="user_nm"	value="">
                    	<%}else{ %>
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(base.getMng_id2(), "USER")%>" size="12">
                        <a href="javascript:User_search('mng_id2', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
                        <%}%> 
						<input type="hidden" name="mng_id2" value="<%=base.getMng_id2()%>">
			<% user_idx++;%>
                    </td>					
                </tr>
                <%if(acar_de.equals("1000")){ %>
                <input type='hidden' name="user_nm"	value="">
                <input type='hidden' name="user_nm"	value="">
                <input type='hidden' name="bus_id2"	value="<%=base.getBus_id2()%>">
                <input type='hidden' name="mng_id"	value="<%=base.getMng_id()%>">
                <input type='hidden' name="car_deli_dt"	value="<%=cont_etc.getCar_deli_dt()%>">
                <% user_idx++;%>
                <% user_idx++;%>
                <%}else{ %>
                <tr> 
                    <td class=title>영업담당자</td>
                    <td>&nbsp;			
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(base.getBus_id2(), "USER")%>" size="12"> 
			<input type="hidden" name="bus_id2" value="<%=base.getBus_id2()%>">
			<%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id)){%>
			<a href="javascript:User_search('bus_id2', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>			
			<%}%>
			<% user_idx++;%>
		    </td>
                    <td class=title>관리담당자</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(base.getMng_id(), "USER")%>" size="12"> 
			<input type="hidden" name="mng_id" value="<%=base.getMng_id()%>">
			<%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id)){%>
			<a href="javascript:User_search('mng_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<%}%>
			<% user_idx++;%>
  		    </td>
                    <td class=title>차량인도일</td>
                    <td>&nbsp;
        			  <input type="text" name="car_deli_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>" size="12" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <%}%> 
                <tr>
				<td class=title>계약진행담당자</td>
                    <td>&nbsp;
                        <input name="agent_emp_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(base.getAgent_emp_id(), "CAR_OFF_EMP")%>" size="12"> 
			<input type="hidden" name="agent_emp_id" value="<%=base.getAgent_emp_id()%>">
			<a href="javascript:Agent_User_search('agent_emp_id');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>			
			(에이전트계약)
                    </td>                	
                    <td class=title>차량이용지역</td>
                    <td colspan='3'>&nbsp;
                        <%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
                        <input type='hidden' name="est_area" value="<%=cont_etc.getEst_area()%>">
			<input type='hidden' name='county' value='<%=cont_etc.getCounty()%>'>
			<%    if(base.getUse_yn().equals("") || cont_etc.getEst_area().equals("") || cont_etc.getCounty().equals("")){%>
			<a href="javascript:item_cng_update('est_area')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
			<%    }%>			
		    </td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('0')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
		  &nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
    </tr>
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
