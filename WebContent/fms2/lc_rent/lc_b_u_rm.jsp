<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.con_ins.*, acar.ext.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db"     class="acar.fee.AddFeeDatabase"	       scope="page"/>
<jsp:useBean id="e_bean"    class="acar.estimate_mng.EstimateBean"     scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="em_bean"   class="acar.estimate_mng.EstiCommVarBean"  scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="shDb"      class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean"               scope="page"/>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase"      scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean"             scope="page"/>
<jsp:useBean id="ac_db"     class="acar.cost.CostDatabase"             scope="page"/>
<jsp:useBean id="ae_db"     class="acar.ext.AddExtDatabase"            scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")	==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")	==null?"" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")	==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st	 	= request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	EstiDatabase edb 	= EstiDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
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
	
	//����Ʈ����
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	
	
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
	
	
	
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
	//���ǿ���
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //����� ����Ʈ
	int user_size2 = users2.size();
	
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//�ܰ�����NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String a_a = "2";
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";
	
	//���뺯��
	em_bean = edb.getEstiCommVarCase(a_a, "");
	
	
	
	
	
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt());//������� ����Ⱓ(����)
	
	
	
	//��ĵ���� üũ����
	String scan_chk = "Y";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&from_page="+from_page;
	
	String valus_t = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st=t&from_page="+from_page;
	
	int fee_opt_amt = 0;
	
	int zip_cnt = 0;
	
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(max_fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(max_fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
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
	

	
	//����Ʈ
	function list(){
		var fm = document.form1;	
		
		if(fm.from_page.value == '')						fm.action = 'lc_rm_frame.jsp';
		else if(fm.from_page.value == '/fms2/lc_rent/lc_bc_frame.jsp')		fm.action = '/fms2/lc_rent/lc_bc_frame.jsp';		
		else if(fm.from_page.value == '/fms2/mis/sale_cost_mng_frame.jsp')	fm.action = '/fms2/mis/sale_cost_mng_frame.jsp';				
		else									fm.action = fm.from_page.value;
		
		fm.target = 'd_content';
		fm.submit();
	}	

	//2�ܰ� -----------------------------------------------------------
	
	//�� ��ȸ
	function search_client()
	{
		window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp", "CLIENT", "left=10, top=10, width=1100, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//�� ����
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���õ� ���� �����ϴ�."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ��ȸ
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=500, scrollbars=yes, status=yes, resizable=yes");
	}			
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("���õ� ������ �����ϴ�."); return;}
		window.open("/fms2/client/client_site_i_p.jsp?cmd=view&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			


	//������ ��ȸ
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_mgr.jsp?car_st=<%=base.getCar_st()%>&idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
	
	//�ּ� ��ȸ
	function search_post(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_post.jsp?idx="+idx+"&client_id="+fm.client_id.value, "POST", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//���뺸����
	function guar_display(){
		var fm = document.form1;
		var size = toInt(fm.gur_size.value);
		if(fm.guar_st[0].checked == true){ 				//����
			tr_guar2.style.display	= '';
		}else{								//����
			tr_guar2.style.display	= 'none';
		}
	}	
	
	//���� üũ
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');
		}
	}
	


	//4�ܰ� -----------------------------------------------------------
		
	//�ڵ���������� ����
	function view_car()
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	//�������� ����
	function view_car_nm(car_id, car_seq){
		window.open("/acar/car_mst/car_mst_u.jsp?from_page=lc_rent&car_id="+car_id+"&car_seq="+car_seq, "VIEW_CAR_NM", "left=20, top=20, width=875, height=650, scrollbars=yes");		
	}

	//�ش� ���� �������� �⺻��� ����
	function open_car_b(car_id, car_seq, car_name){
		window.open('view_car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=100, top=100, width=450, height=600, scrollbars=yes"); 
	}	


	
	
	//�뿩�Ⱓ ����
	function set_cont_date(obj){
		var fm = document.form1;
		
		
		if(obj == fm.con_mon || obj == fm.con_day){
		
			fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value);
					
			fm.v_con_mon.value = fm.con_mon.value;
			fm.v_con_day.value = fm.con_day.value;					
			
			set_sum_amt();	
		}
	
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
		
		var car_price 	= toInt(parseDigit(fm.sh_amt.value));
		
		//������---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value = fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value = replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			}

		//����뿩��---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//����뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();			
		}else if(obj==fm.inv_v_amt){ 	//����뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.inv_amt){ 	//����뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			dc_fee_amt();			
		//D/C---------------------------------------------------------------------------------
		}else if(obj==fm.dc_s_amt){ 	//D/C ���ް�
			obj.value = parseDecimal(obj.value);
			fm.dc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) * 0.1 );
			fm.dc_amt.value	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));			
			dc_fee_amt();			
		}else if(obj==fm.dc_v_amt){ 	//D/C �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.dc_amt.value	= parseDecimal(toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.dc_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.dc_amt){ 	//D/C �հ�
			obj.value = parseDecimal(obj.value);
			fm.dc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_amt.value))));
			fm.dc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)));			
			dc_fee_amt();			
		//������̼�---------------------------------------------------------------------------------
		}else if(obj==fm.navi_s_amt){ 	//������̼� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) * 0.1 );
			fm.navi_amt.value	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));			
		}else if(obj==fm.navi_v_amt){ 	//������̼� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.navi_amt.value	= parseDecimal(toInt(parseDigit(fm.navi_s_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value)));			
		}else if(obj==fm.navi_amt){ 	//������̼� �հ�
			obj.value = parseDecimal(obj.value);
			fm.navi_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.navi_amt.value))));
			fm.navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.navi_amt.value)) - toInt(parseDigit(fm.navi_s_amt.value)));			
		//��Ÿ---------------------------------------------------------------------------------
		}else if(obj==fm.etc_s_amt){ 	//��Ÿ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) * 0.1 );
			fm.etc_amt.value	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));			
		}else if(obj==fm.etc_v_amt){ 	//��Ÿ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.etc_amt.value	= parseDecimal(toInt(parseDigit(fm.etc_s_amt.value)) + toInt(parseDigit(fm.etc_v_amt.value)));			
		}else if(obj==fm.etc_amt){ 	//��Ÿ �հ�
			obj.value = parseDecimal(obj.value);
			fm.etc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.etc_amt.value))));
			fm.etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_amt.value)) - toInt(parseDigit(fm.etc_s_amt.value)));			
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.cons1_s_amt){ 	//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.cons1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) * 0.1 );
			fm.cons1_amt.value	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));			
		}else if(obj==fm.cons1_v_amt){ 	//������ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.cons1_amt.value	= parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));			
		}else if(obj==fm.cons1_amt){ 	//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.cons1_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.cons1_amt.value))));
			fm.cons1_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons1_amt.value)) - toInt(parseDigit(fm.cons1_s_amt.value)));			
		//������---------------------------------------------------------------------------------
		}else if(obj==fm.cons2_s_amt){ 	//������ ���ް�
			obj.value = parseDecimal(obj.value);
			fm.cons2_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) * 0.1 );
			fm.cons2_amt.value	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));			
		}else if(obj==fm.cons2_v_amt){ 	//������ �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.cons2_amt.value	= parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));			
		}else if(obj==fm.cons2_amt){ 	//������ �հ�
			obj.value = parseDecimal(obj.value);
			fm.cons2_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.cons2_amt.value))));
			fm.cons2_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cons2_amt.value)) - toInt(parseDigit(fm.cons2_s_amt.value)));			
		}
		
		set_sum_amt();	
		
	}	
	
	//�հ���
	function set_sum_amt(){
		var fm = document.form1;
				

				
		//���뿩�� �հ�
		fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.navi_s_amt.value))+ toInt(parseDigit(fm.etc_s_amt.value)));
		fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) - toInt(parseDigit(fm.dc_v_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value))+ toInt(parseDigit(fm.etc_v_amt.value)));
		fm.fee_amt.value   = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)) );
		//�뿩�� �Ѿ�
		fm.t_fee_s_amt.value = parseDecimal((toInt(parseDigit(fm.fee_s_amt.value))*toInt(fm.con_mon.value)) + (toInt(parseDigit(fm.fee_s_amt.value))/30*toInt(fm.con_day.value)));
		fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) * 0.1 );
		fm.t_fee_amt.value   = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) + toInt(parseDigit(fm.t_fee_v_amt.value)) );
		//�հ�
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)));
		fm.rent_tot_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		fm.rent_tot_amt.value   = parseDecimal(toInt(parseDigit(fm.rent_tot_s_amt.value)) + toInt(parseDigit(fm.rent_tot_v_amt.value)) );
		
		f_paid_way_display();
	}		
	
	//�뿩�� DC�� ���
	function dc_fee_amt(){
		var fm = document.form1;
		
		var inv_amt	= toInt(parseDigit(fm.inv_s_amt.value))+toInt(parseDigit(fm.inv_v_amt.value));		//����뿩��
		var dc_amt	= toInt(parseDigit(fm.dc_s_amt.value))+toInt(parseDigit(fm.dc_v_amt.value));		//DC�ݾ�
		var dc_ra;
						
		if(inv_amt > 0 && dc_amt > 0){			
			dc_ra = replaceFloatRound(dc_amt / inv_amt );
			fm.dc_ra.value = dc_ra;
		}
	}		
		
	//������̼�����
	function obj_display(st, value){
		var fm = document.form1;	
		
		if(st == 'navi'){
			if(value == 'Y'){
				fm.navi_s_amt.value 	= '25,000';
				fm.navi_v_amt.value 	= '2,500';
				fm.navi_amt.value	= '27,500';		
			}else if(value == 'N'){
				fm.navi_s_amt.value 	= '0';
				fm.navi_v_amt.value 	= '0';
				fm.navi_amt.value	= '0';		
			}	
		}else if(st == 'cons1'){
			if(value == 'Y'){
				fm.cons1_s_amt.value 	= '20,000';
				fm.cons1_v_amt.value 	= '2,000';
				fm.cons1_amt.value	= '22,000';		
			}else if(value == 'N'){
				fm.cons1_s_amt.value 	= '0';
				fm.cons1_v_amt.value 	= '0';
				fm.cons1_amt.value	= '0';		
			}
		}else if(st == 'cons2'){
			if(value == 'Y'){
				fm.cons2_s_amt.value 	= '20,000';
				fm.cons2_v_amt.value 	= '2,000';
				fm.cons2_amt.value	= '22,000';		
			}else if(value == 'N'){
				fm.cons2_s_amt.value 	= '0';
				fm.cons2_v_amt.value 	= '0';
				fm.cons2_amt.value	= '0';		
			}				
		}
		set_sum_amt();			
	}	
	
	//���ʰ������ ����
	function f_paid_way_display(){
		var fm = document.form1;
		
		//1����ġ
		if(fm.f_paid_way.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		//�Ѿ�	
		}else if(fm.f_paid_way.value == '2'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_amt.value)) + toInt(parseDigit(fm.cons1_amt.value)) );
		}
		
		//������ �������Կ���
		if(fm.f_paid_way2.value == '1'){
			fm.f_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.f_rent_tot_amt.value)) + toInt(parseDigit(fm.cons2_amt.value)));
		}					
	}	

	
	

	//����
	function update(idx){
		var fm = document.form1;
		
		if(idx == 0 || idx == 99){

			if(fm.bus_id2.value == '')			{ alert('��������ڸ� Ȯ���Ͻʽÿ�.'); 				return;}
			if(fm.bus_id2.value.substring(0,1) == '1')	{ alert('��������ڰ� �μ��� ���õǾ����ϴ�. Ȯ�����ּ���.'); 	return;}				
			if(fm.est_area.value == '')			{ alert('�����̿������� Ȯ���Ͻʽÿ�.'); 			return;}
				
		}else if(idx == 1 || idx == 99){
		
			if(fm.client_id.value == '')	{ alert('���� �����Ͻʽÿ�.'); 		return;}
									
			
		}else if(idx == 2 || idx == 99){
					
			if(fm.guar_st[0].checked == true){
				if(fm.gur_nm[0].value == '')	{ alert('���뺸���� ������ �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_ssn[0].value == '')	{ alert('���뺸���� ��������� �Է��Ͻʽÿ�.'); 		return;}
				if(fm.t_addr[2].value == '')	{ alert('���뺸���� �ּҸ� �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_tel[0].value == '')	{ alert('���뺸���� ����ó�� �Է��Ͻʽÿ�.'); 			return;}
				if(fm.gur_rel[0].value == '')	{ alert('���뺸���� ���踦 �Է��Ͻʽÿ�.'); 			return;}												
			}	
			
		}else if(idx == 10 || idx == 99){
		
			if(fm.driving_age.value == '')				{ alert('�������-�����ڿ����� �Է��Ͻʽÿ�.'); 		fm.driving_age.focus(); 	return; }
			//if(fm.com_emp_yn.value == '')				{ alert('�������-��������������Ư�� ���Կ��θ� �Է��Ͻʽÿ�.');	fm.com_emp_yn.focus(); 		return; }
			if(fm.gcp_kd.value == '')				{ alert('�������-�빰��� ���Աݾ��� �Է��Ͻʽÿ�.'); 		fm.gcp_kd.focus(); 		return; }
			if(fm.bacdt_kd.value == '')				{ alert('�������-�ڱ��ü��� ���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.bacdt_kd.focus(); 		return; }
			if(fm.canoisr_yn.value == '')				{ alert('�������-������������ ���Կ��θ� �Է��Ͻʽÿ�.'); 	fm.canoisr_yn.focus(); 		return; }
			if(fm.cacdt_yn.value == '')				{ alert('�������-�ڱ��������� ���Կ��θ� �Է��Ͻʽÿ�.'); 	fm.cacdt_yn.focus(); 		return; }
			if(fm.eme_yn.value == '')				{ alert('�������-����⵿ ���Կ��θ� �Է��Ͻʽÿ�.'); 		fm.eme_yn.focus(); 		return; }
							
			<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
			if(fm.driving_age.value=='1' && fm.age_scp.value!='1'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';}
			if(fm.driving_age.value=='3' && fm.age_scp.value!='4'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}
			if(fm.driving_age.value=='0' && fm.age_scp.value!='2'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}
			if(fm.driving_age.value=='2' && fm.age_scp.value!='3'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}
			if(fm.driving_age.value=='5' && fm.age_scp.value!='5'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}			
			if(fm.driving_age.value=='6' && fm.age_scp.value!='6'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}			
			if(fm.driving_age.value=='7' && fm.age_scp.value!='7'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}			
			if(fm.driving_age.value=='8' && fm.age_scp.value!='8'){		alert('���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk1.value =	'���� ���ɹ����� ���� ���԰� ������ Ʋ���ϴ�.';		}												
				
			if(fm.gcp_kd.value=='3' && fm.vins_gcp_kd.value!='6'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.';		}
			if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.';		}				
			if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.';		}
			if(fm.gcp_kd.value=='4' && fm.vins_gcp_kd.value!='7'){		alert('���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk2.value =	'���� �빰������ ���� ���԰� ������ Ʋ���ϴ�.';		}				
				
			if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk3.value =	'���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.';	}
			if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk3.value =	'���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.';	}
			if(fm.bacdt_kd.value=='9' && fm.vins_bacdt_kd.value!='9'){	alert('���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk3.value =	'���� �ڱ��ü��� ���� ���԰� ������ Ʋ���ϴ�.';	}
				
			if(fm.con_f_nm.value=='1' && fm.insur_per.value!='1'){		alert('���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk4.value =	'���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.';		}
			if(fm.con_f_nm.value=='2' && fm.insur_per.value!='2'){		alert('���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.Ȯ���Ͻʽÿ�.');		fm.ins_chk4.value =	'���� �Ǻ����ڰ� ���� ���԰� ������ Ʋ���ϴ�.';		}
			<%}%>		
					
			var car_ja 	= toInt(parseDigit(fm.car_ja.value));
			if(car_ja == 0)							{ alert('�������-������å���� �Է��Ͻʽÿ�.'); 			fm.car_ja.focus(); 			return; }
			<%if(car.getCar_origin().equals("2")){//������%>
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
		
		}else if(idx == 12 || idx == 99){
		
			if(fm.con_mon.value == '')				{ alert('�뿩���-�̿�Ⱓ�� �Է��Ͻʽÿ�.'); 				fm.con_mon.focus(); 		return; }
											
			<%if(String.valueOf(begin.get("CLS_ST")).equals("���°�") || String.valueOf(begin.get("CLS_ST")).equals("��������")){%>
			<%}else{%>
			
			var fee_amt 	= toInt(parseDigit(fm.fee_amt.value));
			var inv_amt 	= toInt(parseDigit(fm.inv_amt.value));		
			var agree_dist 	= toInt(parseDigit(fm.agree_dist.value));
			var over_run_amt= toInt(parseDigit(fm.over_run_amt.value));		
		
			if(inv_amt == 0)	{ alert('�뿩���-����뿩�Ḧ �Է��Ͻʽÿ�.'); 	fm.inv_amt.focus(); 		return; }
			if(fee_amt == 0)	{ alert('�뿩���-���뿩�Ḧ Ȯ���Ͻʽÿ�.'); 		fm.inv_amt.focus(); 		return; }
			if(agree_dist == 0)	{ alert('�뿩���-��������Ÿ��� �Է��Ͻʽÿ�.'); 	fm.agree_dist.focus(); 		return; }
			if(over_run_amt == 0)	{ alert('�뿩���-�ʰ�����δ���� �Է��Ͻʽÿ�.'); 	fm.over_run_amt.focus(); 	return; }
		
			if(toInt(parseDigit(fm.f_rent_tot_amt.value)) == '0')	{ alert('�뿩���-���ʰ����ݾ��� �Է��Ͻʽÿ�.'); 		fm.f_rent_tot_amt.focus(); 	return; }			
		
							
			if(fm.fee_pay_tm.value == '')			{ alert('�뿩���-����Ƚ���� �Է��Ͻʽÿ�.'); 				fm.fee_pay_tm.focus(); 		return; }
			if(fm.fee_sh.value == '')			{ alert('�뿩���-���ݱ��и� �Է��Ͻʽÿ�.'); 				fm.fee_sh.focus(); 			return; }
			if(fm.fee_pay_st.value == '')			{ alert('�뿩���-���ι���� �Է��Ͻʽÿ�.'); 				fm.fee_pay_st.focus(); 		return; }
			if(fm.fee_pay_st.value != '1' && fm.cms_not_cau.value == ''){ alert('���ι���� �ڵ���ü�� �ƴ� ��� CMS�̽�������� �Է��Ͻʽÿ�.'); fm.cms_not_cau.focus(); return; }
			if(fm.def_st.value == '')			{ alert('�뿩���-��ġ���θ� �Է��Ͻʽÿ�.'); 				fm.def_st.focus(); 			return; }
			if(fm.def_st.value == 'Y'){
				if(fm.def_remark.value == '')		{ alert('�뿩���-��ġ������ �Է��Ͻʽÿ�.');				fm.def_remark.focus();		return; }
				if(fm.def_sac_id.value == '')		{ alert('�뿩���-��ġ �����ڸ� �Է��Ͻʽÿ�.');			fm.def_sac_id.focus();		return; }
			}

				
			//������ ���
			if('<%=fee_size%>' == '1' && '<%=base.getRent_st()%>' == '3'){	
				if(fm.grt_suc_l_cd.value == '')	{ alert('������ ������� �Է��Ͻʽÿ�.'); 	return;}
			}		
			<%}%>
			
		}else if(idx == 13 || idx == 99){
		
			if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ fm.tax_type[0].checked = true; }
			if(fm.car_st.value != '2'){		
				if(fm.rec_st.value == '')				{ alert('���ݰ�꼭-û�������ɹ���� �Է��Ͻʽÿ�.');		fm.rec_st.focus(); 			return; }
				if(fm.rec_st.value == '1'){
					if(fm.ele_tax_st.value == '')		{alert('���ݰ�꼭-���ڼ��ݰ�꼭 �ý����� �Է��Ͻʽÿ�.'); fm.ele_tax_st.focus();		return; }
					if(fm.ele_tax_st.value == '2'){
						if(fm.tax_extra.value == '')	{ alert('���ݰ�꼭-���ڼ��ݰ�꼭 �����ý��� �̸��� �Է��Ͻʽÿ�.'); fm.tax_extra.focus(); 	return; }
					}
				}
			}			
																
		}
		
		fm.idx.value = idx;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_u_rm_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}							
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
	
	function getSecondhandCarDist(rent_dt, serv_dt, tot_dist){
		var fm = document.form1;
		rent_dt = fm.sh_day_bas_dt.value;
		serv_dt = fm.sh_km_bas_dt.value;
		tot_dist = fm.sh_tot_km.value;
		var height = 300;
		window.open("search_todaydist.jsp?car_mng_id=<%=base.getCar_mng_id()%>&rent_dt="+rent_dt+"&serv_dt="+serv_dt+"&tot_dist="+tot_dist, "VIEW_DIST", "left=0, top=0, width=650, height="+height+", scrollbars=yes");
	}
	

	function search_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}				
	
	//������ �������ϱ�
	function rent_delete(){
		var fm = document.form1;
		fm.idx.value = 'delete';
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
		if(confirm('���� �����Ͻðڽ��ϱ�?')){
		if(confirm('�����ϸ� �����Ҽ� �����ϴ�.\n\n���� ��¥�� �����Ͻðڽ��ϱ�?')){		
		if(confirm('������ ��� ����Ÿ�� �����ϰ� �˴ϴ�. \n\n�����Ͻðڽ��ϱ�?')){				
			fm.action='lc_b_u_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}}}}
	}
	
	//�����̷°����׸� ����
	function item_cng_update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id' || st == 'bus_st' || st == 'est_area'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650, status=yes, scrollbars=yes");
		}else{
			//window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=500, status=yes, scrollbars=yes");
		}
	}	
	
	function set_loc(loc_num, st){
		var fm = document.form1;	
		var loc_nm = '';
		
		if(loc_num == '1')		loc_nm = '����������';
		else if(loc_num == '2')		loc_nm = '�������� ������';
		else if(loc_num == '3')		loc_nm = '�λ����� ������';
		else if(loc_num == '4')		loc_nm = '�������� ������';
		else if(loc_num == '5')		loc_nm = '�뱸���� ������';
						
		if(loc_nm != ''){
			if(st == 'deli')		fm.deli_loc.value = loc_nm;
			else if(st == 'ret')		fm.ret_loc.value = loc_nm;
		}
	}	
	
	
	//�ŷ�ġ ������ĵ ����ȭ
	function scan_sys(){
		var fm = document.form1;
		fm.idx.value = 'scan_sys';		
		if(confirm('��ĵ���� ����ȭ�Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_u_rm_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}	
	}									
		
		
	//���ڹ��� �����ϱ�
	function go_edoc(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;	
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;	
		fm.link_im_seq.value 	= link_im_seq;			
		window.open('about:blank', "EDOC_LINK", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK";
		fm.action = "reg_edoc_link.jsp";
		fm.submit();		
	}			
	
	//��������
	function view_sale_cost_lw_add(){
		window.open("/fms2/mis/view_sale_cost_cont_lw_add.jsp?rent_mng_id=<%=base.getRent_mng_id()%>&rent_l_cd=<%=base.getRent_l_cd()%>&add_rent_st=s", "VIEW_SALE_COST_LW_ADD", "left=0, top=0, width=850, height=<%=s_height%>, scrollbars=yes");
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
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
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
  <input type='hidden' name='rent_way' 			value='<%=max_fee.getRent_way()%>'>
    
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">    
  <input type='hidden' name="est_from"			value="lc_b_u">
  <input type='hidden' name="fee_opt_amt"		value="">  
  <input type='hidden' name="rent_mng_id2"		value="">    
  <input type='hidden' name="rent_l_cd2"		value="">      
  <input type='hidden' name="fee_rent_st"		value="<%=rent_st%>">        
  <input type='hidden' name="fee_rent_dt"		value="">          
  <input type='hidden' name="r_max_agree_dist"		value=""> 
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
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>����Ʈ �̰���</span></span></td>
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
    		    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){%>
                <tr> 
                    <td class=title width=13%>���汸��</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_ST")%> <%=begin.get("RENT_L_CD")%></td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_DT")%></td>
                    <td class=title width=10%>��</td>
                    <td>&nbsp;<%=begin.get("FIRM_NM")%>&nbsp;<%=begin.get("CLIENT_NM")%></td>
                </tr>
    		    <tr>
        		    <td class=title>��������</td>
        			<td colspan="5">&nbsp;<%=begin.get("CLS_CAU")%></td>
    		    </tr>
    		    <%}else if(String.valueOf(begin.get("CLS_ST")).equals("��������")){%>
                <tr> 
                    <td class=title width=13%>���汸��</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_ST")%></td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_DT")%></td>
                    <td class=title width=10%>�ڵ���</td>
                    <td>&nbsp;<%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%></td>
                </tr>
    		    <tr>
    		        <td class=title>��������</td>
    			    <td colspan="5">&nbsp;<%=begin.get("CLS_CAU")%></td>
    		    </tr>
    		    <%}%>
            </table>		
        </td>
	</tr>
    <tr>
	    <td>&nbsp;</td>
	</tr>	
    <%}%>	
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%>(<%=rent_mng_id%>)</td>
                    <td class=title width=10%>��������</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>��������</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>��౸��</td>
                    <td>&nbsp;<%String cont_rent_st = base.getRent_st();%><%if(cont_rent_st.equals("1")){%>�ű�<%}else if(cont_rent_st.equals("3")){%>����<%}else if(cont_rent_st.equals("4")){%>����<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ�<%}else if(bus_st.equals("2")){%>�������<%}else if(bus_st.equals("3")){%>��ü�Ұ�<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>��ȭ���<%}else if(bus_st.equals("6")){%>������ü<%}else if(bus_st.equals("7")){%>������Ʈ<%}else if(bus_st.equals("8")){%>�����<%}%>
        	    </td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}else if(car_gu.equals("3")){%>����Ʈ<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;                   
                    <%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("4")){%>����Ʈ<%}else if(car_st.equals("5")){%>�����뿩<%}%>
                    <input type='hidden' name="car_st"		value="<%=base.getCar_st()%>">      
                    </td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String rent_way = max_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}else if(rent_way.equals("2")){%>�����<%}%></td>
                </tr>
                <tr> 
                    <td class=title>���ʿ�����</td>
                    <td>&nbsp;
        			  <select name="bus_id">
        			    <option value="">����</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(base.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
        		  		<option value="">=�����=</option>
                 		 <%	if(user_size2 > 0){
        						for (int i = 0 ; i < user_size2 ; i++){
        							Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                  		<option value='<%=user2.get("USER_ID")%>' <%if(base.getBus_id().equals(String.valueOf(user2.get("USER_ID")))){%>selected<%}%>><%=user2.get("USER_NM")%></option>
                  		<%		}
        					}%>				
                    </select></td>
                    <td class=title>���������</td>
                    <td>&nbsp;
			<%if(nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("�����������",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
        			  <select name="bus_id2">
        			    <option value="">����</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(base.getBus_id2().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
        		  		<option value="">=�����=</option>
                  		<%	if(user_size2 > 0){
        						for (int i = 0 ; i < user_size2 ; i++){
        						Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                  		<option value='<%=user2.get("USER_ID")%>' <%if(base.getBus_id2().equals(String.valueOf(user2.get("USER_ID")))){%>selected<%}%>><%=user2.get("USER_NM")%></option>
                  		<%		}
        					}%>				
                      </select>						
					  <%}else{%>
						<%=c_db.getNameById(base.getBus_id2(),"USER")%>
						<input type='hidden' name='bus_id2' 		value='<%=base.getBus_id2()%>'>
					  <%}%>
					</td>   
                    <td class=title>�����ε���</td>
                    <td>&nbsp;
        			  <input type="text" name="car_deli_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>" size="11" maxlength='11' class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
					                 					
                </tr>
                <tr>
                    <td class=title>�����̿�����</td>
                    <td colspan='5'>&nbsp;
                    	<%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
                        <input type='hidden' name="est_area" value="<%=cont_etc.getEst_area()%>">
			<input type='hidden' name='county' value='<%=cont_etc.getCounty()%>'>
			<%if(base.getUse_yn().equals("")){%>
			<a href="javascript:item_cng_update('est_area')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
			<%}%>
					</td>
                </tr>									
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:update('0')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>
	<tr>
	    <td class=h></td>
	</tr>					
    <%if(String.valueOf(begin.get("CLS_ST")).equals("���°�")){
    		if(cont_etc.getRent_suc_dt().equals("")) cont_etc.setRent_suc_dt(base.getReg_dt());
			ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//���� ��� ���� ��ȸ
			//���Ծ��� �°������ �δ�
			if(cont_etc.getRent_suc_commi_pay_st().equals("1")){
				suc2 = ae_db.getAGrtScd(rent_mng_id, cont_etc.getRent_suc_l_cd(), "1", "5", "1");//���� ��� ���� ��ȸ
			}%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���°�</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>					
                <tr>
                    <td class=title width=13%>���°�����</td>
                    <td colspan='3'>&nbsp;
    			    <input type="text" name="rent_suc_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%>" size="11" maxlength='11' class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
    		</tr>	    
		<tr>			
					</td>	
                    <td class=title width=13%>���°������</td>
                    <td colspan='3'>&nbsp;
        			  <input type='text' size='11' name='rent_suc_commi' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��
					  &nbsp;&nbsp;&nbsp;
					  <% 	if(suc2 == null || suc2.getRent_l_cd().equals("")){%> 
					  ���ް� : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='num' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>��
					  �ΰ��� : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='num' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>��					  
					  &nbsp;&nbsp;&nbsp;					  
					  <% 		if(AddUtil.parseInt(cont_etc.getRent_suc_dt()) >= 20100520){%> 	
					  <br>&nbsp;
						(������ ���� -> 
					    <input type="checkbox" name="suc_tax_req" value="Y"> ��꼭 ����
						�Աݿ����� : <input type='text' name='suc_commi_est_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
						<a href="javascript:make_suc_schedule();"><img src=/acar/images/center/button_sch_cre.gif  align=absmiddle border="0"></a> )
					  <%		}%>
					  <%	}else{%>
					  ���ް� : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(suc2.getExt_s_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��
					  �ΰ��� : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(suc2.getExt_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��					  
					  &nbsp;&nbsp;&nbsp;
					  <%	}%>				   				   
				   &nbsp;&nbsp;&nbsp;
				   * ����°������ : <%=AddUtil.parseDecimal((car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())*0.7/100)%>��	  
				   (�����Һ��ڰ� <%=AddUtil.parseDecimal((car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt()))%>���� 0.7%)

					  
					  </td>
                    
                </tr>
				<tr>
                    <td class=title width=13%>���δ���</td>
                    <td colspan='3'>&nbsp;
    			    	<select name='rent_suc_commi_pay_st'>
                           <option value="">����</option>
                           <option value="1" <%if(cont_etc.getRent_suc_commi_pay_st().equals("1")){%>selected<%}%>>�������</option>
                           <option value="2" <%if(cont_etc.getRent_suc_commi_pay_st().equals("2")){%>selected<%}%>>���°���</option>
                        </select>
						
					</td>					
				</tr>
				<tr>
                    <td class=title width=13%>������</td>
                    <td width=50%>&nbsp;
    			    	����ຸ����
						<input type='text' size='11' name='suc_grt_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��						
						, �°躸����
						<input type='text' size='11' name='suc_grt_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>��						
						
					</td>					
					<td class=title width=10%>�����ݽ°迩��</td>
					<td>&nbsp;
						<select name='rent_suc_grt_yn'>
                           <option value="">����</option>
                           <option value="0" <%if(cont_etc.getRent_suc_grt_yn().equals("0")){%>selected<%}%>>�°�</option>
                           <option value="1" <%if(cont_etc.getRent_suc_grt_yn().equals("1")){%>selected<%}%>>����</option>
                        </select>
					</td>					
				</tr>				
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:update('suc_commi')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>
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
                      <%if(client.getClient_id().equals("000228") || nm_db.getWorkAuthUser("������",user_id)){//%>
        		<span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        	      <%}%>
        	      <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>					  
        	    </td>
                    <td width='10%' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="client_nm" value='<%=client.getClient_nm()%>' size='22' class='whitetext' readonly></td>
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
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>
                <tr>
                    <td class='title'>�����ּ�</td>
                    <td align='left'>&nbsp;
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=base.getP_zip()%>">
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="40" value="<%=base.getP_addr()%>">
                    </td>
                    <td class='title'>����������</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='<%=base.getTax_agnt()%>' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
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
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%=mgr.getMgr_st()%>' class='white' readonly ></td>
                    
                    <td align='center'><input type='text' name='mgr_nm'   size='13' value='<%=mgr.getMgr_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_ssn'  size='15' maxlength='8' value='<%=mgr.getSsn()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_addr'  size='20' value='<%=mgr.getMgr_addr()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_tel'    size='13' value='<%=mgr.getMgr_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='<%=mgr.getMgr_m_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_lic_no'   size='13' value='<%=mgr.getLic_no()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_etc' size='20' value='<%=mgr.getEtc()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		  <%	} %>
                <tr>                 <input type='hidden' name='mgr_id'  value='<%=mgr_size%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='' class='text'></td>
                    <td align='center'><input type='text' name='mgr_nm'   size='13' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_ssn'  size='15' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_addr'  size='20' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_tel'    size='13' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_lic_no'   size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_etc' size='20' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=mgr_size%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>		  		  
                <tr id=tr_mgr_addr style='display:none'> 
                    <td colspan="2" class=title>�����̿��� �ǰ����� �ּ�</td>
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
                    <td colspan="8">&nbsp;<% zip_cnt++;%>
						<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=mgr_zip%>">
						<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr1" size="60" value="<%=mgr_addr%>">
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr></tr><tr></tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>�������뵵</td>                    
                    <td>&nbsp;
                      <input type='text' name="rm_car_use" value='<%=f_fee_rm.getCar_use()%>' size='50' class='text'></td>
                </tr>  
            </table>
        </td>
    </tr>        
	<tr>
	    <td align="right"><a href="javascript:update('1')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ���뺸��</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_client_guar_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>"'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1'  <%if(cont_etc.getClient_guar_st().equals("1"))%>checked<%%>>
        				�Ժ�
        			  <input type='radio' name="client_guar_st" value='2'  <%if(cont_etc.getClient_guar_st().equals("2"))%>checked<%%>>
        				����</td>
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
        					<% zip_cnt++;%>
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
									<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value="<%=gur.get("GUR_ZIP")%>">
									<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr2" size="25" value="<%=gur.get("GUR_ADDR")%>">
									</td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value='<%=gur.get("GUR_TEL")%>'></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value='<%=gur.get("GUR_REL")%>'></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                      <%}%>
                      <%for(int i=gur_size; i<3; i++){%>
                      <% zip_cnt++;%>
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
									<input type="text" name="t_zip"  id="t_zip3" size="7" maxlength='7' value="">
									<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr3" size="25" value="">
								</td>
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
	<tr>
	    <td align="right"><a href="javascript:update('2')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>

	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
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
                <tr>
                    <td width='13%' class='title'>�ڵ���ȸ��</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' width="10%">����</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' width='10%'>����</td>
                    <td>&nbsp;<a href="javascript:view_car_nm('<%=cm_bean.getCar_id()%>', '<%=cm_bean.getCar_seq()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cm_bean.getCar_name()%></a></td>
                </tr>
                <tr>
                    <td class='title'>�Һз� </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
                    <td class='title' width="10%">�����ڵ�</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>��ⷮ</td>
                    <td>&nbsp;<%=cr_bean.getDpm()%>cc</td>
                </tr>
                <tr>
                    <td class='title'>GPS��ġ������ġ</td>
                    <td colspan="5">&nbsp;
        			  <%if(cr_bean.getGps().equals("Y")){%>����<%}else{%>������<%}%>
					  </td>
                </tr>								
                <tr>
                    <td class='title'>�⺻���</td>
                    <td colspan="5" align=center>
                        <table width=99% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td>
        			  <%if(!cm_bean2.getCar_name().equals("")){%>
        			      <a href="javascript:open_car_b('<%=cm_bean2.getCar_id()%>','<%=cm_bean2.getCar_seq()%>','<%=cm_bean2.getCar_name()%>')" title="<%=cm_bean2.getCar_b()%>"><font color='#999999'><%=cm_bean2.getCar_name()%>��&nbsp;</font></a>
        			  <%}%>
        			  <%=cm_bean.getCar_b()%></td>
        			        </tr>
        			        <tr>
                                <td style='height:3'></td>
                            </tr>
                        </table>
                    </td>
                </tr>		  		  
                <tr>
                    <td class='title'>�ɼ�</td>
                    <td colspan="5">&nbsp;
        			  <%=car.getOpt()%><input type='hidden' name='opt_code' value='<%=car.getOpt_code()%>'></td>
                </tr>
                <tr>
                    <td class='title'>����</td>
                    <td colspan="5">&nbsp;                        
        			  <%=car.getColo()%>
					  &nbsp;&nbsp;&nbsp;
					  (�������(��Ʈ): <%=car.getIn_col()%> )  
					  &nbsp;&nbsp;&nbsp;
					  (���Ͻ�: <%=car.getGarnish_col()%> )  
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
	<tr>
	    <td align="right"><a href="javascript:update('8')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
		  
    <tr id=tr_car0 style="display:<%if(!base.getCar_gu().equals("1") || fee_size > 1){%>''<%}else{%>none<%}%>"> 
	<%	int sh_car_amt = 0;
		String sh_year= "";
		String sh_month = "";
		String sh_day = "";
		String sh_day_bas_dt = "";
		int sh_amt = 0;
		float sh_ja = 0;
		int sh_km = 0;
		int sh_tot_km = 0;
		String sh_km_bas_dt = "";
		String sh_init_reg_dt = "";
		if(!base.getCar_gu().equals("1") || fee_size > 1){
			sh_car_amt 		= fee_etc.getSh_car_amt();
			sh_year 		= fee_etc.getSh_year();
			sh_month 		= fee_etc.getSh_month();
			sh_day	 		= fee_etc.getSh_day();
			sh_amt			= fee_etc.getSh_amt();
			sh_ja			= fee_etc.getSh_ja();
			sh_km			= fee_etc.getSh_km();
			sh_tot_km		= fee_etc.getSh_tot_km();
			sh_km_bas_dt	= fee_etc.getSh_km_bas_dt();
			sh_init_reg_dt	= fee_etc.getSh_init_reg_dt();
			sh_day_bas_dt	= fee_etc.getSh_day_bas_dt();
			if(sh_tot_km==0) sh_tot_km = a_db.getSh_tot_km(base.getCar_mng_id(), fee_etc.getSh_km_bas_dt());
				
			if(sh_year.equals("")){
				sh_year 	= String.valueOf(carOld.get("YEAR"));
				sh_month 	= String.valueOf(carOld.get("MONTH"));
				sh_day	 	= String.valueOf(carOld.get("DAY"));				
			}
		}
		if(sh_init_reg_dt.equals("")) sh_init_reg_dt = cr_bean.getInit_reg_dt();
	%>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> �����Һ��ڰ� </td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(sh_car_amt)%>'size='10' class='defaultnum' readonly >
        				  �� </td>
                    <td class='title' width="10%">�ܰ���</td>
                    <td width="10%">&nbsp;
                      <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher(sh_ja,2) %>'size='4' class='defaultnum' readonly >
					  %</td>
                    <td class='title' width='10%'>
                      �߰�����</td>
                  <td width="37%">&nbsp;
                    <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(sh_amt) %>'size='10' class='defaultnum'  readonly>
					  ��
					  
					  </td>
                </tr>
                <tr>
                  <td class='title'>����</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_year' value='<%=sh_year%>'size='1' class='white' >
                    ��
                    <input type='text' name='sh_month' value='<%=sh_month%>'size='2' class='white' >
                    ����
                    <input type='text' name='sh_day' value='<%=sh_day%>'size='2' class='white' >
                    �� (���ʵ����
                    <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(sh_init_reg_dt)%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    ~�����
                    <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%><%//= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='white' >
				  

                  )				  
				  </td>
                </tr>
                <tr>				  
                  <td class='title'>��������Ÿ�</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(sh_km) %>' class='defaultnum' >
					  km ( <%if(fee_size==1){%>����� <%}else{%> �뿩������<%}%>
					  <input type='text' name='sh_day_bas_dt2' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%><%//= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='white' > 
					  ) / Ȯ������Ÿ� 
					  <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal(sh_tot_km) %>' class='defaultnum' >
					  km ( ����Ȯ����
					  <input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2(sh_km_bas_dt) %>' class='default' >
					  )
					 </td>
                </tr>
                <%if(!cr_bean.getDist_cng().equals("")){%>
                <tr>
                  <td class='title'>����Ǳ�ü</td>
                  <td colspan="5">&nbsp;
                    <font color=green><%=cr_bean.getDist_cng()%></font></td>
                </tr>                
                <%}%>
            </table>
	    </td>
    </tr>
   	<!--
	<tr>
	    <td align="right"><a href="javascript:update('9')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	-->
	<tr>
	    <td class=h></td>
	</tr>	
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
                            <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>21���̻� 
                            </option>
                            <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>24���̻� 
                            </option>
                            <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>26���̻� 
                            </option>
                            <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>������ 
                            </option>
							<option value=''>=�Ǻ����ڰ�=</option>				
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>30���̻�</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>35���̻�</option>				
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>43���̻�</option>						
						<option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>48���̻�</option>
						<option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>22���̻�</option>
						<option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>28���̻�</option>
						<option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>35���̻�~49������</option>
                          </select></td>
                    <td width="10%" class=title >�빰���</td>
                    <td width="15%">&nbsp;
                    <select name='vins_gcp_kd' disabled>
                            <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5���</option>
                            <option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3���</option>
			    <option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2���</option>
                            <option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1���</option>							
                            <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000����&nbsp;&nbsp;&nbsp;</option>
                            <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000����</option>
                            <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500����</option>
                            <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000����</option>				
                          </select></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td>&nbsp;
                    <select name='vins_bacdt_kd' disabled>
                            <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3���</option>							
                            <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1��5õ����</option>
                            <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1���</option>
                            <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000����</option>
                            <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000����</option>
                            <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500����</option>
                            <option value="9" <%if(ins.getVins_bacdt_kd().equals("9")){%>selected<%}%>>�̰���</option>
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
                      </select></td>
                    <td width="10%"  class=title>�Ǻ�����</td>
                    <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' onChange='javascript:display_ip()'>
                          <option value="">����</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>�Ƹ���ī</option>
                          <!--  <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>��</option>-->
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
                <td class=''>&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">����</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>����</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>�̰���</option>
                  </select></td>                        
                </tr>
                <tr>
                    <td  class=title>���ι��</td>
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
              <tr>
                <td  class=title>���������</td>
                <td colspan='5'>&nbsp;
                    <select name="my_accid_yn">
                        <option value="Y" <%if(f_fee_rm.getMy_accid_yn().equals("Y"))%>selected<%%>>���δ�</option>
                        <option value="N" <%if(f_fee_rm.getMy_accid_yn().equals("N"))%>selected<%%>>����</option>
                      </select>
                  </td>
              </tr>                              
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:update('10')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	</tr>	    	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/���� ��������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <%
    	String plan_dt = "";
	String plan_h = "";
	String plan_m = "";
    %>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td width="13%"  class=title>�����ð�</td>
    <%
	if(f_fee_rm.getDeli_plan_dt().length() == 12){
		plan_dt = f_fee_rm.getDeli_plan_dt().substring(0,8);
		plan_h 	= f_fee_rm.getDeli_plan_dt().substring(8,10);
		plan_m	= f_fee_rm.getDeli_plan_dt().substring(10,12);
	}
    %>                
                <td width="37%">&nbsp;<input type='text' size='11' name='deli_plan_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(plan_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='deli_plan_h' class='default' value='<%=plan_h%>'>
                    ��
                    <input type='text' size='2' name='deli_plan_m' class='default' value='<%=plan_m%>'>
                    ��
                    </td>
                <td width="13%" class=title>�����ð�</td>
    <%
    	plan_dt = "";
    	plan_h = "";
    	plan_m = "";
	if(f_fee_rm.getRet_plan_dt().length() == 12){
		plan_dt = f_fee_rm.getRet_plan_dt().substring(0,8);
		plan_h 	= f_fee_rm.getRet_plan_dt().substring(8,10);
		plan_m	= f_fee_rm.getRet_plan_dt().substring(10,12);
	}
    %>                
                
                <td width="37%" class=''>&nbsp;<input type='text' size='11' name='ret_plan_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(plan_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='ret_plan_h' class='default' value='<%=plan_h%>'>
                    ��
                    <input type='text' size='2' name='ret_plan_m' class='default' value='<%=plan_m%>'>
                    ��
                    </td>
              </tr>
              <tr> 
                <td width="13%"  class=title>�������</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='deli_loc' class='default' value='<%=f_fee_rm.getDeli_loc()%>'  onBlur="javscript:set_loc(this.value, 'deli');">
                      </td>
                <td width="13%" class=title>�������</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='ret_loc' class='default' value='<%=f_fee_rm.getRet_loc()%>'  onBlur="javscript:set_loc(this.value, 'ret');">
                      </td>
              </tr>          
            </table>
        </td>
    </tr>
    <tr>
        <td>* ��/���� ��� ��ȣ �ڵ��Է� : 1 - ����������, 2 - �������� ������, 3 - �λ����� ������, 4 - �������� ������, 5 - �뱸���� ������ </td>
    </tr>          	    
	<tr>
	    <td align="right"><a href="javascript:update('16')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span></td>
    </tr>
	<%	for(int f=1; f<=fee_size; f++){
			ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
			
			ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));
			
			//����Ʈ����
			ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, Integer.toString(f));
			
			if(fee_size >1 && f==(fee_size-1)){
				fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt();
			}
			
			if(f<fee_size){%>	
    <tr>
	<td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 	
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr>
                    <td width="13%" align="center" class=title>�������</td>
                    <td width="20%">&nbsp;<%if(f >1){%><%=AddUtil.ChangeDate2(fees.getRent_dt())%><%}else{%><%=AddUtil.ChangeDate2(base.getRent_dt())%><%}%></td>
                    <td width="10%" align="center" class=title>�������</td>
                    <td >&nbsp;<%if(f >1){%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}else{%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}%></td>
                    <td width="10%" align="center" class=title>�����븮��</td>
                    <td >&nbsp;<%if(f >1){%><%=c_db.getNameById(fee_etc.getBus_agnt_id(),"USER")%><%}else{%><%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%><%}%></td>
                </tr>		
                <tr>
                    <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="ext_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitetext' onChange='javascript:set_cont_date(this)'>
            			 ����
            		<%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%>	 
            		<input type='text' name="ext_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='whitetext' onChange='javascript:set_cont_date(this)'>
            			 ��
            		<%}else{%>
            		<input type='hidden' name="ext_con_day" value="<%=fee_etcs.getCon_day()%>">      
            		<%}%>
            	    </td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="ext_rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate4(this, this.value); set_cont_date(this);'></td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td>&nbsp;
                      <input type="text" name="ext_rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate4(this, this.value);'></td>
                  </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>����</td>
                    <td class='title' width='11%'>���ް�</td>
                    <td class='title' width='11%'>�ΰ���</td>
                    <td class='title' width='13%'>�հ�</td>
                    <td class='title' width='4%'>�Ա�</td>
                    <td class='title' width="28%">�������</td>
                    <td class='title' width='20%'>��������</td>
                </tr>            
                <tr>                    
                    <td colspan='2' class='title'>������</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='ext_grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='ext_gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % </td>
                    <td align='center'>
					<%if(fee_size==1 && f==1 && base.getRent_st().equals("3")){%>
					  ���� ������ �°迩�� :
					  <select name='ext_grt_suc_yn' disabled>
                              <option value="">����</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0"))%>selected<%%>>�°�</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1"))%>selected<%%>>����</option>
                            </select>	
					<%}else{%>
        			  <%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%>
        			  <input type='hidden' name='ext_gur_suc_yn' value='<%=fees.getGrt_suc_yn()%>'>
					<%}%>
        			  <input type='hidden' name='ext_gur_per' value=''>
        			  <input type='hidden' name='ext_grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'><!--���� <font color="#FF0000">��Ʈ
        			    <input type='text' size='3' name='gur_per' class='whitenum' value='' readonly>%</font> �̻�-->
						</td>
                </tr>    
              <tr>
                <td width="3%" rowspan="5" class='title'>��<br>
                  ��<br>��<br>��</td>
                <td width="10%" class='title'>����뿩��</td>
                 <td align="center"><input type='text' size='11' name='ext_inv_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ext_inv_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ext_inv_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>

                <td align="center">-</td>
                <td align='center'>-</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>D/C</td>
                <td align="center">-<input type='text' size='10' name='ext_dc_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">-<input type='text' size='10' name='ext_dc_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-<input type='text' size='10' name='ext_dc_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt()+fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
    		<td align='center'>-</td>		  
                <td align="center">DC��:
                  <input type='text' size='4' name='ext_dc_ra' maxlength='10' class="whitenum" value='<%=fee.getDc_ra()%>'>
                </font>%</span></td>
                <td align='center'>-</td>
              </tr>              
              <tr>
                <td class='title'>������̼�</td>
                <td align="center"><input type='text' size='11' name='ext_navi_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ext_navi_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ext_navi_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                 
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>��Ÿ</td>
                <td align="center"><input type='text' size='11' name='ext_etc_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ext_etc_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ext_etc_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                    <input type='text' size='40' name='ext_etc_cont' class='text' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>�հ�</td>
                <td align="center"><input type='text' size='11' name='ext_fee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ext_fee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ext_fee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">-</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>�뿩���Ѿ�</td>
                <td align="center"><input type='text' size='11' name='ext_t_fee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ext_t_fee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ext_t_fee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center"><input type='text' name="ext_v_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 ����
        		<%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%>	 		 
        	    <input type='text' name="ext_v_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 ��
        		<%}else{%>	
        		<input type='hidden' name="ext_v_con_day" value="<%=fee_etcs.getCon_day()%>">       
        		<%}%>
        			 </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>������</td>
                <td align="center"><input type='text' size='11' name='ext_cons1_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ext_cons1_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ext_cons1_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                  
    	 	</td>
                <td align='center'>
    			  
                </td>
              </tr>
              <tr>
                <td colspan="2" class='title'>������</td>
                <td align="center"><input type='text' size='11' name='ext_cons2_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ext_cons2_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ext_cons2_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                  
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>�հ�</td>
                <td align="center"><input type='text' size='11' name='ext_rent_tot_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='ext_rent_tot_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='ext_rent_tot_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center"> </td>
                <td align='center'>-</td>
              </tr>              
              <tr id=tr_emp_bus style="display:''">
                <td rowspan="<%if(rent_st.equals("3")){%>4<%}else{%>3<%}%>" class='title'>��<br>Ÿ</td>                             
                <td class='title'><span class="title1">���ʰ����ݾ�</span></td>
                <td align='center'><input type="text" name="ext_f_rent_tot_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��		  
                </td>                
                <td colspan='4'>&nbsp;&nbsp;&nbsp;
                     * ���ʰ������ : <select name="ext_f_paid_way" onchange="javascript:f_paid_way_display();" disabled>
                        <option value="">==����==</option>			  
                        <option value="1" <%if(fee_rm.getF_paid_way().equals("1")){%>selected<%}%>>1����ġ</option>
                        <option value="2" <%if(fee_rm.getF_paid_way().equals("2")){%>selected<%}%>>�Ѿ�</option>
                      </select>
                      &nbsp; ������
                      <select name="ext_f_paid_way2" onchange="javascript:f_paid_way_display();" disabled>
                        <option value="">==����==</option>
                        <option value="1" <%if(fee_rm.getF_paid_way2().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(fee_rm.getF_paid_way2().equals("3")){%>selected<%}%>>������</option>
                      </select>          
                      &nbsp;&nbsp;&nbsp;
                      * ����� : <input type="text" name="ext_f_con_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_con_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��	
                  
                </td>                
                <td align='center'>-</td>
              </tr>  
              <tr>
                <td class='title'><span class="title1">��������Ÿ�</span></td>
                <td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='ext_agree_dist' size='8' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>'>
                  km����/1����,
                  �ʰ��� 1km�� (<input type='text' name='ext_over_run_amt' size='3' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��)�� �߰������ �ΰ��˴ϴ�.
                </td>
                <td align='center'>-</td>
              </tr>                                   
              <tr>
                <td class='title'>�ߵ�����������</td>
                <td colspan="4" align="center">���̿�Ⱓ�� 1���� �̻��� ���</td>                
                <td align="center">�ܿ��Ⱓ �뿩����
                    <input type='text' size='3' name='ext_cls_r_per' maxlength='10'  class='whitenum' value='<%=fee.getCls_r_per()%>'>
    				  %</td>
                <td align='center'><font color="#FF0000">
    				<input type='text' size='3' name='ext_cls_per' maxlength='10' class='whitenum' value='<%=fee.getCls_per()%>'>%					
					</font></span></td>
              </tr>
              <%if(rent_st.equals("3")){%>
				<%	//�������������
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}
					%>			  
              <tr>
                    <td class='title' style="font-size : 8pt;">���������</td>
                    <td colspan="6">&nbsp;					  
					  &nbsp;����ȣ : <input type='text' name='ext_grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='ext_grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;�����ڵ庰���� ���� : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[���������ݽ°�]</b>
					  &nbsp;���������� : <input type='text' name='ext_grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum' >��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  �°躸���� : <input type='text' name='ext_grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum' >��
					  <input type='hidden' name='ext_grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  				<font color=red>(���������� ���� <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  			<%} %>		
        			</td>
              </tr>	
              <%}%>
              <tr>
                <td colspan="2" class='title'>���</td>
                <td colspan="6">&nbsp;
                  <textarea rows='5' cols='90' name='ext_fee_cdt' disabled><%=fees.getFee_cdt()%></textarea></td>
              </tr>			
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>����Ƚ��</td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='ext_fee_pay_tm' value='<%=fees.getFee_pay_tm()%>' maxlength='2' class='text' >
        				ȸ </td>
                    <td width="10%" class='title'>��������</td>
                    <td width="20%">&nbsp;�ſ�
                      <select name='ext_fee_est_day'>
                        <option value="">����</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                        <option value='<%=i%>' <%if(fees.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                        <% } %>
                        <option value='99' <%if(fees.getFee_est_day().equals("99")){%> selected <%}%>> ���� </option>
						<option value='98' <%if(fees.getFee_est_day().equals("98")){%> selected <%}%>> �뿩������ </option>
                      </select></td>
                    <td width="10%" class='title'>���ԱⰣ</td>
                    <td>&nbsp;
                      <input type='text' name='ext_fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  <input type='text' name='ext_fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		
            </table>				  							
	    </td>
    </tr>			
	<%		}else{//������ȸ��				
        %>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr id=tr_fee_rent style="display:<%if(!fees.getRent_st().equals("1")){%>''<%}else{%>none<%}%>">
                <td width="13%" align="center" class=title>�������</td>
                <td width="20%">&nbsp;
					  <%if(nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
        			  <input type="text" name="ext_rent_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(fees.getRent_dt())%>
					  <input type='hidden' name='ext_rent_dt' 	value='<%=fees.getRent_dt()%>'>
					  <%}%>				
				  
				</td>
                <td width="10%" align="center" class=title>�������</td>
                <td >&nbsp;                  
                  <select name='ext_agnt'>
                    <option value="">����</option>
                    <%if(user_size > 0){
    					for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); %>
                    <option value='<%=user.get("USER_ID")%>' <%if(fees.getExt_agnt().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%	}
    				}		%>
    		  <option value="">=�����=</option>
              <%if(user_size2 > 0){
    				for (int i = 0 ; i < user_size2 ; i++){
    					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
              <option value='<%=user2.get("USER_ID")%>' <%if(fees.getExt_agnt().equals(String.valueOf(user2.get("USER_ID")))){%>selected<%}%>><%=user2.get("USER_NM")%></option>
              <%	}
    			}%>												
                  </select>                  
                </td>
                <td width="10%" align="center" class=title>�����븮��</td>
                <td >&nbsp;                  
                  <select name='ext_bus_agnt_id'>
                    <option value="">����</option>
                    <%if(user_size > 0){
    					for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); %>
                    <option value='<%=user.get("USER_ID")%>' <%if(fee_etc.getBus_agnt_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%	}
    				}		%>
    		  <option value="">=�����=</option>
              <%if(user_size2 > 0){
    				for (int i = 0 ; i < user_size2 ; i++){
    					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
              <option value='<%=user2.get("USER_ID")%>' <%if(fee_etc.getBus_agnt_id().equals(String.valueOf(user2.get("USER_ID")))){%>selected<%}%>><%=user2.get("USER_NM")%></option>
              <%	}
    			}%>																
                  </select>                 
                </td>
              </tr>				
              <tr>
                <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                <td width="20%">&nbsp;
                    <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 ����
        	    <%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%>	 		 
        	    <input type='text' name="con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 ��	
        	    <%}else{%>		 	 
        	    <input type='hidden' name="con_day" value="<%=fee_etcs.getCon_day()%>">      
        	    <%}%>
        	</td>
                <td width="10%" align="center" class=title>�뿩������</td>
                <td width="20%">&nbsp;
                  <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'></td>
                <td width="10%" align="center" class=title>�뿩������</td>
                <td>&nbsp;
                  <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);'></td>
              </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>����</td>
                    <td class='title' width='11%'>���ް�</td>
                    <td class='title' width='11%'>�ΰ���</td>
                    <td class='title' width='13%'>�հ�</td>
                    <td class='title' width='4%'>�Ա�</td>
                    <td class='title' width="28%">�������</td>
                    <td class='title' width='20%'>��������</td>
                </tr>                
                <tr>
                    <td colspan='2' class='title'>������</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % </td>
                    <td align='center'>
		    <%if(fee_size==1 && base.getRent_st().equals("3")){%>
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
        		<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'>
        	    </td>
                </tr>           
              <tr>
                <td width="3%" rowspan="5" class='title'>��<br>
                  ��<br>��<br>��</td>
                <td width="10%" class='title'>����뿩��</td>
                 <td align="center"><input type='text' size='11' name='inv_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='inv_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='inv_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>

                <td align="center">-</td>
                <td align='center'>-</td>
                <td align='center'>-
                  
                  &nbsp;<%=fee_rm.getEst_id()%>
                  
                </td>
              </tr>
              <tr>
                <td class='title'>D/C</td>
                <td align="center">-<input type='text' size='10' name='dc_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center">-<input type='text' size='10' name='dc_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-<input type='text' size='10' name='dc_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt()+fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
    		<td align='center'>-</td>		  
                <td align="center">DC��:
                  <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fee.getDc_ra()%>'>
                </font>%</span></td>
                <td align='center'>-</td>
              </tr>              
              <tr>
                <td class='title'>������̼�</td>
                <td align="center"><input type='text' size='11' name='navi_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='navi_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='navi_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                  <input type='radio' name="navi_yn" value='N' onclick="javascript:obj_display('navi','N')" <%if(fee_rm.getNavi_yn().equals("0")||fee_rm.getNavi_yn().equals("")){%> checked <%}%>>
                  ����
                  <input type='radio' name="navi_yn" value='Y' onclick="javascript:obj_display('navi','Y')" <%if(fee_rm.getNavi_yn().equals("1")){%> checked <%}%>>
    	 	  ����
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>��Ÿ</td>
                <td align="center"><input type='text' size='11' name='etc_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='etc_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='etc_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                    <input type='text' size='40' name='etc_cont' class='text' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>�հ�</td>
                <td align="center"><input type='text' size='11' name='fee_s_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='fee_v_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='fee_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">-</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>�뿩���Ѿ�</td>
                <td align="center"><input type='text' size='11' name='t_fee_s_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='t_fee_v_amt' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='t_fee_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center"><input type='text' name="v_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 ����
        			 <%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%>
        	    <input type='text' name="v_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 ��
        			 <%}else{%>
        			 <input type='hidden' name="v_con_day" value="<%=fee_etcs.getCon_day()%>">      
        			 <%}%>
        			 </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>������</td>
                <td align="center"><input type='text' size='11' name='cons1_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='cons1_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='cons1_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                  <input type='radio' name="cons1_yn" value='N' onclick="javascript:obj_display('cons1','N')" <%if(fee_rm.getCons1_yn().equals("0")||fee_rm.getCons1_yn().equals("")){%> checked <%}%>>
                  ����
                  <input type='radio' name="cons1_yn" value='Y' onclick="javascript:obj_display('cons1','Y')" <%if(fee_rm.getCons1_yn().equals("1")){%> checked <%}%>>
    	 	  ���� 
    	 	</td>
                <td align='center'>
    			  
                </td>
              </tr>
              <tr>
                <td colspan="2" class='title'>������</td>
                <td align="center"><input type='text' size='11' name='cons2_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='cons2_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='cons2_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                  <input type='radio' name="cons2_yn" value='N' onclick="javascript:obj_display('cons2','N')" <%if(fee_rm.getCons2_yn().equals("0")||fee_rm.getCons2_yn().equals("0")){%> checked <%}%>>
                  ����
                  <input type='radio' name="cons2_yn" value='Y' onclick="javascript:obj_display('cons2','Y')" <%if(fee_rm.getCons2_yn().equals("1")){%> checked <%}%>>
    	 	  ���� 
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>�հ�</td>
                <td align="center"><input type='text' size='11' name='rent_tot_s_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='rent_tot_v_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='rent_tot_amt' maxlength='11' class='fixnum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center"> </td>
                <td align='center'>-</td>
              </tr>              
              <tr id=tr_emp_bus style="display:''">
                <td rowspan="<%if(rent_st.equals("3")){%>4<%}else{%>3<%}%>" class='title'>��<br>Ÿ</td>                             
                <td class='title'><span class="title1">���ʰ����ݾ�</span></td>
                <td align='center'><input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>" size="11" class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��		  
                </td>                
                <td colspan='4'>&nbsp;&nbsp;&nbsp;
                     * ���ʰ������ : <select name="f_paid_way" onchange="javascript:f_paid_way_display();">
                        <option value="">==����==</option>			  
                        <option value="1" <%if(fee_rm.getF_paid_way().equals("1")){%>selected<%}%>>1����ġ</option>
                        <option value="2" <%if(fee_rm.getF_paid_way().equals("2")){%>selected<%}%>>�Ѿ�</option>
                      </select>
                      &nbsp; ������
                      <select name="f_paid_way2" onchange="javascript:f_paid_way_display();">
                        <option value="">==����==</option>
                        <option value="1" <%if(fee_rm.getF_paid_way2().equals("1")){%>selected<%}%>>����</option>
                        <option value="2" <%if(fee_rm.getF_paid_way2().equals("2")){%>selected<%}%>>������</option>
                      </select>          
                      &nbsp;&nbsp;&nbsp;
                      * ����� : <input type="text" name="f_con_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_con_amt())%>" size="11" class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��	
                  
                </td>                
                <td align='center'>-</td>
              </tr>  
              <tr>
                <td class='title'><span class="title1">��������Ÿ�</span></td>
                <td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='agree_dist' size='8' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>'>
                  km����/1����,
                  �ʰ��� 1km�� (<input type='text' name='over_run_amt' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��)�� �߰������ �ΰ��˴ϴ�.
                </td>
                <td align='center'>-</td>
              </tr>                                   
              <tr>
                <td class='title'>�ߵ�����������</td>
                <td colspan="4" align="center">���̿�Ⱓ�� 1���� �̻��� ���</td>                
                <td align="center">�ܿ��Ⱓ �뿩����
                    <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fee.getCls_r_per()%>'>
    				  %</td>
                <td align='center'><font color="#FF0000">
    				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fee.getCls_per()%>'>%					
					</font></span></td>
              </tr>
              <%if(rent_st.equals("3")){%>
				<%	//�������������
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}
					%>			  
              <tr>
                    <td class='title' style="font-size : 8pt;">���������</td>
                    <td colspan="6">&nbsp;
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;����ȣ : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;�����ڵ庰���� ���� : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[���������ݽ°�]</b>
					  &nbsp;���������� : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  �°躸���� : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum' >��
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  				<font color=red>(���������� ���� <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  			<%} %>		
        			</td>
              </tr>	
              <%}%>
              <tr>
                <td colspan="2" class='title'>���</td>
                <td colspan="6">&nbsp;
                  <textarea rows='5' cols='90' class=default name='fee_cdt'><%=fees.getFee_cdt()%></textarea></td>
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
	<%		}%>
	<%	}%>
	
		
	
	<tr>
	    <td align="right"><a href="javascript:update('12')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
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
                        <option value='6' <%if(fee.getFee_pay_st().equals("6")){%> selected <%}%>>ī��</option>
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
                  <tr>
                    <td class='title'>�ڵ���ü<% zip_cnt++;%>
                        <br><span class="b"><a href="javascript:search_cms('<%=zip_cnt%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                    </td>
                    <td colspan="5"><table width="100%" border="0" cellpadding="0">
        			  <tr>
        			    <td>&nbsp;
						  ���¹�ȣ : 
        			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='20' class='text'>
        			      (
        			      <input type='hidden' name="cms_bank" value="<%=cms.getCms_bank()%>">
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
						function openDaumPostcode4() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip4').value = data.zonecode;
									document.getElementById('t_addr4').value = data.address;
									
								}
							}).open();
						}
					</script>
    				  &nbsp;&nbsp;������ �ּ� : 
						<input type="text" name="t_zip"  id="t_zip4" size="7" maxlength='7' value="<%=cms.getCms_dep_post()%>">
						<input type="button" onclick="openDaumPostcode4()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr4" size="65" value="<%=cms.getCms_dep_addr()%>">
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
        			     <tr>
        			    <td>&nbsp;
					  ������������ :
    			      <input type='text' name='cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>

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
	<tr>
	    <td align="right"><a href="javascript:update('12_2')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
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
			  		if(AddUtil.parseInt(String.valueOf(tax_print_car.get("TOT_CNT")))>1 && client.getPrint_car_st().equals("") && !client.getPrint_st().equals("1") &&
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409") 
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
					   ){//'100','101','601','602','701','702','801','802','803','811','812'
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
	<tr>
	    <td align="right"><a href="javascript:update('13')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	
	<%	int scan_num = 0;
		String scan_mm = "";
		int scan_cnt = 0;%>
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
                  <td width="5%" class=title></td>
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
		<%	for(int f=1; f<=fee_size; f++){
					ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
					ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));%>	


        	<!-- �ڵ����뿩�̿��༭ �������� -->
        	
        	
        	<%if(AddUtil.parseInt(fees.getRent_dt()) > 20130701 && f==1 && !base.getReg_step().equals("")){%>
        	<%	scan_num++;%>        	
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp</td>		  
                  <td align="center">�ڵ����뿩�̿��༭</td>                  
                  <td align="center">
                      <%if(AddUtil.parseInt(base.getRent_dt()) > 20140228){%>
                      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                      <%}else{%>
		      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		      <%}%>
		  </td>
                  <td align="center"></td>
                  <td align="center"></td>		  
                </tr>	        	
        	<%}%>
        	
        	<%if(AddUtil.parseInt(fees.getRent_dt()) > 20130701 && f>1 && !base.getReg_step().equals("")){%>
        	<%	scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp</td>		  
                  <td align="center">�ڵ����뿩�̿��༭(����)</td>                  
                  <td align="center">
                      <%if(AddUtil.parseInt(base.getRent_dt()) > 20140228){%>
                      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                      <%}else{%>
		      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		      <%}%>
		  </td>
                  <td align="center"></td>
                  <td align="center"></td>		  
                </tr>	        	
        	<%}%>

        	
		<!--���ʰ�༭(pdf)-->			
                <% 	scan_num++; 
                	file_rent_st = Integer.toString(f);
                	file_st = "1";                
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 ){%><% scan_cnt++;%><font color=red>����</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   
                		

		<%			if(f==1 && AddUtil.parseInt(fee_etcs.getReg_dt()) >= 20100501){%>
		
		<!--�뿩�����İ�༭(��)-jpg����-->			
                <% 	scan_num++; 
                	file_rent_st = Integer.toString(f);
                	file_st = "17";                
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
                	file_rent_st = Integer.toString(f);
                	file_st = "18";                
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
                		
													
		<%			}%>
				
		<%	}//for end%>			
				
       		
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
			<%	//20140801���� �ʼ�
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
                

                	
		<!--CMS���Ǽ�jpg-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "38";                
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
                    <td align="center">CMS���Ǽ�tif/jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS���Ǽ�tif/jpg</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      

                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">          
                
                                       		
                       		
        		<tr>
	    			<td class=line2 colspan="6"></td>
				</tr>
				
		<%	if(!client.getClient_st().equals("2")){%>
		
		<!--����ڵ����jpg-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "2";                
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
                		
       		<%	}%>
        		
       		<%	if(scan_chk.equals("Y") && client.getClient_st().equals("1")){%>
       		
		<!--���ε��ε-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "3";                
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
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">      
                
		<!--�����ΰ�����-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "6";                
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
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                         		
       		
       		<%	}%>
        		
       		<%	if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){%>
       		<%	}else{%>
       		<%		if(scan_chk.equals("Y")){%>
       		
		<!--<%=scan_mm%>�ź���jpg-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "4";                
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
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
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
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">     
                
		<!--<%=scan_mm%>�ΰ�����-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "8";                
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
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                                        		
       				        		
       		<%		}%>
       		<%	}%>
       		

                <%	//���뺸���� ���񼭷�-----------------------------------
        		if(cont_etc.getGuar_st().equals("1")){
		%>
		
		<!--���뺸����-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "14";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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

		<!--����ڵ����/�ź���-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "11";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">       
                
		<!--���ε��ε/�ֹε�ϵ-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "12";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>"> 
                
		<!--�����ΰ�����/�ΰ�����-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "13";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
		
		
		<%	}%>	
		

		<!--����纻-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "9";                
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
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   
                 
		<%if(cont_etc.getInsur_per().equals("2")){%>
		
		<!--���谡��Ư�༭-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "19";                
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
                    <td align="center"><% scan_cnt++;%><font color=red>����</font></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  
                
		<!--����û�༭-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "36";                
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
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
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
 					
 					if(file_st.equals("1")||file_st.equals("2")||file_st.equals("3")||file_st.equals("4")||file_st.equals("5")||file_st.equals("6")||file_st.equals("7")||file_st.equals("8")||file_st.equals("9")||file_st.equals("10")||file_st.equals("11")||file_st.equals("12")||file_st.equals("13")||file_st.equals("14")||file_st.equals("15")||file_st.equals("17")||file_st.equals("18")||file_st.equals("19")||file_st.equals("20")||file_st.equals("36")||file_st.equals("37")) continue;
 					
 					scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">
                        <%if(file_st.equals("16")){%>���·�÷�μ���<%}%>
			<%if(file_st.equals("21")){%>��������׺����û��<%}%>					
			<%if(file_st.equals("22")){%>�뿩������׺����û��<%}%>
			<%if(file_st.equals("23")){%>�鼼��ǰ����Ű�<%}%>                    
			<%if(file_st.equals("24")){%>���ԽŰ�����<%}%>
			<%if(file_st.equals("31")){%>�ֿ����ڿ���������<%}%>
			<%if(file_st.equals("32")){%>�߰������ڿ���������<%}%>
			<%if(file_st.equals("33")){%>���������ε���<%}%>
			<%if(file_st.equals("34")){%>���������μ���<%}%>
			<%if(file_st.equals("35")){%>������<%}%>
                    </td>
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
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
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
		  <span class="b"><a href="javascript:scan_sys()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">[����ȭ]</a> (���� �ŷ�ó Ÿ��� ��ĵ���ϰ� ����ȭ)</span>		  
	</td>
    </tr>    
	<!--
    <tr> 
      <td colspan="2" align="right"><a href="javascript:scan_reg('')">��ĵ �߰� ���</a></td>
    </tr>	
	-->
	<%for(int i=1; i<=20; i++){//�Է°� ����%>
	<tr id=tr_chk<%=i%> style='display:none'>
	    <td><input type='text' name="chk<%=i%>" value='' size="100" class='redtext'></td>
	</tr>	
	<%}%>
	<%for(int i=1; i<=20; i++){//������%>
	<tr id=tr_sanc<%=i%> style='display:none'>
	    <td><input type='text' name="sanc<%=i%>" value='' size="100" class='chktext'></td>
	</tr>	
	<%}%>	    
	<%}%>
    <tr>
	    <td align='center'>	   
		 
	    <%String sanction_date = base.getSanction_date();
	  	if(sanction_date.length() > 0) sanction_date = sanction_date.substring(0,8);%>
		

	    <%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || base.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("�����ڸ��",user_id)){%>
	    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:update(99);" title='��ü �����ϱ�'><img src=/acar/images/center/button_all_modify.gif align=absmiddle border=0></a>
	    <%}%>
		
	    <%if(nm_db.getWorkAuthUser("������",user_id)){%>
		<%	if(base.getUse_yn().equals("") || base.getRent_start_dt().equals("")){%>
	    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:rent_delete();" title='��� �����ϱ�'>
	    <img src=/acar/images/center/button_delete.gif align=absmiddle border=0>
	    </a>
	    <%	}%>
	    <%}%>		
		
		
	    &nbsp;&nbsp;&nbsp;&nbsp;<font color="#999999">( �������� : ��������� �ִ� ��� OR ���ʿ����� OR ����� )</font>
	    </td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
	
    <tr>
        <td align='right'>
        
	  <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�������Ʈ���",user_id) || (base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("1")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("1"))){ %>	  
	    <a href="lc_reg_step2_rm.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp; 	    	    
          <%}%>	
          
	  <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�������Ʈ���",user_id) || (base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("3")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("2"))){%>	  
            <a href="lc_reg_step4_rm.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
          <%}%>	
          
          <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�������Ʈ���",user_id)){%>            
            <a href="lc_c_frame.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>	  	   
          <%}%>	
	
	<tr>
	    <td>&nbsp;</td>
    </tr>			
    		
	  
	    </td>
    </tr>
</table>
  <input type='hidden' name="zip_cnt" 			value="<%=zip_cnt%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	
	
	//�ٷΰ���
	var s_fm 	= parent.top_menu.document.form1;
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value 	= fm.client_id.value;
	s_fm.accid_id.value 	= "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";
	
	
//-->
</script>
</body>
</html>
