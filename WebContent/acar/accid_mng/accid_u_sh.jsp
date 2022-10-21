<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.accid.*, acar.insur.*, acar.res_search.*, acar.doc_settle.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//보험정보
	String ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id);
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP", ""); 
	int user_size = users.size();
	
	String car_st = String.valueOf(cont.get("CAR_NO"));
	if(car_st.length()>5 && !car_st.equals(""))	car_st = car_st.substring(4,5);	
	
	String accid_dt = a_bean.getAccid_dt();
	String accid_dt_h = "";
	String accid_dt_m = "";
	if(!accid_dt.equals("")){
		accid_dt = a_bean.getAccid_dt().substring(0,8);
		accid_dt_h = a_bean.getAccid_dt().substring(8,10);
		accid_dt_m = a_bean.getAccid_dt().substring(10,12);
	}
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleCommi("45", c_id+""+accid_id);
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
		window.open("../accid_reg/search_res.jsp?c_id="+fm.c_id.value, "SEARCH_RES", "left=100, top=100, width=700, height=500, scrollbars=yes");		
	}
		
	//수정하기	
	function save(){
		var fm = document.form1;
		dt_chk();
		if(fm.reg_dt.value == ''){ alert('접수일자를 입력하십시오.'); return; }		
		if(fm.reg_id.value == ''){ alert('접수자를 선택하십시오.'); return; }	
		if(fm.old_accid_st.value !=  fm.accid_st.value ){ alert('사고유형인 변경되었으니, 과실비율을 다시 확인하세요!!!.');  }	
		
		if(!confirm('수정하시겠습니까?')){	return;	}		
		fm.target = 'i_no';		
		fm.action = 'accid_u_a.jsp';
		fm.submit();
	}

	//삭제하기
	function del_accid(){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){	return;	}		
		if(!confirm('정말 삭제하시겠습니까?')){	return;	}		
		if(!confirm('진짜로 삭제하시겠습니까?')){	return;	}				
		fm.target = 'i_no';
		fm.action = 'accid_d_a.jsp';
		fm.submit();
	}
	
	//보유차 기간과 사고일시 비교
	function dt_chk(){
		var fm = document.form1;	
		if(fm.car_st.value == '2' && fm.sub_rent_gu.value != '99'){
			var st_dt = replaceString("-","",fm.sub_rent_st.value);
			var et_dt = replaceString("-","",fm.sub_rent_et.value);
			var dt = replaceString("-","",fm.accid_dt.value);
			if(st_dt > dt || et_dt < dt){ 
				if(!confirm('보유차 계약기간과 사고일자가 맞지 않습니다.\n\n사고일시를 확인하십시오.\n\n수정하시면 하단의 사고개요의 사고일시도 수정해 주십시오.')){	return;	}	
			}
		}
	}	
		
	//하단메뉴 이동
	function sub_in(idx){
		var fm = document.form1;
		if(idx == 13 && '<%=a_bean.getSettle_st()%>' != '1' && '<%=doc.getDoc_no()%>'=='' ){
			if(!confirm('사고처리결과문서관리로 넘어갑니다. 종결처리 하시겠습니까?')){	return;	}				
			fm.target = 'd_content';
			fm.action = '/fms2/accid_mng/accid_result_c.jsp';
			fm.submit();		
		}else{		
			parent.c_foot.location.href = "accid_u_in"+idx+".jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&mode="+idx;		
		}
	}	
	
	//목록가기
	function list(){
		var fm = document.form1;
		fm.target = 'd_content';
		if(fm.go_url.value == '')	fm.action = 'accid_s_frame.jsp';
		else						fm.action = fm.go_url.value;		
		fm.submit();
	}	

	function view_client()
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=0", "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}	
	function view_car()
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=20, top=20, width=850, height=700, scrollbars=yes");
	}		
	function view_ins()
	{
		window.open("../ins_mng/ins_u_frame.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&ins_st=<%=ins_st%>&cmd=view", "VIEW_INS", "left=20, top=20, width=850, height=650, scrollbars=yes");
	}	
		
	function search_car()
	{
		window.open("accid_sm_frame.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=100, top=200, width=850, height=500, scrollbars=no");
	}
				
	function view_memo()
	{
		var auth_rw = document.form1.auth_rw.value;		
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
	}
	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/view_scan.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}	
	
			
		//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//중고차가
	function sh_car_amt(){
		window.open("/fms2/lc_rent/search_sh_car_amt.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>", "CAR_AMT_S", "left=0, top=0, width=1000, height=550, status=yes, scrollbars=yes");	
	}
					
		
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='accid_u_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>

<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
<input type='hidden' name="cmd" value='<%=cmd%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>  		

<input type='hidden' name="car_st" value='<%=cont.get("CAR_ST")%>'>
<input type='hidden' name="client_id" value='<%=cont.get("CLIENT_ID")%>'>
<input type='hidden' name="h_accid_dt" value=''>
<input type='hidden' name="accid_dt" value='<%=accid_dt%>'>
<input type='hidden' name="old_accid_st" value='<%=a_bean.getAccid_st()%>'>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 사고관리 > <span class=style5>
						사고상세내역</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  
    <tr>
		<td class=line2 colspan="2"></td>
	</tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="9%">계약번호</td>
                    <td width="14%">&nbsp;<%=l_cd%>
                    <!--  해지수리 차량은 원래계약으로 변경권한부여된자에 한해서 -->
                     <% if ( String.valueOf(cont.get("CAR_ST")).equals("2")    &&  ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id))   ) { %>&nbsp;
                                     <a href="javascript:MM_openBrWindow('upd_l_cd.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&car_no=<%=String.valueOf(cont.get("CAR_NO"))%>','popwin','scrollbars=no,status=no,resizable=no,left=100,top=120,width=500,height=200')"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a>
                       <% } %>
                    </td>
                    <td class=title width="9%">상호</td>
                    <td colspan="3">&nbsp;<a href="javascript:view_client()"><%=cont.get("FIRM_NM")%></a><%if(String.valueOf(cont.get("USE_YN")).equals("N")){%>(해지)<%}%></td>
                    <td class=title width="9%">계약자</td>
                    <td width="11%">&nbsp;<span title='<%=cont.get("CLIENT_NM")%>'><%=Util.subData(String.valueOf(cont.get("CLIENT_NM")), 5)%></span></td>
                    <td class=title width="9%">사용본거지</td>
                    <td width="12%">&nbsp;<%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title><a href="javascript:search_car()" title='<%=c_id%> <%=accid_id%>'>차량번호</a></td>
                    <td>&nbsp;<a href="javascript:view_car()"><%=cont.get("CAR_NO")%></a></td>
                    <td class=title>차명</td>
                    <td colspan="3">&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                    <td class=title>차량등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>관리담당자</td>
                    <td>&nbsp;<%=cont.get("USER_NM")%></td>
                </tr>
                <tr> 
                    <td class=title>보험회사</td>
                    <td >&nbsp;<a href="javascript:view_ins()"><%=ins_com_nm%></a>
        			<%if(ins.getVins_spe().equals("애니카")){%>(애니카)<%}%>
        			</td>
                    <td class=title width=9%>대인배상Ⅱ</td>
                    <td>
        			<%if(ins.getVins_pcp_kd().equals("1")){%>&nbsp;무한<%}%>
        			<%if(ins.getVins_pcp_kd().equals("2")){%>&nbsp;유한<%}%>
        			</td>
                    <td class=title width=9%>대물배상</td>
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
                      &nbsp;1500만원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("5")){%>
                      &nbsp;1000만원 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("4")){%>
                      &nbsp;5천만원 
                      <%}%>
                    </td>
                    <td class=title>자기신체</td>
                    <td colspan="3">&nbsp;1인당사망/장애:
                    <%if(ins.getVins_bacdt_kd().equals("1")){%>3억원<%}%>
                    <%if(ins.getVins_bacdt_kd().equals("2")){%>1억5천만원<%}%>
                    <%if(ins.getVins_bacdt_kd().equals("3")){%>3천만원<%}%>
                    <%if(ins.getVins_bacdt_kd().equals("4")){%>1500만원<%}%>
                    <%if(ins.getVins_bacdt_kd().equals("5")){%>5천만원<%}%>								
                    <%if(ins.getVins_bacdt_kd().equals("6")){%>1억원<%}%>											
        			, 1인당부상:
                    <%if(ins.getVins_bacdt_kc2().equals("1")){%>3억원<%}%>
                    <%if(ins.getVins_bacdt_kc2().equals("2")){%>1억5천만원<%}%>
                    <%if(ins.getVins_bacdt_kc2().equals("3")){%>3천만원<%}%>
                    <%if(ins.getVins_bacdt_kc2().equals("4")){%>1500만원<%}%>		
                    <%if(ins.getVins_bacdt_kc2().equals("5")){%>5천만원<%}%>								
                    <%if(ins.getVins_bacdt_kc2().equals("6")){%>1억원<%}%>											
        			</td>
                </tr>
                <tr>
                  <td class=title>피보험자</td>
                  <td>&nbsp;<%if(ins.getCon_f_nm().equals("아마존카")){%><%=ins.getCon_f_nm()%><%}else{%><b><font color='#990000'><%=ins.getCon_f_nm()%></font></b><%}%></td>
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
  가입
  <%}else{%>
  -
  <%}%></td>
                  <td class=title>자기차량손해</td>
                  <td>&nbsp;
                      <%if(ins.getVins_cacdt_cm_amt()>0){%>
					  <b><font color='#990000'>
  가입 ( 차량 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>만원, 자기부담금 <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>만원)
                      </font></b>
					  <%}else{%>
                      -
                      <%}%>
                  </td>
                  <td class=title>자차면책금</td>
                  <td>&nbsp;
                  	<%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>원</td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(String.valueOf(cont.get("CAR_ST")).equals("2")){
			//단기계약정보
			RentContBean rc_bean = rs_db.getRentContCase2(a_bean.getRent_s_cd());
	%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보유차운행</span>
		&nbsp; <a href='/acar/rent_mng/res_rent_p.jsp?s_cd=<%=a_bean.getRent_s_cd()%>&c_id=<%=rc_bean.getCar_mng_id()%>' target="_blank"><img src="/acar/images/center/button_dggy.gif" align="absmiddle" border="0"></a>
		</td>
        <td align="right"> 
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a>&nbsp;
        <%}%>
		<!--<a href="../car_accident/car_accid_all_u.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&accid_st=<%=a_bean.getAccid_st()%>" target=_blank>.</a>-->
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%><a href="javascript:res_search()">대여구분</a></td>
                    <td width=12%> 
                      <%	String sub_rent_gu = "";
        				if(a_bean.getSub_rent_gu().equals("1")) sub_rent_gu="단기대여";
        				if(a_bean.getSub_rent_gu().equals("2")) sub_rent_gu="정비대차";
        				if(a_bean.getSub_rent_gu().equals("3")) sub_rent_gu="사고대차";
        				if(a_bean.getSub_rent_gu().equals("9")) sub_rent_gu="보험대차";
        				if(a_bean.getSub_rent_gu().equals("10")) sub_rent_gu="지연대차";
        				if(a_bean.getSub_rent_gu().equals("4")) sub_rent_gu="업무대여";
        				if(a_bean.getSub_rent_gu().equals("5")) sub_rent_gu="업무지원";
        				if(a_bean.getSub_rent_gu().equals("6")) sub_rent_gu="차량정비";
        				if(a_bean.getSub_rent_gu().equals("7")) sub_rent_gu="차량점검";
        				if(a_bean.getSub_rent_gu().equals("8")) sub_rent_gu="사고수리";
        				if(a_bean.getSub_rent_gu().equals("99")) sub_rent_gu="기타";
        				if(a_bean.getSub_rent_gu().equals("12")) sub_rent_gu="월렌트";
        				%>
                      <input type="text" name="sub_rent_gu_nm" value="<%=sub_rent_gu%>" size="10" class=whitetext>                      
                      <input type='hidden' name="rent_s_cd" value='<%=a_bean.getRent_s_cd()%>'>
                      <input type='hidden' name="sub_rent_gu" value='<%=a_bean.getSub_rent_gu()%>'>
                    </td>
                    <td class=title width=9%>상호</td>
                    <td width=27%> 
                      <input type="text" name="sub_firm_nm" value="<%=a_bean.getSub_firm_nm()%>" size="25" class=whitetext>
                    </td>
                    <td class=title width=9%>계약기간</td>
                    <td width=34%> 
                      <input type="text" name="sub_rent_st" value="<%=AddUtil.ChangeDate2(a_bean.getSub_rent_st())%>" size="11" class=whitetext>
                      ~ 
                      <input type="text" name="sub_rent_et" value="<%=AddUtil.ChangeDate2(a_bean.getSub_rent_et())%>" size="11" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>메모</td>
                    <td colspan="5">
                      &nbsp;<input type="text" name="memo" size="105" class="text" value="<%=a_bean.getMemo()%>">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고접수</span> <font color="#999999">&nbsp;&nbsp;(
        최초등록일:<%=AddUtil.ChangeDate2(a_bean.getReg_dt())%>, 최초등록자:<%=c_db.getNameById(a_bean.getReg_id(), "USER")%>, 최초등록IP:<%=a_bean.getReg_ip()%>, 
        최종등록일:<%=AddUtil.ChangeDate2(a_bean.getUpdate_dt())%>, 최종등록자:<%=c_db.getNameById(a_bean.getUpdate_id(), "USER")%>
        )</font>
	    &nbsp;<a href="javascript:javascript:view_memo()"><img src=/acar/images/center/button_tel.gif align=absmiddle border=0></a>
		  &nbsp;<a href="javascript:view_scan('<%=m_id%>','<%=l_cd%>');" class="btn"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>        				
		  &nbsp;<a href="javascript:sh_car_amt();" class="btn" title='중고차가계산'><img src=/acar/images/center/button_fee_jg.gif align=absmiddle border=0></a>
		</td>
        <td align="right"> 
		<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("사고관리",user_id)){%>
		<a href='javascript:del_accid()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_delete.gif"  align="absmiddle" border="0"></a> 
		<%}%>
        <%//if(!String.valueOf(cont.get("CAR_ST")).equals("2")){%>
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <%if(nm_db.getWorkAuthUser("전산팀",user_id) || !a_bean.getSettle_st().equals("1")  ){%> <!--사고 종결이 아닌 경우 :피해사고인 경우 견적서 없는 경우 확인을 위해  -->      
       	 <a href='javascript:save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
       	 <% } %>
        <%}%>
        <a href='javascript:list()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_list.gif"  align="absmiddle" border="0"></a> 		
        <%//}%>	
		<!--<a href="../car_accident/car_accid_all_u.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&accid_st=<%=a_bean.getAccid_st()%>" target=_blank>.</a>-->
        </td>
    </tr>
    <tr>
		<td class=line2 colspan=2></td>
	</tr> 
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>접수일자</td>
                    <td width=30%> 
                      &nbsp;<input type="text" name="reg_dt" value="<%=AddUtil.ChangeDate2(a_bean.getAcc_dt())%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=9%>접수자</td>
                    <td width=52%> 
                      &nbsp;<select name='reg_id'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(a_bean.getAcc_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>사고유형</td>
                    <td> 
                      &nbsp;<select name='accid_st'>
                        <option value="1" <%if(a_bean.getAccid_st().equals("1"))%>selected<%%>>피해</option>
                        <option value="2" <%if(a_bean.getAccid_st().equals("2"))%>selected<%%>>가해</option>
                        <option value="3" <%if(a_bean.getAccid_st().equals("3"))%>selected<%%>>쌍방</option>
      <!--                  <option value="5" <%if(a_bean.getAccid_st().equals("5"))%>selected<%%>>사고자차</option>
                        <option value="4" <%if(a_bean.getAccid_st().equals("4"))%>selected<%%>>운행자차</option>  
                         <option value="7" <%if(a_bean.getAccid_st().equals("7"))%>selected<%%>>재리스정비</option> -->
                         <option value="8" <%if(a_bean.getAccid_st().equals("8"))%>selected<%%>> 단독</option>
                        <option value="6" <%if(a_bean.getAccid_st().equals("6"))%>selected<%%>>수해</option>		
		  
                      </select>
                    </td>
                    <td class=title>사고구분</td>
                    <td>
                      &nbsp;<input type="checkbox" name="dam_type1" value="Y" <%if(a_bean.getDam_type1().equals("Y"))%>checked<%%>>
                      대인
                      <input type="checkbox" name="dam_type2" value="Y" <%if(a_bean.getDam_type2().equals("Y"))%>checked<%%>>
                      대물
        			  <input type="checkbox" name="dam_type3" value="Y" <%if(a_bean.getDam_type3().equals("Y"))%>checked<%%>>
                      자손
        			  <input type="checkbox" name="dam_type4" value="Y" <%if(a_bean.getDam_type4().equals("Y"))%>checked<%%>>
                      자차</td>
                </tr>
                <tr> 
                    <td class=title>특이사항</td>
                    <td colspan="3">
                      &nbsp;<textarea name="sub_etc" cols="120" class="text" rows="3"><%=a_bean.getSub_etc()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr align="center"> 
        <td colspan="2">
        	<input type="button" class="button btn-submit" value="소송" onclick="javascript:sub_in(14);">&nbsp;
            <input type="button" class="button btn-submit" value="처리진행사항" onclick="javascript:sub_in(13);">&nbsp;
            <input type="button" class="button btn-submit" value="사고개요" onclick="javascript:sub_in(1);">&nbsp;
            <input type="button" class="button btn-submit" value="운전자&보험사" onclick="javascript:sub_in(2);">&nbsp;	    		
	  	<%if(a_bean.getAccid_st().equals("4") || a_bean.getAccid_st().equals("7")){//운행자차,재리스정비%>
	  	 	<input type="button" class="button btn-submit" value="인적사고" onclick="javascript:sub_in(5);">&nbsp;
	  	    <input type="button" class="button btn-submit" value="물적사고" onclick="javascript:sub_in(6);">&nbsp;
	  	    <input type="button" class="button btn-submit" value="면책금" onclick="javascript:sub_in(7);">&nbsp;		  
	  	<%}else if(a_bean.getAccid_st().equals("5") || a_bean.getAccid_st().equals("6")){//사고자차,수해%>
		  	<input type="button" class="button btn-submit" value="인적사고" onclick="javascript:sub_in(5);">&nbsp;
		  	<input type="button" class="button btn-submit" value="물적사고" onclick="javascript:sub_in(6);">&nbsp;
		  	<input type="button" class="button btn-submit" value="면책금" onclick="javascript:sub_in(7);">&nbsp;
		  	<input type="button" class="button btn-submit" value="보험처리결과" onclick="javascript:sub_in(9);">&nbsp;	 
	  	<%}else{%>
	  		<input type="button" class="button btn-submit" value="경찰서" onclick="javascript:sub_in(4);">&nbsp;
	  		<input type="button" class="button btn-submit" value="인적사고" onclick="javascript:sub_in(5);">&nbsp;
	  		<input type="button" class="button btn-submit" value="물적사고" onclick="javascript:sub_in(6);">&nbsp;
	  		<input type="button" class="button btn-submit" value="면책금" onclick="javascript:sub_in(7);">&nbsp;
	  		<input type="button" class="button btn-submit" value="대차료" onclick="javascript:sub_in(8);">&nbsp;
	  		<input type="button" class="button btn-submit" value="보험처리결과" onclick="javascript:sub_in(9);">&nbsp;	  		
	  	<%}%>	  	
		  	<input type="button" class="button btn-submit" value="사고사진" onclick="javascript:sub_in(10);">&nbsp;	  		
		  	<input type="button" class="button btn-submit" value="통화내역" onclick="javascript:sub_in(11);">&nbsp;	  		
		  	<input type="button" class="button btn-submit" value="사고이력" onclick="javascript:sub_in(12);">&nbsp; 
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
<script language='javascript'>
<!--
	var fm = document.form1;

	//바로가기
	var s_fm = parent.parent.top_menu.document.form1;
	s_fm.m_id.value = fm.m_id.value;
	s_fm.l_cd.value = fm.l_cd.value;	
	s_fm.c_id.value = fm.c_id.value;
	s_fm.auth_rw.value = fm.auth_rw.value;
	s_fm.user_id.value = fm.user_id.value;
	s_fm.br_id.value = fm.br_id.value;		
	s_fm.client_id.value = fm.client_id.value;		
	s_fm.accid_id.value = fm.accid_id.value;
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
//-->
</script>  
</body>
</html>
