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
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
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
	
	//�α���ID&������ID&����
	if(user_id.equals("")){ 	user_id = ck_acar_id; }
	if(br_id.equals("")){ 	br_id = login.getCookieValue(request, "acar_br"); }
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "02"); }
	//�α���-�뿩����:����
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//�⺻����
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(m_id, l_cd);
	
	//���ʴ뿩����
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//�������뿩����
	ContFeeBean max_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
	
	//��������
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	
	//��ü�� ����
	boolean flag = af_db.calDelayDtPrint(m_id, l_cd, cls.getCls_dt(), String.valueOf(fee.get("RENT_DT")));
	
	//��������, ���°��϶��� �������� ����
	if(cls.getCls_st().equals("4") || cls.getCls_st().equals("5")){
		flag = af_db.calDelayDtPrint(m_id, l_cd, "", String.valueOf(fee.get("RENT_DT")));
	}
	
	//�Ǻ� �뿩�� ������ ����Ʈ
	Vector fee_scd = af_db.getFeeScdPrint2(l_cd, "", false);
	int fee_scd_size = fee_scd.size();
	
	//�����뿩��յ���� ������ 2018.04.17
	Vector fee_scd_sun_nap = af_db.getFeeScdPrint2(l_cd, "", true);
	int fee_scd_sun_nap_size = fee_scd_sun_nap.size();
	
	//�Ǻ� �뿩�� ������ ���
	Hashtable fee_stat = af_db.getFeeScdStatPrint2(m_id, l_cd);
	int fee_stat_size = fee_stat.size();
	
	// ���� �뿩�� �յ� ���� ������ ���
	Hashtable sun_nap_stat = af_db.getFeeScdSunNapStat(m_id, l_cd);
	int sun_nap_stat_size = sun_nap_stat.size();
	
	//��/������ �̸�
	String h_title = "������";
	if(!String.valueOf(fee.get("CAR_NO")).equals("")){
		if(String.valueOf(fee.get("CAR_NO")).indexOf("��") == -1){				h_title = "������"; 
		}else{																	h_title = "������"; }
	}
	
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	String rent_st = String.valueOf(fee.get("RENT_ST"));
	//System.out.println("--"+rent_st);// del
	
	int cnt = 8; //�˻� ���μ�
	int sh_height = request.getParameter("sh_height")==null?140:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(!rent_st.equals("1")){
		height = height - (Util.parseInt(rent_st)*60);
	}
	
	//���⺻����
	ContBaseBean c_base = a_db.getCont(m_id, l_cd);
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(m_id, c_base.getReg_dt());
	//���°� Ȥ�� ���������϶� �°��� ��������
	Hashtable cng_cont = af_db.getScdFeeCngContA(m_id, l_cd);
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	
	//����Ʈ����
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(m_id, l_cd, "1");
	
	//�ſ�ī�� �ڵ����
	ContCmsBean card_cms = a_db.getCardCmsMng(m_id, l_cd);	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//����Ʈ ����	
	function go_to_list()
	{
		var fm = document.form1;
		fm.mode.value = '';
		fm.target = 'd_content';
		fm.action = 'fee_frame_s.jsp';
		if('<%=from_page%>'=='/fms2/error_mng/cls_fee_scd_dly_frame.jsp') fm.action = '<%=from_page%>';
		fm.submit();
	}	

	//�뿩�� ������ �μ�ȭ��
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
	
	//�����뿩��յ���� ������ 
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
	
	//�뿩�� ������ �μ�ȭ��
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
	
	//�뿩�� ������ ����ȭ��
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
	
	//�뿩�ὺ���� ���Ϲ߼�
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
	
	//ȸ�� ���� & ����ȸ�� ����
	function ext_scd(gubun, idx, r_st)
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		if(fm.user_id.value == '000029' && gubun == 'EXT')	//��ȸ�� �� ����.. m_id, l_cd, r_st, fee_tm�� default�� �ʿ�(fee_est_dt, fee_s_amt, fee_v_amt)
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
			
			//��ุ���� üũ
			var today = '<%=AddUtil.getDate()%>';			
			if(fm.rent_end_dt.value < today){
				alert('��ุ������ ����Ͽ� ȸ���� ������ �� �����ϴ�.\n\n��࿬�� �Ͻðų� ��ุ������ �����Ͽ� �ֽʽÿ�.');
				return;
			}
			//�̻��
			//window.open("/fms2/con_fee/ext_scd_i.jsp?auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&prv_mon_yn="+prv_mon_yn+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st+"&fee_est_dt="+fee_est_dt+"&fee_amt="+fee_amt+"&fee_tm="+fee_tm, "EXT_SCD", "left=100, top=100, width=400, height=200");
		}
		else if(fm.user_id.value == '000029' && gubun == 'DROP')	//�߰��� ȸ�� ����.. pk ��� �־�� ��. (m_id, l_cd, r_st, fee_tm, tm_st1, tm_st2)
		{
			fm.r_st.value 		= r_st;
			fm.h_fee_tm.value 	= i_fm.ht_fee_tm[idx].value;
			fm.h_tm_st1.value 	= i_fm.ht_tm_st1[idx].value;
			fm.h_tm_st2.value 	= i_fm.ht_tm_st2[idx].value;
			fm.h_rent_seq.value	= i_fm.ht_rent_seq[idx].value;			
			var tm_st1			= i_fm.t_tm_st1[idx].value;
				
			if(!confirm(fm.h_fee_tm.value+'ȸ�� '+tm_st1+'�� �����Ͻðڽ��ϱ�?'))		return;
			
			fm.h_ext_gubun.value = gubun;
			fm.action = '/fms2/con_fee/ext_scd_i_a.jsp';
			fm.target='i_no';
			//�̻��
			//fm.submit();
		}
	}
	
	//���Ա� �ܾ� ����
	function ext_scd_j(gubun, idx, r_st)
	{
		var fm = document.form1;
		var i_fm = i_in.form1;
		if(fm.user_id.value == '000029' && gubun == 'DROP')	//�߰��� ȸ�� ����.. pk ��� �־�� ��. (m_id, l_cd, r_st, fee_tm, tm_st1)
		{
			fm.r_st.value 		= r_st;
			fm.h_fee_tm.value 	= i_fm.ht_fee_tm[idx].value;
			fm.h_tm_st1.value 	= i_fm.ht_tm_st1[idx].value;
			fm.h_tm_st2.value 	= i_fm.ht_tm_st2[idx].value;
			fm.h_rent_seq.value	= i_fm.ht_rent_seq[idx].value;			
			var tm_st1			= i_fm.t_tm_st1[idx].value;
				
			if(!confirm(fm.h_fee_tm.value+'ȸ�� '+tm_st1+'�� �����Ͻðڽ��ϱ�?'))		return;
			
			fm.h_ext_gubun.value = gubun;
			fm.action = '/fms2/con_fee/ext_scd_i_a.jsp';
			fm.target='i_no';
			fm.submit();			
		}
	}
		
	//�Աݿ����� ����
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
		//�̻��
		//window.open("/fms2/con_fee/cng_ext_dt_i.jsp?auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&prv_mon_yn="+prv_mon_yn+"&m_id="+m_id+"&l_cd="+l_cd, "CNG_FEE", "left=100, top=100, width=350, height=180");
	}
		
	//�뿩�� ����
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
		//�̻��
		//window.open("/fms2/con_fee/cng_ext_amt_i.jsp?auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&prv_mon_yn="+prv_mon_yn+"&m_id="+m_id+"&l_cd="+l_cd+"&fee_amt="+fee_amt, "CNG_FEEAMT", "left=100, top=100, width=400, height=180");
	}
				
	//���·� �� ��Ģ�� ������Ȳ ����
	function see_pnt()
	{
		var fm = document.form1;
		var m_id = fm.m_id.value;
		var l_cd = fm.l_cd.value;
		window.open("/fms2/con_fee/pnt_s_p.jsp?m_id="+m_id+"&l_cd="+l_cd, "FINE", "left=100, top=100, width=620, height=350");
	}	
	//Ư�̻��� ����
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
	
	//�Աݿ����� ���泻�� ����
	function view_cng_cau(idx)
	{
		var fm = i_in.form1;
		window.open("/fms2/con_fee/view_cng_fee_s.jsp?dt="+fm.h_pag_cng_dt[idx].value+"&msg="+fm.h_pag_cng_cau[idx].value, "�Աݿ����Ϻ��泻��", "left=100, top=100, width=250, height=200, location=no, scrollbars=yes");
	}
	
	//�Ա�ó��
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
		//�׿��� �ڵ���ǥ ����� ���� ���ݰ�꼭 �������ڰ� �� �ʿ�!
		//�̻��
		//window.open("/fms2/con_fee/fee_pay_u.jsp?auth="+auth+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st+"&fee_tm="+fee_tm+"&tm_st1="+tm_st1+"&tm_st2="+tm_st2+"&prv_mon_yn="+prv_mon_yn+"&ext_dt="+ext_dt+"&rent_seq="+rent_seq, "PAY_FEE", "left=100, top=100, width=500, height=425, scrollbars=yes, STATUS=YES");
	}

	//�Ա����
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
		if(confirm(fm.h_fee_tm.value+'ȸ�� '+ tm_st1+' ('+rc_dt+'�� '+fm.h_rc_amt.value+'�� �Ա�ó����)�� \n �Ա����ó���Ͻðڽ��ϱ�?'))
		{
			fm.action='/fms2/con_fee/cancel_rc_u.jsp';
			fm.target = 'i_no';
			//fm.target = '_blank'
			fm.submit();
		}
	}
	
	//����
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
		
		/*���Ա��ΰ�� - �뿩��ݾ� ����*/
		if(rc_yn == '0'){
			if((fm.h_fee_amt.value == '0')||(fm.h_fee_amt.value.length > 8)){	alert('�뿩��ݾ��� Ȯ���Ͻʽÿ�');		return;		}
			if(confirm('�����Ͻðڽ��ϱ�?'))
			{
				fm.action='/fms2/con_fee/mod_scd_u.jsp';
				fm.target = 'i_no';
				//�̻��
				//fm.submit();
			}
		}
		/* �Ա��� ��� - �Ա����� ����*/
		else
		{
			if(fm.h_rc_dt.value == ''){		alert('�Ա����ڸ� Ȯ���Ͻʽÿ�');		return;		}
			if(confirm('�����Ͻðڽ��ϱ�?'))
			{
				fm.action='/fms2/con_fee/mod_scd_u.jsp';
				fm.target = 'i_no';
				//�̻��
				//fm.submit();
			}
		}
	}

	//�뿩�� ���ް�,�ΰ��� ��� ����
	function cal_sv_amt(idx)
	{
		var fm = i_in.form1;
		if(idx == 0 && fm.tot_tm.value == '1'){
			if(parseDigit(fm.t_fee_amt.value).length > 8)
			{	alert('�뿩��ݾ��� Ȯ���Ͻʽÿ�');		return;	}
			fm.t_fee_amt.value = parseDecimal(fm.t_fee_amt.value);
			fm.t_fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.t_fee_amt.value))));
			fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_amt.value)) - toInt(parseDigit(fm.t_fee_s_amt.value)));
		}else{
			if(parseDigit(fm.t_fee_amt[idx].value).length > 8)
			{	alert('�뿩��ݾ��� Ȯ���Ͻʽÿ�');		return;	}
			fm.t_fee_amt[idx].value = parseDecimal(fm.t_fee_amt[idx].value);
			fm.t_fee_s_amt[idx].value = parseDecimal(sup_amt(toInt(parseDigit(fm.t_fee_amt[idx].value))));
			fm.t_fee_v_amt[idx].value = parseDecimal(toInt(parseDigit(fm.t_fee_amt[idx].value)) - toInt(parseDigit(fm.t_fee_s_amt[idx].value)));
		}
	}
	
	//�뿩��, ��ü�� ��� ����
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
	//��ü�� ���ݰ���
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
	
	// �����뿩��յ���� ��� �ݾ� ����
	function set_sun_nap_stat_amt(){
		var fm = document.form1;
		fm.p_n.value = parseDecimal(toInt(parseDigit(fm.p_s.value)) + toInt(parseDigit(fm.p_v.value)));		// ���� �ݾ� �հ�
		fm.n_p_n.value = parseDecimal(toInt(parseDigit(fm.n_p_s.value)) + toInt(parseDigit(fm.n_p_v.value)));	// �̹��� �ݾ� �հ�
		fm.s_t_c.value = parseDecimal(toInt(parseDigit(fm.p_c.value)) + toInt(parseDigit(fm.n_p_c.value)));	// �հ� �Ǽ�
		fm.s_t_s.value = parseDecimal(toInt(parseDigit(fm.p_s.value)) + toInt(parseDigit(fm.n_p_s.value)));	// ���ް� �հ�
		fm.s_t_v.value = parseDecimal(toInt(parseDigit(fm.p_v.value)) + toInt(parseDigit(fm.n_p_v.value)));	// �ΰ��� �հ�
		fm.s_t_n.value = parseDecimal(toInt(parseDigit(fm.p_n.value)) + toInt(parseDigit(fm.n_p_n.value)));	// ���ձݾ�
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
	//��Ÿ �뿩�ὺ���ٰ����� �̵�	
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
		if(fm.t_wd.value == ''){ alert('�˻��� �ܾ �Է��Ͻʽÿ�.'); return; }			
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
		
	//�����ٺ����̷�
	function FeeScdCngList(){
		var fm = document.form1;
		window.open("about:blank", "ScdCngList", "left=50, top=50, width=900, height=600, scrollbars=yes");				
		fm.action = "fee_scd_u_cnglist.jsp";
		fm.target = "ScdCngList";
		fm.submit();	
	}	
	//��꼭�Ͻ���������
	function FeeScdStop(){
		var fm = document.form1;
		window.open("about:blank", "ScdStopList", "left=50, top=50, width=850, height=700, scrollbars=yes");				
		fm.action = "fee_scd_u_stoplist.jsp";
		fm.target = "ScdStopList";
		fm.submit();
	}		
	
	//�뿩�� �Ͻó� ���(6�����̻�)
	function view_all_pay_account(){
		var fm = document.form1;
		window.open("about:blank", "AllPayAccount", "left=50, top=10, width=900, height=900, scrollbars=yes");
		fm.action = "fee_scd_account_allpay_frame.jsp";
		fm.target = "AllPayAccount";
		fm.submit();
	}
	
	//��ü�� �̷����� ���
	function view_redly_account(){
		var fm = document.form1;
		window.open("about:blank", "RedlyAccount", "left=50, top=10, width=400, height=200, scrollbars=yes");
		fm.action = "fee_scd_account_redly_sc.jsp";
		fm.target = "RedlyAccount";
		fm.submit();
	}	
	
	//��ü�̿���������Ʈ
	function list_view() {
		window.open("/acar/car_rent/scd_fee_rent_list.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>", "print_view", "left=100, top=100, width=1300, height=700, scrollbars=yes");
	}
	
	//������� ��ü�� ����
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > �뿩�� ���� > <span class=style5>�뿩�� ������ ��ȸ �� ����</span></span></td>	
                    <td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>[���°�] ����� : <%=begin.get("RENT_L_CD")%> <%=begin.get("FIRM_NM")%>, �°����� : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%> <%}%>
            	    <%if(String.valueOf(begin.get("CLS_ST")).equals("��������")){%>[��������] ����� : <%=begin.get("RENT_L_CD")%> <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, �������� : <%=begin.get("CLS_DT")%><%}%>            	    
					
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("5")){%>[���°�] �°��� : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, �°����� : <%if(String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("")){%><%=cng_cont.get("CLS_DT")%><%}else{%><%=cng_cont.get("RENT_SUC_DT")%><%}%> <%if(!String.valueOf(cng_cont.get("RENT_SUC_DT")).equals("") && !String.valueOf(cng_cont.get("RENT_SUC_DT")).equals(String.valueOf(cng_cont.get("CLS_DT")))){%>, �������� : <%=cng_cont.get("CLS_DT")%><%}%> <%}%>
					<%if(String.valueOf(cng_cont.get("CLS_ST")).equals("4")){%>[��������] ������ : <%=cng_cont.get("RENT_L_CD")%> <%=cng_cont.get("FIRM_NM")%>, �������� : <%=cng_cont.get("CLS_DT")%> <%}%>					
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
                                <td width='8%' class='title' >����ȣ</td>
                                <td width='13%'>&nbsp;<input type='text' name='s_rent_l_cd' value='<%=fee.get("RENT_L_CD")%>' size='16' class='default' onKeyDown='javascript:enter(2)' style='IME-MODE: inactive'></td>
                                <td width='8%' class='title' >��ȣ</td>
                                <td width='15%'>&nbsp;<input type='text' name='s_firm_nm' value='<%=fee.get("FIRM_NM")%>' size='23' class='default' onKeyDown='javascript:enter(1)' style='IME-MODE: active'></td>
                                <td width='8%' class='title' >����</td>
                                <td width='9%'>&nbsp;<a href="javascript:view_client('<%=m_id%>', '<%=l_cd%>', '<%=fee.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=fee.get("CLIENT_NM")%></a></td>
                                <td width='8%' class='title' >������ȣ</td>
                                <td width='12%'>&nbsp;<input type='text' name='s_car_no' value='<%=fee.get("CAR_NO")%>' size='12' class='default' onKeyDown='javascript:enter(3)' style='IME-MODE: active'></td>
                                <td width='8%' class='title' >����</td>
                                <td width='12%'>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm(), 6)%></span></td>
                            </tr>
                            <tr> 
                                <td class='title' >�뿩���</td>
                                <td> 
                                <%if(max_fee.getRent_way().equals("1")){%>
                                &nbsp;�Ϲݽ� 
                                <%}else if(max_fee.getRent_way().equals("2")){%>
                                &nbsp;����� 
                                <%}else{%>
                                &nbsp;�⺻�� 
                                <%}%>
                                </td>
                                <td class='title' > �뿩�Ⱓ </td>
                                <td>&nbsp;<%=f_fee.getCon_mon()%>����</td>
                                <td class='title' > ������ </td>
                                <td>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                                <td class='title' > ������ </td>
                                <td>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_end_dt())%></td>
                                <td class='title' >ä������</td>
                                <td>&nbsp;<%=fee.get("GI_ST")%></td>
                            </tr>
                            <tr> 
                                <td class='title' > 2ȸ��û������ </td>
                                <td>&nbsp;<%if(c_base.getCar_st().equals("4")){%>[����Ʈ]<%String cms_type = f_fee_rm.getCms_type();%><%if(cms_type.equals("card")){%>�ſ�ī�� <%}else if(cms_type.equals("cms")){%>CMS<%}%><%}%></td>
                                <td class='title' >CMS</td>
                                <td colspan='3'>&nbsp;
								<%if(!cms.getCms_bank().equals("")){%>
									<b><%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%></b>
        			 				<%=cms.getCms_bank()%> <%=cms.getCms_acc_no()%> <%=cms.getCms_dep_nm()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%><br>&nbsp;&nbsp;(�ſ� <%=cms.getCms_day()%>��, ��û�� <%=AddUtil.ChangeDate2(cms.getApp_dt())%>, ���������� <%=AddUtil.ChangeDate2(cms.getUpdate_dt())%>)
        			 			<%}else{%>
        			 			-
        			 			<%}%>	
                                </td>
                                <td class='title' >�ſ�ī��</td>
                                <td colspan='3'>&nbsp;
								<%if(c_base.getCar_st().equals("4") && !card_cms.getCms_acc_no().equals("")){%>
        			 			<b>[<%=card_cms.getCbit()%>]</b>	<%=card_cms.getCms_bank()%> <%=card_cms.getCms_acc_no()%> <%=card_cms.getCms_dep_nm()%>  : ��û�� <%=AddUtil.ChangeDate2(card_cms.getAdate())%>)
        			 			<%}else{%>
        			 			-
        			 			<%}%>	
                                </td>                                
                            </tr>							
                            <tr> 
                                <td class='title'> ������ </td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getPp_s_amt()+f_fee.getPp_v_amt())%>��
                                	<%if(f_fee.getPp_chk().equals("0")){%><br>&nbsp;�ſ��յ����<%}%>
                                </td>
                                <td class='title' > ������ </td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getGrt_amt_s())%>��&nbsp;</td>
                                <td class='title' >���ô뿩��</td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getIfee_s_amt()+f_fee.getIfee_v_amt())%>��</td>
                                <td class='title' >���뿩��</td>
                                <td colspan="3">&nbsp;<%=Util.parseDecimal(f_fee.getFee_s_amt()+f_fee.getFee_v_amt())%>��
                                <%if(f_fee.getFee_chk().equals("1")){%><br>&nbsp;�Ͻÿϳ�<%}%>	
                                </td>
                            </tr>
							<%if(!f_fee.getFee_cdt().equals("")){%>							
                            <tr> 
                                <td class='title' >���</td>
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
                                <td class='title' width="8%" >��������</td>
                                <td width="13%">&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_dt())%></td>
                                <td class='title' width="8%" >�뿩�Ⱓ</td>
                                <td width="15%">&nbsp;<%=ext_fee.getCon_mon()%>����</td>
                                <td class='title' width="8%" >������</td>
                                <td width="9%">&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></td>
                                <td class='title' width="8%" >������</td>
                                <td width="12%">&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%></td>
                                <td class='title' width="8%" >�����</td>
                                <td width="12%">&nbsp;<%=c_db.getNameById(ext_fee.getExt_agnt(),"USER")%></td>
                            </tr>
                            <tr> 
                                <td class='title' >������</td>
                           	    <td>&nbsp;<%=Util.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>��
                           	    <%if(ext_fee.getPp_chk().equals("0")){%><br>&nbsp;�ſ��յ����<%}%></td>
                                <td class='title' >������</td>
                                <td>&nbsp;<%=Util.parseDecimal(ext_fee.getGrt_amt_s())%>��</td>
                                <td class='title' >���ô뿩��</td>
                                <td>&nbsp;<%=Util.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>��</td>
                                <td class='title' >���뿩��</td>
                           	    <td colspan="3">&nbsp;<%=Util.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>��
                           	    <%if(ext_fee.getFee_chk().equals("1")){%><br>&nbsp;�Ͻÿϳ�<%}%></td>
                            </tr>
							<%if(!ext_fee.getFee_cdt().equals("")){%>
                            <tr> 
                                <td class='title' >���</td>
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
                                <td class='title' width="8%" >Ư�̻���</td>
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
        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�� ���� ������</span>
        	&nbsp;
        	<!-- <input type="button" class="button_style" id="scd_list_button" value="�̿����� ����Ʈ" onclick="list_view();"> -->
        	<a href="javascript:list_view();"><img src="/acar/images/center/button_all_car.png" align="absmiddle" border="0"></a>&nbsp;
        </td>
        <td align="right" colspan=2>
		<img src=/acar/images/center/arrow.gif> �뿩�ὺ����ǥ
        <input type='text' name='b_dt' size='12' value='<%if(cls.getCls_dt().equals("")){%><%=Util.getDate()%><%}else{%><%=cls.getCls_dt()%><%}%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
	    <label><input type="checkbox" name="cls_chk" value="Y">�����Ϻ�����</label>
		[
	    <a href="javascript:print_view('');" title='�⺻' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>&nbsp;
		
		<a href="javascript:print_view_ext('');" title='����� ÷�ο�' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_gsj.gif" align="absmiddle" border="0"></a>&nbsp;
		
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
		<font color="#FF0000">b</font>:��������� (�����Ī����)
        �뿩�� ǥ��,
		ȸ�� Ŭ���� ���Ⱓ Ȯ�� ����
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
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����뿩��յ���� ������</span></td>
    	
    	<td align="right">
    		&#91;&nbsp;<a href="javascript:sn_print_view('');" title='�����뿩��յ���� ����Ʈ' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_print.gif" align="absmiddle" border="0"></a>&nbsp;&#93;
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
	    <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�� ���</span></td>
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
                    						<td class='title' width='20%'>����</td>
                    						<td class='title' width='20%'>�Ǽ�</td>
                    						<td class='title' width='20%'>���ް�</td>
                    						<td class='title' width='20%'>�ΰ���</td>
                    						<td class='title' width='20%'>�հ�</td>
					                    </tr>
					                    <tr>
                    						<td class='title'> �̼��� </td>
                    						<td align='center'>
<input type='text' name='s_c' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("NC")))%>' size='3' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_s' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("NS")))%>' size='10' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("NV")))%>' size='10' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_n' value='' size='10' class='whitenum' readonly>��&nbsp;</td>
					                    </tr>
					                    <tr>
                    					    <td class='title'> ���� </td>
                    						<td align='center'>
<input type='text' name='s_c' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("RC")))%>' size='3' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_s' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("RS")))%>' size='10' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("RV")))%>' size='10' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_n' value='' size='10' class='whitenum' readonly>��&nbsp;</td>
					                    </tr>
					                    <tr>
                    						<td class='title'> �̵����� </td>
                    						<td align='center'>
<input type='text' name='s_c' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("MC")))%>' size='3' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_s' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("MS")))%>' size='10' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("MV")))%>' size='10' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='s_n' value='' size='10' class='whitenum' readonly>��&nbsp;</td>
                    				    </tr>										
                    				    <tr>
                    						<td class='title'> �հ� </td>
                    						<td align='center'>
<input type='text' name='t_c' value='' size='3' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='t_s' value='' size='10' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='t_v' value='' size='10' class='whitenum' readonly>��&nbsp;</td>
						                    <td align='center'>
<input type='text' name='t_n' value='' size='10' class='whitenum' readonly>��&nbsp;</td>
					                    </tr>
					                </table>
				                </td>
				            </tr>
			            	<tr>
				              <td align='right'><input type="button" class="button" value="�뿩�� �Ͻó� ���(6����ġ�̻�)" onclick="javascript:view_all_pay_account();"></td>
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
                    						<td class='title' width='40%'>��ü�Ǽ� </td>
                    						<td align='right'> 
                                              <input type='text' name='s_c' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DC")))%>' size='3' class='whitenum' readonly>
                                              ��&nbsp;</td>
                					    </tr>
                					    <tr>											
                                           	<td class='title'> �̼� ��ü��</td>
                    						<td align='right'>
                    						  <input type='text' name='s_s' value='' size='10' class='whitenum' readonly>��&nbsp;</td>
                					    </tr>
                					    <tr>											
                                           	<td class='title'> ���� ��ü��</td>
                    						<td align='right'>
                    						  <input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DT2")))%>' size='10' class='whitenum' readonly>��&nbsp;</td>
                					    </tr>
                					    <tr>											
                                           	<td class='title'>�ѿ�ü��</td>
                    						<td align='right'>
                						    <input type='text' name='s_n' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DT")))%>' size='10' class='whitenum' readonly>��&nbsp;</td>
                					    </tr>		
                					</table>								
            				    </td>
            				</tr>
            		  		<tr>
            		            <td align="right">
            		            	<%	if(!cls.getCls_dt().equals("") && nm_db.getWorkAuthUser("������",user_id)){%>
            				        <input type="button" class="button" value="������� ��ü�� ����" onclick="javascript:cls_scd_account();">
            				        &nbsp;&nbsp;
            				        <%	} %>
            		            	<input type="button" class="button" value="��ü�� �̷����� ���" onclick="javascript:view_redly_account();">
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
		    �뿩�� ��谡 �����ϴ�
	    </td>
	</tr>
</table>	
  <%	}%>
  
  <%if(fee_scd_sun_nap_size > 0) {%>
	<table border="0" cellspacing="0" cellpadding="0" width=50%>
		<tr>
		    <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����뿩��յ���� ���</span></td>
		</tr>
		<tr>
	    	<td>
		    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    	<td class=line2></td>
		            <tr>
		                <td class='line'>
			                <table border="0" cellspacing="1" cellpadding="0" width=100%>
                                <tr>
               						<td class='title' width='20%'>����</td>
               						<td class='title' width='20%'>�Ǽ�</td>
               						<td class='title' width='20%'>���ް�</td>
               						<td class='title' width='20%'>�ΰ���</td>
               						<td class='title' width='20%'>�հ�</td>
			                    </tr>
			                    <tr>
               						<td class='title'> ���� </td>
               						<td align='center'>
										<input type='text' name='p_c' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("PC")))%>' size='3' class='whitenum' readonly>��&nbsp;
									</td>
				                    <td align='center'>
											<input type='text' name='p_s' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("PS")))%>' size='10' class='whitenum' readonly>��&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='p_v' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("PV")))%>' size='10' class='whitenum' readonly>��&nbsp;
									</td>
			                    	<td align='center'>
										<input type='text' name='p_n' value='' size='10' class='whitenum' readonly>��&nbsp;
									</td>
			                    </tr>
			                    <tr>
               					    <td class='title'> �̹��� </td>
               						<td align='center'>
										<input type='text' name='n_p_c' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("NPC")))%>' size='3' class='whitenum' readonly>��&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='n_p_s' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("NPS")))%>' size='10' class='whitenum' readonly>��&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='n_p_v' value='<%=Util.parseDecimal(String.valueOf(sun_nap_stat.get("NPV")))%>' size='10' class='whitenum' readonly>��&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='n_p_n' value='' size='10' class='whitenum' readonly>��&nbsp;
									</td>
			                    </tr>
                  				<tr>
               						<td class='title'> �հ� </td>
               						<td align='center'>
										<input type='text' name='s_t_c' value='' size='3' class='whitenum' readonly>��&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='s_t_s' value='' size='10' class='whitenum' readonly>��&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='s_t_v' value='' size='10' class='whitenum' readonly>��&nbsp;
									</td>
				                    <td align='center'>
										<input type='text' name='s_t_n' value='' size='10' class='whitenum' readonly>��&nbsp;
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

	//�ٷΰ���
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
