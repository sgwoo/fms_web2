<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*"%>
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
	String fee_start_dt = "";
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String ins_st 	= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	
	if(rent_l_cd.equals("")){
		Hashtable cont = a_db.getContViewUseYCarCase(c_id);
		rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
		rent_l_cd 		= String.valueOf(cont.get("RENT_L_CD"));
	}
	
	if(rent_l_cd.equals("") && !l_cd.equals("")){
		rent_mng_id = m_id;
		rent_l_cd 	= l_cd;
	}
	
	if(rent_l_cd.equals("") || rent_l_cd.equals("null")) return;
	
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "15", "01", "16");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(c_id.equals("")){
		c_id = base.getCar_mng_id();
	}
	
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
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�����⺻����
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//�����ڰݰ������
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//���ó�¥ ���ϱ�
var dt = new Date();		
var month = dt.getMonth()+1;	if(month<10)	month = "0"+month;
var day = dt.getDate();
var year = dt.getFullYear();

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
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
	
	
	function set_d_ch_amt(){
		var fm = document.form1;
		fm.d_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.n_fee_amt.value)) - toInt(parseDigit(fm.o_fee_amt.value)));
	}	
	
	//���
	function save(){
		var fm = document.form1;
		
		for(var i=0 ; i<2 ; i++){
		fm.rent_way_nm[i].value = fm.rent_way[i].options[fm.rent_way[i].selectedIndex].text;
		}
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "u_chk"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("��������� �����ϼ���.");
			return;
		}	
		

		
		
		if(fm.cng_dt.value == '')			{ alert('�������ڸ� �Է��Ͻʽÿ�.'); 						fm.cng_dt.focus(); 	return; }
		if(fm.cng_etc.value == '')			{ alert('���� �� Ư�̻����� �Է��Ͻʽÿ�.'); 				fm.cng_etc.focus();	return; }
			
		if(fm.n_fee_amt.value == '' || fm.n_fee_amt.value == '0')		
											{ alert('������ �뿩��ݾ��� �Է��Ͻʽÿ�.');				fm.cng_dt.focus();	return; }
		if(fm.u_chk[2].checked==true ){
			//�߰������� �߰�
			if(fm.fee_add_user.value == '������ �߰�'){
				if(fm.mgr_lic_no5.value == ''){
					alert('�߰������� ���������ȣ�� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_emp5.value == ''){
					alert('�߰������� ���������ȣ �̸��� �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_rel5.value == ''){
					alert('�߰������� ���������ȣ ���踦 �Է��Ͻʽÿ�.');
					return;
				}
				if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_result5.value != '1'){
					alert('�߰��������� ���������������� Ȯ�����ּ���. �����ڰ� ���� �ڿ��� ������ �뿩�� �� �����ϴ�.');
					return;
				}
			}
		}		
		
		if(confirm('����Ͻðڽ��ϱ�?')){	
		
			fm.action='fee_doc_reg_c_a.jsp';		
//			fm.target='i_no';
			fm.target='_blank';
			fm.submit();
		}							
	}
	
	//�뿩�� �Աݿ����� ���̸� ���뿩�� �� �������� �ڵ�����(20180723)
	function setDisplayValue(val){
		var fm = document.form1;
		if(val=="6"){
			fm.cng_dt.value = year+""+month+""+day;
			fm.n_fee_amt.value = fm.o_fee_amt.value;		
		}else{
			fm.cng_dt.value = ""
			fm.n_fee_amt.value = "";
		}
		set_d_ch_amt();
		if(val=="4"){
			if(fm.fee_add_user.value == '������ �߰�'){
				tr_mgr5.style.display='';//����
			}else{
				tr_mgr5.style.display='none';//����
			}	
		}else{
			tr_mgr5.style.display='none';//����
		}
	}
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
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
<form action='fee_doc_reg_c_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 			value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 			value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"	 	value="<%=ext_fee.getRent_st()%>">
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="c_id"	 		value="<%=c_id%>">  
  <input type='hidden' name="from_page" 	value="/fms2/con_fee/fee_doc_reg_c.jsp">             
  <input type='hidden' name='st' value=''>        
  
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
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=3%>����</td>
                    <td width="10%" class=title>����</td>
                    <td class=title width=22%>������ </td>
                    <td class=title width=65%>������</td>
                </tr>
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="1" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>�뿩��ǰ</td>
                    <td>&nbsp;
					  <select name="rent_way" disabled><!--disabled Ǯ�� ó���κ� �ҽ� �迭�� �����ؾ���. Ǯ������ -->
                        <option value=''>����</option>
                        <option value='1' <%if(ext_fee.getRent_way().equals("1")){%>selected<%}%>>�Ϲݽ�</option>
                        <option value='3' <%if(ext_fee.getRent_way().equals("3")){%>selected<%}%>>�⺻��</option>
                      </select>
					</td>
                    <td>&nbsp;
					  <select name="rent_way">
                        <option value='1' <%if(ext_fee.getRent_way().equals("1")){%>selected<%}%>>�Ϲݽ�</option>
                        <option value='3' <%if(ext_fee.getRent_way().equals("3")){%>selected<%}%>>�⺻��</option>
                      </select>
					  <input type='hidden' name='rent_way_nm' value=''>
					  <input type='hidden' name='rent_way_nm' value=''>
					  </td>
                </tr>
                
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="2" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>�뿩������</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='fee_dc' size='100' class='text'>
				  </td>
                </tr>
                 <tr>
                  <td class=title><input type="radio" name="u_chk" value="4" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>�߰�������</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <select name="fee_add_user" id="fee_add_user" onChange="javascript:setDisplayValue(4)">                        
                        <option value='������ �߰�' >������ �߰�</option>
                        <option value='������ �߰� ���' >������ �߰� ���</option>
                      </select>                      
				  </td>
                </tr>
                 <tr>
                  <td class=title><input type="radio" name="u_chk" value="5" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>��������Ÿ�����</td>
                    <td>&nbsp;
					  <%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>km����/1��<input type='hidden' name="o_agree_dist"	value="<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>"></td>
                    <td>&nbsp;
                      <input type='text' name='fee_dis_plus' size='10' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>km����/1��
				  </td>
                </tr>
                <!-- �뿩�� �Աݿ�����(20180718) -->
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="6" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>�뿩�� �Աݿ�����</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='fee_day' size='100' class='text'>
				  </td>
                </tr>
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="7" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>�������ｺƼĿ�߱�</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='fee_sticker' size='100' class='text'>
				  </td>
                </tr>
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="8" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>������ġ����</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='others_device' size='100' class='text'>
				  </td>
                </tr>
                <tr>
                  <td class=title><input type="radio" name="u_chk" value="9" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>����������</td>
                    <td>&nbsp;
					  <%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>��<input type='hidden' name="o_grt_amt"	value="<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>"></td>
                    <td>&nbsp;
                      <input type='text' name='grt_amt' size='12' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��
				  </td>
                </tr>
                 <tr>
                  <td class=title><input type="radio" name="u_chk" value="3" onclick="javascript:setDisplayValue(this.value);"></td> 
                    <td class=title>��Ÿ</td>
                    <td>&nbsp;
					  -</td>
                    <td>&nbsp;
                      <input type='text' name='fee_etc' size='100' class='text'>
				  </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>��������</td>
                    <td>&nbsp;
        			  <input type='text' name='cng_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
					</td>
                </tr>
                <tr> 
                    <td class='title'>���� �� Ư�̻���</td>
                    <td>&nbsp;
        			  <textarea name="cng_etc" cols="100" class="text" style="IME-MODE: active" rows="5"></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
	<tr>
	    <td class=h></td>
	</tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩�ὺ���� �ݿ� ��</span></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=13%>����</td>
                    <td class=title width=22%>������</td>
                    <td class=title width=22%>������</td>
                    <td class=title width=43%>-</td>
                </tr>
                <tr>
                    <td class='title'>���뿩��</td>
                    <td>&nbsp;
        			          <input type='text' name='o_fee_amt' size='10' value='<%=AddUtil.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_d_ch_amt();'>��
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_fee_amt' size='10' value='' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_d_ch_amt();'>��
					              &nbsp;&nbsp;(vat����)
					          </td>
                    <td>&nbsp;���ݿ��ݾ� : 
        			          �� <input type='text' name='d_fee_amt' size='10' value='' class='num' onBlur='javascript: this.value = parseDecimal(this.value); set_d_ch_amt();'>���� ����
					              &nbsp;&nbsp;(vat����)
					          </td>
                </tr>
                <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                <tr>
                    <td class='title'>ȯ�޴뿩��</td>
                    <td>&nbsp;
        			          <input type='text' name='o_rtn_run_amt' size='10' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��/1km(�ΰ�������)
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_rtn_run_amt' size='10' value='<%=AddUtil.parseDecimal(fee_etc.getRtn_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��/1km(�ΰ�������)					              
					          </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class='title'>�ʰ�����뿩��</td>
                    <td>&nbsp;
        			          <input type='text' name='o_over_run_amt' size='10' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��/1km(�ΰ�������)
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_over_run_amt' size='10' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��/1km(�ΰ�������)					              
					          </td>
                    <td>&nbsp;</td>
                </tr>
                <%} %>
                <tr>
                    <td class='title'>���Կɼǰ���</td>
                    <td>&nbsp;
        			          <input type='text' name='o_opt_amt' size='10' value='<%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_opt_amt' size='10' value='<%=AddUtil.parseDecimal(ext_fee.getOpt_s_amt()+ext_fee.getOpt_v_amt())%>' class='num' onBlur='javascript: this.value = parseDecimal(this.value);'>��
					              &nbsp;&nbsp;(vat����)
					          </td>
                    <td>&nbsp;</td>
                </tr>        
                <tr> 
                    <td class='title'>������</td>
                    <td>&nbsp;
        			          <input type='text' name='o_cls_per' size='10' value='<%=ext_fee.getCls_r_per()%>' class='num'>%
					          </td>
                    <td>&nbsp;
					              <input type='text' name='n_cls_per' size='10' value='<%=ext_fee.getCls_r_per()%>' class='num'>%
					          </td>
                    <td>&nbsp;</td>
                </tr>                                
            </table>
        </td>
    </tr>
    <!-- �߰������� -->
    <tr>
	    <td class=h></td>
	</tr>	
    <tr id=tr_mgr5 style="display:none"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                	  
                <%	
              		//���ΰ�����������
            		Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
            		int mgr_size = car_mgrs.size();
            		CarMgrBean mgr5 = new CarMgrBean();
                	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("�߰�������")){
        					mgr5 = mgr;
        				}
					}                       
                %>                 
                <tr>
                    <td width=13% class='title'>�߰������� ���������ȣ</td>
                    <td>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td>&nbsp;�����ȣ : <input type='text' name='mgr_lic_no5' value='<%=mgr5.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;�̸� : <input type='text' name='mgr_lic_emp5' value='<%=mgr5.getMgr_nm()%>'  size='10' class='text'></td>
		            <td>&nbsp;���� : <input type='text' name='mgr_lic_rel5' value='<%=mgr5.getEtc()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;������� : <select name='mgr_lic_result5'>
        		          		<option value='' <%if(mgr5.getLic_result().equals("")) out.println("selected");%>>����</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(mgr5.getLic_result().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        		<%}%> 
        		            </select>&nbsp;</td>
                </tr>                    	                              
            </table>
        </td>
    </tr>
    
    
    		
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
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
