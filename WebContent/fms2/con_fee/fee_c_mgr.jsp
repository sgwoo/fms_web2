<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.cls.*, acar.user_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")){ 	user_id = ck_acar_id; }
	if(br_id.equals("")){ 	br_id = login.getCookieValue(request, "acar_br"); }
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "02"); }
	//로그인-대여관리:권한
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//기본정보
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(m_id, l_cd);
	
	//최초대여정보
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//마지막대여정보
	ContFeeBean max_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
	
	//해지정보
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	
	//연체료 세팅
	boolean flag = af_db.calDelayDtPrint(m_id, l_cd, cls.getCls_dt(), String.valueOf(fee.get("RENT_DT")));
	
	//차종변경, 계약승계일때는 해지일자 무시
	if(cls.getCls_st().equals("4") || cls.getCls_st().equals("5")){
		flag = af_db.calDelayDtPrint(m_id, l_cd, "", String.valueOf(fee.get("RENT_DT")));
	}
	
	//건별 대여료 스케줄 리스트
	Vector fee_scd = af_db.getFeeScdPrint2(l_cd, "", false);
	int fee_scd_size = fee_scd.size();
	
	//선납대여료균등발행 스케줄 2018.04.17
	Vector fee_scd_sun_nap = af_db.getFeeScdPrint2(l_cd, "", true);
	int fee_scd_sun_nap_size = fee_scd_sun_nap.size();
	
	//건별 대여료 스케줄 통계
	Hashtable fee_stat = af_db.getFeeScdStatPrint2(m_id, l_cd);
	int fee_stat_size = fee_stat.size();
	
	// 선납 대여료 균등 발행 스케줄 통계
	Hashtable sun_nap_stat = af_db.getFeeScdSunNapStat(m_id, l_cd);
	int sun_nap_stat_size = sun_nap_stat.size();
	
	//휴/대차료 이름
	String h_title = "휴차료";
	if(!String.valueOf(fee.get("CAR_NO")).equals("")){
		if(String.valueOf(fee.get("CAR_NO")).indexOf("허") == -1){				h_title = "대차료"; 
		}else{																	h_title = "휴차료"; }
	}
	
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	String rent_st = String.valueOf(fee.get("RENT_ST"));
	//System.out.println("--"+rent_st);// del
	
	int cnt = 8; //검색 라인수
	int sh_height = request.getParameter("sh_height")==null?140:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//현황 라인수만큼 제한 아이프레임 사이즈
	
	if(!rent_st.equals("1")){
		height = height - (Util.parseInt(rent_st)*60);
	}
	
	//계약기본정보
	ContBaseBean c_base = a_db.getCont(m_id, l_cd);
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(m_id, c_base.getReg_dt());
	//계약승계 혹은 차종변경일때 승계계약 해지내용
	Hashtable cng_cont = af_db.getScdFeeCngContA(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	
	//월렌트정보
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(m_id, l_cd, "1");
	
	//신용카드 자동출금
	ContCmsBean card_cms = a_db.getCardCmsMng(m_id, l_cd);	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//리스트 가기	
	function go_to_list()
	{
		var fm = document.form1;
		fm.mode.value = '';
		fm.target = 'd_content';
		fm.action = 'fee_frame_s.jsp';
		if('<%=from_page%>'=='/fms2/error_mng/cls_fee_scd_dly_frame.jsp') fm.action = '<%=from_page%>';
		fm.submit();
	}	

	//대여료 스케줄 인쇄화면
	function print_view(mode)
	{
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var b_dt = fm.b_dt.value;
		var cls_chk;
		if(fm.cls_chk.checked == true) cls_chk='Y';
		window.open("fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "PRINT_VIEW", "left=50, top=50, width=750, height=640, scrollbars=yes");
	}
	
	//선납대여료균등발행 스케줄 
	function sn_print_view(mode)
	{
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var b_dt = fm.b_dt.value;
		var cls_chk;
		if(fm.cls_chk.checked == true) cls_chk='Y';
		window.open("fee_scd_print_sn.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "PRINT_VIEW", "left=50, top=50, width=750, height=640, scrollbars=yes");
	}
	
	//대여료 스케줄 인쇄화면
	function print_view_ext(mode)
	{
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var b_dt = fm.b_dt.value;
		var cls_chk;
		if(fm.cls_chk.checked == true) cls_chk='Y';
		window.open("fee_scd_print_ext.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "PRINT_VIEW", "left=50, top=50, width=750, height=640, scrollbars=yes");
	}		
	
	//대여료 스케줄 엑셀화면
	function excel_view(mode)
	{
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var b_dt = fm.b_dt.value;
		var cls_chk;
		if(fm.cls_chk.checked == true) cls_chk='Y';
		window.open("fee_scd_excel.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "_blank");
	}		
	
	//대여료스케줄 메일발송
	function FeeScdDocEmail(mode){
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var b_dt = fm.b_dt.value;
		var cls_chk;
		if(fm.cls_chk.checked == true) cls_chk='Y';
		window.open("fee_scd_email_reg.jsp?mail_st=scd_fee_print&m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "ScdDocEmail", "left=50, top=50, width=700, height=450, scrollbars=yes");
	}		
		
	/*fee_c_mgr.jsp-----------------------------------------------------------------------------------------------------------*/
	
	//회차 연장 & 연장회차 삭제
	function ext_scd(gubun, idx, r_st)
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		if(fm.user_id.value == '000029' && gubun == 'EXT')	//한회차 더 생성.. m_id, l_cd, r_st, fee_tm과 default값 필요(fee_est_dt, fee_s_amt, fee_v_amt)
		{
			var m_id 		= fm.m_id.value;
			var l_cd 		= fm.l_cd.value;
			var auth 		= fm.auth.value;		
			var auth_rw 	= fm.auth_rw.value;			
			var user_id 	= fm.user_id.value;			
			var br_id	 	= fm.br_id.value;									
			var prv_mon_yn 	= fm.prv_mon_yn.value;					
			var r_st 		= r_st;
			var fee_est_dt = '';
			var fee_amt = '';			
			var fee_tm = '';
			if(idx == '0'){
				fee_est_dt	= i_fm.t_fee_est_dt.value.substring(8, 10);
				fee_amt		= toInt(parseDigit(i_fm.t_fee_amt.value));
				fee_tm 		= toInt(i_fm.ht_fee_tm.value)+1;
			}else{
				fee_est_dt	= i_fm.t_fee_est_dt[idx].value.substring(8, 10);
				fee_amt		= toInt(parseDigit(i_fm.t_fee_amt[idx].value));
				fee_tm 		= toInt(i_fm.ht_fee_tm[i_fm.ht_fee_tm.length-1].value)+1;			
			}
			
			//계약만료일 체크
			var today = '<%=AddUtil.getDate()%>';			
			if(fm.rent_end_dt.value < today){
				alert('계약만료일이 경과하여 회차를 연장할 수 없습니다.\n\n계약연장 하시거나 계약만료일을 수정하여 주십시오.');
				return;
			}
			//미사용
			//window.open("/fms2/con_fee/ext_scd_i.jsp?auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&prv_mon_yn="+prv_mon_yn+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st+"&fee_est_dt="+fee_est_dt+"&fee_amt="+fee_amt+"&fee_tm="+fee_tm, "EXT_SCD", "left=100, top=100, width=400, height=200");
		}
		else if(fm.user_id.value == '000029' && gubun == 'DROP')	//추가된 회차 삭제.. pk 모두 있어야 함. (m_id, l_cd, r_st, fee_tm, tm_st1, tm_st2)
		{
			fm.r_st.value 		= r_st;
			fm.h_fee_tm.value 	= i_fm.ht_fee_tm[idx].value;
			fm.h_tm_st1.value 	= i_fm.ht_tm_st1[idx].value;
			fm.h_tm_st2.value 	= i_fm.ht_tm_st2[idx].value;
			fm.h_rent_seq.value	= i_fm.ht_rent_seq[idx].value;			
			var tm_st1			= i_fm.t_tm_st1[idx].value;
				
			if(!confirm(fm.h_fee_tm.value+'회차 '+tm_st1+'를 삭제하시겠습니까?'))		return;
			
			fm.h_ext_gubun.value = gubun;
			fm.action = '/fms2/con_fee/ext_scd_i_a.jsp';
			fm.target='i_no';
			//미사용
			//fm.submit();
		}
	}
	
	//미입금 잔액 삭제
	function ext_scd_j(gubun, idx, r_st)
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		if(fm.user_id.value == '000029' && gubun == 'DROP')	//추가된 회차 삭제.. pk 모두 있어야 함. (m_id, l_cd, r_st, fee_tm, tm_st1)
		{
			fm.r_st.value 		= r_st;
			fm.h_fee_tm.value 	= i_fm.ht_fee_tm[idx].value;
			fm.h_tm_st1.value 	= i_fm.ht_tm_st1[idx].value;
			fm.h_tm_st2.value 	= i_fm.ht_tm_st2[idx].value;
			fm.h_rent_seq.value	= i_fm.ht_rent_seq[idx].value;			
			var tm_st1			= i_fm.t_tm_st1[idx].value;
				
			if(!confirm(fm.h_fee_tm.value+'회차 '+tm_st1+'를 삭제하시겠습니까?'))		return;
			
			fm.h_ext_gubun.value = gubun;
			fm.action = '/fms2/con_fee/ext_scd_i_a.jsp';
			fm.target='i_no';
			fm.submit();			
		}
	}
		
	//입금예정일 변경
	function change_est_dt()
	{
		var fm 			= document.form1;
		var m_id 		= fm.m_id.value;
		var l_cd 		= fm.l_cd.value;
		var auth 		= fm.auth.value;		
		var auth_rw 	= fm.auth_rw.value;		
		var user_id 	= fm.user_id.value;			
		var br_id	 	= fm.br_id.value;												
		var prv_mon_yn 	= fm.prv_mon_yn.value;			
		//미사용
		//window.open("/fms2/con_fee/cng_ext_dt_i.jsp?auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&prv_mon_yn="+prv_mon_yn+"&m_id="+m_id+"&l_cd="+l_cd, "CNG_FEE", "left=100, top=100, width=350, height=180");
	}
		
	//대여료 변경
	function change_feeamt(idx)
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		var m_id 		= fm.m_id.value;
		var l_cd 		= fm.l_cd.value;
		var auth 		= fm.auth.value;		
		var auth_rw 	= fm.auth_rw.value;		
		var user_id 	= fm.user_id.value;			
		var br_id	 	= fm.br_id.value;					
		var prv_mon_yn 	= fm.prv_mon_yn.value;		
		var fee_amt;
		if(idx == 0 && i_fm.tot_tm.value == '1'){
			fee_amt		= toInt(parseDigit(i_fm.t_fee_amt.value));		
		}else{
			fee_amt		= toInt(parseDigit(i_fm.t_fee_amt[idx].value));		
		}	
		//미사용
		//window.open("/fms2/con_fee/cng_ext_amt_i.jsp?auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&prv_mon_yn="+prv_mon_yn+"&m_id="+m_id+"&l_cd="+l_cd+"&fee_amt="+fee_amt, "CNG_FEEAMT", "left=100, top=100, width=400, height=180");
	}
				
	//과태료 및 범칙금 납부현황 보기
	function see_pnt()
	{
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		window.open("/fms2/con_fee/pnt_s_p.jsp?m_id="+m_id+"&l_cd="+l_cd, "FINE", "left=100, top=100, width=620, height=350");
	}	
	//특이사항 수정
	function see_etc()
	{
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var c_id = fm.c_id.value;						
		var st = 'mgr';				
		var client_id = fm.client_id.value;
		var etc = fm.etc.value;
		var firm_nm = fm.firm_nm.value;
		var client_nm = fm.client_nm.value;	
		var auth 	= fm.auth.value;		
		var auth_rw = fm.auth_rw.value;
		var user_id = fm.user_id.value;			
		var br_id	= fm.br_id.value;						
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;					
		window.open("/fms2/con_fee/etc_s_p.jsp?m_id="+m_id+"&l_cd="+l_cd+"&st="+st+"&client_id="+client_id+"&etc="+etc+"&firm_nm="+firm_nm+"&client_nm="+client_nm+"&auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc, "ETC", "left=100, top=100, width=520, height=250");
	}	
	
		
	/*fee_c_mgr_in.jsp-----------------------------------------------------------------------------------------------------------*/	
	
	//입금예정일 변경내역 보기
	function view_cng_cau(idx)
	{
		var fm = i_in.form1;
		window.open("/fms2/con_fee/view_cng_fee_s.jsp?dt="+fm.h_pag_cng_dt[idx].value+"&msg="+fm.h_pag_cng_cau[idx].value, "입금예정일변경내역", "left=100, top=100, width=250, height=200, location=no, scrollbars=yes");
	}
	
	//입금처리
	function pay_fee(idx, r_st)
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		var m_id 	= fm.m_id.value;
		var l_cd 	= fm.l_cd.value;
		var auth 	= fm.auth.value;
		var auth_rw = fm.auth_rw.value;	
		var user_id = fm.user_id.value;			
		var br_id	= fm.br_id.value;								
		var prv_mon_yn 	= fm.prv_mon_yn.value;		
		var r_st 	= r_st;
		var rent_seq;
		var fee_tm;		
		var tm_st1;
		var tm_st2;
		var ext_dt;
		if(idx == 0 && i_fm.tot_tm.value == '1'){
			fee_tm		= i_fm.ht_fee_tm.value;
			tm_st1 		= i_fm.ht_tm_st1.value;		
			tm_st2 		= i_fm.ht_tm_st2.value;
			rent_seq 	= i_fm.ht_rent_seq.value;		
		}else{
			fee_tm		= i_fm.ht_fee_tm[idx].value;
			tm_st1 		= i_fm.ht_tm_st1[idx].value;
			tm_st2 		= i_fm.ht_tm_st2[idx].value;
			rent_seq	= i_fm.ht_rent_seq[idx].value;			
		}		
		//네오엠 자동전표 기능을 위해 세금계산서 발행일자가 꼭 필요!
		//미사용
		//window.open("/fms2/con_fee/fee_pay_u.jsp?auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st+"&fee_tm="+fee_tm+"&tm_st1="+tm_st1+"&tm_st2="+tm_st2+"&prv_mon_yn="+prv_mon_yn+"&ext_dt="+ext_dt+"&rent_seq="+rent_seq, "PAY_FEE", "left=100, top=100, width=500, height=425, scrollbars=yes, STATUS=YES");
	}

	//입금취소
	function cancel_rc(idx, r_st)
	{
		var i_fm = i_in.form1;
		var fm = document.form1;
		fm.r_st.value 		= r_st;
		var tm_st1;
		var rc_dt;
		if(idx == 0 && i_fm.tot_tm.value == '1'){
			fm.h_fee_tm.value 	= i_fm.ht_fee_tm.value;
			fm.h_tm_st1.value 	= i_fm.ht_tm_st1.value;
			fm.h_tm_st2.value 	= i_fm.ht_tm_st2.value;
			fm.h_rent_seq.value = i_fm.ht_rent_seq.value;			
			tm_st1				= i_fm.t_tm_st1.value;
			fm.h_fee_amt.value 	= parseDigit(i_fm.t_fee_amt.value);
			fm.h_rc_amt.value 	= parseDigit(i_fm.t_rc_amt.value);
			rc_dt 				= i_fm.t_rc_dt.value;
		}else{
			fm.h_fee_tm.value 	= i_fm.ht_fee_tm[idx].value;
			fm.h_tm_st1.value 	= i_fm.ht_tm_st1[idx].value;
			fm.h_tm_st2.value 	= i_fm.ht_tm_st2[idx].value;
			fm.h_rent_seq.value = i_fm.ht_rent_seq[idx].value;
			tm_st1				= i_fm.t_tm_st1[idx].value;
			fm.h_fee_amt.value 	= parseDigit(i_fm.t_fee_amt[idx].value);
			fm.h_rc_amt.value 	= parseDigit(i_fm.t_rc_amt[idx].value);
			rc_dt 				= i_fm.t_rc_dt[idx].value;
		}				
		if(confirm(fm.h_fee_tm.value+'회차 '+ tm_st1+' ('+rc_dt+'에 '+fm.h_rc_amt.value+'원 입금처리됨)를 \n 입금취소처리하시겠습니까?'))
		{
			fm.action='/fms2/con_fee/cancel_rc_u.jsp';
			fm.target = 'i_no';
			//fm.target = '_blank'
			fm.submit();
		}
	}
	
	//수정
	function change_scd(idx, r_st)
	{
		var i_fm = i_in.form1;
		var fm = document.form1;
		fm.r_st.value = r_st;
		var tm_st1;
		var rc_yn;
		if(idx == 0 && i_fm.tot_tm.value == '1'){
			fm.h_fee_tm.value 	= i_fm.ht_fee_tm.value;
			fm.h_tm_st1.value 	= i_fm.ht_tm_st1.value;
			fm.h_tm_st2.value 	= i_fm.ht_tm_st2.value;
			fm.h_rent_seq.value	= i_fm.ht_rent_seq.value;
			tm_st1 				= i_fm.t_tm_st1.value;
			fm.h_fee_amt.value 	= parseDigit(i_fm.t_fee_amt.value);
			fm.h_fee_s_amt.value= parseDigit(i_fm.t_fee_s_amt.value);
			fm.h_fee_v_amt.value= parseDigit(i_fm.t_fee_v_amt.value);
			fm.h_rc_dt.value 	= i_fm.t_rc_dt.value;
			rc_yn 				= i_fm.ht_rc_yn.value;
		}else{
			fm.h_fee_tm.value 	= i_fm.ht_fee_tm[idx].value;
			fm.h_tm_st1.value 	= i_fm.ht_tm_st1[idx].value;
			fm.h_tm_st2.value 	= i_fm.ht_tm_st2[idx].value;
			fm.h_rent_seq.value	= i_fm.ht_rent_seq[idx].value;			
			tm_st1 				= i_fm.t_tm_st1[idx].value;
			fm.h_fee_amt.value 	= parseDigit(i_fm.t_fee_amt[idx].value);
			fm.h_fee_s_amt.value= parseDigit(i_fm.t_fee_s_amt[idx].value);
			fm.h_fee_v_amt.value= parseDigit(i_fm.t_fee_v_amt[idx].value);
			fm.h_rc_dt.value 	= i_fm.t_rc_dt[idx].value;
			rc_yn 				= i_fm.ht_rc_yn[idx].value;
		}				
		
		/*미입금인경우 - 대여료금액 변경*/
		if(rc_yn == '0'){
			if((fm.h_fee_amt.value == '0')||(fm.h_fee_amt.value.length > 8)){	alert('대여료금액을 확인하십시오');		return;		}
			if(confirm('수정하시겠습니까?'))
			{
				fm.action='/fms2/con_fee/mod_scd_u.jsp';
				fm.target = 'i_no';
				//미사용
				//fm.submit();
			}
		}
		/* 입금인 경우 - 입금일자 변경*/
		else
		{
			if(fm.h_rc_dt.value == ''){		alert('입금일자를 확인하십시오');		return;		}
			if(confirm('수정하시겠습니까?'))
			{
				fm.action='/fms2/con_fee/mod_scd_u.jsp';
				fm.target = 'i_no';
				//미사용
				//fm.submit();
			}
		}
	}

	//대여료 공급가,부가세 계산 세팅
	function cal_sv_amt(idx)
	{
		var fm = i_in.form1;
		if(idx == 0 && fm.tot_tm.value == '1'){
			if(parseDigit(fm.t_fee_amt.value).length > 8)
			{	alert('대여료금액을 확인하십시오');		return;	}
			fm.t_fee_amt.value = parseDecimal(fm.t_fee_amt.value);
			fm.t_fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.t_fee_amt.value))));
			fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_amt.value)) - toInt(parseDigit(fm.t_fee_s_amt.value)));
		}else{
			if(parseDigit(fm.t_fee_amt[idx].value).length > 8)
			{	alert('대여료금액을 확인하십시오');		return;	}
			fm.t_fee_amt[idx].value = parseDecimal(fm.t_fee_amt[idx].value);
			fm.t_fee_s_amt[idx].value = parseDecimal(sup_amt(toInt(parseDigit(fm.t_fee_amt[idx].value))));
			fm.t_fee_v_amt[idx].value = parseDecimal(toInt(parseDigit(fm.t_fee_amt[idx].value)) - toInt(parseDigit(fm.t_fee_s_amt[idx].value)));
		}
	}
	
	//대여료, 연체료 통계 셋팅
	function set_stat_amt(){
		var fm = document.form1;
		for(i=0; i<3; i++){ 	
			fm.s_n[i].value = parseDecimal(toInt(parseDigit(fm.s_s[i].value)) + toInt(parseDigit(fm.s_v[i].value)));		
			fm.t_c.value = parseDecimal(toInt(parseDigit(fm.t_c.value)) + toInt(parseDigit(fm.s_c[i].value)));
			fm.t_s.value = parseDecimal(toInt(parseDigit(fm.t_s.value)) + toInt(parseDigit(fm.s_s[i].value)));
			fm.t_v.value = parseDecimal(toInt(parseDigit(fm.t_v.value)) + toInt(parseDigit(fm.s_v[i].value)));
			fm.t_n.value = parseDecimal(toInt(parseDigit(fm.t_n.value)) + toInt(parseDigit(fm.s_n[i].value)));
		}		
			fm.s_s[3].value = parseDecimal(toInt(parseDigit(fm.s_n[3].value)) - toInt(parseDigit(fm.s_v[3].value)));
	}
	//연체료 수금관리
	function get_dly_scd(){
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var c_id = fm.c_id.value;						
		var mode = fm.mode.value;				
		var auth 	= fm.auth.value;		
		var auth_rw = fm.auth_rw.value;
		var user_id = fm.user_id.value;			
		var br_id	= fm.br_id.value;						
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;					
		var idx 	= fm.idx.value;							
		window.open("/fms2/con_fee/dly_scd.jsp?m_id="+m_id+"&l_cd="+l_cd+"&mode="+mode+"&auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&idx="+idx, "DLY_SCD", "left=200, top=10, width=650, height=700, scrollbars=yes");	
	}
	
	// 선납대여료균등발행 통계 금액 세팅
	function set_sun_nap_stat_amt(){
		var fm = document.form1;
		fm.p_n.value = parseDecimal(toInt(parseDigit(fm.p_s.value)) + toInt(parseDigit(fm.p_v.value)));		// 발행 금액 합계
		fm.n_p_n.value = parseDecimal(toInt(parseDigit(fm.n_p_s.value)) + toInt(parseDigit(fm.n_p_v.value)));	// 미발행 금액 합계
		fm.s_t_c.value = parseDecimal(toInt(parseDigit(fm.p_c.value)) + toInt(parseDigit(fm.n_p_c.value)));	// 합계 건수
		fm.s_t_s.value = parseDecimal(toInt(parseDigit(fm.p_s.value)) + toInt(parseDigit(fm.n_p_s.value)));	// 공급가 합계
		fm.s_t_v.value = parseDecimal(toInt(parseDigit(fm.p_v.value)) + toInt(parseDigit(fm.n_p_v.value)));	// 부가세 합계
		fm.s_t_n.value = parseDecimal(toInt(parseDigit(fm.p_n.value)) + toInt(parseDigit(fm.n_p_n.value)));	// 총합금액
	}
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	
	
	function view_memo()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;		
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		var r_st = fm.r_st.value;						
//		window.open("/fms2/con_fee/fee_memo_frame_s.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "FEE_MEMO", "left=0, top=0, width=800, height=750");
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw="+auth_rw+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st+"&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750");		
	}	
	//기타 대여료스케줄관리로 이동	
	function move_fee_scd(){
		var fm = document.form1;	
		fm.target = 'd_content';	
		fm.action = '/fms2/con_fee/fee_scd_u_frame.jsp';
		fm.submit();								
	}
	
	function search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == '1') fm.t_wd.value = fm.s_firm_nm.value;
		if(s_kd == '2') fm.t_wd.value = fm.s_rent_l_cd.value;
		if(s_kd == '3') fm.t_wd.value = fm.s_car_no.value;	
		if(fm.t_wd.value == ''){ alert('검색할 단어를 입력하십시오.'); return; }			
		window.open("about:blank", "SEARCH", "left=50, top=50, width=880, height=520, scrollbars=yes");				
		fm.action = "fee_search_sc.jsp";
		fm.target = "SEARCH";
		fm.submit();
	}	
	function enter(s_kd){
		var keyValue = event.keyCode;
		if (keyValue =='13') search(s_kd);
	}
	
	function all_pay_fee(){
		var fm = document.form1;
		window.open("about:blank", "FEEPAYS", "left=50, top=50, width=830, height=620, scrollbars=yes");				
		fm.action = "fee_pay_all_u.jsp";
		fm.target = "FEEPAYS";
		fm.submit();
	}
		
	//스케줄변경이력
	function FeeScdCngList(){
		var fm = document.form1;
		window.open("about:blank", "ScdCngList", "left=50, top=50, width=900, height=600, scrollbars=yes");				
		fm.action = "fee_scd_u_cnglist.jsp";
		fm.target = "ScdCngList";
		fm.submit();	
	}	
	//계산서일시중지관리
	function FeeScdStop(){
		var fm = document.form1;
		window.open("about:blank", "ScdStopList", "left=50, top=50, width=850, height=700, scrollbars=yes");				
		fm.action = "fee_scd_u_stoplist.jsp";
		fm.target = "ScdStopList";
		fm.submit();
	}		
	
	//대여료 일시납 계산(6개월이상)
	function view_all_pay_account(){
		var fm = document.form1;
		window.open("about:blank", "AllPayAccount", "left=50, top=10, width=900, height=900, scrollbars=yes");
		fm.action = "fee_scd_account_allpay_frame.jsp";
		fm.target = "AllPayAccount";
		fm.submit();
	}
	
	//연체료 미래일자 계산
	function view_redly_account(){
		var fm = document.form1;
		window.open("about:blank", "RedlyAccount", "left=50, top=10, width=400, height=200, scrollbars=yes");
		fm.action = "fee_scd_account_redly_sc.jsp";
		fm.target = "RedlyAccount";
		fm.submit();
	}	
	
	//전체이용차량리스트
	function list_view() {
		window.open("/acar/car_rent/scd_fee_rent_list.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>", "print_view", "left=100, top=100, width=1300, height=700, scrollbars=yes");
	}
	
	//해지계약 연체료 재계산
	function cls_scd_account(){
		var fm = document.form1;
		fm.action='fee_scd_account_cls_sc.jsp';		
		fm.target = '_blank'
		fm.submit();
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.button_style {
	background-image: linear-gradient(#919191, #787878);
    font-size: 10px;
    font-weight: bold;
    cursor: pointer;
    border-radius: 3px;
    color: #FFF;
    border: 0;
    outline: 0;
    padding: 5px 8px;
    margin: 3px;
}
</style>
</head>
<body rightmargin=0>

<form name='form1' action='' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='prv_mon_yn' value='<%=fee.get("PRV_MON_YN")%>'>
<input type='hidden' name='client_id' value='<%=fee.get("CLIENT_ID")%>'>
<input type='hidden' name='etc' value='<%=fee.get("ETC")%>'>
<input type='hidden' name='firm_nm' value='<%=fee.get("FIRM_NM")%>'>
<input type='hidden' name='client_nm' value='<%=fee.get("CLIENT_NM")%>'>
<input type='hidden' name='r_st' value='<%=fee.get("RENT_ST")%>'>
<input type='hidden' name='rent_st' value='<%=fee.get("RENT_ST")%>'>
<input type='hidden' name='rent_dt' value='<%=fee.get("RENT_DT")%>'>
<input type='hidden' name='h_rent_seq' value=''>
<input type='hidden' name='h_fee_tm' value=''>
<input type='hidden' name='h_tm_st1' value=''>
<input type='hidden' name='h_tm_st2' value=''>
<input type='hidden' name='h_fee_amt' value=''>
<input type='hidden' name='h_fee_s_amt' value=''>
<input type='hidden' name='h_fee_v_amt' value=''>
<input type='hidden' name='h_rc_amt' value=''>
<input type='hidden' name='h_rc_dt' value=''>
<input type='hidden' name='h_fee_ext_dt' value=''>
<input type='hidden' name='h_ext_gubun' value=''>
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
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='rent_end_dt' value='<%=fee.get("RENT_END_DT")%>'>
<input type='hidden' name='f_list' value='pay'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='fee_scd_size' value='<%=fee_scd_size%>'>
<input type='hidden' name='fee_scd_sun_nap_size' value='<%=fee_scd_sun_nap_size%>'>
<input type='hidden' name='cls_dt' value='<%=cls.getCls_dt()%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > 대여료 관리 > <span class=style5>대여료 스케줄 조회 및 수금</span></span></td>	
                    <td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>[계약승계] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("FIRM_NM")%>, 승계일자 : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%> <%}%>
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>[차종변경] 원계약 : <%=begin.get("RENT_L_CD")%> <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, 변경일자 : <%=begin.get("CLS_DT")%><%}%>            	    
					
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>[계약승계] 승계계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 승계일자 : <%if(String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("")){%><%=cng_cont.get("CLS_DT")%><%}else{%><%=cng_cont.get("RENT_SUC_DT")%><%}%> <%if(!String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("") && !String.valueOf(cng_cont.get("RENT_SUC_DT")).equals(String.valueOf(cng_cont.get("CLS_DT")))){%>, 해지일자 : <%=cng_cont.get("CLS_DT")%><%}%> <%}%>
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>[차종변경] 변경계약 : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, 변경일자 : <%=cng_cont.get("CLS_DT")%> <%}%>					
					</font>&nbsp;
					</td>			
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td align=right>
	    &nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>
	    &nbsp;&nbsp;<a href="javascript:history.go(-1);" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_back_p.gif" align="absmiddle" border="0"></a></td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
        	    <tr><td class=line2></td></tr>
                <tr> 
                    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='8%' class='title' >계약번호</td>
                                <td width='13%'>&nbsp;<input type='text' name='s_rent_l_cd' value='<%=fee.get("RENT_L_CD")%>' size='16' class='default' onKeyDown='javascript:enter(2)' style='IME-MODE: inactive'></td>
                                <td width='8%' class='title' >상호</td>
                                <td width='15%'>&nbsp;<input type='text' name='s_firm_nm' value='<%=fee.get("FIRM_NM")%>' size='23' class='default' onKeyDown='javascript:enter(1)' style='IME-MODE: active'></td>
                                <td width='8%' class='title' >고객명</td>
                                <td width='9%'>&nbsp;<a href="javascript:view_client('<%=m_id%>', '<%=l_cd%>', '<%=fee.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=fee.get("CLIENT_NM")%></a></td>
                                <td width='8%' class='title' >차량번호</td>
                                <td width='12%'>&nbsp;<input type='text' name='s_car_no' value='<%=fee.get("CAR_NO")%>' size='12' class='default' onKeyDown='javascript:enter(3)' style='IME-MODE: active'></td>
                                <td width='8%' class='title' >차명</td>
                                <td width='12%'>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm(), 6)%></span></td>
                            </tr>
                            <tr> 
                                <td class='title' >대여방식</td>
                                <td> 
                                <%if(max_fee.getRent_way().equals("1")){%>
                                &nbsp;일반식 
                                <%}else if(max_fee.getRent_way().equals("2")){%>
                                &nbsp;맞춤식 
                                <%}else{%>
                                &nbsp;기본식 
                                <%}%>
                                </td>
                                <td class='title' > 대여기간 </td>
                                <td>&nbsp;<%=f_fee.getCon_mon()%>개월</td>
                                <td class='title' > 개시일 </td>
                                <td>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                                <td class='title' > 만료일 </td>
                                <td>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_end_dt())%></td>
                                <td class='title' >채권유형</td>
                                <td>&nbsp;<%=fee.get("GI_ST")%></td>
                            </tr>
                            <tr> 
                                <td class='title' > 2회차청구구분 </td>
                                <td>&nbsp;<%if(c_base.getCar_st().equals("4")){%>[월렌트]<%String cms_type = f_fee_rm.getCms_type();%><%if(cms_type.equals("card")){%>신용카드 <%}else if(cms_type.equals("cms")){%>CMS<%}%><%}%></td>
                                <td class='title' >CMS</td>
                                <td colspan='3'>&nbsp;
								<%if(!cms.getCms_bank().equals("")){%>
									<b><%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%></b>
        			 				<%=cms.getCms_bank()%> <%=cms.getCms_acc_no()%> <%=cms.getCms_dep_nm()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%><br>&nbsp;&nbsp;(매월 <%=cms.getCms_day()%>일, 신청일 <%=AddUtil.ChangeDate2(cms.getApp_dt())%>, 최종수정일 <%=AddUtil.ChangeDate2(cms.getUpdate_dt())%>)
        			 			<%}else{%>
        			 			-
        			 			<%}%>	
                                </td>
                                <td class='title' >신용카드</td>
                                <td colspan='3'>&nbsp;
								<%if(c_base.getCar_st().equals("4") && !card_cms.getCms_acc_no().equals("")){%>
        			 			<b>[<%=card_cms.getCbit()%>]</b>	<%=card_cms.getCms_bank()%> <%=card_cms.getCms_acc_no()%> <%=card_cms.getCms_dep_nm()%>  : 신청일 <%=AddUtil.ChangeDate2(card_cms.getAdate())%>)
        			 			<%}else{%>
        			 			-
        			 			<%}%>	
                                </td>                                
                            </tr>							
                            <tr> 
                                <td class='title'> 선납금 </td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getPp_s_amt()+f_fee.getPp_v_amt())%>원
                                	<%if(f_fee.getPp_chk().equals("0")){%><br>&nbsp;매월균등발행<%}%>
                                </td>
                                <td class='title' > 보증금 </td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getGrt_amt_s())%>원&nbsp;</td>
                                <td class='title' >개시대여료</td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getIfee_s_amt()+f_fee.getIfee_v_amt())%>원</td>
                                <td class='title' >월대여료</td>
                                <td colspan="3">&nbsp;<%=Util.parseDecimal(f_fee.getFee_s_amt()+f_fee.getFee_v_amt())%>원
                                <%if(f_fee.getFee_chk().equals("1")){%><br>&nbsp;일시완납<%}%>	
                                </td>
                            </tr>
							<%if(!f_fee.getFee_cdt().equals("")){%>							
                            <tr> 
                                <td class='title' >비고</td>
                                <td colspan='9'>&nbsp;<%=f_fee.getFee_cdt()%>
                                </td>
                            </tr>	
							<%}%>													
                        </table>
                    </td>
                </tr>
		  <%for(int i=2; i<=AddUtil.parseInt(rent_st); i++){
				ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
				if(!ext_fee.getCon_mon().equals("")){%>	
				<tr></tr><tr></tr>
                <tr> 
                    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td class='title' width="8%" >연장계약일</td>
                                <td width="13%">&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_dt())%></td>
                                <td class='title' width="8%" >대여기간</td>
                                <td width="15%">&nbsp;<%=ext_fee.getCon_mon()%>개월</td>
                                <td class='title' width="8%" >개시일</td>
                                <td width="9%">&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></td>
                                <td class='title' width="8%" >만료일</td>
                                <td width="12%">&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%></td>
                                <td class='title' width="8%" >담당자</td>
                                <td width="12%">&nbsp;<%=c_db.getNameById(ext_fee.getExt_agnt(),"USER")%></td>
                            </tr>
                            <tr> 
                                <td class='title' >선납금</td>
                           	    <td>&nbsp;<%=Util.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>원
                           	    <%if(ext_fee.getPp_chk().equals("0")){%><br>&nbsp;매월균등발행<%}%></td>
                                <td class='title' >보증금</td>
                                <td>&nbsp;<%=Util.parseDecimal(ext_fee.getGrt_amt_s())%>원</td>
                                <td class='title' >개시대여료</td>
                                <td>&nbsp;<%=Util.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>원</td>
                                <td class='title' >월대여료</td>
                           	    <td colspan="3">&nbsp;<%=Util.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>원
                           	    <%if(ext_fee.getFee_chk().equals("1")){%><br>&nbsp;일시완납<%}%></td>
                            </tr>
							<%if(!ext_fee.getFee_cdt().equals("")){%>
                            <tr> 
                                <td class='title' >비고</td>
                                <td colspan='9'>&nbsp;<%=ext_fee.getFee_cdt()%>
                                </td>
                            </tr>									
							<%}%>												
                        </table>
                    </td>
                </tr>
          <%	}
		  }%>
                <tr></tr><tr></tr>
                <tr> 
                    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td class='title' width="8%" >특이사항</td>
                                 <td width="92%">
                                    <table width=100% border=0 cellspacing=01 cellpadding=3>
                                        <tR>
                                            <td>
                                            <%if(fee.get("ETC") != null){%>
                                            <%= fee.get("ETC")%>
                                            <%}%>
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
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>
        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 수금 스케쥴</span>
        	&nbsp;
        	<!-- <input type="button" class="button_style" id="scd_list_button" value="이용차량 리스트" onclick="list_view();"> -->
        	<a href="javascript:list_view();"><img src="/acar/images/center/button_all_car.png" align="absmiddle" border="0"></a>&nbsp;
        </td>
        <td align="right" colspan=2>
		<img src=/acar/images/center/arrow.gif> 대여료스케줄표
        <input type='text' name='b_dt' size='12' value='<%if(cls.getCls_dt().equals("")){%><%=Util.getDate()%><%}else{%><%=cls.getCls_dt()%><%}%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
	    <label><input type="checkbox" name="cls_chk" value="Y">해지일분제외</label>
		[
	    <a href="javascript:print_view('');" title='기본' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>&nbsp;
		
		<a href="javascript:print_view_ext('');" title='고소장 첨부용' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_gsj.gif" align="absmiddle" border="0"></a>&nbsp;
		
		/
		<a href="javascript:FeeScdDocEmail()"><img src=/acar/images/center/button_in_email.gif  align=absmiddle border="0"></a>
		/
	    <a href="javascript:excel_view('');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>
		]
        </td>
    </tr>
	<%	int i_height = (fee_scd_size*22)+60;
		if(i_height > 400){ i_height = 400; }
		if(i_height < 100){ i_height = 300; }
		%>
    <tr> 
        <td colspan='3'>
	  	    <iframe src="/fms2/con_fee/fee_c_mgr_in.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&prv_mon_yn=<%=fee.get("PRV_MON_YN")%>&brch_id=<%=fee.get("BRCH_ID")%>" name="i_in" width="100%" height="<%=i_height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>  
			<!--height="<%if(fee.get("RENT_ST").equals("2")){%>270<%}else if(fee.get("RENT_ST").equals("3")){%>230<%}else{%>315<%}%>"-->
	    </td>
   	</tr>
   	<tr>
   	    <td style='height:5'></td>
   	</tr>
    <tr> 
        <td> 
		<font color="#FF0000">b</font>:출고전대차 (만기매칭대차)
        대여료 표시,
		회차 클릭시 사용기간 확인 가능
        <td align='right' colspan="2"> 		
       	<%	if(fee_scd_size > 0){%>       	
		<a href="javascript:move_fee_scd()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_sch.gif align=absmiddle border="0"></a>&nbsp;&nbsp;		
		<a href="javascript:FeeScdStop()"><img src=/acar/images/center/button_ncha.gif  align=absmiddle border="0"></a>&nbsp;&nbsp;
		<a href="javascript:FeeScdCngList()"><img src=/acar/images/center/button_scd_bgir.gif  align=absmiddle border="0"></a>&nbsp;&nbsp;
       	<a href="javascript:see_etc()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify_e.gif align=absmiddle border="0"></a>&nbsp;&nbsp; 
		<a href="javascript:view_memo()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_tel.gif align=absmiddle border="0"></a> 
       	<%	}%>
        </td>
    </tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<%if(fee_scd_sun_nap_size > 0){%>
	<tr>
        <td class=h></td>
    </tr>
    <%	int j_height = (fee_scd_sun_nap_size*22)+60;
		if(j_height > 400){ j_height = 400; }
		if(j_height < 100){ j_height = 100; }
		%>
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선납대여료균등발행 스케줄</span></td>
    	
    	<td align="right">
    		&#91;&nbsp;<a href="javascript:sn_print_view('');" title='선납대여료균등발행 프린트' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>&nbsp;&#93;
    	</td>
    </tr>
    <tr>
    	<td colspan="2">
	  	    <iframe src="/fms2/con_fee/fee_c_mgr_in_sn.jsp?auth=<%=auth%>&auth_rw=<%=auth_rw%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&prv_mon_yn=<%=fee.get("PRV_MON_YN")%>&brch_id=<%=fee.get("BRCH_ID")%>" name="i_in" width="100%" height="<%=j_height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
	    </td>
    </tr>
    <%}%>
    <tr>
    	<td class=h></td>
    </tr>
</table>

  <%if(fee_stat_size > 0){%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
	    <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 통계</span></td>
	</tr>
	<tr>
	    <td>
		    <table border="0" cellspacing="0" cellpadding="0" width=100%>
		        <tr>
			        <td width=50%>
			            <table border="0" cellspacing="0" cellpadding="0" width=100%>
			                <tr>
			                    <td class=line2></td>
			                </tr>
				            <tr>
				                <td class='line'>
					                <table border="0" cellspacing="1" cellpadding="0" width=100%>
                                        <tr>
                    						<td class='title' width='20%'>구분</td>
                    						<td class='title' width='20%'>건수</td>
                    						<td class='title' width='20%'>공급가</td>
                    						<td class='title' width='20%'>부가세</td>
                    						<td class='title' width='20%'>합계</td>
					                    </tr>
					                    <tr>
                    						<td class='title'> 미수금 </td>
                    						<td align='center'>
<input type='text' name='s_c' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("NC")))%>' size='3' class='whitenum' readonly>건&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_s' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("NS")))%>' size='10' class='whitenum' readonly>원&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("NV")))%>' size='10' class='whitenum' readonly>원&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_n' value='' size='10' class='whitenum' readonly>원&nbsp;</td>
					                    </tr>
					                    <tr>
                    					    <td class='title'> 수금 </td>
                    						<td align='center'>
<input type='text' name='s_c' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("RC")))%>' size='3' class='whitenum' readonly>건&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_s' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("RS")))%>' size='10' class='whitenum' readonly>원&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("RV")))%>' size='10' class='whitenum' readonly>원&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_n' value='' size='10' class='whitenum' readonly>원&nbsp;</td>
					                    </tr>
					                    <tr>
                    						<td class='title'> 미도래금 </td>
                    						<td align='center'>
<input type='text' name='s_c' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("MC")))%>' size='3' class='whitenum' readonly>건&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_s' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("MS")))%>' size='10' class='whitenum' readonly>원&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("MV")))%>' size='10' class='whitenum' readonly>원&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_n' value='' size='10' class='whitenum' readonly>원&nbsp;</td>
                    				    </tr>										
                    				    <tr>
                    						<td class='title'> 합계 </td>
                    						<td align='center'>
<input type='text' name='t_c' value='' size='3' class='whitenum' readonly>건&nbsp;</td>
						                    <td align='center'>
<input type='text' name='t_s' value='' size='10' class='whitenum' readonly>원&nbsp;</td>
						                    <td align='center'>
<input type='text' name='t_v' value='' size='10' class='whitenum' readonly>원&nbsp;</td>
						                    <td align='center'>
<input type='text' name='t_n' value='' size='10' class='whitenum' readonly>원&nbsp;</td>
					                    </tr>
					                </table>
				                </td>
				            </tr>
			            	<tr>
				              <td align='right'><input type="button" class="button" value="대여료 일시납 계산(6개월치이상)" onclick="javascript:view_all_pay_account();"></td>
				            </tr>				            
			            </table>
			        <td width='23%'></td>
			        <td width='27%' valign='top'>
        			    <table border="0" cellspacing="0" cellpadding="0" width=100%>
            				<tr>
			                    <td class=line2></td>
			                </tr>
            				<tr>
            				    <td class='line'>
                					<table border="0" cellspacing="1" cellpadding="0" width=100%>
                                        <tr>
                    						<td class='title' width='40%'>연체건수 </td>
                    						<td align='right'> 
                                              <input type='text' name='s_c' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DC")))%>' size='3' class='whitenum' readonly>
                                              건&nbsp;</td>
                					    </tr>
                					    <tr>											
                                           	<td class='title'> 미수 연체료</td>
                    						<td align='right'>
                    						  <input type='text' name='s_s' value='' size='10' class='whitenum' readonly>원&nbsp;</td>
                					    </tr>
                					    <tr>											
                                           	<td class='title'> 수금 연체료</td>
                    						<td align='right'>
                    						  <input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DT2")))%>' size='10' class='whitenum' readonly>원&nbsp;</td>
                					    </tr>
                					    <tr>											
                                           	<td class='title'>총연체료</td>
                    						<td align='right'>
                						    <input type='text' name='s_n' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DT")))%>' size='10' class='whitenum' readonly>원&nbsp;</td>
                					    </tr>		
                					</table>								
            				    </td>
            				</tr>
            		  		<tr>
            		            <td align="right">
            		            	<%	if(!cls.getCls_dt().equals("") && nm_db.getWorkAuthUser("전산팀",user_id)){%>
            				        <input type="button" class="button" value="해지계약 연체료 재계산" onclick="javascript:cls_scd_account();">
            				        &nbsp;&nbsp;
            				        <%	} %>
            		            	<input type="button" class="button" value="연체료 미래일자 계산" onclick="javascript:view_redly_account();">
            		            	&nbsp;&nbsp;
            				        <a href="javascript:get_dly_scd()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_pay_d.gif align=absmiddle border="0"></a>
            				                    				        
            				    </td>
            		  		</tr>				
        			    </table>
			        </td>
		        </tr>
		    </table>
	    </td>
	</tr>
</table>
  <%	}else{%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
	    <td>
		    대여료 통계가 없습니다
	    </td>
	</tr>
</table>	
  <%	}%>
  
  <%if(fee_scd_sun_nap_size > 0) {%>
	<table border="0" cellspacing="0" cellpadding="0" width=50%>
		<tr>
		    <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선납대여료균등발행 통계</span></td>
		</tr>
		<tr>
	    	<td>
		    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    	<td class=line2></td>
		            <tr>
		                <td class='line'>
			                <table border="0" cellspacing="1" cellpadding="0" width=100%>
                                <tr>
               						<td class='title' width='20%'>구분</td>
               						<td class='title' width='20%'>건수</td>
               						<td class='title' width='20%'>공급가</td>
               						<td class='title' width='20%'>부가세</td>
               						<td class='title' width='20%'>합계</td>
			                    </tr>
			                    <tr>
               						<td class='title'> 발행 </td>
               						<td align='center'>
										<input type='text' name='p_c' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("PC")))%>' size='3' class='whitenum' readonly>건&nbsp;
									</td>
				                    <td align='center'>
											<input type='text' name='p_s' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("PS")))%>' size='10' class='whitenum' readonly>원&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='p_v' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("PV")))%>' size='10' class='whitenum' readonly>원&nbsp;
									</td>
			                    	<td align='center'>
										<input type='text' name='p_n' value='' size='10' class='whitenum' readonly>원&nbsp;
									</td>
			                    </tr>
			                    <tr>
               					    <td class='title'> 미발행 </td>
               						<td align='center'>
										<input type='text' name='n_p_c' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("NPC")))%>' size='3' class='whitenum' readonly>건&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='n_p_s' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("NPS")))%>' size='10' class='whitenum' readonly>원&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='n_p_v' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("NPV")))%>' size='10' class='whitenum' readonly>원&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='n_p_n' value='' size='10' class='whitenum' readonly>원&nbsp;
									</td>
			                    </tr>
                  				<tr>
               						<td class='title'> 합계 </td>
               						<td align='center'>
										<input type='text' name='s_t_c' value='' size='3' class='whitenum' readonly>건&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='s_t_s' value='' size='10' class='whitenum' readonly>원&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='s_t_v' value='' size='10' class='whitenum' readonly>원&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='s_t_n' value='' size='10' class='whitenum' readonly>원&nbsp;
									</td>
			                    </tr>
			            	</table>
		                </td>
		            </tr>
				</table>
			</td>
		</tr>
	</table>
  <%}%>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
	set_stat_amt();
	set_sun_nap_stat_amt();
	
	var fm = document.form1;

	//바로가기
	var s_fm = parent.top_menu.document.form1;
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
	
//-->
</script>  
</body>
</html>
