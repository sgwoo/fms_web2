<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.fee.*, card.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
		
	ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//����Ʈ����
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, rent_st);
	
	ContFeeBean feeb = new ContFeeBean();
		
	if(!rent_st.equals("1")){
		feeb = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(AddUtil.parseInt(rent_st)-1));	
	}
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));	
	
	//�����⺻����
	ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//����Ʈ����
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
		
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//�ſ�ī�� �ڵ����
	ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
	
	
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	

	
	//����ǰ��
	DocSettleBean commi_doc = d_db.getDocSettleCommi("1", rent_l_cd);
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	

	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	
	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	

	
	if(rent_st.equals("")) rent_st = "1";
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
		
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
		
	
	//���� üũ
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'�� ����'+len+'�� �ִ����'+max_len+'�� �ʰ��մϴ�.');
		}
	}
	
		



	
	//�뿩�Ⱓ ����
	function set_cont_date(){
		var fm = document.form1;
					
		fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value);
		
		<%if(cng_item.equals("fee")){%>	
		
		fm.v_con_mon.value = fm.con_mon.value;
		fm.v_con_day.value = fm.con_day.value;					
		
		set_sum_amt();	
		
		<%}%>
			

			
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;

		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
			
		fm.action='get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
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
		<%if(rent_st.equals("1")){%> 
		}else if(obj==fm.inv_s_amt){ 	//����뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			//dc_fee_amt();			
		}else if(obj==fm.inv_v_amt){ 	//����뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			//dc_fee_amt();
		}else if(obj==fm.inv_amt){ 	//����뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			//dc_fee_amt();	
		<%}else{%>			
		
		}else if(obj==fm.fee_s_amt){ 	//����뿩�� ���ް�
			obj.value = parseDecimal(obj.value);
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));									
			//dc_fee_amt();			
		}else if(obj==fm.fee_v_amt){ 	//����뿩�� �ΰ���
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			//dc_fee_amt();
		}else if(obj==fm.fee_amt){ 	//����뿩�� �հ�
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			//dc_fee_amt();	
		<%}%>
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
		
		var amt_per = 0;
		
		
		<%if(rent_st.equals("1")){%> 
		//���뿩�� �հ�
		fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) - toInt(parseDigit(fm.dc_s_amt.value)) + toInt(parseDigit(fm.navi_s_amt.value))+ toInt(parseDigit(fm.etc_s_amt.value)));
		fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) - toInt(parseDigit(fm.dc_v_amt.value)) + toInt(parseDigit(fm.navi_v_amt.value))+ toInt(parseDigit(fm.etc_v_amt.value)));
		fm.fee_amt.value   = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)) );
		<%}%>
		//�뿩�� �Ѿ�
		if(fm.v_con_mon.value == '1' && fm.v_con_day.value=='0'){
			fm.t_fee_s_amt.value = fm.fee_s_amt.value;
			fm.t_fee_v_amt.value = fm.fee_v_amt.value;
			fm.t_fee_amt.value   = fm.fee_amt.value;			
		}else{
			fm.t_fee_s_amt.value = parseDecimal_hun_th_rnd((toInt(parseDigit(fm.fee_s_amt.value))*toInt(fm.con_mon.value)) + (toInt(parseDigit(fm.fee_s_amt.value))/30*toInt(fm.con_day.value)));
			fm.t_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) * 0.1 );
			fm.t_fee_amt.value   = parseDecimal(toInt(parseDigit(fm.t_fee_s_amt.value)) + toInt(parseDigit(fm.t_fee_v_amt.value)) );			
		}
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
	function update(){
		var fm = document.form1;
		
		var cng_item = fm.cng_item.value;
		
		<% if(cng_item.equals("fee")){%>		
		

		<%}else if(cng_item.equals("deli")){%>		
		

		<%}else if(cng_item.equals("rent_start")){%>		
		
				
				if(toInt(fm.car_ret_chk.value) > 0)		{ alert('�뿩����-����ý��ۿ� ���� ��ó������ �ֽ��ϴ�. ���� ����ó���Ŀ� �뿩���� �Ͻʽÿ�.'); return; }
				if(fm.con_mon.value == '')			{ alert('�뿩����-�̿�Ⱓ�� �Է��Ͻʽÿ�.'); 				fm.con_mon.focus(); 		return; }
				if(fm.rent_start_dt.value == '')		{ alert('�뿩����-�뿩�������� �Է��Ͻʽÿ�.'); 			fm.rent_start_dt.focus(); 	return; }
				if(fm.rent_end_dt.value == '')			{ alert('�뿩����-�뿩�������� �Է��Ͻʽÿ�.'); 			fm.rent_end_dt.focus(); 	return; }				
				
				//[�Է°� üũ]1.�뿩������ ���纸�� �Ѵ��̻� ���̰� ���� �ȵȴ�.
				var est_day = getRentTime('m', fm.rent_start_dt.value, '<%=AddUtil.getDate()%>');				
				if( est_day > 1 || est_day < -1){ 
					alert('�Է��Ͻ� �뿩�������� ���糯¥�� �Ѵ��̻� ���̳��ϴ�.\n\nȮ���Ͻʽÿ�.'); 				fm.rent_start_dt.focus(); 	return; 
				}
				
				
				
					if(fm.fee_pay_tm.value == '')		{ alert('�뿩����-����Ƚ���� �Է��Ͻʽÿ�.'); 				fm.fee_pay_tm.focus(); 		return; }
					if(fm.fee_est_day.value == '')		{ alert('�뿩����-�������ڸ� �Է��Ͻʽÿ�.'); 				fm.fee_est_day.focus(); 	return; }
					if(fm.fee_pay_start_dt.value == '')	{ alert('�뿩����-���ԱⰣ�� �Է��Ͻʽÿ�.'); 				fm.fee_pay_start_dt.focus();	return; }
					if(fm.fee_pay_end_dt.value == '')	{ alert('�뿩����-���ԱⰣ�� �Է��Ͻʽÿ�.'); 				fm.fee_pay_end_dt.focus(); 	return; }
					
					if(fm.fee_fst_dt.value == '')			{ alert('�뿩����-1ȸ���������� �Է��Ͻʽÿ�.'); 			fm.fee_fst_dt.focus(); 		return; }
				
					//[�Է°� üũ]2.ùȸ���������� �뿩�����Ϻ��� Ŭ���� ����.
					est_day = getRentTime('d', fm.rent_start_dt.value, fm.fee_fst_dt.value);
					if( est_day < -2){ 
						alert('�Է��Ͻ� ùȸ���������� �뿩�����Ϻ��� �۽��ϴ�. \n\nȮ���Ͻʽÿ�.');					fm.fee_fst_dt.focus(); 		return;
					}				
					if( est_day > 10){ 
						alert('�Է��Ͻ� ùȸ���������� �뿩�����Ϻ��� 10�� �̻� ���̰� ���ϴ�. \n\nȮ���Ͻʽÿ�.');					fm.fee_fst_dt.focus(); 		return;
					}							
					
					if(fm.cms_type[0].checked == false && fm.cms_type[1].checked == false){		
						alert('2ȸ�� û������� �����Ͻʽÿ�.'); return;
					}
					
										
		<%}else if(cng_item.equals("pay_way")){%>					
			
			<%if(f_fee_rm.getCms_type().equals("cms")){%>
				
			if(fm.cms_acc_no.value == '')		{ alert('�ڵ���ü-���¹�ȣ�� �Է��Ͻʽÿ�.'); 				fm.cms_acc_no.focus(); 		return; }
			if(fm.cms_acc_no.value != '')			{ 
				fm.cms_acc_no.value = replaceString(" ","",fm.cms_acc_no.value);
				if ( !checkInputNumber("CMS ���¹�ȣ", fm.cms_acc_no.value) ) {		
					fm.cms_acc_no.focus(); 		return; 
				}
				//�޴���,����ó ���Ͽ��� Ȯ��
				if(replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getM_tel()%>") || replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getO_tel()%>")){
					alert("���¹�ȣ�� �޴��� Ȥ�� ����ó�� �����ϴ�. ������¹�ȣ�� �ڵ���ü�� �ȵ˴ϴ�.");
					fm.cms_acc_no.focus(); 		return; 
				}
			}
			if(fm.cms_bank_cd.value == '')	{ alert('�ڵ���ü-������ �Է��Ͻʽÿ�.'); 				fm.cms_bank_cd.focus(); 		return; }
			if(fm.cms_dep_nm.value == '')		{ alert('�ڵ���ü-�����ָ� �Է��Ͻʽÿ�.'); 				fm.cms_dep_nm.focus(); 		return; }
					
			<%}%>
			
		<%}else if(cng_item.equals("pay_way3")){%>
				
			if(fm.c_cms_acc_no.value != '')		{ 
				fm.c_cms_acc_no.value = replaceString(" ","",fm.c_cms_acc_no.value);
				if ( !checkInputNumber("ī���ȣ", fm.c_cms_acc_no.value) ) {		
					fm.c_cms_acc_no.focus(); 		return; 
				}
			}
			
		<%}%>

				
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_c_u_rm_a.jsp';		
			fm.target='i_no';
			//fm.target = '_blank';
			
			//if(fm.user_id.value == '000029') fm.target='_blank';
			
			fm.submit();
		}							
		
		
		
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

	function search_card_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("search_card_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
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
				
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='lc_b_u_rm_a.jsp' name="form1" method='post'>
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
  <input type='hidden' name='cng_item'	 		value='<%=cng_item%>'>     
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_st"			value="<%=base.getCar_st()%>">  
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name='client_id' 		value="<%=base.getClient_id()%>">
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">      
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="idx"			value="">  
  <input type='hidden' name="scan_cnt"			value="">    
  <input type='hidden' name="chk_cnt"			value="">    
  <input type='hidden' name="est_from"			value="lc_c_u">      
  <input type='hidden' name="fee_rent_st"		value="">        
  <input type='hidden' name="car_no" 			value="<%=cr_bean.getCar_no()%>">      
  <input type='hidden' name="c_firm_nm" 		value="<%=client.getFirm_nm()%>">      
  <input type='hidden' name="c_client_nm" 		value="<%=client.getClient_nm()%>">      
  
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
	<%if(cng_item.equals("deli")){%>	
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
                <td width="13%"  class=title>��������Ÿ�</td>
                <td colspan='3'>&nbsp;<input type='text' name='sh_km' size='3' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(f_fee_etc.getSh_km())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>km</td>
              </tr>                   
              <tr> 
                <td width="13%"  class=title>�����ð�</td>
    <%
	if(f_fee_rm.getDeli_plan_dt().length() == 12){
		plan_dt = f_fee_rm.getDeli_plan_dt().substring(0,8);
		plan_h 	= f_fee_rm.getDeli_plan_dt().substring(8,10);
		plan_m	= f_fee_rm.getDeli_plan_dt().substring(10,12);
	}
    %>                
                <td width="37%">&nbsp;<input type='text' size='11' name='deli_plan_dt' maxlength='10' class='default' value='<%=AddUtil.ChangeDate2(plan_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
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
                <td width="37%">&nbsp;<input type='text' size='30' name='deli_loc' class='default' value='<%=f_fee_rm.getDeli_loc()%>' onBlur="javscript:set_loc(this.value, 'deli');">
                      </td>
                <td width="13%" class=title>�������</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='ret_loc' class='default' value='<%=f_fee_rm.getRet_loc()%>' onBlur="javscript:set_loc(this.value, 'ret');">
                      </td>
              </tr>          
            </table>
        </td>
    </tr>	
    <tr>
        <td>* ��/���� ��� ��ȣ �ڵ��Է� : 1 - ����������, 2 - �������� ������, 3 - �λ����� ������, 4 - �������� ������, 5 - �뱸���� ������ </td>
    </tr>          	
	
	
	<%}%>

	<%if(cng_item.equals("fee")){%>	
  <input type='hidden' name='rent_st' 			value='<%=rent_st%>'> 	
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name='sh_amt' 			value='<%=fee_etcs.getSh_amt()%>'> 
  <input type='hidden' name='amt_per' 			value='<%=fee_rm.getAmt_per()%>'> 

	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee style="display:''"> 
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
                        <option value='<%=user.get("USER_ID")%>' <%if(fee_etcs.getBus_agnt_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>			  
                </tr>
    		<%}else{%>
                <tr>
                    <td width="13%" align="center" class=title>�����ε���</td>
                    <td colspan='5'>&nbsp;
        			  <input type="text" name="car_deli_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                    </td>			  
                </tr>			
			<%}%>
                <tr>
                    <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id) || nm_db.getWorkAuthUser("�����ٺ�������",ck_acar_id)){%><%}else{%>readonly<%}%> size="4" maxlength="2" class='text' onChange='javascript:set_cont_date()'>
            			 ����
            		<input type='text' name="con_day" value='<%=fee_etcs.getCon_day()%>' <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id) || nm_db.getWorkAuthUser("�����ٺ�������",ck_acar_id)){%><%}else{%>readonly<%}%> size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 ��		 
            	    </td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id) || nm_db.getWorkAuthUser("�����ٺ�������",ck_acar_id)){%><%}else{%>readonly<%}%> size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date();'></td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td>&nbsp;
                    <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ٻ�����",user_id) || nm_db.getWorkAuthUser("�����ٺ�������",ck_acar_id)){%><%}else{%>readonly<%}%> size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title'>����</td>
                    <td class='title' width='11%'>���ް�</td>
                    <td class='title' width='11%'>�ΰ���</td>
                    <td class='title' width='14%'>�հ�</td>
                    <td class='title' width='4%'>�Ա�</td>			
                    <td width="27%" class='title'>�������</td>
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
              <%if(fees.getRent_st().equals("1")){%>          
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
                <td align='center'>-</td>
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
              <%}else{%>
              <tr>
                <td colspan="2" class='title'>���뿩��</td>
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
              <%}%>
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
        	    <input type='text' name="v_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 ��</td>
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
    		    <%if(rent_st.equals("1")){
					//�������������
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}%>
                <tr>
                    <td colspan="2" class='title'>���������</td>
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
			
<script language="JavaScript">
<!--		
	var fm = document.form1;
//-->
</script>	
	<%} %>	

	<%if(cng_item.equals("rent_start")){
			
			int car_ret_chk = 0;
			
			//�縮���϶� ����ý��� �������� Ȯ��
			if(base.getCar_gu().equals("0")){
				car_ret_chk = rs_db.getCarRetChk(base.getCar_mng_id());
			}
			
			%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span> (<font color=red>*</font>�ʼ��Է�)</td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<input type='hidden' name="rent_way"			value="<%=fees.getRent_way()%>">
	<input type='hidden' name="car_ret_chk"			value="<%=car_ret_chk%>">
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='fix' onBlur='javascript:set_cont_date()'>����
                        <input type='text' name="con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='fix' onChange='javascript:set_cont_date()'>��	
        	    </td>
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
                <tr>
                    <td width="13%" class='title'>1ȸ��������<font color=red>*</font></td>
                    <td width="20%">&nbsp;
                        <input type='text' name='fee_fst_dt' value='<%=fee.getFee_fst_dt()%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value); set_cont_date();'>
        		    </td>
                    <td width="10%" class='title'>1ȸ�����Ծ�</td>
                    <td colspan="3">&nbsp;
        			  <input type='text' name='fee_fst_amt' value='<%=AddUtil.parseDecimal(fee.getFee_fst_amt())%>' maxlength='10' size='10' class='num'>��
                    </td>
                </tr>		
                <tr>
                    <td width="10%" class='title'>2ȸ��û�����<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type='radio' name="cms_type" value='card' checked>
     				  �ſ�ī��
      			  <input type='radio' name="cms_type" value='cms'>
      			  CMS 
					</td>
                </tr>
                
                <%	//�����뿩������ �뿩Ƚ�� �ִ밪
			int max_fee_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd);
			if(max_fee_tm==0){%>
                <tr>
                    <td width="10%" class='title'>�����ٻ�������<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="scd_reg_yn" value="Y" checked>
					</td>
                </tr>                
                <%	}%>
                <tr>
                    <td width="10%" class='title'>�ȳ����ڿ���<font color=red>*</font></td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="sms_reg_yn" value="Y" checked onclick="return false;" >
					</td>
                </tr>                
                
            </table>
	    </td>
	</tr>	
    <tr>
	    <!--<td>* �� ������ڿ��� ��������� ������ ���� ���ڸ� �����ϴ�. ([����Ʈ] 00000(������ȣ) �뿩�������� 000, ���� ����ڴ� 000, ����ó�� 000 �Դϴ�. (��)�Ƹ���ī)</td>-->
	     <td>* �� ������ڿ��� �Ƹ���ī ����Ʈ ���� ���ǻ��� �ȳ� ���ڸ� �����ϴ�.(�ʼ�)</td>
	    <td></td>
	</tr>	

	
	<%} %>	
	
	
	
	<%if(cng_item.equals("pay_way")){%>		
	<tr id=tr_fee3 >
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ڵ���ü</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>						
    <tr id=tr_fee2> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		  <%if(cms.getApp_dt().equals("") || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("CMS����",user_id) || nm_db.getWorkAuthUser("��ݴ��",user_id)){%>
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
    												if(cms.getCms_bank().equals("")){
    													//�ű��ΰ�� �̻������ ����
   														if(bank.getUse_yn().equals("N"))	 continue;
    								%>
                    <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}else{%>
                    <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                    <%			}%>
                    <%		}
    										}
    								%>
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
    			      &nbsp;&nbsp;������ �ּ� : 
					  
					  <input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=cms.getCms_dep_post()%>">
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="50" value="<%=cms.getCms_dep_addr()%>">
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
        			    <tr>
        			    <td>&nbsp;������������ :
    			      <input type='text' name='cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>

    			     

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
	
	
	<%if(cng_item.equals("pay_way3")){%>		
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
										document.getElementById('t_zip').value = data.zonecode;
										document.getElementById('t_addr').value = data.address;
										
									}
								}).open();
							}
						</script>
						<br>
    			      &nbsp;��û�� �ּ� : 
					  <input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��">
					  <input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=card_cms.getCms_dep_post()%>">
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="50" value="<%=card_cms.getCms_dep_addr()%>">
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
		

    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>	
    <tr>
	    <td align='center'>
	        <%if(cng_item.equals("pay_way") && !cms.getApp_dt().equals("")){%>	
	        
	        <%}else{%>
	        <%    if(!auth_rw.equals("1")){%>
	  	<a href='javascript:update();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	  	&nbsp;
	  	<%    }%>
	  	<%}%>
	  	<a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
			  	</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	fm.fee_fst_amt.value = '<%=AddUtil.parseDecimal(f_fee_rm.getF_rent_tot_amt())%>';
//-->
</script>
</body>
</html>
