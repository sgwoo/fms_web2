<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.common.*, acar.call.*, acar.util.*,acar.client.*, acar.car_mst.*, acar.user_mng.*, acar.car_office.* "%>
<%@ page import="acar.insur.*"%>
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
		
	//계약기타정보		2018.03.21
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//고객정보
	ClientBean client 		= al_db.getClient(base.getClient_id());

	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();		// 2018.03.21
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();	// 2018.05.21
	
	
	//cont call  reg_id
	String reg_id 	= "";
	reg_id = p_db.getCallReg_id(m_id, l_cd);	
	
	if ( reg_id.equals("")) {
		reg_id = user_id;
	}
 	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+
					"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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

	
function update(st){
	
			var height = 350;			
			window.open("call_mgr_u.jsp<%=valus%>&cng_item="+st+"&rent_st=1", "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
	
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
        <td class= colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<tr>
					<td class=""></td>
					<td align="right"></td>
				</tr>
			</table>
		</td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> 계약사항 </label></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width="15%">계약번호</td>
                    <td  width="30%" class=b>&nbsp;<%=base.getRent_l_cd()%></td>
                    <td class=title width="15%">계약일자</td>
                    <td  width="30%" class=b>&nbsp;<%=base.getRent_dt()%></td>
				</tr>
				<tr>
                    <td class=title width="15%">계약구분</td>
                    <td  width="30%" class=b>&nbsp; 
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
                    <td class=title  width="10%">대여구분</td>
                    <td  width="30%" class=b>&nbsp;
						<select name="s_car_st" onChange='javascript:set_con_cd()' disabled >
							<%if(base.getCar_st().equals("1") || base.getCar_st().equals("3")){%>
							<option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>렌트</option>
							<option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>리스</option>
							<%}else if(base.getCar_st().equals("2")){%>
							<option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>보유</option>
							<%}%>
						</select>
					</td>
				</tr>
                <tr>
                    <td width="10%" class=title>대여방식</td>
                    <td  width="30%" class=b>&nbsp;
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
                        <%}%>
					</td>
                    <td  width="10%" class=title>영업구분</td>
                    <td class=b  width="30%">&nbsp;
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
						</select>
					</td>
                </tr>		  
                <tr> 
                    <td width="10%" class=title>대여개월</td>
                    <td width="30%" class=b>&nbsp;<%=base.getCon_mon()%>개월 </td>
                    <td width="10%" class=title>대여기간</td>
                    <td class=b align="center" width="30%">&nbsp;<%=base.getRent_start_dt()%>
					~
					<%=base.getRent_end_dt()%></td>
                </tr>
                <tr> 
                    <td width="10%" class=title>최초영업자</td>
                    <td width="30%" class=b>&nbsp; <%=c_db.getNameById(base.getBus_id(),"USER")%> <br/>
                    	<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %>&nbsp;(계약진행담당자:<%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)<%}%>
                    </td>
                    <td width="10%" class=title>영업대리인</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
				</tr>
                <tr>
                    <td width="10%" class=title>영업담당자</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>    
                    </td>
                    <td width="10%" class=title>관리담당자</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> 기본사항 </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='15%' class='title'>고객구분</td>
                    <td width="30%" align='left'>&nbsp;
                        			<% if(client.getClient_st().equals("1")){%>법인
        							<% }else if(client.getClient_st().equals("2")){%>개인
        							<% }else if(client.getClient_st().equals("3")){%>개인사업자(일반과세)
        							<% }else if(client.getClient_st().equals("4")){%>개인사업자(간이과세)
        							<% }else if(client.getClient_st().equals("5")){%>개인사업자(면세사업자)
        							<% }%></td>
                    <td width='15%' class='title'>상호</td>
                    <td width='30%' align='left'>&nbsp;<%=client.getFirm_nm()%></td>
				</tr>
                <tr> 
                    <td width='10%' class='title'>대표자</td>
                    <td width="30%">&nbsp;<%=client.getClient_nm()%></td>
                
                    <td width="10%" class='title'>사업자번호</td>
                    <td width="30%" align='left'>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
				</tr>
                <tr> 
                    <td width="10%" class='title'>생년월일</td>
					<td width="30%" align='left'>&nbsp;<%=client.getSsn1()%>-*******</td>
                    <td width='10%' class='title'>Homepage</td>
                    <td width="30%" align='left'>&nbsp; 
                      <%if(!client.getHomepage().equals("") && client.getHomepage().length() > 7){%>
                      <a href="<%=client.getHomepage()%>" target="_bank"> 
                      <%=client.getHomepage()%>
                      </a> 
                      <%}else{%>
                      <%=client.getHomepage()%>
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width="10%" class='title'>사무실전화</td>
                    <td width="30%" align='left'>&nbsp;<%= client.getO_tel()%></td>
                    <td width="10%" class='title'>FAX 번호</td>
                    <td width="30%" align='left'>&nbsp;<%= client.getFax()%></td>
				</tr>
                <tr> 
                    <td class='title' width="10%">개업년월일</td>
                    <td width="30%">&nbsp;<%= client.getOpen_year()%></td>
                    <td width="10%" class='title'>자본금</td>
                    <td width="30%" align='left'>&nbsp;<%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"백만원/"+client.getFirm_day());%></td>
				</tr>
                <tr> 
                    <td width="10%" class='title'>연매출</td>
                    <td width="30%">&nbsp;<%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"백만원/"+client.getFirm_day_y());%></td>
                    <td width="10%" class='title'>발행구분</td>
                    <td width="30%">&nbsp;
						<% if(client.getPrint_st().equals("1")){%>계약건별
						<% }else if(client.getPrint_st().equals("2")){%>거래처통합
						<% }else if(client.getPrint_st().equals("3")){%>지점통합
						<% }else if(client.getPrint_st().equals("4")){%>현장통합
						<% }%>
                    </td>
                </tr>
                <tr> 
                    <td width="10%" class='title'>업태</td>
                    <td width="30%"align='left'>&nbsp;<%= client.getBus_cdt()%></td>
                    <td width="10%" class='title'>종목</td>
                    <td align='left'  width="30%">&nbsp;<%= client.getBus_itm()%></td>
                </tr>
                <tr> 
                    <td width="10%" class='title'>사업장주소</td>
                    <td colspan="3"  width="30%">&nbsp; (<%=client.getO_zip()%>)&nbsp; <%=client.getO_addr()%> </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h><input type="button" class="button button4" value="관계자수정" onclick="update('mgr');"/></td>
    </tr>
	<%//법인고객차량관리자
        			Vector car_mgrs = a_db.getCarMgr(m_id, l_cd);
        			int mgr_size = car_mgrs.size();
        			if(mgr_size > 0){
        				for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> <%=mgr.getMgr_st()%> </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr> 
					<td class=title width="15%">성명</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_nm()%></td>
					<td class=title width="15%">근무부서</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_dept()%></td>
				</tr>
                <tr> 	
                    <td class=title width="15%">직위</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_title()%></td>
				
                    <td class=title width="15%">전화번호</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_tel()%></td>
				</tr>
                <tr>                 
					<td class=title width="15%">휴대폰</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_m_tel()%></td>
                    <td class=title width="15%">E-MAIL</td>
					<td width="30%">&nbsp;<%= mgr.getMgr_email()%></td>
                </tr>
            </table>
	    </td>
    </tr>
  <%	}
	}%>
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> 영업사원</label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
               
                  <%//지급수수료:영업소사원
        			Hashtable mgrs 		= a_db.getCommiNInfo(m_id, l_cd);
        			Hashtable mgr_bus 	= (Hashtable)mgrs.get("BUS");
        			Hashtable mgr_dlv 	= (Hashtable)mgrs.get("DLV");%>
				 <tr> 
                    <td class=title width="15%">상호</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("COM_NM") != null)%><%=mgr_bus.get("COM_NM")%></td>
                    <td class=title width="15%">지점명</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("CAR_OFF_ST") != null && mgr_bus.get("CAR_OFF_ST").equals("1") && mgr_bus.get("CAR_OFF_NM") != null)%><%=mgr_bus.get("CAR_OFF_NM")%></td>
				</tr>
				<tr>
                    <td class=title width="10%">영업소명</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("CAR_OFF_ST") != null && !mgr_bus.get("CAR_OFF_ST").equals("1") && mgr_bus.get("CAR_OFF_NM") != null)%><%=mgr_bus.get("CAR_OFF_NM")%></td>
                    <td class=title width="10%">성명</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("NM") != null)%><%=mgr_bus.get("NM")%></td>
				</tr>
				<tr>
                    <td class=title width="10%">직위</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("POS") != null)%><%=mgr_bus.get("POS")%></td>
                    <td class=title width="10%">전화번호</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("O_TEL") != null)%><%=mgr_bus.get("O_TEL")%></td>
				</tr>
				<tr>
                    <td class=title width="10%">휴대폰</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("TEL") != null)%><%=mgr_bus.get("TEL")%></td>
                    <td class=title>이메일</td>
					<td width="30%">&nbsp;<%if(mgr_bus.get("EMP_EMAIL") != null)%><%=mgr_bus.get("EMP_EMAIL")%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> 출고사원</label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
				 <tr> 
                    <td class=title width="15%">상호</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("COM_NM") != null)%><%=mgr_dlv.get("COM_NM")%></td>
                    <td class=title width="15%">지점명</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null)%><%=mgr_dlv.get("CAR_OFF_NM")%></td>
				</tr>
				<tr>
                    <td class=title width="15%">영업소명</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && !mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null)%><%=mgr_dlv.get("CAR_OFF_NM")%></td>
                    <td class=title width="15%">성명</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("NM") != null)%><%=mgr_dlv.get("NM")%></td>
				</tr>
				<tr>
                    <td class=title width="10%">직위</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("POS") != null)%><%=mgr_dlv.get("POS")%></td>
                    <td class=title width="15%">전화번호</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("O_TEL") != null)%><%=mgr_dlv.get("O_TEL")%></td>
				</tr>
				<tr>
                    <td class=title width="15%">휴대폰</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("TEL") != null)%><%=mgr_dlv.get("TEL")%></td>
                    <td class=title width="15%">이메일</td>
					<td width="30%">&nbsp;<%if(mgr_dlv.get("EMP_EMAIL") != null)%><%=mgr_dlv.get("EMP_EMAIL")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> 차량기본사항 </label></td>
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
    <tr>
        <td class=line2></td>
    </tr>
	<tr> 
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>                   
				<tr> 
					<td class='title' width='15%'> 차량번호 </td>
					<td width="30%">&nbsp;<%=car_fee.get("CAR_NO")%></td>
					<td class='title' width='15%'> 자동차회사 </td>
					<td width="30%">&nbsp;<%=mst.getCar_comp_nm()%></td>
				</tr>
				<tr>
					<td class='title' width="15%">차명</td>
					<td width="30%">&nbsp;<%=mst.getCar_nm()%></td>
					<td class='title' width='15%'>차종</td>
					<td width="30%">&nbsp;<%=mst.getCar_name()%></td>
				</tr>                                                        
			</table>
		</td>
	</tr>
	<tr><!-- 2018.03.20 -->
        <td class=h></td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> 보험사항 </label></td>
    </tr>
    <%	
		
	%>
    <tr>
        <td class=line2></td>
    </tr>
	<tr> 
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>      
			<%	//보험이력-일반보험
				String ins_com_nm = "";
				if(true){
					Vector inss2 = ai_db.getInsHisList1(base.getCar_mng_id());
					int ins_size2 = inss2.size();
					//System.out.println("ins_size2 : " + ins_size2);
					if(ins_size2 > 0){
						for(int i=0; i<ins_size2; i++){
							Hashtable ins2 = (Hashtable)inss2.elementAt(i);
							//System.out.println(" i : " + i);
							if(i<ins_size2-1) {
								continue;
							}
							ins_com_nm = (String)ins2.get("INS_COM_NM");
							
						}
					}
				}
			%>             
				<tr> 
					<td class='title' width='15%'> 보험사명 </td>
					<td width="30%">&nbsp;<%=ins_com_nm%></td>
					<td class='title' width='15%' style="font-size:100%;"><b>피보험자</b></td><!-- 글자 크기 수정 / 정채달 팀장님 지시사항 2018.03.30 -->
					<td width="30%">&nbsp;<font style="font-size:130%;"><b><%String insur_per = cont_etc.getInsur_per();%><%if(insur_per.equals("1") || insur_per.equals("")){%>아마존카<%}else if(insur_per.equals("2")){%>고객<%}%></b></font></td>
				</tr>
				<tr>
					<td class='title' width="15%">대인배상</td>
					<td width="30%">&nbsp;무한(대인배상Ⅰ,Ⅱ)</td>
					<td class='title' width='15%'><!-- 보험계약자 --></td><!-- 보험 계약서 삭제 / 정채달 팀장님 지시사항 2018.03.30 -->
					<td width="30%">&nbsp;<%-- <%String insurant = cont_etc.getInsurant();%><%if(insurant.equals("1") || insurant.equals("")){%>아마존카<%}else if(insurant.equals("2")){%>고객<%}%> --%></td>
				</tr>
				<tr>
					<td class='title' width="15%">대물배상</td>
					<td width="30%">&nbsp;<%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5천만원<%}else if(gcp_kd.equals("2")){%>1억원<%}else if(gcp_kd.equals("3")){%>5억원<%}else if(gcp_kd.equals("4")){%>2억원<%}else if(gcp_kd.equals("8")){%>3억원<%}%></td>
					<td class='title' width='15%'>운전자연령</td>
					<td width="30%">&nbsp;<%String driving_age = base.getDriving_age();%><%if(driving_age.equals("0")){%>26세이상<%}
                    	else if(driving_age.equals("3")){%>24세이상<%}
                    	else if(driving_age.equals("1")){%>21세이상<%}
                    	else if(driving_age.equals("5")){%>30세이상<%}
                    	else if(driving_age.equals("6")){%>35세이상<%}
                    	else if(driving_age.equals("7")){%>43세이상<%}
                    	else if(driving_age.equals("8")){%>48세이상<%}
                    	else if(driving_age.equals("9")){%>22세이상<%}
                    	else if(driving_age.equals("10")){%>28세이상<%}
                    	else if(driving_age.equals("11")){%>35세이상~49세이하<%}
                    	else if(driving_age.equals("2")){%>모든운전자<%}%></td>
				</tr>
				<tr>
					<td class='title' width="15%">자기신체사고</td>
					<td width="30%">&nbsp;<%String bacdt_kd = base.getBacdt_kd();%><%if(bacdt_kd.equals("1")){%>5천만원<%}else if(bacdt_kd.equals("2")){%>1억원<%}else if(bacdt_kd.equals("9")){%>미가입<%}%></td>
					<td class='title' width='15%' style="letter-spacing:-0.5px;">임직원운전한정특약</td>
					<td width="30%">&nbsp;<%String com_emp_yn = cont_etc.getCom_emp_yn();%><%if(com_emp_yn.equals("Y")){%>가입<%}else if(!com_emp_yn.equals("Y")){%>미가입<%}%></td>
				</tr>
				<tr>
					<td class='title' width="15%">무보험차상해</td>
					<td width="30%">&nbsp;<%String canoisr_yn = cont_etc.getCanoisr_yn();%><%if(canoisr_yn.equals("Y")){%>가입<%}else if(canoisr_yn.equals("N")){%>미가입<%}%></td>
					<td class='title' width='15%'></td>
					<td width="30%"></td>
				</tr>
				<tr>
					<td class='title' width="15%">자차손해면책금<br>(자기부담금)</td>
					<td width="30%" colspan="3">&nbsp;<%if(insur_per.equals("1")||insur_per.equals("")){
						%>사고건당 <%=AddUtil.parseDecimal(base.getCar_ja())%>원 (자기차량 손해는 보험사에 가입하지 않고, 아마존카 자기차량손해 면책제도에 의거 보상)<%}else{
						%>물적사고할증기준 : <%=cont_etc.getCacdt_mebase_amt()%>만원
							  &nbsp;&nbsp;&nbsp;최소자기부담금 : <%=cont_etc.getCacdt_memin_amt()%>만원 
							  &nbsp;&nbsp;&nbsp;최대자기부담금 : <%=cont_etc.getCacdt_me_amt()%>만원<%}%></td>
				</tr>
			</table>
		</td>
	</tr>
	<%if(insur_per.equals("1") || insur_per.equals("")){%>
	<tr><td style="height:5px;"></td></tr>
	<tr>
		<td>
			※ 자기차량손해 면책 제도란 고객의 과실로 인한 자차사고시, 고객은 약정한 자기차량손해 면책금(자기부담금)만 자동차 대여회사에 납입하고, 
			발생한 자기차량손해에 대하여 면책되는 제도입니다. (아마존카는 해당 차량의 종합보험을 가입한 보험사의 약관에 준하여 자기차량손해 면책 제도 운영)
		</td>
	</tr>
	<%}%>
   	<tr>
        <td></td>
    </tr>
</table>
</form>
</body>
</html>
