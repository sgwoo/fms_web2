<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.cls.*"%>
<%@ page import="acar.user_mng.*, acar.res_search.*, tax.*, acar.doc_settle.*, acar.fee.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.end_cont.End_ContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
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
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//????????????
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//????????????
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//1. ???? ---------------------------
	
	//????????
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//????????
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//????????????
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//??????????????
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//????????????
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//????????
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//3. ????-----------------------------
	
	//??????????????(????????)
	int fee_size = af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//????????????
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//????????????
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//????????
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	Hashtable end_cont = ec_db.selectEnd_Cont(rent_mng_id, rent_l_cd);
	
	//????????????
	Vector rtn = af_db.getFeeRtnList(rent_mng_id, rent_l_cd, ext_fee.getRent_st());
	int rtn_size = rtn.size();
	
	//????????
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//????????
	FeeImBean im = af_db.getFeeIm(doc.getDoc_id());
	
	//????????????
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	
	//??????????
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	long total_amt 	= 0;
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

	
	//??????
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'lc_im_stat_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	
		
	//???? ????
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("?????? ?????? ????????."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//????/???? ????
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("?????? ?????? ????????."); return;}
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//?????????????? ????
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//??????????????????
	function FeeScdStop(){
		var fm = document.form1;
		window.open("about:blank", "ScdStopList", "left=50, top=50, width=750, height=550, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_stoplist.jsp";
		fm.target = "ScdStopList";
		fm.submit();
	}
	
	//?????? ???? ?????????? ????
	function clientFeeReqDt(client_id){
		window.open("/fms2/con_fee/client_feereqdt.jsp?client_id="+client_id, "clientFeeReqDt", "left=100, top=100, width=900, height=700, scrollbars=yes");
	}	
		
	//??????????????
	function FeeScdCngList(){
		var fm = document.form1;
		window.open("about:blank", "ScdCngList", "left=50, top=50, width=800, height=500, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_cnglist.jsp";
		fm.target = "ScdCngList";
		fm.submit();	
	}	
		
	//????????
	function cng_schedule(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD", "left=50, top=50, width=650, height=500, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "/fms2/con_fee/fee_scd_u_cngscd.jsp";
		fm.target = "CNGSCD";
		fm.submit();
	}		
	//????????
	function cng_schedule2(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD2", "left=50, top=50, width=650, height=400, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "/fms2/con_fee/fee_scd_u_cngscd2.jsp";
		fm.target = "CNGSCD2";
		fm.submit();
	}	
	//????????-????????????????????
	function cng_schedule3(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD3", "left=50, top=50, width=650, height=500, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "/fms2/con_fee/fee_scd_u_cngscd3.jsp";
		fm.target = "CNGSCD3";
		fm.submit();
	}		
	//????????-????????????????
	function cng_schedule4(rent_seq, rent_st, idx, cng_st)
	{
		var fm = document.form1;
		window.open("about:blank", "CNGSCD4", "left=50, top=50, width=950, height=300, scrollbars=yes");				
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.idx.value = idx;
		fm.cng_st.value = cng_st;		
		fm.action = "/fms2/con_fee/fee_scd_u_cngscd4.jsp";
		fm.target = "CNGSCD4";
		fm.submit();
	}			
	//???????? ????
	function tm_update(idx, rent_seq, rent_st, fee_tm, tm_st1, tm_st2){
		var fm = document.form1;
		window.open("about:blank", "SCDUPD", "left=50, top=50, width=750, height=600, scrollbars=yes");				
		fm.idx.value = idx;
		fm.rent_st.value = rent_st;
		fm.rent_seq.value = rent_seq;		
		fm.fee_tm.value = fee_tm;
		fm.tm_st1.value = tm_st1;
		fm.tm_st2.value = tm_st2;		
		fm.action = "/fms2/con_fee/fee_scd_u_tm.jsp";
		fm.target = "SCDUPD";
		fm.submit();
	}	
	//???? ????
	function dt_update(fee_est_dt){
		var fm = document.form1;
		window.open("about:blank", "SCDDTUPD", "left=50, top=50, width=1000, height=800, scrollbars=yes");				
		fm.s_fee_est_dt.value = fee_est_dt;
		fm.action = "/fms2/con_fee/fee_scd_u_client_dt.jsp";
		fm.target = "SCDDTUPD";
		fm.submit();
	}		
			
	//???????? ????
	function ScdfeeSet()
	{
		var fm = document.form1;
		
		if(toInt(fm.add_tm.value) > 5)	{ alert('?????????? 5?????? ???????? ?????? ?? ????????.'); 	fm.add_tm.focus(); 		return; }
		
		if(fm.rent_start_dt.value != '' && fm.add_tm.value != ''){
			fm.action = "/fms2/con_fee/fee_scd_set_nodisplay.jsp";
			fm.target = "i_no";
			fm.submit();
		}
	}			
	
	//?????????? ???? ??????????
	function display_rtn(){
		var fm = document.form1;		
		if(fm.rtn_st.checked == true){ 					
			tr_rtn.style.display = '';		
		}else{											
			tr_rtn.style.display = 'none';							
		}	
	}
	
			
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;

		if(confirm('?????????????????')){	
			fm.action='lc_im_doc_sanction.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
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
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>    
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 			value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 			value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"	 	value="<%=ext_fee.getRent_st()%>">
  <input type='hidden' name="from_page" 	value="/fms2/lc_rent/lc_im_doc_u.jsp">             
  <input type='hidden' name="firm_nm"	 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name='client_id' 	value='<%=client.getClient_id()%>'>  
<input type='hidden' name='idx' value=''>
<input type='hidden' name='cng_st' value=''>
<input type='hidden' name='tm_st1' value=''>
<input type='hidden' name='tm_st2' value=''>
<input type='hidden' name='fee_tm' value=''>
<input type='hidden' name='rent_seq' value=''>
<input type='hidden' name='s_fee_est_dt' value=''>
<input type='hidden' name="doc_bit" value="">  
<input type='hidden' name="idx" value="">  
<input type='hidden' name="mode" value="">  

        
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>???????? > <span class=style5>????????????</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align="right"><%if(!mode.equals("view")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td></td>
	<tr> 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>????????</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>????/????</td>
                    <td width=10%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>????<%}else if(car_st.equals("2")){%>????<%}else if(car_st.equals("3")){%>????<%}else if(car_st.equals("5")){%>????????<%}%>
					&nbsp;<%String rent_way = ext_fee.getRent_way();%><%if(rent_way.equals("1")){%>??????<%}else if(rent_way.equals("3")){%>??????<%}%></td>
                    <td class=title width=10%>??????????</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>
                <tr>
                    <td class=title>????</td>
                    <td >&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="??????????"><%=client.getFirm_nm()%> <%=site.getR_site()%></a></td>
                    <td class=title>????????</td>
                    <td>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="??????????"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title>????</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(????????:<%=cm_bean.getJg_code()%>)</font>
        			</td>
                </tr>
				<%if(!cms.getCms_bank().equals("")){%>
                <tr>
                     <td class='title'>CMS</td>
                     <td colspan='5'>&nbsp;
						<b><%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%></b>
        			 	<%=cms.getCms_bank()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (???? <%=cms.getCms_day()%>??)
					 </td>                     
                </tr>							
        		<%}%>		
				<%if(!client.getEtc().equals("")){%>	 				
                <tr>
                     <td class='title'>???? ????????</td>
                     <td colspan='5'>&nbsp;<%=Util.htmlBR(client.getEtc())%></td>                     
                </tr>		
        		<%}%>						
				<%if(!String.valueOf(end_cont.get("RE_BUS_NM")).equals("") && !String.valueOf(end_cont.get("RE_BUS_NM")).equals("null")){%>				
                <tr>
                     <td class='title'>????????????</td>
                     <td colspan='5'>&nbsp;<%=end_cont.get("REG_DT")%> : [<%=end_cont.get("RE_BUS_NM")%>] <%=end_cont.get("CONTENT")%></td>                     
                </tr>	
				<%}%>						
                <tr>
                     <td class='title'>??????????????</td>
                     <td colspan='5'>&nbsp;
					  <%if(client.getPrint_st().equals("1")) 		out.println("????????");
                      	else if(client.getPrint_st().equals("2"))   out.println("<b><font color='#FF9933'>??????????</font></b>");
                      	else if(client.getPrint_st().equals("3")) 	out.println("<b><font color='#FF9933'>????????</font></b>");
                     	else if(client.getPrint_st().equals("4"))	out.println("<b><font color='#FF9933'>????????</font></b>");%>
						</td>                     
                </tr>					
            </table>
	    </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>???????? <%if(fee_size>1){%>????<%}%></span></td>	
	</tr>		
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
                <tr>
                    <td style="font-size : 8pt;" width="3%" class=title rowspan="2">????</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">????????</td>
                    <td style="font-size : 8pt;" width="6%" class=title rowspan="2">????????</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">??????????</td>
                    <td style="font-size : 8pt;" width="8%" class=title rowspan="2">??????????</td>
                    <td style="font-size : 8pt;" width="7%" class=title rowspan="2">????????</td>
                    <td style="font-size : 8pt;" width="9%" class=title rowspan="2">????????</td>
                    <td style="font-size : 8pt;" class=title colspan="2">??????</td>
                    <td style="font-size : 8pt;" width="10%" class=title rowspan="2">??????</td>
                    <td style="font-size : 8pt;" class=title colspan="2">??????????</td>
                    <td style="font-size : 8pt;" class=title colspan="2">????????</td>
                </tr>
                <tr>
                    <td style="font-size : 8pt;" width="10%" class=title>????</td>
                    <td style="font-size : 8pt;" width="3%" class=title>????</td>
                    <td style="font-size : 8pt;" width="10%" class=title>????</td>
                    <td style="font-size : 8pt;" width="3%" class=title>????</td>
                    <td style="font-size : 8pt;" width="10%" class=title>????</td>
                    <td style="font-size : 8pt;" width="3%" class=title>%</td>			
                </tr>
    		  <%for(int i=0; i<fee_size; i++){
    				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
    				if(!fees.getCon_mon().equals("")){%>	
                <tr>
                    <td style="font-size : 8pt;" align="center"><%=i+1%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getCon_mon()%>????</td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getRent_st().equals("1")){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>??&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>??&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>????<%}else if(fees.getGrt_suc_yn().equals("1")){%>????<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>??&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%if(fees.getIfee_s_amt()>0){%><%if(fees.getPere_r_mth()>0){%><%=fees.getPere_r_mth()%><%}else{%><%=fees.getIfee_s_amt()/fees.getFee_s_amt()%><%}%>??&nbsp;<%}%><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>??&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>????<%}else if(fees.getIfee_suc_yn().equals("1")){%>????<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>??&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%}}%>
            </table>
	    </td>
	</tr>
	<%if(!cls.getCls_st().equals("")){%>	
	<tr>
	    <td class=h></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>	
	</tr>	  		
    <tr>
        <td class=line2></td>
    </tr>  	 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
              <tr>
                <td width="13%" class=title>????????</td>
                <td width="37%">&nbsp;<%=cls.getCls_st()%></td>
                <td width="13%" class=title>????????</td>
                <td>&nbsp;<%=cls.getCls_dt()%></td>
              </tr>	
              <tr>
                <td class=title>????????</td>
                <td colspan="3">&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%></td>
              </tr>		    		  		    		  	    
            </table> 	
	    </td>
	</tr> 
	<%}%> 						
	<%if(im_vt_size>1){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>???????? ????</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">????</td>
                    <td class=title width="20%">????</td>			
                    <td class=title width="37%">????????</td>
                    <td class=title width="15%">??????</td>
                    <td class=title width="15%">??????</td>
                  </tr>
        		  <%	for(int i = 0 ; i < im_vt_size ; i++){
        					Hashtable im_ht = (Hashtable)im_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=im_ht.get("ADD_TM")%>????</td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("RENT_END_DT")))%></td>
                    <td align='center'><%=im_ht.get("USER_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(im_ht.get("REG_DT")))%></td>
                  </tr>
        		  <%	} %>
            </table>
        </td>
    </tr>		
	<%}%>	
    <tr>
        <td class=h></td>
    </tr>				
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>	
	</tr>	  	
    <tr>
        <td class=line2></td>
    </tr>		
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>????????</td>
                    <td>
                      &nbsp;<input type='text' size='3' name='add_tm' value='<%=im.getAdd_tm()%>' maxlength='2' class='whitetext'>??
					  </td>
                </tr>
                <tr>
                    <td class='title'>????????????</td>
                    <td>
					  &nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(im.getRent_start_dt())%>' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        			  ~
        			  <input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(im.getRent_end_dt())%>' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        			</td>
                </tr>	
				
            </table>
	    </td>
    </tr>		
	<tr>
	    <td class=h></td>
	</tr>	
<%	if(nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("????????",user_id) || doc.getUser_dt3().equals(user_id)){%> 	
<%		
		if(rtn_size == 0){
			Hashtable ht = new Hashtable();
			ht.put("FIRM_NM", client.getFirm_nm());
			ht.put("RTN_AMT", String.valueOf(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt()));
			rtn.add(ht);
			rtn_size = rtn.size();
		}
		for(int r = 0 ; r < rtn_size ; r++){
			Hashtable r_ht = (Hashtable)rtn.elementAt(r);
			if(rtn_size>1){%>	
	<tr>
	    <td colspan="2">&nbsp;</td>	
	</tr>	  			
	<tr>
	    <td colspan="2" align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
    	    	<tr><td class=line2></td></tr>
                <tr>
                    <td width='10%' class='title'>??????????</td>
                    <td width="24%">&nbsp;<%=r_ht.get("FIRM_NM")%></td>
                    <td width="10%" class='title'>????????</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(r_ht.get("RTN_AMT")))%>??&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>	
<%			}%>
<%			//??????????????-????
			Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", ext_fee.getRent_st(), "", "", rent_mng_id, rent_l_cd, base.getCar_mng_id(), "", String.valueOf(r+1));
			int fee_scd_size = fee_scd.size();
			if(fee_scd_size>0){%>  	
    <tr></tr><tr></tr>		
	<tr>
	    <td colspan="2" class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>	 
                <tr>
                    <td width='5%' rowspan="2" class='title'>????</td>
                    <td colspan="2" rowspan="2" class='title'>????????</td>
                    <td width="13%" rowspan="2" class='title'>????????</td>
                    <td width="5%" rowspan="2" class='title'>????<br>/????</td>
                    <td width="5%" rowspan="2" class='title'>????</td>
                    <td colspan="3" class='title'>??????</td>
                    <td colspan="2" class='title'>??????????</td>					
                    <td colspan="2" class='title'>??????</td>
                </tr>
                <tr>
                  <td width="8%" class='title'>??????????</td>
                  <td width="8%" class='title'>????????</td>
                  <td width="8%" class='title'>??????????</td>
                  <td width="8%" class='title'>????????</td>
                  <td width="8%" class='title'>????????</td>
                  <td width="8%" class='title'>????????</td>
                  <td width="8%" class='title'>????????</td>
                </tr>
        <%				total_amt = 0;
						for(int j = 0 ; j < fee_scd_size ; j++){
        					Hashtable ht = (Hashtable)fee_scd.elementAt(j);
							if(String.valueOf(ht.get("PAY_CNG_CAU")).equals("????????"+doc.getDoc_id())){
								total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("FEE_AMT")));%>
                <tr>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>>
					<%if(String.valueOf(ht.get("RC_YN")).equals("0")){%>
        		    <%=j+1%><a href="javascript:tm_update('<%=j%>', '<%=String.valueOf(r+1)%>', '<%=ht.get("RENT_ST")%>','<%=ht.get("FEE_TM")%>','<%=ht.get("TM_ST1")%>','<%=ht.get("TM_ST2")%>')"></a>
					<%}else{%>
					<%=j+1%>
					<%}%>
        		    </td>
                    <td width="8%" align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="8%" align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td align="right"  <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>??&nbsp;&nbsp;</td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=ht.get("BILL_YN")%>/<%if(String.valueOf(ht.get("RC_YN")).equals("0")) 			out.println("N");
                     				 	else if(String.valueOf(ht.get("RC_YN")).equals("1"))   	out.println("Y");%>
                    </td>
                    <td align="right"  <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=ht.get("DLY_DAYS")%>??&nbsp;</td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%><%if(String.valueOf(ht.get("ITEM_DT")).equals("")&&nm_db.getWorkAuthUser("????????",user_id)){%><a href="javascript:dt_update('<%=ht.get("FEE_EST_DT")%>')"></a>.<%}%></td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%></td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_EST_DT")))%></td>										
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>>
        		    <%if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
          		    <%}else{%>					
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%>
					<%}%>
        		    </td>
                    <td align="center" <%if(String.valueOf(ht.get("TM_ST2")).equals("3")){%>class="im"<%}%>>
        		    <%if(String.valueOf(ht.get("PRINT_DT")).equals("")){%>
        		    <%	if(AddUtil.parseInt(AddUtil.dateFormat("yyyyMMdd")) > AddUtil.parseInt(String.valueOf(ht.get("REG_DT")))){%>
        		    	<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
          		    <%	}else{%>
						<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
					<%	}%>
        		    <%}else{%>
        		    <%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%>
        		    <%}%>
        		    </td>
                </tr>
				<%			}%>
        <%				}%>
		        <tr>
				  <td class="title" colspan="3">????</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>??&nbsp;</td>
				  <td class="title" colspan="9"></td>				  
				</tr>		
            </table>
	    </td>
    </tr>

<%			}%>  
<%		}%>
<%	}%>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">????</td>
                    <td class=title width=15%>??????</td>
                    <td class=title width=15%><%=doc.getUser_nm1()%></td>
                    <td class=title width=15%><%=doc.getUser_nm2()%></td>
                    <td class=title width=15%>-<%//=doc.getUser_nm3()%></td>
                    <td class=title width=15%>-<%//=doc.getUser_nm4()%></td>
                    <td class=title width=15%>-<%//=doc.getUser_nm5()%></td>			
        	    </tr>	
                <tr> 
                    <td align="center" style='height:44'><%=user_bean.getBr_nm()%></td>
                    <td align="center"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></td>
                    <td align="center"><!--????????--><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>        			
        			</td>
                    <td align="center"><!--??????????--><!--<%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>-->        			  
        			</td>
                    <td align="center"></td>
                    <td align="center"></td>			
        	    </tr>	
    		</table>
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
