<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*, acar.car_mst.*, acar.user_mng.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"":request.getParameter("r_st");
		
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String url = "http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+r_st;
	String short_url = ShortenUrlGoogle.getShortenUrl(url);
	
	String client_fms_url = "https://fms.amazoncar.co.kr/service/index.jsp";
	String fms_short_url = ShortenUrlGoogle.getShortenUrl(client_fms_url);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//매니저정보
	UsersBean mng_user_bean = umd.getUsersBean(base.getMng_id());
	
	//은행계좌번호
	Vector banks = neoe_db.getFeeDepositList();
	int bank_size = banks.size();
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//자동이체정보
	ContCmsBean cms 	= a_db.getCmsMng(m_id, l_cd);
	
	// 대여차량
	cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	
	//연체료 세팅
	Vector dly_cont = af_db.getFeeDlyContViewClientList(base.getClient_id());
	int dly_cont_size = dly_cont.size();	
	for(int i = 0 ; i < dly_cont_size ; i++){
		Hashtable ht = (Hashtable)dly_cont.elementAt(i);
		boolean dly_flag = af_db.calDelayDtPrint(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), String.valueOf(ht.get("CLS_DT")), String.valueOf(ht.get("RENT_DT")));
	}	

	//[계약별]대여료스케줄
	Vector fee_scds2 = af_db.getFeeScdDlySettleList(m_id, l_cd);
	int scd_size2 = fee_scds2.size();
		
	//[계약별]대여료통계
	Hashtable fee_stat = af_db.getFeeScdStatPrint(m_id, l_cd);
	
	//[거래처별]대여료스케줄
	Vector fee_scds = af_db.getFeeScdDlySettleClientList(base.getClient_id());
	int scd_size = fee_scds.size();
	
	//[거래처별]대여료연체료 통계
	Vector dly_scds = af_db.getFeeScdDlyStatClient(base.getClient_id());
	int dly_size = dly_scds.size();
	
	//면책금
	Vector serv_scds = af_db.getServScdStatClient(base.getClient_id());
	int serv_size = serv_scds.size();
	
	//과태료
	Vector fine_scds = af_db.getFineScdStatClient(base.getClient_id());
	int fine_size = fine_scds.size();
	
	//해지정산금
	Vector cls_scds = af_db.getClsScdStatClient(base.getClient_id());
	int cls_size = cls_scds.size();
	
	//선수금
	Vector grt_scds = af_db.getGrtScdStatClient(base.getClient_id());
	int grt_size = grt_scds.size();
	//20210708 선수금 제외처리
	grt_size = 0;
		
	long total_amt1 	= 0;
	long total_amt2 	= 0;
	long total_amt3 	= 0;
	long total_amt4 	= 0;
	long total_amt5 	= 0;
	long total_amt6 	= 0;
	long total_amt7 	= 0;
	long total_amt8 	= 0;
	long total_amt9 	= 0;
	long total_amt10 	= 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function setSmsMsg(idx){
		var fm = document.form1;
		
		opener.document.form1.msg_subject.value = "bond";
		opener.document.form1.customer_name.value = fm.customer_name.value;
		/* opener.document.form1.car_no.value = fm.car_no.value;
		opener.document.form1.car_nm.value = fm.car_nm.value;
		opener.document.form1.short_url.value = fm.short_url.value; */
		
		//계약별
		if(idx==1){
			opener.document.form1.bond_msg_type.value = "contract";
			
			opener.document.form1.car_no.value = fm.car_no.value;
			opener.document.form1.car_nm.value = fm.car_nm.value;
			opener.document.form1.short_url.value = fm.short_url.value;
			
			opener.document.form1.msg.value = fm.msg1.value;
			
			opener.document.form1.cur_date.value = fm.cur_date_1.value;
			opener.document.form1.unpaid.value = fm.unpaid_1.value;
			opener.document.form1.bank_full.value = fm.bank_full_1.value;
			
			opener.document.form1.manager_name.value = fm.manager_name.value;
			opener.document.form1.manager_phone.value = fm.manager_phone.value;
			
		//고객별
		}else{
			opener.document.form1.bond_msg_type.value = "client";
			
			opener.document.form1.car_no.value = fm.car_no2.value;
			opener.document.form1.car_nm.value = fm.car_nm2.value;
			opener.document.form1.car_count.value = fm.car_count.value;
			opener.document.form1.car_num_name_count.value = fm.car_num_name_count.value;
			opener.document.form1.short_url.value = fm.fms_short_url.value;
			
			opener.document.form1.msg.value = fm.msg2.value;
			
			opener.document.form1.cur_date.value = fm.cur_date_2.value;
			opener.document.form1.unpaid.value = fm.unpaid_2.value;
			opener.document.form1.bank_full.value = fm.bank_full_2.value;
		}
		
		<%if(!from_page.equals("/fms2/ars_card/ars_req_c.jsp")){%>
		opener.checklen();
		<%}%>
		
		self.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='scd_size' value=''>
<input type='hidden' name='s_cnt' value='<%=s_cnt%>'>
<input type='hidden' name='h_fee_amt1' value=''>
<input type='hidden' name='h_dly_amt1' value=''>
<input type='hidden' name='h_fee_amt2' value=''>
<input type='hidden' name='h_dly_amt2' value=''>
<input type="hidden" id="cms_day" value="<%=cms.getCms_day()%>">

<input type='hidden' id="customer_name" name='customer_name' value='<%=client.getFirm_nm()%>'>
<input type="hidden" id="car_no" name="car_no" value="<%=cr_bean.getCar_no()%>">
<input type="hidden" id="car_nm" name="car_nm" value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">

<input type="hidden" id="car_no2" name="car_no2" value="<%=cr_bean.getCar_no()%>">
<input type="hidden" id="car_nm2" name="car_nm2" value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">

<input type="hidden" id="car_count" name="car_count" value="">
<input type="hidden" id="car_num_name_count" name="car_num_name_count" value="">

<input type='hidden' id="short_url" name='short_url' value='<%=short_url%>'>
<input type='hidden' id="fms_short_url" name='fms_short_url' value='<%=fms_short_url%>'>
<input type='hidden' id="cur_date_1" name='cur_date_1' value=''>
<input type='hidden' id="unpaid_1" name='unpaid_1' value=''>
<input type='hidden' id="bank_full_1" name='bank_full_1' value=''>
<input type='hidden' id="cur_date_2" name='cur_date_2' value=''>
<input type='hidden' id="unpaid_2" name='unpaid_2' value=''>
<input type='hidden' id="bank_full_2" name='bank_full_2' value=''>

<input type='hidden' id="manager_name" name='manager_name' value='<%=c_db.getNameById(base.getMng_id(),"USER")%>'>
<input type='hidden' id="manager_phone" name='manager_phone' value='<%=mng_user_bean.getUser_m_tel()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>당일+연체 채권 메시지<span class=style5> (대여료+연체이자+면책금+과태료+해지정산금)</span></span></td>	
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>상호</td>
                    <td width='85%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title' width='15%'>계좌번호</td>
                    <td>&nbsp;
					  <select name="deposit_no" id="deposit_no">
                        <!-- <option value=''>계좌를 선택하세요</option> -->
					    <%	if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									Hashtable bank = (Hashtable)banks.elementAt(i);%>
						<option value='[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
			            <%		}
							}%>

                      </select>
					</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 문자메시지 : 최대&nbsp;<input class="text" type="text" name="maxmsglen" size="4" maxlength="4" readonly value='2000'>byte
		&nbsp;(디폴트로 당일+연체대여료 합계가 적용되었음, 항목별 회차별 선택하여 문자산정 가능)
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계약별</td>
                    <td colspan="3">&nbsp;
					  <textarea name='msg1' id="msg1" rows='19' cols='65' class='text' onKeyUp="javascript:checklen(1)" readonly style='IME-MODE: active'></textarea>
					  &nbsp;&nbsp;<input type="text" name="msglen1" class='text' size="3" maxlength="3" readonly value=0>byte        	
					  &nbsp;&nbsp;<a href="javascript:setSmsMsg(1);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>	
					  <br>&nbsp;
					  ※ 대여료스케줄표 URL : <%=cr_bean.getCar_no()%> 차량의 장기대여스케줄 안내문			  		    
                    </td>
                </tr>
                <tr>
                  <td class='title'>고객별</td>
                  <td colspan="3">&nbsp;
				    <textarea name='msg2' id="msg2" rows='19' cols='65' class='text' onKeyUp="javascript:checklen(2)" readonly style='IME-MODE: active'></textarea>
					&nbsp;&nbsp;<input type="text" name="msglen2" class='text' size="3" maxlength="3" readonly value=0>byte
					&nbsp;&nbsp;<a href="javascript:setSmsMsg(2);"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
					<br>&nbsp;
					  ※ 대여료스케줄표 URL : <%=client.getFirm_nm()%> 고객FMS 로그인화면 (고객FMS에서 스케줄 확인)	
				  </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td><hr></td>
    </tr>				
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 계약별 당일+연체 대여료 리스트</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<input type='hidden' name='scd_size1' value='<%=scd_size2%>'>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>연번</td>
                    <td class="title" width='15%'>회차</td>					
                    <td class="title" width='20%'>구분</td>					
                    <td class="title" width='25%'>입금예정일</td>
                    <td class="title" width='25%'>금액</td>
                    <!-- <td class="title" width='15%'>연체이자</td> -->
                    <td class="title" width='10%'><input type="checkbox" name="ch_all1" id="ch_all1" value="Y"></td>
                </tr>
				<%	if(scd_size2 > 0){
						for(int i = 0 ; i < scd_size2 ; i++){
							Hashtable fee_scd = (Hashtable)fee_scds2.elementAt(i);
							total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(fee_scd.get("FEE_AMT")));%>
							<input type='hidden' name='fee_amt' value='<%=fee_scd.get("FEE_AMT")%>'>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=fee_scd.get("FEE_TM")%></td><!-- 회차 -->
                    <td align="center"><%=fee_scd.get("TM_ST1_NM")%></td><!-- 구분 -->	
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("R_FEE_EST_DT")))%></td><!-- 입금예정일 -->
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("FEE_AMT")))%>' readonly>원</td><!-- 금액 -->
                    <td align="center"><input type="checkbox" name="ch_cd1" value="<%=String.valueOf(fee_scd.get("FEE_AMT"))%>"></td><!-- 체크박스 -->
                </tr>							
				<%		}
					}%>
				<%
					int dly_tot_amt = AddUtil.parseInt(String.valueOf(fee_stat.get("DT")));
					int dly_pay_amt = AddUtil.parseInt(String.valueOf(fee_stat.get("DT2")));
					total_amt2 	= Long.parseLong(String.valueOf(fee_stat.get("DT"))) - Long.parseLong(String.valueOf(fee_stat.get("DT2")));
				%>	
                <tr>
                    <td align="center"><%=scd_size2+1%></td>								
                    <td colspan="3" align="center">대여료 미수연체이자 합계 </td>
                    <td align="center"><input type='text' name='dly_amt1' size='10' class='num' value='<%=Util.parseDecimal(dly_tot_amt-dly_pay_amt)%>' readonly>원</td>
                    <td align="center"><input type="checkbox" name="ch_dly1"></td><!-- 2018.03.30 -->
                </tr>
                <tr>
                    <td colspan="2" class=title>합계</td>
                    <td colspan="2" class=title>
					대여료 : <input type='text' name='total_fee_amt1' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt1)%>'>원, 
					연체이자 : <input type='text' name='total_dly_amt1' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt2)%>'>원</td>					
                    <td class=title><input type='text' name='total_amt1' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt1+total_amt2)%>'>원</td>
                    <td class=title>&nbsp;<a id="setMsgTotAmt1" href="#">[합계적용]</a></td>
                    <!-- <td class=title>&nbsp;</td> -->
                </tr>																																				
            </table>
        </td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 고객별 5일이내+연체 대여료 리스트</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<input type='hidden' name='scd_size2' value='<%=scd_size%>'>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='5%'>연번</td>
                    <td class="title" width='15%'>차량번호</td>
                    <td class="title" width='15%'>차종</td>					
                    <td class="title" width='5%'>회차</td>
                    <td class="title" width='15%'>구분</td>					
                    <td class="title" width='10%'>입금예정일</td>
                    <td class="title" width='25%'>금액</td>
                    <!-- <td class="title" width='15%'>연체이자</td> -->
                    <td class="title" width='10%'><input type="checkbox" name="ch_all2" id="ch_all2" value="Y"></td>
                </tr>
				
				<%	if(scd_size > 0){
						for(int i = 0 ; i < scd_size ; i++){
							Hashtable fee_scd = (Hashtable)fee_scds.elementAt(i);
							total_amt3 	= total_amt3 + Long.parseLong(String.valueOf(fee_scd.get("FEE_AMT")));%>
							<input type='hidden' name='fee_amt' value='<%=fee_scd.get("FEE_AMT")%>'>	
                <tr>
                    <td align="center"><%=i+1%></td>				
                    <td align="center" class="car_no"><%=fee_scd.get("CAR_NO")%></td>
                    <td align="center" class="car_nm"><%=fee_scd.get("CAR_NM")%></td>					
                    <td align="center"><%=fee_scd.get("FEE_TM")%></td>
                    <td align="center"><%=fee_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("R_FEE_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("FEE_AMT")))%>' readonly>원</td>
                    <td align="center"><input type="checkbox" name="ch_cd2" value="<%=String.valueOf(fee_scd.get("FEE_AMT"))%>"></td>
                </tr>							
				<%		}
					}%>
							
				<%	if(dly_size > 0){
						for(int i = 0 ; i < dly_size ; i++){
							Hashtable dly_scd = (Hashtable)dly_scds.elementAt(i);
							int dly_jan_amt = AddUtil.parseInt(String.valueOf(dly_scd.get("JAN_AMT")));
							total_amt4 	= total_amt4 + Long.parseLong(String.valueOf(dly_scd.get("JAN_AMT")));
							scd_size++;
					%>
                <tr>
				    <td align="center"><%=scd_size%></td>	
                    <td align="center" class="car_no"><%=dly_scd.get("CAR_NO")%></td>
                    <td align="center" class="car_nm"><%=dly_scd.get("CAR_NM")%></td>					
                    <td align="center">-</td>
                    <td colspan="2" align="center">대여료 미수연체이자 합계</td>					
                    <td align="center"><input type='text' name='dly_amt2' size='10' class='num' value='<%=Util.parseDecimal(dly_jan_amt)%>' readonly>원</td>
                    <td align="center"><input type="checkbox" name="ch_dly2"></td>					
                </tr>							
				<%		}
					}%>													
                <tr>
                    <td colspan="2" class=title>합계</td>
					<td colspan="4" class=title>
					대여료 : <input type='text' name='total_fee_amt2' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt3)%>'>원, 
					연체이자 : <input type='text' name='total_dly_amt2' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt4)%>'>원</td>					
                    <td class=title><input type='text' name='total_amt2' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt3+total_amt4)%>'>원</td>
                    <td class=title>&nbsp;<a id="setMsgTotAmt2" href="#">[합계적용]</a></td>	
                    <!-- <td class=title>&nbsp;</td> -->
                </tr>																																				
            </table>
        </td>
    </tr>
	<input type='hidden' name='scd_size3' value='<%=serv_size%>'>
	<%	if(serv_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 고객별 면책금 미수 리스트</td><!-- 2018.04.02 -->
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='5%'>연번</td>
                    <td class="title" width='15%'>차량번호</td>
                    <td class="title" width='15%'>차종</td>					
                    <td class="title" width='5%'>회차</td>
                    <td class="title" width='15%'>구분</td>					
                    <td class="title" width='10%'>입금예정일</td>
                    <td class="title" width='25%'>금액</td>
                    <td class="title" width='10%'><input type="checkbox" name="ch_all3" id="ch_all3" value="Y"></td>										
                </tr>	
				<%	for(int i = 0 ; i < serv_size ; i++){
							Hashtable serv_scd = (Hashtable)serv_scds.elementAt(i);
							total_amt5 	= total_amt5 + Long.parseLong(String.valueOf(serv_scd.get("EXT_AMT")));
					%>
					<input type='hidden' name='serv_amt' value='<%=serv_scd.get("EXT_AMT")%>'>
                <tr>
                    <td align="center"><%=i+1%></td>		
					<td align="center" class="car_no"><%=serv_scd.get("CAR_NO")%></td>
                    <td align="center" class="car_nm"><%=serv_scd.get("CAR_NM")%></td>					
                    <td align="center"><%=serv_scd.get("EXT_TM")%></td>
                    <td align="center"><%=serv_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(serv_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(serv_scd.get("EXT_AMT")))%>'>원</td>
                    <td align="center"><input type="checkbox" name="ch_cd3" value="<%=String.valueOf(serv_scd.get("EXT_AMT"))%>" ></td>					
                </tr>							
				<%	}%>									
                <tr>
                    <td colspan="6" class=title>합계</td>
                    <td class=title><input type='text' name='total_amt3' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt5)%>'>원</td>
                    <td class=title>&nbsp;</td>
                </tr>									
            </table>
        </td>
    </tr>							
	<%}%>	
	<input type='hidden' name='scd_size4' value='<%=fine_size%>'>
	<%	if(fine_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 고객별 과태료 미수 리스트</td><!-- 2018.04.02 -->
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='3%'>연번</td>
                    <td class="title" width='10%'>차량번호</td>
                    <td class="title" width='20%'>위반일자</td>					
                    <td class="title" width='17%'>위반내용</td>
                    <td class="title" width='30%'>위반장소</td>					
                    <td class="title" width='15%'>금액</td>
                    <td class="title" width='5%'><input type="checkbox" name="ch_all4" id="ch_all4" value="Y"></td>										
                </tr>	
				<%	for(int i = 0 ; i < fine_size ; i++){
							Hashtable fine_scd = (Hashtable)fine_scds.elementAt(i);
							total_amt6 	= total_amt6 + Long.parseLong(String.valueOf(fine_scd.get("EXT_AMT")));
					%>
					<input type='hidden' name='fine_amt' value='<%=fine_scd.get("EXT_AMT")%>'>
                <tr>
                    <td align="center"><%=i+1%></td>		
					<td align="center" class="car_no"><%=fine_scd.get("CAR_NO")%><input type="hidden" class="car_nm" value="<%=fine_scd.get("CAR_NM")%>"></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(fine_scd.get("VIO_DT")))%></td>					
                    <td align="center"><%=fine_scd.get("VIO_CONT")%></td>
                    <td align="center"><%=fine_scd.get("VIO_PLA")%></td>					
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fine_scd.get("EXT_AMT")))%>'>원</td>
                    <td align="center"><input type="checkbox" name="ch_cd4" value="<%=String.valueOf(fine_scd.get("EXT_AMT"))%>" ></td>					
                </tr>							
				<%	}%>								
                <tr>
                    <td colspan="5" class=title>합계</td>
                    <td class=title><input type='text' name='total_amt4' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt6)%>'>원</td>
                    <td class=title>&nbsp;</td>
                </tr>									
				
            </table>
        </td>
    </tr>							
	<%}%>			
	<input type='hidden' name='scd_size5' value='<%=cls_size%>'>
	<%	if(cls_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 고객별 해지정산금 미수 리스트</td><!-- 2018.04.04 -->
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='5%'>연번</td>
                    <td class="title" width='15%'>차량번호</td>
                    <td class="title" width='15%'>차종</td>					
                    <td class="title" width='5%'>회차</td>
                    <td class="title" width='15%'>구분</td>					
                    <td class="title" width='10%'>입금예정일</td>
                    <td class="title" width='25%'>금액</td>
                    <td class="title" width='10%'><input type="checkbox" name="ch_all5" id="ch_all5" value="Y"></td>
                </tr>	
				<%	for(int i = 0 ; i < cls_size ; i++){
							Hashtable cls_scd = (Hashtable)cls_scds.elementAt(i);
							total_amt6 	= total_amt6 + Long.parseLong(String.valueOf(cls_scd.get("EXT_AMT")));
					%>
					<input type='hidden' name='cls_amt' value='<%=cls_scd.get("EXT_AMT")%>'>
                <tr>
                    <td align="center"><%=i+1%></td>		
					<td align="center" class="car_no"><%=cls_scd.get("CAR_NO")%></td>
                    <td align="center" class="car_nm"><%=cls_scd.get("CAR_NM")%></td>					
                    <td align="center"><%=cls_scd.get("EXT_TM")%></td>
                    <td align="center"><%=cls_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(cls_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(cls_scd.get("EXT_AMT")))%>'>원</td>
                    <td align="center"><input type="checkbox" name="ch_cd5" value="<%=String.valueOf(cls_scd.get("EXT_AMT"))%>" ></td>					
                </tr>							
				<%	}%>									
                <tr>
                    <td colspan="6" class=title>합계</td>
                    <td class=title><input type='text' name='total_amt5' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt6)%>'>원</td>
                    <td class=title>&nbsp;</td>
                </tr>									
            </table>
        </td>
    </tr>							
	<%}%>		
	<input type='hidden' name='scd_size6' value='<%=grt_size%>'>
	<%	if(grt_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 고객별 선수금 미수 리스트</td><!-- 2018.04.04 -->
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='5%'>연번</td>
                    <td class="title" width='15%'>차량번호</td>
                    <td class="title" width='15%'>차종</td>					
                    <td class="title" width='5%'>회차</td>
                    <td class="title" width='15%'>구분</td>					
                    <td class="title" width='10%'>입금예정일</td>
                    <td class="title" width='25%'>금액</td>
                    <td class="title" width='10%'><input type="checkbox" name="ch_all6" id="ch_all6" value="Y"></td>										
                </tr>	
				<%	for(int i = 0 ; i < grt_size ; i++){
							Hashtable grt_scd = (Hashtable)grt_scds.elementAt(i);
							total_amt7 	= total_amt7 + Long.parseLong(String.valueOf(grt_scd.get("EXT_AMT")));
					%>
					<input type='hidden' name='grt_amt' value='<%=grt_scd.get("EXT_AMT")%>'>
                <tr>
                    <td align="center"><%=i+1%></td>		
					<td align="center" class="car_no"><%=grt_scd.get("CAR_NO")%></td>
                    <td align="center" class="car_nm"><%=grt_scd.get("CAR_NM")%></td>					
                    <td align="center"><%=grt_scd.get("EXT_TM")%></td>
                    <td align="center"><%=grt_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(grt_scd.get("EXT_AMT")))%>'>원</td>
                    <td align="center"><input type="checkbox" name="ch_cd6" value="<%=String.valueOf(grt_scd.get("EXT_AMT"))%>" ></td>					
                </tr>							
				<%	}%>									
                <tr>
                    <td colspan="6" class=title>합계</td>
                    <td class=title><input type='text' name='total_amt6' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt7)%>'>원</td>
                    <td class=title>&nbsp;</td>
                </tr>									
            </table>
        </td>
    </tr>							
	<%}%>				
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// 문자메시지 필드 계약별 textarea
function setMsgArea1(){
	var ch_cd1_total=0;		// 대여료
	var ch_dly1_total=0;	// 미수연체이자 합계
	var ch_cd3_total=0;		// 면책금
	var ch_cd4_total=0;		// 과태료
	var ch_cd5_total=0;		// 해지정산금
	var ch_cd6_total=0;		// 선수금
	var total=0;					// 총금액
	var regExp=/,/gi	// 특수문자 , 판별
	var result="";
	var unpaid="";
	var accountNum = $("#deposit_no option:selected").val();
	
	var date = new Date();
	var week = new Array("일", "월", "화", "수", "목", "금", "토");
	var year = date.getFullYear();
	var month = date.getMonth()+1;
	var day = date.getDate();
	if (month < 10) {
		month = "0"+month;
	}
	if (day < 10) {
		day = "0"+day;
	}
	var fullDate = year + "-" + month + "-" + day + "("+ week[date.getDay()] +")";	
	
	var cmsDay = $("#cms_day").val();
	var car_no = $("#car_no").val();
	var car_nm = $("#car_nm").val();
	var short_url = $("#short_url").val();
	var manager_name = $("#manager_name").val();
	var manager_phone = $("#manager_phone").val();
	
	$("input[name=ch_cd1]:checked").each(function(){
		var ch_cd1 = $(this).prev().context.value;
		ch_cd1_total = ch_cd1_total + Number(ch_cd1.replace(regExp,""));
	});
	$("input[name=ch_dly1]:checked").each(function(){
		var ch_dly1 = $(this).parent().prev().children()[0].value;
		ch_dly1_total = ch_dly1_total + Number(ch_dly1.replace(regExp,""));
	});
	$("input[name=ch_cd3]:checked").each(function(){
		var ch_cd3 = $(this).parent().prev().children()[0].value;
		ch_cd3_total = ch_cd3_total + Number(ch_cd3.replace(regExp,""));
	});
	$("input[name=ch_cd4]:checked").each(function(){
		var ch_cd4 = $(this).parent().prev().children()[0].value;
		ch_cd4_total = ch_cd4_total + Number(ch_cd4.replace(regExp,""));
	});
	$("input[name=ch_cd5]:checked").each(function(){
		var ch_cd5 = $(this).parent().prev().children()[0].value;
		ch_cd5_total = ch_cd5_total + Number(ch_cd5.replace(regExp,""));
	});
	$("input[name=ch_cd6]:checked").each(function(){
		var ch_cd6 = $(this).parent().prev().children()[0].value;
		ch_cd6_total = ch_cd6_total + Number(ch_cd6.replace(regExp,""));
	});
	
	result = $("#customer_name").val() + ' 고객님 안녕하십니까. 아마존카입니다.\n\n';
	result += '다음과 같이 미납된 자동차 대여료가 있어 알려드립니다.\n\n';
	result += '★ 기준일자 : ' + fullDate + ' 알림 발송시각\n'; 
	result += '★ 차량번호 : ' + car_no + " " + car_nm + '\n'; 
	result += '★ 대여료 스케줄표 : ' + short_url + '\n';
	result += '★ 미납금액 : ';
	
	if(Number(ch_cd1_total) != 0){
		result += '대여료 '+numberWithCommas(ch_cd1_total)+'원';
		unpaid += '대여료 '+numberWithCommas(ch_cd1_total)+'원';
	}
	
	if(Number(ch_dly1_total) != 0){
		if (Number(ch_cd1_total) == 0) {			
			result += '대여료 미납이자 '+numberWithCommas(ch_dly1_total)+'원';	
			unpaid += '대여료 미납이자 '+numberWithCommas(ch_dly1_total)+'원';
		} else {			
			result += ' + 대여료 미납이자 '+numberWithCommas(ch_dly1_total)+'원';	
			unpaid += ' + 대여료 미납이자 '+numberWithCommas(ch_dly1_total)+'원';
		}
	}
	
	if(Number(ch_cd3_total) != 0){
		if (Number(ch_cd1_total) == 0 && Number(ch_dly1_total) == 0) {
			result += '면책금 '+numberWithCommas(ch_cd3_total)+'원';	
			unpaid += '면책금 '+numberWithCommas(ch_cd3_total)+'원';
		} else {
			result += ' + 면책금 '+numberWithCommas(ch_cd3_total)+'원';	
			unpaid += ' + 면책금 '+numberWithCommas(ch_cd3_total)+'원';
		}		
	}
	
	if(Number(ch_cd4_total) != 0){
		if (Number(ch_cd1_total) == 0 && Number(ch_dly1_total) == 0 && Number(ch_cd3_total) == 0) {
			result += '과태료 '+numberWithCommas(ch_cd4_total)+'원';	
			unpaid += '과태료 '+numberWithCommas(ch_cd4_total)+'원';	
		} else {
			result += ' + 과태료 '+numberWithCommas(ch_cd4_total)+'원';	
			unpaid += ' + 과태료 '+numberWithCommas(ch_cd4_total)+'원';
		}			
	}
	
	if(Number(ch_cd5_total) != 0){
		if (Number(ch_cd1_total) == 0 && Number(ch_dly1_total) == 0 && Number(ch_cd3_total) == 0 && Number(ch_cd4_total) == 0) {
			result += '해지정산금 '+numberWithCommas(ch_cd5_total)+'원';	
			unpaid += '해지정산금 '+numberWithCommas(ch_cd5_total)+'원';	
		} else {
			result += ' + 해지정산금 '+numberWithCommas(ch_cd5_total)+'원';	
			unpaid += ' + 해지정산금 '+numberWithCommas(ch_cd5_total)+'원';
		}		
	}
	
	if(Number(ch_cd6_total) != 0){
		if (Number(ch_cd1_total) == 0 && Number(ch_dly1_total) == 0 && Number(ch_cd3_total) == 0 && Number(ch_cd4_total) == 0 && Number(ch_cd5_total) == 0) {
			result += '선수금 '+numberWithCommas(ch_cd6_total)+'원';	
			unpaid += '선수금 '+numberWithCommas(ch_cd6_total)+'원';	
		} else {
			result += ' + 선수금 '+numberWithCommas(ch_cd6_total)+'원';	
			unpaid += ' + 선수금 '+numberWithCommas(ch_cd6_total)+'원';
		}
	}
	
	if (Number(ch_cd1_total) == 0 && Number(ch_dly1_total) == 0 && Number(ch_cd3_total) == 0 && Number(ch_cd4_total) == 0 && Number(ch_cd5_total) == 0 && Number(ch_cd6_total) == 0) {
		result += '총금액 '+numberWithCommas(ch_cd1_total+ch_dly1_total+ch_cd3_total+ch_cd4_total+ch_cd5_total+ch_cd6_total)+'원\n';
		unpaid += '총금액 '+numberWithCommas(ch_cd1_total+ch_dly1_total+ch_cd3_total+ch_cd4_total+ch_cd5_total+ch_cd6_total);	
	} else {
		result += ' = 총금액 '+numberWithCommas(ch_cd1_total+ch_dly1_total+ch_cd3_total+ch_cd4_total+ch_cd5_total+ch_cd6_total)+'원\n';
		unpaid += ' = 총금액 '+numberWithCommas(ch_cd1_total+ch_dly1_total+ch_cd3_total+ch_cd4_total+ch_cd5_total+ch_cd6_total);
	}	
	
	result += '★ 납부계좌 : ' + accountNum + '(예금주:아마존카)\n';
	result += '★ 주의 : 무통장 입금은 16시(PM 4시) 전까지는 처리되어야 자동이체(CMS)와 중복 입·출금을 방지할 수 있습니다. (입금자명은 계약자 성명 또는 상호)로 처리)\n';
	result += '★ 담당자 : ' + manager_name + ' ' + manager_phone + '\n\n';
	result += '감사합니다.\n\n';
	result += '(주)아마존카 (www.amazoncar.co.kr)';
	
	if(result.substr(0, 1).indexOf('=') > -1 || result.substr(0, 1).indexOf('+') > -1){
		result = result.substring(1);
	}
	
	$("#cur_date_1").val(fullDate);
	$("#unpaid_1").val(unpaid);
	$("#bank_full_1").val(accountNum);
	
	$("#msg1").val(result);
	checklen(1);
}

//문자메시지 필드 고객별 textarea
function setMsgArea2(){
	var ch_cd2_total=0;		// 대여료
	var ch_dly2_total=0;	// 미수연체이자 합계
	var ch_cd3_total=0;		// 면책금
	var ch_cd4_total=0;		// 과태료
	var ch_cd5_total=0;		// 해지정산금
	var ch_cd6_total=0;		// 선수금
	var total=0;					// 총금액
	var regExp=/,/gi	// 특수문자 , 판별
	var result="";
	var unpaid="";
	var accountNum = $("#deposit_no option:selected").val();
	
	var car_no_arr = [];
	var car_arr = [];
	
	var date = new Date();
	var week = new Array("일", "월", "화", "수", "목", "금", "토");
	var year = date.getFullYear();
	var month = date.getMonth()+1;
	var day = date.getDate();
	if (month < 10) {
		month = "0"+month;
	}
	if (day < 10) {
		day = "0"+day;
	}
	var fullDate = year + "-" + month + "-" + day + "("+ week[date.getDay()] +")";
	$("#cur_date_2").val(fullDate);
	
	var cmsDay = $("#cms_day").val();
	var car_no = $("#car_no").val();
	var car_nm = $("#car_nm").val();
	var fms_short_url = $("#fms_short_url").val();
	var total_car_count = 0;
	
	$("input[name=ch_cd2]:checked").each(function(){
		var ch_cd2 = $(this).prev().context.value;
		ch_cd2_total = ch_cd2_total + Number(ch_cd2.replace(regExp,""));
		
		var temp_car_no = $(this).closest("tr").find(".car_no").text();
		var temp_car_nm = $(this).closest("tr").find(".car_nm").text();
		var temp_full_car = temp_car_no + "^" + temp_car_nm;
		
		//차량번호
		var car_no_index = car_no_arr.indexOf(temp_car_no);
	    if (car_no_index == -1){
	    	car_no_arr.push(temp_car_no);
	    }
	    //차량번호 및 차종
		var car_index = car_arr.indexOf(temp_full_car);
	    if (car_index == -1){
	    	car_arr.push(temp_full_car);
	    }
	});
	
	$("input[name=ch_dly2]:checked").each(function(){
		var ch_dly2 = $(this).parent().prev().children()[0].value;
		ch_dly2_total = ch_dly2_total + Number(ch_dly2.replace(regExp,""));
		
		var temp_car_no = $(this).closest("tr").find(".car_no").text();
		var temp_car_nm = $(this).closest("tr").find(".car_nm").text();
		var temp_full_car = temp_car_no + "^" + temp_car_nm;
		
		//차량번호
		var car_no_index = car_no_arr.indexOf(temp_car_no);
	    if (car_no_index == -1){
	    	car_no_arr.push(temp_car_no);
	    }
	    //차량번호 및 차종
		var car_index = car_arr.indexOf(temp_full_car);
	    if (car_index == -1){
	    	car_arr.push(temp_full_car);
	    }
	});
	
	$("input[name=ch_cd3]:checked").each(function(){
		var ch_cd3 = $(this).parent().prev().children()[0].value;
		ch_cd3_total = ch_cd3_total + Number(ch_cd3.replace(regExp,""));
		
		var temp_car_no = $(this).closest("tr").find(".car_no").text();
		var temp_car_nm = $(this).closest("tr").find(".car_nm").text();
		var temp_full_car = temp_car_no + "^" + temp_car_nm;
		
		//차량번호
		var car_no_index = car_no_arr.indexOf(temp_car_no);
	    if (car_no_index == -1){
	    	car_no_arr.push(temp_car_no);
	    }
	    //차량번호 및 차종
		var car_index = car_arr.indexOf(temp_full_car);
	    if (car_index == -1){
	    	car_arr.push(temp_full_car);
	    }
	});
	
	$("input[name=ch_cd4]:checked").each(function(){
		var ch_cd4 = $(this).parent().prev().children()[0].value;
		ch_cd4_total = ch_cd4_total + Number(ch_cd4.replace(regExp,""));
		
		var temp_car_no = $(this).closest("tr").find(".car_no").text();
		var temp_car_nm = $(this).closest("tr").find(".car_nm").val();
		var temp_full_car = temp_car_no + "^" + temp_car_nm;
		
		//차량번호
		var car_no_index = car_no_arr.indexOf(temp_car_no);
	    if (car_no_index == -1){
	    	car_no_arr.push(temp_car_no);
	    }
	    //차량번호 및 차종
		var car_index = car_arr.indexOf(temp_full_car);
	    if (car_index == -1){
	    	car_arr.push(temp_full_car);
	    }
	});
	
	$("input[name=ch_cd5]:checked").each(function(){
		var ch_cd5 = $(this).parent().prev().children()[0].value;
		ch_cd5_total = ch_cd5_total + Number(ch_cd5.replace(regExp,""));
		
		var temp_car_no = $(this).closest("tr").find(".car_no").text();
		var temp_car_nm = $(this).closest("tr").find(".car_nm").text();
		var temp_full_car = temp_car_no + "^" + temp_car_nm;
		
		//차량번호
		var car_no_index = car_no_arr.indexOf(temp_car_no);
	    if (car_no_index == -1){
	    	car_no_arr.push(temp_car_no);
	    }
	    //차량번호 및 차종
		var car_index = car_arr.indexOf(temp_full_car);
	    if (car_index == -1){
	    	car_arr.push(temp_full_car);
	    }
	});
	
	$("input[name=ch_cd6]:checked").each(function(){
		var ch_cd6 = $(this).parent().prev().children()[0].value;
		ch_cd6_total = ch_cd6_total + Number(ch_cd6.replace(regExp,""));
		
		var temp_car_no = $(this).closest("tr").find(".car_no").text();
		var temp_car_nm = $(this).closest("tr").find(".car_nm").text();
		var temp_full_car = temp_car_no + "^" + temp_car_nm;
		
		//차량번호
		var car_no_index = car_no_arr.indexOf(temp_car_no);
	    if (car_no_index == -1){
	    	car_no_arr.push(temp_car_no);
	    }
	    //차량번호 및 차종
		var car_index = car_arr.indexOf(temp_full_car);
	    if (car_index == -1){
	    	car_arr.push(temp_full_car);
	    }
	});
	
	if (car_no_arr.length <= 0) {
		total_car_count = 0;
	} else {
		total_car_count = car_no_arr.length-1;
	}	
	
	if (car_arr.length <= 0) {
		car_no = $("#car_no").val();
		car_nm = $("#car_nm").val();
	} else {
		//car_no = car_arr[0].split("^")[0];
		//car_nm = car_arr[0].split("^")[1];
		var search_car = car_arr.indexOf($("#car_no").val() + "^" + $("#car_nm").val());
		if (search_car == -1) {
			car_no = car_arr[0].split("^")[0];
			car_nm = car_arr[0].split("^")[1];
		} else {
			car_no = $("#car_no").val();
			car_nm = $("#car_nm").val();
		}
	}
	
	$("#car_no2").val(car_no);
	$("#car_nm2").val(car_nm);
	
	$("#car_count").val(total_car_count);
	
	var car_num_name_count = "";
	if (total_car_count == 0) {
		car_num_name_count = car_no + " " + car_nm;
	} else {
		car_num_name_count = car_no + " " + car_nm + ' 외 ' + total_car_count;		
	}	
	
	$("#car_num_name_count").val(car_num_name_count);
	
	result = $("#customer_name").val() + ' 고객님 안녕하십니까. 아마존카입니다.\n\n';
	result += fullDate + ' 금일 현재시각 미납내역 안내입니다.\n\n';
	/* result += '★ 차량번호 : ' + car_no + " " + car_nm + ' 외 ' + total_car_count + '\n'; */
	if (total_car_count == 0) {
		result += '★ 차량번호 : ' + car_num_name_count + '\n'; 
	} else {
		result += '★ 차량번호 : ' + car_num_name_count + '\n';
	} 
	result += '★ 대여료 스케줄표 : ' + fms_short_url + '\n';
	result += '★ 미납금액 : ';
	
	if(Number(ch_cd2_total) != 0){
		result += '대여료 '+numberWithCommas(ch_cd2_total)+'원';
		unpaid += '대여료 '+numberWithCommas(ch_cd2_total)+'원';
	}
	if(Number(ch_dly2_total)!=0){
		if (Number(ch_cd2_total) == 0) {
			result += '대여료 미납이자 '+numberWithCommas(ch_dly2_total)+'원';
			unpaid += '대여료 미납이자 '+numberWithCommas(ch_dly2_total)+'원';
		} else {			
			result += ' + 대여료 미납이자 '+numberWithCommas(ch_dly2_total)+'원';	
			unpaid += ' + 대여료 미납이자 '+numberWithCommas(ch_dly2_total)+'원';
		}
	}
	if(Number(ch_cd3_total) != 0){		
		if (Number(ch_cd2_total) == 0 && Number(ch_dly2_total) == 0) {			
			result += '면책금 '+numberWithCommas(ch_cd3_total)+'원';	
			unpaid += '면책금 '+numberWithCommas(ch_cd3_total)+'원';
		} else {			
			result += ' + 면책금 '+numberWithCommas(ch_cd3_total)+'원';	
			unpaid += ' + 면책금 '+numberWithCommas(ch_cd3_total)+'원';
		}
	}
	if(Number(ch_cd4_total) != 0){
		if (Number(ch_cd2_total) == 0 && Number(ch_dly2_total) == 0 && Number(ch_cd3_total) == 0) {
			result += '과태료 '+numberWithCommas(ch_cd4_total)+'원';
			unpaid += '과태료 '+numberWithCommas(ch_cd4_total)+'원';
		} else {
			result += ' + 과태료 '+numberWithCommas(ch_cd4_total)+'원';
			unpaid += ' + 과태료 '+numberWithCommas(ch_cd4_total)+'원';
		}
	}
	if(Number(ch_cd5_total) != 0){
		if (Number(ch_cd2_total) == 0 && Number(ch_dly2_total) == 0 && Number(ch_cd3_total) == 0 && Number(ch_cd4_total) == 0) {
			result += '해지정산금 '+numberWithCommas(ch_cd5_total)+'원';
			unpaid += '해지정산금 '+numberWithCommas(ch_cd5_total)+'원';
		} else {
			result += ' + 해지정산금 '+numberWithCommas(ch_cd5_total)+'원';
			unpaid += ' + 해지정산금 '+numberWithCommas(ch_cd5_total)+'원';
		}
	}
	if(Number(ch_cd6_total) != 0){
		if (Number(ch_cd2_total) == 0 && Number(ch_dly2_total) == 0 && Number(ch_cd3_total) == 0 && Number(ch_cd4_total) == 0 && Number(ch_cd5_total) == 0) {			
			result += '선수금 '+numberWithCommas(ch_cd6_total)+'원';	
			unpaid += '선수금 '+numberWithCommas(ch_cd6_total)+'원';
		} else {
			result += ' + 선수금 '+numberWithCommas(ch_cd6_total)+'원';	
			unpaid += ' + 선수금 '+numberWithCommas(ch_cd6_total)+'원';			
		}
	}
	
	if (Number(ch_cd2_total) == 0 && Number(ch_dly2_total) == 0 && Number(ch_cd3_total) == 0 && Number(ch_cd4_total) == 0 && Number(ch_cd5_total) == 0 && Number(ch_cd6_total) == 0) {		
		result += '총금액 '+numberWithCommas(ch_cd2_total+ch_dly2_total+ch_cd3_total+ch_cd4_total+ch_cd5_total+ch_cd6_total)+'원\n';
		unpaid += '총금액 '+numberWithCommas(ch_cd2_total+ch_dly2_total+ch_cd3_total+ch_cd4_total+ch_cd5_total+ch_cd6_total);
	} else {
		result += ' = 총금액 '+numberWithCommas(ch_cd2_total+ch_dly2_total+ch_cd3_total+ch_cd4_total+ch_cd5_total+ch_cd6_total)+'원\n';
		unpaid += ' = 총금액 '+numberWithCommas(ch_cd2_total+ch_dly2_total+ch_cd3_total+ch_cd4_total+ch_cd5_total+ch_cd6_total);		
	}
	
	result += '★ 납부계좌 : ' + accountNum + '(예금주:아마존카)\n';
	result += '★ 주의 : 무통장 입금은 16시(PM 4시) 전까지는 처리되어야 자동이체(CMS)와 중복 입·출금을 방지할 수 있습니다. (입금자명은 계약자 성명 또는 상호)로 처리)\n\n';
	result += '감사합니다.\n\n';
	result += '(주)아마존카 (www.amazoncar.co.kr)';
	
	if(result.substr(0, 1).indexOf('=') > -1 || result.substr(0, 1).indexOf('+') > -1){
		result = result.substring(1);
	}
	
	$("#cur_date_2").val(fullDate);
	$("#unpaid_2").val(unpaid);
	$("#bank_full_2").val(accountNum);
	
	$("#msg2").val(result);
	checklen(2);
}

$(document).ready(function(){
		
	// 팝업 로드 시 첫 이벤트는 합계적용 버튼을 클릭할 경우와 동일하다.
	$("input[name=ch_all1]").prop('checked', true);
	$("input[name=ch_cd1]").prop('checked', true);
	$("input[name=ch_dly1]").prop('checked', true);
	setMsgArea1();
	$("input[name=ch_all2]").prop('checked', true);
	$("input[name=ch_cd2]").prop('checked', true);
	$("input[name=ch_dly2]").prop('checked', true);
	setMsgArea2();
	// end
	
	// 계좌번호 select box 이벤트
	$("#deposit_no").on('change', function(){
		setMsgArea1();
		setMsgArea2();	
	});
	
	// 개별 체크박스 이벤트
	$("input[name=ch_cd1]").change(function(){//계약별 5일이내+연체 대여료 리스트
		if(!($(this).is(":checked"))){	// 체크박스를 한개라도 풀면 전체 체크박스를 해제 한다
			$("#ch_all1").prop('checked', false);
		}
		setMsgArea1();
	});
	$("input[name=ch_dly1]").change(function(){//계약별 대여료 미수연체이자 합계
		if(!($(this).is(":checked"))){
			$("#ch_all1").prop('checked', false);
		}
		setMsgArea1();
	});
	$("input[name=ch_cd2]").change(function(){//고객별 당일+연체 대여료 리스트
		if(!($(this).is(":checked"))){
			$("#ch_all2").prop('checked', false);
		}
		setMsgArea2();
	});
	$("input[name=ch_dly2]").change(function(){//고객별 대여료 미수연체이자 합계
		if(!($(this).is(":checked"))){
			$("#ch_all2").prop('checked', false);
		}
		setMsgArea2();
	});
	$("input[name=ch_cd3]").change(function(){//고객별 면책금 미수 리스트
		if(!($(this).is(":checked"))){
			$("#ch_all3").prop('checked', false);
		}
		setMsgArea1();
		setMsgArea2();
	});
	$("input[name=ch_cd4]").change(function(){//고객별 과태료 미수 리스트
		if(!($(this).is(":checked"))){
			$("#ch_all4").prop('checked', false);
		}
		setMsgArea1();
		setMsgArea2();
	});
	$("input[name=ch_cd5]").change(function(){//고객별 해지정산금 미수 리스트
		if(!($(this).is(":checked"))){
			$("#ch_all5").prop('checked', false);
		}
		setMsgArea1();
		setMsgArea2();
	});
	$("input[name=ch_cd6]").change(function(){//고객별 선수금 미수 리스트
		if(!($(this).is(":checked"))){
			$("#ch_all6").prop('checked', false);
		}
		setMsgArea1();
		setMsgArea2();
	});
		
	// 전체 선택 체크박스 이벤트
	$("#ch_all1").on("click", function(){	// 계약별 5일이내+연체 대여료 리스트 체크박스 전체 선택
		if($(this).is(":checked")){
			$("input[name=ch_cd1]").prop('checked', true);
			$("input[name=ch_dly1]").prop('checked', true);
		}else{
			$("input[name=ch_cd1]").prop('checked', false);
			$("input[name=ch_dly1]").prop('checked', false);
		}
		setMsgArea1();
	});
	$("#ch_all2").on("click", function(){	// 고객별 당일+연체 대여료 리스트 체크박스 전체 선택
		if($(this).is(":checked")){
			$("input[name=ch_cd2]").prop('checked', true);
			$("input[name=ch_dly2]").prop('checked', true);
		}else{
			$("input[name=ch_cd2]").prop('checked', false);
			$("input[name=ch_dly2]").prop('checked', false);
		}
		setMsgArea2();
	});
	$("#ch_all3").on("click", function(){	// 고객별 면책금 미수 리스트 체크박스 전체 선택
		if($(this).is(":checked")){
			$("input[name=ch_cd3]").prop('checked', true);
		}else{
			$("input[name=ch_cd3]").prop('checked', false);
		}
		setMsgArea1();
		setMsgArea2();
	});
	$("#ch_all4").on("click", function(){	// 고객별 과태료 미수 리스트 체크박스 전체 선택
		if($(this).is(":checked")){
			$("input[name=ch_cd4]").prop('checked', true);
		}else{
			$("input[name=ch_cd4]").prop('checked', false);
		}
		setMsgArea1();
		setMsgArea2();
	});
	$("#ch_all5").on("click", function(){	// 고객별 해지정산금 미수 리스트 체크박스 전체 선택
		if($(this).is(":checked")){
			$("input[name=ch_cd5]").prop('checked', true);
		}else{
			$("input[name=ch_cd5]").prop('checked', false);
		}
		setMsgArea1();
		setMsgArea2();
	});
	$("#ch_all6").on("click", function(){	// 고객별 선수금 미수 리스트 체크박스 전체 선택
		if($(this).is(":checked")){
			$("input[name=ch_cd6]").prop('checked', true);
		}else{
			$("input[name=ch_cd6]").prop('checked', false);
		}
		setMsgArea1();
		setMsgArea2();
	});
	
	// 합계적용 클릭 시 이벤트
	$("#setMsgTotAmt1").on("click", function(){	// 계약별 5일이내+연체 대여료 리스트
		$("input[name=ch_all1]").prop('checked', true);
		$("input[name=ch_cd1]").prop('checked', true);
		$("input[name=ch_dly1]").prop('checked', true);
		setMsgArea1();
	});
	$("#setMsgTotAmt2").on("click", function(){	// 고객별 당일+연체 대여료 리스트
		$("input[name=ch_all2]").prop('checked', true);
		$("input[name=ch_cd2]").prop('checked', true);
		$("input[name=ch_dly2]").prop('checked', true);
		setMsgArea2();
	});
});
	
//메시지 입력시 string() 길이 체크
function checklen(idx) {
	var msgtext, msglen;
	var maxlen = 2000;
	
	if(idx==1){
		msgtext = document.form1.msg1.value;
		msglen = document.form1.msglen1.value;
	}else{
		msgtext = document.form1.msg2.value;
		msglen = document.form1.msglen2.value;
	}
	
	var i=0,l=0;
	var temp,lastl;
	
	//길이를 구한다.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>maxlen)
		{
			alert("메시지란에 허용 길이 이상의 글을 쓰셨습니다.\n 메시지란에는 한글 "+(maxlen/2)+"자, 영문"+(maxlen)+"자까지만 쓰실 수 있습니다.");
			
			if(idx==1){
				temp = document.form1.msg1.value.substr(0,i);
				document.form1.msg1.value = temp;
			}else{
				temp = document.form1.msg2.value.substr(0,i);
				document.form1.msg2.value = temp;
			}
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}
	if(idx==1){
		form1.msglen1.value=l;
	}else{
		form1.msglen2.value=l;	
	}
}
</script>
</body>
</html>