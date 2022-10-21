<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.estimate_mng.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.res_search.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();	
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");	
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�������뿩����
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�������뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//����ȸ������
	int in_size 			= af_db.getYnCarCallIn(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, String.valueOf(fee_size));
	
	//������ȣ�� �߱�����
	CarSecondPlateBean second_plate = a_db.getCarSecondPlate(rent_mng_id, rent_l_cd);
	
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	//��������-�������̺� ���� ��ȸ
	Hashtable carbase = shDb.getBase(base.getCar_mng_id(), max_fee.getRent_end_dt());
	
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+fee_size+"&from_page="+from_page+"&now_stat="+now_stat;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�������
	function view_cont_b(){
		var fm = document.form1;	
		fm.action = 'lc_b_s.jsp';
		<%if(base.getCar_st().equals("4")){%>
		fm.action = 'lc_b_u_rm.jsp';
		<%}%>
		<%if(base.getCar_gu().equals("2")){%>
		fm.action = 'lc_b_u_ac.jsp';
		<%}%>
		fm.target = 'd_content';
		fm.submit();
	}	

	//����Ʈ
	function list(){
		var fm = document.form1;
		if(fm.from_page.value != '') 	fm.action = fm.from_page.value;
		else 				fm.action = 'lc_s_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	

	//�ϴ������� ����
	function display_c(st){
		var fm = document.form1;	
		fm.action = 'lc_c_c_'+st+'.jsp';
		if(st == 'fee' && fm.car_st.value == '4') fm.action = 'lc_c_c_fee_rm.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}
	
	//��� ���ں� ��������
	function display_h_in(idx){
		var fee_size = <%=fee_size%>;
		
		head_cont.tr_cont.style.display 		= 'none';		
		head_cont.tr_pur.style.display 			= 'none';
		head_cont.tr_car.style.display 			= 'none';
		head_cont.tr_taecha.style.display 		= 'none';
		<%if(!base.getCar_st().equals("2")){ for(int i=0; i<fee_size; i++){%>
		head_cont.tr_fee<%=i+1%>.style.display 	= 'none';
		<%}}%>		
		head_cont.tr_cls.style.display 			= 'none';
				
		if(idx == 'cont'){
			head_cont.tr_cont.style.display 	= '';
		}else if(idx == 'pur'){
			head_cont.tr_pur.style.display 		= '';
		}else if(idx == 'car'){
			head_cont.tr_car.style.display 		= '';
		}else if(idx == 'taecha'){
			head_cont.tr_taecha.style.display 	= '';
		<%if(!base.getCar_st().equals("2")){ for(int i=0; i<fee_size; i++){%>
		}else if(idx == 'fee<%=i+1%>'){
			head_cont.tr_fee<%=i+1%>.style.display 	= '';
		<%}}%>	
		}else if(idx == 'cls'){
			head_cont.tr_cls.style.display 		= '';
		}else if(idx == 'auc'){
			head_cont.tr_auc.style.display 		= '';
		}else{
			head_cont.tr_cont.style.display 	= '';
		}
	}
	
	//�� ����
	function view_client()
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id=<%=base.getClient_id()%>", "CLIENT", "left=10, top=10, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		

	//���ϰ��� ����
	function view_mail(m_id, l_cd){
		window.open("/acar/car_rent/rent_email_reg.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "RentDocEmail", "left=100, top=100, width=1000, height=700, scrollbars=yes, status=yes");		
	}

	//��ĵ���� ����
	function view_scan(m_id, l_cd){
		window.open("scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=900, scrollbars=yes");		
	}

	//��ǰ���� ����
	function view_est(m_id, l_cd){
		window.open("/acar/car_rent/est_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_STAT", "left=100, top=100, width=620, height=400, scrollbars=yes");		
	}
	
	//�ߵ���������  ����
	function view_settle(m_id, l_cd){
	
		alert("���� ���� ���꼭 �Դϴ�. �� ����ݰ� ���̰� ���� �� �ֽ��ϴ�. !!!!");
		alert("�ʰ�����δ���� ������ ����Ÿ��� �Է��ϰ� Ÿ��Ʋ �ʰ�����뿩��(M)�� Ŭ���ϸ� �˾����������� Ȯ���� �� �ֽ��ϴ�. ��������Ÿ� ����Ʈ�̹Ƿ� ���� ����Ÿ��� Ȯ���Ͽ� �Է��Ͻʽÿ�.");
	
		<%if(base.getCar_st().equals("4")){%>
		window.open("/acar/cls_con/cls_settle_rm.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=850, scrollbars=yes, status=yes");	
		<%} else {%>	
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=850, scrollbars=yes, status=yes");		
		<%} %>	
		
	}	
	
	//�뿩��޸�
	function reg_cooperation()
	{
		window.open("/fms2/cooperation/cooperation_i.jsp?from_page=/fms2/lc_rent/lc_s_frame.jsp&rent_l_cd=<%=rent_l_cd%>&client_id=<%=base.getClient_id()%>", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");						
	}		
	
	
	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//�뿩��޸�
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");						
	}		
	
	
	//�ߵ�����
	function view_cls(m_id, l_cd)
	{	
		var url = "";
		
		<%if(base.getCar_st().equals("4")){%>
		url = "/acar/cls_con/cls_u_rm.jsp?m_id="+m_id+"&l_cd="+l_cd;	
		<%}else{%>	
			<%if(base.getUse_yn().equals("Y")){%>
			url = "/acar/cls_con/cls_i_tax.jsp?m_id="+m_id+"&l_cd="+l_cd;
			<%}else{%>
			url = "/acar/cls_con/cls_u.jsp?m_id="+m_id+"&l_cd="+l_cd;		
			<%}%>
		<% } %>	
		window.open(url, "CLS_I", "left=50, top=50, width=840, height=650, status=yes, scrollbars=yes");
	}	
			
	//��ุ��,�ߵ����� ���
	function cancel_cls(m_id, l_cd){
		var fm = document.form1;
		fm.cng_item.value = 'cancel_cls';
		
		if(confirm('����Ͻðڽ��ϱ�?')){	
		if(confirm('���� ����Ͻðڽ��ϱ�?')){		
		if(confirm('��������Ͻðڽ��ϱ�?')){	
			fm.action='lc_c_h_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}}}								
	}
	
	//���� üũ	
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');
		}
	}	
	
	//����
	function update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id' || st == 'bus_id2' || st == 'mng_id' || st == 'mng_id2' || st == 'bus_st' || st == 'est_area' || st == 'bus_agnt_id' || st == 'suc_cls_dt'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650, status=yes, scrollbars=yes");
		}else{
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=500, status=yes, scrollbars=yes");
		}
	}
	//����
	function cont_check(){
		var fm = document.form1;
		fm.cng_item.value = 'cont_check';
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_c_h_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}							
	}
	
	//�����⼭��
	function cont_check_memo(){
		window.open("/fms2/lc_rent/lc_n_memo.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&r_st=<%=fee_size%>", "CONT_CHK_MEMO", "left=0, top=0, width=700, height=600, status=yes, scrollbars=yes");	
	}
	
	//��ຯ��Ȯ��
	function cont_cng_check(){
		var fm = document.form1;
		fm.cng_item.value = 'cont_cng_check';
		
		if(confirm('Ȯ���Ͻðڽ��ϱ�?')){	
			fm.action='lc_c_h_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}							
	}	
	//�����ӽ�ȸ��
	function car_call_in(m_id, l_cd)
	{
		window.open("/fms2/lc_rent/car_call_in_list.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "CAR_CALLIN", "left=0, top=0, width=800, height=750");
	}		
	
	//�縮������
	function car_secondhand(){
		var fm = document.form1;
		
		//if(<%=carbase.get("TODAY_DIST")%>==0 || <%=carbase.get("TODAY_DIST")%>==null){ alert('�Էµ� ����Ÿ��� �����ϴ�. ������-������Ͽ��� ������������ ����Ÿ��� ���� �Է����ּ���'); return;}
		
		
		//����Ʈ
		<%if(base.getCar_st().equals("4")){%>	
		
		<%	if(cr_bean.getSecondhand().equals("1")){%>		 	
				fm.action='/acar/secondhand/secondhand_detail_frame.jsp';		
				fm.target='_blank';
				fm.submit();					
		<%	}else{%>
		if(confirm('�縮��������� ������ �ƴմϴ�. ���� ��������Կ��� �縮������ �������� �������� ���Ǹ� �Ͻñ� �ٶ��ϴ�.')){
				fm.action='/acar/secondhand/secondhand_detail_frame.jsp';		
				fm.target='_blank';
				fm.submit();					
		}	
		<%	}%>							

		
		//����Ʈ�ƴ�	
		<%}else{%>
		if(confirm('��������Ÿ��� <%=carbase.get("TODAY_DIST")%>�Դϴ�. �� ����Ÿ��� �����Ͻðڽ��ϱ�?')){
				fm.action='/acar/secondhand/secondhand_detail_frame.jsp';		
				fm.target='_blank';
				fm.submit();
		}		
		<%}%>
	
	}
	
	
	//�������
	function add_rent_esti_s(){
		window.open("search_car_esti_s.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_ESTI_S", "left=0, top=0, width=1100, height=750, status=yes, scrollbars=yes");	
	}	
	//�߰�����
	function sh_car_amt(){
		window.open("search_sh_car_amt.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_AMT_S", "left=0, top=0, width=1100, height=550, status=yes, scrollbars=yes");	
	}
	
	//����Ʈ �������� ���Ȯ�� ����
	function rent_conform(){
		window.open("/fms2/lc_rent/lc_rm_conform.jsp<%=valus%>", "LC_RM_CONFORM", "left=100, top=100, width=1280, height=850, status=yes, scrollbars=yes");
	}
	
	//����Ʈ �������� ���Ȯ�� ���
	function rent_delete(){
		var fm = document.form1;
		fm.cng_item.value = 'lc_rm_delete';
		if(confirm('����Ͻðڽ��ϱ�?')){
		if(confirm('������ ��� ����Ÿ�� �����ϰ� �˴ϴ�. \n\n�����Ͻðڽ��ϱ�?')){
			fm.action='lc_c_h_a.jsp';
			fm.target='i_no';
			//fm.target='_blank';
			fm.submit();
		}}
	}

	// jjlim@20171101 add kakao_contract
	function view_kakao_contract(m_id, l_cd, car_comp_id) {
        window.open("/acar/kakao/alim_talk_contract.jsp?mng_id="+m_id+"&l_cd="+l_cd+"&car_comp_id="+car_comp_id, "VIEW_KAKAO_CONTRACT", "left=0, top=0, width=800, height=750, scrollbars=yes");
	}
	
	// Ȯ�μ� ��� �˾� 2017.12.27
	function view_confirm_popup(){
		var url = "./lc_c_h_confirm_popup.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(url,"CONFIRM_POPUP", "left=0, top=0, width=760, height=450, scrollbars=yes, status=yes");
	}
	
	// Ȯ�μ� ���ڹ���
	function view_confirm_edoc(){
		var url = "./confirm_doc_list.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=max_fee.getRent_st()%>";		
		window.open(url,"CONFIRM_POPUP", "left=0, top=0, width=760, height=450, scrollbars=yes, status=yes");
	}
	
	//�ɻ��ڷ�
	function view_bus_review(){
		var client_id = '<%=base.getClient_id()%>';
		var url = "./lc_c_h_bus_review_popup.jsp?client_id="+client_id;
		window.open(url,"REVIEW_POPUP", "left=0, top=0, width=1800, height=950, scrollbars=yes");
	}
	
	//�縮�� ��������
	function EstiReReg(){
		var fm = document.form1;
		fm.action = 'get_esti_mng_i_re_rent.jsp';
		fm.target = "_blank";
		fm.submit();
	}	

	//�����̷�
	function view_sh_res_h(){
		var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id=<%=base.getCar_mng_id()%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}	
	//Ư������
	function spedc_car_reg(){
		var SUBWIN="/acar/off_lease/newcar_special_discount_i.jsp?car_mng_id=<%=base.getCar_mng_id()%>";
		window.open(SUBWIN, "specialDiscount", "left=50, top=50, width=650, height=300, scrollbars=yes, status=yes");			
	}
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15" <%if(base.getUse_yn().equals("N")){%>onLoad="javascript:display_h_in('cls');"<%}%>>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st" 		value="<%=fee_size%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="now_stat" 		value="<%=now_stat%>">  
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="car_st" 		value="<%=base.getCar_st()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="cng_item"		value="">    
  <input type='hidden' name="est_st"		value="">      
  <input type='hidden' name="fee_opt_amt"	value="<%=max_fee.getOpt_s_amt()+max_fee.getOpt_v_amt()%>">        
  <input type='hidden' name="fee_rent_st"	value="<%=max_fee.getRent_st()%>">    

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>��༭����</span></span>
                        <%if(!base.getCar_st().equals("4")){%><%if(nm_db.getWorkAuthUser("�����ڸ��",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%><a href="javascript:view_cont_b()" onMouseOver="window.status=''; return true">.</a><%}%><%}%>
                        <%if(base.getCar_st().equals("4")){%><%if(nm_db.getWorkAuthUser("������",user_id)){%><a href="javascript:view_cont_b()" onMouseOver="window.status=''; return true">.</a><%}%><%}%>
                    </td>
                    <td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	          <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%><a href="javascript:display_c('suc_commi')">[���°�]</a> ����� : <%=begin.get("FIRM_NM")%>, �°����� : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%>, ���°������ : <%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>��, �������� : <%=begin.get("CLS_DT")%>, ������� : <%=base.getReg_dt()%> <%}%>
            	          <%if(String.valueOf(begin.get("CLS_ST")).equals("��������")){%>[��������] ����� : <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, �������� : <%=begin.get("CLS_DT")%>, ������� : <%=base.getReg_dt()%><%}%>
			                  </font>&nbsp;
			                  <%if(in_size > 0){%><span class=style5>[����ȸ������]</span><%}%>
			                  <%if(base.getReject_car().equals("Y")){%><span class=style5>[�μ��ź�����]</span><%}%>
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
        <td colspan="2" align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td align=right>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                                <td class=title width=13%>����ȣ</td>
                                <td width=21%>&nbsp;<%=rent_l_cd%></td>
                                <td class=title width=10%>��ȣ</td>
                                <td width=22%>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a>
                                <%	if(!base.getCar_mng_id().equals("") && base.getCar_st().equals("2")){	
                                		//�������� ��������
                            			Hashtable reserv = rs_db.getResCarCase(base.getCar_mng_id(), "2");
                            			String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
                            			//�������� �������
                            			Hashtable reserv2 = rs_db.getResCarCase(base.getCar_mng_id(), "1");
                            			String use_st2 = String.valueOf(reserv2.get("USE_ST"))==null?"":String.valueOf(reserv2.get("USE_ST")); %>
                            			
                            			<%if(!use_st.equals("null")){%>
                              			( [����] <%=reserv.get("RENT_ST")%> &nbsp;<%=reserv.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="�̷�"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              			<%}else{ %>
                              			<%	if(!use_st2.equals("null")){%>
                              			( [����] <%=reserv2.get("RENT_ST")%> &nbsp;<%=reserv2.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="�̷�"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              			<%	} %>
                              			<%} %>
                              			                            			
                            	<%	} %>		
                                </td>
                                <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>����<%}else{%>������ȣ<%}%></td>
                                <td width=25%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a>
                    		          &nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>
                    		        </td>
                            </tr>
                            <%if (!second_plate.getSecond_plate_yn().equals("")) {%>
                            <tr>
                            	<td class=title width=13%>������ȣ��</td>
                                <td colspan="5" width=77%>&nbsp;<%if (second_plate.getSecond_plate_yn().equals("Y")) {%>������ȣ�� �߱�<%} else if (second_plate.getSecond_plate_yn().equals("R")) {%>������ȣ�� ȸ�� (ȸ���� : <%=AddUtil.ChangeDate2(second_plate.getReturn_dt())%>)<%} else if (second_plate.getSecond_plate_yn().equals("N")) {%>������ȣ�� ��ȸ�� (��ȸ�� ���� : <%=second_plate.getEtc()%>)<%}%></td>
                            </tr>
	                    	<%}%>
						</table>
            	    </td>
            	</tr>
            </table>
        </td>
	      <td width=7>&nbsp;</td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr> 	  	
    <%	int height = 160;
    		
    		if(base.getCar_gu().equals("2")) height = 135;
    %>
    <tr> 
        <td colspan="2">
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
    		    <tr>
        		    <td width=32%>
        			  <iframe src="lc_c_h_dt.jsp<%=valus%>" name="head_dt" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                		</iframe>
        			</td>
        			<td width=2%>&nbsp;</td>
        			<td width=67%>
        			  	<iframe src="lc_c_h_in.jsp<%=valus%>" name="head_cont" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                		</iframe>	
        			</td>
    		    </tr>
    		</table>
	    </td>
    </tr>
    <%if(!base.getCar_gu().equals("2")){%>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td colspan="2" style='background-color:e3e3e3; height:1'></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
    <%}%>
    <%if(!base.getCar_st().equals("2")){%>	
    <tr>
		<td colspan="2" align="center">
    	  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    			<tr>
        	    <td align='center'>
        	    
        	    	    <!-- �Ķ���ư -->
                        <a href="javascript:display_c('client')" title='��'><img src=/acar/images/center/button_cnt_cust.gif align=absmiddle border=0></a>&nbsp;
                        <a href="javascript:display_c('car')" title='�ڵ���&����'><img src=/acar/images/center/button_cnt_carins.gif align=absmiddle border=0></a>&nbsp;
                        <a href="javascript:display_c('fee')" title='�뿩'><img src=/acar/images/center/button_cnt_lend.gif align=absmiddle border=0></a>&nbsp;
                        <a href="javascript:display_c('gur')" title='ä��Ȯ��'><img src=/acar/images/center/button_cnt_cghb.gif align=absmiddle border=0></a>&nbsp;
                        
                        <%if(!base.getCar_st().equals("4") && !base.getReject_car().equals("Y")){%>
                        <a href="javascript:display_c('emp')" title='�������'><img src=/acar/images/center/button_cnt_sman.gif align=absmiddle border=0></a>&nbsp;
                        <%}%>
                        
                        <%if(!base.getCar_st().equals("4")){%>
                        <a href="javascript:display_c('tint')" title='��ǰ'><img src=/acar/images/center/button_p_yp.gif align=absmiddle border=0></a>&nbsp;
                        <%}%>
                        
			            <a href="javascript:display_c('etc')" title='Ư�̻���'><img src=/acar/images/center/button_p_sp.gif align=absmiddle border=0></a>&nbsp;
			            
			            &nbsp;&nbsp;&nbsp;&nbsp;
			            
        	    	    <!-- ������ư -->
   						<a href="javascript:view_kakao_contract('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=cm_bean.getCar_comp_id()%>');" class="btn" title='�˸���'><img src=/acar/images/center/button_ntalk.gif align=absmiddle border=0></a>&nbsp;
        			    <a href="javascript:view_memo('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='��ȭ'><img src=/acar/images/center/button_th.gif align=absmiddle border=0></a>&nbsp;
        		        <a href="javascript:view_mail('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='����'><img src=/acar/images/center/button_mail.gif align=absmiddle border=0></a>&nbsp;
        	            <a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='��ĵ'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>&nbsp;
        	            
        	            <%if(!base.getCar_st().equals("4")){%> <!-- ����Ʈ�ƴϸ�  -->
        	            <!-- ��ǰ -->
        	            <%		if(!base.getReject_car().equals("Y") && base.getRent_start_dt().equals("")){%>
                	    <a href="javascript:view_est('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='��ǰ'><img src=/acar/images/center/button_np.gif align=absmiddle border=0></a>&nbsp;
                	    <%		}%>
                	    <!-- �����˽� -->
			            <%		if(from_page.equals("/fms2/lc_rent/lc_n_frame.jsp")){//��������Ȳ%>
        		        <%			if(nm_db.getWorkAuthUser("�����ڸ��",user_id) || nm_db.getWorkAuthUser("������������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������2",user_id)){%>
        		        <%				if(fee_etc.getChk_dt().equals("") || nm_db.getWorkAuthUser("������",user_id)){//��༭������%>
        			    <a href="javascript:cont_check();" class="btn" title='������ ���� �Ϸ�ó��'><img src=/acar/images/center/button_jg.gif align=absmiddle border=0></a>&nbsp;
        			    <a href="javascript:cont_check_memo();" class="btn" title='�̰��缭�� ��������'><img src=/acar/images/center/button_mjcsr.gif align=absmiddle border=0></a>&nbsp;
        			    <%				}%>
        		        <%			}%>
			            <%		}%>
			            <!-- ��ຯ���Ȯ�ν� -->
			            <%		if(from_page.equals("/fms2/lc_rent/lc_n2_frame.jsp")){//��ຯ���Ȯ����Ȳ%>
        		        <%			if(nm_db.getWorkAuthUser("������������",user_id) || nm_db.getWorkAuthUser("������",user_id)  || nm_db.getWorkAuthUser("����/�°�����",user_id)  || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) ){%>
        			    <%				if(!fee_etc.getCng_chk_id().equals("") && fee_etc.getCng_chk_dt().equals("")){//��ຯ��Ȯ��%>
        			    <a href="javascript:cont_cng_check();" class="btn" title='��ຯ�� Ȯ��ó��'><img src=/acar/images/center/button_modify_gy.gif align=absmiddle border=0></a>&nbsp;
        			    <%				}%>
        		        <%			}%>
			            <%		}%>
   			            <!-- ���� - ����,����, ���Կɼ�-->			            
			            <%		if(base.getUse_yn().equals("Y") ){%>	
			            <%			if(nm_db.getWorkAuthUser("�ѹ�����",user_id) || nm_db.getWorkAuthUser("������",user_id) ){%>		            
        		        <a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='����'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp;
        		         <%				}%>
        		        <%		}%>
			            <!-- ���� - ���뿩����(��Ʈ/����) -->
			            <%		if(base.getUse_yn().equals("Y") && (base.getCar_st().equals("1")||base.getCar_st().equals("3"))){%>			            
				        <a href="javascript:view_settle('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='����'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>&nbsp;
        		        <%		}%>
        		        <!-- �������� ����  -->
        		        <%		if(base.getUse_yn().equals("N")){%>
				               <a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='�����ϱ�'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp;
        		        <% } %>        		        
        		        <!-- ������Ȱ -->
        		        <%		if(base.getUse_yn().equals("N") && (nm_db.getWorkAuthUser("������",user_id) && base.getUse_yn().equals("N"))){%>
        		        <%			if(cls.getCls_st().equals("��ุ��") || cls.getCls_st().equals("�ߵ��ؾ�") || cls.getCls_st().equals("���Կɼ�")){%>
        			    <a href="javascript:cancel_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='������Ȱ'><img src=/acar/images/center/button_cancel_hj.gif align=absmiddle border=0></a>&nbsp;
        			    <%			}%>
        		        <%		}%>
        		        <!-- ����ȸ�� -->
			            <%		if(base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("�����������ڵ�",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("���Կɼǰ�����",user_id) || nm_db.getWorkAuthUser("���ݰ�꼭�����",user_id) || nm_db.getWorkAuthUser("����������",user_id)){%>		
			            <%			if(base.getUse_yn().equals("Y") && !fee.getRent_start_dt().equals("")){%>					  
        			    <a href="javascript:car_call_in('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='����ȸ��'><img src=/acar/images/center/button_hs.gif align=absmiddle border=0></a>&nbsp;					  
				        <%			}%>
			            <%		}%>
			            <!-- �̷� ������� -->
			            <%		if(base.getUse_yn().equals("Y") && (base.getCar_st().equals("1")||base.getCar_st().equals("3"))){%>
			            <a href="javascript:add_rent_esti_s();" class="btn" title='��������ϱ�'><img src=/acar/images/center/button_est_yj.gif align=absmiddle border=0></a>&nbsp;					  
			            <%		}%>			
			            <!-- ���������� �����ٽó��� -->
			            <%		if(base.getUse_yn().equals("Y") && base.getCar_gu().equals("1") && cont_etc.getRent_suc_dt().equals("") && fee_size==1 && !base.getCar_mng_id().equals("") && !base.getRent_start_dt().equals("")){%>
			            <%			if(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//����,���Ҵ� ����.%>
			            <%			}else{ %>
                        <!-- <input type="button" class="button" value="���������� ���� �ٽó���" onclick="javascript:EstiReReg();">&nbsp; -->
                        <input type="button" class="button" value="���������� �����Ÿ� ����" onclick="javascript:EstiReReg();">&nbsp;
                        <%			} %>
                        <%		} %>
			            <%}%>
			            
			            
                        <!-- �縮�������� - ���� �������� ���� �縮�������� Ȯ�� -->
			            <%if(base.getUse_yn().equals("Y") && !base.getCar_mng_id().equals("") && !base.getRent_start_dt().equals("")){%>			            
	                    <a href="javascript:sh_car_amt();" class="btn" title='�縮��������'><img src=/acar/images/center/button_fee_jg.gif align=absmiddle border=0></a>&nbsp;
			            <%}%>

			            <!--����Ʈ -->	
			            <%if(base.getCar_st().equals("4")){%>
			            
			            <%		if(base.getUse_yn().equals("Y")){%>
			            <!-- ���� -->
				        <a href="javascript:view_settle('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='����'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>&nbsp;
                        <!-- ����� -->
                        <a href="javascript:car_secondhand();" class="btn" title='�縮�������ϱ�'><img src=/acar/images/center/button_slease.gif align=absmiddle border=0></a>&nbsp;
                        <!-- ������� -->
                        <%			if(!cont_etc.getSpe_est_id().equals("") && base.getRent_start_dt().equals("")){%>
                        <%				if(base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�������Ʈ���",user_id)){%>
                        <a href="javascript:rent_delete();" class="btn" title='����ϱ�'><img src=/acar/images/center/button_cancel_cont.gif align=absmiddle border=0></a>&nbsp;                        
                        <%				}%>
                        <%			}%>
                        <%		}%>
                        
			            <%		if(base.getUse_yn().equals("N")){%>
        		        <a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='�����ϱ�'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp; 
        		        <%		}%>
        		        
			            <%		if(base.getUse_yn().equals("")){%>
			            <!-- Ȩ������ �� ����Ʈ ���� ���� -->
			            <%			if(!cont_etc.getSpe_est_id().equals("")){%>
			            <!-- ������ -->
			            <a href="javascript:rent_conform();" class="btn" title='�����ϱ�'><img src=/acar/images/center/button_app_cont.gif align=absmiddle border=0></a>&nbsp;
			            <!-- ������� -->
                        <a href="javascript:rent_delete();" class="btn" title='����ϱ�'><img src=/acar/images/center/button_cancel_cont.gif align=absmiddle border=0></a>&nbsp;
                        <!-- �����븮�� -->
   		                <%				if(cont_etc.getBus_agnt_id().equals("")){%>                 
    					<input type="button" class="button" value="�����븮�� ���" onclick="javascript:update('bus_agnt_id');">&nbsp;
    					<%				}%>
    					<%			} %>
   		                <%		} %>
   		                  
   		                <%		if(nm_db.getWorkAuthUser("������",user_id)){%>
   		                <a href="javascript:rent_conform();" class="btn" title='�����ϱ�'><img src=/acar/images/center/button_app_cont.gif align=absmiddle border=0></a>&nbsp;
   		                <%		}%>   		                  
                        <%} %>
                        
                        <!-- Ȯ�μ� ��� 2018.1.2-->
                        <a href="javascript:view_confirm_popup();" class="btn"><img src=/acar/images/center/button_confirm.gif align=absmiddle border=0></a>&nbsp;
                        
                        <%//		if(nm_db.getWorkAuthUser("������",user_id)){%>
                        <input type="button" class="button" value="����Ȯ�μ�" onclick="javascript:view_confirm_edoc();">&nbsp;
                        <%//		}%>
                        
                        
                        <!-- �ɻ� -->
                        <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
                        <input type="button" class="button" value="�ɻ�" onclick="javascript:view_bus_review();">&nbsp;
                        <%} %>
                        
                        <!--  �������� ���  -->
                        <input type="button" class="button" value="��������" onclick="javascript:reg_cooperation();">&nbsp;
                        
                        <%if(base.getCar_gu().equals("1") && cr_bean.getNcar_spe_dc_amt() > 0 && ck_acar_id.equals("000029")){%>
                        <input type="button" class="button" value="Ư������" onclick="javascript:spedc_car_reg();">&nbsp;
                        <%} %>
   	    </td>						
    		</tr>
    	    </table>
		</td>
    </tr>	
    <%}else{ //������%>
    <%	if(base.getCar_gu().equals("2")){%>
    <tr>
	      <td colspan="2" align="center">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
        	    <td align="center">        	    	
                    <a href="javascript:display_c('car_ac')"><img src=/acar/images/center/button_cnt_carins.gif align=absmiddle border=0></a>&nbsp;
        	    </td>
    		    </tr>
    	    </table>
	      </td>
    </tr>    
    <%	}else{%>
    <tr>
	      <td colspan="2" align="center">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
        	    <td align="center">
        	        <a href="javascript:display_c('tint')"><img src=/acar/images/center/button_p_yp.gif align=absmiddle border=0></a>&nbsp;
        	        <a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='�����ϱ�'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp;         		
		            <%if(!base.getCar_mng_id().equals("")){%>
		            <a href="javascript:sh_car_amt();" class="btn" title='�߰��������'><img src=/acar/images/center/button_fee_jg.gif align=absmiddle border=0></a>&nbsp;					  
 	                <%}%>
        	    </td>
    		    </tr>
    	    </table>
	      </td>
    </tr>
    <%	}%>
    <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
