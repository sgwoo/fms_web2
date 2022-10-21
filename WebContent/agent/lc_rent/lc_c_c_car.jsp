<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.doc_settle.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	
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
	String mode	 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//����������
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//�Һ�����
	ContDebtBean debt = a_db.getContDebt(rent_mng_id, rent_l_cd);
	
	//�⺻��� ���� ����
	String car_b_inc_name = cmb.getCar_b_inc_name(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�߰����ܰ� ����
	Hashtable janga 	= new Hashtable();
	Hashtable carOld 	= new Hashtable();
	if(base.getCar_gu().equals("0")){
		janga = shDb.getJanga_20070528(base.getCar_mng_id());
		carOld = c_db.getOld(cr_bean.getInit_reg_dt(), base.getRent_dt());
	}

	//3. �뿩-----------------------------
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//Ư�Ҽ�����
	TaxScdBean tax = t_db.getTaxScdCase(rent_mng_id, rent_l_cd, base.getCar_mng_id());

	//4. ����----------------------------
	
	
	//�ܰ�����NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
		
	String a_e = cm_bean.getS_st();
		
	from_page = "/agent/lc_rent/lc_c_c_car.jsp";
	
	String valus = 	"?user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(ext_fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}	
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(ext_fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
	}
	
					
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����
	function update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id'){
			window.open("/agent/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}else{
			var height = 500;
			if(st == 'car') 				height = 700;
			else if(st == 'car_amt') 		height = 500;
			else if(st == 'insur') 			height = 600;
			else if(st == 'gi') 			height = 300;
			window.open("/agent/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
		}
	}
	
	//4�ܰ� -----------------------------------------------------------
		
	//���� �Һ��ڰ� �հ�
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
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
	

	
	//�ش� ���� �������� �⺻��� ����
	function open_car_b(car_id, car_seq, car_name){
		fm = document.form1;
		window.open('view_car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=100, top=100, width=450, height=600, scrollbars=yes"); 
	}
	
	function view_car_amt(){
		var fm = document.form1;
		if(fm.view_car_amt.value == ''){
			tr_car1.style.display='';
			fm.view_car_amt.value = 'open';
		}else{
			tr_car1.style.display='none';
			fm.view_car_amt.value = '';			
		}
	}
	
	function OpenIns(ins_st){
		var theForm = document.CarRegForm;
		var url = "/agent/ins_mng/ins_u_frame.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&c_id=<%=base.getCar_mng_id()%>&ins_st="+ins_st+"&go_url=lc_rent&cmd=view";		
		window.open(url, "Ins", "left=100, top=50, width=850, height=610, scrollbars=no");		
	}
	
	//��������������Ư�� �̰��� ���� ó��
	function Com_emp_sac(){	
		var fm = document.form1;
		var ment = '';
		if('<%=cont_etc.getCom_emp_yn()%>'=='Y'){
			ment = '����';
		}else if('<%=cont_etc.getCom_emp_yn()%>'=='N'){
			ment = '�̰���';
		}else{
			alert('��������������Ư�� ���Կ��ΰ� �����ϴ�.'); return;
		}
		fm.cng_item.value = 'com_emp_sac';
		<%if(client.getClient_st().equals("1")){ %>
		if(ment=='�̰���'){
			if(confirm('��������������Ư�� �̰��� ���� ó���Ͻðڽ��ϱ�?')){	
				fm.action='lc_c_u_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}	
		}else{
			alert('���Խ����� �ʿ�����ϴ�.');
		}			
		<%}else{%>
		if(ment=='����'){
			if(confirm('���ǽŰ����ڷ� ��������������Ư�� ���� ����ó���Ͻðڽ��ϱ�?')){	
				fm.action='lc_c_u_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}
		}else{
			alert('�̰��Խ����� �ʿ�����ϴ�.');	
		}			
		<%}%>
	}		
	
	//�����̰���ϱ�
	function age_search()
	{
		var fm = document.form1;
		
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/agent/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}	
	
	//�⺻��纸���ֱ�
	function opt(car_id, car_seq){		
		var fm = document.form1;
		var SUBWIN="/fms2/lc_rent/lc_c_c_car_opt.jsp?car_id="+car_id+"&car_seq="+car_seq+"&from_page=<%=from_page%>";
		window.open(SUBWIN, "OPT", "left=10, top=10, width=798, height=550, scrollbars=yes, status=yes, resizable=no");
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

	function OpenImg(url){
	  	var img=new Image();
	  	var OpenWindow=window.open('','_blank', 'width=1000, height=760, menubars=no, scrollbars=auto');
	  	OpenWindow.document.write("<style>body{margin:0px;}</style><img src='"+url+"' width='990'>");
	 }
	
	//������ ���� �� ��������ǥ�� ��
	function span_dc_view(){
		var fm = document.form1;
		if(fm.dc_view_yn.checked==true){	$("#span_dc_view").css("display","");				}
		else{												$("#span_dc_view").css("display","none");		}
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
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"				value="<%=cm_bean.getCar_b()%>">
  <input type='hidden' name="s_st" 				value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">    
  <input type='hidden' name="rent_way" 			value="<%=ext_fee.getRent_way()%>">  
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
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name="o_1"				value="">
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
    
  <input type='hidden' name="cng_item"			value="">  
  <input type='hidden' name="msg_st"		value="">
  <input type='hidden' name='from_page2'	 	value='/agent/lc_rent/lc_c_c_car.jsp'>
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���� (<%=base.getCar_mng_id()%>)<%if(!mode.equals("view")){%><%if(user_id.equals("000000") || base.getBus_id().equals(user_id)){%>&nbsp;<a href="javascript:update('car')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( ������ : ����,�������,����,LPG����,�߰�����,��� ���� )</font><%}%></span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		    <%if(!cr_bean.getCar_no().equals("")){%>
    		    <tr>
        		    <td width='13%' class='title'>������ȣ</td>
        		    <td width="20%">&nbsp;<%=cr_bean.getCar_doc_no()%>&nbsp;(<%String car_ext = cr_bean.getCar_ext();%><%=c_db.getNameByIdCode("0032", "", car_ext)%>)</td>
                	<td width="10%" class='title'>���ʵ����</td>
        		    <td width="20%">&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                	<td width="10%" class='title'>���ɸ�����</td>
        		    <td>&nbsp;<%=cr_bean.getCar_end_dt()%></td>
    		    </tr>			  
    		    <%}%>	  
                <tr>
                    <td width='13%' class='title'>�ڵ���ȸ��</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' width="10%">����</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' width='10%'>����</td>
                    <td>&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[������]<%}%><a href="javascript:opt('<%=cm_bean.getCar_id()%>','<%=cm_bean.getCar_seq()%>');" onMouseOver="window.status=''; return true"><%=cm_bean.getCar_name()%></a></td>
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
                    <td class='title'>����</td>
                    <td>&nbsp;<% if(cm_bean.getDiesel_yn().equals("1")) out.print("�ֹ���"); %> <% if(cm_bean.getDiesel_yn().equals("Y")) out.print("����"); %> <% if(cm_bean.getDiesel_yn().equals("2")) out.print("LPG"); %> <% if(cm_bean.getDiesel_yn().equals("5")) out.print("����"); %> <% if(cm_bean.getDiesel_yn().equals("6")) out.print("����"); %></td>
                    <td class='title' width="10%">��������</td>
                    <td>&nbsp;<%=cr_bean.getTaking_p()%></td>
                    <td class='title'>���ӱ� </td>
                    <td>&nbsp;<% String auto_yn = "";
        			             if(cm_bean.getAuto_yn().equals("Y")) auto_yn="A/T";
        						 if(cm_bean.getAuto_yn().equals("N")) auto_yn="M/T";
        						 if(car.getOpt().indexOf("�ڵ����ӱ�") != -1) auto_yn="A/T";
        						 out.print(auto_yn); %></td>
                </tr>
                <tr>
                    <td class='title'>GPS��ġ������ġ</td>
                    <td colspan="5">&nbsp;<%if(cr_bean.getGps().equals("Y")){%>����<%}else{%>������<%}%></td>
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
                    			<% if(!car_b_inc_name.equals("")){ %> <a href="javascript:open_car_b('<%= cm_bean.getCar_b_inc_id() %>','<%= cm_bean.getCar_b_inc_seq() %>','<%= car_b_inc_name %>');"  onMouseOver="window.status=''; return true"><%= car_b_inc_name %> �⺻���</a> �� <br><% } %>
                    			<%=HtmlUtil.htmlBR(cm_bean.getCar_b())%></td>
                    	    </tr>
                    	    <tr>
                                <td style='height:3'></td>
                            </tr>
                    	</table>
                    </td>
                </tr>
                <tr>
                    <td class='title'>�ɼ�</td>
                    <td colspan="5">&nbsp;<a href="javascript:opt('<%=cm_bean.getCar_id()%>','<%=cm_bean.getCar_seq()%>');" onMouseOver="window.status=''; return true"><%=car.getOpt()%></a></td>
                </tr>
                <tr>
                    <td class='title'> ����</td>
                    <td colspan="3">&nbsp;<%=car.getColo()%> 
						<%if(!car.getIn_col().equals("")){%>
						&nbsp;&nbsp;&nbsp;
					  	(�������(��Ʈ): <%=car.getIn_col()%> )  
						<%}%>
						<%if(!car.getGarnish_col().equals("")){%>
						&nbsp;&nbsp;&nbsp;
					  	(���Ͻ�: <%=car.getGarnish_col()%> )  
						<%}%>
					</td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=car.getSun_per()%>%</td>
                </tr>
                <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>
                <tr>
                	<td class='title'>��縵ũ����</td>
                	<td colspan="5">&nbsp;
                		<%if(car.getBluelink_yn().equals("")){%><%}%>
                        <%if(car.getBluelink_yn().equals("Y")){%>����<%}%>
                        <%if(car.getBluelink_yn().equals("N")){%>����<%}%>
                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;�� �������ý� ��縵ũ ���� �ȳ��� �˸���߼�(�����ٻ�����)</span>
                	</td>
                </tr>
                <% } %>
          <tr>
          	<td class="title">����</td>
          	<td colspan="5"><%=car.getConti_rat()%></td>
          </tr>
          <%if(ej_bean.getJg_g_7().equals("3")){//������%>
          <tr>
            <td class='title'>������ ���ּ���</td>
            <td colspan="5">&nbsp;<%=c_db.getNameByIdCode("0034", "", pur.getEcar_loc_st())%></td>            
          </tr>
          <%}%>
          <%if(ej_bean.getJg_g_7().equals("4")){//������%>
          <tr>
            <td class='title'>������ ���ּ���</td>
            <td colspan="5">&nbsp;<%=c_db.getNameByIdCode("0037", "", pur.getHcar_loc_st())%></td>            
          </tr>
          <%}%>          
          <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//ģȯ����-��������%>
          <tr <%if ((ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) && !car.getEco_e_tag().equals("1")) {%>style="display: none;"<%}%>>
            <td class='title'>�������ｺƼĿ �߱�<br>(�����ͳ� �̿� �����±�)</td>
            <td colspan="5">&nbsp;<%String eco_e_tag = car.getEco_e_tag();%><%if(eco_e_tag.equals("0")){%>�̹߱�<%}else if(eco_e_tag.equals("1")){%>�߱�<%}%></td>            
          </tr>
          <%}%>
                <tr>
                    <td class='title'>�����μ���</td>
                    <td colspan="3" align=center>
                        <table width=98% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td>
                    			<%=c_db.getNameByIdCode("0035", "", pur.getUdt_st())%>
        			            �μ��� Ź�۷� : <%=AddUtil.parseDecimal(pur.getCons_amt1())%>�� (���μ��� ���� ���� �Է�)</td>
                    	    </tr>
                    	    <tr>
                                <td style='height:3'></td>
                            </tr>
                    	</table>  
                    </td>                  
                    <td class='title'>�������</td>
                    <td>&nbsp;
                    	<%=c_db.getNameByIdCode("0032", "", car.getCar_ext())%>
                    </td>
                </tr>
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
                <tr>
                    <td class='title'><span class="title1">������߰�����</span></td>
                    <td colspan="5">
                    	&nbsp;<%=car.getAdd_opt()%>&nbsp;<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>��<font color="#666666">(�ΰ������Աݾ�, ���� �ݿ���, LPGŰƮ����, �׺���̼� ��)</font>
                    	<%if(cm_bean.getS_st().equals("801")||cm_bean.getS_st().equals("802")||cm_bean.getS_st().equals("811")||cm_bean.getS_st().equals("821")){%>
                    		<%if(!cr_bean.getCar_no().equals("")){ %>
								<br>&nbsp;&nbsp;ȭ���� ���� : 
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="" <%if(car.getVan_add_opt().equals("")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;����
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="1" <%if(car.getVan_add_opt().equals("1")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;����ž/���ٵ�	        				
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="2" <%if(car.getVan_add_opt().equals("2")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;Ȱ�������
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="3" <%if(car.getVan_add_opt().equals("3")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;���߱�/ũ����
							<%}%>	
        				<%}%>	
                    </td>
                </tr>                
                <tr>
                    <td class='title'><span class="title1">�����ݿ���ǰ</span></td>
                    <td colspan="5">&nbsp;
                      <%if(car.getTint_b_yn().equals("Y")){%><input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2ä�� ���ڽ�<%}%>
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> ���� ����(�⺻��)<%}%>
                      &nbsp;
                      <%if(car.getTint_ps_yn().equals("Y")){%><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> ��޽���(��������), ����:<%=car.getTint_ps_nm()%>, ��ǰ�� ���ޱݾ�: <%=AddUtil.parseDecimal(car.getTint_ps_amt())%> �� (�ΰ�������)<%}%>
                      &nbsp;
                      <%if(car.getTint_n_yn().equals("Y")){%><input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> ��ġ�� ������̼�<%}%>
                      &nbsp;
                      <%if(car.getTint_sn_yn().equals("Y")){%><input type="checkbox" name="tint_sn_yn" value="Y" <%if(car.getTint_sn_yn().equals("Y")){%>checked<%}%>> ������� �̽ð� ����<%}%>
                      &nbsp;
                      <%if(car.getTint_bn_yn().equals("Y")){%><input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> ���ڽ� ������ ���� (<%if(car.getTint_bn_nm().equals("1")){%>��Ʈ��ķ<%}else if(car.getTint_bn_nm().equals("2")){%>������<%}else{%>��Ʈ��ķ,������..<%}%>)<%}%>
                      &nbsp;
					  <%if(car.getTint_cons_yn().equals("Y")){%><input type="checkbox" name="tint_cons_yn" value="Y" <%if(car.getTint_cons_yn().equals("Y")){%>checked<%}%>> �߰�Ź�۷��: <%=AddUtil.parseDecimal(car.getTint_cons_amt())%> ��<%}%>
                      &nbsp;
                      <%if(car.getTint_eb_yn().equals("Y")){%><input type="checkbox" name="tint_eb_yn" value="Y" <%if(car.getTint_eb_yn().equals("Y")){%>checked<%}%>> �̵��� ������(������)<%}%>
                      &nbsp;
                      <%-- <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%> --%>
	                      ��ȣ�Ǳ���
                      <!-- ������ȣ�ǽ�û -->
	                   	<select name="new_license_plate">
	                   		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>����</option>
	                   		<option value="0" <%if (!(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2"))) {%>selected<%}%>>����</option>
	                   		<%-- <option value="" <%if (car.getNew_license_plate().equals("")) {%>selected<%}%>>��û����</option>
	                   		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>��û</option> --%>
<%-- 	                   		<option value="1" <%if (car.getNew_license_plate().equals("1")) {%>selected<%}%>>������</option> --%>
<%-- 	                   		<option value="2" <%if (car.getNew_license_plate().equals("2")) {%>selected<%}%>>����/�뱸/����/�λ�</option> --%>
	                   	</select>
	                   <%-- <%}%> --%>
                    </td>
                </tr>                   
                <tr>
                    <td class='title'><span class="title1">����ǰ��</span></td>
                    <td colspan="5">&nbsp;<%=car.getExtra_set()%>&nbsp;<%=AddUtil.parseDecimal(car.getExtra_amt())%>��<font color="#666666">(�ΰ������Աݾ�, �����̹ݿ���)</font><br>
                    &nbsp;<input type="checkbox" name="serv_b_yn" value="Y" <%if(car.getServ_b_yn().equals("Y")){%>checked<%}%>> ���ڽ� (2015��8��1�Ϻ���)
                    <%if(ej_bean.getJg_g_7().equals("3")){%>
						&nbsp;<input type="checkbox" name="serv_sc_yn" value="Y" <%if(car.getServ_sc_yn().equals("Y")){%>checked<%}%>> ������������
				    <%} %>
                    </td>
                </tr>
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;<%=HtmlUtil.htmlBR(car.getRemark())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
	    <td class=h></td> 
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� </span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_car1 style="display:<%if(!base.getCar_gu().equals("0")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>��������</td>
                    <td colspan="3">&nbsp;<%String purc_gu = car.getPurc_gu();%><%if(purc_gu.equals("1")){%>����<%}else if(purc_gu.equals("0")){%>�鼼<%}%></td>
                    <td class='title'>��ó</td>
                    <td colspan="3">&nbsp;<%String car_origin = car.getCar_origin();%>
        			<%	if(car_origin.equals("")){
        					code_bean = c_db.getCodeBean("0001", cm_bean.getCar_comp_id(), "");
        					car_origin = code_bean.getApp_st();
        				}%>
        			<%if(car_origin.equals("1")){%>����<%}else if(car_origin.equals("2")){%>����<%}%></td>
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
                    <td align="center">&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title>��������</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                </tr>
                <tr>
                    <td height="12" class='title'>�ɼ�</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title>Ź�۷�</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                </tr>
                <tr>
                    <td height="26" class='title'> ����</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			��</td>
                    <td class=title><span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">����D/C</a></span></td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				��</td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				��</td>
                </tr>
              <tr id=tr_ecar_dc <%if(car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//ģȯ����%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>���Ҽ� �����</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			��</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>                         
                <tr>
                    <td align="center" class='title'>�հ�</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    ��</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                    <td align='center' class='title'>�հ�</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				��</td>
                    <td  align="center"class='title'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
        				��</td>
                </tr>
            </table>		
	    </td>
    </tr>		  
    <tr id=tr_car0 style="display:<%if(!base.getCar_gu().equals("1")){%>''<%}else{%>none<%}%>"> 
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
		if(fee_etc.getRent_l_cd().equals("")){
			sh_car_amt 	= car.getCar_fs_amt()+car.getCar_fv_amt()-car.getDc_cs_amt()-car.getDc_cv_amt();
			sh_year 	= String.valueOf(carOld.get("YEAR"));
			sh_month 	= String.valueOf(carOld.get("MONTH"));
			sh_day	 	= String.valueOf(carOld.get("DAY"));
			sh_amt		= AddUtil.parseInt(String.valueOf(janga.get("SH_AMT")));
			sh_ja		= AddUtil.parseInt(String.valueOf(janga.get("REAL_KM_JANGA")));
			sh_km		= AddUtil.parseInt(String.valueOf(janga.get("TODAY_DIST")));
			sh_tot_km	= AddUtil.parseInt(String.valueOf(janga.get("TOT_DIST")));
			sh_km_bas_dt= String.valueOf(janga.get("SERV_DT"));
			sh_day_bas_dt	= String.valueOf(janga.get("RENT_DT"));
		}else{
			sh_car_amt 	= fee_etc.getSh_car_amt();
			sh_year 	= fee_etc.getSh_year();
			sh_month 	= fee_etc.getSh_month();
			sh_day	 	= fee_etc.getSh_day();
			sh_amt		= fee_etc.getSh_amt();
			sh_ja		= fee_etc.getSh_ja();
			sh_km		= fee_etc.getSh_km();
			sh_tot_km	= fee_etc.getSh_tot_km();
			sh_km_bas_dt= fee_etc.getSh_km_bas_dt();
			sh_init_reg_dt	= fee_etc.getSh_init_reg_dt();
			sh_day_bas_dt	= fee_etc.getSh_day_bas_dt();
			if(sh_tot_km==0) sh_tot_km = a_db.getSh_tot_km(base.getCar_mng_id(), fee_etc.getSh_km_bas_dt());
		}
		if(sh_init_reg_dt.equals("")) sh_init_reg_dt = cr_bean.getInit_reg_dt();
	%>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'>�����Һ��ڰ�</td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(sh_car_amt)%>'size='10' class='white' readonly >
        				  �� <a href="javascript:view_car_amt();"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a><input type='hidden' name="view_car_amt" value=""></td>
                    <td class='title' width="10%">�ܰ���</td>
                    <td width="19%">&nbsp;
                      <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher(sh_ja,2) %>'size='4' class='white' readonly >
%</td>
                    <td class='title' width='10%'><%if(base.getCar_gu().equals("0")){%>
�߰�����
  <%}else if(base.getCar_gu().equals("2")){%>
�߰������԰�
<%}%></td>
                    <td>&nbsp;
                      <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(sh_amt) %>'size='10' class='white' readonly>
�� </td>
                </tr>
                <tr>
                    <td class='title'>����</td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='sh_year' value='<%=sh_year%>'size='1' class='white' >
                      ��
                      <input type='text' name='sh_month' value='<%=sh_month%>'size='2' class='white' >
                      ����
                      <input type='text' name='sh_day' value='<%=sh_day%>'size='2' class='white' >
                      �� ( ���ʵ����
                      <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(sh_init_reg_dt)%>' class='white' onBlur='javascript:this.value=ChangeDate(this.value);'>
~ �����
<input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%>'size='11' class='white' >
)</td>
                </tr>
                <tr>
                  <td class='title'>��������Ÿ�</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(sh_km) %>' class='white' >
km( <%if(fee_size==1){%>����� <%}else{%> �뿩������<%}%>
<input type='text' name='sh_day_bas_dt2' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%>'size='11' class='white' > 
					  ) / Ȯ������Ÿ� 
					  <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal(sh_tot_km) %>' class='white' >
					  km ( ����Ȯ����
<input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2(sh_km_bas_dt) %>' class='white' >
)</td>
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
    <tr></tr><tr></tr>
    <tr> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td width="3%" class='title'>����</td>
                    <td width="10%" class='title'>���ο���</td>
                    <td width="13%">&nbsp;<%String pay_st = car.getPay_st();%><%if(pay_st.equals("1")){%>����<%}else if(pay_st.equals("2")){%>�鼼<%}%></td>
                    <td width="13%" class='title'>Ư�Ҽ�</td>
                    <td  align="center"width="13%">&nbsp;
                      <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
        				��</td>
                    <td width="10%" class='title'>������</td>
                    <td  align="center"width="13%">&nbsp;
                      <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
        				��</td>
                    <td width="12%" class='title'>�հ�</td>
                    <td  align="center"width="13%" >&nbsp;
                      <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>
        				��</td>
                </tr>
    		    <%if(!tax.getCar_mng_id().equals("")){%>
                <tr>
                    <td class='title'>����</td>
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=tax.getPay_dt()%></td>
                    <td class='title'>Ư�Ҽ�</td>
                    <td align="center">&nbsp;
                        <input type='text' name='spe_tax2' size='10' value='<%=Util.parseDecimal(tax.getSpe_tax_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
        				  ��</td>
                    <td class='title'>������</td>
                    <td align="center">&nbsp;
                        <input type='text' name='edu_tax2' size='10' value='<%=Util.parseDecimal(tax.getEdu_tax_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); '>
        				  ��</td>
                    <td class='title'>�հ�</td>
                    <td align="center" >&nbsp;
                        <input type='text' name='tot_tax2' size='10' value='<%=Util.parseDecimal(tax.getPay_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>
        				  ��</td>
                </tr>
    		    <%}%>
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
                        <input type='text' name='ecar_pur_sub_amt' value='<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��
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
    
    <%if(base.getCar_gu().equals("1")){%>
    <tr>
	    <td class=h></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ŸŴ�����޳��� </span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>	 
	<tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                    
                    <td class='title' colspan="4">��û(����) �ؿ�������ڰ� ��û���</td>
                    <td class='title' colspan="5">����(����) ������ó����� Ȯ��</td>
                    <td class='title' rowspan="2" width="10%">����</td>
                </tr>
                <tr>
                    <td width="10%" class='title'>���� </td>
                    <td width="10%" class='title'>�ݾ� </td>
                    <td width="10%" class='title'>���⿹���� </td>
                    <td width="10%" class='title'>��û����� </td>                    
                    <td width="10%" class='title'>���� </td>
                    <td width="10%" class='title'>ī��/������</td>
                    <td width="10%" class='title'>���±��� </td>
                    <td width="10%" class='title'>ī��/���¹�ȣ </td>
                    <td width="10%" class='title'>������ </td>                    
                </tr>    
                <%	int    t_trf_amt	= 0;
                	String trf_nm 		= "";
                	String trf_st 		= "";
        		 	int    trf_amt 		= 0;
        		  	String card_kind 	= "";
        		  	String cardno 		= "";
        		  	String trf_cont 	= "";
        		  	String trf_est_dt 	= "";
					String trf_pay_dt 	= "";
					String trf_req_dt 	= "";
					String acc_st 		= "";
					String trf_yn 		= "";
					//����ǰ��
					DocSettleBean doc = d_db.getDocSettleCommi("4", rent_l_cd);
        		  	for(int j=0; j<6; j++){
        		  		trf_yn 		= "Y";
        		  		if(j==0){
        					trf_nm 		= "����";
        					trf_st 		= pur.getTrf_st0	();
        					trf_amt 	= pur.getCon_amt	();
        					card_kind 	= pur.getCon_bank	();
        					cardno 		= pur.getCon_acc_no	();
        					trf_cont 	= pur.getCon_acc_nm	();
        					trf_est_dt	= pur.getCon_est_dt ();
							trf_pay_dt	= pur.getCon_pay_dt ();
							trf_req_dt  = pur.getCon_amt_pay_req();
							acc_st 		= pur.getAcc_st0	();    
							if(trf_amt>0 && trf_st.equals("")){ trf_st = "1"; }							
        		  		}else if(j==1){
        		  			trf_nm 		= "���(�ܱ�)";
        		  			trf_st 		= pur.getTrf_st1	();
        					trf_amt 	= pur.getTrf_amt1	();
        					card_kind 	= pur.getCard_kind1	();
        					cardno 		= pur.getCardno1	();
        					trf_cont 	= pur.getTrf_cont1	();
        					trf_est_dt	= pur.getPur_est_dt ();
							trf_pay_dt	= pur.getTrf_pay_dt1();
							trf_req_dt  = doc.getUser_dt3();
							acc_st 		= pur.getAcc_st1	();
							if(trf_amt == 0){ trf_yn = "N"; }	
        				}else if(j==2){
        					trf_nm 		= "���(�ܱ�)";
        					trf_st 		= pur.getTrf_st2	();
        					trf_amt 	= pur.getTrf_amt2	();
        					card_kind 	= pur.getCard_kind2	();
        					cardno 		= pur.getCardno2	();
        					trf_cont 	= pur.getTrf_cont2	();
        					trf_est_dt	= pur.getPur_est_dt ();
							trf_pay_dt	= pur.getTrf_pay_dt2();
							trf_req_dt  = doc.getUser_dt3();
							acc_st 		= pur.getAcc_st2	();
							if(trf_amt == 0){ trf_yn = "N"; }
        				}else if(j==3){
        					trf_nm 		= "���(�ܱ�)";
        					trf_st 		= pur.getTrf_st3	();
        					trf_amt 	= pur.getTrf_amt3	();
        					card_kind 	= pur.getCard_kind3	();
        					cardno 		= pur.getCardno3	();
        					trf_cont 	= pur.getTrf_cont3	();
        					trf_est_dt	= pur.getPur_est_dt ();
							trf_pay_dt	= pur.getTrf_pay_dt2();
							trf_req_dt  = doc.getUser_dt3();
							acc_st 		= pur.getAcc_st3	();
							if(trf_amt == 0){ trf_yn = "N"; }
        				}else if(j==4){
        					trf_nm 		= "���(�ܱ�)";
        					trf_st 		= pur.getTrf_st4	();
        					trf_amt 	= pur.getTrf_amt4	();
        					card_kind 	= pur.getCard_kind4	();
        					cardno 		= pur.getCardno4	();
        					trf_cont 	= pur.getTrf_cont4	();
        					trf_est_dt	= pur.getPur_est_dt ();
							trf_pay_dt	= pur.getTrf_pay_dt4();
							trf_req_dt  = doc.getUser_dt3();
							acc_st 		= pur.getAcc_st4	();
							if(trf_amt == 0){ trf_yn = "N"; }
	        		  	}else if(j==5){
    						trf_nm 		= "�ӽÿ��ຸ���";
    						trf_st 		= pur.getTrf_st5	();
    						trf_amt 	= pur.getTrf_amt5	();
    						card_kind 	= pur.getCard_kind5	();
    						cardno 		= pur.getCardno5	();
    						trf_cont 	= pur.getTrf_cont5	();
    						trf_est_dt	= pur.getTrf_est_dt5();
							trf_pay_dt	= pur.getTrf_pay_dt5();
							trf_req_dt  = pur.getTrf_amt_pay_req();
							acc_st 		= pur.getAcc_st5	();
    					}
        		  		
        		  		t_trf_amt += trf_amt; 
        		  		
        		  		if(trf_yn.equals("Y")){
        		  		%>
                <tr>
                    <td align="center"><%=trf_nm%><%if(ck_acar_id.equals("000029")){%>(<%=j%>)<%}%></td>
                    <td align="right"><%=AddUtil.parseDecimal(trf_amt)%></td>
                    <td align="center"><%if(trf_amt > 0){%><%= AddUtil.ChangeDate2(trf_est_dt)%><%}%></td>
                    <td align="center">
                    	<%if(trf_amt > 0){%>
                    		<%= AddUtil.ChangeDate2(trf_req_dt)%>
                    	<%}%>	
                    	<%if(base.getCar_mng_id().equals("") && trf_pay_dt.equals("") && trf_req_dt.equals("") && trf_nm.equals("����")){ %>
                    	<a href="javascript:SendMsg('con_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                    	<%} %>
                    	<%if(base.getCar_mng_id().equals("") && trf_pay_dt.equals("") && trf_req_dt.equals("") && trf_nm.equals("�ӽÿ��ຸ���")){ %>
                    	<a href="javascript:SendMsg('trf_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                    	<%} %>                                       
                    </td>                    
                    <td align="center"><%if(trf_amt > 0){%><%if(trf_st.equals("1")){ out.println("����"); }else if(trf_st.equals("3")){ out.println("�ĺ�ī��"); }%><%}%></td>
                    <td align="center"><%if(trf_amt > 0){%><%=card_kind%><%}%></td>
                    <td align="center"><%if(trf_amt > 0){%><%if(acc_st.equals("1")){ out.println("��������"); }else if(acc_st.equals("2")){ out.println("�������"); }%><%}%></td>
                    <td align="center"><%if(trf_amt > 0){%><%=cardno%><%}%></td>
                    <td align="center"><%if(trf_amt > 0){%><%= AddUtil.ChangeDate2(trf_pay_dt)%><%}%></td>
                    <td align="center"><%if(trf_amt > 0){%><%=trf_cont%><%}%></td>                    
                </tr>  
                <%		}
                	} %>     
                <tr>
                    <td class='title'>�հ�</td>
                    <td align="right"><%=AddUtil.parseDecimal(t_trf_amt)%></td>
                    <td class='title' colspan='8'>&nbsp;</td>                                   
                </tr>	               		    		
            </table>
        </td>
    </tr>	
    <%}%>
                     
    <tr>
	    <td class=h></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(!base.getCar_gu().equals("2")){%>���<%}else if(base.getCar_gu().equals("2")){%>�߰�������ó<%}%> <%if(!mode.equals("view")){%><%if(user_id.equals("000000") || base.getBus_id().equals(user_id)){%>&nbsp;<a href="javascript:update('emp2','')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( ������ : �������-����� ���� )</font><%}%></span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
    		    <%if(!base.getCar_gu().equals("2")){%>
                <tr>
                    <td class='title'>�����</td>
                    <td >&nbsp;<%String one_self = pur.getOne_self();%><%if(one_self.equals("Y")){%>��ü���<%}else if(one_self.equals("N")){%>����������<%}%></td>
                    <td class='title'>Ư�������</td>
                    <td>&nbsp;<%String dir_pur_yn = pur.getDir_pur_yn();%><%if(dir_pur_yn.equals("Y")){%>Ư�����<%}%></td>
                </tr>	
                <tr>
                    <td class='title'>����û��</td>
                    <td colspan="3">&nbsp;<%= AddUtil.ChangeDate2(pur.getPur_req_dt())%>
                    &nbsp;<%String pur_req_yn = pur.getPur_req_yn();%><%if(pur_req_yn.equals("Y")){%>����û�Ѵ�<%}%>
                    </td>
                </tr>
                <!-- 
                <tr>
                	<td class='title'>����</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(pur.getCon_amt())%>��
                	<%if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getCon_amt_pay_req().equals("")){%>
                	<a href="javascript:SendMsg('con_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                	<%}%>
                	<%if(pur.getCon_amt() > 0 && !pur.getCon_amt_pay_req().equals("")){%>
                	&nbsp;�۱ݿ�û(<%=pur.getCon_amt_pay_req()%>)
                	<%}%>
                    </td>
                    <td class='title'>�ӽÿ��ຸ���<input type="hidden" id="trf_amt" name="trf_amt" value="<%=pur.getTrf_amt5()%>"></td>
                    <td colspan='3'>&nbsp;<%=pur.getTrf_amt5()%>��
                	<%if(pur.getTrf_amt5() > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_amt_pay_req().equals("")){%>
                	<%	if(pur.getCon_amt() == 0 && pur.getCon_amt_pay_req().equals("")){%>
                		<a href="javascript:SendMsg('trf_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                	<%	}%>
                	<%}%>
                	<%if(pur.getTrf_amt5() > 0 && !pur.getTrf_amt_pay_req().equals("")){%>
                	&nbsp;�۱ݿ�û(<%=pur.getTrf_amt_pay_req()%>)
                	<%}%>
                    	
                    	</td>
                </tr> 
 				-->     						  
                <tr>
                    <td class='title'>�������</td>
                    <td >&nbsp;<%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%>&nbsp;<%=emp2.getCar_off_nm()%></td>
                    <td class='title'>�����ȣ</td>
                    <td>&nbsp;<%=pur.getRpt_no()%></td>
                </tr>					
                <tr>
                    <td width="13%" class='title'>�������</td>
                    <td width="37%" >&nbsp;<%=pur.getDlv_est_dt()%>&nbsp;<%=pur.getDlv_est_h()%>��</td>
                    <td width="10%" class='title'>�������</td>
                    <td width="40%" >&nbsp;<%= AddUtil.ChangeDate2(base.getDlv_dt())%></td>
                </tr>
                <tr>
                    <td width="13%" class='title'>�����ȣ</td>
                    <td width="37%" >&nbsp;<%=cr_bean.getCar_num()%><%if(cr_bean.getCar_num().equals("")){%><%=pur.getCar_num()%><%}%></td>
                    <td width="10%" class='title'>���������ȣ</td>
                    <td width="40%" >&nbsp;<%=pur.getEst_car_no()%></td>
                </tr>
                <tr>
                    <td class='title'>�ӽÿ����ȣ</td>
                    <td >&nbsp;<%=pur.getTmp_drv_no()%></td>
                    <td class='title'>�ӽÿ���Ⱓ</td>
                    <td>&nbsp;<%=pur.getTmp_drv_st()%>~<%=pur.getTmp_drv_et()%></td>
                </tr>
    		    <%}else{%>
                <tr>
                    <td class='title'>�ŵ�������</td>
                    <td colspan="3">&nbsp;<%=emp2.getCar_off_nm()%></td>
                </tr>					
                <tr>
                    <td width="13%" class='title'>�Ÿ�����</td>
                    <td width="37%" >&nbsp;<%= AddUtil.ChangeDate2(base.getDlv_dt())%></td>
                    <td width="10%" class='title'>�Ÿűݾ�</td>
                    <td width="40%" >&nbsp;<%= AddUtil.parseDecimal(pur.getTrf_amt1())%></td>
                </tr>
                <tr>
                    <td width="13%" class='title'>�����ȣ</td>
                    <td width="37%" >&nbsp;<%=cr_bean.getCar_num()%><%if(cr_bean.getCar_num().equals("")){%><%=pur.getCar_num()%><%}%></td>
                    <td width="10%" class='title'>��������ȣ</td>
                    <td width="40%" >&nbsp;<%=pur.getRpt_no()%></td>
                </tr>		  
    		    <%}%>
                <tr>
                    <td class=title>�������</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(debt.getCpt_cd(), "BANK")%></td>
                </tr>		    
                <tr>
                    <td class=title>�������</td>
                    <td >&nbsp;<%=AddUtil.parseDecimal(debt.getLend_prn())%>&nbsp;��</td>
                    <td  class=title>��������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(debt.getLend_dt())%></td>
                </tr>		    		  
            </table>
        </td>
    </tr>	
    <tr>
	    <td class=h></td>
	</tr>		  
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� </span></td>
	</tr><!-- ���� ��������� ������Ʈ�� ������ �� �ְ� �ٲٴ� ���� ÷�ܾ�����ġ ó���� ������ �� 2018.02.13 -->
	<tr>
	    <td class=line2></td>
	</tr>	
		<%	//�����̷�-�Ϲݺ���
			if(1==1){
			Vector inss2 = ai_db.getInsHisList1(base.getCar_mng_id());
			int ins_size2 = inss2.size();
			if(ins_size2 > 0){	  %>	

    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
          <%	for(int i = 0 ; i < ins_size2 ; i++){
					Hashtable ins2 = (Hashtable)inss2.elementAt(i);
					if(i < ins_size2-1) continue;%>
                <tr>
        		    <td class=title width="13%">������</td>
                    <td width="20%">&nbsp;<b><%=ins2.get("INS_COM_NM")%></b></td>
        			<td class=title width="10%">����Ⱓ</td>
                    <td>&nbsp;<%=ins2.get("INS_START_DT")%>~<%=ins2.get("INS_EXP_DT")%><a href="javascript:OpenIns('<%=ins2.get("INS_ST")%>')"></a></td>
                </tr>
          <%	}%>
            </table>
        </td>
    </tr>
    <%}}%>
    <tr>
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="13%"  class=title>��������</td>
                    <td width="20%">&nbsp;<b><%String insurant = cont_etc.getInsurant();%><%if(insurant.equals("1") || insurant.equals("")){%>�Ƹ���ī<%}else if(insurant.equals("2")){%>��<%}%></b></td>
                    <td width="10%"  class=title>�Ǻ�����</td>
                    <td colspan='3'>&nbsp;<b><%String insur_per = cont_etc.getInsur_per();%><%if(insur_per.equals("1") || insur_per.equals("")){%>�Ƹ���ī<%}else if(insur_per.equals("2")){%>��<%}%></b></td>
                </tr>
                <tr> 
                    <td width="13%" class=title>�����ڹ���</td>
                    <td width="20%" class=''>&nbsp;<%String driving_ext = base.getDriving_ext();%><%if(driving_ext.equals("1") || driving_ext.equals("")){%>�����<%}else if(driving_ext.equals("2")){%>��������<%}else if(driving_ext.equals("3")){%>��Ÿ<%}%></td>
                    <td width="10%" class=title >�����ڿ���</td>
                    <td>&nbsp;<b><%String driving_age = base.getDriving_age();%>
                    <%if(driving_age.equals("0")){%>��26���̻�<%}
                    else if(driving_age.equals("3")){%>��24���̻�<%}
                    else if(driving_age.equals("1")){%>��21���̻�<%}
                    else if(driving_age.equals("5")){%>��30���̻�<%}
                    else if(driving_age.equals("6")){%>��35���̻�<%}
                    else if(driving_age.equals("7")){%>��43���̻�<%}
                    else if(driving_age.equals("8")){%>��48���̻�<%}
                    else if(driving_age.equals("9")){%>��22���̻�<%}
                    else if(driving_age.equals("10")){%>��28���̻�<%}
                    else if(driving_age.equals("11")){%>��35���̻�~��49������<%}
                    else if(driving_age.equals("2")){%>��������<%}%>
                    </b>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a></td>
                    <td width="10%" class=title >��������������Ư��</td>
                    <td>&nbsp;<%String com_emp_yn = cont_etc.getCom_emp_yn();%><%if(com_emp_yn.equals("Y")){%>����<%}else if(com_emp_yn.equals("N")){%>�̰���<%}%>
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
                    <td width="13%" class=title>���ι��</td>
                    <td width="20%">&nbsp;����(���ι��,��)</td>
                    <td width="10%" class=title>�빰���</td>
                    <td width="20%" class=''>&nbsp;<%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5õ����<%}else if(gcp_kd.equals("2")){%>1���<%}else if(gcp_kd.equals("3")){%>5���<%}else if(gcp_kd.equals("4")){%>2���<%}else if(gcp_kd.equals("8")){%>3���<%}%></td>
                    <td width="10%" class=title >�ڱ��ü���</td>
                    <td class=''>&nbsp;<%String bacdt_kd = base.getBacdt_kd();%><%if(bacdt_kd.equals("1")){%>5õ����<%}else if(bacdt_kd.equals("2")){%>1���<%}%></td>
                </tr>
                <tr>
                    <td  class=title>������������</td>
                    <td>&nbsp;<%String canoisr_yn = cont_etc.getCanoisr_yn();%><%if(canoisr_yn.equals("Y")){%>����<%}else if(canoisr_yn.equals("N")){%>�̰���<%}%></td>
                    <td class=title>�ڱ���������</td>
                    <td class=''>&nbsp;<%String cacdt_yn = cont_etc.getCacdt_yn();%><%if(cacdt_yn.equals("Y")){%><b>����</b><%}else if(cacdt_yn.equals("N")){%>�̰���<%}%></td>
                    <td class=title >����⵿</td>
                    <td class=''>&nbsp;<%String eme_yn = cont_etc.getEme_yn();%><%if(eme_yn.equals("Y")){%>����<%}else if(eme_yn.equals("N")){%>�̰���<%}%></td>
                </tr>
                <tr>
                    <td  class=title>������å��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(base.getCar_ja())%>��</td>
                    <td class=title>�������</td>
                    <td class=''>&nbsp;<%=cont_etc.getJa_reason()%></td>
                    <td class=title >������</td>
                    <td class=''>&nbsp;<%=c_db.getNameById(cont_etc.getRea_appr_id(),"USER")%>(�⺻ <%=AddUtil.parseDecimal(car.getImm_amt())%>��) </td>
                </tr>
                <tr>
                    <td  class=title>�ڵ���</td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="air_ds_yn" 	value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%>checked<%}%> disabled>
        				�����������
                      <input type="checkbox" name="air_as_yn" 	value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%>checked<%}%> disabled>
        				�����������
                      <input type="checkbox" name="blackbox_yn" 	value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%>checked<%}%> disabled>
        				���ڽ�
                      <input type="checkbox" name="lkas_yn" 		value="Y" <%if(cont_etc.getLkas_yn().equals("Y")){%>checked<%}%> disabled>
					      ����(����)   				
					  <input type="checkbox" name="ldws_yn"	 		value="Y" <%if(cont_etc.getLdws_yn().equals("Y")){%>checked<%}%> disabled>
						 ����(���)   				
					  <input type="checkbox" name="aeb_yn" 			value="Y" <%if(cont_etc.getAeb_yn().equals("Y")){%>checked<%}%> disabled>
						 ���(����)   				
					  <input type="checkbox" name="fcw_yn" 			value="Y" <%if(cont_etc.getFcw_yn().equals("Y")){%>checked<%}%> disabled>
						 ���(���)   				
				      <input type="checkbox" name="ev_yn" 			value="Y" <%if(cont_etc.getEv_yn().equals("Y")){%>checked<%}%> disabled>
						 ������
					  <input type="checkbox" name="hook_yn" 			value="Y" <%if(cont_etc.getHook_yn().equals("Y")){%>checked<%}%> disabled>
						 ���ΰ�(Ʈ���Ϸ���)
						<input type="checkbox" name="legal_yn" 			value="Y" <%if(cont_etc.getLegal_yn().equals("Y")){%>checked<%}%> disabled>
						 �������������(�����)
						 &nbsp; 	
						 <input type="checkbox" name="top_cng_yn"		value="Y" <%if(cont_etc.getTop_cng_yn().equals("Y")){%>checked<%}%> disabled>
						 ž��(��������)
        				<br/>
        				&nbsp;  
        				��Ÿ��ġ : <%=cont_etc.getOthers_device()%>     
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
                                    <input type='text' name='ip_insur' value='<%=cont_etc.getIp_insur()%>' size='12' class='whitetext'>
                      				&nbsp;�븮�� : 
                      				<input type='text' name='ip_agent' value='<%=cont_etc.getIp_agent()%>' size='15' class='whitetext'>
                      				&nbsp;����� :
                      				<input type='text' name='ip_dam' value='<%=cont_etc.getIp_dam()%>' size='10' class='whitetext'>
                					&nbsp;����ó :
                					<input type='text' name='ip_tel' value='<%=cont_etc.getIp_tel()%>' size='13' class='whitetext'>
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
                                <td width="100%">&nbsp;��������������� :
                                    <input type='text' name='cacdt_mebase_amt' value='<%=cont_etc.getCacdt_mebase_amt()%>' size='5' class='whitenum'>����
                      				&nbsp;&nbsp;&nbsp;�ּ��ڱ�δ�� : 
                      				<input type='text' name='cacdt_memin_amt' value='<%=cont_etc.getCacdt_memin_amt()%>' size='5' class='whitenum'>����
                      				&nbsp;&nbsp;&nbsp;�ִ��ڱ�δ�� :
                      				<input type='text' name='cacdt_me_amt' value='<%=cont_etc.getCacdt_me_amt()%>' size='5' class='whitenum'>����
                			    </td>
                            </tr>
                        </table>
                    </td>
                </tr>				
                <tr>
                    <td class='title'>���</td>
                    <td colspan="5">&nbsp;<%=HtmlUtil.htmlBR(base.getOthers())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>	
	<%if(base.getCar_st().equals("2")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������-����� <%if(!mode.equals("view")){%><%if(base.getBus_id().equals(user_id)){%><a href="javascript:update('emp2','')"><img src="/images/u.gif" width="16" height="16" aligh="absmiddle" border="0"></a><%}%><font color="#CCCCCC"> ( ������ : �������-����� ���� )</font><%}%></span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>	
    <tr id=tr_emp_dlv style="display:<%if(base.getCar_gu().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="3%" rowspan="2" class='title'>��<br>
                      ��</td>
                    <td width="10%" class='title'>�������</td>
                    <td width="20%">&nbsp;<%=emp2.getEmp_nm()%>			
        			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>			  
                      </td>
                    <td width="10%" class='title'>�����Ҹ�</td>
                    <td width="20%">&nbsp;<%=emp2.getCar_off_nm()%></td>
                    <td width="10%" class='title'>����</td>
                    <td>&nbsp;<%=emp2.getCar_off_st()%></td>
                </tr>
                <tr>
                    <td class='title'>�����ȣ</td>
                    <td >&nbsp;<%=pur.getRpt_no()%></td>
                    <td class='title'>�������</td>
                    <td>&nbsp;<%=pur.getDlv_est_dt()%>&nbsp;<%=pur.getDlv_est_h()%>��</td>
                    <td class='title'>�������</td>
                    <td>&nbsp;<%= AddUtil.ChangeDate2(base.getDlv_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>		
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	sum_car_c_amt();
	sum_car_f_amt();
//-->
</script>
</body>
</html>
