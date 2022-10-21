<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*, acar.doc_settle.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	int idx = request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//계약기본정보
	ContBaseBean cont 	= a_db.getCont(m_id, l_cd);
	//cont_view
	Hashtable base 		= a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms 	= a_db.getCmsMng(m_id, l_cd);
	//대여기본정보
	ContFeeBean fee 	= a_db.getContFeeNew(m_id, l_cd, rent_st);
	if(fee.getPp_s_amt()==0 && !fee.getPp_chk().equals("")){  fee.setPp_chk(""); }
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//출고전대차 조회
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	
	
	//영업소리스트-고객구분
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	ContFeeBean fees = new ContFeeBean();
	ContCarBean fee_etcs = new ContCarBean();
	ContFeeRmBean fee_rm = new ContFeeRmBean();
	
	DocSettleBean doc = d_db.getDocSettleCommi("16", l_cd);
	
	//문서품의
	DocSettleBean doc_var = d_db.getDocSettleVar(doc.getDoc_no(), 1);
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//대여스케줄 등록 - 세금계산서 발행스케줄 포함
	function auto_make_schedule()
	{
		var fm = document.form1;
		

		if(fm.rent_start_dt.value 	== '')			{	alert('대여개시일을 확인하십시오'); 			fm.rent_start_dt.focus(); 	return; }
		if(fm.rent_end_dt.value 	== '')			{	alert('대여만료일을 확인하십시오'); 			fm.rent_end_dt.focus(); 	return; }		
		
		<%if(!fee.getPp_chk().equals("0")){%>
		if(fm.fee_amt.value 		== '0')			{	alert('월대여료 금액을 확인하십시오'); 			fm.fee_amt.focus(); 		return; }
		<%}%>
		
		
		if(fm.f_use_start_dt.value 	== '')			{	alert('1회차 사용기간을 입력하십시오'); 		fm.f_use_start_dt.focus(); 	return; }
		if(fm.f_use_end_dt.value 	== '')			{	alert('1회차 사용기간을 입력하십시오'); 		fm.f_use_end_dt.focus(); 	return; }		
		if(fm.fee_fst_dt.value 		== '')			{	alert('1회차 납입일를 입력하십시오'); 			fm.fee_fst_dt.focus(); 		return; }
		if(fm.leave_day.value 		== '' && fm.f_req_dt.value == '')			{	alert('발행기한을 입력하십시오'); 				fm.leave_day.focus(); 		return; }
		if(fm.fee_pay_tm.value 		== '')			{	alert('납입횟수를 입력하십시오'); 				fm.fee_pay_tm.focus(); 		return; }
		

		if(fm.rent_st.value != ''){		
			if(fm.tax_br_id.value	== '')			{ 	alert('세금계산서 발행영업소를 선택하십시오'); 	fm.tax_br_id.focus();		return;	}					
			if(fm.fee_pay_st.value	== '')			{ 	alert('납부방법을 선택하십시오'); 		fm.fee_pay_st.focus();		return;	}
			if(fm.fee_sh.value	== '')			{ 	alert('납부방식을 선택하십시오'); 		fm.fee_sh.focus();		return;	}
			if(fm.fee_est_day.value	== '')			{ 	alert('매월결제일자를 선택하십시오'); 		fm.fee_est_day.focus();		return;	}
			//if(fm.fee_req_day.value	== '')			{ 	alert('청구기준일을 선택하십시오'); 		fm.fee_req_day.focus();		return;	}
			<%if(!fee.getPp_chk().equals("0")){%>
			if(fm.mon_st.value == '1'){
				var ifee_tm = toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
				var rfee_tm = toInt(parseDigit(fm.rent_mon.value)) - ifee_tm;
				if(Math.round(rfee_tm) != toInt(fm.fee_pay_tm.value)){
					alert("실납입횟수는 "+rfee_tm+"회 입니다. 확인하십시오.");
					//return;
				}				
			}
			<%}%>
		}
		
		
		//1회차시작일 체크
		if(fm.rent_start_dt.value != fm.f_use_start_dt.value){ 
			if(!confirm('입력하신 1회차 시작일이 대여개시일과 틀립니다.\n\n스케줄을 생성하시겠습니까?'))			
				return;
		}
		
		
		if(fm.rent_st.value != '' && fm.mon_st.value == '12'){		//신규,연장계약  12개월 회차구분 제외
			
		}else{
		
			var con_mon = getRentTime('m', fm.rent_start_dt.value, fm.rent_end_dt.value);
			
			
			
			if(toInt(parseDigit(fm.rent_mon.value)) != con_mon){
				if(!confirm('대여기간과 개월수가 다릅니다. \n\n스케줄을 생성하시겠습니까?'))			
					return;
			}

		
			//1회차 대여기간 체크
			if(getRentTime('m', fm.f_use_start_dt.value, fm.f_use_end_dt.value) > 1){ 
				if(!confirm('1회차 대여기간이 '+fm.f_use_start_dt.value+'부터 '+fm.f_use_end_dt.value+' 입니다.\n\n입력하신 값이 한달이상 차이납니다.\n\n스케줄을 생성하시겠습니까?'))			
					return;
			}
			
			//1회차 대여기간 체크
			if(getRentTime('d', fm.f_use_start_dt.value, fm.f_use_end_dt.value) < 0){ 
				if(!confirm('1회차 대여기간이 '+fm.f_use_start_dt.value+'부터 '+fm.f_use_end_dt.value+' 입니다.\n\n입력하신 값이 이상합니다.\n\n스케줄을 생성하시겠습니까?'))			
					return;
			}
									
			//입금예정일 체크
			var est_day = getRentTime('m', fm.f_use_end_dt.value, fm.fee_fst_dt.value);
			if( est_day > 1 || est_day < -1){ 
				if(!confirm('입력하신 입금예정일이 사용기간 종료일과 한달이상 차이납니다.\n\n스케줄을 생성하시겠습니까?'))			
					return;
			}			
			est_day = getRentTime('d', fm.f_use_start_dt.value, fm.fee_fst_dt.value);
			if( est_day < 0){ 
				if(!confirm('입력하신 입금예정일이 사용기간 시작일보다 작습니다. \n\n스케줄을 생성하시겠습니까?'))			
					return;
			}
			

		}
		

		//분할청구
		if(fm.rtn_st.checked == true){
			var rtn_tm = toInt(fm.rtn_tm.value);			
			var tot_rtn_fee_amt = 0;
			<%if(!fee.getPp_chk().equals("0")){%>
			if(fm.rtn_fee_amt[0].value == '0'){			alert('1번 분할청구 대여료 금액을 확인하십시오'); 	fm.rtn_fee_amt[0].focus(); 	return; }
			<%}%>
			for(i=0; i<rtn_tm; i++){ 
				if(fm.rtn_firm_nm[i].value == '' || fm.rtn_fee_amt[i].value == ''){ alert(i+1+'번 분할청구 내용을 입력하십시오.'); return;}
				if(toInt(parseDigit(fm.rtn_fee_amt[i].value)) > 0){ 
					fm.rtn_fee_s_amt[i].value 	= sup_amt(toInt(parseDigit(fm.rtn_fee_amt[i].value)));
					fm.rtn_fee_v_amt[i].value 	= toInt(parseDigit(fm.rtn_fee_amt[i].value)) - toInt(fm.rtn_fee_s_amt[i].value);
					if(fm.rtn_type[i].value == '0'){ 
						tot_rtn_fee_amt 			= tot_rtn_fee_amt + toInt(parseDigit(fm.rtn_fee_amt[i].value));
					}
					if(fm.rtn_type[i].value == '4' && i==1){ 
						if(fm.f_rtn2_fee_amt.value == '0'){	set_reqamt('');	}
					}
				}
			}
			if(toInt(parseDigit(fm.fee_amt.value)) != tot_rtn_fee_amt){ alert('분할청구금액합이 맞지 않습니다.'); return; }		
		}
				
		
		if(confirm('스케줄등록을 하시겠습니까?'))
		{						
			var est_dt = replaceString('-','',fm.fee_fst_dt.value);
			fm.fee_est_y.value = est_dt.substring(0,4);
			fm.fee_est_m.value = est_dt.substring(4,6);
			fm.fee_est_d.value = est_dt.substring(6,8);
		
			fm.fee_s_amt.value = sup_amt(toInt(parseDigit(fm.fee_amt.value)));
			fm.fee_v_amt.value = toInt(parseDigit(fm.fee_amt.value)) - toInt(fm.fee_s_amt.value);
			fm.action = './fee_scd_u_mkscd_a.jsp';
//			fm.target = 'i_no';
			fm.target = 'MKSCD';
			fm.submit();
		}
	}		
	
	//대여일수 구하기
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}		
	
	//대여기간 셋팅
	function ScdfeeSet()
	{
		var fm = document.form1;
		if(fm.rent_start_dt.value != '' && fm.rent_mon.value != ''){
			fm.action = "fee_scd_set_nodisplay.jsp";
			fm.target = "i_no";
			fm.submit();
		}
	}
	function setUse_end_dt(){
		var fm = document.form1;
		if(fm.fee_sh.value == '0'){//후불
			fm.fee_fst_dt.value = fm.f_use_end_dt.value;	
		}else{
			fm.fee_fst_dt.value = fm.f_use_start_dt.value;			
		}
	}	
	
	//거래처 최근 발행예정일 보기
	function clientFeeReqDt(client_id){
		window.open("client_feereqdt.jsp?client_id="+client_id, "clientFeeReqDt", "left=100, top=400, width=900, height=300, scrollbars=yes");
	}
	
	//분할청구거래처 조회
	function search_client(idx){
		var fm = document.form1;
		window.open("/tax/pop_search/s_client_site.jsp?go_url=fee_scd_u_mkscd&s_kd=1&t_wd="+fm.rtn_firm_nm[idx].value+"&idx="+idx, "ClientSite", "left=100, top=400, width=900, height=300, scrollbars=yes");	
	}
	
	//통합여부에 따른 디스플레이
	function display_rtn(){
		var fm = document.form1;		
		if(fm.rtn_st.checked == true){ 					
			tr_rtn.style.display = '';		
		}else{											
			tr_rtn.style.display = 'none';							
		}	
	}
	//분할갯수에 따른 디스플레이
	function display_rtn2(){
		var fm = document.form1;				
		if(fm.rtn_tm.value == 2){
			tr_rtn2.style.display = '';
			tr_rtn3.style.display = 'none';
			tr_rtn4.style.display = 'none';
			tr_rtn5.style.display = 'none';
		}else if(fm.rtn_tm.value == 3){
			tr_rtn2.style.display = '';
			tr_rtn3.style.display = '';
			tr_rtn4.style.display = 'none';
			tr_rtn5.style.display = 'none';
		}else if(fm.rtn_tm.value == 4){
			tr_rtn2.style.display = '';
			tr_rtn3.style.display = '';
			tr_rtn4.style.display = '';
			tr_rtn5.style.display = 'none';
		}else if(fm.rtn_tm.value == 5){
			tr_rtn2.style.display = '';
			tr_rtn3.style.display = '';
			tr_rtn4.style.display = '';
			tr_rtn5.style.display = '';
		}	
	}

	//청구금액 셋팅
	function set_reqamt(st){
		var fm = document.form1;			
		if(fm.f_use_start_dt.value == ''){	alert('시작일을 입력하십시오.'); return;}
		if(fm.f_use_end_dt.value == ''){	alert('종료일을 입력하십시오.'); return;}				
		fm.st.value = st;
		fm.action='getUseDayFeeAmt.jsp';		
		if(st == 'view'){
			fm.target='_blank';
		}else{
			fm.target='i_no';
		}				
		fm.submit();
	}			
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="post">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='rent_way' value='<%=base.get("RENT_WAY")%>'>
<input type='hidden' name='prv_mon_yn' value='<%=fee.getPrv_mon_yn()%>'>
<input type='hidden' name='cms_start_dt' value='<%=cms.getCms_start_dt()%>'>
<input type='hidden' name='st' value=''>
<input type='hidden' name='f_fee_amt' value=''>
<input type='hidden' name='f_fee_s_amt' value=''>
<input type='hidden' name='f_fee_v_amt' value=''>
<input type='hidden' name='f_rtn2_fee_amt' value=''>
<input type='hidden' name='f_rtn2_fee_s_amt' value=''>
<input type='hidden' name='f_rtn2_fee_v_amt' value=''>
<input type='hidden' name='from_page' value='fee_scd_u_mkscd.jsp'>
<input type='hidden' name='fee_est_y' value=''>
<input type='hidden' name='fee_est_m' value=''>
<input type='hidden' name='fee_est_d' value=''>
<input type='hidden' name='o_tot_mon' value=''>
<input type='hidden' name="firm_nm"			value="<%=base.get("FIRM_NM")%>">      
<input type='hidden' name='taecha_no' value='<%=taecha_no%>'>


<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > 대여료스케줄관리 > <span class=style5>대여료스케줄 등록</span></span></td>
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
                    <td width='13%' class='title'>계약번호</td>
                    <td width='20%'>&nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='13%' class='title'>상호</td>
                    <td width='22%'>&nbsp;<%=base.get("FIRM_NM")%></td>
                    <td width='13%' class='title'>사용본거지</td>
                    <td>&nbsp;<%=base.get("R_SITE_NM")%></td>
                </tr>
                <tr>
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=base.get("CAR_NO")%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></td>
                    <td class='title'>등록지역</td>
                    <td>&nbsp;<%String car_ext = String.valueOf(base.get("CAR_EXT"));%><%=c_db.getNameByIdCode("0032", "", car_ext)%></td>
                </tr>
                <tr>
                    <td class='title'> 대여방식 </td>
                    <td>&nbsp;<%=base.get("RENT_WAY")%></td>
                    <td class='title'>CMS</td>
                    <td colspan="3">&nbsp;<%if(!cms.getCms_bank().equals("")){%>
					<b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
								<%=cms.getCms_bank()%>:<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>(매월<%=cms.getCms_day()%>일)<%}else{%>-<%}%>
                    </td>
                </tr>
                <tr>
                    <td class='title'>영업지점</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("BRCH_ID")),"BRCH")%></td>
                    <td class='title'>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                    <td class='title'>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                </tr>
            </table>
        </td>
	</tr>
	<tr>
	    <td align=right><a href="javascript:clientFeeReqDt('<%=base.get("CLIENT_ID")%>')"><img src=/acar/images/center/button_conf_bh.gif align=absmiddle border="0"></a></td>
	</tr>		
	
<%	if(rent_st.equals("") && idx==1){
		String f_use_s_dt 	= taecha.getCar_rent_st();
		//String f_use_e_dt = c_db.minusDay(c_db.addMonth(f_use_s_dt, 1), 1);
		String f_use_e_dt = c_db.addMonth(f_use_s_dt, 1);
%>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고지연 대차대여</span></td>	
	</tr>	
	<tr> 
        <td class=line2></td>
    </tr>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'>차량번호</td>
                    <td>&nbsp;<%=taecha.getCar_no()%></td>
                </tr>
                <tr>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=c_db.getNameById(taecha.getCar_id(), "FULL_CAR_NM")%></td>
                </tr>
                <tr>
                    <td class='title'>대여기간</td>
                    <td>&nbsp;
                      <input type='text' name='rent_start_dt' value='<%=taecha.getCar_rent_st()%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value); ScdfeeSet();'>
        			  ~
        			  <input type='text' name='rent_end_dt' value='<%=taecha.getCar_rent_et()%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        			  <input type='hidden' name='rent_mon' value='<%=taecha.getCar_rent_tm()%>'>
        			  <input type='hidden' name='tae_no' value='<%=taecha.getNo()%>'>			  
        			</td>
                </tr>
                <tr>
                    <td class='title'>월대여료</td>
                    <td>&nbsp;
        			    <input type='text' name='fee_amt' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>원&nbsp;
        				<input type='hidden' name='fee_s_amt' value=''>
        				<input type='hidden' name='fee_v_amt' value=''>						
        			</td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align='right'>&nbsp;</td>
	</tr>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>발행영업소</td>
                    <td>
                      &nbsp;<select name='tax_br_id'>
                        <option value=''>선택</option>
                        <%	if(brch_size > 0)	{
        						for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);		%>
                        <option value='<%=branch.get("BR_ID")%>' <%if(String.valueOf(branch.get("BR_ID")).equals("S1")){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                        <%		}
        					}			%>
                      </select>
          		    </td>
                </tr>						
                <tr>
                    <td width="100" class='title'>1회차사용기간</td>
                    <td>&nbsp;
                      <input type='text' name='f_use_start_dt' value='<%=f_use_s_dt%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                      ~
                      <input type='text' name='f_use_end_dt' value='<%=f_use_e_dt%>' maxlength='10' size='11' class='text' onBlur="javscript:this.value = ChangeDate4(this, this.value); document.form1.fee_fst_dt.value = this.value;  set_reqamt('');">
					( <input type='hidden' name='use_days' value=''>
					  <input type="text" name="u_mon" value="" size="5" class=text>개월
  					  <input type="text" name="u_day" value="" size="5" class=text>일 )
					  <span class="b"><a href="javascript:set_reqamt('')" onMouseOver="window.status=''; return true" title="사용일수 및 대여료 일자계산합니다."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
        			  <span class="b"><a href="javascript:set_reqamt('view')" onMouseOver="window.status=''; return true" title="월대여료 계산하기"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>
					  
        		    </td>
                </tr>
                <tr>
                    <td width="100" class='title'>1회차납입일</td>
                    <td>&nbsp;
                      <input type='text' name='fee_fst_dt' value='<%=taecha.getCar_rent_dt()%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>
                <tr>
                    <td class='title'>발행기한</td>
                    <td>&nbsp;입금예정일 
                    <input type='text' size='3' name='leave_day' value='<%=fee.getLeave_day()%>' maxlength='2' class='text'>
        			일전 발행</td>
                </tr>
                <tr>
                    <td class='title'>납입횟수</td>
                    <td>&nbsp;
                    <input type='text' size='3' name='fee_pay_tm' value='<%=taecha.getCar_rent_tm()%>' maxlength='2' class='text'>
        			회</td>
                </tr>
            </table>
        </td>
    </tr>
<%	}%>
		
<%	if(idx==2){
		ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
		
		String f_use_s_dt 	= ext_fee.getRent_start_dt();
		String f_use_e_dt = c_db.minusDay(c_db.addMonth(f_use_s_dt, 1), 1);
		if(!ext_fee.getFee_fst_dt().equals("")) f_use_e_dt= ext_fee.getFee_fst_dt();
		
		if(rent_st.equals("1") && !taecha.getRent_mng_id().equals("") && taecha.getTae_st().equals("0") && ext_fee.getPrv_mon_yn().equals("1")){
			f_use_s_dt 	= taecha.getCar_rent_st();
			f_use_e_dt = c_db.minusDay(c_db.addMonth(f_use_s_dt, 1), 1);
			ext_fee.setRent_start_dt(f_use_s_dt);
		}
		if(!rent_st.equals("1") && AddUtil.parseInt(ext_fee.getCon_mon()) < AddUtil.parseInt(ext_fee.getFee_pay_tm())){
			ext_fee.setFee_pay_tm(ext_fee.getCon_mon());
			if(ext_fee.getIfee_suc_yn().equals("0") && ext_fee.getIfee_s_amt()>0){
				int pay_tm = AddUtil.parseInt(ext_fee.getFee_pay_tm()) - ext_fee.getPere_r_mth();
				ext_fee.setFee_pay_tm(String.valueOf(pay_tm));
			}
		}
		
		
		if(String.valueOf(base.get("CAR_ST")).equals("4")){
			//월렌트정보
			fee_rm = a_db.getContFeeRm(m_id, l_cd, rent_st);
			fees = a_db.getContFeeNew(m_id, l_cd, rent_st);
			fee_etcs = a_db.getContFeeEtc(m_id, l_cd, rent_st);
		}
		
		//신차개시 및 스케줄생성과 연동
		if(ext_fee.getRent_st().equals("1") && !doc_var.getDoc_no().equals("")){
                		
                	if(doc_var.getVar01().equals("1")){
                		ext_fee.setFee_est_day(doc_var.getVar02());	
                		if(doc_var.getVar05().length()==10)                		ext_fee.setFee_req_day(doc_var.getVar05().substring(8,10));	
                		if(doc_var.getVar05().length()==8)                		ext_fee.setFee_req_day(doc_var.getVar05().substring(6,8));	
                		f_use_e_dt = doc_var.getVar05();
                		ext_fee.setFee_fst_dt(doc_var.getVar05());	                			
                	}else if(doc_var.getVar01().equals("2")){
                		ext_fee.setFee_est_day(doc_var.getVar16());	
                		if(doc_var.getVar19().length()==10)                		ext_fee.setFee_req_day(doc_var.getVar19().substring(8,10));	
                		if(doc_var.getVar19().length()==8)                		ext_fee.setFee_req_day(doc_var.getVar19().substring(6,8));	                		
                		f_use_e_dt = doc_var.getVar19();
                		ext_fee.setFee_fst_dt(doc_var.getVar19());	                			
                	}       
                		
                }		
		%>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(rent_st.equals("1")){%>신차<%}else{%><%=AddUtil.parseInt(rent_st)-1%>차 연장<%}%>대여</span></td>	
	</tr>	
	<tr> 
        <td class=line2></td>
    </tr>  
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>대여기간</td>
                    <td colspan="3">
                      &nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value); ScdfeeSet();'>
                            ~
                            <input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        				    (
        			        <input type='text' name='rent_mon' value='<%=ext_fee.getCon_mon()%>' size='2' class='whitenum' readonly>
        				    개월
        				    <%if(!fee_rm.getRent_mng_id().equals("")){%>
        				    <input type='text' name='rent_day' value='<%=fee_etcs.getCon_day()%>' size='2' class='whitenum' readonly>
        				    개월
        				    <%}%>
        				    )</td>
                </tr>
                <tr>
                    <td class='title' width=13%>선납금</td>
                    <td width=20%>
        			    &nbsp;<input type='text' name='pp_amt' value='<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>' size='10' class='whitenum' readonly>원&nbsp;</td>
                    <td width=13% class='title'>보증금</td>
                    <td>
    			        &nbsp;<input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' size='10' class='whitenum' readonly>원&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>개시대여료</td>
                    <td>
        			    &nbsp;<input type='text' name='ifee_amt' value='<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>' size='10' class='whitenum' readonly>원&nbsp;</td>
                    <td class='title'>월대여료</td>
                    <td>
        			    &nbsp;<input type='text' name='fee_amt' value='<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>' size='10' class='whitenum' readonly onBlur='javascript:this.value=parseDecimal(this.value);'>원&nbsp;
        			    <input type='hidden' name='fee_s_amt' value='<%=ext_fee.getFee_s_amt()%>'>
        			    <input type='hidden' name='fee_v_amt' value='<%=ext_fee.getFee_v_amt()%>'>			
        			</td>			
                </tr>
            </table>
        </td>
    </tr>	
    <%if(!fee_rm.getRent_mng_id().equals("")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트</span></td>	
	</tr>	    
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>구분</td>
                    <td class='title' width='20%'>공급가</td>
                    <td class='title' width='20%'>부가세</td>
                    <td class='title' width='20%'>합계</td>
                    <td width="20%" class='title'>계약조건</td>
                </tr>
                <tr>
                    <td rowspan="5" class='title' width='5%'>월<br>대<br>
                      여<br>
                      료</td>
                    <td class='title' width='15%'>정상대여료</td>
                    <td align="center" ><input type='text' size='10' name='v_inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9' name='v_inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='v_inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align="center">-</td>
                </tr>
                <tr>
                    <td class='title'>D/C</td>
                    <td align="center" ><input type='text' size='10' name='v_dc_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9' name='v_dc_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='v_dc_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt()+fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align="center">DC율:
                      <input type='text' size='4' name='v_dc_ra' maxlength='10' class="whitenum" value='<%=fees.getDc_ra()%>'></td>
                </tr>	
              <tr>
                <td class='title'>내비게이션</td>
                <td align="center"><input type='text' size='11' name='v_navi_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='v_navi_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='v_navi_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">
                  <%if(fee_rm.getNavi_yn().equals("N")){%>없음<%}else if(fee_rm.getNavi_yn().equals("Y")){%>있음<%}else{%>-<%}%>                  
    	 	</td>
              </tr>
              <tr>
                <td class='title'>기타</td>
                <td align="center"><input type='text' size='11' name='v_etc_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='v_etc_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='v_etc_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">
                    <input type='text' size='40' name='v_etc_cont' class='whitetext' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
              </tr>                
                <tr>
                    <td class='title'>소계</td>
                    <td align="center" ><input type='text' size='10'  name='v_fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='9'  name='v_fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10'  name='v_fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원 </td>
                    <td align="center">-</td>
                </tr>    
              <tr>
                <td colspan="2" class='title'>대여료총액</td>
                <td align="center"><input type='text' size='11' name='v_t_fee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='v_t_fee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='v_t_fee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' name="v_v_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 개월
        	    <input type='text' name="v_v_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 일</td>
              </tr>
              <%if(rent_st.equals("1")){%>
              <tr>
                <td colspan="2" class='title'>배차료</td>
                <td align="center"><input type='text' size='11' name='v_cons1_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='v_cons1_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='v_cons1_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">
                  <%if(fee_rm.getCons1_yn().equals("N")){%>없음<%}else if(fee_rm.getCons1_yn().equals("Y")){%>있음<%}else{%>-<%}%>                    
    	 	</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>반차료</td>
                <td align="center"><input type='text' size='11' name='v_cons2_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='v_cons2_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='v_cons2_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">
                  <%if(fee_rm.getCons2_yn().equals("N")){%>없음<%}else if(fee_rm.getCons2_yn().equals("Y")){%>있음<%}else{%>-<%}%>                    
    	 	</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>합계</td>
                <td align="center"><input type='text' size='11' name='v_rent_tot_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='v_rent_tot_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='v_rent_tot_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"> </td>
              </tr>                  
              <tr>                
                <td colspan="2" class='title'><span class="title1">최초결제금액</span></td>
                <td align='center'><input type="text" name="v_f_rent_tot_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원		  
                </td>                
                <td colspan='3'>&nbsp;&nbsp;&nbsp;
                     * 최초결제방식 : <%if(fee_rm.getF_paid_way().equals("1")){%>1개월치<%}else if(fee_rm.getF_paid_way().equals("2")){%>총액<%}else{%>-<%}%>                         
                      &nbsp;&nbsp;&nbsp;
                      반차료 <%if(fee_rm.getF_paid_way2().equals("1")){%>포함<%}else if(fee_rm.getF_paid_way2().equals("2")){%>미포함<%}else{%>-<%}%>                                                   
                      &nbsp;&nbsp;&nbsp;
                      * 예약금 : <input type="text" name="v_f_con_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_con_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원	
                  
                </td>                
              </tr>      
              <%}%> 
            </table>		
	    </td>
    </tr>                              	
    <%}%>
    <tr>
	<td align='right'>&nbsp;</td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width=13% class='title'>발행영업소</td>
                    <td>
                      &nbsp;<select name='tax_br_id'>
                        <option value=''>선택</option>
                        <%	if(brch_size > 0)	{
        						for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);		%>
                        <option value='<%=branch.get("BR_ID")%>' <%if(String.valueOf(branch.get("BR_ID")).equals("S1")){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                        <%		}
        					}			%>
                      </select>
          		    </td>
                </tr>			
                <tr>
                    <td class='title'>&nbsp;납부방법</td>
                    <td>
                      &nbsp;<select name='fee_pay_st'>
                        <option value='1' <%if(fee.getFee_pay_st().equals("1")){%> selected <%}%>>자동이체</option>
                        <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>무통장입금</option>
                        <option value='3' <%if(fee.getFee_pay_st().equals("3")){%> selected <%}%>>지로</option>
                        <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>수금</option>
                        <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>기타</option>
                      </select>
          			</td>
                </tr>				  	
                <tr>
                    <td class='title'>납부방식</td>
                    <td>
                      &nbsp;<select name='fee_sh'>
                        <option value="0" <%if(fee.getFee_sh().equals("0")){%> selected <%}%>>후불</option>
                        <option value="1" <%if(fee.getFee_sh().equals("1")){%> selected <%}%>>선불</option>
                      </select>
                    </td>
                </tr>
                <%	
                %>
                <tr>
                    <td class='title'>매월결제일자</td>
                    <td>
                      &nbsp;<select name='fee_est_day'>
                        <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                        <% } %>
                        <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
						<option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
                      </select>
                    </td>
                </tr>
                <!--
                <tr>		  
                    <td class='title'>청구기준일</td>
                    <td>
                      &nbsp;<select name='fee_req_day'>
                        <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>' <%if(fee.getFee_req_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                        <% } %>
                        <option value='99' <%if(fee.getFee_req_day().equals("99")){%> selected <%}%>> 말일 </option>
                      </select>
                    </td>
                </tr>
                -->
                <tr>
                    <td class='title'>1회차사용기간</td>
                    <td>
                      &nbsp;<input type='text' name='f_use_start_dt' value='<%=AddUtil.ChangeDate2(f_use_s_dt)%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                      ~
                      <input type='text' name='f_use_end_dt' value='<%=AddUtil.ChangeDate2(f_use_e_dt)%>' maxlength='10' size='11' class='text' onBlur="javscript:this.value = ChangeDate4(this, this.value); setUse_end_dt(); set_reqamt('');">
					( <input type='hidden' name='use_days' value=''>
					  <input type="text" name="u_mon" <%if(cont.getCar_st().equals("4")){%>value="<%=fees.getCon_mon()%>"<%}else{%>value=""<%}%> size="5" class=text>개월
  					  <input type="text" name="u_day" <%if(cont.getCar_st().equals("4")){%>value="<%=fee_etcs.getCon_day()%>"<%}else{%>value=""<%}%> size="5" class=text>일 )
        			  <%if(!cont.getCar_st().equals("4")){%><span class="b"><a href="javascript:set_reqamt('view')" onMouseOver="window.status=''; return true" title="월대여료 계산하기"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span><%}%>
        		    </td>
                </tr>
                <tr>
                    <td class='title'>1회차납입일</td>
                    <td>
                        &nbsp;<input type='text' name='fee_fst_dt' value='<%=AddUtil.ChangeDate2(ext_fee.getFee_fst_dt())%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>
                <tr>
                    <td class='title'>발행기한</td>
                    <td>&nbsp;입금예정일
                    <input type='text' size='3' name='leave_day' value='<%=ext_fee.getLeave_day()%>' maxlength='2' class='text'>
        			일전 발행
        		혹은 1회차발행일
        		&nbsp;<input type='text' name='f_req_dt' value='' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        				
        			</td>
                </tr>
                <tr>
                    <td class='title'>납입횟수</td>
                    <td>
                    &nbsp;<input type='text' size='3' name='fee_pay_tm' value='<%=ext_fee.getFee_pay_tm()%>' maxlength='2' class='text'>
        			회
					
					&nbsp;
					( 회차간격 : 
					 <select name='mon_st'>
        							<option value='1'> 1개월</option>
        							<option value='12'>12개월</option>									
        						</select>
					)
					</td>
                </tr>
            </table>
        </td>
    </tr>
<%	}%>		
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>변경사유</td>
                    <td>
                        &nbsp;<textarea name="cng_cau" cols="82" rows="1" class=default style='IME-MODE: active'></textarea>
                    </td>
                </tr>
                <tr>
                    <td width="13%" class='title'>일자계산내역</td>
                    <td>
                        &nbsp;<textarea name="etc" cols="82" rows="1" class=default style='IME-MODE: active'></textarea>
                        <input type='hidden' name='etc2' value=''>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>		
	<tr>
	    <td><font color=green>* <!--1회차 사용기간에 있는 [계산하기]를 클릭하면 사용기간 및 대여료 일자 계산 합니다.-->1회차만료일 입력시 자동 계산함.</font></td>
    </tr>		
    <tr> 
        <td class=line2></td>
    </tr>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width=13% class='title'>분할청구여부</td>
                    <td colspan="3">&nbsp;
        			  <input type="checkbox" name="rtn_st" value="Y" onClick="javascript:display_rtn()">
        			<%if(fee.getPp_chk().equals("0")){%>&nbsp;<font color=red>* 선납금 매월균등발행</font><%}%>        			  
                    </td>
                </tr>
            </table>
	    </td>
    </tr>	
	<tr tr id=tr_rtn style='display:none'>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'>분할갯수</td>
                    <td colspan="3">
                      &nbsp;<select name='rtn_tm' onchange="javascript:display_rtn2()">
                        <%	for(int i=2; i<=5 ; i++){%>
                        <option value='<%=i%>'><%=i%></option>개
                        <% } %>
                      </select></td>
                </tr>
    		  <%String firm_nm 		= String.valueOf(base.get("FIRM_NM"));
    			String client_id 	= String.valueOf(base.get("CLIENT_ID"));
    		  	String site_id 		= "";
    		  	if(cont.getTax_type().equals("2")){
    				firm_nm 		= String.valueOf(base.get("R_SITE_NM"));
    				site_id 		= String.valueOf(base.get("R_SITE_SEQ"));
    			}%>
                <tr>
                    <td class='title' width='13%'>연번</td>
                    <td class='title' width='13%' >구분</td>
                    <td class='title' width='54%'>공급받는자</td>
        						<td class='title' width='20%'>청구금액</td>
                </tr>			
                <tr>
                    <td class='title'>1</td>
                    <td align="center">
        			  <select name='rtn_type'>
                        <option value='0'>대여료</option>
                      </select>
        			  </td>                    
                    <td align="center">
        			  <input type='text' size='40' name='rtn_firm_nm' value='<%=firm_nm%>' class='text' readonly>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  </td>
        			  <td align="center">
                      <input type='text' name='rtn_fee_amt' value='0' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원
        			  <input type='hidden' name='rtn_fee_s_amt' value='0'>
        			  <input type='hidden' name='rtn_fee_v_amt' value='0'>		
        			  <input type='hidden' name='rtn_client_id' value='<%=client_id%>'>
        			  <input type='hidden' name='rtn_site_id' value='<%=site_id%>'></td>
                </tr>
    		    <%	for(int i=2; i<=5 ; i++){%>
                <tr tr id=tr_rtn<%=i%> style="display:<%if(i==2){%>''<%}else{%>none<%}%>">
                    <td class='title'><%=i%></td>
                    <td align="center">
        			  <select name='rtn_type'>
                        <option value='0'>대여료</option>
                        <option value='4' <%if(fee.getPp_chk().equals("0")){%>selected<%}%>>선납금균등발행</option>
                      </select>
        			  </td>                              
                    <td align="center">
        			  <input type='text' size='40' name='rtn_firm_nm' value='<%if(i==2 && fee.getPp_chk().equals("0")){%><%=firm_nm%><%}%>' class='text'>
        			  <span class="b"><a href="javascript:search_client(<%=i-1%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
        			  </td>
        			  <td align="center">
        			  <input type='text' name='rtn_fee_amt' value='0' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원
        			  <input type='hidden' name='rtn_fee_s_amt' value='0'>
        			  <input type='hidden' name='rtn_fee_v_amt' value='0'>
        			  <input type='hidden' name='rtn_client_id' value='<%if(i==2 && fee.getPp_chk().equals("0")){%><%=client_id%><%}%>'>
        			  <input type='hidden' name='rtn_site_id' value='<%if(i==2 && fee.getPp_chk().equals("0")){%><%=site_id%><%}%>'></td>
                </tr>
    		  <% } %>
            </table>
	    </td>
    </tr>	
	<tr>
	    <td align='right'>&nbsp;</td>
    </tr>	
	<tr>
	    <td align="center">
      		<a href="javascript:auto_make_schedule();" class="btn"><img src=/acar/images/center/button_reg.gif align=absmiddle border="0"></a>&nbsp;&nbsp;
      		<a href="javascript:window.close();" class="btn"><img src=/acar/images/center/button_close.gif align=absmiddle border="0"></a>			
	    </td>
	</tr>	
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	var fm = document.form1;		
	
	fm.o_tot_mon.value 		 = <%=fee.getCon_mon()%>-(<%=fee.getIfee_s_amt()%>/<%=fee.getFee_s_amt()%>);
	
	//선납금월균등발행
	<%if(fee.getPp_chk().equals("0")){%>
	fm.rtn_fee_amt[0].value = 	parseDecimal(<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>);
	fm.rtn_fee_amt[1].value = 	parseDecimal(<%=fee.getPp_s_amt()+fee.getPp_v_amt()%>/<%=fee.getCon_mon()%>);
	<%}%>
	

	//월렌트
	<%if(cont.getCar_st().equals("4")){%>
	
	<%	fee_rm.setF_paid_way("1"); %>
	
	//총액
	<%	if(fee_rm.getF_paid_way().equals("2")){%>
	
			fm.f_use_start_dt.value = '<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>';
			fm.f_use_end_dt.value 	= '<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>';
			if(fm.fee_fst_dt.value == ''){
				fm.fee_fst_dt.value = fm.f_use_start_dt.value;
			}
			
	<%	}else{%>
	
			fm.f_use_start_dt.value = '<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>';
			fm.f_use_end_dt.value 	= '<%=AddUtil.ChangeDate2(c_db.addDay(c_db.addMonth(fees.getRent_start_dt(), 1), -1))%>';
			if(fm.fee_fst_dt.value == ''){
				fm.fee_fst_dt.value = fm.f_use_start_dt.value;
			}
			fm.u_mon.value = '1';
			fm.u_day.value = '0';
			
			if(fm.fee_pay_tm.value == '<%=fees.getCon_mon()%>' && <%=fee_etcs.getCon_day()%> >0){
				fm.fee_pay_tm.value = '<%=AddUtil.parseInt(fees.getCon_mon())+1%>';
			}
	
	<%	}%>
	
	<%}else{%>	
		set_reqamt();
	<%}%>

	<%if(fee.getPp_chk().equals("0")){%>
		fm.rtn_st.checked = true;
		tr_rtn.style.display = '';
	<%}%>
	
	
		
//-->
</script>
</body>
</html>
