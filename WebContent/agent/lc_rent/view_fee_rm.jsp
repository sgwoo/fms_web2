<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	
	//2. �ڵ���--------------------------
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	
	//3. �뿩-----------------------------
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	
	//����Ʈ����
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, rent_st);
	
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	from_page = "/fms2/lc_rent/lc_c_c_fee.jsp";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//������ �հ�
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		
	
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
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <input type='hidden' name="opt"				value="<%=car.getOpt()%>">
  <input type='hidden' name="car_st" 			value="<%=base.getCar_st()%>">
  <input type='hidden' name="purc_gu" 			value="<%=car.getPurc_gu()%>">  
  <input type='hidden' name="pay_st" 			value="<%=car.getPay_st()%>">    
  <input type='hidden' name="rent_way" 			value="<%=fee.getRent_way()%>">    
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
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">        
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>    
  <input type='hidden' name='site_id' 			value='<%=base.getR_site()%>'>
  <input type='hidden' name="car_mng_id" 		value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="dec_gr"			value="<%=cont_etc.getDec_gr()%>"> 
  <input type='hidden' name="o_1"				value="">
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
          
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩���</font></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
    		<%if(rent_st.equals("1")){%>
                <tr>
                    <td width="13%" align="center" class=title>�������</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td width="10%" align="center" class=title>�������</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                </tr>
    		  <%}else{%>
                <tr>
                    <td width="13%" align="center" class=title>�������</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_dt())%></td>
                    <td width="10%" align="center" class=title>�������</td>
                    <td colspan="3">&nbsp;<%=c_db.getNameById(fee.getExt_agnt(),"USER")%></td>
                </tr>		  
    		  <%}%>
                <tr>
                    <td width="13%" align="center" class=title>�̿�Ⱓ</td>
                    <td width="20%">&nbsp;<%=fee.getCon_mon()%>����</td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
                    <td width="10%" align="center" class=title>�뿩������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_end_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr>
        <td class=line>
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
                <td colspan='2' class='title'>������</td>
                <td align='center'>-</td>
                <td align='center'>-</td>
                <td align='center'><input type='text' size='11' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
    		<td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fee.getRent_st(), "0")%></td>		  
                <td align="center">������
                    <input type='text' size='4' name='gur_p_per' class='whitenum' value='<%=fee.getGur_p_per()%>' readonly>
    				  % </td>
                <td align='center'><%if(base.getRent_st().equals("3") && fee.getRent_st().equals("1")){%>���� ������ �°迩�� :<%}%>
        			  <%if(fee.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fee.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%><input type='hidden' name='gur_per' value=''>
		</td>
              </tr>                           
                <tr>
                    <td rowspan="5" class='title'>��<br>��<br>
                      ��<br>
                      ��</td>
                    <td class='title'>����뿩��</td>
                    <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='9' name='inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getInv_s_amt()+fee.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  �� </td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td class='title'>D/C</td>
                    <td align="center" ><input type='text' size='10' name='dc_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='9' name='dc_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='dc_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt()+fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  �� </td>
                    <td align='center'>-</td>
                    <td align="center">DC��:
                      <input type='text' size='4' name='dc_ra' maxlength='10' class="whitenum" value='<%=fee.getDc_ra()%>'></td>
                    <td align='center'>&nbsp;</td>
                </tr>	
              <tr>
                <td class='title'>������̼�</td>
                <td align="center"><input type='text' size='11' name='navi_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='navi_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='navi_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                  <%if(fee_rm.getNavi_yn().equals("N")){%>����<%}else if(fee_rm.getNavi_yn().equals("Y")){%>����<%}else{%>-<%}%>                  
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>��Ÿ</td>
                <td align="center"><input type='text' size='11' name='etc_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='etc_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='etc_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                    <input type='text' size='40' name='etc_cont' class='whitetext' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
                <td align='center'>-</td>
              </tr>                
                <tr>
                    <td class='title'>�Ұ�</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align="center" ><input type='text' size='9'  name='fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  ��</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  �� </td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                </tr>    
              <tr>
                <td colspan="2" class='title'>�뿩���Ѿ�</td>
                <td align="center"><input type='text' size='11' name='t_fee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='t_fee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='t_fee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center"><input type='text' name="v_con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 ����
        	    <input type='text' name="v_con_day" value='<%=fee_etc.getCon_day()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 ��</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>������</td>
                <td align="center"><input type='text' size='11' name='cons1_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='cons1_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='cons1_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                  <%if(fee_rm.getCons1_yn().equals("N")){%>����<%}else if(fee_rm.getCons1_yn().equals("Y")){%>����<%}else{%>-<%}%>                    
    	 	</td>
                <td align='center'>
    			  
                </td>
              </tr>
              <tr>
                <td colspan="2" class='title'>������</td>
                <td align="center"><input type='text' size='11' name='cons2_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='cons2_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='cons2_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center">
                  <%if(fee_rm.getCons2_yn().equals("N")){%>����<%}else if(fee_rm.getCons2_yn().equals("Y")){%>����<%}else{%>-<%}%>                    
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>�հ�</td>
                <td align="center"><input type='text' size='11' name='rent_tot_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align="center"><input type='text' size='11' name='rent_tot_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'><input type='text' size='11' name='rent_tot_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  ��</td>
                <td align='center'>-</td>
                <td align="center"> </td>
                <td align='center'>-</td>
              </tr>   
              <%if(rent_st.equals("1")){%> 
              <tr>                
                <td colspan="2" class='title'><span class="title1">���ʰ����ݾ�</span></td>
                <td align='center'><input type="text" name="f_rent_tot_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��		  
                </td>                
                <td colspan='4'>&nbsp;&nbsp;&nbsp;
                     * ���ʰ������ : <%if(fee_rm.getF_paid_way().equals("1")){%>1����ġ<%}else if(fee_rm.getF_paid_way().equals("2")){%>�Ѿ�<%}else{%>-<%}%>                         
                      &nbsp;&nbsp;&nbsp;
                      ������ <%if(fee_rm.getF_paid_way2().equals("1")){%>����<%}else if(fee_rm.getF_paid_way2().equals("2")){%>������<%}else{%>-<%}%>                                                   
                      &nbsp;&nbsp;&nbsp;
                      * ����� : <input type="text" name="f_con_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_con_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��	
                  
                </td>                
                <td align='center'>-</td>
              </tr>   
              <tr>
                <td colspan="2" class='title'><span class="title1">��������Ÿ�</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='agree_dist' size='8' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etc.getAgree_dist())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  km����/1��,
                  �ʰ� 1km�� (<input type='text' name='over_run_amt' size='3' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etc.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  ��)�� �߰������ �ΰ��˴ϴ�.
                </td>
                <td align='center'>-</td>
              </tr>     
			
                <tr>
                    <td colspan="2" class='title'>�ߵ�����������</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">�ܿ��Ⱓ �뿩����
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='whitenum' value='<%=fee.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='whitenum' value='<%=fee.getCls_per()%>'>%
			</font></span></td>
                </tr>		  
				<%if(fee.getRent_st().equals("1") && base.getRent_st().equals("3")){
					//�������������
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}%>
                <tr>
                    <td colspan="2" class='title'>���������</td>
                    <td colspan="6">&nbsp;
					  [���������]&nbsp;&nbsp;
        			  ����ȣ : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;������ȣ : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;�����ڵ庰���� ���� : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[���������ݽ°�]</b>
					  &nbsp;���������� : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>��
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  �°躸���� : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='whitenum'  readonly>��
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(���������� ���� <%=AddUtil.parseDecimal(fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  <%} %>					  
        			</td>
                </tr>		
		        <%}%>  	
		<%}%>        
                <tr>
                    <td colspan="2" class='title'>���</td>
                    <td colspan="6">&nbsp;<%=HtmlUtil.htmlBR(fee.getFee_cdt())%></td>
                </tr>
            </table>		
	    </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Թ��</span></td>
    </tr>	
	<%if(rent_st.equals("1")){%>
	<tr>
	    <td class=line2></td>
	</tr>				
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="3%" rowspan="5" class='title'>��<br>��<br>��<br>��<br>��<br>��<br>��</td>
                    <td width="10%" class='title'>����Ƚ��</td>
                    <td width="20%">&nbsp;<%=fee.getFee_pay_tm()%>ȸ </td>
                    <td width="10%" class='title'>��������</td>
                    <td width="20%">&nbsp;<%if(fee.getFee_est_day().equals("98")){%>�뿩������<%}else{%>�ſ�<%if(fee.getFee_est_day().equals("99")){%> ���� <%}else{%><%=fee.getFee_est_day()%>��<%}%><%}%></td>
                    <td width="10%" class='title'>���ԱⰣ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>~<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%></td>
                </tr>		  		  		  
                <tr>
                    <td width="10%" class='title'>���ݱ���</td>
                    <td width="20%">&nbsp;<%String fee_sh = fee.getFee_sh();%><%if(fee_sh.equals("0")){%>�ĺ�<%}else if(fee_sh.equals("1")){%>����<%}%></td>
                    <td width="10%" class='title'>���ι��</td>
                    <td colspan="3">&nbsp;<%String fee_pay_st = fee.getFee_sh();%><%if(fee_pay_st.equals("1")){%>�ڵ���ü<%}else if(fee_pay_st.equals("2")){%>�������Ա�<%}else if(fee_pay_st.equals("3")){%>����<%}else if(fee_pay_st.equals("4")){%>����<%}else if(fee_pay_st.equals("5")){%>��Ÿ<%}%></td>
                </tr>		  		  		  
                <tr>
                    <td class='title'>��ġ����</td>
                    <td colspan="3">&nbsp;<%String def_st = fee.getDef_st();%><%if(def_st.equals("N")){%>����<%}else if(def_st.equals("Y")){%>����<%}%>
                    &nbsp;&nbsp;&nbsp;&nbsp;���� : <%=fee.getDef_remark()%></td>
                    <td class='title'>������</td>
                    <td>&nbsp;<%=c_db.getNameById(fee.getDef_sac_id(),"USER")%></td>
                </tr>
                <tr>
                    <td class='title'>�ڵ���ü</td>
                    <td colspan="5">
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
                <tr>
                    <td class='title'>�����Ա�</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(fee.getFee_bank(), "BANK")%></td>
                </tr>
            </table>
        </td>
    </tr>	
	<%}else{%>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>����Ƚ��</td>
                    <td width="20%">&nbsp;<%=fee.getFee_pay_tm()%>ȸ </td>
                    <td width="10%" class='title'>��������</td>
                    <td width="20%">&nbsp;<%if(fee.getFee_est_day().equals("98")){%>�뿩������<%}else{%>�ſ�<%if(fee.getFee_est_day().equals("99")){%> ���� <%}else{%><%=fee.getFee_est_day()%>��<%}%><%}%></td>
                    <td width="10%" class='title'>���ԱⰣ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>~<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%></td>
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
	sum_pp_amt();	
//-->
</script>
</body>
</html>
