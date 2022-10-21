<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.estimate_mng.*, acar.cls.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="e_bean"    class="acar.estimate_mng.EstimateBean"     scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="shDb"      class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean"               scope="page"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�߰��̿뿵��ȿ�����
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String add_rent_st 	= request.getParameter("add_rent_st")==null?"":request.getParameter("add_rent_st");
	
	add_rent_st = "a";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
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
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//�߰�����뿩����
	Hashtable fee_add = a_db.getContFeeAdd(rent_mng_id, rent_l_cd, "a");
	
	if(String.valueOf(fee_add.get("RENT_L_CD")).equals("null")){
		//�߰�����뿩���� ����ġ
		Hashtable fee_add2 = a_db.getContBcAddCase(rent_mng_id, rent_l_cd);
		fee_add.put("RENT_MNG_ID", 		rent_mng_id);
		fee_add.put("RENT_L_CD",   		rent_l_cd);
		fee_add.put("RENT_ST",     		"a");
		fee_add.put("RENT_DT",  		String.valueOf(fee_add2.get("RENT_START_DT")));
		fee_add.put("RENT_START_DT",  	String.valueOf(fee_add2.get("RENT_START_DT")));
		fee_add.put("RENT_END_DT",  	String.valueOf(fee_add2.get("RENT_END_DT")));
		fee_add.put("CON_MON",		  	String.valueOf(fee_add2.get("CON_MON")));
		boolean flag3 = a_db.insertFeeAdd(fee_add);
		
		ContFeeBean fee2 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
		fee2.setRent_st			("a");
		fee2.setCon_mon			(String.valueOf(fee_add2.get("CON_MON")));
		fee2.setRent_dt			(String.valueOf(fee_add2.get("RENT_START_DT")));
		fee2.setRent_start_dt	(String.valueOf(fee_add2.get("RENT_START_DT")));
		fee2.setRent_end_dt		(String.valueOf(fee_add2.get("RENT_END_DT")));
		flag3 = a_db.updateContFeeAdd(fee2);
		
		fee_add = a_db.getContFeeAdd(rent_mng_id, rent_l_cd, "a");
	}
	
	//�����������Կɼ�
	int fee_opt_amt = fee.getOpt_s_amt()+fee.getOpt_v_amt();
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtcAdd(rent_mng_id, rent_l_cd, String.valueOf(fee_add.get("RENT_ST")));
	
	if(fee_etc.getCls_n_mon().equals("")) fee_etc.setCls_n_mon("0");
	
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
	if(gin_size==0) gin_size=1;
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	//��������
	e_bean = e_db.getEstimateCase(fee_etc.getBc_est_id());
	
	String s_rent_dt  = String.valueOf(fee_add.get("RENT_START_DT"));
	String s_start_dt = String.valueOf(fee_add.get("RENT_START_DT"));
	
	
	Hashtable sh_ht = new Hashtable();
	Hashtable carOld = new Hashtable();
	
			//�縮�������⺻�������̺�
			Hashtable ht = shDb.getShBase(base.getCar_mng_id());
			
			//��������-�������̺� ���� ��ȸ
			Hashtable ht2 = shDb.getBase(base.getCar_mng_id(), s_rent_dt);
			
			if(String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
				ht2.put("REG_ID", user_id);
				ht2.put("SECONDHAND_DT", s_rent_dt);
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
					ht2.put("SECONDHAND_DT", s_rent_dt);
					//sh_base table update
					int count = shDb.updateShBase(ht2);
				}
			}
		//��������
		sh_ht = shDb.getShBase(base.getCar_mng_id());
		//������� ����Ⱓ(����)
		carOld 	= c_db.getOld(String.valueOf(sh_ht.get("INIT_REG_DT")));
		
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	
	
	
	
	
	//����DC�ڵ�
	CodeBean[] codes = c_db.getCodeAll("0017");
	int c_size = codes.length;
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&add_rent_st="+add_rent_st+"&from_page="+from_page;
	
	int idx = 1;
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
	//����Ʈ
	function list(){
		var fm = document.form1;		
		<%if(from_page.equals("/fms2/mis/sale_cost_mng_frame.jsp")){%>	
		fm.action = '/fms2/mis/sale_cost_mng_frame.jsp';		
		<%}else{%>
		fm.action = 'lc_bc_add_frame.jsp';		
		<%}%>
		fm.target = 'd_content';
		fm.submit();
	}	

	//����ȿ������ ��� (����)
	function estimate_cmp(st, idx){
		var fm = document.form1;
		
		fm.esti_stat.value 	= st;
		fm.from_page.value  = 'car_rent';
				
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}
		fm.action='get_fee_estimate_cmp_add_20130101.jsp';
		fm.submit();
	}
	
	//�߰������� ����ϱ�-���
	function getSecondhandCarAmt_h(){
		var fm = document.sh_form;
		var fm2 = document.form1;		
		
		var a_b 	= <%=String.valueOf(fee_add.get("CON_MON"))%>;
		var rent_dt 	= <%=s_rent_dt%>;

				
		fm.fee_opt_amt.value= fm2.fee_opt_amt.value;		
		fm.rent_st.value 	= '2';//����
		fm.mode.value 		= 'lc_rent';
		
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "i_no";
		fm.submit();
	}	
	
	//�߰������� ����ϱ�-���
	function getSecondhandCarAmt(){
		var fm = document.sh_form;
		var fm2 = document.form1;		

		var a_b 	= <%=String.valueOf(fee_add.get("CON_MON"))%>;
		var rent_dt 	= <%=s_rent_dt%>;

		fm.fee_opt_amt.value= fm2.fee_opt_amt.value;		
		fm.rent_st.value 	= '2';//����
		fm.mode.value 		= 'view';
		
		fm.action = "/acar/secondhand/getSecondhandBaseSet.jsp";
		fm.target = "_blank";
		fm.submit();
	}	

	//������ġ�� ����
	function set_janga(){
		
		var a_b 	= <%=String.valueOf(fee_add.get("CON_MON"))%>;
		var rent_dt 	= <%=s_rent_dt%>;


		var fm = document.sh_form;
		
			fm.rent_st.value = '2';
			fm.a_b.value 	 = a_b;
			fm.mode.value 	 = 'cmpadd';
			fm.action='/acar/secondhand/getSecondhandJanga.jsp';
			fm.target='i_no';
			fm.submit();	

	}
	
	//������ġ�� ����
	function set_janga_b(){
		
		var a_b 	= <%=String.valueOf(fee_add.get("CON_MON"))%>;
		var rent_dt 	= <%=s_rent_dt%>;


		var fm = document.sh_form;
		
			fm.rent_st.value = '2';
			fm.a_b.value 	 = a_b;
			fm.mode.value 	 = 'cmpadd';
			fm.action='/acar/secondhand/getSecondhandJanga.jsp';			
			fm.target='_blank';			
			fm.submit();	

	}	
	

	//����
	function update(st, rent_st){
		var height = 500;
		if(st == 'fee'){
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=50, top=50, width=850, height="+height+", scrollbars=yes");
		}else if(st == 'cls_n'){
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=50, top=50, width=850, height="+height+", scrollbars=yes");		
		}else if(st == 'car'){
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=50, top=50, width=850, height="+height+", scrollbars=yes");		
		}else{
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM", "left=50, top=50, width=850, height="+height+", scrollbars=yes");				
		}
	}
			
	//�������� ����
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=base.getCar_mng_id()%>", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
			
	//��������
	function view_sale_cost_add_lw(){
		var height = <%=s_height%>;
		window.open("/fms2/mis/view_sale_cost_cont_lw_add.jsp<%=valus%>", "VIEW_SALE_COST_LW", "left=0, top=0, width=850, height="+height+", scrollbars=yes");
	}	
			
	function getSecondhandCarDist(rent_dt, serv_dt, tot_dist){
		var fm = document.form1;
		rent_dt = fm.sh_day_bas_dt.value;
		serv_dt = fm.sh_km_bas_dt.value;
		tot_dist = fm.sh_tot_km.value;
		var height = 300;
		window.open("search_todaydist.jsp?car_mng_id=<%=base.getCar_mng_id()%>&rent_dt="+rent_dt+"&serv_dt="+serv_dt+"&tot_dist="+tot_dist, "VIEW_DIST", "left=0, top=0, width=650, height="+height+", scrollbars=yes");
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
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name="mode"				value="cmpadd">    
  <input type='hidden' name="rent_dt"			value="<%=s_rent_dt%>">    
  <input type='hidden' name="rent_st"			value="">      
  <input type='hidden' name="a_b"				value="<%=String.valueOf(fee_add.get("CON_MON"))%>">     
  <input type='hidden' name="fee_opt_amt"		value="<%=fee_opt_amt%>">
  <input type='hidden' name="cust_sh_car_amt"	value="">   
  <input type='hidden' name="jg_b_dt"			value="">
  <input type='hidden' name="a_j"				value="">  
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
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="fee_rent_st" 		value="<%=rent_st%>"> 
  <input type='hidden' name="add_rent_st" 		value="<%=add_rent_st%>">   
  <input type='hidden' name="rent_dt"			value="<%=s_rent_dt%>">
  <input type='hidden' name="a_b"				value="">       
  <input type='hidden' name="esti_stat"			value="">  
  <input type='hidden' name="jg_b_dt"			value="">
  <input type='hidden' name="a_j"				value="">    
  <input type='hidden' name="mode"				value="cmpadd">
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �߰����念��ȿ�������Ȳ > <span class=style5>�߰����念��ȿ�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>  
    <tr>
	    <td align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border="0"></a></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>����ȣ</td>
            <td width=15%>&nbsp;<%=rent_l_cd%></td>
            <td class=title width=10%>�������</td>
            <td width=15%>&nbsp;<%if(rent_st.equals("1")){%>
			<%=AddUtil.ChangeDate2(base.getRent_dt())%>
			<%}else{%>
			<%=AddUtil.ChangeDate2(fee.getRent_dt())%>(����)
			<%}%></td>
            <td class=title width=10%>���������</td>
            <td width=15%>&nbsp;
			<%=c_db.getNameById(base.getBus_id2(),"USER")%>
			</td>
            <td class=title width=10%>�����븮��</td>
            <td width=12%>&nbsp;</td>			
          </tr>
          <tr> 
            <td class=title>��������</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
            <td class=title>��౸��</td>
            <td>&nbsp;<%String c_rent_st = base.getRent_st();%><%if(c_rent_st.equals("1")){%>�ű�<%}else if(c_rent_st.equals("3")){%>����<%}else if(c_rent_st.equals("4")){%>����<%}%></td>
            <td class=title>�뵵����</td>
            <td>&nbsp;<b><%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></b></td>
            <td class=title>��������</td>
            <td>&nbsp;<b><%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}else if(rent_way.equals("2")){%>�����<%}%></b></td>
          </tr>		  
          <tr> 
            <td class=title>��ȣ/����</td>
            <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
            <td class=title>�ſ���</td>
            <td colspan="3">&nbsp;<b><%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
              <% if(cont_etc.getDec_gr().equals("3")) out.print("�ż�����"); 	%>
              <% if(cont_etc.getDec_gr().equals("0")) out.print("�Ϲݰ�"); 	%>
              <% if(cont_etc.getDec_gr().equals("1")) out.print("�췮���"); 	%>
              <% if(cont_etc.getDec_gr().equals("2")) out.print("�ʿ췮���");  %></b></td>
          </tr>		  		  
        </table>
	  </td>
    </tr>
    <tr>
        <td></td>
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
		  <%if(!cr_bean.getCar_no().equals("")){%>
		  <tr>
		    <td width='13%' class='title'> ������ȣ </td>
		    <td width="15%">&nbsp;<%=cr_bean.getCar_no()%></td>
        	<td class='title' width="10%">������ȣ</td>
		    <td width="25%">&nbsp;<%=cr_bean.getCar_doc_no()%>&nbsp;(<%String car_ext = cr_bean.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>)</td>
		    <td width="10%" class='title'>���ʵ����</td>
		    <td width="27%">&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
		  </tr>			  
		  <%}%>	  
          <tr>
            <td width='13%' class='title'>�ڵ���ȸ��</td>
            <td width="15%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
            <td class='title' width="10%">����</td>
            <td width="25%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
            <td class='title' width='10%'>����</td>
            <td width="27%">&nbsp;<%=cm_bean.getCar_name()%></td>
          </tr>
          <tr>
            <td class='title'>�Һз� </td>
            <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
            <td class='title' width="10%">�����ڵ�</td>
            <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%>			  
		    </td>
            <td class='title'>��ⷮ</td>
            <td>&nbsp;<%=cr_bean.getDpm()%>cc</td>
          </tr>
          <tr>
            <td class='title'>�ɼ�</td>
            <td colspan="3">&nbsp;<%=car.getOpt()%></td>
            <td class='title'> ����</td>
            <td>&nbsp;<%=car.getColo()%>
            </td>			  
          </tr>
		  <%if(car.getLpg_yn().equals("Y")){%>
          <tr>
            <td class='title'>LPGŰƮ</td>
            <td colspan="5" >
			  <table width="350" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="80">&nbsp;����: <%String lpg_yn = car.getLpg_yn();%><%if(lpg_yn.equals("Y")){%>����<%}else if(lpg_yn.equals("N")){%>������<%}%></td>
                  <td width="130">&nbsp;���: <%String lpg_setter = car.getLpg_setter();%><%if(lpg_setter.equals("1")){%>������<%}else if(lpg_setter.equals("2")){%>���뿩�ῡ ����<%}else if(lpg_setter.equals("3")){%>�����ݿ� ����<%}else if(lpg_setter.equals("4")){%>��������<%}%></td>
                  <td>&nbsp;ŰƮ: <%String lpg_kit = car.getLpg_kit();%><%if(lpg_kit.equals("1")){%>�����л�<%}else if(lpg_kit.equals("2")){%>�����л�<%}else if(lpg_setter.equals("3")){%>�����Ұ�<%}%>				  
				  </td>				                   
                </tr>
              </table>
			</td>
		  </tr>		
		  <%}%>          
          <tr>
            <td class='title'>�����μ���</td>
            <td colspan="3">&nbsp;<%=c_db.getNameByIdCode("0035", "", pur.getUdt_st())%>
			&nbsp; �μ��� Ź�۷� : <%=AddUtil.parseDecimal(pur.getCons_amt1())%>�� (���μ��� ���� ���� �Է�)</td>
            <td class='title'>�������</td>
            <td>&nbsp;<%String car_ext = car.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%></td>
          </tr>		
          <tr>
            <td class='title'><span class="title1">��������Ÿ�</span></td>
            <td>&nbsp;1�����&nbsp;<%int agree_dist = f_fee_etc.getAgree_dist();%><%if(agree_dist==0){%>���Ѿ���<%}else{%><%=agree_dist%>km<%}%></td>
            <td class='title'>������/������ ���ּ���</td>
            <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", pur.getEcar_loc_st())%><%=c_db.getNameByIdCode("0037", "", pur.getHcar_loc_st())%></td>
            <td class='title'>�������ｺƼĿ �߱�<br>(�����ͳ� �̿� �����±�)</td>
            <td>&nbsp;<%String eco_e_tag = car.getEco_e_tag();%><%if(eco_e_tag.equals("0")){%>�̹߱�<%}else if(eco_e_tag.equals("1")){%>�߱�<%}%></td>
          </tr>
          <tr>
            <td class='title'><span class="title1">������߰�����</span></td>
            <td colspan="5">&nbsp;<%=car.getAdd_opt()%>&nbsp;<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>��<font color="#666666">(�ΰ������Աݾ�, ���� �ݿ���, LPGŰƮ����, �׺���̼� ��)</font></td>
          </tr>
          <tr>
            <td class='title'><span class="title1">����ǰ��</span></td>
            <td colspan="5">&nbsp;<%=car.getExtra_set()%>&nbsp;<%=AddUtil.parseDecimal(car.getExtra_amt())%>��<font color="#666666">(�ΰ������Աݾ�, �����̹ݿ���)</font></td>
          </tr>		      
        </table>
      </td>
    </tr>
	<tr>
        <td></td>
    </tr>
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
            <td align=center>&nbsp;
              <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td align=center>&nbsp;
              <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td align=center>&nbsp;
              <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td class=title>��������</td>
            <td align=center>&nbsp;
              <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td align=center>&nbsp;
              <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td align=center>&nbsp;
              <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
          </tr>
          <tr>
            <td height="12" class='title'>�ɼ�</td>
            <td align=center>&nbsp;
              <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td align=center>&nbsp;
              <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td align=center>&nbsp;
              <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td class=title>Ź�۷�</td>
            <td height="12" align=center>&nbsp;
              <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td height="12" align=center>&nbsp;
              <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td height="12" align=center>&nbsp;
              <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
          </tr>
          <tr>
            <td height="26" class='title'> ����</td>
            <td align=center>&nbsp;
              <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td align=center>&nbsp;
              <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td align=center>&nbsp;
              <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
     			��</td>
            <td class=title>����D/C</td>
            <td align=center>&nbsp;
              <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
				��</td>
            <td align=center>&nbsp;
              <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
				��</td>
            <td align=center>&nbsp;
              <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
				��</td>
          </tr>
              <tr id=tr_ecar_dc <%if(car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>���Ҽ� �����</td>
                <td align=center>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align=center>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td align=center>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>            
          <tr>
            <td align="center" class='title_p'>�հ�</td>
            <td class='title_p'>&nbsp;
              <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
			    ��</td>
            <td class='title_p'>&nbsp;
              <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
				��</td>
            <td class='title_p'>&nbsp;
              <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
				��</td>
            <td align='center' class='title_p'>�հ�</td>
            <td class='title_p'>&nbsp;
              <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
				��</td>
            <td class='title_p'>&nbsp;
              <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
				��</td>
            <td class='title_p'>&nbsp;
              <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
				��</td>
          </tr>
        </table>		
	  </td>
    </tr>		
	<%if((car.getS_dc1_amt()+car.getS_dc2_amt()+car.getS_dc3_amt())>0){%>
	<tr>
	    <td class=line2></td>
	</tr>	
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='10%'> ���� </td>
					<td class='title' width='17%'>����D/C ����</td>
					<td class='title' width='35%'>����</td>					
					<td class='title' width='13%'>�Һ��ڰ����</td>										
					<td width="12%" class='title'>�뿩��ݿ�����</td>
				    <td width="13%" class='title'>�ݾ�</td>
			    </tr>
				<tr>
					<td align='center'>1</td>
					<td>&nbsp;
					  <select name='s_dc1_re' class='default' disabled>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc1_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc1_re_etc' size='35' class="whitetext" value='<%=car.getS_dc1_re_etc()%>'>
					<td align="center">  
					  <input type='text' name='s_dc1_per' size='4' class="whitetext" value='<%=car.getS_dc1_per()%>' onBlur='javascript:setDc_per_amt(1);'>%
					</td>
					<td align="center"><select name='s_dc1_yn' class='default' disabled>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc1_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc1_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc1_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc1_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_dc_amt();'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>2</td>
					<td>&nbsp;
					  <select name='s_dc2_re' class='default' disabled>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc2_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc2_re_etc' size='35' class="whitetext" value='<%=car.getS_dc2_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc2_per' size='4' class="whitetext" value='<%=car.getS_dc2_per()%>' onBlur='javascript:setDc_per_amt(2);'>%
					</td>
					<td align="center"><select name='s_dc2_yn' class='default' disabled>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc2_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc2_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc2_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc2_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_dc_amt();'>
     					 ��</td>
			    </tr>
				<tr>
					<td align='center'>3</td>
					<td>&nbsp;
					  <select name='s_dc3_re' class='default' disabled>
                        <option value="">����</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc3_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc3_re_etc' size='35' class="whitetext" value='<%=car.getS_dc3_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc3_per' size='4' class="whitetext" value='<%=car.getS_dc3_per()%>' onBlur='javascript:setDc_per_amt(3);'>%
					</td>
					<td align="center"><select name='s_dc3_yn' class='default' disabled>
                              <option value="">����</option>
                              <option value="Y" <%if(car.getS_dc3_yn().equals("Y")) out.println("selected");%>>�ݿ�</option>
                              <option value="N" <%if(car.getS_dc3_yn().equals("N")) out.println("selected");%>>�̹ݿ�</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc3_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc3_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_dc_amt();'>
     					 ��</td>
			    </tr>
		  </table>
		</td>
	</tr>		  
	<%}%>
	<tr>
        <td></td>
    </tr>
	<tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�߰�������</span></td>
    </tr>	
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr id=tr_car0 style="display:''"> 
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
			if(fee_etc.getSh_car_amt() == 0){
				sh_car_amt 		= AddUtil.parseInt((String)sh_ht.get("CAR_AMT"))+AddUtil.parseInt((String)sh_ht.get("OPT_AMT"))+AddUtil.parseInt((String)sh_ht.get("COL_AMT"));
				sh_year 		= String.valueOf(carOld.get("YEAR"));
				sh_month 		= String.valueOf(carOld.get("MONTH"));
				sh_day	 		= String.valueOf(carOld.get("DAY"));
				sh_km			= AddUtil.parseInt(String.valueOf(sh_ht.get("TODAY_DIST")));
				sh_tot_km		= AddUtil.parseInt(String.valueOf(sh_ht.get("TOT_DIST")));
				sh_km_bas_dt	= String.valueOf(sh_ht.get("SERV_DT"));
				sh_day_bas_dt	= s_rent_dt;
			}else{
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
			}
		if(sh_init_reg_dt.equals("")) sh_init_reg_dt = cr_bean.getInit_reg_dt();
	%>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> �����Һ��ڰ� </td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(sh_car_amt)%>'size='10' class='defaultnum' readonly >
        				  �� 
        				  <input type='hidden' name="view_car_amt" value=""></td>
                    <td class='title' width="10%">�ܰ���</td>
                    <td width="10%">&nbsp;
                      <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher(sh_ja,2) %>'size='4' class='defaultnum' readonly >
					  %</td>
                    <td class='title' width='10%'>�߰�����</td>
                  <td width="37%">&nbsp;
                    <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(sh_amt) %>'size='10' class='defaultnum'  readonly>
					  ��
					  <span class="b"><a href="javascript:getSecondhandCarAmt_h()" onMouseOver="window.status=''; return true" title="�߰����� ����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
        			  &nbsp;&nbsp;
					  <span class="b"><a href="javascript:getSecondhandCarAmt()" onMouseOver="window.status=''; return true" title="�߰����� ����ϱ�"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
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
				  <%	if(!base.getDlv_dt().equals("")) sh_init_reg_dt = base.getDlv_dt();%>
				  , <%=a_db.getUseDays(sh_day_bas_dt, sh_init_reg_dt)%>��
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
					  <span class="b"><a href="javascript:getSecondhandCarDist('<%=sh_day_bas_dt%>','<%=sh_km_bas_dt%>','<%=sh_tot_km%>')" onMouseOver="window.status=''; return true" title="�߰����� ����ϱ�"><img src=/acar/images/center/button_in_jhgl.gif align=absmiddle border=0></a></span>
        			  &nbsp;&nbsp;
					  <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="���񳻿�����"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>
					 </td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
        <td></td>
    </tr>
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
            <td width="13%" class=title>��������</td>
            <td width="15%">&nbsp;
              <%String insurant = cont_etc.getInsurant();%>
              <%if(insurant.equals("1") || insurant.equals("")){%>
                �Ƹ���ī
              <%}else if(insurant.equals("2")){%>
                ��
              <%}%>
            </td>
            <td width="10%" class=title>�Ǻ�����</td>
            <td colspan='3'>&nbsp;
              <%String insur_per = cont_etc.getInsur_per();%>
              <%if(insur_per.equals("1") || insur_per.equals("")){%>
                �Ƹ���ī
              <%}else if(insur_per.equals("2")){%>
                ��
              <%}%>
            </td>
	
		  </tr>
          <tr>
            <td width="13%" class=title>������å��</td>
            <td width="15%" class=''>&nbsp;<%=AddUtil.parseDecimal(base.getCar_ja())%>��</td>
            <td width="10%" class=title >�����ڿ���</td>
            <td colspan='3'>&nbsp;
              <%String driving_age = base.getDriving_age();%>
              <%if(driving_age.equals("0")){%>
                 26���̻�
              <%}else if(driving_age.equals("3")){%>
                 24���̻�
              <%}else if(driving_age.equals("1")){%>
                 21���̻�
              <%}else if(driving_age.equals("2")){%>
               	 ��������
              <%}else if(driving_age.equals("5")){%>
               	 30���̻�
              <%}else if(driving_age.equals("6")){%>
               	 35���̻�
              <%}else if(driving_age.equals("7")){%>
               	 43���̻�
              <%}else if(driving_age.equals("8")){%>
               	 48���̻�
              <%}else if(driving_age.equals("9")){%>
               	 22���̻�
              <%}else if(driving_age.equals("10")){%>
               	 28���̻�
              <%}else if(driving_age.equals("11")){%>
               	 35���̻�~49������
              <%}%>
            </td>			
		  </tr>		  
          <tr>
             <td width="13%" class=title>�빰���</td>
             <td width="15%" class=''>&nbsp;
               <%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5õ����<%}else if(gcp_kd.equals("2")){%>1���<%}else if(gcp_kd.equals("3")){%>5���<%}else if(gcp_kd.equals("4")){%>2���<%}else if(gcp_kd.equals("8")){%>3���<%}%></td>
             <td width="10%" class=title >�ڱ��ü���</td>
             <td width="25%" class=''>&nbsp;
               <%String bacdt_kd = base.getBacdt_kd();%>
               <%if(bacdt_kd.equals("1")){%>
                    5õ����
               <%}else if(bacdt_kd.equals("2")){%>
                    1���
               <%}else if(bacdt_kd.equals("9")){%>
                    �̰���
               <%}%></td>
            <td width="10%" class=title>����⵿</td>
            <td width="27%" class=''>&nbsp;
              <%String eme_yn = cont_etc.getEme_yn();%>
              <%if(eme_yn.equals("Y")){%>
                ����
              <%}else if(eme_yn.equals("N")){%>
                �̰���
              <%}%></td>
           </tr>
        </table>
      </td>
    </tr>		

	<tr>
        <td></td>
    </tr>
	<tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>	
	<tr>
	    <td class=line2></td>
	</tr>	
	<tr>
      <td class=line><table border="0" cellspacing="1" cellpadding="0" width=100%>
	<%	for(int f=1; f<=gin_size ; f++){
			ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));			
			
			if(f<gin_size ){%>                
          <tr>
            <td width="13%"class=title>��������</td>
            <td width="15%">&nbsp;<%=ext_gin.getGi_jijum()%></td>
            <td width="10%" class='title'>���Աݾ�</td>
            <td width="25%">&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>��</td>
            <td width="10%" class=title >���������</td>
            <td width="27%">&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>��</td>
          </tr>
          <%}else{%>
          <tr>
            <td width="13%"class=title>��������</td>
            <td width="15%">&nbsp;<%=ext_gin.getGi_jijum()%></td>
            <td width="10%" class='title'>���Աݾ�</td>
            <td width="25%">&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>��</td>
            <td width="10%" class=title >���������</td>
            <td width="27%">&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>��</td>
          </tr>
          <%}%>
          <%}%>
      </table></td>
    </tr>
	<tr>
        <td></td>
    </tr>
	<tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</span></td>
    </tr>	
	<tr>
	    <td class=line2></td>
	</tr>	
	<tr>	
	  <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
          <tr>
            <td style="font-size : 8pt;" width="3%" class=title rowspan="2">����</td>
            <td style="font-size : 8pt;" width="10%" class=title rowspan="2">�������</td>
            <td style="font-size : 8pt;" width="4%" class=title rowspan="2">�̿�<br>�Ⱓ</td>
            <td style="font-size : 8pt;" width="4%" class=title rowspan="2">����<br>�Ⱓ</td>			
            <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 8pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 8pt;" width="7%" class=title rowspan="2">�����</td>
            <td style="font-size : 8pt;" width="9%" class=title rowspan="2">���뿩��</td>
            <td style="font-size : 8pt;" class=title colspan="2">������</td>
            <td style="font-size : 8pt;" width="10%" class=title rowspan="2">������</td>
            <td style="font-size : 8pt;" class=title colspan="2">���ô뿩��</td>
            <td style="font-size : 8pt;" class=title colspan="2">���Կɼ�</td>
          </tr>
          <tr>
            <td style="font-size : 8pt;" width="9%" class=title>�ݾ�</td>
            <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 8pt;" width="9%" class=title>�ݾ�</td>
            <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 8pt;" width="3%" class=title>%</td>			
          </tr>
		  <%for(int i=0; i<fee_size; i++){
				ContFeeBean fees 		= a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				ContCarBean fee_etcs 	= a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				if(!fees.getCon_mon().equals("")){%>	
          <tr>
            <td style="font-size : 8pt;" align="center"><%=i+1%></td>
            <td style="font-size : 8pt;" align="center"><a href="javascript:update('fee','<%=i+1%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
            <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>����</td>
            <td style="font-size : 8pt;" align="center"><%=fee_etcs.getCls_n_mon()%>����</td>			
            <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
            <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
            <td style="font-size : 8pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
            <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��&nbsp;</td>
            <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
          </tr>
		  <%}}%>
        </table>		
	  </td>
	</tr>	
	<tr></tr><tr></tr><tr></tr>
    <tr> 	
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>		
          <tr>
            <td width="13%" align="center" class=title>�̿�Ⱓ</td>
            <td width="15%">&nbsp;
                <input type='text' name="con_mon" value='<%=String.valueOf(fee_add.get("CON_MON"))%>' size="4" maxlength="2" class='whitetext' onChange='javascript:set_cont_date(this)'>
    			 ����
    			 <%if(e_bean.getRent_st().equals("a") && !e_bean.getEtc().equals("")){ %>
    			 (�ǰ�����:<%=e_bean.getEtc()%>����)
    			 <%}%>
    		</td>
            <td width="10%" align="center" class=title>�뿩������</td>
            <td width="25%">&nbsp;
              <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(fee_add.get("RENT_START_DT")))%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'></td>
            <td width="10%" align="center" class=title>�뿩������</td>
            <td width="27%">&nbsp;
              <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(fee_add.get("RENT_END_DT")))%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);'></td>
          </tr>		  
		  <input type='hidden' name='rent_suc_commi'	value="">
		  <input type='hidden' name='cls_n_mon'			value="">
		  <input type='hidden' name='cls_n_amt'			value="">		  		  
        </table>				
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td class='title'>����</td>
            <td class='title' width='11%'>���ް�</td>
            <td class='title' width='11%'>�ΰ���</td>
            <td class='title' width='13%'>�հ�</td>
            <td class='title' width='4%'>�Ա�</td>
            <td class='title' width="28%">�������</td>
            <td class='title' width='20%'>��������</td>
          </tr>
          <tr>
            <td class='title'>������</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  ��</td>
            <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fee.getRent_st(), "0")%></td>
            <td align="center">������
                <input type='text' size='4' name='gur_p_per' class='whitenum' value='<%=fee.getGur_p_per()%>' readonly>
				  % </td>
            <td align='center'>
			<%if(fee.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fee.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%>
			  <input type='hidden' name='gur_suc_yn' value='<%=fee.getGrt_suc_yn()%>'>
			  <input type='hidden' name='gur_per' value=''>
			  <input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>'></td>
          </tr>
          <tr>
            <td class='title'>���뿩��</td>
            <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  ��</td>
            <td align="center" ><input type='text' size='10'  name='fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  ��</td>
            <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  ��</td>
            <td align='center'>-</td>
            <td align="center">-</td>
            <td align='center'>-</td>
          </tr>
          <tr>
            <td class='title'>����뿩��</td>
            <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(fee_add.get("INV_S_AMT")))+AddUtil.parseInt(String.valueOf(fee_add.get("INS_S_AMT")))+fee_etc.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  ��</td>
            <td align="center" ><input type='text' size='10' name='inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(fee_add.get("INV_V_AMT")))+AddUtil.parseInt(String.valueOf(fee_add.get("INS_V_AMT")))+fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  ��</td>
            <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(fee_add.get("INV_S_AMT")))+AddUtil.parseInt(String.valueOf(fee_add.get("INV_V_AMT")))+AddUtil.parseInt(String.valueOf(fee_add.get("INS_S_AMT")))+AddUtil.parseInt(String.valueOf(fee_add.get("INS_V_AMT")))+fee_etc.getDriver_add_amt()+fee_etc.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
				  ��</td>
            <td align='center'>-</td>
            <td align="center">-</td>
            <td align='center'></td>
          </tr>            
		  <%if(fee_opt_amt>0){//������� ���Կɼ��� �ִ� ���%>
          <tr>
            <td class='title'>�������Կɼ�</td>
            <td colspan="2" align="center">-</td>
            <td align='center'><input type='text' size='10' name='fee_opt_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_opt_amt)%>'>
				  ��</td>
            <td align='center'>-</td>
            <td align="center">-</td>
            <td align='center'>-</td>
          </tr>  		  
		  <%}else{%>
		    <input type='hidden' name="fee_opt_amt"		value="">
		  <%}%>
          <tr>
            <td class='title'>���</td>
            <td colspan="6">&nbsp;
              <%=fee.getFee_cdt()%></td>
          </tr>					  
        </table>
	  </td>
    </tr>	
	<tr>
        <td></td>
    </tr>
	<tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>	
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr>
                <td width="13%" class=title>��������</td>
                <td width="15%">&nbsp;<%=cls.getCls_st()%></td>
                <td width="10%" class=title>��������</td>
                <td width="15%">&nbsp;<%=cls.getCls_dt()%></td>
                <td width="10%" class=title>��������</td>
                <td width="37%">&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%></td>
              </tr>		    		  		    		  	    
            </table>	
		</td>
	</tr>		
	<tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2" style='background-color:bebebe; height:1;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>	
	<tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ȿ��</span></td>
    </tr>	
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>	
          <tr>
            <td width="13%" class='title'>�ִ��ܰ�</td>
            <td width='28%' align="center">������
			  <input type='text' size='4' name='o_13' maxlength='10' class='fixnum' value='<%=e_bean.getO_13()%>'>
			  %</td>
            <td width="11%" class='title'>�����ܰ�</td>
            <td width='28%' align='center'><input type='text' size='4' name='ro_13' maxlength='10' class='fixnum' value='<%=e_bean.getRo_13()%>'>
			  %&nbsp;&nbsp;&nbsp;&nbsp;
			  <input type='text' size='10' name='ro_13_amt' maxlength='11' class=fixnum value='<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>'>
				  ��
            <td width='20%' align='center'></td>
          </tr>
		</table>
	  </td>	  
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>  
    <tr> 
      <td> 
        <table border="0" cellspacing="0" cellpadding='0' width=100%>
            <tr>
                <td class=line2></td>
            </tr>
		  <tr>
		    <td class=line width="100%">
			  <table border="0" cellspacing="1" cellpadding='0' width=100%>
		        <tr>
				  <td width="13%" class=title>��ȣ</td>
				  <td width="11%" class=title>�ڵ�</td>				  
				  <td width="28%" class=title>�̸�</td>
				  <td width="28%" class=title>��</td>
				  <td width="20%" class=title>-</td>				  
				</tr>
		        <tr>
				  <td align="center">E-1</td>
				  <td align="center">bc_b_e1</td>				  
				  <td>�������󰡴�����簡ġ����¼��ǱⰣ�ݿ���</td>
				  <td align="center"><input type='text' size='12' name='bc_b_e1' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_e1()%>'>&nbsp;</td>
				  <td rowspan='2' align="center"></td>
				</tr>
		        <tr>
				  <td align="center">E-2</td>
				  <td align="center">bc_b_e2</td>				  
				  <td>����忹��������</td>
				  <td align="center"><input type='text' size='12' name='bc_b_e2' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_e2()%>'>&nbsp;</td>
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
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
      <td> 
        <table border="0" cellspacing="0" cellpadding='0' width=100%>
		  <tr>
		    <td class=line width="100%">
			  <table border="0" cellspacing="1" cellpadding='0' width=100%>
		        <tr>
				  <td width="13%" class=title>��ȣ</td>
				  <td width="11%" class=title>�ڵ�</td>				  
				  <td width="28%" class=title>�̸�</td>
				  <td width="28%" class=title>��</td>
				  <td width="20%" class=title>-</td>				  
				</tr>
		        <tr>
				  <td align="center">a</td>
				  <td align="center">bc_s_a</td>				  
				  <td>10��������Һα�</td>
				  <td align="center"><input type='text' size='12' name='bc_s_a' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_a()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
				  <td rowspan='17' align="center">
					  <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ڸ��",user_id) || nm_db.getWorkAuthUser("��������",user_id)){%>
					  <span class="b"><a href="javascript:estimate_cmp('account', '')" onMouseOver="window.status=''; return true" title="����ȿ������"><img src=/acar/images/center/button_in_cal.gif border=0 align=absmiddle></a></span>
					  <%}%>
				  </td>				  
				</tr>
		        <tr>
				  <td align="center">b</td>
				  <td align="center">bc_s_b</td>				  
				  <td>���Ⱓ</td>
				  <td align="center"><input type='text' size='12' name='bc_s_b' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_b()%>'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">c</td>
				  <td align="center">bc_s_c</td>				  
				  <td>���ش뿩��</td>
				  <td align="center"><input type='text' size='12' name='bc_s_c' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_c()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">d</td>
				  <td align="center">bc_s_d</td>				  
				  <td>��ǥ������</td>
				  <td align="center"><input type='text' size='12' name='bc_s_d' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_d()%>'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">e</td>
				  <td align="center">bc_s_e</td>				  
				  <td>�����ܰ��������������뿩����������</td>
				  <td align="center"><input type='text' size='12' name='bc_s_e' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_e()%>'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">f</td>
				  <td align="center">bc_s_f</td>				  
				  <td>��ü������</td>
				  <td align="center"><input type='text' size='12' name='bc_s_f' maxlength='10' class=fixnum value='' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">g</td>
				  <td align="center">bc_s_g</td>				  
				  <td>����뿩��</td>
				  <td align="center"><input type='text' size='12' name='bc_s_g' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">i</td>
				  <td align="center">bc_s_i</td>				  
				  <td>ĳ������</td>
				  <td align="center"><input type='text' size='12' name='bc_s_i' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_i()%>'>&nbsp;</td>
				</tr>
				<tr>
				  <td align="center">i2</td>
				  <td align="center">bc_s_i2</td>				  
				  <td>ĳ������</td>
				  <td align="center"><input type='text' size='12' name='bc_s_i' maxlength='10' class=fixnum value='<%=fee_etc.getBc_s_i2()%>'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">A</td>
				  <td align="center">bc_b_a</td>				  
				  <td>�⺻�İ�����</td>
				  <td align="center"><input type='text' size='12' name='bc_b_a' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_a()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">B</td>
				  <td align="center">bc_b_b</td>				  
				  <td>�Ϲݽ��߰�������</td>
				  <td align="center"><input type='text' size='12' name='bc_b_b' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_b()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">D</td>
				  <td align="center">bc_b_d</td>				  
				  <td>�縮���ʱ⿵�����</td>
				  <td align="center"><input type='text' size='12' name='bc_b_d' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_d()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">K</td>
				  <td align="center">bc_b_k</td>				  
				  <td>�Ϲݽ��ּҰ������</td>
				  <td align="center"><input type='text' size='12' name='bc_b_k' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_k()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">N</td>
				  <td align="center">bc_b_n</td>				  
				  <td>��������ĿŹ�۷�</td>
				  <td align="center"><input type='text' size='12' name='bc_b_n' maxlength='10' class=fixnum value='<%=fee_etc.getBc_b_n()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;</td>
				</tr>
		        <tr>
				  <td align="center">G</td>
				  <td align="center">bc_b_g</td>				  
				  <td>��Ÿ����</td>
				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='num' value='<%=fee_etc.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='20' name='bc_b_g_cont' maxlength='30' class=text value='<%=fee_etc.getBc_b_g_cont()%>'></td>
				</tr>
		        <tr>
				  <td align="center">U</td>
				  <td align="center">bc_b_u</td>				  
				  <td>��Ÿ���(�����߰����޵�)</td>
				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='num' value='<%=fee_etc.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='20' name='bc_b_u_cont' maxlength='30' class=text value='<%=fee_etc.getBc_b_u_cont()%>'></td>
				</tr>
		        <tr>
				  <td align="center">AC</td>
				  <td align="center">bc_b_ac</td>				  
				  <td>��Ÿ ����ȿ���ݿ���</td>
				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='num' value='<%=fee_etc.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;����: <input type='text' size='20' name='bc_b_ac_cont' maxlength='30' class=text value='<%=fee_etc.getBc_b_ac_cont()%>'></td>
				</tr>
		      </table>		
			</td>						
		  </tr>
        </table>
	  </td>
    </tr>		
	<%if(!fee_etc.getBc_est_id().equals("")){%>	
	<tr>
	    <td>&nbsp;</td>
    </tr>			
	<tr>
	    <td align="center"><a href="javascript:view_sale_cost_add_lw()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_see_yuhy.gif border=0 align=absmiddle></a></td>
    </tr>			
	<%}%>	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
		
	fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
	fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
	fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
		
	fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
	fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
	fm.tot_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							



	<%	if(sh_amt==0){//������� ���Կɼ��� �ִ� ���%>		
	getSecondhandCarAmt_h();
	<%	}%>
//-->
</script>
</body>
</html>
