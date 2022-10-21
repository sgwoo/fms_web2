<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, acar.fee.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "12");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
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
	
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//������ ��ȸ
	function car_search()
	{
		var fm = document.form1;
		window.open("search_ext_car.jsp", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");
	}	

	//�� ����
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//�뿩���
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=650, scrollbars=yes");
	}		
	
	//����� �������ڷ� �ٽ� ���
	function set_day(){
		var fm = document.form1;	
		if(fm.cls_dt.value == ''){ 	alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_dt.focus(); 	return;	}
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}					
		fm.action='/acar/cls_con/cls_settle_nodisplay.jsp';		
		fm.target='i_no';
		fm.submit();
	}
	
	function save(){
		var fm = document.form1;
		if(fm.cls_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.');				return;}
		if(fm.car_mng_id.value == '')		{ alert('������ �����Ͻʽÿ�.'); 				return;}
		if(fm.car_deli_dt.value == '')		{ alert('�����ε��ϸ� �Է��Ͻʽÿ�.');				return;}				
		<%if(ht_size > 0){%>
		if(fm.fee_tm.value == '')		{ alert('������ �̰�ȸ���� �����Ͻʽÿ�.'); 			return;}
		fm.cng_fee_tm.value = fm.fee_tm.options[fm.fee_tm.selectedIndex].text;
		<%}%>
								
		if(confirm('����Ͻðڽ��ϱ�?')){		
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			fm.action='lc_cng_car_c_a.jsp';
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
			
			link.getAttribute('href',originFunc);
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
<body>
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 				value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 				value="<%=rent_l_cd%>">  
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">    
  <input type='hidden' name="from_page" 		value="/fms2/lc_rent/lc_cng_car_frame.jsp">
  <input type='hidden' name='con_cd3' value=''>
  <input type='hidden' name='con_cd4' value=''>  
  <input type='hidden' name="cng_fee_tm"        value="">  
  <input type='hidden' name="in_col"        value="">  
  <input type='hidden' name="garnish_col"        value="">  
  <input type='hidden' name="car_use"        value="">
  <input type='hidden' name="lkas_yn"	value=""><!-- ÷�ܾ�����ġ 2018.03.27 -->
  <input type='hidden' name="ldws_yn"	value="">
  <input type='hidden' name="aeb_yn"		value="">
  <input type='hidden' name="fcw_yn"		value="">
  <input type='hidden' name="ev_yn"		value=""><!-- ������ ���� -->
  <input type='hidden' name="hook_yn"		value=""><!-- ���ΰ� ���� -->
  <input type='hidden' name="others_device"		value="">
  <input type='hidden' name="top_cng_yn"		value=""><!-- ž��(��������) -->
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
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
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>�ű�<%}else if(rent_st.equals("3")){%>����<%}else if(rent_st.equals("4")){%>����<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ�<%}else if(bus_st.equals("2")){%>�������<%}else if(bus_st.equals("3")){%>��ü�Ұ�<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>��ȭ���<%}else if(bus_st.equals("6")){%>������ü<%}else if(bus_st.equals("7")){%>������Ʈ<%}else if(bus_st.equals("8")){%>�����<%}%></td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
                    <td class=title>�뵵����</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
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
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="2">����</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">�������</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">�̿�Ⱓ</td>
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
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>�°�</td>
                    <td style="font-size : 8pt;" width="10%" class=title>�ݾ�</td>
                    <td style="font-size : 8pt;" width="3%" class=title>%</td>			
                </tr>
    		  <%for(int i=0; i<fee_size; i++){
    				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>����</td>
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
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1;'></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>��������</td>
                    <td width="20%">&nbsp;
        			  <input type='hidden' name="cls_st" value="4">
        			  ��������</td>
                    <td width='10%' class='title'>������</td>
                    <td width="20%">&nbsp;
        			  <input type='text' name='cls_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'> 
                    </td>
                    <td class='title' width="10%">�̿�Ⱓ</td>
                    <td>&nbsp;
        			  <input type='text' name='r_mon' value='' class='text' size="2">
                      ���� 
                      <input type='text' name='r_day' value='' class='text' size="2">
                      �� </td>
                </tr>
                <tr> 
                    <td class='title'>�������� </td>
                    <td colspan="5">&nbsp;
        			  <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan="2" class='title'>�׸�</td>
                    <td width="70%" class='title'>����</td>
                    <td width="17%" class='title'>�ݾ�</td>
                </tr>
                <tr> 
                    <td colspan="2" class='title'>������ȣ</td>
                    <td>&nbsp;
        			  <input type='text'   name='car_no' class='fix' size='15' readonly>
        			  <input type='hidden' name='car_mng_id' value=''>
        			  <input type='hidden' name='old_rent_mng_id' value=''>
        			  <input type='hidden' name='old_rent_l_cd' value=''>			  
                      <a href="javascript:car_search();"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td width="3%" rowspan="7" class='title'>��<br>
                    ��<br>��</td>
                    <td width="10%" class='title'>��ó</td>
                    <td><table width="100%" border="0" cellpadding="0">
                        <tr>
                          <td id=td_01 style='display:none'>&nbsp;
                            <select name="car_origin" onChange="javascript:GetCarCompe()" class='default'>
                              <option value="">����</option>
                              <option value="1" selected>����</option>
                              <option value="2">����</option>
                            </select></td>
                          <td id=td_02 style="display:''">&nbsp;
        				  <input type='text' name="car_origin_nm" size='60' class='fix' readonly></td>
                        </tr>
                      </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>����ȸ��</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_11 style='display:none'>&nbsp;
                          		<input type='hidden' name='car_comp_id' value=''>
            				    </td>
                                <td id=td_12 style="display:''">&nbsp;
                                  <input type='text' name="car_comp_nm" size='60' class='fix' readonly></td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_21 style='display:none'>&nbsp;                    
            					<select name="code" onChange="javascript:GetCarCd()">
                            	  <option value="">����</option>
                          		</select>
            					&nbsp; </td>
                                <td id=td_22 style="display:''">&nbsp;
            				    <input type='text' name="car_nm" size='60' class='fix' readonly></td>
                            </tr>
                        </table> 
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_31 style='display:none'>&nbsp;                    
            					    <input type="button" name="b1" value="����" onclick="javascript:sub_list('1');">
            				    </td>
                                <td id=td_32 style="display:''">&nbsp;
                				  	<input type='text' name="car_name" size='60' class='fix' readonly>
                			  		<input type='hidden' name='car_id' value=''>
                			  		<input type='hidden' name='car_seq' value=''>
                					<input type='hidden' name='car_s_amt' value=''>
                					<input type='hidden' name='car_v_amt' value=''></td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='car_amt' size='10' value='' maxlength='15' class='fixnum' readonly>
        			  ��</td>
                </tr>
                <tr> 
                    <td class='title'>�ɼ�</td>
                    <td>
        			    <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_41 style='display:none'>&nbsp;
            				        <input type="button" name="b1" value="����" onclick="javascript:sub_list('2');">					
                                </td>
                                <td id=td_42 style="display:''">&nbsp;
            				    <input type='text' name="opt" size='60' class='fix' readonly>
            				    <input type='hidden' name='opt_seq' value=''>
            				    <input type='hidden' name='opt_s_amt' value=''>
            				    <input type='hidden' name='opt_v_amt' value=''></td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='opt_amt' size='10' value='' maxlength='13' class='fixnum' readonly>
        			  ��</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td id=td_51 style='display:none'>&nbsp;
            				        <input type="button" name="b1" value="����" onclick="javascript:sub_list('3');">
                                </td>
                                <td id=td_52 style="display:''">&nbsp;
            				    <input type='text' name="col" size='60' class='fix'>
            				    <input type='hidden' name='col_seq' value=''>
            				    <input type='hidden' name='col_s_amt' value=''>
            				    <input type='hidden' name='col_v_amt' value=''></td>
                            </tr>
                        </table>
                    </td>
                    <td align="center"><input type='text' name='col_amt' size='10' value='' maxlength='13' class='fixnum' onBlur="javascript:setColAmt()">
        			  ��</td>
                </tr>
                <tr>
                    <td colspan="2" class='title'>��������</td>
                    <td align="center"><input type='text' name='o_1' size='10' value='' maxlength='13' class='fixnum' readonly>					
    				��<input type='hidden' name='o_1_s_amt' value=''><input type='hidden' name='o_1_v_amt' value=''></td>
                </tr>
            </table>
	    </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�� ������ �̰�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td width='13%' class='title'>�̰�ȸ��</td>
                <td>&nbsp;
    			  <%	if(ht_size > 0){%>
    						<select name='fee_tm'>
    						   <option value="">����</option>
    					<%		for(int i = 0 ; i < ht_size ; i++){
    								FeeScdBean bean = (FeeScdBean)ht.elementAt(i);
    								if(i==0){
    									fee_scd = bean;
    								}%>
    							<option value='<%=bean.getFee_tm()%>'>[<%=AddUtil.addZero(bean.getFee_tm())%>ȸ��] <%=AddUtil.ChangeDate2(bean.getFee_est_dt())%> <%if(bean.getRc_yn().equals("0")){%>���Ա�<%}else{%>�Ա�<%}%></option>
    					<%		}%>
    						</select> ȸ
            		      &nbsp;(����ȸ������ ��� ȸ�� �̰�)
    					<%	}else{%>
    						���ð����� ȸ���� �����ϴ�.
    					<%	}%>	
                </td>
              </tr>
    		</table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td width='13%' class='title'>�����ε���</td>
                <td>&nbsp;
    			  <input type='text' name='car_deli_dt' maxlength='10' size='11' value='' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
					&nbsp;&nbsp;<font color='#CCCCCC'>(���� ������ �ε��Ǵ� ��¥�� �Է��Ͻʽÿ�.)</font>
                </td>
              </tr>
    		</table>
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1' >
                  		����
                  		<input type='radio' name="gi_st" value='0' >
                  		���� </td>
                </tr>                
                <tr>
                    <td class=title>��������</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value=''>
        			   <input type='text' name='gi_jijum' value='' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>���Աݾ�</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                    <td class=title >���������</td>
                    <td>&nbsp;
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		��</td>
                </tr>	
            </table>
        </td>
    </tr>      		    	
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
		<td align="right"><a id="submitLink" href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
//-->
</script>
</body>
</html>
