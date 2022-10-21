<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, acar.fee.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	
	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean fees = fee;
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	ContCarBean fee_etcs = fee_etc;
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	
	
	
	//자동차회사 리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAllNew("1");
	
	//차종리스트
	Vector cars = cmb.getSearchCodeNew(cm_bean.getCar_comp_id(), "", "", "", "1", "", "");
	int car_size = cars.size();
		
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//고객 보기
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 보기
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
		
	//기존차 조회
	function car_search()
	{
		var fm = document.form1;
		window.open("search_ext_car.jsp?from_page=/fms2/lc_rent/lc_cng_car_frame.jsp&rent_dt=<%=base.getRent_dt()%>", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");
	}	
	
	//중고차가격 계산하기-숨어서(재리스)
	function getSecondhandCarAmt_h(){
		var fm = document.sh_form;
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "i_no";
		fm.submit();
	}			

	function save(){
		var fm = document.form1;
		
		if(fm.car_mng_id.value == ''){ alert('차량번호를 조회하여 선택하십시오.'); return; }
		
		if(fm.car_mng_id.value == '<%=base.getCar_mng_id()%>'){ alert('기존 계약차량입니다. 다른 차량를 조회하여 입력하십시오.'); return; }		
		
		if(fm.sh_amt.value == '' || fm.sh_amt.value == '0'){
			getSecondhandCarAmt_h();
		}
			
		if(confirm('수정하시겠습니까?')){		
			fm.action='lc_cng_new_car_c_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}		
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
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name="mode"				value="lc_rent">
  <input type='hidden' name="rent_dt"			value="<%=base.getRent_dt()%>">  
  <input type='hidden' name="rent_st"			value="1">  
  <input type='hidden' name="a_b"				value="<%=fee.getCon_mon()%>">
  <input type='hidden' name="fee_opt_amt"		value="">
  <input type='hidden' name="cust_sh_car_amt"	value="">
</form>
<form action="get_car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_origin" value="">
  <input type="hidden" name="car_comp_id" value="">  
  <input type="hidden" name="code" value="">
  <input type="hidden" name="car_id" value="">
  <input type="hidden" name="view_dt" value="">    
  <input type="hidden" name="t_wd" value="">      
  <input type="hidden" name="auth_rw" value="">
  <input type="hidden" name="mode" value="">
</form>
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 				value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 				value="<%=rent_l_cd%>">  
  <input type='hidden' name="from_page" 		value="/fms2/lc_rent/lc_cng_car_frame.jsp">
  
  <input type="hidden" name="idx"         		value="reset_car">
  <input type='hidden' name='o_1_s_amt' 		value=''>
  <input type='hidden' name='o_1_v_amt' 		value=''>
  <input type='hidden' name='s_st' 				value='<%=cm_bean.getS_st()%>'>
  <input type='hidden' name='dpm' 				value='<%=cm_bean.getDpm()%>'> 

  <input type="hidden" name="bc_b_e1"   		value="">
  <input type="hidden" name="bc_b_e2"   		value="">  
  
  
    
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
                    <td class=title>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<b><%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></b></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}%></td>
                </tr>
                <tr>
                    <td class=title>상호</td>
                    <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a></td>
                    <td class=title>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>지점/현장</td>
                    <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=site.getR_site()%></a></td>
                </tr>
                <tr>
                    <td class=title>차량번호</td>
                    <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title width=10%>차명</td>
                    <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(차종코드:<%=cm_bean.getJg_code()%>)</font>
        			</td>
                </tr>		  
            </table>
	    </td>
    </tr>
	<tr>
        <td></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경차종</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan="2" class='title'>항목</td>
                    <td width="70%" class='title'>선택</td>
                    <td width="17%" class='title'>금액</td>
                </tr>
                <tr id=td_con_cd style='display:none'> 
                    <td colspan='2' class='title'>변경 계약번호</td>
                    <td><table width="100%" border="0" cellpadding="0">
                        <tr>
                          <td>&nbsp;
						  	<input type='text' class='fix' name='con_cd3' size='1' value='' readonly>
                      		-
                      		<input type='text' class='fix' name='con_cd4' size='2' value='' readonly>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>	
                <tr> 
                    <td colspan='2' class='title'>차량번호</td>
                    <td><table width="100%" border="0" cellpadding="0">
                        <tr>
                          <td>&nbsp;
						 	<input type='text'   name='car_no' class='fix' size='15' value='<%=cr_bean.getCar_no()%>' readonly>
        			  		<input type='hidden' name='car_mng_id' value='<%=cr_bean.getCar_mng_id()%>'>
        			  		<input type='hidden' name='old_rent_mng_id' value=''>
        			  		<input type='hidden' name='old_rent_l_cd' value=''>			  
                      		<a href="javascript:car_search();"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a> 	
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>										
                <tr> 
                    <td width="3%" rowspan="7" class='title'>자<br>
                    동<br>차</td>
                    <td width="10%" class='title'>출처</td>
                    <td>
						<table width="100%" border="0" cellpadding="0">
                        	<tr>
                          		<td>&nbsp;							
                            		<input type='text' name="car_origin_nm" size='60' class='fix'  value='<%if(car.getCar_origin().equals("1")){%>국산<%}else if(car.getCar_origin().equals("2")){%>수입<%}%>' readonly>							
									<input type='hidden' name='car_origin' value='<%=car.getCar_origin()%>'>
								</td>
                        	</tr>
                      	</table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>제작회사</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td>&nbsp;
									<input type='text' name="car_comp_nm" size='60' class='fix'  value='<%=cm_bean.getCar_comp_nm()%>' readonly>							
									<input type='hidden' name='car_comp_id' value='<%=cm_bean.getCar_comp_id()%>'>								
            				    </td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>차명</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td>&nbsp;          
									<input type='text' name="car_nm" size='60' class='fix'  value='<%=cm_bean.getCar_nm()%>' readonly>							
									<input type='hidden' name='code' value='<%=cm_bean.getCode()%>'>								
            					&nbsp; </td>
                            </tr>
                        </table> 
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>차종</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td>&nbsp;
                				  	<input type='text' name="car_name" size='60' class='fix' value="<%=cm_bean.getCar_name()%>" readonly>
			  						<input type='hidden' name='car_id' value='<%=cm_bean.getCar_id()%>'>
			  						<input type='hidden' name='car_seq' value='<%=cm_bean.getCar_seq()%>'>
									<input type='hidden' name='car_s_amt' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>'>
									<input type='hidden' name='car_v_amt' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>'>
								</td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='car_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='15' class='fixnum' readonly>
        			  원</td>
                </tr>
                <tr> 
                    <td class='title'>옵션</td>
                    <td>
        			    <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_42 style="display:''">&nbsp;
            				    	<input type='text' name="opt" size='60' class='fix' value="<%=car.getOpt()%>" readonly>
				  		    		<input type='hidden' name='opt_seq' value='<%=car.getOpt_code()%>'>
				  		    		<input type='hidden' name='opt_s_amt' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>'>
				  		    		<input type='hidden' name='opt_v_amt' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>'>
				  				</td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='opt_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='13' class='fixnum' readonly>
        			  원</td>
                </tr>
                <tr> 
                    <td class='title'>색상</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_52 style="display:''">&nbsp;
            				    	<input type='text' name="col" size='60' class='fix' value="<%=car.getColo()%>" readonly>
            				    	(내장색상(시트): <input type='text' name="in_col" size='20' class='fix' value='<%=car.getIn_col()%>' readonly> )            				    	
            				    	(가니쉬: <input type='text' name="garnish_col" size='20' class='fix' value='<%=car.getGarnish_col()%>' readonly> )            				    	
				  					<input type='hidden' name='col_seq' value=''>
				  					<input type='hidden' name='col_s_amt' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>'>
				  					<input type='hidden' name='col_v_amt' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>'>
				  				</td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='col_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='13' class='fixnum' readonly>
        			  원</td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>차량가격</td>
                    <td align="center"><input type='text' name='o_1' size='10' value='' maxlength='13' class='fixnum' readonly>					
    				원
					</td>
                </tr>				
            </table>
	    </td>
    </tr>	
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	fm.o_1.value 		= parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)));
	fm.o_1_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_s_amt.value)) + toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.col_s_amt.value)));
	fm.o_1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_v_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)) + toInt(parseDigit(fm.col_v_amt.value)));		
	
//-->
</script>	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중고차가</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> 신차소비자가 </td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='' size='10' class='defaultnum' readonly>
        				  원&nbsp;</td>
                    <td class='title' width="10%">잔가율</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='sh_ja' value=''size='4' class='defaultnum' readonly>%</td>
                    <td class='title' width='10%'>중고차가</td>
                    <td>&nbsp;
                      <input type='text' name='sh_amt' value=''size='10' class='defaultnum' readonly>원</td>
                </tr>
                <tr>
                  <td class='title'>차령</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_year' value='' size='1' class='white' readonly>
                    년
                    <input type='text' name='sh_month' value='' size='2' class='white' readonly>
                    개월
                    <input type='text' name='sh_day' value='' size='2' class='white' readonly>
                    일 (<input type='text' name='sh_init_reg_dt' value='' size='11' class='white' readonly> ~
                    <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(base.getRent_dt())%>' size='11' class='white' readonly>
                  )</td>
                </tr>
                <tr>
                  <td class='title'>적용주행거리</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='' class='defaultnum' >
					km
					/ 확인주행거리 <input type='text' name='sh_tot_km' size='6' value='' class='defaultnum' >
					km(
					<input type='text' name='sh_km_bas_dt' size='11' value='' class='default' >
					)</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td>※ 등록후 <font color=red><b>미결현황</b></font>으로 넘어갑니다.</td>
    </tr>
    <tr>
        <td>※ 미결현황에서 변경된 차종에 맞게 <font color=red><b>대여요금 / 계약서 스캔등록</b></font> 등을 처리하세요.</td>
    </tr>
    <tr>
        <td>※ 영업팀장님 결재는 초기화 합니다. 수정 완료후 결재요청 하세요.</td>
    </tr>
    <tr>
        <td>※ <font color=red><b>재리스 차종변경은 테스트하지 못했습니다. 전산팀 정현미대리에게 등록의뢰하거나, 직접등록후 정상처리되지 않았을 경우 문의하여 주세요.</b></font></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>	
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
    </tr>	
    <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
//-->
</script>
</body>
</html>
