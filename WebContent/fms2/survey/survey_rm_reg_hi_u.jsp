<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.common.*, acar.call.*, acar.util.*,acar.client.*, acar.car_mst.*, acar.user_mng.*, acar.cls.*, acar.credit.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
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
	
	
	//임의연장
	Vector im_vt = af_db.getFeeImList(m_id, l_cd, "");
	int im_vt_size = im_vt.size();
	
	
	
	//고객정보
	ClientBean client 		= al_db.getClient(base.getClient_id());

	//해지정보
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	
	//해지의뢰정보
	ClsEtcBean clss = ac_db.getClsEtcCase(m_id, l_cd);
	
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--


	
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
                    <td width="30%" class=b>&nbsp;<%=base.getRent_l_cd()%></td>
                    <td class=title width="15%">계약일자</td>
                    <td width="30%" class=b>&nbsp;<%=base.getRent_dt()%></td>
				</tr>
				<tr>
                    <td class=title width="10%">계약구분</td>
                    <td  colspan="" class=b>&nbsp; 
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
                    <td align="center" width="10%" class=title>대여구분</td>
                    <td width="30%" class=b>&nbsp;
                      <select name="s_car_st" onChange='javascript:set_con_cd()' disabled >
                        <%if(base.getCar_st().equals("1") || base.getCar_st().equals("3")){%>
                        <option value="1" <%if(base.getCar_st().equals("1")){%>selected<%}%>>렌트</option>
                        <option value="3" <%if(base.getCar_st().equals("3")){%>selected<%}%>>리스</option>
                        <%}else if(base.getCar_st().equals("2")){%>
                        <option value="2" <%if(base.getCar_st().equals("2")){%>selected<%}%>>보유</option>
						<%}else if(base.getCar_st().equals("4")){%>
                        <option value="4" <%if(base.getCar_st().equals("4")){%>selected<%}%>>월렌트</option>
                        <%}%>
						</select>
					</td>
				</tr>
                <tr>
                    <td width="10%" align="center" class=title>대여방식</td>
                    <td width="30%" class=b>&nbsp;
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
                    <td width="10%" align="center" class=title>영업구분</td>
                    <td width="30%" class=b>&nbsp;
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
                    <td width="10%" align="center" class=title>대여개월</td>
                    <td width="30%" class=b>&nbsp;<%=base.getCon_mon()%>개월 </td>
                    <td width="10%" align="center" class=title>대여기간</td>
                    <td width="30%" class=b>&nbsp;<%=base.getRent_start_dt()%>	~	<%=base.getRent_end_dt()%></td>
                </tr>
                <tr> 
                    <td width="10%" align="center" class=title>최초영업자</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td width="10%" align="center" class=title>영업대리인</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
				</tr>
				<tr>
                    <td width="10%" align="center" class=title>영업담당자</td>
                    <td width="30%" class=b>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>    
                    <td width="10%"  class=title align="center">관리담당자</td>
                    <td width="30%"  class=b>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%></td>
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
        <td class=h><label><i class="fa fa-check-circle"></i> 고객 </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='15%' class='title'>고객구분</td>
                    <td width='30%' align='left'>&nbsp;<% if(client.getClient_st().equals("1")){%>법인
						<% }else if(client.getClient_st().equals("2")){%>개인
						<% }else if(client.getClient_st().equals("3")){%>개인사업자(일반과세)
						<% }else if(client.getClient_st().equals("4")){%>개인사업자(간이과세)
						<% }else if(client.getClient_st().equals("5")){%>개인사업자(면세사업자)
						<% }%> 
					</td>
                    <td width='15%' class='title'>상호</td>
                    <td width='30%' align='left'>&nbsp;<%=client.getFirm_nm()%></td>
				</tr>
                <tr>	
                    <td width='10%' class='title'>대표자</td>
                    <td width='30%' align='left'>&nbsp;<%=client.getClient_nm()%></td>
                    <td width="" class='title'>사업자번호</td>
                    <td width="" align='left'>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%> </td>
				</tr>
                <tr>
                    <td width="" class='title'>생년월일</td>
					<td width="" align='left'>&nbsp;<%=client.getSsn1()%>-******* </td>
                    <td width='' class='title'>Homepage</td>
                    <td align='left'>&nbsp; 
                      <%if(!client.getHomepage().equals("") && client.getHomepage().length() > 7){%>
                      <a href="<%=client.getHomepage()%>" target="_bank"><%=client.getHomepage()%></a> 
                      <%}else{%>
                      <%=client.getHomepage()%>
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width="" class='title'>사무실전화</td>
                    <td width="" align='left'>&nbsp;<%= client.getO_tel()%></td>
                    <td width="" class='title'>FAX 번호</td>
                    <td width="" align='left'>&nbsp;<%= client.getFax()%></td>
				</tr>
                <tr>
                    <td class='title' width="10%">개업년월일</td>
                    <td class='left'>&nbsp;<%= client.getOpen_year()%></td>
                    <td width="" class='title'>자본금</td>
                    <td width="" align='left'>&nbsp;<%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"백만원/"+client.getFirm_day());%></td>
				</tr>
                <tr>                
                    <td width="" class='title'>연매출</td>
                    <td width="">&nbsp;<%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"백만원/"+client.getFirm_day_y());%> </td>
                    <td width="" class='title'>발행구분</td>
                    <td>&nbsp;<% if(client.getPrint_st().equals("1")){%>계약건별
						<% }else if(client.getPrint_st().equals("2")){%>거래처통합
						<% }else if(client.getPrint_st().equals("3")){%>지점통합
						<% }else if(client.getPrint_st().equals("4")){%>현장통합
						<% }%>
                    </td>
                </tr>
                <tr> 
                    <td width="10%" class='title'>업태</td>
                    <td width="" align='left'>&nbsp;<%= client.getBus_cdt()%></td>
                    <td width="10%" class='title'>종목</td>
                    <td align='left'>&nbsp;<%= client.getBus_itm()%></td>
                </tr>
                <tr> 
                    <td width="10%" class='title'>사업장주소</td>
                    <td colspan="3">&nbsp;(<%=client.getO_zip()%>)&nbsp;<%=client.getO_addr()%></td>
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
        <td class=h><label><i class="fa fa-check-circle"></i> <%= mgr.getMgr_st()%> </label></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="15%">근무부서</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_dept()%></td>
                    <td class=title width="15%">성명</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_nm()%></td>
				</tr>	
				<tr>
                    <td class=title width="15%">직위</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_title()%></td>
                    <td class=title width="15%">전화번호</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_tel()%></td>
				</tr>	
				<tr>
                    <td class=title width="15%">휴대폰</td>
					<td width="30%">&nbsp;
					<%= mgr.getMgr_m_tel()%></td>
                    <td class=title width="15%">E-MAIL</td>
					<td width="30%">&nbsp;
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
    <tr id='write'> 
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td class='line'>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>                   
                            <tr> 
                                <td class='title' width="15%"> 차량번호 </td>
                                <td width="30%">&nbsp;<%=car_fee.get("CAR_NO")%></td>
                                <td class='title' width="15%"> 자동차회사 </td>
                                <td width="30%">&nbsp;<%=mst.getCar_comp_nm()%></td>
							</tr>
							<tr>
                                <td class='title' width="100">차명</td>
                                <td width="30%">&nbsp;<%=mst.getCar_nm()%></td>
                                <td class='title' width='100'>차종</td>
                                <td width="30%">&nbsp;<%=mst.getCar_name()%></td>
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
        <td class=h></td>
    </tr>
	<%if(im_vt_size>0){%>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> 대여기간 </label></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr> 
		<td colspan="3" width="90%" class=line> 
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				  <tr> 
					<td class=title width="13%">연번</td>
					<td class=title width="10%">회차</td>			
					<td class=title width="37%">대여기간</td>
					<td class=title width="15%">등록자</td>
					<td class=title width="20%">등록일</td>                    
				  </tr>
				  <%	for(int i = 0 ; i < im_vt_size ; i++){
							Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
				  <tr> 
					<td align='center'><%=i+1%></td>
					<td align='center'><%=im_ht.get("ADD_TM")%>회차</td>
					<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
					<td align='center'><%=im_ht.get("USER_NM")%></td>
					<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("REG_DT")))%></td>
				  </tr>
				  <%	} %>
			</table>
		</td>
	</tr>				
	<tr>
        <td class=h></td>
    </tr>
	<%}%>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=h><label><i class="fa fa-check-circle"></i> 해지정보 </label></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr> 
					<td width='15%' class='title'>해지구분</td>
					<td width="23%" align='center'><%if(cls.getCls_st().equals("월렌트해지")){%>월렌트해지<%}%></td>
					<td width='15%' class='title'>해지일</td>
					<td width="23%" align='center'><%=cls.getCls_dt()%></td>
				</tr>
				<tr> 
					<td class='title' width="15%">이용기간</td>
					<td width="23%" align='center'><%=cls.getR_mon()%>개월 <%=cls.getR_day()%>일</td>
					<td width='10%' class='title'>선납금<br>납입방식</td>
					<td align='center'><% if(cls.getPp_st().equals("1")){%>
							3개월치 대여료 선납식
						<%}else if(cls.getPp_st().equals("2")){%>
							고객 선택형 선납식
						<%}%>
					</td>
				</tr>
				<tr> 
					<td width='15%' class='title'>정산서<br>작성여부 </td>
					<td align='center'><% if(cls.getCls_doc_yn().equals("N")){%>
							없음
						<%}else if(cls.getCls_doc_yn().equals("Y")){%>
							있음
						<%}%>
					</td>
					<td width='15%' class='title'>잔여선납금<br>매출취소여부</td>
					<td align='center'> <% if(cls.getCancel_yn().equals("N")){%>
							매출유지
						<%}else if(cls.getCancel_yn().equals("Y")){%>
							매출취소
						<%}%>
					</td>			
				</tr>
				<tr> 
					<td width='15%' class='title'>해지내역 </td>
					<td colspan="3" align='center'><br><%=cls.getCls_cau()%><br>&nbsp;</td>
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
        <td class=h><label><i class="fa fa-check-circle"></i> 미납입금액 정산</label></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr> 
		<td class='line'>
		  <table border="0" cellspacing="1" cellpadding="0" width="100%">
			<tr> 
			  <td class="title" colspan="4">항목</td>
			  <td class="title" width='30%'>내용</td>
			  <td class="title" width='35%'>비고</td>
			</tr>
			<tr> 
			  <td class="title" rowspan="18" width="5%">미<br>
				납<br>
				입<br>
				금<br>
				액</td>
			  <td colspan="3" class="title">과태료/범칙금(D)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getFine_amt())%>원&nbsp; </td>
			  <td class='title' width='35%'>&nbsp;</td>
			</tr>
			 <tr> 
			  <td colspan="3" class="title">자기차량손해면책금(E)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>원&nbsp; </td>
			  <td class='title' width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td class="title" rowspan="5" width="5%"><br>
				대<br>
				여<br>
				료</td>
			  <td align="center" colspan="2">과부족</td>
			  <td width='30%' align="right">&nbsp; 
				<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>원&nbsp; </td>
			  <td width='35%'>&nbsp; </td>
			</tr>
			<tr> 
			  <td rowspan="2" align="center" width="10%">미납입</td>
			  <td width='5%' align="center">기간</td>
			  <td width='30%' align="center"> 
				<%=cls.getNfee_mon()%>개월 &nbsp; <%=cls.getNfee_day()%>일 </td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td align="center">금액</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getNfee_amt())%>원&nbsp; </td>
			  <td width='35%'>매출 세금계산서 발행</td>
			</tr>
			<tr> 
			  <td colspan="2" align="center">연체료</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getDly_amt())%>원&nbsp; </td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td class="title" colspan="2">대여료(F)</td>
			  <td class='title' width='30%' style="text-align:right;">
				원 </td>
			  <td class='title' width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td rowspan="6" class="title">중<br>
				도<br>
				해<br>
				지<br>
				위<br>
				약<br>
				금</td>
			  <td align="center" colspan="2">대여료총액</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getTfee_amt())%>원&nbsp;</td>
			  <td width='35%'>=선납금+월대여료총액</td>
			</tr>
			<tr> 
			  <td align="center" colspan="2">월대여료(환산)</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getMfee_amt())%>원&nbsp;</td>
			  <td width='35%'>=대여료총액÷계약기간</td>
			</tr>
			<tr> 
			  <td align="center" colspan="2">잔여대여계약기간</td>
			  <td width='30%' align="center"> 
				<%=cls.getRcon_mon()%>개월 <%=cls.getRcon_day()%>일</td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td align="center" colspan="2">잔여기간 대여료 총액</td>
			  <td width='30%' align="right"> 
				<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>원&nbsp;</td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td align="center" colspan="2">위약금 적용요율</td>
			  <td width='30%' align="center"> 
				<%=cls.getDft_int()%>%</td>
			  <td width='35%'>잔여기간 대여료 총액 기준</td>
			</tr>
			<tr> 
			  <td  class="title" colspan="2">중도해지위약금(G)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getDft_amt())%>원&nbsp;</td>
			  <td align="left"><%if(clss.getTax_chk0().equals("Y")){%>중도해지위약금 계산서 발행<%}%></td>
			</tr>
			<tr> 
			 <td class="title" rowspan="5" width="5%"><br>
				기<br>
				타</td> 
			  <td colspan="2" class="title">차량회수외주비용(H)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getEtc_amt())%>원 &nbsp;</td>
			   <td align="left"><%if(clss.getTax_chk1().equals("Y")){%>차량회수외주비용 계산서 발행<%}%></td>
			</tr>
			<tr> 
			  <td colspan="2" class="title">차량회수부대비용(I)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>원 &nbsp;</td>
			  <td align="left"><%if(clss.getTax_chk2().equals("Y")){%>차량회수부대비용 계산서 발행<%}%></td>
			</tr>
			<tr> 
			  <td colspan="2" class="title">잔존차량가격(J)</td>
			  <td class='title' width='30%' style="text-align:right;"> 
				<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>원 &nbsp;</td>
			  <td width='35%'>&nbsp;</td>
			</tr>
			<tr> 
			  <td colspan="2" class="title">기타손해배상금(K)</td>
			  <td class='title' width='30%' style="text-align:right;"><%=AddUtil.parseDecimal(cls.getEtc4_amt())%>원&nbsp; </td>
			  <td align="left"><%if(clss.getTax_chk3().equals("Y")){%>기타손해배상금 계산서 발행<%}%></td>
			</tr>
			<tr> 
				<td colspan="2" class="title">부가세(L)</td>
				<td class='title' width='30%' style="text-align:right;"><%=AddUtil.parseDecimal(cls.getNo_v_amt())%>원&nbsp; </td>
				<td class='title' width='35%'>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr> 
							<td style="display:''" class='title'>=(미납입금액-B-C)×10% </td>
							<td style='display:none' class='title'>=(미납입금액-B-C)×10% </td>
						</tr>
					</table>
				</td>
			</tr>
			<tr> 
				<td class="title" colspan="4">계(J)</td>
				<td class='title' width='30%' style="text-align:right;"><%=AddUtil.parseDecimal(cls.getFdft_amt1())%>원&nbsp; </td>
				<td class='title' width='35%'>=(D+E+F+G+H+I+J+K+L)</td>
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
