<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.estimate_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_office.*, acar.con_ins.*, acar.ext.*, card.*"%>
<jsp:useBean id="e_bean"    class="acar.estimate_mng.EstimateBean"     	scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    	scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean"               	scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db"     class="acar.fee.AddFeeDatabase"		scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase" 	scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean" 		scope="page"/>
<jsp:useBean id="ae_db"     class="acar.ext.AddExtDatabase" 		scope="page"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")	==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")	==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")	==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st	 	= request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();	
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�ڵ����⺻����-�⺻����
	CarMstBean cm_bean2 = new CarMstBean();
	
	if(!cm_bean.getCar_b_inc_id().equals("")){
		cm_bean2 = cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	}
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//��������
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	if(rent_st.equals("")) rent_st = "1";
	if(fee_size > 1) rent_st = Integer.toString(fee_size);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�������뿩����
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
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
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
	if(gin_size==0) gin_size = 1;
	
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
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);
	
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
	
	//������ڰ�༭
	Hashtable alink_lc_rent = ln_db.getAlinkEndLcRent(rent_l_cd, "1");	
	
	if(now_stat.equals("���°�")){
		alink_lc_rent = ln_db.getAlinkEndLcRent(rent_l_cd, cont_etc.getSuc_rent_st());
	}
	
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
		
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
		
	//�ſ����ڵ�
	CodeBean[] gr_cd1 = c_db.getCodeAll2("0013", "1");
	CodeBean[] gr_cd2 = c_db.getCodeAll2("0013", "2");
	CodeBean[] gr_cd3 = c_db.getCodeAll2("0013", "3");
	
	int eval_cnt = -1;
	
	//�ڻ�����
	CodeBean[] ass_cd = c_db.getCodeAll2("0014", "");
	
	//��ĵ���� üũ����
	String scan_chk = "Y";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&from_page="+from_page;
	
	String valus_t = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st=t&from_page="+from_page;
	
	int fee_opt_amt = 0;
	
	int zip_cnt =4;
	
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(max_fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(max_fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
	}
	
	//�⺻DC ��������
	String car_d_dt = "";	
	car_d_dt = e_db.getDc_b_dt(cm_bean.getCar_comp_id()+""+cm_bean.getCode(), "dc", base.getRent_dt(), cm_bean.getCar_b_dt());
	CarDcBean cd_bean = cmb.getCarDcBaseCase(cm_bean.getCar_comp_id(), cm_bean.getCode(), car_d_dt, cm_bean.getCar_b_dt());	
	
	//�̸���ȸ
	int user_idx = 0;	
	
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
	
	//�����������
	CodeBean[] code32 = c_db.getCodeAll3("0032");
	int code32_size = code32.length;

	//�����μ���
	CodeBean[] code35 = c_db.getCodeAll3("0035");
	int code35_size = code35.length;
	
  	//������ ���ּ���
  	CodeBean[] code34 = c_db.getCodeAll3("0034");
  	int code34_size = code34.length;	
	
  	//������ ���ּ���
  	CodeBean[] code37 = c_db.getCodeAll3("0037");
  	int code37_size = code37.length;	
  	
  	//�����ڰݰ������
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//�ݿø�
function getCutRoundNumber(num, place){
	var returnNum;
	var st="1";
	return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
}

	function replaceFloatRound(per){		return Math.round(per*1000)/10;		}
	//���������ݽ°���ȸ
	function search_grt_suc(){		var fm = document.form1;	window.open("/agent/car_pur/s_grt_suc.jsp?from_page=/agent/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");	}
	//���������ݽ°����
	function cancel_grt_suc()	{		var fm = document.form1;		fm.grt_suc_l_cd.value = '';		fm.grt_suc_m_id.value = '';		fm.grt_suc_c_no.value = '';		fm.grt_suc_o_amt.value = '';		fm.grt_suc_r_amt.value = '';	}
	//����Ʈ
	function list(){
		var fm = document.form1;	
		if(fm.from_page.value == '')	fm.action = 'lc_b_frame.jsp';
		else				fm.action = fm.from_page.value;
		fm.target = 'd_content';
		fm.submit();
	}	

	//2�ܰ� -----------------------------------------------------------
	
	//�� ��ȸ
	function search_client(){		window.open("/agent/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp", "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");	}
	//�� ����
	function view_client(){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("���õ� ���� �����ϴ�."); return;}			window.open("/agent/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");	}
	//����/���� ��ȸ
	function search_site()	{		var fm = document.form1;		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}		window.open("/agent/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=500, scrollbars=yes, status=yes, resizable=yes");	}
	//����/���� ����
	function view_site()	{		var fm = document.form1;		if(fm.site_id.value == ""){ alert("���õ� ������ �����ϴ�."); return;}		window.open("/agent/client/client_site_i_p.jsp?cmd=view&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");	}
	//������ ��ȸ
	function search_mgr(idx){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}			window.open("search_mgr.jsp?idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	}
	//�ּ� ��ȸ
	function search_post(idx){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}			window.open("search_post.jsp?idx="+idx+"&client_id="+fm.client_id.value, "POST", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		}
	//��ǥ�̻纸��
	function cng_input2(){	
		var fm = document.form1;		
		if(fm.client_guar_st[0].checked == true){ //����
			tr_client_guar.style.display = 'none';
		}else{	//����
			tr_client_guar.style.display = '';
		}
	}
	//���������� �����������
	function cng_input4(){
		<%if(client.getClient_st().equals("2")){%>
		if(document.form1.client_share_st[0].checked==true){
			tr_client_share_st_test.style.display='';//����
		}else{
			tr_client_share_st_test.style.display='none';//����
		}
		<%}%>
	}	
	//���뺸����
	function guar_display(){
		var fm = document.form1;
		var size = toInt(fm.gur_size.value);
		if(fm.guar_st[0].checked == true){ 	//����
			tr_guar2.style.display	= '';
		}else{	//����
			tr_guar2.style.display	= 'none';
		}
	}	
	function gur_display_add(){
		var fm = document.form1;
		var size = toInt(fm.gur_size.value);
		if(size == 0){				tr_gur_info0.style.display	= '';			tr_gur_eval0.style.display	= '';			tr_gur_ass0.style.display	= '';
		}else if(size == 1){	tr_gur_info1.style.display	= '';			tr_gur_eval1.style.display	= '';			tr_gur_ass1.style.display	= '';
		}else if(size == 2){	tr_gur_info2.style.display	= '';			tr_gur_eval2.style.display	= '';			tr_gur_ass2.style.display	= '';
		}else{								alert('���뺸������ �ִ� 3�α��� �Դϴ�.');		}
		fm.gur_size.value = size+1;
	}
	//������ ��ȸ
	function search_gur(idx){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}			window.open("search_gur.jsp?idx="+idx+"&client_id="+fm.client_id.value, "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		}
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
		var gr_size = toInt(fm.eval_cnt.value)+1;	
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
	function enter_car(obj)	{		var keyValue = event.keyCode;		if (keyValue =='13') set_car_amt(obj);	}	
	//���/����: ���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_car_amt(obj)
	{
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.car_cs_amt){ 	//�����⺻���� ���ް�
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) * 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cs_amt){ 	//���û��� ���ް�
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) * 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cs_amt){ 	//���� ���ް�
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) * 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cs_amt){ 	//Ź�۷� ���ް�
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) * 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cs_amt){ 	//����DC ���ް�
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) * 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));			
		}else if(obj==fm.car_fs_amt){ 	//�鼼�������� ���ް�
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) * 0.1 );
			fm.car_f_amt.value	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));			
		}else if(obj==fm.tax_dc_s_amt){ 	//ģȯ���� ���Ҽ� ����� ���ް�
			fm.tax_dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) * 0.1 );
			fm.tax_dc_amt.value		= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));			
		

		}else if(obj==fm.car_cv_amt){ 	//�����⺻���� �ΰ���
			fm.car_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) / 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cv_amt){ 	//���û��� �ΰ���
			fm.opt_cs_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cv_amt.value)) / 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cv_amt){ 	//���� �ΰ���
			fm.col_cs_amt.value = parseDecimal(toInt(parseDigit(fm.col_cv_amt.value)) / 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cv_amt){ 	//Ź�۷� �ΰ���
			fm.sd_cs_amt.value = parseDecimal(toInt(parseDigit(fm.sd_cv_amt.value)) / 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cv_amt){ 	//����DC �ΰ���
			fm.dc_cs_amt.value = parseDecimal(toInt(parseDigit(fm.dc_cv_amt.value)) / 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));
		}else if(obj==fm.car_fv_amt){ 	//�鼼�������� �ΰ���
			fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) / 0.1 );
			fm.car_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
		}else if(obj==fm.tax_dc_v_amt){ 	//ģȯ���� ���Ҽ� ����� �ΰ���
			fm.tax_dc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_v_amt.value)) / 0.1 );
			fm.tax_dc_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));
		

		}else if(obj==fm.car_c_amt){ 	//�����⺻���� �հ�
			fm.car_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_cs_amt.value)));			
		}else if(obj==fm.opt_c_amt){ 	//���û��� �հ�
			fm.opt_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.opt_cs_amt.value)));			
		}else if(obj==fm.col_c_amt){ 	//���� �հ�
			fm.col_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.col_cs_amt.value)));			
		}else if(obj==fm.sd_c_amt){ 	//Ź�۷� �հ�
			fm.sd_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.sd_cs_amt.value)));			
		}else if(obj==fm.dc_c_amt){ 	//����DC �հ�
			fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));			
		}else if(obj==fm.car_f_amt){ 	//�鼼�������� �հ�
			fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_fs_amt.value)));
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
		sum_pp_amt();			
	}
	
	//Ư�Ҽ��������� ��������
	function setVar_o_123(car_price){
		var fm = document.form1;
		var o_1 = car_price;
		//������ Ư�Ҽ���
		var o_2 = <%=ej_bean.getJg_3()%>;	
		//Ư�Ҽ��������� o_3 = o_1/(1+o_2), ��������/(1+Ư�Ҽ���);
		var o_3 = Math.round(o_1/(1+o_2));	
		fm.v_o_1.value = o_1;
		fm.v_o_2.value = o_2;
		fm.v_o_3.value = o_3;
	}

	//���� Ư�Ҽ� �հ�
	function sum_tax_amt(){
		var fm = document.form1;
		
		if(toInt(parseDigit(fm.car_f_amt.value)) == 0){	sum_car_f_amt(); }
		
		var purc_gu 		= fm.purc_gu.value;		
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_c_price = setCarPrice('car_c_price');
		var car_f_price = setCarPrice('car_f_price');
		var a_e = toInt(s_st);
		setVar_o_123(car_f_price);
		if(purc_gu == '1'){//����1
			fm.tot_tax.value = parseDecimal(car_c_price-toInt(fm.v_o_3.value));
			fm.pay_st[1].selected = true;
		}else{//����2(�鼼)	 	
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
				fm.tot_tax.value = parseDecimal(Math.round(toInt(fm.v_o_1.value)*toFloat(fm.v_o_2.value)));
			}else{
				fm.tot_tax.value = parseDecimal(car_c_price-toInt(parseDigit(fm.car_f_amt.value)));
			}				
			fm.pay_st[2].selected = true;
		}
		fm.spe_tax.value 	= parseDecimal(toInt(parseDigit(fm.tot_tax.value))/6.5*5);	
		fm.edu_tax.value 	= parseDecimal(toInt(parseDigit(fm.tot_tax.value)) - toInt(parseDigit(fm.spe_tax.value)) );		
	}
	
	//���� �Һ��ڰ� �հ�
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
	}
	
	//���� ���԰� �հ�
	function sum_car_f_amt_b(){
		var fm = document.form1;
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );
	}
	
	//���� ���԰� �հ�
	function sum_car_f_amt(){
		var fm = document.form1;
		
		var purc_gu 		= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_price = setCarPrice('car_c_price');
		if(fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0') set_car_amt(fm.dc_c_amt);
		sum_car_f_amt_b();
		var car_price2 = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price2);
    	car_price2 = car_price2 - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));
		if(fm.car_gu.value != '1'){
			car_price2 	= toInt(parseDigit(fm.sh_amt.value));
		}
		//ä��Ȯ��
		if(car_price2 <= 45000000)			fm.credit_per.value = '20';
		else if(car_price2 > 45000000)	fm.credit_per.value = '25';
		//�������� �⺻ �����ݿ��� 10% ���ش�
   	if('<%=ej_bean.getJg_g_7()%>' == '3'){ fm.credit_per.value = toInt(fm.credit_per.value)-10; }
		//�������� �⺻ �����ݿ��� 15% ���ش�
   	if('<%=ej_bean.getJg_g_7()%>' == '4'){ fm.credit_per.value = toInt(fm.credit_per.value)-15; }
		var credit_per = toInt(fm.credit_per.value)/100;
		fm.credit_amt.value = parseDecimal(car_price2*credit_per);
	}	
	

	//���� ���԰� �հ�
	function sum_car_f_amt2(){
		var fm = document.form1;
		
		var purc_gu 		= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_price = setCarPrice('car_c_price');
		if(fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0') set_car_amt(fm.dc_c_amt);
		fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)));
		fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.tot_cv_amt.value)));
		fm.car_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_c_amt.value)));
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }	
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
			//������
			if('<%=ej_bean.getJg_w()%>'=='1'){	
				fm.car_f_amt.value  = parseDecimal(<%=cm_bean.getCar_b_p2()%>);
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));	
			}else if('<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				fm.car_f_amt.value  = parseDecimal(toInt(fm.v_o_3.value));
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));			
			}
		}
		sum_car_f_amt_b();
		sum_tax_amt();
	}
	
	//����DC
	function search_dc(){
		var fm = document.form1;
		window.open("search_dc.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&car_fs_amt="+fm.car_fs_amt.value+"&car_fv_amt="+fm.car_fv_amt.value, "COMP_DC", "left=100, top=100, height=200, width=800, scrollbars=yes, status=yes");
	}
	
	//�Ǻ�����-�� ���÷���
	function display_ip(){
		var fm = document.form1;
		var insur_per = fm.insur_per.options[fm.insur_per.selectedIndex].value;
		if(insur_per == '1'){ 						//�Ƹ���ī
			tr_ip.style.display		= 'none';
			tr_ip2.style.display		= 'none';
		}else{								//��
			tr_ip.style.display		= '';
			tr_ip2.style.display		= '';
		}		
	}	
	
	//�������� ���÷���
	function display_gi(){
		var fm = document.form1;
		if(fm.gi_st[0].checked == true){				//����
			<%for(int f=1; f<=gin_size ; f++){%>
			tr_gi<%=f+1%>.style.display		= '';
			<%}%>
		}else{								//����
			<%for(int f=1; f<=gin_size ; f++){%>
			tr_gi<%=f+1%>.style.display		= 'none';
			<%}%>			
		}		
	}	
		
	//�뿩�Ⱓ ����
	function set_cont_date(obj){
		var fm = document.form1;
		var rent_way = fm.rent_way.value;
		if(fm.con_mon.value == ''){
			return;
		}
		fm.action='/fms2/lc_rent/get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();	
	}
	
	//���/����: �������� �Է½� �ڵ�������� ����..
	function enter_fee(obj, rent_dt)	{		var keyValue = event.keyCode;		if (keyValue =='13') set_fee_amt(obj, rent_dt);	}	
	//���/����: ���ް�, �ΰ���, �հ� �Է½� �ڵ����
	function set_fee_amt(obj, rent_dt)
	{
		var fm = document.form1;	
		var car_price = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price);
		if(rent_dt == '') rent_dt = <%=base.getRent_dt()%>;
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
		//Ư�����
		//20190513 �̻��
		//if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn[0].checked == true){
		//	s_dc_amt = <%=cd_bean.getCar_d_p()%>;
		//	var s_dc_per = <%=cd_bean.getCar_d_per()%>;
		//	if(s_dc_per > 0){ s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt; }
		//}
		car_price = car_price - s_dc_amt;
		
		
		//������---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			}
			sum_pp_amt();			
		}else if(obj==fm.grt_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
				
			}
			sum_pp_amt();		
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			}
			sum_pp_amt();			
		}else if(obj==fm.pp_v_amt){ 	//������ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			}		
			sum_pp_amt();	
		}else if(obj==fm.pp_amt){ 		//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));			
					
			if(car_price > 0){
				fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			}			
			sum_pp_amt();
		//���ô뿩��---------------------------------------------------------------------------------			
		}else if(obj==fm.ifee_s_amt){ 	//���ô뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ifee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
		
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			}			
			sum_pp_amt();
		}else if(obj==fm.ifee_v_amt){ 	//���ô뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
		
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
				
			}	
			sum_pp_amt();					
		}else if(obj==fm.ifee_amt){ 	//���ô뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));			
					
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));	
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			}	
			sum_pp_amt();	
		//�ִ��ܰ���---------------------------------------------------------------------------------			
		}else if(obj==fm.max_ja){ 		//�ִ��ܰ���
			fm.ja_amt.value 	= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.max_ja.value) /100,-3) );
			fm.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));			
		}else if(obj==fm.ja_s_amt){ 	//�ִ��ܰ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) * 0.1 );
			fm.ja_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));			
			//fm.max_ja.value 	= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
		}else if(obj==fm.ja_v_amt){ 	//�ִ��ܰ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ja_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));			
		}else if(obj==fm.ja_amt){		//�ִ��ܰ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));		
			if(car_price > 0){	
				fm.max_ja.value 	= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
			}

				
		//�����ܰ���---------------------------------------------------------------------------------			
		}else if(obj==fm.app_ja){ 		//�����ܰ���
			fm.ja_r_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.app_ja.value) /100,-3) );
			fm.ja_r_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
		}else if(obj==fm.ja_r_s_amt){ 	//�����ܰ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
			//fm.app_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
		}else if(obj==fm.ja_r_v_amt){ 	//�����ܰ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_amt){		//�����ܰ� �հ�
			obj.value = parseDecimal(obj.value);
			fm.ja_r_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));		
			if(car_price > 0){	
				fm.app_ja.value 	= replaceFloatRound(toInt(parseDigit(fm.ja_r_amt.value)) / car_price );
			}
		//���Կɼ���---------------------------------------------------------------------------------			
		}else if(obj==fm.opt_s_amt){ 	//���Կɼ� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));		
			if(car_price > 0){	
				fm.opt_per.value 	= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
			}
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){				
					fm.app_ja.value		= fm.max_ja.value;
					fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
					fm.ja_r_amt.value 	= fm.ja_amt.value;		
				}else{				
					fm.app_ja.value		= fm.opt_per.value;
					fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
					fm.ja_r_amt.value 	= fm.opt_amt.value;
				}
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked 	= true;				
			}
		}else if(obj==fm.opt_v_amt){ 	//���Կɼ� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
					fm.app_ja.value		= fm.max_ja.value;
					fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
					fm.ja_r_amt.value 	= fm.ja_amt.value;		
				}else{				
					fm.app_ja.value		= fm.opt_per.value;
					fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
					fm.ja_r_amt.value 	= fm.opt_amt.value;
				}
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked 	= true;				
			}			
		}else if(obj==fm.opt_amt){ 		//���Կɼ� �հ�
			obj.value = parseDecimal(obj.value);
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
				fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));	
				if(car_price > 0){		
					fm.opt_per.value 	= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
				}
				if(toInt(parseDigit(fm.opt_amt.value)) >0){
					if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
						fm.app_ja.value		= fm.max_ja.value;
						fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
						fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
						fm.ja_r_amt.value 	= fm.ja_amt.value;		
					}else{				
						fm.app_ja.value		= fm.opt_per.value;
						fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
						fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
						fm.ja_r_amt.value 	= fm.opt_amt.value;
					}
					fm.opt_chk[1].checked = true;
				}else{
					fm.app_ja.value		= fm.max_ja.value;
					fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
					fm.ja_r_amt.value 	= fm.ja_amt.value;
					fm.opt_chk[0].checked 	= true;				
				}
			}
		//���뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.fee_s_amt){ 	//���뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
		}else if(obj==fm.fee_v_amt){ 	//���뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value		= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.fee_amt){ 		//���뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
		
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
	
	//���Կɼ�����
	function opt_display(st, rent_dt){
		var fm = document.form1;	
		
		if(rent_dt == '') rent_dt = <%=base.getRent_dt()%>;
		
		if(st == ''){
			if(fm.opt_chk[0].checked == true)		st = '0';
			else if(fm.opt_chk[1].checked == true)		st = '1';
		}
		
		if(st == '0'){
			fm.app_ja.value		= fm.max_ja.value;
			fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
			fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
			fm.ja_r_amt.value 	= fm.ja_amt.value;
			fm.opt_s_amt.value = 0;
			fm.opt_v_amt.value = 0;
			fm.opt_amt.value = 0;
			fm.opt_per.value = 0;
		}else if(st == '1'){
			if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;		
			}else{		
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;		
			}
		}		
	}
	
	//�������� ��������
	function setCarPrice(st){
		var fm = document.form1;
		var car_price = 0;
		if(st == 'car_c_price')		car_price = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));
		if(st == 'car_price2')		car_price	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		if(st == 'car_f_price')		car_price = toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		//������DC�� ����
		if(st == 'car_f_price' && <%=base.getRent_dt()%> >= 20130501 && '<%=ej_bean.getJg_w()%>'=='1'){
			car_price 	= toInt(parseDigit(fm.car_f_amt.value));
		}
		return car_price;
	}
	//DC�ݾ� ��������
	function setDcAmt(car_price){
		var fm = document.form1;		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		//�Ϲ� ������ ��Ʈ������ ����D/C�ݾ� Ư�Ҽ����ݿ�---------------
		var purc_gu 	= fm.purc_gu.value;
		var s_st 			= fm.s_st.value;
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);
				s_dc_amt = Math.round(s_dc_amt*(1+toFloat(fm.v_o_2.value)));
			}
		}
		//������
		if('<%=ej_bean.getJg_w()%>'=='1'){ s_dc_amt = 0; }
		return s_dc_amt;
	}	
	//DC�ݾ� ��������
	function setDcAmt2(car_price){
		var fm = document.form1;		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		//������
		if('<%=ej_bean.getJg_w()%>'=='1'){ s_dc_amt = 0; }
		return s_dc_amt;
	}		
	
	//������ �հ�
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		

		var car_price = setCarPrice('car_price2');
		var s_dc_amt 	= setDcAmt2(car_price);	
    	car_price = car_price - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));    	
				
		var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
		if(pp_price>0 && car_price>0){
			fm.credit_r_per.value = replaceFloatRound(pp_price / car_price );
			fm.credit_r_amt.value = parseDecimal(pp_price);
		}
	}

		
	//�뿩�� DC�� ���
	function dc_fee_amt(){
		var fm = document.form1;
		
		var pp_s_amt		= toInt(parseDigit(fm.pp_s_amt.value));		//������
		var fee_s_amt		= toInt(parseDigit(fm.fee_s_amt.value));	//���뿩��(����)
		var inv_s_amt		= toInt(parseDigit(fm.inv_s_amt.value));	//����뿩��(����)
		var con_mon		= toInt(parseDigit(fm.con_mon.value));		//�뿩�Ⱓ 
		var dc_ra;
		
		//�����ݿ��� �����.
		if(<%=base.getRent_dt()%> < 20150512){			
			if(fee_s_amt > 0 && inv_s_amt > 0){
				dc_ra = (1 - (pp_s_amt+fee_s_amt*con_mon)/(pp_s_amt+inv_s_amt*con_mon))*100;
				fm.dc_ra.value = parseFloatCipher3(dc_ra,1);
			}
		}
	}				
	
	//�����뿩�� ��� (����)
	function estimate(rent_st, rent_dt, rent_start_dt, st){
		var fm = document.form1;
		
		set_fee_amt(fm.opt_amt, rent_dt);
	
		if(fm.con_mon.value == '')			{ alert('�̿�Ⱓ�� �Է��Ͻʽÿ�.');		return;}
		if(fm.driving_age.value == '')			{ alert('�����ڿ����� �����Ͻʽÿ�.');		return;}
		if(fm.gcp_kd.value == '')			{ alert('�빰����� �����Ͻʽÿ�.');		return;}		
		if(fm.dec_gr.value == '')			{ alert('�ſ����� �����Ͻʽÿ�.');		return;}	
		
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.car_gu.value == '1' && fm.dir_pur_yn[0].checked == false && fm.dir_pur_yn[1].checked == false){	alert('Ư������θ� �����Ͽ� �ֽʽÿ�.'); fm.dir_pur_yn[0].focus(); return; }
		
		// �׽��� ���� �뿩�Ⱓ ���� ����. 20210225
		<%-- if ('<%=cm_bean.getCar_comp_id()%>' == '0056') {
			if(fm.con_mon.value > 48) {
				alert('�׽��������� ��� 48���� �̻� ������ �Ұ� �մϴ�.');
				fm.con_mon.focus();
				return;
			}
		} --%>
		
		var agree_dist 		= toInt(parseDigit(fm.agree_dist.value));
		fm.fee_rent_st.value = rent_st;
		fm.fee_rent_dt.value = rent_dt;
				
		var car_price 	= setCarPrice('car_price2');
		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '����ƮDC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		
		//�Ϲ� ������ ��Ʈ������ ����D/C�ݾ� Ư�Ҽ����ݿ�---------------
		var purc_gu 	= fm.purc_gu.value;
		var s_st 			= fm.s_st.value;
		if(purc_gu == ''){	alert("���������� �����Ͻʽÿ�."); return; }
		if(purc_gu == '1'){//����1
		}else{//����2(�鼼)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				//����D/C �鼼�� �ݿ� = ����D/C*(1+Ư�Ҽ���);	������DC�� ����				
				if(<%=base.getRent_dt()%> >= 20130501 && '<%=ej_bean.getJg_w()%>'=='1'){
				}else{
					s_dc_amt = Math.round(s_dc_amt*(1+toFloat(fm.v_o_2.value)));
				}
			}
		}		
		
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
		
		fm.o_1.value 		= car_price - s_dc_amt;
		fm.t_dc_amt.value 	= s_dc_amt;
		fm.esti_stat.value 	= st;
		
		//Ư�����
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn[0].checked == true){
			fm.o_1.value 		= car_price;
			fm.t_dc_amt.value 	= 0;
			
			if(<%=base.getRent_dt()%> >= 20130501){
				s_dc_amt = <%=cd_bean.getCar_d_p()%>;
				var s_dc_per = <%=cd_bean.getCar_d_per()%>;
				if(s_dc_per > 0){
					s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt;					
				}
				fm.o_1.value 		= car_price - s_dc_amt;
				fm.t_dc_amt.value 	= s_dc_amt;
			}
		}		
		
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';			
		}
		
		if(fm.car_cng_yn.value == 'Y'){
			if('<%=base.getDlv_dt()%>' != ''){
				fm.fee_rent_dt.value = '<%=base.getDlv_dt()%>';
			}else{
				if('<%=pur.getDlv_est_dt()%>' != ''){
					fm.fee_rent_dt.value = '<%=AddUtil.replace(pur.getDlv_est_dt(),"-","")%>';
				}
			}								
		}
		
		//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
		if('<%=base.getCar_st()%><%=max_fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('�������� ���� �����⺻�ĸ� �����մϴ�.');
				return;
			}			
		}			
				
		<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ������ �Ϲݰ�����  %>
			if(<%=base.getRent_dt()%> >= 20190215 && <%=base.getRent_dt()%> < 20191217){
				if(fm.return_select.value == ''){ alert('������ �μ�/�ݳ� ������ �����Ͻʽÿ�.'); return; }
				//�Ϲݽ��� �μ�/�ݳ� �������� �Ҽ� ����.
				if(fm.rent_way.value == '1' && fm.return_select.value == '0'){
					alert('�Ϲݽ��� ������ �μ�/�ݳ� �������� ������ �� �����ϴ�. ');
					return;
				}
				//�μ�/�ݳ� ������ - ���Կɼ�����
				if(fm.return_select.value == '0'){
					fm.opt_chk[1].checked = true;	
				//�ݳ��� - ���ԿɼǾ���	
				}else if(fm.return_select.value == '1'){
					fm.opt_chk[0].checked = true;	
					fm.opt_s_amt.value = 0;
					fm.opt_v_amt.value = 0;
					fm.opt_amt.value = 0;
					fm.opt_per.value = 0;
				}
				opt_display('', '');
			}
		<%}%>
		
		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;					
		fm.action='get_fee_estimate_20090901.jsp';
				
		<%	if(cm_bean.getJg_code().equals("")){%>
		alert("�����ܰ��ڵ尡 �����ϴ�. ������������ �Է��Ͻʽÿ�.");
		return;
		<%	}%>
		
		if(confirm('�������� ������� '+fm.comm_r_rt.value+'%�� �����˴ϴ�. ����Ͻðڽ��ϱ�?')){		
			fm.submit();
		}
		
		dc_fee_amt();
		
	}
	
	//����������� ���÷���
	function display_tae(){
		var fm = document.form1;
		if(fm.prv_dlv_yn[0].checked == true){					//����
			tr_tae2.style.display		= 'none';
		}else{									//�ִ�
			tr_tae2.style.display		= '';
		}		
	}

	//��������� ��ȸ
	function car_search(st)	{		var fm = document.form1;		window.open("search_res_car.jsp?taecha=Y&client_id=<%=base.getClient_id()%>", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");	}	
	
	
	
	//�����Ҵ���� ��ȸ
	function search_emp(st){		
		var fm = document.form1;		
		var one_self = "N";		
		var pur_bus_st = "4";
		if(fm.one_self[0].checked == true) one_self = "Y";		
		window.open("search_emp.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self="+one_self+"&pur_bus_st="+pur_bus_st+"&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");	
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
			fm.emp_bank.value = '';
			fm.emp_bank_cd.value = '';
			fm.emp_acc_no.value = '';
			fm.emp_acc_nm.value = '';			
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
	
	//��������
	function reset_car(){
		var fm = document.form1;
		window.open('reset_car.jsp<%=valus%>', "reset_car", "left=100, top=100, width=800, height=600, scrollbars=yes"); 
	}
	
	//����
	function update(idx){
		var fm = document.form1;
		
	
		if(idx == 0 || idx == 99){

	
			if(fm.rent_st.value == '')			{ alert('��౸���� Ȯ���Ͻʽÿ�.'); 		return;}			
			if(fm.rent_way.value == '')			{ alert('���������� Ȯ���Ͻʽÿ�.'); 		return;}
			if(fm.bus_agnt_id.value.substring(0,1) == '1')	{ alert('�����븮���� �μ��� ���õǾ����ϴ�. Ȯ�����ּ���.'); return; }

			
			
			if(fm.car_st.value != '<%=base.getCar_st()%>'){
				alert('�뵵������ �����ϴ� ��쿡 �뿩��� �� �������� ���� Ȯ���ϰ� �����ϼž� �մϴ�.');
			}
			
			if(fm.rent_way.value != '<%=max_fee.getRent_way()%>'){
				alert('���������� �����ϴ� ��쿡 �뿩��� ���� Ȯ���ϰ� �����ϼž� �մϴ�.');
			}
			
		}else if(idx == 1 || idx == 99){
		
			if(fm.client_id.value == '')	{ alert('���� �����Ͻʽÿ�.'); 		return;}
			if(fm.t_addr[0].value == '')	{ alert('�����ּҸ� Ȯ���Ͻʽÿ�.'); 		return;}
			
			<%for(int i = 0 ; i <= mgr_size ; i++){%>
			fm.mgr_email[<%=i%>].value = fm.email_1[<%=i%>].value+'@'+fm.email_2[<%=i%>].value;
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
			if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_emp5.value == ''){
				alert('�߰������� ���������ȣ �̸��� �Է��Ͻʽÿ�.');
				return;
			}
			if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_rel5.value == ''){
				alert('�߰������� ���������ȣ ���踦 �Է��Ͻʽÿ�.');
				return;
			}
			if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_result5.value != '1'){
				alert('�߰��������� ���������������� Ȯ�����ּ���. �����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�.');
				return;
			}
		
		}else if(idx == 2 || idx == 99){
		
			// ����, ���λ���ڵ� ��ǥ �������� ��� 20210308
			<%-- if('<%=client.getClient_st()%>' == '1' && fm.client_share_st[0].checked == false && fm.client_share_st[1].checked == false){ --%>		
			if(fm.client_share_st[0].checked == false && fm.client_share_st[1].checked == false){		
				alert('��ǥ�̻� ���������ο��θ� �����Ͻʽÿ�.'); return;			
			}
			if('<%=client.getClient_st()%>' != '1'){		
				fm.client_share_st[1].checked = true;		
			}
		
			if('<%=client.getClient_st()%>' !='2' && fm.client_guar_st[1].checked == true){		
				if(fm.guar_con.options[fm.guar_con.selectedIndex].value == '')		{ alert('��ǥ�̻纸�� ���������� �����Ͻʽÿ�.'); 	return;}			
				if(fm.guar_sac_id.value == '')						{ alert('��ǥ�̻纸�� ���� �����ڸ� �����Ͻʽÿ�.'); 	return;}						
			}
			
			if(fm.guar_st[0].checked == true){
				if(fm.gur_nm[0].value == '')	{ alert('���뺸���� ������ �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_ssn[0].value == '')	{ alert('���뺸���� ��������� �Է��Ͻʽÿ�.'); 		return;}
				if(fm.t_addr[2].value == '')	{ alert('���뺸���� �ּҸ� �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_tel[0].value == '')	{ alert('���뺸���� ����ó�� �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_rel[0].value == '')	{ alert('���뺸���� ���踦 �Է��Ͻʽÿ�.'); 			return;}												
			}
		
		}else if(idx == 3 || idx == 99){
				
			if(fm.client_st.value == '1'){
				var open_year = '<%=AddUtil.replace(client.getOpen_year(),"-","")%>';
				var now = new Date();
				var base_dt = now.getYear()+'0101';
				if(open_year != '' && toInt(open_year) < toInt(base_dt)){
					if(fm.c_ba_year_s.value == '' || fm.c_ba_year.value == '')		{ alert('��� �������ڸ� �Է��Ͻʽÿ�.'); 		return;}
				}
			}
				
		}else if(idx == 4 || idx == 99){
		
		}else if(idx == 5 || idx == 99){
		
		}else if(idx == 7 || idx == 99){
		
			if(fm.dec_gr.value == '')				{ alert('����ſ����� �����Ͻʽÿ�.'); 						return;}
		
		}else if(idx == '8_1' || idx == 99){
			
			if(fm.color.value == '')				{ alert('�뿩����-������ �Է��Ͻʽÿ�.'); 			fm.color.focus(); 		return; }
			if(<%=base.getRent_dt()%> > 20161231 && fm.car_gu.value == '1'){//����
				if(fm.in_col.value == ''){ alert('�뿩����-��������� �Է��Ͻʽÿ�.');fm.in_col.focus();return; }	
			}
			
			if(fm.car_ext.value == '')				{ alert('�뿩����-��������� �Է��Ͻʽÿ�.'); 			fm.car_ext.focus(); 		return; }
			
			<%if(base.getCar_mng_id().equals("") || AddUtil.parseInt(base.getRent_dt()) > 20180208){%>
			
			<%if(ej_bean.getJg_g_7().equals("3")){//������%>
			if (fm.ecar_loc_st.value == '') {	
				alert("������ ���ּ����� �����Ͻʽÿ�.");
				return;
			} 
//				else {
				//1.����, 2.����, 3.�λ�, 4.����, 5.����, 6.��õ, 7.��õ, 8.����, 9.����, 10.�뱸
				
				//���� -> ���� ���
				/* if(fm.ecar_loc_st.value == '0'){
					fm.car_ext.value = '1';
				}
				//��õ,��� -> ���� ���
				if(fm.ecar_loc_st.value == '1'){
					fm.car_ext.value = '1';
				}
				//���� -> ���� ���
				if(fm.ecar_loc_st.value == '2'){
					fm.car_ext.value = '1';
				}
				//���� -> ���� ���
				if(fm.ecar_loc_st.value == '3'){
					fm.car_ext.value = '1';
				}
				//���� -> ���� ���
				if(fm.ecar_loc_st.value == '4'){
					fm.car_ext.value = '9';
				}
				//�뱸 -> �뱸 ���
				if(fm.ecar_loc_st.value == '5'){
					fm.car_ext.value = '10';
				}
				//�λ� -> ���� ���
				if(fm.ecar_loc_st.value == '6'){
					fm.car_ext.value = '1';
				}
				//����,�泲,���(��������) -> ���� ���
				if(fm.ecar_loc_st.value == '7'){
					fm.car_ext.value = '1';
				}
				//���(�뱸����) -> ���� ���
				if(fm.ecar_loc_st.value == '8'){
					fm.car_ext.value = '1';
				}
				//���,�泲 -> ���� ���
				if(fm.ecar_loc_st.value == '9'){
					fm.car_ext.value = '1';
				}
				//����,����(��������) -> ���� ���
				if(fm.ecar_loc_st.value == '10'){
					fm.car_ext.value = '1';
				} */
				
				// ���� ����ȭ����(�����: ����) �� ��� ������ �� �ּ����� ���� ���� ��õ���� ���. 2021.02.18.
				// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� ��õ ���. 20210224
				// ����ȭ���� �� ������ ���ּ��� ���� �ǵ������ ���. ����/��õ/����/����/�뱸/�λ� �� ������ ���ּ����� �λ� ���. 20210520
<%-- 						<%if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435")  || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%> --%>
//						fm.car_ext.value = '1';
<%-- 						<%} else {%> --%>
//						if(fm.ecar_loc_st.value == '0'){
//							fm.car_ext.value = '1';
//						} else if(fm.ecar_loc_st.value == '1'){
//							fm.car_ext.value = '7';
//						} else if(fm.ecar_loc_st.value == '3'){
//							fm.car_ext.value = '5';
//						} else if(fm.ecar_loc_st.value == '4'){
//							fm.car_ext.value = '9';
//						} else if(fm.ecar_loc_st.value == '5'){
//							fm.car_ext.value = '10';
//						} else if(fm.ecar_loc_st.value == '6'){
//							fm.car_ext.value = '3';
//						} else{
//							//fm.car_ext.value = '7';
//							fm.car_ext.value = '3';		// ������ ���� �λ����� ��� ó��.
//						}
<%-- 						<%}%> --%>
				
				<%-- <%if (cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")) {//20191016 ��3�� ����ε��%>
					// fm.car_ext.value = '1';
					fm.car_ext.value = '7'; // 20210216 �׽��� ��3 �ǵ������ ��õ���� ����.
				<%} else if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435")  || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {//20200313 �����Ϸ�Ʈ��, ����EV�� �뱸���%>
					//fm.car_ext.value = '7';
					fm.car_ext.value = '1';
				<%}%> --%>
//				}
			<%}%>
			
			<%if(ej_bean.getJg_g_7().equals("4")){//������%>
				if(fm.hcar_loc_st.value == ''){
					alert("������ ���ּ����� �����Ͻʽÿ�.");
					return;			
				}
//				else{
//					fm.car_ext.value = '1';
//				}
			//��õ -> ��õ ���
//				if(fm.hcar_loc_st.value == '1'){	
//					fm.car_ext.value = '7';
//				}
			//���� ���� -> ������ ���� ���
<%-- 					if(fm.hcar_loc_st.value == '3' && '<%=base.getCar_st()%>' == '3'){	 --%>
//					fm.car_ext.value = '5';
//				}
			//����/����/���� -> ���� ���
//				if(fm.hcar_loc_st.value == '4'){	
//					fm.car_ext.value = '9';
//				}
			//�λ�/���/�泲 -> �λ� ���
//				if(fm.hcar_loc_st.value == '6'){	
//					fm.car_ext.value = '3';
//				}
			//20190701 �������� ��� ��õ
			//fm.car_ext.value = '7';
//				fm.car_ext.value = '7'; //20191206 �������� ��� ��õ
			//fm.car_ext.value = '1'; //20200324 �������� ��� ��õ -> ����� ���
			<%}%>

			<%-- <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//��������-ģȯ����%>
			if(fm.eco_e_tag.value == ''){	
				alert("�������ｺƼĿ �߱�(�����ͳ� �̿� �����±�)�� �����Ͻʽÿ�.");
				return;
			}		
			/* if(fm.eco_e_tag.value == '1'){
				fm.car_ext.value = '1'; //�������ｺƼĿ �߱޽� ������
			} */
			
				<%if(ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����:��������%>
				if(fm.eco_e_tag.value == '1'){
					alert("������/�������� ���� �������ｺƼĿ �߱�(�����ͳ� �̿� �����±�)�� �Ұ��մϴ�.");
					return;
				}
				<%}else{%>
				if(fm.eco_e_tag.value == '1'){
					fm.car_ext.value = '1'; //�������ｺƼĿ �߱޽� ������
				}
				<%}%>
			
			<%}%> --%>			
		<%}%>	
		
		}else if(idx == 8 || idx == 99){
		
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
					
			if(fm.tint_s_yn.checked == true && toInt(fm.tint_s_per.value) < 50 && '<%=ej_bean.getJg_w()%>' != '1'){
				//alert('�뿩����-��ǰ-��������� �������� �������� 50% �̻� �����մϴ�.'); 				fm.tint_s_per.focus(); 		return;
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
					
		}else if(idx == 9 || idx == 99){

			var car_c_amt = toInt(parseDigit(fm.car_c_amt.value));
			var car_f_amt = toInt(parseDigit(fm.car_f_amt.value));
			if(fm.purc_gu.value == '')		{ alert('��������-���������� �Է��Ͻʽÿ�.'); 			fm.purc_gu.focus(); 		return; }
			if(car_c_amt == 0)				{ alert('��������-�Һ��ڰ� �⺻������ �Է��Ͻʽÿ�.'); 	fm.car_c_amt.focus(); 		return; }
			if(car_f_amt == 0)				{ alert('��������-���԰� ���������� �Է��Ͻʽÿ�.'); 		fm.car_f_amt.focus(); 		return; }
			
			var chk_car_amt1 = Math.abs(toInt(parseDigit(fm.o_car_c_amt.value))-toInt(parseDigit(fm.car_c_amt.value)));
			if(chk_car_amt1 > 50000){
				alert('�������� �Һ��ڰ� �⺻���� ���� �������� ��50,000���� �ѽ��ϴ�. Ȯ���Ͻʽÿ�.');
				return;
			}
			var chk_car_amt2 = Math.abs(toInt(parseDigit(fm.o_car_f_amt.value))-toInt(parseDigit(fm.car_f_amt.value)));
			if(toInt(parseDigit(fm.car_f_amt.value)) > 0 && chk_car_amt2 > 50000){
				alert('�������� ���԰��� ���� �������� ��50,000���� �ѽ��ϴ�. Ȯ���Ͻʽÿ�.');
				return;
			}	
			
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

		}else if(idx == 10 || idx == 99){  
		
			if(fm.insur_per.value == '')				{ alert('�������-�Ǻ����ڸ� �Է��Ͻʽÿ�.'); 		fm.insur_per.focus(); 		return; }
			if(fm.driving_age.value == '')				{ alert('�������-�����ڿ����� �Է��Ͻʽÿ�.'); 		fm.driving_age.focus(); 	return; }			
			<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600  && AddUtil.parseInt(a_e) != 409){%>	
				if(fm.com_emp_yn.value == '')			{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');	fm.com_emp_yn.focus(); 		return; }
				if(fm.com_emp_yn.value == 'N' && fm.others.value == ''){	alert('* ���ΰ��� ��������������Ư�� �̰��� ������ �������-��� �Է��Ͻʽÿ�.');	return; }
			<%}else if(AddUtil.parseInt(client.getClient_st()) >2 && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
				//���λ���� ������������ ���Ѿ���
				if(fm.com_emp_yn.value == '')			{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');	fm.com_emp_yn.focus(); 		return; }
			<%}else{%>
				if(fm.com_emp_yn.value == 'Y')			{ alert('�������-��������������Ư�� ���Դ���� �ƴѵ� �������� �Ǿ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');	fm.com_emp_yn.focus(); 	return; }
			<%}%>
			if(fm.gcp_kd.value == '')				{ alert('�������-�빰��� ���Աݾ��� �Է��Ͻʽÿ�.'); 		fm.gcp_kd.focus(); 		return; }
			if(fm.bacdt_kd.value == '')				{ alert('�������-�ڱ��ü��� ���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.bacdt_kd.focus(); 		return; }
			if(fm.canoisr_yn.value == '')				{ alert('�������-������������ ���Կ��θ� �Է��Ͻʽÿ�.'); 	fm.canoisr_yn.focus(); 		return; }
			if(fm.cacdt_yn.value == '')				{ alert('�������-�ڱ��������� ���Կ��θ� �Է��Ͻʽÿ�.'); 	fm.cacdt_yn.focus(); 		return; }
			if(fm.eme_yn.value == '')				{ alert('�������-����⵿ ���Կ��θ� �Է��Ͻʽÿ�.'); 		fm.eme_yn.focus(); 		return; }
				
			//20150626 �����⺻�ĸ� �������� �� ���ð���, �������ڰ� ���̸� �Ǻ����ڵ� ���̿��� �Ѵ�.			
			if('<%=base.getCar_st()%><%=max_fee.getRent_way()%>' == '33'){
				if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
					alert('�������� ���̸� �Ǻ����ڵ� ���̿��� �մϴ�.');
					return;					
				}
			}else{
				if(fm.insurant.value == '2'){
					alert('�������� ���� �����⺻�ĸ� �����մϴ�.');
					return;
				}			
			}	
			
			<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
			if(fm.driving_age.value=='1' && fm.age_scp.value!='1'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';}
			if(fm.driving_age.value=='3' && fm.age_scp.value!='4'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
			if(fm.driving_age.value=='0' && fm.age_scp.value!='2'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
			if(fm.driving_age.value=='2' && fm.age_scp.value!='3'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}
			if(fm.driving_age.value=='5' && fm.age_scp.value!='5'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}			
			if(fm.driving_age.value=='6' && fm.age_scp.value!='6'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}			
			if(fm.driving_age.value=='7' && fm.age_scp.value!='7'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}			
			if(fm.driving_age.value=='8' && fm.age_scp.value!='8'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ';		}												
			
			if(fm.gcp_kd.value=='3' && fm.vins_gcp_kd.value!='6'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}
			if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}				
			if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}
			if(fm.gcp_kd.value=='4' && fm.vins_gcp_kd.value!='7'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'�빰���� ';		}				
			
			if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk3.value =	'�ڱ��ü��� ';	}
			if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');	fm.ins_chk3.value =	'�ڱ��ü��� ';	}
			
			if(fm.con_f_nm.value=='1' && fm.insur_per.value!='1'){		alert('���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk4.value =	'�Ǻ����� ';		}
			if(fm.con_f_nm.value=='2' && fm.insur_per.value!='2'){		alert('���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk4.value =	'�Ǻ����� ';		}
			<%}%>		
						
			var car_ja 	= toInt(parseDigit(fm.car_ja.value));
			if(car_ja == 0)						{ alert('�������-������å���� �Է��Ͻʽÿ�.'); 		fm.car_ja.focus(); 		return; }
  			<%if(ej_bean.getJg_w().equals("1")){//������%>
			if(fm.car_ja.value != fm.imm_amt.value){
				if(fm.ja_reason.value == '')			{ alert('�������-������å�� ��������� �Է��Ͻʽÿ�.'); 	fm.ja_reason.focus(); 		return; }
				if(fm.rea_appr_id.value == '')			{ alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.'); 	fm.rea_appr_id.focus(); 	return; }
			}
			<%}else{%>
			if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
				if(fm.ja_reason.value == '')			{ alert('�������-������å�� ��������� �Է��Ͻʽÿ�.'); 	fm.ja_reason.focus(); 		return; }
				if(fm.rea_appr_id.value == '')			{ alert('�������-������å�� ���� �����ڸ� �Է��Ͻʽÿ�.'); 	fm.rea_appr_id.focus(); 	return; }
			}			
			<%}%>			
			if(fm.insur_per.value == '2'){
				if(fm.ip_insur.value == '')			{ alert('�������-�Ժ�ȸ�� �������� �Է��Ͻʽÿ�.'); 		fm.ip_insur.focus(); 		return; }
				if(fm.ip_acar.value == '')			{ alert('�������-�Ժ�ȸ�� �븮������ �Է��Ͻʽÿ�.'); 		fm.ip_acar.focus(); 		return; }
				if(fm.ip_dam.value == '')			{ alert('�������-�Ժ�ȸ�� ����ڸ��� �Է��Ͻʽÿ�.'); 		fm.ip_dam.focus(); 		return; }
				if(fm.ip_tel.value == '')			{ alert('�������-�Ժ�ȸ�� ����ó�� �Է��Ͻʽÿ�.'); 		fm.ip_tel.focus(); 		return; }
			}
			
		
		}else if(idx == 11 || idx == 99){
		
			if(fm.gi_st[0].checked == true){//����
				var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
				//var gi_fee 	= toInt(parseDigit(fm.gi_fee.value));
				if(gi_amt == 0)						{ alert('��������-���Աݾ��� �Է��Ͻʽÿ�.'); 				fm.gi_amt.focus(); 			return; }
				//if(gi_fee == 0)						{ alert('��������-��������Ḧ �Է��Ͻʽÿ�.'); 			fm.gi_fee.focus(); 			return; }
			}else if(fm.gi_st[1].checked == true){//����
				fm.gi_amt.value 	= 0;
				fm.gi_fee.value 	= 0;				
			}
		


		}else if(idx == 12 || idx == 99){
		
			
			if(fm.con_mon.value == '')				{ alert('�뿩���-�̿�Ⱓ�� �Է��Ͻʽÿ�.'); 			fm.con_mon.focus(); 		return; }
				
				
			if(toInt(parseDigit(fm.ja_amt.value)) == 0 && toInt(parseDigit(fm.ja_r_amt.value)) > 0){
				fm.ja_s_amt.value 	= fm.ja_r_s_amt.value;
				fm.ja_v_amt.value 	= fm.ja_r_v_amt.value;
				fm.ja_amt.value 	= fm.ja_r_amt.value;
				fm.max_ja.value 	= fm.app_ja.value;								
			}				
				
			if(fm.max_ja.value == '')				{ alert('�뿩���-�ִ��ܰ����� �Է��Ͻʽÿ�.'); 		fm.max_ja.focus(); 		return; }
			var ja_amt = toInt(parseDigit(fm.ja_amt.value));
			if(toInt(fm.cls_r_per.value) < 1)			{ alert('�뿩���-�ߵ������������� Ȯ���Ͻʽÿ�.'); 		fm.cls_r_per.focus(); 		return;	}
			var fee_amt = toInt(parseDigit(fm.fee_amt.value));
			var inv_amt = toInt(parseDigit(fm.inv_amt.value));							
				
			var agree_dist 		= toInt(parseDigit(fm.agree_dist.value));
			var over_run_amt 	= toInt(parseDigit(fm.over_run_amt.value));
			var rtn_run_amt 	= toInt(parseDigit(fm.rtn_run_amt.value));
			
			
			if(fm.car_gu.value == '1' && fm.agree_dist.value !='������'){//����
			<%if(AddUtil.parseInt(base.getRent_dt()) > 20130604){%>				
				if(agree_dist == 0)				{ alert('�뿩���-��������Ÿ��� �Է��Ͻʽÿ�.'); 			fm.agree_dist.focus(); 		return; }
				if(over_run_amt == 0)			{ alert('�뿩���-�ʰ�����δ���� �Է��Ͻʽÿ�.'); 			fm.over_run_amt.focus(); 	return; }
				<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
					if(fm.rtn_run_amt_yn.value == '')								{ alert('�뿩���-ȯ�޴뿩�����뿩�θ� �Է��Ͻʽÿ�.'); 	fm.rtn_run_amt_yn.focus(); 	return; }
					if(rtn_run_amt == 0 && fm.rtn_run_amt_yn.value == '0')			{ alert('�뿩���-ȯ�޴뿩�Ḧ �Է��Ͻʽÿ�.'); 			fm.rtn_run_amt.focus(); 	return; }
					if(rtn_run_amt > 0 && fm.rtn_run_amt_yn.value == '1')			{ alert('�뿩���-ȯ�޴뿩��������̹Ƿ� ȯ�޴뿩�� 0�� ó���մϴ�.'); fm.rtn_run_amt.value = 0; }
				<%}%>
			<%}%>
			}
				
				
			if(fm.fee_pay_tm.value == '')				{ alert('�뿩���-����Ƚ���� �Է��Ͻʽÿ�.'); 			fm.fee_pay_tm.focus(); 		return; }
			if(fm.fee_sh.value == '')				{ alert('�뿩���-���ݱ��и� �Է��Ͻʽÿ�.'); 			fm.fee_sh.focus(); 		return; }
			if(fm.fee_pay_st.value == '')				{ alert('�뿩���-���ι���� �Է��Ͻʽÿ�.'); 			fm.fee_pay_st.focus(); 		return; }
			if(fm.fee_pay_st.value != '1' && fm.cms_not_cau.value == ''){ alert('���ι���� �ڵ���ü�� �ƴ� ��� CMS�̽�������� �Է��Ͻʽÿ�.'); fm.cms_not_cau.focus(); 	return; }
			if(fm.def_st.value == '')				{ alert('�뿩���-��ġ���θ� �Է��Ͻʽÿ�.'); 			fm.def_st.focus(); 		return; }
			if(fm.def_st.value == 'Y'){
				if(fm.def_remark.value == '')				{ alert('�뿩���-��ġ������ �Է��Ͻʽÿ�.');			fm.def_remark.focus();		return; }
				if(fm.def_sac_id.value == '')				{ alert('�뿩���-��ġ �����ڸ� �Է��Ͻʽÿ�.');		fm.def_sac_id.focus();		return; }
			}
			
			//Ư�����(�����̰�����)�̸� ���������� ����.
			if(<%=base.getRent_dt()%> >= 20190610 && toFloat(parseDigit(fm.comm_r_rt.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true && fm.dir_pur_yn[0].checked == true && fm.pur_bus_st[0].checked == false && fm.dir_pur_commi_yn.value == 'Y'){
				alert('�������̸鼭 ���ΰ��̰� ����������� �ִ� Ư������ ���������� �����ϴ�.'); return;
			}
				
			//������ ���
			if('<%=base.getRent_st()%>' == '3'){	
				if(fm.grt_suc_l_cd.value == '')	{ alert('������ ������� �Է��Ͻʽÿ�.'); 	return;}
			}					
			
			<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ������ ����%>
			if(<%=base.getRent_dt()%> >= 20190215 && <%=base.getRent_dt()%> < 20191217){
				if(fm.return_select.value == ''){ alert('������ �μ�/�ݳ� ������ �����Ͻʽÿ�.'); return; }
				//�Ϲݽ��� �μ�/�ݳ� �������� �Ҽ� ����.
				if(fm.rent_way.value == '1' && fm.return_select.value == '0'){
					alert('�Ϲݽ��� ������ �μ�/�ݳ� �������� ������ �� �����ϴ�. ');
					return;
				}
				//�μ�/�ݳ� ������ - ���Կɼ�����
				if(fm.return_select.value == '0'){
					fm.opt_chk[1].checked = true;	
				//�ݳ��� - ���ԿɼǾ���	
				}else if(fm.return_select.value == '1'){
					fm.opt_chk[0].checked = true;	
					fm.opt_s_amt.value = 0;
					fm.opt_v_amt.value = 0;
					fm.opt_amt.value = 0;
					fm.opt_per.value = 0;
				}
				opt_display('', '');
			}	
			<%}%>
			
			if(fm.opt_chk[0].checked == false && fm.opt_chk[1].checked == false)				{ alert('�뿩���-���Կɼ� ���θ� �Է��Ͻʽÿ�.'); 			fm.opt_chk.focus(); 		return; }
			if(fm.opt_chk[1].checked == true){
				if(fm.opt_per.value == '')			{ alert('�뿩���-���Կɼ����� �Է��Ͻʽÿ�.'); 			fm.opt_per.focus(); 		return; }
				var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
				if(opt_amt == 0)					{ alert('�뿩���-���ԿɼǱݾ��� �Է��Ͻʽÿ�.'); 			fm.opt_amt.focus(); 		return; }
			}
			if(fm.opt_chk[0].checked == true){
				var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
				if(opt_amt > 0)						{ alert('�뿩���-���ԿɼǾ������� �Ǿ� ������ ���ԿɼǱݾ��� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.');	fm.opt_amt.focus(); 		return; }
				//fm.opt_s_amt.value = 0;
				//fm.opt_v_amt.value = 0;
				//fm.opt_amt.value = 0;
				//fm.opt_per.value = 0;
			}
			
			var checkSymbol = false;
			var symbol = "<>\"'\\";		// �Է� ���� ����� Ư�� ����(<, >, ', ")
			var con_etc = fm.con_etc.value;
			for(var i=0; i<con_etc.length; i++){
				if(symbol.indexOf(con_etc.charAt(i)) != -1) 	checkSymbol = true;
			}
			if(checkSymbol){		// Ư����� ����� �Ϻ� Ư�� ���� �Է� ���� ó�� ���� 2020.01.03.
				alert('�뿩���-Ư����� ���� ���뿡�� Ư�� ���� �� <, >, \', "\�� ����� �� �����ϴ�.'); return;
			}
			if (con_etc.indexOf("*,***") != -1) {
				alert('�뿩���-Ư����� ���� ���� �� ���뿩�� �λ�ݾ� �Է��� Ȯ���ϼ���.'); return;
			}
		
		}else if(idx == 13 || idx == 99){
		
			if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ 
				alert('��������� �ȵǾ� �ֽ��ϴ�. ���� ������ ����Ͻʽÿ�.');
				fm.tax_type[0].checked = true; 
			}
			
			if(fm.rec_st.value == '')			{ alert('���ݰ�꼭-û�������ɹ���� �Է��Ͻʽÿ�.');			fm.rec_st.focus(); 	return; }
			if(fm.rec_st.value == '1'){
				if(fm.ele_tax_st.value == '')		{ alert('���ݰ�꼭-���ڼ��ݰ�꼭 �ý����� �Է��Ͻʽÿ�.'); 		fm.ele_tax_st.focus();	return; }
				if(fm.ele_tax_st.value == '2'){
					if(fm.tax_extra.value == '')	{ alert('���ݰ�꼭-���ڼ��ݰ�꼭 �����ý��� �̸��� �Է��Ͻʽÿ�.'); 	fm.tax_extra.focus(); 	return; }
				}
			}
		
		}else if(idx == 14 || idx == 99){
		
			
			if(fm.prv_dlv_yn[1].checked == true){
				if(fm.tae_car_no.value == '')		{ alert('���������-�ڵ����� �����Ͻʽÿ�.'); 			fm.tae_car_no.focus(); 		return; }					
				if(fm.tae_car_rent_st.value == '')	{ alert('���������-�뿩�������� �Է��Ͻʽÿ�.'); 		fm.tae_car_rent_st.focus(); 	return; }
				if(fm.tae_req_st.value == '')		{ alert('���������-û�����θ� �����Ͻʽÿ�.'); 		fm.tae_req_st.focus(); 		return; }
				if(fm.tae_req_st.value == '1'){
					if(toInt(parseDigit(fm.tae_rent_fee.value)) == 0)	{ alert('���������-���뿩�Ḧ �Է��Ͻʽÿ�.'); 			fm.tae_rent_fee.focus(); 	return; }
					if(toInt(parseDigit(fm.tae_rent_inv.value)) == 0)	{ alert('���������-�������� �Է��Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
					if(fm.tae_est_id.value == '')	{ alert('���������-������ ����ϱ⸦ �Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
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
				if(toInt(parseDigit(fm.tae_rent_fee.value))>0){
					fm.tae_rent_fee_s.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.tae_rent_fee.value))));
					fm.tae_rent_fee_v.value 	= parseDecimal(toInt(parseDigit(fm.tae_rent_fee.value)) - toInt(parseDigit(fm.tae_rent_fee_s.value)));						
				}
				if(fm.tae_sac_id.value == '')		{ alert('���������-�����ڸ� �����Ͻʽÿ�.'); 			fm.tae_sac_id.focus(); 		return; }
			}
			
		
		}else if(idx == 15 || idx == 99){
		
			if(fm.emp_id[0].value != ''){
				if(fm.comm_rt.value == '' || fm.comm_rt.value == '0')	{ 
					fm.comm_rt.value = 3.0;
				}
				if(toFloat(fm.comm_rt.value) < toFloat(fm.comm_r_rt.value)){ //�ִ������������ ������������� �� Ŭ���� ����.
					alert('������翵�����-�������� �ִ������������ ������������� �� Ŭ�� �� �����ϴ�. Ȯ���Ͻʽÿ�.'); 		fm.comm_rt.focus(); 		return;
				}		
				//Ư�����(�����̰�����)�̸� ���������� ����.
				if(<%=base.getRent_dt()%> >= 20190610 && toFloat(parseDigit(fm.v_comm_r_rt.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true && fm.dir_pur_yn[0].checked == true && fm.dir_pur_commi_yn.value == 'Y'){
					alert('�������̸鼭 ���ΰ��̰� ����������� �ִ� Ư������ ���������� �����ϴ�.'); return;
				}else{
					if(fm.v_comm_r_rt.value == '')		{ alert('������翵�����-�������� ������������� �Է��Ͻʽÿ�.'); 		fm.v_comm_r_rt.focus(); 		return; }				
				}				
				
			}
			
			
			
			//��Ÿ(��ü)
			if(fm.dir_pur_yn[0].checked == false){
				var con_amt 		= toInt(parseDigit(fm.con_amt.value));
				//if(con_amt > 0){
				//	if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){
				//		alert('������ҿ� �������(����)�� ������ ���¸� �Է��Ͻʽÿ�.'); return;
				//	}
				//}	
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value == '�����Ǹ�����'){
					alert('���� �����Ǹ������ε� Ư���� �ƴմϴ�. ������Ҹ� Ȯ���Ͻʽÿ�.'); return;											
				}
				if(fm.dir_pur_commi_yn.value == 'Y'){
					alert('����������� �ְ� Ư�����(�����̰�����)�ε� Ư���� �ƴմϴ�. Ư������� Ȥ�� ��������� ������� Ȯ���Ͻʽÿ�.'); return;
				}
				if(fm.dir_pur_commi_yn.value == 'N'){
					alert('����������� �ְ� Ư�����(�����̰�����)�ε� Ư���� �ƴմϴ�. Ư������� Ȥ�� ��������� ������� Ȯ���Ͻʽÿ�.'); return;
				}
			//Ư�����	
			}else{
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value == ''){
					alert('������Ҹ� �Է��Ͻʽÿ�.'); return;										
				}
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value != '030849'){
						alert('Ư����� ���õǾ����� ������Ұ� �����Ǹ����� �ƴմϴ�. Ȯ���Ͻʽÿ�.'); return;
				}
				if('<%=cm_bean.getCar_comp_id()%>' == '0003' && fm.emp_id[1].value != '038036'){
						alert('Ư����� ���õǾ����� ������Ұ� �����Ǹ����� �ƴմϴ�. Ȯ���Ͻʽÿ�.'); return;
				}
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value != '�����Ǹ�����'){
					alert('���� Ư���ε� �����Ǹ����� �ƴմϴ�. ������Ҹ� Ȯ���Ͻʽÿ�.'); return;											
				}
				if(fm.dir_pur_commi_yn.value == '2'){
					alert('����������� �ְ� ��ü���븮������ε� Ư���Դϴ�. Ư������� Ȥ�� ��������� ������� Ȯ���Ͻʽÿ�.'); return;
				}
			}
			
			if(fm.emp_id[1].value != ''){
				if(fm.con_amt.value == '' || fm.con_amt.value == '0')	{
					
				}else{	
					if(fm.trf_st0.value == '')			{ alert('�������-������ ���޼����� �����Ͻʽÿ�.'); 	fm.trf_st0.focus(); 		return; }
					if(fm.trf_st0.value == '1'){
						if(fm.con_bank.value == '') 	{ alert('�������-������ ���ޱ����縦 �Է��Ͻʽÿ�.'); 	fm.con_bank.focus(); 		return; }
						if(fm.con_acc_no.value == '') 	{ alert('�������-������ ���¹�ȣ�� �Է��Ͻʽÿ�.'); 	fm.con_acc_no.focus(); 		return; }
						if(fm.con_acc_nm.value == '') 	{ alert('�������-������ ���¿����ָ� �Է��Ͻʽÿ�.'); 	fm.con_acc_nm.focus(); 		return; }
						if(fm.con_est_dt.value == '') 	{ alert('�������-������ ���޿������� �Է��Ͻʽÿ�.'); 	fm.con_est_dt.focus(); 		return; }
					}	
				}			
				if(fm.trf_amt5.value == '' || fm.trf_amt5.value == '0')	{
					
				}else{	
					if(fm.trf_st5.value == '')			{ alert('�ӽÿ��ຸ��� ���޼����� �����Ͻʽÿ�.'); 	fm.trf_st5.focus(); 		return; }
					if(fm.trf_st5.value == '1'){
						if(fm.card_kind5.value == '') 	{ alert('�ӽÿ��ຸ��� ���ޱ����縦 �Է��Ͻʽÿ�.'); 	fm.card_kind5.focus(); 		return; }
						if(fm.cardno5.value == '') 		{ alert('�ӽÿ��ຸ��� ���¹�ȣ�� �Է��Ͻʽÿ�.'); 		fm.cardno5.focus(); 	return; }
						if(fm.trf_cont5.value == '') 	{ alert('�ӽÿ��ຸ��� ���¿����ָ� �Է��Ͻʽÿ�.'); 	fm.trf_cont5.focus(); 		return; }
						if(fm.trf_est_dt5.value == '') 	{ alert('�ӽÿ��ຸ��� ���޿������� �Է��Ͻʽÿ�.'); 	fm.trf_est_dt5.focus(); 	return; }
					}	
				}	
			}
					
					
		}
	
		fm.idx.value = idx;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_u_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}							
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

	//�����û�ϱ�
	function sanction_req(){
		var fm = document.form1;
		if(toInt(fm.chk_cnt.value) > 0){
			alert('�Է°� üũ ��� Ȯ���� �ʿ��� �׸��� '+toInt(fm.chk_cnt.value)+'�� �߻��߽��ϴ�.');
			return;
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
		
	//��������������Ư�� �̰��� ���� ó��
	function Com_emp_sac(){
		var fm = document.form1;
		var ment = '';
		if(fm.com_emp_yn.value=='Y'){
			ment = '����';
		}else if(fm.com_emp_yn.value=='N'){
			ment = '�̰���';
		}else{
			alert('��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.'); return;
		}
		fm.idx.value = 'com_emp_sac';
		<%if(client.getClient_st().equals("1")){ %>
		if(ment=='�̰���'){
    		if(fm.others.value == ''){ alert('* ���� ��������������Ư�� �̰��� ������ �������-��� �Է��Ͻʽÿ�.'); return; }
			if(confirm('���� ���� ��������������Ư�� �̰��� ������ �������-��� �Է��Ͻʽÿ�. \n\n ��������������Ư�� �̰��� ���� ó���Ͻðڽ��ϱ�?')){	
				fm.action='lc_b_u_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}
		}else{
			alert('���Խ����� �ʿ�����ϴ�.');
		}	
		<%}else{%>
		if(ment=='����'){
			if(fm.others.value == ''){ alert('* ���� ��������������Ư�� ���� ������ �������-��� �Է��Ͻʽÿ�.'); return; }
			if(confirm('���λ���� ���� ��������������Ư�� ���� ������ �������-��� �Է��Ͻʽÿ�. \n\n ���ǽŰ����ڷ� ��������������Ư�� ���� ����ó���Ͻðڽ��ϱ�?')){	
				fm.action='lc_b_u_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}	
		}else{
			alert('�̰��Խ����� �ʿ�����ϴ�.');	
		}			
		<%}%>
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
		if(cnt == 0){
		 	alert("�ϰ� ����� ��ĵ�׸��� �����ϼ���.");
			return;
		}		
		window.open('about:blank', "SCAN_ALL", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "SCAN_ALL";
		fm.action = "reg_scan_all.jsp";
		fm.submit();
	}
	//��ĵ����-�ϰ�
	function scan_all_copy(){
		var fm = document.form1;			
		window.open('about:blank', "SCAN_ALL_COPY", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "SCAN_ALL_COPY";
		fm.action = "reg_scan_all_copy.jsp";
		fm.submit();
	}
		
	//��ĵ���� ����
	function view_scan(){
		window.open("scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
	
	
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
				
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}		

		fm.action='get_fee_estimate_taecha.jsp';			
							
		fm.submit();
	}		
	
	//�������μ�
	function TaechaEstiPrint(est_id){ 
		var fm = document.form1;  
		var SUBWIN="/acar/secondhand_hp/estimate.jsp?from_page=<%=from_page%>&est_id="+est_id;  	
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}	
	
	//��������������� ���ÿ� ���� �ڱ�δ�� ����
	function setCacdtMeAmt(){
		var fm = document.form1;
		fm.cacdt_memin_amt.value = toInt(fm.cacdt_mebase_amt.value)*0.1;		
		if(toInt(fm.cacdt_mebase_amt.value) >0){
			fm.cacdt_me_amt.value = 50;
		}
	}	
	
	function search_cms(idx){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}			window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");			}
	//�����̰���ϱ�
	function age_search()
	{
		var fm = document.form1;
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/agent/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}	
	//�����̷°����׸� ����
	function item_cng_update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id' || st == 'bus_st' || st == 'est_area'){
			window.open("/agent/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650, status=yes, scrollbars=yes");
		}
	}	
	
	//������ȸ
	function User_search(nm, idx)
	{
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/agent/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	
	//������Ʈ������ȸ
	function Agent_User_search(nm)
	{
		var fm = document.form1;
		if(fm.bus_st.value != '7')	{ alert('���������� ������Ʈ�� ���� �ʿ��մϴ�.'); 		return;}
		if(fm.bus_id.value == '')		{ alert('���ʿ����ڸ� �����Ͻʽÿ�.'); 		return;}
		var t_wd = fm.agent_emp_nm.value;
		window.open("about:blank",'Agent_User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');
		fm.action = "/fms2/lc_rent/search_agent_user.jsp?mode=EMP_Y&nm="+nm+"&t_wd="+t_wd+"&agent_user_id="+fm.bus_id.value;
		fm.target = "Agent_User_search";
		fm.submit();
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
	
	//���°賻�뺸��
	function update_suc_commi(){
		window.open("/fms2/lc_rent/lc_b_u_suc_commi.jsp<%=valus%>", "UPDATE_SUC_COMMI", "left=0, top=0, width=1280, height=520, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//���������
	function cng_input3(){
		var fm = document.form1;
		if(<%=base.getRent_dt()%> >= 20190610){
			if('<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true){ 
				if(fm.dir_pur_commi_yn.value == ''){
					if('<%=ej_bean.getJg_g_7()%>' == '3' || '<%=ej_bean.getJg_g_7()%>' == '4'){
						fm.dir_pur_commi_yn.value = 'N';
					}else{
						fm.dir_pur_commi_yn.value = 'Y';
					}					
					//��Ÿ(��ü)
					if(fm.dir_pur_yn[0].checked == false){
						fm.dir_pur_commi_yn.value = '2';
					}
				}
			}else{														
				fm.dir_pur_commi_yn.value = '';
			}
		}			
	}
	
	//������ ���� �� ��������ǥ�� ��
	function span_dc_view(){
		var fm = document.form1;
		if(fm.dc_view_yn.checked==true){	$("#span_dc_view").css("display","");				}
		else{												$("#span_dc_view").css("display","none");		}
	}
	 	
	
	//���ڹ��� �����ϱ�2 ��Ÿ����Ʈ
	function go_edoc2(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;
		fm.link_im_seq.value 	= link_im_seq;
		window.open('about:blank', "EDOC_LINK2", "left=0, top=0, width=900, height=800, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK2";
		fm.action = "/fms2/lc_rent/reg_edoc_link2.jsp";
		fm.submit();
	}	
	
	//��������� �˻�
	function EstiTaeSearch(){
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=1100, height=800, resizable=yes, scrollbars=yes, status=yes");
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/tae_esti_history_cont.jsp';
		fm.submit();		
	}	
	
	//����
	function update_item(st, rent_st){
		var cmd = "�Աݼ����� ����";
		if(st == 'grt_amt' || st == 'pp_amt' || st == 'ifee_amt'){
			if(st == 'pp_amt'){
				<%if(max_fee.getPp_chk().equals("0")){%>cmd = "�ſ��յ���� �Աݼ����� ����"<%}%>		
			}
			window.open("/agent/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st+"&cmd="+cmd, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}
	}	
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
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
  <input type='hidden' name="mode"			value="lc_rent">    
  <input type='hidden' name="rent_dt"			value="">    
  <input type='hidden' name="rent_st"			value="">      
  <input type='hidden' name="a_b"			value="">     
  <input type='hidden' name="fee_opt_amt"		value="">
  <input type='hidden' name="cust_sh_car_amt"		value="">   
  <input type='hidden' name="sh_amt"			value="">     
  <input type='hidden' name="cls_n_mon"			value="">     
  <input type='hidden' name="today_dist"		value="">         
</form>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>  
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>        
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="opt"			value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"			value="<%=AddUtil.replace(cm_bean.getCar_b()," ","")%><%=AddUtil.replace(cm_bean2.getCar_b()," ","")%>">
  <input type='hidden' name="s_st" 			value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="dpm" 			value="<%=cm_bean.getDpm()%>">
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
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="fin_seq" 			value="<%=c_fin.getF_seq()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">      
  <input type='hidden' name="gur_size"			value="<%=gur_size%>">     
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">     
  <input type='hidden' name="o_1"			value="">
  <input type='hidden' name="ro_13"			value="">  
  <input type='hidden' name="o_13"			value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
  <input type='hidden' name="idx"			value="">  
  <input type='hidden' name="scan_cnt"			value="">    
  <input type='hidden' name="chk_cnt"			value="">
  <input type='hidden' name="car_id"			value="<%=cm_bean.getCar_id()%>">  
  <input type='hidden' name="car_id2"			value="<%=cm_bean2.getCar_id()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">    
  <input type='hidden' name="est_from"			value="lc_b_u">
  <input type='hidden' name="fee_opt_amt"		value="">  
  <input type='hidden' name="rent_mng_id2"		value="">    
  <input type='hidden' name="rent_l_cd2"		value="">      
  <input type='hidden' name="fee_rent_st"		value="<%=rent_st%>">        
  <input type='hidden' name="fee_rent_dt"		value="">          
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">            
  <input type='hidden' name="ins_chk4"			value="">            
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">            
  <input type='hidden' name="v_o_1"			value="">
  <input type='hidden' name="v_o_2"			value="">
  <input type='hidden' name="v_o_3"			value="">
  <input type='hidden' name="car_cng_yn"		value="<%=cont_etc.getCar_cng_yn()%>">
  <input type='hidden' name="link_table"		value="">  
  <input type='hidden' name="link_type"			value="">  
  <input type='hidden' name="link_rent_st"		value="">  
  <input type='hidden' name="link_im_seq"		value="">  
  <input type='hidden' name="msg_st"		value="">
  <input type='hidden' name='from_page2'	 	value='/agent/lc_rent/lc_b_u.jsp'>
  <input type='hidden' name="prev_new_license_plate"		value="">
  
  <input type="hidden" name="lkas_yn_org" id="lkas_yn_org" value="<%=cont_etc.getLkas_yn()%>"><!-- ������Ż ������ ���� ���� �� -->
  <input type="hidden" name="ldws_yn_org" id="ldws_yn_org" value="<%=cont_etc.getLdws_yn()%>"><!-- ������Ż ����� ���� ���� �� -->
  <input type="hidden" name="aeb_yn_org" id="aeb_yn_org" value="<%=cont_etc.getAeb_yn()%>"><!-- ������� ������ ���� ���� �� -->
  <input type="hidden" name="fcw_yn_org" id="fcw_yn_org" value="<%=cont_etc.getFcw_yn()%>"><!-- ������� ����� ���� ���� �� -->
  <input type="hidden" name="hook_yn_org" id="hook_yn_org" value="<%=cont_etc.getHook_yn()%>"><!-- ���ΰ� ���� ���� �� -->
  <input type="hidden" name="legal_yn_org" id="legal_yn_org" value="<%=cont_etc.getLegal_yn()%>"><!-- �������������(�����) ���� ���� �� -->  
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > ������ > <span class=style5>�̰���</span></span></td>
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
	<tr>
	    <td>(����� : <%=AddUtil.ChangeDate2(base.getReg_dt())%>)</td>
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
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td>&nbsp;					 
					  <%if(base.getCar_mng_id().equals("") && user_id.equals(base.getBus_id())){%>
        			  	  <input type="text" name="rent_dt" value="<%=AddUtil.ChangeDate2(base.getRent_dt())%>" size="11" maxlength='11' class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(base.getRent_dt())%>
					  <input type='hidden' name='rent_dt' 	value='<%=base.getRent_dt()%>'>				
					  <%}%>
		    </td>
                    <td class=title>��౸��</td>
                    <td>&nbsp;
                      <%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>
        			  	<select name="rent_st">
                      		<option value=''>����</option>
                      		<option value='1' <%if(base.getRent_st().equals("1")){%>selected<%}%>>�ű�</option>
                      		<option value='3' <%if(base.getRent_st().equals("3")){%>selected<%}%>>����</option>
                      		<option value='4' <%if(base.getRent_st().equals("4")){%>selected<%}%>>����</option>
                      	</select>
                      <%}else{ %>
                      	<%if(base.getRent_st().equals("1")){%>�ű�<%}%>
                      	<%if(base.getRent_st().equals("3")){%>����<%}%>
                      	<%if(base.getRent_st().equals("4")){%>����<%}%>                      
                      	<input type='hidden' name='rent_st' 	value='<%=base.getRent_st()%>'>
                      <%} %>
                    </td>
                    <td class=title>��������</td>
                    <td>&nbsp;
					  ������Ʈ
					  <input type='hidden' name='bus_st' 	value='<%=base.getBus_st()%>'>				
                    </td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("2")){%>����<%}%>
                    <input type='hidden' name="car_st"		value="<%=base.getCar_st()%>">      
                    </td>
                    <td class=title>��������</td>
                    <td>&nbsp;
                      <%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>
        			  	<select name="rent_way">
                        	<option value=''>����</option>
                        	<option value='1' <%if(max_fee.getRent_way().equals("1")){%>selected<%}%>>�Ϲݽ�</option>                        	
                        	<option value='3' <%if(max_fee.getRent_way().equals("3")){%>selected<%}%>>�⺻��</option>
                      	</select>
                      <%}else{ %>
                      	<%if(max_fee.getRent_way().equals("1")){%>�Ϲݽ�<%}%>                      	
                      	<%if(max_fee.getRent_way().equals("3")){%>�⺻��<%}%>                      
                      	<input type='hidden' name='rent_way' 	value='<%=max_fee.getRent_way()%>'>
                      <%} %>
                      </td>
                </tr>
                <tr> 
                    <td class=title>���ʿ�����</td>
                    <td>&nbsp;
                        <%=c_db.getNameById(base.getBus_id(),"USER")%>
			<input type='hidden' name='bus_id' 		value='<%=base.getBus_id()%>'>
                    </td>
                    <td class=title>�����븮��</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getBus_agnt_id(), "USER")%>" size="12"> 
			<input type="hidden" name="bus_agnt_id" value="<%=cont_etc.getBus_agnt_id()%>">
			<a href="javascript:User_search('bus_agnt_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
		    </td>
                    <td class=title>�����̿�����</td>
                    <td>&nbsp;
                    	<%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
                        <input type='hidden' name="est_area" value="<%=cont_etc.getEst_area()%>">
                        <input type='hidden' name='county' value='<%=cont_etc.getCounty()%>'>
			<%if(base.getUse_yn().equals("")){%>
			<a href="javascript:item_cng_update('est_area')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
			<%}%>
					</td>
                </tr>
                <tr>
				<td class=title>�����������</td>
                    <td colspan='5'>&nbsp;
                        <input name="agent_emp_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(base.getAgent_emp_id(), "CAR_OFF_EMP")%>" size="12"> 
			<input type="hidden" name="agent_emp_id" value="<%=base.getAgent_emp_id()%>">
			<a href="javascript:Agent_User_search('agent_emp_id');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>						
                    </td>                	

                </tr>					                
            </table>
	    </td>
    </tr>
  	<%if(!san_st.equals("��û")){%>
	<tr>
	    <td align="right"><a href="javascript:update('0')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>					

    <!--���°�-->
    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>    
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���°�</span>
        &nbsp;<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_suc_commi()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
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
	
	<tr>
	    <td class=h></td>
	</tr>
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
                    <td width='50%' align='left'>&nbsp;
                      <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='50' class='text' readonly>                      
                      <%if(client.getClient_id().equals("000228")){%>
        	        <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>        	      
        	      <%}%>
        	      <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>					  
        	    </td>
                    <td width='10%' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="client_nm" value='<%=client.getClient_nm()%>' size='22' class='whitetext' readonly></td>
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
                    <td height="26" class='left'>&nbsp; 
        			  <input type='text' name="site_nm" value='<%=site.getR_site()%>' size='50' class='text' readonly>
        			  <input type='hidden' name='site_id' value='<%=base.getR_site()%>'>
        			  <span class="b"><a href='javascript:search_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
        			</td>
                    <td width='10%' class='title'>���������</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="open_year" value='<%=client.getOpen_year()%>' size='22' class='whitetext' readonly></td>					
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>
                <tr>
                    <td class='title'>�����ּ�</td>
                    <td align='left'>&nbsp;
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=base.getP_zip()%>">
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="65" value="<%=base.getP_addr()%>">
                    </td>
                    <td class='title'>����������</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='<%=base.getTax_agnt()%>' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
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
                <%	CarMgrBean mgr1 = new CarMgrBean();
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
                <%//if(!client.getClient_st().equals("1")){ %> 
                <tr>
                    <td class='title'>����� ���������ȣ</td>
		            <td colspan='3'>&nbsp;<input type='text' name='lic_no' value='<%=base.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
						<input type="hidden" name="ssn" value="<%=client.getSsn1()%><%=client.getSsn2()%>">
					</td>
		            <td>&nbsp;(����,���λ����)&nbsp;�� �����(<%=client.getClient_nm()%>)�� ���������ȣ�� ����</td>
                </tr>
                <tr>
                    <td class='title' width='13%'>�����̿��� ���������ȣ</td>
		            <td width='15%'>&nbsp;<input type='text' name='mgr_lic_no' value='<%=base.getMgr_lic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='20%'>&nbsp;�̸� : <input type='text' name='mgr_lic_emp' value='<%=base.getMgr_lic_emp()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='12%'>&nbsp;���� : <input type='text' name='mgr_lic_rel' value='<%=base.getMgr_lic_rel()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='40%'>&nbsp;(����,���λ����)<%if(client.getClient_st().equals("3")||client.getClient_st().equals("4")||client.getClient_st().equals("5")){%>&nbsp;�� ����ڰ� �������㰡 ���� ��� �����̿����� �������㸦 �Է�<%}%></td>
                </tr>  
	            <%//} %>  
	                
                <tr>
                    <td class='title' width='13%'>�߰������� ���������ȣ</td>
		            <td width='15%'>&nbsp;<input type='text' name='mgr_lic_no5' value='<%=mgr5.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='20%'>&nbsp;�̸� : <input type='text' name='mgr_lic_emp5' value='<%=mgr5.getMgr_nm()%>'  size='10' class='text'></td>
		            <td width='13%'>&nbsp;���� : <input type='text' name='mgr_lic_rel5' value='<%=mgr5.getEtc()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='40%'>&nbsp;������� : <select name='mgr_lic_result5'>
        		          		<option value='' <%if(mgr5.getLic_result().equals("")) out.println("selected");%>>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(mgr5.getLic_result().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        		<%}%> 
        		            </select>&nbsp;�� ��༭�� "�����ڹ���" ���� �����ڸ� �߰������ڷ� ����ϴ� ��쿡�� �߰������� ���������� ����</td>
                </tr>                
    	                 
            
                <!-- �����ڰݰ������ -->
                   
                <tr>
                    <td class='title' rowspan='2'>�������� �����ڰݰ���</td>
		            <td>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td>&nbsp;���������(�̸�) : <input type='text' name='test_lic_emp' value='<%=base.getTest_lic_emp()%>'  size='8' class='text'></td>
		            <td>&nbsp;���� : <input type='text' name='test_lic_rel' value='<%=base.getTest_lic_rel()%>'  size='10' class='text'></td>
		            <td>&nbsp;������� : <select name='test_lic_result'>
        		          		<option value='' <%if(base.getTest_lic_result().equals("")) out.println("selected");%>>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(base.getTest_lic_result().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
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
                    <td align='center'><input type='text' name='mgr_title' size='10' value='<%=mgr.getMgr_title()%>' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
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
						<option value="daum.net">daum.net</option>
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
						<option value="daum.net">daum.net</option>
						<option value="">���� �Է�</option>
						</select>
					<input type='hidden' name="mgr_email" value="">
					</td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=mgr_size%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>	
				<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip1').value = data.zonecode;
								document.getElementById('t_addr1').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>				
                <tr> 
                    <td colspan="2" class=title>�����̿��� �ǰ����� �ּ�</td>
                    <td colspan="8">&nbsp;
					<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=mgr_zip%>">
					<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr1" size="61" value="<%=mgr_addr%>">
                </tr>
            </table>
        </td>
    </tr>	
    <%if(!san_st.equals("��û")){%>
    <tr>
	    <td align="right"><a href="javascript:update('1')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>
    <%}%>
<%--     <%if(client.getClient_st().equals("1")){%>	      --%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
<%--     <%}%>     --%>
    <%-- <tr id=tr_client_share_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  --%>
    <tr id='tr_client_share_st'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>������������</td> 
                    <td colspan="4" align='left'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' <%if(cont_etc.getClient_share_st().equals("1"))%>checked<%%> onClick="javascript:cng_input4()">
        				�ִ�
        	      <input type='radio' name="client_share_st" value='2' <%if(!cont_etc.getClient_share_st().equals("1"))%>checked<%%> onClick="javascript:cng_input4()">
        				����</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr id=tr_client_share_st_test style="display:<%if(client.getClient_st().equals("2") && cont_etc.getClient_share_st().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                
                <!-- �����ڰݰ������ -->
                <tr>
                    <td width='13%' class='title' rowspan='2'>�������� �����ڰݰ���</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;���������(�̸�) : <input type='text' name='test_lic_emp2' value='<%=base.getTest_lic_emp2()%>'  size='8' class='text'></td>
		            <td width='12%'>&nbsp;���� : <input type='text' name='test_lic_rel2' value='<%=base.getTest_lic_rel2()%>'  size='10' class='text'></td>
		            <td width='40%'>&nbsp;������� : <select name='test_lic_result2'>
        		          		<option value='' <%if(base.getTest_lic_result2().equals("")) out.println("selected");%>>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(base.getTest_lic_result2().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;(����)&nbsp;�� ���ΰ��� ������������ �ִ� ��� �����ڰ��� ����</td>
                </tr>  
            </table>  
        </td>
    </tr>            
    <%if(client.getClient_st().equals("1")){%>	 
       
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ���뺸��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <%}%>
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
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getGuar_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="guar_sac_id" value="<%=cont_etc.getGuar_sac_id()%>">			
			<a href="javascript:User_search('guar_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
		    </td>
                </tr>
            </table>  
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
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
                                <td align="center"><input type="text" name="t_zip"  size="7"   class='text' value='<%=gur.get("GUR_ZIP")%>'>&nbsp;<input type='text' name="t_addr" size='25' class='text' value='<%=gur.get("GUR_ADDR")%>'></td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value='<%=gur.get("GUR_TEL")%>'></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value='<%=gur.get("GUR_REL")%>'></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                      <%}%>
                      <%for(int i=gur_size; i<3; i++){%>
                            <tr>
                                <td class=title>���뺸����<input type='hidden' name='gur_id' value='<%=i+1%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" class='text' value=''></td>
                                <td align="center"><input type="text" name="t_zip"  size="7"   class='text' value=''>&nbsp;<input type='text' name="t_addr" size='25' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value=''></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                      <%}%>
                        </table>
        			</td>			
                </tr>
            </table>  
        </td>
    </tr>
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('2')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	</tr>	
	<%}%>
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
                    <td width=20%>&nbsp;<input type='text' size='30' name='job' value='<%=client.getJob()%>' maxlength='20' class='text'></td>
                    <td class=title width=10%>�ҵ汸��</td>
                    <td colspan="3">&nbsp;
        			  <select name='c_pay_st'>
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
		                <input type='text' name='c_kisu' size='10' value='<%=c_fin.getC_kisu()%>' maxlength='20' class='text' >
		            ��)</td>
		            <td width="43%" class=title>����(
		                <input type='text' name='f_kisu' size='10' value='<%=c_fin.getF_kisu()%>' maxlength='20' class='text' >
		            ��)</td>
		        </tr>
		        <tr>
		            <td class=title>&nbsp;&nbsp;
					(
		            	<input type='text' name='c_ba_year_s' size='11' class='text' maxlength='11' value='<%=c_fin.getC_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='c_ba_year' size='10' class='text' maxlength='10' value='<%=c_fin.getC_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		     
		            <td class='title'>&nbsp;&nbsp;
					(
		            	<input type='text' name='f_ba_year_s' size='11' class='text' maxlength='11' value='<%=c_fin.getF_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='f_ba_year' size='10' class='text' maxlength='10' value='<%=c_fin.getF_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		              
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
	<%}%>    
	<%if(!san_st.equals("��û")){%>
	<tr>
	    <td align="right"><a href="javascript:update('3')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>		
	<%}%>	
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
                    		<option value="">�Է�</option>
                    		<option value="">����</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval3.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
                          <option value="����" <%if(eval3.getEval_gr().equals("����")) out.println("selected");%>>����</option>
                          <option value="����" <%if(eval3.getEval_gr().equals("����")) out.println("selected");%>>����</option>
        				  <%if(eval3.getEval_off().equals("2")||eval3.getEval_off().equals("")){
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
        		  <%
        		  	
        		  		eval5 = a_db.getContEval(rent_mng_id, rent_l_cd, "5", "");
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
                    		<option value="">�Է�</option>
                    		<option value="">����</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval5.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">����</option>
                          <option value="����" <%if(eval5.getEval_gr().equals("����")) out.println("selected");%>>����</option>
                          <option value="����" <%if(eval5.getEval_gr().equals("����")) out.println("selected");%>>����</option>
        				  <%if(eval5.getEval_off().equals("2")||eval5.getEval_off().equals("")){
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
                          <option value="����" <%if(eval1.getEval_gr().equals("����")) out.println("selected");%>>����</option>
                          <option value="����" <%if(eval1.getEval_gr().equals("����")) out.println("selected");%>>����</option>
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
        				  <%if(eval1.getEval_off().equals("1")||eval1.getEval_off().equals("")){
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
                          <option value="����" <%if(eval2.getEval_gr().equals("����")) out.println("selected");%>>����</option>
                          <option value="����" <%if(eval2.getEval_gr().equals("����")) out.println("selected");%>>����</option>
        				  <%if(eval2.getEval_off().equals("2")||eval2.getEval_off().equals("")){
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
                          <option value="����" <%if(eval6.getEval_gr().equals("����")) out.println("selected");%>>����</option>
                          <option value="����" <%if(eval6.getEval_gr().equals("����")) out.println("selected");%>>����</option>
        				  <%if(eval6.getEval_off().equals("2")||eval6.getEval_off().equals("")){
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
                    <td class=title>����������<input type='hidden' name='eval_gu' value='7'><input type='hidden' name='e_seq' value='<%=eval7.getE_seq()%>'>
                    </td>
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
                          <option value="����" <%if(eval7.getEval_gr().equals("����")) out.println("selected");%>>����</option>
                          <option value="����" <%if(eval7.getEval_gr().equals("����")) out.println("selected");%>>����</option>
        				  <%if(eval7.getEval_off().equals("2")||eval7.getEval_off().equals("")){
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
                          <option value="����" <%if(eval8.getEval_gr().equals("����")) out.println("selected");%>>����</option>
                          <option value="����" <%if(eval8.getEval_gr().equals("����")) out.println("selected");%>>����</option>
        				  <%if(eval8.getEval_off().equals("2")||eval8.getEval_off().equals("")){
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
                          <option value="����" <%if(eval4.getEval_gr().equals("����")) out.println("selected");%>>����</option>
                          <option value="����" <%if(eval4.getEval_gr().equals("����")) out.println("selected");%>>����</option>
        				  <%if(eval4.getEval_off().equals("2")||eval4.getEval_off().equals("")){
        				    for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("3")){
        				    for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];
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
	  <input type='hidden' name="eval_cnt"			value="<%=eval_cnt%>">              
	<%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('4')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>			
	<%}%>	
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
						function openDaumPostcode2() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip2').value = data.zonecode;
									document.getElementById('t_addr2').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>			
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value="<%=eval3.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr2" size="25" value="<%=eval3.getAss1_addr()%>">
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
						function openDaumPostcode3() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip3').value = data.zonecode;
									document.getElementById('t_addr3').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip3" size="7" maxlength='7' value="<%=eval3.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr3" size="25" value="<%=eval3.getAss2_addr()%>">
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
						function openDaumPostcode4() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip4').value = data.zonecode;
									document.getElementById('t_addr4').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip4" size="7" maxlength='7' value="<%=eval1.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode4()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr4" size="25" value="<%=eval1.getAss1_addr()%>">
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
						function openDaumPostcode5() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip5').value = data.zonecode;
									document.getElementById('t_addr5').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip5" size="7" maxlength='7' value="<%=eval1.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode5()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr5" size="25" value="<%=eval1.getAss2_addr()%>">
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
						function openDaumPostcode6() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip6').value = data.zonecode;
									document.getElementById('t_addr6').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip6" size="7" maxlength='7' value="<%=eval2.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode6()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr6" size="25" value="<%=eval2.getAss1_addr()%>">
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
						function openDaumPostcode7() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip7').value = data.zonecode;
									document.getElementById('t_addr7').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip7" size="7" maxlength='7' value="<%=eval2.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode7()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr7" size="25" value="<%=eval2.getAss2_addr()%>">
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
						function openDaumPostcode8() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip8').value = data.zonecode;
									document.getElementById('t_addr8').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip8" size="7" maxlength='7' value="<%=eval7.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode8()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr8" size="25" value="<%=eval7.getAss1_addr()%>">
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
						function openDaumPostcode9() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip9').value = data.zonecode;
									document.getElementById('t_addr9').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip9" size="7" maxlength='7' value="<%=eval7.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode9()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr9" size="25" value="<%=eval7.getAss2_addr()%>">
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
						function openDaumPostcode10() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip10').value = data.zonecode;
									document.getElementById('t_addr10').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip10" size="7" maxlength='7' value="<%=eval4.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode10()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr10" size="25" value="<%=eval4.getAss1_addr()%>">
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
						function openDaumPostcode11() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip11').value = data.zonecode;
									document.getElementById('t_addr11').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip11" size="7" maxlength='7' value="<%=eval4.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode11()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr11" size="25" value="<%=eval4.getAss2_addr()%>">
					</td>
					<% zip_cnt++;%>
                </tr>
        		  <%	}
        		  	}%>		
            </table>
        </td>
    </tr>
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('5')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	    
	<%}%>	
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
                                <!-- 
                                <option value=''>����</option>
                                <option value='3' <%if(cont_etc.getDec_gr().equals("3")){%>selected<%}%>>�ż�����</option>
                                <option value='0' <%if(cont_etc.getDec_gr().equals("0")){%>selected<%}%>>�Ϲݰ�</option>
                                 -->
                                <option value='1' <%if(cont_etc.getDec_gr().equals("1")){%>selected<%}%>>�췮���</option>
                                <option value='2' <%if(cont_etc.getDec_gr().equals("2")){%>selected<%}%>>�ʿ췮���</option> 
                            </select>        	        
                    </td>                       
                    <td align="center">
                        <%=c_db.getNameById(cont_etc.getDec_f_id(), "USER")%>
			<input type="hidden" name="dec_f_id" value="<%=cont_etc.getDec_f_id()%>">						
                    </td>
                    <td align="center"><input type='text' name='dec_f_dt' size='11' maxlength='20' class='text' value="<%=AddUtil.ChangeDate2(cont_etc.getDec_f_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center">
                        <%=c_db.getNameById(cont_etc.getDec_l_id(), "USER")%>
			<input type="hidden" name="dec_l_id" value="<%=cont_etc.getDec_l_id()%>">			
               	    </td>
                    <td align="center"><input type='text' name='dec_l_dt' size='11' maxlength='20' class='whitetext' value='<%=AddUtil.ChangeDate2(cont_etc.getDec_l_dt())%>' ></td>
                </tr>
            </table>
        </td>
    </tr>
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('7')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	    
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
        		    <td width="20%">&nbsp;<%=cr_bean.getCar_no()%></td>
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
                    <td>&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[������]<%}%><%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class='title'>�Һз� </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
                    <td class='title' width="10%">�����ڵ�</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>��ⷮ</td>
                    <td>&nbsp;<%=cm_bean.getDpm()%>cc</td>
                </tr>
                <tr>
                    <td class='title'>GPS��ġ������ġ</td>
                    <td colspan="5">&nbsp;
        			  <%if(cr_bean.getGps().equals("Y")){%>����<%}else{%>������<%}%>
					  </td>
                </tr>								
                <tr>
                    <td class='title'>�ɼ�</td>
                    <td colspan="5">&nbsp;
        			  <%=car.getOpt()%><input type='hidden' name='opt_code' value='<%=car.getOpt_code()%>'></td>
                </tr>
            </table>
        </td>
    </tr>
  <%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�") && !san_st.equals("��û")){%>    
	<tr>
	    <td align="right"><a href="javascript:reset_car()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
	<tr></tr><tr></tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td class='title'>����</td>
                    <td colspan="5">&nbsp;                        
        			  <input type='text' name='color' size='45' maxlength='100' class='text' value='<%=car.getColo()%>'>
					  &nbsp;&nbsp;&nbsp;
					  (�������(��Ʈ): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'> )  
					  &nbsp;&nbsp;&nbsp;
					  (���Ͻ�: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'> )  
        			  </td>
                </tr>
                <%if(ej_bean.getJg_g_7().equals("3")){//������%>
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td colspan="5">&nbsp;
                        <select name="ecar_loc_st">
                    	  <option value=""  <%if(pur.getEcar_loc_st().equals(""))%>selected<%%>>����</option>
                    	  <%for(int i = 0 ; i < code34_size ; i++){
                            CodeBean code = code34[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getEcar_loc_st().equals(code.getNm_cd())){%>selected<%}%> <%if(Integer.parseInt(cm_bean.getJg_code()) > 8000000 && (code.getNm_cd().equals("12") || code.getNm_cd().equals("13"))){ %>style='display: none;'<%} %>><%= code.getNm()%></option>
                        <%}%>        
                      </select>                    	     			  
        			  </td>
                </tr>		
                <%}%>	  
                <%if(ej_bean.getJg_g_7().equals("4")){//������%>
                <tr>
                    <td class='title'>������ ���ּ���</td>
                    <td colspan="5">&nbsp;
                        <select name="hcar_loc_st">
                    	  <option value=""  <%if(pur.getHcar_loc_st().equals(""))%>selected<%%>>����</option>
                    	  <%for(int i = 0 ; i < code37_size ; i++){
                            CodeBean code = code37[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getHcar_loc_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>        
                      </select>
        			  </td>
                </tr>	
                <%}%>                                    
                <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����-��������%>
                <tr <%if ((ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) && !car.getEco_e_tag().equals("1")) {%>style="display: none;"<%}%>>
                    <%-- <td class='title'>�������ｺƼĿ �߱�<br>(�����ͳ� �̿� �����±�)</td>
                    <td colspan="5">&nbsp;
                        <select name="eco_e_tag" id="eco_e_tag">
                    	  <option value=""  <%if(car.getEco_e_tag().equals(""))%>selected<%%>>����</option>
                        <option value="0" <%if(car.getEco_e_tag().equals("0"))%>selected<%%>>�̹߱�</option>
                        <option value="1" <%if(car.getEco_e_tag().equals("1"))%>selected<%%>>�߱�</option>
                      </select>
                      &nbsp;�� ģȯ���� �� �� �����ͳ� ���̿��ڸ� �߱� ����, ���̺긮��/�÷����� ���̺긮�� ������ ��� ���������� �뿩�ᰡ ���� ��µ�.
        			      </td> --%>
	                <input type="hidden" name="eco_e_tag" id="eco_e_tag" value="<%=car.getEco_e_tag()%>">	                     
                </tr>		
                <%}%> 
                <tr>
                    <td class='title'>�����μ���</td>
                    <td colspan="5">&nbsp;
                        <select name="udt_st">
                        <option value=''>����</option>
                        <%for(int i = 0 ; i < code35_size ; i++){
                            CodeBean code = code35[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getUdt_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
        			  &nbsp; �μ��� Ź�۷� :
        			  <input type='text' name='cons_amt1' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(pur.getCons_amt1())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  �� (���μ��� ���� ���� �Է��ϼ���.)
        			  </td>
                </tr>			  
                <tr>
                    <td width='13%' class='title'>�������</td>
                    <td colspan="5">&nbsp;
                      <select name="car_ext" id="car_ext">
                      	<option value=''>����</option>
                		<%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(car.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�") && !san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('8_1')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td width='13%' class='title'>����</td>
                    <td <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %> width='10%' <% } else { %> colspan="3" <% } %>>&nbsp;
                      <input type='text' name="sun_per" value='<%=car.getSun_per()%>' size="4" maxlength="4" class='text'> %
                      	<%if (car.getHipass_yn().equals("")) { // 20181012 �����н����� (������ ������ ���� select���� input���� ���� ó��)%>
							<input type="hidden" name="hipass_yn" value="">
						<%} else {%>
							<input type="hidden" name="hipass_yn" value="<%=car.getHipass_yn()%>">
						<%}%>
						
						<%if (!(base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001"))) {%>
							<%if (car.getBluelink_yn().equals("")) {%>
								<input type="hidden" name="bluelink_yn" value="">
							<%} else {%>
								<input type="hidden" name="bluelink_yn" value="<%=car.getBluelink_yn()%>">
							<%}%>
						<%}%>
                    </td>
                    <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>
	                    <td width='10%' class='title'>��縵ũ����</td>
	                    <td>&nbsp;
	                        <select name="bluelink_yn">
	                            <option value='' <%if(car.getBluelink_yn().equals(""))%>selected<%%>>����</option>
	                            <option value='Y' <%if(car.getBluelink_yn().equals("Y"))%>selected<%%>>����</option>
	                            <option value='N' <%if(car.getBluelink_yn().equals("N"))%>selected<%%>>����</option>
	                        </select>
	                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;�� �������ý� ��縵ũ ���� �ȳ��� �˸���߼�(�����ٻ�����)</span>
	                    </td>
                    <% } %>
                </tr>
                <tr>
                    <td class='title'><span class="title1">������߰�����</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='add_opt' size='45' class="text" value='<%=car.getAdd_opt()%>'>
        				&nbsp;<input type='text' name='add_opt_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  ��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����ݿ���,LPGŰƮ����,�׺���̼ǵ�)</font></span>
                    </td>
                </tr>

                <tr>
                    <td class='title'><span class="title1">�����ݿ���ǰ</span></td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2ä�� ���ڽ�
                      &nbsp;
                      <input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> ���� ����(�⺻��),
                      &nbsp;
                      ���ñ��������� :
                      <input type='text' name="tint_s_per" value='<%=car.getTint_s_per()%>' size="4" maxlength="4" class='text'>
        	      % 
      		      &nbsp;
      		      	<input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> ��޽���(��������)
      		      	&nbsp; ���� <input type="text" name="tint_ps_nm" value="<%=car.getTint_ps_nm()%>" size='10' style="text-align:right;">
					&nbsp; ��ǰ�� ���ޱݾ� <input type="text" name="tint_ps_amt" value="<%=AddUtil.parseDecimal(car.getTint_ps_amt())%>" size='10' style="text-align:right;"> �� (�ΰ�������)
      		      <br>
      		      &nbsp;
                  <input type="checkbox" name="tint_sn_yn" value="Y" <%if(car.getTint_sn_yn().equals("Y")){%>checked<%}%>> ������� �̽ð� ����
      		      &nbsp;
                  <input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> ���ڽ� ������ ���� 
                  &nbsp; ���λ��� : 
                  <select name="tint_bn_nm">
                  		<option value=""  <%if (car.getTint_bn_nm().equals("")){%>selected<%}%>>����</option>
                  		<option value="2" <%if (car.getTint_bn_nm().equals("2")){%>selected<%}%>>������</option>
                   		<option value="1" <%if (car.getTint_bn_nm().equals("1")){%>selected<%}%>>��Ʈ��ķ</option>                   		
                   	</select>
				  &nbsp;
				  <input type="checkbox" name="tint_cons_yn" value="Y" <%if(car.getTint_cons_yn().equals("Y")){%>checked<%}%>> �߰�Ź�۷��
					&nbsp; �ݾ� <input type="text" name="tint_cons_amt" value="<%=AddUtil.parseDecimal(car.getTint_cons_amt())%>" size='10'> ��
      		      <%if(car.getTint_n_yn().equals("Y")){%>
      		      &nbsp;
                      <input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> ��ġ�� ������̼�
      		      <%}%>
                      <%if(ej_bean.getJg_g_7().equals("3")){//������%>
      		      &nbsp;
                      <input type="checkbox" name="tint_eb_yn" value="Y" <%if(car.getTint_eb_yn().equals("Y")){%>checked<%}%>> �̵��� ������(������)
                      <%}%>
                  &nbsp;
                  <%if( !( (Integer.parseInt(ej_bean.getSh_code()) > 9018110 && Integer.parseInt(ej_bean.getSh_code()) < 9018999) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")
                		  || cm_bean.getCar_comp_id().equals("0044") || cm_bean.getCar_comp_id().equals("0007") || cm_bean.getCar_comp_id().equals("0025") || cm_bean.getCar_comp_id().equals("0033") || cm_bean.getCar_comp_id().equals("0048")) ){ %>
                      ��ȣ�Ǳ���
                      <!-- ������ȣ�ǽ�û -->
                   	<select name="new_license_plate">
                   		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>����</option>
                   		<option value="0" <%if (!(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2"))) {%>selected<%}%>>����</option>
                   		<%-- <option value="" <%if (car.getNew_license_plate().equals("")) {%>selected<%}%>>��û����</option>
                   		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>��û</option> --%>
<%--                    		<option value="1" <%if (car.getNew_license_plate().equals("1")) {%>selected<%}%>>������</option> --%>
<%--                    		<option value="2" <%if (car.getNew_license_plate().equals("2")) {%>selected<%}%>>����/�뱸/����/�λ�</option> --%>
                   	</select>
                   	<%} %>
                    </td>
                </tr>                

                <tr>
                    <td class='title'><span class="title1">����ǰ��</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='extra_set' size='45' class="text" value='<%=car.getExtra_set()%>'>
        				&nbsp;<input type='text' name='extra_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getExtra_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  ��&nbsp;<span style="font-size : 8pt;"><font color="#666666">(�ΰ������Աݾ�,�����̹ݿ���)</font></span><br>
        					  &nbsp;<input type="checkbox" name="serv_b_yn" value="Y" <%if(car.getServ_b_yn().equals("Y")){%>checked<%}%>> ���ڽ� (2015��8��1�Ϻ���)
        					  <%if(ej_bean.getJg_g_7().equals("3")){%>
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
  <%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�") && !san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('8')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_car1 style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>��������</td>
                    <td colspan="3">&nbsp;
                      <select name="purc_gu">
                        <option value=''>����</option>
                        <option value='1' <%if(car.getPurc_gu().equals("1")){%> selected <%}%>>����</option>
                        <option value='0' <%if(car.getPurc_gu().equals("0")){%> selected <%}%>>�鼼</option>
                      </select></td>
                    <td class='title'>��ó</td>
                    <td colspan="3">&nbsp;
        			  <%String car_origin = car.getCar_origin();%>
        			  <%if(car_origin.equals("")){
        			  		if(!cm_bean.getCar_comp_id().equals("")){
        						code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
        					}
        					car_origin = code_bean.getApp_st();
        				}%>
        			<select name="car_origin">
                        <option value="">����</option>
                        <option value="1" <%if(car_origin.equals("1")){%> selected <%}%>>����</option>
                        <option value="2" <%if(car_origin.equals("2")){%> selected <%}%>>����</option>
                      </select></td>
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
                    <td width="12%" class='title'>�ΰ���</td>
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_f_amt()" onMouseOver="window.status=''; return true" title="���԰� �հ� ����ϱ�">�հ�</a></span>&nbsp;<span class="b"><a href="javascript:sum_car_f_amt2()" onMouseOver="window.status=''; return true" title="���԰� ����ϱ�">���</a></span></td>
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
              <tr id=tr_ecar_dc <%if(base.getDlv_dt().equals("") || car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'> ���Ҽ� �����</td>
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
              </tr>                       <tr>
                    <td align="center" class='title_p'>�հ�</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    ��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                    <td align='center' class='title_p'>�հ�</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
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
                    <td class='title'><a href="javascript:sum_tax_amt()" onMouseOver="window.status=''; return true" title="���԰� �հ� ����ϱ�">Ư�Ҽ�</a></td>
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
    	
    <%if(ej_bean.getJg_w().equals("1")){//������%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ ������ ����</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>ī������ݾ�</td>
                    <td width="27%">&nbsp;
                        <input type='text' name='import_card_amt' value='<%= AddUtil.parseDecimal(car.getImport_card_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    </td>
                    <td width="10%" class='title'>Cash Back�ݾ�</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_cash_back' value='<%= AddUtil.parseDecimal(car.getImport_cash_back())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
        	    </td>	
        	    <td width="10%" class='title'>Ź�۽��ú���</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_bank_amt' value='<%= AddUtil.parseDecimal(car.getImport_bank_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
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
                        <input type='hidden' name="h_ecar_pur_sub_amt"	value="<%=car.getEcar_pur_sub_amt()%>">
                        <input type='hidden' name="h_ecar_pur_sub_st"		value="<%=car.getEcar_pur_sub_st()%>">
        	          </td>	                    
                </tr>
            </table>
	    </td>
    </tr>   
    <%}%>              
  <%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�") && !san_st.equals("��û")){%>		  
	<tr>
	    <td align="right"><a href="javascript:update('9')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
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
                        <select name='conr_nm' disabled>
                          <option value="1" <%if(ins.getConr_nm().equals("�Ƹ���ī")){%> selected <%}%>>�Ƹ���ī</option>
                          <option value="2" <%if(!ins.getConr_nm().equals("�Ƹ���ī")){%> selected <%}%>>��</option>
                        </select></td>				
                    <td width="10%" class=title >�Ǻ�����</td>
                    <td colspan='3'>&nbsp;
                        <select name='con_f_nm' disabled>
                          <option value="1" <%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%> selected <%}%>>�Ƹ���ī</option>
                          <option value="2" <%if(!ins.getCon_f_nm().equals("�Ƹ���ī")){%> selected <%}%>>��</option>
                        </select></td>		
                </tr>            
                <tr>
                    <td width="13%" class=title >�����ڿ���</td>
                    <td width="20%">&nbsp;
                    <select name='age_scp' disabled>
                            <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>��21���̻� 
                            </option>
                            <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>��24���̻� 
                            </option>
                            <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>��26���̻� 
                            </option>
                            <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>������ 
                            </option>
							<option value=''>=�Ǻ����ڰ�=</option>				
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>��30���̻�</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>��35���̻�</option>				
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>��43���̻�</option>						
						<option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>��48���̻�</option>
						<option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>��22���̻�</option>
						<option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>��28���̻�</option>
						<option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>��35���̻�~��49���̻�</option>
                          </select></td>
                    <td width="10%" class=title >�빰���</td>
                    <td width="20%">&nbsp;
                    <select name='vins_gcp_kd' disabled>
                            <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5���</option>
							<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2���</option>
                            <option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1���</option>							
                            <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000����&nbsp;&nbsp;&nbsp;</option>
                            <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000����</option>
                            <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500����</option>
                            <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000����</option>				
                          </select></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td >&nbsp;
                    <select name='vins_bacdt_kd' disabled>
                            <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3���</option>							
                            <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1��5õ����</option>
                            <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1���</option>
                            <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000����</option>
                            <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000����</option>
                            <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500����</option>
                          </select></td>
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
                          <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>��26���̻�</option>
                          <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>��24���̻�</option>
                          <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>��21���̻�</option>
                          <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>��������</option>
					  <option value=''>=�Ǻ����ڰ�=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>��30���̻�</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>��35���̻�</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>��43���̻�</option>						
					  <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>��48���̻�</option>					  						  
					  <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>��22���̻�</option>					  						  
					  <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>��28���̻�</option>					  						  
					  <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>��35���̻�~��49������</option>					  						  
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a></td>
                <td class=title >��������������Ư��</td>
                <td class=''>&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">����</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                  </select>
                  <%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
                      <%if(cont_etc.getCom_emp_sac_id().equals("")){%>
                      <a href="javascript:Com_emp_sac();"><img src=/acar/images/center/button_in_si.gif border=0 align=absmiddle></a>
                      <%}else{%>
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
                        <select name='gcp_kd'>
                          <option value="">����</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5õ����</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1���</option>
						  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2���</option>
						  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3���</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5���</option>						  
                      </select></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td class=''>&nbsp;
                        <select name='bacdt_kd'>
                          <option value="">����</option>
                          <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1���</option>
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
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getRea_appr_id(), "USER")%>" size="12"> 
			<input type="hidden" name="rea_appr_id" value="<%=cont_etc.getRea_appr_id()%>">			
			<a href="javascript:User_search('rea_appr_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
                        (�⺻ <input type='text' size='6' maxlength='10' name='imm_amt' class='whitenum' value='<%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%>' readonly>��) </td>
                </tr>
                <tr>
                    <td  class=title>�ڵ���</td>
                    <td colspan="5">&nbsp;
                      <select name="air_ds_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getAir_ds_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>
        				�����������
        			  <select name="air_as_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getAir_as_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        				�����������
        				 <select name="blackbox_yn">
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getBlackbox_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        				���ڽ�
        				<br/>
        				&nbsp; 	
                      <select name="lkas_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getLkas_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getLkas_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
       				����(����)	
        			&nbsp; 			
                      <select name="ldws_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getLdws_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getLdws_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			����(���)	
        			&nbsp; 			
                      <select name="aeb_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getAeb_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getAeb_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			���(����)	
        			&nbsp; 			
                      <select name="fcw_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getFcw_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getFcw_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			���(���)	
        			&nbsp; 			
                      <select name="ev_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getEv_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getEv_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			�����ڵ���	
        			 &nbsp; 	
					 <select name="hook_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getHook_yn().equals("Y")){%> selected <%}%>>��</option>
                        <option value="N" <%if(cont_etc.getHook_yn().equals("N")){%> selected <%}%>>��</option>
                      </select>	
        			���ΰ�(Ʈ���Ϸ���)	
      				&nbsp; 	
        			<select name="legal_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">����</option>
                        <option value="Y" <%if(cont_etc.getLegal_yn().equals("Y")){%> selected <%}%>>����</option>
                        <option value="N" <%if(cont_etc.getLegal_yn().equals("N")){%> selected <%}%>>�̰���</option>
                      </select>	
       				�������������(�����)
        			 &nbsp;
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
            </table>
        </td>
    </tr>	
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('10')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	    
	<%}%>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr id=tr_gi style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>

	<%	
		for(int f=1; f<=gin_size ; f++){
			ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));			
			
			if(f<gin_size ){%>  
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1' onClick="javascript:display_gi()" <%if(ext_gin.getGi_st().equals("1")){%> checked <%}%>>
                  		����
                  		<input type='radio' name="gi_st" value='0' onClick="javascript:display_gi()" <%if(ext_gin.getGi_st().equals("0")){%> checked <%}%>>
                  		���� </td>
                </tr>			        
                <tr id=tr_gi<%=f+1%> style='display:<%if(ext_gin.getGi_st().equals("1")){%>""<%}else{%>none<%}%>'>
                    <td class=title>��������</td>
                    <td width="20%">&nbsp;<input type='hidden' name='ext_gi_no' value='<%=ext_gin.getGi_no()%>'>
                    <input type='hidden' name='ext_gi_rent_st' value='<%=ext_gin.getRent_st()%>'>
        			   <input type='text' name='ext_gi_jijum' value='<%=ext_gin.getGi_jijum()%>' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>���Աݾ�</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='ext_gi_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                    <td class=title >���������</td>
                    <td>&nbsp;
                        <input type='text' name='ext_gi_fee' size='9' maxlength='20' class='whitenum' readonly value='<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                </tr>
	<%		}else{//������ȸ��%>	 
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1' onClick="javascript:display_gi()" <%if(ext_gin.getGi_st().equals("1")){%> checked <%}%>>
                  		����
                  		<input type='radio' name="gi_st" value='0' onClick="javascript:display_gi()" <%if(ext_gin.getGi_st().equals("0")){%> checked <%}%>>
                  		���� </td>
                </tr>			   	               
                <tr id=tr_gi<%=f+1%> style='display:<%if(ext_gin.getGi_st().equals("1")){%>""<%}else{%>none<%}%>'>
                    <td class=title>��������</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value='<%=ext_gin.getGi_no()%>'>
                    <input type='hidden' name='gi_rent_st' value='<%=ext_gin.getRent_st()%>'>
        			   <input type='text' name='gi_jijum' value='<%=ext_gin.getGi_jijum()%>' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>���Աݾ�</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'>
                  		��</td>
                    <td class=title >���������</td>
                    <td>&nbsp;
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                </tr>	
	<%		}%>
	<%	}%>                	
            </table>
        </td>
    </tr>    
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('11')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span></td>
    </tr>
	<%	for(int f=1; f<=fee_size; f++){
			ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
			
			ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));
			
			if(fee_size >1 && f==(fee_size-1)){
				fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt();
			}
			
			if(f<fee_size){%>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr>
                    <td width="13%" align="center" class=title>�������</td>
                    <td width="20%">&nbsp;<%if(f >1){%><%=AddUtil.ChangeDate2(fees.getRent_dt())%><%}else{%><%=AddUtil.ChangeDate2(base.getRent_dt())%><%}%></td>
                    <td width="10%" align="center" class=title>�������</td>
                    <td >&nbsp;<%if(f >1){%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}else{%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}%></td>
                    <td width="10%" align="center" class=title>�����븮��</td>
                    <td >&nbsp;<%if(f >1){%><%=c_db.getNameById(fee_etcs.getBus_agnt_id(),"USER")%><%}else{%><%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%><%}%></td>
                </tr>		
                <tr>
                    <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="ext_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitetext' onChange='javascript:set_cont_date(this)' readonly>
            			 ����</td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="ext_rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate4(this, this.value); set_cont_date(this);' readonly></td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td>&nbsp;
                      <input type="text" name="ext_rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate4(this, this.value);' readonly></td>
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
                    <td align='center'><input type='text' size='10' maxlength='10' name='ext_grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='ext_gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % </td>
                    <td align='center'>
					<%if(base.getRent_st().equals("3")){%>
					  ���� ������ �°迩�� :
					  <select name='ext_grt_suc_yn' disabled>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0"))%>selected<%%>>�°�</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1"))%>selected<%%>>����</option>
                            </select>	
					<%}else{%>					
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='ext_grt_suc_yn' value='<%= fees.getGrt_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='ext_grt_suc_yn' disabled>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0")){%>selected<%}%>>�°�</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1")){%>selected<%}%>>����</option>
                            </select>			  
        				<%}%>
					<%}%>
        				<input type='hidden' name='ext_gur_per' value=''>
        				<input type='hidden' name='ext_grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">������</td>
                    <td align="center"><input type='text' size='10' name='ext_pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ext_pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ext_pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='ext_pere_r_per' class='whitenum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % </td>
                    <td align='center'><input type='hidden' name='ext_pere_per' value=''>
           ������ ��꼭���౸�� :
					<select name='ext_pp_chk' disabled>
                              <option value="">����</option>
                              <option value="1" <%if(fees.getPp_chk().equals("1")){%>selected<%}%>>�����Ͻù���</option>
                              <option value="0" <%if(fees.getPp_chk().equals("0")){%>selected<%}%>>�ſ��յ����</option>
                            </select>
                    </td>
                </tr>                
                <tr>
                    <td class='title' colspan="2">���ô뿩��</td>
                    <td align="center"><input type='text' size='10' name='ext_ifee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ext_ifee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ext_ifee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2")%></td>
                    <td align="center">������
                        <input type='text' size='2' name='ext_pere_r_mth' class='whitenum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  ����ġ �뿩�� </td>
                    <td align='center'>
        			    <%if(fees.getRent_st().equals("1")){ %>
        				<input type='hidden' name='ext_ifee_suc_yn' value='<%= fees.getIfee_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='ext_ifee_suc_yn' disabled>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getIfee_suc_yn().equals("0")){%>selected<%}%>>�°�</option>
                              <option value="1" <%if(fees.getIfee_suc_yn().equals("1")){%>selected<%}%>>����</option>
                            </select>			  
        				<%}%>
        			    <input type='hidden' name='ext_pere_mth' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">�հ�</td>
                    <td align="center"><input type='text' size='10' name='ext_tot_pp_s_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ext_tot_pp_v_amt' maxlength='10' class='whitenum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ext_tot_pp_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">�Աݿ����� :
                          <input type='text' size='11' name='ext_pp_est_dt' maxlength='11' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
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
                        ������ : <input name="ext_user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee_etcs.getCredit_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_credit_sac_id" value="<%=fee_etc.getCredit_sac_id()%>">
			<% user_idx++;%>
			&nbsp;&nbsp;&nbsp;&nbsp;
			�������� : <input type='text' size='11' name='ext_credit_sac_dt' maxlength='11' class="whitetext" value='<%=AddUtil.ChangeDate2(fee_etcs.getCredit_sac_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>							
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='4' name='ext_credit_r_per' class='whitenum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='10' name='ext_credit_r_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>��(������������)</td>
                    <td align='center'><input type='text' size='4' name='ext_credit_per' class='whitenum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='10' name='ext_credit_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>��</td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>����<br>
                      �Ÿ�</td>              
              <!--20130605 ������������Ÿ� �-->    
                <td class='title' colspan="2"><span class="title1">��������Ÿ�</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='ext_agree_dist' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >
                  km����/1��,
                  <br>&nbsp;
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (�������Ͽ����) ȯ�޴뿩��  <input type='text' name='ext_rtn_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��/1km (�ΰ�������)
                  <%//	if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
                  <!--
                  <select name='ext_rtn_run_amt_yn' disabled>        
                    <option value=""  <%if(fee_etcs.getRtn_run_amt_yn().equals(""))%>selected<%%>>����</option>                      
                    <option value="0" <%if(fee_etcs.getRtn_run_amt_yn().equals("0"))%>selected<%%>>ȯ�޴뿩������</option>
                    <option value="1" <%if(fee_etcs.getRtn_run_amt_yn().equals("1"))%>selected<%%>>ȯ�޴뿩�������</option>                    
                  </select>
                  -->
                  <%//	}else{ %>
                  <%if(fee_etcs.getRtn_run_amt_yn().equals("0")){%>��ȯ�޴뿩������<%}else if(fee_etcs.getRtn_run_amt_yn().equals("1")){%>��ȯ�޴뿩�������<%} %>
                  <input type="hidden" name="ext_rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <%//	} %>
                  <%}else{ %>
                  <input type="hidden" name="ext_rtn_run_amt" value="<%=fee_etcs.getRtn_run_amt()%>">
                  <input type="hidden" name="ext_rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <%} %>    
                  <br>&nbsp;              
                  (�����ʰ������) �ʰ�����뿩�� <input type='text' name='ext_over_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��/1km (�ΰ�������)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  ���Կɼ� ���� ȯ�޴뿩�� : �⺻���� ������, �Ϲݽ��� 40%�� ����
                  <%} %>
                  <br>&nbsp;                  
                  ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>�� ����
                  <input type="hidden" name="ext_agree_dist_yn" value="<%=fee_etcs.getAgree_dist_yn()%>">
                  <!-- 
                  <select name='ext_agree_dist_yn' disabled>        
                    <option value=""  <%if(fee_etcs.getAgree_dist_yn().equals(""))%>selected<%%>>����</option>                      
                    <option value="1" <%if(fee_etcs.getAgree_dist_yn().equals("1"))%>selected<%%>>���׸���(�⺻��)</option>
                    <option value="2" <%if(fee_etcs.getAgree_dist_yn().equals("2"))%>selected<%%>>50%�� ����(�Ϲݽ�)</option>
                    <option value="3" <%if(fee_etcs.getAgree_dist_yn().equals("3"))%>selected<%%>>���Կɼ� ����(�⺻��,�Ϲݽ�)</option>
                  </select>
                   -->	
                   <!-- 
                  <br>&nbsp;
                  �� ��������Ÿ� ������� ��������Ÿ��� <input type='text' name='ext_ex_agree_dist' size='5' class='whitenum' value='������' >�� ���� �Է��ϸ� �˴ϴ�.
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        �� ���� ����Ÿ� <input type='text' name='ext_cust_est_km' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getCust_est_km())%>' >
                        km/1��
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
                    <input type='text' name='ext_e_rtn_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>' >/1km,<br>&nbsp;
                    <%}else{ %>
                    <input type="hidden" name="ext_e_rtn_run_amt" value="<%=e_bean.getRtn_run_amt()%>">
                    <%} %>
                    <input type='text' name='ext_e_over_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,<br>&nbsp;
                    <input type='text' name='ext_e_agree_dist_yn' size='15' class='whitetext' value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>
              </tr>   
                <tr>
                    <td class='title' style="font-size : 8pt;" colspan="2">����������Ÿ�</td>
                    <td colspan="6">&nbsp;
                        <input type='text' name='ext_over_bas_km' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>' >
                        km
                        (�縮�� ������ �뿩���� ����Ÿ�, ��༭ ���� ��)
                    </td>
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
        			  <input type='text' size='4' name='ext_b_max_ja' maxlength='10' class='whitenum' value='<%=fees.getB_max_ja()%>'>
        			  % </td>
                    <td align='center'><input type='text' name='ext_e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' >km/1��</td>
                </tr>                             
                <tr>
                    <td class='title' colspan="2">���� �ִ��ܰ�</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_s_amt' readonly maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_v_amt' readonly maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ext_ja_amt' readonly maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='ext_max_ja' maxlength='10' readonly class='whitenum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'><input type='text' name='ext_r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >km/1��
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">���Կɼ�</td>
                    <td align="center"><input type='text' size='10' name='ext_opt_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ext_opt_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ext_opt_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
                        <input type='text' size='4' name='ext_opt_per' class='whitenum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  % </td>
                    <td align='center'>
        			  <input type='radio' name="ext_opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%> onClick="javascript:opt_display('0', <%=fees.getRent_dt()%>)">
                      ����
                      <input type='radio' name="ext_opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%> onclick="javascript:opt_display('1', <%=fees.getRent_dt()%>)">
        	 		  ����
                    </td>
                </tr>
                <%if(fee_etcs.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ������ ���� %>
                <tr>
                    <td class='title' colspan="2">�����ܰ�</td>
                    <td align="center"><input type='text' size='10' name='i_ext_ja_r_s_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='i_ext_ja_r_v_amt' readonly maxlength='10' class='whitenum' value='-' >
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='i_ext_ja_r_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='i_ext_app_ja' maxlength='10' readonly class="whitenum" value='-'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}else{%>
                <tr>
                    <td class='title' colspan="2">�����ܰ�</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_r_s_amt' readonly maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_r_v_amt' readonly maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ext_ja_r_amt' readonly maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='ext_app_ja' maxlength='10' readonly class="whitenum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>��<br>��<br>��</td>
                    <td class='title' colspan="2">�����</td>
                    <td align="center" ><input type='text' size='10'  name='ext_fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='10'  name='ext_fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='10'  name='ext_fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>
					���뿩�ᳳ�Թ�� :
					  <select name='ext_fee_chk' disabled>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getFee_chk().equals("0"))%>selected<%%>>�ſ�����</option>
                              <option value="1" <%if(fees.getFee_chk().equals("1"))%>selected<%%>>�Ͻÿϳ�</option>
                            </select>	
					</td>
                </tr>                
                <!-- �������߰����/�������(���Ǻ���) ���� (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">��<br>��<br>��<br>��<br>��</td>
	                <td class='title'>������</td>
	                <td align="center" ><input type='text' size='11' name='ext_inv_s_amt' maxlength='10' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  ��</td>
	                <td align="center" ><input type='text' size='11' name='ext_inv_v_amt' maxlength='9' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  ��</td>
	                <td align='center' ><input type='text' size='11' maxlength='10' name='ext_inv_amt' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  ��</td>
	                <td align="center">-</td>
	                <td align="center">-</td>
	                <td align='center'>&nbsp;</td>
               </tr>
               <tr>
                    <td class='title'>�������(���Ǻ���)</td>
                    <td align="center" ><input type='text' size='11' name='ext_ins_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='11' name='ext_ins_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='11' maxlength='10'  name='ext_ins_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">&nbsp;�������(���ް�) = �Ⱓ�����
                    	<input type='text' size='10' maxlength='10' name='ext_ins_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 ��/12</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
	                <td class='title'>�������߰����</td>
	                <td align="center" >
	                	<input type='text' size='11' name='ext_driver_add_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> �� 
	                </td>
	                <td align="center" >
	                	<input type='text' size='11' name='ext_driver_add_v_amt'  maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center' >
	                	<input type='text' size='11' maxlength='10'  name='ext_driver_add_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	            </tr>
                <tr>
                    <td class='title'>������ �հ�</td>
                    <td align="center" >
                    	<input type='text' size='11' name='ext_tinv_s_amt' maxlength='11' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etcs.getDriver_add_amt())%>'> �� 
                    </td>
                    <td align="center" >
                       	<input type='text' size='11' name='ext_tinv_v_amt'  maxlength='9' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center' >
                    	<input type='text' size='11' maxlength='10'  name='ext_tinv_amt' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
               </tr>
               
        	<tr>
                <td class='title' colspan="2">�뿩��DC</td>
                <td colspan='3'>&nbsp;
                    ������ : 
                        <input name="ext_user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee_etcs.getDc_ra_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_dc_ra_sac_id" value="<%=fee_etcs.getDc_ra_sac_id()%>">
			<% user_idx++;%>
		    &nbsp;&nbsp;&nbsp;&nbsp;
		    �������� : 	
		    <input type='text' size='11' name='ext_bas_dt' maxlength='11' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                
                </td>                    
                <td align='center'>-</td>            
                <td align="center">
                    ����ٰ� : <select name='ext_dc_ra_st' disabled>
                        <option value=''>����</option>
                        <option value='1' <%if(fee_etcs.getDc_ra_st().equals("1")){%>selected<%}%>>����DC����</option>
                        <option value='2' <%if(fee_etcs.getDc_ra_st().equals("2")){%>selected<%}%>>Ư��DC</option>
                    </select>
                    &nbsp;
		    ��Ÿ : 
		    <input type='text' size='18' name='ext_dc_ra_etc' class="whitetext" value='<%=fee_etcs.getDc_ra_etc()%>'>
                </td>
                <td align='center'>
                    DC�� <input type='text' size='4' name='ext_dc_ra' maxlength='10' class="whitenum" value='<%=fees.getDc_ra()%>'>%
                    DC�ݾ� <input type='text' size='6' name='ext_dc_ra_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>'>
        				  ��
                </td>
              </tr>                       
		<%	int fee_etc_rowspan = 2;
		    	if(fees.getRent_st().equals("1") && base.getRent_st().equals("3")) fee_etc_rowspan = fee_etc_rowspan+2;//��������϶� ���������
		%>
                <tr>
                    <td rowspan="<%=fee_etc_rowspan%>" class='title'>��<br>
                      Ÿ</td>
                  <td class='title' colspan="2" style="font-size : 8pt;">�ߵ�����������</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">�ܿ��Ⱓ �뿩����
                        <input type='text' size='3' name='ext_cls_r_per' maxlength='10'  class='whitenum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='ext_cls_per' maxlength='10' class='whitenum' value='<%=fees.getCls_per()%>'>%
						,�ʿ��������[<input type='text' size='3' name='ext_cls_n_per' maxlength='10' class='whitenum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                </tr>
                <tr>
                    <td class='title'  colspan="2">��������</td>
                    <td colspan="2" align="center">
        			  �������:
        			  <select name='ext_commi_car_st' disabled>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>��������</option>
                      </select>
        			</td>
                    <td align='center'><input type='text' size='10' name='ext_commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">
                        <input type='text' name="ext_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='whitenum' onBlur='javascript:setCommi()'>
        		      %</td>
                    <td align='center'>
        				        <input type='text' name="ext_comm_rt" value='<%=emp1.getComm_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='whitenum' <%if(!base.getUse_yn().equals("")){%>readonly<%}%>>
        			  %</td>
                </tr>					    
				        <%if(fees.getRent_st().equals("1") && base.getRent_st().equals("3")){
										//�������������
										Hashtable suc_cont = new Hashtable();
										if(!cont_etc.getGrt_suc_l_cd().equals("")){
											suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
										}  
								%>                                  
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">���������</td>
                    <td colspan="6">&nbsp;
					  <b>[���������]</b>
					  &nbsp;����ȣ : <input type='text' name='ext_grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='ext_grt_suc_c_no' size='12' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;�����ڵ庰���� ���� : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  <br>
					  &nbsp;
					  <b>[���������ݽ°�]</b>
					  &nbsp;���������� : <input type='text' name='ext_grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum' >��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  �°躸���� : <input type='text' name='ext_grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='whitenum' >��
					  <input type='hidden' name='ext_grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>		
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(���������� ���� <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  <%} %>					  
        			</td>
                </tr>						
                <%}%>
                <%if(ej_bean.getJg_g_7().equals("3")){//������,������ 20190701 ����������%>
                <tr>
                    <td colspan="3" class='title'>������ �μ�/�ݳ� ����</td>
                    <td colspan="6">&nbsp;
                    	<select name='ext_return_select' disabled>
                        <option value=''>����</option>
                        <option value='0' <%if(fee_etcs.getReturn_select().equals("0")){%>selected<%}%>>�μ�/�ݳ� ������</option>
                        <option value='1' <%if(fee_etcs.getReturn_select().equals("1")){%>selected<%}%>>�ݳ���</option>
                    	</select>
                    </td>
                </tr>
                <%}%>			                
                <tr>
                    <td colspan="3" class='title'>��༭ Ư����� ���� ����</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                      		<textarea rows='5' cols='90' name='ext_con_etc' OnBlur='checkSpecial();'><%=fee_etcs.getCon_etc()%></textarea>
                      		</div>
                   		</div>
                   		<div style="float: left; margin-left: 10px; height: 100%; display: table;">
					  		<div style="display: table-cell; vertical-align: middle;">
					  		<%-- <%if( ej_bean.getJg_3() > 0 && (
					  					cm_bean.getJg_code().equals("4022311") || cm_bean.getJg_code().equals("4022312") || cm_bean.getJg_code().equals("4022313") || cm_bean.getJg_code().equals("4022314")
					  					 || cm_bean.getJg_code().equals("5014123") || cm_bean.getJg_code().equals("5018411") || cm_bean.getJg_code().equals("5018412") || cm_bean.getJg_code().equals("5018413")
					  					 || cm_bean.getJg_code().equals("6022410") || cm_bean.getJg_code().equals("6022415") || cm_bean.getJg_code().equals("6022418") || cm_bean.getJg_code().equals("4217013") || cm_bean.getJg_code().equals("3516312")
					  					 || cm_bean.getJg_code().equals("4519221") || cm_bean.getJg_code().equals("4519222") || cm_bean.getJg_code().equals("4519223") || cm_bean.getJg_code().equals("5514112")
					  					 || cm_bean.getJg_code().equals("6516213") || cm_bean.getJg_code().equals("6516214") || cm_bean.getJg_code().equals("6516215") || cm_bean.getJg_code().equals("6519213") || cm_bean.getJg_code().equals("6519214")
					  					|| cm_bean.getJg_code().equals("5028511") || cm_bean.getJg_code().equals("5028512")
					  					|| cm_bean.getJg_code().equals("4016314") || cm_bean.getJg_code().equals("6012423") || cm_bean.getJg_code().equals("6012424") || cm_bean.getJg_code().equals("6012428") || cm_bean.getJg_code().equals("6012429")
				                		 || cm_bean.getJg_code().equals("6022421") || cm_bean.getJg_code().equals("6022422") || cm_bean.getJg_code().equals("6022423") || cm_bean.getJg_code().equals("6022424") || cm_bean.getJg_code().equals("6022426") || cm_bean.getJg_code().equals("6022427")
				                		 || cm_bean.getJg_code().equals("6024411") || cm_bean.getJg_code().equals("6024412") || cm_bean.getJg_code().equals("6024413") || cm_bean.getJg_code().equals("6024414") || cm_bean.getJg_code().equals("6024415")
				                		 || cm_bean.getJg_code().equals("5028513") || cm_bean.getJg_code().equals("5018414") || cm_bean.getJg_code().equals("5018415") || cm_bean.getJg_code().equals("5018416")
					  				) ){ %>
			                	<input type="button" onclick="setMentConEtc('5')" value="�����Һ��� ȯ���� �ȳ�����">
							<%}%> --%>
								<script>
								function setMentConEtc(idx) {
									if (idx == "5") {
										document.form1.con_etc.value = "�� 2022�� 1�� 1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�.";
									} 
								}
							  	</script>
					  		</div>
					  	</div>
                    </td>
                </tr>			                
                <tr>
                    <td colspan="3" class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='ext_fee_cdt'><%=fees.getFee_cdt()%></textarea></td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>���<br>(���� ����)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='ext_cls_etc'><%=cont_etc.getCls_etc()%></textarea></td>
                </tr>			
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>����Ƚ��</td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='ext_fee_pay_tm' value='<%=fees.getFee_pay_tm()%>' maxlength='2' class='whitetext' >
        				ȸ </td>
                    <td width="10%" class='title'>��������</td>
                    <td width="20%">&nbsp;�ſ�
                      <select name='ext_fee_est_day' disabled>
                        <option value="">����</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                        <option value='<%=i%>' <%if(fees.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                        <% } %>
                        <option value='99' <%if(fees.getFee_est_day().equals("99")){%> selected <%}%>> ���� </option>
						<option value='98' <%if(fees.getFee_est_day().equals("98")){%> selected <%}%>> �뿩������ </option>
                      </select></td>
                    <td width="10%" class='title'>���ԱⰣ</td>
                    <td>&nbsp;
                      <input type='text' name='ext_fee_pay_start_dt' maxlength='11' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  <input type='text' name='ext_fee_pay_end_dt' maxlength='11' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
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
            				    <td align="center"><input type='text' size='12' name='ext_bc_b_e1' maxlength='10' class=whitenum value='<%=fee_etcs.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;����忹��������</td>
            				    <td align="center"><input type='text' size='12' name='ext_bc_b_e2' maxlength='10' class=whitenum value='<%=fee_etcs.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;��Ÿ���</td>
            				  <td align="center"><input type='text' size='12' name='ext_bc_b_u' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='ext_bc_b_u_cont' maxlength='150' class=whitetext value='<%=fee_etcs.getBc_b_u_cont()%>'>
            				  </td>
            				</tr>							
            		        <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;��Ÿ����</td>
            				  <td align="center"><input type='text' size='12' name='ext_bc_b_g' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='ext_bc_b_g_cont' maxlength='150' class=whitetext value='<%=fee_etcs.getBc_b_g_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;��Ÿ ����ȿ���ݿ���</td>
            				  <td align="center"><input type='text' size='12' name='ext_bc_b_ac' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='30' name='ext_bc_b_ac_cont' maxlength='150' class=whitetext value='<%=fee_etcs.getBc_b_ac_cont()%>'></td>
            				</tr>
            		        <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_etc</td>				  
            				  <td>&nbsp;�������ǻ���</td>
            				  <td align="center"><textarea rows='5' cols='70' name='ext_bc_etc'><%=fee_etcs.getBc_etc()%></textarea></td>
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
	<%		}else{//������ȸ�� %>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td width="13%" align="center" class=title>�������</td>
                <td width="20%">&nbsp;
					  <%if(user_id.equals(base.getBus_id())){%>
        			  <input type="text" name="ext_rent_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_dt())%>" size="11" maxlength='11' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);' readonly>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(fees.getRent_dt())%>
					  <input type='hidden' name='ext_rent_dt' 	value='<%=fees.getRent_dt()%>'>
					  <%}%>				
				  
				</td>
                <td width="10%" align="center" class=title>�������</td>
                <td >&nbsp;    
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fees.getExt_agnt(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_agnt" value="<%=fees.getExt_agnt()%>">						
			<% user_idx++;%>
                </td>
                <td width="10%" align="center" class=title>�����븮��</td>
                <td >&nbsp;                  
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee_etcs.getBus_agnt_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_bus_agnt_id" value="<%=fee_etcs.getBus_agnt_id()%>">						
			<% user_idx++;%>               
                </td>
              </tr>				
              <tr>
                <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                <td width="20%">&nbsp;
                    <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitetext' onChange='javascript:set_cont_date(this)' readonly>
        			 ����</td>
                <td width="10%" align="center" class=title>�뿩������</td>
                <td width="20%">&nbsp;
                  <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);' readonly></td>
                <td width="10%" align="center" class=title>�뿩������</td>
                <td>&nbsp;
                  <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);' readonly></td>
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
                <% String pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0"); %>
                <tr>
                    <td width="3%" rowspan="5" class='title'>��<br>
                      ��</td>
                    <td width="10%" class='title' colspan="2">������</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'  <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum'  readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">������
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				  <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>
    				            <br><font color=red>�� �Աݵ� �������� ���� ���游 �����մϴ�.</font>
    				            <a href="javascript:update_item('grt_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        			</td>
                    <td align='center'>
					<%if(base.getRent_st().equals("3")){%>
					  ���� ������ �°迩�� :
					  <select name='grt_suc_yn'>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0"))%>selected<%%>>�°�</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1"))%>selected<%%>>����</option>
                            </select>	
					<%}else{%>					
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='grt_suc_yn' value='<%= fees.getGrt_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='grt_suc_yn'>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0")){%>selected<%}%>>�°�</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1")){%>selected<%}%>>����</option>
                            </select>			  
        				<%}%>
					<%}%>
        				<input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'></td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1"); %>
                <tr>
                    <td class='title' colspan="2">������</td>
                    <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='pp_v_amt' maxlength='10' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">������
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				  <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>
    				            <br><font color=red>�� �Աݵ� �������� ���� ���游 �����մϴ�.</font>
    				            <a href="javascript:update_item('pp_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        				  </td>
                    <td align='center'><input type='hidden' name='pere_per' value=''>
           ������ ��꼭���౸�� :
					<select name='pp_chk'>
                              <option value="">����</option>
                              <option value="1" <%if(fees.getPp_chk().equals("1")){%>selected<%}%>>�����Ͻù���</option>
                              <option value="0" <%if(fees.getPp_chk().equals("0")){%>selected<%}%>>�ſ��յ����</option>
                            </select>
                    </td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2"); %>
                <tr>
                    <td class='title' colspan="2">���ô뿩��</td>
                    <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ifee_v_amt' maxlength='10' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  ��</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">������
                        <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  ����ġ �뿩��
        				  <%if(pp_pay_st.equals("�Ա�") || pp_pay_st.equals("�ܾ�")){%>
    				            <br><font color=red>�� �Աݵ� ���ô뿩��� ���� ���游 �����մϴ�.</font>
    				            <a href="javascript:update_item('ifee_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %> 
        			</td>
                    <td align='center'>
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='ifee_suc_yn' value='<%= fees.getIfee_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='ifee_suc_yn'>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getIfee_suc_yn().equals("0")){%>selected<%}%>>�°�</option>
                              <option value="1" <%if(fees.getIfee_suc_yn().equals("1")){%>selected<%}%>>����</option>
                            </select>			  
        				<%}%>
        			    <input type='hidden' name='pere_mth' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">�հ�</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_s_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_v_amt' maxlength='10' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='tot_pp_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">�Աݿ����� :
                          <input type='text' size='11' name='pp_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
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
                        ������ : <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etcs.getCredit_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="credit_sac_id" value="<%=fee_etcs.getCredit_sac_id()%>">
			<a href="javascript:User_search('credit_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
			&nbsp;&nbsp;&nbsp;&nbsp;
			�������� : <input type='text' size='11' name='credit_sac_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee_etcs.getCredit_sac_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>							
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>��(������������)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='10' name='credit_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>��</td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>����<br>
                      �Ÿ�</td>              
              <!--20130605 ������������Ÿ� �-->    
                <td class='title' colspan="2"><span class="title1">��������Ÿ�</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='agree_dist' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >
                  km����/1��,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (�������Ͽ����) ȯ�޴뿩��  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��/1km (�ΰ�������)
                  <%//	if ((nm_db.getWorkAuthUser("������", user_id) || nm_db.getWorkAuthUser("���翵��������", user_id) || nm_db.getWorkAuthUser("������������", user_id) || user_id.equals("000057"))) {%>
                  <!--
                  <select name='rtn_run_amt_yn'>        
                    <option value="">����</option>                      
                    <option value="0" <%if(fee_etcs.getRtn_run_amt_yn().equals("0")||fee_etcs.getRtn_run_amt_yn().equals(""))%>selected<%%>>ȯ�޴뿩������</option>
                    <option value="1" <%if(fee_etcs.getRtn_run_amt_yn().equals("1"))%>selected<%%>>ȯ�޴뿩�������</option>                    
                  </select>
                  -->
                  <%//	}else{ %>
                  <%if(fee_etcs.getRtn_run_amt_yn().equals("0")){%>��ȯ�޴뿩������<%}else if(fee_etcs.getRtn_run_amt_yn().equals("1")){%>��ȯ�޴뿩�������<%} %>
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <%//	} %>
                  <%}else{ %>
                  <input type="hidden" name="rtn_run_amt" value="<%=fee_etcs.getRtn_run_amt()%>">
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <%} %>                  
                  <br>&nbsp;                  
                  (�����ʰ������) �ʰ�����뿩�� <input type='text' name='over_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��/1km (�ΰ�������)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  ���Կɼ� ���� ȯ�޴뿩�� : �⺻���� ������, �Ϲݽ��� 40%�� ����
                  <%} %>
                  <br>&nbsp;                  
                  ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>�� ����
                  <!-- 
                  �ʰ� 1km�� (<input type='text' name='over_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��)�� �ʰ�����δ���� �ΰ��� (�뿩�����)	
                  <br>&nbsp;
                  ���Կɼ� ���� �ʰ�����뿩�� : �⺻���� ���׸���, �Ϲݽ��� 50%�� ����
                   -->
                  <input type="hidden" name="agree_dist_yn" value="<%=fee_etcs.getAgree_dist_yn()%>">
                  <!-- 
                  <select name='agree_dist_yn'>        
                    <option value=""  <%if(fee_etcs.getAgree_dist_yn().equals(""))%>selected<%%>>����</option>                      
                    <option value="1" <%if(fee_etcs.getAgree_dist_yn().equals("1"))%>selected<%%>>���׸���(�⺻��)</option>
                    <option value="2" <%if(fee_etcs.getAgree_dist_yn().equals("2"))%>selected<%%>>50%�� ����(�Ϲݽ�)</option>
                    <option value="3" <%if(fee_etcs.getAgree_dist_yn().equals("3"))%>selected<%%>>���Կɼ� ����(�⺻��,�Ϲݽ�)</option>
                  </select>	
                  -->
                  <br>&nbsp;
                  �� ��������Ÿ� ������� ��������Ÿ��� <input type='text' name='ex_agree_dist' size='5' class='defaultnum' value='������' >�� ���� �Է��ϸ� �˴ϴ�.
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        �� ���� ����Ÿ� <input type='text' name='cust_est_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getCust_est_km())%>' >
                        km/1��
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
                    <input type='text' name='e_rtn_run_amt' size='2' class='whitenum' readonly value='<%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>' >/1km,<br>&nbsp;
                    <%}else{ %>
                  	<input type="hidden" name="e_rtn_run_amt" value="<%=e_bean.getRtn_run_amt()%>">
                  	<%} %>                       
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' readonly value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,    <br>&nbsp;                
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' readonly value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>
              </tr>   
                <tr>
                    <td class='title' style="font-size : 8pt;" colspan="2">����������Ÿ�</td>
                    <td colspan="6">&nbsp;
                        <input type='text' name='over_bas_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>' >
                        km
                        (�縮�� ������ �뿩���� ����Ÿ�, ��༭ ���� ��)
                    </td>
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
        			  <input type='text' size='4' name='b_max_ja' maxlength='10' class='fixnum' value='<%=fees.getB_max_ja()%>'>
        			  % </td>
                    <td align='center'><input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' >km/1��</td>
                </tr>                             
                <tr>
                    <td class='title' colspan="2">���� �ִ��ܰ�</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ja_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='max_ja' maxlength='10' readonly class='fixnum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'><input type='text' name='r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >km/1��
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">���Կɼ�</td>
                    <td align="center"><input type='text' size='10' name='opt_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='opt_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='opt_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
                        <input type='text' size='4' name='opt_per' class='defaultnum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  % </td>
                    <td align='center'>
        			  <input type='radio' name="opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%> onClick="javascript:opt_display('0', <%=fees.getRent_dt()%>)">
                      ����
                      <input type='radio' name="opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%> onclick="javascript:opt_display('1', <%=fees.getRent_dt()%>)">
        	 		  ����
                    </td>
                </tr>
                <%if(fee_etcs.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//������,������  20190701  || ej_bean.getJg_g_7().equals("4") ���������� %>
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
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center"><input type='text' size='10' name='ja_r_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">������
        			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="defaultnum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>��<br>��<br>��</td>
                    <td class='title' colspan="2">�����</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='10'  name='fee_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>
					���뿩�ᳳ�Թ�� :
					  <select name='fee_chk'>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getFee_chk().equals("0"))%>selected<%%>>�ſ�����</option>
                              <option value="1" <%if(fees.getFee_chk().equals("1"))%>selected<%%>>�Ͻÿϳ�</option>
                            </select>	
					</td>
                </tr>                
                <!-- �������߰����/�������(���Ǻ���) ���� (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">��<br>��<br>��<br>��<br>��</td>
	                <td class='title'>������</td>
	                <td align="center" ><input type='text' size='11' name='inv_s_amt' maxlength='10' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  ��</td>
	                <td align="center" ><input type='text' size='11' name='inv_v_amt' maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  ��</td>
	                <td align='center' ><input type='text' size='11' maxlength='10' name='inv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  ��</td>
	                <td align="center">-</td>
	                <td align="center">-</td>
	                <td align='center'>&nbsp;
	    			  <span class="b"><a href="javascript:estimate('<%=fees.getRent_st()%>', '<%=fees.getRent_dt()%>', '<%=fees.getRent_start_dt()%>', 'account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
	                </td>
               </tr>
               <tr>
                    <td class='title'>�������(���Ǻ���)</td>
                    <td align="center" ><input type='text' size='11' name='ins_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='11' name='ins_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='11' maxlength='10'  name='ins_amt' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">&nbsp;�������(���ް�) = �Ⱓ�����
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 ��/12</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
	                <td class='title'>�������߰����</td>
	                <td align="center" >
	                	<input type='text' size='11' name='driver_add_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> �� 
	                </td>
	                <td align="center" >
	                	<input type='text' size='11' name='driver_add_v_amt'  maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center' >
	                	<input type='text' size='11' maxlength='10'  name='driver_add_total_amt' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
	                </td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	            </tr>
                <tr>
                    <td class='title'>������ �հ�</td>
                    <td align="center" >
                    	<input type='text' size='11' name='tinv_s_amt' maxlength='11' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etcs.getDriver_add_amt())%>'> �� 
                    </td>
                    <td align="center" >
                       	<input type='text' size='11' name='tinv_v_amt'  maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center' >
                    	<input type='text' size='11' maxlength='10'  name='tinv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> ��
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
               </tr>
               
        	<tr>
                <td class='title' colspan="2">�뿩��DC</td>
                <td colspan='3'>&nbsp;
                    ������ : 
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etcs.getDc_ra_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="dc_ra_sac_id" value="<%=fee_etcs.getDc_ra_sac_id()%>">
			<a href="javascript:User_search('dc_ra_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
		    &nbsp;&nbsp;&nbsp;&nbsp;
		    �������� : 	
		    <input type='text' size='11' name='bas_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                
                </td>                    
                <td align='center'>-</td>            
                <td align="center">
                    ����ٰ� : <select name='dc_ra_st'>
                        <option value=''>����</option>
                        <option value='1' <%if(fee_etcs.getDc_ra_st().equals("1")){%>selected<%}%>>����DC����</option>
                        <option value='2' <%if(fee_etcs.getDc_ra_st().equals("2")){%>selected<%}%>>Ư��DC</option>
                    </select>
                    &nbsp;
		    ��Ÿ : 
		    <input type='text' size='18' name='dc_ra_etc' class="text" value='<%=fee_etcs.getDc_ra_etc()%>'>
                </td>
                <td align='center'>
                    DC�� <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fees.getDc_ra()%>'>%
                    DC�ݾ� <input type='text' size='6' name='dc_ra_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>'>
        				  ��
                </td>
              </tr>                       
		<%	int fee_etc_rowspan = 2;
		    	if(fees.getRent_st().equals("1") && base.getRent_st().equals("3")) fee_etc_rowspan = fee_etc_rowspan+2;//��������϶� ���������
		%>
                <tr>
                    <td rowspan="<%=fee_etc_rowspan%>" class='title'>��<br>
                      Ÿ</td>
                  <td class='title' colspan="2" style="font-size : 8pt;">�ߵ�����������</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">�ܿ��Ⱓ �뿩����
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fees.getCls_per()%>'>%
						,�ʿ��������[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                </tr>
                <tr>
                    <td class='title'  colspan="2">��������</td>
                    <td colspan="2" align="center">
        			  �������:
        			  <select name='commi_car_st'>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>��������</option>
                      </select>
        			</td>
                    <td align='center'><input type='text' size='10' name='commi_car_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">
                        <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='defaultnum' onBlur='javascript:setCommi()'>
        		      %</td>
                    <td align='center'>
        				        <input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='fixnum' <%if(!base.getUse_yn().equals("")){%>readonly<%}%>>
        			  %</td>
                </tr>					    
				        <%if(fees.getRent_st().equals("1") && base.getRent_st().equals("3")){
										//�������������
										Hashtable suc_cont = new Hashtable();
										if(!cont_etc.getGrt_suc_l_cd().equals("")){
											suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
										}  
								%>
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">���������</td>
                    <td colspan="6">&nbsp;
					  <b>[���������]</b>
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;����ȣ : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='grt_suc_c_no' size='12' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
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
					  <font color=red>(���������� ���� <input type='text' name='grt_suc_cha_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt()-cont_etc.getGrt_suc_r_amt())%>' class='whitenum'>)</font>
					  <%}else{ %>
					  <input type='hidden' name='grt_suc_cha_amt' 	value=''>
					  <%} %>					  	
        			</td>
                </tr>						
                <%}%>
                <%if(ej_bean.getJg_g_7().equals("3")){//������,������ 20190701  || ej_bean.getJg_g_7().equals("4") ������ ���� %>
                <tr>
                    <td colspan="3" class='title'>������ �μ�/�ݳ� ����</td>
                    <td colspan="6">&nbsp;
                    	<select name='return_select'>
                        <option value=''>����</option>
                        <option value='0' <%if(fee_etcs.getReturn_select().equals("0")){%>selected<%}%>>�μ�/�ݳ� ������</option>
                        <option value='1' <%if(fee_etcs.getReturn_select().equals("1")){%>selected<%}%>>�ݳ���</option>
                    	</select>
                    </td>
                </tr>		
                <%}%>	                 
                <tr>
                    <td colspan="3" class='title'>��༭ Ư����� ���� ����</td>
                    <td colspan="6">&nbsp;
                      <div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                      		<textarea rows='5' cols='90' name='con_etc' ><%=fee_etcs.getCon_etc()%></textarea>
                      		</div>
                   		</div>
                      <div style="float: left; margin-left: 10px; height: 100%; display: table;">
					  		<div style="display: table-cell; vertical-align: middle;">
					  		<%-- <%if( ej_bean.getJg_3() > 0 && (
					  					cm_bean.getJg_code().equals("4022311") || cm_bean.getJg_code().equals("4022312") || cm_bean.getJg_code().equals("4022313") || cm_bean.getJg_code().equals("4022314")
					  					 || cm_bean.getJg_code().equals("5014123") || cm_bean.getJg_code().equals("5018411") || cm_bean.getJg_code().equals("5018412") || cm_bean.getJg_code().equals("5018413")
					  					 || cm_bean.getJg_code().equals("6022410") || cm_bean.getJg_code().equals("6022415") || cm_bean.getJg_code().equals("6022418") || cm_bean.getJg_code().equals("4217013") || cm_bean.getJg_code().equals("3516312")
					  					 || cm_bean.getJg_code().equals("4519221") || cm_bean.getJg_code().equals("4519222") || cm_bean.getJg_code().equals("4519223") || cm_bean.getJg_code().equals("5514112")
					  					 || cm_bean.getJg_code().equals("6516213") || cm_bean.getJg_code().equals("6516214") || cm_bean.getJg_code().equals("6516215") || cm_bean.getJg_code().equals("6519213") || cm_bean.getJg_code().equals("6519214")
					  					 || cm_bean.getJg_code().equals("5028511") || cm_bean.getJg_code().equals("5028512")
					  					|| cm_bean.getJg_code().equals("4016314") || cm_bean.getJg_code().equals("6012423") || cm_bean.getJg_code().equals("6012424") || cm_bean.getJg_code().equals("6012428") || cm_bean.getJg_code().equals("6012429")
				                		 || cm_bean.getJg_code().equals("6022421") || cm_bean.getJg_code().equals("6022422") || cm_bean.getJg_code().equals("6022423") || cm_bean.getJg_code().equals("6022424") || cm_bean.getJg_code().equals("6022426") || cm_bean.getJg_code().equals("6022427")
				                		 || cm_bean.getJg_code().equals("6024411") || cm_bean.getJg_code().equals("6024412") || cm_bean.getJg_code().equals("6024413") || cm_bean.getJg_code().equals("6024414") || cm_bean.getJg_code().equals("6024415")
				                		 || cm_bean.getJg_code().equals("5028513") || cm_bean.getJg_code().equals("5018414") || cm_bean.getJg_code().equals("5018415") || cm_bean.getJg_code().equals("5018416")
					  				) ){ %>
			                	<input type="button" onclick="setMentConEtc1('5')" value="�����Һ��� ȯ���� �ȳ�����">
							<%}%> --%>
								<script>
								function setMentConEtc1(idx) {
									if (idx == "5") {
										document.form1.con_etc.value = "�� 2022�� 1�� 1�� ���� ������ ���Ǿ� �ѽ������� ���ϵ� �ڵ��� �����Һ����� ȯ��(3.5% �� 5%)�� ��� ���뿩�ᰡ *,***��(���ް�) �λ�˴ϴ�.";
									} 
								}
							  	</script>
					  		</div>
					  	</div>
                     </td>
                </tr>			                
                <tr>
                    <td colspan="3" class='title'>���<br>(�Ϲ����� ���� �� ����������� ���� ����)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='fee_cdt'><%=fees.getFee_cdt()%></textarea></td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>���<br>(���� ����)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='cls_etc'><%=cont_etc.getCls_etc()%></textarea></td>
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
            </table>
	    </td>
    </tr>			
    <input type='hidden' name='bc_b_e1' value='<%=fee_etcs.getBc_b_e1()%>'>
    <input type='hidden' name='bc_b_e2' value='<%=fee_etcs.getBc_b_e2()%>'>
    <input type='hidden' name='bc_b_u' value='<%=fee_etcs.getBc_b_u()%>'>
    <input type='hidden' name='bc_b_u_cont' value='<%=fee_etcs.getBc_b_u_cont()%>'>
    <input type='hidden' name='bc_b_g' value='<%=fee_etcs.getBc_b_g()%>'>
    <input type='hidden' name='bc_b_g_cont' value='<%=fee_etcs.getBc_b_g_cont()%>'>
    <input type='hidden' name='bc_b_ac' value='<%=fee_etcs.getBc_b_ac()%>'>
    <input type='hidden' name='bc_b_ac_cont' value='<%=fee_etcs.getBc_b_ac_cont()%>'>
    <input type='hidden' name='bc_etc' value='<%=fee_etcs.getBc_etc()%>'>
   <%}%> 
<%}%>
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('12')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	    
	<%}%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Թ��</span></td>
    </tr>	
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee2 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="3%" rowspan="4" class='title'>��<br>��<br>��<br>��<br>��<br>��<br>��</td>				
                    <td width="10%" class='title'>���ݱ���</td>
                    <td width="20%">&nbsp;
                      <select name='fee_sh'>
                        <option value="">����</option>
                        <option value="0" <%if(fee.getFee_sh().equals("0")){%> selected <%}%>>�ĺ�</option>
                        <option value="1" <%if(fee.getFee_sh().equals("1")){%> selected <%}%>>����</option>
                      </select></td>
                    <td width="10%" class='title'>���ι��</td>
                    <td>&nbsp;
                      <select name='fee_pay_st'>
                        <option value=''>����</option>
                        <option value='1' <%if(fee.getFee_pay_st().equals("1")){%> selected <%}%>>�ڵ���ü</option>
                        <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>�������Ա�</option>                        
                        <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>����</option>
                        <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>��Ÿ</option>
                      </select></td>
        			  <td class='title'>CMS�̽���</td>
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
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee.getDef_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="def_sac_id" value="<%=fee.getDef_sac_id()%>">			
			<a href="javascript:User_search('def_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
                      </td>
                </tr>
                  <tr>
                    <td class='title'>�ڵ���ü
                        <br><span class="b"><a href="javascript:search_cms('<%=zip_cnt%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                    </td>
                    <td colspan="5"><table width="100%" border="0" cellpadding="0">
        			  <tr>
        			    <td>&nbsp;
						  ���¹�ȣ : 
        			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='20' class='text'>
        			      (
        			      <input type='hidden' name="cms_bank" 			value="<%=cms.getCms_bank()%>">
        			      <select name='cms_bank_cd'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];	
        												if(cms.getCms_bank().equals("")){
        													//�ű��ΰ�� �̻������ ����
																	if(bank.getUse_yn().equals("N"))	 continue;
        								%>
                        <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}else{
                        %>
                        <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}%>
                        <%		}
        					}%>
                      </select>
        
        			       ) </td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
						  �� �� �� :&nbsp;
        			      <input type='text' name='cms_dep_nm' value='<%=cms.getCms_dep_nm()%>' size='20' class='text'>
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
        			    <td>&nbsp;
					  ������ �������/����ڹ�ȣ :
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
					  <script>
						function openDaumPostcode12() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip12').value = data.zonecode;
									document.getElementById('t_addr12').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
    				  &nbsp;&nbsp;������ �ּ� : 
					  <input type="text" name="t_zip"  id="t_zip12" size="7" maxlength='7' value="<%=cms.getCms_dep_post()%>">
					<input type="button" onclick="openDaumPostcode12()" value="�����ȣ ã��">&nbsp;<input type="text" name="t_addr" id="t_addr12" size="50" value="<%=cms.getCms_dep_addr()%>">
        				  </td>
        			    </tr>			
        			  <tr>
        			    <td>&nbsp;
					  ������ȭ :
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
            </table>
        </td>
    </tr>			
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('12_2')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ݰ�꼭</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_tax style="display:''"> 
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
        			  <%if(cont_etc.getRec_st().equals("") && client.getEtax_not_cau().equals("")) 	cont_etc.setRec_st("1");
        			    if(cont_etc.getRec_st().equals("") && !client.getEtax_not_cau().equals("")) cont_etc.setRec_st("2");%>
                      <select name='rec_st'>
                        <option value="">����</option>					
                        <option value="1" <% if(cont_etc.getRec_st().equals("1")) out.print("selected"); %>>�̸���</option>
                        <option value="2" <% if(cont_etc.getRec_st().equals("2")) out.print("selected"); %>>����</option>
                        <option value="3" <% if(cont_etc.getRec_st().equals("3")) out.print("selected"); %>>���ɾ���</option>
                      </select>
                    </td>
                    <td width="10%" class='title' style="font-size : 8pt;">���ڼ��ݰ�꼭</td>
                    <td>&nbsp;<%if(cont_etc.getEle_tax_st().equals("") && cont_etc.getRec_st().equals("1")) cont_etc.setEle_tax_st("1");%>
                      <select name='ele_tax_st'>
                        <option value="">����</option>
                        <option value="1" <% if(cont_etc.getEle_tax_st().equals("1")) out.print("selected"); %>>���ý���</option>
                        <option value="2" <% if(cont_etc.getEle_tax_st().equals("2")) out.print("selected"); %>>�����ý���</option>
                      </select>
                      <input type='text' name='tax_extra' maxlength='10' size='15' value='<%=cont_etc.getTax_extra()%>' class='text'>
        			</td>
                </tr>
			  <!--�ΰ���ȯ�������� �߰� �Ǿ��� ��쿡 �ΰ���ȯ������ ��꼭 ���� �߱ݿ� ���� ���´�.-->
			  <%	Hashtable tax_print_car = al_db.getTaxPrintCarStChk(base.getClient_id());
			  		if(AddUtil.parseInt(String.valueOf(tax_print_car.get("TOT_CNT")))>1 && !client.getPrint_car_st().equals("1") && !client.getPrint_st().equals("1") &&
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409") 
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
					   ){
					   %>
			  <tr>
                <td width="13%" class='title'>��꼭�������౸��</td>			  
			    <td colspan='5'>&nbsp;
				  <select name='print_car_st'>
                    <option value="">����</option>				  
                    <option value=''  <%if(client.getPrint_car_st().equals("")) out.println("selected");%>>����</option>
                    <option value='1' <%if(client.getPrint_car_st().equals("1")) out.println("selected");%>>����/ȭ��/9�ν�/����</option>							
                  </select>	
				  <font color=red>* '<%=cm_bean.getCar_nm()%>' ������ �ΰ���ȯ�޴�� �����Դϴ�. �ΰ���ȯ���Ұ�� ��꺰�����౸���� [����/ȭ��/9�ν�/����]�� �����Ͻʽÿ�.</font>
				</td>	
			  </tr>
			  <%	}%>						
            </table>
        </td>
    </tr>
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('13')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_tae1 style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>�������������</td>
                    <td width="20%">&nbsp; &nbsp;<%if(fee.getPrv_dlv_yn().equals("")) fee.setPrv_dlv_yn("N"); %>
                      <input type='radio' name="prv_dlv_yn" value='N' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                      ����
                      <input type='radio' name="prv_dlv_yn" value='Y' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
        	 		�ִ�
        		    </td>
                    <td width="10%" class=title style="font-size : 7pt;">�����Ⱓ���Կ���</td>
                    <td>&nbsp; &nbsp;<%if(fee.getPrv_dlv_yn().equals("Y") && fee.getPrv_mon_yn().equals("")) fee.setPrv_mon_yn("0"); %>
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
    <tr id=tr_tae2 style='display:<%if(fee.getPrv_dlv_yn().equals("Y")){%>""<%}else{%>none<%}%>'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>������ȣ</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='tae_car_no' size='12' class='text' <%if(!base.getRent_st().equals("3"))%>readonly<%%> value='<%=taecha.getCar_no()%>'>
                      &nbsp;<span class="b"><a href="javascript:car_search('taecha')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span> 
        			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
					  <input type='hidden' name='tae_s_cd'	 	 value='<%=taecha.getRent_s_cd()%>'>
        			</td>
                    <td width="10%" class='title'>����</td>
                    <td>&nbsp;
                      <input type="text" name="tae_car_nm" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getCar_nm()%>'></td>
                    <td class='title'>���ʵ����</td>
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
                </tr>
                <tr>
                    <td class=title>���뿩��</td>
                    <td colspan='3' >&nbsp;
                      <input type='text' name='tae_rent_fee' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����) 
        			  <input type='hidden' name='tae_rent_fee_s'	 value=''>
        			  <input type='hidden' name='tae_rent_fee_v'	 value=''>
        			  <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              		  <%}else{%>	
        			  <a href="javascript:EstiTaeSearch();"><img src=/acar/images/center/button_in_search.gif align="absmiddle" border="0" alt="���������������ȸ"></a>
        			  <%}%>								  					  
        			</td>
                    <td class=title>������</td>
                    <td>&nbsp;					  
                      <input type='text' name='tae_rent_inv' class='whitenum' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_inv())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����) 
					  <span class="b"><a href="javascript:estimate_taecha('account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
					  <%	if(!taecha.getRent_inv().equals("0")){
					  		ContCarBean t_fee_add = a_db.getContFeeEtcAdd(rent_mng_id, rent_l_cd, "t");
					  		if(!t_fee_add.getBc_est_id().equals("")){%>
					  <a href="javascript:TaechaEstiPrint('<%=t_fee_add.getBc_est_id()%>');"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
					  <%		}
					  	}%>					  
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
              <%} %>	  
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
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(taecha.getTae_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="tae_sac_id" value="<%=taecha.getTae_sac_id()%>">			
			<a href="javascript:User_search('tae_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
    			</td>
              </tr>
            </table>
        </td>
    </tr>    
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('14')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������-�������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_bus style="display:''"> 		
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width="3%" rowspan="6" class='title'>��<br>
					��</td>
					<td class='title'>��������</td>
					<td colspan='5'>&nbsp;
					<input type='radio' name="pur_bus_st" value='4' checked>
					������Ʈ
					</td>		
				</tr>
				<tr id="dlv_con_commi_yn_tr">
					<td class='title'>��������� ���޿���</td>
					<td colspan='5'>&nbsp;
						<label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input3()">
						����</label>
						<label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input3()">
						����</label>
						<table>
              		   <tr>              		   
              		       <td>&nbsp;
              		           <select name='dir_pur_commi_yn'>
                          <option  value="">����</option>
                          <option value="Y" <%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>selected<%}%>>Ư�����(�����̰�����)</option>
                          <option value="N" <%if(cont_etc.getDir_pur_commi_yn().equals("N")){%>selected<%}%>>Ư�����(�����̰��Ұ���)</option>
                          <option value="2" <%if(cont_etc.getDir_pur_commi_yn().equals("2")){%>selected<%}%>>��ü���븮�����</option>
                        </select>                        
              		       </td> 
              		   </tr>
              		</table>
					</td>
				</tr>
				<tr>
					<td width="10%" class='title'>�������</td>
					<td width="20%" >&nbsp;
						<input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
						<input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>                      
					</td>
                    <td width="10%" class='title'>��ȣ/�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>
                      <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'></td>
                    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp1.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>                      
                    </td>
                </tr>
                <tr>
                    <td class='title'>�ҵ汸��</td>
                    <td >&nbsp;
                      <input type='text' name='cust_st' size='15' value='<%=emp1.getCust_st()%>' class='whitetext' readonly></td>
                    <td class='title'>�ִ��������</td>
                    <td>&nbsp;
                      <input type='text' name="v_comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum' readonly>
        			  % 
        			</td>
                    <td class='title'>�����������</td>
                    <td>&nbsp;
                      <input type='text' name="v_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='num' onBlur='javascript:setCommi()'>
        		      % 
        			  <input type='text' name="commi" size='10' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
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
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(emp1.getCh_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ch_sac_id" value="<%=emp1.getCh_sac_id()%>">			
			<a href="javascript:User_search('ch_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
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
                      <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='text'>
        			</td>
                    <td class='title'>�����ָ�</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='text'>
        			</td>
                </tr>		  		  
            </table>
        </td>
    </tr>	
	<tr>
	    <td class=h></td>
	</tr>    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>�������-�����<%if(!cop_bean.getRent_l_cd().equals("")){%>&nbsp;<font color=red>(������� <%=cop_bean.getCom_con_no()%>)</font><%}%><%}else if(base.getCar_gu().equals("2")){%>�߰�������ó<%}%></span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_dlv style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                    <td width="3%" rowspan="4" class='title'>��<br>
                      ��</td>			  
                <td class='title'>�����</td>
                <td>&nbsp;
                    <label><input type='radio' name="one_self" value='Y' <%if(pur.getOne_self().equals("Y")){%>checked<%}%>>
        				��ü���</label>
					<label><input type='radio' name="one_self" value='N' <%if(pur.getOne_self().equals("N")){%>checked<%}%>>
        				����������</label>           
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
                    <td width="10%" class='title'>�����</td>
                    <td width="20%" >&nbsp;
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
        			  <%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>  
                      <span class="b"><a href="javascript:search_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href="javascript:cancel_emp('DLV')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
        			  <%}%>
                      <input type='checkbox' name="emp_chk" onClick="javascript:set_emp_sam()"><font size='1'>��</font></td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%>
                      <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
        			</td>
        	    <td width="10%" class='title'>����ó</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp2.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>                      
                    </td>		
                </tr>
              <tr>
                <td class='title'>����</td>
                <td colspan="5">&nbsp;
                	�ݾ� : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��	
                     &nbsp;
                     ���޼��� :
                     <select name="trf_st0" class='default'>
                        <option value="">==����==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>ī��</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>����</option>
        			  </select> 
                     &nbsp;
                    ������ :
					<select name='con_bank'>
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
				  	<select name="acc_st0" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>�������</option>
        			  </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					������ : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
        			&nbsp;
        			���޿�û�� :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>															
              </tr>
              <%if(!base.getCar_gu().equals("2")){%>    	
              <tr>				
                <td class='title'>�ӽÿ��ຸ���</td>
                <td colspan='5'>&nbsp;
                  �ݾ� : 
				     <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>��	
                     &nbsp;
                     ���޼��� :
                     <select name="trf_st5" class='default'>
                        <option value="">==����==</option>
        				<option value="2" <%if(pur.getTrf_st5().equals("2")) out.println("selected");%>>����ī��</option>
        				<option value="3" <%if(pur.getTrf_st5().equals("3")) out.println("selected");%>>�ĺ�ī��</option>
        				<option value="1" <%if(pur.getTrf_st5().equals("1")) out.println("selected");%>>����</option>
        			  </select> 
                     &nbsp;
                    ������ :
					<select name='card_kind5'>
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
				  	<select name="acc_st5" class='default'>
                        <option value="">==����==</option>
        				<option value="1" <%if(pur.getAcc_st5().equals("1")) out.println("selected");%>>��������</option>
        				<option value="2" <%if(pur.getAcc_st5().equals("2")) out.println("selected");%>>�������</option>
        			  </select>
				  	&nbsp;
					���¹�ȣ : 
        			<input type='text' name='cardno5' value='<%=pur.getCardno5()%>' size='20' class='text'>
					&nbsp;
					������ : 
        			<input type='text' name='trf_cont5' value='<%=pur.getTrf_cont5()%>' size='20' class='text'>
        			&nbsp;
        			���޿�û�� :
        			<input type='text' name='trf_est_dt5' value='<%= AddUtil.ChangeDate2(pur.getTrf_est_dt5())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
				    <!--<input type="button" class="button" id="b_tmp_ins_amt" value='�����ػ� ����� ����' onclick="javascript:OpenImg('/acar/images/center/tmp_ins_amts.jpg');">-->
				    <%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>  
                		<%if(pur.getTrf_amt5() > 0 && !pur.getTrf_amt_pay_req().equals("")){%>
                		&nbsp;�۱ݿ�û(<%=pur.getTrf_amt_pay_req()%>)
                		<%}%>
                	<%}%>
    			</td>				
              </tr>   
              <%}%>   
              
              
            </table>
        </td>
    </tr>
	<tr>
	    <td>* ������ҿ� ������ݸ� ������ ���¸� �Է��Ͻʽÿ�. ���θ��� ���´� ����� �� �����ϴ�.(Ư������)</td>
	<tr>		
	<%if(!san_st.equals("��û")){%>	
	<%	if(!String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('15')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>
	<%	}else{%>
    <tr>
        <td>&nbsp;</td>
    </tr>		
	<%	}%>
	<%}%>
	<%if(base.getUse_yn().equals("")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������İ��� (���ü�� ���� �Է�)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=13%>�����Ȳ</td>
                    <td>&nbsp;<textarea name='bus_cau' rows='5' cols='100' maxlenght='500'><%=f_fee_etc.getBus_cau()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>				
  <%if(!san_st.equals("��û")){%>  
	<tr>
	    <td align="right"><%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('16')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<%}%>	
	<%}%>
			    
	<%	int scan_num = 0;
		String scan_mm = "";
		int scan_cnt = 0;%>
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
			String content_seq  = rent_mng_id+""+rent_l_cd; 
			
			Vector attach_vt = new Vector();
			int attach_vt_size = 0;       
			        		
        	%>
				
		<!--������-->	
				
				
		<%	if(ck_acar_id.equals(base.getBus_id())){ %>
        	<%		if(AddUtil.parseInt(base.getRent_dt()) > 20151201){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">�ڵ����뿩�̿��༭(�ű�,����,����)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=1&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=1&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;<a href='https://fms3.amazoncar.co.kr/data/doc/privacy_agree.pdf' target="_blank"><img src=/acar/images/center/button_in_sj.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">��������</td>		  
                  <td align="center">
                      <%if(AddUtil.parseInt(base.getReg_dt()) >= 20200303 && user_id.equals("000284")){%>
                         		<a href="javascript:go_edoc2('lc_rent_link','1','1','');" title='���ڰ�༭ ����'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                      <%}%>    
                  </td>		  
                </tr>	        	
        	<%		}%>
        	<%	}%>
        	

        	<%		if(now_stat.equals("���°�") && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > 20180801 ){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">�ڵ����뿩�̿��༭(���°�)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=cont_etc.getSuc_rent_st()%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=cont_etc.getSuc_rent_st()%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">��������</td>		  
                  <td align="center">  
                      <%if(now_stat.equals("���°�") && AddUtil.parseInt(cont_etc.getRent_suc_dt()) >= 20200303 && user_id.equals("000284")){%>
	                       		<a href="javascript:go_edoc2('lc_rent_link','2','<%=cont_etc.getSuc_rent_st()%>','');" title='���ڰ�༭ ����'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                      <%}%>                                                                               
                  </td>		  
                </tr>	      
                
		<!--�뿩�����İ�༭(��)-jpg����-->				
                <% 	scan_num++; 
                	file_rent_st = cont_etc.getSuc_rent_st();
                	file_st = "17";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�뿩�����İ�༭(��)-jpg���� : ���°�</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�뿩�����İ�༭(��)-jpg���� : ���°�</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
                
		<!--�뿩�����İ�༭(��)-jpg����-->				
                <% 	scan_num++; 
                	file_rent_st = cont_etc.getSuc_rent_st();
                	file_st = "18";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�뿩�����İ�༭(��)-jpg���� : ���°�</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�뿩�����İ�༭(��)-jpg���� : ���°�</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>    
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  
                
		<!--����(�ſ�)���� �������̿롤��������ȸ���Ǽ�-->				
                <% 	scan_num++; 
                	file_rent_st = cont_etc.getSuc_rent_st();
                	file_st = "37";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    <%
					if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){//���� ��ǥ�ڿ�������� ����
					}else{
						scan_cnt++;
						out.println("<font color=red>����</font>");
					}
				
                    %>
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>    
                <input type='hidden' name="h_file_st" value="<%=file_st%>">          
                
		<!--����(�ſ�)���� �������̿롤��������ȸ���Ǽ�(����������) - ����/���λ����-->
		<%if(!client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>						
                <% 	scan_num++; 
                	file_rent_st = cont_etc.getSuc_rent_st();
                	file_st = "51";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    <%
						scan_cnt++;
						out.println("<font color=red>����</font>");
                    %>
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>    
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                           
        <%	}%>                                	
                	
		<!--CMS���Ǽ�jpg-->			
                <% 	scan_num++; 
                	file_rent_st = cont_etc.getSuc_rent_st();
                	file_st = "38";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
<%				if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("") && !cms_scan_yn.equals("Y")){ //�ڵ���ü
						scan_cnt++;
						out.println("<font color=red>����</font>");
						if(!cms_scan_yn.equals("Y")){ out.println("<font color=red>(�̹��������� �ƴϰų� 300KB �ʰ��Դϴ�.)</font>"); }
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
			<%	if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("")){ //�ڵ���ü
						scan_cnt++;
						out.println("<font color=red>����</font>");
					}
				
			%>                      	
                    	</td>
                    <td align="center"></td>
                </tr>      

                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                    
                                  	
        	<%		}else{%>        	        	
        	
        					

		<!--���ʰ�༭(pdf)-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "1";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�ű� ��༭</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">�ű� ��༭</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
                
		<!--�뿩�����İ�༭(��)-jpg����-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "17";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
                
		<!--�뿩�����İ�༭(��)-jpg����-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "18";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>    
                <input type='hidden' name="h_file_st" value="<%=file_st%>">            
                
        	        	
                
		<!--����(�ſ�)���� �������̿롤��������ȸ���Ǽ�-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "37";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
                    <td align="center"><a href="'https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    <%
				//20140801���� �ʼ�
				if(AddUtil.parseInt(base.getRent_dt()) > 20140731 && fee_size == 1){
					if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){//���� ��ǥ�ڿ�������� ����
					}else{
						scan_cnt++;
						out.println("<font color=red>����</font>");
					}
				}		                    
                    %>
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>    
                <input type='hidden' name="h_file_st" value="<%=file_st%>">               
                                	
		<!--����(�ſ�)���� �������̿롤��������ȸ���Ǽ�(����������)-->	
		<%if(!client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>					
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "51";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
                    <td align="center"><a href="'https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">����(�ſ�)���� �������̿롤��������ȸ���Ǽ�(����������)</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    <%
				//20210601���� �ʼ�
				if(AddUtil.parseInt(base.getRent_dt()) >= 20210601 && fee_size == 1){
						scan_cnt++;
						out.println("<font color=red>����</font>");
				}		                    
                    %>
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>    
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                                         	
                	
		<%	}%>  
		
		
		<!--CMS���Ǽ�jpg-->
		
		 			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "38";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
				if(AddUtil.parseInt(base.getRent_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("") && !cms_scan_yn.equals("Y")){ //�ڵ���ü
						scan_cnt++;
						out.println("<font color=red>����</font>");
						if(!cms_scan_yn.equals("Y")){ out.println("<font color=red>(�̹��������� �ƴϰų� 300KB �ʰ��Դϴ�.)</font>"); }
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
			<%	//20170801 �ʼ�
				if(AddUtil.parseInt(base.getRent_dt()) > 20170731 && fee_size == 1){
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
                <input type='hidden' name="h_file_st" value="<%=file_st%>">         
               
        	<%		}%>                 

		<%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
		
		<!--��������������Ư�డ�Կ�û��-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "40";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "40", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   				
			
		<%}%>	
		         
		                                				
				       		
       		<tr>
  		    <td class=line2 colspan="6"></td>
		</tr>
			
				
		<%if(!client.getClient_st().equals("2")){%>		
		<!--����ڵ����jpg-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "2";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "2", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                       		
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
        	<%}%>
        		
        		
        	<%if(scan_chk.equals("Y") && client.getClient_st().equals("1")){%>

		<!--���ε��ε-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "3";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "3", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%// scan_cnt++;%><!--<font color=red>����</font>--></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>  
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  
		<!--�����ΰ�����-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "6";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "6", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%// scan_cnt++;%><!--<font color=red>����</font>--></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>  
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                                      	
                
        	<%}%>
        		
        		
        	<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2") && cont_etc.getClient_share_st().equals("2")){%>
        	<%}else{%>
        	<%	if(scan_chk.equals("Y")){%>	
        	
		<!--<%=scan_mm%>�ź���jpg-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "4";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "4", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  
		<!--<%=scan_mm%>�ֹε�ϵ-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "7";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "7", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%// scan_cnt++;%><!--<font color=red>����</font>--></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>  
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   
		<!--<%=scan_mm%>�ΰ�����-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "8";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "8", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%// scan_cnt++;%><!--<font color=red>����</font>--></td>
                    <td align="center"></td>
                </tr>      
                <%	}%> 
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                                              		
                        		
        	<%	}%>
        	<%}%>
        		
        		

                <%//���뺸���� ���񼭷�-----------------------------------
        	  if(cont_etc.getGuar_st().equals("1")){
        	%>	        				
		<!--���뺸����-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "14";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "14", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>   
                <input type='hidden' name="h_file_st" value="<%=file_st%>">       
		<!--���뺸���� ����ڵ����/�ź���-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "11";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "11", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���뺸���� ����ڵ����/�ź���</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���뺸���� ����ڵ����/�ź���</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>  
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                         		
		<!--���뺸���� ���ε��ε/�ֹε�ϵ-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "12";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "12", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���뺸���� ���ε��ε/�ֹε�ϵ</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">���뺸���� ���ε��ε/�ֹε�ϵ</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>        		
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
		<!--���뺸���� �����ΰ�����/�ΰ�����-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "13";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "13", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">

        	<%}%>	
        	
        	
		<!--����纻-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "9";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "9", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
			<%	//�ڵ���ü & �ű԰�� 
				if(fee.getFee_pay_st().equals("1") && base.getRent_st().equals("1")){
					scan_cnt++;
					out.println("<font color=red>����</font>");
				}	
			%>                    
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>   
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  
                
		<%if(ej_bean.getJg_g_7().equals("3")){%>                
		<!--������Ȯ�༭-->			
                <% 	scan_num++; 
                		file_rent_st = "1";
                		file_st = "44";     
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
                	file_rent_st = "1";
                	file_st = "19";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%> 
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                      	
                
		<!--����û�༭-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "36";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  
                
		<!--���谡������-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "39";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                  
                                
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
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
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
                <% 	file_rent_st = "1";
                	file_st = "10";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "10", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                <% 	file_rent_st = "1";
                	file_st = "15";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "15", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                <% 	file_rent_st = "1";
                	file_st = "5";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "5", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
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
                <input type='hidden' name="h_file_st" value="">                      	


    
             </table>
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
	
	
    <tr>
	    <td align='center'>	   
		 
	    	<%	String sanction_date = base.getSanction_date();
	  		if(sanction_date.length() > 0) sanction_date = sanction_date.substring(0,8);%>
	  	
		
        	<%	if(AddUtil.parseInt(base.getRent_dt()) > AddUtil.parseInt(sanction_date)){%>
        	<%		if(!san_st.equals("��û")){%>
        	&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:sanction_req();" title='������ ��û�ϱ�'><img src=/acar/images/center/button_gjyc.gif align=absmiddle border=0></a>
	    	<%		}%>
	    	<!--    ������ ��û -->        	
            <br><br>��������û���� : <input type='text' name="sanction_req_delete_cont" value='' size="100" class='text'>&nbsp;<a href="javascript:sanction_req_delete();" title='������ ��û�ϱ�'>[��������û �޽����߼�]</a><br><br>        
	    	<%	}%>
		

	    	<%	if(base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id)){%>
	    	<%		if(!san_st.equals("��û")){%>
	    	<%			if(!String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>  
	    	&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:update(99);" title='��ü �����ϱ�'><img src=/acar/images/center/button_all_modify.gif align=absmiddle border=0></a>
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
	  	<%if((base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("1")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("1"))){%>	  
	    <a href="lc_reg_step2.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp; 	    
        <%}%>	
	  	<%if((base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("2")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("2"))){%>	  
	    <a href="lc_reg_step3.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_3step.gif align=absmiddle border=0></a>&nbsp;	  
        <%}%>	
	  	<%if((base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("3")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("2"))){%>	  
	    <a href="lc_reg_step4.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
        <%}%>	
    </tr>			
	    
</table>
  <input type='hidden' name="zip_cnt" 			value="<%=zip_cnt%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript">
<!--	
	//������ �ε� �� ��������� ���޿��� �ʱ�ȭ		2017. 12. 06
	document.addEventListener("DOMContentLoaded", function(){
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		if(dlv_con_commi_yn_val == "Y"){															// ��������� ���޿��� -> ���� ����
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// ����� -> ��ü��� ����
			$("input[name='one_self']:radio[value='N']").prop("disabled", true);		// ����� -> ���������� ��Ȳ��ȭ
		}else if(dlv_con_commi_yn_val == "N"){													// ��������� ���޿��� -> ���� �� ���
			$("input[name='one_self']:radio[value='N']").prop("disabled", false);	// ����� -> ���������� Ȱ��ȭ
			$("input[name='one_self']:radio[value='N']").prop("checked", true);	// ����� -> ���������� ����
		}
	});
	
	// ���������		2017. 12. 06
	var one_self_no = $("input[name='one_self']:radio[value='N']");		// ����� ����������
	$("input[name=dlv_con_commi_yn]").change(function(){
		if($(this).val() == "Y"){																			// �������п��� �����������, ������Ʈ ���� �� > ��������� ���޿��� ���� ���� ��
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// ����� ��ü��� ����
			one_self_no.prop("disabled", true);														// ����� ���������� ��Ȱ��ȭ
		}else{																										// �������п��� �����������, ������Ʈ ���� �� > ��������� ���޿��� ���� ���� ��
			one_self_no.prop("disabled", false);														// ����� ���������� Ȱ��ȭ
			one_self_no.prop("checked", true);														// ����� ���������� ����
		}
	});
	
	var fm = document.form1;
	
	if(fm.purc_gu.value == '' && fm.car_st.value == '3'){	fm.purc_gu[1].selected = true; 	}	
	if(fm.purc_gu.value == '' && fm.car_st.value == '1'){   fm.purc_gu[2].selected = true; 	}

	sum_car_c_amt();
	sum_car_f_amt();
	sum_pp_amt();	
	
	fm.scan_cnt.value = <%=scan_cnt%>;	
	
	cont_chk();
		
	function cont_chk(){
		var kkk1 = <%=user_id%>;
		if(kkk1 == "139"){
			// del
		}else if(<%=fee_etc.getReg_dt()%> >= 20100501 && toInt(fm.scan_cnt.value) > 0){
		
			fm.chk1.value = '* �̵�� ��ĵ�� <%=scan_cnt%>�� �ֽ��ϴ�. --> ���� ������ �������� �ʽ��ϴ�.';
			
			<%	if(client.getFirm_type().equals("7")){%>
			fm.chk1.value = '* �̵�� ��ĵ�� <%=scan_cnt%>�� �ֽ��ϴ�. --> ���� ������ �������� �ʽ��ϴ�. -> ������ü��ü�� ���� �ٸ� ������ ��ü�ؼ� ��ĵ����Ͻʽÿ�.';
			<%	}%>
			
			tr_chk1.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			
		}
		
		//������ �Է°� Ȯ��
		if(fm.client_st.value != '2' && fm.client_guar_st[1].checked == true &&  fm.guar_sac_id.value != ''){
			fm.sanc1.value = '* ��ǥ�̻纸�� ���� �����ڴ� <%=c_db.getNameById(cont_etc.getGuar_sac_id(),"USER")%> �Դϴ�.';
			tr_sanc1.style.display = '';					
		}		
		if(fm.car_ja.value != fm.imm_amt.value &&  fm.rea_appr_id.value != ''){
			fm.sanc2.value = '* ������å�� ���� �����ڴ� <%=c_db.getNameById(cont_etc.getRea_appr_id(),"USER")%> �Դϴ�.';
			tr_sanc2.style.display = '';					
		}
		if(fm.credit_sac_id.value != ''){
			fm.sanc3.value = '* ä��Ȯ�� �����ڴ� <%=c_db.getNameById(fee_etc.getCredit_sac_id(),"USER")%> �Դϴ�.';
			tr_sanc3.style.display = '';					
		}
		if(fm.def_st.value == 'Y' && fm.def_sac_id.value != ''){
			fm.sanc4.value = '* ��ġ���� �����ڴ� <%=c_db.getNameById(fee.getDef_sac_id(),"USER")%> �Դϴ�.';
			tr_sanc4.style.display = '';					
		}		
		if(fm.prv_dlv_yn[1].checked == true && fm.tae_sac_id.value != ''){
			fm.sanc5.value = '* ��������� �����ڴ� <%=c_db.getNameById(taecha.getTae_sac_id(),"USER")%> �Դϴ�.';
			tr_sanc5.style.display = '';							
		}
		if(toFloat(fm.comm_rt.value) != toFloat(fm.comm_rt.value) && fm.ch_sac_id.value != ''){
			fm.sanc6.value = '* ������� ������� �Ǵ� �����ڴ� <%=c_db.getNameById(emp1.getCh_sac_id(),"USER")%> �Դϴ�.';
			tr_sanc6.style.display = '';							
		}
																
		<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
		if(fm.driving_age.value=='1' && fm.age_scp.value!='1'){
			fm.sanc7.value = '* ���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
			tr_sanc7.style.display = '';											
		}
		if(fm.driving_age.value=='3' && fm.age_scp.value!='4'){
			fm.sanc7.value = '* ���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
			tr_sanc7.style.display = '';											
		}
		if(fm.driving_age.value=='0' && fm.age_scp.value!='2'){
			fm.sanc7.value = '* ���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
			tr_sanc7.style.display = '';											
		}
		if(fm.driving_age.value=='2' && fm.age_scp.value!='3'){
			fm.sanc7.value = '* ���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
			tr_sanc7.style.display = '';											
		}
		if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3'){
			fm.sanc8.value = '* ���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
			tr_sanc8.style.display = '';											
		}
		if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4'){
			fm.sanc8.value = '* ���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
			tr_sanc8.style.display = '';											
		}
		if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){
			fm.sanc9.value = '* ���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
			tr_sanc9.style.display = '';											
		}
		if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){
			fm.sanc9.value = '* ���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.';
			tr_sanc9.style.display = '';											
		}			
		<%}%>
	
		
		//�ʼ��̷� üũ
		if(fm.client_st.value == '1' && fm.client_guar_st[0].checked == false && fm.client_guar_st[1].checked == false){	
			fm.chk2.value = '* ��ǥ�̻纸�� ������ �����ϴ�.';
			tr_chk2.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		if(fm.client_st.value == '1' && fm.client_guar_st[1].checked == true && (fm.guar_con.value == '' || fm.guar_sac_id.value == '')){
			fm.chk2.value = '* ��ǥ�̻纸�� �������� �� �����ڰ� �����ϴ�.';
			tr_chk2.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}		
	
		if(fm.guar_st[0].checked == false && fm.guar_st[1].checked == false){	
			fm.chk3.value = '* ���뺸���� ������ �����ϴ�.';
			tr_chk3.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
					
		<%if(ej_bean.getJg_w().equals("1")){//������%>
			if(fm.car_ja.value != fm.imm_amt.value && (fm.ja_reason.value == '' || fm.rea_appr_id.value == '')){
					fm.chk6.value = '* ������å�� ������� �Ǵ� �����ڰ� �����ϴ�.';
					tr_chk6.style.display = '';					
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			<%if(fee_size ==1 && base.getCar_gu().equals("1")){%>
			if(toInt(parseDigit(fm.import_cash_back.value))+toInt(parseDigit(fm.dc_c_amt.value)) == 0){
				//fm.chk14.value = '* �������ε� ����D/C�� Cash Back�ݾ��� ��� �����ϴ�.';
				//tr_chk14.style.display = '';
				//fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			<%}%>
		<%}else{%>
			if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
				if(fm.car_ja.value != fm.imm_amt.value && (fm.ja_reason.value == '' || fm.rea_appr_id.value == '')){
					fm.chk6.value = '* ������å�� ������� �Ǵ� �����ڰ� �����ϴ�.';
					tr_chk6.style.display = '';					
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
			}			
		<%}%>			

		<%if(!ej_bean.getJg_w().equals("1") && !cm_bean.getJg_code().equals("2361") && !cm_bean.getJg_code().equals("2362") && !cm_bean.getJg_code().equals("2031111") && !cm_bean.getJg_code().equals("2031112") && !cm_bean.getJg_code().equals("5033111") && AddUtil.parseInt(cm_bean.getS_st()) < 600){ //!cm_bean.getJg_code().equals("9133") && !cm_bean.getJg_code().equals("9237")%>
		<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
		if(toInt(parseDigit(fm.tax_dc_amt.value)) == 0){
				fm.chk15.value = '* ģȯ���ε� ���Ҽ������ �ݾ��� ��� �����ϴ�.';
				tr_chk15.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}	
		<%	}%>	
		<%}%>	
			
		if(fm.credit_sac_id.value == ''){
			fm.chk9.value = '* ä��Ȯ�� �����ڰ� �����ϴ�.';
			tr_chk9.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
		if(fm.def_st.value == 'Y' && (fm.def_remark.value == '' || fm.def_sac_id.value == '')){
			fm.chk10.value = '* ��ġ���ΰ� ������ ��ġ���� �Ǵ� ��ġ �����ڰ�  �����ϴ�.';
			tr_chk10.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}		

		if(fm.prv_dlv_yn[1].checked == true && fm.tae_sac_id.value == ''){
			fm.chk12.value = '* ��������� �����ڰ� �����ϴ�.';
			tr_chk12.style.display = '';							
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		

		if(fm.dec_gr.value == ''){
			fm.chk5.value = '* �����ſ����� �����ϴ�.';
			tr_chk5.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
			
		if(fm.opt_chk[0].checked == false && fm.opt_chk[1].checked == false){
			fm.chk7.value = '* ���Կɼ� ������ �����ϴ�.';
			tr_chk7.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}			
		if(fm.opt_chk[1].checked == true && (fm.opt_per.value == '' || toInt(parseDigit(fm.opt_amt.value))==0)){
			fm.chk7.value = '* ���Կɼ��� �Ǵ� ���ԿɼǱݾ��� �����ϴ�.';
			tr_chk7.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}	
		if(toInt(fm.fee_amt.value)=='0' && toInt(fm.tot_pp_amt.value)=='0'){
			fm.chk17.value = '* �����ݰ� �뿩�� ������� �����ϴ�.';
			tr_chk17.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}		
		if(fm.fee_pay_st.value == '1'){
			if(fm.cms_bank_cd.value == '' || fm.cms_acc_no.value == '' || fm.cms_acc_no.value == '' || fm.cms_dep_nm.value == '' || fm.cms_dep_ssn.value == ''	){
				fm.chk8.value = '* �ڵ���ü�ε� ���������� �����ϴ�.';				
				tr_chk8.style.display = '';					
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
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
			
			}
		}
		
		if(fm.est_area.value == '' || fm.county.value == ''){
			fm.chk4.value = '* �����̿������� �����ϴ�.';
			tr_chk4.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
		if(toInt(parseDigit(fm.car_ja.value)) == 0){		
			fm.chk6.value = '* ������å���� �����ϴ�.';
			tr_chk6.style.display = '';		
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
				
		if(fm.cls_r_per.value == ''){
			fm.chk8.value = '* �ߵ������������� �����ϴ�.';
			tr_chk8.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}

		if(fm.rec_st.value == ''){
			fm.chk11.value = '* ���ݰ�꼭 û���� ���ɹ���� �����ϴ�.';
			tr_chk11.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
		
		<%if(!String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>  
			<%if(fee_size ==1 && base.getCar_gu().equals("1")){%>
			//����� ����� üũ
			if(fm.one_self[0].checked == false && fm.one_self[1].checked == false){
				fm.chk13.value = '* ����� ������� �����ϴ�.';
				tr_chk13.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			<%}%>
		<%}%>
			
			if(<%=client_tel_cnt%> < 2 ){
				fm.chk15.value = '* �� ����ó�� �ߺ����� �ʴ� ��ȣ�� 2�� �̻��̿��� �մϴ�.<%if(client.getClient_st().equals("1")){%>(���ΰ�:ȸ����ȭ,��ǥ���޴���,�����̿����޴���)<%}else if(client.getClient_st().equals("2")){%>(���ΰ�:���޴���,������ȭ,������ȭ)<%}else{%>(���λ����:ȸ����ȭ,��ǥ���޴���,������ȭ,�����̿����޴���)<%}%>';
				tr_chk15.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}			
			
			<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("N")){%>
      		<%	if(cont_etc.getCom_emp_sac_id().equals("")){%>
				fm.chk16.value = '* ���� ��������������Ư���� �̰����Դϴ�. ����ó���Ͻʽÿ�.';
				tr_chk16.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
    		<%	}else{%>
	    	<%		if(base.getOthers().equals("")){%>	
			fm.chk16.value = '* ���� ��������������Ư���� �̰����Դϴ�. �̰��Ի����� �������-��� �Է��Ͻʽÿ�.';
			tr_chk16.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;    	
  			<%		}%>
      		<%	}%>
      		<%}%>	
      		
      		<%if(!client.getClient_st().equals("1") && !client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("Y")){%>
      		<%	if(cont_etc.getCom_emp_sac_id().equals("")){%>
				fm.chk16.value = '* ���� ��������������Ư���� �����Դϴ�. ����ó���Ͻʽÿ�.';
				tr_chk16.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
    		<%	}else{%>
	    	<%		if(base.getOthers().equals("")){%>	
			fm.chk16.value = '* ���� ��������������Ư���� �����Դϴ�. ���Ի����� �������-��� �Է��Ͻʽÿ�.';
			tr_chk16.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;    	
  			<%		}%>
      		<%	}%>
      		<%}%>	      		

			<%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("")){%>
				fm.chk16.value = '* ���� ��������������Ư���� ���Կ��ΰ� �����ϴ�.';
				tr_chk16.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
      		<%}%>	
      

			
	}
 
	//��ü����
	function AllSelect(){
		var fm = document.form1;
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
	
	//�������ｺƼĿ �߱� ���� �� ��������� ����� �ڵ� ���� / 2017. 10. 30
	$("#eco_e_tag").change(function() {
		console.log("cccc");
		if($("#eco_e_tag").val() == "1"){
			if(<%=base.getCar_mng_id().equals("")%>){
				$("#car_ext").val("1").prop("selected", true);	
			}
		}
	});
//-->
</script>
</body>
</html>
