<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*,  acar.receive.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.credit.*, acar.fee.*, acar.car_sche.*, acar.doc_settle.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "08", "05");
	
	String s_kd 	= request.getParameter("s_kd")==null? "5":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
		
		
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
		
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
		//fee ��Ÿ - ����Ÿ� �ʰ��� ���  - fee_etc ��  over_run_amt > 0���� ū ��� �ش��
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	ClsEtcOverBean co = ac_db.getClsEstOver(rent_mng_id, rent_l_cd);
	
	
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
		//���ǿ���
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();	
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//����� ����Ʈ
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
		
		//�����Ƿ�����
	ClsEstBean cls = ac_db.getClsEstCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st();
	
		
	//�⺻����
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls.getCls_dt(), "");
		
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;			
					
	//������ ���ݰ�꼭
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
	
	int re_day= ac_db.getRemainFeeDay(rent_l_cd, fee_tm, cls.getCls_dt());
	
	from_page = "/fms2/cls_cont/lc_cls_est_u.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
		
	Vector cms_bnk = c_db.getCmsBank();	//������� �����´�.
	int cms_bnk_size1 = cms_bnk.size();
	
	//cms ����

	Hashtable h_cms = c_db.getCmsBank_info(rent_l_cd);
	
	String re_bank = "";
	String re_acc_no = "";
	String re_acc_nm = "";
		
	re_bank = (String)h_cms.get("CBNK");
	re_acc_no = (String) h_cms.get("CBNO");
	re_acc_nm = (String) h_cms.get("CYJ");	
	
	//�������� ����Ʈ
	Vector vt_ext = as_db.getClsList(base.getClient_id());
	int vt_size = vt_ext.size();
	
		//��Ÿ��� ���񺸻�
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id() , "N" );		
				
	Hashtable  return1 =   new Hashtable();	
 
	String return_remark = "";
	
	//   ��Ÿ�� , ȥ�ٴ� ���Կɼ��϶��� �ش� 
   if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "N");	
	  	return_remark = (String)return1.get("REMARK");
  }
  
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "CLS_ETC";
	String content_seq  = rent_mng_id+""+rent_l_cd;

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	
	
	//��Ÿ���ع��� ����üũ	
     	content_seq  = rent_mng_id+""+rent_l_cd+"2";
     attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
     int attach2_vt_size =  attach_vt.size();	
          
     //���ݼ����ΰ�� üũ	
     	content_seq  = rent_mng_id+""+rent_l_cd+"4";
     attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
     int attach4_vt_size =  attach_vt.size();	
    
        //car_price 
  	int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  - car.getDc_cs_amt() - car.getDc_cv_amt(); 

	float f_opt_per = 0;     
		
	ClsEtcAddBean clsa 	= ac_db.getClsEstAddInfo(rent_mng_id, rent_l_cd);
	
	int vt_size8 = 0;
		
	Vector vts8 = ac_db.getClsEstDetailList(rent_mng_id,  rent_l_cd);
	vt_size8 = vts8.size(); 	
	
	 CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;   	
	
%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
	var popObj = null;
<!--

//��ĵ���� ����
	function view_scan(m_id, l_cd){	
	  window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
		
	}		
			
	//�ڵ����絵���� �μ�
	function opt_print(){
		var fm = document.form1;
	
		var SUBWIN="/acar/off_ls_after/car_transfer_certificate.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=820, height=600, resizable=yes, scrollbars=yes, status=yes");
				
	}

//���꼭 �μ�
	function cls_print(){
		var fm = document.form1;
	
		var SUBWIN="lc_cls_est_print.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(SUBWIN, "clsPrint", "left=100, top=10, width=700, height=650, resizable=yes, scrollbars=yes, status=yes");
				
	}

//����Ʈ
	function list(){
		var fm = document.form1;			
	
		fm.action = 'lc_cls_est_frame.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//�� ����
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//�뿩���
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=50, top=50, width=850, height=675, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//���ǿ��� ��༭
	function view_scan_res2(c_id, m_id, l_cd){
		window.open("/fms2/lc_rent/lc_im_doc_print.jsp?c_id="+c_id+"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&mode=fine_doc", "VIEW_SCAN_RES2", "left=100, top=100, width=750, height=700, scrollbars=yes");		
	}	
				
	//������ ����
	function sac_delete() {
		var fm = document.form1;
					
		if(confirm('�������꼭�� �����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_est_d_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}	
		
	}	
		
	
	//���÷��� Ÿ��
	function cls_display(){
		var fm = document.form1;
	
		fm.fdft_amt3.value='0';
			
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //���Կɼ� ���ý� ���÷���
			tr_opt.style.display 		= '';  //���Կɼ�			
			tr_sale.style.display		= '';	//�����Ű��� �����Ծ�
		
		} else if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '7'){ //���������(����) ���ý� ���÷���
	
			tr_opt.style.display 		= 'none';	//���Կɼ�			
			tr_sale.style.display		= 'none';	//�����Ű��� �����Ծ�				
		}else{
			tr_opt.style.display 		= 'none';	//���Կɼ�		
			tr_sale.style.display		= 'none';	//�����Ű��� �����Ծ�			
			
		}
				
		set_init();
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
		fm.fdft_amt3.value='0';  //�����Ű�
	   		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){
			fm.opt_per.value=fm.mopt_per.value;
			fm.opt_amt.value=fm.mopt_amt.value;
			set_sui_amt();
		}
		
	}	
	
	//���÷��� Ÿ��
	function cls_display3(){
		var fm = document.form1;
		 
		if(fm.div_st.options[fm.div_st.selectedIndex].value == '2'){
			td_div.style.display 	= '';
		}else{
			td_div.style.display 	= 'none';
		}
	}	
		
	//���÷��� Ÿ��
	function cancel_display(){
	   //�����Ա��� 0���� ���� ���: ������ ���� �ִ� ��츸 ���������� �� ����.
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[1].selected = true;
			alert('�ߵ���������ݾ��� '+fm.fdft_amt2.value+'������ ȯ���ؾ� �մϴ�. \n\n�̿� ���� ��쿡�� ������Ҹ� �����մϴ�.');
			return;			
		}		
	}	
			
	//�����ݾ� ���� : �ڵ����
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		if(obj == fm.ifee_mon || obj == fm.ifee_day){ //���ô뿩�� ����Ⱓ
			if(fm.ifee_s_amt.value != '0'){		
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );		
		
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //�ܾ�
							
			}
			
		}else if(obj == fm.ifee_ex_amt){ //���ô뿩�� ����ݾ�
			if(fm.ifee_s_amt.value != '0'){		
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );				
			}
		}else if(obj == fm.pded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		
		if(fm.pp_s_amt.value != '0') {
	 	  	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //������
	    		fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;
	    	}   
	    }	
				
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // �����ݾ��� ����� ��� (���Ⱓ�� ����� ��� - ��������� )
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
				
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		
		 //���ô뿩�ᰡ �� ����� ��� �ܿ����ô뿩��� �̳��뿩�ῡ�� ó��
	    if(fm.ifee_s_amt.value != '0') {
	    	 
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
	    		
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
	    	}   
	    	
	    	set_init();	  
	    }	
			
		set_cls_s_amt();
	}	
	
		//�̳� �뿩�� ���� : �ڵ����
	function set_cls_amt2(obj){
		var fm = document.form1;
								
		obj.value=parseDecimal(obj.value);
	
		if(obj == fm.nfee_mon || obj == fm.nfee_day){ //�̳��Դ뿩�� �Ⱓ
										
			//�ܿ����ô뿩�� 
			if(fm.ifee_s_amt.value != '0'){
				ifee_tm = parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			//	ifee_tm = toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value)) ;
				
				pay_tm = toInt(fm.con_mon.value)-ifee_tm;
				if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
					fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
					fm.ifee_day.value 	= fm.r_day.value;
				}
			
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
						
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //�ܾ�
							
			}
			
			  //���ô뿩�ᰡ �� ����� ��� �ܿ����ô뿩��� �̳��뿩�ῡ�� ó��
		    if(fm.ifee_s_amt.value != '0') {
	    	 
		    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
		    		
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 
		      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
		    	}   
		    }		
			
				//�뿩 �������� �����ȵǰ�, �̳��� ���� ��� scd_fee�� ��� nfee_mon, nfee_day ���Ҽ� ����.
		   if(fm.ifee_s_amt.value == '0' ) {	
			   if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ �ȵ� ��� 
				 if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { 
				   	     //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
			   	 // 	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //����ϼ� ǥ��
			   	 	  if (toInt(fm.r_con_mon.value) > 0) {  
			   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //������ - �������� ���� ��
			   	  	  } else {  //������������ ���  (���ô뿩�ᰡ �ִ� ���)
			   	  	  	 fm.nfee_mon.value = '0';
			   	  	  } 
			   	   	  
			   	   	  if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_e_dt.value) ) { // �����ϰ� ������ ������ ��	   	  	  	    	  	   
		  	   	     	fm.nfee_day.value 	= 	fm.r_day.value;
		  	   	   	  } 
		  	   	   	  
		  	   	   	  if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) {	  	   	      	     
				  	   	   var s1_str = fm.use_e_dt.value;
						   var e1_str = fm.cls_dt.value;
						   var  count1 = 0;
							
						   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1, s1_str.substring(6,8) );
						   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );
				
						   var diff1_date = e1_date.getTime() - s1_date.getTime();
				
						   count1 = Math.floor(diff1_date/(24*60*60*1000));
							
				  	   	   if ( count1 >= 0 ) { // �뿩�Ḹ���ϰ� ������ �� (������ü�ϼ� ���)	   	  	  	    	  	   
				  	   	     fm.nfee_day.value 	= 	count1;
				  	   	   } 
				  	  }	  	   	   	 
				 }
				
			  } else { //�������� ������ ������ �� ���
		   
			      if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� ���� ���
				   	     //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
				   	 
			   	//  	   if (toInt(fm.r_con_mon.value) > 0) {  
				//   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //������ - �������� ���� ��
				//   	   } else {  //������������ ���  (���ô뿩�ᰡ �ִ� ���)
				//   	  	  	 fm.nfee_mon.value = '0';
				 //  	   } 
		   	  	  
		   	  	  	   if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) { // �����ϰ� ������ ������ ��	   	  	  	    	  	   
			  	   	     fm.nfee_day.value 	= 	fm.r_day.value;
			  	   	   } 			   
			      }
			  }		
				
			}			
			
							
			//�̳��ݾ�  - ���ô뿩�ᰡ �ִ� ��� ���ô뿩�Ḹŭ �������� �̻���, ������ ���� �������� ������ ���̶�� ������ ������� �̳��ݾ� ����ϰ�,
			//            ������ �������� ���� ���� ������ô�Ḧ ����Ͽ� �̳��ݾ��� �����
							 
		    fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
	
			// ���ô뿩�� �ִ� ��쿡 ����. (�������� �뿩�Ⱓ�� ����� ��쿡 ���� )
		   	if(fm.ifee_s_amt.value != '0' ) {
								
		   		if (v_rifee_s_amt < 0) {  //���ô뿩�Ḧ �� ������ ���
		   	    	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
						
			   	    if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
			   	    //       alert(" ���ô뿩�� ����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// �ѹ̳��ῡ�� - ���ô뿩�� ����
			   	       }else {
			   	      //     alert(" ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���
			   	       //	   alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
			   	           fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
			   	    
			   	      
			   	      }else {
			   	       //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");
			   	       	   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_rifee_s_amt ) ; 
			   	      	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //����ϼ� ǥ��
			   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
			   	       }
			   	   }
			    } else {  //���ô뿩�ᰡ �����ִ� ���
			        if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
			   	    //   	   alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����
			   	       }else {
			   	    //       alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� ���� ���");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //�������� �뿩�� �������� ������ �ȵ� ��� - ��� ���ô뿩�� ����Ͽ� �̳��� ǥ�� 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���
			   	     //      alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");
			   	           fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����   	   
			   	      }else {
			   	     //      alert(" ���ô뿩�� �ܾ�����, ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����̾��� ���");
			   	       	   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ; 
			   	
			   	       }
			   	    }
			    }   
		   	} 		   		 	
						
		}
				
			//������ �� ���Աݰ��� vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} 
		
		if ( fm.ex_di_amt_1.value == fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = fm.ex_di_v_amt.value ;
		}
			
		//vat��� (�뿩��)
		var no_v_amt = 0;
	
	  //  no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
	   	no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)   + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)      -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		 	     
		var no_v_amt2 	 = no_v_amt;
		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt2) );		
		
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
			
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
			
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}	
									
		if ( fm.tax_chk3.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 
		}				
		
	//	if ( fm.tax_chk4.checked == true) {
	//			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
	//			 
	//	}	
			
	//	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
			
		set_cls_s_amt();
	}	
			
	//�̳� �ߵ���������� ���� : �ڵ����
	function set_cls_amt3(obj){
		var fm = document.form1;
	//	obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //�ܿ��뿩���Ⱓ
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
			}
		}else if(obj == fm.dft_int_1){ //����� �������
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			
			}			
		}
		
		//fm.dfee_amt.value					= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		
		set_cls_s_amt();
	}
	
			
	
	//������Ϻ��(���Կɼ�)
	function set_sui_c_amt(){
	
		var fm = document.form1;
							
		if (fm.cls_st.value  == '8' ) {
		  fm.dft_amt.value = '0'; //�ߵ����������
		  fm.dft_amt_1.value = '0'; //�ߵ����������Ȯ��
		}  
				
		set_cls_s_amt();
	
	}	
	
	//������Ϻ��(���Կɼ�)
	function set_sui_amt(){
	
		var fm = document.form1;
				
	//	fm.sui_d_amt.value 		= parseDecimal( hun_th_rnd(toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value))));
				
		set_cls_s_amt();	
	}	
						
	//Ȯ���ݾ� ����
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
	
		/*
	   if(obj == fm.dft_amt_1){ //�ߵ�����
			fm.tax_supply[0].value 	= obj.value;
			if (fm.tax_chk0.checked == true) {
	 				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );		 		
			} else {
					fm.tax_value[0].value 	= '0';				
			}				
		
		}else if(obj == fm.etc_amt_1){ //ȸ�����ֺ��
			fm.tax_supply[1].value 	= obj.value;
			if (fm.tax_chk1.checked == true) {
				 fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 fm.tax_value[1].value 	= '0';
			}		
		
		}else if(obj == fm.etc2_amt_1){ //ȸ���δ���
			fm.tax_supply[2].value 	= obj.value;
			if (fm.tax_chk2.checked == true) {
					fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[2].value 	= '0';
			}		
		
		}else if(obj == fm.etc4_amt_1){ //��Ÿ���ع���
			fm.tax_supply[3].value 	= obj.value;			
			if (fm.tax_chk3.checked == true) {
				 	fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[3].value 	= '0';
			}
			
	//	}else if(obj == fm.over_amt_1){ //�ʰ�����δ�� ����		 
		}else 
		*/	
	    if(obj == fm.m_over_amt){ //�ʰ�����δ�� ����		 
					
    		fm.j_over_amt.value =  toInt(parseDigit(fm.r_over_amt.value)) - toInt(parseDigit(obj.value)) ;  
    		
    		if (  toInt(parseDigit(fm.j_over_amt.value)) > 0) {
    		
				fm.over_amt.value =  '0';  
				fm.over_amt_1.value =  fm.j_over_amt.value ;  			
				fm.tax_supply[4].value 	=  fm.j_over_amt.value;					
				fm.tax_chk4.value  = 'Y' ;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );
		  } else {
		 		fm.over_amt.value =  '0';  
				fm.over_amt_1.value =  '0' ;  			
				fm.tax_supply[4].value 	=  '0';					
				fm.tax_chk4.value  = 'N' ;
				fm.tax_value[4].value 	= '0';		  		  
		  }		
						
		}	
								
		var no_v_amt = 0;
		
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	 
	
	//	 no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		 no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  +   ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1) -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt) );				
		
		/*
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
			
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
			
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}	
									
		if ( fm.tax_chk3.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 
		}
		*/
		
	//	if ( fm.tax_chk4.checked == true) {
	//			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
	//			 
	//	}		
			
		set_cls_s_amt();
						
		//ä������ ����
		if ( toInt(parseDigit(fm.fdft_amt2.value)) > 0)	{	
			tr_get.style.display		= '';	//ä�����ڱ�å
		} else {
		
			tr_get.style.display		= 'none';	//ä�����ڱ�å
		}		
			
	}	
	
	//Ȯ���ݾ� ����
	function set_cls_s_amt(){
		var fm = document.form1;	
							
	//	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	//  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
	  	fm.dfee_amt.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) +  toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))   + toInt(parseDigit(fm.over_amt.value))   + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) +  toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))   + toInt(parseDigit(fm.over_amt_1.value))   + toInt(parseDigit(fm.no_v_amt_1.value)));	 //Ȯ���ݾ�	
			
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		 		 	
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));					
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));						
		}  
						
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
				
	}	
		
	
	//��������û���ܾ�
	function set_gi_amt(){
		var fm = document.form1;
		
		if ( toInt(parseDigit(fm.gi_c_amt.value))  > 0  ) {
			if ( toInt(parseDigit(fm.fdft_amt2.value))  > 0  ) {
				fm.gi_j_amt.value 		= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.gi_c_amt.value)));
			}
		}
		if ( toInt(parseDigit(fm.gi_j_amt.value)) < 0  ) {
				fm.gi_j_amt.value  = "0";
		}
		
		fm.est_amt.value 		= fm.gi_j_amt.value;
		
	}	
	
	//����ȸ�����
	function set_etc_amt(){
		var fm = document.form1;
		
		fm.etc_out_amt.value 		= parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)) + toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		fm.etc_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
	
		fm.etc_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		set_cls_s_amt();
			
	}
			
	
		//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/cls/"+theURL;
		popObj =window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}
			
	//����� �������ڷ� �ٽ� ���
	function set_day(){
		var fm = document.form1;	
		
		if(fm.cls_dt.value == ''){ 	alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_dt.focus(); 	return;	}
	
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}	
		
		fm.action='./lc_cls_c_nodisplay.jsp';						
				
		fm.target='i_no';
		fm.submit();
	}		
	
	//Ư�̻���  ����
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
		//���� ������
	function sendMail(m_id, l_cd){
		window.open("/acar/car_rent/rent_email_reg.jsp?pur_email=cls_est&mtype=cls_est&m_id="+m_id+"&l_cd="+l_cd+"&br_id=S1", "RentDocEmail", "left=100, top=100, width=700, height=500, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
	//���ԿɼǾȳ��� ���Ϲ߼� -�������꼭�� ��� 
	function view_mail(m_id, l_cd){
			window.open("/acar/car_rent/rent_email_reg.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=S1&pur_email=pur_opt&mtype=est", "RentDocEmail", "left=100, top=100, width=1000, height=700, scrollbars=yes, status=yes");		
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
<form action='' name="form1" method='post'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 	value='<%=andor%>'>
<input type='hidden' name='car_st' 	value='<%=base.getCar_st()%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name="fee_size"			value="<%=fee_size%>">    
<input type='hidden' name='rent_start_dt' value='<%=base1.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base1.get("RENT_END_DT")%>'>  
<input type='hidden' name='car_mng_id' value='<%=base1.get("CAR_MNG_ID")%>'>
<input type='hidden' name="mode" 			value="<%=mode%>">     
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 
<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'> 
<input type='hidden' name='car_no' value='<%=base1.get("CAR_NO")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
				
<input type='hidden' name='con_mon' value='<%=base1.get("CON_MON")%>'>

<input type='hidden' name="from_page" 	value="<%=from_page%>">

<input type='hidden' name='cls_s_amt' value='<%=AddUtil.parseDecimal(cls.getCls_s_amt())%>' >
<input type='hidden' name='cls_v_amt' value='<%=AddUtil.parseDecimal(cls.getCls_v_amt())%>' >
  
<input type='hidden' name="re_day" 		value="<%=re_day%>">  
<input type='hidden' name='car_ja_no_amt' value='<%=AddUtil.parseDecimal(cls.getCar_ja_no_amt())%>' >
 
<input type='hidden' name='ex_di_v_amt'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
<input type='hidden' name='ex_di_v_amt_1' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--�����ϱ��� ������Ⱓ -->            

  <!--�ʰ����� �Ÿ� ��� -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='over_run_day' value='<%=car1.getOver_run_day()%>'>
  
<input type='hidden' name='sh_km' value=''>
  

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	 <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>�������� > �������� ><span class=style5>�������꼭 ǰ��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    <!-- �������꼭���� ǥ�� -->
    	<td align='right'> &nbsp;   
        <a href="javascript:sendMail('<%=rent_mng_id%>', '<%=rent_l_cd%>');"><img src="/acar/images/center/button_send_mail.gif" align=absmiddle border=0></a>&nbsp;   
        <a href='javascript:cls_print();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_print_jss.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
	    </td>
	</tr>
	  
	<tr> 
        <td class=line2></td>
    </tr>	
  
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>����ȣ</td>
            <td width=22%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;<a href="javascript:view_cng_etc('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='Ư�̻���'><img src=/acar/images/center/button_tish.gif align=absmiddle border=0></a>
               &nbsp;<a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='��ĵ����'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
            </td>
            <td class=title width=10%>��������</td>
            <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
            <td class=title width=10%>��������</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
          </tr>
          <tr> 
            <td class=title>���ʿ�����</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
            <td class=title>�����븮��</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
            <td class=title>���������</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
          </tr>
          <tr>
            <td class=title>�������</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
            <td class=title>��౸��</td>
            <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>�ű�<%}else if(rent_st.equals("3")){%>���� <%}else if(rent_st.equals("4")){%>���� <%}%></td>
            <td class=title>��������</td>
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ� <%}else if(bus_st.equals("2")){%>������� <%}else if(bus_st.equals("3")){%>��ü�Ұ� <%}else if(bus_st.equals("4")){%>catalog <%}else if(bus_st.equals("5")){%>��ȭ��� <%}else if(bus_st.equals("6")){%>������ü <%}else if(bus_st.equals("7")){%>������Ʈ <%}else if(bus_st.equals("8")){%>����� <%}%></td>
          </tr>
          <tr> 
            <td class=title>��������</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮�� <%}else if(car_gu.equals("1")){%>���� <%}else if(car_gu.equals("2")){%>�߰��� <%}%></td>
            <td class=title>�뵵����</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ <%}else if(car_st.equals("2")){%> ���� <%}else if(car_st.equals("3")){%> ���� <%}else if(car_st.equals("5")){%>�����뿩 <%}%></td>
            <td class=title>��������</td>
            <td>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻�� <%}%></td>
          </tr>
          <tr>
            <td class=title>��ȣ</td>
            <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a></td>
            <td class=title>��ǥ��</td>
            <td>&nbsp;<%=client.getClient_nm()%></td>
            <td class=title>����/����</td>
            <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=site.getR_site()%></a></td>
          </tr>
          <tr>
            <td class=title>������ȣ</td>
            <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a></td>
            <td class=title width=10%>����</td>
            <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
			<font color="#999999">(�����ڵ�:<%=cm_bean.getJg_code()%>)</font>
			</td>
          </tr>		  
        </table>
	  </td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
          <tr>
            <td style="font-size : 9pt;" width="3%" class=title rowspan="2">����</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">�������</td>
            <td style="font-size : 9pt;" width="6%" class=title rowspan="2">���Ⱓ</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 9pt;" width="7%" class=title rowspan="2">�����</td>
            <td style="font-size : 9pt;" width="9%" class=title rowspan="2">���뿩��</td>
            <td style="font-size : 9pt;" class=title colspan="2">������</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">������</td>
            <td style="font-size : 9pt;" class=title colspan="2">���ô뿩��</td>
            <td style="font-size : 9pt;" class=title colspan="2">���Կɼ�</td>
          </tr>
          <tr>
            <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 9pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 9pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 9pt;" width="3%" class=title>%</td>			
          </tr>
		  <%for(int i=0; i<fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				if(!fees.getCon_mon().equals("")){
				
				s_opt_per = fees.getOpt_per();
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
				
				f_opt_per  = (float) s_opt_amt  / car_price * 100 ;
			   			 			   
			   f_opt_per =  AddUtil.parseFloatCipher(f_opt_per,1);
				%>	
          <tr>
            <td style="font-size : 9pt;" align="center"><%=i+1%></td>
            <td style="font-size : 9pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
            <td style="font-size : 9pt;" align="center"><%=fees.getCon_mon()%>����</td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°� <%}else if(fees.getGrt_suc_yn().equals("1")){%>���� <%}else{%>-<%}%></td>			
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°� <%}else if(fees.getIfee_suc_yn().equals("1")){%>���� <%}else{%>-<%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%=f_opt_per%></td>
          </tr>
		  <%}}%>
        </table>
	  </td>
	</tr>
	<tr>
	    <td></td>
	</tr>
	
		<%if(im_vt_size>0){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ǿ���</span> <a href="javascript:view_scan_res2('<%=base.getCar_mng_id()%>','<%=base.getRent_mng_id()%>','<%=base.getRent_l_cd()%>')" onMouseOver="window.status=''; return true"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="���ǰ�༭ ����"></a></td>
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
	  <td style='height:1; background-color=d2d2d2;' ></td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
	 <tr> 
 	 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������&nbsp;
 			 
 		 </span></td>
  	  </tr> 
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='13%' class='title'>��������</td>
            <td width="13%">&nbsp; 
			  <select name="cls_st" disabled >
			    <option value="1" <%if(cls.getCls_st().equals("��ุ��"))%>selected<%%>>��ุ��</option>          
                <option value="2" <%if(cls.getCls_st().equals("�ߵ��ؾ�"))%>selected<%%>>�ߵ��ؾ�</option>
                <option value="7" <%if(cls.getCls_st().equals("���������(����)"))%>selected<%%>>���������(����)</option>
                <option value="8" <%if(cls.getCls_st().equals("���Կɼ�"))%>selected<%%>>���Կɼ�</option>   
                <option value="10" <%if(cls.getCls_st().equals("����������(�縮��)"))%>selected<%%>>����������(�縮��)</option>> 
		      </select> </td>
                      					  
            <td width='13%' class='title'>�Ƿ���</td>
            <td width="12%">&nbsp;
              <select name='reg_id'>
                <option value="">����</option>
                <%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(cls.getReg_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
                <%		}
					}%>
              </select></td>	
                      
            <td width='13%' class='title'>��������</td>
            <td width="12%">&nbsp;
       <% if (user_id.equals("000063")) {%>     
			  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt() )%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'>
		<% } else { %>
		  <input type='text' name='cls_dt' value='<%=AddUtil.ChangeDate2(cls.getCls_dt())%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '>
		<% }%>	  
			  </td> 
		    <td width='12%' class='title'>�̿�Ⱓ</td>
		    <td width="12%" >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' value='<%=cls.getR_mon()%>' >����&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=cls.getR_day()%>' >��&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>���� </td>
            <td colspan="5">&nbsp;
              <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cls.getCls_cau()%></textarea>			
            </td>
              <td width="12%" class=title >�����Ī<br>��������</td>
     	    <td>&nbsp; 
		  <select name="match" >
		  <option value="" <% if(cls.getMatch().equals("")){%>selected<%}%>>--����--</option>
                     <option value="Y" <% if(cls.getMatch().equals("Y")){%>selected<%}%>>�����Ī</option>           
              </select>
	    </td>
          </tr>
          <tr>                                                      
            <td class=title >�ܿ�������<br>������ҿ���</td>
     	    <td>&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'>
                <option value="N" <% if(cls.getCancel_yn().equals("N")){%>selected<%}%>>��������</option>
                <option value="Y" <% if(cls.getCancel_yn().equals("Y")){%>selected<%}%>>�������</option>
              </select>
		    </td>
		
				<td  colspan="6" align=left>&nbsp;�� ����� ��꼭�� ���� �Ǵ� ��ҿ��� �� Ȯ���� �ʿ�, ������ҽ� ���̳ʽ� ���ݰ�꼭 ���� </td>
          </tr>
           <tr>      
		            <td width='10%' class='title'>����Ÿ�</td>
		            <td>&nbsp;
					  <input type='text' name='tot_dist' size='10' value='<%=AddUtil.parseDecimal(cls.getTot_dist())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;km 
		            </td>
		            <td colspan=6   align=left>&nbsp;<%if( cls.getCls_st().equals("���Կɼ�") ) { %>�� ���Կɼǽ� ��������Ÿ� <% } else { %> �� �ߵ����� �� ����� ��������Ÿ� <%} %> </td>	         
		           
		  			 </tr>     
        </table>
      </td>
    </tr>
    
       <tr></tr><tr></tr>    
       			         
         
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ���������, ������������ ��쿡 ���ؼ� ������ ������ ��������縦 ���ؾ� �մϴ�. �̰�� ������ ������ �ʼ��׸��Դϴ�.</td>
    </tr>  
      
    <tr>
    	<td>&nbsp;<font color="#FF0000">***</font> �����Ī�����ΰ��� �����Ī������ ����ȣ�� �Է����ּ���.!!  ���������� �������� Ȯ�����ּ���.!!</td>    
     </tr> 
   
    <tr>
      <td>&nbsp;</td>
    </tr> 	 
    
    
     <tr id=tr_dae style="display:<%if( cls.getCls_st().equals("���������(����)") ){%>'' <%}else{%>none <%}%>"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	
		    	 <tr>
                    <td width="13%" class=title>�������������</td>
                    <td width="20%">&nbsp; &nbsp;
                      <input type='radio' name="prv_dlv_yn" value='N' <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%> disabled>
                      ����
                      <input type='radio' name="prv_dlv_yn" value='Y' <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%> disabled>
        	 		�ִ�
        		    </td>
                    <td width="10%" class=title style="font-size : 8pt;">�����Ⱓ���Կ���</td>
                    <td colspan=3 >&nbsp; &nbsp;
                      <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> disabled>
                      ������
                      <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> disabled>
        	 		����
        		    </td>
                </tr>
                <%	for(int i = 0 ; i < ta_vt_size ; i++){
						Hashtable ta_ht = (Hashtable)ta_vt.elementAt(i);
       					taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, ta_ht.get("NO")+"");
    			%>   
                 <tr>
                    <td width="13%" class=title>������ȣ</td>
                    <td width="20%">&nbsp;<%=taecha.getCar_no()%>                  
        			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
        			</td>
                    <td width="10%" class='title'>����</td>
                    <td>&nbsp;<%=taecha.getCar_nm()%></td>
                    <td class='title'>���ʵ����</td>
                    <td>&nbsp;<%=taecha.getInit_reg_dt()%></td>
                </tr>
                <tr>
                    <td class=title>�뿩������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
                    <td class='title'>�뿩������</td>
                    <td width="20%" >&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
                    <td width="10%" class=title >���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>��(vat����) 
        			</td>
                </tr>		
                <%} %>		 	     
		       </table>
		      </td>        
         </tr>   
         <tr>
     		<td>&nbsp;<font color="#FF0000">***</font> ������������� �ִ� ��� �������� ������ ���� �� ������ ȯ�ҵ˴ϴ�.!! </td>    
     	 </tr>
     	 <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
    
    
    <!-- ���� ���� -->
    <tr id=tr_opt style="display:<%if( cls.getCls_st().equals("���Կɼ�") ){%>'' <%}else{%>none <%}%>"> 

 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Կɼ�</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	  <tr>
 	 	  	 <td class='line'>  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 		          	
		          	<input type='hidden' name='mopt_per' value='<%=s_opt_per%>'>
		          	<input type='hidden' name='mopt_amt' value='<%=AddUtil.parseDecimal(s_opt_amt)%>'>
		          	<input type='hidden' name='mopt_s_amt' value='<%=s_opt_s_amt%>'>
		          	<input type='hidden' name='old_opt_amt' value='<%=clsa.getOld_opt_amt()%>'>
		          	
		 	 	     <td class='title' width="13%">���Կɼ���</td>
		             <td width="13%">&nbsp;<input type='text' name='opt_per' value='<%=f_opt_per%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title' width="13%">���Կɼǰ�</td>
		             <td colspan=5 >&nbsp;<input type='text' name='opt_amt'size='15' class='num' value="<%=AddUtil.parseDecimal(cls.getOpt_amt())%>" onBlur='javascript:this.value=parseDecimal(this.value); set_sui_c_amt();'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(VAT����)</td> 
		            
                  </tr>	
                 
                   <input type='hidden' name='sui_st'  value='N' >
                   <input type='hidden' name='sui_d_amt' value='0' >
		          </tr>  
		       </table>
		      </td>        
         </tr>  
        <%if (clsa.getMt().equals("1") ||  clsa.getMt().equals("2")) {%>  
        <tr>
        	<td>&nbsp;<font color="#FF0000">��</font> ���Կɼǰ� �����</td>
    	</tr>
    	 <%if (clsa.getMt().equals("2")) {%>  
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= ������ ���Կɼ� - (������ ���Կɼ� ������  * �̿��ϼ� / �������ϼ�)</td>
    	   </tr>
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= <%=AddUtil.parseDecimal(clsa.getB_old_opt_amt())%> - {(<%=AddUtil.parseDecimal(clsa.getB_old_opt_amt())%> -<%=AddUtil.parseDecimal(clsa.getOld_opt_amt())%>) * <%=clsa.getCount1()%> / <%=clsa.getCount2()%>}</td>
    	   </tr>
    	
    	 <% } else { %>
    	     <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= ���� ���Կɼǰ��� * ���簡ġ��  + �ڵ�����,����� ���ܿ���� ���簡ġ �հ�</td>
    	   </tr>
    	   <tr>
        	<td>&nbsp;&nbsp;&nbsp;&nbsp;= <%=AddUtil.parseDecimal(clsa.getOld_opt_amt())%> * <%=clsa.getRc_rate()%> + <%=AddUtil.parseDecimal(clsa.getM_r_fee_amt())%></td>
    	   </tr>
    	 <% } %>
        <% } %>
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
  
    
		    
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ݾ� ����</span>[���ް�]</td>
	</tr>
		<tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
		            <td  colspan="2" class='line'> 
		              <table border="0" cellspacing="1" cellpadding="0" width="100%">
		                <tr> 
		                  <td class='title' align='right' colspan="3">�׸�</td>
		                  <td class='title' width='38%' align="center">����</td>
		                  <td class='title' width="40%">���</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="7" width=4%>ȯ<br>
		                    ��<br>
		                    ��<br>
		                    ��</td>
		                  <td class='title' colspan="2">������(A)</td>
		                  <td class='title' > 
		                    <input type='text' name='grt_amt' readonly value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td class='title'>&nbsp;</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3" width=4%>��<br>
		                    ��<br>
		                    ��<br>
		                    ��<br>
		                    ��</td>
		                  <td width="14%" align="center" >����Ⱓ</td>
		                  <td align="center"> 
		                    <input type='text' size='3' name='ifee_mon' readonly  value='<%=cls.getIfee_mon()%>'  class='num' maxlength='4' >
		                    ����&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='<%=cls.getIfee_day()%>' class='num' maxlength='4' >
		                    ��</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >����ݾ�</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' readonly value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);' ></td>
		                  <td>=���ô뿩�᡿����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ���ô뿩��(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
		                  <td class='title'>=���ô뿩��-����ݾ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">��<br>
		                    ��<br>
		                    ��</td>
		                  <td align='center'>�������� </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=�����ݡ����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td align='center'>������ �����Ѿ� </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=�������ס����̿�Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ������(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td class='title'>=������-������ �����Ѿ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">��</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' ></td>
		                  <td class='title'>=(A+B+C)</td>
		                </tr>
		              </table>
		            </td>
			     </tr>
    
            </table>
        </td>
    </tr>
   	<tr></tr><tr></tr><tr></tr>
  	
    <input type='hidden' name='ex_ip_amt'  value='0'> 
    <input type='hidden' name='ex_ip_dt' > 
    <input type='hidden' name='bank_code' > 
    <input type='hidden' name='deposit_no' > 
  	  
    <tr>
        <td class=h></td>
    </tr>
    
    
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳��ݾ� ����</span>[���ް�]</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    
       <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
              <td class="title" colspan="4" rowspan=2>�׸�</td>
              <td class="title" width='38%' colspan=2>ä��</td>                
              <td class="title" width='40%' rowspan=2>���</td>
            </tr>
            <tr>                 
              <td class="title"'> ���ʱݾ�</td>
              <td class="title"'> Ȯ���ݾ�</td>
              
            </tr>
            <tr> 
              <td class="title" rowspan="19" width="4%">��<br>
                ��<br>
                ��<br>
                ��<br>
                ��</td>
              <td class="title" colspan="3">���·�/��Ģ��(D)</td>
              <td align="center" class="title"> 
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' ></td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num'  ></td>           
              <td class="title">&nbsp;</td>
             </tr>
             <tr> 
              <td class="title" colspan="3">�ڱ��������ظ�å��(E)</td>
              <td width='19%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' ></td>
              <td width='19%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>'   size='15' class='num'  ></td>                     
              <td width='40%' class="title">&nbsp;</td>
            </tr>
             <tr>
              <td class="title" rowspan="4" width="4%"><br>
                ��<br>
                ��<br>
                ��</td>
              <td align="center" colspan="2" class="title">������</td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>'  size='15' class='num' ></td>
              <td class='' align="center"> 
                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>              
              <td>&nbsp;</td>
             
            </tr>
         
            <tr> 
              <td rowspan="2" align="center" class="title" width="4%">��<br>
                ��</td>
              <td width='10%' align="center" class="title">�Ⱓ</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' size='3' name='nfee_mon' value='<%=cls.getNfee_mon()%>' readonly class='num' maxlength='4' >
                ����&nbsp;&nbsp;&nbsp; 
                <input type='text' size='3' name='nfee_day' value='<%=cls.getNfee_day()%>'  readonly class='num' maxlength='4' >
                ��</td>
              <td>&nbsp;     
              </td>
            </tr>
            <tr> 
              <td align="center" class="title">�ݾ�</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt'  readonly  value='<%=AddUtil.parseDecimal(cls.getNfee_amt())%>' class='num' ></td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>               
              <td>������꼭�� ���� �Ǵ� ��ҿ��θ� Ȯ��              
              </td>
            </tr>
            
            <tr> 
              <td class="title" colspan="2">�Ұ�(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt'  value='<%=AddUtil.parseDecimal(cls.getDfee_amt())%>' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly   value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
              
                 <td class='title'>&nbsp;=������ + �̳�</td>
            </tr>
                <input type='hidden' size='15' name='d_amt' value='' readonly class='num' >
                <input type='hidden' size='15' name='d_amt_1' readonly value='' class='num' >  
                     
            <tr> 
              <td rowspan="6" class="title">��<br>
                ��<br>
                ��<br>
                ��<br>
                ��<br>
                ��<br>
                ��</td>
              <td align="center" colspan="2" class="title">�뿩���Ѿ�</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=������+���뿩���Ѿ�</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">���뿩��(ȯ��)</td>
              <td class='' colspan=2 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' ></td>
              <td>=�뿩���Ѿס����Ⱓ</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��뿩���Ⱓ</td>
              <td class=''  colspan=2  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=cls.getRcon_mon()%>' class='num' maxlength='4' >
                ����&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day' readonly size='3' value='<%=cls.getRcon_day()%>' class='num' maxlength='4' >
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
              <td class=''  colspan=2 align="center"> 
                <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' readonly size='15' class='num' ></td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> ����� 
                �������</td>
              <td class='' align="center"> 
                <input type='text' readonly name='dft_int'  value='<%=cls.getDft_int()%>' size='5' class='num'  maxlength='5'>
                %</td>
              <td class='' align="center"> 
                <input type='text' name='dft_int_1'  value='<%=cls.getDft_int_1()%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='5'>
                %</td>  
              <td>*����� ��������� ��༭�� Ȯ�� <br><font color=red>*</font>��������� ������ �߻��� ����ȿ������ڸ� �ݵ�� ����</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">�ߵ����������(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' ></td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' onBlur='javascript:set_cls_amt(this)'></td>
                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_s())%>' size='15' class='num' >      
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' size='15' class='num' >            
                <input type='hidden' name='tax_g' size='20' class='text' value='�ߵ����� �����'>
                <td class="title">&nbsp;<input type='checkbox' name='tax_chk0'  value='Y' <%if(cls.getTax_chk0().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled ><!--��꼭�����Ƿ�-->
             	 &nbsp;<font color="#FF0000">*</font>����ȿ�������: 
                     <select name='dft_cost_id'>
		                <option value="">����</option>
		                  <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                 <option value='<%=user.get("USER_ID")%>' <%if(cls.getDft_cost_id().equals((String)user.get("USER_ID"))){%>selected<%}%>><%= user.get("USER_NM")%></option>
		                 <%		}
						 	}%>							           
		              </select>                
                </td>
            </tr>      
       
            <tr> 
              <td class="title" rowspan="6"><br>
                ��<br>
                Ÿ</td> 
              <td colspan="2" align="center" class="title">��ü��(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly  value='<%=AddUtil.parseDecimal(cls.getDly_amt())%>' size='15' class='num' ></td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1'  value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>             
              <td class='title'>&nbsp; </td>
            </tr>
            
              <td class="title" colspan="2">����ȸ�����ֺ��(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt())%>' size='15' class='num' ></td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_s())%>' size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_v())%>' size='15' class='num' >  
                <input type='hidden' name='tax_g' size='20' class='text' value='ȸ�� �������ֺ��'>
               <td class="title">&nbsp;<input type='checkbox' name='tax_chk1'  value='Y' <%if(cls.getTax_chk1().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled >��꼭�����Ƿ�</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">����ȸ���δ���(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>' size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_s())%>' size='15' class='num' > 
                <input type='hidden' name='tax_value' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_v())%>' size='15' class='num' >  
                <input type='hidden' name='tax_g' size='20' class='text' value='ȸ�� �δ���'>
               <td class="title">&nbsp;<input type='checkbox' name='tax_chk2'  value='Y' <%if(cls.getTax_chk2().equals("Y")){%>checked<%}%>  onClick="javascript:set_vat_amt(this);" disabled >��꼭�����Ƿ�</td>
            </tr>
            <tr> 
              <td colspan="2" class="title">������������(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>'size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td> 
            
              <td class="title">&nbsp;
              		<% if  ( fuel_cnt > 0   && return_remark.equals("��Ÿ��") ) {%>
 							<font color="#FF0000">*</font> ���񺸻� ��� ����
 				       <% } %>	
 				     	<% if  ( fuel_cnt > 0   && return_remark.equals("ȥ��")  &&  cls.getCls_st().equals("���Կɼ�") ) {%>
 							<font color="#FF0000">*</font> ȥ�� Ư������ ��� ����
 				       <% } %>	              
              </td>
            </tr>
            <tr> 
              <td class="title" colspan="2">��Ÿ���ع���(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>'  size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
               <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_s())%>' size='15' class='num' > 
               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' size='15' class='num' >  
               <input type='hidden' name='tax_g' size='20' class='text' value='��Ÿ���ع���'>
              <td class="title">&nbsp;<input type='checkbox' name='tax_chk3' value='Y' <%if(cls.getTax_chk3().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);" disabled ><!--��꼭�����Ƿ� -->
              &nbsp;          
             <!-- ��Ÿ���ع����� �ִ� ��츸 --> 
              <%if( cls.getEtc4_amt_1() > 0 ) {%>
                 
                 <%
                 	content_seq  = rent_mng_id+""+rent_l_cd+"2";
                 	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
                 	attach_vt_size = attach_vt.size();	
                 %>
                 				<%if(attach_vt_size > 0){   %>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);
    						%>
    							&nbsp;<a href="javascript:openPop('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='����' ><%=attach_ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>			
    						&nbsp;
    						<%}%>
    						                 
            <%}%></td>                                                        
            </tr>
            
            <tr> 
              <td class="title" colspan="2">�ʰ�����뿩��(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='<%=AddUtil.parseDecimal(cls.getOver_amt())%>'  size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1'  readonly  value='<%=AddUtil.parseDecimal(cls.getOver_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>             
                <td class="title">&nbsp;<input type='checkbox' name='tax_chk4' value='Y' <%if(cls.getTax_chk4().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);" disabled >��꼭�����Ƿ�</td>                                                    
            </tr>
            
                   
            <tr> 
              <td class="title" colspan="3">�ΰ���(N)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt())%>' readonly size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>' readonly size='15' class='num' ></td> 
         
              <td> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td id=td_cancel_n style="display:<%if( cls.getCancel_yn().equals("N") ){%>none<%}else{%>'' <%}%>" class="title">=(F+M-B-C)��10% </td>
                    <td id=td_cancel_y style="display:<%if( cls.getCancel_yn().equals("Y") ){%>none<%}else{%>'' <%}%>" class='title'>=(F+M-B-C)��10% </td>
                  </tr>
                </table>
              </td>
            </tr>
            
            <tr> 
              <td class="title_p" colspan="4">��</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1'value='<%=AddUtil.parseDecimal(cls.getFdft_amt1())%>' readonly  size='15' class='num' ></td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' readonly  size='15' class='num' ></td>  
                
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M+N)&nbsp;&nbsp;
                <br>�� ��꼭:&nbsp;              
               <input type="radio" name="tax_reg_gu" value="N"  <%if(cls.getTax_reg_gu().equals("N")){%>checked<%}%> >�׸�û��
               <input type="radio" name="tax_reg_gu" value="Y"  <%if(cls.getTax_reg_gu().equals("Y")){%>checked<%}%> >�׸��ջ�û��
               <input type="radio" name="tax_reg_gu" value="Z"  <%if(cls.getTax_reg_gu().equals("Z")){%>checked<%}%> >�뿩����������û��
              </td>
            </tr>
          </table>
        </td>         
    </tr>   
    <tr></tr><tr></tr><tr></tr>   
   
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10%>�����Աݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2' readonly  value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>' size='15' class='num'  ></td>
                    <% if ( h_cms.get("CBNO") == null  ) {%>
                    <td colspan=6>&nbsp;�� �̳��Աݾװ� - ȯ�ұݾװ�</td>
                    <% } else { %>    
              		<td class=title width=12% ><input type='checkbox' name='cms_chk' value='Y' <%if(cls.getCms_chk().equals("Y")){%>checked<%}%> >CMS�����Ƿ�</td>
                 	<td colspan=5>&nbsp;�� �̳��Աݾװ� - ȯ�ұݾװ�</td>  
             		<% } %>        
              </tr>
             
              </table>
         </td>       
    <tr> 
  
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_sale style="display:<%if( cls.getCls_st().equals("���Կɼ�") ){%>''<%}else{%>none<%}%>"> 
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >���Կɼǽ�<br>�����Աݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt3'  value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>' size='15' class='num' readonly  ></td>
                    <td colspan=6>&nbsp;�� �����Աݾ�  + ���Կɼǰ� + ������Ϻ��(�߻��� ���)</td>
              </tr>
                       
              </table>
         </td>       
    </tr> 
   
     <tr>
        <td class=h></td>
    </tr>
   
     <tr></tr><tr></tr><tr></tr>
      
    <!-- �ߵ����꼭�� ����  block none  �뿩���Ⱑ 2�����̻� ������ ���  -->
   
   <tr id=tr_cal_sale style="display:<%if( clsa.getOld_opt_amt() > 0  && fee_size == 1){%>''<%}else{%>none<%}%>"> 
    
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
         <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ߵ� ���꼭</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
        </tr> 	 	 	 	
 	 	  <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr>               
               <td class="title"  rowspan="2"  width='3%'>ȸ��</td>
              <td class="title"  rowspan="2" width='8%'>�����ҳ�¥</td>                
              <td class="title"  rowspan="2" width='8%'>���뿩��<br>(���ް�)</td>
              <td class="title"  rowspan="2" width='8%'>���뿩�� ������ <br>������ ����ȿ��</td>
              <td class="title"  rowspan="2" width='8%'>������ ����ȿ�� �ݿ���<br> ���뿩��(���ް�)</td>                  
              <td class="title"  rowspan="2" width='8%'>�ڵ�����</td>                
              <td class="title"  rowspan="2" width='8%'>�����+<br>������</td>
              <td class="title"  rowspan="2" width='8%'>�ڵ�����,�����<br> ���ܿ��<br>(���ް�)</td>                
              <td class="title"  width='25%' colspan=3>�ڵ�����,����� ���ܿ���� ���簡ġ</td>             
              <td class="title"  width='16%' colspan=2>���簡ġ ���� �����ڷ�<br>(������: �� <%=clsa.getA_f()%>%)</td>  
            </tr>          
            
            <tr> 
              <td class="title"  width='8%' >���ް�</td>
              <td class="title"  width='8%'>�ΰ���</td>
              <td class="title"  width='9%'>�հ�</td>
              <td class="title"  width='8%'>���簡ġ��</td>
              <td class="title"  width='8%'>�����ϴ��<br>����ϼ�</td>
             </tr>  
             <tr> 
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td align="center"> (1) </td>
              <td align="center"> (2) </td>
              <td align="center"> (3) = (1) + (2)</td>
              <td align="center"> (4) </td>
              <td align="center"> (5) </td>
              <td align="center"> (6) = (3) - (4) - (5) </td>
              <td align="center"> (7) = (6) * (10) </td>
              <td align="center"> (8) = (7) * 0.1</td>
              <td align="center"> (9) = (7) + (8)</td>
              <td align="center"> (10) </td>
              <td align="center"> (11) </td>                
             </tr>              
                           
<%	
		
	int t_fee_s_amt = 0;            
	int t_s_cal_amt = 0;
	int t_r_fee_s_amt = 0;
	int t_r_fee_v_amt = 0;
	int t_r_fee_amt = 0;
	
	int t_grt_amt = 0;
	int t_g_fee_amt = 0;	
	
	int s_g_fee_amt = 0;
	
					
	for(int i = 0 ; i < vt_size8 ; i++){
					Hashtable ht8 = (Hashtable)vts8.elementAt(i); 					
										
					t_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT")));
					t_s_cal_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_CAL_AMT")));
					t_r_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_S_AMT")));
					t_r_fee_v_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_V_AMT")));
					t_r_fee_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_R_FEE_AMT")));
					
					t_grt_amt += AddUtil.parseInt(String.valueOf(ht8.get("S_GRT_AMT")));
					s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_G_FEE_AMT"))) ;
					
					if ( s_g_fee_amt < 1) s_g_fee_amt = AddUtil.parseInt(String.valueOf(ht8.get("S_FEE_S_AMT"))) ;
								
					t_g_fee_amt += s_g_fee_amt;											
					
%>       
	 		   <tr>
                    <td>&nbsp;<input type='text' name='s_fee_tm'  readonly value='<%=ht8.get("S_FEE_TM")%>' size='4' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_est_dt'  readonly value='<%=AddUtil.ChangeDate2(String.valueOf(ht8.get("S_R_FEE_EST_DT")))%>' size='12' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_fee_s_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_FEE_S_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_grt_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_GRT_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_g_fee_amt'  readonly value='<%=Util.parseDecimal(s_g_fee_amt)%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_tax_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_TAX_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_is_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_IS_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_cal_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_s_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_S_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_v_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_V_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_R_FEE_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_rc_rate'  readonly value='<%=AddUtil.parseFloat(String.valueOf(ht8.get("S_RC_RATE")))%>' size='10' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_cal_days'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("S_CAL_DAYS")))%>' size='8' class='num' > </td>
                                    
               </tr>
<% } %>
               
               <tr>
                    <td colspan="2" class=title>�հ�</td>
                    <td class=title><input type='text' name='t_fee_s_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_fee_s_amt)%>'></td>
                    <td class=title><input type='text' name='t_s_grt_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_grt_amt)%>'></td>
                    <td class=title><input type='text' name='t_s_g_fee_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_g_fee_amt)%>'></td>
                    <td class=title></td>
                    <td class=title></td>
                    <td class=title><input type='text' name='t_s_cal_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_s_cal_amt)%>'></td>
                    <td class=title><input type='text' name='t_r_fee_s_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_r_fee_s_amt)%>'></td>
                    <td class=title><input type='text' name='t_r_fee_v_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_r_fee_v_amt)%>'></td>
                    <td class=title><input type='text' name='t_r_fee_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_r_fee_amt)%>'></td>
                    <td class=title></td>
                    <td class=title></td>                   
                  
               </tr>	  
                   
             </table>
            </td>
         </tr>         
    	
     	</table>
      </td>	 
  </tr>	  	 	    
  
  <tr>
        <td>&nbsp;</td>
   </tr>   
 
          <!-- �ʰ�����δ�ݿ� ����  block none-->
 <!--   <tr id=tr_over style="display:<%if( co.getRent_days() > 0 ){%>''<%}else{%>none<%}%>"> -->
    <tr id=tr_over style="display:<%if( co.getR_over_amt() != 0 ){%>''<%}else{%>none<%}%>">  
      
       <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> ȯ��/�ʰ����� �뿩��[���ް�]</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	 	 	
 	 	   <tr> 
 	      <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="5"  width='34%'>����</td>
              <td class="title" width='20%'>����</td>                
              <td class="title" width='46%'>����</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="7" >��<br>��<br>��<br>��</td>   
              <td class="title"  rowspan=4>��<br>��</td>
              <td class="title"  colspan=3>���Ⱓ</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
              <td align="left" >&nbsp;���ʰ��Ⱓ</td>
             </tr>
             <tr> 
              <td class="title" rowspan=3>����<br>�Ÿ�<br>����</td>
              <td class="title"  colspan=2>���������Ÿ� (��)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title" rowspan=2>�ܰ�<br>(1km) </td>
              <td class="title" >ȯ�޴뿩�� (a1)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getRtn_run_amt() )%>��</td>
              <td align="left" >&nbsp;�����Ÿ� ���Ͽ���</td>
             </tr>            
             <tr> 
              <td class="title" >�ʰ�����뿩��(a2)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>��</td>
               <td align="left" >&nbsp;�����Ÿ� �ʰ�����</td>
            </tr>           
            <tr> 
              <td class="title"  rowspan=3>��<br>��</td>
              <td class="title"  rowspan=2>�̿�<br>�Ⱓ</td>  
              <td class="title"  colspan=2 >���̿�Ⱓ	</td>     
              <td align="center">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
              <td align="left" >&nbsp;�����뿩�Ⱓ</td>
            </tr>   
            <tr> 
              <td class="title"  colspan=2 >���̿��ϼ�	(��)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(co.getRent_days() )%>' size='7' class='whitenum' > �� </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title"  colspan=3 >�����Ÿ�(�ѵ�)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7'  value='<%=AddUtil.parseDecimal(co.getCal_dist() )%>' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(��)x(��) / 365</td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>      
              <td class="title"  rowspan=3>��<br>��</td>
              <td class="title"  colspan=3 >��������Ÿ���(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value='<%=AddUtil.parseDecimal(co.getFirst_dist() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;����(�� �ε����� ����Ÿ�) , ������ (��༭�� ��õ� ����Ÿ�)</td>
             </tr>   
             <tr> 
              <td class="title"  colspan=3>��������Ÿ���(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly value='<%=AddUtil.parseDecimal(co.getLast_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title"  colspan=3 >�ǿ���Ÿ�(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly   value='<%=AddUtil.parseDecimal(co.getReal_dist() )%>'    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
             <tr> 
              <td class="title"  rowspan=3>��<br>��</td>
              <td class="title"   colspan=3 >������ؿ���Ÿ�	(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly   value='<%=AddUtil.parseDecimal(co.getOver_dist() )%>'   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title"   colspan=3 >�⺻�����Ÿ�</td>
               <% if (  AddUtil.parseInt(base.getRent_dt()) > 20220414 ) { %>             
              <td align="right" >&nbsp;��1,000 km</td>
            <% } else { %>
              <td align="right" >&nbsp;1,000 km</td>
            <% }  %>  
         
                <td align="left" >&nbsp;<input type='hidden' name='add_dist'  value='<%=AddUtil.parseDecimal(co.getAdd_dist() )%>'   readonly> </td>
             </tr>      
              <tr> 
              <td class="title"  colspan=3 >�뿩��������ؿ���Ÿ�	(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly value='<%=AddUtil.parseDecimal(co.getJung_dist() )%>'      size='7' class='whitenum' > km</td>
              <% if (  AddUtil.parseInt(base.getRent_dt())  > 20220414 ) { %>  
              <td align="left" >&nbsp;(g)�� ��1,000km �̳��̸� ������(0km) , (g)��  ��1,000km�� �ƴϸ� (g)���⺻�����Ÿ� </td>
                <% } else { %>
               <td align="left" >&nbsp;</td> 
                <% }  %>
          
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>��<br>��<br>��</td>
              <td class="title"  rowspan=2>��<br>��</td>
              <td class="title"  colspan=3 >����ݾ�(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getR_over_amt() )%>'     size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;(b)��  0km �̸��̸� (a1)*(b), (b)�� 1km�̻��̸� (a2)*(b)</td>
             </tr>
             <tr> 
              <td class="title"   colspan=3 >������(i)</td>
              <td align="right"><input type='text' name='m_over_amt'  value='<%=AddUtil.parseDecimal(co.getM_over_amt() )%>'      size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> ��</td>
              <td align="left" >&nbsp;�����ڹ׻���:
              	   <select name='m_saction_id'>
			                <option value="">--����--</option>
			                 <%	if(user_size1 > 0){
								for(int i = 0 ; i < user_size1 ; i++){
									Hashtable user1 = (Hashtable)users1.elementAt(i); %>
			                 <option value='<%=user1.get("USER_ID")%>' <%if(co.getM_saction_id().equals((String)user1.get("USER_ID"))){%>selected<%}%>><%= user1.get("USER_NM")%></option>
			                 <%		}
							 	}%>		              
			              </select> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="m_reason" cols="55" class="text" style="IME-MODE: active" rows="2"><%=co.getM_reason()%></textarea> </td>
             </tr>      
             <tr> 
              <td class="title"  colspan=4 >����(�ΰ�/ȯ�޿���)�ݾ�</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly   value='<%=AddUtil.parseDecimal(co.getJ_over_amt() )%>'     size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;=(h)-(i), ȯ��(-)</td>
             </tr>  
            </table>
           </td>
         </tr>           
   
     	</table>
      </td>	 
  
    </tr>	  	 	    
             
    <tr>
        <td>&nbsp;</td>
    </tr>        
      
      <%	//���ຸ������
			//	ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);
         		 ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
				
		%>
     <tr> 
          <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� ����</span></td>
     </tr>
     
     <tr> 
          <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
              <tr> 
                <td class='title' width="10%"> 
                  <%if(gins.getGi_st().equals("1")){%>����<%}else if(gins.getGi_st().equals("0")){ gins.setGi_amt(0);%>����<%}%>
                </td>
                <td class='title' width="15%" align="center"> 
                  <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' maxlength='15'>
                  </td>
                <td class='title' width="65%"></td>
              </tr>
            </table>
          </td>
    </tr>
   
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>    
  
	<!-- ����ä���� �ִ� ��� -->
 
	<tr id=tr_get style="display:''">
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä���� �ڱ�å&nbsp;</span></td>
		    </tr>
		    <tr>
		        <td class=line2></td>
		    </tr>
		    <tr>
		        <td class=line>
		            <table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
		                    <td class=title width=12%>����</td>
		                    <td colspan=7>&nbsp; 
								  <select name="div_st" onChange='javascript:cls_display3()'>
								    <option value="">---����---</option>
								    <option value="1" <%if(cls.getDiv_st().equals("�Ͻó�"))%>selected<%%>>�Ͻó�</option>
            					    <option value="2" <%if(cls.getDiv_st().equals("�г�"))%>selected<%%>>�г�</option>
					             
					              </select>             
					              <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                        <tr> 
					                          
					                           <td id='td_div' style="display:<%if( cls.getDiv_st().equals("�г�")){%>''<%}else{%>none<%}%>">&nbsp;�г�Ƚ��&nbsp;  
					                             <select name="div_cnt">
												    <option value="">---����---</option>
												    <option value="1" <%if(cls.getDiv_cnt() == 1)%>selected<%%>>1</option>
            					   					<option value="2" <%if(cls.getDiv_cnt() == 2)%>selected<%%>>2</option>
            					   				    <option value="3" <%if(cls.getDiv_cnt() == 3)%>selected<%%>>3</option>
            					   					<option value="4" <%if(cls.getDiv_cnt() == 4)%>selected<%%>>4</option>
            					   				    <option value="5" <%if(cls.getDiv_cnt() == 5)%>selected<%%>>5</option>
            					   					<option value="6" <%if(cls.getDiv_cnt() == 6)%>selected<%%>>6</option>
            					   				    <option value="7" <%if(cls.getDiv_cnt() == 7)%>selected<%%>>7</option>
            					   					<option value="8" <%if(cls.getDiv_cnt() == 8)%>selected<%%>>8</option>
            					   				    <option value="9" <%if(cls.getDiv_cnt() == 9)%>selected<%%>>9</option>
            					   				    <option value="10" <%if(cls.getDiv_cnt() == 10)%>selected<%%>>10</option>
            					   				    <option value="11" <%if(cls.getDiv_cnt() == 11)%>selected<%%>>11</option>
            					   				    <option value="12" <%if(cls.getDiv_cnt() == 12)%>selected<%%>>12</option>            					   					
									              </select>
					                            </td>
					                        </tr>
					                </table>
					         	</td>
					    	</tr>
					  
		                	<tr>
			                    <td class=title width=13%>����</td>
			                    <td class=title width=12%>������</td>
			                    <td>&nbsp;<input type='text' name='est_dt' value='<%=cls.getEst_dt()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
			                    <td class=title width=12%>�����ݾ�</td>
			                    <td>&nbsp;<input type='text' name='est_amt' value='<%=AddUtil.parseDecimal(cls.getEst_amt())%>'size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
			                    <td class=title width=12%>������</td>
			                    <td>&nbsp;<input type='text' name='est_nm' value='<%=cls.getEst_nm()%>' size='15' class='text'></td>
		                	</tr>
		             	                
		            	</td>
		        	</tr>
		    	</table>
		  		</td>
		    </tr>
			<tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>
					                      <td class=title width=13%>����������</td>
									      <td width=12%>&nbsp;<input type='text' value='<%=cls.getGur_nm()%>' name='gur_nm' size='15' class='text'></td>
						                  <td width=12% class=title>����ó</td>
						                  <td>&nbsp;<input type='text' name='gur_rel_tel' value='<%=cls.getGur_rel_tel()%>'  size='30' class='text'></td>
						                  <td width=12% class=title>����ڿ��ǰ���</td>  
						                  <td colspan=3>&nbsp;<input type='text' name='gur_rel' value='<%=cls.getGur_rel()%>'  size='30' class='text'></td>   
		           			             
		               			    </tr>
		               			 </table>
		               		</td>
		                </tr>
		             </table>
		          </td>
		    </tr>
		   	<tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>              
					                    <td class=title style='height:44' width=13%>ó���ǰ�/���û���/����</td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="remark" cols="140" class="text" style="IME-MODE: active" rows="3"><%=cls.getRemark()%></textarea> 
					                    </td>
					                </tr>
		                
		           				</table>
		           			</td>
		           		</tr>
		           	</table>			
		        </td>
		    </tr>
			                    
		   	 <tr>
     		 <td>&nbsp;</td>
     	    </tr>
       	</table>
      </td>	 
    </tr>	            
            
    <tr>
	    <td align='center'>	
	         <a href="javascript:sac_delete();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>&nbsp; 
	    </td>
	</tr>			  
   
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
		
	function set_init(){
		
		var fm = document.form1;		
		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
	//	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));	
	//	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));	
					
	}		
	
//-->
</script>
</body>
</html>
