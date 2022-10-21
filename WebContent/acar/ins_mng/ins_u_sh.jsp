<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.accid.*, acar.insur.*, acar.cont.*, acar.tint.*, acar.offls_pre.*, acar.estimate_mng.*"%>

<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"ins_s_frame.jsp":request.getParameter("go_url");
	if(go_url.equals(""))	go_url = "ins_s_frame.jsp";
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//보험관리번호
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode = "0";
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String update_yn = request.getParameter("update_yn")==null?"":request.getParameter("update_yn");
	
	if(gubun.equals("cls"))	go_url = "../con_ins/ins_cls_frame.jsp";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	if(!c_id.equals("") && m_id.equals("") && l_cd.equals("")){
		RentListBean bean = ai_db.getLongRentCase(c_id);
		m_id = bean.getRent_mng_id();
		l_cd = bean.getRent_l_cd();
	}
	
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	InsurBean ins = ai_db.getInsCase(c_id, ins_st);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;
	
	
	//차량정보
	Off_ls_pre_apprsl apprsl_bean = rs_db.getCarBinImg2(c_id);
	
	
	//변수
	String var1 = e_db.getEstiSikVarCase("1", "", "ins_modify_dt");
	String var2 = e_db.getEstiSikVarCase("1", "", "ins_modify_mon");
		
	if(update_yn.equals("")){
	
		String modify_deadline = c_db.addMonth(ins.getIns_exp_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) == 20220325) modify_deadline = "20220425";
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) < AddUtil.parseInt(AddUtil.getDate(4))){
			update_yn = "N";
		}
		
	}
	
		
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//수정하기	
	function view(rent_mng_id, rent_l_cd, car_mng_id, ins_st ){
		var url = 'ins_u_sh_print.jsp?rent_l_cd='+rent_l_cd+'&rent_mng_id='+rent_mng_id+'&car_mng_id='+car_mng_id+'&ins_st='+ins_st;
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
	}
	//수정하기	
	function save(){
		var fm = document.form1;
		if(!confirm('수정하시겠습니까?')){	return;	}		
		fm.target = 'i_no';
		fm.action = 'ins_u_a.jsp';
		fm.submit();
	}
	
	//하단메뉴 이동
	function sub_in(idx){
		var fm = document.form1;
		fm.target = 'c_foot';
		fm.action = "ins_u_in"+idx+".jsp";
		fm.submit();
	}	
	
	//목록가기
	function list(){
		var fm = document.form1;
		fm.target = 'd_content';
		<%if(go_url.equals("/acar/con_ins/ins_frame_s.jsp")){%>		
		fm.mode.value = '';
		fm.action = '<%=go_url%>';
		<%}else{%>
		fm.action = '<%=go_url%>';		
		<%}%>
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
	function view_lcrent_car()
	{
		window.open("/fms2/lc_rent/lc_c_c_car.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&mode=view", "VIEW_LC_RENT_CAR", "left=120, top=120, width=850, height=600, scrollbars=yes");
	}		
	
	function search_car()
	{
//		window.open("ins_sm_frame.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&cmd=ud", "VIEW_CAR", "left=20, top=20, width=850, height=600, scrollbars=no");
		window.open("about:blank", "SEARCH_CAR", "left=100, top=200, width=850, height=600, scrollbars=no");
		var fm = document.form1;
//		fm.cmd.value = "ud";
		fm.target = 'SEARCH_CAR';
		fm.action = "ins_sm_frame.jsp";
		fm.submit();
	}	
	
	//갱신
	function move_reg(){	
		var fm = document.form1;	
		fm.action = "../ins_reg/ins_reg_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}			
	//해지
	function move_cls(){	
		var fm = document.form1;	
		fm.action = "../ins_cls/ins_cls_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}		
	
	//삭제하기
	function del_insur(){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){	return;	}		
		if(!confirm('정말 삭제하시겠습니까?')){	return;	}		
		if(!confirm('진짜로 삭제하시겠습니까?')){	return;	}				
		fm.target = 'i_no';
//		fm.target = '_blank';		
		fm.action = 'ins_d_a.jsp';
		fm.submit();
	}	
	
	//해지취소
	function InsClsCancel(){
		var fm = document.form1;
		if(!confirm('해지취소하시겠습니까? 보험부활합니다.')){	return;	}		
		//fm.target = 'i_no';
		fm.target = '_blank';		
		fm.action = 'ins_cls_cancel.jsp';
		fm.submit();		
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL;
		window.open(theURL,winName,features);
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow2(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr"+theURL;
		window.open(theURL,winName,features);
	}		
	
	
	//블랙박스사진메일보내기
	function sendEmail_blackbox(blackbox_img, blackbox_img2, car_img1, car_img2){
		var fm = document.form1;
		fm.blackbox_img.value = blackbox_img;
		fm.blackbox_img2.value = blackbox_img2;
		fm.car_img1.value = car_img1;
		fm.car_img2.value = car_img2;
		window.open("about:blank", "ScdDocEmail", "left=50, top=50, width=700, height=450, scrollbars=yes");				
		fm.action = "ins_email_reg.jsp";
		fm.target = "ScdDocEmail";
		fm.submit();
		
		fm.blackbox_img.value = '';
		fm.blackbox_img2.value = '';
		fm.car_img1.value = '';
		fm.car_img2.value = '';
	}		
	//만나이계산하기
	function age_search()
	{
		var fm = document.form1;
		
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}	
	
	function openP(){
		window.open("/fms2/ins_com/view_scan.jsp?car_no=<%=cont.get("CAR_NO")%>&ins_con_no=<%=ins.getIns_con_no()%>", "VIEW_SCAN", "left=100, top=100, width=720, height=350, scrollbars=yes");		
	}
	
	function view_res(c_id){
		
        if ( c_id == '' ) {  alert("등록된 차량이 없습니다.") ;
        } else {
		var fm = document.form1;
		var SUBWIN="/fms2/lc_rent/view_res.jsp?c_id="+c_id+"&auth_rw="+fm.auth_rw.value;	
		window.open(SUBWIN, "VIEW_RES", "left=50, top=50, width=1050, height=600, scrollbars=yes, status=yes");
	}
}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='ins_u_a.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type="hidden" name="idx" value="<%=idx%>">
<input type="hidden" name="s_st" value="<%=s_st%>">
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="ins_st" value='<%=ins_st%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
<input type='hidden' name="cmd" value='<%=cmd%>'>
<input type='hidden' name="car_st" value='<%=cont.get("CAR_ST")%>'>
<input type='hidden' name="client_id" value='<%=cont.get("CLIENT_ID")%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='blackbox_img' value=''>
<input type='hidden' name='blackbox_img2' value=''>
<input type='hidden' name='car_img1' value=''>
<input type='hidden' name='car_img2' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > 환급보험료 > <span class=style5>보험상세내역</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=13%>&nbsp;<a href="javascript:view_lcrent_car()" title='<%=c_id%> <%=ins_st%>'><%=l_cd%></a></td>
                    <td class=title width=10%>상호</td>
                    <td width=21%>&nbsp;<a href="javascript:view_client()"><%=cont.get("FIRM_NM")%></a> &nbsp; <a href="javascript:view_res('<%=c_id%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a></td>
                    <td class=title width=10%>계약자</td>
                    <td width=12%>&nbsp;<%=cont.get("CLIENT_NM")%></td>
                    <td class=title width=10%>사용본거지</td>
                    <td width=14%>&nbsp;<%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title><a href="javascript:search_car()" title='<%=c_id%> <%=ins_st%>'>차량번호</a></td>
                    <td>&nbsp;<a href="javascript:view_car()" title='<%=c_id%> <%=ins_st%>'><%=cont.get("CAR_NO")%></a></td>
                    <td class=title>차명</td>
                    <td><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td><%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td></tr></table></td>
                    <td class=title>최초등록일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>차대번호</td>
                    <td>&nbsp;<%=cont.get("CAR_NUM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험계약</span> <font color="#999999">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_ccdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(ins.getReg_dt())%>, 
        <img src=../images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(ins.getReg_id(), "USER")%>, <img src=../images/center/arrow_cjdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(ins.getUpdate_dt())%>, 
        <img src=../images/center/arrow_cjdrj.gif align=absmiddle> : <%=c_db.getNameById(ins.getUpdate_id(), "USER")%>)</font></td>
        <td align="right"> 
        <%if(!cmd.equals("view")){%>
    	    <a href='javascript:view("<%=m_id%>","<%=l_cd%>","<%=cont.get("CAR_MNG_ID")%>","<%=ins.getIns_st()%>")'><img src=../images/center/button_gh2.png align=absmiddle border=0></a> 
	        <%	if(!update_yn.equals("N") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
    	     &nbsp;<a href='javascript:save()'><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
    	   	<%	}%>
			    <%if(!go_url.equals("car_register")){%>		
	        &nbsp;<a href='javascript:list()'><img src=../images/center/button_list.gif align=absmiddle border=0></a> 
    	    <%}%>	
        	<!--<a href="javascript:history.go(-1);" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/reload.gif" width="50" height="18" aligh="absmiddle" border="0"></a>-->
        <%}%>
        </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>등록구분</td>
                    <td width=13%>
                      &nbsp;<%if(ins.getIns_st().equals("0")){%>신규
                      <%}else{%>갱신(<%=ins.getIns_st()%>)<%}%></td>
                    <td class=title width=10%>등록사유</td>
                    <td width=21%>
                      &nbsp;<select name='reg_cau'>
                        <option value=''>===신규===</option>
                        <option value='1' <%if(ins.getReg_cau().equals("1")){%>selected<%}%>>1. 신차</option>
                        <option value='2' <%if(ins.getReg_cau().equals("2")){%>selected<%}%>>2. 용도변경</option>
                        <option value='5' <%if(ins.getReg_cau().equals("5")){%>selected<%}%>>3. 오프리스</option>				
                        <option value=''>===갱신===</option>				
                        <option value='3' <%if(ins.getReg_cau().equals("3")){%>selected<%}%>>1. 담보변경</option>
                        <option value='4' <%if(ins.getReg_cau().equals("4")){%>selected<%}%>>2. 만기</option>				
                      </select></td>
                    <td class=title width=10%>담보구분</td>
                    <td width=12%>
                      &nbsp;<select name='ins_kd'>
                        <option value='1' <%if(ins.getIns_kd().equals("1")){%>selected<%}%>>전담보</option>
                        <option value='2' <%if(ins.getIns_kd().equals("2")){%>selected<%}%>>책임보험</option>
                      </select></td>
                    <td class=title width=10%>보험상태</td>
                    <td width=14%>
                    <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){ %>
                      &nbsp;<select name='ins_sts'>
                        <option value='1' <%if(ins.getIns_sts().equals("1")){%>selected<%}%>>유효</option>
                        <option value='2' <%if(ins.getIns_sts().equals("2")){%>selected<%}%>>만료</option>
                        <option value='3' <%if(ins.getIns_sts().equals("3")){%>selected<%}%>>중도해지</option>
                        <option value='5' <%if(ins.getIns_sts().equals("5")){%>selected<%}%>>승계</option>				
                      </select>
                      <%}else{ %>
                      	 &nbsp;
                      	 <input type="hidden" name="ins_sts" value="<%=ins.getIns_sts()%>">
                      	<%if(ins.getIns_sts().equals("1")){%>유효
                      	<%}else if(ins.getIns_sts().equals("2")){%>만료
                      	<%}else if(ins.getIns_sts().equals("3")){%>중도해지
                      	<%}else if(ins.getIns_sts().equals("5")){%>승계
                      	<%} %>
                      <%} %>
                    </td>
                </tr>
                <tr> 
                    <td class=title>보험회사</td>
                    <td> 
                      <select name='ins_com_id'>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ins.getIns_com_id().equals(ic.getIns_com_id())){%>selected<%}%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                    <td class=title>계약번호</td>
                    <td> 
                      &nbsp;<input type='text' name='ins_con_no' size='25' value='<%=ins.getIns_con_no()%>' class='text'>
                    </td>
                    <td class=title>계약자</td>
                    <td> 
                      &nbsp;<input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='10' class='text'>
                    </td>
                    <td class=title>피보험자</td>
                    <td> 
                      &nbsp;<input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='10' class='text'>
                    </td>
                </tr>
                <tr> 
                    <td class=title>보험기간</td>
                    <td colspan="3"> 
                      &nbsp;<input type="text" name="ins_start_dt" value="<%=AddUtil.ChangeDate2(ins.getIns_start_dt())%>" size="11" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;24시&nbsp;&nbsp;~ &nbsp;&nbsp; 
                      <input type="text" name="ins_exp_dt" value="<%=AddUtil.ChangeDate2(ins.getIns_exp_dt())%>" size="11" class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                      &nbsp;24시 </td>
                    <td class=title>보험종류</td>
                    <td> 
                      &nbsp;
                      <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
                      <select name='car_use'>
                        <option value='1' <%if(ins.getCar_use().equals("1")){%>selected<%}%>>영업용</option>
                        <option value='2' <%if(ins.getCar_use().equals("2")){%>selected<%}%>>업무용</option>
						            <option value='3' <%if(ins.getCar_use().equals("3")){%>selected<%}%>>개인용</option>
                      </select>
                      <%}else{%>
                      <%if(ins.getCar_use().equals("1")){%>영업용<%}%>
                      <%if(ins.getCar_use().equals("2")){%>업무용<%}%>
                      <%if(ins.getCar_use().equals("3")){%>개인용<%}%>
                      <input type='hidden' name='car_use' 	value='<%=ins.getCar_use()%>'>
                      <%}%>
                    </td>
                    <td class=title>연령범위</td>
                    <td> 
                      &nbsp;<select name='age_scp'>
                        <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>만21세이상 
                        </option>
                        <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>만24세이상 
                        </option>
                        <option value='2' <%if(ins.getAge_scp().equals("2") || ins.getAge_scp().equals("") ){%>selected<%}%>>만26세이상 
                        </option>
                        <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>전연령 
                        </option>
                        <option value=''>=피보험자고객=</option>				
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>만30세이상</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>만35세이상</option>				
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>만43세이상</option>
                        <option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>만48세이상</option>												
                        <option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>만22세이상</option>												
                        <option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>만28세이상</option>												
                        <option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>만35세상~만49세이하</option>												
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
                    </td>
                </tr>
                <tr> 
                    <td class=title>에어백</td>
                  <td colspan="3">&nbsp; 
                      <input type='checkbox' name='air_ds_yn'   value='Y' <%if(ins.getAir_ds_yn().equals("Y")){%>checked<%}%>>
                      운전석 
                      <input type='checkbox' name='air_as_yn'   value='Y' <%if(ins.getAir_as_yn().equals("Y")){%>checked<%}%>>
                      조수석
                      <input type="checkbox" name="auto_yn" 	value="Y" <%if(ins.getAuto_yn().equals("Y")){%>checked<%}%> >
                      자동변속기
                      <input type="checkbox" name="abs_yn" 	value="Y" <%if(ins.getAbs_yn().equals("Y")){%>checked<%}%> >
                      ABS장치


                    </td>
                    <td class='title'>가입경력율</td>
                    <td> 
                      &nbsp;<input type='text' name='car_rate' size='5' maxlength='30' value='<%=ins.getCar_rate()%>' class='text'>
                      % </td>
                    <td class='title'>할인할증율</td>
                    <td> 
                      &nbsp;<input type='text' name='ext_rate' size='5' maxlength='30' value='<%=ins.getExt_rate()%>' class='text'>
                      % </td>
                </tr>
                <tr> 
                    <td class=title>임직원한정특약</td>
                  <td colspan="10">&nbsp; 
                      <b>가입여부</b>
                      <select name='com_emp_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                      &nbsp; 임직원임차인
                      <input type="text" class="text" name="firm_emp_nm" value="<%=ins.getFirm_emp_nm()%>" size="30">
                       &nbsp; 장기구분 
                      <select name='long_emp_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getLong_emp_yn().equals("Y")){%> selected <%}%>>장기</option>
                          <option value="N" <%if(ins.getLong_emp_yn().equals("N")){%> selected <%}%>>단기</option>
                      </select>
                    
	                  <% 	
                   		if(ins.getLkas_yn().equals(""))	ins.setLkas_yn(cont_etc.getLkas_yn()); 
                   		if(ins.getLdws_yn().equals(""))	ins.setLdws_yn(cont_etc.getLdws_yn()); 
                   		if(ins.getAeb_yn().equals(""))	ins.setAeb_yn(cont_etc.getAeb_yn()); 
                   		if(ins.getFcw_yn().equals(""))	ins.setFcw_yn(cont_etc.getFcw_yn()); 
                   		if(ins.getEv_yn().equals(""))	ins.setEv_yn(cont_etc.getEv_yn()); 
                   		/* if(ins.getOthers().equals(""))	ins.setOthers(HtmlUtil.htmlBR(base.getOthers()));  */
                   		
	                  %>
                    
                    
                       &nbsp; 사업자번호
                      <input type="text" class="text" name="enp_no" value="<%=ins.getEnp_no()%>" size="15">
                       &nbsp; 기타장치
                      <input type="text" class="text" name="others_device" value="<%=ins.getOthers_device()%>" size="15">
                      
                      <br/>
                      
                      &nbsp; 차선이탈(제어형)
                      <select name='lkas_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getLkas_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getLkas_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; 차선이탈(경고형)
                      <select name='ldws_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getLdws_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getLdws_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; 긴급제동(제어형) 
                      <select name='aeb_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getAeb_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getAeb_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; 긴급제동(경고형) 
                      <select name='fcw_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getFcw_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getFcw_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; 전기자동차 
                      <select name='ev_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getEv_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getEv_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp;&nbsp;&nbsp;&nbsp; 견인고리 
                      <select name='hook_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getHook_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getHook_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                      &nbsp;&nbsp;&nbsp;&nbsp; 법률비용지원금(고급형) 
                      <select name='legal_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getLegal_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getLegal_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>블랙박스특약</td>
                  <td colspan="10">&nbsp; 
                      <b>가입여부</b>
                      <select name='blackbox_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getBlackbox_yn().equals("Y")){%>selected<%}%>>가입</option>
                          <option value="N" <%if(ins.getBlackbox_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
                       &nbsp; 모델명
                      <input type="text" class="text" name="blackbox_nm" value="<%=ins.getBlackbox_nm()%>" size="30">
                       &nbsp; 시리얼번호
                      <input type="text" class="text" name="blackbox_no" value="<%=ins.getBlackbox_no()%>" size="20">
                       &nbsp; 구입가(공급가)
                      <input type="text" class="num" name="blackbox_amt" value="<%=AddUtil.parseDecimal(ins.getBlackbox_amt())%>" size="8">원
                       &nbsp; 설치일자
                      <input type="text" class="text" name="blackbox_dt" value="<%=ins.getBlackbox_dt()%>" size="12">
                      
                      <%	Hashtable tint = t_db.getInsurBlackboxImgs(ins.getCar_mng_id());   
                      		if(!String.valueOf(tint.get("BLACKBOX_IMG")).equals("") && !String.valueOf(tint.get("BLACKBOX_IMG")).equals("null")){                   		
                      			if(!String.valueOf(tint.get("BLACKBOX_IMG")).equals("")){                   		
                      %>
                          &nbsp;앞:<a href="javascript:MM_openBrWindow('blackbox/<%= tint.get("BLACKBOX_IMG") %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>
                      <%		}
                      			if(!String.valueOf(tint.get("BLACKBOX_IMG2")).equals("")){                   		
                      %>    
                          &nbsp;실내:<a href="javascript:MM_openBrWindow('blackbox/<%= tint.get("BLACKBOX_IMG2") %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>
                      <%		}
                      %>
                      <%		if(!String.valueOf(tint.get("BLACKBOX_IMG")).equals("") && !String.valueOf(tint.get("BLACKBOX_IMG2")).equals("")){%>                        
                          &nbsp;<a href="javascript:sendEmail_blackbox('<%=tint.get("BLACKBOX_IMG")%>', '<%=tint.get("BLACKBOX_IMG2")%>','','')"><img src=/acar/images/center/button_in_email.gif  align=absmiddle border="0"></a>                        
                      <%		}%>
                      <%	}else{%>
                      <%		if(!apprsl_bean.getImgfile5().equals("")){%>
                          &nbsp;앞:<a href="javascript:MM_openBrWindow2('/images/carImg/<%= apprsl_bean.getImgfile5() %>.gif','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>                      
                      <%		}%>
                      <%		if(!apprsl_bean.getImgfile2().equals("")){%>
                          &nbsp;실내:<a href="javascript:MM_openBrWindow2('/images/carImg/<%= apprsl_bean.getImgfile2() %>.gif','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>                      
                      <%		}%>
                      <%		if(!apprsl_bean.getImgfile2().equals("") && !apprsl_bean.getImgfile5().equals("")){%>                        
                          &nbsp;<a href="javascript:sendEmail_blackbox('','','<%=apprsl_bean.getImgfile5()%>.gif', '<%=apprsl_bean.getImgfile2()%>.gif')"><img src=/acar/images/center/button_in_email.gif  align=absmiddle border="0"></a>                        
                      <%		}%>
                      <%	}%>
                                            
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2" class=h></td>
    </tr>
    <tr align="center"> 
        <td colspan="2"> 
            <a href="javascript:sub_in(1)"><img src=../images/center/button_ins_cy.gif align=absmiddle border=0></a>
    		<%//if(ins.getIns_kd().equals("1")){%> 
    	    &nbsp;<a href="javascript:sub_in(2)"><img src=../images/center/button_ins_bg.gif align=absmiddle border=0></a>
    		<%//}%>
            &nbsp;<a href="javascript:sub_in(3)"><img src=../images/center/button_ins_sch.gif align=absmiddle border=0></a> 
            &nbsp;<a href="javascript:sub_in(7)"><img src=../images/center/button_ins_ggby.gif align=absmiddle border=0></a> 		
    		&nbsp;<a href="javascript:sub_in(4)"><img src=../images/center/button_ins_hj.gif align=absmiddle border=0></a> 
            &nbsp;<a href="javascript:sub_in(5)"><img src=../images/center/button_ins_ir.gif align=absmiddle border=0></a> 
    		&nbsp;<a href="javascript:sub_in(6)"><img src=../images/center/button_ins_acc.gif align=absmiddle border=0></a> 

			<%if(!update_yn.equals("N") && !cmd.equals("view")){%>
            &nbsp;&nbsp;&nbsp;<a href="javascript:move_reg()"><img src=../images/center/button_ins_gs.gif align=absmiddle border=0></a> 
    		<%	if(ins.getIns_sts().equals("1")){%>
            &nbsp;&nbsp;&nbsp;<a href="javascript:move_cls()"><img src=../images/center/button_ins_hji.gif align=absmiddle border=0></a> 		
    		<%	}%>
    		
    		&nbsp;&nbsp;&nbsp;<a href="javascript:openP();" class="btn" title='스캔관리'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>&nbsp;
    		
			<%	if(nm_db.getWorkAuthUser("전산팀",user_id) || user_id.equals("000130")){%>
			&nbsp;&nbsp;<a href='javascript:del_insur()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_delete.gif"  align="absmiddle" border="0"></a>
			<%	}%>
			
			<%	if(nm_db.getWorkAuthUser("전산팀",user_id) || user_id.equals("000130")){%>
			<%		if(ins.getIns_sts().equals("3")){%>
			&nbsp;&nbsp;<input type="button" class="button" value="중도해지취소" onclick="javascript:InsClsCancel();">
			<%		}%>
			<%	}%>
			
			<%}%>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
<script language='javascript'>
<!--
<%if(!cmd.equals("view")){%>
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
	s_fm.accid_id.value = "";
	s_fm.serv_id.value = "";
	s_fm.seq_no.value = "";
<%}%>	
//-->
</script>  
</body>
</html>

