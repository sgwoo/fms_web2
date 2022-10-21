<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.insur.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");//사고형태
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");//검색조건
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");//검색어
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	int our_p = 0;
	int ot_p = 0;
	
	if(s_gubun1.equals("1"))		ot_p = 100;
	else if(s_gubun1.equals("2"))	our_p = 100;
	else if(s_gubun1.equals("8"))	our_p = 100;
	else if(s_gubun1.equals("6"))	our_p = 100;
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "01");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);

	//보험정보
	String ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id);
		
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();	
	
	//최근입력분 사고리스트
	Vector accids = as_db.getAccidCarHList(c_id);
	int accid_size = accids.size();
	
	if(accid_size >5) accid_size = 5;
	
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//보유차 운행리스트 조회
	function res_search(){
		var fm = document.form1;	
		if(fm.c_id.value == ''){ alert('차량검색을 다시 하십시오.'); return; }	
		window.open("search_res.jsp?c_id="+fm.c_id.value, "SEARCH_RES", "left=100, top=100, width=700, height=400, scrollbars=yes");		
	}
	
	//보유차 기간과 사고일시 비교
	function dt_chk(){
		var fm = document.form1;	
		if(fm.car_st.value == '2' && fm.sub_rent_gu.value != '99'){
			var st_dt = replaceString("-","",fm.sub_rent_st.value);
			var et_dt = replaceString("-","",fm.sub_rent_et.value);
			var dt = replaceString("-","",fm.accid_dt.value);
			if(fm.sub_rent_st.value !='' && st_dt > dt){ alert('보유차 계약기간과 사고일자가 맞지 않습니다.'); return; 	}
			if(fm.sub_rent_et.value !='' && et_dt < dt){ alert('보유차 계약기간과 사고일자가 맞지 않습니다.'); return;	}
		}
	}	
		
	function save(){
		var fm = document.form1;
		
		if(fm.accid_st.value = '8' && fm.accid_dt.value == ''){ fm.accid_dt.value = fm.reg_dt.value; }		
		if(fm.accid_dt_h.value == ''){ fm.accid_dt_h.value='00'; }		
		if(fm.accid_dt_m.value == ''){ fm.accid_dt_m.value='00'; }		
		
		dt_chk();
		
		fm.h_accid_dt.value = fm.accid_dt.value+fm.accid_dt_h.value+fm.accid_dt_m.value;	
		
		if(fm.m_id.value == '' || fm.l_cd.value == '' || fm.c_id.value == ''){ alert('차량을 선택하십시오.'); return; }
		if(fm.accid_st.value == ''){ alert('사고유형을 선택하십시오.'); return; }
		if(fm.reg_dt.value == ''){ alert('접수일자를 입력하십시오.'); return; }		
		if(fm.reg_id.value == ''){ alert('접수자를 선택하십시오.'); return; }	
		if(fm.accid_st.value != '8' && fm.accid_dt.value == ''){ alert('사고일시를 입력하십시오.'); return; }		
		
		
		var accid_reg_chk = 0;
		
		//최근등록분과비교
		<%for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>			
			if(replaceString("-","",fm.h_accid_dt.value) == '<%=accid.get("ACCID_DT")%>'){
				accid_reg_chk = accid_reg_chk + 1;				
			}			
		<%}%>	
		
		if(accid_reg_chk > 0){		
			if(!confirm('동일한 일시에 등록된 사고가 있습니다. 등록하시겠습니까?')){	return;	}		
		}else{		
			if(!confirm('등록하시겠습니까?')){	return;	}		
		}
		
		fm.target = 'i_no';
		fm.action = 'accid_reg_a.jsp';
		fm.submit();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='accid_reg_a.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="s_gubun1" value='<%=s_gubun1%>'>
<input type='hidden' name="s_kd" value='<%=s_kd%>'>
<input type='hidden' name="t_wd" value='<%=t_wd%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="car_st" value='<%=cont.get("CAR_ST")%>'>
<input type='hidden' name="accid_st" value='<%=s_gubun1%>'>
<input type='hidden' name="rent_st" value='<%=rent_st%>'>
<input type='hidden' name="car_no" value='<%=cont.get("CAR_NO")%>'>
<input type='hidden' name="gubun" value='<%=gubun%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="h_accid_dt" value=''>
<input type='hidden' name="bus_id2" value='<%=cont.get("BUS_ID2")%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="9%">계약번호</td>
                    <td width="12%">&nbsp;<%=l_cd%></td>
                    <td class=title width="9%">상호</td>
                    <td colspan="3">&nbsp;<%=cont.get("FIRM_NM")%></td>
                    <td class=title width="9%">계약자</td>
                    <td width="11%">&nbsp;<%=cont.get("CLIENT_NM")%></td>
                    <td class=title width="9%">사용본거지</td>
                    <td width="14%">&nbsp;<%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title>차량번호</td>
                    <td>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td class=title>차명</td>
                    <td colspan="3">&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                    <td class=title>차량등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>관리담당자</td>
                    <td>&nbsp;<%=cont.get("USER_NM")%></td>
                </tr>
                <tr> 
                    <td class=title>보험회사</td>
                    <td >&nbsp;<b><font color='#990000'><%=ins_com_nm%></font></b></td>
                    <td class=title>대인배상Ⅱ</td>
                    <td width=9%> 
                      <%if(ins.getVins_pcp_kd().equals("1")){%>
                      &nbsp;무한
                      <%}%>
                      <%if(ins.getVins_pcp_kd().equals("2")){%>
                      &nbsp;유한
                      <%}%>
                    </td>
                    <td width=9% class=title>대물배상</td>
                    <td width=9%> 
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
                    <td class=title>자기신체</td>
                    <td colspan="3">&nbsp;1인당사망/장애: 
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
                  <td class=title>피보험자</td>
                  <td>&nbsp;
				    <%if(ins.getCon_f_nm().equals("아마존카")){%><%=ins.getCon_f_nm()%><%}else{%><b><font color='#990000'><%=ins.getCon_f_nm()%></font></b><%}%></td>
		  <td class=title>보험연령</td>
                  <td>&nbsp;
                    	<%if(ins.getAge_scp().equals("1")){%>21세이상<%}%>
                        <%if(ins.getAge_scp().equals("4")){%>24세이상<%}%>
                        <%if(ins.getAge_scp().equals("2")){%>26세이상<%}%>
                        <%if(ins.getAge_scp().equals("3")){%>전연령<%}%>
                        <%if(ins.getAge_scp().equals("5")){%>30세이상<%}%>
                        <%if(ins.getAge_scp().equals("6")){%>35세이상<%}%>
                        <%if(ins.getAge_scp().equals("7")){%>43세이상<%}%>
			<%if(ins.getAge_scp().equals("8")){%>48세이상<%}%>
                  </td>              		    
                  <td class=title>무보험차상해</td>
                  <td>&nbsp;
                    <%if(ins.getVins_canoisr_amt()>0){%>
                    가입<%}else{%>-
                  <%}%></td>
                  <td class=title>자기차량손해</td>
                  <td>&nbsp;
				    <%if(ins.getVins_cacdt_cm_amt()>0){%>
					<b><font color='#990000'>
                    가입
				    ( 차량 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>만원,
					자기부담금 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>만원)
					</font></b>
					<%}else{%>-
                  <%}%>
                  </td>
                  <td class=title>자차면책금</td>
                  <td>&nbsp;
                  	<%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(String.valueOf(cont.get("CAR_ST")).equals("2")){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보유차운행</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%><a href="javascript:res_search()">대여구분</a></td>
                    <td width=12%> 
                      <input type="text" name="sub_rent_gu_nm" value="" size="10" class=whitetext>                      
                      <input type='hidden' name="rent_s_cd" value=''>
                      <input type='hidden' name="sub_rent_gu" value=''>
                    </td>
                    <td class=title width=9%>상호</td>
                    <td width=27%> 
                      <input type="text" name="sub_firm_nm" value="" size="25" class=whitetext>
                    </td>
                    <td class=title width=9%>계약기간</td>
                    <td width=34%> 
                      <input type="text" name="sub_rent_st" value="" size="10" class=whitetext>
                      ~ 
                      <input type="text" name="sub_rent_et" value="" size="10" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>메모</td>
                    <td colspan="5">
                  <input type="text" name="memo" size="105" class="text">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%}%>	
	
<%	if(accid_size > 0) {%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고이력 (최근 최대5건)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
            	<tr> 
                	<td width='5%' class='title'>연번</td>
                        <td width='10%' class='title'>사고구분</td>
                        <td width='15%' class='title'>사고일시</td>
                        <td width='15%' class='title'>상호</td>                        
                        <td width='10%' class='title'>보험접수번호</td>
                        <td width='15%' class='title'>사고장소</td>
                        <td width='15%' class='title'>사고내용</td>
                        <td width='6%' class='title'>접수자</td>
                        <td width='9%' class='title'>접수일자</td>
                </tr>
                <tr> 
          <%		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                          <tr> 
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><a name="<%=i+1%>"><%=i+1%> 
                              <%if(accid.get("USE_YN").equals("Y")){%>
                              <%}else{%>
                              (해약) 
                              <%}%>
                            </a></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=accid.get("ACCID_ST_NM")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>                            
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'> 
                              <%if(accid.get("FIRM_NM").equals("(주)아마존카") && !accid.get("CUST_NM").equals("")){%>
                              <span title='(<%=accid.get("RES_ST")%>)<%=accid.get("CUST_NM")%>'>(<%=accid.get("RES_ST")%>)<%=Util.subData(String.valueOf(accid.get("CUST_NM")), 6)%></span>	
                              <%}else{%>
                              <span title='<%=accid.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(accid.get("FIRM_NM")), 11)%></span> 
                              <%}%>
                            </td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align="center"><%=accid.get("OUR_NUM")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> >&nbsp;<span title='<%=accid.get("ACCID_ADDR")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_ADDR")), 11)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> >&nbsp;<span title='<%=accid.get("ACCID_CONT")%> <%=accid.get("ACCID_CONT2")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_CONT"))+" "+String.valueOf(accid.get("ACCID_CONT2")), 11)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(accid.get("REG_DT")))%></td>
                          </tr>
          <%		}%>

                </tr>
            </table>
        </td>
    </tr>
<%	}%>	
 	<tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고접수</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>접수일자</td>
                    <td width=30%>
                      <input type="text" name="reg_dt" value="<%=AddUtil.getDate()%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=9%>접수자</td>
                    <td colspan=2 width=52%> 
                      <select name='reg_id'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title width=9%>사고구분</td>
                    <td colspan="3" >
                      <input type="checkbox" name="dam_type1" value="Y"  <%if(s_gubun1.equals("2") || s_gubun1.equals("3"))%>checked<%%>>
                      대인 
                      <input type="checkbox" name="dam_type2" value="Y"  <%if(s_gubun1.equals("2") || s_gubun1.equals("3"))%>checked<%%>>
                      대물 
                      <input type="checkbox" name="dam_type3" value="Y"  <%if(!s_gubun1.equals("3"))%>checked<%%>>
                      자손 
                      <input type="checkbox" name="dam_type4" value="Y"  <%if(!s_gubun1.equals("3"))%>checked<%%>>
                      자차</td>
                </tr>               
                <tr> 
                    <td class=title>특이사항</td>
                    <td colspan="3">
                      <textarea name="sub_etc" cols="120" class="text" rows="3"></textarea>
                    </td>                                   
                </tr>
            </table>
        </td>
    </tr>
    
    <tr>
        <td class=h></td>
    </tr>
	<%if(!s_gubun1.equals("4")){%>
    <tr id=tr1 style="display:<%if(s_gubun1.equals("4")){%>none<%}else{%>''<%}%>"> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고개요</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                              <td class=title colspan="2">사고형태</td>
                              <td width=30%>
                                <select name='accid_type'>
                                  <option value="">선택</option>
                                  <option value="1">차대차</option>
                                  <option value="2">차대사람</option>
                                  <option value="3">차량단독</option>
                                  <option value="4">차대열차</option>
                                </select>
                              </td>
                              <td class=title width=9%>사고일시</td>
                              <td width="52%"> 
                                <input type="text" name="accid_dt" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                <input type="text" name="accid_dt_h" size="2" class=text maxlength="2">
                                시 
                                <input type="text" name="accid_dt_m" size="2" class=text maxlength="2">
                                분 <font color="#808080">(시간:0-23)</font> </td>
                            </tr>
                            <tr> 
                              <td class=title colspan="2">사고장소</td>
                              <td colspan="3">
                                <select name='accid_type_sub'>
                                  <option value="">선택</option>
                                  <option value="1">단일로</option>
                                  <option value="2">교차로</option>
                                  <option value="3">철길건널목</option>
                                  <option value="4">커브길</option>
                                  <option value="5">경사로</option>
                                  <option value="6">주차장</option>
                                  <option value="7">골목길</option>
                                  <option value="8">기타</option>
                                </select>
                                <input type="text" name="accid_addr" class=text size="110">
                              </td>
                            </tr>
                            <tr> 
                              <td class=title width=3% rowspan="2">사고경위</td>
                              <td class=title width=6% height="76">왜?</td>
                              <td colspan="3" height="76"> 
                                <textarea name="accid_cont" cols="120" rows="3"></textarea>
                              </td>
                            </tr>
                            <tr> 
                              <td class=title>어떻게?</td>
                              <td colspan="3"> 
                                <textarea name="accid_cont2" cols="120" rows="4"></textarea>
                              </td>
                            </tr>
                            <tr> 
                              <td class=title colspan="2">과실비율</td>
                              <td>당사 
                                <input type="text" name="our_fault_per" size="4" value="<%=our_p%>" class=num onBlur='javascript:document.form1.ot_fault_per.value=Math.abs(toInt(this.value)-100);'>
                                : 
                                <input type="text" name="ot_fault_per" size="4" value="<%=ot_p%>" class=num onBlur='javascript:document.form1.our_fault_per.value=Math.abs(toInt(this.value)-100);'>
                                상대방 </td>
                              <td class=title>중대과실여부</td>
                              <td> 
                                <select name="imp_fault_st">
                                  <option value="">없음</option>
                                  <option value="1">음주</option>
                                  <option value="2">신호위반</option>
                                  <option value="3">속도위반</option>
                                  <option value="4">횡단보도</option>
                                  <option value="5">중앙선침범</option>
                                  <option value="6">사고후도주</option>
                                  <option value="7">앞지르기위반</option>
                                  <option value="8">철길</option>
                                  <option value="9">인도</option>
                                  <option value="10">기타</option>
                                </select>
                                <input type="text" name="imp_fault_sub" size="30" class=text>
                              </td>
                            </tr>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고 당시</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>속도</td>
                    <td width=30%> 
                      <input type="text" name="speed" value="" size="4" class=num>
                      km/h </td>
                    <td class=title width=9%>기상조건</td>
                    <td width=52%> 
                      <input type="radio" name="weather" value="1" checked>
                      맑음 
                      <input type="radio" name="weather" value="2">
                      흐림 
                      <input type="radio" name="weather" value="3">
                      비 
                      <input type="radio" name="weather" value="4">
                      안개 
                      <input type="radio" name="weather" value="5">
                      눈</td>
                </tr>
                <tr> 
                    <td class=title>도로조건</td>
                    <td> 
                      <input type="radio" name="road_stat" value="1" checked>
                      포장 
                      <input type="radio" name="road_stat" value="2">
                      비포장</td>
                    <td class=title>도로면상태</td>
                    <td> 
                      <input type="radio" name="road_stat2" value="1" checked>
                      건조 
                      <input type="radio" name="road_stat2" value="2">
                      습기 
                      <input type="radio" name="road_stat2" value="3">
                      빙설 
                      <input type="radio" name="road_stat2" value="4">
                      기타</td>
                </tr>
            </table>
        </td>
    </tr>		
	<%}else{%>	
    <tr> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고개요</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                              <td class=title width=9%>사고형태</td>
                              <td width=30%> 
                                <select name='accid_type'>
                                  <option value="">선택</option>
                                  <option value="1">차대차</option>
                                  <option value="2">차대사람</option>
                                  <option value="3" selected>차량단독</option>
                                  <option value="4">차대열차</option>
                                </select>
                              </td>
                              <td class=title width=9%>사고일시</td>
                              <td width=52%> 
                                <input type="text" name="accid_dt" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                                <input type="text" name="accid_dt_h" size="2" class=text  maxlength="2">
                                시 
                                <input type="text" name="accid_dt_m" size="2" class=text  maxlength="2">
                                분 <font color="#808080">(시간:0-23)</font> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고 당시</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
              <tr> 
                <td class=title width=9%>속도</td>
                <td width=30%> 
                  <input type="text" name="speed" value="" size="4" class=num >
                  km/h </td>
                <td class=title width="80">기상조건</td>
                <td width="450"> 
                  <input type="radio" name="weather" value="1" checked>
                  맑음 
                  <input type="radio" name="weather" value="2">
                  흐림 
                  <input type="radio" name="weather" value="3">
                  비 
                  <input type="radio" name="weather" value="4">
                  안개 
                  <input type="radio" name="weather" value="5">
                  눈</td>
              </tr>
              <tr> 
                <td class=title width=9%>도로조건</td>
                <td width=52%> 
                  <input type="radio" name="road_stat" value="1" checked>
                  포장 
                  <input type="radio" name="road_stat" value="2">
                  비포장</td>
                <td class=title width="70">도로면상태</td>
                <td> 
                  <input type="radio" name="road_stat2" value="1" checked>
                  건조 
                  <input type="radio" name="road_stat2" value="2">
                  습기 
                  <input type="radio" name="road_stat2" value="3">
                  빙설 
                  <input type="radio" name="road_stat2" value="4">
                  기타</td>
              </tr>
            </table>
        </td>
    </tr>			
	<%}%>		
    <tr> 
        <td align="right">
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
        <%}%>	  
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
