<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="pt_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 		= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");


	String cons_no 		= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	if(from_page.equals("/fms2/cons_pur/consp_doc_frame.jsp")){
		cons_no 		= request.getParameter("d_cons_no")==null?"":request.getParameter("d_cons_no");	
	}

	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	
	

	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//�������
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
	
	//�������
	co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	
	//��������
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//������ȣ �̷�	
	CarHisBean ch_r [] = crd.getCarHisAll(base.getCar_mng_id());

	//Ź���Ƿ�
	ConsignmentBean cons = cs_db.getConsignmentPur(cons_no);
		
	//������
	Vector vt = cs_db.getConsignmentPurCngs(cons_no);
	int vt_size = vt.size();
	
	String cns_st = "";	
	String cns_dt = "";	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		if(i+1 == vt_size){
			cns_st = String.valueOf(ht.get("CNG_ST_NM"));		
			cns_dt = String.valueOf(ht.get("REG_DT"));		
		}	
	}	
	
	user_bean 	= umd.getUsersBean(base.getBus_id());
	
	if(!cons.getDlv_dt().equals("") && cns_st.equals("������")){
		cns_st = "";
		cns_dt = "";
	}	
	

	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
				   	"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&cons_no="+cons_no+"";				   	

	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//����Ʈ
	function list(){
		var fm = document.form1;
		if(fm.from_page.value == ''){			
			fm.action = 'consp_mng_frame.jsp';
		}else{
			fm.action = fm.from_page.value;
		}
		fm.target = 'd_content';
		fm.submit();
	}	

	//����
	function update(st){
	
		var height = 250;
		
		if(st == 'cng') 			height = 300;
		else if(st == 'udt')			height = 200;
		else if(st == 'cancel' || st == 'init')			height = 200;
		else if(st == 'dlv')			height = 200;
		else if(st == 'driver')			height = 300;
							
		window.open("cons_pur_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes, status=yes");		
	}	
	
	function cons_man_sms(){
		var fm = document.form1;
		
		if(fm.destname.value == '')		{	alert('�����ڸ� �Է��Ͽ� �ֽʽÿ�.'); 			fm.destname.focus(); 		return;		}
		if(fm.destphone.value == '')		{	alert('���Ź�ȣ�� �Է��Ͽ� �ֽʽÿ�.'); 		fm.destphone.focus(); 		return;		}
		if(fm.msg.value == '')			{	alert('���ڳ����� �Է��Ͽ� �ֽʽÿ�.'); 		fm.msg.focus(); 		return;		}
		
		if(confirm('��� �Ͻðڽ��ϱ�?')){	
			fm.cng_item.value = 'driver_sms';
			fm.action='cons_pur_u_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}		
	}
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="cons_no" 		value="<%=cons_no%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="car_nm" 		value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">  
  <input type='hidden' name="cng_item" 		value="">  
  <input type='hidden' name="seq" 		value="">  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���Ź�۰��� > <span class=style5>���Ź�ۺ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(!mode.equals("view")){%>
    <tr>
        <td align="right"><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
    <tr> 	
    <%}%>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="2" class=title>����ȣ</td>
                    <td width=7% class=title>�Ƹ���ī</td>
                    <td width=19%>&nbsp;<%=rent_l_cd%></td>
                    <td width=7% rowspan="2" class=title>�������</td>
                    <td width=7% class=title>��������</td>
                    <td width="19%" >&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%></td>
                    <td width=7% rowspan="2" class=title>�����û</td>
                    <td width=7% class=title>���汸��</td>
                    <td width="20%">&nbsp;
                        <%	if(cons.getCancel_dt().equals("")){
                        		out.println(cns_st);
                        	}else{
                        		out.println("Ź�����");
                        	}
                        %>
                    </td>
    		    </tr>
                <tr>
                  <td class=title><%=cm_bean.getCar_comp_nm()%></td>
                  <td>&nbsp;<%=pur.getRpt_no()%></td>
                  <td class=title>�������</td>
                  <td >&nbsp;<%=AddUtil.ChangeDate2(cons.getDlv_dt())%>
  	            <%if(cons.getReq_code().equals("") && cons.getPay_dt().equals("") && !cons.getDlv_dt().equals("")){%>	 
  	            <%if(nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>	 
	        	&nbsp;<a href="javascript:update('dlv_dt')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='����'><img src=/acar/images/center/button_in_modify_b.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
	            <%}%>                                    
	            <%}%>                                    
                  </td>
                  <td width=5% class=title>����Ͻ�</td>
                  <td>&nbsp;
                      <%	if(cons.getCancel_dt().equals("")){
                        		out.println(cns_dt);
                        	}else{
                        		out.println(cons.getCancel_dt());
                        	}
                      %>                        
                  </td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>�������</td>
                    <td colspan="5">&nbsp;<%=pur.getDlv_brch()%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>����</td>
                    <td colspan="5">&nbsp;<%=cm_bean.getCar_nm()%>&nbsp;<%=cm_bean.getCar_name()%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>���û��</td>
                    <td colspan="5" >&nbsp;<%=car.getOpt()%><input type='hidden' name="opt" value="<%=car.getOpt()%>"></td>
                </tr>
                <tr>
                  <td width=14% class=title>����</td>
                  <td width="19%" >&nbsp;����:<%=car.getColo()%>/����:<%=car.getIn_col()%>/���Ͻ�:<%=car.getGarnish_col()%></td>
                  <td width=14% class=title>T/M</td>
                  <td width="19%">&nbsp;<input type='text' name='auto' size='4' value='<%if(cm_bean.getAuto_yn().equals("Y")){%>A/T<%}else{%>M/T<%}%>' class='whitetext' ></td>
                  <td width=14% class=title>��������</td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())%></td>
                </tr>	
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>

    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=7% rowspan="3" class=title>����</td>
                    <td width=7% class=title>Ź�۾�ü</td>
                    <td width=19%>&nbsp;<%=pur.getOff_nm()%></td>
                    <td width=7% rowspan="3" class=title>�����</td>
                    <td width=7% class=title>����</td>
                    <td width="19%" >&nbsp;<%if(pur.getUdt_st().equals("1")){%>���ﺻ��<%}else if(pur.getUdt_st().equals("2")){%>�λ�����<%}else if(pur.getUdt_st().equals("3")){%>��������<%}else if(pur.getUdt_st().equals("4")){%>��<%}else if(pur.getUdt_st().equals("5")){%>�뱸����<%}else if(pur.getUdt_st().equals("6")){%>��������<%}%></td>
                    <td width="7%" rowspan="2" class=title>�����</td>
                    <td width="7%" class=title>�μ�/����</td>
                    <td width="20%">&nbsp;<%=cons.getUdt_mng_nm()%></td>
    		    </tr>
                <tr>
                  <td class=title>���繫��</td>
                  <td>&nbsp;<%=pur.getDlv_ext()%></td>
                  <td class=title>����/��ȣ</td>
                  <td >&nbsp;<%=cons.getUdt_firm()%></td>
                  <td class=title>����ó</td>
                  <td>&nbsp;<%=cons.getUdt_mng_tel()%></td>
                </tr>
                <tr>
                  <td class=title>Ź�۷�</td>
                  <td>&nbsp;<%=AddUtil.parseDecimal(pur.getCons_amt1())%>��</td>
                  <td class=title>�ּ�</td>
                  <td colspan="4" >&nbsp;<%=cons.getUdt_addr()%></td>
                </tr>	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���������</td>
                    <td>&nbsp;<%=user_bean.getUser_nm()%>&nbsp;<%=user_bean.getUser_m_tel()%></td>
                </tr>
            </table>
        </td>
    </tr>        
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>������������</td>
                    <td>&nbsp;<%=cons.getEtc()%></td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>���븮��</td>
                    <td>&nbsp;<%=cons.getDriver_nm()%> <%=cons.getDriver_m_tel()%>                    	
                    </td>
                </tr>
            </table>
        </td>
    </tr>                      
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>Ź�۱��</td>
                    <td width=19%>&nbsp;<%=cons.getDriver_nm2()%> <%=cons.getDriver_m_tel2()%>                    	
                    </td>
                    <td width=14% class=title>����� ���������Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(cons.getTo_est_dt())%>   
                      <%if(!cons.getTo_est_dt().equals("") && cons.getCancel_dt().equals("") && cons.getUdt_dt().equals("") && cons.getDlv_dt().equals("")){%>	
                      <!--
                      &nbsp;&nbsp;&nbsp;&nbsp;
                      <a href="javascript:update('to_est_dt')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='����'>[����]</a>                      
                      -->
                      <%}%>                              	
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>�μ�����</td>
                    <td width=19%>&nbsp;
                        <%if(cons.getUdt_yn().equals("Y")){%>�μ�<%}%><%if(cons.getUdt_yn().equals("N")){%>�ź�<%}%></td>
                    <td>
                    <td width=14% class=title>�μ�����</td>
                    <td width=19%>&nbsp;
                    &nbsp;<%=AddUtil.ChangeDate2(cons.getUdt_dt())%> 
                    <%if(cons.getReq_code().equals("") && cons.getPay_dt().equals("") && !cons.getUdt_dt().equals("")){%>	 
  	            <%if(nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>	 
	        	&nbsp;<a href="javascript:update('udt_dt')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='����'><img src=/acar/images/center/button_in_modify_b.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
	            <%}%>                                    
	            <%}%>   
                    </td>
                    <td width=14% class=title>�����</td>
                    <td>&nbsp;
                    &nbsp;<%=c_db.getNameById(cons.getUdt_id(),"USER")%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>   
    <%if(!cons.getReturn_dt().equals("")){%>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=14% class=title>��ǰŹ����</td>
                    <td width=19%>&nbsp;<%=AddUtil.ChangeDate2(cons.getReturn_dt())%></td>
                    <td width=14% class=title>��ǰŹ�۷�</td>
                    <td width=19%>&nbsp;<%=AddUtil.parseDecimal(cons.getReturn_amt())%>��</td>                    
                    <td width=14% class=title>��ǰ�����</td>
                    <td>&nbsp;<%=c_db.getNameById(cons.getReturn_id(),"USER")%></td>
                </tr>
                <tr> 
                    <td width=14% class=title>��ǰ�����ȣ</td>
                    <td colspan='5'>&nbsp;<%=cons.getRt_com_con_no()%></td>
                </tr>
            </table>
        </td>
    </tr>   
    <%} %>	 
    <tr>
        <td>&nbsp;</td>
    </tr>      
    <%if(!mode.equals("view")){%>
    <%if(cons.getCancel_dt().equals("") && cons.getReturn_dt().equals("")){%>	 
    <tr>
	<td align='center'>	 
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	        		<%if(!nm_db.getWorkAuthUser("�Ƹ���ī�̿�",ck_acar_id)){%>
	        		    	<%if(cons.getUdt_dt().equals("")){%>
	        		    	        <%if(base.getBus_id().equals(ck_acar_id) || nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>	 
	        				<a href="javascript:update('cng')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='����'><img src=/acar/images/center/button_modify_b.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
	        				<%}%>
	        			
	        				<%if(!cons.getDriver_nm().equals("") && !cons.getDlv_dt().equals("")){%>	
	        				<a href="javascript:update('udt')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='�μ�'><img src=/acar/images/center/button_insu.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%}%>
	        			
	        				<%if(base.getBus_id().equals(ck_acar_id) || nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
	        				<a href="javascript:update('cancel')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='���'><img src=/acar/images/center/button_cancel.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%}%>

	        				<%if(nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
	        				<input type="button" class="button" value="��ǰŹ��" onclick="update('return_car')">&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%}%>
	        					        				
	        				<%if(cons.getSettle_dt().equals("")){%>
	        				<%if(nm_db.getWorkAuthUser("��������",ck_acar_id) || nm_db.getWorkAuthUser("�������������",ck_acar_id) || nm_db.getWorkAuthUser("���������",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
	        				&nbsp;&nbsp;
	        				<a href="javascript:update('settle')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='Ȯ��'><img src=/acar/images/center/button_hjung.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%}%>
	        				<%}%>
	        				
	        				<%if(pur.getOff_id().equals("010265") || pur.getOff_id().equals("010266") || pur.getOff_id().equals("010630")){%>
	        				<a href="javascript:update('udt')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='�μ�'><img src=/acar/images/center/button_insu.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        				<%}%>
	        				
	        		    	<%}%>	
	                	<%}else{%>	        		
	                		<%if(cons.getDlv_dt().equals("")){%>	                			                		
	                		<%	if(nm_db.getWorkAuthUser("�ܺ�_Ź�۾�ü",ck_acar_id) || nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
	                		<%		if(!cons.getDriver_nm().equals("")){%>	
	        			<a href="javascript:update('dlv')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='���'><img src=/acar/images/center/button_cgo.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
	        			<%		}%>
	        			<%	}%>
	        			<%}else{%>
	        			<%	if(cons.getUdt_dt().equals("")){%>	
	        			<%		if(nm_db.getWorkAuthUser("�ܺ�_Ź�۾�ü",ck_acar_id)){%>
	        			<a href="javascript:update('cng')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='����'><img src=/acar/images/center/button_modify_b.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
	        			<%		}%>
	        			<%	}%>
	        			<%}%>
        			<%}%>	
        			
        			<%if(cons.getDlv_dt().equals("")){%>
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        			                	
        			<a href="javascript:update('driver')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='���븮��'><img src=/acar/images/center/button_agent_cg.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
        			
        			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        			                	
        			<a href="javascript:update('to_est_dt')" 	onMouseOver="window.status=''; return true" onfocus="this.blur()" title='Ź�۱�� �� �������������'><img src=/acar/images/center/button_tsgs.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;	
        			
        			<%}%>
        			
	        				<%if(base.getBus_id().equals(ck_acar_id) || nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
	        				<%if(!cons.getDriver_nm().equals("") && cons.getDlv_dt().equals("")){%>	
	        				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        			                	
	        				<input type="button" class="button" value="�Ƿڷ�" onclick="update('init')">
	        				<%}%>
	        				<%}%>
        			
	    <%}%>    	
	</td>
    </tr>	    
    <%}%>
    <%}%>          

    

    <%if(mode.equals("view")){%>
    <tr>
	<td align="right"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    <tr>    
    <%}%>   
    
    
    <%if(cons.getCancel_dt().equals("") && cons.getReturn_dt().equals("") && cons.getUdt_dt().equals("") && !cons.getDriver_nm().equals("") && !coe_bean.getCar_off_nm().equals("B2B������") && !coe_bean.getCar_off_nm().equals("Ư����") && !coe_bean.getCar_off_nm().equals("����������") && !coe_bean.getCar_off_nm().equals("�����Ǹ���")){%>
    
    <%		//���¾�ü�� ��ϵ� �����Ҵ� �繫�� ���������� ������    
    		//if(pur.getOne_self().equals("Y")){
    			//��󿬶���-���¾�ü
    			Hashtable pt_ht = pt_db.getPartnerAgnt(coe_bean.getEmp_nm(), coe_bean.getEmp_m_tel());
    			if(!String.valueOf(pt_ht.get("PO_AGNT_NM")).equals("") && !String.valueOf(pt_ht.get("PO_AGNT_NM")).equals("null")){
    				coe_bean.setEmp_nm	(String.valueOf(pt_ht.get("PO_AGNT_NM")));
    				coe_bean.setEmp_pos	("");
    				coe_bean.setEmp_m_tel	(String.valueOf(pt_ht.get("PO_AGNT_M_TEL")));
    			}    		    		
    		//}
    %>
    <tr> 
        <td><hr></td>
    </tr>  
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���븮�� SMS �߼�</span></td>
    </tr>  	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>����</td>
                    <td>&nbsp;<textarea rows='2' cols='90' name='msg'>[<%=pur.getDlv_ext()%>]�Ƹ���ī ���븮��:<%=pur.getOff_nm()%> <%=cons.getDriver_nm()%> <%=cons.getDriver_ssn()%> <%=cons.getDriver_m_tel()%></textarea></td>
                </tr>
                <tr> 
                    <td class='title' width='10%'>������</td>
                    <td>&nbsp;<%=coe_bean.getCar_off_nm()%> <input type='text' name='destname' maxlength='15' value='<%=coe_bean.getEmp_nm()%> <%=coe_bean.getEmp_pos()%>' class='default' size='15'>
                        <input type='text' name='destphone' maxlength='15' value='<%=coe_bean.getEmp_m_tel()%>' class='default' size='15'>
                        &nbsp;&nbsp;&nbsp;
                        <%if(!coe_bean.getCar_off_nm().equals("B2B������") && !coe_bean.getCar_off_nm().equals("Ư����") && !coe_bean.getCar_off_nm().equals("����������") && !coe_bean.getCar_off_nm().equals("�����Ǹ���")){%>
                        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
                        <a href="javascript:cons_man_sms();" title='���ں�����'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>        
                        <%}%>
                        <%}%>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>	    
    <%}%>
    

    
</table>
</form>
<script language="JavaScript">
<!--	
	
	var fm = document.form1;
	
	if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('���ӱ�') != -1){
		fm.auto.value = 'A/T';
	}
	
		
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

