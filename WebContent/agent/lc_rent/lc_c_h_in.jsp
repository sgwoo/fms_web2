<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*,acar.offls_sui.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);

	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		
	//�����뿩����
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(fee_size));
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, String.valueOf(fee_size));
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�Һ�����
	ContDebtBean debt = a_db.getContDebt(rent_mng_id, rent_l_cd);
	
	//������ �����
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");	

	//����̷¸���Ʈ
	Vector conts = a_db.getContHistory(rent_mng_id);
	int cont_size = conts.size();
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	//�Ű�����
	SuiBean sBean = olsD.getSui(base.getCar_mng_id());
	
	UsersBean mng_user_bean 	= umd.getUsersBean(base.getMng_id());	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//���� �߼�
	function view_sms_send(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_sms.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&memo_st=client", "CREDIT_MEMO_SMS", "left=220, top=20, width=800, height=850");
	}		
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
//-->
</style>
</head>
<body>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>   
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"			value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"			value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 			value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">    
  <input type='hidden' name="rent_way" 			value="<%=max_fee.getRent_way()%>">  
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
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name="o_1"			value="">
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
    
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_cont style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr> 
                <td class=title>��������</td>
                <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
                <td class=title>�����̿�����</td>
                <td>&nbsp;<%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
		</td>				
              </tr>
              <tr>
                <td width="16%" class=title>��౸��</td>
                <td width="32%">&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>�ű�<%}else if(rent_st.equals("3")){%>����<%}else if(rent_st.equals("4")){%>����<%}%></td>
                <td width="16%" class=title>��������</td>
                <td>&nbsp;������Ʈ</td>
              </tr>
              <tr> 
                <td width="16%" class=title>�뵵����</td>
                <td width="32%">&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("3")){%>����<%}%>    			  
                <td width="16%" class=title>��������</td>
                <td>&nbsp;<%String rent_way = max_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}else if(rent_way.equals("2")){%>�����<%}%></td>
              </tr>		  
              <tr>
                <td class=title>��������</td>
                <td>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>		    
                <td class=title>��������</td>
                <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
              </tr>
              <tr>
    		  <!-- ������ �ƴ� ��� ���°�, ����������� bus_id ��, ext_agnt�� �־... ) //c_db.getNameById(fee.getExt_agnt(),"USER") -->
                <td class=title>���ʿ�����</td>
                <td>
    			<%if(fee_size ==1){%>
				<%	if(fee.getExt_agnt().equals("")){%>				
    			&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%>
    			<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %>&nbsp;(�����������:<%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>)<%}%>
				<%	}else{%>
				&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%>
				<%	}%>
    			<%}else{%>
    			<%	for(int i=1; i<fee_size; i++){
    					ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
    					if(i+1==fee_size){%>		
    					&nbsp;<%=c_db.getNameById(ext_fee.getExt_agnt(),"USER")%>
    			<%	}}%>			
    			<%}%>
    		</td>
                <td class=title>������</td>
                <td>&nbsp;<%=c_db.getNameById(base.getSanction_id(),"USER")%>&nbsp;<%=AddUtil.ChangeDate2(base.getSanction_date())%></td>
    		  </tr>
    		  <tr>
                <td class=title>���������</td>
                <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                <td class=title>���������</td>
                <td>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%>
                	(<%=mng_user_bean.getUser_m_tel()%>&nbsp;<a href="javascript:view_sms_send('<%=base.getRent_mng_id()%>', '<%=base.getRent_l_cd()%>')" onMouseOver="window.status=''; return true" title='���ڹ߼�'><img src=/acar/images/center/icon_tel.gif align=absmiddle border=0></a>)
                	</td>
    		  </tr>
    		  <tr>
                <td class=title>�����븮��</td>
                <td>&nbsp;
    			<%if(fee_size ==1){%>
    			<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%>
    			<%}else{%>
    			<%=c_db.getNameById(fee_etc.getBus_agnt_id(),"USER")%>			
    			<%}%>
    			  </td>
                <td class=title>���������</td>
                <td>&nbsp;<%=c_db.getNameById(base.getMng_id2(),"USER")%>
    			  </td>
    		  </tr>
            </table>
	    </td>
    </tr>
    <tr id=tr_pur style='display:none'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr> 
                <td class=title>�������</td>
                <td>&nbsp;<%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%>&nbsp;<%=emp2.getCar_off_nm()%></td>
                <td class=title>�����ȣ</td>
                <td>&nbsp;<%=pur.getRpt_no()%></td>
              </tr>
              <tr>
                <td class=title style="font-size : 7pt;">�ӽÿ����㰡��ȣ</td>
                <td>&nbsp;<%=pur.getTmp_drv_no()%></td>
                <td class=title>�ӽÿ���Ⱓ</td>
                <td>&nbsp;<%=AddUtil.ChangeDate2(pur.getTmp_drv_st())%>~<%=AddUtil.ChangeDate2(pur.getTmp_drv_et())%></td>
              </tr>
              <tr>
                <td class=title>�������</td>
                <td colspan="3">&nbsp;<%=c_db.getNameById(debt.getCpt_cd(), "BANK")%></td>
              </tr>		    
              <tr>
                <td width="16%" class=title>�������</td>
                <td width="32%">&nbsp;<%=AddUtil.parseDecimal(debt.getLend_prn())%>&nbsp;��</td>
                <td width="16%" class=title>��������</td>
                <td>&nbsp;<%=AddUtil.ChangeDate2(debt.getLend_dt())%></td>
              </tr>		    
            </table>
	    </td>
    </tr>	
    <tr id=tr_car style='display:none'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr> 
                <td width="16%"  class=title>����</td>
                <td width="32%">&nbsp;<%String car_ext = cr_bean.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%></td>
                <td width="16%"  class=title>������ȣ</td>
                <td>&nbsp;<%=cr_bean.getCar_doc_no()%></td>
              </tr>
              <tr>
                <td class=title>����</td>
                <td>&nbsp;<%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%></td>
                <td class=title>�뵵</td>
                <td>&nbsp;<%String car_use = cr_bean.getCar_use();%><%if(car_use.equals("1")){%>������<%}else if(car_use.equals("2")){%>�ڰ���<%}%></td>
              </tr>
              <tr>
                <td class=title>�����ȣ</td>
                <td>&nbsp;<%=cr_bean.getCar_num()%></td>
                <td class=title>����</td>
                <td>&nbsp;<%=c_db.getNameByIdCode("0039", "", cr_bean.getFuel_kd())%></td>
              </tr>
              <tr>
                <td class=title>���ɸ�����</td>
                <td>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getCar_end_dt())%></td>
                <td class=title>��ⷮ</td>
                <td>&nbsp;<%=cr_bean.getDpm()%>cc</td>			
              </tr>		    		  		    
              <tr>
                <td class=title>�˻���ȿ�Ⱓ</td>
                <td>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getMaint_st_dt())%>~<%=AddUtil.ChangeDate2(cr_bean.getMaint_end_dt())%></td>
                <td class=title>������ȿ�Ⱓ</td>
                <td>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getTest_st_dt())%>~<%=AddUtil.ChangeDate2(cr_bean.getTest_end_dt())%></td>
              </tr>		    		  		    
            </table>
	    </td>
    </tr>	
    <tr id=tr_taecha style='display:none'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr>
                <td width="16%" class=title>������ȣ</td>
                <td width="32%">&nbsp;<%=taecha.getCar_no()%></td>
                <td width="16%" class=title>����</td>
                <td>&nbsp;<%=taecha.getCar_nm()%></td>
              </tr>		    
              <tr>
                <td width="16%" class=title>���ʵ����</td>
                <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getInit_reg_dt())%></td>
                <td class=title>���뿩��</td>
                <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>��(vat����) </td>
              </tr>	
              <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              <%}else{%>
              <tr>
                    <td class=title >���������ÿ������</td>
                    <td colspan='3'> 
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
                <td>&nbsp;<%String tae_req_st = taecha.getReq_st();%><%if(tae_req_st.equals("1")){%>û��<%}else if(tae_req_st.equals("0")){%>�������<%}%></td>
                <td class=title>��꼭���࿩��</td>
                <td>&nbsp;<%String tae_tae_st = taecha.getTae_st();%><%if(tae_tae_st.equals("1")){%>����<%}else if(tae_tae_st.equals("0")){%>�̹���<%}%></td>
              </tr>
            </table>
	  </td>
    </tr>		
<%	for(int i=0; i<fee_size; i++){
		ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
		if(!ext_fee.getCon_mon().equals("")){%>		
    <tr id=tr_fee<%=i+1%> style='display:none'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr>
                <td width="16%" class=title>�뿩��ȣ</td>
                <td width="32%">&nbsp;<%=ext_fee.getRent_st()%></td>
                <td width="16%" class=title>�뿩����</td>
                <td>&nbsp;<%=ext_fee.getCon_mon()%>����</td>
              </tr>		    
              <tr> 
                <td class=title>������</td>
                <td>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>��</td>
                <td class=title>������</td>
                <td>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>��</td>
              </tr>
              <tr>
                <td class=title>���ô뿩��</td>
                <td>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+fee.getIfee_v_amt())%>��</td>
                <td class=title>���뿩��</td>
                <td>&nbsp;<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>��</td>
              </tr>
              <tr> 
                <td class=title>���Կɼ�</td>
                <td>&nbsp;<%String ext_opt_chk = ext_fee.getOpt_chk();%><%if(ext_opt_chk.equals("0")){%>����<%}else if(ext_opt_chk.equals("1")){%>����<%}%>&nbsp;<%=ext_fee.getOpt_per()%>%&nbsp;<%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt())%>��</td>
                <td class=title style="font-size : 8pt;">�ߵ�����������</td>
                <td>&nbsp;<%=ext_fee.getCls_per()%>%</td>
              </tr>
    		<%if(i==0){
				if(cont_etc.getCar_deli_dt().equals("")) cont_etc.setCar_deli_dt(ext_fee.getRent_start_dt());%>			
              <tr>
                <td width="16%" class=title>�����ε���</td>
                <td>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%></td>
                <td class=title style="font-size : 8pt;">�������</td>
                <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
              </tr>					
		    <%}else{%>						  
              <tr>
                <td width="16%" class=title>�������</td>
                <td colspan='3'>&nbsp;<%=c_db.getNameById(ext_fee.getExt_agnt(),"USER")%></td>
              </tr>					
			<%}%>
            </table>
    		<%if(i==0 && !cms.getCms_day().equals("")){%>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr>
                <td width="16%" class=title>�ڵ���ü</td>
                <td width="84%">
    			  <table width="500" border="0" cellpadding="0">
    			    <tr>
    			      <td>&nbsp;���¹�ȣ : 
    			      <%=cms.getCms_acc_no()%>
    			      (����:<%=c_db.getNameById(cms.getCms_bank(), "BANK")%>) </td>
    			    </tr>
    			    <tr>
    			      <td>&nbsp;�� �� �� :&nbsp;<%=cms.getCms_dep_nm()%>			      
    				    &nbsp;&nbsp;
    				    / �������� : �ſ� <%=cms.getCms_day()%>��</td>
    			    </tr>
    			  </table>
    			</td>
              </tr>		    
            </table>
		    <%}%>
	    </td>
    </tr>	
<%	}}%>
    <tr id=tr_cls style='display:none'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr>
                <td width="16%" class=title>��������</td>
                <td width="32%">&nbsp;<a href="javascript:parent.view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');"><%=cls.getCls_st()%></a></td>
                <td width="16%" class=title>��������</td>
                <td>&nbsp;<%=cls.getCls_dt()%></td>
              </tr>	
              <tr>
                <td class=title>��������</td>
                <td colspan="3">&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%></td>
              </tr>		    		  		    		  	    
            </table>
    		<%if(cont_size > 0){%>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr>
                <td width="16%" class=title>����</td>
                <td width="20%" class=title>��</td>
                <td width="15%" class=title>������ȣ</td>
                <td width="20%" class=title>����</td>
                <td width="15%" class=title>��������</td>			
                <td class=title>��������</td>						
              </tr>	
    		  <%for(int i = 0 ; i < cont_size ; i++){
    				Hashtable ht = (Hashtable)conts.elementAt(i);%>
              <tr>
                <td align="center"><%=i+1%></td>
                <td align="center"><%=ht.get("FIRM_NM")%></td>
                <td align="center"><%=ht.get("CAR_NO")%></td>
                <td align="center"><%=ht.get("CAR_NM")%></td>
                <td align="center"><%=ht.get("CLS_ST")%></td>
                <td align="center"><%=ht.get("CLS_DT")%></td>															
              </tr>
    		  <%}%>
            </table>		
    		<%}%>
    		<%if(!sBean.getCar_mng_id().equals("")){%>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr>
                <td width="16%" class=title>�����</td>
                <td width="32%">&nbsp;<%=sBean.getSui_nm()%></td>
                <td width="16%" class=title>�ŸŰ�</td>
                <td>&nbsp;<%=AddUtil.parseDecimal(sBean.getMm_pr())%>��</td>
              </tr>	
              <tr>
                <td width="16%" class=title>����������</td>
                <td width="32%">&nbsp;<%=sBean.getCar_nm()%> (<%=sBean.getCar_relation()%>)</td>
                <td width="16%" class=title>�����Ĺ�ȣ</td>
                <td>&nbsp;<%=sBean.getMigr_no()%></td>
              </tr>	
            </table>		
		<%}%>
	    </td>
    </tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
