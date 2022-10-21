<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.call.*,acar.cont.*, acar.client.*, acar.accid.*, acar.car_mst.*, acar.car_service.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="s_bean2" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�˻�����
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd	 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cont_st 	= request.getParameter("cont_st")==null?"0":request.getParameter("cont_st");
	String b_lst 	= request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_id 	= request.getParameter("s_id")==null?"":request.getParameter("s_id");
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String accid_st 	= request.getParameter("accid_st")==null?"":request.getParameter("accid_st");

	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();	
	
	
	if(user_id.equals("")){ 	user_id = login.getCookieValue(request, "acar_id"); }
	if(br_id.equals("")){	br_id = login.getCookieValue(request, "acar_br"); }
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "16", "01", "02"); }
	
	//���:������
	ContBaseBean base 		= p_db.getContBaseAll(m_id, l_cd);
	String h_brch = base.getBrch_id();
	String rent_st = base.getRent_st();
	String bus_st = base.getBus_st();  //6:������ü
	String ext_st = base.getExt_st();
		
	if (rent_st.equals("2")){
		rent_st = "5";
	}else if (rent_st.equals("7")){	
		rent_st = "6";
	}
	
	if (rent_st.equals("6") &&	bus_st.equals("6")){
		rent_st = "8";   // �縮�� ������ü
	}
	
	if (ext_st.equals("����")){
		rent_st = "5";
	}
	
	//������
	ClientBean client 		= al_db.getClient(base.getClient_id());
	
	//�����ȸ
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	  
	String accid_dt = a_bean.getAccid_dt();
	String accid_dt_h = "";
	String accid_dt_m = "";
	if(!accid_dt.equals("")){
		accid_dt = a_bean.getAccid_dt().substring(0,8);
		accid_dt_h = a_bean.getAccid_dt().substring(8,10);
		accid_dt_m = a_bean.getAccid_dt().substring(10,12);
	}
	  
	 //����/����(��å��)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);
	
    
	//service_call����
 	Vector vt		= p_db.getAccidentPollAll(m_id, l_cd, c_id, accid_id);
 	int vt_size = vt.size();

 	//live_poll����
 	Vector vt_live		= p_db.getPollTypeAll("3");  //��������
 	int vt_live_size = vt_live.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='car_rent_base.js'></script>

<script language="JavaScript">
<!--
	//����ϱ�
	function save()
	{	
		
		var fm = document.form1;
	   	var len = fm.elements.length;
	   	var cnt = 0;
	   	
	   	
<%		for (int j = 0; j < vt_live_size ; j++) { %>
		
			for (var i = 0; i < len ; i++) { 
				var ck = fm.elements[i];
				if (ck.name == "answer<%=j%>") {
					if (ck.checked == true) {
						cnt++;
					}	
				}
			}
			
			
	//	  	alert(cnt);
		  	
		  	if( cnt == 0 ) {
		      alert("<%=j+1%>�� ������ �亯�� �ټž� �մϴ�.!!!");
	       	  return ;
	    	} else { 	  
	 	 	  cnt =0;
	 		} 
		
<% } %>	  	 	  	

  			
		if(confirm('�����Ͻðڽ��ϱ�?')){
			fm.target='c_foot';
			fm.action='call_accident_reg_all_u_a.jsp';
			fm.submit();
		}
	}

//-->
</script>
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
</head>
<body leftmargin="15">

    <form action='call_service_reg_all_u_a.jsp' name="form1" method='post'>
    <!--������-->
    <input type='hidden' name="mode" value=''><!--�������� ������ ����,�߰� ������-->
    <input type='hidden' name="gubun" value=''>
	<input type='hidden' name='use_yn' value='<%=base.getUse_yn()%>'>
    <!--����-->
    <input type='hidden' name="h_c_id" value='<%=base.getClient_id()%>'><!-- client id -->
    <input type='hidden' name="h_gbn" value=''>
  	<input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='s_id' value='<%=s_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='accid_st' value='<%=accid_st%>'>

    <!--�˻���-->
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>		
    <input type='hidden' name='s_kd' value='<%=s_kd%>'>
    <input type='hidden' name='brch_id' value='<%=brch_id%>'>
    <input type='hidden' name='s_bank' value='<%=s_bank%>'>
    <input type='hidden' name='t_wd' value='<%=t_wd%>'>
    <input type='hidden' name='cont_st' value='<%=cont_st%>'> 
	<input type='hidden' name='b_lst' value='<%=b_lst%>'> 
 	
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align='left'>  
        <img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>�⺻����</b></a></td>
    </tr>
    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='110' class='title'>������</td>
                    <td width='180' align='left'>&nbsp; <input type='text' name="t_cl_gbn" 
                        			<% if(client.getClient_st().equals("1")){%>value='����'
        							<% }else if(client.getClient_st().equals("2")){%>value='����'
        							<% }else if(client.getClient_st().equals("3")){%>value='���λ����(�Ϲݰ���)'
        							<% }else if(client.getClient_st().equals("4")){%>value='���λ����(���̰���)'
        							<% }else if(client.getClient_st().equals("5")){%>value='���λ����(�鼼�����)'
        							<% }%>size='20' class='whitetext' readonly> </td>
                    <td width='100' class='title'>��ȣ</td>
                    <td width='180' align='left'>&nbsp; <input type='text' name="t_firm_nm" value='<%=client.getFirm_nm()%>' size='22' class='whitetext' readonly title='<%=client.getFirm_nm()%>'> 
                    </td>
                    <td width='100' class='title'>��ǥ��</td>
                    <td align='left'>&nbsp; <input type='text' name="t_client_nm" value='<%=client.getClient_nm()%>' size='12' class='whitetext' readonly> 
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>����ڹ�ȣ</td>                    
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_enp_no" value='<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>' size="22" class='whitetext' readonly> 
                    </td>
                    <td width="100" class='title'>�ֹι�ȣ</td>
                     <td width="180" align='left'>&nbsp; <input type='text' name="t_ssn" value='<%=client.getSsn1()%>-<%if(client.getSsn2().length() > 1){%><%=client.getSsn2().substring(0,1)%><%}%>******' size='22' class='whitetext' readonly>                                   
                    </td>
                    <td width='100' class='title'>Homepage</td>
                    <td align='left'>&nbsp; 
                      <%if(!client.getHomepage().equals("") && client.getHomepage().length() > 7){%>
                      <a href="<%=client.getHomepage()%>" target="_bank"> 
                      <input type='text' name="t_homepage" value='<%=client.getHomepage()%>' size='22' class='whitetext' readonly>
                      </a> 
                      <%}else{%>
                      <input type='text' name="t_homepage" value='<%=client.getHomepage()%>' size='22' class='whitetext' readonly> 
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>�繫����ȭ</td>
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_o_tel" value='<%= client.getO_tel()%>' size='22' class='whitetext' readonly> 
                    </td>
                    <td width="100" class='title'>FAX ��ȣ</td>
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_fax" value='<%= client.getFax()%>' size='22' class='whitetext' readonly> 
                    &nbsp; </td>
                    <td class='title' width="100">���������</td>
                    <td class='left'>&nbsp; <input type='text' name="t_open_year" value='<%= client.getOpen_year()%>' size='22' class='whitetext' readonly> 
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>�ں���</td>
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_firm_price" value='<%if(client.getFirm_price() > 0){ out.println(AddUtil.parseDecimal(client.getFirm_price())+"�鸸��/"+client.getFirm_day()); }%>' size='22' class='whitetext' readonly> 
                    </td>
                    <td width="100" class='title'>������</td>
                    <td width="180">&nbsp; <input type='text' name="t_firm_price_y" value='<%if(client.getFirm_price_y() > 0){ out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"�鸸��/"+client.getFirm_day_y()); }%>' size='25' class='whitetext' readonly> 
                    </td>
                    <td width="100" class='title'>���౸��</td>
                    <td>&nbsp;<input type='text' name="print_st" 
        							<% if(client.getPrint_st().equals("1")){%>value='���Ǻ�'
        							<% }else if(client.getPrint_st().equals("2")){%>value='�ŷ�ó����'
        							<% }else if(client.getPrint_st().equals("3")){%>value='��������'
        							<% }else if(client.getPrint_st().equals("4")){%>value='��������'
        							<% }%> size='22' class='whitetext' readonly>
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>����</td>
                    <td width="180" align='left'>&nbsp; <input type='text' name="t_bus_cdt" size='22' class='whitetext' readonly value="<%= client.getBus_cdt()%>"> 
                    </td>
                    <td width="100" class='title'>����</td>
                    <td align='left' colspan="3">&nbsp; <input type='text' name="t_bus_itm" size='50' class='whitetext' readonly value="<%= client.getBus_itm()%>"> 
                    </td>
                </tr>
                <tr> 
                    <td width="110" class='title'>������ּ�</td>
                    <td colspan="5">&nbsp; <input type='text' name="t_o_zip" value='<%=client.getO_zip()%>' size="7" class='whitetext' readonly> 
                      <input type='text' name="t_o_addr" value='<%=client.getO_addr()%>' size="59" class='whitetext' readonly> 
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
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="110">����</td>
                    <td class=title width="98">�ٹ��μ�</td>
                    <td class=title width="80">����</td>
                    <td class=title width="80">����</td>
                    <td class=title width="100">��ȭ��ȣ</td>
                    <td class=title width="100">�޴���</td>
                    <td class=title width="201">E-MAIL</td>
                    <td class=title width="80">���Űź�</td>			
                    <td class=title align='center'>&nbsp;</td>
                </tr>
                  <%//���ΰ�����������
        			Vector car_mgrs = a_db.getCarMgr(m_id, l_cd);
        			int mgr_size = car_mgrs.size();
        			if(mgr_size > 0){
        				for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>
                <tr> 
                    <td align='center' width="110"> <input type='hidden' name='h_mgr_id' size='10' class='text' value='<%=mgr.getMgr_id()%>'> 
                     <%= mgr.getMgr_st()%>
                    </td>
                    <td align='center'  width="98"> <input type='text' name='t_mgr_dept' 	value='<%= mgr.getMgr_dept()%>' size='9' maxlength='15' class='whitetext'  style='IME-MODE: active'> 
                    </td>
                    <td align='center'  width="80"> <input type='text' name='t_mgr_nm' 		value='<%= mgr.getMgr_nm()%>' size='9' maxlength='20' class='whitetext'> 
                    </td>
                    <td align='center'  width="80"> <input type='text' name='t_mgr_title' 	value='<%= mgr.getMgr_title()%>' size='9' maxlength='10' class='whitetext' style='IME-MODE: active'> 
                    </td>
                    <td align='center' width="100"> <input type='text' name='t_mgr_tel' 	value='<%= mgr.getMgr_tel()%>' size='12' maxlength='15' class='whitetext'> 
                    </td>
                    <td align='center' width="100"> <input type='text' name='t_mgr_mobile' 	value='<%= mgr.getMgr_m_tel()%>' size='12' maxlength='15' class='whitetext'> 
                    </td>
                    <td align='center' width="201"> <input type='text' name='t_mgr_email' 	value='<%= mgr.getMgr_email()%>' size='13' maxlength='30' class='whitetext' style='IME-MODE: inactive'> 
                    </td>
                    <td align='center'  width="80"> <input type="checkbox" name="mail_yn" disabled	value="N" <%if(mgr.getEmail_yn().equals("N")){%>checked<%}%>>
                    </td>			
                    <td align='center' valign="bottom"> 
                     
                    </td>
                </tr>
              <%	}
    			}%>
            
            </table>
	    </td>
    </tr>

    <tr>
        <td></td>
    </tr>
    <tr> 
        <td align='left'>  
        <img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>�����⺻����</b></a></td>
    </tr>
    <%	
		//�����������
		Hashtable car_fee 	= a_db.getCarRegFee(m_id, l_cd);
		//�����⺻����
		ContCarBean car 	= a_db.getContCar(m_id, l_cd);
		
		//�ڵ���ȸ��&����&�ڵ�����
		AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
		CarMstBean mst 		= a_cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	%>
     
    <input type='hidden' name='h_car_mng_id' value='<%=base.getCar_mng_id()%>'>
    <input type='hidden' name='h_car_rent_l_cd' value=''>
    <input type='hidden' name='h_car_rent_mng_id' value=''>
    
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='write'> 
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td class='line'>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>                   
                            <tr> 
                             	<td class='title' width='110'> ������ȣ </td>
                                <td width="180">&nbsp; <input type='text' name='t_car_no' value='<%=car_fee.get("CAR_NO")%>' class='whitetext' readonly size="13" > 
                                </td>
                                <td class='title' width='110'> �ڵ���ȸ�� </td>
                                <td width="180">&nbsp; <input type='text' name='t_com_nm' value='<%=mst.getCar_comp_nm()%>' class='whitetext' readonly size="13" > 
                                </td>
                                <td class='title' width="100">����</td>
                                <td width="180">&nbsp; <input type='text' name='t_car_nm' value='<%=mst.getCar_nm()%>' class='whitetext' readonly size="20" > 
                                </td>
                                <td class='title' width='100'>����</td>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                            <td>&nbsp; <input type='text' name='t_car_name' value='<%=mst.getCar_name()%>' class='whitetext' readonly size="30" > 
                                            </td>
                                            <td> <input type='hidden' name='h_car_id' value='<%=car.getCar_id()%>'> 
                                             <input type='hidden' name='t_car_seq' value='<%=car.getCar_seq()%>'> 
                                          	 <input type='hidden' name='t_com_id' value='<%=mst.getCar_comp_id()%>'> 
                                          	 <input type='hidden' name='t_car_cd' value='<%=mst.getCode()%>'> 
                				 <input type='hidden' name='s_st' value='<%=mst.getS_st()%>'> 
                                            </td>
                                         </tr>
                                    </table>
                                </td>
                            </tr>                                                        
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>                    
 	<tr>
        <td></td>
    </tr>
        
      <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����</span>  <font color=red>   *** ������ �ִ� ��츸 �ݴ���Դϴ�.</font>   </td>
        <td align="right"> 
        </td>
    </tr>
      <tr>
		<td class=line2 colspan=2></td>
	</tr> 
	
      <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp; 
                      <%if(a_bean.getDam_type1().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>
                    <td class=title width=10%>�빰</td>
                    <td width=15%>&nbsp;
					  <%if(a_bean.getDam_type2().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>
					<td class=title width=10%>�ڼ�</td>
                    <td width=15%>&nbsp; 
                      <%if(a_bean.getDam_type3().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>
					<td class=title width=10%>����</td>
                    <td width=15%>&nbsp; 
                      <%if(a_bean.getDam_type4().equals("Y")){%><b><font color='#990000'>����</font></b><%}else{%>����<%}%>
                    </td>										
                </tr>
            </table>
        </td>
    </tr>		
    <tr>
		<td class=h></td>
    </tr>        	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td width=15%>&nbsp; 
                      <%=c_id%>-<%=accid_id%>
                    </td>
                    <td class=title width=10%>�������</td>
                    <td width=15%>&nbsp;
                      <%if(a_bean.getAccid_st().equals("1")){%>����<%}%>
                      <%if(a_bean.getAccid_st().equals("2")){%>����<%}%>
                      <%if(a_bean.getAccid_st().equals("3")){%>�ֹ�<%}%>
                      <%if(a_bean.getAccid_st().equals("5")){%>�������<%}%>
                      <%if(a_bean.getAccid_st().equals("4")){%>��������<%}%>
                      <%if(a_bean.getAccid_st().equals("6")){%>����<%}%>
				  	  <%if(a_bean.getAccid_st().equals("7")){%>�縮������<%}%>
				      <%if(a_bean.getAccid_st().equals("8")){%>�ܵ�<%}%>
                    </td>
					<td class=title width=10%>�߻��Ͻ�</td>
                    <td width=15%>&nbsp; 
                      &nbsp;<%=AddUtil.ChangeDate3(a_bean.getAccid_dt())%>
                    </td>
					<td class=title width=10%>�����Ͻ�</td>
                    <td width=15%>&nbsp; 
                      &nbsp;<%=AddUtil.ChangeDate2(a_bean.getReg_dt())%>
                    </td>										
                </tr>
                <tr>
                  <td class=title>������</td>
                  <td colspan="7">&nbsp;
				    <%if(a_bean.getAccid_type_sub().equals("1")){%>[���Ϸ�]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("2")){%>[������]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("3")){%>[ö��ǳθ�]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("4")){%>[Ŀ���]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("5")){%>[����]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("6")){%>[������]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("7")){%>[����]<%}%>
                    <%if(a_bean.getAccid_type_sub().equals("8")){%>[��Ÿ]<%}%>
					<%if(!a_bean.getAccid_type_sub().equals("")){%>&nbsp;<%}%>
                    <%=a_bean.getAccid_addr()%></td>
                </tr>
                <tr>
                  <td class=title>������</td>
                  <td colspan="7">&nbsp;
				    <%=a_bean.getAccid_cont()%>
					<%if(!a_bean.getAccid_cont2().equals("") && !a_bean.getAccid_cont().equals(a_bean.getAccid_cont2())){%>
					<br>&nbsp;
					<%=a_bean.getAccid_cont2()%>
					<%}%>
				  </td>
               </tr>
               <tr>
                  <td class=title>Ư�̻���</td>
                  <td colspan="7">&nbsp;
				    <%=a_bean.getSub_etc()%>
		 </td>
                  </tr>
            </table>
        </td>
    </tr>		
    <tr>
	<td class=h></td>
    </tr>        	

     <tr> 
	        <td class=line colspan="2"> 
	            <table border="0" cellspacing="1" width=100%>
	                <tr> 
	                    <td width="4%" rowspan="2" class=title>����</td>
	                    <td colspan="3" class=title>�������</td>
	                    <td colspan="2" class=title>û��</td>
	                    <td colspan="2" class=title>�Ա�</td>
	                    <td width="9%" rowspan="2" class=title>��<br>�Աݾ�</td>
	                    <td width="9%" rowspan="2" class=title>��������<br>�ñݾ�</td>
	                    <td width="4%" rowspan="2" class=title>����<br>����</td>					
	                </tr>
	                <tr>
	                  <td width="10%" class=title>��������</td>
	                  <td width="14%" class=title>�����ü��</td>
	                  <td width="10%" class=title>����ݾ�</td>
	                  <td width="10%" class=title>�ݾ�</td>
	                  <td width="10%" class=title>����</td>
	                  <td width="10%" class=title>�ݾ�</td>
	                  <td width="10%" class=title>����</td>
	                </tr>
	              	<%	int tot_sv_amt = 0;
						int tot_sv_req_amt = 0;
						int tot_sv_pay_amt = 0;
						for(int i=0; i<s_r.length; i++){
	        				s_bean2 = s_r[i];
							if(!s_bean2.getNo_dft_yn().equals("Y")){
								tot_sv_amt 		+= s_bean2.getTot_amt();
							}
							tot_sv_req_amt 	+= s_bean2.getCust_amt();
							tot_sv_pay_amt 	+= s_bean2.getExt_amt();
							if(s_bean2.getDly_amt()>0){
								tot_sv_req_amt  += s_bean2.getDly_amt();
								tot_sv_pay_amt 	+= s_bean2.getDly_amt();
							}
							if(s_bean2.getCls_amt()>0){
								tot_sv_req_amt  += s_bean2.getCls_amt();
								tot_sv_pay_amt 	+= s_bean2.getCls_amt();
							}
							%>
	                <tr> 
	                    <td align="center"><%=i+1%></td>
	                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getServ_dt())%></td>
	                    <td align="center"><%=s_bean2.getOff_nm()%></td>
	                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getRep_amt())%>��
	                         <!--
	                         <% if ( s_bean2.getR_j_amt() > 0) { %>  
		                 <%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf((s_bean2.getR_labor()+s_bean2.getR_j_amt())* 1.1)))%>��
		                 <% } else { %>   
		                 <%=AddUtil.parseDecimal(s_bean2.getTot_amt())%>
		                 <% } %>
		                 -->
	                    </td> 
	                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getCust_amt())%>��</td>
	                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getCust_req_dt())%></td>
	                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getExt_amt())%>��</td>
	                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getCust_pay_dt())%></td>
			    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getDly_amt())//�Աݾ��� ext_amt�� �Ἥ �ӽ÷� dly_amt�� ��%>��</td>
			    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getCls_amt())%>��</td>
			    <td align="center"><span title="��������:<%=s_bean2.getNo_dft_cau()%>"><%if(s_bean2.getNo_dft_yn().equals("Y")){//��û��%>����<%}%></span></td>					
	                </tr>
	              	<%	}%>								
						
	            </table>
	        </td>
         </tr>	
          
	<tr>
	        <td></td>
    	</tr>
            
        <tr> 
        <td align='left'>  
        <img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>�ݰ�������</b></a></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr> 
 
  <!--call���� -loop-->  
<%	if(vt_size > 0){%>
   	<tr> 		
          <td class=line colspan="3"><table border="0" cellspacing="1" cellpadding='0' width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
			
					String poll_id_s = ht.get("POLL_ID").toString();
					
					 	//car call live_poll����
					Vector vt_call	= p_db.getPollAll(poll_id_s);
 					int vt_call_size = vt_call.size();
 					 					 
          	 		for (int j = 0 ; j < vt_call_size ; j++){
					Hashtable ht2 = (Hashtable)vt_call.elementAt(j);					
										
			 %>
			
			 <tr> 
            	<td width='110' class='title'>����&nbsp;<%=i+1%></td>
            	<td align='left' colspan=5>&nbsp;<input type='hidden' name="poll_id<%=i%>"  value='<%=ht.get("POLL_ID")%>' > 
            	<input type='text' name="question<%=i%>" value='<%=ht.get("QUESTION")%>' size='150' class='redtext' readonly > 
           		</td>
          	 </tr>
 
          	 <tr> 
	            <td class='title_g'>�亯&nbsp;<%=i+1%></td>
	            <td align='left' colspan=5>
	           	   <input type='radio' name="answer<%=i%>" value='1' <%if(ht.get("ANSWER").equals("1")){ %>checked<%}%>> <%=ht2.get("ANSWER1")%>
	          <% if( ht2.get("ANSWER1_REM").equals("1")   ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem0<%=i%>"><%if(ht.get("ANSWER").equals("1")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea> <% } %>
	           
	          <% if( !ht2.get("ANSWER2").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='2' <%if(ht.get("ANSWER").equals("2")){ %>checked<%}%>> <%=ht2.get("ANSWER2")%>  <% } %>
	          <% if( ht2.get("ANSWER2_REM").equals("1")   ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem1<%=i%>"><%if(ht.get("ANSWER").equals("2")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>  	          
	          <% if( !ht2.get("ANSWER3").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='3' <%if(ht.get("ANSWER").equals("3")){ %>checked<%}%>> <%=ht2.get("ANSWER3")%>   <% } %>
	          <% if( ht2.get("ANSWER3_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem2<%=i%>"><%if(ht.get("ANSWER").equals("3")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER4").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='4' <%if(ht.get("ANSWER").equals("4")){ %>checked<%}%>> <%=ht2.get("ANSWER4")%>   <% } %>
	          <% if( ht2.get("ANSWER4_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem3<%=i%>"><%if(ht.get("ANSWER").equals("4")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER5").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='5' <%if(ht.get("ANSWER").equals("5")){ %>checked<%}%>> <%=ht2.get("ANSWER5")%>   <% } %>
	          <% if( ht2.get("ANSWER5_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem4<%=i%>"><%if(ht.get("ANSWER").equals("5")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER6").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='6' <%if(ht.get("ANSWER").equals("6")){ %>checked<%}%>> <%=ht2.get("ANSWER6")%>   <% } %>
	          <% if( ht2.get("ANSWER6_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem5<%=i%>"><%if(ht.get("ANSWER").equals("6")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER7").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='7' <%if(ht.get("ANSWER").equals("7")){ %>checked<%}%>> <%=ht2.get("ANSWER7")%>   <% } %>
	          <% if( ht2.get("ANSWER7_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem6<%=i%>"><%if(ht.get("ANSWER").equals("7")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER8").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='8' <%if(ht.get("ANSWER").equals("8")){ %>checked<%}%>> <%=ht2.get("ANSWER8")%>   <% } %>
	          <% if( ht2.get("ANSWER8_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem7<%=i%>"><%if(ht.get("ANSWER").equals("8")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	            </td>
	          </tr>
	          
	         <%}%>
	       <% } %>  
            </table>
        </td>  
    </tr>
<%}%>  
<%	if(vt_size == 0){%>
	<tr> 
        <td class=line colspan="3"> <table border="0" cellspacing="1" cellpadding='0' width=100%>
         <% for (int i = 0 ; i < vt_live_size ; i++){
					Hashtable ht1 = (Hashtable)vt_live.elementAt(i);
													
		%>
    	  <tr> 
            <td width='110' class='title'>����&nbsp;<%=i+1%></td>
            <td align='left' colspan=5>&nbsp;
            <input type='hidden' name="poll_id<%=i%>" value='<%=ht1.get("POLL_ID")%>'  > 
            <input type='text' name="question<%=i%>"  size='150' maxlength='256' value='<%=ht1.get("QUESTION")%>' class='redtext' readonly > 
            </td>
          </tr>
          <tr> 
            <td class='title_g'>�亯&nbsp;<%=i+1%></td>
            <td align='left' colspan=5>
           	   <input type='radio' name="answer<%=i%>" value='1' ><%=ht1.get("ANSWER1")%>
          <% if( ht1.get("ANSWER1_REM").equals("1") ){ %> <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem0<%=i%>"></textarea>   <% } %>
          
          <% if( !ht1.get("ANSWER2").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='2' ><%=ht1.get("ANSWER2")%>  <% } %>
          <% if( ht1.get("ANSWER2_REM").equals("1") ){ %> <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem1<%=i%>"></textarea></p>  <% } %>  
                      
          <% if( !ht1.get("ANSWER3").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='3'> <%=ht1.get("ANSWER3")%>   <% } %>
          
          <% if( ht1.get("ANSWER3_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem2<%=i%>"></textarea></p>  <% } %>                 
          <% if( !ht1.get("ANSWER4").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='4' ><%=ht1.get("ANSWER4")%>   <% } %>
          <% if( ht1.get("ANSWER4_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem3<%=i%>"></textarea></p>  <% } %>
          <% if( !ht1.get("ANSWER5").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='5' ><%=ht1.get("ANSWER5")%>   <% } %>
          <% if( ht1.get("ANSWER5_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem4<%=i%>"></textarea></p>  <% } %>
          <% if( !ht1.get("ANSWER6").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='6' ><%=ht1.get("ANSWER6")%>   <% } %>
          <% if( ht1.get("ANSWER6_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem5<%=i%>"></textarea></p>  <% } %>
          <% if( !ht1.get("ANSWER7").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='7' ><%=ht1.get("ANSWER7")%>   <% } %>
          <% if( ht1.get("ANSWER7_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem6<%=i%>"></textarea></p>  <% } %>
          <% if( !ht1.get("ANSWER8").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='8' ><%=ht1.get("ANSWER8")%>   <% } %>
          <% if( ht1.get("ANSWER8_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='140' name="answer_rem7<%=i%>"></textarea></p>  <% } %>
            </td>
          </tr>
          <%}%>
    	  </table></td>
    </tr>
 <%}%>  
</table>
</form>  

</body>
</html>

