<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.cont.*, acar.client.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<jsp:useBean id="atp_db" class="acar.kakao.AlimTemplateDatabase" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	
	String white = "";
	String disabled = "";
	if(cmd.equals("")){
		white = "white";
		disabled = "disabled";
	}
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
		
	EstiDatabase e_db = EstiDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	e_bean = e_db.getEstimateCase(est_id);
	
	String a_a = e_bean.getA_a().substring(0,1);
	String rent_way = e_bean.getA_a().substring(1);
	String a_b = e_bean.getA_b();
	
	
	//CAR_NM : ????????
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean2 = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String a_e = cm_bean2.getS_st();
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
	//????????
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 			= String.valueOf(ht.get("S_ST"));
	String jg_code 			= String.valueOf(ht.get("JG_CODE"));
	String car_no 			= String.valueOf(ht.get("CAR_NO"));
	String car_name			= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	String secondhand_dt 	= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 		= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 	= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 		= String.valueOf(ht.get("OPT"));
	String colo		 		= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int tax_dc_amt 		= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));
	if(today_dist.equals(""))	today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	
	if(e_bean.getCar_amt()==0){
		e_bean.setCar_amt(car_amt);
		e_bean.setOpt_amt(opt_amt);
		e_bean.setCol_amt(clr_amt);
	}
	
	String stat = "";
	if(e_bean.getEst_st().equals("3") && car_amt == 0) stat = "????????????";
	if(e_bean.getEst_st().equals("3") && AddUtil.parseInt((String)ht.get("O_L")) == 0) stat = "????????????";
	
	//???? ????????
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	int sh_car_amt			= AddUtil.parseInt((String)sh_var.get("SH_CAR_AMT"));
	int dlv_car_amt			= AddUtil.parseInt((String)sh_var.get("DLV_CAR_AMT"));
	
	sh_car_amt 	= e_bean.getO_1();
	dlv_car_amt = car_amt+opt_amt+clr_amt-e_bean.getO_1();	
	
	
	
	//????????
	em_bean = e_db.getEstiCommVarCase(a_a, "");
	
	//?????????? ??????
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	//??????????
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll_Esti(e_bean.getCar_comp_id());
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* ???? ????:?????????? */
	int good_size = goods.length;
	
	//?????? ??????
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	String u_nm ="";
	String u_mt ="";
	String u_ht ="";
	
	UserMngDatabase umdb = UserMngDatabase.getInstance();
	
	UsersBean user_bean = umdb.getUsersBean(e_bean.getReg_id());
	
	u_nm = user_bean.getUser_nm();
	u_mt = user_bean.getUser_m_tel();
	u_ht = user_bean.getHot_tel();
	
	//????????????
	ContBaseBean base = a_db.getCont(e_bean.getRent_mng_id(), e_bean.getRent_l_cd());
	
	//??????????
	Vector car_mgrs = a_db.getCarMgrListNew(e_bean.getRent_mng_id(), e_bean.getRent_l_cd(), "Y");
	int mgr_size = car_mgrs.size();
	
	//????????
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//????????????
	String send_msg = "";
	
	ArrayList<String> sendList = new ArrayList<String>();
	
	sendList.add(e_bean.getEst_nm());
	sendList.add("????");
	sendList.add(u_nm);
	sendList.add(u_mt);
	
	AlimTemplateBean sendTemplateBean = atp_db.selectTemplate("acar0072");
	String send_content_temp = sendTemplateBean.getContent();
	String send_content = sendTemplateBean.getContent();
  	for (String send : sendList) {
  		send_content = send_content.replaceFirst("\\#\\{.*?\\}", send);
	}
  	
  	send_msg = send_content;
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style>
.over_auto {
	overflow: auto !important;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//????????????
	function CustUpate(){
		var fm = document.form1;
		if(!confirm('?????????? ?????????????????')){	return; }	
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}	
	
	//????????
	function go_list(){
		location='esti_sh_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%= esti_m %>&esti_m_dt=<%= esti_m_dt %>&esti_m_s_dt=<%= esti_m_s_dt %>&esti_m_e_dt=<%= esti_m_e_dt %>';
	}

	
	//?????? ????????
	function EstiReg(){
		var fm = document.form1;
		fm.action = '/agent/secondhand/secondhand_detail_frame.jsp';
		fm.target = "d_content";
		fm.submit();
	}
	
	//????????????
	function open_mail(){
		var SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&est_email=<%=e_bean.getEst_email()%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms";	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=600, scrollbars=no, status=yes");
	}	
	
	//??????????
	function EstiView(){
		var SUBWIN="/acar/secondhand_hp/estimate_fms.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms";					
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");				
	}
		
	//???????? ??????????
	function esti_result_sms(){
		var fm = document.form1;
		
		if(fm.est_tel.value != '' && fm.est_m_tel.value == ''){ 	fm.est_m_tel.value = fm.est_tel.value }		
		
		if(fm.est_m_tel.value == ''){ 	alert('?????????? ????????????'); 		return; }		
		
		fm.cmd.value = 'result_sms';
		
		if(!confirm('?????????? ?????????????????')){	return; }	
		
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();
	}
	
	//???????? ???? ???????? ??????????
	function select_esti_result_sms(){
		var fm = document.form1;
						
		if(fm.est_tel.value != '' && fm.est_m_tel.value == ''){ 	fm.est_m_tel.value = fm.est_tel.value }		
		
		if(fm.est_m_tel.value == ''){ 	alert('?????????? ????????????'); 		return; }		
				
		fm.cmd.value = 'result_select_sms_wap';
		
		if(!confirm('?? ?????? ?????????? ?????????????????')){	return; }	
		
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';							
		fm.submit();	
	}			
	
	//???????????? reload
	function reloadTemplateContent() {
		var customer_name = "<%=e_bean.getEst_nm()%>";
		var esti_send_way = $("select[name=sms_cont2]").val();
		var manager_name = "<%=u_nm%>";
		var manager_phone = "<%=u_mt%>";
		
		var reg = /\#\{(.*?)\}/g;
	    var idx = 1;
	    var searchFields = new Object();
	    
	    searchFields.customer_name = customer_name;
	    searchFields.esti_send_way = esti_send_way;
	    searchFields.manager_name = manager_name;
	    searchFields.manager_phone = manager_phone;
	     
	    JSON.stringify(searchFields);
	    
	 	var replace_send_content_temp = $("#send_content_temp").val();
	 	var newLine = String.fromCharCode(13, 10);
	 	var replace_send_content = replace_send_content_temp.replace(/\\n/g, newLine);
	 	
	    var empText = replace_send_content.replace(reg, function(match, p1, offset) {
	        var val = searchFields[p1];
	        /*
	        if (val == undefined || val == "") {
	            val = p1;
	        }
	        */        
	        return val;
	    });
	    
	    $("#alim-textarea").val(empText);
	}
	
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="../car_mst/car_mst_null.jsp" name="form2" method="post">
    <input type="hidden" name="sel" value="">
    <input type="hidden" name="car_comp_id" value="">
    <input type="hidden" name="code" value="">
    <input type="hidden" name="mode" value="">
  </form>
  <form action="./esti_mng_u_a.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
  <input type="hidden" name="gubun5" value="<%=gubun5%>">
  <input type="hidden" name="gubun6" value="<%=gubun6%>">  
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="esti_m" value="<%=esti_m%>">
    <input type="hidden" name="esti_m_dt" value="<%=esti_m_dt%>">
    <input type="hidden" name="esti_m_s_dt" value="<%=esti_m_s_dt%>">
    <input type="hidden" name="esti_m_e_dt" value="<%=esti_m_e_dt%>">
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">	
    <input type="hidden" name="cmd" value="<%=cmd%>">
    <input type="hidden" name="s_st" value="">
    <input type="hidden" name="a_e" value="">
	<input type="hidden" name="udt_st" value="<%=e_bean.getUdt_st()%>">
	<input type="hidden" name="spr_yn" value="<%=e_bean.getSpr_yn()%>">
	<input type="hidden" name="set_code" value="">	
	<input type="hidden" name="from_page" value="esti_sh_mng_u.jsp">	
	<input type="hidden" name="u_nm" value="<%=u_nm%>">
	<input type="hidden" name="u_mt" value="<%=u_mt%>">
	<input type="hidden" name="u_ht" value="<%=u_ht%>">
	<input type="hidden" name="dlv_car_amt" value="<%=dlv_car_amt%>">
	
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > ?????????? > <span class=style5>????????????????(<%=est_id%>)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
        <td align="right">
        <a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>????/????</td>
                    <td width=19%> 
                        &nbsp;<input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="27" class=text style='IME-MODE: active'>
						
                  </td>
                    <td class=title width=13%>??????/????????</td>
                    <td width=14%> 
                        &nbsp;<input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=text>
                    </td>
                    <td class=title width=10%>????????</td>
                    <td width=12%> 
                        &nbsp;<input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="12" class=text>
                    </td>
                    <td class=title width=10%>FAX</td>
                    <td width=12%> 
                        &nbsp;<input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="12" class=text>
                    </td>
                </tr>
                <tr>				
                    <td class=title>??????</td>
                    <td colspan="7">
                    	&nbsp;<input type="text" name="est_email" value="<%=e_bean.getEst_email()%>" size="50" class=text style='IME-MODE: inactive'>
                      </td>
                </tr>					  
                <tr>				
                    <td class=title>????????</td>
                    <td colspan="7">&nbsp;<input type="radio" name="doc_type" value="1" <% if(e_bean.getDoc_type().equals("1")||e_bean.getDoc_type().equals("")) out.print("checked"); %>>
                      ????????
					  <input type="radio" name="doc_type" value="2" <% if(e_bean.getDoc_type().equals("2")) out.print("checked"); %>>
                      ?????????? 
					  <input type="radio" name="doc_type" value="3" <% if(e_bean.getDoc_type().equals("3")) out.print("checked"); %>>
                      ???? 					  
                      </td>
                </tr>					  
                <tr>
                    <td class=title>????????????</td>
                    <td colspan="7">&nbsp;<input type="radio" name="vali_type" value="0" <% if(e_bean.getVali_type().equals("0")||e_bean.getVali_type().equals("")) out.print("checked"); %>>
                      ??????????(10??)
					  <input type="radio" name="vali_type" value="1" <% if(e_bean.getVali_type().equals("1")) out.print("checked"); %>>
                      ??????D/C ???? ?????? ???? 
					  <input type="radio" name="vali_type" value="2" <% if(e_bean.getVali_type().equals("2")) out.print("checked"); %>>
                      ?????????? 
                      </td>
                </tr>				
                <tr>
                    <td class=title>??????</td>
                    <td colspan="7">&nbsp;<b><% if(e_bean.getSpr_yn().equals("2")){%>??????????<% }else if(e_bean.getSpr_yn().equals("1")){%>????????<% }else if(e_bean.getSpr_yn().equals("0")){%>????????<% }else if(e_bean.getSpr_yn().equals("3")){%>????????<%}%></b>
                      </td>
                </tr>	
                <tr>
                    <td class=title>??????</td>
                    <td colspan="7">&nbsp;<select name='damdang_id' class=default>            
                        <option value="">??????</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        					%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(e_bean.getReg_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
                      </td>
                </tr>															
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
        <td align="right"><a href="javascript:CustUpate();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>??????</td>
                    <td colspan="2">&nbsp;<select name="car_comp_id" onChange="javascript:GetCarCode()" <%=disabled%>>
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(e_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>????</td>
                    <td colspan="2">&nbsp;<select name="code" <%=disabled%>>
                        <option value="">????</option>
                        <%for(int i=0; i<cm_r.length; i++){
        						        cm_bean = cm_r[i];%>
                        <option value="<%= cm_bean.getCode() %>" <%if(e_bean.getCar_cd().equals(cm_bean.getCode()))%>selected<%%>>[<%=cm_bean.getCar_cd()%>]<%=cm_bean.getCar_nm()%></option>
                        <%	}	%>
                      </select> 
					  (<%=cm_bean2.getJg_code()%>)
					  </td>
                </tr>
                <tr> 
                    <td class=title width=10%>????</td>
                    <td width=65%> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a> 
                      <%}%>
                      &nbsp;<input type="text" name="car_name" value="<%=cm_bean2.getCar_name()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="car_id" value="<%=e_bean.getCar_id()%>"> 
                      <input type="hidden" name="car_seq" value="<%=e_bean.getCar_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="car_amt" value="<%=AddUtil.parseDecimal(e_bean.getCar_amt())%>" size="15" class=<%=white%>num>
                      ??</td>
                </tr>
                <tr> 
                    <td class=title>????</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="opt" value="<%=e_bean.getOpt()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="opt_seq" value="<%=e_bean.getOpt_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="opt_amt" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>" size="15" class=<%=white%>num>
                      ??</td>
                </tr>
                <tr> 
                    <td class=title>????</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="col" value="<%=e_bean.getCol()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="col_seq" value="<%=e_bean.getCol_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="col_amt" value="<%=AddUtil.parseDecimal(e_bean.getCol_amt())%>" size="15" class=<%=white%>num>
                      ??</td>
                </tr>
                <tr> 
                    <td class=title>????????</td>
                    <td>&nbsp;?????????? : <%=AddUtil.ChangeDate2(init_reg_dt)%>&nbsp;&nbsp;&nbsp;&nbsp;???????? : <%= AddUtil.parseDecimal(e_bean.getToday_dist()) %> <%if(e_bean.getToday_dist()==0) out.println("*****");%> km
                    </td>
                    <td align="center"> -<input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(dlv_car_amt)%>" size="15" class=<%=white%>num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      ??</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">???????? (???????? : <%=car_no%>)</td>
                    <td align="center"><input type="text" name="o_1" value="<%=AddUtil.parseDecimal(e_bean.getO_1())%>" size="15" class=<%=white%>num>
                      ??</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td width=10% colspan="2" class=title>????????</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(e_bean.getReg_dt())%> </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>????????</td>
                    <td colspan="3">&nbsp;<select name="a_a" onChange="javascript:change_c(); opt_display(); GetVar();" <%=disabled%>>
                        <option value="">=?? ??=</option>
                        <%for(int i = 0 ; i < good_size ; i++){
        					CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' <%if(e_bean.getA_a().equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        <%}%>
                      </select> 
                      <!--<input type="text" name="reg_dt" value="<%=AddUtil.getDate()%>" class=text size="12" onBlur='javscript:this.value = ChangeDate(this.value);'>
                      ???????? -->
                    </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>????????</td>
                    <td colspan="3">&nbsp;<input type="text" name="a_b" value="<%=e_bean.getA_b()%>" size="2" class=<%=white%>text>????</td>
                </tr>				
                <tr> 
                    <td width="10%" rowspan="2" class=title>????</td>
                    <td width="8%" class=title>??????????</td>
                    <td colspan="3"> &nbsp;?????? 
                      <input type="text" name="ro_13" value="<%=e_bean.getRo_13()%>" size="4" class=<%=white%>text  onblur="javascript:compare(this)">
                      % <font color="#666666">(?????????? 
                      <input type="text" name="o_13" value="<%=e_bean.getO_13()%>" class=whitenum size="3">
                      % ?????? ????)</font> , ???????????? 
                      <input type="text" name="ro_13_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);' value="<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>">
                      ?? <font color="#666666">(???????? ??????)</font>
					  <a href="javascript:searchO13();"><img src=/acar/images/center/button_in_max.gif align=absmiddle border=0></a>
					  </td>
                </tr>
                <tr>
                  <td class=title>????????</td>
                  <td colspan="3">&nbsp;
				    <input type='radio' name="opt_chk" value='0' <%if(e_bean.getOpt_chk().equals("0")){%> checked <%}%>>
                      ??????
                      <input type='radio' name="opt_chk" value='1' <%if(e_bean.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		  ????
					</td>
                </tr>				
                <tr> 
                    <td rowspan="3" class=title>????</td>
                    <td class=title>??????<br>
                    </td>
                    <td colspan="3">&nbsp;?????? 
                      <input type="text" name="rg_8" value="<%=e_bean.getRg_8()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, ???????????? <font color="#666666"> 
                      <input type="text" name="rg_8_amt" value="<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      ?? (???????????? 
                      <input type="text" name="g_8" value="<%=em_bean.getG_8()%>" class=whitenum size="3">
                      % ???????? ????) </font> </td>
                </tr>
                <tr> 
                    <td class=title>??????<br>
                    </td>
                    <td colspan="3">&nbsp;?????? 
                      <input type="text" name="pp_per" value="<%=e_bean.getPp_per()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, ????????????<font color="#666666">&nbsp;</font> <input type="text" name="pp_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      ?? </td>
                </tr>
                <tr id="tr_ifee" style="display:''"> 
                    <td class=title>??????????</td>
                    <td colspan="3">&nbsp;<font color="#666666"> 
                    <input type="checkbox" name="pp_st" value="1" <%if(e_bean.getPp_st().equals("1"))%> checked<%%> <%=disabled%>>
                    <input type="text" name="g_10" class=<%=white%>num size="2" value="<%=e_bean.getG_10()%>">
                    ?????? ?????? ???? </font></td>
                </tr>
                 <tr> 
                    <td rowspan="3" class=title>????</td>
                    <td class=title>????,????</td>
                    <td >&nbsp;                      <select name="ins_dj"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_dj().equals("1"))%>selected<%%>>5??????/5??????</option>
                        <option value="2" <%if(e_bean.getIns_dj().equals("2"))%>selected<%%>>1????/1????</option>
                        <option value="4" <%if(e_bean.getIns_dj().equals("4"))%>selected<%%>>2????/1????</option>
                    </select> </td>
                    <!--
                    <td class=title width=11%>??????????</td>
                    <td>&nbsp;<select name="ins_good" <%=disabled%>>
                        <option value="0" <%if(e_bean.getIns_good().equals("0"))%>selected<%%>>??????</option>
                        <option value="1" <%if(e_bean.getIns_good().equals("1"))%>selected<%%>>????</option>
                      </select> </td>
                      -->
                      <td class=title width='11%'>??????????</td>
                    <td> 
                      &nbsp;<select name="insurant"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getInsurant().equals("1"))%>selected<%%>>????????</option>
                            <!--<option value="2" <%if(e_bean.getInsurant().equals("2"))%>selected<%%>>????</option>-->
                          </select>
                    </td>	
                </tr>
                <tr>
                  <td class=title>??????????</td> 
                    <td >&nbsp;                      <select name="ins_age"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_age().equals("1"))%>selected<%%>>??26??????</option>
						<option value="3" <%if(e_bean.getIns_age().equals("3"))%>selected<%%>>??24??????</option>
                        <option value="2" <%if(e_bean.getIns_age().equals("2"))%>selected<%%>>??21??????</option>
                    </select> </td>
                    <td class=title width='11%'>????????</td>
                    <td> 
                      &nbsp;<select name="ins_per"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getIns_per().equals("1"))%>selected<%%>>????????(????????)</option>
                            <option value="2" <%if(e_bean.getIns_per().equals("2"))%>selected<%%>>????(??????????)</option>
                          </select>
                    </td>	
                </tr>
                <tr> 
                    <td class=title>????????</td>
                    <td>&nbsp;<select name="gi_yn"  <%=disabled%>>
                        <option value="0" <%if(e_bean.getGi_yn().equals("0"))%>selected<%%>>????</option>
                        <option value="1" <%if(e_bean.getGi_yn().equals("1"))%>selected<%%>>????</option>
                      </select> </td>
                    <td class=title>??????????</td>
                    <td>&nbsp;<input type="text" name="car_ja" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>					  
                </tr>
               <tr> 
                    <td rowspan="3" class=title>????<br> </td>
                    <td class=title>????????</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean.getA_h())%></td>
                    <td class=title>??????????</td>
                    <td>&nbsp;<select name="f_udt_st"  <%=disabled%> >
                        <option value="">=?? ??=</option>
                        <option value="1" <%if(e_bean.getUdt_st().equals("1"))%>selected<%%>>????????</option>
                        <option value="2" <%if(e_bean.getUdt_st().equals("2"))%>selected<%%>>????????</option>
                        <option value="3" <%if(e_bean.getUdt_st().equals("3"))%>selected<%%>>????????</option>
                        <option value="4" <%if(e_bean.getUdt_st().equals("4"))%>selected<%%>>????</option>
                      </select> </td>					  
                </tr>
                <tr> 
                    <td class=title>??????D/C</td>
                    <td>&nbsp;???????? 
                      <input type="text" name="fee_dc_per" value="<%=e_bean.getFee_dc_per()%>" size="4" class=<%=white%>text>
                      %</td>
					<td class=title>????????</td>
                    <td>&nbsp;?????? 
                      <input type="text" name="o_11" value="<%=e_bean.getO_11()%>" size="4" class=<%=white%>text>
                      %</td>  
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=7% rowspan="2">&nbsp;</td>
                    <td class=title rowspan="2" width=13%>??????????</td>
                    <td class=title colspan="4">??????????</td>
                </tr>
                <tr> 
                    <td class=title width=13%>??????</td>
                    <td class=title width=13%>??????</td>
                    <td class=title width=14%>??????????</td>
                    <td class=title >??</td>
                </tr>
                <tr> 
                    <td class=title>??????</td>
                    <td align="center"> <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="gtr_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="pp_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="ifee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class=title>??????<br> </td>
                    <td align="center"> <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> -</td>
                    <td align="center"> <input type="text" name="pp_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="ifee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class=title>??</td>
                    <td align="center"> <input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="t_gtr_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="t_pp_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <input type="text" name="t_ifee_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td align="center"> <font color="#666666"> 
                      <input type="text" name="tot_p_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </font></td>
                </tr>
                <tr> 
                    <td class=title colspan="2">???????? ???? ????????</td>
                    <td colspan="4">
                      &nbsp;<font color="#666666"><input type="text" name="tm" value="<%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>" class=<%=white%>num size="2">
                      </font>??</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">???????????????? </td>
                    <td>&nbsp;<input type="text" name="gi_amt" value="<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                    <td class=title>??????????</td>
                    <td colspan="2">&nbsp;<input type="text" name="gi_fee" value="<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ?? </td>
                </tr>
                <tr> 
                    <td class=title colspan="2">??????????????</td>
                    <td colspan="4">&nbsp;???????? ???????????? 
                      <input type="text" name="cls_per" value="<%=e_bean.getCls_per()%>" size="4" class=<%=white%>text>
                      %</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr> 
        <td align=right colspan="2">&nbsp; </td>
    </tr>
    <tr> 
        <td align=center colspan="2"> 
          <a href="javascript:EstiReg();" title='?????????? ???? ????'><img src=/acar/images/center/button_again_gj.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
          <a href="javascript:open_mail()" title='????????????'><img src=/acar/images/center/button_send_mail.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
    	  <a href="javascript:EstiView()" title='??????????'><img src=/acar/images/center/button_est_see.gif align=absmiddle border=0></a> 
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2">
        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>?????????? ????</span>
        	&nbsp;&nbsp;* ?????? ?????? ???????? ???? ?????????? ???????? ?????? ?????????? ???????? ??????????.
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <%
		String url1 = "http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms.jsp?est_id="+e_bean.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms";
	%> 
    
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title>????????</td>
					<td>&nbsp;
						<select name="s_destphone" onchange="javascript:document.form1.est_m_tel.value=this.value;">
							<option value="" selected>????</option>
	        				<%if(!client.getM_tel().equals("")){%>
	        				<option value="<%=client.getM_tel()%>">[??&nbsp;&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;??] <%=client.getM_tel()%> <%=client.getClient_nm()%></option>
	        				<%}%>
	        				<%if(!client.getCon_agnt_m_tel().equals("")){%>
	        				<option value="<%=client.getCon_agnt_m_tel()%>">[??????????] <%=client.getCon_agnt_m_tel()%> <%=client.getCon_agnt_nm()%></option>
	        				<%}%>
	        				<%for(int i = 0 ; i < mgr_size ; i++){
	        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
	        					if(!mgr.getMgr_m_tel().equals("")){%>
	        					<option value="<%=mgr.getMgr_m_tel()%>" >[<%=mgr.getMgr_st()%>] <%=mgr.getMgr_m_tel()%> <%=mgr.getMgr_nm()%> <%=mgr.getMgr_title()%></option>
	        				<%}}%>
	        				<%if (!e_bean.getEst_tel().equals("")) {%>
	        					<option value="<%=e_bean.getEst_tel()%>" selected>[???? ??????????] <%=e_bean.getEst_tel()%></option>
	        				<%}%>
        			  	</select>
        			  	&nbsp;&nbsp;
        			  	???? : <input type="text" name="est_m_tel" value="<%=e_bean.getEst_tel()%>" size="20" class=text>
						<!-- <input type="text" name="est_m_tel" value="" size="20" class=text> -->
					</td>
				</tr>			
                <tr>
                  	<td width="10%" class=title>????/???????? ??????</td>
                  	<td width="90%">&nbsp;
				  		<%-- <input type="text" name="sms_cont1" value="<%=e_bean.getEst_nm()%> ?????????? ???????? ????????" size="70" class=whitetext readOnly>
						<br>
						&nbsp;
						<select name='sms_cont2'>            
	                        <option value="">????</option>					
	                        <option value="????" selected>????</option>
	                        <option value="????">????</option>
						</select>	
						<input type="text" name="sms_cont3" value="?? ???????? ???? ????????. ?????? ???? ?????? ???????? ??????????. ???????? <%=u_nm%> <%=u_mt%> ??????. (??)????????" size="120" class=whitetext readOnly> --%>
						?????? ???? ???? :&nbsp;
                  		<select name='sms_cont2' id="send_sms_cont2" onchange="reloadTemplateContent();">            
	                        <option value="">????</option>					
	                        <option value="????" selected>????</option>
	                        <option value="????">????</option>
						</select><br><br>&nbsp;
						<textarea id="send_content_temp" style="display: none;"><%=send_content_temp%></textarea>						
						<textarea id="alim-textarea" rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=send_msg%></textarea>
							
						<!-- &nbsp;<a href="javascript:esti_result_sms();" title='??????????'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a> -->				
				  	</td>
                </tr>
			</table>
		</td>
	</tr>
	<tr>
        <td colspan="2" align="right">
        	<a href="javascript:esti_result_sms();" title='??????????'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
        <td class="h" colspan="2"></td>
    </tr>
	<tr>                
		<td class=line colspan="2"> 
			<table border="0" cellspacing="1" width=100%>
                <tr>
                  	<td width="10%" class=title>
                  		<input type="checkbox" name="ch_mms_id" value="<%=e_bean.getEst_id()%>" checked>???? ??????
                  	</td>
                  	<td width="90%">&nbsp;
                  		<%
							String s_a_a = "";
							String s_rent_way = "";
							if (a_a.equals("1")) {
								s_a_a = "????"; 
							} else {
								s_a_a = "????????";
							}
							
							if (rent_way.equals("1")) {
								s_rent_way = "??????(????????)"; 
							} else {
								s_rent_way = "??????";
							}
							
							//???????????? ??????
							if (e_bean.getCtr_s_amt() > 0) {
								e_bean.setFee_s_amt(e_bean.getCtr_s_amt());
								e_bean.setFee_v_amt(e_bean.getCtr_v_amt());
							}
                  		
							String msg = "";
							
							ArrayList<String> fieldList = new ArrayList<String>();
							
							fieldList.add("[??????]"+car_no+" "+cm_bean2.getCar_nm());
							fieldList.add(AddUtil.parseDecimal(e_bean.getO_1()+dlv_car_amt));
							
							if (!init_reg_dt.equals("") && init_reg_dt.length() == 8){
								fieldList.add(AddUtil.getDate3(init_reg_dt).substring(0,9) + "?? " +AddUtil.parseDecimal(e_bean.getToday_dist()) + "km " + s_a_a);
							} else {
								fieldList.add(AddUtil.parseDecimal(e_bean.getToday_dist()) + "km " + s_a_a);
							}
							//fieldList.add(c_db.getNameByIdCode("0009", "", e_bean.getA_a()));
							//fieldList.add(s_a_a);
							fieldList.add(s_rent_way);
							
							fieldList.add(e_bean.getA_b());
							
							fieldList.add(AddUtil.parseDecimal(e_bean.getGtr_amt()));
							fieldList.add(String.valueOf(e_bean.getRg_8()));						
							fieldList.add(AddUtil.parseDecimal(e_bean.getAgree_dist()));
							fieldList.add(AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt()));
							fieldList.add(ShortenUrlGoogle.getShortenUrl(url1));
							fieldList.add(u_nm);
							fieldList.add(u_mt);
							
							AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
					    	String content = templateBean.getContent();
						  	for (String field : fieldList) {
					    		content = content.replaceFirst("\\#\\{.*?\\}", field);
					    	}
						  	
						  	msg = content;
                  		%>
					    <%-- <input type="text" name="wap_msg_body" value="???????? ???????? ????????. [??????]<%=car_no%> <%=cm_bean2.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean.getO_1()+dlv_car_amt)%>?? <%=AddUtil.getDate3(init_reg_dt).substring(0,9)%>?? <%= AddUtil.parseDecimal(e_bean.getToday_dist()) %>km <%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%><%if(e_bean.getA_a().equals("11") || e_bean.getA_a().equals("21")){%>(????????)<%}%> <%=e_bean.getA_b()%>???? ??????<%=e_bean.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>?? VAT????  ???????? <%=u_nm%> <%=u_mt%> ??????. (??)????????" size="151" class=text> --%>
					    <textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
					    <input type="hidden" name="a_url" value="<%=ShortenUrlGoogle.getShortenUrl(url1)%>">
					    <input type="hidden" name="a_car_name" value="[??????]<%=car_no%> <%=cm_bean2.getCar_nm()%>">
					    <input type="hidden" name="a_gubun1" value="<%if(!init_reg_dt.equals("") && init_reg_dt.length() == 8){%><%=AddUtil.getDate3(init_reg_dt).substring(0,9)%>??<%}%> <%= AddUtil.parseDecimal(e_bean.getToday_dist()) %>km <%=s_a_a%>">
					    <%-- <input type="hidden" name="a_gubun2" value="<%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%>"> --%>
					    <input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
					    
					    <!-- &nbsp;<a href="javascript:select_esti_result_sms();" title='??????????'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a> -->				
				  	</td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td colspan="2" align="right">
        	<a href="javascript:select_esti_result_sms();" title='??????????'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
        <td class="h" colspan="2"></td>
    </tr>	
    		
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>