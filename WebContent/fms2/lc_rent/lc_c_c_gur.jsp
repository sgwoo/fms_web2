<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_register.*, cust.member.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//���뺸��������
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	
	from_page = "/fms2/lc_rent/lc_c_c_gur.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����
	function update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}else{
			var height = 500;
			if(st == 'client') 				height = 250;
			else if(st == 'mgr') 			height = 350;
			else if(st == 'client_guar') 	height = 250;
			else if(st == 'guar') 			height = 300;
			else if(st == 'dec') 			height = 700;			
			else if(st == 'gi') 			height = 250;			
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=50, top=50, width=1050, height="+height+", scrollbars=yes");
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
<form action='lc_c_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 			value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 			value='<%=user_id%>'>
  <input type='hidden' name='br_id' 			value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="car_cs_amt"		value="<%=car.getCar_cs_amt()%>">
  <input type='hidden' name="car_cv_amt"		value="<%=car.getCar_cv_amt()%>">
  <input type='hidden' name="car_c_amt"			value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">  
  <input type='hidden' name="car_fs_amt"		value="<%=car.getCar_fs_amt()%>">
  <input type='hidden' name="car_fv_amt"		value="<%=car.getCar_fv_amt()%>">
  <input type='hidden' name="car_f_amt"			value="<%=car.getCar_fs_amt()+car.getCar_fv_amt()%>">    
  <input type='hidden' name="opt_cs_amt"		value="<%=car.getOpt_cs_amt()%>">
  <input type='hidden' name="opt_cv_amt"		value="<%=car.getOpt_cv_amt()%>">
  <input type='hidden' name="opt_c_amt"			value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">  
  <input type='hidden' name="sd_cs_amt"			value="<%=car.getSd_cs_amt()%>">
  <input type='hidden' name="sd_cv_amt"			value="<%=car.getSd_cv_amt()%>">
  <input type='hidden' name="sd_c_amt"			value="<%=car.getSd_cs_amt()+car.getSd_cv_amt()%>">  
  <input type='hidden' name="col_cs_amt"		value="<%=car.getClr_cs_amt()%>">
  <input type='hidden' name="col_cv_amt"		value="<%=car.getClr_cv_amt()%>">
  <input type='hidden' name="col_c_amt"			value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">  
  <input type='hidden' name="dc_cs_amt"			value="<%=car.getDc_cs_amt()%>">
  <input type='hidden' name="dc_cv_amt"			value="<%=car.getDc_cv_amt()%>">
  <input type='hidden' name="dc_c_amt"			value="<%=car.getDc_cs_amt()+car.getDc_cv_amt()%>">  
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ��������</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
<%--     <tr id=tr_client_share_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  --%>
    <tr id='tr_client_share_st'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>������������</td>
                    <td colspan="4" align='left'>&nbsp;<%if(cont_etc.getClient_share_st().equals("1")){%>�ִ�<%}else{%>����<%}%></td>
                </tr>
                <!-- �����ڰݰ������ -->
                <%if(client.getClient_st().equals("2") && cont_etc.getClient_share_st().equals("1")){ %>    
                <tr>
                    <td class='title' rowspan='2'>�������� �����ڰݰ���</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="���������������� ��ȸ" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;���������(�̸�) : <%=base.getTest_lic_emp2()%></td>
		            <td width='12%'>&nbsp;���� : <%=base.getTest_lic_rel2()%></td>
		            <td width='40%'>&nbsp;������� : <%=c_db.getNameByIdCode("0050", "", base.getTest_lic_result2())%></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;(����)&nbsp;�� ���ΰ��� ������������ �ִ� ��� �����ڰ��� ����</td>
                </tr>  
                <%} %>
            </table>  
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>   
  	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ ���뺸��&nbsp;<%if(base.getBus_id().equals(user_id) || nm_db.getWorkAuthUser("�����ڸ��",user_id)){%><a href="javascript:update('client_guar')" title="�����ڸ��"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( ������ : ��ǥ�̻纸������, ��������, ������ ���� )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr id=tr_client_guar_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>��������</td>
                    <td colspan="3" align='left'>&nbsp;<%if(cont_etc.getClient_guar_st().equals("1")){%>�Ժ�<%}else if(cont_etc.getClient_guar_st().equals("2")){%>����<%}%></td>
                </tr>
                <tr id=tr_client_guar style="display:<%if(cont_etc.getClient_guar_st().equals("2")){%>''<%}else{%>none<%}%>">
                    <td class='title'>��������</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                      <%if(cont_etc.getGuar_con().equals("1")){%>�ſ�����<%}%>
                      <%if(cont_etc.getGuar_con().equals("2")){%>���������δ�ü<%}%>
                      <%if(cont_etc.getGuar_con().equals("3")){%>�����������δ�ü<%}%>
                      <%if(cont_etc.getGuar_con().equals("4")){%>��Ÿ ����ȹ��<%}%>
                      <%if(cont_etc.getGuar_con().equals("5")){%>�����濵��<%}%>
                      <%if(cont_etc.getGuar_con().equals("6")){%>��ǥ��������<%}%>
                    </td>
                    <td width="10%" class='title'>������</td>
                    <td width="27%" class='left'>&nbsp;<%=c_db.getNameById(cont_etc.getGuar_sac_id(),"USER")%></td>
                </tr>
            </table>  
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>   
  	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���뺸���� (��ǥ�̻��)&nbsp;<%if(base.getBus_id().equals(user_id) || nm_db.getWorkAuthUser("�����ڸ��",user_id)){%><a href="javascript:update('guar')" title="�����ڸ��"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><%}%><font color="#CCCCCC"> ( ������ : ���뺸��������, �Ż����� ���� )</font></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>		
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>���뺸��</td>
                    <td colspan="3" align='left'>&nbsp;<%if(cont_etc.getGuar_st().equals("1")){%>����<%}else if(cont_etc.getGuar_st().equals("2")){%>����<%}%></td>
                </tr>
                <tr id=tr_guar2 <%if(cont_etc.getGuar_st().equals("1")){%>style="display:''"<%}else{%>style='display:none'<%}%>>
                    <td height="26" colspan="4" class=line>
    			        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width="13%" class=title>����</td>
                                <td width="10%" class=title>����</td>
                                <td width="12%" class='title'>�������</td>
                                <td width="42%" class='title'>�ּ�</td>
                                <td width="13%" class='title'>����ó</td>
                                <td width="10%" class='title'>����</td>
                            </tr>
                            <%for(int i = 0 ; i < gur_size ; i++){
            					Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
                            <tr>
                                <td class=title>���뺸����</td>
                                <td align="center"><%=gur.get("GUR_NM")%></td>
                                <td align="center"><%=AddUtil.ChangeEnpH(String.valueOf(gur.get("GUR_SSN")))%></td>
                                <td align="center"><%=gur.get("GUR_ZIP")%>&nbsp;<%=gur.get("GUR_ADDR")%></td>
                                <td align="center"><%=gur.get("GUR_TEL")%></td>
                                <td align="center"><%=gur.get("GUR_REL")%></td>
                            </tr>
                            <%}%>
                        </table>
    			    </td>			
                </tr>		  
            </table>  
        </td>
    </tr>
    <%if(!base.getCar_st().equals("4")){%>
    
    <%	
			for(int f=1; f<=fee_size ; f++){
				ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));
		%>       
    <tr>
        <td class=h></td>
    </tr> 
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(f >1){%><%=f%>�� ���� <%}%>�������� <%if(f==fee_size && (user_id.equals("000000") || base.getBus_id().equals(user_id) || nm_db.getWorkAuthUser("������",user_id))){%><a href="javascript:update('gi')"><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a><font color="#CCCCCC"> ( ������ : ���Կ���, ��������, ���Աݾ�, ����� ���� )</font><%}%></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr id=tr_gi style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">���Կ���</td>
                    <td colspan="5">&nbsp;<%if(ext_gin.getGi_st().equals("1")){%>����<%}else if(ext_gin.getGi_st().equals("0")){%>����<%}%></td>
                </tr>
                <tr id=tr_gi1 style="display:<%if(ext_gin.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>��������</td>
                    <td width="20%">&nbsp;<%=ext_gin.getGi_jijum()%></td>
                    <td width="10%" class='title'>���Աݾ�</td>
                    <td width="20%" >&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>��</td>
                    <td width="10%" class=title >���������</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>��</td>
                </tr>
                <tr id=tr_gi2 style="display:<%if(ext_gin.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>���ǹ�ȣ</td>
                    <td width="20%">&nbsp;��<%=ext_gin.getGi_no()%>ȣ</td>
                    <td width="10%" class='title'>����Ⱓ</td>
                    <td width="20%" >&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_start_dt())%>~<%=AddUtil.ChangeDate2(ext_gin.getGi_end_dt())%></td>
                    <td class=title >���谡������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    
    <%}%>
     	
  	<%		for(int i=1; i<=fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i));
				if(fees.getGrt_amt_s()+fees.getPp_s_amt()+fees.getIfee_s_amt()+fees.getPp_v_amt()+fees.getIfee_v_amt() > 0){%>	
	<tr>
        <td class=h></td>
    </tr>    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(i >1){%><%=i%>�� ���� <%}%>������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
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
                    <%if(!base.getCar_st().equals("4")){%><td width="3%" rowspan="5" class='title'>��<br>
                      ��</td><%}%>
                    <td <%if(base.getCar_st().equals("4")){%>colspan='2'<%}else{%>width="10%"<%}%>class='title'>������</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  �� </td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % </td>
                    <td align='center'>
    			    <%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%><input type='hidden' name='gur_per' value=''></td>
                </tr>
                <%if(!base.getCar_st().equals("4")){%>
                <tr>
                    <td class='title'>������</td>
                    <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1")%></td>
                    <td align="center">������
                        <input type='text' size='4' name='pere_r_per' class='whitenum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % </td>
                    <td align='center'>-<input type='hidden' name='pere_per' value=''></td>
                </tr>
                <tr>
                    <td class='title'>���ô뿩��</td>
                    <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='ifee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2")%></td>
                    <td align="center">������
                        <input type='text' size='2' name='pere_r_mth' class='whitenum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  ����ġ �뿩�� </td>
                    <td align='center'><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%><input type='hidden' name='pere_mth' value=''></td>
                </tr>
                <tr>
                    <td class='title'>�հ�</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s()+fees.getPp_s_amt()+fees.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center"><input type='text' size='9' name='tot_pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt()+fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'><input type='text' size='10' name='tot_pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s()+fees.getPp_s_amt()+fees.getIfee_s_amt()+fees.getPp_v_amt()+fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center'>-</td>
                    <td align="center">�Աݿ����� :
                          <input type='text' size='11' name='pp_est_dt' maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>&nbsp;</td>
                </tr>
                <%}%>
    		</table>
	    </td>
    </tr>
	<%}else{%>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������ : ����</span></td>
    </tr>
	<%}}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	//�ٷΰ���
	var s_fm = parent.parent.top_menu.document.form1;
	var fm 		= document.form1;	
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value = fm.client_id.value;
	s_fm.accid_id.value = "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";
//-->
</script>
</body>
</html>
