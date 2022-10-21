<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.user_mng.*, acar.call.*, acar.client.*, acar.car_mst.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

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
	String s_id 	= request.getParameter("s_id")==null?"":request.getParameter("s_id");		//serv_id
	String use_yn 	= request.getParameter("use_yn")==null?"":request.getParameter("use_yn");	//계약상태
	String gubun1 	= request.getParameter("gubun1")==null?"20":request.getParameter("gubun1");
	
	String type 	= request.getParameter("type")==null?"1":request.getParameter("type");
	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");	
	
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
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();	// 2018.05.23
	
	
	

	//cont call  reg_id
	String reg_id 	= "";
	reg_id = p_db.getCallServiceReg_id(m_id, l_cd,c_id,s_id);	
	
	if ( reg_id.equals("")) {
		reg_id = user_id;
	}
	
	
	//고객정보
	ClientBean client 		= al_db.getClient(base.getClient_id());

	//정비정보
    Hashtable h_serv	 	= p_db.getServiceBaseAll(l_cd, c_id, s_id);
  
  	String call_t_nm	= "";
	String call_t_tel = "";
	String serv_dt = "";
	String off_nm = "";
	int    buy_amt  = 0;
	String p_gubun = "";
	
			
	call_t_nm = (String)h_serv.get("CALL_T_NM");
	call_t_tel = (String) h_serv.get("CALL_T_TEL");
	serv_dt = (String) h_serv.get("SERV_DT");
	p_gubun = (String) h_serv.get("P_GUBUN");
	off_nm = (String) h_serv.get("OFF_NM");
	buy_amt =Integer.parseInt(String.valueOf(h_serv.get("BUY_AMT")));
	
	if (call_t_nm.equals("null")) call_t_nm = "";
	if (call_t_tel.equals("null")) call_t_tel = "";
    
    //서비스항목
    String serv_item_nm = "";
    serv_item_nm =  p_db.getServiceItemName(c_id, s_id);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='car_rent_base.js'></script>
<script language="JavaScript">
<!--

	//등록하기
	function save()
	{		
		var fm = document.form1;		
		var t_fm = parent.c_foot.document.form1;
				
	}


	//수정하기
	function update()
	{
		var fm = document.form1;	
		save();			
		parent.c_foot.save();
		
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
			parent.location='/fms2/call/car_service_s_frame.jsp?dt='+fm.dt.value+'&gubun2='+fm.gubun2.value+'&ref_dt1='+fm.ref_dt1.value+'&ref_dt2='+fm.ref_dt2.value+'&auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
		} else { 
			parent.location='/fms2/call/call_car_service_frame.jsp?auth_rw='+auth+'&s_kd='+s_kd+'&brch_id='+brch_id+'&s_bank='+s_bank+'&t_wd='+t_wd+'&cont_st='+cont_st;
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
<style>
textarea {
    width: 100%;
    height: 50px;
    padding: 12px 20px;
    box-sizing: border-box;
    border: 2px solid #ccc;
    border-radius: 4px;
    background-color: #f8f8f8;
}
input[name=poll_title] {
    width: 100%;
    padding: 6px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 1px none ;
    border-radius: 4px;
	text-align: center;
	
}
input[name=start_dt], input[name=end_dt], input[name=poll_su]  {
    width: 40%;
    padding: 6px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 1px solid ;
    border-radius: 4px;
	
}


.button {
    background-color: #4CAF50; /* Green */
    border: none;
    color: white;
    padding: 4px 6px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 13px;
    margin: 4px 2px;
    -webkit-transition-duration: 0.4s; /* Safari */
    transition-duration: 0.4s;
    cursor: pointer;
	border-radius: 3px;
}

.button4 {
    background-color: white;
    color: black;
    border: 2px solid #555555;
}

.button4:hover {background-color: #555555;}


</style>
</head>
<body leftmargin="15">
<form action='call_service_reg_hi_u_a.jsp' name="form1" method='post'>
<input type='hidden' name='h_pay_tm' value=''>
<input type='hidden' name='h_pay_start_dt' value=''>
<input type='hidden' name='h_pay_end_dt' value=''>
<input type='hidden' name='h_brch' value='<%= base.getBrch_id()%>'>
<input type='hidden' name='use_yn' value='<%=base.getUse_yn()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='s_id' value='<%=s_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='cont_st' value='<%=cont_st%>'>
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 
<input type='hidden' name='type' value='<%=type%>'> 
<input type='hidden' name="s_dept_id" value=''>
<input type='hidden' name='dt' value="<%=dt%>">
<input type='hidden' name='gubun2' value="<%=gubun2%>">
<input type='hidden' name='ref_dt1' value="<%=ref_dt1%>">
<input type='hidden' name='ref_dt2' value="<%=ref_dt2%>"> 
 
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
                    <td width="30%" class=b>&nbsp;
					<%=base.getRent_l_cd()%></td>
                    <td class=title width="15%">계약일자</td>
                    <td width="30%" class=b>&nbsp;
					<%=base.getRent_dt()%></td>
				</tr>
				<tr>
                    <td class=title width="100">계약구분</td>
                    <td class=b>&nbsp; 
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
				</tr>
				<tr>
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
                    <td class=b>&nbsp;
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
					<%=base.getCon_mon()%>개월 </td>
                    <td width="100" align="center" class=title>대여기간</td>
                    <td class=b>&nbsp;
                    <%=base.getRent_start_dt()%>
                    ~
                    <%=base.getRent_end_dt()%></td>
                
                </tr>
                <tr> 
                    <td width="110" align="center" class=title>최초영업자</td>
                    <td width="160" class=b>&nbsp;
						<%=c_db.getNameById(base.getBus_id(),"USER")%> <br/>
                    	<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %>&nbsp;(계약진행담당자:<%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)<%}%>
					</td>
                    <td width="110" align="center" class=title>영업대리인</td>
                    <td width="160" class=b>&nbsp;
					<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
				</tr>
                <tr>
                    <td width="100" align="center" class=title>영업담당자</td>
                    <td width="160" class=b>&nbsp;
					<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>    
                    </td>
                    <td width="100"  class=title align="center">관리담당자</td>
                    <td width="160"  class=b>&nbsp;
					<%=c_db.getNameById(base.getMng_id(),"USER")%></td>
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
        <td class=h align='left'> <label><i class="fa fa-check-circle"></i> 기본사항 </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='15%' class='title'>고객구분</td>
                    <td width='30%' align='left'>&nbsp;
						<% if(client.getClient_st().equals("1")){%>법인
						<% }else if(client.getClient_st().equals("2")){%>개인
						<% }else if(client.getClient_st().equals("3")){%>개인사업자(일반과세)
						<% }else if(client.getClient_st().equals("4")){%>개인사업자(간이과세)
						<% }else if(client.getClient_st().equals("5")){%>개인사업자(면세사업자)
						<% }%>
					</td>
                    <td width='15%' class='title'>상호</td>
                    <td width='30%' align='left'>&nbsp;
					<%=client.getFirm_nm()%></td>
				</tr>
                <tr>	
                    <td width='100' class='title'>대표자</td>
                    <td align='left'>&nbsp;<%=client.getClient_nm()%></td>
                    <td width="110" class='title'>사업자번호</td>                    
                    <td width="180" align='left'>&nbsp;
					<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
				</tr>
                <tr>                 
                    <td width="100" class='title'>생년월일</td>
                    <td width="180" align='left'>&nbsp;
					<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******</td>
                    <td width='100' class='title'>Homepage</td>
                    <td align='left'>&nbsp; 
                      <%if(!client.getHomepage().equals("") && client.getHomepage().length() > 7){%>
                      <a href="<%=client.getHomepage()%>" target="_bank"> <%=client.getHomepage()%></a> 
                      <%}else{%>
                      <%=client.getHomepage()%>
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>사무실전화</td>
                    <td width="180" align='left'>&nbsp;
					<%= client.getO_tel()%></td>
                    <td width="100" class='title'>FAX 번호</td>
                    <td width="180" align='left'>&nbsp;
					<%= client.getFax()%>&nbsp; </td>
				</tr>
                <tr> 	
                    <td class='title' width="100">개업년월일</td>
                    <td class='left'>&nbsp; <%= client.getOpen_year()%></td>
                    <td width="110" class='title'>자본금</td>
                    <td width="180" align='left'>&nbsp;
					<%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"백만원/"+client.getFirm_day());%></td>
				</tr>
                <tr> 	
                    <td width="100" class='title'>연매출</td>
                    <td width="180">&nbsp;
					<%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"백만원/"+client.getFirm_day_y());%></td>
                    <td width="100" class='title'>발행구분</td>
                    <td>&nbsp;
						<% if(client.getPrint_st().equals("1")){%>계약건별
						<% }else if(client.getPrint_st().equals("2")){%>거래처통합
						<% }else if(client.getPrint_st().equals("3")){%>지점통합
						<% }else if(client.getPrint_st().equals("4")){%>현장통합
						<% }%>
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>업태</td>
                    <td width="180" align='left'>&nbsp;
					<%= client.getBus_cdt()%></td>
                    <td width="100" class='title'>종목</td>
                    <td align='left'>&nbsp;
					<%= client.getBus_itm()%></td>
                </tr>
                <tr> 
                    <td width="110" class='title'>사업장주소</td>
                    <td colspan="3">&nbsp;
					(<%=client.getO_zip()%>) <%=client.getO_addr()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
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
        <td class=h align='left'> <label><i class="fa fa-check-circle"></i> <%= mgr.getMgr_st()%> </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="15%">근무부서</td>
					<td align='' width="30%">&nbsp;
					<%= mgr.getMgr_dept()%></td>
                    <td class=title width="15%">성명</td>
                    <td align='' width="30%">&nbsp;
					<%= mgr.getMgr_nm()%></td>
				</tr>
				<tr>
					<td class=title width="80">직위</td>
					<td align=''>&nbsp;
					<%= mgr.getMgr_title()%></td>
                    <td class=title width="100">전화번호</td>
					<td align=''>&nbsp;
					<%= mgr.getMgr_tel()%></td>
				</tr>
				<tr>
                    <td class=title width="100">휴대폰</td>
					<td align=''>&nbsp;
					<%= mgr.getMgr_m_tel()%></td>
                    <td class=title width="201">E-MAIL</td>
					<td align=''>&nbsp;
					<%= mgr.getMgr_email()%></td>
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
        <td align='left'><label><i class="fa fa-check-circle"></i> 차량기본사항 </label></td>
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
					<td width="30%">&nbsp;
					<%=car_fee.get("CAR_NO")%></td>
					<td class='title' width='15%'> 자동차회사 </td>
					<td width="30%">&nbsp;
					<%=mst.getCar_comp_nm()%></td>
				</tr>
				<tr>
					<td class='title' width="100">차명</td>
					<td width="180">&nbsp;
					<%=mst.getCar_nm()%></td>
					<td class='title' width='100'>차종</td>
					<td>&nbsp;
					<%=mst.getCar_name()%></td>
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
        <td class=h align='left'><label><i class="fa fa-check-circle"></i> 정비내역 </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr> 
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>                   
				<tr> 
					<td class='title' width='15%'> 정비일 </td>
					<td width='30%'>&nbsp;
					<%=serv_dt%></td>
					<td class='title' width='15%'> 결재 </td>
					<td width='30%'>&nbsp;
					<%=p_gubun%></td>
				</tr>
				<tr>
					<td class='title' width='110'> Call 대상자 </td>
					<td >&nbsp;
					<%=call_t_nm%></td>
					<td class='title' width="110">연락처</td>
					<td >&nbsp;
					<%=call_t_tel%></td>                              
				</tr>     
				<tr> 

					<td class='title' width="110">정비업체</td>
					<td >&nbsp;
					<%=off_nm%></td>      
					<td class='title' width='110'> 금액 </td>
					 <td >&nbsp;
					 <%=Util.parseDecimal(buy_amt)%></td>
				</tr>             
				<tr>
					<td class='title' width='15%'> 정비내용 </td>
					<td colspan="3">&nbsp;
					<%=serv_item_nm%></td>
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
