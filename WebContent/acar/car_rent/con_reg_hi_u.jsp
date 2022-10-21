<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.cont.*,acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//계약조회 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	//메뉴권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//사용자ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");		//소속사ID
	
	//검색구분
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cont_st 	= request.getParameter("cont_st")==null?"":request.getParameter("cont_st");
	String b_lst 	= request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");		//rent_mng_id
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");		//rent_l_cd
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");		//car_mng_id
	String use_yn 	= request.getParameter("use_yn")==null?"":request.getParameter("use_yn");	//계약상태
	String gubun1 	= request.getParameter("gubun1")==null?"20":request.getParameter("gubun1");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "01");
	
	//계약정보
	ContBaseBean base = a_db.getContBaseHi(m_id, l_cd);
	if(c_id.equals(""))	c_id = base.getCar_mng_id();
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
	//휴/대차료 이름
	String h_title = "휴/대차료";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//등록하기
	function save()
	{		
		var fm = document.form1;		
		var t_fm = parent.c_foot.document.form1;
		
		if(fm.s_car_st.value != '2'){//예비용이 아니면
			if     (fm.t_con_cd.value == ''){		alert('계약코드를 입력하십시오');	fm.t_con_cd.focus();	return;	}
			else if(fm.t_rent_dt.value == ''){		alert('계약일자를 없습니다');		fm.t_rent_dt.focus();	return;	}
			else if(fm.s_rent_st.value == ''){		alert('계약구분을 선택하십시오');	fm.s_rent_st.focus();	return;	}			
			else if(fm.s_car_st.value == ''){		alert('대여구분을 선택하십시오');	fm.s_car_st.focus();	return;	}			
			else if(fm.s_bus_st.value == ''){		alert('영업구분을 선택하십시오');	fm.s_bus_st.focus();	return;	}			
			else if(fm.s_bus_id.value == ''){		alert('영업담당자를 선택하십시오');	fm.s_bus_id.focus();	return;	}
			else if(fm.s_rent_way.value == ''){		alert('대여방식을 선택하십시오');	fm.s_rent_way.focus();	return;	}
			else if(fm.t_con_mon.value == ''){		alert('대여개월를 입력하십시오');	fm.t_con_mon.focus();	return;	}									
		}
		
		t_fm.t_con_cd.value 		= fm.t_con_cd.value;
		t_fm.t_rent_dt.value 		= fm.t_rent_dt.value;
		t_fm.s_rent_st.value 		= fm.s_rent_st.value;
		t_fm.s_car_st.value 		= fm.s_car_st.value;
		t_fm.h_brch.value 			= fm.h_brch.value;
		t_fm.s_bus_id.value 		= fm.s_bus_id.value;		
		t_fm.s_dept_id.value 		= fm.s_dept_id.value;		
		t_fm.s_rent_way.value 		= fm.s_rent_way.value;
		t_fm.s_bus_st.value 		= fm.s_bus_st.value;
		t_fm.t_con_mon.value 		= fm.t_con_mon.value;
		t_fm.t_rent_start_dt.value 	= fm.t_rent_start_dt.value;
		t_fm.t_rent_end_dt.value 	= fm.t_rent_end_dt.value;
		t_fm.use_yn.value 			= fm.use_yn.value;
		t_fm.s_bus_id2.value		= fm.s_bus_id2.value;			
		t_fm.s_mng_id.value 		= fm.s_mng_id.value;
		t_fm.s_mng_id2.value 		= fm.s_mng_id2.value;				
	}

	//수정하기
	function update()
	{
		var fm = document.form1;	
		if(fm.use_yn.value == 'N'){	
			alert('계약 변경된 건입니다.\n\n수정할 수 없습니다.');
		}else{
			save();			
			parent.c_foot.save();
		}
	}	

	//목록보기
	function list(b_lst)
	{
		var fm = document.form1;
		var auth = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var brch_id = fm.brch_id.value;
		var s_bank = fm.s_bank.value;
		var t_wd = fm.t_wd.value;		
		var cont_st = fm.cont_st.value;		
		if(b_lst=='cont'){		
			parent.location='con_frame_s.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
		}else{
			parent.location='/acar/condition/rent_cond_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
		}
	}		

	//결재하기
	function sanction()
	{	
		var fm = document.form1;		
		fm.action='sanction.jsp?gubun=sanction_id';
		fm.target='nodisplay';
		fm.submit();
	}	

	//영업담당자 변경이력
	function view_bus_cng(m_id, l_cd){
//		window.open("cng_bus_list.jsp?m_id="+m_id+"&l_cd="+l_cd, "BusCng", "left=100, top=100, width=400, height=400, scrollbars=yes, status=yes");		
		window.open("/fms2/lc_rent/cng_item.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&cng_item=bus_id2&cmd=view", "BusCng", "left=100, top=10, width=750, height=450, scrollbars=yes, status=yes");				
	}
	
	//메일관리 보기
	function view_mail(m_id, l_cd){
		window.open("rent_email_reg.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&brch_id="+document.form1.h_brch.value, "RentDocEmail", "left=100, top=100, width=700, height=500, scrollbars=yes, status=yes");		
	}

	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&brch_id="+document.form1.h_brch.value, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}

	//납품관리 보기
	function view_est(m_id, l_cd){
		window.open("est_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&brch_id="+document.form1.h_brch.value, "VIEW_STAT", "left=100, top=100, width=620, height=400, scrollbars=yes");		
	}
	
	//영업담당자 변경
	function cng_bus(m_id, l_cd){
//		window.open("cng_bus.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&brch_id="+document.form1.h_brch.value, "CNG_BUS", "left=100, top=10, width=400, height=220, scrollbars=yes, status=yes");
		window.open("/fms2/lc_rent/cng_item.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&cng_item=bus_id2", "CNG_BUS", "left=100, top=10, width=750, height=450, scrollbars=yes, status=yes");		
	}
	
	//중도해지정산  보기
	function view_settle(m_id, l_cd){
		window.open("../cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&brch_id="+document.form1.h_brch.value, "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
	}	
	
	//중도해지
	function view_cls()
	{	
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var use_yn = fm.use_yn.value;
		var auth = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var brch_id = fm.brch_id.value;
		var s_bank = fm.s_bank.value;
		var t_wd = fm.t_wd.value;
		var b_lst = fm.b_lst.value;				
		var url = "";
		<%//if(br_id.equals("S1") || br_id.equals(base.getBrch_id())){%>
			if(use_yn == 'Y') 	url = "../cls_con/cls_i_tax.jsp?use_yn="+use_yn+"&m_id="+m_id+"&l_cd="+l_cd+"&auth_rw="+auth+"&s_kd="+s_kd+"&brch_id="+brch_id+"&s_bank="+s_bank+"&t_wd="+t_wd+"&b_lst="+b_lst;
			else				url = "../cls_con/cls_u.jsp?use_yn="+use_yn+"&m_id="+m_id+"&l_cd="+l_cd+"&auth_rw="+auth+"&s_kd="+s_kd+"&brch_id="+brch_id+"&s_bank="+s_bank+"&t_wd="+t_wd+"&b_lst="+b_lst;		
		<%//}else{%>
			//if(use_yn == 'Y'){ 	alert('타영업소의 진행중인 계약을 해지할 수 없습니다.'); return; }
			//else				url = "../cls_con/cls_u.jsp?use_yn="+use_yn+"&m_id="+m_id+"&l_cd="+l_cd+"&auth_rw="+auth+"&s_kd="+s_kd+"&brch_id="+brch_id+"&s_bank="+s_bank+"&t_wd="+t_wd+"&b_lst="+b_lst;				
		<%//}%>		
		window.open(url, "CLS_I", "left=50, top=50, width=840, height=650, status=yes, scrollbars=yes");
	}	

	
	/*기초정보---------------------------------------------------------------------------------------------------------------*/

	//대여방식,계약기간,대여개시일,납입횟수 입력에 따라 대여기간,납입횟수,납입기간이 default 세팅
	function set_cont_date(obj)
	{	
		var fm = document.form1;
		
		if(obj == fm.t_rent_start_dt)
			fm.t_rent_start_dt.value = ChangeDate(fm.t_rent_start_dt.value);

		if((fm.s_rent_way.value == '') || (fm.t_con_mon.value == '') || (fm.t_rent_start_dt.value == ''))
			return;

		fm.action='con_fee_nodisplay.jsp?s_rent_way='+fm.s_rent_way.value+'&t_con_mon='+fm.t_con_mon.value+'&t_rent_start_dt='+fm.t_rent_start_dt.value+'&s_car_st='+fm.s_car_st.value+'&m_id='+fm.m_id.value;
		fm.target='nodisplay';
		fm.submit();
	}	
	
	//대여구분 선택시 계약번호 부분 셋팅
	function set_con_cd(){
		var fm = document.form1;
		var t_fm = parent.c_foot.document.form1;
		var car_st = fm.s_car_st.options[fm.s_car_st.selectedIndex].value;
		if(car_st == '2'){
			alert('예비용으로 변경할 수 없습니다.\n\n해지처리 하십시오.');
			return;
		}else{
			if(car_st == '1') car_st = 'R';
			if(car_st == '3') car_st = 'L';		
			var con_cd = fm.t_con_cd.value;
			fm.t_con_cd.value = con_cd.substring(0,7)+car_st+con_cd.substring(8,13);
			t_fm.s_car_st.value	= fm.s_car_st.value;			
			parent.c_foot.fsam();			
		}		
		set_con_ff();
	}	

	//계약구분 연장재계약시 하단에 연장재계약 입력폼 나타내기
	function change_sub_menu(){
		var fm = document.form1;
		var t_fm = parent.c_foot.document.form1;
		t_fm.s_rent_st.value = fm.s_rent_st.value;				
		parent.c_foot.view_ext();			
	}	

	//대여개월, 대여구분 변경시 아래프레임에 내용 업데이트하기->견적대여료 계산위해
	function set_con_ff(){
		var fm = document.form1;
		var t_fm = parent.c_foot.document.form1;
		t_fm.t_con_mon.value = fm.t_con_mon.value;
		t_fm.s_car_st.value	= fm.s_car_st.value;	
	}	
	
	//새로고침
	function ContHiRelode(){
		var fm = document.form1;
		fm.action = 'con_reg_hi_u.jsp';		
		fm.target = 'c_body';	
		fm.submit();					
	}
//-->
</script>
</head>
<body leftmargin="15">
<form action='con_reg_hi_u_a.jsp' name="form1" method='post'>
<input type='hidden' name='h_pay_tm' value=''>
<input type='hidden' name='h_pay_start_dt' value=''>
<input type='hidden' name='h_pay_end_dt' value=''>
<input type='hidden' name='h_brch' value='<%= base.getBrch_id()%>'>
<input type='hidden' name='use_yn' value='<%=base.getUse_yn()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='cont_st' value='<%=cont_st%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 
<input type='hidden' name="s_dept_id" value=''>
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr> 
      <td colspan="2"> 
        <table width='100%'>
          <tr> 
            <td align='left'><font color="navy">영업지원 -> </font><font color="navy">계약관리</font> 
              -> <font color="red">계약수정</font></td>
            <td align='right'> 
			<%//if(br_id.equals("S1") || br_id.equals(base.getBrch_id())){%>
              <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
              <a href='javascript:update()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
              <%}%>
			<%//}%>
              &nbsp; <a href='javascript:list("<%=b_lst%>")' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
            </td>
          </tr>
        </table>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width="110">계약번호</td>
            <td width="160"> 
              <input type="text" name="t_con_cd" value="<%=base.getRent_l_cd()%>" size="15" class='whitetext' readonly >
            </td>
            <td class=title width="100">계약일자</td>
            <td width="180">&nbsp; 
              <input type="text" name="t_rent_dt" value="<%=base.getRent_dt()%>" size="11" maxlength='11' class=whitetext onBlur='javascript: this.value = ChangeDate(this.value)'>
            </td>
            <td class=title width="100">계약구분</td>
            <td>&nbsp; 
              <select name='s_rent_st' onChange='javascript:change_sub_menu()'>
                <option value='1' <% if(base.getRent_st().equals("1")){%> selected <%}%>>신규</option>
                <option value='3' <% if(base.getRent_st().equals("3")){%> selected <%}%>>대차</option>
                <option value='4' <% if(base.getRent_st().equals("4")){%> selected <%}%>>증차</option>
                <option value='5' <% if(base.getRent_st().equals("5")){%> selected <%}%>>연장(6개월미만)</option>
                <option value='2' <% if(base.getRent_st().equals("2")){%> selected <%}%>>연장(6개월이상)</option>
                <option value='6' <% if(base.getRent_st().equals("6")){%> selected <%}%>>재리스(6개월이상)</option>
                <option value='7' <% if(base.getRent_st().equals("7")){%> selected <%}%>>재리스(6개월미만)</option>				
              </select>
            </td>
          </tr>
          <tr>
            <td align="center" class=title>대여구분</td>
            <td width="160">&nbsp;
              <select name="s_car_st" onChange='javascript:set_con_cd()'>
                <%if(base.getCar_st().equals("1") || base.getCar_st().equals("3")){%>
                <option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>렌트</option>
                <option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>리스</option>
                <%}else if(base.getCar_st().equals("2")){%>
                <option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>보유</option>
                <%}%>
            </select></td>
            <td width="100" align="center" class=title>대여방식</td>
            <td width="180">&nbsp;
              <%if(nm_db.getWorkAuthUser("대여방식변경",user_id)){%>
              <select name="s_rent_way">
                <option value=''  <%if(base.getRent_way().equals("")){%>selected<%}%>>선택</option>
                <option value='1' <%if(base.getRent_way().equals("1")){%>selected<%}%>>일반식</option>
                <option value='2' <%if(base.getRent_way().equals("2")){%>selected<%}%>>맞춤식</option>
                <option value='3' <%if(base.getRent_way().equals("3")){%>selected<%}%>>기본식</option>
              </select>
              <%}else{%>
              <%	if(base.getRent_way().equals("1")){%>
일반식
<%	}else if(base.getRent_way().equals("2")){%>
맞춤식
<%	}else if(base.getRent_way().equals("3")){%>
기본식
<%	}%>
<input type='hidden' name="s_rent_way" value='<%=base.getRent_way()%>'>
<%}%></td>
            <td width="100" align="center" class=title>영업구분</td>
            <td>&nbsp;
              <select name="s_bus_st">
                <option value=""  <%if(base.getBus_st().equals("")){%>selected<%}%>>선택</option>
                <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>인터넷</option>
                <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>영업사원</option>
                <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>기존업체소개</option>
                <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog발송</option>
                <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>전화상담</option>
                <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>기존업체</option>
              </select></td>
          </tr>		  
          <tr> 
            <td width="110" align="center" class=title>대여개월</td>
            <td width="160">&nbsp;
              <input type='text' name="t_con_mon" value='<%=base.getCon_mon()%>' size="4" class='text' maxlength="2" onBlur='javascript:set_con_ff(); set_cont_date(this);'>
개월 </td>
            <td width="100" align="center" class=title>대여기간</td>
            <td colspan="3">&nbsp;
              <input type="text" name="t_rent_start_dt" value="<%=base.getRent_start_dt()%>" size="11" maxlength='11' class=text onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'>
~
<input type="text" name="t_rent_end_dt" value="<%=base.getRent_end_dt()%>" size="11" maxlength='11' class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>
          <tr> 
            <td width="110" align="center" class=title>최초영업자</td>
            <td width="160">&nbsp; 
              <select name="s_bus_id">
                <%if(user_size > 0){
					for(int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(base.getBus_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%	}
				}		%>
				
              </select>
            </td>
            <td width="100" align="center" class=title>영업담당자</td>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>&nbsp;                      
                      <select name="h_bus_id2" disabled>
                        <option value="">미지정</option>
                        <%if(user_size > 0)	{
							for (int i = 0 ; i < user_size ; i++){
								Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <% if(base.getBus_id2().equals(user.get("USER_ID"))){%> selected <%}%>><%=user.get("USER_NM")%></option>
                        <%	}
				}		%>
                        
                      </select>
                      <input type='hidden' name='s_bus_id2' value='<%=base.getBus_id2()%>'>
					  <a href="javascript:view_bus_cng('<%=m_id%>','<%=l_cd%>')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/images/h.gif" width="16" height="16" aligh="absmiddle" border="0"></a>
                  </td>
                </tr>
            </table></td>
            <td class=title align="center">관리담당자</td>
            <td>&nbsp;1.
                <select name="s_mng_id">
                  <option value="">미지정</option>
                  <%	if(user_size > 0)	{
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                  <option value='<%=user.get("USER_ID")%>' <% if(base.getMng_id().equals(user.get("USER_ID"))){%> selected <%}%>><%=user.get("USER_NM")%></option>
                  <%		}
					}%>                 
                </select>
				<br>&nbsp;2.
                <select name="s_mng_id2">
                  <option value="">미지정</option>
                  <%	if(user_size > 0)	{
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);%>
                  <option value='<%=user.get("USER_ID")%>' <% if(base.getMng_id2().equals(user.get("USER_ID"))){%> selected <%}%>><%=user.get("USER_NM")%></option>
                  <%		}
					}%>                  
                </select>(예비)
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="500"><font color="#999999">
        <%if(!base.getUpdate_id().equals("")){%>
        ♧ 최종수정자 : <%=c_db.getNameById(base.getUpdate_id(), "USER")%>&nbsp;&nbsp; 
		♧ 최종수정일 : <%=AddUtil.ChangeDate2(base.getUpdate_dt())%>
		<%}%>
        </font> </td>
      <td align="right" width="400"> 
      </td>
    </tr>
    <tr> 
      <td colspan="2" align="right">
	    <%if(base.getSanction_id().equals("") && nm_db.getWorkAuthUser("계약결재",user_id)){%>
        <input type="button" name="b_san" value="결재" onClick="javascript:sanction();" class="btn">
		&nbsp;	  
		<%}%>
		<input type="button" name="b_mail" value="메일관리" onClick="javascript:view_mail('<%=m_id%>','<%=l_cd%>');" class="btn">
		&nbsp;
        <input type="button" name="b_est" value="스캔관리" onClick="javascript:view_scan('<%=m_id%>','<%=l_cd%>');" class="btn">
		&nbsp;
        <input type="button" name="b_est" value="납품관리" onClick="javascript:view_est('<%=m_id%>','<%=l_cd%>');" class="btn">
		&nbsp;
		<!--
		<%if(nm_db.getWorkAuthUser("영업담당자변경",user_id)){//기본식이면 권한있는 사람만 변경%>
        <input type="button" name="b_bus" value="영업담당자변경" onClick="javascript:cng_bus('<%=m_id%>','<%=l_cd%>');" class="btn">
		&nbsp;
		<%}%>	
		-->
        <input type="button" name="b_settle" value="중도해지정산" onClick="javascript:view_settle('<%=m_id%>','<%=l_cd%>');" class="btn">
		&nbsp;
		<input type="button" name="b_cls" value="해지" onClick="javascript:view_cls();" class="btn">
      </td>
    </tr>	
  </table>
  <hr>
</form>
</body>
</html>
