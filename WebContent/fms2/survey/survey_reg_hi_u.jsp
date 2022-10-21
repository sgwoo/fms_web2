<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.common.*, acar.call.*, acar.util.*,acar.client.*, acar.car_mst.*, acar.user_mng.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
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
	
	String type 	= request.getParameter("type")==null?"1":request.getParameter("type");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "16", "01", "01");
	
	//계약정보
	ContBaseBean base = a_db.getContBaseHi(m_id, l_cd);
	if(c_id.equals(""))	c_id = base.getCar_mng_id();
		
		//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//고객정보
	ClientBean client 		= al_db.getClient(base.getClient_id());

	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//cont call  reg_id
	String reg_id 	= "";
	reg_id = p_db.getCallReg_id(m_id, l_cd);	
	
	if ( reg_id.equals("")) {
		reg_id = user_id;
	}
 	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//등록하기
	function save()
	{		
		var fm = document.form1;		
		var t_fm = parent.c_foot.document.form1;
			
		t_fm.t_con_cd.value 		= fm.t_con_cd.value;
		t_fm.t_rent_dt.value 		= fm.t_rent_dt.value;
		t_fm.s_rent_st.value 		= fm.s_rent_st.value;
		t_fm.s_car_st.value 		= fm.s_car_st.value;
		t_fm.h_brch.value 			= fm.h_brch.value;
	//	t_fm.s_bus_id.value 		= fm.s_bus_id.value;		
		t_fm.s_dept_id.value 		= fm.s_dept_id.value;		
		t_fm.s_rent_way.value 		= fm.s_rent_way.value;
		t_fm.s_bus_st.value 		= fm.s_bus_st.value;
		t_fm.t_con_mon.value 		= fm.t_con_mon.value;
		t_fm.t_rent_start_dt.value 	= fm.t_rent_start_dt.value;
		t_fm.t_rent_end_dt.value 	= fm.t_rent_end_dt.value;
		t_fm.use_yn.value 			= fm.use_yn.value;
	//	t_fm.s_bus_id2.value		= fm.s_bus_id2.value;			
	//	t_fm.s_mng_id.value 		= fm.s_mng_id.value;
	//	t_fm.s_mng_id2.value 		= fm.s_mng_id2.value;				
	}


	//수정하기
	function update()
	{
		var fm = document.form1;	
		save();			
		parent.c_foot.save();
		
	}	
	
	//수정하기
	function nocall()
	{
		var fm = document.form1;	
		if(confirm('Call 비대상으로 지정하시겠습니까?')){
			fm.target='nodisplay';
//			fm.target='parent.c_foot';
			fm.action='call_reg_cont_u_a.jsp';
			fm.submit();
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
		var type1 = fm.type.value;		
		
		if ( type1 == '1' ) {
			parent.location='/acar/call/rent_cond_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
		} else { 
			          
			parent.location='/acar/call/call_cond_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
			
		}
	}		

	
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body leftmargin="15">
<form action='survey_reg_hi_u_a.jsp' name="form1" method='post'>
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
<input type='hidden' name='type' value='<%=type%>'> 
<input type='hidden' name="s_dept_id" value=''>
<input type='hidden' name="reg_id" value=''>

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	
    <tr>
        <td class=line2></td>
    </tr>
	<tr> 
        <td class=line colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<tr>
					<td class="title">계약사항</td>
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
                    <td class=title width="110">계약번호</td>
                    <td width="160" class=b>&nbsp; 
                      <input type="text" name="t_con_cd" value="<%=base.getRent_l_cd()%>" size="15" class='whitetext' readonly >
                    </td>
                    <td class=title width="100">계약일자</td>
                    <td width="160" class=b>&nbsp; 
                      <input type="text" name="t_rent_dt" value="<%=base.getRent_dt()%>" size="11" maxlength='10' class=whitetext onBlur='javascript: this.value = ChangeDate(this.value)'>
                    </td>
                    <td class=title width="100">계약구분</td>
                    <td  colspan="3" class=b>&nbsp; 
                      <select name='s_rent_st' onChange='javascript:change_sub_menu()' disabled >
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
                    <td width="160" class=b>&nbsp;
                      <select name="s_car_st" onChange='javascript:set_con_cd()' disabled >
                        <%if(base.getCar_st().equals("1") || base.getCar_st().equals("3")){%>
                        <option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>렌트</option>
                        <option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>리스</option>
                        <%}else if(base.getCar_st().equals("2")){%>
                        <option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>보유</option>
                        <%}%>
                    </select></td>
                    <td width="100" align="center" class=title>대여방식</td>
                    <td width="160" class=b>&nbsp;
                      <%if(nm_db.getWorkAuthUser("대여방식변경",user_id)){%>
                      <select name="s_rent_way" disabled >
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
                    <td  colspan="3"   class=b>&nbsp;
                      <select name="s_bus_st" disabled >
                        <option value=""  <%if(base.getBus_st().equals("")){%>selected<%}%>>선택</option>
                        <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>인터넷</option>
                        <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>영업사원</option>
                        <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>기존업체소개</option>
                        <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog발송</option>
                        <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>전화상담</option>
                        <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>기존업체</option>
                        <option value="7" <%if(base.getBus_st().equals("7")){%>selected<%}%>>에이전트</option>
                        <option value="8" <%if(base.getBus_st().equals("8")){%>selected<%}%>>모바일</option>
                      </select></td>
                 
                </tr>		  
                <tr> 
                    <td width="110" align="center" class=title>대여개월</td>
                    <td width="160" class=b>&nbsp;
                      <input type='text' name="t_con_mon" value='<%=base.getCon_mon()%>' size="4" class='whitetext' maxlength="2" onBlur='javascript:set_con_ff(); set_cont_date(this);' readonly >
                    개월 </td>
                    <td width="100" align="center" class=title>대여기간</td>
                    <td colspan="5" class=b>&nbsp;
                      <input type="text" name="t_rent_start_dt" value="<%=base.getRent_start_dt()%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);' readonly >
                    ~
                    <input type="text" name="t_rent_end_dt" value="<%=base.getRent_end_dt()%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)' readonly ></td>
                
                </tr>
                <tr> 
                    <td width="110" align="center" class=title>최초영업자</td>
                    <td width="160" class=b>&nbsp; <%=c_db.getNameById(base.getBus_id(),"USER")%>            
                    </td>
                    <td width="110" align="center" class=title>영업대리인</td>
                    <td width="160" class=b>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%>             
                    </td>
                    <td width="100" align="center" class=title>영업담당자</td>
                    <td width="160" class=b>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%>        
                    </td>    
                    </td>
                    <td width="100"  class=title align="center">관리담당자</td>
                    <td width="160"  class=b>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%>                      
                    </td>
                
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align='left'>  
        <img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>기본사항</b></a></td>
    </tr>
    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='110' class='title'>고객구분</td>
                    <td width='180' align='left'>&nbsp; <input type='text' name="t_cl_gbn" 
                        			<% if(client.getClient_st().equals("1")){%>value='법인'
        							<% }else if(client.getClient_st().equals("2")){%>value='개인'
        							<% }else if(client.getClient_st().equals("3")){%>value='개인사업자(일반과세)'
        							<% }else if(client.getClient_st().equals("4")){%>value='개인사업자(간이과세)'
        							<% }else if(client.getClient_st().equals("5")){%>value='개인사업자(면세사업자)'
        							<% }%>size='20' class='whitetext' readonly> </td>
                    <td width='100' class='title'>상호</td>
                    <td width='180' align='left'>&nbsp; <input type='text' name="t_firm_nm" value='<%=client.getFirm_nm()%>' size='22' class='whitetext' readonly title='<%=client.getFirm_nm()%>'> 
                    </td>
                    <td width='100' class='title'>대표자</td>
                    <td align='left'>&nbsp; <input type='text' name="t_client_nm" value='<%=client.getClient_nm()%>' size='12' class='whitetext' readonly> 
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>사업자번호</td>
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_enp_no" value='<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>' size="22" class='whitetext' readonly> 
                    </td>
                    <td width="100" class='title'>생년월일</td>
           	  <td width="180" align='left'>&nbsp; <input type='text' name="t_ssn" value='<%=client.getSsn1()%>-*******' size='22' class='whitetext' readonly> 
                    </td>
                    <td width='100' class='title'>Homepage</td>
                    <td align='left'>&nbsp; 
                      <%if(!client.getHomepage().equals("") && client.getHomepage().length() > 7){%>
                      <a href="<%=client.getHomepage()%>" target="_bank"> 
                      <input type='text' name="t_homepage" value='<%=client.getHomepage()%>' size='22' class='whitetext' readonly>
                      </a> 
                      <%}else{%>
                      <input type='text' name="t_homepage" value='<%=client.getHomepage()%>' size='22' class='whitetext' readonly> 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>사무실전화</td>
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_o_tel" value='<%= client.getO_tel()%>' size='22' class='whitetext' readonly> 
                    </td>
                    <td width="100" class='title'>FAX 번호</td>
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_fax" value='<%= client.getFax()%>' size='22' class='whitetext' readonly> 
                    &nbsp; </td>
                    <td class='title' width="100">개업년월일</td>
                    <td class='left'>&nbsp; <input type='text' name="t_open_year" value='<%= client.getOpen_year()%>' size='22' class='whitetext' readonly> 
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>자본금</td>
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_firm_price" value='<%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"백만원/"+client.getFirm_day());%>' size='22' class='whitetext' readonly> 
                    </td>
                    <td width="100" class='title'>연매출</td>
                    <td width="180">&nbsp; <input type='text' name="t_firm_price_y" value='<%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"백만원/"+client.getFirm_day_y());%>' size='25' class='whitetext' readonly> 
                    </td>
                    <td width="100" class='title'>발행구분</td>
                    <td>&nbsp;<input type='text' name="print_st" 
        							<% if(client.getPrint_st().equals("1")){%>value='계약건별'
        							<% }else if(client.getPrint_st().equals("2")){%>value='거래처통합'
        							<% }else if(client.getPrint_st().equals("3")){%>value='지점통합'
        							<% }else if(client.getPrint_st().equals("4")){%>value='현장통합'
        							<% }%> size='22' class='whitetext' readonly>
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>업태</td>
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_bus_cdt" size='22' class='whitetext' readonly value="<%= client.getBus_cdt()%>"> 
                    </td>
                    <td width="100" class='title'>종목</td>
                    <td align='left' colspan="3">&nbsp; <input type='text' name="t_bus_itm" size='50' class='whitetext' readonly value="<%= client.getBus_itm()%>"> 
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>사업장주소</td>
                    <td colspan="5">&nbsp; <input type='text' name="t_o_zip" value='<%=client.getO_zip()%>' size="7" class='whitetext' readonly> 
                      <input type='text' name="t_o_addr" value='<%=client.getO_addr()%>' size="59" class='whitetext' readonly> 
                    </td>
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
                <tr> 
                    <td class=title width="110">구분</td>
                    <td class=title width="98">근무부서</td>
                    <td class=title width="80">성명</td>
                    <td class=title width="80">직위</td>
                    <td class=title width="100">전화번호</td>
                    <td class=title width="100">휴대폰</td>
                    <td class=title width="201">E-MAIL</td>
                    <td class=title width="80">수신거부</td>			
                    <td class=title align='center'>&nbsp;</td>
                </tr>
                  <%//법인고객차량관리자
        			Vector car_mgrs = a_db.getCarMgr(m_id, l_cd);
        			int mgr_size = car_mgrs.size();
        			if(mgr_size > 0){
        				for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>
                <tr> 
                    <td align='center' width="110"> <input type='hidden' name='h_mgr_id' size='10' class='text' value='<%=mgr.getMgr_id()%>'> 
                     <%= mgr.getMgr_st()%>
                    </td>
                    <td align='center'  width="98"> <input type='text' name='t_mgr_dept' 	value='<%= mgr.getMgr_dept()%>' size='9' maxlength='15' class='whitetext'  style='IME-MODE: active'> 
                    </td>
                    <td align='center'  width="80"> <input type='text' name='t_mgr_nm' 		value='<%= mgr.getMgr_nm()%>' size='9' maxlength='20' class='whitetext'> 
                    </td>
                    <td align='center'  width="80"> <input type='text' name='t_mgr_title' 	value='<%= mgr.getMgr_title()%>' size='9' maxlength='10' class='whitetext' style='IME-MODE: active'> 
                    </td>
                    <td align='center' width="100"> <input type='text' name='t_mgr_tel' 	value='<%= mgr.getMgr_tel()%>' size='12' maxlength='15' class='whitetext'> 
                    </td>
                    <td align='center' width="100"> <input type='text' name='t_mgr_mobile' 	value='<%= mgr.getMgr_m_tel()%>' size='12' maxlength='15' class='whitetext'> 
                    </td>
                    <td align='center' width="201"> <input type='text' name='t_mgr_email' 	value='<%= mgr.getMgr_email()%>' size='13' maxlength='30' class='whitetext' style='IME-MODE: inactive'> 
                    </td>
                    <td align='center'  width="80"> <input type="checkbox" name="mail_yn" disabled	value="N" <%if(mgr.getEmail_yn().equals("N"))%>checked<%%>>
                    </td>			
                    <td align='center' valign="bottom"> 
                     
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
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="110">담당자</td>
                    <td class=title width="98">상호</td>
                    <td class=title width="80">지점명</td>
                    <td class=title width="120">영업소명</td>
                    <td class=title width="80">성명</td>
                    <td class=title width="80">직위</td>
                    <td class=title width="100">전화번호</td>
                    <td class=title width="100">휴대폰</td>
                    <td class=title>이메일</td>
                </tr>
                  <%//지급수수료:영업소사원
        			Hashtable mgrs 		= a_db.getCommiNInfo(m_id, l_cd);
        			Hashtable mgr_bus 	= (Hashtable)mgrs.get("BUS");
        			Hashtable mgr_dlv 	= (Hashtable)mgrs.get("DLV");%>
                <tr> 
                    <td class='title' width="110">영업사원
                      <input type='hidden' name='h_emp_id_bus' value='<%if(mgr_bus.get("EMP_ID") != null)%><%=mgr_bus.get("EMP_ID")%>'> 
                    </td>
                    <td align='center'> <input type='text' name='t_com_nm_bus' 	value='<%if(mgr_bus.get("COM_NM") != null)%><%=mgr_bus.get("COM_NM")%>' size='13' class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_off_nm_bus1' value='<%if(mgr_bus.get("CAR_OFF_ST") != null && mgr_bus.get("CAR_OFF_ST").equals("1") && mgr_bus.get("CAR_OFF_NM") != null)%><%=mgr_bus.get("CAR_OFF_NM")%>' size='10' class='white' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_off_nm_bus2' value='<%if(mgr_bus.get("CAR_OFF_ST") != null && !mgr_bus.get("CAR_OFF_ST").equals("1") && mgr_bus.get("CAR_OFF_NM") != null)%><%=mgr_bus.get("CAR_OFF_NM")%>' size='17' class='white' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_emp_nm_bus' 	value='<%if(mgr_bus.get("NM") != null)%><%=mgr_bus.get("NM")%>' size='7' class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_title_bus' 	value='<%if(mgr_bus.get("POS") != null)%><%=mgr_bus.get("POS")%>' size="7" class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_tel_bus' 	value='<%if(mgr_bus.get("O_TEL") != null)%><%=mgr_bus.get("O_TEL")%>' size="13" class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_m_tel_bus' 	value='<%if(mgr_bus.get("TEL") != null)%><%=mgr_bus.get("TEL")%>' size="13" class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_emp_email_bus' value='<%if(mgr_bus.get("EMP_EMAIL") != null)%><%=mgr_bus.get("EMP_EMAIL")%>' size="13" class='whitetext' readonly></td>
                </tr>
                <tr> 
                    <td class='title' width="110">출고사원
                      <input type='hidden' name='h_emp_id_dlv' value='<%if(mgr_dlv.get("EMP_ID") != null)%><%=mgr_dlv.get("EMP_ID")%>'> 
                    </td>
                    <td align='center'> <input type='text' name='t_com_nm_dlv' 	value='<%if(mgr_dlv.get("COM_NM") != null)%><%=mgr_dlv.get("COM_NM")%>' size='13' class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_off_nm_dlv1' value='<%if(mgr_dlv.get("CAR_OFF_ST") != null && mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null)%><%=mgr_dlv.get("CAR_OFF_NM")%>' size='10' class='white' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_off_nm_dlv2' value='<%if(mgr_dlv.get("CAR_OFF_ST") != null && !mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null)%><%=mgr_dlv.get("CAR_OFF_NM")%>' size='17' class='white' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_emp_nm_dlv' 	value='<%if(mgr_dlv.get("NM") != null)%><%=mgr_dlv.get("NM")%>' size='7' class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_title_dlv' 	value='<%if(mgr_dlv.get("POS") != null)%><%=mgr_dlv.get("POS")%>' size="7" class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_tel_dlv' 	value='<%if(mgr_dlv.get("O_TEL") != null)%><%=mgr_dlv.get("O_TEL")%>' size="13" class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_m_tel_dlv' 	value='<%if(mgr_dlv.get("TEL") != null)%><%=mgr_dlv.get("TEL")%>' size="13" class='whitetext' readonly> 
                    </td>
                    <td align='center'> <input type='text' name='t_emp_email_dlv' value='<%if(mgr_dlv.get("EMP_EMAIL") != null)%><%=mgr_dlv.get("EMP_EMAIL")%>' size="13" class='whitetext' readonly></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td align='left'>  
        <img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>차량기본사항</b></a></td>
    </tr>
    <%	
		//차량등록정보
		Hashtable car_fee 	= a_db.getCarRegFee(m_id, l_cd);
		//차량기본정보
		ContCarBean car 	= a_db.getContCar(m_id, l_cd);
		
		//자동차회사&차종&자동차명
		AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
		CarMstBean mst 		= a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	%>
     
    <input type='hidden' name='h_car_mng_id' value='<%=base.getCar_mng_id()%>'>
    <input type='hidden' name='h_car_rent_l_cd' value=''>
    <input type='hidden' name='h_car_rent_mng_id' value=''>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='write'> 
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td class='line'>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>                   
                            <tr> 
                                    	<td class='title' width='110'> 차량번호 </td>
                                <td width="180">&nbsp; <input type='text' name='t_car_no' value='<%=car_fee.get("CAR_NO")%>' class='whitetext' readonly size="13" > 
                                </td>
                                <td class='title' width='110'> 자동차회사 </td>
                                <td width="180">&nbsp; <input type='text' name='t_com_nm' value='<%=mst.getCar_comp_nm()%>' class='whitetext' readonly size="13" > 
                                </td>
                                <td class='title' width="100">차명</td>
                                <td width="180">&nbsp; <input type='text' name='t_car_nm' value='<%=mst.getCar_nm()%>' class='whitetext' readonly size="20" > 
                                </td>
                                <td class='title' width='100'>차종</td>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                            <td>&nbsp; <input type='text' name='t_car_name' value='<%=mst.getCar_name()%>' class='whitetext' readonly size="30" > 
                                            </td>
                                            <td> <input type='hidden' name='h_car_id' value='<%=car.getCar_id()%>'> 
                                             <input type='hidden' name='t_car_seq' value='<%=car.getCar_seq()%>'> 
                                          	 <input type='hidden' name='t_com_id' value='<%=mst.getCar_comp_id()%>'> 
                                          	 <input type='hidden' name='t_car_cd' value='<%=mst.getCode()%>'> 
                							 <input type='hidden' name='s_st' value='<%=mst.getS_st()%>'> 
                                            </td>
                                         </tr>
                                    </table>
                                </td>
                            </tr>                                                        
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>                    
   	<tr>
        <td></td>
    </tr>
</table>
</form>
</body>
</html>
