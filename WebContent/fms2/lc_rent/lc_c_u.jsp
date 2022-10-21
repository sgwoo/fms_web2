<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.con_ins.*, acar.consignment.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase"      scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean"             scope="page"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
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
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
		
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�ڵ����⺻����-�⺻����
	CarMstBean cm_bean2 = cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//��������
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}	
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	ContFeeBean feeb = new ContFeeBean();
	int fee_opt_amt = 0;
	
	if(!rent_st.equals("1")){
		feeb = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(AddUtil.parseInt(rent_st)-1));
		fee_opt_amt = feeb.getOpt_s_amt()+feeb.getOpt_v_amt();
	}
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));	
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//�ſ�ī�� �ڵ����
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
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
	
	if(cont_etc.getGuar_st().equals("2")) gur_size = 0;
	
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
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();		
		
	//������ �����
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	
	
	//����ǰ��
	DocSettleBean commi_doc = d_db.getDocSettleCommi("1", rent_l_cd);
	
	DocSettleBean doc4 = d_db.getDocSettleCommi("4", rent_l_cd);
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);	
	
	//Ư�ǰ������
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);		
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	
	//�����Ҹ���Ʈ
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
  //�����������
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;	

  //�����������
  CodeBean[] code35 = c_db.getCodeAll3("0035");
  int code35_size = code35.length;	
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");

	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();

	String a_a = "";
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";
	//���뺯��
	em_bean = edb.getEstiCommVarCase(a_a, "");
		

	String o_3 		= edb.getEstiSikVarCase("1", "", "o_3");
	
		
	//�ſ����ڵ�
	CodeBean[] gr_cd1 = c_db.getCodeAll2("0013", "1");
	CodeBean[] gr_cd2 = c_db.getCodeAll2("0013", "2");
	CodeBean[] gr_cd3 = c_db.getCodeAll2("0013", "3");
	//�ڻ�����
	CodeBean[] ass_cd = c_db.getCodeAll2("0014", "");
	
	
	
	
	
	Hashtable sh_ht = new Hashtable();
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt());
	if(base.getCar_gu().equals("0") && !base.getCar_st().equals("2")){
		//2008��7��15�� ������------------------------------------------------------------------------------------
		//������ �縮���϶�
		if(base.getCar_gu().equals("0") && !base.getCar_mng_id().equals("")){
			
			//�縮�������⺻�������̺�
			Hashtable ht = shDb.getShBase(base.getCar_mng_id());
			
			//��������-�������̺� ���� ��ȸ
			Hashtable ht2 = shDb.getBase(base.getCar_mng_id());
			
			if(String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
				ht2.put("REG_ID", user_id);
				ht2.put("SECONDHAND_DT", base.getRent_dt());
				//sh_base table insert
				int count = shDb.insertShBase(ht2);
			}else{
				int chk = 0;
				if(!String.valueOf(ht2.get("SECONDHAND_DT")).equals(String.valueOf(ht.get("SECONDHAND_DT")))) 		chk++;
				if(!String.valueOf(ht2.get("BEFORE_ONE_YEAR")).equals(String.valueOf(ht.get("BEFORE_ONE_YEAR")))) 	chk++;
				if(!String.valueOf(ht2.get("SERV_DT")).equals(String.valueOf(ht.get("SERV_DT")))) 					chk++;
				if(!String.valueOf(ht2.get("TOT_DIST")).equals(String.valueOf(ht.get("TOT_DIST")))) 				chk++;
				if(!String.valueOf(ht2.get("TODAY_DIST")).equals(String.valueOf(ht.get("TODAY_DIST")))) 			chk++;
				if(!String.valueOf(ht2.get("PARK")).equals(String.valueOf(ht.get("PARK")))) 						chk++;
				if(chk >0){
					ht2.put("SECONDHAND_DT", base.getRent_dt());
					//sh_base table update
					int count = shDb.updateShBase(ht2);
				}
			}
			//2008��7��15�� ������------------------------------------------------------------------------------------
		}
		//��������
		sh_ht = shDb.getShBase(base.getCar_mng_id());
		//������� ����Ⱓ(����)
	}
	
	if(rent_st.equals("")) rent_st = "1";
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(max_fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}	
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(max_fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
	}			
	
	String car_ins_chk = "N";
	
	if(!ins.getCar_mng_id().equals("")){
		car_ins_chk = "Y";
	}
	
	//���� ���Ź�� ����� �ִ��� Ȯ��
	ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
	
	//���������
	int grt_suc_fee_size = 0;
	ContFeeBean grt_suc_fee = new ContFeeBean();
	
	if(!cont_etc.getGrt_suc_l_cd().equals("")){
		grt_suc_fee_size = af_db.getMaxRentSt(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
		grt_suc_fee = a_db.getContFeeNew(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd(), grt_suc_fee_size+"");		
	}	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	function replaceFloatRound2(per){
		return Math.round(per*10)/10;	
	}

	//���������ݽ°���ȸ
	function search_grt_suc()
	{
		var fm = document.form1;	
		window.open("/fms2/car_pur/s_grt_suc.jsp?from_page=/fms2/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}		
	//���������ݽ°����
	function cancel_grt_suc()
	{
		var fm = document.form1;
		fm.grt_suc_l_cd.value = '';
		fm.grt_suc_m_id.value = '';
		fm.grt_suc_c_no.value = '';
		fm.grt_suc_o_amt.value = '';
		fm.grt_suc_r_amt.value = '';
	}	
		
	//����/���� ��ȸ
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=820, height=450");
	}			
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("���õ� ������ �����ϴ�."); return;}
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}
	//�������
	function cancel_site(){
		var fm = document.form1;
		if(confirm('���� ����Ͻðڽ��ϱ�?')){	
			fm.site_nm.value = '';
			fm.site_id.value = '';
		}
	}			


	
	//������ ��ȸ
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_mgr.jsp?car_st=<%=base.getCar_st()%>&from_page=lc_c_u&idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
		
	//��ǥ�̻纸��
	function cng_input2(){	
		var fm = document.form1;		
		if(fm.client_guar_st[0].checked == true){ 		//����
			tr_client_guar.style.display = 'none';		
		}else{											//����
			tr_client_guar.style.display = '';				
		}
	}
	
	//���뺸����
	function guar_display(){
		var fm = document.form1;
		var size = toInt(fm.gur_size.value);
		if(fm.guar_st[0].checked == true){ 				//����
			tr_guar2.style.display	= '';
		}else{											//����
			tr_guar2.style.display	= 'none';
		}
	}	
	
	function gur_display_add(){
		var fm = document.form1;
		var size = toInt(fm.gur_size.value);
		if(size == 0){
			tr_gur_info0.style.display	= '';
			tr_gur_eval0.style.display	= '';
			tr_gur_ass0.style.display	= '';
		}else if(size == 1){
			tr_gur_info1.style.display	= '';
			tr_gur_eval1.style.display	= '';
			tr_gur_ass1.style.display	= '';
		}else if(size == 2){
			tr_gur_info2.style.display	= '';
			tr_gur_eval2.style.display	= '';
			tr_gur_ass2.style.display	= '';
		}else{
			alert('���뺸������ �ִ� 3�α��� �Դϴ�.');
		}
		fm.gur_size.value = size+1;
	}
	
	//������ ��ȸ
	function search_gur(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_gur.jsp?idx="+idx+"&client_id="+fm.client_id.value, "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//���� üũ
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');
		}
	}
	
	//3�ܰ� -----------------------------------------------------------
		
	//��������� �ſ��� ���÷���
	function SetEval_gr(idx){
		var fm = document.form1;
		
		var gr_size = 1+<%=gur_size%>;
		
		if(fm.client_st.value != '2') gr_size++;
		
		if(gr_size > 1){
		
			if(fm.eval_off[idx].value == '2' || fm.eval_off[idx].value == '3'){		
				fm.eval_gr[idx].length = <%= gr_cd1.length+1 %>;
				fm.eval_gr[idx].options[0].value = '';
				fm.eval_gr[idx].options[0].text = '����';			
				<%for(int i =0; i<gr_cd1.length; i++){
					CodeBean cd = gr_cd1[i];%>
				fm.eval_gr[idx].options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
				fm.eval_gr[idx].options[<%=i+1%>].text  = '<%=cd.getNm()%>';
				<%}%>				
			}else if(fm.eval_off[idx].value == '1'){		
				if(fm.eval_gu[idx].value == '1'){
					fm.eval_gr[idx].length = <%= gr_cd3.length+1 %>;
					fm.eval_gr[idx].options[0].value = '';
					fm.eval_gr[idx].options[0].text = '����';			
					<%for(int i =0; i<gr_cd3.length; i++){
						CodeBean cd = gr_cd3[i];%>
					fm.eval_gr[idx].options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr[idx].options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>								
				}else{
					fm.eval_gr[idx].length = <%= gr_cd2.length+1 %>;
					fm.eval_gr[idx].options[0].value = '';
					fm.eval_gr[idx].options[0].text = '����';			
					<%for(int i =0; i<gr_cd2.length; i++){
						CodeBean cd = gr_cd2[i];%>
					fm.eval_gr[idx].options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr[idx].options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>		
				}
			}else{
				fm.eval_gr[idx].length = 1;
				fm.eval_gr[idx].options[0].value = '';
				fm.eval_gr[idx].options[0].text = '����';							
			}
			
		}else{
	
			if(fm.eval_off.value == '2' || fm.eval_off.value == '3'){		
				fm.eval_gr.length = <%= gr_cd1.length+1 %>;
				fm.eval_gr.options[0].value = '';
				fm.eval_gr.options[0].text = '����';			
				<%for(int i =0; i<gr_cd1.length; i++){
					CodeBean cd = gr_cd1[i];%>
				fm.eval_gr.options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
				fm.eval_gr.options[<%=i+1%>].text  = '<%=cd.getNm()%>';
				<%}%>				
			}else if(fm.eval_off.value == '1'){		
				if(fm.eval_gu.value == '1'){
					fm.eval_gr.length = <%= gr_cd3.length+1 %>;
					fm.eval_gr.options[0].value = '';
					fm.eval_gr.options[0].text = '����';			
					<%for(int i =0; i<gr_cd3.length; i++){
						CodeBean cd = gr_cd3[i];%>
					fm.eval_gr.options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr.options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>								
				}else{
					fm.eval_gr.length = <%= gr_cd2.length+1 %>;
					fm.eval_gr.options[0].value = '';
					fm.eval_gr.options[0].text = '����';			
					<%for(int i =0; i<gr_cd2.length; i++){
						CodeBean cd = gr_cd2[i];%>
					fm.eval_gr.options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr.options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>		
				}
			}else{
				fm.eval_gr.length = 1;
				fm.eval_gr.options[0].value = '';
				fm.eval_gr.options[0].text = '����';							
			}
			
		}
		
	} 

	//4�ܰ� -----------------------------------------------------------
		
		

	//���/����: �������� �Է½� �ڵ�������� ����..
	function enter_car(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_car_amt(obj);
	}	
	//���/����: ���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_car_amt(obj)
	{
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.car_cs_amt){ 		//�����⺻���� ���ް�
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) * 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
			sum_tax_amt();
			sum_car_c_amt();
			account_car_f_amt();
			account_credit_amt();
			sum_car_f_amt();			
		}else if(obj==fm.opt_cs_amt){ 	//���û��� ���ް�
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) * 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
			sum_tax_amt();
			sum_car_c_amt();
			account_car_f_amt();
			account_credit_amt();
			sum_car_f_amt();			
		}else if(obj==fm.col_cs_amt){ 	//���� ���ް�
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) * 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
			sum_tax_amt();
			sum_car_c_amt();
			account_car_f_amt();
			account_credit_amt();
			sum_car_f_amt();			
		}else if(obj==fm.sd_cs_amt){ 	//Ź�۷� ���ް�
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) * 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
			sum_car_f_amt();			
		}else if(obj==fm.dc_cs_amt){ 	//����DC ���ް�
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) * 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));			
			account_credit_amt();
			sum_car_f_amt();						
		}else if(obj==fm.car_fs_amt){ 	//�鼼�������� ���ް�
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) * 0.1 );
			fm.car_f_amt.value	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));			
			sum_car_f_amt();						
		}else if(obj==fm.tax_dc_s_amt){ 	//ģȯ���� ���Ҽ� ����� ���ް�
			fm.tax_dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) * 0.1 );
			fm.tax_dc_amt.value		= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));			
		}

		else if(obj==fm.car_cv_amt){ 	//�����⺻���� �ΰ���
			fm.car_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) / 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
			sum_tax_amt();
			sum_car_c_amt();
			account_car_f_amt();
			account_credit_amt();
			sum_car_f_amt();			
		}else if(obj==fm.opt_cv_amt){ 	//���û��� �ΰ���
			fm.opt_cs_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cv_amt.value)) / 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
			sum_tax_amt();
			sum_car_c_amt();
			account_car_f_amt();
			account_credit_amt();
			sum_car_f_amt();			
		}else if(obj==fm.col_cv_amt){ 	//���� �ΰ���
			fm.col_cs_amt.value = parseDecimal(toInt(parseDigit(fm.col_cv_amt.value)) / 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
			sum_tax_amt();
			sum_car_c_amt();
			account_car_f_amt();
			account_credit_amt();
			sum_car_f_amt();			
		}else if(obj==fm.sd_cv_amt){ 	//Ź�۷� �ΰ���
			fm.sd_cs_amt.value = parseDecimal(toInt(parseDigit(fm.sd_cv_amt.value)) / 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
			sum_car_f_amt();			
		}else if(obj==fm.dc_cv_amt){ 	//����DC �ΰ���
			fm.dc_cs_amt.value = parseDecimal(toInt(parseDigit(fm.dc_cv_amt.value)) / 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));
			account_credit_amt();
			sum_car_f_amt();						
		}else if(obj==fm.car_fv_amt){ 	//�鼼�������� �ΰ���
			fm.car_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
			sum_car_f_amt();						
		}else if(obj==fm.tax_dc_v_amt){ 	//ģȯ���� ���Ҽ� ����� �ΰ���
			fm.tax_dc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_v_amt.value)) / 0.1 );
			fm.tax_dc_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));
		}

		else if(obj==fm.car_c_amt){ 	//�����⺻���� �հ�
			fm.car_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_cs_amt.value)));			
			sum_tax_amt();
			sum_car_c_amt();
			account_car_f_amt();
			account_credit_amt();
			sum_car_f_amt();			
		}else if(obj==fm.opt_c_amt){ 	//���û��� �հ�
			fm.opt_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.opt_cs_amt.value)));			
			sum_tax_amt();
			sum_car_c_amt();
			account_car_f_amt();
			account_credit_amt();
			sum_car_f_amt();			
		}else if(obj==fm.col_c_amt){ 	//���� �հ�
			fm.col_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.col_cs_amt.value)));			
			sum_tax_amt();
			sum_car_c_amt();
			account_car_f_amt();
			account_credit_amt();
			sum_car_f_amt();			
		}else if(obj==fm.sd_c_amt){ 	//Ź�۷� �հ�
			fm.sd_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.sd_cs_amt.value)));			
			sum_car_f_amt();			
		}else if(obj==fm.dc_c_amt){ 	//����DC �հ�
			fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));			
			account_credit_amt();
			sum_car_f_amt();						
		}else if(obj==fm.car_f_amt){ 	//�鼼�������� �հ�
			fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_fs_amt.value)));			
			sum_car_f_amt();						
		}else if(obj==fm.tax_dc_amt){ 	//ģȯ���� ���Ҽ� ����� �հ�
			fm.tax_dc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.tax_dc_v_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));			
		}
		sum_tax_amt();
		sum_car_c_amt();
		sum_car_f_amt();
	}

	//���� Ư�Ҽ� �ڵ����
	function set_tax_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.spe_tax){ 	//Ư�Ҽ�
			fm.edu_tax.value = parseDecimal(toInt(parseDigit(obj.value))*(30/100));		
		}
		fm.tot_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );					
	}

	//��������� �ڵ����
	function set_gi_amt(){
		var fm = document.form1;
		//var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
		//var oa_g 	= <%//=em_bean.getOa_g()%>/100;
		//var a_b 	= toInt(parseDigit(fm.con_mon.value));
		//var gi_fee 	= <%//=gi_fee%>;
		//fm.gi_fee.value = parseDecimal(gi_fee);		
	}

	//���� Ư�Ҽ� �հ�
	function sum_tax_amt(){
		var fm = document.form1;
		
		if(toInt(parseDigit(fm.spe_tax.value)) >  0){	return; }
		
		if(toInt(parseDigit(fm.car_f_amt.value)) == 0){	sum_car_f_amt(); }
		
		var purc_gu 	= fm.purc_gu.value;		
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_c_price = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));		
		var car_f_price = toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		
		var a_e = toInt(s_st);
		var o_1 = car_c_price;
		//������ Ư�Ҽ���
		var o_2 = <%=ej_bean.getJg_3()%>;			
		//Ư�Ҽ��������� o_3 = o_1/(1+o_2), ��������/(1+Ư�Ҽ���);
		var o_3 = Math.round(<%=o_3%>);		
		
		if(purc_gu == '1'){//����1
			fm.spe_tax.value = parseDecimal(car_c_price-o_3);
			fm.pay_st[1].selected = true;
		}else{//����2(�鼼)	 	
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
				fm.spe_tax.value = parseDecimal(Math.round(o_1*o_2));
			}else{
				fm.spe_tax.value = parseDecimal(car_c_price-toInt(parseDigit(fm.car_f_amt.value)));
			}				
			fm.pay_st[2].selected = true;
		}
		fm.edu_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value))*(30/100));		
		fm.tot_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );			
	}
	
	//���� �Һ��ڰ� �հ�
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );
				
	}
	
	//�������� ���
	function account_car_f_amt(){
		var fm = document.form1;
		var purc_gu 	= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));

		if(fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0'){
			fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_c_amt.value))));
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));			
		}

		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }		
		if(purc_gu == '1'){//����1
			fm.car_fs_amt.value = fm.tot_cs_amt.value;
			fm.car_fv_amt.value = fm.tot_cv_amt.value;
			fm.car_f_amt.value 	= fm.tot_c_amt.value;
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
				fm.car_fs_amt.value = fm.tot_cs_amt.value;
				fm.car_fv_amt.value = fm.tot_cv_amt.value;
				fm.car_f_amt.value 	= fm.tot_c_amt.value;
			}else{
				var a_e = toInt(s_st);
				var o_1 = car_price;
				//������ Ư�Ҽ���
				var o_2 = <%=ej_bean.getJg_3()%>;			
				//Ư�Ҽ��������� o_3 = o_1/(1+o_2), ��������/(1+Ư�Ҽ���);
				var o_3 = Math.round(<%=o_3%>);
				fm.car_f_amt.value 	= parseDecimal(o_3);
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));			
			}				
		}
	}
	
	//ä��Ȯ�� ���
	function account_credit_amt(){
		var fm = document.form1;	
		var purc_gu 	= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));

		if(fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0'){
			fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_c_amt.value))));
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));			
		}
		
		<%if(cng_item.equals("fee")){%>	
		//ä��Ȯ��
		var car_price2 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		var s_dc_amt = 0;
		
		if(toInt(fm.s_dc1_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc1_amt.value));
		if(toInt(fm.s_dc2_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc2_amt.value));
		if(toInt(fm.s_dc3_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc3_amt.value));
		
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
			
		//�Ϲ� ������ ��Ʈ������ ����D/C�ݾ� Ư�Ҽ����ݿ�---------------	
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }				
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				var a_e = toInt(s_st);
				var o_1 = car_price2;
				//������ Ư�Ҽ���
				var o_2 = <%=ej_bean.getJg_3()%>;	
					<%	if(base.getDlv_dt().equals("")){%>
					<%		if(cr_bean.getInit_reg_dt().equals("")){%>
						if(<%=AddUtil.getDate(4)%> >= 20081219 && <%=AddUtil.getDate(4)%> < 20090630) o_2 = o_2*0.7;				
					<%		}else{%>
						if(<%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> >= 20081219 && <%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> < 20090630) o_2 = o_2*0.7;							
					<%		}%>
					<%	}else{%>
						if(<%=base.getDlv_dt()%> >= 20081219 && <%=base.getDlv_dt()%> < 20090630) o_2 = o_2*0.7;				
					<%	}%>
				//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);
				s_dc_amt = Math.round(s_dc_amt*(1+o_2));
			}				
		}
        car_price2 = car_price2 - s_dc_amt;
				
		if(fm.car_gu.value != '1'){
			car_price2 	= toInt(parseDigit(fm.sh_amt.value));
		}
		if(<%=rent_st%> >  1){//����
			car_price2 	= toInt(parseDigit(fm.sh_amt.value));
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) car_price2	= toInt(parseDigit(fm.fee_opt_amt.value));
		}		
		
		if(car_st == '1'){
			if(car_price2 < 25000000)									fm.credit_per.value = '20';
			else if(car_price2 > 25000000 && car_price2 < 45000000)		fm.credit_per.value = '30';
			else if(car_price2 > 45000000)								fm.credit_per.value = '25';
		}else if(car_st == '3'){
			if(car_price2 < 25000000)									fm.credit_per.value = '30';
			else if(car_price2 > 25000000 && car_price2 < 45000000)		fm.credit_per.value = '35';
			else if(car_price2 > 45000000)								fm.credit_per.value = '40';		
		}
		var credit_per = toInt(fm.credit_per.value)/100;
		fm.credit_amt.value = parseDecimal(car_price2*credit_per);		
		<%}%>

	}
	
	//���� ���԰� �հ�
	function sum_car_f_amt(){
		var fm = document.form1;
				
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							
	}	
	
	//����DC
	function search_dc(){
		var fm = document.form1;
		window.open("search_dc.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "COMP_DC", "left=100, top=100, height=200, width=800, scrollbars=yes, status=yes");
	}
	
	//�Ǻ�����-�� ���÷���
	function display_ip(){
		var fm = document.form1;
		var insur_per = fm.insur_per.options[fm.insur_per.selectedIndex].value;
		if(insur_per == '1'){ 				//�Ƹ���ī
			tr_ip.style.display		= 'none';
			tr_ip2.style.display	= 'none';
		}else{								//��
			tr_ip.style.display		= '';
			tr_ip2.style.display	= '';
		}		
	}	
		

	
	//�������� ���÷���
	function display_gi(){
		var fm = document.form1;
		if(fm.gi_st[0].checked == true){	//����
			tr_gi1.style.display		= '';
		}else{								//����
			tr_gi1.style.display		= 'none';
		}		
	}	
	
	//�뿩�Ⱓ ����
	function set_cont_date(){
		var fm = document.form1;
	
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;

		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
			
		fm.action='get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
	}
	
	//�ݿø�
	function getCutRoundNumber(num, place){
		var returnNum;
		var st="1";
		return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
	}	
	
	//���/����: �������� �Է½� �ڵ�������� ����..
	function enter_fee(obj)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_fee_amt(obj);
	}	
	//���/����: ���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_fee_amt(obj)
	{
		var fm = document.form1;	
		
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		var s_dc_amt = 0;
		
		if(toInt(fm.s_dc1_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc1_amt.value));
		if(toInt(fm.s_dc2_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc2_amt.value));
		if(toInt(fm.s_dc3_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc3_amt.value));
		
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
			
		//�Ϲ� ������ ��Ʈ������ ����D/C�ݾ� Ư�Ҽ����ݿ�---------------	
		var purc_gu 	= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;			
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }				
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				var a_e = toInt(s_st);
				var o_1 = car_price;
				//������ Ư�Ҽ���
				var o_2 = <%=ej_bean.getJg_3()%>;	
					<%	if(base.getDlv_dt().equals("")){%>
					<%		if(cr_bean.getInit_reg_dt().equals("")){%>
						if(<%=AddUtil.getDate(4)%> >= 20081219 && <%=AddUtil.getDate(4)%> < 20090630) o_2 = o_2*0.7;				
					<%		}else{%>
						if(<%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> >= 20081219 && <%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> < 20090630) o_2 = o_2*0.7;							
					<%		}%>
					<%	}else{%>
						if(<%=base.getDlv_dt()%> >= 20081219 && <%=base.getDlv_dt()%> < 20090630) o_2 = o_2*0.7;				
					<%	}%>
				//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);
				s_dc_amt = Math.round(s_dc_amt*(1+o_2));
			}				
		}
		
    car_price = car_price - s_dc_amt;

        
    var f_car_price = car_price;    
								
		if(fm.car_gu.value != '1'){
			car_price 	= toInt(parseDigit(fm.sh_amt.value));
		}
		if(<%=rent_st%> != 1){//����
			car_price 	= toInt(parseDigit(fm.sh_amt.value));
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) car_price	= toInt(parseDigit(fm.fee_opt_amt.value));
		}		
		
		//������---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			fm.f_gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / f_car_price );
			sum_pp_amt();			
		}else if(obj==fm.grt_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			fm.f_gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / f_car_price );
			sum_pp_amt();		
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
			fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			fm.f_pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / f_car_price );
			sum_pp_amt();			
		}else if(obj==fm.pp_v_amt){ 	//������ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
			fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			fm.f_pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / f_car_price );			
			sum_pp_amt();	
		}else if(obj==fm.pp_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));								
			fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			fm.f_pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / f_car_price );			
			sum_pp_amt();
		//���ô뿩��---------------------------------------------------------------------------------			
		}else if(obj==fm.ifee_s_amt){ 	//���ô뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ifee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));					
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			sum_pp_amt();
		}else if(obj==fm.ifee_v_amt){ 	//���ô뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));					
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);				
			sum_pp_amt();					
		}else if(obj==fm.ifee_amt){ 	//���ô뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));								
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));	
			fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);			
			sum_pp_amt();		
		//�����ܰ���---------------------------------------------------------------------------------			
		}else if(obj==fm.app_ja){ 		//�����ܰ���
			fm.ja_r_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.app_ja.value) /100,-3) );
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
		}else if(obj==fm.ja_r_s_amt){ 	//�����ܰ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
			//fm.app_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
		}else if(obj==fm.ja_r_v_amt){ 	//�����ܰ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_amt){		//�����ܰ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
			fm.app_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_r_amt.value)) / car_price );
		//�ִ��ܰ���---------------------------------------------------------------------------------			
		}else if(obj==fm.max_ja){ 		//�����ܰ���
			fm.ja_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.max_ja.value) /100,-3) );
			fm.ja_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));			
		}else if(obj==fm.ja_s_amt){ 	//�����ܰ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ja_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) * 0.1 );
			fm.ja_amt.value			= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));			
			//fm.max_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
		}else if(obj==fm.ja_v_amt){ 	//�����ܰ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ja_amt.value			= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));			
		}else if(obj==fm.ja_amt){		//�����ܰ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ja_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));			
			fm.max_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
		//���Կɼ���---------------------------------------------------------------------------------			
		}else if(obj==fm.opt_s_amt){ 	//���Կɼ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));			
			fm.opt_per.value 		= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
			fm.f_opt_per.value 		= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / f_car_price );
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(<%=base.getRent_dt()%> >= 20080501 && toInt(parseDigit(fm.opt_amt.value)) > toInt(parseDigit(fm.ja_amt.value))){
					fm.app_ja.value		= fm.max_ja.value;
					fm.ja_r_s_amt.value = fm.ja_s_amt.value;
					fm.ja_r_v_amt.value = fm.ja_v_amt.value;
					fm.ja_r_amt.value 	= fm.ja_amt.value;		
				}else{				
					fm.app_ja.value		= fm.opt_per.value;
					fm.ja_r_s_amt.value = fm.opt_s_amt.value;
					fm.ja_r_v_amt.value = fm.opt_v_amt.value;
					fm.ja_r_amt.value 	= fm.opt_amt.value;
				}
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked = true;				
			}
		}else if(obj==fm.opt_v_amt){ 	//���Կɼ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(<%=base.getRent_dt()%> >= 20080501 && toInt(parseDigit(fm.opt_amt.value)) > toInt(parseDigit(fm.ja_amt.value))){
					fm.app_ja.value		= fm.max_ja.value;
					fm.ja_r_s_amt.value = fm.ja_s_amt.value;
					fm.ja_r_v_amt.value = fm.ja_v_amt.value;
					fm.ja_r_amt.value 	= fm.ja_amt.value;		
				}else{				
					fm.app_ja.value		= fm.opt_per.value;
					fm.ja_r_s_amt.value = fm.opt_s_amt.value;
					fm.ja_r_v_amt.value = fm.opt_v_amt.value;
					fm.ja_r_amt.value 	= fm.opt_amt.value;
				}
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked = true;				
			}			
		}else if(obj==fm.opt_amt){ 		//���Կɼ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));			
			fm.opt_per.value 		  = replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
			fm.f_opt_per.value 		= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / f_car_price );
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(<%=base.getRent_dt()%> >= 20080501 && toInt(parseDigit(fm.opt_amt.value)) > toInt(parseDigit(fm.ja_amt.value))){
					fm.app_ja.value		= fm.max_ja.value;
					fm.ja_r_s_amt.value = fm.ja_s_amt.value;
					fm.ja_r_v_amt.value = fm.ja_v_amt.value;
					fm.ja_r_amt.value 	= fm.ja_amt.value;		
				}else{				
					fm.app_ja.value		= fm.opt_per.value;
					fm.ja_r_s_amt.value = fm.opt_s_amt.value;
					fm.ja_r_v_amt.value = fm.opt_v_amt.value;
					fm.ja_r_amt.value 	= fm.opt_amt.value;
				}
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value = fm.ja_s_amt.value;
				fm.ja_r_v_amt.value = fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked = true;				
			}
		//���뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.fee_s_amt){ 	//���뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
		}else if(obj==fm.fee_v_amt){ 	//���뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value		= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.fee_amt){ 		//���뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
		//������뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.ins_s_amt){ 	//������뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ins_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) * 0.1 );
			fm.ins_amt.value	= parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)));			
			

			
			dc_fee_amt();
			setTinv_amt();
	 	}else if(obj==fm.ins_v_amt){ 
	 		//������뿩�� �ΰ���
	 		obj.value = parseDecimal(obj.value);
			fm.ins_amt.value = parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)));	
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.ins_amt){ 		//������뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ins_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_amt.value))));
			fm.ins_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_amt.value)) - toInt(parseDigit(fm.ins_s_amt.value)));	
			dc_fee_amt();
			setTinv_amt();

		//�Ѻ����---------------------------------------------------------------------------------
		}else if(obj==fm.ins_total_amt){
			obj.value = parseDecimal(obj.value);
			fm.ins_total_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_total_amt.value)));
			
		//�����뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//�����뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.inv_v_amt){ 	//�����뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value		= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.inv_amt){ 		//�����뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		
			//������ �߰����(2018.03.30)-------------------------------------------------------------------	
		}else if(obj==fm.driver_add_amt){	//�������߰���� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.driver_add_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) * 0.1 );
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.driver_add_v_amt){ 	//�������߰���� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.driver_add_total_amt){ //�������߰���� �հ�			
			obj.value = parseDecimal(obj.value);
			fm.driver_add_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.driver_add_total_amt.value))));
			fm.driver_add_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.driver_add_total_amt.value)) - toInt(parseDigit(fm.driver_add_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}
	}	
	
	//�������հ� ���ϱ�
	function setTinv_amt(){
		fm.tinv_s_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.driver_add_amt.value)));
		fm.tinv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
		fm.tinv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.driver_add_total_amt.value)));
	}
	
	//������ �հ�
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		

		var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
		
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		var s_dc_amt = 0;
		
		if(toInt(fm.s_dc1_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc1_amt.value));
		if(toInt(fm.s_dc2_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc2_amt.value));
		if(toInt(fm.s_dc3_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc3_amt.value));
		
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
			
		//�Ϲ� ������ ��Ʈ������ ����D/C�ݾ� Ư�Ҽ����ݿ�---------------	
		var purc_gu 	= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;			
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }				
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				var a_e = toInt(s_st);
				var o_1 = car_price;
				//������ Ư�Ҽ���
				var o_2 = <%=ej_bean.getJg_3()%>;	
					<%	if(base.getDlv_dt().equals("")){%>
					<%		if(cr_bean.getInit_reg_dt().equals("")){%>
						if(<%=AddUtil.getDate(4)%> >= 20081219 && <%=AddUtil.getDate(4)%> < 20090630) o_2 = o_2*0.7;				
					<%		}else{%>
						if(<%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> >= 20081219 && <%=AddUtil.replace(cr_bean.getInit_reg_dt(),"-","")%> < 20090630) o_2 = o_2*0.7;							
					<%		}%>
					<%	}else{%>
						if(<%=base.getDlv_dt()%> >= 20081219 && <%=base.getDlv_dt()%> < 20090630) o_2 = o_2*0.7;				
					<%	}%>
				//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);
				s_dc_amt = Math.round(s_dc_amt*(1+o_2));
			}				
		}
		
    car_price = car_price - s_dc_amt;
        
    car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));    	    
		
		if(fm.car_gu.value != '1'){
			car_price 	= toInt(parseDigit(fm.sh_amt.value));
		}
		if(<%=rent_st%> != 1){//����
			car_price 	= toInt(parseDigit(fm.sh_amt.value));
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) car_price	= toInt(parseDigit(fm.fee_opt_amt.value));
		}
		
		fm.credit_r_per.value = replaceFloatRound(pp_price / car_price );
		fm.credit_r_amt.value = parseDecimal(pp_price);

		<%if(cng_item.equals("fee")){%>	
		var car_st 		= fm.car_st.value;
		//ä��Ȯ��
		if(car_st == '1'){
			if(car_price < 25000000)																fm.credit_per.value = '20';
			else if(car_price > 25000000 && car_price < 35000000)		fm.credit_per.value = '30';
			else if(car_price > 35000000)														fm.credit_per.value = '25';
		}else if(car_st == '3'){
			if(car_price < 25000000)																fm.credit_per.value = '30';
			else if(car_price > 25000000 && car_price < 35000000)		fm.credit_per.value = '35';
			else if(car_price > 35000000)														fm.credit_per.value = '40';		
		}
		
		//�������� �⺻ �����ݿ��� 10% ���ش�
    if('<%=ej_bean.getJg_g_7()%>' == '3'){
     	fm.credit_per.value     = toInt(fm.credit_per.value)-10;
    }
		//�������� �⺻ �����ݿ��� 15% ���ش�
    if('<%=ej_bean.getJg_g_7()%>' == '4'){
     	fm.credit_per.value     = toInt(fm.credit_per.value)-15;
    }
    		
		var credit_per = toInt(fm.credit_per.value)/100;
		fm.credit_amt.value = parseDecimal(car_price*credit_per);		
		<%}%>
		
	}
	
	//������ġ�� ����
	function set_janga(){
		var fm = document.form1;	
		
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		var s_dc_amt = 0;
		
		if(toInt(fm.s_dc1_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc1_amt.value));
		if(toInt(fm.s_dc2_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc2_amt.value));
		if(toInt(fm.s_dc3_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc3_amt.value));
		
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		
		var rent_st		= '<%=fees.getRent_st()%>';
									
		//�Ϲ� ������ ��Ʈ������ ����D/C�ݾ� Ư�Ҽ����ݿ�---------------	
		var purc_gu 	= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;			
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }				
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				var a_e = toInt(s_st);
				var o_1 = car_price;
				//������ Ư�Ҽ���
				var o_2 = <%=ej_bean.getJg_3()%>;			
				//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);
				s_dc_amt = Math.round(s_dc_amt*(1+o_2));
			}				
		}
		//--------------------------------------------------------------

		<%if(!rent_st.equals("1")){%>
		
				var fm2 = document.sh_form;	
				fm2.rent_st.value = '2';
				fm2.a_b.value = fm.con_mon.value;		
				fm2.fee_opt_amt.value = fm.fee_opt_amt.value;		
				fm2.action='/acar/secondhand/getSecondhandJanga.jsp';
				fm2.target='i_no';
				fm2.submit();	
				
		<%}else{%>	
										
		if(fm.car_gu.value == '0'){//�縮��
				
			var fm2 = document.sh_form;	
			if(<%=rent_st%> == 1)				fm2.rent_st.value = '1';
			else								fm2.rent_st.value = '2';
			fm2.a_b.value = fm.con_mon.value;				
			fm2.action='/acar/secondhand/getSecondhandJanga.jsp';
			fm2.target='i_no';
			fm2.submit();	
						
		}else if(fm.car_gu.value == '2'){//�߰���
						
			var fm2 = document.sh_form;	
			fm2.car_mng_id.value = fm.rent_l_cd.value;
			fm2.rent_dt.value = fm.rent_dt.value;
			fm2.rent_st.value = '3';						
			fm2.a_b.value = fm.con_mon.value;
			fm2.action='/acar/secondhand/getSecondhandJanga.jsp';
			fm2.target='i_no';
			fm2.submit();	
						
		}else{
		
				car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));    			
				
				fm.o_1.value 		= car_price - s_dc_amt;			
				fm.t_dc_amt.value 	= s_dc_amt;		
				fm.ja_s_amt.value	= '0';
				fm.ja_v_amt.value	= '0';
				fm.ja_amt.value		= '0';								
				fm.action='getNewCarJanga.jsp';				
				fm.target='i_no';			
				fm.submit();											
		}
							
		<%}%>
				
		set_fee_amt(fm.opt_per);
		set_fee_amt(fm.app_ja);		
		set_fee_amt(fm.grt_amt);
		set_fee_amt(fm.pp_amt);		
		set_fee_amt(fm.ifee_s_amt);
									
	}
	
	//�뿩�� DC�� ���
	function dc_fee_amt(){
		var fm = document.form1;
		
		var pp_s_amt	= toInt(parseDigit(fm.pp_s_amt.value));		//������
		var fee_s_amt	= toInt(parseDigit(fm.fee_s_amt.value));	//���뿩��(����)
		var inv_s_amt	= toInt(parseDigit(fm.inv_s_amt.value));	//����뿩��(����)
		var con_mon		= toInt(parseDigit(fm.con_mon.value));		//�뿩�Ⱓ 
		var dc_ra;
		
		if(<%=base.getRent_dt()%> >= 20080501){
			if(inv_s_amt > 0){
				dc_ra = (1 - (pp_s_amt+fee_s_amt*con_mon)/(pp_s_amt+inv_s_amt*con_mon));
				fm.dc_ra.value = parseFloatCipher3(dc_ra,1);
			}
		}
	}	
	
	//�����뿩�� ��� (����)
	function estimate(rent_st, st){
		
		<%if(!base.getCar_st().equals("2")){%>
		
		var fm = document.form1;
	
		if(toInt(fm.app_ja.value) == 0){ alert('�����ܰ����� �Է��Ͻʽÿ�.'); return;}
		if(toInt(fm.ja_r_amt.value) == 0){ alert('�����ܰ��ݾ��� �Է��Ͻʽÿ�.'); return;}		
		
		
		fm.fee_rent_st.value = rent_st;
		
		var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		var s_dc_amt = 0;
				
		if(toInt(fm.s_dc1_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc1_amt.value));
		if(toInt(fm.s_dc2_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc2_amt.value));
		if(toInt(fm.s_dc3_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc3_amt.value));
		
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		
		var rent_st		= '<%=fees.getRent_st()%>';
									
		//�Ϲ� ������ ��Ʈ������ ����D/C�ݾ� Ư�Ҽ����ݿ�---------------	
		var purc_gu 	= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;			
		
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }				
		
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>' == '2031111' || '<%=cm_bean.getJg_code()%>' == '2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				var a_e = toInt(s_st);
				var o_1 = car_price;
				//������ Ư�Ҽ���
				var o_2 = <%=ej_bean.getJg_3()%>;			
				//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);
				s_dc_amt = Math.round(s_dc_amt*(1+o_2));
			}				
		}
		//--------------------------------------------------------------
		
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));    	
									
		fm.o_1.value 		= car_price - s_dc_amt;
		fm.t_dc_amt.value 	= s_dc_amt;		
		fm.esti_stat.value 	= st;
				
		fm.ro_13.value 		= fm.app_ja.value;
		fm.o_13_amt.value 	= fm.ja_r_amt.value;
		
		if(<%=fees.getRent_dt()%> >= 20080501){
			if(toInt(parseDigit(fm.ja_r_amt.value)) > toInt(parseDigit(fm.ja_amt.value))){
				fm.ro_13.value 		= fm.max_ja.value;
				fm.o_13_amt.value 	= fm.ja_amt.value;
			}			
		}
		fm.o_13.value 		= fm.max_ja.value;
				
		if(fm.car_gu.value != '1'){//�縮��
			fm.o_1.value	= <%=fee_etc.getSh_amt()%>;
		}		
		
		if(<%=rent_st%> > 1){//����
			fm.o_1.value	= <%=fee_etc.getSh_amt()%>;
			if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) fm.o_1.value	= fm.fee_opt_amt.value;
		}
		
		fm.action='get_fee_estimate.jsp';
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}
			
		if(<%=rent_st%> != 1){
			fm.submit();
		}else{
			if(confirm('�������� ������� '+fm.comm_r_rt.value+'%�� �����˴ϴ�. ����Ͻðڽ��ϱ�?')){											
				fm.submit();
			}
		}
		
		dc_fee_amt();
		
		<%}%>

	}
	
	//����������� ���÷���
	function display_tae(){
		var fm = document.form1;
		if(fm.prv_dlv_yn[0].checked == true){	//����
			tr_tae2.style.display		= 'none';
		}else{									//�ִ�
			tr_tae2.style.display		= '';
		}		
	}		

	//��������� ��ȸ
	function car_search(st)
	{
		var fm = document.form1;
		if(st == 'taecha'){
			window.open("search_res_car.jsp?taecha=Y&client_id=<%=base.getClient_id()%>", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");
		}else{
			window.open("search_ext_car.jsp?taecha=Y", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");		
		}		
	}	
	
	//�����Ҵ���� ��ȸ
	function search_emp(st){
		var fm = document.form1;
		var one_self = "N";
		var pur_bus_st = "";
		if('<%=pur.getOne_self()%>' == 'Y') one_self = "Y";
		if(fm.pur_bus_st[0].checked == true) 	pur_bus_st 	= "1";
		if(fm.pur_bus_st[1].checked == true) 	pur_bus_st 	= "2";
		if(fm.pur_bus_st[2].checked == true) 	pur_bus_st 	= "4";
		window.open("search_emp.jsp?bus_id=<%=base.getBus_id()%>&rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self="+one_self+"&pur_bus_st="+pur_bus_st+"&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");				
//		window.open("search_emp.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self=<%=pur.getOne_self()%>&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");		
	}
	//�����Ҵ���� �Է����
	function cancel_emp(st){
		var fm = document.form1;
		if(st == 'BUS'){
			fm.emp_nm[0].value = '';
			fm.emp_id[0].value = '';
			fm.car_off_nm[0].value = '';
			fm.car_off_id[0].value = '';
			fm.car_off_st[0].value = '';
			fm.cust_st.value = '';
			fm.comm_rt.value = '';
			fm.comm_r_rt.value = '';
			fm.ch_remark.value = '';
			fm.ch_sac_id.value = '';
		}else{
			fm.emp_nm[1].value = '';
			fm.emp_id[1].value = '';
			fm.car_off_nm[1].value = '';
			fm.car_off_st[1].value = '';
			fm.car_off_id[1].value = '';
		}		
	}
	
	//��� �����Ҵ���ڸ� ���� �����Ҵ���� ��ó��
	function set_emp_sam(){
		var fm = document.form1;	
		if(fm.emp_chk.checked == true){			
			fm.emp_nm[1].value = fm.emp_nm[0].value;
			fm.emp_id[1].value = fm.emp_id[0].value;
			fm.car_off_nm[1].value = fm.car_off_nm[0].value;
			fm.car_off_st[1].value = fm.car_off_st[0].value;		
		}else{
			cancel_emp('DLV');
		}			
	}

	//����������
	function setCommi(){
		var fm = document.form1;
		
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));		
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
		
		fm.commi.value = parseDecimal(th_round(car_price*comm_r_rt/100));
				
	}
	
	//�ش� ���� �������� �⺻��� ����
	function open_car_b(car_id, car_seq, car_name){
		window.open('view_car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=100, top=100, width=450, height=600, scrollbars=yes"); 
	}
	
	// ÷�ܾ�����ġ ������ ���Ƴ��� ���¿��� ����� ���� �� ÷�ܾ�����ġ select box ��Ȱ��ȭ ���� ����	2018.02.02
	function before_submit(){
		$("#lkas_yn").prop("disabled", false);
		$("#ldws_yn").prop("disabled", false);
		$("#aeb_yn").prop("disabled", false);
		$("#fcw_yn").prop("disabled", false);
		$("#ev_yn").prop("disabled", false);
		$("#hook_yn").prop("disabled", false);
		$("#legal_yn").prop("disabled", false);
	}

	//����
	function update(){
		var fm = document.form1;
		
		var cng_item = fm.cng_item.value;
		
		<%if(cng_item.equals("client")){%>
		
			<%if(!base.getCar_st().equals("4")){%>
		
			if(fm.t_addr.value == '')	{ alert('�����ּҸ� Ȯ���Ͻʽÿ�.'); 		return;}
			
			<%}%>
			
			//����,���λ���ڴ� ���������ȣ �ʼ�
			if(fm.client_st.value == '2' || fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){		
				if(fm.lic_no.value == '' && fm.mgr_lic_no.value == ''){
					alert('����,���λ���ڴ� ���������ȣ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.lic_no.value != '' && fm.lic_no.value.length < 12){
					alert('����� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_no.value.length < 12){
					alert('�����̿��� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_emp.value == ''){
					alert('�����̿��� ���������ȣ �̸��� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_rel.value == ''){
					alert('�����̿��� ���������ȣ ���踦 �Է��Ͻʽÿ�.');
					return;
				}
			}else if(fm.client_st.value == '1'||fm.client_st.value == '6'){	//����
				if(fm.ssn.value==""){
					if(fm.lic_no.value == '' || fm.lic_no.value.length < 12){
						alert('���ι�ȣ�� ���� ���������� ��쿡�� ���������ȣ�� �Է��Ͻʽÿ�.');
						return;
					}
				}
			}						
			
		<%}else if(cng_item.equals("mgr")){%>			
			
			<%if(!base.getCar_st().equals("4")){%>
			<%	for(int i = 0 ; i <= mgr_size ; i++){%>
					if(fm.email_1[<%=i%>].value != '' && fm.email_2[<%=i%>].value != ''){
						fm.mgr_email[<%=i%>].value = fm.email_1[<%=i%>].value+'@'+fm.email_2[<%=i%>].value;
					}
					if(fm.email_1[<%=i%>].value == '' && fm.email_2[<%=i%>].value == ''){
						fm.mgr_email[<%=i%>].value = '';
					}
			<%	}%>
			<%}%>
			
		
		<%}else if(cng_item.equals("client_guar")){%>
		
			if(fm.client_guar_st[1].checked == true){		
				if(fm.guar_con.options[fm.guar_con.selectedIndex].value == '')		{ alert('��ǥ�̻纸�� ���������� �����Ͻʽÿ�.'); 		return;}			
				if(fm.guar_sac_id.options[fm.guar_sac_id.selectedIndex].value == ''){ alert('��ǥ�̻纸�� ���������ڸ� �����Ͻʽÿ�.'); 	return;}						
			}
			
		<%}else if(cng_item.equals("guar")){%>			
					
			if(fm.guar_st[0].checked == true){
				if(fm.gur_nm[0].value == '')	{ alert('���뺸���� ������ �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_id[0].value == '')	{ alert('���뺸���� ��������� �Է��Ͻʽÿ�.'); 	return;}
				if(fm.t_addr[0].value == '')	{ alert('���뺸���� �ּҸ� �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_tel[0].value == '')	{ alert('���뺸���� ����ó�� �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_rel[0].value == '')	{ alert('���뺸���� ���踦 �Է��Ͻʽÿ�.'); 			return;}												
			}
		
		<%}else if(cng_item.equals("dec")){%>			
						
			if(fm.dec_gr.value == '')			{ alert('�����ſ����� �����Ͻʽÿ�.'); 				return;}
			
			if(fm.client_st.value == '1'){
				var open_year = '<%=AddUtil.replace(client.getOpen_year(),"-","")%>';
				var now = new Date();
				var base_dt = now.getYear()+'0101';
				if(open_year != '' && toInt(open_year) < toInt(base_dt)){
					if(fm.c_ba_year_s.value == '' || fm.c_ba_year.value == '')		{ alert('��� �������ڸ� �Է��Ͻʽÿ�.'); 	return;}
					if(fm.c_cap.value == '' || fm.c_cap.value == '0')				{ alert('��� �ں����� �Է��Ͻʽÿ�.'); 	return;}
				}
			}						
						
		<%}else if(cng_item.equals("car")){%>		
			
// 			if(fm.color.value == '')					{ alert('�뿩����-������ �Է��Ͻʽÿ�.'); 					fm.color.focus(); 			return; }
			
			// ��޽��� �߰� 2017.12.26
			if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
				alert('�������(�⺻��), ������� �̽ð� ����, ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
			}
			if(fm.tint_s_yn.checked == true && fm.tint_ps_yn.checked == true){
				alert('�������(�⺻��)�� ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
			}
			if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true){
				alert('�������(�⺻��)�� ������� �̽ð� ���� �� �ϳ��� üũ�ϼ���.'); fm.tint_s_yn.focus(); return;
			}
			if(fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
				alert('������� �̽ð� ���ΰ� ��޽���(��������) �� �ϳ��� üũ�ϼ���.'); fm.tint_ps_yn.focus(); return;
			}
			if(fm.tint_ps_yn.checked == true && fm.tint_ps_amt.value < 1){
				alert('��޽��� �ݾ��� �Է��ϼ���.'); fm.tint_ps_amt.focus(); return;
			}
			if(fm.tint_bn_yn.checked == true && fm.tint_bn_nm.value == ''){
				alert('���ڽ� ������ ���� ������ �����Ͻʽÿ�.'); fm.tint_bn_nm.focus(); return;
			}
			
			var prev_new_license_plate = '<%=car.getNew_license_plate()%>';
			if(prev_new_license_plate == '1' || prev_new_license_plate == '2'){
				prev_new_license_plate = '1';
			} else {
				prev_new_license_plate = '0';
			}
			fm.prev_new_license_plate.value = prev_new_license_plate;
			
// 			if(fm.pur_color.value != ''){
// 				if(fm.old_color.value != fm.color.value || fm.old_in_col.value != fm.in_col.value || fm.old_garnish_col.value != fm.garnish_col.value){
// 					alert('Ư�ǹ����� �ִ� ����('+fm.pur_color.value+')�ϰ� �뿩����-������ �ٸ��ϴ�. ���� ������̸� ������ ���¾�ü����-��ü���������� ����(����) ���� �����Ͻʽÿ�.');
// 				}				
// 			}
		
		<%}else if(cng_item.equals("car_amt")){%>		

			if(fm.car_gu.value == '1'){//����
				var car_c_amt = toInt(parseDigit(fm.car_c_amt.value));
				var car_f_amt = toInt(parseDigit(fm.car_f_amt.value));
				if(fm.purc_gu.value == '')			{ alert('��������-���������� �Է��Ͻʽÿ�.'); 		fm.purc_gu.focus(); 		return; }
				if(car_c_amt == 0)				{ alert('��������-�Һ��ڰ� �⺻������ �Է��Ͻʽÿ�.'); 	fm.car_c_amt.focus(); 		return; }
				if(car_f_amt == 0)				{ alert('��������-���԰� ���������� �Է��Ͻʽÿ�.'); 		fm.car_f_amt.focus(); 		return; }			
				//��༭�� ������ ������ �������� ǥ�⿩��, ������. (20190911)
				<%if(base.getCar_gu().equals("1") && fee_size<=1){%>
					if(fm.dc_view_yn.checked==true){
						if(fm.view_car_dc.value==""||fm.view_car_dc.value==0){
							alert("���� ��༭�� ������ ���� �� �������� ���� ǥ�� ���� üũ!\n\n-> [������ ���� �� ��������] �� �Է����ּ���.");	fm.view_car_dc.focus();	return;
						}
					}else{
						fm.view_car_dc.value="";
					}
				<%}%>
				<%if(!nm_db.getWorkAuthUser("������ڵ��",user_id)){%>
				var chk_car_amt1 = Math.abs(toInt(parseDigit(fm.o_car_c_amt.value))-toInt(parseDigit(fm.car_c_amt.value)));
				if(chk_car_amt1 > 50000){
					alert('�������� �Һ��ڰ� �⺻���� ���� �������� ��50,000���� �ѽ��ϴ�. Ȯ���Ͻʽÿ�.');
					return;
				}
				var chk_car_amt2 = Math.abs(toInt(parseDigit(fm.o_car_f_amt.value))-toInt(parseDigit(fm.car_f_amt.value)));
				if(chk_car_amt2 > 50000){
					alert('�������� ���԰��� ���� �������� ��50,000���� �ѽ��ϴ�. Ȯ���Ͻʽÿ�.');
					return;
				}	
				<%}%>
			}

		<%}else if(cng_item.equals("insur")){%>		
		
			if(fm.insur_per.value == '')				{ alert('�������-�Ǻ����ڸ� �Է��Ͻʽÿ�.'); 		fm.insur_per.focus(); 		return; }
			if(fm.driving_age.value == '')				{ alert('�������-�����ڿ����� �Է��Ͻʽÿ�.'); 		fm.driving_age.focus(); 	return; }
			
			<%if(!nm_db.getWorkAuthUser("������",user_id)){%>	
			<% 	if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
				if(fm.com_emp_yn.value == '')				{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');	fm.com_emp_yn.focus(); 		return; }
			<%	}%>
			<%}%>
			
			if(fm.gcp_kd.value == '')				{ alert('�������-�빰��� ���Աݾ��� �Է��Ͻʽÿ�.'); 		fm.gcp_kd.focus(); 		return; }
			if(fm.bacdt_kd.value == '')				{ alert('�������-�ڱ��ü��� ���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.bacdt_kd.focus(); 		return; }
			if(fm.canoisr_yn.value == '')				{ alert('�������-������������ ���Կ��θ� �Է��Ͻʽÿ�.'); 	fm.canoisr_yn.focus(); 		return; }
			if(fm.cacdt_yn.value == '')				{ alert('�������-�ڱ��������� ���Կ��θ� �Է��Ͻʽÿ�.'); 	fm.cacdt_yn.focus(); 		return; }
			if(fm.eme_yn.value == '')				{ alert('�������-����⵿ ���Կ��θ� �Է��Ͻʽÿ�.'); 		fm.eme_yn.focus(); 		return; }
		
			//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
			if('<%=base.getCar_st()%><%=fees.getRent_way()%>' == '33'){
				if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
					alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
					return;					
				}
			}			
			
			if(fm.car_st.value != '2' && fm.car_st.value != '5'){
				var car_ja 	= toInt(parseDigit(fm.car_ja.value));
				if(car_ja == 0)					{ alert('�������-������å���� �Է��Ͻʽÿ�.'); 			fm.car_ja.focus(); 			return; }
   				<%if(ej_bean.getJg_w().equals("1")){//������%>
				if(fm.car_ja.value != fm.imm_amt.value){
					if(fm.ja_reason.value == '')		{ alert('�������-������å�� ��������� �Է��Ͻʽÿ�.'); 	fm.ja_reason.focus(); 		return; }
					if(fm.rea_appr_id.value == '')		{ alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.'); fm.rea_appr_id.focus(); 	return; }
				}
				<%}else{%>
				if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
					if(fm.ja_reason.value == '')		{ alert('�������-������å�� ��������� �Է��Ͻʽÿ�.'); 	fm.ja_reason.focus(); 		return; }
					if(fm.rea_appr_id.value == '')		{ alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.'); fm.rea_appr_id.focus(); 	return; }
				}			
				<%}%>							
				if(fm.car_st.value != '4' && fm.insur_per.value == '2'){
					if(fm.ip_insur.value == '')			{ alert('�������-�Ժ�ȸ�� �������� �Է��Ͻʽÿ�.'); 		fm.ip_insur.focus(); 		return; }
					if(fm.ip_agent.value == '')			{ alert('�������-�Ժ�ȸ�� �븮������ �Է��Ͻʽÿ�.'); 		fm.ip_agent.focus(); 		return; }
					if(fm.ip_dam.value == '')			{ alert('�������-�Ժ�ȸ�� ����ڸ��� �Է��Ͻʽÿ�.'); 		fm.ip_dam.focus(); 			return; }
					if(fm.ip_tel.value == '')			{ alert('�������-�Ժ�ȸ�� ����ó�� �Է��Ͻʽÿ�.'); 		fm.ip_tel.focus(); 			return; }
				}
			}
		
		<%}else if(cng_item.equals("gi")){%>		
		
			if(fm.car_st.value != '2'){
				if(fm.gi_st[0].checked == true){//����
					if(fm.gi_jijum.value == '')			{ alert('��������-���������� �Է��Ͻʽÿ�.'); 				fm.gi_jijum.focus(); 		return; }
					var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
					//var gi_fee 	= toInt(parseDigit(fm.gi_fee.value));
					if(gi_amt == 0)						{ alert('��������-���Աݾ��� �Է��Ͻʽÿ�.'); 				fm.gi_amt.focus(); 			return; }
					//if(gi_fee == 0)						{ alert('��������-��������Ḧ �Է��Ͻʽÿ�.'); 			fm.gi_fee.focus(); 			return; }
				}
			}
		
		<%}else if(cng_item.equals("fee")){%>		
		
			if(fm.car_st.value != '2'){
				dc_fee_amt();
				
				
			}

		<%}else if(cng_item.equals("rent_start")){%>		
		
				
				//���谡�Ե�� üũ
				<%if(car_ins_chk.equals("N")){%>
					alert('���谡�Ե���� �ȵǾ��ֽ��ϴ�. �������ڿ��� Ȯ���Ͻʽÿ�.');	return; 
				<%}%>
				
				if(toInt(fm.car_ret_chk.value) > 0)		{ alert('�뿩����-����ý��ۿ� ���� ��ó������ �ֽ��ϴ�. ���� ����ó���Ŀ� �뿩���� �Ͻʽÿ�.'); return; }
				if(fm.con_mon.value == '')			{ alert('�뿩����-�̿�Ⱓ�� �Է��Ͻʽÿ�.'); 				fm.con_mon.focus(); 		return; }
				if(fm.rent_start_dt.value == '')		{ alert('�뿩����-�뿩�������� �Է��Ͻʽÿ�.'); 			fm.rent_start_dt.focus(); 	return; }
				if(fm.rent_end_dt.value == '')			{ alert('�뿩����-�뿩�������� �Է��Ͻʽÿ�.'); 			fm.rent_end_dt.focus(); 	return; }				
				
				//[�Է°� üũ]1.�뿩������ ���纸�� �Ѵ��̻� ���̰� ���� �ȵȴ�.
				var est_day = getRentTime('m', fm.rent_start_dt.value, '<%=AddUtil.getDate()%>');				
				if( est_day > 1 || est_day < -1){ 
					alert('�Է��Ͻ� �뿩�������� ���糯¥�� �Ѵ��̻� ���̳��ϴ�.\n\nȮ���Ͻʽÿ�.'); 				fm.rent_start_dt.focus(); 	return; 
				}
				
				
				<%if(fee.getFee_s_amt()>0 && !fee.getFee_chk().equals("1") ){%>
					if(fm.fee_pay_tm.value == '')		{ alert('�뿩����-����Ƚ���� �Է��Ͻʽÿ�.'); 				fm.fee_pay_tm.focus(); 		return; }
					if(fm.fee_est_day.value == '')		{ alert('�뿩����-�������ڸ� �Է��Ͻʽÿ�.'); 				fm.fee_est_day.focus(); 	return; }
					if(fm.fee_pay_start_dt.value == '')	{ alert('�뿩����-���ԱⰣ�� �Է��Ͻʽÿ�.'); 				fm.fee_pay_start_dt.focus();	return; }
					if(fm.fee_pay_end_dt.value == '')	{ alert('�뿩����-���ԱⰣ�� �Է��Ͻʽÿ�.'); 				fm.fee_pay_end_dt.focus(); 	return; }
					
					if(fm.fee_fst_dt.value == '')		{ alert('�뿩����-1ȸ���������� �Է��Ͻʽÿ�.'); 			fm.fee_fst_dt.focus(); 		return; }
				
					//[�Է°� üũ]2.ùȸ���������� �뿩�����Ϻ��� Ŭ���� ����.
					est_day = getRentTime('d', fm.rent_start_dt.value, fm.fee_fst_dt.value);
					if( est_day < 0){ 
						alert('�Է��Ͻ� ùȸ���������� �뿩�����Ϻ��� �۽��ϴ�. \n\nȮ���Ͻʽÿ�.');				fm.fee_fst_dt.focus(); 		return;
					}									
				<%}%>
				
				
										
			
		<%}else if(cng_item.equals("pay_way")){%>		
		
			<%if(!base.getCar_st().equals("4") && cms.getApp_dt().equals("")){%>
				if(fm.cms_acc_no.value != '')		{ 
					if ( !checkInputNumber("CMS ���¹�ȣ", fm.cms_acc_no.value) ) {		
						fm.cms_acc_no.focus(); 		return; 
					}
					//�޴���,����ó ���Ͽ��� Ȯ��
					if(replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getM_tel()%>") || replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getO_tel()%>")){
						alert("���¹�ȣ�� �޴��� Ȥ�� ����ó�� �����ϴ�. ������¹�ȣ�� �ڵ���ü�� �ȵ˴ϴ�.");
						fm.cms_acc_no.focus(); 		return; 
					}
				}
			<%}%>
		
		<%}else if(cng_item.equals("tax")){%>		
		
			if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ fm.tax_type[0].checked = true; }
			if(fm.car_st.value != '2'){		
				if(fm.rec_st.value == '')			{ alert('���ݰ�꼭-û�������ɹ���� �Է��Ͻʽÿ�.');			fm.rec_st.focus(); 		return; }
				if(fm.rec_st.value == '1'){
					if(fm.ele_tax_st.value == '')		{ alert('���ݰ�꼭-���ڼ��ݰ�꼭 �ý����� �Է��Ͻʽÿ�.'); 		fm.ele_tax_st.focus();		return; }
					if(fm.ele_tax_st.value == '2'){
						if(fm.tax_extra.value == '')	{ alert('���ݰ�꼭-���ڼ��ݰ�꼭 �����ý��� �̸��� �Է��Ͻʽÿ�.'); 	fm.tax_extra.focus(); 		return; }
					}
				}
			}
		
		<%}else if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){%>		
		
			
				if('<%=fee.getPrv_dlv_yn()%>' == 'Y'){					
					if(fm.tae_car_no.value == '')		{ alert('���������-�ڵ����� �����Ͻʽÿ�.'); 			fm.tae_car_no.focus(); 		return; }										
					
					
					if('<%=base.getRent_st()%>' == '3' && fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){
						fm.tae_car_mng_id.value 	= '<%=cr_bean.getCar_mng_id()%>';
						fm.tae_car_id.value 		= '<%=cm_bean.getCar_id()%>';
						fm.tae_car_seq.value 		= '<%=cm_bean.getCar_seq()%>';
						fm.tae_car_nm.value 		= '<%=cr_bean.getCar_nm()%>';
						fm.tae_init_reg_dt.value 	= '<%=cr_bean.getInit_reg_dt()%>';						
					}

					if(fm.tae_car_mng_id.value == '')	{ alert('���������-�ڵ����� �����Ͻʽÿ�.'); 			fm.tae_car_no.focus(); 		return; }															
					if(fm.tae_car_rent_st.value == '')	{ alert('���������-�뿩�������� �Է��Ͻʽÿ�.'); 		fm.tae_car_rent_st.focus(); 	return; }
					if(fm.tae_req_st.value == '')		{ alert('���������-û�����θ� �����Ͻʽÿ�.'); 		fm.tae_req_st.focus(); 		return; }
					if(fm.tae_req_st.value == '1'){
						if(toInt(parseDigit(fm.tae_rent_fee.value)) == 0)	{ alert('���������-���뿩�Ḧ �Է��Ͻʽÿ�.'); 			fm.tae_rent_fee.focus(); 	return; }
						if(toInt(parseDigit(fm.tae_rent_inv.value)) == 0)	{ alert('���������-�������� �Է��Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
						if(fm.tae_est_id.value == '' && fm.user_id.value != '000029')	{ alert('���������-������ ����ϱ⸦ �Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
						<%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
                        <%}else{%>
						if(fm.tae_rent_fee_st[0].checked == false && fm.tae_rent_fee_st[1].checked == false){
							alert('��������� ������ <����� ���� �뿩 ��� ������ �������> �׸� ����Ʈ �������� ǥ��Ǿ� �ִ� ��쿡 ����Ʈ �������� �Է��ϰ�, ����Ʈ �������� ǥ��Ǿ� ���� ���� ��쿡�� ���������� ǥ��Ǿ� ���� ������ üũ���ּ���.'); return;
						}else{
							if(fm.tae_rent_fee_st[0].checked == true){
								if(toInt(parseDigit(fm.tae_rent_fee_cls.value)) == 0){ alert('���� ������ �������(����Ʈ������)�� �Է��Ͻʽÿ�.'); return;									}
								if(toInt(parseDigit(fm.tae_rent_fee.value)) >= toInt(parseDigit(fm.tae_rent_fee_cls.value)))	{ alert('���� ������ �������(����Ʈ������)���� ����������� ���뿩�Ẹ�� ũ�� �ʽ��ϴ�. Ȯ���Ͻʽÿ�.'); 			fm.tae_rent_fee_cls.focus(); 	return; }
							}else{
								fm.tae_rent_fee_cls.value = 0;
							}								
						}
						<%}%>
						if(fm.tae_tae_st.value == '')	{ alert('���������-��꼭���࿩�θ� �����Ͻʽÿ�.'); 		fm.tae_tae_st.focus(); 		return; }
					}
					if(fm.tae_sac_id.value == '')		{ alert('���������-�����ڸ� �����Ͻʽÿ�.'); 			fm.tae_sac_id.focus(); 		return; }
					if(toInt(parseDigit(fm.tae_rent_fee.value))>0){
							fm.tae_rent_fee_s.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.tae_rent_fee.value))));
							fm.tae_rent_fee_v.value 	= parseDecimal(toInt(parseDigit(fm.tae_rent_fee.value)) - toInt(parseDigit(fm.tae_rent_fee_s.value)));						
					}
					
					if(fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){
						var est_day = getRentTime('d', fm.tae_car_rent_st.value, fm.tae_car_rent_et.value);
						fm.end_rent_link_day.value = est_day;
						var est_amt = (<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>-<%=grt_suc_fee.getFee_s_amt()+grt_suc_fee.getFee_v_amt()%>)/<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;
						est_amt = replaceFloatRound(est_amt);
						fm.end_rent_link_per.value = est_amt;						
						if(est_day > 35 || est_amt > 30){
							tr_tae3.style.display = '';
							fm.end_rent_link_sac_id_text.value = '(�ʼ�)';
							//������üũ
							if(fm.end_rent_link_sac_id.value == ''){ alert('�����Ī���� �̰������� ���� �����ڸ� �����Ͻʽÿ�.'); fm.end_rent_link_sac_id.focus(); 		return;}
						}						
					}	
					
				}
			
		
		<%}else if(cng_item.equals("emp1")){%>		
		
			if(fm.emp_id[0].value != '' && fm.user_id.value != '000029'){			
				if(fm.comm_rt.value == '')			{ alert('������翵�����-�������� �ִ���������� �Է��Ͻʽÿ�.'); 	fm.comm_rt.focus(); 		return; }
				if(fm.comm_r_rt.value == '')		{ alert('������翵�����-�������� ������������� �Է��Ͻʽÿ�.'); 	fm.comm_r_rt.focus(); 		return; }
				if(toFloat(fm.comm_rt.value) < toFloat(fm.comm_r_rt.value)){ //�ִ������������ ������������� �� Ŭ���� ����.
					alert('������翵�����-�������� �ִ������������ ������������� �� Ŭ�� �� �����ϴ�. Ȯ���Ͻʽÿ�.'); 		fm.comm_rt.focus(); return;
				}
			}

		<%}else if(cng_item.equals("emp2")){%>	
		
		<%}%>
		
		<%if(cng_item.equals("rent_start") && base.getCar_mng_id().equals("")){%>	
		  alert('���� ������ ��ϵ��� �ʾҽ��ϴ�. ������� �� ������ �� �ֽ��ϴ�.'); 	
		  return; 			
		<%}%>
		
		
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			before_submit();	// ÷�ܾ�����ġ ������ ���Ƴ��� ���¿��� ����� ���� �� ÷�ܾ�����ġ select box ��Ȱ��ȭ ���� ����	2018.02.02
			fm.action='lc_c_u_a.jsp';		
			fm.target='i_no';			
			fm.submit();
		}							
		
		
		
	}
	
	
	
	//�߰������� ����ϱ�-���
	function getSecondhandCarAmt_h(){
		var fm = document.sh_form;
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
	//�߰������� ����ϱ�-���(�߰���)
	function getSecondhandCarAmt_h2(){
		var fm = document.form1;
		fm.action = "/acar/secondhand/getSecondhandBaseSet3.jsp";
		fm.target = "i_no";
		fm.submit();
	}	
	
	//������� ����
	function t_car_secondhand(){
		var fm = document.form1;
		
		if(fm.tae_car_mng_id.value == ''){ alert('����������� ������ ���õ��� �ʾҽ��ϴ�.'); return; }
		
		if(confirm('������� �����Ͻðڽ��ϱ�?\n\n����ȭ������ �̵��˴ϴ�.')){	
			fm.action='/acar/secondhand/esti_mng_i_20090901.jsp';		
			fm.target='_blank';
			fm.submit();
		}								
	}	
	
	//������� ������ȸ
	function search_bank_acc(gubun, car_off_id, car_off_nm){
		var fm = document.form1;
		if(car_off_id == ''){
			car_off_id = fm.car_off_id[1].value;
			car_off_nm = fm.car_off_nm[1].value;			
		}		
		if(car_off_id == ''){	alert('������Ҹ� ���� �����Ͻʽÿ�.'); return; 		}
		window.open("/fms2/car_pur/s_bankacc.jsp?go_url=/fms2/lc_rent/lc_b_s.jsp&st="+gubun+"&t_wd="+car_off_nm+"&car_off_id="+car_off_id, "CAR_OFF_ACC", "left=0, top=0, width=800, height=600, status=yes, scrollbars=yes");	
	}	
	
	//��������������� ���ÿ� ���� �ڱ�δ�� ����
	function setCacdtMeAmt(){
		var fm = document.form1;
		fm.cacdt_memin_amt.value = toInt(fm.cacdt_mebase_amt.value)*0.1;		
		if(toInt(fm.cacdt_mebase_amt.value) >0){
			fm.cacdt_me_amt.value = 50;
		}
	}		
	
	//����
	function update2(st, rent_st){
		var height = 600;
		window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM2", "left=150, top=150, width=1050, height="+height+", scrollbars=yes");
	}				
	
	//�뿩�ϼ� ���ϱ�
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
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
	
	function search_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}				
		
	function search_eval_key(){
		window.open("search_eval_key.jsp", "SEARCH_EVAL_KEY", "left=10, top=10, width=900, height=300, scrollbars=yes, status=yes, resizable=yes");	
	}		
				
	<%if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){%>				
	//��������� �����뿩�� ��� (����)
	function estimate_taecha(st){
		var fm = document.form1;
		
		if(fm.tae_car_mng_id.value == '' && '<%=base.getRent_st()%>' == '3' && fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){
			fm.tae_car_mng_id.value 	= '<%=cr_bean.getCar_mng_id()%>';
			fm.tae_car_id.value 		= '<%=cm_bean.getCar_id()%>';
			fm.tae_car_seq.value 		= '<%=cm_bean.getCar_seq()%>';
			fm.tae_car_nm.value 		= '<%=cr_bean.getCar_nm()%>';
			fm.tae_init_reg_dt.value 	= '<%=cr_bean.getInit_reg_dt()%>';						
		}
		
		if(fm.tae_car_mng_id.value == '')	{ alert('��������� ������ �����Ͻʽÿ�.');	return;}
		if(fm.tae_car_id.value == '')		{ alert('��������� ������ �ٽ� �����Ͻʽÿ�.');	return;}
		fm.esti_stat.value 	= st;
		if(st == 'view'){ fm.target = '_blank'; }else{ fm.target = 'i_no'; }
		fm.action='get_fee_estimate_taecha.jsp';
		fm.submit();
	}
	
	//�������μ�
	function TaechaEstiPrint(est_id){ 
		var SUBWIN="/acar/secondhand_hp/estimate.jsp?from_page=<%=from_page%>&est_id="+est_id;  	
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}	
	
	<%}%>
					
	//�����ػ� �ӽÿ��ຸ��� 2018.04.19
	function openHc(){
  		window.open('/acar/common/hyundai_confidentiality.jsp','_blank', 'width=800, height=600, menubars=no, scrollbars=auto');
 	}
 	
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
	
	//������ ���� �� ��������ǥ�� ��
	function span_dc_view(){
		var fm = document.form1;
		if(fm.dc_view_yn.checked==true){	$("#span_dc_view").css("display","");				}
		else{												$("#span_dc_view").css("display","none");		}
	}
	
	function change_eval_input(){
		var fm = document.form1;
		
		var eval_select = fm.eval_select;
		var eval_select_length = eval_select.length;
		
		for(var i=0; i<eval_select_length; i++){
			if(eval_select[i].selectedIndex == 1){
				eval_select[i].nextElementSibling.style.display = 'none';
				eval_select[i].nextElementSibling.value = '';
			} else {
				eval_select[i].nextElementSibling.style.display = 'inline';
			}
		}
	}
	
	//��������� �˻�
	function EstiTaeSearch(){
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=1100, height=800, resizable=yes, scrollbars=yes, status=yes");
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/tae_esti_history_cont.jsp';
		fm.submit();		
	}	
	
	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
	}	
	
	function cancel_taecha(){
		var fm = document.form1;
		fm.tae_car_no.value = '';
		fm.tae_no.value = '';
		fm.tae_car_mng_id.value = '';
		fm.tae_car_id.value = '';
		fm.tae_car_seq.value = '';
		fm.tae_s_cd.value = '';
		fm.tae_car_nm.value = '';
		fm.tae_init_reg_dt.value = '';
		fm.tae_car_rent_st.value = '';
		fm.tae_car_rent_et.value = '';
		fm.tae_f_req_yn[0].checked = false;
		fm.tae_f_req_yn[1].checked = false;
		fm.tae_rent_fee.value = '';
		fm.tae_rent_fee_s.value = '';
		fm.tae_rent_fee_v.value = '';
		fm.tae_rent_inv.value = '';
		fm.tae_rent_inv_s.value = '';
		fm.tae_rent_inv_v.value = '';
		fm.tae_est_id.value = '';
		<%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
        <%}else{%>
		fm.tae_rent_fee_st[0].checked = false;
		fm.tae_rent_fee_st[1].checked = false;
		fm.tae_rent_fee_cls.value = '';
		<%}%>		
		fm.tae_req_st.value = '';
		fm.tae_tae_st.value = '';
		fm.tae_sac_id.value = '';
	}
			
					
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
<style type-"text/css>
<!--	
input.whitetextredb		{ text-align:left; font-size : 9pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#ff0000;  font-weight:bold;}
//-->
</style>
</head>
<body leftmargin="15">
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name="mode"				value="lc_rent">    
  <input type='hidden' name="rent_st"			value="">      
  <input type='hidden' name="rent_dt"			value="">        
  <input type='hidden' name="a_b"				value="">      
  <input type="hidden" name="fee_opt_amt"  		value=""> 
</form>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_c_u.jsp'>
  <input type='hidden' name='cng_item'	 		value='<%=cng_item%>'>     
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">   
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%><%=cm_bean2.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="dpm" 				value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="s_dc1_re" 			value="<%=car.getS_dc1_re()%>">
  <input type='hidden' name="s_dc1_yn" 			value="<%=car.getS_dc1_yn()%>">
  <input type='hidden' name="s_dc1_amt"			value="<%=car.getS_dc1_amt()%>">
  <input type='hidden' name="s_dc2_re" 			value="<%=car.getS_dc2_re()%>">
  <input type='hidden' name="s_dc2_yn" 			value="<%=car.getS_dc2_yn()%>">
  <input type='hidden' name="s_dc2_amt"			value="<%=car.getS_dc2_amt()%>">
  <input type='hidden' name="s_dc3_re" 			value="<%=car.getS_dc3_re()%>">
  <input type='hidden' name="s_dc3_yn" 			value="<%=car.getS_dc3_yn()%>">
  <input type='hidden' name="s_dc3_amt"			value="<%=car.getS_dc3_amt()%>">
  <input type='hidden' name="s_dc1_re_etc"		value="<%=car.getS_dc1_re_etc()%>">  
  <input type='hidden' name="s_dc2_re_etc"		value="<%=car.getS_dc2_re_etc()%>">  
  <input type='hidden' name="s_dc3_re_etc"		value="<%=car.getS_dc3_re_etc()%>">      
  <input type='hidden' name="s_dc1_per"			value="<%=car.getS_dc1_per()%>">  
  <input type='hidden' name="s_dc2_per"			value="<%=car.getS_dc2_per()%>">  
  <input type='hidden' name="s_dc3_per"			value="<%=car.getS_dc3_per()%>">        
  <input type='hidden' name="car_end_dt"		value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_st"			value="<%=base.getCar_st()%>">  
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="fin_seq" 			value="<%=c_fin.getF_seq()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="gur_size"			value="<%=gur_size%>">     
  <input type='hidden' name='client_id' 		value="<%=base.getClient_id()%>">
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">      
  <input type='hidden' name="o_1"				value="">
  <input type='hidden' name="ro_13"				value="">  
  <input type='hidden' name="o_13"				value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
  <input type='hidden' name="idx"				value="">  
  <input type='hidden' name="scan_cnt"			value="">    
  <input type='hidden' name="chk_cnt"			value="">    
  <input type='hidden' name="est_from"			value="lc_c_u">      
  <input type='hidden' name="fee_rent_st"		value="<%=fees.getRent_st()%>">  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">   
  <input type='hidden' name="msg_st"		value="">         
  <input type='hidden' name="prev_new_license_plate"		value="">         
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>��༭����</span></span></td>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>����<%}else{%>������ȣ<%}%></td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>
        			</td>
                </tr>
    		</table>
	    </td>
	</tr>  	  
	<tr>
	    <td align="right">&nbsp;</td>
	<tr>
	<%if(cng_item.equals("client")){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��ȣ/����</td>
                    <td width='50%' align='left'>&nbsp;<%=client.getFirm_nm()%>              
        			  
        			  </td>
                    <td width='10%' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="client_nm" value='<%=client.getClient_nm()%>' size='22' class='whitetext' readonly></td>
                </tr>		
                <tr>
                    <td width='13%' class='title'>����/����</td>
                    <td colspan="3">&nbsp; 
        			  <input type='text' name="site_nm" value='<%=site.getR_site()%>' size='50' class='text' readonly>
        			  <input type='hidden' name='site_id' value='<%=base.getR_site()%>'>
        			  <span class="b"><a href='javascript:search_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>&nbsp;
        			  <span class="b"><a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
        			  <%if(!site.getR_site().equals("")){%>
        			  &nbsp; &nbsp; 
        			  <span class="b"><a href='javascript:cancel_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
        			  <%}%>
        			</td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
                <tr>
					<td class=title>�����ּ�</td>
					<td colspan= >&nbsp;
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=base.getP_zip()%>">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="67" value="<%=base.getP_addr()%>">
					</td>
					
                    <td class='title'>����������</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='<%=base.getTax_agnt()%>' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
                </tr>	
                <%	CarMgrBean mgr1 = new CarMgrBean();
                	CarMgrBean mgr5 = new CarMgrBean();
                	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("�����̿���")){
        					mgr1 = mgr;
        				}
        				if(mgr.getMgr_st().equals("�߰�������")){
    						mgr5 = mgr;
    					}
					}                       
                %>                
                <tr>
                    <td class='title'>����� ���������ȣ</td>
		    <td colspan="3">&nbsp;
			<input type='text' name='lic_no' value='<%=base.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			<input type="hidden" name="ssn" value="<%=client.getSsn1()%><%=client.getSsn2()%>">
			&nbsp;&nbsp;(����,���λ����)  
			&nbsp;�� �����(<%=client.getClient_nm()%>)�� ���������ȣ�� ����
		    </td>
                </tr>		  
                <tr>
                    <td class='title'>�����̿��� ���������ȣ</td>
		    <td colspan="3">&nbsp;
			<input type='text' name='mgr_lic_no' value='<%=base.getMgr_lic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;�̸�
			<input type='text' name='mgr_lic_emp' value='<%=base.getMgr_lic_emp()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;����
			<input type='text' name='mgr_lic_rel' value='<%=base.getMgr_lic_rel()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;(����,���λ����)  
			&nbsp;�� ����ڰ� �������㰡 ���� ��� �����̿����� �������㸦 �Է� 
		    </td>
                </tr>		                                
                <%if(base.getCar_st().equals("4")){%>
                <!-- �����̿��� �ּ� �߰�(2018.03.07) -->
                <tr>
                    <td width='13%' class='title'>�����̿��� �ּ�</td>                    
                    <td colspan=3>&nbsp;
		                <script>
							function openDaumPostcode3() {
								new daum.Postcode({
									oncomplete: function(data) {
										document.getElementById('c_u_zip').value = data.zonecode;
										document.getElementById('c_u_addr').value = data.address;
										
									}
								}).open();
							}
						</script>
						<input type="text" name="c_u_zip" id="c_u_zip" size="7" maxlength='7' value="">
						<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��"><br>
						&nbsp;&nbsp;<input type="text" name="car_use_addr" id="c_u_addr" size="60" value="<%=cont_etc.getCar_use_addr()%>">
					</td>
                </tr>    			
		<%}%>	
		<%if(mgr5.getMgr_st().equals("�߰�������")){ %>    
                <tr>
                    <td class='title'>�߰������� ���������ȣ</td>
		    <td colspan="3">&nbsp;
			<input type='text' name='mgr_lic_no5' value='<%=mgr5.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
			&nbsp;&nbsp;�̸�
			<input type='text' name='mgr_lic_emp5' value='<%=mgr5.getMgr_nm()%>'  size='10' class='text'>
			&nbsp;&nbsp;����
			<input type='text' name='mgr_lic_rel5' value='<%=mgr5.getEtc()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>			 
		    </td>
                </tr>	
            <%} %>   
            </table>
        </td>
    </tr>        
	<%}%>	
	<%if(cng_item.equals("mgr")){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%if(base.getCar_st().equals("4")){%>
                <tr> 
                    <td width="3%" rowspan="<%=mgr_size+2%>" class=title>��<br>��<br>��</td>
                    <td class=title width="10%">����</td>
                    <td class=title width="10%">����</td>			
                    <td class=title width="12%">�������</td>
                    <td class=title width="15%">�ּ�</td>
                    <td class=title width="10%">��ȭ��ȣ</td>
                    <td class=title width="10%">�޴���</td>
                    <td width="10%" class=title>���������ȣ</td>
                    <td width="15%" class=title>��Ÿ</td>
                    <td width="5%" class=title>��ȸ</td>
                </tr>
    		  <%String mgr_zip = "";
    			String mgr_addr = "";
    		  	for(int i = 0 ; i < mgr_size ; i++){
    				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>
                <tr>                 <input type='hidden' name='mgr_id' value='<%=mgr.getMgr_id()%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%=mgr.getMgr_st()%>' class='white' readonly></td>
                    
                    <td align='center'><input type='text' name='mgr_nm'   size='13' value='<%=mgr.getMgr_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_ssn'  size='15' maxlength='8' value='<%=mgr.getSsn()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_addr'  size='20' value='<%=mgr.getMgr_addr()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_tel'    size='13' value='<%=mgr.getMgr_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='<%=mgr.getMgr_m_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_lic_no'   size='13' value='<%=mgr.getLic_no()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_etc' size='20' value='<%=mgr.getEtc()%>' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		  <%	} %>
                <tr>                 <input type='hidden' name='mgr_id'  value='<%=mgr_size%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='' class='text'></td>
                    <td align='center'><input type='text' name='mgr_nm'   size='13' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_ssn'  size='15' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_addr'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_tel'    size='13' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_lic_no'   size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_etc' size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=mgr_size%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>		                
                <%}else{%>
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
                    <td width="5%" class=title>��ȸ</td>
                </tr>
        		  <%String mgr_zip = "";
        			String mgr_addr = "";
        		  	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("�����̿���")){
        					mgr_zip = mgr.getMgr_zip();
        					mgr_addr = mgr.getMgr_addr();
        				}%>
                <tr>                 <input type='hidden' name='mgr_id' value='<%=mgr.getMgr_id()%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%=mgr.getMgr_st()%>' class='white' readonly ></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' value='<%=mgr.getCom_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' value='<%=mgr.getMgr_dept()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' value='<%=mgr.getMgr_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' value='<%=mgr.getMgr_title()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' value='<%=mgr.getMgr_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='<%=mgr.getMgr_m_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
				<%	String email_1 = "";
					String email_2 = "";
					if(!mgr.getMgr_email().equals("")){
						int mail_len = mgr.getMgr_email().indexOf("@");
						if(mail_len > 0){
							email_1 = mgr.getMgr_email().substring(0,mail_len);
							email_2 = mgr.getMgr_email().substring(mail_len+1);
						}
					}
				%>
                    <td align='center'>
					<input type='text' size='10' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='10' name='email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" onChange="javascript:document.form1.email_2[<%=i%>].value=this.value;" align="absmiddle">
						<option value="" selected>�����ϼ���</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">���� �Է�</option>
						</select>
					<input type='hidden' name="mgr_email" value="<%=mgr.getMgr_email()%>">
					</td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
        		  <%	} %>
                <tr>                 <input type='hidden' name='mgr_id'  value='<%=mgr_size%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='' class='text'></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' value='' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'>
					<input type='text' size='10' name='email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='10' name='email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" onChange="javascript:document.form1.email_2[<%=mgr_size%>].value=this.value;" align="absmiddle">
						<option value="" selected>�����ϼ���</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">���� �Է�</option>
						</select>
					<input type='hidden' name="mgr_email" value="">
					</td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=mgr_size%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>		  
                <tr> 
                    <td colspan="2" class=title>�����̿��� �ǰ����� �ּ�</td>
					<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
						function openDaumPostcode1() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip1').value = data.zonecode;
									document.getElementById('t_addr1').value = data.address;
									
								}
							}).open();
						}
					</script>			
						<td colspan=8 >&nbsp;
						<input type="text" name="t_zip" id="t_zip1" size="7" maxlength='7' value="<%=mgr_zip%>">
						<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��">
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr1" size="67" value="<%=mgr_addr%>">
						</td>
						
                </tr>
                <%}%>
            </table>
        </td>
    </tr>	
	<%} %>
	<%if(cng_item.equals("client_guar")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ���뺸��</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_client_guar_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1' onClick="javascript:cng_input2()" <%if(cont_etc.getClient_guar_st().equals("1"))%>checked<%%>>
        				�Ժ�
        			  <input type='radio' name="client_guar_st" value='2' onClick="javascript:cng_input2()" <%if(cont_etc.getClient_guar_st().equals("2"))%>checked<%%>>
        				����</td>
                </tr>
                <tr id=tr_client_guar style="display:<%if(cont_etc.getClient_guar_st().equals("2")){%>''<%}else{%>none<%}%>">
                    <td class='title'>��������</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <select name='guar_con'>
                          <option value="">����</option>
                          <option value="6" <%if(cont_etc.getGuar_con().equals("6")){%>selected<%}%>>��ǥ��������</option>
                          <option value="1" <%if(cont_etc.getGuar_con().equals("1")){%>selected<%}%>>�ſ�������</option>
                          <option value="2" <%if(cont_etc.getGuar_con().equals("2")){%>selected<%}%>>���������δ�ü</option>
                          <option value="3" <%if(cont_etc.getGuar_con().equals("3")){%>selected<%}%>>�����������δ�ü</option>
                          <option value="5" <%if(cont_etc.getGuar_con().equals("5")){%>selected<%}%>>�����濵��</option>
                          <option value="4" <%if(cont_etc.getGuar_con().equals("4")){%>selected<%}%>>��Ÿ ����ȹ��</option>
                        </select>
                    </td>
                    <td width="10%" class='title'>������</td>
                    <td class='left'>&nbsp;
        			  <select name="guar_sac_id">
        			    <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cont_etc.getGuar_sac_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                    </select>
        			</td>
                </tr>
            </table>  
        </td>
    </tr>
	<%} %>
	<%if(cng_item.equals("guar")){%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뺸���� (��ǥ ��)</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="guar_st" value='1' onClick="javascript:guar_display()" <%if(cont_etc.getGuar_st().equals("1")){%>checked<%}%>>
        				�Ժ�
        			  <input type='radio' name="guar_st" value='2' onClick="javascript:guar_display()" <%if(cont_etc.getGuar_st().equals("2")){%>checked<%}%>>
        				����</td>
                </tr>
                <tr id=tr_guar2 <%if(cont_etc.getGuar_st().equals("1")){%>style="display:''"<%}else{%>style='display:none'<%}%>>
                    <td height="26" colspan="4" class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width=100%>        			  
                              <tr>
                                <td width="13%" class=title>����</td>
                                <td width="10%" class=title>����</td>
                                <td width="15%" class='title'>�������</td>
                                <td width="28%" class='title'>�ּ�</td>
                                <td width="13%" class='title'>����ó</td>
                                <td width="16%" class='title'>����</td>
                                <td width="5%" class='title'>��ȸ</td>
                              </tr>
                              <%for(int i = 0 ; i < gur_size ; i++){
                					Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
                              <tr>
                                <td class=title>���뺸����<input type='hidden' name='gur_id' value='<%=gur.get("GUR_ID")%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value='<%=gur.get("GUR_NM")%>'></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" maxlength='8' class='text' value='<%=gur.get("GUR_SSN")%>'></td>
                                <script>
									function openDaumPostcode2() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip2').value = data.zonecode;
												document.getElementById('t_addr2').value = data.address;
												
											}
										}).open();
									}
								</script>
								<td align="center">
									<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value='<%=gur.get("GUR_ZIP")%>'>
									<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr2" size="25" value='<%=gur.get("GUR_ADDR")%>'>
								</td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value='<%=gur.get("GUR_TEL")%>'></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value='<%=gur.get("GUR_REL")%>'></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span> </td>
                              </tr>
                              <%}%>
                              <%for(int i=gur_size; i<3; i++){%>
                              <tr>
                                <td class=title>���뺸����<input type='hidden' name='gur_id' value='<%=i+1%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" class='text' value=''></td>
								<script>
									function openDaumPostcode3() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip3').value = data.zonecode;
												document.getElementById('t_addr3').value = data.address;
												
											}
										}).open();
									}
								</script>
                                <td align="center">
									<input type="text" name="t_zip"  id="t_zip3" size="7" maxlength='7'>
									<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr3" size="25">
								</td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value=''></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">��ȸ</a></span> </td>
                              </tr>
                        <%}%>
                        </table>
    			    </td>			
                </tr>
            </table>  
        </td>
    </tr>
	<%} %>
	<%if(cng_item.equals("dec")){%>		
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
                    <td width=20%>&nbsp;<input type='text' size='30' name='job' value='<%=client.getJob()%>' maxlength='20' class='text'></td>
                    <td class=title width=10%>�ҵ汸��</td>
                    <td colspan="3">&nbsp;
        			  <select name='pay_st'>
        		          		<option value='0' <%if(client.getPay_st().equals("")) out.println("selected");%>>����</option>
        		            	<option value='1' <%if(client.getPay_st().equals("1")) out.println("selected");%>>�޿��ҵ�</option>
        		                <option value='2' <%if(client.getPay_st().equals("2")) out.println("selected");%>>����ҵ�</option>
        		                <option value='3' <%if(client.getPay_st().equals("3")) out.println("selected");%>>��Ÿ����ҵ�</option>
        		            </select>
        			</td>
                </tr>
    		    <tr>
        		    <td class='title'>�����</td>
        		    <td>&nbsp;<input type='text' size='30' name='com_nm' value='<%=client.getCom_nm()%>' maxlength='15' class='text'></td>
                    <td class=title width=10%>�ټӿ���</td>
                    <td width=20%>&nbsp;<input type='text' size='2' name='wk_year' value='<%=client.getWk_year()%>' maxlength='2' class='text'>��</td>
                    <td class=title width=10%>���ҵ�</td>
                    <td>&nbsp;<input type='text' size='7'  name='pay_type' maxlength='9' class='text' value='<%=client.getPay_type()%>'>&nbsp;����
        			</td>
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
		            <td width="42%" class=title>���(
		                <input type='text' name='c_kisu' size='11' value='<%=c_fin.getC_kisu()%>' maxlength='10' class='text' >
		            ��)</td>
		            <td width="43%" class=title>����(
		                <input type='text' name='f_kisu' size='11' value='<%=c_fin.getF_kisu()%>' maxlength='10' class='text' >
		            ��)</td>
		        </tr>
		        <tr>
		            <td class=title>&nbsp;&nbsp;
					(
		            	<input type='text' name='c_ba_year_s' size='11' class='text' maxlength='10' value='<%=c_fin.getC_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='c_ba_year' size='11' class='text' maxlength='10' value='<%=c_fin.getC_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		     
		            <td class='title'>&nbsp;&nbsp;
					(
		            	<input type='text' name='f_ba_year_s' size='11' class='text' maxlength='10' value='<%=c_fin.getF_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='f_ba_year' size='11' class='text' maxlength='10' value='<%=c_fin.getF_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		              
		        </tr>
		        <tr>
		            <td colspan="2" class=title>�ڻ��Ѱ�</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_asset_tot' size='10' maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_asset_tot' size='10' maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		        </tr>
		        <tr>
		            <td width="3%" rowspan="2" class=title>��<br>
		      ��</td>
		            <td width="9%" class=title>�ں���</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		        </tr>
		        <tr>
		            <td class=title>�ں��Ѱ�</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap_tot' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸��</td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap_tot' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸��</td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>����</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_sale' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_sale' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>��������</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_profit' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_profit' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
    	        </tr>
    	    </table>	     
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%}%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ſ���</span>
	        &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:search_eval_key()" onMouseOver="window.status=''; return true" title="�ſ���ȸ ��üŰ ��ȸ�ϱ�"><img src=/acar/images/center/button_in_cf_dc.gif border=0 align=absmiddle></a>
	    </td>
	</tr>
	<input type='hidden' name="client_guar_st" value="<%=cont_etc.getClient_guar_st()%>">
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
        		  <%int eval_cnt = -1;
        		  	if(client.getClient_st().equals("2")){
        		  		eval3 = a_db.getContEval(rent_mng_id, rent_l_cd, "3", "");
        				if(eval3.getEval_nm().equals("")) eval3.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                <tr>
                    <td class=title>�����<input type='hidden' name='eval_gu' value='3'><input type='hidden' name='e_seq' value='<%=eval3.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval3.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">����</option>
                          <option value="1" <%if(eval3.getEval_off().equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value="2" <%if(eval3.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval3.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">�Է�</option>
                    		<option value="2">����</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval3.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
        				  <%if(eval3.getEval_off().equals("2")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval3.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval3.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval3.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        	<%	  		eval5 = a_db.getContEval(rent_mng_id, rent_l_cd, "5", "");
        				if(eval5.getEval_nm().equals("")) eval5.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                <tr>
                    <td class=title>�����<input type='hidden' name='eval_gu' value='5'><input type='hidden' name='e_seq' value='<%=eval5.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval5.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">����</option>
                          <option value="1" <%if(eval5.getEval_off().equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value="2" <%if(eval5.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval5.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="1">�Է�</option>
                    		<option value="2">����</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval5.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
        				  <%if(eval5.getEval_off().equals("2")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval5.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval5.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval5.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%}else{
        		  		eval1 = a_db.getContEval(rent_mng_id, rent_l_cd, "1", "");
        				if(eval1.getEval_nm().equals("")) eval1.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                <tr id=tr_eval_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>����<input type='hidden' name='eval_gu' value='1'><input type='hidden' name='e_seq' value='<%=eval1.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval1.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">����</option>
                          <option value="1" <%if(eval1.getEval_off().equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value="2" <%if(eval1.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval1.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><input type='hidden' name='eval_score' value=''></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
        				  <%if(eval1.getEval_off().equals("2")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval1.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval1.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd3.length; i++){
        						CodeBean cd = gr_cd3[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center"><input type='text' name='eval_b_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval1.getEval_b_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval1.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){
        		  			eval2 = a_db.getContEval(rent_mng_id, rent_l_cd, "2", "");
        					if(eval2.getEval_nm().equals("")) eval2.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>��ǥ�̻�<%}else{%>����<%}%><input type='hidden' name='eval_gu' value='2'><input type='hidden' name='e_seq' value='<%=eval2.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval2.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">����</option>
                          <option value="1" <%if(eval2.getEval_off().equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value="2" <%if(eval2.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval2.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">�Է�</option>
                    		<option value="">����</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval2.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
        				  <%if(eval2.getEval_off().equals("2")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval2.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval2.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval2.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	
        		  			eval6 = a_db.getContEval(rent_mng_id, rent_l_cd, "6", "");
        					if(eval6.getEval_nm().equals("")) eval6.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>��ǥ�̻�<%}else{%>����<%}%><input type='hidden' name='eval_gu' value='6'><input type='hidden' name='e_seq' value='<%=eval6.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval6.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">����</option>
                          <option value="1" <%if(eval6.getEval_off().equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value="2" <%if(eval6.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval6.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">�Է�</option>
                    		<option value="">����</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval6.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
        				  <%if(eval6.getEval_off().equals("2")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval6.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval6.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval6.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>                
        		  <%	}%>
        		  
        		  <%	
        		  		if(cont_etc.getClient_share_st().equals("1")){
        		  			eval7 = a_db.getContEval(rent_mng_id, rent_l_cd, "7", "");
        					if(eval7.getEval_nm().equals("")) eval7.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title>����������<input type='hidden' name='eval_gu' value='7'><input type='hidden' name='e_seq' value='<%=eval7.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval7.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">����</option>
                          <option value="1" <%if(eval7.getEval_off().equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value="2" <%if(eval7.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval7.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">�Է�</option>
                    		<option value="">����</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval7.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
        				  <%if(eval7.getEval_off().equals("2")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval7.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval7.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval7.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	
        		  			eval8 = a_db.getContEval(rent_mng_id, rent_l_cd, "8", "");
        					if(eval8.getEval_nm().equals("")) eval8.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title>����������<input type='hidden' name='eval_gu' value='8'><input type='hidden' name='e_seq' value='<%=eval8.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval8.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">����</option>
                          <option value="1" <%if(eval8.getEval_off().equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value="2" <%if(eval8.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval8.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">�Է�</option>
                    		<option value="">����</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval8.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
        				  <%if(eval8.getEval_off().equals("2")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval8.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval8.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval8.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>                
        		  <%	}%>
        		          		  
        		  <%}%>
        		  <%if(gur_size > 0){
        		  		for(int i = 0 ; i < gur_size ; i++){
        				Hashtable gur = (Hashtable)gurs.elementAt(i);
        				eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));
        				if(eval4.getEval_nm().equals("")) eval4.setEval_nm(String.valueOf(gur.get("GUR_NM")));
        				eval_cnt++;%>
                <tr>
                    <td class=title>���뺸����<%=i+1%><input type='hidden' name='eval_gu' value='4'><input type='hidden' name='e_seq' value='<%=eval4.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval4.getEval_nm()%>'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">����</option>
                          <option value="1" <%if(eval4.getEval_off().equals("1")) out.println("selected");%>>ũ��ž</option>
                          <option value="2" <%if(eval4.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval4.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">�Է�</option>
                    		<option value="">����</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval4.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
        				  <%if(eval4.getEval_off().equals("2")){
        				    for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("3")){
        					  for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[i];
        						
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("1")){
        				    for(int j =0; j<gr_cd2.length; j++){
        						CodeBean cd = gr_cd2[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval4.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	}
        		  	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڻ���Ȳ</span></td>
	</tr>
	<%int zip_cnt =4;%>
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
        			<td align="center">
        			<% zip_cnt++;%>
                      <select name='ass1_type'>
                          <option value="">����</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode4() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip4').value = data.zonecode;
									document.getElementById('t_addr4').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip4" size="7" maxlength='7' value="<%=eval3.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode4()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr4" size="25" value="<%=eval3.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">����</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode5() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip5').value = data.zonecode;
									document.getElementById('t_addr5').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip5" size="7" maxlength='7' value="<%=eval3.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode5()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr5" size="25" value="<%=eval3.getAss2_addr()%>">
					</td>
                </tr> 
                <input type='hidden' name="ass1_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                <input type='hidden' name="ass2_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                
                  <% }else{%>                
                <tr id=tr_dec_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">                    
                    <td class=title>����</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">����</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode6() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip6').value = data.zonecode;
									document.getElementById('t_addr6').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip6" size="7" maxlength='7' value="<%=eval1.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode6()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr6" size="25" value="<%=eval1.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">����</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode7() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip7').value = data.zonecode;
									document.getElementById('t_addr7').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip7" size="7" maxlength='7' value="<%=eval1.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode7()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr7" size="25" value="<%=eval1.getAss2_addr()%>">
					</td>
                </tr>
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>��ǥ�̻�<%}else{%>����<%}%></td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">����</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode8() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip8').value = data.zonecode;
									document.getElementById('t_addr8').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip8" size="7" maxlength='7' value="<%=eval2.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode8()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr8" size="25" value="<%=eval2.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">����</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode9() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip9').value = data.zonecode;
									document.getElementById('t_addr9').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip9" size="7" maxlength='7' value="<%=eval2.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode9()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr9" size="25" value="<%=eval2.getAss2_addr()%>">
					</td>
                </tr>
                <input type='hidden' name="ass1_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                <input type='hidden' name="ass2_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                
        		  <% 	} %>
        		  
        		  <%	if(cont_etc.getClient_share_st().equals("1")){%>
                <tr>
                    <td class=title>����������</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">����</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode10() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip10').value = data.zonecode;
									document.getElementById('t_addr10').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip10" size="7" maxlength='7' value="<%=eval7.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode10()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr10" size="25" value="<%=eval7.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">����</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode11() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip11').value = data.zonecode;
									document.getElementById('t_addr11').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip11" size="7" maxlength='7' value="<%=eval7.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode11()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr11" size="25" value="<%=eval7.getAss2_addr()%>">
					</td>
                </tr>
                <input type='hidden' name="ass1_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                <input type='hidden' name="ass2_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                
        		  <% 	} %>
        		          		  
        		  <% } %>
        		  <%if(gur_size > 0){
        		  		for(int i = 0 ; i < gur_size ; i++){
        				Hashtable gur = (Hashtable)gurs.elementAt(i);
        				eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));%>		  	  
                <tr>
                    <td class=title>���뺸����<%=i+1%></td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">����</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode0() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip0').value = data.zonecode;
									document.getElementById('t_addr0').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip0" size="7" maxlength='7' value="<%=eval4.getAss1_zip()%>">
						<input type="button" onclick="openDaumPostcode0()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr0" size="25" value="<%=eval4.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
        			<td align="center">
                      <select name='ass2_type'>
                          <option value="">����</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode01() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip01').value = data.zonecode;
									document.getElementById('t_addr01').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
						<input type="text" name="t_zip"  id="t_zip01" size="7" maxlength='7' value="<%=eval4.getAss2_zip()%>">
						<input type="button" onclick="openDaumPostcode01()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr01" size="25" value="<%=eval4.getAss2_addr()%>">
					</td>
                </tr>
        		  <%	}
        		  	}%>		
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
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
                    <td>&nbsp;<textarea name='dec_etc' rows='5' cols='100' maxlenght='500'><%=cont_etc.getDec_etc()%></textarea></td>
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
        			<%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
                    <select name='dec_gr'>
                          <option value=''>����</option>
                          <option value='3' <%if(cont_etc.getDec_gr().equals("3")){%>selected<%}%>>�ż�����</option>
                          <option value='0' <%if(cont_etc.getDec_gr().equals("0")){%>selected<%}%>>�Ϲݰ�</option>
                          <option value='1' <%if(cont_etc.getDec_gr().equals("1")){%>selected<%}%>>�췮���</option>
                          <option value='2' <%if(cont_etc.getDec_gr().equals("2")){%>selected<%}%>>�ʿ췮���</option>
                    </select>
                    </td>                       
                    <td align="center">
                       <select name="dec_f_id">
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cont_etc.getDec_f_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
                    </td>
                    <td align="center"><input type='text' name='dec_f_dt' size='11' maxlength='20' class='text' value="<%=AddUtil.ChangeDate2(cont_etc.getDec_f_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center">
                       <select name="dec_l_id" disabled>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cont_etc.getDec_l_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select> 
                    
                	</td>
                    <td align="center"><input type='text' name='dec_l_dt' size='11' maxlength='20' class='whitetext' value='<%=AddUtil.ChangeDate2(cont_etc.getDec_l_dt())%>' ></td>
                </tr>
            </table>
        </td>
    </tr>
	<%} %>	
	<%if(cng_item.equals("car")){%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                    <td width="13%" class='title'>����</td>
                    <td colspan="<% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>3<%}else{%>5<%}%>">&nbsp;
                      <input type='text' name="sun_per" value='<%=car.getSun_per()%>' size="4" maxlength="4" class='text'> %
                      	
						
						<%if (car.getHipass_yn().equals("")) { // 20181012 �����н����� (������ ������ ���� select���� input���� ���� ó��)%>
								<input type="hidden" name="hipass_yn" value="">
						<%} else {%>
								<input type="hidden" name="hipass_yn" value="<%=car.getHipass_yn()%>">
						<%}%>
                    </td>
                </tr>
                <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>
                <tr>
                	<td width='10%' class='title'>��縵ũ����</td>
                    <td colspan="3">&nbsp;
                        <select name="bluelink_yn">
                            <option value='' <%if(car.getBluelink_yn().equals(""))%>selected<%%>>����</option>
                            <option value='Y' <%if(car.getBluelink_yn().equals("Y"))%>selected<%%>>����</option>
                            <option value='N' <%if(car.getBluelink_yn().equals("N"))%>selected<%%>>����</option>
                        </select>
                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;�� �������ý� ��縵ũ ���� �ȳ��� �˸���߼�(�����ٻ�����)</span>
                    </td>
                </tr>
                <% }else{ %>
                <input type="hidden" name="bluelink_yn" value="<%=car.getBluelink_yn()%>">
                <% } %>
                <tr>
                    <td class='title'>LPG����</td>
                    <td colspan="5" >
        			  <table width="100%" border="0" cellpadding="0" cellspacing="0">
        			  	
                        <tr>
                          <td width="80">&nbsp;
                              <select name='lpg_yn'>
                                <option value="">����</option>
                                <option value="Y" <%if(car.getLpg_yn().equals("Y")) out.println("selected");%>>����</option>
                                <option value="N" <%if(car.getLpg_yn().equals("N")) out.println("selected");%>>������ </option>
                              </select>
                          </td>
                          <td width="110">&nbsp;
                              <select name='lpg_setter'>
                                <option value=''>����</option>
                                <option value='1' <%if(car.getLpg_setter().equals("1")){%> selected <%}%>>������</option>
                                <option value='2' <%if(car.getLpg_setter().equals("2")){%> selected <%}%>>���뿩������</option>
                              </select>
                          </td>
                          <td>&nbsp;
                              <select name='lpg_kit'>
                                <option value=''>����</option>
                                <option value='1' <%if(car.getLpg_kit().equals("1")){%> selected <%}%>>�����л�</option>
                                <option value='2' <%if(car.getLpg_kit().equals("2")){%> selected <%}%>>�����л�</option>
                                <option value='3' <%if(car.getLpg_kit().equals("3")){%> selected <%}%>>�����Ұ�</option>						
                              </select>
                          </td>
                        </tr>
                      </table>
        			</td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">������߰�����</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='add_opt' size='65' class="text" value='<%=car.getAdd_opt()%>'>
        				&nbsp;<input type='text' name='add_opt_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  ��<font color="#666666">(�ΰ������Աݾ�, ���� �ݿ���)</font>
        				<%if(cm_bean.getS_st().equals("801")||cm_bean.getS_st().equals("802")||cm_bean.getS_st().equals("811")||cm_bean.getS_st().equals("821")){%>
        					<%if(!cr_bean.getCar_no().equals("")){ %>
								<br>&nbsp;&nbsp;ȭ���� ���� : 
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="" <%if(car.getVan_add_opt().equals("")){%>checked<%}%>>&nbsp;����
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="1" <%if(car.getVan_add_opt().equals("1")){%>checked<%}%>>&nbsp;����ž/���ٵ�	        				
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="2" <%if(car.getVan_add_opt().equals("2")){%>checked<%}%>>&nbsp;Ȱ�������
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="3" <%if(car.getVan_add_opt().equals("3")){%>checked<%}%>>&nbsp;���߱�/ũ����
							<%} %>		
        				<%}%>	  
                    </td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">�����ݿ���ǰ</span></td>
                    <td colspan="5">&nbsp;
                      <label><input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2ä�� ���ڽ�</label>
                      &nbsp;
                      <label><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> ���� ����(�⺻��)</label>, ���ñ���������:<%=car.getTint_s_per()%>%
                      &nbsp;
                      <label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> ��޽���(��������)</label>, 
                      	����: <input type="text" name="tint_ps_nm" value='<%=car.getTint_ps_nm()%>' size="5">, 
                      	��ǰ�� ���ޱݾ�:<input type="text" name="tint_ps_amt" class='num' value='<%=AddUtil.parseDecimal(car.getTint_ps_amt())%>' size="5" style="text-align:right;" onBlur='javascript:this.value=parseDecimal(this.value);'>�� (�ΰ�������)
                      <br>
                      &nbsp;
      		      <label><input type="checkbox" name="tint_sn_yn" value="Y" <%if(car.getTint_sn_yn().equals("Y")){%>checked<%}%>> ������� �̽ð� ����</label>
                      &nbsp;
      		      <label><input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> ���ڽ� ������ ����
                  &nbsp; ���λ��� : 
                  <select name="tint_bn_nm">
                  		<option value=""  <%if (car.getTint_bn_nm().equals("")){%>selected<%}%>>����</option>
                  		<option value="2" <%if (car.getTint_bn_nm().equals("2")){%>selected<%}%>>������</option>
                   		<option value="1" <%if (car.getTint_bn_nm().equals("1")){%>selected<%}%>>��Ʈ��ķ</option>                   		
                   	</select>
      		       </label>
                      &nbsp;
      		      <label><input type="checkbox" name="tint_cons_yn" value="Y" <%if(car.getTint_cons_yn().equals("Y")){%>checked<%}%>> �߰�Ź�۷�� </label>
      		      <input type="text" name="tint_cons_amt" class='num' value='<%=AddUtil.parseDecimal(car.getTint_cons_amt())%>' size="5" onBlur='javascript:this.value=parseDecimal(this.value);'> ��
                      &nbsp;
      		      <label <%if(!car.getTint_n_yn().equals("Y")){%>style="display :none;"<%}%>><input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> ��ġ�� ������̼�</label>
                      <%if(ej_bean.getJg_g_7().equals("3")){//������%>
                      &nbsp;
                      <label <%if(!car.getTint_eb_yn().equals("Y")){%>style="display: none;"<%}%>><input type="checkbox" name="tint_eb_yn" value="Y" <%if(car.getTint_eb_yn().equals("Y")){%>checked<%}%>> �̵��� ������(������)</label>
                      <%}%>      
                      &nbsp;
                      <%if( !( (Integer.parseInt(ej_bean.getSh_code()) > 9018110 && Integer.parseInt(ej_bean.getSh_code()) < 9018999) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")
                    		  || cm_bean.getCar_comp_id().equals("0044") || cm_bean.getCar_comp_id().equals("0007") || cm_bean.getCar_comp_id().equals("0025") || cm_bean.getCar_comp_id().equals("0033") || cm_bean.getCar_comp_id().equals("0048")) ){ %>
                      ��ȣ�Ǳ���
                      <!-- ������ȣ�ǽ�û -->
                   	<select name="new_license_plate">
                   		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>����</option>
                   		<option value="0" <%if (!(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2"))) {%>selected<%}%>>����</option>                   		
                   	</select>                
                   	<%} %>
                    </td>
                </tr>  
                <tr>
                    <td class='title'><span class="title1">����ǰ��</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='extra_set' size='65' class="text" value='<%=car.getExtra_set()%>'>
        				&nbsp;<input type='text' name='extra_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getExtra_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  ��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����̹ݿ���)</font></span><br>
        					  &nbsp;<input type="checkbox" name="serv_b_yn" value="Y" <%if(car.getServ_b_yn().equals("Y")){%>checked<%}%>> ���ڽ� (2015��8��1�Ϻ���)
        					  <%if(ej_bean.getJg_g_7().equals("3")){ %>
        					  	&nbsp;<input type="checkbox" name="serv_sc_yn" value="Y" <%if(car.getServ_sc_yn().equals("Y")){%>checked<%}%>> ������������
        					  <%} %>
                    </td>
                </tr>		  
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='5' cols='90' name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null") && !String.valueOf(pur_com.get("USE_YN_ST")).equals("����")){%>
	<tr>
        <td><font color='red'>�� Ư�ǹ������� ��Ϻ��Դϴ�. ������ ������ ��� ���¾�ü����-��ü���������� ��ຯ�� ó���Ͻʽÿ�.</font></td>
    </tr> 
    <input type="hidden" name="pur_color" value="<%=pur_com.get("R_COLO")%>">   
    <%}else{ %>
    <input type="hidden" name="pur_color" value="">
	<%} %>	
	<%} %>
	
	<%if(cng_item.equals("car_amt")){%>	
	  
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_car1 style="display:<%if(!base.getCar_gu().equals("0")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>��������</td>
                    <td colspan="3">&nbsp;
                      <select name="purc_gu">
                        <option value=''>����</option>
                        <option value='1' <%if(car.getPurc_gu().equals("1")){%> selected <%}%>>����1</option>
                        <option value='0' <%if(car.getPurc_gu().equals("0")){%> selected <%}%>>����2</option>
                      </select></td>
                    <td class='title'>��ó</td>
                    <td colspan="3">&nbsp;
        			  <%String car_origin = car.getCar_origin();%>
        			  <%if(car_origin.equals("")){
        					code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
        					car_origin = code_bean.getApp_st();
        				}%>
        			  <select name="car_origin">
                        <option value="">����</option>
                        <option value="1" <%if(car_origin.equals("1")){%> selected <%}%>>����</option>
                        <option value="2" <%if(car_origin.equals("2")){%> selected <%}%>>����</option>
                      </select>			
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
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_c_amt()" onMouseOver="window.status=''; return true" title="�Һ��ڰ� �հ� ����ϱ�">�հ�</a></span></td>
                    <td width="13%" class='title'>���ް�</td>
                    <td width="13%" class='title'>�ΰ���</td>
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_f_amt()" onMouseOver="window.status=''; return true" title="���԰� �հ� ����ϱ�">�հ�</a></span></td>
                </tr>
                <tr>
                    <td class='title'> �⺻����</td>
                    <td>&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title>��������</td>
                    <td>&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                </tr>
                <input type="hidden" name="o_car_c_amt" value="<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>">
                <input type="hidden" name="o_car_f_amt" value="<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>">
                <tr>
                    <td height="12" class='title'>�ɼ�</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title>Ź�۷�</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                </tr>
                <tr>
                    <td height="26" class='title'> ����</td>
                    <td>&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td>&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title><span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">����D/C</a></span></td>
                    <td>&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				��</td>
                    <td>&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				��</td>
                    <td>&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				��</td>
                </tr>
              <tr id=tr_ecar_dc <%if(car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>���Ҽ� �����</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>    
                                              
                <tr>
                    <td align="center" class='title_p'>�հ�</td>
                    <td class='title_p'>
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    ��</td>
                    <td class='title_p'>
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title_p'>
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                    <td align='center' class='title_p'>�հ�</td>
                    <td class='title_p'>
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title_p'>
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title_p'>
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                </tr>
                <tr>
                    <td class='title'>���ο���</td>
                    <td>&nbsp;
                      <select name='pay_st'>
                        <option value="">����</option>
                        <option value="1" <%if(car.getPay_st().equals("1")){%> selected <%}%>>����</option>
                        <option value="2" <%if(car.getPay_st().equals("2")){%> selected <%}%>>�鼼</option>
                      </select>
                    </td>
                    <td class='title'>Ư�Ҽ�</td>
                    <td >&nbsp;
                      <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
        				��</td>
                    <td class='title'>������</td>
                    <td >&nbsp;
                      <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
        				��</td>
                    <td class='title'>�հ�</td>
                    <td >&nbsp;
                      <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'>
        				��</td>
                </tr>
            </table>		
	    </td>
    </tr>
    <!-- ������ ���� �� �������� ǥ��(20190911)- �����̰� �ű�/����/��������� ��츸 -->
    <%if(base.getCar_gu().equals("1") && fee_size<=1){ %>
    <tr>
  		<td>
  			<font color="#666666">* ���� ��༭�� ������ ���� �� �������� ���� ǥ�� ����</font>
  			<input type="checkbox" name="dc_view_yn" id="dc_view_yn" <%if(cont_etc.getView_car_dc()!=0){%>checked<%}%> onclick="javascript:span_dc_view();">&nbsp;&nbsp;&nbsp;
  			<span id="span_dc_view" style="display:<%if(cont_etc.getView_car_dc()==0){%> none<%}else{%><%}%>;">
  				<font color="#666666">������ ���� �� �������� 
  					<input type="text" size="10" name="view_car_dc" value="<%=cont_etc.getView_car_dc()%>" onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown='javascript:enter_car(this)'>��
  				</font>
  			</span>
  		</td>
  	</tr>
  	<%}%> 
    			  
    <tr id=tr_car0 style="display:<%if(!base.getCar_gu().equals("1")){%>''<%}else{%>none<%}%>"> 
	<%	int sh_car_amt = 0;
		String sh_year= "";
		String sh_month = "";
		String sh_day = "";
		String sh_day_bas_dt = "";
		int sh_amt = 0;
		float sh_ja = 0;
		int sh_km = 0;
		String sh_km_bas_dt = "";
		String sh_init_reg_dt = "";
		if(fee_etc.getRent_l_cd().equals("")){
			sh_car_amt 	= AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT"));
			sh_year 	= String.valueOf(carOld.get("YEAR"));
			sh_month 	= String.valueOf(carOld.get("MONTH"));
			sh_day	 	= String.valueOf(carOld.get("DAY"));
			sh_km		= AddUtil.parseInt(String.valueOf(sh_ht.get("TODAY_DIST")));
			sh_km_bas_dt= String.valueOf(sh_ht.get("SERV_DT"));
		}else{
			sh_car_amt 	= fee_etc.getSh_car_amt();
			sh_year 	= fee_etc.getSh_year();
			sh_month 	= fee_etc.getSh_month();
			sh_day	 	= fee_etc.getSh_day();
			sh_amt		= fee_etc.getSh_amt();
			sh_ja		= fee_etc.getSh_ja();
			sh_km		= fee_etc.getSh_km();
			sh_km_bas_dt= fee_etc.getSh_km_bas_dt();
			sh_init_reg_dt	= fee_etc.getSh_init_reg_dt();
		}
		if(sh_init_reg_dt.equals("")) sh_init_reg_dt = cr_bean.getInit_reg_dt();
	%>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> �����Һ��ڰ� </td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(sh_car_amt)%>'size='10' class='defaultnum' readonly >
        				  �� <input type='hidden' name="view_car_amt" value=""></td>
                    <td class='title' width="10%">���ʵ����</td>
                    <td width="20%">&nbsp;<input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(sh_init_reg_dt)%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                    <td class='title' width='10%'>����</td>
                    <td>&nbsp;<input type='text' name='sh_year' value='<%=sh_year%>'size='1' class='white' >��
        				  <input type='text' name='sh_month' value='<%=sh_month%>'size='2' class='white' >����
        				  <input type='text' name='sh_day' value='<%=sh_day%>'size='2' class='white' >��
        				  (<input type='text' name='sh_day_bas_dt' value='<%= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='white' >)</td>
                </tr>
                <tr>
                    <td class='title'><%if(base.getCar_gu().equals("0")){%>�߰�����<%}else if(base.getCar_gu().equals("2")){%>�߰������԰�<%}%></td>
                    <td>&nbsp;
                              <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(sh_amt) %>'size='10' class='defaultnum'  readonly>
        					  ��
                    </td>
                    <td class='title' width="10%">�ܰ���</td>
                    <td>&nbsp;
        				  <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher(sh_ja,2) %>'size='4' class='defaultnum' readonly >
        			%</td>
                    <td class='title'>����Ÿ�</td>
                    <td>&nbsp;
                              <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(sh_km) %>' class='defaultnum' >					   
                            km(<input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2(sh_km_bas_dt) %>' class='default' >)</td>
                </tr>
            </table>
	    </td>
    </tr>
    <%if(ej_bean.getJg_w().equals("1")){//������%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ������ ����</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>ī������ݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='import_card_amt' value='<%= AddUtil.parseDecimal(car.getImport_card_amt())%>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    </td>
                    <td width="10%" class='title'>Cash Back�ݾ�</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_cash_back' value='<%= AddUtil.parseDecimal(car.getImport_cash_back())%>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
        	    </td>	
                    <td width="10%" class='title'>Ź�۽��ú���</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_bank_amt' value='<%= AddUtil.parseDecimal(car.getImport_bank_amt())%>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
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
                    <td width="20%">&nbsp;
        		<input type='text' name='r_import_cash_back' value='<%= AddUtil.parseDecimal(car.getR_import_cash_back())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
        	    </td>	
        	    <td width="10%" class='title'>Ź�۽��ú���</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='r_import_bank_amt' value='<%= AddUtil.parseDecimal(car.getR_import_bank_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
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
                    <td width="27%">&nbsp;
                        <input type='text' name='ecar_pur_sub_amt' value='<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    </td>
                    <td width="10%" class='title'>�����ݼ��ɹ��</td>
                    <td>&nbsp;
        		            <select name='ecar_pur_sub_st' disabled>
        		            	<option value="">����</option>
                          <option value="1" <%if(car.getEcar_pur_sub_st().equals("1")){%> selected <%}%>>������ ������� ����</option>
                          <option value="2" <%if(car.getEcar_pur_sub_st().equals("2")){%> selected <%}%>>�Ƹ���ī ���� ����</option>
                        </select>        		            
        	          </td>	                    
                </tr>
            </table>
	    </td>
    </tr>                 
    <%}%>                       
<script language="JavaScript">
<!--	
	sum_car_c_amt();
	sum_car_f_amt();
//-->
</script>	
	<%} %>	
	<%if(cng_item.equals("insur")){%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>��������</td>
                    <td width="20%">&nbsp;
                        <select name='insurant'>                          
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                      </select></td>
                    <td width="10%"  class=title>�Ǻ�����</td>
                    <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' onChange='javascript:display_ip()'>
                          <option value="">����</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <%if(cont_etc.getInsur_per().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>
                          <%}%>
                      </select></td>
                </tr>
                <tr> 
                    <td width="13%" class=title>�����ڹ���</td>
                    <td width="20%" class=''>&nbsp;
        			<select name='driving_ext'>
                          <option value="">����</option>
                          <option value="1" <%if(base.getDriving_ext().equals("1")){%> selected <%}%>>�����</option>
                          <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>��������</option>
                          <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>��Ÿ</option>
                      </select>
        			</td>
                    <td width="10%" class=title >�����ڿ���</td>
                    <td>&nbsp;
                        <select name='driving_age'>
                          <option value="">����</option>
                          <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>26���̻�</option>
                          <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>24���̻�</option>
                          <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>21���̻�</option>
                          <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>��������</option>
					  <option value=''>=�Ǻ����ڰ�=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>30���̻�</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>35���̻�</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>43���̻�</option>						
					  <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>48���̻�</option>					  						  						  
					  <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>22���̻�</option>					  						  						  
					  <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>28���̻�</option>					  						  						  
					  <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>35���̻�~49������</option>					  						  						  
                      </select></td>
                <td class=title >��������������Ư��</td>
                <td class=''>&nbsp;<%if(base.getCar_st().equals("4") && !cont_etc.getCom_emp_yn().equals("Y") && !client.getClient_st().equals("2") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){ cont_etc.setCom_emp_yn("Y"); }%>
                  <select name='com_emp_yn'>
                    <option value="">����</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                  </select></td>                        
                </tr>                
                <tr>
                    <td width="13%" class=title>���ι��</td>
                    <td width="20%">&nbsp; ����(���ι��,��)</td>
                    <td width="10%" class=title>�빰���</td>
                    <td width="20%" class=''>&nbsp;
                        <select name='gcp_kd'>
                          <option value="">����</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1���</option>
						  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2���</option>
						  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3���</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5���</option>	
                          <option value="9" <% if(base.getGcp_kd().equals("9")) out.print("selected"); %>>10���</option>						  						  
                      </select></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td class=''>&nbsp;
                        <select name='bacdt_kd'>
                          <option value="">����</option>
                          <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                          <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1���</option>
                          <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>�̰���</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>������������</td>
                    <td>&nbsp;
                      <select name='canoisr_yn'>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getCanoisr_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>            </td>
                    <td class=title>�ڱ���������</td>
                    <td class=''>&nbsp;
                      <select name='cacdt_yn'>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>              </td>
                    <td class=title >����⵿</td>
                    <td class=''>&nbsp;
                      <select name='eme_yn'>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getEme_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getEme_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>������å��</td>
                    <td>&nbsp;
        			<input type='text' size='12' maxlength='10' name='car_ja' class='num' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			��</td>
                    <td class=title>�������</td>
                    <td class=''>&nbsp;
                      <input type='text' size='18' name='ja_reason' class='text' value='<%=cont_etc.getJa_reason()%>'></td>
                    <td class=title >������</td>
                    <td class=''>&nbsp;
                        <select name='rea_appr_id'>
                          <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cont_etc.getRea_appr_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select> 
                        (�⺻ <input type='text' size='6' maxlength='10' name='imm_amt' class='whitenum' value='<%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%>' readonly>��) </td>
                </tr>
                <%if(!base.getCar_st().equals("4")){%>
                <tr>
                    <td  class=title>�ڵ���</td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="air_ds_yn" 	value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%>checked<%}%>>
        				�����������
                      <input type="checkbox" name="air_as_yn" 	value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%>checked<%}%>>
        				�����������
                     <input type="checkbox" name="blackbox_yn" 	value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%>checked<%}%>>
        				���ڽ�
             		 <input type="checkbox" name="lkas_yn" id="lkas_yn" value="Y" <%if(cont_etc.getLkas_yn().equals("Y")){%>checked<%}%> disabled>
					  ����(����)   				                
					 <input type="checkbox" name="ldws_yn" id="ldws_yn" value="Y" <%if(cont_etc.getLdws_yn().equals("Y")){%>checked<%}%> disabled>
					  ����(���)   				                
					 <input type="checkbox" name="aeb_yn" id="aeb_yn" value="Y" <%if(cont_etc.getAeb_yn().equals("Y")){%>checked<%}%> disabled>
					  ���(����)   				                
					 <input type="checkbox" name="fcw_yn" id="fcw_yn" value="Y" <%if(cont_etc.getFcw_yn().equals("Y")){%>checked<%}%> disabled>
					  ���(���)   				                
					 <input type="checkbox" name="ev_yn" 	id="ev_yn" value="Y" <%if(cont_etc.getEv_yn().equals("Y")){%>checked<%}%> disabled>
					  ������   
					  <br/>
					   &nbsp; 	
					 <input type="checkbox" name="hook_yn" 	id="hook_yn" value="Y" <%if(cont_etc.getHook_yn().equals("Y")){%>checked<%}%>>
					  ���ΰ�(Ʈ���Ϸ���)
					  &nbsp;   
					  <input type="checkbox" name="legal_yn" id="legal_yn"	value="Y" <%if(cont_etc.getLegal_yn().equals("Y")){%>checked<%}%> disabled>
					  �������������(�����)
					  &nbsp; 	
					  <input type="checkbox" name="top_cng_yn" 	id="top_cng_yn" value="Y" <%if(cont_etc.getTop_cng_yn().equals("Y")){%>checked<%}%>>
					  ž��(��������)   
        				<br/>
        				&nbsp;  
        				��Ÿ��ġ : 
                      <input type="text" class="text" name="others_device" value="<%=cont_etc.getOthers_device()%>" size="50"> <!-- (���ΰ� �� ��Ÿ��ġ) --> 				

                      </td>
                </tr>
                <tr>
                    <td  class=title>��������<br>��&nbsp;��&nbsp;��<br>��������</td>
                    <td colspan="5">&nbsp;
                      		  <input type="checkbox" name="ac_dae_yn" 	value="Y" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>> 
                      		  ����������<%if(ac_dae_yn_chk.equals("N")){%>(���ػ��� ����)<%}%><br>
        			  &nbsp;
        			  <input type="checkbox" name="pro_yn" 		value="Y" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>> 
        			  ������ �߻��� ���ó�� �������� (����� ���� ���� ��) <br>
        			  &nbsp;
        			  <%if(cyc_yn_chk.equals("Y")){%>
        			  <input type="checkbox" name="cyc_yn" 		value="Y" <%if(cont_etc.getCyc_yn().equals("Y")){%>checked<%}%>> 
                      		  �� 7,000km �Ǵ� ����û�� ��ȸ���� ���� �ǽ� <br>
        			  &nbsp;        			  
        			  <input type="checkbox" name="main_yn" 	value="Y" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>> 
                      		  ��ü�� ���񼭺�(���α�����ǰ �� �Ҹ�ǰ ��ȯ, �������� ��ȯ ��) <br>
        			  &nbsp;
                      		  <%}else{%>
        			  <input type="checkbox" name="main_yn" 	value="Y" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>> 
                      		  ��ü�� ���񼭺�(���� ��������ǰ/�Ҹ�ǰ  ����,��ȯ,����) * ������ ���� ��޼��� ���� <br>
        			  &nbsp;
                      		  <%}%>
        			  <input type="checkbox" name="ma_dae_yn" 	value="Y" <%if(cont_etc.getMa_dae_yn().equals("Y")){%>checked<%}%>> 
                      		  �����������(4�ð� �̻� ������� �԰��) <br>
        			  </td>
                </tr>
                <tr id=tr_ip style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                    <td  class=title>�Ժ�ȸ��</td>
                    <td colspan="5">
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">&nbsp;�����  :
                                    <input type='text' name='ip_insur' value='<%=cont_etc.getIp_insur()%>' size='12' class='text'>
                      				&nbsp;�븮�� : 
                      				<input type='text' name='ip_agent' value='<%=cont_etc.getIp_agent()%>' size='15' class='text'>
                      				&nbsp;����� :
                      				<input type='text' name='ip_dam' value='<%=cont_etc.getIp_dam()%>' size='10' class='text'>
                					&nbsp;����ó :
                					<input type='text' name='ip_tel' value='<%=cont_etc.getIp_tel()%>' size='13' class='text'>
                					</td>
                            </tr>
                        </table>
                    </td>
                </tr>
              <tr id=tr_ip2 style="display:<%if(cont_etc.getInsur_per().equals("2")){%>''<%}else{%>none<%}%>">
                <td  class=title>��������</td>
                <td colspan="5">
                    <table width="100%" border="0" cellpadding="0">
                      <tr>
                        <td width="100%">&nbsp;���������������
					  <select name='cacdt_mebase_amt' onChange="javascript:setCacdtMeAmt();" align="absmiddle">
					    <option value=""    <%if(cont_etc.getCacdt_mebase_amt()==0  ){%>selected<%}%>>����</option>
					    <option value="50"  <%if(cont_etc.getCacdt_mebase_amt()==50 ){%>selected<%}%>>50����</option>
					    <option value="100" <%if(cont_etc.getCacdt_mebase_amt()==100){%>selected<%}%>>100����</option>
					    <option value="150" <%if(cont_etc.getCacdt_mebase_amt()==150){%>selected<%}%>>150����</option>
					    <option value="200" <%if(cont_etc.getCacdt_mebase_amt()==200){%>selected<%}%>>200����</option>
					  </select>
					  / (�ִ�)�ڱ�δ�� 
                      <input type='text' size='6' name='cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(cont_etc.getCacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      ���� 
					  / (�ּ�)�ڱ�δ��  
                      <select name='cacdt_memin_amt'>
                        <option value=""   <%if(cont_etc.getCacdt_memin_amt()==0 ){%>selected<%}%>>����</option>
                        <option value="5"  <%if(cont_etc.getCacdt_memin_amt()==5 ){%>selected<%}%>>5����</option>
                        <option value="10" <%if(cont_etc.getCacdt_memin_amt()==10){%>selected<%}%>>10����</option>
                        <option value="15" <%if(cont_etc.getCacdt_memin_amt()==15){%>selected<%}%>>15����</option>
                        <option value="20" <%if(cont_etc.getCacdt_memin_amt()==20){%>selected<%}%>>20����</option>
                      </select>      
                			    </td>
                      </tr>
                    </table>
                 </td>
                </tr>								
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;
                            <textarea rows='3' cols='90' name='others'><%=base.getOthers()%></textarea></td>
                </tr>
                <%}else{
                	//fee_rm
			ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");%>
                <tr>
                    <td class='title'>���������</td>
                    <td colspan="5">&nbsp;
                        <select name="my_accid_yn">
                            <option value="Y" <%if(fee_rm.getMy_accid_yn().equals("Y"))%>selected<%%>>���δ�</option>
                            <option value="N" <%if(fee_rm.getMy_accid_yn().equals("N"))%>selected<%%>>����</option>
                        </select>
                    </td>
                </tr>                 
                <%}%>
            </table>
        </td>
    </tr>	
	<%} %>	
	<%if(cng_item.equals("gi")){%>	
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr id=tr_gi style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1' onClick="javascript:display_gi()" <%if(gins.getGi_st().equals("1")){%> checked <%}%>>
                  		����
                  		<input type='radio' name="gi_st" value='0' onClick="javascript:display_gi()" <%if(gins.getGi_st().equals("0")){%> checked <%}%>>
                  		���� </td>
                </tr>
        		  
                <tr id=tr_gi1 style="display:<%if(gins.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>��������</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value='<%=gins.getGi_no()%>'>
                    <input type='hidden' name='gi_rent_st' value='<%=max_fee.getRent_st()%>'>                    
        			   <input type='text' name='gi_jijum' value='<%=gins.getGi_jijum()%>' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>���Աݾ�</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                    <td width="10%" class=title >���������</td>
                    <td>&nbsp;
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='<%=AddUtil.parseDecimal(gins.getGi_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                </tr>
                <tr id=tr_gi2 style="display:<%if(gins.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>���ǹ�ȣ</td>
                    <td width="20%">&nbsp;��<input type='text' name='gi_no' value='<%=gins.getGi_no()%>' size='12' class='text'>ȣ</td>
                    <td width="10%" class='title'>����Ⱓ</td>
                    <td width="20%" >&nbsp;<input type="text" name="gi_start_dt" value="<%=AddUtil.ChangeDate2(gins.getGi_start_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>~<input type="text" name="gi_end_dt" value="<%=AddUtil.ChangeDate2(gins.getGi_end_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                    <td class=title >���谡������</td>
                    <td>&nbsp;<input type="text" name="gi_dt" value="<%=AddUtil.ChangeDate2(gins.getGi_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>		  
            </table>
        </td>
    </tr>
	<%} %>	
	<%if(cng_item.equals("fee")){%>	
  <!--�������-->
  <input type="hidden" name="car_cs_amt"   		value="<%=car.getCar_cs_amt()%>">  
  <input type="hidden" name="car_cv_amt"   		value="<%=car.getCar_cv_amt()%>">
  <input type="hidden" name="car_c_amt"   		value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">  
  <input type="hidden" name="car_fs_amt"   		value="<%=car.getCar_fs_amt()%>">  
  <input type="hidden" name="car_fv_amt"   		value="<%=car.getCar_fv_amt()%>">    
  <input type="hidden" name="car_f_amt"   		value="<%=car.getCar_fs_amt()+car.getCar_fv_amt()%>">      
  <input type="hidden" name="opt_cs_amt"   		value="<%=car.getOpt_cs_amt()%>">  
  <input type="hidden" name="opt_cv_amt"   		value="<%=car.getOpt_cv_amt()%>">    
  <input type="hidden" name="opt_c_amt"   		value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">    
  <input type="hidden" name="sd_cs_amt"   		value="<%=car.getSd_cs_amt()%>">  
  <input type="hidden" name="sd_cv_amt"   		value="<%=car.getSd_cv_amt()%>">    
  <input type="hidden" name="sd_c_amt"   		value="<%=car.getSd_cs_amt()+car.getSd_cv_amt()%>">      
  <input type="hidden" name="col_cs_amt"   		value="<%=car.getClr_cs_amt()%>">  
  <input type="hidden" name="col_cv_amt"   		value="<%=car.getClr_cv_amt()%>">    
  <input type="hidden" name="col_c_amt"   		value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">      
  <input type="hidden" name="dc_cs_amt"   		value="<%=car.getDc_cs_amt()%>">  
  <input type="hidden" name="dc_cv_amt"   		value="<%=car.getDc_cv_amt()%>">    
  <input type="hidden" name="dc_c_amt"   		value="<%=car.getDc_cs_amt()+car.getDc_cv_amt()%>">        
  <input type="hidden" name="spe_tax"   		value="<%=car.getSpe_tax()%>">  
  <input type="hidden" name="edu_tax"   		value="<%=car.getEdu_tax()%>">
  <input type="hidden" name="tot_tax"   		value="<%=car.getSpe_tax()+car.getEdu_tax()%>">
  <input type='hidden' name='gi_amt' 			value='<%=gins.getGi_amt()%>'> 	
  <input type='hidden' name='rent_st' 			value='<%=rent_st%>'> 	
  <input type='hidden' name="car_ja"			value="<%=base.getCar_ja()%>">  
  <input type='hidden' name="gcp_kd"			value="<%=base.getGcp_kd()%>">    
  <input type='hidden' name="driving_age"		value="<%=base.getDriving_age()%>">    
  <input type='hidden' name="eme_yn"			value="<%=cont_etc.getEme_yn()%>">
  <input type='hidden' name="car_ext"			value="<%=car.getCar_ext()%>">
  <input type='hidden' name="gi_st"				value="<%=gins.getGi_st()%>">    
  <input type='hidden' name="rent_way"			value="<%=fees.getRent_way()%>">   
  <input type='hidden' name='sh_amt' 			value='<%=fee_etc.getSh_amt()%>'>
  <input type='hidden' name='sh_car_amt' 		value='<%=fee_etc.getSh_car_amt()%>'>  
  <input type='hidden' name='purc_gu' 			value='<%=car.getPurc_gu()%>'>    
  <input type='hidden' name='dec_gr' 			value='<%=cont_etc.getDec_gr()%>'>      
  <input type='hidden' name='spr_kd' 			value='<%=base.getSpr_kd()%>'>      
  <input type="hidden" name="add_opt_amt"  		value="<%=car.getAdd_opt_amt()%>">        
  <input type="hidden" name="fee_opt_amt"  		value="<%=fee_opt_amt%>">        
  <input type="hidden" name="lpg_price"  		value="<%=car.getLpg_price()%>">          
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                
    		    <%if(!fees.getRent_st().equals("1")){%>
                <tr>
                    <td width="13%" align="center" class=title>�������</td>
                    <td width="20%">&nbsp;
					  <%if(nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
        			  <input type="text" name="rent_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(fees.getRent_dt())%>
					  <input type='hidden' name='rent_dt' 	value='<%=fees.getRent_dt()%>'>
					  <%}%>							
        			</td>
                    <td width="10%" align="center" class=title>�������</td>
                    <td>&nbsp;
        			  <select name='ext_agnt'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(fees.getExt_agnt().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
                    <td width="10%" align="center" class=title>�����븮��</td>
                    <td>&nbsp;
        			  <select name='bus_agnt_id'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(fee_etc.getBus_agnt_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>			  
                </tr>
    		<%}else{%>
              <!-- �縮���� �����ε������� �Է� -->
              <%if(base.getCar_gu().equals("0")){ %>
              <tr>
                <td width="13%" align="center" class=title>�����ε�������</td>
                <td colspan='5'>&nbsp;
                    <input type='text' size='12' name='car_deli_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
					 (�縮������� �� �����ε������� ���� ���躯���մϴ�. �ε� Ȯ���� �ٽ� Ȯ���Ͻʽÿ�.)
					 </td>
              </tr>              
              <%}%>    		
                <tr>
                    <td width="13%" align="center" class=title>�����ε���</td>
                    <td colspan='5'>&nbsp;
        			  <input type="text" name="car_deli_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>" size="12" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                    </td>
                </tr>			
			<%}%>
                <tr>
                    <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date()'>
            			 ����</td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="12" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date();'></td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td>&nbsp;
                    <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="12" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="3" class='title'>����</td>
                    <td class='title' width='11%'>���ް�</td>
                    <td class='title' width='11%'>�ΰ���</td>
                    <td class='title' width='14%'>�հ�</td>
                    <td class='title' width='4%'>�Ա�</td>			
                    <td width="27%" class='title'>�������</td>
                    <td class='title' width='20%'>��������</td>
                </tr>
                <tr>
                    <td width="3%" rowspan="5" class='title'>��<br>
                      ��</td>
                    <td width="10%" class='title' colspan="2">������</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>��</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  �� </td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fees.getGur_p_per()%>'>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_gur_p_per' class='fixnum' value='<%=fees.getF_gur_p_per()%>' readonly>
    				            %
        				    </td>
                    <td align='center'>
        			  <%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%>
        			  <input type='hidden' name='gur_suc_yn' value='<%=fees.getGrt_suc_yn()%>'>
        			  <input type='hidden' name='gur_per' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">������</td>
                    <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  �� </td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=fees.getPere_r_per()%>'>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_pere_r_per' class='fixnum' value='<%=fees.getF_pere_r_per()%>' readonly>
    				            %  
        				    </td>
                    <td align='center'>-<input type='hidden' name='pere_per' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">���ô뿩��</td>
                    <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='ifee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  �� </td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2")%></td>
                    <td align="center">������
                        <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=fees.getPere_r_mth()%>'>
        				  ����ġ �뿩�� </td>
                    <td align='center'>
        			  <%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%>
        			  <input type='hidden' name='ifee_suc_yn' value='<%=fees.getIfee_suc_yn()%>'>
        			  <input type='hidden' name='pere_mth' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">�հ�</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_s_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='tot_pp_v_amt' maxlength='10' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='tot_pp_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">�Աݿ����� :
                          <input type='text' size='11' name='pp_est_dt' maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">��ä��Ȯ��</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>						
                    <td align='center'>-</td>									
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='<%=fees.getCredit_r_per()%>'>%
    			    <input type='text' size='10' name='credit_r_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>'>��(������������)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='<%=fees.getCredit_per()%>' >%
    			    <input type='text' size='10' name='credit_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' >��</td>
                </tr>
                <tr>
                    <td rowspan="3" class='title'>��<br>
                      ��</td>
                    <td class='title' colspan="2">�ִ��ܰ�</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='ja_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align='center'>
        			  �ִ��ܰ���:������
                          <input type='text' size='4' name='max_ja' maxlength='10' readonly class=defaultnum value='<%=fees.getMax_ja()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
                          %</td>
                    <td align='center'>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">���Կɼ�</td>
                    <td align="center"><input type='text' size='10' name='opt_s_amt' maxlength='11' readonly class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='opt_v_amt' maxlength='10' readonly class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='opt_amt' maxlength='11' readonly class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
                        <input type='text' size='4' name='opt_per' readonly class='whitenum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  % 
        				        &nbsp;&nbsp;&nbsp;������
    				            <input type='text' size='4' name='f_opt_per' class='whitenum' value='<%=fees.getF_opt_per()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				            %  
        				    </td>
                    <td align='center'><input type='radio' name="opt_chk" value='0' <%if(fee.getOpt_chk().equals("0")){%> checked <%}%>>
                      ����
                      <input type='radio' name="opt_chk" value='1' <%if(fee.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		  ����</td>
                </tr>
                <%if(fee_etc.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ���������� %>
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
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='ja_r_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'>-</td>				  
                    <td align="center">������
        			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="defaultnum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>		  
                <%}%>
                <tr>
                    <td rowspan="5" class='title'>��<br>��<br>��</td>
                    <td class='title' colspan="2">�����</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align="center" ><input type='text' size='9'  name='fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)' readonly>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">DC��:
                      <input type='text' size='4' name='dc_ra' maxlength='10' class="num" value='<%=fees.getDc_ra()%>'>
                    </font>%</span></td>
                    <td align='center'>-</td>
                </tr>                
                <!-- �������߰����/�������(���Ǻ���) ���� (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">��<br>��<br>��<br>��<br>��</td>
                    <td class='title'>������</td>
                    <td align="center" ><input type='text' size='10' name='inv_s_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='9' name='inv_v_amt' readonly maxlength='9' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' readonly name='inv_amt' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">��������<span class="contents1_1">
                      <input type='text' size='11' name='bas_dt' maxlength='10' readonly class="text" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </span></td>
                    <td align='center'>&nbsp;
                    </td>
                </tr>
                  <tr>
                    <td class='title'>�������(���Ǻ���)</td>
                    <td align="center" ><input type='text' size='10' name='ins_s_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='9' name='ins_v_amt' readonly maxlength='9' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='ins_amt' readonly class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center">-</td>
                    <td align="center">&nbsp;�������(���ް�) = �Ⱓ�����
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' readonly class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 ��/12</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
	                <td class='title'>�������߰����</td>
	                <td align="center">
	                	<input type='text' size='10' name='driver_add_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> �� 
	                </td>
	                <td align="center" >
	                	<input type='text' size='9' name='driver_add_v_amt' readonly  maxlength='9' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center' >
	                	<input type='text' size='10' maxlength='10'  name='driver_add_total_amt' readonly class='defaultnum' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	            </tr>
                <tr>
                    <td class='title'>������ �հ�</td>
                    <td align="center">
                    	<input type='text' size='10' name='tinv_s_amt' maxlength='11' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etc.getDriver_add_amt())%>'> ��
                    </td>
                    <td align="center" >
                       	<input type='text' size='9' name='tinv_v_amt'  maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center' >
                    	<input type='text' size='10' maxlength='10'  name='tinv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etc.getDriver_add_amt() + fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
                
              <!--20130605 ������������Ÿ� �-->    
              <%if(AddUtil.parseInt(fees.getRent_dt()) > 20130604){%>          
              <tr>
                <td colspan="3" class='title'><span class="title1">��������Ÿ�</span></td>
                <td colspan="5">&nbsp;
		  		  <input type='text' name='agree_dist' size='8' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  km����/1��,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (�������Ͽ����) ȯ�޴뿩��  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��/1km (�ΰ�������)
                  <%	if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
                  <select name='rtn_run_amt_yn' >        
                    <option value="">����</option>                      
                    <option value="0" <%if(fee_etc.getRtn_run_amt_yn().equals("0")||fee_etc.getRtn_run_amt_yn().equals(""))%>selected<%%>>ȯ�޴뿩������</option>
                    <option value="1" <%if(fee_etc.getRtn_run_amt_yn().equals("1"))%>selected<%%>>ȯ�޴뿩�������</option>                    
                  </select>
                  <%	}else{ %>
                  <%		if(fee_etc.getRtn_run_amt_yn().equals("")){
                	  			fee_etc.setRtn_run_amt_yn("0");
                  			} 
                  %>
                  <%if(fee_etc.getRtn_run_amt_yn().equals("0")){%>��ȯ�޴뿩������<%}else if(fee_etc.getRtn_run_amt_yn().equals("1")){%>��ȯ�޴뿩�������<%} %>
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etc.getRtn_run_amt_yn()%>">
                  <%	} %>
                  <%}else{ %>
                  <input type="hidden" name="rtn_run_amt" value="<%=fee_etc.getRtn_run_amt()%>">
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etc.getRtn_run_amt_yn()%>">
                  <%} %>    
                  <br>&nbsp;              
                  (�����ʰ������) �ʰ�����뿩�� <input type='text' name='over_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��/1km (�ΰ�������)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  ���Կɼ� ���� ȯ�޴뿩�� : �⺻���� ������, �Ϲݽ��� 40%�� ����
                  <%} %>
                  <br>&nbsp;                  
                  ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>�� ����
                  <!-- 
                  �ʰ� 1km�� (<input type='text' name='over_run_amt' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��)�� �ʰ�����δ���� �ΰ��� (�뿩�����)	
                  <br>&nbsp;
                  ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� 50%�� ����
                   -->
                  <input type="hidden" name="agree_dist_yn" value="<%=fee_etc.getAgree_dist_yn()%>">
                  <!--      
                  <select name='agree_dist_yn'>                              
                    <option value="" <%if(fee_etc.getAgree_dist_yn().equals(""))%>selected<%%>>����</option>
                    <option value="1" <%if(fee_etc.getAgree_dist_yn().equals("1"))%>selected<%%>>���׸���(�⺻��)</option>
                    <option value="2" <%if(fee_etc.getAgree_dist_yn().equals("2"))%>selected<%%>>50%�� ����(�Ϲݽ�)</option>
                    <option value="3" <%if(fee_etc.getAgree_dist_yn().equals("3"))%>selected<%%>>���Կɼ� ����(�⺻��,�Ϲݽ�)</option>
                  </select>	
                  -->
                </td>
                <td align='center'>
                    <%if(AddUtil.parseInt(fees.getRent_dt()) > 20130604){
                  	e_bean = edb.getEstimateCase(fee_etc.getBc_est_id());
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
                    <input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>' >/1��,<br>&nbsp;
                    <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%> 
                    <input type='text' name='e_rtn_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>' >/1km,<br>&nbsp;
                    <%}else{ %>
                  	<input type="hidden" name="e_rtn_run_amt" value="<%=e_bean.getRtn_run_amt()%>">
                  	<%} %>    
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,<br>&nbsp;
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>                
              </tr>     
              <tr>
                <td colspan="3" class='title'><span class="title1">����������Ÿ�</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='over_bas_km' size='8' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getOver_bas_km())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  km
                        (�縮�� ������ ������ ����Ÿ�, ��༭ ���� ��),
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        ���� ����Ÿ� <input type='text' name='cust_est_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etc.getCust_est_km())%>' >
                        km/1��
                </td>
                <td align='center'></td>
              </tr>                      
              <%}%>	                
    		    <%if(rent_st.equals("1")){%>
                <tr>
                    <td colspan="3" class='title'>��������</td>
                    <td colspan="2" align="center">
        			  �������:
        			  <select name='commi_car_st'>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>��������</option>
                      </select>
        			</td>
                    <td align='center'><input type='text' size='11' name='commi_car_amt' <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%><%}else{%>readonly<%}%> maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">
        				  ��</td>
                    <td align='center'>-<input type='hidden' name='commi' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>'></td>				  
                    <td align="center">
                        <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum' onBlur='javascript:setCommi()' <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%><%}else{%>readonly<%}%>>
        		      %</td>
                    <td align='center'>
        				<input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum' <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%><%}else{%>readonly<%}%>>
        			  %</td>
                </tr>		
    		    <%}%>  
                <tr>
                    <td colspan="3" class='title'>�ߵ�����������</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">�ܿ��Ⱓ �뿩����
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='whitenum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='whitenum' value='<%=fees.getCls_per()%>'>%
						,�ʿ��������[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                </tr>		
                <%-- <tr>
                    <td colspan="2" class='title'>�������߰����</td>
                    <td colspan="6">&nbsp;
                    	<input type='text' size='10' name='driver_add_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_etc.getDriver_add_amt())%>'>
        				  �� (���ް�)</td>                  
                </tr> --%>                  
    		    <%if(rent_st.equals("1")){
					//�������������
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}%>
                <tr>
                    <td colspan="3" class='title'>���������</td>
                    <td colspan="6">&nbsp;
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;����ȣ : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;�����ڵ庰���� ���� : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;					  
					  <span class="b"><a href="javascript:cancel_grt_suc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[���������ݽ°�]</b>
					  &nbsp;���������� : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  �°躸���� : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum'  onBlur="javascript:document.form1.grt_suc_cha_amt.value=parseDecimal(toInt(parseDigit(document.form1.grt_suc_o_amt.value))-toInt(parseDigit(document.form1.grt_suc_r_amt.value)));">��
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(���������� ���� <input type='text' name='grt_suc_cha_amt' size='10' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>' class='whitenum'>)</font>
					  <%}else{ %>
					  <input type='hidden' name='grt_suc_cha_amt' 	value=''>
					  <%} %>
        			</td>
                </tr>		
    		    <%}%>  	
    		    
    		    							
				
				  		  
			  <input type='hidden' name='bus_agnt_r_per' 	value='<%=fee_etc.getBus_agnt_r_per()%>'>
			  <input type='hidden' name='bus_agnt_per' 		value='<%=fee_etc.getBus_agnt_per()%>'>
			  <input type='hidden' name='cls_n_mon' 		value='<%=fee_etc.getCls_n_mon()%>'>
			  <input type='hidden' name='cls_n_amt' 		value='<%=fee_etc.getCls_n_amt()%>'>
			  <input type='hidden' name='min_agree_dist' 	value='<%=fee_etc.getMin_agree_dist()%>'>
			  <input type='hidden' name='max_agree_dist' 	value='<%=fee_etc.getMax_agree_dist()%>'>			  			  
			  <input type='hidden' name='over_serv_amt' 	value='<%=fee_etc.getOver_serv_amt()%>'>				
			  <input type='hidden' name='over_run_day' 		value='<%=fee_etc.getOver_run_day()%>'>
				  												  		    
                <tr>
                    <td colspan="3" class='title'>������</td>
                    <td colspan="6">&nbsp;<select name='fee_sac_id'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(fees.getFee_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
                </tr>
                <tr>
                    <td colspan="3" class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
                    <td colspan="6">&nbsp;<textarea rows='5' cols='90' name='fee_cdt'><%=fees.getFee_cdt()%></textarea></td>
                </tr>
            </table>		
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>����Ƚ��</td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='fee_pay_tm' value='<%=fees.getFee_pay_tm()%>' maxlength='2' class='text' >
        				ȸ </td>
                    <td width="10%" class='title'>��������</td>
                    <td width="20%">&nbsp;�ſ�
                      <select name='fee_est_day'>
                        <option value="">����</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                        <option value='<%=i%>' <%if(fees.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                        <% } %>
                        <option value='99' <%if(fees.getFee_est_day().equals("99")){%> selected <%}%>> ���� </option>
						<option value='98' <%if(fees.getFee_est_day().equals("98")){%> selected <%}%>> �뿩������ </option>
                      </select></td>
                    <td width="10%" class='title'>���ԱⰣ</td>
                    <td>&nbsp;
                      <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
    			        <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		  		  	
                <tr>
                    <td width="13%" class='title'>1ȸ��������</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='fee_fst_dt' value='<%=AddUtil.ChangeDate2(fees.getFee_fst_dt())%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				</td>
                    <td width="10%" class='title'>1ȸ�����Ծ�</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name='fee_fst_amt' value='<%=AddUtil.parseDecimal(fees.getFee_fst_amt())%>' maxlength='10' size='10' class='num'>��
                      </td>
                </tr>		  		  		  		  		  	  
    		</table>		
	    </td>
    </tr>
    <tr></tr><tr></tr>
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
            				    <td align="center">E-1</td>
            				    <td align="center">bc_b_e1</td>				  
            				    <td>&nbsp;�������󰡴�����簡ġ����¼��ǱⰣ�ݿ���</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e1' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;����忹��������</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e2' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;��Ÿ���</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='num' value='<%=fee_etc.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='bc_b_u_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_u_cont()%>'>
            				  </td>
            				</tr>							
            		        <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;��Ÿ����</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='num' value='<%=fee_etc.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='bc_b_g_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_g_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;��Ÿ ����ȿ���ݿ���</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='num' value='<%=fee_etc.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='bc_b_ac_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_ac_cont()%>'></td>
            				</tr>
            		        <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_etc</td>				  
            				  <td>&nbsp;�������ǻ���</td>
            				  <td align="center"><textarea rows='5' cols='70' name='bc_etc'><%=fee_etc.getBc_etc()%></textarea></td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
    </tr>				
<script language="JavaScript">
<!--	
	sum_pp_amt();	
	var fm = document.form1;
	if(toInt(parseDigit(fm.ja_r_amt.value)) == 0 && toInt(parseDigit(fm.opt_amt.value)) > 0){
				fm.ja_r_s_amt.value = fm.opt_s_amt.value;
				fm.ja_r_v_amt.value = fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;						
				fm.app_ja.value 	= fm.opt_per.value;
	}
//-->
</script>	
	<%} %>	
	<%if(cng_item.equals("pay_way")){%>		
	<tr id=tr_fee3 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Թ��</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>						
    <tr id=tr_fee2 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>���ݱ���</td>
                    <td width="20%">&nbsp;
                      <select name='fee_sh'>
                        <option value="">����</option>
                        <option value="0" <%if(fee.getFee_sh().equals("0")){%> selected <%}%>>�ĺ�</option>
                        <option value="1" <%if(fee.getFee_sh().equals("1")){%> selected <%}%>>����</option>
                      </select></td>
                    <td width="10%" class='title'>���ι��</td>
                    <td width="20%">&nbsp;
                      <select name='fee_pay_st'>
                        <option value=''>����</option>
                        <option value='1' <%if(fee.getFee_pay_st().equals("1")){%> selected <%}%>>�ڵ���ü</option>
                        <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>�������Ա�</option>
                        <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>����</option>
                        <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>��Ÿ</option>
                        <option value='6' <%if(fee.getFee_pay_st().equals("6")){%> selected <%}%>>ī��</option>
                      </select></td>
        		    <td width="10%" class='title'>CMS�̽���</td>
        		    <td>&nbsp;
        			    ���� : <input type='text' name='cms_not_cau' size='25' value='<%=fee_etc.getCms_not_cau()%>' class='text'>
        		    </td>
                </tr>		  		  		  
                <tr>
                    <td class='title'>��ġ����</td>
                    <td colspan="3">&nbsp;
                    <select name='def_st'>
                      <option value="N" <%if(fee.getDef_st().equals("N")){%> selected <%}%>>����</option>
                      <option value="Y" <%if(fee.getDef_st().equals("Y")){%> selected <%}%>>����</option>
                    </select>
        			 ���� :            
        			 <input type='text' name='def_remark' size='40' value='<%=fee.getDef_remark()%>' class='text'>
        			</td>
                    <td class='title'>������</td>
                    <td>&nbsp;
                      <select name='def_sac_id'>
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(fee.getDef_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
                </tr>
    		  <%if(!base.getCar_st().equals("4") && cms.getApp_dt().equals("")){%>
              <tr>
                <td class='title'>�ڵ���ü
                  <br><span class="b"><a href="javascript:search_cms('')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;���¹�ȣ : 
    			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='30' class='text'>
    			      (
    			      <input type='hidden' name="cms_bank" 			value="<%=cms.getCms_bank()%>">
    			      <select name='cms_bank_cd'>
                    <option value=''>����</option>
                    <%	if(bank_size > 0){
    											for(int i = 0 ; i < bank_size ; i++){
    												CodeBean bank = banks[i];	
    												//�ű��ΰ�� �̻������ ����
   													if(bank.getUse_yn().equals("N"))	 continue;
    												if(cms.getCms_bank().equals("")){
    							%>
                    <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}else{%>
                    <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}%>
                    <%		}
    					}%>
                  </select>    
    			       ) </td>
    			    </tr>
    			  <tr>
    			    <td>&nbsp;�� �� �� :&nbsp;
    			      <input type='text' name='cms_dep_nm' value='<%=cms.getCms_dep_nm()%>' size='30' class='text'>
    				  &nbsp;&nbsp;
    				  / �������� : �ſ�
    			      <select name='cms_day'>
        			      <option value="">����</option>
						    <%for(int i=1; i<=31; i++){%>
                        	<option value="<%=i%>"  <%if(cms.getCms_day().equals(String.valueOf(i)))%>selected<%%>><%=i%></option>
							<%}%>						
                      	  </select>
    			��
    				  </td>
    			    </tr>
        			  <tr>
        			    <td>&nbsp;������ �������/����ڹ�ȣ :
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
    			      &nbsp;&nbsp;������ �ּ� : 
					  <script>
						function openDaumPostcode02() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip02').value = data.zonecode;
									document.getElementById('t_addr02').value = data.address;
									
								}
							}).open();
						}
					</script>
						<input type="text" name="t_zip"  id="t_zip02" size="7" maxlength='7' value="<%=cms.getCms_dep_post()%>">
						<input type="button" onclick="openDaumPostcode01()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr02" size="50" value="<%=cms.getCms_dep_addr()%>">
      				</td>
        			    </tr>			
        			  <tr>
        			    <td>&nbsp;������ȭ :
    			      <input type='text' name='cms_tel' size='15' class='text' value="<%=cms.getCms_tel()%>">

    			      &nbsp;&nbsp;�޴��� :
    			      <input type='text' name='cms_m_tel' size='15' class='text' value="<%=cms.getCms_m_tel()%>">
    					  
    			      &nbsp;&nbsp;�̸��� :
    			      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=cms.getCms_email()%>">	

        				  </td>
        			    </tr>		    			    
    			</table>
    			</td>
              </tr>
              
    		 <%}%>
                <tr>
                    <td class='title'>�����Ա�</td>
                    <td colspan="5">&nbsp; 
                      <select name='fee_bank'>
                        <option value=''>����</option>
                        <%if(bank_size > 0){
        										for(int j = 0 ; j < bank_size ; j++){
        											CodeBean bank = banks[j];
        											//�ű��ΰ�� �̻������ ����
 															if(bank.getUse_yn().equals("N"))	 continue;
        								%>
                              <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%= bank.getNm()%> </option>
                        <%	}
        									}%>
                      </select>
                    </td>
                </tr>
                <%if(base.getCar_st().equals("4")){
                		//fee_rm
										ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");	%>

                <tr>
                    <td class='title'>2ȸ��û������</td>
                    <td colspan="5">&nbsp;
                    	<select name='cms_type'>
                    	  <option value="" <%if(fee_rm.getCms_type().equals("")){%> selected <%}%>>����</option>
                        <option value="card" <%if(fee_rm.getCms_type().equals("card")){%> selected <%}%>>�ſ�ī��</option>
                        <option value="cms" <%if(fee_rm.getCms_type().equals("cms")){%> selected <%}%>>CMS</option>
                      </select>                    
                    </td>
                </tr>			
			
								<%}else{%>
                <tr>
                    <td class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
                    <td colspan="5">&nbsp; 
                    <textarea rows='5' cols='90' name='fee_cdt'><%=fee.getFee_cdt()%></textarea>
                    </td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>	
    <%if(fee.getFee_pay_st().equals("6") && base.getRent_l_cd().equals("G120HNGR00164")){%>
	<tr id=tr_fee3 >
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ſ�ī�� �ڵ����</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>						
    <tr id=tr_fee2> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		  <%if(card_cms.getApp_dt().equals("") || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("CMS����",user_id) || nm_db.getWorkAuthUser("�ſ�ī���ڵ����",user_id)){%>
              <tr>
                <td class='title'>�ſ�ī�� �ڵ����
                  <br><span class="b"><a href="javascript:search_card_cms('')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                </td>
                <td colspan="5"><table width="100%" border="0" cellpadding="0">
    			  <tr>
    			    <td>&nbsp;ī���ȣ : 
    			      <input type='text' name='c_cms_acc_no' value='<%=card_cms.getCms_acc_no()%>' size='30' class='text'>
    			      (
    			      ī��� : <input type='text' name='c_cms_bank' value='<%=card_cms.getCms_bank()%>' size='20' class='text'>
    			       ) 
               &nbsp;&nbsp;�������� : �ſ�
    			      <select name='c_cms_day'>
        			      <option value="">����</option>
						    <%for(int i=1; i<=31; i++){%>
                        	<option value="<%=i%>"  <%if(card_cms.getCms_day().equals(String.valueOf(i)))%>selected<%%>><%=i%></option>
							<%}%>						
                      	  </select>
    			��    			       
    			       </td>
    			    </tr>
    			  <tr>
    			    <td>&nbsp;ī���� ���� :&nbsp;
    			      <input type='text' name='c_cms_dep_nm' value='<%=card_cms.getCms_dep_nm()%>' size='30' class='text'>
              &nbsp;&nbsp;ī���� ������� :
    			      <input type='text' name='c_cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(card_cms.getCms_dep_ssn())%>">
					  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
						<script>
							function openDaumPostcode() {
								new daum.Postcode({
									oncomplete: function(data) {
										document.getElementById('t_zip03').value = data.zonecode;
										document.getElementById('t_addr03').value = data.address;
										
									}
								}).open();
							}
						</script>
						<br>
    			      &nbsp;��û�� �ּ� : 
					  <input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��">
					  <input type="text" name="c_cms_zip"  id="t_zip03" size="7" maxlength='7' value="<%=card_cms.getCms_dep_post()%>">
						&nbsp;<input type="text" name="c_cms_addr" id="t_addr03" size="50" value="<%=card_cms.getCms_dep_addr()%>">
        				  </td>
        			    </tr>			
        			  <tr>
        			    <td>&nbsp;������ȭ :
    			      <input type='text' name='c_cms_tel' size='15' class='text' value="<%=card_cms.getCms_tel()%>">

    			      &nbsp;&nbsp;�޴��� :
    			      <input type='text' name='c_cms_m_tel' size='15' class='text' value="<%=card_cms.getCms_m_tel()%>">
    					  
    			      &nbsp;&nbsp;�̸��� :
    			      <input type='text' name='c_cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=card_cms.getCms_email()%>">	

        				  </td>
        			    </tr>	
        			    <tr>
        			    <td>&nbsp;������������ :
    			      <input type='text' name='c_cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(card_cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>

    			     

        				  </td>
        			    </tr>	    			    
    			</table>
    			</td>
              </tr>
              
    		 <%}%>
            </table>
        </td>
    </tr>	    
    <%} %>
    
    		
	<%} %>	
	<%if(cng_item.equals("tax")){%>	
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
                    <td width="10%" class='title' style="font-size : 8pt;">û����<br>���ɹ��</td>
                    <td width="20%">&nbsp;
        			  <%if(cont_etc.getRec_st().equals("") && client.getEtax_not_cau().equals("")) 	cont_etc.setRec_st("1");
        			    if(cont_etc.getRec_st().equals("") && !client.getEtax_not_cau().equals("")) cont_etc.setRec_st("2");%>
                      <select name='rec_st'>
                        <option value="">����</option>					
                        <option value="1" <% if(cont_etc.getRec_st().equals("1")) out.print("selected"); %>>�̸���</option>
                        <option value="2" <% if(cont_etc.getRec_st().equals("2")) out.print("selected"); %>>����</option>
                        <option value="3" <% if(cont_etc.getRec_st().equals("3")) out.print("selected"); %>>���ɾ���</option>
                      </select>
                    </td>
                    <td width="10%" class='title' style="font-size : 8pt;">����<br>���ݰ�꼭</td>
                    <td>&nbsp;<%if(cont_etc.getEle_tax_st().equals("") && cont_etc.getRec_st().equals("1")) cont_etc.setEle_tax_st("1");%>
                      <select name='ele_tax_st'>
                        <option value="">����</option>
                        <option value="1" <% if(cont_etc.getEle_tax_st().equals("1")) out.print("selected"); %>>���ý���</option>
                        <option value="2" <% if(cont_etc.getEle_tax_st().equals("2")) out.print("selected"); %>>�����ý���</option>
                      </select>
                      <input type='text' name='tax_extra' maxlength='10' size='15' value='<%=cont_etc.getTax_extra()%>' class='text'>
        			</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>������</td>
                    <td width="20%">&nbsp;
        			<select name='fee_br_id'>
                        <option value=''>����</option>
                        <%	if(brch_size > 0)	{
        						for (int i = 0 ; i < brch_size ; i++){
        							Hashtable branch = (Hashtable)branches.elementAt(i);%>
                        <option value='<%=branch.get("BR_ID")%>' <%if(fee.getBr_id().equals(branch.get("BR_ID"))){%>selected<%}%>><%= branch.get("BR_NM")%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
                    <td width="10%" class='title'>û������</td>
                    <td width="20%">&nbsp;
        			<select name='fee_st'>
                        <option value="0" <%if(fee.getFee_st().equals("0")){%> selected <%}%>>����</option>
                        <option value="1" <%if(fee.getFee_st().equals("1")){%> selected <%}%>>û��</option>
                        <option value="2" <%if(fee.getFee_st().equals("2")){%> selected <%}%>>����</option>
                    </select>
        			</td>
                    <td width="10%" class='title'>��������</td>
                    <td>&nbsp;
        			<select name='rc_day'>
                        <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                        <option value='<%=i%>' <%if(fee.getRc_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� 
                        </option>
                        <% } %>
                        <option value='99' <%if(fee.getRc_day().equals("99")){%> selected <%}%>> 
                        ���� </option>
                    </select>
        			</td>
                </tr>
                <tr>
                    <td width="13%" class='title'>�Ϳ�����</td>
                    <td>&nbsp;<input type='checkbox' name='next_yn' <%if(fee.getNext_yn().equals("Y")){%>checked<%}%>></td>
                    <td width="10%" class='title'>�������</td>
                    <td colspan="3">&nbsp;
    			    <input type='text' size='3' name='leave_day' value='<%=fee.getLeave_day()%>' maxlength='2' class='text'>��</td>
                </tr>		  
            </table>
        </td>
    </tr>
	<%} %>	
	<%if(cng_item.equals("taecha_info")){%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������� ����</span></td>
	</tr>
    <tr id=tr_tae1 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 style='height:1'></td>
                </tr>
                <tr>
                    <td width="13%" class=title>�������������</td>
                    <td width="20%">&nbsp; &nbsp;
                      <input type='radio' name="prv_dlv_yn" value='N' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                      ����
                      <input type='radio' name="prv_dlv_yn" value='Y' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
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
    <tr>
		<td>* ����������ִ� ��� ������ �Ϸ�Ǹ� �뿩���-��������������� �߰�����Ͻʽÿ�.</td>
    </tr>
    <%} %>	
	<%if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){%>
	<input type='hidden' name='taecha_no'		 value='<%=taecha_no%>'>		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������</span></td>
	</tr>    
    <tr id=tr_tae2 style="display:<%if(fee.getPrv_dlv_yn().equals("Y") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>������ȣ</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='tae_car_no' size='10' class='text' <%if(!base.getRent_st().equals("3"))%>readonly<%%> value='<%=taecha.getCar_no()%>'>
                      <span class="b"><a href="javascript:car_search('taecha')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span> 
        			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
					  <input type='hidden' name='tae_s_cd'	 	 value='<%=taecha.getRent_s_cd()%>'>
					  <!-- ��������� �뿩�ὺ������ ������ ��ҹ�ư ���ϰ�, �̰��ðų� �����پ�����-->
					  <% int max_taecha_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd, ""); %>
					  <% if(max_taecha_tm == 0 || fee.getRent_start_dt().equals("")){ %>
					  &nbsp;<a href="javascript:cancel_taecha()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a>
					  <% } %>
        			</td>
                    <td width="10%" class='title'>����</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="tae_car_nm" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getCar_nm()%>'></td>
                    <td width="10%" class='title'>���ʵ����</td>
                    <td>&nbsp; 
                    <input type="text" name="tae_init_reg_dt" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getInit_reg_dt()%>'></td>
                </tr>
                <tr>
                    <td class=title>�뿩������</td>
                    <td>&nbsp;
                      <input type='text' name='tae_car_rent_st' class='text' size='11' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='title'>�뿩������</td>
                    <td>&nbsp;
                      <input type='text' name='tae_car_rent_et' class='text' size='11' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
        			  &nbsp;</td>
        			  <td class='title'>�뿩�ἱ�Աݿ���</td>
                <td>&nbsp;
                	<input type='radio' name="tae_f_req_yn" value='Y' <%if(taecha.getF_req_yn().equals("Y")){%> checked <%}%> >
                  ���Ա�
                  <input type='radio' name="tae_f_req_yn" value='N' <%if(taecha.getF_req_yn().equals("N")||taecha.getF_req_yn().equals("")){%> checked <%}%> >
    	 		        ���Ա�
    	 		        </td>
    			    </td>
                </tr>
                <tr>
                    <td width="10%" class=title >���뿩��</td>
                    <td>&nbsp;
                      <input type='text' name='tae_rent_fee' class='num' size='8' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����) 
        			  <input type='hidden' name='tae_rent_fee_s'	 value=''>
        			  <input type='hidden' name='tae_rent_fee_v'	 value=''>
        			  <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              		  <%}else{%>	
        			  <a href="javascript:EstiTaeSearch();"><img src=/acar/images/center/button_in_search.gif align="absmiddle" border="0" alt="�����̷�"></a>
        			  <%}%>	
    			    </td>
                    <td width="10%" class=title >������</td>
                    <td colspan='3'>&nbsp;
                      <input type='text' name='tae_rent_inv' class='whitenum' readonly size='8' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_inv())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����) 
            <span class="b"><a href="javascript:estimate_taecha('account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
					  <%	if(!taecha.getRent_inv().equals("0")){
					  			ContCarBean t_fee_add = a_db.getContFeeEtcAdd(rent_mng_id, rent_l_cd, "t");%>
					  <a href="javascript:TaechaEstiPrint('<%=t_fee_add.getBc_est_id()%>');"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
					  <%	}%>
					  
        			  <input type='hidden' name='tae_rent_inv_s'	 value=''>
        			  <input type='hidden' name='tae_rent_inv_v'	 value=''>					  
					  <input type='hidden' name='tae_est_id'	 	 value='<%=taecha.getEst_id()%>'>					          			  
        			  
    			    </td>
                </tr>  
                <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
                <%}else{%>
                <tr>
                    <td class=title>���������ÿ������</td>
                    <td colspan='5' >&nbsp;
                      <input type='radio' name="tae_rent_fee_st" value='1' <%if(taecha.getRent_fee_st().equals("1")){%> checked <%}%> >
                                      ����Ʈ������
                      <input type='text' name='tae_rent_fee_cls' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����)                 
                      <input type='radio' name="tae_rent_fee_st" value='0' <%if(taecha.getRent_fee_st().equals("0")){%> checked <%}%>  >
    	 		          �������� ǥ��Ǿ� ���� ����	                        				  					 
        			</td>                     
              </tr>	      
              <%}%>        
                <tr>
                    <td class=title>û������</td>
                    <td>&nbsp;
                      <select name='tae_req_st'>
                        <option value="">����</option>
                        <option value="1" <% if(taecha.getReq_st().equals("1")) out.print("selected");%>>û��</option>
                        <option value="0" <% if(taecha.getReq_st().equals("0")) out.print("selected");%>>�������</option>
                      </select></td>
                    <td class='title' style="font-size : 8pt;">��꼭���࿩��</td>
                    <td>&nbsp;
                      <select name='tae_tae_st'>
                        <option value="">����</option>
                        <option value="1" <% if(taecha.getTae_st().equals("1")) out.print("selected");%>>����</option>
                        <option value="0" <% if(taecha.getTae_st().equals("0")) out.print("selected");%>>�̹���</option>
                      </select></td>
                    <td class='title'>������</td>
                    <td>&nbsp;
                      <select name='tae_sac_id'>
                        <option value="">����</option>
                       	<%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                   		<option value='<%=user.get("USER_ID")%>' <%if(taecha.getTae_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                      	<%		}
        					}%>
                      </select>
        			</td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(base.getRent_st().equals("3")){%> 
    <tr>
	<td>* �����Ī������ ��� ������ȣ�� "<%=cr_bean.getCar_no()%>"�� �Է��Ͻð�(�˻��� �ȵ�), �����Ⱓ�� ������, 
	      �뿩�������� �����ε���, �뿩�������� ����� ���Ό����, ���뿩��� ����� ���뿩��, û�����δ� û��, ��꼭���࿩�δ� �������� �Է��ϼ���.</td>
    </tr>   
    <tr id=tr_tae3 style="display:none">
	    <td>
	        * �����Ī���� �̰������ٱݾ� ���� : �������� ���� <input name="end_rent_link_day" type="text" class="text"  readonly value="" size="4">��,
	        �����뿩��� ���� �뿩�� ���� <input name="end_rent_link_per" type="text" class="text"  readonly value="" size="4">%<br>
	        * �����Ī �Է��� ��  "���������"  �뿩������ / �뿩������ ���̰� 35�� �̻�, �Ǵ� ������� ���� 30% �̻� ���̰� �߻��ϸ� ����������� �Էµ� "���뿩��"�� ��������  ����������� �������� �ݿ��Ѵ�.<br> 
	        * ������ <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(taecha.getEnd_rent_link_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="end_rent_link_sac_id" value="<%=taecha.getEnd_rent_link_sac_id()%>">			
			<a href="javascript:User_search('end_rent_link_sac_id', '');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<input name="end_rent_link_sac_id_text" type="text" class="whitetextredb"  readonly value="" size="10">
	           
	    </td> 
	<tr>		 
    <%}%>	
	<%} %>	
	<%if(cng_item.equals("emp1") || cng_item.equals("emp2")){%>	
	<tr id=tr_emp_bus_t style="display:<%if(cng_item.equals("emp1")){%>''<%}else{%>none<%}%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>�������<%}else if(base.getCar_gu().equals("2")){%>�߰�������<%}%>-�������</span></td>
	</tr>
    <tr id=tr_emp_bus style="display:<%if(cng_item.equals("emp1")){%>''<%}else{%>none<%}%>"> 	
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
            	    <td class=line2 style='height:1'></td>
            	</tr>
            	              <tr>
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
                <tr>
                    <td width="13%" class='title'>�������</td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>
        			  <%if(commi_doc.getDoc_step().equals("")){%>        			   
                      <span class="b"><a href="javascript:search_emp('BUS')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
        		      <span class="b"><a href="javascript:cancel_emp('BUS')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>        		      
        		      <%}%>
        		    </td>
                </tr>
                <tr>
                    <td width="13%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
					  </td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp1.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                    <td width="10%" class='title'>�ҵ汸��</td>
                    <td>&nbsp;
                    <input type='text' name='cust_st' size='15' value='<%=emp1.getCust_st()%>' class='whitetext' readonly></td>			
                </tr>
                <tr>
                    <td class='title'>�ִ��������</td>
                    <td>&nbsp;
                      <input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum' <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%><%}else{%>readonly<%}%>>
        			  % 
        			</td>
                    <td class='title'>�����������</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%><%}else{%>readonly<%}%> class='<%if(!commi_doc.getDoc_no().equals(""))%>white<%%>num' onBlur='javascript:setCommi()'>
        		      % 			  	  
        			</td>
                </tr>
                <tr>
                    <td class='title'>�������</td>
                    <td>&nbsp;
                      <select name='commi_car_st'>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>��������</option>
                      </select>  
        			</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;
                      <input type='text' size='11' name='commi_car_amt' maxlength='11' <%if(!nm_db.getWorkAuthUser("������",user_id)){%>readonly<%}%> class='<%if(!commi_doc.getDoc_no().equals(""))%>white<%%>num' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">��
					  <%if(emp1.getCommi_car_amt()==0){%>					  
					  	<%if(AddUtil.parseInt(base.getRent_dt())>=20130321){%>
					  	(�Һ������� <%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt())%>)
					  	<%}else{%>
					  	(�Һ������� <%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>)
					  	<%}%>
					  <%}%>
					  </td>
                    <td class='title'>���޼�����</td>
                    <td>&nbsp;
                      <input type='text' name="commi" size='10' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' readonly maxlength='7' class='<%if(!commi_doc.getDoc_no().equals(""))%>white<%%>num' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��			  
        			</td>
                </tr>		  
                <tr>
                    <td class='title'>�������</td>
                    <td colspan="3" >&nbsp;
        		      <input type='text' name="ch_remark" value='<%=emp1.getCh_remark()%>' size="40" class='text'>
                    </td>
                    <td class='title'>������</td>
                    <td>&nbsp;
                      <select name='ch_sac_id'>
                        <option value="">����</option>
                 		<%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
              			<option value='<%=user.get("USER_ID")%>' <%if(emp1.getCh_sac_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
                      </select>
        			</td>
                </tr>
                <tr>
                    <td class='title'>�����</td>
                    <td >&nbsp;
                    	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
        		      <select name='emp_bank_cd'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//�ű��ΰ�� �̻������ ����
   															if(bank.getUse_yn().equals("N"))	 continue;
        								%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        										}%>
                      </select>
        			</td>
                    <td class='title'>���¹�ȣ</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="15" class='text'>
        			</td>
                    <td class='title'>�����ָ�</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="15" class='text'>
        			</td>
                </tr>		  		  
            </table>
        </td>
    </tr>
	<%if(cng_item.equals("emp1") && !commi_doc.getDoc_no().equals("")){%>
    <tr>
	    <td>* �������繮���� ��� ��ϵ� ���Դϴ�. �������� �� �ݾ׼����� �������繮������ �Ͻñ� �ٶ��ϴ�.&nbsp;</td>
	</tr>		
	<%}%>
	<%} %>	
	<%if(cng_item.equals("emp1") || cng_item.equals("emp2")){%>		
	<tr id=tr_emp_dlv_t style="display:<%if(cng_item.equals("emp2")){%>''<%}else{%>none<%}%>">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(!base.getCar_gu().equals("2")){%>�������-�����<%}else if(base.getCar_gu().equals("2")){%>�߰�������ó<%}%></span></td>
	</tr>	
    <tr id=tr_emp_dlv style="display:<%if(cng_item.equals("emp2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
            	    <td class=line2 style='height:1'></td>
            	</tr>		
                <tr>
                 <td class='title'>�����</td>
                 <td>&nbsp;
				   <input type='hidden' name='one_self' value='<%=pur.getOne_self()%>'>
				   <%if(pur.getOne_self().equals("Y")){%>��ü���<%}%>
				   <%if(pur.getOne_self().equals("N")){%>����������<%}%>				   
			     </td>
		<td class='title'>Ư�������</td>
                <td>&nbsp;
                <input type='radio' name="dir_pur_yn" value='Y' <%if(pur.getDir_pur_yn().equals("Y")){%>checked<%}%>>
        				Ư��
        	    <input type='radio' name="dir_pur_yn" value='' <%if(pur.getDir_pur_yn().equals("")){%>checked<%}%>>
        				��Ÿ(��ü)
                		  
        		  
    			</td>	
    		<td class='title'>����û��</td>
                <td>&nbsp;
                		  <input type='text' name='pur_req_dt' value='<%=pur.getPur_req_dt()%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
                		   &nbsp;
        		  <input type="checkbox" name="pur_req_yn" value="Y" <%if(pur.getPur_req_yn().equals("Y")){%>checked<%}%>>				  
        				����û�Ѵ�
        		  
    			</td>	     
              </tr>				
                <tr>
                    <td width="13%" class='title'>�����</td>
                    <td width="20%" style='height:44'>&nbsp;
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
        			  
        			  <%if(doc4.getDoc_step().equals("")){%>
                                  <span class="b"><a href="javascript:search_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href="javascript:cancel_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>        			  
                                  <%}%>
                      </td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
        			</td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp2.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
    		  <%if(!base.getCar_gu().equals("2")){
    			  	String dlv_auth = "";
  		  			if(!pur.getDlv_est_dt().equals("") && !nm_db.getWorkAuthUser("������ڵ��",user_id) && !nm_db.getWorkAuthUser("��ǰ�غ��Ȳ��Ͼ���",user_id)){
  		  				dlv_auth = "white";
  		  			}    	  		  			
    		  %>    		  
                <tr>
                    <td class='title'>�����ȣ</td>
                    <td >&nbsp;
                      <input type='text' name='rpt_no' value='<%=pur.getRpt_no()%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
        		    </td>
                    <td class='title'>�������</td>
                    <td>&nbsp;
                      <input type='text' name='dlv_est_dt' value='<%=pur.getDlv_est_dt()%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  &nbsp;
                  	  <input type='text' size='2' name='dlv_est_h' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> value='<%=pur.getDlv_est_h()%>'>
                 	   �� 
        			</td>
                    <td class='title'>�������</td>
                    <td>&nbsp;
                      <input type='text' name='dlv_dt' value='<%= AddUtil.ChangeDate2(base.getDlv_dt())%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			</td>
                </tr>
                
                <tr>
                    <td class='title'>�����ȣ</td>
                    <td >&nbsp;
                      <input type='text' name='car_num' value='<%=cr_bean.getCar_num()%><%if(cr_bean.getCar_num().equals("")){%><%=pur.getCar_num()%><%}%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> maxlength='20' size='25'>
        		    </td>
                    <td class='title'>���������ȣ</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='est_car_no' value='<%=pur.getEst_car_no()%>' class='<%=dlv_auth%>text' <%if(dlv_auth.equals("white")){%>readonly<%}%> maxlength='20' size='15'>
        			</td>
                </tr>		  
                <tr>
                    <td class='title'>�ӽÿ����ȣ</td>
                    <td >&nbsp;
                      <input type='text' name='tmp_drv_no' value='<%=pur.getTmp_drv_no()%>' class='text' maxlength='10' size='10'>
        		    </td>
                    <td class='title'>�ӽÿ���Ⱓ</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='tmp_drv_st' value='<%=pur.getTmp_drv_st()%>' class='text' maxlength='10' size='11'>
        			 ~
                  	  <input type='text' name='tmp_drv_et' value='<%=pur.getTmp_drv_et()%>' class='text' maxlength='10' size='11'>
        			</td>
                </tr>
              <!--   
			  <tr>				
                <td class='title'>����</td>
                <td>&nbsp;
				  <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��	
				          <%if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getCon_amt_pay_req().equals("")){%>
                	<a href="javascript:SendMsg('con_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                	<%}%>				  
                	<%if(pur.getCon_amt() > 0 && !pur.getCon_amt_pay_req().equals("")){%>
                	&nbsp;�۱ݿ�û(<%=pur.getCon_amt_pay_req()%>)
                	<%}%>
    			</td>				
                <td class='title'>�������</td>				
                <td colspan="3">&nbsp;
					<select name='con_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        								%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        										}%>
                    </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					������ : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
    			</td>				
              </tr>						 
              <tr>				
                <td class='title'>�ӽÿ��ຸ���</td>
                <td colspan='5'>&nbsp;
				  <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��					  
    			</td>				
              </tr>   
               -->              
    		    <%}else if(base.getCar_gu().equals("2")){%>
                <tr>
                    <td class='title'>�Ÿ�����</td>
                    <td >&nbsp;
                      <input type='text' name='dlv_dt' value='<%= AddUtil.ChangeDate2(base.getDlv_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        			</td>
                    <td class='title'>�Ÿűݾ�</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='trf_amt1' value='<%=AddUtil.parseDecimal(pur.getTrf_amt1())%>' class='text' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			��</td>
                </tr>
                <tr>
                    <td class='title'>��������ȣ</td>
                    <td >&nbsp;
                      <input type='text' name='rpt_no' value='<%=pur.getRpt_no()%>' class='text' maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
        		    </td>
                    <td class='title'>�����ȣ</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='car_num' value='<%=pur.getCar_num()%>' class='text' maxlength='20' size='25' onBlur='javascript:this.value=this.value.toUpperCase()'>
        			</td>
                </tr>
    		    <%}%>
            </table>
        </td>
    </tr>
	<%} %>	
	<%if(cng_item.equals("rent_start")){
			
			int car_ret_chk = 0;
			
			//�縮���϶� ����ý��� �������� Ȯ��
			if(base.getCar_gu().equals("0")){
				car_ret_chk = rs_db.getCarRetChk(base.getCar_mng_id());
			}
			
			//����ý��� �������� �̹����� Ȯ��
			Vector rs_conts = rs_db.getTarchaNoRegSearchList(base.getClient_id());
			int rs_cont_size = rs_conts.size();
			%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span> (<font color=red>*</font>�ʼ��Է�)</td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<input type='hidden' name="rent_way"			value="<%=fees.getRent_way()%>">
	<input type='hidden' name="car_ret_chk"			value="<%=car_ret_chk%>">
    <tr id=tr_fee style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='fix' onBlur='javascript:set_cont_date()'>����</td>
                    <td width="10%" align="center" class=title>�뿩������<font color=red>*</font></td>
                    <td width="20%">&nbsp;
                      <input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date();'></td>
                    <td width="10%" align="center" class=title>�뿩������<font color=red>*</font></td>
                    <td>&nbsp;
                    <input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>
				<%if(fee.getFee_s_amt()>0 && !fee.getFee_chk().equals("1") ){%>
                <tr>
                    <td width="13%" class='title'>����Ƚ��<font color=red>*</font></td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='fee_pay_tm' value='<%=fee.getFee_pay_tm()%>' maxlength='2' class='text' >
        				ȸ </td>
                    <td width="10%" class='title'>��������<font color=red>*</font></td>
                    <td colspan="3">&nbsp;�ſ�
                      <select name='fee_est_day'>
                        <option value="">����</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                        <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                        <% } %>
                        <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> ���� </option>
						<option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> �뿩������ </option>
                      </select></td>
                </tr>		  		  		  		  
                <tr>
                    <td width="13%" class='title'>1ȸ��������<font color=red>*</font></td>
                    <td width="20%">&nbsp;
                        <input type='text' name='fee_fst_dt' value='<%=fee.getFee_fst_dt()%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value); set_cont_date();'>
        		    </td>
                    <td width="10%" class='title'>1ȸ�����Ծ�</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name='fee_fst_amt' value='<%=AddUtil.parseDecimal(fee.getFee_fst_amt())%>' maxlength='10' size='11' class='num'>��
                    </td>
                </tr>		
                <tr>
                    <td width="10%" class='title'>���ԱⰣ<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
    			    <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
					&nbsp;&nbsp;<font color='#CCCCCC'>(����Ƚ��, 1ȸ���������� �Է��ϸ� �ڵ�ó���˴ϴ�.)</font>
					</td>
                </tr>	
				<%}else{%>	  	
				  <input type='hidden' name='fee_pay_tm' 			value='<%=fee.getFee_pay_tm()%>'>  
				  <input type='hidden' name='fee_est_day' 			value='<%=fee.getFee_est_day()%>'>  
				  <input type='hidden' name='fee_fst_dt' 			value='<%=fee.getFee_fst_dt()%>'>  
				  <input type='hidden' name='fee_fst_amt' 			value='<%=fee.getFee_fst_amt()%>'>  
				  <input type='hidden' name='fee_pay_start_dt' 		value='<%=fee.getFee_pay_start_dt()%>'>  
				  <input type='hidden' name='fee_pay_end_dt' 		value='<%=fee.getFee_pay_end_dt()%>'>  
				<%}%>
                <tr>
                    <td width="10%" class='title'>�����ε���<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='car_deli_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
					&nbsp;&nbsp;<font color='#CCCCCC'>(���� ������ �ε��Ǵ� ��¥�� �Է��Ͻʽÿ�.)</font>
					</td>
                </tr>
                <!--�����Ī������ ��� �ʰ�����δ�� ���� ����Ÿ��� �ʿ��Ѵ�. 20141014 -->
                <%if(base.getCar_gu().equals("1") && base.getRent_st().equals("3") && taecha.getCar_mng_id().equals(base.getCar_mng_id())){%>
                <tr>
                    <td width="10%" class='title'>��������Ÿ�</td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(f_fee_etc.getSh_km()) %>' class='num' >                      
					&nbsp;&nbsp;<font color='#999999'>(�����Ī���� ����� ���������� ��� ���� �뿩������ ���� ����Ÿ�)</font>
					</td>
                </tr>
                <%}%>                
            </table>
	    </td>
	</tr>	
    <tr>
	    <td>* �� ������ڿ��� ��������� ������ ���� ���ڸ� �����ϴ�. (00000(������ȣ) ���� ����ڴ� 000, ����ó�� 000 �Դϴ�. (��)�Ƹ���ī)</td>
	</tr>	
	<%		if(car_ins_chk.equals("N")){%>
    <tr>
	    <td>* FMS�� ���� ����� �ȵ� �����̹Ƿ� ������ ����ȳ����ڸ� ���� �� �����ϴ�. ������ �Ϸ��� ����ó���Ͻʽÿ�.</td>
	</tr>		
	<%		}else{%>
    <tr>
	    <td>* �� ������ڿ��� ���迡 ���� ���ڸ� �����ϴ�. (������ 0000 1588-****, ����⵿�� ����Ÿ�ڵ��� 1588-6688 �Դϴ�. (��)�Ƹ���ī)</td>
	</tr>		
	<%		}%>
	<%		if(car_ret_chk>0){%>
    <tr>
	    <td>* ����ý��ۿ� [<%=cr_bean.getCar_no()%>]���� ���� ��ó������ �ֽ��ϴ�. ���� ����ó���Ŀ� �뿩�����Ͻʽÿ�.</td>
	</tr>	
	<%		}%>
	
	<%		if(rs_cont_size>0 && taecha.getRent_s_cd().equals("")){%>
    <tr>
	    <td><font color=red>* ����ý���-���������� ���� ��ó������ �ֽ��ϴ�.</font></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� �̹��� ����Ʈ</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">����</td>
                    <td class=title width="20%">������ȣ</td>			
                    <td class=title width="30%">����</td>
                    <td class=title width="20%">�����Ͻ�</td>
                    <td class=title width="17%">ó��</td>
                  </tr>
        		  <%	for(int i = 0 ; i < rs_cont_size ; i++){
        					Hashtable rs_ht = (Hashtable)rs_conts.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=rs_ht.get("CAR_NO")%></td>
                    <td align='center'><%=rs_ht.get("CAR_NM")%></td>					
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(rs_ht.get("DELI_DT")))%></td>
                    <td align='center'>���������<a href="javascript:update2('taecha','')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                  </tr>
        		  <%	} %>
            </table>
        </td>
    </tr>			
	<%		}%>
	
	<%} %>	
	<%if(cng_item.equals("cls_n")){%>	
    <input type='hidden' name='rent_st' 			value='<%=rent_st%>'> 	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr> 	
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr>
                    <td width="13%" align="center" class=title>��������Ⱓ</td>
                    <td width="37%">&nbsp;
                      <input type='text' size='3' name='cls_n_mon' maxlength='10'  class='num' value='<%=fee_etc.getCls_n_mon()%>'>
        				  ����
        			</td>
                    <td width="13%" align="center" class=title>��������ݾ�</td>
                    <td width="37%">&nbsp;
                      <input type='text' size='10' name='cls_n_amt' maxlength='10'  class='num' value='<%=fee_etc.getCls_n_amt()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        				  ��&nbsp;(�������� �������)</td>
                </tr>
            </table>				
	    </td>	
	</tr>
	<%} %>
	<%if(cng_item.equals("spr")){%>	
    <input type='hidden' name='rent_st' 			value='<%=rent_st%>'> 	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ſ���</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr> 	
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr>
                    <td width="13%" align="center" class=title>�ſ���</td>
                    <td >&nbsp;
                      <%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
                    <select name='dec_gr'>
                          <option value=''>����</option>
                          <option value='3' <%if(cont_etc.getDec_gr().equals("3")){%>selected<%}%>>�ż�����</option>
                          <option value='0' <%if(cont_etc.getDec_gr().equals("0")){%>selected<%}%>>�Ϲݰ�</option>
                          <option value='1' <%if(cont_etc.getDec_gr().equals("1")){%>selected<%}%>>�췮���</option>
                          <option value='2' <%if(cont_etc.getDec_gr().equals("2")){%>selected<%}%>>�ʿ췮���</option>
                    </select>
        			</td>
                </tr>
            </table>				
	    </td>	
	</tr>
	<%} %>	

    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>	
    <tr>
	    <td align='center'>
	        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	  	<a href='javascript:update();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	  	&nbsp;
	  	<%}%>
	  	<a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
	  	</td>
	</tr>	
	<%if(cng_item.equals("client")){
		Vector lrc_vt = a_db.getLcRentCngHList(rent_mng_id, rent_l_cd, "p_addr");
		int lrc_vt_size = lrc_vt.size();
		
		out.println(cng_item);
		out.println(lrc_vt_size);
		
		if(lrc_vt_size>0){
	%>	
    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>		
    <tr> 
        <td align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="20%" class='title' >�������</td>
                    <td width="30%" class='title'>������ </td>
                    <td width="30%" class='title'>������</td>
                    <td width="10%" class='title' >��������</td>
                    <td width="10%" class='title' >������</td>			  
                </tr>
                <%		for (int i = 0 ; i < lrc_vt_size ; i++){
    					Hashtable ht = (Hashtable)lrc_vt.elementAt(i);
    					String old_value = String.valueOf(ht.get("OLD_VALUE"));
    					String new_value = String.valueOf(ht.get("NEW_VALUE"));%>
                <tr> 
                    <td align="center" ><%=ht.get("CNG_CAU")%></td>
                    <td align="center"><%=old_value%></td>
                    <td align="center"><%=new_value%></td>
                    <td align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%></td>
                    <td align="center" ><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")), "USER")%></td>
                </tr>
    		<%  		}
    			
    		%>		
            </table>
        </td>
    </tr>	
        <%	} %>	
	<!--�����ּ� �����̷� �����ֱ�-->
	<%} %>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
<%if((cng_item.equals("taecha") || cng_item.equals("taecha_info")) && ta_vt_size>0){%>
tr_tae2.style.display		= '';
<%}%>

<%if(cng_item.equals("taecha") || (cng_item.equals("taecha_info") && ta_vt_size==0)){%>	
<%if(!cont_etc.getGrt_suc_l_cd().equals("")){%>
init_end_rent();
<%}%>

function init_end_rent(){
	var fm = document.form1;
	if(fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){	
		var est_day = getRentTime('d', fm.tae_car_rent_st.value, fm.tae_car_rent_et.value);
		fm.end_rent_link_day.value = est_day;
		var est_amt = (<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>-<%=grt_suc_fee.getFee_s_amt()+grt_suc_fee.getFee_v_amt()%>)/<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;
		est_amt = replaceFloatRound(est_amt);
		fm.end_rent_link_per.value = est_amt;						
		if(est_day > 35 || est_amt > 30){
			tr_tae3.style.display = '';
			fm.end_rent_link_sac_id_text.value = '(�ʼ�)';
		}
		return;
	}
}
<%}%>


//-->
</script>
</body>
</html>
