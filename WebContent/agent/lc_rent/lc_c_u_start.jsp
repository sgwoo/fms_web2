<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.con_ins.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase"      scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean"             scope="page"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>

<%@ include file="/agent/cookies.jsp" %>

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
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
			
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);	
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
		
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
	
	if(fee.getPp_s_amt()==0 && !fee.getPp_chk().equals(""))  fee.setPp_chk("");
	
				
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
			
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();		
	
	//�����ε��� - Ź�� �뿩�����ε� Ź������ ������.
        if(cont_etc.getCar_deli_dt().equals("")){
        	cont_etc.setCar_deli_dt(cs_db.getContCarDeliDt(rent_mng_id, rent_l_cd));
        }	

	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}	
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
	}			
	
	String car_ins_chk = "N";
	
	if(!ins.getCar_mng_id().equals("")){
		car_ins_chk = "Y";
	}
	
	int car_ret_chk = 0;
			
	//�縮���϶� ����ý��� �������� Ȯ��
	if(base.getCar_gu().equals("0")){
		car_ret_chk = rs_db.getCarRetChk(base.getCar_mng_id());
	}
			
	//����ý��� �������� �̹����� Ȯ�� : ���̿�����
	Vector rs_conts = rs_db.getTarchaNoRegSearchList(base.getClient_id());
	int rs_cont_size = rs_conts.size();
	
	//����ý��� �������� �̹����� Ȯ�� : ��࿬����
	Vector rs_conts2 = rs_db.getTarchaNoRetSearchList(base.getRent_l_cd());
	int rs_cont_size2 = rs_conts2.size();
	
	//����ý��� �������� �̹����� Ȯ�� : ����ȣ���� ��������� �̵�Ϻ�
	Vector rs_conts3 = rs_db.getTarchaNoRegSearchList2(base.getRent_l_cd());
	int rs_cont_size3 = rs_conts3.size();		
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";
	String scan17 = "";
	String scan18 = "";


	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	

	Vector attach_vt2 = new Vector();
	int attach_vt_size2 = 0;	
	
	content_code = "LC_SCAN";
	content_seq  = rent_mng_id+""+rent_l_cd+"1"+"17";

	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size = attach_vt.size();	
		
	if(attach_vt_size > 0){
		for (int j = 0 ; j < attach_vt_size ; j++){
    			Hashtable ht = (Hashtable)attach_vt.elementAt(j);   
    			scan17 = String.valueOf(ht.get("FILE_NAME"));
    	}
    }		
	content_code = "LC_SCAN";
	content_seq  = rent_mng_id+""+rent_l_cd+"1"+"18";

	attach_vt2 = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size2 = attach_vt2.size();	
		
	if(attach_vt_size2 > 0){
		for (int j = 0 ; j < attach_vt_size2 ; j++){
    			Hashtable ht = (Hashtable)attach_vt2.elementAt(j);   
    			scan18 = String.valueOf(ht.get("FILE_NAME"));
    		}
    	}	
    	
    //�����۾�������
	Vector fee_scd = ScdMngDb.getFeeScdClient(base.getClient_id());
	int fee_scd_size = fee_scd.size();		
	
	if(fee_scd_size > 10) fee_scd_size = 10;    	
		
	String com_dir_pur_doc_yn = "";
	String com_dir_pur_doc_reg_yn = "";
	String com_dir_pur_doc_no = "";
	if(base.getCar_gu().equals("1") && AddUtil.parseInt(base.getRent_dt()) >= 20190610 && client.getClient_st().equals("1") && cm_bean.getCar_comp_id().equals("0001") && pur.getDir_pur_yn().equals("Y") && !pur.getPur_bus_st().equals("4")){ //���ΰ� ����Ư����� ������Ʈ���� ����
		com_dir_pur_doc_yn = "Y";
		//����ǰ��
		DocSettleBean doc17 = d_db.getDocSettleCommi("17", rent_l_cd);
		com_dir_pur_doc_no = doc17.getDoc_no();
		if(doc17.getDoc_no().equals("")){
			com_dir_pur_doc_reg_yn = "N";
		}
	}	
	
	//������ �Աݻ���
	String pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "1");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//���ΰ�ħ
	function reload(){
		var fm = document.form1;			
		fm.action='lc_c_u_start.jsp';
		fm.target='d_content';
		fm.submit();
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
	
	function cng_input(idx){
		var fm = document.form1;		
		if(idx == 1){
			tr_fee_type1.style.display	= '';
			tr_fee_type2.style.display	= 'none';
			tr_fee_type3.style.display	= 'none';
			fm.end_chk.value		= 'N';
		}else if(idx == 2){
			tr_fee_type1.style.display	= 'none';
			tr_fee_type2.style.display	= '';
			tr_fee_type3.style.display	= 'none';
			fm.end_chk.value		= 'N';
		}else if(idx == 3){
			tr_fee_type1.style.display	= 'none';
			tr_fee_type2.style.display	= 'none';
			tr_fee_type3.style.display	= '';
			fm.end_chk.value		= 'Y';
		}
		
		//set_start_date(2);
	}	
		
	//�����ٻ��� �Ⱓ ����
	function set_start_date(idx){
		var fm = document.form1;
	
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == '') || (fm.rent_end_dt.value == ''))
			return;

		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') 	return;
		if(ChangeDate4_chk(fm.rent_end_dt, fm.rent_end_dt.value)=='') 		return;		
		//if(fm.reg_type[1].checked == true && fm.fee_est_day3.value == '')	return;
		
		if(idx == 1)	fm.fee_fst_dt3.value = '';
		
		fm.end_chk.value		= 'N';
								
		fm.action='get_fee_start_nodisplay.jsp';
		fm.target='i_no';
		//fm.target='_blank';
		fm.submit();
	}	
	
	//����ȭ��
	function update2(st, rent_st){
		var height = 600;
		window.open("/agent/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM2", "left=150, top=150, width=1050, height="+height+", scrollbars=yes");
	}	
	
	//����
	function update(){
		var fm = document.form1;
		
		var cng_item = fm.cng_item.value;

		<%if(fee.getPp_s_amt() > 0 && fee.getPp_chk().equals("0") && !pp_pay_st.equals("�Ա�")){%>
			alert('�����ݱյ�����̸� �������� �ϳ��Ǿ�� �մϴ�.');	return; 
		<%}%>		
		
		<%	if(com_dir_pur_doc_yn.equals("Y") && com_dir_pur_doc_reg_yn.equals("N")){%>
			alert('���ΰ� �ڵ��� �������� Ȱ�� ������ ���� ����Ͻʽÿ�.'); 	return; 
		<%  } %>
		
				
		//jpg ��༭ ��(scan17)/��(scan18) ��ĳ�� ���� üũ - �̵�Ͻ� �뿩���ø��� - ��ĳ���� ������ȣ,  �뿩�������� ���� �Է��Ͽ� ��ĳ���� �� 
		<% if(scan17.equals("")  || scan18.equals("")  ){ %>
			alert('������ȣ�� �뿩�������� �߰��Ͽ� ��༭ ��/�ڸ� JPG�� ��ĵ��� �� �뿩���ø� ó���� �� �ֽ��ϴ�.\n\nȮ���Ͻʽÿ�.'); 	return; 
		<%} %>
		
		<%if(base.getCar_mng_id().equals("")){%>	
		  	alert('���� ������ ��ϵ��� �ʾҽ��ϴ�. ������� �� ������ �� �ֽ��ϴ�.'); 	
		  	return; 			
		<%}%>
				
		//���谡�Ե�� üũ
		<%if(car_ins_chk.equals("N")){%>
			alert('���谡�Ե���� �ȵǾ��ֽ��ϴ�. �������ڿ��� Ȯ���Ͻʽÿ�.');	return; 
		<%}%>
		
		
		if(toInt(fm.car_ret_chk.value) > 0)		{ alert('����ý��ۿ� ���� ��ó������ �ֽ��ϴ�. ���� ����ó���Ŀ� �뿩���� �Ͻʽÿ�.'); return; }
		
		if(<%=rs_cont_size%> > 0){
			if(!confirm('����ý���-���������� ���� ��ó������ �ֽ��ϴ�(����� �̿�����). �ϴ� �������� �̹��� ����Ʈ���� ��������� ������ �� �ֽ��ϴ�. �뿩���� �����Ͻðڽ��ϱ�?')){	return;	}
		}		

		if(<%=rs_cont_size2%> > 0){
			alert('����ý���-���������� ���� ��ó������ �ֽ��ϴ�(����� ������). ���� ����ó���Ŀ� �뿩���� �Ͻʽÿ�.'); return;
		}		
		
		if(<%=rs_cont_size3%> > 0){
			alert('����ý���-���������� ����ȣ ������ �Ǿ����� ������-������������� ���ԷµǾ����ϴ�. ���� ������������� �Է��Ͻʽÿ�.'); return;
		}	
		
		
		
		if(fm.con_mon.value == '')			{ alert('�뿩����-�̿�Ⱓ�� �Է��Ͻʽÿ�.'); 				fm.con_mon.focus(); 		return; }
		if(fm.rent_start_dt.value == '')		{ alert('�뿩����-�뿩�������� �Է��Ͻʽÿ�.'); 			fm.rent_start_dt.focus(); 	return; }
		if(fm.rent_end_dt.value == '')			{ alert('�뿩����-�뿩�������� �Է��Ͻʽÿ�.'); 			fm.rent_end_dt.focus(); 	return; }				
			
		//����
		<%if(base.getRent_st().equals("3") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){%>
		//[�Է°� üũ]1.�뿩������ ���纸�� 4�����̻� ���̰� ���� �ȵȴ�.---�����Ī�����϶�!
		var est_day = getRentTime('m', fm.rent_start_dt.value, '<%=AddUtil.getDate()%>');				
		if( est_day > 5 ||est_day < -5){ 
			alert('�Է��Ͻ� �뿩�������� ���糯¥�� 4�����̻� ���̳��ϴ�.\n\nȮ���Ͻʽÿ�.'); 				fm.rent_start_dt.focus(); 	return; 
		}
		<%}else{%>			
		//[�Է°� üũ]1.�뿩������ ���纸�� �Ѵ��̻� ���̰� ���� �ȵȴ�.
		var est_day = getRentTime('m', fm.rent_start_dt.value, '<%=AddUtil.getDate()%>');				
		if( est_day > 1 || est_day < -1){ 
			alert('�Է��Ͻ� �뿩�������� ���糯¥�� �Ѵ��̻� ���̳��ϴ�.\n\nȮ���Ͻʽÿ�.'); 				fm.rent_start_dt.focus(); 	return; 
		}
		<%}%>
								
		<%if(!fee.getFee_chk().equals("1") && !fee.getPp_chk().equals("0") ){%>
		
			if(fm.reg_type[0].checked == false && fm.reg_type[1].checked == false){	alert('�뿩�ὺ���� ������ �����Ͻʽÿ�.');	return;}
			
			/*
			if(fm.reg_type[0].checked == true){

				if(fm.fee_est_day1.value == '')		{ alert('1�뿩�ὺ���� ������ �����Ͻʽÿ�.');		 	return; }
				if(fm.fee_pay_start_dt1.value == '')	{ alert('2�뿩�ὺ���� ������ �����Ͻʽÿ�.');		 	return; }
				if(fm.fee_pay_end_dt1.value == '')	{ alert('3�뿩�ὺ���� ������ �����Ͻʽÿ�.');		 	return; }
				if(fm.fee_fst_dt1.value == '')		{ alert('4�뿩�ὺ���� ������ �����Ͻʽÿ�.');		 	return; }
				if(fm.fee_fst_amt1.value == '')		{ alert('5�뿩�ὺ���� ������ �����Ͻʽÿ�.');		 	return; }
				if(fm.fee_lst_dt1.value == '')		{ alert('6�뿩�ὺ���� ������ �����Ͻʽÿ�.');		 	return; }
				if(fm.fee_lst_amt1.value == '')		{ alert('7�뿩�ὺ���� ������ �����Ͻʽÿ�.');		 	return; }
			
				//[�Է°� üũ]2.ùȸ���������� �뿩�����Ϻ��� Ŭ���� ����.
				est_day = getRentTime('d', fm.rent_start_dt.value, fm.fee_fst_dt1.value);
				if( est_day < 0){ 
					alert('�Է��Ͻ� ùȸ���������� �뿩�����Ϻ��� �۽��ϴ�. \n\nȮ���Ͻʽÿ�.');			return;
				}									
				
			}else 
			*/
			if(fm.reg_type[0].checked == true){

				ChangeDate4(fm.fee_fst_dt3, fm.fee_fst_dt3.value);
				
				if(fm.fee_est_day2.value == '')		{ alert('1������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 			return; }
				if(fm.fee_pay_start_dt2.value == '')	{ alert('2������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 			return; }
				if(fm.fee_pay_end_dt2.value == '')	{ alert('3������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 			return; }
				if(fm.fee_fst_dt2.value == '')		{ alert('4������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 			return; }
				if(fm.fee_fst_amt2.value == '')		{ alert('5������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 			return; }
				if(fm.fee_lst_dt2.value == '')		{ alert('6������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 			return; }
				if(fm.fee_lst_amt2.value == '')		{ alert('7������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 			return; }

				if(fm.fee_est_day3.value == '')		{ alert('8������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 			return; }
				if(fm.fee_pay_start_dt3.value == '')	{ alert('9������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 			return; }
				if(fm.fee_pay_end_dt3.value == '')	{ alert('10������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 		return; }
				if(fm.fee_fst_dt3.value == '')		{ alert('11������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 		return; }
				if(fm.fee_fst_amt3.value == '')		{ alert('12������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 		return; }
				if(fm.fee_lst_dt3.value == '')		{ alert('13������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 		return; }
				if(fm.fee_lst_amt3.value == '')		{ alert('14������ ���뿩�� �������ڸ� �����Ͻʽÿ�.'); 		return; }
				
				if(toInt(parseDigit(fm.fee_fst_amt3.value)) == 0){ alert('1ȸ���뿩�� ���Աݾ��� Ȯ���Ͻʽÿ�.'); 		return; }
				
				//[�Է°� üũ]2.ùȸ���������� �뿩�����Ϻ��� Ŭ���� ����.
				est_day = getRentTime('d', fm.rent_start_dt.value, fm.fee_fst_dt3.value);
				if( est_day < 0){ 
					alert('�Է��Ͻ� ùȸ���������� �뿩�����Ϻ��� �۽��ϴ�. \n\nȮ���Ͻʽÿ�.');			return;
				}				
				
				//[�Է°� üũ]3.ùȸ���������� ���ó�¥�� 7���̻� ���̰� ���� �Ѵ�.
				est_day = getRentTime('d', '<%=AddUtil.getDate(4)%>', fm.fee_fst_dt3.value);
				
				if( est_day < 7){ 
					alert('�Է��Ͻ� ùȸ���������� ���ú��� 7�����Ŀ��� �մϴ�. \n\nȮ���Ͻʽÿ�.');			return;
				}					
			
			}else if(fm.reg_type[1].checked == true){
				if(fm.etc.value == '')			{ alert('�������� ������ �Է��Ͻʽÿ�.'); 			fm.etc.focus(); 		return; }
			}										
			
			if(fm.end_chk.value == 'N')			{ alert('�뿩�ὺ���� ���� �缱�� �� �������� �缱���� �ʿ��մϴ�.'); 				return; }
				
		<%}%>
		
			
										
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			fm.action='lc_c_u_start_a.jsp';		
			fm.target='i_no';
			fm.submit();
			
			link.getAttribute('href',originFunc);
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
	
	//��ĵ���� ����
	function view_scan(){
		window.open("scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
	
	//���ΰ� �ڵ��� �������� Ȱ�� ���� ����
	function reg_doc(doc_no, doc_st){
		window.open("doc_com_dir_pur.jsp?doc_no="+doc_no+"&doc_st="+doc_st+"&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "VIEW_DOC", "left=100, top=0, width=650, height=950, scrollbars=yes");		
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

<form action='lc_c_u_start_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='from_page'	 		value='/agent/lc_rent/lc_c_u_start.jsp'>   
  <input type='hidden' name='cng_item'	 		value='<%=cng_item%>'>     
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_way"			value="<%=fee.getRent_way()%>">
  <input type='hidden' name="fee_amt"			value="<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>">
  <input type='hidden' name="fee_s_amt"			value="<%=fee.getFee_s_amt()%>">
  <input type='hidden' name="fee_v_amt"			value="<%=fee.getFee_v_amt()%>">
  <input type='hidden' name="ifee_amt"			value="<%=fee.getIfee_s_amt()+fee.getIfee_v_amt()%>">
  <input type='hidden' name="pere_r_mth"		value="<%=fee.getPere_r_mth()%>">  
  <input type='hidden' name="car_ret_chk"		value="<%=car_ret_chk%>">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="end_chk"			value="N">
  
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>���� �뿩���� �� ������ ����</span></span></td>
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
                    <td class=title width=15%>����ȣ</td>
                    <td width=35%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=15%>��ȣ</td>
                    <td width=35%>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title>����</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                </tr>
                <tr> 
                    <td class=title>���ô뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>��&nbsp;
                    	<%if(fee.getIfee_s_amt()>0 && fee.getFee_s_amt()>0){%>
                    	(<%=(fee.getIfee_s_amt()+fee.getIfee_v_amt())/(fee.getFee_s_amt()+fee.getFee_v_amt())%>ȸ)
                    	<%}%>
                    </td>
                    <td class=title>������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>��</td>
                </tr>
                <tr> 
                    <td class=title>���뿩�ᳳ�Թ��</td>
                    <td>&nbsp;<%if(fee.getFee_chk().equals("0")){%>�ſ�����<%}else if(fee.getFee_chk().equals("1")){%>�Ͻÿϳ�<%}else{%>-<%}%></td>
                    <td class=title>�����ݰ�꼭���౸��</td>
                    <td>&nbsp;<%if(fee.getPp_chk().equals("1")){%>�����Ͻù���<%}else if(fee.getPp_chk().equals("0")){%>�ſ��յ����<%}else{%>-<%}%></td>
                </tr>
    	    </table>
	</td>
    </tr>  
    <%	if(com_dir_pur_doc_yn.equals("Y")){%>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ΰ� �ڵ��� �������� Ȱ�� ����</span></td>
	</tr>  	
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=15%>��Ͽ���</td>
                    <td>&nbsp;
	<%		if(com_dir_pur_doc_reg_yn.equals("N")){%>
	        	�̵��  &nbsp;<a href ="javascript:reg_doc('','17')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
	<%		}else{ %>	
	                     ���  &nbsp;<a href ="javascript:reg_doc('<%=com_dir_pur_doc_no%>','17')"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a>			
	<%		} %>    
        	    </td>
                </tr>	
    		</table>
	    </td>
	</tr> 	        
    <%	}%>  
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ĵ</span>
	        &nbsp;<a href ="javascript:view_scan()"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a>
	    </td>
	</tr>  			
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=15%>�뿩�����İ�༭(��)</td>
                    <td width=35%>&nbsp;
                    <%	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					 					
                    %>                    
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
        	    <%}%>
        	    </td>
                    <td class=title width=15%>�뿩�����İ�༭(��)</td>
                    <td width=35%>&nbsp;
                    <%  if(attach_vt_size2 > 0){
				for (int j = 0 ; j < attach_vt_size2 ; j++){
 					Hashtable ht = (Hashtable)attach_vt2.elementAt(j);     					 					
                    %>
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
        	    <%}%>         
        	    </td>
                </tr>	
    		</table>
	    </td>
	</tr> 	    
<%		if(fee_scd_size>0){%>  
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=client.getFirm_nm()%> ������� ���࿹���� Ȯ��</span></td>
	</tr>     
    <tr>
        <td class=line2></td>
    </tR>			
	<tr>
	    <td  class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td class='title'>������ȣ</td>
                    <td class='title'>����</td>					
                    <td class='title'>ȸ��</td>
                    <td colspan="2" class='title'>���Ⱓ</td>
                    <td class='title'>���뿩��</td>
                    <td class='title'>���࿹����</td>
                    <td class='title'>��������</td>
                    <td class='title'>�Աݿ�����</td>
                </tr>
        <%			for(int j = 0 ; j < fee_scd_size ; j++){
        				Hashtable ht = (Hashtable)fee_scd.elementAt(j);%>
                <tr>
                    <td width="15%" align="center"><%=ht.get("CAR_NO")%></td>
                    <td width="15%" align="center"><%=ht.get("CAR_NM")%></td>					
                    <td width="10%" align="center"><%=ht.get("FEE_TM")%></td>
                    <td width="10%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="10%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��&nbsp;&nbsp;</td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                </tr>
<%			}%>
            </table>
	    </td>
    </tr>
<%		}%>     	  
    <tr>
	<td align="right">&nbsp;</td>
    <tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩����</span></td>
    </tr>
    <tr>
	<td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="15%" align="center" class=title>�뿩�Ⱓ</td>
                    <td width="35%">&nbsp;
                        <input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='fix' onBlur='javascript:set_cont_date()'>����
                    </td>
                    <%
                    	
                    %>
                    <td width="15%" class='title'>�����ε���</td>
                    <td width="35%">&nbsp;
                        <input type='text' name='car_deli_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>			
                        &nbsp;(Ź�ۿ�û�� ����Ʈ)
		    </td>
                </tr>
                <tr>                        
                    <td align="center" class=title>�뿩������</td>
                    <td>&nbsp;
                        <input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate4(this, this.value); set_cont_date();'>
                    </td>
                    <td align="center" class=title>�뿩������</td>
                    <td>&nbsp;
                        <input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate4(this, this.value);'>
                    </td>
                </tr>
            </table>
	</td>
    </tr>
 	    	 
    <tr>
	<td>&nbsp;</td>
    </tr>
				  <input type='hidden' name='fee_pay_tm' 		value='<%=fee.getFee_pay_tm()%>'>  
				  <input type='hidden' name='fee_est_day' 		value='<%=fee.getFee_est_day()%>'>  
				  <input type='hidden' name='fee_fst_dt' 		value='<%=fee.getFee_fst_dt()%>'>  
				  <input type='hidden' name='fee_fst_amt' 		value='<%=fee.getFee_fst_amt()%>'>  
				  <input type='hidden' name='fee_pay_start_dt' 		value='<%=fee.getFee_pay_start_dt()%>'>  
				  <input type='hidden' name='fee_pay_end_dt' 		value='<%=fee.getFee_pay_end_dt()%>'>
	<%if(fee.getFee_chk().equals("1") || fee.getPp_chk().equals("0") ){%>
    <tr>
	<td><font color=red>* ���뿩�ᳳ�Թ���� �Ͻÿϳ��̰ų� ������ ���յ����� �Դϴ�. �ѹ��� �����ٴ���ڰ� ������ �뿩�Ḧ �����մϴ�.</font></td>
    </tr>	    
				  <input type='hidden' name='reg_type' 		value='3'>
    <%}else{%>        
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�� ������ ����</span></td>
    </tr>    
    <tr>
	<td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <!--<td width="33%" align="center" class=title><input type='radio' name="reg_type" value='1' onClick="javascript:cng_input(1)"> �뿩�����ϰ� �������ڰ� ����</td>-->
                    <td width="50%" align="center" class=title><input type='radio' name="reg_type" value='2' onClick="javascript:cng_input(2)"> �������ں���(���Ұ��)</td>
                    <td width="50%" align="center" class=title><input type='radio' name="reg_type" value='3' onClick="javascript:cng_input(3)"> �뿩�� ����/�л�û�� �� �л곳��(���߽�����)</td>
                </tr>
            </table>
	</td>
    </tr>  
    <tr>
	<td>&nbsp;</td>
    </tr>
    <tr id=tr_fee_type1 style='display:none'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                   
                <tr>
                    <td rowspan='2' width="15%" class='title'>���뿩��</td>
                    <td width="10%" class='title'>��������</td>
                    <td width="75%">&nbsp;
                        �ſ�
                        <select name='fee_est_day1'>
                            <option value="">����</option>
                            <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                            <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                            <% } %>
                            <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> ���� </option>
			    <option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> �뿩������ </option>
                        </select>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>���ԱⰣ</td>
                    <td>&nbsp;
                        <input type='text' name='fee_pay_start_dt1' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        		~
    			<input type='text' name='fee_pay_end_dt1' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>1ȸ���뿩��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_dt1' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>                        
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>���Աݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_amt1' value='' maxlength='10' size='10' class='whitenum'>��
                        <input type='hidden' name='fee_fst_amt1_etc' value=''>   
                     </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>������ȸ���뿩��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_dt1' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>���Աݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_amt1' value='' maxlength='10' size='10' class='whitenum'>��
                        <input type='hidden' name='fee_lst_amt1_etc' value=''>   
                    </td>
                </tr>	                                	  		  		  		  
            </table>
	</td>
    </tr>  
    <tr id=tr_fee_type2 style='display:none'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%> 
                <tr>
                    <td colspan='3' class='title'>������</td>
                    <td colspan='3' class='title'>������</td>
                </tr>                              
                <tr>
                    <td rowspan='2' width="15%" class='title'>���뿩��</td>
                    <td width="10%" class='title'>��������</td>
                    <td width="25%">&nbsp;
                        �ſ�
                        <select name='fee_est_day2'>
                            <option value="">����</option>
                            <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                            <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>�� </option>
                            <% } %>
                            <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> ���� </option>
			    <option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> �뿩������ </option>
                        </select>
                    </td>
                    <td rowspan='2' width="15%" class='title'>���뿩��</td>
                    <td width="10%" class='title'>��������</td>
                    <td width="25%">&nbsp;
                        �ſ�
                        <select name='fee_est_day3'>
                            <option value="">����</option>
                            <%	for(int i=1; i<=31 ; i++){ //1~31�� %>
                            <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%>  <%}%>><%=i%>�� </option>
                            <% } %>
                            <option value='99' <%if(fee.getFee_est_day().equals("99")){%>  <%}%>> ���� </option>
			    <option value='98' <%if(fee.getFee_est_day().equals("98")){%>  <%}%>> �뿩������ </option>
                        </select>
                        &nbsp;<a href="javascript:set_start_date('1')" onMouseOver="window.status=''; return true" title="�뿩�� ���ڰ���մϴ�."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>���ԱⰣ</td>
                    <td>&nbsp;
                        <input type='text' name='fee_pay_start_dt2' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        		~
    			<input type='text' name='fee_pay_end_dt2' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                    <td class='title'>���ԱⰣ</td>
                    <td>&nbsp;
                        <input type='text' name='fee_pay_start_dt3' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        		~
    			<input type='text' name='fee_pay_end_dt3' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>1ȸ���뿩��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_dt2' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                    <td rowspan='2' class='title'>1ȸ���뿩��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_dt3' value='' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value); set_start_date(2);'>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>���Աݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_amt2' value='' maxlength='10' size='10' class='whitenum'>��
                     </td>
                    <td class='title'>���Աݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_amt3' value='' maxlength='10' size='10' class='whitenum'>��
                        <input type='hidden' name='fee_fst_amt3_etc' value=''>  
                     </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>������ȸ���뿩��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_dt2' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                    <td rowspan='2' class='title'>������ȸ���뿩��</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_dt3' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>���Աݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_amt2' value='' maxlength='10' size='10' class='whitenum'>��
                    </td>
                    <td class='title'>���Աݾ�</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_amt3' value='' maxlength='10' size='10' class='whitenum'>��
                        <input type='hidden' name='fee_lst_amt3_etc' value=''>  
                    </td>
                </tr>	                                	  		  		  		  
            </table>
	</td>
    </tr>            
    <tr id=tr_fee_type3 style='display:none'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                   
                <tr>
                    <td colspan='2' class='title'>��������(�ѹ���) �޽��� �߼�</td>                    
                </tr>		  		  		  		                                    	  		  		  		  
                <tr>
                    <td width="15%" class='title'>����</td>                    
                    <td>&nbsp;
                        <textarea rows='5' cols='90' name='etc'></textarea>                        
                    </td>                    
                </tr>		  		  		  		                                    	  		  		  		  
            </table>
	</td>
    </tr>      
    <%}%>
    
    
    <tr>
	<td>&nbsp;</td>
    </tr>    	
    
    <%		if(com_dir_pur_doc_yn.equals("Y") && com_dir_pur_doc_reg_yn.equals("N")){%>
    <tr>
	<td><font color=red>* ���ΰ� �ڵ��� �������� Ȱ�� ������ ���� ����Ͻʽÿ�.</font></td>
    </tr>	    
    <% 		}%>
    
    <%		if(fee.getPp_s_amt() > 0 && fee.getPp_chk().equals("0") && !pp_pay_st.equals("�Ա�")){%>
    <tr>
	<td><font color=red>* �����ݱյ�����̸� �������� �ϳ��Ǿ�� �մϴ�.</font></td>
    </tr>	        
    <%		}%>    
        
    <% 		if(scan17.equals("")  || scan18.equals("")  ){ %>
    <tr>
	<td><font color=red>* ������ȣ�� �뿩�������� �߰��Ͽ� ��༭ ��/�ڸ� JPG�� ��ĵ��� �� �뿩���ø� ó���� �� �ֽ��ϴ�.</font></td>
    </tr>	    
    <% 		}%>
    
    <% 		if(base.getCar_mng_id().equals("")){ %>
    <tr>
	<td><font color=red>* ���� ������ ��ϵ��� �ʾҽ��ϴ�. ������� �� ������ �� �ֽ��ϴ�.</font></td>
    </tr>	    
    <% 		}%>    
        
    <%		if(car_ret_chk>0){%>
    <tr>
	<td><font color=red>* ����ý��ۿ� [<%=cr_bean.getCar_no()%>]���� ���� ��ó������ �ֽ��ϴ�. ���� ����ó���Ŀ� �뿩�����Ͻʽÿ�.</font></td>
    </tr>	
    <%		}%>	
    
    <%		if(rs_cont_size2>0){%>
    <tr>
	<td><font color=red>* ����ý��ۿ� �������� ���� ��ó������ �ֽ��ϴ�. ���� ����ó���Ŀ� �뿩�����Ͻʽÿ�.</font></td>
    </tr>	
    <%		}%>	    
    
    <%		if(rs_cont_size3>0){%>
    <tr>
	<td><font color=red>* ����ý���-���������� ����ȣ ������ �Ǿ����� ������-������������� ���ԷµǾ����ϴ�. ���� ������������� �Է��Ͻʽÿ�.</font></td>
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
    
    <%		if(rs_cont_size3>0){%>
    <tr>
	<td><font color=red>* ����������� �̵�Ϻ��� �ֽ��ϴ�.</font></td>
    </tr>	
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����������� �̵�� ����Ʈ</span></td>
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
        	<%	for(int i = 0 ; i < rs_cont_size3 ; i++){
        					Hashtable rs_ht = (Hashtable)rs_conts3.elementAt(i);%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=rs_ht.get("CAR_NO")%></td>
                    <td align='center'><%=rs_ht.get("CAR_NM")%></td>					
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(rs_ht.get("DELI_DT")))%></td>
                    <td align='center'>���������
                    <%if(ta_vt_size==0){ %>
                    <a href="javascript:update2('taecha_info','')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%}else{ %>
                    <a href="javascript:update2('taecha','0')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%} %>
                    </td>
                </tr>
        	<%	} %>
            </table>
        </td>
    </tr>			
    <%		}%>

    <tr>
	<td>* �� ������ڿ��� ��������� ������ ���� ���ڸ� �����ϴ�. (00000(������ȣ) ���� ����ڴ� 000, ����ó�� 000 �Դϴ�. (��)�Ƹ���ī)</td>
    </tr>	
        
    <%		if(car_ins_chk.equals("N")){%>
    <tr>
	<td><font color=red>* FMS�� ���� ����� �ȵ� �����̹Ƿ� ������ ����ȳ����ڸ� ���� �� �����ϴ�. ������ �Ϸ��� ����ó���Ͻʽÿ�.</font></td>
    </tr>		
    <%		}else{%>
    <tr>
	<td>* �� ������ڿ��� ���迡 ���� ���ڸ� �����ϴ�. (������ 0000 1588-****, ����⵿�� ����Ÿ�ڵ��� 1588-6688 �Դϴ�. (��)�Ƹ���ī)</td>
    </tr>		
    <%		}%>	
    
    <tr>
	<td align='center'>&nbsp;</td>
    </tr>	
    <tr>
	<td align='center'>
	    <a href='javascript:update();' id="submitLink" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	    &nbsp;
	    <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 		
	    
	    
	    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    <a href="javascript:reload()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_reload.gif align=absmiddle border=0></a> 		
	    
	</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	var ifee_tm = toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
	if(ifee_tm>0){
		fm.pere_r_mth.value = ifee_tm;
	}
//-->
</script>
</body>
</html>
