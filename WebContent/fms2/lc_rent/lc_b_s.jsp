<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.con_ins.*, acar.ext.*, acar.im_email.*,acar.insur.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="af_db" class="acar.fee.AddFeeDatabase"	scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="ac_db" class="acar.cost.CostDatabase" scope="page"/>
<jsp:useBean id="ae_db" class="acar.ext.AddExtDatabase" scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="session"/>	
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();

	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	if(rent_l_cd.equals("") || rent_l_cd.equals("null")) return;
		
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		ins = ai_db.getInsCase(base.getCar_mng_id(), ai_db.getInsSt(base.getCar_mng_id()));//��������
	}
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	if(fee_size > 1) rent_st = Integer.toString(fee_size);
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	//�������뿩����
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	//���뺸��������
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	//���繫��ǥ
	ClientFinBean c_fin = al_db.getClientFin(base.getClient_id(), cont_etc.getFin_seq());
	
	//�ſ��� ��ȸ
	ContEvalBean eval1 = new ContEvalBean();
	ContEvalBean eval2 = new ContEvalBean();
	ContEvalBean eval3 = new ContEvalBean();
	ContEvalBean eval4 = new ContEvalBean();
	ContEvalBean eval5 = new ContEvalBean();
	ContEvalBean eval6 = new ContEvalBean();
	ContEvalBean eval7 = new ContEvalBean();
	ContEvalBean eval8 = new ContEvalBean();
	//���ຸ������	
	ContGiInsBean max_gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	//���ǿ���
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);
	
	//Ư�ǰ������
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);
	
	//�����ڸ���Ʈ
	Vector cop_res_vt = cop_db.getCarOffPreSeqResUseList(String.valueOf(cop_bean.getSeq()));
	int cop_res_vt_size = cop_res_vt.size();
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
		
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
		
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
		
	
	
	//��ĵ���� üũ����
	String scan_chk = "Y";
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&from_page="+from_page+"&now_stat="+now_stat+"&san_st="+san_st;
	String valus_t = valus;
	
	
	//����ȿ��
	Hashtable cost_cmp = ac_db.getSaleCostCampaignCase("1", rent_mng_id, rent_l_cd, rent_st);
	//��������� ����ȿ��
	Hashtable t_cost_cmp = ac_db.getSaleCostCampaignCase("9", rent_mng_id, rent_l_cd, "t");
	//����Ʈ ����ȿ��
	Hashtable rm_cost_cmp = ac_db.getSaleCostCampaignCase("14", rent_mng_id, rent_l_cd, "1");	
	
	
	int alink_count1 = ln_db.getALinkCnt("lc_rent_link",   rent_l_cd)+ln_db.getALinkCnt("lc_rent_link_m",   rent_l_cd);
	//������ڰ�༭
	Hashtable alink_lc_rent = ln_db.getAlinkEndLcRent(rent_l_cd, rent_st);		
	
	Hashtable hp_2d = new Hashtable();
	String max_over_yn = "";
	String max_use_mon = "0";
	//�縮�� �ű԰��
	if(base.getUse_yn().equals("") && base.getCar_gu().equals("0") && !base.getCar_mng_id().equals("") && cont_etc.getRent_suc_dt().equals("") && fee_size==1){
		//�ֱ� Ȩ������ ����뿩�� ��������Ÿ� 20000
		hp_2d = oh_db.getSecondhandCaseDist("", "", base.getCar_mng_id(), "20000");
		max_use_mon = hp_2d.get("MAX_USE_MON")+"";
		if(AddUtil.parseInt(fee.getCon_mon()) > AddUtil.parseInt((String)hp_2d.get("MAX_USE_MON")) ){
			max_over_yn = "Y";
		}
	}
	
	//������ó ����
	int client_tel_cnt = 0;
	String client_tel_1 = "";
	String client_tel_2 = "";
	String client_tel_3 = "";
	String client_tel_4 = "";
	//�繫����ȭ Ȯ�� client_tel_cnt = 0
	if(!client.getO_tel().equals("") && client.getO_tel().length() > 6){
	 client_tel_cnt++;
	 client_tel_1 = AddUtil.replace(client.getO_tel(),"-","");
	}
	//�޴�����ȣ Ȯ�� client_tel_cnt = 0 or 1
	if(!client.getM_tel().equals("") && client.getM_tel().length() > 9){
		if(client_tel_cnt == 0){
			client_tel_cnt++;
			client_tel_1 = AddUtil.replace(client.getM_tel(),"-","");
		}else{
			if(!client_tel_1.equals(AddUtil.replace(client.getM_tel(),"-",""))){
				client_tel_cnt++;
				client_tel_2 = AddUtil.replace(client.getM_tel(),"-","");
			}
		}
	}
	//���ù�ȣ Ȯ�� client_tel_cnt = 0 or 1 or 2
	if(!client.getClient_st().equals("1")){
		if(!client.getH_tel().equals("") && client.getH_tel().length() > 6){
			if(client_tel_cnt == 0){
				client_tel_cnt++;
				client_tel_1 = AddUtil.replace(client.getH_tel(),"-","");
			}else if(client_tel_cnt == 1){
				if(!client_tel_1.equals(AddUtil.replace(client.getH_tel(),"-",""))){
					client_tel_cnt++;
					client_tel_2 = AddUtil.replace(client.getH_tel(),"-","");
				}
			}else{
				if(!client_tel_1.equals(AddUtil.replace(client.getH_tel(),"-",""))){
					client_tel_cnt++;
					client_tel_2 = AddUtil.replace(client.getH_tel(),"-","");
				}			
				if(!client_tel_3.equals(AddUtil.replace(client.getH_tel(),"-",""))){
					client_tel_cnt++;
					client_tel_3 = AddUtil.replace(client.getH_tel(),"-","");
				}
			}
		}
	}
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
	
	function replaceFloatRound(per){return Math.round(per*1000)/10;}
	function replaceFloatRound2(per){return Math.round(per*10)/10;}
	//����Ʈ
	function list(){
		var fm = document.form1;
		if(fm.from_page.value==''){fm.action='lc_b_frame.jsp';}
		else{fm.action=fm.from_page.value;}
		fm.target='d_content';
		fm.submit();
	}
	//�� ����
	function view_client(){if('<%=base.getClient_id()%>'==''){alert("���õ� ���� �����ϴ�.");return;}window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id=<%=base.getClient_id()%>","CLIENT","left=10,top=10,width=1010,height=750,scrollbars=yes,status=yes,resizable=yes");}
	//����/���� ����
	function view_site(){if('<%=base.getR_site()%>'==''){alert("���õ� ������ �����ϴ�.");return;}window.open("/fms2/client/client_site_i_p.jsp?cmd=view&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id=<%=base.getClient_id()%>&site_id=<%=base.getR_site()%>","CLIENT_SITE","left=10,top=10,width=1010,height=500");}
	//�ڵ���������� ����
	function view_car(){window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=1010, height=750, scrollbars=yes");}		
	//�������� ����
	function view_car_nm(car_id, car_seq){window.open("/acar/car_mst/car_mst_u.jsp?from_page=lc_rent&car_id="+car_id+"&car_seq="+car_seq, "VIEW_CAR_NM", "left=10, top=10, width=1010, height=750, scrollbars=yes");}
	//�ش� ���� �������� �⺻��� ����
	function open_car_b(car_id, car_seq, car_name){window.open('view_car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=10, top=10, width=1010, height=600, scrollbars=yes");}
	//��������
	function reset_car(){window.open('reset_car.jsp<%=valus%>&from_page2=/fms2/lc_rent/lc_b_s.jsp', "reset_car", "left=10, top=10, width=1200, height=600, scrollbars=yes");}
	//�����ϱ�
	function sanction(){
		var fm = document.form1;
		<%if(!ck_acar_id.equals("000029")){%>
		if(toInt(fm.chk_cnt.value) > 0){ alert('�Է°� üũ ��� Ȯ���� �ʿ��� �׸��� '+toInt(fm.chk_cnt.value)+'�� �߻��߽��ϴ�.'); return; }
		<%}%>
		fm.idx.value = 'sanction';
		fm.action='lc_b_u_a.jsp';
		fm.target='i_no';
		fm.submit();
	}
	//�����û�ϱ�
	function sanction_req(){
		var fm = document.form1;
		if(toInt(fm.chk_cnt.value) > 0){ alert('�Է°� üũ ��� Ȯ���� �ʿ��� �׸��� '+toInt(fm.chk_cnt.value)+'�� �߻��߽��ϴ�.'); return; }
		//������ ��� ������ ����ȿ�� ���� ������ ���� Ȯ��
		if(<%=fee_etc.getRent_st()%> > 1){//����
			if(toInt(<%=fee_etc.getBc_s_a()%>) == 0){ alert('������ ����ȿ���� �����Ͽ� �������� �����ϰ� ������ �� �����û�Ͻʽÿ�.'); return; }
		}

		fm.idx.value = 'sanction_req';
		if(confirm('�����û�Ͻðڽ��ϱ�?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//������ ��û�ϱ�
	function sanction_req_delete(){
		var fm = document.form1;
		if(fm.sanction_req_delete_cont.value == ''){ alert('������ ��û������ �Է��Ͻʽÿ�.'); return; }
		fm.idx.value = 'sanction_req_delete';
		fm.action='lc_b_u_a.jsp';
		fm.target='i_no';
		fm.submit();
	}	
	//�����û ����ϱ�
	function sanction_req_cancel(){
		var fm = document.form1;
		fm.idx.value = 'sanction_req_cancel';
		fm.action='lc_b_u_a.jsp';
		fm.target='i_no';
		fm.submit();
	}
	//���� ����ϱ�
	function sanction_cancel(){
		var fm = document.form1;
		fm.idx.value = 'sanction_cancel';
		if(confirm('���� ����Ͻðڽ��ϱ�?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	//�ŷ�ġ ������ĵ ����ȭ
	function scan_sys(){
		var fm = document.form1;
		fm.idx.value = 'scan_sys';
		if(confirm('��ĵ���� ����ȭ�Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	//������ �������ϱ�
	function rent_delete(){
		var fm = document.form1;
		fm.idx.value = 'delete';
		if(confirm('�����Ͻðڽ��ϱ�?')){ if(confirm('������ ��� ����Ÿ�� �����ϰ� �˴ϴ�. \n\n�����Ͻðڽ��ϱ�?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='d_content';
			fm.submit();
		}}
	}
	//������ �������ϱ�
	function rent_stat_delete(){
		var fm = document.form1;
		fm.idx.value = 'step1_delete';
		if(confirm('�̻��ó�� �Ͻðڽ��ϱ�?')){ 
			fm.action='lc_b_u_a.jsp';
			fm.target='d_content';
			fm.submit();
		}
	}
	//������ ����������ϱ�
	function rent_delete_ext(){
		var fm = document.form1;
		fm.idx.value = 'delete_ext';
		if(confirm('�����Ͻðڽ��ϱ�?')){ if(confirm('��������� ����Ÿ�� �����ϰ� �˴ϴ�. \n\n�����Ͻðڽ��ϱ�?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='d_content';
			fm.submit();
		}}
	}	
	//������ ����������
	function rent_delete_recar(){
		var fm = document.form1;
		fm.idx.value = 'delete_recar_reg';
		if(confirm('�����������Ͻðڽ��ϱ�?')){ if(confirm('���� �����������Ͻðڽ��ϱ�?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='d_content';
			fm.submit();
		}}
	}
	//��ĵ���� ����
	function view_scan(){
		window.open("scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
	//��ĵ���
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st, "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}	
	//��ĵ���-�ϰ�
	function scan_all_reg(){
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];
			if(ck.name == "ch_l_cd"){
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}
		if(cnt == 0){ alert("�ϰ� ����� ��ĵ�׸��� �����ϼ���."); return; }
		window.open('about:blank', "SCAN_ALL", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");
		fm.target = "SCAN_ALL";
		fm.action = "reg_scan_all.jsp";
		fm.submit();
	}	
	//��ü����
	function AllSelect(){
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}	
	//��������
	function view_sale_cost_lw(){
		window.open("/fms2/mis/view_sale_cost_cont_lw.jsp<%=valus%>", "VIEW_SALE_COST_LW", "left=0, top=0, width=850, height=<%=s_height%>, scrollbars=yes");
	}
	//��������
	function view_sale_cost_lw_base(){
		window.open("/fms2/mis/view_sale_cost_cont_lw_base.jsp<%=valus%>", "VIEW_SALE_COST_LW_BASE", "left=0, top=0, width=850, height=<%=s_height%>, scrollbars=yes");
	}
	//��������
	function view_sale_cost_lw_add(){
		window.open("/fms2/mis/view_sale_cost_cont_lw_add.jsp?rent_mng_id=<%=base.getRent_mng_id()%>&rent_l_cd=<%=base.getRent_l_cd()%>&add_rent_st=t", "VIEW_SALE_COST_LW_ADD", "left=0, top=0, width=850, height=<%=s_height%>, scrollbars=yes");
	}
	//�������� ����
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=base.getCar_mng_id()%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
	function estimates_view(rent_st, reg_code){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?car_gu=<%=base.getCar_gu()%>&rent_st="+rent_st+"&est_code="+reg_code+"&esti_table=estimate";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}
	//�������
	function add_rent_esti_s(){
		window.open("search_car_esti_s.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_ESTI_S", "left=0, top=0, width=1128, height=950, status=yes, scrollbars=yes");	
	}
	//���ϼ����ϱ�
	function go_mail(content_st, rent_st){			
		var SUBWIN="mail_input.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&content_st="+content_st;	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=500, scrollbars=no, status=yes");
	}
	//�����̷°����׸� ����
	function item_cng_update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id' || st == 'bus_st' || st == 'est_area'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=10, top=10, width=1028, height=650, status=yes, scrollbars=yes");
		}
	}
	//�߰�����
	function sh_car_amt(){
		window.open("search_sh_car_amt.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_AMT_S", "left=0, top=0, width=1028, height=550, status=yes, scrollbars=yes");	
	}
	//�ߵ�����
	function view_cls(m_id, l_cd){
		window.open("/acar/cls_con/cls_i_tax.jsp?m_id="+m_id+"&l_cd="+l_cd, "CLS_I", "left=50, top=50, width=840, height=650, status=yes, scrollbars=yes");
	}	
	//�ߵ���������  ����
	function view_settle(m_id, l_cd){
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
	}

	//���°賻�뺸��
	function update_suc_commi(){
		window.open("/fms2/lc_rent/lc_b_u_suc_commi.jsp<%=valus%>", "UPDATE_SUC_COMMI", "left=0, top=0, width=1280, height=520, scrollbars=yes, status=yes, resizable=yes");
	}
	//���� �Һ��ڰ� �հ�
	function sum_car_c_amt(){
		var fm = document.form1;
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );
	}
	//���� ���԰� �հ�
	function sum_car_f_amt(){
		var fm = document.form1;
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );
	}
	//�����̰���ϱ�
	function age_search(){
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');
		fm.action = "/fms2/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();
	}	
	//����
	function update(st, rent_st){
		var fm = document.form1;	
		if(rent_st!=''){
			fm.fee_rent_st.value = rent_st;
		}
		var v_heigth = 250;
		if(st == '1' || st == '2' || st == '8' || st == '8_1' || st == '13' || st == '15'){
			v_heigth = 650;
		}else if(st == '3' || st == '7' || st == '14'){
			v_heigth = 350;
		}else if(st == '4' || st == '9' || st == '10'){
			v_heigth = 550;
		}else if(st == '12'){
			v_heigth = 750;
		}
		window.open("about:blank",'update_s','scrollbars=yes,status=yes,resizable=yes,width=1280,height='+v_heigth+',left=0,top=0');
		fm.action = "/fms2/lc_rent/lc_b_s_"+st+".jsp";
		fm.target = "update_s";
		fm.submit();
	}		
	//���ڹ��� �����ϱ�
	function go_edoc(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;
		fm.link_im_seq.value 	= link_im_seq;
		window.open('about:blank', "EDOC_LINK", "left=0, top=0, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK";
		fm.action = "reg_edoc_link.jsp";
		fm.submit();
	}
	
	//�׽�Ʈ - ���ڹ��� �����ϱ�2
	function go_edoc2(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;
		fm.link_im_seq.value 	= link_im_seq;
		window.open('about:blank', "EDOC_LINK2", "left=0, top=0, width=900, height=800, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK2";
		fm.action = "reg_edoc_link2.jsp";
		fm.submit();
	}
	
	// bh.sim �ӽ� �׽�Ʈ�� start del
	function sanction_req_temp(){
		var fm = document.form1;
		//������ ��� ������ ����ȿ�� ���� ������ ���� Ȯ��
		if(<%=fee_etc.getRent_st()%> > 1){//����
			if(toInt(<%=fee_etc.getBc_s_a()%>) == 0){ alert('������ ����ȿ���� �����Ͽ� �������� �����ϰ� ������ �� �����û�Ͻʽÿ�.'); return; }
		}
		
		fm.idx.value = 'sanction_req';
		if(confirm('�����û�Ͻðڽ��ϱ�?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	// bh.sim �ӽ� �׽�Ʈ�� end
	
	//���ڹ߼�
	function SendMsg(msg_st){
		var fm = document.form1;
		fm.msg_st.value = msg_st;
		window.open('about:blank', "LC_SEND_MSG", "left=0, top=0, width=900, height=400, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "LC_SEND_MSG";
		if(msg_st=='con_amt_pay_req'){
			fm.action = "/fms2/lc_rent/lc_send_msg.jsp";
		}else{
			fm.action = "/fms2/car_pur/reg_trfamt5.jsp";
		}
		fm.submit();
	}
	
	//Ư���û�� ����
	function reqdoc(rent_l_cd, rent_mng_id, rent_st){
		var url = 'lc_b_s_reqdoc.jsp?rent_l_cd='+rent_l_cd+'&rent_mng_id='+rent_mng_id+'&rent_st='+rent_st;
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
	}
	
	//������ ���� �� ��������ǥ�� ��
	function span_dc_view(){
		var fm = document.form1;
		if(fm.dc_view_yn.checked==true){	$("#span_dc_view").css("display","");				}
		else{												$("#span_dc_view").css("display","none");		}
	}
	
	function P_cont_copy(){
		var fm = document.form1;
		window.open('about:blank', "ContCopy", "left=0, top=0, width=600, height=400, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "ContCopy";
		fm.action = "reg_cont_copy.jsp";
		fm.submit();		
	}
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
	}
	
	//���ϰŷ�ó �����ŷ� ����
	function view_lc_rent(){
		var height = 400;
		window.open("view_rent_list.jsp?client_id=<%=base.getClient_id()%>", "VIEW_LC_RENT", "left=0, top=0, width=1150, height="+height+", scrollbars=yes");		
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
<form action='' name="form1" method='post'>
  <input type='hidden' name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name="user_id" value="<%=user_id%>">
  <input type='hidden' name="br_id"   value="<%=br_id%>">
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"			value="<%=rent_st%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="scan_cnt"			value="">
  <input type='hidden' name="chk_cnt"			value="">
  <input type='hidden' name="fee_rent_st"	value="<%=rent_st%>">
  <input type='hidden' name="link_table"		value="">  
  <input type='hidden' name="link_type"			value="">  
  <input type='hidden' name="link_rent_st"		value="">  
  <input type='hidden' name="link_im_seq"		value="">    
  <input type='hidden' name="idx"		value="">    
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">
  <input type='hidden' name="firm_nm" 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="msg_st"		value="">
     
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�̰���</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <%if(AddUtil.getDate(4).equals(base.getReg_dt()) && fee_size == 1 && base.getCar_gu().equals("1") && cont_etc.getRent_suc_dt().equals("")){ //������� ���ϰ��� %>
    <%//if(user_id.equals("000029") && base.getCar_gu().equals("1")){ //������� ���ϰ��� %>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td align='right'><input type="button" class="button" value="������� ���ϰ�,��������&Ʈ��,��������,���ϰ������ �϶� ��� ���ߵ�� ó��" onclick="javascript:P_cont_copy();"></td>
    </tr>    
    <%} %>
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>		
          <tr> 
            <td class=title width=13%>ǰ�Ǳ���</td>
            <td width=20%>&nbsp;
              <%if(now_stat.equals("����")){%>������
              <%}else if(now_stat.equals("���°�")){%>���°���
              <%}else if(now_stat.equals("��������")){%>����������
              <%}else{%>
                <%if(base.getCar_gu().equals("1")){%>�������
                <%}else if(base.getCar_gu().equals("0")){%>�縮�����
                <%}else if(base.getCar_gu().equals("3")){%>����Ʈ���
                <%}%>
                <%if(base.getReject_car().equals("Y")){%>&nbsp;(�μ��ź�����)<%}%>
              <%}%>                              
            </td>
            <td>&nbsp;
              <%if(String.valueOf(alink_lc_rent.get("RENT_L_CD")).equals(rent_l_cd)){%>[���ڰ�༭]<%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
	    <td>(����� : <%=AddUtil.ChangeDate2(base.getReg_dt())%>)</td>
	</tr>	
    <!--������-->
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%>&nbsp;(<%=rent_mng_id%>)</td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>��౸��</td>
                    <td>&nbsp;<%String cont_rent_st = base.getRent_st();%><%if(cont_rent_st.equals("1")){%>�ű�<%}else if(cont_rent_st.equals("3")){%>����<%}else if(cont_rent_st.equals("4")){%>����<%}%>
                    	<%if(base.getRent_st().equals("4")||base.getRent_st().equals("3")){%>
                        &nbsp;
                        <a href="javascript:view_lc_rent()" title="�̷�"><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a>
                        <%}%>
                    </td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ�<%}else if(bus_st.equals("2")){%>�������<%}else if(bus_st.equals("3")){%>��ü�Ұ�<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>��ȭ���<%}else if(bus_st.equals("6")){%>������ü<%}else if(bus_st.equals("7")){%>������Ʈ<%}else if(bus_st.equals("8")){%>�����<%}%></td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String rent_way = max_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}else if(rent_way.equals("2")){%>�����<%}%></td>
                </tr>
                <tr> 
                    <td class=title>���ʿ�����</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(), "USER")%></td>
                    <td class=title>�����븮��</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(), "USER")%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getMng_id2(), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(), "USER")%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getMng_id(), "USER")%></td>
                    <td class=title>�����ε���</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%></td>
                </tr>
                <tr>
                    <td class=title>�����������</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getAgent_emp_id(), "CAR_OFF_EMP")%>(������Ʈ���)</td>
                    <td class=title>�����̿�����</td>
                    <td colspan='3'>&nbsp;<%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
                    	<input type='hidden' name="est_area" value="<%=cont_etc.getEst_area()%>">
                    	<input type='hidden' name='county' value='<%=cont_etc.getCounty()%>'>
                    	</td>
                </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td align="right"><%if(!san_st.equals("��û") || auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('0','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <!--���°�-->
    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>    
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���°�</span>
        &nbsp;<%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_suc_commi()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <%}%>
    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�") || String.valueOf(begin.get("CLS_ST")).equals("��������")){%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ �����</span></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr> 
                    <td class=title width=13%>���汸��</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_ST")%> <%=begin.get("RENT_L_CD")%></td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_DT")%></td>
                    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>
                    <td class=title width=10%>��</td>
                    <td>&nbsp;<%=begin.get("FIRM_NM")%>&nbsp;<%=begin.get("CLIENT_NM")%></td>
                    <%}else if(String.valueOf(begin.get("CLS_ST")).equals("��������")){%>
                    <td class=title width=10%>�ڵ���</td>
                    <td>&nbsp;<%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%></td>
                    <%}%>
                </tr>
                <tr>
                  <td class=title>��������</td>
                  <td colspan="5">&nbsp;<%=begin.get("CLS_CAU")%></td>
                </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <%}%>
        
    <%if(!base.getCar_st().equals("2")){%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��</span>(<%=client.getClient_id()%>)</td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��ȣ/����</td>
                    <td <%if(client.getClient_st().equals("2")){%>colspan='3'<%}%>>&nbsp;<%=client.getFirm_nm()%>
                    	(
                    	<%if(client.getClient_st().equals("2")){%>
                    	  <%=client.getSsn1()%>-<%=client.getSsn2().substring(0,1)%>
                    	<%}else{%>
                    	  <%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>
                    	<%}%>
                    	)
                      <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
                    </td>
                    <%if(!client.getClient_st().equals("2")){%>
                    <td width='10%' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp;<%=client.getClient_nm()%></td>
                    <%}%>
                </tr>
                <tr>
                    <td class='title'>����ó</td>
                    <td colspan='3'>&nbsp;
                    	<%if(!client.getClient_st().equals("2")){%>
                    	ȸ����ȭ : <%=AddUtil.phoneFormat(client.getO_tel())%>, ��ǥ���ڵ��� : <%=AddUtil.phoneFormat(client.getM_tel())%><%if(!client.getClient_st().equals("1")){%>, ������ȭ : <%=AddUtil.phoneFormat(client.getH_tel())%><%}%>
                    	<%}else{%>
                    	���޴��� : <%=AddUtil.phoneFormat(client.getM_tel())%>, ������ȭ : <%=AddUtil.phoneFormat(client.getH_tel())%>, ������ȭ : <%=AddUtil.phoneFormat(client.getO_tel())%>
                    	<%}%>
                    </td>
                </tr>                
                <tr>
                    <td class='title'>����/����</td>
                    <td width='50%' height="26" class='left'>&nbsp;<%=site.getR_site()%>
                    	<%if(!site.getR_site().equals("")){%>
                    	  <%if(site.getSite_st().equals("1")){//����%>
                    	    <%if(site.getEnp_no().length()==10){%>
                    	      (<%=AddUtil.ChangeEnt_no(site.getEnp_no())%>)
                    	    <%}else if(site.getEnp_no().length()==13){%>
                    	      (<%=site.getEnp_no().substring(0,6)%>-<%=site.getEnp_no().substring(7,1)%>)
                    	    <%}%>
                    	  <%}%>
                      <span class="b"><a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
                    	<%}%>
                    </td>
                    <td width='10%' class='title'>���������</td>
                    <td align='left'>&nbsp;<%=client.getOpen_year()%></td>
                </tr>
                <tr>
                    <td class='title'>�����ּ�</td>
                    <td colspan=>&nbsp;<%=base.getP_zip()%>&nbsp;<%=base.getP_addr()%></td>
                    <td class='title'>����������</td>
                    <td class='left'>&nbsp;<%=base.getTax_agnt()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <%		CarMgrBean mgr1 = new CarMgrBean();
                		CarMgrBean mgr5 = new CarMgrBean();
                		for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        					if(mgr.getMgr_st().equals("�����̿���")){
        						mgr1 = mgr;
        						if(!client.getClient_st().equals("2") && !mgr1.getMgr_m_tel().equals("") && mgr1.getMgr_m_tel().length() > 9){
	                        		//�����̿��� ��ȣ client_tel_cnt = 0 or 1 or 2 or 3 : �ִ� 2�� ������ üũ�ϸ� �ȴ�.
                   			  		if(client_tel_cnt == 0){
                  				  		client_tel_cnt++;
				                    	client_tel_1 = AddUtil.replace(mgr1.getMgr_m_tel(),"-","");
			                    	}else if(client_tel_cnt == 1){
				                    	if(!client_tel_1.equals(AddUtil.replace(mgr1.getMgr_m_tel(),"-",""))){
					                    	client_tel_cnt++;
					                    	client_tel_2 = AddUtil.replace(mgr1.getMgr_m_tel(),"-","");
				                    	}
		                      		}
		                    	}
        					}
        					if(mgr.getMgr_st().equals("�߰�������")){
                				mgr5 = mgr;
                			}
						}                       
                %>
                
                <%if(!client.getClient_st().equals("1")){ %>
                <tr>
                    <td class='title'>����� ���������ȣ</td>
		            <td colspan='3'>&nbsp;<%=base.getLic_no()%></td>
		            <td>&nbsp;(����,���λ����)&nbsp;�� �����(<%=client.getClient_nm()%>)�� ���������ȣ�� ����</td>
                </tr>
                <tr>
                    <td class='title' width='13%'>�����̿��� ���������ȣ</td>
		            <td width='15%'>&nbsp;<%=base.getMgr_lic_no()%></td>
		            <td width='20%'>&nbsp;�̸� : <%=base.getMgr_lic_emp()%></td>
		            <td width='12%'>&nbsp;���� : <%=base.getMgr_lic_rel()%></td>
		            <td width='40%'>&nbsp;(����,���λ����)<%if(client.getClient_st().equals("3")||client.getClient_st().equals("4")||client.getClient_st().equals("5")){%>&nbsp;�� ����ڰ� �������㰡 ���� ��� �����̿����� �������㸦 �Է�<%}%></td>
                </tr>
                <%} %>
                  
                <%//if(mgr5.getMgr_st().equals("�߰�������")){ %>
                <tr>
                    <td class='title'>�߰������� ���������ȣ</td>
		            <td>&nbsp;<%=mgr5.getLic_no()%></td>
		            <td>&nbsp;�̸� : <%=mgr5.getMgr_nm()%></td>
		            <td>&nbsp;���� : <%=mgr5.getEtc()%></td>
		            <td>&nbsp;</td>
                </tr>    
                <%//} %>
                
                <!-- �����ڰݰ������ -->                    
                <tr>
                    <td class='title' rowspan='2' width='13%'>�������� �����ڰݰ���</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;���������(�̸�) : <%=base.getTest_lic_emp()%></td>
		            <td width='12%'>&nbsp;���� : <%=base.getTest_lic_rel()%></td>
		            <td width='40%'>&nbsp;������� : <%=c_db.getNameByIdCode("0050", "", base.getTest_lic_result())%></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;�� ���ΰ��� ����� ������, ���λ����/���λ���� ���� ��༭�� �����̿����� �����ڰ��� ����</td>
                </tr>  
                
                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="3%" rowspan="<%=mgr_size+2%>" class=title>��<br>��<br>��</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="8%">�ٹ�ó</td>			
                    <td class=title width="8%">�μ�</td>
                    <td class=title width="8%">����</td>
                    <td class=title width="8%">����</td>
                    <td class=title width="10%">��ȭ��ȣ</td>
                    <td class=title width="10%">�޴���</td>
                    <td width="30%" class=title>E-MAIL</td>
                </tr>
    		  			<%
    		  				for(int i = 0 ; i < mgr_size ; i++){
    								CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
    						%>
                <tr>
                    <td align='center'><%=mgr.getMgr_st()%></td>
                    <td align='center'><%=mgr.getCom_nm()%></td>
                    <td align='center'><%=mgr.getMgr_dept()%></td>
                    <td align='center'><%=mgr.getMgr_nm()%></td>
                    <td align='center'><%=mgr.getMgr_title()%></td>
                    <td align='center'><%=mgr.getMgr_tel()%></td>
                    <td align='center'><%=mgr.getMgr_m_tel()%></td>
                    <td align='center'><%=mgr.getMgr_email()%></td>
                </tr>
    		  			<%}%>
                <tr>
                    <td colspan="2" class=title>�����̿��� �ǰ����� �ּ�</td>
					          <td colspan=8>&nbsp;<%=mgr1.getMgr_zip()%>&nbsp;<%=mgr1.getMgr_addr()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!base.getCar_st().equals("2") && (!san_st.equals("��û") || auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))) {%><a href="javascript:update('1','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
    <tr>
        <td class=h></td>
    </tr>
<%--     <%if(client.getClient_st().equals("1")){%> --%>
	  <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>������������</td>
                    <td colspan="4" align='left'>&nbsp;<%if(cont_etc.getClient_share_st().equals("1")){%>�ִ�<%}else{%>����<%}%></td>
                </tr>
                <!-- �����ڰݰ������ -->
                <%if(client.getClient_st().equals("2") && cont_etc.getClient_share_st().equals("1")){ %>    
                <tr>
                    <td class='title' rowspan='2'>�������� �����ڰݰ���</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;���������(�̸�) : <%=base.getTest_lic_emp2()%></td>
		            <td width='12%'>&nbsp;���� : <%=base.getTest_lic_rel2()%></td>
		            <td width='40%'>&nbsp;������� : <%=c_db.getNameByIdCode("0050", "", base.getTest_lic_result2())%></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;(����)&nbsp;�� ���ΰ��� ������������ �ִ� ��� �����ڰ��� ����</td>
                </tr>  
                <%} %>
            </table>  
        </td>
    </tr>
	  <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ���뺸��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;<%if(cont_etc.getClient_guar_st().equals("1")){%>�Ժ�<%}else if(cont_etc.getClient_guar_st().equals("2")){%>����<%}%></td>
                </tr>
                <%if(cont_etc.getClient_guar_st().equals("2")){%>
                <tr>
                    <td class='title'>��������</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <%if(cont_etc.getGuar_con().equals("1")){%>�ſ�����<%}%>
                      <%if(cont_etc.getGuar_con().equals("2")){%>���������δ�ü<%}%>
                      <%if(cont_etc.getGuar_con().equals("3")){%>�����������δ�ü<%}%>
                      <%if(cont_etc.getGuar_con().equals("4")){%>��Ÿ ����ȹ��<%}%>
                      <%if(cont_etc.getGuar_con().equals("5")){%>�����濵��<%}%>
                      <%if(cont_etc.getGuar_con().equals("6")){%>��ǥ��������<%}%>
                    </td>
                    <td width="10%" class='title'>������</td>
                    <td class='left'>&nbsp;<%=c_db.getNameById(cont_etc.getGuar_sac_id(),"USER")%></td>
                </tr>
                <%}%>
            </table>  
        </td>
    </tr>
<%--     <%}%> --%>
    
    <%if(!base.getCar_st().equals("5")){%>    
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뺸���� <%if(client.getClient_st().equals("1")){%>(��ǥ ��)<%}%></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;<%if(cont_etc.getGuar_st().equals("1")){%>����<%}else if(cont_etc.getGuar_st().equals("2")){%>����<%}%></td>
                </tr>
                <%if(cont_etc.getGuar_st().equals("1")){%>
                <tr>
                    <td height="26" colspan="4" class=line>
        			          <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width="13%" class=title>����</td>
                                <td width="15%" class=title>����</td>
                                <td width="15%" class='title'>�������</td>
                                <td width="28%" class='title'>�ּ�</td>
                                <td width="13%" class='title'>����ó</td>
                                <td width="16%" class='title'>����</td>
                            </tr>
                            <%for(int i = 0 ; i < gur_size ; i++){
        					              Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
                            <tr>
                                <td class=title>���뺸����</td>
                                <td align="center"><%=gur.get("GUR_NM")%></td>
                                <td align="center"><%=AddUtil.ChangeEnpH(String.valueOf(gur.get("GUR_SSN")))%></td>
                                <td align="center"><%=gur.get("GUR_ZIP")%>&nbsp;<%=gur.get("GUR_ADDR")%></td>
                                <td align="center"><%=gur.get("GUR_TEL")%></td>
                                <td align="center"><%=gur.get("GUR_REL")%></td>
                            </tr>
                            <%}%>
                        </table>
        			      </td>			
                </tr>
                <%}%>
            </table>  
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('2', '')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>
	<%if(client.getClient_st().equals("2")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ҵ�����</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>����</td>
                    <td width=20%>&nbsp;<%=client.getJob()%></td>
                    <td class=title width=10%>�ҵ汸��</td>
                    <td colspan="3">&nbsp;
                    	<%if(client.getPay_st().equals("1")) out.println("�޿��ҵ�");%>
                      <%if(client.getPay_st().equals("2")) out.println("����ҵ�");%>
                      <%if(client.getPay_st().equals("3")) out.println("��Ÿ����ҵ�");%>
                    </td>
                </tr>
                <tr>
                    <td class='title'>�����</td>
                    <td>&nbsp;<%=client.getCom_nm()%></td>
                    <td class=title width=10%>�ټӿ���</td>
                    <td width=20%>&nbsp;<%=client.getWk_year()%>��</td>
                    <td class=title width=10%>���ҵ�</td>
                    <td>&nbsp;<%=client.getPay_type()%>����</td>
                </tr>
            </table>
        </td>
    </tr>
	<%}else{%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��� �繫��ǥ</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		        <tr>
		       
		            <td colspan="2" rowspan="2" class=title>����<br>yyyy-mm-dd</td>
		            <td width="42%" class=title>���(<%=c_fin.getC_kisu()%>��)</td>
		            <td width="43%" class=title>����(<%=c_fin.getF_kisu()%>��)</td>
		        </tr>
		        <tr>
		            <td class='title'>(<%=c_fin.getC_ba_year_s()%>~<%=c_fin.getC_ba_year()%>)</td>
		            <td class='title'>(<%=c_fin.getF_ba_year_s()%>~<%=c_fin.getF_ba_year()%>)</td>
		              
		        </tr>
		        <tr>
		            <td colspan="2" class=title>�ڻ��Ѱ�</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_asset_tot' size='10' maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_asset_tot' size='10' maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸�� </td>
		        </tr>
		        <tr>
		            <td width="3%" rowspan="2" class=title>��<br>
		            ��</td>
		            <td width="9%" class=title>�ں���</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸�� </td>
		        </tr>
		        <tr>
		            <td class=title>�ں��Ѱ�</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap_tot' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸��</td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap_tot' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸��</td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>����</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_sale' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_sale' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸�� </td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>��������</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_profit' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_profit' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            �鸸�� </td>
		        </tr>
		    </table>	     
        </td>
    </tr>
	<%}%>
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('3', '')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ſ���</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>����</td>
                    <td width="16%" class=title>��ȣ/����</td>
                    <td width="12%" class=title>�������</td>
                    <td width="13%" class='title'>�ſ�����</td>
                    <td width="16%" class='title'>�ſ���</td>
                    <td width="16%" class='title'>��(����)����</td>
                    <td width="16%" class='title'>��ȸ����</td>
                </tr>
        		    <%
        		    	//����
        		  		if(client.getClient_st().equals("2")){
        		  			eval3 = a_db.getContEval(rent_mng_id, rent_l_cd, "3", "");
        		    %>
                <tr>
                    <td class=title>�����</td>
                    <td align="center"><%=eval3.getEval_nm()%></td>
                    <td align="center" >
                      <%if(eval3.getEval_off().equals("1")) out.println("ũ��ž");%>
                      <%if(eval3.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval3.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval3.getEval_score()%></td>
                    <td align="center">
                      <%if(eval3.getEval_gr().equals("����")) out.println("����");%>
                      <%if(eval3.getEval_gr().equals("����")) out.println("����");%>
                      <%if(!eval3.getEval_gr().equals("����") && !eval3.getEval_gr().equals("����")){
	                      	if(eval3.getEval_off().equals("3")){
	                      		String scope = "";
	                      		switch(eval3.getEval_gr()){
		                      		case "1": scope = "(955~1000)"; break;
		        					case "2": scope = "(907~954)"; break;
		        					case "3": scope = "(837~906)"; break;
		        					case "4": scope = "(770~836)"; break;
		        					case "5": scope = "(693~769)"; break;
		        					case "6": scope = "(620~692)"; break;
		        					case "7": scope = "(535~619)"; break;
		        					case "8": scope = "(475~534)"; break;
		        					case "9": scope = "(390~474)"; break;
		        					case "10": scope = "(1~389)"; break;
	                      		}
	                      %>
                      		<%=c_db.getNameByIdCode("0013","",eval3.getEval_gr())%><%=scope%>
	                      <%
	                      	} else{
	                      %>
	                      	<%=c_db.getNameByIdCode("0013","",eval3.getEval_gr())%>
	                      <%}
	                      }%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval3.getEval_s_dt())%></td>
                </tr>
        		    <%
        		  			eval5 = a_db.getContEval(rent_mng_id, rent_l_cd, "5", "");
        		    %>
                <tr>
                    <td class=title>�����</td>
                    <td align="center"><%=eval5.getEval_nm()%></td>
                    <td align="center" >
                      <%if(eval5.getEval_off().equals("1")) out.println("ũ��ž");%>
                      <%if(eval5.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval5.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval5.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval5.getEval_gr().equals("����")) out.println("����");%>
                      <%if(eval5.getEval_gr().equals("����")) out.println("����");%>
                      <%if(!eval5.getEval_gr().equals("����") && !eval5.getEval_gr().equals("����")){
                      	if(eval5.getEval_off().equals("3")){
                      		String scope = "";
                      		switch(eval5.getEval_gr()){
	                      		case "1": scope = "(955~1000)"; break;
	        					case "2": scope = "(907~954)"; break;
	        					case "3": scope = "(837~906)"; break;
	        					case "4": scope = "(770~836)"; break;
	        					case "5": scope = "(693~769)"; break;
	        					case "6": scope = "(620~692)"; break;
	        					case "7": scope = "(535~619)"; break;
	        					case "8": scope = "(475~534)"; break;
	        					case "9": scope = "(390~474)"; break;
	        					case "10": scope = "(1~389)"; break;
                      		}
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval5.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval5.getEval_gr())%>
                      <%}
                      	}%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval5.getEval_s_dt())%></td>
                </tr>      
        		    <%
        		    	}else{
        		    		//����
     		  					if(client.getClient_st().equals("1")){	
        		  				eval1 = a_db.getContEval(rent_mng_id, rent_l_cd, "1", "");
        				%>
                <tr>
                    <td class=title>����</td>
                    <td align="center"><%=eval1.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval1.getEval_off().equals("1")) out.println("ũ��ž");%>
                      <%if(eval1.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval1.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"></td>
                    <td align="center">
                    	<%if(eval1.getEval_gr().equals("����")) out.println("����");%>
                      <%if(eval1.getEval_gr().equals("����")) out.println("����");%>
                      <%if(!eval1.getEval_gr().equals("����") && !eval1.getEval_gr().equals("����")){
                      	if(eval1.getEval_off().equals("3")){
                      		String scope = "";
                      		switch(eval1.getEval_gr()){
	                      		case "1": scope = "(955~1000)"; break;
	        					case "2": scope = "(907~954)"; break;
	        					case "3": scope = "(837~906)"; break;
	        					case "4": scope = "(770~836)"; break;
	        					case "5": scope = "(693~769)"; break;
	        					case "6": scope = "(620~692)"; break;
	        					case "7": scope = "(535~619)"; break;
	        					case "8": scope = "(475~534)"; break;
	        					case "9": scope = "(390~474)"; break;
	        					case "10": scope = "(1~389)"; break;
                      		}
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval1.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval1.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval1.getEval_b_dt())%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval1.getEval_s_dt())%></td>
                </tr>
                <%	} %>
        		  	<%	//��ǥ���뺸�� ������ �ƴ�
        		  			if(!cont_etc.getClient_guar_st().equals("2")){
        		  				eval2 = a_db.getContEval(rent_mng_id, rent_l_cd, "2", "");
        				%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>��ǥ�̻�<%}else{%>����<%}%></td>
                    <td align="center"><%=eval2.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval2.getEval_off().equals("1")) out.println("ũ��ž");%>
                      <%if(eval2.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval2.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval2.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval2.getEval_gr().equals("����")) out.println("����");%>
                      <%if(eval2.getEval_gr().equals("����")) out.println("����");%>
                      <%if(!eval2.getEval_gr().equals("����") && !eval2.getEval_gr().equals("����")){
                      	if(eval2.getEval_off().equals("3")){
                      		String scope = "";
                      		switch(eval2.getEval_gr()){
	                      		case "1": scope = "(955~1000)"; break;
	        					case "2": scope = "(907~954)"; break;
	        					case "3": scope = "(837~906)"; break;
	        					case "4": scope = "(770~836)"; break;
	        					case "5": scope = "(693~769)"; break;
	        					case "6": scope = "(620~692)"; break;
	        					case "7": scope = "(535~619)"; break;
	        					case "8": scope = "(475~534)"; break;
	        					case "9": scope = "(390~474)"; break;
	        					case "10": scope = "(1~389)"; break;
                      		}
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval2.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval2.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval2.getEval_s_dt())%></td>
                </tr>
                
                <%	  
                			eval6 = a_db.getContEval(rent_mng_id, rent_l_cd, "6", "");
        				%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>��ǥ�̻�<%}else{%>����<%}%></td>
                    <td align="center"><%=eval6.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval6.getEval_off().equals("1")) out.println("ũ��ž");%>
                      <%if(eval6.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval6.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval6.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval6.getEval_gr().equals("����")) out.println("����");%>
                      <%if(eval6.getEval_gr().equals("����")) out.println("����");%>
                      <%if(!eval6.getEval_gr().equals("����") && !eval6.getEval_gr().equals("����")){
                      	if(eval6.getEval_off().equals("3")){
                      		String scope = "";
                      		switch(eval6.getEval_gr()){
	                      		case "1": scope = "(955~1000)"; break;
	        					case "2": scope = "(907~954)"; break;
	        					case "3": scope = "(837~906)"; break;
	        					case "4": scope = "(770~836)"; break;
	        					case "5": scope = "(693~769)"; break;
	        					case "6": scope = "(620~692)"; break;
	        					case "7": scope = "(535~619)"; break;
	        					case "8": scope = "(475~534)"; break;
	        					case "9": scope = "(390~474)"; break;
	        					case "10": scope = "(1~389)"; break;
                      		}
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval6.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval6.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval6.getEval_s_dt())%></td>
                </tr>
                                
        		  	<%	}%>
        		  
        		  	<%	//���� ��ǥ�� ����������
        		  			if(!cont_etc.getClient_guar_st().equals("1") && cont_etc.getClient_share_st().equals("1")){
        		  			
        		  				eval7 = a_db.getContEval(rent_mng_id, rent_l_cd, "7", "");
        				%>
                <tr>
                    <td class=title>����������</td>
                    <td align="center"><%=eval7.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval7.getEval_off().equals("1")) out.println("ũ��ž");%>
                      <%if(eval7.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval7.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval7.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval7.getEval_gr().equals("����")) out.println("����");%>
                      <%if(eval7.getEval_gr().equals("����")) out.println("����");%>
                      <%if(!eval7.getEval_gr().equals("����") && !eval7.getEval_gr().equals("����")){
                      	if(eval7.getEval_off().equals("3")){
                      		String scope = "";
                      		switch(eval7.getEval_gr()){
	                      		case "1": scope = "(955~1000)"; break;
	        					case "2": scope = "(907~954)"; break;
	        					case "3": scope = "(837~906)"; break;
	        					case "4": scope = "(770~836)"; break;
	        					case "5": scope = "(693~769)"; break;
	        					case "6": scope = "(620~692)"; break;
	        					case "7": scope = "(535~619)"; break;
	        					case "8": scope = "(475~534)"; break;
	        					case "9": scope = "(390~474)"; break;
	        					case "10": scope = "(1~389)"; break;
                      		}
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval7.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval7.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
					          <td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval7.getEval_s_dt())%></td>
                </tr>
        		  	<%	
        		  				eval8 = a_db.getContEval(rent_mng_id, rent_l_cd, "8", "");
        				%>
                <tr>
                    <td class=title>����������</td>
                    <td align="center"><%=eval8.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval8.getEval_off().equals("1")) out.println("ũ��ž");%>
                      <%if(eval8.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval8.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval8.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval8.getEval_gr().equals("����")) out.println("����");%>
                      <%if(eval8.getEval_gr().equals("����")) out.println("����");%>
                      <%if(!eval8.getEval_gr().equals("����") && !eval8.getEval_gr().equals("����")){
                      	if(eval8.getEval_off().equals("3")){
                      		String scope = "";
                      		switch(eval8.getEval_gr()){
	                      		case "1": scope = "(955~1000)"; break;
	        					case "2": scope = "(907~954)"; break;
	        					case "3": scope = "(837~906)"; break;
	        					case "4": scope = "(770~836)"; break;
	        					case "5": scope = "(693~769)"; break;
	        					case "6": scope = "(620~692)"; break;
	        					case "7": scope = "(535~619)"; break;
	        					case "8": scope = "(475~534)"; break;
	        					case "9": scope = "(390~474)"; break;
	        					case "10": scope = "(1~389)"; break;
                      		}
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval8.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>>
                      <%=c_db.getNameByIdCode("0013","",eval8.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval8.getEval_s_dt())%></td>
                </tr>                
        		  	<%	}%>
        		          		  
        		  	<%}%>
        		  	
        		  	<%if(gur_size > 0){
        		  			for(int i = 0 ; i < gur_size ; i++){
        							Hashtable gur = (Hashtable)gurs.elementAt(i);
        							eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));
        				%>
                <tr>
                    <td class=title>���뺸����</td>
                    <td align="center"><%=eval4.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval4.getEval_off().equals("1")) out.println("ũ��ž");%>
                      <%if(eval4.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval4.getEval_off().equals("3")) out.println("KCB");%>                    	
                    </td>
                    <td align="center"><%= eval4.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval4.getEval_gr().equals("����")) out.println("����");%>
                      <%if(eval4.getEval_gr().equals("����")) out.println("����");%>
                      <%if(!eval4.getEval_gr().equals("����") && !eval4.getEval_gr().equals("����")){
                      	if(eval4.getEval_off().equals("3")){
                      		String scope = "";
                      		switch(eval4.getEval_gr()){
	                      		case "1": scope = "(955~1000)"; break;
	        					case "2": scope = "(907~954)"; break;
	        					case "3": scope = "(837~906)"; break;
	        					case "4": scope = "(770~836)"; break;
	        					case "5": scope = "(693~769)"; break;
	        					case "6": scope = "(620~692)"; break;
	        					case "7": scope = "(535~619)"; break;
	        					case "8": scope = "(475~534)"; break;
	        					case "9": scope = "(390~474)"; break;
	        					case "10": scope = "(1~389)"; break;
                      		}
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval4.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval4.getEval_gr())%>
                      <%}
                      }%>
        						</td>
										<td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval4.getEval_s_dt())%></td>
                </tr>
        		  	<%	}
        		  	  }
        		  	%>
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڻ���Ȳ</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" rowspan="2" class=title>����</td>
                    <td colspan="2" class=title>������1</td>
                    <td colspan="2" class=title>������2</td>
                </tr>
                <tr>
                    <td width="15%" class=title>����</td>
                    <td width="28%" class='title'>�ּ�</td>
                    <td width="15%" class=title>����</td>
                    <td width="29%" class='title'>�ּ�</td>
                </tr>	  
        		    <%if(client.getClient_st().equals("2")){%>
                <tr>
                    <td class=title>�����</td>
        			      <td align="center"><%=c_db.getNameByIdCode("0014","",eval3.getAss1_type())%></td>
					          <td>&nbsp;<%=eval3.getAss1_zip()%>&nbsp;<%=eval3.getAss1_addr()%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval3.getAss2_type())%></td>
					          <td>&nbsp;<%=eval3.getAss2_zip()%>&nbsp;<%=eval3.getAss2_addr()%></td>
                </tr> 
                <% }else{%>
                <% 		if(client.getClient_st().equals("1")){%>
                <tr>
                    <td class=title>����</td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval1.getAss1_type())%></td>
					          <td>&nbsp;<%=eval1.getAss1_zip()%>&nbsp;<%=eval1.getAss1_addr()%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval1.getAss2_type())%></td>
					          <td>&nbsp;<%=eval1.getAss2_zip()%>&nbsp;<%=eval1.getAss2_addr()%></td>
                </tr>
                <%		}%>
        		    <%		if(!cont_etc.getClient_guar_st().equals("2")){%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>��ǥ�̻�<%}else{%>����<%}%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval2.getAss1_type())%></td>
					          <td>&nbsp;<%=eval2.getAss1_zip()%>&nbsp;<%=eval2.getAss1_addr()%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval2.getAss2_type())%></td>
					          <td>&nbsp;<%=eval2.getAss2_zip()%>&nbsp;<%=eval2.getAss2_addr()%></td>
                </tr>
        		  	<% 		}%>

        		  	<%		
        		  		
        		  		if(!cont_etc.getClient_guar_st().equals("1") && cont_etc.getClient_share_st().equals("1")){
        		  	%>
                <tr>
                    <td class=title>����������</td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval7.getAss1_type())%></td>
										<td colspan=>&nbsp;<%=eval7.getAss1_zip()%>&nbsp;<%=eval7.getAss1_addr()%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval7.getAss2_type())%></td>
					          <td colspan=>&nbsp;<%=eval7.getAss2_zip()%>&nbsp;<%=eval7.getAss2_addr()%></td>
                </tr>               
        		  	<% 		} %>

        		  	<% } %>
        		  	
        		  	<% if(gur_size > 0){
        		  				for(int i = 0 ; i < gur_size ; i++){
        								Hashtable gur = (Hashtable)gurs.elementAt(i);
        								eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));%>
                <tr>
                    <td class=title>���뺸����<%=i+1%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval4.getAss1_type())%></td>
					          <td colspan=>&nbsp;<%=eval4.getAss1_zip()%>&nbsp;<%=eval4.getAss1_addr()%></td>
        			      <td align="center"><%=c_db.getNameByIdCode("0014","",eval4.getAss2_type())%></td>
					          <td colspan=>&nbsp;<%=eval4.getAss2_zip()%>&nbsp;<%=eval4.getAss2_addr()%></td>
                </tr>
        		  	<%		}
        		  			}
        		  	%>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('4','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ�������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>��Ÿ</td>
                    <td>&nbsp;<%=cont_etc.getDec_etc()%></td>
                </tr>
    		</table>	  
	    </td>
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ſ�������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" rowspan="2" class=title>����ſ���</td>
                    <td colspan="2" class=title>�ɻ�</td>
                    <td colspan="2" class=title>����</td>
                </tr>
                <tr>
                    <td width="20%" class=title>�����</td>
                    <td width="20%" class='title'>��������</td>
                    <td width="20%" class=title>������</td>
                    <td width="27%" class='title'>��������</td>
                </tr>
                <tr>
                    <td align="center">
                      <%if(cont_etc.getDec_gr().equals("3")){%>�ż�����<%}%>
                      <%if(cont_etc.getDec_gr().equals("0")){%>�Ϲݰ�<%}%>
                      <%if(cont_etc.getDec_gr().equals("1")){%>�췮���<%}%>
                      <%if(cont_etc.getDec_gr().equals("2")){%>�ʿ췮���<%}%>
                    </td>
                    <td align="center"><%=c_db.getNameById(cont_etc.getDec_f_id(), "USER")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(cont_etc.getDec_f_dt())%></td>
                    <td align="center"><%=c_db.getNameById(cont_etc.getDec_l_id(), "USER")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(cont_etc.getDec_l_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('7','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<%}%>
	
	<%}%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
	</tr>
		<tr>
	    <td class=line2></td>
		</tr>
    <tr> 
        <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		        <%if(!cr_bean.getCar_no().equals("")){%>
        	      <tr>
        		        <td width='13%' class='title'> ������ȣ </td>
        		        <td width="20%">&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a> (<%=cr_bean.getCar_mng_id()%>)</td>
                	  <td class='title' width="10%">������ȣ</td>
        		        <td>&nbsp;<%=cr_bean.getCar_doc_no()%>&nbsp;(<%String car_ext = cr_bean.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>)</td>
        		        <td width="10%" class='title'><%if(cr_bean.getCar_use().equals("1")){%>���ɸ�����<%}else{%>���ʵ����<%}%></td>
        		        <td>&nbsp;<%if(cr_bean.getCar_use().equals("1")){%><font color=red><b><%=cr_bean.getCar_end_dt()%></b></font><%}else{%><%=cr_bean.getInit_reg_dt()%><%}%></td>
        	      </tr>
    		        <tr>
        		        <td class='title'> �˻���ȿ�Ⱓ </td>
        		        <td>&nbsp;<b><%=cr_bean.getMaint_st_dt()%>~<%=cr_bean.getMaint_end_dt()%></b></td>
                	  <td class='title'>������ȿ�Ⱓ</td>
        		        <td colspan='3'>&nbsp;<b><%=cr_bean.getTest_st_dt()%>~<%=cr_bean.getTest_end_dt()%></b></td>
    		        </tr>
        		    <%}%>
                <tr>
                    <td width='13%' class='title'>�ڵ���ȸ��</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' width="10%">����</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' width='10%'>����</td>
                    <td>&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[������]<%}%><a href="javascript:view_car_nm('<%=cm_bean.getCar_id()%>', '<%=cm_bean.getCar_seq()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cm_bean.getCar_name()%></a></td>
                </tr>
                <tr>
                    <td class='title'>�Һз� </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
                    <td class='title' width="10%">�����ڵ�</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>��ⷮ</td>
                    <td>&nbsp;<%if(cr_bean.getCar_mng_id().equals("")){%><%=cm_bean.getDpm()%>cc<%}else{%><%=cr_bean.getDpm()%>cc<%}%></td>
                </tr>
                <tr>
                    <td class='title'>GPS��ġ������ġ</td>
                    <td colspan="5">&nbsp;<%if(cr_bean.getGps().equals("Y")){%>����<%}else{%>������<%}%></td>
                </tr>
                <tr>
                    <td class='title'>�ɼ�</td>
                    <td colspan="5">&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr>
                	<td class="title">����</td>
                	<td colspan="5">&nbsp;<%=car.getConti_rat() %></td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
	  <tr>
	    <td align="right"></td>
	  <tr>	    
    <%}else{%>    
		<tr>
		  <td align="right"><a href="javascript:reset_car()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
		<tr>	
		<%}%>
		<tr></tr><tr></tr>
		<tr>
	    <td class=line2></td>
		</tr>		
    <tr> 
        <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td class='title'>����</td>
                    <td colspan="5">&nbsp;<%=car.getColo()%>
					              &nbsp;&nbsp;&nbsp;
					              (�������(��Ʈ): <%=car.getIn_col()%>)  
					              &nbsp;&nbsp;&nbsp;
					              (���Ͻ�: <%=car.getGarnish_col()%>)  
        			      </td>
                </tr>
                <%if(ej_bean.getJg_g_7().equals("3")){//������%>	
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td colspan="5">&nbsp;
                    	  <%=c_db.getNameByIdCode("0034", "", pur.getEcar_loc_st())%>
        			      </td>
                </tr>
                <%}%>
                <%if(ej_bean.getJg_g_7().equals("4")){//������%>	
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td colspan="5">&nbsp;
                    	  <%=c_db.getNameByIdCode("0037", "", pur.getHcar_loc_st())%>
        			      </td>
                </tr>
                <%}%>                
          <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����-��������%>
          <!-- 
          <tr <%if ((ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) && !car.getEco_e_tag().equals("1")) {%>style="display: none;"<%}%>>
            <td class='title'>�������ｺƼĿ �߱�<br>(�����ͳ� �̿� �����±�)</td>
            <td colspan="5">&nbsp;<%String eco_e_tag = car.getEco_e_tag(); if(eco_e_tag.equals("1")){%>�߱�<%}else{%>�̹߱�<%}%>
            	&nbsp;�� ģȯ���� �� �� �����ͳ� ���̿��ڸ� �߱� ����, ���̺긮��/�÷����� ���̺긮�� ������ ��� ���������� �뿩�ᰡ ���� ��µ�.
            </td>            
          </tr>
           -->
          <%}%>                
                <tr>
                    <td class='title'>�����μ���</td>
                    <td colspan="5">&nbsp;
        						    <%=c_db.getNameByIdCode("0035", "", pur.getUdt_st())%>        						    
        			          &nbsp; �μ��� Ź�۷� : <%=AddUtil.parseDecimal(pur.getCons_amt1())%>�� (���μ��� ���� ���� �Է��ϼ���.)
        			  </td>
                </tr>
                <tr>
                    <td width='13%' class='title'>�������</td>
                    <td colspan="5">&nbsp;
                    	<%=c_db.getNameByIdCode("0032", "", car.getCar_ext())%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
	  <tr>
	    <td align="right"></td>
	  <tr>	    
    <%}else{%>    
		<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('8_1','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>	
		<%}%>
    <tr> 
        <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td width='13%' class='title'>����</td>
                    <td <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %> width='10%' <% } else { %> colspan="3" <% } %>>&nbsp;<%=car.getSun_per()%>%</td>
                    <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>
	                    <td width='13%' class='title'>��縵ũ����</td>
	                    <td colspan="3">&nbsp;
	                        <%if(car.getBluelink_yn().equals("")){%><%}%>
	                        <%if(car.getBluelink_yn().equals("Y")){%>����<%}%>
	                        <%if(car.getBluelink_yn().equals("N")){%>����<%}%>
	                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;�� �������ý� ��縵ũ ���� �ȳ��� �˸���߼�(�����ٻ�����)</span>
	                    </td>
                    <% } %>
                </tr>
                <tr>
                    <td class='title'><span class="title1">������߰�����</span></td>
                    <td colspan="5">&nbsp;<%=car.getAdd_opt()%>&nbsp;�ݾ�:<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����ݿ���,LPGŰƮ����,�׺���̼ǵ�)</font></span></td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">�����ݿ���ǰ</span></td>
                    <td colspan="5">&nbsp;
                    	<%if(car.getTint_b_yn().equals("Y")){%>&nbsp;2ä�� ���ڽ�<%}%>
						<%if(car.getTint_s_yn().equals("Y")){%>&nbsp;���� ����(�⺻��)
						���ñ��������� : <%=car.getTint_s_per()%>% 
						<%}%>
						<%if(car.getTint_ps_yn().equals("Y")){%>&nbsp;��޽���(��������)
						���� <%=car.getTint_ps_nm()%>
						��ǰ�� ���ޱݾ� <%=AddUtil.parseDecimal(car.getTint_ps_amt())%> �� (�ΰ�������)
						<%}%>
                      <%if(car.getTint_n_yn().equals("Y")){%>&nbsp;��ġ�� ������̼�<%}%>
                      <%if(car.getTint_sn_yn().equals("Y")){%>&nbsp;���� ���� �̽ð� ����<%}%>
                      <%if(car.getTint_bn_yn().equals("Y")){%>&nbsp;���ڽ� ������ ���� (<%if(car.getTint_bn_nm().equals("1")){%>��Ʈ��ķ<%}else if(car.getTint_bn_nm().equals("2")){%>������<%}else{%>��Ʈ��ķ,������..<%}%>)<%}%>
					  <%if(car.getTint_cons_yn().equals("Y")){%>&nbsp;�߰�Ź�۷��
						&nbsp;<%=AddUtil.parseDecimal(car.getTint_cons_amt())%> ��
					  <%}%>
                      <%if(car.getTint_eb_yn().equals("Y")){%>&nbsp;�̵��� ������(������)<%}%>
                      <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>
                      	&nbsp;������ȣ��
                      <%} else if(car.getNew_license_plate().equals("0")){%>
                      	&nbsp;������ȣ��
                      <%} %>
                      <%-- <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>&nbsp;������ȣ�ǽ�û<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("1")){%>&nbsp;������ȣ�ǽ�û(������)<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("2")){%>&nbsp;������ȣ�ǽ�û(����/�뱸/����/�λ�)<%}%> --%>
                    </td>
                </tr>   
                <tr>
                    <td class='title'><span class="title1">����ǰ��</span></td>
                    <td colspan="5">&nbsp;<%=car.getExtra_set()%>&nbsp;�ݾ�:<%=AddUtil.parseDecimal(car.getExtra_amt())%>��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����̹ݿ���)</font></span><br>
        					  <%if(car.getServ_b_yn().equals("Y")){%>���ڽ� (2015��8��1�Ϻ���)<%}%>
        					  <%if(ej_bean.getJg_g_7().equals("3")){%>
        					  	<%if(car.getServ_sc_yn().equals("Y")){%>������������<%}%>
        					  <%} %>	
                    </td>
                </tr>
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;<%=car.getRemark()%></td>
                </tr>
                <%if(!cr_bean.getDist_cng().equals("")){%>
                <tr>
                  <td class='title'>����Ǳ�ü</td>
                  <td colspan="5">&nbsp;<font color=green><%=cr_bean.getDist_cng()%></font></td>
                </tr>                
                <%}%>

            </table>
        </td>
    </tr>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
	  <tr>
	    <td align="right"></td>
	  <tr>	    
    <%}else{%>    
		<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('8','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>	
		<%}%>
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
		</tr>
		<tr>
	    <td class=line2></td>
		</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>��������</td>
                    <td colspan="3">&nbsp;
                        <%if(car.getPurc_gu().equals("1")){%> ���� <%}%>
                        <%if(car.getPurc_gu().equals("0")){%> �鼼 <%}%>
                    </td>
                    <td class='title'>��ó</td>
                    <td colspan="3">&nbsp;
                        <%if(car.getCar_origin().equals("1")){%> ���� <%}%>
                        <%if(car.getCar_origin().equals("2")){%> ���� <%}%>
                    </td>
                </tr>
                <tr>
                    <td width="13%" rowspan="2" class='title'>���� </td>
                    <td colspan="3" class='title'>�Һ��ڰ���</td>
                    <td width="10%" rowspan="2" class='title'>����</td>
                    <td colspan="3" class='title'>���԰���</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>���ް�</td>
                    <td width="13%" class='title'>�ΰ���</td>
                    <td width="13%" class='title'>�հ�</td>
                    <td width="13%" class='title'>���ް�</td>
                    <td width="12%" class='title'>�ΰ���</td>
                    <td width="13%" class='title'>�հ�</td>
                </tr>
                <tr>
                    <td class='title'> �⺻����</td>
                    <td>&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td class=title>��������</td>
                    <td>&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' >
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum'>
             			��</td>
                </tr>
                <tr>
                    <td height="12" class='title'>�ɼ�</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' >
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' >
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  >
             			��</td>
                    <td class=title>Ź�۷�</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='whitenum' >
             			��</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='whitenum' >
             			��</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='whitenum'  >
             			��</td>
                </tr>
                <tr>
                    <td height="26" class='title'> ����</td>
                    <td>&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' >
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  >
             			��</td>
                    <td class=title>����D/C</td>
                    <td>&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' maxlength='10' class='whitenum' >
        				��</td>
                    <td>&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' maxlength='10' class='whitenum' >
        				��</td>
                    <td>&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' maxlength='10' class='whitenum'  >
        				��</td>
                </tr>
              <tr id=tr_ecar_dc <%if(base.getDlv_dt().equals("") || car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>���Ҽ� �����</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='whitenum' >
         			��</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum' >
         			��</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum'  >
         			��</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr> 
                <tr>
                    <td align="center" class='title_p'>�հ�</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' >
        			    ��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' >
        				��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  >
        				��</td>
                    <td align='center' class='title_p'>�հ�</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' >
        				��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' >
        				��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  >
        				��</td>
                </tr>
                <tr>
                    <td class='title'>���ο���</td>
                    <td>&nbsp;
                        <%if(car.getPay_st().equals("1")){%> ���� <%}%>
                        <%if(car.getPay_st().equals("2")){%> �鼼 <%}%>
                    </td>
                    <td class='title'>Ư�Ҽ�</td>
                    <td >&nbsp;
                      <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='whitenum' >
        				��</td>
                    <td class='title'>������</td>
                    <td >&nbsp;
                      <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='whitenum' >
        				��</td>
                    <td class='title'>�հ�</td>
                    <td >&nbsp;
                      <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='whitenum' >
        				��</td>
                </tr>
            </table>		
	    </td>
    </tr>
    <!-- ������ ���� �� �������� ǥ��(20190911)- �����̰� �ű԰���� ��츸 -->
    <%if(base.getCar_gu().equals("1") && fee_size<=1){ %>
    <tr>
  		<td>
  			<font color="#666666">* ���� ��༭�� ������ ���� �� �������� ���� ǥ�� ����</font>
  			<input type="checkbox" name="dc_view_yn" id="dc_view_yn" <%if(cont_etc.getView_car_dc()!=0){%>checked<%}%> onclick="javascript:span_dc_view();">&nbsp;&nbsp;&nbsp;
  			<span id="span_dc_view" style="display:<%if(cont_etc.getView_car_dc()==0){%> none<%}else{%><%}%>;">
  				<font color="#666666">������ ���� �� �������� :  
  					<%=AddUtil.parseDecimal(String.valueOf(cont_etc.getView_car_dc()))%> ��
  				</font>
  			</span>
  		</td>
  	</tr>
  	<%}%>
    <%if(ej_bean.getJg_w().equals("1")){//������%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ������ ����</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>ī������ݾ�</td>
                    <td width="27%">&nbsp;<%= AddUtil.parseDecimal(car.getImport_card_amt())%>��
                    </td>
                    <td width="10%" class='title'>Cash Back�ݾ�</td>
                    <td width="20%">&nbsp;<%= AddUtil.parseDecimal(car.getImport_cash_back())%>��
        	    </td>	
        	    <td width="10%" class='title'>Ź�۽��ú���</td>
                    <td width="20%">&nbsp;<%= AddUtil.parseDecimal(car.getImport_bank_amt())%>��
        	    </td>	

                </tr>
            </table>
	    </td>
    </tr>      
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ �ǹ߻� �ݾ�</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>-</td>
                    <td width="27%">&nbsp;                        
                    </td>
                    <td width="10%" class='title'>Cash Back�ݾ�</td>
                    <td width="20%">&nbsp;<%= AddUtil.parseDecimal(car.getR_import_cash_back())%>��
        	    </td>	
        	    <td width="10%" class='title'>Ź�۽��ú���</td>
                    <td width="20%">&nbsp;<%= AddUtil.parseDecimal(car.getR_import_bank_amt())%>��
        	    </td>	

                </tr>
            </table>
	    </td>
    </tr>          
    <%}%> 
    <%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ģȯ����</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>���ź�����</td>
                    <td width="27%">&nbsp;<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>��
                    </td>
                    <td width="10%" class='title'>�����ݼ��ɹ��</td>
                    <td>&nbsp;
                          <%if(car.getEcar_pur_sub_st().equals("1")){%> ������ ������� ���� <%}%>
                          <%if(car.getEcar_pur_sub_st().equals("2")){%> �Ƹ���ī ���� ���� <%}%>
        	          </td>
                </tr>
            </table>
	    </td>
    </tr>
    <%}%>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
	  <tr>
	    <td align="right"></td>
	  <tr>	    
    <%}else{%>
	  <tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><%if( base.getRent_start_dt().equals("") || nm_db.getWorkAuthUser("������",user_id)||nm_db.getWorkAuthUser("��ຯ�����",user_id)||nm_db.getWorkAuthUser("��������������",user_id)||nm_db.getWorkAuthUser("�����������",user_id)||nm_db.getWorkAuthUser("�����������2",user_id)||nm_db.getWorkAuthUser("�����������3",user_id)) {%><a href="javascript:update('9','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%><%}%></td>
	  <tr>	
		<%}%>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
    <%	for(int f=1; f<=fee_size; f++){
					ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));
					
					if(base.getCar_gu().equals("1") && f==1) continue;
		%>	    
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(f>1){%><%=f-1%>�� ���� <%}%>�߰�����</span></td>
    </tr>
		<tr>
	    <td class=line2></td>
		</tr>		
    <tr>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> �����Һ��ڰ� </td>
                    <td width="20%">&nbsp;<%=AddUtil.parseDecimal(fee_etcs.getSh_car_amt())%></td>
                    <td class='title' width="10%">�ܰ���</td>
                    <td width="10%">&nbsp;<%= AddUtil.parseFloatCipher(fee_etcs.getSh_ja(),2) %>%</td>
                    <td class='title' width='10%'>�߰�����</td>
                    <td width="37%">&nbsp;<%= AddUtil.parseDecimal(fee_etcs.getSh_amt()) %>��</td>
                </tr>
                <tr>
                  <td class='title'>����</td>
                  <td colspan="5">&nbsp;<%=fee_etcs.getSh_year()%>��<%=fee_etcs.getSh_month()%>����<%=fee_etcs.getSh_day()%>�� (���ʵ����<%=AddUtil.ChangeDate2(fee_etcs.getSh_init_reg_dt())%>~�����<%=AddUtil.ChangeDate2(fee_etcs.getSh_day_bas_dt())%>)</td>
                </tr>
                <tr>
                  <td class='title'>��������Ÿ�</td>
                  <td colspan="5">&nbsp;<%= AddUtil.parseDecimal(fee_etcs.getSh_km()) %>km 
                  	( <%if(f==1){%>����� <%}else{%> �뿩������<%}%><%=AddUtil.ChangeDate2(fee_etcs.getSh_day_bas_dt())%> )
					            / Ȯ������Ÿ� <%= AddUtil.parseDecimal(fee_etcs.getSh_tot_km()) %>km 
					            ( ����Ȯ���� <%= AddUtil.ChangeDate2(fee_etcs.getSh_km_bas_dt()) %> )
					        </td>
                </tr>
            </table>
	    </td>
    </tr>
    <%	}%>
		<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('9_2','<%=fee_size%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>	
    <%}%>		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>
	<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;1. ���� ���Ե� ��������</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title >��������</td>
                    <td width="20%">&nbsp;
                          <%if(ins.getConr_nm().equals("�Ƹ���ī")){%> �Ƹ���ī <%}%>
                          <%if(!ins.getConr_nm().equals("�Ƹ���ī")){%> �� <%}%>
                    </td>
                    <td width="10%" class=title >�Ǻ�����</td>
                    <td>&nbsp;
                          <%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%> �Ƹ���ī <%}%>
                          <%if(!ins.getCon_f_nm().equals("�Ƹ���ī")){%> �� <%}%>
                    </td>
                    <td width="10%" class=title >��������������Ư��</td>
                    <td>&nbsp;
                          <%if(ins.getCom_emp_yn().equals("Y")){%> ���� <%}%>
                          <%if(ins.getCom_emp_yn().equals("N")){%> �̰��� <%}%>
                    </td>
                </tr>                  
                <tr>
                    <td width="13%" class=title >�����ڿ���</td>
                    <td width="20%">&nbsp;
                            <%if(ins.getAge_scp().equals("1")){%>21���̻�<%}%>
                            <%if(ins.getAge_scp().equals("4")){%>24���̻�<%}%>
                            <%if(ins.getAge_scp().equals("2")){%>26���̻�<%}%>
                            <%if(ins.getAge_scp().equals("3")){%>������<%}%>
                            <%if(ins.getAge_scp().equals("5")){%>30���̻�<%}%>
                            <%if(ins.getAge_scp().equals("6")){%>35���̻�<%}%>
                            <%if(ins.getAge_scp().equals("7")){%>43���̻�<%}%>
						                <%if(ins.getAge_scp().equals("8")){%>48���̻�<%}%>
						                <%if(ins.getAge_scp().equals("9")){%>22���̻�<%}%>
						                <%if(ins.getAge_scp().equals("10")){%>28���̻�<%}%>
						                <%if(ins.getAge_scp().equals("11")){%>35���̻�~49������<%}%>
                    </td>
                    <td width="10%" class=title >�빰���</td>
                    <td width="15%">&nbsp;
                            <%if(ins.getVins_gcp_kd().equals("9")){%>10���<%}%>
                            <%if(ins.getVins_gcp_kd().equals("6")){%>5���<%}%>
                            <%if(ins.getVins_gcp_kd().equals("8")){%>3���<%}%>
			                      <%if(ins.getVins_gcp_kd().equals("7")){%>2���<%}%>
                            <%if(ins.getVins_gcp_kd().equals("3")){%>1���<%}%>
                            <%if(ins.getVins_gcp_kd().equals("4")){%>5000����<%}%>
                            <%if(ins.getVins_gcp_kd().equals("1")){%>3000����<%}%>
                            <%if(ins.getVins_gcp_kd().equals("2")){%>1500����<%}%>
                            <%if(ins.getVins_gcp_kd().equals("5")){%>1000����<%}%>
                    </td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td>&nbsp;
                            <%if(ins.getVins_bacdt_kd().equals("1")){%>3���<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("2")){%>1��5õ����<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("6")){%>1���<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("5")){%>5000����<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("3")){%>3000����<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("4")){%>1500����<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("9")){%>�̰���<%}%>
                    </td>
                </tr>
            </table>
	    </td>		
	</tr>
	<tr>
	    <td>&nbsp;&nbsp;&nbsp;&nbsp;2. ��༭�� ������ ��������</td>
	</tr>		
	<%}%>
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>��������</td>
                    <td width="20%">&nbsp;
                          <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> �Ƹ���ī <%}%>
                          <%if(cont_etc.getInsurant().equals("2")){%> �� <%}%>
                    </td>
                    <td width="10%"  class=title>�Ǻ�����</td>
                    <td colspan='3'>&nbsp;
                          <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> �Ƹ���ī <%}%>
                          <%if(cont_etc.getInsur_per().equals("2")){%> �� <%}%>
                    </td>
                </tr>            
                <tr> 
                    <td width="13%" class=title>�����ڹ���</td>
                    <td width="20%" class=''>&nbsp;
        			            <%if(base.getDriving_ext().equals("1")){%> ����� <%}%>
                          <%if(base.getDriving_ext().equals("2")){%> �������� <%}%>
                          <%if(base.getDriving_ext().equals("3")){%> ��Ÿ <%}%>
                      
        			</td>
                    <td width="10%" class=title >�����ڿ���</td>
                    <td>&nbsp;
                          <%if(base.getDriving_age().equals("0")){%> 26���̻� <%}%>
                          <%if(base.getDriving_age().equals("3")){%> 24���̻� <%}%>
                          <%if(base.getDriving_age().equals("1")){%> 21���̻� <%}%>
                          <%if(base.getDriving_age().equals("2")){%> �������� <%}%>
                          <%if(base.getDriving_age().equals("5")){%>30���̻�<%}%>
                          <%if(base.getDriving_age().equals("6")){%>35���̻�<%}%>
                          <%if(base.getDriving_age().equals("7")){%>43���̻�<%}%>
					                <%if(base.getDriving_age().equals("8")){%>48���̻�<%}%>
					                <%if(base.getDriving_age().equals("9")){%>22���̻�<%}%>
					                <%if(base.getDriving_age().equals("10")){%>28���̻�<%}%>
					                <%if(base.getDriving_age().equals("11")){%>35���̻�~49������<%}%>
                          &nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
                    </td>
                <td class=title >��������������Ư��</td>
                <td class=''>&nbsp;
                    <%if(cont_etc.getCom_emp_yn().equals("Y")){%> ���� <%}%>
                    <%if(cont_etc.getCom_emp_yn().equals("N")){%> �̰��� <%}%>
                    <%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
                      <%if(!cont_etc.getCom_emp_sac_id().equals("")){%>
                      [����]<%=c_db.getNameById(cont_etc.getCom_emp_sac_id(),"USER")%>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCom_emp_sac_dt())%>
                      <%}%>
                    <%}%>
                </td>                        
                </tr>
                <tr>
                    <td class=title>���ι��</td>
                    <td>&nbsp; ����(���ι��,��)</td>
                    <td class=title>�빰���</td>
                    <td class=''>&nbsp;
                          <% if(base.getGcp_kd().equals("1")) out.print("5õ����"); %>
                          <% if(base.getGcp_kd().equals("2")) out.print("1���"); %>
						              <% if(base.getGcp_kd().equals("4")) out.print("2���"); %>
						              <% if(base.getGcp_kd().equals("8")) out.print("3���"); %>
                          <% if(base.getGcp_kd().equals("3")) out.print("5���"); %>
                          <% if(base.getGcp_kd().equals("9")) out.print("10���"); %>
                    </td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td class=''>&nbsp;
                          <% if(base.getBacdt_kd().equals("1")) out.print("5õ����"); %>
                          <% if(base.getBacdt_kd().equals("2")) out.print("1���"); %>
                          <% if(base.getBacdt_kd().equals("9")) out.print("�̰���"); %>
                    </td>
                </tr>
                <tr>
                    <td  class=title>������������</td>
                    <td>&nbsp;
                        <%if(cont_etc.getCanoisr_yn().equals("Y")){%> ���� <%}%>
                        <%if(cont_etc.getCanoisr_yn().equals("N")){%> �̰��� <%}%>
                    </td>
                    <td class=title>�ڱ���������</td>
                    <td class=''>&nbsp;
                        <%if(cont_etc.getCacdt_yn().equals("Y")){%> ���� <%}%>
                        <%if(cont_etc.getCacdt_yn().equals("N")){%> �̰��� <%}%>
                    </td>
                    <td class=title >����⵿</td>
                    <td class=''>&nbsp;
                        <%if(cont_etc.getEme_yn().equals("Y")){%> ���� <%}%>
                        <%if(cont_etc.getEme_yn().equals("N")){%> �̰��� <%}%>
                    </td>
                </tr>
                <tr>
                    <td  class=title>������å��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(base.getCar_ja())%>��</td>
                    <td class=title>�������</td>
                    <td class=''>&nbsp;<%=cont_etc.getJa_reason()%></td>
                    <td class=title >������</td>
                    <td class=''>&nbsp;<%=c_db.getNameById(cont_etc.getRea_appr_id(), "USER")%>
                        (�⺻ <%if(base.getCar_st().equals("5")){%>100,000<%}else{%><%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%><%}%>��) 
                    </td>
                </tr>
                <tr>
                    <td  class=title>�ڵ���</td>
                    <td colspan="5">&nbsp;
                    	  ����������� : 
                        <%if(cont_etc.getAir_ds_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getAir_ds_yn().equals("N")){%> �� <%}%>
        		            &nbsp;&nbsp;&nbsp;
        		            ����������� : 
                        <%if(cont_etc.getAir_as_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getAir_as_yn().equals("N")){%> �� <%}%>
        		            &nbsp;&nbsp;&nbsp;
        		            ���ڽ� : 
                        <%if(cont_etc.getBlackbox_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getBlackbox_yn().equals("N")){%> �� <%}%>
						<br/>&nbsp;
						������Ż(������) : 
                        <%if(cont_etc.getLkas_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getLkas_yn().equals("N")){%> �� <%}%>
                       		&nbsp;&nbsp;&nbsp;
                      	 ������Ż(�����) : 
                        <%if(cont_etc.getLdws_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getLdws_yn().equals("N")){%> �� <%}%>
                       		&nbsp;&nbsp;&nbsp;
                       	�������(������) : 
                        <%if(cont_etc.getAeb_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getAeb_yn().equals("N")){%> �� <%}%>
                       		&nbsp;&nbsp;&nbsp;
                     	�������(�����) : 
                        <%if(cont_etc.getFcw_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getFcw_yn().equals("N")){%> �� <%}%>
                       		&nbsp;&nbsp;&nbsp;
                      	 �����ڵ���	 : 
                        <%if(cont_etc.getEv_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getEv_yn().equals("N")){%> �� <%}%>
							&nbsp;&nbsp;&nbsp;
                      	 ���ΰ�(Ʈ���Ϸ���) : 
                        <%if(cont_etc.getHook_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getHook_yn().equals("N")){%> �� <%}%>
							&nbsp;&nbsp;&nbsp;
                      	 �������������(�����) : 
                        <%if(cont_etc.getLegal_yn().equals("Y")){%> ���� <%}%>
                        <%if(cont_etc.getLegal_yn().equals("N")){%> �̰��� <%}%>
                        	&nbsp;&nbsp;&nbsp;
                      	 ž��(��������) : 
                        <%if(cont_etc.getTop_cng_yn().equals("Y")){%> �� <%}%>
                        <%if(cont_etc.getTop_cng_yn().equals("N")){%> �� <%}%>
                        <br/>&nbsp;
                        	��Ÿ��ġ : <%=cont_etc.getOthers_device()%>
                      </td>
                </tr>               
                <tr>
                    <td  class=title>��������<br>��&nbsp;��&nbsp;��<br>��������</td>
                    <td colspan="5">&nbsp;
                    	<%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
                      		<input type="checkbox" name="ac_dae_yn" 	value="Y" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>>
                      	<%} else {%>
                      		  	&nbsp;* 
                      	<%} %> 
                      		  ����������(���ػ��� ����)<br>
        			  &nbsp;
        			  <%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
        			  	<input type="checkbox" name="pro_yn" 		value="Y" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>> 
        			  <%} else {%>
                      		  	&nbsp;* 
                      <%} %> 
        			  ������ �߻��� ���ó�� �������� (����� ���� ���� ��) <br>
        			  &nbsp;
        			  <%if(cont_etc.getCyc_yn().equals("Y")){%>
        			  <input type="checkbox" name="cyc_yn" 		value="Y" <%if(cont_etc.getCyc_yn().equals("Y")){%>checked<%}%>> 
                      		  �� 7,000km �Ǵ� ����û�� ��ȸ���� ���� �ǽ� <br>
        			  &nbsp;        			  
        			  <%}%>
        			  <input type="checkbox" name="main_yn" 	value="Y" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>> 
                      		  ��ü�� ���񼭺�(���α�����ǰ �� �Ҹ�ǰ ��ȯ, �������� ��ȯ ��) <br>
        			  &nbsp;
        			  <input type="checkbox" name="ma_dae_yn" 	value="Y" <%if(cont_etc.getMa_dae_yn().equals("Y")){%>checked<%}%>> 
                      		  �����������(4�ð� �̻� ������� �԰��) <br>
        			  </td>
                </tr>
                <%if(cont_etc.getInsur_per().equals("2")){%>
                <tr>
                    <td  class=title>�Ժ�ȸ��</td>
                    <td colspan="5">
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">
                                	&nbsp;�����  :<%=cont_etc.getIp_insur()%>
                      				    &nbsp;&nbsp;&nbsp;&nbsp;�븮�� : <%=cont_etc.getIp_agent()%>
                      				    &nbsp;&nbsp;&nbsp;&nbsp;����� :<%=cont_etc.getIp_dam()%>
                					        &nbsp;&nbsp;&nbsp;&nbsp;����ó :<%=cont_etc.getIp_tel()%>
                			    </td>
                            </tr>
                        </table>
                    </td>
                </tr>
              <tr>
                <td  class=title>��������</td>
                <td colspan="5">
                    <table width="100%" border="0" cellpadding="0">
                      <tr>
                        <td width="100%">&nbsp;���������������
					                <%if(cont_etc.getCacdt_mebase_amt()==50 ){%>50����<%}%>
					                <%if(cont_etc.getCacdt_mebase_amt()==100){%>100����<%}%>
					                <%if(cont_etc.getCacdt_mebase_amt()==150){%>150����<%}%>
					                <%if(cont_etc.getCacdt_mebase_amt()==200){%>200����<%}%>

					  / (�ִ�)�ڱ�δ�� <%=Util.parseDecimal(String.valueOf(cont_etc.getCacdt_me_amt()))%>���� 
					  / (�ּ�)�ڱ�δ��  
                        <%if(cont_etc.getCacdt_memin_amt()==5 ){%>5����<%}%>
                        <%if(cont_etc.getCacdt_memin_amt()==10){%>10����<%}%>
                        <%if(cont_etc.getCacdt_memin_amt()==15){%>15����<%}%>
                        <%if(cont_etc.getCacdt_memin_amt()==20){%>20����<%}%>
                			    </td>
                      </tr>
                    </table>
                 </td>
                </tr>
                <%}%>
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;<%=base.getOthers()%></td>
                </tr>
            </table>
        </td>
    </tr>	
		<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('10','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>	
		<%if(!base.getCar_st().equals("2")){%>
		
		<%	for(int f=1; f<=fee_size; f++){
					ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));
					if(ext_gin.getRent_mng_id().equals("")) continue;
		%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(f>1){%><%=f-1%>�� ���� <%}%>��������</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
		</tr>
		<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="9">&nbsp;
                        <%if(ext_gin.getGi_st().equals("1")){%> ���� <%}%>
                  		  <%if(ext_gin.getGi_st().equals("0")){%> ���� <%}%>
                  	</td>
                </tr>
                <%if(!ext_gin.getGi_jijum().equals("")||ext_gin.getGi_amt()!=0||ext_gin.getGi_fee()!=0||!ext_gin.getGi_dt().equals("")){%>
                <tr>
                    <%if(now_stat.equals("���°�")){ %>
	                    <td width="13%" class=title>��������</td>
	                    <td width="12%">&nbsp;<%=ext_gin.getGi_jijum()%></td>
	                    <td width="9%" class='title'>���Աݾ�</td>
	                    <td width="10%" >&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>��</td>
	                    <td width="9%" class=title >���������</td>
	                    <td width="10%">&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>��</td>
	                    <td width="9%" class=title >��������</td>
	                    <td width="10%">&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_dt())%></td>
	                    <!-- �������� ���԰��� �߰�(2018.03.21) -->
	                    <td width="9%" class=title >���ԱⰣ</td>
	                    <td width="9%">&nbsp;<%=ext_gin.getGi_month()%><%if(!ext_gin.getGi_month().equals("")){%>����<%}%></td>
	                <%}else{%>
	                	<td width="13%" class=title>��������</td>
	                    <td width="15%">&nbsp;<%=ext_gin.getGi_jijum()%></td>
	                    <td width="10%" class='title'>���Աݾ�</td>
	                    <td width="15%" >&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>��</td>
	                    <td width="10%" class=title >���������</td>
	                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>��</td>
	                    <td width="10%" class=title >��������</td>
	                    <td width="15%">&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_dt())%></td>
	                <%}%>    
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
		<%	}%>
		<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('11','<%=fee_size%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>
		<%for(int f=1; f<=fee_size; f++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
				ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));
		%>
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(f>1){%><%=f-1%>�� ���� <%}%>�뿩���</span></td>
    </tr>
		<tr>
	    <td class=line2></td>
		</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <%if(f==1 && base.getCar_gu().equals("0")){ %>
              <tr>
                <td width="13%" align="center" class=title>�����ε�������</td>
                <td colspan='5'>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_est_dt())%>                    
					 (�縮������� �� �����ε������� ���� ���躯���մϴ�. �ε� Ȯ���� �ٽ� Ȯ���Ͻʽÿ�.)
					 </td>
              </tr>   
              <%} %>
              <tr>
                <td width="13%" align="center" class=title>�������</td>
                <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
                <td width="10%" align="center" class=title>�������</td>
                <td >&nbsp;<%=c_db.getNameById(fees.getExt_agnt(), "USER")%></td>
                <td width="10%" align="center" class=title>�����븮��</td>
                <td >&nbsp;<%=c_db.getNameById(fee_etcs.getBus_agnt_id(), "USER")%></td>
              </tr>
              <tr>
                <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                <td width="20%">&nbsp;<%=fees.getCon_mon()%>����</td>
                <td width="10%" align="center" class=title>�뿩������</td>
                <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                <td width="10%" align="center" class=title>�뿩������</td>
                <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
              </tr>
            </table>
         </td>
     </tr>
     <tr></tr><tr></tr>
     <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="3" class='title'>����</td>
                    <td class='title' width='11%'>���ް�</td>
                    <td class='title' width='11%'>�ΰ���</td>
                    <td class='title' width='13%'>�հ�</td>
                    <td class='title' width='4%'>�Ա�</td>
                    <td class='title' width="28%">�������</td>
                    <td class='title' width='20%'>��������</td>
                </tr>
                <tr>
                    <td width="3%" rowspan="5" class='title'>��<br>
                      ��</td>
                    <td width="10%" class='title' colspan="2">������</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'>
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_gur_p_per' class='whitenum' value='<%=fees.getF_gur_p_per()%>' readonly>
    				            %
        				    </td>
                    <td align='center'>
					            <%if(fee_size==1 && base.getRent_st().equals("3")){%>
					              ���� ������ �°迩�� :
                              <%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}%>
                              <%if(fees.getGrt_suc_yn().equals("1")){%>����<%}%>                            
					            <%}%>
 			                <%if(f>1){%>
                              <%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}%>
                              <%if(fees.getGrt_suc_yn().equals("1")){%>����<%}%>                            
   				            <%}%>
        				    </td>
                </tr>
                <tr>
                    <td class='title' colspan="2">������</td>
                    <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' >
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' >
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' >
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='pere_r_per' class='whitenum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_pere_r_per' class='whitenum' value='<%=fees.getF_pere_r_per()%>' readonly>
    				            %  
        				    </td>
                    <td align='center'>
           ������ ��꼭���౸�� :
					<select name='pp_chk' disabled>
                              <option value="">����</option>
                              <option value="1" <%if(fees.getPp_chk().equals("1")){%>selected<%}%>>�����Ͻù���</option>
                              <option value="0" <%if(fees.getPp_chk().equals("0")){%>selected<%}%>>�ſ��յ����</option>
                            </select>                      	
                    	</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">���ô뿩��</td>
                    <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' >
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ifee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' >
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' >
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2")%></td>
                    <td align="center">������
                        <input type='text' size='2' name='pere_r_mth' class='whitenum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  ����ġ �뿩�� </td>
                    <td align='center'></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">�հ�</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_s_amt' maxlength='11' class='whitenum' >
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_v_amt' maxlength='10' class='whitenum' >
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='tot_pp_amt' maxlength='11' class='whitenum' >
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">�Աݿ����� : <%=AddUtil.ChangeDate2(fees.getPp_est_dt())%></td>
                    <td align='center'>&nbsp;
					<%	ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fees.getRent_st(), "5", "1");//�°������ ���� ��� ���� ��ȸ
						if(suc == null || suc.getRent_l_cd().equals("")){%>
					<%	}else{%>	
					�°������ �Աݿ��� : <%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "5")%>
					<%	}%>
					</td>
                </tr>
                <tr>
        	    <td class='title' colspan="2">��ä��Ȯ��</td>
                    <td colspan='3'>&nbsp;
                        ������ : <%=c_db.getNameById(fee_etcs.getCredit_sac_id(), "USER")%>
                  			&nbsp;&nbsp;&nbsp;&nbsp;
			                  �������� : <%=AddUtil.ChangeDate2(fee_etcs.getCredit_sac_dt())%>
                    </td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='whitenum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>��(������������)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='whitenum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='10' name='credit_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_amt())%>' readonly>��</td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>����<br>
                      �Ÿ�</td>              
                <td class='title' colspan="2"><span class="title1">��������Ÿ�</span></td>
                <td colspan="5">&nbsp;<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>km����/1��,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (�������Ͽ����) ȯ�޴뿩��  <%=AddUtil.parseDecimal(fee_etcs.getRtn_run_amt())%>��/1km (�ΰ�������)
                  <%if(fee_etcs.getRtn_run_amt_yn().equals("0")){%>��ȯ�޴뿩������<%}else if(fee_etcs.getRtn_run_amt_yn().equals("1")){%>��ȯ�޴뿩�������<%} %>
                  <%} %>  
                  <br>&nbsp;                
                  (�����ʰ������) �ʰ�����뿩�� <%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>��/1km (�ΰ�������)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  ���Կɼ� ���� ȯ�޴뿩�� : �⺻���� ������, �Ϲݽ��� 40%�� ����
                  <%} %>
                  <br>&nbsp;                                    
                  ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>�� ����
                  <!-- 
                  �ʰ� 1km�� (<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>��)�� �ʰ�����δ���� �ΰ��� (�뿩�����)	
                  <br>&nbsp;
                  ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� 50%�� ����
                   -->
                  <!-- 
                    <%if(fee_etcs.getAgree_dist_yn().equals("1")){%>���׸���(�⺻��)<%}%>
                    <%if(fee_etcs.getAgree_dist_yn().equals("2")){%>50%�� ����(�Ϲݽ�)<%}%>
                    <%if(fee_etcs.getAgree_dist_yn().equals("3")){%>���Կɼ� ����(�⺻��,�Ϲݽ�)<%}%>
                  -->
                  <!--
                  <br>&nbsp;�� ���� ����Ÿ� <%=AddUtil.parseDecimal(fee_etcs.getCust_est_km())%>km/1��
                  -->                  
                </td>
                <td align='center'>
                  <%if(AddUtil.parseInt(fees.getRent_dt()) > 20130604){
                  	e_bean = e_db.getEstimateCase(fee_etcs.getBc_est_id()); 
                  	String e_agree_dist_yn = "���Կɼ� ����(�⺻��,�Ϲݽ�)";
                  	if(e_bean.getOpt_chk().equals("1")){
                  		if(e_bean.getA_a().equals("12") || e_bean.getA_a().equals("22")){
                  			e_agree_dist_yn = "���׸���(�⺻��)";
                  		}else{
							if(AddUtil.parseInt(base.getRent_dt()) > 20220414){
								e_agree_dist_yn = "40%������(�Ϲݽ�)";
							}else{
								e_agree_dist_yn = "50%������(�Ϲݽ�)";
							}                  			
                  		}
                  	}
                  %>                    
                    <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                    <input type='text' name='e_rtn_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>' >/1km,<br>&nbsp;
                    <%} %>
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,<br>&nbsp;
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>
              </tr>   
                <tr>
                    <td class='title' style="font-size : 8pt;" colspan="2">����������Ÿ�</td>
                    <%if (f==1 && base.getCar_gu().equals("0")) {%>
                    <td colspan="4">&nbsp;<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>km (�縮�� ������ �뿩���� ����Ÿ�, ��༭ ���� ��)
                    </td>
                    <td colspan="2" align="center">
                    	�� �縮�� ������ �̵� :&nbsp;
                    	���&nbsp;-&nbsp;
                    	<%if (fee_etcs.getBr_from().equals("")) {%>�������̵�����<%}%>
                    	<%if (fee_etcs.getBr_from().equals("0")) {%>����<%}%>
                    	<%if (fee_etcs.getBr_from().equals("1")) {%>����<%}%>
                    	<%if (fee_etcs.getBr_from().equals("2")) {%>�뱸<%}%>
                    	<%if (fee_etcs.getBr_from().equals("3")) {%>����<%}%>
                    	<%if (fee_etcs.getBr_from().equals("4")) {%>�λ�<%}%>
                    	&nbsp;&nbsp;
                    	����&nbsp;-&nbsp;
                    	<%if (fee_etcs.getBr_to().equals("")) {%>�������̵�����<%}%>
                    	<%if (fee_etcs.getBr_to().equals("0")) {%>����<%}%>
                    	<%if (fee_etcs.getBr_to().equals("1")) {%>����<%}%>
                    	<%if (fee_etcs.getBr_to().equals("2")) {%>�뱸<%}%>
                    	<%if (fee_etcs.getBr_to().equals("3")) {%>����<%}%>
                    	<%if (fee_etcs.getBr_to().equals("4")) {%>�λ�<%}%>
                    </td>
                    <%} else {%>
                    <td colspan="6">&nbsp;<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>km (�縮�� ������ �뿩���� ����Ÿ�, ��༭ ���� ��)
                    <%}%>  
                    <input type="hidden" name="over_bas_km" value='<%=fee_etcs.getOver_bas_km()%>'>                  
                </tr>	                         
                <tr>
                    <td rowspan="4" class='title'>��<br>
                      ��</td>
                    <td class='title' colspan="2">ǥ�� �ִ��ܰ�</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='b_max_ja' maxlength='10' class='whitenum' value='<%=fees.getB_max_ja()%>'>
        			  % </td>
                    <td align='center'>                        
                        <input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' >km/1��                        
                    </td>
                </tr>                
                <tr>
                    <td class='title' colspan="2">���� �ִ��ܰ�</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' >
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ja_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' >
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' >
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='max_ja' maxlength='10' class='whitenum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'>
                                  <input type='text' name='r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >km/1��
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">���Կɼ�</td>
                    <td align="center"><input type='text' size='10' name='opt_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='opt_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='opt_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
                        <input type='text' size='4' name='opt_per' class='whitenum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)">
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_opt_per' class='whitenum' value='<%=fees.getF_opt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)">
    				            %  
        				    </td>
                    <td align='center'>
        			        <input type='radio' name="opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%>>
                      ����
                      <input type='radio' name="opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		        ����
                    </td>
                </tr>
                <%if(fee_etcs.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ���������� %>
                <tr>
                    <td class='title' colspan="2">�����ܰ�</td>
                    <td align="center"><input type='text' size='10' name='i_ja_r_s_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='i_ja_r_v_amt' readonly maxlength='10' class='whitenum' value='-' >
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='i_ja_r_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='i_app_ja' maxlength='10' readonly class="whitenum" value='-'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <input type="hidden" name="ja_r_s_amt" value='<%=fees.getJa_r_s_amt()%>'>
                <input type="hidden" name="ja_r_v_amt" value='<%=fees.getJa_r_v_amt()%>'>
                <input type="hidden" name="ja_r_amt" value='<%=fees.getJa_r_s_amt()+fees.getJa_r_v_amt()%>'>
                <input type="hidden" name="app_ja" value='<%=fees.getApp_ja()%>'>
                <%}else{%>
                <tr>
                    <td class='title' colspan="2">�����ܰ�</td>
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' >
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ja_r_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' >
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' >
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='app_ja' maxlength='10' class="whitenum" value='<%=fees.getApp_ja()%>' >
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>��<br>��<br>��</td>
                    <td class='title' colspan="2">�����</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' >
        				  ��</td>
                    <td align="center" ><input type='text' size='10'  name='fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' >
        				  ��</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' >
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>
					���뿩�ᳳ�Թ�� :
                              <%if(fees.getFee_chk().equals("0")){%>�ſ�����<%}%>
                              <%if(fees.getFee_chk().equals("1")){%>�Ͻÿϳ�<%}%>
					</td>
                </tr>
                <!-- �������߰����/�������(���Ǻ���) ���� (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">��<br>��<br>��<br>��<br>��</td>
                    <td class='title'>������</td>
                    <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' >
        				  ��</td>
                    <td align="center" ><input type='text' size='10' name='inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' >
        				  ��</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' >
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>&nbsp;
                            <%EstimateBean esti = e_db.getEstimateCase(fee_etcs.getBc_est_id()); 	%>
			                  <%if(!esti.getReg_code().equals("")){%>
			                  <%if(fee_etc.getBc_dlv_yn().equals("Y")){%>(����ϱ���)<%}%>
			                  &nbsp;&nbsp;
      			              <span class="b"><a href="javascript:estimates_view('<%=fees.getRent_st()%>', '<%=esti.getReg_code()%>')" onMouseOver="window.status=''; return true" title="������� ����"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>					                  
			                  <%}%>                    	
                    </td>
                </tr>
        		<tr>
	                <td class='title'>�������(���Ǻ���)</td>
	                <td align="center" ><input type='text' size='10' name='ins_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' >
        				  ��</td>
                    <td align="center" ><input type='text' size='10' name='ins_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' >
        				  ��</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='ins_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' >
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">&nbsp;�������(���ް�) = �Ⱓ�����
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' >    
					 ��/12</td>
                    <td align='center'>�ڵ������� ���� Ư�� ������<br>
                    	<a href="javascript:reqdoc('<%=fees.getRent_l_cd()%>','<%=fees.getRent_mng_id()%>','<%=fees.getRent_st()%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    </td>
              	</tr> 
               	<tr>
                    <td class='title'>�������߰����</td>
                    <td align="center">
                    	<input type='text' size='10' name='driver_add_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>' > �� 
                    </td>
                    <td align="center" >
                    	<input type='text' size='10' name='driver_add_v_amt'  maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center' >
                    	<input type='text' size='10' maxlength='10'  name='driver_add_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td class='title'>������ �հ�</td>
                    <td align="center">
                    	<input type='text' size='10' name='tinv_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etcs.getDriver_add_amt())%>'> �� 
                    </td>
                    <td align="center" >
                       	<input type='text' size='10' name='tinv_v_amt'  maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center' >
                    	<input type='text' size='10' maxlength='10'  name='tinv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
                
                <tr>
	                <td class='title' colspan="2">�뿩��DC</td>
	                <td colspan='3'>&nbsp; ������ : <%=c_db.getNameById(fee_etcs.getDc_ra_sac_id(), "USER")%>
			                &nbsp;&nbsp;&nbsp;&nbsp;�������� : 	<%=AddUtil.ChangeDate2(fees.getBas_dt())%></td>                    
	                <td align='center'>-</td>            
	                <td align="center">����ٰ� : 
	                        <%if(fee_etcs.getDc_ra_st().equals("1")){%>����DC����<%}%>
	                        <%if(fee_etcs.getDc_ra_st().equals("2")){%>Ư��DC<%}%>
	                    &nbsp;��Ÿ : <%=fee_etcs.getDc_ra_etc()%>
	                </td>
	                <td align='center'>
	                    DC�� <%=fees.getDc_ra()%>%
	                    DC�ݾ� <%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()+fees.getIns_s_amt()+fees.getIns_v_amt()+fee_etcs.getDriver_add_amt()+fee_etcs.getDriver_add_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>��
	                </td>
	            </tr>
                                    
				      <%		int fee_etc_rowspan = 1;
				      			if(fees.getRent_st().equals("1")) fee_etc_rowspan++;//�űԿ� ��������
				    				if(fees.getRent_st().equals("1") && cont_rent_st.equals("3")) fee_etc_rowspan++;//��������϶� ���������
				    				//�������߰�����߰�
		    						fee_etc_rowspan++;
							%>       
                <tr>
                    <td rowspan="<%=fee_etc_rowspan%>" class='title'>��<br>
                      Ÿ</td>                     
                    <td class='title' style="font-size : 8pt;" colspan="2">�ߵ�����������</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">�ܿ��Ⱓ �뿩���� <%=fees.getCls_r_per()%>%</td>
                    <td align='center'><font color="#FF0000"><%=fees.getCls_per()%>%, �ʿ��������[<%=fees.getCls_n_per()%>%]</font></span></td>
                </tr>
                
				        <%if(fees.getRent_st().equals("1")){%>
                <tr>
                    <td class='title' colspan="2">��������</td>
                    <td colspan="2" align="center">
        			        �������: ��������</td>
                    <td align='center'><input type='text' size='10' name='commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>'>��</td>
                    <td align='center'>-</td>
                    <td align="center"><input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum'>%</td>
                    <td align='center'><input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum'>%</td>
                </tr>
                <%}%>
                
                <tr>
                    <td class='title' colspan="2">�������߰����</td>
                    <td colspan="6">&nbsp;
                    	<input type='text' size='10' name='driver_add_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>'>
        				      �� (���ް�)</td>                  
                </tr>
                
				        <%if(fees.getRent_st().equals("1") && cont_rent_st.equals("3")){
										//�������������
										Hashtable suc_cont = new Hashtable();
										if(!cont_etc.getGrt_suc_l_cd().equals("")){
											suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
										}  
								%>                                  
                <tr>
                    <td class='title' style="font-size : 8pt;" colspan="2">���������</td>
                    <td colspan="6">&nbsp;
					            <b>[���������]</b>
					            &nbsp;����ȣ : <%=cont_etc.getGrt_suc_l_cd()%>
					            &nbsp;������ȣ : <%=cont_etc.getGrt_suc_c_no()%>
					            &nbsp;�����ڵ庰���� ���� : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					            <br>
					            &nbsp;
					            <b>[���������ݽ°�]</b>
					            &nbsp;���������� : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>��
					            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					            �°躸���� : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='whitenum' >��
					            <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  				<font color=red>(���������� ���� <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  			<%} %>	
					  			
					  			<%if(ck_acar_id.equals("000029") && fees.getGrt_amt_s()>0 && fees.getGrt_suc_yn().equals("1") && !cont_etc.getRent_suc_dt().equals("") && fees.getRent_st().equals(cont_etc.getSuc_rent_st()) && cont_etc.getGrt_suc_o_amt() >0) { %>
					  			&nbsp; ** ���°�� ������  ���� �Ա�
					  			<%} %>					            
        			      </td>
                </tr>
				        <%}%>
				        <%if(ej_bean.getJg_g_7().equals("3")){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ������ ���� %>
                <tr>
                    <td colspan="3" class='title'>������ �μ�/�ݳ� ����</td>
                    <td colspan="6">&nbsp;
                    	<select name='return_select' disabled>
                        <option value=''>����</option>
                        <option value='0' <%if(fee_etcs.getReturn_select().equals("0")){%>selected<%}%>>�μ�/�ݳ� ������</option>
                        <option value='1' <%if(fee_etcs.getReturn_select().equals("1")){%>selected<%}%>>�ݳ���</option>
                    	</select>
                    </td>
                </tr>
                <%}%>			     				        
                <tr>
                    <td colspan="3" class='title'>��༭ Ư����� ���� ����</td>
                    <td colspan="6">&nbsp;<%=fee_etcs.getCon_etc()%></td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
                    <td colspan="6">&nbsp;<%=fees.getFee_cdt()%></td>
                </tr>
                <%if(fee_etcs.getRent_st().equals("1")){%>
                <tr>
                    <td colspan="3" class='title'>���<br>(���� ����)</td>
                    <td colspan="6">&nbsp;<%=cont_etc.getCls_etc()%></td>
                </tr>
                <%}%>
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>����Ƚ��</td>
                    <td width="20%">&nbsp;<%=fees.getFee_pay_tm()%>ȸ </td>
                    <td width="10%" class='title'>��������</td>
                    <td width="20%">&nbsp;�ſ�
                      <select name='fee_est_day' disabled>
                        <option value="">����</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                        <option value='<%=i%>' <%if(fees.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                        <% } %>
                        <option value='99' <%if(fees.getFee_est_day().equals("99")){%> selected <%}%>> ���� </option>
						            <option value='98' <%if(fees.getFee_est_day().equals("98")){%> selected <%}%>> �뿩������ </option>
                      </select></td>
                    <td width="10%" class='title'>���ԱⰣ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%></td>
                </tr>
            </table>
	    </td>
    </tr>
    <%		if(acar_de.equals("1000")){ %>
	<input type='hidden' name="bc_s_a"	value="<%=fee_etcs.getBc_s_a()%>">
	<input type='hidden' name="bc_b_e1"	value="<%=fee_etcs.getBc_b_e1()%>">
	<input type='hidden' name="bc_b_e2"	value="<%=fee_etcs.getBc_b_e2()%>">
	<input type='hidden' name="bc_b_u"	value="<%=fee_etcs.getBc_b_u()%>">
	<input type='hidden' name="bc_b_g"	value="<%=fee_etcs.getBc_b_g()%>">
	<input type='hidden' name="bc_b_ac"	value="<%=fee_etcs.getBc_b_ac()%>">
	<input type='hidden' name="bc_etc"	value="<%=fee_etcs.getBc_etc()%>">
	<input type='hidden' name="bc_b_t"	value="<%=fee_etcs.getBc_b_t()%>">
	<input type='hidden' name="bc_b_u_cont"	value="<%=fee_etcs.getBc_b_u_cont()%>">
	<input type='hidden' name="bc_b_g_cont"	value="<%=fee_etcs.getBc_b_g_cont()%>">
	<input type='hidden' name="bc_b_ac_cont" value="<%=fee_etcs.getBc_b_ac_cont()%>">
	<%		}else{ %>	
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding='0' width=100%>
    		    <tr>
        		    <td class=line width="100%">
        			    <table border="0" cellspacing="1" cellpadding='0' width=100%>
            		        <tr>
            				  <td width="5%" class=title>��ȣ</td>
            				  <td width="10%" class=title>�ڵ�</td>				  
            				  <td width="35%" class=title>�̸�</td>
            				  <td width="50%" class=title>��</td>
            				</tr>
            		        <tr>
            				    <td align="center">E-1</td>
            				    <td align="center">bc_b_e1</td>				  
            				    <td>&nbsp;�������󰡴�����簡ġ����¼��ǱⰣ�ݿ���</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e1' maxlength='10' class=whitenum value='<%=fee_etcs.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		    <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;����忹��������</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e2' maxlength='10' class=whitenum value='<%=fee_etcs.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		    <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;��Ÿ���</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_u()%>' >&nbsp;����: <%=fee_etcs.getBc_b_u_cont()%></td>
            				</tr>							
            		    <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;��Ÿ����</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_g()%>' >&nbsp;����: <%=fee_etcs.getBc_b_g_cont()%></td>
            				</tr>
            		    <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;��Ÿ ����ȿ���ݿ���</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_ac()%>' >&nbsp;����: <%=fee_etcs.getBc_b_ac_cont()%></td>
            				</tr>
            		    <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_etc</td>				  
            				  <td>&nbsp;�������ǻ���</td>
            				  <td align="center"><%=fee_etcs.getBc_etc()%></td>
            				</tr>
            		    <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_b_t</td>				  
            				  <td>&nbsp;��ǰ���</td>
            				  <td align="center"><%=AddUtil.parseDecimal(fee_etcs.getBc_b_t())%></td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
    </tr>	
    <%		}%>		    
	<%	}%>

	
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('12','<%=fee_size%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	
	<%if(im_vt_size>0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǿ���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">����</td>
                    <td class=title width="20%">ȸ��</td>			
                    <td class=title width="37%">�뿩�Ⱓ</td>
                    <td class=title width="15%">�����</td>
                    <td class=title width="15%">�����</td>
                  </tr>
        		  <%	for(int i = 0 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=im_ht.get("ADD_TM")%>ȸ��</td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Թ��</span></td>
    </tr>	
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee2 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>

                <tr>
                    <td width="3%" rowspan="4" class='title'>��<br>��<br>��<br>��<br>��<br>��<br>��</td>				
                    <td width="10%" class='title'>���ݱ���</td>
                    <td width="20%">&nbsp;
                        <%if(fee.getFee_sh().equals("0")){%> �ĺ� <%}%>
                        <%if(fee.getFee_sh().equals("1")){%> ���� <%}%>
                    </td>
                    <td width="10%" class='title'>���ι��</td>
                    <td width="20%">&nbsp;
                        <%if(fee.getFee_pay_st().equals("1")){%> �ڵ���ü <%}%>
                        <%if(fee.getFee_pay_st().equals("2")){%> �������Ա� <%}%>
                        <%if(fee.getFee_pay_st().equals("4")){%> ���� <%}%>
                        <%if(fee.getFee_pay_st().equals("5")){%> ��Ÿ <%}%>
                        <%if(fee.getFee_pay_st().equals("6")){%> ī�� <%}%>
                    </td>
        			  <td width="10%" class='title'>CMS�̽���</td>
        			  <td>&nbsp;���� : <%=f_fee_etc.getCms_not_cau()%></td>
                </tr>
                <tr>
                    <td class='title'>��ġ����</td>
                    <td colspan="3">&nbsp;
                      <%if(fee.getDef_st().equals("N")){%> ���� <%}%>
                      <%if(fee.getDef_st().equals("Y")){%> ���� <%}%>
        			        ���� : <%=fee.getDef_remark()%></td>
                    <td class='title'>������</td>
                    <td>&nbsp;<%=c_db.getNameById(fee.getDef_sac_id(), "USER")%></td>
                </tr>
                  <tr>
                    <td class='title'>�ڵ���ü</td>
                    <td colspan="5"><table width="100%" border="0" cellpadding="0">
        			  <tr>
        			    <td>&nbsp;
						        ���¹�ȣ : <%=cms.getCms_acc_no()%>
        			      (����:<%=cms.getCms_bank()%>) </td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
						        �� �� �� : <%=cms.getCms_dep_nm()%>
        				  &nbsp;&nbsp;
        				  / �������� : �ſ� <%=cms.getCms_day()%>��</td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
					          ������ �������/����ڹ�ȣ : <%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>
    				        &nbsp;&nbsp;������ �ּ� : <%=cms.getCms_dep_post()%> <%=cms.getCms_dep_addr()%></td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
					          ������ȭ : <%=cms.getCms_tel()%>
    			      &nbsp;&nbsp;�޴��� : <%=cms.getCms_m_tel()%>
    			      &nbsp;&nbsp;�̸��� : <%=cms.getCms_email()%>
        				  </td>
        			    </tr>
        			</table>
        			</td>
                  </tr>
                <tr>
                    <td class='title'>�����Ա�</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(fee.getFee_bank(), "BANK")%></td>
                </tr>
            </table>
        </td>
    </tr>			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_tax style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>���޹޴���</td>
                    <td width="20%">&nbsp;
                      <input type="radio" name="tax_type" value="1" <% if(base.getTax_type().equals("1")) out.print("checked"); %>>
        			    ����
        		      <input type="radio" name="tax_type" value="2" <% if(base.getTax_type().equals("2")) out.print("checked"); %>>
        		    	���� </td>
                    <td width="10%" class='title' style="font-size : 8pt;">û�������ɹ��</td>
                    <td width="20%">&nbsp;
                        <% if(cont_etc.getRec_st().equals("1")) out.print("�̸���"); %>
                        <% if(cont_etc.getRec_st().equals("2")) out.print("����"); %>
                        <% if(cont_etc.getRec_st().equals("3")) out.print("���ɾ���"); %>
                    </td>
                    <td width="10%" class='title' style="font-size : 8pt;">���ڼ��ݰ�꼭</td>
                    <td>&nbsp;
                        <% if(cont_etc.getEle_tax_st().equals("1")) out.print("���ý���"); %>
                        <% if(cont_etc.getEle_tax_st().equals("2")) out.print("�����ý���"); %>
                        &nbsp;<%=cont_etc.getTax_extra()%>
        			</td>
                </tr>
			  <!--�ΰ���ȯ�������� �߰� �Ǿ��� ��쿡 �ΰ���ȯ������ ��꼭 ���� �߱ݿ� ���� ���´�.-->
			  <%	Hashtable tax_print_car = al_db.getTaxPrintCarStChk(base.getClient_id());
			  		if(AddUtil.parseInt(String.valueOf(tax_print_car.get("TOT_CNT")))>1 && client.getPrint_car_st().equals("") && !client.getPrint_st().equals("1") &&
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409") 
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
					   ){//'100','101','601','602','701','702','801','802','803','811','812'%>
			  <tr>
                <td width="13%" class='title'>��꼭�������౸��</td>			  
			    <td colspan='5'>&nbsp;
                    <%if(client.getPrint_car_st().equals("")) out.println("����");%>
                    <%if(client.getPrint_car_st().equals("1")) out.println("����/ȭ��/9�ν�/����");%>
				  <font color=red>* '<%=cm_bean.getCar_nm()%>' ������ �ΰ���ȯ�޴�� �����Դϴ�. �ΰ���ȯ���Ұ�� ��꺰�����౸���� [����/ȭ��/9�ν�/����]�� �����Ͻʽÿ�.</font>
				</td>	
			  </tr>
			  <%	}%>						
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('13','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������<%if(base.getRent_st().equals("3")){%>(�����Ī����)<%}%></span></td> 
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_tae1 style="display:<%if(!base.getCar_st().equals("2") && !base.getReject_car().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>�������������</td>
                    <td width="20%">&nbsp;
                      <input type='radio' name="prv_dlv_yn" value='N' <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                      ����
                      <input type='radio' name="prv_dlv_yn" value='Y' <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
        	 		        �ִ�
        		    </td>
                    <td width="10%" class=title style="font-size : 7pt;">�����Ⱓ���Կ���</td>
                    <td>&nbsp; &nbsp;
                      <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> >
                      ������
                      <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> >
        	 		        ����
        		    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_tae2 style="display:<%if(fee.getPrv_dlv_yn().equals("Y") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>������ȣ</td>
                    <td width="20%">&nbsp;<%=taecha.getCar_no()%></td>
                    <td width="10%" class='title'>����</td>
                    <td width="20%">&nbsp;<%=taecha.getCar_nm()%></td>
                    <td width="10%" class='title'>���ʵ����</td>
                    <td>&nbsp;<%=taecha.getInit_reg_dt()%></td>
                </tr>
                <tr>
                    <td class=title>�뿩������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
                    <td class='title'>�뿩������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
                    <td class='title'>�뿩�ἱ�Աݿ���</td>
                <td>&nbsp;
                	<%if(taecha.getF_req_yn().equals("Y")){%> ���Ա� <%}%>
                  <%if(taecha.getF_req_yn().equals("N")||taecha.getF_req_yn().equals("")){%> ���Ա� <%}%>
    	 		        </td>
                </tr>
                <tr>
                    <td class=title>���뿩��</td>
                    <td colspan='3' >&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>��(vat����)</td>
                    <td class=title>������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_inv())%>��(vat����)</td>
              </tr>
              <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              <%}else{%>
              <tr>
                    <td class=title >���������ÿ������</td>
                    <td colspan='5'> 
                      <%if(taecha.getRent_fee_st().equals("1")){%> ����Ʈ������                                      
                      <%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>
        			  ��(vat����)                 
        			  <%}%>
                      <%if(taecha.getRent_fee_st().equals("0")){%> �������� ǥ��Ǿ� ���� ����    <%}%>    	 		           
        			</td>
                </tr>	
              <%} %>  		
              <tr>
                <td class=title>û������</td>
                <td>&nbsp;
                    <% if(taecha.getReq_st().equals("1")) out.print("û��");%>
                    <% if(taecha.getReq_st().equals("0")) out.print("�������");%>
                </td>
                <td class='title' style="font-size : 8pt;">��꼭���࿩��</td>
                <td>&nbsp;
                    <% if(taecha.getTae_st().equals("1")) out.print("����");%>
                    <% if(taecha.getTae_st().equals("0")) out.print("�̹���");%>
                </td>
                <td class='title'>������</td>
                <td>&nbsp;<%=c_db.getNameById(taecha.getTae_sac_id(), "USER")%></td>
              </tr>
              <%if(!cont_etc.getGrt_suc_l_cd().equals("")){//�����Ī���� �̰������� ���� ������%>
              <tr>
                <td class='title'>�����Ī���� �̰�������<br>���� ������</td>
                <td colspan='5'>&nbsp;<%=c_db.getNameById(taecha.getEnd_rent_link_sac_id(), "USER")%></td>
              </tr>    
              <%} %>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('14','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	
	<%if(base.getCar_gu().equals("0") && base.getCar_st().equals("5")){%>
	<%}else{ %>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>�������<%}else if(base.getCar_gu().equals("2")){%>�߰�������<%}%>-�������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_bus style="display:<%if(!base.getCar_gu().equals("0") && !base.getCar_st().equals("2") && !base.getReject_car().equals("Y")){%>''<%}else{%>none<%}%>"> 		
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
                <td width="3%" rowspan="6" class='title'>��<br>
     			  ��</td>
                <td class='title'>��������</td>
                <td colspan='5'>&nbsp;
		              <input type='radio' name="pur_bus_st" value='1' <%if(pur.getPur_bus_st().equals("1")){%>checked<%}%>>
                  ��ü����
                  <input type='radio' name="pur_bus_st" value='2' <%if(pur.getPur_bus_st().equals("2")){%>checked<%}%>>
                  �����������
                   <input type='radio' name="pur_bus_st" value='4' <%if(pur.getPur_bus_st().equals("4")){%>checked<%}%>>
                  ������Ʈ
                   </td>		
				</tr>
				<tr id="dlv_con_commi_yn_tr">
					<td class='title'>��������� ���޿���</td>
					<td colspan="5" >&nbsp;
						<%-- <label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")||emp1.getDlv_con_commi() == 0){%>checked<%}%>> --%>
						<label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%>>
              			����</label>����
              			<%-- <label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")||emp1.getDlv_con_commi() > 0){%>checked<%}%>> --%>
              			<label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%>>
              			����</label>
              			
              			<%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>
	              		    &nbsp;&nbsp;
	              		    <select name='dir_pur_commi_yn'>
                          <option  value="">����</option>
                          <option value="Y" <%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>selected<%}%>>Ư�����(�����̰�����)</option>
                          <option value="N" <%if(cont_etc.getDir_pur_commi_yn().equals("N")){%>selected<%}%>>Ư�����(�����̰��Ұ���)</option>
                          <option value="2" <%if(cont_etc.getDir_pur_commi_yn().equals("2")){%>selected<%}%>>��ü���븮�����</option>
                        </select> 
	              		<%}%>
					</td>
				</tr>	            
                <tr>
                    <td width="10%" class='title'>�������</td>
                    <td width="20%" >&nbsp;<%=emp1.getEmp_nm()%></td>
                    <td width="10%" class='title'>��ȣ/�����Ҹ�</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%></td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;<%=emp1.getEmp_m_tel()%></td>
                </tr>
                <tr>
                    <td class='title'>�ҵ汸��</td>
                    <td >&nbsp;<%=emp1.getCust_st()%></td>
                    <td class='title'>�ִ��������</td>
                    <td>&nbsp;<%=emp1.getComm_rt()%>%</td>
                    <td class='title'>�����������</td>
                    <td>&nbsp;<%=emp1.getComm_r_rt()%>% <%=AddUtil.parseDecimal(emp1.getCommi())%>��</td>
                </tr>
                <tr>
                    <td class='title'>�������</td>
                    <td colspan="3" >&nbsp;<%=emp1.getCh_remark()%></td>
                    <td class='title'>������</td>
                    <td>&nbsp;<%=c_db.getNameById(emp1.getCh_sac_id(), "USER")%></td>
                </tr>
                <tr>
                    <td class='title'>�����</td>
                    <td >&nbsp;<%=emp1.getEmp_bank()%></td>
                    <td class='title'>���¹�ȣ</td>
                    <td>&nbsp;<%=emp1.getEmp_acc_no()%></td>
                    <td class='title'>�����ָ�</td>
                    <td>&nbsp;<%=emp1.getEmp_acc_nm()%></td>
                </tr>		  		  
            </table>
        </td>
    </tr>
    <%}%>
	<%}%>
	<%if(base.getCar_gu().equals("0") && base.getCar_st().equals("5")){%>
	<%}else{ %>	
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>�������-�����<%}else if(base.getCar_gu().equals("2")){%>�߰�������ó<%}%></span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_dlv style="display:<%if(!base.getCar_gu().equals("0") && !base.getReject_car().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                    <td width="3%" rowspan="<%if(base.getCar_gu().equals("1")){%>5<%}else if(base.getCar_gu().equals("2")){%>5<%}%>" class='title'>��<br>
                      ��</td>			  
                <td class='title'>�����</td>
                <td>&nbsp;
				          <input type='radio' name="one_self" value='Y' <%if(pur.getOne_self().equals("Y")){%>checked<%}%>>
        				  ��ü���
        		      <input type='radio' name="one_self" value='N' <%if(pur.getOne_self().equals("N")){%>checked<%}%>>
        				  ����������
    			      </td>
    		        <td class='title'>Ư�������</td>
                <td>&nbsp;
                  <input type='radio' name="dir_pur_yn" value='Y' <%if(pur.getDir_pur_yn().equals("Y")){%>checked<%}%>>
        				  Ư��
        	        <input type='radio' name="dir_pur_yn" value='' <%if(pur.getDir_pur_yn().equals("")){%>checked<%}%>>
        				  ��Ÿ(��ü)
    			      </td>
    		        <td class='title'>����û��</td>
                <td>&nbsp;<%=pur.getPur_req_dt()%>
                		&nbsp;
        		        <input type="checkbox" name="pur_req_yn" value="Y" <%if(pur.getPur_req_yn().equals("Y")){%>checked<%}%>>				  
        				    ����û�Ѵ�
    			      </td>
              </tr>
                <tr>
                    <td width="10%" class='title'>�����</td>
                    <td width="20%" >&nbsp;<%=emp2.getEmp_nm()%></td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;<%=emp2.getCar_off_nm()%></td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;<%=emp2.getEmp_m_tel()%></td>
                </tr>
    		  <%if(!base.getCar_gu().equals("2")){%>    		  
              <tr>
                <td class='title'>�����ȣ</td>
                <td >&nbsp;<%=pur.getRpt_no()%>
                	<%if(!cop_bean.getRent_l_cd().equals("")){%>
                	<br>&nbsp;<font color=red>
                	(������� <%=cop_bean.getCom_con_no()%>
                	
                	<%	if(cop_res_vt_size>0){
                			for (int i = 0 ; i < 1 ; i++) {
								Hashtable cop_res_ht = (Hashtable)cop_res_vt.elementAt(i);
					%>
					<%=cop_res_ht.get("FIRM_NM")%><%=cop_res_ht.get("CUST_Q")%>
					<%		}
						}
					%>
					
                	)
                	</font>
                	<%}%>
                </td>
                <td class='title'>�������</td>
                <td>&nbsp;<%=pur.getDlv_est_dt()%>&nbsp;<%=pur.getDlv_est_h()%>�� </td>
                <td class='title'>�������</td>
                <td>&nbsp;<%= AddUtil.ChangeDate2(base.getDlv_dt())%></td>
              </tr>              
    		  <%}else if(base.getCar_gu().equals("2")){%>
              <tr>
                <td class='title'>�Ÿ�����</td>
                <td >&nbsp;<%= AddUtil.ChangeDate2(base.getDlv_dt())%></td>
                <td class='title'>�Ÿűݾ�</td>
                <td colspan="3">&nbsp;<%=AddUtil.parseDecimal(pur.getTrf_amt1())%></td>
              </tr>
              <tr>
                <td class='title'>��������ȣ</td>
                <td >&nbsp;<%=pur.getRpt_no()%></td>
                <td class='title'>�����ȣ</td>
                <td colspan="3">&nbsp;<%=pur.getCar_num()%></td>
              </tr>
    		  <%}%>
    		  
               
              <tr>
                <td class='title'>����</td>
                <td colspan="5">&nbsp;
                	�ݾ� : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='whitenum' size='7' onBlur='javascript:this.value=parseDecimal(this.value);'>��
				     <%if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getCon_amt_pay_req().equals("")){%>
                	<a href="javascript:SendMsg('con_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                	<%	if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){ %>
                	<font color=red>�� �۱ݿ�û�� �ؾ� ��������մϴ�. ī��� ���� ����4�ÿ� �����մϴ�. ����4�� ���Ŀ��� ���� ��û�ϼ���. </font><br>
                	<%	}%>
                	<%}%>
                	<%if(pur.getCon_amt() > 0 && !pur.getCon_amt_pay_req().equals("")){%>
                	&nbsp;�۱ݿ�û(<%=pur.getCon_amt_pay_req()%>)
                	<%}%>	
                     &nbsp;
                     ���޼��� :
                     <select name="trf_st0"  disabled>
                        <option value="">==����==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>ī��</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>����</option>
        			  </select> 
                     &nbsp;
                    ������ :
					<select name='con_bank' disabled>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	�������� :
				  	<select name="acc_st0"  disabled>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>�������</option>
        			  </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='whitetext'>
					&nbsp;
					������ : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='15' class='whitetext'>
        			<br>
        			&nbsp;
        			���޿�û�� :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='whitetext' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        								  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;(����������:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <%}%>        			
        			
    			</td>															
              </tr>
    		  <%if(!base.getCar_gu().equals("2")){%>    	
              <tr>				
                <td class='title'>�ӽÿ��ຸ���</td>
                <td colspan='5'>&nbsp;
                  �ݾ� : 
				     <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='whitenum' size='7' onBlur='javascript:this.value=parseDecimal(this.value);'>��
				     <%if(pur.getTrf_amt5() > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_amt_pay_req().equals("")){%>
                	 <%	if(pur.getCon_amt() == 0 && pur.getCon_amt_pay_req().equals("")){%>
                		<a href="javascript:SendMsg('trf_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                	 <%	}%>
                	 <%}%>
                	 <%if(pur.getTrf_amt5() > 0 && !pur.getTrf_amt_pay_req().equals("")){%>
                	 &nbsp;�۱ݿ�û(<%=pur.getTrf_amt_pay_req()%>)
                	 <%}%>	
                     &nbsp;
                     ���޼��� :
                     <select name="trf_st5" disabled>
                        <option value="">==����==</option>
        				<option value="2" <%if(pur.getTrf_st5().equals("2")) out.println("selected");%>>����ī��</option>
        				<option value="3" <%if(pur.getTrf_st5().equals("3")) out.println("selected");%>>�ĺ�ī��</option>
        				<option value="1" <%if(pur.getTrf_st5().equals("1")) out.println("selected");%>>����</option>
        			  </select> 
                     &nbsp;
                    ������ :
					<select name='card_kind5'  disabled>
                        <option value=''>����</option>                        
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                              <option value='<%= bank.getNm()%>' <%if(pur.getCard_kind5().equals(bank.getNm())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        					}	%>	
                    </select>
				  	&nbsp;
				  	�������� :
				  	<select name="acc_st5" disabled>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getAcc_st5().equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(pur.getAcc_st5().equals("2")) out.println("selected");%>>�������</option>
        			  </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='cardno5' value='<%=pur.getCardno5()%>' size='20' class='whitetext'>
					&nbsp;
					������ : 
        			<input type='text' name='trf_cont5' value='<%=pur.getTrf_cont5()%>' size='15' class='whitetext'>
        			<br>
        			&nbsp;
        			���޿�û�� :
        			<input type='text' name='trf_est_dt5' value='<%= AddUtil.ChangeDate2(pur.getTrf_est_dt5())%>' class='whitetext' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>				    
    			</td>				
              </tr> 
    		  <%}%>                        
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('15','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<%if(base.getUse_yn().equals("") && !now_stat.equals("���°�") && !now_stat.equals("��������")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������İ���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=13%>�����Ȳ</td>
                    <td>&nbsp;<%=f_fee_etc.getBus_cau()%></td>
                </tr>
            </table>
        </td>
    </tr>				
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('16','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<%}%>
	
	<%}%>
		
	<%
		int scan_num = 0;
		String scan_mm = "";
		int scan_cnt = 0;
		int add_rent_mail_yn = 0;
	%>
	<%if(!base.getCar_st().equals("2")){%>
    <tr> 
        <td colspan="2"><a name="scan"><img src=/acar/images/center/icon_arrow.gif align=absmiddle></a> <span class=style2>�⺻��ĵ����
		  &nbsp;<a href ="javascript:view_scan()"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a></span>
		  &nbsp;<a href ="javascript:scan_all_reg()" title='��ĵ�ϰ����'><img src=/acar/images/center/button_reg_scan_ig.gif align=absmiddle border=0></a>
		  
		</td>
    </tr>
	<%	if(!client.getClient_st().equals("2")) scan_mm ="��ǥ�� ";%>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td colspan="2" class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="5%" class=title>����</td>
                  <td width="5%" class=title><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                  <td width="40%" class=title>����</td>                  
                  <td width="20%" class=title>��ĵ����</td>
                  <td width="20%" class=title>�������</td>
                  <td width="10%" class=title>����</td>		  
                </tr>
        	<%  
        	
                   	String file_st = "";
                   	String file_rent_st = "";
                   
                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
			String content_code = "LC_SCAN";
			String content_seq  = ""; 
			
			Vector attach_vt = new Vector();
			int attach_vt_size = 0;       
			
		 	String alink_scan_1_yn = "";
        	
        	
        	
        	%>
        		
		<!--������-->	
		<%	for(int f=1; f<=fee_size; f++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
				ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));%>	

        	
        	<%		if(!acar_de.equals("1000") && AddUtil.parseInt(fees.getRent_dt()) > 20140101 && f>1 && f==fee_size ){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">�ڵ����뿩�̿��༭(����)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">��������</td>
                  <td align="center">
                      <%if(now_stat.equals("����") && AddUtil.parseInt(fees.getRent_dt()) >= 20160101){%>
                   			<%-- <%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) < 20190514){ %> --%>
                        		<%-- ���Ǹ��� : <a href=javascript:go_edoc('lc_rent_link','3','<%=f%>','');><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a><br> --%>
                   			<%-- <%} %> --%>
                   			<%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) >= 20190514 || nm_db.getWorkAuthUser("������",ck_acar_id)){ %>
                        		<a href=javascript:go_edoc2('lc_rent_link','3','<%=f%>','');><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                        	<%} %>	
                      <%}%>
                  </td>		  
                </tr>	        	
        	<%		}%>
        	
        	
        	<%		if(AddUtil.parseInt(fees.getRent_dt()) > 20140101 && f==1 ){ //!base.getRent_st().equals("1") && %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">�ڵ����뿩�̿��༭(�ű�,����,����)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;<a href='https://fms3.amazoncar.co.kr/data/doc/privacy_agree.pdf' target="_blank"><img src=/acar/images/center/button_in_sj.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">��������</td>		  
                  <td align="center">
                      <%if(!acar_de.equals("1000") && !now_stat.equals("����") && !now_stat.equals("���°�") && AddUtil.parseInt(fees.getRent_dt()) >= 20160101){%>
                   			<%-- <%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) < 20190514){ %> --%>
                       			<%-- ���Ǹ��� : <a href=javascript:go_edoc('lc_rent_link','1','<%=f%>',''); title='���ڰ�༭ ����'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a><br> --%>
                       		<%-- <%} %> --%>
                       		<%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) >= 20190514 || nm_db.getWorkAuthUser("������",ck_acar_id)){ %>
                        		<a href=javascript:go_edoc2('lc_rent_link','1','<%=f%>',''); title='���ڰ�༭ ����'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                        	<%} %>	
                      <%}%>    
                      <%if(AddUtil.parseInt(base.getReg_dt()) >= 20200303 && user_id.equals("000284")){ //������Ʈ ������ ���%>
                        		<a href=javascript:go_edoc2('lc_rent_link','1','<%=f%>',''); title='���ڰ�༭ ����'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                      <%}%>              
                  </td>		  
                </tr>	        	
        	<%		}%>        	
        	
        	
        	
        	<%		if(now_stat.equals("���°�") && cont_etc.getSuc_rent_st().equals(String.valueOf(f)) && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > 20140101 ){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">�ڵ����뿩�̿��༭(���°�)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">��������</td>		  
                  <td align="center">
                      <%if(now_stat.equals("���°�") && AddUtil.parseInt(cont_etc.getRent_suc_dt()) >= 20160101){%>
                   			<%-- <%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) < 20190514){ %> --%>
                       			<%-- ���Ǹ��� : <a href=javascript:go_edoc('lc_rent_link','2','<%=f%>',''); title='���ڰ�༭ ����'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a><br> --%>
                       		<%-- <%} %> --%>
                       		<%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) >= 20190514 || nm_db.getWorkAuthUser("������",ck_acar_id)){ %>	
	                       		<a href=javascript:go_edoc2('lc_rent_link','2','<%=f%>',''); title='���ڰ�༭ ����'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
	                       	<%} %>
                      <%}%>                                    
                  </td>		  
                </tr>	        	
        	<%		}%>        	
        	

        	

		<%		if((now_stat.equals("���°�") && fee_etcs.getReg_dt().equals(base.getReg_dt())) || (now_stat.equals("��������") && fee_etcs.getReg_dt().equals(base.getReg_dt())) || (now_stat.equals("����") && fee_size==f)){//jpg%>
		
		<!--�����İ�༭(jpg)-->				
                <% 	scan_num++; 
                		content_seq = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"17";
                	  attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	  attach_vt_size = attach_vt.size();
                	  if(attach_vt_size > 0){
            				  for (int j = 0 ; j < 1 ; j++){
 					              Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
 					
 					              if(AddUtil.parseInt(fees.getRent_dt()) >= 20140101 && (String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg") || String.valueOf(ht.get("FILE_TYPE")).equals("image/pjpeg"))){
							            add_rent_mail_yn++; 
					              }                      	
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>�ű�<%}else{%><%=f-1%>�� ����<%}%> ��༭(��)-jpg����
			<%		if(now_stat.equals("���°�") && fee_etcs.getReg_dt().equals(base.getReg_dt())) 	out.println(" : ���°�");
				  	if(now_stat.equals("��������") && fee_etcs.getReg_dt().equals(base.getReg_dt()))	out.println(" : ��������");
						if(now_stat.equals("����") && fee_size==f)						out.println(" : ����");
		  	%>    
		  	
                    </td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>�ű�<%}else{%><%=f-1%>�� ����<%}%> ��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:scan_reg('17')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%><% scan_cnt++;%><font color=red>����</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="17">
                
		<!--�����İ�༭(jpg)-->				
                <% 	scan_num++; 
                		content_seq = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"18";
                  	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                  	attach_vt_size = attach_vt.size();
                  	if(attach_vt_size > 0){
				              for (int j = 0 ; j < 1 ; j++){
 					              Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
 					              if(AddUtil.parseInt(fees.getRent_dt()) >= 20140101 && (String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg") || String.valueOf(ht.get("FILE_TYPE")).equals("image/pjpeg"))){
							            add_rent_mail_yn++; 
					              }                      	
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>�ű�<%}else{%><%=f-1%>�� ����<%}%> ��༭(��)-jpg����
			              <%		if(now_stat.equals("���°�") && fee_etcs.getReg_dt().equals(base.getReg_dt())) 	out.println(" : ���°�");
				  	              if(now_stat.equals("��������") && fee_etcs.getReg_dt().equals(base.getReg_dt()))	out.println(" : ��������");
					                if(now_stat.equals("����") && fee_size==f)						out.println(" : ����");
		  	            %>    
                    </td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>�ű�<%}else{%><%=f-1%>�� ����<%}%> ��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:scan_reg('18')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%><% scan_cnt++;%><font color=red>����</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="18">
                

		<!--����(�ſ�)���� �������̿롤��������ȸ���Ǽ�-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"37";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�</td>
                    <td align="center"><a href="javascript:scan_reg('37')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%if(!base.getCar_st().equals("5")){%>
                    	<%	if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%>
			<%	//20140801���� �ʼ�
				if(AddUtil.parseInt(base.getReg_dt()) > 20140731 && fee_size == 1){
					if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){//���� ��ǥ�ڿ�������� ����
					}else{
						scan_cnt++;
						out.println("<font color=red>����</font>");
					}
				}				
			%>    
											<%	}%>                
											<%}%>                
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="37">    
                
                	
		<!--����(�ſ�)���� �������̿롤��������ȸ���Ǽ�(����������) - ����/���λ����-->		
		<%if(!client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"51";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�(����������)</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�(����������)</td>
                    <td align="center"><a href="javascript:scan_reg('51')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%if(!base.getCar_st().equals("5")){%>
                    	<%	if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%>
			<%	//20210601���� �ʼ�
				if(AddUtil.parseInt(base.getReg_dt()) > 20210601 && fee_size == 1){
						scan_cnt++;
						out.println("<font color=red>����</font>");
				}				
			%>    
											<%	}%>                
											<%}%>                
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="37">  
        <%	}%>                  
                	                	
                	
		<!--CMS���Ǽ�jpg-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"38";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	String cms_scan_yn = "";
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
 					            
 					            if(cms_scan_yn.equals("") && AddUtil.parseInt(String.valueOf(ht.get("FILE_SIZE"))) <= 300000  && (String.valueOf(ht.get("FILE_TYPE")).equals("image/tiff")||String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg")||String.valueOf(ht.get("FILE_TYPE")).equals("image/pjpeg"))){
 					            	cms_scan_yn = "Y";
 					            }
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS���Ǽ�tif/jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%>
<%	//20170801 �ʼ�
				if(AddUtil.parseInt(base.getReg_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("") && !cms_scan_yn.equals("Y")){ //�ڵ���ü
						scan_cnt++;
						out.println("<font color=red>����</font>");
						if(!cms_scan_yn.equals("Y")){ out.println("<font color=red>(�̹��������� �ƴϰų� 300kb �ʰ��Դϴ�.)</font>"); }
					}
				}				
			%>                       	
                    	</td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS���Ǽ�tif/jpg</td>
                    <td align="center"><a href="javascript:scan_reg('38')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%	if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%>
			<%	//20170801 �ʼ�
				if(AddUtil.parseInt(base.getReg_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("")){ //�ڵ���ü
						scan_cnt++;
						out.println("<font color=red>����</font>");
					}
				}				
			%>                 
											<%	}%>                
			       	
			                </td>
                    <td align="center"></td>
                </tr>      

                <%	}%>
                <input type='hidden' name="h_file_st" value="38">	
									
		<%		}else{%>
		
		<!--���ʰ�༭(pdf)-->			
                <% 	scan_num++; 
                		content_seq = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"1";
                	  attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	  attach_vt_size = attach_vt.size();
                	  if(attach_vt_size > 0){
				              for (int j = 0 ; j < 1 ; j++){
 					              Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 								        if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 && alink_count1>0 && !base.getCar_st().equals("5")){
 									        alink_scan_1_yn = "Y";
 								        }
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>�ű�<%}else{%><%=f-1%>�� ����<%}%> ��༭</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>�ű�<%}else{%><%=f-1%>�� ����<%}%> ��༭</td>
                    <td align="center"><a href="javascript:scan_reg('1')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 && alink_count1==0 && base.getCar_mng_id().equals("")){%><% scan_cnt++;%><font color=red>����</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="1">   
                		

		<%			if(f==1 && AddUtil.parseInt(fee_etcs.getReg_dt()) >= 20100501){%>
		
		<!--�뿩�����İ�༭(��)-jpg����-->			
                <% 	scan_num++; 
                    content_seq = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"17";
                  	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                  	attach_vt_size = attach_vt.size();
                	
                  	if(attach_vt_size > 0){
				              for (int j = 0 ; j < 1 ; j++){
 					              Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�뿩�����İ�༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�뿩�����İ�༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:scan_reg('17')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 && (alink_count1>0) && alink_scan_1_yn.equals("") && !base.getCar_mng_id().equals("")){%><% scan_cnt++;%><font color=red>����</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="17">   
                
		<!--�뿩�����İ�༭(��)-jpg����-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"18";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
             				for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�뿩�����İ�༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�뿩�����İ�༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:scan_reg('18')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 && (alink_count1>0) && alink_scan_1_yn.equals("") && !base.getCar_mng_id().equals("")){%><% scan_cnt++;%><font color=red>����</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="18">                   
                		
													
		<%			}%>
		
		<!--����(�ſ�)���� �������̿롤��������ȸ���Ǽ�-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"37";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�</td>
                    <td align="center"><a href="javascript:scan_reg('37')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%if(!base.getCar_st().equals("5")){%>
                    	<%	if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0){%>
			<%	//20140801���� �ʼ�
				if(AddUtil.parseInt(base.getReg_dt()) > 20140731 && fee_size == 1){
					if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){//���� ��ǥ�ڿ�������� ����
					}else{
						scan_cnt++;
						out.println("<font color=red>����</font>");
					}
				}				
			%>    
			               <%	}%>                
			               <%}%>                
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="37">
                
		<!--����(�ſ�)���� �������̿롤��������ȸ���Ǽ�(����������) - ����/���λ����-->		
		<%if(!client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"51";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�(����������)</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�(����������)</td>
                    <td align="center"><a href="javascript:scan_reg('51')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%if(!base.getCar_st().equals("5")){%>
                    	<%	if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0){%>
			<%	//20210601���� �ʼ�
				if(AddUtil.parseInt(base.getReg_dt()) >= 20210601 && fee_size == 1){
						scan_cnt++;
						out.println("<font color=red>����</font>");
				}				
			%>    
			               <%	}%>                
			               <%}%>               
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="37">  
        <%	}%>                      
                	
                	
		<!--CMS���Ǽ�jpg-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"38";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	String cms_scan_yn = "";
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
 					            
 					            if(cms_scan_yn.equals("") && AddUtil.parseInt(String.valueOf(ht.get("FILE_SIZE"))) <= 300000  && (String.valueOf(ht.get("FILE_TYPE")).equals("image/tiff")||String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg")||String.valueOf(ht.get("FILE_TYPE")).equals("image/pjpeg"))){
 					            	cms_scan_yn = "Y";
 					            }
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS���Ǽ�tif/jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%>
                    	<%	if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0){%>
<%	//20170801 �ʼ�
				if(AddUtil.parseInt(base.getReg_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("") && !cms_scan_yn.equals("Y")){ //�ڵ���ü
						scan_cnt++;
						out.println("<font color=red>����</font>");
						if(!cms_scan_yn.equals("Y")){ out.println("<font color=red>(�̹��������� �ƴϰų� 300kb �ʰ��Դϴ�.)</font>"); }
					}
				}				
			%>          
			               <%	}%>                			             	
                    	</td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS���Ǽ�tif/jpg</td>
                    <td align="center"><a href="javascript:scan_reg('38')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
			<%	//20170801 �ʼ�
				if(AddUtil.parseInt(base.getReg_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("")){ //�ڵ���ü
						scan_cnt++;
						out.println("<font color=red>����</font>");
					}
				}				
			%>                        	
			                </td>
                    <td align="center"></td>
                </tr>      

                <%	}%>
                <input type='hidden' name="h_file_st" value="38">
                		
		<%		}%>		
		<%	}//for end%>			
				
				


		<%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
		
		<!--��������������Ư�డ�Կ�û��-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"40";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "40", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">��������������Ư�డ�Կ�û��</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">��������������Ư�డ�Կ�û��</td>
                    <td align="center"><a href="javascript:scan_reg('40')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                        &nbsp;&nbsp;<a href='https://fms3.amazoncar.co.kr/data/doc/insdoc_comemp.pdf' target="_blank"><img src=/acar/images/center/button_in_carins_c.gif align="absmiddle" border="0"></a>
                    </td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="40">   				
			
		<%}%>	
		                
                                				
       		<tr>
 		    <td class=line2 colspan="6"></td>
		</tr>
				
		<%	if(!client.getClient_st().equals("2")){%>
		
		<!--����ڵ����jpg-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"2";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "2", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����ڵ����jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����ڵ����jpg</td>
                    <td align="center"><a href="javascript:scan_reg('2')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="2">    
                		
       		<%	}%>
        		
       		<%	if(scan_chk.equals("Y") && client.getClient_st().equals("1")){%>
       		
		<!--���ε��ε-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"3";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "3", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���ε��ε</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���ε��ε</td>
                    <td align="center"><a href="javascript:scan_reg('3')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="3">
                
		<!--�����ΰ�����-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"6";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "6", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�����ΰ�����</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�����ΰ�����</td>
                    <td align="center"><a href="javascript:scan_reg('6')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="6">
       		
       		<%	}%>
        		
       		<%	if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2") && cont_etc.getClient_share_st().equals("2")){%>
       		<%	}else{%>
       		<%		if(scan_chk.equals("Y")){%>
       		
		<!--<%=scan_mm%>�ź���jpg-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"4";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "4", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>�ź���jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>�ź���jpg</td>
                    <td align="center"><a href="javascript:scan_reg('4')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(!base.getCar_st().equals("5")){%><% scan_cnt++;%><font color=red>����</font><%}%></td>
                    <td align="center"></td>
                </tr>
                <%	}%>
                <input type='hidden' name="h_file_st" value="4">
                       		
		<!--<%=scan_mm%>�ֹε�ϵ-->
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"7";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "7", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>�ֹε�ϵ</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>�ֹε�ϵ</td>
                    <td align="center"><a href="javascript:scan_reg('7')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="7">     
                
		<!--<%=scan_mm%>�ΰ�����-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"8";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "8", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>�ΰ�����</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>�ΰ�����</td>
                    <td align="center"><a href="javascript:scan_reg('8')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="8">                                        		
       				        		
       		<%		}%>
       		<%	}%>
       		

                <%	//���뺸���� ���񼭷�-----------------------------------
        		if(cont_etc.getGuar_st().equals("1")){
		%>
		
		<!--���뺸����-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"14";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "14", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���뺸����</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���뺸����</td>
                    <td align="center"><a href="javascript:scan_reg('14')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="14">

		<!--����ڵ����/�ź���-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"11";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "11", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����ڵ����/�ź���</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����ڵ����/�ź���</td>
                    <td align="center"><a href="javascript:scan_reg('11')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>
                <%	}%>
                <input type='hidden' name="h_file_st" value="11">
                
		<!--���ε��ε/�ֹε�ϵ-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"12";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "12", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���ε��ε/�ֹε�ϵ</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���ε��ε/�ֹε�ϵ</td>
                    <td align="center"><a href="javascript:scan_reg('12')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="12"> 
                
		<!--�����ΰ�����/�ΰ�����-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"13";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "13", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�����ΰ�����/�ΰ�����</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�����ΰ�����/�ΰ�����</td>
                    <td align="center"><a href="javascript:scan_reg('13')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="13">
		
		
		<%	}%>	
		

		<!--����纻-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"9";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "9", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				          for (int j = 0 ; j < 1 ; j++){
 					          Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����纻</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����纻</td>
                    <td align="center"><a href="javascript:scan_reg('9')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
			<%
				//�ڵ���ü & �ű԰�� 
				if(fee.getFee_pay_st().equals("1") && base.getRent_st().equals("1") && fee_size == 1){
					scan_cnt++;
					out.println("<font color=red>����</font>");
				}				
			%>                    
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="9">
                
		<%if(ej_bean.getJg_g_7().equals("3")){%>                
		<!--������Ȯ�༭-->			
                <% 	scan_num++; 
                		content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"44";
	                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "44", 0);
  	              	attach_vt_size = attach_vt.size();
                	
    	            	if(attach_vt_size > 0){
											for (int j = 0 ; j < 1 ; j++){
 												Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">������Ȯ�༭</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">������Ȯ�༭</td>
                    <td align="center"><a href="javascript:scan_reg('44')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
								<%	//20200221 �������� ������ �ʿ����
									//if(ej_bean.getJg_g_7().equals("3") && car.getServ_sc_yn().equals("Y")){
									//			scan_cnt++;
									//			out.println("<font color=red>����</font>");
									//	}
								%>                    
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="44">                                  
		<%}%> 
		                
		<%if(cont_etc.getInsur_per().equals("2")){%>
		
		<!--���谡��Ư�༭-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"19";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "19", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���谡��Ư�༭</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���谡��Ư�༭</td>
                    <td align="center"><a href="javascript:scan_reg('19')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="19">
                
		<!--����û�༭-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"36";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "36", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����û�༭</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����û�༭</td>
                    <td align="center"><a href="javascript:scan_reg('36')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="36">  
                
		<!--���谡������-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"39";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "39", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���谡������</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���谡������</td>
                    <td align="center"><a href="javascript:scan_reg('39')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="39">
                
                <%}%>
			
		<%if(now_stat.equals("���°�")){%>
		
		<!--����������ΰ�����-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"20";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "20", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����������ΰ�����</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����������ΰ�����</td>
                    <td align="center"><a href="javascript:scan_reg('20')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>
                <%	}%>
                <input type='hidden' name="h_file_st" value="20">
                		
		<%}%>
		
		<!--�ɻ��ڷ�-->				
                <% 	scan_num++; 
                content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"49";
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "49", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�ɻ��ڷ�</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�ɻ��ڷ�</td>
                    <td align="center"><a href="javascript:scan_reg('49')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                       		
                <input type='hidden' name="h_file_st" value="49">    
                
		<!--����(�ſ�)���� ����.�̿�.����.��ȸ���Ǽ�jpg(�߰�������)-->	
		<%if(fee_etc.getDriver_add_amt()>0){ %>			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+fee_etc.getRent_st()+""+"52";
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "52", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� ����.�̿�.����.��ȸ���Ǽ�jpg(�߰�������)</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� ����.�̿�.����.��ȸ���Ǽ�jpg(�߰�������)</td>
                    <td align="center"><a href="javascript:scan_reg('52')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                       		
                <input type='hidden' name="h_file_st" value="52">        
                
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+fee_etc.getRent_st()+""+"32";
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "32", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�߰������ڿ���������</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�߰������ڿ���������</td>
                    <td align="center"><a href="javascript:scan_reg('32')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                       		
                <input type='hidden' name="h_file_st" value="32">                                  
        <%	}%>                   									
		
		<!--���ݰ�꼭-->				
                <%
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"10";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "10", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
 					            scan_num++; 
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">���ݰ�꼭</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}%>
                <%	}%>
                
		<!--�Ÿ��ֹ���-->				
                <%
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"15";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "15", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					            scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">�Ÿ��ֹ���</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>
                
		<!--�ӽÿ��ຸ��� ������-->				
                <%
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"26";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "26", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					            scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">�ӽÿ��ຸ��� ������<input type="hidden" name="temp_insur_receipt" value="<%=attach_vt_size%>"></td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>
                
                
                
		<!--�׿�-->		
                <% 	content_seq  = rent_mng_id+""+rent_l_cd;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
						for (int j = 0 ; j < attach_vt_size ; j++){
 							Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					
 							if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 20){ 						
 								file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 						
 							}
 					
 					if(file_st.equals("1")||file_st.equals("2")||file_st.equals("3")||file_st.equals("4")||file_st.equals("5")||file_st.equals("6")||file_st.equals("7")||file_st.equals("8")||file_st.equals("9")||file_st.equals("10")||file_st.equals("11")||file_st.equals("12")||file_st.equals("13")||file_st.equals("14")||file_st.equals("15")||file_st.equals("17")||file_st.equals("18")||file_st.equals("19")||file_st.equals("20")||file_st.equals("36")||file_st.equals("37")||file_st.equals("38")||file_st.equals("39")||file_st.equals("40")||file_st.equals("51")||file_st.equals("52")||(fee_etc.getDriver_add_amt()>0 && file_st.equals("32"))) continue;
 					
 					scan_num++;                             	
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center"><%=c_db.getNameByIdCode("0028", "", file_st)%></td> 
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>       
                                
		<!--��Ÿ-->				
                <% 	
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"5";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "5", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">��Ÿ</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>       				
						

        	<!--�߰�-->		
                <tr>
                  <td align="center"><%=scan_num+1%></td>  
                  <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>                
                  <td align="center">�߰�</td>                  
                  <td align="center"><a href="javascript:scan_reg('')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                  <td align="center">&nbsp;</td>
                  <td align="center"></td>		  
                </tr>                
        	
		
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2" align=right>
		  <span class="b"><a href="javascript:location.reload()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_reload.gif align=absmiddle border=0></a></span>
		  &nbsp;&nbsp;&nbsp;
		  <span class="b"><a href="javascript:scan_sys()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">[����ȭ]</a> (���� �ŷ�ó Ÿ��� ��ĵ���ϰ� ����ȭ))</span>		  
	</td>
    </tr>   
    
     
	<%for(int i=1; i<=20; i++){//�Է°� ����%>
	<tr id=tr_chk<%=i%> style='display:none'>
	    <td><input type='text' name="chk<%=i%>" value='' size="150" class='redtext'></td>
	</tr>	
	<%}%>
	
	<%for(int i=1; i<=20; i++){//������%>
	<tr id=tr_sanc<%=i%> style='display:none'>
	    <td><input type='text' name="sanc<%=i%>" value='' size="150" class='chktext'></td>
	</tr>	
	<%}%>	    
	
	
	<%}%>
	
    <%
	//��༭ �̸��Ϲ߼� ���� ����Ʈ
	Vector ime_vt =  ImEmailDb.getReNewInfoMailDocSendList(rent_l_cd+""+String.valueOf(fee_size));
	int ime_vt_size = ime_vt.size();
	
	if(!acar_de.equals("1000") && ime_vt_size>0){
    %>	 
    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����༭ ���ϰ���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">����</td>
                    <td class=title width="8%">�߼ۿ���</td>			
                    <td class=title width="8%">���ſ���</td>
                    <td class=title width="15%">�޴»��</td>
                    <td class=title width="15%">�߼��Ͻ�</td>
                    <td class=title width="41%">����</td>
                  </tr>
        	  <%	for(int i = 0 ; i < ime_vt_size ; i++){
        			Hashtable ime_ht = (Hashtable)ime_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ime_ht.get("ERRCODE_NM")%></td>
                    <td align='center'><%=ime_ht.get("OCNT_NM")%></td>
                    <td align='center'><%=ime_ht.get("EMAIL")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ime_ht.get("STIME")))%></td>
                    <td>&nbsp;<%=ime_ht.get("TO_TYPE")%>&nbsp;<%=ime_ht.get("SUBJECT2")%></td>
                  </tr>
        	  <%	} %>
            </table>
        </td>
    </tr>				
    <tr>
        <td class=h></td>
    </tr>		    
    <%	}%>
    

   	<%
					//���ڰ�༭�߼�
					int d_chk1 = alink_count1;
					//�����������Ϻ�
					int d_chk2 = 0;
					if(AddUtil.parseInt(AddUtil.getDate(5)) > AddUtil.parseInt(base.getReg_dt().substring(0,6))){
						d_chk2 = 1;
					}
					//��ü�������
					int d_chk3 = 0;
					if(!cop_bean.getRent_l_cd().equals("")){
						d_chk3 = d_chk3+1;
					}
					if(!String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null") && !String.valueOf(pur_com.get("USE_YN_ST")).equals("����")){
						d_chk3 = d_chk3+1;
					}
					
	%>			
    
	<%	if(!san_st.equals("��û") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>    	
    <%		String sanction_date = base.getSanction_date();
 	    	if(sanction_date.length() > 0) sanction_date = sanction_date.substring(0,8);
    %>
    <tr>
	    <td align='center'>                 

        <!-- �����༭ ���Ϻ����� -->
        <%	if(!acar_de.equals("1000") && now_stat.equals("����") && add_rent_mail_yn==2){%>
	        <a href=javascript:go_mail('newcar_doc','<%=fee_size%>');><img src=/acar/images/center/button_email_renew.gif border=0></a>
	        <br><br>
        <%	}%>
        
		<!-- ������� -->
        <%	if(AddUtil.parseInt(base.getRent_dt()) > AddUtil.parseInt(sanction_date)){%>
        <!--    ���°� ���� ó�� -->
        <%		if(!acar_de.equals("1000") && !nm_db.getWorkAuthUser("������",ck_acar_id) && now_stat.equals("���°�")){%>
            <a href="javascript:sanction();" title='�������ϱ�'><img src=/acar/images/center/button_gj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <!--    ������ ��û -->    		
        <%		}else{%>
            <a href="javascript:sanction_req();" title='������ ��û�ϱ�'><img src=/acar/images/center/button_gjyc.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <%		}%>
        <!--    ������ ��û -->
        <%		if(from_page.equals("/fms2/lc_rent/lc_b_frame.jsp") || from_page.equals("/agent/lc_rent/lc_b_frame.jsp")){%>
    	<%
					if(d_chk1+d_chk2+d_chk3 > 0 && !now_stat.equals("���°�") && !now_stat.equals("����") ){
						out.println("<br><br>�� ���ڰ�༭ �߼�("+d_chk1+")�� �Ǿ��ų�, ��� ���� ����Ϻ�("+d_chk2+")�̰ų�, ��ü������ ������("+d_chk3+")�Դϴ�. ������û�� �� �����ϴ�. ������ �Ϸ��� ������ ���������, �縮���� ���������� ����Ͻʽÿ�.<br><br>");	
					}else{
    		%>        
            <br><br>��������û���� : <input type='text' name="sanction_req_delete_cont" value='' size="100" class='text'>&nbsp;<a href="javascript:sanction_req_delete();" title='������ ��û�ϱ�'>[��������û �޽����߼�]</a><br><br>
            <!-- �� ���ڰ�༭ �߼��� �Ǿ��ų�, ��� ���� ����, ��ü������ �������� ������ �� �����ϴ�. -->
            <br> 
        <%			}%>
        <%		}%>
	    <%	}%>        

		<!-- �������� --> 		 
		<%	if(AddUtil.parseInt(base.getRent_dt()) > AddUtil.parseInt(sanction_date) && nm_db.getWorkAuthUser("������",ck_acar_id)){%>	    
	    	<a href="javascript:sanction();" title='�������ϱ�'><img src=/acar/images/center/button_gj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		<%		if(san_st.equals("��û")){%>
		    <br><br>�����û��һ��� : <input type='text' name="sanction_req_cancel_cont" value='' size="100" class='text'>&nbsp;<a href="javascript:sanction_req_cancel();" title='������û ����ϱ�'>[������û����ϱ�]</a><br><br>
		<%		}%>
		<%		if(base.getUse_yn().equals("Y") && !base.getCar_mng_id().equals("")){%>
            <a href="javascript:add_rent_esti_s();" class="btn" title='��������ϱ�'><img src=/acar/images/center/button_est_yj.gif align=absmiddle border=0></a>&nbsp;&nbsp;			
            <a href="javascript:sh_car_amt();" class="btn" title='�߰��������'><img src=/acar/images/center/button_fee_jg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <a href="javascript:view_settle('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='�����ϱ�'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>&nbsp;&nbsp;    
		<%		}%>
	    <%	}%>
	    <%	if(fee_size == 1 && sanction_date.length() > 0 && nm_db.getWorkAuthUser("������",ck_acar_id)){%>
            <a href="javascript:sanction_cancel();" title='������ ����ϱ�'><img src=/acar/images/center/button_cancel_gj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <%	}%>
		
	    <%	if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ຯ��",ck_acar_id)){%>
	    	<a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" title='��� �����ϱ�'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	    <%	}%>
	    
		<!-- ������ -->
	    <%	if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
	    <%    	Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", rent_st, "", "", rent_mng_id, rent_l_cd, base.getCar_mng_id(), "", "");
				int fee_scd_size = fee_scd.size();
	            if(base.getUse_yn().equals("")){
	            	if(fee_scd_size == 0){ //�뿩�ὺ���ٻ������� Ȯ��
	            		
	            		if(d_chk1+d_chk2+d_chk3 > 0 && !now_stat.equals("���°�") && !now_stat.equals("����") ){
	    %>
	        <br>�� ��������� �ȵ˴ϴ�.<br>
	    <% 				}else{%>
	    	<a href="javascript:rent_delete();" title='��� �����ϱ�'>[����]</a>&nbsp;&nbsp;
	    	<%				if(base.getCar_gu().equals("1") && base.getClient_id().equals("000228") && base.getReg_step().equals("1")){ //�����Ƹ���ī1�ܰ�%>
	    	<a href="javascript:rent_stat_delete();" title='��� �����ϱ�'>[�̻��ó��]</a>&nbsp;&nbsp;
	    	<%				} %>
        <%					if(now_stat.equals("���°�")){%> 
	        <select name='suc_rent_delete_yn'>
                <option value="0">����ó��(���°����)</option>
                <option value="1">���Ǹ� ó��(�ߺ��ǻ���)</option>
            </select>&nbsp;&nbsp;	
	    <%					}%>
	    <%				}%>
	    <%			}else{%>
	        <br>�� �������� �ֽ��ϴ�. û���� �� �������� �����ϰ� ó���Ͻʽÿ�.<br>
	    <%			}%>
	    <%		}%>
	    <%		if(base.getUse_yn().equals("N")){%>
	        <a href="javascript:rent_delete_recar();" title='��������� ������ �����ϱ�'>[������ ����]</a>&nbsp;&nbsp;
	    <%		}%>
	    <%		if(base.getUse_yn().equals("Y") && !fee_etc.getRent_st().equals("1") && now_stat.equals("����")){
					if(fee_scd_size == 0){
	    %>
	        <a href="javascript:rent_delete_ext();" title='������ �����ϱ�'>[�������(<%=fee_etc.getRent_st()%>)]</a>&nbsp;&nbsp;
	    <%			}else{%>
	        <br>�� ����뿩�� �������� �ֽ��ϴ�. û���� �� �������� �����ϰ� ó���Ͻʽÿ�.(<%=fee_etc.getRent_st()%>)<br>
	    <%			}%>
	    <%		}%>
	    <%	}%>		
		
        </td>
    </tr>   
     
    <tr>
	<td></td>
    </tr>		
    <tr>
        <td align='right'>
	  <%if( nm_db.getWorkAuthUser("������",ck_acar_id) || ((base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("������Ʈ����",ck_acar_id)) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("1")) ){%>	  
	    <a href="lc_reg_step2.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp; 
          <%}%>	
	  <%if( nm_db.getWorkAuthUser("������",ck_acar_id) || ((base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("������Ʈ����",ck_acar_id)) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("2")) ){%>	  
	    <a href="lc_reg_step3.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_3step.gif align=absmiddle border=0></a>&nbsp;	  
          <%}%>	
	  <%if( nm_db.getWorkAuthUser("������",ck_acar_id) || ((base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("������Ʈ����",ck_acar_id)) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("3")) ){%>	  
	    <%if(base.getCar_st().equals("4")){%>
	        <a href="lc_reg_step4_rm.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
	    <%}else{%>
	        <a href="lc_reg_step4.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
	    <%}%>
          <%}%>	
          <%if(nm_db.getWorkAuthUser("������",ck_acar_id)){%>            
            <a href="lc_c_frame.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>	  	   
          <%}%>	
	</td>	
    </tr>	
    <%	}%>
    
    <%if(!acar_de.equals("1000") && !fee_etc.getBc_est_id().equals("")){%>	
    <tr>
	<td>&nbsp;</td>
    </tr>			
    <tr>
	<td align="center">
		<a href="javascript:view_sale_cost_lw()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_p_yumg.gif border=0 align=absmiddle></a>
		<%if(String.valueOf(cost_cmp.get("RENT_L_CD")).equals("") || String.valueOf(cost_cmp.get("RENT_L_CD")).equals("null")){%>
		<%}else{%>
		<a href="javascript:view_sale_cost_lw_base()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_see_yuhy.gif border=0 align=absmiddle></a>
		<%}%>
		<%if(!String.valueOf(t_cost_cmp.get("RENT_L_CD")).equals("") && !String.valueOf(t_cost_cmp.get("RENT_L_CD")).equals("null")){%>
		<a href="javascript:view_sale_cost_lw_add()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_p_yuhy.gif border=0 align=absmiddle></a>		
		<%}%>	
		<%if(base.getCar_st().equals("4") && !String.valueOf(rm_cost_cmp.get("RENT_L_CD")).equals("") && !String.valueOf(rm_cost_cmp.get("RENT_L_CD")).equals("null")){%>
		<a href="javascript:view_sale_cost_lw_add()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_p_yuhy.gif border=0 align=absmiddle>(����Ʈ)</a>		
		<%}%>	
		/ cost_cmp <%=String.valueOf(cost_cmp.get("RENT_L_CD"))%>
		/ t_cost_cmp <%=String.valueOf(t_cost_cmp.get("RENT_L_CD"))%>
		/ rm_cost_cmp <%=String.valueOf(rm_cost_cmp.get("RENT_L_CD"))%>
	</td>
    </tr>			
    <%}%>	  
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--

	var fm = document.form1;

	sum_car_c_amt();
	sum_car_f_amt();
	
	<%if(!base.getCar_st().equals("2")){%>
		
	fm.scan_cnt.value = <%=scan_cnt%>;
	
	cont_chk();
	
	function cont_chk(){

		if(<%=fee_etc.getReg_dt()%> >= 20100501 && toInt(fm.scan_cnt.value) > 0){
			fm.chk1.value = '* �̵�� ��ĵ�� <%=scan_cnt%>�� �ֽ��ϴ�. --> ���� ������ �������� �ʽ��ϴ�.';
			<%if(client.getFirm_type().equals("7")){%>
			fm.chk1.value = fm.chk1.value + ' -> ������ü��ü�� ���� �ٸ� ������ ��ü�ؼ� ��ĵ����Ͻʽÿ�.';
			<%}%>
			tr_chk1.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
		//�縮�� �ִ밳���� Ȯ��
		if(<%=base.getRent_dt()%> > 20211101 && '<%=max_over_yn%>'=='Y' && '<%=base.getCar_st()%>'!='5'){
			fm.chk18.value = '* �縮�� ���Ⱓ�� �ִ밳���� <%=max_use_mon%>������ ����մϴ�.  --> ���� ������ �������� �ʽ��ϴ�.';
			tr_chk18.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		//�縮�� �ִ밳���� Ȯ��
		if(<%=base.getRent_dt()%> > 20211101 && '<%=max_over_yn%>'=='' && <%=max_use_mon%> > 0 && '<%=user_id%>'=='000029' && '<%=base.getCar_st()%>'!='5'){
			fm.sanc1.value = '* �縮�� �ִ밳������ <%=max_use_mon%>���� �Դϴ�.';
			tr_sanc1.style.display = '';			
		}
		
		//������ �Է°� Ȯ��
		if(<%=base.getRent_dt()%> > 20070831){
			<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
			if('<%=base.getDriving_age()%>'=='1' && '<%=ins.getAge_scp()%>'!='1'){
				fm.sanc7.value = '* ���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
				tr_sanc7.style.display = '';
			}
			if('<%=base.getDriving_age()%>'=='3' && '<%=ins.getAge_scp()%>'!='4'){
				fm.sanc7.value = '* ���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
				tr_sanc7.style.display = '';
			}
			if('<%=base.getDriving_age()%>'=='0' && '<%=ins.getAge_scp()%>'!='2'){
				fm.sanc7.value = '* ���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
				tr_sanc7.style.display = '';
			}
			if('<%=base.getDriving_age()%>'=='2' && '<%=ins.getAge_scp()%>'!='3'){
				fm.sanc7.value = '* ���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
				tr_sanc7.style.display = '';
			}
			if('<%=base.getGcp_kd()%>'=='2' && '<%=ins.getVins_gcp_kd()%>'!='3'){
				fm.sanc8.value = '* ���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
				tr_sanc8.style.display = '';
			}
			if('<%=base.getGcp_kd()%>'=='1' && '<%=ins.getVins_gcp_kd()%>'!='4'){
				fm.sanc8.value = '* ���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
				tr_sanc8.style.display = '';
			}
			if('<%=base.getBacdt_kd()%>'=='2' && '<%=ins.getVins_bacdt_kd()%>'!='6'){
				fm.sanc9.value = '* ���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
				tr_sanc9.style.display = '';
			}
			if('<%=base.getBacdt_kd()%>'=='1' && '<%=ins.getVins_bacdt_kd()%>'!='5'){
				fm.sanc9.value = '* ���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
				tr_sanc9.style.display = '';
			}
			<%}%>
		}
		
		<%if(String.valueOf(begin.get("CLS_ST")).equals("���°�") || String.valueOf(begin.get("CLS_ST")).equals("��������")){%>
		//�ʼ��̷� üũ
		if(<%=base.getRent_dt()%> > 20150201){
			if('<%=max_gins.getGi_st()%>' == '1' && ( '<%=max_gins.getGi_jijum()%>' == '' || '<%=max_gins.getGi_amt()%>' == '0' )){
				fm.chk2.value = '* �������� �����̳� ���������� �����ϴ�.';
				tr_chk2.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			if('<%=fee.getFee_pay_st()%>' == '1'){
				if('<%=cms.getCms_bank()%>' == '' || '<%=cms.getCms_acc_no()%>' == '' || '<%=cms.getCms_dep_nm()%>' == '' || '<%=cms.getCms_dep_ssn()%>' == ''	){
					fm.chk8.value = '* �ڵ���ü�ε� ���������� �����ϴ�. ����,����,�����ָ�,������ �������/����ڹ�ȣ�� Ȯ���ϼ���';
					tr_chk8.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
			}
		}
		<%}else{%>
		//�ʼ��̷� üũ
		if(<%=base.getRent_dt()%> > 20070831){
			<%if(!base.getCar_st().equals("5")){%>
				<%	if(fee_size==1){%>
					if('<%=client.getClient_st()%>' == '1' && '<%=cont_etc.getClient_guar_st()%>' == ''){
						fm.chk2.value = '* ��ǥ�̻纸�� ������ �����ϴ�.';
						tr_chk2.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					if('<%=client.getClient_st()%>' == '1' && '<%=cont_etc.getClient_guar_st()%>'=='2' && ('<%=cont_etc.getGuar_con()%>' == '' || '<%=cont_etc.getGuar_sac_id()%>' == '')){
						fm.chk2.value = '* ��ǥ�̻纸�� �������� �� �����ڰ� �����ϴ�.';
						tr_chk2.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					if('<%=cont_etc.getGuar_st()%>' == ''){
						fm.chk3.value = '* ���뺸���� ������ �����ϴ�.';
						tr_chk3.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					var imm_amt = <%if(base.getCar_st().equals("5")){%>100000<%}else{%><%if(car.getCar_origin().equals("2")){%>500000<%}else{%>300000<%}%><%}%>;
					<%if(ej_bean.getJg_w().equals("1")){//������%>
						if('<%=base.getCar_ja()%>' != imm_amt && ('<%=cont_etc.getJa_reason()%>' == '' || '<%=cont_etc.getRea_appr_id()%>' == '')){
								fm.chk6.value = '* ������å�� ������� �Ǵ� �����ڰ� �����ϴ�.';
								tr_chk6.style.display = '';
								fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
						}						
					<%}else{%>
						if('<%=base.getCar_ja()%>' != '300000' && '<%=base.getCar_ja()%>' != '200000'<%if(base.getCar_st().equals("3")){%> && '<%=base.getCar_ja()%>' != '100000'<%}%>){
							if('<%=base.getCar_ja()%>' != imm_amt && ('<%=cont_etc.getJa_reason()%>' == '' || '<%=cont_etc.getRea_appr_id()%>' == '')){
								fm.chk6.value = '* ������å�� ������� �Ǵ� �����ڰ� �����ϴ�.';
								tr_chk6.style.display = '';
								fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
							}
						}
					<%}%>
				<%	}%>
				
				if('<%=fee_etc.getCredit_sac_id()%>' == ''){
					fm.chk9.value = '* ä��Ȯ�� �����ڰ� �����ϴ�.';
					tr_chk9.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				<%	if(fee_size==1){%>
					if('<%=fee.getDef_st()%>' == 'Y' && ('<%=fee.getDef_remark()%>' == '' || '<%=fee.getDef_sac_id()%>' == '')){
						fm.chk10.value = '* ��ġ���ΰ� ������ ��ġ���� �Ǵ� ��ġ �����ڰ�  �����ϴ�.';
						tr_chk10.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					if('<%=fee.getPrv_dlv_yn()%>' == 'Y' && '<%=taecha.getTae_sac_id()%>' == ''){
						fm.chk12.value = '* ��������� �����ڰ� �����ϴ�.';
						tr_chk12.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
				<%	}%>
            
            	<%if(fee_size ==1 && base.getCar_gu().equals("0")){%>
					//����������������Ÿ�                   
            		var over_bas_km = toInt(parseDigit(fm.over_bas_km.value));
            		if(over_bas_km == 0){
	            		fm.sanc10.value = '* �縮�� ������ ������ ����Ÿ��� �����ϴ�.';
	            		tr_sanc10.style.display = '';
	            		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;                              
            		}
            	<%}%>
            
				if('<%=max_fee.getOpt_chk()%>' == ''){
					fm.chk7.value = '* ���Կɼ� ������ �����ϴ�.';
					tr_chk7.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				if('<%=max_fee.getOpt_chk()%>' == '1' && ('<%=max_fee.getOpt_per()%>' == '' || '<%=max_fee.getOpt_s_amt()%>'==0) && fm.rent_l_cd.value != 'S111HHGR00245'){
					fm.chk7.value = '* ���Կɼ��� �Ǵ� ���ԿɼǱݾ��� �����ϴ�.';
					tr_chk7.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
			
				if('<%=max_fee.getFee_s_amt()%>'=='0' && '<%=max_fee.getPp_s_amt()+max_fee.getGrt_amt_s()+max_fee.getIfee_s_amt()%>'=='0'){
					fm.chk17.value = '* �����ݰ� �뿩�� ������� �����ϴ�.';
					tr_chk17.style.display = '';					
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				if('<%=fee.getFee_pay_st()%>' == '1' && ('<%=cms.getCms_bank()%>' == '' || '<%=cms.getCms_acc_no()%>' == '' || '<%=cms.getCms_dep_nm()%>' == '' || '<%=cms.getCms_dep_ssn()%>' == '') ){
					fm.chk8.value = '* �ڵ���ü�ε� ���������� �����ϴ�. ����,����,�����ָ�,������ �������/����ڹ�ȣ�� Ȯ���ϼ���';
					tr_chk8.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				if('<%=base.getBus_id2()%>' == ''){
					fm.chk5.value = '* ��������ڰ� �����ϴ�.';
					tr_chk5.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				if(<%=client_tel_cnt%> < 2 ){
					fm.chk15.value = '* �� ����ó�� �ߺ����� �ʴ� ��ȣ�� 2�� �̻��̿��� �մϴ�.<%if(client.getClient_st().equals("1")){%>(���ΰ�:ȸ����ȭ,��ǥ���޴���,�����̿����޴���)<%}else if(client.getClient_st().equals("2")){%>(���ΰ�:���޴���,������ȭ,������ȭ)<%}else{%>(���λ����:ȸ����ȭ,��ǥ���޴���,������ȭ,�����̿����޴���)<%}%>';
					tr_chk15.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}		
				<%if(fee_size ==1 && base.getCar_gu().equals("1")){%>
					//������� �������� üũ
					if('<%=pur.getPur_bus_st()%>' == ''){
						fm.chk12.value = '* ������� ���������� �����ϴ�.';
						tr_chk12.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					//����� ����� üũ
					if('<%=pur.getOne_self()%>' == ''){
						fm.chk13.value = '* ����� ������� �����ϴ�.';
						tr_chk13.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
				<%}%>
			<%}%>
		}
		<%}%>
		
		
		if(fm.est_area.value == ''){
			fm.chk4.value = '* �����̿������� �����ϴ�.';
			tr_chk4.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
		if(<%=base.getCar_ja()%> == 0){
			fm.chk6.value = '* ������å���� �����ϴ�.';
			tr_chk6.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		<%if(!base.getCar_st().equals("5")){%>
		if('<%=max_fee.getCls_r_per()%>' == ''){
			fm.chk8.value = '* �ߵ������������� �����ϴ�.';
			tr_chk8.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		<%}%>
		if('<%=cont_etc.getRec_st()%>' == ''){
			fm.chk11.value = '* ���ݰ�꼭 û���� ���ɹ���� �����ϴ�.';
			tr_chk11.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		<%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){
				Hashtable ext0 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, max_fee.getRent_st(), "0");
   			int pp_amt0 	= AddUtil.parseInt(String.valueOf(ext0.get("EXT_S_AMT")));
   			int pp_pay_amt0 = AddUtil.parseInt(String.valueOf(ext0.get("PAY_AMT")));
				if((pp_amt0-pp_pay_amt0) > 0){%>
					fm.chk8.value = '* ���°� �������� �ԱݿϷ���� �ʾҽ��ϴ�.';
					tr_chk8.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		<%	}
		}%>
		
		<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("N")){%>
    	<%	if(cont_etc.getCom_emp_sac_id().equals("")){%>
		fm.chk16.value = '* ���ΰ��� ��������������Ư���� �̰����Դϴ�. ����ó���Ͻʽÿ�.';
		tr_chk16.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
    	<%	}else{%>
    	<%		if(base.getOthers().equals("")){%>	
		fm.chk16.value = '* ���ΰ��� ��������������Ư���� �̰����Դϴ�. �̰��Ի����� �������-��� �Է��Ͻʽÿ�.';
		tr_chk16.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;    	
  		<%		}%>	
  		<%	}%>
    	<%}%>
    	
    	<%if(!client.getClient_st().equals("1") && !client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("Y")){%>
    	<%	if(cont_etc.getCom_emp_sac_id().equals("")){%>
		fm.chk16.value = '* ���Ի���� ���� ��������������Ư���� �����Դϴ�. ����ó���Ͻʽÿ�.';
		tr_chk16.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
    	<%	}else{%>
    	<%		if(base.getOthers().equals("")){%>	
		fm.chk16.value = '* ���Ի���� ���� ��������������Ư���� �����Դϴ�. ���Ի����� �������-��� �Է��Ͻʽÿ�.';
		tr_chk16.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;    	
  		<%		}%>	
  		<%	}%>
    	<%}%>
    
		<%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("")){%>
		fm.chk16.value = '* ���ΰ��� ��������������Ư���� ���Կ��ΰ� �����ϴ�.';
		tr_chk16.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
    	<%}%>
	
	}
	
	<%}%>
	
	<%if(base.getCar_gu().equals("1")){%>
	//������ �ε� �� ��������� ���޿��� �ʱ�ȭ						2017. 12. 05
	//DB���� ���� �������� ����ϴ� ������ ����(�Ϻμҽ� ����)		2017. 12. 13
	//document.addEventListener("DOMContentLoaded", function(){
	$(document).ready(function(){
		var pur_bus_st_chk = $("input[name=pur_bus_st]").is(":checked");
		var pur_bus_st_val = $("input[name=pur_bus_st]:checked").val();					// ��������
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		
		$("#dlv_con_commi_yn_tr").hide();																	// ��������� ���޿��� -> �ʵ� �����
		if(pur_bus_st_chk){
			if(pur_bus_st_val == "1"){
			}else if(pur_bus_st_val == "2" || pur_bus_st_val == "4"){							// �������� -> �����������, ������Ʈ
				$("#dlv_con_commi_yn_tr").show();														// ��������� ���޿��� -> �ʵ� �����ֱ�
			}	
		}else {		// �������� ������ �ȵ��ִ� ��� ��������� ���޿��θ� �����ش� 2017.12.18
			$("#dlv_con_commi_yn_tr").show();
		}
	});	
	<%}%>
	
	
	//�ٷΰ���
	var s_fm 	= parent.top_menu.document.form1;
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";
//-->
</script>
</body>
</html>
